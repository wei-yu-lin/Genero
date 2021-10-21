GLOBALS "../../sys/library/sys_globals.4gl"

SCHEMA rdbmic36
DEFINE micm220f_rec RECORD
     spec LIKE micm210m.SPEC,
     steel_grade_jis LIKE micm210m.STEEL_GRADE_JIS,
     thick_min LIKE micm210m.THICK_MIN,
     thick_max LIKE micm210m.THICK_MAX,
     other LIKE micm210m.OTHER,
     c_min LIKE micm210m.C_MIN,
     c_max LIKE micm210m.C_MAX,
     si_min LIKE micm210m.SI_MIN,
     si_max LIKE micm210m.SI_MAX,
     mn_min LIKE micm210m.MN_MIN,
     mn_max LIKE micm210m.MN_MAX,
     p_min LIKE micm210m.P_MIN,
     p_max LIKE micm210m.P_MAX,
     s_min LIKE micm210m.S_MIN,
     s_max LIKE micm210m.S_MAX,
     ni_min LIKE micm210m.NI_MIN,
     ni_max LIKE micm210m.NI_MAX,
     cr_min LIKE micm210m.CR_MIN,
     cr_max LIKE micm210m.CR_MAX,
     mo_min LIKE micm210m.MO_MIN,
     mo_max LIKE micm210m.MO_MAX,
     n_min LIKE micm210m.N_MIN,
     n_max LIKE micm210m.N_MAX,
     al_min LIKE micm210m.AL_MIN,
     al_max LIKE micm210m.AL_MAX,
     cu_min LIKE micm210m.CU_MIN,
     cu_max LIKE micm210m.CU_MAX,
     ti_min LIKE micm210m.TI_MIN,
     ti_max LIKE micm210m.TI_MAX,
     nb_min LIKE micm210m.NB_MIN,
     nb_max LIKE micm210m.NB_MAX,
     v_min LIKE micm210m.V_MIN,
     v_max LIKE micm210m.V_MAX,
     ce_min LIKE micm210m.CE_MIN,
     ce_max LIKE micm210m.CE_MAX,
     wc_min LIKE micm210m.WC_MIN,
     wc_max LIKE micm210m.WC_MAX,
     co_min LIKE micm210m.CO_MIN,
     co_max LIKE micm210m.CO_MAX,
     b_min LIKE micm210m.B_MIN,
     b_max LIKE micm210m.B_MAX,
     kfa_min LIKE micm210m.KFA_MIN,
     kfa_max LIKE micm210m.KFA_MAX,
     ys_02_min LIKE micm210m.YS_02_MIN,
     ys_02_max LIKE micm210m.YS_02_MAX,
     ys_10_min LIKE micm210m.YS_10_MIN,
     ys_10_max LIKE micm210m.YS_10_MAX,
     ts_min LIKE micm210m.TS_MIN,
     ts_max LIKE micm210m.TS_MAX,
     elongation_min LIKE micm210m.ELONGATION_MIN,
     elongation_max LIKE micm210m.ELONGATION_MAX,
     hard_hrb_min LIKE micm210m.HARD_HRB_MIN,
     hard_hrb_max LIKE micm210m.HARD_HRB_MAX,
     hard_hv_min LIKE micm210m.HARD_HV_MIN,
     hard_hv_max LIKE micm210m.HARD_HV_MAX,
     hard_hb_min LIKE micm210m.HARD_HB_MIN,
     hard_hb_max LIKE micm210m.HARD_HB_MAX,
     bend_test1 LIKE micm210m.BEND_TEST1,
     bend_test2 LIKE micm210m.BEND_TEST2,
     hard_hrc_min LIKE micm210m.HARD_HRC_MIN,
     hard_hrc_max LIKE micm210m.HARD_HRC_MAX,
     yield_ratio_min LIKE micm210m.YIELD_RATIO_MIN,
     yield_ratio_max LIKE micm210m.YIELD_RATIO_MAX,
     charpy_unit LIKE micm210m.CHARPY_UNIT,
     charpy_min LIKE micm210m.CHARPY_MIN,
     charpy_ave_min LIKE micm210m.CHARPY_AVE_MIN,
     c1_elongation_unit LIKE micm210m.C1_ELONGATION_UNIT,
     c1_elongation_min LIKE micm210m.C1_ELONGATION_MIN,
     c2_elongation_unit LIKE micm210m.C2_ELONGATION_UNIT,
     c2_elongation_min LIKE micm210m.C2_ELONGATION_MIN,
     c3_elongation_unit LIKE micm210m.C3_ELONGATION_UNIT,
     c3_elongation_min LIKE micm210m.C3_ELONGATION_MIN,
     thick_percent_min LIKE micm210m.THICK_PERCENT_MIN,
     thick_percent_max LIKE micm210m.THICK_PERCENT_MAX
    END RECORD
