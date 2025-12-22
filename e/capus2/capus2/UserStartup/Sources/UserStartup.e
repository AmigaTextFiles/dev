/*=========================================================================================*/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */
/*=========================================================================================*/
/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '12'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*======<<<   History   >>>======
 ===============================*/

OPT OSVERSION=37
/*"MODULES"*/
MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes','exec/ports','eropenlib','utility/tagitem'
MODULE 'dos/dos','dos/dosasl','mheader','dos/dosextens','dos/dostags'
/**/
/*"ENUM/CONST"*/
ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_BADARGS,ER_ONLYCLI
/**/
/*"GLOBALS DEF"*/
DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offy,offx
/*=======================================
 = st Definitions
 =======================================*/
DEF st_window=NIL:PTR TO window
DEF st_glist=NIL
/*==================*/
/*     Gadgets      */
/*==================*/
CONST GA_G_LIST=0
/*=============================
 = Gadgets labels of st
 =============================*/
DEF g_list
DEF slist:PTR TO lh
DEF cnode=-1
DEF cmd[256]:STRING
DEF intuicount,count,winx=0,winy=0,test=FALSE,nowin=FALSE,run=FALSE
/**/
/*"PMODULES"*/
PMODULE 'Pmodules:PlistNoSort'
PMODULE 'Pmodules:PMHeader'
/**/
/*"WINDOWS PROCEDURES"*/
/*"p_OpenLibraries()"*/
PROC p_OpenLibraries() HANDLE 
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_CloseLibraries()"*/
PROC p_CloseLibraries()  
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
/**/
/*"p_SetUpScreen()"*/
PROC p_SetUpScreen() HANDLE 
    IF (screen:=LockPubScreen('Workbench'))=NIL THEN Raise(ER_LOCKSCREEN)
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)-10
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_SetDownScreen()"*/
PROC p_SetDownScreen() 
    IF visual THEN FreeVisualInfo(visual)
    IF screen THEN UnlockPubScreen(NIL,screen)
