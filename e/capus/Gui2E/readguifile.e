/**********************************/
/* GUI2E v0.0 © NasGûl            */
/**********************************/
/*
C_DATE=29 Jan 1994
C_TIME=23:24:45
*/

ENUM ER_NONE

MODULE 'gtx',
       'gadtoolsbox/forms',
       'gadtoolsbox/gui',
       'gadtoolsbox/prefs',
       'gadtoolsbox/gtxbase',
       'gadtoolsbox/hotkey',
       'gadtoolsbox/textclass'
MODULE 'intuition/intuitionbase','graphics/gfxbase','gadtools','libraries/gadtools','intuition/intuition'
MODULE 'reqtools','libraries/reqtools','nofrag','libraries/nofrag'
MODULE 'utility/tagitem','exec/memory','graphics/text'
MODULE 'utility/tagitem'
MODULE 'readguifile','exec/lists','exec/nodes'
DEF currentname[256]:STRING
DEF myguibase:PTR TO guibase
DEF string_kind[14]:LIST
/******************************************/
/* GESTION DES LISTES                     */
/******************************************/
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
/* LECTURE DU FICHIER GUI                 */
/******************************************/
PROC g_ReadGUIFile(source) /*"g_ReadGUIFile(source)"*/
    DEF len,a,adr,buf,handle,flen=TRUE,pos
    DEF chunk,long
    /*****************************************/
    /* Stockage du fichier source dans buf   */
    /*****************************************/
    IF (flen:=FileLength(source))=-1 THEN RETURN FALSE
    IF (buf:=New(flen+1))=NIL THEN RETURN FALSE
    IF (handle:=Open(source,1005))=NIL THEN RETURN FALSE
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN RETURN FALSE
    adr:=buf
    chunk:=Long(adr+8)
    IF chunk<>ID_GXUI THEN RETURN FALSE
    /***********/
    /* Lecture */
    /***********/
    FOR a:=0 TO len-1
        pos:=adr++
        chunk:=Long(pos)
        SELECT chunk
            long:=Long(pos+4)
            CASE ID_GXMN
            CASE ID_GXTX
            CASE ID_GXBX
            CASE ID_GXGA
            CASE ID_GXWD
            CASE ID_GXUI
            CASE ID_MEDA
                g_ReadMenuData(pos+8)
            CASE ID_ITXT
                g_ReadItextData(pos+8)
            CASE ID_BBOX
                g_ReadBboxData(pos+8)
            CASE ID_GADA
                g_ReadGadgetData(pos+8)
            CASE ID_WDDA
                g_ReadWindowData(pos+8)
            CASE ID_GGUI
            CASE ID_VERS
        ENDSELECT
    ENDFOR
    Dispose(buf)
ENDPROC
PROC g_ReadMenuData(mymenu:PTR TO menudata) /*"g_ReadMenuData(mymenu: PTR TO menudata)"*/
    DEF mynm:PTR TO newmenu
    DEF nnode:PTR TO ln
    DEF cnode:PTR TO ln
    DEF clist:PTR TO lh
    DEF curwin:PTR TO windownode
    DEF nm:PTR TO menunode
    DEF nn
    mynm:=mymenu
    curwin:=myguibase.currentwindow
    cnode:=curwin
    nnode:=New(SIZEOF ln)
    nm:=New(SIZEOF menunode)
    nnode.succ:=0
    nnode.name:=String(EstrLen(' '))
    StrCopy(nnode.name,' ',ALL)
    CopyMem(nnode,nm.node,SIZEOF ln)
    AddTail(curwin.adrmenulist,nm.node)
    nn:=p_GetNumNode(curwin.adrmenulist,nm.node)
    IF nn=0
        clist:=curwin.adrmenulist
        clist.head:=nm.node
        nnode.pred:=0
    ENDIF
    nm.type:=mynm.type
    nm.text:=String(StrLen(mymenu.title))
    StrCopy(nm.text,mymenu.title,ALL)
    nm.comkey:=String(StrLen(mymenu.shortcut))
    StrCopy(nm.comkey,mymenu.shortcut,ALL)
    nm.flags:=mynm.flags
    nm.mutualexclude:=mynm.mutualexclude
    IF nnode THEN Dispose(nnode)
ENDPROC
PROC g_ReadBboxData(mybbox:PTR TO bboxdata) /*"g_ReadBboxData(mybbox:PTR TO bboxdata)"*/
    DEF curwin:PTR TO windownode
    DEF node:PTR TO ln
    DEF b:PTR TO bboxnode
    DEF nn
    DEF clist:PTR TO lh
    curwin:=myguibase.currentwindow
    node:=New(SIZEOF ln)
    b:=New(SIZEOF bboxnode)
    node.succ:=0
    node.name:=String(EstrLen(' '))
    StrCopy(node.name,' ',ALL)
    CopyMem(node,b.node,SIZEOF ln)
    AddTail(curwin.adrbboxlist,b.node)
    nn:=p_GetNumNode(curwin.adrbboxlist,b.node)
    IF nn=0
        clist:=curwin.adrbboxlist
        clist.head:=b.node
        node.pred:=0
    ENDIF
    b.left:=mybbox.left
    b.top:=mybbox.top
    b.width:=mybbox.width
    b.height:=mybbox.height
    b.flags:=mybbox.flags
    IF node THEN Dispose(node)
    /*
    WriteF('Left :\d Top:\d Width:\d Height:\d Flags:\d\n',
            mybbox.left,mybbox.top,mybbox.width,mybbox.height,mybbox.flags)
    */