DEFINE micm220f_arr DYNAMIC ARRAY OF RECORD
     spec LIKE micm210m.SPEC,
     steel_grade_jis LIKE micm210m.STEEL_GRADE_JIS,
     thick_min LIKE micm210m.THICK_MIN,
     thick_max LIKE micm210m.THICK_MAX,
     other LIKE micm210m.OTHER,
     c_min LIKE micm210m.C_MIN,
     c_max LIKE micm210m.C_MAX,
     si_min LIKE micm210m.SI_MIN,
     si_max LIKE micm210m.SI_MAX,
     mn_min LIKE micm210m.MN_MIN,
     mn_max LIKE micm210m.MN_MAX,
     p_min LIKE micm210m.P_MIN,
     p_max LIKE micm210m.P_MAX,
     s_min LIKE micm210m.S_MIN,
     s_max LIKE micm210m.S_MAX,
     ni_min LIKE micm210m.NI_MIN,
     ni_max LIKE micm210m.NI_MAX,
     cr_min LIKE micm210m.CR_MIN,
     cr_max LIKE micm210m.CR_MAX,
     mo_min LIKE micm210m.MO_MIN,
     mo_max LIKE micm210m.MO_MAX,
     n_min LIKE micm210m.N_MIN,
     n_max LIKE micm210m.N_MAX,
     al_min LIKE micm210m.AL_MIN,
     al_max LIKE micm210m.AL_MAX,
     cu_min LIKE micm210m.CU_MIN,
     cu_max LIKE micm210m.CU_MAX,
     ti_min LIKE micm210m.TI_MIN,
     ti_max LIKE micm210m.TI_MAX,
     nb_min LIKE micm210m.NB_MIN,
     nb_max LIKE micm210m.NB_MAX,
     v_min LIKE micm210m.V_MIN,
     v_max LIKE micm210m.V_MAX,
     ce_min LIKE micm210m.CE_MIN,
     ce_max LIKE micm210m.CE_MAX,
     wc_min LIKE micm210m.WC_MIN,
     wc_max LIKE micm210m.WC_MAX,
     co_min LIKE micm210m.CO_MIN,
     co_max LIKE micm210m.CO_MAX,
     b_min LIKE micm210m.B_MIN,
     b_max LIKE micm210m.B_MAX,
     kfa_min LIKE micm210m.KFA_MIN,
     kfa_max LIKE micm210m.KFA_MAX,
     ys_02_min LIKE micm210m.YS_02_MIN,
     ys_02_max LIKE micm210m.YS_02_MAX,
     ys_10_min LIKE micm210m.YS_10_MIN,
     ys_10_max LIKE micm210m.YS_10_MAX,
     ts_min LIKE micm210m.TS_MIN,
     ts_max LIKE micm210m.TS_MAX,
     elongation_min LIKE micm210m.ELONGATION_MIN,
     elongation_max LIKE micm210m.ELONGATION_MAX,
     hard_hrb_min LIKE micm210m.HARD_HRB_MIN,
     hard_hrb_max LIKE micm210m.HARD_HRB_MAX,
     hard_hv_min LIKE micm210m.HARD_HV_MIN,
     hard_hv_max LIKE micm210m.HARD_HV_MAX,
     hard_hb_min LIKE micm210m.HARD_HB_MIN,
     hard_hb_max LIKE micm210m.HARD_HB_MAX,
     bend_test1 LIKE micm210m.BEND_TEST1,
     bend_test2 LIKE micm210m.BEND_TEST2,
     hard_hrc_min LIKE micm210m.HARD_HRC_MIN,
     hard_hrc_max LIKE micm210m.HARD_HRC_MAX,
     yield_ratio_min LIKE micm210m.YIELD_RATIO_MIN,
     yield_ratio_max LIKE micm210m.YIELD_RATIO_MAX,
     charpy_unit LIKE micm210m.CHARPY_UNIT,
     charpy_min LIKE micm210m.CHARPY_MIN,
     charpy_ave_min LIKE micm210m.CHARPY_AVE_MIN,
     c1_elongation_unit LIKE micm210m.C1_ELONGATION_UNIT,
     c1_elongation_min LIKE micm210m.C1_ELONGATION_MIN,
     c2_elongation_unit LIKE micm210m.C2_ELONGATION_UNIT,
     c2_elongation_min LIKE micm210m.C2_ELONGATION_MIN,
     c3_elongation_unit LIKE micm210m.C3_ELONGATION_UNIT,
     c3_elongation_min LIKE micm210m.C3_ELONGATION_MIN,
     thick_percent_min LIKE micm210m.THICK_PERCENT_MIN,
     thick_percent_max LIKE micm210m.THICK_PERCENT_MAX     
