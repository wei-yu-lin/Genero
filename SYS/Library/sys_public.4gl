GLOBALS "sys_globals.4gl"

DEFINE curr_pa,idx SMALLINT
#------------------------------------------------------------------------
# get權限
#------------------------------------------------------------------------
FUNCTION sys_get_priv(channel,s_user,s_priv)
DEFINE channel varchar(20),
       s_user varchar(10),
       s_priv char(7),
       s_add char(1),
       s_del char(1),
       s_upd char(1),
       s_qry char(1),
       s_prt char(1),
       s_exe char(1),
       s_type char(1)

 TRY 
  CALL upshift(channel) RETURNING channel

  SET CONNECTION "mis"
  SELECT padd,pdelete,pmodify,pquery,pprint,pexecute 
  INTO s_add,s_del,s_upd,s_qry,s_prt,s_exe 
      FROM secuprg
      WHERE prg_no = channel AND user_id = s_user

  SELECT u_type 
  INTO s_type
  FROM secuser
  WHERE user_id = s_user AND rownum = 1

  IF s_type = "S" THEN
     LET s_priv = "YYYYYY" || s_type
  ELSE
     LET s_priv = s_add || s_del || s_upd || s_qry || s_prt || s_exe || s_type
     #CALL FGL_WINMESSAGE( "PRIV", s_priv, "information")
  END IF
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_get_priv error!!", "stop")
 END TRY 
 
 RETURN s_priv

END FUNCTION
#------------------------------------------------------------------------
# set動作權限
#------------------------------------------------------------------------
FUNCTION sys_set_act1(d,channel,s_priv,t_type)
DEFINE d ui.Dialog
DEFINE channel varchar(20),
       s_priv char(7),
       t_type char(1),
       act_name_add,act_name_del,act_name_upd,act_name_qry varchar(20),
       act_name_next,act_name_prev,act_name_help varchar(20),
       act_name_first,act_name_last varchar(20)

 TRY 
  LET act_name_add = channel || "_add"
  LET act_name_del = channel || "_del"
  LET act_name_upd = channel || "_upd"
  LET act_name_qry = channel || "_query"
  LET act_name_next = channel || "_next"
  LET act_name_prev = channel || "_prev"
  LET act_name_first = channel || "_first"
  LET act_name_last = channel || "_last"
  LET act_name_help = channel || "_help"

#
{  1.normal(新增,查詢,修改,刪除,存檔,離開,說明)
   2.full(新增,查詢,前一筆,後一筆,修改,刪除,存檔,離開,說明)
   3.full query&update&del(查詢,前一筆,後一筆,修改,刪除,存檔,離開,說明)
   4.query&update&del(查詢,修改,刪除,存檔,離開,說明)
   5.query&update&del&back(查詢,前一筆,後一筆,修改,刪除,存檔,返回,離開,說明)
   6.query&update(查詢,修改,存檔,離開,說明)
   7.query(查詢,離開,說明)
   8.exit(離開)
   9.query&update(查詢,前一筆,後一筆,修改,存檔,離開,說明)
   A.update(修改,存檔,離開,說明) ->不鎖權限的toolbar type
   B.add&update(新增,查詢,前一筆,後一筆,修改,存檔,離開,說明)
   C.query&update(查詢,前一筆,後一筆,修改,存檔,離開,說明)
   D.query(查詢,前一筆,後一筆,離開,說明)
   E.full maintain(新增,查詢,前一筆,後一筆,第一筆,最後筆,修改,刪除,存檔,離開,說明)
   F.full query(查詢,前一筆,後一筆,第一筆,最後筆,離開,說明)
   G.save(存檔,離開,說明) ->不鎖權限的toolbar type
   H.add&query&del(新增,查詢,前一筆,後一筆,刪除,存檔)
   I.add&query(新增,查詢,前一筆,後一筆,存檔)
   J.normal& no del(新增,查詢,修改,存檔,離開,說明)
}

