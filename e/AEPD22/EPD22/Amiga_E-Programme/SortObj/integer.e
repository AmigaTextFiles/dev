-> integer.e is a very SIMPLE object for handling integers.
-> It's writen by Trey Van Riper of the Cheese Olfactory Workshop
OPT MODULE

MODULE '*sortobj'

-> NOTE: In the future, 'integer' will be derived from 'number'.
-> In the meantime, though, I'll just leave it like this.

EXPORT OBJECT integer OF sortobj
 number
ENDOBJECT

-> The all-important 'cmp()' method!

EXPORT PROC cmp(item:PTR TO integer) OF integer
 IF self.number < item.number THEN RETURN -1
 RETURN IF self.number > item.number THEN 1 ELSE 0
ENDPROC

-> write(), to create a string out of the integer.

EXPORT PROC write() OF integer
 DEF out
 out:=String(14)
 StringF(out,'\d',self.number)
ENDPROC out

-> get()ing the integer itself.

EXPORT PROC get() OF integer IS self.number

-> set()ing the integer in some way.

EXPORT PROC set(in) OF integer
 self.number:=in
ENDPROC

-> this object's unique id # is '10'.

EXPORT PROC id() OF integer IS 10
