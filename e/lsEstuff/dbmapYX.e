OPT MODULE

MODULE '*dBMapX'
MODULE '*xli'

EXPORT OBJECT dBMapYX OF xli
ENDOBJECT

PROC private_Methods_From_Here() OF dBMapYX IS EMPTY

PROC dBMapYX() OF dBMapYX IS NIL

PROC set(y, x) OF dBMapYX
   DEF xm:PTR TO dBMapX
   xm := self.find(y)
   IF xm = NIL
      NEW xm.dBMapX()
      self.ordInsert(xm)
   ENDIF
   xm.set(x)
ENDPROC

PROC clr(y, x) OF dBMapYX
   DEF xm:PTR TO dBMapX
   xm := self.find(y)
   IF xm = NIL THEN RETURN NIL
   xm.clr(x)
   IF xm.count() = NIL
      END xm
      self.remove(xm)
   ENDIF
ENDPROC

PROC get(y, x) OF dBMapYX
   DEF xm:PTR TO dBMapX
   xm := self.find(y)
   IF xm = NIL THEN RETURN NIL
ENDPROC xm.get(x)

PROC count() OF dBMapYX
   DEF xm:PTR TO dBMapX
   DEF count=NIL
   xm := self.first()
   WHILE xm
      count := count + xm.count()
      xm := xm.next
   ENDWHILE
ENDPROC count

PROC getMaxX() OF dBMapYX
   DEF xm:PTR TO dBMapX
   DEF mi=NIL
   xm := self.first()
   WHILE xm
      mi := Max(mi, xm.getMaxX())
      xm := xm.next
   ENDWHILE
ENDPROC mi

PROC getMinX() OF dBMapYX
   DEF xm:PTR TO dBMapX
   DEF mi=NIL
   xm := self.first()
   WHILE xm
      mi := Min(mi, xm.getMinX())
      xm := xm.next
   ENDWHILE
ENDPROC mi

PROC getMaxY() OF dBMapYX IS self.getMaxID()

PROC getMinY() OF dBMapYX IS self.getMinID()

PROC clear() OF dBMapYX
   DEF xm:PTR TO dBMapX
   DEF next
   xm := self.first()
   WHILE xm
      next := xm.next
      self.remove(xm)
      END xm
      xm := next
   ENDWHILE
ENDPROC

PROC getDBMapX(y) OF dBMapYX IS self.find(y)

PROC cmp(dbmyx:PTR TO dBMapYX) OF dBMapYX
   DEF xm:PTR TO dBMapX
   DEF xm2:PTR TO dBMapX
   xm := self.first()
   xm2 := dbmyx.first()
   WHILE (xm AND xm2)
      IF xm.id <> xm2.id THEN RETURN FALSE
      IF xm.cmp(xm2) = FALSE THEN RETURN FALSE
      xm := xm.next
      xm2 := xm2.next
   ENDWHILE
ENDPROC TRUE

PROC or(dbmyx:PTR TO dBMapYX) OF dBMapYX
   DEF thisnode:PTR TO dBMapX
   DEF thatnode:PTR TO dBMapX
   DEF newnode:PTR TO dBMapX
   thisnode := self.first()
   thatnode := dbmyx.first()
   WHILE thatnode
      IF thisnode.id < thatnode.id
         thisnode := thisnode.next
      ELSEIF thisnode = thatnode
         thisnode.or(thatnode)
         thisnode := thisnode.next
         thatnode := thatnode.next
      ELSE
         NEW newnode.dBMapX()
         newnode.id := thatnode.id
         self.ordInsert(newnode)
         thatnode := thatnode.next
      ENDIF
   ENDWHILE
ENDPROC

PROC xor(dbmyx:PTR TO dBMapYX) OF dBMapYX
   DEF thisnode:PTR TO dBMapX
   DEF thatnode:PTR TO dBMapX
   DEF newnode:PTR TO dBMapX
   thisnode := self.first()
   thatnode := dbmyx.first()
   WHILE thatnode
      IF thisnode.id < thatnode.id
         thisnode := thisnode.next
      ELSEIF thisnode = thatnode
         thisnode.xor(thatnode)
         thisnode := thisnode.next
         thatnode := thatnode.next
      ELSE
         NEW newnode.dBMapX()
         newnode.id := thatnode.id
         self.ordInsert(newnode)
         thatnode := thatnode.next
      ENDIF
   ENDWHILE
ENDPROC

PROC and(dbmyx:PTR TO dBMapYX) OF dBMapYX
   DEF thisnode:PTR TO dBMapX
   DEF thatnode:PTR TO dBMapX
   thisnode := self.first()
   thatnode := dbmyx.first()
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

PROC cloneContentsTo(yx:PTR TO dBMapYX) OF dBMapYX
   DEF thisnode:PTR TO dBMapX
   DEF thatnode:PTR TO dBMapX
   yx.clear()
   thisnode := self.first()
   WHILE thisnode
      NEW thatnode.dBMapX()
      thisnode.cloneContentsTo(thatnode)
      yx.ordInsert(thatnode)
      thisnode := thisnode.next
   ENDWHILE
ENDPROC yx


PROC end() OF dBMapYX IS self.clear()


