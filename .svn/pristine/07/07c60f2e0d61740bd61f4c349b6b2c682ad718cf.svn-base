IMPORT FGL sys_toolbar
IMPORT FGL sys_public
IMPORT FGL fgldialog
IMPORT FGL fun_turn_to_uppercase


GLOBALS "../../sys/library/sys_globals.4gl"

SCHEMA rdbmic36
DEFINE mic_arr  DYNAMIC ARRAY OF RECORD
    line_marking LIKE micm310m.LINE_MARKING,
    lm_side LIKE micm310m.LM_SIDE,
    lm_plane LIKE micm310m.LM_PLANE,
    lm_heat_no LIKE micm310m.LM_HEAT_NO,
    lm_coil_no LIKE micm310m.LM_COIL_NO,
    lm_spec LIKE micm310m.LM_SPEC,
    lm_steel_grade LIKE micm310m.LM_STEEL_GRADE,
    lm_surface LIKE micm310m.LM_SURFACE,
    lm_dimemtion LIKE micm310m.LM_DIMEMTION,
    remark LIKE micm310m.REMARK,
    del_rec VARCHAR(1),
    upd_flag BOOLEAN 
END RECORD

DEFINE mic_arr_uppercase RECORD 
    line_marking STRING ,
    lm_side STRING,
    lm_plane STRING,
    lm_heat_no STRING,
    lm_coil_no STRING,
    lm_spec STRING,
    lm_steel_grade STRING,
    lm_surface STRING,
    lm_dimemtion STRING,
    remark STRING
    END RECORD ,

idx,mark,curr_pa SMALLINT,
where_clause STRING,
t_date VARCHAR(8),
t_time VARCHAR(6),
t_status VARCHAR(1)

MAIN

    CONNECT TO "rdbmic36" AS "MIC"

    LET channel = "micm310f"
    CALL sys_contro_toolbar(channel,"1")  
    CALL ui.Interface.loadStyles("sys_style") 

    CALL sys_date() RETURNING t_date
    CALL sys_time() RETURNING t_time

    CLOSE WINDOW SCREEN
    OPEN WINDOW f1 WITH FORM "micm310f" ATTRIBUTES (STYLE="mystyle",NORMAL)
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
    MENU ATTRIBUTES (STYLE="Window.naked")
        BEFORE MENU 
            #將明細檔刪除欄位hidden 
            CALL f.setFieldHidden("del_rec",1)
        COMMAND "micm310f_query" 
            CALL f.setFieldHidden("del_rec",1)
            #CALL f.setFieldStyle("line_marking","Label")
            CALL micm310f_r() 
            DISPLAY "123" AT 5,5 ATTRIBUTES(BLACK, BOLD, BLINK)

        COMMAND "micm310f_add"   
            CALL f.setFieldHidden("del_rec",1)
            CALL micm310f_i()
    
        COMMAND "micm310f_upd"  
             #將明細檔刪除欄位恢復顯示
             CALL f.setFieldHidden("del_rec",0)
             IF idx <> 0 THEN 
               CALL micm310f_u() 
             ELSE
               CALL FGL_WINMESSAGE( "提示", "請先執行查詢!!", "information")
             END IF
             #將明細檔刪除欄位hidden 
             CALL f.setFieldHidden("del_rec",1) 

        COMMAND "micm310f_del"
            IF idx <> 0 THEN #length(where_clause) <> 0 THEN
              CALL micm310f_d()
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
FUNCTION micm310f_r()
DEFINE mark SMALLINT

    LET t_status = "R"
    LET mark = 0
    LET idx=1
    CLEAR FORM
    CALL mic_arr.clear()
    DIALOG ATTRIBUTE(UNBUFFERED)
        INPUT mic_arr[1].line_marking
            FROM v_micm310f.line_marking
            ON ACTION ACCEPT
                EXIT DIALOG
            ON ACTION bye 
                LET mark = 1
                EXIT DIALOG 
        END INPUT
    END DIALOG
    LET mic_arr_uppercase.line_marking = mic_arr[1].line_marking
    LET mic_arr_uppercase.line_marking = mic_arr_uppercase.line_marking.toUpperCase()
   
    IF LENGTH(mic_arr_uppercase.line_marking) <> 0 THEN 
        LET where_clause =
            "where line_marking='"
                || mic_arr_uppercase.line_marking CLIPPED || "'"
    ELSE
        LET where_clause = ""
    END IF  

    CALL micm310f_r1()

