IMPORT FGL sys_toolbar
IMPORT FGL sys_public
IMPORT FGL fgldialog

GLOBALS "../../sys/sys_globals.4gl"

SCHEMA rdbpcm

DEFINE f1 ui.Form
DEFINE mywin ui.Window
DEFINE f2 ui.Form
DEFINE mywin2 ui.Window
DEFINE
    where_clause STRING,
    ci INTEGER,
    arrlen INTEGER,
    idx, mark, curr_pa, alter_code SMALLINT
DEFINE havewhere, pcmb020m_arrlen, pcmb030m_arrlen INTEGER
DEFINE data_added, pcmb020m_part BOOLEAN
DEFINE coil_no8 STRING

DEFINE mast_pcmb020m DYNAMIC ARRAY OF RECORD
    pcmb020m_coil_no LIKE pcmb020m.COIL_NO,
    pcmb020m_slab_id LIKE pcmb020m.SLAB_ID,
    pcmb020m_ic_code LIKE pcmb020m.IC_CODE,
    pcmb020m_cb_first_order_item LIKE pcmb020m.CB_FIRST_ORDER_ITEM,
    pcmb020m_date_last_maint LIKE pcmb020m.DATE_LAST_MAINT
END RECORD

DEFINE mast_pcmb020m_rec RECORD
    pcmb020m_coil_no LIKE pcmb020m.COIL_NO,
    pcmb020m_slab_id LIKE pcmb020m.SLAB_ID,
    pcmb020m_ic_code LIKE pcmb020m.IC_CODE,
    pcmb020m_cb_first_order_item LIKE pcmb020m.CB_FIRST_ORDER_ITEM,
    pcmb020m_date_last_maint LIKE pcmb020m.DATE_LAST_MAINT
END RECORD

DEFINE org_pcmb020m_rec RECORD
    pcmb020m_coil_no LIKE pcmb020m.COIL_NO,
    pcmb020m_slab_id LIKE pcmb020m.SLAB_ID,
    pcmb020m_ic_code LIKE pcmb020m.IC_CODE,
    pcmb020m_cb_first_order_item LIKE pcmb020m.CB_FIRST_ORDER_ITEM,
    pcmb020m_date_last_maint LIKE pcmb020m.DATE_LAST_MAINT
END RECORD

DEFINE now_pcmb020m_rec RECORD
    pcmb020m_coil_no LIKE pcmb020m.COIL_NO,
    pcmb020m_slab_id LIKE pcmb020m.SLAB_ID,
    pcmb020m_ic_code LIKE pcmb020m.IC_CODE,
    pcmb020m_cb_first_order_item LIKE pcmb020m.CB_FIRST_ORDER_ITEM,
    pcmb020m_date_last_maint LIKE pcmb020m.DATE_LAST_MAINT
END RECORD

DEFINE mast_pcmb030m DYNAMIC ARRAY OF RECORD
    pcmb030m_coil_no LIKE pcmb030m.COIL_NO,
    pcmb030m_schd_no LIKE pcmb030m.SCHD_NO,
    pcmb030m_station LIKE pcmb030m.STATION,
    pcmb030m_slab_id LIKE pcmb030m.SLAB_ID,
    pcmb030m_date_last_maint LIKE pcmb030m.DATE_LAST_MAINT,
    pcmb030m_heat_no LIKE pcmb030m.HEAT_NO,
    del_rec VARCHAR(1),
    upd_flag BOOLEAN
END RECORD

MAIN
    CONNECT TO "rdbpcm" AS "rdbpcm"
    OPTIONS INPUT WRAP #it can let cursor move repeatingly
    SET CONNECTION "rdbpcm"
    CALL start_pcms020f()
    #CALL start_pcms030f()
    WHILE fgl_eventloop()
        #as long as there's one dialog registered, it will return true
    END WHILE
END MAIN

#-------------------------------------
#開啟主檔視窗和主檔的dialog module
#-------------------------------------
FUNCTION start_pcms020f()
    IF ui.Window.forName("w_pcms020f") IS NULL THEN

        #INITIALIZE mast_pcmb020m TO NULL
        CLOSE WINDOW SCREEN
        OPEN WINDOW w_pcms020f WITH FORM "pcms020f"

        START DIALOG pcms020f_dialog
        LET mywin = ui.Window.getCurrent()
        CALL mywin.setText("主檔明細-主檔部分")
        LET f1 = mywin.getForm()
        CALL ui.Interface.loadStyles("sys_style")
        #LET channel = "pcms020f"
        #CALL sys_contro_toolbar(channel,"2")
        CALL f1.loadToolBar("Toolbar_pcmb020m")
    ELSE
        CURRENT WINDOW IS w_pcms020f
    END IF
END FUNCTION

