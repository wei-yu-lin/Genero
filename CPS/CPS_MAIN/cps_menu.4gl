SCHEMA rdbcps36
DEFINE dnd ui.DragDrop
TYPE t_pdo RECORD
    COIL_NUMBER LIKE ccaa030m.COIL_NUMBER,
    SCHEDULE_NUMBER LIKE ccaa030m.SCHEDULE_NUMBER,
    STEEL_GRADE LIKE ccaa030m.STEEL_GRADE,
    ACTUAL_WIDTH LIKE ccaa030m.ACTUAL_WIDTH,
    ACTUAL_THICKNESS LIKE ccaa030m.ACTUAL_THICKNESS,
    ACTUAL_WEIGHT LIKE ccaa030m.ACTUAL_WEIGHT
END RECORD
DEFINE options RECORD
    follow_tree SMALLINT,
    part_filter CHAR(1),
    last_row INTEGER
END RECORD

DEFINE havewhere, drop_index, i INTEGER
DEFINE drag_source STRING
DEFINE topPdi DYNAMIC ARRAY OF t_pdo
DEFINE downPdi DYNAMIC ARRAY OF t_pdo
DEFINE rec t_pdo
CONSTANT _await = "awaitPdi"
CONSTANT _confirm = "confirmPdi"

MAIN
    CLOSE WINDOW SCREEN
    OPEN WINDOW pdoPrograme WITH FORM "cps_menu"
    CONNECT TO "rdbcps36" AS "cps"
    SET CONNECTION "cps"

    CURRENT WINDOW IS pdoPrograme
    CALL read_pdo() RETURNING havewhere
    CALL bom_build()

END MAIN

FUNCTION read_pdo()
    DEFINE
        s_sql STRING,
        x INTEGER
    INITIALIZE topPdi TO NULL
    LET s_sql =
        "SELECT COIL_NUMBER,SCHEDULE_NUMBER,STEEL_GRADE,ACTUAL_WIDTH,ACTUAL_THICKNESS"
            || " FROM ccaa030m where STEEL_GRADE<>'' and ACTUAL_WIDTH>0"
            || " limit to 10 rows"

    LET havewhere = s_sql.getIndexOf("1=1", 1)
    PREPARE query_sql FROM s_sql
    DECLARE mast_cur1 SCROLL CURSOR FOR query_sql
    OPEN mast_cur1
    CALL topPdi.clear()
    LET x = 0
    FOREACH mast_cur1 INTO rec.*
        LET x = x + 1
        LET topPdi[x].* = rec.*
    END FOREACH
    FREE query_sql
    FREE mast_cur1
    RETURN havewhere
END FUNCTION

FUNCTION bom_build()
    DIALOG ATTRIBUTES(UNBUFFERED)
        DISPLAY ARRAY topPdi TO awaitPdi.*
            BEFORE ROW
                CALL DIALOG.setSelectionMode("awaitPdi", 1)
                CALL bom_dialog_setup(DIALOG)
            AFTER DISPLAY
            ON DRAG_START(dnd)
                LET drag_source = _await
            ON DRAG_FINISHED(dnd)
                INITIALIZE drag_source TO NULL
            ON DRAG_ENTER(dnd)
                IF drag_source IS NULL OR drag_source != _confirm THEN
                    CALL dnd.setOperation(NULL)
                END IF
            ON DROP(dnd)
                # from下面to上面
                LET drop_index = dnd.getLocationRow()
                FOR i = downPdi.getLength() TO 1 STEP -1
                    IF DIALOG.isRowSelected(_confirm, i) THEN
                        CALL DIALOG.insertRow(_await, drop_index)
                        CALL DIALOG.setSelectionRange(
                            _await, drop_index, drop_index, TRUE)
                        LET topPdi[drop_index].* = downPdi[i].*
                        CALL DIALOG.deleteRow(_confirm, i)
                    END IF
                END FOR
        END DISPLAY

        DISPLAY ARRAY downPdi TO confirmPdi.*
            BEFORE ROW
                CALL DIALOG.setSelectionMode("confirmPdi", 1)
                CALL bom_dialog_setup(DIALOG)
            AFTER DISPLAY
            ON DRAG_START(dnd)
                LET drag_source = _confirm
            ON DRAG_FINISHED(dnd)
                INITIALIZE drag_source TO NULL
            ON DRAG_ENTER(dnd)
                IF drag_source IS NULL OR drag_source != _await THEN
                    CALL dnd.setOperation(NULL)
                END IF
            ON DROP(dnd)
                # from上面to下面
                LET drop_index = dnd.getLocationRow()
                DISPLAY drop_index
                FOR i = topPdi.getLength() TO 1 STEP -1
                    IF DIALOG.isRowSelected(_await, i) THEN
                        CALL DIALOG.insertRow(_confirm, drop_index)
                        CALL DIALOG.setSelectionRange(
                            _confirm, drop_index, drop_index, TRUE)
                        LET downPdi[drop_index].* = topPdi[i].*
                        CALL DIALOG.deleteRow(_await, i)
                    END IF
                END FOR
        END DISPLAY
        BEFORE DIALOG
            CALL DIALOG.setSelectionMode(_await, 1)
            CALL DIALOG.setSelectionMode(_confirm, 1)
        AFTER DIALOG
        ON ACTION treeMoveUp
            CALL bomTreeMoveUp(DIALOG, DIALOG.getCurrentRow("awaitPdi"))
            CALL bom_dialog_setup(DIALOG)
        ON ACTION treeMoveDown
            CALL bomTreeMoveDown(DIALOG, DIALOG.getCurrentRow("awaitPdi"))
            CALL bom_dialog_setup(DIALOG)
        ON ACTION treeDelete
            CALL bomTreeDelete(DIALOG, DIALOG.getCurrentRow("awaitPdi"))
            CALL bom_dialog_setup(DIALOG)
        ON ACTION treeSelect
            CALL bomTreeSelect_DeSelect(DIALOG, _await, _confirm)
            CALL bom_dialog_setup(DIALOG)
        ON ACTION treeDeselect
            CALL bomTreeSelect_DeSelect(DIALOG, _confirm, _await)
            CALL bom_dialog_setup(DIALOG)
        ON ACTION close
            ACCEPT DIALOG
    END DIALOG
