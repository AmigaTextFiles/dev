1     GOTO 7900:REM  **** COMPUTER MONOPOLY ****  SOFTWARE COPYRIGHT <c> 1985    by David M. Addison
20    GOTO 10000:REM **** throw dice ****
30    RETURN:REM **** key press sound ****
40    REM **** graphic to build house ****
41    gshape(133,123), housepic%()
42    kk%=val(mid$(b$,8,1))-1:note1%=1900:note2%=1000:gosub 40000
44    gosub 41000:return
50    FOR u%=1 TO 4:IF d%(u%) < 2 THEN GOTO 58:REM **** SORT DEEDS ****
51    FOR v%=1 TO d%(u%)-1:FOR w%=1 TO d%(u%)-1:c$=STR$(p#(u%,w%)):b$=STR$(p#(u%,w%+1))
52    IF MID$(c$,2,2) = "23" OR MID$(c$,2,1) = "4" THEN y%=2-VAL(MID$(c$,2,1)):GOTO 54
53    y%=VAL(MID$(c$,4,2))
54    IF MID$(b$,2,2) = "23" OR MID$(b$,2,1) = "4" THEN x%=2-VAL(MID$(b$,2,1)):GOTO 56
55    x%=VAL(MID$(b$,4,2))
56    IF y% > x% THEN z#=p#(u%,w%):p#(u%,w%)=p#(u%,w%+1):p#(u%,w%+1)=z#
57    NEXT w%,v%
58    NEXT u%:RETURN
60    REM **** GRAPHIC TO BUILD HOTEL ****
62    gshape(108,111), hotelpic%()
64    kk%=5:note1%=5900:note2%=1500:gosub 40000
66    gosub 41000:return
70    gosub 36300:return:rem ****  GRAPHIC FOR POLICE  ****
80    RETURN:REM **** SOUND ****
90    yy%=126:xx%=215:j%=0:REM **** GRAPHIC FOR TRAIN ****
91    pena 1:draw (61,146 TO 240,146)
92    FOR i%=215 TO 61 STEP -1
93    j%=j%+1:IF j% > 4 THEN j% = 1
94    ON j% GOTO 95,96,97,98
95    gshape (i%,yy%),train1%():GOTO 99
96    gshape (i%,yy%),train2%():GOTO 99
97    gshape (i%,yy%),train3%():GOTO 99
98    gshape (i%,yy%),train4%()
99    SLEEP(50000):NEXT i%:RETURN
100   RETURN:REM **** SOUND ****
200   x%=VAL(MID$(b$,4,2)):REM **** FETCH PROPERTY NAME ****
210   a$=propname$(x%):pena propcolor%(x%):PRINT  a$;:pena maincolor%
220   RETURN
299   b$ = propdeed$(z%):RETURN:REM **** FETCH PROPERTY DEED ****
400   GOSUB 20000:GOSUB 460:REM **** MENU ****
401   ask MOUSE xx%,yy%,bb%:x% = pixel(xx%,yy%):IF bb%=0 THEN GOTO 401
402   IF x% = 27 THEN t%=4:GOSUB 20000:GOTO 1219
403   IF x% = 28 THEN GOTO 5000
404   IF x% = 29 THEN GOTO 401
405   if x% = 30 then gosub 3000:gosub 41000:goto 400
406   if x% = 25 then 410
409   goto 401
410   gosub 20000:?:?:? tab (14);"Are you SURE":? tab(12);"you want to QUIT!":gosub 1700
415   if x$="Y" then scnclr:chdir "/":end
420   goto 400
460   pena maincolor%:PRINT "          MENU"
462   peno 1:pena 25:CIRCLE ((14*8)-3,(9*8)-3),3:PAINT ((14*8)-3,(9*8)-3),0
464   pena 25:PRINT at(16*8,9*8);"= End"
466   pena 28:CIRCLE ((14*8)-3,(11*8)-3),3:PAINT ((14*8)-3,(11*8)-3),0
468   pena 22:PRINT at(16*8,11*8);"= Trade"
473   pena 30:circle ((14*8)-3,(13*8)-3),3:paint ((14*8)-3,(13*8)-3),0:pena 23:print at(16*8,13*8);"= Info."
475   pena 27:circle ((14*8)-3,(15*8)-3),3:paint ((14*8)-3,(15*8)-3),0:pena 26:? at(16*8,15*8);"= Play"
490   pena maincolor%:return
600   IF d%(t%)=0 THEN GOTO 1020:REM **** COMPUTER TRADE ****
610   u%=1
611   if u%=t% then 620
612   IF d%(u%)=0 THEN 620
613   v%=1
614   y%=0:b$=STR$(p#(u%,v%)):FOR w%=1 TO d%(t%):c$=STR$(p#(t%,w%)):IF MID$(b$,2,2)=MID$(c$,2,2) THEN y%=y%+1
616   NEXT w%:IF VAL(MID$(b$,2,1))=y%+1 AND b$<>"23" THEN 630
618   v%=v%+1:IF v%<=d%(u%) THEN 614
620   u%=u%+1:IF u%<4 THEN 611
621   GOTO 1003
630   x%=1
631   y%=0:c$=STR$(p#(t%,x%)):FOR z%=1 TO d%(u%):d$=STR$(p#(u%,z%)):IF MID$(c$,2,2)=MID$(d$,2,2) THEN y%=y%+1
632   NEXT z%:IF VAL(MID$(c$,2,1))=y%+1 THEN 640
634   x%=x%+1:IF x%<=d%(t%) THEN 631
635   GOTO 618
640   IF MID$(c$,2,2)=MID$(b$,2,2) THEN 634
650   d$=c$:y%=t%:t%=u%:GOSUB 6000:x%=z%:t%=y%:d$=b$:GOSUB 6000:y%=z%:z%=INT(y%-x%)/2:z%=100*INT(z%/100)
652   IF c%(t%)-z% < 0 OR c%(u%)+z% < 0 THEN GOTO 1003
660   w%=0:GOSUB 20000:pena 26:PRINT at (16*8,6*8);"HUMAN!"
661   w%=w%+1:SLEEP(200500):pena 1:PRINT at(16*8,6*8);"HUMAN!":SLEEP(200500):pena 26:PRINT at(16*8,6*8);"HUMAN!"
662   IF w% < 6 THEN 661
663   pena maincolor%:PRINT TAB(8);:GOSUB 4080:PRINT  " just traded ":d$=b$:b$=c$:PRINT TAB(8);:GOSUB 200
665   c%(t%)=c%(t%)-z%:c%(u%)=c%(u%)+z%
670   IF z% > 0 THEN PRINT tab(8); "and $";z%
680   PRINT tab(8); "and got ":b$=d$:? tab(8);:GOSUB 200
682   PRINT TAB(8);:IF z% < 0 THEN PRINT  "and $";ABS(z%);
684   PRINT  "from ";:y%=t%:t%=u%:GOSUB 4080:PRINT  "!"
690   PRINT TAB(8);:GOSUB 4080:PRINT  " has $";c%(u%);".":t%=y%:PRINT TAB(8);:GOSUB 4080:PRINT  " has $";c%(t%);"."
692   GOSUB 41000:GOSUB 20000:GOTO 5350
700   RETURN
1000  GOSUB 2400:IF t%=4 THEN GOTO 1003:REM **** MAIN LOOP ****
1001  GOTO 600
1003  IF d%(t%)=0 THEN GOTO 1020
1006  IF t% > 3 THEN GOTO 1009
1007  FOR s%=1 TO d%(t%):c$=STR$(p#(t%,s%)):IF mid$(c$,8,1)="0" or len(c$)>8 THEN GOSUB 1500
1008  NEXT s%
1009  IF t%=4 THEN GOSUB 1500
1020  GOSUB 1400:IF l%(t%) = 40 THEN 2900
1040  q%=0:GOSUB 20:PRINT at(48,80);" ";:GOSUB 4088:PRINT  " rolled ";
1045  IF d1%+d2%=8 OR d1%+d2%=11 THEN PRINT  "an";d1%+d2%:GOTO 1050
1046  PRINT  "a";d1%+d2%
1050  IF d1%<>d2% THEN GOTO 1100
1060  d3%=d3%+1:d%=d%+1
1061  if d%=3 then newxx%=40:gosub 31000:l%(t%)=40:?:? tab(8);"Three doubles...";:?:? tab(8);"GO TO JAIL!!":gosub 70:goto 1210
1100  GOSUB 30000:gosub 2780:gosub 20000:l%(t%)=l%(t%)+d1%+d2%:IF l%(t%) > 39 THEN l%(t%)=l%(t%)-40:GOSUB 4070
1110  z%=l%(t%):GOSUB 299:GOSUB 4080:PRINT  " landed on ":? tab(8);:GOSUB 200:PRINT  ".":GOSUB 80:GOSUB 700
1111  if mid$(b$,2,3)="502" then 47000
1112  IF MID$(b$,2,2)="60" THEN 3100
1113  IF MID$(b$,2,2)="70" THEN 4220
1114  IF MID$(b$,2,2)="80" THEN newxx%=40:gosub 31000:l%(t%)=40:gosub 70:goto 1210
1116  IF VAL(MID$(b$,2,1))>4 THEN GOSUB 2400:GOTO 1200
1120  FOR v%=1 TO 4:IF d%(v%)=0 THEN GOTO 1124
1121  FOR x%=1 TO d%(v%):c$=STR$(p#(v%,x%)):IF MID$(c$,1,3)=MID$(b$,1,3) THEN GOTO 1140
1122  NEXT x%
1124  NEXT v%
1125  IF t%<4 THEN GOTO 1300
1127  IF VAL(MID$(b$,2,1))<5 AND c%(4)< 20*fininfo%(8*VAL(MID$(b$,6,2))) THEN 1170
1130  ?:? tab(8);"You have $";c%(t%):?
1131  PRINT TAB(8);"Want to buy":? tab(8);:gosub 200
1133  ? tab(8);"for $";20*fininfo%(8*val(mid$(b$,6,2)));:pena 2:? "?":pena maincolor%:gosub 1700:if x$="N" then goto 1200
1136  GOSUB 2800:GOTO 1200
1140  IF v%<>t% THEN 1148
1141  IF t%=4 THEN ?:?:PRINT  TAB(8);"You own it.":GOTO 1200
1142  ?:?:PRINT  TAB(8);:GOSUB 4080:pena 2:PRINT  " owns it.":GOTO 1200
1148  IF MID$(c$,8,1)<>"0" THEN GOTO 1150
1149  PRINT  TAB(8);"No rent!":y%=t%:t%=v%:PRINT  TAB(8);:GOSUB 4080:t%=y%:PRINT tab(8); "mortgaged the property.":GOTO 1200
1150  PRINT  TAB(14);"PAY RENT!";:SLEEP(10500)
1152  pena 25:PRINT tab(14); "PAY RENT!";:pena maincolor%:SLEEP(10500):IF q%=82 THEN ?:PRINT tab(14); "(DOUBLED)"
1154  PRINT  TAB(8);:GOTO 2600
1170  IF d%(4)=0 THEN GOTO 1198
1172  z%=c%(4):FOR w%=1 TO d%(4):c$=STR$(p#(4,w%)):IF MID$(c$,8,1)="1" OR MID$(c$,8,1)="2" THEN z%=z%+10*fininfo%(8*VAL(MID$(c$,6,2)))
1174  NEXT w%:IF z%<20*fininfo%(8*VAL(MID$(b$,6,2))) THEN GOTO 1198
1176  PRINT  TAB(8);"You can raise an ":PRINT  TAB(8);"additional $";z%-c%(4);"cash ":PRINT  TAB(8);"by mortgaging ":PRINT  TAB(8);"undeveloped land."
1178  PRINT  TAB(8);"Want to mortgage land":PRINT  TAB(8);"and buy?":GOSUB 1700
1179  IF x$="N" THEN PRINT  TAB(8);"Not a gambler, eh? OK...":GOTO 1200
1186  u%=1
1187  GOSUB 2700:IF c%(4)>=20*fininfo%(8*VAL(MID$(b$,6,2))) THEN GOTO 1130
1188  u%=u%+1:IF u%<=d%(4) THEN 1187
1198  PRINT  TAB(8);"You don't have the":PRINT  TAB(8);"money to buy.":GOSUB 2780
1200  IF d3%=1 THEN gosub 41000:GOSUB 20000:GOSUB 4080:PRINT  " had doubles":d3%=0:gosub 2780:GOTO 1000
1210  d3%=0:d%=0:t%=t%+1:IF t%=5 THEN t%=1