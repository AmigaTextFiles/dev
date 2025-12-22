1     ' CANFIELD SOLITAIR by David Addison  ©1986
2     ' This program is in the Public Domain
3     '
4     '
5     clr:SCREEN 1,3:scnclr:graphic 1
8     PRINT :PRINT  SPC(23);"******  CANFIELD  SOLITAIR  ******":PRINT :PRINT  SPC(23);"        by   David Addison"
10    PRINT :PRINT :PRINT :PRINT  SPC(8);"   Click directly on card to put in Foundation, above or below"
11    PRINT  SPC(8);"will pick cards up.  If card can't be played on Foundation the"
12    PRINT  SPC(8);"cards will be picked up."
13    PRINT :PRINT  SPC(8);"   Click on back of card in lower left corner to draw from deck."
14    ?:? spc(8);"   Cards in the foundations wraparound. EX:(J,Q,K,A,2,3,etc.)"
15    ?:? spc(8);"   Holes will be filled by the stock.  When stock is gone then":? spc(8);"you may fill holes with any card from the talon."
16    ?:? spc(8);"   You may play the cards in the stock, just as you would from":? spc(8);"the talon."
17    ?:?:? spc(24);"******  PLEASE   STANDBY  ******":gosub 28000
18    sleep(5*10^6):RESTORE:GOTO 1110
20    WAVE 256,timbre1%():FOR az=0 TO 64 STEP 20:qq=SOUND(1,1,1,az,800):qq=SOUND(2,1,1,az,500):NEXT az:REM **** DRAW CARD ****
23    c=va:ON su GOTO 36,46,24,28
24    gshape(x,y),diamond%():pena 6:GOTO 56
28    gshape(x,y),heart%():pena 6:GOTO 56
36    gshape(x,y),spade%():pena 4:GOTO 56
46    gshape(x,y),club%():pena 4
56    PRINT  at(x+2,y+9);MID$(c$,c,1):PRINT  at(x+51,y+45);MID$(c$,c,1):GOSUB 15000:RETURN
70    su=INT(num/100)
80    va=num-100*su
90    RETURN
100   IF hf=1 THEN GOSUB 1480:RETURN
110   IF left=0 THEN RETURN  
111   IF in>51 THEN GOSUB 1490:GOSUB 130
112   FOR i=1 TO 3
114   IF in>51 AND i>1 THEN 122
115   IF in>51 AND i=1 THEN GOSUB 1490:GOSUB 130:GOTO 112
116   IF d(in)=0 THEN in=in+1:GOTO 114
118   od(in(1),0)=d(in):od(in(1),1)=in:in(1)=in(1)+1:in=in+1
119   x=x(1):y=(in(1)*4)-2:let num=od(in(1)-1,0):gosub 70:gosub 20
120   NEXT i
122   if i<3 then x=x(1):y=(in(1)*4)-2:LET num=od(in(1)-1,0):GOSUB 70:GOSUB 20
123   if i<4 or (in=4 and in=52) then pena 0:peno 5:x=x(0):y=141:box(x,y;x+60,y+44),1
124   RETURN
130   gshape(x(0),139),back%()
135   FOR j=0 TO 33:FOR az=0 TO 1:od(j,az)=0:NEXT az:NEXT j:in=17:in(1)=0:RETURN
150   '
188   REM
189   REM if cu<7 then ? at(13,17);chr$(left(cu));
190   RETURN
280   IF hf=1 THEN GOSUB 1480:RETURN
290   st=cu
300   IF in(cu)=0 THEN GOSUB 1510:RETURN
310   IF cu=1 THEN LET num=od(in(1)-1,0):GOTO 330
320   LET num=c(cu,0)
330   hf=1
335   if cu=8 then j=44:goto 350
340   IF cu=1 THEN 390
341   j=y(in(cu)-1)+52
350   FOR i=y(0)+j TO y(0) STEP -4:gshape(x(cu),i),blank%():NEXT i:GOSUB 150
390   IF cu=1 THEN FOR i=(in(1)*4)+56 TO (in(1)*4)-4 STEP -4:gshape(x(1),i),blank%():NEXT i
391   IF cu=8 THEN gosub 27500:GOTO 394
392   j=0:IF cu=1 THEN IF in(1)-1>0 THEN LET num=od(in(1)-2,0):GOSUB 70:x=x(1):y=((in(1)-1)*4)-2:GOSUB 20:GOTO 400
394   IF cu=8 THEN sleep(.2*10^6):LET num=c(8,in(8)-2):GOSUB 70:x=x(8):y=y(2):GOSUB 20:GOTO 400
395   FOR i=y(j)+52 TO y(j) STEP -4:gshape(x(cu),i),blank%():NEXT i:GOTO 399
399   '
400   GOSUB 14000:RETURN
410   IF hf=0 THEN GOSUB 1520:RETURN
420   IF cu=1 THEN GOSUB 590:RETURN
425   IF cu=8 THEN GOSUB 625:RETURN
430   IF st=cu THEN GOSUB 750:RETURN
440   IF in(cu)=0 THEN GOSUB 630:RETURN
450   LET num=c(cu,in(cu)-1)
460   GOSUB 70:ts=su:tv=va
470   IF st=1 THEN LET num=od(in(1)-1,0):GOTO 490
475   IF st=8 THEN LET num=c(st,in(st)-1):GOTO 490
480   LET num=c(st,0)
490   GOSUB 70:IF ((ts=1) OR (ts=2)) AND ((su=1) OR (su=2)) THEN GOSUB 1530:RETURN
500   IF ((ts=3) OR (ts=4)) AND ((su=3) OR (su=4)) THEN GOSUB 1540:RETURN
510   IF tv<>va+1 THEN GOSUB 1550:RETURN
520   IF st=1 THEN GOSUB 700:RETURN
525   IF st=8 THEN GOSUB 712:RETURN
530   GOSUB 25100:FOR i=0 TO in(st)-1:LET num=c(st,i):c(cu,in(cu))=num:GOSUB 70:x=x(cu):y=y(in(cu))+y(left(cu))+2
535   in(cu)=in(cu)+1:GOSUB 150:GOSUB 20
540   c(st,i)=0:NEXT i:in(st)=0:hf=0
550   IF in(8)=0 THEN RETURN
555   IF in(8)-2<0 THEN FOR i=y(2)+44 TO y(2) STEP -4:gshape(x(8),i),blank%():NEXT i:GOTO 565
560   LET num=c(8,in(8)-2):GOSUB 70:x=x(8):y=y(2):GOSUB 20
565   LET num=c(8,in(8)-1):GOSUB 70:x=x(st):y=y(0):GOSUB 20:in(st)=0:c(st,in(st))=num:in(st)=1
570   in(8)=in(8)-1:c(8,in(8))=0:IF in(8)=0 THEN lcu=1
575   RETURN
580   IF left=0 THEN RETURN
581   IF in(1)-2<0 THEN GOSUB 1490:GOSUB 130
582   IF in(1)-2>0 THEN LET num=od(in(0)-2,0):GOSUB 70:x=x(0):y=(in(1)*4)-2:GOSUB 20
583   LET num=od(in(1)-1,0):GOSUB 70:x=x(st):y=y(st):GOSUB 20:in(st)=0:c(st,in(st))=num:in(st)=1
584   in(1)=in(1)-1:d(od(in(1),1))=0:od(in(1),0)=0:od(in(1),1)=0:left=left-1:RETURN      
590   IF st<>1 THEN GOSUB 1560:RETURN
600   GOSUB 25100:LET num=od(in(1)-1,0):GOSUB 70:x=x(cu):y=((in(1))*4)-2:GOSUB 20
610   flag=1:hf=0
620   RETURN
625   IF st<>8 THEN GOSUB 1560:RETURN
628   LET num=c(8,in(8)-1):GOSUB 70:x=x(8):y=y(2):GOSUB 20:hf=0:RETURN  
630   IF in(8)>0 THEN GOSUB 1560:RETURN
640   LET num=od(in(1)-1,0)
650   GOSUB 70
680   GOSUB 700
690   RETURN
700   x=x(cu):y=y(in(cu)):c(cu,in(cu))=num:in(cu)=in(cu)+1:GOSUB 150:GOSUB 20
710   in(1)=in(1)-1:d(od(in(1),1))=0:od(in(1),0)=0:od(in(1),1)=0:hf=0:left=left-1:RETURN
712   x=x(cu):y=y(in(cu)):c(cu,in(cu))=num:in(cu)=in(cu)+1:GOSUB 150:GOSUB 20
714   in(8)=in(8)-1:c(8,in(8))=0:hf=0:IF in(8)=0 THEN lcu=1
716   RETURN  
720   IF in>51 THEN x=x(0):y=139:FOR i=y+44 TO y STEP -4:gshape(x,i),blank%():NEXT i:RETURN
730   IF in(1)>0 THEN LET num=od(in(1)-1,0):GOSUB 70:x=x(1):y=((in(1)-1)*4)-2:GOSUB 20
740   RETURN
750   GOSUB 25100:FOR i=0 TO in(cu)-1:LET num=c(cu,i):GOSUB 70:x=x(cu):y=y(i):GOSUB 20:NEXT i
760   hf=0
770   RETURN
780   LET num=od(in(1)-1,0):GOSUB 70:fl=1
785   IF (fva<>va) AND (f(su,0)=0) THEN RETURN
786   IF f(su,0)=13 AND va<>1 THEN tv=f(su,0):RETURN
790   IF f(su,0)<>va-1 AND f(su,0)<>13 AND f(su,0)<>0 THEN tv=f(su,0):RETURN
795   FOR i=(in(1)*4)+44 TO (in(1)*4)-4 STEP -4:gshape(x(1),i),blank%():NEXT i
800   GOSUB 980
810   d(od(in(cu),1))=0:od(in(cu),0)=0:od(in(cu),1)=0:left=left-1
820   IF in(cu)=0 THEN GOSUB 720:RETURN
830   if in(1)>0 then let num=od(in(1)-1,0):gosub 70:x=x(1):y=((in(1))*4)-2:gosub 20
835   GOSUB 150
840   RETURN
850   FOR i=y(0)+52 TO y(0) STEP -4:gshape(x(cu),i),blank%():NEXT i:GOTO 875
855   j=52:FOR i=y(0)+j TO y(0) STEP -4:gshape(x(cu),i),blank%():NEXT i
860   FOR i=y(2)+54 TO y(2) STEP -4:gshape(x(8),i),blank%():NEXT i
875   GOSUB 14000
880   RETURN
930   IF hf=1 THEN RETURN
935   fl=0
940   IF in(cu)=0 AND in(8)>0 THEN GOSUB 1510:RETURN
950   IF cu=1 THEN GOSUB 780:RETURN
960   LET num=c(cu,in(cu)-1):GOSUB 70
965   IF (fva<>va) AND (f(su,0)=0) THEN RETURN
966   IF f(su,0)=13 AND va<>1 THEN tv=f(su,0):RETURN  
970   IF f(su,0)<>va-1 AND f(su,0)<>13 AND f(su,0)<>0 THEN tv=f(su,0):RETURN
980   x=x(2)
990   IF su=1 THEN y=y1
1000  IF su=2 THEN y=y2
1010  IF su=3 THEN y=y3
1020  IF su=4 THEN y=y4
1030  GOSUB 20:f(su,0)=va:fdation=1:f(su,1)=f(su,1)+1
1040  in(cu)=in(cu)-1:IF fl=1 THEN RETURN
1045  GOSUB 18000
1050  c(cu,in(cu))=0
1055  IF cu=8 AND in(cu)=0 THEN GOSUB 860:RETURN 
1060  IF in(cu)=0 THEN GOSUB 850:RETURN
1065  IF cu=8 THEN x=x(cu):y=y(2):LET num=c(cu,in(cu)-1):GOSUB 70:GOSUB 20:GOTO 1100
1070  REM
1072  FOR i=y(in(cu))+64 TO y(in(cu)) STEP -4:gshape(x(cu),i),blank%()
1075  NEXT i
1090  x=x(cu):y=y(in(cu)-1):LET num=c(cu,in(cu)-1):GOSUB 70:GOSUB 20
1100  RETURN
1110  DIM c(8,12),p(12),d(51),od(33,1),f(4,1),x(8),y(13),in(8)
1115  DIM back%(400),spade%(400),club%(400),diamond%(400),heart%(400),blank%(100),box%(1000),tempbox%(1000),left(8):what=4
1116  DIM quit%(200),regsave%(100),tx$(13):c$="A23456789TJQK"
1117  RESTORE 1590:FOR i=1 TO 13:READ tx$(i):NEXT i
1120  GOSUB 20000:GOSUB 20100
1150  FOR i=0 TO 6:FOR j=0 TO 5:c(i,j)=0:NEXT j:FOR j=6 TO 12:c(i,j)=0:NEXT j:NEXT i
1160  FOR i=0 TO 33:FOR j=0 TO 1:od(i,j)=0:NEXT j:NEXT i
1170  FOR i=0 TO 4:FOR j=0 TO 1:f(i,j)=0:NEXT j:NEXT i
1180  FOR i=0 TO 8:x(i)=i*69:y(i)=(i*10)-2:NEXT i
1190  FOR i=9 TO 12:y(i)=(i*10)-2:NEXT i
1200  y1=-2:y2=45:y3=92:y4=139:y(13)=0
1220  in=0:FOR i=1 TO 4:FOR j=1 TO 13:d(in)=100*i+j:in=in+1:NEXT j:NEXT i
1230  RANDOMIZE -1:FOR i=51 TO 0 STEP -1:x=int(RND(1)*i)+1:t=d(x):d(x)=d(i):d(i)=t:NEXT i
1240  in=0:FOR i=0 TO 12:c(8,i)=d(in):d(in)=0:in=in+1:NEXT i:in(8)=13
1245  found=d(in):LET num=found:GOSUB 70:fva=va:d(in)=0:in=in+1:f(su,1)=1
1250  FOR i=3 TO 6:c(i,0)=d(in):d(in)=0:in=in+1:NEXT i
1260  graphic 1
1290  scnclr:GOSUB 30000
1300  FOR i=3 TO 6:in(i)=1:NEXT i:in(1)=0:in(8)=13:left=34
1310  GOSUB 100:lcu=0
1320  cu=0:oc=0:x=x(cu):hf=0:fdation=0
1330  IF hf=1 THEN ask MOUSE xpos%,ypos%,b%:GOSUB 25000
1331  drawmode 1:penb 0:pena 5:locate(576,y2+42):? using "##";in(8):drawmode 0
1332  IF in(8)=0 THEN lcu=1
1335  ask MOUSE xpos%,ypos%,b%:IF b%<>4 THEN 1330
1336  IF xpos%<0 OR ypos%<0 OR xpos%>617 OR ypos%>186 THEN 1330
1337  cu=INT(xpos%/69):GOSUB 27000
1338  IF cu=2 OR cu=7 THEN 1330
1339  if cu=0 and ypos%<139 then 1330
1340  IF xpos%>207 AND xpos%<262 AND ypos%>168 AND ypos%<185 THEN 1420
1345  IF hf=1 THEN what=5:GOTO 1400
1350  IF cu=0 AND ypos%>139 THEN what=3:GOTO 1400
1352  IF cu<>1 THEN 1360
1353  IF ypos%>(in(cu)*4) AND ypos%<(in(cu)*4)+44 THEN what=2:GOTO 1400
1355  IF ypos%<(in(cu)*4) OR ypos%>(in(cu)*4)+44 THEN what=4:GOTO 1400
1357  GOTO 1330
1360  if cu<>8 then 1369
1365  if ypos%>y(2) and ypos%<y(2)+44 then what=2:goto 1400
1367  if ypos%<y(2) or ypos%>y(2)+44 then what=4:goto 1400
1368  goto 1330
1369  if ypos%>y(in(cu)) and ypos%<y(in(cu))+44 then what=2:goto 1400
1370  IF ypos%<y(in(cu)) OR ypos%>y(in(cu))+44 THEN what=4:GOTO 1400
1390  GOTO 1330
1400  IF what=3 THEN GOSUB 100:GOTO 1330
1402  IF what=4 THEN GOSUB 280:GOTO 1330
1403  IF what=5 THEN GOSUB 410:GOTO 1330
1404  IF what=2 THEN GOSUB 930:IF fdation=1 THEN 1620 ELSE what=4:GOTO 1400
1410  GOTO 1330
1420  sshape(138,168;618,187),tempbox%():gshape(138,168),box%()
1425  a$="Do you want to end this hand?  (Y or N)":long=LEN(a$):long=INT(long/2):pena 4:PRINT  at(377-(long*8),180);a$
1430  GET a$:IF a$="" THEN 1430
1432  IF INSTR("Yy",a$)>=1 THEN 1440
1435  IF INSTR("Nn",a$)>=1 THEN 1438
1436  GOTO 1430
1438  gshape(138,168),tempbox%():GOTO 1335
1440  gshape(138,168),box%():a$="Play another Hand?  (Y or N)":long=LEN(a$):long=INT(long/2):pena 4:PRINT  at(377-(long*8),180);a$
1442  GET a$:IF a$="" THEN 1442
1444  IF INSTR("Yy",a$)>=1 THEN scnclr:GOTO 1150
1446  IF INSTR("Nn",a$)>=1 THEN SYSTEM
1448  GOTO 1442
1450  END
1460  GOSUB 150
1470  RETURN
1480  a$="YOU'VE ALREADY PICKED UP A CARD":GOSUB 16000:GOTO 1610
1490  a$="I AM TURNING THE TALON OVER !":pena 0:peno 5:x=x(0):y=141:box(x,y;x+60,y+44),1:GOSUB 16000
1495  for i=139+46 to y(0) step -4:gshape(x(1),i),blank%():next i:goto 1610
1510  a$="THERE ARE NO CARDS HERE TO PICK UP":GOSUB 16000:GOTO 1610
1520  a$="YOU DO NOT HAVE ANY CARDS TO DROP":GOSUB 16000:GOTO 1610
1530  a$="YOU CAN'T PLAY BLACK ON BLACK":GOSUB 16000:GOTO 1610
1540  a$="YOU CAN'T PLAY RED ON RED":GOSUB 16000:GOTO 1610
1550  a$="YOU CAN'T DROP A"+tx$(va)+" ON A"+tx$(tv):GOSUB 16000:GOTO 1610
1560  a$="YOU CAN'T DROP CARDS HERE":GOSUB 16000:GOTO 1610
1570  a$="YOU CAN ONLY DROP A KING HERE":GOSUB 16000:GOTO 1610
1580  a$="START YOUR FOUNDATION WITH A"+tx$(fva):GOSUB 16000:GOTO 1610
1590  DATA "N  ACE"," TWO"," THREE"," FOUR"," FIVE"," SIX"," SEVEN","N EIGHT"," NINE"," TEN"," JACK"," QUEEN"," KING"
1610  REM
1615  RETURN
1620  IF f(1,1)<13 OR f(2,1)<13 OR f(3,1)<13 OR f(4,1)<13 THEN fdation=0:GOTO 1330
1630  sshape(138,168;618,187),tempbox%():gshape(138,168),box%()
1640  a$="***  YOU WIN !!  Care to play again? (Y/N)  ***":long=LEN(a$):long=INT(long/2):pena 4:PRINT  at(377-(long*8),180);a$
1650  GET a$:IF a$="" THEN 1650
1655  IF INSTR("Yy",a$)>0 THEN 1700
1660  IF INSTR("Nn",a$)>0 THEN 1800
1670  GOTO 1650
1700  scnclr:GOTO 1150
1800  SYSTEM
11000 RETURN
13000 TIME=40000
13005 SLEEP(TIME)
13010 RETURN
14000 TIME=90000:GOTO 13005
15000 TIME=70000:GOTO 13005
16000 long=LEN(a$):long=INT(long/2)
16010 sshape(138,168;618,187),tempbox%()
16020 gshape(138,168),box%()
16030 pena 4:PRINT at(377-(long*8),180);a$
16040 SLEEP(2*10^6)
16050 gshape(138,168),tempbox%()
16090 RETURN
18000 IF in(cu)<>0 THEN RETURN
18010 in(cu)=0
18050 IF in(8)=0 THEN RETURN
18055 IF in(8)-2<0 THEN FOR i=y(2)+44 TO y(2) STEP -4:gshape(x(8),i),blank%():NEXT i:GOTO 18065
18060 LET num=c(8,in(8)-2):GOSUB 70:x=x(8):y=y(2):GOSUB 20
18065 LET num=c(8,in(8)-1):c(cu,in(cu))=num:in(cu)=1
18070 in(8)=in(8)-1:c(8,in(8))=0:IF in(8)=0 THEN lcu=1
18075 RETURN
18080 IF left=0 THEN RETURN
18081 IF in(0)-2=0 THEN GOSUB 1490:GOSUB 130
18082 IF in(0)-2>0 THEN LET num=od(in(0)-2,0):GOSUB 70:x=x(0):y=(in(0)*4)-2:GOSUB 20
18083 LET num=od(in(0)-1,0):c(cu,in(cu))=num:in(cu)=1
18084 in(0)=in(0)-1:d(od(in(0),1))=0:od(in(0),0)=0:od(in(0),1)=0:left=left-1:RETURN
20000 bload "heart_dat",VARPTR(regsave%(0))
20010 ct=0:FOR i%=0 TO 31
20020 rgb i%,regsave%(ct),regsave%(ct+1),regsave%(ct+2)
20030 ct=ct+3:NEXT i%
20040 RETURN
20100 bload "heart",VARPTR(heart%(0))
20110 bload "diamond",VARPTR(diamond%(0))
20120 bload "club",VARPTR(club%(0))
20130 bload "spade",VARPTR(spade%(0))
20140 bload "blank",VARPTR(blank%(0))
20150 bload "back",VARPTR(back%(0))
20160 bload "box",VARPTR(box%(0))
20170 bload "quit",VARPTR(quit%(0))
20190 RETURN
25000 REM *** shadow box ***
25010 drawmode 2
25020 x2%=xpos%:y2%=ypos%
25030 box(x2%-30,y2%;x2%+30,y2%+44)
25040 ask MOUSE x%,y%,b%
25050 IF b%<>0 THEN box(x2%-30,y2%;x2%+30,y2%+44):xpos%=x2%:ypos%=y2%:drawmode 0:RETURN
25060 IF x%=x2% AND y%=y2% THEN 25040
25070 box(x2%-30,y2%;x2%+30,y2%+44)
25080 x2%=x%:y2%=y%
25090 box(x2%-30,y2%;x2%+30,y2%+44)
25095 GOTO 25040
25100 RETURN:drawmode 2:box(oldxpos%,oldypos%;oldxpos%+43,oldypos%+59)
25110 drawmode 0:RETURN
27000 RETURN
27500 wave 256,timbre%()
27510 for i=3 to 0 step -1:gshape(x(8),y(2)),back%():qq=sound(1,1,1,64,(i+1)*1000):qq=sound(2,1,1,64,(i+1)*1000):next i
27520 return
28000 DIM timbre%(255),timbre1%(255):k#=2*3.14159265#/256
28010 FOR i=0 TO 255
28020 timbre%(i)=31*(SIN(i*k#)+SIN(2*i*k#)+SIN(4*i*k#)+SIN(4*i*k#))
28030 NEXT i
28040 FOR i=0 TO 255
28050 timbre1%(i)=-127+(RND(1)*255)
28060 NEXT i
28070 WAVE 256,timbre1%()
28080 audio 15,1
28090 RETURN
30000 gshape(0,139),back%():peno 5:box(x(2),0;x(2)+59,0+44),0:box(x(2),47;x(2)+59,47+44),0:box(x(2),94;x(2)+59,94+44),0
30010 box(x(2),141;x(2)+59,141+44),0
30020 FOR i=3 TO 6
30030 xx%=x(i):yy%=y(0)+2:GOSUB 32000
30070 LET num=c(i,0):GOSUB 70:x=x(i):y=y(0):GOSUB 20
30080 NEXT i
30082 xx%=x(8):yy%=y(2)+2:GOSUB 32000
30084 LET num=c(8,in(8)-1):GOSUB 70:x=x(8):y=y(2):GOSUB 20
30085 pena 6:PRINT  at(560,y2+32);"STOCK"
30090 pena 7:FOR i=0 TO 3:PRINT  at(x(2)+27,24+(i*47));MID$(c$,fva,1):NEXT i
30100 LET num=found:GOSUB 70:fl=1:GOSUB 980:fl=0
30200 gshape(207,168),quit%():RETURN
32000 peno 4:drawmode 2:ystep=139-yy%:xstep=xx%/10
32010 ystep=INT(ystep/xstep)+2:y=139
32020 FOR x=5 TO xx% STEP 20:y=y-ystep
32030 box(x,y;x+59,y+43),0
32050 box(x,y;x+59,y+43),0
32060 NEXT x
32090 drawmode 0:RETURN
