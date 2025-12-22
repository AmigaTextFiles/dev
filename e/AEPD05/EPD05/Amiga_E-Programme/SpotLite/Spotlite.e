/* SpotLite v0.04 - © 1993 by Leon Woestenberg (leon@stack.urc.tue.nl) */

/* FOLDER "Modules" */
/* ~~~~~~~~~~~~~~~~ */

MODULE 'intuition/intuition'
MODULE 'intuition/screens'
MODULE 'intuition/gadgetclass'
MODULE 'graphics/displayinfo'
MODULE 'graphics/text'
MODULE 'gadtools'
MODULE 'libraries/gadtools'
MODULE 'exec/ports'

/* FEND */
/* FOLDER "Globals" */
/* ~~~~~~~~~~~~~~~~ */

/* Prefs constant */
CONST WBSCREEN=TRUE

/* tagitems for newlook menus */
CONST WFLG_NEWLOOKMENUS=$200000
CONST GTMN_NEWLOOKMENUS=$80080043

/* menu item id's */
ENUM MENU_LOAD,MENU_SAVE,MENU_ABOUT,MENU_QUIT,MENU_LAST

/* screen info */
DEF screen:PTR TO screen
DEF visual
DEF topaz:PTR TO textattr
/* slider format string */
DEF format[6]:STRING

/* main window objects */
DEF mainwindow:PTR TO window
DEF mainmenus:PTR TO menu
DEF maingadgetlist=0:PTR TO gadget
ENUM GADID_RESET,GADID_STRING,GADID_SLIDER,NUM_MAINGADGETS
DEF maingadget[NUM_MAINGADGETS]:ARRAY OF LONG

/* slider window objects */
DEF sliderwindow:PTR TO window
DEF slidermenus:PTR TO menu
DEF slidergadgetlist=0:PTR TO gadget
CONST NUM_SLIDERS=23
DEF slidergadget[NUM_SLIDERS]:ARRAY OF LONG
DEF slidervalue[NUM_SLIDERS]:ARRAY OF CHAR

/* waitstate terminator */
DEF quitflag=FALSE

/* FEND */
/* FOLDER "Editables" */

/* Inside window left-top point */
CONST WIN_TOP=11,WIN_LEFT=4,WIN_BOTTOM=10

/* keep (SLI_WIDTH-8) a multiply of ten to keep a neat scale display */

/* slider offset from boxes, slider sizes and gaps between sliders */
CONST SLI_XOFF=0,SLI_YOFF=0,SLI_WIDTH=16,SLI_GAP=0
DEF sli_height=78

/* box offset from left top of window area, and box size calculation */
CONST BOX_XOFF=4,BOX_YOFF=2

/* gap between boxes, keep ten or higher to have neat scale display */
CONST BOX_GAP=20

/* FEND                           */
/* FOLDER "Exceptions" */
/* ~~~~~~~~~~~~~~~~~~~ */

/* no error exception */
ENUM EXCEPT_NOERROR,

/* xOpenScreen exceptions */
ERROR_NOSCREEN=0,ERROR_NOWBSCREEN,ERROR_NOVISUAL,

/* xOpenWindow exceptions */
ERROR_NOWINDOW=0,ERROR_NOMENUSTRIP,

/* xCreateGadgets exceptions */
ERROR_NOCONTEXT=0,ERROR_NOGADGET,

/* xCreateMenus exceptions */
ERROR_NOMENUS=0,ERROR_NOLAYOUT,

/* xOpenLibraries exceptions */
ERROR_NOGADTOOLS=0

/* FEND */

/* FOLDER "Main" */
PROC main()

  /* version info (<alt space> between name and version) */
  VOID '$VER: SpotLite 0.04 © 1993 by Leon Woestenberg'

  /* set topaz text attributes */
  topaz:=['topaz.font',8,0,FPF_ROMFONT]:textattr

  /* set level format */
  /* format:='%03lu' */
  format := '\z\d[03]'

  /* present interface */
  IF xOpenSpotLiteLibraries()
    IF xOpenSpotLiteScreen()
      IF xOpenMainWindow()
        IF xOpenSliderWindow()

          /* handle input */
          xWaitForSignals()

          /* until user quits */
          xCloseSliderWindow()
        ENDIF
        xCloseMainWindow()
      ENDIF
      xCloseSpotLiteScreen()
    ENDIF
    xCloseSpotLiteLibraries()
  ENDIF
