OPT MODULE

MODULE 'myoo/xl'

OBJECT point OF xni
   value
ENDOBJECT

EXPORT OBJECT d1da OF xli
   PRIVATE
   unsetvalue
ENDOBJECT


PROC d1da() OF d1da IS EMPTY

PROC end() OF d1da
   self.fastdisposeall(SIZEOF point)
ENDPROC

PROC set(x, value) OF d1da
   DEF point:PTR TO point
   point:=self.find(x)
   IF point = NIL
      point:=FastNew(SIZEOF point)
      self.addtail(point)
      point.id:=x
   ENDIF
   point.value:=value
ENDPROC

PROC get(x) OF d1da
   DEF point:PTR TO point
   point:=self.find(x)
ENDPROC point.value

PROC unset(x) OF d1da
   DEF point:PTR TO point
   point:=self.find(x)
   IF point = NIL THEN RETURN NIL
   self.remove(point)
   FastDispose(point, SIZEOF point)
ENDPROC

PROC unsetvalue(val) OF d1da
   self.unsetvalue:=val
ENDPROC

 
