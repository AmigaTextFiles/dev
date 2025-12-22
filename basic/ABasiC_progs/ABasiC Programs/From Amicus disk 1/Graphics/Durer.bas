5     randomize -1
7     cnt = 0
10    dim Rrgb%(31,3)
20    rem window #1, 100,10,140,100,"triguys"
30    for i=0 to 15: ask rgb i,Rrgb%(i,1),Rrgb%(i,2),Rrgb%(i,3): next i
40    rem cmd 1
50    xmax=300: Ymax=200
60    z = 3
70    ymin=1
75    x0=150: y0=100
80    font 0: graphic 1
90    drawmode 2
100   a%=0: peno 2
110   area (xmax-1,ymin to xmax,ymin to xmax,ymax to xmax-1,ymax)
113   gosub 400
115   peno 1
120   gosub 500
130   gosub 300
250   get a$: if a$="" then 120
260   graphic 0: font 0: end
300   a%=(a%+1) mod 16: pena a%
310   gosub 1000
320   return
400   yb=95: drawmode 1: g=0.8
410   yb=int(g*yb)
420   if yb<3 then 440
430   draw(1,95+yb to 296,95+yb)
433   gosub 300
435   goto 410
440   drawmode 0
450   return
500   x1=int(rnd*265)+6
505   xd=(x0-x1)*(x0-x1)
510   y1=int(rnd*165)+6
515   yd=(y0-y1)*(y0-y1)
517   d=sqr(xd+yd)/164
520   x2=int(20*d)+1
530   y2=int(15*d)+1
535   rem randomize -1
540   x2=x1+x2
550   y2=y1+y2
570   p=rnd/2
580   x3=int(p*(x0-x1)+0.5)+x1
590   y3=int(p*(y0-y1)+0.5)+y1
600   x4=int(p*(x0-x2)+0.5)+x2
610   y4=int(p*(y0-y2)+0.5)+y2
620   gosub 300
630   if cnt > 99 then return
635   cnt=cnt+1: graphic 0: print at (34,1); cnt: graphic 1
640   area (x1,y1 to x3,y3 to x3,y4 to x1,y2)
650   area (x1,y1 to x3,y3 to x4,y3 to x2,y1)
655   gosub 300
660   area (x2,y2 to x4,y4 to x4,y3 to x2,y1)
665   gosub 300
670   area (x2,y2 to x4,y4 to x3,y4 to x1,y2)
675   gosub 300
680   area (x1,y1 to x2,y1 to x2,y2 to x1,y2)
690   return
1000  z=z+1: if z>15 then z=3
1005  c=1
1010  Rrgb%(z,1)=Rrgb%(z,1)+1
1020  Rrgb%(z,2)=Rrgb%(z,2)+3
1030  Rrgb%(z,3)=Rrgb%(z,3)+7
1040  rgb z, Rrgb%(z,1), Rrgb%(z,2), Rrgb%(z,3)
1050  return
2000  rem The author of this program is:
2010  rem     Dr. Gerald Hull
2020  rem     25 Smith Hill Road
2030  rem     Binghamton, New York  13905.
2040  rem He offers profound apologies to Albrecht DÜrer.
2050  rem He accepts no responsibility for anything he has done,
2060  rem and doesn't care who rips it off.

