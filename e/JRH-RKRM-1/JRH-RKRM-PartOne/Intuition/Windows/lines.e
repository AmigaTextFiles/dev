-> lines.e -- implements a superbitmap with scroll gadgets
-> This program requires V37, as it uses calls to OpenWindowTags(),
-> LockPubScreen().

OPT PREPROCESS  -> E-Note: enable use of macros

MODULE 'layers',  -> We are going to use the Layers library
       'intuition/intuition', -> Intuition data structures and tags
       'intuition/screens',   -> Screen data structures and tags
       'graphics/rastport',   -> RastPort and other structures
       'graphics/clip',       -> Layer and other structures
       'graphics/gfx',        -> BitMap and other structures
       'graphics/text',       -> TextFont and other structures
       'exec/memory'          -> Memory flags

ENUM ERR_NONE, ERR_LIB, ERR_KICK, ERR_PUB, ERR_RAST, ERR_WIN

RAISE ERR_LIB  IF OpenLibrary()=NIL,
      ERR_PUB  IF LockPubScreen()=NIL,
      ERR_RAST IF AllocRaster()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

CONST WIDTH_SUPER=800, HEIGHT_SUPER=600,
      UP_DOWN_GADGET=0, LEFT_RIGHT_GADGET=1, NO_GADGET=2
-> E-Note: MAXPOT and MAXBODY should be used instead of MAXPROPVAL

#define LAYERXOFFSET(x) (x.rport.layer.scroll_x)
#define LAYERYOFFSET(x) (x.rport.layer.scroll_y)

-> E-Note: need objects like botGad to be zeroed, so use pointers here
DEF win=NIL:PTR TO window, botGadInfo=NIL:PTR TO propinfo,
    botGadImage=NIL:PTR TO image, botGad=NIL:PTR TO gadget,
    sideGadInfo=NIL:PTR TO propinfo, sideGadImage=NIL:PTR TO image,
    sideGad=NIL:PTR TO gadget

PROC main() HANDLE
  DEF myscreen=NIL
  IF KickVersion(37)=FALSE THEN Raise(ERR_KICK)

  -> E-Note: E automatically opens the Intuition and Graphics libraries
  -> Open the Layers library for the program.
  -> E-Note: automatically error-checked (automatic exception)
  layersbase:=OpenLibrary('layers.library', 33)

  -> LockPubScreen()/UnlockPubScreen is only available under V36 and later.  Use
  -> GetScreenData() under V34 systems to get a copy of the screen structure...
  -> E-Note: automatically error-checked (automatic exception)
  myscreen:=LockPubScreen(NIL)

  superWindow(myscreen)

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF myscreen THEN UnlockPubScreen(NIL, myscreen)
  IF layersbase THEN CloseLibrary(layersbase)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_KICK; WriteF('Error: Needs Kickstart V37+\n')
  CASE ERR_LIB;  WriteF('Error: Could not open layers.library\n')
  CASE ERR_PUB;  WriteF('Error: Could not lock public screen\n')
  CASE ERR_RAST; WriteF('Error: Ran out of memory in AllocRaster\n')
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  CASE "MEM";    WriteF('Error: Ran out of memory\n')
  ENDSELECT
ENDPROC

-> A string with this format will be found by the version command supplied by
-> Commodore.  This will allow users to give version numbers with error reports.
-> E-Note: labels can only be used after the first PROC line...
vers: CHAR '$VER: lines 37.2',0

