10    '  ***  Wheels  ***
20    '  ***  by Jungbo Yang  ***
30    '  ***    (really !)    ***
40    '  ***  From the April 1984 issue  ***
50    '  ***  of ANTIC magazine  ***
60    '
70    '  **  Translated from the Atari  **
80    '  **  by David Milligan, 70707,2521  **
90    '  ***       11/4/85       ***
100   '  ***  an interesting graphics toy  ***
110   '
120   '  ***  R  - rotation angle (0-359)  ***
130   '  ***  VX - horz. variation factor  ***
140   '  ***  VY - vert.    "        "     ***
150   '  
160   '  ***  The input variables are supposed  ***
170   '  ***  to be whole numbers, but you can  ***
180   '  ***  conjure up some bizzarre and      ***
190   '  ***  intriguing patterns using floats. ***
200   '
210   '  ***          sample inputs             ***
220   '
230   '  ***  10,0,0    -  circle (36 segments)
240   '  ***  1,200,200  -  patterned diamond
250   '  ***  7,100,200  -  endless diamond & circle
260   '  ***  .5,.5,.6   -  balloon
270   '  ***  .5,.314,100  -  EEG for a Kdatylno
280   '  ***  1,5,.9    -  my signature (so they tell me)
290   '  ***  .5,12,312, 2,300,500, 7,100,200, etc.
300   '
310   '  ***  Click left mouse button to return to  ***
320   '  ***  input prompt while drawing or when finished  ***
330   '
340   '
350   ask window w%,h%:if w%<600 then screen 1,4,0
360   scnclr
370   rgb 0,0,0,0
380   rgb 1,15,15,15
390   rgb 3,15,6,0:rgb 9,0,0,15
400   rgb 10,3,6,15
410   rgb 11,7,7,15:rgb 12,12,0,14
420   rgb 13,15,2,14
430   col=2:cnt=0
440   pena col:cx=320:cy=80:deg=pi/180
450   draw(cx,cy+70):inc=0
460   input "R,VX,VY ";rot,vx,vy
470   rgb 15,0,0,0
480   inc=inc+rot
490   if vx=0 then nx=int(sin(inc*deg)*140):goto 510
500   nx=int(sin(inc*deg)*abs(sin((inc*deg)*vx))*140)
510   ny=int(cos(inc*deg)*abs(cos((inc*deg)*vy))*70)
520   cnt=cnt+1:if cnt<61 then 560
530   cnt=0
540   col=col+1:if col=15 then col=2
550   pena col
560   draw(to nx+cx,ny+cy)
570   ask mouse x%,y%,b%:if b%<>0 then 590
580   if ny<70 then 480
590   ask mouse x%,y%,b%:if b%=0 then 590
600   rgb 15,11,11,11
610   goto 360