END FUNCTION
#-----------------------------------------------------------------------
# 查詢2
#-----------------------------------------------------------------------  
FUNCTION micm310f_r1()
DEFINE sql_txt STRING

    IF length(where_clause) = 0 THEN
        LET sql_txt = "select LINE_MARKING, LM_SIDE, LM_PLANE, LM_HEAT_NO, LM_COIL_NO " || 
                      ", LM_SPEC, LM_STEEL_GRADE, LM_SURFACE, LM_DIMEMTION, REMARK " ||
                "from micm310m " ||
                   " order by line_marking"
    ELSE
        LET sql_txt ="select LINE_MARKING, LM_SIDE, LM_PLANE, LM_HEAT_NO, LM_COIL_NO " || 
                      ", LM_SPEC, LM_STEEL_GRADE, LM_SURFACE, LM_DIMEMTION, REMARK " ||
                "from micm310m " || where_clause ||
                   " order by line_marking"
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
            DISPLAY ARRAY mic_arr TO v_micm310f.* ATTRIBUTES(COUNT=idx, DOUBLECLICK=SELECT) #ATTRIBUTES(COUNT=idx)
                BEFORE DISPLAY 
                    CALL f.setFieldHidden("del_rec",1)
                    #set multi-range selection
                    CALL DIALOG.setSelectionMode( "v_micm310f", 1 )
                    EXIT DIALOG 
            END DISPLAY
        END DIALOG 
    ELSE
    IF t_status = "R" THEN
          #資料不存在,請確認!!
          LET idx=0
          CALL FGL_WINMESSAGE( "警示","資料不存在,請確認!!", "stop")
    END IF
  END IF
     
END FUNCTION

#-----------------------------------------------------------------------
# 新增
#-----------------------------------------------------------------------
FUNCTION micm310f_i()
DEFINE add_ok SMALLINT
         
 CLEAR FORM
 LET where_clause = ""
 CALL mic_arr.clear()

 LET mark = 0
 
 DIALOG ATTRIBUTE(UNBUFFERED)
 
    INPUT ARRAY mic_arr FROM v_micm310f.* #ATTRIBUTE (UNBUFFERED, COUNT=idx)
        BEFORE INSERT
            #鎖住欄位不可變動
            #CALL DIALOG.setFieldActive("code_desc",0)
    END INPUT 

    ON ACTION micm310f_save #按存檔
       EXIT DIALOG

    ON ACTION bye
       LET mark = 1
       LET idx=0
       CALL micm310f_clear()       
       EXIT DIALOG
 
 END DIALOG

  IF mark = 0 THEN
     MENU %"提示" ATTRIBUTES (STYLE="dialog", 
               COMMENT=LSTR("是否確定新增資料?"))     
     COMMAND %"確定" 
        CALL mic_arr.getLength() RETURNING idx  
        CALL micm310f_i_insert(idx) RETURNING add_ok
        IF add_ok = TRUE THEN
             CALL FGL_WINMESSAGE("提示", "資料已新增完畢!!", "information")
             CALL micm310f_reload()
        END IF
        IF add_ok = FALSE THEN
             CALL FGL_WINMESSAGE( "警示", "新增有誤!!", "stop")   
        END IF
             
     COMMAND %"取消" 
     
        CLEAR FORM
        CALL micm310f_clear()
           
     END MENU
  END IF

END FUNCTION

