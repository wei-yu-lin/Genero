FUNCTION fun_show_chxx_desc(chxx_desc,f1)
    DEFINE chxx_desc DYNAMIC ARRAY OF STRING  
    DEFINE f1 ui.Form

    CALL f1.setElementText("ch01_desc", chxx_desc[1])
    CALL f1.setElementText("ch02_desc", chxx_desc[2])
    CALL f1.setElementText("ch03_desc", chxx_desc[3])
    CALL f1.setElementText("ch04_desc", chxx_desc[4])
    CALL f1.setElementText("ch05_desc", chxx_desc[5])
    CALL f1.setElementText("ch06_desc", chxx_desc[6])
    CALL f1.setElementText("ch07_desc", chxx_desc[7])
    CALL f1.setElementText("ch08_desc", chxx_desc[8])
    CALL f1.setElementText("ch09_desc", chxx_desc[9])
    CALL f1.setElementText("ch10_desc", chxx_desc[10])
    CALL f1.setElementText("ch11_desc", chxx_desc[11])
    CALL f1.setElementText("ch12_desc", chxx_desc[12])
    CALL f1.setElementText("ch13_desc", chxx_desc[13])
    CALL f1.setElementText("ch14_desc", chxx_desc[14])
    CALL f1.setElementText("ch15_desc", chxx_desc[15])
    
END FUNCTION 