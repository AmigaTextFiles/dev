/*"Peps Header"*/
/*=========================================================================================*/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */
/*=========================================================================================*/
/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '0'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*======<<<   History   >>>======
 V 0.0 Chosse file in Sys:WBStartup
 ===============================*/
/**/
OPT OSVERSION=37
/*"Modules List"*/
MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes','exec/ports','eropenlib','utility/tagitem'
MODULE 'dos/dos'
/**/
/*"PModules List"*/
PMODULE 'WBSelectorList'
/**/
/*"Objects Definitions"*/
OBJECT wbsbase
    prgslist:LONG   /* List of prg selected */
    prgdlist:LONG   /* List of prg deselcted */
ENDOBJECT
/**/
/*"Globals Definitions"*/
ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_ONLYCLI,ER_BADARGS,ER_FATAL
DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offy,offx
/*=======================================
 = wbs Definitions
 =======================================*/
DEF wbs_window=NIL:PTR TO window
DEF wbs_glist=NIL
/*==================*/
/*     Gadgets      */
/*==================*/
CONST GA_G_SELECT=0
CONST GA_G_DESELECT=1
/*=============================
 = Gadgets labels of wbs
 =============================*/
DEF g_select
DEF g_deselect
/*=============================
 = Application def
 =============================*/
 DEF mywbs:PTR TO wbsbase
 DEF count=5,intuicount,stopcount=FALSE
 DEF winx,winy,savechange=FALSE
/**/
/*"Libraries Procedures"*/
/*"p_OpenLibraries"*/
PROC p_OpenLibraries() HANDLE
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_CloseLibraries"*/
PROC p_CloseLibraries()
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
/**/
/**/
/*"Window Procedures"*/
/*"p_SetUpScreen"*/
PROC p_SetUpScreen() HANDLE
    IF (screen:=LockPubScreen('Workbench'))=NIL THEN Raise(ER_LOCKSCREEN)
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)-10
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_SetDownScreen"*/
PROC p_SetDownScreen()
    IF visual THEN FreeVisualInfo(visual)
    IF screen THEN UnlockPubScreen(NIL,screen)
