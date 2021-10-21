IMPORT FGL fgldialog

SCHEMA oracr2

#-------------------------------------------------------
# CZFP321W
#-------------------------------------------------------
PUBLIC TYPE CZFP321W RECORD
    COIL_NO LIKE CZFP321W.COIL_NO,
    FLAG LIKE CZFP321W.FLAG,
    BP LIKE CZFP321W.BP,
    FP LIKE CZFP321W.FP,
    STEEL_GRADE LIKE CZFP321W.STEEL_GRADE,
    COIL_WIDTH LIKE CZFP321W.COIL_WIDTH,
    COIL_THICK LIKE CZFP321W.COIL_THICK,
    OUT_THICK LIKE CZFP321W.OUT_THICK,
    REDUCTION LIKE CZFP321W.REDUCTION,
    COIL_WT LIKE CZFP321W.COIL_WT,
    PREV_STATION LIKE CZFP321W.PREV_STATION,
    NEXT_STATION LIKE CZFP321W.NEXT_STATION,
    ORDER_NO_ITEM LIKE CZFP321W.ORDER_NO_ITEM,
    DUE_DATE LIKE CZFP321W.DUE_DATE,
    RUSH_CODE_PP LIKE CZFP321W.RUSH_CODE_PP,
    CLASS_CODE LIKE CZFP321W.CLASS_CODE,
    IC_CODE LIKE CZFP321W.IC_CODE,
    APN_CODE LIKE CZFP321W.APN_CODE,
    SPARE LIKE CZFP321W.SPARE
END RECORD

#-------------------------------------------------------
# INITIAL CZFP321W RECORD
#-------------------------------------------------------
FUNCTION (src_rec CZFP321W) init()
    INITIALIZE src_rec.* TO NULL
    CALL init_CZFP321W_DB()
END FUNCTION

#-------------------------------------------------------
# INSERT INTO CZFP321W
#-------------------------------------------------------
PUBLIC FUNCTION  (src_rec CZFP321W) ins()
    SET CONNECTION "CR2"
    
    INSERT INTO CZFP321W VALUES(
        src_rec.*
        )
END FUNCTION

#-------------------------------------------------------
# UPDATE CZFP321W
#-------------------------------------------------------
PUBLIC FUNCTION  (src_rec CZFP321W) upd()
    SET CONNECTION "CR2"
    IF src_rec.coil_no == "*" THEN
        UPDATE CZFP321W SET
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
            SPARE = NVL(src_rec.SPARE, SPARE)
    ELSE
        UPDATE CZFP321W SET
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
            SPARE = NVL(src_rec.SPARE, SPARE)
        WHERE COIL_NO = src_rec.COIL_NO
    END IF
END FUNCTION

#-------------------------------------------------------
# DELETE CZFP321W
#-------------------------------------------------------
PUBLIC FUNCTION  (src CZFP321W) del()
    SET CONNECTION "CR2"

    IF src.COIL_NO == "*" THEN
        DELETE FROM CZFP321W
    ELSE
        DELETE FROM CZFP321W WHERE COIL_NO = src.COIL_NO
    END IF
END FUNCTION

########################################################

#-------------------------------------------------------
# init. For Dependency Diagram Tracing
#-------------------------------------------------------
FUNCTION init_CZFP321W_DB()
END FUNCTION

########################################################