OPT NOSTARTUP, PREPROCESS, POWERPC
MODULE '*/mand'
PROC mandelMarginRGB_SmoothEscape(MANDARGS)
  DEF z0:DOUBLE, z1:DOUBLE
  DEF z2:DOUBLE, z3:DOUBLE
  DEF fr:DOUBLE, fg:DOUBLE, fb:DOUBLE
  DEF r:DOUBLE, g:DOUBLE, b:DOUBLE, t, ft:DOUBLE
  DEF sx:DOUBLE, sy:DOUBLE
  DEF it0
  DEF _eemax:DOUBLE, eemax:DOUBLE, max:DOUBLE, sub:DOUBLE, mul:DOUBLE

   tresh := GETTRESH

  sx := fx
  sy := fy

  it0 := !Fsqrt(iters!)! + 1
  FOR t := 0 TO it0
     z0 := !fx*fx
     z1 := !fy*fy
     fy:=!fx+fx*fy+fyc
     fx:=!z0-z1+fxc
  ENDFOR
     max := !tresh
     eemax := Fexp(Fexp((max)))
     sub := ! max / eemax
     mul := ! max / (!max-sub)
     _eemax := !1.0/eemax


     fb := FloatMax(!tresh-(!z0+(!z1)), 0.0)
     b := ! Fexp(Fexp((fb))) * _eemax - sub * mul

     fr := FloatMax(!tresh-(!fx*fx+(!fy*fy)), 0.0)
     r := ! Fexp(Fexp((fr))) * _eemax - sub * mul
     z0 := !fx*fx
     z1 := !fy*fy
     fy:=!fx+fx*fy+fyc
     fx:=!z0-z1+fxc
     fg := FloatMax(!tresh-(!fx*fx+(!fy*fy)), 0.0)
     g := ! Fexp(Fexp((fg))) * _eemax - sub * mul

  fx := sx
  fy := sy
  t := 0
  WHILE (t++<iters) AND (!fx*fx+(!fy*fy)<tresh)
    z0 := !fx*fx
    z1 := !fy*fy
    fy:=!fx+fx*fy+fyc
    fx:=!z0-z1+fxc
  ENDWHILE
  IF ! fx*fx+(!fy*fy) <= tresh
      ret.r := r
      ret.g := g
      ret.b := b
  ELSE
      z0 := !fx*fx
      z1 := !fy*fy
      fy:=!fx+fx*fy+fyc
      fx:=!z0-z1+fxc
      z0 := !fx*fx
      z1 := !fy*fy
      fy:=!fx+fx*fy+fyc
      fx:=!z0-z1+fxc

      z2 := Fsqrt(!fx*fx+(!fy*fy))
      ft := t! - (!Flog(Flog(z2)) / Flog(2.0))
      ret.r := ! ft / (iters!)
      ret.g := ret.r
      ret.b := ret.g
  ENDIF
ENDPROC