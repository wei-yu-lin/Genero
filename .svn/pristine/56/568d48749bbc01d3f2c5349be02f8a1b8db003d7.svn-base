IMPORT FGL sys_toolbar
IMPORT FGL sys_public
IMPORT FGL fgldialog
IMPORT FGL fun_chxx_desc_determine
IMPORT FGL fun_show_chxx_desc
IMPORT FGL fun_mic_arr_initializer
IMPORT FGL pg_micm251f

GLOBALS "../../sys/library/sys_globals.4gl"

DEFINE f1 ui.Form
DEFINE mywin ui.Window
SCHEMA rdbmic36
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
DEFINE csxx_definition
    ARRAY[24] OF
    STRING
    = ["C ",
        "Si",
        "Mn",
        "P ",
        "S ",
        "Ni",
        "Cr",
        "Mo",
        "Cu",
        "N ",
        "O ",
        "Ti",
        "B ",
        "Nb",
        "Al",
        "V ",
        "Sn",
        "Co",
        "Pb",
        "Ca",
        "CE",
        "WC",
        "Kf",
        "Ca|CE|Pcm|Kfa"]

DEFINE chxx_desc DYNAMIC ARRAY OF STRING
DEFINE mark SMALLINT

DEFINE
    t_date VARCHAR(8),
    t_time VARCHAR(6),
    t_status VARCHAR(1)

CONSTANT prog_last_maint = "MICM250F"

DEFINE pr_code, where_clause STRING
DEFINE idx SMALLINT

MAIN
    CONNECT TO "rdbmic36" AS "MIC"
    CALL sys_date() RETURNING t_date
    CALL sys_time() RETURNING t_time

    CALL start_micm250f()
    WHILE fgl_eventloop()
        #as long as there's one dialog registered, it will return true
    END WHILE
END MAIN

FUNCTION start_micm250f()
    IF ui.Window.forName("w_micm250f") IS NULL THEN

        CLOSE WINDOW SCREEN
        OPEN WINDOW w_micm250f
            WITH
            FORM "micm250f"
            ATTRIBUTES(STYLE = "mystyle")

        START DIALOG micm250f_dialog
        LET mywin = ui.Window.getCurrent()
        LET f1 = mywin.getForm()
        CALL ui.Interface.loadStyles("sys_style")
        CALL f1.loadToolBar("Toolbar_micm250f")
    ELSE
        CURRENT WINDOW IS w_micm250f
    END IF
END FUNCTION

DIALOG micm250f_dialog()
    MENU
        COMMAND "micm250f_query"
            CALL micm250f_r()
            IF ui.Window.forName("w_micm251f") IS NOT NULL THEN
                CALL pg_micm251f(mic_arr, idx)
            END IF
        COMMAND "micm250f_next"
            CALL micm250f_r2(1)
            IF ui.Window.forName("w_micm251f") IS NOT NULL THEN
                CALL pg_micm251f(mic_arr, idx)
            END IF
        COMMAND "micm250f_prev"
            CALL micm250f_r2(-1)
            IF ui.Window.forName("w_micm251f") IS NOT NULL THEN
                CALL pg_micm251f(mic_arr, idx)
            END IF
        COMMAND "micm250f_add"
            CALL micm250f_i()
        COMMAND "micm250f_upd"
            IF idx > 0 THEN
                CALL micm250f_u()
            ELSE
                CALL FGL_WINMESSAGE("提示", "請先執行查詢!!", "information")
            END IF
        COMMAND "micm250f_del"
            IF idx > 0 THEN
                CALL micm250f_d()
            ELSE
                CALL FGL_WINMESSAGE("提示", "請先執行查詢!!", "information")
            END IF
        COMMAND "micm250f_p2"
            IF idx > 0 THEN
                CALL pg_micm251f(mic_arr, idx)
            ELSE
                CALL FGL_WINMESSAGE("提示", "請先執行查詢!!", "information")
            END IF
        COMMAND "bye"
            CALL terminate_micm250f()
            IF ui.Window.forName("w_micm251f") IS NOT NULL THEN
                CALL terminate_micm251f()
            END IF
        ON ACTION CLOSE
            CALL terminate_micm250f()
            IF ui.Window.forName("w_micm251f") IS NOT NULL THEN
                CALL terminate_micm251f()
            END IF
    END MENU
END DIALOG

