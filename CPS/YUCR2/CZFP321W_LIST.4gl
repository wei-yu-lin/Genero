IMPORT util
IMPORT FGL CZFP210M_DB
IMPORT FGL CZFP320M_DB
IMPORT FGL CZFP321W_DB
IMPORT FGL CZFP322W_DB
IMPORT FGL ORDB011M_DB
IMPORT FGL PCMB020M_DB
IMPORT FGL PCMB030M_DB
IMPORT FGL PCMB100M_DB
IMPORT FGL CPSCR6_INC

SCHEMA oracr2

#-------------------------------------------------------
# USED IN GENERATE CZFP321W ARRAY METHOD
#-------------------------------------------------------
PUBLIC TYPE CZFP321W_LIST RECORD
    arr DYNAMIC ARRAY OF CZFP321W_DB.CZFP321W
END RECORD

#----------------------------------------------------------------------
#回傳CZFP321W DB資料
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list CZFP321W_LIST) get()
    DEFINE s_sql STRING
    DEFINE i, j, k, len INTEGER
    DEFINE rec_tmp CZFP321W_DB.CZFP321W
    
    SET CONNECTION "CR2"

    CALL src_list.arr.clear()
    
    LET s_sql = "select * from CZFP321W "

    PREPARE s_stat FROM s_sql
    DECLARE cs321 CURSOR FOR s_stat

    LET i = 1
    FOREACH cs321 INTO src_list.arr[i].*
        LET i = i + 1
    END FOREACH

    #刪除最後NULL成員
    CALL src_list.arr.deleteElement(i)
    
    #依據BPFP排序
    LET len = src_list.arr.getLength()
    FOR i = 1 TO len
        IF src_list.arr[i].COIL_NO == ' ' THEN
            LET rec_tmp.* = src_list.arr[i].*
            LET src_list.arr[i].* = src_list.arr[1].*
            LET src_list.arr[1].* = rec_tmp.*
            EXIT FOR
        END IF
    END FOR
    FOR i = 2 TO len
        FOR j = i TO len
            FOR k = i TO len
                IF src_list.arr[i].FP == src_list.arr[k].COIL_NO THEN
                    LET rec_tmp.* = src_list.arr[i].*
                    LET src_list.arr[i].* = src_list.arr[k].*
                    LET src_list.arr[k].* = rec_tmp.*
                END IF
            END FOR
        END FOR
    END FOR

    
    #刪除HEADER成員
    FOR i = 1 TO len
        IF src_list.arr[i].COIL_NO == ' ' THEN
            #刪除後會在陣列最後出現一個NULL成員
            CALL src_list.arr.deleteElement(i)
        END IF
    END FOR

    #刪除最後NULL成員
    CALL src_list.arr.deleteElement(len)
    
END FUNCTION

#----------------------------------------------------------------------
#細排陣列存入細排暫存檔
#CZFP321W_arr存入CZFP321W
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list CZFP321W_LIST) set()
    DEFINE i, len INTEGER

    #創立BPFP連結關係
    CALL src_list.setBPFP()
    LET len = src_list.arr.getLength() 
    FOR i = 1 TO len
        TRY
            CALL src_list.arr[i].ins()
        CATCH
            CALL src_list.arr[i].upd()
        END TRY
    END FOR
END FUNCTION

#----------------------------------------------------------------------
#以COIL NO刪除CZFP321W ARRAY及DB之中的鋼捲
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list CZFP321W_LIST) delByIndex(idx INTEGER)
    SET CONNECTION "CR2"

    CALL src_list.delByCoilNo(src_list.arr[idx].COIL_NO)
    
END FUNCTION

#----------------------------------------------------------------------
# 將粗排鋼捲(P322W)加入細排清單(P321W_LIST)中
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list CZFP321W_LIST) append(src_p322w CZFP322W_DB.CZFP322W)
    DEFINE i, len INTEGER

    LET len = src_list.arr.getLength()

    #已在細排中，不做處理
    FOR i = 1 TO len
        IF src_list.arr[i].COIL_NO == src_p322w.COIL_NO THEN
            RETURN
        END IF
    END FOR
    
    SET CONNECTION "CR2"

    #陣列insert
    LET src_list.arr[len+1] = src_p322w.toP321W()
    #DB insert
    CALL src_list.arr[len+1].ins()

    #粗排DB 標記選取
    LET src_p322w.FLAG = "@"
    CALL src_p322w.upd()
    #UPDATE CZFP322W SET FLAG = "@" WHERE COIL_NO = src_p322w.COIL_NO
