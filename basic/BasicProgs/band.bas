10    dim a%(5000)
20    gosub 1000
30    sshape(x1%,y1%;x2%,y2%),a%()
35    ask mouse x%,y%,b%
37    if b% = 0 goto 35
40    gshape(x%,y%),a%()
50    goto 20
1000  drawmode 2
1010  ask mouse x1%,y1%,b%
1020  if b% = 0 goto 1010
1025  x2% = x1% : y2% = y1%
1030  ask mouse x%,y%,b%
1035  if x% = x2% and y% = y2% goto 1030
1040  box (x1%,y1%;x2%,y2%)
1045  x2% = x% : y2% = y%
1047  box(x1%,y1%;x2%,y2%)
1050  if b% <> 0 goto 1030
1065  box(x1%,y1%;x2%,y2%)
1067  drawmode 0
1070  return
