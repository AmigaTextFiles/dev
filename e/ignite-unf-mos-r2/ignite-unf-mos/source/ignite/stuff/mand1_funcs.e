
#define FloatMin(x,y) (IF ! (x) < (y) THEN x ELSE y)
#define FloatMax(x,y) (IF ! (x) > (y) THEN x ELSE y)

OBJECT mandret
   r:DOUBLE, g:DOUBLE, b:DOUBLE -> 0..1
ENDOBJECT

#define GETTRESH !fx*fx+(!fy*fy) * tresh

PROC mandSimple(fx:REAL,fy:REAL,fxc:REAL,fyc:REAL,tresh:REAL,iters:LONG,ret:PTR TO mandret)
  DEF a:DOUBLE, b:DOUBLE, t, x:DOUBLE, y:DOUBLE
  x := fx
  y := fy
  tresh := Fabs(GETTRESH)
  t := 0
  WHILE (t++<iters) AND (!x*x+(!y*y)<tresh) ->(!Fabs(x)+Fabs(y)<3.0)
    a := !x*x
    b := !y*y
    y:=!x+x*y+fyc
    x:=!a-b+fxc
  ENDWHILE
  t := t! / (iters!)
  ret.r := t
  ret.g := t
  ret.b := t
ENDPROC


-> http://linas.org/art-gallery/escape/escape.html
PROC mandSmooth(fx:REAL,fy:REAL,fxc:REAL,fyc:REAL,tresh:REAL,iters:LONG,ret:PTR TO mandret)
  DEF a:DOUBLE, b:DOUBLE, ft:DOUBLE, t, x:DOUBLE, y:DOUBLE
  x := fx
  y := fy
  tresh := GETTRESH
  t := 0
  WHILE (t++<iters) AND (!x*x+(!y*y)<tresh)
    a := !x*x
    b := !y*y
    y:=!x+x*y+fyc
    x:=!a-b+fxc
  ENDWHILE

  IF ! x*x+(!y*y) > tresh

  -> following code is the magic..
   a := !x*x
   b := !y*y
   y:=!x+x*y+fyc
   x:=!a-b+fxc
   a := !x*x
   b := !y*y
   y:=!x+x*y+fyc
   x:=!a-b+fxc

   a := Fsqrt(!x*x+(!y*y))
   ft := t! - (!Flog(Flog(a)) / Flog(2.0))
   ft := ! ft / (iters!)

  ELSE
   ft := 0.5
  ENDIF

  ret.r := ft
  ret.g := ft
  ret.b := ft

ENDPROC

PROC square(x:DOUBLE) (DOUBLE) IS !x*x*x*x