ENDPROC
PROC g_ReadGadgetData(mygad:PTR TO gadgetdata) /*"g_ReadGadgetData(mygad:PTR TO gadgetdata)"*/
    DEF mynewgad:PTR TO newgadget
    DEF nnode:PTR TO ln
    DEF ngad:PTR TO gadgetnode
    DEF clist:PTR TO lh
    DEF curwin:PTR TO windownode
    DEF nn
    DEF pv[50]:STRING
    mynewgad:=mygad
    curwin:=myguibase.currentwindow
    nnode:=New(SIZEOF ln)
    ngad:=New(SIZEOF gadgetnode)
    nnode.succ:=0
    StringF(pv,'\s',mygad.gadgetlabel)
    LowerStr(pv)
    nnode.name:=String(StrLen(pv))
    StrCopy(nnode.name,pv,ALL)
    CopyMem(nnode,ngad.node,SIZEOF ln)
    AddTail(curwin.adrgadgetlist,ngad.node)
    nn:=p_GetNumNode(curwin.adrgadgetlist,ngad.node)
    IF nn=0
        clist:=curwin.adrgadgetlist
        clist.head:=ngad.node
        nnode.pred:=0
    ENDIF
    ngad.kind:=mygad.kind
    ngad.leftedge:=mynewgad.leftedge
    ngad.topedge:=mynewgad.topedge
    ngad.width:=mynewgad.width
    ngad.height:=mynewgad.height
    ngad.gadgettext:=String(StrLen(mygad.gadgettext))
    StrCopy(ngad.gadgettext,mygad.gadgettext,ALL)
    ngad.flags:=mynewgad.flags
    IF nnode THEN Dispose(nnode)
    /*
    WriteF('PROC p_Init\sWindow() HANDLE /*"p_Init\sWindow()"*/\n',currentname,currentname)
    WriteF('    IF (\s_glist:=CreateContext({\s_glist}))=NIL THEN Raise(ER_CONTEXT)\n')
    WriteF('LeftEdge:\d TopEdge:\d Width:\d Height:\d\n',
            mynewgad.leftedge,mynewgad.topedge,mynewgad.width,mynewgad.height)
    WriteF('Text:\s Label:\s Flags:\d Kind:\d Numtag:\d\n',
            mygad.gadgettext,mygad.gadgetlabel,mygad.flags,mygad.kind,mygad.numtags)
    tagitemlist:=mygad+SIZEOF gadgetdata
    FOR b:=0 TO mygad.numtags-1
        WriteF('Tag:\d \h[8] Data:\d \h[8]\n',tagitemlist.tag,tagitemlist.data)
        tagitemlist:=tagitemlist+SIZEOF tagitem
    ENDFOR
    */
ENDPROC
PROC g_ReadWindowData(mywin:PTR TO windowdata) /*"g_ReadWindowData(mywin:PTR TO windowdata)"*/
    DEF taglist:PTR TO tagitem
    DEF b,currenttag
    DEF nnode:PTR TO ln
    DEF nwin:PTR TO windownode
    DEF nn
    DEF clist:PTR TO lh
    DEF pv[50]:STRING
    nnode:=New(SIZEOF ln)
    nwin:=New(SIZEOF windownode)
    nnode.succ:=0
    StringF(pv,'\s',mywin.name)
    LowerStr(pv)
    nnode.name:=String(StrLen(pv))
    StrCopy(nnode.name,pv,ALL)
    CopyMem(nnode,nwin.node,SIZEOF ln)
    AddTail(myguibase.adrlistwindow,nwin.node)
    myguibase.currentwindow:=nwin
    nn:=p_GetNumNode(myguibase.adrlistwindow,nwin.node)
    IF nn=0
        clist:=myguibase.adrlistwindow
        clist.head:=nwin.node
        nnode.pred:=0
    ENDIF
    StringF(currentname,'\s',mywin.name)
    taglist:=mywin+SIZEOF windowdata
    FOR b:=0 TO mywin.numtags-1
        currenttag:=taglist.tag
        SELECT currenttag
            CASE WA_LEFT;    nwin.left:=taglist.data
            CASE WA_TOP;     nwin.top:=taglist.data
            CASE WA_WIDTH;   nwin.width:=taglist.data
            CASE WA_HEIGHT;  nwin.height:=taglist.data
            CASE WA_IDCMP;   nwin.idcmp:=mywin.idcmp
            CASE WA_FLAGS;   nwin.flags:=mywin.windowflags
        ENDSELECT
        taglist:=taglist+SIZEOF tagitem
    ENDFOR
    nwin.adrgadgetlist:=p_InitList()
    IF nwin.adrgadgetlist=NIL THEN g_Crash()
    nwin.adrmenulist:=p_InitList()
    IF nwin.adrmenulist=NIL THEN g_Crash()
    nwin.adrbboxlist:=p_InitList()
    IF nwin.adrbboxlist=NIL THEN g_Crash()
    nwin.title:=String(StrLen(mywin.title))
    StrCopy(nwin.title,mywin.title,ALL)
    nwin.screen:=String(StrLen(mywin.screentitle))
    StrCopy(nwin.screen,mywin.screentitle,ALL)
    IF nnode THEN Dispose(nnode)
