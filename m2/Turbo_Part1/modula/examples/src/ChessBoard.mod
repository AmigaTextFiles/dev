(* One of my first ever Modula program, a good example of bad	*)
(* programming style:						*)
(*   Undocumented,						*)
(*   Poor structure,						*)
(*   Meaningless variable names,				*)
(*   Magic numbers ....						*)

(* Written under 1.3. Under 2.0+ colors are backwards *)

MODULE ChessBoard ; (* @B+ *)

FROM Storage IMPORT ALLOCATE ;

FROM Intuition{33} IMPORT
  NewWindow, Gadget, OffGadget, OnGadget, WindowPtr, OpenWindow, CloseWindow,
  Window, IntuiMessagePtr, ViewPortAddress ;

FROM SYSTEM IMPORT
  ADDRESS, ADR, LONGSET ;

FROM Exec IMPORT
  FreeMem, AllocMem, GetMsg, ReplyMsg, WaitPort ;

FROM Graphics{33} IMPORT
  InitBitMap, BitMap, BltBitMap, RastPortPtr, SetAPen, WritePixel, Draw,
  RectFill, WaitTOF, Bob, VSprite, VSpritePtr, BobPtr, InitGels, DrawGList,
  GelsInfoPtr, AddBob, SortGList, InitMasks, AllocRaster, FreeRaster,
  RemIBob, ReadPixel ;

IMPORT G := Graphics, I := Intuition , StdLib , Exec ;

(*----------------------------------------------------------------------------*)

TYPE
  PieceBlock = POINTER TO ARRAY [0..839] OF CARDINAL ;


VAR
  win      : WindowPtr ;
  rp       : RastPortPtr ; (* win^.RastPort *)
  B        : Bob ;
  V        : VSprite ;
  Info     : GelsInfoPtr ;
  bmp      : BitMap ;
  cmp      : BitMap ;
  Ras      : ADDRESS ;
  VPA      : ADDRESS ;
  Board    : ARRAY [0..7],[0..7] OF CARDINAL ;
  chipData : PieceBlock ;
  bool1    : BOOLEAN ; (* What do these represent ?? *)
  bool2    : BOOLEAN ;

CONST
  Empty   = 0 ;
  Pawn    = 1 ;
  Night   = 2 ;
  Bishop  = 3 ;
  Rook    = 4 ;
  Queen   = 5 ;
  King    = 6 ;
  BEmpty  = 7 ;
  BPawn   = 8 ;
  BNight  = 9 ;
  BBishop = 10 ;
  BRook   = 11 ;
  BQueen  = 12 ;
  BKing   = 13 ;

(*----------------------------------------------------------------------------*)

PROCEDURE Cleanup ;
BEGIN
  IF win # NIL THEN CloseWindow( win ) ; win := NIL END ;
  FreeMem( chipData , 1700 ) ;
  FreeRaster( Ras , 32 , 24 ) ;
END Cleanup ;

(*----------------------------------------------------------------------------*)

PROCEDURE InitWindow ;
  VAR nw : NewWindow ;
BEGIN
  WITH nw DO
    Title	:= "ChessBoard" ;
    LeftEdge	:= 30 ;
    TopEdge	:= 70 ;
    Width	:= 215 ;
    Height	:= 117 ;
    DetailPen	:=0 ;
    BlockPen	:=1 ;
    BitMap	:=NIL ;
    IDCMPFlags	:= I.CLOSEWINDOW+I.ACTIVEWINDOW+I.INACTIVEWINDOW+I.MOUSEBUTTONS;
    Flags	:=I.WINDOWDRAG+I.WINDOWDEPTH+I.WINDOWCLOSE+I.ACTIVATE ;
    Type	:=I.WBENCHSCREEN ;
    FirstGadget	:=NIL ;
    CheckMark	:=NIL ;
    Screen	:=NIL
  END;
  win := OpenWindow( nw ) ;
  IF win = NIL THEN HALT END ;
  StdLib.atexit( Cleanup ) ;
  rp := win^.RPort ;
  rp^.GelsInfo := Info ;
  VPA := ViewPortAddress( win )
