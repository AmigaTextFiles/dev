PROC p_dWriteFList(ptr_list) /*"p_dWriteFList(ptr_list)"*/
/********************************************************************************
 * Para         : address of list
 * Return       : NONE
 * Description  : Write the list and node in stdout.
 *******************************************************************************/
    DEF w_list:PTR TO lh
    DEF w_node:PTR TO ln
    IF DEBUG=TRUE
        w_list:=ptr_list
        w_node:=w_list.head
        WriteF('Adr List:\h[8] Head:\h[8] TailPred:\h[8]\n',w_list,w_list.head,w_list.tailpred)
        WHILE w_node
            IF w_node.succ<>0
                WriteF('Adr:\h[8] Succ:\h[8] Pred:\h[8] Name:\s\n',w_node,w_node.succ,w_node.pred,w_node.name)
            ENDIF
            w_node:=w_node.succ
        ENDWHILE
    ENDIF
ENDPROC
PROC tm_CleanAppIconList(list:PTR TO lh,mode) /*"tm_CleanAppIconList(list:PTR TO lh,mode)"*/
    DEF node:PTR TO ln
    DEF mappic:PTR TO appiconnode
    mappic:=list.head
    WHILE mappic
        node:=mappic
        IF node.succ
            IF mappic.command THEN Dispose(mappic.command)
            IF mappic.currentdir THEN Dispose(mappic.currentdir)
            IF mappic.hotkey THEN Dispose(mappic.hotkey)
            IF mappic.output THEN Dispose(mappic.output)
            IF mappic.path THEN Dispose(mappic.path)
            IF mappic.pubscreen THEN Dispose(mappic.pubscreen)
            IF mappic.file THEN Dispose(mappic.file)
            IF mappic THEN Dispose(mappic)
        ENDIF
        IF node.succ=0 THEN RemTail(list)
        IF node.pred=0 THEN RemHead(list)
        IF (node.succ<>0) AND (node.pred<>0) THEN Remove(node)
        IF node.name THEN DisposeLink(TrimStr(node.name))
        mappic:=node.succ
    ENDWHILE
    list.tail:=0
    list.head:=list.tail
    list.tailpred:=list.head
    list.type:=0
    list.pad:=0
    dWriteF(['tm_CleanAppIconList() \h[8]',' \d\n'],[list,mode])
    IF mode=LIST_REMOVE
        IF list THEN Dispose(list)
    ELSEIF mode=LIST_CLEAN
        RETURN list
    ENDIF
ENDPROC
PROC tm_RemAppIconNode(list:PTR TO lh,numnode) /*"tm_RemAppIconNode(list:PTR TO lh,numnode)"*/
    DEF node:PTR TO ln
    DEF mappic:PTR TO appiconnode,count=0,retour
    DEF newnode:PTR TO ln
    DEF test
    dWriteF(['tm_RemAppIconNode()\n'],0)
    mappic:=list.head
    WHILE mappic
        node:=mappic
        IF node.succ
        IF count=numnode
            IF mappic.command THEN DisposeLink(TrimStr(mappic.command))
            IF mappic.currentdir THEN DisposeLink(TrimStr(mappic.currentdir))
            IF mappic.hotkey THEN DisposeLink(TrimStr(mappic.hotkey))
            IF mappic.output THEN DisposeLink(TrimStr(mappic.output))
            IF mappic.path THEN DisposeLink(TrimStr(mappic.path))
            IF mappic.pubscreen THEN DisposeLink(TrimStr(mappic.pubscreen))
            IF mappic.file THEN DisposeLink(TrimStr(mappic.file))
            IF mappic THEN Dispose(mappic)
            IF node.succ=0
                test:=RemTail(list)
                dWriteF(['-> RemTail: list \h[8]',' return \h[8]\n'],[list,test])
                retour:=numnode-1
            ELSEIF node.pred=0
                test:=RemHead(list)
                retour:=numnode
                newnode:=p_GetAdrNode(list,numnode)
                dWriteF(['->RemHead \h[8]',' return \h[8] ',' newhead \h[8]\n'],[list,test,newnode])
                list.head:=newnode
                newnode.pred:=0
            ELSEIF (node.succ<>0) AND (node.pred<>0)
                test:=Remove(node)
                dWriteF(['->Remove \h[8]',' return \h[8] ',' delnode \h[8]\n'],[list,test,node])
                retour:=numnode-1
            ENDIF
            IF node.name THEN Dispose(node.name)
        ENDIF
        ENDIF
        INC count
        mappic:=node.succ
    ENDWHILE
    dWriteF(['tm_RemAppIconNode() \h[8]',' Currentnode \d\n'],[list,retour])
    RETURN retour
ENDPROC
PROC tm_AddAppIconNode(list:PTR TO lh) HANDLE /*"tm_AddAppIconNode(list:PTR TO lh)"*/
    DEF myappic:PTR TO appiconnode
    DEF node:PTR TO ln
    DEF nn
    node:=New(SIZEOF ln)
    myappic:=New(SIZEOF appiconnode)
    node.succ:=0
    node.name:=String(EstrLen('(New)'))
    StrCopy(node.name,'(New)',ALL)
    CopyMem(node,myappic.node,SIZEOF ln)
    AddTail(list_appicon,myappic.node)
    nn:=p_GetNumNode(list,myappic.node)
    IF nn=0
        list.head:=myappic.node
        node.pred:=0
    ENDIF
    myappic.exectype:=TMET_CLI
    myappic.command:=NIL
    myappic.hotkey:=NIL
    myappic.stack:=4000
    myappic.priority:=0
    myappic.delay:=0
    myappic.currentdir:=NIL
    myappic.path:=NIL
    myappic.output:=NIL
    myappic.pubscreen:=NIL
    myappic.arguments:=FALSE
    myappic.tofront:=FALSE
    myappic.file:=NIL
    myappic.posx:=0
    myappic.posy:=0
    myappic.showname:=TRUE
    IF node THEN Dispose(node)
    Raise(nn)
EXCEPT
    dWriteF(['tm_AddAppIconNode() \h[8]',' \d\n'],[list,nn])
    RETURN exception
ENDPROC
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
    dWriteF(['p_InitList() \h[8]\n'],[exception])
    RETURN exception
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

