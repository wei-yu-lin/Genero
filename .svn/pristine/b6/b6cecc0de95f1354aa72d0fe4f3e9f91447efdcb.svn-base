SCHEMA rdbmic36

FUNCTION fun_turn_to_uppercase(mic_arr, mic_arr_uppercase, idx)
    DEFINE mic_arr DYNAMIC ARRAY OF RECORD
        line_marking LIKE micm310m.LINE_MARKING,
        lm_side LIKE micm310m.LM_SIDE,
        lm_plane LIKE micm310m.LM_PLANE,
        lm_heat_no LIKE micm310m.LM_HEAT_NO,
        lm_coil_no LIKE micm310m.LM_COIL_NO,
        lm_spec LIKE micm310m.LM_SPEC,
        lm_steel_grade LIKE micm310m.LM_STEEL_GRADE,
        lm_surface LIKE micm310m.LM_SURFACE,
        lm_dimemtion LIKE micm310m.LM_DIMEMTION,
        remark LIKE micm310m.REMARK,
        del_rec VARCHAR(1),
        upd_flag BOOLEAN
    END RECORD

    DEFINE mic_arr_uppercase RECORD
        line_marking STRING,
        lm_side STRING,
        lm_plane STRING,
        lm_heat_no STRING,
        lm_coil_no STRING,
        lm_spec STRING,
        lm_steel_grade STRING,
        lm_surface STRING,
        lm_dimemtion STRING,
        remark STRING
    END RECORD
    DEFINE idx SMALLINT

    IF LENGTH(mic_arr[idx].line_marking) > 0 THEN
        LET mic_arr_uppercase.line_marking = mic_arr[idx].line_marking
        LET mic_arr_uppercase.line_marking =
            mic_arr_uppercase.line_marking.toUpperCase()
    ELSE
        LET mic_arr_uppercase.line_marking = " "
    END IF
    IF LENGTH(mic_arr[idx].lm_side) > 0 THEN
        LET mic_arr_uppercase.lm_side = mic_arr[idx].lm_side
        LET mic_arr_uppercase.lm_side = mic_arr_uppercase.lm_side.toUpperCase()
    ELSE
        LET mic_arr_uppercase.lm_side = " "
    END IF
    IF LENGTH(mic_arr[idx].lm_plane) > 0 THEN
        LET mic_arr_uppercase.lm_plane = mic_arr[idx].lm_plane
        LET mic_arr_uppercase.lm_plane =
            mic_arr_uppercase.lm_plane.toUpperCase()
    END IF
    IF LENGTH(mic_arr[idx].lm_heat_no) > 0 THEN
        LET mic_arr_uppercase.lm_heat_no = mic_arr[idx].lm_heat_no
        LET mic_arr_uppercase.lm_heat_no =
            mic_arr_uppercase.lm_heat_no.toUpperCase()
    ELSE
        LET mic_arr_uppercase.lm_heat_no = " "
    END IF
    IF LENGTH(mic_arr[idx].lm_coil_no) > 0 THEN
        LET mic_arr_uppercase.lm_coil_no = mic_arr[idx].lm_coil_no
        LET mic_arr_uppercase.lm_coil_no =
            mic_arr_uppercase.lm_coil_no.toUpperCase()
    ELSE
        LET mic_arr_uppercase.lm_coil_no = " "
    END IF
    IF LENGTH(mic_arr[idx].lm_spec) > 0 THEN
        LET mic_arr_uppercase.lm_spec = mic_arr[idx].lm_spec
        LET mic_arr_uppercase.lm_spec = mic_arr_uppercase.lm_spec.toUpperCase()
    ELSE
        LET mic_arr_uppercase.lm_spec = " "
    END IF
    IF LENGTH(mic_arr[idx].lm_steel_grade) > 0 THEN
        LET mic_arr_uppercase.lm_steel_grade = mic_arr[idx].lm_steel_grade
        LET mic_arr_uppercase.lm_steel_grade =
            mic_arr_uppercase.lm_steel_grade.toUpperCase()
    ELSE
        LET mic_arr_uppercase.lm_steel_grade = " "
    END IF
    IF LENGTH(mic_arr[idx].lm_surface) > 0 THEN
        LET mic_arr_uppercase.lm_surface = mic_arr[idx].lm_surface
        LET mic_arr_uppercase.lm_surface =
            mic_arr_uppercase.lm_surface.toUpperCase()
    ELSE
        LET mic_arr_uppercase.lm_surface = " "
    END IF
    IF LENGTH(mic_arr[idx].lm_dimemtion) > 0 THEN
        LET mic_arr_uppercase.lm_dimemtion = mic_arr[idx].lm_dimemtion
        LET mic_arr_uppercase.lm_dimemtion =
            mic_arr_uppercase.lm_dimemtion.toUpperCase()
    ELSE
        LET mic_arr_uppercase.lm_dimemtion = " "
    END IF
    IF LENGTH(mic_arr[idx].remark) > 0 THEN
        LET mic_arr_uppercase.remark = mic_arr[idx].remark
        LET mic_arr_uppercase.remark = mic_arr_uppercase.remark.toUpperCase()
    ELSE
        LET mic_arr_uppercase.remark = " "
    END IF

    RETURN mic_arr_uppercase.*
END FUNCTION