#新增  1,2,B,E,H,I,J
#修改  1,2,3,4,5,6,9,B,C,E,J
#刪除  1,2,3,4,5,E,H
#查詢  1,2,3,4,5,6,7,9,B,C,D,E,F,H,I,J
#上下筆 2,3,5,9,B,C,D,E,F,H,I
#第一筆,最後筆 E,F
 
  #系統維護者則權限全開
  IF s_priv[7,7] = "S" THEN
    IF sys_str_find("1,2,B,E,H,I,J",t_type) THEN
      CALL d.setActionActive(act_name_add,TRUE)
    END IF
    IF sys_str_find("1,2,3,4,5,6,7,9,B,C,D,E,F,H,I,J",t_type) THEN
      CALL d.setActionActive(act_name_qry,TRUE)
    END IF
  ELSE
    #add
    IF sys_str_find("1,2,B,E,H,I,J",t_type) THEN
      IF s_priv[1,1] = "Y" THEN
        CALL d.setActionActive(act_name_add,TRUE)
      ELSE 
        CALL d.setActionActive(act_name_add,FALSE)
      END IF
    END IF
    #query
    IF sys_str_find("1,2,3,4,5,6,7,9,B,C,D,E,F,H,I,J",t_type) THEN
      IF s_priv[4,4] = "Y" THEN
        CALL d.setActionActive(act_name_qry,TRUE)
      ELSE 
        CALL d.setActionActive(act_name_qry,FALSE)
      END IF
    ELSE 
      IF sys_str_find("1,2,3,4,5,6,7,9,B,C,D,E,F,H,I,J",t_type) THEN
        CALL d.setActionActive(act_name_qry,FALSE)
      END IF
    END IF
  END IF
  #上下筆
  IF sys_str_find("2,3,5,9,B,C,D,E,F,H,I",t_type) THEN
    CALL d.setActionActive(act_name_next,FALSE)
    CALL d.setActionActive(act_name_prev,FALSE)
  END IF
  #第一,最後筆
  IF sys_str_find("E,F",t_type) THEN
    CALL d.setActionActive(act_name_first,FALSE)
    CALL d.setActionActive(act_name_last,FALSE)
  END IF
  #刪除
  IF sys_str_find("1,2,3,4,5,E,H",t_type) THEN
    CALL d.setActionActive(act_name_del,FALSE)
  END IF
  #修改
  IF sys_str_find("1,2,3,4,5,6,9,B,C,E,J",t_type) THEN
    CALL d.setActionActive(act_name_upd,FALSE)
  END IF
  
  CALL d.setActionActive(act_name_help,TRUE)
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_set_act1 error!!", "stop")
 END TRY  
  
END FUNCTION

#------------------------------------------------------------------------
# set刪修動作權限(查詢後才做設定)
#------------------------------------------------------------------------
FUNCTION sys_set_act2(d,channel,s_priv,t_type)
DEFINE d ui.Dialog
DEFINE channel varchar(20),
       s_priv char(7),
       t_type char(1),
       act_name_del,act_name_upd,act_name_next,act_name_prev varchar(20),
       act_name_first,act_name_last varchar(20)

 TRY 
  LET act_name_del = channel || "_del"
  LET act_name_upd = channel || "_upd"
  LET act_name_next = channel || "_next"
  LET act_name_prev = channel || "_prev"
  LET act_name_first = channel || "_first"
  LET act_name_last = channel || "_last"
 
