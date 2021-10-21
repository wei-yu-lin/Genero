GLOBALS "../../sys/sys_globals.4gl"

SCHEMA rdbord
DEFINE micm150f_rec RECORD
    product_code like ordc010m.product_code,
    product_type like ordc010m.product_type,
    product_abbr like ordc010m.product_abbr,
    surface_finish like ordc010m.surface_finish,
    product_style  like ordc010m.product_style,
    product_plant  like ordc010m.product_plant,
    product_chi  like ordc010m.product_chi,
    product_eng  like ordc010m.product_eng,
    product_remark like ordc010m.product_remark
END RECORD,
    micm150f_arr DYNAMIC ARRAY OF RECORD
    product_code like ordc010m.product_code,
    product_type like ordc010m.product_type,
    product_abbr like ordc010m.product_abbr,
    surface_finish like ordc010m.surface_finish,
    product_style  like ordc010m.product_style,
    product_plant  like ordc010m.product_plant,
    product_chi  like ordc010m.product_chi,
    product_eng  like ordc010m.product_eng,
    product_remark like ordc010m.product_remark
    END RECORD,
idx,mark,curr_idx,max_row SMALLINT,
where_clause STRING,
t_date VARCHAR(8),
t_time VARCHAR(6),
query_ok VARCHAR(1),
t_product_code VARCHAR(1)



MAIN
    TRY 

    CALL fgl_getenv("g_user_id") RETURNING g_user_id
   
    CONNECT TO "rdbord" AS "ORD"
    LET channel = "micm150f"

    CALL sys_contro_toolbar(channel,"2")  
    CALL ui.Interface.loadStyles("sys_style") 

    CALL sys_date() RETURNING t_date
    CALL sys_time() RETURNING t_time

    CLOSE WINDOW SCREEN
    OPEN WINDOW micm150_f WITH FORM "micm150f" ATTRIBUTES (STYLE="mystyle")
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
   
   #查詢前將上下筆按鈕disable

    MENU ATTRIBUTES (STYLE="Window.naked")
       BEFORE MENU 
         
          #新增
          COMMAND "micm150f_add"
          TRY 
              CALL micm150f_i()
          CATCH
              CALL FGL_WINMESSAGE( "警示", "COMMAND micm150f_add ERROR!", "stop")
          END TRY 
          
          #查詢
          COMMAND "micm150f_query"
             TRY 
             CALL micm150f_r()
             LET query_ok = TRUE

             CATCH
                CALL FGL_WINMESSAGE( "警示", "COMMAND micm150f_query ERROR!", "stop")
             END TRY 
           
          #前一筆
          COMMAND "micm150f_prev"
            TRY 
            CALL micm150f_r1(-1) 
              CATCH
              CALL FGL_WINMESSAGE( "警示", "COMMAND micm150f_prev ERROR!", "stop")
            END TRY 
             
          #後一筆  
          COMMAND "micm150f_next"
            TRY 
            CALL micm150f_r1(1)
              CATCH
              CALL FGL_WINMESSAGE( "警示", "COMMAND micm150f_next ERROR!", "stop")
            END TRY 

          #修改  
          COMMAND "micm150f_upd" 
            TRY 
              IF query_ok = TRUE  THEN
                 CALL micm150f_u()
              END IF 

              CATCH
                 CALL FGL_WINMESSAGE( "警示", "COMMAND micm150f_upd ERROR!", "stop")
              END TRY
                 
          #刪除
          COMMAND "micm150f_del"
            TRY 
              CALL micm150f_d() RETURNING mark 
            CATCH
              CALL FGL_WINMESSAGE( "警示", "COMMAND micm150f_del ERROR!", "stop")
            END TRY 
                 
          COMMAND "bye" 
             EXIT MENU 

    END MENU 
  CATCH
    CALL FGL_WINMESSAGE( "警示", "MAIN ERROR!", "stop")
  END TRY 
END MAIN  
#------------------------------------------------------------------------
# 新增產品代碼檔(ordc010m)資料
#------------------------------------------------------------------------
FUNCTION micm150f_i()
    TRY 
    
    CALL micm150f_clear()
             
    #欄位輸入
    CALL micm150f_i_input()
    CATCH
      CALL FGL_WINMESSAGE( "警示", "FUNCTION micm150f_i ERROR!", "stop")
    END TRY 
