-> collide.e - An example of collision detection between objects and between
->             the border.

->>> Header (globals)
OPT PREPROCESS

MODULE 'dos/dos',
       'exec/memory',
       'graphics/collide',
       'graphics/gels',
       'graphics/gfx',
       'graphics/rastport',
       'graphics/view',
       'intuition/intuition',
       'intuition/screens',
       'other/ecode',
       '*animtools'

ENUM ERR_NONE, ERR_RAST, ERR_SCRN, ERR_WIN

RAISE ERR_RAST IF AllocRaster()=NIL,
      ERR_SCRN IF OpenScreen()=NIL,
      ERR_WIN  IF OpenWindow()=NIL

CONST RBMWIDTH=320, RBMHEIGHT=200, RBMDEPTH=4

-> These give the number of frames (COUNT), size (HEIGHT, WIDTH, DEPTH), and
-> word width (WWIDTH) of the animated object.
CONST BOING_COUNT=6, BOING_HEIGHT=25, BOING_WIDTH=32, BOING_DEPTH=1
CONST BOING_WWIDTH=BOING_WIDTH+15/16

-> These are the IDs for the system to use for the three objects.  These
-> numbers will be used for the collision detection system.
->
-> Do not use zero (0), as it is reserved by the collision system for border
-> hits (see 'graphics/collide', BORDERHIT).
ENUM BOING_1=2, BOING_2, BOING_3

DEF ns:PTR TO ns, nw:PTR TO nw, boing3Times:PTR TO INT,
    boing3YTranses:PTR TO INT, boing3XTranses:PTR TO INT,
    boing3CRoutines:PTR TO LONG, boing3Image:PTR TO LONG,
    newBoingBob:PTR TO newBob, newBoingSeq:PTR TO newAnimSeq

-> E-Note: this is the static variable from setupBitMaps().
DEF myBitMaps[2]:ARRAY OF LONG
->>>

