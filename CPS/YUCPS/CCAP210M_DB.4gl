IMPORT util
IMPORT FGL fgldialog
IMPORT FGL CPSCAP_INC
IMPORT FGL CRM_INC
GLOBALS "../Library/glb.4gl"
SCHEMA oraCPS

#------------------------------------------------------------------------------
# CCAP210M
#------------------------------------------------------------------------------
PUBLIC TYPE CCAP210M RECORD
    coil_number LIKE ccap210m.coil_number,
	coil_status LIKE ccap210m.coil_status,
	steel_grade LIKE ccap210m.steel_grade,
	entry_width LIKE ccap210m.entry_width,
	entry_thickness LIKE ccap210m.entry_thickness,
	entry_outer_diameter LIKE ccap210m.entry_outer_diameter,
	entry_weight LIKE ccap210m.entry_weight,
	exit_sleeve_thickness LIKE ccap210m.exit_sleeve_thickness,
	retrieval_area LIKE ccap210m.retrieval_area,
	storage_area LIKE ccap210m.storage_area,
	class_code LIKE ccap210m.class_code,
	inspection_code LIKE ccap210m.inspection_code,
	defect_code_1 LIKE ccap210m.defect_code_1,
	defect_code_2 LIKE ccap210m.defect_code_2,
	defect_code_3 LIKE ccap210m.defect_code_3,
	defect_code_4 LIKE ccap210m.defect_code_4,
	defect_code_5 LIKE ccap210m.defect_code_5,
	sampling_code LIKE ccap210m.sampling_code,
	paper_code LIKE ccap210m.paper_code,
	production_code LIKE ccap210m.production_code,
	dividing_code LIKE ccap210m.dividing_code,
	len_pc1 LIKE ccap210m.len_pc1,
	len_pc2 LIKE ccap210m.len_pc2,
	len_pc3 LIKE ccap210m.len_pc3,
	len_pc4 LIKE ccap210m.len_pc4,
	weight_pc1 LIKE ccap210m.weight_pc1,
	weight_pc2 LIKE ccap210m.weight_pc2,
	weight_pc3 LIKE ccap210m.weight_pc3,
	weight_pc4 LIKE ccap210m.weight_pc4,
	recoiling_type LIKE ccap210m.recoiling_type,
	uncoiling_type LIKE ccap210m.uncoiling_type,
	resource_code LIKE ccap210m.resource_code,
	application_code LIKE ccap210m.application_code,
	running_mode_cpl LIKE ccap210m.running_mode_cpl,
	running_mode_spm LIKE ccap210m.running_mode_spm,
	running_mode_gpl LIKE ccap210m.running_mode_gpl,
	roughness_code LIKE ccap210m.roughness_code,
	grinding_mode LIKE ccap210m.grinding_mode,
	target_elongation LIKE ccap210m.target_elongation,
	target_width LIKE ccap210m.target_width,
	target_roll_force LIKE ccap210m.target_roll_force,
	send_flag LIKE ccap210m.send_flag,
	upd_date LIKE ccap210m.upd_date,
	upd_time LIKE ccap210m.upd_time,
	user_name LIKE ccap210m.user_name,
	prog_name LIKE ccap210m.prog_name,
	gpl_side LIKE ccap210m.gpl_side,
	mark_position LIKE ccap210m.mark_position,
	mark_factory LIKE ccap210m.mark_factory,
	mark_heat_no LIKE ccap210m.mark_heat_no,
	mark_prod_no LIKE ccap210m.mark_prod_no,
	mark_spec LIKE ccap210m.mark_spec,
	mark_grade LIKE ccap210m.mark_grade,
	mark_surface LIKE ccap210m.mark_surface,
	mark_thickness LIKE ccap210m.mark_thickness,
	mark_width LIKE ccap210m.mark_width,
	mark_thick_unit LIKE ccap210m.mark_thick_unit,
	mark_width_unit LIKE ccap210m.mark_width_unit,
	spm_elongation LIKE ccap210m.spm_elongation,
	running_mode_cap LIKE ccap210m.running_mode_cap,
	play_code LIKE ccap210m.play_code,
	c LIKE ccap210m.c,
	si LIKE ccap210m.si,
	cr LIKE ccap210m.cr,
	mn LIKE ccap210m.mn,
	p LIKE ccap210m.p,
	s LIKE ccap210m.s,
	cu LIKE ccap210m.cu,
	ni LIKE ccap210m.ni,
	mo LIKE ccap210m.mo,
	v LIKE ccap210m.v,
	sn LIKE ccap210m.sn,
	nb LIKE ccap210m.nb,
	ti LIKE ccap210m.ti,
	w LIKE ccap210m.w,
	co LIKE ccap210m.co,
	al LIKE ccap210m.al,
	b LIKE ccap210m.b,
	n LIKE ccap210m.n,
	pb LIKE ccap210m.pb,
	ca LIKE ccap210m.ca,
	tll_elongation LIKE ccap210m.tll_elongation,
	apn_no LIKE ccap210m.apn_no
