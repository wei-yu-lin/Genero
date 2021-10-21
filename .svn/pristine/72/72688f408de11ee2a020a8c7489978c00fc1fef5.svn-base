
#修改製程record
PUBLIC TYPE ModProd_rec RECORD
    coil_no CHAR(11),
    past_station STRING,
    coming_station STRING,
    plan_station STRING,
    prod_thick FLOAT,
    apn_code CHAR(4)
END RECORD

PUBLIC TYPE sys_ProcSeq RECORD
    PKEY CHAR(2),
    PROC_SEQ STRING
END RECORD

#針對每個CPSCR601_rec欄位用一個STRING定義個欄位顏色屬性
PUBLIC TYPE TypePickUpColor DYNAMIC ARRAY OF RECORD
    COIL_NO STRING,
    FLAG STRING,
    BP STRING,
    FP STRING,
    STEEL_GRADE STRING,
    
    COIL_WIDTH STRING,
    COIL_THICK STRING,
    OUT_THICK STRING,
    REDUCTION STRING,
    
    COIL_WT STRING,
    PREV_STATION STRING,
    NEXT_STATION STRING,
    ORDER_NO_ITEM STRING,

    DUE_DATE STRING,
    RUSH_CODE_PP STRING,
    CLASS_CODE STRING,
    IC_CODE STRING,
    APN_CODE STRING
END RECORD

#----------------------------------------------------------------------
# 排程設定record
#----------------------------------------------------------------------
PUBLIC TYPE SchdSeq_rec RECORD
    schd_no CHAR(4),    #排程批號
    coil_num INTEGER,   #鋼捲數量
    init_no INTEGER #序號初值
END RECORD

#----------------------------------------------------------------------
# COIL_LIST 鋼捲清單架構
#----------------------------------------------------------------------
PUBLIC TYPE COIL_LIST_ITEM RECORD
    SCHD_ORDER INTEGER,
    COIL_NO CHAR(11),
    SCHD_COIL_NO STRING
END RECORD

PUBLIC TYPE COIL_LIST RECORD
    arr DYNAMIC ARRAY OF COIL_LIST_ITEM
END RECORD
    

#-------------------------------------------------
#COIL_LIST methods
#-------------------------------------------------
FUNCTION (src_list COIL_LIST) extendList(status STRING, num INTEGER)
    DEFINE idx, pb, len INTEGER
    DEFINE s_COIL_NO STRING
    DEFINE nextSchdCoil STRING
    DEFINE debug COIL_LIST

    LET debug = src_list
    SET CONNECTION "CR2"

    
    IF status = "init" THEN
        CALL src_list.arr.clear()
        SELECT BP INTO nextSchdCoil FROM czfp320m WHERE SCHD_COIL_NO = ' '
        LET idx = 1
    ELSE
        #查詢模式下不啟動查詢擴充
        IF src_list.arr[1].SCHD_ORDER == 0 THEN
            RETURN
        END IF
    
        LET len = src_list.arr.getLength()
        SELECT BP INTO nextSchdCoil FROM czfp320m
                WHERE SCHD_COIL_NO = src_list.arr[len].SCHD_COIL_NO 
        LET idx = len + 1
        LET num = len + num
    END IF
    
    WHILE TRUE
        TRY
            IF status = "init" THEN
                LET pb = (idx*100/num)
                DISPLAY pb TO schdList_pb
                CALL ui.Interface.refresh()
            END IF
            
            #LET s_tmp = nextSchdCoil
            LET s_COIL_NO = nextSchdCoil.subString(5,15)
            
            IF s_COIL_NO == ' ' THEN
                EXIT WHILE
            END IF
            
            
            LET src_list.arr[idx].SCHD_ORDER = idx
            LET src_list.arr[idx].COIL_NO = nextSchdCoil.subString(5,15)
            LET src_list.arr[idx].SCHD_COIL_NO = nextSchdCoil
            
            SELECT BP INTO nextSchdCoil FROM czfp320m WHERE SCHD_COIL_NO = nextSchdCoil
            LET idx = idx + 1

        CATCH
            #DISPLAY "Error on: ", s_BP
            EXIT WHILE
        END TRY

        IF (idx > num) THEN
            EXIT WHILE
        END IF
    END WHILE

    #DISPLAY ui.Window.getCurrent().getForm().getNode().toString()
    IF status = "init" THEN
        DISPLAY 100 TO schdList_pb
        CALL ui.Window.getCurrent().getForm().
            findNode("FormField","formonly.schdlist_pb").
            setAttribute("hidden","1")
    END IF    
