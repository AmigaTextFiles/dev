/*************************************************************************

:Programm.      EManager
:Version.       1.0
:Beschreibung.  Automatisiert die Arbeit mit dem E-Compiler und macht den
                Compiler von der Workbench erreichbar.
:Autor.         Peter Palm

:EC-Version.    EC3.1a
:OS.            >= 3.0 (unter OS3.0 auf A1200 programmiert und getestet)
:PRG-Version.   0.9   -> erste funktionstüchtige Version
                1.0  -> Programm um einige Funktionen erweitert
:letzte
 Änderung.      08.08.1995
:Status.        Freeware

*************************************************************************/



OPT OSVERSION=39 -> wegen verschiedener Betriebssystemroutinen

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
       'dos/dos',
       'dos/dostags',
       'icon',
       'workbench/startup',
       'workbench/workbench',
       '*dev/plist_red',  /* optimiertes "plist"-Modul auf einer älteren
                              EPD-Diskette */
       'exec/nodes',
       'exec/ports'

ENUM NONE,           -> kein Fehler
     NOCONTEXT,      -> kein Gadgetkontext
     NOGADGET,       -> kein Gadget
     NOWB,           -> keine Workbench
     NOVISUAL,       -> kein VisulaInfo
     OPENGT,         -> keine gadtools.library
     NOWINDOW,       -> kein Fenster
     OPENGTX,        -> keine gadtoolsbox.library
     OPENREQ         -> keine reqtools.library

CONST GADGETWIDTH = 18       -> Gadgetbreite in Anzahl Zeichen

ENUM MAIN_EDIT=1,            -> die GadgetId's für das Hauptfenster
     MAIN_COMPILE,
     MAIN_RUN,
     MAIN_TOOLS,
     MAIN_PREFS,
     MAIN_EXIT,
     MAIN_END

ENUM PREFS_EDITOR=1,         -> Die GadgetId's für das Voreinstellerfenster
     PREFS_EDITOR_S,
     PREFS_SOURCE,
     PREFS_SOURCE_S,
     PREFS_SOURCE_REQUEST,
     PREFS_COMPILER,
     PREFS_COMPILER_S,
     PREFS_OPT_REG,
     PREFS_OPT_LARGE,
     PREFS_OPT_SYM,
     PREFS_OPT_ASM,
     PREFS_OPT_IGNORECACHE,
     PREFS_OPT_LINEDEBUG,
     PREFS_OPT_DEBUG,
     PREFS_OPT_OPTI,
     PREFS_REGS,
     PREFS_LOAD,
     PREFS_SAVE,
     PREFS_EXIT,
     PREFS_END

ENUM TOOLS_CCACHE=1,         -> die GadgetId`s für das Hilfsmittel-Fenster
     TOOLS_SCACHE,
     TOOLS_MAKEDIR,
     TOOLS_DELETE,
     TOOLS_RENAME,
     TOOLS_EXIT,
     TOOLS_SHOWMODULE,
     TOOLS_PROGRAM,
     TOOLS_SETUP,
     TOOLS_END

ENUM MOD_DISPLAY=1,          -> die GadgetId`s für das Modulfenster
     MOD_FILE,
     MOD_SELECT,
     MOD_EXIT,
     MOD_END

