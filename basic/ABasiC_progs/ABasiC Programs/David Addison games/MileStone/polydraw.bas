5     clr:SCREEN 0,5:scnclr
10    DIM picture%(11000),regsave%(100),cset%(580),img1%(112),name$(19)
11    gosub 58000
12    vcset%=VARPTR(cset%(0)):vimg1%=VARPTR(img1%(0))
14    bload "polydraw_font",vcset%
20    filename$="polydraw_pic":x%=0:y%=0:gosub 17080
25    first%=11:last%=16:speed%=100:gosub 25070
30    scnclr
52    colorfile$="polydraw_reg_dat"
55    bload colorfile$,VARPTR(regsave%(0))
57    ct=0
59    FOR i% = 0 TO 31
61    rgb i%,regsave%(ct),regsave%(ct+1),regsave%(ct+2)
63    ct=ct+3
65    NEXT i%
70    pena 1:FLAG% = 0:COUNT%=0
90    a$="?":goto 180
100   REM **** MAIN LOOP ****
110   GET a$
120   IF a$="D" OR a$="d" OR a$="D." THEN GOSUB 12000:goto 1000
125   IF a$="Z" OR a$="z" OR a$="Z." THEN GOSUB 21000:goto 1000
130   IF a$="B" OR a$="b" OR a$="B." THEN GOSUB 10000:goto 1000
135   IF a$="X" OR a$="x" or a$="X." THEN GOSUB 40000:goto 1000
140   IF a$="L" OR a$="l" or a$="L." THEN GOSUB 11000:goto 1000
145   IF a$="O" OR a$="o" or a$="O." THEN GOSUB 35000:goto 1000
150   IF a$="S" OR a$="s" or a$="S." THEN GOSUB 15000:goto 1000
155   IF a$="F" OR a$="f" or a$="F." THEN GOSUB 14000:goto 1000
160   IF a$="C" OR a$="c" or a$="C." THEN GOSUB 13000:goto 1000
165   IF a$="K" OR a$="k" or a$="K." THEN GOSUB 17000:goto 1000
170   IF a$="Q" OR a$="q" or a$="Q." THEN GOTO 16000
175   IF a$="U" OR a$="u" or a$="U." THEN scnclr:goto 1000
180   IF a$="?" OR a$="/" OR a$="?." THEN GOSUB 30000:goto 120
185   IF a$="E" OR a$="e" or a$="E." THEN GOSUB 36000:goto 1000
187   IF a$="R" OR a$="r" or a$="R." THEN GOSUB 37000:goto 1000
188   IF a$="A" OR a$="a" or a$="A." THEN GOSUB 52000:goto 1000
190   IF a$="T" OR a$="t" THEN getkey b$:GOSUB 41000:goto 1000
192   if a$="TB" or a$="TS" then b$=mid$(a$,2,1):gosub 41000:goto 1000
200   IF a$="M" OR a$="m" or a$="M." THEN GOSUB 25000:goto 1000
500   GOTO 110
1000  for i%=1 to 10:get a$:next i%:goto 110
9999  REM **** RUBBER BAND BOX ****
10000 talk$ = TRANSLATE$("BOX!"):q% = narrate(talk$)
10005 GOSUB 10040
10016 IF a$<>"" THEN 20000
10030 GOTO 10005
10040 drawmode 2
10050 ask MOUSE x1%,y1%,b%:GOSUB 50000
10060 GOSUB 55000
10065 if a$<>"" then return
10070 x2% = x1% : y2% = y1%
10080 ask MOUSE x%,y%,b%:GOSUB 50000
10090 IF x% = x2% AND y% = y2% GOTO 10080
10100 IF b%=0 THEN 10150
10110 box (x1%,y1%;x2%,y2%)
10120 x2% = x% : y2% = y%
10130 box(x1%,y1%;x2%,y2%)
10140 IF b% <> 0 GOTO 10080
10150 drawmode 0
10155 peno colreg%:box(x1%,y1%;x2%,y2%)
10160 RETURN
10999 REM **** RUBBER BAND LINE ****
11000 talk$ = TRANSLATE$("LINE!"):q% = narrate(talk$)
11005 GOSUB 11040
11010 ask MOUSE x%,y%,b%:GOSUB 50000
11015 GET a$:IF a$="C" OR a$="c" THEN GOSUB 13000:GOTO 11010
11016 IF a$<>"" THEN 20000
11020 IF b% = 0 GOTO 11010
11030 GOTO 11005
11040 drawmode 2
11050 ask MOUSE x1%,y1%,b%:GOSUB 50000
11060 IF b% = 0 GOTO 11050
11070 x2% = x1% : y2% = y1%
11080 ask MOUSE x%,y%,b%:GOSUB 50000
11090 IF x% = x2% AND y% = y2% GOTO 11080
11100 IF b%=0 THEN 11150
11110 draw (x1%,y1% TO x2%,y2%)
11120 x2% = x% : y2% = y%
11130 draw (x1%,y1% TO x2%,y2%)
11140 IF b% <> 0 GOTO 11080
11150 drawmode 0
11155 draw (x1%,y1% TO x2%,y2%)
11160 RETURN
11999 REM **** DRAW ****
12000 talk$ = TRANSLATE$("DRAWW!"):q% = narrate(talk$)
12005 ask MOUSE x%,y%,b%:GOSUB 50000
12010 GET a$:IF a$ = "C" OR a$="c" THEN GOSUB 13000 ELSE IF a$<>"" THEN 20000
12020 IF b% = 0 GOTO 12005
12030 draw (x%,y%)
12035 ask mouse x%,y%,b%:gosub 50000
12036 if b%=0 goto 12005
12037 draw (to x%,y%)
12040 goto 12035
12999 REM **** COLOR CHANGE ROUTINE ****
13000 WINDOW #1,220,0,100,64,"COLORS "
13010 cmd #1
13015 ON ERROR GOTO 60010
13020 GOSUB 13500:GOSUB 13100
13030 ask MOUSE x5%,y5%,b5%
13040 IF b5%=0 THEN 13030
13050 colreg% = pixel (x5%,y5%)
13055 CLOSE #1:cmd #0:pena colreg%
13060 b%=0:GOTO 20000
13100 talk$ = TRANSLATE$("PICK A COLOR")
13110 q% = narrate (talk$)
13120 RETURN
13500 n% = 10
13510 FOR y%=0 TO 3
13520 FOR x%=0 TO 7
13530 pena x%+(8*y%)
13540 a% = x%*n%
13550 b% = y%*n%
13560 peno 1
13570 box(a%,b%;a%+n%,b%+n%),1
13580 NEXT x%,y%
13590 RETURN
13999 REM **** FILL ROUTINE ****
14000 talk$=TRANSLATE$("SELLECT A POINT, AND PRESS BUTTIN!"):q% = narrate(talk$)
14010 ask MOUSE x%,y%,b%:GOSUB 50000
14020 GET a$:IF a$="C" OR a$="c" THEN GOSUB 13000:GOTO 14010
14025 IF a$<>"" THEN 20000
14030 IF b%=0 THEN 14010
14040 PAINT (x%,y%),1
14050 GOTO 14010
14999 REM **** SAVE SCREEN ROUTINE ****
15000 REM
15010 i%=narrate("PLEY4S DHAX MAW3S AET DHAX TAA4P LEH4FT KOH4RNER",n%())
15020 ask MOUSE x1%,y1%,b%:x%=x1%:y%=y1%:GOSUB 50000
15022 gosub 55000:x3%=x1%:y3%=y1%
15025 IF a$<>"" THEN x1%=0:y1%=0:x2%=303:y2%=187:GOTO 15070
15040 i%=narrate("PLEY4S DHAX MAW3S AET DHAX BAA4TAHM RAY3T KOH4RNER",n%())
15050 ask MOUSE x2%,y2%,b%:x%=x2%:y%=y2%:GOSUB 50000
15060 gosub 56000:x1%=x3%:y1%=y3%
15065 drawmode 0
15070 ERASE picture%
15080 size% = INT(((x2%-x1%)/16)+2)
15090 size% = size%*(y2%-y1%)
15100 size% = ((((size%*5)+4)/2)+10)
15110 DIM picture%(size%)
15120 sshape (x1%,y1%;x2%,y2%),picture%()
15130 WINDOW #1,10,50,300,35,"   SAVE    "
15140 cmd #1:graphic 0
15150 PRINT "SIZE= ";size%:INPUT "Enter a Filename: ";filename$
15160 CLOSE #1:cmd #0:graphic 1
15165 IF filename$="" THEN 15400
15170 bsave filename$,VARPTR(picture%(0)),4*size%
15180 colorfile$=filename$+"_dat"
15190 ct=0
15200 FOR i%=0 TO 31
15210 ask rgb i%,red%,green%,blue%
15220 regsave%(ct)=red%:regsave%(ct+1)=green%:regsave%(ct+2)=blue%
15230 ct=ct+3
15240 NEXT i%
15250 bsave colorfile$,VARPTR(regsave%(0)),400
15400 GOTO 20000
15999 REM **** I QUIT ****
16000 talk$=TRANSLATE$("I QUIT!"):q% = narrate(talk$)
16010 SCREEN 0,4:rgb 15,0,0,0:END
16999 REM **** LOAD A SHAPE ****
17000 WINDOW #1,10,50,300,25,"    LOAD    "
17010 cmd #1
17020 INPUT "Enter a filename: ";filename$
17030 CLOSE #1:cmd #0
17035 IF filename$ = "" THEN 20000
17040 talk$=TRANSLATE$("PLACE POINTER WHERE YOU WANT PICTURE TO GO!")
17050 q% = narrate(talk$)
17060 ask MOUSE x1%,y1%,b%:GOSUB 50000
17062 gosub 55000:x%=x2%:y%=y2%:drawmode 0
17065 IF a$<>"" THEN x%=0:y%=0:GOTO 17080
17080 ERASE picture%:DIM picture%(11000)
17085 ON ERROR GOTO 60000
17090 bload filename$,VARPTR(picture%(0))
17100 gshape (x%,y%),picture%()
17110 colorfile$=filename$+"_dat"
17120 bload colorfile$,VARPTR(regsave%(0))
17130 ct=0
17140 FOR i%=0 TO 31
17150 rgb i%,regsave%(ct),regsave%(ct+1),regsave%(ct+2)
17160 ct=ct+3
17170 NEXT i%
17400 ON ERROR GOTO 0:GOTO 20000
20000 talk$ = TRANSLATE$("DONE?"):q% = narrate(talk$)
20005 drawmode 0
20010 ON ERROR GOTO 0:RETURN
20999 REM **** SHOW X & Y ****
21000 IF FLAG% = 0 THEN GOSUB 22000:RETURN
21010 FLAG% = 0:CLOSE #2:cmd #0:RETURN
22000 FLAG% = 1
22010 WINDOW #2,184,169,136,31," X & Y "
22030 cmd #0:RETURN
25000 talk$=TRANSLATE$("CYEKLE COLORS!"):q%=narrate(talk$)
25010 WINDOW #1,0,20,300,50,"  CYCLE COLORS   "
25020 cmd #1
25030 INPUT "Starting color register #: ";first%
25040 INPUT "Ending color register #:   ";last%
25050 IF first%>last% THEN GOTO 25030
25055 INPUT "Speed of rotation: ";speed%
25060 CLOSE #1:cmd #0
25070 ask rgb first%,r%,g%,b%
25080 FOR i%=last% TO first% STEP -1
25090 ask rgb i%,r1%,g1%,b1%
25100 rgb i%,r%,g%,b%
25110 r%=r1%:g%=g1%:b%=b1%
25120 ask MOUSE x%,y%,button%:IF button%=4 THEN GOTO 25200
25125 SLEEP(speed%)
25130 NEXT i%
25140 GOTO 25070
25200 ct=0
25210 FOR i% = 0 TO 31
25220 rgb i%,regsave%(ct),regsave%(ct+1),regsave%(ct+2)
25230 ct=ct+3
25240 NEXT i%
25250 GOTO 20000
29999 REM **** MENU ****
30000 WINDOW #1,0,0,190,187,"   MENU    "
30001 graphic 0:get a$:get a$
30002 cmd #1
30004 ? " "
30010 for i%=1 to 19:? name$(i%):next i%
30015 storey%=1
30020 ask mouse x%,y%,b%
30022 sleep (50000)
30025 if y%<8 or y%>160 or x%<0 or x%>150 then 30020
30030 cur%=int(y%/8):if cur%<1 or cur%>18 then 30045
30035 if cur%<>storey% then print at(0,storey%+1);name$(storey%);
30040 if cur%<>storey% then print at(0,cur%+1);inverse(1) name$(cur%);:storey%=cur%
30045 ask mouse x%,y%,b%
30050 if y%<8 or y%>152 or x%<0 or x%>150 then 30045
30054 if b%=4 then 30060
30055 goto 30030
30060 a$=mid$(name$(cur%),2,2)
30110 CLOSE #1:cmd #0:graphic 1:RETURN
34999 REM **** CIRCLE ****
35000 talk$ = TRANSLATE$("CIRCLE!"):q% = narrate(talk$)
35010 GOSUB 35070
35040 IF a$<>"" THEN 20000
35060 GOTO 35010
35070 drawmode 2
35080 ask MOUSE x1%,y1%,b%:GOSUB 50000
35090 gosub 55000
35095 if a$<>"" then return
35100 x2% = x1% : y2% = y1%
35110 ask MOUSE x%,y%,b%:GOSUB 50000
35120 IF x% = x2% AND y% = y2% GOTO 35110
35130 IF b%=0 THEN 35180
35140 CIRCLE (x1%,y1%),ABS(x2%-x1%)
35150 x2% = x% : y2% = y%
35160 CIRCLE (x1%,y1%),ABS(x2%-x1%)
35170 IF b% <> 0 GOTO 35110
35180 drawmode 0
35190 peno colreg%:CIRCLE (x1%,y1%),ABS(x2%-x1%)
35200 RETURN
35999 REM **** ELLIPSE ****
36000 talk$ = TRANSLATE$("ELIPSE!"):q% = narrate(talk$)
36010 GOSUB 36070
36040 IF a$<>"" THEN 20000
36060 GOTO 36010
36070 drawmode 2
36080 ask MOUSE x1%,y1%,b%:GOSUB 50000
36090 gosub 55000
36095 if a$<>"" then return
36100 x2% = x1% : y2% = y1%
36110 ask MOUSE x%,y%,b%:GOSUB 50000
36120 IF x% = x2% AND y% = y2% GOTO 36110
36130 IF b%=0 THEN 36180
36140 CIRCLE (x1%,y1%),ABS(x2%-x1%),ABS(y2%-y1%)/20
36150 x2% = x% : y2% = y%
36160 CIRCLE (x1%,y1%),ABS(x2%-x1%),ABS(y2%-y1%)/20
36170 IF b% <> 0 GOTO 36110
36180 drawmode 0
36190 peno colreg%:CIRCLE (x1%,y1%),ABS(x2%-x1%),ABS(y2%-y1%)/20
36200 RETURN
36999 REM **** RAYS ****
37000 talk$ = TRANSLATE$("RAYS!"):q% = narrate(talk$)
37010 GOSUB 37070
37020 ask MOUSE x%,y%,b%:GOSUB 50000
37030 GET a$:IF a$="C" OR a$="c" THEN GOSUB 13000:GOTO 37020
37040 IF a$<>"" THEN 20000
37050 IF b% = 0 GOTO 37020
37060 GOTO 37010
37070 drawmode 0
37080 ask MOUSE x1%,y1%,b%:GOSUB 50000
37090 IF b% = 0 GOTO 37080
37100 x2% = x1% : y2% = y1%
37110 ask MOUSE x%,y%,b%:GOSUB 50000
37120 IF x% = x2% AND y% = y2% GOTO 37110
37130 IF b%=0 THEN 37180
37140 draw (x1%,y1% TO x2%,y2%)
37150 x2% = x% : y2% = y%
37160 draw (x1%,y1% TO x2%,y2%)
37170 IF b% <> 0 GOTO 37110
37180 drawmode 0
37200 RETURN
40000 REM **** COPY SHAPE ****
40010 i%=narrate("PLEY4S DHAX MAW3S AET DHAX TAA4P LEH4FT KOH4RNER",n%())
40020 ask MOUSE x1%,y1%,b%:x%=x1%:y%=y1%:GOSUB 50000
40030 gosub 55000:x3%=x2%:y3%=y2%
40035 if a$<>"" then goto 40130
40040 i%=narrate("PLEY4S DHAX MAW3S AET DHAX BAA4TAHM RAY3T KOH4RNER",n%())
40050 ask MOUSE x2%,y2%,b%:x%=x2%:y%=y2%:GOSUB 50000
40060 gosub 56000:x1%=x3%:y1%=y3%
40065 drawmode 0
40070 ERASE picture%
40080 size% = INT(((x2%-x1%)/16)+2)
40090 size% = size%*(y2%-y1%)
40100 size% = ((((size%*5)+4)/2)+10)
40110 DIM picture%(size%)
40120 sshape (x1%,y1%;x2%,y2%),picture%()
40130 talk$=TRANSLATE$("SHAPE IS NOW READY TO USE!"):q% = narrate(talk$)
40140 ask MOUSE x%,y%,b%:GOSUB 50000
40150 GET a$:IF a$<>"" THEN 20000
40160 IF b%=0 THEN 40140
40170 gshape (x%,y%),picture%()
40180 GOTO 40140
41000 REM **** TEXT ROUTINE ****
41005 drawmode 0
41010 IF b$="B" OR b$="b" THEN GOSUB 41100
41020 IF b$="S" OR b$="s" THEN GOSUB 41500
41030 GOTO 20000
41100 talk$=TRANSLATE$("BIG TEXT!"):q%=narrate(talk$)
41110 ask MOUSE x%,y%,b%:GOSUB 50000
41115 gosub 55000:xo%=x1%:yo%=y1%-10:drawmode 0
41117 sleep(100000)
41120 GET alpha$:IF alpha$<>"" THEN IF ASC(alpha$)=13 THEN 41110
41121 if alpha$<>"" then if asc(alpha$)=227 or asc(alpha$)=195 then gosub 13000:alpha$=""
41125 if alpha$<>"" then gosub 42000
41128 ask mouse x%,y%,b%
41130 if b%=0 then 41120
41140 RETURN
41500 talk$=TRANSLATE$("SMALL TEXT!"):q%=narrate(talk$)
41510 graphic 1
41520 ask MOUSE x%,y%,b%:GOSUB 50000:graphic 1
41525 gosub 55000:x3%=x1%:y3%=y1%:drawmode 0
41526 sleep (100000)
41530 GET alpha$:IF alpha$<>"" THEN IF ASC(alpha$)=13 THEN 41520
41531 if alpha$<>"" then if asc(alpha$)=227 or asc(alpha$)=195 then gosub 13000:alpha$=""
41535 if alpha$<>"" then print at(x3%,y3%);alpha$:x3%=x3%+8
41538 ask mouse x1%,y1%,b%
41540 IF b%=0 THEN 41530
41550 graphic 0:RETURN
42000 REM plot alpha$ BIG
42020 sshape (xo%,yo%;12+xo%,yo%+12),img1%()
42030 soffset%=6:COLOR%=colreg%
42040 v%=vcset%+4+(ASC(alpha$)-32)*24
42050 WHILE COLOR%<>0
42060 IF (COLOR% MOD 2)=1 THEN FOR sk%=0 TO 23 STEP 4:POKE_l vimg1%+soffset%+sk%,PEEK_l(v%+sk%):NEXT
42070 COLOR%=INT(COLOR%/2)
42080 soffset%=soffset%+24
42090 WEND
42100 gshape (xo%,yo%),img1%()
42105 xo%=xo%+13
42110 RETURN
50000 IF FLAG% = 0 THEN RETURN
50010 COUNT% = COUNT% +1:IF COUNT% < 200 THEN RETURN
50020 COUNT% = 0:GOSUB 51000
50030 RETURN
51000 cmd #2:graphic 0:PRINT at(0,0);"X= ";:PRINT USING "###";x%;:PRINT "  Y= ";:PRINT USING "###";y%;
51010 cmd #0
51015 graphic 1
51020 RETURN
52000 WINDOW #1,0,0,320,200,"     R G B  MIXER      ":cmd #1
52010 graphic 1
52020 ask rgb colreg%,red%,green%,blue%
52030 pena colreg%: peno 1
52040 box(10,25;298,110),1
52050 RESTORE 52170
52060 FOR j%=1 TO 3
52070 READ a%,b%,c%
52080 pena a%
52090 AREA(c%+10,120 TO c%+0,130 TO c%+20,130)
52100 draw(c%+0,131 TO c%+20,131),1
52110 pena b%
52120 AREA(c%+0,135 TO c%+10,145 TO c%+20,135)
52130 draw(c%+0,134 TO c%+20,134),1
52140 pena 5
52150 AREA (c%+9,148 TO c%+9,163 TO c%+4,163 TO c%+10,166 TO c%+16,163 TO c%+11,163 TO c%+11,148)
52160 NEXT j%
52170 DATA 8,9,70,10,11,147,12,13,222
52180 GOSUB 52540:GOSUB 52620:GOSUB 52700
52190 CIRCLE (10,181),5:pena 2:PAINT (10,181),0
52200 pena 4:PRINT at(19,185); "= QUIT";
52210 n%=10:n1%=18
52220 FOR y%=0 TO 1
52230 FOR x%=0 TO 15
52240 pena x%+(16*y%)
52250 a% = (x%*n1%)+10
52260 b% = y%*n%
52270 peno 1
52280 box(a%,b%;a%+n1%,b%+n%),1
52290 NEXT x%,y%
52300 done% = 1
52310 WHILE done% = 1
52320 pena 6
52330 ask MOUSE x%,y%,button%
52340 IF button% = 4 AND y% < 20 THEN GOSUB 52720
52350 IF button% = 4 AND y% > 20 THEN GOSUB 52430
52360 WEND
52370 peno 0
52380 FOR i%=0 TO 93
52390 box(0+i%,0+i%;316-i%,187-i%),0
52400 SLEEP(5000)
52410 NEXT i%
52420 graphic 0:CLOSE #1:cmd #0:GOSUB 52780:RETURN
52430 colr% = pixel(x%,y%)
52440 IF colr% >= 8 AND colr% <= 13 THEN ON colr%-7 GOSUB 52480,52510,52560,52590,52640,52670
52450 SLEEP(100000)
52460 IF colr% = 2 THEN done% = 0
52470 RETURN
52480 REM *** inc. red ***
52490 red% = red% + 1:IF red% > 15 THEN red% = 15
52500 GOTO 52530
52510 REM *** dec. red ***
52520 red% = red% - 1:IF red% < 0 THEN red% = 0
52530 rgb colreg%,red%,green%,blue%
52540 pena 8:PRINT at((10+70)-7,180);:PRINT USING "##";red%
52550 RETURN
52560 REM *** inc. green ***
52570 green% = green% + 1:IF green% > 15 THEN green% = 15
52580 GOTO 52610
52590 REM *** dec. green ***
52600 green% = green% - 1:IF green% < 0 THEN green% = 0
52610 rgb colreg%,red%,green%,blue%
52620 pena 4:PRINT at((10+147)-7,180);:PRINT USING "##";green%
52630 RETURN
52640 REM *** inc. blue ***
52650 blue% = blue% + 1:IF blue% > 15 THEN blue% = 15
52660 GOTO 52690
52670 REM *** dec. blue ***
52680 blue% = blue% - 1:IF blue% < 0 THEN blue% = 0
52690 rgb colreg%,red%,green%,blue%
52700 pena 12:PRINT at((10+222)-7,180);:PRINT USING "##";blue%
52710 RETURN
52720 colreg% = pixel (x%,y%)
52730 pena colreg%:peno 1
52740 box(10,25;298,110),1
52750 ask rgb colreg%,red%,green%,blue%
52760 GOSUB 52540:GOSUB 52620:GOSUB 52700
52770 RETURN
52780 ct=0
52790 FOR i%=0 TO 31
52800 ask rgb i%,red%,green%,blue%
52810 regsave%(ct)=red%:regsave%(ct+1)=green%:regsave%(ct+2)=blue%
52820 ct=ct+3
52830 NEXT i%
52840 bsave colorfile$,VARPTR(regsave%(0)),400
52850 RETURN
55000 REM **** CROSS HAIR ****
55010 drawmode 2
55020 x2%=x1%:y2%=y1%
55030 draw(x2%,0 TO x2%,187):draw(0,y2% TO 317,y2%)
55040 ask MOUSE x%,y%,b%:GOSUB 50000
55045 get a$:if a$="C" or a$="c" then gosub 13000:drawmode 2:goto 55040
55046 if a$<>"" then b%=4
55050 IF b%<>0 THEN draw(x2%,0 TO x2%,187):draw(0,y2% TO 317,y2%):x1%=x2%:y1%=y2%:RETURN
55060 IF x%=x2% AND y%=y2% THEN 55040
55070 draw(x2%,0 TO x2%,187):draw(0,y2% TO 317,y2%)
55080 x2%=x%:y2%=y%
55090 draw(x2%,0 TO x2%,187):draw(0,y2% TO 317,y2%)
55100 GOTO 55040
56000 REM **** BOX SHADOW ****
56010 drawmode 2
56030 box (x1%,y1%;x2%,y2%)
56040 ask mouse x%,y%,b%:gosub 50000
56050 if b%<>0 then box (x1%,y1%;x2%,y2%):x2%=x2%+1:y2%=y2%+1:return
56060 if x%=x2% and y%=y2% then 56040
56070 box (x1%,y1%;x2%,y2%)
56080 x2%=x%:y2%=y%
56090 box (x1%,y1%;x2%,y2%)
56100 goto 56040
58000 restore 58050
58010 for i%=1 to 19:read name$(i%):next i%:return
58050 data " A... Alter Colors"," B... Box"," C... Change Color"," D... Draw"," E... Ellipse"," F... Fill"," K... Load"," L... Line"
58052 data " M... Cycle Colors"," O... Circle"," Q... Quit"," R... Rays"," S... Save"," TB.. Big Text"," TS.. Small Text"
58054 data " U... Clear Screen"," X... Copy Shape"," Z... Show X & Y"," ?... This Menu"
60000 RESUME 17400
60010 colreg%=1:talk$=TRANSLATE$("TRY AGAIN!"):q%=narrate(talk$)
60020 RESUME 13120
61000 scnclr
61010 get a$:if a$="" then 61010
61015 ? asc(a$);",";
61020 goto 61010
