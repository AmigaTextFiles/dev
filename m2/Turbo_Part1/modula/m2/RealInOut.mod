(* @B+ Turn array checking ON *)
IMPLEMENTATION MODULE RealInOut ;

FROM InOut IMPORT Write, WriteString, ReadString,WriteInt ;

PROCEDURE Ten( x : INTEGER ) : REAL ;
(* Returns 10^x as a REAL *)
    VAR res , r : REAL ; neg : BOOLEAN ;
BEGIN
  neg := x < 0 ;
  x := ABS( x ) ;
  res := 1.0 ; r := 10.0 ;
  WHILE x # 0 DO
    IF ODD( x ) THEN res := res * r END ;
    r := r * r ;
    x := x DIV 2
  END ;
  IF neg THEN RETURN 1.0 / res ELSE RETURN res END
END Ten ;

PROCEDURE Expo( x : REAL ) : INTEGER ;
(* Returns exponent (base 2) of x. For IEEE single precision reals only *)
  TYPE cardAr = ARRAY [0..1] OF CARDINAL ;
       VAR ca : cardAr ;
BEGIN
  ca := cardAr(x) ;
  RETURN (ca[0]/128)MOD 256 ; (* Strip out & return bits 1..9 in x *)
END Expo ;

PROCEDURE StrToReal( str : (*@N*) ARRAY OF CHAR ) : REAL ;

  VAR i : LONGINT ;

  PROCEDURE Read(VAR ch : CHAR ) ;
  BEGIN INC(i) ; ch := str[i] ;
  END Read ;

  VAR
    mantissa , exponent : LONGINT ;
    fraction , negativeExp : BOOLEAN ;
    fractionalDigits , truncatedDigits : LONGINT ;
    neg  : BOOLEAN ;
    ch   : CHAR    ;
    real : REAL ;

BEGIN
  fraction := FALSE ; neg := FALSE ;
  mantissa := 0 ; exponent := 0 ;
  fractionalDigits := 0 ; truncatedDigits := 0 ; i := -1 ;
  REPEAT
    Read( ch ) ; (* skip ws *)
  UNTIL (ch # " ") & (ch # "\t") ;
  IF ( ch # "-") & (ch # "+") & ~(("0" <= ch ) & ( ch <= "9" )) THEN
    done := FALSE ; RETURN 0.0
  END ;
  IF ch = "-" THEN neg := TRUE ; Read(ch) ELSIF ch = "+" THEN Read(ch) END ;
  WHILE ( "0" <= ch ) AND ( ch <= "9" ) DO
    IF mantissa <= MAX( LONGINT ) DIV 10 THEN
      mantissa := 10 * mantissa ;
      IF mantissa <= MAX( LONGINT ) - ( ORD( ch ) - ORD ("0") ) THEN
	INC( mantissa , ORD( ch ) - ORD ("0") ) ;
      ELSE INC( truncatedDigits ) ;
      END ;
    ELSE INC( truncatedDigits ) ;
    END ;
    Read(ch);
    IF fraction THEN INC( fractionalDigits ) END ;
    IF ( ch = "." ) & ~fraction THEN
      fraction:= TRUE ; Read(ch) ;
      IF NOT(("0" <= ch ) & ( ch <= "9" )) THEN done := FALSE ; RETURN 0.0 END
    END
  END ;
  IF ch = 'E' THEN Read(ch) ;
    IF    ch = "+" THEN negativeExp := FALSE ; Read(ch)
    ELSIF ch = "-" THEN negativeExp := TRUE  ; Read(ch)
    ELSE negativeExp := FALSE
    END ;
    IF NOT(("0" <= ch ) & ( ch <= "9" )) THEN done := FALSE ; RETURN 0.0 END ;
    WHILE ( "0" <= ch ) AND ( ch <= "9" ) DO
      exponent := 10 * exponent + ORD( ch ) - ORD("0") ;
      Read( ch )
    END ;
    IF negativeExp THEN exponent := -exponent END
  END ;
  DEC( exponent , fractionalDigits - truncatedDigits ) ;
  IF neg THEN real := -( FLOAT( mantissa ) * Ten( exponent ) )
  ELSE real := FLOAT( mantissa ) * Ten( exponent )
  END ;
  done := Expo( real ) # 255 ;
  RETURN real
END StrToReal ;

VAR
  buff : ARRAY [0..255] OF CHAR ;

PROCEDURE ReadReal( VAR r : REAL ) ;
BEGIN ReadString(buff) ; r := StrToReal(buff)
END ReadReal ;

PROCEDURE WriteReal( x : REAL ; n : INTEGER ) ;
(* Modified from Oberon texts module *)
  VAR
    e , i : INTEGER ;
   x0 ,xx : REAL ;
        d : ARRAY [0..9] OF CHAR ;
BEGIN
  e := Expo( x ) ;
  WriteInt(e,10);
  IF e = 0 THEN
    REPEAT Write(" "); DEC(n) UNTIL n <= 3 ;
    WriteString("  0")
  ELSIF e = 255 THEN
    WHILE n > 4 DO Write(" ") ; DEC( n ) END ;
    WriteString(" NaN")
  ELSE
    IF n <= 9 THEN n := 3 ELSE DEC( n, 6 ) END ;
    WHILE n > 7 DO Write(" ") ; DEC( n ) END ;
    (* there are 3 <= n <= 7 digits to be written *)
    xx := x ; x := ABS(x) ;
    e := VAL( LONGINT, e - 127 ) * 77 DIV 256 ;
    IF e >= 0 THEN x := x / Ten(e) ELSE x := Ten(-e) * x END ;
    IF x >= 10.0 THEN x := 0.1 * x ; INC(e) END ;
    x0 := Ten( n-1 ) ; x := x0*x + 0.5 ;
    IF x >= 10.0*x0 THEN x := 0.1 * x ; INC( e ) END ;
    i := 0 ;
    REPEAT
      d[i] := CHR( TRUNC(x) MOD 10 + 30H ) ; x := x / 10.0 ; INC (i)
    UNTIL i = n ;
    IF e >= 0 THEN Write(" ") END ;
    IF xx < 0.0 THEN Write("-") ELSE Write(" ") END ;
    IF ( e > 0 ) & ( e < n ) THEN
      INC( e ) ;
      REPEAT DEC( n ) ; Write( d[n] ) ; DEC( e ) UNTIL e = 0 ;
      IF n = 0 THEN WriteString(".0E0") ; RETURN ELSE Write(".") END ;
      REPEAT DEC( n ) ; Write( d[n] ) UNTIL n = 0
    ELSIF ( e < 0 ) & ( ABS(e) < n ) THEN
      WriteString("0.");
      INC( e ) ;
      WHILE e # 0 DO Write("0") ; DEC( n ) ; INC(e) END ;
      IF n # 0 THEN REPEAT DEC(n) ; Write( d[n] ) UNTIL n = 0 END
    ELSE
      DEC( n ) ; Write(d[n]) ; Write(".") ;
      REPEAT DEC( n ) ; Write( d[n] ) UNTIL n = 0
    END ;
    Write("E") ;
    IF e < 0 THEN Write("-") ; e := -e END ;
    Write( CHR(e DIV 10 + 30H ) ) ;
    Write( CHR(e MOD 10 + 30H ) )
  END
END WriteReal ;

END RealInOut.
