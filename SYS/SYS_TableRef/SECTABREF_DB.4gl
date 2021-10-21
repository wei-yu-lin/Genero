SCHEMA yud221

PUBLIC TYPE SECTABREF RECORD
	sys LIKE sectabref.sys,
	prog_name LIKE sectabref.prog_name,
	prog_desc LIKE sectabref.prog_desc,
	table_ref LIKE sectabref.table_ref,
	upd_code LIKE sectabref.upd_code,
	calledby LIKE sectabref.calledby
END RECORD

PUBLIC TYPE prog_item RECORD
	prog_name LIKE sectabref.prog_name,
	prog_desc LIKE sectabref.prog_desc,
    upd_code LIKE sectabref.upd_code
END RECORD

PUBLIC TYPE table_item RECORD
	table_ref LIKE sectabref.table_ref,
    upd_code LIKE sectabref.upd_code
END RECORD

PUBLIC TYPE sys_item RECORD
	sys LIKE sectabref.sys
END RECORD

PUBLIC TYPE TableRef_List RECORD
    arr DYNAMIC ARRAY OF SECTABREF,
    prog_list DYNAMIC ARRAY OF prog_item,
    table_list DYNAMIC ARRAY OF table_item,
    sys_list DYNAMIC ARRAY OF sys_item,
    forcus SECTABREF,
    curr_sys CHAR(3)
END RECORD
##########################################################
FUNCTION (src_rec SECTABREF) ins()
    TRY
        INSERT INTO SECTABREF VALUES(src_rec.*)
    CATCH
        UPDATE SECTABREF SET
                sys = NVL(src_rec.sys, sys),
                prog_name = NVL(src_rec.prog_name, prog_name),
                prog_desc = NVL(src_rec.prog_desc, prog_desc),
                table_ref = NVL(src_rec.table_ref, table_ref),
                upd_code = NVL(src_rec.upd_code, upd_code),
                calledby = NVL(src_rec.calledby, calledby)
            WHERE prog_name = src_rec.prog_name
                AND table_ref = src_rec.table_ref
    END TRY
END FUNCTION

FUNCTION (src_rec SECTABREF) del()
    SET CONNECTION "YUD"
    DELETE FROM SECTABREF WHERE prog_name=src_rec.prog_name AND table_ref=src_rec.table_ref
END FUNCTION
##########################################################
FUNCTION (src_rec TableRef_List) init()
    DEFINE idx INTEGER
    
    SET CONNECTION "YUD"
    LET src_rec.curr_sys = "all"
    
    CALL src_rec.arr.clear()
    
    LET idx = 1
    DECLARE cs CURSOR FROM "select * from SECTABREF order by sys, prog_name, table_ref"
    FOREACH cs INTO src_rec.arr[idx].*
        LET idx = idx + 1
    END FOREACH

    CALL src_rec.arr.deleteElement(idx)
END FUNCTION

FUNCTION (src_rec TableRef_List) setCurrSys(arg_sys CHAR(3))
    LET src_rec.curr_sys = arg_sys
END FUNCTION

FUNCTION (src_rec TableRef_List) initBySys()
    DEFINE idx INTEGER
    DEFINE s_sql STRING
    SET CONNECTION "YUD"

    #LET src_rec.curr_sys = arg_sys
    CALL src_rec.arr.clear()

    LET s_sql = "select * from SECTABREF "
    IF src_rec.curr_sys != "all" THEN
        LET s_sql = s_sql || "where sys='"|| src_rec.curr_sys ||"'"
    END IF
    LET s_sql = s_sql || " order by sys, prog_name, table_ref"
    
    LET idx = 1
    DECLARE cs4 CURSOR FROM s_sql
    FOREACH cs4 INTO src_rec.arr[idx].*
        LET idx = idx + 1
    END FOREACH

    CALL src_rec.arr.deleteElement(idx)
END FUNCTION

