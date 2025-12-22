OPT PREPROCESS

MODULE 'morphos/cybergraphics'
MODULE 'colorwheel'


CONST CALCW=800,HEIGHT=600, DEPTH=500

PROC main() HANDLE
  DEF xmax=CALCW!:DOUBLE,ymax=HEIGHT-1!:DOUBLE
  DEF width=3.4:DOUBLE, height=3.4:DOUBLE
  DEF left:DOUBLE,top:DOUBLE
  DEF w,x,y,xr:DOUBLE
  DEF r, g, b
  DEF fx:DOUBLE, fy:DOUBLE, xc:DOUBLE, yc:DOUBLE
  DEF _xmax:DOUBLE, _ymax:DOUBLE
  DEF z, zr:DOUBLE



  cybergfxbase := OpenLibrary('cybergraphics.library', 0)
  IF cybergfxbase = NIL THEN Throw("LIB", 'cybergraphics')

  colorwheelbase := OpenLibrary('gadgets/colorwheel.gadget', 0)
  IF colorwheelbase = NIL THEN Throw("LIB", 'colorwheel')

  IF w:=OpenW(20,11,CALCW+30,HEIGHT+40,$200,$E,'Hybrid? by LS',NIL,1,NIL)
    _xmax := !1.0 / xmax
    _ymax := !1.0 / ymax
    FOR z := 1 TO 1 STEP 1
      width := !width+(!width*0.2)
      height := !height+(!height*0.2)
      left := !0.0-(!width*0.5)
      top := !0.0-(!height*0.5)
      FOR x:=0 TO CALCW-1
         xr:=x!*_xmax*width+left
         FOR y:=0 TO HEIGHT-1
            fx := xr
            fy := y!*_ymax*height+top
            xc := Fsin(!fx)
            yc := Fsin(!fy)
            r, g, b := realflame(fx,fy, xc, yc,10, 5.0)
            debug:                         WriteRGBPixel(stdrast, x+20,y+25, Long([0,r SHR 24,g SHR 24,b SHR 24]:CHAR))
         ENDFOR
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


