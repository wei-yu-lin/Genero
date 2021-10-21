IMPORT FGL CCAP321W_DB
IMPORT FGL fgldialog

SCHEMA oraCPS

#-------------------------------------------------------
# CCAP322W
#-------------------------------------------------------
PUBLIC TYPE CCAP322W RECORD
    coil_no LIKE ccap322w.coil_no,
	bp LIKE ccap322w.bp,
	fp LIKE ccap322w.fp,
	steel_grade LIKE ccap322w.steel_grade,
	coil_width LIKE ccap322w.coil_width,
	coil_thick LIKE ccap322w.coil_thick,
	coil_wt LIKE ccap322w.coil_wt,
	ic_code LIKE ccap322w.ic_code,
	prev_station LIKE ccap322w.prev_station,
	curr_station LIKE ccap322w.curr_station,
	next_station LIKE ccap322w.next_station,
	flag LIKE ccap322w.flag,
	process_code LIKE ccap322w.process_code,
	r_week LIKE ccap322w.r_week,
	process_index LIKE ccap322w.process_index,
	order_no_item LIKE ccap322w.order_no_item,
	due_date LIKE ccap322w.due_date,
	apn_no LIKE ccap322w.apn_no,
	apl_route LIKE ccap322w.apl_route,
	pcl LIKE ccap322w.pcl,
	crm_station LIKE ccap322w.crm_station,
	line_marking LIKE ccap322w.line_marking,
	coil_in_diam LIKE ccap322w.coil_in_diam,
	edging LIKE ccap322w.edging,
	ship_thick_min LIKE ccap322w.ship_thick_min,
	ship_thick_max LIKE ccap322w.ship_thick_max
END RECORD

#-------------------------------------------------------
# INITIAL CCAP322W RECORD
#-------------------------------------------------------
FUNCTION (src_rec CCAP322W) init()
    INITIALIZE src_rec.* TO NULL
END FUNCTION

#-------------------------------------------------------
# INSERT CCAP322W
#-------------------------------------------------------
FUNCTION (src_rec CCAP322W) ins()
    SET CONNECTION "CPS"
    INSERT INTO CCAP322W VALUES (src_rec.*)
END FUNCTION

#-------------------------------------------------------
# UPDATE CCAP322W
#-------------------------------------------------------
FUNCTION (src_rec CCAP322W) upd()
    SET CONNECTION "CPS"

    IF src_rec.coil_no == "*" THEN
        UPDATE CCAP322W SET
            bp = NVL(src_rec.bp, bp),
            fp = NVL(src_rec.fp, fp),
            steel_grade = NVL(src_rec.steel_grade, steel_grade),
            coil_width = NVL(src_rec.coil_width, coil_width),
            coil_thick = NVL(src_rec.coil_thick, coil_thick),
            coil_wt = NVL(src_rec.coil_wt, coil_wt),
            ic_code = NVL(src_rec.ic_code, ic_code),
            prev_station = NVL(src_rec.prev_station, prev_station),
            curr_station = NVL(src_rec.curr_station, curr_station),
            next_station = NVL(src_rec.next_station, next_station),
            flag = NVL(src_rec.flag, flag),
            process_code = NVL(src_rec.process_code, process_code),
            r_week = NVL(src_rec.r_week, r_week),
            process_index = NVL(src_rec.process_index, process_index),
            order_no_item = NVL(src_rec.order_no_item, order_no_item),
            due_date = NVL(src_rec.due_date, due_date),
            apn_no = NVL(src_rec.apn_no, apn_no),
            apl_route = NVL(src_rec.apl_route, apl_route),
            pcl = NVL(src_rec.pcl, pcl),
            crm_station = NVL(src_rec.crm_station, crm_station),
            line_marking = NVL(src_rec.line_marking, line_marking),
            coil_in_diam = NVL(src_rec.coil_in_diam, coil_in_diam),
            edging = NVL(src_rec.edging, edging),
            ship_thick_min = NVL(src_rec.ship_thick_min, ship_thick_min),
            ship_thick_max = NVL(src_rec.ship_thick_max, ship_thick_max)
    ELSE
        UPDATE CCAP322W SET
            bp = NVL(src_rec.bp, bp),
            fp = NVL(src_rec.fp, fp),
            steel_grade = NVL(src_rec.steel_grade, steel_grade),
            coil_width = NVL(src_rec.coil_width, coil_width),
            coil_thick = NVL(src_rec.coil_thick, coil_thick),
            coil_wt = NVL(src_rec.coil_wt, coil_wt),
            ic_code = NVL(src_rec.ic_code, ic_code),
            prev_station = NVL(src_rec.prev_station, prev_station),
            curr_station = NVL(src_rec.curr_station, curr_station),
            next_station = NVL(src_rec.next_station, next_station),
            flag = NVL(src_rec.flag, flag),
            process_code = NVL(src_rec.process_code, process_code),
            r_week = NVL(src_rec.r_week, r_week),
            process_index = NVL(src_rec.process_index, process_index),
            order_no_item = NVL(src_rec.order_no_item, order_no_item),
            due_date = NVL(src_rec.due_date, due_date),
            apn_no = NVL(src_rec.apn_no, apn_no),
            apl_route = NVL(src_rec.apl_route, apl_route),
            pcl = NVL(src_rec.pcl, pcl),
            crm_station = NVL(src_rec.crm_station, crm_station),
            line_marking = NVL(src_rec.line_marking, line_marking),
            coil_in_diam = NVL(src_rec.coil_in_diam, coil_in_diam),
            edging = NVL(src_rec.edging, edging),
            ship_thick_min = NVL(src_rec.ship_thick_min, ship_thick_min),
            ship_thick_max = NVL(src_rec.ship_thick_max, ship_thick_max)
        WHERE coil_no = src_rec.coil_no
    END IF
