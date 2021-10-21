GLOBALS "../../sys/library/sys_globals.4gl"
SCHEMA rdbmic36
DEFINE
    apy_arr DYNAMIC ARRAY OF RECORD
        ord_thick_min LIKE apym070m.ORD_THICK_MIN,
        ord_thick_max LIKE apym070m.ORD_THICK_MAX,
        ord_width_min LIKE apym070m.ORD_WIDTH_MIN,
        ord_width_max LIKE apym070m.ORD_WIDTH_MAX,
        cutting_wid_aim LIKE apym070m.CUTTING_WID_AIM,
        cutting_wid_min LIKE apym070m.CUTTING_WID_MIN,
        cutting_wid_max LIKE apym070m.CUTTING_WID_MAX,
        del_rec VARCHAR(1),
        upd_flag BOOLEAN
    END RECORD,
    idx, mark, curr_pa SMALLINT,
    where_clause STRING,
    t_date VARCHAR(8),
    t_time VARCHAR(6)

MAIN

    CONNECT TO "rdbmic36" AS "MIC"

    LET channel = "apym070f"
    CALL sys_contro_toolbar(channel, "1")
    CALL ui.Interface.loadStyles("sys_style")
    CALL fgl_getenv("g_user_id") RETURNING g_user_id
    LET g_user_id = "YU62445"

    CALL sys_date() RETURNING t_date
    CALL sys_time() RETURNING t_time

    CLOSE WINDOW SCREEN
    OPEN WINDOW f1 WITH FORM "apym070f" ATTRIBUTES(STYLE = "mystyle")
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()

    MENU ATTRIBUTES(STYLE = "Window.naked")
        BEFORE MENU
            #將明細檔刪除欄位hidden
            CALL f.setFieldHidden("del_rec", 1)
        COMMAND "apym070f_query"
            CALL f.setFieldHidden("del_rec", 1)
            CALL apym070f_r()

        COMMAND "apym070f_add"
            CALL f.setFieldHidden("del_rec", 1)
            CALL apym070f_i()

        COMMAND "bye"
            EXIT MENU
    END MENU

END MAIN
#-----------------------------------------------------------------------
#查詢1
#-----------------------------------------------------------------------
FUNCTION apym070f_r()

    DEFINE mark SMALLINT

    TRY
        CLEAR FORM
        CALL apy_arr.clear()
        CONSTRUCT BY NAME where_clause ON ord_thick_min, ord_width_max

            ON ACTION bye
                LET mark = 1
                CALL apym070f_clear()
                EXIT CONSTRUCT
        END CONSTRUCT

        IF mark <> 1 THEN
            LET where_clause = "where " || WHERE_clause
            CALL apym070f_r1()
        END IF
    CATCH
        CALL __Waring_ok("Fun", "apym070f_r")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
# 查詢2
#-----------------------------------------------------------------------
FUNCTION apym070f_r1()
    DEFINE sql_txt STRING

    LET sql_txt =
        "select ord_thick_min,ord_thick_max,ord_width_min,ord_width_max,"
            || "cutting_wid_aim,cutting_wid_min,cutting_wid_max from apym070m "
            || where_clause
            || "order by ord_thick_min,ord_width_min "

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
                TO v_apym070f.*
                ATTRIBUTES(COUNT = idx,
                    DOUBLECLICK = select) #ATTRIBUTES(COUNT=idx)
                BEFORE DISPLAY
                    CALL f.setFieldHidden("del_rec", 1)
                    #set multi-range selection
                    CALL DIALOG.setSelectionMode("v_apym070f", 1)
            END DISPLAY

            COMMAND "apym070f_query"
                CALL apym070f_r()
            COMMAND "apym070f_add"
                CALL f.setFieldHidden("del_rec", 1)
                CALL apym070f_i()
            COMMAND "apym070f_upd"
                #將明細檔刪除欄位恢復顯示
                CALL f.setFieldHidden("del_rec", 0)
                CALL apym070f_u()
                #將明細檔刪除欄位hidden
                CALL f.setFieldHidden("del_rec", 1)
            COMMAND "apym070f_del"
                CALL apym070f_d()
            COMMAND "bye"
                EXIT PROGRAM
        END DIALOG

    ELSE
        #資料不存在,請確認!!
        CALL __Waring_ok("NoData", "apym070m")
        CALL apy_arr.deleteElement(idx)
    END IF

