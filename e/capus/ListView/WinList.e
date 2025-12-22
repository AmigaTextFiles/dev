/*=========================================================================================*/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */
/*=========================================================================================*/

OPT OSVERSION=37

MODULE 'intuition/intuition',
       'gadtools',
       'libraries/gadtools',
       'intuition/gadgetclass',
       'intuition/screens',
       'graphics/text',
       'exec/lists',
       'exec/nodes',
       'exec/ports',
       'eropenlib',
       'utility/tagitem'
MODULE 'utility','datanode','dos/dos'
MODULE 'reqtools','libraries/reqtools'
ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_LIST

DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offy
/*=======================================
 = tl Definitions
 =======================================*/
DEF tl_window=NIL:PTR TO window
DEF tl_glist=NIL
/*==================*/
/*     Gadgets      */
/*==================*/
CONST GA_G_ADD=0
CONST GA_G_REM=1
CONST GA_G_UP=2
CONST GA_G_DOWN=3
CONST GA_G_SORT=4
CONST GA_G_GETADR=5
CONST GA_G_GETNUM=6
CONST GA_G_COUNT=7
CONST GA_G_DATA=8
CONST GA_G_LIST=9
CONST GA_G_NODENAME=10
/*=============================
 = Gadgets labels of tl
 =============================*/
DEF g_add
DEF g_rem
DEF g_up
DEF g_down
DEF g_sort
DEF g_getadr
DEF g_getnum
DEF g_count
DEF g_data
DEF g_list
DEF g_nodename
/*===============================
 = App Definitions
 ================================*/
DEF mylist:PTR TO lh
DEF currentnode=0
PMODULE 'Pmodules:Plist'
PROC main() HANDLE /*"main()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : ER_NONE if ok,else the error.
 = Description  : Main Procedure.
 ==============================================================================*/
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF (mylist:=p_InitList())=NIL THEN Raise(ER_LIST)
    IF arg<>NIL THEN p_MakeCurrentDirList(arg)
    IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InittlWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_OpentlWindow())<>ER_NONE THEN Raise(testmain)
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    IF mylist THEN p_CleanList(mylist,-1,[14,DISL,DISE],LIST_REMOVE)
    IF tl_window THEN p_RemtlWindow()
    IF screen THEN p_SetDownScreen()
    p_CloseLibraries()
    SELECT exception
        CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.\n')
        CASE ER_VISUAL;     WriteF('Error Visual.\n')
        CASE ER_CONTEXT;    WriteF('Error Context.\n')
        CASE ER_MENUS;      WriteF('Error Menus.\n')
        CASE ER_GADGET;     WriteF('Error Gadget.\n')
        CASE ER_WINDOW;     WriteF('Error Window.\n')
        CASE ER_LIST;       WriteF('Error List.\n')
    ENDSELECT
    CleanUp(exception)
