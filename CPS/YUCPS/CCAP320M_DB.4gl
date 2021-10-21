SCHEMA oraCPS

PUBLIC TYPE CCAP320M RECORD
    SEQ LIKE CCAP320M.SEQ,
    SCHD_COIL_NO LIKE CCAP320M.SCHD_COIL_NO,
    FP LIKE CCAP320M.FP,
    BP LIKE CCAP320M.BP,
    PROCESS_CODE LIKE CCAP320M.PROCESS_CODE,
    PROCESS_INDEX LIKE CCAP320M.PROCESS_INDEX,
    STATE LIKE CCAP320M.STATE
END RECORD

#-------------------------------------------------------
# INITIAL CCAP320M RECORD
#-------------------------------------------------------
FUNCTION (src_rec CCAP320M) init()
    INITIALIZE src_rec.* TO NULL
END FUNCTION

#------------------------------------------------------------------------------
# insert CCAP320M
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP320M) ins()
    SET CONNECTION "CPS"
    
    INSERT INTO CCAP320M VALUES(
        src_rec.*
        )

END FUNCTION

#------------------------------------------------------------------------------
#  update CCAP320M
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP320M) upd()
    SET CONNECTION "CPS"

    IF src_rec.SCHD_COIL_NO == "*" THEN
        UPDATE CCAP320M SET
            SEQ = NVL(src_rec.SEQ,SEQ),
            SCHD_COIL_NO = NVL(src_rec.SCHD_COIL_NO,SCHD_COIL_NO),
            FP = NVL(src_rec.FP,FP),
            BP = NVL(src_rec.BP,BP),
            PROCESS_CODE = NVL(src_rec.PROCESS_CODE,PROCESS_CODE),
            PROCESS_INDEX = NVL(src_rec.PROCESS_INDEX,PROCESS_INDEX),
            STATE = NVL(src_rec.STATE,STATE)
    ELSE
        UPDATE CCAP320M SET
            SEQ = NVL(src_rec.SEQ,SEQ),
            SCHD_COIL_NO = NVL(src_rec.SCHD_COIL_NO,SCHD_COIL_NO),
            FP = NVL(src_rec.FP,FP),
            BP = NVL(src_rec.BP,BP),
            PROCESS_CODE = NVL(src_rec.PROCESS_CODE,PROCESS_CODE),
            PROCESS_INDEX = NVL(src_rec.PROCESS_INDEX,PROCESS_INDEX),
            STATE = NVL(src_rec.STATE,STATE)
        WHERE SCHD_COIL_NO = src_rec.SCHD_COIL_NO
    END IF

    INITIALIZE src_rec.* TO NULL
END FUNCTION

#-------------------------------------------------------
# DELETE CCAP320M
#-------------------------------------------------------
PUBLIC FUNCTION  (src CCAP320M) del()
    SET CONNECTION "CPS"

    IF src.SCHD_COIL_NO == "*" THEN
        DELETE FROM CCAP320M
    ELSE
        DELETE FROM CCAP320M WHERE SCHD_COIL_NO = src.SCHD_COIL_NO
    END IF
END FUNCTION

########################################################

#-------------------------------------------------------
# init. For Dependency Diagram Tracing
#-------------------------------------------------------
FUNCTION init_CCAP320M()
END FUNCTION

########################################################
