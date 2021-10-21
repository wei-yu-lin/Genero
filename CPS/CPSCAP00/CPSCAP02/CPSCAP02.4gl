IMPORT util
IMPORT FGL CCAP210M_DB
IMPORT FGL CPSCAP01
IMPORT FGL fgldialog
IMPORT FGL CPSCAP_INC
#IMPORT FGL sys_temp
IMPORT FGL sys_toolbar

DEFINE PDI_tmp CCAP210M_DB.CCAP210M
DEFINE dispPDI CCAP210M_DB.CCAP210M_LIST
DEFINE dispCoilList CPSCAP_INC.COIL_LIST

DEFINE MainDialog ui.Dialog
#DEFINE priv sys_priv
#DEFINE form_tb sys_tbDispFlag
DEFINE form_tb sys_ConToolBar

FUNCTION CPSCAP02()
    DEFINE next_work, len, pt, tb_count INTEGER
    DEFINE upd_tmp CCAP210M_DB.CCAP210M
    DEFINE selCoil CHAR(11)

    #OPEN FORM CPSCAP02_f FROM "CPSCAP02"
    #DISPLAY FORM CPSCAP02_f

    #CALL ui.Window.getCurrent().getForm().loadToolBar("CAPSCH00_toolbar")
    
    CALL form_tb.init(TRUE)
    CALL form_tb.setAttribute("_add", FALSE)
    CALL form_tb.setAttribute("_help", FALSE)
    CALL form_tb.getPriv("CPSCAP02")
    
    CALL ui.Window.getCurrent().getForm().loadTopMenu("cpscap01_topmenu")

    
    LET next_work = 0
    SET CONNECTION "CPS"
    SELECT COUNT(SCHD_COIL_NO) INTO tb_count FROM CCAP320M 
    LET tb_count = tb_count - 1

    MESSAGE "F1查詢鋼捲  F2修改PDI  F3刪除PDI"
    DIALOG ATTRIBUTE(UNBUFFERED)
        SUBDIALOG COIL_LIST_SCH02_dm -- 鋼捲列表(當前排程)
        #SUBDIALOG SelCoil_dm -- 查詢鋼捲
        SUBDIALOG PDIField_dm -- PDI欄位

        BEFORE DIALOG
            CALL form_tb.setDialogPriv()
            
            LET MainDialog = ui.Dialog.getCurrent()
            CALL setFieldsModSch02(false, MainDialog) -- PDI各欄位編輯disable
            CALL MainDialog.setActionActive("CPSCAP02_save", FALSE) --PDI修改確認按鈕disable
            CALL MainDialog.setActionActive("CPSCAP02_back", FALSE) --PDI修改取消按鈕disable
            
            IF form_tb.priv.PQRY != 'N' OR form_tb.priv.PQRY IS NULL THEN
                #初始從排程抓n顆鋼捲顯示
                CALL dispCoilList.extendList("init", 5)
                CALL dispPDI(dispCoilList.arr[1].COIL_NO)
            END IF
            
        #以鋼捲編號查詢鋼捲
        ON ACTION CPSCAP02_query ATTRIBUTE(TEXT="確認查詢", ACCELERATOR = "F1")
            CALL getPDI(fun_winSelCoil())
            
        ON ACTION CPSCAP02_prev -- 前一筆
            LET pt = arr_curr()-1
            IF arr_curr() <= 1 THEN
                CALL fgldialog.fgl_winMessage("ERROR","已到top!","stop")
            ELSE
                CALL dispPDI(dispCoilList.arr[pt].COIL_NO)
                CALL DIALOG.setCurrentRow("COIL_LIST_tb",pt)
            END IF
        ON ACTION CPSCAP02_next -- 下一筆
            LET pt = arr_curr()+1
            LET len = dispPDI.arr.getLength()
            IF arr_curr() == len THEN
                IF tb_count == arr_curr() THEN
                    CALL fgldialog.fgl_winMessage("ERROR","已到botton!","stop")
                ELSE
                    CALL dispCoilList.extendList("normal", 5)
                END IF
            ELSE
                CALL dispPDI(dispCoilList.arr[pt].COIL_NO)
                CALL DIALOG.setCurrentRow("COIL_LIST_tb",pt)
            END IF
        ON ACTION CPSCAP02_first -- 第一筆
            CALL dispPDI(dispCoilList.arr[1].COIL_NO)
            CALL DIALOG.setCurrentRow("COIL_LIST_tb",1)
            
        ON ACTION CPSCAP02_last -- 最後筆
            CALL dispCoilList.extendList("init", tb_count)
            CALL dispPDI(dispCoilList.arr[tb_count].COIL_NO)
            CALL DIALOG.setCurrentRow("COIL_LIST_tb",tb_count)
            
        #修改PDI
        ON ACTION CPSCAP02_upd ATTRIBUTE(TEXT="修改PDI", ACCELERATOR = "F2")
            CALL setFieldsModSch02(true, MainDialog)
            INITIALIZE upd_tmp.* TO NULL
            CALL MainDialog.setActionActive("CPSCAP02_save", TRUE)
            CALL MainDialog.setActionActive("CPSCAP02_back", TRUE)
            CALL MainDialog.setActionActive("CPSCAP02_upd", FALSE)

        ON ACTION CPSCAP02_save -- 修改PDI->確認修改
            LET upd_tmp.* = dispPDI.focus_PDI.*
            LET upd_tmp.UPD_DATE = util.Datetime.format(CURRENT,"%Y%m%d")
            LET upd_tmp.UPD_TIME = util.Datetime.format(CURRENT,"%H%M%S")
            LET upd_tmp.USER_NAME = fgl_getenv("g_user_id")
            LET upd_tmp.PROG_NAME = "CPSCAP02"
            
            CALL upd_tmp.updCCAP210M()
            LET dispPDI.focus_PDI.* = upd_tmp.*
            LET dispPDI.arr[arr_curr()].* = dispPDI.focus_PDI.*
            CALL setFieldsModSch02(false, MainDialog) 
            
            CALL MainDialog.setActionActive("CPSCAP02_upd", TRUE)
            CALL MainDialog.setActionActive("CPSCAP02_save", FALSE)
            CALL MainDialog.setActionActive("CPSCAP02_back", FALSE)
            
        ON ACTION CPSCAP02_back -- 修改PDI->取消修改
            CALL setFieldsModSch02(false, MainDialog)
            CALL dispPDI(dispCoilList.arr[arr_curr()].COIL_NO)
            
            CALL MainDialog.setActionActive("CPSCAP02_upd", TRUE)
            CALL MainDialog.setActionActive("CPSCAP02_save", FALSE)
            CALL MainDialog.setActionActive("CPSCAP02_back", FALSE)
            #CALL setFieldsModSch02("1")

        #刪除PDI
        ON ACTION CPSCAP02_del ATTRIBUTE(TEXT="刪除PDI", ACCELERATOR = "F3")
            IF fgldialog.fgl_winButton(
                "刪除資料",
                "是否確定刪除"||dispPDI.arr[arr_curr()].COIL_NUMBER||"的PDI?",
                "Lynx",
                "YES" || "|" || "NO",
                "question",
                0) = "YES" THEN
                INITIALIZE upd_tmp.* TO NULL
                LET upd_tmp.COIL_NUMBER = dispPDI.arr[arr_curr()].COIL_NUMBER
                CALL upd_tmp.delCCAP210M()
            END IF
        ON ACTION CPSCAP01
            LET next_work = 1
            EXIT DIALOG
        ON ACTION CPSCAP03
            LET next_work = 3
            EXIT DIALOG
        ON ACTION CPSCAP04
            LET next_work = 4
            EXIT DIALOG
        ON ACTION CPSCAP06
            LET next_work = 6
            EXIT DIALOG
        ON ACTION EXIT
            EXIT DIALOG
    END DIALOG
    
    RETURN next_work
