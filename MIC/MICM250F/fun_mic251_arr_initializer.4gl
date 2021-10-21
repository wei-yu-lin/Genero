SCHEMA rdbmic36

FUNCTION fun_mic251_arr_initializer(mic251_arr,idx2)
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
    DEFINE idx2 SMALLINT 

    IF mic251_arr[idx2].mh01 IS NULL THEN 
        LET mic251_arr[idx2].mh01 = 0 
    END IF
    IF mic251_arr[idx2].mh02 IS NULL THEN 
        LET mic251_arr[idx2].mh02 = 0 
    END IF
    IF mic251_arr[idx2].mh03 IS NULL THEN 
        LET mic251_arr[idx2].mh03 = 0 
    END IF
    IF mic251_arr[idx2].mh04 IS NULL THEN 
        LET mic251_arr[idx2].mh04 = 0 
    END IF
    IF mic251_arr[idx2].mh05 IS NULL THEN 
        LET mic251_arr[idx2].mh05 = 0 
    END IF
    IF mic251_arr[idx2].mh06 IS NULL THEN 
        LET mic251_arr[idx2].mh06 = 0 
    END IF
    IF mic251_arr[idx2].mh07 IS NULL THEN 
        LET mic251_arr[idx2].mh07 = 0 
    END IF
    IF mic251_arr[idx2].mh08 IS NULL THEN 
        LET mic251_arr[idx2].mh08 = 0 
    END IF
    IF mic251_arr[idx2].mh09 IS NULL THEN 
        LET mic251_arr[idx2].mh09 = 0 
    END IF
    IF mic251_arr[idx2].mh10 IS NULL THEN 
        LET mic251_arr[idx2].mh10 = 0 
    END IF
    IF mic251_arr[idx2].mh11 IS NULL THEN 
        LET mic251_arr[idx2].mh11 = 0 
    END IF
    IF mic251_arr[idx2].mh12 IS NULL THEN 
        LET mic251_arr[idx2].mh12 = 0 
    END IF
END FUNCTION 