END FUNCTION

#-------------------------------------------------------
# DELETE CCAP322W
#-------------------------------------------------------
FUNCTION (src_rec CCAP322W) del()
    SET CONNECTION "CPS"
    IF src_rec.coil_no == "*" THEN
        DELETE FROM CCAP322W
    ELSE
        DELETE FROM CCAP322W WHERE coil_no = src_rec.coil_no
    END IF
END FUNCTION

#-------------------------------------------------------
# CCAP322W 轉存成 P321W
#-------------------------------------------------------
PUBLIC FUNCTION (src CCAP322W) toP321W() RETURNS CCAP321W
    DEFINE res CCAP321W

    LET res.coil_no = src.coil_no
	LET res.bp = src.bp
	LET res.fp = src.fp
	LET res.steel_grade = src.steel_grade
	LET res.coil_width = src.coil_width
	LET res.coil_thick = src.coil_thick
	LET res.coil_wt = src.coil_wt
	LET res.ic_code = src.ic_code
	LET res.prev_station = src.prev_station
	LET res.next_station = src.next_station
	LET res.process_code = src.process_code
	LET res.process_index = src.process_index
	LET res.curr_station = src.curr_station
	LET res.order_no_item = src.order_no_item
	LET res.due_date = src.due_date
	LET res.apn_no = src.apn_no

    RETURN res
END FUNCTION

#------------------------------------------------------------------------------
# 鋼捲是否存在於CZAP320M #1號機排程
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP322W) existInZA() RETURNS BOOLEAN
    DEFINE s_sql STRING
    
    SET CONNECTION "CPS"
    # 1號機schd check
    LET s_sql = "select SCHD_COIL_NO from czap320m " ||
                " where substr(SCHD_COIL_NO,5,11) " ||
                " = '" || src_rec.coil_no || "' and state in ('I','P','A') "
    PREPARE s_stat FROM s_sql
    EXECUTE s_stat
    
    IF SQLCA.sqlcode != 100 THEN
        DISPLAY src_rec.coil_no," already in crm1"
        RETURN TRUE
    END IF
    FREE s_stat

    RETURN FALSE
END FUNCTION

#------------------------------------------------------------------------------
# 鋼捲是否存在於CZBP320M #2號機排程
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP322W) existInZB() RETURNS BOOLEAN
    DEFINE s_sql STRING
    
    SET CONNECTION "CPS"
    # 2號機schd check
    LET s_sql = "select SCHD_COIL_NO from czbp320m " ||
                " where substr(SCHD_COIL_NO,5,11) " ||
                " = '" || src_rec.coil_no || "' and state in ('I','P','A') " 
    PREPARE s_stat FROM s_sql
    EXECUTE s_stat

    IF  SQLCA.sqlcode != 100 THEN
        DISPLAY src_rec.coil_no," already in crm2"
        RETURN TRUE
    END IF
    FREE s_stat

    RETURN FALSE
END FUNCTION