END FUNCTION

#----------------------------------------------------------------------
#放製"修改製程"的各欄位數值
#----------------------------------------------------------------------
FUNCTION (src_rec ModProd_rec) SetUpModProc()
    DEFINE idx INTEGER
    DEFINE n om.DomNode
    DEFINE order_no_item CHAR(9)
    DEFINE s_no, s_item STRING
    DEFINE debug ModProd_rec
    
    SET CONNECTION "PCM"
    
    LET src_rec.apn_code = " "
    LET src_rec.coming_station = " "
    LET src_rec.past_station = " "
    LET src_rec.plan_station = " "
    LET src_rec.prod_thick = " "
    
    #實際路徑
    LET src_rec.coming_station = ""
    
    SELECT ACTL_STATION_CODE, CURR_STATION_INDEX, CB_FIRST_ORDER_ITEM
        INTO src_rec.coming_station, idx, order_no_item FROM pcmb020m
        WHERE COIL_NO = src_rec.coil_no

    LET s_no = order_no_item
    LET s_no = s_no.subString(1,7)
    LET s_item = order_no_item
    LET s_item = s_item.subString(8,9)
    
    #厚度與用途碼
    SELECT ORDER_THICK_AIM, APN_NO 
    INTO src_rec.prod_thick, src_rec.apn_code FROM ordb011m
    WHERE ORDER_NO = s_no AND ORDER_ITEM = s_item

    LET src_rec.past_station =  src_rec.coming_station.subString(1,idx)
    LET src_rec.coming_station =  src_rec.coming_station.subString(idx+1,src_rec.coming_station.getLength())
    
    LET n = ui.Window.getCurrent().getNode()
    LET n = ui.Window.getCurrent().findNode("Label","past_station_fd")
    CALL n.setAttribute("text",src_rec.past_station)
    CALL n.setAttribute("gridWidth",0)

    #標準路徑
    LET src_rec.plan_station = ""
    SELECT PROCESS_CODE
        INTO src_rec.plan_station FROM pcmb100m
        WHERE ORDER_NO = s_no AND ORDER_ITEM = s_item
    LET debug = src_rec
    LET src_rec.plan_station = sys_ProcToActl(src_rec.plan_station)
END FUNCTION

FUNCTION sys_procToActl(src STRING)
    DEFINE len, a_len, i, j, idx INTEGER
    DEFINE x CHAR(1), p_key CHAR(2)
    DEFINE res STRING
    DEFINE proc_seq_arr DYNAMIC ARRAY OF sys_ProcSeq

    #----- 取得製程對應列表 -----
    SET CONNECTION "PCM"

    LET idx = 1
    DECLARE CS CURSOR FROM "select PKEY, PROC_SEQ from pcmy020m"
    
    FOREACH CS INTO proc_seq_arr[idx].*
        LET idx = idx + 1
    END FOREACH
    CALL proc_seq_arr.deleteElement(idx)

    #----- 以對應列表生成預設製程 -----
    LET len = proc_seq_arr.getLength()
    
    LET len = src.getLength()
    LET a_len = proc_seq_arr.getLength()
    LET res = src.getCharAt(1)

    FOR i = 1 TO len
        LET x = src.getCharAt(i)
        LET p_key = (i-1) || x
        #DISPLAY "p_key:",p_key
        IF (i-1) != 0 AND x != "0" THEN
            FOR j = 1 TO a_len
                IF proc_seq_arr[j].PKEY == p_key THEN
                    LET res = res ||  proc_seq_arr[j].PROC_SEQ clipped
                    EXIT FOR
                END IF
            END FOR
        END IF
    END FOR

    LET res = res || "$"
    RETURN res
END FUNCTION