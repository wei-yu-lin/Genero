IMPORT FGL CZFP320M_DB
IMPORT FGL CZFP321W_DB
IMPORT FGL CZFP322W_DB
IMPORT FGL CPSCR6_INC
IMPORT FGL sys_toolbar

#------------------------------------------------------------------------------
# CPSCR606
#------------------------------------------------------------------------------
TYPE CPSCR606 RECORD
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

DEFINE CPSCR606_arr DYNAMIC ARRAY OF CPSCR606

DEFINE form_tb sys_ConToolBar

FUNCTION CPSCR606()
    DEFINE next_work INTEGER

    SET CONNECTION "PCM"
    SET CONNECTION "CR2"
    
    #OPEN FORM CPSCR606_f FROM "CPSCR606"
    #DISPLAY FORM CPSCR606_f

    CALL form_tb.init(FALSE)
    CALL form_tb.setAttribute("_del", TRUE)
    CALL form_tb.getPriv("CPSCR606")
    
    CALL ui.Window.getCurrent().getForm().loadTopMenu("cr6sch01_topmenu")
    
    CALL getSchdSeq()
    DIALOG ATTRIBUTE(UNBUFFERED)
        SUBDIALOG SchdSeq_dm
        BEFORE DIALOG
            CALL form_tb.setDialogPriv()
        ON ACTION CLOSE
            EXIT DIALOG
        ON ACTION EXIT
            EXIT DIALOG
        ON ACTION CPSCR606_del
            CALL delSchd()
        #ON ACTION CPSCR606_F1 --完全清空排程檔
            #CALL delSchd()
        ON ACTION CPSCR601
            LET next_work = 1
            EXIT DIALOG
        ON ACTION CPSCR602
            LET next_work = 2
            EXIT DIALOG
        ON ACTION CPSCR603
            LET next_work = 3
            EXIT DIALOG
        ON ACTION CPSCR604
            LET next_work = 4
            EXIT DIALOG
    END DIALOG

    CALL CPSCR606_arr.clear()
    RETURN next_work
END FUNCTION

DIALOG SchdSeq_dm()
    DEFINE ptr, lastBP, s_last CHAR(15)
    DEFINE schd CHAR(4)
    DEFINE s_tmp STRING
    DEFINE dnd ui.DragDrop
    DEFINE idx, len, i, dst INTEGER
    DEFINE drag_320M_arr DYNAMIC ARRAY OF CPSCR606
    DEFINE del_idx_buff DYNAMIC ARRAY OF INTEGER
    
    DISPLAY ARRAY CPSCR606_arr TO SchdSeq_r.*
        BEFORE DISPLAY
            #多列選擇模式
            CALL Dialog.setSelectionMode("SchdSeq_r", TRUE)
        BEFORE ROW
            IF CPSCR606_arr.getLength() == arr_curr() THEN
                SET CONNECTION "CR2"
                LET s_tmp = CPSCR606_arr[CPSCR606_arr.getLength()].SCHD_SEQ
                LET schd = s_tmp.subString(1,4)
                
                SELECT BP INTO ptr FROM CZFP320M 
                WHERE SCHD_COIL_NO = schd||CPSCR606_arr[CPSCR606_arr.getLength()].COIL_NO
                CALL getPartSchdSeq(ptr, CPSCR606_arr.getLength(), 5)                
            END IF
        #開始拖移
        ON DRAG_START(dnd)
            SET CONNECTION "CR2"
            CALL drag_320M_arr.clear()
            CALL del_idx_buff.clear()
            LET idx = 1
            LET len = CPSCR606_arr.getLength()

            LET s_last = getSchdCoilNo(CPSCR606_arr[len].*)
            SELECT BP INTO lastBP FROM CZFP320M WHERE SCHD_COIL_NO = s_last
            
            FOR i = 1 TO len
                #將選擇並拖移的鋼捲先放進drag_321W_arr
                #其index放進del_idx_buff
                IF DIALOG.isRowSelected("SchdSeq_r", i) THEN
                    LET drag_320M_arr[idx].* = CPSCR606_arr[i].*
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
                    CALL CPSCR606_arr.deleteElement(del_idx_buff[i])
                ELSE
                    LET dst = dst - 1
                    CALL CPSCR606_arr.deleteElement(del_idx_buff[i])
                END IF
            END FOR
            
            LET len = drag_320M_arr.getLength()
            
            FOR i = len TO 1 STEP -1
                CALL CPSCR606_arr.insertElement(dst)
                LET CPSCR606_arr[dst].* = drag_320M_arr[i].*
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
    
    LET len = CPSCR606_arr.getLength()
    LET idx = 0
    
    FOR i = 1 TO len
        IF ui.DIALOG.getCurrent().isRowSelected("SchdSeq_r", i) THEN
            LET s_tmp = CPSCR606_arr[i].SCHD_SEQ
            LET del_trg = s_tmp.subString(1,4) || CPSCR606_arr[i].COIL_NO

            SET CONNECTION "CR2"
            SELECT BP, FP INTO mybp, myfp FROM CZFP320M WHERE SCHD_COIL_NO = del_trg
            UPDATE CZFP320M SET BP = mybp WHERE SCHD_COIL_NO = myfp
            UPDATE CZFP320M SET FP = myfp WHERE SCHD_COIL_NO = mybp
            DELETE FROM CZFP320M WHERE SCHD_COIL_NO = del_trg

            LET idx = idx + 1
            LET del_idx[idx] = i
        END IF
    END FOR
    FOR i = idx TO 1 STEP -1
        CALL CPSCR606_arr.deleteElement(del_idx[i])
    END FOR
