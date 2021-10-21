#------------------------------------------------------------------------------
# 依輸入畫面名稱及類別顯示不同Toolbar
#------------------------------------------------------------------------------
 FUNCTION sys_contro_toolbar(channel,t_type)
   DEFINE aui om.DomNode
   DEFINE tb  om.DomNode
   DEFINE tbi om.DomNode
   DEFINE tbs om.DomNode
   DEFINE channel varchar(20)
   DEFINE t_type varchar(1)
   DEFINE tb_name_add,tb_name_del,tb_name_upd,tb_name_qry varchar(20),
          tb_name_next,tb_name_prev,tb_name_help varchar(20),
          tb_name_save,tb_name_back,tb_name_first,tb_name_last varchar(20)

  LET tb_name_add = channel || "_add"
  LET tb_name_del = channel || "_del"
  LET tb_name_upd = channel || "_upd"
  LET tb_name_qry = channel || "_query"
  LET tb_name_next = channel || "_next"
  LET tb_name_prev = channel || "_prev"
  LET tb_name_first = channel || "_first"
  LET tb_name_last  = channel || "_last"
  LET tb_name_save = channel || "_save"
  LET tb_name_back = channel || "_back"
  LET tb_name_help = channel || "_help"
   
   LET aui = ui.Interface.getRootNode()
 
   LET tb = aui.createChild("ToolBar")
  