ENDPROC
/* FEND */
/* FOLDER "Wait for Signals" */
PROC xWaitForSignals()
  
  /* signal bitmasks */
  DEF mainmask,slidermask,signalmask
  DEF port:PTR TO mp

    /* create signal bitmasks */

    /* mainwindow open? */
    IF mainwindow
      port:=mainwindow.userport
      mainmask:=Shl(1,port.sigbit)
    ELSE
      mainmask:=0
    ENDIF
    /* sliderwindow open? */
    IF sliderwindow
      port:=sliderwindow.userport
      slidermask:=Shl(1,port.sigbit)
    ELSE
      slidermask:=0
    ENDIF

  /* quit? */
  WHILE quitflag=FALSE

    /* wait for wanted signals */
    signalmask:=Wait(mainmask OR slidermask)

    /* check for signals, and act if set */
    IF (mainmask AND signalmask) THEN xHandleMainMessages()
    IF (slidermask AND signalmask) THEN xHandleSliderMessages()

  ENDWHILE
ENDPROC
/* FEND */

/* FOLDER "Screen" */
/* FOLDER "Open" */
PROC xOpenSpotLiteScreen()
  IF WBSCREEN
    IF xLockWorkbenchScreen() THEN RETURN TRUE
  ELSE
    IF xOpenCustomScreen() THEN RETURN TRUE
  ENDIF
ENDPROC
PROC xCloseSpotLiteScreen()
  IF WBSCREEN
    xUnlockWorkbenchScreen()
  ELSE
    xCloseCustomScreen()
  ENDIF
ENDPROC
/* FEND */
/* FOLDER "Custom" */
PROC xOpenCustomScreen() HANDLE

  /* open a custom screen */
  screen:=xCall(OpenScreenTagList(0,
    [SA_WIDTH,STDSCREENWIDTH,
     SA_HEIGHT,STDSCREENHEIGHT,
     SA_TYPE,CUSTOMSCREEN,
     SA_TITLE,'SpotLite v0.03 © 1993 by Leon Woestenberg',
     SA_DISPLAYID,HIRES_KEY,
     SA_FONT,topaz,
     SA_DEPTH,2,
     0,0]),ERROR_NOSCREEN)

  /* get screen private info for gadtools */
  visual:=xCall(GetVisualInfoA(screen,NIL),ERROR_NOVISUAL)

  /* opening screen succeeded */
  RETURN TRUE
EXCEPT

  /* cleanup */
  xCloseCustomScreen()

  /* inform user */
  xExceptionMessage(['Could not open custom screen.',
                     'Could not get screen visual info.'])
ENDPROC
PROC xCloseCustomScreen() /* "xCloseScreen" */

  /* visual info? */
  IF visual
    /* free visual info */
    FreeVisualInfo(visual)
    visual:=0
  ENDIF

  /* screen open? */
  IF screen
    /* close screen */
    IF CloseScreen(screen)=FALSE
      /* screen has windows */
      /* IF SO, THIS IS BUG */
      exception:=EXCEPT_NOERROR
      xExceptionMessage(['Screen contains at least one window.\nPlease report this error to author.'])
    ELSE
      screen:=0
    ENDIF
  ENDIF
ENDPROC
/* FEND */
/* FOLDER "Workbench" */
PROC xLockWorkbenchScreen() HANDLE
  screen:=xCall(LockPubScreen('Workbench'),ERROR_NOWBSCREEN)
  visual:=xCall(GetVisualInfoA(screen,NIL),ERROR_NOVISUAL)
  RETURN TRUE
EXCEPT
  xUnlockWorkbenchScreen()
  xExceptionMessage(['Could not lock Workbench screen',
                     'Could not get screen visual info'])
ENDPROC
PROC xUnlockWorkbenchScreen()
  IF visual
    FreeVisualInfo(visual)
    visual:=0
  ENDIF
  IF screen
    UnlockPubScreen(NIL,screen)
    screen:=0
  ENDIF
