IMPORT FGL CCAP321W_DB
IMPORT FGL CCAP321W_LIST
IMPORT FGL CCAP322W_DB
IMPORT FGL CCAP322W_LIST
IMPORT FGL CPSCAP_INC

SCHEMA orapcm

#篩選條件record
PUBLIC TYPE funCond_rec RECORD
    COND_NAME STRING,   #條件名稱
    CURR_STATION STRING,    #當站製程
    PREV_STATION STRING,    #上一站製程
    NEXT_STATION STRING,    #下一站製程
    COIL_WIDTH_MIN STRING,  #最小鋼捲寬度
    COIL_WIDTH_MAX STRING,  #最大鋼捲寬度
    COIL_STATE STRING,  #鋼捲狀態碼
    FACTORY STRING  #廠區
END RECORD

PUBLIC TYPE funCond_list RECORD
    arr DICTIONARY OF funCond_rec
END RECORD

PUBLIC TYPE funCoil_rec RECORD
    COIL_PRODUCT STRING,   #鋼捲類型
    COIL_IN_DIAM INTEGER,
    CRM_STATION BOOLEAN
END RECORD
PUBLIC TYPE funCoil_list RECORD
    arr DICTIONARY OF funCoil_rec
END RECORD

#----------------------------------------------------------------------
#從依選取條件將資料載入粗排陣列(P322W_arr)
#1. COIL_NO = pcmb020m.COIL_NO
#5. STEEL_GRADE = pcmb020m.STEEL_GRADE
#6. COIL_WIDTH = pcmb020m.COIL_WIDTH
#7. COIL_THICK = pcmb020m.COIL_THICK
#9. REDUCTION = (COIL_THICK - OUT_THICK)/COIL_THICK*100
#10.COIL_WT = pcmb020m.COIL_WEIGHT
#11.PREV_STATION = pcmb020m.PREV_STATION
#12.NEXT_STATION = pcmb020m.NEXT_STATION
#13.ORDER_NO_ITEM = pcmb020m.CB_FIRST_ORDER_ITEM
#14.DUE_DATE = YUPCM.ordb011m.DELIVERY_DATE
#15.RUSH_CODE_PP = YUPCM.ordb011m.RUSH_CODE_PP
#16.CLASS_CODE = pcmb020m.CLASS_CODE
#17.IC_CODE = pcmb020m.IC_CODE
#18.APN_CODE = pcmb020m.ACTL_STATION_CODE[1]||YUPCM.ordb011m.APN_NO[3:4] ???
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# 以篩選條件提取、轉置並載入至粗排清單(P322W)
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_rec funCond_rec) etlToP322W(condition_sub STRING,coil_main funCoil_rec) RETURNS CCAP322W_LIST
    DEFINE res_p322 CCAP322W_LIST
    DEFINE s_sql_select, s_sql_count, s_sql,pcmb100m_sql STRING
    DEFINE p_max, p_count INTEGER--條件篩選後數量, 載入進度
    DEFINE idx, len,J INTEGER
    CALL res_p322.arr.clear()
    IF coil_main.COIL_PRODUCT IS NULL THEN
        RETURN res_p322
    END IF
    DISPLAY coil_main.COIL_PRODUCT
    DISPLAY "CRM_STATION=",coil_main.CRM_STATION

    LET s_sql_select =
        "SELECT COIL_NO, '', '', SUBSTR(STEEL_GRADE,2,5), COIL_WIDTH, COIL_THICK, COIL_WEIGHT, " 
            || " ic_code, prev_station, curr_station, next_station, '' ,CURR_STATION_CODE,0,CURR_STATION_INDEX,"
            || " CB_FIRST_ORDER_ITEM,'', '','','','',line_marking,0,edging,0,0  "
    LET s_sql_count = "SELECT COUNT(COIL_NO) "
    LET s_sql = " FROM PCMB020M "
            || " WHERE CURR_STATION "
            || src_rec.CURR_STATION
    #上製程條件
    IF src_rec.PREV_STATION IS NOT NULL THEN
        LET s_sql = s_sql || " and " || " PREV_STATION " || src_rec.PREV_STATION
    END IF
    #下製程條件
    IF src_rec.NEXT_STATION IS NOT NULL THEN
        LET s_sql = s_sql || " and " || " NEXT_STATION " || src_rec.NEXT_STATION
    END IF
   
    #最小寬度條件
    IF src_rec.COIL_WIDTH_MIN IS NOT NULL THEN
        LET s_sql = s_sql || " and " || " COIL_WIDTH " || src_rec.COIL_WIDTH_MIN
    END IF
    #最大寬度條件
    IF src_rec.COIL_WIDTH_MAX IS NOT NULL THEN
        LET s_sql = s_sql || " and " || " COIL_WIDTH " || src_rec.COIL_WIDTH_MAX
    END IF
    #鋼捲狀態條件
    IF src_rec.COIL_STATE IS NOT NULL THEN
        LET s_sql = s_sql || " and " || " IC_CODE " || src_rec.COIL_STATE
    END IF
    #廠區條件
    IF src_rec.FACTORY IS NOT NULL THEN
        LET s_sql = s_sql || " and " || " FACTORY " || src_rec.FACTORY
    END IF
    
    #鋼種條件
    IF condition_sub == "2" OR condition_sub == "3" OR condition_sub == "4" THEN
        LET s_sql =
            s_sql
                || " and "
                || " SUBSTR(STEEL_GRADE,2,1) ='"
                || condition_sub
                || "'"
    END IF
    
    SET CONNECTION "PCM"
    
    PREPARE s_stat FROM s_sql_count || s_sql
    EXECUTE s_stat INTO p_max
    PREPARE s_stat FROM s_sql_select || s_sql
    DECLARE cs01 CURSOR FOR s_stat

    LET idx = 1
    LET J = 1
    FOREACH cs01 INTO res_p322.arr[idx].*
        LET p_count = idx*33/p_max
        DISPLAY p_count TO select_pb
        CALL ui.Interface.refresh()
        LET pcmb100m_sql = "select coil_in_diam from pcmb100m where order_no='" || 
        res_p322.arr[idx].order_no_item[1,7] ||
        "' and order_item='" || res_p322.arr[idx].order_no_item[8,9] ||"'"
        DISPLAY "尚未開始=",pcmb100m_sql
        PREPARE pcmb100m_stat FROM pcmb100m_sql
        
        DECLARE pcmb100m_cursor CURSOR FOR pcmb100m_stat
        
        FOREACH pcmb100m_cursor INTO res_p322.arr[idx].coil_in_diam
        
            IF  coil_main.COIL_PRODUCT == "再製鋼捲" THEN
            
                IF res_p322.arr[idx].coil_in_diam <> 508 and res_p322.arr[idx].next_station <> 'CRM' THEN
                    
                    CALL res_p322.arr.deleteElement(res_p322.arr.getLength())
                ELSE 
                
                    LET idx = res_p322.arr.getLength() + 1
                END if
            ELSE 
               IF res_p322.arr[idx].coil_in_diam == 508 or res_p322.arr[idx].next_station == 'CRM' THEN
                    CALL res_p322.arr.deleteElement(res_p322.arr.getLength())
               ELSE 
                    LET idx = res_p322.arr.getLength() + 1
               END IF
            END IF
        END FOREACH
        
    END FOREACH

    LET idx = 1
    FREE s_stat

    LET len = res_p322.arr.getLength()
    
    #刪除NULL元素成員
    FOR idx = 1 TO len
        IF res_p322.arr[idx].COIL_NO IS NULL THEN
            CALL res_p322.arr.deleteElement(idx)
        END IF
    END FOR

