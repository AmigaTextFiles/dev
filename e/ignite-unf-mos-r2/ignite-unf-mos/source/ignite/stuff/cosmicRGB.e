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

OPT POWERPC, STACK=5000000

OPT PREPROCESS

MODULE '*macros'

MODULE 'graphics/modeid'
MODULE 'intuition/intuitionbase','intuition/intuition','intuition/screens'
MODULE 'utility/tagitem'

MODULE 'morphos/cybergfx'

RAISE "^C" IF CtrlC()=TRUE
RAISE "STCK" IF FreeStack() < 8000

CONST MAXFLAMELEVEL   = 250
CONST MAXTOTALPOINTS  = 300000
CONST FLAME_SIZE      = 500
CONST WIDTH = 800, HEIGHT = 600
CONST HASHMASK = $FFFF
CONST HASHSIZE = HASHMASK+1


#define HASHXY(x,y) (x + y AND HASHMASK)

OBJECT point
   x:INT, y:INT
   r:LONG, g:LONG, b:LONG
   hnext:PTR TO point
ENDOBJECT

DEF flame:PTR TO DOUBLE
DEF numpoints, count=0

DEF pointMem:PTR TO point
DEF pointHash:PTR TO LONG

DEF win:PTR TO window, width, height, centx, centy
DEF rp

DEF maxRCount, maxGCount, maxBCount
DEF totRCount, totGCount, totBCount


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

  ib:=intuitionbase
  q := Mul(ib.micros,ib.seconds) ->- count
  Rnd(q OR $80000000)
  q := Rnd(1000)


  FOR x := 0 TO 10 DO Rnd(32768)

  FOR x := 0 TO 5 DO flame[x] := Rnd(32768)!/16384.0-1.0*0.9
  /*
  FOR x := 6 TO 60 STEP 6
     flame[x+0] := !-flame[x-6]
     flame[x+1] := !-flame[x-6+1]
     flame[x+2] := Rnd(32768)!/16384.0-1.0*0.9
     flame[x+3] := !-flame[x-6+3]
     flame[x+4] := !-flame[x-6+4]
     flame[x+5] := Rnd(32768)!/16384.0-1.0*0.9
  ENDFOR
  */
  FOR x := 6 TO 60 STEP 6
     flame[x+0] := Rnd(32768)!/16384.0-1.0*0.9
     flame[x+1] := Rnd(32768)!/16384.0-1.0*0.9
     flame[x+2] := Rnd(32768)!/16384.0-1.0*0.9
     flame[x+3] := Rnd(32768)!/16384.0-1.0*0.9
     flame[x+4] := Rnd(32768)!/16384.0-1.0*0.9
     flame[x+5] := Rnd(32768)!/16384.0-1.0*0.9
  ENDFOR



  numpoints:=0
  maxRCount:=0
  maxGCount:=0
  maxBCount:=0
  totRCount:=0
  totGCount:=0
  totBCount:=0

  FOR x := 0 TO HASHSIZE-1 DO pointHash[x] := NIL

  recurseRGB(0.0,0.0,0.0,0.0,0,0)
  WriteF('MaxCount=\d,\d,\d\n', maxRCount, maxGCount, maxBCount)
  renderRGB()

  IF count++ = 0
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

PROC findPoint(point:REG PTR TO point, x:REG,y:REG)
   WHILE point
      IF point.x = x
         IF point.y = y
            RETURN point
         ENDIF
      ENDIF
      point := point.hnext
   ENDWHILE
ENDPROC NIL