#------------------------------------------------------------------------
#新增_寫入資料
#------------------------------------------------------------------------
FUNCTION  micm310f_i_insert(idx)
DEFINE add_ok,idx,i SMALLINT
    LET i = 1
    LET add_ok = TRUE
    WHENEVER ERROR CONTINUE
    WHILE i <= idx AND length(mic_arr[i].line_marking) > 0
        CALL fun_turn_to_uppercase(mic_arr,mic_arr_uppercase.*,i) RETURNING mic_arr_uppercase.*
        
      INSERT INTO micm310m
            (line_marking,
             lm_side,
             lm_plane, 
             lm_heat_no,
             lm_coil_no,
             lm_spec,
             lm_steel_grade,
             lm_surface,
             lm_dimemtion,
             remark)
        VALUES (mic_arr_uppercase.line_marking,
                mic_arr_uppercase.lm_side,
                mic_arr_uppercase.lm_plane,
                mic_arr_uppercase.lm_heat_no,
                mic_arr_uppercase.lm_coil_no,
                mic_arr_uppercase.lm_spec,
                mic_arr_uppercase.lm_steel_grade,
                mic_arr_uppercase.lm_surface,
                mic_arr_uppercase.lm_dimemtion,
                mic_arr_uppercase.remark)
            
        LET i = i + 1
        
        IF (SQLCA.SQLCODE = 0) THEN
            LET add_ok = TRUE
        ELSE
            LET add_ok = FALSE
            DISPLAY  i,SQLERRMESSAGE
        END IF
    END WHILE
    WHENEVER ERROR STOP
    
  
    RETURN add_ok

END FUNCTION

#------------------------------------------------------------------------
# 修改資料
#------------------------------------------------------------------------
FUNCTION micm310f_u()
DEFINE alter_ok,del_ok,t_cur SMALLINT
       
    LABEL input_rec:
    LET t_status = "U"
    LET mark = 0
    #欄位輸入
    DIALOG ATTRIBUTES(UNBUFFERED)
     
        INPUT ARRAY mic_arr FROM v_micm310f.* #ATTRIBUTE (WITHOUT DEFAULTS)
            BEFORE INSERT
                CANCEL INSERT 
                
            BEFORE ROW
                #curr_pa = 當下所在列數
                LET curr_pa = ARR_CURR()
                #鎖住欄位不可修改
                CALL DIALOG.setFieldActive("line_marking",0)
                #預設false
                LET mic_arr[curr_pa].upd_flag = FALSE 
                
            ON ROW CHANGE
                 LET t_cur = DIALOG.getCurrentRow("v_micm310f") 
                 LET mic_arr[t_cur].upd_flag = TRUE 
                 DISPLAY mic_arr[t_cur].upd_flag
        END INPUT

        ON ACTION micm310f_save  #按存檔
            IF DIALOG.getFieldTouched("v_micm310f.*") THEN 
                LET curr_pa = ARR_CURR()
                LET mic_arr[curr_pa].upd_flag = TRUE 
            END IF 
            EXIT DIALOG
              
        ON ACTION bye
           LET mark = 1
           CALL micm310f_clear()
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
            CALL micm310f_u_update(idx) RETURNING alter_ok
            #update明細檔(刪除)
            CALL micm310f_u_del(idx) RETURNING del_ok

            CASE  alter_ok
            WHEN TRUE 
                #提示 資料已修改完畢!!
                CALL FGL_WINMESSAGE("提示", "資料已修改完畢!!", "information")
                CALL micm310f_reload()
                DISPLAY "where=" || where_clause
            WHEN FALSE 
                #警告 資料修改有誤!!
                CALL FGL_WINMESSAGE("警告","資料修改有誤", "stop")
                GOTO input_rec
            END CASE 
     
       COMMAND %"取消" 
          GOTO input_rec
      
       COMMAND %"放棄" 
          CALL micm310f_reload()     
       END MENU
  END IF
  

END FUNCTION

