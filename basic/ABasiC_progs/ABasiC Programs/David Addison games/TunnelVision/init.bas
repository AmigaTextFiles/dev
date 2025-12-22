10    'TUNNEL VISION
15    'by David Addison ©1986
20    '
25    'This program has been put  into the Public Domain -- ENJOY
30    '
35    '
46    screen 0,5:graphic 1:talk$="TUNNEL VISION!":gosub 32000
47    gosub 10000:a$="PLEASE STAND BY":gosub 16000:gosub 30000
50    gosub 4000:gosub 5000:randomize -1
60    sshape(0,21;303,143),tempback%()
65    gosub 13000:gshape(0,22),mapback%()
80    xc=3
85    yc=int(rnd(1)*((length-9)/2))*2+9:firstmy=yc
90    ex=xc:ey=yc:ypnt=500:pntr=0:pmax=0:outline 0
100   pena 22:area(xc*5,yc*5 to (xc*5)+4,yc*5 to (xc*5)+4,(yc*5)+4 to xc*5,(yc*5)+4):pena 21
110   lng=int(rnd(direction)*3)*2
120   direction=int(rnd(1)*4)
130   s=abs(direction=0)-abs(direction=1)
140   t=abs(direction=2)-abs(direction=3)
180   i=2
190   p=pixel((xc+s*i)*5,(yc+t*i)*5)
200   if (p=4 or p=28 or p=21 or p=22 or p=23 or p=19 or p=0) and i=2 then 110
210   if p=4 or p=28 or p=21 or p=22 or p=23 or p=19 or p=0 then lng=2:goto 130
220   i=i+2:if i <= lng then 190
221   if p=8 or p=27 then p=0:gosub 20000
222   xc=xc+s*lng:yc=yc+t*lng
225   if pntr>pmax then pmax=pntr:mx=xc:my=yc:ms=s:mt=t
230   pntr=pntr+1
235   rem
240   xpnt(pntr)=xc
250   xpnt(ypnt+pntr)=yc
290   gosub 500:if p>0 then 300
295   goto 110:rem **** SOUND ****
300   xc=xpnt(pntr)
305   yc=xpnt(ypnt+pntr)
310   pntr=pntr-1:gosub 500
315   rem **** SOUND ****
320   if p>0 and pntr>0 then 300
325   rem **** SOUND ****
330   if pntr<>0 then area(xc*5,yc*5 to (xc*5)+4,yc*5 to (xc*5)+4,(yc*5)+4 to xc*5,(yc*5)+4)
335   if pntr>0 then 110
340   pena 23:area(mx*5,my*5 to (mx*5)+4,my*5 to (mx*5)+4,(my*5)+4 to mx*5,(my*5)+4):pena 21
345   wave 256,timbre%()
350   if 1-extra then 390
360   for i=1 to 25
365   pp%=sound(12,1,2,64,3000)
370   xc=int(rnd(1)*(xwidth-4))+9:yc=(int(rnd(1)*(length-3))+6)+4:if int((xc+yc)/2)=(xc+yc)/2 then 370
380   area(xc*5,yc*5 to (xc*5)+4,yc*5 to (xc*5)+4,(yc*5)+4 to xc*5,(yc*5)+4):next i
390   for y=6 to length+7
400   for x=2 to xwidth+9:p=pixel(x*5,y*5):pena 1:draw(x*5,y*5)
405   if p=8 or p=27 then mappic%(y*(xwidth+9)+x)=0 else mappic%(y*(xwidth+9)+x)=p-20
407   if y=6 or y=12 or y=19 or y=26 then pp%=sound(12,1,1,30,800)
410   next x:next y
420   erase xpnt:dim xpnt(100)
430   restore 6000:s=-ms:t=-mt:ms=0:for i=0 to 6:read xpnt(i):next i:p3=0
440   ypnt=8:xpnt(ypnt-1)=79:for i=0 to 6:xpnt(ypnt+i)=79-(xpnt(i)+xpnt(i))/4:next i
450   gshape(0,21),tempback%()
460   pena 22:draw(3+124,firstmy+116):pena 4:draw(mx+124,my+116):oldmx=mx:oldmy=my
470   goto 1000
500   p1=pixel((xc+2)*5,yc*5):if p1=8 or p1=27 then p1=0 else p1=1
510   p2=pixel((xc-2)*5,yc*5):if p2=8 or p2=27 then p2=0 else p2=1
520   p3=pixel(xc*5,(yc+2)*5):if p3=8 or p3=27 then p3=0 else p3=1
530   p4=pixel(xc*5,(yc-2)*5):if p4=8 or p4=27 then p4=0 else p4=1
540   p=p1 and p2 and p3 and p4:return
600   outline 1:p1=0
602   pena border:peno border
605   xf=75:yf=32:if nr(1,1)=3 then pp%=sound(12,1,1,64,5000)
608   gshape(73,31),tvpic%()
610   for yc=0 to 6 step dead:p2=nr(1,yc):if p2=2 then gosub 17000
612   if p2<=0 then 670
615   x1=p1:x2=xpnt(yc):p1=x2
620   if feet=1 and yc>0 then if p2=3 and nr(1,yc-1)=3 then draw(79+xf,xpnt(ypnt+yc-1)+yf to 79+xf,xpnt(ypnt+yc)+yf)
630   for xc=0 to 2 step 2:if xc>0 then x1=158-x1:x2=158-x2
635   xd1=x1/2:xd2=x2/2:if nr(xc,yc)>0 then 645
640   pena walls:area(x1+xf,xd1+yf to x2+xf,xd2+yf to x2+xf,(79-xd2)+yf to x1+xf,(79-xd1)+yf)
642   if xc=0 then draw(x1+xf,(xd1+yf)+1 to x1+xf,(78-xd1)+yf),walls else draw(x1+xf,(xd1+yf)-1 to x1+xf,(80-xd1)+yf),walls
643   goto 655
645   draw(x1+xf,xd1+yf to x1+xf,(79-xd1)+yf)
649   pena halls:if yc=0 then if xc=0 then draw(x2+(xf-1),(79-xd2)+yf to x2+(xf-1),xd2+yf) else draw(x2+(xf+1),(79-xd2)+yf to x2+(xf+1),xd2+yf)
650   area(x1+xf,xd2+yf to x2+xf,xd2+yf to x2+xf,(79-xd2)+yf to x1+xf,(79-xd2)+yf):draw(x2+xf,xd2+yf to x2+xf,(79-xd2)+yf)
651   if nr(1,yc+1) then pena border:goto 652 else 654
652   if yc<>0 then draw(x2+xf,(79-xd2)+yf to x2+xf,xd2+yf)
653   if yc=0 then if xc=0 then draw(x2+(xf-1),(79-xd2)+yf to x2+(xf-1),xd2+yf) else draw(x2+(xf+1),(79-xd2)+yf to x2+(xf+1),xd2+yf)
654   pena border:goto 660
655   p2=nr(1,yc+1)
656   rem if p2=0 or p2=2 then if xc=0 then draw((x2-1)+xf,(79-xd2)+yf to (x2-1)+xf,xd2+yf) else draw((x2+1)+xf,(79-xd2)+yf to (x2+1)+xf,xd2+yf)
658   pena walls:if yc=0 then if xc=0 then draw(x2+(xf-1),(79-xd2)+yf to x2+(xf-1),xd2+yf) else draw(x2+(xf+1),(79-xd2)+yf to x2+(xf+1),xd2+yf)
660   pena border:if feet=1 then if yc>0 and nr(xc,yc)=3 then draw(79+xf,xpnt(ypnt+yc)+(yf+2) to x1+xf,xpnt(ypnt+yc)+(yf+2))
665   next xc:next yc:if nr(1,7)=0 then pena border:draw(79+xf,39+yf to 79+xf,40+yf)
668   return
670   pena halls:area(x2+xf,xd2+yf to (158-x2)+xf,xd2+yf to (158-x2)+xf,(79-xd2)+yf to x2+xf,(79-xd2)+yf)
675   if yc<>0 then draw((158-x2)+xf,(xd2-1)+yf to (158-x2)+xf,(80-xd2)+yf):draw(x2+xf,(xd2-1)+yf to x2+xf,(80-xd2)+yf)
676   return
1000  if t<>1 then 1020
1015  for xc=-1 to 1:for yc=0 to 7:nr(xc+1,yc)=mappic%((my+yc)*(xwidth+9)+mx-xc):next yc:next xc:a$="SOUTH":goto 1050
1020  if t<>-1 then 1030
1025  for xc=-1 to 1:for yc=0 to 7
1026  if (my-yc)*(xwidth+9)+mx+xc <0 then nr(xc+1,yc)=0:goto 1028
1027  nr(xc+1,yc)=mappic%((my-yc)*(xwidth+9)+mx+xc)
1028  next yc:next xc:a$="NORTH":goto 1050
1030  if s<>-1 then 1040
1035  for xc=-1 to 1:for yc=0 to 7:nr(xc+1,yc)=mappic%((my-xc)*(xwidth+9)+mx-yc):next yc:next xc:a$="WEST":goto 1050
1040  if s<>1 then 1050
1045  for xc=-1 to 1:for yc=0 to 7:nr(xc+1,yc)=mappic%((my+xc)*(xwidth+9)+mx+yc):next yc:next xc:a$="EAST"
1050  walls=mazecl%(shade,0):halls=mazecl%(shade,1):gosub 600:pp%=sound(12,1,1,64,500)
1052  if temp$<>a$ then temp$=a$:a$="YOU'RE LOOKING "+a$:gosub 16100:gosub 16000
1055  ask mouse x%,y%,b%:if b%<>4 then 1055 else gosub 22000
1056  if push=10 then 23000
1060  if push<>32 or mapsw=0 then 1065
1061  if p3>2 then a$="THREE LOOKS IS YOUR LIMIT":gosub 16000:temp$="":for i=1 to 100:next i:goto 1065
1062  p3=p3+1:a$="CHECK TUNNEL MAZE #"+str$(p3):gosub 16000:temp$="":gosub 3000
1063  for x=1 to 50:for p=1 to 4:for i=1 to 10:next i:pena p:area(mx*5,my*5 to (mx*5)+4,my*5 to (mx*5)+4,(my*5)+4 to mx*5,(my*5)+4):next p:next x
1064  sleep(5*10^6):gshape(0,21),tempback%():goto 1000
1065  p=push:if p=50 or p=52 or p=54 or p=56 then 1070 else 1055
1070  if p=56 then mx=mx+s:my=my+t:if mappic%(my*(xwidth+9)+mx)=0 then mx=mx-s:my=my-t:p=0
1085  if p=50 then p1=s:s=-t:t=p1:p1=s:s=-t:t=p1:gosub 15200
1090  if p=54 or p=52 then p1=s:s=-t:t=p1:shade=shade+1:if shade>6 then shade=1
1095  if p=54 then gosub 15000
1100  if p=52 then s=-s:t=-t:gosub 15100
1110  if p=0 then a$="**** CRASH ****":gosub 25000:sleep(50000):p=0:ms=0:gosub 21000
1120  i=mappic%(my*(xwidth+9)+mx):if i=2 then 2000
1121  if i=3 and (p<>54 and p<>52 and p<>50 and p<>0)then batt=batt-1:gosub 18000
1122  if p=0 then 1130
1124  if path=border and i=3 then pena 19 else pena path
1125  draw(oldmx+124,oldmy+116):pena 4:draw(mx+124,my+116):oldmx=mx:oldmy=my
1130  mappic%(my*(xwidth+9)+mx)=3:if p<>0 then 1000
1140  p=1:goto 1055
2000  a$="**** YOU ARE FREE ****":gosub 16000:for x=1 to 10:for y=200 to 0 step -4:pp%=sound(12,1,2,(x*6)+4,y*2)
2010  next Y:for i=1 to 6:pena 1:draw((rnd(1)*157)+xf+1,1+yf to (rnd(1)*157)+xf+1,78+yf):next i:next x
2012  peno border:for i=0 to 39
2014  box(74+i,32+i;234-i,111-i),0
2016  next i
2018  gshape(72,30),outside%()
2020  sleep(10*10^6):a$="*** YOUR FINAL MAP ***":gosub 16000:gosub 3000
2030  goto 23000
3000  sshape(0,21;303,143),tempback%():gosub 13000:gshape(0,22),mapback%()
3002  outline 0:for y=7 to length+7:pp%=sound(12,1,2,50,1000):for x=3 to xwidth+9
3005  temp=mappic%(y*(xwidth+9)+x):if temp=0 then 3020
3007  pena 20+temp
3010  area(x*5,y*5 to (x*5)+4,y*5 to (x*5)+4,(y*5)+4 to x*5,(y*5)+4)
3020  next x:next y
3030  return
4000  dim timbre%(255):k#=2*3.14159265#/256
4010  for i=0 to 255
4020  timbre%(i)=31*(sin(i*k#)+sin(2*i*k#)+sin(3*i*k#)+sin(4*i*k#))
4030  next i
4040  wave 256,timbre%()
4050  audio 12,1
4100  dim timbre1%(255)
4110  for i=0 to 255
4120  timbre1%(i)=-127+(rnd(1)*255)
4130  next i
4140  wave 256,timbre1%()
4170  return
5000  graphic 1:temp$=""
5002  xwidth=49:length=19:dp=96:d2=dp*8:ext=0:shade=1
5003  dim mappic%(2000),xpnt(1000),nr(2,7),tvpic%(2600),tunnelpic%(11000)
5004  dim mapback%(6500),tempback%(6500),mazecl%(6,1),north%(350),south%(350),east%(350),west%(350)
5005  dim g1%(300),g2%(300),g3%(300),g4%(300),g5%(300),outside%(2700)
5009  gosub 12000
5010  border=29:walls=24:halls=5:ceiling=7:floor=30:start=19:finish=6
5015  batt=100:dead=1:path=23:damage=0:score=0
5020  restore 6010:for i=1 to 6:read mazecl%(i,0):read mazecl%(i,1):next i
5025  restore 5027:for i=0 to 8:read voice%(i):next i
5027  data 90,0,150,0,20000,64,4,0,0
5030  gshape(0,0),tunnelpic%()
5031  feet=0:extra=0:mapsw=0
5032  a$="T U N N E L  V I S I O N":gosub 16000:sleep(2*10^6)
5034  a$="--- By David Addison ---":gosub 16000:sleep(2*10^6)
5040  a$="Do you want to leave a Trail (Y/N)?":gosub 25000
5045  getkey a$:if instr("Yy",a$)>0 then feet=1
5050  a$="Do you want Extra Passages (Y/N)?":gosub 25000
5055  getkey a$:if instr("Yy",a$)>0 then extra=1
5060  a$="Do you want to use the Map (Y/N)?":gosub 25000
5065  getkey a$:if instr("Yy",a$)>0 then mapsw=1
5070  a$="*** TUNNEL VISION ***":gosub 16000
5080  return
6000  data 0,28,46,60,68,74,78
6010  data 24,5,20,8,25,19,9,3,15,11,5,6
10000 cnt=0:dim regsave%(100):bload "tunnelpic_dat",varptr(regsave%(0))
10010 for i=0 to 31
10020 rgb i,regsave%(cnt),regsave%(cnt+1),regsave%(cnt+2):cnt=cnt+3
10030 next i
10040 return
12000 rem
12010 bload "tvpic",varptr(tvpic%(0))
12020 bload "tunnelpic",varptr(tunnelpic%(0))
12030 bload "mapback",varptr(mapback%(0))
12040 bload "north",varptr(north%(0)):bload "south",varptr(south%(0))
12050 bload "east",varptr(east%(0)):bload "west",varptr(west%(0))
12060 bload "g1",varptr(g1%(0)):bload "g2",varptr(g2%(0)):bload "g3",varptr(g3%(0))
12070 bload "g4",varptr(g4%(0)):bload "g5",varptr(g5%(0))
12080 bload "outside",varptr(outside%(0))
12090 return
13000 drawmode 2
13010 for ii=0 to 59 step 4
13020 box(115-(ii*2),79-ii;187+(ii*2),85+ii)
13025 box(116-(ii*2),80-ii;186+(ii*2),84+ii)
13030 box(115-(ii*2),79-ii;187+(ii*2),85+ii)
13035 box(116-(ii*2),80-ii;186+(ii*2),84+ii)
13040 next ii:drawmode 1
13050 return
15000 pena ceiling:for i=-1 to 159 step 2:draw(i+xf,0+yf to i+xf,79+yf):next i
15010 return
15100 pena ceiling:for i=159 to -1 step -2:draw(i+xf,0+yf to i+xf,79+yf):next i
15110 return
15200 pena ceiling:for i=79 to 0 step -2:draw(-1+xf,i+yf to 159+xf,i+yf):next i
15210 return
16000 drawmode 1:penb 10:pena border:? at(1*8,15);space$(36):num=len(a$)
16010 msg$=space$(num)+a$+space$(2)
16020 for i=1 to num+1
16030 ? at((19-(num/2))*8,15);mid$(msg$,i,num)
16040 next i
16050 drawmode 0:return
16100 if mid$(a$,16,1)="N" then gshape(27,146),north%():goto 16140
16110 if mid$(a$,16,1)="S" then gshape(27,146),south%():goto 16140
16120 if mid$(a$,16,1)="E" then gshape(27,146),east%():goto 16140
16130 if mid$(a$,16,1)="W" then gshape(27,146),west%()
16140 return
17000 temp=halls:halls=finish:gosub 670:halls=temp:return
17100 temp=halls:halls=24:gosub 670:halls=temp:return
18000 if batt<-2 then goto 18100
18005 if batt=0 then gshape(10,56),g1%():dead=2
18006 IF BATT=0 THEN TALK$="YOUR BATTERY IS DEAD. SHORT RANGE SCANNER IS MALFUNCTIONING!,,":GOSUB 32000:GOTO 18100
18010 if batt=25 then gshape(10,56),g2%():talk$="CAUTION!,BATTERY IS GETING LOW!,,":GOSUB 32000:goto 18100
18020 if batt=50 then gshape(10,56),g3%():talk$="BATTERY IS HALF FULL!,,":GOSUB 32000:goto 18100
18030 if batt=75 then gshape(10,56),g4%():talk$="BATTERY IS DRAINING!,,":GOSUB 32000:goto 18100
18040 if batt=99 then talk$="WARNING,WARNING! BACK TRACKING DRAINS BATTERY!,,":GOSUB 32000
18100 score=score-1:gosub 18200:return
18200 drawmode 1:pena 19:penb 18
18210 locate(13,115)
18220 print using "+####";score
18230 drawmode 0:return
19000 for y=6 to length+6:for x=3 to xwidth+9
19010 temp=mappic%(y*(xwidth+9)+x):if temp=0 then 19050
19020 pena 20+temp
19030 draw(x,y+120)
19050 next x:next y
19060 return
20000 for q=1 to lng
20010 tx=(xc+s*q)*5:ty=(yc+t*q)*5
20020 area(tx,ty to tx+4,ty to tx+4,ty+4 to tx,ty+4)
20030 next q
20035 pp%=sound(12,1,3,50,((ty/5)*30)+tx/5)
20040 return
21000 audio 12,0:audio 12,1:if damage=4 then pp%=sound(12,1,2,50,18000):goto 21100
21010 damage=damage+1
21020 if damage=1 then pena 8:peno 8:top=82:talk$="OUCH!":gosub 32000
21030 if damage=2 then pena 6:peno 6:top=63:talk$="HAY,WATCH WHERE YOUR GOING!":gosub 32000
21040 if damage=3 then pena 19:peno 19:top=44:talk$="YOUR GOING TO DAMAGE SOMETHING!":gosub 32000
21045 if damage>=4 then pena 19:peno 19:top=25:path=border:talk$="NOW YOUVE DONE IT!":gosub 32000
21046 if damage>=4 then talk$="WISE GUY":gosub 32000
21050 box(267,top;280,102),1
21100 return
22000 push=-1:if x%>247 and x%<269 and y%>121 and y%<133 then push=56:goto 22100
22010 if x%>247 and x%<269 and y%>173 and y%<185 then push=50:goto 22100
22020 if x%>214 and x%<236 and y%>147 and y%<159 then push=52:goto 22100
22030 if x%>280 and x%<302 and y%>147 and y%<159 then push=54:goto 22100
22040 if x%>201 and x%<219 and y%>123 and y%<133 then push=32:goto 22100
22050 if x%>7 and x%<59 and y%>22 and y%<32 then push=10:goto 22100
22100 return
23000 a$="(E)nd Program or (N)ew Game?":gosub 16000:a$="":cnt=0
23010 get a$:ask mouse x%,y%,b%
23011 if cnt=2000 then b%=4
23012 if push<>10 then if b%=4 then gshape(0,21),tempback%()
23013 cnt=cnt+1
23014 if a$="" then 23010
23020 if instr("Ee",a$)>0 then system
23030 if instr("Nn",a$)>0 then 24000
23040 if push=10 then temp$="":goto 1000
23050 a$="":goto 23010
24000 temp$="":gosub 5010:randomize -1
24010 erase xpnt:dim xpnt(1000):goto 60
25000 drawmode 1:penb 10:pena border:? at(1*8,15);space$(36)
25010 num=len(a$):? at((19-(num/2))*8,15);a$
25020 drawmode 0:return
30000 graphic 1
30010 pena 25:? at(5*8,5*8);"Backtracking over Radio Active"
30012 ? "trail will drain Battery. When battery"
30014 ? "is empty the `Short Range Scanner'"
30016 ? "will start to malfunction."
30018 pena 28:?:?:? "     Crashing into walls will cause"
30020 ? "damage to `Long Range Scanner'."
30021 pena 19:?:?:? " `RED' ";:pena 3:? "is Start, ";:pena 22:? "`Yellow' ";:pena 3:? "is Finish."
30022 pena 8:?:?:? "     A perfect Game is:"
30024 ?:? "            A score of Zero,"
30026 ? "            A full Battery,"
30028 ? "            and No Damage."
30100 return
32000 talk$=translate$(talk$)
32010 pp%=narrate(talk$,voice%())
32020 return
