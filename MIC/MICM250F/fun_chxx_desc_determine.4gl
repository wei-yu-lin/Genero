SCHEMA rdbmic36

FUNCTION fun_chxx_desc_determine(chxx_desc, mic_arr, csxx_definition,idx)
    
    DEFINE chxx_desc DYNAMIC ARRAY OF STRING  
    DEFINE mic_arr  DYNAMIC ARRAY OF RECORD
        pr_code LIKE micm240m.PR_CODE,
        remark LIKE micm240m.REMARK,
        ch01 LIKE micm240m.CH01,
        ch02 LIKE micm240m.CH02,
        ch03 LIKE micm240m.CH03,
        ch04 LIKE micm240m.CH04,
        ch05 LIKE micm240m.CH05,
        ch06 LIKE micm240m.CH06,
        ch07 LIKE micm240m.CH07,
        ch08 LIKE micm240m.CH08,
        ch09 LIKE micm240m.CH09,
        ch10 LIKE micm240m.CH10,
        ch11 LIKE micm240m.CH11,
        ch12 LIKE micm240m.CH12,
        ch13 LIKE micm240m.CH13,
        ch14 LIKE micm240m.CH14,
        ch15 LIKE micm240m.CH15
    END RECORD
    DEFINE csxx_definition ARRAY[24] OF STRING = [
        "C ",
        "Si",
        "Mn",
        "P ",
        "S ",
        "Ni",
        "Cr",
        "Mo",
        "Cu",
        "N ",
        "O ",
        "Ti",
        "B ",
        "Nb",
        "Al",
        "V ",
        "Sn",
        "Co",
        "Pb",
        "Ca",
        "CE",
        "WC",
        "Kf",
        "Ca|CE|Pcm|Kfa"	
        ]
    DEFINE x INTEGER,
        idx SMALLINT 

    FOR x=1 TO 15
        INITIALIZE chxx_desc[x] TO NULL 
    END FOR 

    DISPLAY "mic_arr[idx].ch01",mic_arr[idx].ch01,"idx",idx

    IF mic_arr[idx].ch01 <> 0 THEN 
        LET chxx_desc[1]=csxx_definition[mic_arr[idx].ch01]
    END IF 
    IF mic_arr[idx].ch02 <> 0 THEN 
        LET chxx_desc[2]=csxx_definition[mic_arr[idx].ch02]
    END IF 
    IF mic_arr[idx].ch03 <> 0 THEN 
        LET chxx_desc[3]=csxx_definition[mic_arr[idx].ch03]
    END IF 
    IF mic_arr[idx].ch04 <> 0 THEN 
        LET chxx_desc[4]=csxx_definition[mic_arr[idx].ch04]
    END IF 
    IF mic_arr[idx].ch05 <> 0 THEN 
        LET chxx_desc[5]=csxx_definition[mic_arr[idx].ch05]
    END IF 
    IF mic_arr[idx].ch06 <> 0 THEN 
        LET chxx_desc[6]=csxx_definition[mic_arr[idx].ch06]
    END IF 
    IF mic_arr[idx].ch07 <> 0 THEN 
        LET chxx_desc[7]=csxx_definition[mic_arr[idx].ch07]
    END IF 
    IF mic_arr[idx].ch08 <> 0 THEN 
        LET chxx_desc[8]=csxx_definition[mic_arr[idx].ch08]
    END IF 
    IF mic_arr[idx].ch09 <> 0 THEN 
        LET chxx_desc[9]=csxx_definition[mic_arr[idx].ch09]
    END IF 
    IF mic_arr[idx].ch10 <> 0 THEN 
        LET chxx_desc[10]=csxx_definition[mic_arr[idx].ch10]
    END IF 
    IF mic_arr[idx].ch11 <> 0 THEN 
        LET chxx_desc[11]=csxx_definition[mic_arr[idx].ch11]
    END IF 
    IF mic_arr[idx].ch12 <> 0 THEN 
        LET chxx_desc[12]=csxx_definition[mic_arr[idx].ch12]
    END IF 
    IF mic_arr[idx].ch13 <> 0 THEN 
        LET chxx_desc[13]=csxx_definition[mic_arr[idx].ch13]
    END IF 
    IF mic_arr[idx].ch14 <> 0 THEN 
        LET chxx_desc[14]=csxx_definition[mic_arr[idx].ch14]
    END IF 
    IF mic_arr[idx].ch15 <> 0 THEN 
        LET chxx_desc[15]=csxx_definition[mic_arr[idx].ch15]
    END IF 

    RETURN chxx_desc
    
    
END FUNCTION 