#-------------------------------------
#開啟明細視窗和明細的dialog module
#-------------------------------------
FUNCTION start_pcms030f()
    IF ui.Window.forName("w_pcms030f") IS NULL THEN
        INITIALIZE mast_pcmb030m TO NULL
        OPEN WINDOW w_pcms030f WITH FORM "pcms030f"
        START DIALOG pcms030f_dialog

        LET mywin2 = ui.Window.getCurrent()
        CALL mywin2.setText("主檔明細-明細部分")
        LET f2 = mywin2.getForm()
        
        #LET channel = "pcms020f"
        #CALL sys_contro_toolbar(channel,"2")
        CALL f2.loadToolBar("Toolbar_pcmb030m")
    ELSE
        CURRENT WINDOW IS w_pcms030f
    END IF
END FUNCTION

#-------------------------------------
#主檔的dialog module
#-------------------------------------
DIALOG pcms020f_dialog()

    MENU
        BEFORE MENU
            LET data_added = FALSE
            CALL DIALOG.setActionActive("pcms020f_next", FALSE)
            CALL DIALOG.setActionActive("pcms020f_prev", FALSE)

            CALL DIALOG.setActionActive("pcms020f_del", FALSE)
            CALL DIALOG.setActionActive("pcms020f_upd", FALSE)

        ON ACTION pcms020f_query
            LET ci = 1
            CLEAR FORM

            CURRENT WINDOW IS w_pcms020f

            CALL read_pcmb020m() RETURNING havewhere

            IF havewhere = 0 THEN
                CALL DIALOG.setActionActive("pcms020f_next", FALSE)
                CALL DIALOG.setActionActive("pcms020f_prev", FALSE)

            ELSE
                CALL DIALOG.setActionActive("pcms020f_next", TRUE)
                CALL DIALOG.setActionActive("pcms020f_prev", TRUE)

            END IF

            IF (pcmb020m_arrlen - 1) < 1 THEN
                CALL DIALOG.setActionActive("pcms020f_del", FALSE)
                CALL DIALOG.setActionActive("pcms020f_upd", FALSE)
            ELSE
                CALL DIALOG.setActionActive("pcms020f_del", TRUE)
                CALL DIALOG.setActionActive("pcms020f_upd", TRUE)
            END IF

            IF ui.Window.forName("w_pcms030f") IS NULL THEN
                CALL start_pcms030f()
            END IF

            CURRENT WINDOW IS w_pcms030f
            CALL f2.setFieldHidden("del_rec", 1)
            CALL read_pcmb030m()

            IF ui.Window.forName("w_pcms030f") IS NULL THEN
                WHILE fgl_eventloop()
                    #as long as there's one dialog registered, it will return true
                END WHILE
            END IF

        ON ACTION pcms020f_next
            CURRENT WINDOW IS w_pcms020f
            CALL pcms020f_rl(1)
            IF ui.Window.forName("w_pcms030f") IS NOT NULL THEN
                CURRENT WINDOW IS w_pcms030f
                CALL f2.setFieldHidden("del_rec", 1)
                CALL read_pcmb030m()
            END IF

        ON ACTION pcms020f_prev
            CURRENT WINDOW IS w_pcms020f
            CALL pcms020f_rl(-1)
            IF ui.Window.forName("w_pcms030f") IS NOT NULL THEN
                CURRENT WINDOW IS w_pcms030f
                CALL f2.setFieldHidden("del_rec", 1)
                CALL read_pcmb030m()
            END IF

        ON ACTION pcms020f_add
            CURRENT WINDOW IS w_pcms020f
            LET pcmb020m_part = TRUE
            CALL DIALOG.setActionActive("pcms020f_del", TRUE)
            CALL DIALOG.setActionActive("pcms020f_upd", TRUE)

            CALL pcms020f_i()

            IF ui.Window.forName("w_pcms030f") IS NULL THEN
                CALL start_pcms030f()
            END IF

            CURRENT WINDOW IS w_pcms030f
            CALL f2.setFieldHidden("del_rec", 1)
            CALL pcms030f_i()

            IF ui.Window.forName("w_pcms030f") IS NULL THEN
                WHILE fgl_eventloop()
                    #as long as there's one dialog registered, it will return true
                END WHILE
            END IF
            LET data_added = TRUE

            CALL DIALOG.setActionActive("pcms020f_next", FALSE)
            CALL DIALOG.setActionActive("pcms020f_prev", FALSE)

        ON ACTION pcms020f_del
            CURRENT WINDOW IS w_pcms020f
            LET pcmb020m_part = TRUE
            CALL pcms020f_d()

            CALL DIALOG.setActionActive("pcms020f_next", FALSE)
            CALL DIALOG.setActionActive("pcms020f_prev", FALSE)
            CALL DIALOG.setActionActive("pcms020f_del", FALSE)
            CALL DIALOG.setActionActive("pcms020f_upd", FALSE)

        ON ACTION pcms020f_upd
            CURRENT WINDOW IS w_pcms020f
            CALL pcms020f_u()

        ON ACTION CLOSE
            CALL terminate_pcms020f()
            IF ui.Window.forName("w_pcms030f") IS NOT NULL THEN
                CALL terminate_pcms030f()
            END IF

        ON ACTION bye
            CALL terminate_pcms020f()
            IF ui.Window.forName("w_pcms030f") IS NOT NULL THEN
                CALL terminate_pcms030f()
            END IF
    END MENU

