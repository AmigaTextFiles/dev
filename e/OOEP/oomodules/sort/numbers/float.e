/*

First draft of a Float object. It's very rudimentary, just to get the
Coordinate going...

Gregor Goldbach
*/

OPT MODULE
OPT EXPORT

MODULE 'oomodules/sort/numbers'

OBJECT float OF number
  value
ENDOBJECT

PROC name() OF float IS 'Float'

PROC set(value) OF float
  self.value := value
ENDPROC

PROC get() OF float IS self.value

PROC cmp(what:PTR TO float) OF float
  IF self.value < what.value THEN RETURN -1
  RETURN IF self.value > what.value THEN 1 ELSE 0
ENDPROC

PROC write() OF float
DEF out

  out := String(42)
  IF out
    RealF(out,self.value,8)
    RETURN out
  ELSE
    RETURN NIL
  ENDIF

ENDPROC

PROC add(in:PTR TO float) OF float
DEF value

  value := !self.get() + in.get()
  self.set( value)
ENDPROC

PROC substract(in:PTR TO float) OF float
  self.set( !self.get() - in.get() )
ENDPROC

PROC multiply(in:PTR TO float) OF float
  self.set( !self.get() * in.get() )
ENDPROC

PROC divide(in:PTR TO float) OF float
  self.set( !self.get() / in.get() )
ENDPROC



->PROC power(in:PTR TO float) OF float IS EMPTY

->PROC max(in:PTR TO float) OF float IS EMPTY

PROC abs() OF float
DEF value
  IF !self.value < 0
    value := self.get()
    RETURN ! value * (-1)
  ELSE
    RETURN self.get()
  ENDIF
ENDPROC

PROC neg() OF float
  self.set( !0-self.get())
ENDPROC

->PROC min(in:PTR TO float) OF float IS EMPTY

->PROC sign() OF float IS EMPTY

->PROC bounds(min:PTR TO float,max:PTR TO float) OF float IS EMPTY

->PROC rnd(min=0:PTR TO float,max=0:PTR TO float) IS EMPTY

PROC copy(to:PTR TO float) OF float
  to.set( self.get() )
ENDPROC

PROC flt2int() OF float
DEF value:PTR TO float,dummy1,dummy2

  NEW value.new()

  value.set( self.get() + 0.5)
  value.set(Ffloor(value.get()))
  RETURN !value.get()!
ENDPROC
