SCHEMA oracps


PUBLIC TYPE CCAA030M RECORD
	coil_number LIKE ccaa030m.coil_number,
	schedule_number LIKE ccaa030m.schedule_number,
	steel_grade LIKE ccaa030m.steel_grade,
	start_date LIKE ccaa030m.start_date,
	start_time LIKE ccaa030m.start_time,
	finish_date LIKE ccaa030m.finish_date,
	finish_time LIKE ccaa030m.finish_time,
	actual_thickness LIKE ccaa030m.actual_thickness,
	actual_width LIKE ccaa030m.actual_width,
	theo_length LIKE ccaa030m.theo_length,
	actual_length LIKE ccaa030m.actual_length,
	entry_weight LIKE ccaa030m.entry_weight,
	theo_weight LIKE ccaa030m.theo_weight,
	actual_weight LIKE ccaa030m.actual_weight,
	theo_outer_diameter LIKE ccaa030m.theo_outer_diameter,
	actual_outer_diameter LIKE ccaa030m.actual_outer_diameter,
	exit_sleeve_thickness LIKE ccaa030m.exit_sleeve_thickness,
	storage_area LIKE ccaa030m.storage_area,
	class_code LIKE ccaa030m.class_code,
	paper_code LIKE ccaa030m.paper_code,
	production_code LIKE ccaa030m.production_code,
	uncoiling_type LIKE ccaa030m.uncoiling_type,
	recoiling_type LIKE ccaa030m.recoiling_type,
	defect_code1 LIKE ccaa030m.defect_code1,
	defect_code2 LIKE ccaa030m.defect_code2,
	defect_code3 LIKE ccaa030m.defect_code3,
	defect_code4 LIKE ccaa030m.defect_code4,
	defect_code5 LIKE ccaa030m.defect_code5,
	defect_code6 LIKE ccaa030m.defect_code6,
	defect_code7 LIKE ccaa030m.defect_code7,
	defect_code8 LIKE ccaa030m.defect_code8,
	defect_code9 LIKE ccaa030m.defect_code9,
	defect_code10 LIKE ccaa030m.defect_code10,
	application_code LIKE ccaa030m.application_code,
	grinding_parm LIKE ccaa030m.grinding_parm,
	running_mode_cpl LIKE ccaa030m.running_mode_cpl,
	running_mode_gpl LIKE ccaa030m.running_mode_gpl,
	grinding_mode LIKE ccaa030m.grinding_mode,
	running_mode_spm LIKE ccaa030m.running_mode_spm,
	roughness_code LIKE ccaa030m.roughness_code,
	from_code LIKE ccaa030m.from_code,
	dcs_flag LIKE ccaa030m.dcs_flag,
	cpd_flag LIKE ccaa030m.cpd_flag,
	send_flag LIKE ccaa030m.send_flag,
	upd_date LIKE ccaa030m.upd_date,
	upd_time LIKE ccaa030m.upd_time,
	user_name LIKE ccaa030m.user_name,
	prog_name LIKE ccaa030m.prog_name,
	transfer LIKE ccaa030m.transfer,
	lock LIKE ccaa030m.lock,
	shift_no LIKE ccaa030m.shift_no,
	shift_date LIKE ccaa030m.shift_date,
	qc_lock LIKE ccaa030m.qc_lock,
	mother_COIL_NUMBER LIKE ccaa030m.MOTHER_COIL_NO,
	pdi_weight LIKE ccaa030m.pdi_weight,
	spare_int LIKE ccaa030m.spare_int,
	spare_real LIKE ccaa030m.spare_real,
	spare_char LIKE ccaa030m.spare_char,
	upper_roughness LIKE ccaa030m.upper_roughness,
	under_roughness LIKE ccaa030m.under_roughness,
	oem_no LIKE ccaa030m.oem_no,
	white_spot_h LIKE ccaa030m.white_spot_h,
	white_spot_m LIKE ccaa030m.white_spot_m,
	white_spot_e LIKE ccaa030m.white_spot_e,
	qc_code LIKE ccaa030m.qc_code,
	qc_station LIKE ccaa030m.qc_station,
	qc_comment LIKE ccaa030m.qc_comment,
	l2_confirm LIKE ccaa030m.l2_confirm,
	spm_elongation LIKE ccaa030m.spm_elongation,
	running_mode_cap LIKE ccaa030m.running_mode_cap,
	play_code LIKE ccaa030m.play_code,
	edging LIKE ccaa030m.edging,
	surface_code LIKE ccaa030m.surface_code

END RECORD

#------------------------------------------------------------------------------
# select CCAA030M
#------------------------------------------------------------------------------
PUBLIC FUNCTION (src_rec CCAA030M) getCCAA030M()
    SET CONNECTION "CPS"

    SELECT * INTO src_rec.* FROM CCAA030M
        WHERE coil_number = src_rec.coil_number AND schedule_number = src_rec.schedule_number
END FUNCTION



