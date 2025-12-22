0 saucers.bas
10    screen 0,5
20    audio 15,1
30    scnclr
40    dim saucer%(1560),base%(720),shot%(180),eshot%(180),per%(20)
50    rgb 0,0,0,0:black=0
60    rgb 3,0,5,5:rgb 4,0,10,10:rgb 5,15,15,0
70    rgb 6,5,0,0
80    rgb 7,0,4,0:rgb 8,0,8,0:rgb 9,0,12,0:rgb 10,10,10,10
90    rgb 11,10,0,10:rgb 12,15,0,0
100   c=3:pena c
110   read xx,yy
120   locate (xx,yy)
130   read xx,yy
140   if xx<0 then 160 else draw (to xx,yy)
150   goto 130
160   c=c+1:pena c:if c<7 then 110
170   sshape (82,100;121,108),saucer%()
180   pena black:for y=100 to 108:draw (80,y to 120,y):next
190   pena 7:draw (95,185 to 105,185 to 104,184 to 96,184):pena 8:draw (97,183 to 103,183 to 102,182 to 98,182):pena 9:draw (99,181 to 101,181)
200   pena 10:draw (99,180 to 101,180 to 101,178 to 99,178 to 99,179 to 100,179)
210   sshape (92,177;108,186),base%()
220   pena 11:draw (1,1 to 1,4 to 2,5 to 3,4 to 3,1 to 2,0):pena 12:draw (2,1 to 2,4)
230   sshape (0,0;4,9),shot%()
240   pena black:for y=0 to 5:draw (0,y to 4,y):next
250   sshape (0,0;4,9),eshot%()
260   saucx=20
270   spx=3
280   px%=92
290   gosub 970:rem set up explosion
300   rem ** main loop **
310   gosub 720:rem saucer
320   gosub 350:rem player
330   gosub 490:rem shot
340   goto 310
350   rem ** player movement **
360   ask mouse mx%,my%,b%
370   if mx%=px% then if b%=4 then goto 420 else return
380   if mx%>px% then px%=px%+2 else px%=px%-2
390   if px%<0 then px%=0 else if px%>300 then px%=300
400   gshape (px%,177),base%()
410   if b%<>4 then return
420   rem ** new shot **
430   if shstat=1 then gshape (sx,sy),eshot%()
440   sx=px%+6:rem change the 5
450   sy=169
460   gshape (sx,sy),shot%()
470   shstat=1
480   return
490   rem ** handle shot **
500   if shstat=0 then return
510   if sy=0 then gshape (sx,sy),eshot%():shstat=0:return
520   if sx>=saucx and sx-saucx<35 and sy<saucy and saucy-sy<7 then goto 560:rem hit saucer
530   sy=sy-3
540   gshape (sx,sy),shot%()
550   return
560   rem ** hit saucer **
570   rgb 20,15,7,0:rgb 21,13,5,0:rgb 22,11,3,0:rgb 23,9,1,0
580   for y=saucy to saucy+8:for x=saucx to saucx+35
590   pena cint(3*rnd(1))+20
600   draw (x,y)
610   next x:next y
620   for a=1 to 25:for b=20 to 23:ask rgb b,r%,g%,b%
630   if b=20 then rgb 23,r%,g%,b% else rgb b-1,r%,g%,b%
640   for c=1 to 100:next
650   next b:next a
660   volume 3,vol%():period 10,per%()
670   audio 15,1
680   x%=sound(10,0,0,64,254)
690   t$="you won. oh boy  how exciting."
700   x%=narrate(translate$(t$))
710   end
720   rem ** move saucer **
730   blinkc=blinkc+1:if blinkc<20 then goto 760
740   blinkc=0
750   ask rgb 6,r%,g%,b%:if r%=5 then rgb 6,15,g%,b% else rgb 6,5,g%,b%
760   saucx=saucx+spx:if saucx>268 or saucx<5 then spx=-spx:gosub 800:saucy=saucy+8
770   if saucy>178 then goto 960
780   gshape (saucx,saucy),saucer%()
790   return
800   pena black:for y=saucy to saucy+10:draw (saucx,y to saucx+40,y):next
810   saucx=saucx+spx*2
820   return
830   data 100,100,102,100,103,101,103,102
840   data 104,103,109,103,110,104,116,104
850   data 117,105,116,106,110,106,109,107
860   data 93,107,92,106,86,106,85,105,86,104,92,104
870   data 93,103,98,103,99,102,99,101
880   data -1,0
890   data 99,103,103,103,103,104,109,104,93,104
900   data 93,105,86,105,116,105
910   data -1,0
920   data 109,106,93,106
930   data -1,0
940   data 100,101,102,101,102,102,100,102
950   data -1,0
960   ?"you lost."
970   for a=0 to 19 step 2
980   if cint(a/4)=a/4 then 1020
990   per%(a)=cint(-1000000*rnd(1))
1000  per%(a+1)=cint(1280*rnd(1))
1010  goto 1040
1020  per%(a)=cint(1000000*rnd(1))
1030  per%(a)=cint(12800*rnd(1))
1040  next a
1050  for a=0 to 5
1060  read vol%(a)
1070  next a
1080  return
1090  data 6000000,64,-100000,0,0,0
