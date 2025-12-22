/*******************************************************************************************/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl					   */
/*******************************************************************************************/
/********************************************************************************
 * << EUTILS HEADER >>
 ********************************************************************************
 ED
 EC
 PREPRO
 SOURCE
 EPPDEST
 EXEC
 ISOURCE
 HSOURCE
 ERROREC
 ERROREPP
 VERSION
 REVISION
 NAMEPRG
 NAMEAUTHOR
 ********************************************************************************
 * HISTORY :
 *******************************************************************************/

OPT OSVERSION=37

MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes','exec/ports','eropenlib','utility/tagitem'
MODULE 'clickgui'
MODULE 'asl','libraries/asl'
MODULE 'reqtools','libraries/reqtools'
MODULE 'dos/dostags','wbmessage','dos/dosextens'
MODULE 'wb','workbench/workbench'
MODULE 'dos/notify'
CONST F_LOAD=0,
      F_SAVE=1,
      ACTION_LIST=0,
      ACTION_CONF=1,
      GET_STACK=0,
      GET_PRI=1,
      MODE_WB=0,
      MODE_CLI=1

ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_MEM,ER_PORT,ER_NOFILE,ER_FORMAT,OK_FICHIER,ER_APPWIN

DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offy
/****************************************
 * cr Definitions
 ****************************************/
DEF cr_window=NIL:PTR TO window
DEF cr_glist=NIL
DEF cr_menu=NIL
DEF cr_appwindow
/***********
 * Gadgets
 ***********/
ENUM GA_GLIST,GA_GADD,GA_GREM,GA_GQUIT,GA_GWB,GA_GCLI,GA_GINFO
/************************
 * Gadgets labels of cr
 ************************/
DEF glist,gadd,grem,gquit,gwb,gcli,ginfo
/******************
 * liste
 ******************/
DEF commandelist:PTR TO lh
DEF emptylist:PTR TO lh
/******************
 * Application
 ******************/
DEF currentnode
DEF wb_handle
DEF prgport:PTR TO mp
DEF defdir[256]:STRING
DEF zoomed=FALSE
DEF nreq:PTR TO notifyrequest
DEF nreqsig=-1
/***************************************/
/* Gestion de la liste		       */
/***************************************/
PROC p_InitList() HANDLE /*"p_InitList()"*/
/********************************************************************************
 * Para 	: NONE
 * Return	: address of the new list if ok,else NIL.
 * Description	: Initialise a list.
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
PROC p_EmptyList(adr_list) /*"p_EmptyList(adr_list)"*/
/********************************************************************************
 * Para 	: address of list.
 * Return	: TRUE if list is empty,else address of list.
 * Description	: Look if a list is empty.
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
PROC p_AjouteNode(ptr_list,node_name) HANDLE /*"p_AjouteNode(ptr_list,node_name)"*/
/********************************************************************************
 * Para 	: address of list,the name of a node.
 * Return	: the number of the new selected node in the list.
 * Description	: Add a node and return the new current node (for LISTVIEW_KIND).
 *******************************************************************************/
    DEF a_list:PTR TO lh
    DEF a_node:PTR TO ln
    DEF nn=NIL
    a_list:=ptr_list
    a_node:=New(SIZEOF ln)
    a_node.succ:=0
    a_node.name:=String(EstrLen(node_name))
    StrCopy(a_node.name,node_name,ALL)
    AddTail(a_list,a_node)
    nn:=p_GetNumNode(a_list,a_node)
    IF nn=0
	a_list.head:=a_node
	a_node.pred:=0
   /**********************************************
	a_node.succ:=0
	a_list.tailpred:=a_node
    ELSE
	a_node.succ:=0
	a_node.pred:=p_GetAdrNode(a_list,nn-1)
	a_list.tailpred:=a_node
    **********************************************/
    ENDIF
    Raise(nn)
EXCEPT
    RETURN exception
ENDPROC
PROC p_GetAdrNode(ptr_list,num_node) /*"p_GetAdrNode(ptr_list,num_node)"*/
/********************************************************************************
 * Para 	: address of list,number's node.
 * Return	: address of node or NIL.
 * Description	: Find the address of a node.
 *******************************************************************************/
    DEF g_list:PTR TO lh
    DEF g_node:PTR TO ln
    DEF count=0
    g_list:=ptr_list
    g_node:=g_list.head
    WHILE g_node
	IF count=num_node THEN RETURN g_node
	INC count
	g_node:=g_node.succ
    ENDWHILE
    RETURN NIL