#新增  1,2,B,E,H,I,J
#修改  1,2,3,4,5,6,9,B,C,E,J
#刪除  1,2,3,4,5,E,H
#查詢  1,2,3,4,5,6,7,9,B,C,D,E,F,H,I,J
#上下筆 2,3,5,9,B,C,D,E,F,H,I
#第一筆,最後筆 E,F
 
  #系統維護者則權限全開
  IF s_priv[7,7] = "S" THEN
    IF sys_str_find("1,2,3,4,5,E,H",t_type) THEN
      CALL d.setActionActive(act_name_del,TRUE)
    END IF
    IF sys_str_find("1,2,3,4,5,6,9,B,C,J",t_type) THEN
      CALL d.setActionActive(act_name_upd,TRUE)
    END IF
    IF sys_str_find("2,3,5,9,B,C,D,E,F,H,I",t_type) THEN
      CALL d.setActionActive(act_name_next,TRUE)
      CALL d.setActionActive(act_name_prev,TRUE)
    END IF
    IF sys_str_find("E,F",t_type) THEN
      CALL d.setActionActive(act_name_first,TRUE)
      CALL d.setActionActive(act_name_last,TRUE)
    END IF
  ELSE
    #delete
    IF sys_str_find("1,2,3,4,5,E,H",t_type) THEN
       IF s_priv[2,2] = "Y" THEN 
          CALL d.setActionActive(act_name_del,TRUE)
       ELSE
          CALL d.setActionActive(act_name_del,FALSE) 
       END IF 
    END IF
    #update
    IF sys_str_find("1,2,3,4,5,6,9,B,C,E,J",t_type) THEN 
       IF s_priv[3,3] = "Y" THEN
         CALL d.setActionActive(act_name_upd,TRUE)
       ELSE
         CALL d.setActionActive(act_name_upd,FALSE)  
       END IF 
    END IF
    #前一筆,後一筆
    IF sys_str_find("2,3,5,9,B,C,D,E,F,H,I",t_type) THEN
      CALL d.setActionActive(act_name_next,TRUE)
      CALL d.setActionActive(act_name_prev,TRUE)
    END IF
    IF sys_str_find("E,F",t_type) THEN
      CALL d.setActionActive(act_name_first,TRUE)
      CALL d.setActionActive(act_name_last,TRUE)
    END IF
  END IF
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_set_act2 error!!", "stop")
 END TRY  
 
END FUNCTION

#------------------------------------------------------------------------
# set prt及exe動作權限
#------------------------------------------------------------------------
FUNCTION sys_setact_oth(d,s_priv,act_name,act_type)

DEFINE d ui.Dialog
DEFINE act_name varchar(20),
       s_priv char(7),
       act_type char(3),
       act_yn char(1)

 TRY 
  CASE act_type
   WHEN "prt"
     LET act_yn =  s_priv[5,5] 
   WHEN "exe"
     LET act_yn =  s_priv[6,6] 
  END CASE

  #系統維護者則權限全開
  IF s_priv[7,7] = "S" THEN
    CALL d.setActionActive(act_name,TRUE)
  ELSE
    IF act_yn = "Y" THEN
      CALL d.setActionActive(act_name,TRUE)
    ELSE
      CALL d.setActionActive(act_name,FALSE)
    END IF
  END IF
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_setact_oth error!!", "stop")
 END TRY  
 
END FUNCTION
#------------------------------------------------------------------------
# check prt及exe動作權限
#------------------------------------------------------------------------
FUNCTION sys_chk_priv(s_priv,act_type)

DEFINE d ui.Dialog
DEFINE s_priv char(7),
       act_type char(3),
       act_yn char(1)

 TRY 
  CASE act_type
   WHEN "prt"
     LET act_yn =  s_priv[5,5] 
   WHEN "exe"
     LET act_yn =  s_priv[6,6] 
  END CASE
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_chk_priv error!!", "stop")
 END TRY  
 
 RETURN act_yn 
END FUNCTION 
#------------------------------------------------------------------------
#傳入字串P_STR及找尋字元t_type，回傳FIND OR NOTFOUND
#------------------------------------------------------------------------
FUNCTION sys_str_find(p_str,t_type)
DEFINE p_str string,
       t_type varchar(3),
       pos SMALLINT,
       yn BOOLEAN

 TRY 
  LET pos = p_str.getIndexOf(t_type,1)
  IF pos <> 0 THEN
    LET yn = TRUE
  ELSE
    LET yn = FALSE
  END IF
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_str_find error!!", "stop")
 END TRY  
 
 RETURN yn

END FUNCTION
#------------------------------------------------------------------------
#傳入字串P_STR及找尋字元t_type，回傳FIND OR NOTFOUND
#------------------------------------------------------------------------
FUNCTION sys_str_find1(p_str,t_type)
DEFINE p_str string,
       t_type varchar(3),
       pos SMALLINT,
       yn BOOLEAN

 TRY 
  LET pos = p_str.getIndexOf(t_type,1)
  IF pos <> 0 THEN
    LET yn = TRUE
  ELSE
    LET yn = FALSE
  END IF
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_str_find1 error!!", "stop")
 END TRY  
 
 RETURN pos

