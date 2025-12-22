
' Alternative print include for ACE
' (C) 2014  Lorence Lombardo.

' Intended for "ace" directory.

' You need to have a ` LIBRARY "exec.library" ' at the
' top of your program & a ` LIBRARY CLOSE "exec.library" '
' at the end of print related stuff,
' OR "LIBRARY" equivalent.


DECLARE FUNCTION _Write& LIBRARY dos
DECLARE FUNCTION _Output& LIBRARY dos
DECLARE FUNCTION AllocMem& LIBRARY exec
DECLARE FUNCTION FreeMem& LIBRARY exec
DECLARE FUNCTION RawDoFmt& LIBRARY exec


SUB sprintf$(fmt$, args&)
   vspfPCP& = &H16C04E75  
   buff&=AllocMem(1024,1) 
   buf$=""
   If buff& then
      RawDoFmt (@fmt$, args&, @vspfPCP&, buff&)
      buf$=CSTR(buff&)
      FreeMem (buff&, 1024)
   End If
   sprintf$ = buf$
END SUB

' Here are some basic types that can be used with sprintf$ :-

' %ld = decimal
' %lu = unsigned ROM2.0+ very handy  v37+
' %lx = hexadecimal
' %lc = character 0-255
' %s  = string

' For a more detailed explanation please refer to RKM RawDoFmt
' Also C/C++ printf/sprintf could be of assistance



' Prints a string with no EOL 

SUB puts(s$)
   _Write (_Output, @s$, Len(s$))
END SUB


' Converts a decimal number to a string

SUB DStr$(num&)
   DStr$ = sprintf$("%ld", @num&)
END SUB


' Converts a decimal number to an unsigned string, needs v37+

SUB UStr$(num&)
   UStr$ = sprintf$("%lu", @num&)
END SUB


' Converts a decimal number to a hex string

SUB HStr$(num&)
   HStr$ = sprintf$("%lx", @num&)
END SUB


' Converts a decimal number to a character string

SUB Byt$(num%)
   Byt$ = sprintf$("%c", @num%)
END SUB


' Prints a string with an EOL

SUB putsn(s$)
   puts(s$+Byt$(10))
END SUB