ENUM UTILS_ENTRY=1,          -> die GadgetId`s für das Hilfsprogramm-Fenster
     UTILS_ENTRIES,
     UTILS_SELECT,
     UTILS_ADD,
     UTILS_DELETE,
     UTILS_LOAD,
     UTILS_SAVE,
     UTILS_RETURN,
     UTILS_RUN

/* die Internen Optionen für die Hilfsprogramme */
CONST MODE_SHELL =       %0000001,    -> = SHELL
      MODE_WORKBENCH =   %0011110,    -> = WB
      MODE_SOURCE =      %0000010,    -> = SRC
      MODE_REQUEST =     %0000100,    -> = REQ
      MODE_NOREQUEST =   %1111011,
      MODE_PATTERN =     %0001000,    -> = PAT
      MODE_DELETESUFFIX =%0010000,    -> = DSX
      MODE_NOARGS       =%0100000,    -> = NOARGS
      MODE_NOARGS2      =%0100001,
      MODE_DISPLAY      =%1000000     -> = DISPLAY


OBJECT preferences /**** die Voreinstelungen ****/
  editor:PTR TO CHAR,           -> Editorprogramm
  source_request:CHAR,          -> Flag für Anforderung eines Filerequesters
  source:PTR TO CHAR,           -> Quelltext, oder wenn "source_request" gesetzt
                                ->   ist, Quelltextverzeichnis
  compiler:PTR TO CHAR,         -> ECompilerprogramm
  extsource:PTR TO CHAR,        -> Zwischenspeicher

-> die einzelnen Optionen sind eigentlich selbsterklärend!

  opt_reg:CHAR,
  opt_large:CHAR,
  opt_sym:CHAR,
  opt_asm:CHAR,
  opt_ignorecache:CHAR,
  opt_linedebug:CHAR,
  opt_debug:CHAR,
  opt_opti:CHAR,

  regs:CHAR,                    -> Anzahl der Register für opt_reg

  flag:LONG                     -> Exit-Flag
ENDOBJECT

OBJECT utilities /*** Utilities die In den Tooltypes definiert werden ***/
  showcache:PTR TO CHAR,
  flushcache:PTR TO CHAR,
  showmodule:PTR TO CHAR,
  display:PTR TO CHAR, -> der Textanzeiger
  ext:LONG -> die Liste an eigenen Hilfsprogrammen
ENDOBJECT

-> globale Variablen (müssen leider sein!)
DEF main_wnd:PTR TO window,
    main_glist,
    main_handle,

    prefs_wnd:PTR TO window,
    prefs_glist,
    prefs_handle,

    module_wnd:PTR TO window,
    module_glist,
    module_handle,
    mod_lv,

    tools_wnd:PTR TO window,
    tools_glist,
    tools_handle,
    tools_lv,

    utils_wnd:PTR TO window,
    utils_glist,
    utils_handle,
    utils_lv,

    infos:PTR TO gadget,
    scr:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    ysize,
    xsize,
    di:PTR TO drawinfo,
    glob_buf[256]:STRING,
    tx,
    ty,
    myport:PTR TO mp,
    b_tags


PROC setupscreen( )
  DEF font:PTR TO textfont

  tattr := New( SIZEOF textattr )
  IF ( gadtoolsbase := OpenLibrary( 'gadtools.library', 37 ) ) = NIL THEN RETURN OPENGT
  IF ( gtxbase := OpenLibrary( 'gadtoolsbox.library', 37 ) ) = NIL THEN RETURN OPENGTX
  IF ( reqtoolsbase := OpenLibrary( 'reqtools.library', 38) )= NIL THEN RETURN OPENREQ
  IF ( scr := LockPubScreen( 'Workbench' ) ) = NIL THEN RETURN NOWB
  IF ( visual := GetVisualInfoA( scr, NIL ) ) = NIL THEN RETURN NOVISUAL
  AskFont( scr.rastport, tattr )
  ysize := tattr.ysize
  IF ysize < 11 THEN ysize := 11 
  IF di := GetScreenDrawInfo( scr )
    font := di.font
    xsize := font.xsize 
  ENDIF
  b_tags := [GT_UNDERSCORE,"_",NIL]:LONG
ENDPROC

PROC closedownscreen( )
  IF di THEN FreeScreenDrawInfo( scr, di )
  IF visual THEN FreeVisualInfo( visual )
  IF scr THEN UnlockPubScreen( NIL, scr )
  IF gadtoolsbase THEN CloseLibrary( gadtoolsbase )
  IF gtxbase THEN CloseLibrary( gtxbase )
  IF reqtoolsbase THEN CloseLibrary( reqtoolsbase )
ENDPROC

PROC openmain_window()
  DEF g:PTR TO gadget,
      x,y,bx,by,ww,wh

  main_handle := GtX_GetHandleA( [HKH_TAGBASE,TRUE,
                                  HKH_USENEWBUTTON,1,
                                  HKH_NEWTEXT,TRUE,
                                  HKH_KEYMAP,NIL,
                                  NIL] )
  x := 2*xsize
  y := 3*ysize
  bx := xsize*GADGETWIDTH
  by := ysize+(ysize/2)
  ww := (2*x)+bx+(35*xsize)
  wh := y+(6*by)+(5*ysize/3)

  IF ( g := CreateContext( {main_glist} ) ) = NIL THEN RETURN NOCONTEXT
  IF ( g := GtX_CreateGadgetA( main_handle, BUTTON_KIND, g,
    [x,y,bx,by,'_Editieren',tattr,MAIN_EDIT,16,visual,0]:newgadget,
    b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA( main_handle,BUTTON_KIND,g,
    [x,y+by+(ysize/3),bx,by,'_Compilieren',tattr,MAIN_COMPILE,16,visual,0]:newgadget,
     b_tags ) ) = NIL
   RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA( main_handle,BUTTON_KIND,g,
    [x,y+(2*(by+(ysize/3))),bx,by,'_Ausführen',tattr,MAIN_RUN,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA( main_handle,BUTTON_KIND,g,
    [x,y+(3*(by+(ysize/3))),bx,by,'_Hilfsmittel',tattr,MAIN_TOOLS,16,visual,0]:newgadget,
     b_tags ) )=NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA( main_handle,BUTTON_KIND,g,
    [x,y+(4*by)+(7*ysize/3),bx+2,by,'E_instellungen',tattr,MAIN_PREFS,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA( main_handle,BUTTON_KIND,g,
    [ww-x-(bx+2),y+(4*by)+(7*ysize/3),bx+2,by,'Programm _beenden',tattr,MAIN_EXIT,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF ( main_wnd:=OpenWindowTagList(NIL,
    getWinTags( 0,scr.barheight+1,ww,wh,main_glist,'AmigaE-Manager V1.0')))=NIL THEN
    RETURN NOWINDOW
  tx := x+bx+(3*xsize/2)
  ty := y+(ysize/2)
  print( 0, 'AmigaE-Manager V1.0' )
  print( 1, '© by Peter Palm' )
  print( 3, '"EManager" ist FREEWARE' )
  DrawBevelBoxA(main_wnd.rport,x+bx+xsize,y,33*xsize+xsize,(3*(by+(ysize/3)))+by,
    [GT_VISUALINFO,visual,
     GTBB_RECESSED,1,NIL])
  DrawBevelBoxA(main_wnd.rport,x-xsize,y-(ysize/2),ww-(2*xsize),(3*(by+(ysize/3)))+ysize+by,
    [GT_VISUALINFO,visual,
     GTBB_RECESSED,1,
     GTBB_FRAMETYPE,BBFT_RIDGE,
     NIL])
  drawButtonFrameG( main_wnd, findGadget( main_wnd, MAIN_PREFS ) )
  GtX_RefreshWindow(main_handle,main_wnd,NIL)
ENDPROC

PROC getWinTags( leftedge, topedge, width, height, glist, title )
  DEF tags

  tags := [WA_LEFT,leftedge,
           WA_TOP,topedge,
           WA_WIDTH,width,
           WA_HEIGHT,height,
           WA_IDCMP,                       ->$24C077E,
              IDCMP_REFRESHWINDOW+
              IDCMP_GADGETUP+
              IDCMP_GADGETDOWN+
              IDCMP_CLOSEWINDOW+
              IDCMP_CHANGEWINDOW+
              IDCMP_RAWKEY,
           WA_FLAGS,$100E,
           WA_TITLE,title,
           WA_CUSTOMSCREEN,scr,
           WA_AUTOADJUST,1,
           WA_AUTOADJUST,1,
           WA_GADGETS,glist,
           NIL]:LONG
ENDPROC tags

PROC closemain_window()
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
             'create menus',
             'open "gadtoolsbox.library"',
             'open "reqtools.library" v38+',
             NIL]
    EasyRequestArgs(0,[20,0,0,'Could not \s!','ok'],0,[erlist[er-1]])
  ENDIF
ENDPROC er

PROC main()
  DEF m,
      fl=FALSE,
      gad,
      p=NIL:PTR TO preferences,
      u

  IF init( )
    IF reporterr(setupscreen())=0
      IF reporterr(openmain_window())=0
        IF u := getToolTypes( )
          p := loadPrefs( p, u, main_wnd )
          REPEAT
            m := wait4message( main_handle, main_wnd )
            IF m = IDCMP_GADGETUP
              gad := infos.gadgetid
              SELECT gad
                CASE MAIN_PREFS
                  p := prefs( p )
                  fl := p.flag
                CASE MAIN_EXIT
                  fl := TRUE
                CASE MAIN_EDIT
                  editor( p )
                CASE MAIN_COMPILE
                  compiler( p )
                CASE MAIN_RUN
                  run( p )
                CASE MAIN_TOOLS
                  fl := tools( u, p )
              ENDSELECT
            ELSEIF m = IDCMP_CLOSEWINDOW
              fl := TRUE
            ENDIF
            IF fl
              fl := RtEZRequestA( 'Programm wirklich beenden?', '_Ja|_Nein',
                                   NIL, NIL, getRTTags( main_wnd ) )
            ENDIF
          UNTIL fl
          freeToolTypes( u )
        ENDIF
      ENDIF
      closemain_window()
    ENDIF
    closedownscreen()
    remove( )
  ENDIF
ENDPROC

PROC openprefs_window()
  DEF g:PTR TO gadget,
      x,y,bx,by,ww,wh

  prefs_handle := GtX_GetHandleA( [HKH_TAGBASE,NIL,
                                   HKH_USENEWBUTTON,1,
                                   HKH_NEWTEXT,TRUE,
                                   NIL] )

  x := (2*xsize)
  y := (3*ysize)
  by := ysize+(ysize/2)
  bx := (xsize*GADGETWIDTH)

  ww := (2*x)+(2*((3*xsize)+1))+(bx+(bx/2))+xsize+bx+(bx/2)
  wh := y+(9*by)+(by/2)+(ysize/2)

  IF (g:=CreateContext({prefs_glist}))=NIL THEN RETURN NOCONTEXT
  IF (g:=GtX_CreateGadgetA(prefs_handle,STRING_KIND,g,
    [x+(3*xsize)+1,y,bx+(bx/2),by,
     'E_ditor',tattr,PREFS_EDITOR,4,visual,0]:newgadget,
    [$80030024,0,
     GTST_MAXCHARS,256,
     GT_UNDERSCORE,"_",
     NIL]))=NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,BUTTON_KIND,g,
    [x,y,(3*xsize),by,'?_1',tattr,PREFS_EDITOR_S,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,STRING_KIND,g,
    [x+(2*((3*xsize)+1))+(bx+(bx/2))+xsize,y,bx+(bx/2),by,
     '_Quelltext',tattr,PREFS_SOURCE,4,visual,0]:newgadget,
    [$80030024,0,
     GTST_MAXCHARS,256,
     GT_UNDERSCORE,"_",
     NIL]))=NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,BUTTON_KIND,g,
    [x+((3*xsize)+1)+(bx+(bx/2))+xsize,y,(3*xsize),by,
     '?_2',tattr,PREFS_SOURCE_S,16,visual,0]:newgadget,
     b_tags ) )=NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,CHECKBOX_KIND,g,
    [x+(2*((3*xsize)+1))+(bx+(bx/2))+xsize,y+by,26,11,
     '_anfordern',tattr,PREFS_SOURCE_REQUEST,2,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,STRING_KIND,g,
    [x+(3*xsize)+1,y+(3*by)+(ysize),(bx+(bx/2)),by,
     '_Compiler',tattr,PREFS_COMPILER,4,visual,0]:newgadget,
    [$80030024,0,
     GTST_MAXCHARS,256,
     GT_UNDERSCORE,"_",
     NIL]))=NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,BUTTON_KIND,g,
    [x,y+(3*by)+(ysize),(3*xsize),by,
     '?_3',tattr,PREFS_COMPILER_S,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,CHECKBOX_KIND,g,
    [x,y+(4*by)+(ysize),26,11,
     '_Register',tattr,PREFS_OPT_REG,2,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,CHECKBOX_KIND,g,
    [x+bx,y+(4*by)+(ysize),26,11,
     'Lar_ge',tattr,PREFS_OPT_LARGE,2,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,CHECKBOX_KIND,g,
    [x+(2*bx),y+(4*by)+(ysize),26,11,
     'S_ymbolhunk',tattr,PREFS_OPT_SYM,2,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,CHECKBOX_KIND,g,
    [x,y+(4*by)+(ysize)+ysize,26,11,
     'Asse_mbler',tattr,PREFS_OPT_ASM,2,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,CHECKBOX_KIND,g,
    [x+bx,y+(4*by)+(ysize)+ysize,26,11,
     '_Ignorecache',tattr,PREFS_OPT_IGNORECACHE,2,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,CHECKBOX_KIND,g,
    [x+(2*bx),y+(4*by)+(ysize)+ysize,26,11,
     'Linedeb_ug',tattr,PREFS_OPT_LINEDEBUG,2,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,CHECKBOX_KIND,g,
    [x,y+(4*by)+(ysize)+(2*ysize),26,11,
     'De_bug',tattr,PREFS_OPT_DEBUG,2,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,CHECKBOX_KIND,g,
    [x+bx,y+(4*by)+(ysize)+(2*ysize),26,11,
     '_Optimieren',tattr,PREFS_OPT_OPTI,2,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,INTEGER_KIND,g,
    [x+(2*bx),y+(4*by)+(ysize/3)+(3*ysize),(5*xsize),by,
     'Registera_nzahl',tattr,PREFS_REGS,2,visual,0]:newgadget,
    [$80030024,0,
     GTIN_NUMBER,3,
     GTIN_MAXCHARS,1,
     GT_UNDERSCORE,"_",
     NIL]))=NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,BUTTON_KIND,g,
    [x,y+(8*by)+(ysize/2),bx,by,'_laden',tattr,PREFS_LOAD,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,BUTTON_KIND,g,
    [(ww/2)-(bx/2),y+(8*by)+(ysize/2),bx,by,'_sichern',tattr,PREFS_SAVE,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(prefs_handle,BUTTON_KIND,g,
    [ww-x-bx,y+(8*by)+(ysize/2),bx,by,'_zurück',tattr,PREFS_EXIT,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF ( prefs_wnd:=OpenWindowTagList(NIL,
    getWinTags(main_wnd.leftedge,main_wnd.topedge+main_wnd.bordertop,ww,wh,
               prefs_glist,'Management-Einstellungen') ) ) = NIL THEN
    RETURN NOWINDOW
  PrintIText(prefs_wnd.rport,
    [2,0,0,x+(2*bx),y+(3*by),tattr,'Optionen',NIL]:intuitext,0,0)
/****
  DrawBevelBoxA(prefs_wnd.rport,x-xsize,y-((7*ysize)/4),ww-(2*(x-xsize)),(3*by)+(ysize/2),
    [GT_VISUALINFO,visual,
     GTBB_RECESSED,TRUE,
     GTBB_FRAMETYPE,BBFT_RIDGE,
     NIL])
****/
  DrawBevelBoxA(prefs_wnd.rport,x-xsize,y-((7*ysize)/4)+(3*by)+(ysize),ww-(2*(x-xsize)),
     5*by+(by/2),
    [GT_VISUALINFO,visual,
     GTBB_RECESSED,TRUE,
     GTBB_FRAMETYPE,BBFT_RIDGE,
     NIL])
  drawButtonFrameG( prefs_wnd, findGadget( prefs_wnd, PREFS_LOAD ) )
  drawButtonFrameG( prefs_wnd, findGadget( prefs_wnd, PREFS_SAVE ) )
  GtX_RefreshWindow(prefs_handle,prefs_wnd,NIL)
ENDPROC

PROC closeprefs_window()
  IF prefs_wnd THEN CloseWindow(prefs_wnd)
  IF prefs_glist THEN FreeGadgets(prefs_glist)
  IF prefs_handle THEN GtX_FreeHandle( prefs_handle )
ENDPROC

PROC prefs( prefs :PTR TO preferences )
  DEF m,
      fl=FALSE,
      gad,
      dummy,
      buf:PTR TO CHAR,
      winlock

  prefs.flag := FALSE
  winlock := RtLockWindow( main_wnd )
  IF reporterr(openprefs_window())=0
    setPrefs( prefs )
    REPEAT
      m := wait4message(prefs_handle,prefs_wnd)
      IF m = IDCMP_GADGETUP
        gad := infos.gadgetid
        SELECT PREFS_END OF gad
          CASE PREFS_EXIT
            fl := TRUE
          CASE PREFS_SOURCE_S
            Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_SOURCE ), prefs_wnd, NIL,
                                 [GTST_STRING,{buf},NIL] )
            IF prefs.source_request = 0
              selectPath( buf )
              IF doRequest( '', glob_buf, prefs_wnd, 'Bitte Quelltext wählen!', '#?.e' )
                StrCopy( prefs.source, glob_buf, ALL )
                GtX_SetGadgetAttrsA( prefs_handle,
                                     findGadget( prefs_wnd, PREFS_SOURCE ),
                                    [GTST_STRING,prefs.source,NIL] )
              ENDIF
            ELSE
              IF doRequest( '', buf, prefs_wnd, 'Bitte Quelltext-Verzeichnis wählen!',
                            NIL, FREQF_NOFILES )
                StrCopy( prefs.source, glob_buf, ALL )
                GtX_SetGadgetAttrsA( prefs_handle, findGadget( prefs_wnd, PREFS_SOURCE ),
                                    [GTST_STRING,glob_buf,NIL] )
              ENDIF
            ENDIF
          CASE PREFS_EDITOR_S
            Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_EDITOR ), prefs_wnd, NIL,
                               [GTST_STRING,{buf},NIL] )
            selectPath( buf )
            IF doRequest( '', glob_buf, prefs_wnd, 'Bitte Editor wählen!', NIL )
              StrCopy( prefs.editor, glob_buf, ALL )
              GtX_SetGadgetAttrsA( prefs_handle, findGadget( prefs_wnd, PREFS_EDITOR ),
                                  [GTST_STRING,prefs.editor,NIL] )
            ENDIF
          CASE PREFS_COMPILER_S
            Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_COMPILER ), prefs_wnd, NIL,
                               [GTST_STRING,{buf},NIL] )
            selectPath( buf )
            IF doRequest( '', glob_buf, prefs_wnd, 'Bitte ECompiler wählen!', NIL )
              StrCopy( prefs.compiler, glob_buf, ALL )
              GtX_SetGadgetAttrsA( prefs_handle, findGadget( prefs_wnd, PREFS_COMPILER ),
                                  [GTST_STRING,prefs.compiler,NIL] )
            ENDIF
          CASE PREFS_SOURCE_REQUEST
            Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_SOURCE_REQUEST ), prefs_wnd, NIL,
                               [GTCB_CHECKED,{dummy},NIL] )
            prefs.source_request := dummy
            IF dummy
              GtX_SetGadgetAttrsA( prefs_handle, findGadget( prefs_wnd, PREFS_SOURCE ),
                                  [GTST_STRING,'',NIL] )
            ENDIF
          CASE PREFS_OPT_REG
            Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_OPT_REG ), prefs_wnd, NIL,
                               [GTCB_CHECKED,{dummy},NIL] )
            IF dummy
              OnGadget( findGadget( prefs_wnd, PREFS_REGS ), prefs_wnd, NIL )
            ELSE
              OffGadget( findGadget( prefs_wnd, PREFS_REGS ), prefs_wnd, NIL )
            ENDIF
          CASE PREFS_SAVE
            prefs := getPrefs( prefs )
            savePrefs( prefs )
          CASE PREFS_LOAD
            prefs := loadPrefs( prefs, NIL, prefs_wnd )
            setPrefs( prefs )
        ENDSELECT
      ELSEIF m = IDCMP_CHANGEWINDOW
        /****
        ChangeWindowBox( main_wnd, prefs_wnd.leftedge,
                                   (prefs_wnd.topedge)-(prefs_wnd.bordertop),
                                   main_wnd.width,
                                   main_wnd.height )
        WindowToFront( prefs_wnd )
        ActivateWindow( prefs_wnd )
        ****/
      ELSEIF m = IDCMP_CLOSEWINDOW
        fl := TRUE
        prefs.flag := TRUE
      ENDIF
    UNTIL fl
    prefs := getPrefs( prefs )
  ENDIF
  closeprefs_window()
  RtUnlockWindow( main_wnd, winlock )
ENDPROC prefs

PROC doRequest( iFile:PTR TO CHAR, iDir:PTR TO CHAR, win:PTR TO window,
                   title:PTR TO CHAR, pattern:PTR TO CHAR, mode=NIL )
/*********************************************************************
  öffnet einen ReqTools-Filerequester mit den angegebenen Parametern
*********************************************************************/
  DEF req:PTR TO rtfilerequester,
      fl=FALSE,buf[256]:STRING,pat[5]:STRING

  mode := mode+FREQF_PATGAD
  IF pattern THEN StrCopy( pat, pattern, ALL )
  StrCopy( buf, iFile, ALL )
  IF req := RtAllocRequestA( RT_FILEREQ, NIL )
    RtChangeReqAttrA( req, [ RTFI_DIR, iDir,
                             RTFI_MATCHPAT, pat,
                             NIL ] )
    IF RtFileRequestA( req, buf, title, [ RT_WINDOW, win,
                                          RT_REQPOS, REQPOS_POINTER,
                                          RT_LOCKWINDOW, TRUE,
                                          RTFI_FLAGS, mode,
                                          NIL ] )
      fl := TRUE
      StrCopy( glob_buf, req.dir, ALL )
      AddPart( glob_buf, buf, 256 )
    ENDIF
    RtFreeRequest( req )
  ENDIF
ENDPROC fl

PROC setPrefs( prefs:PTR TO preferences )
/*********************************************************************
  setzt alle Werte im Voreinstellefenster
*********************************************************************/

  GtX_SetGadgetAttrsA( prefs_handle, findGadget( prefs_wnd, PREFS_EDITOR ), [GTST_STRING,prefs.editor,NIL] )
  GtX_SetGadgetAttrsA( prefs_handle, findGadget( prefs_wnd, PREFS_SOURCE ), [GTST_STRING,prefs.source,NIL] )
  GtX_SetGadgetAttrsA( prefs_handle, findGadget( prefs_wnd, PREFS_COMPILER ), [GTST_STRING,prefs.compiler,NIL] )
  setPCB( findGadget( prefs_wnd, PREFS_SOURCE_REQUEST ), prefs.source_request )
  GtX_SetGadgetAttrsA( prefs_handle, findGadget( prefs_wnd, PREFS_SOURCE ), [GTST_STRING,prefs.source,NIL] )
  setPCB( findGadget( prefs_wnd, PREFS_OPT_REG ), prefs.opt_reg )
  IF prefs.opt_reg=0
    OffGadget( findGadget( prefs_wnd, PREFS_REGS ), prefs_wnd, NIL )
  ELSE
    OnGadget( findGadget( prefs_wnd, PREFS_REGS ), prefs_wnd, NIL )
    Gt_SetGadgetAttrsA( findGadget( prefs_wnd, PREFS_REGS ), prefs_wnd, NIL,
                       [GTIN_NUMBER,prefs.regs,NIL] )
  ENDIF
  setPCB( findGadget( prefs_wnd, PREFS_OPT_LARGE ), prefs.opt_large )
  setPCB( findGadget( prefs_wnd, PREFS_OPT_SYM ), prefs.opt_sym )
  setPCB( findGadget( prefs_wnd, PREFS_OPT_ASM ), prefs.opt_asm )
  setPCB( findGadget( prefs_wnd, PREFS_OPT_IGNORECACHE ), prefs.opt_ignorecache )
  setPCB( findGadget( prefs_wnd, PREFS_OPT_LINEDEBUG ), prefs.opt_linedebug )
  setPCB( findGadget( prefs_wnd, PREFS_OPT_DEBUG ), prefs.opt_debug )
  setPCB( findGadget( prefs_wnd, PREFS_OPT_OPTI ), prefs.opt_opti )
ENDPROC

PROC getPrefs( prefs:PTR TO preferences )
/***********************************************
  holt alle getroffenen Voreinstellungen aus dem
  Voreinstellerfenster
***********************************************/
  DEF dummy

  Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_EDITOR ), prefs_wnd, NIL,
                     [GTST_STRING,{dummy},NIL] )
  StrCopy( prefs.editor, dummy, ALL )
  Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_COMPILER ), prefs_wnd, NIL,
                     [GTST_STRING,{dummy},NIL] )
  StrCopy( prefs.compiler, dummy, ALL )
  prefs.source_request := getPCB( findGadget( prefs_wnd, PREFS_SOURCE_REQUEST ) )
  Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_SOURCE ), prefs_wnd, NIL,
                     [GTST_STRING,{dummy},NIL] )
  StrCopy( prefs.source, dummy, ALL )
  prefs.opt_reg := getPCB( findGadget( prefs_wnd, PREFS_OPT_REG ) )
  IF prefs.opt_reg
    Gt_GetGadgetAttrsA( findGadget( prefs_wnd, PREFS_REGS ), prefs_wnd, NIL,
                       [GTIN_NUMBER,{dummy},NIL] )
    prefs.regs := dummy
  ELSE
    prefs.regs := 3
  ENDIF
  prefs.opt_large := getPCB( findGadget( prefs_wnd, PREFS_OPT_LARGE ) )
  prefs.opt_sym := getPCB( findGadget( prefs_wnd, PREFS_OPT_SYM ) )
  prefs.opt_asm := getPCB( findGadget( prefs_wnd, PREFS_OPT_ASM ) )
  prefs.opt_ignorecache := getPCB( findGadget( prefs_wnd, PREFS_OPT_IGNORECACHE ) )
  prefs.opt_linedebug := getPCB( findGadget( prefs_wnd, PREFS_OPT_LINEDEBUG ) )
  prefs.opt_debug := getPCB( findGadget( prefs_wnd, PREFS_OPT_DEBUG ) )
  prefs.opt_opti := getPCB( findGadget( prefs_wnd, PREFS_OPT_OPTI ) )
ENDPROC prefs

PROC getPCB( gad:PTR TO gadget )
/************************************************
  holt den CheckBox-Status
************************************************/
  DEF dummy

  Gt_GetGadgetAttrsA( gad, prefs_wnd, NIL,
                     [GTCB_CHECKED,{dummy},NIL] )
ENDPROC dummy

PROC setPCB( gad:PTR TO gadget, set )
/**********************************************
  setzt den CheckBox-Status
**********************************************/

  GtX_SetGadgetAttrsA( prefs_handle, gad,
                      [GTCB_CHECKED,set,NIL] )
ENDPROC

PROC savePrefs( prefs:PTR TO preferences )
/************************************************************
  speichert die Voreinstellungen in der Datei
  "ENVARC:EManager.prefs" ab
************************************************************/
  DEF handle,buf[256]:STRING

  DeleteFile( 'ENVARC:EManager.prefs' )
  IF handle := Open( 'ENVARC:EManager.prefs', NEWFILE )
    StringF( buf, '\s\n', prefs.editor )
    Write( handle, buf, StrLen( buf ) )
    StringF( buf, '\s\n', prefs.source )
    Write( handle, buf, StrLen( buf ) )
    StringF( buf, '\s\n', prefs.compiler )
    Write( handle, buf, StrLen( buf ) )
    writeChar( handle, prefs.source_request )
    writeChar( handle, prefs.opt_reg )
    writeChar( handle, prefs.opt_large )
    writeChar( handle, prefs.opt_sym )
    writeChar( handle, prefs.opt_asm )
    writeChar( handle, prefs.opt_ignorecache )
    writeChar( handle, prefs.opt_linedebug )
    writeChar( handle, prefs.opt_debug )
    writeChar( handle, prefs.opt_opti )
    writeChar( handle, prefs.regs )
    Close( handle )
  ENDIF
ENDPROC


PROC loadPrefs( prefs:PTR TO preferences, utils:PTR TO utilities, wnd )
/*********************************************
  lädt die Voreinstellungen aus der Datei
  "ENVARC:EManager.prefs"
*********************************************/
  DEF handle

  IF prefs = NIL
    prefs := New( SIZEOF preferences )
    prefs.editor := String( 90 )
    prefs.source := String( 90 )
    prefs.compiler := String( 90 )
    prefs.extsource := String( 90 )
  ENDIF
  IF handle := Open( 'ENVARC:EManager.prefs', OLDFILE )
    ReadStr( handle, prefs.editor )
    ReadStr( handle, prefs.source )
    ReadStr( handle, prefs.compiler )
    prefs.source_request := readChar( handle )
    prefs.opt_reg := readChar( handle )
    prefs.opt_large := readChar( handle )
    prefs.opt_sym := readChar( handle )
    prefs.opt_asm := readChar( handle )
    prefs.opt_ignorecache := readChar( handle )
    prefs.opt_linedebug := readChar( handle )
    prefs.opt_debug := readChar( handle )
    prefs.opt_opti := readChar( handle )
    prefs.regs := readChar( handle )
    IF utils THEN loadUtils( utils )
    Close( handle )
  ELSE
    RtEZRequestA( 'Kann Einstellungen\nnicht laden!\n', '_Weiter',
                  NIL, NIL, getRTTags( wnd ) )
  ENDIF
ENDPROC  prefs

PROC writeChar( handle, chr:LONG )
/****************************************
  Shreibt das unterste Byte eines Long-
  wertes in das handle
  (hier rächt sich, daß es in AmigaE
   keinen Datentyp :CHAR gibt!)
  -- supportroutine für savePrefs()
****************************************/

  MOVE.L chr,D0
  LSL.L #8,D0
  LSL.L #8,D0
  LSL.L #8,D0
  MOVE.L D0,chr
  Write( handle, {chr}, 1 )
ENDPROC

PROC readChar( handle )
/*****************************
  Gegenstück zu writeChar()
*****************************/
  DEF buf

  Read( handle, {buf}, 1 )
  MOVE.L buf,D0
  LSR.L #8,D0
  LSR.L #8,D0
  LSR.L #8,D0
ENDPROC D0

PROC editor( prefs:PTR TO preferences )
/***********************************************
  ruft den Editor nach den Voreinstellungen
  auf
***********************************************/
  DEF buf[256]:STRING,
      winlock

  winlock := RtLockWindow( main_wnd )
  print( 0, 'Editor' )
  IF checkSource( prefs ) <> 1
    StringF( buf, '\s \s', prefs.editor, prefs.extsource )
    SetStr( buf, StrLen( buf ) )
    SystemTagList( buf, [NIL] )
  ENDIF
  RtUnlockWindow( main_wnd, winlock )
ENDPROC

PROC compiler( prefs:PTR TO preferences )
/***********************************************
  ruft den Compiler nach den Voreinstellungen
  auf
***********************************************/
  DEF buf[256]:STRING,
      error,
      winlock

  winlock := RtLockWindow( main_wnd )
  print( 0, 'Compiler' )
  IF checkSource( prefs ) = 0
    StringF( buf, '\s >T:EManager.tmp \s \s',
             prefs.compiler, prefs.extsource, genOptions( prefs ) )
    SetStr( buf, StrLen( buf ) )
    IF error := SystemTagList( buf, [NIL] )
      StringF( buf, 'Fehler in Zeile: \d', error )
      print( 1, buf )
      checkCompileGlobal( )
      checkCompileLocal( )
      checkUnref( )
    ELSE
      IF checkCompileGlobal( )
        print( 1, 'Alles in Ordnung' )
        checkUnref( )
      ENDIF
    ENDIF
  ENDIF
  RtUnlockWindow( main_wnd, winlock )
ENDPROC

PROC genOptions( prefs:PTR TO preferences )
/*********************************************************
  generiert die Optionen für den Compiler in einem
  String
*********************************************************/
  DEF buf[256]:STRING

  IF prefs.opt_reg
    StringF( buf, 'REG \d ', prefs.regs )
  ENDIF
  IF prefs.opt_large THEN StrAdd( buf, 'LARGE ', 6 )
  IF prefs.opt_sym THEN StrAdd( buf, 'SYM ', 4 )
  IF prefs.opt_asm THEN StrAdd( buf, 'ASM ', 4 )
  IF prefs.opt_ignorecache THEN StrAdd( buf, 'IGNORECACHE ', 12 )
  IF prefs.opt_linedebug THEN StrAdd( buf, 'LINEDEBUG ', 12 )
  IF prefs.opt_debug THEN StrAdd( buf, 'DEBUG ', 6 )
  IF prefs.opt_opti THEN StrAdd( buf, 'OPTI ', 5 )
  StrAdd( buf, 'ERRLINE', 7 )
  SetStr( buf, StrLen( buf ) )
ENDPROC buf

PROC print( line, text:PTR TO CHAR )
/***************************************************************
  gibt einen Zeile "text" an der Position line (0-2) im
  Hauptfenster als Statusmeldung aus!
***************************************************************/
  DEF xa,ya,xe,ye


  IF line = 0
    SetAPen( main_wnd.rport, 0 )
    xa := tx
    ya := ty
    ye := ya+(5*(ysize+1))
    xe := xa+(33*xsize)
    RectFill( main_wnd.rport, xa, ya, xe, ye )
  ENDIF
  ya := ty+(line*(ysize+1))
  PrintIText(main_wnd.rport,
    [1,0,0,tx,ya,tattr,text,NIL]:intuitext,0,0)
ENDPROC

PROC checkSource( prefs:PTR TO preferences )
/*********************************************************************
  überprüft, ob der Quelltext den anforderungen an den Compiler ent-
  spricht
*********************************************************************/
  DEF lock,
      fib:fileinfoblock,
      fl=0,buf[2]:STRING,
      src[256]:STRING

  IF prefs.source_request
    IF doRequest( '', prefs.source, main_wnd, 'Bitte Quelltext wählen!', '#?.e' )
      StrCopy( src, glob_buf, ALL )
    ELSE
      StrCopy( src, '', ALL )
    ENDIF
  ELSE
    StrCopy( src, prefs.source, ALL )
  ENDIF
  IF StrLen( src )
    IF lock := Lock( src, -2 )
      RightStr( buf, src, 2 )
      IF StrCmp( buf, '.e', 2 )
        IF Examine( lock, fib )
          IF fib.direntrytype > 0
            fl := 1
            print( 1, 'Verzeichnisse nicht erlaubt!' )
          ENDIF
        ENDIF
      ELSE
        print( 1, 'Datei muß auf ".e" enden!' )
        fl := 1
      ENDIF
      UnLock( lock )
    ELSE
      print( 1, 'Datei existiert nicht!' )
      fl := -1
    ENDIF
  ELSE
    print( 1, 'Welche Datei?' )
    fl := -1
  ENDIF
  StrCopy( prefs.extsource, src, ALL )
ENDPROC fl

PROC checkCompileGlobal( )
/*************************************************************
  überprüft die Compilermessage auf globale Fehlermeldungen
*************************************************************/
  DEF handle,
      buf[256]:STRING,
      pos,
      dummy,
      fl=TRUE

  IF handle := Open( 'T:Emanager.tmp', OLDFILE )
    WHILE Fgets( handle, buf, 256 )
      IF ( pos := InStr( buf, 'ERROR', 0 ) ) <> -1
        dummy := buf + pos + 7
        dummy := pString( dummy )
        StringF( buf, 'FEHLER: \l\s[25]', dummy )
        print( 2, buf )
        fl := FALSE
      ENDIF
    ENDWHILE
    Close( handle )
  ENDIF
ENDPROC fl

PROC checkCompileLocal( )
/**************************************************************
  überprüft die Compilermessage auf lokale Fehlermeldungen
**************************************************************/
  DEF handle,
      buf[256]:STRING,
      fl=TRUE,
      pos,
      dummy

  IF handle := Open( 'T:EManager.tmp', OLDFILE )
    WHILE ( ReadStr( handle, buf ) ) <> -1
      IF ( pos := InStr( buf, 'WITH', 0 ) ) <> -1
        dummy := buf + pos + 6
        StrCopy( buf, 'Mit:', 4 )
        StrAdd( buf, dummy, 30 )
        print( 3, buf )
        fl := FALSE
      ENDIF
    ENDWHILE
    Close( handle )
  ENDIF
ENDPROC fl

PROC run( prefs:PTR TO preferences )
/***********************************************************
  führt das compilierte Programm aus
***********************************************************/
  DEF src[256]:STRING,
      buf[256]:STRING,
      buf2[256]:STRING,
      fl=TRUE,
      sel,
      winlock

  print( 0, 'Programm ausführen' )
  winlock := RtLockWindow( main_wnd )
  ->IF checkSource( prefs.source ) <> -1
    IF prefs.source_request
      IF doRequest( '', prefs.source, main_wnd, 'Bitte Programm wählen!', NIL )
        StrCopy( src, glob_buf, ALL )
      ELSE
        fl := FALSE
        StrCopy( src, '', ALL )
      ENDIF
    ELSE
      StrCopy( src, prefs.source, StrLen(prefs.source)-2 )
    ENDIF
  ->ELSE
  ->fl := FALSE
  ->ENDIF

  IF fl
    StringF( buf2, 'Bitte wählen Sie die\n' +
                     'Argumentenzeile für einen\n' +
                     'Shell-Start, bzw den Startmodus aus!\n\n' +
                     'Programm:\n "\s"\n', src )
    IF sel := RtGetStringA( buf, 256, 'Programm ausführen', NIL,
                    [ RT_WINDOW, main_wnd,
                      RT_LOCKWINDOW, TRUE,
                      RT_UNDERSCORE, "_",
                      RTGS_ALLOWEMPTY,TRUE,
                      RTGS_GADFMT, '_Shell|_Workbench|_Abbruch',
                      RTGS_TEXTFMT, buf2,
                      RTGS_FLAGS,GSREQF_CENTERTEXT,
                      NIL ] )
      IF sel = 1
        StringF( buf2, '\s >CON:0/0/\d/\d/EManager-Shell-Ausgabe/CLOSE/WAIT \s',
                 src, scr.width, scr.height, buf )
        SystemTagList( buf2, [NP_CLI,TRUE,
                              NIL] )
      ELSEIF sel = 2
        SystemTagList( src, [NIL] )
      ENDIF
    ENDIF
  ENDIF
  RtUnlockWindow( main_wnd, winlock )
ENDPROC


PROC opentools_window()
  DEF g:PTR TO gadget,x,y,bx,by,ww,wh

  tools_handle := GtX_GetHandleA( [HKH_TAGBASE,NIL,
                                   HKH_USENEWBUTTON,1,
                                   HKH_NEWTEXT,TRUE,
                                   HKH_SETREPEAT,SRF_LISTVIEW,
                                   NIL] )
  x := 2*xsize
  y := 3*ysize+(ysize/2)
  bx := xsize*(GADGETWIDTH+9)
  by := ysize+(ysize/2)
  ww := x+bx+(2*xsize)+(bx)+x
  wh := y+(6*by)+(5*(ysize/4))+ysize+(ysize/3)

  IF (g:=CreateContext({tools_glist}))=NIL THEN RETURN NOCONTEXT
  IF (g:=GtX_CreateGadgetA(tools_handle,BUTTON_KIND,g,
    [x+bx+(2*xsize),y+(4*by)+(5*(ysize/4)),bx,by,
     'Cache _löschen',tattr,TOOLS_CCACHE,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(tools_handle,LISTVIEW_KIND,g,
    [x+bx+(2*xsize),y,(bx),(7*ysize),
     'EModule-_Cache',tattr,TOOLS_SCACHE,4,visual,0]:newgadget,
    [GTLV_LABELS,NIL,
     GTLV_READONLY,1,
     GT_UNDERSCORE,"_",
     NIL]))=NIL
    RETURN NOGADGET
  ELSE
    tools_lv := g
  ENDIF
  IF (g:=GtX_CreateGadgetA(tools_handle,BUTTON_KIND,g,
    [x+(2*xsize),y-by,bx-(4*xsize),by,
     '_Verzeichis anlegen',tattr,TOOLS_MAKEDIR,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(tools_handle,BUTTON_KIND,g,
    [x+(2*xsize),y+(ysize/4),bx-(4*xsize),by,
     '_Datei(en) löschen',tattr,TOOLS_DELETE,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(tools_handle,BUTTON_KIND,g,
    [x+(2*xsize),y+by+(2*(ysize/4)),bx-(4*xsize),by,
     'Datei _umbenennen',tattr,TOOLS_RENAME,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(tools_handle,BUTTON_KIND,g,
    [(ww/2)-(bx/2),y+(5*by)+(4*(ysize/4))+ysize,bx,by,
     '_zurück',tattr,TOOLS_EXIT,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(tools_handle,BUTTON_KIND,g,
    [x+(2*xsize),y+(2*by)+(3*(ysize/4)),bx-(4*xsize),by,
     '_Modul anzeigen',tattr,TOOLS_SHOWMODULE,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(tools_handle,BUTTON_KIND,g,
    [x+(2*xsize),y+(3*by)+(4*(ysize/4)),bx-(4*xsize),by,
     '_Performance',tattr,TOOLS_PROGRAM,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
/***
  IF (g:=GtX_CreateGadgetA(tools_handle,BUTTON_KIND,g,
    [x+(2*xsize),y+(4*by)+(5*(ysize/4)),bx-(4*xsize),by,
     'Vo_reinstellungen',tattr,TOOLS_SETUP,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
***/
  IF (tools_wnd:=OpenWindowTagList(NIL,
      getWinTags(main_wnd.leftedge,main_wnd.topedge+main_wnd.bordertop,ww,wh,
                 tools_glist,'Hilfsmittel') ) ) = NIL THEN RETURN NOWINDOW
  DrawBevelBoxA(tools_wnd.rport,
    x-(xsize),y-by-(ysize/3),bx+(2*xsize),(6*by)+(5*(ysize/4))+(2*ysize/3),
    [GT_VISUALINFO,visual,NIL])
  DrawBevelBoxA(tools_wnd.rport,
    x+bx+(2*xsize)-(xsize),y-by-(ysize/3),(bx)+(2*xsize),(6*by)+(5*(ysize/4))+(2*ysize/3),
    [GT_VISUALINFO,visual,NIL])
  drawButtonFrameG( tools_wnd, findGadget( tools_wnd, TOOLS_EXIT ) )
  GtX_RefreshWindow(tools_handle,tools_wnd,NIL)
ENDPROC

PROC closetools_window()
  IF tools_wnd THEN CloseWindow(tools_wnd)
  IF tools_glist THEN FreeGadgets(tools_glist)
  IF tools_handle THEN GtX_FreeHandle( tools_handle )
ENDPROC


PROC tools( u:PTR TO utilities, p:PTR TO preferences )
  DEF m,
      gad,
      fl=FALSE,
      li,
      winlock,
      ret=FALSE

  print( 0, 'Hilfsmittel' )
  winlock := RtLockWindow( main_wnd )
  IF reporterr(opentools_window())=0
    li := manageCache( u, tools_lv, FALSE )
    REPEAT
      m := wait4message( tools_handle, tools_wnd )
      IF m = IDCMP_GADGETUP
        gad := infos.gadgetid
        SELECT gad
          CASE TOOLS_EXIT
            fl := TRUE
          CASE TOOLS_CCACHE
            GtX_SetGadgetAttrsA( tools_handle, tools_lv,
                                [GTLV_LABELS,NIL,NIL] )
            disposeCache( li )
            li := manageCache( u, tools_lv, TRUE )
          CASE TOOLS_DELETE
            deleteFiles( p.source )
          CASE TOOLS_MAKEDIR
            makedir( p.source )
          CASE TOOLS_RENAME
            rename( p.source )
          CASE TOOLS_SHOWMODULE
            ret := module( u )
            fl := ret
          CASE TOOLS_PROGRAM
            ret := utilities( p, u )
            fl := ret
        ENDSELECT
      ELSEIF m = IDCMP_CLOSEWINDOW
        fl := TRUE
        ret := TRUE
      ELSEIF m = IDCMP_CHANGEWINDOW
        /****
        ChangeWindowBox( main_wnd, tools_wnd.leftedge,
                                   (tools_wnd.topedge)-(tools_wnd.bordertop),
                                   main_wnd.width,
                                   main_wnd.height )
        WindowToFront( tools_wnd )
        ActivateWindow( tools_wnd )
        ****/
      ENDIF
    UNTIL fl
    disposeCache( li )
  ENDIF
  closetools_window()
  RtUnlockWindow( main_wnd, winlock )
ENDPROC ret

PROC getToolTypes( )
  DEF disk:PTR TO diskobject,
      wb:PTR TO wbstartup,
      args:PTR TO wbarg,
      lock,
      buf[256]:STRING,
      buf2[256]:STRING,
      tt:PTR TO CHAR,
      utils:PTR TO utilities

  IF utils := New( SIZEOF utilities )
    utils.flushcache := String( 90 )
    utils.showcache := String( 90 )
    utils.showmodule := String( 90 )
    utils.display := String( 90 )
    utils.ext := p_InitList( )

    IF iconbase := OpenLibrary( 'icon.library', 37 )
      IF lock := GetProgramDir( )
        NameFromLock( lock, buf, 256 )
        IF wbmessage
          wb:=wbmessage
          args:=wb.arglist
          StrCopy( buf2, args[].name, ALL )
        ELSE
          GetProgramName( buf2, 256 )
        ENDIF
        AddPart( buf, buf2, 256 )
        IF disk := GetDiskObject( buf )
          IF tt := FindToolType( disk.tooltypes, 'FLUSHCACHE' )
            StrCopy( utils.flushcache, tt, ALL )
          ELSE
            StrCopy( utils.flushcache, 'FlushCache', ALL )
          ENDIF
          IF tt := FindToolType( disk.tooltypes, 'SHOWCACHE' )
            StrCopy( utils.showcache, tt, ALL )
          ELSE
            StrCopy( utils.showcache, 'ShowCache', ALL )
          ENDIF
          IF tt := FindToolType( disk.tooltypes, 'SHOWMODULE' )
            StrCopy( utils.showmodule, tt, ALL )
          ELSE
            StrCopy( utils.showmodule, 'ShowModule', ALL )
          ENDIF
          IF tt := FindToolType( disk.tooltypes, 'DISPLAY' )
            StrCopy( utils.display, tt, ALL )
          ELSE
            StrCopy( utils.display, 'More', 4 )
          ENDIF
          FreeDiskObject( disk )
        ELSE
          StrCopy( utils.flushcache, 'FlushCache', ALL )
          StrCopy( utils.showcache, 'ShowCache', ALL )
          StrCopy( utils.display, 'More', 4 )
        ENDIF
      ENDIF
      CloseLibrary( iconbase )
    ENDIF
    StrAdd( utils.flushcache, ' >T:EManager.tmp', ALL )
    StrAdd( utils.showcache, ' >T:EManager.tmp', ALL )
    StrAdd( utils.showmodule, ' >T:EManager.tmp ', ALL )
    StrAdd( utils.display, ' T:EManager.tmp', ALL )
    loadUtils( utils )
  ENDIF
ENDPROC utils

PROC loadUtils( u:PTR TO utilities )
  DEF buf[256]:STRING,
      handle

  p_CleanList( u.ext, FALSE, NIL, LIST_CLEAN )
  IF handle := Open( 'ENVARC:EManager.utils', OLDFILE )
    WHILE Fgets( handle, buf, 256 )
      StrCopy( buf, buf, StrLen(buf)-1 )
      p_AjouteNode( u.ext, buf, NIL )
    ENDWHILE
    Close( handle )
  ENDIF
ENDPROC

PROC saveUtils( u:PTR TO utilities )
  DEF buf[256]:STRING,
      node:PTR TO ln,
      handle,
      num,cnt

  IF handle := Open( 'ENVARC:EManager.utils', NEWFILE )
    IF num := p_CountNodes( u.ext )
      DEC num
      FOR cnt := 0 TO num
        node := p_GetAdrNode( u.ext, cnt )
        StringF( buf, '\s\n', node.name )
        Fputs( handle, buf )
      ENDFOR
    ENDIF
    Close( handle )
  ENDIF
ENDPROC


PROC freeToolTypes( utils:PTR TO utilities )
  SetStr( utils.flushcache, 0 )
  SetStr( utils.showcache, 0 )
  SetStr( utils.showmodule, 0 )
  IF utils.ext THEN p_CleanList( utils.ext, FALSE, NIL, LIST_REMOVE )
  Dispose( utils )
ENDPROC

PROC manageCache( utils:PTR TO utilities, lvgad:PTR TO gadget, mode )
  DEF handle,
      buf[256]:STRING,
      li,
      dummy,
      fl=FALSE

  IF mode
    SystemTagList( utils.flushcache, [NIL] )
  ENDIF
  IF li := p_InitList( )
    SystemTagList( utils.showcache, [NIL] )
    IF handle := Open( 'T:EManager.tmp', OLDFILE )
      Fgets( handle, buf, 256 )
      IF StrCmp( buf, 'Emodule Cache Show', 18 )
        Fgets( handle, buf, 256 )
        Fgets( handle, buf, 256 )
        IF StrCmp( buf, 'Empty cache.', 12 ) = FALSE
          IF StrCmp( buf, 'size', 4 )
            Fgets( handle, buf, 256 )
            REPEAT
              Fgets( handle, buf, 256 )
              StrCopy( buf, buf, StrLen(buf)-1 )
              IF StrLen( buf ) > 2
                dummy := PathPart( buf )
                p_AjouteNode( li, dummy, NIL )
              ELSE
                fl := TRUE
              ENDIF
            UNTIL fl
            GtX_SetGadgetAttrsA( tools_handle, lvgad, [GTLV_LABELS,li,NIL] )
          ENDIF
        ENDIF
      ELSE
        li := disposeCache( li )
      ENDIF
      Close( handle )
    ELSE
      li := disposeCache( li )
    ENDIF
  ELSE
    li := NIL
  ENDIF
ENDPROC li

PROC disposeCache( li )
  IF li THEN p_CleanList( li, NIL, FALSE, LIST_REMOVE )
ENDPROC NIL

PROC pString( buf:PTR TO CHAR )
  DEF len:REG,cnt:REG

  len := StrLen( buf )
  FOR cnt := 0 TO len
    IF buf[cnt] = $0A THEN buf[cnt] := $20
  ENDFOR
ENDPROC buf

PROC makedir( pat:PTR TO CHAR )
  DEF buf[256]:STRING,
      buf2[256]:STRING,
      lock

  selectPath( pat )
  IF doRequest( '', glob_buf, tools_wnd, 'Bitte Ursprungsverzeichnis wählen!',
                NIL, FREQF_NOFILES )
    StringF( buf2, 'Bitte geben Sie den Namen\n' +
                   'des neuen Verzeichnisses\n' +
                   'an, das im Verzeichnis\n' +
                   '"\s"\n' +
                   'angelegt werden soll!\n', glob_buf )
    IF RtGetStringA( buf, 256, 'Verzeichnis anlegen', NIL,
                    [ RT_WINDOW, main_wnd,
                      RT_LOCKWINDOW, TRUE,
                      RT_UNDERSCORE, "_",
                      RTGS_GADFMT, '_Erzeugen|_Abbruch',
                      RTGS_TEXTFMT, buf2,
                      RTGS_FLAGS,GSREQF_CENTERTEXT,
                      NIL ] )
      AddPart( glob_buf, buf, 256 )
      IF lock := CreateDir( glob_buf )
        UnLock( lock )
      ELSE
        RtEZRequestA( 'Kann Verzeichnis nicht anlegen!', '_OK',
                          NIL, NIL, getRTTags( tools_wnd ) )
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC deleteFiles( pat:PTR TO CHAR )
  DEF buf[256]:STRING,
      fl:PTR TO rtfilelist,
      entry:PTR TO rtfilelist,
      req:PTR TO rtfilerequester

  selectPath( pat )
  IF req := RtAllocRequestA( RT_FILEREQ, NIL )
    RtChangeReqAttrA( req, [ RTFI_DIR, glob_buf,
                             RTFI_MATCHPAT, '#?',
                             NIL ] )

    IF fl := RtFileRequestA( req, buf, 'Bitte Files zum löschen wählen!',
                                              [ RT_WINDOW, tools_wnd,
                                                RT_REQPOS, REQPOS_POINTER,
                                                RT_LOCKWINDOW, TRUE,
                                                RTFI_FLAGS, FREQF_MULTISELECT,
                                                NIL ] )
      entry := fl
      REPEAT
        StrCopy( buf, req.dir, ALL )
        AddPart( buf, entry.name, 256 )
        StringF( glob_buf, 'Datei\n"\s"\nwirklich löschen?', buf )
        IF RtEZRequestA( glob_buf, '_Ja|_Nein',
                                 NIL, NIL, getRTTags( tools_wnd ) )
          IF DeleteFile( buf )
          ELSE
            StringF( glob_buf, 'Kann Datei\n"\s"\nnich löschen!', buf )
            RtEZRequestA( glob_buf, '_OK',
                          NIL, NIL, getRTTags( tools_wnd ) )
          ENDIF
        ENDIF
        entry := entry.next
      UNTIL entry = 0
      RtFreeFileList( fl )
    ENDIF
    RtFreeRequest( req )
  ENDIF
ENDPROC

PROC rename( pat:PTR TO CHAR )
  DEF dummy,
      buf[256]:STRING,
      buf2[256]:STRING,
      sel,
      handleA,handleB,
      char

  selectPath( pat )
  IF doRequest( buf, glob_buf, tools_wnd, 'Bitte Ursprungsverzeichnis wählen!',
                NIL )
    StringF( buf2, 'Bitte geben Sie den neuen Dateinamen\n' +
                   'für "\s" an.\n', glob_buf )
    StrCopy( buf, glob_buf, ALL )
    IF sel := RtGetStringA( buf, 256, 'Datei umbenennen', NIL,
                           [ RT_WINDOW, main_wnd,
                             RT_LOCKWINDOW, TRUE,
                             RT_UNDERSCORE, "_",
                             RTGS_GADFMT, '_Umbenennen|_Neu erzeugen|_Abbruch',
                             RTGS_TEXTFMT, buf2,
                             RTGS_FLAGS,GSREQF_CENTERTEXT,
                             NIL ] )
      dummy := PathPart( glob_buf )
      StrCopy( buf2, glob_buf, StrLen(glob_buf)-StrLen(dummy) )
      AddPart( buf2, buf, 256 )
      IF sel = 1
        Rename( glob_buf, buf2 )
      ELSEIF sel = 2
        IF handleA := Open( glob_buf, OLDFILE )
          IF handleB := Open( buf2, NEWFILE )
            WHILE ( char := FgetC( handleA ) ) <> -1 DO FputC( handleB, char )
            Close( handleB )
          ENDIF
          Close( handleA )
        ENDIF
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC checkUnref( )
  DEF handle,
    buf[256]:STRING,
    pos,
    dummy

  IF handle := Open( 'T:Emanager.tmp', OLDFILE )
    WHILE Fgets( handle, buf, 256 )
      IF ( pos := InStr( buf, 'UNREFERENCED', 0 ) ) <> -1
        dummy := buf + pos + 14
        pString( dummy )
        StringF( buf, 'UNREF: \l\s[25]', dummy )
        print( 3, buf )
      ENDIF
    ENDWHILE
    Close( handle )
  ENDIF
ENDPROC

PROC getRTTags( win )
  DEF tags:PTR TO LONG

  tags := [ RT_WINDOW, win,
            RT_LOCKWINDOW, TRUE,
            RT_REQPOS, REQPOS_POINTER,
            RT_UNDERSCORE, "_",
            RTEZ_REQTITLE, 'Achtung!',
            RTEZ_FLAGS,EZREQF_CENTERTEXT,
            NIL ]:LONG
ENDPROC tags

PROC drawButtonFrameG( win:PTR TO window, gad:PTR TO gadget, color=1 )
/****************************************************************************
  Funktion : Zeichnet einen einfarbigen Rahmen um ein Gadget. Die E-Funktion
             "Box()" habe ich bewußt umgangen (naja, ich habe die E-Doku nicht
             richtig gelesen...)
  Parameter : win = Zeiger auf das Fenster, in dem gearbeitet werden soll
              gad = Zeiger auf das Gadget, das umrahmt werden soll
              color = Farbnummer, in der gezeichnet werden soll
  Zurück : nichts
****************************************************************************/

  DEF x,y,dx,dy

  SetAPen( win.rport, color )
  x := gad.leftedge-1
  y := gad.topedge-1
  dx := gad.width
  dy := gad.height
  drawFrame( win.rport, x, y, dx, dy )
ENDPROC

PROC drawFrame( rport, x, y, dx, dy )
/************************************
  Funktion : zeichnet den Rahmen für
             "drawButtonFrameG()" und
             "drawButtonFrameOld()"
  Parameter : rport = RastPort des
                      Fensters
              x, y, dx, dy, color
              wie oben
  Zurück : nichts

Diese Funktion sollte nur intern
erreichbar sein!
************************************/

  Move( rport, x, y )
  PolyDraw( rport, 4, [(x+dx),y,
                       (x+dx),(y+dy+1),
                       x,(y+dy+1),
                       x,y]:INT )
  Move( rport, (x-1), y )
  Draw( rport, (x-1), (y+dy+1) )
  Move( rport, (x+dx+1), y )
  Draw( rport, (x+dx+1), (y+dy+1) )
ENDPROC

PROC selectPath( str:PTR TO CHAR )
  DEF pos

  pos := FilePart( str )
  IF pos = str
    glob_buf[] := 0
  ELSE
    StrCopy( glob_buf, str, StrLen(str)-StrLen(pos) )
  ENDIF
ENDPROC


PROC openmodule_window()
  DEF g:PTR TO gadget,
      x,y,bx,by,ww,wh

  module_handle := GtX_GetHandleA( [HKH_TAGBASE,NIL,
                                    HKH_USENEWBUTTON,1,
                                    HKH_NEWTEXT,TRUE,
                                    HKH_SETREPEAT,SRF_LISTVIEW,
                                    NIL] )

  x := (2*xsize)
  y := (2*ysize)
  by := ysize+(ysize/2)
  bx := (xsize*GADGETWIDTH)

  ww := (2*x)+(53*xsize)
  wh := y+(3*by)+(10*ysize)+(ysize/2)

  IF (g:=CreateContext({module_glist}))=NIL THEN RETURN NOCONTEXT
  IF (g:=GtX_CreateGadgetA(module_handle,LISTVIEW_KIND,g,
    [x,y+(2*by)+(ysize/2),(53*xsize),(9*ysize),'_Modulinhalt:',tattr,MOD_DISPLAY,4,visual,0]:newgadget,
    [GTLV_LABELS,NIL,
     GTLV_READONLY,1,
     GT_UNDERSCORE,"_",
     NIL]))=NIL
    RETURN NOGADGET
  ELSE
    mod_lv := g
  ENDIF
  IF (g:=GtX_CreateGadgetA(module_handle,TEXT_KIND,g,
    [x+(ww/2)-bx,y+(ysize/2),(2*bx),by,'Modul:',tattr,MOD_FILE,1,visual,0]:newgadget,
    [GTTX_BORDER,1,
     NIL]))=NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(module_handle,BUTTON_KIND,g,
    [x,y+(2*by)+(10*ysize),bx,by,'_Anderes Modul',tattr,MOD_SELECT,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (g:=GtX_CreateGadgetA(module_handle,BUTTON_KIND,g,
    [ww-x-bx,y+(2*by)+(10*ysize),bx,by,'_Zurück',tattr,MOD_EXIT,16,visual,0]:newgadget,
     b_tags ) ) = NIL
    RETURN NOGADGET
  ENDIF
  IF (module_wnd:=OpenWindowTagList(NIL,
      getWinTags(tools_wnd.leftedge,tools_wnd.topedge+tools_wnd.bordertop,ww,wh,
                 module_glist,'Modulinhalt anzeigen') ) ) = NIL THEN RETURN NOWINDOW
  DrawBevelBoxA(module_wnd.rport,x-xsize,y,ww-(2*(x-xsize)),
                                (2*by)+(10*ysize)-(ysize/3),
    [GT_VISUALINFO,visual,
     NIL])
  drawButtonFrameG( module_wnd, findGadget( module_wnd, MOD_SELECT ) )
  GtX_RefreshWindow(module_handle,module_wnd,NIL)
ENDPROC

PROC closemodule_window()
  IF module_wnd THEN CloseWindow(module_wnd)
  IF module_glist THEN FreeGadgets(module_glist)
  IF module_handle THEN GtX_FreeHandle( module_handle )
ENDPROC

PROC module( u:PTR TO utilities )
  DEF m,
      gad,
      fl=FALSE,
      winlock,
      req:PTR TO rtfilerequester,
      buf[256]:STRING,
      li=0,
      ret=FALSE

  winlock := RtLockWindow( tools_wnd )
  IF reporterr(openmodule_window())=0
    IF req := RtAllocRequestA( RT_FILEREQ, NIL )
      RtChangeReqAttrA( req, [ RTFI_DIR, 'EMODULES:',
                               RTFI_MATCHPAT, '#?.m',
                               NIL ] )
      IF RtFileRequestA( req, buf, 'Bitte Modul wählen!',
                                          [ RT_WINDOW, module_wnd,
                                            RT_REQPOS, REQPOS_POINTER,
                                            RT_LOCKWINDOW, TRUE,
                                            RTFI_FLAGS, FREQF_PATGAD,
                                            NIL ] )
        StrCopy( glob_buf, req.dir, ALL )
        AddPart( glob_buf, buf, 256 )
        GtX_SetGadgetAttrsA( module_handle, findGadget( module_wnd, MOD_FILE ),
                             [GTTX_TEXT,glob_buf,NIL] )
        li := getModule( li, u, glob_buf )
        GtX_SetGadgetAttrsA( module_handle, mod_lv,
                             [GTLV_LABELS,li,NIL] )
        REPEAT
          m := wait4message(module_handle,module_wnd)
          IF m = IDCMP_GADGETUP
            gad := infos.gadgetid
            SELECT gad
              CASE MOD_EXIT
                fl := TRUE
              CASE MOD_SELECT
                IF RtFileRequestA( req, buf, 'Bitte Modul wählen!',
                                                    [ RT_WINDOW, module_wnd,
                                                      RT_REQPOS, REQPOS_POINTER,
                                                      RT_LOCKWINDOW, TRUE,
                                                      RTFI_FLAGS, FREQF_PATGAD,
                                                      NIL ] )
                  StrCopy( glob_buf, req.dir, ALL )
                  AddPart( glob_buf, buf, 256 )
                  GtX_SetGadgetAttrsA( module_handle, findGadget( module_wnd, MOD_FILE ),
                                       [GTTX_TEXT,glob_buf,NIL] )
                  getModule( li, u, glob_buf )
                  GtX_SetGadgetAttrsA( module_handle, mod_lv,
                                       [GTLV_LABELS,li,
                                        GTLV_TOP,0,
                                        NIL] )
                ENDIF
            ENDSELECT
          ELSEIF m = IDCMP_CLOSEWINDOW
            fl := TRUE
            ret := TRUE
          ELSEIF m = IDCMP_CHANGEWINDOW
            /****
            ChangeWindowBox( tools_wnd, module_wnd.leftedge,
                                   (module_wnd.topedge)-(module_wnd.bordertop),
                                   tools_wnd.width,
                                   tools_wnd.height )
            ChangeWindowBox( main_wnd, module_wnd.leftedge,
              (module_wnd.topedge)-(tools_wnd.bordertop)-(module_wnd.bordertop),
                                   main_wnd.width,
                                   main_wnd.height )
            WindowToBack( main_wnd )
            WindowToFront( module_wnd )
            ActivateWindow( module_wnd )
            ****/
          ENDIF
        UNTIL fl
        disposeCache( li )
      ENDIF
      RtFreeRequest( req )
    ENDIF
  ENDIF
  closemodule_window()
  RtUnlockWindow( tools_wnd, winlock )
ENDPROC ret

PROC getModule( list, u:PTR TO utilities, name:PTR TO CHAR )
  DEF handle,
      buf[256]:STRING,
      pos,
      winlock

  winlock := RtLockWindow( module_wnd )
  disposeCache( list )
  IF list := p_InitList( )
    StrCopy( buf, u.showmodule, ALL )
    StrAdd( buf, name, ALL )
    SystemTagList( buf, [NIL] )
    IF handle := Open( 'T:EManager.tmp', OLDFILE )
      FOR pos := 0 TO 3 DO Fgets( handle, buf, 256 )
      WHILE Fgets( handle, buf, 256 )
        StrCopy( buf, buf, (StrLen(buf)-1) )
        IF StrLen( buf ) = 1 THEN buf[] := 0
        IF pos := InStr( buf, '    ', 0 )
          StrCopy( buf, buf, pos )
        ENDIF
        p_AjouteNode( list, buf, NIL )
      ENDWHILE
      Close( handle )
    ENDIF
  ENDIF
  RtUnlockWindow( module_wnd, winlock )
ENDPROC list

PROC init( )
  DEF node:PTR TO ln,
      fl

  Forbid( )
  myport := FindPort( 'EManagement' )
  Permit( )
  IF myport 
    StringF( glob_buf, 'Ein EManager-Programm läuft bereits!\n' +
                       'Sicherlich ist es auch besser, es dabei\n' +
                       'zu belassen.\n' )
    EasyRequestArgs(0,[20,0,0,glob_buf,'ok'],0,[NIL])
    fl := FALSE
  ELSE
    IF myport := CreateMsgPort( )
      node := myport.ln
      node.name := 'EManagement'
      AddPort( myport )
      fl := TRUE
    ELSE
      myport := NIL
      fl := FALSE
    ENDIF
  ENDIF
ENDPROC fl

PROC remove( )
  IF myport
    RemPort( myport )
    DeleteMsgPort( myport )
  ENDIF
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


PROC openutils_window( list )
  DEF g:PTR TO gadget,
      x,y,bx,by,ww,wh

  utils_handle := GtX_GetHandleA( [HKH_TAGBASE,NIL,
                                   HKH_USENEWBUTTON,1,
                                   HKH_NEWTEXT,TRUE,
                                   HKH_SETREPEAT,SRF_LISTVIEW,
                                   NIL] )

  x := (2*xsize)
  y := (3*ysize)
  by := ysize+(ysize/2)
  bx := 12*xsize

  ww := (2*x)+(50*xsize)
  wh := y+(ysize*10)+(2*by)+(ysize/2)

  IF p_CountNodes( list ) = 0 THEN list := NIL

  IF (g:=CreateContext({utils_glist}))=NIL THEN RETURN NOCONTEXT
  IF (g:=GtX_CreateGadgetA(utils_handle,STRING_KIND,g,
    [x+(3*xsize)+1,y+(7*ysize),(50*xsize)-(3*xsize)-1,by,'',tattr,UTILS_ENTRY,0,visual,0]:newgadget,
    [$80030024,0,
     GTST_MAXCHARS,256,
     NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=GtX_CreateGadgetA(utils_handle,LISTVIEW_KIND,g,
    [x,y+(ysize/2),(50*xsize),(6*ysize),'_Programmiertools',tattr,UTILS_ENTRIES,4,visual,0]:newgadget,
    [GTLV_LABELS,list,
     GT_UNDERSCORE,"_",
     GTLV_SHOWSELECTED,NIL,
     NIL]))=NIL
    RETURN NOGADGET
  ELSE
    utils_lv := g
  ENDIF
  IF (g:=GtX_CreateGadgetA(utils_handle,BUTTON_KIND,g,
    [x,y+(7*ysize),(3*xsize),by,'_?',tattr,UTILS_SELECT,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=GtX_CreateGadgetA(utils_handle,BUTTON_KIND,g,
    [x+xsize,y+(9*ysize),bx,by,'_Hinzufügen',tattr,UTILS_ADD,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=GtX_CreateGadgetA(utils_handle,BUTTON_KIND,g,
    [((ww-bx)/2),y+(9*ysize),bx,by,'Lös_chen',tattr,UTILS_DELETE,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=GtX_CreateGadgetA(utils_handle,BUTTON_KIND,g,
    [x,y+(10*ysize)+by,bx,by,'_Laden',tattr,UTILS_LOAD,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=GtX_CreateGadgetA(utils_handle,BUTTON_KIND,g,
    [((ww-bx)/2),y+(ysize*10)+by,bx,by,'_Sichern',tattr,UTILS_SAVE,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=GtX_CreateGadgetA(utils_handle,BUTTON_KIND,g,
    [(ww-x-bx),y+(ysize*10)+by,bx,by,'_Zurück',tattr,UTILS_RETURN,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=GtX_CreateGadgetA(utils_handle,BUTTON_KIND,g,
    [(ww-x-bx-xsize),y+(ysize*9),bx,by,'S_tart',tattr,UTILS_RUN,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL]))=NIL THEN RETURN NOGADGET
  IF (utils_wnd:=OpenWindowTagList(NIL,
      getWinTags(tools_wnd.leftedge,tools_wnd.topedge+tools_wnd.bordertop,ww,wh,
                 utils_glist,'weitere Programme') ) ) = NIL THEN RETURN NOWINDOW
  DrawBevelBoxA(utils_wnd.rport,x-xsize,y-by,ww-(2*(x-xsize)),(9*ysize)+(2*by)+(ysize/2),
    [GT_VISUALINFO,visual,
     GTBB_FRAMETYPE,BBFT_RIDGE,
     ->GTBB_RECESSED,TRUE,
     NIL])
  drawButtonFrameG( utils_wnd, findGadget( utils_wnd, UTILS_LOAD ) )
  drawButtonFrameG( utils_wnd, findGadget( utils_wnd, UTILS_SAVE ) )
->  drawButtonFrameG( utils_wnd, findGadget( utils_wnd, UTILS_DELETE ) )
->  drawButtonFrameG( utils_wnd, findGadget( utils_wnd, UTILS_ADD ) )
  drawButtonFrameG( utils_wnd, findGadget( utils_wnd, UTILS_RUN ) )
  GtX_RefreshWindow(utils_handle,utils_wnd,NIL)
ENDPROC

PROC closeutils_window()
  IF utils_wnd THEN CloseWindow(utils_wnd)
  IF utils_glist THEN FreeGadgets(utils_glist)
  IF utils_handle THEN GtX_FreeHandle(utils_handle)
ENDPROC


PROC utilities( p:PTR TO preferences, u:PTR TO utilities )
  DEF m,
      fl=FALSE,
      gad,
      req:PTR TO rtfilerequester,
      buf[256]:STRING,
      winlock,
      dummy,
      dummy2,
      node:PTR TO ln,
      ret=FALSE

  winlock := RtLockWindow( tools_wnd )
  IF reporterr(openutils_window( u.ext ))=0
    IF req := RtAllocRequestA( RT_FILEREQ, NIL )
      IF u.ext
        p_SortList( u.ext )
        REPEAT
          m := wait4message(utils_handle,utils_wnd)
          IF m = IDCMP_GADGETUP
            gad := infos.gadgetid
            SELECT gad
              CASE UTILS_RETURN
                fl := TRUE
              CASE UTILS_SELECT
                GtX_SetGadgetAttrsA( utils_handle, utils_lv,
                                      [GTLV_SELECTED,-1,NIL] )

                IF RtFileRequestA( req, buf, 'Bitte Modul wählen!',
                                              [ RT_WINDOW, utils_wnd,
                                                RT_REQPOS, REQPOS_POINTER,
                                                RT_LOCKWINDOW, TRUE,
                                                RTFI_FLAGS, FREQF_PATGAD,
                                                NIL ] )
                  StrCopy( glob_buf, req.dir, ALL )
                  AddPart( glob_buf, buf, 256 )
                  dummy := findGadget( utils_wnd, UTILS_ENTRY )
                  GtX_SetGadgetAttrsA( utils_handle, dummy,
                                       [GTST_STRING,glob_buf,NIL] )
                  ActivateGadget( dummy, utils_wnd, NIL )
                ENDIF
              CASE UTILS_ADD
                buf[] := 0
                dummy := findGadget( utils_wnd, UTILS_ENTRY )
                Gt_GetGadgetAttrsA( dummy, utils_wnd, NIL,
                                    [GTST_STRING,{dummy2},NIL] )
                  StrCopy( buf, dummy2, ALL )
                IF buf[]
                  GtX_SetGadgetAttrsA( utils_handle, dummy,
                                      [GTST_STRING,'',NIL] )
                  dummy := p_AjouteNode( u.ext, buf, NIL )
                  p_SortList( u.ext )
                  GtX_SetGadgetAttrsA( utils_handle, utils_lv,
                                       [GTLV_LABELS,u.ext,
                                        GTLV_SELECTED,-1,
                                        NIL] )
                ENDIF
              CASE UTILS_DELETE
                Gt_GetGadgetAttrsA( utils_lv, utils_wnd, NIL,
                                    [GTLV_SELECTED,{dummy},NIL] )
                p_EnleveNode( u.ext, dummy, FALSE, NIL )
                GtX_SetGadgetAttrsA( utils_handle, utils_lv,
                                     [GTLV_LABELS,u.ext,
                                      GTLV_SELECTED,-1,
                                      NIL] )
                GtX_SetGadgetAttrsA( utils_handle, findGadget( utils_wnd, UTILS_ENTRY ),
                                    [GTST_STRING,'',NIL] )
              CASE UTILS_ENTRIES
                Gt_GetGadgetAttrsA( utils_lv, utils_wnd, NIL,
                                   [GTLV_SELECTED,{dummy},NIL] )
                node := p_GetAdrNode( u.ext, dummy )
                StrCopy( glob_buf, node.name, ALL )
                GtX_SetGadgetAttrsA( utils_handle, findGadget( utils_wnd, UTILS_ENTRY ),
                                    [GTST_STRING,glob_buf,NIL] )
              CASE UTILS_ENTRY
                GtX_SetGadgetAttrsA( utils_handle, utils_lv,
                                     [GTLV_SELECTED,-1,
                                      NIL] )
              CASE UTILS_SAVE
                saveUtils( u )
              CASE UTILS_LOAD
                loadUtils( u )
                GtX_SetGadgetAttrsA( utils_handle, utils_lv,
                                     [GTLV_LABELS,u.ext,
                                      GTLV_SELECTED,-1,
                                      NIL] )
              CASE UTILS_RUN
                Gt_GetGadgetAttrsA( utils_lv, utils_wnd, NIL,
                                   [GTLV_SELECTED,{dummy},NIL] )
                node := p_GetAdrNode( u.ext, dummy )
                StrCopy( glob_buf, node.name, ALL )
                runUtility( p, glob_buf, u )
            ENDSELECT
          ELSEIF m = IDCMP_CLOSEWINDOW
            fl := TRUE
            ret := TRUE
          ELSEIF m = IDCMP_CHANGEWINDOW
            /****
            ChangeWindowBox( tools_wnd, utils_wnd.leftedge,
                                   (utils_wnd.topedge)-(utils_wnd.bordertop),
                                   tools_wnd.width,
                                   tools_wnd.height )
            ChangeWindowBox( main_wnd, utils_wnd.leftedge,
              (utils_wnd.topedge)-(tools_wnd.bordertop)-(utils_wnd.bordertop),
                                   main_wnd.width,
                                   main_wnd.height )
            WindowToBack( main_wnd )
            WindowToFront( utils_wnd )
            ActivateWindow( utils_wnd )
            ****/
          ENDIF
        UNTIL fl
      ENDIF
      RtFreeRequest( req )
    ENDIF
  ENDIF
  closeutils_window()
  RtUnlockWindow( tools_wnd, winlock )
ENDPROC ret

PROC runUtility( prefs:PTR TO preferences, name:PTR TO CHAR, u:PTR TO utilities )
  DEF util[256]:STRING,
      para[256]:STRING,
      buf[256]:STRING,
      oldpos,
      pos,
      dummy,
      opts=0,
      pat[30]:STRING,
      req:PTR TO rtfilerequester,
      winlock,
      fl=TRUE

  winlock := RtLockWindow( utils_wnd )
  IF ( pos := InStr( name, '{', 0 ) ) <> -1
    StrCopy( util, name, (pos-1) )
    dummy := name + pos + 1
    StrCopy( para, dummy, ALL )
    IF ( pos := InStr( para, '}', 0 ) ) <> 0
      StrCopy( para, para, pos )
      pos := 0
      oldpos := 0
      WHILE ( pos := InStr( para, '|', oldpos ) ) <> -1
        dummy := para + oldpos
        StrCopy( buf, dummy, (pos-oldpos) )
        opts := getOpts( buf, opts )
        IF ( opts AND MODE_PATTERN ) THEN StrCopy( pat, buf, ALL )
        oldpos := pos+1
      ENDWHILE
      dummy := para + oldpos
      StrCopy( buf, dummy, ALL )
      opts := getOpts( buf, opts )
      StrCopy( pat, buf, ALL )
    ENDIF
  ELSE
    StrCopy( util, name, ALL )
  ENDIF
  IF req := RtAllocRequestA( RT_FILEREQ, NIL )
    IF ( opts AND MODE_NOARGS )
      buf[] := 0
    ELSE
      IF ( opts AND MODE_PATTERN )
        opts := opts OR MODE_REQUEST
      ELSE
        StrCopy( pat, '#?', 2 )
      ENDIF
      IF ( opts AND MODE_SOURCE )
        IF prefs.source_request = 0
          opts := opts AND MODE_NOREQUEST
          StrCopy( buf, prefs.source, ALL )
        ELSE
          opts := opts OR MODE_REQUEST
        ENDIF
      ENDIF
    ENDIF
    IF ( opts AND MODE_REQUEST )
      IF prefs.source_request
        StrCopy( glob_buf, prefs.source, ALL )
      ELSE
        StrCopy( glob_buf, prefs.source, ALL )
        pos := FilePart( glob_buf )
        StrCopy( glob_buf, glob_buf, StrLen(glob_buf)-StrLen(pos) )
      ENDIF
      buf[] := 0
      RtChangeReqAttrA( req, [ RTFI_DIR, glob_buf,
                               RTFI_MATCHPAT, pat,
                               NIL ] )
      IF RtFileRequestA( req, buf, 'Bitte Datei wählen!',
                                          [ RT_WINDOW, utils_wnd,
                                            RT_REQPOS, REQPOS_POINTER,
                                            RT_LOCKWINDOW, TRUE,
                                            RTFI_FLAGS, FREQF_PATGAD,
                                            NIL ] )
        StrCopy( glob_buf, req.dir, ALL )
        AddPart( glob_buf, buf, 256 )
        StrCopy( buf, glob_buf, ALL )
      ELSE
        fl := FALSE
      ENDIF
    ENDIF
    IF fl
      IF ( opts AND MODE_DELETESUFFIX )
        pos := InStr( buf, '.', 0 )
        StrCopy( buf, buf, pos )
      ENDIF
      IF ( opts AND MODE_SHELL )
        IF ( opts AND MODE_DISPLAY )
          StrAdd( util, ' >T:EManager.tmp ', ALL )
        ELSE
          StrAdd( util, ' >CON:0/0/400/150/Ausgabefenster/CLOSE/WAIT ', ALL )
        ENDIF
        StrAdd( util, buf, ALL )
        StrCopy( util, util, ALL )
        SystemTagList( util, [NP_CLI,TRUE,NIL] )
        IF ( opts AND MODE_DISPLAY )
          SystemTagList( u.display, [NP_CLI,TRUE,NIL] )
        ENDIF
      ELSE
        SystemTagList( util, [NIL] )
      ENDIF
    ENDIF
    RtFreeRequest( req )
  ENDIF
  RtUnlockWindow( utils_wnd, winlock )
ENDPROC

PROC getOpts( buf:PTR TO CHAR, opts )
  DEF dummy, pat[30]:STRING

  IF StrCmp( buf, 'SHELL', 5 )
    opts := opts OR MODE_SHELL
  ENDIF
  IF StrCmp( buf, 'WB',2 )
    opts := opts AND MODE_WORKBENCH
  ENDIF
  IF StrCmp( buf, 'SRC', 3 )
    opts := opts OR MODE_SOURCE
  ENDIF
  IF StrCmp( buf, 'REQ', 3 )
    opts := opts OR MODE_REQUEST
  ENDIF
  IF StrCmp( buf, 'DSX', 3 )
    opts := opts OR MODE_DELETESUFFIX
  ENDIF
  IF StrCmp( buf, 'DISPLAY', 7 )
    opts := opts OR (MODE_DISPLAY+MODE_SHELL)
  ENDIF
  IF StrCmp( buf, 'PAT', 3 ) /*** Diese Option muß als letzte angegeben werden! ***/
    opts := opts OR MODE_PATTERN
    dummy := buf + 4
    StrCopy( pat, dummy, ALL )
  ENDIF
  IF StrCmp( buf, 'NOARGS', 6 )
    opts := opts OR MODE_NOARGS
    opts := ( opts AND MODE_NOARGS2 )
    buf[] := 0
  ENDIF
  StrCopy( buf, pat, ALL )
ENDPROC opts