END RECORD    
DEFINE where_clause STRING
DEFINE curr_idx, max_row SMALLINT
DEFINE idx, mark, curr_pa SMALLINT
#===============================================================================  
#主程式
#==============================================================================
MAIN
    LET channel = "micm220f"
    CALL sys_contro_toolbar(channel, "2")
    CALL ui.Interface.loadStyles("sys_style")

    CLOSE WINDOW SCREEN
    OPEN WINDOW micm220f_f WITH FORM "micm220f" ATTRIBUTES(STYLE = "mystyle")
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
    #CALL w.setText("標準規範資料維護作業")

    CONNECT TO "rdbmic36" AS "MIC"
    SET CONNECTION "MIC"

    MENU ATTRIBUTES(STYLE = "Window.naked")
        COMMAND "micm220f_query"
            CALL micm220f_r()
        COMMAND "micm220f_prev"
            CALL micm220f_n(-1)
        COMMAND "micm220f_next"
            CALL micm220f_n(1)
        COMMAND "micm220f_add"
            CALL micm220f_i()
        COMMAND "micm220f_upd"
            CALL micm220f_u()
        COMMAND "micm220f_del"
            CALL micm220f_d()
        COMMAND KEY(F)
            CALL micm220f_r()
        COMMAND KEY(LEFT)
            CALL micm220f_n(-1)
        COMMAND KEY(RIGHT)
            CALL micm220f_n(1)
        COMMAND KEY(U)
            CALL micm220f_u()
        COMMAND "bye"
            EXIT MENU
    END MENU

    DISCONNECT "MIC"
END MAIN
#--------------------------------------------------------------------
# 查詢1
#--------------------------------------------------------------------
FUNCTION micm220f_r()
    DEFINE spec VARCHAR(15)
    DEFINE steel_grade_jis VARCHAR(15)
    DEFINE cur_idx SMALLINT
    
    TRY
        CLEAR FORM
        CALL micm220f_arr.clear()
        CONSTRUCT BY NAME where_clause ON spec,steel_grade_jis,thick_min
            {BEFORE FIELD spec
                MESSAGE "mic_no 為查詢欄位"}

        
           #按放大鏡 
            ON ACTION spec_find
                #LET curr_pa = ARR_CURR()
                LET spec = ""
                CALL mic_spec() RETURNING spec
                DISPLAY "spec:" , spec
                IF (LENGTH(spec) > 0) THEN  
                    LET micm220f_arr[1].spec = spec
                    DISPLAY micm220f_arr[1].spec TO v_micm220f[1].spec
                END IF
                
                
            #按放大鏡 
            ON ACTION steel_grade_jis_find
                #LET curr_pa = ARR_CURR()
                LET steel_grade_jis = ""
                IF (LENGTH(spec) > 0) THEN
                    CALL mic_steel(spec) RETURNING steel_grade_jis
                ELSE 
                    CALL __Waring_ok("waring", "Please give [spec] first!!") 
                    NEXT FIELD spec
                END IF 
                IF (LENGTH(steel_grade_jis) > 0) THEN  
                    LET micm220f_arr[1].steel_grade_jis = steel_grade_jis
                    DISPLAY micm220f_arr[1].steel_grade_jis TO v_micm220f[1].steel_grade_jis
                END IF  

            ON ACTION bye
                CLEAR FORM
                EXIT CONSTRUCT
           
            {AFTER FIELD spec
                MESSAGE "查詢條件:" || where_clause}
        END CONSTRUCT
        LET where_clause = where_clause
        CALL micm220f_r_query()
    CATCH
        CALL __Waring_ok("Fun", "micn220f_r")
    END TRY

