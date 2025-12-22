/*=========================================================================================*/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */
/*=========================================================================================*/
/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '2'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*======<<<   History   >>>======
 ===============================*/
OPT OSVERSION=37
CONST DEBUG=FALSE
/*"Modules/Erreurs"*/
MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes','exec/ports','eropenlib','utility/tagitem',
       'intuition/intuitionbase'
MODULE 'amigaguide','libraries/amigaguide'
MODULE 'reqtools','libraries/reqtools'
MODULE 'icon','workbench/workbench','workbench/startup','mheader'
MODULE 'commodities','libraries/commodities'
ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_LOCKAG,ER_HANDLEAG,ER_NEWAG,ER_BADARGS,ER_NOICON,ER_PORT,ER_CX
/**/
/*"Globals Definitions"*/
DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offy,offx
/*=======================================
 = xref Definitions
 =======================================*/
DEF xref_window=NIL:PTR TO window
DEF xref_glist=NIL
/*==================*/
/*     Gadgets      */
/*==================*/
CONST GA_G_XREFLIST=0
CONST GA_G_LOADXREF=1
CONST GA_G_EXPUNGEXREF=2
CONST GA_G_FONCTIONLIST=3
CONST GA_G_FILE=4
CONST GA_G_VIEWGUIDE=5
CONST GA_G_VIEWREMEMBER=6
CONST GA_G_REMEMBER=7
CONST GA_G_QUIT=8
/*=============================
 = Gadgets labels of xref
 =============================*/
