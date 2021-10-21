GLOBALS "../../sys/library/sys_globals.4gl"

SCHEMA rdbmic36
DEFINE
    micm145m_arr DYNAMIC ARRAY OF RECORD
        #spec LIKE micm145m.SPEC,
        steel_grade_jis LIKE micm145m.STEEL_GRADE_JIS
    END RECORD

DEFINE curr_pa, idx SMALLINT


#------------------------------------------------------------------------
# MIC系統查詢(規範鋼種)頁面
#------------------------------------------------------------------------
FUNCTION mic_steel(spec1)
    DEFINE
        spec1 VARCHAR(15),
        steel_grade_jis VARCHAR(15),
        sql_txt STRING

    DISPLAY spec1    
    LET sql_txt = ""
    CALL micm145m_arr.clear()
    
    TRY
        OPEN WINDOW micm145q WITH FORM "micm145q" ATTRIBUTES(STYLE = 'mystyle')
        CURRENT WINDOW IS micm145q

        
        LET sql_txt =
            " SELECT steel_grade_jis FROM micm145m"
                || " where spec = '" || spec1 || "'"
                || " order by spec,steel_grade_jis"

        DISPLAY "sql_txt:" , sql_txt        
        PREPARE query_145m FROM sql_txt
        DECLARE mic_curs1 SCROLL CURSOR FOR query_145m

        LET idx = 1
        WHENEVER ERROR CONTINUE
        FOREACH mic_curs1 INTO micm145m_arr[idx].*
            LET idx = idx + 1
        END FOREACH
        WHENEVER ERROR STOP

        IF idx > 0 THEN
            LET int_flag = FALSE
            DISPLAY ARRAY micm145m_arr TO micm145m_rec.* ATTRIBUTES(COUNT = idx)
            IF (NOT int_flag) THEN
                LET curr_pa = arr_curr()
                LET steel_grade_jis = micm145m_arr[curr_pa].steel_grade_jis
            END IF
        END IF

        CLOSE WINDOW micm145q
    CATCH
        CALL FGL_WINMESSAGE(
            LSTR("警示"), "Call Function micm145q error!!", "stop")
    END TRY
    FREE query_145m
    CLOSE mic_curs1
    
    RETURN steel_grade_jis

END FUNCTION