PROC test8(fx:REAL,fy:REAL,fxc:REAL,fyc:REAL,tresh:REAL,iters:LONG,ret:PTR TO mandret)
  DEF x:DOUBLE,y:DOUBLE
  DEF rz0:DOUBLE, rz1:DOUBLE, rz:DOUBLE
  DEF gz0:DOUBLE, gz1:DOUBLE, gz:DOUBLE
  DEF bz0:DOUBLE, bz1:DOUBLE, bz:DOUBLE
  DEF ft:DOUBLE
  DEF fr=0.0:DOUBLE, fg=0.0:DOUBLE, fb=0.0:DOUBLE
  DEF fri=0.1:DOUBLE, fgi=0.1:DOUBLE, fbi=0.1:DOUBLE
  DEF a


  x := fx
  y := fy
  tresh :=  GETTRESH

  ->tresh2 := !x*x+(!y*y) / treshhold


  FOR a := 0 TO iters-1

    rz0 := !x*x
    rz1 := !y*y
    rz := !rz0+rz1

    y:=(!x+x*y+fyc)
    x:=(!rz0-rz1+fxc)

    gz0 := !x*x
    gz1 := !y*y
    gz := !gz0+gz1

    y:=(!x+x*y+fyc)
    x:=(!gz0-gz1+fxc)

    bz0 := !x*x
    bz1 := !y*y
    bz := !bz0+bz1

    y:=(!x+x*y+fyc)
    x:=(!bz0-bz1+fxc)

    IF (!rz>tresh) AND (!gz>tresh) AND (!bz>tresh) THEN JUMP outside8

       ->fr := ! fr + (!Fsqrt(!rz/tresh))
       ->fg := ! fg + (!Fsqrt(!gz/tresh))
       ->fb := ! fb + (!Fsqrt(!bz/tresh))

       fr := ! fr + Fsqrt(!(tresh)*0.1/rz)
       fg := ! fg + Fsqrt(!(tresh)*0.1/gz)
       fb := ! fb + Fsqrt(!(tresh)*0.1/bz)

       ->fr := ! fr + (!(!tresh/rz)*0.05)
       ->fg := ! fg + (!(!tresh/gz)*0.05)
       ->fb := ! fb + (!(!tresh/bz)*0.05)

       ->fr := ! fr + (!Fsqrt(!(tresh)/(rz))*(iters!-fr/(iters!)))
       ->fg := ! fg + (!Fsqrt(!(tresh)/(gz))*(iters!-fg/(iters!)))
       ->fb := ! fb + (!Fsqrt(!(tresh)/(bz))*(iters!-fb/(iters!)))

       ->fr := ! fr + (!tresh*rz)
       ->fg := ! fg + (!tresh*gz)
       ->fb := ! fb + (!tresh*bz)

       fri := ! fri + (!(!rz/tresh)*10.1)
       fgi := ! fgi + (!(!gz/tresh)*10.1)
       fbi := ! fbi + (!(!bz/tresh)*10.1)

  ENDFOR

  ret.r := !fri / (iters!)

  ret.g := !fgi / (iters!)

  ret.b := !fbi / (iters!)

  RETURN

outside8:

   ft := ! (!Fsqrt(iters!) / (iters!))

   ret.r := !fr / (iters!)

   ret.g := !fg / (iters!)

   ret.b := !fb / (iters!)


ENDPROC

PROC test9(fx:REAL,fy:REAL,fxc:REAL,fyc:REAL,tresh:REAL,iters:LONG,ret:PTR TO mandret)
  DEF x:DOUBLE,y:DOUBLE
  DEF rz0:DOUBLE, rz1:DOUBLE, rz:DOUBLE
  DEF gz0:DOUBLE, gz1:DOUBLE, gz:DOUBLE
  DEF bz0:DOUBLE, bz1:DOUBLE, bz:DOUBLE
  DEF ft:DOUBLE
  DEF fr=0.0:DOUBLE, fg=0.0:DOUBLE, fb=0.0:DOUBLE
  DEF a
  DEF orz=0.0:DOUBLE, ogz=0.0:DOUBLE, obz=0.0:DOUBLE


  x := fx
  y := fy
  tresh :=  GETTRESH

  ->tresh2 := !x*x+(!y*y) / treshhold


  FOR a := 0 TO iters-1

    rz0 := !x*x
    rz1 := !y*y
    rz := !rz0+rz1

    y:=(!x+x*y+fyc)
    x:=(!rz0-rz1+fxc)

    gz0 := !x*x
    gz1 := !y*y
    gz := !gz0+gz1

    y:=(!x+x*y+fyc)
    x:=(!gz0-gz1+fxc)

    bz0 := !x*x
    bz1 := !y*y
    bz := !bz0+bz1

    y:=(!x+x*y+fyc)
    x:=(!bz0-bz1+fxc)

    EXIT (!rz>tresh) AND (!gz>tresh) AND (!bz>tresh)

    fr := ! fr + (!orz/(!rz))
    fg := ! fg + (!ogz/(!gz))
    fb := ! fb + (!obz/(!bz))

    ->fr := ! fr + FloatMin(!orz/tresh/Fsqrt(!rz/tresh), 1.0)
    ->fg := ! fg + FloatMin(!ogz/tresh/Fsqrt(!gz/tresh), 1.0)
    ->fb := ! fb + FloatMin(!obz/tresh/Fsqrt(!bz/tresh), 1.0)

    orz := rz
    ogz := gz
    obz := bz

  ENDFOR


      ret.r := !fr / (iters!)

      ret.g := !fg / (iters!)

      ret.b := !fb / (iters!)


