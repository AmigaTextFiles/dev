/*"p_GetAdrNode(ptr_list:PTR TO lh,num_node)"*/
PROC p_GetAdrNode(ptr_list:PTR TO lh,num_node) 
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
