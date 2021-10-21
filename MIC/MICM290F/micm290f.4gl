IMPORT FGL sys_toolbar
IMPORT FGL sys_public
IMPORT FGL fgldialog

GLOBALS "../../sys/sys_globals.4gl"

SCHEMA rdbmic36
DEFINE
    mic_arr DYNAMIC ARRAY OF RECORD
        product_code LIKE micm290m.PRODUCT_CODE,
        steel_grade_2_5 LIKE micm290m.STEEL_GRADE_2_5,
        sandblasting LIKE micm290m.SANDBLASTING,
        titanizing LIKE micm290m.TITANIZING,
        anti_fingerprint LIKE micm290m.ANTI_FINGERPRINT,
        wt_min LIKE micm290m.WT_MIN,
        wt_max LIKE micm290m.WT_MAX,
        thick_min LIKE micm290m.THICK_MIN,
        thick_max LIKE micm290m.THICK_MAX,
        wid_min LIKE micm290m.WID_MIN,
        wid_max LIKE micm290m.WID_MAX,
        len_min LIKE micm290m.LEN_MIN,
        len_max LIKE micm290m.LEN_MAX,
        date_last_maint LIKE micm290m.DATE_LAST_MAINT,
        del_rec VARCHAR(1),
        upd_flag BOOLEAN 
    END RECORD,
    idx, mark, curr_pa SMALLINT,
    where_clause STRING,
    t_date VARCHAR(8),
    t_time VARCHAR(6),
    t_status VARCHAR(1)
DEFINE
    current_datetime STRING,
    yyyy, mm, dd, hh, mmin, ss, ff STRING
DEFINE dt DATETIME YEAR TO FRACTION(3)

MAIN

    CONNECT TO "rdbmic36" AS "MIC"

    LET channel = "micm290f"
    CALL sys_contro_toolbar(channel, "1")
    CALL ui.Interface.loadStyles("sys_style")
    

    CALL sys_date() RETURNING t_date
    CALL sys_time() RETURNING t_time

    CLOSE WINDOW SCREEN
    OPEN WINDOW f1 WITH FORM "micm290f" ATTRIBUTES(STYLE = "mystyle")
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
    #CALL FGL_WINMESSAGE("question", "My very own fgl_winmessage","smiley")
    MENU ATTRIBUTES(STYLE = "Window.naked")
        COMMAND "micm290f_query"
            CALL f.setFieldHidden("del_rec",1)
            CALL f.setFieldStyle("product_code", "Label")
            CALL micm290f_r()

        COMMAND "micm290f_add"
            CALL f.setFieldHidden("del_rec",1)
            CALL micm290f_i()

        COMMAND "micm290f_upd"
            CALL f.setFieldHidden("del_rec",0)
            IF idx <> 0 THEN 
                CALL micm290f_u()
            ELSE 
                CALL FGL_WINMESSAGE( "提示", "請先執行查詢!!", "information")
            END IF 

        COMMAND "micm290f_del"
            IF idx <> 0 THEN #length(where_clause) <> 0 THEN
              CALL micm290f_d()
            ELSE
              # 提示_請先執行查詢!!
              CALL FGL_WINMESSAGE( "提示", "請先執行查詢!!", "information")
            END IF
        COMMAND "bye"
            EXIT MENU

    END MENU

