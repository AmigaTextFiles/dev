OPT MODULE

MODULE '*xl'

EXPORT OBJECT xni OF xn
   id:LONG
ENDOBJECT

EXPORT OBJECT xli OF xl
ENDOBJECT
->/*
PROC find(id, startnode=NIL) OF xli
   DEF xni:REG PTR TO xni
   xni := IF startnode = NIL THEN self.first() ELSE startnode
   WHILE xni
      IF xni.id=id THEN RETURN xni
      xni:=xni.next
   ENDWHILE
ENDPROC NIL

PROC findRev(id, startnode=NIL) OF xli
   DEF xni:REG PTR TO xni
   xni := IF startnode = NIL THEN self.last() ELSE startnode
   WHILE xni
      IF xni.id=id THEN RETURN xni
      xni:=xni.prev
   ENDWHILE
ENDPROC NIL

PROC ordFind(id) OF xli
   DEF first:PTR TO xni
   DEF last:PTR TO xni
   DEF beg
   DEF end
   first := self.first()
   last := self.last()
   beg := id - first.id
   end := last.id - id
   IF (end < 0) OR (beg < 0)THEN RETURN NIL
   IF end <= beg THEN RETURN self.findRev(id)
ENDPROC self.find(id)


->*/
/*
PROC find(_id) OF xli
   DEF xni:REG
   DEF id:REG
   id := _id
   xni := self.first()
   MOVE.L #0, D2
loop:            ->WHILE xni
   CMP.L  D2, xni ->.........
   BEQ.L  null    ->.........

   MOVE.L xni, A0 -> lägg xni i A0
   MOVE.L 8(A0), D1

   CMP.L  id, D1
   BEQ.L  end

   MOVE.L (A0), xni -> xni := xni.next
   BRA.L  loop

null:
   RETURN NIL
end:
ENDPROC xni
*/



PROC getMaxID() OF xli
   DEF n:REG PTR TO xni, id:REG
   id := -2000000000
   n := self.first()
   WHILE n
      id := IF n.id > id THEN n.id ELSE id
      n := n.next
   ENDWHILE
ENDPROC id

PROC getMinID() OF xli
   DEF n:REG PTR TO xni, id:REG
   id := 2000000000
   n := self.first()
   WHILE n
      id := IF n.id < id THEN n.id ELSE id
      n := n.next
   ENDWHILE
ENDPROC id

PROC getSumID() OF xli
   DEF n:REG PTR TO xni, id:REG
   id:=NIL
   n := self.first()
   WHILE n
      id := id + n.id
      n := n.next
   ENDWHILE
ENDPROC id


PROC sort() OF xli
   ->DEF xli2:PTR TO xli
   ->NEW xli2
   ->presplit(self, xli2 , 50)
   bubble(self)
   ->bubble(xli2)
   ->self.listAddLast(xli2)
   ->END xli2
ENDPROC

PROC bubble(xli:PTR TO xli)
   DEF n:PTR TO xni
   DEF nnext:PTR TO xni
   DEF useful
   REPEAT
      n := xli.first()
      useful := FALSE
      WHILE n
         nnext := n.next
         IF nnext
            IF n.id > nnext.id
               xli.remove(n)
               xli.insert(n, nnext)
               useful := TRUE
            ENDIF
            n := n.next
         ELSE
            n := NIL
         ENDIF
      ENDWHILE
   UNTIL useful = FALSE
ENDPROC

/* something goes wrong here..! */
/* well it experimental anyway..
PROC presplit(xli:PTR TO xli, xli2:PTR TO xli, splitval)
   DEF n:PTR TO xni
   n := xli.first()
   WHILE n
      IF n.id > splitval
         xli.remove(n)
         xli2.addFirst(n)
      ENDIF
      n := n.next
   ENDWHILE
ENDPROC
*/


/* these doesnt wprk! */
/*
PROC quickSort() OF xli
   quicksort(self, self.first(), self.last())
ENDPROC

PROC quicksort(list:PTR TO xli, first:PTR TO xni, last:PTR TO xni)
  DEF curr:PTR TO xni, left=NIL, fNum

  IF FreeStack() < 100 THEN Raise(TRUE)
  fNum:=first.id
  IF (curr:=first.next)=last
    IF fNum>(last.id)
      list.remove(first); list.insert(first,last)
    ENDIF
  ELSE
    REPEAT
      IF (curr.id)<fNum
        IF curr=last THEN last:=last.prev
        IF left=NIL THEN left:=curr
        list.remove(curr); list.insert(curr,first.prev)
      ENDIF
    UNTIL (curr:=curr.next)=(last.next)
    IF left AND (left<>(first.prev)) THEN quicksort(list, left, first.prev)
    IF (first<>last) AND ((first.next)<>last) THEN quicksort(list, first.next, last)
  ENDIF
ENDPROC
*/

EXPORT OBJECT xli_CPObj OF xl_CPObj
ENDOBJECT

PROC ordInsert(xni:PTR TO xni) OF xli
   DEF n:PTR TO xni
   n := self.first()
   IF n = NIL THEN RETURN self.addFirst(xni)
   IF n.id > xni.id THEN RETURN self.addFirst(xni)
   WHILE n.id < xni.id
      n := n.next
      IF n = NIL THEN RETURN self.addLast(xni)
   ENDWHILE
   self.insert(xni, n.prev)
ENDPROC xni

PROC cmpMap(xli:PTR TO xli) OF xli
   DEF thisnode:PTR TO xni
   DEF thatnode:PTR TO xni
   thisnode := self.first()
   thatnode := xli.first()
   WHILE (thisnode OR thatnode)
      IF thisnode.id <> thatnode.id THEN RETURN FALSE
      thisnode := thisnode.next
      thatnode := thatnode.next
   ENDWHILE
ENDPROC TRUE

PROC scroll(_amount) OF xli
   DEF n:REG PTR TO xni
   DEF amount:REG
   amount := _amount
   n := self.first()
   WHILE n
      n.id := n.id + amount
      n := n.next
   ENDWHILE
ENDPROC

/* merge two sorted lists into one */
PROC ordListMerge(listToInsert:PTR TO xli) OF xli
   DEF thisnode:PTR TO xni
   DEF thatnode:PTR TO xni
   thisnode := self.first()
   thatnode := listToInsert.first()
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

