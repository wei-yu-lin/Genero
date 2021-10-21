GLOBALS "../../sys/library/sys_globals.4gl"

SCHEMA rdbmic36
DEFINE
    micm200f_arr DYNAMIC ARRAY OF RECORD
        grade_code LIKE micm190m.GRADE_CODE,
        density LIKE micm190m.DENSITY,
        serial_code LIKE micm190m.SERIAL_CODE,
        alloy_code LIKE micm190m.ALLOY_CODE,
        del_rec VARCHAR(1),
        upd_flag BOOLEAN
    END RECORD,
    idx, mark, curr_pa SMALLINT,
    where_clause STRING,
    t_date VARCHAR(8),
    t_time VARCHAR(6),
    t_status VARCHAR(1)

MAIN

    CONNECT TO "rdbmic36" AS "MIC"

    LET channel = "micm200f"
    CALL sys_contro_toolbar(channel, "1")
    CALL ui.Interface.loadStyles("sys_style")

    CALL sys_date() RETURNING t_date
    CALL sys_time() RETURNING t_time

    CLOSE WINDOW SCREEN
    OPEN WINDOW micm200f_f WITH FORM "micm200f" ATTRIBUTES(STYLE = "mystyle")
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
    
    MENU ATTRIBUTES(STYLE = "Window.naked")
        BEFORE MENU
            #將明細檔刪除欄位hidden
            CALL f.setFieldHidden("del_rec", 1) 
        COMMAND "micm200f_query"
            CALL f.setFieldHidden("del_rec", 1)
            #CALL f.setFieldStyle("schd_no","Label")
            CALL micm200f_r()

        COMMAND "micm200f_add"
            CALL f.setFieldHidden("del_rec", 1)
            CALL micm200f_i()

        COMMAND "micm200f_upd"
            #將明細檔刪除欄位恢復顯示
            CALL f.setFieldHidden("del_rec", 0)
            IF idx <> 0 THEN
                CALL micm200f_u()
            ELSE
                CALL FGL_WINMESSAGE("提示", "請先執行查詢!!", "information")
            END IF
            #將明細檔刪除欄位hidden
            CALL f.setFieldHidden("del_rec", 1)

        COMMAND "micm200f_del"
            IF length(where_clause) <> 0 THEN
                CALL micm200f_d()
            ELSE
                # 提示_請先執行查詢!!
                 CALL FGL_WINMESSAGE("提示", "請先執行查詢!!", "information")
            END IF

        COMMAND "bye"
            EXIT MENU

    END MENU

END MAIN
#-----------------------------------------------------------------------
#查詢1
#-----------------------------------------------------------------------
FUNCTION micm200f_r()
    DEFINE mark,cur_idx SMALLINT

    LET t_status = "R"
    LET mark = 0

    CLEAR FORM
    CALL micm200f_arr.clear()
    CONSTRUCT BY NAME where_clause ON grade_code
                
       ON ACTION bye
            LET mark = 1
            CALL micm200f_clear()
            EXIT CONSTRUCT
    END CONSTRUCT

    IF length(where_clause) > 0 THEN
        LET where_clause = "where " || WHERE_clause
    ELSE
        LET where_clause = ""
        LET mark = 1
    END IF

    CALL micm200f_r1()

END FUNCTION
#-----------------------------------------------------------------------
# 查詢2
#-----------------------------------------------------------------------
FUNCTION micm200f_r1()
    DEFINE sql_txt STRING

    IF length(where_clause) = 0 THEN
        LET sql_txt =
            "select grade_code,density, "
                || "serial_code,alloy_code "              
                || "from micm190m "
                || " order by grade_code"
    ELSE
        LET sql_txt =
            "select  grade_code,density, "             
                || "serial_code,alloy_code "             
                || "from micm190m "
                || where_clause
                || " order by grade_code"
    END IF

    DISPLAY sql_txt
    PREPARE query_sql FROM sql_txt
    DECLARE micm200f_curs SCROLL CURSOR FOR query_sql

    LET idx = 1
    WHENEVER ERROR CONTINUE
    FOREACH micm200f_curs INTO micm200f_arr[idx].*
        LET micm200f_arr[idx].del_rec = "N"
        LET micm200f_arr[idx].upd_flag = 0
        LET idx = idx + 1
    END FOREACH
    WHENEVER ERROR STOP

    IF (idx > 1) THEN
        CALL micm200f_arr.deleteElement(idx)
        LET idx = idx - 1
        DIALOG
            DISPLAY ARRAY micm200f_arr
                TO v_micm200f.*
                ATTRIBUTES(COUNT = idx,
                    DOUBLECLICK = select) #ATTRIBUTES(COUNT=idx)
                BEFORE DISPLAY
                    CALL f.setFieldHidden("del_rec", 1)
                    #set multi-range selection
                    CALL DIALOG.setSelectionMode("v_micm200f", 1)
            END DISPLAY

            COMMAND "micm200f_query"
                CALL micm200f_r()

            COMMAND "micm200f_add"
                CALL micm200f_i()

            COMMAND "micm200f_upd"
                #將明細檔刪除欄位恢復顯示
                CALL f.setFieldHidden("del_rec", 0)
                IF idx <> 0 THEN
                    CALL micm200f_u()
                ELSE
                    CALL FGL_WINMESSAGE("提示", "請先執行查詢!!", "information")
                END IF
                #將明細檔刪除欄位hidden
                CALL f.setFieldHidden("del_rec", 1)

            COMMAND "micm200f_del"
                IF length(where_clause) <> 0 THEN
                     CALL micm200f_d()
                ELSE
                    # 提示_請先執行查詢!!
                    CALL FGL_WINMESSAGE("提示", "請先執行查詢!!", "information")
                END IF

            COMMAND "bye"
                EXIT PROGRAM

        END DIALOG
    ELSE
        IF t_status = "R" THEN
            #資料不存在,請確認!!
            CALL FGL_WINMESSAGE("警示", "資料不存在,請確認!!", "stop")
        END IF
    END IF

