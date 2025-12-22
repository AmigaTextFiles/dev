/* Master - the ProgSuite V1.0 Master program */

MODULE 'intuition/intuition', 'intuition/screens', 'graphics/view'
MODULE 'tools/ilbm', 'tools/ilbmdefs'
MODULE 'amigalib/ports', 'dos/dos'
MODULE 'exec/memory', 'exec/nodes', 'exec/ports'

MODULE '*Defs'

/* Screen size */
CONST SIZEX = 640, SIZEY = 480, SIZEZ = 4

/* Variable to hold our own name (should be a constant...) */
DEF progname: PTR TO CHAR

/* Custom screen we use for everything */
DEF sptr = NIL

/* background window for the close gadget */
DEF bwptr = NIL

/* offscreen bitmap, private screen and window for the initial picture */
DEF bmptr = NIL, psptr:PTR TO screen, pwptr:PTR TO window

/* messageport and messages for inter-program communication */
DEF masterport = NIL: PTR TO mp,
    sendmsg = NIL: PTR TO portMessage, recvmsg: PTR TO portMessage

/* stuff for starting related programs */
DEF homelock, homepath[100] : STRING, tmpstr[2] : STRING, command[100] : STRING
DEF prognames[3] : ARRAY OF LONG, quitmsg[3] : ARRAY, auxflags[3] : ARRAY

PROC main () HANDLE

  initVariables ()
  initScreen ()

  -> Show a picture to kill time during program setup
  initPicture ()

  -> set up the communications port, and the final QUIT message
  masterport := portCreate ('MasterPort', progname)
  sendmsg := messageCreate (masterport, progname)

  -> Find the path to where we live
  homelock := GetProgramDir ()
  NameFromLock (homelock, homepath, 100)
  SetStr (homepath, StrLen (homepath))
  IF (StrCmp (RightStr (tmpstr, homepath, 1), ':') = FALSE) THEN StrAdd (homepath, '/')

  -> Start other  program(s), and wait for their WakeUp messages
  IF startAuxiliaries ()

    -> Initialized; now remove startup picture
    finishPicture ()

    -> Main program loop here
    mainLoop ()

  ENDIF

  -> at end: send QUIT messages to the other programs
  stopAuxiliaries ()
 
  -> finished ; normal termination
  Raise (ERR_NONE)
EXCEPT DO
  WriteF ('\s: Exception: \d\n', progname, exception)
  finishPicture ()
  IF masterport THEN portRemove (masterport)
  IF sendmsg THEN Dispose (sendmsg)
  IF bwptr THEN CloseW (bwptr)
  IF sptr THEN CloseS (sptr)
  SELECT exception
  CASE "WIN"
    WriteF ('\s: Could not open window!\n', progname)
  CASE "SCR"
    WriteF ('\s: Could not open screen!\n', progname)
  ENDSELECT
ENDPROC

PROC initVariables ()
  progname     := 'Master'
  prognames[0] := 'Display' ; quitmsg[0] := QUITDISPLMSG ; auxflags[0] := FALSE
  prognames[1] := 'Control' ; quitmsg[1] := QUITCONTRMSG ; auxflags[1] := FALSE
  prognames[2] := 'World'   ; quitmsg[2] := QUITWORLDMSG ; auxflags[2] := FALSE
ENDPROC

/* procedure to initialize the display screen */

PROC initScreen ()
  sptr := OpenS (SIZEX, SIZEY, SIZEZ, V_HIRES OR V_LACE, 'ProgSuite Master',
                 [SA_TYPE, PUBLICSCREEN,
                  SA_PUBNAME, 'ProgSuiteScreen',
                  0])
  ShowTitle (sptr, FALSE)
  SetColour (sptr,  0,   0,   0,   0)    -> Black (background)
  SetColour (sptr,  1, 238, 204, 170)    -> Tan
  SetColour (sptr,  2, 204, 102,  51)    -> Brown
  SetColour (sptr,  3, 255, 102,  68)    -> Orange
  SetColour (sptr,  4,   0, 102,   0)    -> DarkGreen
  SetColour (sptr,  5,  51, 255,  17)    -> Green
  SetColour (sptr,  6,   0,   0, 221)    -> DarkBlue
  SetColour (sptr,  7,  34, 204, 221)    -> Blue
  SetColour (sptr,  8, 221,   0,   0)    -> DarkRed
  SetColour (sptr,  9, 255, 102,   0)    -> Red
  SetColour (sptr, 10, 221, 187,   0)    -> DarkYellow
  SetColour (sptr, 11, 255, 238,   0)    -> Yellow
  SetColour (sptr, 12, 255, 255, 255)    -> White
  SetColour (sptr, 13, 204, 204, 204)    -> Grey
  SetColour (sptr, 14, 136, 136, 136)    -> DarkGrey
  SetColour (sptr, 15,   0,   0,   0)    -> Black
  bwptr := OpenW (0, 0, SIZEX, SIZEY, NIL, WFLG_BACKDROP OR WFLG_BORDERLESS,
                  'Programs Communication Demo V0.1 (22 June 1996) Hans Jansen',
                  sptr, CUSTOMSCREEN, NIL)
  PubScreenStatus (sptr, 0)	-> make our screen public, for use by related programs
