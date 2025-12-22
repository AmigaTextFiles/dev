
' A test program for the print_lyt.o functions.
' (C) 2014  Lorence Lombardo.

' See "print_lyt.b" for more info


#include <SUBmods/print_lyt.h>


putsn("")

putsn("test this text")

putsn(" h="+Hex$(11)+" d="+Str$(161)+" c="+Chr$(65)+" o="+Oct$(333))

puts("i got no EOL")

putsn("")

putsn("")

If SYSTEM>35 then
   DECLARE FUNCTION VPrintf& LIBRARY 
   DECLARE FUNCTION PutStr& LIBRARY
   l$=chr$(10)
   numba%=69
   VPrintf("This number is %d."+l$, @numba%)
   PutStr ("This is the end."+l$+l$)
end if