ENDPROC
PROC g_ReadItextData(myit:PTR TO itextdata) /*"g_ReadItextData(myit:PTR TO itextdata)"*/
    DEF it:PTR TO intuitext
    it:=myit
    WriteF('Fp:\d Bp:\d Dm:\d LeftEdge:\d TopEdge:\d ',
            it.frontpen,it.backpen,it.drawmode,it.leftedge,it.topedge)
    WriteF('Text:\s\n',myit.text)
ENDPROC
/******************************************/
/* INIT APP                               */
/******************************************/
PROC g_InitGUIBase() /*"g_InitGUIBase()"*/
    myguibase:=New(SIZEOF guibase)
    myguibase.adrlistwindow:=p_InitList()
    myguibase.adrlistdef:=p_InitList()
    myguibase.currentwindow:=0
    myguibase.currentgadget:=0
ENDPROC
PROC g_RemGUIBase() /*"g_RemGUIBase()"*/
    IF myguibase
        IF myguibase.adrlistdef THEN p_RemoveList(myguibase.adrlistdef)
        IF myguibase.adrlistwindow THEN g_CleanWindowList(myguibase.adrlistwindow)
        Dispose(myguibase)
    ENDIF
ENDPROC
/*******************************************/
/* CLEANUP                                 */
/*******************************************/
PROC g_CleanWindowList(list:PTR TO lh) /*"g_CleanWindowList(list:PTR TO lh)"*/
    DEF wnode:PTR TO windownode
    DEF node:PTR TO ln
    wnode:=list.head
    WHILE wnode
        node:=wnode
        IF node.succ<>0
            IF wnode.adrgadgetlist THEN g_CleanGadgetList(wnode.adrgadgetlist)
            IF wnode.adrmenulist THEN g_CleanMenuList(wnode.adrmenulist)
            IF wnode.adrbboxlist THEN g_CleanBboxList(wnode.adrbboxlist)
            IF wnode.title THEN Dispose(wnode.title)
            IF wnode.screen THEN Dispose(wnode.screen)
            IF node.name THEN Dispose(node.name)
            IF wnode THEN Dispose(wnode)
        ENDIF
        IF node.succ=0 THEN RemTail(list)
        IF node.pred=0 THEN RemHead(list)
        IF (node.succ<>0) AND (node.pred<>0) THEN Remove(node)
        wnode:=node.succ
    ENDWHILE
ENDPROC
PROC g_CleanGadgetList(list:PTR TO lh) /*"g_CleanGadgetList(list:PTR TO lh)"*/
    DEF gnode:PTR TO gadgetnode
    DEF node:PTR TO ln
    gnode:=list.head
    WHILE gnode
        node:=gnode
        IF node.succ<>0
            IF gnode.gadgettext THEN Dispose(gnode.gadgettext)
            IF node.name THEN Dispose(node.name)
            IF gnode THEN Dispose(gnode)
        ENDIF
        IF node.succ=0 THEN RemTail(list)
        IF node.pred=0 THEN RemHead(list)
        IF (node.succ<>0) AND (node.pred<>0) THEN Remove(node)
        gnode:=node.succ
    ENDWHILE
ENDPROC
PROC g_CleanBboxList(list:PTR TO lh) /*"g_CleanBboxList(list:PTR TO lh)"*/
    DEF bnode:PTR TO bboxnode
    DEF node:PTR TO ln
    bnode:=list.head
    WHILE bnode
        node:=bnode
        IF node.succ<>0
            IF bnode THEN Dispose(bnode)
        ENDIF
        IF node.succ=0 THEN RemTail(list)
        IF node.pred=0 THEN RemHead(list)
        IF (node.succ<>0) AND (node.pred<>0) THEN Remove(node)
        bnode:=node.succ
    ENDWHILE
ENDPROC
PROC g_CleanMenuList(list:PTR TO lh) /*"g_CleanMenuList(list:PTR TO lh)"*/
    DEF mnode:PTR TO menunode
    DEF node:PTR TO ln
    mnode:=list.head
    WHILE mnode
        node:=mnode
        IF node.succ<>0
            IF node.name THEN Dispose(node.name)
            IF mnode.text THEN Dispose(mnode.text)
            IF mnode.comkey THEN Dispose(mnode.comkey)
            IF mnode THEN Dispose(mnode)
        ENDIF
        IF node.succ=0 THEN RemTail(list)
        IF node.pred=0 THEN RemHead(list)
        IF (node.succ<>0) AND (node.pred<>0) THEN Remove(node)
        mnode:=node.succ
    ENDWHILE
