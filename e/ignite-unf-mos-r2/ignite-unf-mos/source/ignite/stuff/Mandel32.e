OPT POWERPC, PREPROCESS

MODULE 'morphos/cybergraphics'
MODULE 'colorwheel'


CONST CALCW=800,HEIGHT=600, DEPTH=500

CONST PID2 = 1.570796326
CONST PI =   3.141592653
CONST PI2 =  6.283185307

PROC main() HANDLE
  DEF xmax=CALCW!:DOUBLE,ymax=HEIGHT-1!:DOUBLE
  DEF width=0.2:DOUBLE, height=0.2:DOUBLE
  DEF left=-0.85:DOUBLE,top=-0.25:DOUBLE
  DEF w,x,y,xr:DOUBLE
  DEF r, g, b
  DEF fx:DOUBLE, fy:DOUBLE, xc:DOUBLE, yc:DOUBLE

  cybergfxbase := OpenLibrary('cybergraphics.library', 0)
  IF cybergfxbase = NIL THEN Throw("LIB", 'cybergraphics')

  colorwheelbase := OpenLibrary('gadgets/colorwheel.gadget', 0)
  IF colorwheelbase = NIL THEN Throw("LIB", 'colorwheel')

  IF w:=OpenW(20,11,CALCW+30,HEIGHT+40,$200,$E,'Mandel32 by LS',NIL,1,NIL)
    FOR x:=0 TO CALCW-1
      xr:=x!/xmax*width+left
      FOR y:=0 TO HEIGHT-1
         fx := xr
         fy := y!/ymax*height+top
         xc := (!fx)
         yc := (!fy)
         r, g, b := mandJummyTight(fx,fy, xc, yc,30,15.3)
         ->r, g, b := flamediv(fx, fy,xc,yc, 12, 5.0)
         debug:
         WriteRGBPixel(stdrast, x+20,y+25, Long([0,r SHR 24,g SHR 24,b SHR 24]:CHAR))
       ENDFOR
    ENDFOR
    WaitIMessage(w)
    CloseW(w)
  ELSE
     WriteF('could not open window!\n')
  ENDIF

EXCEPT DO

   IF colorwheelbase THEN CloseLibrary(colorwheelbase)
   IF cybergfxbase THEN CloseLibrary(cybergfxbase)

ENDPROC

#define fMin(a,b) (IF ! (a) < (b) THEN a ELSE b)
#define fMax(a,b) (IF ! (a) > (b) THEN a ELSE b)

