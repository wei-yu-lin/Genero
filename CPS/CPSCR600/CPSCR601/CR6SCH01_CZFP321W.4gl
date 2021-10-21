IMPORT FGL fgldialog
GLOBALS "../CR6SCH_inc.4gl"

#----------------------------------------------------------------------
#回傳CZFP321W DB資料
#----------------------------------------------------------------------
FUNCTION getCZFP321W()
    DEFINE res_arr DYNAMIC ARRAY OF CR6SCH01
    DEFINE s_sql STRING
    DEFINE i, j, k, len INTEGER
    DEFINE rec_tmp CR6SCH01
    
    SET CONNECTION "rdbcr2"

    LET s_sql = "select COIL_NO, FLAG, BP, FP, STEEL_GRADE, COIL_WIDTH, COIL_THICK, " ||
                " OUT_THICK, REDUCTION, COIL_WT, PREV_STATION, NEXT_STATION, " ||
                " ORDER_NO_ITEM, DUE_DATE, RUSH_CODE_PP, CLASS_CODE, IC_CODE, APN_CODE " ||
                " from CZFP321W "

    PREPARE s_stat FROM s_sql
    DECLARE cs321 CURSOR FOR s_stat

    LET i = 1
    FOREACH cs321 INTO res_arr[i].*
        LET i = i + 1
    END FOREACH

    #刪除最後NULL成員
    CALL res_arr.deleteElement(i)
    #刪除HEADER成員
    CALL res_arr.deleteElement(1)

    #依據BPFP排序
    LET len = res_arr.getLength()
    FOR i = 1 TO len
        IF res_arr[i].COIL_NO == ' ' THEN
            LET rec_tmp.* = res_arr[i].*
            LET res_arr[i].* = res_arr[1].*
            LET res_arr[1].* = rec_tmp.*
            EXIT FOR
        END IF
    END FOR
    FOR i = 2 TO len
        FOR j = i TO len
            FOR k = i TO len
                IF res_arr[i].FP == res_arr[k].COIL_NO THEN
                    LET rec_tmp.* = res_arr[i].*
                    LET res_arr[i].* = res_arr[k].*
                    LET res_arr[k].* = rec_tmp.*
                END IF
            END FOR
        END FOR
    END FOR
    
    RETURN res_arr
END FUNCTION

#----------------------------------------------------------------------
#細排陣列存入細排暫存檔
#CZFP321W_arr存入CZFP321W
#----------------------------------------------------------------------
FUNCTION setCZFP321W(CZFP321W_arr DYNAMIC ARRAY OF CR6SCH01)
    DEFINE i, len INTEGER

    #創立BPFP連結關係
    LET CZFP321W_arr = setBPFP(CZFP321W_arr)
    LET len = CZFP321W_arr.getLength() 
    FOR i = 1 TO len
        TRY
        INSERT INTO CZFP321W(COIL_NO,
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
                            CZFP321W_arr[i].*)
        CATCH
            #803為duplicate key error，代表此鋼捲已存在於細排暫存檔中
            IF SQLCA.SQLERRD[2] != "803" THEN
                CALL fgl_winmessage("ERROR","存入細排時發生SQL錯誤!","stop")
            ELSE
                #更新細排暫存檔
                UPDATE CZFP321W SET 
                    FLAG = CZFP321W_arr[i].FLAG,
                    BP = CZFP321W_arr[i].BP,
                    FP = CZFP321W_arr[i].FP,
                    STEEL_GRADE = CZFP321W_arr[i].STEEL_GRADE,
                    COIL_WIDTH = CZFP321W_arr[i].COIL_WIDTH,
                    COIL_THICK = CZFP321W_arr[i].COIL_THICK,
                    OUT_THICK = CZFP321W_arr[i].OUT_THICK,
                    REDUCTION = CZFP321W_arr[i].REDUCTION,
                    COIL_WT = CZFP321W_arr[i].COIL_WT,
                    PREV_STATION = CZFP321W_arr[i].PREV_STATION,
                    NEXT_STATION = CZFP321W_arr[i].NEXT_STATION,
                    DUE_DATE = CZFP321W_arr[i].DUE_DATE,
                    ORDER_NO_ITEM = CZFP321W_arr[i].ORDER_NO_ITEM ,
                    CLASS_CODE = CZFP321W_arr[i].CLASS_CODE,
                    IC_CODE = CZFP321W_arr[i].IC_CODE,
                    APN_CODE = CZFP321W_arr[i].APN_CODE
                    WHERE COIL_NO = CZFP321W_arr[i].COIL_NO
            END IF
        END TRY
    END FOR
END FUNCTION

#----------------------------------------------------------------------
#刪除細排暫存檔中所有資料
#刪除CZFP321W中所有資料
#----------------------------------------------------------------------
FUNCTION delCZFP321W()
    SET CONNECTION "rdbcr2"
    DELETE FROM CZFP321W
    INSERT INTO CZFP321W(COIL_NO,BP,FP) VALUES (' ', ' ', ' ')
END FUNCTION

#----------------------------------------------------------------------
#於CZFP321W_arr建立BP,FP Linking
#----------------------------------------------------------------------
PRIVATE FUNCTION setBPFP(CZFP321W_arr DYNAMIC ARRAY OF CR6SCH01)
    DEFINE i, len INTEGER
    LET len = CZFP321W_arr.getLength()
    IF len <= 1 THEN
        LET CZFP321W_arr[1].FP = ' '
        LET CZFP321W_arr[1].BP = ' '

        UPDATE CZFP321W SET BP = ' ', FP = ' ' WHERE COIL_NO = ' ' 
    END IF
    IF len > 1 THEN
        LET CZFP321W_arr[1].FP = ' '
        LET CZFP321W_arr[1].BP = CZFP321W_arr[2].COIL_NO
        LET CZFP321W_arr[len].FP = CZFP321W_arr[len-1].COIL_NO
        LET CZFP321W_arr[len].BP = ' '
        UPDATE CZFP321W SET BP = CZFP321W_arr[1].COIL_NO, FP = CZFP321W_arr[len].COIL_NO WHERE COIL_NO = ' '
    END IF
    FOR i = 2 TO len - 1
        LET CZFP321W_arr[i].FP = CZFP321W_arr[i-1].COIL_NO
        LET CZFP321W_arr[i].BP = CZFP321W_arr[i+1].COIL_NO
    END FOR

    RETURN CZFP321W_arr
END FUNCTION