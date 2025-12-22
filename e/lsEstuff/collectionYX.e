OPT MODULE

MODULE '*xli'
MODULE '*collectionX'

EXPORT OBJECT collectionYX OF xli
ENDOBJECT

PROC private_Methods_From_Here() OF collectionYX IS EMPTY

PROC collectionYX() OF collectionYX IS TRUE

PROC clear() OF collectionYX
   DEF nax:PTR TO collectionX
   DEF next
   nax := self.first()
   WHILE nax
      next := nax.next
      self.remove(nax)
      END nax
      nax := next
   ENDWHILE
ENDPROC

PROC scrollY(amount) OF collectionYX IS self.scroll(amount)

PROC scrollX(amount) OF collectionYX
   DEF nax:PTR TO collectionX
   nax := self.first()
   WHILE nax
      nax.scrollX(amount)
      nax := nax.next
   ENDWHILE
ENDPROC

PROC countYX() OF collectionYX
   DEF nax:PTR TO collectionX
   DEF count=NIL
   nax := self.first()
   WHILE nax
      count := count + nax.countX()
      INC count
      nax := nax.next
   ENDWHILE
ENDPROC count

PROC countX() OF collectionYX
   DEF nax:PTR TO collectionX
   DEF count=NIL
   nax := self.first()
   WHILE nax
      count := count + nax.countX()
      nax := nax.next
   ENDWHILE
ENDPROC count

PROC countY() OF collectionYX IS self.countNodes()

PROC getCollectionX(y) OF collectionYX IS self.find(y)

PROC set(y, x, value) OF collectionYX
   DEF nax:PTR TO collectionX
   nax := self.ordFind(y)
   IF nax = NIL
      IF value = NIL THEN RETURN NIL
      NEW nax.collectionX()
      nax.id := y
      self.ordInsert(nax)
   ENDIF
   nax.set(x, value)
ENDPROC

PROC get(y, x) OF collectionYX
   DEF nax:PTR TO collectionX
   nax := self.ordFind(y)
   IF nax = NIL THEN RETURN NIL
ENDPROC nax.get(x)

PROC unSet(y, x) OF collectionYX
   DEF nax:PTR TO collectionX
   nax := self.ordFind(y)
   IF nax = NIL THEN RETURN NIL
   nax.unSet(x)
   IF nax.countX() = NIL
      self.remove(nax)
      END nax
   ENDIF
ENDPROC

PROC cmpMapYX(nayx:PTR TO collectionYX) OF collectionYX
   DEF nax1:PTR TO collectionX
   DEF nax2:PTR TO collectionX
   IF self.cmpMap(nayx) = FALSE THEN RETURN FALSE
   nax1 := self.first()
   nax2 := nayx.first()
   WHILE nax1
      IF nax1.cmpMapX(nax2) = FALSE THEN RETURN FALSE
      nax1 := nax1.next
      nax2 := nax2.next
   ENDWHILE
ENDPROC TRUE

PROC applyNewFrom(nayx:PTR TO collectionYX) OF collectionYX
   DEF nax1:PTR TO collectionX
   DEF nax2:PTR TO collectionX
   DEF newnax:PTR TO collectionX
   nax1 := self.first()
   nax2 := nayx.first()
   WHILE nax2
      IF nax1.id = nax2.id
         nax1 := nax1.next
         nax2 := nax2.next
      ELSEIF nax1.id > nax2.id
         NEW newnax.collectionX()
         newnax.id := nax2.id
         nax2.cloneContentsTo(newnax)
         self.ordInsert(newnax)
         nax2 := nax2.next
      ELSE -> nax1.id < nax2
         nax1 := nax1.next
      ENDIF
   ENDWHILE
ENDPROC

PROC applyAllFrom(nayx:PTR TO collectionYX) OF collectionYX
   DEF nax1:PTR TO collectionX
   DEF nax2:PTR TO collectionX
   DEF newnax:PTR TO collectionX
   nax1 := self.first()
   nax2 := nayx.first()
   WHILE nax2
      IF nax1.id = nax2.id
         nax2.cloneContentsTo(nax1)
         nax1 := nax1.next
         nax2 := nax2.next
      ELSEIF nax1.id > nax2.id
         NEW newnax.collectionX()
         newnax.id := nax2.id
         nax2.cloneContentsTo(newnax)
         self.ordInsert(newnax)
         nax2 := nax2.next
      ELSE -> nax1.id < nax2
         nax1 := nax1.next
      ENDIF
   ENDWHILE