ENDPROC
/* FEND */
/* FEND */
/* FOLDER "Main Window" */
/* ~~~~~~~~~~~~~~~~~~~~ */
/* FOLDER "Open" */
PROC xOpenMainWindow() HANDLE

  /* gadgets made? */
  IF xCreateMainGadgets()

    /* menus made? */
    IF xCreateMainMenus()

      /* open window */
      mainwindow:=xCall(OpenWindowTagList(NIL,

        /* window position and size */
       [WA_LEFT,45,WA_TOP,28,WA_WIDTH,376,WA_HEIGHT,109,

        /* our window settings */
        WA_FLAGS,WFLG_DRAGBAR OR
                 WFLG_DEPTHGADGET OR
                 WFLG_CLOSEGADGET OR
                 WFLG_ACTIVATE OR
                 WFLG_SMART_REFRESH OR
                 WFLG_NEWLOOKMENUS,

        /* what we want to know */
        WA_IDCMP,SLIDERIDCMP OR
                 IDCMP_MENUPICK OR
                 IDCMP_CLOSEWINDOW OR
                 IDCMP_REFRESHWINDOW,

        /* window title */
        WA_TITLE,'Main Controls',

        /* window references */
        WA_CUSTOMSCREEN,screen,
        WA_GADGETS,maingadgetlist]),ERROR_NOWINDOW)

        /* initial refresh gadgets */
        Gt_RefreshWindow(mainwindow,NIL)

        /* refresh window */
        xRenderMainWindow()
        
        /* attach menu strip */
        xCall(SetMenuStrip(mainwindow,mainmenus),ERROR_NOMENUSTRIP)

      /* window is opened succesfully */
      RETURN TRUE
    ENDIF
  ENDIF
EXCEPT

  /* clean up */
  xCloseMainWindow()

  /* inform user */
  xExceptionMessage(['Could not open window',
                     'Could not attach menustrip'])
ENDPROC
PROC xCloseMainWindow()

  /* detach the menustrip */
  IF mainwindow THEN ClearMenuStrip(mainwindow)

  /* free the menu structure */
  IF mainmenus
    FreeMenus(mainmenus)
    mainmenus:=0
  ENDIF

  /* close the window */
  IF mainwindow
    CloseWindow(mainwindow)
    mainwindow:=0
  ENDIF

  /* free the gadgetlist */
  IF maingadgetlist
    FreeGadgets(maingadgetlist)
    maingadgetlist:=0
  ENDIF

ENDPROC
/* FEND */
/* FOLDER "Gadgets" */
PROC xCreateMainGadgets() HANDLE

  /* links gadgets */
  DEF xgadget=0:PTR TO gadget

  /* create first context gadget */
  xgadget:=xCall(CreateContext({maingadgetlist}),ERROR_NOCONTEXT)

  /* create 'reset' button */
  maingadget[GADID_RESET]:=xCall(xgadget:=CreateGadgetA(BUTTON_KIND,xgadget,
    [15,85,109,16,'_Reset',topaz,
    GADID_RESET,PLACETEXT_IN,visual]:newgadget,
    [GT_UNDERSCORE,"_"]),ERROR_NOGADGET)

  /* create 'code name' stringgadget */
  maingadget[GADID_STRING]:=xCall(xgadget:=CreateGadgetA(STRING_KIND,xgadget,
    [93,28,266,14,
     'Just A Plain String Gadget',topaz,
     GADID_STRING,PLACETEXT_ABOVE,visual,0]:newgadget,
    [GTST_MAXCHARS,256,
     GT_UNDERSCORE,"_",
     GA_IMMEDIATE,TRUE]),ERROR_NOGADGET)

  /* create slider gadget */
  maingadget[GADID_SLIDER]:=xCall(xgadget:=CreateGadgetA(SLIDER_KIND,xgadget,
    [10,14,30,50,
     'Spot',topaz,
     GADID_SLIDER,PLACETEXT_RIGHT,visual,0]:newgadget,
    [GTSL_MIN,1,
     GTSL_MAX,4,
     GTSL_LEVEL,1,
     GTSL_MAXLEVELLEN,3,
     GTSL_LEVELFORMAT,format,
     GTSL_LEVELPLACE,PLACETEXT_BELOW,
     PGA_FREEDOM,LORIENT_VERT,
     GA_IMMEDIATE,TRUE,
     GA_RELVERIFY,TRUE]),ERROR_NOGADGET)
  RETURN TRUE
EXCEPT

  /* free the gadgetlist */
  FreeGadgets(maingadgetlist)
  maingadgetlist:=0

  /* inform the user */
  xExceptionMessage(['Could not create main gadgets context.',
                     'Could not create a main gadget.'])
