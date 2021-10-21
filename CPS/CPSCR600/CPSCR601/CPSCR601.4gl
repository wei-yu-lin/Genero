IMPORT FGL fgldialog
IMPORT FGL CZFP215M_DB
IMPORT FGL CZFP321W_DB
IMPORT FGL CZFP321W_LIST
IMPORT FGL CZFP322W_DB
IMPORT FGL CZFP322W_LIST
IMPORT FGL PCMB020M_DB
IMPORT FGL funCond
IMPORT FGL CPSCR6_INC
IMPORT FGL CPSCR601_report
IMPORT FGL sys_toolbar

#粗排檔CZFP322W LIST--包含CZFP322W動態空陣列
#細排檔CZFP321W LIST--包含CZFP321W動態空陣列
DEFINE P322W_list CZFP322W_LIST
DEFINE P321W_list CZFP321W_LIST

#CR6的鋼捲篩選條件
DEFINE CR6_COND funCond.funCond_list
DEFINE condition_main, condition_sub STRING

DEFINE PickUpColor CPSCR6_INC.TypePickUpColor
    
DEFINE schd_seq CPSCR6_INC.SchdSeq_rec
DEFINE form_tb sys_ConToolBar

FUNCTION CPSCR601()
    DEFINE len, i, idx INTEGER
    DEFINE next_work INTEGER
    DEFINE del_buff DYNAMIC ARRAY OF INTEGER

    #CALL CPSCR601_init()
    
    LET next_work = 0
    #CALL init_proc_seq()
    
    #OPEN FORM SCH01_f FROM "CPSCR601"
    #DISPLAY FORM SCH01_f

    CALL form_tb.init(FALSE)
    CALL form_tb.getPriv("CPSCR601")
    CALL ui.Window.getCurrent().getForm().loadTopMenu("cr6sch01_topmenu")

    CALL P322W_list.arr.clear()
    CALL P321W_list.arr.clear()
    
    DIALOG ATTRIBUTE(UNBUFFERED)
        #粗排
        SUBDIALOG P322W_dm
        #細排
        SUBDIALOG P321W_dm
        #條件選取
        SUBDIALOG condition_dm
        #副條件選取
        SUBDIALOG condition_sub_dm

        BEFORE DIALOG
            
            CALL form_tb.setDialogPriv()
            #初始化資料->查詢權限
            IF form_tb.priv.PQRY != 'N' OR form_tb.priv.PQRY IS NULL THEN
                #載入選取條件到CR6_COND.arr
                CALL CR6_COND.loadCondition("formonly.condition_cb")
                #載入暫存檔到當前工作環境
                CALL P322W_list.get() --粗排陣列
                CALL P321W_list.get() --細排陣列
            END IF

        #選取粗排到細排
        ON ACTION CPSCR601_F1 ATTRIBUTE(TEXT="F1 選入待排", ACCELERATOR = "F1")
            LET len = P322W_list.arr.getLength()
            FOR i = 1 TO len
                #在粗排dialog被選擇的Row
                IF DIALOG.isRowSelected("P322W_r", i) AND P322W_list.arr[i].COIL_NO IS NOT NULL THEN
                    #加入細排
                    CALL P321W_list.append(P322W_list.arr[i])
                    CALL P322W_list.updFLAG(P322W_list.arr[i].COIL_NO, "@")
                END IF
            END FOR

            #更新粗排dialog，已選入細排的列標色
            CALL setPickUpColor(ui.DIALOG.getCurrent())
            #CALL DIALOG.setArrayAttributes("P322W_r", PickUpColor)

        #從細排移除
        ON ACTION CPSCR601_F2 ATTRIBUTE(TEXT="F2 取消待排", ACCELERATOR = "F2")
            #初始化參數
            LET len = P321W_list.arr.getLength()
            LET idx = 1
            CALL del_buff.clear()

            #挑選在細排dialog中被選擇的Row
            FOR i = 1 TO len
                IF DIALOG.isRowSelected("P321W_r", i) THEN                    
                    #登記欲從細排陣列刪除的成員index
                    LET del_buff[idx] = i
                    LET idx = idx + 1
                END IF
            END FOR

            #從細排陣列刪除成員
            LET len = del_buff.getLength()
            FOR i = len TO 1 STEP -1
                CALL P322W_list.updFLAG(P321W_list.arr[del_buff[i]].COIL_NO, ' ')
                CALL P321W_list.delByIndex(del_buff[i])
            END FOR

            #設定刪除後Table的反白項
            IF len > 0 THEN
                CALL DIALOG.setCurrentRow("P321W_r", del_buff[1])
            END IF
            
            #重新載入粗排暫存檔
            #CALL P322W_list.get()

            #重新標色: 粗排dialog，選入細排的列標色
            CALL setPickUpColor(ui.DIALOG.getCurrent())
            
        #從清空細排
        ON ACTION CPSCR601_F3 ATTRIBUTE(TEXT="F3 清空待排", ACCELERATOR = "F3")
            #細排陣列清空
            CALL P321W_list.arr.clear()
            #細排暫存檔清空
            #CALL CZFP321W_DB.delP321W_DB('*')
            CALL P321W_list.delByCoilNo("*")
            
            #無鋼捲從粗排被選入
            #粗排暫存檔全部初始化
            CALL P322W_list.updFLAG('*', ' ')
            
            #重新標色: 粗排dialog
            CALL setPickUpColor(ui.DIALOG.getCurrent())
        #修改製程
        ON ACTION CPSCR601_F4 ATTRIBUTE(TEXT="F4 修改製程", ACCELERATOR = "F4")
            
            #依細排設製"修改製程"欄位
            CALL modify_prod_dm()
            
        #送出排程並產生PDI
        ON ACTION CPSCR601_F5 ATTRIBUTE(TEXT="F5 送出排程", ACCELERATOR = "F5")
            IF fun_winSendSchd() == 1 THEN
                CALL fgldialog.fgl_winMessage("送出排程","排程送出完成","sucess")
            END IF
        #列印報表    
        ON ACTION CPSCR601_F6 ATTRIBUTE(TEXT="F6 列印報表", ACCELERATOR = "F6")
            IF P321W_list.arr.getLength() < 1 THEN
                CALL fgldialog.fgl_winMessage("待生產排程報表無資料","\"待排程鋼捲\"列表為空，請將鋼捲選入待排!", "error")
            ELSE
                CALL CPSCR601_report.GenReport(P321W_list.arr)
            END IF
        ON ACTION CPSCR602
            LET next_work = 2
            EXIT DIALOG
        ON ACTION CPSCR603
            LET next_work = 3
            EXIT DIALOG
        ON ACTION CPSCR604
            LET next_work = 4
            EXIT DIALOG
        ON ACTION CPSCR606
            LET next_work = 6
            EXIT DIALOG
        ON ACTION CLOSE
            EXIT DIALOG
        ON ACTION EXIT
            EXIT DIALOG
    END DIALOG

    RETURN next_work
