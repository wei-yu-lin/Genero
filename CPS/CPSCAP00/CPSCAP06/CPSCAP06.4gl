IMPORT FGL CCAP320M_DB
IMPORT FGL CCAP321W_DB
IMPORT FGL CCAP322W_DB
IMPORT FGL CPSCAP_INC
IMPORT FGL sys_toolbar

#------------------------------------------------------------------------------
# CPSCAP06
#------------------------------------------------------------------------------
TYPE CPSCAP06 RECORD
        SCHD_SEQ CHAR(8),
        COIL_NO CHAR(11),
        STEEL_GRADE STRING,
        COIL_WIDTH INTEGER,
        COIL_THICK FLOAT,
        COIL_WEIGHT INTEGER,
        REDUCTION FLOAT,
        PRODUCTION_CODE CHAR(1),
        IC_CODE CHAR(2),
        CLASS_CODE CHAR(1),
        CURR_STATION CHAR(3),
        STATE CHAR(1)
    END RECORD

DEFINE CAPSCH06_arr DYNAMIC ARRAY OF CPSCAP06

DEFINE form_tb sys_ConToolBar

FUNCTION CPSCAP06()
    DEFINE next_work INTEGER

    SET CONNECTION "PCM"
    SET CONNECTION "CPS"
    
    #OPEN FORM CAPSCH06_f FROM "CPSCAP06"
    #DISPLAY FORM CAPSCH06_f

    CALL form_tb.init(FALSE)
    CALL form_tb.setAttribute("_del", TRUE)
    CALL form_tb.getPriv("CPSCAP06")

    CALL ui.Window.getCurrent().getForm().loadTopMenu("cpscap01_topmenu")
    
    CALL getSchdSeq()
    DIALOG ATTRIBUTE(UNBUFFERED)
        SUBDIALOG SchdSeq_dm
        BEFORE DIALOG
            CALL form_tb.setDialogPriv()
        ON ACTION CLOSE
            EXIT DIALOG
        ON ACTION EXIT
            EXIT DIALOG
        ON ACTION CAPSCH06_del
            CALL delSchd()
        #ON ACTION CAPSCH06_F1 --完全清空排程檔
            #CALL delSchd()
        ON ACTION CPSCAP01
            LET next_work = 1
            EXIT DIALOG
        ON ACTION CPSCAP02
            LET next_work = 2
            EXIT DIALOG
        ON ACTION CPSCAP03
            LET next_work = 3
            EXIT DIALOG
        ON ACTION CPSCAP04
            LET next_work = 4
            EXIT DIALOG
    END DIALOG

    CALL CAPSCH06_arr.clear()
    RETURN next_work
END FUNCTION

DIALOG SchdSeq_dm()
    DEFINE ptr, lastBP, s_last CHAR(15)
    DEFINE schd CHAR(4)
    DEFINE s_tmp STRING
    DEFINE dnd ui.DragDrop
    DEFINE idx, len, i, dst INTEGER
    DEFINE drag_320M_arr DYNAMIC ARRAY OF CPSCAP06
    DEFINE del_idx_buff DYNAMIC ARRAY OF INTEGER
    
    DISPLAY ARRAY CAPSCH06_arr TO SchdSeq_r.*
        BEFORE DISPLAY
            #多列選擇模式
            CALL Dialog.setSelectionMode("SchdSeq_r", TRUE)
        BEFORE ROW
            IF CAPSCH06_arr.getLength() == arr_curr() THEN
                SET CONNECTION "CPS"
                LET s_tmp = CAPSCH06_arr[CAPSCH06_arr.getLength()].SCHD_SEQ
                LET schd = s_tmp.subString(1,4)
                
                SELECT BP INTO ptr FROM CCAP320M 
                WHERE SCHD_COIL_NO = schd||CAPSCH06_arr[CAPSCH06_arr.getLength()].COIL_NO
                CALL getPartSchdSeq(ptr, CAPSCH06_arr.getLength(), 5)                
            END IF
        #開始拖移
        ON DRAG_START(dnd)
            SET CONNECTION "CPS"
            CALL drag_320M_arr.clear()
            CALL del_idx_buff.clear()
            LET idx = 1
            LET len = CAPSCH06_arr.getLength()

            LET s_last = getSchdCoilNo(CAPSCH06_arr[len].*)
            SELECT BP INTO lastBP FROM CCAP320M WHERE SCHD_COIL_NO = s_last
            
            FOR i = 1 TO len
                #將選擇並拖移的鋼捲先放進drag_321W_arr
                #其index放進del_idx_buff
                IF DIALOG.isRowSelected("SchdSeq_r", i) THEN
                    LET drag_320M_arr[idx].* = CAPSCH06_arr[i].*
                    LET del_idx_buff[idx] = i
                    LET idx = idx + 1
                END IF
            END FOR
        #放置
        ON DROP(dnd)
            LET dst = dnd.getLocationRow()
            LET len = del_idx_buff.getLength()
            FOR i = len TO 1 STEP -1
                IF del_idx_buff[i] >= dst THEN
                    CALL CAPSCH06_arr.deleteElement(del_idx_buff[i])
                ELSE
                    LET dst = dst - 1
                    CALL CAPSCH06_arr.deleteElement(del_idx_buff[i])
                END IF
            END FOR
            
            LET len = drag_320M_arr.getLength()
            
            FOR i = len TO 1 STEP -1
                CALL CAPSCH06_arr.insertElement(dst)
                LET CAPSCH06_arr[dst].* = drag_320M_arr[i].*
            END FOR
            CALL DIALOG.setCurrentRow("SchdSeq_r", dst)
            CALL DIALOG.setSelectionRange( "SchdSeq_r", dst, dst+drag_320M_arr.getLength()-1, TRUE)

            #以拖拉後的順序set320BPFP
            CALL set320BPFP(lastBP)
    END DISPLAY