ENDPROC
/* FEND */
/* FOLDER "Menus" */
PROC xCreateMainMenus() HANDLE

  /* create menus */
  mainmenus:=xCall(CreateMenusA([NM_TITLE,0,'Project',0,$0,0,0,
    NM_ITEM,0,'Load...','L',$0,0,MENU_LOAD,
    NM_ITEM,0,'Save...','S',$0,0,MENU_SAVE,
    NM_ITEM,0,NM_BARLABEL,0,0,0,0,
    NM_ITEM,0,'About...',0,0,0,MENU_ABOUT,
    NM_ITEM,0,NM_BARLABEL,0,0,0,0,
    NM_ITEM,0,'Quit','Q',$0,0,MENU_QUIT,
    NM_TITLE,0,'Preferences',0,$0,0,0,
    NM_ITEM,0,'Last Saved...',0,$0,0,MENU_LAST,
    NM_END,0,0,0,0,0,0]:newmenu,NIL),ERROR_NOMENUS)

  /* layout menus */
  xCall(LayoutMenusA(mainmenus,visual,[GTMN_NEWLOOKMENUS,TRUE]),ERROR_NOLAYOUT)

  /* menus created succesfully */
  RETURN TRUE
EXCEPT
  /* clean up */
  IF mainmenus
    FreeMenus(mainmenus)
    mainmenus:=0
  ENDIF

  /* inform user */
  xExceptionMessage(['Could not create main menus.',
                     'Could not layout main menus.'])
ENDPROC
/* FEND */
/* FOLDER "Render" */
PROC xRenderMainWindow()
  DrawBevelBoxA(mainwindow.rport,
                mainwindow.borderleft,
                mainwindow.bordertop,
                mainwindow.width-mainwindow.borderright-mainwindow.borderleft,
                mainwindow.height-mainwindow.bordertop-mainwindow.borderbottom,
                [GT_VISUALINFO,visual])
ENDPROC
/* FEND */
/* FOLDER "Handle" */

PROC xHandleMainMessages()

  /* message pointer and body */
  DEF message:PTR TO intuimessage
  DEF class,code,address

  /* clicked gadget and id */
  DEF clicked:PTR TO gadget
  DEF gadgetid

  /* process one message at a time */
  WHILE message:=Gt_GetIMsg(mainwindow.userport)

    /* copy message */
    class:=message.class
    code:=message.code
    address:=message.iaddress

    /* reply message */
    Gt_ReplyIMsg(message)

    /* what happened? */
    SELECT class

    /* gadget released? */
    CASE IDCMP_GADGETUP
      clicked:=address
      gadgetid:=clicked.gadgetid
      SELECT gadgetid
      CASE GADID_RESET
        FOR gadgetid:=0 TO 23
          IF slidervalue[gadgetid]<>127
            slidervalue[gadgetid]:=127
            Gt_SetGadgetAttrsA(slidergadget[gadgetid],sliderwindow,0,[GTSL_LEVEL,127])
          ENDIF
        ENDFOR
        WriteF('Reset done.\n')
      CASE GADID_STRING
        WriteF('String deactivated.\n')
      CASE GADID_SLIDER
        WriteF('Slider released.\n')
      ENDSELECT

    /* gadget pressed? */
    CASE IDCMP_GADGETDOWN
      clicked:=address
      gadgetid:=clicked.gadgetid
      SELECT gadgetid
      CASE GADID_RESET
      CASE GADID_STRING
      CASE GADID_SLIDER
        WriteF('Slider pressed.\n')
      ENDSELECT

    /* slider in use? */
    CASE IDCMP_MOUSEMOVE
      clicked:=address
      gadgetid:=clicked.gadgetid
      WriteF('Mouse moved.\n')

    /* menu item picked? */
    CASE IDCMP_MENUPICK
      WriteF('class=$\h\n',class)
      WriteF('code=$\h\n',code)
      WriteF('address=$\h\n',address)
      WriteF('No gadget...\n')

    /* closegadget? */
    CASE IDCMP_CLOSEWINDOW
      quitflag:=TRUE

    /* refresh window? */
    CASE IDCMP_REFRESHWINDOW
      xRenderMainWindow()

    ENDSELECT
  ENDWHILE
