IMPORT util
IMPORT os
IMPORT FGL fgldialog
IMPORT FGL CPSCAP01
IMPORT FGL CPSCAP02
IMPORT FGL CPSCAP03
IMPORT FGL CPSCAP04
IMPORT FGL CPSCAP06

GLOBALS "../../sys/library/sys_globals.4gl"
GLOBALS "../Library/glb.4gl"

#--------------------------------------------------------------
#測試用主程式片段
#--------------------------------------------------------------
MAIN
    DISPLAY "development environment..."
    CONNECT TO "orapcm" AS "PCM"
    CONNECT TO "oracps" AS "CPS"
    #CONNECT TO "oracr2" AS "CR2"
    CONNECT TO "oraord" AS "ORD"
    CONNECT TO "oramic" AS "MIC"
    CONNECT TO "orawip" AS "WIP"
   # CONNECT TO "orahpc" AS "HPC"
    CONNECT TO "yud221" AS "YUD"

    CALL CPSCAP00_func()

    TRY
        DISCONNECT "PCM"
        DISCONNECT "CPS"
        DISCONNECT "ORD"
        DISCONNECT "MIC"
        DISCONNECT "WIP"
       # DISCONNECT "HPC"
        DISCONNECT "YUD"
    CATCH
    END TRY
END MAIN

FUNCTION CPSCAP00_func() 
    DEFINE exec_key INTEGER
    DEFINE fptr base.Channel
    DEFINE g_user_id, PathHeader STRING

    TRY
        CONNECT TO "orapcm" AS "PCM"
        CONNECT TO "oracps" AS "CPS"
       # CONNECT TO "oraCPS" AS "CPS"
        CONNECT TO "oraord" AS "ORD"
        CONNECT TO "oramic" AS "MIC"
        CONNECT TO "orawip" AS "WIP"
        CONNECT TO "orahpc" AS "HPC"
        CONNECT TO "yud221" AS "YUD"
    CATCH
    END TRY
    
    #將user_id存入公用變數
    CALL fgl_getenv("g_user_id") RETURNING g_user_id

    #CLOSE WINDOW SCREEN
    OPEN WINDOW CPSCAP00_w WITH FORM "CPSCAP00" ATTRIBUTE(STYLE = "schd",
                TEXT = "#CAP CAPSCH- CPSCAP00 - " || fgl_getenv("g_user_id"))
    
    #區分程式p_id
    CALL fgl_setenv("p_id", util.Datetime.format(CURRENT,"%Y%m%d%H%M%S") || g_user_id)
    #init semaphore for BC01
    LET fptr = base.Channel.create()

    LET PathHeader = "..//CPS//SharedMemory//"|| fgl_getenv("p_id")
    
    CALL fptr.openFile(PathHeader ||"_BC01.tmp", "w")
    CALL fptr.writeLine("TRUE")
    CALL fptr.close()

    CALL fptr.openFile(PathHeader ||"_MSG.tmp", "w")
    CALL fptr.writeLine("##########"||util.Datetime.format(CURRENT,"%Y/%m/%d %H:%M:%S")||"##########\n")
    CALL fptr.close()

#******************************************************************
#冷軋產線選擇畫面 Dialog Module
#******************************************************************
    CALL ui.Interface.loadStyles("cps_style")
    CALL ui.Window.getCurrent().getForm().loadTopMenu("cpscap00_topmenu")
    CALL CPSCAP01.CPSCAP01() RETURNING exec_key
    CALL next_work(exec_key)
   

    CLOSE WINDOW CPSCAP00_w
    
    DISPLAY "delete semaphore .tmp: " + os.Path.delete(PathHeader||"_BC01.tmp")
    DISPLAY "delete ack .tmp: " + os.Path.delete(PathHeader||"_ZF51.tmp")
    DISPLAY "delete msg .tmp: " + os.Path.delete(PathHeader||"_MSG.tmp")
    
    TRY
        DISCONNECT "PCM"
        DISCONNECT "CPS"
        DISCONNECT "ORD"
        DISCONNECT "MIC"
        DISCONNECT "WIP"
        DISCONNECT "HPC"
        DISCONNECT "YUD"
    CATCH
    END TRY
END FUNCTION

FUNCTION next_work(i INTEGER)
    DEFINE tmp INTEGER
    IF i == 1 THEN
        CALL CPSCAP01.CPSCAP01() RETURNING tmp
        CALL next_work(tmp)
    END IF
    IF i == 2 THEN
        CALL CPSCAP02.CPSCAP02() RETURNING tmp
        CALL next_work(tmp)
    END IF
    IF i == 3 THEN
        CALL CPSCAP03.CPSCAP03() RETURNING tmp
        CALL next_work(tmp)
    END IF
    IF i == 4 THEN
        CALL CPSCAP04.CPSCAP04() RETURNING tmp
        CALL next_work(tmp)
    END IF
    IF i == 6 THEN
        CALL CPSCAP06.CPSCAP06() RETURNING tmp
        CALL next_work(tmp)
    END IF
END FUNCTION