ENDPROC
/****************************************/
/* GENERATE                             */
/****************************************/
PROC g_WriteFHeader() /*"g_WriteFHeader()"*/
    WriteF('/*******************************************************************************************/\n')
    WriteF('/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */\n')
    WriteF('/*******************************************************************************************/\n')
    WriteF('/********************************************************************************\n')
    WriteF(' * << EUTILS HEADER >>\n')
    WriteF(' ********************************************************************************\n')
    WriteF('   ED\n')
    WriteF('   EC\n')
    WriteF('   PREPRO\n')
    WriteF('   SOURCE\n')
    WriteF('   EPPDEST\n')
    WriteF('   EXEC\n')
    WriteF('   ISOURCE\n')
    WriteF('   HSOURCE\n')
    WriteF('   ERROREC\n')
    WriteF('   ERROREPP\n')
    WriteF('   VERSION\n')
    WriteF('   REVISION\n')
    WriteF('   NAMEPRG\n')
    WriteF('   NAMEAUTHOR\n')
    WriteF(' ********************************************************************************\n')
    WriteF(' * HISTORY :\n')
    WriteF(' *******************************************************************************/\n')
    WriteF('\n')
    WriteF('OPT OSVERSION=37\n')
    WriteF('\n')
    WriteF('MODULE \aintuition/intuition\a,\agadtools\a,\alibraries/gadtools\a,\aintuition/gadgetclass\a,\aintuition/screens\a,\n')
    WriteF('       \agraphics/text\a,\aexec/lists\a,\aexec/nodes\a,\aexec/ports\a,\aeropenlib\a,\autility/tagitem\a\n')
    WriteF('\n')
    WriteF('ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW\n')
    WriteF('\n')
    WriteF('DEF screen:PTR TO screen,\n')
    WriteF('    visual=NIL,\n')
    WriteF('    tattr:PTR TO textattr,\n')
    WriteF('    reelquit=FALSE\n')
ENDPROC
PROC g_WriteFDef(list:PTR TO lh) /*"g_WriteFDef(list:PTR TO lh)"*/
    /* window */
    DEF w:PTR TO windownode
    DEF wnode:PTR TO ln
    /* gadget */
    DEF g:PTR TO gadgetnode
    DEF gnode:PTR TO ln
    DEF plist:PTR TO lh
    DEF c=0
    DEF pv[80]:STRING
    w:=list.head
    WHILE w
        wnode:=w
        IF wnode.succ<>0
            myguibase.currentwindow:=w
            WriteF('/****************************************\n')
            WriteF(' * \s Definitions\n',wnode.name)
            WriteF(' ****************************************/\n')
            WriteF('DEF \s_window=NIL:PTR TO window\n',wnode.name)
            WriteF('DEF \s_glist=NIL\n',wnode.name)
            IF p_EmptyList(w.adrmenulist)<>-1 THEN WriteF('DEF \s_menu=NIL\n',wnode.name)
            IF p_EmptyList(w.adrgadgetlist)<>-1
                plist:=w.adrgadgetlist
                g:=plist.head
                WriteF('/* Gadgets */\n')
                WHILE g
                    gnode:=g
                    IF gnode.succ<>0
                        StrCopy(pv,gnode.name,ALL)
                        UpperStr(pv)
                        WriteF('CONST GA_\s=\d\n',pv,c)
                        INC c
                    ENDIF
                    g:=gnode.succ
                ENDWHILE
                WriteF('/* Gadgets labels of \s */\n',wnode.name)
                g:=plist.head
                WHILE g
                    gnode:=g
                    IF gnode.succ<>0
                        WriteF('DEF \s\n',gnode.name)
                    ENDIF
                    g:=gnode.succ
                ENDWHILE
            ENDIF
        ENDIF
        w:=wnode.succ
    ENDWHILE
