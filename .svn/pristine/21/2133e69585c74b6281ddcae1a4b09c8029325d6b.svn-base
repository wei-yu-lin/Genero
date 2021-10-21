GLOBALS "../../sys/library/sys_globals.4gl"

SCHEMA rdbmic36
DEFINE mic_arr  DYNAMIC ARRAY OF RECORD
    code_type LIKE micm060m.CODE_TYPE,
    code_desc VARCHAR(30),
    code LIKE micm060m.CODE,
    remark LIKE micm060m.REMARK,
    del_rec VARCHAR(1),
    upd_flag BOOLEAN 
END RECORD,
idx,mark,curr_pa SMALLINT,
where_clause STRING,
t_date VARCHAR(8),
t_time VARCHAR(6),
t_status VARCHAR(1)

MAIN

    CONNECT TO "rdbmic36" AS "MIC"

    LET channel = "mics060f"
    CALL sys_contro_toolbar(channel,"1")  
    CALL ui.Interface.loadStyles("sys_style") 

    CALL sys_date() RETURNING t_date
    CALL sys_time() RETURNING t_time

    CLOSE WINDOW SCREEN
    OPEN WINDOW f1 WITH FORM "mics060f" ATTRIBUTES (STYLE="mystyle")
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
    MENU ATTRIBUTES (STYLE="Window.naked")
        BEFORE MENU 
            #將明細檔刪除欄位hidden 
            CALL f.setFieldHidden("del_rec",1)
        COMMAND "mics060f_query" 
            CALL f.setFieldHidden("del_rec",1)
            CALL f.setFieldStyle("schd_no","Label")
            CALL mics060f_r() 

        COMMAND "mics060f_add"   
            CALL f.setFieldHidden("del_rec",1)
            CALL mics060f_i()
    
        COMMAND "mics060f_upd"  
             #將明細檔刪除欄位恢復顯示
             CALL f.setFieldHidden("del_rec",0)
             IF idx <> 0 THEN 
               CALL mics060f_u() 
             ELSE
               CALL FGL_WINMESSAGE( "提示", "請先執行查詢!!", "information")
             END IF
             #將明細檔刪除欄位hidden 
             CALL f.setFieldHidden("del_rec",1) 

        COMMAND "mics060f_del"
            IF length(where_clause) <> 0 THEN
              CALL mics060f_d()
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
FUNCTION mics060f_r()
DEFINE mark SMALLINT

    LET t_status = "R"
    LET mark = 0
 
    CLEAR FORM
    CALL mic_arr.clear()
    CONSTRUCT BY NAME where_clause ON code_type,code

    ON ACTION bye
        LET mark = 1
        CALL mics060f_clear()
        EXIT CONSTRUCT 
    END CONSTRUCT
 
 
    IF length(where_clause) > 0 THEN
        LET where_clause = "where " || WHERE_clause
    ELSE
        LET where_clause =""
        LET mark = 1     
    END IF  

    CALL mics060f_r1()

END FUNCTION
#-----------------------------------------------------------------------
# 查詢2
#-----------------------------------------------------------------------  
FUNCTION mics060f_r1()
DEFINE sql_txt STRING

    IF length(where_clause) = 0 THEN
        LET sql_txt = "select a.code_type,(select remark from micm060m b "||
                   "where b.code_type ='00' and b.code = a.code_type),a.code,a.remark " ||
                "from micm060m a " ||
                   " order by a.code_type,a.code"
    ELSE
        LET sql_txt = "select a.code_type,(select remark from micm060m b "||
                   "where b.code_type ='00' and b.code = a.code_type),a.code,a.remark " ||
                   "from micm060m a " || where_clause ||
                  " order by a.code_type,a.code"
        
    END IF
   
    DISPLAY sql_txt
    PREPARE query_sql FROM sql_txt
    DECLARE mic_curs SCROLL CURSOR FOR query_sql

    LET idx=1
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
            DISPLAY ARRAY mic_arr TO v_mics060f.* ATTRIBUTES(COUNT=idx, DOUBLECLICK=select) #ATTRIBUTES(COUNT=idx)
                BEFORE DISPLAY 
                    CALL f.setFieldHidden("del_rec",1)
                    #set multi-range selection
                    CALL DIALOG.setSelectionMode( "v_mics060f", 1 )
            END DISPLAY

            COMMAND "mics060f_query" 
                CALL mics060f_r() 

            COMMAND "mics060f_add"   
                CALL mics060f_i()

            COMMAND "mics060f_upd"  
                #將明細檔刪除欄位恢復顯示
                CALL f.setFieldHidden("del_rec",0)
                IF idx <> 0 THEN 
                    CALL mics060f_u() 
                ELSE
                    CALL FGL_WINMESSAGE( "提示", "請先執行查詢!!", "information")
                END IF
                #將明細檔刪除欄位hidden 
                CALL f.setFieldHidden("del_rec",1) 
             
            COMMAND "mics060f_del"
                IF length(where_clause) <> 0 THEN
                  CALL mics060f_d()
                ELSE
                  # 提示_請先執行查詢!!
                  CALL FGL_WINMESSAGE( "提示", "請先執行查詢!!", "information")
                END IF
            
            COMMAND "bye" 
                 EXIT PROGRAM  
            
        END DIALOG 
    ELSE
    IF t_status = "R" THEN
          #資料不存在,請確認!!
          CALL FGL_WINMESSAGE( "警示","資料不存在,請確認!!", "stop")
    END IF
  END IF
     
