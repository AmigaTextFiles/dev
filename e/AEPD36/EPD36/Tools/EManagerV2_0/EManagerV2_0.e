/*********************************************************

               EManager V2.0 - Quelltext

                 leider undokumentiert

*********************************************************/

OPT OSVERSION=39

MODULE 'gadtools',
       'libraries/gadtools',
       'intuition/intuition',
       'intuition/screens',
       'intuition/gadgetclass',
       'graphics/text',
       'gtx',
       'gadtoolsbox/hotkey',
       'reqtools',
       'libraries/reqtools',
       'exec/lists',
       'exec/nodes',
       'exec/memory',
       'dos/dostags',
       'dos/dos',
       '*dev/exec_lists'

ENUM NONE,
     NOCONTEXT,
     NOGADGET,
     NOWB,
     NOVISUAL,
     OPENGT,
     NOWINDOW,
     NOMEM,
     NODRW,
     OPENREQ,
     OPENGTX

ENUM MAIN_EDIT=1,
     MAIN_COMPILE,
     MAIN_RUN,
     MAIN_SETUP,
     MAIN_TOOLS,
     MAIN_PREFS,
     MAIN_SOURCE,
     MAIN_INFO,
     MAIN_EXIT

ENUM SETUP_OPT_REG=1,
     SETUP_OPT_LARGE,
     SETUP_OPT_SYM,
     SETUP_OPT_ASM,
     SETUP_OPT_IGNORECACHE,
     SETUP_OPT_LINEDEBUG,
     SETUP_OPT_DEBUG,
     SETUP_OPT_OPTI,
     SETUP_REGS,
     SETUP_FILETYPE,
     SETUP_SELECT,
     SETUP_FILE,
     SETUP_SAVE,
     SETUP_USE,
     SETUP_CANCEL

ENUM PREFS_DATA = 1,
     PREFS_SELECT,
     PREFS_FILE,
     PREFS_ASYNCH,
     PREFS_SAVE,
     PREFS_USE,
     PREFS_CANCEL

ENUM TOOLS_LIST=1,
     TOOLS_ADD,
     TOOLS_REMOVE,
     TOOLS_SAVE,
     TOOLS_STRING,
     TOOLS_SELECT,
     TOOLS_RUN,
     TOOLS_ACTION,
     TOOLS_DOIT,
     TOOLS_EXIT


CONST OPT_EMPTY               = NIL,

      OPT_DISPLAY             = %000000001,
      SET_DISPLAY             = %011111001,

      OPT_SHELL               = %000000010,
      SET_SHELL               = %111111010,

      OPT_WB                  = %000000100,
      SET_WB                  = %010000100,

      OPT_SRC                 = %000001000,
      SET_SRC                 = %111001011,

      OPT_REQ                 = %000010000,
      SET_REQ                 = %111110011,

      OPT_PAT                 = %000100000,
      SET_PAT                 = %111110011,

      OPT_DSX                 = %001000000,
      SET_DSX                 = %111111011,

      OPT_INPUT               = %010000000,
      SET_INPUT               = %110000011,

      OPT_QUIET               = %100000000,
      SET_QUIET               = %111111010

OBJECT setupdata
  editor:LONG,
  compiler:LONG,
  source:LONG,
  options:LONG,
  regs:LONG
ENDOBJECT

OBJECT toolsdata
  progs:PTR TO lh
ENDOBJECT

OBJECT prefsdata
  displayfile:LONG,
  displayflag:LONG,
  toolsfile:LONG,
  setupfile:LONG,
  tmpfile:LONG,
  asynch:LONG
ENDOBJECT

DEF   main_wnd:PTR TO window,
      main_glist,
      main_handle,

      setup_wnd:PTR TO window,
      setup_glist,
      setup_handle,
      setup_slider,

      tools_wnd:PTR TO window,
      tools_glist,
      tools_handle,
      tools_listview:PTR TO gadget,

      prefs_wnd:PTR TO window,
      prefs_glist,
      prefs_handle,

      infos:PTR TO gadget,
      scr:PTR TO screen,
      visual=NIL,
      tattr:PTR TO textattr,
      font:PTR TO textfont,
      xsize,ysize,
      di:PTR TO drawinfo

PROC setupscreen()
/****************************************************************************
  Funktion: Öffnen der Libraries, Initialisierungen, ...
       Ein: nichts
       Aus: NULL für O.K: oder Fehlernummer
BENUTZT
    Intern: tattr, reqtoolsbase, gadtoolsbase, gtxbase, scr, visual, di,
            font, xsize, ysize
    Extern: nichts
****************************************************************************/

  IF (tattr:=New( SIZEOF textattr ))=NIL THEN RETURN NOMEM
  IF (reqtoolsbase:=OpenLibrary('reqtools.library',0))=NIL THEN RETURN OPENREQ
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN OPENGT
  IF (gtxbase:=OpenLibrary('gadtoolsbox.library',0))=NIL THEN RETURN OPENGTX
  IF (scr:=LockPubScreen('Workbench'))=NIL THEN RETURN NOWB
  IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN RETURN NOVISUAL
  IF (di:=GetScreenDrawInfo(scr))=NIL THEN RETURN NODRW
  font := di.font
  xsize := font.xsize
  AskFont(scr.rastport,tattr)
  ysize:=tattr.ysize
ENDPROC

PROC closedownscreen()
/****************************************************************************
  Funktion: stellt den vorherigen Zustand wieder her
       Ein: nichts
       Aus: nichts
BENUTZT
    Intern: di, visual, scr, gtxbase, gadtoolsbase, reqtoolsbase, tattr
    Extern: nichts
***************************************************************************/

  IF di THEN FreeScreenDrawInfo(scr,di)
  IF visual THEN FreeVisualInfo(visual)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF gtxbase THEN CloseLibrary(gtxbase)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
  IF tattr THEN Dispose( tattr )
ENDPROC

PROC getWinTags( leftedge, topedge, width, height, glist, title )
/***************************************************************************
  Funktion: belegt das TagItemArray für OpenWindowTagList()
       Ein: Koordinaten linke obere Ecke (2), Breite, Höhe, Gadgetliste,
            Titel
       Aus: das TagItemArray
BENUTZT
    Intern: scr
    Extern: nichts
***************************************************************************/
  DEF tags

  tags := [WA_LEFT,leftedge,
           WA_TOP,topedge,
           WA_WIDTH,width,
           WA_HEIGHT,height,
           WA_IDCMP,
              IDCMP_REFRESHWINDOW+
              IDCMP_GADGETUP+
              IDCMP_GADGETDOWN+
              IDCMP_CLOSEWINDOW+
              ->IDCMP_INTUITICKS+
              IDCMP_RAWKEY,
           WA_FLAGS,$100E,
           WA_TITLE,title,
           WA_CUSTOMSCREEN,scr,
           WA_AUTOADJUST,1,
           WA_AUTOADJUST,1,
           WA_GADGETS,glist,
           NIL]:LONG
ENDPROC tags


