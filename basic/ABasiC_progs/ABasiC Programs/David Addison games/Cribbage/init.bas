1     rem ** written by David Addison -- (503)-645-6985 -- c1985 -- this program has been put into the public domain -- use kickstart 1.0
2     clr:screen 0,5:graphic 1:drawmode 0
3     dim cribscreen%(10000),regsave%(100),clubs%(450),spades%(450),hearts%(450),diamonds%(450),clubs2%(450),spades2%(450),hearts2%(450),diamonds2%(450)
4     dim back1%(450),back2%(450),computer%(60),human%(60),computerb%(60),humanb%(60),mycrib%(350),yourcrib%(350)
5     dim points%(350),pointer%(60),pointerb%(60),updown%(300),updownb%(300),backerase%(220),carderase%(360)
6     dim gobox%(125),goboxb%(125),donebox%(150),doneboxb%(150),winner%(3500)
7     dim pegpos(121),w(6,4),m(6,4),j(52),v(15,7),i(52),d(52,4),y(6,5),c(4,4),d$(6),q(11,6),r(4,5),s(4),card(6):humcolor=20:compcolor=0
10    bload "cribscreen_dat",varptr(regsave%(0)):n=0
12    i%=0
13    rgb i%,regsave%(n),regsave%(n+1),regsave%(n+2)
14    n=n+3
15    i%=i%+1:if i%<32 then 13
17    pena 6:? at(5,5*8);"Please STANDBY while I set things up."
20    gosub 32000
50    dim sinewave%(11):restore 60:for cx%=0 to 11:read sinewave%(cx%):next cx%
60    data 100,90,60,100,90,60,-100,90,-60,-100,-90,-60
62    audio 15,1:wave 6,sinewave%
100   nl$="A23456789TJQK"
105   me=0:you=0
110   gosub 30000:gosub 32200
112   gosub 17000:msg$=" Use MOUSE for all player INPUT !":pena 18:gosub 7010:sleep(2*10^6)
113   gosub 12000
135   restore 10000
140   for n=1 to 15:for m=1 to 7:read v(n,m):next m:next n
150   for n=1 to 11:for m=1 to 6:read q(n,m):next m:next n
160   for n=1 to 4:for m=1 to 5:read r(n,m):next m:next n
170   n=1
172   read s(n)
175   n=n+1:if n<5 then 172
180   n=1
182   read d$(n)
185   n=n+1:if n<7 then 182
300   s1=0:s2=0
320   gosub 5660:gosub 5820:cut=1
350   if cut=1 then cut=0:goto 360
355   gosub 5660
360   gosub 6100
380   gosub 3400
400   i1=v(b9,5):i2=v(b9,6)
420   gosub 17000:msg$="YOUR DISCARDS? (CHOOSE 2 CARDS)":pena humcolor:gosub 7010
430   right=6:gosub 25000:i3=q1:i4=q2
525   y(i3,5)=0:y(i4,5)=0
530   gosub 23000:cnt=4:gosub 32600
535   cnt2=27:gosub 22000:cx=8:cy=119
537   n=1
540   if y(n,5)=0 then 550
542   num=y(n,4):suit=y(n,3):gosub 21000
545   cx=cx+35
550   n=n+1:if n<7 then 540
560   j=1
570   c(1,j)=m(i1,j):c(2,j)=m(i2,j):c(3,j)=y(i3,j):c(4,j)=y(i4,j)
572   j=j+1:if j<5 then 570
575   for k=1 to 3
576   for l=k+1 to 4
577   if c(k,4)>c(l,4) then 581
578   for i=1 to 4
579   swap c(k,i),c(l,i)
580   next i
581   next l:next k
630   gosub 4200
650   gosub 1490
670   gosub 24000
675   if m=0 then 710
680   gosub 17000:msg$="[ YOU SCORE FIRST ]":pena humcolor:gosub 7010:gosub 8010:x1=1:goto 930
710   gosub 17000:msg$="[ I SCORE FIRST ]":pena compcolor:gosub 7010:gosub 8010:x1=2:goto 1200
740   gosub 17000:msg$="- - the crib contains - -":pena 29:gosub 7010
745   gosub 22000:cx=8:cy=119:j=0
750   n=1
765   num=c(n,4):suit=c(n,3):gosub 21000
770   cx=cx+35
775   n=n+1:if n<5 then 765
780   q1=0:for i=1 to 4
790   for j=1 to 4
800   w(i,j)=c(i,j)
810   next j:next i
830   c=1:w(5,4)=t9
850   gosub 4420
860   on x1 goto 870,910
870   gosub 17000:pena 18:? at(2*8,175);"The crib has  ";p;"  points.  ";
880   r=p:if r<>0 then gosub 9010
881   pena 29:? at(12*8,183);inverse (1) "PRESS":? at(18*8,183); "button to continue."
882   ask mouse x%,y%,b%:if b%<>4 then 882
900   goto 1370
910   x1=3
920   goto 1050
930   k=1
940   i=1
950   if i=i3 then 1000
960   if i=i4 then 1000
970   for j=1 to 4
980   w(k,j)=y(i,j)
990   next j
991   k=k+1
1000  i=i+1:if i<7 then 950
1010  q1=0:gosub 17000:msg$="..... YOUR CARDS .....":pena humcolor:gosub 7010
1011  cnt2=17:gosub 22000:cx=8:cy=119
1012  n=1
1013  if n=i3 or n=i4 then 1016
1014  num=y(n,4):suit=y(n,3):gosub 21000
1015  cx=cx+35
1016  n=n+1:if n<7 then 1013
1020  w(5,4)=t9:c=0
1040  gosub 4420
1050  if c=0 then gosub 17000:pena 18:msg$="How many points do you have?":gosub 7010
1055  if c=1 then gosub 17000:pena 18:msg$="How many points are in the crib?":gosub 7010
1060  gosub 27000
1070  d=p-p9
1080  if d>=0 then 1110
1090  gosub 17000:msg$="Not with that hand. TRY AGAIN !":pena 3:gosub 7010:gosub 8010
1100  goto 1050
1110  r=p9:if r<>0 then gosub 9040
1140  if d=0 then 1190
1150  gosub 17000:pena 25:? at(5*8,175);inverse(1) " MUGGINS ":? at(14*8,175);" for  ";d;"  points.";
1170  r=d:gosub 9010
1171  pena 29:? at(12*8,183);inverse(1) "PRESS":? at(18*8,183);"button to continue."
1172  ask mouse x%,y%,b%:if b%<>4 then 1172
1190  on x1 goto 1200,740,1370
1200  for k=1 to 4
1210  l=v(b9,k)
1220  for j=1 to 4
1230  w(k,j)=m(l,j)
1240  next j:next k
1260  for k=1 to 4:l=w(k,1):next k
1280  gosub 17000:msg$="..... MY CARDS .....":pena compcolor:gosub 7010
1281  cnt2=17:gosub 22000:cx=8:cy=119
1282  n=1
1284  num=w(n,4):suit=w(n,3):gosub 21000
1285  cx=cx+35
1286  n=n+1:if n<5 then 1284
1290  w(5,4)=t9:c=0:gosub 4390
1320  gosub 17000:pena compcolor:? at(5*8,175);"I have  ";p;"  points.";
1340  r=p:if r<>0 then gosub 9010
1341  pena 29:? at(12*8,183);inverse(1) "PRESS":? at(18*8,183);"button to continue."
1342  ask mouse x%,y%,b%:if b%<>4 then 1342
1360  on x1 goto 740,930
1370  gosub 6390
1380  gosub 22000:for i=100 to 116:draw(50,i to 134,i),0:next i:cxx=9:cyy=63:gosub 32700:goto 350
1400  gosub 17000
1410  gshape(46,63),winner%():pena compcolor:? at(92,81);"I WIN THIS GAME":goto 1460
1430  gosub 17000
1440  gshape(46,63),winner%():pena 19:? at(84,81);"YOU WIN THIS GAME"
1445  cx=1
1446  cy=5000
1447  n=sound(1,1,50,65,cy):n=sound(2,1,50,65,cy)
1448  sleep (10000)
1449  cy=cy-300:if cy>=100 then 1447
1450  cx=cx+1:if cx<=4 then 1446
1460  gosub 1470
1462  ask mouse x%,y%,b%:n=pixel(x%,y%)
1463  if b%=4 and (n=8 or n=19) then 1480
1467  sleep(30000):goto 1462
1470  pena 29
1471  ? at(7*8,175);inverse(1) "===== RUNNING TOTAL =====";inverse(0) " "
1472  ? at(2*8,183);inverse(1) "COMPUTER";inverse(0) " =";me;"GAMES   ";inverse(1) "YOU";inverse(0) " =";you;"GAMES"
1473  gosub 12000:return
1480  if n=19 then scnclr:end
1482  gosub 32200:gosub 12000:goto 300
1490  y5=0:m5=0:c=0:s9=0:g=0:right=5
1500  if m=0 then 1910
1510  if y5<>4 then 1540
1520  if m5=4 then 2470
1530  goto 1910
1540  gosub 17000:pena humcolor:msg$="Your play. Select a card.":gosub 7010
1550  gosub 25000:gosub 17000
1560  if c$<>"GO" then 1680
1570  x=31-s9
1575  n=1
1578  if y(n,5)=0 then 1590
1580  if y(n,4)<=x then 1600
1590  n=n+1:if n<7 then 1578
1595  goto 1910
1600  gosub 17000:msg$="SHAME ! SHAME !  You have a play !!!":pena 3:gosub 7010:gosub 8010:goto 1540
1680  c6=val(c$):if s9+y(c6,2)>31 then 1890
1690  s9=s9+y(c6,2):y5=y5+1:i(10+y5)=c6:c=c+1:right=right-1:j(c)=y(c6,4):mg$="You ":cx=humcolor:gosub 2960:gosub 6390
1700  if x31=1 then msg$="You get  2  points for 31":pena humcolor:gosub 7010
1750  y(c6,5)=0:cnt2=17:gosub 22000
1752  if y5=1 or cx1=164 then cx1=164:cy1=108:cx=cx1:cy=cy1:num=y(c6,4):suit=y(c6,3):gosub 21000:cx1=cx1+20:goto 1754
1753  zz=0:cx=cx1:cy=cy1:num=y(c6,4):suit=y(c6,3):gosub 21100:cx1=cx1+20
1754  r=p:if r<>0 then gosub 9040
1755  cx=8:cy=119:for n=1 to 6
1756  if y(n,5)=0 then 1759
1757  num=y(n,4):suit=y(n,3):gosub 21000
1758  cx=cx+35
1759  next n
1780  f=1
1820  if s9<>31 then 1910
1830  gosub 24000:cx1=164:cx2=164:f=0:c=0:s9=0:g=0:gosub 6390:goto 1910
1890  gosub 17000:msg$="That totals more than 31, TRY AGAIN!":pena 3:gosub 7010
1900  gosub 8010:goto 1540
1910  if m5<>4 then 2050
1920  if y5=4 then 2470
1930  if c$<>"GO" then 1510
1935  cx1=164:cx2=164
1940  if f=2 then 2000
1950  gosub 17000:pena humcolor:msg$="You get 1 point for last card.":gosub 7010
1960  r=1:gosub 9040:gosub 24000
1980  f=0:c=0:s9=0:gosub 6390
1990  goto 1510
2000  gosub 17000:pena compcolor:msg$="I get 1 point for last card.":gosub 7010
2010  r=1:gosub 9010:gosub 24000
2030  f=0:c=0:s9=0:gosub 6390
2040  goto 1510
2050  k9=0:p9=0:c9=c:c=c+1:h9=s9
2090  for i9=1 to 6
2100  i(i9)=0
2110  if i9=i1 then 2250
2120  if i9=i2 then 2250
2130  if m5=0 then 2170
2140  for j9=1 to m5
2150  if i9=i(20+j9) then n=1:j9=m5
2160  next j9:if n=1 then n=0:goto 2250
2170  if h9+m(i9,2)>31 then 2250
2180  k9=k9+1:s9=h9+m(i9,2):j(c)=m(i9,4):mg$="no":pena compcolor:gosub 2960
2220  if p>p9 then p9=p
2230  i(i9)=p:i(k9+30)=i9
2250  next i9
2260  c=c9:s9=h9
2280  if k9<>0 then 2570
2290  if c$<>"GO" then 2360
2300  if g=1 then 2370
2310  gosub 17000:pena compcolor:msg$="I get 1 point for last card.":gosub 7010
2320  c=0:s9=0:r=1:gosub 9010:gosub 24000:gosub 6390:cx1=164:cx2=164
2350  goto 1510
2360  if y5<>4 then 2430
2370  gosub 17000:pena humcolor:msg$="I'll give you 1 point for last card.":gosub 7010
2380  r=1:gosub 9040:gosub 24000:cx1=164:cx2=164
2400  c=0:s9=0:g=0:gosub 6390:c$="":goto 1910
2430  if g=1 then 1510
2440  gosub 17000:msg$="GO":pena 29:gosub 7010:g=1
2460  gosub 8010:goto 1510
2470  if f=0 then 2560
2475  cx1=164:cx2=164
2480  if f=1 then 2530
2490  gosub 17000:pena compcolor:msg$="I get 1 point for last card.":gosub 7010
2500  r=1:gosub 9010:gosub 24000:s9=0:gosub 6390
2520  goto 2560
2530  gosub 17000:pena humcolor:msg$="You get 1 point for last card.":gosub 7010
2540  r=1:gosub 9040:gosub 24000:s9=0:gosub 6390
2560  return
2570  c=c+1:m5=m5+1
2590  if c<>1 then 2740
2600  j7=1
2610  i9=v(b9,j7)
2620  vv=1
2630  if i(vv+20)=i9 then 2710 
2635  vv=vv+1:if vv<=m5+1 then 2630
2650  if m(i9,2)=5 then 2710
2660  i(m5+20)=i9:j(c)=m(i9,4):p9=0:s9=m(i9,2):goto 2810
2710  j7=j7+1:if j7<5 then 2610
2720  l=v(b9,1)
2730  goto 2660
2740  j8=1
2750  i9=i(j8+30)
2760  if i(i9)=p9 then 2780
2770  j8=j8+1:if j8<=k9 then 2750
2780  i(m5+20)=i9:j(c)=m(i9,4):s9=s9+m(i9,2)
2810  gosub 17000:msg$="MY PLAY":pena compcolor:gosub 7010:gosub 8010
2820  gosub 23000:cnt=cnt-1:gosub 32600
2822  if m5=1 or cx2=164 then cx2=164:cy2=63:cx=cx2:cy=cy2:num=m(i9,4):suit=m(i9,3):gosub 21000:cx2=cx2+20:goto 2840
2823  cx=cx2:cy=cy2:num=m(i9,4):suit=m(i9,3):gosub 21100:cx2=cx2+20
2840  f=2:gosub 6390:gosub 17000:mg$="I ":cx=compcolor:gosub 2960:r=p
2850  if s9=31 then gosub 17000:msg$="I get  2  points for 31 !":pena compcolor:gosub 7010
2860  if r<>0 then gosub 9010
2870  if s9<>31 then 2900
2880  gosub 24000:cx1=164:cx2=164:f=0:c=0:s9=0:gosub 6390:goto 1510
2900  if c$="GO" then 1910
2910  goto 1510
2960  p=0:x31=0
2970  if c=1 then 3200
2980  if s9<>15 then 3010
2990  p=p+2:if mg$<>"no" then msg$=mg$+"get 2 points for FIFTEEN.":gosub 17000:pena cx:gosub 7010:gosub 8010
3000  goto 3030
3010  if s9<>31 then 3030
3020  p=p+2:x31=1
3030  if c-2>2 then n=c-2:goto 3040
3035  n=2
3040  j=0:for i=c to n step -1
3050  if j(i)<>j(i-1) then if mg$<>"no" then 3125 else goto 3140
3060  on c-i+1 goto 3070,3090,3110
3070  p=p+2:j=1
3080  goto 3120
3090  p=p+4:j=2
3100  goto 3120
3110  p=p+6:j=3
3120  next i
3122  if mg$="no" then 3140
3125  if j=1 then msg$=mg$+"get 2 points for a PAIR."
3130  if j=2 then msg$=mg$+"get 6 points for THREE of a KIND."
3135  if j=3 then msg$=mg$+"get 12 points for FOUR of a KIND."
3137  if j<>0 then gosub 17000:pena cx:gosub 7010:gosub 8010
3140  if c=2 then 3200
3150  r9=0
3160  i=3
3162  gosub 3210
3164  i=i+1:if i<=c then 3162
3190  p=p+r9
3195  if r9<>0 then if mg$<>"no" then msg$=mg$+"get "+str$(r9)+" points for a "+str$(r9)+" card RUN.":gosub 17000:pena cx:gosub 7010
3200  return
3210  j=11
3212  j(j)=14
3214  j=j+1:if j<=20 then 3212
3220  j=1
3222  j(j+10)=j(c-j+1)
3224  j=j+1:if j<=c then 3222
3240  k=1
3250  l=k+1
3260  if j(k+10)<j(l+10) then 3300
3270  x=j(k+10):j(k+10)=j(l+10):j(l+10)=x
3300  l=l+1:if l<=i then 3260
3310  k=k+1:if k<=i-1 then 3250
3320  k=1
3330  if j(k+10)<>j(k+11)-1 then 3360
3340  k=k+1:if k<=i-1 then 3330
3350  r9=i
3360  return
3400  p9=0
3410  n=1:z9=1
3420  i1=v(z9,1):i2=v(z9,2):i3=v(z9,3):i4=v(z9,4)
3430  gosub 13000
3460  q1=0:j=1
3470  w(1,j)=m(i1,j)
3480  w(2,j)=m(i2,j)
3490  w(3,j)=m(i3,j)
3500  w(4,j)=m(i4,j)
3510  w(5,j)=25
3520  j=j+1:if j<5 then 3470
3540  c=0
3550  gosub 4390
3560  v(z9,7)=p
3570  if p>p9 then p9=p
3580  z9=z9+1:if z9<16 then 3420
3600  j=0
3610  i=1
3620  if v(i,7)<>p9 then 3650
3630  j=j+1:i(j)=i
3650  i=i+1:if i<16 then 3620
3660  if j>1 then 3720
3680  b9=i(1)
3690  gosub 14000:return
3720  c9=5:z=1:goto 3960
3760  n=1:c9=8:z=2:goto 3960
3800  c9=7:z=3:goto 3960
3840  c9=11:z=4:goto 3960
3880  c9=1:z=5:goto 3960
3920  b9=int(j*rnd)+1
3930  b9=i(b9):gosub 14000:return
3960  p9=0
3965  gosub 13000
3970  i=1
3972  j(i)=0
3974  i=i+1:if i<16 then 3972
4000  i=1
4010  k=1
4020  l=v(i(i),k)
4030  if m(l,4)<>c9 goto 4050
4040  j(i)=j(i)+1
4050  k=k+1:if k<5 then 4020
4060  if j(i)>p9 then p9=j(i)
4070  i=i+1:if i<=j then 4010
4080  k=0
4090  i=1
4100  if j(i)<>p9 then 4130
4110  k=k+1:b9=i(i)
4130  i=i+1:if i<=j then 4100
4140  if k<>1 then 4160
4150  gosub 14000:return
4160  on z goto 3760,3800,3840,3880,3920
4200  n=int(rnd*38)+14
4210  gosub 17000:msg$="THE UPCARD IS....":pena 29:gosub 7010
4220  cx=9:cy=63:num=d(n,4):suit=d(n,3):gosub 21000:q1=0:gosub 8010
4240  i=1
4242  w(5,i)=d(n,i)
4244  i=i+1:if i<5 then 4242
4270  t9=w(5,4)
4280  if w(5,4)<>11 then 4370
4290  if m=0 then 4340
4300  gosub 17000:msg$="TWO POINTS TO ME.":pena compcolor:gosub 7010
4310  r=2:gosub 9010
4330  return
4340  gosub 17000:msg$="TWO POINTS TO YOU.":pena humcolor:gosub 7010
4350  r=2:gosub 9040
4370  return
4390  rem
4420  p=0
4430  rem
4440  i=1
4450  if w(i,4)<>11 goto 4490
4460  if w(i,3)<>w(5,3) goto 4490
4470  p=p+1
4480  goto 4500
4490  i=i+1:if i<5 then 4450
4500  rem
4510  i=1
4520  if w(i,3)<>w(i+1,3) goto 4620
4530  i=i+1:if i<4 then 4520
4540  rem
4550  if c<>0 goto 4600
4560  p=p+4
4570  if w(4,3)<>w(5,3) goto 4620
4580  p=p+1
4590  goto 4620
4600  if w(4,3)<>w(5,3) goto 4620
4610  p=p+5
4620  rem
4630  i=1
4640  j=i+1
4650  if w(i,2)+w(j,2)<>15 goto 4670
4660  p=p+2
4670  j=j+1:if j<6 then 4650
4680  i=i+1:if i<5 then 4640
4690  rem
4700  i=1
4710  j=i+1
4720  k=j+1
4730  if w(i,2)+w(j,2)+w(k,2)<>15 goto 4750
4740  p=p+2
4750  k=k+1:if k<6 then 4730
4760  j=j+1:if j<5 then 4720
4770  i=i+1:if i<4 then 4710
4780  rem
4790  i=1
4800  j=i+1
4810  k=j+1
4820  l=k+1
4830  if (w(i,2)+w(j,2)+w(k,2)+w(l,2))<>15 goto 4850
4840  p=p+2
4850  l=l+1:if l<6 then 4830
4860  k=k+1:if k<5 then 4820
4870  j=j+1:if j<4 then 4810
4880  i=i+1:if i<3 then 4800
4890  rem
4900  s=0
4910  i=1
4920  s=s+w(i,2)
4930  i=i+1:if i<6 then 4920
4940  if s<>15 goto 4960
4950  p=p+2
4960  rem
4970  i=1
4980  j(i)=0
4990  i=i+1:if i<14 then 4980
5000  i=1
5010  j=w(i,4)
5020  j(j)=j(j)+1
5030  i=i+1:if i<6 then 5010
5040  i=1
5050  on j(i)+1 goto 5090,5090,5080,5070,5060
5060  p=p+6
5070  p=p+4
5080  p=p+2
5090  i=i+1:if i<14 then 5050
5100  rem
5110  for i=1 to 5
5120  for j=i to 5
5130  if w(i,4)<=w(j,4) goto 5150
5140  swap w(i,4),w(j,4)
5150  next j
5160  next i
5170  rem
5180  d=w(1,4)-q(1,1)
5190  i=1
5200  j=1
5210  q(i,j)=q(i,j)+d
5220  j=j+1:if j<6 then 5210
5230  i=i+1:if i<12 then 5200
5240  i=1
5250  j=1
5260  if w(j,4)<>q(i,j) goto 5310
5270  j=j+1:if j<6 then 5260
5280  rem
5290  p=p+q(i,6)
5300  return
5310  i=i+1:if i<12 then 5250
5320  rem
5330  l=1
5340  d=w(l,4)-r(1,1)
5350  i=1
5360  j=1
5370  r(i,j)=r(i,j)+d
5380  j=j+1:if j<5 then 5370
5390  i=i+1:if i<5 then 5360
5400  i=1
5410  k=1
5420  if w(k+l-1,4)<>r(i,k) goto 5470
5430  k=k+1:if k<5 then 5420
5440  rem
5450  p=p+r(i,5)
5460  return
5470  i=i+1:if i<5 then 5410
5480  l=l+1:if l<3 then 5340
5490  rem
5500  l=1
5510  d=w(l,4)-s(1)
5520  i=1
5530  s(i)=s(i)+d
5540  i=i+1:if i<4 then 5530
5550  i=1
5560  if w(l+i-1,4)<>s(i) goto 5610
5570  i=i+1:if i<4 then 5560
5580  rem
5590  p=p+s(4)
5600  return
5610  l=l+1:if l<4 then 5510
5620  return
5660  gosub 17000:msg$="SHUFFLING":pena 25:gosub 7010
5665  randomize -1
5670  for j=0 to 51:i(j)=j:next j
5690  for j=51 to 1 step -1
5700  k=int(rnd*(j+1))
5710  swap i(j),i(k)
5720  next j
5730  i=1
5740  j=i(i-1)+1
5750  d(i,1)=j
5755  d(i,3)=int((j-1)/13)+1
5760  d(i,4)=j-13*int((j-1)/13)
5765  if d(i,4)<10 then d(i,2)=d(i,4):goto 5775
5770  d(i,2)=10
5775  i=i+1:if i<53 then 5740
5780  return
5820  gosub 17000:msg$="Press BUTTON to cut for deal.":pena 18:gosub 7010
5830  ask mouse x%,y%,b%:if b%<>4 then 5830
5880  randomize -1:i=int(rnd*52)+1
5890  gosub 17000:msg$="YOUR card is ........":pena humcolor:gosub 7010
5900  cx=43:cy=119:num=d(i,4):suit=d(i,3):gosub 21000:gosub 8010
5910  randomize -1:j=int(rnd*52)+1
5920  if j=i then 5910
5930  gosub 17000:msg$="MY card is ..........":pena compcolor:gosub 7010
5940  cx=113:cy=119:num=d(j,4):suit=d(j,3):gosub 21000:gosub 8010
5950  if d(i,4)<d(j,4) then m=1:gosub 17000:msg$="YOUR CRIB......":pena humcolor:gosub 7010:gosub 8010:goto 6000
5960  if d(j,4)<d(i,4) then m=0:gosub 17000:msg$="MY CRIB........":pena 0:gosub 7010:gosub 8010:goto 6000
5970  gosub 17000:msg$="please cut again":pena 29:gosub 7010:gosub 8010:cnt2=19:gosub 22000:goto 5820
6000  cnt2=19:gosub 22000:return
6100  r=0:s9=0:gosub 6390
6110  if m=0 then gshape(50,100),mycrib%():goto 6120
6115  gshape(50,100),yourcrib%()
6120  m=1-m:y=1-m
6150  gosub 17000:msg$=" - - YOUR CARDS ARE - -":pena humcolor:gosub 7010
6160  cx=8:cy=119:cxx=269:cyy=63
6170  n=1
6180  k=2*n-y:l=2*n-m
6200  i=1
6240  m(n,i)=d(k,i):y(n,i)=d(l,i):y(n,5)=1
6250  i=i+1:if i<5 then 6240
6255  n=n+1:if n<7 then 6180
6265  k=1
6266  l=k+1
6267  if y(k,4)>y(l,4) then 6271
6268  i=1
6269  x=y(k,i):y(k,i)=y(l,i):y(l,i)=x
6270  i=i+1:if i<5 then 6269
6271  l=l+1:if l<7 then 6267
6273  k=k+1:if k<6 then 6266
6275  cnt=1
6284  for n=1 to 6:if m=1 then if cnt=1 then gosub 32605 else gosub 32625
6285  num=y(n,4):suit=y(n,3):gosub 21000:cx=cx+35:if m=0 then if cnt=1 then gosub 32605 else gosub 32625
6286  cnt=2:next n
6288  gosub 17000:pena 25:? at(8*2,175);inverse(1) "=STUDY YOUR HAND=":? at(20*8,175);" while I'm gone":cnt=6
6289  return
6390  drawmode 1:pena 6:penb 7:locate(84,83):print using "##";s9:drawmode 0
6395  return
7010  msg=int(len(msg$)/2)
7015  print at(8*(19-msg),175);msg$
7030  return
8010  sleep(1.5*10^6)
8030  return
9010  mpeg=3-mpeg:q1=0:q2=s1
9011  if mpeg=1 and q4<>0 then gshape(mp1x,mp1y),computerb%()
9012  if mpeg=1 then mp1x=mp2x:mp1y=mp2y
9013  if mpeg=2 then gshape(mp2x,mp2y),computerb%():mp2x=mp1x:mp2y=mp1y
9014  for peg=s1+1 to s1+r
9015  on mpeg gosub 9020,9025:pena 8:penb 21:drawmode 1:locate (37,33):print using "###";peg:drawmode 0
9016  x%=sound(1,1,2,60,7000):x%=sound(2,1,2,60,7000):sleep(200000)
9019  next peg:s1=s1+r:q4=1:gosub 8010:return
9020  xx=mp1x:yy=mp1y:gosub 9030:mp1x=xx+pegpos(peg):mp1y=yy:return
9025  xx=mp2x:yy=mp2y:gosub 9030:mp2x=xx+pegpos(peg):mp2y=yy:return
9030  if peg=121 then gshape(xx,yy),computerb%():gshape(11,yy),computer%():me=me+1:goto 1400
9032  if peg=31 or peg=91 then yy=yy+8:if q2<>30 and q2<>90 then gshape(xx,yy-8),computerb%()
9033  if peg=61 then yy=yy-8:if q2<>60 then gshape(xx,yy+8),computerb%()
9034  if q1<>0 then gshape(xx,yy),computerb%()
9035  q1=1:gshape(xx+pegpos(peg),yy),computer%():return
9040  ypeg=3-ypeg:q1=0:q2=s2
9041  if ypeg=1 and q5<>0 then gshape(yp1x,yp1y),humanb%()
9042  if ypeg=1 then yp1x=yp2x:yp1y=yp2y
9043  if ypeg=2 then gshape(yp2x,yp2y),humanb%():yp2x=yp1x:yp2y=yp1y
9044  for peg=s2+1 to s2+r
9045  on ypeg gosub 9050,9055:pena 19:penb 21:drawmode 1:locate (255,33):print using "###";peg:drawmode 0
9046  x%=sound(1,1,2,60,2000):x%=sound(2,1,2,60,2000):sleep(200000)
9049  next peg:s2=s2+r:q5=1:gosub 8010:return
9050  xx=yp1x:yy=yp1y:gosub 9060:yp1x=xx+pegpos(peg):yp1y=yy:return
9055  xx=yp2x:yy=yp2y:gosub 9060:yp2x=xx+pegpos(peg):yp2y=yy:return
9060  if peg=121 then gshape(xx,yy),humanb%():gshape(11,yy),human%():you=you+1:goto 1430
9062  if peg=31 or peg=91 then yy=yy-8:if q2<>30 and q2<>90 then gshape(xx,yy+8),humanb%()
9063  if peg=61 then yy=yy+8:if q2<>60 then gshape(xx,yy-8),humanb%()
9064  if q1<>0 then gshape(xx,yy),humanb%()
9065  q1=1:gshape(xx+pegpos(peg),yy),human%():return
10000 data 1,2,3,4,5,6,0,1,2,3,5,4,6,0,1,2,3,6,4,5,0
10002 data 1,2,4,5,3,6,0,1,2,4,6,3,5,0,1,2,5,6,3,4,0
10004 data 1,3,4,5,2,6,0,1,3,4,6,2,5,0,1,3,5,6,2,4,0
10006 data 1,4,5,6,2,3,0,2,3,4,5,1,6,0,2,3,4,6,1,5,0
10008 data 2,3,5,6,1,4,0,2,4,5,6,1,3,0,3,4,5,6,1,2,0
10010 data 1,1,1,2,3,09,1,1,2,2,3,12,1,1,2,3,3,12
10012 data 1,1,2,3,4,08,1,2,2,2,3,09,1,2,2,3,3,12
10014 data 1,2,2,3,4,08,1,2,3,3,3,09,1,2,3,3,4,08
10016 data 1,2,3,4,4,08,1,2,3,4,5,05
10018 data 1,1,2,3,6,1,2,2,3,6,1,2,3,3,6,1,2,3,4,4
10020 data 1,2,3,3
10022 data 1,2,3,4,5,6
11000 rem
12000 mpeg=2:ypeg=2:mp1x=11:mp1y=9:mp2x=11:mp2y=9:yp1x=11:yp1y=45:yp2x=11:yp2y=45:q4=0:q5=0:return
13000 rgb 22,regsave%(n*3),regsave%(n*3+1),regsave%(n*3+2)
13010 n=n+2
13020 return
14000 rgb 22,regsave%(66),regsave%(67),regsave%(68)
14010 return
17000 drawmode 0:peno 19:pena 12:paint(2,184),0
17010 return
21000 for q=0 to 64 step 16:qq=sound(1,1,2,q,5000):qq=sound(2,1,2,q,4000):next q
21010 on suit gosub 21050,21060,21070,21080
21020 pena 18:? at(cx+4,cy+8);mid$(nl$,num,1):? at(cx+23,cy+38);mid$(nl$,num,1)
21040 return
21050 gshape(cx,cy),spades%():return
21060 gshape(cx,cy),clubs%():return
21070 gshape(cx,cy),hearts%():return
21080 gshape(cx,cy),diamonds%():return
21100 for q=0 to 64 step 16:qq=sound(1,1,2,q,5000):qq=sound(2,1,2,q,4000):next q
21110 on suit gosub 21150,21160,21170,21180
21120 pena 18:? at(cx+4,cy+8);mid$(nl$,num,1):? at(cx+23,cy+38);mid$(nl$,num,1)
21140 return
21150 gshape(cx,cy),spades2%():return
21160 gshape(cx,cy),clubs2%():return
21170 gshape(cx,cy),hearts2%():return
21180 gshape(cx,cy),diamonds2%():return
22000 for n=cnt2+1 to 1 step -1:gshape(n*8,119),carderase%():next n
22030 return
23000 for n=13 to 1 step -1:gshape(269,62+((n-1)*8)),backerase%():next n
23030 return
24000 for n=32 to 20 step -1:gshape(n*8,108),carderase%():next n
24020 for n=32 to 20 step -1:gshape(n*8,63),carderase%():next n
24030 return
25000 num=1:for n=1 to 6
25002 if y(n,5)=1 then card(num)=n:num=num+1
25004 next n
25005 if right<6 then gshape(8+(right*35),154),gobox%()
25007 gosub 26100:q1=0:q2=0
25010 ask mouse x%,y%,b%
25015 if b%=4 and right=6 then 25045
25020 if b%=4 and right<6 then 26000
25030 goto 25010
25045 if y%<119 or y%>160 then 25010
25050 i=1
25055 if x%>8+((i-1)*35) and x%<8+(((i-1)*35)+33) then 25070
25060 i=i+1:if i<=right then 25055
25065 goto 25010
25070 gshape(15+((i-1)*35),161),pointer%():gosub 26100
25075 if q1=0 then q1=card(i):goto 25010
25080 q2=card(i):if q1=q2 then q2=0:goto 25010
25085 return
26000 if y%>153 and y%<165 and x%>8+(right*35) and x%<8+((right*35)+22) then c$="GO":return
26010 if y%<119 or y%>160 then 25010
26020 i=1
26030 if x%>8+((i-1)*35) and x%<8+(((i-1)*35)+33) then 26060
26040 i=i+1:if i<=right-1 then 26030
26050 goto 25010
26060 c$=str$(card(i))
26070 gshape(8+(right*35),154),goboxb%():return
26100 rem sound
26150 return
27000 gshape(115,63),updown%():gshape(146,75),donebox%():drawmode 1:pena 6:penb 7:p9=0:n=0
27010 ask mouse x%,y%,b%:st=pixel(x%,y%)
27015 if b%=4 and x%>146 and x%<184 and y%>75 and y%<85 then n=1
27020 if n=1 then print at(84,83);" 0":drawmode 0:gshape(115,63),updownb%():gshape(146,75),doneboxb%():return
27022 if b%=0 goto 27010
27025 if st<>8 and st<>3 then 27010
27030 if st=8 then 27050
27035 if st=3 then 27060
27040 goto 27010
27050 p9=p9+1:if p9>29 then p9=0
27055 locate(84,83):print using "##";p9;
27058 sleep(.2*10^6):goto 27010
27060 p9=p9-1:if p9<0 then p9=29
27065 locate(84,83):print using "##";p9;
27068 sleep(.2*10^6):goto 27010
30000 restore 30080
30010 i=1
30012 read pegpos(i)
30014 i=i+1:if i<61 then 30012
30020 restore 30080
30030 i=61
30032 read pegpos(i)
30034 i=i+1:if i<121 then 30032
30040 pegpos(61)=0:return
30080 data 15,8,8,8,8,13,8,8,8,8,13,8,8,8,8,13,8,8,8,8,13,8,8,8,8,13,8,8,8,8,0,-8,-8,-8,-8,-13,-8,-8,-8,-8
30081 data -13,-8,-8,-8,-8,-13,-8,-8,-8,-8,-13,-8,-8,-8,-8,-13,-8,-8,-8,-8
32000 bload "clubs1",varptr(clubs%(0)):bload "spades1",varptr(spades%(0)):bload "hearts1",varptr(hearts%(0)):bload "cribscreen",varptr(cribscreen%(0))
32004 bload "back1",varptr(back1%(0)):bload "back2",varptr(back2%(0)):bload "player1",varptr(computer%(0)):bload "player2",varptr(human%(0))
32008 bload "blankplay1",varptr(computerb%(0)):bload "blankplay2",varptr(humanb%(0)):bload "mycrib",varptr(mycrib%(0))
32011 bload "yourcrib",varptr(yourcrib%(0)):bload "points",varptr(points%(0)):bload "pointer",varptr(pointer%(0))
32015 bload "updown",varptr(updown%(0)):bload "blankud",varptr(updownb%(0)):bload "gobox",varptr(gobox%(0)):bload "donebox",varptr(donebox%(0))
32019 bload "winner",varptr(winner%(0)):sshape(269,155;303,163),backerase%():sshape(219,119;227,165),carderase%():sshape(100,0;123,11),goboxb%()
32023 sshape(225,154;264,165),doneboxb%():bload "diamonds1",varptr(diamonds%(0)):bload "clubs2",varptr(clubs2%(0)):bload "spades2",varptr(spades2%(0))
32027 bload"hearts2",varptr(hearts2%(0)):bload "diamonds2",varptr(diamonds2%(0)):return
32200 gshape(0,0),cribscreen%():gshape(11,9),computer%():gshape(11,45),human%()
32210 return
32600 cxx=269:cyy=63:rem **** draw back of card ****
32605 if cnt=0 then return
32620 gosub 32700:if cnt=1 then return
32625 for q1=1 to cnt-1:cyy=cyy+11:gosub 32710:next q1:return
32700 gshape(cxx,cyy),back1%():return
32710 gshape(cxx,cyy),back2%():return
32720 rem
32721 cxx=9:cyy=63:gosub 32700
32730 pena 7:peno 29:paint(80,72),0
32740 return