ENDPROC
PROC p_OpenLibraries() HANDLE /*"p_OpenLibraries()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : ER_NONE if ok,else the error.
 = Description  : Open libraries.
 ==============================================================================*/
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (utilitybase:=OpenLibrary('utility.library',37))=NIL THEN Raise(ER_UTILITYLIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))=NIL THEN Raise(ER_REQTOOLSLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_CloseLibraries()  /*"p_CloseLibraries()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : NONE.
 = Description  : Close Libraries
 ==============================================================================*/
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF utilitybase THEN CloseLibrary(utilitybase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
PROC p_SetUpScreen() HANDLE /*"p_SetUpScreen()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : ER_NONE if ok,else the error.
 = Description  : Lock screen and get the visualinfo.
 ==============================================================================*/
    IF (screen:=LockPubScreen('Workbench'))=NIL THEN Raise(ER_LOCKSCREEN)
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)+1
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_SetDownScreen() /*"p_SetDownScreen()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : NONE.
 = Description  : Free Visual and unlock Screen.
 ==============================================================================*/

    IF visual THEN FreeVisualInfo(visual)
    IF screen THEN UnlockPubScreen(NIL,screen)
ENDPROC
PROC p_InittlWindow() HANDLE /*"p_InittlWindow()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : ER_NONE if ok,else the error.
 = Description  : Build the gadgetlist.
 ==============================================================================*/
    IF (tl_glist:=CreateContext({tl_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_add:=CreateGadgetA(BUTTON_KIND,tl_glist,[23,18,91,12,'AddNode',tattr,0,16,visual,0]:newgadget,[GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_rem:=CreateGadgetA(BUTTON_KIND,g_add,[114,18,91,12,'RemNode',tattr,1,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_up:=CreateGadgetA(BUTTON_KIND,g_rem,[205,18,91,12,'UpNode',tattr,2,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_down:=CreateGadgetA(BUTTON_KIND,g_up,[296,18,91,12,'DownNode',tattr,3,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_sort:=CreateGadgetA(BUTTON_KIND,g_down,[23,32,91,12,'SortList',tattr,4,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_getadr:=CreateGadgetA(BUTTON_KIND,g_sort,[296,32,91,12,'GetAdr',tattr,5,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_getnum:=CreateGadgetA(BUTTON_KIND,g_getadr,[205,32,91,12,'GetNum',tattr,6,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_count:=CreateGadgetA(BUTTON_KIND,g_getnum,[114,32,91,12,'CountNodes',tattr,7,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_data:=CreateGadgetA(STRING_KIND,g_count,[21,131,370,13,'',tattr,8,0,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_list:=CreateGadgetA(LISTVIEW_KIND,g_data,[21,53,370,65,'',tattr,9,0,visual,0]:newgadget,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,-1,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_nodename:=CreateGadgetA(STRING_KIND,g_list,[21,116,370,13,'',tattr,10,0,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RendertlWindow() /*"p_RendertlWindow()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : NONE.
 = Description  : Redraw the window (for the Bevelbox and the listview).
 ==============================================================================*/
    DEF dn:PTR TO datanode
    DEF node:PTR TO ln
    IF p_EmptyList(mylist)=-1
        Gt_SetGadgetAttrsA(g_list,tl_window,NIL,[GTLV_SELECTED,NIL,GA_DISABLED,TRUE,GTLV_LABELS,-1,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_rem,tl_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_up,tl_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_down,tl_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_sort,tl_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_getadr,tl_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_getnum,tl_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_count,tl_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_data,tl_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_nodename,tl_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
    ELSE
        dn:=p_GetAdrNode(mylist,currentnode)
        node:=dn
        /*WriteF('\s \s\n',node.name,dn.data)*/
        Gt_SetGadgetAttrsA(g_list,tl_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,currentnode,GA_DISABLED,FALSE,GTLV_LABELS,mylist,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_rem,tl_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_up,tl_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_down,tl_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_sort,tl_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_getadr,tl_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_getnum,tl_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_count,tl_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_data,tl_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,dn.data,TAG_DONE,0])
        Gt_SetGadgetAttrsA(g_nodename,tl_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,node.name,TAG_DONE,0])
    ENDIF
    DrawBevelBoxA(tl_window.rport,10,15,391,32,[GT_VISUALINFO,visual,TAG_DONE,0])
    DrawBevelBoxA(tl_window.rport,10,50,391,96,[GT_VISUALINFO,visual,TAG_DONE,0])
    RefreshGList(g_add,tl_window,NIL,-1)
    Gt_RefreshWindow(tl_window,NIL)
ENDPROC
PROC p_OpentlWindow() HANDLE /*"p_OpentlWindow()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : ER_NONE if ok,else the error.
 = Description  : Open the window.
 ==============================================================================*/
    IF (tl_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,568,
                       WA_TOP,72,
                       WA_WIDTH,408,
                       WA_HEIGHT,149,
                       WA_IDCMP,$400278,
                       WA_FLAGS,$2E,
                       WA_GADGETS,tl_glist,
                       WA_TITLE,'WindowList Test v0.1 © 1994 NasGûl',
                       WA_SCREENTITLE,'Made With GadToolsBox v2.0 © 1991-1993 - Convert With Gui2E v0.1 © 1994 NasGûl',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    p_RendertlWindow()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RemtlWindow() /*"p_RemtlWindow()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : NONE.
 = Description  : Free window data.
 ==============================================================================*/
    IF tl_window THEN CloseWindow(tl_window)
    IF tl_glist THEN FreeGadgets(tl_glist)
ENDPROC
PROC p_LockListView(gad,win) /*"p_LockListView(gad,win)"*/
/*===============================================================================
 = Para         : Address of gadget,Address of window.
 = Return       : NONE.
 = Description  : Just lock the LISTVIEW Gadet.
 ==============================================================================*/
    Gt_SetGadgetAttrsA(gad,win,NIL,[GTLV_LABELS,-1,TAG_DONE,0])
ENDPROC
PROC p_UnLockListView(gad,win,list) /*"p_UnLockListView(gad,win,list)"*/
/*===============================================================================
 = Para         : Address of gadget (gadget),address of window (winodw),address of list (lh)
 = Return       : NONE.
 = Description  : Unlock the LISTVIEW if the list is not empty.
 ==============================================================================*/
    IF p_EmptyList(list)<>-1
        Gt_SetGadgetAttrsA(gad,win,NIL,[GA_DISABLED,FALSE,GTLV_LABELS,list,TAG_DONE,0])
    ELSE
        Gt_SetGadgetAttrsA(gad,win,NIL,[GA_DISABLED,TRUE,GTLV_LABELS,-1,TAG_DONE,0])
    ENDIF
ENDPROC

PROC p_LookAllMessage() /*"p_LookAllMessage()"*/
/*===============================================================================
 = Para         : NONE.
 = Return       : NONE.
 = Description  : Wait events on (window port and CTRL C/D/E/F ).
 ==============================================================================*/
    DEF sigreturn
    DEF tlport:PTR TO mp
    IF tl_window THEN tlport:=tl_window.userport ELSE tlport:=NIL
    sigreturn:=Wait(Shl(1,tlport.sigbit) OR
                    $F000)
    IF (sigreturn AND Shl(1,tlport.sigbit))
        p_LooktlMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
PROC p_LooktlMessage() /*"p_LooktlMessage()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : IDCMP Events.
 ==============================================================================*/
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF gstr:PTR TO stringinfo
   DEF type=0,infos=NIL
   DEF ndn:PTR TO datanode
   DEF nd:PTR TO ln
   DEF pv[256]:STRING
   DEF countnode
   IF mes:=Gt_GetIMsg(tl_window.userport)
       type:=mes.class
       SELECT type
           CASE IDCMP_MENUPICK
              infos:=mes.code
              SELECT infos
              ENDSELECT
           CASE IDCMP_CLOSEWINDOW
               reelquit:=TRUE
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                  CASE GA_G_ADD
                      p_LockListView(g_list,tl_window)
                      ndn:=New(SIZEOF datanode)
                      ndn.data:=String(EstrLen('(New)'))
                      StrCopy(ndn.data,'(New)',ALL)
                      currentnode:=p_AjouteNode(mylist,'(New)',ndn)
                      p_UnLockListView(g_list,tl_window,mylist)
                      p_RendertlWindow()
                  CASE GA_G_REM
                      p_LockListView(g_list,tl_window)
                      ndn:=p_GetAdrNode(mylist,currentnode)
                      IF ndn.data THEN DisposeLink(ndn.data)
                      currentnode:=p_EnleveNode(mylist,currentnode,-1,[14,DISL,DISE])
                      p_UnLockListView(g_list,tl_window,mylist)
                      p_RendertlWindow()
                  CASE GA_G_UP
                      p_LockListView(g_list,tl_window)
                      currentnode:=p_DoUpNode(mylist,currentnode)
                      p_UnLockListView(g_list,tl_window,mylist)
                      p_RendertlWindow()
                  CASE GA_G_DOWN
                      p_LockListView(g_list,tl_window)
                      currentnode:=p_DoDownNode(mylist,currentnode)
                      p_UnLockListView(g_list,tl_window,mylist)
                      p_RendertlWindow()
                  CASE GA_G_SORT
                      p_LockListView(g_list,tl_window)
                      p_SortList(mylist)
                      p_UnLockListView(g_list,tl_window,mylist)
                      p_RendertlWindow()
                  CASE GA_G_GETADR
                      nd:=p_GetAdrNode(mylist,currentnode)
                      RtEZRequestA('Address :\h[8]\n'+
                                  'Succ    :\h[8]\n'+
                                  'Pred    :\h[8]\n','Ok',0,[nd,nd.succ,nd.pred],[RT_LOCKWINDOW,TRUE,RT_WINDOW,tl_window,TAG_DONE,0])
                  CASE GA_G_GETNUM
                      RtEZRequestA('Current Node Number:\d','Ok',0,[currentnode],[RT_LOCKWINDOW,TRUE,RT_WINDOW,tl_window,TAG_DONE,0])
                  CASE GA_G_COUNT
                      countnode:=p_CountNodes(mylist)
                      RtEZRequestA('Number Of node(s):\d','Ok',0,[countnode],[RT_LOCKWINDOW,TRUE,RT_WINDOW,tl_window,TAG_DONE,0])
                  CASE GA_G_DATA
                      p_LockListView(g_list,tl_window)
                      gstr:=g.specialinfo
                      ndn:=p_GetAdrNode(mylist,currentnode)
                      IF ndn.data THEN DisposeLink(ndn.data)
                      StringF(pv,'\s',gstr.buffer)
                      ndn.data:=String(EstrLen(pv))
                      StrCopy(ndn.data,pv,ALL)
                      p_UnLockListView(g_list,tl_window,mylist)
                      p_RendertlWindow()
                  CASE GA_G_LIST
                      currentnode:=mes.code
                      p_RendertlWindow()
                  CASE GA_G_NODENAME
                      p_LockListView(g_list,tl_window)
                      gstr:=g.specialinfo
                      nd:=p_GetAdrNode(mylist,currentnode)
                      IF nd.name THEN DisposeLink(ndn.data)
                      StringF(pv,'\s',gstr.buffer)
                      nd.name:=String(EstrLen(pv))
                      StrCopy(nd.name,pv,ALL)
                      p_UnLockListView(g_list,tl_window,mylist)
                      p_RendertlWindow()
              ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDIF
ENDPROC
PROC p_MakeCurrentDirList(dir) /*"p_MakeCurrentDirList()"*/
/*===============================================================================
 = Para         : directory.
 = Return       : NONE.
 = Description  : Just add some node to the list.
 ==============================================================================*/
    DEF lock,info:fileinfoblock
    DEF f[256]:STRING,t[256]:STRING
    DEF dnode:PTR TO datanode
    IF lock:=Lock(dir,-2)
        IF Examine(lock,info)
            WHILE ExNext(lock,info)
                IF info.direntrytype>0
                    StringF(t,'\s','Dir')
                    StringF(f,'\s',info.filename)
                ELSE
                    StringF(t,'\d Octets',info.size)
                    StringF(f,'\s',info.filename)
                ENDIF
                dnode:=New(SIZEOF datanode)
                dnode.data:=String(EstrLen(t))
                StrCopy(dnode.data,t,ALL)
                p_AjouteNode(mylist,f,dnode)
            ENDWHILE
        ENDIF
        IF lock THEN UnLock(lock)
    ENDIF
ENDPROC

