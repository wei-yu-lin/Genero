GLOBALS "../../sys/sys_globals.4gl"

DEFINE flag  SMALLINT 
DEFINE t_res SMALLINT 
#--------------------------------------------------------------
#�D�{��
#--------------------------------------------------------------
MAIN 
    #CONNECT TO "rdbmic36" AS "MIC"
     
    #�Nuser_id�s�J�����ܼ�
    CALL fgl_getenv("g_user_id") RETURNING g_user_id
    CALL fgl_getenv("g_sys_no") RETURNING g_sys_no
    CALL fgl_getenv("g_company") RETURNING g_company
    CALL fgl_getenv("g_style") RETURNING g_style

     CLOSE WINDOW SCREEN
     CALL ui.Interface.loadStyles("sys_style")
     OPEN WINDOW pcm_menu WITH FORM "pcm_menu" 
   
     LET doc = ui.Interface.getdocument()
     LET w = ui.Window.getCurrent()
     LET f = w.getForm()
     CALL f.loadtopmenu("pcm_topmenu")
     CALL ui.Interface.setText("PCM(����W��)")   
   MENU ATTRIBUTES (STYLE="Window.naked")

#******************************************************************
#�򥻸�ƺ��@�@�~[ADDMENU ]
#******************************************************************
        ON ACTION pcms020f
            RUN "fglrun PCMS020F" WITHOUT WAITING

        ON ACTION reload
            LET flag = 1
            EXIT MENU
                        
        ON ACTION EXIT
            EXIT MENU
            
    END MENU

    CLOSE WINDOW pcm_menu
    If(flag = 1) THEN
        RUN "fglrun SYS_LOGIN" WITHOUT WAITING
    END IF 

END MAIN 
#END FUNCTION