END FUNCTION
#-----------------------------------------------------------------------
# 新增
#-----------------------------------------------------------------------
FUNCTION apym070f_i()

    CLEAR FORM
    LET where_clause = ""
    CALL apy_arr.clear()
    DIALOG ATTRIBUTE(UNBUFFERED)

        INPUT ARRAY apy_arr FROM v_apym070f.* #ATTRIBUTE (UNBUFFERED, COUNT=idx)

            AFTER FIELD ord_thick_min
                LET curr_pa = arr_curr()
                SELECT *
                    FROM apym070m
                    WHERE ord_thick_min = apy_arr[curr_pa].ord_thick_min
                        AND ord_width_min = apy_arr[curr_pa].ord_width_min

                IF SQLCA.SQLCODE = 0 THEN
                    CALL __Waring_ok("", "資料已存在,請確認!")
                    NEXT FIELD ord_thick_min
                END IF

            AFTER FIELD ord_width_min
                LET curr_pa = arr_curr()
                SELECT *
                    FROM apym070m
                    WHERE ord_thick_min = apy_arr[curr_pa].ord_thick_min
                        AND ord_width_min = apy_arr[curr_pa].ord_width_min

                IF SQLCA.SQLCODE = 0 THEN
                    CALL __Waring_ok("", "資料已存在,請確認!")
                    NEXT FIELD ord_width_min
                END IF

        END INPUT
        ON ACTION apym070f_save #按存檔
            IF __mbox_yn("apym070f_insert", "是否確定新增資料?", "stop") THEN
                CALL apym070f_i_insert()
            ELSE
                CLEAR FORM
                CALL apym070f_clear()
            END IF
            EXIT DIALOG

        ON ACTION bye
            CALL apym070f_clear()
            EXIT DIALOG

    END DIALOG
END FUNCTION
#------------------------------------------------------------------------
#新增_寫入資料
#------------------------------------------------------------------------
FUNCTION apym070f_i_insert()
    DEFINE add_ok, idx, i SMALLINT

    TRY
        LET i = 1
        LET add_ok = TRUE
        CALL apy_arr.getLength() RETURNING idx
        WHENEVER ERROR CONTINUE
        WHILE i <= idx
            AND length(apy_arr[i].ord_thick_min) > 0
            AND length(apy_arr[i].ord_width_min) > 0
            INSERT INTO apym070m(
                ord_thick_min,
                ord_thick_max,
                ord_width_min,
                ord_width_max,
                cutting_wid_aim,
                cutting_wid_min,
                cutting_wid_max,
                date_last_maint,
                time_last_maint,
                prog_last_maint,
                user_last_maint)
                VALUES(apy_arr[i].ord_thick_min,
                    apy_arr[i].ord_thick_max,
                    apy_arr[i].ord_width_min,
                    apy_arr[i].ord_width_max,
                    apy_arr[i].cutting_wid_aim,
                    apy_arr[i].cutting_wid_min,
                    apy_arr[i].cutting_wid_max,
                    t_date,
                    t_time,
                    "APYM070F",
                    g_user_id)

            LET i = i + 1
        END WHILE
        WHENEVER ERROR STOP
        IF SQLCA.SQLCODE = 0 THEN
            CALL __Waring_ok("", "資料已新增完畢!")
            CALL apym070f_clear()
        ELSE
            DISPLAY sqlca.sqlcode
            CALL __Waring_ok("", "資料新增有誤!")
            ERROR SQLERRMESSAGE
        END IF

    CATCH
        CALL __Waring_ok("Fun", " apym070f_i_insert")
    END TRY

END FUNCTION
#------------------------------------------------------------------------
# 修改資料
#------------------------------------------------------------------------
FUNCTION apym070f_u()
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
                    FROM v_apym070f.* #ATTRIBUTE (WITHOUT DEFAULTS)
                    BEFORE INSERT
                        CANCEL INSERT

                    BEFORE ROW
                        #curr_pa = 當下所在列數
                        LET curr_pa = ARR_CURR()
                        #鎖住欄位不可修改
                        CALL DIALOG.setFieldActive("ord_thick_min", 0)
                        CALL DIALOG.setFieldActive("ord_width_min", 0)
                        #預設false
                        LET apy_arr[curr_pa].upd_flag = FALSE

                    ON ROW CHANGE
                        LET t_cur = DIALOG.getCurrentRow("v_apym070f")
                        LET apy_arr[t_cur].upd_flag = TRUE
                END INPUT

                ON ACTION apym070f_save #按存檔
                    IF DIALOG.getFieldTouched("v_apym070f.*") THEN
                        LET curr_pa = ARR_CURR()
                        LET apy_arr[curr_pa].upd_flag = TRUE
                    END IF
                    IF __mbox_yn(
                        "apym070f_update", "是否確定修改資料?", "stop") THEN
                        #傳回目前陣列筆數
                        CALL apy_arr.getLength() RETURNING idx
                        #update明細檔
                        CALL apym070f_u_update(idx) RETURNING alter_ok
                        #update明細檔(刪除)
                        CALL apym070f_u_del(idx) RETURNING del_ok
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
                        CALL apym070f_reload()
                    ELSE
                        GOTO input_rec
                    END IF
                    EXIT DIALOG

                ON ACTION bye
                    CALL apym070f_clear()
                    EXIT DIALOG

            END DIALOG
        CATCH
            CALL __Waring_ok("Fun", "apym070f_u")
        END TRY
    END IF

