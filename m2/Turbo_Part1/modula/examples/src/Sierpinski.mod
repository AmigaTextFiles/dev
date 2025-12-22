MODULE Sierpinski;

IMPORT
  SYSTEM, MathIEEESingTrans, Graphics{33}, Intuition{33}, StdLib, Exec, Dos ;

CONST
  SquareSize	= 512 ;
  width		= SquareSize;
  height	= SquareSize;

(* *********************************************************************** *)
(* Graphics handling routines.                                             *)
(* *********************************************************************** *)

VAR
  screen : Intuition.ScreenPtr  ; (* The Screen *)
  new	 : Intuition.NewScreen  ;
  rp	 : Graphics.RastPortPtr ;

PROCEDURE CloseScreen( );
BEGIN Intuition.CloseScreen(screen);
END CloseScreen;

PROCEDURE OpenScreen( );
BEGIN
  WITH new DO
    Width := 640 ;
    Height := 512 ;
    Depth := 1 ;
    DefaultTitle := "";
    ViewModes := Graphics.HIRES+Graphics.LACE ;
    Type := Intuition.CUSTOMSCREEN ;
  END;
  screen := Intuition.OpenScreen(new);
  IF screen = NIL THEN HALT END;
  StdLib.atexit(CloseScreen);
  rp := SYSTEM.ADR(screen^.RastPort);
END OpenScreen;

VAR
  i , h : INTEGER;

PROCEDURE DrawLine(sx, sy, ex, ey: INTEGER);
BEGIN
  Graphics.Move(rp, sx+100, sy);
  Graphics.Draw(rp, ex+100, ey);
  StdLib.chkabort();
END DrawLine;


(* *********************************************************************** *)
(* A really *sad* line drawing procedure by N. Wirth.                      *)
(* *********************************************************************** *)

VAR
  Px, Py	: REAL;		(* Stuff needed by line(). *)

PROCEDURE rad(deg: INTEGER): REAL;
CONST
  pi = 3.14159265;
BEGIN
  RETURN FLOAT(deg)*pi/180.0;
END rad;

PROCEDURE line(d, n: INTEGER);
(* draw a line of length n in direction d (angle = 45*d degrees) *)
VAR
  fd, fn	: REAL;
  oldx, oldy	: REAL;
BEGIN
  fd := rad(45*d+90);
  fn := FLOAT(n);
  oldx := Px;
  oldy := Py;
  Px := oldx + fn * MathIEEESingTrans.IEEESPCos(fd);
  Py := oldy - fn * MathIEEESingTrans.IEEESPSin(fd);
  DrawLine(TRUNC(oldx), TRUNC(oldy), TRUNC(Px), TRUNC(Py));
END line;


(* *********************************************************************** *)
(* The code for Sierpinski, from "Programming in Modula-2", by N. Wirth.   *)
(* *********************************************************************** *)

PROCEDURE A(k: INTEGER); FORWARD;
PROCEDURE B(k: INTEGER); FORWARD;
PROCEDURE C(k: INTEGER); FORWARD;
PROCEDURE D(k: INTEGER); FORWARD;

PROCEDURE A(k: INTEGER);
BEGIN
  IF k>0 THEN
    A(k-1); line(7, h); B(k-1); line(0, 2*h);
    D(k-1); line(1, h); A(k-1);
  END;
END A;

PROCEDURE B(k: INTEGER);
BEGIN
  IF k>0 THEN
    B(k-1); line(5, h); C(k-1); line(6, 2*h);
    A(k-1); line(7, h); B(k-1);
  END;
END B;

PROCEDURE C(k: INTEGER);
BEGIN
  IF k>0 THEN
    C(k-1); line(3, h); D(k-1); line(4, 2*h);
    B(k-1); line(5, h); C(k-1);
  END;
END C;

PROCEDURE D(k: INTEGER);
BEGIN
  IF k>0 THEN
    D(k-1); line(1, h); A(k-1); line(2, 2*h);
    C(k-1); line(3, h); D(k-1);
  END;
END D;

PROCEDURE main();
VAR
  x0, y0	: INTEGER;
  msg		: Exec.MessagePtr ;
BEGIN
  i := 0;
  h := SquareSize DIV 4;
  x0 := width DIV 2 - h;
  y0 := height DIV 2;
  REPEAT
    INC(i);
    h := h DIV 2;
    x0 := x0 - h;
    Px := FLOAT(x0);
    Py := FLOAT(y0) + FLOAT(h)*1.75;
    y0 := TRUNC(Py);
    A(i); line(7, h); B(i); line(5, h);
    C(i); line(3, h); D(i); line(1, h);
  UNTIL (i = 5);
  Dos.Delay(250) ;
END main ;

BEGIN
  OpenScreen();
  main();
END Sierpinski.