END FUNCTION

#----------------------------------------------------------------------
#P322W DIALOG MODULE
#----------------------------------------------------------------------
DIALOG P322W_dm()
    DEFINE node om.DomNode
    DISPLAY ARRAY P322W_list.arr TO P322W_r.* 
        BEFORE DISPLAY
            #多列選擇模式
            CALL Dialog.setSelectionMode("P322W_r", 1)

            #粗排dialog樣式初始化
            LET node = ui.Window.getCurrent().findNode("Table","table1")
            CALL node.setAttribute("style","foz")

            #修改製程區塊隱藏
            CALL ui.Window.getCurrent().getForm().setElementHidden("modify_proc_g",TRUE)

            #已被選入細排的列標色
            CALL setPickUpColor(ui.DIALOG.getCurrent())

        BEFORE ROW
            #粗排dialog樣式初始化
            CALL node.setAttribute("style","foz")
            #選入排程按鈕開啟
            IF form_tb.priv.F1 != 'N' OR form_tb.priv.F1 IS NULL THEN
                CALL DIALOG.setActionActive("CPSCR601_F1", TRUE)
            END IF
            #取消排程按鈕關閉
            CALL DIALOG.setActionActive("CPSCR601_F2", FALSE)
            #修改製程按鈕開啟
            CALL DIALOG.setActionActive("CPSCR601_F4", FALSE)

    END DISPLAY
