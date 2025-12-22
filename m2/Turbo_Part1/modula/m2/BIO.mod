IMPLEMENTATION MODULE BIO ;

FROM FIO IMPORT
  StdIn, StdOut, StdErr,			(* variables       *)
  EndType, File, Status,			(* types           *)
						(* procedures      *)
  Close, EOF, EOLN, FindPosition,
  IOStatus, FlushFile, ReportError,
  ReadChar, ReadInteger, ReadLine,
  ReadReal, ReadLongReal, ReadString, ReadLn,
  WriteChar, WriteInteger, WriteLine,
  WriteReal, WriteRealFmt, WriteLongReal, WriteLongRealFmt, WriteString,
  WriteLn, UnReadChar ;

PROCEDURE IsMore( ) : BOOLEAN ;
BEGIN RETURN NOT EOF( StdIn )
END IsMore ;

PROCEDURE IsEndOfLine( ) : BOOLEAN ;
BEGIN RETURN EOLN( StdIn )
END IsEndOfLine ;

PROCEDURE PushBackChar( c : CHAR ) ;
BEGIN UnReadChar( StdIn, c )
END PushBackChar ;

PROCEDURE GetLn( VAR s : ARRAY OF CHAR ) ;
BEGIN ReadLn( StdIn, s )
END GetLn ;

PROCEDURE PutLn( s : ARRAY OF CHAR );
BEGIN WriteLn( StdOut, s )
END PutLn ;

PROCEDURE GetInteger( VAR int : LONGINT ) ;
BEGIN
  LOOP
   int := ReadInteger( StdIn ) ;
   IF IOStatus( StdIn ) = NoError THEN EXIT END ;
     WriteString( StdErr, "Not a valid Integer. Try again: ") ;
     FlushFile( StdErr ) ;
     ReadLine( StdIn )
  END
END GetInteger ;

PROCEDURE PutInteger( int : LONGINT ) ;
BEGIN WriteInteger( StdOut, int )
END PutInteger ;

PROCEDURE GetReal( VAR real : REAL ) ;
BEGIN
  LOOP
    real := ReadReal( StdIn ) ;
    IF IOStatus( StdIn ) = NoError THEN EXIT END ;
    WriteString( StdErr, "Not a valid REAL. Try again: ") ;
    FlushFile( StdErr ) ;
    ReadLine( StdIn )
  END
END GetReal ;

PROCEDURE PutReal( real : REAL ) ;
BEGIN WriteReal( StdOut, real )
END PutReal ;

PROCEDURE PutRealFmt( r : REAL; width, decplaces : LONGINT ) ;
BEGIN WriteRealFmt( StdOut, r, width, decplaces )
END PutRealFmt ;

PROCEDURE GetLongReal( VAR longReal : LONGREAL ) ;
BEGIN
  LOOP
    longReal := ReadLongReal( StdIn ) ;
    IF IOStatus( StdIn ) = NoError THEN EXIT END ;
    WriteString( StdErr, "Not a valid LONGREAL. Try again: ") ;
    FlushFile( StdErr ) ;
    ReadLine( StdIn )
  END
END GetLongReal ;

PROCEDURE PutLongReal( lr : LONGREAL ) ;
BEGIN WriteLongReal( StdOut, lr )
END PutLongReal ;

PROCEDURE PutLongRealFmt( r : LONGREAL ; width, decplaces : LONGINT ) ;
BEGIN WriteLongRealFmt( StdOut, r, width, decplaces )
END PutLongRealFmt ;

PROCEDURE GetChar( VAR ch : CHAR ) ;
BEGIN ch := ReadChar( StdIn )
END GetChar ;

PROCEDURE InspectChar( ) : CHAR ;
 VAR ch : CHAR ;
BEGIN
  IF EOF( StdIn ) THEN
    RETURN 0C
  ELSE
    ch := ReadChar( StdIn ) ;
    UnReadChar( StdIn, ch ) ;
    RETURN ch
  END
END InspectChar;

PROCEDURE PutChar( ch : CHAR ) ;
BEGIN WriteChar( StdOut, ch )
END PutChar ;

PROCEDURE GetString( VAR str : ARRAY OF CHAR ) ;
BEGIN
  LOOP
    str[0] := 0C ;
    ReadString( StdIn, str ) ;
    IF IOStatus( StdIn ) = NoError THEN EXIT END ;
    WriteString( StdErr, "Not a valid STRING. Try again: ") ;
    FlushFile( StdErr ) ;
    ReadLine( StdIn )
  END ;
END GetString ;

PROCEDURE PutString( str : (*@N*) ARRAY OF CHAR ) ;
BEGIN WriteString( StdOut, str )
END PutString ;

PROCEDURE GetLine( ) ;
BEGIN ReadLine( StdIn )
END GetLine;

PROCEDURE PutLine( ) ;
BEGIN WriteLine( StdOut )
END PutLine ;

PROCEDURE Flush( ) ;
BEGIN FlushFile( StdOut ) ; FlushFile( StdIn )
END Flush ;

END BIO.