-> Create, initialise and process the super bitmap window. Cleanup if any error.
PROC superWindow(myscreen:PTR TO screen) HANDLE
  DEF bigBitMap=NIL:PTR TO bitmap, planeNum, mydepth

  -> Set-up the border prop gadgets for the OpenWindow() call.
  initBorderProps(myscreen)

  -> The code relies on the allocation of the BitMap structure with the
  -> MEMF_CLEAR flag.  This allows the assumption that all of the bitmap
  -> pointers are NIL, except those successfully allocated by the program.
  -> E-Note: NewM raises an exception if it fails
  bigBitMap:=NewM(SIZEOF bitmap, MEMF_PUBLIC OR MEMF_CLEAR)

  mydepth:=myscreen.bitmap.depth
  InitBitMap(bigBitMap, mydepth, WIDTH_SUPER, HEIGHT_SUPER)

  -> E-Note: we handle errors with exceptions
  FOR planeNum:=0 TO mydepth-1
    bigBitMap.planes[planeNum]:=AllocRaster(WIDTH_SUPER, HEIGHT_SUPER)
  ENDFOR

  -> Only open the window if the bitplanes were successfully allocated.  Fail
  -> via exception if they were not.

  -> OpenWindowTags() and OpenWindowTagList() are only available when the
  -> library version is at least V36.  Under earlier versions of Intuition, use
  -> OpenWindow() with a NewWindow structure.
  win:=OpenWindowTagList(NIL,
       [WA_WIDTH,  150,
        WA_HEIGHT, (4*(myscreen.wbortop+myscreen.font.ysize+1)),
        WA_MAXWIDTH,  WIDTH_SUPER,
        WA_MAXHEIGHT, HEIGHT_SUPER,
        WA_IDCMP, IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR
                  IDCMP_NEWSIZE  OR IDCMP_INTUITICKS OR IDCMP_CLOSEWINDOW,
        WA_FLAGS, WFLG_SIZEGADGET OR WFLG_SIZEBRIGHT  OR WFLG_SIZEBBOTTOM OR
                  WFLG_DRAGBAR    OR WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR
                  WFLG_SUPER_BITMAP OR WFLG_GIMMEZEROZERO OR WFLG_NOCAREREFRESH,
        WA_GADGETS,     sideGad,
        WA_TITLE,       {vers}+6,  -> Take title from version string
        WA_PUBSCREEN,   myscreen,
        WA_SUPERBITMAP, bigBitMap,
        NIL])

  -> Set-up the window display
  SetRast(win.rport, 0)  -> Clear the bitplanes
  SetDrMd(win.rport, RP_JAM1)

  doNewSize()  -> Adjust props to represent portion visible
  doDrawStuff()

  -> Process the window, return on IDCMP_CLOSEWINDOW
  doMsgLoop()

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF win THEN CloseWindow(win)
  IF bigBitMap
    FOR planeNum:=0 TO mydepth-1
      -> Free only the bitplanes actually allocated...
      IF bigBitMap.planes[planeNum]
        FreeRaster(bigBitMap.planes[planeNum], WIDTH_SUPER, HEIGHT_SUPER)
      ENDIF
    ENDFOR
    Dispose(bigBitMap)
  ENDIF
  ReThrow()  -> E-Note: pass exception on if it was an error
ENDPROC

-> Set-up the prop gadgets -- initialise them to values that fit into the
-> window border.  The height of the prop gadget on the side of the window
-> takes the height of the title bar into account in its set-up.  Note the
-> initialisation assumes a fixed size "sizing" gadget.
->
-> Note also, that the size of the sizing gadget is dependent on the screen
-> resolution.  The numbers given here are only valid if the screen is NOT
-> lo-res.  These values must be re-worked slightly for lo-res screens.
->
-> The PROPNEWLOOK flag is ignored by 1.3.
PROC initBorderProps(myscreen:PTR TO screen)
  DEF top  -> E-Note: temp variable for top calc
  -> Initialises the two prop gadgets.
  ->
  -> Note where the PROPNEWLOOK flag goes.  Adding this flag requires no extra
  -> storage, but tells the system that our program is expecting the new-look
  -> prop gadgets under 2.0.
  -> E-Note: we initialise using typed lists and NEW, so that we do not need
  ->         to fill in every field (NEW will zero the trailing ones).
  ->         Without NEW only a partial structure would be allocated...
  -> E-Note: allocate zeroed images
  NEW botGadImage, sideGadImage

  botGadInfo:=NEW [AUTOKNOB OR FREEHORIZ OR PROPNEWLOOK,
                   0, 0, -1, -1]:propinfo

  botGad:=NEW [NIL, 3, -7, -23, 6,
               GFLG_RELBOTTOM OR GFLG_RELWIDTH,
               GACT_RELVERIFY OR GACT_IMMEDIATE OR GACT_BOTTOMBORDER,
               GTYP_PROPGADGET OR GTYP_GZZGADGET,
               botGadImage, NIL, NIL, NIL,
               botGadInfo, LEFT_RIGHT_GADGET]:gadget

  sideGadInfo:=NEW [AUTOKNOB OR FREEVERT OR PROPNEWLOOK,
                    0, 0, -1, -1]:propinfo

  -> NOTE the TopEdge adjustment for the border and the font for V36.
  top:=myscreen.wbortop+myscreen.font.ysize+2
  sideGad:=NEW [botGad, -14, top, 12, -top-11,
                GFLG_RELRIGHT OR GFLG_RELHEIGHT,
                GACT_RELVERIFY OR GACT_IMMEDIATE OR GACT_RIGHTBORDER,
                GTYP_PROPGADGET OR GTYP_GZZGADGET,
                sideGadImage, NIL, NIL, NIL,
                sideGadInfo, UP_DOWN_GADGET]:gadget
ENDPROC

