-> genlockdemo.e - Genlock VideoControl example.

->>> Header (globals)
OPT PREPROCESS

MODULE 'gadtools',
       'exec/libraries',
       'graphics/displayinfo',
       'graphics/gfxbase',
       'graphics/modeid',
       'graphics/text',
       'graphics/videocontrol',
       'graphics/view',
       'intuition/intuition',
       'intuition/screens',
       'libraries/gadtools',
       'utility/tagitem'

ENUM ERR_NONE, ERR_CTXT, ERR_ECS, ERR_GAD, ERR_KICK, ERR_LIB, ERR_SCRN,
     ERR_VIS, ERR_WIN

RAISE ERR_CTXT IF CreateContext()=NIL,
      ERR_GAD  IF CreateGadgetA()=NIL,
      ERR_KICK IF KickVersion()=FALSE,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_SCRN IF OpenScreenTagList()=NIL,
      ERR_VIS  IF GetVisualInfoA()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL,
      "MEM"    IF String()=NIL

-> 'libraries/gadtools' does not define a library name.
#define GADTOOLSNAME 'gadtools.library'

-> Some gadget ID's
ENUM BORDERBLANK_ID=16, BORDERNOTRANS_ID, BITPLANEKEY_ID, CHROMAPLANE_ID,
     CHROMAKEY_ID

-> E-Note: get the right type to use gfxbase
DEF gfx:PTR TO gfxbase
->>>

