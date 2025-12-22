/*=================================================*/
/* YOU MUST COMPILE THIS SOURCE WITH E3.0          */
/*=================================================*/
/* $VER: Plist.e 0.1 (04/04/95) © NasGûl           */
/*=================================================*/
/* See Doc for more info..                         */
/*=================================================*/

OPT MODULE


EXPORT MODULE 'exec/lists','exec/nodes','utility'


EXPORT CONST DISP=0,
             DISL=1,
             DISE=-1

EXPORT CONST LIST_CLEAN=0,
             LIST_REMOVE=1

/*"banner_version()"*/
PROC banner_version()
    VOID '$VER: Plist.m 0.1 (04/04/95) © NasGûl'
ENDPROC
/**/
/*"copyList(l_s:PTR TO lh,l_d:PTR TO lh)"*/
EXPORT PROC copyList(l_s:PTR TO lh,l_d:PTR TO lh)
    DEF s_n:PTR TO ln
    DEF str[256]:STRING
    s_n:=l_s.head
    WHILE s_n
        IF s_n.succ<>0
            StringF(str,s_n.name,ALL)
            addNode(l_d,str,0)
        ENDIF
        s_n:=s_n.succ
    ENDWHILE
ENDPROC
/**/
/*"writeFList(ptr_list:PTR TO lh)"*/
EXPORT PROC writeFList(ptr_list:PTR TO lh)
/*===============================================================================
 = Para         : Address of a list
 = Return       : NONE.
 = Description  : Write in stdout the list data and nodes.
 ==============================================================================*/
    DEF w_node:PTR TO ln
    w_node:=ptr_list.head
    WriteF('Adr List:\h[8] Head:\h[8] TailPred:\h[8]\n',ptr_list,ptr_list.head,ptr_list.tailpred)
    WHILE w_node
        IF w_node.succ<>0
            WriteF('Adr:\h[8] Succ:\h[8] Pred:\h[8] Name:\s\n',w_node,w_node.succ,w_node.pred,w_node.name)
        ENDIF
        w_node:=w_node.succ
    ENDWHILE
ENDPROC
/**/
/*"removeList(ptr_list:PTR TO lh)"*/
EXPORT PROC removeList(ptr_list:PTR TO lh)
/*===============================================================================
 = Para         : Address of a list.
 = Return       : NONE
 = Description  : p_CleanList() an Dispose() the list.
 ==============================================================================*/
    DEF r_list:PTR TO lh
    r_list:=cleanList(ptr_list,FALSE,0,0)
    IF r_list THEN Dispose(r_list)
ENDPROC
/**/
/*"initList()"*/
EXPORT PROC initList() HANDLE
/*===============================================================================
 = Para         : NONE.
 = Return       : Address of the new list if ok,else NIL.
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
/**/
/*"getNumNode(ptr_list:PTR TO lh,adr_node)"*/
EXPORT PROC getNumNode(ptr_list:PTR TO lh,adr_node)
/*===============================================================================
 = Para         : Address of a list,address of a node.
 = Return       : The number of the node,else -1.
 = Description  : Find the num of a node.
 ==============================================================================*/
    DEF g_node:PTR TO ln
    DEF count=0
    g_node:=ptr_list.head
    WHILE g_node
        IF g_node=adr_node THEN RETURN count
        INC count
        g_node:=g_node.succ
    ENDWHILE
    RETURN -1
