PROC p_EmptyList(ptr_list:PTR TO lh) /*"p_EmptyList(ptr_list:PTR TO lh)"*/
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

