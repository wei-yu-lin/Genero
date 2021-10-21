IMPORT FGL SECTABREF_DB
IMPORT FGL sys_toolbar

DEFINE disp_list TableRef_List

MAIN
CONNECT TO "yud221" AS "YUD"

CALL sys_TableRef()

DISCONNECT "YUD"
END MAIN

FUNCTION sys_TableRef()
    DEFINE form_tb sys_ConToolBar

    #CALL ui.Interface.loadStyles("sys_style")
    
    CLOSE WINDOW SCREEN
    OPEN WINDOW w1 WITH FORM "sys_TableRef"
    
    CALL form_tb.init(FALSE)
    CALL form_tb.setAttribute("_add", TRUE)
    CALL form_tb.setAttribute("_upd", TRUE)
    CALL form_tb.setAttribute("_del", TRUE)
    
    DIALOG ATTRIBUTE(UNBUFFERED)
        SUBDIALOG sectabref_dm
        SUBDIALOG prog_list_dm
        SUBDIALOG table_list_dm
        SUBDIALOG sys_combobox_dm
        
        BEFORE DIALOG
            CALL disp_list.init()
            CALL form_tb.setDialogPriv()
        ON ACTION _add
            CALL fun_Ins()
            IF NOT INT_FLAG THEN
                CALL disp_list.initBySys()
            END IF
        ON ACTION _upd
            CALL fun_Upd()
            IF NOT INT_FLAG THEN
                CALL disp_list.initBySys()
            END IF
        ON ACTION _del
            LET disp_list.forcus = disp_list.arr[DIALOG.getCurrentRow("sectabref_r")]
            CALL disp_list.forcus.del()
            CALL disp_list.initBySys()

        ON ACTION EXIT
            EXIT DIALOG
    END DIALOG

    CLOSE WINDOW w1
END FUNCTION

DIALOG sectabref_dm()
    DISPLAY ARRAY disp_list.arr TO sectabref_r.*
        BEFORE ROW
            LET disp_list.forcus = disp_list.arr[DIALOG.getCurrentRow("sectabref_r")]
            CALL disp_list.getProgList()
            CALL disp_list.getTalbeList()
    END DISPLAY
END DIALOG

DIALOG prog_list_dm()
    DISPLAY ARRAY disp_list.prog_list TO prog_ref_r.*
        BEFORE ROW
            LET disp_list.forcus.prog_name = disp_list.prog_list[DIALOG.getCurrentRow("prog_ref_r")].prog_name
            CALL disp_list.getTalbeListByProg()
    END DISPLAY
END DIALOG

DIALOG table_list_dm()
    DISPLAY ARRAY disp_list.table_list TO table_ref_r.*
        BEFORE ROW
            LET disp_list.forcus.table_ref = disp_list.table_list[DIALOG.getCurrentRow("table_ref_r")].table_ref
            CALL disp_list.getProgListByTable()
    END DISPLAY
END DIALOG

DIALOG sys_combobox_dm()
    DEFINE arg_sys CHAR(3)
    DEFINE cb_node ui.ComboBox
    DEFINE i, len INTEGER

    INPUT arg_sys FROM sys_cb_r.*
        BEFORE INPUT
            LET cb_node = ui.ComboBox.forName("sectabref.sys")
            CALL cb_node.clear()
            CALL disp_list.getSysList()

            LET len = disp_list.sys_list.getLength()
            CALL cb_node.addItem("all", "ALL")
            FOR i = 1 TO len
                CALL cb_node.addItem(disp_list.sys_list[i].sys, disp_list.sys_list[i].sys)
            END FOR
            
        ON CHANGE sys
            CALL disp_list.setCurrSys(arg_sys)
            CALL disp_list.initBySys()
            CALL disp_list.getProgList()
            CALL disp_list.getTalbeList()
    END INPUT
END DIALOG

PRIVATE FUNCTION fun_Ins()
    DEFINE ins_rec SECTABREF

    OPEN WINDOW winInsUpd_w WITH FORM "winInsUpd"
    INPUT ins_rec.* FROM winInsUpd_r.*

    IF NOT INT_FLAG THEN
        CALL ins_rec.ins()
    END IF
    CLOSE WINDOW winInsUpd_w
END FUNCTION

PRIVATE FUNCTION fun_Upd()
    DEFINE ins_rec SECTABREF

    OPEN WINDOW winInsUpd_w WITH FORM "winInsUpd"
    INPUT ins_rec.* FROM winInsUpd_r.* ATTRIBUTE(UNBUFFERED,WITHOUT DEFAULTS)
        BEFORE INPUT
            LET ins_rec = disp_list.forcus
    END INPUT

    IF NOT INT_FLAG THEN
        CALL ins_rec.ins()
    END IF
    CLOSE WINDOW winInsUpd_w
END FUNCTION