END DIALOG
#----------------------------------------------------------------------
#P321W DIALOG MODULE
#----------------------------------------------------------------------
DIALOG P321W_dm()
    DEFINE dnd ui.DragDrop
    DEFINE len, i, idx, dst INTEGER
    DEFINE drag_321W_arr DYNAMIC ARRAY OF CZFP321W_DB.CZFP321W
    DEFINE del_idx_buff DYNAMIC ARRAY OF INTEGER
    DEFINE node om.DomNode
    
    DISPLAY ARRAY P321W_list.arr TO P321W_r.*
        BEFORE DISPLAY
            #多列選擇模式
            CALL Dialog.setSelectionMode("P321W_r", TRUE)

        BEFORE ROW
            #選入排程按鈕關閉
            CALL DIALOG.setActionActive("CPSCR601_F1", FALSE)
            IF form_tb.priv.F2 != 'N' OR form_tb.priv.F2 IS NULL THEN
                #取消排程按鈕開啟
                CALL DIALOG.setActionActive("CPSCR601_F2", TRUE)
            END IF
            IF form_tb.priv.F4 != 'N' OR form_tb.priv.F4 IS NULL THEN
                #修改製程按鈕開啟
                CALL DIALOG.setActionActive("CPSCR601_F4", TRUE)
            END IF

            #LET modify_prod_rec.coil_no = P321W_list.arr[arr_curr()].COIL_NO
            
            #讓CurrentRow只指到一行
            CALL DIALOG.setCurrentRow("P322W_r", DIALOG.getCurrentRow("P322W_r"))

            LET node = ui.Window.getCurrent().findNode("Table","table1")

            IF P322W_list.arr.getLength() > 0 THEN
                IF P322W_list.arr[DIALOG.getCurrentRow("P322W_r")].FLAG == '@' THEN
                    CALL node.setAttribute("style","defocus")
                END IF
            END IF
            
        #開始拖移
        ON DRAG_START(dnd)
            CALL drag_321W_arr.clear()
            CALL del_idx_buff.clear()
            LET idx = 1
            LET len = P321W_list.arr.getLength()
            FOR i = 1 TO len
                #將選擇並拖移的鋼捲先放進drag_321W_arr
                #其index放進del_idx_buff
                IF DIALOG.isRowSelected("P321W_r", i) THEN
                    LET drag_321W_arr[idx].* = P321W_list.arr[i].*
                    LET del_idx_buff[idx] = i
                    LET idx = idx + 1
                END IF
            END FOR
        #放置
        ON DROP(dnd)
            LET dst = dnd.getLocationRow()
            LET len = del_idx_buff.getLength()
            FOR i = len TO 1 STEP -1
                IF del_idx_buff[i] >= dst THEN
                    CALL P321W_list.arr.deleteElement(del_idx_buff[i])
                ELSE
                    LET dst = dst - 1
                    CALL P321W_list.arr.deleteElement(del_idx_buff[i])
                END IF
            END FOR
            
            LET len = drag_321W_arr.getLength()
            
            FOR i = len TO 1 STEP -1
                CALL P321W_list.arr.insertElement(dst)
                LET P321W_list.arr[dst].* = drag_321W_arr[i].*
            END FOR
            CALL DIALOG.setCurrentRow("P321W_r", dst)
            CALL DIALOG.setSelectionRange( "P321W_r", dst, dst+drag_321W_arr.getLength()-1, TRUE)

            #以拖拉後的順序存回細排暫存檔
            CALL P321W_list.set()
    END DISPLAY
