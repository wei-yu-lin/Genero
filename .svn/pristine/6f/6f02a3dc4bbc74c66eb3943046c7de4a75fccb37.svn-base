SCHEMA oracr2

PUBLIC TYPE CZFP215M RECORD
    COIL_NO LIKE CZFP215M.COIL_NO,
    ACK LIKE CZFP215M.ACK,
    TIMER LIKE CZFP215M.TIMER
END RECORD

#------------------------------------------------------------------------------
# insert CZFP215M
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP215M) insCZFP215M()
    SET CONNECTION "CR2"

    IF src_rec.COIL_NO != ' ' Then
        INSERT INTO CZFP215M VALUES(
            src_rec.COIL_NO,
            src_rec.ACK,
            src_rec.TIMER
            )
    END IF
        
END FUNCTION

#-------------------------------------------------------
# CZFP215W Method
#-------------------------------------------------------
PUBLIC FUNCTION  (src CZFP215M) delDB()
    SET CONNECTION "CR2"
    DELETE FROM CZFP215M WHERE COIL_NO = src.COIL_NO
END FUNCTION

#-------------------------------------------------------
# get CR2$DB:CZFP215W TO Array
#-------------------------------------------------------
PUBLIC FUNCTION getCZFP215M_DB()
    DEFINE res DYNAMIC ARRAY OF CZFP215M
    DEFINE s_sql STRING
    DEFINE idx INTEGER
    
    SET CONNECTION "CR2"
    LET s_sql = "select COIL_NO from CZFP215M"

    PREPARE s_stat FROM s_sql
    DECLARE cs00 CURSOR FOR s_stat

    LET idx = 1
    FOREACH cs00 INTO res[idx].COIL_NO
        LET idx = idx+1
    END FOREACH
    CALL res.deleteElement(idx)

    RETURN res
END FUNCTION