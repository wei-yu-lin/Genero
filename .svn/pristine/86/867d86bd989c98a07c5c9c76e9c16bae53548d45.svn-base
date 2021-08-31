GLOBALS "../../sys/library/sys_globals.4gl"

DEFINE flag  SMALLINT 
DEFINE t_res SMALLINT 
#--------------------------------------------------------------
#主程式
#--------------------------------------------------------------
MAIN 
    CONNECT TO "rdbmic36" AS "MIC"
     
    #將user_id存入公用變數
    CALL fgl_getenv("g_user_id") RETURNING g_user_id
    CALL fgl_getenv("g_sys_no") RETURNING g_sys_no
    CALL fgl_getenv("g_company") RETURNING g_company
    CALL fgl_getenv("g_style") RETURNING g_style

     CLOSE WINDOW SCREEN
     CALL ui.Interface.loadStyles("sys_style")
     OPEN WINDOW mic_menu WITH FORM "mic_menu" 
   
     LET doc = ui.Interface.getdocument()
     LET w = ui.Window.getCurrent()
     LET f = w.getForm()
     CALL f.loadtopmenu("mic_topmenu")
     CALL ui.Interface.setText("MIC(冶金規範系統)")   
   MENU ATTRIBUTES (STYLE="Window.naked")

#******************************************************************
#基本資料維護作業[ADDMENU ]
#******************************************************************
        ON ACTION mics060f
            RUN "fglrun MICS060F" WITHOUT WAITING

        ON ACTION micm012f
            RUN "fglrun MICM012F" WITHOUT WAITING            

        ON ACTION mict010f
            RUN "fglrun MICT010F" WITHOUT WAITING
            
        ON ACTION reload
            LET flag = 1
            EXIT MENU
                        
        ON ACTION EXIT
            EXIT MENU
            
    END MENU

    CLOSE WINDOW mic_menu
    If(flag = 1) THEN
        RUN "fglrun SYS_LOGIN" WITHOUT WAITING
    END IF 

END MAIN 
#END FUNCTION