DEF g_xreflist
DEF g_loadxref
DEF g_expungexref
DEF g_fonctionlist
DEF g_file
DEF g_viewguide
DEF g_viewremember
DEF g_remember
DEF g_quit
/**/
/*"App definitions"*/
DEF keyagbase=NIL
DEF mylist:PTR TO lh
DEF xreflist:PTR TO lh
DEF rememberlist:PTR TO lh
DEF currentnode=-1
DEF handleag=NIL
DEF agsig=-1
DEF myag:PTR TO newamigaguide
DEF defaultdir[256]:STRING
DEF context[20]:LIST
DEF text_include[256]:STRING
DEF xref_file[256]:STRING
DEF docguide[256]:STRING
DEF psn[80]:STRING
DEF baselock,popup=FALSE
/**/
/*"Pmodules"*/
PMODULE 'CxXrefList'
PMODULE 'CxXrefCX'
PMODULE 'Pmodules:PMHeader'
PMODULE 'PModules:dWriteF'
/**/
/*"p_OpenLibraries()"*/
PROC p_OpenLibraries() HANDLE 
    dWriteF(['p_OpenLibraries\n'],0)
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (amigaguidebase:=OpenLibrary('amigaguide.library',34))=NIL THEN Raise(ER_AMIGAGUIDELIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))=NIL THEN Raise(ER_REQTOOLSLIB)
    IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN Raise(ER_ICONLIB)
    IF (cxbase:=OpenLibrary('commodities.library',37))=NIL THEN Raise(ER_COMMODITIESLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_CloseLibraries()"*/
PROC p_CloseLibraries()  
    dWriteF(['p_CloseLibraries()\n'],0)
    IF cxbase THEN CloseLibrary(cxbase)
    IF iconbase THEN CloseLibrary(iconbase)
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF amigaguidebase THEN CloseLibrary(amigaguidebase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
/**/
/*"p_SetUpScreen()"*/
PROC p_SetUpScreen() HANDLE 
    dWriteF(['p_SetUpScreen()\n'],0)
    IF psn=NIL
        IF (screen:=LockPubScreen(p_LockActivePubScreen()))=NIL THEN Raise(ER_LOCKSCREEN)
    ELSE
        IF (screen:=LockPubScreen(psn))=NIL
            IF (screen:=LockPubScreen(p_LockActivePubScreen()))=NIL THEN Raise(ER_LOCKSCREEN)
        ENDIF
    ENDIF
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)-10
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_SetDownScreen()"*/
PROC p_SetDownScreen() 
    dWriteF(['p_SetDownScreen()\n'],0)
    IF visual THEN FreeVisualInfo(visual)
    IF screen THEN UnlockPubScreen(NIL,screen)
ENDPROC
/**/
/*"p_LockActivePubScreen()"*/
PROC p_LockActivePubScreen()
    DEF ps:PTR TO pubscreennode
    DEF s:PTR TO screen
    DEF sn:PTR TO ln
    DEF psl:PTR TO lh
    DEF ret=NIL
    DEF myintui:PTR TO intuitionbase
    dWriteF(['p_LockActivePubScreen()\n'],0)
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

/*"p_InitxrefWindow()"*/
PROC p_InitxrefWindow() HANDLE 
    DEF g:PTR TO gadget
    dWriteF(['p_InitxrefWindow()\n'],0)
    IF (g:=CreateContext({xref_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_xreflist:=CreateGadgetA(LISTVIEW_KIND,g,[offx+36,offy+18,197,32,'XRef File(s).',tattr,0,2,visual,0]:newgadget,[GTLV_READONLY,TRUE,GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_loadxref:=CreateGadgetA(BUTTON_KIND,g_xreflist,[offx+364,offy+18,101,11,'Load Xref',tattr,1,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_expungexref:=CreateGadgetA(BUTTON_KIND,g_loadxref,[offx+364,offy+35,101,11,'ExpungeXRef',tattr,2,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_fonctionlist:=CreateGadgetA(LISTVIEW_KIND,g_expungexref,[offx+36,offy+71,197,40,'Fonctions List.',tattr,3,4,visual,0]:newgadget,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_file:=CreateGadgetA(TEXT_KIND,g_fonctionlist,[offx+288,offy+71,177,11,'File',tattr,4,1,visual,0]:newgadget,[GTTX_BORDER,1,GTTX_TEXT,'',GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_viewguide:=CreateGadgetA(BUTTON_KIND,g_file,[offx+244,offy+83,101,11,'View Guide',tattr,5,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_viewremember:=CreateGadgetA(BUTTON_KIND,g_viewguide,[offx+364,offy+83,101,11,'V Remember',tattr,6,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_remember:=CreateGadgetA(BUTTON_KIND,g_viewremember,[offx+244,offy+96,101,11,'Remember',tattr,7,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_quit:=CreateGadgetA(BUTTON_KIND,g_remember,[offx+364,offy+96,101,11,'Quit',tattr,8,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RenderxrefWindow()"*/
PROC p_RenderxrefWindow() 
    dWriteF(['p_RenderxrefWindow()\n'],0)
    IF currentnode<>-1 THEN p_UpDateFileGadget(currentnode) ELSE Gt_SetGadgetAttrsA(g_file,xref_window,NIL,[GTTX_TEXT,'None.',TAG_DONE])
    IF (p_EmptyList(mylist)<>-1)
        Gt_SetGadgetAttrsA(g_fonctionlist,xref_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,0,GTLV_LABELS,mylist,TAG_DONE])
    ELSE
        Gt_SetGadgetAttrsA(g_fonctionlist,xref_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,TAG_DONE])
    ENDIF
    IF (p_EmptyList(xreflist)<>-1)
        Gt_SetGadgetAttrsA(g_xreflist,xref_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,0,GTLV_LABELS,xreflist,TAG_DONE])
    ELSE
        Gt_SetGadgetAttrsA(g_xreflist,xref_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,TAG_DONE])
    ENDIF
    DrawBevelBoxA(xref_window.rport,offx+10,offy+12,463,42,[GT_VISUALINFO,visual,TAG_DONE,0])
    DrawBevelBoxA(xref_window.rport,offx+12,offy+55,460,56,[GT_VISUALINFO,visual,TAG_DONE,0])
    RefreshGList(g_xreflist,xref_window,NIL,-1)
    Gt_RefreshWindow(xref_window,NIL)
ENDPROC
/**/
/*"p_UpDateFileGadget(num)"*/
PROC p_UpDateFileGadget(num)
    DEF xn:PTR TO xref
    dWriteF(['p_UpDateFileGadget()\n'],0)
    xn:=p_GetAdrNode(mylist,num)
    Gt_SetGadgetAttrsA(g_file,xref_window,NIL,[GTTX_TEXT,xn.file,TAG_DONE])
ENDPROC
/**/
/*"p_OpenxrefWindow()"*/
PROC p_OpenxrefWindow() HANDLE
    dWriteF(['p_OpenxrefWindow()\n'],0)
    IF (xref_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,screen.mousex-240,
                       WA_TOP,screen.mousey-57,
                       WA_WIDTH,offx+481,
                       WA_HEIGHT,offy+114,
                       WA_IDCMP,$278+IDCMP_REFRESHWINDOW+IDCMP_MENUHELP+IDCMP_RAWKEY,
                       WA_FLAGS,$102E+WFLG_HASZOOM,
                       WA_ZOOM,[0,0,offy+290,11]:INT,
                       WA_GADGETS,xref_glist,
                       WA_CUSTOMSCREEN,screen,
                       WA_TITLE,title_req,
                       WA_SCREENTITLE,'Made With GadToolsBox V2.0b © 1991-1993',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    p_RenderxrefWindow()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemxrefWindow()"*/
PROC p_RemxrefWindow() 
    dWriteF(['p_RemxrefWindow()\n'],0)
    IF xref_window THEN CloseWindow(xref_window)
    IF xref_glist THEN FreeGadgets(xref_glist)
    xref_window:=NIL
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
    dWriteF(['p_OpenWindow()\n'],[0])
    IF (t:=p_SetUpScreen())<>ER_NONE THEN Raise(t)
    IF (t:=p_InitxrefWindow())<>ER_NONE THEN Raise(t)
    IF (t:=p_OpenxrefWindow())<>ER_NONE THEN Raise(t)
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
    dWriteF(['p_CloseWindow()\n'],[0])
    IF xref_window THEN p_RemxrefWindow()
    IF screen THEN p_SetDownScreen()
    screen:=NIL
    xref_window:=NIL
ENDPROC
/**/

/*"p_LookAllMessage()"*/
PROC p_LookAllMessage() 
    DEF sigreturn
    DEF xrefport:PTR TO mp
    IF xref_window THEN xrefport:=xref_window.userport ELSE xrefport:=NIL
    sigreturn:=Wait(Shl(1,xrefport.sigbit) OR 
                    agsig OR 
                    cxsigflag OR
                    $F000)
    IF (sigreturn AND Shl(1,xrefport.sigbit))
        IF p_LookxrefMessage()=TRUE THEN p_CloseWindow()
    ENDIF
    IF (sigreturn AND agsig)
        p_LookAmigaGuideMessage()
    ENDIF
    IF (sigreturn AND cxsigflag)
        p_LookCxMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
/**/
/*"p_LookxrefMessage()"*/
PROC p_LookxrefMessage() 
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF type=0,infos=NIL
   DEF ret=FALSE
   WHILE mes:=Gt_GetIMsg(xref_window.userport)
       type:=mes.class
       /*WriteF('\h\n',type)*/
       SELECT type
           CASE IDCMP_REFRESHWINDOW
              p_RenderxrefWindow()
           CASE IDCMP_MENUPICK
              infos:=mes.code
              SELECT infos
              ENDSELECT
           CASE IDCMP_CLOSEWINDOW
              ret:=TRUE
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                  CASE GA_G_XREFLIST
                  CASE GA_G_LOADXREF
                    IF (p_FileRequester())=TRUE THEN p_RenderxrefWindow()
                  CASE GA_G_EXPUNGEXREF
                    Gt_SetGadgetAttrsA(g_file,xref_window,NIL,[GTTX_TEXT,'Clear Xref..',TAG_DONE])
                    ExpungeXRef()
                    currentnode:=-1
                    p_UpDateListes()
                    xreflist:=p_CleanList(xreflist,FALSE,0,LIST_CLEAN)
                    p_RenderxrefWindow()
                  CASE GA_G_FONCTIONLIST
                    currentnode:=mes.code
                    p_UpDateFileGadget(currentnode)
                  CASE GA_G_FILE
                  CASE GA_G_VIEWGUIDE
                    p_ShowAmigaGuideFile(currentnode)
                  CASE GA_G_VIEWREMEMBER
                    p_ViewRememberGuide()
                  CASE GA_G_REMEMBER
                    p_AddToRememberList(currentnode)
                  CASE GA_G_QUIT
                    reelquit:=TRUE
              ENDSELECT
           CASE IDCMP_RAWKEY
              IF mes.code=95 THEN p_CheckMousePosition()
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
   RETURN ret
ENDPROC
/**/
/*"p_LookCxMessage()"*/
PROC p_LookCxMessage() 
    DEF msgid=NIL,msgtype=NIL
    DEF msg
    WHILE msg:=GetMsg(broker_mp) 
        msgid:=CxMsgID(msg)
        msgtype:=CxMsgType(msg) 
        SELECT msgtype 
            CASE CXM_IEVENT 
                SELECT msgid 
                    CASE EVT_HOTKEY_CXREF
                        IF xref_window=NIL
                            p_OpenWindow() 
                        ELSE
                            p_CloseWindow() 
                        ENDIF 
                    CASE EVT_HOTKEY_GUIDE;  p_ShowAmigaGuideFile(currentnode)
                ENDSELECT 
            CASE CXM_COMMAND 
                SELECT msgid
                    CASE CXCMD_KILL 
                        reelquit:=TRUE
                    CASE  CXCMD_DISABLE 
                        ActivateCxObj(broker,0) 
                    CASE CXCMD_ENABLE
                        ActivateCxObj(broker,1) 
                    CASE CXCMD_APPEAR 
                        IF xref_window=NIL
                            p_OpenWindow() 
                        ELSE 
                            WindowToFront(xref_window)
                        ENDIF 
                    CASE CXCMD_DISAPPEAR 
                        IF xref_window<>NIL
                            p_CloseWindow() 
                        ENDIF 
                ENDSELECT
        ENDSELECT
        ReplyMsg(msg)
    ENDWHILE
ENDPROC
/**/

/*"p_AddToRememberList(numnode)"*/
PROC p_AddToRememberList(numnode)
    DEF n:PTR TO ln
    DEF xn:PTR TO xref
    DEF cmd[256]:STRING
    n:=p_GetAdrNode(mylist,numnode)
    xn:=n
    IF n.type=1
        StringF(cmd,'   @{"\s" link "\s/\s"}',n.name,xn.file,xn.name)
        IF FindName(rememberlist,cmd)=0
            p_AjouteNode(rememberlist,cmd,0)
        ELSE
            p_Request('\s est déjà dans Remember.Guide','Merci',[xn.name])
        ENDIF
    ELSE
        StringF(cmd,'    @{"\s" link "\s/Main" \d \d}',n.name,xn.file,xn.line,n.type)
        IF FindName(rememberlist,cmd)=0
            p_AjouteNode(rememberlist,cmd,0)
        ELSE
            p_Request('\s est déjà dans Remember.Guide','Merci',[xn.name])
        ENDIF
    ENDIF
ENDPROC
/**/
/*"p_ViewRememberGuide()"*/
PROC p_ViewRememberGuide()
    DEF h
    DEF oldstdout
    DEF n:PTR TO ln
    IF p_EmptyList(rememberlist)<>-1
        oldstdout:=stdout
        IF h:=Open('T:Remember.Guide',1006)
            stdout:=h
            WriteF('@database "CxXref Remember.Guide"\n')
            WriteF('@node main "Remember List"\n')
            n:=rememberlist.head
            WHILE n
                IF n.succ<>0
                    WriteF('\s\n',n.name)
                ENDIF
                n:=n.succ
            ENDWHILE
            WriteF('@endnode\n')
            IF h THEN Close(h)
        ELSE
            p_Request('Vous devez sortir du Document en cours.','D\aAccord',0)
            JUMP skk
        ENDIF
        stdout:=oldstdout
        myag.name:='T:Remember.guide'
        myag.node:='main'
        myag.line:=0
        myag.context:=0
        SendAmigaGuideCmd(handleag,'Link "T:Remember.guide/main"',NIL)
    ELSE
        p_Request('Le fichier T:Remember.guide ne contient aucun noeud','Merci',0)
    ENDIF
    skk:
ENDPROC
/**/
/*"p_LookAmigaGuideMessage()"*/
PROC p_LookAmigaGuideMessage()
    DEF agmsg:PTR TO amigaguidemsg
    DEF type
    WHILE (agmsg:=GetAmigaGuideMsg(handleag))
        type:=agmsg.type
        /*WriteF('Type :\h Pri_Ret:\h\n',type,agmsg.pri_ret)*/
        ReplyAmigaGuideMsg(agmsg)
    ENDWHILE
ENDPROC
/**/
/*"p_CheckMousePosition()"*/
PROC p_CheckMousePosition()
    DEF myg:PTR TO gadget
    DEF mx=-1,my=-1
    DEF minx,maxx,miny,maxy
    DEF id
    DEF cmd[256]:STRING
    DEF test,found=FALSE
    mx:=xref_window.mousex
    my:=xref_window.mousey
    myg:=g_xreflist
    REPEAT
        minx:=myg.leftedge
        maxx:=myg.leftedge+myg.width
        miny:=myg.topedge
        maxy:=myg.topedge+myg.height
        /*WriteF('Mx :\d My :\d \d \d \d \d\n',mx,my,minx,maxx,miny,maxy)*/
        IF ((mx<maxx) AND (mx>minx))
            IF ((my<maxy) AND (my>miny))
                id:=myg.gadgetid
                myag.name:=docguide
                myag.node:='main'
                myag.line:=0
                myag.context:=context
                StringF(cmd,'link "\s/\s"',docguide,context[id])
                test:=SendAmigaGuideCmd(handleag,cmd,NIL)
                found:=TRUE
                /*WriteF('\s \d\n',cmd,test)*/
            ENDIF
        ENDIF
        myg:=myg.nextgadget
    UNTIL myg=NIL
    IF found=FALSE
        StringF(cmd,'link "\s/\s"',docguide,'COPY')
        test:=SendAmigaGuideCmd(handleag,cmd,NIL)
        /*WriteF('\s \d\n',cmd,test)*/
    ENDIF
ENDPROC
/**/
/*"p_InitAPP()"*/
PROC p_InitAPP() HANDLE
    DEF flist:PTR TO lh
    dWriteF(['p_InitAPP()\n'],0)
    StrCopy(defaultdir,'Ram:',ALL)
    IF EstrLen(text_include)<>0 THEN AssignPath('TEXT_INCLUDE',text_include)
    IF EstrLen(xref_file)<>0 THEN StrCopy(defaultdir,xref_file,ALL)
    IF (keyagbase:=LockAmigaGuideBase(NIL))=NIL THEN Raise(ER_LOCKAG)
    mylist:=p_InitList()
    xreflist:=p_InitList()
    rememberlist:=p_InitList()
    GetAmigaGuideAttr(AGA_XREFLIST,NIL,flist)
    IF (myag:=New(SIZEOF newamigaguide))=NIL THEN Raise(ER_NEWAG)
    myag.basename:='CxXRef'
    myag.name:=docguide
    myag.node:='Main'
    myag.line:=0
    myag.flags:=HTF_CACHE_NODE+HTF_UNIQUE
    context:=['XREFLIST','LOADXREF','EXPUNGEXREF','FONCTIONLIST','FILE','VIEWGUIDE','VIEWREMEMBER','REMEMBER','QUIT',NIL]
    myag.context:=context
    IF (handleag:=OpenAmigaGuideAsync(myag,NIL))=NIL THEN Raise(ER_HANDLEAG)
    agsig:=AmigaGuideSignal(handleag)
    SetAmigaGuideAttrsA(handleag,[AGA_ACTIVATE,TRUE,NIL])
    mylist:=Long(flist)
    UnlockAmigaGuideBase(keyagbase)
    keyagbase:=NIL
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemAPP()"*/
PROC p_RemAPP()
    /*IF keyagbase<>NIL THEN UnlockAmigaGuideBase(keyagbase)*/
    dWriteF(['p_RemAPP()\n'],0)
    IF handleag<>NIL THEN CloseAmigaGuide(handleag)
    DeleteFile('T:Remember.Guide')
    DeleteFile('T:Data.Guide')
ENDPROC
/**/
/*"p_StartCLI()"*/
PROC p_StartCLI() HANDLE
    DEF myargs:PTR TO LONG,rdargs=NIL
    myargs:=[0,0,0,0,0,0,0,0]
    IF rdargs:=ReadArgs('XR=XREF_FILE/K,TI=TEXT_INCLUDE/K,GUIDE/K,PUBSCREEN/K,HT=CX_POPKEY/K,P=CX_PRIORITY/N,HG=CX_HOTKEYGUIDE/K,CX_POPUP/S',myargs,NIL)
        IF myargs[0] THEN StrCopy(xref_file,myargs[0],ALL) ELSE StrCopy(xref_file,'Guide:',ALL)
        IF myargs[1] THEN StrCopy(text_include,myargs[1],ALL) ELSE StrCopy(text_include,'LC:/Compiler_headers',ALL)
        IF myargs[2] THEN StrCopy(docguide,myargs[2],ALL) ELSE StrCopy(docguide,'CxXref.Guide',ALL)
        IF myargs[3] THEN StrCopy(psn,myargs[3],ALL) ELSE StrCopy(psn,'',ALL)
        IF myargs[4] THEN StrCopy(hotkey,myargs[4],ALL) ELSE StrCopy(hotkey,'lcommand esc',ALL)
        IF myargs[5] THEN cxpri:=Long(myargs[5]) ELSE cxpri:=0
        IF myargs[6] THEN StrCopy(hotkeyguide,myargs[6],ALL) ELSE StrCopy(hotkeyguide,'lalt esc',ALL)
        IF myargs[7] THEN popup:=TRUE
    ELSE
        Raise(ER_BADARGS)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF rdargs THEN FreeArgs(rdargs)
    RETURN exception
ENDPROC
/**/
/*"p_StartWB()"*/
PROC p_StartWB() HANDLE
    DEF name[256]:STRING
    DEF wb:PTR TO wbstartup
    DEF args:PTR TO wbarg
    DEF dob:PTR TO diskobject
    DEF data[256]:STRING
    dob:=NIL
    wb:=wbmessage
    args:=wb.arglist
    StrCopy(name,args[0].name,ALL)
    baselock:=CurrentDir(args[0].lock)
    IF (dob:=GetDiskObject(name))
        IF data:=FindToolType(dob.tooltypes,'CX_POPKEY')
            StrCopy(hotkey,data,ALL)
        ELSE
            StrCopy(hotkey,'lcommand esc',ALL)
        ENDIF
        IF data:=FindToolType(dob.tooltypes,'CX_PRIORITY')
            cxpri:=Val(data,NIL)
        ELSE
            cxpri:=0
        ENDIF
        IF data:=FindToolType(dob.tooltypes,'CX_POPUP') THEN popup:=TRUE
        IF data:=FindToolType(dob.tooltypes,'CX_POPKEYGUIDE')
            StrCopy(hotkeyguide,data,ALL)
        ELSE
            StrCopy(hotkeyguide,'lalt esc',ALL)
        ENDIF
        IF data:=FindToolType(dob.tooltypes,'TEXT_INCLUDE')
            StrCopy(text_include,data,ALL)
        ELSE
            StrCopy(text_include,'LC:/Complier_headers',ALL)
        ENDIF
        IF data:=FindToolType(dob.tooltypes,'XREF_FILE')
            StrCopy(xref_file,data,ALL)
        ELSE
            StrCopy(xref_file,'Guide:',ALL)
        ENDIF
        IF data:=FindToolType(dob.tooltypes,'GUIDE')
            StrCopy(docguide,data,ALL)
        ELSE
            StrCopy(docguide,'CxXRef.guide',ALL)
        ENDIF
        IF data:=FindToolType(dob.tooltypes,'PUBSCREEN')
            StrCopy(psn,data,ALL)
        ELSE
            StrCopy(psn,'',ALL)
        ENDIF
    ELSE
        Raise(ER_NOICON)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF dob<>NIL THEN FreeDiskObject(dob)
    IF baselock THEN CurrentDir(baselock)
    RETURN exception
ENDPROC
/**/
/*"p_Request(bodytext,gadgettext,the_arg)"*/
PROC p_Request(bodytext,gadgettext,the_arg)
/*===============================================================================
 = Para         : texte (STRING),gadgets (STRING),the_arg.
 = Return       : FALSE if cancel selected,else TRUE.
 = Description  : PopUp a requester (reqtools.library).
 ==============================================================================*/
    DEF ret
    DEF taglist
    IF xref_window<>NIL
        taglist:=[RT_WINDOW,xref_window,RT_LOCKWINDOW,TRUE,RTEZ_REQTITLE,'CxXRef',RT_UNDERSCORE,"_",0]
    ELSE
        taglist:=[RTEZ_REQTITLE,'CxXRef',RT_UNDERSCORE,"_",0]
    ENDIF
    ret:=RtEZRequestA(bodytext,gadgettext,0,the_arg,taglist)
    RETURN ret
ENDPROC
/**/
/*"p_FileRequester()"*/
PROC p_FileRequester()
/*===============================================================================
 = Para         : NONE
 = Return       : False if cancel selected.
 = Description  : PopUp a MultiFileRequester,build the cxxref arguments.
 ==============================================================================*/
    DEF reqfile:PTR TO rtfilerequester
    DEF liste:PTR TO rtfilelist
    DEF buffer[120]:STRING
    DEF add_liste=0
    DEF ret=FALSE
    DEF the_reelname[256]:STRING
    DEF fullname[256]:STRING
    DEF pv[256]:STRING
    DEF test
    reqfile:=NIL
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,NIL)
        buffer[0]:=0
        RtChangeReqAttrA(reqfile,[RTFI_DIR,defaultdir,TAG_DONE])
        add_liste:=RtFileRequestA(reqfile,buffer,'CxXRef: Load Xref',
                                  [RTFI_FLAGS,FREQF_MULTISELECT,RTFI_OKTEXT,'Load',RTFI_HEIGHT,200,
                                   RT_UNDERSCORE,"_",TAG_DONE])
        StrCopy(defaultdir,reqfile.dir,ALL)
        StrCopy(pv,reqfile.dir,ALL)
        AddPart(pv,'',256)
        IF reqfile THEN RtFreeRequest(reqfile)
        IF add_liste THEN ret:=TRUE
    ELSE
        ret:=FALSE
    ENDIF
    IF ret=TRUE
        liste:=add_liste
        IF add_liste
            Gt_SetGadgetAttrsA(g_file,xref_window,NIL,[GTTX_TEXT,'Wait Loading Xref..',TAG_DONE])
            WHILE liste
                StringF(the_reelname,'\s',liste.name)
                StringF(fullname,'\s\s',pv,the_reelname)
                test:=LoadXRef(NIL,fullname)
                SELECT test
                    CASE -1; NOP
                    CASE  0; p_Request('Impossible de charger \s','Ok',[the_reelname])
                    CASE  1
                        p_AjouteNode(xreflist,the_reelname,0)
                        p_UpDateListes()
                    CASE 2 ; p_Request('\s est déjà chargé','Merci',[the_reelname])
                ENDSELECT
                liste:=liste.next
            ENDWHILE
            IF add_liste THEN RtFreeFileList(add_liste)
        ENDIF
    ELSE
        ret:=FALSE
    ENDIF
    RETURN ret
ENDPROC
/**/
/*"p_UpDateListes()"*/
PROC p_UpDateListes()
    DEF flist
    GetAmigaGuideAttr(AGA_XREFLIST,NIL,flist)
    mylist:=Long(flist)
ENDPROC
/**/
/*"p_ShowAmigaGuideFile(numnode)"*/
PROC p_ShowAmigaGuideFile(numnode)
    DEF n:PTR TO ln
    DEF xn:PTR TO xref
    DEF cmd[256]:STRING
    IF numnode=-1 THEN RETURN
    n:=p_GetAdrNode(mylist,numnode)
    xn:=n
    IF n.type=1
        StringF(cmd,'link "\s"',xn.name)
        myag.name:=xn.file
        myag.node:=xn.name
        myag.line:=xn.line
        myag.context:=0
        SendAmigaGuideCmd(handleag,cmd,NIL)
    ELSE
        IF p_WriteAmigaGuide(xn.file,xn.name,xn.line,n.type)=TRUE
            StrCopy(cmd,'link "T:Data.Guide/Structure Info"',ALL)
            myag.name:='T:data.guide'
            myag.node:='Structure Info'
            myag.line:=xn.line
            myag.context:=0
            SendAmigaGuideCmd(handleag,cmd,NIL)
        ENDIF
    ENDIF
ENDPROC
/**/
/*"p_WriteAmigaGuide(fichier,nom,ligne,type)"*/
PROC p_WriteAmigaGuide(fichier,nom,ligne,type)
    DEF h,ret=TRUE
    DEF oldstdout
    /*
    DEF cmd[256]:STRING
    StringF(cmd,'hd3:Amiga_e_v3.0a/bin/showmodule >T:\s \s',nom,fichier)
    WriteF('\s\n',cmd)
    Execute(cmd,0,stdout)
    StringF(cmd,'T:\s',nom)
    fichier:=cmd
    */
    oldstdout:=stdout
    IF h:=Open('T:Data.Guide',1006)
        stdout:=h
        WriteF('@database "CxXRefv0.0"\n')
        WriteF('@node main\n')
        WriteF('@endnode\n')
        WriteF('@node "Structure Info"\n\n')
        WriteF('    @{"\s" link "\s/Main" \d \d}\n',nom,fichier,ligne,type)
        WriteF('@endnode\n')
        Close(h)
    ELSE
        p_Request('Vous devez sortir du Document en cours.','D\aAccord',0)
        ret:=FALSE
    ENDIF
    stdout:=oldstdout
    RETURN ret
ENDPROC
/**/
/*"main()"*/
PROC main() HANDLE 
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    p_DoReadHeader({banner})
    IF wbmessage<>NIL
        IF (testmain:=p_StartWB())<>ER_NONE THEN Raise(testmain)
    ELSE
        IF (testmain:=p_StartCLI())<>ER_NONE THEN Raise(testmain)
    ENDIF
    IF (testmain:=p_InitCx())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitAPP())<>ER_NONE THEN Raise(testmain)
    IF popup=TRUE THEN p_OpenWindow()
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    IF xref_window<>NIL THEN p_RemxrefWindow()
    IF screen<>NIL THEN p_SetDownScreen()
    p_RemAPP()
    p_RemCx()
    p_CloseLibraries()
    SELECT exception
        CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.')
        CASE ER_VISUAL;     WriteF('Error Visual.')
        CASE ER_CONTEXT;    WriteF('Error Context.')
        CASE ER_MENUS;      WriteF('Error Menus.')
        CASE ER_GADGET;     WriteF('Error Gadget.')
        CASE ER_WINDOW;     WriteF('Error Window.')
        CASE ER_LOCKAG;     WriteF('Error Lock AmigaGuideBase.\n')
        CASE ER_NEWAG;      WriteF('Error Allocate New AmigaGuide.\n')
        CASE ER_HANDLEAG;   WriteF('Error Create AmigaGuideAsync.\n')
        CASE ER_BADARGS;    WriteF('Error ReadArgs() fct.\n')
        CASE ER_NOICON;     WriteF('Error NoIcon.\n')
        CASE ER_AMIGAGUIDELIB;  WriteF('amigaguide.library ?\n')
        CASE ER_REQTOOLSLIB;    WriteF('reqtools.library ?\n')
        CASE ER_PORT;           WriteF('Error CreateMsgPort() for commodities.\n')
        CASE ER_CX;             WriteF('Error Cx.\n')
    ENDSELECT
ENDPROC
/**/