END DIALOG

#-------------------------------------
#明細的dialog module
#-------------------------------------
DIALOG pcms030f_dialog()
    DISPLAY ARRAY mast_pcmb030m TO r_pcmb030f.*

        ON ACTION pcms030f_add
            CURRENT WINDOW IS w_pcms030f
            CALL f2.setFieldHidden("del_rec", 1)
            LET pcmb020m_part = FALSE
            CALL pcms030f_i()

        ON ACTION pcms030f_del
            CURRENT WINDOW IS w_pcms030f
            IF pcmb030m_arrlen - 1 = 0 THEN
                CALL FGL_WINMESSAGE(
                    "提示", "沒有資料可以進行刪除，請重新查詢", "stop")
                RETURN
            END IF
            CALL f2.setFieldHidden("del_rec", 1)
            LET pcmb020m_part = FALSE
            CALL pcms020f_d()

        ON ACTION pcms030f_upd
            CURRENT WINDOW IS w_pcms030f
            IF pcmb030m_arrlen - 1 = 0 THEN
                CALL FGL_WINMESSAGE(
                    "提示", "沒有資料可以進行修改，請重新查詢", "stop")
                RETURN
            END IF
            CALL f2.setFieldHidden("del_rec", 0)
            CALL pcms030f_u()
            #CALL f2.setFieldHidden("del_rec", 1)
        ON ACTION CLOSE
            CALL terminate_pcms030f()

        ON ACTION bye
            CALL terminate_pcms030f()
    END DISPLAY
END DIALOG

#-------------------------------------
#讀取主檔pcmb020m資料
#-------------------------------------
FUNCTION read_pcmb020m()
    DEFINE
        s_sql STRING,
        x INTEGER

    LET x = 1

    #在這邊先初始化陣列，避免第一次搜尋六筆，第二次結果只要一筆時，因為前一次殘留而結果陣列的長度還是有6
    INITIALIZE mast_pcmb020m TO NULL

    CONSTRUCT BY NAME where_clause ON coil_no
        ON ACTION bye
            EXIT CONSTRUCT
    END CONSTRUCT

    LET where_clause = "where " || where_clause
    IF (where_clause.getIndexOf("1=1", 1)) > 0 THEN
        LET s_sql =
            "SELECT coil_no,SLAB_ID,IC_CODE,CB_FIRST_ORDER_ITEM,DATE_LAST_MAINT"
                || " FROM pcmb020m "
                || where_clause
                || " ORDER BY coil_no  LIMIT TO 5 ROWS"
    ELSE
        LET s_sql =
            "SELECT coil_no,SLAB_ID,IC_CODE,CB_FIRST_ORDER_ITEM,DATE_LAST_MAINT"
                || " FROM pcmb020m "
                || where_clause
                || " ORDER BY coil_no"
    END IF

    DISPLAY "11111111111111", s_sql

    LET havewhere = s_sql.getIndexOf("1=1", 1)

    PREPARE query_sql FROM s_sql
    DECLARE mast_cur1 SCROLL CURSOR FOR query_sql
    OPEN mast_cur1
    FOREACH mast_cur1 INTO mast_pcmb020m[x].*
        LET x = x + 1
    END FOREACH
    LET arrlen = mast_pcmb020m.getLength()
    LET pcmb020m_arrlen = arrlen
    IF (arrlen - 1) != 0 THEN
        CALL display_pcmb020m()

    ELSE
        CALL FGL_WINMESSAGE("提示", "no data for this coil_no", "stop")
        LET mast_pcmb020m_rec.* = mast_pcmb020m[ci].*
    END IF

    FREE query_sql
    FREE mast_cur1

    RETURN havewhere
END FUNCTION