ENDPROC

PROC test10(fx:REAL,fy:REAL,fxc:REAL,fyc:REAL,tresh:REAL,iters:LONG,ret:PTR TO mandret)
  DEF x:DOUBLE,y:DOUBLE
  DEF rz0:DOUBLE, rz1:DOUBLE, rz:DOUBLE
  DEF gz0:DOUBLE, gz1:DOUBLE, gz:DOUBLE
  DEF bz0:DOUBLE, bz1:DOUBLE, bz:DOUBLE
  DEF ft:DOUBLE
  DEF fr=0.0:DOUBLE, fg=0.0:DOUBLE, fb=0.0:DOUBLE
  DEF a
  DEF orz=0.0:DOUBLE, ogz=0.0:DOUBLE, obz=0.0:DOUBLE


  x := fx
  y := fy

  tresh := GETTRESH

  ->tresh2 := !x*x+(!y*y) / treshhold


  FOR a := 0 TO iters-1

    rz0 := !x*x
    rz1 := !y*y
    rz := !rz0+rz1

    y:=(!x+x*y+fyc)
    x:=(!rz0-rz1+fxc)

    gz0 := !x*x
    gz1 := !y*y
    gz := !gz0+gz1

    y:=(!x+x*y+fyc)
    x:=(!gz0-gz1+fxc)

    bz0 := !x*x
    bz1 := !y*y
    bz := !bz0+bz1

    y:=(!x+x*y+fyc)
    x:=(!bz0-bz1+fxc)


    IF !rz>tresh
       fr := ! fr + (!tresh/rz)
    ELSE
       fr := ! fr + (!orz/rz)
    ENDIF

    IF !gz>tresh
       fg := ! fg + (!tresh/gz)
    ELSE
       fg := ! fg + (!gz/ogz)
    ENDIF

    IF !bz>tresh
       fb := ! fb + (!tresh/bz)
    ELSE
       fb := ! fb + (!bz/obz)
    ENDIF

    orz := rz
    ogz := gz
    obz := bz

  ENDFOR

  ret.r := !fr / (iters!)

  ret.g := !fg / (iters!)

  ret.b := !fb / (iters!)


ENDPROC

PROC test11_(fx:REAL,fy:REAL,fxc:REAL,fyc:REAL,tresh:REAL,iters:LONG,ret:PTR TO mandret)
  DEF x:DOUBLE,y:DOUBLE
  DEF rz0:DOUBLE, rz1:DOUBLE, rz:DOUBLE
  DEF gz0:DOUBLE, gz1:DOUBLE, gz:DOUBLE
  DEF bz0:DOUBLE, bz1:DOUBLE, bz:DOUBLE
  DEF ft:DOUBLE
  DEF fr=0.0:DOUBLE, fg=0.0:DOUBLE, fb=0.0:DOUBLE
  DEF a
  DEF orz=0.0:DOUBLE, ogz=0.0:DOUBLE, obz=0.0:DOUBLE


  x := fx
  y := fy

  tresh := GETTRESH

  ->tresh2 := !x*x+(!y*y) / treshhold


  FOR a := 0 TO iters-1

    rz0 := !x*x
    rz1 := !y*y
    rz := !rz0+rz1

    y:=(!x+x*y+fyc)
    x:=(!rz0-rz1+fxc)

    gz0 := !x*x
    gz1 := !y*y
    gz := !gz0+gz1

    y:=(!x+x*y+fyc)
    x:=(!gz0-gz1+fxc)

    bz0 := !x*x
    bz1 := !y*y
    bz := !bz0+bz1

    y:=(!x+x*y+fyc)
    x:=(!bz0-bz1+fxc)

    ->EXIT (!rz>tresh) AND (!gz>tresh) AND (!bz>tresh)
    EXIT (!gz > (!rz*tresh)) AND (!bz > (!gz*tresh))


    /*IF !rz > tresh
       fr := !fr - (!tresh/rz)
    ELSE*/IF !rz > orz
       fr := ! fr + (!orz/rz)
    ELSE
       fr := ! fr + (!rz/orz)
    ENDIF

    /*IF !gz > tresh
       fg := !fg - (!tresh/gz)
    ELSE*/IF !gz > ogz
       fg := ! fg + (!ogz/gz)
    ELSE
       fg := ! fg + (!gz/ogz)
    ENDIF

    /*IF !bz > tresh
       fb := !fb - (!tresh/bz)
    ELSE*/IF !bz > obz
       fb := ! fb + (!obz/bz)
    ELSE
       fb := ! fb + (!bz/obz)
    ENDIF

    orz := rz
    ogz := gz
    obz := bz

  ENDFOR

  ret.r := !fr / (iters!)

  ret.g := !fg / (iters!)

  ret.b := !fb / (iters!)