END FUNCTION

#----------------------------------------------------------------------
# 將細排清單Append到排程檔中
#----------------------------------------------------------------------
FUNCTION (src_list CZFP321W_LIST) appendToSchd(schd_seq SchdSeq_rec)
    DEFINE i INTEGER
    DEFINE head, head_bp, append_coil, upd_ctrl, ins_ctrl CZFP320M_DB.CZFP320M

    INITIALIZE upd_ctrl.* TO NULL
    INITIALIZE ins_ctrl.* TO NULL
    
    SET CONNECTION "CR2"
    
    FOR i=schd_seq.coil_num TO 1 STEP -1
        LET append_coil.SCHD_COIL_NO = schd_seq.schd_no||src_list.arr[i].COIL_NO
        LET append_coil.SEQ_NO = schd_seq.init_no + i - 1
        LET append_coil.PROCESS_CODE = ' '
        LET append_coil.PROCESS_INDEX = 0
        LET append_coil.STATE = 'I'

        SELECT * INTO head.* FROM CZFP320M WHERE SCHD_COIL_NO = ' '

        IF head.SCHD_COIL_NO IS NULL THEN
            #P320M裡不存在header時，創建header
            INITIALIZE ins_ctrl.* TO NULL
            LET ins_ctrl.SCHD_COIL_NO = ' '
            CALL ins_ctrl.ins()
            
            #header的FB指向初始鋼捲
            INITIALIZE upd_ctrl.* TO NULL
            LET upd_ctrl.SCHD_COIL_NO = ' '
            LET upd_ctrl.FP = append_coil.SCHD_COIL_NO
            CALL upd_ctrl.upd()

            #P320M裡無排程鋼捲->BP指向header
            LET append_coil.BP = ' '
        ELSE
            #P320M裡已有排程鋼捲->BP指向第一顆
            SELECT * INTO head_bp.* FROM CZFP320M WHERE SCHD_COIL_NO = head.BP
            LET append_coil.BP = head_bp.SCHD_COIL_NO
        END IF

        #FP指向header
        LET append_coil.FP = ' '
        
        #於CZFP320M插入此筆鋼捲排程
        INITIALIZE ins_ctrl.* TO NULL
        LET ins_ctrl.* = append_coil.*
        CALL ins_ctrl.ins()
        
        #header的BP指向此鋼捲
        INITIALIZE upd_ctrl.* TO NULL
        LET upd_ctrl.SCHD_COIL_NO = ' '
        LET upd_ctrl.BP = append_coil.SCHD_COIL_NO
        CALL upd_ctrl.upd()
        
        #原本第一顆的FP指向此鋼捲
        INITIALIZE upd_ctrl.* TO NULL
        LET upd_ctrl.SCHD_COIL_NO = head_bp.SCHD_COIL_NO
        LET upd_ctrl.FP = append_coil.SCHD_COIL_NO
        CALL upd_ctrl.upd()

    END FOR

END FUNCTION

#----------------------------------------------------------------------
#由COIL NO指定刪除CZFP322W DB資料
#----------------------------------------------------------------------
PUBLIC FUNCTION (src_list CZFP321W_LIST) delByCoilNo(arg_coil LIKE CZFP322W.coil_no)
    DEFINE i, len INTEGER
    DEFINE ctrl CZFP321W_DB.CZFP321W

    #DB刪除
    CALL ctrl.init()
    LET ctrl.COIL_NO = arg_coil
    CALL ctrl.del()

    #UI陣列刪除
    LET len = src_list.arr.getLength()
    FOR i = 1 TO len
        IF src_list.arr[i].COIL_NO == arg_coil THEN
            CALL src_list.arr.deleteElement(i)
            EXIT FOR
        END IF
    END FOR
