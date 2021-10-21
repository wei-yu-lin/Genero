IMPORT FGL CZFP321W_DB
IMPORT FGL CZFP321W_LIST
IMPORT FGL CZFP322W_DB
IMPORT FGL CZFP322W_LIST
IMPORT FGL CPSCR6_INC

SCHEMA orapcm

#篩選條件record
PUBLIC TYPE funCond_rec RECORD
    COND_NAME STRING,   #條件名稱
    CURR_STATION STRING,    #上一站製程
    NEXT_STATION STRING,    #下一站製程
    PROD_CODE STRING,   #產品碼
    COIL_WIDTH_MIN STRING,  #最小鋼捲寬度
    COIL_WIDTH_MAX STRING,  #最大鋼捲寬度
    COIL_STATE STRING,  #鋼捲狀態碼
    FACTORY STRING  #廠區
END RECORD

PUBLIC TYPE funCond_list RECORD
    arr DICTIONARY OF funCond_rec
END RECORD

#----------------------------------------------------------------------
#從依選取條件將資料載入粗排陣列(P322W_arr)
#1. COIL_NO = pcmb020m.COIL_NO
#5. STEEL_GRADE = pcmb020m.STEEL_GRADE
#6. COIL_WIDTH = pcmb020m.COIL_WIDTH
#7. COIL_THICK = pcmb020m.COIL_THICK
#8. OUT_THICK = getOutThick(...)
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
PUBLIC FUNCTION (src_rec funCond_rec) etlToP322W(condition_sub STRING) RETURNS CZFP322W_LIST
    DEFINE res_p322 CZFP322W_LIST
    DEFINE s_sql_select, s_sql_count, s_sql STRING
    DEFINE p_max, p_count INTEGER--條件篩選後數量, 載入進度
    DEFINE idx, len INTEGER
    
    CALL res_p322.arr.clear()
    IF src_rec.COND_NAME IS NULL THEN
        RETURN res_p322
    END IF
    