END FUNCTION
#------------------------------------------------------------------------
# 傳回西元系統日期
#------------------------------------------------------------------------
FUNCTION sys_date()
DEFINE yy,mm,dd,sys_date varchar(8)

 TRY 
  LET yy = year(today)
  LET mm = month(today)
  LET dd = day(today)

  IF length(mm) = 1 THEN
     LET mm = "0" || mm
  END IF

  IF length(dd) = 1 THEN
     LET dd = "0" || dd
  END IF
  
  LET sys_date = yy || mm || dd
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_date error!!", "stop")
 END TRY  

 RETURN sys_date
  
END FUNCTION

#------------------------------------------------------------------------
# 傳回西元系統時間
#------------------------------------------------------------------------
FUNCTION sys_time()
DEFINE sys_time varchar(6),
       t_time varchar(10),
       hh,mm,ss varchar(2)

 TRY 
  LET t_time = TIME ( CURRENT )

  LET hh = t_time[1,2]
  LET mm = t_time[4,5]
  LET ss = t_time[7,8]
  LET sys_time = hh || mm || ss
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_time error!!", "stop")
 END TRY  
 
 RETURN sys_time

END FUNCTION

#-----------------------------------------------------------------------  
#顯示單位名稱
#-----------------------------------------------------------------------  
FUNCTION sys_show_depname(dept_no)
DEFINE dept_no varchar(10),
       t_dept_name varchar(30)

 TRY 
  SELECT dept_name INTO t_dept_name 
  FROM pamf070m
  WHERE deptno = dept_no
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_show_depname!!", "stop")
 END TRY  

 RETURN t_dept_name

END FUNCTION

#------------------------------------------------------------------------
# 得標廠商短名 頁面
#------------------------------------------------------------------------
FUNCTION sys_show_vend_no(v_no)
DEFINE v_no varchar(5),
       s_name varchar(30) 

 TRY 
   SELECT short_name INTO s_name
   FROM pura010m
   WHERE vend_no = v_no
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_show_vend_no!!", "stop")
 END TRY  
 
 RETURN s_name
 
END FUNCTION

#------------------------------------------------------------------------
# 得標廠商全名 頁面
#------------------------------------------------------------------------
FUNCTION sys_show_vend_no_all(v_no)
DEFINE v_no varchar(5),
       s_name varchar(120) 

 TRY 
    SELECT name INTO s_name
    FROM pura010m
    WHERE vend_no = v_no
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_show_vend_no_all error!!", "stop")
 END TRY  
 
 RETURN s_name
 
END FUNCTION

#------------------------------------------------------------------------
# 幣別顯示頁面 
#------------------------------------------------------------------------
FUNCTION sys_show_dollar_sign(t_dollar_sign)
DEFINE t_dollar_sign varchar(10),
       t_code_desc varchar(30)

 TRY 
   SELECT code_descr INTO t_code_desc
   FROM puru010m
   WHERE code_type = '04'  AND code_item = t_dollar_sign
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Call Function sys_show_dollar_sign error!!", "stop")
 END TRY    
 
 RETURN t_code_desc
END FUNCTION

#------------------------------------------------------------------------
# sys dialog
# argument remark(form name,prompt string)
# return ans & input string
#------------------------------------------------------------------------
FUNCTION sys_dialog(t_form_txt,t_msg_str)
DEFINE t_form_txt,t_msg_str varchar(100),
       t_input_txt varchar(30),
       t_ans BOOLEAN,
       f ui.Form,
       w ui.Window,
       doc om.DomDocument

 TRY 
  CALL ui.Interface.loadStyles(g_style)
  OPEN WINDOW sys_dialog WITH FORM "sys_dialog" ATTRIBUTES (STYLE='dialog')
  CURRENT WINDOW IS sys_dialog

  LET doc = ui.Interface.getdocument()
  LET w = ui.Window.getCurrent()
  LET f = w.getForm()
  #form名稱
  CALL w.setText(t_form_txt)
  CALL f.setElementText("msg_txt",t_msg_str)
  CALL ui.Interface.setText(t_form_txt)

  DIALOG ATTRIBUTE(UNBUFFERED)
     INPUT t_input_txt FROM sys_dialog.input_txt
     END INPUT
 
    { ON ACTION act_y
        LET t_ans = TRUE
        EXIT DIALOG

     ON ACTION act_n
        LET t_ans = FALSE
        EXIT DIALOG}
     COMMAND "act_Y"
        LET t_ans = TRUE
        EXIT DIALOG

     COMMAND "act_n"
        LET t_ans = FALSE
        EXIT DIALOG
     
  END DIALOG
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_dialog error!!", "stop")
 END TRY 
 
 RETURN t_input_txt,t_ans
 
