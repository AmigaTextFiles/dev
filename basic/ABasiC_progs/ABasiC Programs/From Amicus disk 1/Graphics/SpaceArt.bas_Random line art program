10    rem *** SPACE ART 10/26/85
20    rem
30    screen 1,4,0:drawmode 1
40    graphic (1)
50    scnclr
52    rgb 0,0,0,0
54    rgb 1,0,0,0
56    rgb 2,0,0,0
60    pena 1:penb 1:paint (320,100)
70    pena (rnd*14)+2
80    x1%=319:y1%=99
90    i=0:ra=rnd*3.1416+.01
100   for i=0 to 36 step .05
110   x%=280*sin(i)+x1%
120   y%=80*cos(ra*i)+y1%
130   draw (x1%,y1% to x%,y%)
140   next i
150   sleep 3*1^6
160   goto 50