ENDPROC
/* FEND */
/* FEND */
/* FOLDER "Slider Window" */
/* ~~~~~~~~~~~~~~~~~~~~~~ */
/* FOLDER "Open" */
PROC xOpenSliderWindow() HANDLE

  /* gadgets made? */
  IF xCreateSliderGadgets()

    /* menus made? */
    IF xCreateSliderMenus()

      /* open window */
      sliderwindow:=xCall(OpenWindowTagList(NIL,

        /* window position and size */
       [WA_LEFT,0,
        WA_TOP,62,
        WA_WIDTH,screen.width,
        WA_HEIGHT,sli_height+WIN_TOP+BOX_YOFF+1+SLI_YOFF+SLI_YOFF+1+BOX_YOFF+WIN_BOTTOM,
        WA_MINWIDTH,screen.width,
        WA_MAXWIDTH,screen.width,
        WA_MINHEIGHT,WIN_TOP+BOX_YOFF+1+SLI_YOFF+28+SLI_YOFF+1+BOX_YOFF+WIN_BOTTOM,
        WA_MAXHEIGHT,screen.height,


        /* our window settings */
        WA_FLAGS,WFLG_DRAGBAR OR
                 WFLG_CLOSEGADGET OR
                 WFLG_ACTIVATE OR
                 WFLG_SMART_REFRESH OR
                 WFLG_SIZEGADGET OR
                 WFLG_SIZEBBOTTOM OR
                 WFLG_NEWLOOKMENUS,

        /* what we want to know */
        WA_IDCMP,SLIDERIDCMP OR
                 IDCMP_CLOSEWINDOW OR
                 IDCMP_NEWSIZE OR
                 IDCMP_REFRESHWINDOW,

        /* window title */
        WA_TITLE,'Slider Panel',

        /* window references */
        WA_CUSTOMSCREEN,screen,
        WA_GADGETS,slidergadgetlist]),ERROR_NOWINDOW)

        /* initial window refresh */
        Gt_RefreshWindow(sliderwindow,NIL)

        /* render window */
        xRenderSliderWindow()

        /* attach menu strip */
        xCall(SetMenuStrip(sliderwindow,slidermenus),ERROR_NOMENUSTRIP)

      /* window is opened succesfully */
      RETURN TRUE
    ENDIF
  ENDIF
EXCEPT

  /* clean up */
  xCloseSliderWindow()

  /* inform user */
  xExceptionMessage(['Could not open slider window',
                     'Could not attach menustrip'])
ENDPROC
PROC xCloseSliderWindow()

  /* detach the menustrip */
  IF sliderwindow THEN ClearMenuStrip(sliderwindow)

  /* free the menu structure */
  IF slidermenus
    FreeMenus(slidermenus)
    slidermenus:=0
  ENDIF

  /* close the window */
  IF sliderwindow
    CloseWindow(sliderwindow)
    sliderwindow:=0
  ENDIF

  /* free the gadgetlist */
  IF slidergadgetlist
    FreeGadgets(slidergadgetlist)
    slidergadgetlist:=0
  ENDIF

ENDPROC
/* FEND */
/* FOLDER "Gadgets" */
PROC xCreateSliderGadgets() HANDLE

  /* links gadgets */
  DEF xgadget=0:PTR TO gadget

  /* run through groups and sliders */
  DEF xgroup,xslider,xnum=0,xpos

  /* create first context gadget */
  xgadget:=xCall(CreateContext({slidergadgetlist}),ERROR_NOCONTEXT)

  xpos:=WIN_LEFT+BOX_XOFF+2+SLI_XOFF

  /* build sliders */
  FOR xgroup:=0 TO 3
    FOR xslider:=0 TO 5
      /* create slider gadget */
      slidergadget[xnum]:=xCall(xgadget:=CreateGadgetA(SLIDER_KIND,xgadget,
        [xpos,WIN_TOP+BOX_YOFF+1+SLI_YOFF,SLI_WIDTH,sli_height,
         0,topaz,xnum,PLACETEXT_ABOVE,visual,0]:newgadget,
        [GTSL_MIN,0,
         GTSL_MAX,255,
         GTSL_LEVEL,slidervalue[xnum],
         PGA_FREEDOM,LORIENT_VERT,
         GA_IMMEDIATE,TRUE,
         GA_RELVERIFY,TRUE]),ERROR_NOGADGET)
      /* increase gadgetnumber */
      INC xnum
      /* add x gadget offset */
      ADD.L #SLI_WIDTH+SLI_GAP,xpos
    ENDFOR
    /* add x group gap */
    ADD.L #-SLI_GAP+2+SLI_XOFF+BOX_GAP+2+SLI_XOFF,xpos
  ENDFOR
  RETURN TRUE
