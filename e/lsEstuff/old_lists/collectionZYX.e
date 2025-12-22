OPT MODULE

MODULE '*xli'
MODULE '*collectionYX'

EXPORT OBJECT collectionZYX OF xli
ENDOBJECT

PROC private_Methods_From_Here() OF collectionZYX IS EMPTY

PROC collectionZYX() OF collectionZYX IS TRUE

PROC clear() OF collectionZYX
   DEF nayx:PTR TO collectionZYX
   DEF next
   nayx := self.first()
   WHILE nayx
      next := nayx.next
      self.remove(nayx)
      END nayx
      nayx := next
   ENDWHILE
ENDPROC

PROC scrollX(amount) OF collectionZYX
   DEF nayx:PTR TO collectionYX
   nayx := self.first()
   WHILE nayx
      nayx.scrollX(amount)
      nayx := nayx.next
   ENDWHILE
ENDPROC

PROC scrollZ(amount) OF collectionZYX IS self.scroll(amount)

PROC scrollY(amount) OF collectionZYX
   DEF nayx:PTR TO collectionYX
   nayx := self.first()
   WHILE nayx
      nayx.scrollY(amount)
      nayx := nayx.next
   ENDWHILE
ENDPROC

PROC getCollectionYX(z) OF collectionZYX IS self.find(z)

PROC countZYX() OF collectionZYX
   DEF nayx:PTR TO collectionYX
   DEF count=NIL
   nayx := self.first()
   WHILE nayx
      count := count + nayx.countYX()
      INC count
      nayx := nayx.next
   ENDWHILE
ENDPROC

PROC countY() OF collectionZYX
   DEF nayx:PTR TO collectionYX
   DEF count=NIL
   nayx := self.first()
   WHILE nayx
      count := count + nayx.countY()
      nayx := nayx.next
   ENDWHILE
ENDPROC count

PROC countX() OF collectionZYX
   DEF nayx:PTR TO collectionYX
   DEF count=NIL
   nayx := self.first()
   WHILE nayx
      count := count + nayx.countX()
      nayx := nayx.next
   ENDWHILE
ENDPROC count

PROC countYX() OF collectionZYX
   DEF nayx:PTR TO collectionYX
   DEF count=NIL
   nayx := self.first()
   WHILE nayx
      count := count + nayx.countYX()
      nayx := nayx.next
   ENDWHILE
ENDPROC

PROC countZ() OF collectionZYX IS self.countNodes()

PROC getMaxZ() OF collectionZYX IS self.getMaxID()

PROC getMinZ() OF collectionZYX IS self.getMinID()

PROC getMaxY() OF collectionZYX
   DEF nayx:PTR TO collectionYX
   DEF maxy=NIL
   nayx := self.first()
   WHILE nayx
      maxy := Max(maxy, nayx.getMaxY())
      nayx := nayx.next
   ENDWHILE
ENDPROC maxy

PROC getMinY() OF collectionZYX
   DEF nayx:PTR TO collectionYX
   DEF miny=NIL
   nayx := self.first()
   WHILE nayx
      miny := Min(miny, nayx.getMinY())
      nayx := nayx.next
   ENDWHILE
ENDPROC miny

PROC getMaxX() OF collectionZYX
   DEF nayx:PTR TO collectionYX
   DEF maxx=NIL
   nayx := self.first()
   WHILE nayx
      maxx := Max(maxx, nayx.getMaxX())
      nayx := nayx.next
   ENDWHILE
ENDPROC maxx

PROC getMinX() OF collectionZYX
   DEF nayx:PTR TO collectionYX
   DEF minx=NIL
   nayx := self.first()
   WHILE nayx
      minx := Min(minx, nayx.getMinX())
      nayx := nayx.next
   ENDWHILE
ENDPROC minx


PROC set(z, y, x, value) OF collectionZYX
   DEF nayx:PTR TO collectionYX
   nayx := self.ordFind(z)
   IF nayx = NIL
      IF value = NIL THEN RETURN NIL
      NEW nayx.collectionYX()
      nayx.id := y
      self.ordInsert(nayx)
   ENDIF
   nayx.set(y, x, value)
ENDPROC

PROC get(z, y, x) OF collectionZYX
   DEF nayx:PTR TO collectionYX
   nayx := self.ordFind(z)
   IF nayx = NIL THEN RETURN NIL
ENDPROC nayx.get(y, x)

PROC unSet(z, y, x) OF collectionZYX
   DEF nayx:PTR TO collectionYX
   nayx := self.ordFind(z)
   IF nayx = NIL THEN RETURN NIL
   nayx.unSet(y, x)
   IF nayx.countYX() = NIL
      self.remove(nayx)
      END nayx
   ENDIF
ENDPROC

PROC applyNewFrom(nazyx:PTR TO collectionZYX) OF collectionZYX
   DEF nayx1:PTR TO collectionYX
   DEF nayx2:PTR TO collectionYX
   DEF newnayx:PTR TO collectionYX
   nayx1 := self.first()
   nayx2 := nazyx.first()
   WHILE nayx2
      IF nayx1.id = nayx2.id
         nayx1 := nayx1.next
         nayx2 := nayx2.next
      ELSEIF nayx1.id > nayx2.id
         NEW newnayx.collectionYX()
         newnayx.id := nayx2.id
         nayx2.cloneContentsTo(newnayx)
         self.ordInsert(newnayx)
         nayx2 := nayx2.next
      ELSE -> nayx1.id < nayx2
         nayx1 := nayx1.next
      ENDIF
   ENDWHILE
ENDPROC

