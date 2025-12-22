OPT MODULE
OPT PREPROCESS

MODULE 'exec/ports','exec/nodes','rexxsyslib','rexx/storage','amigalib/ports'

EXPORT ENUM CMD,FUNC

EXPORT OBJECT msgport
    msgport:PTR TO mp
    ENDOBJECT

PROC create(name=NIL:PTR TO LONG,pri=0) OF msgport
    IF name THEN IF FindPort(name) THEN Throw("mp",-2)
    self.msgport:=createPort(name,pri)
    IF (self.msgport=NIL)
        Throw("mp",-1)
        ENDIF
    ENDPROC self.msgport
PROC delete() OF msgport
    IF self.msgport
        deletePort(self.msgport)
        ENDIF
    ENDPROC
PROC end() OF msgport IS self.delete()
PROC sigbit() OF msgport IS self.msgport.sigbit
PROC sigbitA() OF msgport IS Shl(1,self.sigbit())
PROC getmsg() OF msgport IS GetMsg(self.msgport)
PROC wait() OF msgport IS WaitPort(self.msgport)
PROC putmsg(port:PTR TO mp,m:PTR TO mn) OF msgport IS PutMsg(port,m)
PROC putrxcmd(type,cmd:PTR TO LONG,port=NIL:PTR TO LONG) OF msgport
    DEF rxm:PTR TO rexxmsg,rxport:PTR TO mp,rc=0,res=NIL,help:PTR TO LONG
    IF (rxm:=CreateRexxMsg(self.msgport,NIL,NIL))
        IF type=CMD
            rxm.mn.ln.name:="REXX"
            rxm.action:=RXCOMM
        ELSEIF type:=FUNC
            rxm.mn.ln.name:='REXX'
            rxm.action:=(RXFUNC OR RXFF_RESULT)
            ENDIF
        help:=rxm.args
        help[0]:=CreateArgstring(cmd,StrLen(cmd))
        IF (rxport:=FindPort(port))
            self.putmsg(rxport,rxm)
        ELSE
            RETURN (rc=-255),(res=NIL)
            ENDIF
        self.wait()
        WHILE (rxm:=self.getmsg())
            rc:=rxm.result1
            IF type=FUNC THEN res:=rxm.result2
            ClearRexxMsg(rxm,1)
            DeleteRexxMsg(rxm)
            ENDWHILE
        RETURN rc,res
        ENDIF
    Throw("mp",-3)
    ENDPROC
