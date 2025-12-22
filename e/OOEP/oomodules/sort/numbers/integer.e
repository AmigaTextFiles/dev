-> integer.e is a very SIMPLE object for handling integers.
-> It's writen by Trey Van Riper of the Cheese Olfactory Workshop
OPT MODULE
OPT EXPORT

MODULE 'oomodules/sort/numbers'

-> NOTE: In the future, 'integer' will be derived from 'number'.
-> In the meantime, though, I'll just leave it like this.

OBJECT integer OF number
 number
ENDOBJECT

-> size() returns how much memory you can expect to use.

PROC size() OF integer IS 8

-> name() returns the name of this kind of object.

PROC name() OF integer IS 'Integer'

-> The all-important 'cmp()' method!

PROC cmp(item:PTR TO integer) OF integer
 IF self.number < item.number THEN RETURN -1
 RETURN IF self.number > item.number THEN 1 ELSE 0
ENDPROC

-> select() doesn't do much.. lets you set a value from new().

PROC select(opt,i) OF integer
 DEF item
 item:=ListItem(opt,i)
 SELECT item
  CASE "set"
   INC i
   self.set(ListItem(opt,i))
 ENDSELECT
ENDPROC i

-> write(), to create a string out of the integer.

PROC write() OF integer
 DEF out
 out:=String(14)
 StringF(out,'\d',self.number)
ENDPROC out

-> get()ing the integer itself.

PROC get() OF integer IS self.number

-> set()ing the integer in some way.

PROC set(in) OF integer
 self.number:=in
ENDPROC

PROC add(in) OF integer
 self.number := self.number + in
ENDPROC

PROC subtract(in) OF integer
 self.number := self.number - in
ENDPROC

PROC divide(in) OF integer
 self.number := self.number / in
ENDPROC

PROC multiply(in) OF integer
 self.number := self.number * in
ENDPROC

-> addition by GG: negate it
PROC negate() OF integer
 self.number := 0 - self.number
ENDPROC