ENDPROC
/**/
/*"p_InitwbsWindow"*/
PROC p_InitwbsWindow() HANDLE
    DEF g:PTR TO gadget
    IF (g:=CreateContext({wbs_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_select:=CreateGadgetA(LISTVIEW_KIND,g,[offx+24,offy+28,153,40,'Selected',tattr,0,4,visual,0]:newgadget,[GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_deselect:=CreateGadgetA(LISTVIEW_KIND,g_select,[offx+180,offy+28,153,40,'DeSelected',tattr,1,4,visual,0]:newgadget,[GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RenderwbsWindow"*/
PROC p_RenderwbsWindow()
    IF p_EmptyList(mywbs.prgslist)<>-1
        Gt_SetGadgetAttrsA(g_select,wbs_window,NIL,[GA_DISABLED,FALSE,GTLV_LABELS,mywbs.prgslist,TAG_DONE])
    ELSE
        Gt_SetGadgetAttrsA(g_select,wbs_window,NIL,[GA_DISABLED,TRUE,GTLV_LABELS,NIL,TAG_DONE])
    ENDIF
    IF p_EmptyList(mywbs.prgdlist)<>-1
        Gt_SetGadgetAttrsA(g_deselect,wbs_window,NIL,[GA_DISABLED,FALSE,GTLV_LABELS,mywbs.prgdlist,TAG_DONE])
    ELSE
        Gt_SetGadgetAttrsA(g_deselect,wbs_window,NIL,[GA_DISABLED,TRUE,GTLV_LABELS,NIL,TAG_DONE])
    ENDIF
    DrawBevelBoxA(wbs_window.rport,offx+8,offy+12,341,61,[GT_VISUALINFO,visual,TAG_DONE])
    RefreshGList(g_select,wbs_window,NIL,-1)
    Gt_RefreshWindow(wbs_window,NIL)
ENDPROC
/**/
/*"p_OpenwbsWindow"*/
PROC p_OpenwbsWindow() HANDLE
    IF (wbs_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,winx,
                       WA_TOP,winy,
                       WA_WIDTH,offx+356,
                       WA_HEIGHT,offy+75,
                       WA_IDCMP,$400278,
                       WA_FLAGS,$102E,
                       WA_GADGETS,wbs_glist,
                       WA_CUSTOMSCREEN,screen,
                       WA_TITLE,'WBStartup Selector © 1994 NasGûl',
                       WA_SCREENTITLE,'Made With GadToolsBox V2.0b © 1991-1993',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    p_RenderwbsWindow()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemwbsWindow"*/
PROC p_RemwbsWindow()
    IF wbs_window THEN CloseWindow(wbs_window)
    IF wbs_glist THEN FreeGadgets(wbs_glist)
ENDPROC
/**/
/**/
/*"Message Procedures"*/
/*"p_LookAllMessage"*/
PROC p_LookAllMessage()
    DEF sigreturn
    DEF wbsport:PTR TO mp
    IF wbs_window THEN wbsport:=wbs_window.userport ELSE wbsport:=NIL
    sigreturn:=Wait(Shl(1,wbsport.sigbit) OR
                    $F000)
    IF (sigreturn AND Shl(1,wbsport.sigbit))
        p_LookwbsMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
/**/
/*"p_LookwbsMessage"*/
PROC p_LookwbsMessage()
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF type=0,infos=NIL
   DEF curnode:PTR TO ln
   WHILE mes:=Gt_GetIMsg(wbs_window.userport)
       type:=mes.class
       SELECT type
           CASE IDCMP_CLOSEWINDOW
              reelquit:=TRUE
           CASE IDCMP_INTUITICKS
              IF stopcount=FALSE
                  INC intuicount
                  IF intuicount=count THEN reelquit:=TRUE
              ENDIF
           CASE IDCMP_GADGETUP
            /*IDCMP_GADGETUP*/
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                  CASE GA_G_SELECT
                    curnode:=p_GetAdrNode(mywbs.prgslist,mes.code)
                    p_AjouteNode(mywbs.prgdlist,curnode.name,NIL)
                    p_EnleveNode(mywbs.prgslist,mes.code,0,0)
                    p_RenderwbsWindow()
                    savechange:=TRUE
                  CASE GA_G_DESELECT
                    curnode:=p_GetAdrNode(mywbs.prgdlist,mes.code)
                    p_AjouteNode(mywbs.prgslist,curnode.name,NIL)
                    p_EnleveNode(mywbs.prgdlist,mes.code,0,0)
                    p_RenderwbsWindow()
                    savechange:=TRUE
              ENDSELECT
              stopcount:=TRUE
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
ENDPROC
/**/
/**/
/*"Applications Procedures"*/
/*"p_InitWBS()"*/
PROC p_InitWBS() HANDLE
    mywbs:=New(SIZEOF wbsbase)
    mywbs.prgslist:=p_InitList()
    mywbs.prgdlist:=p_InitList()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemWBS()"*/
PROC p_RemWBS()
    IF mywbs.prgslist THEN p_CleanList(mywbs.prgslist,0,0,LIST_REMOVE)
    IF mywbs.prgdlist THEN p_CleanList(mywbs.prgdlist,0,0,LIST_REMOVE)
    IF mywbs THEN Dispose(mywbs)
ENDPROC
/**/
/*"p_ReadWBStartupDir()"*/
PROC p_ReadWBStartupDir() HANDLE
    DEF lock
    DEF info:fileinfoblock
    DEF pos
    DEF prgname[80]:STRING
    DEF file[80]:STRING
    IF lock:=Lock('Sys:WBStartup',-2)
        IF Examine(lock,info)
            WHILE ExNext(lock,info)
                StringF(file,'\s',info.filename)
                IF (pos:=InStr(file,'.info',ALL))<>-1
                    MidStr(prgname,file,0,pos)
                    p_AjouteNode(mywbs.prgslist,prgname,NIL)
                ENDIF
                IF (pos:=InStr(file,'.xinfo',ALL))<>-1
                    MidStr(prgname,file,0,pos)
                    p_AjouteNode(mywbs.prgdlist,prgname,NIL)
                ENDIF
                pos:=-1
            ENDWHILE
        ENDIF
        IF lock THEN UnLock(lock)
    ELSE
        Raise(ER_FATAL)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_MakeChange()"*/
PROC p_MakeChange()
    DEF list:PTR TO lh
    DEF n:PTR TO ln
    DEF source[80]:STRING
    DEF destin[80]:STRING
    list:=mywbs.prgslist
    n:=list.head
    WHILE n
        IF n.succ<>0
            StringF(source,'Sys:WBStartUp/\s.xinfo',n.name)
            IF FileLength(source)<>-1
                StringF(destin,'Sys:WBStartup/\s.info',n.name)
                Rename(source,destin)
            ENDIF
        ENDIF
        n:=n.succ
    ENDWHILE
    list:=mywbs.prgdlist
    n:=list.head
    WHILE n
        IF n.succ<>0
            StringF(source,'Sys:WBStartUp/\s.info',n.name)
            IF FileLength(source)<>-1
                StringF(destin,'Sys:WBStartup/\s.xinfo',n.name)
                Rename(source,destin)
            ENDIF
        ENDIF
        n:=n.succ
    ENDWHILE
ENDPROC
/**/
/*"p_StartCli()"*/
PROC p_StartCli() HANDLE
    DEF myargs:PTR TO LONG,rdargs=NIL
    myargs:=[0,0,0]
    IF rdargs:=ReadArgs('Time/N,PosX/N,PosY/N',myargs,NIL)
        IF myargs[0]
            count:=Long(myargs[0])*5
        ELSE
            count:=5
        ENDIF
        IF myargs[1] THEN winx:=Long(myargs[1]) ELSE winx:=300
        IF myargs[2] THEN winy:=Long(myargs[2]) ELSE winy:=65
    ELSE
        Raise(ER_BADARGS)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF rdargs THEN FreeArgs(rdargs)
    RETURN exception
ENDPROC
/**/
/**/
/*"main"*/
PROC main() HANDLE
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF wbmessage<>NIL
        Raise(ER_ONLYCLI)
    ELSE
        IF (testmain:=p_StartCli())<>ER_NONE THEN Raise(testmain)
    ENDIF
    IF (testmain:=p_InitWBS())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_ReadWBStartupDir())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitwbsWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_OpenwbsWindow())<>ER_NONE THEN Raise(testmain)
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    IF savechange=TRUE THEN p_MakeChange()
    Raise(ER_NONE)
EXCEPT
    IF mywbs THEN p_RemWBS()
    IF wbs_window THEN p_RemwbsWindow()
    IF screen THEN p_SetDownScreen()
    p_CloseLibraries()
    SELECT exception
        CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.\n')
        CASE ER_VISUAL;     WriteF('Error Visual.\n')
        CASE ER_CONTEXT;    WriteF('Error Context.\n')
        CASE ER_MENUS;      WriteF('Error Menus.\n')
        CASE ER_GADGET;     WriteF('Error Gadget.\n')
        CASE ER_WINDOW;     WriteF('Error Window.\n')
        CASE ER_ONLYCLI;    WriteF('Only Cli.\n')
        CASE ER_BADARGS;    WriteF('Bad Args.\n')
        CASE ER_FATAL;      WriteF('Fatal Error.\n')
    ENDSELECT
ENDPROC
/**/
