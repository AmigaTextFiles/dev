10    dim a%(1000)
20    ask mouse x%,y%,b%
30    if b%=0% then 20
40    print "upper left";x%;y%
50    for i=1 to 1000 : next i
60    ask mouse x2%,y2%,b%
70    if b%=0% then 60
80    print "Lower right";x2%,y2%
90    sshape(x%,y%;x2%,y2%),a%()
100   drawmode 2
110   box(x%,y%;x2%,y2%)
120   drawmode 0
130   for i=1 to 1000
140   next i
150   ask mouse x%,y%,b%
160   if b%=0% then 150
170   gshape(x%,y%),a%()
180   goto 150
