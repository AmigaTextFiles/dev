/*"Windows Proc"*/
/*"p_OpenLibraries()"*/
PROC p_OpenLibraries() HANDLE 
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (cxbase:=OpenLibrary('commodities.library',37))=NIL THEN Raise(ER_COMMODITIESLIB)
    IF (workbenchbase:=OpenLibrary('workbench.library',37))=NIL THEN Raise(ER_WORKBENCHLIB)
    IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN Raise(ER_ICONLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_CloseLibraries()"*/
PROC p_CloseLibraries()  
    IF iconbase THEN CloseLibrary(iconbase)
    IF workbenchbase THEN CloseLibrary(workbenchbase)
    IF cxbase  THEN CloseLibrary(cxbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
/**/
/*"p_SetUpScreen()"*/
PROC p_SetUpScreen() HANDLE 
    DEF pt:PTR TO textattr
    dWriteF(['p_SetUpScreen()\n'],0)
    IF mb.allscreen=TRUE
        IF (screen:=p_LockActiveScreen())=NIL THEN Raise(ER_LOCKSCREEN)
    ELSE
        IF (screen:=LockPubScreen(p_LockActivePubScreen()))=NIL THEN Raise(ER_LOCKSCREEN)
    ENDIF
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)-10
    pt:=screen.font
    IF pt.ysize<=8
        tattr:=[pt.name,pt.ysize,0,0]:textattr
    ELSE
        tattr:=['topaz.font',8,0,0]:textattr
    ENDIF
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_SetDownScreen()"*/
PROC p_SetDownScreen() 
    dWriteF(['p_SetDownScreen()\n'],0)
    IF visual THEN FreeVisualInfo(visual)
    IF mb.allscreen=TRUE
        NOP
    ELSE
        IF screen THEN UnlockPubScreen(NIL,screen)
    ENDIF
ENDPROC
/**/
/*"p_LockActivePubScreen()"*/
PROC p_LockActivePubScreen()
    DEF ps:PTR TO pubscreennode
    DEF s:PTR TO screen
    DEF ret=NIL
    DEF sn:PTR TO ln
    DEF psl:PTR TO lh
    DEF myintui:PTR TO intuitionbase
    dWriteF(['p_LockActivePubScreen()\n'],0)
    ret:=NIL
    myintui:=intuitionbase
    s:=myintui.activescreen
    IF psl:=LockPubScreenList()
        sn:=psl.head
        WHILE sn
            ps:=sn
            IF sn.succ<>0
                IF ps.screen=s THEN ret:=sn.name
            ENDIF
            sn:=sn.succ
        ENDWHILE
        UnlockPubScreenList()
    ENDIF
    RETURN ret
ENDPROC
/**/
/*"p_LockActiveScreen()"*/
PROC p_LockActiveScreen()
    DEF s:PTR TO screen
    DEF ret=NIL
    DEF myintui:PTR TO intuitionbase
    dWriteF(['p_LockAtiveScreen()\n'],0)
    ret:=NIL
    myintui:=intuitionbase
    s:=myintui.activescreen
    RETURN s
ENDPROC
/**/
/*"p_InitcrWindow()"*/
PROC p_InitcrWindow() HANDLE 
    DEF g:PTR TO gadget
    IF (g:=CreateContext({cr_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (glist:=CreateGadgetA(LISTVIEW_KIND,g,[offx+4,offy+11,153,40,'',tattr,0,0,visual,0]:newgadget,[GA_IMMEDIATE,TRUE,GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (gedit:=CreateGadgetA(BUTTON_KIND,glist,[offx+159,offy+11,126,12,'_Edit',tattr,1,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g4:=CreateGadgetA(BUTTON_KIND,gedit,[offx+159,offy+35,126,12,'_Quit',tattr,2,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_wb:=CreateGadgetA(BUTTON_KIND,g4,[offx+161,offy+23,62,12,'_WBRun',tattr,3,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_cli:=CreateGadgetA(BUTTON_KIND,g_wb,[offx+223,offy+23,62,12,'_CliRun',tattr,4,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_info:=CreateGadgetA(TEXT_KIND,g_cli,[offx+7,offy+47,278,12,'',tattr,5,0,visual,0]:newgadget,[GTTX_BORDER,1,GTTX_TEXT,'',GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RendercrWindow()"*/
PROC p_RendercrWindow() 
    DEF inf[256]:STRING
    DEF infonode:PTR TO xarg
    DEF infox:PTR TO xblock
    DEF cn:PTR TO ln
    dWriteF(['p_RendercrWindow()\n'],0)
    IF cr_window<>0
        p_LockListView(glist,cr_window)
        infonode:=p_GetAdrNode(currentlist,currentnode)
        cn:=infonode
        IF StrCmp(cn.name,'»» ',3)
            infox:=cn
            StringF(inf,'Nbrs Command(s):\d',p_CountNodes(infox.list))
        ELSE
            StringF(inf,'Stack :\d Priority :\d',infonode.stack,infonode.pri)
        ENDIF
        IF p_EmptyList(currentlist)=-1
            Gt_SetGadgetAttrsA(glist,cr_window,NIL,[GA_DISABLED,TRUE,GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,TAG_DONE,0])
            Gt_SetGadgetAttrsA(gedit,cr_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
            Gt_SetGadgetAttrsA(g_wb,cr_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
            Gt_SetGadgetAttrsA(g_cli,cr_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
            Gt_SetGadgetAttrsA(g_info,cr_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,'Empty list.',TAG_DONE,0])
            IF mb.zoomed=FALSE
                SetWindowTitles(cr_window,title_req,'Made With GadToolsBox v2.0 © 1991-1993')
            ELSE
                SetWindowTitles(cr_window,'No Command','Made With GadToolsBox v2.0 © 1991-1993')
            ENDIF
        ELSE
            Gt_SetGadgetAttrsA(glist,cr_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,TRUE,GTLV_TOP,currentnode,GTLV_SELECTED,currentnode,GTLV_LABELS,currentlist,TAG_DONE,0])
            Gt_SetGadgetAttrsA(g_info,cr_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,inf,TAG_DONE,0])
            Gt_SetGadgetAttrsA(gedit,cr_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
            Gt_SetGadgetAttrsA(g_wb,cr_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
            Gt_SetGadgetAttrsA(g_cli,cr_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
            IF mb.zoomed=FALSE
                SetWindowTitles(cr_window,title_req,'Made With GadToolsBox v2.0 © 1991-1993')
            ELSE
                SetWindowTitles(cr_window,cn.name,'Made With GadToolsBox v2.0 © 1991-1993')
            ENDIF
        ENDIF
        p_UnLockListView(glist,cr_window,currentlist)
        RefreshGList(glist,cr_window,NIL,-1)
        Gt_RefreshWindow(cr_window,NIL)
    ENDIF
ENDPROC
/**/
/*"p_OpencrWindow()"*/
PROC p_OpencrWindow() HANDLE 
    DEF mx,my
    DEF winx,winy,ap
    mx:=screen.mousex-145
    my:=screen.mousey-31
    winx:=290+offx
    winy:=62+offy
    IF (cr_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,mx,
                       WA_TOP,my,
                       WA_WIDTH,winx,
                       WA_HEIGHT,winy,
                       WA_IDCMP,$400378+IDCMP_REFRESHWINDOW+IDCMP_RAWKEY,
                       WA_FLAGS,$102E+WFLG_HASZOOM+WFLG_RMBTRAP,
                       WA_GADGETS,cr_glist,
                       WA_ZOOM,[mx,my,290,11]:INT,
                       WA_TITLE,title_req,
                       WA_CUSTOMSCREEN,screen,
                       WA_SCREENTITLE,'Made With GadToolsBox v2.0 © 1991-1993',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    Gt_RefreshWindow(cr_window,NIL)
    p_RendercrWindow()
    IF (ap:=AddAppWindowA(0,0,cr_window,mb.prgport,NIL))=NIL THEN Raise(ER_APPWIN)
    mb.appwindow:=ap
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemcrWindow()"*/
PROC p_RemcrWindow() 
    IF mb.appwindow THEN RemoveAppWindow(mb.appwindow)
    IF cr_window THEN CloseWindow(cr_window)
    IF cr_glist THEN FreeGadgets(cr_glist)
    cr_window:=NIL
ENDPROC
/**/
/*"p_OpenWindow()"*/
PROC p_OpenWindow() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Lock,init gagets lists and open whatview window.
 ==============================================================================*/
    DEF t
    IF (t:=p_SetUpScreen())<>ER_NONE THEN Raise(t)
    IF (t:=p_InitcrWindow())<>ER_NONE THEN Raise(t)
    IF (t:=p_OpencrWindow())<>ER_NONE THEN Raise(t)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_CloseWindow()"*/
PROC p_CloseWindow() 
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : free gadgets lists,close window and unlock screen.
 ==============================================================================*/
    IF cr_window THEN p_RemcrWindow()
    IF screen THEN p_SetDownScreen()
    cr_window:=NIL
    screen:=NIL
    mb.zoomed:=FALSE
ENDPROC
/**/
/**/

