IMPORT FGL fgldialog
IMPORT FGL sys_menu 

SCHEMA yud221

DEFINE t_uid varchar(10),
       t_pwd varchar(15),
       t_station varchar(3),
       s_name varchar(20),
       s_type varchar(1),
       f_yn varchar(1),
       t_style varchar(30)

DEFINE list_count SMALLINT,
       cmd STRING,
       prog_name varchar(30)
#----------------------------------------------------------------------
#login畫面     
#----------------------------------------------------------------------
FUNCTION sys_login() 
DEFINE sys_list ui.ComboBox,
       sys_list_sys_no LIKE secsys.sys_no,
       sys_list_sys_name LIKE secsys.sys_name,
       t_u_type,t_flag char(1),
       t_u_pwd varchar(10),
       mark,t_res SMALLINT,
       sql_txt STRING
DEFINE cb ui.ComboBox

    SET CONNECTION "MIS"

    LET t_station = ""

    OPEN WINDOW sys_login WITH FORM "sys_login"
    CALL ui.Interface.loadStyles("sys_style")
     
    LABEL re_login:
    LET mark = 0 
    DIALOG ATTRIBUTE(UNBUFFERED)

        INPUT sys_list_sys_name,t_uid,t_pwd
        FROM get_sys.sys_name,user_id,password
            BEFORE INPUT
                #DEFINE sys_list ui.ComboBox 
                LET sys_list = ui.ComboBox.forName("get_sys.sys_name") 
                CALL sys_list.clear()

                DECLARE get_sname CURSOR FOR 
                SELECT sys_no,sys_name FROM secsys ORDER BY sys_no
                LET list_count = 1

                FOREACH get_sname INTO sys_list_sys_no,sys_list_sys_name
                    CALL sys_list.addItem(sys_list_sys_no,sys_list_sys_name)
                    LET list_count = list_count + 1
                    DISPLAY "sys_list_sys_name",sys_list_sys_name
                END FOREACH
              
           BEFORE FIELD password
             CALL DIALOG.setActionActive("ok",TRUE)
           
        END INPUT

        BEFORE DIALOG
            CALL DIALOG.setActionActive("ok",FALSE)
            CALL DIALOG.setActionActive("bye",TRUE)
 
        ON ACTION ok
            LET mark = 1
            LET t_station = sys_list_sys_name
            SELECT u_type,password
            INTO t_u_type,t_u_pwd
            FROM secuser
            WHERE user_id = t_uid 

            IF t_station MATCHES "[A-Z]??" THEN 
                IF t_pwd <> t_u_pwd OR SQLCA.SQLCODE = 100 THEN 
                    CALL FGL_WINMESSAGE("警示","帳號密碼錯誤,請確認", "stop")
                    GOTO re_login
                END IF
                EXIT DIALOG
            ELSE
                CALL FGL_WINMESSAGE("警示","請選擇系統", "stop")
                GOTO re_login
            END IF 

        ON ACTION bye
            LET mark = 2
            EXIT DIALOG

        #密碼變更
        ON ACTION chg_pwd
            IF length(t_uid) = 0 OR length(t_pwd) = 0 THEN 
                CALL FGL_WINMESSAGE("警示","請先輸入帳號密碼!", "stop")
            ELSE 
                SELECT * FROM secuser 
                WHERE user_id = t_uid AND password = t_pwd 
                IF sqlca.sqlcode <> 0 THEN 
                    CALL FGL_WINMESSAGE("警示","帳號密碼錯誤,請確認", "stop")
                ELSE
                    CALL sys_chg_pwd()
                    LET t_pwd=""
                    DISPLAY t_pwd TO sys_login.password
                END IF 
            END IF 

    END DIALOG

    IF mark = 0 THEN
        GOTO re_login
    ELSE IF mark = 1 THEN 

        CLOSE WINDOW sys_login
        CALL fgl_setenv("g_user_id",t_uid)
        CALL fgl_setenv("g_sys_no",t_station)
        CALL fgl_setenv("g_company",'LD')
        CALL fgl_setenv("g_style",t_style)

        IF t_station = "SYS" THEN 
            CALL sys_mainmenu()
        ELSE 
            DISPLAY "station ==" || t_station
            LET prog_name = t_station || "_MAIN"
        END IF 

        #LET cmd = "fglrun " || prog_name ," '",s_uid,"'" ," '","bbbb","'" ," '","cccc","'" ,123
        LET cmd = "fglrun " || prog_name 
        #LET cmd = "fglrun EDU_MAIN" 
        RUN cmd #WITHOUT WAITING
    
    END IF
    END IF 
  
END FUNCTION
#----------------------------------------------------------------------
#change password  
#----------------------------------------------------------------------
FUNCTION sys_chg_pwd()
DEFINE t_new_pwd,t_new_pwd_chk varchar(10),
       t_mark SMALLINT 

    LET t_mark = 0
    OPEN WINDOW sys_chg_pwd WITH FORM "sys_chg_pwd" ATTRIBUTES (STYLE='dialog')
    CURRENT WINDOW IS sys_chg_pwd
    DIALOG ATTRIBUTE(UNBUFFERED)
    
        INPUT t_new_pwd,t_new_pwd_chk
        FROM  r_chgpwd.new_pwd,r_chgpwd.new_pwd_chk 

            ON ACTION ACCEPT 
                IF t_station MATCHES "[A-Z]??" THEN 
                    IF t_new_pwd <> t_new_pwd_chk THEN 
                         #"SYS0120"="兩次輸入密碼不同,請確認!"
                         CALL FGL_WINMESSAGE( LSTR("SYS0020"), LSTR("SYS0120"), "stop") 
                         NEXT FIELD new_pwd
                     ELSE IF length(t_new_pwd) = 0 THEN 
                         #"SYS0118"="請輸入新密碼"
                         CALL FGL_WINMESSAGE( LSTR("SYS0020"), LSTR("SYS0118"), "stop") 
                         NEXT FIELD new_pwd
                     ELSE IF length(t_new_pwd_chk) = 0 THEN 
                         #"SYS0119"="再次輸入新密碼確認"
                         CALL FGL_WINMESSAGE( LSTR("SYS0020"), LSTR("SYS0119"), "stop") 
                         NEXT FIELD new_pwd_chk
                     ELSE 
                       LET t_mark = 1
                       EXIT DIALOG 
                     END IF   
                     END IF 
                     END IF 
                ELSE

                END IF 

            ON ACTION CANCEL
                LET t_mark = 0
                EXIT DIALOG 
        END INPUT
        
    END DIALOG 
    CLOSE WINDOW sys_chg_pwd

    IF t_mark = 1 THEN 
        UPDATE secuser
        SET password = t_new_pwd
        WHERE user_id = t_uid
        IF sqlca.sqlcode = 0 THEN
            CALL FGL_WINMESSAGE("提示", "密碼變更成功!", "information")  
        END IF 
    END IF 

 
END FUNCTION 