-- END PCMB020M --
-- ORDB011M --
    LET len = res_p322.arr.getLength()     
    #從ordb011m抓取粗排欄位所需數據
    #14.DUE_DATE = YUPCM.ordb011m.DELIVERY_DATE
    #15.RUSH_CODE_PP = YUPCM.ordb011m.RUSH_CODE_PP
    #18.APN_CODE = YUPCM.ordb011m.APN_NO
    FOR idx=1 TO len
        LET p_count = 33 + idx*33/len
        DISPLAY p_count TO select_pb
        CALL ui.Interface.refresh()
    #急訂單,用途碼與APL_ROUTE
        CALL res_p322.arr[idx].getORDB011M()
    END FOR
    FREE s_stat
--END ORDB011M --

    #非能直接從DB來的欄位資料
    #8.OUT_THICK 出料欄位
    #9.REDUCTION 軋延欄位
    #18.APN_CODE = pcmb020m.ACTL_STATION_CODE[1]||YUPCM.ordb011m.APN_NO[3:4] ???
    FOR idx=1 TO len
        LET p_count = 66 + idx*34/p_max
        DISPLAY p_count TO select_pb
        CALL ui.Interface.refresh()
    END FOR

    #資料排序
    CALL res_p322.sort()
    
    RETURN res_p322