END InitWindow ;

(*----------------------------------------------------------------------------*)

PROCEDURE InitStrucs ;
  VAR
    sqrx  : CARDINAL ;
    dsa   : VSpritePtr ;
    dsb   : VSpritePtr ;
BEGIN

  NEW( dsa ) ;
  NEW( dsb ) ;
  NEW( Info ) ;
  InitGels( dsa, dsb, Info ) ;
  InitBitMap( bmp, 2, 24, 12 ) ;
  InitBitMap( cmp, 2, 24, 12 ) ;
  Ras := AllocRaster( 32, 24 ) ;

  Board[0,0] := BRook ;
  Board[1,0] := BNight ;
  Board[2,0] := BBishop ;
  Board[3,0] := BQueen ;
  Board[4,0] := BKing ;
  Board[5,0] := BBishop ;
  Board[6,0] := BNight ;
  Board[7,0] := BRook ;
  Board[0,7] := Rook ;
  Board[1,7] := Night ;
  Board[2,7] := Bishop ;
  Board[3,7] := Queen ;
  Board[4,7] := King ;
  Board[5,7] := Bishop ;
  Board[6,7] := Night ;
  Board[7,7] := Rook ;

  FOR sqrx := 0 TO 7 DO
    Board [sqrx,6] := Pawn ;
    Board [sqrx,1] := BPawn
  END;

  bool1 := FALSE ;
  bool2 := TRUE ;

END InitStrucs ;

(*----------------------------------------------------------------------------*)

PROCEDURE SetBob( pc : CARDINAL ) ;
BEGIN
  WITH V DO
    VSBob := ADR( B ) ;
    Height := 12 ;
    Width := 2 ;
    Depth := 2 ;
    IF pc>6 THEN ImageData := LONGCARD(chipData)+240*(pc MOD 7) ;
    ELSE ImageData := LONGCARD(chipData)+(240*(pc MOD 7))+48 ;
    END ;
    PlanePick := 3 ;
    Flags := G.SAVEBACK+G.OVERLAY ;
    CollMask := NIL ;
    Y := 25 ;
    X := 11 ;
  END;
  WITH B DO
    BobVSprite := ADR( V ) ;
    IF pc > 6 THEN ImageShadow := LONGCARD(chipData)+(240*(pc MOD 7))+144 ;
    ELSE ImageShadow := LONGCARD(chipData)+(240*(pc MOD 7))+192
    END ;
    SaveBuffer := Ras ;
    Before := NIL ;
    After := NIL ;
    DBuffer := NIL ;
    Flags := { } ;
  END;
  AddBob( ADR( B ) , rp )
END SetBob ;

(*----------------------------------------------------------------------------*)

PROCEDURE Doit( col : BOOLEAN ) ;
  VAR co : ADDRESS ;
BEGIN
  IF col THEN (*Black square*)
    cmp.Planes[0] := LONGCARD( chipData )+48 ;
    cmp.Planes[1] := LONGCARD( chipData )+96 ;
  ELSE
    cmp.Planes[0] := LONGCARD( chipData ) ;
    cmp.Planes[1] := LONGCARD( chipData )+48 ;
  END ;
  bmp.Planes[0] := B.SaveBuffer ;
  bmp.Planes[1] := LONGCARD( B.SaveBuffer )+48 ;
  co := ADR( chipData )+1682 ;
  BltBitMap( ADR( cmp ), 0, 0, ADR( bmp ), 0, 0, 26, 12, 0C0H, 3, co ) ;
END Doit;

(*----------------------------------------------------------------------------*)

PROCEDURE SlidePC( Fx, Fy, pc : CARDINAL ) ;
BEGIN
  SetBob( pc ) ;
  V.X := Fx ;
  V.Y := Fy ;
  DrawGList( rp , VPA ) ;
  V.Flags := G.OVERLAY ;
  B.Flags := G.SAVEBOB ;
  RemIBob( ADR( B ), rp, VPA )
