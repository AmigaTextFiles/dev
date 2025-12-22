OPT MODULE

EXPORT OBJECT object
ENDOBJECT

PROC new(opts=NIL) OF object IS self.o_empty('new()')

->PROC setAttrs(attrs) OF object IS self.o_bla('setAttrs()')

->PROC getAttrs() OF object IS self.o_bla('getAttrs()')

PROC end() OF object IS EMPTY ->self.o_empty('end()')
                                  /* fw-code */
PROC getObjectSize() OF object IS Long(^self)

PROC getObjectName() OF object IS 'object'

PROC cloneObject() OF object
/* this code is snitched from framework */
  DEF copy:PTR TO LONG
  copy:=FastNew(Long(^self))
  CopyMem(self+(SIZEOF LONG),copy,Long(^self)-(SIZEOF LONG))
ENDPROC copy

PROC copyObjectFrom(other:PTR TO LONG) OF object
           /* fw-code */
   CopyMem(other+4,self+4,Long(^other)-(SIZEOF LONG))
ENDPROC

PROC o_empty(methodname) OF object
   WriteF(' method \s of object \s is EMPTY\n',
            methodname, self.getObjectName())
ENDPROC

PROC printObject() OF object
   DEF longs
   DEF a
   longs := self.getObjectSize() / 4
   WriteF('object \s :\n', self.getObjectName())
   FOR a := 0 TO longs-1
      WriteF('\h[8]\n', Long(self + (a * 4)))
   ENDFOR
ENDPROC

