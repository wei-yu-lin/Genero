#----------------------------------------------------------------------
# 權限架構設計
#----------------------------------------------------------------------

PRIVATE TYPE sys_FK_mapping RECORD
        F1 STRING, F2 STRING, F3 STRING, F4 STRING, 
        F5 STRING, F6 STRING, F7 STRING, F8 STRING, 
        F9 STRING, F10 STRING, F11 STRING, F12 STRING  
    END RECORD

PUBLIC TYPE sys_priv RECORD
        PRG CHAR(20),
        USER_ID CHAR(20),
        PADD CHAR(1),
        PDEL CHAR(1),
        PMOD CHAR(1),
        PQRY CHAR(1),
        PPRT CHAR(1),
        PEXE CHAR(1),
        F1 CHAR(1), F2 CHAR(1), F3 CHAR(1), F4 CHAR(1),
        F5 CHAR(1), F6 CHAR(1), F7 CHAR(1), F8 CHAR(1),
        F9 CHAR(1), F10 CHAR(1), F11 CHAR(1), F12 CHAR(1)
    END RECORD

PUBLIC TYPE sys_ConToolBar RECORD
        _add BOOLEAN,
        _query BOOLEAN,
        _prev BOOLEAN,
        _next BOOLEAN,
        _first BOOLEAN,
        _last BOOLEAN,
        _upd BOOLEAN,
        _del BOOLEAN,
        _save BOOLEAN,
        _back BOOLEAN,
        exit BOOLEAN,
        _help BOOLEAN,
        tb_node om.DomNode,
        priv sys_priv,
        FK_mapping sys_FK_mapping
    END RECORD

#############################################################
FUNCTION (src_rec sys_ConToolBar) getPriv(arg_prg VARCHAR(20))
    DEFINE user_no STRING
    
    LET user_no = fgl_getenv("g_user_id")
    
    SET CONNECTION "YUD"
    {SELECT PRG_NO, PADD, PDELETE, PMODIFY, PQUERY, PPRINT, PEXECUTE,
            F1, F2, F3, F4, F5, F6 INTO src_rec.priv.*
        FROM SECUPRG_FK WHERE USER_ID = user_no AND PRG_NO = arg_prg}
    
    SELECT * INTO src_rec.priv.* FROM SECUPRG WHERE USER_ID = user_no AND PRG_NO = arg_prg

END FUNCTION

FUNCTION (src_rec sys_ConToolBar) setDialogPriv()
    DEFINE debug sys_ConToolBar
    LET debug = src_rec
    #預設全開
    #新增
    IF src_rec.priv.PADD == 'N' THEN
        CALL sys_setAction("_add", FALSE)
    END IF
    #刪除
    IF src_rec.priv.PDEL == 'N' THEN
        CALL sys_setAction("_del", FALSE)
    END IF
    #查詢
    IF src_rec.priv.PQRY == 'N' THEN
        CALL sys_setAction("_query", FALSE)
        CALL sys_setAction("_prev", FALSE)
        CALL sys_setAction("_next", FALSE)
        CALL sys_setAction("_first", FALSE)
        CALL sys_setAction("_last", FALSE)
    END IF
    #修改
    IF src_rec.priv.PMOD == 'N' THEN
        CALL sys_setAction("_upd", FALSE)
        CALL sys_setAction("_del", FALSE)
        CALL sys_setAction("_save", FALSE)
        CALL sys_setAction("_back", FALSE)
    END IF
    {#執行-統一設定
    IF NOT priv.PEXE == 'Y' THEN
        CALL sys_setAction(arg_prg || "_F1", FALSE)
        CALL sys_setAction(arg_prg || "_F2", FALSE)
        CALL sys_setAction(arg_prg || "_F3", FALSE)
        CALL sys_setAction(arg_prg || "_F4", FALSE)
        CALL sys_setAction(arg_prg || "_F5", FALSE)
        CALL sys_setAction(arg_prg || "_F6", FALSE)
    END IF}
    #-----Auto Accept-----
    # _back
    # _help
    #-----Auto Accept-----

    #執行-個別設定
    #預設全開
    CALL sys_setAction(src_rec.FK_mapping.F1, NOT src_rec.priv.F1 == 'N')
    CALL sys_setAction(src_rec.FK_mapping.F2, NOT src_rec.priv.F2 == 'N')
    CALL sys_setAction(src_rec.FK_mapping.F3, NOT src_rec.priv.F3 == 'N')
    CALL sys_setAction(src_rec.FK_mapping.F4, NOT src_rec.priv.F4 == 'N')
    CALL sys_setAction(src_rec.FK_mapping.F5, NOT src_rec.priv.F5 == 'N')
    CALL sys_setAction(src_rec.FK_mapping.F6, NOT src_rec.priv.F6 == 'N')
    CALL sys_setAction(src_rec.FK_mapping.F7, NOT src_rec.priv.F7 == 'N')
    CALL sys_setAction(src_rec.FK_mapping.F8, NOT src_rec.priv.F8 == 'N')
    CALL sys_setAction(src_rec.FK_mapping.F9, NOT src_rec.priv.F9 == 'N')
    CALL sys_setAction(src_rec.FK_mapping.F10, NOT src_rec.priv.F10 == 'N')
    CALL sys_setAction(src_rec.FK_mapping.F11, NOT src_rec.priv.F11 == 'N')
    CALL sys_setAction(src_rec.FK_mapping.F12, NOT src_rec.priv.F12 == 'N')
