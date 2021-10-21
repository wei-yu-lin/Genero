GLOBALS "../../sys/library/sys_globals.4gl"

#--------------------------------------------------------------
#主程式
#--------------------------------------------------------------
MAIN
#    CONNECT TO "rdbtqc36" AS "TQC"

    CLOSE WINDOW SCREEN
    CALL ui.Interface.loadStyles("sys_style")

    OPEN WINDOW tqc_menu WITH FORM "tqc_menu"
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
    CALL f.loadtopmenu("tqc_topmenu")
    CALL w.setText("TQC冷軋品保")

    MENU ATTRIBUTES(STYLE = "Window.naked")     
        ON ACTION mics060f
            RUN "fglrun TQCS010F" WITHOUT WAITING
        ON ACTION reload
            RUN "fglrun SYS_LOGIN" WITHOUT WAITING
            EXIT MENU
        ON ACTION EXIT
            EXIT MENU
    END MENU

    CLOSE WINDOW tqc_menu

END MAIN
