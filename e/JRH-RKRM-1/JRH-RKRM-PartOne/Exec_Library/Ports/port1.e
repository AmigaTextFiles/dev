-> port1.e - Port and message example, run at the same time as port2.e

MODULE 'amigalib/ports',
       'dos/dos',
       'exec/ports'

ENUM ERR_NONE, ERR_PORT

OBJECT xyMessage
  msg:mn
  x:INT
  y:INT
ENDOBJECT

PROC main() HANDLE
  DEF xyport=NIL:PTR TO mp, xymsg:PTR TO xyMessage,
      portsig, usersig, signal, abort=FALSE
  IF NIL=(xyport:=createPort('xyport', 0)) THEN Raise(ERR_PORT)
  portsig:=Shl(1, xyport.sigbit)
  usersig:=SIGBREAKF_CTRL_C  -> Give user a 'break' signal.

  WriteF('Start port2 in another shell.  CTRL-C here when done.\n')
  -> port1 will wait forever and reply to messages, until the user breaks
  REPEAT
    signal:=Wait(portsig OR usersig)
    -> Since we only have one port that might get messages we have to reply
    -> to, it is not really necessary to test for the portsignal.  If there
    -> is not a message at the port, xymsg simply will be NIL.
    IF signal AND portsig
      WHILE xymsg:=GetMsg(xyport)
        WriteF('port1 received: x = \d y = \d\n', xymsg.x, xymsg.y)
        xymsg.x:=xymsg.x+50  -> Since we have not replied yet to the owner of
        xymsg.y:=xymsg.y+50  -> xymsg, we can change the data contents of xymsg.
        WriteF('port1 replying with: x = \d y = \d\n', xymsg.x, xymsg.y)
        ReplyMsg(xymsg)
      ENDWHILE
    ENDIF
    IF signal AND usersig  -> The user wants to abort.
      abort:=TRUE
    ENDIF
  UNTIL abort
EXCEPT DO
  IF xyport
    -> Make sure the port is empty.
    WHILE xymsg:=GetMsg(xyport) DO ReplyMsg(xymsg)
    deletePort(xyport)
  ENDIF
  SELECT exception
  CASE ERR_PORT;  WriteF('Couldn''t create "xyport"\n')
  ENDSELECT
ENDPROC
