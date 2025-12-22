/*"p_InitList()"*/
PROC p_InitList() HANDLE 
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