END DIALOG

#----------------------------------------------------------------------
#條件選取鋼捲 DIALOG MODULE
#----------------------------------------------------------------------
DIALOG condition_dm()
    INPUT condition_main FROM condition_cb
        BEFORE FIELD condition_cb
            IF form_tb.priv.PQRY == 'N' THEN
                CALL fgldialog.fgl_winMessage("權限錯誤","無查詢權限","")
            END IF
        ON CHANGE condition_cb
            #非副條件的選項，選完即抓取符合條件的鋼捲
            IF      condition_main != "P_PREV_STATION" 
                AND condition_main != "METER_WIDTH" 
                AND condition_main != "FEET4_WIDTH"  THEN

                CALL ui.Window.getCurrent().findNode("FormField","formonly.select_pb").setAttribute("hidden","0")
                #粗排初始化，避免殘留
                CALL P322W_list.delByCoilNo("*")
                LET P322W_list = CR6_COND.arr[condition_main].etlToP322W(condition_sub)
                CALL P322W_list.set()

                CALL setPickUpColor(ui.DIALOG.getCurrent())
                CALL ui.Window.getCurrent().findNode("FormField","formonly.select_pb").setAttribute("hidden","1")
                
            END IF
    END INPUT
END DIALOG
#----------------------------------------------------------------------
#副條件選取鋼捲 DIALOG MODULE
#----------------------------------------------------------------------
DIALOG condition_sub_dm()
    INPUT condition_sub FROM condition_sub_cb
        BEFORE INPUT
            #載入所有條件選項
            CALL SetUpSubCond_cb()
        BEFORE FIELD condition_sub_cb
            IF form_tb.priv.PQRY == 'N' THEN
                CALL fgldialog.fgl_winMessage("權限錯誤","無查詢權限","")
            END IF
        ON CHANGE condition_sub_cb
            
            CALL ui.Window.getCurrent().findNode("FormField","formonly.select_pb").setAttribute("hidden","0")
            #粗排初始化，避免殘留
            CALL P322W_list.delByCoilNo("*")
            CASE condition_main
                #生產預排類條件，需要再引入副條件
                WHEN "P_PREV_STATION"
                    #抓取符合條件的鋼捲
                    LET P322W_list = CR6_COND.arr[condition_sub].etlToP322W(condition_sub)
                OTHERWISE
                    #抓取符合條件的鋼捲
                    LET P322W_list = CR6_COND.arr[condition_main].etlToP322W(condition_sub)
            END CASE
            
            CALL P322W_list.set()

            CALL setPickUpColor(ui.DIALOG.getCurrent())

            CALL ui.Window.getCurrent().findNode("FormField","formonly.select_pb").setAttribute("hidden","1")
    END INPUT
END DIALOG

