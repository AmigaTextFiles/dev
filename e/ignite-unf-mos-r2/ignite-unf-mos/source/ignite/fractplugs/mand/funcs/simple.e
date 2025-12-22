OPT NOSTARTUP, PREPROCESS, POWERPC
MODULE '*/mand'
PROC mandSimple(MANDARGS)
  DEF a:DOUBLE, b:DOUBLE, t, x:DOUBLE, y:DOUBLE
  x := fx
  y := fy
  tresh := Fabs(GETTRESH)
  t := 0
  WHILE (t++<iters) AND (!x*x+(!y*y)<tresh)
    a := !x*x
    b := !y*y
    y:=!x+x*y+fyc
    x:=!a-b+fxc
  ENDWHILE
  a := t! / (iters!)
  ret.r := a
  ret.g := a
  ret.b := a
ENDPROC
