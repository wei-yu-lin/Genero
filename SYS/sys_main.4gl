IMPORT FGL sys_login 
MAIN

#-----------------------------------------------------
#開啟連線
#-----------------------------------------------------
 CONNECT TO "yud221" AS "MIS"

    CLOSE WINDOW SCREEN
    CALL SYS_LOGIN()
       
END MAIN


