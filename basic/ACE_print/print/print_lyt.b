
' Alternative print lib for ACE, Lyt version ;)
' (C) 2014  Lorence Lombardo.

' Intended for use in conjunction with ACE commands,
' Chr$, Str$, Hex$, Oct$, CSTR, etc...

' When writing for ROM2+ also consider the following:-
' VPrintf, VFPrintf, VFWritef & PutStr from the "dos.library".

' "LIBRARY"  command is not needed here coz ACE automatically
' opens & closes the "dos.library" internally.
  

DECLARE FUNCTION _Write& LIBRARY dos
DECLARE FUNCTION _Output& LIBRARY dos


' Prints a string with no EOL 

SUB puts(s$) EXTERNAL
   _Write (_Output, @s$, Len(s$))
END SUB


' Prints a string with an EOL

SUB putsn(s$) EXTERNAL
   puts(s$+Chr$(10))
END SUB


