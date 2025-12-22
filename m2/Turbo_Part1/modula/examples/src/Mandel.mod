MODULE Mandel ;

FROM SYSTEM IMPORT ADR ;

IMPORT
  E := Exec,
  I := Intuition,
  G := Graphics,
  StdIO,
  StdLib ;

CONST
  realC   = 0.2  ;
  imgC    = 0.15 ;
  zoom    = 6.0  ;
  maxI    = 50   ;
  tv	  = 200  ;
  th	  = 200  ;

VAR
  ns    : I.NewScreen ;
  s     : I.ScreenPtr ;
  rp	: G.RastPortPtr ;
  h     : LONGINT ;
  v     : LONGINT ;
  k     : LONGINT ;
  cr    : SHORTREAL ;
  ci    : SHORTREAL ;
  t     : SHORTREAL ;
  zr    : SHORTREAL ;
  zi    : SHORTREAL ;
  horiF : SHORTREAL ;
  vertF : SHORTREAL ;
  loop  : BOOLEAN   ;
  colarr: ARRAY [0..31] OF INTEGER ;

BEGIN
  ns := [0,0,320,400,5,1,7,G.LACE,I.CUSTOMSCREEN+I.SCREENQUIET,NIL,""];
  s := I.OpenScreen( ns ) ;
  IF s = NIL THEN RETURN 10 END ;
  StdIO.puts("CTRL-C to quit...") ;
  rp := ADR( s^.RastPort ) ;

  colarr := [0000H,0F00H,0F30H,0F60H,0F90H,0FC0H,0FF0H,0CF0H,
	     09F0H,06F0H,03F0H,00F0H,00F3H,00F6H,00F9H,00FCH,
	     00FFH,00CFH,009FH,006FH,003FH,000FH,030FH,060FH,
	     090FH,0C0FH,0F0FH,0F3FH,0F6FH,0F9FH,0FCFH,0FFFH] ;

  G.LoadRGB4( ADR( s^.ViewPort ) , ADR( colarr ) , 32 ) ;

  horiF := zoom/320.0 ;
  vertF := zoom/400.0 ;
  FOR v := -tv TO 399-tv DO
     ci := imgC + vertF * SHORTFLOAT(v) ;
     FOR h := -th TO 319-th DO
       cr := horiF * SHORTFLOAT(h) + realC ;
       zr := 0.0 ; zi := 0.0 ;
       loop := TRUE ; k := 1 ;
       WHILE ( k <= maxI ) & loop DO
         t := zr ;
         zr := (zr*zr)-(zi*zi)+cr ;
         zi := 2.0*t*zi+ci ;
         IF (zr*zr)+(zi*zi) >= 4.0 THEN loop := FALSE END ;
         INC( k );
       END ;
       IF k < maxI THEN G.SetAPen( rp, k MOD 32 )
       ELSE G.SetAPen( rp, 0 );
       END ;
       G.WritePixel( rp, h+th, v+tv ) ;
       StdLib.chkabort( )
     END
  END ;
  E.Wait({12}) (* Wait for BREAK signal *)

CLOSE

  IF s # NIL THEN I.CloseScreen( s ) END

END Mandel.
