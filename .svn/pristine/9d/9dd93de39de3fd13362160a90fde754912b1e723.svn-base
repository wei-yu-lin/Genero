IMPORT FGL sys_public
GLOBALS "../../sys/library/sys_globals.4gl"
SCHEMA rdbmic36

DEFINE
    apy_arr DYNAMIC ARRAY OF RECORD
        proc_code LIKE apym060m.PROC_CODE,
        seq_no LIKE apym060m.SEQ_NO,
        description LIKE apym060m.DESCRIPTION,
        del_rec VARCHAR(1),
        upd_flag BOOLEAN
    END RECORD,
    idx, mark, curr_pa SMALLINT,
    where_clause STRING,
    t_date VARCHAR(8),
    t_time VARCHAR(6)

MAIN

    CONNECT TO "rdbmic36" AS "MIC"

    LET channel = "apym060f"
    CALL sys_contro_toolbar(channel, "1")
    CALL ui.Interface.loadStyles("sys_style")
    CALL fgl_getenv("g_user_id") RETURNING g_user_id
    LET g_user_id = "YU62445"

    CALL sys_date() RETURNING t_date
    CALL sys_time() RETURNING t_time

    CLOSE WINDOW SCREEN
    OPEN WINDOW f1 WITH FORM "apym060f" ATTRIBUTES(STYLE = "mystyle")
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()

    MENU ATTRIBUTES(STYLE = "Window.naked")
        BEFORE MENU
            #將明細檔刪除欄位hidden
            CALL f.setFieldHidden("del_rec", 1)
        COMMAND "apym060f_query"
            CALL f.setFieldHidden("del_rec", 1)
            CALL apym060f_r()

        COMMAND "apym060f_add"
            CALL f.setFieldHidden("del_rec", 1)
            CALL apym060f_i()

        COMMAND "bye"
            EXIT MENU
    END MENU

END MAIN
#-----------------------------------------------------------------------
#查詢1
#-----------------------------------------------------------------------
FUNCTION apym060f_r()

    DEFINE mark SMALLINT

    TRY
        CLEAR FORM
        CALL apy_arr.clear()
        CONSTRUCT BY NAME where_clause ON proc_code

            ON ACTION bye
                LET mark = 1
                CALL apym060f_clear()
                EXIT CONSTRUCT
        END CONSTRUCT

        IF mark <> 1 THEN
            LET where_clause = "where " || WHERE_clause
            CALL apym060f_r1()
        END IF
    CATCH
        CALL __Waring_ok("Fun", "apym060f_r")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
# 查詢2
#-----------------------------------------------------------------------
FUNCTION apym060f_r1()
    DEFINE sql_txt STRING

    LET sql_txt =
        "select proc_code,seq_no,description from apym060m "
            || where_clause
            || "order by proc_code,seq_no "

    #DISPLAY sql_txt
    PREPARE query_sql FROM sql_txt
    DECLARE apy_curs SCROLL CURSOR FOR query_sql

    LET idx = 1
    WHENEVER ERROR CONTINUE
    FOREACH apy_curs INTO apy_arr[idx].*
        LET apy_arr[idx].del_rec = "N"
        LET apy_arr[idx].upd_flag = 0
        LET idx = idx + 1
    END FOREACH
    WHENEVER ERROR STOP

    IF (idx > 1) THEN
        CALL apy_arr.deleteElement(idx)
        LET idx = idx - 1
        DIALOG
            DISPLAY ARRAY apy_arr
                TO v_apym060f.*
                ATTRIBUTES(COUNT = idx,
                    DOUBLECLICK = select) #ATTRIBUTES(COUNT=idx)
                BEFORE DISPLAY
                    CALL f.setFieldHidden("del_rec", 1)
                    #set multi-range selection
                    CALL DIALOG.setSelectionMode("v_apym060f", 1)
            END DISPLAY

            COMMAND "apym060f_query"
                CALL apym060f_r()
            COMMAND "apym060f_add"
                CALL apym060f_i()
            COMMAND "apym060f_upd"
                #將明細檔刪除欄位恢復顯示
                CALL f.setFieldHidden("del_rec", 0)
                CALL apym060f_u()
                #將明細檔刪除欄位hidden
                CALL f.setFieldHidden("del_rec", 1)
            COMMAND "apym060f_del"
                CALL apym060f_d()
            COMMAND "bye"
                EXIT PROGRAM
        END DIALOG

    ELSE
        #資料不存在,請確認!!
        CALL __Waring_ok("NoData", "apym060m")
        CALL apy_arr.deleteElement(idx)
    END IF