END FUNCTION

FUNCTION getSchdSeq()
    DEFINE head CZFP320M_DB.CZFP320M
    DEFINE ptr CHAR(15)

    SET CONNECTION "CR2"
    
    #LET idx = 1
    SELECT * INTO head.* FROM CZFP320M WHERE SCHD_COIL_NO = ' ' 

    LET ptr = head.BP
    CALL getPartSchdSeq(ptr, 0, 10)
END FUNCTION

FUNCTION getPartSchdSeq(ptr CHAR(15), idx INTEGER, num INTEGER)
    DEFINE s_seq_no, s_schd_coil_no, s_prod_code STRING

    LET idx = CPSCR606_arr.getLength() + 1
    LET num = num + CPSCR606_arr.getLength()
    
    WHILE ptr != ' '
        SELECT SEQ_NO, SCHD_COIL_NO, STATE
        INTO s_seq_no, s_schd_coil_no, CPSCR606_arr[idx].STATE
        FROM CZFP320M
        WHERE SCHD_COIL_NO = ptr

        IF s_seq_no.getLength() == 1 THEN
            LET s_seq_no = "00" || s_seq_no
        END IF
        IF s_seq_no.getLength() == 2 THEN
            LET s_seq_no = "0" || s_seq_no
        END IF
        LET s_seq_no = "-" || s_seq_no
        
        LET CPSCR606_arr[idx].SCHD_SEQ = s_schd_coil_no.subString(1,4) || s_seq_no
        LET CPSCR606_arr[idx].COIL_NO = s_schd_coil_no.subString(5,15)

        
        SELECT STEEL_GRADE, PRODUCTION_CODE
        INTO CPSCR606_arr[idx].STEEL_GRADE, s_prod_code
        FROM CZFP210M
        WHERE COIL_NO = CPSCR606_arr[idx].COIL_NO

        LET CPSCR606_arr[idx].PRODUCTION_CODE = s_prod_code.subString(2,2)

        IF CPSCR606_arr[idx].STATE == 'O' THEN
            SELECT ACTUAL_WIDTH,
                    ACTUAL_THICKNESS,
                    NET_WEIGHT,
                    TOTAL_REDUCTION,
                    CLASS_CODE
            INTO CPSCR606_arr[idx].COIL_WIDTH,
                    CPSCR606_arr[idx].COIL_THICK,
                    CPSCR606_arr[idx].COIL_WEIGHT,
                    CPSCR606_arr[idx].REDUCTION,
                    CPSCR606_arr[idx].CLASS_CODE
            FROM CZFA030M
            WHERE COIL_NO = CPSCR606_arr[idx].COIL_NO
        ELSE --I, P, A, R: 還沒產出PDO->從PDI抓
            SELECT ENTRY_WIDTH,
                    ENTRY_THICKNESS,
                    ENTRY_WEIGHT,
                    REDUCTION,
                    CLASS_CODE
            INTO CPSCR606_arr[idx].COIL_WIDTH, 
                    CPSCR606_arr[idx].COIL_THICK,
                    CPSCR606_arr[idx].COIL_WEIGHT,
                    CPSCR606_arr[idx].REDUCTION,
                    CPSCR606_arr[idx].CLASS_CODE
            FROM CZFP210M
            WHERE COIL_NO = CPSCR606_arr[idx].COIL_NO
        END IF

        SET CONNECTION "PCM"
        IF CPSCR606_arr[idx].STATE == 'O' THEN
            SELECT " ", CURR_STATION
            INTO CPSCR606_arr[idx].IC_CODE, CPSCR606_arr[idx].CURR_STATION
            FROM PCMB020M
            WHERE COIL_NO = CPSCR606_arr[idx].COIL_NO
        ELSE
            SELECT IC_CODE, CURR_STATION
            INTO CPSCR606_arr[idx].IC_CODE, CPSCR606_arr[idx].CURR_STATION
            FROM PCMB020M
            WHERE COIL_NO = CPSCR606_arr[idx].COIL_NO
        END IF
        
        LET idx = idx + 1                
        IF idx > num THEN
            EXIT WHILE
        END IF

        SET CONNECTION "CR2"
        SELECT BP INTO ptr FROM CZFP320M WHERE SCHD_COIL_NO = ptr
    END WHILE
