IMPORT FGL CZFP321W_DB
IMPORT FGL fgldialog

SCHEMA oracr2

#-------------------------------------------------------
# CZFP322W
#-------------------------------------------------------
PUBLIC TYPE CZFP322W RECORD
    COIL_NO LIKE CZFP322W.COIL_NO,
    FLAG LIKE CZFP322W.FLAG,
    BP LIKE CZFP322W.BP,
    FP LIKE CZFP322W.FP,
    STEEL_GRADE LIKE CZFP322W.STEEL_GRADE,
    COIL_WIDTH LIKE CZFP322W.COIL_WIDTH,
    COIL_THICK LIKE CZFP322W.COIL_THICK,
    OUT_THICK LIKE CZFP322W.OUT_THICK,
    REDUCTION LIKE CZFP322W.REDUCTION,
    COIL_WT LIKE CZFP322W.COIL_WT,
    PREV_STATION LIKE CZFP322W.PREV_STATION,
    NEXT_STATION LIKE CZFP322W.NEXT_STATION,
    ORDER_NO_ITEM LIKE CZFP322W.ORDER_NO_ITEM,
    DUE_DATE LIKE CZFP322W.DUE_DATE,
    RUSH_CODE_PP LIKE CZFP322W.RUSH_CODE_PP,
    CLASS_CODE LIKE CZFP322W.CLASS_CODE,
    IC_CODE LIKE CZFP322W.IC_CODE,
    APN_CODE LIKE CZFP322W.APN_CODE,
    SPARE LIKE CZFP322W.SPARE,
    APL_ROUTE LIKE CZFP322W.APL_ROUTE
END RECORD

#-------------------------------------------------------
# INITIAL CZFP322W RECORD
#-------------------------------------------------------
FUNCTION (src_rec CZFP322W) init()
    INITIALIZE src_rec.* TO NULL
END FUNCTION

#-------------------------------------------------------
# INSERT CZFP322W
#-------------------------------------------------------
FUNCTION (src_rec CZFP322W) ins()
    SET CONNECTION "CR2"
    INSERT INTO CZFP322W VALUES (src_rec.*)
END FUNCTION

#-------------------------------------------------------
# UPDATE CZFP322W
#-------------------------------------------------------
FUNCTION (src_rec CZFP322W) upd()
    SET CONNECTION "CR2"

    IF src_rec.coil_no == "*" THEN
        UPDATE CZFP322W SET
            FLAG = NVL(src_rec.FLAG, FLAG),
            BP = NVL(src_rec.BP, BP),
            FP = NVL(src_rec.FP, FP),
            STEEL_GRADE = NVL(src_rec.STEEL_GRADE, STEEL_GRADE),
            COIL_WIDTH = NVL(src_rec.COIL_WIDTH, COIL_WIDTH),
            COIL_THICK = NVL(src_rec.COIL_THICK, COIL_THICK),
            OUT_THICK = NVL(src_rec.OUT_THICK, OUT_THICK),
            REDUCTION = NVL(src_rec.REDUCTION, REDUCTION),
            COIL_WT = NVL(src_rec.COIL_WT, COIL_WT),
            PREV_STATION = NVL(src_rec.PREV_STATION, PREV_STATION),
            NEXT_STATION = NVL(src_rec.NEXT_STATION, NEXT_STATION),
            ORDER_NO_ITEM = NVL(src_rec.ORDER_NO_ITEM, ORDER_NO_ITEM),
            DUE_DATE = NVL(src_rec.DUE_DATE, DUE_DATE),
            RUSH_CODE_PP = NVL(src_rec.RUSH_CODE_PP, RUSH_CODE_PP),
            CLASS_CODE = NVL(src_rec.CLASS_CODE, CLASS_CODE),
            IC_CODE = NVL(src_rec.IC_CODE, IC_CODE),
            APN_CODE = NVL(src_rec.APN_CODE, APN_CODE),
            SPARE = NVL(src_rec.SPARE, SPARE),
            APL_ROUTE = NVL(src_rec.APL_ROUTE, APL_ROUTE)
    ELSE
        UPDATE CZFP322W SET
            FLAG = NVL(src_rec.FLAG, FLAG),
            BP = NVL(src_rec.BP, BP),
            FP = NVL(src_rec.FP, FP),
            STEEL_GRADE = NVL(src_rec.STEEL_GRADE, STEEL_GRADE),
            COIL_WIDTH = NVL(src_rec.COIL_WIDTH, COIL_WIDTH),
            COIL_THICK = NVL(src_rec.COIL_THICK, COIL_THICK),
            OUT_THICK = NVL(src_rec.OUT_THICK, OUT_THICK),
            REDUCTION = NVL(src_rec.REDUCTION, REDUCTION),
            COIL_WT = NVL(src_rec.COIL_WT, COIL_WT),
            PREV_STATION = NVL(src_rec.PREV_STATION, PREV_STATION),
            NEXT_STATION = NVL(src_rec.NEXT_STATION, NEXT_STATION),
            ORDER_NO_ITEM = NVL(src_rec.ORDER_NO_ITEM, ORDER_NO_ITEM),
            DUE_DATE = NVL(src_rec.DUE_DATE, DUE_DATE),
            RUSH_CODE_PP = NVL(src_rec.RUSH_CODE_PP, RUSH_CODE_PP),
            CLASS_CODE = NVL(src_rec.CLASS_CODE, CLASS_CODE),
            IC_CODE = NVL(src_rec.IC_CODE, IC_CODE),
            APN_CODE = NVL(src_rec.APN_CODE, APN_CODE),
            SPARE = NVL(src_rec.SPARE, SPARE),
            APL_ROUTE = NVL(src_rec.APL_ROUTE, APL_ROUTE)
        WHERE COIL_NO = src_rec.coil_no
    END IF