#----------------------------------------------------------------------- 
# 
#-----------------------------------------------------------------------  
FUNCTION micm310f_u_update(idx)
DEFINE i,idx,alter_ok SMALLINT
DEFINE s_sql STRING 

  LET i = 1
  LET alter_ok = 1
 
    WHILE i <= idx   
        #----------------------------
        #flag= TRUE -> 有修改才update
        IF mic_arr[i].upd_flag = TRUE THEN 
            CALL fun_turn_to_uppercase(mic_arr,mic_arr_uppercase.*,i) RETURNING mic_arr_uppercase.*
            DISPLAY mic_arr_uppercase.*
            SELECT * FROM micm310m
            WHERE line_marking = mic_arr_uppercase.line_marking
            DISPLAY "i,",i,SQLCA.SQLCODE
            IF (SQLCA.SQLCODE = 0) THEN
            #修改存在資料則update
                UPDATE micm310m SET 
                   lm_side = mic_arr_uppercase.lm_side,
                   lm_plane = mic_arr_uppercase.lm_plane,
                   lm_heat_no = mic_arr_uppercase.lm_heat_no,
                   lm_coil_no = mic_arr_uppercase.lm_coil_no,
                   lm_spec = mic_arr_uppercase.lm_spec,
                   lm_steel_grade = mic_arr_uppercase.lm_steel_grade,
                   lm_surface = mic_arr_uppercase.lm_surface,
                   lm_dimemtion = mic_arr_uppercase.lm_dimemtion,
                   remark = mic_arr_uppercase.remark
                WHERE line_marking = mic_arr_uppercase.line_marking
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

#-----------------------------------------------------------------------  
#修改明細(刪除)
#----------------------------------------------------------------------- 
FUNCTION micm310f_u_del(idx)
DEFINE idx,i,del_ok SMALLINT

TRY 

 LET i = 1
 LET del_ok = TRUE
  WHENEVER ERROR CONTINUE
  WHILE i <= idx
      #將核取方塊中勾選者刪除
      IF mic_arr[i].del_rec = "Y" THEN
         DELETE FROM micm310m
         WHERE line_marking = mic_arr[i].line_marking 
        
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
FUNCTION micm310f_d()
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
              LET sql_txt = "delete from micm310m " || where_clause
              DISPLAY sql_txt
              WHENEVER ERROR CONTINUE    
                EXECUTE IMMEDIATE sql_txt
              WHENEVER ERROR STOP
               #"資料已刪除完畢!!"
               CALL FGL_WINMESSAGE("提示","資料已刪除完畢!!", "information")
               CALL micm310f_clear()
         END IF 
    END IF 

CATCH
   CALL FGL_WINMESSAGE( "警告", "FUNCTION mics060f_d ERROR!", "stop") 
END TRY 

END FUNCTION

#-----------------------------------------------------------------------  
#Reload data
#-----------------------------------------------------------------------  
FUNCTION micm310f_reload()
      
    TRY
        CALL mic_arr.clear()
        DISPLAY ARRAY mic_arr TO v_micm310f.* ATTRIBUTES(COUNT=idx)
            BEFORE DISPLAY
                CALL f.setFieldHidden("del_rec",1)
            EXIT DISPLAY
        END DISPLAY 
        #IF length(where_clause) <> 0 THEN
            CALL mic_arr.clear()
            CALL micm310f_r1()
            DISPLAY "qquerryyyyyyyyy"
        #END IF
        LET where_clause = ""
    CATCH
        CALL FGL_WINMESSAGE( "警示", "FUNCTION mics060f_reload ERROR!", "stop")
    END TRY
 
END FUNCTION
#-----------------------------------------------------------------------
# 清除畫面資料
#-----------------------------------------------------------------------
FUNCTION micm310f_clear()
    CALL mic_arr.clear()
    DISPLAY ARRAY mic_arr TO v_micm310f.* #ATTRIBUTES(COUNT=idx)
      BEFORE DISPLAY
      EXIT DISPLAY
    END DISPLAY
END FUNCTION




