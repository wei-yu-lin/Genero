SCHEMA oraCPS

PUBLIC TYPE CCAP215M RECORD
    COIL_NUMBER LIKE CCAP215M.COIL_NUMBER,
    ACK LIKE CCAP215M.ACK,
    TIMER LIKE CCAP215M.TIMER
END RECORD

#------------------------------------------------------------------------------
# insert CCAP215M
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP215M) insCCAP215M()
    SET CONNECTION "CPS"

    IF src_rec.COIL_NUMBER != ' ' Then
        INSERT INTO CCAP215M VALUES(
            src_rec.COIL_NUMBER,
            src_rec.ACK,
            src_rec.TIMER
            )
    END IF
        
END FUNCTION

#-------------------------------------------------------
# CZFP215W Method
#-------------------------------------------------------
PUBLIC FUNCTION  (src CCAP215M) delDB()
    SET CONNECTION "CPS"
    DELETE FROM CCAP215M WHERE COIL_NUMBER = src.COIL_NUMBER
END FUNCTION

#-------------------------------------------------------
# get CPS$DB:CZFP215W TO Array
#-------------------------------------------------------
PUBLIC FUNCTION getCCAP215M_DB()
    DEFINE res DYNAMIC ARRAY OF CCAP215M
    DEFINE s_sql STRING
    DEFINE idx INTEGER
    
    SET CONNECTION "CPS"
    LET s_sql = "select COIL_NUMBER from CCAP215M"

    PREPARE s_stat FROM s_sql
    DECLARE cs00 CURSOR FOR s_stat

    LET idx = 1
    FOREACH cs00 INTO res[idx].COIL_NUMBER
        LET idx = idx+1
    END FOREACH
    CALL res.deleteElement(idx)

    RETURN res
END FUNCTION