END FUNCTION

FUNCTION (src_rec CZFP322W) updByWhere(arg_where STRING)
    DEFINE s_sql STRING
    SET CONNECTION "CR2"

    LET s_sql = "UPDATE CZFP322W SET "
    IF src_rec.FLAG IS NOT NULL THEN LET s_sql = s_sql || " FLAG = '"|| src_rec.FLAG ||"'," END IF
    IF src_rec.BP IS NOT NULL THEN LET s_sql = s_sql || " BP = '"|| src_rec.BP ||"'," END IF
    IF src_rec.FP IS NOT NULL THEN LET s_sql = s_sql || " FP = '"|| src_rec.FP ||"'," END IF
    IF src_rec.STEEL_GRADE IS NOT NULL THEN LET s_sql = s_sql || " STEEL_GRADE = '"|| src_rec.STEEL_GRADE ||"'," END IF
    IF src_rec.COIL_WIDTH IS NOT NULL THEN LET s_sql = s_sql || " COIL_WIDTH = '"|| src_rec.COIL_WIDTH ||"'," END IF
    IF src_rec.COIL_THICK IS NOT NULL THEN LET s_sql = s_sql || " COIL_THICK = '"|| src_rec.COIL_THICK ||"'," END IF
    IF src_rec.OUT_THICK IS NOT NULL THEN LET s_sql = s_sql || " OUT_THICK = '"|| src_rec.OUT_THICK ||"'," END IF
    IF src_rec.REDUCTION IS NOT NULL THEN LET s_sql = s_sql || " REDUCTION = '"|| src_rec.REDUCTION ||"'," END IF
    IF src_rec.COIL_WT IS NOT NULL THEN LET s_sql = s_sql || " COIL_WT = '"|| src_rec.COIL_WT ||"'," END IF
    IF src_rec.PREV_STATION IS NOT NULL THEN LET s_sql = s_sql || " PREV_STATION = '"|| src_rec.PREV_STATION ||"'," END IF
    IF src_rec.NEXT_STATION IS NOT NULL THEN LET s_sql = s_sql || " NEXT_STATION = '"|| src_rec.NEXT_STATION ||"'," END IF
    IF src_rec.ORDER_NO_ITEM IS NOT NULL THEN LET s_sql = s_sql || " ORDER_NO_ITEM = '"|| src_rec.ORDER_NO_ITEM ||"'," END IF
    IF src_rec.DUE_DATE IS NOT NULL THEN LET s_sql = s_sql || " DUE_DATE = '"|| src_rec.DUE_DATE ||"'," END IF
    IF src_rec.RUSH_CODE_PP IS NOT NULL THEN LET s_sql = s_sql || " RUSH_CODE_PP = '"|| src_rec.RUSH_CODE_PP ||"'," END IF
    IF src_rec.CLASS_CODE IS NOT NULL THEN LET s_sql = s_sql || " CLASS_CODE = '"|| src_rec.CLASS_CODE ||"'," END IF
    IF src_rec.IC_CODE IS NOT NULL THEN LET s_sql = s_sql || " IC_CODE = '"|| src_rec.IC_CODE ||"'," END IF
    IF src_rec.APN_CODE IS NOT NULL THEN LET s_sql = s_sql || " APN_CODE = '"|| src_rec.APN_CODE ||"'," END IF
    IF src_rec.SPARE IS NOT NULL THEN LET s_sql = s_sql || " SPARE = '"|| src_rec.SPARE ||"'," END IF
    IF src_rec.APL_ROUTE IS NOT NULL THEN LET s_sql = s_sql || " APL_ROUTE = '"|| src_rec.APL_ROUTE ||"'," END IF

    LET s_sql = s_sql.subString(1, s_sql.getLength() - 1)
    LET s_sql = s_sql || " " || arg_where
    
    PREPARE s_upd FROM s_sql
    EXECUTE s_upd
