MODULE Gurus;

(*$
 
 OverflowChk+

*)

IMPORT NoGuru;

VAR 
 i:INTEGER;
 k:SHORTCARD;
 

BEGIN
 FOR i:=0 TO 4000 DO
  INC(k);                    (* Must give a overflow because k has a range *)                            
 END;                        (* from 0 until 255 *)
END Gurus.
