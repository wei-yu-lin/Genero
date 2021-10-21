IMPORT FGL CZFP322W_DB

SCHEMA oracr2

#-------------------------------------------------------
# USED IN GENERATE CZFP322W ARRAY METHOD
#-------------------------------------------------------
PUBLIC TYPE CZFP322W_LIST RECORD
    arr DYNAMIC ARRAY OF CZFP322W_DB.CZFP322W
END RECORD

#----------------------------------------------------------------------
# 由 COIL NO 指定刪除於DB和UI的資料
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list CZFP322W_LIST) delByCoilNo(arg_coil LIKE CZFP322W.coil_no)
    DEFINE i, len INTEGER
    DEFINE ctrl CZFP322W_DB.CZFP322W

    #DB刪除
    CALL ctrl.init()
    LET ctrl.COIL_NO = arg_coil
    CALL ctrl.del()

    #UI陣列刪除
    IF arg_coil = "*" THEN
        CALL src_list.arr.clear()
    ELSE
        LET len = src_list.arr.getLength()
        FOR i = 1 TO len
            IF src_list.arr[i].COIL_NO == arg_coil THEN
                CALL src_list.arr.deleteElement(i)
                EXIT FOR
            END IF
        END FOR
    END IF
END FUNCTION

#----------------------------------------------------------------------
# 取得CZFP322W DB資料
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list CZFP322W_LIST) get()
    DEFINE s_sql STRING
    DEFINE i, len INTEGER
    
    SET CONNECTION "CR2"

    LET s_sql = "select COIL_NO, FLAG, BP, FP, STEEL_GRADE, COIL_WIDTH, COIL_THICK, " ||
                " OUT_THICK, REDUCTION, COIL_WT, PREV_STATION, NEXT_STATION, " ||
                " ORDER_NO_ITEM, DUE_DATE, RUSH_CODE_PP, CLASS_CODE, IC_CODE, APN_CODE " ||
                " from CZFP322W "

    PREPARE s_stat FROM s_sql
    DECLARE cs_getCZFP322W CURSOR FOR s_stat
    
    LET i = 1
    FOREACH cs_getCZFP322W INTO src_list.arr[i].*
        LET src_list.arr[i].REDUCTION = fgl_decimal_truncate(src_list.arr[i].REDUCTION,2)
        LET i = i + 1
    END FOREACH

    FREE s_stat

    LET len = src_list.arr.getLength()
    #刪除NULL成員
    FOR i = 1 TO len
        IF src_list.arr[i].COIL_NO IS NULL THEN
            CALL src_list.arr.deleteElement(i)
        END IF
    END FOR
    
END FUNCTION

#----------------------------------------------------------------------
#粗排陣列存入粗排暫存檔
#CZFP322W_arr存入CZFP322W
#----------------------------------------------------------------------
FUNCTION (src_list CZFP322W_LIST) set()
    DEFINE i, len INTEGER
    LET len = src_list.arr.getLength()
    FOR i = 1 TO len
        TRY
            CALL src_list.arr[i].ins()
        CATCH
            #803為duplicate key error，代表此鋼捲已存在於細排暫存檔中
            {IF SQLCA.SQLERRD[2] != "803" THEN
                CALL fgl_winmessage("ERROR","存入粗排時發生SQL錯誤!","stop")
            ELSE}
                #更新粗排暫存檔
                CALL src_list.arr[i].upd()
            #END IF
        END TRY
    END FOR
END FUNCTION

#----------------------------------------------------------------------
# 資料排序: 急訂單>鋼捲寬>鋼種>鋼捲編號
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list CZFP322W_LIST) sort()
#資料排序: 急訂單>鋼捲寬>鋼種>鋼捲編號
    CALL src_list.arr.sort("COIL_NO",FALSE)
    CALL src_list.arr.sort("STEEL_GRADE",FALSE)
    CALL src_list.arr.sort("COIL_WIDTH",FALSE)
    CALL src_list.arr.sort("RUSH_CODE_PP",TRUE)
END FUNCTION

#----------------------------------------------------------------------
# 由COIL NO更新CZFP322W DB的FLAG欄位資料
# 更新粗排暫存檔: 已被選入細排之FLAG
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list CZFP322W_LIST) updFLAG(arg_coil LIKE CZFP322W.coil_no, arg_flag LIKE CZFP322W.flag)
    DEFINE i, len INTEGER
    DEFINE ctrl CZFP322W_DB.CZFP322W

    #DB更新
    CALL ctrl.init()
    LET ctrl.COIL_NO = arg_coil
    LET ctrl.FLAG = arg_flag
    CALL ctrl.upd()

    #DB更新
    CALL ctrl.init()
    LET ctrl.COIL_NO = arg_coil
    LET ctrl.FLAG = arg_flag
    CALL ctrl.upd()
    
    LET len = src_list.arr.getLength()
    IF arg_coil == "*" THEN
        #UI陣列更新
        FOR i = 1 TO len
            LET src_list.arr[i].FLAG = arg_flag
        END FOR
    ELSE
        #UI陣列更新
        FOR i = 1 TO len
            IF src_list.arr[i].COIL_NO == arg_coil THEN
                LET src_list.arr[i].FLAG = arg_flag
                EXIT FOR
            END IF
        END FOR
    END IF
END FUNCTION

########################################################
#-------------------------------------------------------
# init. For Dependency Diagram Tracing
#-------------------------------------------------------
FUNCTION init_CZFP322W_LIST()
    CALL init_CZFP322W_DB()
END FUNCTION

########################################################
