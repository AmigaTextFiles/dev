10    GOTO 1540
20    b1=-99999:ss=0:ht=0:b5=0:td(1)=d(0):td(2)=d(1):td(3)=d(0):td(4)=d(0)
30    FOR i=1 TO 4:tm(i)=24:NEXT i:nm=mm:j=-b(0):IF j>mm THEN j=mm
40    IF j>0 THEN FOR i=1 TO j:tm(i)=26:NEXT i
50    FOR i=0 TO 25:tb(i)=b(i):NEXT i:mt=0
60    tm=me(0):FOR i=1 TO nm:IF tm(i)<26 THEN 100
70    IF tb(25-td(i))>1 THEN 720
80    IF tb(25-td(i))=1 THEN tb(25)=tb(25)+1:tb(25-td(i))=0
90    tb(25-td(i))=tb(25-td(i))-1:tb(0)=tb(0)+1:GOTO 230
100   IF i>1 THEN IF tm(i)+ss>tm(i-1) THEN 120
110   IF tb(tm(i))<0 THEN 140
120   tm(i)=tm(i)-1:IF tm(i)>0 THEN 100
130   GOTO 670
140   IF tm(i)-td(i)<1 THEN 180
150   IF tb(tm(i)-td(i))>1 THEN 120
160   IF tb(tm(i)-td(i))=1 THEN tb(25)=tb(25)+1:tb(tm(i)-td(i))=0
170   tb(tm(i)-td(i))=tb(tm(i)-td(i))-1:tb(tm(i))=tb(tm(i))+1:GOTO 230
180   FOR j=7 TO 24:IF tb(j)<0 THEN 670
190   NEXT j:IF tm(i)-td(i)=0 THEN 220
200   jm=tm(i)+1:FOR j=jm TO 6:IF tb(j)<0 THEN 670
210   NEXT j
220   tb(tm(i))=tb(tm(i))+1:tm=tm-1
230   mt=mt+td(i):NEXT i
240   IF mt<ht THEN 720
250   ht=mt:mi=0:bt=0:FOR i=1 TO 24
260   IF tb(i)>0 THEN IF i<19 THEN mi=mi+tb(i)*INT((22-i)/4)/2
270   IF tb(i)<0 THEN IF i>6 THEN mi=mi+tb(i)*INT((i-3)/4)/2
280   NEXT i:mi=mi+3*(tb(0)+tb(25)):IF tb(25)>1 THEN mi=mi+1
290   ct=0:IF tb(25)-tb(0) THEN ct=1:GOTO 340
300   FOR i=24 TO 2 STEP -1:IF tb(i)<0 THEN 320
310   NEXT i:GOTO 340
320   FOR j=i-1 TO 1 STEP -1:IF tb(j)>0 THEN ct=1:GOTO 340
330   NEXT j
340   bl=0
350   IF ct=0 THEN bt=0:GOTO 420
360   hp=0:FOR i=1 TO 24
370   IF tb(i)=-1 THEN bt=bt-INT((30-i)/4)/2:IF i<7 THEN mi=mi-1
380   IF i>18 AND b(i)>1 THEN hp=hp+1
390   NEXT i:hp=hp*hp+(hp=0):bt=INT(bt*hp/25+.5)/2
400   FOR i=1 TO 4:b=0:FOR j=i TO i+5:b=b-(tb(j)<-1):NEXT j
410   b=INT(b*b/4):bl=bl-(b>bl)*(b-bl):NEXT i
420   IF mi+bl+bt<b1+b2+b3 THEN 630
430   tc=0:bo=0:ds=0:lo=1:FOR i=1 TO 24
440   IF i>6 THEN IF tb(i)<0 THEN tc=tc+tb(i)*INT((i-1)/6):bo=bo+i*tb(i)
450   IF tb(i)<0 THEN ds=ds+1:lo=lo*(0-tb(i))
460   NEXT i
470   IF b1=-99999 THEN 600
480   IF bl+mi+bt>b2+b1+b3 THEN 600
490   IF tm<b9 THEN 600
500   IF tm>b9 THEN 630
510   IF tc<b4 THEN 630
520   IF tc>b4 THEN 600
530   IF ds<b6 THEN 630
540   IF ds>b6 THEN 600
550   IF bo<b7 THEN 630
560   IF bo>b7 THEN 600
570   IF lo<b8 THEN 630
580   IF lo>b8 THEN 600
590   GOTO 630
600   b5=nm:b2=bl:b3=bt:b4=tc:b1=mi:b9=tm:b6=ds:bt=bo:b8=lo:j=1-(b5<mm)
610   FOR i=1 TO b5:sm(j)=tm(b5+1-i)
620   sd(j)=td(b5+1-i):j=j+1:NEXT i
630   IF tm(nm)=26 THEN 720
640   tm(nm)=tm(nm)-1
650   IF tm(nm)>0 THEN 50
660   i=nm
670   FOR j=i TO nm:tm(j)=24:NEXT j:i=i-1
680   IF i=0 THEN 720
690   IF tm(i)=26 THEN 720
700   IF tm(i)>1 THEN tm(i)=tm(i)-1:GOTO 50
710   GOTO 670
720   IF d(1)=d(0) THEN 760
730   IF ss=1 THEN 750
740   ss=1:td(1)=d(1):td(2)=d(0):GOTO 50
750   ss=0:td(1)=d(0):td(2)=d(1)
760   nm=nm-1:IF nm=0 THEN 780
770   IF ht=0 THEN 50
780   IF b5<mm THEN sm(1)=27
790   ms=mm:IF b5<mm THEN ms=b5+1
800   m=sm(ms):d=sd(ms):ms=ms-1:IF m=26 THEN m=0
810   IF m=27 THEN GOTO 910
820   mpt=m:GOSUB 2380
830   GOTO 1180
840   os=1:IF d(0)=2 AND d(1)=6 THEN d(0)=6:d(1)=2:os=2
850   sm(2)=op(0,6*d(0)+d(1)-7):sm(1)=op(1,6*d(0)+d(1)-7)
860   sd(2)=d(0):sd(1)=d(1):IF os=2 THEN d(0)=2:d(1)=6
870   IF mm=4 THEN sm(3)=sm(1):sd(3)=sd(1):sm(4)=sm(2):sd(4)=sd(2)
880   IF b(sm(1)-sd(1))>1 THEN 50
890   IF b(sm(2)-sd(2))>1 THEN 50
900   ms=mm:GOTO 800
910   FOR di=0 TO 1:IF d(di)>0 THEN GOSUB 2580
920   NEXT di:RANDOMIZE -1:d(0)=INT(6*RND(1)+1):d(1)=INT(6*RND(1)+1):pl=-pl:mm=2
930   IF d(0)=d(1) THEN mm=4
940   GOSUB 2420:pc=1:IF pl=1 THEN pc=0:GOTO 970
950   IF ms>0 THEN 800
960   IF os=0 THEN 840 ELSE 20
970   m=0:GOSUB 1870:IF mpt=26 THEN 1320
980   IF (b(25)>0 AND mpt<>25) OR mpt=0 OR b(mpt)<1 THEN 970
990   m=mpt:GOSUB 2380
1000  GOSUB 1870:IF mpt=m THEN GOSUB 2410:GOTO 970
1010  IF mpt>24 THEN 1000
1020  IF mpt=0 THEN mpt=25
1030  IF b(mpt)<-1 THEN 1000
1040  IF m=25 THEN d=mpt ELSE d=mpt-m
1050  IF d<1 OR d>6 THEN 1000
1060  di=-1:IF d=d(0) THEN di=0:GOTO 1110
1070  IF d=d(1) THEN di=1:GOTO 1110
1080  IF mpt=25 AND d(0)>d THEN d=d(0):di=0
1090  IF mpt=25 AND d(1)>d THEN d=d(1):di=1
1100  IF di=-1 THEN 1000
1110  IF m=25 THEN 1180
1120  IF m+d<25 THEN 1180
1130  FOR i=1 TO 18:IF b(i)>0 THEN 1000
1140  NEXT i
1150  IF m+d=25 THEN 1180
1160  FOR i=19 TO m-1:IF b(i)>0 THEN 1000
1170  NEXT i
1180  IF d=d(0) THEN di=0 ELSE di=1
1190  IF mm<3 THEN GOSUB 2580
1200  mm=mm-1:po=m:mn=ABS(b(po)):GOSUB 2300:d=d*pl:b(m)=b(m)-pl
1210  IF m=0 OR m=25 THEN m=25-m
1220  IF m+d<1 OR m+d>24 THEN 1290
1230  IF b(m+d)<>-pl THEN 1270
1240  po=m+d:mn=1:pc=1-pc
1250  GOSUB 2300:br=0:IF pl=-1 THEN br=25
1260  b(br)=b(br)-pl:b(m+d)=0:po=br:mn=ABS(b(br)):GOSUB 2270:pc=1-pc
1265  gosub 41000
1270  b(m+d)=b(m+d)+pl:po=m+d:mn=ABS(b(po))
1280  GOSUB 2270:gosub 41000:GOTO 1300
1290  me((pl+1)/2)=me((pl+1)/2)-1:IF me(0)=0 OR me(1)=0 THEN 1440
1300  IF mm=0 THEN 910
1310  GOTO 940
1320  IF b(25)=0 THEN 1350
1330  FOR i=0 TO 1:IF d(i)>0 AND b(d(i))>-2 THEN 970
1340  NEXT i:GOTO 910
1350  FOR i=0 TO 1:IF d(i)=0 THEN 1380
1360  FOR j=1 TO 24-d(i):IF b(j)>0 AND b(j+d(i))>-2 THEN 970
1370  NEXT j
1380  NEXT i:FOR j=1 TO 18:IF b(j)>0 THEN 910
1390  NEXT j:FOR i=0 TO 1:IF d(i)>0 AND b(25-d(i))>0 THEN 970
1400  NEXT i:FOR i=19 TO 24:IF b(i)>0 THEN 1420
1410  NEXT i:GOTO 910
1420  FOR j=0 TO 1:IF d(j)>0 AND d(j)>25-i THEN 970
1430  NEXT j:GOTO 910
1440  FOR di=0 TO 1:IF d(di)>0 THEN GOSUB 2580
1450  NEXT di
1460  pena 4
1470  IF me(0)=0 THEN msg$="I win " ELSE msg$="You win "
1480  IF me(0)<15 AND me(1)<15 THEN 1520
1490  IF b(0)<>0 OR b(25)<>0 THEN msg$=msg$+" WITH A BACKGAMMON":GOTO 1520
1500  FOR i=1 TO 6:IF b(i)>0 OR b(25-i)<0 THEN msg$=msg$+" WITH A BACKGAMMON":GOTO 1520
1510  NEXT i:msg$=msg$+" WITH A GAMMON"
1520  middle=(len(msg$)/2)*8:? at((18*8)-middle,183);msg$
1525  gosub 37000
1530  GOSUB 1870:GOTO 1720
1540  SCREEN 0,5:graphic 1:drawmode 0
1550  font 1:DIM regsave%(100):bload "pic_dat",VARPTR(regsave%(0)):GOSUB 30000
1560  dim picture%(11000):bload "pic",varptr(picture%(0))
1565  dim dice1%(200),dice2%(200),dice3%(200),dice4%(200),dice5%(200),dice6%(200)
1570  bload "dice1",varptr(dice1%(0)):bload "dice2",varptr(dice2%(0)):bload "dice3",varptr(dice3%(0))
1575  bload "dice4",varptr(dice4%(0)):bload "dice5",varptr(dice5%(0)):bload "dice6",varptr(dice6%(0))
1590  REM
1600  pena 7:PRINT  at(12*8,1*8);"AMIGA BACKGAMMON":PRINT 
1610  pena 8:? "     Amiga Version by David Addison":pena 9:? "       Original ST Version by TCB":?
1620  pena 4:PRINT  "  You will play the white pieces and ":? "move clockwise from the upper left."
1630  PRINT :PRINT  "  To move a piece, click on piece ":? "to be moved and then";
1640  PRINT  " click on the":PRINT  "destination point."
1650  PRINT :PRINT  "  To bear off use the GOLD bar on the ":? "left as the destination."
1660  PRINT :PRINT  "  If you do not have a valid move":? "click on the dice."
1670  PRINT :PRINT  "  To end the game click on ""A"""
1680  pena 11:PRINT  at(5*8,22*8);"Click mouse button to start."
1690  GOSUB 2700:REM v=rnd(-xc*yc)
1700  rem
1710  DIM b(25),tb(25),me(1),op(1,35),sm(4),sd(4),d(1),td(4),tm(4),sinewave%(11)
1720  FOR i=0 TO 25:b(i)=0:NEXT i
1730  b(1)=2:b(6)=-5:b(8)=-3:b(12)=5:b(13)=-5:b(17)=3:b(19)=5:b(24)=-2
1740  me(0)=15:me(1)=15
1750  ms=0:os=0
1760  RESTORE:FOR i=0 TO 35:READ x,y:op(0,i)=x:op(1,i)=y:NEXT i
1765  for i=0 to 11:read sinewave%(i):next i
1766  audio 15,1:wave 6,sinewave%
1770  GOSUB 1990
1780  RANDOMIZE -1:FOR i=0 TO 1:d(i)=INT(6*RND(1)+1):NEXT i:IF d(0)=d(1) THEN 1780
1790  pl=-1:mm=2:IF d(0)>d(1) THEN pl=1
1800  GOTO 940
1810  DATA 8,6,6,13,6,8,6,13,6,13,8,13
1820  DATA 13,6,13,6,13,13,6,8,13,13,0,0
1830  DATA 8,6,13,13,13,8,13,13,8,13,13,13
1840  DATA 13,6,8,6,13,13,13,9,13,13,13,13
1850  DATA 13,6,13,13,13,8,13,13,13,8,13,13
1860  DATA 13,8,13,7,13,13,13,13,13,13,24,13
1865  data 100,90,60,100,90,60,-100,-90,-60,-100,-90,-60
1870  GOSUB 2700:REM if button>1 then goto 1870
1880  IF yc<3 OR yc>169 OR xc>298 THEN GOTO 1870
1890  IF xc<5 THEN mpt=0:RETURN
1900  IF xc<144 THEN 1960
1910  IF xc>159 THEN 1940
1920  IF yc>98 THEN mpt=25:RETURN
1930  IF yc>73 THEN goto 40000 ELSE GOTO 1870
1940  IF yc>73 AND yc<98 THEN GOTO 1870
1950  xc=xc-18:GOTO 1970
1960  IF yc>73 AND yc<98 THEN mpt=26:RETURN
1970  xc=xc-4:ptx=xc\23:IF yc>98 THEN mpt=24-ptx ELSE mpt=ptx+1
1980  RETURN
1990  scnclr:outline 0:gshape(0,0),picture%()
2000  rem
2010  rem
2020  rem
2030  rem
2040  rem
2050  rem
2060  rem
2070  rem
2080  rem
2085  rem
2090  FOR po=0 TO 25
2100  IF b(po)=0 THEN 2130
2110  pc=1+(b(po)>0)
2120  FOR mn=1 TO ABS(b(po)):GOSUB 2270:NEXT mn
2130  NEXT po
2140  RETURN
2150  REM
2160  IF po<13 THEN pox=po-1 ELSE pox=24-po
2170  x=16+pox*23:IF pox>5 THEN x=x+18
2180  IF po=0 OR po=25 THEN x=151
2190  IF po<13 THEN y1=3:y2=73:yd=1 ELSE y1=169:y2=99:yd=-1
2200  y0=y1+yd*6
2210  IF po MOD 2 THEN pi1=7 ELSE pi1=9
2220  RETURN
2230  GOSUB 2150
2240  mx=x:if mn<6 then radius=6 else radius=6
2250  my=y0+yd*13*((mn-1) MOD 5):if mn>5 then my=y0+yd*13*((6-1) mod 5)
2260  RETURN
2270  GOSUB 2230
2275  rem if mn>5 then gosub 25000:goto 2290
2280  peno (1-pc)+5:CIRCLE(mx,my),radius:pena pc+5:PAINT(mx-5,my),0
2285  if mn>5 then gosub 25000:goto 2290
2290  RETURN
2300  REM
2310  GOSUB 2230
2320  peno 8:CIRCLE(mx,my),radius:pena 8:PAINT(mx,my),0
2330  IF po=0 OR po=25 THEN pena 11:GOTO 2350
2340  pena 15:draw(x-12,y1 TO x,y2):draw(x,y2 TO x+12,y1):pena pi1
2350  peno 15:PAINT(mx,my),1
2360  if mn>1 then for mn=1 to mn-1:gosub 2270:next mn
2370  RETURN
2380  mn=ABS(b(mpt)):po=mpt:GOSUB 2230
2382  qq=sound(1,1,5,64,3000):qq=sound(2,1,5,64,6000)
2385  qq=1:if pl=1 then qq=5
2390  pena 16:paint(mx-5,my),1
2392  pena 8:paint(mx-5,my),1
2395  qq=qq+1:if qq<5 then 2390
2400  return
2410  po=mpt:mn=b(mpt):GOSUB 2270:RETURN
2420  IF pl=1 THEN dx=46 ELSE dx=202
2425  sleep(.5*10^6):randomize -1
2430  FOR dj=0 TO 1:xd=dx+dj*33:IF d(dj)=0 THEN 2460
2440  rem
2450  ON d(dj) GOSUB 2520,2530,2540,2550,2560,2570
2460  NEXT dj
2470  RETURN
2520  gshape(xd,75),dice1%():return
2530  gshape(xd,75),dice2%():return
2540  gshape(xd,75),dice3%():return
2550  gshape(xd,75),dice4%():return
2560  gshape(xd,75),dice5%():return
2570  gshape(xd,75),dice6%():return
2580  REM
2590  IF pl=1 THEN dx=46 ELSE dx=202
2600  xd=dx+di*32
2610  pena 8:peno 8:area (xd,75 to xd+25,75 to xd+25,97 to xd,97)
2640  d(di)=0
2650  return
2700  REM
2720  ask MOUSE xc%,yc%,b%
2730  IF b%=4 THEN 2720
2740  ask MOUSE xc%,yc%,b%
2760  IF b%=0 THEN 2740
2770  xc=xc%:yc=yc%:button=b%:RETURN
25000 drawmode 0
25010 if pl=1 then pena 5:peno 5 else pena 6:peno 6
25015 area(mx-3,my+3 to mx+3,my+3 to mx+3,my-3 to mx-3,my-3):drawmode 0
25018 if pl=1 then pena 6:penb 5 else pena 5:penb 6
25020 ? at(mx-11,my+3);mn-4
25030 drawmode 0:return
30000 cnt=0:i=0
30010 rgb i,regsave%(cnt),regsave%(cnt+1),regsave%(cnt+2):cnt=cnt+3
30030 i=i+1:IF i<32 THEN 30010
30040 RETURN
37000 for qq=1 to 40
37005 ask rgb 7,r%,g%,b%
37010 for i%=9 to 7 step -2
37020 ask rgb i%,r1%,g1%,b1%
37030 rgb i%,r%,g%,b%
37040 r%=r1%:g%=g1%:b%=b1%
37045 sleep(50000)
37050 next i%
37060 next qq
37070 return
40000 scnclr:rgb 31,0,0,0:system
41000 qq=sound(1,1,5,64,500):qq=sound(2,1,5,64,1000):return