END SlidePC;

(*----------------------------------------------------------------------------*)

PROCEDURE Slide( Fx, Fy, Tx, Ty : INTEGER ; a , b : INTEGER ; pc : CARDINAL ) ;
BEGIN
  IF bool2 THEN SetBob(pc) END ;
  V.X := Fx ;
  V.Y := Fy ;
  DrawGList( rp, VPA ) ;
  IF bool2 THEN Doit(((Fx DIV 26) MOD 2 )#((Fy DIV 13) MOD 2 )) END ;
  WHILE ( Fx # Tx ) OR ( Fy # Ty ) DO
    Fx  := Fx+a ;
    Fy  := Fy+b ;
    V.X := Fx ;
    V.Y := Fy ;
    WaitTOF( ) ;
    DrawGList( rp, VPA ) ;
  END;
  IF bool1 THEN
  ELSE
    Doit(((Tx DIV 26) MOD 2) # ((Ty DIV 13) MOD 2 ) );
    DrawGList( rp, VPA ) ;
    V.Flags := G.OVERLAY ;
    B.Flags := G.SAVEBOB ;
    RemIBob( ADR( B ), rp, VPA ) ;
  END;
END Slide ;

(*----------------------------------------------------------------------------*)

PROCEDURE DrwBrd( ) ;
  VAR nx, ny, mx, my, sqrx, sqry, sqry2, pc : INTEGER ;
BEGIN
  SetAPen( rp, 1 );
  RectFill( rp, 3, 11, 210, 114 ) ;
  SetAPen( rp, 0 );
  FOR nx := 3 TO 185 BY 52 DO
    FOR ny := 24 TO 102 BY 26 DO
      RectFill( rp, nx, ny, nx+25, ny+12 )
    END
  END ;
  FOR nx := 29 TO 185 BY 52 DO
    FOR ny := 11 TO 89 BY 26 DO
      RectFill( rp, nx, ny, nx+25, ny+12 )
    END
  END ;
  FOR sqrx := 0 TO 7 DO
    FOR sqry := 0 TO 1 DO
      sqry2 := 6+sqry ;
      pc := Board[sqrx,sqry] ;
      mx := 3+sqrx*26 ;
      my := 12+sqry*13 ;
      nx := mx ;
      ny := my ;
      SlidePC( mx, my, pc ) ;
      pc := Board[sqrx,sqry2] ;
      my := 12+sqry2*13 ;
      ny := my ;
      SlidePC( mx, my, pc )
    END
  END
END DrwBrd;

(*----------------------------------------------------------------------------*)

PROCEDURE WhichDir( mx, my, nx, ny, PC : INTEGER ) ;

  PROCEDURE Slid( za, zb : INTEGER ) ;
  BEGIN Slide( mx, my, nx, ny, za, zb, PC )
  END Slid ;

  VAR
    a, b, Cnx, Cny, Cmx, Cmy : INTEGER ;
    Flag : BOOLEAN ;

BEGIN
  Flag := TRUE ;
  Cnx := (nx-3) DIV 26 ;
  Cny := (ny-12) DIV 13 ;
  Cmx := (mx-3) DIV 26 ;
  Cmy := (my-12) DIV 13 ;
  a := Cnx-Cmx ;
  b := Cny-Cmy ;
  IF ( PC=Night ) OR ( PC=BNight ) THEN

    IF (ABS(a)=1) & (ABS(b)=2) THEN
      nx := nx-(a*26);
      bool1 := TRUE ;
      Slid( 0, b DIV 2);
      my := my+((b DIV 2)*26);
      bool1 := FALSE ; bool2 := FALSE ;
      nx := nx+(a*26) ;
      Slid( a*2, 0 ) ;
      bool2 := TRUE ;
    ELSIF (ABS(a)=2) & (ABS(b)=1) THEN
      ny := ny-(b*13) ;
      bool1 := TRUE ;
      Slid( a, 0 ) ;
      mx := mx+(a*26) ;
      bool1 := FALSE ; bool2 := FALSE ;
      ny := ny+(b*13) ;
      Slid( 0, b ) ;
      bool2 := TRUE
    ELSE
      Flag := FALSE ;
      Slide( mx, my, mx, my, 0, 0, PC )
    END

  ELSE

    IF (nx#mx) & (ny#my) THEN
      IF (nx>mx)&(ny>my) THEN Slid( 2, 1 )
      ELSIF nx>mx THEN Slid( 2, -1 )
      ELSIF (ny<my) & (nx<mx) THEN Slid( -2, -1 )
      ELSE Slid( -2, 1 )
      END

    ELSE
      IF nx>mx THEN Slid( 2, 0 )
      ELSIF nx<mx THEN Slid( -2, 0 )
      ELSIF ny>my THEN Slid( 0, 1 )
      ELSE Slid( 0, -1 )
      END
    END
  END;
  IF Flag THEN Board[Cnx,Cny] := PC ; Board[Cmx,Cmy] := 0 END
END WhichDir;

(*----------------------------------------------------------------------------*)

PROCEDURE IsLegal( x1, y1, x2, y2 : INTEGER ) : BOOLEAN ;
BEGIN
  RETURN ((NOT((x1=x2) & (y1=y2))) & ((x1=x2) OR (y1=y2) OR
         (ABS(x2-x1)=ABS(y2-y1)) OR (Board[x2,y2]=Night) OR
         (Board[x2,y2]=BNight)));
END IsLegal ;

(*----------------------------------------------------------------------------*)

PROCEDURE Main ;
  VAR
    mx, my, Ay, Ax, lx, ly, lax, lay : INTEGER ;
    col   : LONGCARD ;
    msg   : IntuiMessagePtr ;
    Code  : CARDINAL ;
    Class : LONGSET ;
BEGIN
  SetAPen( rp , 3 ) ;
  LOOP
    WaitPort( win^.UserPort ) ;
    msg := GetMsg( win^.UserPort ) ;
    Class := msg^.Class ;
    Code := msg^.Code ;
    Ax := (( win^.MessageKey^.MouseX )-3) DIV 26 ;
    Ay := (( win^.MessageKey^.MouseY )-11) DIV 13 ;
    mx := Ax*26+3;
    my := Ay*13+12;
    ReplyMsg( msg ) ;
    IF Class = I.CLOSEWINDOW THEN EXIT

    ELSIF Class = I.INACTIVEWINDOW THEN
      REPEAT
        WaitPort( win^.UserPort ) ;
        msg := GetMsg( win^.UserPort ) ;
        Class := msg^.Class ;
        ReplyMsg( msg )
      UNTIL Class = I.ACTIVEWINDOW

    ELSIF Code = I.SELECTDOWN THEN
      IF Board[Ax,Ay] # 0 THEN
        SetAPen( rp , 3 ) ;
        lx := mx ; ly := my ; lax := Ax ; lay := Ay ; my := my-1 ;
        rp^.cp_x := mx ;
        rp^.cp_y := my ;
        Draw( rp, mx+25, my ) ;
        Draw( rp, mx+25, my+12 ) ;
        Draw( rp, mx, my+12 ) ;
        Draw( rp, mx, my ) ;
        rp^.cp_x := mx+24 ;
        rp^.cp_y := my ;
        Draw( rp, mx+24, my+12 ) ;
        Draw( rp, mx+1, my+12 ) ;
        Draw( rp, mx+1, my ) ;
      ELSE lax := Ax ; lay := Ay
      END

    ELSIF ( Code = I.SELECTUP ) & ( Board[lax,lay] # 0 ) THEN
      col := ReadPixel( rp, lx+2, ly );
      SetAPen( rp, col );
      rp^.cp_x := lx  ;
      rp^.cp_y := ly-1 ;
      Draw( rp, lx+25, ly-1 ) ;
      IF IsLegal( Ax, Ay, lax, lay ) THEN
        WhichDir( lx, ly, mx, my, Board[lax,lay] )
      ELSE Slide( lx, ly, lx, ly, 0, 0, Board[lax,lay] )
      END
    END
  END
END Main ;

(*----------------------------------------------------------------------------*)

PROCEDURE InitPieces ;
BEGIN
  chipData := AllocMem( 1700 , Exec.MEMF_CHIP ) ;
  IF chipData = NIL THEN HALT END ;
  chipData^ :=
  [
    0FFFFH,0FFFFH,0FFFFH,0FFFFH,0FFFFH,0FFFFH,0FFFFH,0FFFFH,0FFFFH,0FFFFH,
    0FFFFH,0FFFFH,0FFFFH,0FFFFH,0FFFFH,0FFFFH,0FFFFH,0FFFFH,0FFFFH,0FFFFH,
    0FFFFH,0FFFFH,0FFFFH,0FFFFH,
    00000H,00000H,00000H,00000H,00000H,00000H,00000H,00000H,00000H,00000H,
    00000H,00000H,00000H,00000H,00000H,00000H,00000H,00000H,00000H,00000H,
    00000H,00000H,00000H,00000H,
    00000H,00000H,00000H,00000H,00000H,00000H,00000H,00000H,00000H,00000H,
    00000H,00000H,00000H,00000H,00000H,00000H,00000H,00000H,00000H,00000H,
    00000H,00000H,00000H,00000H,
    0FFFFH,0FFC0H,0FFFFH,0FFC0H,0FFFFH,0FFC0H,0FFFFH,0FFC0H,0FFFFH,0FFC0H,
    0FFFFH,0FFC0H,0FFFFH,0FFC0H,0FFFFH,0FFC0H,0FFFFH,0FFC0H,0FFFFH,0FFC0H,
    0FFFFH,0FFC0H,0FFFFH,0FFC0H,
    0FFFFH,0FFC0H,0FFFFH,0FFC0H,0FFFFH,0FFC0H,0FFFFH,0FFC0H,0FFFFH,0FFC0H,
    0FFFFH,0FFC0H,0FFFFH,0FFC0H,0FFFFH,0FFC0H,0FFFFH,0FFC0H,0FFFFH,0FFC0H,
    0FFFFH,0FFC0H,0FFFFH,0FFC0H,

    00000H,00000H,0001FH,00000H,00031H,08000H,00060H,0C000H,000C0H,06000H,
    00060H,0C000H,00031H,08000H,00060H,0C000H,000C0H,06000H,00180H,03000H,
    003FFH,0F800H,00000H,00000H,0003FH,08000H,00060H,0C000H,000CEH,06000H,
    0019FH,03000H,0033FH,09800H,0019FH,03000H,000CEH,06000H,0019FH,03000H,
    0033FH,09800H,0067FH,0CC00H,00400H,00400H,007FFH,0FC00H,
    00000H,00000H,0001FH,00000H,00031H,08000H,00060H,0C000H,000C0H,06000H,
    00060H,0C000H,00031H,08000H,00060H,0C000H,000C0H,06000H,00180H,03000H,
    003FFH,0F800H,00000H,00000H,0003FH,08000H,
    0007FH,0C000H,000FFH,0E000H,001FFH,0F000H,003FFH,0F800H,001FFH,0F000H,
    000FFH,0E000H,001FFH,0F000H,003FFH,0F800H,007FFH,0FC00H,007FFH,0FC00H,
    007FFH,0FC00H,00000H,00000H,0001FH,00000H,0003FH,08000H,0007FH,0C000H,
    000FFH,0E000H,0007FH,0C000H,0003FH,08000H,0007FH,0C000H,000FFH,0E000H,
    001FFH,0F000H,003FFH,0F800H,00000H,00000H,

    00020H,00000H,000DCH,00000H,00187H,00000H,00301H,0C000H,00660H,07000H,
    00C00H,01800H,01800H,00C00H,031F8H,00600H,01E30H,00600H,000C0H,00600H,
    001FFH,0FE00H,00000H,00000H,000DCH,00000H,00123H,00000H,00278H,0C000H,
    004FEH,03000H,0099FH,08800H,013FFH,0E400H,027FFH,0F200H,04E07H,0F900H,
    021CFH,0F900H,01F3FH,0F900H,00200H,00100H,001FFH,0FF00H,
    00020H,00000H,000DCH,00000H,00187H,00000H,00301H,0C000H,00660H,07000H,
    00C00H,01800H,01800H,00C00H,031F8H,00600H,01E30H,00600H,000C0H,00600H,
    001FFH,0FE00H,00000H,00000H,000FCH,00000H,
    001FFH,00000H,003FFH,0C000H,007FFH,0F000H,00FFFH,0F800H,01FFFH,0FC00H,
    03FFFH,0FE00H,07FFFH,0FF00H,03FFFH,0FF00H,01FFFH,0FF00H,003FFH,0FF00H,
    001FFH,0FF00H,00020H,00000H,000FCH,00000H,001FFH,00000H,003FFH,0C000H,
    007FFH,0F000H,00FFFH,0F800H,01FFFH,0FC00H,03FFFH,0FE00H,01E3FH,0FE00H,
    000FFH,0FE00H,001FFH,0FE00H,00000H,00000H,

    00000H,00000H,0001EH,00000H,00073H,08000H,000C0H,0C000H,0018CH,06000H,
    0019EH,06000H,000CCH,0C000H,00073H,08000H,001C0H,0E000H,0061EH,01800H,
    01FF3H,0FE00H,00000H,00000H,0003FH,00000H,000E1H,0C000H,0018CH,06000H,
    0033FH,03000H,00673H,09800H,00661H,09800H,00333H,03000H,0038CH,07000H,
    0063FH,01800H,019E1H,0E600H,0200CH,00100H,01FF3H,0FE00H,
    00000H,00000H,0001EH,00000H,00073H,08000H,000C0H,0C000H,0018CH,06000H,
    0019EH,06000H,000CCH,0C000H,00073H,08000H,001C0H,0E000H,0061EH,01800H,
    01FF3H,0FE00H,00000H,00000H,0003FH,00000H,
    000FFH,0C000H,001FFH,0E000H,003FFH,0F000H,007FFH,0F800H,007FFH,0F800H,
    003FFH,0F000H,003FFH,0F000H,007FFH,0F800H,01FFFH,0FE00H,03FFFH,0FF00H,
    01FF3H,0FE00H,00000H,00000H,0001EH,00000H,0007FH,08000H,000FFH,0C000H,
    001FFH,0E000H,001FFH,0E000H,000FFH,0C000H,0003FH,08000H,001FFH,0E000H,
    007FFH,0F800H,01FF3H,0FE00H,00000H,00000H,

    00000H,00000H,007DFH,07C00H,00461H,08400H,00300H,01800H,0019FH,03000H,
    00180H,03000H,00180H,03000H,0019FH,03000H,00300H,01800H,00600H,00C00H,
    003FFH,0F800H,00000H,00000H,00FFFH,0FE00H,01820H,08300H,01B9EH,07B00H,
    00CFFH,0E600H,00660H,0CC00H,0067FH,0CC00H,0067FH,0CC00H,00660H,0CC00H,
    00CFFH,0E600H,019FFH,0F300H,00C00H,00600H,007FFH,0FC00H,
    00000H,00000H,007DFH,07C00H,00461H,08400H,00300H,01800H,0019FH,03000H,
    00180H,03000H,00180H,03000H,0019FH,03000H,00300H,01800H,00600H,00C00H,
    003FFH,0F800H,00000H,00000H,00FFFH,0FE00H,
    01FFFH,0FF00H,01FFFH,0FF00H,00FFFH,0FE00H,007FFH,0FC00H,007FFH,0FC00H,
    007FFH,0FC00H,007FFH,0FC00H,00FFFH,0FE00H,01FFFH,0FF00H,00FFFH,0FE00H,
    007FFH,0FC00H,00000H,00000H,007DFH,07C00H,007FFH,0FC00H,003FFH,0F800H,
    001FFH,0F000H,001FFH,0F000H,001FFH,0F000H,001FFH,0F000H,003FFH,0F800H,
    007FFH,0FC00H,003FFH,0F800H,00000H,00000H,

    00000H,00000H,00F3EH,07800H,01994H,0CC00H,00CE3H,09800H,01A63H,02C00H,
    03122H,04600H,018FFH,09C00H,00700H,07000H,003FFH,0E000H,00300H,06000H,
    001FFH,0C000H,00000H,00000H,01F3EH,07C00H,030C1H,08600H,0266BH,03200H,
    0331CH,06600H,0659CH,0D300H,04EDDH,0B900H,06700H,06300H,038FFH,08E00H,
    00C00H,01800H,00CFFH,09800H,00600H,03000H,003FFH,0E000H,
    00000H,00000H,00F3EH,07800H,01994H,0CC00H,00CE3H,09800H,01A63H,02C00H,
    03122H,04600H,018FFH,09C00H,00700H,07000H,003FFH,0E000H,00300H,06000H,
    001FFH,0C000H,00000H,00000H,01F3EH,07C00H,
    03FFFH,0FE00H,03FFFH,0FE00H,03FFFH,0FE00H,07FFFH,0FF00H,07FFFH,0FF00H,
    07FFFH,0FF00H,03FFFH,0FE00H,00FFFH,0F800H,00FFFH,0F800H,007FFH,0F000H,
    003FFH,0E000H,01F3EH,07C00H,03FFFH,0FE00H,03FFFH,0FE00H,03FFFH,0FE00H,
    07FFFH,0FF00H,07FFFH,0FF00H,07FFFH,0FF00H,03FFFH,0FE00H,00FFFH,0F800H,
    00FFFH,0F800H,007FFH,0F000H,003FFH,0E000H,

    0001CH,00000H,0007FH,00000H,0001CH,00000H,00EBFH,05C00H,019E1H,0E600H,
    00C00H,00C00H,0067FH,09800H,00300H,03000H,0037FH,0B000H,00600H,01800H,
    003FFH,0F000H,00000H,00000H,000E3H,08000H,00180H,0C000H,01FE3H,0FC00H,
    03140H,0A300H,0261EH,01900H,033FFH,0F300H,01980H,06600H,01CFFH,0CE00H,
    00C80H,04C00H,019FFH,0E600H,00C00H,00C00H,007FFH,0F000H,
    0001CH,00000H,0007FH,00000H,0001CH,00000H,00EBFH,05C00H,019E1H,0E600H,
    00C00H,00C00H,0067FH,09800H,00300H,03000H,0037FH,0B000H,00600H,01800H,
    003FFH,0F000H,00000H,00000H,000FFH,08000H,
    001FFH,0C000H,01FFFH,0FC00H,03FFFH,0FF00H,03FFFH,0FF00H,03FFFH,0FF00H,
    01FFFH,0FE00H,01FFFH,0FE00H,00FFFH,0FC00H,01FFFH,0FE00H,00FFFH,0FC00H,
    007FFH,0F000H,0001CH,00000H,0007FH,00000H,0001CH,00000H,00EBFH,05C00H,
    01FFFH,0FE00H,00FFFH,0FC00H,007FFH,0F800H,003FFH,0F000H,003FFH,0F000H,
    007FFH,0F800H,003FFH,0F000H,00000H,00000H
  ]
END InitPieces ;

BEGIN
  InitPieces( ) ;
  InitStrucs( ) ;
  InitWindow( ) ;
  DrwBrd( ) ;
  Main( )
END ChessBoard.






