MODULE ArgTest ;

IMPORT CliArgs, InOut ;

VAR
  argArray : ARRAY [0..5] OF CHAR ;
  		(* In reality you would declare a much bigger array!          *)
  		(* We declare a small one to illustrate the truncation effect *)

  x : LONGINT ;

BEGIN
  FOR x := 0 TO CliArgs.GetArgCount()-1 DO
    CliArgs.GetArg( x, argArray ) ;
    InOut.WriteString( argArray ) ;
    IF CliArgs.truncated THEN InOut.WriteString(" (truncated)") END ;
    InOut.WriteLn
  END
END ArgTest.
