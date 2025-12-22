/* Display - ProgSuite V1.0 Display program */

MODULE 'intuition/intuition', 'intuition/screens', 'graphics/view'
MODULE 'tools/ilbm', 'tools/ilbmdefs'
MODULE 'amigalib/ports', 'dos/dos'
MODULE 'exec/memory', 'exec/nodes', 'exec/ports'

MODULE '*Defs'

/* Screen size */
CONST SIZEX = 640, SIZEY = 480

/* Variable to hold our own name (should be a constant...) */
DEF progname: PTR TO CHAR

/* Communication variables */
DEF displayport = NIL: PTR TO mp,
    wakemsg = NIL: PTR TO portMessage, finishmsg = NIL: PTR TO portMessage,
    recvmsg: PTR TO portMessage

/* Screen and window pointers */
DEF progsuitescreen: PTR TO screen, panelwin: PTR TO window

/* variables for between-calls memory */
DEF mx = 0, my = 0, prevsecs = 0

/* The main procedure */

PROC main () HANDLE

  progname := 'Display'
  progsuitescreen := NIL ; panelwin := NIL
  displayport := portCreate ('DisplayPort', progname)
  wakemsg := messageCreate (displayport, progname)
  wakemsg.msn := WAKEMSG  -> Our WakeUp message
  finishmsg := messageCreate (displayport, progname)
  finishmsg.msn := FINISHMSG  -> Our Finish message

  -> Display the instruments panel
  initPanel ()

  -> Report our readyness to the master
  WriteF ('\s: Sending WakeUp message (\d) to Master...\n', progname, wakemsg.msn)
  IF FALSE = messageSend (wakemsg, 'MasterPort') THEN Raise (ERR_FINDPORT)

  -> Wait for messages, and act accordingly
  displayLoop ()

  -> Finish off
  finishPanel ()

  Raise (ERR_NONE)
EXCEPT DO
  IF displayport THEN portRemove (displayport)
  IF wakemsg THEN Dispose (wakemsg)
  IF finishmsg THEN Dispose (finishmsg)
  IF (panelwin) THEN finishPanel ()
  SELECT exception
  CASE ERR_FINDSCREEN
    WriteF ('\s: Can''t find ProgSuite Screen: This program should be started from Master!\n', progname)
  CASE "WIN"
    UnlockPubScreen (NIL, progsuitescreen)
    WriteF ('\s: Can''t open window!\n', progname)
  CASE "PORT"
    WriteF ('\s: Can''t create messageport "DisplayPort"!\n', progname)
  CASE ERR_FINDPORT
    WriteF ('\s: Can''t find messageport "MasterPort"!', progname)
  CASE "MEM"
    WriteF ('\s: Can''t get memory!\n', progname)
  ENDSELECT
ENDPROC

/* procedures to display/remove the instruments panel */

PROC initPanel ()
DEF ilbm, filename[30]:STRING, width, height, bmh:PTR TO bmhd, pi:PTR TO picinfo, bmptr = NIL

  StringF (filename, 'PROGDIR:Pictures/panel.iff')
  IF ilbm := ilbm_New (filename, 0)
    ilbm_LoadPicture (ilbm, [ILBML_GETBITMAP, {bmptr}, 0])

    -> get a pointer to the image's picture-info.
    -> extract the bitmap header, and read the picture's size.
    pi := ilbm_PictureInfo (ilbm)
    bmh := pi.bmhd
    width := bmh.w
    height := bmh.h
    -> the ilbm-handle is no longer needed, we can free it
    ilbm_Dispose (ilbm)

    -> if a bitmap actually opened,
    IF bmptr
      -> Open our window on the common screen (horizontally centered, and as low as possible)
      progsuitescreen := LockPubScreen ('ProgSuiteScreen')
      panelwin := OpenW ((SIZEX - width) / 2, (SIZEY - height), width, height,
->                         IDCMP_MOUSEBUTTONS OR IDCMP_INTUITICKS,
                         IDCMP_MOUSEBUTTONS,
                         WFLG_BORDERLESS OR WFLG_RMBTRAP, NIL, NIL, NIL, NIL,
                         [WA_PUBSCREEN, progsuitescreen, 0])
      UnlockPubScreen (NIL, progsuitescreen)

      -> blit the picture into our window
      -> blit into actual dimensions the OS gave us
      -> (the window might be smaller than the picture)
      BltBitMapRastPort (bmptr, 0, 0, 
                         panelwin.rport, 0, 0,
                         width, height, $c0);
      -> now don't need the bitmap anymore
      ilbm_FreeBitMap (bmptr)
      bmptr := NIL
    ENDIF
  ELSE
    WriteF ('\s: Could not open picture file "\s"!\n', progname, filename)
  ENDIF
