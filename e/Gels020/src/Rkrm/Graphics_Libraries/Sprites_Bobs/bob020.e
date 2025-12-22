-> bob.e - Simple Bob example

->>> Header (globals)
OPT PREPROCESS

MODULE 'dos/dos',
       'exec/memory',
       'exec/ports',
       'graphics/gels',
       'intuition/intuition',
       'intuition/screens',
       '*animtools020'

ENUM ERR_NONE, ERR_KICK, ERR_WIN

RAISE ERR_KICK IF KickVersion()=FALSE,
      ERR_WIN  IF OpenWindow()=NIL

CONST GEL_SIZE=4

DEF bob_data1, bob_data2, myNewBob:PTR TO newBob
->>>

->>> PROC bobDrawGList(rport, vport)
-> Draw the Bobs into the RastPort.
PROC bobDrawGList(rport, vport)
  SortGList(rport)
  DrawGList(rport, vport)
  -> If the GelsList includes true VSprites, MrgCop() and LoadView() here
  WaitTOF()
ENDPROC
->>> 

->>> PROC process_window(win:PTR TO window, myBob:PTR TO bob)
-> Process window and dynamically change bob:  Get messages.  Go away on
-> IDCMP_CLOSEWINDOW.  Update and redisplay bob on IDCMP_INTUITICKS.  Wait for
-> more messages.
PROC process_window(win:PTR TO window, myBob:PTR TO bob)
  DEF msg:PTR TO intuimessage
  LOOP
    Wait(Shl(1, win.userport.sigbit))
    WHILE msg:=GetMsg(win.userport)
      -> Only IDCMP_CLOSEWINDOW AND IDCMP_INTUITICKS are active
      IF msg.class=IDCMP_CLOSEWINDOW
        ReplyMsg(msg)
        RETURN
      ENDIF
      -> Must be IDCMP_INTUITICKS: change x and y values on the fly.  Note: do
      -> not have to add window offset, Bob is relative to the window (sprite
      -> relative to screen).
      myBob.bobvsprite.x:=msg.mousex+20
      myBob.bobvsprite.y:=msg.mousey+1
      ReplyMsg(msg)
    ENDWHILE
    -> After getting a message, change image data on the fly
    myBob.bobvsprite.imagedata:=IF myBob.bobvsprite.imagedata=bob_data1 THEN
                                  bob_data2 ELSE bob_data1
    InitMasks(myBob.bobvsprite)  -> Set up masks for new image
    bobDrawGList(win.rport, ViewPortAddress(win))
  ENDLOOP
ENDPROC
->>>

->>> PROC do_Bob(win:PTR TO window)
-> Working with the Bob: setup the GEL system, and get a new Bob (makeBob()). 
-> Add the bob to the system and display.  Use the Bob.  When done, remove the
-> Bob and update the display without the bob.  Cleanup everything.
PROC do_Bob(win:PTR TO window) HANDLE
  DEF myBob=NIL, my_ginfo=NIL
  my_ginfo:=setupGelSys(win.rport, $03)
  myBob:=makeBob(myNewBob)
  AddBob(myBob, win.rport)
  bobDrawGList(win.rport, ViewPortAddress(win))
  process_window(win, myBob)
  RemBob(myBob)
  bobDrawGList(win.rport, ViewPortAddress(win))
EXCEPT DO
  IF myBob THEN freeBob(myBob, myNewBob.rasDepth)
  IF my_ginfo THEN cleanupGelSys(my_ginfo, win.rport)
  ReThrow()
ENDPROC
->>>

->>> PROC main()
PROC main() HANDLE
  DEF win=NIL
  KickVersion(37)
  -> E-Note: set-up global data
  -> Bob data - two sets that are alternated between.  Note that this data is
  -> at the resolution of the screen.
  bob_data1:=copyListToChip([$FFFF0003, $FFF00003, $FFF00003, $FFFF0003,
                             $3FFFFFFC, $3FF00FFC, $3FF00FFC, $3FFFFFFC])
  bob_data2:=copyListToChip([$C000FFFF, $C0000FFF, $C0000FFF, $C000FFFF,
                             $3FFFFFFC, $3FF00FFC, $3FF00FFC, $3FFFFFFC])
  -> Data for the new Bob object defined in animtools.m
  myNewBob:=[bob_data2, 2, GEL_SIZE,
             2, 3, 0, VSF_SAVEBACK OR VSF_OVERLAY,
             0, 8, 160, 100, 0, 0]:newBob
  win:=OpenWindow([80, 20, 400, 150, -1, -1,
                   IDCMP_CLOSEWINDOW OR IDCMP_INTUITICKS,
                   WFLG_ACTIVATE OR WFLG_CLOSEGADGET OR WFLG_DEPTHGADGET OR
                     WFLG_RMBTRAP,
                   NIL, NIL, 'Bob', NIL, NIL, 0, 0, 0, 0, WBENCHSCREEN]:nw)
  do_Bob(win)
EXCEPT DO
  IF win THEN CloseWindow(win)
  SELECT exception
  CASE ERR_KICK; WriteF('Error: requires V37\n')
  CASE ERR_WIN;  WriteF('Error: could not open window\n')
  CASE "MEM";    WriteF('Error: ran out of memory\n')
  ENDSELECT
ENDPROC IF exception<>ERR_NONE THEN RETURN_FAIL ELSE RETURN_OK
->>>

->>> PROC copyListToChip(data)
-> E-Note: get some Chip memory and copy list (quick, since LONG aligned)
PROC copyListToChip(data)
  DEF size, mem
  size:=ListLen(data)*SIZEOF LONG
  mem:=NewM(size, MEMF_CHIP)
  CopyMemQuick(data, mem, size)
ENDPROC mem
->>>

