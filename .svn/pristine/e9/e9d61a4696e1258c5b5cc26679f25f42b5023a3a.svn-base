IMPORT util
IMPORT FGL fgldialog
IMPORT FGL CPSCR6_INC
IMPORT FGL CRM_INC
GLOBALS "../Library/glb.4gl"
SCHEMA oracr2

#------------------------------------------------------------------------------
# CZFP210M
#------------------------------------------------------------------------------
PUBLIC TYPE CZFP210M RECORD
    COIL_NO LIKE CZFP210M.COIL_NO, #鋼捲號碼
    COIL_STATUS LIKE CZFP210M.COIL_STATUS, #鋼捲狀態碼
    STEEL_GRADE LIKE CZFP210M.STEEL_GRADE, #鋼種
    ENTRY_WIDTH LIKE CZFP210M.ENTRY_WIDTH, #入料寬度
    ENTRY_THICKNESS LIKE CZFP210M.ENTRY_THICKNESS, #入料厚度
    TARGET_THICKNESS LIKE CZFP210M.TARGET_THICKNESS, #目標厚度
    ENTRY_OUTER_DIAMETER LIKE CZFP210M.ENTRY_OUTER_DIAMETER, #入料外徑
    ENTRY_INNER_DIAMETER LIKE CZFP210M.ENTRY_INNER_DIAMETER, #入料內徑
    EXIT_INNER_DIAMETER LIKE CZFP210M.EXIT_INNER_DIAMETER, #出料內徑
    ENTRY_WEIGHT LIKE CZFP210M.ENTRY_WEIGHT, #入料重量
    CLASS_CODE LIKE CZFP210M.CLASS_CODE, #等級碼
    INSPECTION_CODE LIKE CZFP210M.INSPECTION_CODE, #檢驗碼
    DEFECT_CODE01 LIKE CZFP210M.DEFECT_CODE01, #第一個缺陷碼
    DEFECT_CODE02 LIKE CZFP210M.DEFECT_CODE02, #第二個缺陷碼
    DEFECT_CODE03 LIKE CZFP210M.DEFECT_CODE03, #第三個缺陷碼
    DEFECT_CODE04 LIKE CZFP210M.DEFECT_CODE04, #第四個缺陷碼
    DEFECT_CODE05 LIKE CZFP210M.DEFECT_CODE05, #第五個缺陷碼
    SAMPLING_CODE LIKE CZFP210M.SAMPLING_CODE, #鋼捲夾層紙代碼
    PAPER_CODE LIKE CZFP210M.PAPER_CODE, #襯紙類別
    EXIT_SLEEVE_THICKNESS LIKE CZFP210M.EXIT_SLEEVE_THICKNESS, #出口套筒厚度
    RETRIEVAL_AREA LIKE CZFP210M.RETRIEVAL_AREA, #訂單區域
    PRODUCTION_CODE LIKE CZFP210M.PRODUCTION_CODE, #生產型態碼
    APN_NO LIKE CZFP210M.APN_NO, #用途碼
    UPD_DATE LIKE CZFP210M.UPD_DATE, #維護日期
    UPD_TIME LIKE CZFP210M.UPD_TIME, #維護時間
    USER_NAME LIKE CZFP210M.USER_NAME, #維護人員
    PROG_NAME LIKE CZFP210M.PROG_NAME, #維護程式
    FACTORY LIKE CZFP210M.FACTORY, #廠別
    QC_COMMENT LIKE CZFP210M.QC_COMMENT, #覆判備註
    ORDER_NO_ITEM LIKE CZFP210M.ORDER_NO_ITEM, #訂單編號項次
    DELIVERY_DATE LIKE CZFP210M.DELIVERY_DATE, #交期
    REDUCTION LIKE CZFP210M.REDUCTION, #軋下率
    CU LIKE CZFP210M.CU, #化學成分 銅
    ZN LIKE CZFP210M.ZN, #化學成分 鋅
    PB LIKE CZFP210M.PB, #化學成分 鉛
    P LIKE CZFP210M.P, #化學成分 磷
    SN LIKE CZFP210M.SN, #化學成分 錫
    AL LIKE CZFP210M.AL, #化學成分 鋁
    MN LIKE CZFP210M.MN, #化學成分 錳
    NI LIKE CZFP210M.NI, #化學成分 鎳
    CR LIKE CZFP210M.CR, #化學成分 鉻
    TI LIKE CZFP210M.TI, #化學成分 鈦
    ZR LIKE CZFP210M.ZR, #化學成分 鋯
    SI LIKE CZFP210M.SI, #化學成分 矽
    CO LIKE CZFP210M.CO, #化學成分 鈷
    S LIKE CZFP210M.S, #化學成分 硫
    SE LIKE CZFP210M.SE, #化學成分 硒
    C LIKE CZFP210M.C, #化學成分 碳
    B LIKE CZFP210M.B, #化學成分 硼
    MO LIKE CZFP210M.MO, #化學成分 鉬
    NB LIKE CZFP210M.NB, #化學成分 鈮
    V LIKE CZFP210M.V, #化學成分 釩
    W LIKE CZFP210M.W #化學成分 鎢