END FUNCTION

#----------------------------------------------------------------------
#更新CZFP320M的BP,FP Linking
#----------------------------------------------------------------------
FUNCTION set320BPFP(lastBP CHAR(15))
    DEFINE i, len INTEGER
    DEFINE s_first, s_last, tmpBP, tmpFP, curr CHAR(15)

    LET len = CPSCR606_arr.getLength()
    
    IF len < 1 THEN
        RETURN
    END IF
    
    LET s_first = getSchdCoilNo(CPSCR606_arr[1].*)
    LET s_last = getSchdCoilNo(CPSCR606_arr[len].*)

    #更新header與first element的BP, FP關係
    #first.FP -> header
    #header.BP -> first
    UPDATE CZFP320M SET BP = s_first WHERE SCHD_COIL_NO = ' '
    UPDATE CZFP320M SET FP = ' ' WHERE SCHD_COIL_NO = s_first

    #更新footer與last element的BP, FP關係
    #footer.FP -> last
    #last.BP -> footer 
    UPDATE CZFP320M SET BP = lastBP WHERE SCHD_COIL_NO = s_last
    UPDATE CZFP320M SET FP = s_last WHERE SCHD_COIL_NO = lastBP

    #設定first & last elements的BP和FP
    #first.BP -> [2] element
    #last.FP -> [len-1] element
    IF len >= 2 THEN
        #第一個element的BP
        LET tmpBP = getSchdCoilNo(CPSCR606_arr[2].*)
        UPDATE CZFP320M SET BP = tmpBP WHERE SCHD_COIL_NO = s_first
        #最後一個element的FP
        LET tmpFP = getSchdCoilNo(CPSCR606_arr[len-1].*)
        UPDATE CZFP320M SET FP = tmpFP WHERE SCHD_COIL_NO = s_last
    END IF

    #first與last之間elements的BP,FP設定
    FOR i = 2 TO len - 1
        LET curr = tmpBP
        LET tmpFP = getSchdCoilNo(CPSCR606_arr[i-1].*)
        LET tmpBP = getSchdCoilNo(CPSCR606_arr[i+1].*)
        UPDATE CZFP320M SET FP = tmpFP WHERE SCHD_COIL_NO = curr
        UPDATE CZFP320M SET BP = tmpBP WHERE SCHD_COIL_NO = curr
    END FOR

END FUNCTION

FUNCTION getSchdCoilNo(src CPSCR606)
    DEFINE res CHAR(15) 
    DEFINE s_tmp STRING

    LET s_tmp = src.SCHD_SEQ
    LET res = s_tmp.subString(1,4) || src.COIL_NO
    
    RETURN res
END FUNCTION
