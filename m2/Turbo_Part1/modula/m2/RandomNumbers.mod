IMPLEMENTATION MODULE RandomNumbers ;
(* Reiser M. & Wirth N. (1992). Programming in OBERON.ACM press	*)

VAR
  z : LONGINT ;

PROCEDURE Uniform( ) : REAL ;

CONST
  a = 16807 ;
  m = 2147483647 ;
  q = m DIV a ;
  r = m MOD a ;

VAR
  gamma : LONGINT ;

BEGIN
  gamma := a*(z MOD q)-r*(z DIV q) ;
  IF gamma>0 THEN z := gamma ELSE z := gamma+m END ;
  RETURN FLOAT(z)*(1.0/FLOAT(m))
END Uniform ;

PROCEDURE SetSeed( seed : LONGINT ) ;
BEGIN z := seed ;
END SetSeed ;

BEGIN z := 314159
END RandomNumbers.
