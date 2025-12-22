OPT MODULE

MODULE 'exec/nodes', 'exec/ports'


EXPORT OBJECT msg
   mn:mn
   command:LONG ->anything user wants
   data:LONG  -> data ..
   error:LONG ->positive values = user error
              ->negative values = do error
              ->zero = no error :)
ENDOBJECT


EXPORT PROC doMsgQName(portname, command, data=NIL)
   DEF port
   ->Forbid()
   port:=FindPort(portname)
   IF port THEN doMsgQ(port, command, data)
   ->Permit()
ENDPROC port

EXPORT PROC doMsgQ(toport, command, data=NIL)
   DEF msg:PTR TO msg, er
   NEW msg
   doMsg(toport, msg, command, data)
   er:=msg.error
   END msg
ENDPROC er

EXPORT PROC doMsgQF(toport, replyport, command, data=NIL)
   DEF msg:PTR TO msg, er
   NEW msg
   doMsgF(toport, msg, replyport, command, data)
   er:=msg.error
   END msg
ENDPROC er

EXPORT PROC doMsgName(portname, msg, command, data=NIL)
   DEF port
   Forbid()
   port:=FindPort(portname)
   IF port THEN doMsg(port, msg, command, data)
   Permit()
ENDPROC port

EXPORT PROC doMsg(toport, msg:PTR TO msg, command, data=NIL)
   DEF replyport
   replyport:=CreateMsgPort()
   IF replyport = NIL THEN RETURN NIL
   doMsgF(toport, msg, replyport, command, data)
   DeleteMsgPort(replyport)
ENDPROC msg


EXPORT PROC doMsgF(toport, msg:PTR TO msg, replyport, command, data=NIL)
   msg.mn.ln.type:=NT_MESSAGE
   msg.mn.length:=SIZEOF msg
   msg.mn.replyport:=replyport
   msg.command:=command
   msg.data:=data
   msg.error:=NIL
   PutMsg(toport, msg)
   WaitPort(msg.mn.replyport)
   WHILE GetMsg(replyport) DO GetMsg(replyport)
ENDPROC msg

EXPORT PROC waitMsg(port)
   DEF msg
   WaitPort(port)
   msg:=GetMsg(port)
ENDPROC msg

EXPORT PROC emptyPort(port)
   WHILE GetMsg(port)
      ReplyMsg(port)
   ENDWHILE
ENDPROC

EXPORT PROC getLastMsg(port)
   DEF msg, lastmsg=NIL
   WHILE (msg:=GetMsg(port))
      IF lastmsg THEN ReplyMsg(lastmsg)
      lastmsg:=msg
   ENDWHILE
ENDPROC lastmsg
