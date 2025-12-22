OPT MODULE, PREPROCESS
OPT POINTER

MODULE 'exec/ports',
       'exec/nodes',
       'rexx/rxslib',
       'rexx/storage',
       'rexxsyslib',
       'amigalib/ports'
MODULE 'exec'

PRIVATE
ENUM ERR_NONE, ERR_LIB, ERR_RMSG, ERR_RSTR
PUBLIC

RAISE ERR_LIB  IF OpenLibrary()=NIL,
      ERR_RMSG IF CreateRexxMsg()=NIL,
      ERR_RSTR IF CreateArgstring()=NIL

PROC rx_SendMsg(portname:ARRAY OF CHAR, s:ARRAY OF CHAR, repPort=NIL:PTR TO mp)
  DEF port:PTR TO mp, msg:PTR TO rexxmsg, myrep:PTR TO mp, lib:PTR TO lib, success
  port:=NIL ; msg:=NIL ; myrep:=NIL ; lib:=NIL ; success:=FALSE
  IF rexxsysbase=NIL
    rexxsysbase:=lib:=OpenLibrary(RXSNAME, 0)
  ENDIF
  IF repPort=NIL
    IF NIL=(repPort:=myrep:=createPort(NILA,0)) THEN Raise("PORT")
  ENDIF
  msg:=CreateRexxMsg(repPort, NILA, portname)
  msg.action:=RXCOMM
  msg.args[0]:=CreateArgstring(s, StrLen(s))
  msg.mn.ln.name:=RXSDIR
  Forbid()
  IF port:=FindPort(RXSDIR) THEN PutMsg(port, msg !!PTR!!PTR TO mn)
  Permit()
  IF port
    WaitPort(repPort)
    msg:=GetMsg(repPort) !!PTR!!PTR TO rexxmsg
    success:=(msg.result1=0)
  ENDIF
FINALLY
  IF msg
    IF msg.args[0] THEN DeleteArgstring(msg.args[0] #ifndef pe_TargetOS_AROS !!VALUE #endif !!ARRAY OF CHAR)
    DeleteRexxMsg(msg)
  ENDIF
  IF myrep THEN deletePort(myrep)
  IF lib
    CloseLibrary(lib)
    rexxsysbase:=NIL
  ENDIF
  exception:=0
ENDPROC success