->>> PROC setupGlobals()
PROC setupGlobals()
  ns:=[0, 0, 320, 200, 2, 0, 1, NIL,
       CUSTOMSCREEN, NIL, 'Collision with AnimObs', NIL, NIL]:ns
  nw:=[50, 50, 220, 100, -1, -1, IDCMP_CLOSEWINDOW,
       WFLG_CLOSEGADGET OR WFLG_RMBTRAP, NIL, NIL, 'Close Window to Stop',
       NIL, NIL, 150, 100, 150, 100, CUSTOMSCREEN]:nw
  -> These are the number of counts that each frame is displayed.  They are
  -> all one, so each frame is displayed once then the animation system will
  -> move on to the next in the sequence.
  boing3Times:=[1, 1, 1, 1, 1, 1]:INT
  -> These are all set to zero as we do not want anything added to the X and Y
  -> positions using ring motion control.  All movement is done using the
  -> acceleration and velocity values.
  boing3YTranses:=[0, 0, 0, 0, 0, 0]:INT
  boing3XTranses:=[0, 0, 0, 0, 0, 0]:INT
  -> No special routines to call when each anim comp is displayed.
  boing3CRoutines:=[NIL, NIL, NIL, NIL, NIL, NIL]:LONG
  boing3Image:=copyListToChip(
                             -> ----- bitmap Boing, frame 0:  w = 32, h = 25 ------
                             [$00230000, $004E3000, $00E33A00, $03C3C900,
                              $07878780, $108F8700, $31F78790, $61F04790,
                              $63E0FB90, $43E0F848, $3BC0F870, $3801F870,
                              $383DF070, $387E1070, $387C0EE0, $D87C1F10,
                              $467C1E10, $479C1E30, $67873E20, $0787CC60,
                              $0F0F8700, $048F0E00, $02771C00, $0161D800,
                              $00272000,
                             -> ----- bitmap Boing, frame 1:  w = 32, h = 25 ------
                              $00318000, $01071800, $00F01900, $09E1EC80,
                              $13C1E340, $1803E380, $387BC390, $30F801D0,
                              $70F83DC0, $E1F03E08, $9DF07C30, $9E307C30,
                              $9E1C7C30, $1C1F9C30, $1C1F0630, $7C1F0780,
                              $623F0798, $63DE0F10, $23C10F20, $33C3EE20,
                              $0BC3C380, $0647C700, $023F8E00, $0130F800,
                              $00338000,
                             -> ----- bitmap Boing, frame 2:  w = 32, h = 25 ------
                              $0019C000, $01038800, $02788D00, $0CF0FE80,
                              $11F0F140, $0E60F1E0, $1C39F0C0, $1C3E30C0,
                              $387E0CE0, $F87C1F28, $8C7C1F18, $8F3C1F18,
                              $8F061E18, $8F07DE18, $8F07C018, $6E0FC1C0,
                              $300F83C8, $31EF8390, $31F08780, $11E0F720,
                              $11E1F1C0, $0B61E300, $071BC600, $01386C00,
                              $00318000,
                             -> ----- bitmap Boing, frame 3:  w = 32, h = 25 ------
                              $001CE000, $01B1CC00, $031CC500, $0C3C3680,
                              $18787840, $2F7078E0, $0E087860, $1E0FB860,
                              $1C1F0460, $BC1F07B0, $C43F0788, $C7FE0788,
                              $C7C00F88, $C781EF88, $C783F118, $2783E0E8,
                              $3983E1E0, $3863E1C0, $1878C1C0, $38783380,
                              $10F078C0, $0B70F180, $0588E200, $009E2400,
                              $0018C000,
                             -> ----- bitmap Boing, frame 4:  w = 32, h = 25 ------
                              $000E6000, $00F8E400, $030FE600, $061E1300,
                              $0C3E1C80, $27FC1C60, $07843C60, $4F07FE20,
                              $8F07C230, $1E0FC1F0, $620F83C8, $61CF83C8,
                              $61E183C8, $63E063C8, $63E0F9C8, $03E0F878,
                              $1DC0F860, $1C21F0E0, $5C3EF0C0, $0C3C11C0,
                              $143C3C40, $09B83880, $05C07000, $00CF0400,
                              $000C6000,
                             -> ----- bitmap Boing, frame 5:  w = 32, h = 25 ------
                              $00262000, $00FC7400, $01877200, $030F0100,
                              $0E0F0E80, $319F0E00, $23C60F30, $63C1CF30,
                              $4781F310, $0783E0D0, $7383E0E0, $70C3E0E0,
                              $70F9E1E0, $70F821E0, $70F83FE0, $91F03E38,
                              $4FF07C30, $4E107C60, $4E0F7860, $2E1F08C0,
                              $0E1E0E00, $049E1C80, $00E43800, $00C79000,
                              $000E6000])
  -> These objects contain the initialisation data for the animation sequence.
  newBoingBob:=[NIL, BOING_WWIDTH, BOING_HEIGHT, BOING_DEPTH, $2, $0,
                VSF_SAVEBACK OR VSF_OVERLAY, 0, RBMDEPTH, 0, 0, 0, 0]:newBob
  newBoingSeq:=[NIL, boing3Image, boing3XTranses, boing3YTranses,
                boing3Times, boing3CRoutines, 0, BOING_COUNT, 0]:newAnimSeq
ENDPROC
->>>

->>> PROC setupBoing(dbufing)
-> Make a new animation object.  Since all of the boing balls use the same
-> underlying data, the initalisation structures are hard-coded into the
-> routine (newBoingBob and newBoingSeq.)
->
-> Return a pointer to the object if successful.
PROC setupBoing(dbufing) HANDLE
  DEF bngOb=NIL:PTR TO ao, bngComp:PTR TO ac
  NEW bngOb
  newBoingBob.dBuf:=dbufing  -> Double-buffer status
  newBoingSeq.headOb:=bngOb  -> Pass down head object

  bngComp:=makeSeq(newBoingBob, newBoingSeq)
  -> The head comp is the one that is returned by makeSeq()
  bngOb.headcomp:=bngComp
EXCEPT
  IF bngOb THEN END bngOb
  ReThrow()
ENDPROC bngOb
->>>

