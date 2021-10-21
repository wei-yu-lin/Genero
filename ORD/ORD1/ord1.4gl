GLOBALS "../../sys/library/sys_globals.4gl"

SCHEMA rdbord

DEFINE
    mast_rec RECORD
        order_no LIKE ordb010m.ORDER_NO,
        order_date LIKE ordb010m.ORDER_DATE,
        ORDER_kind LIKE ordb010m.ORDER_KIND
    END RECORD,
    mast_arr DYNAMIC ARRAY OF RECORD
        order_no LIKE ordb010m.ORDER_NO,
        order_date LIKE ordb010m.ORDER_DATE,
        ORDER_kind LIKE ordb010m.ORDER_KIND
    END RECORD,
    detail_arr DYNAMIC ARRAY OF RECORD
        order_item LIKE ordb011m.ORDER_ITEM,
        product_type LIKE ordb011m.PRODUCT_TYPE,
        order_amount LIKE ordb011m.ORDER_AMOUNT,
        order_status LIKE ordb011m.ORDER_STATUS,
        del_rec VARCHAR(1),
        upd_flag BOOLEAN
    END RECORD,
    midx, idx SMALLINT,
    curr_pa SMALLINT,
    where_clause STRING,
    max_cnt SMALLINT,
    m_add_ok, d_add_ok SMALLINT,
    m_alter_ok, d_alter_ok, d_del_ok SMALLINT

#===============================================================================
#主程式
#==============================================================================
MAIN
    CONNECT TO "rdbord" AS "ORD"

    CLOSE WINDOW SCREEN
    OPEN WINDOW ord1 WITH FORM "ord1" ATTRIBUTE(STYLE = "mystyle")

    LET channel = "ord"
    CALL sys_contro_toolbar(channel, 2) #套入自己的tool bar
    CALL ui.Interface.loadStyles("sys_style")
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()

    MENU
        BEFORE MENU
            #將明細檔刪除欄位hidden
            CALL f.setFieldHidden("del_rec", 1)

        COMMAND "ord_query"
            LET midx = 1
            CALL ord_r()

            #前一筆
        COMMAND "ord_prev"
            CALL ord_r1(-1)

            #後一筆
        COMMAND "ord_next"
            CALL ord_r1(1)

        COMMAND "ord_add"
            CALL ord_i()

        COMMAND "bye"
            CALL ord_clear()
            EXIT MENU

    END MENU
END MAIN

#--------------------------------------------------------------------
# find data
#--------------------------------------------------------------------
FUNCTION ord_r()
    DEFINE sql_txt, i, t_search_all STRING
    DEFINE mark SMALLINT

    TRY
        CLEAR FORM
        LET mark = 0
        CONSTRUCT BY NAME where_clause ON ordb010m.ORDER_NO
            ON ACTION bye
                LET mark = 1
                CALL ord_clear()
                EXIT CONSTRUCT
        END CONSTRUCT
        IF mark MATCHES 0 THEN
            IF LENGTH(where_clause) > 0 THEN
                LET where_clause = "where " || WHERE_clause

                LET sql_txt =
                    "select order_no,CAST(ORDER_DATE AS CHAR(8)),order_kind "
                            || "from ordb010m "
                            || where_clause CLIPPED
                        || " order by order_no "

                CALL sys_str_find(where_clause, "1=1") RETURNING t_search_all
                IF t_search_all = TRUE THEN
                    LET sql_txt = sql_txt || " limit to 100 rows"
                END IF
                DISPLAY "sql===", sql_txt
                PREPARE query_sql FROM sql_txt
                DECLARE mast_cur SCROLL CURSOR FOR query_sql

                LET i = 1
                WHENEVER ERROR CONTINUE
                FOREACH mast_cur INTO mast_arr[i].*
                    LET i = i + 1
                END FOREACH
                WHENEVER ERROR STOP
                LET max_cnt = i - 1
                DISPLAY "max ==", max_cnt
                CALL ord_r_display()
            END IF
        END IF
    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION ord_r ERROR!", "stop")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
#顯示主檔畫面資料
#-----------------------------------------------------------------------
FUNCTION ord_r_display()
    TRY
        DISPLAY BY NAME mast_arr[midx].*
        LET mast_rec.* = mast_arr[midx].*
        CALL ord_r_detail()
    CATCH

    END TRY