ENDPROC
PROC g_WriteFLookMessage(list:PTR TO lh) /*"g_WriteFLookMessgage(list:PTR TO lh)"*/
    /* window */
    DEF w:PTR TO windownode
    DEF wnode:PTR TO ln
    DEF c=0
    DEF pv[80]:STRING
    /* PROC p_LookAllMessage() */
    WriteF('PROC p_LookAllMessage() /*"p_LookAllMessage()"*/\n')
    WriteF('    DEF sigreturn\n')
    w:=list.head
    WHILE w
        wnode:=w
        IF wnode.succ<>0
            WriteF('    DEF \sport:PTR TO mp\n',wnode.name)
        ENDIF
        w:=wnode.succ
    ENDWHILE
    w:=list.head
    WHILE w
        wnode:=w
        IF wnode.succ<>0
            WriteF('    IF \s_window THEN \sport:=\s_window.userport ELSE \sport:=NIL\n',
                    wnode.name,wnode.name,wnode.name,wnode.name)
        ENDIF
        w:=wnode.succ
    ENDWHILE
    WriteF('    sigreturn:=Wait(')
    w:=list.head
    WHILE w
        wnode:=w
        IF wnode.succ<>0
            IF wnode.pred=0
                WriteF('Shl(1,\sport.sigbit) OR\n',wnode.name)
            ELSE
                WriteF('                    Shl(1,\sport.sigbit) OR\n',wnode.name)
            ENDIF
        ENDIF
        w:=wnode.succ
    ENDWHILE
    WriteF('                    $F000)\n')
    w:=list.head
    WHILE w
        wnode:=w
        IF wnode.succ<>0
                WriteF('    IF (sigreturn AND Shl(1,\sport.sigbit))\n',wnode.name)
                WriteF('        p_Look\sMessage()\n',wnode.name)
                WriteF('    ENDIF\n')
        ENDIF
        w:=wnode.succ
    ENDWHILE
    WriteF('    IF (sigreturn AND $F000)\n',wnode.name)
    WriteF('        reelquit:=TRUE\n')
    WriteF('    ENDIF\n')
    WriteF('ENDPROC\n')
ENDPROC
PROC g_WriteFMain(list:PTR TO lh) /*"g_WriteFMain()"*/
    /* window */
    DEF w:PTR TO windownode
    DEF wnode:PTR TO ln
    DEF c=0
    DEF pv[80]:STRING
    /* PROC p_LookAllMessage() */
    WriteF('PROC main() HANDLE /*"main()"*/\n')
    WriteF('    DEF testmain\n')
    WriteF('    tattr:=[\atopaz.font\a,8,0,0]:textattr\n')
    WriteF('    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)\n')
    WriteF('    IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)\n')
    w:=list.head
    WHILE w
        wnode:=w
        IF wnode.succ<>0
            WriteF('    IF (testmain:=p_Init\sWindow())<>ER_NONE THEN Raise(testmain)\n',wnode.name)
        ENDIF
        w:=wnode.succ
    ENDWHILE
    w:=list.head
    WHILE w
        wnode:=w
        IF wnode.succ<>0
            IF wnode.pred=0 THEN WriteF('    IF (testmain:=p_Open\sWindow())<>ER_NONE THEN Raise(testmain)\n',wnode.name)
        ENDIF
        w:=wnode.succ
    ENDWHILE
    WriteF('    REPEAT\n')
    WriteF('        p_LookAllMessage()\n')
    WriteF('    UNTIL reelquit=TRUE\n')
    WriteF('    Raise(ER_NONE)\n')
    WriteF('EXCEPT\n')
    w:=list.head
    WHILE w
        wnode:=w
        IF wnode.succ<>0
            WriteF('    p_Rem\sWindow()\n',wnode.name)
        ENDIF
        w:=wnode.succ
    ENDWHILE
    WriteF('    p_SetDownScreen()\n')
    WriteF('    p_CloseLibraries()\n')
    WriteF('    SELECT exception\n')
    WriteF('        CASE ER_LOCKSCREEN; WriteF(\aLock Screen Failed.\a)\n')
    WriteF('        CASE ER_VISUAL;     WriteF(\aError Visual.\a)\n')
    WriteF('        CASE ER_CONTEXT;    WriteF(\aError Context.\a)\n')
    WriteF('        CASE ER_MENUS;      WriteF(\aError Menus.\a)\n')
    WriteF('        CASE ER_GADGET;     WriteF(\aError Gadget.\a)\n')
    WriteF('        CASE ER_WINDOW;     WriteF(\aError Window.\a)\n')
    WriteF('    ENDSELECT\n')
    WriteF('ENDPROC\n')
ENDPROC
PROC g_WriteFOpenCloseLib() /*"g_WriteFOpenCloseLib()"*/
    WriteF('PROC p_OpenLibraries() HANDLE /*"p_OpenLibraries()"*/\n')
    WriteF('    IF (intuitionbase:=OpenLibrary(\aintuition.library\a,37))=NIL THEN Raise(ER_INTUITIONLIB)\n')
    WriteF('    IF (gadtoolsbase:=OpenLibrary(\agadtools.library\a,37))=NIL THEN Raise(ER_GADTOOLSLIB)\n')
    WriteF('    IF (gfxbase:=OpenLibrary(\agraphics.library\a,37))=NIL THEN Raise(ER_GRAPHICSLIB)\n')
    WriteF('    Raise(ER_NONE)\n')
    WriteF('EXCEPT\n')
    WriteF('    RETURN exception\n')
    WriteF('ENDPROC\n')
    WriteF('PROC p_CloseLibraries()  /*"p_CloseLibraries()"*/\n')
    WriteF('    IF gfxbase THEN CloseLibrary(gfxbase)\n')
    WriteF('    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)\n')
    WriteF('    IF intuitionbase THEN CloseLibrary(intuitionbase)\n')
    WriteF('ENDPROC\n')
