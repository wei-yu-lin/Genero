IMPORT util
IMPORT FGL CZFP210M_DB
IMPORT FGL CZFA030M_DB
IMPORT FGL CPSCR6_INC
IMPORT FGL CRM_INC
IMPORT FGL fgldialog
IMPORT FGL sys_toolbar

DEFINE focus_PDO CZFA030M_DB.CZFA030M
DEFINE form_tb sys_ConToolBar

DEFINE dispPDI CZFP210M_DB.CZFP210M_LIST
DEFINE dispCoilList CPSCR6_INC.COIL_LIST

FUNCTION CPSCR603()
    DEFINE next_work, pt, len,tb_count INTEGER
    DEFINE MainDialog ui.Dialog
    DEFINE upd_tmp CZFA030M_DB.CZFA030M
    
    #OPEN FORM CPSCR603_f FROM "CPSCR603"
    #DISPLAY FORM CPSCR603_f

    CALL form_tb.init(TRUE)
    CALL form_tb.setAttribute("_add", FALSE)
    CALL form_tb.setAttribute("_help", FALSE)
    CALL form_tb.getPriv("CPSCR603")
    
    CALL ui.Window.getCurrent().getForm().loadTopMenu("cr6sch01_topmenu")

    LET next_work = 0
    SET CONNECTION "CR2"
    SELECT COUNT(SCHD_COIL_NO) INTO tb_count FROM CZFP320M
    LET tb_count = tb_count - 1
    
    DIALOG ATTRIBUTE(UNBUFFERED)
        SUBDIALOG COIL_LIST_SCH03_dm -- 鋼捲列表(當前排程)
        SUBDIALOG PDOField_dm
        
        BEFORE DIALOG
            CALL form_tb.setDialogPriv()
            IF form_tb.priv.PQRY != 'N' OR form_tb.priv.PQRY IS NULL THEN
                #初始從排程抓n顆鋼捲顯示
                CALL dispCoilList.extendList("init", 5)
                #CALL dispPDI.updByCoilList(dispCoilList)
            END IF
            
            LET MainDialog = ui.Dialog.getCurrent()
            CALL setFieldsModSch03(false, MainDialog) -- PDO各欄位編輯disable
            CALL MainDialog.setActionActive("CPSCR603_save", FALSE) --PDO修改確認按鈕disable
            CALL MainDialog.setActionActive("CPSCR603_back", FALSE) --PDO修改取消按鈕disable
            
        ON ACTION CPSCR603_query ATTRIBUTE(TEXT="確認查詢", ACCELERATOR = "F1")
            CALL querySchdCoil()
            
        ON ACTION CPSCR603_prev -- 前一筆
            LET pt = arr_curr()-1
            IF arr_curr() <= 1 THEN
                CALL fgldialog.fgl_winMessage("ERROR","已到top!","stop")
            ELSE
                CALL DIALOG.setCurrentRow("COIL_LIST_SCH03_tb",pt)
                CALL dispPDO(dispCoilList.arr[pt].SCHD_COIL_NO)
            END IF
            
        ON ACTION CPSCR603_next -- 下一筆
            LET pt = arr_curr()+1
            LET len = dispCoilList.arr.getLength()
            IF arr_curr() == len THEN
                IF tb_count == arr_curr() THEN
                    CALL fgldialog.fgl_winMessage("ERROR","已到botton!","stop")
                ELSE
                    CALL dispCoilList.extendList("normal", 5)
                END IF
            ELSE
                CALL DIALOG.setCurrentRow("COIL_LIST_SCH03_tb",pt)
                CALL dispPDO(dispCoilList.arr[pt].SCHD_COIL_NO)
            END IF
            
        ON ACTION CPSCR603_first -- 第一筆
            CALL dispPDO(dispCoilList.arr[1].SCHD_COIL_NO)
            CALL DIALOG.setCurrentRow("COIL_LIST_SCH03_tb",1)
            
        ON ACTION CPSCR603_last -- 最後筆
            CALL dispCoilList.extendList("init", tb_count)
            CALL dispPDO(dispCoilList.arr[tb_count].SCHD_COIL_NO)
            CALL DIALOG.setCurrentRow("COIL_LIST_SCH03_tb",tb_count)
        #修改PDI
        ON ACTION CPSCR603_upd ATTRIBUTE(TEXT="修改PDO", ACCELERATOR = "F2")
            CALL setFieldsModSch03(true, MainDialog)
            INITIALIZE upd_tmp.* TO NULL
            CALL MainDialog.setActionActive("CPSCR603_save", TRUE)
            CALL MainDialog.setActionActive("CPSCR603_back", TRUE)
            CALL MainDialog.setActionActive("CPSCR603_upd", FALSE)
            
        ON ACTION CPSCR603_back -- 修改PDI->取消修改
            CALL setFieldsModSch03(false, MainDialog)
            CALL dispPDO(dispCoilList.arr[arr_curr()].SCHD_COIL_NO)
            
            CALL MainDialog.setActionActive("CPSCR603_upd", TRUE)
            CALL MainDialog.setActionActive("CPSCR603_save", FALSE)
            CALL MainDialog.setActionActive("CPSCR603_back", FALSE)

        ON ACTION CPSCR603_save -- 修改PDI->確認修改
            LET upd_tmp.* = focus_PDO.*
            LET upd_tmp.UPD_DATE = util.Datetime.format(CURRENT,"%Y%m%d")
            LET upd_tmp.UPD_TIME = util.Datetime.format(CURRENT,"%H%M%S")
            LET upd_tmp.USER_NAME = fgl_getenv("g_user_id")
            LET upd_tmp.PROG_NAME = "CPSCR602"
            
            CALL upd_tmp.updCZFA030M()
            LET focus_PDO.* = upd_tmp.*
            LET dispPDI.arr[arr_curr()].* = dispPDI.focus_PDI.*
            CALL setFieldsModSch03(false, MainDialog) 
            
            CALL MainDialog.setActionActive("CPSCR603_upd", TRUE)
            CALL MainDialog.setActionActive("CPSCR603_save", FALSE)
            CALL MainDialog.setActionActive("CPSCR603_back", FALSE)
            
        #刪除PDI
        ON ACTION CPSCR603_del ATTRIBUTE(TEXT="刪除PDO", ACCELERATOR = "F3")
            IF fgldialog.fgl_winButton(
                "刪除資料",
                "是否確定刪除PDO "||
                dispCoilList.arr[arr_curr()].SCHD_COIL_NO.subString(1,4)|| " - " ||
                dispCoilList.arr[arr_curr()].SCHD_COIL_NO.subString(5,15)||"?",
                "Lynx",
                "YES" || "|" || "NO",
                "question",
                0) = "YES" THEN
                INITIALIZE upd_tmp.* TO NULL
                LET upd_tmp.COIL_NO = dispCoilList.arr[arr_curr()].COIL_NO
                LET upd_tmp.SCHD_NO = dispCoilList.arr[arr_curr()].SCHD_COIL_NO.subString(1,4)
                CALL upd_tmp.delCZFA030M()
            END IF
            
        ON ACTION CPSCR601
            LET next_work = 1
            EXIT DIALOG
        ON ACTION CPSCR602
            LET next_work = 2
            EXIT DIALOG
        ON ACTION CPSCR604
            LET next_work = 4
            EXIT DIALOG
        ON ACTION CPSCR606
            LET next_work = 6
            EXIT DIALOG
        ON ACTION EXIT
            EXIT DIALOG
    END DIALOG
    
    RETURN next_work