END FUNCTION
#-----------------------------------------------------------------------
# 新增
#-----------------------------------------------------------------------
FUNCTION micm200f_i()
    DEFINE add_ok,cnt SMALLINT
    
       

    CLEAR FORM
    LET where_clause = ""
    CALL micm200f_arr.clear()

    LET mark = 0

    DIALOG ATTRIBUTE(UNBUFFERED)

        INPUT ARRAY micm200f_arr
            FROM v_micm200f.* #ATTRIBUTE (UNBUFFERED, COUNT=idx)
            BEFORE INSERT
                #鎖住欄位不可變動
                #CALL DIALOG.setFieldActive("cust_no", 0)
        END INPUT

        ON ACTION micm200f_save #按存檔
            EXIT DIALOG

        ON ACTION bye
            LET mark = 1
            CALL micm200f_clear()
            EXIT DIALOG

    END DIALOG

    IF mark = 0 THEN
        MENU %"提示"
            ATTRIBUTES(STYLE = "dialog", COMMENT = LSTR("是否確定新增資料?"))
            COMMAND %"確定"
                CALL micm200f_arr.getLength() RETURNING idx
                CALL micm200f_i_insert(idx) RETURNING add_ok
                IF add_ok = TRUE THEN
                    CALL FGL_WINMESSAGE(
                        "提示", "資料已新增完畢!!", "information")
                    CALL micm200f_reload()
                END IF
                IF add_ok = FALSE THEN
                    CALL FGL_WINMESSAGE("警示", "新增有誤!!", "stop")
                END IF

            COMMAND %"取消"
                CLEAR FORM
                CALL micm200f_clear()

        END MENU
    END IF

END FUNCTION
#------------------------------------------------------------------------
#新增_寫入資料
#------------------------------------------------------------------------
FUNCTION micm200f_i_insert(idx)
    DEFINE add_ok, idx, i SMALLINT

    LET i = 1
    LET add_ok = TRUE
    WHENEVER ERROR CONTINUE
    WHILE i <= idx AND length(micm200f_arr[i].grade_code) > 0
        
        INSERT INTO micm190m(
            grade_code,density,
            serial_code,alloy_code,
            date_last_maint,time_last_maint, 
            user_last_maint, prog_last_maint )
            VALUES(micm200f_arr[i].grade_code,
                micm200f_arr[i].density,
                micm200f_arr[i].serial_code,
                micm200f_arr[i].alloy_code,
                t_date,
                t_time,
                "YUMIC00",
                "micm200f")           

        LET i = i + 1

        IF (SQLCA.SQLCODE = 0) THEN
            LET add_ok = TRUE
        ELSE
            DISPLAY "sqlcode:",sqlca.sqlcode
            LET add_ok = FALSE
            ERROR SQLERRMESSAGE
        END IF
    END WHILE
    WHENEVER ERROR STOP
    RETURN add_ok

END FUNCTION
#-----------------------------------------------------------------------
#Reload data
#-----------------------------------------------------------------------
FUNCTION micm200f_reload()

    TRY
        CALL micm200f_arr.clear()
        DISPLAY ARRAY micm200f_arr TO v_micm200f.* ATTRIBUTES(COUNT = idx)
            BEFORE DISPLAY
                CALL f.setFieldHidden("del_rec", 1)
                EXIT DISPLAY
        END DISPLAY
        IF length(where_clause) <> 0 THEN
            CALL micm200f_arr.clear()
            CALL micm200f_r1()
            DISPLAY "qquerryyyyyyyyy"
        END IF
        LET where_clause = ""
    CATCH
        CALL FGL_WINMESSAGE("警示", "FUNCTION micm200f_reload ERROR!", "stop")
    END TRY