--PCMB020M --
    #從pcmb020m抓取粗排欄位所需數據
    #1. COIL_NO = pcmb020m.COIL_NO
    #5. STEEL_GRADE = pcmb020m.STEEL_GRADE
    #6. COIL_WIDTH = pcmb020m.COIL_WIDTH
    #7. COIL_THICK = pcmb020m.COIL_THICK
    #10.COIL_WT = pcmb020m.COIL_WEIGHT
    #11.PREV_STATION = pcmb020m.PREV_STATION
    #12.NEXT_STATION = pcmb020m.NEXT_STATION
    #13.ORDER_NO_ITEM = pcmb020m.CB_FIRST_ORDER_ITEM
    #16.CLASS_CODE = pcmb020m.CLASS_CODE
    #17.IC_CODE = pcmb020m.IC_CODE
    LET s_sql_select =
        "SELECT COIL_NO, '', '', '', SUBSTR(STEEL_GRADE,2,5), COIL_WIDTH, COIL_THICK, 0, " 
            || " 0, COIL_WEIGHT, PREV_STATION, NEXT_STATION, CB_FIRST_ORDER_ITEM ,"
            || " '', '', CLASS_CODE, IC_CODE, ''  "
    LET s_sql_count = "SELECT COUNT(COIL_NO) "
    LET s_sql = " FROM PCMB020M "
            || " WHERE CURR_STATION "
            || src_rec.CURR_STATION
    #下製程條件
    IF src_rec.NEXT_STATION IS NOT NULL THEN
        LET s_sql = s_sql || " and " || " NEXT_STATION " || src_rec.NEXT_STATION
    END IF
    #產品碼條件
    IF src_rec.PROD_CODE IS NOT NULL THEN
        LET s_sql =
            s_sql
                || " and "
                || " SUBSTR(ACTL_STATION_CODE,1,1) "
                || src_rec.PROD_CODE
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
    FOREACH cs01 INTO res_p322.arr[idx].*
        LET p_count = idx*33/p_max
        DISPLAY p_count TO select_pb
        CALL ui.Interface.refresh()
    
        #若已被其他軋機預排排程則排除，以避免誤排
        #IF condition_main == "P_PREV_STATION" THEN
            #生產預排條件選取時
            #避免已被預排的鋼捲重複排程
            IF res_p322.arr[idx].existInZA() || res_p322.arr[idx].existInZB() ||
                res_p322.arr[idx].existInZC() || res_p322.arr[idx].existInZD() ||
                res_p322.arr[idx].existInZE() || res_p322.arr[idx].existInZF() THEN
                CALL res_p322.arr.deleteElement(idx)
                SET CONNECTION "PCM"
                CONTINUE FOREACH
            END IF
        #END IF
        SET CONNECTION "PCM"
        LET len = res_p322.arr.getLength()
        
        LET idx = idx + 1
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

        CALL res_p322.arr[idx].getOutThick()
        CALL res_p322.arr[idx].getReduction()
    END FOR

    #資料排序
    CALL res_p322.sort()
    
    RETURN res_p322
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
    LET src_list.arr["METER_WIDTH"].CURR_STATION = "in ('CRM')"
    LET src_list.arr["METER_WIDTH"].NEXT_STATION = NULL
    LET src_list.arr["METER_WIDTH"].PROD_CODE = NULL
    LET src_list.arr["METER_WIDTH"].COIL_WIDTH_MIN = " >= 300 "
    LET src_list.arr["METER_WIDTH"].COIL_WIDTH_MAX = " <= 1100 "
    LET src_list.arr["METER_WIDTH"].COIL_STATE = "in ('32', '83')"
    LET src_list.arr["METER_WIDTH"].FACTORY = "='C'"
    CALL cb_node.addItem("METER_WIDTH", src_list.arr["METER_WIDTH"].COND_NAME)

    #四呎寬度2B/2D
    LET src_list.arr["FEET4_WIDTH"].COND_NAME = "四呎寬度2B/2D"
    LET src_list.arr["FEET4_WIDTH"].CURR_STATION = "in ('CRM')"
    LET src_list.arr["FEET4_WIDTH"].NEXT_STATION = NULL
    LET src_list.arr["FEET4_WIDTH"].PROD_CODE = "in ('D', 'G', 'B', 'U')"
    LET src_list.arr["FEET4_WIDTH"].COIL_WIDTH_MIN = " >= 1101 "
    LET src_list.arr["FEET4_WIDTH"].COIL_WIDTH_MAX = " <= 1300 "
    LET src_list.arr["FEET4_WIDTH"].COIL_STATE = "in ('32', '83')"
    LET src_list.arr["FEET4_WIDTH"].FACTORY = "='C'"
    CALL cb_node.addItem("FEET4_WIDTH", src_list.arr["FEET4_WIDTH"].COND_NAME)

    #2D產品
    LET src_list.arr["PROD_2D"].COND_NAME = "2D產品"
    LET src_list.arr["PROD_2D"].CURR_STATION = "in ('CRM')"
    LET src_list.arr["PROD_2D"].NEXT_STATION = NULL
    LET src_list.arr["PROD_2D"].PROD_CODE = "in ('D')"
    LET src_list.arr["PROD_2D"].COIL_WIDTH_MIN = " >= 300 "
    LET src_list.arr["PROD_2D"].COIL_WIDTH_MAX = " <= 1300 "
    LET src_list.arr["PROD_2D"].COIL_STATE = "in ('32', '83')"
    LET src_list.arr["PROD_2D"].FACTORY = "='C'"
    CALL cb_node.addItem("PROD_2D", src_list.arr["PROD_2D"].COND_NAME)

    #下製程酸洗用料(CAP)
    LET src_list.arr["NEXT_CAP"].COND_NAME = "下製程酸洗用料(CAP)"
    LET src_list.arr["NEXT_CAP"].CURR_STATION = "in ('CRM')"
    LET src_list.arr["NEXT_CAP"].NEXT_STATION = "in ('CAP')"
    LET src_list.arr["NEXT_CAP"].PROD_CODE = NULL
    LET src_list.arr["NEXT_CAP"].COIL_WIDTH_MIN = " >= 300 "
    LET src_list.arr["NEXT_CAP"].COIL_WIDTH_MAX = " <= 1300 "
    LET src_list.arr["NEXT_CAP"].COIL_STATE = "in ('32', '83')"
    LET src_list.arr["NEXT_CAP"].FACTORY = "='C'"
    CALL cb_node.addItem("NEXT_CAP", src_list.arr["NEXT_CAP"].COND_NAME)

    #下製程煇面用料(BAL)
    LET src_list.arr["NEXT_BAL"].COND_NAME = "下製程煇面用料(BAL)"
    LET src_list.arr["NEXT_BAL"].CURR_STATION = "in ('CRM')"
    LET src_list.arr["NEXT_BAL"].NEXT_STATION = "in ('BAL')"
    LET src_list.arr["NEXT_BAL"].PROD_CODE = NULL
    LET src_list.arr["NEXT_BAL"].COIL_WIDTH_MIN = " >= 300 "
    LET src_list.arr["NEXT_BAL"].COIL_WIDTH_MAX = " <= 1300 "
    LET src_list.arr["NEXT_BAL"].COIL_STATE = "in ('32', '83')"
    LET src_list.arr["NEXT_BAL"].FACTORY = "='C'"
    CALL cb_node.addItem("NEXT_BAL", src_list.arr["NEXT_BAL"].COND_NAME)

    #下製程其他用料(XXX)
    LET src_list.arr["NEXT_OTH"].COND_NAME = "下製程其他用料(XXX)"
    LET src_list.arr["NEXT_OTH"].CURR_STATION = "in ('CRM')"
    LET src_list.arr["NEXT_OTH"].NEXT_STATION = "not in ('BAL', 'CAP')"
    LET src_list.arr["NEXT_OTH"].PROD_CODE = NULL
    LET src_list.arr["NEXT_OTH"].COIL_WIDTH_MIN = " >= 300 "
    LET src_list.arr["NEXT_OTH"].COIL_WIDTH_MAX = " <= 1300 "
    LET src_list.arr["NEXT_OTH"].COIL_STATE = "in ('32', '83')"
    LET src_list.arr["NEXT_OTH"].FACTORY = "='C'"
    CALL cb_node.addItem("NEXT_OTH", src_list.arr["NEXT_OTH"].COND_NAME)
    
    #生產預排上製程
    CALL cb_node.addItem("P_PREV_STATION", "生產預排上製程")
    #生產預排上製程HAP
    LET src_list.arr["PREV_HAP"].COND_NAME = "生產預排上製程HAP"
    LET src_list.arr["PREV_HAP"].CURR_STATION = "in ('HAP')"
    LET src_list.arr["PREV_HAP"].NEXT_STATION = "in ('CRM')"
    LET src_list.arr["PREV_HAP"].PROD_CODE = "in ('D', 'G', 'B', 'U')"
    LET src_list.arr["PREV_HAP"].COIL_WIDTH_MIN = " >= 300 "
    LET src_list.arr["PREV_HAP"].COIL_WIDTH_MAX = " <= 1300 "
    LET src_list.arr["PREV_HAP"].COIL_STATE = "in ('46')"
    LET src_list.arr["PREV_HAP"].FACTORY = "='A'"

    #生產預排上製程AP3
    LET src_list.arr["PREV_AP3"].COND_NAME = "生產預排上製程AP3"
    LET src_list.arr["PREV_AP3"].CURR_STATION = "in ('AP3')"
    LET src_list.arr["PREV_AP3"].NEXT_STATION = "in ('CRM')"
    LET src_list.arr["PREV_AP3"].PROD_CODE = "in ('D', 'G', 'B', 'U')"
    LET src_list.arr["PREV_AP3"].COIL_WIDTH_MIN = " >= 300 "
    LET src_list.arr["PREV_AP3"].COIL_WIDTH_MAX = " <= 1300 "
    LET src_list.arr["PREV_AP3"].COIL_STATE = "in ('46')"
    LET src_list.arr["PREV_AP3"].FACTORY = "='B'"

    #生產預排上製程CPL
    LET src_list.arr["PREV_CPL"].COND_NAME = "生產預排上製程CPL"
    LET src_list.arr["PREV_CPL"].CURR_STATION = "in ('CPL')"
    LET src_list.arr["PREV_CPL"].NEXT_STATION = "in ('CRM')"
    LET src_list.arr["PREV_CPL"].PROD_CODE = NULL
    LET src_list.arr["PREV_CPL"].COIL_WIDTH_MIN = NULL--" >= 300 "
    LET src_list.arr["PREV_CPL"].COIL_WIDTH_MAX = NULL--" <= 1300 "
    LET src_list.arr["PREV_CPL"].COIL_STATE = "in ('46')"
    LET src_list.arr["PREV_CPL"].FACTORY = "='A'"
    
    #生產預排上製程AP4
    LET src_list.arr["PREV_AP4"].COND_NAME = "生產預排上製程AP4"
    LET src_list.arr["PREV_AP4"].CURR_STATION = "in ('AP4')"
    LET src_list.arr["PREV_AP4"].NEXT_STATION = "in ('CRM')"
    LET src_list.arr["PREV_AP4"].PROD_CODE = "in ('D', 'G', 'B', 'U')"
    LET src_list.arr["PREV_AP4"].COIL_WIDTH_MIN = " >= 300 "
    LET src_list.arr["PREV_AP4"].COIL_WIDTH_MAX = " <= 1300 "
    LET src_list.arr["PREV_AP4"].COIL_STATE = "in ('46')"
    LET src_list.arr["PREV_AP4"].FACTORY = "='C'"
    
END FUNCTION