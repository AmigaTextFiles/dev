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
MODULE 'smgui','reqtools','libraries/reqtools'
ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_LIST,ER_MEM
ENUM JOB_DONE,JOB_CONST,JOB_OBJ,JOB_LIB=6

CONST F_OBJ=0,
      F_CONST=1,
      F_FUNC=2
CONST MODE_LOAD=0,
      MODE_SAVE=1,
      FUNC_MOD=0,
      FUNC_CONF=1
CONST ID_SMOD=$534D4F44,
      ID_MODU=$4D4F4455
DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offy
/****************************************
 * sm Definitions
 ****************************************/
DEF sm_window=NIL:PTR TO window
DEF sm_glist=NIL
/* Gadgets */
CONST GA_G_ADDMOD=0
CONST GA_G_REMMOD=1
CONST GA_G_SAVEMOD=2
CONST GA_G_FINDOBJ=3
CONST GA_G_FINDCONST=4
CONST GA_G_FINDFUNC=5
CONST GA_G_LOADCONG=6
CONST GA_G_SAVECONF=7
CONST GA_G_QUIT=8
CONST GA_G_MODLIST=9
CONST GA_G_DATALIST=10
/* Gadgets labels of sm */
DEF g_addmod
DEF g_remmod
DEF g_savemod
DEF g_findobj
DEF g_findconst
DEF g_findfunc
DEF g_loadcong
DEF g_saveconf
DEF g_quit
DEF g_modlist
DEF g_datalist
/***********************/
/* Application         */
/***********************/
DEF mysm:PTR TO smbase
DEF currentmodule=0
/***********************/
/* OpenClose Libraries */
/***********************/
PROC p_OpenLibraries() HANDLE /*"p_OpenLibraries()"*/
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL THEN Raise(ER_REQTOOLSLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_CloseLibraries()  /*"p_CloseLibraries()"*/
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
/***********************/
/* List fonctions      */
/***********************/
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
PROC p_RemoveList(list:PTR TO lh) /*"p_RemoveList(list:PTR TO lh)"*/
/********************************************************************************
 * Para         : address of list
 * Return       : NONE
 * Description  : p_CleanList() and dispose the list.
 *******************************************************************************/
    list:=p_CleanList(list)
    IF list THEN Dispose(list)
ENDPROC
PROC p_CleanList(list:PTR TO lh) /*"p_CleanList(list:PTR TO lh)"*/
/********************************************************************************
 * Para         : address of list
 * Return       : address of clean list
 * Description  : Remove all nodes in the list.
 *******************************************************************************/
    DEF node:PTR TO ln
    node:=list.head
    WHILE node
        IF node.succ=0 THEN RemTail(list)
        IF node.pred=0 THEN RemHead(list)
        IF (node.succ<>0) AND (node.pred<>0) THEN Remove(node)
        node:=node.succ
    ENDWHILE
    RETURN list
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
PROC p_RemoveModuleList(list:PTR TO lh,action) /*"p_RemoveModuleList(list:PTR TO lh,action)"*/
    DEF rmod:PTR TO modulenode
    DEF node:PTR TO ln
    rmod:=list.head
    WHILE rmod
        node:=rmod
        IF node.succ<>0
            IF rmod.datalist THEN p_RemoveList(rmod.datalist)
            IF rmod THEN Dispose(rmod)
        ENDIF
        IF node.succ=0 THEN RemTail(list)
        IF node.pred=0 THEN RemHead(list)
        IF (node.succ<>0) AND (node.pred<>0) THEN Remove(node)
        rmod:=node.succ
    ENDWHILE
    IF action=TRUE
        IF list THEN Dispose(list)
    ENDIF
ENDPROC
PROC p_RemoveModuleNode(list:PTR TO lh,numnode) /*"p_RemoveModuleNode(list:PTR TO lh,numnode)"*/
    DEF rmod:PTR TO modulenode
    DEF node:PTR TO ln,count=0
    DEF retour=NIL,newnode:PTR TO ln
    rmod:=list.head
    WHILE rmod
        node:=rmod
        IF count=numnode
            IF node.succ<>0
                IF rmod.datalist THEN p_RemoveList(rmod.datalist)
                IF rmod THEN Dispose(rmod)
            ENDIF
            IF node.succ=0
                RemTail(list)
                retour:=numnode-1
            ELSEIF node.pred=0
                RemHead(list)
                retour:=numnode
                newnode:=p_GetAdrNode(list,numnode)
                list.head:=newnode
                newnode.pred:=0
            ELSEIF (node.succ<>0) AND (node.pred<>0)
                Remove(node)
                retour:=numnode-1
            ENDIF
        ENDIF
        INC count
        rmod:=node.succ
    ENDWHILE
    RETURN retour
ENDPROC
/***********************/
/* Window Proc         */
/***********************/
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
PROC p_InitsmWindow() HANDLE /*"p_InitsmWindow()"*/
    IF (sm_glist:=CreateContext({sm_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_addmod:=CreateGadgetA(BUTTON_KIND,sm_glist,[21,20,151,12,'Charger Module',tattr,0,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_remmod:=CreateGadgetA(BUTTON_KIND,g_addmod,[21,33,151,12,'Enlever Module',tattr,1,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_savemod:=CreateGadgetA(BUTTON_KIND,g_remmod,[21,46,151,12,'Sauver Module',tattr,2,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_findobj:=CreateGadgetA(BUTTON_KIND,g_savemod,[206,20,151,12,'Trouver Objet',tattr,3,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_findconst:=CreateGadgetA(BUTTON_KIND,g_findobj,[206,33,151,12,'Trouver Const.',tattr,4,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_findfunc:=CreateGadgetA(BUTTON_KIND,g_findconst,[206,46,151,12,'Trouver Fonct.',tattr,5,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_loadcong:=CreateGadgetA(BUTTON_KIND,g_findfunc,[392,20,151,12,'Charger Conf.',tattr,6,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_saveconf:=CreateGadgetA(BUTTON_KIND,g_loadcong,[392,33,151,12,'Sauver Conf.',tattr,7,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_quit:=CreateGadgetA(BUTTON_KIND,g_saveconf,[392,46,151,12,'Quitter.',tattr,8,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_modlist:=CreateGadgetA(LISTVIEW_KIND,g_quit,[13,65,540,41,'',tattr,9,0,visual,0]:newgadget,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,-1,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_datalist:=CreateGadgetA(LISTVIEW_KIND,g_modlist,[15,107,540,129,'',tattr,10,0,visual,0]:newgadget,[GTLV_READONLY,TRUE,GTLV_LABELS,-1,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RendersmWindow() /*"p_RendersmWindow()"*/
    DEF infomod:PTR TO modulenode
    IF p_EmptyList(mysm.modulelist)=-1
        Gt_SetGadgetAttrsA(g_modlist,sm_window,NIL,[GA_DISABLED,TRUE,GTLV_LABELS,mysm.emptylist,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_datalist,sm_window,NIL,[GA_DISABLED,TRUE,GTLV_LABELS,mysm.emptylist,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_remmod,sm_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_savemod,sm_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_findobj,sm_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_findconst,sm_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_findfunc,sm_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_saveconf,sm_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
    ELSE
        infomod:=p_GetAdrNode(mysm.modulelist,currentmodule)
        Gt_SetGadgetAttrsA(g_modlist,sm_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,currentmodule,GTLV_LABELS,mysm.modulelist,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_datalist,sm_window,NIL,[GA_DISABLED,FALSE,GTLV_LABELS,infomod.datalist,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_remmod,sm_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_savemod,sm_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_findobj,sm_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_findconst,sm_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_findfunc,sm_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_saveconf,sm_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
    ENDIF
    DrawBevelBoxA(sm_window.rport,10,15,545,48,[GT_VISUALINFO,visual,TAG_DONE,0])
    RefreshGList(g_addmod,sm_window,NIL,-1)
    Gt_RefreshWindow(sm_window,NIL)
ENDPROC
PROC p_OpensmWindow() HANDLE /*"p_OpensmWindow()"*/
    IF (sm_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,10,
                       WA_TOP,0,
                       WA_WIDTH,565,
                       WA_HEIGHT,234,
                       WA_IDCMP,$400278+IDCMP_REFRESHWINDOW,
                       WA_FLAGS,$102E+WFLG_HASZOOM,
                       WA_ZOOM,[10,0,565,11]:INT,
                       WA_GADGETS,sm_glist,
                       WA_TITLE,'SModule v0.5 © 1992/1994 $#%!/NasGûl',
                       WA_SCREENTITLE,'Made With GadToolsBox v2.0 © 1991-1993',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    p_RendersmWindow()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RemsmWindow() /*"p_RemsmWindow()"*/
    IF sm_window THEN CloseWindow(sm_window)
    IF sm_glist THEN FreeGadgets(sm_glist)
ENDPROC
PROC p_LockListView() /*"p_LockListView()"*/
    Gt_SetGadgetAttrsA(g_modlist,sm_window,NIL,[GTLV_LABELS,-1,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_datalist,sm_window,NIL,[GTLV_LABELS,-1,TAG_DONE,0])
ENDPROC
/***********************/
/* Message Proc        */
/***********************/
PROC p_LookAllMessage() /*"p_LookAllMessage()"*/
    DEF sigreturn
    DEF smport:PTR TO mp
    IF sm_window THEN smport:=sm_window.userport ELSE smport:=NIL
    sigreturn:=Wait(Shl(1,smport.sigbit) OR
                    $F000)
    IF (sigreturn AND Shl(1,smport.sigbit))
        p_LooksmMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
PROC p_LooksmMessage() /*"p_LooksmMessage()"*/
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF type=0,infos=NIL
   WHILE (mes:=Gt_GetIMsg(sm_window.userport))
       type:=mes.class
       SELECT type
           CASE IDCMP_MENUPICK
              infos:=mes.code
              SELECT infos
              ENDSELECT
           CASE IDCMP_REFRESHWINDOW
              p_LockListView()
              p_RendersmWindow()
           CASE IDCMP_CLOSEWINDOW
              reelquit:=TRUE
           CASE IDCMP_GADGETDOWN
              type:=IDCMP_GADGETUP
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                  CASE GA_G_ADDMOD
                    p_LockListView()
                    p_FileRequester(MODE_LOAD,FUNC_MOD)
                    p_RendersmWindow()
                  CASE GA_G_REMMOD
                    p_LockListView()
                    currentmodule:=p_RemoveModuleNode(mysm.modulelist,currentmodule)
                    p_RendersmWindow()
                  CASE GA_G_SAVEMOD
                    p_LockListView()
                    p_FileRequester(MODE_SAVE,FUNC_MOD)
                    p_RendersmWindow()
                  CASE GA_G_FINDOBJ
                    p_LockListView()
                    p_ReqStringFind(mysm.modulelist,F_OBJ)
                    p_RendersmWindow()
                  CASE GA_G_FINDCONST
                    p_LockListView()
                    p_ReqStringFind(mysm.modulelist,F_CONST)
                    p_RendersmWindow()
                  CASE GA_G_FINDFUNC
                    p_LockListView()
                    p_ReqStringFind(mysm.modulelist,F_FUNC)
                    p_RendersmWindow()
                  CASE GA_G_LOADCONG
                    p_LockListView()
                    p_FileRequester(MODE_LOAD,FUNC_CONF)
                    p_RendersmWindow()
                  CASE GA_G_SAVECONF
                    p_LockListView()
                    p_FileRequester(MODE_SAVE,FUNC_CONF)
                    p_RendersmWindow()
                  CASE GA_G_QUIT
                    reelquit:=TRUE
                  CASE GA_G_MODLIST
                    currentmodule:=mes.code
                    p_RendersmWindow()
                  CASE GA_G_DATALIST
              ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
ENDPROC
/***********************/
/* Application         */
/***********************/
PROC p_InitSMAPP() HANDLE /*"p_InitSMAPP()"*/
    mysm:=New(SIZEOF smbase)
    mysm.emptylist:=p_InitList()
    mysm.modulelist:=p_InitList()
    IF (mysm.emptylist=NIL) OR (mysm.modulelist=NIL) THEN Raise(ER_LIST)
    p_AjouteNode(mysm.emptylist,'')
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RemSMAPP() /*"p_RemSMAPP()"*/
    IF mysm.emptylist THEN p_RemoveList(mysm.emptylist)
    IF mysm.modulelist THEN p_RemoveModuleList(mysm.modulelist,TRUE)
    IF mysm THEN Dispose(mysm)
ENDPROC
PROC p_FileRequester(mode,fonction) /*"p_FileRequester(mode,fonction)"*/
/********************************************************************************
 * Para         : NONE
 * Return       : FALSE if Cancel selected.
 * Description  : PopUp a MultiFileRequester.
 *******************************************************************************/
    DEF reqfile:PTR TO rtfilerequester
    DEF liste:PTR TO rtfilelist
    DEF buffer[120]:STRING
    DEF add_liste
    DEF ret=TRUE
    DEF the_fullname[256]:STRING
    DEF the_reelname[256]:STRING
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,NIL)
        buffer[0]:=0
        RtChangeReqAttrA(reqfile,[RTFI_DIR,'Emodules:'])
        add_liste:=RtFileRequestA(reqfile,buffer,'SModule v0.5',
                                  [RTFI_FLAGS,FREQF_MULTISELECT,RTFI_OKTEXT,'_Ok',RTFI_HEIGHT,200,
                                   RT_UNDERSCORE,"_",TAG_DONE,0])
        liste:=add_liste
        IF buffer[0]<>0
            WHILE liste
                StringF(the_reelname,'\s',liste.name)
                AddPart(reqfile.dir,'',256)
                StringF(the_fullname,'\s\s',reqfile.dir,liste.name)
                SELECT mode
                    CASE MODE_LOAD
                        SELECT fonction
                            CASE FUNC_MOD
                                p_LoadModule(the_fullname)
                            CASE FUNC_CONF
                                p_ReadConfigFile(the_fullname)
                                JUMP plus
                        ENDSELECT
                    CASE MODE_SAVE
                        SELECT fonction
                            CASE FUNC_MOD
                               p_SaveModule(mysm.modulelist,the_fullname)
                               JUMP plus
                            CASE FUNC_CONF
                                p_SaveConfigFile(mysm.modulelist,the_fullname)
                                JUMP plus
                        ENDSELECT
                ENDSELECT
                liste:=liste.next
            ENDWHILE
            plus:
            IF add_liste THEN RtFreeFileList(add_liste)
        ELSE
            ret:=FALSE
        ENDIF
        IF reqfile THEN RtFreeRequest(reqfile)
    ELSE
        ret:=FALSE
    ENDIF

ENDPROC
PROC p_ReqStringFind(list:PTR TO lh,type) /*"p_ReqStringFind(list:PTR TO lh,type)"*/
    DEF my_sreq:PTR TO rtfilerequester
    DEF bodyreq[256]:STRING
    DEF buffer[256]:STRING
    DEF return_string[256]:STRING
    DEF ret,taglist,stringtag:PTR TO LONG
    DEF rmod:PTR TO modulenode
    DEF node:PTR TO ln
    DEF datlist:PTR TO lh
    DEF datnode:PTR TO ln
    DEF findnummod=NIL,findnumdat=NIL,pos
    stringtag:=['Un Objet.','Une Constante.','Une Fonction.']
    StringF(bodyreq,'Chercher \s',stringtag[type])
    StrCopy(buffer,'',ALL)
    taglist:=[RT_WINDOW,sm_window,RT_LOCKWINDOW,TRUE,RTEZ_REQTITLE,'SModule',RTGS_GADFMT,'_Ok|_Cancel',RTGS_TEXTFMT,bodyreq,RT_UNDERSCORE,"_",0]
    IF my_sreq:=RtAllocRequestA(RT_REQINFO,NIL)
        ret:=RtGetStringA(buffer,200,NIL,my_sreq,taglist)
        IF ret
            NOP
        ELSE
            buffer:=NIL
        ENDIF
        SELECT type
            CASE F_OBJ;   StringF(return_string,'(---) OBJECT \s',buffer)
            CASE F_CONST
                StringF(return_string,'\s',buffer)
                UpperStr(return_string)
            CASE F_FUNC
                StringF(return_string,'\s',buffer)
        ENDSELECT
        IF my_sreq THEN RtFreeRequest(my_sreq)
    ELSE
        RETURN NIL
    ENDIF
    rmod:=list.head
    WHILE rmod
        node:=rmod
        IF node.succ<>0
            datlist:=rmod.datalist
            datnode:=datlist.head
            findnumdat:=0
            WHILE datnode
                IF datnode.succ<>0
                    pos:=InStr(datnode.name,return_string,0)
                    IF pos<>-1 THEN JUMP fini
                ENDIF
                INC findnumdat
                datnode:=datnode.succ
            ENDWHILE
        ENDIF
        INC findnummod
        rmod:=node.succ
    ENDWHILE
    fini:
    IF pos<>-1
        currentmodule:=findnummod
        p_RendersmWindow()
        rmod:=p_GetAdrNode(mysm.modulelist,currentmodule)
        Gt_SetGadgetAttrsA(g_datalist,sm_window,NIL,[GA_DISABLED,FALSE,GTLV_TOP,findnumdat,GTLV_LABELS,rmod.datalist,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_modlist,sm_window,NIL,[GA_DISABLED,FALSE,GTLV_TOP,findnummod,GTLV_LABELS,mysm.modulelist,TAG_DONE,0])
    ELSE
        RtEZRequestA('\s non trouvé.\n','Ok',0,[return_string],[RT_LOCKWINDOW,TRUE,RT_WINDOW,sm_window,RTEZ_REQTITLE,'SModule v0.5',TAG_DONE,0])
    ENDIF
ENDPROC
PROC p_LoadModule(fichier) /*"p_LoadModule(fichier)"*/
/********************************************************************************
 * Para         : Num of list.
 * Return       : FALSE if error.
 * Description  : PopUp a filerequester and load module (routine par $#%!).
 *******************************************************************************/
  DEF end,job,len,val,f,off,types:PTR TO LONG,c,r,c2
  DEF flen,o:PTR TO INT,mem,handle=NIL
  DEF my_string[256]:STRING
  DEF piv_string[256]:STRING
  DEF node:PTR TO ln
  DEF modnode:PTR TO modulenode
  DEF nn,list:PTR TO lh
  flen:=FileLength(fichier)
  handle:=Open(fichier,OLDFILE)
  IF (flen<8) OR (handle=NIL)
    RETURN FALSE
  ELSE
    mem:=New(flen)
    IF mem=NIL
      Raise(ER_MEM)
    ELSE
      IF Read(handle,mem,flen)<>flen THEN RETURN FALSE
      Close(handle)
      handle:=NIL
      o:=mem
      end:=o+flen
      types:=['substructure','CHAR','INT','','LONG']
      IF ^o++<>"EMOD" THEN RETURN FALSE
      node:=New(SIZEOF ln)
      modnode:=New(SIZEOF modulenode)
      node.succ:=0
      node.name:=String(EstrLen(fichier))
      StrCopy(node.name,fichier,ALL)
      CopyMem(node,modnode.node,SIZEOF ln)
      AddTail(mysm.modulelist,modnode.node)
      nn:=p_GetNumNode(mysm.modulelist,modnode.node)
      IF nn=0
        list:=mysm.modulelist
        list.head:=modnode.node
        node.pred:=0
      ENDIF
      modnode.datalist:=p_InitList()
      currentmodule:=nn
      WHILE o<end
        job:=o[]++
        SELECT job
          CASE JOB_CONST
            len:=o[]++; f:=TRUE
            p_AjouteNode(modnode.datalist,'')
            WHILE len
              val:=^o++
              IF f THEN StrCopy(my_string,'CONST ',ALL) ELSE StrCopy(my_string,'      ',ALL)
              StringF(piv_string,'\s=',o);StrAdd(my_string,piv_string,ALL)
              IF (val>=-$20) AND (val<$20)
                  StringF(piv_string,'\d',val)
                  StrAdd(my_string,piv_string,ALL)
              ELSE
                  StringF(piv_string,'$\h',val)
                  StrAdd(my_string,piv_string,ALL)
              ENDIF
              o:=o+len; len:=o[]++; f:=FALSE
              IF len
                  StrAdd(my_string,',',ALL)
              ENDIF
              p_AjouteNode(modnode.datalist,my_string)
            ENDWHILE
          CASE JOB_OBJ
            p_AjouteNode(modnode.datalist,'')
            len:=o[]++;
            StringF(piv_string,'(---) OBJECT \s',o+4)
            StrCopy(my_string,piv_string,ALL)
            p_AjouteNode(modnode.datalist,my_string)
            o:=o+4+len
            WHILE len:=o[]++
              val:=o[]++
              off:=o[]++
              StringF(piv_string,'(\d[3])   \s:\s',off,o,types[val])
              StrCopy(my_string,piv_string,ALL)
              p_AjouteNode(modnode.datalist,my_string)
              o:=o+len
            ENDWHILE
            val:=o[]++
            StrCopy(my_string,'(---) ENDOBJECT     /* SIZEOF=',ALL)
            IF val<>$FFFF
                StringF(piv_string,'\d */',val)
                StrAdd(my_string,piv_string,ALL)
            ELSE
                StrAdd(my_string,'NONE !!! */',ALL)
            ENDIF
            p_AjouteNode(modnode.datalist,my_string)
          CASE JOB_LIB
            p_AjouteNode(modnode.datalist,'')
            c:=o
            WHILE c[]++ DO NOP
            StringF(piv_string,'LIBRARY \a\s\a, \s         /* informal notation */',o,c)
            StrCopy(my_string,piv_string,ALL)
            p_AjouteNode(modnode.datalist,my_string)
            WHILE c[]++ DO NOP
            WHILE (c[]<>$FF) AND (c<end)
              c2:=c
              WHILE c[]++>" " DO NOP; c--
              r:=c[]; c[]++:=0
              StringF(piv_string,'  \s\c',c2,"(")
              StrCopy(my_string,piv_string,ALL)
              WHILE r<" "
                IF r<16
                    IF r<8
                        StringF(piv_string,'D\d',r)
                        StrAdd(my_string,piv_string,ALL)
                    ELSE
                        StringF(piv_string,'A\d',r-8)
                        StrAdd(my_string,piv_string,ALL)
                    ENDIF
                ENDIF
                r:=c[]++
                IF r<16
                    StrAdd(my_string,',',ALL)
                ENDIF
              ENDWHILE
              c--
              StrAdd(my_string,')',ALL)
              p_AjouteNode(modnode.datalist,my_string)
            ENDWHILE
            StrCopy(my_string,'ENDLIBRARY',ALL)
            p_AjouteNode(modnode.datalist,my_string)
            o:=end
          CASE JOB_DONE
            o:=end
          DEFAULT
            /* Raise(ER_JOBID) */
            NOP
        ENDSELECT
      ENDWHILE
    ENDIF
  ENDIF
  RETURN TRUE
ENDPROC
PROC p_SaveModule(list:PTR TO lh,fichier) /*"p_SaveModule(list:PTR TO lh,fichier)"*/
    DEF snode:PTR TO modulenode
    DEF node:PTR TO ln
    DEF datlist:PTR TO lh
    DEF pv[256]:STRING,h
    snode:=p_GetAdrNode(list,currentmodule)
    datlist:=snode.datalist
    IF h:=Open(fichier,1006)
        node:=datlist.head
        WHILE node
            IF node.succ<>0
                StringF(pv,'\s\n',node.name)
                Write(h,pv,EstrLen(pv))
            ENDIF
            node:=node.succ
        ENDWHILE
        IF h THEN Close(h)
    ENDIF
ENDPROC
PROC p_SaveConfigFile(list:PTR TO lh,fichier) /*"p_SaveConfigFile(list:PTR TO lh,fichier)"*/
    DEF smod:PTR TO modulenode
    DEF node:PTR TO ln
    DEF h
    IF h:=Open(fichier,1006)
        Write(h,[ID_SMOD]:LONG,4)
        smod:=list.head
        WHILE smod
            node:=smod
            IF node.succ<>0
                Write(h,[ID_MODU]:LONG,4)
                Write(h,node.name,EstrLen(node.name))
                Out(h,0)
            ENDIF
            smod:=node.succ
        ENDWHILE
        IF h THEN Close(h)
    ENDIF
ENDPROC
PROC p_ReadConfigFile(source) /*"p_ReadConfigFile(source)"*/
    DEF len,a,adr,buf,handle,flen=TRUE,pos
    DEF chunk
    DEF pv[256]:STRING
    IF (flen:=FileLength(source))=-1 THEN RETURN FALSE
    IF (buf:=New(flen+1))=NIL THEN RETURN FALSE
    IF (handle:=Open(source,1005))=NIL THEN RETURN FALSE
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN RETURN FALSE
    adr:=buf
    chunk:=Long(adr)
    IF chunk<>ID_SMOD
        Dispose(buf)
        RETURN FALSE
    ENDIF
    p_RemoveModuleList(mysm.modulelist,FALSE)
    FOR a:=0 TO len-1
        pos:=adr++
        chunk:=Long(pos)
        SELECT chunk
            CASE ID_MODU
                StringF(pv,'\s',pos+4)
                p_LoadModule(pv)
        ENDSELECT
    ENDFOR
    Dispose(buf)
    RETURN TRUE
ENDPROC
/***********************/
/* Main Proc           */
/***********************/
PROC main() HANDLE /*"main()"*/
    DEF testmain
    tattr:=['topaz.font',9,0,0]:textattr
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitsmWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitSMAPP())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_OpensmWindow())<>ER_NONE THEN Raise(testmain)
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    p_RemsmWindow()
    p_RemSMAPP()
    p_SetDownScreen()
    p_CloseLibraries()
    CleanUp(0)
    SELECT exception
        CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.')
        CASE ER_VISUAL;     WriteF('Error Visual.')
        CASE ER_CONTEXT;    WriteF('Error Context.')
        CASE ER_MENUS;      WriteF('Error Menus.')
        CASE ER_GADGET;     WriteF('Error Gadget.')
        CASE ER_WINDOW;     WriteF('Error Window.')
    ENDSELECT
ENDPROC
