OPT NOSTARTUP, PREPROCESS, POWERPC
MODULE '*/mand'
-> http://linas.org/art-gallery/escape/escape.html
-> note! uses internal global math-vars.. works because engine
-> calling us is written in E, otherwise it would break..
PROC mandSmooth(MANDARGS)
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