END FUNCTION

#-------------------------------------------------
# sys_setActionPriv
# arg_flag -> Action flag
#             -> TRUE -> NOT Reject
#             -> FALSE -> Reject
#-------------------------------------------------
PRIVATE FUNCTION sys_setAction(arg_action STRING, arg_flag BOOLEAN)
    DEFINE arg_dialog ui.Dialog
    LET arg_dialog = ui.Dialog.getCurrent()
    TRY
        CALL arg_dialog.setActionActive( arg_action, arg_flag )
    CATCH
        IF STATUS == -8089 THEN
            DISPLAY arg_action || " not exist --> ignore."
        END IF
    END TRY 
END FUNCTION

PRIVATE FUNCTION (tb_code sys_ConToolBar) sys_setToolBar()
    DEFINE TB_NODE om.DomNode

    #LET TB_NODE = ui.Window.getCurrent().findNode("ToolBar", "sys_ToolBar")
    
    #新增
    LET TB_NODE = ui.Window.getCurrent().findNode("ToolBarItem", "_add")
    CALL TB_NODE.setAttribute("hidden", NOT tb_code._add);
    CALL TB_NODE.getPrevious().setAttribute("hidden", NOT tb_code._add);
    
    #查詢
    LET TB_NODE = ui.Window.getCurrent().findNode("ToolBarItem", "_query")
    CALL TB_NODE.setAttribute("hidden", NOT tb_code._query);
    CALL TB_NODE.getPrevious().setAttribute("hidden", NOT tb_code._query);
    
    #前一筆
    LET TB_NODE = ui.Window.getCurrent().findNode("ToolBarItem", "_prev")
    CALL TB_NODE.setAttribute("hidden", NOT tb_code._prev);
    CALL TB_NODE.getPrevious().setAttribute("hidden", NOT tb_code._prev);
    
    #後一筆
    LET TB_NODE = ui.Window.getCurrent().findNode("ToolBarItem", "_next")
    CALL TB_NODE.setAttribute("hidden", NOT tb_code._next);
    CALL TB_NODE.getPrevious().setAttribute("hidden", NOT tb_code._next);
    
    #第一筆
    LET TB_NODE = ui.Window.getCurrent().findNode("ToolBarItem", "_first")
    CALL TB_NODE.setAttribute("hidden", NOT tb_code._first);
    CALL TB_NODE.getPrevious().setAttribute("hidden", NOT tb_code._first);
    
    #最後筆
    LET TB_NODE = ui.Window.getCurrent().findNode("ToolBarItem", "_last")
    CALL TB_NODE.setAttribute("hidden", NOT tb_code._last);
    CALL TB_NODE.getPrevious().setAttribute("hidden", NOT tb_code._last);
    
    #修改
    LET TB_NODE = ui.Window.getCurrent().findNode("ToolBarItem", "_upd")
    CALL TB_NODE.setAttribute("hidden", NOT tb_code._upd);
    CALL TB_NODE.getPrevious().setAttribute("hidden", NOT tb_code._upd);
    
    #刪除
    LET TB_NODE = ui.Window.getCurrent().findNode("ToolBarItem", "_del")
    CALL TB_NODE.setAttribute("hidden", NOT tb_code._del);
    CALL TB_NODE.getPrevious().setAttribute("hidden", NOT tb_code._del);
    
    #存檔
    LET TB_NODE = ui.Window.getCurrent().findNode("ToolBarItem", "_save")
    CALL TB_NODE.setAttribute("hidden", NOT tb_code._save);
    CALL TB_NODE.getPrevious().setAttribute("hidden", NOT tb_code._save);
    
    #返回
    LET TB_NODE = ui.Window.getCurrent().findNode("ToolBarItem", "_back")
    CALL TB_NODE.setAttribute("hidden", NOT tb_code._back);
    CALL TB_NODE.getPrevious().setAttribute("hidden", NOT tb_code._back);
    
    #離開
    LET TB_NODE = ui.Window.getCurrent().findNode("ToolBarItem", "exit")
    CALL TB_NODE.setAttribute("hidden", NOT tb_code.exit);
    CALL TB_NODE.getPrevious().setAttribute("hidden", NOT tb_code.exit);
    
    #說明
    LET TB_NODE = ui.Window.getCurrent().findNode("ToolBarItem", "_help")
    CALL TB_NODE.setAttribute("hidden", NOT tb_code._help);
    CALL TB_NODE.getPrevious().setAttribute("hidden", NOT tb_code._help);
    
