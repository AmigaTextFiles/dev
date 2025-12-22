10    ' ************************************
12    ' **                                **
13    ' **           MILE STONE           **
14    ' **           ----------           **
15    ' **        AMIGA VERSION BY        **
16    ' **         David  Addison         **
17    ' **                                **
18    ' **            C   1986            **
19    ' **                                **
20    ' ************************************
21    ' ************************************
75    clr:SCREEN 0,5:graphic 1:drawmode 1
80    DIM picture%(11000),regsave%(100),mplay%(200),mdiscard%(200),mblank%(200) 
85    bload "milestone_pic",VARPTR(picture%(0))
87    bload "milestone_dat",VARPTR(regsave%(0)):bload "milestone-P",VARPTR(mplay%(0))
89    bload "milestone-D",VARPTR(mdiscard%(0))
90    GOSUB 10000
93    gshape (0,0),picture%():sshape (65,12;85,20),mblank%()
110   e=106:red=19:yellow=26:green=8:brown=30:dblue=28:mblue=8:purp=21
115   bk0=2:bk1=8:bk2=10:bk3=13:bk4=14:bk5=29
120   DIM s(7),c(e),t$(20),pl(1,3),h(1,7),t1(4),t2(4,5),tb(1),qq(1),safety(1,5),sinewave%(11)
140   DATA OUT OF GAS,FLAT TIRE,ACCIDENT,SPEED LIMIT(50),STOP
150   DATA GAS,SPARE TIRE,REPAIRS,END SPEED LIMIT,ROLL
160   DATA EXTRA TANK,PERMANENT TIRE,DRIVING ACE,R,RIGHT-OF-WAY
170   DATA 200,100,75,50,25
180   nm$="HAZARD    REMEDY    SAFETY    DISTANCE  "
185   bl$="               ":bl0$="                                 "
187   FOR n=1 TO 20
190   READ t$(n)
195   NEXT n
200   DATA 18,56,60,106,4,7,10,14,19,25,31,37,43,57,58,59,60,60,61,65,77,87,97,107
210   FOR i=1 TO 4:READ t1(i):NEXT i
220   FOR i=1 TO 4:FOR j=1 TO 5
230   READ t2(i,j):NEXT j:NEXT i
235   data 100,90,60,100,90,60,-100,-90,-60,-100,-90,-60
236   for kk%=0 to 11:read sinewave%(kk%):next kk%:audio 15,1:wave 6,sinewave%
240   g=0:FOR i=1 TO e:c(i)=i:NEXT i:s(0)=0:s(1)=0:play=1
250   graphic 1:pena dblue:penb bk0:PRINT  at(2*8,6); "SHUFFLING...":GOSUB 740:GOSUB 820:sleep(100000)
260   FOR i=0 TO 1:FOR j=0 TO 3:pl(i,j)=0:NEXT j:tb(i)=10:qq(i)=6:NEXT i
265   FOR i=0 TO 1:FOR j=1 TO 5:safety(i,j)=0:NEXT j:NEXT i
270   FOR i=0 TO 1:FOR j=1 TO 6
280   cn=cn+1:h(i,j)=c(cn):NEXT j:NEXT i
290   LOCATE (0,6+4*8):pena brown:penb bk1
300   FOR a=1 TO 6:c=h(1,a):GOSUB 780:PRINT AT(2*8,6+(3+a)*8);n$:NEXT a
310   p=1:cn=cn+1:IF cn>e THEN s=s+1:IF s>6 THEN n$="NOBODY":GOTO 1740
320   IF s>0 THEN 360
325   pena purp:penb bk5:locate(270,75):print using "###";106-cn
330   c=c(cn):h(1,0)=c:GOSUB 780:pena brown:penb bk1
340   PRINT  at(2*8,6+3*8);bl$
350   PRINT  at (2*8,6+3*8);n$
360   pena mblue:penb bk0:PRINT at(1*8,6),bl0$:PRINT  at (2*8,6); "YOUR MOVE":flag=0 
370   GOSUB 9000:pena brown:penb bk1
380   GOSUB 5000:storey%=4+s
385   ask MOUSE x%,y%,b%
390   IF y%<6 OR y%>19 OR x%<0 OR x%>163 THEN 385
395   IF y%>11 AND y%<20 AND x%>5 AND x%<50 AND b%=4 THEN gshape (65,12),mplay%():play=1:GOTO 402
400   IF y%>11 AND y%<20 AND x%>100 AND x%<164 AND b%=4 THEN gshape (65,12),mdiscard%():play=0:GOTO 402
402   if b%<>4 then 385
403   ask mouse x%,y%,b%:if b%<>0 then 403
405   cur%=INT(y%/8):IF cur%<3+s OR cur%>9 THEN 411
407   IF cur%<>storey% and s<>6 THEN c=h(1,storey%-3):GOSUB 780:PRINT at(8*2,6+(storey%)*8);n$;
409   IF cur%<>storey% or s=6 THEN c=h(1,cur%-3):GOSUB 780:PRINT at(8*2,6+(cur%)*8);inverse(1) n$;:storey%=cur% 
411   ask MOUSE x%,y%,b%
412   IF y%<6 OR y%>80 OR x%<0 OR x%>163 THEN 411
414   IF b%=4 THEN 418
416   GOTO 405
418   n=cur%-3
419   print at(8*2,6+(storey%)*8);n$;
420   gshape (65,12),mblank%()
422   if n<s or n>6 then 360
430   IF play=0 THEN GOSUB 920:GOSUB 900:GOTO 460
440   GOSUB 880
450   IF ch=0 THEN penb bk0:pena red:PRINT  ",OK ";
451   if ch=0 then ask mouse x%,y%,b%:if b%=0 then 451
452   if ch=0 then ask mouse x%,y%,b%:if b%=4 then 452 else goto 360
460   penb bk1:PRINT at(2*8,6+(3+s)*8);bl$
470   IF pl(1,0)=1000 THEN n$="YOU":GOTO 1740
480   d$="PLAY"
490   pena dblue:penb bk0:PRINT at(1*8,6),bl0$
500   PRINT  at (2*8,6); "THINKING....":p=0:cn=cn+1:flag=0:sleep(50000)
510   GOSUB 8000
520   IF s=0 THEN h(0,0)=c(cn):pena purp:penb bk5:locate(270,75):print using "###";106-cn
530   hz=pl(0,2):IF hz>-1 AND pl(0,1)>-1 THEN 600
540   GOSUB 1470:IF cf THEN safety(0,m)=1:pl(0,cf)=m:s(2)=s(2)+300
550   IF cf THEN s(4)=s(4)+100:GOTO 720
560   IF s OR pl(1,0)>790 OR pl(0,0)>790 THEN GOSUB 1680:IF sf THEN 720
570   GOSUB 1430:IF ch THEN pl(0,ch)=m:GOTO 720
580   IF pl(0,2)>-1 THEN 600
590   GOTO 680
600   IF pl(0,2)<5 THEN 670
610   lm=201:IF pl(0,1)<0 THEN lm=51
620   IF lm<200 AND pl(0,0)<900 THEN GOSUB 1400:IF ch THEN pl(0,1)=4:GOTO 720
630   ch=0:d=0:FOR a=s TO 6:c=h(0,a):GOSUB 780:b=VAL(n$):IF b=0 THEN 650
640   IF b<lm AND (b+pl(0,0)<1001) AND b>d THEN d=b:n=a:ch=1
650   NEXT a:IF ch THEN pl(0,0)=pl(0,0)+d:GOTO 720
660   GOTO 680
670   GOSUB 1530:IF ch AND (pl(0,2)>-1) THEN pl(0,2)=5:GOTO 720
680   IF pl(1,2)<0 AND pl(1,1)<0 THEN 710
690   GOSUB 1330:IF ch=1 AND pl(1,0)<950 THEN pl(1,1)=-4:GOTO 720
700   IF ch=2 AND pl(1,2)=5 THEN pl(1,2)=-m:GOTO 720
710   GOSUB 1550
720   GOSUB 1800:IF pl(0,0)=1000 THEN n$="I":GOTO 1740
730   GOSUB 2100:GOTO 310
740   cn=0:en=e+1:s=0:randomize -1
750   FOR i=2 TO 5:s(i)=0:NEXT i
760   FOR i=1 TO e:r=INT(i+(en-i)*RND(8)):t=c(i):c(i)=c(r):c(r)=t
770   NEXT i:RETURN
780   FOR i=1 TO 4:FOR j=1 TO 5
790   IF c>t1(i) THEN j=5:GOTO 810
800   IF c<t2(i,j) THEN start=((i-1)*5+1)+((j-1)):n$=t$(start):k=i:l=j:i=4:j=5
810   NEXT j:NEXT i:RETURN
820   REM
870   RETURN
880   c=h(1,n):GOSUB 780:GOSUB 960:p=1
890   IF ch=0 THEN pena dblue:penb bk0:print at(1*8,6);bl0$:PRINT at(2*8,6);ms$;:RETURN
900   GOSUB 950:j=n+5+6*(1-p):pena brown:penb bk1:GOSUB 2090:PRINT bl$
905   IF n=0 THEN c=h(p,n):GOSUB 780:RETURN
910   pena brown:penb bk1:ask cursor hor%,vert%:c=h(p,n):GOSUB 780:PRINT  at(2*8,(vert%-8));n$:RETURN
920   c=h(p,n):GOSUB 780
930   pena dblue:penb bk2:PRINT at(22*8,3+6*8);"               ":GOSUB 6000
935   ln=29-Int(len(n$)/2):? at(ln*8,3+6*8);n$
940   LOCATE (0,6):RETURN
950   h(p,n)=h(p,s):RETURN
960   p=1:ms$="":ON k GOTO 1040,1120,1240,970
970   d=VAL(n$):IF pl(1,0)+d>1000 THEN ms$="YOU HAVE EXCEEDED 1000"
980   IF pl(1,1)=-4 AND d>50 THEN start=((1-1)*5+1)+((4-1)):ms$="YOU HAVE A "+t$(start)
990   IF pl(1,2)<5 THEN ms$="YOU DON'T HAVE A ROLL CARD"
1000  IF pl(1,2)<0 THEN ms$="YOU HAVE A HAZARD"
1010  IF ms$<>"" THEN ch=0:RETURN
1020  pl(1,0)=pl(1,0)+d:ch=1:pena 3:penb bk3
1030  n$=STR$(pl(1,0)):LOCATE(33*8,6+11*8):PRINT USING "####";pl(1,0):ch=1:gosub 4000:RETURN
1040  IF l<>4 AND pl(0,2)<5 THEN ms$="I DON'T HAVE A ROLL CARD"
1050  IF l<>4 AND pl(0,2)<0 THEN ms$="I ALREADY HAVE A HAZARD"
1060  IF l=4 AND pl(0,1)<0 THEN ms$="I HAVE A SPEED LIMIT"
1070  IF l=4 AND safety(0,5)=1 THEN start=((3-1)*5+1)+((5-1)):ms$="I HAVE "+t$(start)
1080  IF safety(0,l)=1 THEN ms$="HA!-I HAVE THE SAFETY"
1090  IF ms$<>"" THEN ch=0:RETURN
1100  IF l<>4 THEN pl(0,2)=-l:j=21:pena red:penb bk4:GOTO 1220
1110  ch=1:pl(0,1)=-4:j=20:pena yellow:penb bk4:GOTO 1220
1120  IF l<>5 THEN 1170
1130  IF pl(1,2)=5 THEN ms$="YOU HAVE A ROLL CARD"
1140  IF pl(1,2)<0 THEN ms$="YOU HAVE A HAZARD":IF pl(1,2)=-5 THEN ms$=""
1150  IF ms$<>"" THEN ch=0:RETURN
1160  pl(1,2)=5:pena green:penb bk3:GOTO 1210
1170  IF l=4 AND pl(1,1)=-4 THEN pl(p,1)=4:j=14:pena green:penb bk3:GOTO 1220
1180  IF pl(1,2)<>-l THEN ms$="YOU DON'T NEED TO DO THAT"
1190  IF ms$<>"" THEN ch=0:RETURN
1200  pl(p,2)=l:pena yellow
1210  j=15:penb bk3
1220  GOSUB 2090:print at(11*8,vert%);bl$;:PRINT at(11*8,vert%);n$
1230  ch=1:RETURN
1240  p=1:cf=0:IF pl(1,2)=-l THEN pl(1,2)=l:cf=1
1250  IF l=5 AND pl(1,1)<0 THEN cf=1
1260  s(5)=s(5)+100:safety(1,l)=1
1270  IF cf THEN pena red:penb bk0:print at(1*8,6);bl0$:PRINT at(2*8,6);inverse(1) " COUP FOURRE ":?:s(3)=s(3)+300:GOSUB 7000
1280  IF l=5 THEN 1285
1282  GOTO 1290
1285  safety(p,4)=1:safety(p,5)=1:pl(p,1)=4:j=20-6*p
1286  IF p=0 THEN pena green:penb bk4
1287  IF p=1 THEN pena green:penb bk3
1288  GOSUB 2090
1289  start=((2-1)*5+1)+((4-1)):ask cursor horz%,vert%:PRINT at(11*8,vert%);t$(start)
1290  fs$=mid$(n$,1,1):j=0:IF p=1 THEN j=6
1291  if fs$="R" then x=10:y=20
1292  if fs$="E" then x=25:y=20
1293  if fs$="P" then x=10:y=21
1294  if fs$="D" then x=25:y=21
1295  pena red:penb 11:PRINT  at(x*8,6+((y-j)*8)); n$:?:LOCATE(2*8,6):flag=1
1310  IF cf AND pl(p,2)=l THEN 1315
1311  GOTO 1320
1315  IF p=0 THEN pena yellow:penb bk4
1316  IF p=1 THEN pena yellow:penb bk3
1317  j=21-6*p:GOSUB 2090:start=((2-1)*5+1)+(l-1):? at(11*8,vert%);bl$:PRINT  at(11*8,vert%);t$(start):LOCATE(2*8,6)
1320  cf=0:ch=1:RETURN
1330  ch=0:FOR a=s TO 6:c=h(0,a):GOSUB 780
1340  IF k<>1 THEN 1390
1350  IF l=4 AND pl(1,1)>-1 THEN ch=1:m=l:n=a
1360  IF l<>4 AND pl(1,2)>0 THEN ch=2:m=l:n=a
1370  IF safety(1,l)=1 THEN ch=0
1380  IF ch THEN a=6
1390  NEXT a:RETURN
1400  ch=0:FOR a=s TO 6
1410  c=h(0,a):GOSUB 780:IF k=2 AND l=4 THEN ch=1:n=a:a=6
1420  NEXT a:RETURN
1430  ch=0:FOR a=s TO 6:c=h(0,a):GOSUB 780
1440  IF k=2 AND l=-hz THEN ch=2:m=l:n=a:a=6:GOTO 1460
1450  IF k=2 AND l=4 AND pl(0,1)=-4 THEN ch=1:m=l:n=a
1460  NEXT a:RETURN
1470  sf=0:cf=0:FOR a=s TO 6:c=h(0,a):GOSUB 780:IF k<>3 THEN 1520
1480  IF pl(0,1)<0 AND l=5 THEN cf=1
1490  sf=sf+INT(2^(l-1)+.5):m=l:n=a:IF l=-hz THEN cf=2
1500  IF l=5 THEN sf=sf+8
1510  IF cf THEN a=6
1520  NEXT a:RETURN
1530  ch=0:FOR a=s TO 6:c=h(0,a):GOSUB 780:IF k=2 AND l=5 THEN ch=1:n=a:a=6
1540  NEXT a:RETURN
1550  d$="DISCARD":FOR a=s TO 6:c=h(0,a):GOSUB 780
1560  IF k=1 AND safety(0,l)=1 THEN 1730
1570  IF k=1 AND l=4 AND pl(1,0)>949 THEN 1730
1580  IF k=2 AND (safety(0,l)=1 OR sf) THEN 1730
1585  REM
1590  IF VAL(n$)<>0 THEN IF k=4 AND VAL(n$)>(1000-pl(0,0)) THEN 1730
1600  NEXT a
1610  FOR a=s TO 6:c=h(0,a):GOSUB 780
1615  REM
1620  IF VAL(n$)<>0 THEN IF k=4 AND VAL(n$) AND VAL(n$)<76 THEN 1730
1630  NEXT a
1640  FOR a=s TO 6:c=h(0,a):GOSUB 780
1650  IF k=1 AND (safety(0,l) OR sf)=0 THEN 1730
1660  IF k=2 AND l<5 AND safety(1,l)=0 THEN 1730
1670  NEXT a
1680  GOSUB 1470
1690  IF sf THEN safety(0,m)=1:d$="PLAY":s(4)=s(4)+100:RETURN
1700  randomize -1:n=INT((7-s)*RND(8))+s:IF s THEN RETURN
1710  c=h(0,n):GOSUB 780:IF VAL(n$)=0 THEN 1720 ELSE IF VAL(n$)>100 THEN 1700
1720  RETURN
1730  n=a:a=6:RETURN
1740  pena green:penb bk0:print at(1*8,6);bl0$:PRINT  at(2*8,6);n$;" REACHED 1000 MILES!!..."
1745  if pl(1,0)=1000 then gosub 11000 else sleep(3000000)
1750  pena dblue:PRINT  at(2*8,6);bl0$:PRINT  at(2*8,6);"NEXT ROUND (Y/N)  ";:getkey n$
1760  GOSUB 1920:IF s(0)>5000 OR s(1)>5000 OR n$="n" OR n$="N" THEN PRINT :PRINT :PRINT TAB(3);"GAME OVER":GOTO 1780
1770  PRINT  TAB(3);"OK  ?";:getkey n$:gshape(0,0),picture%():GOTO 250
1780  PRINT  TAB(3);"NEW GAME  (Y/N) ?";:getkey n$:IF n$="y" OR n$="Y" THEN gshape(0,0),picture%():GOTO 240
1790  scnclr:clr:graphic 0:drawmode 0:END
1800  p=0:c=h(0,n):GOSUB 780
1810  REM
1811  REM
1812  REM
1815  pena mblue:penb bk0:print at(1*8,6);bl0$:print at(1*8,6);"I WILL ";:pena red:print d$;
1816  pena mblue:print " A ";:pena dblue:print n$;:pena mblue:print " CARD";
1817  sleep(1000000)
1820  p=0
1830  IF LEN(d$)>6 THEN GOSUB 930:GOSUB 950:RETURN
1840  IF cf THEN pena red:penb bk0:PRINT  at(1*8,6);bl0$:PRINT  at(2*8,6);inverse(1) " COUP FOURRE ":?:GOSUB 7000
1850  LOCATE(2*8,6):IF k=4 THEN ch=0:pena 3:penb bk4:LOCATE(33*8,6+17*8):PRINT USING "####";pl(0,0):gosub 950:gosub 4000:return
1860  ch=0:IF k=3 THEN j=22:ch=1
1870  IF k=2 THEN j=21:IF l=4 THEN j=20
1875  IF j=20 THEN pena mblue
1876  IF j=21 AND l=5 THEN pena mblue
1877  IF j=21 AND l<>5 THEN pena yellow
1880  IF k=1 THEN j=15:IF l=4 THEN j=14
1885  IF j=15 THEN pena red
1886  IF j=14 THEN pena yellow
1888  IF j<17 THEN penb bk3 ELSE penb bk4
1890  GOSUB 2090:locate(11*8,vert%)
1900  IF ch THEN GOSUB 1280:GOSUB 950:RETURN
1910  PRINT  bl$;:PRINT at(11*8,vert%);n$:LOCATE(0,6):GOSUB 950:RETURN
1920  graphic 0:scnclr:pena brown:penb 0
1925  g=g+1:PRINT at(0,0);"SCORES FOR ROUND: ";g
1930  PRINT :PRINT  at(20,2);inverse(1) " ME ";inverse(0):PRINT  at(29,2);inverse(1) " YOU ";inverse(0):PRINT 
1940  PRINT  "DISTANCE":? at(19,4);" ";:? using "####";pl(0,0):? at(29,4);" ";:? using "####";pl(1,0)
1950  s(6)=pl(0,0):s(7)=pl(1,0)
1960  PRINT  "COMPLETE TRIP"
1970  if s(6)=1000 then ? at(19,5);" ";:print using "####";val("400"):s(6)=s(6)+400
1980  IF s(7)=1000 THEN ? at(29,5);" ";:? using "####";val("400"):s(7)=s(7)+400
1990  PRINT  "COUP FOURRES":? at(19,6);" ";:? using "####";s(2):? at(29,6);" ";:? using "####";s(3)
2000  s(6)=s(6)+s(2):s(7)=s(7)+s(3)
2010  PRINT  "SAFETIES":? at(19,7);" ";:? using "####";s(4):? at(29,7);" ";:? using "####";s(5)
2020  s(6)=s(6)+s(4):s(7)=s(7)+s(5)
2030  PRINT  "SHUT OUT":IF pl(1,0)=0 THEN ? at(19,8);" ";:? using "####";val("500"):s(6)=s(6)+500
2040  IF pl(0,0)=0 THEN ? at(29,8);" ";:? using "####";val("500"):s(7)=s(7)+500
2050  PRINT :PRINT  "ROUND ";g;" TOTAL":? at(18,10);" ";:? using "#####";s(6):? at(28,10);" ";:? using "#####";s(7)
2060  s(0)=s(0)+s(6):s(1)=s(1)+s(7)
2070  PRINT :PRINT  "GRAND TOTAL":? at(18,12);" ";:? using "#####";s(0):? at(28,12);" ";:? using "#####";s(1)
2080  RETURN
2090  LOCATE(0,6):LOCATE(2*8,6+(j-2)*8)
2091  IF j<12 OR (j=13 OR j=16 OR j=17) OR (j=19 OR j=22 OR j=23) THEN 2095
2092  PRINT  at(11*8,6+(j-2)*8);bl$:LOCATE(2*8,6+(j-2)*8)
2095  IF j>12 THEN GOSUB 6000
2096  ask cursor horz%,vert%:RETURN
2100  FOR t=1 TO 200:NEXT t:RETURN
2840  RETURN
4000  for kk%=1 to int(d/10)
4010  cx%=sound(1,1,3,65,int(rnd*700)+700):cx%=sound(2,1,3,65,int(rnd*1000)+1000)
4015  sleep(30000)
4020  next kk%
4030  return
5000  return
6000  randomize -1
6010  note1%=(rnd(8)*1000)+100:note2%=note1%+100
6020  cx%=sound(1,1,100,65,note1%):sleep(10000):cx%=sound(2,1,100,65,note2%)
6040  return
7000  for jj%=1 to 4
7005  for kk%=5000 to 100 step -300
7010  cx%=sound(1,1,50,65,kk%):cx%=sound(2,1,50,65,kk%)
7015  sleep(10000)
7020  next kk%
7025  next jj%
7030  return
8000  IF safety(1,5)=1 AND pl(1,2)>-1 THEN pl(1,2)=5:j=15:pena mblue:penb bk3:PRINT  at(11*8,6+(j-2)*8);"ROLL           "
8010  RETURN
9000  IF safety(0,5)=1 AND pl(0,2)>-1 THEN pl(0,2)=5:j=21:pena mblue:penb bk4:PRINT  at(11*8,6+(j-2)*8);"ROLL           "
9010  RETURN
10000 cnt=0
10010 FOR i%=0 TO 31:rgb i%,regsave%(cnt),regsave%(cnt+1),regsave%(cnt+2):cnt=cnt+3:NEXT i%
10020 RETURN
11000 for t=1 to 30
11005 ask rgb 4,r%,g%,b%
11010 for i%=31 to 4 step -1
11020 ask rgb i%,r1%,g1%,b1%
11030 rgb i%,r%,g%,b%
11040 r%=r1%:g%=g1%:b%=b1%
11050 sleep(100)
11060 next i%
11070 next t
11080 gosub 10000:return
