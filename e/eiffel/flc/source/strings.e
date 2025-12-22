
-> Copyright © 1995, Guichard Damien.

-> string module

OPT MODULE
OPT EXPORT  -> Export all

-> string duplication
PROC clone(str:PTR TO CHAR)
ENDPROC StrCopy(String(StrLen(str)),str,ALL)


-> hash function
PROC hash(key:PTR TO CHAR)
  DEF value=0
  WHILE key[] DO value:=value*13+key[]++
ENDPROC value