END FUNCTION

#-------------------------------------------------------
# DELETE CZFP322W
#-------------------------------------------------------
FUNCTION (src_rec CZFP322W) del()
    SET CONNECTION "CR2"
    IF src_rec.COIL_NO == "*" THEN
        DELETE FROM CZFP322W
    ELSE
        DELETE FROM CZFP322W WHERE COIL_NO = src_rec.COIL_NO
    END IF
END FUNCTION

#-------------------------------------------------------
# CZFP322W 轉存成 P321W
#-------------------------------------------------------
PUBLIC FUNCTION (src CZFP322W) toP321W() RETURNS CZFP321W
    DEFINE res CZFP321W

    LET res.COIL_NO = src.COIL_NO
    LET res.FLAG = src.FLAG
    LET res.BP = src.BP
    LET res.FP = src.FP
    LET res.STEEL_GRADE = src.STEEL_GRADE
    LET res.COIL_WIDTH = src.COIL_WIDTH
    LET res.COIL_THICK = src.COIL_THICK
    LET res.OUT_THICK = src.OUT_THICK
    LET res.REDUCTION = src.REDUCTION
    LET res.COIL_WT = src.COIL_WT
    LET res.PREV_STATION = src.PREV_STATION
    LET res.NEXT_STATION = src.NEXT_STATION
    LET res.ORDER_NO_ITEM = src.ORDER_NO_ITEM
    LET res.DUE_DATE = src.DUE_DATE
    LET res.RUSH_CODE_PP = src.RUSH_CODE_PP
    LET res.CLASS_CODE = src.CLASS_CODE
    LET res.IC_CODE = src.IC_CODE
    LET res.APN_CODE = src.APN_CODE
    LET res.SPARE = src.SPARE

    RETURN res
END FUNCTION

#------------------------------------------------------------------------------
# 鋼捲是否存在於CZAP320M #1號機排程
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP322W) existInZA() RETURNS BOOLEAN
    DEFINE s_sql STRING
    
    SET CONNECTION "CPS"
    # 1號機schd check
    LET s_sql = "select schd_coil_no from czap320m " ||
                " where substr(schd_coil_no,5,11) " ||
                " = '" || src_rec.COIL_NO || "' and state in ('I','P','A') "
    PREPARE s_stat FROM s_sql
    EXECUTE s_stat
    
    IF SQLCA.sqlcode != 100 THEN
        DISPLAY src_rec.COIL_NO," already in crm1"
        RETURN TRUE
    END IF
    FREE s_stat

    RETURN FALSE
