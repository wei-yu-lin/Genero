#IMPORT FGL line_prod
IMPORT FGL fgldialog
IMPORT FGL CPSCR600

GLOBALS "../../sys/library/sys_globals.4gl"

#--------------------------------------------------------------
#主程式
#--------------------------------------------------------------
MAIN
    DEFINE s_client_ip CHAR(15)

     
    #將user_id存入公用變數
    CALL fgl_getenv("g_user_id") RETURNING g_user_id

    CLOSE WINDOW SCREEN

    CALL ui.Interface.loadStyles("cps_style")
    OPEN WINDOW cps_menu_w WITH FORM "cps_menu" ATTRIBUTE(STYLE = "menu")
    CALL ui.Window.getCurrent().getForm().loadTopMenu("cps_topmenu")
    
#******************************************************************
#冷軋產線選擇畫面 Dialog Module
#******************************************************************
    MENU
        #CRM6
        ON ACTION CPSCR6
            
            CALL CPSCR600.CPSCR600_func()
            
        #右上角關閉    
        ON ACTION CLOSE
            EXIT MENU
        #重新選擇系統
        ON ACTION reload
            RUN "fglrun sys_main" WITHOUT WAITING
            
            EXIT MENU
        #登出帳號
        ON ACTION logout
            LET s_client_ip = fgl_getenv("CLIENT_IP")
            CONNECT TO "yud221"
            UPDATE SECAUTOLOGIN
                SET AUTO_LOGIN = 'N'
                WHERE CLIENT_IP = s_client_ip
            RUN "fglrun sys_main" WITHOUT WAITING
            
            EXIT MENU
        #離開    
        ON ACTION EXIT
            EXIT MENU
    END MENU
END MAIN
