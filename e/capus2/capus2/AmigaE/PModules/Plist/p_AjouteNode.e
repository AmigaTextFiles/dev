/*"p_AjouteNode(ptr_list:PTR TO lh,node_name,adr)"*/
PROC p_AjouteNode(ptr_list:PTR TO lh,node_name,adr) HANDLE 
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
