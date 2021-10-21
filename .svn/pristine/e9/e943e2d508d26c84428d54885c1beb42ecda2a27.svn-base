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

            #******************************************************************
#尺寸配料維護作業[APYM000M ]
#******************************************************************
        ON ACTION apym010f
            RUN "fglrun APYM010F" WITHOUT WAITING
        ON ACTION apym060f
            RUN "fglrun APYM060F" WITHOUT WAITING
        ON ACTION apym070f
            RUN "fglrun APYM070F" WITHOUT WAITING

#******************************************************************
#冶金規範維護作業[MICM000M ]
#******************************************************************
            
        ON ACTION micm012f
            RUN "fglrun MICM012F" WITHOUT WAITING            
        ON ACTION micm140f
            RUN "fglrun MICM140F" WITHOUT WAITING  
        ON ACTION micm150f
            RUN "fglrun MICM150F" WITHOUT WAITING 
        ON ACTION micm170f
            RUN "fglrun MICM170F" WITHOUT WAITING  
        ON ACTION micm180f
            RUN "fglrun MICM180F" WITHOUT WAITING  
        ON ACTION micm190f
            RUN "fglrun MICM190F" WITHOUT WAITING  
        ON ACTION micm200f
            RUN "fglrun MICM200F" WITHOUT WAITING  
        ON ACTION micm220f
            RUN "fglrun MICM220F" WITHOUT WAITING  
        ON ACTION micm250f
            RUN "fglrun MICM250F" WITHOUT WAITING  
        ON ACTION micm290f
            RUN "fglrun MICM290F" WITHOUT WAITING  
        ON ACTION micm310f
            RUN "fglrun MICM310F" WITHOUT WAITING           

#******************************************************************
#冶金規範異動作業[MICT000M ]
#******************************************************************  
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