FUNCTION micm250f_r()

    LET t_status = "R"
    LET mark = 0

    CLEAR FORM
    CALL mic_arr.clear()

    DIALOG ATTRIBUTE(UNBUFFERED)
        INPUT mic_arr[1].pr_code FROM v_micm250f.pr_code
            ON KEY(ACCEPT)
                EXIT DIALOG
            ON ACTION bye
                CALL micm250f_clear()
                EXIT DIALOG
        END INPUT
    END DIALOG
    DISPLAY mic_arr[1].pr_code
    LET pr_code = mic_arr[1].pr_code
    LET pr_code = pr_code.toUpperCase()

    IF LENGTH(pr_code) <> 0 THEN
        LET where_clause = "where pr_code='" || pr_code || "' "
    ELSE
        LET where_clause = ""
    END IF

    CALL micm250f_r1()
END FUNCTION

FUNCTION micm250f_r1()
    DEFINE sql_txt STRING

    IF length(where_clause) = 0 THEN
        LET sql_txt =
            "select pr_code,remark,ch01,ch02,ch03,ch04,ch05,ch06,ch07,"
                || "ch08,ch09,ch10,ch11,ch12,ch13,ch14,ch15"
                || " from micm240m "
                || " order by pr_code"
    ELSE
        LET sql_txt =
            "select pr_code,remark,ch01,ch02,ch03,ch04,ch05,ch06,ch07,"
                    || "ch08,ch09,ch10,ch11,ch12,ch13,ch14,ch15"
                    || " from micm240m "
                    || where_clause CLIPPED
                || " order by pr_code"
    END IF

    DISPLAY sql_txt
    PREPARE query_sql FROM sql_txt
    DECLARE mic_curs SCROLL CURSOR FOR query_sql

    LET idx = 1
    WHENEVER ERROR CONTINUE
    FOREACH mic_curs INTO mic_arr[idx].*
        LET idx = idx + 1
    END FOREACH
    WHENEVER ERROR STOP

    IF (idx > 1) THEN
        CALL mic_arr.deleteElement(idx)
        LET idx = 1

        CALL fun_chxx_desc_determine(
            chxx_desc, mic_arr, csxx_definition, idx)
            RETURNING chxx_desc
        CALL fun_show_chxx_desc(chxx_desc, f1)

        DISPLAY mic_arr[idx].* TO v_micm250f.*
    ELSE
        IF t_status = "R" THEN
            #資料不存在,請確認!!
            CALL FGL_WINMESSAGE("警示", "資料不存在,請確認!!", "stop")
            LET idx=0
        END IF

    END IF

    FREE query_sql
    FREE mic_curs
END FUNCTION

#-------------------------------------
#讀取上一筆及下一筆資料
#-------------------------------------
FUNCTION micm250f_r2(ci)
    DEFINE ci INTEGER
    LET idx = idx + ci

    IF idx < 1 THEN
        CALL FGL_WINMESSAGE("提示", "no prev data", "stop")
        LET idx = idx - ci
        RETURN
    ELSE
        IF idx > mic_arr.getLength() THEN
            CALL FGL_WINMESSAGE("提示", "no next data", "stop")
            LET idx = idx - ci
            RETURN
        END IF
    END IF
    CALL fun_chxx_desc_determine(
        chxx_desc, mic_arr, csxx_definition, idx)
        RETURNING chxx_desc
    CALL fun_show_chxx_desc(chxx_desc, f1)
    DISPLAY mic_arr[idx].* TO v_micm250f.*

END FUNCTION

#-----------------------------------------------------------------------
# 新增
#-----------------------------------------------------------------------
FUNCTION micm250f_i()
    DEFINE add_ok SMALLINT

    CLEAR FORM
    LET where_clause = ""
    CALL mic_arr.clear()

    LET mark = 0
    LET idx = 1
    DIALOG ATTRIBUTE(UNBUFFERED)

        INPUT mic_arr[idx].* FROM v_micm250f.*
            AFTER FIELD ch01
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch02
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch03
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch04
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch05
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch06
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch07
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch08
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch09
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch10
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch11
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch12
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch13
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch14
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch15
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            ON KEY(ACCEPT)
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
                EXIT DIALOG
        END INPUT

        ON ACTION micm250f_save #按存檔
            EXIT DIALOG

        ON ACTION bye
            LET mark = 1
            LET idx=0
            CALL micm250f_clear()
            EXIT DIALOG

    END DIALOG
    IF mark = 0 THEN
        MENU %"提示"
            ATTRIBUTES(STYLE = "dialog", COMMENT = LSTR("是否確定新增資料?"))
            COMMAND %"確定"
                #CALL mic_arr.getLength() RETURNING idx
                CALL micm250f_i_insert(idx) RETURNING add_ok
                IF add_ok = TRUE THEN
                    CALL FGL_WINMESSAGE(
                        "提示", "資料已新增完畢!!", "information")
                    CALL micm250f_reload()
                END IF
                IF add_ok = FALSE THEN
                    CALL FGL_WINMESSAGE("警示", "新增有誤!!", "stop")
                END IF

            COMMAND %"取消"
                LET idx=0
                CLEAR FORM
                CALL micm250f_clear()

        END MENU
    END IF