END FUNCTION
#-----------------------------------------------------------------------
# 新增
#-----------------------------------------------------------------------
FUNCTION apym060f_i()
   
    CLEAR FORM
    LET where_clause = ""
    CALL apy_arr.clear()
    DIALOG ATTRIBUTE(UNBUFFERED)

        INPUT ARRAY apy_arr FROM v_apym060f.* #ATTRIBUTE (UNBUFFERED, COUNT=idx)
        END INPUT
        ON ACTION apym060f_save #按存檔
            IF __mbox_yn("apym060f_insert", "是否確定新增資料?", "stop") THEN
                CALL apym060f_i_insert()
            ELSE
                CLEAR FORM
                CALL apym060f_clear()
            END IF
            EXIT DIALOG

        ON ACTION bye
            CALL apym060f_clear()
            EXIT DIALOG

    END DIALOG
END FUNCTION
#------------------------------------------------------------------------
#新增_寫入資料
#------------------------------------------------------------------------
FUNCTION apym060f_i_insert()
    DEFINE add_ok, idx, i SMALLINT

    TRY
        LET i = 1
        LET add_ok = TRUE
        CALL apy_arr.getLength() RETURNING idx
        WHENEVER ERROR CONTINUE
        WHILE i <= idx AND length(apy_arr[i].proc_code) > 0
            INSERT INTO apym060m(
                proc_code,
                seq_no,
                description,
                date_last_maint,
                time_last_maint,
                prog_last_maint,
                user_last_maint)
                VALUES(apy_arr[i].proc_code,
                    apy_arr[i].seq_no,
                    apy_arr[i].description,
                    t_date,
                    t_time,
                    "APYM060F",
                    g_user_id)

            LET i = i + 1
        END WHILE
        WHENEVER ERROR STOP
        IF SQLCA.SQLCODE = 0 THEN
            CALL __Waring_ok("", "資料已新增完畢!")
            CALL apym060f_clear()
        ELSE
            DISPLAY sqlca.sqlcode
            CALL __Waring_ok("", "資料新增有誤!")
            ERROR SQLERRMESSAGE
        END IF

    CATCH
        CALL __Waring_ok("Fun", " apym060f_i_insert")
    END TRY

END FUNCTION
#------------------------------------------------------------------------
# 修改資料
#------------------------------------------------------------------------
FUNCTION apym060f_u()
    DEFINE alter_ok, del_ok, t_cur SMALLINT

    CALL apy_arr.getLength() RETURNING idx
    IF idx = 0 THEN
        CALL FGL_WINMESSAGE("提示", "請先執行查詢!!", "information")
    ELSE
        TRY
            LABEL input_rec:
            LET mark = 0
            #欄位輸入
            DIALOG ATTRIBUTES(UNBUFFERED)
                INPUT ARRAY apy_arr
                    FROM v_apym060f.* #ATTRIBUTE (WITHOUT DEFAULTS)
                    BEFORE INSERT
                        CANCEL INSERT

                    BEFORE ROW
                        #curr_pa = 當下所在列數
                        LET curr_pa = ARR_CURR()
                        #鎖住欄位不可修改
                        CALL DIALOG.setFieldActive("proc_code", 0)
                        #預設false
                        LET apy_arr[curr_pa].upd_flag = FALSE

                    ON ROW CHANGE
                        LET t_cur = DIALOG.getCurrentRow("v_apym060f")
                        LET apy_arr[t_cur].upd_flag = TRUE
                END INPUT

                ON ACTION apym060f_save #按存檔
                    IF DIALOG.getFieldTouched("v_apym060f.*") THEN
                        LET curr_pa = ARR_CURR()
                        LET apy_arr[curr_pa].upd_flag = TRUE
                    END IF
                    IF __mbox_yn(
                        "apym060f_update", "是否確定修改資料?", "stop") THEN
                        #傳回目前陣列筆數
                        CALL apy_arr.getLength() RETURNING idx
                        #update明細檔
                        CALL apym060f_u_update(idx) RETURNING alter_ok
                        #update明細檔(刪除)
                        CALL apym060f_u_del(idx) RETURNING del_ok
                        IF alter_ok = TRUE AND del_ok = TRUE THEN
                            CALL __Waring_ok("", "資料已修改完畢!")
                        ELSE
                            IF alter_ok = FALSE THEN
                                CALL __Waring_ok("", "資料修改有誤!")
                            ELSE
                                IF del_ok = FALSE THEN
                                    CALL __Waring_ok("", "資料刪除有誤!")
                                END IF
                            END IF
                            ERROR SQLERRMESSAGE
                        END IF
                        CALL apym060f_reload()
                    ELSE
                        GOTO input_rec
                    END IF
                    EXIT DIALOG

                ON ACTION bye
                    CALL apym060f_clear()
                    EXIT DIALOG

            END DIALOG
        CATCH
            CALL __Waring_ok("Fun", "apym060f_u")
        END TRY
    END IF

