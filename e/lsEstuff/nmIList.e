OPT MODULE

MODULE 'leifoo/nm'
MODULE 'leifoo/nmList'

EXPORT OBJECT nmIList OF nmList
ENDOBJECT

PROC find(id, startnode=NIL) OF nmIList
   DEF nmI:REG PTR TO nmI
   nmI := IF startnode = NIL THEN self.first() ELSE startnode
   WHILE nmI
      IF nmI.id=id THEN RETURN nmI
      nmI:=nmI.next
   ENDWHILE
ENDPROC NIL

PROC findR(id, startnode=NIL) OF nmIList
   DEF nmI:REG PTR TO nmI
   nmI := IF startnode = NIL THEN self.last() ELSE startnode
   WHILE nmI
      IF nmI.id=id THEN RETURN nmI
      nmI:=nmI.prev
   ENDWHILE
ENDPROC NIL
 
PROC getMaxID() OF nmIList
   DEF n:REG PTR TO nmI, id:REG
   id := -2000000000
   n := self.first()
   WHILE n
      id := IF n.id > id THEN n.id ELSE id
      n := n.next
   ENDWHILE
ENDPROC id

PROC getMinID() OF nmIList
   DEF n:REG PTR TO nmI, id:REG
   id := 2000000000
   n := self.first()
   WHILE n
      id := IF n.id < id THEN n.id ELSE id
      n := n.next
   ENDWHILE
ENDPROC id

PROC getSumID() OF nmIList
   DEF n:REG PTR TO nmI, id:REG
   id:=NIL
   n := self.first()
   WHILE n
      id := id + n.id
      n := n.next
   ENDWHILE
ENDPROC id


PROC scroll(_amount) OF nmIList
   DEF n:REG PTR TO nmI
   DEF amount:REG
   amount := _amount
   n := self.first()
   WHILE n
      n.id := n.id + amount
      n := n.next
   ENDWHILE
ENDPROC