END FUNCTION

#----------------------------------------------------------------------
# 於CZFP321W_arr建立BP,FP Linking
#----------------------------------------------------------------------
PRIVATE FUNCTION (src_list CZFP321W_LIST) setBPFP()
    DEFINE i, len INTEGER
    DEFINE upd_ctrl CZFP321W

    LET len = src_list.arr.getLength()
    IF len <= 1 THEN
        LET src_list.arr[1].FP = ' '
        LET src_list.arr[1].BP = ' '

        INITIALIZE upd_ctrl.* TO NULL
        LET upd_ctrl.BP = ' '
        LET upd_ctrl.FP = ' '
        LET upd_ctrl.COIL_NO = ' '
        CALL upd_ctrl.upd()
        #UPDATE CZFP321W SET BP = ' ', FP = ' ' WHERE COIL_NO = ' ' 
    END IF
    IF len > 1 THEN
        LET src_list.arr[1].FP = ' '
        LET src_list.arr[1].BP = src_list.arr[2].COIL_NO
        LET src_list.arr[len].FP = src_list.arr[len-1].COIL_NO
        LET src_list.arr[len].BP = ' '

        INITIALIZE upd_ctrl.* TO NULL
        LET upd_ctrl.BP = src_list.arr[1].COIL_NO
        LET upd_ctrl.FP = src_list.arr[len].COIL_NO
        LET upd_ctrl.COIL_NO = ' '
        CALL upd_ctrl.upd()
        #UPDATE CZFP321W SET BP = src_list.arr[1].COIL_NO, FP = src_list.arr[len].COIL_NO WHERE COIL_NO = ' '
    END IF
    FOR i = 2 TO len - 1
        LET src_list.arr[i].FP = src_list.arr[i-1].COIL_NO
        LET src_list.arr[i].BP = src_list.arr[i+1].COIL_NO
    END FOR

END FUNCTION