->>> PROC runAnimation(win:PTR TO window, dbufing, animKey, myBitMaps)
-> A simple message handling LOOP that also draws the successive frames.
PROC runAnimation(win:PTR TO window, dbufing, animKey, myBitMaps)
  DEF intuiMsg:PTR TO intuimessage, toggleFrame
  -> toggleFrame is used to keep track of which frame of the double buffered
  -> screen we are currently displaying.  The variable must exist for the life
  -> of the displayed objects, so it is defined here.
  toggleFrame:=0

  -> End the loop on a IDCMP_CLOSEWINDOW event.
  LOOP
    -> Draw the gels, then check for messages.  Check the messages after each
    -> display so we get a quick response.
    drawGels(win, animKey, dbufing, {toggleFrame}, myBitMaps)

    -> Quit on a Control-C
    -> E-Note: use built-in check
    IF CtrlC() THEN RETURN

    -> Check for a IDCMP_CLOSEWINDOW event, die if found
    WHILE intuiMsg:=GetMsg(win.userport)
      IF intuiMsg.class=IDCMP_CLOSEWINDOW
        ReplyMsg(intuiMsg)
        RETURN
      ENDIF
      ReplyMsg(intuiMsg)
    ENDWHILE
  ENDLOOP
ENDPROC
->>>

->>> PROC setupPlanes(bitMap:PTR TO bitmap, depth, width, height)
-> Called only for double-buffered displays.  Allocate and clear each
-> bit-plane in a bitmap structure.  Clean-up on failure.
PROC setupPlanes(bitMap:PTR TO bitmap, depth, width, height) HANDLE
  DEF plane_num
  FOR plane_num:=0 TO depth-1
    bitMap.planes[plane_num]:=AllocRaster(width, height)
    BltClear(bitMap.planes[plane_num], (width/8)*height, 1)
  ENDFOR
EXCEPT
  freePlanes(bitMap, depth, width, height)
  ReThrow()
ENDPROC
->>>

->>> PROC setupBitMaps(depth, width, height)
-> Allocate the two bitmaps for a double-buffered display.  Routine only
-> called when the display is double-buffered.
PROC setupBitMaps(depth, width, height) HANDLE
  DEF p=NIL:PTR TO bitmap, q=NIL:PTR TO bitmap
  -> Allocate the two bitmap objects.  These do not have to be in CHIP.
  -> E-Note: use p and q to get correct type.
  myBitMaps[0]:=NEW p
  myBitMaps[1]:=NEW q
  -> Initialise the bitmaps to the correct size.
  InitBitMap(p, depth, width, height)
  InitBitMap(q, depth, width, height)
  -> Allocate and initialise the bit-planes for the bitmaps.
  setupPlanes(p, depth, width, height)
  setupPlanes(q, depth, width, height)
EXCEPT
  IF p
    freePlanes(p, depth, width, height)
    END p
  ENDIF
  IF q
    freePlanes(q, depth, width, height)
    END q
  ENDIF
  ReThrow()
ENDPROC myBitMaps
->>>

->>> PROC freePlanes(bitMap:PTR TO bitmap, depth, width, height)
-> Free all of the bit-planes in a bitmap structure.
PROC freePlanes(bitMap:PTR TO bitmap, depth, width, height)
  DEF plane_num
  FOR plane_num:=0 TO depth-1
    IF bitMap.planes[plane_num]
      FreeRaster(bitMap.planes[plane_num], width, height)
    ENDIF
  ENDFOR
ENDPROC
->>>

->>> PROC freeBitMaps(myBitMaps:PTR TO LONG, depth, width, height)
-> Free the two bitmaps from the double buffered display. The bit-planes are
-> freed first, then the bitmap objects.
PROC freeBitMaps(myBitMaps:PTR TO LONG, depth, width, height)
  freePlanes(myBitMaps[0], depth, width, height)
  freePlanes(myBitMaps[1], depth, width, height)
  END myBitMaps[2]
ENDPROC
->>>