END FUNCTION

#----------------------------------------------------------------------
#PDO FIELDS DIALOG MODULE
#----------------------------------------------------------------------
DIALOG PDOField_dm()
    
    INPUT focus_PDO.* FROM PDO_r.* ATTRIBUTE(WITHOUT DEFAULTS)
    END INPUT
END DIALOG

#----------------------------------------------------------------------
#COIL LIST DIALOG MODULE
#----------------------------------------------------------------------
DIALOG COIL_LIST_SCH03_dm()
    DEFINE len INTEGER
    
    DISPLAY ARRAY dispCoilList.arr TO COIL_LIST_SCH03_tb.*
        BEFORE DISPLAY
            CALL dispPDO(dispCoilList.arr[1].SCHD_COIL_NO)
        BEFORE ROW
            
            CALL dispPDO(dispCoilList.arr[arr_curr()].SCHD_COIL_NO)
            
            LET len = dispCoilList.arr.getLength()

            IF len == arr_curr() THEN
                CALL dispCoilList.extendList("normal", 5)
            END IF

    END DISPLAY
END DIALOG

#----------------------------------------------------------------------
#GET PDO BY COIL_NO AND SCHD_NO
#準備arg_coil_no的PDO DATA，使其顯示到畫面上PDO各欄位 
#----------------------------------------------------------------------
FUNCTION dispPDO(arg_schd_coil_no STRING)
    DEFINE pdi_rec CZFP210M_DB.CZFP210M
    
    LET pdi_rec.COIL_NO = focus_PDO.COIL_NO
    CALL pdi_rec.getCZFP210M()
    DISPLAY pdi_rec.TARGET_THICKNESS TO TARGET_THICKNESS_SCH03

    LET focus_PDO.COIL_NO = arg_schd_coil_no.subString(5,15)
    LET focus_PDO.SCHD_NO = arg_schd_coil_no.subString(1,4)
    CALL focus_PDO.getCZFA030M()
END FUNCTION