PROC openmain_window()
/***************************************************************************
  Funktion: öffnet das Hauptfenster
       Ein: nichts
       Aus: NULL oder Fehlernummer
BENUTZT
    Intern:
    Extern:
***************************************************************************/
  DEF g:PTR TO gadget,
       x,  y,
      bx, by,
      ww, wh,
      buf[30]:STRING

  x := xsize*2
  y := ysize*3
  bx := 19*xsize
  by := /*ysize+(ysize/2)*/ 2*ysize
  ww := (2*x)+(2*bx)+xsize
  wh := y+(5*by)+(3*ysize)+by

  IF ( main_handle := GtX_GetHandleA( getGTXTags( )
                                      ) ) = NIL THEN RETURN NOCONTEXT

  IF ( g := CreateContext( {main_glist} ) ) = NIL THEN RETURN NOCONTEXT
  IF ( g := GtX_CreateGadgetA( main_handle, BUTTON_KIND, g,
    [x,y,bx,by,
     '_editieren',tattr,MAIN_EDIT,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( main_handle, BUTTON_KIND, g,
    [x,y+by+(ysize/3),bx,by,
     '_compilieren',tattr,MAIN_COMPILE,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( main_handle, BUTTON_KIND, g,
    [x,y+(2*by)+(2*ysize/3),bx,by,
     's_tarten',tattr,MAIN_RUN,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( main_handle, BUTTON_KIND, g,
    [x+bx+xsize,y,bx,by,'Ei_nstellungen',tattr,MAIN_SETUP,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( main_handle, BUTTON_KIND, g,
    [x+bx+xsize,y+by+(ysize/3),bx,by,
     '_Voreinstellungen',tattr,MAIN_PREFS,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( main_handle, BUTTON_KIND, g,
    [x+bx+xsize,y+(2*by)+(2*ysize/3),bx,by,
     '_Hilfsmittel',tattr,MAIN_TOOLS,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( main_handle, TEXT_KIND, g,
    [x,y+(4*by)+(4*ysize/3),(2*bx)+xsize,by,
     'Quelltext',tattr,MAIN_SOURCE,4,visual,0]:newgadget,
    [GTTX_BORDER,1,
     GTTX_TEXT,buf,
     GTTX_JUSTIFICATION,GTJ_CENTER,
     GTTX_COPYTEXT,TRUE,
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( main_handle, BUTTON_KIND, g,
    [x-xsize,y+(5*by)+(7*ysize/3),bx,by,
     '_Info',tattr,MAIN_INFO,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( main_handle, BUTTON_KIND, g,
    [x+bx+(2*xsize),y+(5*by)+(7*ysize/3),bx,by,
     '_beenden',tattr,MAIN_EXIT,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( main_wnd := OpenWindowTagList( NIL,
       getWinTags( 0, scr.barheight+1, ww, wh, main_glist, 'EManager' )
     ) ) = NIL THEN RETURN NOWINDOW
  DrawBevelBoxA( main_wnd.rport,
     x-xsize, y-(ysize/2), (2*bx)+(3*xsize), (5*by)+(7*ysize/3),
    [GT_VISUALINFO,visual,
     GTBB_RECESSED,1,
     GTBB_FRAMETYPE,BBFT_RIDGE,
     NIL] )
  GtX_RefreshWindow( main_handle, main_wnd, NIL )
ENDPROC

PROC closemain_window()
/*************************************************
  Schließt Hauptfenster
*************************************************/
  IF main_wnd THEN CloseWindow(main_wnd)
  IF main_glist THEN FreeGadgets(main_glist)
  IF main_handle THEN GtX_FreeHandle( main_handle )
ENDPROC

PROC wait4message( handle, win:PTR TO window )
  DEF type,
      mes:PTR TO intuimessage

  REPEAT
    type := 0
    IF mes := GtX_GetIMsg( handle, win.userport )
      type := mes.class
      IF ( type = IDCMP_GADGETDOWN ) OR ( type = IDCMP_GADGETUP )
        infos := mes.iaddress
      ELSEIF type = IDCMP_REFRESHWINDOW
        GtX_BeginRefresh( handle )
        GtX_EndRefresh( handle,TRUE)
        type := 0
      ENDIF
      GtX_ReplyIMsg( handle, mes )
    ELSE
      WaitPort( win.userport )
    ENDIF
  UNTIL type
ENDPROC type

PROC reporterr(er)
  DEF erlist:PTR TO LONG
  IF er
    erlist:=['get context',
             'create gadget',
             'lock wb',
             'get visual infos',
             'open "gadtools.library" v37+',
             'open window',
             'alloc memory',
             'get drawinfo',
             'open reqtools.library v38+',
             'open gadtoolsbox.library v39+'
            ]
    EasyRequestArgs(0,[20,0,0,'Could not \s!','ok'],0,[erlist[er-1]])
  ENDIF
ENDPROC er

PROC main()
  DEF m,
      gad,
      fl=FALSE,
      set:PTR TO setupdata,
      td:PTR TO toolsdata,
      dummy:PTR TO CHAR,
      winlock,
      pref:PTR TO prefsdata

  pref := loadPrefs( )
  IF set := loadSetup( pref )
    td := loadTools( NIL, pref )
    IF reporterr(setupscreen())=0
      IF reporterr(openmain_window())=0
        dummy := FilePart( set.source )
        GtX_SetGadgetAttrsA( main_handle,
                             findGadget( main_wnd, MAIN_SOURCE ),
                             [GTTX_TEXT,dummy,NIL] )
        REPEAT
          m := wait4message( main_handle, main_wnd )
          IF m = IDCMP_GADGETUP
            gad := infos.gadgetid
            winlock := RtLockWindow( main_wnd )
            SELECT gad
              CASE MAIN_EXIT
                fl := TRUE
              CASE MAIN_EDIT
                edit( set )
              CASE MAIN_COMPILE
                compile( set )
              CASE MAIN_SETUP
                setup( set, pref )
                dummy := FilePart( set.source )
                GtX_SetGadgetAttrsA( main_handle,
                                     findGadget( main_wnd, MAIN_SOURCE ),
                                     [GTTX_TEXT,dummy,NIL] )
              CASE MAIN_RUN
                run( set, main_wnd )
              CASE MAIN_TOOLS
                tools( td, set, pref )
              CASE MAIN_PREFS
                prefs( pref )
              CASE MAIN_INFO
                info( set )
            ENDSELECT
            RtUnlockWindow( main_wnd, winlock )
          ELSEIF m = IDCMP_CLOSEWINDOW
            fl := TRUE
          ENDIF
        UNTIL fl
      ENDIF
      closemain_window()
    ENDIF
    closedownscreen()
    freeSetup( set )
  ENDIF
ENDPROC

PROC opensetup_window()
  DEF g:PTR TO gadget,
       x,  y,
      bx, by,
      ww, wh,
      dy

  x := xsize*2
  y := 7*ysize/2
  bx := xsize*15
  by := /*ysize+(ysize/2)*/ 2*ysize
  ww := (2*x)+(3*bx)+1+(3*xsize)+1
  dy := (by/2)
  wh := y+(4*dy)+(3*by)+(5*ysize/2)

  IF ( setup_handle := GtX_GetHandleA( getGTXTags( )
                                       ) ) = NIL THEN RETURN NOCONTEXT
  IF ( g := CreateContext( {setup_glist} ) ) = NIL THEN RETURN NOCONTEXT
  IF ( g := GtX_CreateGadgetA( setup_handle, CHECKBOX_KIND, g,
    [x+bx,y+dy+by+(2*ysize),(3*xsize),by/2,
     '_Register',tattr,SETUP_OPT_REG,1,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     GTCB_SCALED,TRUE,
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( setup_handle, CHECKBOX_KIND, g,
    [x+bx+(bx/2),y+dy+by+(2*ysize),(3*xsize),by/2,
     '_Large',tattr, SETUP_OPT_LARGE,2,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     GTCB_SCALED,TRUE,
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( setup_handle, CHECKBOX_KIND, g,
    [x+bx,y+(2*dy)+by+(2*ysize)+1,(3*xsize),by/2,
     'S_ymbolhunk',tattr,SETUP_OPT_SYM,1,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     GTCB_SCALED,TRUE,
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( setup_handle, CHECKBOX_KIND, g,
    [x+bx+(bx/2),y+(2*dy)+by+(2*ysize)+1,(3*xsize),by/2,
     'Asse_mbler',tattr,SETUP_OPT_ASM,2,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     GTCB_SCALED,TRUE,
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( setup_handle, CHECKBOX_KIND, g,
    [x+bx,y+(3*dy)+by+(2*ysize)+2,(3*xsize),by/2,
     '_Ignorecache',tattr,SETUP_OPT_IGNORECACHE,1,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     GTCB_SCALED,TRUE,
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( setup_handle, CHECKBOX_KIND, g,
    [x+bx+(bx/2),y+(3*dy)+by+(2*ysize)+2,(3*xsize),by/2,
     'Linedeb_ug',tattr,SETUP_OPT_LINEDEBUG,2,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     GTCB_SCALED,TRUE,
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( setup_handle, CHECKBOX_KIND, g,
    [x+bx,y+(4*dy)+by+(2*ysize)+3,(3*xsize),by/2,
     'D_ebug',tattr,SETUP_OPT_DEBUG,1,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     GTCB_SCALED,TRUE,
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( setup_handle, CHECKBOX_KIND, g,
    [x+bx+(bx/2),y+(4*dy)+by+(2*ysize)+3,(3*xsize),by/2,
     '_Optimieren',tattr,SETUP_OPT_OPTI,2,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     GTCB_SCALED,TRUE,
     NIL]))=NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( setup_handle, SLIDER_KIND, g,
    [x+(2*bx)+(2*bx/3),y+(2*by),(2*xsize),(2*by),
     'Re_gister',tattr,SETUP_REGS,4,visual,0]:newgadget,
    [PGA_FREEDOM,2,
     GTSL_MAX,5,
     GTSL_LEVEL,3,
     GTSL_LEVELFORMAT,'%ld',
     GTSL_MAXLEVELLEN,5,
     GTSL_LEVELPLACE,8,
     GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  setup_slider := g
  IF ( g := GtX_CreateGadgetA( setup_handle, CYCLE_KIND, g,
    [x,y,bx,by,
     'Da_teiart',tattr,SETUP_FILETYPE,4,visual,0]:newgadget,
    [GTCY_LABELS,['Quelltext','Compiler','Editor',0],
     GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( setup_handle, BUTTON_KIND, g,
    [(x+bx+1),y,(3*xsize),by,'_?',tattr,SETUP_SELECT,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA(setup_handle, STRING_KIND, g,
    [x+bx+1+(3*xsize)+1,y,(2*bx),by,
     '_Datei',tattr,SETUP_FILE,4,visual,0]:newgadget,
    [$80030024,0,
     GTST_MAXCHARS,90,
     GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( setup_handle, BUTTON_KIND, g,
    [x,y+(4*dy)+(2*by)+(2*ysize),bx,by,
     '_Sichern',tattr,SETUP_SAVE,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( setup_handle, BUTTON_KIND, g,
    [(ww/2)-(bx/2),y+(4*dy)+(2*by)+(2*ysize),bx,by,
     '_Benutzen',tattr,SETUP_USE,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( setup_handle, BUTTON_KIND, g,
    [ww-x-bx,y+(4*dy)+(2*by)+(2*ysize),bx,by,
     '_Abbruch',tattr,SETUP_CANCEL,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF (setup_wnd:=OpenWindowTagList(NIL,
      getWinTags( main_wnd.leftedge, main_wnd.topedge, ww, wh,
      setup_glist, 'EManager Einstellungen' )
     ) ) = NIL THEN RETURN NOWINDOW
  PrintIText(setup_wnd.rport,
    [2,0,0,x+(2*xsize),y+by+(ysize/2),tattr,
     'Compileroptionen',NIL]:intuitext,0,0)
  DrawBevelBoxA(setup_wnd.rport,x,y+by,ww-(2*x),(4*dy)+by+(3*ysize/2)+2,
    [GT_VISUALINFO,visual,NIL])
  GtX_RefreshWindow( setup_handle, setup_wnd, NIL )
ENDPROC

PROC closesetup_window()
  IF setup_wnd THEN CloseWindow(setup_wnd)
  IF setup_glist THEN FreeGadgets(setup_glist)
  IF setup_handle THEN GtX_FreeHandle( setup_handle )
ENDPROC

PROC findGadget( win:PTR TO window, index )
  DEF g:PTR TO gadget,
      fl=FALSE,
      rg=NIL:PTR TO gadget

  g := win.firstgadget
  REPEAT
    IF ( g.gadgetid = index )
      fl := TRUE
      rg := g
    ENDIF
    g := g.nextgadget
    IF g = NIL THEN fl := TRUE
  UNTIL fl
ENDPROC rg

PROC loadSetup( pref:PTR TO prefsdata )
  DEF set:PTR TO setupdata,
      handle,
      buf[90]:STRING,
      dummy

  IF set := New( SIZEOF setupdata )
    set.editor := String( 90 )
    set.compiler := String( 90 )
    set.source := String( 90 )
    IF handle := Open( pref.setupfile, OLDFILE )
      Fgets( handle, buf, 90 )
      StrCopy( set.editor, buf, StrLen(buf)-1  )
      Fgets( handle, buf, 90 )
      StrCopy( set.compiler, buf, StrLen(buf)-1 )
      Fgets( handle, buf, 90 )
      StrCopy( set.source, buf, StrLen(buf)-1 )
      dummy := FgetC( handle )
      set.options := dummy
      dummy := FgetC( handle )
      set.regs := dummy
      Close( handle )
    ENDIF
  ENDIF
ENDPROC set

PROC loadPrefs( )
  DEF pref:PTR TO prefsdata,
      handle,
      buf[256]:STRING

  IF pref := New( SIZEOF prefsdata )
    pref.displayfile := String( 256 )
    pref.toolsfile := String( 256 )
    pref.setupfile := String( 256 )
    pref.tmpfile := String( 256 )
    IF handle := Open( 'ENVARC:EManager.prefs', OLDFILE )
      Fgets( handle, buf, 256 )
      StrCopy( pref.displayfile, buf, StrLen(buf)-1 )
      pref.displayflag := FgetC( handle )
      Fgets( handle, buf, 256 )
      StrCopy( pref.toolsfile, buf, StrLen(buf)-1 )
      pref.asynch := FgetC( handle )
      Fgets( handle, buf, 256 )
      StrCopy( pref.setupfile, buf, StrLen(buf)-1 )
      Fgets( handle, buf, 256 )
      StrCopy( pref.tmpfile, buf, StrLen(buf)-1 )
      Close( handle )
    ENDIF
  ENDIF
ENDPROC pref

PROC savePrefs( pref:PTR TO prefsdata )
  DEF handle,
      buf[256]:STRING

  IF handle := Open( 'ENVARC:EManager.prefs', NEWFILE )
    StringF( buf, '\s\n', pref.displayfile )
    Fputs( handle, buf )
    FputC( handle, pref.displayflag )
    StringF( buf, '\s\n', pref.toolsfile )
    Fputs( handle, buf )
    FputC( handle, pref.asynch )
    StringF( buf, '\s\n', pref.setupfile )
    Fputs( handle, buf )
    StringF( buf, '\s\n', pref.tmpfile )
    Fputs( handle, buf )
    Close( handle )
  ENDIF
ENDPROC

PROC saveSetup( set:PTR TO setupdata, pref:PTR TO prefsdata )
  DEF handle

  IF handle := Open( pref.setupfile, NEWFILE )
    Fputs( handle, set.editor )
    FputC( handle, $0A )
    Fputs( handle, set.compiler )
    FputC( handle, $0A )
    Fputs( handle, set.source )
    FputC( handle, $0A )
    FputC( handle, set.options )
    FputC( handle, set.regs )
    Close( handle )
  ENDIF
ENDPROC

PROC freeSetup( set:PTR TO setupdata )

  SetStr( set.editor, 0 )
  SetStr( set.compiler, 0 )
  SetStr( set.source, 0 )
  Dispose( set )
ENDPROC

PROC setCheckBoxes( flags, handle, wnd:PTR TO window, from, to )
  DEF cnt,
      val

  FOR cnt := to TO from STEP -1
    MOVE.L flags,D0
    ANDI.L #$00000001,D0
    MOVE.L D0,val
    GtX_SetGadgetAttrsA( handle,
                         findGadget( wnd, cnt ),
                         [GTCB_CHECKED,val,NIL] )
    MOVE.L flags,D0
    LSR.L #1,D0
    MOVE.L D0,flags
  ENDFOR
ENDPROC

PROC getCheckBoxes( wnd:PTR TO window, from, to )
  DEF cnt,
      val,
      flags=0

  FOR cnt := from TO to
    Gt_GetGadgetAttrsA( findGadget( wnd, cnt ),
                        wnd,
                        NIL,
                        [GTCB_CHECKED,{val},NIL] )
    MOVE.L val,D1
    ANDI.L #$00000001,D1
    MOVE.L flags,D0
    ASL.L #1,D0
    OR.L D1,D0
    MOVE.L D0,flags
  ENDFOR
ENDPROC flags

PROC edit( set:PTR TO setupdata )
  DEF buf[256]:STRING,
      dir[256]:STRING, dummy, lock, oldlock

  StrCopy( buf, set.editor, ALL )
  IF ( dummy := InStr( buf, ' ', 0 ) ) <> -1 THEN StrCopy( buf, buf, dummy )
  dummy := PathPart( buf )
  StrCopy( dir, buf, dummy-buf )
  IF lock := Lock( dir, -2 )
    oldlock := CurrentDir( lock )
    StrCopy( buf, set.editor, ALL )
    StrAdd( buf, ' ', 1 )
    StrAdd( buf, set.source, ALL )
    SetStr( buf, StrLen( buf ) )
    SystemTagList( buf, NIL )
    lock := CurrentDir( oldlock )
    UnLock( lock )
  ENDIF
ENDPROC

PROC compile( set:PTR TO setupdata )
/**************************************************************
  Funktion: startet den Compiler
       Ein: Zeiger auf "setupdata"-Struktur
       Aus: nichts
BENUTZT
    Intern: nichts
    Extern: eigenes Ausgabefenster "CON:"
**************************************************************/
  DEF buf[1024]:STRING,
      dir[256]:STRING, dummy, lock, oldlock

  StrCopy( buf, set.compiler, ALL )
  dummy := PathPart( buf )
  StrCopy( dir, buf, dummy-buf )
  IF lock := Lock( dir, -2 )
    oldlock := CurrentDir( lock )
    StringF( buf, '\s >CON:\d/\d/\d/\d/Compiler-Output/CLOSE \s', set.compiler,
                                                            main_wnd.leftedge,
                                                            main_wnd.topedge,
                                                            main_wnd.width,
                                                            main_wnd.height,
                                                            set.source )
    StrAdd( buf, generateOptions( set.options, set.regs ), ALL )
    StrAdd( buf, 'HOLD', 4 )
    SystemTagList( buf, NIL )
    lock := CurrentDir( oldlock )
    UnLock( lock )
  ENDIF
ENDPROC

PROC run( set:PTR TO setupdata, wnd:PTR TO window )
  DEF para[256]:STRING,
      buf[2048]:STRING,
      dat[256]:STRING,
      sel,
      dir[256]:STRING,
      lock, oldlock, dummy

  StrCopy( buf, 'Bitte wählen Sie zwischen\n'+
                'Shell- oder Workbenchstart und\n'+
                'geben Sie ggf. die Shellparameter an!\n' )
  IF sel := RtGetStringA( para, 256, 'Bitte Parameter eingeben', NIL,
               [RT_REQPOS,REQPOS_CENTERWIN,
                RT_UNDERSCORE,"_",
                RT_TEXTATTR,tattr,
                RT_WINDOW,wnd,
                RT_LOCKWINDOW,TRUE,
                RTGS_ALLOWEMPTY,TRUE,
                RTGS_GADFMT,'_Shell|_Workbench|_Abbruch',
                RTGS_TEXTFMT, buf,
                RTGS_FLAGS,GSREQF_CENTERTEXT,
                RTGS_BACKFILL,TRUE,
                NIL] )
    StrCopy( buf, set.source, StrLen(set.source)-2 )
    dummy := PathPart( buf )
    StrCopy( dir, buf, dummy-buf )
    IF lock := Lock( dir, -2 )
      oldlock := CurrentDir( lock )

      IF sel = 1
        StringF( dat, ' >CON:\d/\d/\d/\d/Programmausgabe/WAIT/CLOSE ',
                      wnd.leftedge, wnd.topedge,
                      wnd.width, wnd.height )
        SetStr( dat, StrLen( dat ) )
        StrAdd( buf, dat, ALL )
        StrAdd( buf, para, ALL )
      ENDIF
      SetStr( buf, StrLen( buf ) )
      SystemTagList( buf, NIL )
      lock := CurrentDir( oldlock )
      UnLock( lock )
    ENDIF
  ENDIF
ENDPROC


PROC generateOptions( opts:LONG, regs )
/**************************************************************
  Funktion: extrahiert aus den Einstellungen den Parameter-
            string für den Compiler
       Ein: die Optionen und die Registerzahl aus setupdata-Struktur
       Aus: Optionsstring
BENUTZT
    Intern: nichts
    Extern: nichts
**************************************************************/

  DEF buf[256]:STRING,
      buf2[10]:STRING

  StrCopy( buf, ' ', 1 )
  IF ( opts AND 1 )
    StrAdd( buf, 'OPTI ', 5 )
  ENDIF
  IF ( opts AND 2 )
    StrAdd( buf, 'DEBUG ', 6 )
  ENDIF
  IF ( opts AND 4 )
    StrAdd( buf, 'LINEDEBUG ', 10 )
  ENDIF
  IF ( opts AND 8 )
    StrAdd( buf, 'IGNORECACHE ', 12 )
  ENDIF
  IF ( opts AND 16 )
    StrAdd( buf, 'ASM ', 4 )
  ENDIF
  IF ( opts AND 32 )
    StrAdd( buf, 'SYM ', 4 )
  ENDIF
  IF ( opts AND 64 )
    StrAdd( buf, 'LARGE ', 6 )
  ENDIF
  IF ( opts AND 128 )
    StringF( buf2, 'REG=\d ', regs )
    StrAdd( buf, buf2, 6 )
  ENDIF
  SetStr( buf, StrLen( buf ) )
ENDPROC  buf

PROC setup( set:PTR TO setupdata, pref:PTR TO prefsdata )
/**************************************************************
  Funktion: öffnet das Einstellungsfenster und bearbeitet die
            Eingaben
       Ein: Zeiger auf initialisierte (und ggf. belegte)
            "setupdata"-Struktur
       Aus: nichts (ggf. Änderung des setupdata-Inhalts)
BENUTZT
    Intern: setup_wnd, setup_handle, setup_glist, setup_slider
    Extern: Zugriff und ggf. Veränderung der Datei
            "ENVARC:EManager.setup"
**************************************************************/

  DEF m,
      gad,
      fl=FALSE,
      sptr:PTR TO setupdata,
      dummy,
      num,
      buf[108]:STRING,
      req:PTR TO rtfilerequester

  IF sptr := New( SIZEOF setupdata )
    sptr.editor := String( 90 )
    sptr.source := String( 90 )
    sptr.compiler := String( 90 )
    StrCopy( sptr.editor, set.editor, ALL )
    StrCopy( sptr.compiler, set.compiler, ALL )
    StrCopy( sptr.source, set.source, ALL )
    IF req := RtAllocRequestA( RT_FILEREQ, NIL )
      IF reporterr( opensetup_window( ) ) = 0
        StrCopy( buf, sptr.source, ALL )
        GtX_SetGadgetAttrsA( setup_handle,
                                     findGadget( setup_wnd, SETUP_FILE ),
                                     [GTST_STRING,buf,NIL] )
        setCheckBoxes( set.options,
                       setup_handle,
                       setup_wnd,
                       SETUP_OPT_REG,
                       SETUP_OPT_OPTI )
        GtX_SetGadgetAttrsA( setup_handle,
                                     setup_slider,
                                     [GTSL_LEVEL,set.regs,NIL] )
        REPEAT
          m := wait4message( setup_handle, setup_wnd )
          IF m = IDCMP_GADGETUP
            gad := infos.gadgetid
            SELECT gad
              CASE SETUP_CANCEL
                fl := TRUE
              CASE SETUP_FILETYPE
                Gt_GetGadgetAttrsA( findGadget( setup_wnd, SETUP_FILETYPE ),
                                    main_wnd, NIL,
                                    [GTCY_ACTIVE,{num},NIL] )
                SELECT num
                  CASE 0
                    StrCopy( buf, sptr.source, ALL )
                  CASE 1
                    StrCopy( buf, sptr.compiler, ALL )
                  CASE 2
                    StrCopy( buf, sptr.editor, ALL )
                ENDSELECT
                GtX_SetGadgetAttrsA( setup_handle,
                                     findGadget( setup_wnd, SETUP_FILE ),
                                     [GTST_STRING,buf,NIL] )
              CASE SETUP_FILE
                Gt_GetGadgetAttrsA( findGadget( setup_wnd, SETUP_FILETYPE ),
                                    main_wnd, NIL,
                                    [GTCY_ACTIVE,{num},NIL] )
                Gt_GetGadgetAttrsA( findGadget( setup_wnd, SETUP_FILE ),
                                    main_wnd, NIL,
                                    [GTST_STRING,{dummy},NIL] )
                SELECT num
                  CASE 0
                    StrCopy( sptr.source, dummy, ALL )
                  CASE 1
                    StrCopy( sptr.compiler, dummy, ALL )
                  CASE 2
                    StrCopy( sptr.editor, dummy, ALL )
                ENDSELECT
              CASE SETUP_SELECT
                Gt_GetGadgetAttrsA( findGadget( setup_wnd, SETUP_FILETYPE ),
                                    main_wnd, NIL,
                                    [GTCY_ACTIVE,{num},NIL] )
                IF num
                  RtChangeReqAttrA( req, [RTFI_MATCHPAT,'#?',NIL] )
                ELSE
                  RtChangeReqAttrA( req, [RTFI_MATCHPAT,'#?.e',NIL] )
                ENDIF
                buf[] := 0
                IF RtFileRequestA( req, buf, 'Bitte Datei wählen!',
                                  [RT_WINDOW,setup_wnd,
                                   RT_REQPOS,REQPOS_CENTERWIN,
                                   RT_LOCKWINDOW,TRUE,
                                   RTFI_FLAGS,FREQF_PATGAD,
                                   RTFI_HEIGHT,setup_wnd.height,
                                   NIL] )
                  SELECT num
                    CASE 0
                      StrCopy( sptr.source, req.dir, ALL )
                      AddPart( sptr.source, buf, 90 )
                      StrCopy( buf, sptr.source, ALL )
                    CASE 1
                      StrCopy( sptr.compiler, req.dir, ALL )
                      AddPart( sptr.compiler, buf, 90 )
                      StrCopy( buf, sptr.compiler, ALL )
                    CASE 2
                      StrCopy( sptr.editor, req.dir, ALL )
                      AddPart( sptr.editor, buf, 90 )
                      StrCopy( buf, sptr.editor, ALL )
                  ENDSELECT
                  GtX_SetGadgetAttrsA( setup_handle,
                                       findGadget( setup_wnd, SETUP_FILE ),
                                       [GTST_STRING,buf,NIL] )
                ENDIF
              CASE SETUP_USE
                StrCopy( set.editor, sptr.editor, ALL )
                StrCopy( set.compiler, sptr.compiler, ALL )
                StrCopy( set.source, sptr.source, ALL )
                set.options := getCheckBoxes( setup_wnd,
                                              SETUP_OPT_REG,
                                              SETUP_OPT_OPTI )
                Gt_GetGadgetAttrsA( setup_slider,
                                    setup_wnd,
                                    NIL,
                                    [GTSL_LEVEL,{num},NIL] )
                set.regs := num
                fl := TRUE
              CASE SETUP_SAVE
                StrCopy( set.editor, sptr.editor, ALL )
                StrCopy( set.compiler, sptr.compiler, ALL )
                StrCopy( set.source, sptr.source, ALL )
                set.options := getCheckBoxes( setup_wnd,
                                              SETUP_OPT_REG,
                                              SETUP_OPT_OPTI )
                Gt_GetGadgetAttrsA( setup_slider,
                                    setup_wnd,
                                    NIL,
                                    [GTSL_LEVEL,{num},NIL] )
                set.regs := num
                saveSetup( set, pref )
                fl := TRUE
            ENDSELECT
          ELSEIF m = IDCMP_CLOSEWINDOW
            fl := TRUE
          ENDIF
        UNTIL fl
      ENDIF
      RtFreeRequest( req )
    ENDIF
    closesetup_window( )
    Dispose( sptr )
  ENDIF
ENDPROC

PROC opentools_window()
  DEF g:PTR TO gadget,
       x,  y,
      bx, by,
      ww, wh,
      dummy:PTR TO gadget

  x := (2*xsize)
  y := (4*ysize)
  bx := (25*xsize)
  by := /*ysize+(ysize/2)*/ 2*ysize
  ww := (2*x)+(48*xsize)
  wh := 0

  IF ( tools_handle := GtX_GetHandleA( getGTXTags( )
                                       ) ) = NIL THEN RETURN NOCONTEXT

  IF ( g := CreateContext( {tools_glist} ) ) = NIL THEN RETURN NOCONTEXT
  IF ( g := GtX_CreateGadgetA( tools_handle, LISTVIEW_KIND, g,
    [x,y,(48*xsize),(6*ysize),
     'externe _Programme',tattr,TOOLS_LIST,36,visual,0]:newgadget,
    [GTLV_LABELS,NIL,
     GT_UNDERSCORE,"_",
     GTLV_SHOWSELECTED,0,
     NIL] ) ) = NIL THEN RETURN NOGADGET
  tools_listview := g
  wh := y+(tools_listview.height)+(5*by)+(ysize/2)
  IF ( g := GtX_CreateGadgetA( tools_handle, BUTTON_KIND, g,
    [x,y+(tools_listview.height)+by+(ysize/2) /*y+(9*ysize)*/,(12*xsize),by,
     '_hinzufügen',tattr,TOOLS_ADD,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL]))=NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( tools_handle, BUTTON_KIND, g,
    [x+(xsize*12),y+(tools_listview.height)+by+(ysize/2) /*y+(9*ysize)*/,
     (xsize*12),by,
     '_entfernen',tattr,TOOLS_REMOVE,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( tools_handle, BUTTON_KIND, g,
    [x+(xsize*24),y+(tools_listview.height)+by+(ysize/2) /*y+(9*ysize)*/,
     (xsize*12),by,
     '_sichern',tattr,TOOLS_SAVE,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( tools_handle, STRING_KIND, g,
    [x+(9*xsize), (y+(tools_listview.height)) /*y+(7*ysize)*/,
     (36*xsize),by,
     'a_ktuell',tattr,TOOLS_STRING,1,visual,0]:newgadget,
    [$80030024,0,
     GTST_MAXCHARS,256,
     GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( tools_handle, BUTTON_KIND, g,
    [x+(45*xsize),y+(tools_listview.height) /*y+(7*ysize)*/,
     (3*xsize),by,
     '_?',tattr,TOOLS_SELECT,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( tools_handle, BUTTON_KIND, g,
    [x+(36*xsize),y+(tools_listview.height)+by+(ysize/2) /*y+(9*ysize)*/,
     (12*xsize),by,
     's_tarten',tattr,TOOLS_RUN,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( tools_handle, CYCLE_KIND, g,
    [x+(10*xsize),y+(tools_listview.height)+(2*by)+(3*ysize/2),bx,by,
     '_Aktion',tattr,TOOLS_ACTION,1,visual,0]:newgadget,
    [GTCY_LABELS,['Datei löschen','Datei umbenennen','Verzeichnis anlegen',0],
     GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  dummy := g
  IF ( g := GtX_CreateGadgetA( tools_handle, BUTTON_KIND, g,
    [x+(10*xsize)+bx,y+(tools_listview.height)+(2*by)+(3*ysize/2),
     ww-bx-(10*xsize)-(2*x),by,
     'Sta_rt',tattr,TOOLS_DOIT,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( tools_handle, BUTTON_KIND, g,
    [(ww/2)-(bx/4),y+(tools_listview.height)+(4*by),
      (bx/2),by,
     '_zurück',tattr,TOOLS_EXIT,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( tools_wnd := OpenWindowTagList( NIL,
      getWinTags( main_wnd.leftedge, main_wnd.topedge, ww, wh,
      tools_glist, 'EManager Hilfsmittel' ) ) ) = NIL THEN RETURN NOWINDOW
  DrawBevelBoxA( tools_wnd.rport, tools_listview.leftedge-xsize,
                                  y-by,
                                  tools_listview.width+(2*xsize),
                                 (tools_listview.height)+(3*by)+(3*ysize/4)+1,
    [GT_VISUALINFO,visual,
     GTBB_RECESSED,TRUE,
     NIL])
  DrawBevelBoxA( tools_wnd.rport, x-(xsize/2),
                                dummy.topedge-(ysize/4),
                                (49*xsize),
                                dummy.height+(ysize/2),
    [GT_VISUALINFO,visual,
     GTBB_RECESSED,TRUE,
     NIL])
  GtX_RefreshWindow( tools_handle, tools_wnd, NIL)
ENDPROC

PROC closetools_window()
  IF tools_wnd THEN CloseWindow(tools_wnd)
  IF tools_glist THEN FreeGadgets(tools_glist)
  IF tools_handle THEN GtX_FreeHandle( tools_handle )
ENDPROC

PROC loadTools( td:PTR TO toolsdata, pref:PTR TO prefsdata )
  DEF buf[256]:STRING,
      handle

  IF td
    IF td.progs
      p_CleanList( td.progs, LIST_CLEAN )
    ELSE
      td.progs := p_InitList( )
    ENDIF
  ELSE
    td := New( SIZEOF toolsdata )
    td.progs := p_InitList( )
  ENDIF
  IF handle := Open( pref.toolsfile, OLDFILE )
    WHILE Fgets( handle, buf, 256 )
      StrCopy( buf, buf, StrLen(buf)-1 )
      p_AjouteNode( td.progs, buf )
    ENDWHILE
    Close( handle )
  ELSE
    p_CleanList( td.progs, LIST_REMOVE )
    Dispose( td )
    td := NIL
  ENDIF
ENDPROC td

PROC saveTools( td:PTR TO toolsdata, pref:PTR TO prefsdata )
  DEF buf[256]:STRING,
      node:PTR TO ln,
      handle,
      num,cnt

  IF handle := Open( pref.toolsfile, NEWFILE )
    IF num := p_CountNodes( td.progs )
      DEC num
      FOR cnt := 0 TO num
        node := p_GetAdrNode( td.progs, cnt )
        StringF( buf, '\s\n', node.name )
        Fputs( handle, buf )
      ENDFOR
    ENDIF
    Close( handle )
  ENDIF
ENDPROC


PROC tools( td:PTR TO toolsdata, set:PTR TO setupdata, pref:PTR TO prefsdata )
  DEF m,
      gad,
      fl=FALSE,
      num,
      dummy:PTR TO CHAR,
      node:PTR TO ln,
      buf[256]:STRING,
      buf2[90]:STRING,
      posA,posB,
      opts=0,
      req:PTR TO rtfilerequester,
      prg[256]:STRING,
      para[90]:STRING,
      val[30]:STRING,
      winlock,
      flg

  IF reporterr( opentools_window( ) ) = 0
    IF req := RtAllocRequestA( RT_FILEREQ, NIL )
      RtChangeReqAttrA( req, [RTFI_DIR,'SYS:',
                              NIL] )
      IF p_CountNodes( td.progs )
        GtX_SetGadgetAttrsA( tools_handle, tools_listview,
                            [GTLV_LABELS,td.progs,NIL] )
      ENDIF
      REPEAT
        m := wait4message( tools_handle, tools_wnd )
        IF m = IDCMP_GADGETUP
          gad := infos.gadgetid
          SELECT gad
            CASE TOOLS_STRING
              GtX_SetGadgetAttrsA( tools_handle, tools_listview,
                                     [GTLV_SELECTED,-1,
                                      NIL] )
            CASE TOOLS_EXIT
              fl := TRUE
            CASE TOOLS_SAVE
              saveTools( td, pref )
            CASE TOOLS_LIST
              Gt_GetGadgetAttrsA( tools_listview, tools_wnd, NIL,
                                 [GTLV_SELECTED,{num},NIL] )
              node := p_GetAdrNode( td.progs, num )
              StrCopy( buf, node.name, ALL )
              GtX_SetGadgetAttrsA( tools_handle,
                                   findGadget( tools_wnd, TOOLS_STRING ),
                                   [GTST_STRING,buf,NIL] )
            CASE TOOLS_REMOVE
              Gt_GetGadgetAttrsA( tools_listview, tools_wnd, NIL,
                                 [GTLV_SELECTED,{num},NIL] )
              p_EnleveNode( td.progs, num )
              GtX_SetGadgetAttrsA( tools_handle, tools_listview,
                                   [GTLV_LABELS,td.progs,
                                    GTLV_SELECTED,-1,
                                    NIL] )
              GtX_SetGadgetAttrsA( tools_handle, findGadget( tools_wnd, TOOLS_STRING ),
                                   [GTST_STRING,'',NIL] )
            CASE TOOLS_ADD
              Gt_GetGadgetAttrsA( findGadget( tools_wnd, TOOLS_STRING ),
                                  tools_wnd,
                                  NIL,
                                  [GTST_STRING,{dummy},NIL] )
              StrCopy( buf, dummy, ALL )
              IF buf[]
                p_AjouteNode( td.progs, buf )
                p_SortList( td.progs )
                GtX_SetGadgetAttrsA( tools_handle, tools_listview,
                                     [GTLV_LABELS,td.progs,
                                      GTLV_SELECTED,-1,
                                      NIL] )
                GtX_SetGadgetAttrsA( tools_handle,
                                     findGadget( tools_wnd, TOOLS_STRING ),
                                     [GTST_STRING,'',NIL] )
              ENDIF
            CASE TOOLS_RUN
              buf[] := 0
              buf2[] := 0
              para[] := 0
              prg[] := 0
              flg := TRUE
              Gt_GetGadgetAttrsA( tools_listview, tools_wnd, NIL,
                                 [GTLV_SELECTED,{num},NIL] )
              IF num <> -1
                node := p_GetAdrNode( td.progs, num )
                StrCopy( buf, node.name, ALL )
                IF ( ( posA := InStr( buf, '{', 0 ) ) <> -1 ) AND
                   ( ( posB := InStr( buf, '}', posA ) ) <> -1 )
                  StrCopy( prg, buf, (posA-1) )
                  dummy := buf+posA+1
                  StrCopy( buf2, dummy, (posB-posA-1) )
                  opts := getToolOptions( buf2 )
                  IF ( opts AND OPT_WB )
                    para[] := 0
                  ELSE
                    IF ( opts AND OPT_QUIET )
                      StrCopy( para, ' ', 1 )
                    ELSE
                      IF ( opts AND OPT_DISPLAY )
                        StrCopy( para, ' >', 2 )
                        StrAdd( para, pref.tmpfile, ALL )
                        StrAdd( para, ' ', 1 )
                      ELSE
                        StringF( para,
                                 ' >CON:\d/\d/\d/\d/Ausgabe/CLOSE/WAIT ',
                                   tools_wnd.leftedge,
                                   tools_wnd.topedge,
                                   tools_wnd.width,
                                   tools_wnd.height )
                      ENDIF
                    ENDIF
                    IF ( opts AND OPT_REQ )
                      IF ( opts AND OPT_PAT )
                        RtChangeReqAttrA( req, [RTFI_MATCHPAT,buf2,
                                                NIL] )
                      ELSE
                        RtChangeReqAttrA( req, [RTFI_MATCHPAT,'#?',
                                                NIL] )
                      ENDIF
                      buf[] := 0
                      IF RtFileRequestA( req, buf, 'Bitte Datei wählen!',
                                    [RT_WINDOW,tools_wnd,
                                     RT_REQPOS,REQPOS_CENTERWIN,
                                     RT_LOCKWINDOW,TRUE,
                                     RTFI_FLAGS,FREQF_PATGAD,
                                     RTFI_HEIGHT,tools_wnd.height,
                                     NIL] )
                        StrAdd( para, req.dir, ALL )
                        AddPart( para, buf, 90 )
                      ELSE
                        flg := FALSE
                      ENDIF
                    ELSEIF ( opts AND OPT_SRC )
                      StrAdd( para, set.source, ALL )
                    ENDIF
                    IF ( opts AND OPT_INPUT )
                      IF RtGetStringA( val, 30, 'Parameter eingeben', NIL,
                        [ RT_WINDOW, tools_wnd,
                          RT_LOCKWINDOW, TRUE,
                          RT_UNDERSCORE, "_",
                          RTGS_GADFMT, '_Ok|_Abbruch',
                          RTGS_ALLOWEMPTY,TRUE,
                          NIL ] )
                        StrAdd( para, ' ', 1 )
                        StrAdd( para, val, ALL )
                      ELSE
                        flg := FALSE
                      ENDIF
                    ENDIF
                  ENDIF
                ELSE
                  StrCopy( prg, buf, ALL )
                  para[] := 0
                ENDIF
                IF ( opts AND OPT_DSX )
                  IF ( posA := InStr( para, '.', 0 ) ) <> -1
                    StrCopy( para, para, (posA) )
                  ENDIF
                ENDIF
                IF flg
                  IF pref.asynch = 0 THEN winlock := RtLockWindow( tools_wnd )
                  StrAdd( prg, para, ALL )
                  SystemTagList( prg, [SYS_ASYNCH,pref.asynch,
                                       NIL] )
                  IF pref.asynch = 0 THEN RtUnlockWindow( tools_wnd, winlock )
                  IF ( opts AND OPT_DISPLAY )
                    IF pref.asynch = 0 THEN winlock := RtLockWindow( tools_wnd )
                    StrCopy( prg, pref.displayfile, ALL )
                    StrAdd( prg, ' ', 1 )
                    StrAdd( prg, pref.tmpfile, ALL )
                    SystemTagList( prg,
                                        [SYS_ASYNCH,pref.displayflag,
                                         NIL] )
                    IF pref.asynch = 0 THEN RtUnlockWindow( tools_wnd, winlock )
                  ENDIF
                ENDIF
              ENDIF
            CASE TOOLS_SELECT
              IF RtFileRequestA( req, buf, 'Bitte Datei wählen!',
                                  [RT_WINDOW,tools_wnd,
                                   RT_REQPOS,REQPOS_CENTERWIN,
                                   RT_LOCKWINDOW,TRUE,
                                   RTFI_FLAGS,FREQF_PATGAD,
                                   RTFI_HEIGHT,tools_wnd.height,
                                   NIL] )
                StrCopy( buf2, req.dir, ALL )
                AddPart( buf2, buf, 90 )
                GtX_SetGadgetAttrsA( tools_handle,
                                     findGadget( tools_wnd, TOOLS_STRING ),
                                     [GTST_STRING,buf2,NIL] )
                GtX_SetGadgetAttrsA( tools_handle, tools_listview,
                                     [GTLV_SELECTED,-1,NIL] )
              ENDIF
            CASE TOOLS_DOIT
              Gt_GetGadgetAttrsA( findGadget( tools_wnd, TOOLS_ACTION ),
                                  tools_wnd, NIL, [GTCY_ACTIVE,{num},NIL] )
              SELECT num
                CASE 0
                  /*** Datei(en) löschen ***/
                  deleteFiles( req, tools_wnd )
                CASE 1
                  renameFile( req, tools_wnd )
                CASE 2
                  makeDirectory( req, tools_wnd )
              ENDSELECT
          ENDSELECT
        ELSEIF m = IDCMP_CLOSEWINDOW
          fl := TRUE
        ENDIF
      UNTIL fl
      RtFreeRequest( req )
    ENDIF
  ENDIF
  closetools_window()
ENDPROC

PROC makeDirectory( req:PTR TO rtfilerequester, wnd:PTR TO window )
  DEF buf2[256]:STRING,
      lock,
      dir[256]:STRING

  IF RtFileRequestA( req, dir, 'Bitte Datei wählen!',
                                  [RT_WINDOW,wnd,
                                   RT_REQPOS,REQPOS_CENTERWIN,
                                   RT_LOCKWINDOW,TRUE,
                                   RTFI_FLAGS,FREQF_PATGAD+
                                              FREQF_NOFILES,
                                   RTFI_HEIGHT,wnd.height,
                                   NIL] )

    StrCopy( dir, req.dir, ALL )
    StringF( buf2, 'Bitte geben Sie den Namen\n' +
                   'des neuen Verzeichnisses\n' +
                   'an, das im Verzeichnis\n' +
                   '"\s"\n' +
                   'angelegt werden soll!\n', dir )
    IF RtGetStringA( dir, 256, 'Verzeichnis anlegen', NIL,
                    [ RT_WINDOW, main_wnd,
                      RT_LOCKWINDOW, TRUE,
                      RT_UNDERSCORE, "_",
                      RTGS_GADFMT, '_Erzeugen|_Abbruch',
                      RTGS_TEXTFMT, buf2,
                      RTGS_FLAGS,GSREQF_CENTERTEXT,
                      NIL ] )
      IF lock := CreateDir( dir )
        UnLock( lock )
      ELSE
        RtEZRequestA( 'Kann Verzeichnis nicht anlegen!', '_OK',
                          NIL, NIL, getRTTags( wnd ) )
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC renameFile( req:PTR TO rtfilerequester, wnd:PTR TO window )
  DEF buf[256]:STRING,
      buf2[256]:STRING,
      old[256]:STRING,
      sel,
      handleA,handleB,
      char

  IF RtFileRequestA( req, buf, 'Bitte Datei wählen!',
                                    [RT_WINDOW,wnd,
                                     RT_REQPOS,REQPOS_CENTERWIN,
                                     RT_LOCKWINDOW,TRUE,
                                     RTFI_FLAGS,FREQF_PATGAD,
                                     RTFI_HEIGHT,wnd.height,
                                     NIL] )

    StrCopy( buf2, req.dir, ALL )
    AddPart( buf2, buf, 256 )
    StrCopy( old, buf2, ALL )
    StrCopy( buf, old, ALL )
    StringF( buf2, 'Bitte geben Sie den neuen Dateinamen\n' +
                   'für "\s" an.\n', old )
    IF sel := RtGetStringA( buf, 256, 'Datei umbenennen', NIL,
                           [ RT_WINDOW, wnd,
                             RT_LOCKWINDOW, TRUE,
                             RT_UNDERSCORE, "_",
                             RTGS_GADFMT, '_Umbenennen|_Neu erzeugen|_Abbruch',
                             RTGS_TEXTFMT, buf2,
                             RTGS_FLAGS,GSREQF_CENTERTEXT,
                             NIL ] )
      IF sel = 1
        Rename( old, buf )
      ELSEIF sel = 2
        IF handleA := Open( old, OLDFILE )
          IF handleB := Open( buf, NEWFILE )
            WHILE ( char := FgetC( handleA ) ) <> -1 DO FputC( handleB, char )
            Close( handleB )
          ENDIF
          Close( handleA )
        ENDIF
      ENDIF
    ENDIF
     RtFreeReqBuffer( req )
  ENDIF
ENDPROC

PROC deleteFiles( req:PTR TO rtfilerequester, wnd:PTR TO window )
  DEF buf[256]:STRING,
      fl:PTR TO rtfilelist,
      entry:PTR TO rtfilelist,
      buf2[256]:STRING

    IF fl := RtFileRequestA( req, buf, 'Bitte Files zum löschen wählen!',
                                        [RT_WINDOW,wnd,
                                         RT_REQPOS,REQPOS_CENTERWIN,
                                         RT_LOCKWINDOW,TRUE,
                                         RTFI_FLAGS,FREQF_PATGAD+
                                                    FREQF_MULTISELECT,
                                         RTFI_HEIGHT,wnd.height,
                                         NIL] )
      entry := fl
      REPEAT
        StrCopy( buf, req.dir, ALL )
        AddPart( buf, entry.name, 256 )
        StringF( buf2, 'Datei\n"\s"\nwirklich löschen?', buf )
        IF RtEZRequestA( buf2, '_Ja|_Nein',
                                 NIL, NIL, getRTTags( wnd ) )
          IF DeleteFile( buf ) = FALSE
            StringF( buf2, 'Kann Datei\n"\s"\nnicht löschen!', buf )
            RtEZRequestA( buf2, '_OK',
                          NIL, NIL, getRTTags( wnd ) )
          ENDIF
        ENDIF
        entry := entry.next
      UNTIL entry = 0
      RtFreeFileList( fl )
      RtFreeReqBuffer( req )
    ENDIF
ENDPROC

PROC getRTTags( win )
  DEF tags:PTR TO LONG

  tags := [ RT_WINDOW, win,
            RT_LOCKWINDOW, TRUE,
            RT_REQPOS, REQPOS_CENTERWIN,
            RT_UNDERSCORE, "_",
            RTEZ_REQTITLE, 'Information:',
            RTEZ_FLAGS,EZREQF_CENTERTEXT,
            NIL ]:LONG
ENDPROC tags

PROC getToolOptions( para:PTR TO CHAR )
  DEF pos=0,
      oldpos=0,
      strptr:PTR TO CHAR,
      buf[90]:STRING,
      opts=OPT_EMPTY


  WHILE ( pos := InStr( para, '|', oldpos ) ) <> -1
    strptr := para + oldpos
    StrCopy( buf, strptr, (pos-oldpos) )
    opts := checkOpts( opts, buf )
    IF ( opts AND OPT_PAT ) THEN StrCopy( para, buf, ALL )
    oldpos := pos+1
  ENDWHILE
  strptr := para + oldpos
  StrCopy( buf, strptr, (pos-oldpos) )
  opts := checkOpts( opts, buf )
  IF ( opts AND OPT_PAT ) THEN StrCopy( para, buf, ALL )
ENDPROC opts

PROC checkOpts( opts:LONG, option:PTR TO CHAR )
  DEF strptr:PTR TO CHAR

  IF StrCmp( option, 'DISPLAY', 7 )
    MOVE.L opts,D0
    ORI.L #OPT_DISPLAY,D0
    ANDI.L #SET_DISPLAY,D0
    MOVE.L D0,opts
  ENDIF
  IF StrCmp( option, 'SHELL', 5 )
    MOVE.L opts,D0
    ORI.L #OPT_SHELL,D0
    ANDI.L #SET_SHELL,D0
    MOVE.L D0,opts
  ENDIF
  IF StrCmp( option, 'WB', 2 )
    MOVE.L opts,D0
    ORI.L #OPT_WB,D0
    ANDI.L #SET_WB,D0
    MOVE.L D0,opts
  ENDIF
  IF StrCmp( option, 'SRC', 3 )
    MOVE.L opts,D0
    ORI.L #OPT_SRC,D0
    ANDI.L #SET_SRC,D0
    MOVE.L D0,opts
  ENDIF
  IF StrCmp( option, 'REQ', 3 )
    MOVE.L opts,D0
    ORI.L #OPT_REQ,D0
    ANDI.L #SET_REQ,D0
    MOVE.L D0,opts
  ENDIF
  IF StrCmp( option, 'PAT', 3 )
    MOVE.L opts,D0
    ORI.L #OPT_PAT,D0
    ANDI.L #SET_PAT,D0
    MOVE.L D0,opts
    strptr := option+4
    StrCopy( option, strptr, ALL )
  ENDIF
  IF StrCmp( option, 'DSX', 3 )
    MOVE.L opts,D0
    ORI.L #OPT_DSX,D0
    ANDI.L #SET_DSX,D0
    MOVE.L D0,opts
  ENDIF
  IF StrCmp( option, 'INPUT', 5 )
    MOVE.L opts,D0
    ORI.L #OPT_INPUT,D0
    ANDI.L #SET_INPUT,D0
    MOVE.L D0,opts
  ENDIF
  IF StrCmp( option, 'QUIET', 5 )
    MOVE.L opts,D0
    ORI.L #OPT_QUIET,D0
    ANDI.L #SET_QUIET,D0
    MOVE.L D0,opts
  ENDIF
ENDPROC opts

PROC openprefs_window()
  DEF g:PTR TO gadget,
      bx, by,
       x,  y,
      ww, wh

  x := (3*xsize/2)
  y := (2*ysize)
  bx := (20*xsize)
  by := /*ysize+(ysize/2)*/ 2*ysize
  ww := (2*x)+(2*bx)+(3*xsize)+(bx/2)
  wh := y+(5*ysize)+(2*by)+(ysize/2)
  IF ( prefs_handle := GtX_GetHandleA( getGTXTags( )
                                       ) ) = NIL THEN RETURN NOCONTEXT
  IF ( g := CreateContext( {prefs_glist} ) ) = NIL THEN RETURN NOCONTEXT
  IF ( g := GtX_CreateGadgetA( prefs_handle, CYCLE_KIND, g,
    [x,y+(3*ysize),bx,by,
     'A_rt',tattr,PREFS_DATA,4,visual,0]:newgadget,
    [GTCY_LABELS,
     ['Textanzeiger',
      'Hilfsmittel',
      'Einstellungen',
      'Temporär',
      0],
     GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( prefs_handle, BUTTON_KIND, g,
    [x+bx,y+(3*ysize),(3*xsize),by,
     '_?',tattr,PREFS_SELECT,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( prefs_handle, STRING_KIND, g,
    [x+bx+(3*xsize),y+(3*ysize),bx+(bx/2),by,
     '_Datei',tattr,PREFS_FILE,4,visual,0]:newgadget,
    [$80030024,0,
     GTST_MAXCHARS,256,
     GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( prefs_handle, CHECKBOX_KIND, g,
    [x,y+(3*ysize)+by+(ysize/2),(3*xsize),by/2,
     'as_ynchron ausführen',tattr,PREFS_ASYNCH,2,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     GTCB_SCALED,TRUE,
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( prefs_handle, BUTTON_KIND, g,
    [x,y+(5*ysize)+(by),(bx/2),by,
     '_Sichern',tattr,PREFS_SAVE,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( prefs_handle, BUTTON_KIND, g,
    [(ww/2)-(bx/4),y+(5*ysize)+by,(bx/2),by,
     '_Benutzen',tattr,PREFS_USE,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( g := GtX_CreateGadgetA( prefs_handle, BUTTON_KIND, g,
    [ww-x-(bx/2),y+(5*ysize)+by,(bx/2),by,
     '_Abbruch',tattr,PREFS_CANCEL,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL] ) ) = NIL THEN RETURN NOGADGET
  IF ( prefs_wnd := OpenWindowTagList( NIL,
       getWinTags( main_wnd.leftedge, main_wnd.topedge, ww, wh,
       prefs_glist, 'EManager Vorinstellungen' ) ) ) = NIL THEN RETURN NOWINDOW
  PrintIText(prefs_wnd.rport,
    [2,0,0,x,y+(ysize/4),tattr,'Textanzeiger & Sicherungsdateien',NIL]:intuitext,0,0)
  DrawBevelBoxA(prefs_wnd.rport,
     x-(xsize/2),y,ww+xsize-(2*x),
     /*(3*ysize)+(2*by)+(ysize/2),*/ (4*ysize)+by+(3*ysize/4),
    [GT_VISUALINFO,visual,
     GTBB_RECESSED,TRUE,
     NIL])
  GtX_RefreshWindow( prefs_handle, prefs_wnd, NIL )
ENDPROC

PROC closeprefs_window()
  IF prefs_wnd THEN CloseWindow(prefs_wnd)
  IF prefs_glist THEN FreeGadgets(prefs_glist)
  IF prefs_handle THEN GtX_FreeHandle( prefs_handle )
ENDPROC

PROC prefs( pref:PTR TO prefsdata )
  DEF m,
      fl=FALSE,
      gad,
      req:PTR TO rtfilerequester,
      buf[256]:STRING,
      dummy,
      dummy2,
      file[256]:STRING,
      ex,
      pd:PTR TO prefsdata

  IF reporterr( openprefs_window( ) ) = 0
    IF req := RtAllocRequestA( RT_FILEREQ, NIL )
      IF pd := New( SIZEOF prefsdata )
        pd.displayfile := String( 256 )
        pd.toolsfile := String( 256 )
        pd.setupfile := String( 256 )
        pd.tmpfile := String( 256 )
        StrCopy( pd.displayfile, pref.displayfile, ALL )
        StrCopy( pd.toolsfile, pref.toolsfile, ALL )
        StrCopy( pd.setupfile, pref.setupfile, ALL )
        StrCopy( pd.tmpfile, pref.tmpfile, ALL )
        pd.displayflag := pref.displayflag
        pd.asynch := pref.asynch
        StrCopy( file, pd.displayfile, ALL )
        GtX_SetGadgetAttrsA( prefs_handle, findGadget( prefs_wnd, PREFS_FILE ),
                                  [GTST_STRING,file,NIL] )
        dummy := pd.displayflag
        GtX_SetGadgetAttrsA( prefs_handle,
                             findGadget( prefs_wnd, PREFS_ASYNCH ),
                             [GTCB_CHECKED,dummy,NIL] )
        REPEAT
          m := wait4message( prefs_handle, prefs_wnd )
          IF m = IDCMP_GADGETUP
            ex := FALSE
            gad := infos.gadgetid
            SELECT gad
              CASE PREFS_CANCEL
                fl := TRUE
              CASE PREFS_SELECT
                IF RtFileRequestA( req, buf, 'Bitte Datei wählen!',
                                      [RT_WINDOW,prefs_wnd,
                                       RT_REQPOS,REQPOS_CENTERWIN,
                                       RT_LOCKWINDOW,TRUE,
                                       RTFI_FLAGS,FREQF_PATGAD,
                                       NIL] )
                  StrCopy( file, req.dir, ALL )
                  AddPart( file, buf, 256 )
                  ex := TRUE
                ENDIF
              CASE PREFS_FILE
                Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_FILE ), prefs_wnd,
                                    NIL,
                                     [GTST_STRING,{dummy},ALL] )
                StrCopy( file, dummy, ALL )
                ex := TRUE
              CASE PREFS_ASYNCH
                Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_ASYNCH ), prefs_wnd,
                                    NIL, [GTCB_CHECKED,{dummy2},NIL] )
                Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_DATA ), prefs_wnd,
                                    NIL,
                                    [GTCY_ACTIVE,{dummy},ALL] )
                SELECT dummy
                  CASE 0
                    pd.displayflag := dummy2
                  CASE 1
                    pd.asynch := dummy2
                ENDSELECT
              CASE PREFS_DATA
                Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_DATA ), prefs_wnd,
                                    NIL,
                                    [GTCY_ACTIVE,{dummy},ALL] )
                SELECT dummy
                  CASE 0
                    StrCopy( file, pd.displayfile, ALL )
                    GtX_SetGadgetAttrsA( prefs_handle,
                                         findGadget( prefs_wnd, PREFS_FILE ),
                                         [GTST_STRING,file,NIL] )
                    OnGadget( findGadget( prefs_wnd, PREFS_ASYNCH ),
                              prefs_wnd, NIL )
                    GtX_SetGadgetAttrsA( prefs_handle,
                                         findGadget( prefs_wnd, PREFS_ASYNCH ),
                                         [GTCB_CHECKED,pd.displayflag,NIL] )
                  CASE 1
                    StrCopy( file, pd.toolsfile, ALL )
                    GtX_SetGadgetAttrsA( prefs_handle,
                                         findGadget( prefs_wnd, PREFS_FILE ),
                                         [GTST_STRING,file,NIL] )
                    OnGadget( findGadget( prefs_wnd, PREFS_ASYNCH ),
                              prefs_wnd, NIL )
                    GtX_SetGadgetAttrsA( prefs_handle,
                                         findGadget( prefs_wnd, PREFS_ASYNCH ),
                                         [GTCB_CHECKED,pd.asynch,NIL] )
                  CASE 2
                    StrCopy( file, pd.setupfile, ALL )
                    GtX_SetGadgetAttrsA( prefs_handle,
                                         findGadget( prefs_wnd, PREFS_FILE ),
                                         [GTST_STRING,file,NIL] )
                    OffGadget( findGadget( prefs_wnd, PREFS_ASYNCH ),
                              prefs_wnd, NIL )
                    GtX_SetGadgetAttrsA( prefs_handle,
                                         findGadget( prefs_wnd, PREFS_ASYNCH ),
                                         [GTCB_CHECKED,NIL,NIL] )
                  CASE 3
                    StrCopy( file, pd.tmpfile, ALL )
                    GtX_SetGadgetAttrsA( prefs_handle,
                                         findGadget( prefs_wnd, PREFS_FILE ),
                                         [GTST_STRING,file,NIL] )
                    OffGadget( findGadget( prefs_wnd, PREFS_ASYNCH ),
                              prefs_wnd, NIL )
                    GtX_SetGadgetAttrsA( prefs_handle,
                                         findGadget( prefs_wnd, PREFS_ASYNCH ),
                                         [GTCB_CHECKED,NIL,NIL] )
                ENDSELECT
              CASE PREFS_SAVE
                savePrefs( pd )
                StrCopy( pref.displayfile, pd.displayfile, ALL )
                StrCopy( pref.toolsfile, pd.toolsfile, ALL )
                StrCopy( pref.setupfile, pd.setupfile, ALL )
                StrCopy( pref.tmpfile, pd.tmpfile, ALL )
                pref.displayflag := pd.displayflag
                pref.asynch := pd.asynch
                fl := TRUE
              CASE PREFS_USE
                StrCopy( pref.displayfile, pd.displayfile, ALL )
                StrCopy( pref.toolsfile, pd.toolsfile, ALL )
                StrCopy( pref.setupfile, pd.setupfile, ALL )
                StrCopy( pref.tmpfile, pd.tmpfile, ALL )
                pref.displayflag := pd.displayflag
                pref.asynch := pd.asynch
                fl := TRUE
            ENDSELECT
            IF ex
              GtX_SetGadgetAttrsA( prefs_handle, findGadget( prefs_wnd, PREFS_FILE ),
                                  [GTST_STRING,file,NIL] )
              Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_DATA ), prefs_wnd,
                                  NIL,
                                  [GTCY_ACTIVE,{dummy},ALL] )
              SELECT dummy
                CASE 0
                  StrCopy( pd.displayfile, file, ALL )
                CASE 1
                  StrCopy( pd.toolsfile, file, ALL )
                CASE 2
                  StrCopy( pd.setupfile, file, ALL )
                CASE 3
                  StrCopy( pd.tmpfile, file, ALL )
              ENDSELECT
            ENDIF
          ELSEIF m = IDCMP_CLOSEWINDOW
            fl := TRUE
          ENDIF
        UNTIL fl
      ENDIF
      RtFreeRequest( req )
    ENDIF
  ENDIF
  closeprefs_window( )
ENDPROC

PROC getFileSize( name:PTR TO CHAR )
  DEF lock,
      fib:fileinfoblock,
      val=0

  IF lock := Lock( name, -2 )
    Examine( lock, fib )
    val := fib.size
    UnLock( lock )
  ENDIF
ENDPROC val

PROC info( set:PTR TO setupdata )
  DEF buf[256]:STRING,
      prg[256]:STRING,
      prg2:PTR TO CHAR,
      text[2048]:STRING

  StringF( buf, '*** EManager V2.0 ***\n\n' )
  StrAdd( text, buf, ALL )
  StringF( buf, '© by Peter Palm\nDieses Programm ist Freeware.\n\n' )
  StrAdd( text, buf, ALL )
  buf[] := 0
  prg2 := FilePart( set.source )
  StringF( buf, 'Quelltext: \s (\d Bytes)\n', prg2, getFileSize( set.source ) )
  StrAdd( text, buf, ALL )
  StrCopy( prg, set.source, StrLen(set.source)-2 )
  buf[] := 0
  prg2 := FilePart( prg )
  StringF( buf, 'Programm: \s (\d Bytes)\n', prg2, getFileSize( prg ) )
  StrAdd( text, buf, ALL )
  SetStr( text, StrLen( text ) )
  RtEZRequestA( text, '_OK', NIL, NIL,
                getRTTags( main_wnd ) )
ENDPROC

PROC getGTXTags( )
  DEF tags:PTR TO LONG

  tags := [HKH_TAGBASE,TRUE,
           HKH_USENEWBUTTON,1,
           HKH_NEWTEXT,1,
           HKH_KEYMAP,NIL,
           HKH_SETREPEAT,SRF_LISTVIEW+
                         SRF_SLIDER,
           NIL]
ENDPROC tags