->>> PROC setupDisplay(win:PTR TO LONG, dbufing, myBitMaps:PTR TO LONG)
-> Open the screen and the window for the display.
->
-> If using double buffered display, assume the bitmaps have been opened and
-> correctly set-up.
PROC setupDisplay(win:PTR TO LONG, dbufing, myBitMaps:PTR TO LONG) HANDLE
  DEF gInfo, screen=NIL, wp=NIL:PTR TO window
  -> If double-buffered, set-up the new screen structure for custom bitmap.
  IF dbufing
    ns.type:=ns.type OR CUSTOMBITMAP
    ns.custombitmap:=myBitMaps[0]
  ENDIF

  -> Open everything.  Check for failure.
  screen:=OpenScreen(ns)
  nw.screen:=screen
  -> E-Note: use wp to get the right type
  win[]:=(wp:=OpenWindow(nw))
  IF dbufing
    -> We are double buffered.  Set the rastport for it.
    wp.wscreen.rastport.flags:=RPF_DBUFFER

    -> This copies the Intuition display (close gadget) to the second bitmap
    -> so the display does not flash when we change between them.
    wp.wscreen.rastport.bitmap:=myBitMaps[1]
    BltBitMapRastPort(myBitMaps[0], 0, 0, wp.wscreen.rastport,
                      0, 0, RBMWIDTH, RBMHEIGHT, $C0)
    wp.wscreen.rastport.bitmap:=myBitMaps[0]
  ENDIF

  -> Ready the gel system for accepting objects.  This is only done once for
  -> each rastport in use.
  gInfo:=setupGelSys(wp.wscreen.rastport, $03)
EXCEPT
  IF wp THEN CloseWindow(wp)
  IF screen THEN CloseScreen(screen)
  ReThrow()
ENDPROC gInfo
->>>

->>> PROC drawGels(win:..., animKey, dbufing, toggleFrame:..., myBitMaps:...)
-> Handle the update of the display.  Animate the simulation and check for
-> collisions.  If the screen is double buffered, swap the bit map as
-> required.
-> E-Note: toggleFrame is PTR TO LONG since '{toggle}' was used.
PROC drawGels(win:PTR TO window, animKey, dbufing,
              toggleFrame:PTR TO LONG, myBitMaps:PTR TO LONG)
  -> Do the required animation stuff.  You must sort both after the animate
  -> call and after the collision call.
  Animate(animKey, win.wscreen.rastport)
  SortGList(win.wscreen.rastport)

  DoCollision(win.wscreen.rastport)
  SortGList(win.wscreen.rastport)

  -> Toggle if double buffered
  IF dbufing
    win.wscreen.viewport.rasinfo.bitmap:=myBitMaps[toggleFrame[]]
  ENDIF

  -> Draw the new position of the gels into the screen.
  DrawGList(win.wscreen.rastport, win.wscreen.viewport)

  -> If using a double buffered display, you have a more complicated update
  -> procedure.  If not then simply use WaitTOF().
  IF dbufing
    MakeScreen(win.wscreen)
    RethinkDisplay()
    toggleFrame[]:=1-toggleFrame[]
    win.wscreen.rastport.bitmap:=myBitMaps[toggleFrame[]]
  ELSE
    WaitTOF()
  ENDIF
ENDPROC
->>>

->>> PROC bounceWall(vs1:PTR TO vs, borderflags)
-> Handle bouncing the animation objects off the walls.
PROC bounceWall(vs1:PTR TO vs, borderflags)
  DEF ob:PTR TO ao
  -> Get a pointer to the object from the sprite pointer.
  ob:=vs1.vsbob.bobcomp.headob

  -> Check for hits and act appropriately.  For right and left, reverse the x
  -> velocity if the object is moving towards the wall (it may have already
  -> reversed but still be in contact with the wall).  For the bottom and top
  -> you also have to subtract out the velocity.
  IF ((borderflags AND RIGHTHIT) AND (ob.xvel>0)) OR
     ((borderflags AND LEFTHIT) AND (ob.xvel<0))
    ob.xvel:=-ob.xvel
  ELSEIF ((borderflags AND TOPHIT) AND (ob.yvel<0)) OR
         ((borderflags AND BOTTOMHIT) AND (ob.yvel>0))
    ob.yvel:=ob.yvel-ob.yaccel
    ob.yvel:=-ob.yvel
  ENDIF