END RECORD

PUBLIC TYPE CCAP210M_LIST RECORD 
    arr DYNAMIC ARRAY OF CCAP210M,
    focus_PDI CCAP210M
END RECORD

#------------------------------------------------------------------------------
# select CCAP210M
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP210M) getCCAP210M()
    SET CONNECTION "CPS"
    
    SELECT * INTO src_rec.* FROM CCAP210M WHERE COIL_NUMBER = src_rec.COIL_NUMBER
END FUNCTION

#------------------------------------------------------------------------------
#  update CCAP210M
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP210M) updCCAP210M()
    SET CONNECTION "CPS"
    
    UPDATE CCAP210M SET
        coil_status = NVL(src_rec.coil_status),
        entry_width = NVL(src_rec.entry_width),
        entry_thickness = NVL(src_rec.entry_thickness),
        entry_outer_diameter = NVL(src_rec.entry_outer_diameter),
        entry_weight = NVL(src_rec.entry_weight),
        exit_sleeve_thickness = NVL(src_rec.exit_sleeve_thickness),
        retrieval_area = NVL(src_rec.retrieval_area),
        storage_area = NVL(src_rec.storage_area),
        class_code = NVL(src_rec.class_code),
        inspection_code = NVL(src_rec.inspection_code),
        defect_code_1 = NVL(src_rec.defect_code_1),
        defect_code_2 = NVL(src_rec.defect_code_2),
        defect_code_3 = NVL(src_rec.defect_code_3),
        defect_code_4 = NVL(src_rec.defect_code_4),
        defect_code_5 = NVL(src_rec.defect_code_5),
        sampling_code = NVL(src_rec.sampling_code),
        paper_code = NVL(src_rec.paper_code),
        production_code = NVL(src_rec.production_code),
        dividing_code = NVL(src_rec.dividing_code),
        len_pc1 = NVL(src_rec.len_pc1),
        len_pc2 = NVL(src_rec.len_pc2),
        len_pc3 = NVL(src_rec.len_pc3),
        len_pc4 = NVL(src_rec.len_pc4),
        weight_pc1 = NVL(src_rec.weight_pc1),
        weight_pc2 = NVL(src_rec.weight_pc2),
        weight_pc3 = NVL(src_rec.weight_pc3),
        weight_pc4 = NVL(src_rec.weight_pc4),
        recoiling_type = NVL(src_rec.recoiling_type),
        uncoiling_type = NVL(src_rec.uncoiling_type),
        resource_code = NVL(src_rec.resource_code),
        application_code = NVL(src_rec.application_code),
        running_mode_cpl = NVL(src_rec.running_mode_cpl),
        running_mode_spm = NVL(src_rec.running_mode_spm),
        running_mode_gpl = NVL(src_rec.running_mode_gpl),
        roughness_code = NVL(src_rec.roughness_code),
        grinding_mode = NVL(src_rec.grinding_mode),
        target_elongation = NVL(src_rec.target_elongation),
        target_width = NVL(src_rec.target_width),
        target_roll_force = NVL(src_rec.target_roll_force),
        send_flag = NVL(src_rec.send_flag),
        upd_date = NVL(src_rec.upd_date),
        upd_time = NVL(src_rec.upd_time),
        user_name = NVL(src_rec.user_name),
        prog_name = NVL(src_rec.prog_name),
        gpl_side = NVL(src_rec.gpl_side),
        mark_position = NVL(src_rec.mark_position),
        mark_factory = NVL(src_rec.mark_factory),
        mark_heat_no = NVL(src_rec.mark_heat_no),
        mark_prod_no = NVL(src_rec.mark_prod_no),
        mark_spec = NVL(src_rec.mark_spec),
        mark_grade = NVL(src_rec.mark_grade),
        mark_surface = NVL(src_rec.mark_surface),
        mark_thickness = NVL(src_rec.mark_thickness),
        mark_width = NVL(src_rec.mark_width),
        mark_thick_unit = NVL(src_rec.mark_thick_unit),
        mark_width_unit = NVL(src_rec.mark_width_unit),
        spm_elongation = NVL(src_rec.spm_elongation),
        running_mode_cap = NVL(src_rec.running_mode_cap),
        play_code = NVL(src_rec.play_code),
        c = NVL(src_rec.c),
        si = NVL(src_rec.si),
        cr = NVL(src_rec.cr),
        mn = NVL(src_rec.mn),
        p = NVL(src_rec.p),
        s = NVL(src_rec.s),
        cu = NVL(src_rec.cu),
        ni = NVL(src_rec.ni),
        mo = NVL(src_rec.mo),
        v = NVL(src_rec.v),
        sn = NVL(src_rec.sn),
        nb = NVL(src_rec.nb),
        ti = NVL(src_rec.ti),
        w = NVL(src_rec.w),
        co = NVL(src_rec.co),
        al = NVL(src_rec.al),
        b = NVL(src_rec.b),
        n = NVL(src_rec.n),
        pb = NVL(src_rec.pb),
        ca = NVL(src_rec.ca),
        tll_elongation = NVL(src_rec.tll_elongation),
        apn_no = NVL(src_rec.apn_no)
    WHERE COIL_NUMBER = src_rec.COIL_NUMBER