END MAIN
#-----------------------------------------------------------------------
#查詢1
#-----------------------------------------------------------------------
FUNCTION micm290f_r()
    DEFINE
        mark SMALLINT,
        product_code STRING,
        steel_grade_2_5 STRING

    LET t_status = "R"
    LET mark = 0

    CLEAR FORM
    CALL mic_arr.clear()

    DIALOG ATTRIBUTE(UNBUFFERED)
        INPUT mic_arr[1].product_code, mic_arr[1].steel_grade_2_5
            FROM v_micm290f.product_code, v_micm290f.steel_grade_2_5
            ON KEY(ACCEPT)
                EXIT DIALOG
        END INPUT
    END DIALOG
    DISPLAY mic_arr[1].product_code, mic_arr[1].steel_grade_2_5
    LET product_code = mic_arr[1].product_code
    LET product_code = product_code.toUpperCase()
    LET steel_grade_2_5 = mic_arr[1].steel_grade_2_5
    LET steel_grade_2_5 = steel_grade_2_5.toUpperCase()

    IF LENGTH(product_code) <> 0 AND LENGTH(steel_grade_2_5) <> 0 THEN
        LET where_clause =
            "where product_code='"
                || product_code
                || "' and steel_grade_2_5='"
                || steel_grade_2_5
                || "' "
    ELSE
        IF LENGTH(product_code) <> 0 THEN
            LET where_clause = "where product_code='" || product_code || "' "
        ELSE
            LET where_clause = ""
        END IF
    END IF

    CALL micm290f_r1()

END FUNCTION
#-----------------------------------------------------------------------
# 查詢2
#-----------------------------------------------------------------------
FUNCTION micm290f_r1()
    DEFINE
        sql_txt STRING,
        i INTEGER

    IF length(where_clause) = 0 THEN
        LET sql_txt =
            "select product_code,steel_grade_2_5,sandblasting,titanizing,anti_fingerprint,"
                || " wt_min,wt_max,thick_min,thick_max,wid_min,wid_max,len_min,len_max,"
                || "date_last_maint "
                || " from micm290m "
                || " order by product_code"
    ELSE
        LET sql_txt =
            "select product_code,steel_grade_2_5,sandblasting,titanizing,anti_fingerprint,"
                || " wt_min,wt_max,thick_min,thick_max,wid_min,wid_max,len_min,len_max,"
                || "date_last_maint "
                || " from micm290m "
                || where_clause
                || " order by product_code"
    END IF

    DISPLAY sql_txt
    PREPARE query_sql FROM sql_txt
    DECLARE mic_curs SCROLL CURSOR FOR query_sql

    LET idx = 1
    WHENEVER ERROR CONTINUE
    FOREACH mic_curs INTO mic_arr[idx].*
        LET mic_arr[idx].del_rec = "N"
        LET mic_arr[idx].upd_flag = 0
        LET idx = idx + 1
    END FOREACH
    WHENEVER ERROR STOP

    IF (idx > 1) THEN
        CALL mic_arr.deleteElement(idx)
        LET idx = idx - 1
        DIALOG
            DISPLAY ARRAY mic_arr
                TO v_micm290f.*
                ATTRIBUTES(COUNT = idx,
                    DOUBLECLICK = select) #ATTRIBUTES(COUNT=idx)
                BEFORE DISPLAY
                    #set multi-range selection
                    CALL DIALOG.setSelectionMode("v_micm290f", 1)
                    EXIT DIALOG
            END DISPLAY

            COMMAND "micm290f_query"
                CALL micm290f_r()

            COMMAND "micm290f_add"
                CALL micm290f_i()

            COMMAND "bye"
                EXIT DIALOG

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
FUNCTION micm290f_i()
    DEFINE add_ok SMALLINT

    CLEAR FORM
    LET where_clause = ""
    CALL mic_arr.clear()

    LET mark = 0

    DIALOG ATTRIBUTE(UNBUFFERED)

        INPUT ARRAY mic_arr FROM v_micm290f.* #ATTRIBUTE (UNBUFFERED, COUNT=idx)

        END INPUT

        ON ACTION micm290f_save #按存檔
            EXIT DIALOG

        ON ACTION bye
            LET mark = 1
            CALL micm290f_clear()
            EXIT DIALOG

    END DIALOG

    IF mark = 0 THEN
        MENU %"提示"
            ATTRIBUTES(STYLE = "dialog", COMMENT = LSTR("是否確定新增資料?"))
            COMMAND %"確定"
                CALL mic_arr.getLength() RETURNING idx
                CALL micm290f_i_insert(idx) RETURNING add_ok
                IF add_ok = TRUE THEN
                    CALL FGL_WINMESSAGE(
                        "提示", "資料已新增完畢!!", "information")
                    #CALL micm012f_reload()
                END IF
                IF add_ok = FALSE THEN
                    CALL FGL_WINMESSAGE("警示", "新增有誤!!", "stop")
                END IF

            COMMAND %"取消"

                CLEAR FORM
                CALL micm290f_clear()

        END MENU
    END IF