END FUNCTION
#-----------------------------------------------------------------------
#修改寫入
#-----------------------------------------------------------------------
FUNCTION apym060f_u_update(idx)
    DEFINE i, idx, alter_ok SMALLINT
    TRY
        LET i = 1
        LET alter_ok = TRUE
        WHILE i <= idx
            #----------------------------
            #flag= TRUE -> 有修改才update
            IF apy_arr[i].upd_flag = TRUE THEN
                SELECT * FROM apym060m WHERE proc_code = apy_arr[i].proc_code

                IF (SQLCA.SQLCODE = 0) THEN
                    #修改存在資料則update
                    UPDATE apym060m
                        SET seq_no = apy_arr[i].seq_no,
                            description = apy_arr[i].description,
                            date_last_maint = t_date,
                            time_last_maint = t_time,
                            prog_last_maint = "APYM060F",
                            user_last_maint = g_user_id
                        WHERE proc_code = apy_arr[i].proc_code

                    IF SQLCA.SQLCODE <> 0 THEN
                        LET alter_ok = FALSE
                        ERROR SQLERRMESSAGE
                    END IF
                END IF
            END IF
            LET i = i + 1
        END WHILE
    CATCH
        CALL __Waring_ok("Fun", "apym060f_u_update")
    END TRY

    RETURN alter_ok
END FUNCTION
#-----------------------------------------------------------------------
#修改明細(刪除)
#-----------------------------------------------------------------------
FUNCTION apym060f_u_del(idx)
    DEFINE idx, i, del_ok SMALLINT

    TRY
        LET i = 1
        LET del_ok = TRUE
        WHENEVER ERROR CONTINUE
        WHILE i <= idx
            #將核取方塊中勾選者刪除
            IF apy_arr[i].del_rec = "Y" THEN
                DELETE FROM apym060m WHERE proc_code = apy_arr[i].proc_code

                IF SQLCA.SQLCODE <> 0 THEN
                    LET del_ok = FALSE
                    ERROR SQLERRMESSAGE
                END IF
            END IF
            LET i = i + 1
        END WHILE
        WHENEVER ERROR STOP

    CATCH
        CALL __Waring_ok("Fun", "apym060f_u_del")
        LET del_ok = FALSE
    END TRY
    RETURN del_ok
END FUNCTION
#-----------------------------------------------------------------------
#刪除資料
#-----------------------------------------------------------------------
FUNCTION apym060f_d()
    DEFINE
        sql_txt STRING,
        t_search_all CHAR(1)

    CALL apy_arr.getLength() RETURNING idx
    IF idx = 0 THEN
        CALL FGL_WINMESSAGE("提示", "請先執行查詢!!", "information")
    ELSE
        TRY
            CALL sys_str_find(where_clause, "1=1") RETURNING t_search_all
            IF t_search_all = TRUE THEN
                CALL FGL_WINMESSAGE(
                    "警示", "全選查詢不允許刪除,請輸入KEY值查詢!", "stop")
            ELSE
                IF __mbox_yn(
                    "apym060f_delete", "是否確定刪除資料?", "stop") THEN

                    LET sql_txt = "delete from apym060m " || where_clause
                    WHENEVER ERROR CONTINUE
                    EXECUTE IMMEDIATE sql_txt
                    WHENEVER ERROR STOP
                    IF SQLCA.SQLCODE = 0 THEN
                        CALL __Waring_ok("", "資料刪除完畢!")
                        CALL apym060f_clear()
                    ELSE
                        CALL __Waring_ok("", "資料刪除有誤!")
                        ERROR SQLERRMESSAGE
                    END IF
                END IF
            END IF
        CATCH
            CALL __Waring_ok("Fun", "apym060f_d")
        END TRY

    END IF

END FUNCTION
#-----------------------------------------------------------------------
#Reload data
#-----------------------------------------------------------------------
FUNCTION apym060f_reload()

    TRY
        CALL apy_arr.clear()
        DISPLAY ARRAY apy_arr TO v_apym060f.* ATTRIBUTES(COUNT = idx)
            BEFORE DISPLAY
                CALL f.setFieldHidden("del_rec", 1)
                EXIT DISPLAY
        END DISPLAY
        IF length(where_clause) <> 0 THEN
            CALL apy_arr.clear()
            CALL apym060f_r1()
        END IF
        LET where_clause = ""
    CATCH
        CALL __Waring_ok("Fun", "apym060f_reload")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
# Clear Data
#-----------------------------------------------------------------------
FUNCTION apym060f_clear()
    CALL apy_arr.clear()
    DISPLAY ARRAY apy_arr TO v_apym060f.* #ATTRIBUTES(COUNT=idx)
        BEFORE DISPLAY
            EXIT DISPLAY
    END DISPLAY
END FUNCTION