ENDPROC

PROC finishPanel ()
  CloseW (panelwin) ; panelwin := NIL
ENDPROC

/* The main message loop */

PROC displayLoop ()
  DEF portsig, winsig, usersig, signal, finish = FALSE
  portsig := Shl (1, displayport.sigbit)
  winsig := Shl (1, panelwin.userport.sigbit)
  usersig := SIGBREAKF_CTRL_C  -> Give user a 'break' signal.
                               -> Note: does not seem to work here...

  REPEAT
    -> (for now, wait for the QUIT message)
    signal := Wait (portsig OR winsig OR usersig)
    IF signal AND usersig  -> The user wants to abort.
      WriteF ('\s: Sending Finish message (\d) to Master...\n', progname, finishmsg.msn)
      messageSend (finishmsg, 'MasterPort') ; finish := TRUE
    ENDIF
    IF signal AND winsig THEN handleWindowMessages ()
    IF signal AND portsig THEN finish := handlePortMessages ()
  UNTIL finish

ENDPROC

/* Procedure to handle incoming Exec messages */

PROC handlePortMessages ()
DEF mesnum, finish = FALSE
  WHILE recvmsg := GetMsg (displayport)
    messageCheckOwn (recvmsg, displayport, progname)
    mesnum := recvmsg.msn
    SELECT mesnum
      CASE QUITDISPLMSG
        finish := TRUE
    ENDSELECT
    messageReply (recvmsg, displayport)
  ENDWHILE
ENDPROC finish

/* Procedure to handle Intuition messages */

PROC handleWindowMessages ()
DEF recvimsg: PTR TO intuimessage, class, code
  WHILE recvimsg := GetMsg (panelwin.userport)
    class := recvimsg.class ; code := recvimsg.code
    WriteF ('\s: IDCMP received: \d \d\n', progname, class, code)
    SELECT class
      CASE IDCMP_INTUITICKS
        WriteF ('\s: IntuiTick message received\n', progname)
        handleTimeTick (recvimsg.seconds, recvimsg.micros)
      CASE IDCMP_MOUSEBUTTONS
        WriteF ('\s: MouseButton message received: \d \d \d\n', progname, code, recvimsg.mousex, recvimsg.mousey)
        handleMouseButtons (code, recvimsg.mousex, recvimsg.mousey)
    ENDSELECT
    messageReply (recvimsg, displayport)
  ENDWHILE
ENDPROC

PROC handleTimeTick (seconds, micros)
  IF prevsecs = 0 THEN prevsecs := seconds
  IF seconds > prevsecs
    WriteF ('\s: One second passed\n', progname)
->    messageSend (tickmsg, 'MasterPort')
    prevsecs := seconds
  ENDIF
ENDPROC

PROC handleMouseButtons (icode, imx, imy)
  SELECT icode
    CASE SELECTDOWN
        WriteF ('\s: SelectDown message received: \d \d\n', progname, imx, imy)
      mx := imx ; my := imy
    CASE SELECTUP
        WriteF ('\s: SelectUp message received: \d \d\n', progname, imx, imy)
      IF mx = imx AND my = imy THEN checkButton (mx, my)
    CASE MENUDOWN
        WriteF ('\s: MenuDown message received: \d \d\n', progname, imx, imy)
      mx := imx ; my := imy
    CASE MENUUP
        WriteF ('\s: MenuUp message received: \d \d\n', progname, imx, imy)
      IF mx = imx AND my = imy THEN doSubwin (mx, my)
  ENDSELECT
ENDPROC

PROC doSubwin (mx, my)
  WriteF ('\s: Subwindow selected...\n', progname)
ENDPROC

PROC checkButton (mx, my)
  WriteF ('\s: Button selected...\n', progname)
ENDPROC