ENDPROC

PROC test11(fx:REAL,fy:REAL,fxc:REAL,fyc:REAL,tresh:REAL,iters:LONG,ret:PTR TO mandret)
  DEF x:DOUBLE,y:DOUBLE
  DEF rz0:DOUBLE, rz1:DOUBLE, rz:DOUBLE
  DEF gz0:DOUBLE, gz1:DOUBLE, gz:DOUBLE
  DEF bz0:DOUBLE, bz1:DOUBLE, bz:DOUBLE
  DEF ft:DOUBLE
  DEF fr=0.0:DOUBLE, fg=0.0:DOUBLE, fb=0.0:DOUBLE
  DEF a
  DEF orz=0.0:DOUBLE, ogz=0.0:DOUBLE, obz=0.0:DOUBLE


  x := fx
  y := fy

  tresh := tresh->GETTRESH

  ->tresh2 := !x*x+(!y*y) / treshhold


  FOR a := 0 TO iters-1

    rz0 := !x*x
    rz1 := !y*y
    rz := !rz0+rz1

    y:=(!x+x*y+fyc)
    x:=(!rz0-rz1+fxc)

    gz0 := !x*x
    gz1 := !y*y
    gz := !gz0+gz1

    y:=(!x+x*y+fyc)
    x:=(!gz0-gz1+fxc)

    bz0 := !x*x
    bz1 := !y*y
    bz := !bz0+bz1

    y:=(!x+x*y+fyc)
    x:=(!bz0-bz1+fxc)

    ->EXIT (!rz>tresh) AND (!gz>tresh) AND (!bz>tresh)
    ->EXIT (!gz > (!rz*tresh)) AND (!bz > (!gz*tresh))


    IF (!rz > tresh) AND (!gz > tresh) AND (!bz > tresh)
       fr := !fr + (!tresh/rz)
       fg := !fg + (!tresh/gz)
       fb := !fb + (!tresh/bz)
    ELSE
       fr := ! fr + (!1.0/tresh*rz)
       fg := ! fg + (!1.0/tresh*gz)
       fb := ! fb + (!1.0/tresh*bz)
    ENDIF


    orz := rz
    ogz := gz
    obz := bz

  ENDFOR

  ret.r := !fr / (iters!)

  ret.g := !fg / (iters!)

  ret.b := !fb / (iters!)


ENDPROC