#----------------------------------------------------------------------
# 從CZFP321W_list.arr生成PDI並存到CZFP210M
#----------------------------------------------------------------------
FUNCTION (src_list CZFP321W_LIST) genPDI()
    DEFINE PDI DYNAMIC ARRAY OF CZFP210M_DB.CZFP210M
    DEFINE PCM_DATA PCMB020M_DB.PCMB020M -- PDI產生所需之PCMB020M DATA
    DEFINE HSM_DATA PCMB030M_DB.PCMB030M
    DEFINE PCM100_DATA PCMB100M_DB.PCMB100M -- PDI產生所需之PCMB100M DATA
    DEFINE ORD_DATA ORDB011M_DB.ORDB011M
    DEFINE len, i, j INTEGER
    DEFINE tmp_rec CZFP321W_DB.CZFP321W
    DEFINE CURR_STATION_CODE, s_sleeve CHAR(1)
    DEFINE CRM_CODE, s_sample_code, s_tmp STRING
    DEFINE f_density FLOAT
    DEFINE baf_pass BOOLEAN

    LET CRM_CODE = "LMN"
    LET CURR_STATION_CODE = ' '
    LET len = src_list.arr.getLength()
    
    FOR i = 1 TO len
        LET tmp_rec = src_list.arr[i]
        CALL PCM_DATA.getByCoilNo(tmp_rec.COIL_NO)

        LET s_tmp = tmp_rec.ORDER_NO_ITEM
        LET ORD_DATA.ORDER_NO = s_tmp.subString(1,7)
        LET ORD_DATA.ORDER_ITEM = s_tmp.subString(8,9)
        CALL ORD_DATA.getORDB011M()

        LET PCM100_DATA.ORDER_NO = s_tmp.subString(1,7)
        LET PCM100_DATA.ORDER_ITEM = s_tmp.subString(8,9)
        CALL PCM100_DATA.getPCMB100M()
        
        #1. COIL_NO
        LET PDI[i].COIL_NO = src_list.arr[i].COIL_NO
        
        #2. COIL_STATUS
        IF PCM_DATA.CURR_STATION == "CRM" AND PCM_DATA.IC_CODE == "32" THEN
            #待排程鋼捲
            LET PDI[i].COIL_STATUS = 'I'
            LET CURR_STATION_CODE = PCM_DATA.CURR_STATION_CODE
        ELSE IF PCM_DATA.CURR_STATION == "CRM" AND PCM_DATA.IC_CODE == "31" THEN
            #待搬運鋼捲
            LET PDI[i].COIL_STATUS = 'P'
            LET CURR_STATION_CODE = PCM_DATA.CURR_STATION_CODE
        ELSE
            #預排鋼捲
            LET PDI[i].COIL_STATUS = 'P'

            #將CURR_STATION_CODE推移到冷軋STATION_CODE
            FOR j = PCM_DATA.CURR_STATION_INDEX + 1 TO 20
                IF CRM_CODE.getIndexOf(PCM_DATA.ACTL_STATION_CODE[j], 1) THEN
                    LET CURR_STATION_CODE = PCM_DATA.ACTL_STATION_CODE[j]
                    EXIT FOR
                END IF
            END FOR
        END IF END IF

        #3. STEEL_GRADE
        LET PDI[i].STEEL_GRADE = PCM_DATA.STEEL_GRADE

        #4. ENTRY_WIDTH
        LET PDI[i].ENTRY_WIDTH = PCM_DATA.COIL_WIDTH

        #5. ENTRY_THICKNESS
        CALL HSM_DATA.getByHSM(tmp_rec.COIL_NO)
        IF CURR_STATION_CODE == 'L' AND
            NotExistD(PCM_DATA.ACTL_STATION_CODE) AND
            HSM_DATA.class_code != 'C' THEN
            LET PDI[i].ENTRY_THICKNESS = HSM_DATA.COIL_THICK
        ELSE
            LET PDI[i].ENTRY_THICKNESS = PCM_DATA.COIL_THICK
        END IF
        
        #6. TARGET_THICKNESS
        IF CRM_CODE.getIndexOf(CURR_STATION_CODE, 1) THEN
            LET PDI[i].TARGET_THICKNESS = 0
            
            IF CURR_STATION_CODE == 'N' THEN
                LET PDI[i].TARGET_THICKNESS = (PDI[i].ENTRY_THICKNESS *0.9)
            END IF
            IF CURR_STATION_CODE == 'L' THEN
                SELECT ZMILL_THICK_1 INTO PDI[i].TARGET_THICKNESS
                    FROM pcmb010m WHERE ORDER_NO_ITEM = tmp_rec.ORDER_NO_ITEM
            END IF
            IF CURR_STATION_CODE == 'M' THEN
                SELECT ZMILL_THICK_2 INTO PDI[i].TARGET_THICKNESS
                    FROM pcmb010m WHERE ORDER_NO_ITEM = tmp_rec.ORDER_NO_ITEM
            END IF
        END IF

        IF PDI[i].TARGET_THICKNESS == 0 THEN
            SET CONNECTION "ORD"

            LET PDI[i].TARGET_THICKNESS = ORD_DATA.SHIP_THICK_AIM
            
            IF PDI[i].TARGET_THICKNESS IS NOT NULL THEN
                IF PDI[i].TARGET_THICKNESS > 0.6 AND PDI[i].TARGET_THICKNESS <= 0.9 THEN
                    LET PDI[i].TARGET_THICKNESS = PDI[i].TARGET_THICKNESS + 0.01
                END IF
                IF PDI[i].TARGET_THICKNESS > 0.9 AND PDI[i].TARGET_THICKNESS <= 1.6 THEN
                    LET PDI[i].TARGET_THICKNESS = PDI[i].TARGET_THICKNESS + 0.02
                END IF
                IF PDI[i].TARGET_THICKNESS > 1.6 AND PDI[i].TARGET_THICKNESS <= 2.1 THEN
                    LET PDI[i].TARGET_THICKNESS = PDI[i].TARGET_THICKNESS + 0.03
                END IF
                IF PDI[i].TARGET_THICKNESS > 2.1 AND PDI[i].TARGET_THICKNESS <= 3.3 THEN
                    LET PDI[i].TARGET_THICKNESS = PDI[i].TARGET_THICKNESS + 0.04
                END IF
            ELSE
                LET PDI[i].TARGET_THICKNESS = 0
            END If
        END IF

        #7. 入料外徑 ENTRY_OUTER_DIAMETER
        SET CONNECTION "MIC"
        SELECT DENSITY INTO f_density FROM micm190m
            WHERE GRADE_CODE = PCM_DATA.STEEL_GRADE

        LET PDI[i].ENTRY_OUTER_DIAMETER =
            1000*util.Math.sqrt(
            (PCM_DATA.COIL_WEIGHT*4)/(PCM_DATA.COIL_WIDTH*f_density*3.14)
            + 0.61)

        #8. 入料內徑 ENTRY_INNER_DIAMETER 
        LET PDI[i].ENTRY_INNER_DIAMETER = PCM_DATA.COIL_IN_DIAM

        #9. 出料內徑 EXIT_INNER_DIAMETER
        LET PDI[i].EXIT_INNER_DIAMETER = 610

        #10. 入料重量 ENTRY_WEIGHT 
        LET PDI[i].ENTRY_WEIGHT = PCM_DATA.COIL_WEIGHT

        #11. CLASS_CODE
        LET PDI[i].CLASS_CODE = PCM_DATA.CLASS_CODE

        #12. 檢驗碼 INSPECTION_CODE
        SELECT INSPECTION_CODE, SAMPLING_CODE
            INTO PDI[i].INSPECTION_CODE, s_sample_code
            FROM micm010m
            WHERE MIC_NO = PCM_DATA.ACTL_MIC_NO

        #18. 鋼捲取樣碼 SAMPLING_CODE
        LET PDI[i].SAMPLING_CODE = s_sample_code.subString(4,4)

        #13~17. DEFECT_CODE
        LET PDI[i].DEFECT_CODE01 = PCM_DATA.DEFACT01
        LET PDI[i].DEFECT_CODE02 = PCM_DATA.DEFACT02
        LET PDI[i].DEFECT_CODE03 = PCM_DATA.DEFACT03
        LET PDI[i].DEFECT_CODE04 = PCM_DATA.DEFACT04
        LET PDI[i].DEFECT_CODE05 = PCM_DATA.DEFACT05

        #19. PAPER_CODE
        IF CRM_CODE.getIndexOf(CURR_STATION_CODE, 1) THEN
            SET CONNECTION "ORD"

            LET PDI[i].PAPER_CODE = ORD_DATA.PADDING_CODE
            LET s_sleeve = ORD_DATA.SLEEVE_CODE
            {SELECT PADDING_CODE, SLEEVE_CODE
                INTO   PDI[i].PAPER_CODE, s_sleeve
                FROM   ORDB011M
                WHERE  ORDER_NO||ORDER_ITEM = tmp_rec.ORDER_NO_ITEM}

            IF PCM_DATA.NEXT_STATION == 'REL' THEN
                CASE PDI[i].PAPER_CODE
                    WHEN '1'
                        LET PDI[i].PAPER_CODE = 'A'
                    WHEN '2'
                        LET PDI[i].PAPER_CODE = 'B'
                    WHEN '3'
                        LET PDI[i].PAPER_CODE = 'C'
                    WHEN '4'
                        LET PDI[i].PAPER_CODE = 'D'
                    WHEN '5'
                        LET PDI[i].PAPER_CODE = 'E'
                    OTHERWISE
                        LET PDI[i].PAPER_CODE = 'N'
                END CASE
            ELSE
                LET PDI[i].PAPER_CODE = 'A'
            END IF
        END IF
        
        #20. 出口套筒厚度 EXIT_SLEEVE_THICKNESS
        IF CRM_CODE.getIndexOf(CURR_STATION_CODE, 1) THEN
            CASE TRUE
                WHEN PCM_DATA.NEXT_STATION == 'REL' AND s_sleeve = 'Y'
                    LET PDI[i].EXIT_SLEEVE_THICKNESS = 18
                WHEN PCM_DATA.NEXT_STATION != 'REL' AND 
                        PCM_DATA.NEXT_STATION != 'OEM' AND
                        PDI[i].TARGET_THICKNESS <= 1.00
                    LET PDI[i].EXIT_SLEEVE_THICKNESS = 70
                WHEN PCM_DATA.NEXT_STATION == 'REL' AND s_sleeve = 'S'
                    LET PDI[i].EXIT_SLEEVE_THICKNESS = 60
                OTHERWISE
                    LET PDI[i].EXIT_SLEEVE_THICKNESS = 0
            END CASE
        END IF

        #21. 來源儲位
        SET CONNECTION "WIP"

        SELECT STORAGE_LOCA INTO PDI[i].RETRIEVAL_AREA
        FROM wipy020m
        WHERE COIL_NO = tmp_rec.COIL_NO

        IF SQLCA.sqlcode != 0 THEN
            LET PDI[i].RETRIEVAL_AREA = ' '
        END IF

        #22. 生產型態碼 
        LET baf_pass = FALSE
        FOR j = 2 TO 20
            IF PCM_DATA.ACTL_STATION_CODE[j] == 'B' THEN
                LET baf_pass = TRUE
                EXIT FOR
            END IF
        END FOR

        CASE TRUE
            WHEN PDI[i].STEEL_GRADE[2] == '3'
                LET PDI[i].PRODUCTION_CODE[1] = 'A'
            WHEN PDI[i].STEEL_GRADE[2] == '2'
                LET PDI[i].PRODUCTION_CODE[1] = 'B'
            WHEN PDI[i].STEEL_GRADE[2] == '4' AND baf_pass
                LET PDI[i].PRODUCTION_CODE[1] = 'C'
            WHEN PDI[i].STEEL_GRADE[2] == '4' AND NOT baf_pass
                LET PDI[i].PRODUCTION_CODE[1] = 'N'
            OTHERWISE
                LET PDI[i].PRODUCTION_CODE[1] = ' '
        END CASE

        LET PDI[i].PRODUCTION_CODE[2] = PCM_DATA.ACTL_STATION_CODE[1]

        #23. APN_NO
        #31. DELIVERY_DATE
        LET PDI[i].DELIVERY_DATE = PCM100_DATA.DELIVERY_DATE
        LET PDI[i].APN_NO =PCM100_DATA.APN_NO
        {SET CONNECTION "PCM"
        SELECT CAST(DELIVERY_DATE AS CHAR(14)), APN_NO
        INTO PDI[i].DELIVERY_DATE, PDI[i].APN_NO
        FROM PCMB100M
        WHERE   ORDER_NO||ORDER_ITEM = tmp_rec.ORDER_NO_ITEM}

        #24~30. 
        LET PDI[i].UPD_DATE = TODAY USING "yyyymmdd"
        LET PDI[i].UPD_TIME = util.Datetime.format(TIME(CURRENT), "%H%M%S")
        LET PDI[i].USER_NAME = fgl_getenv("g_user_id")
        LET PDI[i].PROG_NAME = "CPSCR601_GenPDI"
        LET PDI[i].FACTORY = PCM_DATA.FACTORY
        LET PDI[i].QC_COMMENT = PCM_DATA.QC_COMMENT
        LET PDI[i].ORDER_NO_ITEM = PCM_DATA.CB_FIRST_ORDER_ITEM

        #32. 軋下率
        LET PDI[i].REDUCTION = 
            (PDI[i].ENTRY_THICKNESS - PDI[i].TARGET_THICKNESS)
            /
            PDI[i].ENTRY_THICKNESS * 100

        #化學成分
        CALL PDI[i].getChemCompn(PCM_DATA.HEAT_NO)
        
        #insert/update PDI db
        CALL PDI[i].db_PDI_IU()
    END FOR
END FUNCTION

#--------------------------------------------------
# For 5. ENTRY_THICKNESS
# 製程路徑是否含代碼D
#--------------------------------------------------
FUNCTION NotExistD(src CHAR(20))
    DEFINE exist BOOLEAN
    DEFINE i INTEGER

    LET exist = TRUE

    FOR i = 3 TO 20
        IF src[i] == 'D' THEN
            LET exist = FALSE
            EXIT FOR
        END IF
    END FOR
    
    RETURN exist
END FUNCTION