ENDPROC
/**/
/*"p_InitstWindow()"*/
PROC p_InitstWindow() HANDLE 
    DEF g:PTR TO gadget
    IF (g:=CreateContext({st_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_list:=CreateGadgetA(LISTVIEW_KIND,g,[offx+17,offy+15,285,48,'',tattr,0,0,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RenderstWindow()"*/
PROC p_RenderstWindow()
    IF p_EmptyList(slist)<>-1
        Gt_SetGadgetAttrsA(g_list,st_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,cnode,GTLV_LABELS,slist,TAG_DONE])
    ENDIF
    DrawBevelBoxA(st_window.rport,offx+10,offy+12,298,53,[GT_VISUALINFO,visual,TAG_DONE,0])
    RefreshGList(g_list,st_window,NIL,-1)
    Gt_RefreshWindow(st_window,NIL)
ENDPROC
/**/
/*"p_OpenstWindow()"*/
PROC p_OpenstWindow() HANDLE 
    IF (st_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,0,
                       WA_TOP,0,
                       WA_WIDTH,offx+318,
                       WA_HEIGHT,offy+69,
                       WA_IDCMP,$400278,
                       WA_FLAGS,$102E,
                       WA_GADGETS,st_glist,
                       WA_CUSTOMSCREEN,screen,
                       WA_TITLE,title_req,
                       WA_SCREENTITLE,'Made With GadToolsBox V2.0b © 1991-1993',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    p_RenderstWindow()
    ClearPointer(st_window)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemstWindow()"*/
PROC p_RemstWindow() 
    IF st_window THEN CloseWindow(st_window)
    IF st_glist THEN FreeGadgets(st_glist)
ENDPROC
/**/
/**/
/*"MESSAGES PROCEDURES"*/
/*"p_LookAllMessage()"*/
PROC p_LookAllMessage() 
    DEF sigreturn
    DEF stport:PTR TO mp
    IF st_window THEN stport:=st_window.userport ELSE stport:=NIL
    sigreturn:=Wait(Shl(1,stport.sigbit) OR
                    $F000)
    IF (sigreturn AND Shl(1,stport.sigbit))
        p_LookstMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
/**/
/*"p_LookstMessage()"*/
PROC p_LookstMessage() 
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF gstr:PTR TO stringinfo
   DEF type=0,infos=NIL
   DEF cn:PTR TO ln
   WHILE mes:=Gt_GetIMsg(st_window.userport)
       type:=mes.class
       SELECT type
           CASE IDCMP_MENUPICK
              infos:=mes.code
              SELECT infos
              ENDSELECT
           CASE IDCMP_INTUITICKS
              INC intuicount
              IF intuicount=count THEN reelquit:=TRUE
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                  CASE GA_G_LIST
                    cn:=p_GetAdrNode(slist,mes.code)
                    StringF(cmd,'S:\s\n',cn.name)
                    reelquit:=TRUE
              ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
ENDPROC
/**/
/**/
/*"APPLICATION PROCEDURES"*/
/*"p_InitAPP()"*/
PROC p_InitAPP()
    DEF er
    DEF i:PTR TO fileinfoblock
    DEF anchor=NIL:PTR TO anchorpath
    DEF name[256]:STRING
    slist:=p_InitList()
    anchor:=New(SIZEOF anchorpath+250)
    anchor.strlen:=249
    er:=MatchFirst('S:startup#?',anchor)
    WHILE er=0
        i:=anchor.info
        StringF(name,'\s',i.filename)
        IF EstrLen(name)<>16
            cnode:=p_AjouteNode(slist,name,0)
        ENDIF
        er:=MatchNext(anchor)
    ENDWHILE
    MatchEnd(anchor)
    Dispose(anchor)
ENDPROC
/**/
/*"p_RemAPP()"*/
PROC p_RemAPP()
    p_CleanList(slist,FALSE,0,LIST_REMOVE)
ENDPROC
/**/
/*"p_StartCli()"*/
PROC p_StartCli() HANDLE
    DEF myargs:PTR TO LONG,rdargs=NIL
    myargs:=[0,0,0,0,0,0,0]
    IF rdargs:=ReadArgs('DefautStartup/A,Time/N,PosX/N,PosY/N,Test/S,NoWindow/S,Run/S',myargs,NIL)
        IF myargs[0] THEN StrCopy(cmd,myargs[0],ALL)
        IF myargs[1]
            count:=Long(myargs[1])*5
        ELSE
            count:=5
        ENDIF
        IF myargs[2] THEN winx:=Long(myargs[1]) ELSE winx:=0
        IF myargs[3] THEN winy:=Long(myargs[2]) ELSE winy:=0
        IF myargs[4] THEN test:=TRUE
        IF myargs[5] THEN nowin:=TRUE
        IF myargs[6] THEN run:=TRUE
    ELSE
        Raise(ER_BADARGS)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF rdargs THEN FreeArgs(rdargs)
    RETURN exception
ENDPROC
/**/
/*"p_GetChoice()"*/
PROC p_GetChoice()
    DEF n:PTR TO ln,num=0,fo,sv,input[20]:STRING
    WriteF('\s\n',title_req)
    n:=slist.head
    WHILE n
        IF n.succ<>0
            WriteF('[32m\d[2] [33m-->[0m\s\n',num,n.name)
            num:=num+1
        ENDIF
        n:=n.succ
    ENDWHILE
    WriteF('Selectionnez la startup-sequence de votre choix ?:')
    IF fo:=Open('CONSOLE:',1006)
        ReadStr(fo,input)
        sv:=Val(input,NIL)
        Close(fo)
    ENDIF
    n:=p_GetAdrNode(slist,sv)
    StringF(cmd,'S:\s',n.name)
ENDPROC
/**/
/*"myExecute(cmd)"*/
PROC myExecute(cmd,dir) HANDLE
    DEF ofh:PTR TO filehandle
    DEF ifh:PTR TO filehandle
    DEF newct=NIL:PTR TO mp
    DEF oldct:PTR TO mp
    DEF oldcd=NIL
    DEF newcd=NIL
    DEF test
    IF ofh:=Open('NIL:',1006)
        IF IsInteractive(ofh)
            newct:=ofh.type
            oldct:=SetConsoleTask(newct)
            ifh:=Open('CONSOLE:',1005)
            SetConsoleTask(oldct)
        ELSE
            ifh:=Open('NIL:',1005)
        ENDIF
    ENDIF
    newcd:=Lock(dir,-2)
    oldcd:=CurrentDir(newcd)
    IF test:=SystemTagList(cmd,[SYS_OUTPUT,NIL,
                         SYS_INPUT,NIL,
                         SYS_ASYNCH,TRUE,
                         SYS_USERSHELL,FALSE,
                         NP_STACKSIZE,4096,
                         NP_PRIORITY,0,
                         NP_PATH,NIL,
                         NP_CONSOLETASK,newct,
                         0])
    ENDIF
    CurrentDir(oldcd)
    IF newcd THEN UnLock(newcd)
    IF ofh THEN Close(ofh)
    IF ifh THEN Close(ifh)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/

/**/
/*"main()"*/
PROC main() HANDLE 
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    IF wbmessage<>NIL
        Raise(ER_ONLYCLI)
    ELSE
        IF (testmain:=p_StartCli())<>ER_NONE THEN Raise(testmain)
    ENDIF
    p_DoReadHeader({banner})
    p_InitAPP()
    IF nowin<>TRUE
        IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
        IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
        IF (testmain:=p_InitstWindow())<>ER_NONE THEN Raise(testmain)
        IF (testmain:=p_OpenstWindow())<>ER_NONE THEN Raise(testmain)
        REPEAT
            p_LookAllMessage()
        UNTIL reelquit=TRUE
        Raise(ER_NONE)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF nowin<>TRUE
        IF st_window THEN p_RemstWindow()
        IF screen THEN p_SetDownScreen()
        p_CloseLibraries()
    ELSE
        p_GetChoice()
    ENDIF
    p_RemAPP()
    SELECT exception
        CASE ER_BADARGS;    WriteF('Bad Args.\n')
        CASE ER_ONLYCLI;    WriteF('Only cli prg.\n')
        CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.\n')
        CASE ER_VISUAL;     WriteF('Error Visual.\n')
        CASE ER_CONTEXT;    WriteF('Error Context.\n')
        CASE ER_MENUS;      WriteF('Error Menus.\n')
        CASE ER_GADGET;     WriteF('Error Gadget.\n')
        CASE ER_WINDOW;     WriteF('Error Window.\n')
    ENDSELECT
    IF test=TRUE
        WriteF('\s\n',cmd)
    ELSE
        IF run=FALSE
            Execute(cmd,0,stdout)
        ELSE
            myExecute(cmd,'S:')
        ENDIF
    ENDIF
ENDPROC
/**/
