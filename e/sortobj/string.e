OPT MODULE

MODULE '*sortobj','*integer'

-> string.e: a derived object from 'sortobj' to handle
-> strings.

EXPORT OBJECT string OF sortobj
 item
 len:PTR TO integer	-> I made this 'integer' in order to use the cmp in there.
ENDOBJECT

-> We need to have a way to initialize 'len'.

PROC init() OF string
 DEF tmp:PTR TO integer
 NEW tmp.new()
 self.len := tmp
ENDPROC

-> We have to dispose of the string and the 'len' pointer.

PROC end() OF string
 DEF tmp:PTR TO integer
 Dispose(self.item) -> get rid of the string.
 tmp:=self.len
 END tmp	    -> get rid of its length, too
ENDPROC

-> cmp() compares two strings quickly.. but it doesn't handle international characters.
-> Many improvements could be made to this, I'm sure, but it has the virtue of being
-> fairly quick.  Perhaps locale.library support would be nice.

EXPORT PROC cmp(item:PTR TO string) OF string
 DEF i,inner,outer
 inner:=self.item
 outer:=item.item
 FOR i := 0 TO IF self.len.lt(item.len) THEN self.len.get()-1 ELSE item.len.get()-1
  IF inner[i] < outer[i] THEN RETURN -1
  IF inner[i] > outer[i] THEN RETURN 1
 ENDFOR
 IF self.len.et(item.len) THEN RETURN 0
 RETURN IF self.len.lt(item.len) THEN -1 ELSE 1
ENDPROC

-> set() lets you put a value into the string.

EXPORT PROC set(in) OF string
 self.len.set(StrLen(in))
 self.item:=in
ENDPROC

-> size() returns the length of the string.

EXPORT PROC size() OF string
 RETURN self.len.get()
ENDPROC

-> NOTE: here write() and get() are synonyms, since it's already a string.

EXPORT PROC write() OF string
 RETURN self.get()
ENDPROC

EXPORT PROC get() OF string
 RETURN self.item
ENDPROC

-> 'string's unique ID is 1.

EXPORT PROC id() OF string IS 1
