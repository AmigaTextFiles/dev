/*
**    cosmic_32.e - Generates cosmic flame fractals :-)
**    This version makes use of and requires 24 bit graphics.
**
**    Based on cosmic.e, this version uses more colours, more detail
**    and is alot slower :) Also removed accesses to customchips.
**    Copyright © 2004 Leif Salomonsson.
**
**    Copyright © 1996 by Chris Sumner
**
**
**    Cosmic flame fractal code derived from FracBlank source code
**    Copyright © 1991-1992 by Olaf `Olsen' Barthel
**
**    Cosmic flame fractal code derived from xlock source code
**    Copyright © 1988-1991 by Patrick J. Naughton.
**
**   Permission to use, copy, modify, and distribute this software and its
**   documentation for any purpose and without fee is hereby granted,
**   provided that the above copyright notice appear in all copies and that
**   both that copyright notice and this permission notice appear in
**   supporting documentation.
*/



/* MorphOS version by LS 2004 */

OPT POWERPC, STACK=500000

OPT PREPROCESS


OBJECT recursedata
   x:REAL, y:REAL
   r:REAL, g:REAL, b:REAL
   z:REAL
   level
ENDOBJECT



/* FEEDBACK (New concept ?) Generates repetive patterns */

#define FUNCTION f := functionCosmic(old,new,f)
#define FEEDBACK(a) new.a := doFeedback(new.a,old.a)
#define ALTERNATE(a) new.a := doAlternate(new.a,new.x,new.y,new.r,new.g,new.b,new.z)

MODULE '*macros'

MODULE 'graphics/modeid'
MODULE 'intuition/intuitionbase','intuition/intuition','intuition/screens'
MODULE 'utility/tagitem'

MODULE 'morphos/cybergfx'
MODULE 'colorwheel'
MODULE 'gadgets/colorwheel'

RAISE "^C" IF CtrlC()=TRUE
RAISE "STCK" IF FreeStack() < 8000

CONST MAXFLAMELEVEL   = 250
CONST MAXTOTALPOINTS  = 50000
CONST FLAME_SIZE      = 500
CONST WIDTH = 800, HEIGHT = 600


DEF dorgb, feedback, alternate

DEF flame:PTR TO REAL
DEF points,count=0

DEF win:PTR TO window, width, height, left, top
DEF rp

DEF degrees=0:PTR TO LONG

PROC functionCosmic(old:PTR TO recursedata,new:PTR TO recursedata, f:PTR TO REAL)
   DEF r:REAL, g:REAL, b:REAL, x:REAL, y:REAL, z:REAL, a:REAL

   r := old.r
   g := old.g
   b := old.b
   x := old.x
   y := old.y
   z := old.z

   a := ! r*g*b + (Rnd(32000)!/16000.0-1.0*0.002)

   new.x := ! (!x*f[]++) + (!y*f[]++) + (!a*f[]++) + f[]++
   new.y := ! (!x*f[]++) + (!y*f[]++) + (!a*f[]++) + f[]++

   a := ! x*y ->+ (Rnd(32000)!/16000.0-1.0*0.005)

   new.r := ! (!r*f[]++) + (!g*f[]++) + (!b*f[]++) + (!a*f[]++) * 0.5 + f[]++
   new.g := ! (!r*f[]++) + (!g*f[]++) + (!b*f[]++) + (!a*f[]++) * 0.5 + f[]++
   new.b := ! (!r*f[]++) + (!g*f[]++) + (!b*f[]++) + (!a*f[]++) * 0.5 + f[]++

ENDPROC f

PROC functionTest(old:PTR TO recursedata,new:PTR TO recursedata, f:PTR TO REAL)
   DEF r:REAL, g:REAL, b:REAL, x:REAL, y:REAL, z:REAL, a1:REAL, a2:REAL, a3:REAL

   r := old.r
   g := old.g
   b := old.b
   x := old.x
   y := old.y
   z := old.z

   ->a := ! r*g*b

   new.x := ! (!x*f[]++) + (!y*f[]++) + f[]++
   new.y := ! (!x*f[]++) + (!y*f[]++) + f[]++

   new.r := ! (!r*f[]++) + (!g*f[]++) + (!b*f[]++) + f[]++
   new.g := ! (!r*f[]++) + (!g*f[]++) + (!b*f[]++) + f[]++
   new.b := ! (!r*f[]++) + (!g*f[]++) + (!b*f[]++) + f[]++

   ->new.z := ! (!z*f[]++) + (!x*f[]++) + (!y*f[]++) * 0.5 + f[]++

   new.x := ! x + new.x * 0.5
   new.y := ! y + new.y * 0.5

