PROC p_DoDownNode(list:PTR TO lh,numnode) /*"p_DoDownNode(list:PTR TO lh,numnode)"*/
/*===============================================================================
 = Para         : address of a list,num of node.
 = Return       : the num of the new selected node.
 = Description  : make down node.
 ==============================================================================*/
    DEF upnode:PTR TO ln
    DEF succnode:PTR TO ln
    DEF rn
    rn:=p_CountNodes(list)
    rn:=rn-1
    IF numnode=rn THEN RETURN numnode
    upnode:=p_GetAdrNode(list,numnode)
    succnode:=upnode.succ
    IF ((upnode) AND (succnode))
        Remove(upnode)
        Insert(list,upnode,succnode)
    ENDIF
    IF numnode=0 THEN list.head:=succnode
    RETURN numnode+1
ENDPROC


