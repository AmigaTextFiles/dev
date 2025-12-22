OPT MODULE

MODULE '*dBMapYX'
MODULE '*xli'

EXPORT OBJECT dBMapZYX OF xli
ENDOBJECT

PROC private_Methods_From_Here() OF dBMapZYX IS EMPTY

PROC dBMapZYX() OF dBMapZYX IS NIL

PROC set(z, y, x) OF dBMapZYX
   DEF xm:PTR TO dBMapYX
   xm := self.find(z)
   IF xm = NIL
      NEW xm.dBMapYX()
      self.ordInsert(xm)
   ENDIF
   xm.set(y, x)
ENDPROC

PROC clr(z, y, x) OF dBMapZYX
   DEF xm:PTR TO dBMapYX
   xm := self.find(z)
   IF xm = NIL THEN RETURN NIL
   xm.clr(y, x)
   IF xm.count() = NIL
      END xm
      self.remove(xm)
   ENDIF
ENDPROC

PROC get(z, y, x) OF dBMapZYX
   DEF xm:PTR TO dBMapYX
   xm := self.find(z)
   IF xm = NIL THEN RETURN NIL
ENDPROC xm.get(y, x)

PROC count() OF dBMapZYX
   DEF xm:PTR TO dBMapYX
   DEF count=NIL
   xm := self.first()
   WHILE xm
      count := count + xm.count()
      xm := xm.next
   ENDWHILE
ENDPROC count

PROC getMaxX() OF dBMapZYX
   DEF xm:PTR TO dBMapYX
   DEF mi=NIL
   xm := self.first()
   WHILE xm
      mi := Max(mi, xm.getMaxX())
      xm := xm.next
   ENDWHILE
ENDPROC mi

PROC getMinX() OF dBMapZYX
   DEF xm:PTR TO dBMapYX
   DEF mi=NIL
   xm := self.first()
   WHILE xm
      mi := Min(mi, xm.getMinX())
      xm := xm.next
   ENDWHILE
ENDPROC mi

PROC getMaxY() OF dBMapZYX
   DEF xm:PTR TO dBMapYX
   DEF mi=NIL
   xm := self.first()
   WHILE xm
      mi := Max(mi, xm.getMaxY())
      xm := xm.next
   ENDWHILE
ENDPROC mi

PROC getMinY() OF dBMapZYX
   DEF xm:PTR TO dBMapYX
   DEF mi=NIL
   xm := self.first()
   WHILE xm
      mi := Min(mi, xm.getMinY())
      xm := xm.next
   ENDWHILE
ENDPROC mi

PROC getMaxZ() OF dBMapZYX IS self.getMaxID()

PROC getMinZ() OF dBMapZYX IS self.getMinID()

PROC clear() OF dBMapZYX
   DEF xm:PTR TO dBMapYX
   DEF next
   xm := self.first()
   WHILE xm
      next := xm.next
      self.remove(xm)
      END xm
      xm := next
   ENDWHILE
ENDPROC

PROC getDBMapYX(z) OF dBMapZYX
ENDPROC self.find(z)

PROC cmp(dbmzyx:PTR TO dBMapZYX) OF dBMapZYX
   DEF xm:PTR TO dBMapYX
   DEF xm2:PTR TO dBMapYX
   xm := self.first()
   xm2 := dbmzyx.first()
   WHILE (xm AND xm2)
      IF xm.id <> xm2.id THEN RETURN FALSE
      IF xm.cmp(xm2) = FALSE THEN RETURN FALSE
      xm := xm.next
      xm2 := xm2.next
   ENDWHILE
ENDPROC TRUE

PROC or(dbmzyx:PTR TO dBMapZYX) OF dBMapZYX
   DEF thisnode:PTR TO dBMapYX
   DEF thatnode:PTR TO dBMapYX
   DEF newnode:PTR TO dBMapYX
   thisnode := self.first()
   thatnode := dbmzyx.first()
   WHILE thatnode
      IF thisnode.id < thatnode.id
         thisnode := thisnode.next
      ELSEIF thisnode = thatnode
         thisnode.or(thatnode)
         thisnode := thisnode.next
         thatnode := thatnode.next
      ELSE
         NEW newnode.dBMapYX()
         newnode.id := thatnode.id
         self.ordInsert(newnode)
         thatnode := thatnode.next
      ENDIF
   ENDWHILE
ENDPROC

PROC xor(dbmzyx:PTR TO dBMapZYX) OF dBMapZYX
   DEF thisnode:PTR TO dBMapYX
   DEF thatnode:PTR TO dBMapYX
   DEF newnode:PTR TO dBMapYX
   thisnode := self.first()
   thatnode := dbmzyx.first()
   WHILE thatnode
      IF thisnode.id < thatnode.id
         thisnode := thisnode.next
      ELSEIF thisnode = thatnode
         thisnode.xor(thatnode)
         thisnode := thisnode.next
         thatnode := thatnode.next
      ELSE
         NEW newnode.dBMapYX()
         newnode.id := thatnode.id
         self.ordInsert(newnode)
         thatnode := thatnode.next
      ENDIF
   ENDWHILE
ENDPROC

PROC and(dbmzyx:PTR TO dBMapZYX) OF dBMapZYX
   DEF thisnode:PTR TO dBMapYX
   DEF thatnode:PTR TO dBMapYX
   thisnode := self.first()
   thatnode := dbmzyx.first()
   WHILE thisnode
      IF thisnode.id < thatnode.id
         thisnode := thisnode.next
      ELSEIF thisnode = thatnode
         thisnode.and(thatnode)
         thisnode := thisnode.next
         thatnode := thatnode.next
      ELSE
         thatnode := thatnode.next
      ENDIF
   ENDWHILE
ENDPROC

PROC cloneContentsTo(zyx:PTR TO dBMapZYX) OF dBMapZYX
   DEF thisnode:PTR TO dBMapYX
   DEF thatnode:PTR TO dBMapYX
   zyx.clear()
   thisnode := self.first()
   WHILE thisnode
      NEW thatnode.dBMapYX()
      thisnode.cloneContentsTo(thatnode)
      zyx.ordInsert(thatnode)
      thisnode := thisnode.next
   ENDWHILE
ENDPROC zyx


PROC end() OF dBMapZYX IS self.clear()


