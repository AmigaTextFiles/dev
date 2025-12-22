-> dualplayfield.e - Shows how to turn on dual-playfield mode in a screen.

MODULE 'intuition/intuition',  -> Intuition data structures and tags
       'intuition/screens',    -> Screen data structures and tags
       'graphics/modeid',      -> Release 2 Amiga display mode ID's
       'exec/memory',          -> Memory flags
       'graphics/gfx',         -> Bitmap and other structures
       'graphics/rastport',    -> RastPort and other structures
       'graphics/view'         -> ViewPort and other structures

ENUM ERR_NONE, ERR_SCRN, ERR_WIN, ERR_RAST, ERR_MODEID

RAISE ERR_SCRN   IF OpenScreenTagList()=NIL,
      ERR_WIN    IF OpenWindowTagList()=NIL,
      ERR_RAST   IF AllocRaster()=NIL,
      ERR_MODEID IF GetVPModeID()=INVALID_ID

PROC main() HANDLE
  DEF win=NIL, scr=NIL
  -> E-Note: E automatically opens the Intuition and Graphics libraries
  scr:=OpenScreenTagList(NIL,
                        [SA_DEPTH,     2,
                         SA_DISPLAYID, HIRES_KEY,
                         SA_TITLE,     'Dual Playfield Test Screen',
                         NIL])
  win:=OpenWindowTagList(NIL,
                        [WA_TITLE,        'Dual Playfield Mode',
                         WA_IDCMP,        IDCMP_CLOSEWINDOW,
                         WA_WIDTH,        200,
                         WA_HEIGHT,       100,
                         WA_DRAGBAR,      TRUE,
                         WA_CLOSEGADGET,  TRUE,
                         WA_CUSTOMSCREEN, scr,
                         NIL])
  doDualPF(win)

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF win THEN CloseWindow(win)
  IF scr THEN CloseScreen(scr)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_SCRN;   WriteF('Error: Failed to open custom screen\n')
  CASE ERR_WIN;    WriteF('Error: Failed to open window\n')
  CASE ERR_RAST;   WriteF('Error: Ran out of memory in AllocRaster\n')
  CASE ERR_MODEID; WriteF('Error: Bad/invalid mode ID for viewport\n')
  CASE "MEM";      WriteF('Error: Ran out of memory\n')
  ENDSELECT
ENDPROC

-> Allocate all of the stuff required to add dual playfield to a screen.
PROC doDualPF(win:PTR TO window) HANDLE
  DEF myscreen:PTR TO screen,  rinfo2=NIL:PTR TO rasinfo,
      bmap2=NIL:PTR TO bitmap, rport2=NIL:PTR TO rastport

  myscreen:=win.wscreen  -> Find the window's screen

  -> Allocate the second playfield's rasinfo, bitmap, and bitplane
  -> E-Note: NewM raises an exception if it fails
  rinfo2:=NewM(SIZEOF rasinfo, MEMF_PUBLIC OR MEMF_CLEAR)
  -> Get a rastport, and set it up for rendering into bmap2
  rport2:=NewM(SIZEOF rastport, MEMF_PUBLIC)
  bmap2:=NewM(SIZEOF bitmap, MEMF_PUBLIC OR MEMF_CLEAR)
  InitBitMap(bmap2, 1, myscreen.width, myscreen.height)
  
  -> Extra playfield will only use one bitplane here.
  -> E-Note: automatically error checked (automatic exception)
  bmap2.planes[0]:=AllocRaster(myscreen.width, myscreen.height)
  InitRastPort(rport2)
  rinfo2.bitmap:=bmap2
  rport2.bitmap:=bmap2

  SetRast(rport2, 0)

  -> E-Note: an exception will be raised if installDualPF fails
  installDualPF(myscreen, rinfo2)
  SetRGB4(myscreen.viewport, 9, 0, $F, 0)

  drawSomething(rport2)

  handleIDCMP(win)

  removeDualPF(myscreen)

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF bmap2
    IF bmap2.planes[0] -> E-Note: NewM makes this zero when bmap2 allocated
      FreeRaster(bmap2.planes[0], myscreen.width, myscreen.height)
    ENDIF
    Dispose(bmap2)
  ENDIF
  IF rport2 THEN Dispose(rport2)
  IF rinfo2 THEN Dispose(rinfo2)
  -> E-Note: pass exception on if it was an error
  ReThrow()
ENDPROC

-> Manhandle the viewport: install second playfield and change modes
PROC installDualPF(scrn:PTR TO screen, rinfo2)
  -> You can only play with the bits in the Modes field if the upper half of
  -> the screen mode ID is zero!!!
  -> E-Note: automatic and explicit exceptions raised here
  IF GetVPModeID(scrn.viewport) AND $FFFF0000 THEN Raise(ERR_MODEID)

  Forbid()

  -> Install rinfo2 for viewport's second playfield
  scrn.viewport.rasinfo.next:=rinfo2
  scrn.viewport.modes:=scrn.viewport.modes OR V_DUALPF

  Permit()

  -> Put viewport change into effect
  MakeScreen(scrn)
  RethinkDisplay()
ENDPROC

-> Draw some lines in a rast port... This is used to get some data into the
-> second playfield.  The windows on the screen will move underneath these
-> graphics without disturbing them.
PROC drawSomething(rp:PTR TO rastport)
  DEF width, height, r, c

  width:=rp.bitmap.bytesperrow * 8
  height:=rp.bitmap.rows

  SetAPen(rp, 1)

  FOR r:=0 TO height-1 STEP 40
    FOR c:=0 TO width-1 STEP 40
      -> E-Note: we could use E's graphics functions
      Move(rp, 0, r)
      Draw(rp, c, 0)
    ENDFOR
  ENDFOR
ENDPROC

-> Simple event loop to wait for the user to hit the close gadget on the window.
PROC handleIDCMP(win)
  WHILE WaitIMessage(win)<>IDCMP_CLOSEWINDOW
  ENDWHILE
ENDPROC

-> Remove the effects of installDualPF().
-> Only call if installDualPF() succeeded.
PROC removeDualPF(scrn:PTR TO screen)
  Forbid()

  scrn.viewport.rasinfo.next:=NIL
  scrn.viewport.modes:=scrn.viewport.modes AND Not(V_DUALPF)

  Permit()

  MakeScreen(scrn)
  RethinkDisplay()
ENDPROC