END FUNCTION

FUNCTION (src_rec sys_ConToolBar) init(sign BOOLEAN)
    LET src_rec._add = sign
    LET src_rec._query = sign
    LET src_rec._prev = sign
    LET src_rec._next = sign
    LET src_rec._first = sign
    LET src_rec._last = sign
    LET src_rec._upd = sign
    LET src_rec._del = sign
    LET src_rec._save = sign
    LET src_rec._back = sign
    LET src_rec.exit = TRUE
    LET src_rec._help = sign

    LET src_rec.FK_mapping.F1 = "_F1"
    LET src_rec.FK_mapping.F2 = "_F2"
    LET src_rec.FK_mapping.F3 = "_F3"
    LET src_rec.FK_mapping.F4 = "_F4"
    LET src_rec.FK_mapping.F5 = "_F5"
    LET src_rec.FK_mapping.F6 = "_F6"
    LET src_rec.FK_mapping.F7 = "_F7"
    LET src_rec.FK_mapping.F8 = "_F8"
    LET src_rec.FK_mapping.F9 = "_F9"
    LET src_rec.FK_mapping.F10 = "_F10"
    LET src_rec.FK_mapping.F11 = "_F11"
    LET src_rec.FK_mapping.F12 = "_F12"
    
    CALL ui.Window.getCurrent().getForm().loadToolBar("sys_toolbar")
    CALL src_rec.sys_setToolBar()
    LET src_rec.tb_node = ui.Window.getCurrent().findNode("ToolBar","sys_ToolBar")
    
END FUNCTION