END FUNCTION
#--------------------------------------------------------------------
# 查詢1
#--------------------------------------------------------------------
FUNCTION micm220f_r_query()
    DEFINE idx SMALLINT

    TRY
        DECLARE rec_mast CURSOR FROM 
            " SELECT spec,steel_grade_jis,thick_min,"
            || " thick_max,other,c_min,c_max,si_min,"
            || " si_max,mn_min,mn_max,p_min,p_max,"
            || " s_min,s_max,ni_min,ni_max,cr_min,"
            || " cr_max,mo_min,mo_max,n_min,n_max,"
            || " al_min,al_max,cu_min,cu_max,ti_min,"
            || " ti_max,nb_min,nb_max,v_min,v_max,"
            || " ce_min,ce_max,wc_min,wc_max,co_min,"
            || " co_max,b_min,b_max,kfa_min,kfa_max,"
            || " ys_02_min,ys_02_max,ys_10_min,ys_10_max,"
            || " ts_min,ts_max,elongation_min,elongation_max,"
            || " hard_hrb_min,hard_hrb_max,hard_hv_min,"
            || " hard_hv_max,hard_hb_min,hard_hb_max,"
            || " bend_test1,bend_test2,hard_hrc_min,"
            || " hard_hrc_max,yield_ratio_min,yield_ratio_max,"
            || " charpy_unit,charpy_min,charpy_ave_min,"
            || " c1_elongation_unit,c1_elongation_min,"
            || " c2_elongation_unit,c2_elongation_min,"
            || " c3_elongation_unit,c3_elongation_min,"
            || " thick_percent_min,thick_percent_max "
            || " FROM micm210m"
            || " WHERE "
            || where_clause
            

        LET idx = 0
        LET max_row = 1
        CALL micm220f_arr.clear()
        WHENEVER ERROR CONTINUE
        FOREACH rec_mast INTO micm220f_rec.*
            LET idx = idx + 1
            LET micm220f_arr[idx].* = micm220f_rec.*
        END FOREACH
        WHENEVER ERROR STOP

        FREE rec_mast
        CLOSE rec_mast

        IF (idx > 0) THEN
            LET curr_idx = 1
            DISPLAY BY NAME micm220f_arr[curr_idx].*
            LET max_row = micm220f_arr.getLength()
        ELSE
            CALL __Waring_ok("NoData", "micm210m")
        END IF

    CATCH
        CALL __Waring_ok("Fun", "micm220f_r_query")
    END TRY

END FUNCTION 
#-----------------------------------------------------------------------  
#抓上下筆資料
#-----------------------------------------------------------------------  
FUNCTION micm220f_n(idx)
    DEFINE idx SMALLINT

    DISPLAY curr_idx
    IF curr_idx = 0 THEN
        MESSAGE "無資料"
    ELSE
        LET curr_idx = curr_idx + idx
        MESSAGE ""
        IF curr_idx = 0 THEN
            LET curr_idx = 1
            MESSAGE "已經第一筆了"
        ELSE
            IF curr_idx = max_row + 1 THEN
                LET curr_idx = max_row
                MESSAGE "已經最後一筆了"
            END IF
        END IF
        DISPLAY BY NAME micm220f_arr[curr_idx].*
    END IF
END FUNCTION