PROC applyAllFrom(nazyx:PTR TO collectionZYX) OF collectionZYX
   DEF nayx1:PTR TO collectionYX
   DEF nayx2:PTR TO collectionYX
   DEF newnayx:PTR TO collectionYX
   nayx1 := self.first()
   nayx2 := nazyx.first()
   WHILE nayx2
      IF nayx1.id = nayx2.id
         nayx2.cloneContentsTo(nayx1)
         nayx1 := nayx1.next
         nayx2 := nayx2.next
      ELSEIF nayx1.id > nayx2.id
         NEW newnayx.collectionYX()
         newnayx.id := nayx2.id
         nayx2.cloneContentsTo(newnayx)
         self.ordInsert(newnayx)
         nayx2 := nayx2.next
      ELSE -> nayx1.id < nayx2
         nayx1 := nayx1.next
      ENDIF
   ENDWHILE
ENDPROC

PROC applyORFrom(nazyx:PTR TO collectionZYX) OF collectionZYX
   DEF nayx1:PTR TO collectionYX
   DEF nayx2:PTR TO collectionYX
   DEF newnayx:PTR TO collectionYX
   nayx1 := self.first()
   nayx2 := nazyx.first()
   WHILE nayx2
      IF nayx1.id = nayx2.id
         nayx1 := nayx1.next
         nayx2 := nayx2.next
         nayx1.applyORFrom(nayx2)
      ELSEIF nayx1.id > nayx2.id
         NEW newnayx.collectionYX()
         newnayx.id := nayx2.id
         nayx2.cloneContentsTo(newnayx)
         self.ordInsert(newnayx)
         nayx2 := nayx2.next
      ELSE -> nayx1.id < nayx2
         nayx1 := nayx1.next
      ENDIF
   ENDWHILE
ENDPROC

PROC applyExistsFrom(nazyx:PTR TO collectionZYX) OF collectionZYX
   DEF nayx1:PTR TO collectionYX
   DEF nayx2:PTR TO collectionYX
   nayx1 := self.first()
   nayx2 := nazyx.first()
   WHILE nayx2
      IF nayx1.id = nayx2.id
         nayx1 := nayx1.next
         nayx2 := nayx2.next
         nayx1.applyExistsFrom(nayx2)
      ELSEIF nayx1.id > nayx2.id
         nayx2 := nayx2.next
      ELSE -> nayx1.id < nayx2
         nayx1 := nayx1.next
      ENDIF
   ENDWHILE
ENDPROC

PROC applyANDFrom(nazyx:PTR TO collectionZYX) OF collectionZYX
   DEF nayx1:PTR TO collectionYX
   DEF nayx2:PTR TO collectionYX
   nayx1 := self.first()
   nayx2 := nazyx.first()
   WHILE nayx2
      IF nayx1.id = nayx2.id
         nayx1 := nayx1.next
         nayx2 := nayx2.next
         nayx1.applyANDFrom(nayx2)
      ELSEIF nayx1.id > nayx2.id
         nayx2 := nayx2.next
      ELSE -> nayx1.id < nayx2
         nayx1 := nayx1.next
      ENDIF
   ENDWHILE
ENDPROC

PROC applyAveFrom(nazyx:PTR TO collectionZYX) OF collectionZYX
   DEF nayx1:PTR TO collectionYX
   DEF nayx2:PTR TO collectionYX
   DEF newnayx:PTR TO collectionYX
   nayx1 := self.first()
   nayx2 := nazyx.first()
   WHILE nayx2
      IF nayx1.id = nayx2.id
         nayx1 := nayx1.next
         nayx2 := nayx2.next
         nayx1.applyAveFrom(nayx2)
      ELSEIF nayx1.id > nayx2.id
         NEW newnayx.collectionYX()
         newnayx.id := nayx2.id
         newnayx.applyAveFrom(nayx2)
         self.ordInsert(newnayx)
         nayx2 := nayx2.next
      ELSE -> nayx1.id < nayx2
         nayx1 := nayx1.next
      ENDIF
   ENDWHILE
ENDPROC

PROC cloneContentsTo(nazyx:PTR TO collectionZYX) OF collectionZYX
   DEF nayx:PTR TO collectionYX
   DEF newnayx:PTR TO collectionYX
   nazyx.clear()
   nayx := self.first()
   WHILE nayx
      NEW newnayx.collectionYX()
      nayx.cloneContentsTo(newnayx)
      nazyx.addLast(newnayx)
      nayx := nayx.next
   ENDWHILE
ENDPROC self.first()

PROC cmpMapZYX(nazyx:PTR TO collectionZYX) OF collectionZYX
   DEF nayx1:PTR TO collectionYX
   DEF nayx2:PTR TO collectionYX
   IF self.cmpMap(nazyx) = FALSE THEN RETURN FALSE
   nayx1 := self.first()
   nayx2 := nazyx.first()
   WHILE nayx1
      IF nayx1.cmpMapYX(nayx2) = FALSE THEN RETURN FALSE
      nayx1 := nayx1.next
      nayx2 := nayx2.next
   ENDWHILE
ENDPROC TRUE

PROC cleanUp() OF collectionZYX
   DEF nayx:PTR TO collectionYX
   DEF next:PTR TO collectionYX
   nayx := self.first()
   WHILE nayx
      next := nayx.next
      nayx.cleanUp()
      IF nayx.countX() = NIL
         self.remove(nayx)
         END nayx
      ENDIF
      nayx := next
   ENDWHILE
ENDPROC

PROC end() OF collectionZYX IS self.clear()