END FUNCTION
#----------------------------------------------------------------------
#COIL LIST DIALOG MODULE
#----------------------------------------------------------------------
DIALOG COIL_LIST_SCH02_dm()
    DEFINE len, debug INTEGER
    
    DISPLAY ARRAY dispCoilList.arr TO COIL_LIST_tb.*
        BEFORE DISPLAY
            CALL dispPDI(dispCoilList.arr[1].COIL_NO)
        BEFORE ROW
            CALL dispPDI(dispCoilList.arr[arr_curr()].COIL_NO)

            LET len = dispCoilList.arr.getLength()
            
            IF len == arr_curr() THEN
                CALL dispCoilList.extendList("normal", 5)
                #CALL dispPDI.updByCoilList(dispCoilList)
                #CALL dispPDI(dispCoilList.arr[arr_curr()].COIL_NO)
            END IF

    END DISPLAY
END DIALOG
#----------------------------------------------------------------------
#SELECT COIL DIALOG MODULE
#----------------------------------------------------------------------
{DIALOG SelCoil_dm()
    INPUT SelCoil FROM SelCoil_SCH02_fd
    END INPUT
END DIALOG}

#----------------------------------------------------------------------
#PDI FIELDS DIALOG MODULE
#----------------------------------------------------------------------
DIALOG PDIField_dm()
    
    INPUT dispPDI.focus_PDI.* FROM PDI_r.*
    END INPUT
