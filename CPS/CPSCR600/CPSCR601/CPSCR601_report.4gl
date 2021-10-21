IMPORT FGL CZFP321W_DB

TYPE reportData RECORD
            focusRow CZFP321W_DB.CZFP321W,
            totalWT FLOAT,
            groupId INTEGER
        END RECORD

FUNCTION GenReport(CZFP321W_arr DYNAMIC ARRAY OF CZFP321W_DB.CZFP321W)
    DEFINE saxhandler om.SaxDocumentHandler
    DEFINE i, j, len INTEGER
    DEFINE DATA reportData
    
    
    LET DATA.totalWT = 0

    LET len = CZFP321W_arr.getLength()
    
    LET saxhandler = configureOutput()

    START REPORT SchdReport TO XML HANDLER saxHANDLER

    FOR i = 1 TO len
            LET DATA.focusRow = CZFP321W_arr[i]
            LET DATA.totalWT = DATA.totalWT + CZFP321W_arr[i].COIL_WT
            LET DATA.groupId = 1
            OUTPUT TO REPORT SchdReport(DATA.*)
    END FOR

    FINISH REPORT SchdReport
    

END FUNCTION

FUNCTION configureOutput()
 
    IF NOT fgl_report_loadCurrentSettings("CPSCR601_report.4rp") THEN
        CALL fgl_winmessage("錯誤","錯誤錯誤","")
        EXIT PROGRAM
    END IF
    CALL fgl_report_selectDevice("SVG")
    CALL fgl_report_selectPreview(true)
    RETURN fgl_report_commitCurrentSettings()
END FUNCTION

REPORT SchdReport( item reportData)
    
    ORDER EXTERNAL BY item.groupId
    FORMAT
    BEFORE GROUP OF item.groupId
            DISPLAY "ID " || item.groupId
            
    ON EVERY ROW
        PRINTX item.*

END REPORT