ENDPROC
PROC g_WriteFScreen() /*"g_WriteFScreen()"*/
    WriteF('PROC p_SetUpScreen() HANDLE /*"p_SetUpScreen()"*/\n')
    WriteF('    IF (screen:=LockPubScreen(\aWorkbench\a))=NIL THEN Raise(ER_LOCKSCREEN)\n')
    WriteF('    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)\n')
    WriteF('    Raise(ER_NONE)\n')
    WriteF('EXCEPT\n')
    WriteF('    RETURN exception\n')
    WriteF('ENDPROC\n')
    WriteF('PROC p_SetDownScreen() /*"p_SetDownScreen()"*/\n')
    WriteF('    IF visual THEN FreeVisualInfo(visual)\n')
    WriteF('    IF screen THEN UnlockPubScreen(NIL,screen)\n')
    WriteF('ENDPROC\n')
ENDPROC
PROC g_WriteFWinMessage(list:PTR TO lh) /*"g_WriteFWinMessage(list:PTR TO lh)"*/
    /* window */
    DEF w:PTR TO windownode
    DEF wnode:PTR TO ln
    /* gadget */
    DEF g:PTR TO gadgetnode
    DEF gnode:PTR TO ln
    DEF plist:PTR TO lh
    DEF c=0
    DEF pv[80]:STRING
    w:=list.head
    WHILE w
        wnode:=w
        IF wnode.succ<>0
            myguibase.currentwindow:=w
            WriteF('PROC p_Look\sMessage() /*"p_Look\sMessage()"*/\n',wnode.name,wnode.name)
            WriteF('   DEF mes:PTR TO intuimessage\n')
            WriteF('   DEF g:PTR TO gadget\n')
            WriteF('   DEF gstr:PTR TO stringinfo\n')
            WriteF('   DEF type=0,infos=NIL\n')
            WriteF('   IF mes:=Gt_GetIMsg(\s_window.userport)\n')
            WriteF('       type:=mes.class\n')
            WriteF('       SELECT type\n')
            WriteF('           CASE IDCMP_MENUPICK\n')
            WriteF('              infos:=mes.code\n')
            WriteF('              SELECT infos\n')
            WriteF('              ENDSELECT\n')
            WriteF('           CASE (IDCMP_GADGETDOWN OR IDCMP_GADGETUP)\n')
            WriteF('              g:=mes.iaddress\n')
            WriteF('              infos:=g.gadgetid\n')
            WriteF('              SELECT infos\n')
            IF p_EmptyList(w.adrgadgetlist)<>-1
                plist:=w.adrgadgetlist
                g:=plist.head
                WHILE g
                    gnode:=g
                    IF gnode.succ<>0
                        StrCopy(pv,gnode.name,ALL)
                        UpperStr(pv)
                        WriteF('                  CASE GA_\s\n',pv)
                        INC c
                    ENDIF
                    g:=gnode.succ
                ENDWHILE
            ENDIF
            WriteF('              ENDSELECT\n')
            WriteF('       ENDSELECT\n')
            WriteF('       Gt_ReplyIMsg(mes)\n')
            WriteF('   ENDIF\n')
            WriteF('ENDPROC\n')
        ENDIF
        w:=wnode.succ
    ENDWHILE
ENDPROC
PROC g_WriteFWindowList(list:PTR TO lh) /*"g_WriteFWindowList(list:PTR TO lh)"*/
    DEF w:PTR TO windownode
    DEF node:PTR TO ln
    w:=list.head
    WHILE w
        node:=w
        IF node.succ<>0
            myguibase.currentwindow:=w
            IF w.adrgadgetlist THEN g_GenerateInitWindow(w)
            WriteF('PROC p_Open\sWindow() HANDLE /*"p_Open\sWindow()"*/\n',node.name,node.name)
            WriteF('    IF (\s_window:=OpenWindowTagList(NIL,\n')
            WriteF('                      [WA_LEFT,\d,\n',w.left)
            WriteF('                       WA_TOP,\d,\n',w.top)
            WriteF('                       WA_WIDTH,\d,\n',w.width)
            WriteF('                       WA_HEIGHT,\d,\n',w.height)
            WriteF('                       WA_IDCMP,$\h,\n',w.idcmp)
            WriteF('                       WA_FLAGS,$\h,\n',w.flags)
            WriteF('                       WA_GADGETS,\s_glist,\n',node.name)
            WriteF('                       WA_TITLE,\a\s\a,\n',w.title)
            WriteF('                       WA_SCREENTITLE,\a\s\a,\n',w.screen)
            WriteF('                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)\n')
            IF p_EmptyList(w.adrmenulist)<>-1
                WriteF('    IF SetMenuStrip(\s_window,\s_menu)=FALSE THEN Raise(ER_MENUS)\n',node.name,node.name)
                WriteF('    Gt_RefreshWindow(\s_window,NIL)\n',node.name)
            ENDIF
            IF p_EmptyList(w.adrbboxlist)<>-1 THEN WriteF('    p_Render\sWindow()\n',node.name)
            WriteF('    Raise(ER_NONE)\n')
            WriteF('EXCEPT\n')
            WriteF('    RETURN exception\n')
            WriteF('ENDPROC\n')
            WriteF('PROC p_Rem\sWindow() /*"p_Rem\sWindow()"*/\n',node.name,node.name)
            WriteF('    IF \s_window THEN CloseWindow(\s_window)\n',node.name,node.name)
            IF p_EmptyList(w.adrmenulist)<>-1
                WriteF('    IF \s_menu THEN FreeMenus(\s_menu)\n',node.name,node.name)
            ENDIF
            WriteF('    IF \s_glist THEN FreeGadgets(\s_glist)\n',node.name,node.name)
            WriteF('ENDPROC\n')
        ENDIF
        w:=node.succ
    ENDWHILE
