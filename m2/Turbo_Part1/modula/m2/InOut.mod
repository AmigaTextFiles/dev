IMPLEMENTATION MODULE InOut ;

FROM SYSTEM IMPORT ADR ;
IMPORT StdIO ;

PROCEDURE Write( ch : CHAR ) ;
BEGIN StdIO.putchar(ORD(ch))
END Write ;

PROCEDURE WriteLn ;
BEGIN StdIO.printf("\n")
END WriteLn ;

PROCEDURE WriteString( str : (*@N*) ARRAY OF CHAR ) ;
BEGIN StdIO.printf("%s",str) ;
END WriteString ;

PROCEDURE WriteInt( x : LONGINT ; n : INTEGER ) ;
BEGIN StdIO.printf("%*d",n,x)
END WriteInt ;

PROCEDURE WriteOct( x : LONGINT ; n : INTEGER ) ;
BEGIN StdIO.printf("%*o",n,x)
END WriteOct ;

PROCEDURE WriteHex( x : LONGINT ; n : INTEGER ) ;
BEGIN StdIO.printf("%*X",n,x)
END WriteHex ;

PROCEDURE Read( VAR ch : CHAR ) ;
  VAR i : LONGINT ;
BEGIN
  i := StdIO.fgetc( StdIO.stdin ) ;
  done := i # StdIO.EOF ;
  ch := CHR( i ) ;
END Read ;

PROCEDURE ReadString( VAR str : ARRAY OF CHAR ) ;
BEGIN StdIO.fgets( ADR(str) , HIGH(str)+1 , StdIO.stdin )
END ReadString ;

PROCEDURE ReadInt( VAR x : INTEGER ) ;
  VAR i : LONGINT ;
BEGIN
  done := StdIO.scanf( "%hd" , ADR(x) ) = 1 ;
  REPEAT i := StdIO.getchar() ; UNTIL (i = ORD("\n")) OR (i = StdIO.EOF)
END ReadInt ;

PROCEDURE ReadLongInt( VAR x : LONGINT ) ;
  VAR i : LONGINT ;
BEGIN
  done := StdIO.scanf( "%d" , ADR(x) ) = 1 ;
  REPEAT i := StdIO.getchar() UNTIL (i = ORD("\n")) OR (i = StdIO.EOF)
END ReadLongInt ;

END InOut.