#------------------------------------------------------------------------
# 新增資料
#------------------------------------------------------------------------
FUNCTION micm220f_i()
    DEFINE spec VARCHAR(15)
    DEFINE steel_grade_jis VARCHAR(15)
    
    #TRY
        CALL micm220f_arr.clear()
        #欄位輸入
        LABEL input_rec:
        DIALOG ATTRIBUTES(UNBUFFERED)
            INPUT micm220f_arr[1].*  
               FROM v_micm220f.* ATTRIBUTE (WITHOUT DEFAULTS)
               
               #按放大鏡 
               ON ACTION spec_find
                  LET curr_pa = ARR_CURR()
                  LET spec = ""
                  CALL mic_spec() RETURNING spec
                  LET micm220f_arr[1].spec = spec
                  #LET temp_spec = spec  
               #按放大鏡 
               ON ACTION steel_grade_jis_find
                  LET curr_pa = ARR_CURR()
                  DISPLAY "curr_pa:" ,curr_pa
                  LET steel_grade_jis = ""
                  CALL mic_steel(spec) RETURNING steel_grade_jis
                  LET micm220f_arr[1].steel_grade_jis = steel_grade_jis

            END INPUT
            
            ON ACTION micm220f_save #按存檔
                IF __mbox_yn(
                    "micm220f_insert", "是否確定新增資料?", "stop") THEN
                    CALL micm220f_i_insert()
                ELSE
                    CALL micm220f_clear()
                END IF
                EXIT DIALOG

            ON ACTION bye
                CALL micm220f_clear()
                EXIT DIALOG
        END DIALOG

    #CATCH
   #    CALL __Waring_ok("Fun", "micm220f_i")
   # END TRY