END FUNCTION

#------------------------------------------------------------------------------
# 鋼捲是否存在於CZBP320M #2號機排程
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP322W) existInZB() RETURNS BOOLEAN
    DEFINE s_sql STRING
    
    SET CONNECTION "CPS"
    # 2號機schd check
    LET s_sql = "select schd_coil_no from czbp320m " ||
                " where substr(schd_coil_no,5,11) " ||
                " = '" || src_rec.COIL_NO || "' and state in ('I','P','A') " 
    PREPARE s_stat FROM s_sql
    EXECUTE s_stat

    IF  SQLCA.sqlcode != 100 THEN
        DISPLAY src_rec.COIL_NO," already in crm2"
        RETURN TRUE
    END IF
    FREE s_stat

    RETURN FALSE
END FUNCTION

#------------------------------------------------------------------------------
# 鋼捲是否存在於CZCP320M #3號機排程
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP322W) existInZC() RETURNS BOOLEAN
    DEFINE s_sql STRING
    
    SET CONNECTION "CPS"
    # 3號機schd check
    LET s_sql = "select schd_coil_no from czcp320m " ||
                " where substr(schd_coil_no,5,11) " ||
                " = '" || src_rec.COIL_NO || "' and state in ('I','P','A') " 
    PREPARE s_stat FROM s_sql
    EXECUTE s_stat

    IF  SQLCA.sqlcode != 100 THEN
        DISPLAY src_rec.COIL_NO," already in crm3"
        RETURN TRUE
    END IF
    FREE s_stat

    RETURN FALSE
END FUNCTION

#------------------------------------------------------------------------------
# 鋼捲是否存在於CZDP320M #4號機排程
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP322W) existInZD() RETURNS BOOLEAN
    DEFINE s_sql STRING
    
    SET CONNECTION "CR2"
    # 4號機schd check
    LET s_sql = "select schd_coil_no from czdp320m " ||
                " where substr(schd_coil_no,5,11) " ||
                " = '" || src_rec.COIL_NO || "' and state in ('I','P','A') " 
    PREPARE s_stat FROM s_sql
    EXECUTE s_stat

    IF  SQLCA.sqlcode != 100 THEN
        DISPLAY src_rec.COIL_NO," already in crm4"
        RETURN TRUE
    END IF
    FREE s_stat

    RETURN FALSE
END FUNCTION

#------------------------------------------------------------------------------
# 鋼捲是否存在於CZEP320M #5號機排程
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP322W) existInZE() RETURNS BOOLEAN
    DEFINE s_sql STRING
    
    SET CONNECTION "CR2"
    
    # 5號機schd check
    LET s_sql = "select schd_coil_no from czep320m " || 
                " where substr(schd_coil_no,5,11) " ||
                " = '" || src_rec.COIL_NO || "' and state in ('I','P','A') " 
    PREPARE s_stat FROM s_sql
    EXECUTE s_stat

    IF  SQLCA.sqlcode != 100 THEN
        DISPLAY src_rec.COIL_NO," already in crm5"
        RETURN TRUE
    END IF
    FREE s_stat

    RETURN FALSE
END FUNCTION

#------------------------------------------------------------------------------
# 鋼捲是否存在於CZFP320M #6號機排程
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP322W) existInZF() RETURNS BOOLEAN
    DEFINE s_sql STRING
    
    SET CONNECTION "CR2"
    
     # 6號機schd check
    LET s_sql = "select schd_coil_no from czfp320m " || 
                " where substr(schd_coil_no,5,11) " ||
                " = '" || src_rec.COIL_NO || "' and state in ('I','P','A') " 
    PREPARE s_stat FROM s_sql
    EXECUTE s_stat

    IF  SQLCA.sqlcode != 100 THEN
        DISPLAY src_rec.COIL_NO," already in crm6"
        RETURN TRUE
    END IF
    FREE s_stat

    RETURN FALSE
