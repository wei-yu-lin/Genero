SCHEMA rdbmic36

FUNCTION fun_mic_arr_initializer(mic_arr,idx)

    DEFINE mic_arr DYNAMIC ARRAY OF RECORD
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

    DEFINE idx SMALLINT 
    
    IF mic_arr[idx].pr_code IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].pr_code=""
    END IF 
    IF mic_arr[idx].remark IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].remark=""
    END IF 
    IF mic_arr[idx].ch01 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch01=0
    END IF 
    IF mic_arr[idx].ch02 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch02=0
    END IF
    IF mic_arr[idx].ch03 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch03=0
    END IF
    IF mic_arr[idx].ch04 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch04=0
    END IF
    IF mic_arr[idx].ch05 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch05=0
    END IF
    IF mic_arr[idx].ch06 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch06=0
    END IF
    IF mic_arr[idx].ch07 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch07=0
    END IF
    IF mic_arr[idx].ch08 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch08=0
    END IF
    IF mic_arr[idx].ch09 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch09=0
    END IF
    IF mic_arr[idx].ch10 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch10=0
    END IF
    IF mic_arr[idx].ch11 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch11=0
    END IF
    IF mic_arr[idx].ch12 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch12=0
    END IF
    IF mic_arr[idx].ch13 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch13=0
    END IF
    IF mic_arr[idx].ch14 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch14=0
    END IF
    IF mic_arr[idx].ch15 IS NULL THEN#MATCHES "*[0-9]" 
        LET mic_arr[idx].ch15=0
    END IF
    
END FUNCTION 