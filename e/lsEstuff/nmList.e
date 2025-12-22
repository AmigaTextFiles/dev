OPT MODULE

->
->the new listclass (991017)
->nodes and the list inherits methods from lobject.
->if nodes with methods is a problem, dont use this one!
->be SURE to use only nodes inherited from nm!!

->kinda skitbra !! skulle jag vilja säga.
->extremt trevlig klass som man kan bygga vidare på
->eller bara använda som den e..
->används till tamejfan nästan allt i leifoo-lådan :)


MODULE 'leifoo/nm'

EXPORT OBJECT nmList OF nm
   id
   PRIVATE
   first:PTR TO nm
   last:PTR TO nm
ENDOBJECT

EXPORT OBJECT nmList_travObj
   node :PTR TO nm
   list:PTR TO nmList
ENDOBJECT

PROC printObject() OF nmList
   DEF n:PTR TO nm
   WriteF('list')
   SUPER self.printObject()
   n := self.first()
   WriteF('nodes :\n')
   WHILE n
      n.printObject()
      n := n.next
   ENDWHILE
ENDPROC


PROC end() OF nmList IS self.clear()

PROC clear() OF nmList
   DEF node:PTR TO nm
   DEF next
   node := self.first()
   WHILE node
      next := node.next
      END node
      node := next
   ENDWHILE
ENDPROC

PROC getObjectName() OF nmList IS 'nmList'

PROC getObjectSize() OF nmList IS SIZEOF nmList

PROC first() OF nmList IS self.first

PROC last() OF nmList IS self.last


PROC addFirst(nm:PTR TO nm) OF nmList
   DEF next:PTR TO nm
   next:=self.first

   self.first:=nm
   IF self.last=NIL THEN self.last:=nm
   nm.prev:=NIL
   nm.next:=next
   IF next THEN next.prev:=nm
ENDPROC nm

PROC addLast(nm:PTR TO nm) OF nmList
   DEF prev:PTR TO nm
   prev:=self.last

   self.last:=nm
   IF self.first=NIL THEN self.first:=nm
   nm.next:=NIL
   nm.prev:=prev
   IF prev THEN prev.next:=nm
ENDPROC nm

PROC remFirst() OF nmList
   DEF remed:PTR TO nm, next:PTR TO nm
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

PROC remLast() OF nmList
   DEF remed:PTR TO nm, prev:PTR TO nm
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

PROC remove(nm:PTR TO nm) OF nmList
   DEF prev:PTR TO nm, next:PTR TO nm
   IF nm.prev=NIL THEN RETURN self.remFirst()
   IF nm.next=NIL THEN RETURN self.remLast()
   prev:=nm.prev
   next:=nm.next
   prev.next:=next
   next.prev:=prev
ENDPROC nm

PROC insert(nm:PTR TO nm, afterthis:PTR TO nm) OF nmList
   DEF next:PTR TO nm
   IF afterthis.next=NIL THEN RETURN self.addLast(nm)
   next:=afterthis.next
   afterthis.next:=nm
   nm.prev:=afterthis
   nm.next:=next
   next.prev:=nm
ENDPROC nm

PROC countNodes(firstnode=NIL) OF nmList
   DEF nm:REG PTR TO nm, count:REG
   count:=NIL
   nm := IF firstnode = NIL THEN self.first ELSE firstnode
   WHILE nm
      count++
      nm:=nm.next
   ENDWHILE
ENDPROC count

PROC listInsert(nmList:PTR TO nmList, afterthis:PTR TO nm) OF nmList
   DEF nmL_last:PTR TO nm
   DEF nmL_first:PTR TO nm
   nmL_first := nmList.first
   nmL_first.prev := afterthis
   nmL_last := nmList.last
   nmL_last.next := afterthis.next
   afterthis.next := nmList.first
   self.last := nmList.last
ENDPROC

PROC listAddFirst(nmList:PTR TO nmList) OF nmList
   DEF thatlast:PTR TO nm
   DEF thisfirst:PTR TO nm
   thisfirst.prev := nmList.last
   thatlast := nmList.last
   thatlast.next := self.first
   self.first := nmList.first
ENDPROC

PROC listAddLast(nmList:PTR TO nmList) OF nmList
   DEF thatfirst:PTR TO nm
   thatfirst := nmList.first
   thatfirst.prev := self.last
   self.last.next := thatfirst
   self.last := nmList.last
ENDPROC

PROC delete(nm:PTR TO nm) OF nmList
   self.remove(nm)
   END nm
ENDPROC

PROC travNodes(proc, obj=NIL) OF nmList
   DEF n:PTR TO nm
   DEF to:PTR TO nmList_travObj
   to := obj
   IF to = NIL THEN NEW to
   to.list := self
   n := self.first
   WHILE n
      to.node := n
      proc(to)
      n := n.next
   ENDWHILE
   IF obj = NIL THEN END to
ENDPROC

PROC replace(oldnode:PTR TO nm, newnode:PTR TO nm) OF nmList
   DEF prevnode:PTR TO nm
   DEF nextnode:PTR TO nm

   prevnode := oldnode.prev
   nextnode := oldnode.next

   newnode.prev := prevnode
   newnode.next := nextnode

   IF prevnode = NIL
      self.first := newnode
   ELSE
      prevnode.next := newnode
   ENDIF

   IF nextnode = NIL
      self.last := newnode
   ELSE
      nextnode.prev := newnode
   ENDIF

ENDPROC oldnode