END FUNCTION
#-----------------------------------------------------------------------
#查詢明細檔資料
#-----------------------------------------------------------------------
FUNCTION ord_r_detail()

    TRY
        CALL detail_arr.clear()
        DECLARE detail_curs CURSOR FOR
            SELECT order_item, product_type, order_amount, order_status, 'N'
                FROM ordb011m
                WHERE order_no = mast_arr[midx].order_no
                ORDER BY order_item
        LET idx = 1

        WHENEVER ERROR CONTINUE
        FOREACH detail_curs INTO detail_arr[idx].*
            DISPLAY "del==", detail_arr[idx].del_rec
            LET idx = idx + 1
        END FOREACH
        WHENEVER ERROR STOP
        DISPLAY "idx===" || idx

        IF (idx > 1) THEN
            CALL detail_arr.deleteElement(idx)
        END IF

        LET idx = idx - 1
        DIALOG
            DISPLAY ARRAY detail_arr TO v_ordb011m.* ATTRIBUTES(COUNT = idx)
            END DISPLAY

            COMMAND "ord_query"
                LET midx = 1
                CALL ord_r()

                #前一筆
            COMMAND "ord_prev"
                CALL ord_r1(-1)

                #後一筆
            COMMAND "ord_next"
                CALL ord_r1(1)

            COMMAND "ord_add"
                CALL ord_i()

            COMMAND "ord_upd"
                #將明細檔刪除欄位恢復顯示
                CALL f.setFieldHidden("del_rec", 0)
                CALL ord_u()
                #將明細檔刪除欄位hidden
                CALL f.setFieldHidden("del_rec", 1)

                #刪除
            COMMAND "ord_del"
                CALL ord_d()

            COMMAND "bye"
                CALL ord_clear()
                EXIT PROGRAM

        END DIALOG

    CATCH

    END TRY

END FUNCTION
#-----------------------------------------------------------------------
#抓下筆資料
#-----------------------------------------------------------------------
FUNCTION ord_r1(p_flag)
    DEFINE p_flag, fetch_ok SMALLINT

    CLEAR FORM
    LET midx = midx + p_flag

    DISPLAY "midx===", midx
    IF midx > max_cnt THEN
        CALL FGL_WINMESSAGE("警示", "已達最後一筆", "stop")
        LET midx = midx - 1
    END IF

    IF midx = 0 THEN
        CALL FGL_WINMESSAGE("警示", "已達第一筆", "stop")
        LET midx = 1
    END IF

    DISPLAY BY NAME mast_arr[midx].*
    LET mast_rec.* = mast_arr[midx].*
    CALL ord_r_detail()

END FUNCTION
#------------------------------------------------------------------------
# 新增資料
#------------------------------------------------------------------------
FUNCTION ord_i()

    CALL mast_arr.clear()
    CALL detail_arr.clear()
    TRY
        LABEL input_rec:
        DIALOG ATTRIBUTE(UNBUFFERED)
            #-----------------------------------------
            #Master
            #-----------------------------------------
            INPUT BY NAME mast_rec.* ATTRIBUTE(WITHOUT DEFAULTS)
            END INPUT
            #-----------------------------------------
            #Detail
            #-----------------------------------------
            INPUT ARRAY detail_arr FROM v_ordb011m.* ATTRIBUTE(WITHOUT DEFAULTS)
            END INPUT

            ON ACTION ord_save
                MENU %"提示"
                    ATTRIBUTES(STYLE = "dialog",
                        COMMENT = LSTR("是否確定新增資料?"))
                    COMMAND %"確定"
                        CALL ord_i_master()
                        CALL ord_i_detail()
                        IF m_add_ok = TRUE AND d_add_ok THEN
                            CALL FGL_WINMESSAGE(
                                "提示", "資料已新增完畢!!", "information")
                            CALL ord_clear()
                        ELSE
                            CALL FGL_WINMESSAGE(
                                "提示", "資料新增失敗!!", "information")
                        END IF
                    COMMAND %"取消"

                        CLEAR FORM

                END MENU
                EXIT DIALOG
            ON ACTION bye
                EXIT DIALOG
        END DIALOG

    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION ord_i ERROR!", "stop")
    END TRY