ENDPROC
PROC g_WriteFGadgetList(list:PTR TO lh,glist) /*"g_WriteFGadgetList(list:PTR TO lh,glist)"*/
    DEF gnode:PTR TO gadgetnode
    DEF node:PTR TO ln,count=0
    DEF last_gad[256]:STRING
    gnode:=list.head
    WHILE gnode
        node:=gnode
        IF node.succ<>0
            IF node.pred=0
                WriteF('    IF (\s:=CreateGadgetA(\s,\s_glist,[\d,\d,\d,\d,\a\s\a,tattr,\d,\d,visual,0]:newgadget,\s))=NIL THEN Raise(ER_GADGET)\n',
                                 node.name,string_kind[gnode.kind],glist,gnode.leftedge,gnode.topedge,
                                 gnode.width,gnode.height,gnode.gadgettext,count,gnode.flags,g_FoundTag(gnode.kind))
                StringF(last_gad,'\s',node.name)
            ELSE
                WriteF('    IF (\s:=CreateGadgetA(\s,\s,[\d,\d,\d,\d,\a\s\a,tattr,\d,\d,visual,0]:newgadget,\s))=NIL THEN Raise(ER_GADGET)\n',
                                 node.name,string_kind[gnode.kind],last_gad,gnode.leftedge,gnode.topedge,
                                 gnode.width,gnode.height,gnode.gadgettext,count,gnode.flags,g_FoundTag(gnode.kind))
                StringF(last_gad,'\s',node.name)
            ENDIF
        ENDIF
        INC count
        gnode:=node.succ
    ENDWHILE
ENDPROC
PROC g_WriteFMenuList(list:PTR TO lh,nom) /*"g_WriteFMenuList(list:PTR TO lh,nom)"*/
    DEF mnode:PTR TO menunode
    DEF node:PTR TO ln
    mnode:=list.head
    WHILE mnode
        node:=mnode
        IF node.succ<>0
            IF node.pred=0
                WriteF('    IF (\s_menu:=CreateMenusA([',nom)
                WriteF('\d,\d,\a\s\a,',mnode.type,0,mnode.text)
                IF (mnode.type<>1) AND mnode.comkey
                    WriteF('\a\s\a,',mnode.comkey)
                ELSE
                    WriteF('0,')
                ENDIF
                WriteF('\d,\d,0,\n',mnode.flags,mnode.mutualexclude)
            ELSE
                WriteF('                                  \d,\d,\a\s\a,',mnode.type,0,mnode.text)
                IF (mnode.type<>1) AND mnode.comkey
                    WriteF('\a\s\a,',mnode.comkey)
                ELSE
                    WriteF('0,')
                ENDIF
                WriteF('\d,\d,0,\n',mnode.flags,mnode.mutualexclude)
            ENDIF
        ENDIF
        mnode:=node.succ
    ENDWHILE
    WriteF('                                   0,0,0,0,0,0,0]:newmenu,NIL))=NIL THEN Raise(ER_MENUS)\n')
    WriteF('    IF LayoutMenusA(\s_menu,visual,NIL)=FALSE THEN Raise(ER_MENUS)\n',nom)
ENDPROC
PROC g_WriteFBboxList(list:PTR TO lh,nom) /*"g_WriteBboxList(list:PTR TO lh,nom)"*/
    DEF bnode:PTR TO bboxnode
    DEF node:PTR TO ln
    DEF gn:PTR TO ln
    DEF curwin:PTR TO windownode
    curwin:=myguibase.currentwindow
    gn:=p_GetAdrNode(curwin.adrgadgetlist,0)
    bnode:=list.head
    WriteF('PROC p_Render\sWindow() /*"p_Render\sWindow()"*/\n',nom,nom)
    WHILE bnode
        node:=bnode
        IF node.succ<>0
            WriteF('    DrawBevelBoxA(\s_window.rport,\d,\d,\d,\d,[GTBB_RECESSED,\d,GT_VISUALINFO,visual,TAG_DONE,0])\n',
                        nom,bnode.left,bnode.top,bnode.width,bnode.height,bnode.flags)
        ENDIF
        bnode:=node.succ
    ENDWHILE
    WriteF('    RefreshGList(\s,\s_window,NIL,-1)\n',gn.name,nom)
    WriteF('    Gt_RefreshWindow(\s_window,NIL)\n',nom)
    WriteF('ENDPROC\n')
