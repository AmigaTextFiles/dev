/*"Libraries Proc"*/
/*"p_OpenLibraries() :Ouvre les libraries."*/
PROC p_OpenLibraries() HANDLE 
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (diskfontbase:=OpenLibrary('diskfont.library',37))=NIL THEN Raise(ER_DISKFONTLIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))=NIL THEN Raise(ER_REQTOOLSLIB)
    IF (mathtransbase:=OpenLibrary('mathtrans.library',37))=NIL THEN Raise(ER_MATHTRANSLIB)
    IF (rexxsysbase:=OpenLibrary('rexxsyslib.library',36))=NIL THEN Raise(ER_REXXSYSLIBLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_CloseLibraries() :Ferme les libraries."*/
PROC p_CloseLibraries()  
    IF rexxsysbase THEN CloseLibrary(rexxsysbase)
    IF mathtransbase THEN CloseLibrary(mathtransbase)
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF diskfontbase THEN CloseLibrary(diskfontbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
/**/
/**/
/*"Screen Proc"*/
/*"p_SetUpScreen() :Ouvre l'écran."*/
PROC p_SetUpScreen() HANDLE 
    DEF ps:PTR TO screen
    DEF t
    /*==== Install Fonts ====*/
    tattr:=['ruby.font',15,0,0]:textattr
    IF (t:=OpenDiskFont(tattr))=NIL THEN Raise(ER_FONT)
    myfont:=OpenFont(tattr)
    IF (ps:=OpenScreenTagList(NIL,          /* get ourselves a public screen */
                                 [SA_TOP,0,
                                  SA_DEPTH,3,             /*                         */
                                  SA_FONT,tattr,              /*                         */
                                  SA_DISPLAYID,SUPERLACE_KEY,          /* le champ SA_DISPLAYID           */
                                  SA_PUBNAME,'3DScreen',
                                  SA_TITLE,'3Dview v0.9 © 1994 NasGûl',
                                  SA_PUBSIG,IF (screensig:=AllocSignal(-1))=NIL THEN Raise(ER_SCREENSIG) ELSE screensig,
                                  SA_AUTOSCROLL,TRUE,
                                  SA_TYPE,CUSTOMSCREEN+PUBLICSCREEN,
                                  SA_OVERSCAN,OSCAN_TEXT,
                                  SA_PENS,[0,1,1,2,1,3,1,0,2,1,2,1]:INT,    /* Répartition de couleurs WB 2.0 */
                                  SA_DETAILPEN,1,            /* Detailpen */
                                  SA_BLOCKPEN,2,             /* BlockPen  */
                                  0,0]))=NIL THEN Raise(ER_SCREEN)
    PubScreenStatus(ps,0)                 /* make it available */
    IF (screen:=LockPubScreen('3DScreen'))=NIL THEN Raise(ER_LOCKSCREEN)
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)-10
    mybase.centrex:=Div(screen.width,2)
    mybase.centrey:=Div(screen.height,2)
    mybase.format:=SpDiv(SpFlt(screen.height),SpFlt(screen.width))
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_SetDownScreen() :Ferme l'écran."*/
PROC p_SetDownScreen() 
    IF visual THEN FreeVisualInfo(visual)
    IF screen.firstwindow<>0
        Wait(Shl(1,screensig))
    ENDIF
    IF myfont THEN CloseFont(myfont)
    IF screensig THEN FreeSignal(screensig)
    IF screen THEN UnlockPubScreen(NIL,screen)
    IF screen THEN CloseScreen(screen)
ENDPROC
/**/
/**/
/*"View Window"*/
/*"p_InitviewWindow() :Initialise les menus et gadgets."*/
PROC p_InitviewWindow() HANDLE 
    IF (view_menu:=CreateMenusA([1,0,get_3DView_string(DMENU_FILE),0,0,0,0,
                                  2,0,get_3DView_string(DMENU_LOADNEW),'N',0,0,MENU_LOADNEW,
                                  2,0,get_3DView_string(DMENU_LOADADD),'A',0,0,MENU_LOADADD,
                                  2,0,NM_BARLABEL,0,0,0,0,
                                  2,0,get_3DView_string(DMENU_SAVE_S),0,0,0,0,
                                  3,0,get_3DView_string(DMENU_SAVE_OBJSELECT),0,1,6,MENU_SAVE_OBJSELECT,
                                  3,0,get_3DView_string(DMENU_SAVE_OBJDESELECT),0,1,5,MENU_SAVE_OBJDESELECT,
                                  3,0,get_3DView_string(DMENU_SAVE_ALLOBJ),0,$101,3,MENU_SAVE_OBJALL,
                                  2,0,get_3DView_string(DMENU_SAVE_F),0,0,0,0,
                                  3,0,get_3DView_string(DMENU_SAVE_DXF),0,$101,6,MENU_SAVE_DXF,
                                  3,0,get_3DView_string(DMENU_SAVE_GEO),0,1,5,MENU_SAVE_GEO,
                                  3,0,get_3DView_string(DMENU_SAVE_RAY),0,1,3,MENU_SAVE_RAY,
                                  3,0,get_3DView_string(DMENU_SAVE_BIN),0,1,7,MENU_SAVE_BIN,
                                  2,0,NM_BARLABEL,0,0,0,0,
                                  2,0,get_3DView_string(DMENU_SAVEBASE),'S',0,0,MENU_SAVEBASE,
                                  2,0,NM_BARLABEL,0,0,0,0,
                                  2,0,get_3DView_string(DMENU_CONFIGURATION),'F',0,0,MENU_CONFIGURATION,
                                  2,0,NM_BARLABEL,0,0,0,0,
                                  2,0,get_3DView_string(DMENU_QUITTER),'Q',0,0,MENU_QUITTER,
                                  1,0,get_3DView_string(DMENU_VUES),0,0,0,0,
                                  2,0,get_3DView_string(DMENU_MODE),0,0,0,0,
                                  3,0,get_3DView_string(DMENU_MODE_PTS),0,1,6,MENU_MODE_PTS,
                                  3,0,get_3DView_string(DMENU_MODE_FCS),0,1,5,MENU_MODE_FCS,
                                  3,0,get_3DView_string(DMENU_MODE_PTSFCS),0,$101,3,MENU_MODE_PTSFCS,
                                  2,0,NM_BARLABEL,0,0,0,0,
                                  2,0,get_3DView_string(DMENU_VUEEN),0,0,0,0,
                                  3,0,get_3DView_string(DMENU_VUE_XOY),'0',$101,6,MENU_VUE_XOY,
                                  3,0,get_3DView_string(DMENU_VUE_XOZ),'1',1,5,MENU_VUE_XOZ,
                                  3,0,get_3DView_string(DMENU_VUE_YOZ),'3',1,3,MENU_VUE_YOZ,
                                  2,0,NM_BARLABEL,0,0,0,0,
                                  2,0,get_3DView_string(DMENU_COORD),0,0,0,0,
                                  3,0,get_3DView_string(DMENU_COORD_INVX),'X',0,0,MENU_COORD_INVX,
                                  3,0,get_3DView_string(DMENU_COORD_INVY),'Y',0,0,MENU_COORD_INVY,
                                  3,0,get_3DView_string(DMENU_COORD_INVZ),'Z',0,0,MENU_COORD_INVZ,
                                  2,0,NM_BARLABEL,0,0,0,0,
                                  2,0,get_3DView_string(DMENU_ZOOM),0,0,0,0,
                                  3,0,get_3DView_string(DMENU_ZOOM_P_PLUS),'+',0,0,MENU_ZOOM_P_PLUS,
                                  3,0,get_3DView_string(DMENU_ZOOM_P_MOINS),'-',0,0,MENU_ZOOM_P_MOINS,
                                  3,0,get_3DView_string(DMENU_ZOOM_G_PLUS),'*',0,0,MENU_ZOOM_G_PLUS,
                                  3,0,get_3DView_string(DMENU_ZOOM_G_MOINS),'/',0,0,MENU_ZOOM_G_MOINS,
                                  2,0,NM_BARLABEL,0,0,0,0,
                                  2,0,get_3DView_string(DMENU_ROT),0,0,0,0,
                                  3,0,get_3DView_string(DMENU_ROT_UP),'8',0,0,MENU_ROT_UP,
                                  3,0,get_3DView_string(DMENU_ROT_DOWN),'2',0,0,MENU_ROT_DOWN,
                                  3,0,get_3DView_string(DMENU_ROT_LEFT),'4',0,0,MENU_ROT_LEFT,
                                  3,0,get_3DView_string(DMENU_ROT_RIGHT),'6',0,0,MENU_ROT_RIGHT,
                                  3,0,get_3DView_string(DMENU_OBJCENTRE),'C',0,0,MENU_OBJCENTRE,
                                  1,0,get_3DView_string(DMENU_OBJ),0,0,0,0,
                                  2,0,get_3DView_string(DMENU_SELECTALL),'O',0,0,MENU_SELECTALL,
                                  2,0,get_3DView_string(DMENU_DESELECTALL),'D',0,0,MENU_DESELECTALL,
                                  2,0,get_3DView_string(DMENU_OBJSECTION),0,0,0,MENU_OBJSELECTION,
                                  2,0,NM_BARLABEL,0,0,0,0,
                                  2,0,get_3DView_string(DMENU_COLOR),0,0,0,0,
                                  3,0,get_3DView_string(DMENU_COLORPTS),0,0,0,MENU_COUL_PTS,
                                  3,0,get_3DView_string(DMENU_COLORFCS),0,0,0,MENU_COUL_FCS,
                                  3,0,get_3DView_string(DMENU_COLOROBJSELECT),0,0,0,MENU_COUL_OBJSELECT,
                                  3,0,get_3DView_string(DMENU_COLORBOUNDING),0,0,0,MENU_COUL_BOUNDING,
                                   0,0,0,0,0,0,0]:newmenu,NIL))=NIL THEN Raise(ER_MENUS)
    IF LayoutMenusA(view_menu,visual,NIL)=FALSE THEN Raise(ER_MENUS)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_OpenviewWindow() :Ouvre la fenêtre."*/
PROC p_OpenviewWindow() HANDLE 
    IF (view_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,0,
                       WA_TOP,0,
                       WA_WIDTH,offx+screen.width,
                       WA_HEIGHT,offy+screen.height,
                       WA_IDCMP,$340+IDCMP_RAWKEY,
                       WA_FLAGS,$1900,
                       /*WA_GADGETS,view_glist,*/
                       WA_CUSTOMSCREEN,screen,
                       WA_TITLE,'ViewWindow',
                       WA_SCREENTITLE,titlescreen,
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    IF SetMenuStrip(view_window,view_menu)=FALSE THEN Raise(ER_MENUS)
    LoadRGB4(ViewPortAddress(view_window),mybase.palette,8)
    Gt_RefreshWindow(view_window,NIL)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemviewWindow() :Ferme la fenêtre et libère la mémoire."*/
PROC p_RemviewWindow() 
    IF view_window THEN CloseWindow(view_window)
    IF view_menu THEN FreeMenus(view_menu)
    IF view_glist THEN FreeGadgets(view_glist)
ENDPROC
/**/
/**/
/*"Config Window"*/
/*"p_InitconfigWindow() :Initialise les menus et gadgets."*/
PROC p_InitconfigWindow() HANDLE 
    DEF g:PTR TO gadget
    IF (g:=CreateContext({config_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_fct3dpro:=CreateGadgetA(STRING_KIND,g,[offx+119,offy+39,153,19,'3Dpro',tattr,0,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_fctsculpt:=CreateGadgetA(STRING_KIND,g_fct3dpro,[offx+119,offy+62,153,19,'Sculpt',tattr,1,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_fctimagine:=CreateGadgetA(STRING_KIND,g_fctsculpt,[offx+119,offy+85,153,19,'Imagine',tattr,2,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_fctvertex:=CreateGadgetA(STRING_KIND,g_fctimagine,[offx+119,offy+108,153,19,'Vertex',tattr,3,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_configok:=CreateGadgetA(BUTTON_KIND,g_fctvertex,[offx+20,offy+148,97,21,'Ok',tattr,4,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_configcancel:=CreateGadgetA(BUTTON_KIND,g_configok,[offx+220,offy+148,97,21,'Cancel',tattr,5,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_OpenconfigWindow() :Ouvre la fenêtre."*/
PROC p_OpenconfigWindow() HANDLE 
    IF (config_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,267,
                       WA_TOP,125,
                       WA_WIDTH,offx+344,
                       WA_HEIGHT,offy+184,
                       WA_IDCMP,$37C,
                       WA_FLAGS,$102E,
                       WA_GADGETS,config_glist,
                       WA_CUSTOMSCREEN,screen,
                       WA_TITLE,'3DView Configuration.',
                       WA_SCREENTITLE,titlescreen,
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    IF SetMenuStrip(config_window,view_menu)=FALSE THEN Raise(ER_MENUS)
    p_RenderconfigWindow()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RenderconfigWindow() :Dessine les BevelBox et le texte."*/
PROC p_RenderconfigWindow() 
    DEF str[256]:STRING
    StrCopy(str,p_FloatToString(mybase.fct3dpro),ALL)
    Gt_SetGadgetAttrsA(g_fct3dpro,config_window,NIL,[GTST_STRING,str,0])
    StrCopy(str,p_FloatToString(mybase.fctsculpt),ALL)
    Gt_SetGadgetAttrsA(g_fctsculpt,config_window,NIL,[GTST_STRING,str,0])
    StrCopy(str,p_FloatToString(mybase.fctimagine),ALL)
    Gt_SetGadgetAttrsA(g_fctimagine,config_window,NIL,[GTST_STRING,str,0])
    StrCopy(str,p_FloatToString(mybase.fctvertex),ALL)
    Gt_SetGadgetAttrsA(g_fctvertex,config_window,NIL,[GTST_STRING,str,0])
    DrawBevelBoxA(config_window.rport,offx+8,offy+140,329,41,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(config_window.rport,offx+8,offy+20,329,117,[GT_VISUALINFO,visual,TAG_DONE])
    RefreshGList(g_fct3dpro,config_window,NIL,-1)
    Gt_RefreshWindow(config_window,NIL)
ENDPROC
/**/
/*"p_RemconfigWindow() :Ferme la fenêtre et libère la mémoire."*/
PROC p_RemconfigWindow() 
    DEF mes
    WHILE mes:=Gt_GetIMsg(config_window.userport) DO Gt_ReplyIMsg(mes)
    IF config_window THEN CloseWindow(config_window)
    IF config_glist THEN FreeGadgets(config_glist)
    config_window:=NIL
ENDPROC
/**/
/*"p_OpenTheConfigWindow() :Call p_InitconfigWindow() and p_OpenconfigWindow()."*/
PROC p_OpenTheConfigWindow() HANDLE
    DEF tm
    IF (tm:=p_InitconfigWindow())<>ER_NONE THEN Raise(tm)
    curobjnode:=0
    IF (tm:=p_OpenconfigWindow())<>ER_NONE THEN Raise(tm)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/**/
/*"Info Window"*/
/*"p_InitinfoWindow() :Initialise les menus et gadgets."*/
PROC p_InitinfoWindow() HANDLE 
    DEF g:PTR TO gadget
    IF (g:=CreateContext({info_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_infototalpts:=CreateGadgetA(NUMBER_KIND,g,[offx+576,offy+24,121,18,get_3DView_string(GAD_TOTALPTS),tattr,0,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infototalfcs:=CreateGadgetA(NUMBER_KIND,g_infototalpts,[offx+576,offy+44,121,18,get_3DView_string(GAD_TOTALFCS),tattr,1,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infototalobj:=CreateGadgetA(NUMBER_KIND,g_infototalfcs,[offx+576,offy+64,121,18,get_3DView_string(GAD_TOTALOBJ),tattr,2,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infodelobj:=CreateGadgetA(BUTTON_KIND,g_infototalobj,[offx+8,offy+168,209,25,get_3DView_string(GAD_DELOBJ),tattr,3,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_objmode:=CreateGadgetA(MX_KIND,g_infodelobj,[offx+240,offy+21,17,9,'',tattr,4,2,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTMX_LABELS,[get_3DView_string(GAD_MX_NORMAL),get_3DView_string(GAD_MX_SELECT),get_3DView_string(GAD_MX_BOUNDED),get_3DView_string(GAD_MX_HIDE),0],GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_infonbrspts:=CreateGadgetA(NUMBER_KIND,g_objmode,[offx+332,offy+92,121,18,get_3DView_string(GAD_NBRSPTS),tattr,5,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infonbrsfcs:=CreateGadgetA(NUMBER_KIND,g_infonbrspts,[offx+332,offy+112,121,18,get_3DView_string(GAD_NBRSFCS),tattr,6,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infominx:=CreateGadgetA(NUMBER_KIND,g_infonbrsfcs,[offx+332,offy+132,121,18,get_3DView_string(GAD_MINX),tattr,7,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infomaxx:=CreateGadgetA(NUMBER_KIND,g_infominx,[offx+332,offy+152,121,18,get_3DView_string(GAD_MAXX),tattr,8,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infominy:=CreateGadgetA(NUMBER_KIND,g_infomaxx,[offx+332,offy+172,121,18,get_3DView_string(GAD_MINY),tattr,9,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infomaxy:=CreateGadgetA(NUMBER_KIND,g_infominy,[offx+332,offy+192,121,18,get_3DView_string(GAD_MAXY),tattr,10,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infominz:=CreateGadgetA(NUMBER_KIND,g_infomaxy,[offx+332,offy+212,121,18,get_3DView_string(GAD_MINZ),tattr,11,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infomaxz:=CreateGadgetA(NUMBER_KIND,g_infominz,[offx+332,offy+232,121,18,get_3DView_string(GAD_MAXZ),tattr,12,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infocenx:=CreateGadgetA(NUMBER_KIND,g_infomaxz,[offx+576,offy+92,121,18,get_3DView_string(GAD_CENTREX),tattr,13,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infoceny:=CreateGadgetA(NUMBER_KIND,g_infocenx,[offx+576,offy+112,121,18,get_3DView_string(GAD_CENTREY),tattr,14,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infocenz:=CreateGadgetA(NUMBER_KIND,g_infoceny,[offx+576,offy+132,121,18,get_3DView_string(GAD_CENTREZ),tattr,15,1,visual,0]:newgadget,[GTNM_BORDER,1,GTIN_NUMBER,00000000,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infotype:=CreateGadgetA(TEXT_KIND,g_infocenz,[offx+28,offy+224,169,18,get_3DView_string(GAD_TYPE),tattr,16,4,visual,0]:newgadget,[GTTX_BORDER,1,GTTX_TEXT,'',0]))=NIL THEN Raise(ER_GADGET)
    IF (g_infook:=CreateGadgetA(BUTTON_KIND,g_infotype,[offx+520,offy+196,141,21,get_3DView_string(GAD_OUI),tattr,17,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_infolist:=CreateGadgetA(LISTVIEW_KIND,g_infook,[offx+18,offy+32,193,129,'',tattr,18,0,visual,0]:newgadget,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_OpeninfoWindow() :Ouvre la fenêtre."*/
PROC p_OpeninfoWindow() HANDLE 
    IF (info_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,315,
                       WA_TOP,121,
                       WA_WIDTH,offx+713,
                       WA_HEIGHT,offy+262,
                       WA_IDCMP,$40037C,
                       WA_FLAGS,$102E,
                       WA_GADGETS,info_glist,
                       WA_CUSTOMSCREEN,screen,
                       WA_TITLE,'3DView Information.',
                       WA_SCREENTITLE,titlescreen,
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    IF SetMenuStrip(info_window,view_menu)=FALSE THEN Raise(ER_MENUS)
    p_RenderinfoWindow()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RenderinfoWindow() :Dessine les BevelsBox et le texte."*/
PROC p_RenderinfoWindow() 
    DEF renderobj:PTR TO object3d,totobj
    DEF nbrspts[256]:STRING,mxdata=0
    IF (p_EmptyList(mybase.objlist))<>-1
        renderobj:=p_GetAdrNode(mybase.objlist,curobjnode)
        totobj:=p_CountNodes(mybase.objlist)
        dWriteF(['Current obj:\h ','Pts:\d ','Fcs:\d\n'],[renderobj,renderobj.nbrspts,renderobj.nbrsfcs])
        nbrspts:=renderobj.nbrspts
        IF renderobj.bounded=TRUE THEN mxdata:=2
        IF renderobj.selected=TRUE THEN mxdata:=1
        Gt_SetGadgetAttrsA(g_infolist,info_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,curobjnode,GTLV_LABELS,mybase.objlist,TAG_DONE])
        Gt_SetGadgetAttrsA(g_infototalpts,info_window,NIL,[GTNM_NUMBER,mybase.totalpts,0])
        Gt_SetGadgetAttrsA(g_infototalfcs,info_window,NIL,[GTNM_NUMBER,mybase.totalfcs,0])
        Gt_SetGadgetAttrsA(g_infototalobj,info_window,NIL,[GTNM_NUMBER,totobj,0])
        Gt_SetGadgetAttrsA(g_objmode,info_window,NIL,[GTMX_ACTIVE,mxdata,0])
        Gt_SetGadgetAttrsA(g_infonbrspts,info_window,NIL,[GTNM_NUMBER,renderobj.nbrspts,0])
        Gt_SetGadgetAttrsA(g_infonbrsfcs,info_window,NIL,[GTNM_NUMBER,renderobj.nbrsfcs,0])
        Gt_SetGadgetAttrsA(g_infominx,info_window,NIL,[GTNM_NUMBER,renderobj.objminx,0])
        Gt_SetGadgetAttrsA(g_infomaxx,info_window,NIL,[GTNM_NUMBER,renderobj.objmaxx,0])
        Gt_SetGadgetAttrsA(g_infominy,info_window,NIL,[GTNM_NUMBER,renderobj.objminy,0])
        Gt_SetGadgetAttrsA(g_infomaxy,info_window,NIL,[GTNM_NUMBER,renderobj.objmaxy,0])
        Gt_SetGadgetAttrsA(g_infominz,info_window,NIL,[GTNM_NUMBER,renderobj.objminz,0])
        Gt_SetGadgetAttrsA(g_infomaxz,info_window,NIL,[GTNM_NUMBER,renderobj.objmaxz,0])
        Gt_SetGadgetAttrsA(g_infominx,info_window,NIL,[GTNM_NUMBER,renderobj.objminx,0])
        Gt_SetGadgetAttrsA(g_infocenx,info_window,NIL,[GTNM_NUMBER,renderobj.objcx,0])
        Gt_SetGadgetAttrsA(g_infoceny,info_window,NIL,[GTNM_NUMBER,renderobj.objcy,0])
        Gt_SetGadgetAttrsA(g_infocenz,info_window,NIL,[GTNM_NUMBER,renderobj.objcz,0])
        Gt_SetGadgetAttrsA(g_infotype,info_window,NIL,[GTTX_TEXT,data_objtype[renderobj.typeobj],0])
    ELSE
        Gt_SetGadgetAttrsA(g_infolist,info_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,curobjnode,GTLV_LABELS,NIL,TAG_DONE])
    ENDIF
    DrawBevelBoxA(info_window.rport,offx+8,offy+196,209,61,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(info_window.rport,offx+468,offy+20,237,65,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(info_window.rport,offx+468,offy+88,237,65,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(info_window.rport,offx+220,offy+20,245,65,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(info_window.rport,offx+468,offy+156,237,101,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(info_window.rport,offx+8,offy+20,209,145,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(info_window.rport,offx+220,offy+88,245,169,[GT_VISUALINFO,visual,TAG_DONE])
    RefreshGList(g_infototalpts,info_window,NIL,-1)
    Gt_RefreshWindow(info_window,NIL)
ENDPROC
/**/
/*"p_ReminfoWindow() :Ferme la fenêtre et libère la mémoire."*/
PROC p_ReminfoWindow() 
    DEF mes
    WHILE mes:=Gt_GetIMsg(info_window.userport) DO Gt_ReplyIMsg(mes)
    IF info_window THEN CloseWindow(info_window)
    IF info_glist THEN FreeGadgets(info_glist)
    info_window:=NIL
ENDPROC
/**/
/*"p_OpenTheInfoWindow() :Call p_InitinfoWindow() and p_OpeninfoWindow()."*/
PROC p_OpenTheInfoWindow() HANDLE
    DEF tm
    IF (tm:=p_InitinfoWindow())<>ER_NONE THEN Raise(tm)
    curobjnode:=0
    IF (tm:=p_OpeninfoWindow())<>ER_NONE THEN Raise(tm)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/**/