END FUNCTION

#-----------------------------------------------------------------------
#修改寫入
#-----------------------------------------------------------------------
FUNCTION apym070f_u_update(idx)
    DEFINE i, idx, alter_ok SMALLINT
    TRY
        LET i = 1
        LET alter_ok = TRUE
        WHILE i <= idx
            #----------------------------
            #flag= TRUE -> 有修改才update
            IF apy_arr[i].upd_flag = TRUE THEN
                SELECT *
                    FROM apym070m
                    WHERE ord_thick_min = apy_arr[i].ord_thick_min
                        AND ord_width_min = apy_arr[i].ord_width_min

                IF (SQLCA.SQLCODE = 0) THEN
                    #修改存在資料則update
                    UPDATE apym070m
                        SET ord_thick_max = apy_arr[i].ord_thick_max,
                            ord_width_max = apy_arr[i].ord_width_max,
                            cutting_wid_aim = apy_arr[i].cutting_wid_aim,
                            cutting_wid_min = apy_arr[i].cutting_wid_min,
                            cutting_wid_max = apy_arr[i].cutting_wid_max,
                            date_last_maint = t_date,
                            time_last_maint = t_time,
                            prog_last_maint = "APYM070F",
                            user_last_maint = g_user_id
                        WHERE ord_thick_min = apy_arr[i].ord_thick_min
                            AND ord_width_min = apy_arr[i].ord_width_min

                    IF SQLCA.SQLCODE <> 0 THEN
                        LET alter_ok = FALSE
                        ERROR SQLERRMESSAGE
                    END IF
                END IF
            END IF
            LET i = i + 1
        END WHILE
    CATCH
        CALL __Waring_ok("Fun", "apym070f_u_update")
    END TRY

    RETURN alter_ok
END FUNCTION
#-----------------------------------------------------------------------
#修改明細(刪除)
#-----------------------------------------------------------------------
FUNCTION apym070f_u_del(idx)
    DEFINE idx, i, del_ok SMALLINT

    TRY
        LET i = 1
        LET del_ok = TRUE
        WHENEVER ERROR CONTINUE
        WHILE i <= idx
            #將核取方塊中勾選者刪除
            IF apy_arr[i].del_rec = "Y" THEN
                DELETE FROM apym070m
                    WHERE ord_thick_min = apy_arr[i].ord_thick_min
                        AND ord_width_min = apy_arr[i].ord_width_min

                IF SQLCA.SQLCODE <> 0 THEN
                    LET del_ok = FALSE
                    ERROR SQLERRMESSAGE
                END IF
            END IF
            LET i = i + 1
        END WHILE
        WHENEVER ERROR STOP

    CATCH
        CALL __Waring_ok("Fun", "apym070f_u_del")
        LET del_ok = FALSE
    END TRY
    RETURN del_ok
END FUNCTION
#-----------------------------------------------------------------------
#刪除資料
#-----------------------------------------------------------------------
FUNCTION apym070f_d()
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
                    "apym070f_delete", "是否確定刪除資料?", "stop") THEN

                    LET sql_txt = "delete from apym070m " || where_clause
                    WHENEVER ERROR CONTINUE
                    EXECUTE IMMEDIATE sql_txt
                    WHENEVER ERROR STOP
                    IF SQLCA.SQLCODE = 0 THEN
                        CALL __Waring_ok("", "資料刪除完畢!")
                        CALL apym070f_clear()
                    ELSE
                        CALL __Waring_ok("", "資料刪除有誤!")
                        ERROR SQLERRMESSAGE
                    END IF
                END IF
            END IF
        CATCH
            CALL __Waring_ok("Fun", "apym070f_d")
        END TRY

    END IF

END FUNCTION
#-----------------------------------------------------------------------
#Reload data
#-----------------------------------------------------------------------
FUNCTION apym070f_reload()

    TRY
        CALL apy_arr.clear()
        DISPLAY ARRAY apy_arr TO v_apym070f.* ATTRIBUTES(COUNT = idx)
            BEFORE DISPLAY
                CALL f.setFieldHidden("del_rec", 1)
                EXIT DISPLAY
        END DISPLAY
        IF length(where_clause) <> 0 THEN
            CALL apy_arr.clear()
            CALL apym070f_r1()
        END IF
        LET where_clause = ""
    CATCH
        CALL __Waring_ok("Fun", "apym070f_reload")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
# Clear Data
#-----------------------------------------------------------------------
FUNCTION apym070f_clear()
    CALL apy_arr.clear()
    DISPLAY ARRAY apy_arr TO v_apym070f.* #ATTRIBUTES(COUNT=idx)
        BEFORE DISPLAY
            EXIT DISPLAY
    END DISPLAY
END FUNCTION
