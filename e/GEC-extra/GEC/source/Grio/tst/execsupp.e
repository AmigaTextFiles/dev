MODULE 'execsupport','libraries/execsupport','exec/lists','exec/nodes'


PROC main()
DEF lh:PTR TO lh,x,l
IF (execsupportbase:=OpenLibrary('execsupport.library',3))
    IF (lh:=Es_InitList())
        Es_AddNode(lh,'Zero')
        Es_AddNode(lh,'One')
        Es_AddNode(lh,'Two')
        Es_AddNode(lh,'Three')
        l:=Es_CountNodes(lh)
        WriteF('Number of nodes = \d\n',l)
        FOR x:=0 TO l-1
           WriteF('Node \d name = \s\n',x,Es_GetAddrNode(lh,x)::ln.name)
        ENDFOR
        WriteF('Sorting...\n')
        Es_SortList(lh,SORT_NORMAL)
        FOR x:=0 TO l-1
           WriteF('Node \d name = \s\n',x,Es_GetAddrNode(lh,x)::ln.name)
        ENDFOR
        Es_FreeList(lh,LIST_REMOVE)
    ENDIF
    CloseLibrary(execsupportbase)
ENDIF
ENDPROC

