SCHEMA oracr2

PUBLIC TYPE CZFP320M RECORD
    SEQ_NO LIKE CZFP320M.SEQ_NO,
    SCHD_COIL_NO LIKE CZFP320M.SCHD_COIL_NO,
    FP LIKE CZFP320M.FP,
    BP LIKE CZFP320M.BP,
    PROCESS_CODE LIKE CZFP320M.PROCESS_CODE,
    PROCESS_INDEX LIKE CZFP320M.PROCESS_INDEX,
    STATE LIKE CZFP320M.STATE
END RECORD

#-------------------------------------------------------
# INITIAL CZFP320M RECORD
#-------------------------------------------------------
FUNCTION (src_rec CZFP320M) init()
    INITIALIZE src_rec.* TO NULL
END FUNCTION

#------------------------------------------------------------------------------
# insert CZFP320M
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP320M) ins()
    SET CONNECTION "CR2"
    
    INSERT INTO CZFP320M VALUES(
        src_rec.*
        )

END FUNCTION

#------------------------------------------------------------------------------
#  update CZFP320M
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP320M) upd()
    SET CONNECTION "CR2"

    IF src_rec.SCHD_COIL_NO == "*" THEN
        UPDATE CZFP320M SET
            SEQ_NO = NVL(src_rec.SEQ_NO,SEQ_NO),
            SCHD_COIL_NO = NVL(src_rec.SCHD_COIL_NO,SCHD_COIL_NO),
            FP = NVL(src_rec.FP,FP),
            BP = NVL(src_rec.BP,BP),
            PROCESS_CODE = NVL(src_rec.PROCESS_CODE,PROCESS_CODE),
            PROCESS_INDEX = NVL(src_rec.PROCESS_INDEX,PROCESS_INDEX),
            STATE = NVL(src_rec.STATE,STATE)
    ELSE
        UPDATE CZFP320M SET
            SEQ_NO = NVL(src_rec.SEQ_NO,SEQ_NO),
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
# DELETE CZFP320M
#-------------------------------------------------------
PUBLIC FUNCTION  (src CZFP320M) del()
    SET CONNECTION "CR2"

    IF src.SCHD_COIL_NO == "*" THEN
        DELETE FROM CZFP320M
    ELSE
        DELETE FROM CZFP320M WHERE SCHD_COIL_NO = src.SCHD_COIL_NO
    END IF
END FUNCTION

########################################################

#-------------------------------------------------------
# init. For Dependency Diagram Tracing
#-------------------------------------------------------
FUNCTION init_CZFP320M()
END FUNCTION

########################################################