END FUNCTION
#-----------------------------------------------------------------------
#欄位輸入
#-----------------------------------------------------------------------
FUNCTION micm150f_i_input()
  DEFINE m_add_ok,mark SMALLINT,
         seq_mark BOOLEAN
  TRY       
  LET mark = 0
  LET seq_mark = 0
  LABEL input_rec:
    DIALOG ATTRIBUTES(UNBUFFERED)
    INPUT   micm150f_rec.product_code,
            micm150f_rec.product_type,
            micm150f_rec.product_abbr,
            micm150f_rec.surface_finish,
            micm150f_rec.product_style,
            micm150f_rec.product_plant,
            micm150f_rec.product_chi,
            micm150f_rec.product_eng,
            micm150f_rec.product_remark

    
        FROM product_code,product_type,product_abbr,surface_finish,
             product_style,product_plant,product_chi,product_eng,
             product_remark
        ATTRIBUTE (WITHOUT DEFAULTS)
        
        AFTER FIELD product_type
            SELECT product_code
              FROM ordc010m
            WHERE product_code = micm150f_rec.product_code AND 
                  product_type = micm150f_rec.product_type
         
            #比對該產品代碼是否已存在
            IF (SQLCA.SQLCODE = 0) THEN
                # 警告 此產品代碼已存在
                CALL FGL_WINMESSAGE( "警示","產品代碼及PRODUCT_TYPE已存在", "stop")
                NEXT FIELD product_type
            END IF
           
    END INPUT 
            
    ON ACTION micm150f_save  #按存檔
       EXIT DIALOG 

    ON ACTION bye
       LET mark = 1
       LET query_ok = FALSE
       CALL micm150f_clear()
       EXIT DIALOG 
  END DIALOG 
  
 
  IF mark = 0 THEN
     #提示   是否確定新增資料？!
     MENU "提示" ATTRIBUTES (STYLE="dialog",COMMENT="是否確定新增資料?")
         #確定
         COMMAND %"確定" 
            CALL micm150f_i_insert() RETURNING m_add_ok
            #IF m_add_ok = TRUE AND d_add_ok = TRUE THEN
         
            IF m_add_ok = TRUE THEN
               #提示 資料已新增完畢!!
                 CALL FGL_WINMESSAGE( "警示", "資料已新增完畢!!", "information")
                 #CALL micm150f_reload()
            END IF

            IF m_add_ok = FALSE THEN
                 #警告 資料新增有誤
                 CALL FGL_WINMESSAGE( "警示", "資料新增有誤!!", "stop")
                 CALL micm150f_clear()             
            END IF 

         #取消   
        COMMAND "取消"
            GOTO input_rec
         
         #放棄
        COMMAND "放棄"
            CLEAR FORM
            CALL micm150f_clear()
               
         END MENU
    END IF 

  CATCH
    CALL FGL_WINMESSAGE( "警示", "FUNCTION micm150f_i_input ERROR!", "stop")
  END TRY 
END FUNCTION
#-----------------------------------------------------------------------  
#產品代碼檔ordc010m新增
#-----------------------------------------------------------------------  
FUNCTION micm150f_i_insert()
    DEFINE m_add_ok SMALLINT 
    
    TRY
    
    WHENEVER ERROR CONTINUE   
    INSERT INTO ordc010m(product_code,
                         product_type,
                         product_abbr,
                         surface_finish,
                         product_style,
                         product_plant,
                         product_chi,
                         product_eng,
                         product_remark,
                         date_last_maint,
                         time_last_maint,
                         user_last_maint)
    VALUES (micm150f_rec.product_code,
            micm150f_rec.product_type,
            micm150f_rec.product_abbr,
            micm150f_rec.surface_finish,
            micm150f_rec.product_style,
            micm150f_rec.product_plant,
            micm150f_rec.product_chi,
            micm150f_rec.product_eng,
            micm150f_rec.product_remark,
            t_date,
            t_time,
            g_user_id)
    WHENEVER ERROR STOP

    IF SQLCA.SQLCODE = 0 THEN
       LET m_add_ok = TRUE
    ELSE
       LET m_add_ok = FALSE
       #ERROR SQLERRMESSAGE
    END IF

    CATCH
      CALL FGL_WINMESSAGE( "警示", "FUNCTION micm150f_i_insert ERROR!", "stop")
    END TRY 
      RETURN m_add_ok