END RECORD

PUBLIC TYPE CZFP210M_LIST RECORD 
    arr DYNAMIC ARRAY OF CZFP210M,
    focus_PDI CZFP210M
END RECORD

#------------------------------------------------------------------------------
# select CZFP210M
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP210M) getCZFP210M()
    SET CONNECTION "CR2"
    
    SELECT * INTO src_rec.* FROM CZFP210M WHERE COIL_NO = src_rec.coil_no
END FUNCTION

#------------------------------------------------------------------------------
#  update CZFP210M
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP210M) updCZFP210M()
    SET CONNECTION "CR2"
    
    UPDATE CZFP210M SET
        COIL_STATUS = NVL(src_rec.COIL_STATUS, COIL_STATUS),
        STEEL_GRADE = NVL(src_rec.STEEL_GRADE, STEEL_GRADE),
        ENTRY_WIDTH = NVL(src_rec.ENTRY_WIDTH, ENTRY_WIDTH),
        ENTRY_THICKNESS = NVL(src_rec.ENTRY_THICKNESS, ENTRY_THICKNESS),
        TARGET_THICKNESS = NVL(src_rec.TARGET_THICKNESS, TARGET_THICKNESS),
        ENTRY_OUTER_DIAMETER = NVL(src_rec.ENTRY_OUTER_DIAMETER, ENTRY_OUTER_DIAMETER),
        ENTRY_INNER_DIAMETER = NVL(src_rec.ENTRY_INNER_DIAMETER, ENTRY_INNER_DIAMETER),
        EXIT_INNER_DIAMETER = NVL(src_rec.EXIT_INNER_DIAMETER, EXIT_INNER_DIAMETER),
        ENTRY_WEIGHT = NVL(src_rec.ENTRY_WEIGHT, ENTRY_WEIGHT),
        CLASS_CODE = NVL(src_rec.CLASS_CODE, CLASS_CODE),
        INSPECTION_CODE = NVL(src_rec.INSPECTION_CODE, INSPECTION_CODE),
        DEFECT_CODE01 = NVL(src_rec.DEFECT_CODE01, DEFECT_CODE01),
        DEFECT_CODE02 = NVL(src_rec.DEFECT_CODE02, DEFECT_CODE02),
        DEFECT_CODE03 = NVL(src_rec.DEFECT_CODE03, DEFECT_CODE03),
        DEFECT_CODE04 = NVL(src_rec.DEFECT_CODE04, DEFECT_CODE04),
        DEFECT_CODE05 = NVL(src_rec.DEFECT_CODE05, DEFECT_CODE05),
        SAMPLING_CODE = NVL(src_rec.SAMPLING_CODE, SAMPLING_CODE),
        PAPER_CODE = NVL(src_rec.PAPER_CODE, PAPER_CODE),
        EXIT_SLEEVE_THICKNESS = NVL(src_rec.EXIT_SLEEVE_THICKNESS, EXIT_SLEEVE_THICKNESS),
        RETRIEVAL_AREA = NVL(src_rec.RETRIEVAL_AREA, RETRIEVAL_AREA),
        PRODUCTION_CODE = NVL(src_rec.PRODUCTION_CODE, PRODUCTION_CODE),
        APN_NO = NVL(src_rec.APN_NO, APN_NO),
        UPD_DATE = NVL(src_rec.UPD_DATE, UPD_DATE),
        UPD_TIME = NVL(src_rec.UPD_TIME, UPD_TIME),
        USER_NAME = NVL(src_rec.USER_NAME, USER_NAME),
        PROG_NAME = NVL(src_rec.PROG_NAME, PROG_NAME),
        FACTORY = NVL(src_rec.FACTORY, FACTORY),
        QC_COMMENT = NVL(src_rec.QC_COMMENT, QC_COMMENT),
        ORDER_NO_ITEM = NVL(src_rec.ORDER_NO_ITEM, ORDER_NO_ITEM),
        DELIVERY_DATE = NVL(src_rec.DELIVERY_DATE, DELIVERY_DATE),
        REDUCTION = NVL(src_rec.REDUCTION, REDUCTION),
        CU = NVL(src_rec.CU, CU),
        ZN = NVL(src_rec.ZN, ZN),
        PB = NVL(src_rec.PB, PB),
        P = NVL(src_rec.P, P),
        SN = NVL(src_rec.SN, SN),
        AL = NVL(src_rec.AL, AL),
        MN = NVL(src_rec.MN, MN),
        NI = NVL(src_rec.NI, NI),
        CR = NVL(src_rec.CR, CR),
        TI = NVL(src_rec.TI, TI),
        ZR = NVL(src_rec.ZR, ZR),
        SI = NVL(src_rec.SI, SI),
        CO = NVL(src_rec.CO, CO),
        S = NVL(src_rec.S, S),
        SE = NVL(src_rec.SE, SE),
        C = NVL(src_rec.C, C),
        B = NVL(src_rec.B, B),
        MO = NVL(src_rec.MO, MO),
        NB = NVL(src_rec.NB, NB),
        V = NVL(src_rec.V, V),
        W = NVL(src_rec.W, W)
    WHERE COIL_NO = src_rec.COIL_NO
