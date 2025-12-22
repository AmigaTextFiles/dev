PROC p_OpenLibraries() HANDLE /*"p_OpenLibraries()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : ER_NONE if ok,else the error.
 = Description  : Open libraries.
 ==============================================================================*/
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (rexxsysbase:=OpenLibrary('rexxsyslib.library',36))=NIL THEN Raise(ER_REXXSYSLIBLIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL THEN Raise(ER_REQTOOLSLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_CloseLibraries()  /*"p_CloseLibraries()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : CLose libraries.
 ==============================================================================*/
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF rexxsysbase THEN CloseLibrary(rexxsysbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
PROC p_SetUpScreen() HANDLE /*"p_SetUpScreen()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : ER_NONE if ok,else the error.
 = Description  : Lock wb or open the screen.
 ==============================================================================*/
    IF StrCmp(pubscreenname,'Workbench',9)
        NOP
    ELSE
        IF (screen:=OpenScreenTagList(NIL,
                                      [SA_TOP,0,
                                       SA_DEPTH,2,
                                       SA_FONT,tattr,
                                       SA_DISPLAYID,typescreen,
                                       SA_PUBNAME,pubscreenname,
                                       SA_TITLE,'Peps v0.1 © 1994 NasGûl',
                                       SA_PUBSIG,IF (screensig:=AllocSignal(-1))=NIL THEN Raise(ER_SCREENSIG) ELSE screensig,
                                       SA_AUTOSCROLL,TRUE,
                                       SA_TYPE,CUSTOMSCREEN+PUBLICSCREEN,
                                       SA_OVERSCAN,OSCAN_TEXT,
                                       SA_PENS,[0,1,1,2,1,3,1,0,2,1,2,1]:INT,
                                       SA_DETAILPEN,2,
                                       SA_BLOCKPEN,1,
                                       0,0]))=NIL THEN Raise(ER_OPENSCREEN)
        PubScreenStatus(screen,0)
        IF screenbydefault THEN SetDefaultPubScreen(pubscreenname)
        IF screenshanghai THEN SetPubScreenModes(SHANGHAI)
    ENDIF
    IF (screen:=LockPubScreen(pubscreenname))=NIL
        IF (screen:=LockPubScreen('Workbench'))=NIL THEN Raise(ER_LOCKSCREEN)
    ENDIF
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)+1
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_SetDownScreen() /*"p_SetDownScreen()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Unlock screnn,clse screen if screen open,wait all windows
 =                in screen to be closed.
 ==============================================================================*/
    dWriteF(['p_SetDownScreen()\n'],0)
    IF StrCmp(pubscreenname,'Workbench',9)
        IF visual THEN FreeVisualInfo(visual)
        IF screen THEN UnlockPubScreen(NIL,screen)
    ELSE
        IF visual THEN FreeVisualInfo(visual)
        IF screen THEN UnlockPubScreen(NIL,screen)
        IF screen.firstwindow<>0
            Wait(Shl(1,screensig))
        ENDIF
        IF screensig<>-1 THEN FreeSignal(screensig)
        IF screen THEN CloseScreen(screen)
        IF screenbydefault THEN SetDefaultPubScreen(NIL)
    ENDIF
    dWriteF(['p_SetDownScreen() Ok\n'],0)
ENDPROC
PROC p_InitppWindow() HANDLE /*"p_InitppWindow()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : build gadgets list.
 ==============================================================================*/
    dWriteF(['p_InitppWindow()\n'],0)
    IF nomenu=FALSE
        IF (menu:=CreateMenusA(save_list_chip,NIL))=NIL THEN Raise(ER_MENUS)
        IF LayoutMenusA(menu,visual,NIL)=FALSE THEN Raise(ER_MENUS)
    ENDIF
    IF (pp_glist:=CreateContext({pp_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_source:=CreateGadgetA(TEXT_KIND,pp_glist,[80,17,321,12,'ESource',tattr,0,1,visual,0]:newgadget,[GTTX_BORDER,TRUE,GTTX_TEXT,esource,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_filelist:=CreateGadgetA(LISTVIEW_KIND,g_source,[38,40,254,33,'File(s).',tattr,1,2,visual,0]:newgadget,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,-1,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_proclist:=CreateGadgetA(LISTVIEW_KIND,g_filelist,[37,78,254,41,'Proc(s).',tattr,2,2,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTLV_READONLY,TRUE,GTLV_LABELS,-1,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_errorslist:=CreateGadgetA(LISTVIEW_KIND,g_proclist,[39,121,253,81,'Error(s).',tattr,3,2,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTLV_READONLY,TRUE,GTLV_LABELS,-1,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    dWriteF(['p_InitppWindow()  Retour:\d\n'],[exception])
    RETURN exception
ENDPROC
PROC p_RenderppWindow() /*"p_RenderppWindow()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : redraw bevelbox,clean listview if list is empty.
 ==============================================================================*/
    dWriteF(['p_RenderppWindow()\n'],0)
    IF (p_EmptyList(myb.pmodulelist))<>-1
        Gt_SetGadgetAttrsA(g_filelist,pp_window,NIL,[GTLV_LABELS,myb.pmodulelist,TAG_DONE,0])
    ELSE
        Gt_SetGadgetAttrsA(g_filelist,pp_window,NIL,[GTLV_LABELS,emptylist,TAG_DONE,0])
    ENDIF
    DrawBevelBoxA(pp_window.rport,9,13,401,20,[GT_VISUALINFO,visual,TAG_DONE,0])
    DrawBevelBoxA(pp_window.rport,9,35,401,167,[GT_VISUALINFO,visual,TAG_DONE,0])
    RefreshGList(g_source,pp_window,NIL,-1)
    Gt_RefreshWindow(pp_window,NIL)
    dWriteF(['p_RenderppWindow() Ok.\n'],0)
ENDPROC
PROC p_OpenppWindow() HANDLE /*"p_OpenppWindow()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Open window.
 ==============================================================================*/
    dWriteF(['p_OpenppWindow()\n'],0)
    IF (pp_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,347,
                       WA_TOP,0,
                       WA_WIDTH,419,
                       WA_HEIGHT,206,
                       WA_IDCMP,$400278+IDCMP_REFRESHWINDOW+IDCMP_MENUPICK,
                       WA_FLAGS,$102E+WFLG_HASZOOM,
                       WA_GADGETS,pp_glist,
                       WA_TITLE,'Peps v0.1 © 1994 NasGûl',
                       WA_ZOOM,[347,0,419,11]:INT,
                       WA_PUBSCREENNAME,pubscreenname,
                       WA_PUBSCREEN,screen,
                       WA_CUSTOMSCREEN,screen,
                       WA_BLOCKPEN,2,
                       WA_DETAILPEN,1,
                       WA_SCREENTITLE,'Made With GadToolsBox v2.0 © 1991-1993',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    IF nomenu=FALSE
        IF SetMenuStrip(pp_window,menu)=FALSE THEN Raise(ER_MENUS)
    ENDIF
    p_RenderppWindow()
    Raise(ER_NONE)
EXCEPT
    dWriteF(['p_OpenppWindow() Retour:\d\n'],[exception])
    RETURN exception
ENDPROC
PROC p_RemppWindow() /*"p_RemppWindow()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Free gadgetlist and close window.
 ==============================================================================*/
    IF nomenu=FALSE
        IF pp_window THEN ClearMenuStrip(pp_window)
    ENDIF
    IF pp_window THEN CloseWindow(pp_window)
    IF pp_glist THEN FreeGadgets(pp_glist)
    IF nomenu=FALSE
        IF menu THEN FreeMenus(menu)
    ENDIF
ENDPROC
PROC p_StartCli() HANDLE /*"p_StartCli()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Parsing Cli Arguments.
 ==============================================================================*/
    DEF myargs:PTR TO LONG,rdargs=NIL,h,pos
    DEF edname[80]:STRING,edopt[80]:STRING
    DEF temp,clock
    myargs:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    temp:='ESource,'+
          'EC/K,'+
          'PS=PubScreenName/K,'+
          'TF=TempFile/K,'+
          'AP=ArexxPortName/K,'+
          'EN=ExecName/K,'+
          'ED=EditorName/K,'+
          'EP=EditorPortName/K,'+
          'ER=ErrorArexxScriptName/K,'+
          'MF=MenuFile/K,'+
          'DT=DelTemp/S,'+
          'JE=JustEC/S,'+
          'IC=InsComment/S,'+
          'Hires/S,'+
          'DF=PubScreenByDef/S,'+
          'SG=PubScreenShanghai/S'
    IF ReadArgs(temp,myargs,NIL)
    IF myargs[0] /* ESOURCE */
        StrCopy(esource,myargs[0],ALL)
        IF FileLength(esource)=-1 THEN Raise(ER_NOFILE)
        IF (pos:=InStr(esource,':',0))<>-1 THEN Raise(ER_SAMEDIR)
        IF (pos:=InStr(esource,'/',0))<>-1 THEN Raise(ER_SAMEDIR)
    ELSE
        Raise(ER_NOFILE)
    ENDIF
    IF myargs[1] /* ECOPT */
        StrCopy(ec,myargs[1],ALL)
    ELSE
        StrCopy(ec,'-e',ALL)
    ENDIF
    IF myargs[2] /* PUBSCREENNAME */
        StrCopy(pubscreenname,myargs[2],ALL)
    ELSE
        StrCopy(pubscreenname,'Workbench',ALL)
    ENDIF
    IF myargs[3] /* TEMPFILE */
        StrCopy(tempfile,myargs[3],ALL)
        pos:=InStr(tempfile,'.e',0)
        IF pos=-1 THEN StrAdd(tempfile,'.e',ALL)
        IF h:=Open(tempfile,1006)
        Close(h)
        ELSE
        Raise(ER_TEMPNOVALID)
        ENDIF
    ELSE
        StrCopy(tempfile,'T:PepsMain.e',ALL)
    ENDIF
    pos:=InStr(tempfile,'.e',ALL)
    MidStr(ecsource,tempfile,0,pos)
    IF myargs[4] /* AREXXPORTNAME */
        StrCopy(prgportname,myargs[4],ALL)
    ELSE
        StrCopy(prgportname,'PepsPort',ALL)
    ENDIF
    IF myargs[5] /* EXECNAME */
        StrCopy(execname,myargs[5],ALL)
    ELSE
        pos:=InStr(esource,'.e',0)
        MidStr(execname,esource,0,pos)
    ENDIF
    IF h:=Open(execname,1006)
        Close(h)
        DeleteFile(execname)
    ELSE
        Raise(ER_EXENOVALID)
    ENDIF
    IF myargs[6] /* EDITORNAME */
        pos:=InStr(myargs[6],'[]',0)
        IF pos<>-1
        MidStr(edname,myargs[6],0,pos)
        MidStr(edopt,myargs[6],pos+3,ALL)
        StringF(editorcommand,'\s \s \s',edname,esource,edopt)
        ELSE
        StringF(editorcommand,'\s \s',myargs[6],esource)
        ENDIF
    ELSE
        StringF(editorcommand,'ED \s',esource)
    ENDIF
    IF myargs[7] /* EDITORPORTNAME */
        StrCopy(edarexxportname,myargs[7],ALL)
    ELSE
        StrCopy(edarexxportname,'',ALL)
    ENDIF
    IF myargs[8] /* ERRORAREXXSCRIPTNAME */
        StrCopy(erscriptname,myargs[8],ALL)
        arexxer:=TRUE
    ELSE
        StrCopy(erscriptname,'PepsError',ALL)
        arexxer:=TRUE
    ENDIF
    IF myargs[9] /* MENUFILE */
        IF FileLength(myargs[9])<>-1
            StrCopy(menufile,myargs[9],ALL)
        ELSE
            StrCopy(menufile,'peps.Menus',ALL)
        ENDIF
    ELSE
        nomenu:=TRUE
    ENDIF
    /* BOLL ARGS */
    IF myargs[10] THEN b_deletetemp:=TRUE
    IF myargs[11] THEN compilandexit:=TRUE
    IF myargs[12] THEN insertcomment:=TRUE
    IF myargs[13] THEN typescreen:=HIRES_KEY
    IF myargs[14] THEN screenbydefault:=TRUE
    IF myargs[15] THEN screenshanghai:=TRUE
    ELSE
    Raise(ER_BADARGS)
    ENDIF
    /*
    WriteF('Source   :\s\n',esource)
    WriteF('EC opt   :\s\n',ec)
    WriteF('PubScr   :\s\n',pubscreenname)
    WriteF('TempFile :\s\n',tempfile)
    IF b_deletetemp THEN WriteF('DelTemp.\n') ELSE WriteF('No DelTemp.\n')
    WriteF('PortName :\s\n',prgportname)
    WriteF('ExecName :\s\n',execname)
    */
    IF clock:=Lock('',-2)
    NameFromLock(clock,currentdir,256)
    AddPart(currentdir,'',256)
    UnLock(clock)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF rdargs THEN FreeArgs(rdargs)
    RETURN exception
ENDPROC
PROC p_OpenConsole() HANDLE /*"p_OpenConsole()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Open the Output console.
 ==============================================================================*/
    StringF(myconout,'Con:0/0/640/80/PepsOut/Auto/Wiat/Close/Screen \s',pubscreenname)
    IF (myout:=Open(myconout,1006))=NIL THEN Raise(ER_CONOUT)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_CloseConsole() /*"p_CloseConsole()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Close the output console.
 ==============================================================================*/
    IF myout THEN Close(myout)
ENDPROC
PROC p_CreateArexxPort(nom,pri) HANDLE /*"p_CreateArexxPort(nom,pri)"*/
/*===============================================================================
 = Para         : name (STRING),pri (NUM).
 = Return       : the address of the port if ok,else NIL.
 = Description  : Create a public port.
 ==============================================================================*/
    DEF dat_port:PTR TO ln
    IF FindPort(nom)<>0 THEN Raise(ER_PORTEXIST)
    arexxport:=CreateMsgPort()
    IF arexxport=0
    Raise(ER_CREATEPORT)
    ENDIF
    dat_port:=arexxport.ln
    dat_port.name:=nom
    dat_port.pri:=pri
    dat_port.type:=NT_MSGPORT
    arexxport.flags:=PA_SIGNAL
    IF nom<>NIL
    AddPort(arexxport)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_DeleteArexxPort(adr_port:PTR TO mp) /*"p_DeleteArexxPort(adr_port:PTR TO mp)"*/
/*===============================================================================
 = Para         : Address of port.
 = Return       : NONE
 = Description  : Remove a public port.
 ==============================================================================*/
    DEF data_port:PTR TO ln
    data_port:=adr_port.ln
    IF data_port.name<>NIL THEN RemPort(adr_port)
    IF adr_port THEN DeleteMsgPort(adr_port)
ENDPROC
PROC p_InitPeps() HANDLE /*"p_InitPeps()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Init the eubase structure.
 ==============================================================================*/
    IF (myb:=New(SIZEOF eubase))=NIL THEN Raise(ER_MEM)
    myb.pmodulelist:=p_InitList()
    myb.proclist:=p_InitList()
    myb.infolist:=p_InitList()
    emptylist:=p_InitList()
    IF ((myb.pmodulelist=0) OR
        (myb.proclist=0) OR (myb.infolist=0) OR (emptylist=0)) THEN Raise(ER_MEM)
    p_AjouteNode(emptylist,' ',0)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RemPeps() /*"p_RemPeps()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Remove the eubase structure.
 ==============================================================================*/
    IF myb.pmodulelist THEN p_CleanPmoduleList(myb.pmodulelist)
    IF myb.proclist THEN p_RemoveList(myb.proclist)
    IF myb.infolist THEN p_RemoveList(myb.infolist)
    IF emptylist THEN p_RemoveList(emptylist)
ENDPROC
PROC p_RemoveList(ptr_list:PTR TO lh) /*"p_RemoveList(ptr_list:PTR TO lh)"*/
/*===============================================================================
 = Para         : Address of list.
 = Return       : NONE.
 = Description  : p_CleanList() and dispose the list.
 ==============================================================================*/
    DEF r_list:PTR TO lh
    r_list:=p_CleanList(ptr_list)
    IF r_list THEN Dispose(r_list)
ENDPROC
PROC p_InitList() HANDLE /*"p_InitList()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : address of the new list if ok,else NIL.
 = Description  : Initialise a list.
 ==============================================================================*/
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
PROC p_GetNumNode(ptr_list:PTR TO lh,adr_node) /*"p_GetNumNode(ptr_list:PTR TO lh,adr_node)"*/
/*===============================================================================
 = Para         : address of list,address of node
 = Return       : the number of the node if ok else -1.
 = Description  : Find the number of a node.
 ==============================================================================*/
    DEF g_node:PTR TO ln
    DEF count=0
    g_node:=ptr_list.head
    WHILE g_node
        IF g_node=adr_node THEN RETURN count
        INC count
        g_node:=g_node.succ
    ENDWHILE
    RETURN NIL
ENDPROC
PROC p_GetAdrNode(ptr_list:PTR TO lh,num_node) /*"p_GetAdrNode(ptr_list:PTR TO lh,num_node)"*/
/*==============================================================================
 = Para         : address of list,number's node.
 = Return       : address of node or NIL.
 = Description  : Find the address of a node.
 ==============================================================================*/
    DEF g_node:PTR TO ln
    DEF count=0
    g_node:=ptr_list.head
    WHILE g_node
        IF count=num_node THEN RETURN g_node
        INC count
        g_node:=g_node.succ
    ENDWHILE
    RETURN NIL
ENDPROC
PROC p_EmptyList(ptr_list:PTR TO lh) /*"p_EmptyList(ptr_list:PTR TO lh)"*/
/*===============================================================================
 = Para         : address of list.
 = Return       : TRUE if list is empty,else address of list.
 = Description  : Look if a list is empty.
 ==============================================================================*/
    DEF count=0
    DEF e_node:PTR TO ln
    e_node:=ptr_list.head
    WHILE e_node
        IF e_node.succ<>0 THEN INC count
        e_node:=e_node.succ
    ENDWHILE
    IF count=0 THEN RETURN TRUE ELSE RETURN ptr_list
ENDPROC
PROC p_CleanList(ptr_list:PTR TO lh) /*"p_CleanList(ptr_list:PTR TO lh)"*/
/*===============================================================================
 = Para         : address of list
 = Return       : address of clean list
 = Description  : Remove all nodes in the list.
 ==============================================================================*/
    DEF c_node:PTR TO ln
    c_node:=ptr_list.head
    WHILE c_node
        IF c_node.succ<>0
            IF c_node.name THEN DisposeLink(c_node.name)
        ENDIF
        IF c_node.succ=0 THEN RemTail(ptr_list)
        IF c_node.pred=0 THEN RemHead(ptr_list)
        IF (c_node.succ<>0) AND (c_node.pred<>0) THEN Remove(c_node)
        c_node:=c_node.succ
    ENDWHILE
    ptr_list.tail:=0
    ptr_list.head:=ptr_list.tail
    ptr_list.tailpred:=ptr_list.head
    ptr_list.type:=0
    ptr_list.pad:=0
    RETURN ptr_list
ENDPROC
PROC p_AjouteNode(ptr_list:PTR TO lh,node_name,adr) HANDLE /*"p_AjouteNode(ptr_list:PTR TO lh,node_name,adr)"*/
/*===============================================================================
 = Para         : address of list,the name of a node,adr to copy node if adr<>0.
 = Return       : the number of the new selected node in the list.
 = Description  : Add a node and return the new current node (for LISTVIEW_KIND).
 ===============================================================================*/
    DEF a_node:PTR TO ln
    DEF nn=NIL
    a_node:=New(SIZEOF ln)
    a_node.succ:=0
    a_node.name:=String(EstrLen(node_name))
    StrCopy(a_node.name,node_name,ALL)
    IF adr<>0  /* Copy the node in the structure) */
        CopyMem(a_node,adr,SIZEOF ln)
        AddTail(ptr_list,adr)
        nn:=p_GetNumNode(ptr_list,adr)
    ELSE
        AddTail(ptr_list,a_node)
        nn:=p_GetNumNode(ptr_list,a_node)
    ENDIF
    IF nn=0
        IF adr=0 THEN ptr_list.head:=a_node ELSE ptr_list.head:=adr
        a_node.pred:=0
    ENDIF
    IF adr<>0 THEN Dispose(a_node) /* node is copied,free it */
    Raise(nn)
EXCEPT
    RETURN exception
ENDPROC
PROC p_AjouteInfoNode(ptr_list:PTR TO lh,node_name) HANDLE /*"p_AjouteInfoNode(ptr_list:PTR TO lh,node_name)"*/
/*===============================================================================
 = Para         : address of list,the name of a node.
 = Return       : the number of the new selected node in the list.
 = Description  : Add a node and return the new current node (for LISTVIEW_KIND).
 =                and refresh the window.
 ==============================================================================*/
    DEF a_node:PTR TO ln
    DEF nn=NIL
    Gt_SetGadgetAttrsA(g_errorslist,pp_window,NIL,[GTLV_LABELS,-1,TAG_DONE,0])
    a_node:=New(SIZEOF ln)
    a_node.succ:=0
    a_node.name:=String(EstrLen(node_name))
    StrCopy(a_node.name,node_name,ALL)
    AddTail(ptr_list,a_node)
    nn:=p_GetNumNode(ptr_list,a_node)
    IF nn=0
        ptr_list.head:=a_node
        a_node.pred:=0
    ENDIF
    Gt_SetGadgetAttrsA(g_errorslist,pp_window,NIL,[GTLV_TOP,nn,GTLV_LABELS,p_EmptyList(myb.infolist),TAG_DONE,0])
    Raise(nn)
EXCEPT
    RETURN exception
ENDPROC
PROC p_CleanPmoduleList(ptr_list:PTR TO lh) /*"p_CleanPmoduleList(ptr_list:PTR TO lh)"*/
/*===============================================================================
 = Para         : address of list
 = Return       : NONE
 = Description  : Clean the eubase.pmoduleslist (all filenode and procnode are deleted).
 ===============================================================================*/
    DEF w_fnode:PTR TO ln
    DEF w_pnode:PTR TO ln
    DEF w_filenode:PTR TO filenode
    DEF w_procnode:PTR TO procnode
    DEF pivlist:PTR TO lh
    w_filenode:=ptr_list.head
    WHILE w_filenode
        w_fnode:=w_filenode
        IF w_fnode.succ<>0
            IF w_fnode.name THEN DisposeLink(w_fnode.name)
            IF p_EmptyList(w_filenode.deflist)<>-1 THEN p_CleanList(w_filenode.deflist)
            IF p_EmptyList(w_filenode.proclist)<>-1
                pivlist:=w_filenode.proclist
                w_procnode:=pivlist.head
                WHILE w_procnode
                    w_pnode:=w_procnode
                    IF w_pnode.succ<>0
                        IF w_pnode.name THEN DisposeLink(w_pnode.name)
                        IF w_procnode.buffer THEN Dispose(w_procnode.buffer)
                        IF w_procnode THEN Dispose(w_procnode)
                        IF w_pnode.succ=0 THEN RemTail(w_filenode.proclist)
                        IF w_pnode.pred=0 THEN RemHead(w_filenode.proclist)
                        IF (w_pnode.succ<>0) AND (w_pnode.pred<>0) THEN Remove(w_pnode)
                    ENDIF
                    w_procnode:=w_pnode.succ
                ENDWHILE
            ENDIF
            IF w_filenode THEN Dispose(w_filenode)
            IF w_fnode.succ=0 THEN RemTail(ptr_list)
            IF w_fnode.pred=0 THEN RemHead(ptr_list)
            IF (w_pnode.succ<>0) AND (w_pnode.pred<>0) THEN Remove(w_pnode)
        ENDIF
        w_filenode:=w_fnode.succ
    ENDWHILE
    ptr_list.tail:=0
    ptr_list.head:=ptr_list.tail
    ptr_list.tailpred:=ptr_list.head
    ptr_list.type:=0
    ptr_list.pad:=0
ENDPROC
PROC p_CleanAllList() /*"p_CleanAllList()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : NONE.
 = Description  : Lock listview and clen all list.
 ==============================================================================*/
    Gt_SetGadgetAttrsA(g_proclist,pp_window,NIL,[GTLV_LABELS,-1,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_filelist,pp_window,NIL,[GTLV_LABELS,-1,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_errorslist,pp_window,NIL,[GTLV_LABELS,-1,TAG_DONE,0])
    p_CleanList(myb.proclist)
    p_CleanList(myb.infolist)
    p_CleanPmoduleList(myb.pmodulelist)
    Gt_SetGadgetAttrsA(g_proclist,pp_window,NIL,[GTLV_LABELS,emptylist,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_filelist,pp_window,NIL,[GTLV_LABELS,emptylist,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_errorslist,pp_window,NIL,[GTLV_LABELS,emptylist,TAG_DONE,0])
ENDPROC

