10    '  ****  Spheres  ****
20    '  **  From ANALOG magazine  **
30    '  **  Translated from the Atari  **
40    '  **  by David Milligan, 70707,2521  11/2/85 **
50    '
60    '  ***  Draws multicoloured spheres of random
70    '  ***  sizes at random locations on the screen,
80    '  ***  endlessly, with a brief pause between
90    '  ***  spheres. Click left mouse button to exit.
100   '
110   ask window wid%,hi%:if wid%<600 then 130
120   screen 0,4,0
130   rgb 0,0,0,0:rgb 15,0,0,0
140   rgb 3,15,6,0:rgb 9,0,0,15
150   rgb 10,3,6,15:rgb 11,7,7,15
160   rgb 12,12,0,14:rgb 13,15,2,14
170   window #1,0,0,320,200,"Spheres"
180   cmd 1:graphic(1):scnclr
190   colr=2:randomize -1
200   size=90:cx=160:cy=96:time=1:deg=pi/180
210   pena colr
220   draw(cx+size,cy)
230   for y=90 to 0 step -6
240   colr=colr+1:if colr=15 then colr=2
250   pena colr
260   for x=0 to 360 step 10
270   if time=1 then goto 280 else goto 300
280   x2=cx+size*cos(x*deg):goto 290
290   y2=cy-(size*sin(x*deg)*sin(y*deg)):goto 310
300   x2=cx-(size*sin(x*deg)*sin(y*deg)):y2=cy+size*cos(x*deg)
310   draw(to x2,y2)
320   ask mouse x%,y%,b%:if b%<>0 then 450
330   next x:next y
340   time =time+1:if time=2 then draw(cx,cy+size):goto 230
350   size=20+rnd(1)*38:cx=size+1+(rnd(1)*(318-(size*2)))
360   cy=size+1+(rnd(1)*(190-(size*2)))
370   gosub 420:time=1:goto 220
380   pena 0 :for x=0 to 90 step 0.5
390   x2=size*cos(x*deg):y2=size*sin(x*deg)
400   draw(cx+x2,cy+y2 to cx-x2,cy+y2):draw(cx+x2,cy-y2 to cx-x2,cy-y2)
410   next x:pena colr:return
420   for i=0 to 500:ask mouse x%,y%,b%
430   if b%<>0 then 450
440   next i:goto 380
450   scnclr:close 1:rgb 0,6,9,15:rgb 15,11,11,11
