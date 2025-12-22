OPT MODULE

OPT EXPORT

MODULE 'exec/lists'
MODULE '*/mymods/myfile'

OBJECT xn
   next:PTR TO LONG
   prev:PTR TO LONG
ENDOBJECT


OBJECT xl
   next:PTR TO LONG
   prev:PTR TO LONG
   id
   PRIVATE
   first:PTR TO LONG
   last:PTR TO LONG
ENDOBJECT

PROC first() OF xl IS self.first

PROC last() OF xl IS self.last


PROC addFirst(xn:PTR TO xn) OF xl
   DEF next:PTR TO xn
   next:=self.first

   self.first:=xn
   IF self.last=NIL THEN self.last:=xn
   xn.prev:=NIL
   xn.next:=next
   IF next THEN next.prev:=xn
ENDPROC xn

PROC addLast(xn:PTR TO xn) OF xl
   DEF prev:PTR TO xn
   prev:=self.last

   self.last:=xn
   IF self.first=NIL THEN self.first:=xn
   xn.next:=NIL
   xn.prev:=prev
   IF prev THEN prev.next:=xn
ENDPROC xn

PROC remFirst() OF xl
   DEF remed:PTR TO xn, next:PTR TO xn
   remed:=NIL
   IF self.first
      remed:=self.first
      self.first:=remed.next
      IF remed.next=NIL
         self.last:=NIL
      ELSE
         next:=remed.next
         next.prev:=NIL
      ENDIF
   ENDIF
ENDPROC remed

PROC remLast() OF xl
   DEF remed:PTR TO xn, prev:PTR TO xn
   remed:=NIL
   IF self.last
      remed:=self.last
      self.last:=remed.prev
      IF remed.prev=NIL
         self.first:=NIL
      ELSE
         prev:=remed.prev
         prev.next:=NIL
      ENDIF
   ENDIF
ENDPROC remed

PROC remove(xn:PTR TO xn) OF xl
   DEF prev:PTR TO xn, next:PTR TO xn
   IF xn.prev=NIL THEN RETURN self.remFirst()
   IF xn.next=NIL THEN RETURN self.remLast()
   prev:=xn.prev
   next:=xn.next
   prev.next:=next
   next.prev:=prev
ENDPROC xn

PROC insert(xn:PTR TO xn, afterthis:PTR TO xn) OF xl
   DEF next:PTR TO xn
   IF afterthis.next=NIL THEN RETURN self.addLast(xn)
   next:=afterthis.next
   afterthis.next:=xn
   xn.prev:=afterthis
   xn.next:=next
   next.prev:=xn
ENDPROC xn

PROC countNodes(firstnode=NIL) OF xl
   DEF xn:REG PTR TO xn, count:REG
   count:=NIL
   xn:=IF firstnode = NIL THEN self.first ELSE firstnode
   WHILE xn
      count++
      xn:=xn.next
   ENDWHILE
ENDPROC count

PROC removeFastDisposeAll(nodesize) OF xl
   DEF xn:PTR TO xn
   xn:=self.first
   WHILE xn
      self.removeFastDispose(xn, nodesize)
      xn:=xn.next
   ENDWHILE
ENDPROC


PROC removeFastDispose(node, nodesize) OF xl
   self.remove(node)
   FastDispose(node, nodesize)
ENDPROC

PROC addLastFastNew(nodesize) OF xl
ENDPROC self.addLast(FastNew(nodesize))

PROC cloneFastNew(tolist:PTR TO xl, nodesize) OF xl
   DEF n1:PTR TO xn
   DEF n2:PTR TO xn
   n1 := self.first
   WHILE n1
      n2 := FastNew(nodesize)
      CopyMem(n1, n2, nodesize)
      tolist.addLast(n2)
      n1 := n1.next
   ENDWHILE
ENDPROC self.first

PROC fromExecList(lh:PTR TO lh) OF xl
   self.first := lh.head
   self.last := lh.tailpred
ENDPROC

PROC looseNodes() OF xl
   self.first := NIL
   self.last := NIL
ENDPROC

PROC listInsert(xl:PTR TO xl, afterthis:PTR TO xn) OF xl
   afterthis.next := xl.first
   self.last := xl.last
ENDPROC

PROC listAddFirst(xl:PTR TO xl) OF xl
   DEF thatlast:PTR TO xn
   thatlast := xl.last
   thatlast.next := self.first
   self.first := xl.first
ENDPROC

PROC listAddLast(xl:PTR TO xl) OF xl
   DEF thatfirst:PTR TO xn
   thatfirst := xl.first
   thatfirst.prev := self.last
   self.last := xl.last
ENDPROC

EXPORT OBJECT xl_CPObj
   node:PTR TO LONG
   list:PTR TO LONG
ENDOBJECT


PROC travNodes(proc, cpobj=NIL:PTR TO xl_CPObj) OF xl
   DEF n:PTR TO xn
   DEF cp:xl_CPObj
   IF cpobj = NIL THEN cpobj := cp
   n := self.first
   cpobj.list := self
   WHILE n
      cpobj.node := n
      proc(cpobj)
      n := n.next
   ENDWHILE
ENDPROC

PROC travNodesRev(proc, cpobj=NIL:PTR TO xl_CPObj) OF xl
   DEF n:PTR TO xn
   DEF cp:xl_CPObj
   IF cpobj = NIL THEN cpobj := cp
   n := self.last
   cpobj.list := self
   WHILE n
      cpobj.node := n
      proc(cpobj)
      n := n.prev
   ENDWHILE
ENDPROC

/* only to use with xn-inherited objects! (no methods) */
EXPORT PROC saveToDisk(xl:PTR TO xl, name, nodesize)
   DEF mem
   DEF memptr:PTR TO LONG
   DEF memsize
   DEF nrof
   DEF n:PTR TO xn
   nodesize := nodesize - SIZEOF xn
   IF nodesize < 1 THEN RETURN NIL
   nrof := xl.countNodes()
   IF nrof = NIL THEN RETURN NIL
   memsize := memsize * nrof
   memsize := memsize + 8 -> two LONGs describing the block
   mem := FastNew(memsize)
   memptr := mem
   memptr[]++ := nrof
   memptr[]++ := nodesize
   n := xl.first
   WHILE n
      CopyMem(n + (SIZEOF xn), memptr, nodesize)
      memptr := memptr + nodesize
      n := n.next
   ENDWHILE
   writefile(name, mem, memsize)
   FastDispose(mem, memsize)
ENDPROC

