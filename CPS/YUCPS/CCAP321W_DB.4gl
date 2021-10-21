IMPORT FGL fgldialog

SCHEMA oraCPS

#-------------------------------------------------------
# CCAP321W
#-------------------------------------------------------
PUBLIC TYPE CCAP321W RECORD
    coil_no LIKE ccap321w.coil_no,
    bp LIKE ccap321w.bp,
    fp LIKE ccap321w.fp,
    steel_grade LIKE ccap321w.steel_grade,
    coil_width LIKE ccap321w.coil_width,
    coil_thick LIKE ccap321w.coil_thick,
    coil_wt LIKE ccap321w.coil_wt,
    ic_code LIKE ccap321w.ic_code,
    prev_station LIKE ccap321w.prev_station,
    next_station LIKE ccap321w.next_station,
    process_code LIKE ccap321w.process_code,
    process_index LIKE ccap321w.process_index,
    curr_station LIKE ccap321w.curr_station,
    order_no_item LIKE ccap321w.order_no_item,
    out_thick LIKE ccap321w.out_thick,
    due_date LIKE ccap321w.due_date,
    brige LIKE ccap321w.brige,
    apn_no LIKE ccap321w.apn_no
END RECORD

#-------------------------------------------------------
# INITIAL CCAP321W RECORD
#-------------------------------------------------------
FUNCTION (src_rec CCAP321W) init()
    INITIALIZE src_rec.* TO NULL
END FUNCTION

#-------------------------------------------------------
# INSERT INTO CCAP321W
#-------------------------------------------------------
PUBLIC FUNCTION  (src_rec CCAP321W) ins()
    SET CONNECTION "CPS"
    
    INSERT INTO CCAP321W VALUES(
        src_rec.*
        )
END FUNCTION

#-------------------------------------------------------
# UPDATE CCAP321W
#-------------------------------------------------------
PUBLIC FUNCTION  (src_rec CCAP321W) upd()
    SET CONNECTION "CPS"
    IF src_rec.COIL_NO == "*" THEN
        UPDATE CCAP321W SET
            bp = NVL(src_rec.bp, bp),
            fp = NVL(src_rec.fp, fp),
            steel_grade = NVL(src_rec.steel_grade, steel_grade),
            coil_width = NVL(src_rec.coil_width, coil_width),
            coil_thick = NVL(src_rec.coil_thick, coil_thick),
            coil_wt = NVL(src_rec.coil_wt, coil_wt),
            ic_code = NVL(src_rec.ic_code, ic_code),
            prev_station = NVL(src_rec.prev_station, prev_station),
            next_station = NVL(src_rec.next_station, next_station),
            process_code = NVL(src_rec.process_code, process_code),
            process_index = NVL(src_rec.process_index, process_index),
            curr_station = NVL(src_rec.curr_station, curr_station),
            order_no_item = NVL(src_rec.order_no_item, order_no_item),
            out_thick = NVL(src_rec.out_thick, out_thick),
            due_date = NVL(src_rec.due_date, due_date),
            brige = NVL(src_rec.brige, brige),
            apn_no = NVL(src_rec.apn_no, apn_no)
    ELSE
        UPDATE CCAP321W SET
            bp = NVL(src_rec.bp, bp),
            fp = NVL(src_rec.fp, fp),
            steel_grade = NVL(src_rec.steel_grade, steel_grade),
            coil_width = NVL(src_rec.coil_width, coil_width),
            coil_thick = NVL(src_rec.coil_thick, coil_thick),
            coil_wt = NVL(src_rec.coil_wt, coil_wt),
            ic_code = NVL(src_rec.ic_code, ic_code),
            prev_station = NVL(src_rec.prev_station, prev_station),
            next_station = NVL(src_rec.next_station, next_station),
            process_code = NVL(src_rec.process_code, process_code),
            process_index = NVL(src_rec.process_index, process_index),
            curr_station = NVL(src_rec.curr_station, curr_station),
            order_no_item = NVL(src_rec.order_no_item, order_no_item),
            out_thick = NVL(src_rec.out_thick, out_thick),
            due_date = NVL(src_rec.due_date, due_date),
            brige = NVL(src_rec.brige, brige),
            apn_no = NVL(src_rec.apn_no, apn_no)
        WHERE COIL_NO = src_rec.COIL_NO
    END IF
END FUNCTION

#-------------------------------------------------------
# DELETE CCAP321W
#-------------------------------------------------------
PUBLIC FUNCTION  (src CCAP321W) del()
    SET CONNECTION "CPS"

    IF src.COIL_NO == "*" THEN
        DELETE FROM CCAP321W
    ELSE
        DELETE FROM CCAP321W WHERE COIL_NO = src.COIL_NO
    END IF
END FUNCTION

########################################################

#-------------------------------------------------------
# init. For Dependency Diagram Tracing
#-------------------------------------------------------
FUNCTION init_CCAP321W_DB()
END FUNCTION

########################################################
