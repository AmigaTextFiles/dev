/*********************************/
/* OpenClose Libraries           */
/*********************************/
PROC p_OpenLibraries() HANDLE /*"p_OpenLibraries()"*/
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (whatisbase:=OpenLibrary('whatis.library',3))=NIL THEN Raise(ER_WHATISLIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))=NIL THEN Raise(ER_REQTOOLSLIB)
    IF (execbase:=OpenLibrary('exec.library',37))=NIL THEN Raise(ER_EXECLIB)
    IF (workbenchbase:=OpenLibrary('workbench.library',37))=NIL THEN Raise(ER_WORKBENCHLIB)
    IF (utilitybase:=OpenLibrary('utility.library',37))=NIL THEN Raise(ER_UTILITYLIB)
    IF (dosbase:=OpenLibrary('dos.library',37))=NIL THEN Raise(ER_DOSLIB)
    IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN Raise(ER_ICONLIB)
    IF (rexxsysbase:=OpenLibrary('rexxsyslib.library',36))=NIL THEN Raise(ER_REXXSYSLIBLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_CloseLibraries()  /*"p_CloseLibraries()"*/
    IF rexxsysbase THEN CloseLibrary(rexxsysbase)
    IF iconbase THEN CloseLibrary(iconbase)
    IF dosbase THEN CloseLibrary(dosbase)
    IF utilitybase THEN CloseLibrary(utilitybase)
    IF workbenchbase THEN CloseLibrary(workbenchbase)
    IF execbase THEN CloseLibrary(execbase)
    IF whatisbase THEN CloseLibrary(whatisbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
/*********************************/
/* Window Proc                   */
/*********************************/
PROC p_SetUpScreen() HANDLE /*"p_SetUpScreen()"*/
    IF (screen:=LockPubScreen('Workbench'))=NIL THEN Raise(ER_LOCKSCREEN)
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)+1
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_SetDownScreen() /*"p_SetDownScreen()"*/
    IF visual THEN FreeVisualInfo(visual)
    IF screen THEN UnlockPubScreen(NIL,screen)
    screen:=NIL
ENDPROC
PROC p_InitwvWindow() HANDLE /*"p_InitwvWindow()"*/
    IF (wv_glist:=CreateContext({wv_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_whatview:=CreateGadgetA(BUTTON_KIND,wv_glist,[18,17,91,12,'_Whatview',tattr,0,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_info:=CreateGadgetA(BUTTON_KIND,g_whatview,[109,17,91,12,'_Info',tattr,1,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_addicon:=CreateGadgetA(BUTTON_KIND,g_info,[200,17,91,12,'_AddIcon',tattr,2,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_execute:=CreateGadgetA(BUTTON_KIND,g_addicon,[18,30,91,12,'_Execute',tattr,3,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_prefs:=CreateGadgetA(BUTTON_KIND,g_execute,[109,30,91,12,'_Prefs',tattr,4,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_quit:=CreateGadgetA(BUTTON_KIND,g_prefs,[200,30,91,12,'_Quit',tattr,5,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RenderwvWindow() /*"p_RenderwvWindow()"*/
    DrawBevelBoxA(wv_window.rport,9,14,290,33,[GTBB_RECESSED,0,GT_VISUALINFO,visual,TAG_DONE,0])
    RefreshGList(g_whatview,wv_window,NIL,-1)
    Gt_RefreshWindow(wv_window,NIL)
ENDPROC
PROC p_OpenwvWindow() HANDLE /*"p_OpenwvWindow()"*/
    IF (wv_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,winx,
                       WA_TOP,winy,
                       WA_WIDTH,307,
                       WA_HEIGHT,51,
                       WA_IDCMP,$240,
                       WA_FLAGS,$102E,
                       WA_GADGETS,wv_glist,
                       WA_TITLE,'WhatView v0.15 © NasGûl',
                       WA_SCREENTITLE,'Made With GadToolsBox v2.0 © 1991-1993',
                       TAG_DONE]))=NIL
        IF (wv_window:=OpenWindowTagList(NIL,
                          [WA_LEFT,10,
                           WA_TOP,10,
                           WA_WIDTH,307,
                           WA_HEIGHT,51,
                           WA_IDCMP,$240,
                           WA_FLAGS,$102E,
                           WA_GADGETS,wv_glist,
                           WA_TITLE,'WhatView v0.15 © NasGûl',
                           WA_SCREENTITLE,'Made With GadToolsBox v2.0 © 1991-1993',
                           TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    ENDIF
    p_RenderwvWindow()
    IF (appwindow:=AddAppWindowA(0,0,wv_window,prgport,NIL))=NIL THEN Raise(ER_APPWIN)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RemwvWindow() /*"p_RemwvWindow()"*/
    IF appwindow THEN RemoveAppWindow(appwindow)
    winx:=wv_window.leftedge
    winy:=wv_window.topedge
    IF wv_window THEN CloseWindow(wv_window)
    IF wv_glist THEN FreeGadgets(wv_glist)
    wv_window:=NIL
ENDPROC
PROC p_OpenWindow() HANDLE /*"p_OpenWindow()"*/
    DEF t
    IF (t:=p_SetUpScreen())<>ER_NONE THEN Raise(t)
    IF (t:=p_InitwvWindow())<>ER_NONE THEN Raise(t)
    IF (t:=p_OpenwvWindow())<>ER_NONE THEN Raise(t)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_CloseWindow() /*"p_CloseWindow()"*/
    p_RemwvWindow()
    p_SetDownScreen()
ENDPROC
/*********************************/
/* DEBUG PROC                    */
/*********************************/
PROC dWriteF(format,data) /*"dWriteF(format,dat)"*/
/********************************************************************************
 * Para         : PTR TO LONG like ['\s','\d'],idem like [string,address]
 * Return       : NONE
 * Description  : WriteF() if DEBUG=TRUE.
 *******************************************************************************/
    DEF p_format[10]:LIST
    DEF p_data[10]:LIST
    DEF b
    p_format:=format
    p_data:=data
    FOR b:=0 TO ListLen(p_format)-1
        IF DEBUG=TRUE THEN WriteF(p_format[b],p_data[b])
    ENDFOR
ENDPROC
/*********************************/
/* Listes proc                   */
/*********************************/
PROC p_InitList() HANDLE /*"p_InitList()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : address of the new list if ok,else NIL.
 * Description  : Initialise a list.
 *******************************************************************************/
    DEF i_list:PTR TO lh
    i_list:=New(SIZEOF lh)
    i_list.tail:=0
    i_list.head:=i_list.tail
    i_list.tailpred:=i_list.head
    i_list.type:=0
    i_list.pad:=0
    IF i_list THEN Raise(i_list) ELSE Raise(NIL)
EXCEPT
    RETURN exception
ENDPROC
PROC p_GetNumNode(ptr_list,adr_node) /*"p_GetNumNode(ptr_list,adr_node)"*/
/********************************************************************************
 * Para         : address of list,address of node
 * Return       : the number of the node.
 * Description  : Find the number of a node.
 *******************************************************************************/
    DEF g_list:PTR TO lh
    DEF g_node:PTR TO ln
    DEF count=0
    g_list:=ptr_list
    g_node:=g_list.head
    WHILE g_node
        IF g_node=adr_node THEN RETURN count
        INC count
        g_node:=g_node.succ
    ENDWHILE
    RETURN NIL
ENDPROC
PROC p_CleanActionList(list:PTR TO lh) /*"p_CleanActionList(list:PTR TO lh)"*/
    DEF eactnode:PTR TO actionnode
    DEF node:PTR TO ln
    eactnode:=list.head
    WHILE eactnode
        node:=eactnode
        IF node.succ<>0
            IF node.name THEN DisposeLink(node.name)
            IF eactnode.command THEN DisposeLink(eactnode.command)
            IF eactnode.currentdir THEN DisposeLink(eactnode.currentdir)
            IF eactnode.cmd THEN DisposeLink(eactnode.cmd)
            IF eactnode THEN Dispose(eactnode)
            IF node.succ=0
                RemTail(list)
            ELSEIF node.pred=0
                RemHead(list)
            ELSEIF (node.succ<>0) AND (node.pred<>0)
                Remove(node)
            ENDIF
        ENDIF
        eactnode:=node.succ
    ENDWHILE
    list.tail:=0
    list.head:=list.tail
    list.tailpred:=list.head
    list.type:=0
    list.pad:=0
ENDPROC
PROC p_EmptyList(adr_list) /*"p_EmptyList(adr_list)"*/
/********************************************************************************
 * Para         : address of list.
 * Return       : TRUE if list is empty,else address of list.
 * Description  : Look if a list is empty.
 *******************************************************************************/
    DEF e_list:PTR TO lh,count=0
    DEF e_node:PTR TO ln
    e_list:=adr_list
    e_node:=e_list.head
    WHILE e_node
        IF e_node.succ<>0 THEN INC count
        e_node:=e_node.succ
    ENDWHILE
    IF count=0 THEN RETURN TRUE ELSE RETURN e_list
ENDPROC
PROC p_RemoveActionList(list:PTR TO lh,mode) /*"p_RemoveActionList(list:PTR TO lh,mode)"*/
    p_CleanActionList(list)
    IF mode=TRUE
        IF list THEN Dispose(list)
    ENDIF
ENDPROC
PROC p_AjouteArgNode(list:PTR TO lh,argname,arglock) /*"p_AjouteArgNode(list:PTR TO lh,argname,arglock)"*/
    DEF myarg:PTR TO wvarg
    DEF node:PTR TO ln
    DEF pv[256]:STRING
    DEF fullname[256]:STRING
    DEF idstring[9]:STRING
    DEF nn,idtype,lock=NIL,fib:fileinfoblock
    DEF size
    myarg:=New(SIZEOF wvarg)
    NameFromLock(arglock,pv,256)
    AddPart(pv,'',256)
    IF EstrLen(argname)<>0
        StringF(fullname,'\s\s',pv,argname)
    ELSE
        StringF(fullname,'\s',pv)
    ENDIF
    IF lock:=Lock(fullname,-2)
        IF Examine(lock,fib)
            size:=fib.size
            IF fib.size=0
                StringF(fullname,'\s',pv)
                StringF(argname,'\s',fib.filename)
            ELSE
            ENDIF
            IF fib THEN Dispose(fib)
        ENDIF
        IF lock THEN UnLock(lock)
    ENDIF
    myarg.lock:=DupLock(arglock)
    idtype:=WhatIs(fullname,[WI_DEEP,1])
    idstring:=GetIDString(idtype)
    node:=New(SIZEOF ln)
    node.succ:=0
    myarg.size:=size
    node.name:=String(EstrLen(argname))
    StrCopy(node.name,argname,ALL)
    CopyMem(node,myarg.node,SIZEOF ln)
    AddTail(list,myarg.node)
    nn:=p_GetNumNode(list,myarg.node)
    IF nn=0
        list.head:=myarg.node
        node.pred:=0
    ENDIF
    IF idstring
        StringF(pv,'\s',idstring)
        myarg.idstring:=String(EstrLen(pv))
        StrCopy(myarg.idstring,pv,ALL)
    ENDIF
    IF node THEN Dispose(node)
ENDPROC
PROC p_RemoveArgList(list:PTR TO lh,mode) /*"p_RemoveArgList(list:PTR TO lh,mode)"*/
    DEF rarg:PTR TO wvarg
    DEF node:PTR TO ln
    rarg:=list.head
    WHILE rarg
        node:=rarg
        IF node.succ<>0
            IF node.name THEN DisposeLink(node.name)
            IF rarg.lock THEN UnLock(rarg.lock)
            /*IF rarg.date THEN Dispose(rarg.date)*/
            IF rarg.idstring THEN DisposeLink(rarg.idstring)
        ENDIF
        IF node.succ=0
            RemTail(list)
        ELSEIF node.pred=0
            RemHead(list)
        ELSEIF (node.succ<>0) AND (node.pred<>0)
            Remove(node)
        ENDIF
        rarg:=node.succ
    ENDWHILE
    IF mode=TRUE
        IF list THEN Dispose(list)
    ENDIF
ENDPROC
PROC p_WriteFArgList(list:PTR TO lh,action) /*"p_WriteFArgList(list:PTR TO lh,action)"*/
    DEF rarg:PTR TO wvarg
    DEF node:PTR TO ln
    DEF anode:PTR TO actionnode
    DEF mode
    DEF piv[4096]:STRING
    DEF fullname[256]:STRING
    DEF mywbarg:PTR TO wbarg,posbuf=NIL
    DEF oldcd,retstr[256]:STRING
    rarg:=list.head
    WHILE rarg
        node:=rarg
        IF node.succ<>0
                SELECT action
                    CASE ACT_WHATVIEW
                        IF anode:=FindName(myw.adractionlist,rarg.idstring)
                            mode:=anode.exectype
                            IF anode.numarg=0
                                posbuf:=anode.arglist
                            ELSE
                                posbuf:=anode.arglist+(anode.numarg*SIZEOF wbarg)
                            ENDIF
                            SELECT mode
                                CASE MODE_WB
                                    IF anode.numarg<maxarg
                                        anode.numarg:=anode.numarg+1
                                        mywbarg:=New(SIZEOF wbarg)
                                        mywbarg.lock:=rarg.lock
                                        IF node.name
                                            mywbarg.name:=node.name
                                        ELSE
                                            mywbarg.name:=''
                                        ENDIF
                                        CopyMem(mywbarg,posbuf,SIZEOF wbarg)
                                        posbuf:=posbuf+(anode.numarg*SIZEOF wbarg)
                                        IF mywbarg THEN Dispose(mywbarg)
                                    ENDIF
                                    anode.cmd:=0
                                CASE MODE_CLI
                                    anode.numarg:=-1
                                    NameFromLock(rarg.lock,piv,256)
                                    IF rarg.size<>0 THEN AddPart(piv,node.name,256)
                                    StringF(fullname,' "\s" ',piv)
                                    StringF(piv,'\s \s',anode.cmd,fullname)
                                    IF anode.cmd THEN DisposeLink(anode.cmd)
                                    anode.cmd:=String(EstrLen(piv))
                                    StrCopy(anode.cmd,piv,ALL)
                            ENDSELECT
                        ELSE
                            IF p_MakeWVRequest('Pas de commande pour:\nFichier :\s\nType    :\s\nSize    :\d\nDate:\s','_Suivant|S_ortie',[node.name,rarg.idstring,rarg.size,rarg.date])=FALSE THEN JUMP exit
                        ENDIF
                    CASE ACT_INFO
                        IF p_MakeWVRequest('Fichier :\s\nType    :\s\nSize    :\d\nDate:\s','_Suivant|S_ortie',[node.name,rarg.idstring,rarg.size,rarg.date])=FALSE THEN JUMP exit
                    CASE ACT_ADDICON
                        NameFromLock(rarg.lock,piv,256)
                        IF rarg.size<>0 THEN AddPart(piv,node.name,256)
                        StringF(fullname,'\s',piv)
                        p_AddIcon(fullname,node.name,rarg.size,rarg.idstring)
                    CASE ACT_EXECUTE
                        IF retstr:=p_MakeWVStringReq(node.name,rarg.idstring,rarg.size)
                            oldcd:=CurrentDir(rarg.lock)
                            StringF(piv,'\s \s',retstr,node.name)
                            Execute(piv,0,stdout)
                            CurrentDir(oldcd)
                        ENDIF
                ENDSELECT
        ENDIF
        rarg:=node.succ
    ENDWHILE
    exit:
    p_WriteFActionList(myw.adractionlist,ACT_WHATVIEW)
ENDPROC
PROC p_WriteFActionList(list:PTR TO lh,action) /*"p_WriteFActionList(list:PTR TO lh,action)"*/
    DEF eactnode:PTR TO actionnode
    DEF node:PTR TO ln
    DEF mode=NIL
    DEF pv[4096]:STRING
    eactnode:=list.head
    WHILE eactnode
        node:=eactnode
        IF node.succ<>0
            SELECT action
                CASE ACT_WHATVIEW
                        mode:=eactnode.exectype
                        IF (eactnode.numarg>0) OR (eactnode.numarg=-1)
                            SELECT mode
                                CASE MODE_WB
                                    p_WBRun(eactnode.command,eactnode.currentdir,eactnode.stack,eactnode.priority,eactnode.numarg,eactnode.arglist)
                                    eactnode.numarg:=0
                                CASE MODE_CLI
                                    StringF(pv,'\s \s',eactnode.command,eactnode.cmd)
                                    p_CLIRun(pv,eactnode.currentdir,eactnode.stack,eactnode.priority)
                            ENDSELECT
                        ENDIF
                CASE ACT_INFO
            ENDSELECT
        ENDIF
        eactnode:=node.succ
    ENDWHILE
ENDPROC
PROC p_CleanArgActionList(list:PTR TO lh) /*"p_CleanArgActionList(list:PTR TO lh)"*/
    DEF eactnode:PTR TO actionnode
    DEF node:PTR TO ln
    eactnode:=list.head
    WHILE eactnode
        node:=eactnode
        IF node.succ<>0
            eactnode.numarg:=0
            IF eactnode.cmd THEN DisposeLink(eactnode.cmd)
        ENDIF
        eactnode:=node.succ
    ENDWHILE
    /*
    list.tail:=0
    list.head:=list.tail
    list.tailpred:=list.head
    list.type:=0
    list.pad:=0
    */
ENDPROC

