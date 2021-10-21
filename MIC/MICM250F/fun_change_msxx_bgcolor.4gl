SCHEMA rdbmic36

FUNCTION fun_change_msxx_bgcolor(mic251_arr, idx2, f2)
    DEFINE mic251_arr DYNAMIC ARRAY OF RECORD
        mh01 LIKE micm240m.MH01,
        mh02 LIKE micm240m.MH02,
        mh03 LIKE micm240m.MH03,
        mh04 LIKE micm240m.MH04,
        mh05 LIKE micm240m.MH05,
        mh06 LIKE micm240m.MH06,
        mh07 LIKE micm240m.MH07,
        mh08 LIKE micm240m.MH08,
        mh09 LIKE micm240m.MH09,
        mh10 LIKE micm240m.MH10,
        mh11 LIKE micm240m.MH11,
        mh12 LIKE micm240m.MH12
    END RECORD
    DEFINE
        idx2 SMALLINT,
        x,y INTEGER,
        msxx STRING
    DEFINE f2 ui.Form
    DEFINE nums ARRAY[12] OF INTEGER=[1,2,3,4,5,6,7,8,9,10,11,12]
    DEFINE find_nums BOOLEAN= FALSE  
    DISPLAY mic251_arr[idx2].*
    
    LET x=1
    DISPLAY idx2
    
    
    FOR y=1 TO 12
        LET  find_nums = FALSE 
        IF y < 10 THEN
            LET msxx="ms0"||y
        ELSE 
            LET msxx="ms"||y
        END IF 
        
        IF find_nums = FALSE THEN 
            IF  mic251_arr[idx2].mh01 = y THEN 
                CALL f2.setElementStyle(msxx, "msnn")
                LET find_nums = TRUE 
            ELSE 
                CALL f2.setElementStyle(msxx, "csnn")
            END IF 
        END IF 

        IF  find_nums = FALSE THEN 
            IF  mic251_arr[idx2].mh02 = y THEN 
                CALL f2.setElementStyle(msxx, "msnn")
                LET find_nums = TRUE 
            ELSE 
                CALL f2.setElementStyle(msxx, "csnn")
            END IF 
        END IF 

        IF  find_nums = FALSE THEN 
            IF  mic251_arr[idx2].mh03 = y THEN 
                CALL f2.setElementStyle(msxx, "msnn")
                LET find_nums = TRUE 
            ELSE 
                CALL f2.setElementStyle(msxx, "csnn")
            END IF
        END IF 

        IF  find_nums = FALSE THEN 
            IF  mic251_arr[idx2].mh04 = y THEN 
                CALL f2.setElementStyle(msxx, "msnn")
                LET find_nums = TRUE 
            ELSE 
                CALL f2.setElementStyle(msxx, "csnn")
            END IF
        END IF 

        IF  find_nums = FALSE THEN 
            IF  mic251_arr[idx2].mh05 = y THEN 
                CALL f2.setElementStyle(msxx, "msnn")
                LET find_nums = TRUE 
            ELSE 
                CALL f2.setElementStyle(msxx, "csnn")
            END IF
        END IF 

        IF  find_nums = FALSE THEN 
            IF  mic251_arr[idx2].mh06 = y THEN 
                CALL f2.setElementStyle(msxx, "msnn")
                LET find_nums = TRUE 
            ELSE 
                CALL f2.setElementStyle(msxx, "csnn")
            END IF
        END IF 

        IF  find_nums = FALSE THEN 
            IF  mic251_arr[idx2].mh07 = y THEN 
                CALL f2.setElementStyle(msxx, "msnn")
                LET find_nums = TRUE 
            ELSE 
                CALL f2.setElementStyle(msxx, "csnn")
            END IF
        END IF 

        IF  find_nums = FALSE THEN 
            IF  mic251_arr[idx2].mh08 = y THEN 
                CALL f2.setElementStyle(msxx, "msnn")
                LET find_nums = TRUE 
            ELSE 
                CALL f2.setElementStyle(msxx, "csnn")
            END IF
        END IF 

        IF  find_nums = FALSE THEN 
            IF  mic251_arr[idx2].mh09 = y THEN 
                CALL f2.setElementStyle(msxx, "msnn")
                LET find_nums = TRUE 
            ELSE 
                CALL f2.setElementStyle(msxx, "csnn")
            END IF
        END IF 

        IF  find_nums = FALSE THEN 
            IF  mic251_arr[idx2].mh10 = y THEN 
                CALL f2.setElementStyle(msxx, "msnn")
                LET find_nums = TRUE 
            ELSE 
                CALL f2.setElementStyle(msxx, "csnn")
            END IF
        END IF 

        IF  find_nums = FALSE THEN 
            IF  mic251_arr[idx2].mh11 = y THEN 
                CALL f2.setElementStyle(msxx, "msnn")
                LET find_nums = TRUE 
            ELSE 
                CALL f2.setElementStyle(msxx, "csnn")
            END IF
        END IF 
        
    END FOR 
    
    
END FUNCTION
