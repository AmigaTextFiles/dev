OPT MODULE

MODULE '*xliv'
MODULE '*newArrayX'

EXPORT OBJECT newArrayYX
   PRIVATE
   ylist:PTR TO xliv
ENDOBJECT

PROC newArrayYX() OF newArrayYX IS NEW self.ylist

PROC setE(y, x, value) OF newArrayYX
   DEF xna:PTR TO newArrayX
   DEF ynode:PTR TO xniv
   ynode := self.ylist.find(y)
   IF ynode = NIL
      ynode := self.ylist.create_xniv(y)
      NEW xna.newArrayX()
      ynode.value := xna
   ENDIF
 
   xna.setE(x, value)
ENDPROC

PROC getE(y, x) OF newArrayYX
   DEF ynode:PTR TO xniv
   DEF xna:PTR TO newArrayX
   ynode := self.ylist.find(y)
   IF ynode = NIL THEN RETURN NIL
   xna := ynode.value
ENDPROC xna.getE(x)

PROC unsetE(y, x) OF newArrayYX
   DEF ynode:PTR TO xniv
   DEF xna:PTR TO newArrayX
   ynode := self.ylist.find(y)
   IF ynode = NIL THEN RETURN NIL
   xna := ynode.value
   xna.unsetE(x)
   IF xna.countX() = NIL
      END xna
      self.ylist.delete_xniv(ynode)
   ENDIF
ENDPROC

PROC countY() OF newArrayYX IS self.ylist.count()



PROC clearA() OF newArrayYX
   DEF ynode:PTR TO xniv
   DEF xna:PTR TO newArrayX
   ynode := self.ylist.first()
   WHILE ynode
      xna := ynode.value
      END xna
      self.ylist.delete_xniv(ynode)
      ynode := ynode.next
   ENDWHILE
ENDPROC

PROC end() OF newArrayYX
   self.clearA()
   END self.ylist
ENDPROC

PROC getnewArrayX(y) OF newArrayYX
   DEF n:PTR TO xniv
   n := self.ylist.find(y)
   IF n = NIL THEN RETURN NIL
ENDPROC n.value