END FUNCTION
#-----------------------------------------------------------------------  
#upd 產品代碼檔維護作業
#-----------------------------------------------------------------------  
FUNCTION micm150f_u()
    DEFINE t_product_code varchar(1),
           m_alter_ok smallint,
           mark varchar(1),
           matches INTEGER
    TRY        
    LET mark = 0
    
    LABEL input_rec:
    DIALOG ATTRIBUTES(UNBUFFERED, FIELD ORDER FORM)
        INPUT BY NAME micm150f_arr[curr_idx].* ATTRIBUTE(WITHOUT DEFAULTS)
        BEFORE INPUT
            #鎖住欄位不可修改
            CALL dialog.setFieldActive("product_code", FALSE)

        END INPUT

    
    ON ACTION micm150f_save  #按存檔時離開
       EXIT DIALOG 
    ON ACTION bye
       LET mark = 1
       LET t_product_code = ""
       LET query_ok = FALSE
       CALL micm150f_clear()
       EXIT DIALOG 
        
    END DIALOG    
    
    IF mark = 0 THEN

        #提示  是否確定修改資料？!
        MENU "提示" ATTRIBUTES (STYLE="dialog",COMMENT="是否確定修改資料?")
       #確定
        COMMAND "確定" 
       #update ordc010m
        CALL micm150f_u_update() RETURNING m_alter_ok,MATCHES

        IF m_alter_ok = TRUE AND matches = FALSE THEN
          #提示 資料已修改完畢!!
          CALL FGL_WINMESSAGE( "提示", "資料已修改完畢!!", "information")
          #CALL clear_fama020f()
          CALL micm150f_reload()
        END IF

        IF m_alter_ok = FALSE THEN
          #警告 資料修改有誤!!
          CALL FGL_WINMESSAGE( "警示", "資料修改有誤!!", "stop")
          GOTO input_rec
          #CALL micm150f_clear()
        END IF 
        #取消
        COMMAND "取消"
          GOTO input_rec
        #放棄    
        COMMAND "放棄"
          # CALL micm150f_reload(t_product_code)       

          CALL micm150f_clear()     
        END MENU 
     END IF     
  CATCH
    CALL FGL_WINMESSAGE( "警示", "FUNCTION micm150f_u ERROR!", "stop")
  END TRY
END FUNCTION
#-----------------------------------------------------------------------  
#ordc010m 修改
#----------------------------------------------------------------------- 
FUNCTION micm150f_u_update()
  DEFINE ordc010m_u_rec  RECORD
    product_type like ordc010m.product_type,
    product_abbr like ordc010m.product_abbr,
    surface_finish like ordc010m.surface_finish,
    product_style like ordc010m.product_style,
    product_plant like ordc010m.product_plant,
    product_chi like ordc010m.product_chi,
    product_eng like ordc010m.product_eng,
    product_remark like ordc010m.product_remark
  END RECORD,
  m_alter_ok smallint,
  matches INTEGER
  
  TRY 
  
  LET matches = FALSE
  
  WHENEVER ERROR CONTINUE   
  SELECT    product_type,
            product_abbr,
            surface_finish,
            product_style,
            product_plant,
            product_chi,
            product_eng,
            product_remark
  INTO  ordc010m_u_rec.product_type,
        ordc010m_u_rec.product_abbr,
        ordc010m_u_rec.surface_finish,
        ordc010m_u_rec.product_style,
        ordc010m_u_rec.product_plant,
        ordc010m_u_rec.product_chi,
        ordc010m_u_rec.product_eng,
        ordc010m_u_rec.product_remark
  FROM ordc010m
  WHERE product_code = micm150f_arr[curr_idx].product_code
        
        FOR UPDATE
  WHENEVER ERROR STOP 

  IF SQLCA.SQLCODE = NOTFOUND THEN
      #警示 資料已不存在,請確認!!  
      CALL FGL_WINMESSAGE( "警示", "資料不存在,請確認!!", "stop")
  ELSE                      -- compare records    

      IF ordc010m_u_rec.* = micm150f_arr[curr_idx].* THEN
        LET matches = TRUE      
        LET m_alter_ok = TRUE
      ELSE
        LET matches = FALSE
      END IF
    #有修改則update

     IF matches = FALSE THEN     
        WHENEVER ERROR CONTINUE
        UPDATE ordc010m SET
            product_abbr = micm150f_arr[curr_idx].product_abbr,
            surface_finish  = micm150f_arr[curr_idx].surface_finish,
            product_style = micm150f_arr[curr_idx].product_style,
            product_plant   = micm150f_arr[curr_idx].product_plant,
            product_chi = micm150f_arr[curr_idx].product_chi,
            product_eng = micm150f_arr[curr_idx].product_eng,
            product_remark = micm150f_arr[curr_idx].product_remark,
            date_last_maint = t_date,
            time_last_maint = t_time,
            user_last_maint = g_user_id
        WHERE product_code = micm150f_arr[curr_idx].product_code AND 
              product_type = micm150f_arr[curr_idx].product_type
        
        WHENEVER ERROR STOP  

        IF SQLCA.SQLCODE = 0 THEN
           LET m_alter_ok = TRUE
        ELSE
           LET m_alter_ok = FALSE
           #ERROR SQLERRMESSAGE
        END IF 
     END IF
  END IF

  CATCH
    CALL FGL_WINMESSAGE( "警示", "FUNCTION micm150f_u_input ERROR!", "stop")
  END TRY 
    RETURN m_alter_ok,MATCHES