ENDPROC

/* procedures to display/remove the initial picture */

PROC initPicture ()
DEF ilbm, filename[30]:STRING, width, height, depth, bmh:PTR TO bmhd, pi:PTR TO picinfo, i, pc:PTR TO CHAR

  StrCopy (filename, 'PROGDIR:Pictures/startup.iff')
  IF ilbm := ilbm_New (filename, 0)
    ilbm_LoadPicture (ilbm, [ILBML_GETBITMAP, {bmptr}, 0])

    -> get a pointer to the image's picture-info.
    -> extract the bitmap header, and read the picture's size.
    pi := ilbm_PictureInfo (ilbm)
    bmh := pi.bmhd
    width := bmh.w
    height := bmh.h
    depth := bmh.planes

    -> If a colour-map is included in the picture, give it its own screen; 
    -> otherwise open it on our main () screen
    IF pi.palraw
      pc := pi.palraw
      psptr := OpenS (width, height, depth, V_HIRES OR V_LACE, ' Load Picture', [SA_BEHIND, TRUE, SA_LEFT, (SIZEX - width) / 2, SA_TOP, (SIZEY - height) / 2, 0])
      FOR i := 0 TO pi.colours-1
        SetRGB4 (psptr.viewport, i, pc[i*3]/16, pc[(i*3)+1]/16, pc[(i*3)+2]/16)
      ENDFOR
    ELSE
      psptr := sptr
    ENDIF

    -> the ilbm-handle is no longer needed, we can free it
    ilbm_Dispose (ilbm)

    -> if a bitmap actually opened, open a window, and blit it in
    IF bmptr
      IF pwptr := OpenW (0, 0, width, height, NIL, WFLG_BORDERLESS, NIL, psptr, CUSTOMSCREEN, NIL)

        -> blit into actual dimensions the OS gave us
        -> (the window might be smaller than the picture)
        BltBitMapRastPort (bmptr, 0, 0, 
                           pwptr.rport, 0, 0, 
                           width, height, $c0);

        ilbm_FreeBitMap (bmptr)
        bmptr := NIL
      ENDIF
    ScreenToFront (psptr)
    ENDIF
  ELSE
    WriteF ('\s: Could not open picture file "\s"!\n', progname, filename)
  ENDIF

ENDPROC

PROC finishPicture ()
  IF psptr THEN ScreenToBack (psptr)
  IF pwptr
    CloseW (pwptr) ; pwptr := NIL
  ENDIF
  IF psptr
    IF psptr <> sptr
      CloseS (psptr) ; psptr := NIL
    ENDIF
  ENDIF
  IF bmptr
    ilbm_FreeBitMap (bmptr) ; bmptr := NIL
  ENDIF
ENDPROC

/* Procedures to start/stop the other programs in the package */

PROC startAuxiliaries ()
DEF i
  FOR i := 0 TO 2
    WriteF ('\s: Starting \s...\n', progname, prognames[i])
    StringF (command, 'Run \s\s\n', homepath, prognames[i])
    auxflags[i] := Execute (command, 0, stdout)
    IF auxflags[i]
      WriteF ('\s: Waiting for \s''s WakeUp message...\n', progname, prognames[i])
      WaitPort (masterport)
      IF recvmsg := GetMsg (masterport) THEN messageReply (recvmsg, masterport)
      messageCheckOwn (recvmsg, masterport, progname)
    ENDIF
  ENDFOR
ENDPROC auxflags[0] AND auxflags[1] AND auxflags[2]

PROC stopAuxiliaries ()
DEF i, t[14] : STRING
  FOR i := 0 TO 2
    IF auxflags[i]
      sendmsg.msn := quitmsg[i]  -> Our Quit messages
      WriteF ('\s: Sending QUIT message (\d) to \s...\n', progname, sendmsg.msn, prognames[i])
      StrCopy (t, prognames[i]) ; StrAdd (t, 'Port')
      IF FALSE = messageSend (sendmsg, t) THEN Raise (ERR_FINDPORT)
      WriteF ('\s: Waiting for reply...\n', progname)
      WaitPort (masterport)
      recvmsg := GetMsg (masterport)
      messageCheckOwn (recvmsg, masterport, progname)
    ENDIF -> auxflags[i]
  ENDFOR
ENDPROC

/* The main message loop */

PROC mainLoop ()
  DEF abort = FALSE

  -> mainLoop will wait forever and reply to messages, until a FINISH message arrives
  REPEAT
    WaitPort (masterport)
    WHILE recvmsg := GetMsg (masterport)
      messageCheckOwn (recvmsg, masterport, progname)
      IF recvmsg.msn = FINISHMSG THEN abort := TRUE
      messageReply (recvmsg, masterport)
    ENDWHILE
  UNTIL abort
  ScreenToBack (sptr)
  WriteF ('\s: Finish message received: exiting\n', progname)
ENDPROC
