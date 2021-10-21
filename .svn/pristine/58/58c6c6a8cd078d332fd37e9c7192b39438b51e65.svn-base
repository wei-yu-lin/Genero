GLOBALS "../../sys/library/sys_globals.4gl"

SCHEMA rdbwip36
DEFINE
    data_rec RECORD
        m_coil_no LIKE wipb010m.m_coil_no,
        schd_no LIKE wipb010m.schd_no,
        steel_grade LIKE wipb010m.steel_grade
    END RECORD,
    org_rec RECORD
        m_coil_no LIKE wipb010m.m_coil_no,
        schd_no LIKE wipb010m.schd_no,
        steel_grade LIKE wipb010m.steel_grade
    END RECORD,
    now_rec RECORD
        m_coil_no LIKE wipb010m.m_coil_no,
        schd_no LIKE wipb010m.schd_no,
        steel_grade LIKE wipb010m.steel_grade
    END RECORD,
    alter_code, curr_pa SMALLINT,
    where_clause STRING
MAIN

    CONNECT TO "rdbwip36" AS "WIP"

    LET channel = "view"
    CALL sys_contro_toolbar(channel, "1")
    CALL ui.Interface.loadStyles("sys_style")

    CLOSE WINDOW SCREEN
    OPEN WINDOW view_f WITH FORM "view_f" ATTRIBUTES(STYLE = "mystyle")
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
    MENU ATTRIBUTES(STYLE = "Window.naked")

        COMMAND "view_query"
            CALL view_r()

        COMMAND "view_add"
            CALL view_i()

        COMMAND "view_upd"
            CALL view_u()

        COMMAND "view_del"
            CALL view_d()

        COMMAND "bye"
            #CALL FGL_WINMESSAGE("提示", "Test}!!", "information")
            EXIT MENU
    END MENU
    #COMMIT WORK
END MAIN
#-----------------------------------------------------------------------
#查詢資料
#-----------------------------------------------------------------------
FUNCTION view_r()
    DEFINE mark, f_ext SMALLINT

    TRY
        CLEAR FORM
        INITIALIZE data_rec TO NULL

        LET mark = 0

        CONSTRUCT BY NAME where_clause ON m_coil_no, schd_no
            ON ACTION bye
                LET mark = 1

                CLEAR FORM
                INITIALIZE data_rec TO NULL
                EXIT CONSTRUCT
        END CONSTRUCT

        IF length(where_clause) > 0 THEN
            LET where_clause = "where " || WHERE_clause
        ELSE
            LET where_clause = ""
            LET mark = 1
        END IF

        IF mark MATCHES 0 THEN
            CALL view_r_query()
        END IF

    CATCH
        CALL FGL_WINMESSAGE("提示", "FUNCTION view_r ERROR!", "stop")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
#查詢主檔資料
#-----------------------------------------------------------------------
FUNCTION view_r_query()
    DEFINE
        sql_txt STRING,
        f_ext SMALLINT

    TRY
        LET sql_txt =
            "SELECT m_coil_no,schd_no,steel_grade "
                || "FROM wipb010m "
                || where_clause CLIPPED

        LET sql_txt = sql_txt || " order by m_coil_no  "
        DISPLAY "SQL===", sql_txt

        PREPARE query_sql FROM sql_txt
        DECLARE rec_mast SCROLL CURSOR FOR query_sql

        OPEN rec_mast
        FETCH rec_mast INTO data_rec.*

        IF SQLCA.SQLCODE = NOTFOUND THEN
            LET f_ext = FALSE
            CALL FGL_WINMESSAGE("提示", "資料不存在,請確認!!", "stop")
        ELSE
            LET f_ext = TRUE
            DISPLAY BY NAME data_rec.*
            LET org_rec.* = data_rec.*
        END IF

        FREE query_sql
        FREE rec_mast
        CLOSE query_sql
        CLOSE rec_mast
    CATCH
        CALL FGL_WINMESSAGE("提示", "FUNCTION view_r_query ERROR!", "stop")
        LET f_ext = FALSE
    END TRY

