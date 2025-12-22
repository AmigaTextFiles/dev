/* World - ProgSuite V1.0 World program */

MODULE 'intuition/intuition', 'intuition/screens', 'graphics/view'
MODULE 'amigalib/ports', 'dos/dos'
MODULE 'exec/memory', 'exec/nodes', 'exec/ports'

MODULE '*Defs'

/* Screen size */
CONST SIZEX = 640, SIZEY = 480

/* Variable to hold our own name (should be a constant...) */
DEF progname: PTR TO CHAR

/* Communications variables */
DEF worldport = NIL: PTR TO mp,
    wakemsg = NIL: PTR TO portMessage, finishmsg = NIL: PTR TO portMessage,
    recvmsg: PTR TO portMessage

/* Screen and window pointers */
DEF progsuitescreen: PTR TO screen, viewwin: PTR TO window

/* The main procedure */

PROC main () HANDLE
  progname := 'World'
  progsuitescreen := NIL ; viewwin := NIL
  worldport := portCreate ('WorldPort', progname)
  wakemsg := messageCreate (worldport, progname)
  wakemsg.msn := WAKEMSG  -> Our WakeUp message
  finishmsg := messageCreate (worldport, progname)
  finishmsg.msn := FINISHMSG  -> Our Finish message

  -> Open the out-the-cabin view window
  initView ()

  -> World will wait for a QUIT message and reply it,
  -> and then exit

  -> Report our readyness to the master
  WriteF ('\s: Sending WakeUp message (\d) to Master...\n', progname, wakemsg.msn)
  IF FALSE = messageSend (wakemsg, 'MasterPort') THEN Raise (ERR_FINDPORT)

  -> Wait for messages, and take appropriate actions
  worldLoop ()

  -> Finish off
  finishView ()

  Raise (ERR_NONE)
EXCEPT DO
  IF worldport THEN portRemove (worldport)
  IF wakemsg THEN Dispose (wakemsg)
  IF finishmsg THEN Dispose (finishmsg)
  IF (viewwin) THEN finishView ()
  SELECT exception
  CASE ERR_FINDSCREEN
    WriteF ('\s: Can''t find ProgSuite Screen: This program should be started from Master!\n', progname)
  CASE "WIN"
    UnlockPubScreen (NIL, progsuitescreen)
    WriteF ('\s: Can''t open window!\n', progname)
  CASE "PORT"
    WriteF ('\s: Can''t create messageport "WorldPort"!\n', progname)
  CASE ERR_FINDPORT
    WriteF ('\s: Can''t find messageport "MasterPort"!\n', progname)
  CASE "MEM"
    WriteF ('\s: Can''t get memory!\n', progname)
  ENDSELECT
ENDPROC

/* procedure to display the outside world view */

PROC initView ()
DEF width = 480, height = 200

  -> Open our window on the common screen (horizontally centered, and as high as possible)
  progsuitescreen := LockPubScreen ('ProgSuiteScreen')
  viewwin := OpenW ((SIZEX - width) / 2, 0, width, height,
->                    IDCMP_MOUSEBUTTONS OR IDCMP_CLOSEWINDOW OR IDCMP_INTUITICKS,
                    IDCMP_MOUSEBUTTONS OR IDCMP_CLOSEWINDOW,
                    WFLG_CLOSEGADGET OR WFLG_BORDERLESS, 
                    'World window - Hit close box to finish demo', NIL, NIL, NIL,
                    [WA_PUBSCREEN, progsuitescreen, 0])
  UnlockPubScreen (NIL, progsuitescreen)

ENDPROC

/* Procedure to close the view window */

PROC finishView ()
  CloseW (viewwin) ; viewwin := NIL
ENDPROC

/* The main message loop */

PROC worldLoop ()
DEF portsig, winsig, signal, finish = FALSE
  portsig := Shl (1, worldport.sigbit)
  winsig := Shl (1, viewwin.userport.sigbit)
  REPEAT
    signal := Wait (portsig OR winsig)
    IF signal AND winsig THEN handleWindowMessages ()
    IF signal AND portsig THEN finish := handlePortMessages ()
  UNTIL finish
ENDPROC

/* Procedure to handle incoming Exec messages */

PROC handlePortMessages ()
DEF finish = FALSE
  WHILE recvmsg := GetMsg (worldport)
    messageCheckOwn (recvmsg, worldport, progname)
    IF recvmsg.msn = QUITWORLDMSG THEN finish := TRUE
    messageReply (recvmsg, worldport)
  ENDWHILE
ENDPROC finish

/* Procedure to handle Intuition messages */

PROC handleWindowMessages ()
DEF recvimsg: PTR TO intuimessage, class, code
  WHILE recvimsg := GetMsg (viewwin.userport)
    class := recvimsg.class ; code := recvimsg.code
    WriteF ('\s: IDCMP received: \d \d\n', progname, class, code)
    SELECT class
      CASE IDCMP_CLOSEWINDOW
        WriteF ('\s: Sending Finish message (\d) to Master...\n', progname, finishmsg.msn)
        messageSend (finishmsg, 'MasterPort')
    ENDSELECT
    messageReply (recvimsg, worldport)
  ENDWHILE
ENDPROC