END FUNCTION
#------------------------------------------------------------------------
# 主檔新增
#------------------------------------------------------------------------
FUNCTION ord_i_master()
    DEFINE
        v_date STRING,
        h base.SqlHandle

    TRY

        DISPLAY "no=", mast_rec.order_no
        DISPLAY "date=", mast_rec.order_date

        LET v_date =
            mast_rec.order_date[1, 4]
                || "-"
                || mast_rec.order_date[5, 6]
                || "-"
                || mast_rec.order_date[7, 8]
        DISPLAY v_date

        WHENEVER ERROR CONTINUE
        INSERT INTO ordb010m(
            order_no, order_date, order_kind)
            VALUES(mast_rec.order_no, v_date, mast_rec.order_kind)
        WHENEVER ERROR STOP

        DISPLAY "sqlcode=", sqlca.sqlcode
        IF SQLCA.SQLCODE = 0 THEN
            LET m_add_ok = TRUE
        ELSE
            LET m_add_ok = FALSE
            CALL FGL_WINMESSAGE("警示", SQLERRMESSAGE, "stop")
        END IF
    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION ord_i_master ERROR!", "stop")
    END TRY

END FUNCTION
#------------------------------------------------------------------------
# 明細檔新增
#------------------------------------------------------------------------
FUNCTION ord_i_detail()
    DEFINE i SMALLINT

    #顯示目前陣列共幾筆
    CALL detail_arr.getLength() RETURNING idx
    DISPLAY "idx===", idx
    LET i = 1
    WHENEVER ERROR CONTINUE
    WHILE i <= idx
        INSERT INTO ordb011m(
            order_no, order_item, product_type, order_amount, order_status)
            VALUES(mast_rec.order_no,
                detail_arr[i].order_item,
                detail_arr[i].product_type,
                detail_arr[i].order_amount,
                detail_arr[i].order_status)
        LET i = i + 1

        DISPLAY "d_sqlcode==", sqlca.sqlcode
        IF (SQLCA.SQLCODE = 0) THEN
            LET d_add_ok = TRUE
        ELSE
            LET d_add_ok = FALSE
        END IF

    END WHILE

END FUNCTION
#------------------------------------------------------------------------
# 修改
#------------------------------------------------------------------------
FUNCTION ord_u()
#用Dialog包住可讓主檔明細檔同時開啟輸入可供修改
    DIALOG ATTRIBUTES(UNBUFFERED, FIELD ORDER FORM)
        INPUT BY NAME mast_rec.* ATTRIBUTE(WITHOUT DEFAULTS)
        END INPUT

        #----------------------------------------
        #明細檔欄位輸入
        #----------------------------------------
        INPUT ARRAY detail_arr FROM v_ordb011m.*
        #鎖住欄位不可修改
        #BEFORE ROW
        #CALL DIALOG.setFieldActive("order_item", 0)
        END INPUT

        ON ACTION ord_save #按存檔時離開
            #傳回目前陣列筆數
            CALL detail_arr.getLength() RETURNING idx
            #update主檔
            CALL ord_u_master(dialog) RETURNING m_alter_ok
            #update明細檔
            CALL ord_u_detail() RETURNING d_alter_ok
            #update明細檔(刪除)
            CALL ord_d_detail() RETURNING d_del_ok
            IF m_alter_ok = TRUE AND d_alter_ok THEN
                CALL FGL_WINMESSAGE("提示", "資料已修改完畢!!", "information")
                LET mast_arr[midx].order_date = mast_rec.order_date
                LET mast_arr[midx].order_kind = mast_rec.order_kind
                #CALL ord_clear()
            ELSE
                CALL FGL_WINMESSAGE("提示", "資料修改失敗!!", "information")
            END IF
            EXIT DIALOG

        ON ACTION bye
            CALL ord_clear()
            EXIT DIALOG
    END DIALOG
