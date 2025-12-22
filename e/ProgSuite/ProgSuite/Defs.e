/* Definitions - included in all ProgSuite programs (V1.0) */

OPT MODULE
OPT EXPORT

MODULE 'intuition/intuition', 'intuition/screens', 'graphics/view'
MODULE 'tools/ilbm', 'tools/ilbmdefs'
MODULE 'amigalib/ports', 'dos/dos'
MODULE 'exec/memory', 'exec/nodes', 'exec/ports'

/* Exception values */

ENUM ERR_NONE, ERR_FINDSCREEN, ERR_FINDPORT

/* Automatic Exceptions */

RAISE	"WIN"		IF OpenW () = NIL,
	"SCR"		IF OpenS () = NIL,
	ERR_FINDSCREEN 	IF LockPubScreen () = NIL

/* Message types and structure */

ENUM WAKEMSG, FINISHMSG, QUITDISPLMSG, QUITCONTRMSG, QUITWORLDMSG

OBJECT portMessage
  msg: mn
  msc: LONG
  msn: INT
ENDOBJECT

/* Common Procedures */

PROC portCreate (portname: PTR TO mp, progname: PTR TO CHAR) HANDLE
DEF newport: PTR TO mp
  IF NIL = (newport := createPort (portname, 0)) THEN Raise ("PORT")
EXCEPT DO
  SELECT exception
  CASE "PORT"
    WriteF ('\s: Couldn''t create messageport "\s"!\n', progname, portname)
    ReThrow ()
  ENDSELECT
ENDPROC newport

PROC portRemove (msgport: PTR TO mp)
DEF portmsg: PTR TO portMessage
  -> Make sure the port is empty before deleting it
  WHILE portmsg := GetMsg (msgport) DO messageReply (portmsg, msgport)
  deletePort (msgport)
ENDPROC

PROC messageCreate (replyport: PTR TO mp, progname: PTR TO CHAR) HANDLE
DEF newmessage: PTR TO portMessage
  newmessage := NewM (SIZEOF portMessage, MEMF_PUBLIC OR MEMF_CLEAR)
  newmessage.msg.ln.type := NT_MESSAGE         -> Make up a message, including the
  newmessage.msg.length := SIZEOF portMessage  -> reply port.
  newmessage.msg.replyport := replyport
  newmessage.msc := 0                          -> i.e. this is NOT an IntuiMessage
EXCEPT DO
  SELECT exception
  CASE "MEM"
    WriteF ('\s: Couldn''t create port message!\n', progname)
    ReThrow ()
  ENDSELECT
ENDPROC newmessage

PROC messageSend (message: PTR TO portMessage, portname: PTR TO mp)
DEF port: PTR TO mp
  Forbid ()
  port := FindPort (portname)
  IF port THEN PutMsg (port, message)
  Permit ()
ENDPROC port <> NIL	-> Returns FALSE if the port was not found

PROC messageReply (message: PTR TO portMessage, ownportname: PTR TO mp)
DEF result = FALSE
  IF (message.msg.replyport <> NIL) AND (message.msg.replyport <> ownportname)
    WriteF ('messageReply: replying message \d \d\n', message.msc, message.msn)
    ReplyMsg (message)
    result := TRUE
  ENDIF
ENDPROC result		-> Returns FALSE if it was our own message

PROC messageCheckOwn (message: PTR TO portMessage, ownportname: PTR TO mp, progname: PTR TO CHAR)
  IF message.msg.replyport = ownportname
    WriteF ('\s: Reply received: \d \d\n', progname, message.msc, message.msn)
  ELSE
    WriteF ('\s: Message received: \d \d\n', progname, message.msc, message.msn)
  ENDIF
ENDPROC