END FUNCTION

#------------------------------------------------------------------------
#新增_寫入資料
#------------------------------------------------------------------------
FUNCTION micm290f_i_insert(idx)
    DEFINE
        add_ok, idx, i SMALLINT,
        titanizing, anti_fingerprint, product_code, steel_grade_2_5 STRING
    LET current_datetime = CURRENT
    CALL getdateforvms(current_datetime) RETURNING current_datetime
    DISPLAY current_datetime
    LET i = 1
    LET add_ok = FALSE
    WHENEVER ERROR CONTINUE
    WHILE i <= idx
        AND length(mic_arr[i].product_code) > 0
        AND length(mic_arr[i].steel_grade_2_5) > 0
        AND length(mic_arr[i].sandblasting) > 0
        AND length(mic_arr[i].titanizing) > 0
        AND length(mic_arr[i].anti_fingerprint) > 0
        AND length(mic_arr[i].wt_min) > 0
        AND length(mic_arr[i].wt_max) > 0
        AND length(mic_arr[i].thick_min) > 0
        AND length(mic_arr[i].thick_max) > 0
        AND length(mic_arr[i].wid_min) > 0
        AND length(mic_arr[i].wid_max) > 0
        AND length(mic_arr[i].len_min) > 0
        AND length(mic_arr[i].len_max) > 0

        LET titanizing = mic_arr[i].titanizing
        LET titanizing = titanizing.toUpperCase()
        LET anti_fingerprint = mic_arr[i].anti_fingerprint
        LET anti_fingerprint = anti_fingerprint.toUpperCase()
        LET product_code = mic_arr[i].product_code
        LET product_code = product_code.toUpperCase()
        LET steel_grade_2_5 = mic_arr[i].steel_grade_2_5
        LET steel_grade_2_5 = steel_grade_2_5.toUpperCase()

        INSERT INTO micm290m(
            product_code,
            steel_grade_2_5,
            sandblasting,
            titanizing,
            anti_fingerprint,
            wt_min,
            wt_max,
            thick_min,
            thick_max,
            wid_min,
            wid_max,
            len_min,
            len_max,
            date_last_maint,
            user_last_maint,
            prog_last_maint)
            VALUES(product_code,
                steel_grade_2_5,
                mic_arr[i].sandblasting,
                titanizing,
                anti_fingerprint,
                mic_arr[i].wt_min,
                mic_arr[i].wt_max,
                mic_arr[i].thick_min,
                mic_arr[i].thick_max,
                mic_arr[i].wid_min,
                mic_arr[i].wid_max,
                mic_arr[i].len_min,
                mic_arr[i].len_max,
                current_datetime,
                "YU65655",
                "MICM290F")

        LET i = i + 1

        IF (SQLCA.SQLCODE = 0) THEN
            LET add_ok = TRUE
        ELSE
            LET add_ok = FALSE
            ERROR SQLERRMESSAGE
            DISPLAY SQLERRMESSAGE
        END IF
    END WHILE
    WHENEVER ERROR STOP
    RETURN add_ok

    RETURN add_ok

END FUNCTION

