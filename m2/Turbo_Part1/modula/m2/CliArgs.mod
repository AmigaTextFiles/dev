IMPLEMENTATION MODULE CliArgs ;

IMPORT M2Lib ;

PROCEDURE GetArgCount( ) : LONGINT ;
BEGIN RETURN M2Lib.argc
END GetArgCount ;

PROCEDURE GetArg( n : LONGINT ; VAR arg : ARRAY OF CHAR ) ;
VAR
  x : LONGINT ;
BEGIN
  IF n > M2Lib.argc-1 THEN
    M2Lib._ErrorReq("CliArgs.GetArg","Invalid argument number")
  END ;
  truncated := FALSE ;
  FOR x := 0 TO HIGH( arg ) DO
    arg[x] := M2Lib.argv^[n]^[x] ;
    IF arg[x] = 0C THEN RETURN END ;
    IF x = HIGH( arg ) THEN arg[x] := 0C ; truncated := TRUE END
  END
END GetArg ;

END CliArgs.
