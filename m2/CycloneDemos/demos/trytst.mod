MODULE trytst;

(* Little program to test TRY..EXCEPT/FINALY..END block *)

FROM SYSTEM IMPORT ASSEMBLE;
FROM ModulaLib IMPORT ExceptNr,Raise;
IMPORT io:InOut;

VAR j:INTEGER;

PROCEDURE Test1;
BEGIN
 TRY
  j:=5;
 FINALLY
  io.WriteInt(j,3); io.WriteLn;
  io.WriteInt(ExceptNr,3); io.WriteLn;
 END
END Test1;

PROCEDURE Test2;
VAR i:INTEGER;
BEGIN
 TRY
  io.WriteString("Try1\n");
  TRY
   io.WriteString(" Try2\n");
  EXCEPT
   io.WriteString(" Except2\n");
  END;
  Raise(1);
 EXCEPT
   io.WriteString("Except1\n");
   Raise(10); (* This raise must be end up in the close part of the module *)
 END;
END Test2;



BEGIN
 Test1;
 Test2;
 j:=3;
CLOSE
  io.WriteInt(ExceptNr,3); io.WriteLn;

  (* A Raise here would recall the close part, which will lead to
   * a never ended loop 
   * However I want to change this but at the moment, don't know yet
   * how to implement it.
   *)

END trytst.