END FUNCTION
#-----------------------------------------------------------------------  
#查詢產品代碼檔資料
#-----------------------------------------------------------------------  
FUNCTION micm150f_r()
    DEFINE where_clause STRING,
           mark SMALLINT

    TRY 
    CLEAR FORM

    INITIALIZE micm150f_rec.* TO NULL

    LET mark = 0
    CONSTRUCT BY NAME where_clause ON   product_code,
                                        product_type

       ON ACTION bye
       CALL micm150f_clear()
       LET mark = 1
       EXIT CONSTRUCT
      END CONSTRUCT 
                                        
    IF length(where_clause) > 0 THEN
        LET where_clause = "where " || WHERE_clause
    ELSE
        LET where_clause =""
        LET mark = 1
    END IF

    IF mark matches 0 THEN
        CALL micm150f_r_query(where_clause) 
    END IF  
    
    CATCH
      CALL FGL_WINMESSAGE( "警示", "FUNCTION micm150f_r ERROR!", "stop")
    END TRY 

END FUNCTION
#-----------------------------------------------------------------------  
#查詢產品代碼檔資料
#-----------------------------------------------------------------------  
FUNCTION micm150f_r_query(where_clause)
    DEFINE where_clause STRING
    
    TRY 
    DECLARE ordc010m_cur CURSOR FROM
        "select product_code,product_type,product_abbr,surface_finish,"||
                  "product_style,product_plant,product_chi,product_eng,"||
                  "product_remark from ordc010m " || 
                  where_clause CLIPPED

    LET idx = 0
    LET max_row = 1
    CALL micm150f_arr.clear()
    WHENEVER ERROR CONTINUE
    FOREACH ordc010m_cur INTO micm150f_rec.*
            LET idx = idx + 1
            LET micm150f_arr[idx].* = micm150f_rec.*
        END FOREACH
        WHENEVER ERROR STOP

        FREE ordc010m_cur
        CLOSE ordc010m_cur

        IF (idx > 0) THEN
            LET curr_idx = 1
            DISPLAY BY NAME micm150f_arr[curr_idx].*
            LET max_row = micm150f_arr.getLength()
        ELSE
            CALL FGL_WINMESSAGE( "提示", "資料不存在,請確認!!", "information")
        END IF

    CATCH
        CALL FGL_WINMESSAGE( "警示", "FUNCTION micm150f_r ERROR!", "stop")
    END TRY
END FUNCTION
#-----------------------------------------------------------------------  
#抓上下筆資料
#-----------------------------------------------------------------------  
FUNCTION micm150f_r1(idx)
    DEFINE idx SMALLINT

    DISPLAY curr_idx
    DISPLAY max_row
    
    IF curr_idx = 0 THEN
        MESSAGE "無資料"
    ELSE
        LET curr_idx = curr_idx + idx
        MESSAGE ""
        IF curr_idx = 0 THEN
            LET curr_idx = 1
            CALL FGL_WINMESSAGE("警示", "已達第一筆", "stop")
        ELSE
            IF curr_idx = max_row + 1 THEN
                LET curr_idx = max_row
                CALL FGL_WINMESSAGE("警示", "已達最後一筆", "stop")
            END IF
        END IF
        DISPLAY BY NAME micm150f_arr[curr_idx].*
    END IF