END FUNCTION
#------------------------------------------------------------------------
#新增_寫入資料
#------------------------------------------------------------------------
FUNCTION micm250f_i_insert(idx)
    DEFINE add_ok, idx, i SMALLINT

    LET i = 1
    LET add_ok = TRUE
    LET pr_code = mic_arr[i].pr_code
    LET pr_code = pr_code.toUpperCase()
    WHENEVER ERROR CONTINUE
    IF LENGTH(pr_code) > 0 THEN
        INSERT INTO micm240m(
            pr_code,
            ch01,
            ch02,
            ch03,
            ch04,
            ch05,
            ch06,
            ch07,
            ch08,
            ch09,
            ch10,
            ch11,
            ch12,
            ch13,
            ch14,
            ch15,
            remark,
            user_last_maint,
            prog_last_maint,
            date_last_maint,
            time_last_maint)
            VALUES(pr_code,
                mic_arr[i].ch01,
                mic_arr[i].ch02,
                mic_arr[i].ch03,
                mic_arr[i].ch04,
                mic_arr[i].ch05,
                mic_arr[i].ch06,
                mic_arr[i].ch07,
                mic_arr[i].ch08,
                mic_arr[i].ch09,
                mic_arr[i].ch10,
                mic_arr[i].ch11,
                mic_arr[i].ch12,
                mic_arr[i].ch13,
                mic_arr[i].ch14,
                mic_arr[i].ch15,
                mic_arr[i].remark,
                "yu65655",
                prog_last_maint,
                t_date,
                t_time)
    END IF

    IF (SQLCA.SQLCODE = 0) THEN
        LET add_ok = TRUE
    ELSE
        LET add_ok = FALSE
        ERROR SQLERRMESSAGE
    END IF
    WHENEVER ERROR STOP

    RETURN add_ok

END FUNCTION