#-------------------------------------
#讀取明細pcmb030m資料
#-------------------------------------
FUNCTION read_pcmb030m()

    DEFINE
        s_sql STRING,
        x INTEGER

    LET coil_no8 =
        mast_pcmb020m_rec.pcmb020m_coil_no #org_pcmb020m_rec.pcmb020m_coil_no
    LET coil_no8 = coil_no8.subString(1, 8)
    DISPLAY "coil_no8:", coil_no8

    INITIALIZE mast_pcmb030m TO NULL
    LET x = 1

    TRY
        LET s_sql =
            "SELECT coil_no,schd_no,station,slab_id,date_last_maint,heat_no "
                    || "FROM pcmb030m "
                    || "WHERE coil_no='"
                    || coil_no8 CLIPPED
                || "' "
                || "ORDER BY coil_no"
        DISPLAY "select pcmb030m s_sql:", s_sql
        PREPARE query_sql1 FROM s_sql
        DECLARE mast_cur2 SCROLL CURSOR FOR query_sql1
        LET x = 1

        WHENEVER ERROR CONTINUE
        FOREACH mast_cur2 INTO mast_pcmb030m[x].*
            LET mast_pcmb030m[x].del_rec = "N"
            LET mast_pcmb030m[x].upd_flag = 0
            LET x = x + 1
        END FOREACH
        WHENEVER ERROR STOP

        DISPLAY ARRAY mast_pcmb030m TO r_pcmb030f.*
            BEFORE DISPLAY
                EXIT DISPLAY
        END DISPLAY

        LET pcmb030m_arrlen = mast_pcmb030m.getLength()
    CATCH
        DISPLAY "Exception caught, SQL error: ", SQLCA.SQLCODE
    END TRY

    FREE mast_cur2
    FREE query_sql1

    RETURN
END FUNCTION

#-------------------------------------
#讀取上一筆及下一筆資料
#-------------------------------------
FUNCTION pcms020f_rl(idx)
    DEFINE idx INTEGER
    MESSAGE arrlen

    LET ci = ci + idx
    IF ci < 1 THEN
        CALL FGL_WINMESSAGE("提示", "no prev data", "stop")
        LET ci = ci + idx
        RETURN
    ELSE
        IF ci >= arrlen THEN
            CALL FGL_WINMESSAGE("提示", "no next data", "stop")
            LET ci = ci - idx
            RETURN
        END IF
    END IF

    #DISPLAY ci
    CALL display_pcmb020m()

    RETURN
END FUNCTION

FUNCTION display_pcmb020m()
    LET org_pcmb020m_rec.* = mast_pcmb020m[ci].*
    LET mast_pcmb020m_rec.* = mast_pcmb020m[ci].*
    DISPLAY mast_pcmb020m[ci].* TO r_pcmb020f.*

END FUNCTION

#------------------------------------------------------------------------
#新增_輸入主檔資料
#------------------------------------------------------------------------
FUNCTION pcms020f_i()
    LET mark = 0
    DIALOG ATTRIBUTE(UNBUFFERED)
        INPUT mast_pcmb020m_rec.*
            FROM r_pcmb020f.* #ATTRIBUTE (UNBUFFERED, COUNT=idx)
            ON KEY(ACCEPT)
                EXIT DIALOG

        END INPUT

        ON ACTION pcms020f_save #按存檔
            EXIT DIALOG

        ON ACTION bye
            LET mark = 1
            CALL pcms020f_clear()
            EXIT DIALOG

        ON ACTION CLOSE
            LET mark = 1
            CALL pcms020f_clear()
            EXIT DIALOG
    END DIALOG
END FUNCTION

