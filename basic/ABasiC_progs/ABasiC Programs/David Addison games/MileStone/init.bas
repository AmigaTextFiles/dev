10    ' ************************************
11    ' **                                **
12    ' **           MILESTONE            **
13    ' **               by               **
14    ' **         David Addison          **
15    ' **                                **
16    ' **        C  1986   v 1.0         **
17    ' **                                **
18    ' ************************************
100   clr:SCREEN 0,5:graphic 1:audio 15,1
110   dim picture%(11000),regsave%(100)
120   bload "milestone_main_pic",varptr(picture%(0))
130   bload "milestone_pic_dat",varptr(regsave%(0))
140   ct=0
150   for i%=0 to 31
160   rgb i%,regsave%(ct),regsave%(ct+1),regsave%(ct+2)
170   ct=ct+3
180   next i%
200   gshape(0,0),picture%()
210   ask mouse x%,y%,b%
220   if x%>58 and x%<157 and y%>1 and y%<12 and b%=4 then goto 1000
230   if x%>204 and x%<242 and y%>1 and y%<12 and b%=4 then chain "milestonegame"
240   goto 210
1000  scnclr:pena 1
1010  RESTORE 10000
1020  READ A$
1030  IF ASC(A$)>47 AND ASC(A$)<65 THEN GOSUB 2000:GOTO 1020:REM *** locate x,y
1040  IF ASC(A$)=38 THEN GOSUB 3000:GOTO 1020:REM **** '&' page full
1045  IF ASC(A$)=94 THEN GOTO 200:REM '^' end
1047  IF ASC(A$)=126 THEN GOTO 1100
1050  FOR i=1 TO LEN(A$):PRINT  MID$(A$,i,1);
1060  rem cx%=SOUND(1,1,3,40,INT(RND*700)+700):cx%=SOUND(2,1,3,40,INT(RND*1000)+1000)
1070  FOR w=1 TO INT(RND(8)*10)+2:NEXT w
1075  NEXT i
1080  goto 1020
1100  penb 19:read a$:for i=1 to len(a$):print inverse(1) mid$(a$,i,1);
1110  cx%=sound(1,1,3,40,int(rnd*700)+700):cx%=sound(2,1,3,40,int(rnd*1000)+1000)
1120  for w=1 to int(rnd(8)*10)+2:next w
1130  next i
1140  penb 0:goto 1020
2000  x%=VAL(A$):READ A$:y%=VAL(A$):if x%<3 then print at(x%*8,y%*8); else print at((x%-1)*8,y%*8);
2010  cx%=SOUND(1,1,50,65,500):FOR w=1 TO 15:NEXT w:RETURN
3000  penb 26:print at(4*8,23*8);:PRINT inverse(1) "Press `BUTTON' continue.";
3010  ask mouse x%,y%,b%:if b%=0 then 3010
3020  ?:scnclr:penb 1:return
10000 DATA 1,1,~,OBJECT:,5,3,The object of this game is to be,3,4
10010 DATA the first one to accumulate a total,3,5
10020 DATA of 1000 miles in each hand played.,1,8
10040 DATA ~,THE CARDS:,5,9
10060 DATA ~,A...HAZARD AND REMEDY CARDS,5,10
10080 DATA Hazard Cards are played onto your,3,11
10100 DATA opponents' pile and Remedy Cards are,3,12
10120 DATA played on your own pile. For each,3,13
10140 DATA Hazard Card there are corresponding,3,14
10160 DATA Remedy Cards.,5,16
10180 DATA ~,A ROLL CARD,17,16,must be displayed on,3,17
10200 DATA your Battle Pile before you can play,3,18
10220 DATA any Distance Cards. (For the one,3,19
10240 DATA exception to this rule," see paragraph",3,20
10260 DATA on RIGHT OF WAY CARD.),&
10270 DATA 5,1
10280 data~,A STOP CARD,17,1,is played only onto,3,2
10300 data your opponents' Roll Card to prevent,3,3
10320 data them from playing further Distance,3,4
10340 data Cards until they cover it with,3,5
10360 data another Roll Card on a subsequent,3,6
10380 data turn.,5,8
10400 data ~,A SPEED LIMIT CARD,24,8,is played onto,3,9
10410 data your opponents Speed Pile along side,3,10
10415 data their Battle Pile. While it is,3,11
10420 data exposed  your opponent can only,3,12
10425 data play 25 mile or 50 mile cards. As,3,13
10430 data long as no cards are on your Speed,3,14
10435 data Pile  you are not subject to any,3,15
10440 data speed limit.,5,17
10445 data ~,AN END OF LIMIT CARD,26,17,is played on,3,18
10450 data your own Speed Pile  on a Speed,3,19
10455 data Limit Card  to permit you to resume,3,20
10460 data speed and play any mileage cards,3,21
10465 data including 75 100 and 200 mile cards.,&
10470 data 5,1
10475 data ~,AN OUT OF GAS CARD,24,1,is played onto,3,2
10480 data your opponents' Roll Card. They,3,3
10485 data cannot play further Distance Cards,3,4
10490 data until they have first played a,3,5
10495 data GAS CARD and then a Roll Card,3,6
10498 data on subsequent turns.,5,8
10500 data ~,A FLAT TIRE CARD,22,8,is played onto,3,9
10505 data your opponents' Roll Card. They,3,10
10510 data cannot play further Distance Cards,3,11
10515 data until they have first played a,3,12
10520 data SPARE TIRE CARD and then a Roll Card,3,13
10525 data on subsequent turns.,5,15
10530 data ~,AN ACCIDENT CARD,22,15,is played onto,3,16
10535 data your opponents' Roll Card. They,3,17
10540 data cannot play further Distance Cards,3,18
10545 data until they have first played a,3,19
10550 data REPAIR CARD and then a Roll Card on,3,20
10555 data subsequent turns.,&
10560 data 5,1
10565 data ~,B...SAFETY CARDS,22,1,--Safety Cards,3,2
10570 data are played in your own Safety Area,3,3
10575 data and prevent you from being stopped,3,4
10580 data by the corresponding Hazard Cards,3,5
10585 data for the balance of the hand. As,3,6
10590 data soon as a safety is played  it,3,7
10595 data prevents any further attack and,3,8
10600 data cancels the attack in progress.,&
10625 data 5,1
10630 data ~,RIGHT OF WAY CARD:,3,2
10635 data When displayed in your Safety Area,3,3
10640 data your opponent can't play a Stop Card,3,4
10645 data on your Battle Pile and can't play a,3,5
10650 data Speed Limit Card on your Speed Pile.,5,6
10685 data ~,EXTRA TANK CARD:,3,7
10690 data When displayed in your Safety Area,3,8
10695 data your opponent cannot play an Out,3,9
10700 data of Gas Card onto your Battle Pile.,5,10
10705 data ~,PUNCTURE PROOF CARD:,3,11
10710 data When displayed in your Safety Area,3,12
10715 data your opponent cannot play a,3,13
10720 data Flat Tire Card on you.,5,14
10725 data ~,DRIVING ACE:,3,15
10730 data When displayed in your Safety Area,3,16
10735 data your opponent cannot play an,3,17
10740 data Accident Card on you.,&
10745 data 5,1
10750 data ~,COUP FOURRE:,3,2
10755 data (pronounced Coo-Foo-Ray),3,3
10760 data If your opponent plays a Hazard,3,4
10765 data Card and you hold the corresponding,3,5
10770 data Safety Card in your hand you may,3,6
10775 data call `COUP FOURRE' and immediately,3,7
10780 data play the Safety Card to your,3,8
10785 data Safety Area and recieve a 300,3,9
10790 data point bonus.,5,11
10800 data ~,SCORING:,3,12
10805 data Each person scores as many points,3,13
10810 data as the total number of miles that,3,14
10815 data they have traveled.,3,16
10820 data Each Safety Card played = 100 points,3,18
10825 data Each Coup Fourre = 300 points.,3,20
10830 data Bonus for making 1000 miles = 400.,3,22
10835 data Shut out = 500 points.,&
10840 data 5,1
10850 data ~,USING THE MOUSE:,3,2
10855 data Point to PLAY or DISCARD with the,3,3
10860 data mouse and press Left Button  then,3,4
10865 data point to the card you want to use,3,5
10870 data and press Left Button again.,5,7
10875 data To remove Message at top of,3,8
10880 data screen press Left Button.,5,10
10885 data Answer Yes or No questions with,3,11
10890 data the Keyboard.,10,13
10895 data ~," HAVE FUN !!!!!",&,^
30000 GOTO 30000
