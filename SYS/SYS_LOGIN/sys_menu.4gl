GLOBALS "../../sys/library/sys_globals.4gl"

FUNCTION sys_mainmenu()
    DEFINE flag INTEGER
    DEFINE t_res SMALLINT
    DEFINE f ui.Form
    DEFINE w ui.Window
    DEFINE doc om.DomDocument

    OPTIONS HELP FILE "help.iem"

    #將user_id存入公用變數
    CALL fgl_getenv("g_user_id") RETURNING g_user_id
    CALL fgl_getenv("g_sys_no") RETURNING g_sys_no
    CALL fgl_getenv("g_company") RETURNING g_company
    CALL fgl_getenv("g_style") RETURNING g_style

    OPEN WINDOW sys_mainmenu WITH FORM "sys_mainmenu"
    CALL ui.Interface.loadStyles(g_style)

    LET doc = ui.Interface.getdocument()
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
    #LET fn = f.getnode()
    CALL f.loadtopmenu("sys_topmenu")

    MENU ATTRIBUTES(STYLE = "Window.naked")

        #-----------------------------------------
        ON ACTION SYS_KIND_SET #topmenu中系統別設定
            RUN "fglrun SYS_KIND_SET " WITHOUT WAITING

            #-----------------------------------------
        ON ACTION SYS_PROG_SET #topmenu中系統程式設定
            RUN "fglrun SYS_PROG_SET " WITHOUT WAITING

            #----------------------------------------------------------------
        ON ACTION sys_priv_set #topmenu中user程式授權
            RUN "fglrun SYS_PRIV_SET " WITHOUT WAITING

            #----------------------------------------------------------------
        ON ACTION sys_user_set #topmenu中使用者帳號維護作業
            RUN "fglrun SYS_USER_SET " WITHOUT WAITING

            #-----------------------------------------
        ON ACTION SYS_STR_SET #topmenu中語系設定
            RUN "fglrun SYS_STR_SET " WITHOUT WAITING

            #----------------------------------------------------------------
        ON ACTION EXIT
            CALL sys_logout_chk(g_sys_no, g_user_id) RETURNING t_res

            IF t_res > 0 THEN
                #"SYS0148"="系統尚有未離開之作業,請全部關閉後再行登出!"
                CALL FGL_WINMESSAGE(LSTR("SYS0020"), LSTR("SYS0148"), "stop")
            ELSE
                #離開系統將log_flag還原為'N'
                CALL sys_flag_off(
                    g_user_id, g_sys_no, g_company)
                    RETURNING t_res
                IF t_res <> 0 THEN
                    #"SYS0147"="系統登入碼寫入有誤!"
                    CALL FGL_WINMESSAGE(
                        LSTR("SYS0020"), LSTR("SYS0147"), "stop")
                END IF
                EXIT MENU
            END IF

        ON ACTION reload
            CALL sys_logout_chk(g_sys_no, g_user_id) RETURNING t_res

            IF t_res > 0 THEN
                #"SYS0148"="系統尚有未離開之作業,請全部關閉後再行登出!"
                CALL FGL_WINMESSAGE(LSTR("SYS0020"), LSTR("SYS0148"), "stop")
            ELSE
                LET flag = 1
                #離開系統將log_flag還原為'N'
                CALL sys_flag_off(
                    g_user_id, g_sys_no, g_company)
                    RETURNING t_res
                IF t_res <> 0 THEN
                    #"SYS0147"="系統登入碼寫入有誤!"
                    CALL FGL_WINMESSAGE(
                        LSTR("SYS0020"), LSTR("SYS0147"), "stop")
                END IF
                EXIT MENU
            END IF

    END MENU

    CLOSE WINDOW sys_mainmenu
    IF (flag = 1) THEN
        RUN "fglrun SYS_APP" WITHOUT WAITING
    END IF

END FUNCTION