ENDPROC
->>>

->>> PROC hit_routine(vs1:PTR TO vs, vs2:PTR TO vs)
-> Handle the collision between two animation objects.  This routine simulates
-> objects bouncing off of each other.  This does not do a very good job of
-> it, it does not take into account the angle of the collision or real
-> physics. If anyone wants to fix it, please feel free.
->
-> The call to DoCollision() causes a call back to this routine when two
-> animation objects overlap.
PROC hit_routine(vs1:PTR TO vs, vs2:PTR TO vs)
  DEF vel1, vel2, ob1:PTR TO ao, ob2:PTR TO ao
  -> Get pointers to the objects from the sprite pointers.
  ob1:=vs1.vsbob.bobcomp.headob
  ob2:=vs2.vsbob.bobcomp.headob

  -> Check that the bob is not being removed!  This is due to a 1.3 bug where
  -> all bobs are tested for collision, even the ones that are in the process
  -> of being removed.  See text for more information.
  ->
  -> Bobs are moved to a very large negative position as they are being
  -> removed.  If the BOBSAWAY flag is set, then both bobs in the collision
  -> are in the process of being removed--don't do anything in the collision
  -> routine.
  IF 0=(vs1.vsbob.bobflags AND BF_BOBSAWAY)
    -> Cache the velocity values.
    -> Do the X values first (order is not important).
    vel1:=ob1.xvel
    vel2:=ob2.xvel

    -> If the two objects are moving in the opposite direction (X component)
    -> then negate the velocities, else swap the velocities.
    IF ((vel1>0) AND (vel2<0)) OR ((vel1<0) AND (vel2>0))
      ob1.xvel:=-vel1
      ob2.xvel:=-vel2
    ELSE
      ob1.xvel:=vel2
      ob2.xvel:=vel1
    ENDIF

    -> Cache the velocity values.
    -> Do the Y values second (order is not important).
    vel1:=ob1.yvel
    vel2:=ob2.yvel

    -> If the two objects are moving in the opposite direction (Y component)
    -> then negate the velocities, else swap the velocities.
    IF ((vel1>0) AND (vel2<0)) OR ((vel1<0) AND (vel2>0))
      ob1.yvel:=-vel1
      ob2.yvel:=-vel2
    ELSE
      ob1.yvel:=vel2
      ob2.yvel:=vel1
    ENDIF
  ENDIF
ENDPROC
->>>