ENDPROC
/**/
/*"getAdrNode(ptr_list:PTR TO lh,num_node)"*/
EXPORT PROC getAdrNode(ptr_list:PTR TO lh,num_node)
/*===============================================================================
 = Para         : Address of a list,number of a node.
 = Return       : Address of node or -1.
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
    RETURN -1
ENDPROC
/**/
/*"remNode(ptr_list:PTR TO lh,num_node,doit,dat:PTR TO LONG)"*/
EXPORT PROC remNode(ptr_list:PTR TO lh,num_node,doit,dat:PTR TO LONG)
/*===============================================================================
 = Para         : Address of a list,number of a node.
 = Return       : The number of the new selected node in the list.
 = Description  : Remove a node.
 ==============================================================================*/
    DEF e_node:PTR TO ln
    DEF new_e_node:PTR TO ln
    DEF count=0,retour=NIL
    DEF p=0,pivadr
    DEF rdat:PTR TO LONG
    e_node:=ptr_list.head
    rdat:=dat
    WHILE e_node
        p:=0
        rdat:=dat
        IF count=num_node
            IF doit<>0
                REPEAT
                    p:=rdat[]++
                    IF p<>DISE
                        IF ((p<>DISE) AND (p<>DISP) AND (p<>DISL))
                            pivadr:=Long(e_node+p)
                        ENDIF
                        IF (p=DISP)
                            IF pivadr THEN Dispose(pivadr)
                        ENDIF
                        IF (p=DISL)
                            IF pivadr THEN DisposeLink(pivadr)
                        ENDIF
                    ENDIF
                UNTIL (p=DISE)
                IF e_node THEN Dispose(e_node)
            ENDIF
            IF e_node.succ=0
                RemTail(ptr_list)
                retour:=num_node-1
            ELSEIF e_node.pred=0
                RemHead(ptr_list)
                retour:=num_node
                new_e_node:=getAdrNode(ptr_list,num_node)
                ptr_list.head:=new_e_node
                new_e_node.pred:=0
            ELSEIF (e_node.succ<>0) AND (e_node.pred<>0)
                Remove(e_node)
                retour:=num_node-1
            ENDIF
            IF e_node.name THEN DisposeLink(e_node.name)
        ENDIF
        INC count
        e_node:=e_node.succ
    ENDWHILE
    RETURN retour
ENDPROC
/**/
/*"emptyList(ptr_list:PTR TO lh)"*/
EXPORT PROC emptyList(ptr_list:PTR TO lh)
/*===============================================================================
 = Para         : Address of a list.
 = Return       : TRUE if list is empty,else the adress list.
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
/**/
/*"countNodes(list:PTR TO lh)"*/
EXPORT PROC countNodes(list:PTR TO lh)
/*===============================================================================
 = Para         : address of a list
 = Return       : number of nodes in the list.
 = Description  : count nodes in the list.
 ==============================================================================*/
    DEF count=0
    DEF e_node:PTR TO ln
    e_node:=list.head
    WHILE e_node
        IF e_node.succ<>0 THEN INC count
        e_node:=e_node.succ
    ENDWHILE
    RETURN count
ENDPROC
/**/
/*"cleanList(ptr_list:PTR TO lh,doit,dat:PTR TO LONG,mode)"*/
EXPORT PROC cleanList(ptr_list:PTR TO lh,doit,dat:PTR TO LONG,mode)
/*===============================================================================
 = Para         : Address of a List.
 = Return       : Address of clean list.
 = Description  : Remove all nodes in the list.
 ==============================================================================*/
    DEF c_node:PTR TO ln
    DEF p=0,pivadr
    DEF rdat:PTR TO LONG
    c_node:=ptr_list.head
    rdat:=dat
    WHILE c_node
        p:=0
        rdat:=dat
        IF c_node.succ<>0
            IF doit<>0
                REPEAT
                    p:=rdat[]++
                    IF p<>DISE
                        IF ((p<>DISE) AND (p<>DISP) AND (p<>DISL))
                            pivadr:=Long(c_node+p)
                        ENDIF
                        IF (p=DISP)
                            IF pivadr THEN Dispose(pivadr)
                        ENDIF
                        IF (p=DISL)
                            IF pivadr THEN DisposeLink(pivadr)
                        ENDIF
                    ENDIF
                UNTIL (p=DISE)
                IF c_node THEN Dispose(c_node)
            ENDIF
            IF c_node.name THEN DisposeLink(c_node.name)
            IF c_node.succ=0 THEN RemTail(ptr_list)
            IF c_node.pred=0 THEN RemHead(ptr_list)
            IF (c_node.succ<>0) AND (c_node.pred<>0) THEN Remove(c_node)
        ENDIF
        c_node:=c_node.succ
    ENDWHILE
    IF mode=LIST_CLEAN
        ptr_list.tail:=0
        ptr_list.head:=ptr_list.tail
        ptr_list.tailpred:=ptr_list.head
        ptr_list.type:=0
        ptr_list.pad:=0
        RETURN ptr_list
    ELSEIF mode=LIST_REMOVE
        IF ptr_list THEN Dispose(ptr_list)
        RETURN NIL
    ENDIF
