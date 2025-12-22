DEF argstr[256]:STRING
/*"p_OpenLibraries()"*/
PROC p_OpenLibraries() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Open libraries.
 ==============================================================================*/
    dWriteF(['p_OpenLibraries()\n'],[0])
    IF (execbase:=OpenLibrary('exec.library',37))=NIL THEN Raise(ER_EXECLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (whatisbase:=OpenLibrary('whatis.library',3))=NIL THEN Raise(ER_WHATISLIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))=NIL THEN Raise(ER_REQTOOLSLIB)
    IF (workbenchbase:=OpenLibrary('workbench.library',37))=NIL THEN Raise(ER_WORKBENCHLIB)
    IF (utilitybase:=OpenLibrary('utility.library',37))=NIL THEN Raise(ER_UTILITYLIB)
    IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN Raise(ER_ICONLIB)
    IF (cxbase:=OpenLibrary('commodities.library',37))=NIL THEN Raise(ER_COMMODITIESLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_CloseLibraries()"*/
PROC p_CloseLibraries()  
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : CLose libraries.
 ==============================================================================*/
    dWriteF(['p_CloseLibraries()\n'],[0])
    IF cxbase THEN CloseLibrary(cxbase)
    IF iconbase THEN CloseLibrary(iconbase)
    IF utilitybase THEN CloseLibrary(utilitybase)
    IF workbenchbase THEN CloseLibrary(workbenchbase)
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF whatisbase THEN CloseLibrary(whatisbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF execbase THEN CloseLibrary(execbase)
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
/*"p_SetUpScreen()"*/
PROC p_SetUpScreen() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Lock scrren and get visual infos.
 ==============================================================================*/
    DEF pt:PTR TO textattr
    dWriteF(['p_SetUpScreen()\n'],[0])
    IF (screen:=LockPubScreen(p_LockActivePubScreen()))=NIL THEN Raise(ER_LOCKSCREEN)
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
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Free visual info and unlock screen.
 ==============================================================================*/
    dWriteF(['p_SetDownScreen()\n'],[0])
    IF visual THEN FreeVisualInfo(visual)
    IF screen THEN UnlockPubScreen(NIL,screen)
    screen:=NIL
ENDPROC
/**/
/*"p_SetUpInfoScreen()"*/
PROC p_SetUpInfoScreen() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Lock scrren and get visual infos.
 ==============================================================================*/
    DEF pt:PTR TO textattr
    dWriteF(['p_SetUpInfoScreen()\n'],[0])
    IF (i_screen:=LockPubScreen(p_LockActivePubScreen()))=NIL THEN Raise(ER_LOCKSCREEN)
    IF (i_visual:=GetVisualInfoA(i_screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=i_screen.wbortop+Int(i_screen.rastport+58)-10
    pt:=i_screen.font
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
/*"p_SetDownInfoScreen()"*/
PROC p_SetDownInfoScreen() 
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Free visual info and unlock screen.
 ==============================================================================*/
    dWriteF(['p_SetDownScreen()\n'],[0])
    IF i_visual THEN FreeVisualInfo(i_visual)
    IF i_screen THEN UnlockPubScreen(NIL,i_screen)
    i_screen:=NIL
ENDPROC
/**/
/*"p_InitwvWindow()"*/
PROC p_InitwvWindow() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Build the gadgets lists.
 ==============================================================================*/
    DEF g:PTR TO gadget
    dWriteF(['p_InitwvWindow()\n'],[0])
    IF (g:=CreateContext({wv_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_whatview:=CreateGadgetA(BUTTON_KIND,g,[offx+18,offy+17,91,12,'_Whatview',tattr,0,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_info:=CreateGadgetA(BUTTON_KIND,g_whatview,[offx+109,offy+17,91,12,'_Info',tattr,1,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_addicon:=CreateGadgetA(BUTTON_KIND,g_info,[offx+200,offy+17,91,12,'_AddIcon',tattr,2,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_execute:=CreateGadgetA(BUTTON_KIND,g_addicon,[offx+18,offy+30,91,12,'_Execute',tattr,3,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_prefs:=CreateGadgetA(BUTTON_KIND,g_execute,[offx+109,offy+30,91,12,'_Prefs',tattr,4,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_quit:=CreateGadgetA(BUTTON_KIND,g_prefs,[offx+200,offy+30,91,12,'_Quit',tattr,5,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RenderwvWindow()"*/
PROC p_RenderwvWindow() 
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Redraw Bevelbox and refresh gadgets.
 ==============================================================================*/
    dWriteF(['p_RenderwvWindow()\n'],[0])
    DrawBevelBoxA(wv_window.rport,offx+9,offy+14,290,33,[GTBB_RECESSED,0,GT_VISUALINFO,visual,TAG_DONE])
    RefreshGList(g_whatview,wv_window,NIL,-1)
    Gt_RefreshWindow(wv_window,NIL)
ENDPROC
/**/
/*"p_OpenwvWindow()"*/
PROC p_OpenwvWindow() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Open WhatView Window (init app window).
 ==============================================================================*/
    DEF txt[80]:STRING
    StringF(txt,'WhatView <\s>',hotkey)
    StrCopy(wtxt,txt,ALL)
    dWriteF(['p_OpenwvWindow()\n'],[0])
    IF undermouse=TRUE
        winx:=screen.mousex-153
        winy:=screen.mousey-25
    ENDIF
    IF (wv_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,winx,
                       WA_TOP,winy,
                       WA_WIDTH,offx+307,
                       WA_HEIGHT,offy+51,
                       WA_IDCMP,$240+IDCMP_RAWKEY,
                       WA_FLAGS,$102E,
                       WA_GADGETS,wv_glist,
                       WA_CUSTOMSCREEN,screen,
                       WA_TITLE,wtxt,
                       WA_SCREENTITLE,title_req,
                       TAG_DONE]))=NIL
        IF (wv_window:=OpenWindowTagList(NIL,
                          [WA_LEFT,10,
                           WA_TOP,10,
                           WA_WIDTH,offx+307,
                           WA_HEIGHT,offy+51,
                           WA_IDCMP,$240,
                           WA_FLAGS,$102E,
                           WA_GADGETS,wv_glist,
                           WA_TITLE,wtxt,
                           WA_SCREENTITLE,title_req,
                           TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    ENDIF
    p_RenderwvWindow()
    IF (appwindow:=AddAppWindowA(0,0,wv_window,prgport,NIL))=NIL THEN Raise(ER_APPWIN)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemwvWindow()"*/
PROC p_RemwvWindow() 
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : rem app window free gadgets lists and close WhatView Window.
 ==============================================================================*/
    dWriteF(['p_RemwvWindow()\n'],[0])
    IF appwindow THEN RemoveAppWindow(appwindow)
    winx:=wv_window.leftedge
    winy:=wv_window.topedge
    IF wv_window THEN CloseWindow(wv_window)
    IF wv_glist THEN FreeGadgets(wv_glist)
    wv_window:=NIL
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
    IF (t:=p_InitwvWindow())<>ER_NONE THEN Raise(t)
    IF (t:=p_OpenwvWindow())<>ER_NONE THEN Raise(t)
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
    IF wv_window THEN p_RemwvWindow()
    IF screen THEN p_SetDownScreen()
ENDPROC
/**/
/*"p_InitinfoWindow()"*/
PROC p_InitinfoWindow() HANDLE
    DEF g:PTR TO gadget
    IF (g:=CreateContext({info_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_inform:=CreateGadgetA(LISTVIEW_KIND,g,[offx+4,offy+12,513,73,'',tattr,0,0,i_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTLV_READONLY,GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RenderinfoWindow()"*/
PROC p_RenderinfoWindow() 
    Gt_SetGadgetAttrsA(g_inform,info_window,NIL,[GA_RELVERIFY,TRUE,GTLV_LABELS,infolist,TAG_DONE])
    RefreshGList(g_inform,info_window,NIL,-1)
    Gt_RefreshWindow(info_window,NIL)
    ActivateWindow(info_window)
    WindowToFront(info_window)
ENDPROC
/**/
/*"p_OpeninfoWindow()"*/
PROC p_OpeninfoWindow() HANDLE 
    IF (info_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,356,
                       WA_TOP,89,
                       WA_WIDTH,offx+522,
                       WA_HEIGHT,offy+82,
                       WA_IDCMP,$400278+IDCMP_RAWKEY,
                       WA_FLAGS,$102E,
                       WA_GADGETS,info_glist,
                       WA_CUSTOMSCREEN,i_screen,
                       WA_TITLE,'WhatView Informations.',
                       WA_SCREENTITLE,title_req,
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    Gt_RefreshWindow(info_window,NIL)
    p_RenderinfoWindow()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_ReminfoWindow()"*/
PROC p_ReminfoWindow() 
    DEF mes
    IF info_window<>NIL
        WHILE (mes:=Gt_GetIMsg(info_window.userport)) DO Gt_ReplyIMsg(mes)
        CloseWindow(info_window)
    ENDIF
    IF info_glist THEN FreeGadgets(info_glist)
    info_window:=NIL
ENDPROC
/**/
/*"p_OpenInfoWindow()"*/
PROC p_OpenInfoWindow() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Lock,init gagets lists and open whatview window.
 ==============================================================================*/
    DEF t
    dWriteF(['p_OpenInfoWindow()\n'],[0])
    IF (t:=p_SetUpInfoScreen())<>ER_NONE THEN Raise(t)
    IF (t:=p_InitinfoWindow())<>ER_NONE THEN Raise(t)
    IF (t:=p_OpeninfoWindow())<>ER_NONE THEN Raise(t)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_CloseInfoWindow()"*/
PROC p_CloseInfoWindow() 
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : free gadgets lists,close window and unlock screen.
 ==============================================================================*/
    dWriteF(['p_CloseInfoWindow()\n'],[0])
    IF info_window THEN p_ReminfoWindow()
    IF infolist THEN p_CleanList(infolist,FALSE,0,LIST_CLEAN)
    IF i_screen THEN p_SetDownInfoScreen()
ENDPROC
/**/
/*"dWriteF(format,dat)"*/
PROC dWriteF(format,data) 
/*===============================================================================
 = Para         : PTR TO LONG,PTR TO LONG
 = Return       : NONE
 = Description  : WriteF() if DEBUG=TRUE.
 ==============================================================================*/
    DEF p_format[10]:LIST
    DEF p_data[10]:LIST
    DEF b
    p_format:=format
    p_data:=data
    FOR b:=0 TO ListLen(p_format)-1
        IF DEBUG=TRUE THEN WriteF(p_format[b],p_data[b])
    ENDFOR
ENDPROC
/**/
/*"p_InitList()"*/
PROC p_InitList() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : Address of a new list if ok,else NIL.
 = Description  : Initialise a list.
 ==============================================================================*/
    DEF i_list:PTR TO lh
    dWriteF(['p_InitList()\n'],[0])
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
/**/
/*"p_GetNumNode(ptr_list,adr_node)"*/
PROC p_GetNumNode(ptr_list,adr_node) 
/*===============================================================================
 = Para         : address of list,address of node.
 = Return       : the num of node.
 = Description  : find the number of a node.
 ==============================================================================*/
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
    /*RETURN NIL*/
    RETURN -1
ENDPROC
/**/
/*"p_CleanActionList(list:PTR TO lh)"*/
PROC p_CleanActionList(list:PTR TO lh) 
/*===============================================================================
 = Para         : address of list.
 = Return       : NONE
 = Description  : Clean the Action List.
 ==============================================================================*/
    DEF eactnode:PTR TO actionnode
    DEF node:PTR TO ln
    dWriteF(['p_CleanActionList()\n'],[0])
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
/**/
/*"p_EmptyList(adr_list)"*/
PROC p_EmptyList(adr_list) 
/*===============================================================================
 = Para         : address of list.
 = Return       : TRUE if list is empty,else the address of list.
 = Description  : look if a list is empty.
 ==============================================================================*/
    DEF e_list:PTR TO lh,count=0
    DEF e_node:PTR TO ln
    dWriteF(['p_EmptyList()\n'],[0])
    e_list:=adr_list
    e_node:=e_list.head
    WHILE e_node
        IF e_node.succ<>0 THEN INC count
        dWriteF(['Count \d\n'],[count])
        e_node:=e_node.succ
    ENDWHILE
    IF count=0 THEN RETURN TRUE ELSE RETURN e_list
ENDPROC
/**/
/*"p_RemoveActionList(list:PTR TO lh,mode)"*/
PROC p_RemoveActionList(list:PTR TO lh,mode) 
/*===============================================================================
 = Para         : address of list,mode (FALSE or TRUE)
 = Return       : NONE
 = Description  : Clean Action list if mode=FALSE,Clean and Remove if mode=TRUE.
 ==============================================================================*/
    dWriteF(['p_RemoveActionList()\n'],[0])
    p_CleanActionList(list)
    IF mode=TRUE
        IF list THEN Dispose(list)
    ENDIF
ENDPROC
/**/
/*"p_AjouteArgNode(list:PTR TO lh,argname,arglock)"*/
PROC p_AjouteArgNode(list:PTR TO lh,argname,arglock) 
/*===============================================================================
 = Para         : address of list,argname (STRING), arglock.
 = Return       : NONE
 = Description  : Add a argument to the Arg List.
 ==============================================================================*/
    DEF myarg:PTR TO wvarg
    DEF node:PTR TO ln
    DEF pv[256]:STRING
    DEF fullname[256]:STRING
    DEF idstring[9]:STRING
    DEF nn,idtype,lock=NIL,fib:fileinfoblock
    DEF size
    DEF reelname[256]:STRING
    DEF reellock=NIL
    DEF datestring[80]:STRING
    StringF(reelname,'\s',argname)
    reellock:=arglock
    dWriteF(['p_AjouteArgNode()\n'],[0])
    myarg:=New(SIZEOF wvarg)
    NameFromLock(arglock,pv,256)
    AddPart(pv,'',256)
    IF EstrLen(reelname)<>0
        StringF(fullname,'\s\s',pv,reelname)
    ELSE
        StringF(fullname,'\s',pv)
    ENDIF
    IF lock:=Lock(fullname,-2)
        IF Examine(lock,fib)
            size:=fib.size
            IF fib.size=0
                StringF(fullname,'\s\s',pv,argname)
                StringF(argname,'\s',fib.filename)
            ELSE
            ENDIF
            IF fib THEN Dispose(fib)
        ENDIF
        dWriteF(['Lock() \h[8] ','ArgLock() \h[8]',' ReelLock \h[8]\n'],[lock,arglock,reellock])
        StrCopy(datestring,p_GetReelDate(fib.datestamp),ALL)
        IF lock THEN UnLock(lock)
    ENDIF
    myarg.lock:=DupLock(reellock)
    dWriteF(['Lock() \h[8] ','ArgLock() \h[8] ','DupLock() \h[8]\n'],[lock,arglock,myarg.lock])
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
    IF nn=-1
        list.head:=myarg.node
        node.pred:=0
    ENDIF
    IF idstring
        StringF(pv,'\s',idstring)
        myarg.idstring:=String(EstrLen(pv))
        StrCopy(myarg.idstring,pv,ALL)
    ENDIF
    IF datestring
        myarg.date:=String(EstrLen(datestring))
        StrCopy(myarg.date,datestring,ALL)
    ENDIF
    IF node THEN Dispose(node)
ENDPROC
/**/
/*"p_RemoveArgList(list:PTR TO lh,mode)"*/
PROC p_RemoveArgList(list:PTR TO lh,mode) 
/*===============================================================================
 = Para         : address of a list,mode (TRUE or FALSE).
 = Return       : NONE
 = Description  : Remove all nodes of tha Arg List,if mode=TRUE remove the list too.
 ==============================================================================*/
    DEF rarg:PTR TO wvarg
    DEF node:PTR TO ln
    dWriteF(['p_RemoveArgList()\n'],[0])
    rarg:=list.head
    WHILE rarg
        node:=rarg
        IF node.succ<>0
            IF node.name THEN DisposeLink(node.name)
            IF rarg.lock THEN UnLock(rarg.lock)
            IF rarg.date THEN DisposeLink(rarg.date)
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
    ELSE
        list.tail:=0
        list.head:=list.tail
        list.tailpred:=list.head
        list.type:=0
        list.pad:=0
    ENDIF
ENDPROC
/**/
/*"p_WriteFArgList(list:PTR TO lh,action)"*/
PROC p_WriteFArgList(list:PTR TO lh,action) 
/*===============================================================================
 = Para         : address of list,action (ACT_WHATVIEW report to p_WriteFActionList()).
 = Return       : NONE
 = Description  : Perform command with is arguments (ACT_INFO,ACT_ADDICON,ACT_EXECUTE).
 ==============================================================================*/
    DEF rarg:PTR TO wvarg
    DEF node:PTR TO ln
    DEF sn:PTR TO ln
    DEF anode:PTR TO actionnode
    DEF panode:PTR TO actionnode
    DEF mode
    DEF piv[4096]:STRING
    DEF fullname[256]:STRING
    DEF mywbarg:PTR TO wbarg,posbuf=NIL
    DEF oldcd,retstr
    DEF infostr[256]:STRING
    DEF l
    DEF idtype,parentidtype,parentstrtype[9]:STRING
    dWriteF(['p_WriteFArgList()\n'],[0])
    rarg:=list.head
    WHILE rarg
        node:=rarg
        IF node.succ<>0
                SELECT action
                    CASE ACT_WHATVIEW
                        IF anode:=FindName(myw.adractionlist,rarg.idstring)
                            IF anode.usesubtype
                                StringF(infostr,'\s',rarg.idstring)
                                idtype:=GetIDType(infostr)
                                parentidtype:=ParentFileType(idtype)
                                parentstrtype:=GetIDString(parentidtype)
                                IF panode:=FindName(myw.adractionlist,parentstrtype)
                                    anode:=panode
                                ELSE
                                    p_MakeWVRequest(get_WhatView_string(MSGWHATVIEW_COMASS),
                                                    get_WhatView_string(MSGWHATVIEW_COMASS_GAD),[rarg.idstring,parentstrtype])
                                    JUMP skip
                                ENDIF
                            ENDIF
                            mode:=anode.exectype
                            IF anode.numarg=0
                                posbuf:=anode.arglist
                            ELSE
                                posbuf:=anode.arglist+(anode.numarg*SIZEOF wbarg)
                            ENDIF
                            SELECT mode
                                CASE MODE_WB
                                    IF (anode.numarg<maxarg)
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
                            IF p_MakeWVRequest(get_WhatView_string(MSGWHATVIEW_NOCOM),get_WhatView_string(MSGWHATVIEW_NOCOM_GAD),[node.name,rarg.idstring,rarg.size,rarg.date])=FALSE THEN JUMP exit
                        ENDIF
                    CASE ACT_INFO
                        /*IF p_MakeWVRequest('Fichier :\s\nType    :\s\nSize    :\d\nDate    :\s','_Suivant|S_ortie',[node.name,rarg.idstring,rarg.size,rarg.date])=FALSE THEN JUMP exit*/
                        StringF(infostr,'\l\s[32] \r\d[9] \l\s[8] \l\s[9]',node.name,rarg.size,rarg.date,rarg.idstring)
                        p_AjouteNode(infolist,infostr,0)
                    CASE ACT_ADDICON
                        NameFromLock(rarg.lock,piv,256)
                        IF rarg.size<>0 THEN AddPart(piv,node.name,256)
                        StringF(fullname,'\s',piv)
                        dWriteF(['FullName :\s',' Name :\s',' Size:\d',' IDString:\s\n'],[piv,node.name,rarg.size,rarg.idstring])
                        p_AddIcon(fullname,node.name,rarg.size,rarg.idstring)
                    CASE ACT_EXECUTE
                        l:=rarg.lock
                        IF anode:=FindName(myw.adractionlist,rarg.idstring)
                            IF anode.usesubtype
                                StringF(infostr,'\s',rarg.idstring)
                                idtype:=GetIDType(infostr)
                                parentidtype:=ParentFileType(idtype)
                                parentstrtype:=GetIDString(parentidtype)
                                IF panode:=FindName(myw.adractionlist,parentstrtype)
                                    anode:=panode
                                ELSE
                                    p_MakeWVRequest(get_WhatView_string(MSGWHATVIEW_COMASS),
                                                    get_WhatView_string(MSGWHATVIEW_COMASS_GAD),[rarg.idstring,parentstrtype])
                                    JUMP skip
                                ENDIF
                            ENDIF
                            StringF(infostr,'\s "\s"',anode.command,node.name)
                        ELSE
                            StringF(infostr,'"\s"',node.name)
                        ENDIF
                        IF retstr:=p_MakeWVStringReq(node.name,rarg.idstring,rarg.size,infostr)
                            NameFromLock(l,piv,256)
                            oldcd:=CurrentDir(l)
                            StringF(piv,'\s',argstr)
                            /*WriteF('\s \s\n',piv,infostr)*/
                            Execute(piv,0,stdout)
                            CurrentDir(oldcd)
                        ENDIF
                ENDSELECT
                skip:
        ENDIF
        rarg:=node.succ
    ENDWHILE
    exit:
    IF action=ACT_WHATVIEW THEN p_WriteFActionList(myw.adractionlist,ACT_WHATVIEW)
    dWriteF(['Action \d',' Info_Window \h[8]\n'],[action,info_window])
    IF action=ACT_INFO
        IF info_window=NIL
            IF (p_OpenInfoWindow())<>ER_NONE
                p_MakeWVRequest(get_WhatView_string(MSGERWHATVIEW_INFOWINDOW),get_WhatView_string(MSGWHATVIEW_COMASS_GAD),0)
            ENDIF
        ELSE
            p_RenderinfoWindow()
        ENDIF
    ENDIF
ENDPROC
/**/
/*"p_WriteFActionList(list:PTR TO lh,action)"*/
PROC p_WriteFActionList(list:PTR TO lh,action) 
/*===============================================================================
 = Para         : address of list,action (always ACT_WHATVIEW).
 = Return       : NONE
 = Description  : Perform ACT_WHATVIEW.
 ==============================================================================*/
    DEF eactnode:PTR TO actionnode
    DEF node:PTR TO ln
    DEF mode=NIL
    DEF pv[4096]:STRING
    dWriteF(['p_WriteFActionList()\n'],[0])
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
/**/
/*"p_CleanArgActionList(list:PTR TO lh)"*/
PROC p_CleanArgActionList(list:PTR TO lh) 
/*===============================================================================
 = Para         : address of list.
 = Return       : NONE.
 = Description  : Clean the cmd of alls nodes in the Action list.
 ==============================================================================*/
    DEF eactnode:PTR TO actionnode
    DEF node:PTR TO ln
    dWriteF(['p_CleanArgActionList()\n'],[0])
    eactnode:=list.head
    WHILE eactnode
        node:=eactnode
        IF node.succ<>0
            eactnode.numarg:=0
            IF (eactnode.cmd) THEN DisposeLink(eactnode.cmd)
            eactnode.cmd:=0
        ENDIF
        eactnode:=node.succ
    ENDWHILE
ENDPROC
/**/
/*"p_GetReelDate(st)"*/
PROC p_GetReelDate(st) 
    DEF date:PTR TO datetime
    DEF strdate[LEN_DATSTRING]:STRING
    DEF strday[LEN_DATSTRING]:STRING
    DEF strtime[LEN_DATSTRING]:STRING
    DEF r_str[80]:STRING
    /* Date Data */
    date:=New(SIZEOF datetime)
    CopyMem(st,date.stamp,SIZEOF datetime)
    VOID DateStamp(st)
    date.format:=FORMAT_CDN
    date.flags:=0
    date.strdate:=strdate
    date.strday:=strday
    date.strtime:=strtime
    DateToStr(date.stamp)
    IF date THEN Dispose(date)
    StringF(r_str,'\s',strdate)
    RETURN r_str
ENDPROC
/**/
/*"p_MakeWVRequest(bodytext,gadgettext,the_arg)"*/
PROC p_MakeWVRequest(bodytext,gadgettext,the_arg) 
/*===============================================================================
 = Para         : texte (STRING),gadgets (STRING),the_arg.
 = Return       : FALSE if cancel selected,else TRUE.
 = Description  : PopUp a requester (reqtools.library).
 ==============================================================================*/
    DEF ret
    DEF taglist
    dWriteF(['p_MakeWVRequest()\n'],[0])
    IF wv_window<>NIL
        taglist:=[RT_WINDOW,wv_window,RT_LOCKWINDOW,TRUE,RTEZ_REQTITLE,title_req,RT_UNDERSCORE,"_",0]
    ELSE
        taglist:=[RT_PUBSCRNAME,p_LockActivePubScreen(),RTEZ_REQTITLE,title_req,RT_UNDERSCORE,"_",0]
    ENDIF
    ret:=RtEZRequestA(bodytext,gadgettext,0,the_arg,taglist)
    RETURN ret
ENDPROC
/**/
/*"p_MakeWVStringReq(t_reelname,t_idstr,t_size,defcom)"*/
PROC p_MakeWVStringReq(t_reelname,t_idstr,t_size,defcom)
/*===============================================================================
 = Para         : t_reelname (STRING),ID string (STRING),size (LONG).
 = Return       : the result string of request or NIL if cancel selected.
 = Description  : PopUp a StringRequester th choose a command.
 =============================================================================*/
    DEF my_sreq:PTR TO rtfilerequester
    DEF bodyreq[256]:STRING
    DEF buffer[256]:STRING
    DEF return_string[256]:STRING
    DEF ret,taglist
    dWriteF(['p_MakeWVStringReq()\n'],[0])
    StringF(bodyreq,get_WhatView_string(MSGWHATVIEW_EXECCOM),t_reelname,t_idstr,t_size)
    StrCopy(buffer,defcom,ALL)
    IF wv_window<>NIL
        taglist:=[RT_WINDOW,wv_window,RT_LOCKWINDOW,TRUE,RTEZ_REQTITLE,title_req,RTGS_GADFMT,get_WhatView_string(MSGWHATVIEW_EXECCOM_GAD),RTGS_TEXTFMT,bodyreq,RT_UNDERSCORE,"_",0]
    ELSE
        taglist:=[RT_PUBSCRNAME,p_LockActivePubScreen(),RTEZ_REQTITLE,title_req,RTGS_GADFMT,get_WhatView_string(MSGWHATVIEW_EXECCOM_GAD),RTGS_TEXTFMT,bodyreq,RT_UNDERSCORE,"_",0]
    ENDIF
    IF my_sreq:=RtAllocRequestA(RT_REQINFO,NIL)
        ret:=RtGetStringA(buffer,200,title_req,my_sreq,taglist)
        IF ret
            NOP
        ELSE
            buffer:=NIL
        ENDIF
        StringF(argstr,'\s',buffer)
        IF my_sreq THEN RtFreeRequest(my_sreq)
    ELSE
        RETURN FALSE
    ENDIF
    RETURN ret
ENDPROC
/**/
/*"p_WVFileRequester(a)"*/
PROC p_WVFileRequester(a) 
/*===============================================================================
 = Para         : NONE
 = Return       : False if cancel selected.
 = Description  : PopUp a MultiFileRequester,build the whatview arguments.
 ==============================================================================*/
    DEF reqfile:PTR TO rtfilerequester
    DEF liste:PTR TO rtfilelist
    DEF buffer[120]:STRING
    DEF add_liste=0
    DEF ret=FALSE
    DEF the_reelname[256]:STRING
    DEF lock
    reqfile:=NIL
    dWriteF(['p_WVFileRequester()\n'],[0])
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,NIL)
        buffer[0]:=0
        RtChangeReqAttrA(reqfile,[RTFI_DIR,defaultdir,TAG_DONE])
        add_liste:=RtFileRequestA(reqfile,buffer,title_req,
                                  [RT_PUBSCRNAME,p_LockActivePubScreen(),RTFI_FLAGS,FREQF_MULTISELECT+FREQF_PATGAD,RTFI_OKTEXT,oktext[a],RTFI_HEIGHT,200,
                                   RT_UNDERSCORE,"_",TAG_DONE])
        StrCopy(defaultdir,reqfile.dir,ALL)
        IF reqfile THEN RtFreeRequest(reqfile)
        IF add_liste THEN ret:=TRUE
    ELSE
        dWriteF(['p_WVFileRequester() Bad\n'],[0])
        ret:=FALSE
    ENDIF
    IF ret=TRUE
        liste:=add_liste
        IF add_liste
            WHILE liste
                StringF(the_reelname,'\s',liste.name)
                IF lock:=Lock(defaultdir,-2)
                    p_AjouteArgNode(myw.adremptylist,the_reelname,lock)
                    UnLock(lock)
                ENDIF
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

