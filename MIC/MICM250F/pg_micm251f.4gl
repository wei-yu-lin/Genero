IMPORT FGL sys_toolbar
IMPORT FGL sys_public
IMPORT FGL fgldialog
IMPORT FGL fun_chxx_desc_determine
IMPORT FGL fun_show_chxx_desc
IMPORT FGL fun_mic_arr_initializer
IMPORT FGL fun_change_msxx_bgcolor
#IMPORT FGL micm250f
IMPORT FGL fun_mic251_arr_initializer

GLOBALS "../../sys/library/sys_globals.4gl"

DEFINE f1, f2 ui.Form
DEFINE mywin, mywin2 ui.Window
SCHEMA rdbmic36

DEFINE mic251_arr DYNAMIC ARRAY OF RECORD
    mh01 LIKE micm240m.MH01,
    mh02 LIKE micm240m.MH02,
    mh03 LIKE micm240m.MH03,
    mh04 LIKE micm240m.MH04,
    mh05 LIKE micm240m.MH05,
    mh06 LIKE micm240m.MH06,
    mh07 LIKE micm240m.MH07,
    mh08 LIKE micm240m.MH08,
    mh09 LIKE micm240m.MH09,
    mh10 LIKE micm240m.MH10,
    mh11 LIKE micm240m.MH11,
    mh12 LIKE micm240m.MH12
END RECORD

DEFINE mic250_arr DYNAMIC ARRAY OF RECORD
    pr_code LIKE micm240m.PR_CODE,
    remark LIKE micm240m.REMARK,
    ch01 LIKE micm240m.CH01,
    ch02 LIKE micm240m.CH02,
    ch03 LIKE micm240m.CH03,
    ch04 LIKE micm240m.CH04,
    ch05 LIKE micm240m.CH05,
    ch06 LIKE micm240m.CH06,
    ch07 LIKE micm240m.CH07,
    ch08 LIKE micm240m.CH08,
    ch09 LIKE micm240m.CH09,
    ch10 LIKE micm240m.CH10,
    ch11 LIKE micm240m.CH11,
    ch12 LIKE micm240m.CH12,
    ch13 LIKE micm240m.CH13,
    ch14 LIKE micm240m.CH14,
    ch15 LIKE micm240m.CH15
END RECORD
DEFINE
    idx2 SMALLINT,
    first_time BOOLEAN = TRUE,
    mark SMALLINT

FUNCTION pg_micm251f(mic_arr, idx)
    DEFINE mic_arr DYNAMIC ARRAY OF RECORD
        pr_code LIKE micm240m.PR_CODE,
        remark LIKE micm240m.REMARK,
        ch01 LIKE micm240m.CH01,
        ch02 LIKE micm240m.CH02,
        ch03 LIKE micm240m.CH03,
        ch04 LIKE micm240m.CH04,
        ch05 LIKE micm240m.CH05,
        ch06 LIKE micm240m.CH06,
        ch07 LIKE micm240m.CH07,
        ch08 LIKE micm240m.CH08,
        ch09 LIKE micm240m.CH09,
        ch10 LIKE micm240m.CH10,
        ch11 LIKE micm240m.CH11,
        ch12 LIKE micm240m.CH12,
        ch13 LIKE micm240m.CH13,
        ch14 LIKE micm240m.CH14,
        ch15 LIKE micm240m.CH15
    END RECORD
    DEFINE idx SMALLINT
    LET idx2 = idx
    IF idx2 > 0 THEN 
        LET mic250_arr[idx2].* = mic_arr[idx2].*
        DISPLAY "mic250_arr data",mic250_arr[idx2].*
    END IF 
    
    CALL start_micm251f()
    CURRENT WINDOW IS w_micm251f

    IF first_time = TRUE THEN
        DISPLAY "this is only be executed at first time"
        LET first_time = FALSE
        WHILE fgl_eventloop()
            #as long as there's one dialog registered, it will return true
        END WHILE
    END IF

END FUNCTION

#-------------------------------------
#開啟明細視窗和明細的dialog module
#-------------------------------------
FUNCTION start_micm251f()
    IF ui.Window.forName("w_micm251f") IS NULL THEN
        INITIALIZE mic251_arr TO NULL
        OPEN WINDOW w_micm251f
            WITH
            FORM "micm251f"
            ATTRIBUTES(STYLE = "mystyle")
        START DIALOG micm251f_dialog

        LET mywin2 = ui.Window.getCurrent()
        LET f2 = mywin2.getForm()
        CALL ui.Interface.loadStyles("mic_style")
        CALL f2.loadToolBar("Toolbar_micm251f")
        IF idx2 > 0 THEN 
            CALL show_mhxx()
        END IF 
    ELSE
        CURRENT WINDOW IS w_micm251f
        IF idx2 > 0 THEN 
            CALL show_mhxx()
        END IF
    END IF
END FUNCTION

DIALOG micm251f_dialog()
    
    MENU
        
        BEFORE MENU
            CURRENT WINDOW IS w_micm250f
        COMMAND "micm251f_upd"
            IF idx2 > 0 THEN 
                CALL micm251f_u()
            ELSE 
                CALL FGL_WINMESSAGE("提示", "請先執行查詢!!", "information")
            END IF 
        COMMAND "bye"
            CALL terminate_micm251f()
        ON ACTION CLOSE
            CALL terminate_micm251f()
    END MENU