#----------------------------------------------------------------------
#修改製程 DIALOG MODULE
#----------------------------------------------------------------------
FUNCTION modify_prod_dm()
    DEFINE tmp_pcm PCMB020M_DB.PCMB020M
    DEFINE src_path STRING
    DEFINE mod_prod CPSCR6_INC.ModProd_rec
    
    OPEN WINDOW ModProd_w WITH FORM "winModProd" ATTRIBUTE(STYLE="miniWin")
    
    INPUT mod_prod.coming_station FROM coming_station_fd ATTRIBUTE(WITHOUT DEFAULTS)
        BEFORE INPUT
            LET mod_prod.coil_no = P321W_list.arr[arr_curr()].COIL_NO
            CALL mod_prod.SetUpModProc()
            LET src_path = mod_prod.coming_station

            DISPLAY mod_prod.coil_no TO coil_no_fd -- 鋼捲編號
            DISPLAY mod_prod.past_station TO past_station_fd -- 已完成製程
            DISPLAY mod_prod.plan_station TO plan_station_fd -- 標準製程
            DISPLAY mod_prod.prod_thick TO prod_thick_fd -- 成品厚度
            DISPLAY mod_prod.apn_code TO apn_code_fd -- 用途碼
        #恢復製程欄位
        ON ACTION mod_rs_bt
            DISPLAY src_path TO coming_station_fd
            
    END INPUT

    
    IF NOT INT_FLAG THEN
        IF fgldialog.fgl_winQuestion(
            "修改確認", "確認修改 "||mod_prod.coil_no||"製程? ",
            "cancel", "yes|no", "question", 0) == "yes" THEN
            INITIALIZE tmp_pcm.* TO NULL
            
            LET tmp_pcm.COIL_NO = mod_prod.coil_no
            LET tmp_pcm.ACTL_STATION_CODE = mod_prod.past_station || mod_prod.coming_station

            CALL tmp_pcm.upd()
        END IF
    END IF
    
    CLOSE WINDOW ModProd_w
END FUNCTION

#----------------------------------------------------------------------
#送出排程小視窗
#----------------------------------------------------------------------
FUNCTION fun_winSendSchd()
    DEFINE i, len INTEGER
    DEFINE ins_tmp CZFP215M_DB.CZFP215M
    
    OPEN WINDOW sendSchd_w WITH FORM "winSendSchd"

    INPUT schd_seq.* FROM schd_seq_r.*
        BEFORE INPUT
            LET schd_seq.coil_num = NULL
            LET schd_seq.init_no = NULL
    END INPUT

    IF NOT INT_FLAG THEN
        #各欄位檢查
        IF LENGTH(schd_seq.schd_no) < 4 THEN
            CALL fgldialog.fgl_winMessage("送出排程錯誤","排程批號格式錯誤","stop")
            CLOSE WINDOW sendSchd_w
            RETURN -1
        END IF
        
        IF schd_seq.coil_num IS NULL THEN
            LET schd_seq.coil_num = 0
        END IF
        IF schd_seq.init_no IS NULL THEN
            LET schd_seq.init_no = 1
        END IF

        #生成PDI
        CALL P321W_list.genPDI()

        LET len = P321W_list.arr.getLength()

        #UI與暫存檔更新
        IF schd_seq.coil_num > len OR schd_seq.coil_num==0 THEN
            #當鋼捲數量超過待排或等於0時，全部排程
            LET schd_seq.coil_num = len
            #加入排程檔
            CALL P321W_list.appendToSchd(schd_seq)

            CALL P322W_list.updFLAG('*', ' ')
            --UPDATE P322W SET FLAG = ''
        ELSE
            #加入排程檔
            CALL P321W_list.appendToSchd(schd_seq)


        END IF

        FOR i = 1 TO schd_seq.coil_num
            #加入PDI Trigger
            LET ins_tmp.COIL_NO = P321W_list.arr[1].COIL_NO
            CALL ins_tmp.insCZFP215M()

            #P322W刪除已排程鋼捲
            CALL P322W_list.delByCoilNo(P321W_list.arr[1].COIL_NO)
            #P321W刪除已排程鋼捲
            CALL P321W_list.delByIndex(1)
        END FOR
        
        #排程後更新P321W
        
        IF schd_seq.coil_num == len THEN
            #CALL CZFP321W_DB.delP321W_DB('*')
            CALL P321W_list.delByCoilNo("*")
            CALL P321W_list.arr.clear()
        ELSE
            CALL P321W_list.set()
        END IF

        #重新標色
        CALL setPickUpColor(ui.DIALOG.getCurrent())

        CLOSE WINDOW sendSchd_w
        RETURN 1
    ELSE
        CLOSE WINDOW sendSchd_w
        RETURN 0
    END IF
END FUNCTION

