
OPT MODULE
OPT EXPORT

MODULE 'other/stderr'

OBJECT object
ENDOBJECT

PROC new(opts=0) OF object
 self.init()
 self.opts(opts)
ENDPROC

PROC init() OF object IS EMPTY

PROC size() OF object IS 4

PROC opts(opts) OF object
 DEF i,next
 IF opts=0 THEN RETURN
 next:=opts
 REPEAT
  FOR i:=0 TO ListLen(next)-1
   i:=self.select(next,i)
  ENDFOR
  next:=Next(next)
 UNTIL next=NIL
ENDPROC

PROC select(opt,i) OF object IS i

PROC error(string,number) OF object
 err_WriteF(string,[number])
 RETURN NIL
ENDPROC

PROC name() OF object IS 'Object'

PROC end() OF object IS EMPTY

PROC halt(i) OF object
 CleanUp(i)
ENDPROC

PROC sameAs(a:PTR TO object) OF object IS IF a.name() = self.name() THEN TRUE ELSE FALSE

PROC differentFrom(a) OF object IS EMPTY

PROC update(a=0) OF object IS EMPTY