#------------------------------------------------------------------------
#新增_輸入明細資料
#------------------------------------------------------------------------
FUNCTION pcms030f_i()
    DEFINE
        pcmb020m_add_ok, pcmb030m_add_ok SMALLINT,
        pcmb020m_sqlcod, x INTEGER
    INITIALIZE mast_pcmb030m TO NULL
    CURRENT WINDOW IS w_pcms030f
    CLEAR WINDOW w_pcms030f
    LET mark = 0
    LET x = 1
    LABEL re_input_pcmb030m:

    DIALOG ATTRIBUTE(UNBUFFERED)
        INPUT ARRAY mast_pcmb030m
            FROM r_pcmb030f.* #ATTRIBUTE (UNBUFFERED, COUNT=idx)
            ON KEY(ACCEPT)
                EXIT DIALOG
        END INPUT

        ON ACTION pcms030f_save #按存檔
            EXIT DIALOG

        ON ACTION bye
            LET mark = 1
            CALL pcms030f_clear()
            EXIT DIALOG

        ON ACTION CLOSE
            LET mark = 1
            CALL pcms030f_clear()
            EXIT DIALOG
    END DIALOG

    FOR x = 1 TO mast_pcmb030m.getLength()
        IF LENGTH(mast_pcmb030m[x].pcmb030m_coil_no) = 0 THEN
            CALL FGL_WINMESSAGE("提示", "鋼捲編號不能空白!!", "information")
            LET mark = 1
            GOTO re_input_pcmb030m
        END IF
        IF LENGTH(mast_pcmb030m[x].pcmb030m_schd_no) = 0 THEN
            CALL FGL_WINMESSAGE("提示", "排程編號不能空白!!", "information")
            GOTO re_input_pcmb030m
        END IF
        IF LENGTH(mast_pcmb030m[x].pcmb030m_station) = 0 THEN
            CALL FGL_WINMESSAGE("提示", "產出產線不能空白!!", "information")
            GOTO re_input_pcmb030m
        END IF
    END FOR

    #輸入完明細資料後，主檔和明細才會一起存檔
    IF mark = 0 THEN
        MENU %"提示"
            ATTRIBUTES(STYLE = "dialog", COMMENT = LSTR("是否確定新增資料?"))
            COMMAND %"確定"

                #如果單純按明細(pcmb030m)視窗上的新增的話，就不跑新增主檔的部分
                IF pcmb020m_part = TRUE THEN
                    CALL pcms020f_i_insert(
                        ) RETURNING pcmb020m_add_ok, pcmb020m_sqlcod
                END IF
                CALL mast_pcmb030m.getLength() RETURNING idx
                DISPLAY "idx:", idx
                CALL pcms030f_i_insert(idx) RETURNING pcmb030m_add_ok

                #如果單純按明細(pcmb030m)視窗上的新增的話，就不跑新增主檔的部分
                IF pcmb020m_part = TRUE THEN
                    IF pcmb020m_add_ok = TRUE THEN
                        CURRENT WINDOW IS w_pcms020f
                        CALL FGL_WINMESSAGE(
                            "提示", "主檔資料已新增完畢!!", "information")
                        #CALL pcms020f_reload()
                    END IF
                    IF pcmb020m_add_ok = FALSE THEN
                        CALL FGL_WINMESSAGE(
                            "警示", "pcmb020m新增有誤!!", "stop")
                    END IF
                END IF

                IF pcmb030m_add_ok = TRUE THEN
                    CURRENT WINDOW IS w_pcms030f
                    CALL FGL_WINMESSAGE(
                        "提示", "明細資料已新增完畢!!", "information")
                    CALL pcms030f_reload()
                END IF
                IF pcmb030m_add_ok = FALSE THEN
                    CALL FGL_WINMESSAGE("警示", "pcmb030m新增有誤!!", "stop")
                    CALL pcms030f_clear()
                END IF

            COMMAND %"取消"
                CLEAR FORM

        END MENU
    END IF
END FUNCTION

#------------------------------------------------------------------------
#新增_寫入主檔資料
#------------------------------------------------------------------------
FUNCTION pcms020f_i_insert()
    DEFINE
        add_ok SMALLINT,
        sqlcod INTEGER
    LET add_ok = TRUE
    WHENEVER ERROR CONTINUE
    INSERT INTO pcmb020m(
        coil_no, slab_id, ic_code, cb_first_order_item, date_last_maint)
        VALUES(mast_pcmb020m_rec.pcmb020m_coil_no,
            mast_pcmb020m_rec.pcmb020m_slab_id,
            mast_pcmb020m_rec.pcmb020m_ic_code,
            mast_pcmb020m_rec.pcmb020m_cb_first_order_item,
            mast_pcmb020m_rec.pcmb020m_date_last_maint)

    LET sqlcod = SQLCA.SQLCODE
    IF (SQLCA.SQLCODE = 0) THEN
        LET org_pcmb020m_rec.* = mast_pcmb020m_rec.*
        LET add_ok = TRUE
    ELSE
        LET add_ok = FALSE
        ERROR SQLERRMESSAGE
    END IF
    WHENEVER ERROR STOP

    RETURN add_ok, sqlcod
END FUNCTION

#------------------------------------------------------------------------
#新增_寫入明細資料
#------------------------------------------------------------------------
FUNCTION pcms030f_i_insert(idx)
    DEFINE
        pcmb030m_add_ok, idx, i SMALLINT,
        equal_to_coil_no8 INTEGER,
        warn_msg STRING
    LET i = 1
    LET pcmb030m_add_ok = TRUE
    WHENEVER ERROR CONTINUE
    DISPLAY "pcmb020m_coil_no:", mast_pcmb020m_rec.pcmb020m_coil_no
    LET coil_no8 = mast_pcmb020m_rec.pcmb020m_coil_no
    LET coil_no8 = coil_no8.subString(1, 8)
    DISPLAY "coil_no8", coil_no8

    WHILE i <= idx
        #檢查使用者所有輸入的重要的值是否跟主檔相符，並且只新增相符的資料
        IF mast_pcmb030m[i].pcmb030m_coil_no = coil_no8 THEN
            INSERT INTO pcmb030m(
                coil_no, SCHD_NO, STATION, SLAB_ID, DATE_LAST_MAINT, HEAT_NO)
                VALUES(mast_pcmb030m[i].pcmb030m_coil_no,
                    mast_pcmb030m[i].pcmb030m_schd_no,
                    mast_pcmb030m[i].pcmb030m_station,
                    mast_pcmb030m[i].pcmb030m_slab_id,
                    mast_pcmb030m[i].pcmb030m_date_last_maint,
                    mast_pcmb030m[i].pcmb030m_heat_no)
            LET equal_to_coil_no8=1
        ELSE
            LET warn_msg =
                "鋼捲編號",
                mast_pcmb030m[i].pcmb030m_coil_no CLIPPED,
                "有不符合主檔的資料，此筆無法新增"
            CALL FGL_WINMESSAGE("警示", warn_msg, "stop")
            LET equal_to_coil_no8=2
            
        END IF

        LET i = i + 1
        DISPLAY "SQLCA.SQLCODE",SQLCA.SQLCODE
        DISPLAY "pcmb030m_sqlcod : ", equal_to_coil_no8
        IF (SQLCA.SQLCODE = 0 AND equal_to_coil_no8 = 1) THEN
            LET pcmb030m_add_ok = TRUE
        ELSE
            LET pcmb030m_add_ok = FALSE
            ERROR SQLERRMESSAGE
        END IF
    END WHILE
    WHENEVER ERROR STOP

    RETURN pcmb030m_add_ok

