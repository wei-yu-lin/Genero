GLOBALS "../../sys/library/sys_globals.4gl"

SCHEMA rdbmic36

DEFINE
    mast_rec RECORD
        spec LIKE micm140m.spec,
        spec_desc LIKE micm140m.spec_desc
    END RECORD,
    mast_arr DYNAMIC ARRAY OF RECORD
        spec LIKE micm140m.spec,
        spec_desc LIKE micm140m.spec_desc
    END RECORD,
    detail_arr DYNAMIC ARRAY OF RECORD
        steel_grade_jis LIKE micm145m.steel_grade_jis,
        psr_no_2_6 LIKE micm145m.psr_no_2_6,
        invoice_abbr LIKE micm145m.invoice_abbr,
        del_rec VARCHAR(1),
        upd_flag BOOLEAN
    END RECORD,
    t_date VARCHAR(8),
    t_time VARCHAR(6),
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
    CONNECT TO "rdbmic36" AS "MIC"

    CLOSE WINDOW SCREEN
    OPEN WINDOW f1 WITH FORM "micm140f" ATTRIBUTES (STYLE="mystyle")

    LET channel = "micm140f"
    CALL sys_contro_toolbar(channel, 2) #套入自己的tool bar
    CALL ui.Interface.loadStyles("sys_style")
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()

    MENU
        BEFORE MENU
            #將明細檔刪除欄位hidden
            CALL f.setFieldHidden("upd_flag", 1)
            CALL f.setFieldHidden("del_rec", 1)

        COMMAND "micm140f_query"
            LET midx = 1
            CALL micm140f_r()

            #前一筆
        COMMAND "micm140f_prev"
            CALL micm140f_r1(-1)

            #後一筆
        COMMAND "micm140f_next"
            CALL micm140f_r1(1)

        COMMAND "micm140f_add"
            CALL micm140f_i()

        COMMAND "bye"
            CALL micm140f_clear()
            EXIT MENU

    END MENU
END MAIN

#--------------------------------------------------------------------
# find data
#--------------------------------------------------------------------
FUNCTION micm140f_r()
    DEFINE sql_txt, i, t_search_all STRING
    DEFINE mark SMALLINT

    TRY
        CLEAR FORM
        LET mark = 0

        CONSTRUCT BY NAME where_clause ON micm140m.spec
            ON ACTION bye
                LET mark = 1
                CALL micm140f_clear()
                EXIT CONSTRUCT
        END CONSTRUCT

        IF mark MATCHES 0 THEN
            IF LENGTH(where_clause) > 0 THEN
                LET where_clause = "where " || WHERE_clause

                LET sql_txt =
                    "select spec,spec_desc "
                            || "from micm140m "
                            || where_clause CLIPPED
                        || " order by spec "

                CALL sys_str_find(where_clause, "1=1") RETURNING t_search_all
                IF t_search_all = TRUE THEN
                    LET sql_txt = sql_txt || " limit to 100 rows"
                END IF

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
                CALL micm140f_r_display()
            END IF
        END IF
    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION micm140f_r ERROR!", "stop")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
#顯示主檔畫面資料
#-----------------------------------------------------------------------
FUNCTION micm140f_r_display()
    TRY
        DISPLAY BY NAME mast_arr[midx].*
        LET mast_rec.* = mast_arr[midx].*
        CALL micm140f_r_detail()
    CATCH

    END TRY
END FUNCTION
#-----------------------------------------------------------------------
#查詢明細檔資料
#-----------------------------------------------------------------------
FUNCTION micm140f_r_detail()

    TRY
        CALL detail_arr.clear()
        DECLARE detail_curs CURSOR FOR
            SELECT steel_grade_jis, psr_no_2_6, invoice_abbr
                FROM micm145m
                WHERE spec  = mast_arr[midx].spec
                ORDER BY spec
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
            DISPLAY ARRAY detail_arr TO v_micm145m.* ATTRIBUTES(COUNT = idx)
            END DISPLAY

            COMMAND "micm140f_query"
                LET midx = 1
                CALL micm140f_r()

                #前一筆
            COMMAND "micm140f_prev"
                CALL micm140f_r1(-1)

                #後一筆
            COMMAND "micm140f_next"
                CALL micm140f_r1(1)

            COMMAND "micm140f_add"
                CALL micm140f_i()

            COMMAND "micm140f_upd"
                 #將明細檔刪除欄位恢復顯示
                 CALL f.setFieldHidden("del_rec",0)
                 IF idx <> 0 THEN 
                   CALL micm140f_u() 
                 ELSE
                   CALL FGL_WINMESSAGE( "提示", "請先執行查詢!!", "information")
                 END IF
                 #將明細檔刪除欄位hidden 
                 CALL f.setFieldHidden("del_rec",1) 

                #刪除
            COMMAND "micm140f_del"
                #將明細檔刪除欄位恢復顯示
                CALL f.setFieldHidden("del_rec",0)
                IF length(where_clause) <> 0 THEN
                  CALL micm140f_d()
                ELSE
                  # 提示_請先執行查詢!!
                  CALL FGL_WINMESSAGE( "提示", "請先執行查詢!!", "information")
                END IF
                #將明細檔刪除欄位hidden 
                CALL f.setFieldHidden("del_rec",1) 

            COMMAND "bye"
                CALL micm140f_clear()
                EXIT PROGRAM

        END DIALOG

    CATCH

    END TRY