END FUNCTION
#-----------------------------------------------------------------------
#新增data
#-----------------------------------------------------------------------
FUNCTION micm220f_i_insert()
    DEFINE spec,steel_grade_jis STRING
    DEFINE thick_min FLOAT
    
     
    TRY
        WHENEVER ERROR CONTINUE
        INSERT INTO micm210m(
            spec,steel_grade_jis,
            thick_min,thick_max,
            other,
            c_min,c_max,
            si_min,si_max,
            mn_min,mn_max,
            p_min,p_max,
            s_min,s_max,
            ni_min,ni_max,
            cr_min,cr_max,
            mo_min,mo_max,
            n_min,n_max,
            al_min,al_max,
            cu_min,cu_max,
            ti_min,ti_max,
            nb_min,nb_max,
            v_min,v_max,
            ce_min,ce_max,
            wc_min,wc_max,
            co_min,co_max,
            b_min,b_max,
            kfa_min,kfa_max,
            ys_02_min,ys_02_max,
            ys_10_min,ys_10_max,
            ts_min,ts_max,
            elongation_min,elongation_max,
            hard_hrb_min,hard_hrb_max,
            hard_hv_min,hard_hv_max,
            hard_hb_min,hard_hb_max,
            bend_test1,bend_test2,
            hard_hrc_min,hard_hrc_max,
            yield_ratio_min,yield_ratio_max,
            charpy_unit,charpy_min,charpy_ave_min,
            c1_elongation_unit,c1_elongation_min,
            c2_elongation_unit,c2_elongation_min,
            c3_elongation_unit,c3_elongation_min,
            thick_percent_min,thick_percent_max)
        VALUES (
            micm220f_arr[1].spec,micm220f_arr[1].steel_grade_jis,
            micm220f_arr[1].thick_min,micm220f_arr[1].thick_max,
            micm220f_arr[1].other,
            micm220f_arr[1].c_min,micm220f_arr[1].c_max,
            micm220f_arr[1].si_min,micm220f_arr[1].si_max,
            micm220f_arr[1].mn_min,micm220f_arr[1].mn_max,
            micm220f_arr[1].p_min,micm220f_arr[1].p_max,
            micm220f_arr[1].s_min,micm220f_arr[1].s_max,
            micm220f_arr[1].ni_min,micm220f_arr[1].ni_max,
            micm220f_arr[1].cr_min,micm220f_arr[1].cr_max,
            micm220f_arr[1].mo_min,micm220f_arr[1].mo_max,
            micm220f_arr[1].n_min,micm220f_arr[1].n_max,
            micm220f_arr[1].al_min,micm220f_arr[1].al_max,
            micm220f_arr[1].cu_min,micm220f_arr[1].cu_max,
            micm220f_arr[1].ti_min,micm220f_arr[1].ti_max,
            micm220f_arr[1].nb_min,micm220f_arr[1].nb_max,
            micm220f_arr[1].v_min,micm220f_arr[1].v_max,
            micm220f_arr[1].ce_min,micm220f_arr[1].ce_max,
            micm220f_arr[1].wc_min,micm220f_arr[1].wc_max,
            micm220f_arr[1].co_min,micm220f_arr[1].co_max,
            micm220f_arr[1].b_min,micm220f_arr[1].b_max,
            micm220f_arr[1].kfa_min,micm220f_arr[1].kfa_max,
            micm220f_arr[1].ys_02_min,micm220f_arr[1].ys_02_max,
            micm220f_arr[1].ys_10_min,micm220f_arr[1].ys_10_max,
            micm220f_arr[1].ts_min,micm220f_arr[1].ts_max,
            micm220f_arr[1].elongation_min,micm220f_arr[1].elongation_max,
            micm220f_arr[1].hard_hrb_min,micm220f_arr[1].hard_hrb_max,
            micm220f_arr[1].hard_hv_min,micm220f_arr[1].hard_hv_max,
            micm220f_arr[1].hard_hb_min,micm220f_arr[1].hard_hb_max,
            micm220f_arr[1].bend_test1,micm220f_arr[1].bend_test2,
            micm220f_arr[1].hard_hrc_min,micm220f_arr[1].hard_hrc_max,
            micm220f_arr[1].yield_ratio_min,micm220f_arr[1].yield_ratio_max,
            micm220f_arr[1].charpy_unit,micm220f_arr[1].charpy_min,
            micm220f_arr[1].charpy_ave_min,
            micm220f_arr[1].c1_elongation_unit,micm220f_arr[1].c1_elongation_min,
            micm220f_arr[1].c2_elongation_unit,micm220f_arr[1].c2_elongation_min,
            micm220f_arr[1].c3_elongation_unit,micm220f_arr[1].c3_elongation_min,
            micm220f_arr[1].thick_percent_min,micm220f_arr[1].thick_percent_max)
        WHENEVER ERROR STOP

        IF SQLCA.SQLCODE = 0 THEN
            CALL __Waring_ok("", "資料已新增完畢!")
            LET spec = micm220f_arr[1].spec
            LET spec = spec.trim()
            LET steel_grade_jis = micm220f_arr[1].steel_grade_jis
            LET steel_grade_jis = steel_grade_jis.trim()
            LET thick_min = micm220f_arr[1].thick_min
            
            
            LET where_clause = " spec = '" || spec || "' " 
                            || " and steel_grade_jis =  " 
                            || " '" || steel_grade_jis || "' " 
                            || " and thick_min = " || thick_min ||" " 
                               
                              
            DISPLAY "where_clause:",where_clause                  
            CALL micm220f_reload()
        ELSE
            CALL __Waring_ok("", "資料新增有誤!")
            ERROR SQLERRMESSAGE
        END IF
    CATCH
        CALL __Waring_ok("Fun", "micm220f_i_insert")
    END TRY
END FUNCTION
#------------------------------------------------------------------------
# 修改資料
#------------------------------------------------------------------------
FUNCTION micm220f_u()

    IF curr_idx == 0 THEN
        MESSAGE ("無資料可修改,請查詢後再修改")
    ELSE
        LABEL input_rec:
        DIALOG ATTRIBUTES(UNBUFFERED, FIELD ORDER FORM)
            INPUT BY NAME micm220f_arr[curr_idx].* ATTRIBUTE(WITHOUT DEFAULTS)
                BEFORE INPUT
                    #鎖住欄位不可修改
                    CALL dialog.setFieldActive("spec", FALSE)
                    CALL dialog.setFieldActive("steel_grade_jis", FALSE)
                    CALL dialog.setFieldActive("thick_min", FALSE)
            END INPUT

            ON ACTION micm220f_save #按存檔時離開
                IF __mbox_yn(
                    "micm220f_update", "是否確定修改資料?", "stop") THEN
                    CALL micm220f_u1()
                ELSE
                    GOTO input_rec
                END IF
                EXIT DIALOG

            ON ACTION bye
                EXIT DIALOG

        END DIALOG
    END IF