ENDPROC

PROC applyORFrom(nayx:PTR TO collectionYX) OF collectionYX
   DEF nax1:PTR TO collectionX
   DEF nax2:PTR TO collectionX
   DEF newnax:PTR TO collectionX
   nax1 := self.first()
   nax2 := nayx.first()
   WHILE nax2
      IF nax1.id = nax2.id
         nax1 := nax1.next
         nax2 := nax2.next
         nax1.applyORFrom(nax2)
      ELSEIF nax1.id > nax2.id
         NEW newnax.collectionX()
         newnax.id := nax2.id
         nax2.cloneContentsTo(newnax)
         self.ordInsert(newnax)
         nax2 := nax2.next
      ELSE -> nax1.id < nax2
         nax1 := nax1.next
      ENDIF
   ENDWHILE
ENDPROC

PROC applyExistsFrom(nayx:PTR TO collectionYX) OF collectionYX
   DEF nax1:PTR TO collectionX
   DEF nax2:PTR TO collectionX
   nax1 := self.first()
   nax2 := nayx.first()
   WHILE nax2
      IF nax1.id = nax2.id
         nax1 := nax1.next
         nax2 := nax2.next
         nax1.applyExistsFrom(nax2)
      ELSEIF nax1.id > nax2.id
         nax2 := nax2.next
      ELSE -> nax1.id < nax2
         nax1 := nax1.next
      ENDIF
   ENDWHILE
ENDPROC

PROC applyANDFrom(nayx:PTR TO collectionYX) OF collectionYX
   DEF nax1:PTR TO collectionX
   DEF nax2:PTR TO collectionX
   nax1 := self.first()
   nax2 := nayx.first()
   WHILE nax2
      IF nax1.id = nax2.id
         nax1 := nax1.next
         nax2 := nax2.next
         nax1.applyANDFrom(nax2)
      ELSEIF nax1.id > nax2.id
         nax2 := nax2.next
      ELSE -> nax1.id < nax2
         nax1 := nax1.next
      ENDIF
   ENDWHILE
ENDPROC

PROC applyAveFrom(nayx:PTR TO collectionYX) OF collectionYX
   DEF nax1:PTR TO collectionX
   DEF nax2:PTR TO collectionX
   DEF newnax:PTR TO collectionX
   nax1 := self.first()
   nax2 := nayx.first()
   WHILE nax2
      IF nax1.id = nax2.id
         nax1 := nax1.next
         nax2 := nax2.next
         nax1.applyAveFrom(nax2)
      ELSEIF nax1.id > nax2.id
         NEW newnax.collectionX()
         newnax.id := nax2.id
         newnax.applyAveFrom(nax2)
         self.ordInsert(newnax)
         nax2 := nax2.next
      ELSE -> nax1.id < nax2
         nax1 := nax1.next
      ENDIF
   ENDWHILE
ENDPROC

PROC cloneContentsTo(nayx:PTR TO collectionYX) OF collectionYX
   DEF nax:PTR TO collectionX
   DEF newnax:PTR TO collectionX
   nayx.clear()
   nax := self.first()
   WHILE nax
      NEW newnax.collectionX()
      nax.cloneContentsTo(newnax)
      nayx.addLast(newnax)
      nax := nax.next
   ENDWHILE
ENDPROC self.first()

PROC cleanUp() OF collectionYX
   DEF nax:PTR TO collectionX
   DEF next
   nax := self.first()
   WHILE nax
      next := nax.next
      nax.cleanUp()
      IF nax.countX() = NIL
         self.remove(nax)
         END nax
      ENDIF
      nax := next
   ENDWHILE
ENDPROC

PROC getMaxY() OF collectionYX IS self.getMaxID()

PROC getMinY() OF collectionYX IS self.getMinID()

PROC getMaxX() OF collectionYX
   DEF maxx=NIL
   DEF nax:PTR TO collectionX
   nax := self.first()
   WHILE nax
      maxx := Max(maxx, nax.getMaxX())
      nax := nax.next
   ENDWHILE
ENDPROC maxx

PROC getMinX() OF collectionYX
   DEF minx=NIL
   DEF nax:PTR TO collectionX
   nax := self.first()
   WHILE nax
      minx := Min(minx, nax.getMinX())
      nax := nax.next
   ENDWHILE
ENDPROC minx

PROC end() OF collectionYX IS self.clear()