END FUNCTION
#------------------------------------------------------------------------
# sys dialog(input 3 parameter)
# argument remark(form name,prompt string1,prompt string2)
# return ans & input string
#------------------------------------------------------------------------
FUNCTION sys_dialog_2(t_form_txt,t_msg_str1,t_msg_str2)
DEFINE t_form_txt,t_msg_str1,t_msg_str2 varchar(50),
       t_input_txt1,t_input_txt2 varchar(30),
       t_ans BOOLEAN,
       f ui.Form,
       w ui.Window,
       doc om.DomDocument

 TRY 
  CALL ui.Interface.loadStyles(g_style)  
  OPEN WINDOW sys_dialog_2 WITH FORM "sys_dialog_2" ATTRIBUTES (STYLE='dialog')
  CURRENT WINDOW IS sys_dialog_2

  LET doc = ui.Interface.getdocument()
  LET w = ui.Window.getCurrent()
  LET f = w.getForm()
  #form名稱
  CALL w.setText(t_form_txt)
  CALL f.setElementText("msg_txt1",t_msg_str1)
  CALL f.setElementText("msg_txt2",t_msg_str2)
  CALL ui.Interface.setText(t_form_txt)

  DIALOG ATTRIBUTE(UNBUFFERED)
     INPUT t_input_txt1,t_input_txt2 FROM sys_dialog_2.input_txt1,sys_dialog_2.input_txt2
     END INPUT
 
     COMMAND "act_Y"
        LET t_ans = TRUE
        EXIT DIALOG

     COMMAND "act_n"
        LET t_ans = FALSE
        EXIT DIALOG
     
  END DIALOG
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_dialog_2 error!!", "stop")
 END TRY 

  RETURN t_input_txt1,t_input_txt2,t_ans
  
END FUNCTION
#------------------------------------------------------------------------
# sys dialog(input 3 parameter)
# argument remark(form name,prompt string,show text string)
#------------------------------------------------------------------------
FUNCTION sys_dialog3(t_form_txt,t_msg_str,t_msg_str2)
DEFINE t_form_txt,t_msg_str,t_msg_str2 varchar(100),
       t_input_txt varchar(30),
       t_ans BOOLEAN,
       f ui.Form,
       w ui.Window,
       doc om.DomDocument

 TRY 
  CALL ui.Interface.loadStyles(g_style)
  OPEN WINDOW sys_dialog WITH FORM "sys_dialog" ATTRIBUTES (STYLE='dialog')
  CURRENT WINDOW IS sys_dialog

  LET doc = ui.Interface.getdocument()
  LET w = ui.Window.getCurrent()
  LET f = w.getForm()
  #form名稱
  CALL w.setText(t_form_txt)
  CALL f.setElementText("msg_txt",t_msg_str)
  CALL f.setElementText("line",t_msg_str2)
  CALL ui.Interface.setText(t_form_txt)

  DIALOG ATTRIBUTE(UNBUFFERED)
     INPUT t_input_txt FROM sys_dialog.input_txt
     END INPUT
 
     ON ACTION act_y
        LET t_ans = TRUE
        EXIT DIALOG

     ON ACTION act_n
        LET t_ans = FALSE
        EXIT DIALOG
     
  END DIALOG
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_dialog3 error!!", "stop")
 END TRY 

 RETURN t_input_txt,t_ans