END DIALOG

#------------------------------------------------------------------------
# 修改資料
#------------------------------------------------------------------------
FUNCTION micm251f_u()
    DEFINE alter_ok, del_ok, t_cur SMALLINT

    LABEL input_rec:
    #LET t_status = "U"
    LET mark = 0
    #欄位輸入

    DIALOG ATTRIBUTES(UNBUFFERED)

        INPUT mic251_arr[idx2].* FROM v_micm251f.* ATTRIBUTE(WITHOUT DEFAULTS)
            #BEFORE INPUT
            #CALL DIALOG.setFieldActive("pr_code",0)
            #CALL DIALOG.setFieldActive("remark",0)
            #AFTER FIELD ch14

            BEFORE INPUT
                CALL DIALOG.setFieldActive("MH12", FALSE)
            AFTER FIELD mh01
                CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
            AFTER FIELD mh02
                CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
            AFTER FIELD mh03
                CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
            AFTER FIELD mh04
                CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
            AFTER FIELD mh05
                CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
            AFTER FIELD mh06
                CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
            AFTER FIELD mh07
                CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
            AFTER FIELD mh08
                CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
            AFTER FIELD mh09
                CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
            AFTER FIELD mh10
                CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
            AFTER FIELD mh11
                CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)

            ON KEY(ACCEPT)
                CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
                EXIT DIALOG
        END INPUT

        ON ACTION micm251f_save #按存檔
            CALL fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
            EXIT DIALOG

        ON ACTION bye
            LET mark = 1
            #CALL micm250f_clear()
            EXIT DIALOG

    END DIALOG

    IF mark = 0 THEN
        # "提示","是否確定修改資料?"
        MENU %"提示" ATTRIBUTES(STYLE = "dialog", COMMENT = "是否確定修改資料?")
            #確定
            COMMAND "確定"
                #update明細檔
                CALL micm251f_u_update() RETURNING alter_ok

                CASE alter_ok
                    WHEN TRUE
                        #提示 資料已修改完畢!!
                        CALL FGL_WINMESSAGE(
                            "提示", "資料已修改完畢!!", "information")
                        #CALL micm250f_reload()
                        #DISPLAY "where=" || where_clause
                    WHEN FALSE
                        #警告 資料修改有誤!!
                        CALL FGL_WINMESSAGE("警告", "資料修改有誤", "stop")
                        GOTO input_rec
                END CASE

            COMMAND %"取消"
                GOTO input_rec

            COMMAND %"放棄"
                #CALL micm250f_reload()
        END MENU
    END IF
END FUNCTION

#-----------------------------------------------------------------------
#
#-----------------------------------------------------------------------
FUNCTION micm251f_u_update()
    DEFINE i, alter_ok SMALLINT
    DEFINE s_sql STRING
    LET i = 1
    LET alter_ok = 1

    CALL fun_mic251_arr_initializer(mic251_arr, idx2)

    LET s_sql =
        "update micm240m set"
            || " mh01="
            || mic251_arr[idx2].mh01
            || ", mh02="
            || mic251_arr[idx2].mh02
            || ", mh03="
            || mic251_arr[idx2].mh03
            || ", mh04="
            || mic251_arr[idx2].mh04
            || ", mh05="
            || mic251_arr[idx2].mh05
            || ", mh06="
            || mic251_arr[idx2].mh06
            || ", mh07="
            || mic251_arr[idx2].mh07
            || ", mh08="
            || mic251_arr[idx2].mh08
            || ", mh09="
            || mic251_arr[idx2].mh09
            || ", mh10="
            || mic251_arr[idx2].mh10
            || ", mh11="
            || mic251_arr[idx2].mh11
            || ", mh12="
            || mic251_arr[idx2].mh12
            || " where pr_code='"
            || mic250_arr[idx2].pr_code
            || "'"
    DISPLAY s_sql
    WHENEVER ERROR CONTINUE
    EXECUTE IMMEDIATE s_sql
    WHENEVER ERROR STOP
    IF SQLCA.SQLCODE = 0 THEN
        LET alter_ok = TRUE
    ELSE
        LET alter_ok = FALSE
    END IF

    RETURN alter_ok
END FUNCTION

FUNCTION  show_mhxx()
    TRY 
    DECLARE c1 CURSOR FOR
                SELECT mh01,
                    mh02,
                    mh03,
                    mh04,
                    mh05,
                    mh06,
                    mh07,
                    mh08,
                    mh09,
                    mh10,
                    mh11,
                    mh12
                    FROM micm240m
                    WHERE pr_code = mic250_arr[idx2].pr_code
            OPEN c1
            FETCH c1 INTO mic251_arr[idx2].*
            CLOSE c1
            DISPLAY mic251_arr[idx2].* TO v_micm251f.*
            CALL fun_change_msxx_bgcolor(mic251_arr,idx2,f2)
    CATCH 
        DISPLAY SQLERRMESSAGE 
    END TRY 
END FUNCTION 