PROC recurseRGB_(x:DOUBLE,y:DOUBLE,ox:DOUBLE, oy:DOUBLE, lev,col)
   DEF f:PTR TO DOUBLE, nx:DOUBLE, ny:DOUBLE
   DEF i, point:PTR TO point, oldpoint:PTR TO point


  CtrlC()

  FreeStack()


   IF numpoints > MAXTOTALPOINTS THEN RETURN FALSE

   IF lev >= MAXFLAMELEVEL

      point := pointMem[numpoints++]

      IF ! x > -1.0
      IF ! x < 1.0
      IF ! y > -1.0
      IF ! y < 1.0

         point.x := ! x * (width/2!) ! + centx
         point.y := ! y * (height/2!) ! + centy

         i := HASHXY(point.x, point.y)
         oldpoint := findPoint(pointHash[i], point.x, point.y)
         IF oldpoint
            IF col AND %001
               oldpoint.r++
               IF ! Fabs(!x-ox) > 0.2 THEN oldpoint.b++
               IF ! Fabs(!y-oy) > 0.2 THEN oldpoint.g++
            ENDIF
            IF col AND %010
               oldpoint.g++
               IF ! Fabs(!x-ox) > 0.2 THEN oldpoint.r++
               IF ! Fabs(!y-oy) > 0.2 THEN oldpoint.b++
            ENDIF
            IF col AND %100
               oldpoint.b++
               IF ! Fabs(!x-ox) > 0.2 THEN oldpoint.g++
               IF ! Fabs(!y-oy) > 0.2 THEN oldpoint.r++
            ENDIF
            maxRCount := Max(maxRCount, oldpoint.r)
            maxGCount := Max(maxGCount, oldpoint.g)
            maxBCount := Max(maxBCount, oldpoint.b)
         ELSE
            point.hnext := pointHash[i]
            pointHash[i] := point
            IF col AND %001
               point.r++
               ->IF ! Fabs(!x-ox) > 0.2 THEN oldpoint.b++
               ->IF ! Fabs(!y-oy) > 0.2 THEN oldpoint.g++
            ENDIF
            IF col AND %010
               point.g++
               ->IF ! Fabs(!x-ox) > 0.2 THEN oldpoint.r++
               ->IF ! Fabs(!y-oy) > 0.2 THEN oldpoint.b++
            ENDIF
            IF col AND %100
               point.b++
               ->IF ! Fabs(!x-ox) > 0.2 THEN oldpoint.g++
               ->IF ! Fabs(!y-oy) > 0.2 THEN oldpoint.r++
            ENDIF
         ENDIF
      ENDIF ; ENDIF ; ENDIF ; ENDIF

   ELSE

     lev++

     f := flame



      nx := !(!x*f[]++)+(!y*f[]++)+f[]++
      ny := !(!x*f[]++)+(!y*f[]++)+f[]++

      IF recurseRGB(nx,ny,x,y,lev,%100)=FALSE THEN RETURN FALSE

      nx := !(!x*f[]++)+(!y*f[]++)+f[]++
      ny := !(!x*f[]++)+(!y*f[]++)+f[]++

      IF recurseRGB(nx,ny,x,y,lev,%010)=FALSE THEN RETURN FALSE

      nx := !(!x*f[]++)+(!y*f[]++)+f[]++
      ny := !(!x*f[]++)+(!y*f[]++)+f[]++

      IF recurseRGB(nx,ny,x,y,lev,%001)=FALSE THEN RETURN FALSE

      ->RETURN TRUE

      nx := !(!x*f[]++)+(!y*f[]++)+f[]++
      ny := !(!x*f[]++)+(!y*f[]++)+f[]++

      IF recurseRGB(nx,ny,x,y,lev,%111)=FALSE THEN RETURN FALSE

      nx := !(!x*f[]++)+(!y*f[]++)+f[]++
      ny := !(!x*f[]++)+(!y*f[]++)+f[]++

      IF recurseRGB(nx,ny,x,y,lev,%011)=FALSE THEN RETURN FALSE

      nx := !(!x*f[]++)+(!y*f[]++)+f[]++
      ny := !(!x*f[]++)+(!y*f[]++)+f[]++

      IF recurseRGB(nx,ny,x,y,lev,%110)=FALSE THEN RETURN FALSE

      nx := !(!x*f[]++)+(!y*f[]++)+f[]++
      ny := !(!x*f[]++)+(!y*f[]++)+f[]++

      IF recurseRGB(nx,ny,x,y,lev,%101)=FALSE THEN RETURN FALSE




  ENDIF
ENDPROC TRUE