FUNCTION (src_rec sys_ConToolBar) createChild(tb_name VARCHAR(20), ch_name VARCHAR(20), icon VARCHAR(20), FK_mapping STRING)
    DEFINE tbi om.DomNode
    DEFINE tbs om.DomNode

    LET tbs = createTBS(src_rec.tb_node) ##############
    LET tbi = createTB(src_rec.tb_node, tb_name, ch_name, ch_name, icon)

    CASE FK_mapping
        WHEN "F1" LET src_rec.FK_mapping.F1 = tb_name
        WHEN "F2" LET src_rec.FK_mapping.F2 = tb_name
        WHEN "F3" LET src_rec.FK_mapping.F3 = tb_name
        WHEN "F4" LET src_rec.FK_mapping.F4 = tb_name
        WHEN "F5" LET src_rec.FK_mapping.F5 = tb_name
        WHEN "F6" LET src_rec.FK_mapping.F6 = tb_name
        WHEN "F7" LET src_rec.FK_mapping.F7 = tb_name
        WHEN "F8" LET src_rec.FK_mapping.F8 = tb_name
        WHEN "F9" LET src_rec.FK_mapping.F9 = tb_name
        WHEN "F10" LET src_rec.FK_mapping.F10 = tb_name
        WHEN "F11" LET src_rec.FK_mapping.F11 = tb_name
        WHEN "F12" LET src_rec.FK_mapping.F12 = tb_name
    END CASE
END FUNCTION

FUNCTION createTBS(tb)
    DEFINE tb om.DomNode
    DEFINE tbs, exit_tbs om.DomNode
    LET tbs = tb.createChild("ToolBarSeparator")

    LET exit_tbs = ui.Window.getCurrent().findNode("ToolBarSeparator","exit_tbs")
    CALL tb.insertBefore(tbs, exit_tbs)
    RETURN tbs
END FUNCTION

FUNCTION createTB(tb, n, t, c, i)
    DEFINE tb om.DomNode
    DEFINE n, t, c, i VARCHAR(100)
    DEFINE tbi, exit_tbs om.DomNode
    LET tbi = tb.createChild("ToolBarItem")
    CALL tbi.setAttribute("name", n)
    CALL tbi.setAttribute("text", t)
    CALL tbi.setAttribute("comment", c)
    CALL tbi.setAttribute("image", i)

    LET exit_tbs = ui.Window.getCurrent().findNode("ToolBarSeparator","exit_tbs")
    CALL tb.insertBefore(tbi, exit_tbs)
    RETURN tbi
END FUNCTION

FUNCTION (src_rec sys_ConToolBar) setAttribute(member STRING, sign BOOLEAN)
    CASE member
        WHEN "_add"
			LET src_rec._add = sign
        WHEN "_query"
			LET src_rec._query = sign
        WHEN "_prev"
			LET src_rec._prev = sign
        WHEN "_next"
			LET src_rec._next = sign
        WHEN "_first"
			LET src_rec._first = sign
        WHEN "_last"
			LET src_rec._last = sign
        WHEN "_upd"
			LET src_rec._upd = sign
        WHEN "_del"
			LET src_rec._del = sign
        WHEN "_save"
			LET src_rec._save = sign
        WHEN "_back"
			LET src_rec._back = sign
        WHEN "exit"
			LET src_rec.exit = sign
        WHEN "_help"
			LET src_rec._help = sign
    END CASE

    CALL src_rec.sys_setToolBar()

END FUNCTION

