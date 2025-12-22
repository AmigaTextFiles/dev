/*"p_GetNumNode(ptr_list:PTR TO lh,adr_node)"*/
PROC p_GetNumNode(ptr_list:PTR TO lh,adr_node) 
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