#------------------------------------------------------------------------------
# 鋼捲是否存在於CZCP320M #3號機排程
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP322W) existInZC() RETURNS BOOLEAN
    DEFINE s_sql STRING
    
    SET CONNECTION "CPS"
    # 3號機schd check
    LET s_sql = "select SCHD_COIL_NO from czcp320m " ||
                " where substr(SCHD_COIL_NO,5,11) " ||
                " = '" || src_rec.coil_no || "' and state in ('I','P','A') " 
    PREPARE s_stat FROM s_sql
    EXECUTE s_stat

    IF  SQLCA.sqlcode != 100 THEN
        DISPLAY src_rec.coil_no," already in crm3"
        RETURN TRUE
    END IF
    FREE s_stat

    RETURN FALSE
END FUNCTION

#------------------------------------------------------------------------------
# 鋼捲是否存在於CZDP320M #4號機排程
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP322W) existInZD() RETURNS BOOLEAN
    DEFINE s_sql STRING
    
    SET CONNECTION "CR2"
    # 4號機schd check
    LET s_sql = "select SCHD_COIL_NO from czdp320m " ||
                " where substr(SCHD_COIL_NO,5,11) " ||
                " = '" || src_rec.coil_no || "' and state in ('I','P','A') " 
    PREPARE s_stat FROM s_sql
    EXECUTE s_stat

    IF  SQLCA.sqlcode != 100 THEN
        DISPLAY src_rec.coil_no," already in crm4"
        RETURN TRUE
    END IF
    FREE s_stat

    RETURN FALSE
END FUNCTION

#------------------------------------------------------------------------------
# 鋼捲是否存在於CZEP320M #5號機排程
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP322W) existInZE() RETURNS BOOLEAN
    DEFINE s_sql STRING
    
    SET CONNECTION "CPS"
    
    # 5號機schd check
    LET s_sql = "select SCHD_COIL_NO from czep320m " || 
                " where substr(SCHD_COIL_NO,5,11) " ||
                " = '" || src_rec.coil_no || "' and state in ('I','P','A') " 
    PREPARE s_stat FROM s_sql
    EXECUTE s_stat

    IF  SQLCA.sqlcode != 100 THEN
        DISPLAY src_rec.coil_no," already in crm5"
        RETURN TRUE
    END IF
    FREE s_stat

    RETURN FALSE
END FUNCTION

#------------------------------------------------------------------------------
# 鋼捲是否存在於CCAP320M #6號機排程
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP322W) existInZF() RETURNS BOOLEAN
    DEFINE s_sql STRING
    
    SET CONNECTION "CPS"
    
     # 6號機schd check
    LET s_sql = "select SCHD_COIL_NO from CCAP320M " || 
                " where substr(SCHD_COIL_NO,5,11) " ||
                " = '" || src_rec.coil_no || "' and state in ('I','P','A') " 
    PREPARE s_stat FROM s_sql
    EXECUTE s_stat

    IF  SQLCA.sqlcode != 100 THEN
        DISPLAY src_rec.coil_no," already in crm6"
        RETURN TRUE
    END IF
    FREE s_stat

    RETURN FALSE
END FUNCTION

#------------------------------------------------------------------------------
# 從PCM.ORDB011M提取資料
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP322W) getORDB011M()
    DEFINE s_tmp, s_sql STRING

    IF src_rec.ORDER_NO_ITEM IS NULL THEN
        RETURN
    END IF  
    
    SET CONNECTION "PCM"
    LET s_tmp = src_rec.ORDER_NO_ITEM
    LET s_sql = "select  DELIVERY_DATE, APN_NO, APL_ROUTE "
    LET s_sql = s_sql || " from ordb011m " --PCM的ordb011m, 影子訂單檔
    LET s_sql = s_sql || " where ORDER_NO = '"|| s_tmp.subString(1,7) ||"' "
    LET s_sql = s_sql || " and ORDER_ITEM = '"|| s_tmp.subString(8,9) ||"' "

    PREPARE s_stat FROM s_sql
    EXECUTE s_stat INTO src_rec.DUE_DATE,
                        src_rec.APN_NO, src_rec.APL_ROUTE

END FUNCTION

########################################################

#-------------------------------------------------------
# init. For Dependency Diagram Tracing
#-------------------------------------------------------
FUNCTION init_CCAP322W_DB()
    CALL init_CCAP321W_DB()
END FUNCTION

########################################################
