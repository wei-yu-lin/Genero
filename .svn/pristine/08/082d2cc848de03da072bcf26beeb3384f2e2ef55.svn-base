GLOBALS "../../sys/library/sys_globals.4gl"

SCHEMA rdbmic36
DEFINE
    micm140m_arr DYNAMIC ARRAY OF RECORD
        spec LIKE micm140m.SPEC
    END RECORD
   
DEFINE curr_pa, idx SMALLINT


#------------------------------------------------------------------------
# MIC系統查詢(產品規範代碼)頁面
#------------------------------------------------------------------------
FUNCTION mic_spec()
    DEFINE
        spec VARCHAR(15),
        sql_txt STRING
        
    LET sql_txt = ""
    #CLEAR FORM
    #CALL mic_arr.clear()
    
    TRY
        OPEN WINDOW micm140q WITH FORM "micm140q" ATTRIBUTES(STYLE = 'mystyle')
        CURRENT WINDOW IS micm140q
       
        LET sql_txt =
            " SELECT spec FROM micm140m"
                || " order by spec"

        PREPARE query_140m FROM sql_txt
        DECLARE mic_curs SCROLL CURSOR FOR query_140m

        LET idx = 1
        WHENEVER ERROR CONTINUE
        FOREACH mic_curs INTO micm140m_arr[idx].*
            LET idx = idx + 1
        END FOREACH
        WHENEVER ERROR STOP

        IF idx > 0 THEN
            LET int_flag = FALSE
            DISPLAY ARRAY micm140m_arr TO micm140m_rec.* ATTRIBUTES(COUNT = idx)
            IF (NOT int_flag) THEN
                LET curr_pa = arr_curr()
                LET spec = micm140m_arr[curr_pa].spec
            END IF
        END IF

        CLOSE WINDOW micm140q
    CATCH
        CALL FGL_WINMESSAGE(
            LSTR("警示"), "Call Function micm140q error!!", "stop")
    END TRY
    FREE query_140m
    CLOSE mic_curs
    
    RETURN spec

END FUNCTION
