SCHEMA rdbcps36
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

DEFINE
    havewhere INTEGER,
    ci INTEGER

DEFINE cap_pdo DYNAMIC ARRAY OF t_pdo
DEFINE rec t_pdo

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
    
    INITIALIZE cap_pdo TO NULL
    LET s_sql =
        "SELECT COIL_NUMBER,SCHEDULE_NUMBER,STEEL_GRADE,ACTUAL_WIDTH,ACTUAL_THICKNESS"
            || " FROM ccaa030m where STEEL_GRADE<>'' and ACTUAL_WIDTH>0"
            || " limit to 10 rows"

    LET havewhere = s_sql.getIndexOf("1=1", 1)
    PREPARE query_sql FROM s_sql
    DECLARE mast_cur1 SCROLL CURSOR FOR query_sql
    OPEN mast_cur1
    
    CALL cap_pdo.clear()
    LET x = 0
    FOREACH mast_cur1 INTO rec.*
        LET x = x + 1
        LET cap_pdo[x].* = rec.*
    END FOREACH

    FREE query_sql
    FREE mast_cur1
    RETURN havewhere
END FUNCTION

FUNCTION bom_build()
    DIALOG ATTRIBUTES(UNBUFFERED)
        DISPLAY ARRAY cap_pdo TO awaitPdi.*
            BEFORE ROW
                CALL DIALOG.setSelectionMode("awaitPdi",1)
                CALL bom_dialog_setup(DIALOG)
        END DISPLAY
        
    
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
            CALL bomTreeSelect(DIALOG) 
            CALL bom_dialog_setup(DIALOG)
        ON ACTION close
            ACCEPT DIALOG
    END DIALOG
END FUNCTION

FUNCTION bom_dialog_setup(d)
    DEFINE d ui.Dialog
    DEFINE n, c INT
    LET n = d.getArrayLength("awaitPdi")
    LET c = d.getCurrentRow("awaitPdi")
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
    END IF
END FUNCTION

FUNCTION bomTreeMoveUp(d, c)
    DEFINE d ui.Dialog
    DEFINE c INT

    CALL d.insertRow("awaitPdi", c + 1)
    LET cap_pdo[c + 1].* = cap_pdo[c - 1].*
    LET cap_pdo[c - 1].* = cap_pdo[c].*
    LET cap_pdo[c].* = cap_pdo[c + 1].*
    CALL d.deleteRow("awaitPdi", c + 1)
    CALL d.setCurrentRow("awaitPdi", c - 1)
END FUNCTION

FUNCTION bomTreeMoveDown(d,c)
    DEFINE d ui.Dialog
    DEFINE c INT
    CALL d.insertRow("awaitPdi", c + 2)
    LET cap_pdo[c + 2].* = cap_pdo[c + 1].*
    LET cap_pdo[c + 1].* = cap_pdo[c].*
    LET cap_pdo[c].* = cap_pdo[c + 2].*
    CALL d.deleteRow("awaitPdi", c + 2)
    CALL d.setCurrentRow("awaitPdi", c + 1)
END FUNCTION

FUNCTION bomTreeDelete(d,c)
    DEFINE d ui.Dialog
    DEFINE c INT
    CALL d.deleteRow("awaitPdi", c)
END FUNCTION

FUNCTION bomTreeSelect(d)
    DEFINE d ui.Dialog 
    #CALL d.setSelectionRange("awaitPdi",selected[1],selected[2],TRUE)
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
    IF currentRow <= 0 THEN RETURN FALSE END IF
    RETURN TRUE
END FUNCTION

FUNCTION treeCanSelect(_dialog, currentRow)
    DEFINE _dialog ui.Dialog
    DEFINE currentRow INT
   # IF _dialog.isRowSelected("awaitPdi",selected[1]) THEN
   #     RETURN FALSE
   # END IF
    RETURN TRUE
END FUNCTION