END DIALOG

FUNCTION delSchd()
    DEFINE i, len, idx INTEGER
    DEFINE s_tmp STRING
    DEFINE del_trg, mybp, myfp CHAR(15)
    DEFINE del_idx DYNAMIC ARRAY OF INTEGER
    
    LET len = CAPSCH06_arr.getLength()
    LET idx = 0
    
    FOR i = 1 TO len
        IF ui.DIALOG.getCurrent().isRowSelected("SchdSeq_r", i) THEN
            LET s_tmp = CAPSCH06_arr[i].SCHD_SEQ
            LET del_trg = s_tmp.subString(1,4) || CAPSCH06_arr[i].COIL_NO

            SET CONNECTION "CPS"
            SELECT BP, FP INTO mybp, myfp FROM CCAP320M WHERE SCHD_COIL_NO = del_trg
            UPDATE CCAP320M SET BP = mybp WHERE SCHD_COIL_NO = myfp
            UPDATE CCAP320M SET FP = myfp WHERE SCHD_COIL_NO = mybp
            DELETE FROM CCAP320M WHERE SCHD_COIL_NO = del_trg

            LET idx = idx + 1
            LET del_idx[idx] = i
        END IF
    END FOR
    FOR i = idx TO 1 STEP -1
        CALL CAPSCH06_arr.deleteElement(del_idx[i])
    END FOR
END FUNCTION

FUNCTION getSchdSeq()
    DEFINE head CCAP320M_DB.CCAP320M
    DEFINE ptr CHAR(15)

    SET CONNECTION "CPS"
    
    #LET idx = 1
    SELECT * INTO head.* FROM CCAP320M WHERE SCHD_COIL_NO = ' ' 

    LET ptr = head.BP
    CALL getPartSchdSeq(ptr, 0, 10)
END FUNCTION