END FUNCTION
#-----------------------------------------------------------------------
# 新增
#-----------------------------------------------------------------------
FUNCTION mics060f_i()
DEFINE add_ok SMALLINT
         
 CLEAR FORM
 LET where_clause = ""
 CALL mic_arr.clear()

 LET mark = 0
 
 DIALOG ATTRIBUTE(UNBUFFERED)
 
    INPUT ARRAY mic_arr FROM v_mics060f.* #ATTRIBUTE (UNBUFFERED, COUNT=idx)
        BEFORE INSERT
            #鎖住欄位不可變動
            CALL DIALOG.setFieldActive("code_desc",0)
        AFTER FIELD code_type
            LET curr_pa = arr_curr()
            SELECT remark INTO mic_arr[curr_pa].code_desc
            FROM micm060m WHERE code_type = '00' AND code = mic_arr[curr_pa].code_type
    END INPUT 

    ON ACTION mics060f_save #按存檔
       EXIT DIALOG

    ON ACTION bye
       LET mark = 1
       CALL mics060f_clear()       
       EXIT DIALOG
 
 END DIALOG

  IF mark = 0 THEN
     MENU %"提示" ATTRIBUTES (STYLE="dialog", 
               COMMENT=LSTR("是否確定新增資料?"))     
     COMMAND %"確定" 
        CALL mic_arr.getLength() RETURNING idx  
        CALL mics060f_i_insert(idx) RETURNING add_ok
        IF add_ok = TRUE THEN
             CALL FGL_WINMESSAGE("提示", "資料已新增完畢!!", "information")
             CALL mics060f_reload()
        END IF
        IF add_ok = FALSE THEN
             CALL FGL_WINMESSAGE( "警示", "新增有誤!!", "stop")   
        END IF
             
     COMMAND %"取消" 
     
        CLEAR FORM
        CALL mics060f_clear()
           
     END MENU
  END IF

END FUNCTION
#------------------------------------------------------------------------
#新增_寫入資料
#------------------------------------------------------------------------
FUNCTION  mics060f_i_insert(idx)
DEFINE add_ok,idx,i SMALLINT

    LET i = 1
    LET add_ok = TRUE
    WHENEVER ERROR CONTINUE
    WHILE i <= idx AND length(mic_arr[i].code_type) > 0
      INSERT INTO micm060m
            (code_type,
             code,
             remark, 
             date_last_maint,
             time_last_maint)
        VALUES (mic_arr[i].code_type,
                mic_arr[i].code,
                mic_arr[i].remark,
                t_date,
                t_time)
            
        LET i = i + 1
        
        IF (SQLCA.SQLCODE = 0) THEN
            LET add_ok = TRUE
        ELSE
            LET add_ok = FALSE
            ERROR SQLERRMESSAGE
        END IF
    END WHILE
    WHENEVER ERROR STOP
    RETURN add_ok
  
RETURN add_ok

END FUNCTION
#------------------------------------------------------------------------
# 修改資料
#------------------------------------------------------------------------
FUNCTION mics060f_u()
DEFINE alter_ok,del_ok,t_cur SMALLINT
       
    LABEL input_rec:
    LET t_status = "U"
    LET mark = 0
    #欄位輸入
    DIALOG ATTRIBUTES(UNBUFFERED)
     
        INPUT ARRAY mic_arr FROM v_mics060f.* #ATTRIBUTE (WITHOUT DEFAULTS)
            BEFORE INSERT
                CANCEL INSERT 
                
            BEFORE ROW
                #curr_pa = 當下所在列數
                LET curr_pa = ARR_CURR()
                #鎖住欄位不可修改
                CALL DIALOG.setFieldActive("code_type",0)
                CALL DIALOG.setFieldActive("code_desc",0)
                CALL DIALOG.setFieldActive("code",0)
                #預設false
                LET mic_arr[curr_pa].upd_flag = FALSE 
                
            ON ROW CHANGE
                 LET t_cur = DIALOG.getCurrentRow("v_mics060f") 
                 LET mic_arr[t_cur].upd_flag = TRUE 
                 DISPLAY mic_arr[t_cur].upd_flag
        END INPUT

        ON ACTION mics060f_save  #按存檔
            IF DIALOG.getFieldTouched("v_mics060f.*") THEN 
                LET curr_pa = ARR_CURR()
                LET mic_arr[curr_pa].upd_flag = TRUE 
            END IF 
            EXIT DIALOG
              
        ON ACTION bye
           LET mark = 1
           CALL mics060f_clear()
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
            CALL mics060f_u_update(idx) RETURNING alter_ok
            #update明細檔(刪除)
            CALL mics060f_u_del(idx) RETURNING del_ok

            CASE  alter_ok
            WHEN TRUE 
                #提示 資料已修改完畢!!
                CALL FGL_WINMESSAGE("提示", "資料已修改完畢!!", "information")
                CALL mics060f_reload()
                DISPLAY "where=" || where_clause
            WHEN FALSE 
                #警告 資料修改有誤!!
                CALL FGL_WINMESSAGE("警告","資料修改有誤", "stop")
                GOTO input_rec
            END CASE 
     
       COMMAND %"取消" 
          GOTO input_rec
      
       COMMAND %"放棄" 
          CALL mics060f_reload()     
       END MENU
  END IF
  

