PROC p_SortList(list:PTR TO lh) /*"p_SortList(list:PTR TO lh)"*/
/*===============================================================================
 = Para         : address of list.
 = Return       : NONE.
 = Description  : Sort a list (found in toolmanager sources).
 ==============================================================================*/
    DEF notfini=TRUE
    DEF first:PTR TO ln
    DEF second:PTR TO ln
    DEF numnode=NIL
    WHILE (notfini)
        notfini:=FALSE
        IF first:=list.head
            WHILE ((second:=first.succ) AND (second.succ<>0))
                IF (Stricmp(first.name,second.name))>0
                    numnode:=p_GetNumNode(list,second)
                    IF numnode<>-1
                        p_DoUpNode(list,numnode)
                        notfini:=TRUE
                    ENDIF
                ELSE
                    first:=second
                ENDIF
            ENDWHILE
        ENDIF
    ENDWHILE
ENDPROC