FUNCTION getPartSchdSeq(ptr CHAR(15), idx INTEGER, num INTEGER)
    DEFINE s_SEQ, s_schd_coil_no, s_prod_code STRING

    LET idx = CAPSCH06_arr.getLength() + 1
    LET num = num + CAPSCH06_arr.getLength()
    
    WHILE ptr != ' '
        SELECT SEQ, SCHD_COIL_NO, STATE
        INTO s_SEQ, s_schd_coil_no, CAPSCH06_arr[idx].STATE
        FROM CCAP320M
        WHERE SCHD_COIL_NO = ptr

        IF s_SEQ.getLength() == 1 THEN
            LET s_SEQ = "00" || s_SEQ
        END IF
        IF s_SEQ.getLength() == 2 THEN
            LET s_SEQ = "0" || s_SEQ
        END IF
        LET s_SEQ = "-" || s_SEQ
        
        LET CAPSCH06_arr[idx].SCHD_SEQ = s_schd_coil_no.subString(1,4) || s_SEQ
        LET CAPSCH06_arr[idx].COIL_NO = s_schd_coil_no.subString(5,15)

        
        SELECT STEEL_GRADE, PRODUCTION_CODE
        INTO CAPSCH06_arr[idx].STEEL_GRADE, s_prod_code
        FROM CCAP210M
        WHERE COIL_NO = CAPSCH06_arr[idx].COIL_NO

        LET CAPSCH06_arr[idx].PRODUCTION_CODE = s_prod_code.subString(2,2)

        IF CAPSCH06_arr[idx].STATE == 'O' THEN
            SELECT ACTUAL_WIDTH,
                    ACTUAL_THICKNESS,
                    NET_WEIGHT,
                    TOTAL_REDUCTION,
                    CLASS_CODE
            INTO CAPSCH06_arr[idx].COIL_WIDTH,
                    CAPSCH06_arr[idx].COIL_THICK,
                    CAPSCH06_arr[idx].COIL_WEIGHT,
                    CAPSCH06_arr[idx].REDUCTION,
                    CAPSCH06_arr[idx].CLASS_CODE
            FROM CCAA030M
            WHERE COIL_NO = CAPSCH06_arr[idx].COIL_NO
        ELSE --I, P, A, R: 還沒產出PDO->從PDI抓
            SELECT ENTRY_WIDTH,
                    ENTRY_THICKNESS,
                    ENTRY_WEIGHT,
                    REDUCTION,
                    CLASS_CODE
            INTO CAPSCH06_arr[idx].COIL_WIDTH, 
                    CAPSCH06_arr[idx].COIL_THICK,
                    CAPSCH06_arr[idx].COIL_WEIGHT,
                    CAPSCH06_arr[idx].REDUCTION,
                    CAPSCH06_arr[idx].CLASS_CODE
            FROM CCAP210M
            WHERE COIL_NO = CAPSCH06_arr[idx].COIL_NO
        END IF

        SET CONNECTION "PCM"
        IF CAPSCH06_arr[idx].STATE == 'O' THEN
            SELECT " ", CURR_STATION
            INTO CAPSCH06_arr[idx].IC_CODE, CAPSCH06_arr[idx].CURR_STATION
            FROM PCMB020M
            WHERE COIL_NO = CAPSCH06_arr[idx].COIL_NO
        ELSE
            SELECT IC_CODE, CURR_STATION
            INTO CAPSCH06_arr[idx].IC_CODE, CAPSCH06_arr[idx].CURR_STATION
            FROM PCMB020M
            WHERE COIL_NO = CAPSCH06_arr[idx].COIL_NO
        END IF
        
        LET idx = idx + 1                
        IF idx > num THEN
            EXIT WHILE
        END IF

        SET CONNECTION "CPS"
        SELECT BP INTO ptr FROM CCAP320M WHERE SCHD_COIL_NO = ptr
    END WHILE
END FUNCTION

#----------------------------------------------------------------------
#更新CCAP320M的BP,FP Linking
#----------------------------------------------------------------------
FUNCTION set320BPFP(lastBP CHAR(15))
    DEFINE i, len INTEGER
    DEFINE s_first, s_last, tmpBP, tmpFP, curr CHAR(15)

    LET len = CAPSCH06_arr.getLength()
    
    IF len < 1 THEN
        RETURN
    END IF
    
    LET s_first = getSchdCoilNo(CAPSCH06_arr[1].*)
    LET s_last = getSchdCoilNo(CAPSCH06_arr[len].*)

    #更新header與first element的BP, FP關係
    #first.FP -> header
    #header.BP -> first
    UPDATE CCAP320M SET BP = s_first WHERE SCHD_COIL_NO = ' '
    UPDATE CCAP320M SET FP = ' ' WHERE SCHD_COIL_NO = s_first

    #更新footer與last element的BP, FP關係
    #footer.FP -> last
    #last.BP -> footer 
    UPDATE CCAP320M SET BP = lastBP WHERE SCHD_COIL_NO = s_last
    UPDATE CCAP320M SET FP = s_last WHERE SCHD_COIL_NO = lastBP

    #設定first & last elements的BP和FP
    #first.BP -> [2] element
    #last.FP -> [len-1] element
    IF len >= 2 THEN
        #第一個element的BP
        LET tmpBP = getSchdCoilNo(CAPSCH06_arr[2].*)
        UPDATE CCAP320M SET BP = tmpBP WHERE SCHD_COIL_NO = s_first
        #最後一個element的FP
        LET tmpFP = getSchdCoilNo(CAPSCH06_arr[len-1].*)
        UPDATE CCAP320M SET FP = tmpFP WHERE SCHD_COIL_NO = s_last
    END IF

    #first與last之間elements的BP,FP設定
    FOR i = 2 TO len - 1
        LET curr = tmpBP
        LET tmpFP = getSchdCoilNo(CAPSCH06_arr[i-1].*)
        LET tmpBP = getSchdCoilNo(CAPSCH06_arr[i+1].*)
        UPDATE CCAP320M SET FP = tmpFP WHERE SCHD_COIL_NO = curr
        UPDATE CCAP320M SET BP = tmpBP WHERE SCHD_COIL_NO = curr
    END FOR

END FUNCTION

FUNCTION getSchdCoilNo(src CPSCAP06)
    DEFINE res CHAR(15) 
    DEFINE s_tmp STRING

    LET s_tmp = src.SCHD_SEQ
    LET res = s_tmp.subString(1,4) || src.COIL_NO
    
    RETURN res
END FUNCTION