#----------------------------------------------------------------------
#PDO FIELDS MODIFIABLE
#----------------------------------------------------------------------
FUNCTION setFieldsModSch03(arg_entry BOOLEAN, arg_dialog ui.Dialog)
    
    CALL arg_dialog.nextField("SCHD_ORDER_col")
    #基本
    CALL arg_dialog.setFieldActive("MOTHER_COIL_NO_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("STEEL_GRADE_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("START_DATE_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("START_TIME_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("FINISH_DATE_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("FINISH_TIME_SCH03", arg_entry)
    #生產明細
    CALL arg_dialog.setFieldActive("ENTRY_THICKNESS_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("ACTUAL_THICKNESS_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("ACTUAL_WIDTH_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("ACTUAL_LENGTH_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("ENTRY_WEIGHT_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("GROSS_WEIGHT_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("NET_WEIGHT_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("ACTUAL_OUTER_DIAMETER_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("EXIT_SLEEVE_THICKNESS_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("EXIT_PAPER_CODE_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("PRODUCTION_CODE_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("TOTAL_PASSES_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("TOTAL_REDUCTION_SCH03", arg_entry)
    #品管
    CALL arg_dialog.setFieldActive("CLASS_CODE_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("QC_STATION_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("QC_COMMENT_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("QC_CODE_SCH03", arg_entry)
    #狀態
    CALL arg_dialog.setFieldActive("COIL_NOTE", arg_entry)
    CALL arg_dialog.setFieldActive("L2_CONFIRM", arg_entry)
    CALL arg_dialog.setFieldActive("QC_LOCK", arg_entry)
    CALL arg_dialog.setFieldActive("PP_LOCK", arg_entry)
    CALL arg_dialog.setFieldActive("TRANSFER", arg_entry)
    #班別
    CALL arg_dialog.setFieldActive("SHIFT_DATE_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("SHIFT_NO_SCH03", arg_entry)
    #維護
    CALL arg_dialog.setFieldActive("UPD_DATE_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("UPD_TIME_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("USER_NAME_SCH03", arg_entry)
    CALL arg_dialog.setFieldActive("PROG_NAME_SCH03", arg_entry)

END FUNCTION

FUNCTION querySchdCoil()
    DEFINE trg_schd, trg_coil, s_sql STRING
    DEFINE idx INTEGER
    DEFINE roll_back CPSCR6_INC.COIL_LIST

    OPEN WINDOW winSelSchdCoil_w WITH FORM "winSelSchdCoil"
    INPUT trg_schd, trg_coil FROM schd_no_fd, coil_no_fd
    
    CLOSE WINDOW winSelSchdCoil_w

    IF NOT INT_FLAG THEN
        IF trg_schd.getLength() < 4 AND trg_coil.getLength() < 8 THEN
            CALL fgldialog.fgl_winMessage("查詢鋼捲錯誤","鋼捲編號格式錯誤","stop")
            RETURN
        ELSE IF trg_schd.getLength() == 4  AND trg_coil.getLength() < 8 THEN
            LET s_sql = "SELECT SCHD_NO, COIL_NO FROM CZFA030M WHERE SCHD_NO='"|| trg_schd ||"'"
        ELSE IF trg_schd.getLength() < 4 AND trg_coil.getLength() >= 8 THEN
            LET s_sql = "SELECT SCHD_NO, COIL_NO FROM CZFA030M WHERE COIL_NO='"|| trg_coil ||"'"
        ELSE
            LET s_sql = "SELECT SCHD_NO, COIL_NO FROM CZFA030M WHERE " ||
                        " SCHD_NO='"|| trg_schd ||"' AND COIL_NO='"||trg_coil||"'"
        END IF END IF END IF

        CALL dispCoilList.arr.copyTo(roll_back.arr)
        CALL dispCoilList.arr.clear()
        SET CONNECTION "CR2"
        DECLARE cs CURSOR FROM s_sql

        LET idx = 1
        FOREACH cs INTO trg_schd, trg_coil
            LET dispCoilList.arr[idx].SCHD_ORDER = 0
            LET dispCoilList.arr[idx].COIL_NO = trg_coil
            LET dispCoilList.arr[idx].SCHD_COIL_NO = trg_schd CLIPPED || trg_coil
            LET idx = idx + 1
        END FOREACH
        CLOSE cs
        IF dispCoilList.arr.getLength() <> 1 THEN
            CALL dispCoilList.arr.deleteElement(dispCoilList.arr.getLength())
        END IF

        IF dispCoilList.arr[1].SCHD_COIL_NO IS NULL THEN
            CALL fgldialog.fgl_winMessage("查詢鋼捲錯誤","PDO查無鋼捲","stop")
            CALL roll_back.arr.copyTo(dispCoilList.arr)
        ELSE
            CALL dispPDO(dispCoilList.arr[1].SCHD_COIL_NO)
        END IF
    END IF
END FUNCTION
#----------------------------------------------------------------------
#Send PDO Request TO L2
#----------------------------------------------------------------------
FUNCTION sendReqToL2(src_coil CHAR(11))
    DEFINE pdi CZFP210M_DB.CZFP210M
    DEFINE tmp CRM_INC.L3MSG
    
    {SELECT * INTO pdi.*
        FROM czfp210m
        WHERE COIL_NO = src_coil

    LET tmp = pdi.genCZFP210M_BC01Msg()

    CALL PDI_SENDER(tmp.*)}
    
END FUNCTION


FUNCTION inputSchdCoil()
    DEFINE schdNo CHAR(4)
    DEFINE coilNo CHAR(11)
    PROMPT "TEST..." FOR schdNo
    DISPLAY schdNo
        
    RETURN schdNo
END FUNCTION