END FUNCTION
#----------------------------------------------------------------------- 
# 
#-----------------------------------------------------------------------  
FUNCTION mics060f_u_update(idx)
DEFINE i,idx,alter_ok SMALLINT
DEFINE s_sql STRING 

  LET i = 1
  LET alter_ok = 1
 
    WHILE i <= idx   
        #----------------------------
        #flag= TRUE -> 有修改才update
        IF mic_arr[i].upd_flag = TRUE THEN 
            SELECT * FROM micm060m
            WHERE code_type = mic_arr[i].code_type AND code =  mic_arr[i].code

            IF (SQLCA.SQLCODE = 0) THEN
            #修改存在資料則update
                UPDATE micm060m SET 
                   remark = mic_arr[i].remark
                WHERE code_type = mic_arr[i].code_type AND code =  mic_arr[i].code

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
FUNCTION mics060f_u_del(idx)
DEFINE idx,i,del_ok SMALLINT

TRY 

 LET i = 1
 LET del_ok = TRUE
  WHENEVER ERROR CONTINUE
  WHILE i <= idx
      #將核取方塊中勾選者刪除
      IF mic_arr[i].del_rec = "Y" THEN
         DELETE FROM micm060m
         WHERE code_type = mic_arr[i].code_type AND code =  mic_arr[i].code
        
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
   CALL FGL_WINMESSAGE("警示", "FUNCTION  mics060f_u_del ERROR!", "stop") 
   LET del_ok = FALSE
 END TRY
 
 RETURN del_ok
  
END FUNCTION
#-----------------------------------------------------------------------    
#刪除資料
#-----------------------------------------------------------------------  
FUNCTION mics060f_d()
DEFINE sql_txt,ans STRING,
       t_search_all CHAR(1)

TRY 
    CALL sys_str_find(where_clause,"1=1") RETURNING t_search_all
    IF t_search_all = TRUE THEN
        CALL FGL_WINMESSAGE("警示","全選查詢不允許刪除,請輸入KEY值查詢!", "stop")
    ELSE 
         LET ans = FGL_WINBUTTON("刪除資料", "是否確定刪除?",
            "Lynx", "確定"||"|"||"取消", "question", 0)

         IF ans = "確定" THEN --"yes" THEN
              LET sql_txt = "delete from micm060m " || where_clause
              DISPLAY sql_txt
              WHENEVER ERROR CONTINUE    
                EXECUTE IMMEDIATE sql_txt
              WHENEVER ERROR STOP
               #"資料已刪除完畢!!"
               CALL FGL_WINMESSAGE("提示","資料已刪除完畢!!", "information")
               CALL mics060f_clear()
         END IF 
    END IF 

CATCH
   CALL FGL_WINMESSAGE( "警告", "FUNCTION mics060f_d ERROR!", "stop") 
END TRY 

END FUNCTION
#-----------------------------------------------------------------------  
#Reload data
#-----------------------------------------------------------------------  
FUNCTION mics060f_reload()
      
    TRY
        CALL mic_arr.clear()
        DISPLAY ARRAY mic_arr TO v_mics060f.* ATTRIBUTES(COUNT=idx)
            BEFORE DISPLAY
                CALL f.setFieldHidden("del_rec",1)
            EXIT DISPLAY
        END DISPLAY 
        IF length(where_clause) <> 0 THEN
            CALL mic_arr.clear()
            CALL mics060f_r1()
            DISPLAY "qquerryyyyyyyyy"
        END IF
        LET where_clause = ""
    CATCH
        CALL FGL_WINMESSAGE( "警示", "FUNCTION mics060f_reload ERROR!", "stop")
    END TRY
 
END FUNCTION
#-----------------------------------------------------------------------
# 清除畫面資料
#-----------------------------------------------------------------------
FUNCTION mics060f_clear()
    CALL mic_arr.clear()
    DISPLAY ARRAY mic_arr TO v_mics060f.* #ATTRIBUTES(COUNT=idx)
      BEFORE DISPLAY
      EXIT DISPLAY
    END DISPLAY
END FUNCTION