END FUNCTION
#------------------------------------------------------------------------
# info dialog(input 2 parameter)
# form text & message string
#------------------------------------------------------------------------
FUNCTION sys_execute_ck(t_form_txt,t_msg_str)
DEFINE t_form_txt,t_msg_str varchar(100),
       t_ans BOOLEAN,
       f ui.Form,
       w ui.Window,
       doc om.DomDocument

 TRY 
  CALL ui.Interface.loadStyles(g_style)
  OPEN WINDOW sys_execute_ck WITH FORM "sys_execute_ck" ATTRIBUTES (STYLE='dialog')
  CURRENT WINDOW IS sys_execute_ck

  LET doc = ui.Interface.getdocument()
  LET w = ui.Window.getCurrent()
  LET f = w.getForm()
  
  #form名稱
  CALL w.setText(t_form_txt)
  CALL f.setElementText("msg_txt",t_msg_str)
  CALL ui.Interface.setText(t_form_txt)

  MENU 
     ON ACTION act_y
        LET t_ans = TRUE
        EXIT MENU

     ON ACTION act_n
        LET t_ans = FALSE
        EXIT MENU
  END MENU    
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_execute_ck error!!", "stop")
 END TRY 
 
 RETURN t_ans
END FUNCTION
#------------------------------------------------------------------------
#window message
#------------------------------------------------------------------------
FUNCTION sys_win_msg(t_form_txt,t_msg_str)
DEFINE t_form_txt,t_msg_str varchar(100),
       t_ans BOOLEAN,
       f ui.Form,
       w ui.Window,
       doc om.DomDocument

 TRY 
  CALL ui.Interface.loadStyles(g_style)
  OPEN WINDOW sys_win_msg WITH FORM "sys_win_msg" ATTRIBUTES (STYLE='dialog')
  CURRENT WINDOW IS sys_win_msg

  LET doc = ui.Interface.getdocument()
  LET w = ui.Window.getCurrent()
  LET f = w.getForm()
  #form名稱
  CALL w.setText(t_form_txt)
  #info
  CALL f.setElementText("msg_txt",t_msg_str)
  CALL ui.Interface.setText(t_form_txt)

  MENU 
     ON ACTION act_y
        LET t_ans = TRUE
        EXIT MENU
  END MENU    
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_win_msg error!!", "stop")
 END TRY 
 RETURN t_ans
END FUNCTION
#------------------------------------------------------------------------
# date check
#------------------------------------------------------------------------
FUNCTION sys_date_chk(t_date)
DEFINE t_date  VARCHAR(8)
DEFINE t_date1 varchar(23)
DEFINE t_date_yn BOOLEAN 

 TRY 
   IF length(t_date) = 4 THEN
     LET t_date = t_date || "0101"
   ELSE IF length(t_date) = 6 THEN
     LET t_date = t_date || "01"
   END IF 
   END IF
   
   WHENEVER ERROR CONTINUE 
     SELECT TO_DATE(t_date,'yyyymmdd') INTO t_date1 FROM DUAL
   WHENEVER ERROR STOP
   
   #CALL FGL_WINMESSAGE( LSTR("SYS0019"),SQLCA.sqlcode, "information")

   IF SQLCA.sqlcode = 0 AND t_date1 IS NOT NULL THEN 
     LET t_date_yn = TRUE 
   ELSE 
     LET t_date_yn = FALSE 
   END IF 


   #新增年度判斷
   IF t_date[1,4] < '1911' OR t_date[1,4] > '2100' THEN 
     LET t_date_yn = FALSE 
   END IF 
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_date_chk error!!", "stop")
 END TRY 
 
 RETURN t_date_yn
END FUNCTION 
#------------------------------------------------------------------------
# last day
# pass 2 (yyyymmdd,number(add month))
# return 2 (turn or false,last date(yyyymmdd))
# ex -> passing ('20140310',2) ==> return (true,'20140531')
#------------------------------------------------------------------------
FUNCTION sys_last_day(t_date,t_int)
DEFINE t_date varchar(8) 
DEFINE t_int INTEGER
DEFINE t_date_yn BOOLEAN
DEFINE t_nextdate varchar(8)
 
 TRY 
    SELECT TO_DATE(t_date,'yyyymmdd') INTO t_nextdate FROM DUAL   
   
    IF SQLCA.sqlcode = 0 AND t_nextdate IS NOT NULL THEN
 
     LET t_date = t_date[1,6]||'01'
    
       LET t_int = t_int +1
       select to_char(add_months(to_date(t_date,'yyyymmdd'),t_int) - 1,'yyyymmdd') 
         INTO t_nextdate from dual
       LET t_date_yn=TRUE
        
    ELSE
       LET t_date_yn = FALSE
       LET t_nextdate = ' '
    END IF
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_last_day error!!", "stop")
 END TRY  
 
 RETURN t_date_yn,t_nextdate
