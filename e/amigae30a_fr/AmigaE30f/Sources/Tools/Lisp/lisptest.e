-> module test lisp

MODULE 'tools/lisp'

PROC main()
  DEF a,b

  -> map a reverse over lists

  showcellint(map(<<1,2,3>,<4,5,6>,<7,8,9>>,{nrev}))

  -> somme une liste

  WriteF('\n\d\n',foldr(<1,2,3>,{add},0))

  -> selectionne une liste du paires 'zipped' qui ont head>tail

  showcellint(filter(zip(<1,2,3,4,5>,<2,1,-1,5,4>),{greater}))

  -> nombre de nombre positif et négatif d'une liste

  a,b:=partition(<1,-5,8,2,-2,4,5,7>,{pos})
  WriteF('\n\d \d\n',length(a),length(b))

ENDPROC

PROC add(x,y) IS x+y
PROC pos(x) IS x>=0

PROC greater(c)
  DEF h,t
  c <=> <h|t>
ENDPROC h>t