END FUNCTION
#------------------------------------------------------------------------
# 新增資料
#------------------------------------------------------------------------
FUNCTION view_i()

    TRY

        INITIALIZE data_rec.* TO NULL

        #欄位輸入
        CALL view_i_input()

    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION view_i ERROR!", "stop")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
#欄位輸入
#-----------------------------------------------------------------------
FUNCTION view_i_input()
    DEFINE mark, cnt, add_ok SMALLINT
    TRY
        LET mark = 0

        LABEL input_rec:
        DIALOG ATTRIBUTES(UNBUFFERED)
            INPUT data_rec.* FROM view_rec.*
            END INPUT

            ON ACTION view_save #按存檔
                EXIT DIALOG

            ON ACTION bye
                LET mark = 1
                CLEAR FORM
                CALL view_clear()
                EXIT DIALOG
        END DIALOG

        IF mark = 0 THEN
            MENU %"提示"
                ATTRIBUTES(STYLE = "dialog",
                    COMMENT = LSTR("是否確定新增資料?"))
                COMMAND %"確定"
                    CALL view_i_insert() RETURNING add_ok
                    IF add_ok = TRUE THEN
                        CALL FGL_WINMESSAGE(
                            "提示", "資料已新增完畢!!", "information")
                        LET where_clause =
                            " where m_coil_no = '"
                                || data_rec.m_coil_no
                                || "' and schd_no = '"
                                || data_rec.schd_no
                                || "' "
                        CALL view_reload()
                    END IF
                    IF add_ok = FALSE THEN
                        CALL FGL_WINMESSAGE("警示", "新增有誤!!", "stop")
                    END IF

                COMMAND %"取消"

                    CLEAR FORM
                    CALL view_clear()

            END MENU
        END IF

    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION view_i_input ERROR!", "stop")
    END TRY
END FUNCTION
#-----------------------------------------------------------------------
#新增data
#-----------------------------------------------------------------------
FUNCTION view_i_insert()
    DEFINE add_ok SMALLINT
    TRY
        WHENEVER ERROR CONTINUE
        INSERT INTO wipb010m(
            m_coil_no, schd_no, steel_grade)
            VALUES(data_rec.m_coil_no, data_rec.schd_no, data_rec.steel_grade)

        WHENEVER ERROR STOP

        IF SQLCA.SQLCODE = 0 THEN
            LET add_ok = TRUE
        ELSE
            LET add_ok = FALSE
            #ERROR SQLERRMESSAGE
        END IF

    CATCH
        CALL FGL_WINMESSAGE("警示", "view_i_insert ERROR!", "stop")
    END TRY
    RETURN add_ok
END FUNCTION
#-----------------------------------------------------------------------
#upd 資料
#-----------------------------------------------------------------------
FUNCTION view_u()
    DEFINE
        sql_txt STRING,
        mark VARCHAR(1),
        t_yn BOOLEAN

    LET mark = 0
    LABEL input_rec:

    DIALOG ATTRIBUTES(UNBUFFERED, FIELD ORDER FORM)

        INPUT BY NAME data_rec.* ATTRIBUTE(WITHOUT DEFAULTS)
            BEFORE INPUT
                #鎖住欄位不可修改
                CALL dialog.setFieldActive("m_coil_no", FALSE)
                CALL dialog.setFieldActive("schd_no", FALSE)
        END INPUT

        ON ACTION view_save #按存檔時離開
            EXIT DIALOG

        ON ACTION bye
            LET mark = 1
            EXIT DIALOG

    END DIALOG

    IF mark = 0 THEN
        # "提示","是否確定修改資料?"
        MENU %"提示" ATTRIBUTES(STYLE = "dialog", COMMENT = "是否確定修改資料?")
            #確定
            COMMAND "確定"
                #update payctrl
                CALL view_u1()

                CASE alter_code
                    WHEN 1
                        #提示 資料已修改完畢!!
                        CALL FGL_WINMESSAGE(
                            "提示", "資料已修改完畢!!", "information")
                    WHEN 2
                        #警告 資料修改有誤!!
                        CALL FGL_WINMESSAGE("警告", "資料修改有誤", "stop")
                        GOTO input_rec
                    WHEN 3
                        #警告 資料已被異動請重新查詢!!
                        CALL FGL_WINMESSAGE(
                            "警告", "資料已被異動,請重新查詢!!", "stop")
                        CALL view_clear()
                END CASE

                #取消
            COMMAND %"取消"
                GOTO input_rec
                #放棄
            COMMAND %"放棄 "
                CALL view_clear()
        END MENU
    END IF

