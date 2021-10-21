IMPORT util
IMPORT FGL CRM_INC
GLOBALS "../../Library/glb.4gl"

DEFINE ShareMemoryPath STRING
MAIN
    DEFINE io, sv_cmd, conn_log, ack_locate base.Channel
    DEFINE ip, msg_json, ack, ack_json STRING
    DEFINE msg CRM_INC.L3MSG
    DEFINE port, err_code, len INTEGER
    DEFINE first_elem BOOLEAN
    DEFINE ack_arr DYNAMIC ARRAY OF CRM_INC.L2ACK

    LET sv_cmd = base.Channel.create()
    CALL sv_cmd.openFile(NULL, "r")

    LET ShareMemoryPath = "..//CPS//SharedMemory//"|| fgl_getenv("p_id") || "_"
    
    LET conn_log = base.Channel.create()
    CALL conn_log.openFile(ShareMemoryPath||"MSG.tmp", "a")
    
    LET msg_json = sv_cmd.readLine()
    LET ip = sv_cmd.readLine()
    LET port = sv_cmd.readLine()

    CALL util.JSON.parse(msg_json, msg)
    TRY
        DISPLAY "Connect to socket "||ip||":"||port
        CALL conn_log.writeLine("Connect to socket "||ip||":"||port)

        #send msg to L2
        LET io = base.Channel.create()
        CALL io.openClientSocket(ip, port, "u", 3)
        CALL msg.genMsgString()
        CALL io.writeLine(msg.msgString)

        CALL conn_log.writeLine("####" || msg.class|| ";"
                || msg.coil_no || ";"
                || msg.date.subString(1,4) ||"/"|| msg.date.subString(5,6) ||"/"|| msg.date.subString(7,8)||" "
                || msg.time.subString(1,2) ||":"|| msg.time.subString(3,4) ||":"|| msg.time.subString(5,6)||":"||"####")
                
        CALL conn_log.writeLine(msg.coil_no||" waiting L2 ACK...\n")
        CALL conn_log.writeLine("--------------------------------")
        
        WHILE TRUE
            #等待L2 ACK
            IF io.dataAvailable() THEN
                LET err_code = io.read(ack)
                #DISPLAY msg.subString(31,41) || " ack: "||ack

                IF ack IS NULL THEN
                    CALL conn_log.writeLine("#### invalid ack;"
                                        || msg.coil_no || ";"
                                        ||"####")
                ELSE
                    CALL conn_log.writeLine("####" || ack.subString(1,4)|| ";"
                                        || msg.coil_no || ";"
                                        ||"####")
                END IF
                CALL conn_log.writeLine(msg.class|| ";"
                            || msg.coil_no || ";"
                            || msg.date.subString(1,4) ||"/"|| msg.date.subString(5,6) ||"/"|| msg.date.subString(7,8)||" "
                            || msg.time.subString(1,2) ||":"|| msg.time.subString(3,4) ||":"|| msg.time.subString(5,6))
                CALL conn_log.writeLine("ACK: " || ack)
                CALL conn_log.writeLine("receive time:"||util.Datetime.format(CURRENT,"%Y/%m/%d %H:%M:%S"))
                CALL conn_log.writeLine("--------------------------------")
                EXIT WHILE
            END IF
            SLEEP 1
        END WHILE

        #取得ack pool存取semaphore
        WHILE getUnlockSem(msg.class) != "TRUE"
            #有人佔用ack pool
            SLEEP 1
        END WHILE

        #拉起使用信號
        CALL setUnlockSem(msg.class, "FALSE")
        #---ˇˇˇ臨界區間ˇˇˇ---

        LET first_elem = TRUE

        #取出當前global ack pool資料
        LET ack_locate = base.Channel.create()
        CALL ack_locate.openFile(ShareMemoryPath || ack.subString(1,4)||".tmp", "r")
        LET ack_json = ack_locate.readLine()
        CALL ack_locate.close()
        #LET ack_json = fgl_getenv("ack_pool")


        #append ack到ack pool
        CALL util.JSON.parse(ack_json, ack_arr)
        CALL ack_arr.appendElement()
        LET len = ack_arr.getLength()
        LET ack_arr[len].msghdr = msg.msgString.subString(1,31)
        LET ack_arr[len].coil_no = msg.coil_no
        LET ack_arr[len].ackHeader = ack.subString(1,30)
        LET ack_arr[len].bufData = ack.subString(31,ack.getLength())

        #寫回global ack pool
        LET ack_json = util.JSON.stringify(ack_arr)
        #CALL fgl_setenv("ack_pool", ack_json)
        CALL ack_locate.openFile(ShareMemoryPath || ack.subString(1,4)||".tmp", "w")
        CALL ack_locate.writeLine(ack_json)
        CALL ack_locate.close()
        #---^^^臨界區間^^^---
        #放下使用信號
        CALL setUnlockSem(msg.class, "TRUE")
        
        
    CATCH
        IF STATUS == "-8086" THEN
            #DISPLAY ip||":"||port, " The socket connection timed out."
            CALL conn_log.writeLine(ip||":"||port||" The socket connection timed out.")
            CALL conn_log.close()

        END IF
    END TRY

    #DISPLAY msg.subString(31,41)||" PDI SENDER FINISHED"
    #CALL conn_log.writeLine(msg.subString(31,41)||" PDI SENDER FINISHED")

    CALL conn_log.close()
END MAIN


FUNCTION getUnlockSem(msg STRING)
    DEFINE unlock_sem base.Channel
    DEFINE res STRING

    LET unlock_sem = base.Channel.create()
    CALL unlock_sem.openFile(ShareMemoryPath || msg.subString(1,4)||".tmp", "r")
    LET res = unlock_sem.readLine()
    CALL unlock_sem.close()

    RETURN res
END FUNCTION

FUNCTION setUnlockSem(msg STRING, sem STRING)
    DEFINE unlock_sem base.Channel

    LET unlock_sem = base.Channel.create()
    CALL unlock_sem.openFile(ShareMemoryPath || msg.subString(1,4)||".tmp", "w")
    CALL unlock_sem.writeLine(sem)
    CALL unlock_sem.close()
END FUNCTION
