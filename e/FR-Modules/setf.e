/* setf.m 1.0 (3.7.97) © Frédéric Rodrigues - Freeware
   patching object
*/

OPT MODULE

EXPORT OBJECT setf PRIVATE
  libbase,offset,oldf,newf,enabled
ENDOBJECT

PROC setf(libbase,offset,newfunc) OF setf
  self.libbase:=libbase
  self.offset:=offset
  self.newf:=newfunc
  self.enabled:=TRUE
  Forbid()
  self.oldf:=SetFunction(libbase,offset,newfunc)
  Permit()
ENDPROC

PROC enabled() OF setf IS self.enabled

PROC disable() OF setf
  self.enabled:=FALSE
ENDPROC

PROC enable() OF setf
  self.enabled:=TRUE
ENDPROC

PROC patched() OF setf
  DEF t
  Forbid()
  t:=SetFunction(self.libbase,self.offset,self.oldf)
  SetFunction(self.libbase,self.offset,t)
  Permit()
ENDPROC IF t=self.newf THEN FALSE ELSE TRUE

PROC end() OF setf
  WHILE self.patched() DO Delay(10)
  Forbid()
  SetFunction(self.libbase,self.offset,self.oldf)
  Permit()
ENDPROC

PROC oldfunc() OF setf
  DEF func
  func:=self.oldf
  func()
ENDPROC D0