ENDPROC f

PROC functionTest2(old:PTR TO recursedata,new:PTR TO recursedata, f:PTR TO REAL)
   DEF x:REAL, y:REAL, a1:REAL, a2:REAL, a3:REAL

   x := old.x
   y := old.y

   ->a := ! r*g*b

   new.x := ! (!x*f[]++) + (!y*f[]++) + f[]++
   new.y := ! (!x*f[]++) + (!y*f[]++) + f[]++

   a1 := Fabs(!new.x-x)
   a2 := Fabs(!new.y-y)
   a1 := ! a1*a1
   a2 := ! a2*a2

   new.z := ! Fsqrt(!a1+a2)

ENDPROC f

-> very cool, very bright ands clear colours
PROC function1(old:PTR TO recursedata,new:PTR TO recursedata, f:PTR TO REAL)
   DEF r:REAL, g:REAL, b:REAL, x:REAL, y:REAL, z:REAL

   r := old.r
   g := old.g
   b := old.b
   x := old.x
   y := old.y
   z := old.z

   #define Func1a   !(!x*f[]++)+(!y*f[]++) * z * 2.0 + f[]++
   #define Func1b   !(!r*f[]++)+(!g*f[]++)+(!b*f[]++) * z + f[]++
   #define Func1c   !(!r*f[]++)+(!g*f[]++)+(!b*f[]++)+(!x*f[]++)+(!y*f[]++)+(!z*f[]++) * 0.5 + f[]++

   new.x := Func1a
   new.y := Func1a
   new.z := Func1c
   new.r := Func1b
   new.b := Func1b
   new.g := Func1b

ENDPROC f

PROC functionSpeedCol(old:PTR TO recursedata,new:PTR TO recursedata, f:PTR TO REAL)
   DEF r:REAL, g:REAL, b:REAL, x:REAL, y:REAL, z:REAL

   r := old.r
   g := old.g
   b := old.b
   x := old.x
   y := old.y
   z := old.z


   new.x := ! (!x+f[]++) + (!y+f[]++) + (!z*f[]++) + f[]++
   new.y := ! (!x+f[]++) + (!y+f[]++) + (!z*f[]++) + f[]++
   new.z := ! (!x+f[]++) + (!y+f[]++) + (!z*f[]++) + f[]++

   new.r := ! (!new.x - x*f[]++) + (!r*f[]++) + f[]++
   new.g := ! (!new.y - y*f[]++) + (!g*f[]++) + f[]++
   new.b := ! (!new.z - z*f[]++) + (!b*f[]++) + f[]++

ENDPROC f

PROC doFeedback(a:REAL, b:REAL)
   SELECT feedback
   CASE 0
   CASE 1 ; a := ! a + a + a + a + a + a + a + a + a + -b / 5.0
   CASE 2 ; a := ! a + a + a + a + -b / 2.0
   CASE 3 ; a := ! a + a + a + -b / 1.5
   CASE 4 ; a := ! a*a - (!b*b)
   CASE 5 ; a := ! b*b - (!a*a)
   ENDSELECT
ENDPROC a

PROC doAlternate(a:REAL, x:REAL, y:REAL, r:REAL, g:REAL, b:REAL, z:REAL)
   SELECT alternate
   CASE 0
   CASE 1 ; a := -a -> yes, INTEGER negate !! :)
   CASE 2 ; a := ! a + (Rnd(32000)!/16000.0-1.0*0.1)
   CASE 3 ; a := ! a * Fsqrt(!a+1.0*2.0) - a
   CASE 4 ; a := ! a * a / (!(!x*x)+(!y*y)+(!z*z))
   CASE 5 ; a := ! a * a / (!x*y*z)
   CASE 6 ; a := ! a / (!(!x*y*z) + (!r*g*b))
   CASE 7 ; a := ! a / (!(!x*x) + (!y*y) + (!z*z))
   CASE 8 ; a := ! a / Fsqrt(Fabs(a))
   ENDSELECT
ENDPROC a

PROC main() HANDLE
  openiface()
  LOOP
    cosmic()
    IF LeftMouse(win) THEN Raise(0)
  ENDLOOP
EXCEPT
  closeiface()
  ExceptionReport('main()')
ENDPROC

