/*******************************************************************************************/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */
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
MODULE 'whatis','wvprefs'
MODULE 'asl','libraries/asl'
ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_MEM
RAISE ER_MEM IF New()=NIL,
      ER_MEM IF String()=NIL

CONST LOAD_PREFS=0,
      SAVE_PREFS=1

DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offy
/****************************************
 * wp Definitions
 ****************************************/
DEF wp_window=NIL:PTR TO window
DEF wp_glist=NIL
/* Gadgets */
ENUM GA_G_COMMAND,GA_G_GETCOMMAND,GA_G_EXECTYPE,
     GA_G_STACK,GA_G_PRI,GA_G_LOAD,GA_G_SAVE,
     GA_G_SAVEAS,GA_G_ADD,GA_G_REM,GA_G_IDLIST,
     GA_G_ACTIONLIST
/* Gadgets labels of wp */
DEF g_command,g_getcommand,g_exectype,
    g_stack,g_pri,g_load,g_save,g_saveas,
    g_add,g_rem,g_idlist,g_actionlist
/* Application def       */
DEF mywvbase:PTR TO wvbase
DEF curidnode=0
DEF curactionnode=0
DEF defdir[256]:STRING
/***************************/
/* OpenClose Libraries     */
/***************************/
PROC p_OpenLibraries() HANDLE /*"p_OpenLibraries()"*/
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (whatisbase:=OpenLibrary('whatis.library',3))=NIL THEN Raise(ER_WHATISLIB)
    IF (aslbase:=OpenLibrary('asl.library',37))=NIL THEN Raise(ER_ASLLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_CloseLibraries()  /*"p_CloseLibraries()"*/
    IF aslbase THEN CloseLibrary(aslbase)
    IF whatisbase THEN CloseLibrary(whatisbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
/***************************/
/* Gestion de la liste     */
/***************************/
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
PROC p_RemoveList(ptr_list) /*"p_RemoveList(ptr_list)"*/
/********************************************************************************
 * Para         : address of list
 * Return       : NONE
 * Description  : p_CleanList() and dispose the list.
 *******************************************************************************/
    DEF r_list:PTR TO lh
    r_list:=p_CleanList(ptr_list)
    IF r_list THEN Dispose(r_list)
ENDPROC
PROC p_CleanList(ptr_list) /*"p_CleanList(ptr_list)"*/
/********************************************************************************
 * Para         : address of list
 * Return       : address of clean list
 * Description  : Remove all nodes in the list.
 *******************************************************************************/
    DEF c_node:PTR TO ln
    DEF c_list:PTR TO lh
    c_list:=ptr_list
    c_node:=c_list.head
    WHILE c_node
        IF c_node.succ
            IF c_node.succ=0 THEN RemTail(c_list)
            IF c_node.pred=0 THEN RemHead(c_list)
            IF (c_node.succ<>0) AND (c_node.pred<>0) THEN Remove(c_node)
        ENDIF
        c_node:=c_node.succ
    ENDWHILE
    RETURN c_list
ENDPROC
PROC p_GetAdrNode(ptr_list,num_node) /*"p_GetAdrNode(ptr_list,num_node)"*/
/********************************************************************************
 * Para         : address of list,number's node.
 * Return       : address of node or NIL.
 * Description  : Find the address of a node.
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
PROC p_AjouteNode(ptr_list,node_name) HANDLE /*"p_AjouteNode(ptr_list,node_name)"*/
/********************************************************************************
 * Para         : address of list,the name of a node.
 * Return       : the number of the new selected node in the list.
 * Description  : Add a node and return the new current node (for LISTVIEW_KIND).
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
/******************************************/
PROC p_AjouteActionNode(numid,list:PTR TO lh) /*"p_AjouteActionNode(numid,list:PTR TO lh)"*/
    DEF idnode:PTR TO ln
    DEF node:PTR TO ln
    DEF myactnode:PTR TO actionnode,nn
    idnode:=p_GetAdrNode(mywvbase.adridlist,numid)
    IF FindName(mywvbase.adractionlist,idnode.name)
        EasyRequestArgs(0,[20,0,0,'Le Type "\s" existe déjà.','Ok'],0,[idnode.name])
        RETURN FALSE
    ENDIF
    node:=New(SIZEOF ln)
    myactnode:=New(SIZEOF actionnode)
    node.succ:=0
    node.name:=String(EstrLen(idnode.name))
    StrCopy(node.name,idnode.name,ALL)
    CopyMem(node,myactnode.node,SIZEOF ln)
    AddTail(mywvbase.adractionlist,myactnode.node)
    nn:=p_GetNumNode(mywvbase.adractionlist,myactnode.node)
    curactionnode:=nn
    IF nn=0
        list.head:=myactnode.node
        node.pred:=0
    ENDIF
    myactnode.exectype:=MODE_WB
    myactnode.command:=0
    myactnode.currentdir:=0
    myactnode.stack:=4000
    myactnode.priority:=0
    IF node THEN Dispose(node)
ENDPROC
PROC p_EnleveActionNode(list:PTR TO lh,numnode) /*"p_EnleveActionNode(list:PTR TO lh,numnode)"*/
    DEF eactnode:PTR TO actionnode
    DEF node:PTR TO ln
    DEF count=0,retour=NIL
    DEF newn:PTR TO ln
    eactnode:=list.head
    WHILE eactnode
        node:=eactnode
        IF count=numnode
            IF node.succ<>0
                IF node.name THEN Dispose(node.name)
                IF eactnode.command THEN Dispose(eactnode.command)
                IF eactnode.currentdir THEN Dispose(eactnode.currentdir)
                IF eactnode THEN Dispose(eactnode)
            ENDIF
            IF node.succ=0
                RemTail(list)
                retour:=numnode-1
            ELSEIF node.pred=0
                RemHead(list)
                retour:=numnode
                newn:=p_GetAdrNode(list,numnode)
                list.head:=newn
                newn.pred:=0
            ELSEIF (node.succ<>0) AND (node.pred<>0)
                Remove(node)
                retour:=numnode-1
            ENDIF
        ENDIF
        INC count
        eactnode:=node.succ
    ENDWHILE
    RETURN retour
ENDPROC
PROC p_CleanActionList(list:PTR TO lh) /*"p_CleanActionList(list:PTR TO lh)"*/
    DEF eactnode:PTR TO actionnode
    DEF node:PTR TO ln
    eactnode:=list.head
    WHILE eactnode
        node:=eactnode
        IF node.succ<>0
            IF node.name THEN Dispose(node.name)
            IF eactnode.command THEN Dispose(eactnode.command)
            IF eactnode.currentdir THEN Dispose(eactnode.currentdir)
            IF eactnode THEN Dispose(eactnode)
        ENDIF
        IF node.succ=0
            RemTail(list)
        ELSEIF node.pred=0
            RemHead(list)
        ELSEIF (node.succ<>0) AND (node.pred<>0)
            Remove(node)
        ENDIF
        eactnode:=node.succ
    ENDWHILE
ENDPROC
PROC p_RemoveActionList(list:PTR TO lh,mode) /*"p_RemoveActionList(list:PTR TO lh,mode)"*/
    p_CleanActionList(list)
    IF mode=TRUE
        IF list THEN Dispose(list)
    ENDIF
ENDPROC
/***************************/
/* Window Proc             */
/***************************/
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
PROC p_InitwpWindow() HANDLE /*"p_InitwpWindow()"*/
    IF (wp_glist:=CreateContext({wp_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_command:=CreateGadgetA(TEXT_KIND,wp_glist,[88,19,181,12,'Commande',tattr,0,1,visual,0]:newgadget,[GTTX_BORDER,TRUE,GTTX_TEXT,'',GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_getcommand:=CreateGadgetA(BUTTON_KIND,g_command,[269,19,41,12,'?',tattr,1,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_exectype:=CreateGadgetA(CYCLE_KIND,g_getcommand,[88,32,221,12,'ExecType',tattr,2,1,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCY_LABELS,['Mode WB','Mode CLI',0],GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_stack:=CreateGadgetA(INTEGER_KIND,g_exectype,[218,45,91,12,'Pile',tattr,3,1,visual,0]:newgadget,[GTIN_NUMBER,NIL,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_pri:=CreateGadgetA(INTEGER_KIND,g_stack,[88,45,77,12,'Priorité',tattr,4,1,visual,0]:newgadget,[GTIN_NUMBER,NIL,GA_RELVERIFY,TRUE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_load:=CreateGadgetA(BUTTON_KIND,g_pri,[16,63,81,12,'_Charger',tattr,5,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_save:=CreateGadgetA(BUTTON_KIND,g_load,[122,63,81,12,'_Sauver',tattr,6,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_saveas:=CreateGadgetA(BUTTON_KIND,g_save,[229,63,81,12,'S_auver S.',tattr,7,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_add:=CreateGadgetA(BUTTON_KIND,g_saveas,[56,81,81,12,'_Add',tattr,8,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_rem:=CreateGadgetA(BUTTON_KIND,g_add,[188,81,81,12,'_Rem',tattr,9,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_idlist:=CreateGadgetA(LISTVIEW_KIND,g_rem,[28,106,110,41,'ID',tattr,10,4,visual,0]:newgadget,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,-1,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_actionlist:=CreateGadgetA(LISTVIEW_KIND,g_idlist,[176,106,110,41,'Action',tattr,11,4,visual,0]:newgadget,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,-1,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RenderwpWindow() /*"p_RenderwpWindow()"*/
    DEF infonode:PTR TO actionnode
    IF p_EmptyList(mywvbase.adractionlist)<>-1
        infonode:=p_GetAdrNode(mywvbase.adractionlist,curactionnode)
        Gt_SetGadgetAttrsA(g_command,wp_window,NIL,[GA_DISABLED,FALSE,GTTX_BORDER,TRUE,GTTX_TEXT,infonode.command,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_getcommand,wp_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_exectype,wp_window,NIL,[GA_DISABLED,FALSE,GTCY_ACTIVE,infonode.exectype,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_stack,wp_window,NIL,[GA_DISABLED,FALSE,GTIN_NUMBER,infonode.stack,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_pri,wp_window,NIL,[GA_DISABLED,FALSE,GTIN_NUMBER,infonode.priority,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_actionlist,wp_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,curactionnode,GTLV_LABELS,mywvbase.adractionlist,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_rem,wp_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
    ELSE
        Gt_SetGadgetAttrsA(g_command,wp_window,NIL,[GA_DISABLED,TRUE,GTTX_BORDER,TRUE,GTTX_TEXT,'',TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_getcommand,wp_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_exectype,wp_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_stack,wp_window,NIL,[GA_DISABLED,TRUE,GTIN_NUMBER,NIL,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_pri,wp_window,NIL,[GA_DISABLED,TRUE,GTIN_NUMBER,NIL,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_actionlist,wp_window,NIL,[GA_DISABLED,TRUE,GTLV_SHOWSELECTED,NIL,GTLV_LABELS,mywvbase.adremptylist,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_rem,wp_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
    ENDIF
    Gt_SetGadgetAttrsA(g_idlist,wp_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,curidnode,GTLV_TOP,curidnode,GTLV_LABELS,mywvbase.adridlist,TAG_DONE,0])
    DrawBevelBoxA(wp_window.rport,9,61,305,16,[GT_VISUALINFO,visual,TAG_DONE,0])
    DrawBevelBoxA(wp_window.rport,9,13,305,46,[GT_VISUALINFO,visual,TAG_DONE,0])
    DrawBevelBoxA(wp_window.rport,9,79,304,68,[GT_VISUALINFO,visual,TAG_DONE,0])
    RefreshGList(g_command,wp_window,NIL,-1)
    Gt_RefreshWindow(wp_window,NIL)
ENDPROC
PROC p_OpenwpWindow() HANDLE /*"p_OpenwpWindow()"*/
    IF (wp_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,10,
                       WA_TOP,10,
                       WA_WIDTH,319,
                       WA_HEIGHT,150,
                       WA_IDCMP,$400278,
                       WA_FLAGS,$102E,
                       WA_GADGETS,wp_glist,
                       WA_TITLE,'WVPrefs v0.1 © NasGûl',
                       WA_SCREENTITLE,'Made With GadToolsBox v2.0 © 1991-1993',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    p_RenderwpWindow()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RemwpWindow() /*"p_RemwpWindow()"*/
    IF wp_window THEN CloseWindow(wp_window)
    IF wp_glist THEN FreeGadgets(wp_glist)
ENDPROC
PROC p_LockListView() /*"p_LockListView()"*/
    Gt_SetGadgetAttrsA(g_actionlist,wp_window,NIL,[GTLV_LABELS,-1,TAG_DONE,0])
ENDPROC
/***************************/
/* Message proc            */
/***************************/
PROC p_LookAllMessage() /*"p_LookAllMessage()"*/
    DEF sigreturn
    DEF wpport:PTR TO mp
    IF wp_window THEN wpport:=wp_window.userport ELSE wpport:=NIL
    sigreturn:=Wait(Shl(1,wpport.sigbit) OR
                    $F000)
    IF (sigreturn AND Shl(1,wpport.sigbit))
        p_LookwpMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
PROC p_LookwpMessage() /*"p_LookwpMessage()"*/
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF gstr:PTR TO stringinfo
   DEF type=0,infos=NIL
   DEF actnode:PTR TO actionnode
   WHILE (mes:=Gt_GetIMsg(wp_window.userport))
       type:=mes.class
       SELECT type
           CASE IDCMP_MENUPICK
              infos:=mes.code
              SELECT infos
              ENDSELECT
           CASE IDCMP_CLOSEWINDOW
              reelquit:=TRUE
           CASE IDCMP_GADGETDOWN
              type:=IDCMP_GADGETUP
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                  CASE GA_G_COMMAND
                  CASE GA_G_GETCOMMAND
                      p_LockListView()
                      p_FileRequester(curactionnode,NIL)
                      p_RenderwpWindow()
                  CASE GA_G_EXECTYPE
                      actnode:=p_GetAdrNode(mywvbase.adractionlist,curactionnode)
                      actnode.exectype:=mes.code
                  CASE GA_G_STACK
                      gstr:=g.specialinfo
                      actnode:=p_GetAdrNode(mywvbase.adractionlist,curactionnode)
                      actnode.stack:=Val(gstr.buffer,NIL)
                  CASE GA_G_PRI
                      gstr:=g.specialinfo
                      actnode:=p_GetAdrNode(mywvbase.adractionlist,curactionnode)
                      actnode.stack:=Val(gstr.buffer,NIL)
                  CASE GA_G_LOAD
                      p_LockListView()
                      p_FileRequester(-1,LOAD_PREFS)
                      p_RenderwpWindow()
                  CASE GA_G_SAVE
                      p_LockListView()
                      p_SavePrefsFile(mywvbase.adractionlist,'Env:WhatView.Prefs')
                      p_RenderwpWindow()
                  CASE GA_G_SAVEAS
                      p_LockListView()
                      p_FileRequester(-1,SAVE_PREFS)
                      p_RenderwpWindow()
                  CASE GA_G_ADD
                      p_LockListView()
                      p_AjouteActionNode(curidnode,mywvbase.adractionlist)
                      p_RenderwpWindow()
                  CASE GA_G_REM
                      p_LockListView()
                      curactionnode:=p_EnleveActionNode(mywvbase.adractionlist,curactionnode)
                      p_RenderwpWindow()
                  CASE GA_G_IDLIST
                      curidnode:=mes.code
                  CASE GA_G_ACTIONLIST
                      curactionnode:=mes.code
                      p_RenderwpWindow()
              ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
ENDPROC
/***************************/
/* Application proc        */
/***************************/
PROC p_InitWVAPP() HANDLE /*"p_InitWVAPP()"*/
    mywvbase:=New(SIZEOF wvbase)
    mywvbase.adridlist:=p_InitList()
    mywvbase.adractionlist:=p_InitList()
    mywvbase.adremptylist:=p_InitList()
    p_AjouteNode(mywvbase.adremptylist,'')
    Raise(p_BuildIdList())
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RemWVAPP() /*"p_RemWVAPP()"*/
    IF mywvbase.adridlist THEN p_RemoveList(mywvbase.adridlist)
    IF mywvbase.adremptylist THEN p_RemoveList(mywvbase.adremptylist)
    IF mywvbase.adractionlist THEN p_RemoveActionList(mywvbase.adractionlist,TRUE)
    IF mywvbase THEN Dispose(mywvbase)
ENDPROC
PROC p_BuildIdList() /*"p_BuildIdList()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Clean the ListView and rebuild it with all filetype (whatis.library).
 *******************************************************************************/
    DEF next
    DEF id_str[9]:STRING
    DEF my_string[256]:STRING
    p_CleanList(mywvbase.adridlist)
    next:=FirstType()
    WHILE next
        id_str:=GetIDString(next)
        StringF(my_string,'\s',id_str)
        p_AjouteNode(mywvbase.adridlist,my_string)
        next:=NextType(next)
    ENDWHILE
    RETURN ER_NONE
ENDPROC
PROC p_FileRequester(numactnode,action) /*"p_FileRequester(numactnode,action)"*/
  DEF fichier[256]:STRING
  DEF dossier[256]:STRING
  DEF piv_string[256]:STRING
  DEF reqload:PTR TO filerequestr
  DEF mnode:PTR TO actionnode
  IF reqload:=AllocAslRequest(ASL_FILEREQUEST,[ASL_OKTEXT,'Ok',ASL_DIR,defdir,0])
      IF RequestFile(reqload)
          StringF(dossier,'\s',reqload.dir)
          StringF(defdir,'\s',reqload.dir)
          StringF(fichier,'\s',reqload.file)
      ELSE
      ENDIF
      FreeAslRequest(reqload)
  ELSE
     RETURN FALSE
  ENDIF
  IF numactnode<>-1
      mnode:=p_GetAdrNode(mywvbase.adractionlist,numactnode)
      IF mnode.command THEN DisposeLink(mnode.command)
      mnode.command:=String(EstrLen(fichier))
      StrCopy(mnode.command,fichier,ALL)
      IF mnode.currentdir THEN DisposeLink(mnode.currentdir)
      mnode.currentdir:=String(EstrLen(dossier))
      StrCopy(mnode.currentdir,dossier,ALL)
  ELSE
      SELECT action
        CASE LOAD_PREFS
          AddPart(dossier,'',256)
          StringF(piv_string,'\s\s',dossier,fichier)
          p_ReadPrefsFile(piv_string)
        CASE SAVE_PREFS
          AddPart(dossier,'',256)
          StringF(piv_string,'\s\s',dossier,fichier)
          p_SavePrefsFile(mywvbase.adractionlist,piv_string)
      ENDSELECT
  ENDIF
ENDPROC
PROC p_SavePrefsFile(list:PTR TO lh,fichier) /*"p_SavePrefsFile(list:PTR TO lh,fichier)"*/
    DEF sactnode:PTR TO actionnode
    DEF node:PTR TO ln
    DEF h
    IF h:=Open(fichier,1006)
        Write(h,[ID_WVPR]:LONG,4)
        sactnode:=list.head
        WHILE sactnode
            node:=sactnode
            IF node.succ<>0
                Write(h,[ID_WVAC]:LONG,4)
                Write(h,[sactnode.exectype]:INT,2)
                Write(h,[sactnode.stack]:LONG,4)
                Write(h,[sactnode.priority]:INT,2)
                Write(h,node.name,EstrLen(node.name))
                Out(h,0)
                Write(h,sactnode.command,EstrLen(sactnode.command))
                Out(h,0)
                Write(h,sactnode.currentdir,EstrLen(sactnode.currentdir))
                Out(h,0)
            ENDIF
            sactnode:=node.succ
        ENDWHILE
        IF h THEN Close(h)
    ENDIF
ENDPROC
PROC p_ReadPrefsFile(source) /*"p_ReadPrefsFile(source)"*/
    DEF len,a,adr,buf,handle,flen=TRUE,pos
    DEF chunk
    DEF pv[256]:STRING
    DEF node:PTR TO ln
    DEF addact:PTR TO actionnode
    DEF list:PTR TO lh,nn=NIL
    IF (flen:=FileLength(source))=-1 THEN RETURN FALSE
    IF (buf:=New(flen+1))=NIL THEN RETURN FALSE
    IF (handle:=Open(source,1005))=NIL THEN RETURN FALSE
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN RETURN FALSE
    adr:=buf
    chunk:=Long(adr)
    IF chunk<>ID_WVPR
        Dispose(buf)
        RETURN FALSE
    ENDIF
    p_RemoveActionList(mywvbase.adractionlist,FALSE)
    FOR a:=0 TO len-1
        pos:=adr++
        chunk:=Long(pos)
        SELECT chunk
            CASE ID_WVAC
                pos:=pos+4
                node:=New(SIZEOF ln)
                addact:=New(SIZEOF actionnode)
                addact.exectype:=Int(pos)
                addact.stack:=Long(pos+2)
                addact.priority:=Int(pos+6)
                StringF(pv,'\s',pos+8)
                node.name:=String(EstrLen(pv))
                node.succ:=0
                StrCopy(node.name,pv,ALL)
                pos:=pos+8+EstrLen(pv)+1
                StringF(pv,'\s',pos)
                addact.command:=String(EstrLen(pv))
                StrCopy(addact.command,pv,ALL)
                pos:=pos+EstrLen(pv)+1
                StringF(pv,'\s',pos)
                addact.currentdir:=String(EstrLen(pv))
                StrCopy(addact.currentdir,pv,ALL)
                pos:=pos+EstrLen(pv)+1
                CopyMem(node,addact.node,SIZEOF ln)
                AddTail(mywvbase.adractionlist,addact.node)
                nn:=p_GetNumNode(mywvbase.adractionlist,addact.node)
                IF nn=0
                    list:=mywvbase.adractionlist
                    list.head:=addact.node
                    node.pred:=0
                ENDIF
                IF node THEN Dispose(node)
        ENDSELECT
    ENDFOR
    Dispose(buf)
    RETURN TRUE
ENDPROC
/***************************/
/* Main Proc               */
/***************************/
PROC main() HANDLE /*"main()"*/
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    StrCopy(defdir,'Sys:',ALL)
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitwpWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitWVAPP())<>ER_NONE THEN Raise(testmain)
    IF FileLength('Env:Whatview.prefs')<>-1 THEN p_ReadPrefsFile('env:whatview.prefs')
    IF (testmain:=p_OpenwpWindow())<>ER_NONE THEN Raise(testmain)
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    p_RemwpWindow()
    p_RemWVAPP()
    p_SetDownScreen()
    p_CloseLibraries()
    SELECT exception
        CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.')
        CASE ER_VISUAL;     WriteF('Error Visual.')
        CASE ER_CONTEXT;    WriteF('Error Context.')
        CASE ER_MENUS;      WriteF('Error Menus.')
        CASE ER_GADGET;     WriteF('Error Gadget.')
        CASE ER_WINDOW;     WriteF('Error Window.')
    ENDSELECT
ENDPROC