ENDPROC
PROC p_GetNumNode(ptr_list,adr_node) /*"p_GetNumNode(ptr_list,adr_node)"*/
/********************************************************************************
 * Para 	: address of list,address of node
 * Return	: the number of the node.
 * Description	: Find the number of a node.
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
PROC p_RemoveEmptyList(list:PTR TO lh) /*"p_RemoveEmptyList(list:PTR TO lh)"*/
    DEF node:PTR TO ln
    node:=list.head
    WHILE node
	IF node.succ<>0
	    IF node.name THEN Dispose(node.name)
	ENDIF
	IF node.succ=0 THEN RemTail(list)
	IF node.pred=0 THEN RemHead(list)
	IF (node.succ<>0) AND (node.pred<>0) THEN Remove(node)
	node:=node.succ
    ENDWHILE
ENDPROC
PROC p_CleanCRList(list:PTR TO lh) /*"p_CleanCRList(list:PTR TO lh)"*/
    DEF cnode:PTR TO clicknode
    DEF node:PTR TO ln
    cnode:=list.head
    WHILE cnode
	node:=cnode
	IF node.succ<>0
	    IF node.name THEN Dispose(node.name)
	    IF cnode.currentdir THEN Dispose(cnode.currentdir)
	    IF cnode THEN Dispose(cnode)
	ENDIF
	IF node.succ=0 THEN RemTail(list)
	IF node.pred=0 THEN RemHead(list)
	IF (node.succ<>0) AND (node.pred<>0) THEN Remove(node)
	cnode:=node.succ
    ENDWHILE
ENDPROC
PROC p_AjouteCRNode(list:PTR TO lh,nom,thedir) /*"p_AjouteCRNode(list,nom,thedir)"*/
    DEF mycrnode:PTR TO clicknode
    DEF node:PTR TO ln
    DEF nn
    node:=New(SIZEOF ln)
    mycrnode:=New(SIZEOF clicknode)
    node.succ:=0
    node.name:=String(EstrLen(nom))
    StrCopy(node.name,nom,ALL)
    CopyMem(node,mycrnode.node,SIZEOF ln)
    AddTail(commandelist,mycrnode.node)
    nn:=p_GetNumNode(commandelist,mycrnode.node)
    IF nn=0
	list.head:=mycrnode.node
	node.pred:=0
    ENDIF
    mycrnode.currentdir:=String(EstrLen(thedir))
    StrCopy(mycrnode.currentdir,thedir,ALL)
    mycrnode.stack:=p_GetReqVal(GET_STACK,nom)
    mycrnode.pri:=p_GetReqVal(GET_PRI,nom)
    IF node THEN Dispose(node)
    RETURN nn
ENDPROC
PROC p_RemoveCRNode(list:PTR TO lh,numnode) /*"p_RemoveCRNode(list:PTR TO lh,numnode)"*/
    DEF rcr:PTR TO clicknode
    DEF rnode:PTR TO ln
    DEF count=0,retour=NIL
    DEF newn:PTR TO ln
    rcr:=list.head
    WHILE rcr
	rnode:=rcr
	IF count=numnode
	    IF rnode.succ<>0
		IF rnode.name THEN Dispose(rnode.name)
		IF rcr.currentdir THEN Dispose(rcr.currentdir)
		IF rcr THEN Dispose(rcr)
	    ENDIF
	    IF rnode.succ=0
		RemTail(list)
		retour:=numnode-1
	    ELSEIF rnode.pred=0
		RemHead(list)
		retour:=numnode
		newn:=p_GetAdrNode(list,numnode)
		list.head:=newn
		newn.pred:=0
	    ELSEIF (rnode.succ<>0) AND (rnode.pred<>0)
		Remove(rnode)
		retour:=numnode-1
	    ENDIF
	ENDIF
	INC count
	rcr:=rnode.succ
    ENDWHILE
    RETURN retour
