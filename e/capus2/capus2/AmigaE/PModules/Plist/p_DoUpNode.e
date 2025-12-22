/*"p_DoUpNode(list:PTR TO lh,numnode)"*/
PROC p_DoUpNode(list:PTR TO lh,numnode) 
/*===============================================================================
 = Para         : address of a list,num of node.
 = Return       : the number (and not the address) of the new node selected.
 = Description  : move up a node.
 ==============================================================================*/
    DEF upnode:PTR TO ln
    DEF prednode:PTR TO ln
    DEF ret
    upnode:=p_GetAdrNode(list,numnode)
    IF numnode=0 THEN RETURN 0
    prednode:=upnode.pred
    IF ((upnode) AND (prednode))
        prednode:=prednode.pred
        Remove(upnode)
        Insert(list,upnode,prednode)
        ret:=numnode-1
        ENDIF
    IF ret=0
        upnode:=p_GetAdrNode(list,0)
        upnode.pred:=0
    ENDIF
    RETURN ret
ENDPROC
/**/