END FUNCTION

#------------------------------------------------------------------------
# date add
# pass 3 (yyyymmdd ; type=y,m,d ; number)
# return 2 (turn or false ; yyyymmdd)
# ex -> passing ('20140310',m,2) ==> return(true,'20140510')
#       passing ('20140310',d,6) ==> return(true,'20140316')
#       passing ('20140310',y,2) ==> return(true,'20160310')
#------------------------------------------------------------------------
FUNCTION sys_date_add(t_date,t_type,t_int)
DEFINE t_date  VARCHAR(8)
DEFINE t_nextdate varchar(23)
DEFINE t_date_yn BOOLEAN 
DEFINE t_type varchar(1)
DEFINE t_int INTEGER 

 TRY 

    SELECT TO_DATE(t_date,'yyyymmdd') INTO t_nextdate FROM DUAL   
    IF SQLCA.sqlcode = 0 AND t_nextdate IS NOT NULL THEN 
   
         IF t_type ='d' THEN 
         select to_char(to_date(t_date,'yyyymmdd')+t_int,'yyyymmdd') 
               INTO t_nextdate from dual 
         END IF
         
         IF t_type ="m" THEN
           select to_char(add_months(to_date(t_date,'yyyymmdd'),t_int),'yyyymmdd') 
               INTO t_nextdate from dual     
         END IF
    #    書上是用day*365算一年,但若遇到閏二月,天數會跟想像中的有差,故改為用月*12
         IF t_type ="y" THEN
           select to_char(add_months(to_date(t_date,'yyyymmdd'),t_int*12),'yyyymmdd') 
               INTO t_nextdate from dual     
         END IF
         LET t_date_yn=TRUE
    ELSE 
       LET t_date_yn = FALSE
       LET t_nextdate = ' '
    END IF     
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_date_add error!!", "stop")
 END TRY  
 
 RETURN t_date_yn,t_nextdate
END FUNCTION 
#------------------------------------------------------------------------
# date count (date1 - date2)
# 2 parameter(date1,date2),return result number 
# ex -> passing ('20140320','20140309') ==> return 11
#------------------------------------------------------------------------
FUNCTION sys_date_cnt(t_date1,t_date2)
DEFINE t_date1,t_date2 varchar(8),
       t_cnt INTEGER 

 TRY 
   SELECT to_date(t_date1,'yyyymmdd') - to_date(t_date2,'yyyymmdd') 
   INTO t_cnt
   from dual
 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_date_cnt error!!", "stop")
 END TRY  
 
 RETURN t_cnt

END FUNCTION 
#-----------------------------------------------------------------------  
#傳回檔案名稱的副檔名(.xxx)及不含副檔名的檔名
#----------------------------------------------------------------------- 
FUNCTION sys_file_type(filename)
DEFINE filename varchar(120),
       s_length,s_pos SMALLINT,
       buf base.StringBuffer,
       s_filetype varchar(5),
       s_filename varchar(120)

 TRY 
     LET buf = base.StringBuffer.create()
     CALL buf.append(filename)
     LET s_pos = buf.getIndexOf(".",1)
      #CALL FGL_WINMESSAGE( "提示", "s_pos="||s_pos, "information")
     LET s_length = length(filename)
      #CALL FGL_WINMESSAGE( "提示", "s_len="||s_length, "information")
     LET s_filetype = buf.subString(s_pos,s_length)
     LET s_filename = buf.subString(1,s_pos-1)
  CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_file_type error!!", "stop")
  END TRY  
 
 RETURN s_filetype,s_filename
END FUNCTION
#-----------------------------------------------------------------------  
#chec flag
#----------------------------------------------------------------------- 
FUNCTION sys_chk_flag(t_user_id,t_sys_no,t_company)
DEFINE t_flag varchar(1),
       t_sys_no varchar(4),
       t_user_id varchar(8),
       t_company varchar(2)

 TRY 
     SET CONNECTION "mis"
     SELECT log_flag
     INTO t_flag 
     FROM sys_log
     WHERE user_id = t_user_id AND sys_no = t_sys_no AND company = t_company
  CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_chk_flag error!!", "stop")
  END TRY  
  
 RETURN t_flag
