100   rem
105   rem random-circles.bas
110   rem Rick Parker
115   rem 10/14/85
120   rem
1000  screen 1,4,0:scnclr
1001  randomize
1002  input "How many circles ";howmany:scnclr
1005  for number= 1 to howmany
1006  color= int(rnd*32)
1007  peno color
1010  xaxis%=int(rnd*640):yaxis%=int(rnd*400):radius%=int(rnd*200):aspect=rnd
1020  locate (xaxis%,yaxis%)
1030  circle ,radius%,aspect
1090  next number