END FUNCTION

#------------------------------------------------------------------------------
# insert CCAP210M
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAP210M) insCCAP210M()
    SET CONNECTION "CPS"
    
    INSERT INTO CCAP210M VALUES(
        src_rec.*
        )
END FUNCTION

#----------------------------------------------------------------------
#delete from CCAP210M
#----------------------------------------------------------------------
FUNCTION (src_rec CCAP210M) delCCAP210M()
    SET CONNECTION "CPS"

    IF src_rec.COIL_NUMBER = '*' THEN
        DELETE FROM CCAP210M
    ELSE
        DELETE FROM CCAP210M WHERE COIL_NUMBER = src_rec.COIL_NUMBER
    END IF
END FUNCTION

#------------------------------------------------------------------------------
# CCAP210M - 由PCMB020M.HEAT_NO從HPC取得化學成分
#------------------------------------------------------------------------------
PUBLIC FUNCTION (PDI CCAP210M) getChemCompn(arg_heat_no CHAR (8))
    SET CONNECTION "HPC"
    SELECT CU, N, PB, P, SN, AL,
            MN, NI, CR, TI, CA, SI,
            CO, S, C, B, MO,
            NB, V, W
    INTO
        PDI.CU, PDI.N, PDI.PB, PDI.P, PDI.SN, PDI.AL,
        PDI.MN, PDI.NI, PDI.CR, PDI.TI, PDI.CA, PDI.SI,
        PDI.CO, PDI.S, PDI.C, PDI.B, PDI.MO,
        PDI.NB, PDI.V, PDI.W
    FROM HPCY130M
    WHERE HEAT_NO = arg_heat_no
END FUNCTION

#------------------------------------------------------------------------------
# CCAP210M - 傳輸MSG生成method
#------------------------------------------------------------------------------
PUBLIC FUNCTION (pdi CCAP210M) genCCAP210M_BC01Msg() RETURNS CRM_INC.L3MSG
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

    LET msg.coil_no = pdi.COIL_NUMBER
    
    LET msg.bufData = pdi.COIL_NUMBER
    LET msg.bufData = msg.bufData || pdi.COIL_STATUS
    LET msg.bufData = msg.bufData || pdi.STEEL_GRADE

    LET char4 = pdi.ENTRY_WIDTH
    LET msg.bufData = msg.bufData || char4
   
    LET char4 = DotRemove(pdi.ENTRY_THICKNESS USING "&.&&&")
    LET msg.bufData = msg.bufData || char4

    

    LET msg.bufData = msg.bufData || (pdi.ENTRY_OUTER_DIAMETER USING "&&&&")
    LET msg.bufData = msg.bufData || (pdi.ENTRY_WEIGHT USING "&&&&&")

    LET msg.bufData = msg.bufData || pdi.CLASS_CODE
    LET msg.bufData = msg.bufData || pdi.INSPECTION_CODE
    LET msg.bufData = msg.bufData || pdi.DEFECT_CODE_1
    LET msg.bufData = msg.bufData || pdi.DEFECT_CODE_2
    LET msg.bufData = msg.bufData || pdi.DEFECT_CODE_3
    LET msg.bufData = msg.bufData || pdi.DEFECT_CODE_4
    LET msg.bufData = msg.bufData || pdi.DEFECT_CODE_5

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
# CCAP210M - INSERT/UPDATE PDI TO DB
#------------------------------------------------------------------------------
PUBLIC FUNCTION (PDI CCAP210M) db_PDI_IU()
    SET CONNECTION "CPS"
    SELECT COIL_NUMBER FROM CCAP210M WHERE COIL_NUMBER = PDI.COIL_NUMBER
    IF SQLCA.sqlcode = 100 THEN
        #INSERT INTO CCAP210M VALUES(PDI.*)
        CALL PDI.insCCAP210M()
    ELSE
        CALL PDI.updCCAP210M()
    END IF
END FUNCTION

{
#------------------------------------------------------------------------------
# CCAP210M_LIST - UPDATE PDI ARRAY By COIL LIST
#------------------------------------------------------------------------------
FUNCTION (src_list CCAP210M_LIST) updByCoilList(arg_list COIL_LIST)
    DEFINE i, len INTEGER
    
    LET len = arg_list.arr.getLength()
    CALL src_list.arr.clear()
    
    FOR i = 1 TO len
        LET src_list.arr[i].COIL_NUMBER = arg_list.arr[i].COIL_NUMBER
        CALL src_list.arr[i].getCCAP210M()
    END FOR
END FUNCTION}
