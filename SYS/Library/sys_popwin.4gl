GLOBALS "sys_globals.4gl"
DEFINE
    list_arr DYNAMIC ARRAY OF RECORD
        code_no CHAR(10),
        code_desc CHAR(30)
    END RECORD,
    list_rec RECORD
        code_no CHAR(10),
        code_desc CHAR(30)
    END RECORD,
    ret_code_no CHAR(10),
    ret_code_desc CHAR(30),
    idx, curr_pa SMALLINT
#------------------------------------------------------------------
#功能:顯示代碼及代碼描述
#參數:資料庫名稱,table name,code欄位,desc欄位,where條件(不含where)
#------------------------------------------------------------------
FUNCTION sys_show_list(dbname, tbname, code_no, code_desc, where_clause, fmname)
    DEFINE
        dbname VARCHAR(6),
        tbname VARCHAR(10),
        code_no VARCHAR(10),
        code_desc VARCHAR(10),
        where_clause STRING,
        sql_txt STRING,
        fmname STRING

    SET CONNECTION dbname

    LET sql_txt = "select " || code_no || "," || code_desc || " from " || tbname
    IF where_clause.trim() <> "" THEN
        LET sql_txt = sql_txt || " where " || where_clause
    END IF
    LET sql_txt = sql_txt || " order by " || code_no
    DISPLAY "sql == " || sql_txt

    PREPARE query_sql FROM sql_txt
    DECLARE list_curs CURSOR FOR query_sql

    OPEN WINDOW sys_show_list
        WITH
        FORM "sys_show_list"
        ATTRIBUTES(STYLE = 'dialog')
    CURRENT WINDOW IS sys_show_list
    LET w = ui.Window.getCurrent()
    CALL w.setText(fmname)

    LET idx = 0
    CALL list_arr.clear()
    FOREACH list_curs INTO list_rec.*
        LET idx = idx + 1
        LET list_arr[idx].* = list_rec.*
    END FOREACH
    LET ret_code_no = ""
    LET ret_code_desc = ""

    IF idx > 0 THEN
        DISPLAY ARRAY list_arr TO v_code_list.* ATTRIBUTES(COUNT = idx)
        LET curr_pa = arr_curr()
        LET ret_code_no = list_arr[curr_pa].code_no
        LET ret_code_desc = list_arr[curr_pa].code_desc
    END IF
    CLOSE WINDOW sys_show_list
    RETURN ret_code_no, ret_code_desc

END FUNCTION