IMPORT util
IMPORT os

IMPORT FGL CZFP210M_DB
IMPORT FGL CZFP215M_DB
IMPORT FGL CRM_INC
IMPORT FGL CPSCR6_INC
IMPORT FGL sys_toolbar

GLOBALS "../../Library/glb.4gl"

DEFINE CZFP215M_arr DYNAMIC ARRAY OF CZFP215M_DB.CZFP215M
DEFINE L2ip STRING
DEFINE port, i, j, len, len_i, len_j INTEGER
DEFINE ShareMemoryPath STRING

DEFINE priv sys_priv
DEFINE form_tb sys_ConToolBar

FUNCTION CPSCR604()
    DEFINE next_work INTEGER
    DEFINE msg_log, fptr base.Channel
    DEFINE conn_msg, s_tmp STRING
    DEFINE ack_arr DYNAMIC ARRAY OF CRM_INC.L2ACK
    
    #OPEN FORM CPSCR604_f FROM "CPSCR604"
    #DISPLAY FORM CPSCR604_f

    SET CONNECTION "CR2"
    
    CALL form_tb.init(FALSE)
    CALL form_tb.setAttribute("_del", TRUE)
    CALL form_tb.getPriv("CPSCR604")
    
    CALL ui.Window.getCurrent().getForm().loadTopMenu("cr6sch01_topmenu")

    CALL CZFP215M_DB.getCZFP215M_DB() RETURNING CZFP215M_arr
    LET msg_log = base.Channel.create()

    #預設值
    LET L2ip = "172.16.5.29"
    LET port = 5432
    LET ShareMemoryPath = "..//CPS//SharedMemory//"|| fgl_getenv("p_id") || "_"

    #init BC01 ack pool
    CALL fgl_setenv("ack_pool", "[]")
    LET fptr = base.Channel.create()
    CALL fptr.openFile(ShareMemoryPath||"ZF51.tmp", "w")
    CALL fptr.writeLine("[]")
    CALL fptr.close()
    
    #clean sender msg
    #CALL fptr.openFile("..//CPS//CPSCR600//sender.log", "w")
    #CALL fptr.writeLine(" ")
    #CALL fptr.close()
    
    DIALOG ATTRIBUTE(UNBUFFERED)
        SUBDIALOG CZFP215M_dm
        SUBDIALOG L2ip_dm
        SUBDIALOG ConnPort_dm
        
        BEFORE DIALOG
            CALL form_tb.setDialogPriv()
            
        ON TIMER 1
            #ACK update - 從Share Memory讀取L2 ACK
            CALL fptr.openFile(ShareMemoryPath || "ZF51.tmp", "r")
            LET s_tmp = fptr.readLine()
            CALL fptr.close()
            CALL util.JSON.parse(s_tmp, ack_arr) -- 將目前ack存到ack_arr
            
            #比對ack與傳送coil
            LET len_i = ack_arr.getLength()
            LET len_j = CZFP215M_arr.getLength()
            
            FOR i = 1 TO len_i -- ack array
                FOR j = 1 TO len_j -- send coil
                    IF ack_arr[i].coil_no == CZFP215M_arr[j].COIL_NO THEN -- send coil和ack對上 
                        #ack[32] - A for accept/OK, B for reject/not OK
                        IF ack_arr[i].bufData.subString(2,2) == "A" THEN
                            CALL CZFP215M_arr[j].delDB()
                            CALL CZFP215M_arr.deleteElement(j)
                        ELSE
                            LET CZFP215M_arr[j].ACK = ack_arr[i].bufData.subString(2,2) ||
                                    ack_arr[i].bufData.subString(10,11)
                        END IF
                    END IF
                END FOR
            END FOR
            
            CALL msg_log.openFile(ShareMemoryPath||"MSG.tmp", "r")
            #DISPLAY ShareMemoryPath||"MSG.tmp" TO msg_path_fd
            LET conn_msg = "sernder connection message:\n"
            WHILE msg_log.read(s_tmp)
                IF s_tmp IS NOT NULL THEN
                    LET conn_msg = conn_msg || s_tmp || "\n"
                END IF
            END WHILE
            DISPLAY conn_msg TO ConnMsg_te
            CALL ui.Interface.refresh()
            CALL msg_log.close()
        ON ACTION CPSCR604_F1 ATTRIBUTE(TEXT="PDI傳送", ACCELERATOR = "F1")
            LET len = CZFP215M_arr.getLength()
            FOR i = 1 TO len
                IF DIALOG.isRowSelected("CZFP215M_r", i) THEN
                    CALL SendPDItoL2(CZFP215M_arr[i].COIL_NO)
                END IF
            END FOR
            
        ON ACTION CPSCR604_del ATTRIBUTE(TEXT="刪除傳送", ACCELERATOR = "F2")
            LET len = CZFP215M_arr.getLength()
            FOR i = len TO 1 STEP -1
                IF DIALOG.isRowSelected("CZFP215M_r", i) THEN
                    CALL CZFP215M_arr[i].delDB()
                    CALL CZFP215M_arr.deleteElement(i)
                END IF
            END FOR
            
        ON ACTION CPSCR601
            LET next_work = 1
            EXIT DIALOG
        ON ACTION CPSCR602
            LET next_work = 2
            EXIT DIALOG
        ON ACTION CPSCR603
            LET next_work = 3
            EXIT DIALOG
        ON ACTION CPSCR606
            LET next_work = 6
            EXIT DIALOG
        ON ACTION EXIT
            EXIT DIALOG
    END DIALOG
     
    RETURN next_work
END FUNCTION

DIALOG CZFP215M_dm()
    DISPLAY ARRAY CZFP215M_arr TO CZFP215M_r.*
        BEFORE DISPLAY
            #多列選擇模式
            CALL Dialog.setSelectionMode("CZFP215M_r", TRUE)
    END DISPLAY
END DIALOG

DIALOG L2ip_dm()
    INPUT L2ip FROM L2_ip_e ATTRIBUTE(WITHOUT DEFAULTS)
    END INPUT
END DIALOG

DIALOG ConnPort_dm()
    INPUT port FROM port_e ATTRIBUTE(WITHOUT DEFAULTS)
    END INPUT
END DIALOG

FUNCTION SendPDItoL2(src_coil CHAR(11))
    DEFINE pdi CZFP210M_DB.CZFP210M
    DEFINE tmp CRM_INC.L3MSG

    SET CONNECTION "CR2"
    SELECT * INTO pdi.*
        FROM czfp210m
        WHERE COIL_NO = src_coil

    LET tmp = pdi.genCZFP210M_BC01Msg()

    CALL PDI_SENDER(tmp.*)
    
END FUNCTION


FUNCTION PDI_SENDER(msg CRM_INC.L3MSG)
    DEFINE BC5_ch base.Channel
    DEFINE msgString STRING

    IF msg.coil_no IS NULL THEN
        RETURN
    END IF
    
    LET BC5_ch = base.Channel.create()
    
    CALL BC5_ch.openPipe("start /b fglrun CRM_SENDER","w")
    #CALL BC5_ch.openPipe("fglrun PDI_SENDER","u")

    LET msgString = util.JSON.stringify(msg)
    CALL BC5_ch.writeLine(msgString)
    CALL BC5_ch.writeLine(L2ip)
    CALL BC5_ch.writeLine(port)

    #CALL fgl_setenv("msg", msg)
    #RUN "fglrun PDI_SENDER" WITHOUT WAITING
END FUNCTION


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
