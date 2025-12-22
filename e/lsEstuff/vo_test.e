MODULE '*virt_Obj'

PROC main()
   DEF vo:PTR TO virtObj
   NEW vo
   vo.set([1], 1)
   vo.set([1, 2], 2)
   vo.set([1, 2, 3], 3)
   vo.set([3, 2, 1], 20)
   vo.travNodesS({bla})
   vo.unset([1])
   vo.travNodesS({bla})
   END vo
ENDPROC

PROC bla(n:PTR TO vo_node)
   DEF a
   WriteF('elist : ')
   FOR a := 0 TO ListLen(n.elist)-1
      WriteF('\d, ', ListItem(n.elist, a))
   ENDFOR
   WriteF('..value : \d\n', n.value)
ENDPROC