END FUNCTION

#------------------------------------------------------------------------------
# insert CZFP210M
#------------------------------------------------------------------------------
FUNCTION (src_rec CZFP210M) insCZFP210M()
    SET CONNECTION "CR2"
    
    INSERT INTO CZFP210M VALUES(
        src_rec.*
        )
END FUNCTION

#----------------------------------------------------------------------
#delete from CZFP210M
#----------------------------------------------------------------------
FUNCTION (src_rec CZFP210M) delCZFP210M()
    SET CONNECTION "CR2"

    IF src_rec.COIL_NO = '*' THEN
        DELETE FROM CZFP210M
    ELSE
        DELETE FROM CZFP210M WHERE COIL_NO = src_rec.COIL_NO
    END IF
END FUNCTION

#------------------------------------------------------------------------------
# CZFP210M - 由PCMB020M.HEAT_NO從HPC取得化學成分
#------------------------------------------------------------------------------
PUBLIC FUNCTION (PDI CZFP210M) getChemCompn(arg_heat_no CHAR (8))
    SET CONNECTION "HPC"
    SELECT CU, ZN, PB, P, SN, AL,
            MN, NI, CR, TI, ZR, SI,
            CO, S, SE, C, B, MO,
            NB, V, W
    INTO
        PDI.CU, PDI.ZN, PDI.PB, PDI.P, PDI.SN, PDI.AL,
        PDI.MN, PDI.NI, PDI.CR, PDI.TI, PDI.ZR, PDI.SI,
        PDI.CO, PDI.S, PDI.SE, PDI.C, PDI.B, PDI.MO,
        PDI.NB, PDI.V, PDI.W
    FROM HPCY130M
    WHERE HEAT_NO = arg_heat_no
END FUNCTION

