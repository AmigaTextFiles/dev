PROC p_CountNodes(list:PTR TO lh) /*"p_CountNodes(list:PTR TO lh)"*/
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