->>> PROC main()
PROC main() HANDLE
  DEF genscreen=NIL:PTR TO screen, controlwindow=NIL:PTR TO window,
      glist=NIL, gadget:PTR TO gadget, hitgadget:PTR TO gadget,
      vp:PTR TO viewport, viewlord:PTR TO view, vi=NIL, ng:PTR TO newgadget,
      -> E-Note: C version is over-cautious about the size of vtags
      imsg:PTR TO intuimessage, vtags[22]:ARRAY OF tagitem,
      gadgetPtrs[21]:ARRAY OF LONG, iclass, icode, i, j, abort=FALSE, isPAL,
      gfx:PTR TO gfxbase
  gfx:=gfxbase  -> E-Note: set-up correct typed gfxbase
  KickVersion(37)
  gadtoolsbase:=OpenLibrary(GADTOOLSNAME, 37)
  IF 0=(gfx.chiprevbits0 AND GFXF_HR_DENISE) THEN Raise(ERR_ECS)
  -> Check if the user happens to prefer PAL or if this is a true PAL system.
  isPAL:=checkPAL('Workbench')

  -> Open a 'standard' HIRES screen.
  genscreen:=OpenScreenTagList(NIL,
                        -> Give me 3D look window (I'll use a quiet screen).
                       [SA_PENS, [0, 1, 1, 2, 1, 3, 1, 0, 3, -1]:INT,
                        SA_DISPLAYID, HIRES_KEY,
                        SA_DEPTH, 4,
                        -> Give me a lot of border.
                        SA_WIDTH, 640,
                        SA_HEIGHT, IF isPAL THEN 256 ELSE 200,
                        SA_OVERSCAN, 0,
                        -> Hold the titlebar, please.
                        SA_QUIET, TRUE,
                        -> Give me a sysfont 1 as default rastport font.
                        SA_SYSFONT, 1,
                        NIL])
  -> Blast some colourbars in screen's rastport, leave some colour 0 gaps.
  j:=0
  FOR i:=0 TO 15
    SetAPen(genscreen.rastport, i)
    RectFill(genscreen.rastport, j+1, 0, j+30, IF isPAL THEN 255 ELSE 199)
    j:=j+40
  ENDFOR
  -> A line to show where borders start.
  SetAPen(genscreen.rastport, 5)
  Move(genscreen.rastport, 0, 0)
  Draw(genscreen.rastport, genscreen.width-1, 0)
  Draw(genscreen.rastport, genscreen.width-1, genscreen.height-1)
  Draw(genscreen.rastport, 0, genscreen.height-1)
  Draw(genscreen.rastport, 0, 0)

  -> Open a restricted window, no dragging or sizing, just closing (don't
  -> want to refresh screen).
  controlwindow:=OpenWindowTagList(NIL,
                          [WA_TITLE, 'VideoControl',
                           WA_LEFT, 210,
                           WA_TOP, 20,
                           WA_WIDTH, 220,
                           WA_HEIGHT, 150,
                           WA_CUSTOMSCREEN, genscreen,
                           WA_FLAGS, WFLG_CLOSEGADGET OR WFLG_ACTIVATE OR
                                     WFLG_NOCAREREFRESH,
                           WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP,
                           NIL])
  -> OK, got a window, lets make some gadgets.
  vi:=GetVisualInfoA(genscreen, [NIL])
  gadget:=CreateContext({glist})
  ng:=[controlwindow.borderleft+120, controlwindow.bordertop+2,
       12, 12,
       -> Just a demo, set everything to topaz 80.
       'BORDERBLANK', ['topaz.font', 8, 0, 0]:textattr,
       BORDERBLANK_ID, PLACETEXT_LEFT OR NG_HIGHLABEL,
       vi, NIL]:newgadget
  -> E-Note: the C version fails to check the return value of every single one
  ->         of the calls to CreateGadgetA(), which is fatal since "gadget" is
  ->         dereferenced as "gadget.height" (we are using automatic exceptions)
  gadget:=CreateGadgetA(CHECKBOX_KIND, gadget, ng, [NIL])
  gadgetPtrs[BORDERBLANK_ID]:=gadget

  ng.topedge:=ng.topedge+gadget.height+2
  ng.gadgettext:='BORDERNOTRANS'
  ng.gadgetid:=BORDERNOTRANS_ID
  gadget:=CreateGadgetA(CHECKBOX_KIND, gadget, ng, [NIL])
  gadgetPtrs[BORDERNOTRANS_ID]:=gadget

  ng.topedge:=ng.topedge+gadget.height+2
  ng.gadgettext:='CHROMAKEY'
  ng.gadgetid:=CHROMAKEY_ID
  gadget:=CreateGadgetA(CHECKBOX_KIND, gadget, ng, [NIL])
  gadgetPtrs[CHROMAKEY_ID]:=gadget

  ng.topedge:=ng.topedge+gadget.height+2
  ng.gadgettext:='BITPLANEKEY'
  ng.gadgetid:=BITPLANEKEY_ID
  gadget:=CreateGadgetA(CHECKBOX_KIND, gadget, ng, [NIL])
  gadgetPtrs[BITPLANEKEY_ID]:=gadget

  ng.topedge:=ng.topedge+gadget.height+2
  ng.width:=90
  ng.gadgettext:='CHROMAPLANE'
  ng.gadgetid:=CHROMAPLANE_ID
  gadget:=CreateGadgetA(CYCLE_KIND, gadget, ng,
               [GTCY_LABELS, ['Plane 0', 'Plane 1', 'Plane 2', 'Plane 3', NIL],
                NIL])
  gadgetPtrs[CHROMAPLANE_ID]:=gadget

  ng.topedge:=ng.topedge+gadget.height+20
  ng.width:=12
  ng.flags:=PLACETEXT_ABOVE OR NG_HIGHLABEL
  FOR j:=0 TO 1
    FOR i:=0 TO 7
      ng.leftedge:=controlwindow.borderleft+2+(i*gadget.width)
      -> E-Note: we can let E clear up all the E-strings we make
      ng.gadgettext:=StringF(String(3), '\d', i+(j*8))
      ng.gadgetid:=i+(j*8)
      gadget:=CreateGadgetA(CHECKBOX_KIND, gadget, ng, [NIL])
      -> E-Note: C version gets the index wrong
      gadgetPtrs[i+(j*8)]:=gadget
    ENDFOR
    ng.topedge:=ng.topedge+gadget.height
    ng.flags:=PLACETEXT_BELOW OR NG_HIGHLABEL
  ENDFOR

  AddGList(controlwindow, glist, -1, -1, NIL)
  RefreshGList(glist, controlwindow, NIL, -1)
  Gt_RefreshWindow(controlwindow, NIL)

  -> Finally, a window with some gadgets...
  ->
  -> Get the current genlock state.  Obviously I already know what the settings
  -> will be (all off), since I opened the screen myself.  Do it just to show
  -> how to get them.
  vp:=genscreen.viewport

  -> Is borderblanking on?
  vtags[0].tag:=VTAG_BORDERBLANK_GET
  vtags[0].data:=NIL

  -> Is bordertransparent set?
  vtags[1].tag:=VTAG_BORDERNOTRANS_GET
  vtags[1].data:=NIL

  -> Key on bitplane?
  vtags[2].tag:=VTAG_BITPLANEKEY_GET
  vtags[2].data:=NIL

  -> Get plane which is used to key on
  vtags[3].tag:=VTAG_CHROMA_PLANE_GET
  vtags[3].data:=NIL

  -> Chromakey overlay on?
  vtags[4].tag:=VTAG_CHROMAKEY_GET
  vtags[4].data:=NIL

  FOR i:=0 TO 15
    -> Find out which colours overlay
    vtags[i+5].tag:=VTAG_CHROMA_PEN_GET
    vtags[i+5].data:=i
  ENDFOR

  -> Indicate end of tag array
  vtags[21].tag:=VTAG_END_CM
  vtags[21].data:=NIL

  -> And send the commands.  On return the Tags themselves will indicate the
  -> genlock settings for this ViewPort's ColorMap.
  VideoControl(vp.colormap, vtags)

  -> And initialise the gadgets, according to genlock settings.

  IF vtags[0].tag=VTAG_BORDERBLANK_SET
    Gt_SetGadgetAttrsA(gadgetPtrs[BORDERBLANK_ID], controlwindow, NIL,
                      [GTCB_CHECKED, TRUE, NIL])
  ENDIF
  IF vtags[1].tag=VTAG_BORDERNOTRANS_SET
    Gt_SetGadgetAttrsA(gadgetPtrs[BORDERNOTRANS_ID], controlwindow, NIL,
                      [GTCB_CHECKED, TRUE, NIL])
  ENDIF
  IF vtags[2].tag=VTAG_BITPLANEKEY_SET
    Gt_SetGadgetAttrsA(gadgetPtrs[BITPLANEKEY_ID], controlwindow, NIL,
                      [GTCB_CHECKED, TRUE, NIL])
  ENDIF
  IF vtags[3].tag=VTAG_CHROMA_PLANE_SET
    Gt_SetGadgetAttrsA(gadgetPtrs[CHROMAPLANE_ID], controlwindow, NIL,
                      [GTCY_ACTIVE, vtags[3].data, NIL])
  ENDIF
  IF vtags[4].tag=VTAG_CHROMAKEY_SET
    Gt_SetGadgetAttrsA(gadgetPtrs[CHROMAKEY_ID], controlwindow, NIL,
                      [GTCB_CHECKED, TRUE, NIL])
  ENDIF
  FOR i:=0 TO 15
    IF vtags[i+5].tag=VTAG_CHROMA_PEN_SET
      -> E-Note: C version fails to terminate the tag list!
      Gt_SetGadgetAttrsA(gadgetPtrs[i], controlwindow, NIL,
                        [GTCB_CHECKED, TRUE, NIL])
    ENDIF
  ENDFOR

  -> Will only send single commands from here on.
  vtags[1].tag:=VTAG_END_CM

  -> Get user input.
  REPEAT
    WaitPort(controlwindow.userport)
    WHILE imsg:=Gt_GetIMsg(controlwindow.userport)
      iclass:=imsg.class
      icode:=imsg.code
      hitgadget:=imsg.iaddress
      Gt_ReplyIMsg(imsg)

      -> E-Note: C version uses obsolete tags
      SELECT iclass
      CASE IDCMP_GADGETUP
        IF hitgadget.gadgetid < 16
          IF hitgadget.flags AND GFLG_SELECTED
            -> Set colour key
            vtags[0].tag:=VTAG_CHROMA_PEN_SET
          ELSE
            -> Clear colour key
            vtags[0].tag:=VTAG_CHROMA_PEN_CLR
          ENDIF
        ELSE
          i:=hitgadget.gadgetid
          SELECT i
          CASE BORDERBLANK_ID
            IF hitgadget.flags AND GFLG_SELECTED
              -> Set border blanking on
              vtags[0].tag:=VTAG_BORDERBLANK_SET
            ELSE
              -> Turn border blanking off
              vtags[0].tag:=VTAG_BORDERBLANK_CLR
            ENDIF
          CASE BORDERNOTRANS_ID
            IF hitgadget.flags AND GFLG_SELECTED
              -> Set border transparency on
              vtags[0].tag:=VTAG_BORDERNOTRANS_SET
            ELSE
              -> Turn border transparency off
              vtags[0].tag:=VTAG_BORDERNOTRANS_CLR
            ENDIF
          CASE BITPLANEKEY_ID
            IF hitgadget.flags AND GFLG_SELECTED
              -> Key on current selected bitplane (chromaplane)
              vtags[0].tag:=VTAG_BITPLANEKEY_SET
            ELSE
              -> Turn bitplane keying off
              vtags[0].tag:=VTAG_BITPLANEKEY_CLR
            ENDIF
          CASE BITPLANEKEY_ID
            IF hitgadget.flags AND GFLG_SELECTED
              -> Key on current selected bitplane (chromaplane)
              vtags[0].tag:=VTAG_BITPLANEKEY_SET
            ELSE
              -> Turn bitplane keying off
              vtags[0].tag:=VTAG_BITPLANEKEY_CLR
            ENDIF
          CASE CHROMAPLANE_ID
            -> Set plane to key on
            vtags[0].tag:=VTAG_CHROMA_PLANE_SET
            vtags[0].data:=icode
          CASE BITPLANEKEY_ID
            IF hitgadget.flags AND GFLG_SELECTED
              -> Key on current selected bitplane (chromaplane)
              vtags[0].tag:=VTAG_BITPLANEKEY_SET
            ELSE
              -> Turn bitplane keying off
              vtags[0].tag:=VTAG_BITPLANEKEY_CLR
            ENDIF
          CASE CHROMAKEY_ID
            IF hitgadget.flags AND GFLG_SELECTED
              -> Set chromakey overlay on
              vtags[0].tag:=VTAG_CHROMAKEY_SET
            ELSE
              -> Turn chromakey overlay off
              vtags[0].tag:=VTAG_CHROMAKEY_CLR
            ENDIF
          ENDSELECT
        ENDIF

        -> Send video command.
        VideoControl(vp.colormap, vtags)
        -> Get the View for this genlock screen.
        viewlord:=ViewAddress()
        -> And remake the ViewPort.
        MakeVPort(viewlord, vp)
        MrgCop(viewlord)
        LoadView(viewlord)

      CASE IDCMP_CLOSEWINDOW
        -> Get out of here.
        abort:=TRUE
      ENDSELECT
    ENDWHILE
  UNTIL abort

  RemoveGList(controlwindow, glist, -1)

EXCEPT DO
  -> E-Note: works even if glist=NIL
  FreeGadgets(glist)
  IF vi THEN FreeVisualInfo(vi)
  IF controlwindow THEN CloseWindow(controlwindow)
  IF genscreen THEN CloseScreen(genscreen)
  -> E-Note: the E-strings used for gadget text will be freed automatically
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  imsg:=NIL  -> E-Note: get ready to receive a possible error message
  SELECT exception
  CASE ERR_CTXT;  imsg:='Can''t create gadget context'
  CASE ERR_ECS;   imsg:='Requires ECS'
  CASE ERR_GAD;   imsg:='Can''t create gadget'
  CASE ERR_KICK;  imsg:='Requires V37'
  CASE ERR_LIB;   imsg:='Unable to open gadtools.library'
  CASE ERR_SCRN;  imsg:='Can''t open screen'
  CASE ERR_VIS;   imsg:='Can''t get visual info'
  CASE ERR_WIN;   imsg:='Can''t open window'
  CASE "MEM";     imsg:='Out of memory'
  ENDSELECT
  IF imsg THEN EasyRequestArgs(NIL, [SIZEOF easystruct, 0, 'GenlockDemo',
                                     '\s', 'Continue']:easystruct,
                               NIL, [imsg])
ENDPROC
->>>

->>> PROC checkPAL(screenname)
-> Generic routine to check for a PAL System.  CheckPAL returns TRUE, if the
-> videomode of the specified public screen (or default videmode) is PAL.  If
-> the screenname is NIL, the default public screen will be used.
PROC checkPAL(screenname)
  DEF screen:PTR TO screen, modeID=LORES_KEY, displayinfo:displayinfo, isPAL
  IF gfx.lib.version>=36
    -> We got V36, so lets use the new calls to find out what kind of videomode
    -> the user (hopefully) prefers.
    IF screen:=LockPubScreen(screenname)
      -> Use graphics.library/GetVPModeID() to get the ModeID of the specified
      -> screen.  Will use the default public screen (Workbench most of the
      -> time) if NIL.  It is _very_ unlikely that this would be invalid, heck
      -> it's impossible.
      IF INVALID_ID<>(modeID:=GetVPModeID(screen.viewport))
        -> If the screen is in VGA mode, we can't tell whether the system is PAL
        -> or NTSC.  So to be foolproof we fall back to the displayinfo of the
        -> default.monitor by inquiring about just the LORES_KEY displaymode if
        -> we don't know.  The default.monitor reflects the initial video setup
        -> of the system, thus is an alias for either ntsc.monitor or
        -> pal.monitor.  We only use the displaymode of the specified public
        -> screen if it's display mode is PAL or NTSC and NOT the default.
        IF ((modeID AND MONITOR_ID_MASK)<>NTSC_MONITOR_ID) AND
           ((modeID AND MONITOR_ID_MASK)<>PAL_MONITOR_ID)
          modeID:=LORES_KEY
        ENDIF
      ENDIF
      UnlockPubScreen(NIL, screen)
    ENDIF
    -> If fails modeID=LORES_KEY.  Can't lock screen, so fall back on
    -> default monitor.
    IF GetDisplayInfoData(NIL, displayinfo, SIZEOF displayinfo,
                          DTAG_DISP, modeID)
      -> Currently the default monitor is always either PAL or NTSC.
      isPAL:=displayinfo.propertyflags AND DIPF_IS_PAL
    ENDIF
  ELSE
    -> < V36.  The enhancements to the videosystem in V36 cannot be better
    -> expressed than with the simple way to determine PAL in V34.
    isPAL:=gfx.displayflags AND PAL
  ENDIF
ENDPROC isPAL
->>>