END FUNCTION 
#-----------------------------------------------------------------------  
#set flag on 
#----------------------------------------------------------------------- 
FUNCTION sys_flag_on(t_user_id,t_sys_no,t_company)
DEFINE t_res SMALLINT,
       t_sys_no varchar(4),
       t_user_id varchar(8),
       t_company varchar(2)

 TRY 
     SET CONNECTION "mis"

     #check exist or not 
     SELECT * FROM sys_log
     WHERE user_id = t_user_id AND sys_no = t_sys_no AND company = t_company
     IF sqlca.sqlcode = 0 THEN 
         UPDATE sys_log
         SET log_flag = 'Y'
         WHERE user_id = t_user_id AND sys_no = t_sys_no AND company = t_company
     ELSE
         INSERT INTO sys_log
         (user_id,sys_no,company,log_flag)
         VALUES
         (t_user_id,t_sys_no,t_company,'Y')
     END IF
     
     LET t_res = sqlca.sqlcode
  CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_flag_on error!!", "stop")
  END TRY  
  
 RETURN t_res
END FUNCTION 
#-----------------------------------------------------------------------  
#set flag off 
#----------------------------------------------------------------------- 
FUNCTION sys_flag_off(t_user_id,t_sys_no,t_company)
DEFINE t_res SMALLINT,
       t_sys_no varchar(4),
       t_user_id varchar(8),
       t_company varchar(2)

 TRY 
     SET CONNECTION "mis"

     UPDATE sys_log
     SET log_flag = 'N'
     WHERE user_id = t_user_id AND sys_no = t_sys_no AND company = t_company

     LET t_res = sqlca.sqlcode
  CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_flag_off error!!", "stop")
  END TRY  
  
 RETURN t_res
END FUNCTION 

#-----------------------------------------------------------------------  
#set program flag on 
#----------------------------------------------------------------------- 
FUNCTION sys_prg_flag_on(t_user_id,t_prg_no,t_company)
DEFINE t_prg_no varchar(20),
       t_user_id varchar(8),
       t_company varchar(2)

 TRY 
     SET CONNECTION "mis"

     #check exist or not 
     SELECT * FROM sys_prg_log
     WHERE user_id = t_user_id AND prg_no = t_prg_no AND company = t_company 
           
     IF sqlca.sqlcode = 0 THEN 
         UPDATE sys_prg_log
         SET log_flag = 'Y'
         WHERE user_id = t_user_id AND prg_no = t_prg_no AND company = t_company
     ELSE
         INSERT INTO sys_prg_log
         (user_id,prg_no,company,log_flag)
         VALUES
         (t_user_id,t_prg_no,t_company,'Y')
     END IF
     
  CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_prog_flag_on error!!", "stop")
  END TRY  
  
END FUNCTION 

#-----------------------------------------------------------------------  
#set program flag off 
#----------------------------------------------------------------------- 
FUNCTION sys_prg_flag_off(t_user_id,t_prg_no,t_company)
DEFINE t_prg_no varchar(20),
       t_user_id varchar(8),
       t_company varchar(2)

 TRY 
     SET CONNECTION "mis"

     UPDATE sys_prg_log
     SET log_flag = 'N'
     WHERE user_id = t_user_id AND prg_no = t_prg_no AND company = t_company

  CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_flag_off error!!", "stop")
  END TRY  
  
END FUNCTION 
#-----------------------------------------------------------------------  
#system logout check
#----------------------------------------------------------------------- 
FUNCTION sys_logout_chk(t_sys_no,t_user_id)
DEFINE t_sys_no varchar(3),
       t_user_id varchar(10),
       t_res SMALLINT
       

 TRY 
   SET CONNECTION "mis"
 
   SELECT count(*) 
   INTO t_res
   FROM sys_prg_log  
   WHERE substr(prg_no,1,3) = t_sys_no AND log_flag = 'Y' AND user_id = t_user_id

 CATCH 
    CALL FGL_WINMESSAGE( lstr("SYS0020"), "Function sys_flag_off error!!", "stop")
 END TRY  
  
 RETURN t_res
END FUNCTION 





