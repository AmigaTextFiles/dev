-> vsprite.e - Virtual Sprite example

->>> Header (globals)
MODULE 'dos/dos',
       'exec/memory',
       'exec/ports',
       'graphics/collide',
       'graphics/gels',
       'graphics/rastport',
       'intuition/intuition',
       'intuition/screens',
       'other/ecode',
       '*animtools'

ENUM ERR_NONE, ERR_KICK, ERR_WIN

RAISE ERR_KICK IF KickVersion()=FALSE,
      ERR_WIN  IF OpenWindow()=NIL

CONST GEL_SIZE=4

-> VSprite data - there are two sets that are alternated between.  Note that
-> this data is always displayed as low resolution.
DEF vsprite_data1, vsprite_data2, mySpriteColours, mySpriteAltColours
->>>

->>> PROC vspriteDrawGList(win, myRPort)
-> Basic VSprite display subroutine
PROC vspriteDrawGList(win, myRPort)
  SortGList(myRPort)
  DrawGList(myRPort, ViewPortAddress(win))
  RethinkDisplay()
ENDPROC
->>>

->>> PROC borderCheck(hitVSprite:PTR TO vs, borderflags)
-> Collision routine for vsprite hitting border.  Note that when the collision
-> is VSprite to VSprite (or Bob to Bob, Bob to AnimOb, etc.), then the
-> parameters are both pointers to a VSprite.
PROC borderCheck(hitVSprite:PTR TO vs, borderflags)
  IF borderflags AND RIGHTHIT
    hitVSprite.sprcolors:=mySpriteAltColours
    hitVSprite.vuserext:=-40
  ENDIF
  IF borderflags AND LEFTHIT
    hitVSprite.sprcolors:=mySpriteColours
    hitVSprite.vuserext:=20
  ENDIF
ENDPROC
->>>

->>> PROC process_window(win:PTR TO window, myRPort, myVSprite:PTR TO vs)
-> Process window and dynamically change vsprite.  Get messages.  Go away on
-> CLOSEWINDOW.  Update and redisplay vsprite on INTUITICKS.  Wait for more
-> messages.
PROC process_window(win:PTR TO window, myRPort, myVSprite:PTR TO vs)
  DEF msg:PTR TO intuimessage
  LOOP
    Wait(Shl(1, win.userport.sigbit))
    WHILE NIL<>(msg:=GetMsg(win.userport))
      -> Only IDCMP_CLOSEWINDOW and IDCMP_INTUITICKS are active
      IF msg.class=IDCMP_CLOSEWINDOW
        ReplyMsg(msg)
        RETURN
      ENDIF
      -> Must be an INTUITICKS:  change x and y values on the fly.  Note offset
      -> by window left and top edge--sprite is relative to the screen, not
      -> window.  Divide the MouseY in half to adjust for Lores movement
      -> increments on a Hires screen.
      myVSprite.x:=win.leftedge+msg.mousex+myVSprite.vuserext
      myVSprite.y:=win.topedge+(msg.mousey/2)+1
      ReplyMsg(msg)
    ENDWHILE
    -> Got a message, change image data on the fly
    myVSprite.imagedata:=IF myVSprite.imagedata=vsprite_data1 THEN
                            vsprite_data2 ELSE vsprite_data1
    SortGList(myRPort)
    DoCollision(myRPort)
    vspriteDrawGList(win, myRPort)
  ENDLOOP
ENDPROC
->>>

->>> PROC do_VSprite(win, myRPort:PTR TO rastport) HANDLE
-> Working with the VSprite.  Setup the GEL system and get a new VSprite
-> (makeVSprite()).  Add VSprite to the system and display.  Use the vsprite.
-> When done, remove VSprite and update the display without the VSprite.
-> Cleanup everything.
PROC do_VSprite(win, myRPort:PTR TO rastport) HANDLE
  DEF myVSprite=NIL:PTR TO vs, my_ginfo=NIL
  my_ginfo:=setupGelSys(myRPort, $FC)
  myVSprite:=makeVSprite(
            -> Image data, sprite colour array, word width (1 for true VSprite)
           [vsprite_data1, mySpriteColours, 1,
            -> Line height, image depth (2 for true VSprite), x, y position
            GEL_SIZE, 2, 160, 100,
            -> Flags (VSF_VSPRITE for true VSprite), hit mask and me mask
            VSF_VSPRITE, Shl(1, BORDERHIT), 0]:newVSprite)
  AddVSprite(myVSprite, myRPort)
  vspriteDrawGList(win, myRPort)
  myVSprite.vuserext:=20
  -> E-Note: wrap borderCheck function for use as collision routine
  SetCollision(BORDERHIT, eCodeCollision({borderCheck}), myRPort.gelsinfo)
  process_window(win, myRPort, myVSprite)
  RemVSprite(myVSprite)
EXCEPT DO
  IF myVSprite THEN freeVSprite(myVSprite)
  IF my_ginfo
    vspriteDrawGList(win, myRPort)
    cleanupGelSys(my_ginfo, myRPort)
  ENDIF
  ReThrow()
ENDPROC
->>>

->>> PROC main() HANDLE
-> Example VSprite program.  First open a window.
PROC main() HANDLE
  DEF win=NIL:PTR TO window, myRPort=NIL:PTR TO rastport
  KickVersion(37)
  NEW myRPort  -> E-Note: allocate a zeroed rastport
  -> E-Note: set-up global data
  vsprite_data1:=copyListToChip([$7FFE80FF, $7C3E803F, $7C3E803F, $7FFE80FF, 0])
  vsprite_data2:=copyListToChip([$7FFEFF01, $7C3EFC01, $7C3EFC01, $7FFEFF01, 0])
  mySpriteColours:=[$0000, $00F0, $0F00]:INT
  mySpriteAltColours:=[$000F, $0F00, $0FF0]:INT
  win:=OpenWindow([80, 20, 400, 150, -1, -1,
                   IDCMP_CLOSEWINDOW OR IDCMP_INTUITICKS,
                   WFLG_ACTIVATE OR WFLG_CLOSEGADGET OR WFLG_DEPTHGADGET OR
                       WFLG_RMBTRAP OR WFLG_DRAGBAR,
                   NIL, NIL, 'VSprite', NIL, NIL, 0, 0, 0, 0, WBENCHSCREEN]:nw)
  InitRastPort(myRPort)
  -> Copy the window rastport
  CopyMem(win.wscreen.rastport, myRPort, SIZEOF rastport)
  do_VSprite(win, myRPort)
EXCEPT DO
  IF win THEN CloseWindow(win)
  END myRPort
  SELECT exception
  CASE ERR_KICK;  WriteF('Error: requires V37\n')
  CASE ERR_WIN;   WriteF('Error: could not open window\n')
  CASE "MEM";     WriteF('Error: ran out of memory\n')
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