EXCEPT

  /* free the gadgetlist */
  FreeGadgets(slidergadgetlist)
  slidergadgetlist:=0

  /* inform the user */
  xExceptionMessage(['Could not create slider gadgets context.',
                     'Could not create a slider.'])
ENDPROC
/* FEND */
/* FOLDER "Menus" */
PROC xCreateSliderMenus() HANDLE

  /* create menus */
  slidermenus:=xCall(CreateMenusA([NM_TITLE,0,'Project',0,$0,0,0,
    NM_ITEM,0,'Load...','L',$0,0,MENU_LOAD,
    NM_ITEM,0,'Save...','S',$0,0,MENU_SAVE,
    NM_ITEM,0,NM_BARLABEL,0,0,0,0,
    NM_ITEM,0,'About...',0,0,0,MENU_ABOUT,
    NM_ITEM,0,NM_BARLABEL,0,0,0,0,
    NM_ITEM,0,'Quit','Q',$0,0,MENU_QUIT,
    NM_TITLE,0,'Sliders',0,$0,0,0,
    NM_ITEM,0,'50%...',0,$0,0,MENU_LAST,
    NM_END,0,0,0,0,0,0]:newmenu,NIL),ERROR_NOMENUS)

  /* layout menus */
  xCall(LayoutMenusA(slidermenus,visual,[GTMN_NEWLOOKMENUS,TRUE]),ERROR_NOLAYOUT)

  /* menus created succesfully */
  RETURN TRUE
EXCEPT
  /* clean up */
  IF slidermenus
    FreeMenus(slidermenus)
    slidermenus:=0
  ENDIF

  /* inform user */
  xExceptionMessage(['Could not create slider menus.',
                     'Could not layout slider menus.'])
ENDPROC
/* FEND */
/* FOLDER "Render" */
PROC xRenderSliderWindow()
  DEF box,level,indent
  /*
  DrawBevelBoxA(sliderwindow.rport,
                WIN_LEFT,
                WIN_TOP,
                BOX_XOFF+((SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4)*4)+(BOX_GAP*3)+BOX_XOFF,
                BOX_YOFF+1+SLI_YOFF+sli_height+SLI_YOFF+1+BOX_YOFF,
                [GT_VISUALINFO,visual,0,0])
  */
  FOR box:=0 TO 3
    DrawBevelBoxA(sliderwindow.rport,
                  WIN_LEFT+BOX_XOFF+(((SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4)+BOX_GAP)*box),
                  WIN_TOP+BOX_YOFF,
                  (SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4),
                  1+SLI_YOFF+sli_height+SLI_YOFF+1,
                  [GT_VISUALINFO,visual,
                   GTBB_RECESSED,TRUE,0,0])
  ENDFOR
  stdrast:=sliderwindow.rport
  FOR box:=0 TO 2
    DrawBevelBoxA(sliderwindow.rport,
                  WIN_LEFT+BOX_XOFF+(SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4)+(((SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4)+BOX_GAP)*box),
                  WIN_TOP+BOX_YOFF,
                  BOX_GAP,
                  1+SLI_YOFF+sli_height+SLI_YOFF+1,
                  [GT_VISUALINFO,visual,
                   GTBB_RECESSED,TRUE,0,0])
    FOR level:=0 TO 10
      SELECT level
      CASE 0
        indent:=0
      CASE 5
        indent:=1
      CASE 10
        indent:=0
      DEFAULT
        indent:=2
      ENDSELECT
      Line(WIN_LEFT+BOX_XOFF+(SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4)+2+indent+(((SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4)+BOX_GAP)*box),
           WIN_TOP+BOX_YOFF+SLI_YOFF+4+(((sli_height-8)*level)/10),
           WIN_LEFT+BOX_XOFF+(SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4)+BOX_GAP-3-indent+(((SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4)+BOX_GAP)*box),
           WIN_TOP+BOX_YOFF+SLI_YOFF+4+(((sli_height-8)*level)/10),1)

      /* graphics.library's 'Line' equivalent */
      /*
      Move(sliderwindow.rport,WIN_LEFT+BOX_XOFF+(SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4)+2+indent+(((SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4)+BOX_GAP)*box),WIN_TOP+BOX_YOFF+SLI_YOFF+4+(((sli_height-8)*level)/10))
      Draw(sliderwindow.rport,WIN_LEFT+BOX_XOFF+(SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4)+BOX_GAP-3-indent+(((SLI_WIDTH+SLI_GAP*5+SLI_WIDTH+SLI_XOFF+SLI_XOFF+4)+BOX_GAP)*box),WIN_TOP+BOX_YOFF+SLI_YOFF+4+(((sli_height-8)*level)/10))
      */
  ENDFOR