-> Z + C
PROC testZC(fx:REAL,fy:REAL,fxc:REAL,fyc:REAL,tresh:REAL,iters:LONG,ret:PTR TO mandret)
  DEF x:DOUBLE, y:DOUBLE, a:DOUBLE, b:DOUBLE, t=0
  DEF dir=-1, count=0

  x := (!fx)
  y := (!fy)
  tresh := !(!x*x+(!y*y)) + (!fxc*fxc+(!fyc*fyc)) * tresh

  WHILE (t++ < iters) AND (!x*x+(!y*y) < tresh)
    ->a := ! x*x/(!x-y)  + (!fxc)
    ->b := ! y*y/(!x-y)  + (!fyc)
    ->a := ! x*x-(!y) + (!fxc)
    ->b := ! x-(!y*y) + (!fyc)
    ->a := ! (!x*x)-(!y) + (!fxc)
    ->b := ! (!y*y)-(!x) + (!fyc)
    a := ! Fexp(x) * Fcos(y) * fxc
    b := ! Fexp(x) * Fsin(y) * fyc
    x := a
    y := b
  ENDWHILE

  ->fr := ! Fabs(Fpow(!fy,fx)) / 2.0

  ret.r := t!/(iters!)
  ret.g := t!/(iters!)
  ret.b := t!/(iters!)

ENDPROC

-> frequence
PROC testF(fx:REAL,fy:REAL,fxc:REAL,fyc:REAL,tresh:REAL,iters:LONG,ret:PTR TO mandret)
  DEF x:DOUBLE, y:DOUBLE, a:DOUBLE, b:DOUBLE, t=0
  DEF xdr=1, ydr=-1,  xfc=0, yfc=0
  DEF fmin:DOUBLE, fmax:DOUBLE

  x := (!fx)
  y := (!fy)

  ->fmin := !x*x+(!y*y)
  ->fmax := fmin

  tresh := !(!x*x+(!y*y)) + (!fxc*fxc+(!fyc*fyc)) * tresh

  WHILE (t++ < iters) AND (!x*x+(!y*y) < tresh)
    a := !x*x-(!y*y) + fxc
    b := !2.0*x*y + fyc

    IF xdr = -1
       IF !a > x
         xfc++
         xdr := 1
       ENDIF
    ELSE
      IF !a < x
         xfc++
         xdr := -1
      ENDIF
    ENDIF

    IF ydr = -1
       IF !b > y
         yfc++
         ydr := 1
       ENDIF
    ELSE
      IF !b < y
         yfc++
         ydr := -1
      ENDIF
    ENDIF


    x := a
    y := b

  ENDWHILE

  ->fr := ! Fabs(Fpow(!fy,fx)) / 2.0
  IF !x*x+(!y*y) > tresh
      ret.r := t!/(iters!)
      ret.g := t!/(iters!)
      ret.b := t!/(iters!)
  ELSE
      ->ret.r := !Fsqrt(xfc*xfc+(yfc*yfc)!)/(iters!)
      ->ret.g := !Fsqrt(xfc*xfc+(yfc*yfc)!)/(iters!)
      ->ret.b := !Fsqrt(xfc*xfc+(yfc*yfc)!)/(iters!)
      ret.r := xfc!/(iters!)
      ret.g := yfc!/(iters!)
      ret.b := !Fsqrt(xfc*xfc+(yfc*yfc)!)/(iters!)
  ENDIF


ENDPROC

PROC test12(fx:REAL,fy:REAL,fxc:REAL,fyc:REAL,tresh:REAL,iters:LONG,ret:PTR TO mandret)
  DEF x:DOUBLE, y:DOUBLE, a:DOUBLE, b:DOUBLE, t=0
  DEF afc=0.0:DOUBLE, adc=0

  x := (!fx)
  y := (!fy)

  tresh := !(!x*x+(!y*y)) + (!fxc*fxc+(!fyc*fyc)) * tresh

  WHILE (t++ < iters) AND (!x*x+(!y*y) < tresh)
    a := !x*x-(!y*y) + fxc
    b := !2.0*x*y + fyc

    afc := ! afc + Fabs(!a+b-(!x*x+(!y*y)))

    IF !a+b > (!x*x+(!y*y))
       adc++
    ENDIF

    x := a
    y := b
  ENDWHILE

  IF t < iters
      ret.r := (!adc/(t!))
      ret.g := (!adc/(t!))
      ret.b := (!adc/(t!))
  ELSE
      ret.r := !afc/(iters!)
      ret.g := !afc/(iters!)
      ret.b := !afc/(iters!)
  ENDIF


ENDPROC