PROC cosmic()
   DEF ib:PTR TO intuitionbase
   DEF x,q, str[50]:STRING
   DEF old:PTR TO recursedata

  ib:=intuitionbase
  q := Eor(ib.micros,ib.seconds) ->- count
  Rnd(q OR $80000000)
  q := Rnd(1000)

  dorgb := TRUE->q AND 1
  IF q AND 2
     feedback := Rnd(59) / 10
     alternate :=0
  ELSE
     alternate := Rnd(89) / 10
     feedback := 0
  ENDIF

  FOR x := 0 TO 10 DO Rnd(32768)
  x:=0
  WHILE x<FLAME_SIZE
     flame[x] := Rnd(32768)!/16384.0-1.0*0.9
     x++
  ENDWHILE

  TextF(10,10,'dorgb=\d, feedback=\d, alternate=\d', dorgb, feedback, alternate)

  points:=0
  old := NEW [0.0,0.0,0.0,0.0,0.0,0.0,0]:recursedata
  recurse6d(old)
  FastDisposeList(old)

  IF count++ = 3
      count := 0
      Delay(120)
      clearwindow(win)


   ENDIF

ENDPROC

PROC    clearwindow(window:PTR TO window)


    FillPixelArray(window.rport,  window.borderleft,
                            window.bordertop,
                            window.width-window.borderright-1,
                            window.height-window.borderbottom-1, $00000000)


ENDPROC


PROC recurse6d(old:PTR TO recursedata)
   DEF f:PTR TO REAL->, alternate=FALSE
   DEF new:recursedata, x
   DEF rgb[3]:ARRAY OF CHAR, ix, iy, ir, ig, ib, t:PTR TO LONG

   new.level := old.level + 1

  CtrlC()

  FreeStack()


   IF points > MAXTOTALPOINTS THEN RETURN FALSE

   IF old.level >= MAXFLAMELEVEL
      points++

      ix := !old.x+1.0*(width/2!)! + left
      iy := !old.y+1.0*(height/2!)! + top

      t := ReadRGBPixel(rp,ix,iy)
      rgb[0] := Shr(t,16)
      rgb[1] := Shr(t,8)
      rgb[2] := t AND $FF

      ir := ! old.r * 40.0 + 127.0 !
      ig := ! old.g * 40.0 + 127.0 !
      ib := ! old.b * 40.0 + 127.0 !

      ->ir := ! Fsqrt(! old.r * 3000.0 + 3000.0) !
      ->ig := ! Fsqrt(! old.g * 3000.0 + 3000.0) !
      ->ib := ! Fsqrt(! old.b * 3000.0 + 3000.0) !

      ir := Max(Min(ir, 255), 0)
      ig := Max(Min(ig, 255), 0)
      ib := Max(Min(ib, 255), 0)

      ir := rgb[0] + ir / 2
      ig := rgb[1] + ig / 2
      ib := rgb[2] + ib / 2

      ->ir := ir + (255-ir/10)
      ->ig := ig + (255-ig/10)
      ->ib := ib + (255-ib/10)


      ->IF rgb[0] OR rgb[1] OR rgb[2] THEN alternate := TRUE

      WriteRGBPixel(rp, ix, iy,
      Long([0,ir,ig,ib]:CHAR))

   ELSE


   f := flame

    FOR x := 0 TO 1

      FUNCTION

      ->FEEDBACK(x)
      ->FEEDBACK(y)
      ->>FEEDBACK(r)
      ->FEEDBACK(g)
      ->FEEDBACK(b)
      ->FEEDBACK(z)

      ->ALTERNATE(x)
      ->ALTERNATE(y)
      ->ALTERNATE(r)
      ->ALTERNATE(g)
      ->ALTERNATE(b)
      ->ALTERNATE(z)

      IF recurse6d(new)=FALSE THEN RETURN FALSE

   ENDFOR


  ENDIF
ENDPROC TRUE


->----------------------------------------------------------------------------<-

PROC openiface()
   DEF tags:PTR TO LONG, x
   DEF a, ib:PTR TO intuitionbase

   cybergfxbase := OpenLibrary('cybergraphics.library',41)
   IF cybergfxbase = NIL THEN Raise("LIB")

   colorwheelbase := OpenLibrary('gadgets/colorwheel.gadget',41)
   IF colorwheelbase = NIL THEN Raise("LIB")

  -> lets hope workbench is atleast 24bit !
  win:=OpenW(10,10,800,600,NIL,$800,'cosmic32',NIL,NIL,NIL,NIL)
  IF win=NIL THEN Raise("wndw")

  left := win.borderleft
  top := win.bordertop
  width := win.width-win.borderright-1

  height := win.height-win.borderbottom-1
  rp:=win.rport

  NEW flame[FLAME_SIZE]

  SetStdRast(rp)

  clearwindow(win)

ENDPROC

PROC closeiface()
  IF win THEN CloseW(win)
  IF cybergfxbase THEN CloseLibrary(cybergfxbase)
  IF colorwheelbase THEN CloseLibrary(colorwheelbase)
ENDPROC






