    
(*########################*)
 IMPLEMENTATION MODULE Str0;             (* v2.1amiga-021989 *)
(*########################*)
(*
   (c) Copyright 1984 Tom Breeden, All Rights Reserved

                           Aglet Software
                           PO Box 3314
                           Charlottesville, VA 22903
*)
   
(*$R-*) (*$D-*)
    
(*
VERSION HISTORY
    
v1.0-010384         -First version for PDP11 system
    
v1.1-051985         -Call to StrSet to initialize NullStr, now it should word
                     for either PDP11 byte sex or M68000 byte sex.

v2.0amiga-062286    -Finally gave in, this implements a null-delimited
                     string system with the same interface.
                    -Also, had to change input open array params to VAR
                     since TDI compiler insists on it.
                    -Also note: the TDI compiler considers all open array params
                     to be of different types from each other, so cannot do
                     a string assignment with them.

v2.1amiga-021989    -For Benchmark compiler, removed VAR where appropriate.
                    -Use compiler switch to disable param copying.
*)
    
(*==============================================================*)
 PROCEDURE StrAsg(InStr:ARRAY OF CHAR; VAR OutStr:ARRAY OF CHAR);
(*==============================================================*)
(*
     This proc assigns an input string to an output string.   

NOTE   1.Efficiency could be improved.

*)
  
VAR i  :CARDINAL;
   
BEGIN

i := 0;
LOOP
   IF i > HIGH(OutStr) THEN
      EXIT
   ELSIF (i > HIGH(InStr)) OR (InStr[i] = 0C) THEN
      OutStr[i] := 0C;
      EXIT;
   ELSE
     OutStr[i] := InStr[i];
     INC(i);
   END;
END;

END StrAsg;
    
(*=========================================*)
 PROCEDURE StrLen(S:ARRAY OF CHAR):CARDINAL;
(*=========================================*)
(*
     Function returns the length of the input string parameter.
*)

VAR len :CARDINAL;
                                                              
BEGIN
    
len := 0;
WHILE (len <= HIGH(S)) AND (S[len] # 0C) DO
   INC(len);
END;

RETURN len;

END StrLen;
    
(*==================================================*)
 PROCEDURE StrSet(VAR S:ARRAY OF CHAR; Len:CARDINAL);
(*==================================================*)
    
BEGIN
    
IF Len <= HIGH(S) THEN
   S[Len] := 0C;
END;
    
END StrSet;
   
BEGIN
    
StrSet(NullStr,0);
   
END Str0.

