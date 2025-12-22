MODULE Cat ;

FROM SYSTEM IMPORT STRING ;
IMPORT SIO := StdIO , SLib := StdLib , M2 := M2Lib ;

VAR
  i	   : INTEGER ;
  buf	   : ARRAY [0..511] OF CHAR ;
  fi	   : SIO.FILEPtr ;

PROCEDURE brk( ) : LONGINT ;
BEGIN SIO.puts("Well, if you insist...") ; RETURN 1
END brk ;

BEGIN
  (* StdLib.expand_args will expand any command line wildcard arguments *)
  SLib.expand_args( M2.argc, M2.argv , M2.argc , M2.argv ) ;
  IF M2.argc = 1 THEN SIO.puts("cat <files>") ; SLib.exit( 1 ) END ;
  SLib.onbreak( brk ) ;
  FOR i := 1 TO M2.argc-1 DO
    fi := SIO.fopen( M2.argv^[i] , "r" );
    IF fi # NIL THEN
      WHILE SIO.fgets( buf , SIZE( buf ) , fi ) # NIL DO
	SIO.fputs( buf , SIO.stdout )
      END;
      SIO.fclose( fi )
    ELSE SIO.printf( "Unable to open %s\n" , M2.argv^[i] )
    END
  END
END Cat.

