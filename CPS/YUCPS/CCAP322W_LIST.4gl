IMPORT FGL CCAP322W_DB

SCHEMA oracps

#-------------------------------------------------------
# USED IN GENERATE CCAP322W ARRAY METHOD
#-------------------------------------------------------
PUBLIC TYPE CCAP322W_LIST RECORD
    arr DYNAMIC ARRAY OF CCAP322W_DB.CCAP322W
END RECORD

#----------------------------------------------------------------------
# 由 COIL NO 指定刪除於DB和UI的資料
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list CCAP322W_LIST) delByCoilNo(arg_coil LIKE CCAP322W.COIL_NO)
    DEFINE i, len INTEGER
    DEFINE ctrl CCAP322W_DB.CCAP322W

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
# 取得CCAP322W DB資料
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list CCAP322W_LIST) get()
    DEFINE s_sql STRING
    DEFINE i, len INTEGER
    
    SET CONNECTION "CPS"

    LET s_sql = "select coil_no,bp,fp,steel_grade,coil_width,coil_thick,coil_wt,ic_code, " ||
    "prev_station,curr_station,next_station,flag,process_code,r_week,process_index,order_no_item,due_date, " ||
    "apn_no,apl_route, pcl, crm_station,line_marking,coil_in_diam,edging,ship_thick_min,ship_thick_max " ||
    "from CCAP322W"
    LET i = 1
    PREPARE s_stat FROM s_sql
    DECLARE cs_getCCAP322W CURSOR FOR s_stat
     FOREACH cs_getCCAP322W INTO src_list.arr[i].*        
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
#CCAP322W_arr存入CCAP322W
#----------------------------------------------------------------------
FUNCTION (src_list CCAP322W_LIST) set()
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
PUBLIC FUNCTION (src_list CCAP322W_LIST) sort()
#資料排序: 急訂單>鋼捲寬>鋼種>鋼捲編號
    CALL src_list.arr.sort("coil_no",FALSE)
    CALL src_list.arr.sort("STEEL_GRADE",FALSE)
    CALL src_list.arr.sort("COIL_WIDTH",FALSE)
END FUNCTION

#----------------------------------------------------------------------
# 由COIL NO更新CCAP322W DB的FLAG欄位資料
# 更新粗排暫存檔: 已被選入細排之FLAG
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list CCAP322W_LIST) updFLAG(arg_coil LIKE CCAP322W.COIL_NO, arg_flag LIKE CCAP322W.flag)
    DEFINE i, len INTEGER
    DEFINE ctrl CCAP322W_DB.CCAP322W

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
FUNCTION init_CCAP322W_LIST()
    CALL init_CCAP322W_DB()
END FUNCTION

########################################################
