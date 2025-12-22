MODULE '*smartList'

CONST NROFNODES=100

PROC main()
   DEF sl:PTR TO smartList
   DEF cpobj:sl_CPObj
   DEF a
   NEW sl
   sl.smartList()

   WriteF('initing \d nodes..\n', NROFNODES)
   FOR a := 0 TO (NROFNODES)-1
      sl.add(FastNew(SIZEOF smartNode), (NROFNODES)-a)
   ENDFOR
   WriteF('counting nodes..')
   WriteF('\d\n', sl.count())
   sl.forEachCallProc({printnode}, cpobj)
   WriteF('sorting..')
   SystemTagList('date', NIL)
   sl.sort()
   SystemTagList('date', NIL)
   sl.forEachCallProc({printnode}, cpobj)
   sl.forEachCallProc({freenode}, cpobj)
   END sl
ENDPROC

PROC printnode(cpobj:PTR TO sl_CPObj)
   DEF smartNode:PTR TO smartNode
   smartNode := cpobj.node
   WriteF(' \d\n', smartNode.id)
ENDPROC

PROC freenode(cpobj:PTR TO sl_CPObj)
   FastDispose(cpobj.node, SIZEOF smartNode)
ENDPROC