#------------------------------------------------------------------------------
#  update CCAA030M
#------------------------------------------------------------------------------
FUNCTION (src_rec CCAA030M) updCCAA030M()
    SET CONNECTION "CPS"
    
    UPDATE CCAA030M SET
    coil_number = NVL(src_rec.coil_number),
    schedule_number = NVL(src_rec.schedule_number),
    steel_grade = NVL(src_rec.steel_grade),
    start_date = NVL(src_rec.start_date),
    start_time = NVL(src_rec.start_time),
    finish_date = NVL(src_rec.finish_date),
    finish_time = NVL(src_rec.finish_time),
    actual_thickness = NVL(src_rec.actual_thickness),
    actual_width = NVL(src_rec.actual_width),
    theo_length = NVL(src_rec.theo_length),
    actual_length = NVL(src_rec.actual_length),
    entry_weight = NVL(src_rec.entry_weight),
    theo_weight = NVL(src_rec.theo_weight),
    actual_weight = NVL(src_rec.actual_weight),
    theo_outer_diameter = NVL(src_rec.theo_outer_diameter),
    actual_outer_diameter = NVL(src_rec.actual_outer_diameter),
    exit_sleeve_thickness = NVL(src_rec.exit_sleeve_thickness),
    storage_area = NVL(src_rec.storage_area),
    class_code = NVL(src_rec.class_code),
    paper_code = NVL(src_rec.paper_code),
    production_code = NVL(src_rec.production_code),
    uncoiling_type = NVL(src_rec.uncoiling_type),
    recoiling_type = NVL(src_rec.recoiling_type),
    defect_code1 = NVL(src_rec.defect_code1),
    defect_code2 = NVL(src_rec.defect_code2),
    defect_code3 = NVL(src_rec.defect_code3),
    defect_code4 = NVL(src_rec.defect_code4),
    defect_code5 = NVL(src_rec.defect_code5),
    defect_code6 = NVL(src_rec.defect_code6),
    defect_code7 = NVL(src_rec.defect_code7),
    defect_code8 = NVL(src_rec.defect_code8),
    defect_code9 = NVL(src_rec.defect_code9),
    defect_code10 = NVL(src_rec.defect_code10),
    application_code = NVL(src_rec.application_code),
    grinding_parm = NVL(src_rec.grinding_parm),
    running_mode_cpl = NVL(src_rec.running_mode_cpl),
    running_mode_gpl = NVL(src_rec.running_mode_gpl),
    grinding_mode = NVL(src_rec.grinding_mode),
    running_mode_spm = NVL(src_rec.running_mode_spm),
    roughness_code = NVL(src_rec.roughness_code),
    from_code = NVL(src_rec.from_code),
    dcs_flag = NVL(src_rec.dcs_flag),
    cpd_flag = NVL(src_rec.cpd_flag),
    send_flag = NVL(src_rec.send_flag),
    upd_date = NVL(src_rec.upd_date),
    upd_time = NVL(src_rec.upd_time),
    user_name = NVL(src_rec.user_name),
    prog_name = NVL(src_rec.prog_name),
    transfer = NVL(src_rec.transfer),
    lock = NVL(src_rec.lock),
    shift_no = NVL(src_rec.shift_no),
    shift_date = NVL(src_rec.shift_date),
    qc_lock = NVL(src_rec.qc_lock),
    mother_COIL_NUMBER = NVL(src_rec.mother_COIL_NUMBER),
    pdi_weight = NVL(src_rec.pdi_weight),
    spare_int = NVL(src_rec.spare_int),
    spare_real = NVL(src_rec.spare_real),
    spare_char = NVL(src_rec.spare_char),
    upper_roughness = NVL(src_rec.upper_roughness),
    under_roughness = NVL(src_rec.under_roughness),
    oem_no = NVL(src_rec.oem_no),
    white_spot_h = NVL(src_rec.white_spot_h),
    white_spot_m = NVL(src_rec.white_spot_m),
    white_spot_e = NVL(src_rec.white_spot_e),
    qc_code = NVL(src_rec.qc_code),
    qc_station = NVL(src_rec.qc_station),
    qc_comment = NVL(src_rec.qc_comment),
    l2_confirm = NVL(src_rec.l2_confirm),
    spm_elongation = NVL(src_rec.spm_elongation),
    running_mode_cap = NVL(src_rec.running_mode_cap),
    play_code = NVL(src_rec.play_code),
    edging = NVL(src_rec.edging),
    surface_code = NVL(src_rec.surface_code)
    WHERE coil_number = src_rec.coil_number
        AND schedule_number = src_rec.schedule_number
END FUNCTION

#----------------------------------------------------------------------
#delete from CCAA030M
#----------------------------------------------------------------------
FUNCTION (src_rec CCAA030M) delCCAA030M()
    SET CONNECTION "CPS"

    IF src_rec.coil_number = '*' THEN
        DELETE FROM CCAA030M
    ELSE
        DELETE FROM CCAA030M 
            WHERE coil_number = src_rec.coil_number
            AND schedule_number = src_rec.schedule_number
    END IF
END FUNCTION
