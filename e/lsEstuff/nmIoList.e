OPT MODULE

MODULE 'leifoo/nm'
MODULE 'leifoo/nmIList'

EXPORT OBJECT nmIoList OF nmIList ; ENDOBJECT

PROC oFind(id) OF nmIoList
   DEF first:PTR TO nmI
   DEF last:PTR TO nmI
   DEF beg
   DEF end
   first := self.first()
   last := self.last()
   beg := id - first.id
   end := last.id - id
   IF (end < 0) OR (beg < 0)THEN RETURN NIL
   IF end <= beg THEN RETURN self.findR(id)
ENDPROC self.find(id)

PROC sort() OF nmIoList IS bubble(self)

PROC bubble(nmIoList:PTR TO nmIoList)
   DEF n:PTR TO nmI
   DEF nnext:PTR TO nmI
   DEF useful
   REPEAT
      n := nmIoList.first()
      useful := FALSE
      WHILE n
         nnext := n.next
         IF nnext
            IF n.id > nnext.id
               nmIoList.remove(n)
               nmIoList.insert(n, nnext)
               useful := TRUE
            ENDIF
            n := n.next
         ELSE
            n := NIL
         ENDIF
      ENDWHILE
   UNTIL useful = FALSE
ENDPROC

PROC oInsert(nmI:PTR TO nmI) OF nmIoList
   DEF n:PTR TO nmI
   n := self.first()
   IF n = NIL THEN RETURN self.addFirst(nmI)
   IF n.id > nmI.id THEN RETURN self.addFirst(nmI)
   WHILE n.id < nmI.id
      n := n.next
      IF n = NIL THEN RETURN self.addLast(nmI)
   ENDWHILE
   self.insert(nmI, n.prev)
ENDPROC nmI

PROC cmpMap(nmIoList:PTR TO nmIoList) OF nmIoList
   DEF thisnode:PTR TO nmI
   DEF thatnode:PTR TO nmI
   thisnode := self.first()
   thatnode := nmIoList.first()
   WHILE (thisnode OR thatnode)
      IF thisnode.id <> thatnode.id THEN RETURN FALSE
      thisnode := thisnode.next
      thatnode := thatnode.next
   ENDWHILE
ENDPROC TRUE

/* merge two sorted lists into one */
/* damn.. it seems a little complicated..  */
/* does it have to be that much code ? */
PROC oListMerge(oListToInsert:PTR TO nmIoList) OF nmIoList
   DEF thisnode:PTR TO nmI
   DEF thatnode:PTR TO nmI
   thisnode := self.first()
   thatnode := oListToInsert.first()
   WHILE thatnode
      IF thisnode
         IF thisnode.id > thatnode.id
            IF thisnode.prev
               self.insert(thatnode, thisnode.prev)
            ELSE
               self.addFirst(thatnode)
            ENDIF
            thatnode := thatnode.next
         ELSEIF thisnode.id = thatnode.id
            self.insert(thatnode, thisnode)
            thisnode := thisnode.next
            thatnode := thatnode.next
         ELSE -> thisnode.id < thatnode.id
            thisnode := thisnode.next
         ENDIF
      ELSE
         self.addLast(thatnode)
         thatnode := thatnode.next
      ENDIF
   ENDWHILE
ENDPROC

/* this one.. I dont know.. where do I get the ideas ? */
PROC callProcCmpIDLists(eqproc, lesproc, bigproc, l1:PTR TO nmIoList, l2:PTR TO nmIoList)
   DEF n1:PTR TO nmI
   DEF n2:PTR TO nmI
   n1 := l1.first()
   n2 := l2.first()
   WHILE n1 OR n2
      IF n1.id > n2.id
         bigproc(n1, n2)
         n2 := n2.next
      ELSEIF n1.id = n2.id
         eqproc(n1, n2)
         n1 := n1.next
         n2 := n2.next
      ELSE
         lesproc(n1, n2)
         n1 := n1.next
      ENDIF
   ENDWHILE
ENDPROC

/* well.. its ordered .. right ? */
PROC oGetMaxID() OF nmIoList
   DEF n:PTR TO nmI
   n := self.last()
   IF n = NIL THEN RETURN NIL
ENDPROC n.id

PROC oGetMinID() OF nmIoList
   DEF n:PTR TO nmI
   n := self.first()
   IF n = NIL THEN RETURN NIL
ENDPROC n.id



