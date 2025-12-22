/*"p_RemoveList(ptr_list:PTR TO lh)"*/
PROC p_RemoveList(ptr_list:PTR TO lh) 
/*===============================================================================
 = Para         : Address of a list.
 = Return       : NONE
 = Description  : p_CleanList() an Dispose() the list.
 ==============================================================================*/
    DEF r_list:PTR TO lh
    r_list:=p_CleanList(ptr_list,FALSE,0,0)
    IF r_list THEN Dispose(r_list)
ENDPROC
/**/