END FUNCTION
#-----------------------------------------------------------------------
#抓下筆資料
#-----------------------------------------------------------------------
FUNCTION micm140f_r1(p_flag)
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
    CALL micm140f_r_detail()

END FUNCTION
#------------------------------------------------------------------------
# 新增資料
#------------------------------------------------------------------------
FUNCTION micm140f_i()

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
            INPUT ARRAY detail_arr FROM v_micm145m.* ATTRIBUTE(WITHOUT DEFAULTS)
            END INPUT

            ON ACTION micm140f_save
                MENU %"提示"
                    ATTRIBUTES(STYLE = "dialog",
                        COMMENT = LSTR("是否確定新增資料?"))
                    COMMAND %"確定"
                        CALL micm140f_i_master()
                        CALL micm140f_i_detail()
                        IF m_add_ok = TRUE AND d_add_ok THEN
                            CALL FGL_WINMESSAGE(
                                "提示", "資料已新增完畢!!", "information")
                            CALL micm140f_clear()
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
        CALL FGL_WINMESSAGE("警示", "FUNCTION micm140f_i ERROR!", "stop")
    END TRY

END FUNCTION
#------------------------------------------------------------------------
# 主檔新增
#------------------------------------------------------------------------
FUNCTION micm140f_i_master()
    DEFINE
        v_date STRING,
        h base.SqlHandle

    TRY

        DISPLAY "spec=", mast_rec.spec
        DISPLAY "spec_desc=", mast_rec.spec_desc

        #LET v_date =
        #    mast_rec.order_date[1, 4]
        #        || "-"
        #        || mast_rec.order_date[5, 6]
        #        || "-"
        #        || mast_rec.order_date[7, 8]
        #DISPLAY v_date

        WHENEVER ERROR CONTINUE
        INSERT INTO micm140m(
            spec, 
            spec_desc,
            date_last_maint,
            time_last_maint)
            VALUES(
            mast_rec.spec,
            mast_rec.spec_desc, 
            t_date,
            t_time)
        WHENEVER ERROR STOP

        DISPLAY "sqlcode=", sqlca.sqlcode
        IF SQLCA.SQLCODE = 0 THEN
            LET m_add_ok = TRUE
        ELSE
            LET m_add_ok = FALSE
            CALL FGL_WINMESSAGE("警示", SQLERRMESSAGE, "stop")
        END IF
    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION micm140f_i_master ERROR!", "stop")
    END TRY

END FUNCTION
#------------------------------------------------------------------------
# 明細檔新增
#------------------------------------------------------------------------
FUNCTION micm140f_i_detail()
    DEFINE i SMALLINT

    #顯示目前陣列共幾筆
    CALL detail_arr.getLength() RETURNING idx
    DISPLAY "idx===", idx
    LET i = 1
    WHENEVER ERROR CONTINUE
    WHILE i <= idx
        INSERT INTO micm145m(
            spec,
            steel_grade_jis,
            psr_no_2_6,
            invoice_abbr, 
            date_last_maint,
            time_last_maint)
            VALUES(mast_rec.spec,
                detail_arr[i].steel_grade_jis,
                detail_arr[i].psr_no_2_6,
                detail_arr[i].invoice_abbr,
                t_date,
                t_time)
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
FUNCTION micm140f_u()
#用Dialog包住可讓主檔明細檔同時開啟輸入可供修改

    DIALOG ATTRIBUTES(UNBUFFERED, FIELD ORDER FORM)
        INPUT BY NAME mast_rec.* ATTRIBUTE(WITHOUT DEFAULTS)
        
        END INPUT
        
        #----------------------------------------
        #明細檔欄位輸入
        #----------------------------------------
        INPUT ARRAY detail_arr FROM v_micm145m.*
        #鎖住欄位不可修改
        #BEFORE ROW
        #CALL DIALOG.setFieldActive("order_item", 0)
        END INPUT

        ON ACTION micm140f_save #按存檔時離開
            #傳回目前陣列筆數
            CALL detail_arr.getLength() RETURNING idx
            #update主檔
            CALL micm140f_u_master(dialog) RETURNING m_alter_ok
            #update明細檔
            CALL micm140f_u_detail() RETURNING d_alter_ok
            #update明細檔(刪除)
            CALL micm140f_d_detail() RETURNING d_del_ok
            IF m_alter_ok = TRUE AND d_alter_ok THEN
                CALL FGL_WINMESSAGE("提示", "資料已修改完畢!!", "information")
                LET mast_arr[midx].spec = mast_rec.spec
                LET mast_arr[midx].spec_desc = mast_rec.spec_desc
                #CALL micm140f_clear()
            ELSE
                CALL FGL_WINMESSAGE("提示", "資料修改失敗!!", "information")
            END IF
            EXIT DIALOG

        ON ACTION bye
            CALL micm140f_clear()
            EXIT DIALOG
    END DIALOG