ENDPROC
PROC g_GenerateInitWindow(w:PTR TO windownode) /*"g_GenerateInitWindow(w:PTR TO windownode)"*/
    DEF node:PTR TO ln
    node:=w
    WriteF('PROC p_Init\sWindow() HANDLE /*"p_Init\sWindow()"*/\n',node.name,node.name)
    WriteF('    IF (\s_glist:=CreateContext({\s_glist}))=NIL THEN Raise(ER_CONTEXT)\n')
    IF p_EmptyList(w.adrmenulist)<>-1 THEN g_WriteFMenuList(w.adrmenulist,node.name)
    IF p_EmptyList(w.adrgadgetlist)<>-1 THEN g_WriteFGadgetList(w.adrgadgetlist,node.name)
    WriteF('    Raise(ER_NONE)\n')
    WriteF('EXCEPT\n')
    WriteF('    RETURN exception\n')
    WriteF('ENDPROC\n')
    IF p_EmptyList(w.adrbboxlist)<>-1 THEN g_WriteFBboxList(w.adrbboxlist,node.name)
ENDPROC
PROC g_FoundTag(f_tag) /*"g_FoundTag(f_tag)"*/
    SELECT f_tag
        CASE 0
        /* BUTTON_KIND */
        CASE 1; RETURN '[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]'
        /* CHEKBOX_KIND */
        CASE 2; RETURN '[GA_RELVERIFY,TRUE,GTCB_CHECKED,FALSE,GT_UNDERSCORE,"_", TAG_DONE,0]'
        /* INTEGER_KIND */
        CASE 3; RETURN '[GA_RELVERIFY,TRUE,GTIN_NUMBER,666,GTIN_MAXCHARS,8,GT_UNDERSCORE,"_",TAG_DONE,0]'
        /* LISTVIEW_KIND */
        CASE 4; RETURN '[GA_RELVERIFY,TRUE,GTLV_LABELS,-1,GT_UNDERSCORE,"_",TAG_DONE,0]'
        /* MX_KIND */
        CASE 5; RETURN '[GA_RELVERIFY,TRUE,GTMX_LABELS,[\a\a,\a\a,0],GT_UNDERSCORE,"_",TAG_DONE,0]'
        /* NUMBER_KIND */
        CASE 6; RETURN '[GA_RELVERIFY,TRUE,GT_UNDERSCORE,"_",TAG_DONE,0]'
        /* CYCLE_KIND */
        CASE 7; RETURN '[GA_RELVERIFY,TRUE,GTCY_LABELS,[\a\a,\a\a,0],GT_UNDERSCORE,"_",TAG_DONE,0]'
        /* PALETTE_KIND */
        CASE 8; RETURN '[GTPA_DEPTH,2,GTPA_COLOR,1,GTPA_INDICATORWIDTH,TRUE,GTPA_INDICATORHEIGHT,TRUE,GT_UNDERSCORE,"_",TAG_DONE,0]'
        /* SCROLLER_KIND */
        CASE 9; RETURN '[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]'
        /* SLIDER_KIND */
        CASE 11; RETURN '[GTSL_MIN,0,GTSL_MAX,10,GT_UNDERSCORE,"_",TAG_DONE,0]'
        /* STRING_KIND */
        CASE 12; RETURN '[GTST_STRING,\a\a,GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]'
        /* TEXT_KIND */
        CASE 13; RETURN '[GTTX_TEXT,\a\a,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]'
    ENDSELECT
ENDPROC
PROC g_Crash() /*"g_Crash()"*/
    g_RemGUIBase()
    CleanUp(20)
ENDPROC
PROC main() HANDLE /*"main()"*/
    string_kind:=['GENERIC_KIND',
                  'BUTTON_KIND',
                  'CHECKBOX_KIND',
                  'INTEGER_KIND',
                  'LISTVIEW_KIND',
                  'MX_KIND',
                  'NUMBER_KIND',
                  'CYCLE_KIND',
                  'PALETTE_KIND',
                  '',
                  'SCROLLER_KIND',
                  'SLIDER_KIND',
                  'STRING_KIND',
                  'TEXT_KIND']
    g_InitGUIBase()
    g_ReadGUIFile(arg)
    /*
    g_WriteFHeader()
    g_WriteFDef(myguibase.adrlistwindow)
    g_WriteFOpenCloseLib()
    g_WriteFScreen()
    g_WriteFWindowList(myguibase.adrlistwindow)
    g_WriteFLookMessage(myguibase.adrlistwindow)
    g_WriteFWinMessage(myguibase.adrlistwindow)
    g_WriteFMain(myguibase.adrlistwindow)
    */
    Raise(ER_NONE)
EXCEPT
    g_RemGUIBase()
ENDPROC

