DEFINE f ui.Form
DEFINE w ui.Window
DEFINE doc om.DomDocument

FUNCTION sys_set_toolbar(fm_name, tm_name)
    DEFINE fm_name VARCHAR(15)
    DEFINE tm_name VARCHAR(15)

    OPEN FORM fm_name FROM fm_name
    DISPLAY FORM fm_name
    LET doc = ui.Interface.getdocument()
    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
    CALL f.loadtopmenu(tm_name)
    CALL ui.Interface.loadToolBar("ToolBar1m")

END FUNCTION