END FUNCTION
#-----------------------------------------------------------------------
#update主檔
#-----------------------------------------------------------------------
FUNCTION ord_u_master(d)
    DEFINE d ui.DIALOG

    LET m_alter_ok = TRUE
    IF d.getFieldTouched("v_ordb010m.*") THEN
        WHENEVER ERROR CONTINUE
        UPDATE ordb010m
            SET order_kind = mast_rec.order_kind,
                order_date = mast_rec.order_date
            WHERE order_no = mast_rec.order_no
        WHENEVER ERROR STOP
        IF sqlca.sqlcode = 0 THEN
            LET m_alter_ok = TRUE
        ELSE
            LET m_alter_ok = FALSE
        END IF
    END IF

    RETURN m_alter_ok
END FUNCTION
#-----------------------------------------------------------------------
#update明細檔
#-----------------------------------------------------------------------
FUNCTION ord_u_detail()
    DEFINE i SMALLINT

    LET i = 1
    LET d_alter_ok = TRUE
    DISPLAY "idx===", idx
    WHENEVER ERROR CONTINUE
    WHILE i <= idx
        SELECT *
            FROM ordb011m
            WHERE order_no = mast_rec.order_no
                AND order_item = detail_arr[i].order_item
        IF (SQLCA.SQLCODE = 0) THEN
            #修改存在資料則update
            UPDATE ordb011m
                SET product_type = detail_arr[i].product_type,
                    order_amount = detail_arr[i].order_amount,
                    order_status = detail_arr[i].order_status
                WHERE order_no = mast_rec.order_no
                    AND order_item = detail_arr[i].order_item
            IF sqlca.sqlcode = 0 THEN
                LET d_alter_ok = TRUE
            ELSE
                LET d_alter_ok = FALSE
            END IF
        ELSE
            INSERT INTO ordb011m(
                order_no, order_item, product_type, order_amount, order_status)
                VALUES(mast_rec.order_no,
                    detail_arr[i].order_item,
                    detail_arr[i].product_type,
                    detail_arr[i].order_amount,
                    detail_arr[i].order_status)
            IF sqlca.sqlcode = 0 THEN
                LET d_alter_ok = TRUE
            ELSE
                LET d_alter_ok = FALSE
            END IF
        END IF

        LET i = i + 1
    END WHILE
    WHENEVER ERROR STOP

    RETURN d_alter_ok
END FUNCTION
#-----------------------------------------------------------------------
#修改明細(刪除)
#-----------------------------------------------------------------------
FUNCTION ord_d_detail()
    DEFINE i, del_ok SMALLINT

    TRY
        LET i = 1
        LET del_ok = TRUE
        WHENEVER ERROR CONTINUE
        WHILE i <= idx
            #將核取方塊中勾選者刪除
            IF detail_arr[i].del_rec = "Y" THEN
                DELETE FROM ordb011m
                    WHERE order_no = mast_rec.order_no
                        AND order_item = detail_arr[i].order_item
                IF SQLCA.SQLCODE = 0 THEN
                    LET del_ok = TRUE
                    CALL detail_arr.deleteElement(i)
                ELSE
                    LET del_ok = FALSE
                    ERROR SQLERRMESSAGE
                END IF
            END IF
            LET i = i + 1
        END WHILE
        WHENEVER ERROR STOP

    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION ord_d_detail ERROR!", "stop")
        LET del_ok = FALSE
    END TRY

    RETURN del_ok

END FUNCTION
#-----------------------------------------------------------------------
#刪除資料
#-----------------------------------------------------------------------
FUNCTION ord_d()
    DEFINE ans STRING

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
            WHENEVER ERROR CONTINUE
            DELETE FROM ordb010m WHERE order_no = mast_rec.order_no
            DELETE FROM ordb011m WHERE order_no = mast_rec.order_no
            WHENEVER ERROR STOP
            #"資料已刪除完畢!!"
            CALL FGL_WINMESSAGE("提示", "資料已刪除完畢!!", "information")
            CALL ord_clear()
        END IF

    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION ord_d ERROR!", "stop")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
#作業結束後清除畫面及record變數資料
#-----------------------------------------------------------------------
FUNCTION ord_clear()

    CALL mast_arr.clear()
    CALL detail_arr.clear()
    INITIALIZE mast_rec.* TO NULL
    DISPLAY BY NAME mast_rec.*

    LET idx = 1
    DISPLAY ARRAY detail_arr TO v_ordb011m.* ATTRIBUTES(COUNT = idx)
        BEFORE DISPLAY
            EXIT DISPLAY
    END DISPLAY

END FUNCTION