END FUNCTION

FUNCTION bom_dialog_setup(d)
    DEFINE d ui.Dialog
    DEFINE n, c, confirmRow INT
    LET n = d.getArrayLength("awaitPdi")
    LET c = d.getCurrentRow("awaitPdi")
    LET confirmRow = d.getCurrentRow("confirmPdi")
    IF c <= 0 THEN
        CALL d.setActionActive("treeBack", FALSE)
        CALL d.setActionActive("tree_append_child", FALSE)
        CALL d.setActionActive("treeMoveUp", FALSE)
        CALL d.setActionActive("treeMoveDown", FALSE)
        CALL d.setActionActive("treeSelect", FALSE)
        CALL d.setActionActive("treeDeselect", FALSE)
        CALL d.setActionActive("treeDelete", FALSE)
        CALL d.setActionActive("treeRequest", FALSE)
        CALL d.setActionActive("treePrint", FALSE)
        CALL d.setActionActive("treePdo", FALSE)
    ELSE
        CALL d.setActionActive("treeMoveUp", treeCanUp(d, c))
        CALL d.setActionActive("treeMoveDown", treeCanDown(d, c))
        CALL d.setActionActive("treeDelete", treeCanDelete(d, -1))
        CALL d.setActionActive("treeSelect", treeCanSelect(d, c))
        CALL d.setActionActive("treeDeselect", treeCanDeSelect(d, confirmRow))
    END IF
END FUNCTION

FUNCTION bomTreeMoveUp(d, c)
    DEFINE d ui.Dialog
    DEFINE c INT

    CALL d.insertRow("awaitPdi", c + 1)
    LET topPdi[c + 1].* = topPdi[c - 1].*
    LET topPdi[c - 1].* = topPdi[c].*
    LET topPdi[c].* = topPdi[c + 1].*
    CALL d.deleteRow("awaitPdi", c + 1)
    CALL d.setCurrentRow("awaitPdi", c - 1)
END FUNCTION

FUNCTION bomTreeMoveDown(d, c)
    DEFINE d ui.Dialog
    DEFINE c INT
    CALL d.insertRow("awaitPdi", c + 2)
    LET topPdi[c + 2].* = topPdi[c + 1].*
    LET topPdi[c + 1].* = topPdi[c].*
    LET topPdi[c].* = topPdi[c + 2].*
    CALL d.deleteRow("awaitPdi", c + 2)
    CALL d.setCurrentRow("awaitPdi", c + 1)
END FUNCTION

FUNCTION bomTreeDelete(d, c)
    DEFINE d ui.Dialog
    DEFINE c INT
    CALL d.deleteRow("awaitPdi", c)
END FUNCTION

FUNCTION bomTreeSelect_DeSelect(d, _from, _target)
    DEFINE d ui.Dialog
    DEFINE _from, _target STRING
    DEFINE idx, len, isSelected INT
    DEFINE targetArray DYNAMIC ARRAY OF t_pdo
    DEFINE fromArray DYNAMIC ARRAY OF t_pdo
    LET len = d.getArrayLength(_target) + 1
    IF _from == "awaitPdi" THEN
        LET targetArray = downPdi
        LET fromArray = topPdi
    ELSE
        LET targetArray = topPdi
        LET fromArray = downPdi
    END IF

    FOR idx = fromArray.getLength() TO 1 STEP -1
        IF d.isRowSelected(_from, idx) THEN
            LET isSelected = d.isRowSelected(_from, idx)
            CALL d.insertRow(_target, len)
            CALL d.setSelectionRange(_target, len, len, TRUE)
            LET targetArray[len].* = fromArray[idx].*
            CALL d.deleteRow(_from, idx)
            DISPLAY idx
            CALL d.setCurrentRow(_from,idx)
        END IF
    END FOR
    
    
END FUNCTION

FUNCTION treeCanUp(_dialog, currentRow)
    DEFINE _dialog ui.Dialog
    DEFINE currentRow INT
    IF currentRow < 2 THEN
        RETURN FALSE
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION treeCanDown(_dialog, currentRow)
    DEFINE _dialog ui.Dialog
    DEFINE currentRow INT
    IF currentRow == 0 THEN
        RETURN FALSE
    END IF
    IF currentRow == _dialog.getArrayLength("awaitPdi") THEN
        RETURN FALSE
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION treeCanDelete(_dialog, currentRow)
    DEFINE _dialog ui.Dialog
    DEFINE currentRow INT
    IF currentRow == -1 THEN
        LET currentRow = _dialog.getCurrentRow("awaitPdi")
    END IF
    IF currentRow <= 0 THEN
        RETURN FALSE
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION treeCanSelect(_dialog, currentRow)
    DEFINE _dialog ui.Dialog
    DEFINE currentRow INT
    IF currentRow == _dialog.getArrayLength("awaitPdi")THEN
        RETURN FALSE 
    END IF
    RETURN TRUE
END FUNCTION


FUNCTION treeCanDeSelect(_dialog, currentConfirmRow)
    DEFINE _dialog ui.Dialog
    DEFINE currentConfirmRow INT
    IF currentConfirmRow == _dialog.getArrayLength("confirmPdi")THEN
        RETURN FALSE 
    END IF
    RETURN TRUE
END FUNCTION
