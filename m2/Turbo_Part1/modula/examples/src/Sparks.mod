MODULE Sparks (* From oberon version by Fridtjof Siebert, Fred Fish 380 *);

IMPORT Graphics{33}, I := Intuition{33} ;

FROM SYSTEM IMPORT BITSET, ADDRESS, ADR ;

CONST
  maxLines = 64 ;
  erase    = 00 ;
  x	   = 00 ;
  y  	   = 01 ;
  start    = 00 ;
  end	   = 01 ;

TYPE
  point  = ARRAY [0..01] OF INTEGER ;
  line	 = ARRAY [0..01] OF point   ;
  ColArr = ARRAY [0..31] OF INTEGER ;

VAR
  i			: INTEGER ;
  ns			: I.NewScreen ;
  screen		: I.ScreenPtr ;
  Ciapra[0BFE001H]	: SET OF [0..7] ;
  lines			: ARRAY [0..maxLines-1] OF line ;
  l			: line ;
  cl			: INTEGER ;
  color,coldir		: INTEGER ;
  deltas		: line ;
  colarr		: ColArr ;

PROCEDURE DrawLine( VAR l : line ; color : INTEGER ) ;
  VAR rp : ADDRESS ;
BEGIN
  rp := ADR( screen^.RastPort ) ;
  Graphics.SetAPen( rp , color ) ;
  Graphics.SetDrMd( rp , {} ) ;
  Graphics.Move( rp , l[start,x] , l[start,y] ) ;
  Graphics.Draw( rp , l[end,  x] , l[end,  y] ) ;
END DrawLine;

PROCEDURE Adjust( VAR c , dc : INTEGER ; max : INTEGER ) ;
  VAR i : INTEGER ; VHPosR[ 0DFF006H ] : BITSET ;
BEGIN
  i := dc - 8 ;
  INC( c , i ) ;
  IF ( c < 0 ) OR ( c >= max ) THEN
    DEC( c , i ) ;
    i := INTEGER( VHPosR*{0..3} );
    IF i > 7 THEN INC( i , 1 ) END ;
    dc := i ;
  END ;
END Adjust ;

PROCEDURE z ;
BEGIN
  WITH ns DO
    Width     := 320 ;
    Height    := 256 ;
    Depth     := 5 ;
    ViewModes := { } ;
    Type      := I.CUSTOMSCREEN + I.SCREENQUIET ;
  END ;
  screen := I.OpenScreen( ns ) ;
  IF screen # NIL THEN
    colarr  := [0000H,0F00H,0F30H,0F60H,0F90H,0FC0H,0FF0H,0CF0H,
		09F0H,06F0H,03F0H,00F0H,00F3H,00F6H,00F9H,00FCH,
		00FFH,00CFH,009FH,006FH,003FH,000FH,030FH,060FH,
		090FH,0C0FH,0F0FH,0F3FH,0F6FH,0F9FH,0FCFH,0FFFH] ;
    Graphics.LoadRGB4( ADR( screen^.ViewPort ) , ADR( colarr ) , 32 ) ;
    color  := 1 ;
    coldir := 1 ;
    REPEAT
      DrawLine( lines[cl] , erase ) ;
      INC( color , coldir ) ;
      IF color = 1 THEN coldir := -coldir
      ELSIF color = 31 THEN coldir := -coldir
      END ;
      CASE color OF 1,31: coldir := -coldir ELSE END ;
      i := start ;
      REPEAT
	Adjust( l[i,x] , deltas[i,x] , screen^.Width ) ;
	Adjust( l[i,y] , deltas[i,y] , screen^.Height ) ;
	INC( i ) ;
      UNTIL i > end ;
      DrawLine( l , color ) ;
      lines[cl] := l ;
      INC( cl ) ;
      IF cl = maxLines THEN cl := 0 END ;
    UNTIL NOT( 6 IN Ciapra ) ;
    I.CloseScreen( screen ) ;
  END
END z ;

BEGIN z
END Sparks.
