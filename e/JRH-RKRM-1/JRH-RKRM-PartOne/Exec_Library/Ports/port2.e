-> port2.e - Port and message example, run at the same time as port1.e

MODULE 'amigalib/ports',
       'dos/dos',
       'exec/memory',
       'exec/nodes',
       'exec/ports'

ENUM ERR_NONE, ERR_FINDPORT, ERR_CREATEPORT

OBJECT xyMessage
  msg:mn
  x:INT
  y:INT
ENDOBJECT

PROC main() HANDLE
  DEF xyreplyport=NIL:PTR TO mp, xymsg=NIL:PTR TO xyMessage,
      reply:PTR TO xyMessage
  -> Using createPort() with no name because this port need not be public.
  IF NIL=(xyreplyport:=createPort(NIL, 0)) THEN Raise(ERR_CREATEPORT)
  xymsg:=NewM(SIZEOF xyMessage, MEMF_PUBLIC OR MEMF_CLEAR)
  xymsg.msg.ln.type:=NT_MESSAGE       -> Make up a message, including the
  xymsg.msg.length:=SIZEOF xyMessage  -> reply port.
  xymsg.msg.replyport:=xyreplyport
  xymsg.x:=10  -> Our special message information
  xymsg.y:=20

  WriteF('Sending to port1: x = \d y = \d\n', xymsg.x, xymsg.y)

  -> port2 will simply try to put one message to port1, wait for the reply,
  -> and then exit
  IF FALSE=safePutToPort(xymsg, 'xyport') THEN Raise(ERR_FINDPORT)

  WaitPort(xyreplyport)
  IF reply:=GetMsg(xyreplyport)
    -> We don't ReplyMsg since WE initiated the message.
    WriteF('Reply contains: x = \d y = \d\n', xymsg.x, xymsg.y)
  ENDIF

  -> Since we only use this private port for receiving replies, and we sent
  -> only one and got one reply there is no need to cleanup.  For a public port,
  -> or if you pass a pointer to the port to another process, it is a very
  -> good habit to always handle all messages at the port before you delete it.
EXCEPT DO
  IF xymsg THEN Dispose(xymsg)  -> E-Note: not really necessary
  IF xyreplyport THEN deletePort(xyreplyport)
  SELECT exception
  CASE ERR_CREATEPORT
    WriteF('Couldn''t create "xyreplyport"\n')
  CASE ERR_FINDPORT
    WriteF('Can''t find "xyport"; start port1 in a separate shell\n')
  CASE "MEM"
    WriteF('Couldn''t get memory\n')
  ENDSELECT
ENDPROC

PROC safePutToPort(message, portname)
  DEF port:PTR TO mp
  Forbid()
  port:=FindPort(portname)
  IF port THEN PutMsg(port, message)
  Permit()
  -> Once we've done a Permit(), the port might go away and leave us with an
  -> invalid port address.  So we return just a boolean to indicate whether
  -> the message has been sent or not.
  -> E-Note: Be careful - if FindPort() automatically raised an exception
  ->         you might forget to Permit()!
ENDPROC port<>NIL  -> FALSE if the port was not found
