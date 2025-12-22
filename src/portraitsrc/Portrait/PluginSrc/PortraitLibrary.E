MODULE 'exec/ports', 'intuition/screens', 'exec/nodes', 'exec/memory'

LIBRARY 'portrait.library', 1, 12, 'portrait.library 1.12 (7.5.98)' IS checkport,reporterror,sendmsg,request,allocpp,freepp,setgui,addpp,rempp

OBJECT pmsg
  mn:mn
  type:INT
  data1:LONG
  data2:LONG
  data3:LONG
  data4:LONG
  ret:LONG
ENDOBJECT

OBJECT pp
  id:LONG
  gui:PTR TO LONG
  guiopen:CHAR
  name:PTR TO CHAR
  title:PTR TO CHAR
  descr:PTR TO CHAR
  version:INT
  revision:INT
  copyright:PTR TO CHAR
  language:PTR TO CHAR
ENDOBJECT

DEF port:PTR TO mp, msg:PTR TO pmsg, replyport

CONST ERR_NOPORT=-1

ENUM MSG_REQUEST, MSG_ADDPP, MSG_REMPP, MSG_SETGUI

PROC main()
  port:=FindPort('Portrait')
  replyport:=CreateMsgPort()
  msg:=AllocMem(SIZEOF pmsg, MEMF_CLEAR OR MEMF_PUBLIC)
ENDPROC

PROC close()
  DeleteMsgPort(replyport)
  FreeMem(msg, SIZEOF pmsg)
ENDPROC

PROC checkport() RETURN IF port THEN NIL ELSE ERR_NOPORT

PROC reporterror(error)
  DEF ok
  SELECT error
    CASE ERR_NOPORT
      request('Plugins must be called from Portrait', ok:='Ok', NIL)
  ENDSELECT
ENDPROC

PROC sendmsg(mn:PTR TO pmsg)
  mn.ln.succ:=NIL
  mn.ln.pred:=NIL
  mn.ln.type:=NT_MESSAGE
  mn.ln.name:=NIL
  mn.ln.pri:=0
  mn.length:=SIZEOF pmsg
  mn.replyport:=replyport
  PutMsg(port, mn)
  WaitPort(replyport)
  GetMsg(replyport)
ENDPROC

PROC request(body:PTR TO CHAR, gadgets:PTR TO CHAR, args:PTR TO LONG)
  msg.type:=MSG_REQUEST
  msg.data1:=body
  msg.data2:=gadgets
  msg.data3:=args
  sendmsg(msg)
ENDPROC msg.ret

PROC allocpp()
  DEF pp:PTR TO pp
  pp:=AllocMem(SIZEOF pp, MEMF_CLEAR OR MEMF_PUBLIC)
ENDPROC pp

PROC addpp(pp:PTR TO pp)
  msg.type:=MSG_ADDPP
  msg.data1:=pp
  sendmsg(msg)
ENDPROC msg.ret

PROC setgui(pp:PTR TO pp, title:PTR TO CHAR, gui:PTR TO CHAR, tags:PTR TO LONG)
  msg.type:=MSG_SETGUI
  msg.data1:=pp
  msg.data2:=title
  msg.data3:=gui
  msg.data4:=tags
  sendmsg(msg)
ENDPROC msg.ret

PROC rempp(pp:PTR TO pp)
  msg.type:=MSG_REMPP
  msg.data1:=pp
  sendmsg(msg)
ENDPROC msg.ret

PROC freepp(pp:PTR TO pp)
  FreeMem(pp, SIZEOF pp)
ENDPROC