END FUNCTION

#-----------------------------------------------------------------------
#刪除主檔和明細資料
#-----------------------------------------------------------------------
FUNCTION pcms020f_d()
    DEFINE sql_txt, sql_txt1, ans STRING
    TRY
        LET ans =
            FGL_WINBUTTON(
                "刪除資料",
                "是否確定刪除?",
                "Lynx",
                "確定" || "|" || "取消",
                "question",
                0)

        IF ans = "確定" THEN --"yes" THEN

            #為了沒有新增資料時，刪除的資料是和目前看的的是同一筆，所以用了這個判斷
            #新增的話，會去輸入mast_pcmb020m_rec，所以新增後刪除會和目前看到的是同一筆，沒問題
            #data_added true為有新增，false為沒有新增
            IF data_added = FALSE THEN
                LET mast_pcmb020m_rec.* = mast_pcmb020m[ci].*
            END IF
            #如果是按下pcms030f視窗的刪除toolbar就不執行刪除主檔的動作
            IF pcmb020m_part = TRUE THEN
                LET sql_txt =
                    "delete from pcmb020m where coil_no='"
                            || mast_pcmb020m_rec.pcmb020m_coil_no CLIPPED
                        || "'"
                DISPLAY "delete from pcmb020m s_sql:", sql_txt
                WHENEVER ERROR CONTINUE
                EXECUTE IMMEDIATE sql_txt
                WHENEVER ERROR STOP
                #"資料已刪除完畢!!"
                CALL FGL_WINMESSAGE(
                    "提示", "主檔資料已刪除完畢!!", "information")
                #CALL pcms020f_clear()
            END IF

            LET sql_txt1 =
                "delete from pcmb030m where coil_no='" || coil_no8 CLIPPED
                    || "'"
            DISPLAY sql_txt1
            WHENEVER ERROR CONTINUE
            EXECUTE IMMEDIATE sql_txt1
            WHENEVER ERROR STOP
            #"資料已刪除完畢!!"
            CALL FGL_WINMESSAGE("提示", "明細資料已刪除完畢!!", "information")
            CALL pcms020f_clear()
            CALL pcms030f_clear()
        END IF
    CATCH
        CALL FGL_WINMESSAGE("警告", "FUNCTION mics060f_d ERROR!", "stop")
    END TRY
END FUNCTION

#------------------------------------------------------------------------
# 修改_輸入主檔資料
#------------------------------------------------------------------------
FUNCTION pcms020f_u()
    DEFINE alter_ok, del_ok, t_cur SMALLINT

    LABEL input_rec:
    #LET t_status = "U"
    LET mark = 0
    #欄位輸入
    LET mast_pcmb020m[ci].* = mast_pcmb020m_rec.*
    DIALOG ATTRIBUTE(UNBUFFERED)
        INPUT mast_pcmb020m[ci].*
            FROM r_pcmb020f.*
            ATTRIBUTE(WITHOUT DEFAULTS = TRUE)
            BEFORE INPUT
                #鎖住欄位不可修改
                CALL dialog.setFieldActive("coil_no", FALSE)
        END INPUT

        ON ACTION pcms020f_save #按存檔時離開
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
                CALL pcms020f_u1()
                #DISPLAY "update press ok"

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
                        #CALL view_clear()
                END CASE

                #取消
            COMMAND %"取消"
                GOTO input_rec
                #放棄
            COMMAND %"放棄 "
                #CALL view_clear()
                DISPLAY "quit"
        END MENU
    END IF

END FUNCTION