END DIALOG

FUNCTION fun_winSelCoil()
    DEFINE input_coil CHAR(11)
    
    OPEN WINDOW winSelCoil_w WITH FORM "winSelCoil"
    INPUT input_coil FROM coil_no_fd
    CLOSE WINDOW winSelCoil_w

    RETURN input_coil
END FUNCTION

#----------------------------------------------------------------------
#PDI FIELDS MODIFIABLE
#----------------------------------------------------------------------
FUNCTION setFieldsModSch02(arg_entry BOOLEAN, arg_dialog ui.Dialog)
    
    CALL arg_dialog.nextField("SCHD_ORDER_SCH02_col")
    #基本
    CALL arg_dialog.setFieldActive("coil_status_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("steel_grade_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("factory_SCH02", arg_entry)

    #入料
    CALL arg_dialog.setFieldActive("entry_width_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("entry_thickness_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("target_thickness_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("entry_outer_diameter_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("entry_weight_SCH02", arg_entry)

    #出料
    CALL arg_dialog.setFieldActive("paper_code_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("exit_sleeve_thickness_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("class_code_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("production_code_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("reduction_SCH02", arg_entry)

    #訂單
    CALL arg_dialog.setFieldActive("order_no_item_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("delivery_date_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("apn_no_SCH02", arg_entry)

    #缺陷
    CALL arg_dialog.setFieldActive("defect_code01_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("defect_code02_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("defect_code03_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("defect_code04_SCH02", arg_entry)
    CALL arg_dialog.setFieldActive("defect_code05_SCH02", arg_entry)

    #品管
    CALL arg_dialog.setFieldActive("qc_comment_SCH02", arg_entry)

END FUNCTION

FUNCTION getPDI(arg_coil_no CHAR(11))
    DEFINE s_tmp STRING

    LET s_tmp = arg_coil_no
    IF s_tmp.trim() < 8 THEN
        CALL fgldialog.fgl_winMessage("查詢鋼捲錯誤","鋼捲編號格式錯誤","stop")
        RETURN
    END IF
    
    SET CONNECTION "CPS"
    
    SELECT * INTO PDI_tmp.* FROM CCAP210M WHERE COIL_NO = arg_coil_no

    IF SQLCA.sqlcode == 100 THEN
        CALL fgldialog.fgl_winMessage("查詢鋼捲錯誤","PDI查無此鋼捲: "||arg_coil_no,"stop")
    ELSE
        CALL dispPDI.arr.clear()
        CALL dispCoilList.arr.clear()
        LET dispPDI.arr[1].* = PDI_tmp.*
        LET dispCoilList.arr[1].COIL_NO = arg_coil_no
        LET dispCoilList.arr[1].SCHD_ORDER = 0
        CALL dispPDI(PDI_tmp.COIL_NUMBER)
    END IF
END FUNCTION


#----------------------------------------------------------------------
#準備arg_coil_no的PDI DATA，使其顯示到畫面上PDI各欄位
#----------------------------------------------------------------------
FUNCTION dispPDI(arg_coil_no CHAR(11))
    DEFINE ORDER_THICK CHAR(4), PROD CHAR(1)
    DEFINE s_tmp, no_trg, item_trg STRING
    

    LET dispPDI.focus_PDI.COIL_NUMBER = arg_coil_no
    CALL dispPDI.focus_PDI.getCCAP210M()
    
    LET PROD = dispPDI.focus_PDI.PRODUCTION_CODE[2]
    #LET s_tmp = dispPDI.focus_PDI.ORDER_NO_ITEM
    #LET no_trg = s_tmp.subString(1,7)
    #LET item_trg = s_tmp.subString(8,9)
    
    #SET CONNECTION "ORD"
    
    #SELECT SHIP_THICK_AIM INTO ORDER_THICK FROM ordb011m
    #WHERE ORDER_NO = no_trg AND ORDER_ITEM = item_trg
    #WHERE (ORDER_NO||ORDER_ITEM) = PDI.ORDER_NO_ITEM --不會吃到INDEX

    DISPLAY  PROD TO PROD_SCH02 
END FUNCTION