#------------------------------------------------------------------------
# 修改資料
#------------------------------------------------------------------------
FUNCTION micm290f_u()
DEFINE alter_ok,del_ok,t_cur SMALLINT
       
    LABEL input_rec:
    LET t_status = "U"
    LET mark = 0
    #欄位輸入
    DIALOG ATTRIBUTES(UNBUFFERED)
     
        INPUT ARRAY mic_arr FROM v_micm290f.* #ATTRIBUTE (WITHOUT DEFAULTS)
            BEFORE INSERT
                CANCEL INSERT 
                
            BEFORE ROW
                #curr_pa = 當下所在列數
                LET curr_pa = ARR_CURR()
                CALL DIALOG.setFieldActive("product_code",0)
                CALL DIALOG.setFieldActive("steel_grade_2_5",0)
                #預設false
                LET mic_arr[curr_pa].upd_flag = FALSE 
                
            ON ROW CHANGE
                 LET t_cur = DIALOG.getCurrentRow("v_micm290f") 
                 LET mic_arr[t_cur].upd_flag = TRUE 
                 DISPLAY mic_arr[t_cur].upd_flag
        END INPUT

        ON ACTION micm290f_save  #按存檔
            IF DIALOG.getFieldTouched("v_micm290f.*") THEN 
                LET curr_pa = ARR_CURR()
                LET mic_arr[curr_pa].upd_flag = TRUE 
            END IF 
            EXIT DIALOG
              
        ON ACTION bye
           LET mark = 1
           CALL micm290f_clear()
           EXIT DIALOG
     
    END DIALOG
    IF mark = 0 THEN
       # "提示","是否確定修改資料?"
       MENU %"提示"  ATTRIBUTES (STYLE="dialog",COMMENT="是否確定修改資料?")
       #確定
       COMMAND "確定"         
            #傳回目前陣列筆數
            CALL mic_arr.getLength() RETURNING idx
            LET curr_pa = ARR_CURR() 
            
            
             #update明細檔
            CALL micm290f_u_update(idx) RETURNING alter_ok
            #update明細檔(刪除)
            CALL micm290f_u_del(idx) RETURNING del_ok

            CASE  alter_ok
            WHEN TRUE 
                #提示 資料已修改完畢!!
                CALL FGL_WINMESSAGE("提示", "資料已修改完畢!!", "information")
                CALL micm290f_reload()
                DISPLAY "where=" || where_clause
            WHEN FALSE 
                #警告 資料修改有誤!!
                CALL FGL_WINMESSAGE("警告","資料修改有誤", "stop")
                GOTO input_rec
            END CASE 
     
       COMMAND %"取消" 
          GOTO input_rec
      
       COMMAND %"放棄" 
          CALL micm290f_reload()     
       END MENU
  END IF
  

END FUNCTION

#----------------------------------------------------------------------- 
# 
#-----------------------------------------------------------------------  
FUNCTION micm290f_u_update(idx)
DEFINE i,idx,alter_ok SMALLINT
DEFINE s_sql STRING 

  LET i = 1
  LET alter_ok = 1
 
    WHILE i <= idx   
        #----------------------------
        #flag= TRUE -> 有修改才update
        IF mic_arr[i].upd_flag = TRUE THEN 
            #CALL fun_turn_to_uppercase(mic_arr,mic_arr_uppercase.*,i) RETURNING mic_arr_uppercase.*
            DISPLAY mic_arr[i].*
            SELECT * FROM micm290m
            WHERE product_code = mic_arr[i].product_code
            DISPLAY "i,",i,SQLCA.SQLCODE
            IF (SQLCA.SQLCODE = 0) THEN
            #修改存在資料則update
                UPDATE micm290m SET 
                   sandblasting =  mic_arr[i].sandblasting,
                   titanizing =  mic_arr[i].titanizing,
                   anti_fingerprint= mic_arr[i].anti_fingerprint,
                   wt_min = mic_arr[i].wt_min,
                   wt_max = mic_arr[i].wt_max,
                   thick_min = mic_arr[i].thick_min,
                   thick_max = mic_arr[i].thick_min,
                   wid_min = mic_arr[i].wid_min,
                   wid_max = mic_arr[i].wid_max,
                   len_min = mic_arr[i].len_min,
                   len_max = mic_arr[i].len_max,
                   date_last_maint = current_datetime
                   
                WHERE product_code = mic_arr[i].product_code
                IF SQLCA.SQLCODE = 0 THEN
                    LET alter_ok = TRUE
                ELSE
                    LET alter_ok = FALSE
                    DISPLAY SQLERRMESSAGE
                END IF
            END IF
        END IF 
        LET i = i + 1	
    END WHILE 

    RETURN alter_ok