END FUNCTION



PUBLIC FUNCTION (src_list funCoil_list) loadCoilProduct(arg_fd_node STRING)
    DEFINE cb_node ui.ComboBox
    LET cb_node = ui.ComboBox.forName(arg_fd_node)
    CALL cb_node.clear()
    LET src_list.arr["REMAKE"].COIL_PRODUCT = "再製鋼捲"
    LET src_list.arr["REMAKE"].COIL_IN_DIAM = "= 508 "
    LET src_list.arr["REMAKE"].CRM_STATION = TRUE
    CALL cb_node.addItem("REMAKE", src_list.arr["REMAKE"].COIL_PRODUCT)
    LET src_list.arr["PAY"].COIL_PRODUCT = "直繳鋼捲"
    LET src_list.arr["PAY"].COIL_IN_DIAM = "<> 508 "
    LET src_list.arr["PAY"].CRM_STATION = FALSE
    CALL cb_node.addItem("PAY", src_list.arr["PAY"].COIL_PRODUCT)
END FUNCTION
#----------------------------------------------------------------------
# 載入靜態篩選規則至Cond List及Form上的combobox node 
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list funCond_list) loadCondition(arg_fd_node STRING)
    DEFINE cb_node ui.ComboBox
    LET cb_node = ui.ComboBox.forName(arg_fd_node)
    CALL cb_node.clear()
    
    #米尺寬度
    LET src_list.arr["METER_WIDTH"].COND_NAME = "米尺寬度"
    LET src_list.arr["METER_WIDTH"].COIL_WIDTH_MIN = " >= 500 "
    LET src_list.arr["METER_WIDTH"].COIL_WIDTH_MAX = " <= 1100 "
    LET src_list.arr["METER_WIDTH"].COIL_STATE = "in ('32', '84')"
    LET src_list.arr["METER_WIDTH"].FACTORY = "='A'"
    LET src_list.arr["METER_WIDTH"].CURR_STATION = "in ('CAP')"
    LET src_list.arr["METER_WIDTH"].NEXT_STATION = NULL
    LET src_list.arr["METER_WIDTH"].PREV_STATION = "in ('CRM')"
    CALL cb_node.addItem("METER_WIDTH", src_list.arr["METER_WIDTH"].COND_NAME)

    #四呎寬度
    LET src_list.arr["FEET4_WIDTH"].COND_NAME = "四呎寬度"
    LET src_list.arr["FEET4_WIDTH"].PREV_STATION = "in ('CRM')"
    LET src_list.arr["FEET4_WIDTH"].CURR_STATION = "in ('CAP')"
    LET src_list.arr["FEET4_WIDTH"].NEXT_STATION = NULL
    LET src_list.arr["FEET4_WIDTH"].COIL_WIDTH_MIN = " >= 1101 "
    LET src_list.arr["FEET4_WIDTH"].COIL_WIDTH_MAX = " <= 1300 "
    LET src_list.arr["FEET4_WIDTH"].COIL_STATE = "in ('32', '84')"
    LET src_list.arr["FEET4_WIDTH"].FACTORY = "='A'"
    CALL cb_node.addItem("FEET4_WIDTH", src_list.arr["FEET4_WIDTH"].COND_NAME)

    #五呎寬度
    LET src_list.arr["FEET5_WIDTH"].COND_NAME = "五呎寬度"
    LET src_list.arr["FEET5_WIDTH"].PREV_STATION = "in ('CRM')"
    LET src_list.arr["FEET5_WIDTH"].CURR_STATION = "in ('CAP')"
    LET src_list.arr["FEET5_WIDTH"].NEXT_STATION = NULL
    LET src_list.arr["FEET5_WIDTH"].COIL_WIDTH_MIN = " >= 1301 "
    LET src_list.arr["FEET5_WIDTH"].COIL_WIDTH_MAX = " <= 1600 "
    LET src_list.arr["FEET5_WIDTH"].COIL_STATE = "in ('32', '84')"
    LET src_list.arr["FEET5_WIDTH"].FACTORY = "='A'"
    CALL cb_node.addItem("FEET5_WIDTH", src_list.arr["FEET5_WIDTH"].COND_NAME)
    #生產預排搬運料
    LET src_list.arr["PRE_STATION"].COND_NAME = "生產預排搬運料"
    LET src_list.arr["PRE_STATION"].PREV_STATION = NULL
    LET src_list.arr["PRE_STATION"].CURR_STATION = "in ('CAP')"
    LET src_list.arr["PRE_STATION"].NEXT_STATION = NULL
    LET src_list.arr["PRE_STATION"].COIL_WIDTH_MIN = NULL
    LET src_list.arr["PRE_STATION"].COIL_WIDTH_MAX = NULL
    LET src_list.arr["PRE_STATION"].COIL_STATE = "= '31'"
    LET src_list.arr["PRE_STATION"].FACTORY = "='A'"
    CALL cb_node.addItem("PRE_STATION", src_list.arr["PRE_STATION"].COND_NAME)
    #生產預排排程料(CRM)
    LET src_list.arr["PRE_STATION_CRM"].COND_NAME = "生產預排搬運料(CRM)"
    LET src_list.arr["PRE_STATION_CRM"].PREV_STATION = NULL
    LET src_list.arr["PRE_STATION_CRM"].CURR_STATION = "in ('CRM')"
    LET src_list.arr["PRE_STATION_CRM"].NEXT_STATION = "='CAP'"
    LET src_list.arr["PRE_STATION_CRM"].COIL_WIDTH_MIN = " >= 500 "
    LET src_list.arr["PRE_STATION_CRM"].COIL_WIDTH_MAX = " <= 1600 "
    LET src_list.arr["PRE_STATION_CRM"].COIL_STATE = "in ('46')"
    LET src_list.arr["PRE_STATION_CRM"].FACTORY = "='A'"
    CALL cb_node.addItem("PRE_STATION_CRM", src_list.arr["PRE_STATION_CRM"].COND_NAME)
    #重酸或其它
    LET src_list.arr["RE_ACID"].COND_NAME = "重酸或其它"
    LET src_list.arr["RE_ACID"].PREV_STATION = NULL
    LET src_list.arr["RE_ACID"].CURR_STATION = "in ('CRM')"
    LET src_list.arr["RE_ACID"].NEXT_STATION = NULL
    LET src_list.arr["RE_ACID"].COIL_WIDTH_MIN = " >= 1101 "
    LET src_list.arr["RE_ACID"].COIL_WIDTH_MAX = " <= 1300 "
    LET src_list.arr["RE_ACID"].COIL_STATE = "in ('32', '83')"
    LET src_list.arr["RE_ACID"].FACTORY = "='C'"
    CALL cb_node.addItem("RE_ACID", src_list.arr["RE_ACID"].COND_NAME)
    
END FUNCTION