END FUNCTION
#------------------------------------------------------------------------
# 修改資料
#------------------------------------------------------------------------
FUNCTION micm200f_u()
    DEFINE alter_ok, del_ok, t_cur SMALLINT,
           sleeve_code VARCHAR(4)
           

    LABEL input_rec:
    LET t_status = "U"
    LET mark = 0
    #欄位輸入
    DIALOG ATTRIBUTES(UNBUFFERED)

        INPUT ARRAY micm200f_arr FROM v_micm200f.* #ATTRIBUTE (WITHOUT DEFAULTS)
            BEFORE INSERT
                CANCEL INSERT

            BEFORE ROW
                #curr_pa = 當下所在列數
                LET curr_pa = ARR_CURR()
                #鎖住欄位不可修改
                #CALL DIALOG.setFieldActive("mic_remark", 0)
                
                #預設false
                LET micm200f_arr[curr_pa].upd_flag = FALSE
 
                
            ON ROW CHANGE
                LET t_cur = DIALOG.getCurrentRow("v_micm200f")
                LET micm200f_arr[t_cur].upd_flag = TRUE
                DISPLAY micm200f_arr[t_cur].upd_flag
        END INPUT

    
        ON ACTION micm200f_save #按存檔
            IF DIALOG.getFieldTouched("v_micm200f.*") THEN
                LET curr_pa = ARR_CURR()
                LET micm200f_arr[curr_pa].upd_flag = TRUE
            END IF
            EXIT DIALOG


        ON ACTION bye
            LET mark = 1
            CALL micm200f_clear()
            EXIT DIALOG

    END DIALOG
    IF mark = 0 THEN
        # "提示","是否確定修改資料?"
        MENU %"提示" ATTRIBUTES(STYLE = "dialog", COMMENT = "是否確定修改資料?")
            #確定
            COMMAND "確定"
                #傳回目前陣列筆數
                CALL micm200f_arr.getLength() RETURNING idx
                LET curr_pa = ARR_CURR()

                #update明細檔
                CALL micm200f_u_update(idx) RETURNING alter_ok
                #update明細檔(刪除)
                CALL micm200f_u_del(idx) RETURNING del_ok

                CASE alter_ok
                    WHEN TRUE
                        #提示 資料已修改完畢!!
                        CALL FGL_WINMESSAGE(
                            "提示", "資料已修改完畢!!", "information")
                        CALL micm200f_reload()
                        DISPLAY "where=" || where_clause
                    WHEN FALSE
                        #警告 資料修改有誤!!
                        CALL FGL_WINMESSAGE("警告", "資料修改有誤", "stop")
                        GOTO input_rec
                END CASE

            COMMAND %"取消"
                GOTO input_rec

            COMMAND %"放棄"
                CALL micm200f_reload()
        END MENU
    END IF

END FUNCTION
#-----------------------------------------------------------------------
#
#-----------------------------------------------------------------------
FUNCTION micm200f_u_update(idx)
    DEFINE i, idx, alter_ok SMALLINT
    
           
    LET i = 1
    LET alter_ok = 1
    
    WHILE i <= idx
        #----------------------------
        #flag= TRUE -> 有修改才update
        IF micm200f_arr[i].upd_flag = TRUE THEN
            SELECT *
            FROM micm190m
            WHERE grade_code = micm200f_arr[i].grade_code
                                 
            IF (SQLCA.SQLCODE = 0) THEN
                #修改存在資料則update
                UPDATE micm190m
                    SET density = micm200f_arr[i].density,
                        serial_code = micm200f_arr[i].serial_code,
                        alloy_code = micm200f_arr[i].alloy_code
                    WHERE grade_code = micm200f_arr[i].grade_code
                        
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
#-----------------------------------------------------------------------
#修改明細(刪除)
#-----------------------------------------------------------------------
FUNCTION micm200f_u_del(idx)
    DEFINE idx, i, del_ok SMALLINT

    TRY
        LET i = 1
        LET del_ok = TRUE
        WHENEVER ERROR CONTINUE
        WHILE i <= idx
            #將核取方塊中勾選者刪除
            IF micm200f_arr[i].del_rec = "Y" THEN
                DELETE FROM micm190m
                WHERE grade_code = micm200f_arr[i].grade_code
                 
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
        CALL FGL_WINMESSAGE("警示", "FUNCTION  micm200f_u_del ERROR!", "stop")
        LET del_ok = FALSE
    END TRY

    RETURN del_ok
END FUNCTION
#-----------------------------------------------------------------------
#刪除資料
#-----------------------------------------------------------------------
FUNCTION micm200f_d()
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
                LET sql_txt = "delete from micm190m " || where_clause
                DISPLAY sql_txt
                WHENEVER ERROR CONTINUE
                EXECUTE IMMEDIATE sql_txt
                WHENEVER ERROR STOP
                #"資料已刪除完畢!!"
                CALL FGL_WINMESSAGE("提示", "資料已刪除完畢!!", "information")
                CALL micm200f_clear()
            END IF
        END IF

    CATCH
        CALL FGL_WINMESSAGE("警告", "FUNCTION micm200f_d ERROR!", "stop")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
# 清除畫面資料
#-----------------------------------------------------------------------
FUNCTION micm200f_clear()
    CALL micm200f_arr.clear()
    DISPLAY ARRAY micm200f_arr TO v_micm200f.* #ATTRIBUTES(COUNT=idx)
        BEFORE DISPLAY
            EXIT DISPLAY
    END DISPLAY
END FUNCTION

