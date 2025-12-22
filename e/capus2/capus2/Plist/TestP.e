
MODULE 'exec/lists','exec/execbase','*Plist'

PROC main()
    DEF l:PTR TO lh
    DEF d:PTR TO lh
    DEF b,str[80]:STRING
    DEF e:PTR TO execbase
    DEF v
    e:=execbase
    WriteF('Init list...(with ''initList()'')\n')
    l:=initList()
    d:=initList()
    Write(stdout,'Enter Number of Nodes =',STRLEN)
    ReadStr(stdout,str)
    v:=Val(str,NIL)
    FOR b:=0 TO v-1
        StringF(str,'Node :\d',b)
        addNode(l,str,0)
        WriteF('Add node with ''addNode()'' name:\s\n',str)
    ENDFOR
    b:=countNodes(l)
    WriteF('Total Nodes:\d with ''countNodes()''\n',b)
    b:=getAdrNode(l,2)
    WriteF('Address Node number 2:\h with ''getAdrNode()''\n',b)
    Write(stdout,'Now ''writeFList()'' (press return)\n',STRLEN)
    ReadStr(stdout,str)
    writeFList(l)
    Write(stdout,'Now ''copyList()'' copy execbase.portlist (press return)\n',STRLEN)
    ReadStr(stdout,str)
    Forbid()
    copyList(e.portlist,d)
    Permit()
    Write(stdout,'Now ''writeFList()'' the result list.(press return)\n',STRLEN)
    ReadStr(stdout,str)
    writeFList(d)
    WriteF('Now clean it.. with ''cleanList()''\n')
    d:=cleanList(d,FALSE,0,LIST_CLEAN)
    WriteF('''writeFList()'' if list is empty with ''emptyList()''\n')
    IF emptyList(d) THEN writeFList(d)
    cleanList(d,FALSE,0,LIST_REMOVE)
    cleanList(l,FALSE,0,LIST_REMOVE)
ENDPROC

