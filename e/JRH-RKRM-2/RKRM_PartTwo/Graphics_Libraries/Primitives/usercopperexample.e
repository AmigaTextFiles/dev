-> UserCopperExample.e - User Copper List Example

->>> Header (globals)
OPT PREPROCESS

MODULE 'dos/dos',
       'exec/memory',
       'graphics/copper',
       'graphics/gfxmacros',
       'graphics/text',
       'graphics/videocontrol',
       'graphics/view',
       'hardware/custom',
       'intuition/intuition',
       'intuition/preferences',
       'intuition/screens'

ENUM ERR_NONE, ERR_KICK, ERR_SCRN, ERR_WIN

RAISE ERR_KICK IF KickVersion()=FALSE,
      ERR_SCRN IF OpenScreenTagList()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL,
      "MEM"    IF AllocMem()=NIL

DEF screen=NIL:PTR TO screen, window=NIL:PTR TO window,
    -> E-Note: set-up custom
    custom=CUSTOMADDR:PTR TO custom
->>>

->>> PROC main()
PROC main() HANDLE
  DEF ret_val=RETURN_OK, viewPort:PTR TO viewport
  -> Open a screen and a window
  openAll()
  -> Create and attach the user Copper list.
  loadCopper()
  -> Wait until the user clicks in the close gadget.
  REPEAT
  UNTIL WaitIMessage(window)=IDCMP_CLOSEWINDOW
EXCEPT DO
  IF window
    viewPort:=ViewPortAddress(window)
    IF viewPort.ucopins
      -> Free the memory allocated for the Copper list.
      FreeVPortCopLists(viewPort)
      RemakeDisplay()
    ENDIF
    CloseWindow(window)
  ENDIF
  IF screen THEN CloseScreen(screen)
  SELECT exception
  CASE ERR_KICK;  WriteF('Error: requires V37\n')
                  ret_val:=ERROR_INVALID_RESIDENT_LIBRARY
  CASE ERR_SCRN;  WriteF('Error: failed to open screen\n')
                  ret_val:=ERROR_NO_FREE_STORE
  CASE ERR_WIN;   WriteF('Error: failed to open window\n')
                  ret_val:=ERROR_NO_FREE_STORE
  CASE "MEM";     WriteF('Error: ran out of memory\n')
                  ret_val:=ERROR_NO_FREE_STORE
  ENDSELECT
ENDPROC ret_val
->>>

->>> PROC openAll()
CONST MY_WA_WIDTH=270  -> Width of window.

-> Opens screen and window
-> E-Note: any exception raised here will be handled by the caller
PROC openAll()
  KickVersion(37)
  screen:=OpenScreenTagList(NIL,
                           [SA_OVERSCAN, OSCAN_STANDARD,
                            SA_TITLE,    'User Copper List Example',
                            SA_FONT, ['topaz.font', TOPAZ_SIXTY, 0, 0]:textattr,
                            NIL])
  -> E-Note: C version uses obsolete tags, and in fact used an IDCMP flag,
  ->         INACTIVEWINDOW, with WA_FLAGS (I guess they meant WFLG_ACTIVATE)
  window:=OpenWindowTagList(NIL,
                           [WA_CUSTOMSCREEN, screen,
                            WA_TITLE,        '<- Click here to quit.',
                            WA_IDCMP,        IDCMP_CLOSEWINDOW,
                            WA_FLAGS,        WFLG_DRAGBAR OR WFLG_CLOSEGADGET OR
                                             WFLG_ACTIVATE,
                            WA_LEFT,         (screen.width-MY_WA_WIDTH)/2,
                            WA_TOP,          screen.height/2,
                            WA_HEIGHT,       screen.font.ysize+3,
                            WA_WIDTH,        MY_WA_WIDTH,
                            NIL])
ENDPROC
->>>

->>> PROC loadCopper()
CONST NUMCOLORS=32

-> Creates a Copper list program and adds it to the system
-> E-Note: again, any exception raised here will be handled by the caller
PROC loadCopper()
  DEF i, scanlines_per_color, viewPort:PTR TO viewport, uCopList,
      spectrum:PTR TO INT
  -> Allocate memory for the Copper list.
  -> Make certain that the initial memory is cleared.
  -> E-Note: we *have* to use AllocMem() since FreeVPortCopLists() is used
  uCopList:=AllocMem(SIZEOF ucoplist, MEMF_PUBLIC OR MEMF_CLEAR)

  -> Initialise the Copper list buffer.
  CINIT(uCopList, NUMCOLORS)

  scanlines_per_color:=screen.height/NUMCOLORS

  spectrum:=[$0604, $0605, $0606, $0607, $0617, $0618, $0619, $0629,
             $072a, $073b, $074b, $074c, $075d, $076e, $077e, $088f,
             $07af, $06cf, $05ff, $04fb, $04f7, $03f3, $07f2, $0bf1,
             $0ff0, $0fc0, $0ea0, $0e80, $0e60, $0d40, $0d20, $0d00]:INT
  -> Load in each color.
  FOR i:=0 TO NUMCOLORS-1
    CWAIT(uCopList, i*scanlines_per_color, 0)
    -> E-Note: hard to use CMOVE() due to use of {}, which CMOVEA() eliminates
    -> E-Note: use the offset constant COLOR plus n*SIZEOF INT for n-th color
    CMOVEA(uCopList, CUSTOMADDR+COLOR+0, spectrum[i])
  ENDFOR

  CEND(uCopList)  -> End the Copper list.

  viewPort:=ViewPortAddress(window)  -> Get a pointer to the ViewPort.
  Forbid()  -> Forbid task switching while changing the Copper list.
  viewPort.ucopins:=uCopList
  Permit()  -> Permit task switching again.

  -> Enable user Copper list clipping this ViewPort.
  VideoControl(viewPort.colormap, [VTAG_USERCLIP_SET, NIL, NIL])

  RethinkDisplay()  -> Display the new Copper list.
ENDPROC
->>>