END FUNCTION
#-----------------------------------------------------------------------    
#刪除資料
#-----------------------------------------------------------------------  
FUNCTION micm150f_d()
  DEFINE cnt SMALLINT,
         ans STRING

    TRY 
    LET mark = 0
  
     LET ans = FGL_WINBUTTON( "刪除資料", "是否確定刪除?",
        "Lynx", "確定"||"|"||"取消", "question", 0)
 
     IF ans = "確定" THEN --"yes" THEN

           WHENEVER ERROR CONTINUE    
           SELECT count(*) INTO cnt
            FROM ordc010m 
           WHERE product_code = micm150f_arr[curr_idx].product_code AND 
                 product_type = micm150f_arr[curr_idx].product_type

           WHENEVER ERROR STOP

           IF SQLCA.SQLCODE <> 0  THEN
             #提示 資料不存在,請確認!!
             CALL FGL_WINMESSAGE( "提示", "資料不存在,請確認!!", "information")
             CALL micm150f_clear()
           ELSE
                  
             WHENEVER ERROR CONTINUE
      
             DELETE FROM ordc010m WHERE product_code = micm150f_arr[curr_idx].product_code AND 
                                        product_type = micm150f_arr[curr_idx].product_type
             LET mark = 1
             #提示 刪除完畢!!     
             CALL FGL_WINMESSAGE( "提示", "資料已刪除完畢!!", "information")
             CALL micm150f_clear() 
           END IF  
        END IF

  CATCH
    CALL FGL_WINMESSAGE( "警示", "FUNCTION micm150f_d ERROR!", "stop")
  END TRY 
  RETURN mark
END FUNCTION
#-----------------------------------------------------------------------  
#顯示畫面資料
#-----------------------------------------------------------------------  
FUNCTION micm150f_display()

  TRY 
  SELECT product_code,product_type,product_abbr,surface_finish,
         product_style,product_plant,product_chi,product_eng,
         product_remark
     INTO   micm150f_rec.product_code,
            micm150f_rec.product_type,
            micm150f_rec.product_abbr,
            micm150f_rec.surface_finish,
            micm150f_rec.product_style,
            micm150f_rec.product_plant,
            micm150f_rec.product_chi,
            micm150f_rec.product_eng,
            micm150f_rec.product_remark
  FROM ordc010m WHERE product_code = micm150f_rec.product_code 
       AND product_type = micm150f_rec.product_type 

  IF SQLCA.sqlcode <> NOTFOUND THEN

  ELSE 
     LET micm150f_rec.product_code = ""
     LET micm150f_rec.product_type = ""
     LET micm150f_rec.product_abbr = ""
     LET micm150f_rec.surface_finish = ""
     LET micm150f_rec.product_style = ""
     LET micm150f_rec.product_plant = ""
     LET micm150f_rec.product_chi = ""
     LET micm150f_rec.product_eng = ""
     LET micm150f_rec.product_remark = ""   
  END IF 

  DISPLAY micm150f_rec.*  TO v_micm150f.* 
  CATCH
    CALL FGL_WINMESSAGE( "警示", "FUNCTION micm150f_display ERROR!", "stop")
  END TRY 

END FUNCTION
#-----------------------------------------------------------------------   
#作業結束後清除畫面及record變數資料
#----------------------------------------------------------------------- 
FUNCTION micm150f_clear()
    TRY 
    INITIALIZE micm150f_rec.* TO NULL
    DISPLAY micm150f_rec.*  TO v_micm150f.*
      CATCH
      CALL FGL_WINMESSAGE( "警示", "FUNCTION micm150f_clear ERROR!", "stop")
    END TRY 

END FUNCTION 
#-----------------------------------------------------------------------  
#修改後reload data
#-----------------------------------------------------------------------  
FUNCTION micm150f_reload()
DEFINE u_product_code varchar(10),
       where_clause STRING
  TRY 
  LET where_clause = "where product_code =" ||" '"||micm150f_arr[curr_idx].product_code ||"' AND"||
                     " product_type =" ||" '"||micm150f_arr[curr_idx].product_type||"'"

  CALL micm150f_r_query(where_clause) 
  CATCH
    CALL FGL_WINMESSAGE( "警示", "FUNCTION micm150f_reload ERROR!", "stop")
  END TRY 
END FUNCTION