#------------------------------------------------------------------------
# 修改_update主檔資料
#------------------------------------------------------------------------
FUNCTION pcms020f_u1()
    DEFINE s_sql STRING

    BEGIN WORK
    WHENEVER ERROR CONTINUE
    LET s_sql =
        "SELECT coil_no,SLAB_ID,IC_CODE,CB_FIRST_ORDER_ITEM,DATE_LAST_MAINT"
                || " FROM pcmb020m where coil_no='"
                || mast_pcmb020m[ci].pcmb020m_coil_no CLIPPED
            || "'"
    DISPLAY "select pcmb020m s_sql when update:", s_sql

    PREPARE u_sql FROM s_sql
    DISPLAY SQLCA.SQLCODE, ": ", SQLCA.SQLERRD[2], "-", SQLERRMESSAGE
    DECLARE cc CURSOR FOR u_sql
    OPEN cc
    FETCH cc INTO now_pcmb020m_rec.*

    DISPLAY "org", org_pcmb020m_rec.*
    DISPLAY "now", now_pcmb020m_rec.*

    IF org_pcmb020m_rec.* != now_pcmb020m_rec.* THEN
        LET alter_code = 3
        ROLLBACK WORK
        CLOSE cc
    ELSE
        CLOSE cc
        UPDATE pcmb020m
            SET coil_no = mast_pcmb020m[ci].pcmb020m_coil_no,
                slab_id = mast_pcmb020m[ci].pcmb020m_slab_id,
                ic_code = mast_pcmb020m[ci].pcmb020m_ic_code,
                cb_first_order_item
                    = mast_pcmb020m[ci].pcmb020m_cb_first_order_item,
                date_last_maint = mast_pcmb020m[ci].pcmb020m_date_last_maint
            WHERE coil_no = mast_pcmb020m[ci].pcmb020m_coil_no

        IF SQLCA.SQLCODE = 0 THEN
            LET alter_code = 1
        ELSE
            LET alter_code = 2
            DISPLAY SQLCA.SQLCODE, ": ", SQLCA.SQLERRD[2], "-", SQLERRMESSAGE
            #ERROR SQLERRMESSAGE
        END IF
        COMMIT WORK
    END IF
    #DISPLAY sqlca.sqlcode

END FUNCTION

#------------------------------------------------------------------------
# 修改_輸入明細資料
#------------------------------------------------------------------------
FUNCTION pcms030f_u()
    DEFINE alter_ok, del_ok, t_cur, lastidx SMALLINT

    LABEL input_rec:
    #LET t_status = "U"
    LET mark = 0
    #欄位輸入
    LET lastidx = mast_pcmb030m.getLength()
    CALL mast_pcmb030m.deleteElement(lastidx)
    DIALOG ATTRIBUTE(UNBUFFERED)
        INPUT ARRAY mast_pcmb030m FROM r_pcmb030f.*
            #ATTRIBUTE(WITHOUT DEFAULTS = TRUE)
            BEFORE INSERT
                CANCEL INSERT
            BEFORE ROW
                LET curr_pa = ARR_CURR()
                CALL dialog.setFieldActive("coil_no", FALSE)
                CALL dialog.setFieldActive("schd_no", FALSE)
                CALL dialog.setFieldActive("station", FALSE)
                #預設false
                LET mast_pcmb030m[curr_pa].upd_flag = FALSE
            ON ROW CHANGE
                LET t_cur = DIALOG.getCurrentRow("r_pcmb030f")
                DISPLAY "t_cur", t_cur
                LET mast_pcmb030m[curr_pa].upd_flag = TRUE
                DISPLAY mast_pcmb030m[curr_pa].upd_flag, ",", curr_pa
        END INPUT

        ON ACTION pcms030f_save #按存檔時離開
            IF DIALOG.getFieldTouched("r_pcmb030f.*") THEN
                LET curr_pa = ARR_CURR()
                LET mast_pcmb030m[curr_pa].upd_flag = TRUE
                DISPLAY "row upd_flag:",
                    curr_pa,
                    "::",
                    mast_pcmb030m[curr_pa].upd_flag
            ELSE
                DISPLAY "no change detected"
            END IF

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
                #傳回目前陣列筆數
                CALL mast_pcmb030m.getLength() RETURNING idx
                LET curr_pa = ARR_CURR()

                #update明細檔
                CALL pcms030f_u_update(idx) RETURNING alter_ok
                #update明細檔(刪除)
                CALL pcms030f_u_del(idx) RETURNING del_ok

                CASE alter_ok
                    WHEN TRUE
                        #提示 資料已修改完畢!!
                        CALL FGL_WINMESSAGE(
                            "提示", "資料已修改完畢!!", "information")
                        CALL pcms030f_reload()
                        DISPLAY "where=" || where_clause
                    WHEN FALSE
                        #警告 資料修改有誤!!
                        CALL FGL_WINMESSAGE("警告", "資料修改有誤", "stop")
                        GOTO input_rec
                END CASE

            COMMAND %"取消"
                GOTO input_rec

            COMMAND %"放棄"
                CALL pcms030f_reload()
        END MENU
    END IF