ENDPROC
/**/
/*"addNode(ptr_list:PTR TO lh,node_name,adr)"*/
EXPORT PROC addNode(ptr_list:PTR TO lh,node_name,adr) HANDLE
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
        nn:=getNumNode(ptr_list,adr)
    ELSE
        AddTail(ptr_list,a_node)
        nn:=getNumNode(ptr_list,a_node)
    ENDIF
    IF nn=-1
        IF adr=0 THEN ptr_list.head:=a_node ELSE ptr_list.head:=adr
        a_node.pred:=0
        nn:=0
    ENDIF
    IF adr<>0 THEN Dispose(a_node) /* node is copied,free it */
    Raise(nn)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"sortList(list:PTR TO lh)"*/
EXPORT PROC sortList(list:PTR TO lh)
/*===============================================================================
 = Para         : address of list.
 = Return       : NONE.
 = Description  : Sort a list (found in toolmanager sources).
 ==============================================================================*/
    DEF notfini=TRUE
    DEF first:PTR TO ln
    DEF second:PTR TO ln
    DEF numnode=NIL
    WHILE (notfini)
        notfini:=FALSE
        IF first:=list.head
            WHILE ((second:=first.succ) AND (second.succ<>0))
                IF (Stricmp(first.name,second.name))>0
                    numnode:=getNumNode(list,second)
                    IF numnode<>-1
                        doUpNode(list,numnode)
                        notfini:=TRUE
                    ENDIF
                ELSE
                    first:=second
                ENDIF
            ENDWHILE
        ENDIF
    ENDWHILE
ENDPROC
/**/
/*"doUpNode(list:PTR TO lh,numnode)"*/
EXPORT PROC doUpNode(list:PTR TO lh,numnode)
/*===============================================================================
 = Para         : address of a list,num of node.
 = Return       : the number (and not the address) of the new node selected.
 = Description  : move up a node.
 ==============================================================================*/
    DEF upnode:PTR TO ln
    DEF prednode:PTR TO ln
    DEF ret
    upnode:=getAdrNode(list,numnode)
    IF numnode=0 THEN RETURN 0
    prednode:=upnode.pred
    IF ((upnode) AND (prednode))
        prednode:=prednode.pred
        Remove(upnode)
        Insert(list,upnode,prednode)
        ret:=numnode-1
        ENDIF
    IF ret=0
        upnode:=getAdrNode(list,0)
        upnode.pred:=0
    ENDIF
    RETURN ret
ENDPROC
/**/
/*"doDownNode(list:PTR TO lh,numnode)"*/
EXPORT PROC doDownNode(list:PTR TO lh,numnode)
/*===============================================================================
 = Para         : address of a list,num of node.
 = Return       : the num of the new selected node.
 = Description  : make down node.
 ==============================================================================*/
    DEF upnode:PTR TO ln
    DEF succnode:PTR TO ln
    DEF rn
    rn:=countNodes(list)
    rn:=rn-1
    IF numnode=rn THEN RETURN numnode
    upnode:=getAdrNode(list,numnode)
    succnode:=upnode.succ
    IF ((upnode) AND (succnode))
        Remove(upnode)
        Insert(list,upnode,succnode)
    ENDIF
    IF numnode=0 THEN list.head:=succnode
    RETURN numnode+1
ENDPROC
/**/