FUNCTION (src_rec TableRef_List) getProgList()
    DEFINE idx INTEGER
    DEFINE s_sql STRING
    DEFINE debug TableRef_List
    
    SET CONNECTION "YUD"

    CALL src_rec.prog_list.clear()
    LET debug = src_rec
    LET idx = 1
    LET s_sql = "select prog_name, prog_desc, '' from SECTABREF "
    IF src_rec.curr_sys != "all" THEN
        LET s_sql = s_sql || " WHERE sys='"|| src_rec.curr_sys ||"' "
    END IF
    LET s_sql = s_sql || " group by prog_name, prog_desc order by prog_name "
    DECLARE cs1 CURSOR FROM s_sql 
        
    FOREACH cs1 INTO src_rec.prog_list[idx].*
        LET idx = idx + 1
    END FOREACH

    CLOSE cs1
    FREE cs1
    CALL src_rec.prog_list.deleteElement(idx)
END FUNCTION

FUNCTION (src_rec TableRef_List) getTalbeList()
    DEFINE idx INTEGER
    DEFINE s_sql STRING
    SET CONNECTION "YUD"

    CALL src_rec.table_list.clear()

    LET s_sql = "select table_ref, '' from SECTABREF "
    IF src_rec.curr_sys != "all" THEN
        LET s_sql = s_sql || " WHERE sys='"|| src_rec.curr_sys ||"' "
    END IF
    LET s_sql = s_sql || " group by table_ref order by table_ref "
    
    LET idx = 1
    DECLARE cs2 CURSOR FROM s_sql
        {"select table_ref from SECTABREF " ||
        " group by table_ref " ||
        " order by table_ref "}
        
    FOREACH cs2 INTO src_rec.table_list[idx].*
        LET idx = idx + 1
    END FOREACH

    CALL src_rec.table_list.deleteElement(idx)
END FUNCTION

FUNCTION (src_rec TableRef_List) getSysList()
    DEFINE idx INTEGER
    SET CONNECTION "YUD"

    CALL src_rec.sys_list.clear()
    
    LET idx = 1
    DECLARE cs5 CURSOR FROM 
        "select sys from SECTABREF " ||
        " group by sys " ||
        " order by sys "
        
    FOREACH cs5 INTO src_rec.sys_list[idx].*
        LET idx = idx + 1
    END FOREACH

    CALL src_rec.sys_list.deleteElement(idx)
END FUNCTION

FUNCTION (src_rec TableRef_List) getTalbeListByProg()
    DEFINE idx, i, len INTEGER
    DEFINE debug  TableRef_List
    LET debug = src_rec
    SET CONNECTION "YUD"

    CALL src_rec.table_list.clear()
    LET len = src_rec.prog_list.getLength()
    FOR i = 1 TO len
        LET src_rec.prog_list[i].upd_code = ""
    END FOR
    
    LET idx = 1
    DECLARE cs3 CURSOR FROM 
        "select table_ref, upd_code from SECTABREF " ||
        " where prog_name = '" || src_rec.forcus.prog_name || "'" ||
        " group by upd_code, table_ref " ||
        " order by upd_code desc, table_ref "
        
    FOREACH cs3 INTO src_rec.table_list[idx].*
        LET idx = idx + 1
    END FOREACH

    CALL src_rec.table_list.deleteElement(idx)
END FUNCTION

FUNCTION (src_rec TableRef_List) getProgListByTable()
    DEFINE idx, i, len INTEGER
    
    SET CONNECTION "YUD"

    CALL src_rec.prog_list.clear()
    LET len = src_rec.table_list.getLength()
    FOR i = 1 TO len
        LET src_rec.table_list[i].upd_code = ""
    END FOR
    
    LET idx = 1
    DECLARE cs6 CURSOR FROM 
        "select prog_name, prog_desc, upd_code from SECTABREF " ||
        " where table_ref = '" || src_rec.forcus.table_ref || "'" ||
        " group by upd_code, prog_name, prog_desc " ||
        " order by upd_code desc, prog_name "
        
    FOREACH cs6 INTO src_rec.prog_list[idx].*
        LET idx = idx + 1
    END FOREACH

    CALL src_rec.prog_list.deleteElement(idx)
END FUNCTION