# TOOL BAR 按鈕的 bye 我就沒有再多設定~因為都通用!!所以一致叫做BYE
# 改用 CASE的方式來區分
  
    CASE t_type
    WHEN "1" #normal(新增,查詢,修改,刪除,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_add,"新增","新增","new")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_qry,"查詢","查詢1","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_upd,"修改","修改","prop")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_del,"刪除","刪除","eraser")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"存檔","存檔","disk")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","離開","離開","quit")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"說明","說明","quest")

    WHEN "2" #full(新增,查詢,前一筆,後一筆,修改,刪除,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_add,"新增","新增","new")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_qry,"查詢","查詢1","find")
         LET tbs = createToolBarSeparator(tb)############## 
         #LET tbi = createToolBarItem(tb,tb_name_prev,"前一筆","前一筆","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_next,"後一筆","後一筆","goforw")
         LET tbs = createToolBarSeparator(tb)###############
         LET tbi = createToolBarItem(tb,tb_name_upd,"修改","修改","prop")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_del,"刪除","刪除","eraser")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"存檔","存檔","disk")
         LET tbs = createToolBarSeparator(tb)##############
          LET tbi = createToolBarItem(tb,"bye","離開","離開","quit")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"說明","說明","quest")
    WHEN "3" #full query&update&del(查詢,前一筆,後一筆,修改,刪除,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_prev,"SYS0003","SYS0003","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_next,"SYS0004","SYS0004","goforw")
         LET tbs = createToolBarSeparator(tb)###############
         LET tbi = createToolBarItem(tb,tb_name_upd,"SYS0005","SYS0012","prop")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_del,"SYS0006","SYS0013","eraser")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")   
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "4" #query&update&del(查詢,修改,刪除,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_upd,"SYS0005","SYS0012","prop")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_del,"SYS0006","SYS0013","eraser")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")   
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "5" #query&update&del&back(查詢,前一筆,後一筆,修改,刪除,存檔,返回,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_prev,"SYS0003","SYS0003","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_next,"SYS0004","SYS0004","goforw")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_upd,"SYS0005","SYS0012","prop")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_del,"SYS0006","SYS0013","eraser")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_back,"SYS0016","SYS0017","uplevel")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")   
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "6" #query&update(查詢,修改,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_upd,"SYS0005","SYS0012","prop")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")   
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "7" #query
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")   
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "8" #exit
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")   
         LET tbs = createToolBarSeparator(tb)##############
    WHEN "9" #query&update(查詢,修改,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_prev,"SYS0003","SYS0003","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_next,"SYS0004","SYS0004","goforw")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_upd,"SYS0005","SYS0012","prop")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")   
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "A" #update(修改,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_upd,"SYS0005","SYS0012","prop")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")   
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "B" #(新增,查詢,前一筆,後一筆,修改,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_add,"SYS0001","SYS0010","new")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_prev,"SYS0003","SYS0003","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_next,"SYS0004","SYS0004","goforw")
         LET tbs = createToolBarSeparator(tb)###############
         LET tbi = createToolBarItem(tb,tb_name_upd,"SYS0005","SYS0012","prop")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "C" #(查詢,前一筆,後一筆,修改,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_prev,"SYS0003","SYS0003","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_next,"SYS0004","SYS0004","goforw")
         LET tbs = createToolBarSeparator(tb)###############
         LET tbi = createToolBarItem(tb,tb_name_upd,"SYS0005","SYS0012","prop")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "D" #(查詢,前一筆,後一筆,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_prev,"SYS0003","SYS0003","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_next,"SYS0004","SYS0004","goforw")
         LET tbs = createToolBarSeparator(tb)###############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "E" #(新增,查詢,前一筆,後一筆,第一筆,最後筆,修改,刪除,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_add,"SYS0001","SYS0010","new")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_prev,"SYS0003","SYS0003","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_next,"SYS0004","SYS0004","goforw")
         LET tbs = createToolBarSeparator(tb)###############
         LET tbi = createToolBarItem(tb,tb_name_first,"SYS0041","SYS0041","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_last,"SYS0042","SYS0042","goforw")
         LET tbs = createToolBarSeparator(tb)###############
         LET tbi = createToolBarItem(tb,tb_name_upd,"SYS0005","SYS0012","prop")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_del,"SYS0006","SYS0013","eraser")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")   
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "F" #(查詢,前一筆,後一筆,第一筆,最後筆,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_prev,"SYS0003","SYS0003","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_next,"SYS0004","SYS0004","goforw")
         LET tbs = createToolBarSeparator(tb)###############
         LET tbi = createToolBarItem(tb,tb_name_first,"SYS0041","SYS0041","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_last,"SYS0042","SYS0042","goforw")
         LET tbs = createToolBarSeparator(tb)###############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "G" #query&update(存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")   
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "H" #(新增,查詢,前一筆,後一筆,刪除,存檔)
         LET tbi = createToolBarItem(tb,tb_name_add,"SYS0001","SYS0010","new")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_prev,"SYS0003","SYS0003","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_next,"SYS0004","SYS0004","goforw")
         LET tbs = createToolBarSeparator(tb)###############
         LET tbi = createToolBarItem(tb,tb_name_del,"SYS0006","SYS0013","eraser")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")   
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
    WHEN "I" #(新增,查詢,前一筆,後一筆,存檔)
         LET tbi = createToolBarItem(tb,tb_name_add,"SYS0001","SYS0010","new")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_prev,"SYS0003","SYS0003","gorev")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_next,"SYS0004","SYS0004","goforw")
         LET tbs = createToolBarSeparator(tb)###############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")   
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
     WHEN "J" #normal(新增,查詢,修改,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_add,"SYS0001","SYS0010","new")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_upd,"SYS0005","SYS0012","prop")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
      WHEN "K" #no update(新增,查詢,刪除,存檔,離開,說明)
         LET tbi = createToolBarItem(tb,tb_name_add,"SYS0001","SYS0010","new")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_qry,"SYS0002","SYS0011","find")
         LET tbs = createToolBarSeparator(tb)############## 
         LET tbi = createToolBarItem(tb,tb_name_del,"SYS0006","SYS0013","eraser")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_save,"SYS0007","SYS0015","save")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,"bye","SYS0008","SYS0008","quit")
         LET tbs = createToolBarSeparator(tb)##############
         LET tbi = createToolBarItem(tb,tb_name_help,"SYS0009","SYS0014","quest")
   END CASE
   
END FUNCTION

FUNCTION createToolBarSeparator(tb)
   DEFINE tb om.DomNode
   DEFINE tbs om.DomNode
   LET tbs = tb.createChild("ToolBarSeparator")
   RETURN tbs
END FUNCTION
 
FUNCTION createToolBarItem(tb,n,t,c,i)
   DEFINE tb om.DomNode
   DEFINE n,t,c,i VARCHAR(100)
   DEFINE tbi om.DomNode
   LET tbi = tb.createChild("ToolBarItem")
   CALL tbi.setAttribute("name",n)
   #CALL tbi.setAttribute("text",t)
   CALL tbi.setAttribute("text",LSTR(t))
   CALL tbi.setAttribute("comment",LSTR(c))
   CALL tbi.setAttribute("image",i)
   RETURN tbi
END FUNCTION