PROC recurseRGB(x:DOUBLE,y:DOUBLE,ox:DOUBLE, oy:DOUBLE, lev,col)
   DEF f:PTR TO DOUBLE, nx:DOUBLE, ny:DOUBLE
   DEF i, point:PTR TO point, oldpoint:PTR TO point


  CtrlC()

  FreeStack()


   IF numpoints > MAXTOTALPOINTS THEN RETURN FALSE

   IF lev >= MAXFLAMELEVEL

      point := pointMem[numpoints++]

      IF ! x > -1.0
      IF ! x < 1.0
      IF ! y > -1.0
      IF ! y < 1.0

         point.x := ! x * (width/2!) ! + centx
         point.y := ! y * (height/2!) ! + centy

         i := HASHXY(point.x, point.y)
         oldpoint := findPoint(pointHash[i], point.x, point.y)
         IF oldpoint
            IF col AND %001
               oldpoint.r++
               ->IF ! Fabs(!x-ox) > 0.2 THEN oldpoint.b++
               ->IF ! Fabs(!y-oy) > 0.2 THEN oldpoint.g++
            ENDIF
            IF col AND %010
               oldpoint.g++
               ->IF ! Fabs(!x-ox) > 0.2 THEN oldpoint.r++
               ->IF ! Fabs(!y-oy) > 0.2 THEN oldpoint.b++
            ENDIF
            IF col AND %100
               oldpoint.b++
               ->IF ! Fabs(!x-ox) > 0.2 THEN oldpoint.g++
               ->IF ! Fabs(!y-oy) > 0.2 THEN oldpoint.r++
            ENDIF
            IF col AND %1000
               oldpoint.r++
               oldpoint.g++
               oldpoint.b++
            ENDIF
            maxRCount := Max(maxRCount, oldpoint.r)
            maxGCount := Max(maxGCount, oldpoint.g)
            maxBCount := Max(maxBCount, oldpoint.b)
         ELSE
            point.hnext := pointHash[i]
            pointHash[i] := point
            IF col AND %001
               point.r++
               ->IF ! Fabs(!x-ox) > 0.2 THEN point.b++
               ->IF ! Fabs(!y-oy) > 0.2 THEN point.g++
            ENDIF
            IF col AND %010
               point.g++
               ->IF ! Fabs(!x-ox) > 0.2 THEN point.r++
               ->IF ! Fabs(!y-oy) > 0.2 THEN point.b++
            ENDIF
            IF col AND %100
               point.b++
               ->IF ! Fabs(!x-ox) > 0.2 THEN point.g++
               ->IF ! Fabs(!y-oy) > 0.2 THEN point.r++
            ENDIF
         ENDIF
      ENDIF ; ENDIF ; ENDIF ; ENDIF

   ELSE

     lev++

     f := flame



      nx := !(!x*f[]++)+(!y*f[]++)+f[]++
      ny := !(!x*f[]++)+(!y*f[]++)+f[]++

      IF recurseRGB(nx,ny,x,y,lev,%100)=FALSE THEN RETURN FALSE

      nx := !(!x*f[]++)+(!y*f[]++)+f[]++
      ny := !(!x*f[]++)+(!y*f[]++)+f[]++

      IF recurseRGB(nx,ny,x,y,lev,%010)=FALSE THEN RETURN FALSE

      nx := !(!x*f[]++)+(!y*f[]++)+f[]++
      ny := !(!x*f[]++)+(!y*f[]++)+f[]++

      IF recurseRGB(nx,ny,x,y,lev,%001)=FALSE THEN RETURN FALSE

      nx := !(!x*f[]++)+(!y*f[]++)+f[]++
      ny := !(!x*f[]++)+(!y*f[]++)+f[]++

      IF recurseRGB(nx,ny,x,y,lev,%1000)=FALSE THEN RETURN FALSE


  ENDIF
ENDPROC TRUE

PROC renderRGB()
   DEF point:PTR TO point
   DEF r, g, b, a
   DEF rx:DOUBLE, ry:DOUBLE, rz:DOUBLE
   DEF gx:DOUBLE, gy:DOUBLE, gz:DOUBLE
   DEF bx:DOUBLE, by:DOUBLE, bz:DOUBLE

   rx := !1.0 / Flog(maxRCount!)
   ry := maxRCount!/Flog(maxRCount!)
   rz := maxRCount!/(maxRCount! - ry)

   gx := !1.0 / Flog(maxGCount!)
   gy := maxGCount!/Flog(maxGCount!)
   gz := maxGCount!/(maxGCount! - gy)

   bx := !1.0 / Flog(maxBCount!)
   by := maxBCount!/Flog(maxBCount!)
   bz := maxBCount!/(maxBCount! - by)


   FOR a := 0 TO (HASHSIZE-1)
      point := pointHash[a]
      WHILE point

         r := IF point.r THEN ! Flog(point.r!) * rx * 350.0 - ry * rz ! ELSE NIL
         g := IF point.g THEN ! Flog(point.g!) * gx * 350.0 - gy * gz ! ELSE NIL
         b := IF point.b THEN ! Flog(point.b!) * bx * 350.0 - by * bz ! ELSE NIL

         r := Max(Min(r, 255),0)
         g := Max(Min(g, 255),0)
         b := Max(Min(b, 255),0)

         WriteRGBPixel(rp, point.x, point.y, Long([0,r,g,b]:CHAR))

         point := point.hnext

      ENDWHILE

   ENDFOR

ENDPROC

->----------------------------------------------------------------------------<-

PROC openiface()
   DEF tags:PTR TO LONG, x
   DEF ib:PTR TO intuitionbase

   cybergfxbase := OpenLibrary('cybergraphics.library',41)
   IF cybergfxbase = NIL THEN Raise("LIB")

  -> lets hope workbench is atleast 24bit !
  win:=OpenW(10,10,800,600,NIL,$800,'cosmicRGB',NIL,NIL,NIL,NIL)
  IF win=NIL THEN Raise("wndw")

  centx := win.borderleft + (WIDTH/2)
  centy := win.bordertop + (HEIGHT/2)
  width := win.width-win.borderright-1
  height := win.height-win.borderbottom-1

  rp:=win.rport

  NEW flame[FLAME_SIZE]
  NEW pointMem[MAXTOTALPOINTS+1]
  NEW pointHash[HASHSIZE+1]

  SetStdRast(rp)

  clearwindow(win)

ENDPROC

PROC closeiface()
  IF win THEN CloseW(win)
  IF cybergfxbase THEN CloseLibrary(cybergfxbase)
ENDPROC






