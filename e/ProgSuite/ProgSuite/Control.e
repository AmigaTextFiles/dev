/* Control - ProgSuite V1.0 Control program */

MODULE 'amigalib/ports', 'dos/dos'
MODULE 'exec/memory', 'exec/nodes', 'exec/ports'

MODULE '*Defs'

/* Variable to hold our own name (should be a constant...) */
DEF progname: PTR TO CHAR

/* Communications variables */
DEF controlport = NIL: PTR TO mp,
    wakemsg = NIL: PTR TO portMessage, recvmsg: PTR TO portMessage

PROC main () HANDLE
  progname := 'Control'
  controlport := portCreate ('ControlPort', progname)
  wakemsg := messageCreate (controlport, progname)
  wakemsg.msn := WAKEMSG  -> Our WakeUp message

  -> Control will wait for a QUIT message and reply it,
  -> and then exit

  -> Report our readyness to the master
  WriteF ('\s: Sending WakeUp message (\d) to Master...\n', progname, wakemsg.msn)
  IF FALSE = messageSend (wakemsg, 'MasterPort') THEN Raise (ERR_FINDPORT)

  -> Do our job
  controlLoop ()

  Raise (ERR_NONE)
EXCEPT DO
  IF controlport THEN portRemove (controlport)
  IF wakemsg THEN Dispose (wakemsg)
  SELECT exception
  CASE "PORT"
    WriteF ('\s: Can''t create messageport "ControlPort"!\n', progname)
  CASE ERR_FINDPORT
    WriteF ('\s: Can''t find messageport "MasterPort": This program should be started from Master!', progname)
  CASE "MEM"
    WriteF ('\s: Can''t get memory!\n', progname)
  ENDSELECT
ENDPROC

/* The main message loop */

PROC controlLoop ()

  REPEAT
    -> (for now, wait for the QUIT message)
    WaitPort (controlport)
    IF recvmsg := GetMsg (controlport)
      messageCheckOwn (recvmsg, controlport, progname)
      messageReply (recvmsg, controlport)
    ENDIF
  UNTIL recvmsg.msn = QUITCONTRMSG

ENDPROC