ENDFOR

ENDPROC
/* FEND */
/* FOLDER "Handle" */

PROC xHandleSliderMessages()

  /* message pointer and body */
  DEF message:PTR TO intuimessage
  DEF class,code,address

  /* clicked gadget and id */
  DEF clicked:PTR TO gadget
  DEF gadgetid

  /* process one message at a time */
  WHILE message:=Gt_GetIMsg(sliderwindow.userport)

    /* copy message */
    class:=message.class
    code:=message.code
    address:=message.iaddress

    /* what happened? */
    SELECT class

    /* gadget released? */
    CASE IDCMP_GADGETUP
      clicked:=address
      gadgetid:=clicked.gadgetid
      slidervalue[gadgetid]:=code
      WriteF('slider #\d released on \z\d[3].\b',gadgetid,code)

    /* gadget pressed? */
    CASE IDCMP_GADGETDOWN
      clicked:=address
      gadgetid:=clicked.gadgetid
      WriteF('slider #\d pressed.         \b',gadgetid)
      
    CASE IDCMP_MOUSEMOVE
      clicked:=address
      gadgetid:=clicked.gadgetid
      WriteF('slider #\d moved to \z\d[3].\b',gadgetid,code)
    
    /* menu item picked? */
    CASE IDCMP_MENUPICK

    /* closegadget? */
    CASE IDCMP_CLOSEWINDOW
      WriteF('\n')
      quitflag:=TRUE

    /* window resized? */
    CASE IDCMP_NEWSIZE

      /* clean window area */
      SetAPen(sliderwindow.rport,0)
      RectFill(sliderwindow.rport,WIN_LEFT,WIN_TOP,sliderwindow.width-sliderwindow.borderright-1,sliderwindow.height-sliderwindow.borderbottom-1)

      /* calculate new sliderheight */
      sli_height:=Div(sliderwindow.height-WIN_TOP-BOX_YOFF-1-SLI_YOFF-SLI_YOFF-1-BOX_YOFF-WIN_BOTTOM-8,10)*10+8

      /* and change the sliders */
      FOR gadgetid:=0 TO 23
        clicked:=slidergadget[gadgetid]
        clicked.height:=sli_height-4
      ENDFOR

      /* refresh and repair window */
      RefreshWindowFrame(sliderwindow)
      Gt_RefreshWindow(sliderwindow,NIL)

    /* refresh window? */
    CASE IDCMP_REFRESHWINDOW

      /* re-render window */
      /*
      Gt_BeginRefresh(sliderwindow)
      Gt_EndRefresh(sliderwindow,TRUE)
      */
      xRenderSliderWindow()

    ENDSELECT
    /* reply message */
    Gt_ReplyIMsg(message)

  ENDWHILE
ENDPROC
/* FEND */
/* FEND */

/* FOLDER "Libraries" */
PROC xOpenSpotLiteLibraries() HANDLE

  /* open libraries */
  gadtoolsbase:=xCall(OpenLibrary('gadtools.library',37),ERROR_NOGADTOOLS)

  /* all libs opened succesfully */
  RETURN TRUE

EXCEPT

  /* cleanup */
  xCloseSpotLiteLibraries()

  /* inform user */
  xExceptionMessage(['Could not open gadtools.library'])

ENDPROC
PROC xCloseSpotLiteLibraries()
  /* gadtools? */
  IF gadtoolsbase
    /* close gadtools */
    CloseLibrary(gadtoolsbase)
    gadtoolsbase:=0
  ENDIF
