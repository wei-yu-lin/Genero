IMPORT FGL fgldialog
GLOBALS "../CR6SCH_inc.4gl"

#----------------------------------------------------------------------
#回傳CZFP322W DB資料
#----------------------------------------------------------------------
FUNCTION getCZFP322W()
    DEFINE res_arr DYNAMIC ARRAY OF CR6SCH01
    DEFINE s_sql STRING
    DEFINE i INTEGER
    
    SET CONNECTION "rdbcr2"

    LET s_sql = "select COIL_NO, FLAG, BP, FP, STEEL_GRADE, COIL_WIDTH, COIL_THICK, " ||
                " OUT_THICK, REDUCTION, COIL_WT, PREV_STATION, NEXT_STATION, " ||
                " ORDER_NO_ITEM, DUE_DATE, RUSH_CODE_PP, CLASS_CODE, IC_CODE, APN_CODE " ||
                " from CZFP322W "

    PREPARE s_stat FROM s_sql
    DECLARE cs322 CURSOR FOR s_stat
    
    LET i = 1
    FOREACH cs322 INTO res_arr[i].*
        LET res_arr[i].REDUCTION = fgl_decimal_truncate(res_arr[i].REDUCTION,2)
        LET i = i + 1
    END FOREACH

    FREE s_stat
    #刪除最後NULL成員
    CALL res_arr.deleteElement(i)
    
    RETURN res_arr
END FUNCTION

#----------------------------------------------------------------------
#粗排陣列存入粗排暫存檔
#CZFP322W_arr存入CZFP322W
#----------------------------------------------------------------------
FUNCTION setCZFP322W(CZFP322W_arr DYNAMIC ARRAY OF CR6SCH01)
    DEFINE i, len INTEGER
    LET len = CZFP322W_arr.getLength()
    FOR i = 1 TO len
        TRY
        INSERT INTO CZFP322W(COIL_NO,
                            FLAG,
                            BP,
                            FP,
                            STEEL_GRADE,
                            COIL_WIDTH,
                            COIL_THICK,
                            OUT_THICK,
                            REDUCTION,
                            COIL_WT,
                            PREV_STATION,
                            NEXT_STATION,
                            ORDER_NO_ITEM,
                            DUE_DATE,
                            RUSH_CODE_PP,
                            CLASS_CODE,
                            IC_CODE,
                            APN_CODE) VALUES (
                            CZFP322W_arr[i].*)
        CATCH
            #803為duplicate key error，代表此鋼捲已存在於細排暫存檔中
            IF SQLCA.SQLERRD[2] != "803" THEN
                CALL fgl_winmessage("ERROR","存入粗排時發生SQL錯誤!","stop")
            ELSE
                #更新粗排暫存檔
                UPDATE CZFP322W SET 
                    FLAG = CZFP322W_arr[i].FLAG,
                    STEEL_GRADE = CZFP322W_arr[i].STEEL_GRADE,
                    COIL_WIDTH = CZFP322W_arr[i].COIL_WIDTH,
                    COIL_THICK = CZFP322W_arr[i].COIL_THICK,
                    OUT_THICK = CZFP322W_arr[i].OUT_THICK,
                    REDUCTION = CZFP322W_arr[i].REDUCTION,
                    COIL_WT = CZFP322W_arr[i].COIL_WT,
                    PREV_STATION = CZFP322W_arr[i].PREV_STATION,
                    NEXT_STATION = CZFP322W_arr[i].NEXT_STATION,
                    DUE_DATE = CZFP322W_arr[i].DUE_DATE,
                    ORDER_NO_ITEM = CZFP322W_arr[i].ORDER_NO_ITEM ,
                    CLASS_CODE = CZFP322W_arr[i].CLASS_CODE,
                    IC_CODE = CZFP322W_arr[i].IC_CODE,
                    APN_CODE = CZFP322W_arr[i].APN_CODE
                    WHERE COIL_NO = CZFP322W_arr[i].COIL_NO
            END IF
        END TRY
    END FOR
END FUNCTION

#----------------------------------------------------------------------
#刪除粗排暫存檔中所有資料
#刪除CZFP322W中所有資料
#----------------------------------------------------------------------
FUNCTION delCZFP322W()
    SET CONNECTION "rdbcr2"
    DELETE FROM CZFP322W
END FUNCTION