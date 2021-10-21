PUBLIC TYPE L2ACK RECORD
    msghdr STRING, --對應的L3MSG HEADER 
    coil_no CHAR(11),
    ackHeader STRING, --HEADER 
    bufData STRING
    END RECORD

PUBLIC TYPE L3MSG RECORD
    class CHAR(4),
    date STRING,
    time STRING,
    sender CHAR(3),
    receiver CHAR(3),
    len CHAR(6),
    coil_no CHAR(11),
    bufData STRING,
    msgString STRING
    END RECORD

PUBLIC FUNCTION (src_rec L3MSG) genMsgString()
    DEFINE res STRING
    LET res = src_rec.class
    LET res = res || src_rec.date
    LET res = res || src_rec.time
    LET res = res || src_rec.sender
    LET res = res || src_rec.receiver
    LET res = res || src_rec.len
    LET res = res || src_rec.bufData

    LET src_rec.msgString = res
END FUNCTION