END FUNCTION
#-----------------------------------------------------------------------
#micm220f_u1
#-----------------------------------------------------------------------
FUNCTION micm220f_u1()

    WHENEVER ERROR CONTINUE
    UPDATE micm210m
        SET thick_max = micm220f_arr[curr_idx].thick_max,
            other = micm220f_arr[curr_idx].other, 
            c_min = micm220f_arr[curr_idx].c_min,
            c_max = micm220f_arr[curr_idx].c_max,
            si_min = micm220f_arr[curr_idx].si_min,
            si_max = micm220f_arr[curr_idx].si_max,
            mn_min = micm220f_arr[curr_idx].mn_min,
            mn_max = micm220f_arr[curr_idx].mn_max,
            p_min = micm220f_arr[curr_idx].p_min,
            p_max = micm220f_arr[curr_idx].p_max,
            s_min = micm220f_arr[curr_idx].s_min,
            s_max = micm220f_arr[curr_idx].s_max,
            ni_min = micm220f_arr[curr_idx].ni_min,
            ni_max = micm220f_arr[curr_idx].ni_max,
            cr_min = micm220f_arr[curr_idx].cr_min,
            cr_max = micm220f_arr[curr_idx].cr_max,
            mo_min = micm220f_arr[curr_idx].mo_min,
            mo_max = micm220f_arr[curr_idx].mo_max,
            n_min = micm220f_arr[curr_idx].n_min,
            n_max = micm220f_arr[curr_idx].n_max,
            al_min = micm220f_arr[curr_idx].al_min,
            al_max = micm220f_arr[curr_idx].al_max,
            cu_min = micm220f_arr[curr_idx].cu_min,
            cu_max = micm220f_arr[curr_idx].cu_max,
            ti_min = micm220f_arr[curr_idx].ti_min,
            ti_max = micm220f_arr[curr_idx].ti_max,
            nb_min = micm220f_arr[curr_idx].nb_min,
            nb_max = micm220f_arr[curr_idx].nb_max,
            v_min = micm220f_arr[curr_idx].v_min,
            v_max = micm220f_arr[curr_idx].v_max,
            ce_min = micm220f_arr[curr_idx].ce_min,
            ce_max = micm220f_arr[curr_idx].ce_max,
            wc_min = micm220f_arr[curr_idx].wc_min,
            wc_max = micm220f_arr[curr_idx].wc_max,
            co_min = micm220f_arr[curr_idx].co_min,
            co_max = micm220f_arr[curr_idx].co_max,
            b_min = micm220f_arr[curr_idx].b_min,
            b_max = micm220f_arr[curr_idx].b_max,
            kfa_min = micm220f_arr[curr_idx].kfa_min,
            kfa_max = micm220f_arr[curr_idx].kfa_max,
            ys_02_min = micm220f_arr[curr_idx].ys_02_min,
            ys_02_max = micm220f_arr[curr_idx].ys_02_max,
            ys_10_min = micm220f_arr[curr_idx].ys_10_min,
            ys_10_max = micm220f_arr[curr_idx].ys_10_max,
            ts_min = micm220f_arr[curr_idx].ts_min,
            ts_max = micm220f_arr[curr_idx].ts_max,
            elongation_min = micm220f_arr[curr_idx].elongation_min,
            elongation_max = micm220f_arr[curr_idx].elongation_max,
            hard_hrb_min = micm220f_arr[curr_idx].hard_hrb_min,
            hard_hrb_max = micm220f_arr[curr_idx].hard_hrb_max,
            hard_hv_min = micm220f_arr[curr_idx].hard_hv_min,
            hard_hv_max = micm220f_arr[curr_idx].hard_hv_max,
            hard_hb_min = micm220f_arr[curr_idx].hard_hb_min,
            hard_hb_max = micm220f_arr[curr_idx].hard_hb_max, 
            bend_test1 = micm220f_arr[curr_idx].bend_test1,
            bend_test2 = micm220f_arr[curr_idx].bend_test2,
            hard_hrc_min = micm220f_arr[curr_idx].hard_hrc_min,
            hard_hrc_max = micm220f_arr[curr_idx].hard_hrc_max,
            yield_ratio_min = micm220f_arr[curr_idx].yield_ratio_min,
            yield_ratio_max = micm220f_arr[curr_idx].yield_ratio_max,
            charpy_unit = micm220f_arr[curr_idx].charpy_unit,
            charpy_min = micm220f_arr[curr_idx].charpy_min,
            charpy_ave_min = micm220f_arr[curr_idx].charpy_ave_min,
            c1_elongation_unit = micm220f_arr[curr_idx].c1_elongation_unit,
            c1_elongation_min = micm220f_arr[curr_idx].c1_elongation_min,
            c2_elongation_unit = micm220f_arr[curr_idx].c2_elongation_unit,
            c2_elongation_min = micm220f_arr[curr_idx].c2_elongation_min,
            c3_elongation_unit =  micm220f_arr[curr_idx].c3_elongation_unit,
            c3_elongation_min = micm220f_arr[curr_idx].c3_elongation_min,
            thick_percent_min = micm220f_arr[curr_idx].thick_percent_min,
            thick_percent_max = micm220f_arr[curr_idx].thick_percent_max           
        WHERE spec = micm220f_arr[curr_idx].spec AND 
              steel_grade_jis = micm220f_arr[curr_idx].steel_grade_jis AND 
              thick_min = micm220f_arr[curr_idx].thick_min
    WHENEVER ERROR STOP

    IF SQLCA.SQLCODE = 0 THEN
        CALL __Waring_ok("", "資料已修改完畢!")
    ELSE
        CALL __Waring_ok("", "資料修改有誤!")
        ERROR SQLERRMESSAGE
    END IF

