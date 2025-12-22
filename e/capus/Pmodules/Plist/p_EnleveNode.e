PROC p_EnleveNode(ptr_list:PTR TO lh,num_node,doit,dat:PTR TO LONG) /*"p_EnleveNode(ptr_list:PTR TO lh,num_node,doit,dat:PTR TO LONG)"*/
/*===============================================================================
 = Para         : Address of a list,number of a node,if doit<>0 free data,tha data.
 = Return       : The number of the new selected node in the list.
 = Description  : Remove a node.
 ==============================================================================*/
    DEF e_node:PTR TO ln
    DEF new_e_node:PTR TO ln
    DEF count=0,retour=NIL
    DEF p=0,pivadr
    DEF rdat:PTR TO LONG
    e_node:=ptr_list.head
    rdat:=dat
    WHILE e_node
        p:=0
        rdat:=dat
        IF count=num_node
            IF doit<>0
                REPEAT
                    p:=rdat[]++
                    IF p<>DISE
                        IF ((p<>DISE) AND (p<>DISP) AND (p<>DISL))
                            pivadr:=Long(e_node+p)
                        ENDIF
                        IF (p=DISP)
                            IF pivadr THEN Dispose(pivadr)
                        ENDIF
                        IF (p=DISL)
                            IF pivadr THEN DisposeLink(pivadr)
                        ENDIF
                    ENDIF
                UNTIL (p=DISE)
                IF e_node THEN Dispose(e_node)
            ENDIF
            IF e_node.succ=0
                RemTail(ptr_list)
                retour:=num_node-1
            ELSEIF e_node.pred=0
                RemHead(ptr_list)
                retour:=num_node
                new_e_node:=p_GetAdrNode(ptr_list,num_node)
                ptr_list.head:=new_e_node
                new_e_node.pred:=0
            ELSEIF (e_node.succ<>0) AND (e_node.pred<>0)
                Remove(e_node)
                retour:=num_node-1
            ENDIF
            IF e_node.name THEN DisposeLink(e_node.name)
        ENDIF
        INC count
        e_node:=e_node.succ
    ENDWHILE
    RETURN retour
ENDPROC