-> This function does all the work of drawing the lines
PROC doDrawStuff()
  DEF x1, y1, x2, y2, pen, ncolors, deltx, delty

  ncolors:=Shl(1, win.wscreen.bitmap.depth)
  -> E-Note: Rnd could be seeded using VbeamPos...
  deltx:=Rnd(6)+2
  delty:=Rnd(6)+2

  pen:=Rnd(ncolors-1)+1
  SetAPen(win.rport, pen)
  x1:=0; y1:=0; x2:=WIDTH_SUPER-1; y2:=HEIGHT_SUPER-1
  WHILE x1 < WIDTH_SUPER
    Move(win.rport, x1, y1)
    Draw(win.rport, x2, y2)
    x1:=x1+deltx
    x2:=x2-deltx
  ENDWHILE

  pen:=Rnd(ncolors-1)+1
  SetAPen(win.rport, pen)
  x1:=0; y1:=0; x2:=WIDTH_SUPER-1; y2:=HEIGHT_SUPER-1
  WHILE y1 < HEIGHT_SUPER
    Move(win.rport, x1, y1)
    Draw(win.rport, x2, y2)
    y1:=y1+delty
    y2:=y2-delty
  ENDWHILE
ENDPROC

-> This function provides a simple interface to ScrollLayer
PROC slideBitMap(dx, dy)
  ScrollLayer(0, win.rport.layer, dx, dy)
ENDPROC

-> E-Note: define macros to compute fraction of Pot and Body
-> E-Note: use Mul() and Div() since definitely over 16-bits
#define FRACTIONPOT(n,d)  (Div(Mul(n, MAXPOT), d))
#define FRACTIONBODY(n,d) (Div(Mul(n, MAXBODY), d))

-> Update the prop gadgets and bitmap positioning when the size changes.
PROC doNewSize()
  DEF tmp
  tmp:=LAYERXOFFSET(win) + win.gzzwidth
  IF tmp>=WIDTH_SUPER THEN slideBitMap(WIDTH_SUPER-tmp, 0)

  NewModifyProp(botGad, win, NIL, AUTOKNOB OR FREEHORIZ,
      FRACTIONPOT(LAYERXOFFSET(win), WIDTH_SUPER - win.gzzwidth),
      NIL,
      FRACTIONBODY(win.gzzwidth, WIDTH_SUPER),
      MAXBODY,
      1)

  tmp:=LAYERYOFFSET(win) + win.gzzheight
  IF tmp>=HEIGHT_SUPER THEN slideBitMap(0, HEIGHT_SUPER-tmp)

  NewModifyProp(sideGad, win, NIL, AUTOKNOB OR FREEVERT,
      NIL,
      FRACTIONPOT(LAYERYOFFSET(win), HEIGHT_SUPER - win.gzzheight),
      MAXBODY,
      FRACTIONBODY(win.gzzheight, HEIGHT_SUPER),
      1)
ENDPROC

-> E-Note: convert signed INT from a Pot to unsigned for calculations
#define UNSIGNED(x) (x AND $FFFF)
-> E-Note: define macro to compute layer offset from Pot value
-> E-Note: use Mul() and Div() since definitely over 16-bits
#define CALCOFFSET(size, pot) (Div(Mul(size, UNSIGNED(pot)), MAXPOT))

-> Process the currently selected gadget.  This is called from IDCMP_INTUITICKS
-> and when the gadget is released IDCMP_GADGETUP.
PROC checkGadget(gadgetID)
  DEF tmp, dx=0, dy=0

  SELECT gadgetID
  CASE UP_DOWN_GADGET
    tmp:=CALCOFFSET(HEIGHT_SUPER-win.gzzheight, sideGadInfo.vertpot)
    dy:=tmp - LAYERYOFFSET(win)
  CASE LEFT_RIGHT_GADGET
    tmp:=CALCOFFSET(WIDTH_SUPER-win.gzzwidth, botGadInfo.horizpot)
    dx:=tmp - LAYERXOFFSET(win)
  ENDSELECT

  IF dx OR dy THEN slideBitMap(dx, dy)
ENDPROC

-> Main message loop for the window.
-> E-Note: E version is simpler, since we use WaitIMessage
PROC doMsgLoop()
  DEF class, currentGadget=NO_GADGET, g:PTR TO gadget
  -> E-Note: g is used to cast the type of MsgIaddr()
  REPEAT
    class:=WaitIMessage(win)
    SELECT class
    CASE IDCMP_NEWSIZE
      doNewSize()
      doDrawStuff()
    CASE IDCMP_GADGETDOWN
      g:=MsgIaddr()
      currentGadget:=g.gadgetid
    CASE IDCMP_GADGETUP
      checkGadget(currentGadget)
      currentGadget:=NO_GADGET
    CASE IDCMP_INTUITICKS
      checkGadget(currentGadget)
    ENDSELECT
  UNTIL class=IDCMP_CLOSEWINDOW
ENDPROC
