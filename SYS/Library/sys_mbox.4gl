FUNCTION __Waring_ok(arg_type, arg_message)
    DEFINE arg_type, arg_message STRING
    IF arg_type = "Fun" THEN
        LET arg_message = "Function " || arg_message || " ERROR!"
    ELSE IF arg_type = "NoData" THEN
        LET arg_message = arg_message || "資料不存在,請確認!"    
    END IF
    END IF
    CALL __mbox_ok("提示", arg_message, "stop")

END FUNCTION

FUNCTION __mbox_ok(title, message, icon)
    DEFINE title, message, icon STRING
    MENU title ATTRIBUTES(STYLE = 'dialog', IMAGE = icon, COMMENT = message)
        COMMAND "OK"
    END MENU
END FUNCTION

FUNCTION __mbox_yn(title, message, icon)
    DEFINE title, message, icon STRING
    DEFINE r SMALLINT
    MENU title ATTRIBUTES(STYLE = 'dialog', IMAGE = icon, COMMENT = message)
        COMMAND "確定"
            LET r = TRUE
        COMMAND "取消"
            LET r = FALSE
    END MENU
    RETURN r
END FUNCTION