ENDPROC
/* FEND */
/* FOLDER "History" */
/*

History of 'SpotLite', copyrights © 1993 by Leon Woestenberg
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Global Info: SpotLite is written by Leon Woestenberg using the
~~~~~~~~~~~~ Amiga E compiler version 2.1b by Wouter van Oortmerssen.

Spotlite Introduction
~~~~~~~~~~~~~~~~~~~~~
Spotlite is a project for an Amiga controlled 'Spotlights Mix Panel' which
is used in theatres and such. This should be able to fully edit and record
a light show appearance. Because it has to run on a first generation Amiga
500 upgraded with 2.04 Kickstart, efficiency has to be high. Therefore,
the E language was a good choice for me. I'm just a beginner in programming
the Amiga and I by releasing this source code, I hope I can help other
beginners out by showing the basic stuff of Intuition and Amiga E.

Disclaimer
~~~~~~~~~~
I do not claim (so I disclaim) that this code is fully compliant with THE
rules. To my humble knowledge, it is, and if you think different, let me
know, because my aim is to learn a neat way of programming the Amiga!

v0.01 (18-Sep-93)
~~~~~~~~~~~~~~~~~
- Begin of project, mainly adapting GUI functions and cleaning them up.
- Added folders (for GoldEd) and comments to almost every line of code.
- Problems:
  a) Screen doesn't copy 'HIRES_KEY' from Workbench settings.
  b) The slider gadget shows it's format string instead of level.

v0.02 (21-Sep-93)
~~~~~~~~~~~~~~~~~
- Started adding an appropriate GUI interface for spotlight controls.
- Saved 24 bytes by using a VOID before the version string.
- Saved even more bytes by defining a global textattribute pointer.
- Still unsure about which window refresh method to use: smart or simple?
- Added opening on Workbench screen, and made entry procedure for opening.
Problems:
  c) Furthermore I want the slider values to update while dragging, as well
    as being able to hear when user presses and releases slidergadget.
Solutions:
  c) After studying the intuition constants, the last problem is solved:
     SLIDERIDCMP is a total of IDCMP_GADGETUP, IDCMP_GADGETDOWN and
     IDCMP_MOUSEMOVE. As I was using '+' instead of 'OR' in defining the
     IDCMP mask, things screw up (as $70 + $20 is not equal to $70 OR $20).
  b) The GTSL_LEVELFORMAT tag needed a stringpointer (STRPTR in C) and I
     supplied a normal pointer (oops!). But I took revenge by sending it an
     e-string pointer which is far superior (but downwards compatible...:-).

v0.03 (27-Sep-93)
~~~~~~~~~~~~~~~~~
- Building nice slider window with many, many gadgets. Space might be too 
  small when not using (horizontal) overscan or borderless windows...
- Added constants which define the slider window layout. Offsets, gaps and
  sizes of boxes and sliders are adjustable and prepared for y-scalebility.
- Removed a bug that caused the sliders to appear shifted from the boxes when
  the slidergap was non zero. A groups last gadget gap was added to the next.
- Looks like a have to get a registered version of GoldED real quick now, as
  the sourcecode is going to grow over the 1000 lines limit.
- Changed the graphics.library's 'Move' and 'Draw' instructions to AmigaE's
  'Line' instruction, which is a small decrease in length (increased speed?).
Problems:
  d) Cannot get the resize/refresh routines to work properly, as someway the
     system re-renders the slider settings before I've resized the sliders.
Solutions:
  b) It seemed that the formatstring must be a global variable, to which
     RawDoFmt() will refer during gadget updating. Problem solved now.
  d) Re-render routines were much to complex by doing window resizing to get
     a nice scale graphic. Influenced by Reqtools' filerequester scaling I
     now only rescale slider gadgets and leave the window as it is.
  e) Re-sizeing routines do not work under 3.x. Sliders are displayed with
     original height. Need some example code or Kernel Reference Manuals.

v0.04 (8-Dec-93)
~~~~~~~~~~~~~~~~
- I received my registered GoldED from Dietmar Eilert within two weeks!
  Now I can continue exceeding the 1000 lines limit with this source code.
- Released this code onto Aminet in dev/e for as an example E source for
  beginners in both Intuition and Amiga E.
*/
/* FEND */

/* FOLDER "xExceptionMessage" */
PROC xExceptionMessage(xmessagelist)

  /* display an personal message requester with OK button */
  EasyRequestArgs(mainwindow,[SIZEOF easystruct,0,'SpotLight Information',ListItem(xmessagelist,exception),'OK'],0,NIL)

ENDPROC
/* FEND */
/* FOLDER "xCall" */
PROC xCall(xreturncode,xexception)

  /* function failed? */
  IF xreturncode=NIL

    /* raise exception */
    Raise(xexception)

  ENDIF

ENDPROC xreturncode
/* FEND */