END FUNCTION
#-----------------------------------------------------------------------
#刪除資料
#-----------------------------------------------------------------------
FUNCTION micm220f_d()
    DEFINE sql_txt STRING
    DEFINE d_spec,d_steel_grade_jis STRING
    DEFINE d_thick_min FLOAT
    
    IF curr_idx == 0 THEN
        MESSAGE ("請查詢後再刪除")
    ELSE
        TRY
            
            IF __mbox_yn("micm220f_delete", "是否確定刪除資料?", "stop") THEN
                LET d_spec = micm220f_arr[curr_idx].spec
                LET d_spec = d_spec.trim()
                LET d_steel_grade_jis = micm220f_arr[curr_idx].steel_grade_jis
                LET d_steel_grade_jis = d_steel_grade_jis.trim()
                
                LET sql_txt =
                    "delete from micm210m where spec = 
                    '"|| d_spec || "' 
                    and steel_grade_jis = 
                    '"|| d_steel_grade_jis || "' 
                    and thick_min =  
                    "|| micm220f_arr[curr_idx].thick_min ||" "
                DISPLAY sql_txt
                WHENEVER ERROR CONTINUE
                EXECUTE IMMEDIATE sql_txt
                WHENEVER ERROR STOP
                IF SQLCA.SQLCODE = 0 THEN
                    CALL __Waring_ok("", "資料刪除完畢!")
                    CALL micm220f_clear()
                ELSE
                    CALL __Waring_ok("", "資料刪除有誤!")
                    ERROR SQLERRMESSAGE
                END IF
            END IF
        CATCH
            CALL __Waring_ok("Fun", "micm220f_d")
        END TRY
    END IF
END FUNCTION 
#-----------------------------------------------------------------------
#修改後reload data
#-----------------------------------------------------------------------
FUNCTION micm220f_reload()

    TRY
        CALL micm220f_r_query()
    CATCH
        CALL __Waring_ok("Fun", "micm220f_reload")
    END TRY

END FUNCTION
#-----------------------------------------------------------------------
#作業結束後清除畫面及record變數資料
#-----------------------------------------------------------------------
FUNCTION micm220f_clear()
    CALL micm220f_arr.clear()
    CLEAR FORM
    LET curr_idx = 0
END FUNCTION