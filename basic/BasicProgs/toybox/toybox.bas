10    '!TOYBOX! - Robert Sawdey - 10/21/85
20    ' title
30    screen 0,4,0:scnclr:print " "
40    rgb 0,0,0,0:rgb 1,0,0,0:rgb 2,0,0,15:rgb 3,15,0,0:rgb 4,0,0,0:rgb 15,0,0,0
50    peno 4:box(68,6;240,166),0:print at (11,9);"Created exclusively";at (19,11);"for";at (12,13);"Slipped Disk Inc."
60    pena 0:box(14,14;153,40),1:print at (4,4);"! T O Y B O X !"
70    box(166,136;288,158),1:print at (23,19);"Robert Sawdey"
80    pena 2:paint(95,50),1:rgb 4,15,15,2:pena 3:paint(16,16),1:paint(170,140),1:sleep(1000000)*5
90    for j%=0 to 15:for i%=2 to 4:ask rgb i%,r%,g%,b%
100   if r%>0 then r%=r%-1
110   if g%>0 then g%=g%-1
120   if b%>0 then b%=b%-1
130   rgb i%,r%,g%,b%:sleep(12000):next i%:next j%
140   '   setup palette
150   rgb 0,0,0,0:' screen color
160   rgb 1,15,15,10:'  text color
170   rgb 2,15,10,15:'    border
180   rgb 3,15,0,15
190   rgb 4,15,0,10
200   rgb 5,15,0,5
210   rgb 6,15,0,0
220   rgb 7,15,5,5
230   rgb 8,5,0,10
240   rgb 9,0,0,15
250   rgb 10,5,5,15
260   rgb 11,0,10,5
270   rgb 12,5,15,5
280   rgb 13,10,15,5
290   rgb 14,15,15,5
300   rgb 15,15,15,15
310   '   menu
320   dim lines%(201,5)
330   scnclr:print" "
340   print at (12,2);"! T O Y B O X !"
350   print at (15,5);"0. Quit"
360   print at (15,6);"1. Lines1"
370   print at (15,7);"2. Lines2"
380   print at (15,8);"3. Lines3"
390   print at (15,9);"4. Boxes"
400   print at (15,10);"5. Circles"
410   print at (13,12);"                    "
420   print at (14,12);"";:input;"Selection";sel%:print
430   if sel%=0 then goto 1480
440   if sel%>5 then goto 410
450   on sel% gosub 470,690,920,1140,1300
460   goto 330
470   'LINES1
480   scnclr:randomize -1
490   x1%=rnd(1)*319:y1%=rnd(1)*199:x2%=rnd(1)*319:y2%=rnd(1)*199
500   x1i%=(5-rnd(1)*10):y1i%=(5-rnd(1)*10)
510   x2i%=(5-rnd(1)*10):y2i%=(5-rnd(1)*10)
520   c%=rnd(1)*15
530   x1%=x1%+x1i%:y1%=y1%+y1i%:x2%=x2%+x2i%:y2%=y2%+y2i%
540   if (x1%<0) then x1%=0:x1i%=x1i%*(-1)
550   if (x1%>319) then x1%=319:x1i%=x1i%*(-1)
560   if (y1%<0) then y1%=0:y1i%=y1i%*(-1)
570   if (y1%>199) then y1%=199:y1i%=y1i%*(-1)
580   if (x2%<0) then x2%=0:x2i%=x2i%*(-1)
590   if (x2%>319) then x2%=319:x2i%=x2i%*(-1)
600   if (y2%<0) then y2%=0:y2i%=y2i%*(-1)
610   if (y2%>199) then y2%=199:y2i%=y2i%*(-1)
620   draw(x1%,y1%;x2%,y2%),c%
630   ptr%=ptr%+1:if ptr%>20 then ptr%=1
640   lines%(ptr%,1)=x1%:lines%(ptr%,2)=y1%
650   lines%(ptr%,3)=x2%:lines%(ptr%,4)=y2%:lines%(ptr%,5)=c%
660   get a$:if a$<>"" then return
670   if ptr%=1 then goto 520 else goto 530
680   'LINES2
690   scnclr:randomize -1
700   x1%=rnd(1)*319:y1%=rnd(1)*199:x2%=rnd(1)*319:y2%=rnd(1)*199
710   x1i%=(5-rnd(1)*10):y1i%=(5-rnd(1)*10)
720   x2i%=(5-rnd(1)*10):y2i%=(5-rnd(1)*10)
730   c%=(rnd(1)*14)+1
740   x1%=x1%+x1i%:y1%=y1%+y1i%:x2%=x2%+x2i%:y2%=y2%+y2i%
750   if (x1%<0) then x1%=0:x1i%=x1i%*(-1)
760   if (x1%>319) then x1%=319:x1i%=x1i%*(-1)
770   if (y1%<0) then y1%=0:y1i%=y1i%*(-1)
780   if (y1%>199) then y1%=199:y1i%=y1i%*(-1)
790   if (x2%<0) then x2%=0:x2i%=x2i%*(-1)
800   if (x2%>319) then x2%=319:x2i%=x2i%*(-1)
810   if (y2%<0) then y2%=0:y2i%=y2i%*(-1)
820   if (y2%>199) then y2%=199:y2i%=y2i%*(-1)
830   draw(x1%,y1%;x2%,y2%),c%
840   ptr%=ptr%+1:if ptr%>200 then ptr%=1
850   draw(lines%(ptr%,1),lines%(ptr%,2);lines%(ptr%,3),lines%(ptr%,4)),0
860   lines%(ptr%,1)=x1%:lines%(ptr%,2)=y1%
870   lines%(ptr%,3)=x2%:lines%(ptr%,4)=y2%
880   get a$:if a$<>"" then return
890   if (ptr% mod 33)=0 then if (rnd(1)>.7) goto 710 else goto 730
900   goto 740
910   'LINES3
920   scnclr:randomize -1
930   x1%=rnd(1)*319:y1%=rnd(1)*199:x2%=rnd(1)*319:y2%=rnd(1)*199
940   x1i%=(5-rnd(1)*10):y1i%=(5-rnd(1)*10)
950   x2i%=(5-rnd(1)*10):y2i%=(5-rnd(1)*10)
960   c%=(rnd(1)*14)+1:linepat(rnd(1)*65535)
970   x1%=x1%+x1i%:y1%=y1%+y1i%:x2%=x2%+x2i%:y2%=y2%+y2i%
980   if (x1%<0) then x1%=0:x1i%=x1i%*(-1)
990   if (x1%>319) then x1%=319:x1i%=x1i%*(-1)
1000  if (y1%<0) then y1%=0:y1i%=y1i%*(-1)
1010  if (y1%>199) then y1%=199:y1i%=y1i%*(-1)
1020  if (x2%<0) then x2%=0:x2i%=x2i%*(-1)
1030  if (x2%>319) then x2%=319:x2i%=x2i%*(-1)
1040  if (y2%<0) then y2%=0:y2i%=y2i%*(-1)
1050  if (y2%>199) then y2%=199:y2i%=y2i%*(-1)
1060  draw(x1%,y1%;x2%,y2%),c%
1070  ptr%=ptr%+1:if ptr%>200 then ptr%=1
1080  draw(lines%(ptr%,1),lines%(ptr%,2);lines%(ptr%,3),lines%(ptr%,4)),0
1090  lines%(ptr%,1)=x1%:lines%(ptr%,2)=y1%
1100  lines%(ptr%,3)=x2%:lines%(ptr%,4)=y2%:lines%(ptr%,5)=c%
1110  get a$:if a$<>"" then return
1120  if (ptr% mod 33)=0 then if (rnd(1)>.7) goto 940 else goto 960
1130  goto 970
1140  ' box
1150  scnclr:randomize -1:drawmode 1
1160  ask window wx%,wy%
1170  x1%=rnd*wx%
1180  y1%=rnd*wy%
1190  x2%=rnd*wx%
1200  y2%=rnd*wy%
1210  for i%=0 to 7:a%(i%)=rnd*65535:next
1220  pa%=rnd*15:pb%=rnd*15
1230  if pb%=pa% then pb%=pa%+1
1240  pat%=rnd*8
1250  pattern pat%,a%()
1260  pena pa%:penb pb%
1270  box(x1%,y1%;x2%,y2%),1
1280  get a$:if a$<>"" then return
1290  goto 1160
1300  'CIRCLE
1310  a%(0)=&hffff
1320  pattern 1,a%
1330  scnclr:randomize -1
1340  for i% = 150 to 0 step -10
1350  c%=i%/10:peno c%
1360  circle (153,93),i%,.87
1370  next
1380  for j%=1 to 15
1390  ask rgb 15, r%,g%,b%
1400  for i% = 14 to 1 step -1
1410  ask rgb i%, r1%,g1%,b1%
1420  rgb i%+1,r1%,g1%,b1%
1430  next i%
1440  rgb 1,r%,g%,b%
1450  next j%
1460  get a$:if a$<>"" then return
1470  goto 1380
1480  ' reset rgb
1490  rgb 0,6,9,15:rgb 1,0,0,0:rgb 2,15,15,15:rgb 3,15,9,10:rgb 4,14,3,0:rgb 5,15,11,0:rgb 6,15,15,2:rgb 7,11,15,0
1500  rgb 8,5,13,0:rgb 9,0,14,13:rgb 10,7,13,15:rgb 11,12,0,14:rgb 12,15,2,14:rgb 13,15,13,11:rgb 14,12,9,8:rgb 15,11,11,11
1510  scnclr:print" "
