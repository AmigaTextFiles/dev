OPT MODULE

MODULE '*xliv'
MODULE '*newArrayX'
MODULE '*newArrayYX'

EXPORT OBJECT newArrayZYX
   PRIVATE
   zlist:PTR TO xliv
ENDOBJECT

PROC newArrayZYX() OF newArrayZYX IS NEW self.zlist

PROC setE(z, y, x, value) OF newArrayZYX
   DEF n:PTR TO xniv
   DEF nayx:PTR TO newArrayYX
   n := self.zlist.find(z)
   IF n = NIL
      n := self.zlist.create_xniv(z)
      NEW nayx.newArrayYX()
      n.value := nayx
   ENDIF

   nayx.setE(y, x, value)
ENDPROC

PROC getE(z, y, x) OF newArrayZYX
   DEF n:PTR TO xniv
   DEF nayx:PTR TO newArrayYX
   n := self.zlist.find(z)
   IF n = NIL THEN RETURN NIL
   nayx := n.value
ENDPROC nayx.getE(y, x)

PROC unsetE(z, y, x) OF newArrayZYX
   DEF n:PTR TO xniv
   DEF nayx:PTR TO newArrayYX
   n := self.zlist.find(z)
   IF n = NIL THEN RETURN NIL
   nayx := n.value
   nayx.unsetE(y, x)
   IF nayx.countY() = NIL
      END nayx
      self.zlist.delete_xniv(n)
   ENDIF
ENDPROC

PROC clearA() OF newArrayZYX
   DEF n:PTR TO xniv
   DEF nayx:PTR TO newArrayYX
   n := self.zlist.first()
   WHILE n
      nayx := n.value
      END nayx
      self.zlist.delete_xniv(n)
      n := n.next
   ENDWHILE
ENDPROC

PROC end() OF newArrayZYX
   self.clearA()
   END self.zlist
ENDPROC

PROC countZ() OF newArrayZYX IS self.zlist.count()

PROC getnewArrayYX(z) OF newArrayZYX
   DEF n:PTR TO xniv
   n := self.zlist.find(z)
   IF n = NIL THEN RETURN NIL
ENDPROC n.value