FUNCTION (src_rec sys_ConToolBar) initByType(type_code CHAR(1))
    LET src_rec._add = FALSE
    LET src_rec._query = FALSE
    LET src_rec._prev = FALSE
    LET src_rec._next = FALSE
    LET src_rec._first = FALSE
    LET src_rec._last = FALSE
    LET src_rec._upd = FALSE
    LET src_rec._del = FALSE
    LET src_rec._save = FALSE
    LET src_rec._back = FALSE
    LET src_rec.exit = FALSE
    LET src_rec._help = FALSE
    
    CASE type_code
        WHEN "1" -- 新增,查詢,修改,刪除,存檔,離開,說明
            LET src_rec._add = TRUE
            LET src_rec._query = TRUE
            LET src_rec._upd = TRUE
            LET src_rec._del = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "2" -- 新增,查詢,前一筆,後一筆,修改,刪除,存檔,離開,說明
            LET src_rec._add = TRUE
            LET src_rec._query = TRUE
            LET src_rec._prev = TRUE
            LET src_rec._next = TRUE
            LET src_rec._upd = TRUE
            LET src_rec._del = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "3" -- 查詢,前一筆,後一筆,修改,刪除,存檔,離開,說明
            LET src_rec._query = TRUE
            LET src_rec._prev = TRUE
            LET src_rec._next = TRUE
            LET src_rec._upd = TRUE
            LET src_rec._del = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "4" -- 查詢,修改,刪除,存檔,離開,說明
            LET src_rec._query = TRUE
            LET src_rec._upd = TRUE
            LET src_rec._del = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "5" -- 查詢,前一筆,後一筆,修改,刪除,存檔,返回,離開,說明
            LET src_rec._query = TRUE
            LET src_rec._prev = TRUE
            LET src_rec._next = TRUE
            LET src_rec._upd = TRUE
            LET src_rec._del = TRUE
            LET src_rec._save = TRUE
            LET src_rec._back = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "6" -- 查詢,修改,存檔,離開,說明
            LET src_rec._add = TRUE
            LET src_rec._query = TRUE
            LET src_rec._upd = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "7" -- 查詢,離開,說明
            LET src_rec._query = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "8" -- 離開
            LET src_rec.exit = TRUE
        WHEN "9" -- 查詢,修改,存檔,離開,說明
            LET src_rec._query = TRUE
            LET src_rec._upd = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "A" -- 修改,存檔,離開,說明
            LET src_rec._upd = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "B" -- 新增,查詢,前一筆,後一筆,修改,存檔,離開,說明
            LET src_rec._add = TRUE
            LET src_rec._query = TRUE
            LET src_rec._prev = TRUE
            LET src_rec._next = TRUE
            LET src_rec._upd = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "C" -- 查詢,前一筆,後一筆,修改,存檔,離開,說明
            LET src_rec._query = TRUE
            LET src_rec._prev = TRUE
            LET src_rec._next = TRUE
            LET src_rec._upd = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "D" -- 查詢,前一筆,後一筆,存檔,離開,說明
            LET src_rec._query = TRUE
            LET src_rec._prev = TRUE
            LET src_rec._next = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "E" -- 新增,查詢,前一筆,後一筆,第一筆,最後筆,修改,刪除,存檔,離開,說明
            LET src_rec._add = TRUE
            LET src_rec._query = TRUE
            LET src_rec._prev = TRUE
            LET src_rec._next = TRUE
            LET src_rec._first = TRUE
            LET src_rec._last = TRUE
            LET src_rec._upd = TRUE
            LET src_rec._del = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "F" -- 查詢,前一筆,後一筆,第一筆,最後筆,離開,說明
            LET src_rec._query = TRUE
            LET src_rec._prev = TRUE
            LET src_rec._next = TRUE
            LET src_rec._first = TRUE
            LET src_rec._last = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "G" -- 存檔,離開,說明
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "H" -- 新增,查詢,前一筆,後一筆,刪除,存檔
            LET src_rec._add = TRUE
            LET src_rec._query = TRUE
            LET src_rec._prev = TRUE
            LET src_rec._next = TRUE
            LET src_rec._del = TRUE
            LET src_rec._save = TRUE
        WHEN "I" -- 新增,查詢,前一筆,後一筆,存檔
            LET src_rec._add = TRUE
            LET src_rec._query = TRUE
            LET src_rec._prev = TRUE
            LET src_rec._next = TRUE
            LET src_rec._save = TRUE
        WHEN "J" -- 新增,查詢,修改,存檔,離開,說明
            LET src_rec._add = TRUE
            LET src_rec._query = TRUE
            LET src_rec._upd = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        WHEN "K" -- 新增,查詢,刪除,存檔,離開,說明
            LET src_rec._add = TRUE
            LET src_rec._query = TRUE
            LET src_rec._del = TRUE
            LET src_rec._save = TRUE
            LET src_rec.exit = TRUE
            LET src_rec._help = TRUE
        OTHERWISE
            CALL src_rec.init(TRUE)
    END CASE

    CALL ui.Window.getCurrent().getForm().loadToolBar("sys_toolbar")
    CALL src_rec.sys_setToolBar()
    LET src_rec.tb_node = ui.Window.getCurrent().findNode("ToolBar","sys_ToolBar")
    
END FUNCTION