#----------------------------------------------------------------------
#載入副條件combo box列表
#----------------------------------------------------------------------
FUNCTION SetUpSubCond_cb()
    DEFINE cb_list ui.ComboBox

    LET cb_list = ui.ComboBox.forName("formonly.condition_sub_cb")
    CALL cb_list.clear()

    CASE condition_main
        #生產預排副條件選項
        WHEN "P_PREV_STATION"
            CALL cb_list.addItem("PREV_HAP", "預排HAP(2B/2D不接導帶)")
            CALL cb_list.addItem("PREV_AP3", "預排AP3(2B/2D不接導帶)")
            CALL cb_list.addItem("PREV_CPL", "預排CPL(2B/2D需接導帶)")
            CALL cb_list.addItem("PREV_AP4", "預排AP4(2B/2D二軋鋼捲)")
        #米尺寬度副條件選項
        WHEN "METER_WIDTH"
            CALL cb_list.addItem("2", "200系")
            CALL cb_list.addItem("3", "300系")
            CALL cb_list.addItem("4", "400系")
        #四呎寬度副條件選項
        WHEN "FEET4_WIDTH"
            CALL cb_list.addItem("2", "200系")
            CALL cb_list.addItem("3", "300系")
            CALL cb_list.addItem("4", "400系")
    END CASE
END FUNCTION

#----------------------------------------------------------------------
#根據P322W_arr中的選取FLAG去設定顏色提醒
#----------------------------------------------------------------------
FUNCTION setPickUpColor(arg_dialog ui.Dialog)
    DEFINE len, i INTEGER

    CALL PickUpColor.clear()
    LET len = P322W_list.arr.getLength()
    FOR i = 1 TO len
        IF P322W_list.arr[i].FLAG == '@' THEN
            LET PickUpColor[i].COIL_NO = "#CCCCFF reverse"
            LET PickUpColor[i].RUSH_CODE_PP = "#CCCCFF reverse"
            LET PickUpColor[i].STEEL_GRADE = "#CCCCFF reverse"
            LET PickUpColor[i].COIL_WIDTH = "#CCCCFF reverse"
            LET PickUpColor[i].COIL_THICK = "#CCCCFF reverse"
            LET PickUpColor[i].OUT_THICK = "#CCCCFF reverse"
            LET PickUpColor[i].REDUCTION = "#CCCCFF reverse"

            LET PickUpColor[i].COIL_WT = "#CCCCFF reverse"
            LET PickUpColor[i].PREV_STATION = "#CCCCFF reverse"
            LET PickUpColor[i].NEXT_STATION = "#CCCCFF reverse"
            
            LET PickUpColor[i].ORDER_NO_ITEM = "#CCCCFF reverse"
            LET PickUpColor[i].DUE_DATE = "#CCCCFF reverse"
            LET PickUpColor[i].APN_CODE = "#CCCCFF reverse"
            LET PickUpColor[i].CLASS_CODE = "#CCCCFF reverse"
            LET PickUpColor[i].IC_CODE = "#CCCCFF reverse"
        END IF

        #軋下率異常顯示
        IF P322W_list.arr[i].REDUCTION >78 OR P322W_list.arr[i].REDUCTION <40 THEN
            #IF P322W_arr[i].FLAG == '@' THEN
                LET PickUpColor[i].REDUCTION = "red bold underline reverse"
            #ELSE
            #    LET PickUpColor[i].REDUCTION = "red bold underline"
            #END IF
        END IF 
    END FOR

    CALL arg_dialog.setArrayAttributes("P322W_r", PickUpColor)
END FUNCTION

#-------------------------------------------------------
# init. For Dependency Diagram Tracing
#-------------------------------------------------------
FUNCTION CPSCR601_init()
    CALL init_CZFP322W_DB()
    CALL init_CZFP322W_LIST()
    CALL init_CZFP321W_DB()
    CALL init_PCMB020M()
END FUNCTION