ENDPROC
/****************************************/
/* Libraries and window proc		*/
/****************************************/
PROC p_OpenLibraries() HANDLE /*"p_OpenLibraries()"*/
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (aslbase:=OpenLibrary('asl.library',37))=NIL THEN Raise(ER_ASLLIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL THEN Raise(ER_REQTOOLSLIB)
    IF (workbenchbase:=OpenLibrary('workbench.library',37))=NIL THEN Raise(ER_WORKBENCHLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_CloseLibraries()  /*"p_CloseLibraries()"*/
    IF workbenchbase THEN CloseLibrary(workbenchbase)
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF aslbase THEN CloseLibrary(aslbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
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
ENDPROC
PROC p_InitcrWindow() HANDLE /*"p_InitcrWindow()"*/
    IF (cr_glist:=CreateContext({cr_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (cr_menu:=CreateMenusA([1,0,'Project',0,0,0,0,
			       2,0,'Load','L',0,0,0,
			       2,0,'Save','S',0,0,0,
			       2,0,'Quit','Q',0,0,0,
			       1,0,' Options ',0,0,0,0,
			       2,0,'Stack   ','A',0,0,0,
			       2,0,'Priority','P',0,0,0,
				   0,0,0,0,0,0,0]:newmenu,NIL))=NIL THEN Raise(ER_MENUS)
    IF LayoutMenusA(cr_menu,visual,NIL)=FALSE THEN Raise(ER_MENUS)
    IF (glist:=CreateGadgetA(LISTVIEW_KIND,cr_glist,[4,12,153,41,'',tattr,0,0,visual,0]:newgadget,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,-1,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (gadd:=CreateGadgetA(BUTTON_KIND,glist,[159,12,62,12,'_Add',tattr,1,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (grem:=CreateGadgetA(BUTTON_KIND,gadd,[223,12,62,12,'_Rem',tattr,2,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (gquit:=CreateGadgetA(BUTTON_KIND,grem,[159,36,126,12,'_Quit',tattr,3,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (gwb:=CreateGadgetA(BUTTON_KIND,gquit,[161,24,62,12,'_WBRun',tattr,4,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (gcli:=CreateGadgetA(BUTTON_KIND,gwb,[223,24,62,12,'_CliRun',tattr,5,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (ginfo:=CreateGadgetA(TEXT_KIND,gcli,[7,48,278,12,'',tattr,6,0,visual,0]:newgadget,[GTTX_BORDER,TRUE,GTTX_TEXT,'',GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RendercrWindow() /*"p_RendercrWindow()"*/
    DEF inf[256]:STRING
    DEF infonode:PTR TO clicknode
    DEF cn:PTR TO ln
    Gt_SetGadgetAttrsA(glist,cr_window,NIL,[GTLV_LABELS,-1,TAG_DONE,0])
    infonode:=p_GetAdrNode(commandelist,currentnode)
    cn:=infonode
    StringF(inf,'Stack :\d Prioriy :\d',infonode.stack,infonode.pri)
    IF p_EmptyList(commandelist)=-1
	Gt_SetGadgetAttrsA(glist,cr_window,NIL,[GA_DISABLED,TRUE,GTLV_SHOWSELECTED,NIL,GTLV_LABELS,emptylist,TAG_DONE,0])
	Gt_SetGadgetAttrsA(grem,cr_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
	Gt_SetGadgetAttrsA(gwb,cr_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
	Gt_SetGadgetAttrsA(gcli,cr_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
	Gt_SetGadgetAttrsA(ginfo,cr_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,'Empty list.',TAG_DONE,0])
	IF zoomed=FALSE
	    SetWindowTitles(cr_window,'ClickRun v0.1','Made With GadToolsBox v2.0 © 1991-1993')
	ELSE
	    SetWindowTitles(cr_window,'No Command','Made With GadToolsBox v2.0 © 1991-1993')
	ENDIF
    ELSE
	Gt_SetGadgetAttrsA(glist,cr_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,currentnode,GTLV_LABELS,commandelist,TAG_DONE,0])
	Gt_SetGadgetAttrsA(grem,cr_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
	Gt_SetGadgetAttrsA(gwb,cr_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
	Gt_SetGadgetAttrsA(gcli,cr_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
	Gt_SetGadgetAttrsA(ginfo,cr_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,inf,TAG_DONE,0])
	IF zoomed=FALSE
	    SetWindowTitles(cr_window,'ClickRun v0.1','Made With GadToolsBox v2.0 © 1991-1993')
	ELSE
	    SetWindowTitles(cr_window,cn.name,'Made With GadToolsBox v2.0 © 1991-1993')
	ENDIF
    ENDIF
    RefreshGList(glist,cr_window,NIL,-1)
    Gt_RefreshWindow(cr_window,NIL)
ENDPROC
PROC p_OpencrWindow() HANDLE /*"p_OpencrWindow()"*/
    IF (cr_window:=OpenWindowTagList(NIL,
		      [WA_LEFT,10,
		       WA_TOP,10,
		       WA_WIDTH,290,
		       WA_HEIGHT,62,
		       WA_IDCMP,$378+IDCMP_REFRESHWINDOW,
		       WA_FLAGS,$102E+WFLG_HASZOOM,
		       WA_GADGETS,cr_glist,
		       WA_ZOOM,[10,10,290,11]:INT,
		       WA_TITLE,'ClickRun v0.1',
		       WA_SCREENTITLE,'Made With GadToolsBox v2.0 © 1991-1993',
		       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    IF SetMenuStrip(cr_window,cr_menu)=FALSE THEN Raise(ER_MENUS)
    Gt_RefreshWindow(cr_window,NIL)
    p_RendercrWindow()
    IF (cr_appwindow:=AddAppWindowA(0,0,cr_window,prgport,NIL))=NIL THEN Raise(ER_APPWIN)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RemcrWindow() /*"p_RemcrWindow()"*/
    IF cr_appwindow THEN RemoveAppWindow(cr_appwindow)
    IF cr_window THEN CloseWindow(cr_window)
    IF cr_menu THEN FreeMenus(cr_menu)
    IF cr_glist THEN FreeGadgets(cr_glist)
ENDPROC
/******************************************/
/* Message proc 			  */
/******************************************/
PROC p_LookAllMessage() /*"p_LookAllMessage()"*/
    DEF sigreturn
    DEF crport:PTR TO mp
    IF cr_window THEN crport:=cr_window.userport ELSE crport:=NIL
    sigreturn:=Wait(Shl(1,prgport.sigbit) OR Shl(1,crport.sigbit) OR
		    Shl(1,nreq.signalnum) OR $F000)
    IF (sigreturn AND Shl(1,prgport.sigbit))
	p_LookAppMessage()
    ENDIF
    IF (sigreturn AND Shl(1,nreq.signalnum))
	p_ReadConfig('Env:Clk.prefs')
	p_RendercrWindow()
    ENDIF
    IF (sigreturn AND Shl(1,crport.sigbit))
	p_LookcrMessage()
    ENDIF
    IF (sigreturn AND $F000)
	reelquit:=TRUE
    ENDIF
ENDPROC
PROC p_LookcrMessage() /*"p_LookcrMessage()"*/
    DEF mes:PTR TO intuimessage
    DEF g:PTR TO gadget
    DEF type=0,infos=NIL
    DEF cn,pivz
    IF mes:=Gt_GetIMsg(cr_window.userport)
	type:=mes.class
	SELECT type
	    CASE IDCMP_MENUPICK
		infos:=mes.code
		SELECT infos
		    CASE $F800
			p_FileRequester(F_LOAD,'Load Config',ACTION_CONF)
			p_RendercrWindow()
		    CASE $F820
			IF p_EmptyList(commandelist)<>-1 THEN p_FileRequester(F_SAVE,'Save Config',ACTION_CONF)
		    CASE $F840;    reelquit:=TRUE
		    CASE $F801
			IF p_ChangeCurrentData(currentnode,GET_STACK) THEN p_RendercrWindow()
		    CASE $F821
			IF p_ChangeCurrentData(currentnode,GET_PRI) THEN p_RendercrWindow()
		ENDSELECT
	    CASE IDCMP_CLOSEWINDOW;  reelquit:=TRUE
	    CASE IDCMP_REFRESHWINDOW
		IF zoomed=FALSE THEN pivz:=TRUE ELSE pivz:=FALSE
		zoomed:=pivz
		p_RendercrWindow()
	    CASE IDCMP_GADGETDOWN
		type:=IDCMP_GADGETUP
	    CASE IDCMP_GADGETUP
		g:=mes.iaddress
		infos:=g.gadgetid
		SELECT infos
		    CASE GA_GLIST
			IF p_EmptyList(commandelist)<>-1
			    currentnode:=mes.code
			    p_RendercrWindow()
			ENDIF
		    CASE GA_GADD
			IF cn:=p_FileRequester(F_LOAD,'Charger Nouvelle Commande',ACTION_LIST)
			    currentnode:=cn
			ENDIF
			p_RendercrWindow()
		    CASE GA_GREM
			cn:=p_RemoveCRNode(commandelist,currentnode)
			/*IF cn<>NIL THEN currentnode:=cn*/
			currentnode:=cn
			p_RendercrWindow()
		    CASE GA_GQUIT;   reelquit:=TRUE
		    CASE GA_GWB
			p_StartProgram(commandelist,currentnode,MODE_WB,0,0)
		    CASE GA_GCLI
			p_StartProgram(commandelist,currentnode,MODE_CLI,0,0)
		    CASE GA_GINFO
		ENDSELECT
	 ENDSELECT
	 Gt_ReplyIMsg(mes)
     ENDIF
ENDPROC
PROC p_LookAppMessage() /*"p_LookAppMessage()"*/
    DEF appmsg:PTR TO appmessage
    IF appmsg:=GetMsg(prgport)
	/*p_WriteFWBMessage(appmsg.numargs,appmsg.arglist)*/
	p_StartProgram(commandelist,currentnode,MODE_WB,appmsg.numargs,appmsg.arglist)
	ReplyMsg(appmsg)
    ENDIF
ENDPROC
/*
PROC p_WriteFWBMessage(numa,lisa:PTR TO LONG) /*"p_WriteFWBMessage(numa,lisa:PTR TO LONG)"*/
   DEF b
   DEF fullname[256]:STRING
   WriteF('NumArgs:\d\n',numa)
   FOR b:=0 TO numa-1
      NameFromLock(lisa[b],fullname,256)
      WriteF('Name :\s Lock:\h FuulName:\s\n',lisa[b+1],lisa[b],fullname)
   ENDFOR
ENDPROC
*/
/******************************************/
/* Application				  */
/******************************************/
PROC p_StartProgram(list:PTR TO lh,numnode,mode,numa,lisa) /*"p_StartProgram(list:PTR TO lh,numnode,mode,numa,lisa)"*/
    DEF rcr:PTR TO clicknode
    DEF rnode:PTR TO ln
    DEF count=0
    rcr:=list.head
    WHILE rcr
	rnode:=rcr
	IF count=numnode
	    SELECT mode
		CASE MODE_WB;	 wb_WBRun(rnode.name,rcr.currentdir,rcr.stack,rcr.pri,numa,lisa)
		CASE MODE_CLI;	 wb_CLIRun(rnode.name,rcr.currentdir,rcr.stack,rcr.pri)
	    ENDSELECT
	ENDIF
	INC count
	rcr:=rnode.succ
    ENDWHILE
ENDPROC
PROC wb_WBRun(com,dir,st,pr,num_arg,arg_list:PTR TO LONG) HANDLE /*"wb_WBRun(com,di,st,pr,num_arg,arg_list)"*/
    DEF execmsg:PTR TO mn
    DEF wbsm:wbstartmsg
    DEF rc=FALSE
    DEF node:PTR TO ln
    wbsm:=New(SIZEOF wbstartmsg)
    execmsg:=wbsm
    node:=execmsg
    node.type:=NT_MESSAGE
    node.pri:=0
    execmsg.replyport:=prgport
    wbsm.name:=com
    wbsm.dirlock:=Lock(dir,-2)
    wbsm.stack:=st
    wbsm.prio:=pr
    wbsm.numargs:=num_arg
    wbsm.arglist:=arg_list
    IF wb_handle
	PutMsg(wb_handle,wbsm)
    ENDIF
    IF wb_handle
	WaitPort(prgport)
	GetMsg(prgport)
	rc:=wbsm.stack
    ENDIF
    IF rc=0 THEN p_Alert('WBRun Failed.')
    Raise(ER_NONE)
EXCEPT
    IF wbsm.dirlock THEN UnLock(wbsm.dirlock)
    IF wbsm THEN Dispose(wbsm)
    RETURN exception
ENDPROC
PROC wb_CLIRun(cmd,dir,sta,pp) HANDLE /*"wv_CLIRun(cmd,dir,sta,pp)"*/
    DEF ofh:PTR TO filehandle
    DEF ifh:PTR TO filehandle
    DEF newct=NIL:PTR TO mp
    DEF oldct:PTR TO mp
    DEF oldcd
    DEF newcd
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
    IF SystemTagList(cmd,[SYS_OUTPUT,NIL,
			 SYS_INPUT,NIL,
			 SYS_ASYNCH,TRUE,
			 SYS_USERSHELL,TRUE,
			 NP_STACKSIZE,sta,
			 NP_PRIORITY,pp,
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
PROC p_InitCRAPP() HANDLE /*"p_InitCRAPP()"*/
    emptylist:=p_InitList()
    commandelist:=p_InitList()
    IF (emptylist=NIL) OR (commandelist=NIL) THEN Raise(ER_MEM)
    p_AjouteNode(emptylist,' ')
    IF (prgport:=CreateMsgPort())=NIL THEN Raise(ER_PORT)
    Forbid()
    IF (wb_handle:=FindPort('WBStart-Handler Port'))=NIL
	wb_handle:=p_InitWBHandler()
    ENDIF
    Permit()
    p_InitLockConfigFile()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RemCRAPP() /*"p_RemCRAPP()"*/
    IF emptylist THEN p_RemoveEmptyList(emptylist)
    IF commandelist THEN p_CleanCRList(commandelist)
    IF commandelist THEN Dispose(commandelist)
    IF nreq THEN p_RemLockConfigFile()
    IF prgport THEN DeleteMsgPort(prgport)
ENDPROC
PROC p_InitLockConfigFile() /*"p_InitLockConfigFile()"*/
    nreq:=New(SIZEOF notifyrequest)
    nreq.name:='Env:Clk.prefs'
    nreq.flags:=NRF_SEND_SIGNAL
    nreq.port:=FindTask(0)
    nreq.signalnum:=AllocSignal(nreqsig)
    nreqsig:=nreq.signalnum
    StartNotify(nreq)
ENDPROC
PROC p_RemLockConfigFile() /*"p_RemLockConfigFile()"*/
    IF nreq.signalnum THEN FreeSignal(nreq.signalnum)
    EndNotify(nreq)
ENDPROC
PROC p_InitWBHandler() HANDLE /*"p_InitWBHandler()"*/
    DEF ifh
    DEF ofh
    DEF wbh
    IF (ifh:=Open('NIL:',1006))=NIL THEN Raise(NIL)
    IF (ofh:=Open('NIL:',1005))=NIL THEN Raise(NIL)
    SystemTagList('L:WBStart-Handler',[SYS_INPUT,ifh,
				      SYS_OUTPUT,ofh,
				      SYS_ASYNCH,TRUE,
				      SYS_USERSHELL,TRUE,
				      NP_CONSOLETASK,NIL,
				      NP_WINDOWPTR,NIL])
    Delay(25)
    wbh:=FindPort('WBStart-Handler Port')
    Raise(wbh)
EXCEPT
    IF Not(wbh)
	IF ifh THEN Close(ifh)
	IF ofh THEN Close(ofh)
    ENDIF
    RETURN wbh
ENDPROC
PROC p_FileRequester(func,titre,action) /*"p_FileRequester(func,titre,action)"*/
    DEF req:PTR TO filerequestr
    DEF ret=FALSE
    DEF tag
    DEF curdir[256]:STRING
    DEF name[80]:STRING
    DEF fullname[256]:STRING
    DEF doit
    IF func=F_LOAD
	tag:=[ASL_FUNCFLAGS,FILF_PATGAD,ASL_DIR,defdir,ASL_HAIL,titre,0]
    ELSE
	tag:=[ASL_DIR,defdir,ASL_FUNCFLAGS,FILF_SAVE,ASL_HAIL,titre,0]
    ENDIF
    IF req:=AllocAslRequest(ASL_FILEREQUEST,tag)
	IF doit:=RequestFile(req)
	    StringF(name,'\s',req.file)
	    StringF(curdir,'\s',req.dir)
	    StrCopy(defdir,req.dir,ALL)
	    AddPart(req.dir,'',256)
	    StringF(fullname,'\s\s',req.dir,req.file)
	ENDIF
	FreeAslRequest(req)
    ENDIF
    IF doit
	SELECT action
	    CASE ACTION_LIST
		ret:=p_AjouteCRNode(commandelist,name,curdir)
	    CASE ACTION_CONF
		SELECT func
		    CASE F_LOAD
		       p_ReadConfig(fullname)
		    CASE F_SAVE
			p_SaveConfig(commandelist,fullname)
		ENDSELECT
	ENDSELECT
    ENDIF
    RETURN ret
ENDPROC
PROC p_SaveConfig(list:PTR TO lh,fichier) /*"p_SaveConfig(list:PTR TO lh,fichier)"*/
    DEF h
    DEF scn:PTR TO clicknode
    DEF sn:PTR TO ln
    IF h:=Open(fichier,1006)
	Write(h,[ID_CLRU]:LONG,4)
	scn:=list.head
	WHILE scn
	    sn:=scn
	    IF sn.succ<>0
		Write(h,[ID_COMM]:LONG,4)
		Write(h,[scn.stack]:LONG,4)
		Write(h,[scn.pri]:LONG,4)
		Write(h,scn.currentdir,EstrLen(scn.currentdir))
		Out(h,0)
		Write(h,sn.name,EstrLen(sn.name))
		Out(h,0)
	    ENDIF
	    scn:=sn.succ
	ENDWHILE
	IF h THEN Close(h)
    ELSE
	p_Alert('Save Error.')
    ENDIF
ENDPROC
PROC p_ReadConfig(source) /*"p_ReadConfig(source)"*/
    DEF len,a,adr,buf,handle,flen=TRUE,pos
    DEF node:PTR TO ln
    DEF myclicknode:PTR TO clicknode
    DEF chunk,nn
    DEF pv[256]:STRING
    IF (flen:=FileLength(source))=-1 THEN RETURN ER_NOFILE
    IF (buf:=New(flen+1))=NIL THEN RETURN ER_NOFILE
    IF (handle:=Open(source,1005))=NIL THEN RETURN ER_NOFILE
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN RETURN ER_NOFILE
    adr:=buf
    chunk:=Long(adr)
    IF chunk<>ID_CLRU
	p_Alert('ce n\aest pas un fichier ClickRun.')
	Dispose(buf)
	RETURN ER_FORMAT
    ENDIF
    p_CleanCRList(commandelist)
    FOR a:=0 TO len-1
	pos:=adr++
	chunk:=Long(pos)
	SELECT chunk
	    CASE ID_COMM
		node:=New(SIZEOF ln)
		myclicknode:=New(SIZEOF clicknode)
		node.succ:=0
		myclicknode.stack:=Long(pos+4)
		myclicknode.pri:=Long(pos+8)
		StringF(pv,'\s',pos+12)
		myclicknode.currentdir:=String(EstrLen(pv))
		StrCopy(myclicknode.currentdir,pv,ALL)
		pos:=pos+12+EstrLen(pv)+1
		StringF(pv,'\s',pos)
		node.name:=String(EstrLen(pv))
		StrCopy(node.name,pv,ALL)
		CopyMem(node,myclicknode.node,SIZEOF ln)
		AddTail(commandelist,myclicknode.node)
		nn:=p_GetNumNode(commandelist,myclicknode.node)
		IF nn=0
		    commandelist.head:=myclicknode.node
		    node.pred:=0
		ENDIF
		IF node THEN Dispose(node)
	ENDSELECT
    ENDFOR
    Dispose(buf)
    RETURN OK_FICHIER
ENDPROC
PROC p_GetReqVal(typ,co) /*"p_GetReqVal(typ,co)"*/
    DEF reqt:PTR TO rtfilerequester
    DEF ret=NIL,num
    DEF titre[256]:STRING
    DEF taglist
    SELECT typ
	CASE GET_STACK
	    StringF(titre,'Stack pour :\s',co)
	    taglist:=[RTGL_TEXTFMT,titre,RTGL_MIN,4000,RTGL_MAX,150000,RT_LOCKWINDOW,TRUE,RT_WINDOW,cr_window,TAG_DONE,0]
	    num:=4000
	CASE GET_PRI
	    StringF(titre,'Priorité pour :\s',co)
	    taglist:=[RTGL_TEXTFMT,titre,RT_LOCKWINDOW,TRUE,RT_WINDOW,cr_window,RTGL_MIN,-10,RTGL_MAX,10,TAG_DONE]
	    num:=0
    ENDSELECT
    IF reqt:=RtAllocRequestA(RT_REQINFO,NIL)
	ret:=RtGetLongA({num},'ClickGUI',reqt,taglist)
	    SELECT typ
		CASE GET_STACK
		    IF (num<4000) OR (num>150000) THEN ret:=4000 ELSE ret:=num
		CASE GET_PRI
		    IF (num<-10) OR (num>10) THEN ret:=0 ELSE ret:=num
	    ENDSELECT
	IF reqt THEN RtFreeRequest(reqt)
    ENDIF
    RETURN ret
ENDPROC
PROC p_ChangeCurrentData(numnode,type) /*"p_ChangeCurrentData(numnode,type)"*/
    DEF chnode:PTR TO clicknode
    DEF node:PTR TO ln
    DEF reqt:PTR TO rtfilerequester
    DEF ret=FALSE,num
    DEF titre[256]:STRING
    DEF taglist
    IF p_EmptyList(commandelist)=-1 THEN RETURN FALSE
    chnode:=p_GetAdrNode(commandelist,numnode)
    node:=chnode
    SELECT type
	CASE GET_STACK
	    StringF(titre,'Nouvelle Stack pour :\s',node.name)
	    taglist:=[RTGL_TEXTFMT,titre,RTGL_MIN,4000,RTGL_MAX,150000,RT_LOCKWINDOW,TRUE,RT_WINDOW,cr_window,TAG_DONE,0]
	    num:=chnode.stack
	CASE GET_PRI
	    StringF(titre,'Nouvelle Priorité pour :\s',node.name)
	    taglist:=[RTGL_TEXTFMT,titre,RT_LOCKWINDOW,TRUE,RT_WINDOW,cr_window,RTGL_MIN,-10,RTGL_MAX,10,TAG_DONE]
	    num:=chnode.pri
    ENDSELECT
    IF reqt:=RtAllocRequestA(RT_REQINFO,NIL)
	ret:=RtGetLongA({num},'ClickGUI',reqt,taglist)
	    SELECT type
		CASE GET_STACK
		    chnode.stack:=num
		CASE GET_PRI
		    chnode.pri:=num
	    ENDSELECT
	IF reqt THEN RtFreeRequest(reqt)
    ENDIF
    RETURN ret
ENDPROC
PROC p_Alert(texte) /*"p_Alert(texte)"*/
	Gt_SetGadgetAttrsA(ginfo,cr_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,texte,TAG_DONE,0])
ENDPROC
PROC p_AlertEnd() /*"p_AlerEnd()"*/
/********************************************************************************
 * Para 	: NONE
 * Return	: TRUE or FALSE
 * Description	: PopUp the EndRequester.
 *******************************************************************************/
    DEF body[1000]:STRING
    StrCopy(body,'>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<\n'+
		 '>> ClickGui    v0.1    © 1994 NasGûl        <<\n'+
		 '>> GadToolsBox v37.273 © Jaba Development   <<\n'+
		 '>> Gui2E       v0.1    © 1994 NasGûl        <<\n'+
		 '>> AmigaE      v2.1b   © W. van Oortmersen  <<\n'+
		 '>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<\n'+
		 '             Voulez-vous quitter   ?          \n',ALL)
    RETURN EasyRequestArgs(0,[20,0,0,body,'Oui|Non'],0,NIL)
ENDPROC
/******************************************/
/* Main Proc				  */
/******************************************/
PROC main() HANDLE /*"main()"*/
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    StrCopy(defdir,'Sys:',ALL)
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitCRAPP())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitcrWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_OpencrWindow())<>ER_NONE THEN Raise(testmain)
    IF FileLength('Ram:Env/Clk.prefs')<>-1
	p_ReadConfig('Ram:Env/Clk.prefs')
	p_RendercrWindow()
    ENDIF
    REPEAT
	p_LookAllMessage()
	IF reelquit=TRUE
	    IF p_AlertEnd() THEN NOP ELSE reelquit:=FALSE
	ENDIF
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    p_RemcrWindow()
    p_SetDownScreen()
    p_RemCRAPP()
    p_CloseLibraries()
    SELECT exception
	CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.')
	CASE ER_VISUAL;     WriteF('Error Visual.')
	CASE ER_CONTEXT;    WriteF('Error Context.')
	CASE ER_MENUS;	    WriteF('Error Menus.')
	CASE ER_GADGET;     WriteF('Error Gadget.')
	CASE ER_WINDOW;     WriteF('Error Window.')
    ENDSELECT
ENDPROC