#------------------------------------------------------------------------
# 修改資料
#------------------------------------------------------------------------
FUNCTION micm250f_u()
    DEFINE alter_ok, del_ok, t_cur SMALLINT

    LABEL input_rec:
    LET t_status = "U"
    LET mark = 0
    #欄位輸入

    DIALOG ATTRIBUTES(UNBUFFERED)

        INPUT mic_arr[idx].* FROM v_micm250f.* ATTRIBUTE(WITHOUT DEFAULTS)
            #BEFORE INPUT
            #CALL DIALOG.setFieldActive("pr_code",0)
            #CALL DIALOG.setFieldActive("remark",0)
            #AFTER FIELD ch14
            AFTER FIELD ch01
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch02
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch03
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch04
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch05
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch06
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch07
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch08
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch09
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch10
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch11
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch12
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch13
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch14
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            AFTER FIELD ch15
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
            ON KEY(ACCEPT)
                CALL fun_chxx_desc_determine(
                    chxx_desc, mic_arr, csxx_definition, idx)
                    RETURNING chxx_desc
                CALL fun_show_chxx_desc(chxx_desc, f1)
                EXIT DIALOG
        END INPUT

        ON ACTION micm250f_save #按存檔
            CALL fun_chxx_desc_determine(
                chxx_desc, mic_arr, csxx_definition, idx)
                RETURNING chxx_desc
            CALL fun_show_chxx_desc(chxx_desc, f1)
            EXIT DIALOG

        ON ACTION bye
            LET mark = 1
            CALL micm250f_reload()
            EXIT DIALOG

    END DIALOG

    IF mark = 0 THEN
        # "提示","是否確定修改資料?"
        MENU %"提示" ATTRIBUTES(STYLE = "dialog", COMMENT = "是否確定修改資料?")
            #確定
            COMMAND "確定"
                #update明細檔
                CALL micm250f_u_update() RETURNING alter_ok

                CASE alter_ok
                    WHEN TRUE
                        #提示 資料已修改完畢!!
                        CALL FGL_WINMESSAGE(
                            "提示", "資料已修改完畢!!", "information")
                        #CALL micm250f_reload()
                        DISPLAY "where=" || where_clause
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
FUNCTION micm250f_u_update()
    DEFINE i, alter_ok SMALLINT
    DEFINE s_sql STRING
    LET i = 1
    LET alter_ok = 1

    CALL fun_mic_arr_initializer(mic_arr, idx)

    LET s_sql =
        "update micm240m set pr_code='"
                || mic_arr[idx].pr_code
                || "', "
                || "remark='"
                || mic_arr[idx].remark CLIPPED
            || "', ch01="
            || mic_arr[idx].ch01
            || ", ch02="
            || mic_arr[idx].ch02
            || ", ch03="
            || mic_arr[idx].ch03
            || ", ch04="
            || mic_arr[idx].ch04
            || ", ch05="
            || mic_arr[idx].ch05
            || ", ch06="
            || mic_arr[idx].ch06
            || ", ch07="
            || mic_arr[idx].ch07
            || ", ch08="
            || mic_arr[idx].ch08
            || ", ch09="
            || mic_arr[idx].ch09
            || ", ch10="
            || mic_arr[idx].ch10
            || ", ch11="
            || mic_arr[idx].ch11
            || ", ch12="
            || mic_arr[idx].ch12
            || ", ch13="
            || mic_arr[idx].ch13
            || ", ch14="
            || mic_arr[idx].ch14
            || ", ch15="
            || mic_arr[idx].ch15
            || ", date_last_maint='"
            || t_date
            || "', time_last_maint='"
            || t_time
            || "', prog_last_maint='"
            || prog_last_maint
            || "', user_last_maint='"
            || "yu65655' "
            || " where pr_code='"
            || mic_arr[idx].pr_code
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
#-----------------------------------------------------------------------
#刪除資料
#-----------------------------------------------------------------------
FUNCTION micm250f_d()
    DEFINE sql_txt, ans STRING

    TRY
        DISPLAY pr_code
        LET ans =
            FGL_WINBUTTON(
                "刪除資料",
                "是否確定刪除?",
                "Lynx",
                "確定" || "|" || "取消",
                "question",
                0)

        IF ans = "確定" THEN --"yes" THEN
            LET sql_txt =
                "delete from micm240m where pr_code='" || pr_code || "'"

            IF (SQLCA.SQLCODE = 0) THEN
                DISPLAY "success"
            ELSE

                DISPLAY SQLERRMESSAGE
            END IF
            DISPLAY sql_txt
            WHENEVER ERROR CONTINUE
            EXECUTE IMMEDIATE sql_txt
            WHENEVER ERROR STOP
            #"資料已刪除完畢!!"
            CALL FGL_WINMESSAGE("提示", "資料已刪除完畢!!", "information")
            CALL micm250f_clear()
        END IF

    CATCH
        CALL FGL_WINMESSAGE("警告", "FUNCTION micm012f_d ERROR!", "stop")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
#Reload data
#-----------------------------------------------------------------------
FUNCTION micm250f_reload()

    TRY
        CALL mic_arr.clear()
        DISPLAY ARRAY mic_arr TO v_micm250f.* ATTRIBUTES(COUNT = idx)
            BEFORE DISPLAY
                EXIT DISPLAY
        END DISPLAY
        IF length(where_clause) <> 0 THEN
            CALL mic_arr.clear()
            CALL micm250f_r1()
            DISPLAY "qquerryyyyyyyyy"
        END IF
        LET where_clause = ""
    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION micm250f_reload ERROR!", "stop")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
# 清除畫面資料
#-----------------------------------------------------------------------
FUNCTION micm250f_clear()
    CALL mic_arr.clear()
    DISPLAY ARRAY mic_arr TO v_micm250f.* #ATTRIBUTES(COUNT=idx)
        BEFORE DISPLAY
            EXIT DISPLAY
    END DISPLAY
END FUNCTION

#關閉主檔dialog和window
FUNCTION terminate_micm250f()
    TERMINATE DIALOG micm250f_dialog
    CLOSE WINDOW w_micm250f
END FUNCTION

#關閉明細dialog和window
FUNCTION terminate_micm251f()
    TERMINATE DIALOG micm251f_dialog
    CLOSE WINDOW w_micm251f
END FUNCTION