END FUNCTION
#-----------------------------------------------------------------------
#update主檔
#-----------------------------------------------------------------------
FUNCTION micm140f_u_master(d)
    DEFINE d ui.DIALOG

    LET m_alter_ok = TRUE
    IF d.getFieldTouched("m_micm140m.*") THEN
        WHENEVER ERROR CONTINUE
        UPDATE micm140m
            SET spec_desc = mast_rec.spec_desc,
                date_last_maint = t_date,
                time_last_maint = t_time
            WHERE spec = mast_rec.spec
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
FUNCTION micm140f_u_detail()
    DEFINE i SMALLINT

    LET i = 1
    LET d_alter_ok = TRUE
    DISPLAY "idx===", idx
    WHENEVER ERROR CONTINUE
    WHILE i <= idx
        SELECT *
            FROM micm145m
            WHERE spec = mast_rec.spec
                AND steel_grade_jis = detail_arr[i].steel_grade_jis
        IF (SQLCA.SQLCODE = 0) THEN
            #修改存在資料則update
            UPDATE micm145m
                SET psr_no_2_6 = detail_arr[i].psr_no_2_6,
                    invoice_abbr = detail_arr[i].invoice_abbr,
                    date_last_maint = t_date,
                    time_last_maint = t_time
                WHERE spec = mast_rec.spec
                    AND steel_grade_jis = detail_arr[i].steel_grade_jis
            IF sqlca.sqlcode = 0 THEN
                LET d_alter_ok = TRUE
            ELSE
                LET d_alter_ok = FALSE
            END IF
        ELSE
            INSERT INTO micm145m(
                spec, 
                steel_grade_jis, 
                psr_no_2_6, 
                invoice_abbr, 
                date_last_maint,
                time_last_maint)
                VALUES(mast_rec.spec,
                    detail_arr[i].steel_grade_jis,
                    detail_arr[i].psr_no_2_6,
                    detail_arr[i].invoice_abbr,
                    t_date,
                    t_time)
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
FUNCTION micm140f_d_detail()
    DEFINE i, del_ok SMALLINT

    TRY
        LET i = 1
        LET del_ok = TRUE
        WHENEVER ERROR CONTINUE
        WHILE i <= idx
            #將核取方塊中勾選者刪除

            IF detail_arr[i].del_rec = "Y" THEN
                DELETE FROM micm145m
                    WHERE spec = mast_rec.spec
                        AND steel_grade_jis = detail_arr[i].steel_grade_jis
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
        CALL FGL_WINMESSAGE("警示", "FUNCTION micm140f_d_detail ERROR!", "stop")
        LET del_ok = FALSE
    END TRY

    RETURN del_ok

END FUNCTION
#-----------------------------------------------------------------------
#刪除資料
#-----------------------------------------------------------------------
FUNCTION micm140f_d()
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
            DELETE FROM micm140m WHERE spec = mast_rec.spec
            DELETE FROM micm145m WHERE spec = mast_rec.spec
            WHENEVER ERROR STOP
            #"資料已刪除完畢!!"
            CALL FGL_WINMESSAGE("提示", "資料已刪除完畢!!", "information")
            CALL micm140f_clear()
        END IF

    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION micm140f_d ERROR!", "stop")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
#作業結束後清除畫面及record變數資料
#-----------------------------------------------------------------------
FUNCTION micm140f_clear()

    CALL mast_arr.clear()
    CALL detail_arr.clear()
    INITIALIZE mast_rec.* TO NULL
    DISPLAY BY NAME mast_rec.*

    LET idx = 1
    DISPLAY ARRAY detail_arr TO v_micm145m.* ATTRIBUTES(COUNT = idx)
        BEFORE DISPLAY
            EXIT DISPLAY
    END DISPLAY

END FUNCTION