#------------------------------------------------------------------------------
# CZFP210M - 傳輸MSG生成method
#------------------------------------------------------------------------------
PUBLIC FUNCTION (pdi CZFP210M) genCZFP210M_BC01Msg() RETURNS CRM_INC.L3MSG
    DEFINE tmp STRING
    DEFINE msg CRM_INC.L3MSG
    DEFINE char4 CHAR(4)

    LET msg.class = "BC01"
    
    LET tmp = util.Datetime.format(CURRENT,"%Y%m%d%H%M%S")
    #LET msghdr = msghdr || tmp
    LET msg.date = tmp.subString(1,8)
    LET msg.time = tmp.subString(9,14)

    LET msg.sender = "533"
    LET msg.receiver = "501"

    LET msg.len = "000146"

    LET msg.coil_no = pdi.COIL_NO
    
    LET msg.bufData = pdi.COIL_NO
    LET msg.bufData = msg.bufData || pdi.COIL_STATUS
    LET msg.bufData = msg.bufData || pdi.STEEL_GRADE

    LET char4 = pdi.ENTRY_WIDTH
    LET msg.bufData = msg.bufData || char4
   
    LET char4 = DotRemove(pdi.ENTRY_THICKNESS USING "&.&&&")
    LET msg.bufData = msg.bufData || char4

    LET char4 = DotRemove(pdi.TARGET_THICKNESS USING "&.&&&")
    LET msg.bufData = msg.bufData || char4

    LET msg.bufData = msg.bufData || (pdi.ENTRY_OUTER_DIAMETER USING "&&&&")
    LET msg.bufData = msg.bufData || (pdi.ENTRY_INNER_DIAMETER USING "&&&")
    LET msg.bufData = msg.bufData || (pdi.EXIT_INNER_DIAMETER USING "&&&")
    LET msg.bufData = msg.bufData || (pdi.ENTRY_WEIGHT USING "&&&&&")

    LET msg.bufData = msg.bufData || pdi.CLASS_CODE
    LET msg.bufData = msg.bufData || pdi.INSPECTION_CODE
    LET msg.bufData = msg.bufData || pdi.DEFECT_CODE01
    LET msg.bufData = msg.bufData || pdi.DEFECT_CODE02
    LET msg.bufData = msg.bufData || pdi.DEFECT_CODE03
    LET msg.bufData = msg.bufData || pdi.DEFECT_CODE04
    LET msg.bufData = msg.bufData || pdi.DEFECT_CODE05

    LET msg.bufData = msg.bufData || pdi.SAMPLING_CODE
    LET msg.bufData = msg.bufData || pdi.PAPER_CODE
    
    LET msg.bufData = msg.bufData || (pdi.EXIT_SLEEVE_THICKNESS USING "&&")
    LET msg.bufData = msg.bufData || pdi.RETRIEVAL_AREA
    LET msg.bufData = msg.bufData || pdi.PRODUCTION_CODE
    LET msg.bufData = msg.bufData || pdi.APN_NO

    RETURN msg
END FUNCTION

FUNCTION DotRemove(src STRING)
    DEFINE i, len INTEGER
    DEFINE res STRING
    
    LET len = src.getLength()

    FOR i = 1 TO len
        IF src.getCharAt(i) == "." THEN
            LET res = src.subString(1, i-1)
            LET res = res || src.subString(i+1, len)

            EXIT FOR
        END IF
    END FOR

    RETURN res
END FUNCTION

#------------------------------------------------------------------------------
# CZFP210M - INSERT/UPDATE PDI TO DB
#------------------------------------------------------------------------------
PUBLIC FUNCTION (PDI CZFP210M) db_PDI_IU()
    SET CONNECTION "CR2"
    SELECT COIL_NO FROM czfp210m WHERE COIL_NO = PDI.COIL_NO
    IF SQLCA.sqlcode = 100 THEN
        #INSERT INTO czfp210m VALUES(PDI.*)
        CALL PDI.insCZFP210M()
    ELSE
        CALL PDI.updCZFP210M()
    END IF
END FUNCTION

{
#------------------------------------------------------------------------------
# CZFP210M_LIST - UPDATE PDI ARRAY By COIL LIST
#------------------------------------------------------------------------------
FUNCTION (src_list CZFP210M_LIST) updByCoilList(arg_list COIL_LIST)
    DEFINE i, len INTEGER
    
    LET len = arg_list.arr.getLength()
    CALL src_list.arr.clear()
    
    FOR i = 1 TO len
        LET src_list.arr[i].COIL_NO = arg_list.arr[i].COIL_NO
        CALL src_list.arr[i].getCZFP210M()
    END FOR
END FUNCTION}