END FUNCTION

#------------------------------------------------------------------------------
# 從PCM.ORDB011M提取資料
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP322W) getORDB011M()
    DEFINE s_tmp, s_sql STRING

    IF src_rec.ORDER_NO_ITEM IS NULL THEN
        RETURN
    END IF  
    
    SET CONNECTION "PCM"
    LET s_tmp = src_rec.ORDER_NO_ITEM
    LET s_sql = "select RUSH_CODE_PP, DELIVERY_DATE, APN_NO"--, APL_ROUTE "
    LET s_sql = s_sql || " from ordb011m " --PCM的ordb011m, 影子訂單檔
    LET s_sql = s_sql || " where ORDER_NO = '"|| s_tmp.subString(1,7) ||"' "
    LET s_sql = s_sql || " and ORDER_ITEM = '"|| s_tmp.subString(8,9) ||"' "

    PREPARE s_stat FROM s_sql
    EXECUTE s_stat INTO src_rec.RUSH_CODE_PP, src_rec.DUE_DATE,
                        src_rec.APN_CODE#, P322W_arr[i].APL_ROUTE

END FUNCTION

#------------------------------------------------------------------------------
# 提取/計算Out Thick資料
#------------------------------------------------------------------------------
PUBLIC FUNCTION (src_rec CZFP322W) getOutThick()
    DEFINE
        t_res FLOAT,
        t_station CHAR(1),
        s_tmp STRING
    DEFINE debug CZFP322W

    LET debug = src_rec
    IF src_rec.COIL_NO IS NULL OR src_rec.ORDER_NO_ITEM IS NULL THEN
        RETURN
    END IF  
    SET CONNECTION "PCM"
    
    SELECT CURR_STATION_CODE
        INTO t_station
        FROM pcmb020m
        WHERE COIL_NO = src_rec.COIL_NO
    
    CASE t_station
        WHEN "N"
            SELECT COIL_THICK INTO t_res FROM pcmb020m WHERE COIL_NO = src_rec.COIL_NO
            LET t_res = t_res * 0.9
        WHEN "L"
            SELECT ZMILL_THICK_1
                INTO t_res
                FROM pcmb010m
                WHERE ORDER_NO_ITEM = src_rec.ORDER_NO_ITEM
        WHEN "M"
            SELECT ZMILL_THICK_2
                INTO t_res
                FROM pcmb010m
                WHERE ORDER_NO_ITEM = src_rec.ORDER_NO_ITEM
        OTHERWISE
            LET t_res = 0
    END CASE
    IF t_res = 0 THEN
        SET CONNECTION "ORD"
        LET s_tmp = src_rec.ORDER_NO_ITEM
        PREPARE s_stat FROM "select SHIP_THICK_AIM from ordb011m "
            || " where ORDER_NO='"|| s_tmp.subString(1,7) ||"' "
            || " and ORDER_ITEM='"|| s_tmp.subString(8,9) ||"' "
        EXECUTE s_stat INTO t_res
        FREE s_stat
        LET t_res = t_res + 0.01
    END IF

    LET src_rec.OUT_THICK = t_res
END FUNCTION

#------------------------------------------------------------------------------
# 計算下軋率 REDUCTION
#------------------------------------------------------------------------------
PUBLIC FUNCTION (src_rec CZFP322W) getReduction()

        IF src_rec.COIL_THICK == 0 THEN
            LET src_rec.REDUCTION = -1
        END IF
        LET src_rec.REDUCTION  =
            fgl_decimal_truncate((src_rec.COIL_THICK - src_rec.OUT_THICK)
                / src_rec.COIL_THICK
                * 100, 2)
END FUNCTION

########################################################

#-------------------------------------------------------
# init. For Dependency Diagram Tracing
#-------------------------------------------------------
FUNCTION init_CZFP322W_DB()
    CALL init_CZFP321W_DB()
END FUNCTION

########################################################