->>> PROC main()
-> Run a double buffered display if the user puts any arguments on the command
-> line.
->
-> Set-up the display, set-up the animation system and the objects, set-up
-> collisions between objects and against walls, and run the thing.
->
-> Clean-up and close resources when done.
PROC main() HANDLE
  DEF myBitMaps:PTR TO LONG, boingOb=NIL:PTR TO ao, boing2Ob=NIL:PTR TO ao,
      boing3Ob=NIL:PTR TO ao, win=NIL:PTR TO window, gInfo=NIL, animKey,
      dbufing=0, hitcode
  -> E-Note: set-up global data
  setupGlobals()
  -> If any arguments, use double-buffering
  IF arg THEN IF arg[] THEN dbufing:=1
  WriteF(IF dbufing THEN
         'Double buffering - no args means single buffered\n' ELSE
         'Single buffering - supply any arguments to do double buffering\n')
  -> Note that setupBitMaps() will only be called if we are double buffering.
  IF dbufing THEN myBitMaps:=setupBitMaps(RBMDEPTH, RBMWIDTH, RBMHEIGHT)
  gInfo:=setupDisplay({win}, dbufing, myBitMaps)
  -> You have to initialise the animation key before you use it.
  InitAnimate({animKey})

  -> Set-up the first boing ball.  All of these use the same data, hard coded
  -> into setupBoing().  Change the colour by changing planePick.  Set the ID
  -> of the ball (meMask) to BOING_1.  hitMask = $FF means that it will
  -> collide with everything.
  newBoingBob.planePick:=$2
  newBoingBob.meMask:=Shl(1, BOING_1)
  newBoingBob.hitMask:=$FF
  boingOb:=setupBoing(dbufing)

  -> Pick an initial position, velocity and acceleration and add the OBJECT to
  -> the system.  NOTE that the Y-velocity and X-acceleration are not set
  -> (they default to zero.)  This means that the objects will maintain a
  -> constant movement to the left or right, and will rely on the Y
  -> accelleration for the downward movement.  The collision routines change
  -> these values, producing bouncing off of walls and other objects.
  ->
  -> NOTE: ANFRACSIZE is a value that shifts animation constants past an
  -> internal decimal point.  If you do not do this, then the values will only
  -> be some fraction of what you expect.  See the text of the Animation
  -> chapter.
  boingOb.any:=Shl(10, ANFRACSIZE)
  boingOb.anx:=Shl(250, ANFRACSIZE)
  boingOb.xvel:=-Shl(3, ANFRACSIZE)
  boingOb.yaccel:=35
  AddAnimOb(boingOb, {animKey}, win.wscreen.rastport)

  -> Do the second object--see above comments.
  newBoingBob.planePick:=$1
  newBoingBob.meMask:=Shl(1, BOING_2)
  newBoingBob.hitMask:=$FF
  boing2Ob:=setupBoing(dbufing)
  boing2Ob.any:=Shl(50, ANFRACSIZE)
  boing2Ob.anx:=Shl(50, ANFRACSIZE)
  boing2Ob.xvel:=Shl(2, ANFRACSIZE)  
  boing2Ob.yaccel:=35
  AddAnimOb(boing2Ob, {animKey}, win.wscreen.rastport)

  -> Do the third object--see above comments.
  -> Here we also use planeOnOff to change the colour.
  newBoingBob.planePick:=$1
  newBoingBob.planeOnOff:=$2
  newBoingBob.meMask:=Shl(1, BOING_3)
  newBoingBob.hitMask:=$FF
  boing3Ob:=setupBoing(dbufing)
  boing3Ob.any:=Shl(80, ANFRACSIZE)
  boing3Ob.anx:=Shl(150, ANFRACSIZE)
  boing3Ob.xvel:=Shl(1, ANFRACSIZE)
  boing3Ob.yaccel:=35
  AddAnimOb(boing3Ob, {animKey}, win.wscreen.rastport)

  -> Set up the collisions between boing balls.
  -> NOTE that they all call the same routine.
  -> E-Note: wrap hit_routine() so it can be used as a collision function (the
  ->         function is simple enough not to need the full register
  ->         preservation of eCodeCollision(), so eCodeSwapArgs() is used).
  hitcode:=eCodeSwapArgs({hit_routine})
  SetCollision(BOING_1, hitcode, gInfo)
  SetCollision(BOING_2, hitcode, gInfo)
  SetCollision(BOING_3, hitcode, gInfo)

  -> Set the collisions with the walls.
  -> E-Note: see above comment about eCodeXXX().
  SetCollision(BORDERHIT, eCodeSwapArgs({bounceWall}), gInfo)

  -> Everything set-up...  Run the animation.
  runAnimation(win, dbufing, {animKey}, myBitMaps)

  -> Done..  Free-up everything and clean up the mess.
EXCEPT DO
  IF boing3Ob THEN freeOb(boing3Ob, RBMDEPTH)
  IF boing2Ob THEN freeOb(boing2Ob, RBMDEPTH)
  IF boingOb THEN freeOb(boingOb, RBMDEPTH)
  IF gInfo THEN cleanupGelSys(gInfo, win.wscreen.rastport)
  IF win THEN CloseWindow(win)
  -> E-Note: C version does not do this safely...
  IF nw.screen THEN CloseScreen(nw.screen)
  IF dbufing THEN freeBitMaps(myBitMaps, RBMDEPTH, RBMWIDTH, RBMHEIGHT)
  SELECT exception
  CASE ERR_RAST;  WriteF('Error: could not allocate raster\n')
  CASE ERR_SCRN;  WriteF('Error: could not open screen\n')
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