END FUNCTION

#------------------------------------------------------------------------
# 修改_刪除明細有被勾選刪除的資料
#------------------------------------------------------------------------
FUNCTION pcms030f_u_del(idx)
    DEFINE idx, i, del_ok SMALLINT

    TRY

        LET i = 1
        LET del_ok = TRUE
        WHENEVER ERROR CONTINUE
        WHILE i <= idx
            #將核取方塊中勾選者刪除
            IF mast_pcmb030m[i].del_rec = "Y" THEN
                DELETE FROM pcmb030m
                    WHERE coil_no = mast_pcmb030m[i].pcmb030m_coil_no
                        AND station = mast_pcmb030m[i].pcmb030m_station
                        AND schd_no = mast_pcmb030m[i].pcmb030m_schd_no

                IF SQLCA.SQLCODE = 0 THEN
                    LET del_ok = TRUE
                ELSE
                    LET del_ok = FALSE
                    ERROR SQLERRMESSAGE
                END IF
            END IF
            LET i = i + 1
        END WHILE
        WHENEVER ERROR STOP

    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION  pcmm030m_u_del ERROR!", "stop")
        LET del_ok = FALSE
    END TRY

    RETURN del_ok
END FUNCTION

#------------------------------------------------------------------------
# 修改_update明細資料
#------------------------------------------------------------------------
FUNCTION pcms030f_u_update(idx)
    DEFINE i, idx, alter_ok SMALLINT
    DEFINE s_sql STRING
    LET alter_ok = 1

    LET i = 1
    LET alter_ok = 1

    WHILE i <= idx
        #----------------------------
        #flag= TRUE -> 有修改才update
        IF mast_pcmb030m[i].upd_flag = TRUE THEN
            DISPLAY "is in the update if statement"

            SELECT COUNT(*)
                FROM pcmb030m
                WHERE coil_no = mast_pcmb030m[i].pcmb030m_coil_no

            DISPLAY "SQLCA.SQLCODE:", SQLCA.SQLCODE
            DISPLAY mast_pcmb030m[i].pcmb030m_coil_no,
                ",",
                mast_pcmb030m[i].pcmb030m_schd_no,
                ",",
                mast_pcmb030m[i].pcmb030m_station
            IF (SQLCA.SQLCODE = 0) THEN
                #修改存在資料則update
                UPDATE pcmb030m
                    SET slab_id = mast_pcmb030m[i].pcmb030m_slab_id,
                        date_last_maint
                            = mast_pcmb030m[i].pcmb030m_date_last_maint,
                        heat_no = mast_pcmb030m[i].pcmb030m_heat_no
                    WHERE coil_no = mast_pcmb030m[i].pcmb030m_coil_no
                        AND station = mast_pcmb030m[i].pcmb030m_station
                        AND schd_no = mast_pcmb030m[i].pcmb030m_schd_no

                IF SQLCA.SQLCODE = 0 THEN
                    LET alter_ok = TRUE
                ELSE
                    LET alter_ok = FALSE
                    ERROR SQLERRMESSAGE
                END IF
            END IF
        END IF
        LET i = i + 1
    END WHILE

    RETURN alter_ok
END FUNCTION


FUNCTION pcms020f_clear()
    CALL mast_pcmb020m.clear()
    CLEAR FORM
END FUNCTION


FUNCTION pcms020f_reload()
    CALL mast_pcmb020m.clear()
    DISPLAY ARRAY mast_pcmb020m TO r_pcmb020f.*
        BEFORE DISPLAY
            EXIT DISPLAY
    END DISPLAY
END FUNCTION

FUNCTION pcms030f_clear()
    CALL mast_pcmb030m.clear()
    CLEAR FORM
END FUNCTION

FUNCTION pcms030f_reload()
    CALL mast_pcmb030m.clear()
    DISPLAY ARRAY mast_pcmb030m TO r_pcmb030f.* ATTRIBUTES(COUNT = idx)
        BEFORE DISPLAY
            CALL f2.setFieldHidden("del_rec", 1)
            EXIT DISPLAY
    END DISPLAY
    CALL read_pcmb030m()

END FUNCTION

#關閉主檔dialog和window
FUNCTION terminate_pcms020f()
    TERMINATE DIALOG pcms020f_dialog
    CLOSE WINDOW w_pcms020f
END FUNCTION

#關閉明細dialog和window
FUNCTION terminate_pcms030f()
    TERMINATE DIALOG pcms030f_dialog
    CLOSE WINDOW w_pcms030f
END FUNCTION