-> the good old school example
PROC escapeTime(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF a:DOUBLE, b:DOUBLE, t
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    a := !x*x
    b := !y*y
    y:=!x+x*y+yc
    x:=!a-b+xc
  ENDWHILE
  t := t! / (it!) * 16000000.0 !
ENDPROC t SHL 8, t SHL 8, t SHL 8

-> successfully sets treshhold relatively to the absoulte value of (x,y)
-> this makes tresh microscopicly small when zooming in.
-> this almost removed the "banding" outside set. Not as good as (Floating EscapeTime though)
-> HEY! Suddenly a whole new world showed itself on high zooms ! :)
-> Ive ssen stuff like this on Elena's fractals.
-> also renering of outside gos alot faster now, 500 iterations is nothing..
PROC escapeTimeSmartTresh(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF a:DOUBLE, b:DOUBLE, t

  tresh := Fabs(!x*x+(!y*y) * tresh)

  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    a := !x*x
    b := !y*y
    y:=!x+x*y+yc
    x:=!a-b+xc
  ENDWHILE
  t := 16000000 - (t! / (it!) * 16000000.0 !)
ENDPROC t SHL 8, t SHL 8, t SHL 8



-> very nice shading of fractal "inside"
PROC trappedMargin(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF a:DOUBLE, b:DOUBLE, fr:DOUBLE, t
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    a := !x*x
    b := !y*y
    y:=!x+x*y+yc
    x:=!a-b+xc
  ENDWHILE
  fr := fMax(!tresh-(!x*x+(!y*y)), 0.0)
  t := ! fr / tresh * 45000.0 * 200000.0 !
ENDPROC t SHL 8, t SHL 8, t SHL 8

PROC trappedMarginEscapeTime(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF fr:DOUBLE, fg:DOUBLE, fb:DOUBLE
  DEF r, g, b, t
  DEF max:DOUBLE, sub:DOUBLE, mul:DOUBLE, eemax:DOUBLE, _eemax:DOUBLE
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE
  IF ! x*x+(!y*y) < tresh
     max := tresh
     eemax := Fexp(Fexp(max))
     sub := ! max / eemax
     mul := ! max / (!max-sub) * 16000000.0
     _eemax := !1.0/eemax
     fr := !tresh-(!x*x+(!y*y))
     r := ! Fexp(Fexp(fr)) * _eemax - sub * mul !
  ELSE
     r := t! / (it!) * 16000000.0 !
     g := r
     b := r
  ENDIF
ENDPROC r SHL 8, r SHL 8, r SHL 8

PROC trappedMarginSmoothEscape(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF fr:DOUBLE, ft:DOUBLE
  DEF r, g, b, t
  DEF max:DOUBLE, sub:DOUBLE, mul:DOUBLE, eemax:DOUBLE, _eemax:DOUBLE
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE
  IF ! x*x+(!y*y) < tresh
     max := tresh
     eemax := Fexp(Fexp(max))
     sub := ! max / eemax
     mul := ! max / (!max-sub) * 16000000.0
     _eemax := !1.0/eemax
     fr := !tresh-(!x*x+(!y*y))
     r := ! Fexp(Fexp(fr)) * _eemax - sub * mul !
  ELSE
     z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc

      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      t := ! 16000000.0 - (!ft / (it!) * 16000000.0) !
      r := t

  ENDIF
ENDPROC r SHL 8, r SHL 8, r SHL 8

PROC trappedMarginRGBEscapeTime(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF fr:DOUBLE, fg:DOUBLE, fb:DOUBLE
  DEF sx:DOUBLE, sy:DOUBLE
  DEF r, g, b, t
  sx := x
  sy := y
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE
  IF !x*x+(!y*y) < tresh
     z0 := !x*x
     z1 := !y*y
     y:=!x+x*y+yc
     x:=!z0-z1+xc
     fb := !tresh-(!x*x+(!y*y))->, 0.0)
     b := ! (! fb * 17430.0 * 9055.0 / tresh) !
     z0 := !x*x
     z1 := !y*y
     y:=!x+x*y+yc
     x:=!z0-z1+xc
     fr := !tresh-(!x*x+(!y*y))->, 0.0)
     r := ! (! fr * 17430.0 * 9055.0 / tresh) !
     z0 := !x*x
     z1 := !y*y
     y:=!x+x*y+yc
     x:=!z0-z1+xc
     fg := !tresh-(!x*x+(!y*y))->, 0.0)
     g := ! (! fg * 17430.0 * 9055.0 * 8.0 / tresh) !
  ELSE
     r := 255 - (t! / (it!) * 16000000.0 !)
     g := r
     b := r
  ENDIF
ENDPROC r SHL 8, g SHL 8, b SHL 8


PROC mandelMarginRGB_SmoothEscape(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF fr:DOUBLE, fg:DOUBLE, fb:DOUBLE
  DEF r, g, b, t, ft:DOUBLE
  DEF sx:DOUBLE, sy:DOUBLE
  DEF it0
  DEF _eemax:DOUBLE, eemax:DOUBLE, max:DOUBLE, sub:DOUBLE, mul:DOUBLE

   tresh := !x*x+(!y*y) * tresh

  sx := x
  sy := y

  it0 := !Fsqrt(it!)! + 1
  FOR t := 0 TO it0
     z0 := !x*x
     z1 := !y*y
     y:=!x+x*y+yc
     x:=!z0-z1+xc
  ENDFOR
     max := !tresh
     eemax := Fexp(Fexp((max)))
     sub := ! max / eemax
     mul := ! max / (!max-sub) * 16000000.0
     _eemax := !1.0/eemax


     fb := fMax(!tresh-(!z0+(!z1)), 0.0)
     b := ! Fexp(Fexp((fb))) * _eemax - sub * mul !

     fr := fMax(!tresh-(!x*x+(!y*y)), 0.0)
     r := ! Fexp(Fexp((fr))) * _eemax - sub * mul !
     z0 := !x*x
     z1 := !y*y
     y:=!x+x*y+yc
     x:=!z0-z1+xc
     fg := fMax(!tresh-(!x*x+(!y*y)), 0.0)
     g := ! Fexp(Fexp((fg))) * _eemax - sub * mul !

  x := sx
  y := sy
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE
  IF ! x*x+(!y*y) <= tresh

  ELSE
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc

      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      t := ! 16000000.0 - (!ft / (it!) * 16000000.0) !
      r := t
      g := t
      b := t
  ENDIF
ENDPROC r SHL 8, g SHL 8, b SHL 8

PROC mandSDRGBFEG(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF fr:DOUBLE, fg:DOUBLE, fb:DOUBLE
  DEF r, g, b, t, ft:DOUBLE
  DEF sx:DOUBLE, sy:DOUBLE
  DEF it0
  DEF _eemax:DOUBLE, eemax:DOUBLE, max:DOUBLE, sub:DOUBLE, mul:DOUBLE

  z0 := !x*x
  z1 := !y*y
  y:=!x+x*y+yc
  x:=!z0-z1+xc

  sx := Fabs(x)
  sy := Fabs(y)

  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE
  IF ! x*x+(!y*y) <= tresh
     max := ! tresh
     eemax := Fsqrt(max)
     sub := ! max / eemax
     mul := ! max / (!max-sub) * 16000000.0
     _eemax := !1.0/eemax


     fb := ! fMax(!x*y-(!sx*sy), 0.0) / tresh
     b := ! Fsqrt(fb) * _eemax - sub * mul !
     z0 := !x*x
     z1 := !y*y
     y:=!x+x*y+yc
     x:=!z0-z1+xc
     fr := ! fMax(!x*y-(!sx*sy), 0.0) / tresh
     r := ! Fsqrt(fr) * _eemax - sub * mul !
     z0 := !x*x
     z1 := !y*y
     y:=!x+x*y+yc
     x:=!z0-z1+xc
     fg := ! fMax(!x*y-(!sx*sy), 0.0) / tresh
     g := ! Fsqrt(fg) * _eemax - sub * mul !

  ELSE
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc

      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      t := ! 16000000.0 - (!ft / (it!) * 16000000.0) !
      r := t
      g := t
      b := t
  ENDIF
ENDPROC r SHL 8, g SHL 8, b SHL 8

-> nope, colours are not outiside! (..or are they ?)
PROC mandelMarginRGB_FloatEscapeRGB(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF fr:DOUBLE, fg:DOUBLE, fb:DOUBLE
  DEF r, g, b, t, ft:DOUBLE
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE
  IF ! x*x+(!y*y) <= tresh
     ->z3 := !3200000.0 * 66.0 / tresh
     z3 := ! 1.0 / Fexp(Fexp(tresh)) * 3200000.0 * 5.0
     z0 := !x*x
     z1 := !y*y
     y:=!x+x*y+yc
     x:=!z0-z1+xc
     fb := fMax(!tresh-(!x*x+(!y*y)), 0.0)
     b := ! Fexp(Fexp(fb)) * z3 !
     z0 := !x*x
     z1 := !y*y
     y:=!x+x*y+yc
     x:=!z0-z1+xc
     fr := fMax(!tresh-(!x*x+(!y*y)), 0.0)
     r := ! Fexp(Fexp(fr)) * z3 !
     z0 := !x*x
     z1 := !y*y
     y:=!x+x*y+yc
     x:=!z0-z1+xc
     fg := fMax(!tresh-(!x*x+(!y*y)), 0.0)
     g := ! Fexp(Fexp(fg)) * z3 !
  ELSE
      z3 := ! 1.0/Flog(1.0) * 16000000.0
      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      r := ! 16000000.0 - (Flog(!ft / (it!))*z3) !
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc
      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      r := ! 16000000.0 - (Flog(!ft / (it!))*z3) !
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc
      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      r := ! 16000000.0 - (Flog(!ft / (it!))*z3) !


  ENDIF
ENDPROC r SHL 8, g SHL 8, b SHL 8

-> crap
PROC escapeMarginRepeat(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF a:DOUBLE, b:DOUBLE, fr:DOUBLE, t=0, rept=0
bla:
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    a := !x*x
    b := !y*y
    y:=!x+x*y+yc
    x:=!a-b+xc
  ENDWHILE
  IF (! x*x+(!y*y) >= tresh)
     IF rept++ < 3
         x := !tresh-(!x*x+(!y*y))
         JUMP bla
     ELSE
        fr := !x*x+(!y*y)-tresh
        t := ! fr / tresh !
     ENDIF
  ELSE
     fr := fMax(!tresh-(!x*x+(!y*y)), 0.0)
     t := ! fr / tresh * 4500.0 * 200000.0 !
  ENDIF

ENDPROC t SHL 8, t SHL 8, t SHL 8

-> crap
PROC escapeDiff(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF a:DOUBLE, b:DOUBLE, fr:DOUBLE, t
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    a := !x*x
    b := !y*y
    y:=!x+x*y+yc
    x:=!a-b+xc
  ENDWHILE
  IF !x*x+(!y*y) >= tresh
     fr := Fabs(!a-b+tresh/2/tresh)
     t := ! fr * 16000000.0 !
  ELSE
     t := 0
  ENDIF
ENDPROC t SHL 8, t SHL 8, t SHL 8

PROC mandelDiff(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF a:DOUBLE, b:DOUBLE, fr:DOUBLE, t
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    a := !x*x
    b := !y*y
    y:=!x+x*y+yc
    x:=!a-b+xc
  ENDWHILE
  IF !x*x+(!y*y) < tresh
     fr := !a-b+tresh/2.0/tresh
     t := ! fr * 16000000.0 !
  ELSE
     t := 0
  ENDIF
ENDPROC t SHL 8, t SHL 8, t SHL 8

PROC blackwhitetight(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF a:DOUBLE, b:DOUBLE, t, xtemp:DOUBLE, ytemp:DOUBLE, r
  DEF fr=0.1:DOUBLE
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    a := !x*x
    b := !y*y
    y:=!x+x*y+yc
    x:=!a-b+xc
    fr := ! fr + (!tresh-(!a+b)/tresh*fr)
  ENDWHILE
  fr := ! fr / (it!) * 16000000.0
  r := !fr !
ENDPROC r SHL 8, r SHL 8, r SHL 8

PROC trappedSmoothEscapeTime(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF a:DOUBLE, b:DOUBLE, t, r
  DEF z0=0.1:DOUBLE, z1=255.0:DOUBLE
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y) < tresh)
    a := !x*x
    b := !y*y
    y:=!x+x*y+yc
    x:=!a-b+xc
    z0 := ! z0 + (!tresh-(!a+b)/tresh*z0)
    z1 := ! z1 - (!z1*0.1)
  ENDWHILE
  IF !x*x+(!y*y) >= tresh
     r := ! (t!/(it!)) * 16000000.0 !
  ELSE
     r := ! z0 / it! * 16000000.0 !
  ENDIF
ENDPROC r SHL 8, r SHL 8, r SHL 8

PROC weird(x,y,xc,yc,it,tresh)
  DEF xtemp,a, t
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    xtemp:=x; x:=!x*x-(!y*y)+xc; y:=!xtemp+xtemp*y+yc
  ENDWHILE
  a := ! x*y / (!tresh / 4000000000.0) - 2000000000.0 !
ENDPROC a, a, a

PROC calc_(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh)
  DEF xtemp:DOUBLE,rgb[3]:ARRAY OF LONG, t=0.0:DOUBLE
  DEF a:DOUBLE, a2:DOUBLE, fit:DOUBLE, z

  REPEAT
    a  := ! x * x
    a2 := ! y * y
    t  := ! t - fMin(! a*a+(!a2*a2) - tresh, 0.0)
    xtemp := x
    x := ! a - a2 + xc
    y := ! xtemp + xtemp * y + yc
    it--
  UNTIL (it < 1) OR (! a + a2 >= tresh)
  ConvertHSBToRGB([!t! SHL 24, -1, !t! SHL 24]:LONG, rgb)
ENDPROC rgb[0], rgb[1], rgb[2]

PROC mandJummy1(x:REG DOUBLE,y:REG DOUBLE,xc:REG DOUBLE,yc:REG DOUBLE,it:REG,tresh:REG DOUBLE)
  DEF xtemp:REG DOUBLE,rgb[3]:ARRAY OF LONG, t=0:REG
  DEF a:REG DOUBLE, a2:REG DOUBLE, z0=0.0:REG DOUBLE, z1=0.0:REG DOUBLE

  REPEAT
    a  := ! x * x
    a2 := ! y * y
    ->xtemp := x
    y := ! x + x * y + yc
    x := ! a - a2 + xc
    z0 := ! z0 - fMin(! a-tresh, 0.0)
    z1 := ! z1 - fMin(! a2-tresh, 0.0)
    t++
  UNTIL (t > it) OR (! a+a2 >= tresh)
  z0 := ! z0 / tresh / (it!) * 65535.0
  z1 := ! z1 / tresh / (it!) * 65535.0
  ConvertHSBToRGB([!Fsqrt(!z1*3000.0)! SHL 16, -1, !z0! SHL 16]:LONG, rgb)
ENDPROC rgb[0], rgb[1], rgb[2]

PROC mandJummy2(x:REG DOUBLE,y:REG DOUBLE,xc:REG DOUBLE,yc:REG DOUBLE,it:REG,tresh:REG DOUBLE)
  DEF xtemp:REG DOUBLE,rgb[3]:ARRAY OF LONG, t=0:REG
  DEF a:REG DOUBLE, a2:REG DOUBLE, z0=1.0:REG DOUBLE, z1=1.0:REG DOUBLE

  REPEAT
    a  := ! x * x
    a2 := ! y * y
    y := ! x + x * y + yc
    x := ! a - a2 + xc
    z0 := ! z0 - (! fMin(! a-tresh, 0.0) / tresh * z0)
    z1 := ! z1 - (! fMin(! a2-tresh, 0.0) / tresh * z1)
    t++
  UNTIL (t > it) OR (! a+a2 >= tresh)
  z0 := ! z0 / tresh / (it!) * 65535.0
  z1 := ! z1 / tresh / (it!) * 65535.0
  ConvertHSBToRGB([!Fsqrt(!z1*3000.0)! SHL 16, -1, !z0! SHL 16]:LONG, rgb)
ENDPROC rgb[0], rgb[1], rgb[2]

PROC mandJummyTight(x:REG DOUBLE,y:REG DOUBLE,xc:REG DOUBLE,yc:REG DOUBLE,it:REG,tresh:REG DOUBLE)
  DEF xtemp:REG DOUBLE,rgb[3]:ARRAY OF LONG, t=0:REG
  DEF a:REG DOUBLE, a2:REG DOUBLE, z0=1.0:REG DOUBLE, z1=1.0:REG DOUBLE
  DEF xt:DOUBLE, yt:DOUBLE

  REPEAT
    xt := x
    yt := y
    a  := ! x * x
    a2 := ! y * y
    y := ! x + x * y + yc
    x := ! a - a2 + xc
    IF !a > 0.0
      z0 := ! z0 - fMin(! fMax(!a, 0.0) - tresh / tresh * z0, 0.0)
    ELSE
      z0 := ! z0 - fMax(! fMin(!a, 0.0) + tresh / tresh * z0, 0.0)
    ENDIF
    IF !a2 > 0.0
      z1 := ! z1 - fMin(! fMax(!a2, 0.0) - tresh / tresh * z1, 0.0)
    ELSE
      z1 := ! z1 - fMax(! fMin(!a2, 0.0) + tresh / tresh * z1, 0.0)
    ENDIF
    ->z1 := ! z1 + fMax(! a2+a / tresh * z1, 0.0)
    t++
  UNTIL (t > it) OR (! a+a2 >= tresh)
  z0 := ! z0 / tresh / (it!) * 65535.0
  z1 := ! z1 / tresh / (it!) * 65535.0
  ConvertHSBToRGB([!z1! SHL 16, -1, !z0! SHL 16]:LONG, rgb)
ENDPROC rgb[0], rgb[1], rgb[2]

PROC mandJummy1b(x:REG DOUBLE,y:REG DOUBLE,xc:REG DOUBLE,yc:REG DOUBLE,it:REG,tresh:REG DOUBLE)
  DEF xtemp:REG DOUBLE,rgb[3]:ARRAY OF LONG, t=0:REG
  DEF a:REG DOUBLE, a2:REG DOUBLE, z0=0.0:REG DOUBLE, z1=0.0:REG DOUBLE

  WHILE (t++ < it) AND (! (a:=!x*x) + (a2:=!y*y) < tresh)
    ->a  := ! x * x
    ->a2 := ! y * y
    ->xtemp := x
    y := ! x + x * y + yc
    x := ! a - a2 + xc
    z0 := ! z0 - fMin(! a-tresh, 0.0)
    z1 := ! z1 - fMin(! a2-tresh, 0.0)
    ->t++
  ENDWHILE ->UNTIL (t > it) OR (! a+a2 >= tresh)
  z0 := ! z0 / tresh / (it!) * 65535.0
  z1 := ! z1 / tresh / (it!) * 65535.0
  ConvertHSBToRGB([!Fsqrt(!z1*3000.0)! SHL 16, -1, !z0! SHL 16]:LONG, rgb)
ENDPROC rgb[0], rgb[1], rgb[2]

PROC mandJummy3(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF xtemp:DOUBLE,rgb[3]:ARRAY OF LONG, t=0
  DEF a:DOUBLE, a2:DOUBLE, z0=0.0:DOUBLE, z1=0.0:DOUBLE

  REPEAT
    a  := ! x * x
    a2 := ! y * y
    xtemp := x
    x := ! a - a2 + xc
    y := ! xtemp + xtemp * y + yc
    z0 := ! z0 - fMin(! a*a-tresh, 0.0)
    z1 := ! z1 - fMin(! a2*a2-tresh, 0.0)
    t++
  UNTIL (t > it) OR (! a*a + (!a2*a2) >= tresh)
  z0 := ! z0 / tresh / (it!) * 200.0 * 16000000.0
  z1 := ! z1 / tresh / (it!) * 200.0 * 16000000.0
  ConvertHSBToRGB([!z1!, -1, !z0!]:LONG, rgb)
ENDPROC rgb[0], rgb[1], rgb[2]

PROC mandCalc3(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF xtemp,rgb[3]:ARRAY OF LONG, t=0
  DEF a:DOUBLE, a2:DOUBLE
  DEF z0=0.3:DOUBLE, z1=-0.7:DOUBLE
  DEF z2=0.3:DOUBLE, z3=-0.7:DOUBLE

  REPEAT
    a  := ! x * x
    a2 := ! y * y
    xtemp := x
    x := ! a - a2 + xc
    y := ! xtemp + xtemp * y + yc
    z0 := ! z0 + fMax(!a-tresh/tresh*z0, 0.0)
    z1 := ! z1 + fMin(!-tresh-a/tresh*z1, 0.0)
    z2 := ! z2 + fMax(!a2-tresh/tresh*z2, 0.0)
    z3 := ! z3 + fMin(!-tresh-a2/tresh*z3, 0.0)
    t++
  UNTIL (t > it) OR (! a + a2 >= tresh)
  z0 := ! z0 - z3 / (it!) * 65535.0
  z2 := ! z2 - z3 / (it!) * 65535.0
  ConvertHSBToRGB([!z2! SHL 16,-1, !z0! SHL 16]:LONG, rgb)
ENDPROC rgb[0], rgb[1], rgb[2]

PROC mandCalc____(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh)
  DEF xtemp:DOUBLE,rgb[3]:ARRAY OF LONG, t=0.0:DOUBLE
  DEF a:DOUBLE, a2:DOUBLE, fit:DOUBLE, z
  fit := it!

  REPEAT
    a  := ! x * x
    a2 := ! y * y
    t  := ! t - fMin(! a * a2 - tresh, 0.0)
    xtemp := x
    x := ! a - a2 + xc
    y := ! xtemp + xtemp * y + yc
    it--
  UNTIL (it < 1) OR (! a + a2 >= tresh)
  t := ! t / tresh * 50.0
  ConvertHSBToRGB([!t! SHL 24, -1, 128 SHL 24]:LONG, rgb)
ENDPROC rgb[0], rgb[1], rgb[2]

->Ax+By+C
->Dx+Ey+F

->X = Ax+By/A
->Y = Bx+Ay/B

PROC flamediv(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF xtemp:DOUBLE,rgb[3]:ARRAY OF LONG, t=0
  DEF a:DOUBLE, a2:DOUBLE, z0=0.0:DOUBLE, z1=0.0:DOUBLE

  xc := ! Fsin(xc)
  yc := ! Fsin(yc)
  REPEAT
    a := ! (!x*xc)+(!y*yc)/xc
    y := ! (!x*yc)+(!y*xc)/yc
    ->a := ! (!x/xc)+(!y/yc)*xc
    ->y := ! (!x/yc)+(!y/xc)*yc
    ->a := ! (!xc/x)+(!yc/y)*xc
    ->y := ! (!yc/x)+(!xc/y)*yc
    x := a
    z0 := ! z0 + fMin(! tresh-(!x*x), 0.0)
    z1 := ! z1 + fMin(! tresh-(!y*y), 0.0)
    t++
  UNTIL (t > it) OR (! x*y >= tresh)
  z0 := ! z0 / tresh / (it!) * 65535.0
  z1 := ! z1 / tresh / (it!) * 65535.0
  ConvertHSBToRGB([!z1! SHL 16, -1, !z0! SHL 16]:LONG, rgb)
ENDPROC rgb[0], rgb[1], rgb[2]

PROC simple(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF xtemp:DOUBLE,rgb[3]:ARRAY OF LONG, t=0
  DEF a:DOUBLE, a2:DOUBLE, z0=0.1:DOUBLE, z1=0.1:DOUBLE



  REPEAT
    a := ! y+(!x*yc)-yc
    y := ! x+(!y*xc)-xc
    x := a
    z0 := ! z0 + fMax(! tresh-(!x*x), 0.0)
    z1 := ! z1 + fMax(! tresh-(!y*y), 0.0)
    t++
  UNTIL (t > it) ->OR (! x*y >= tresh)
  z0 := ! z0 / tresh / (it!) * 65535.0
  z1 := ! z1 / tresh / (it!) * 65535.0
  ConvertHSBToRGB([!z1! SHL 16, -1, !z0! SHL 16]:LONG, rgb)
ENDPROC rgb[0], rgb[1], rgb[2]

PROC flameGrey(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t=0
  DEF a:DOUBLE, z0=0.1:DOUBLE
  DEF r

  WHILE (t++ < it) AND (!x*y < tresh)
    a := ! (!x*xc)+(!y*yc)/xc
    y := ! (!x*yc)+(!y*xc)/yc
    x := a
    z0 := ! z0 + fMax(Fsqrt(!tresh-(!x*y)*10.0), 0.0)
  ENDWHILE
  r := ! z0 / tresh * 100000000.0 / (it!) !
ENDPROC r SHL 8, r SHL 8, r SHL 8

PROC flameRGB(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t=0, zc:DOUBLE
  DEF a:DOUBLE, b:DOUBLE, c:DOUBLE
  DEF z0=0.1:DOUBLE, z1=0.1:DOUBLE, z2=0.1:DOUBLE
  DEF z:DOUBLE, ir, ig, ib

  zc := ! xc + yc * 0.5
  z := ! x + y * 0.5

  WHILE (t++ < it) ->AND (!x*y < tresh)
    a := ! (!x*xc)+(!y*yc)+(!z*zc)/xc
    b := ! (!x*yc)+(!y*zc)+(!z*xc)/yc
    c := ! (!x*zc)+(!y*zc)+(!z*yc)/zc
    x := a
    y := b
    z := c
    z0 := ! z0 + fMax(Fsqrt(!tresh-(!x*x)), 0.0)
    z1 := ! z1 + fMax(Fsqrt(!tresh-(!y*y)), 0.0)
    z2 := ! z2 + fMax(Fsqrt(!tresh-(!z*z)), 0.0)
  ENDWHILE
  ->ir := ! z0 / tresh * 100000000.0 / (it!) !
  ->ig := ! z1 / tresh * 100000000.0 / (it!) !
  ->ib := ! z2 / tresh * 100000000.0 / (it!) !
  ir := ! z0 / Fsqrt(!tresh*(it!)) * 6000000.0!
  ig := ! z1 / Fsqrt(!tresh*(it!)) * 6000000.0!
  ib := ! z2 / Fsqrt(!tresh*(it!)) * 6000000.0!
ENDPROC ir SHL 8, ig SHL 8, ib SHL 8

PROC realflame(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF xtemp:DOUBLE,rgb[3]:ARRAY OF LONG, t=0
  DEF a:DOUBLE, a2:DOUBLE, z0=0.1:DOUBLE, z1=0.1:DOUBLE
  xc := !1.0/xc
  yc := !1.0/yc

  REPEAT
    a := ! (!x*0.9)+(!y*-0.9)+xc
    y := ! (!x*-0.9)+(!y*0.9)+yc
    x := a
    z0 := ! z0 + fMax(! x * z0, 0.0)
    z1 := ! z1 + fMin(! y * z1, 0.0)
    t++
  UNTIL (t > it) OR (! x*y <= tresh)
  ConvertHSBToRGB([!z0 * 65536.0! SHL 16, -1, !z1 * 65536.0 ! SHL 16]:LONG, rgb)
ENDPROC rgb[0], rgb[1], rgb[2]

PROC mandIterAll(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF xtemp:DOUBLE,a, a2, fr=1.0:DOUBLE, fg=1.0:DOUBLE, fb=1.0:DOUBLE, t=0
  DEF r, g, b, grr=0.5:DOUBLE


  WHILE (t++<it)
    a  := ! x * x
    a2 := ! y * y
    IF !a+a2 > tresh THEN grr := ! grr + (!a+a2-tresh/tresh*grr)
    y := ! x + x * y + yc
    x := ! a - a2 + xc
    t++
  ENDWHILE

  r := !grr / (it!) * 1600.0 !
  g := !grr / (it!) * 1600.0 !
  b := !grr / (it!) * 1600.0 !

ENDPROC r SHL 1, g SHL 1, b SHL 1

-> http://linas.org/art-gallery/escape/escape.html
PROC floatingEscape(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF a:DOUBLE, b:DOUBLE, ft:DOUBLE, t=0
  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    a := !x*x
    b := !y*y
    y:=!x+x*y+yc
    x:=!a-b+xc
  ENDWHILE

  IF ! x*x+(!y*y) > tresh

  -> following code is the magic..
   a := !x*x
   b := !y*y
   y:=!x+x*y+yc
   x:=!a-b+xc
   a := !x*x
   b := !y*y
   y:=!x+x*y+yc
   x:=!a-b+xc

   a := Fsqrt(!x*x+(!y*y))
   ft := t! - (!Flog(Flog(a)) / Flog(2.0))
   t := ! ft / (it!) * 16000000.0 !

  ENDIF

ENDPROC t SHL 8, t SHL 8, t SHL 8

PROC mandelSample_SE(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF fr=0.0:DOUBLE, ft:DOUBLE
  DEF r, g, b, t
  DEF max:DOUBLE, sub:DOUBLE, mul:DOUBLE, eemax:DOUBLE, _eemax:DOUBLE
  DEF sx:DOUBLE, sy:DOUBLE, sampledone=FALSE

  sx := x
  sy := y

  -> the idea is to take a sample of the interior
  -> at a time independant of number of iterations

  max := tresh
  eemax := Fexp(Fexp(max))
  sub := ! max / eemax
  mul := ! max / (!max-sub) * 15000000.0
  _eemax := !1.0/eemax

  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
    IF (Fabs(!x*y - (!sx*sy)) > Flog(Fabs(!sx*sy))) AND (sampledone=FALSE)
       fr := !tresh-(!x*x+(!y*y))
       fr := ! Fexp(Fexp(fr)) * _eemax - sub * mul
       sampledone := TRUE
    ENDIF
  ENDWHILE
  IF ! x*x+(!y*y) < tresh
     IF sampledone = FALSE
        fr := !tresh-(!x*x+(!y*y))
        fr := ! Fexp(Fexp(fr)) * _eemax - sub * mul
     ENDIF
     r := !fr!
  ELSE
     z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc

      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      t := ! 16000000.0 - (!ft / (it!) * 16000000.0) !
      r := t

  ENDIF
ENDPROC r SHL 8, r SHL 8, r SHL 8

PROC mandelSampleDiffHSB_SE(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF fr=0.0:DOUBLE, ft:DOUBLE
  DEF r, g, b, t
  DEF max:DOUBLE, sub:DOUBLE, mul:DOUBLE, eemax:DOUBLE, _eemax:DOUBLE
  DEF sx:DOUBLE, sy:DOUBLE, sampledone=FALSE
  DEF rgb[3]:ARRAY OF LONG
  DEF diff:DOUBLE

  sx := x
  sy := y

  -> the idea is to take a sample of the interior
  -> at a time independant of number of iterations

  max := tresh
  eemax := Fexp(Fexp(max))
  sub := ! max / eemax
  mul := ! max / (!max-sub) * 16000000.0
  _eemax := !1.0/eemax

  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
    IF (Fabs(!x*y - (!sx*sy)) > Flog(Fabs(!sx*sy))) AND (sampledone=FALSE)
       fr := !tresh-(!x*x+(!y*y))
       fr := ! Fexp(Fexp(fr)) * _eemax - sub * mul
       sampledone := TRUE
       diff := !z0-z1
    ENDIF
  ENDWHILE
  IF ! x*x+(!y*y) < tresh
     IF sampledone = FALSE
        fr := !tresh-(!x*x+(!y*y))
        fr := ! Fexp(Fexp(fr)) * _eemax - sub * mul
        diff := ! z0 - z1
     ENDIF

     ConvertHSBToRGB([!diff+tresh/tresh * 16000000.0 ! SHL 8, -1, !fr! SHL 8]:LONG, rgb)
     r := rgb[0]
     g := rgb[1]
     b := rgb[2]

  ELSE


     z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc

      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      t := ! 16000000.0 - (!ft / (it!) * 16000000.0) !

      r := t SHL 8
      g := t SHL 8
      b := t SHL 8


  ENDIF
ENDPROC r, g, b

PROC hmm(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF fr=0.0:DOUBLE, ft:DOUBLE
  DEF r, g, b, t
  DEF max:DOUBLE, sub:DOUBLE, mul:DOUBLE, eemax:DOUBLE, _eemax:DOUBLE
  DEF sx:DOUBLE, sy:DOUBLE, sampledone=FALSE
  DEF rgb[3]:ARRAY OF LONG
  DEF diff:DOUBLE

  sx := x
  sy := y

  tresh := ! x*x+(!y*y) * tresh

  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE
  IF ! x*x+(!y*y) < tresh
     r := 0
  ELSE



      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      t := ! 16000000.0 - (!ft / (it!) * 16000000.0) !

      r := t SHL 8

  ENDIF

  t := 0
  x := sx
  y := sy
  WHILE (t++<it) AND (!x*x+(!x*x)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE
  IF ! x*x+(!x*x) < tresh
     g := 0
  ELSE



      z2 := Fsqrt(!x*x+(!x*x))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      t := ! 16000000.0 - (!ft / (it!) * 16000000.0) !

      g := t SHL 8

  ENDIF

  t := 0
  x := sx
  y := sy
  WHILE (t++<it) AND (!y*y+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE
  IF ! y*y+(!y*y) < tresh
     b := 0
  ELSE


      z2 := Fsqrt(!y*y+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      t := ! 16000000.0 - (!ft / (it!) * 16000000.0) !

      b := t SHL 8

  ENDIF

ENDPROC r, g, b

PROC hmmHSB(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF ft:DOUBLE
  DEF r, g, b, t
  DEF sx:DOUBLE, sy:DOUBLE, sampledone=FALSE
  DEF rgb[3]:ARRAY OF LONG

  sx := x
  sy := y



  t := 0
  x := sx
  y := sy
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE
  IF ! x*x+(!y*y) < tresh
      r := 0  ; g := 0 ; b := 0
  ELSE


      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc

      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc

      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (! Flog(Flog(z2)) / Flog(2.0))
      r := ! Fsqrt(!ft * 4500.0) * 9000.0 !
      ->r := ! Fsqrt(! tresh-(!z0+z1)/tresh) * 16000000.0

      ConvertHSBToRGB([r SHL 8, -1, ! 16000000.0 - (!ft / (it!) * 16000000.0) ! SHL 8], rgb)
      r := rgb[0]
      g := rgb[1]
      b := rgb[2]

  ENDIF

ENDPROC r, g, b


PROC propTresh(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF ft:DOUBLE
  DEF r, g, b, t
  DEF sx:DOUBLE, sy:DOUBLE, sampledone=FALSE
  DEF rgb[3]:ARRAY OF LONG

  sx := x
  sy := y


  t := 0
  x := sx
  y := sy
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE
  IF ! x*x+(!y*y) < tresh
     r := 0  ; g := 0 ; b := 0
  ELSE
     z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))


  ->r := ! Fsqrt(! tresh-(!z0+z1)/tresh) * 16000000.0

      ConvertHSBToRGB([220 SHL 24, -1, ! 16000000.0 - (!ft / (it!) * 16000000.0) ! SHL 8], rgb)
      r := rgb[0]
      g := rgb[1]
      b := rgb[2]

  ENDIF

ENDPROC r, g, b

PROC smoothHSBDiffEscape(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF a:DOUBLE, b:DOUBLE, ft:DOUBLE, t=0
  DEF rgb[3]:ARRAY OF LONG

  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    a := !x*x
    b := !y*y
    y:=!x+x*y+yc
    x:=!a-b+xc
  ENDWHILE

  IF ! x*x+(!y*y) > tresh

  -> following code is the magic..
   a := !x*x
   b := !y*y
   y:=!x+x*y+yc
   x:=!a-b+xc
   a := !x*x
   b := !y*y
   y:=!x+x*y+yc
   x:=!a-b+xc

   ft := Fsqrt(!x*x+(!y*y))
   ft := t! - (!Flog(Flog(ft)) / Flog(2.0))
   t := ! ft / (it!) * 16000000.0 !

  ENDIF

  ConvertHSBToRGB([!a+b-tresh*19000.0! SHL 16, -1, t SHL 8], rgb)

ENDPROC rgb[0], rgb[1], rgb[2]

PROC clever1(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t, q:DOUBLE, qc:DOUBLE, z0:DOUBLE, z1:DOUBLE, r

  q := !x*y
  qc :=!xc*yc

  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
    q := ! q*q+qc
  ENDWHILE
  IF !x*x+(!y*y) < tresh
      r := ! (!x*y) - q / tresh * 16000000.0 !
  ELSE
     r := t! / (it!) * 16000000.0 !
  ENDIF
ENDPROC r SHL 8, r SHL 8, r SHL 8

-> based on mandelMArginSmothEscape, but..
-> We use also a lower treshhold and do counting and float it up.
-> this means we have three regions.
-> FU: IT sucked, .. changed it..
PROC threeway(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF fr:DOUBLE, fg:DOUBLE, fb:DOUBLE
  DEF r, g, b, t, ft:DOUBLE
  DEF sx:DOUBLE, sy:DOUBLE
  DEF it0->, tresh1:DOUBLE, tresh2:DOUBLE
  DEF _eemax:DOUBLE, eemax:DOUBLE, max:DOUBLE, sub:DOUBLE, mul:DOUBLE

   tresh := Fabs(!x*x+(!y*y) * tresh)

  sx := x
  sy := y

  x := sx
  y := sy
  t := 0
  WHILE (t++<it)
    IF !x*x+(!y*y)>tresh THEN JUMP way3_outside
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE

  x := sx
  y := sy
  FOR t := 0 TO 3
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDFOR
     tresh := !tresh * 0.5

     max := 2.0
     eemax := Fsqrt(Fsqrt(!max))
     sub := ! 0.0->max / eemax
     mul := ! /*max  / (!max-sub) **/ 16000000.0
     _eemax := !1.0/eemax


     fb := (!x*x+(!y*y)/tresh)
     b := ! Fsqrt(Fsqrt(!fb)) * _eemax - sub * mul !
     ->b := !fb / tresh1 * 16000000.0 !
     z0 := !x*x
     z1 := !y*y
     y:=!x+x*y+yc
     x:=!z0-z1+xc
     fr := (!x*x+(!y*y)/tresh)
     r := !Fsqrt(Fsqrt(!fr)) * _eemax - sub * mul !
     ->r := !fr / tresh1 * 16000000.0 !
     z0 := !x*x
     z1 := !y*y
     y:=!x+x*y+yc
     x:=!z0-z1+xc
     fg := (!x*x+(!y*y)/tresh)
     g := ! Fsqrt(Fsqrt(!fg)) * _eemax - sub * mul !
     ->g := !fg / tresh1 * 16000000.0 !
  JUMP way3_end

way3_outside:
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc
      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      t := ! 16000000.0 - (!ft / (it!) * 16000000.0) !
      r := t
      g := t
      b := t


way3_end:

ENDPROC r SHL 8, g SHL 8, b SHL 8

-> we try to colour outside by using difference of angle on x,y => H
-> saturation full = S=-1
-> brightness by normal floatescape => B

PROC test(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,treshhold:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF fr:DOUBLE, fg:DOUBLE, fb:DOUBLE
  DEF r, g, b, t, ft:DOUBLE
  DEF sx:DOUBLE, sy:DOUBLE
  DEF tresh:DOUBLE

  sx := x
  sy := y

  tresh := (!x*x+(!y*y) * treshhold)


  t := 0
  WHILE (t++<it) AND (!x*x+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE

      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc

      z2 := Fsqrt(!x*x+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      r := ! 16000000.0 - (!ft / (it!) * 16000000.0) !

  x := (sx)
  y := (sy)

  tresh := (!x*x+(!x*x) * treshhold)

  t := 0
  WHILE (t++<it) AND (!x*x+(!x*x)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE

      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc

      z2 := Fsqrt(!x*x+(!x*x))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      g := ! 16000000.0 - (!ft / (it!) * 16000000.0) !

  x := sx
  y := (sy)

  tresh := (!y*y+(!y*y) * treshhold)

  t := 0
  WHILE (t++<it) AND (!y*y+(!y*y)<tresh)
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
  ENDWHILE

      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc
      z0 := !x*x
      z1 := !y*y
      y:=!x+x*y+yc
      x:=!z0-z1+xc

      z2 := Fsqrt(!y*y+(!y*y))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      b := ! 16000000.0 - (!ft / (it!) * 16000000.0) !

ENDPROC r SHL 8, g SHL 8, b SHL 8

PROC farg(x:DOUBLE,y:DOUBLE) (DOUBLE)
  DEF t:DOUBLE
  t := IF ! y < 0.0 THEN !PI+PID2 ELSE !PID2
  t := ! t - Fatan(!x/y)
ENDPROC t

-> increment counter by [0..1]
PROC test2(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,treshhold:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF r, g, b
  DEF t=0, ft=0.0:DOUBLE
  DEF tresh:DOUBLE
  DEF a

  tresh := !x*x+(!y*y) * treshhold

  FOR a := 0 TO it
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
    IF !x*x+(!y*y)>=tresh
       IF t = 0 THEN t := a
    ELSE
       t := 0
    ENDIF
    ft := ! ft + Fsqrt(!z0+z1)
  ENDFOR

  IF t
     ft := it-t! / (it!)
  ELSE
     ft := it!-ft / (it!)
  ENDIF

  r := (! ft * 16000000.0 !)

ENDPROC r SHL 8, r SHL 8, r SHL 8

PROC test3(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,treshhold:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF r, g, b
  DEF t=0
  DEF ft:DOUBLE
  DEF fr=0.0:DOUBLE, fg=0.0:DOUBLE, fb=0.0:DOUBLE
  DEF tresh:DOUBLE
  DEF a

  tresh := !x*x+(!y*y) * treshhold
  IF !tresh < 1.0 THEN tresh := 1.0

  FOR a := 0 TO it
    z0 := !x*x
    z1 := !y*y
    y:=!x+x*y+yc
    x:=!z0-z1+xc
    IF !x*x+(!y*y)>=tresh
       t++
       fr := 0.0
    ELSE
       t := 0
    ENDIF
    fr := ! fr + Fsqrt(!z0+z1)
  ENDFOR

  IF t
     ft := it-t! / (it!)
     r := (! ft * 16000000.0 !)
  ELSE
     fr := it!-fr / (it!)
     r := (! fr * 16000000.0 !)
  ENDIF



ENDPROC r SHL 8, r SHL 8, r SHL 8

PROC test4(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,treshhold:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF r, g, b
  DEF ft:DOUBLE
  DEF fr=0.0:DOUBLE, fg=0.0:DOUBLE, fb=0.0:DOUBLE
  DEF tresh1:DOUBLE,tresh2:DOUBLE,tresh3:DOUBLE
  DEF a, rt=0, gt=0, bt=0

  tresh1 := !x*x+(!y*y) * treshhold
  tresh2 := !x*x+(!x*x) * treshhold
  tresh3 := !y*y+(!y*y) * treshhold

  FOR a := 0 TO it
    z0 := !x*x
    z1 := !y*y
    IF !x*x+(!y*y)>=tresh1
       rt++
       ->fr := 0.0
    ELSE
       ->rt := 0
       fr := ! fr + Fsqrt(!(!x*x+(!y*y)))
    ENDIF
    IF !x*x+(!x*x)>=tresh2
       gt++
       ->fg := 0.0
    ELSE
       ->gt := 0
       fg := ! fg + Fsqrt(!(!x*x+(!x*x)))
    ENDIF
    IF !y*y+(!y*y)>=tresh3
       bt++
       ->fb := 0.0
    ELSE
       ->bt := 0
       fb := ! fb + Fsqrt(!(!y*y+(!y*y)))
    ENDIF
    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)
  ENDFOR

  IF rt
     fr := it-rt! / (it!)
     r := (! fr * 16000000.0 !)
  ELSE
     fr := it!-fr / (it!)
     r := (! Fsqrt(fr) * 16000000.0 !)
  ENDIF

  IF gt
     fg := it-gt! / (it!)
     g := (! fg * 16000000.0 !)
  ELSE
     fg := it!-fg / (it!)
     g := (! Fsqrt(fg) * 16000000.0 !)
  ENDIF

  IF bt
     fb := it-bt! / (it!)
     b := (! fb * 16000000.0 !)
  ELSE
     fb := it!-fb / (it!)
     b := (! Fsqrt(fb) * 16000000.0 !)
  ENDIF


ENDPROC 0 SHL 8, 0 SHL 8, b SHL 8

#define sqr4(x) Fsqrt(Fsqrt(Fsqrt(Fsqrt(x))))

PROC muuu(z:DOUBLE,tresh:DOUBLE) (DOUBLE) IS 1.0-Flog10(!tresh/z*0.1+0.9)->(!Flog(!z)/Flog(tresh))
->PROC muuu(z:DOUBLE,tresh:DOUBLE) (DOUBLE) IS !Fexp(z)-1.0/1.8

PROC test5(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,treshhold:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE, z:DOUBLE
  DEF r, g, b
  DEF ft:DOUBLE
  DEF fr=0.0:DOUBLE, fg=0.0:DOUBLE, fb=0.0:DOUBLE
  DEF tresh:DOUBLE, tresh2:DOUBLE
  DEF a, rt=0, gt=0, bt=0

  tresh :=  !x*x+(!y*y) *  treshhold
  ->tresh2 := !x*x+(!y*y) / treshhold

  FOR a := 0 TO it-1
    z0 := !x*x
    z1 := !y*y
    z := !z0+z1
    IF !z>=tresh
       rt++
       ->fr := 0.0
    ELSE
       ->rt := 0
       fr := ! fr + muuu(z,!tresh)
    ENDIF
    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)

    z0 := !x*x
    z1 := !y*y
    z := ! z0+z1
    IF !z>=tresh
       gt++
       ->fg := 0.0
    ELSE
       ->gt := 0
       fg := ! fg + muuu(z,!tresh)
    ENDIF
    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)

    z0 := !x*x
    z1 := !y*y
    z := ! z0+z1
    IF !z>=tresh
       bt++
       ->fb := 0.0
    ELSE
       ->bt := 0
       fb := ! fb + muuu(z,!tresh)
    ENDIF
    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)
  ENDFOR

  IF rt
     fr := it-rt! / (it!)
     r := 16000000 - (! (fr) * 16000000.0 !)
  ELSE
     fr := it!-fr / (it!)
     r := (! fr * 16000000.0 !)
  ENDIF
  IF gt
     fg := it-gt! / (it!)
     g := 16000000 - (! (fg) * 16000000.0 !)
  ELSE
     fg := it!-fg / (it!)
     g := (! fg * 16000000.0 !)
  ENDIF
  IF bt
     fb := it-bt! / (it!)
     b := 16000000 - (! (fb) * 16000000.0 !)
  ELSE
     fb := it!-fb / (it!)
     b := (! fb * 16000000.0 !)
  ENDIF

  ->r := Max(r, 0)
  ->g := Max(g, 0)
  ->b := Max(b, 0)

ENDPROC r SHL 8, g SHL 8, b SHL 8

PROC test6(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,treshhold:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE, z:DOUBLE
  DEF r, g, b
  DEF ft:DOUBLE
  DEF fr=0.0:DOUBLE, fg=0.0:DOUBLE, fb=0.0:DOUBLE
  DEF tresh:DOUBLE, tresh2:DOUBLE
  DEF a, rt=0, gt=0, bt=0

  tresh :=  !x*x+(!y*y) *  treshhold
  ->tresh2 := !x*x+(!y*y) / treshhold

  FOR a := 0 TO it-1
    z0 := !x*x
    z1 := !y*y
    z := !z0+z1
    IF !Fabs(!z0-z1)>tresh
       rt++
       ->fr := 0.0
    ELSE
       ->rt := 0
       fr := ! fr + (!z1-z0/z)->muuu(!Fabs(!z0-z1),tresh)
    ENDIF
    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)

    z0 := !x*x
    z1 := !y*y
    z := ! z0+z1
    IF !Fabs(!z0-z1)>tresh
       gt++
       ->fg := 0.0
    ELSE
       ->gt := 0
       fg := ! fg + (!z1-z0/z)->muuu(!Fabs(!z0-z1),tresh)
    ENDIF
    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)

    z0 := !x*x
    z1 := !y*y
    z := ! z0+z1
    IF !Fabs(!z0-z1)>tresh
       bt++
       ->fb := 0.0
    ELSE
       ->bt := 0
       fb := ! fb + (!z1-z0/z)->muuu(!Fabs(!z0-z1),tresh)
    ENDIF
    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)
  ENDFOR



  IF rt
     fr := it-rt! / (it!)
     r := 16000000 - (! (fr) * 16000000.0 !)
  ELSE
     fr := it!-fr / (it!)
     r := (! fr * 16000000.0 !)
  ENDIF
  IF gt
     fg := it-gt! / (it!)
     g := 16000000 - (! (fg) * 16000000.0 !)
  ELSE
     fg := it!-fg / (it!)
     g := (! fg * 16000000.0 !)
  ENDIF
  IF bt
     fb := it-bt! / (it!)
     b := 16000000 - (! (fb) * 16000000.0 !)
  ELSE
     fb := it!-fb / (it!)
     b := (! fb * 16000000.0 !)
  ENDIF

  ->r := Max(r, 0)
  ->g := Max(g, 0)
  ->b := Max(b, 0)

ENDPROC r SHL 8, g SHL 8, b SHL 8

-> produces "cones"
-> no treshhold is used and the outer space is all black
-> because it seems when escaping,  x2=y2 more or less.
-> idea: use x2=y2 criteria for escape (in some other routine)
PROC test6b(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,treshhold:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE, z:DOUBLE
  DEF r, g, b
  DEF ft:DOUBLE
  DEF fr=0.0:DOUBLE, fg=0.0:DOUBLE, fb=0.0:DOUBLE
  DEF frmax=0.0:DOUBLE,fgmax=0.0:DOUBLE,fbmax=0.0:DOUBLE
  DEF frmin=0.0:DOUBLE,fgmin=0.0:DOUBLE,fbmin=0.0:DOUBLE
  DEF tresh:DOUBLE, tresh2:DOUBLE
  DEF a, rt=0, gt=0, bt=0

  tresh :=  !x*x+(!y*y) *  treshhold
  ->tresh2 := !x*x+(!y*y) / treshhold

  FOR a := 0 TO it-1
    z0 := !x*x
    z1 := !y*y
    z := !z0+z1


    fr := ! fr + (!z1-z0/z)

    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)

    z0 := !x*x
    z1 := !y*y
    z := ! z0+z1

    fg := ! fg + (!z1-z0/z)

    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)

    z0 := !x*x
    z1 := !y*y
    z := ! z0+z1

    fb := ! fb + (!z1-z0/z)

    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)
  ENDFOR



     fr := it!-fr / (it!) - 2.1
     r := (! fr * 16000000.0 !)

     fg := it!-fg / (it!) - 2.1
     g := (! fg * 16000000.0 !)

     fb := it!-fb / (it!) - 2.1
     b := (! fb * 16000000.0 !)


ENDPROC r SHL 8, g SHL 8, b SHL 8

->#define FLIM(x, f) IF !(x)>f THEN (f) ELSE IF !(x)<(0.0-f) THEN (0.0-f) ELSE (x)

-> a more "controlled" vrsion of 6b
PROC test6c(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,treshhold:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE, z:DOUBLE
  DEF r, g, b
  DEF ft:DOUBLE
  DEF fr=0.0:DOUBLE, fg=0.0:DOUBLE, fb=0.0:DOUBLE
  DEF frmax=0.0:DOUBLE,fgmax=0.0:DOUBLE,fbmax=0.0:DOUBLE
  DEF frmin=0.0:DOUBLE,fgmin=0.0:DOUBLE,fbmin=0.0:DOUBLE
  DEF tresh:DOUBLE, tresh2:DOUBLE
  DEF a, rt=0, gt=0, bt=0

  tresh :=  !x*x+(!y*y) *  treshhold
  ->tresh2 := !x*x+(!y*y) / treshhold

  FOR a := 0 TO it-1
    z0 := !x*x
    z1 := !y*y
    z := !z0+z1


    IF ! z > tresh THEN RETURN a!/(it!)*16000000.0!SHL 8,
                               a!/(it!)*16000000.0!SHL 8,
                               a!/(it!)*16000000.0!SHL 8

    fr := ! fr - (!z0-z1/(z))
    frmax := fMax(fr, frmax)
    frmin := fMin(fr, frmin)

    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)

    z0 := !x*x
    z1 := !y*y
    z := ! z0+z1

    fg := ! fg - (!z0-z1/(z))
    fgmax := fMax(fg, fgmax)
    fgmin := fMin(fg, fgmin)

    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)

    z0 := !x*x
    z1 := !y*y
    z := ! z0+z1

    fb := ! fb - (!z0-z1/(z))
    fbmax := fMax(fb, fbmax)
    fbmin := fMin(fb, fbmin)

    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)
  ENDFOR


     ft := (!frmin+frmax*0.5)
     fr := ! fr - ft
     frmax := ! frmax - ft
     frmin := ! frmin - ft

     ft := (!fgmin+fgmax*0.5)
     fg := ! fg - ft
     fgmax := ! fgmax - ft
     fgmin := ! fgmin - ft

     ft := (!fbmin+fbmax*0.5)
     fb := ! fb - ft
     fbmax := ! fbmax - ft
     fbmin := ! fbmin - ft

     fr := (! square(!fr * 2.0 / (!frmax-frmin)) + 1.0) -> 0..2
     r := (! fr * 8000000.0 !)

     fg := (! square(!fg * 2.0 / (!fgmax-fgmin)) + 1.0)
     g := (! fg * 8000000.0 !)

     fb := (! square(!fb * 2.0 / (!fbmax-fbmin)) + 1.0)
     b := (! fb * 8000000.0 !)


ENDPROC r SHL 8, g SHL 8, b SHL 8

PROC square(x:DOUBLE) (DOUBLE) IS !x*x*x

PROC test7(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,treshhold:DOUBLE)
  DEF z0:DOUBLE, z1:DOUBLE, z:DOUBLE
  DEF r, g, b
  DEF ft:DOUBLE
  DEF fr=0.0:DOUBLE, fg=0.0:DOUBLE, fb=0.0:DOUBLE
  DEF tresh:DOUBLE, tresh2:DOUBLE
  DEF a, rt=0, gt=0, bt=0

  tresh :=  !x*x+(!y*y) *  treshhold
  ->tresh2 := !x*x+(!y*y) / treshhold

  ->#define BLA (!z-(!z1*z0))
  #define BLA (!z0-z1/z) + 1.0
  ->#define BLA (!(z0)*(z1)-(z))

  FOR a := 0 TO it-1
    z0 := !x*x
    z1 := !y*y
    z := !z0+z1
    IF !z>tresh
       rt++
       ->fr := 0.0
    ELSE
       ->rt := 0
       fr := ! fr  - BLA
    ENDIF
    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)

    z0 := !x*x
    z1 := !y*y
    z := ! z0+z1
    IF !z>tresh
       gt++
       ->fg := 0.0
    ELSE
       ->gt := 0
       fg := ! fg  - BLA
    ENDIF
    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)

    z0 := !x*x
    z1 := !y*y
    z := ! z0+z1
    IF !z>tresh
       bt++
       ->fb := 0.0
    ELSE
       ->bt := 0
       fb := ! fb - BLA
    ENDIF
    y:=(!x+x*y+yc)
    x:=(!z0-z1+xc)
  ENDFOR

  IF rt
     fr := rt! / (it!)
     r := (! (fr) * 16000000.0 !)
  ELSE
     fr := it!-fr / (it!) - 1.0
     r := (! (fr) * 16000000.0 !)
  ENDIF
  IF gt
     fg := gt! / (it!)
     g :=  (! (fg) * 16000000.0 !)
  ELSE
     fg := it!-fg / (it!) - 1.0
     g := (! (fg) * 16000000.0 !)
  ENDIF
  IF bt
     fb := bt! / (it!)
     b :=  (! (fb) * 16000000.0 !)
  ELSE
     fb := it!-fb / (it!) - 1.0
     b := (! (fb) * 16000000.0 !)
  ENDIF        ->r := Max(r, 0)
  ->g := Max(g, 0)
  ->b := Max(b, 0)

ENDPROC r SHL 8, g SHL 8, b SHL 8