END FUNCTION

#-----------------------------------------------------------------------
#upd 資料
#-----------------------------------------------------------------------
FUNCTION view_u1()
    DEFINE s_sql STRING

    BEGIN WORK
    LET where_clause =
        " where m_coil_no = '"
            || data_rec.m_coil_no
            || "' and schd_no = '"
            || data_rec.schd_no
            || "' "
    LET s_sql =
        " SELECT m_coil_no,schd_no,steel_grade FROM wipb010m "
            || where_clause
            || " for update " CLIPPED
    DISPLAY "upd_sql" || s_sql
    PREPARE u_sql FROM s_sql
    DECLARE cc CURSOR FOR u_sql
    OPEN cc
    FETCH cc INTO now_rec.*

    DISPLAY org_rec.*
    DISPLAY now_rec.*
    IF org_rec.* != now_rec.* THEN
        LET alter_code = 3
        ROLLBACK WORK
        CLOSE cc
    ELSE
        CLOSE cc
        UPDATE wipb010m
            SET steel_grade = data_rec.steel_grade
            WHERE m_coil_no = data_rec.m_coil_no AND schd_no = data_rec.schd_no

        IF SQLCA.SQLCODE = 0 THEN
            LET alter_code = 1
        ELSE
            LET alter_code = 2
            ERROR SQLERRMESSAGE
        END IF
        COMMIT WORK
    END IF
    #DISPLAY sqlca.sqlcode

END FUNCTION

#-----------------------------------------------------------------------
#刪除資料
#-----------------------------------------------------------------------
FUNCTION view_d()
    DEFINE
        sql_txt, ans STRING,
        t_search_all CHAR(1)

    TRY
        CALL sys_str_find(where_clause, "1=1") RETURNING t_search_all
        IF t_search_all = TRUE THEN
            CALL FGL_WINMESSAGE(
                "警示", "全選查詢不允許刪除,請輸入KEY值查詢!", "stop")
        ELSE
            LET ans =
                FGL_WINBUTTON(
                    "刪除資料",
                    "是否確定刪除?",
                    "Lynx",
                    "確定" || "|" || "取消",
                    "question",
                    0)

            IF ans = "確定" THEN --"yes" THEN
                LET sql_txt = "delete from wipb010m " || where_clause
                DISPLAY sql_txt
                WHENEVER ERROR CONTINUE
                EXECUTE IMMEDIATE sql_txt
                WHENEVER ERROR STOP
                #"資料已刪除完畢!!"
                CALL FGL_WINMESSAGE("提示", "資料已刪除完畢!!", "information")
                CALL view_clear()
            END IF
        END IF
    CATCH
        CALL FGL_WINMESSAGE("警告", "FUNCTION view_d ERROR!", "stop")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
#修改後reload data
#-----------------------------------------------------------------------
FUNCTION view_reload()

    TRY
        CALL view_r_query()
    CATCH
        CALL FGL_WINMESSAGE("警告", "FUNCTION view_reload ERROR!", "stop")
    END TRY
END FUNCTION
#-----------------------------------------------------------------------
#作業結束後清除畫面及record變數資料
#-----------------------------------------------------------------------
FUNCTION view_clear()
    INITIALIZE data_rec.* TO NULL
    DISPLAY BY NAME data_rec.*
END FUNCTION
