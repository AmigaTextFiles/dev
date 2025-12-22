PROC p_CleanList(ptr_list:PTR TO lh,doit,dat:PTR TO LONG,mode) /*"p_CleanList(ptr_list:PTR TO lh,doit,dat:PTR TO LONG,mode)"*/
/*===============================================================================
 = Para         : Address of a List,if doit<>0 free data,the data,just clean or clean and remove.
 = Return       : Address of clean list.
 = Description  : Remove all nodes in the list.
 ==============================================================================*/
    DEF c_node:PTR TO ln
    DEF p=0,pivadr
    DEF rdat:PTR TO LONG
    c_node:=ptr_list.head
    rdat:=dat
    WHILE c_node
        p:=0
        rdat:=dat
        IF c_node.succ<>0
            IF doit<>0
                REPEAT
                    p:=rdat[]++
                    IF p<>DISE
                        IF ((p<>DISE) AND (p<>DISP) AND (p<>DISL))
                            pivadr:=Long(c_node+p)
                        ENDIF
                        IF (p=DISP)
                            IF pivadr THEN Dispose(pivadr)
                        ENDIF
                        IF (p=DISL)
                            IF pivadr THEN DisposeLink(pivadr)
                        ENDIF
                    ENDIF
                UNTIL (p=DISE)
                IF c_node THEN Dispose(c_node)
            ENDIF
            IF c_node.name THEN DisposeLink(c_node.name)
            IF c_node.succ=0 THEN RemTail(ptr_list)
            IF c_node.pred=0 THEN RemHead(ptr_list)
            IF (c_node.succ<>0) AND (c_node.pred<>0) THEN Remove(c_node)
        ENDIF
        c_node:=c_node.succ
    ENDWHILE
    IF mode=LIST_CLEAN
        ptr_list.tail:=0
        ptr_list.head:=ptr_list.tail
        ptr_list.tailpred:=ptr_list.head
        ptr_list.type:=0
        ptr_list.pad:=0
        RETURN ptr_list
    ELSEIF mode=LIST_REMOVE
        IF ptr_list THEN Dispose(ptr_list)
        RETURN NIL
    ENDIF
ENDPROC

