GLOBALS "../../sys/library/sys_globals.4gl"

SCHEMA rdbmic36

#DEFINE data_rec RECORD LIKE MICM010M.*
DEFINE data_rec RECORD
    mic_no LIKE MICM010M.MIC_NO,
    date_last_maint LIKE micm010m.DATE_LAST_MAINT
END RECORD
DEFINE data_arr DYNAMIC ARRAY OF RECORD
    mic_no LIKE MICM010M.MIC_NO,
    date_last_maint LIKE micm010m.DATE_LAST_MAINT
END RECORD
DEFINE where_clause STRING
DEFINE curr_idx, max_row SMALLINT

#--------------------------------------------------------------
#主程式
#--------------------------------------------------------------
MAIN
    LET channel = "mict010f"
    CALL sys_contro_toolbar(channel, "2")
    CALL ui.Interface.loadStyles("mic_style")

    CLOSE WINDOW SCREEN
    OPEN WINDOW mict010f WITH FORM "mict010f" ATTRIBUTES(STYLE = "mystyle")
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
    CALL w.setText("冶金規範維護作業")

    CONNECT TO "rdbmic36" AS "MIC"
    SET CONNECTION "MIC"

    MENU ATTRIBUTES(STYLE = "Window.naked")
        COMMAND "mict010f_query"
            CALL mict010f_r()
        COMMAND "mict010f_prev"
            CALL mict010f_n(-1)
        COMMAND "mict010f_next"
            CALL mict010f_n(1)
        COMMAND "mict010f_add"
            CALL mict010f_i()
        COMMAND "mict010f_upd"
            CALL mict010f_u()
        COMMAND "mict010f_del"
            CALL mict010f_d()
        COMMAND KEY(F)
            CALL mict010f_r()
        COMMAND KEY(LEFT)
            CALL mict010f_n(-1)
        COMMAND KEY(RIGHT)
            CALL mict010f_n(1)
        COMMAND KEY(U)
            CALL mict010f_u()
        COMMAND "bye"
            EXIT MENU
    END MENU

    DISCONNECT "MIC"

END MAIN

FUNCTION mict010f_r()
    TRY
        CLEAR FORM
        INITIALIZE data_rec TO NULL
        CONSTRUCT BY NAME where_clause ON mic_no
            ON ACTION bye
                CLEAR FORM
                EXIT CONSTRUCT
            BEFORE FIELD mic_no
                MESSAGE "mic_no 為查詢欄位"
            AFTER FIELD mic_no
                MESSAGE "查詢條件:" || where_clause
        END CONSTRUCT
        LET where_clause = where_clause
        CALL mict010f_r_query()
    CATCH
        CALL __Waring_ok("Fun", "mict00f_r")
    END TRY

END FUNCTION

FUNCTION mict010f_r_query()
    DEFINE idx SMALLINT

    TRY
        DECLARE rec_mast CURSOR FROM " SELECT mic_no, date_last_maint "
            || " FROM micm010m"
            || " WHERE "
            || where_clause

        LET idx = 0
        LET max_row = 1
        CALL data_arr.clear()
        WHENEVER ERROR CONTINUE
        FOREACH rec_mast INTO data_rec.*
            LET idx = idx + 1
            LET data_arr[idx].* = data_rec.*
        END FOREACH
        WHENEVER ERROR STOP

        FREE rec_mast
        CLOSE rec_mast

        IF (idx > 0) THEN
            LET curr_idx = 1
            DISPLAY BY NAME data_arr[curr_idx].*
            LET max_row = data_arr.getLength()
        ELSE
            CALL __Waring_ok("NoData", "micm010m")
        END IF

    CATCH
        CALL __Waring_ok("Fun", "mict010f_r_query")
    END TRY

END FUNCTION

FUNCTION mict010f_n(idx)
    DEFINE idx SMALLINT

    DISPLAY curr_idx
    IF curr_idx = 0 THEN
        MESSAGE "無資料"
    ELSE
        LET curr_idx = curr_idx + idx
        MESSAGE ""
        IF curr_idx = 0 THEN
            LET curr_idx = 1
            MESSAGE "已經第一筆了"
        ELSE
            IF curr_idx = max_row + 1 THEN
                LET curr_idx = max_row
                MESSAGE "已經最後一筆了"
            END IF
        END IF
        DISPLAY BY NAME data_arr[curr_idx].*
    END IF
END FUNCTION