END FUNCTION

FUNCTION micm290f_u_del(idx)
    DEFINE idx,i,del_ok SMALLINT

TRY 

 LET i = 1
 LET del_ok = TRUE
  WHENEVER ERROR CONTINUE
  WHILE i <= idx
      #將核取方塊中勾選者刪除
      IF mic_arr[i].del_rec = "Y" THEN
         DELETE FROM micm290m
         WHERE product_code = mic_arr[i].product_code 
        
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
   CALL FGL_WINMESSAGE("警示", "FUNCTION  mics290f_u_del ERROR!", "stop") 
   LET del_ok = FALSE
 END TRY
 
 RETURN del_ok
END FUNCTION 

#-----------------------------------------------------------------------    
#刪除資料
#-----------------------------------------------------------------------  
FUNCTION micm290f_d()
DEFINE sql_txt,ans STRING,
       t_search_all CHAR(1)

TRY 
    #CALL sys_str_find(where_clause,"1=1") RETURNING t_search_all
    IF length(where_clause) = 0 THEN
        CALL FGL_WINMESSAGE("警示","全選查詢不允許刪除,請輸入KEY值查詢!", "stop")
    ELSE 
         LET ans = FGL_WINBUTTON("刪除資料", "是否確定刪除?",
            "Lynx", "確定"||"|"||"取消", "question", 0)

         IF ans = "確定" THEN --"yes" THEN
              LET sql_txt = "delete from micm290m " || where_clause
              DISPLAY sql_txt
              WHENEVER ERROR CONTINUE    
                EXECUTE IMMEDIATE sql_txt
              WHENEVER ERROR STOP
               #"資料已刪除完畢!!"
               CALL FGL_WINMESSAGE("提示","資料已刪除完畢!!", "information")
               CALL micm290f_clear()
         END IF 
    END IF 

CATCH
   CALL FGL_WINMESSAGE( "警告", "FUNCTION micm290f_d ERROR!", "stop") 
END TRY 

END FUNCTION

#-----------------------------------------------------------------------
# 清除畫面資料
#-----------------------------------------------------------------------
FUNCTION micm290f_clear()
    CALL mic_arr.clear()
    DISPLAY ARRAY mic_arr TO v_micm290f.* #ATTRIBUTES(COUNT=idx)
        BEFORE DISPLAY
            EXIT DISPLAY
    END DISPLAY
END FUNCTION

#-----------------------------------------------------------------------  
#Reload data
#-----------------------------------------------------------------------  
FUNCTION micm290f_reload()
      
    TRY
        CALL mic_arr.clear()
        DISPLAY ARRAY mic_arr TO v_micm290f.* ATTRIBUTES(COUNT=idx)
            BEFORE DISPLAY
                CALL f.setFieldHidden("del_rec",1)
            EXIT DISPLAY
        END DISPLAY 
        #IF length(where_clause) <> 0 THEN
            CALL mic_arr.clear()
            CALL micm290f_r1()
            DISPLAY "qquerryyyyyyyyy"
        #END IF
        LET where_clause = ""
    CATCH
        CALL FGL_WINMESSAGE( "警示", "FUNCTION micm290f_reload ERROR!", "stop")
    END TRY
 
END FUNCTION

FUNCTION getdateforvms(current_datetime)
    DEFINE current_datetime STRING
    LET mm = current_datetime.subString(6, 7)
    LET yyyy = current_datetime.subString(1, 4)
    LET dd = current_datetime.subString(9, 10)
    LET hh = current_datetime.subString(12, 13)
    LET mmin = current_datetime.subString(15, 16)
    LET ss = current_datetime.subString(18, 19)
    LET ff = current_datetime.subString(21, 22)
    LET current_datetime = yyyy || mm || dd || hh || mmin || ss || ff
    RETURN current_datetime
END FUNCTION