PROC flamediv(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF xtemp:DOUBLE,rgb[3]:ARRAY OF LONG, t=0
  DEF a:DOUBLE, a2:DOUBLE, z0=0.0:DOUBLE, z1=0.0:DOUBLE

  tresh := ! Fsqrt(!x*x+(!y*y)) * tresh

  ->xc := ! xc * 2.0 - 1.0
  ->yc := ! yc * 2.0 - 1.0
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
  DEF z0=0.0:DOUBLE, z1=0.0:DOUBLE, z2=0.0:DOUBLE
  DEF z:DOUBLE, ir, ig, ib

  tresh := ! Fsqrt(!x*x+(!y*y)) * tresh

  zc := ! xc + yc * 0.5
  z := ! x + y * 0.5

  WHILE (t++ < it) ->AND (!x*y < tresh)
    a := ! (!x*zc)+(!y*yc)+(!z*yc)/xc
    b := ! (!x*zc)+(!y*xc)+(!z*yc)/yc
    c := ! (!x*xc)+(!z*zc)+(!z*xc)/zc
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

PROC flameRGB2(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t=0, zc:DOUBLE
  DEF a:DOUBLE, b:DOUBLE, c:DOUBLE
  DEF z0=0.0:DOUBLE, z1=0.0:DOUBLE, z2=0.0:DOUBLE
  DEF z:DOUBLE, ir, ig, ib

  tresh := ! Fsqrt(!x*x+(!y*y)) * tresh

  zc := Flog(! Fexp(xc) + Fexp(yc))
  z := Flog(! Fexp(x) + Fexp(y))


  WHILE (t++ < it) ->AND (!x*y < tresh)
    a := ! (!x*xc)+(!y*zc)+(!z*zc)/xc
    b := ! (!x*yc)+(!y*yc)+(!z*xc)/yc
    c := ! (!x*zc)+(!y*xc)+(!z*yc)/zc
    x := a
    y := b
    z := c
    z0 := ! z0 + (!tresh-z0/tresh*fMax(!tresh-(!x*x), 0.0))
    z1 := ! z1 + (!tresh-z1/tresh*fMax(!tresh-(!y*y), 0.0))
    z2 := ! z2 + (!tresh-z2/tresh*fMax(!tresh-(!z*z), 0.0))
  ENDWHILE
  ir := 16000000 - (! tresh - z0 / tresh * 16000000.0!)
  ig := 16000000 - (! tresh - z1 / tresh * 16000000.0!)
  ib := 16000000 - (! tresh - z2 / tresh * 16000000.0!)
ENDPROC ir SHL 8, ig SHL 8, ib SHL 8

PROC flameRGB2b(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t=0, zc:DOUBLE
  DEF a:DOUBLE, b:DOUBLE, c:DOUBLE
  DEF z0=0.1:DOUBLE, z1=0.1:DOUBLE, z2=0.1:DOUBLE
  DEF z:DOUBLE, ir, ig, ib

  tresh := ! Fsqrt(!x*x+(!y*y)) * tresh

  z := Fsqrt(! x*x + (!y*y))
  zc := Fsqrt(!xc*xc+(!yc*yc))

  z := Fsin(z)
  zc := Fsin(zc)

  WHILE (t++ < it) ->AND (!x*y < tresh)
    a := ! x*x+(!y*z)/xc
    b := ! y*y+(!x*z)/yc
    c := ! z*z+(!x*y)/zc
    x := a
    y := b
    z := c
    z0 := ! z0 + (!tresh-z0/tresh*fMax(!tresh-(!x*x), 0.0))
    z1 := ! z1 + (!tresh-z1/tresh*fMax(!tresh-(!y*y), 0.0))
    z2 := ! z2 + (!tresh-z2/tresh*fMax(!tresh-(!z*z), 0.0))
  ENDWHILE
  ir := 16000000 - (! tresh - z0 / tresh * 16000000.0!)
  ig := 16000000 - (! tresh - z1 / tresh * 16000000.0!)
  ib := 16000000 - (! tresh - z2 / tresh * 16000000.0!)
ENDPROC ir SHL 8, ig SHL 8, ib SHL 8

PROC flameRGB2c(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t=0, zc:DOUBLE
  DEF a:DOUBLE, b:DOUBLE, c:DOUBLE
  DEF z0=0.0:DOUBLE, z1=0.0:DOUBLE, z2=0.0:DOUBLE
  DEF z:DOUBLE, ir, ig, ib

  tresh := ! Fsqrt(!x*x+(!y*y)) * tresh

  z := Fsqrt(! x*x + (!y*y))
  zc := Fsqrt(!xc*xc+(!yc*yc))

  z := Fsin(z)
  zc := Fcos(zc)

  WHILE (t++ < it) ->AND (!x*y < tresh)
    a := ! (!x*xc)+(!y*yc)+(!z*zc)/(xc)
    b := ! (!x*yc)+(!y*zc)+(!z*xc)/(yc)
    c := ! (!x*zc)+(!y*xc)+(!z*yc)/(zc)
    x := a
    y := b
    z := c
    z0 := ! z0 + (!tresh-z0/tresh*fMax(!tresh-(!x*x), 0.0))
    z1 := ! z1 + (!tresh-z1/tresh*fMax(!tresh-(!y*y), 0.0))
    z2 := ! z2 + (!tresh-z2/tresh*fMax(!tresh-(!z*z), 0.0))
  ENDWHILE
  ir := 16000000 - (! tresh - z0 / tresh * 16000000.0!)
  ig := 16000000 - (! tresh - z1 / tresh * 16000000.0!)
  ib := 16000000 - (! tresh - z2 / tresh * 16000000.0!)
ENDPROC ir SHL 8, ig SHL 8, ib SHL 8


PROC flameRGB3(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t=0, zc:DOUBLE
  DEF a:DOUBLE, b:DOUBLE, c:DOUBLE
  DEF z0=0.0:DOUBLE, z1=0.0:DOUBLE, z2=0.0:DOUBLE
  DEF z0max:DOUBLE, z1max:DOUBLE, z2max:DOUBLE
  DEF z:DOUBLE, ir, ig, ib

  tresh := ! Fsqrt(!x*x+(!y*y)) * tresh

  zc := ! xc + yc * 0.5
  z := ! x + y * 0.5

  WHILE (t++ < it) ->AND (!x*y < tresh)
    a := ! (!x*xc)+(!y*zc)+(!z*zc)/xc
    b := ! (!x*yc)+(!y*yc)+(!z*xc)/yc
    c := ! (!x*zc)+(!y*xc)+(!z*yc)/zc
    x := a
    y := b
    z := c
    IF x < 0.0
       z0 := ! z0 + fMax(Fsqrt(!tresh-(!x*x)), 0.0)
    ELSE
       z0 := ! z0 - fMax(Fsqrt(!tresh-Fabs(!x*x)), 0.0)
    ENDIF
    IF y < 0.0
       z1 := ! z1 + fMax(Fsqrt(!tresh-(!y*y)), 0.0)
    ELSE
       z1 := ! z1 - fMax(Fsqrt(!tresh-Fabs(!y*y)), 0.0)
    ENDIF
    IF z < 0.0
       z2 := ! z2 + fMax(Fsqrt(!tresh-(!z*z)), 0.0)
    ELSE
       z2 := ! z2 - fMax(Fsqrt(!tresh-Fabs(!z*z)), 0.0)
    ENDIF
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

   tresh := ! Fsqrt(!x*x+(!y*y)) * tresh

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

-> measure how many times x, y, z changes direction *NOPE*
-> measures maximum change in direction
PROC flameRGB4(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t=0, zc:DOUBLE
  DEF a:DOUBLE, b:DOUBLE, c:DOUBLE
  DEF z0=0.0:DOUBLE, z1=0.0:DOUBLE, z2=0.0:DOUBLE
  DEF z:DOUBLE, ir, ig, ib
  DEF dx=-1, dy=-1, dz=-1

  tresh := ! Fsqrt(!x*x+(!y*y)) * tresh

  zc := (! xc + yc * 0.5)
  z := (! x + y * 0.5)

  WHILE (t++ < it) ->AND (!x*y < tresh)
    a := ! (!x*xc)+(!y*zc)+(!z*yc)/xc
    b := ! (!x*yc)+(!y*xc)+(!z*zc)/yc
    c := ! (!x*zc)+(!y*yc)+(!z*xc)/zc
    IF dx < 0
       IF ! x > a
          dx := 1
          z0 := fMax(z0, Fsqrt(!x-a))
       ENDIF
    ELSE
       IF ! x < a
          dx := -1
          z0 := fMax(z0, Fsqrt(!a-x))
       ENDIF
    ENDIF
    IF dy < 0
       IF ! y > b
          dy := 1
          z1 := fMax(z1, Fsqrt(!y-b))
       ENDIF
    ELSE
       IF ! y < b
          dy := -1
          z1 := fMax(z1, Fsqrt(!b-y))
       ENDIF
    ENDIF
    IF dz < 0
       IF ! z > c
          dy := 1
          z2 := fMax(z2, Fsqrt(!z-c))
       ENDIF
    ELSE
       IF ! z < c
          dz := -1
          z2 := fMax(z2, Fsqrt(!c-z))
       ENDIF
    ENDIF

    x := a
    y := b
    z := c
    ->z0 := ! z0 + (!tresh-z0/tresh*fMax(!tresh-(!x*x), 0.0))
    ->z1 := ! z1 + (!tresh-z1/tresh*fMax(!tresh-(!y*y), 0.0))
    ->z2 := ! z2 + (!tresh-z2/tresh*fMax(!tresh-(!z*z), 0.0))
  ENDWHILE
  ir := (!z0 * 16000000.0 / tresh)!
  ig := (!z1 * 16000000.0 / tresh)!
  ib := (!z2 * 16000000.0 / tresh)!
ENDPROC ir SHL 8, ig SHL 8, ib SHL 8


PROC flameRGB2d(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t=0, zc:DOUBLE
  DEF a:DOUBLE, b:DOUBLE, c:DOUBLE
  DEF z0=0.0:DOUBLE, z1=0.0:DOUBLE, z2=0.0:DOUBLE
  DEF z:DOUBLE, ir, ig, ib

  zc := Fsqrt(! xc*xc + (!yc*yc))
  z := Fsqrt(! x*x + (!y*y))

  tresh := ! Fsqrt(!x*x+(!y*y)) * tresh

  WHILE (t++ < it) ->AND (!x*y < tresh)
    a := ! x+(!y*z*xc)/xc
    b := ! y+(!x*z*yc)/yc
    c := ! z+(!x*y*zc)/zc
    x := a
    y := b
    z := c
    z0 := ! z0 + (!tresh-z0/tresh*fMax(!tresh-(!x*x), 0.0))
    z1 := ! z1 + (!tresh-z1/tresh*fMax(!tresh-(!y*y), 0.0))
    z2 := ! z2 + (!tresh-z2/tresh*fMax(!tresh-(!z*z), 0.0))
  ENDWHILE
  ir := 16000000 - (! tresh - z0 / tresh * 16000000.0!)
  ig := 16000000 - (! tresh - z1 / tresh * 16000000.0!)
  ib := 16000000 - (! tresh - z2 / tresh * 16000000.0!)
ENDPROC ir SHL 8, ig SHL 8, ib SHL 8

PROC flameRGB2e(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t=0, zc:DOUBLE
  DEF a:DOUBLE, b:DOUBLE, c:DOUBLE
  DEF z0=0.0:DOUBLE, z1=0.0:DOUBLE, z2=0.0:DOUBLE
  DEF z:DOUBLE, ir, ig, ib

  z := Fsin(Fsqrt(! x*x + (!y*y)))
  zc := Fsin(Fsqrt(! xc*xc + (!yc*yc)))

  tresh := ! Fsqrt(!x*x+(!y*y)) * tresh

  WHILE (t++ < it)
    a := ! x+(!y*z*xc)/xc
    b := ! y+(!x*z*yc)/yc
    c := ! z+(!x*y*zc)/zc
    x := a
    y := b
    z := c
    z0 := ! z0 + (!tresh-z0/tresh*fMax(!tresh-(!x*x), 0.0))
    z1 := ! z1 + (!tresh-z1/tresh*fMax(!tresh-(!y*y), 0.0))
    z2 := ! z2 + (!tresh-z2/tresh*fMax(!tresh-(!z*z), 0.0))
  ENDWHILE
  ir := 16000000 - (! tresh - z0 / tresh * 16000000.0!)
  ig := 16000000 - (! tresh - z1 / tresh * 16000000.0!)
  ib := 16000000 - (! tresh - z2 / tresh * 16000000.0!)
ENDPROC ir SHL 8, ig SHL 8, ib SHL 8

PROC flameRGB2f(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t=0, zc:DOUBLE
  DEF a:DOUBLE, b:DOUBLE, c:DOUBLE
  DEF z0=0.0:DOUBLE, z1=0.0:DOUBLE, z2=0.0:DOUBLE
  DEF z:DOUBLE, ir, ig, ib

  z := Fsqrt(! x*x + (!y*y))
  zc := Fsqrt(! xc*xc + (!yc*yc))

  -> gives a cool effect too..
  ->z := Fsin(z)
  ->zc := Fsin(zc)

  tresh := ! Fsqrt(!x*x+(!y*y)) * tresh

  WHILE (t++ < it)
    ->a := ! x*x/xc-y-z->(!y*z*xc)
    ->b := ! y*y/yc-x-z->(!x*z*yc)
    ->c := ! z*z/zc-x-y->(!x*y*zc)
    a := ! x+(!y*z)+xc->(!y*z*xc)
    b := ! y+(!x*z)+yc->(!x*z*yc)
    c := ! z+(!x*y)+zc->(!x*y*zc)
    x := a
    y := b
    z := c
    z0 := ! z0 + (!tresh-z0/tresh*fMax(!tresh-Fabs(x), 0.0))
    z1 := ! z1 + (!tresh-z1/tresh*fMax(!tresh-Fabs(y), 0.0))
    z2 := ! z2 + (!tresh-z2/tresh*fMax(!tresh-Fabs(z), 0.0))
  ENDWHILE
  ir := 16000000 - (! tresh - z0 / tresh * 16000000.0!)
  ig := 16000000 - (! tresh - z1 / tresh * 16000000.0!)
  ib := 16000000 - (! tresh - z2 / tresh * 16000000.0!)
ENDPROC ir SHL 8, ig SHL 8, ib SHL 8

PROC flameRGB2g(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t=0, zc:DOUBLE
  DEF a:DOUBLE, b:DOUBLE, c:DOUBLE
  DEF z0=0.0:DOUBLE, z1=0.0:DOUBLE, z2=0.0:DOUBLE
  DEF z:DOUBLE, ir, ig, ib
  DEF u:DOUBLE

  z := Fsqrt(! x*x + (!y*y))
  zc := Fsqrt(! xc*xc + (!yc*yc))

  u := Fsqrt(!x*x+(!y*y)+(!z*z))

  -> gives a cool effect too..
  ->z := Fsin(z)
  ->zc := Fsin(zc)


  WHILE (t++ < it)
    a := ! x+(!y*z)-xc->(!y*z*xc)
    b := ! y+(!x*z)-yc->(!x*z*yc)
    c := ! z+(!x*y)-zc->(!x*y*zc)
    x := a
    y := b
    z := c
    z0 := ! z0 + x*y
    z1 := ! z1 + y*z
    z2 := ! z2 + z*x
  ENDWHILE
  ir := (! z0 / (it!) * 16000000.0!)
  ig := (! z1 / (it!) * 16000000.0!)
  ib := (! z2 / (it!) * 16000000.0!)
ENDPROC ir SHL 8, ig SHL 8, ib SHL 8


PROC flameET(x:DOUBLE,y:DOUBLE,xc:DOUBLE,yc:DOUBLE,it,tresh:DOUBLE)
  DEF t=0, zc:DOUBLE
  DEF a:DOUBLE, b:DOUBLE, c:DOUBLE
  DEF z0=0.0:DOUBLE, z1=0.0:DOUBLE, z2=0.0:DOUBLE
  DEF z:DOUBLE, ir, ig, ib

  z := Fsqrt(! x*x + (!y*y))
  zc := z->Fsqrt(! xc*xc + (!yc*yc))

  tresh := ! Fsqrt(!x*x+(!y*y)+(!z*z)) * tresh

  WHILE (t++ < it) AND (!Fsqrt(!x*x+(!y*y)+(!z*z)) < tresh)
    a := ! (!y-yc*x)+(!z-zc*x)-x-xc
    b := ! (!x-xc*y)+(!z-zc*y)-y-yc
    c := ! (!x-xc*z)+(!y-yc*z)-z-zc
    x := a
    y := b
    z := c
  ENDWHILE
  ir := t! / (it!) * 16000000
  ig := ir
  ib := ir
ENDPROC ir SHL 8, ig SHL 8, ib SHL 8