FUNCTION mict010f_u()

    IF curr_idx == 0 THEN
        MESSAGE ("無資料可修改,請查詢後再修改")
    ELSE
        LABEL input_rec:
        DIALOG ATTRIBUTES(UNBUFFERED, FIELD ORDER FORM)
            INPUT BY NAME data_arr[curr_idx].* ATTRIBUTE(WITHOUT DEFAULTS)
                BEFORE INPUT
                    #鎖住欄位不可修改
                    CALL dialog.setFieldActive("mic_no", FALSE)
            END INPUT

            ON ACTION mict010f_save #按存檔時離開
                IF __mbox_yn(
                    "mict010f_update", "是否確定修改資料?", "stop") THEN
                    CALL mict010f_u1()
                ELSE
                    GOTO input_rec
                END IF
                EXIT DIALOG

            ON ACTION bye
                EXIT DIALOG

        END DIALOG
    END IF

END FUNCTION

FUNCTION mict010f_u1()

    WHENEVER ERROR CONTINUE
    UPDATE micm010m
        SET date_last_maint = data_arr[curr_idx].date_last_maint
        WHERE mic_no = data_arr[curr_idx].mic_no
    WHENEVER ERROR STOP

    IF SQLCA.SQLCODE = 0 THEN
        CALL __Waring_ok("", "資料已修改完畢!")
    ELSE
        CALL __Waring_ok("", "資料修改有誤!")
        ERROR SQLERRMESSAGE
    END IF

END FUNCTION

#------------------------------------------------------------------------
# 新增資料
#------------------------------------------------------------------------
FUNCTION mict010f_i()

    TRY
        CALL data_arr.clear()
        #欄位輸入
        LABEL input_rec:
        DIALOG ATTRIBUTES(UNBUFFERED)
            INPUT data_arr[1].* FROM mict010f.*
            END INPUT

            ON ACTION mict010f_save #按存檔
                IF __mbox_yn(
                    "mict010f_insert", "是否確定新增資料?", "stop") THEN
                    CALL mict010f_i_insert()
                ELSE
                    CALL mict010f_clear()
                END IF
                EXIT DIALOG

            ON ACTION bye
                CALL mict010f_clear()
                EXIT DIALOG
        END DIALOG

    CATCH
        CALL __Waring_ok("Fun", "mict010f_i")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
#新增data
#-----------------------------------------------------------------------
FUNCTION mict010f_i_insert()
    TRY
        WHENEVER ERROR CONTINUE
        INSERT INTO micm010m(
            mic_no, date_last_maint)
            VALUES(data_arr[1].mic_no, data_arr[1].date_last_maint)
        WHENEVER ERROR STOP

        IF SQLCA.SQLCODE = 0 THEN
            CALL __Waring_ok("", "資料已新增完畢!")
            LET where_clause = " mic_no = '" || data_arr[1].mic_no || "' "
            CALL mict010f_reload()
        ELSE
            CALL __Waring_ok("", "資料新增有誤!")
            ERROR SQLERRMESSAGE
        END IF
    CATCH
        CALL __Waring_ok("Fun", "mict010f_i_insert")
    END TRY
END FUNCTION

#-----------------------------------------------------------------------
#刪除資料
#-----------------------------------------------------------------------
FUNCTION mict010f_d()
    DEFINE sql_txt STRING
    IF curr_idx == 0 THEN
        MESSAGE ("請查詢後再刪除")
    ELSE
        TRY
            IF __mbox_yn("mict010f_delete", "是否確定刪除資料?", "stop") THEN
                LET sql_txt =
                    "delete from micm010m where mic_no = '"
                        || data_arr[curr_idx].mic_no
                        || "'"
                DISPLAY sql_txt
                WHENEVER ERROR CONTINUE
                EXECUTE IMMEDIATE sql_txt
                WHENEVER ERROR STOP
                IF SQLCA.SQLCODE = 0 THEN
                    CALL __Waring_ok("", "資料刪除完畢!")
                    CALL mict010f_clear()
                ELSE
                    CALL __Waring_ok("", "資料刪除有誤!")
                    ERROR SQLERRMESSAGE
                END IF
            END IF
        CATCH
            CALL __Waring_ok("Fun", "mict010f_d")
        END TRY
    END IF
END FUNCTION

#-----------------------------------------------------------------------
#修改後reload data
#-----------------------------------------------------------------------
FUNCTION mict010f_reload()

    TRY
        CALL mict010f_r_query()
    CATCH
        CALL __Waring_ok("Fun", "mict010f_reload")
    END TRY

END FUNCTION

#-----------------------------------------------------------------------
#作業結束後清除畫面及record變數資料
#-----------------------------------------------------------------------
FUNCTION mict010f_clear()
    CALL data_arr.clear()
    CLEAR FORM
    LET curr_idx = 0
END FUNCTION
