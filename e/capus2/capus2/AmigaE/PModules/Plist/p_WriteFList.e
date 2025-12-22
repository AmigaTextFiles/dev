/*"p_WriteFList(ptr_list:PTR TO lh)"*/
PROC p_WriteFList(ptr_list:PTR TO lh) 
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
