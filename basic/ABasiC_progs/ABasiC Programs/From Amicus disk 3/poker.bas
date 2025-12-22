5     zx=0
10    scnclr
11    gosub 7000
12    y=120:gosub 7100
15    rgb 0,5,15,0
25    circle(138,28),30
27    pena 11:paint(159,10)
28    penb 7:pena 1:?at(110,30);" BET ? "
29    d=0:bet=0
30    ask mouse x%,y%,b%
32    if b%=4 and y%<60 then ?at(130,70);"or":circle(138,90),40,.25:paint(130,90):pena 2:penb 1:?at(122,93);"DEAL":d=1:bet=bet+1:?at(120,40);"$"bet
33    if b%=4 and y%<60 then pot=pot-1:gosub 7000
35    if b%=4 and y%>80 and d=1 then 40
39    goto 30
40    scnclr
45    y=10:gosub 7100:y=100
50    x=-2:y=100
51    gosub 60:gosub 61
52    x=59:gosub 60:gosub 61
53    x=120:gosub 60:gosub 61
54    x=181:gosub 60:gosub 61
55    x=242:gosub 60:gosub 61
56    goto 70
60    gshape(x,y),card53%
61    for t=1 to 500:next:return
70    '
100   rem
110   randomize
120   c=int(rnd(9)*52+1)
125   c1=c:x=-2:y=100
128   gosub 1000
130   c=int(rnd(9)*52+1)
135   c2=c:x=59
136   if c2=c1 then 130
138   gosub 1000
140   c=int(rnd(9)*52+1)
145   c3=c:x=120
146   if c3=c2 or c3=c1 then 140
148   gosub 1000
150   c=int(rnd(9)*52+1)
155   c4=c:x=181
156   if c4=c3 or c4=c2 or c4=c1 then 150
158   gosub 1000
160   c=int(rnd(9)*52+1)
165   c5=c:x=242
166   if c5=c4 or c5=c3 or c5=c2 or c5=c1 then 150
168   gosub 1000
500   '
510   graphic 1
515   penb 2
519   goto 565
520   pena 1:? at (6 ,95);" HOLD "
530   ?at(66,95);" HOLD "
540   ?at(128,95);" HOLD "
550   ?at(188,95);" HOLD "
560   ?at(248,95);" HOLD "
565   h1=0:h2=0:h3=0:h4=0:h5=0
568   pena 1
570   ?at(55,85);"  select cards to hold  "
572   Y=10:GOSUB 7100:Y=100
575   penb 4:?at(83,65);" THE BET IS $"bet
580   penb 7:?at(66,180);"   draw when ready   "
581   ?at(66,50); "       draw          "
600   rem
610   ask mouse x%,y%,b%
615   if b%=4 and y%>95  goto 620
616   if b%=4 and y%<50 goto 700
619   goto 600
620   if x%<60 and h1=0 then penb 4:?at(6,95);" HELD ":h1=1:goto 670
621   if x%<60 and h1=1 then penb 0:?at(6,95);"      ":h1=0:goto 670
630   if x%>60 and x%<120 and h2=0 then penb 4:?at(66,95);" HELD ":h2=1:goto 670
631   if X%>60 and x%<120 and h2=1 then penb 0:?at(66,95);"      ":h2=0:goto 670
640   if x%>120 and x%<180 and h3=0 then penb 4:?at(128,95);" HELD ":h3=1 :goto 670
641   if x%>120 and x%<180 and h3=1 then penb 0:?at(128,95);"      ":h3=0:goto 670
650   if x%>180 and x%<240 and h4=0 then penb 4:?at(188,95);" HELD ":h4=1:goto 670
651   if x%>180 and x%<240 and h4=1 then penb 0:?at(188,95);"      ":h4=0:goto 670
660   if x%>240 and h5=0 then penb 4:?at(248,95);" HELD ":h5=1:goto 670
661   if x%>240 and h5=1 then penb 0:?at(248,95);"      ":h5=0:goto 670
670   for t=1 to 1000:next:goto 600
690   goto 600
700   rem ****deal remaining cards**
701   if h1=0 then x=-2:gosub 60
702   if h2=0 then x=59:gosub 60
703   if h3=0 then x=120:gosub 60
704   if h4=0 then x=181:gosub 60
705   if h5=0 then x=242:gosub 60
710   if h1=0 then c=int(rnd(9)*52+1):c6=c:x=-2:if c6=c5 or c6= c4 or c6=c3 or c6=c2 or c6=c1 then 710:gosub 1000
730   if h2=0 then c=int(rnd(9)*52+1):c7=c:x=59:if c7=c6 or c7= c5 or c7=c4 or c7=c3 or c7=c2 or c7=c1 then 730:gosub 1000
740   if h3=0 then c=int(rnd(9)*52+1):c8=c:x=120:if c8=c7 or c8=c6 or c8=c5 or c8=c4 or c8=c3 or c8=c2 or c8=c1 then 740:gosub 1000
750   if h4=0 then c=int(rnd(9)*52+1):c9=c:x=181:if c9=c8 or c9=c7 or c9=c6 or c9=c5 or c9=c4 or c9=c3 or c9=c2 or c9=c1 then 740:gosub 1000
760   if h5=0 then c=int(rnd(9)*52+1):c10=c:x=242:if c10=c9 or c10=c8 or c10=c7 or c10=c6 or c10=c5 or c10=c4 or c10=c3 or c10=c2 or c10=c1 then 760:gosub 1000
765   gosub 770:goto 780
770   penb 0:?at(55,85);"                          "
771   ?at(66,180);"                     "
775   return
780   if h1=0 then c1=c6
781   if h2=0 then c2=c7
782   if h3=0 then c3=c8
783   if h4=0 then c4=c9
785   if h5=0 then c5=c10
790   goto 1900
800   '
1000  rem
1010  if c=1 then gshape(x,y),card1%
1020  if c=2 then gshape(x,y),card2%
1030  if c=3 then gshape(x,y),card3%
1040  if c=4 then gshape(x,y),card4%
1050  if c=5 then gshape(x,y),card5%
1060  if c=6 then gshape(x,y),card6%
1070  if c=7 then gshape(x,y),card7%
1080  if c=8 then gshape(x,y),card8%
1090  if c=9 then gshape(x,y),card9%
1100  if c=10 then gshape(x,y),card10%
1110  if c=11 then gshape(x,y),card11%
1120  if c=12 then gshape(x,y),card12%
1130  if c=13 then gshape(x,y),card13%
1140  if c=14 then gshape(x,y),card14%
1150  if c=15 then gshape(x,y),card15%
1160  if c=16 then gshape(x,y),card16%
1170  if c=17 then gshape(x,y),card17%
1180  if c=18 then gshape(x,y),card18%
1190  if c=19 then gshape(x,y),card19%
1200  if c=20 then gshape(x,y),card20%
1210  if c=21 then gshape(x,Y),card21%
1220  if c=22 then gshape(x,y),card22%
1230  if c=23 then gshape(x,y),card23%
1240  if c=24 then gshape(x,y),card24%
1250  if c=25 then gshape(x,y),card25%
1260  if c=26 then gshape(x,y),card26%
1270  if c=27 then gshape(x,y),card27%
1280  if c=28 then gshape(x,y),card28%
1290  if c=29 then gshape(x,y),card29%
1300  if c=30 then gshape(x,y),card30%
1310  if c=31 then gshape(x,y),card31%
1320  if c=32 then gshape(x,y),card32%
1330  if c=33 then gshape(x,y),card33%
1340  if c=34 then gshape(x,y),card34%
1350  if c=35 then gshape(x,y),card35%
1360  if c=36 then gshape(x,y),card36%
1370  if c=37 then gshape(x,y),card37%
1380  if c=38 then gshape(x,y),card38%
1390  if c=39 then gshape(x,y),card39%
1400  if c=40 then gshape(x,y),card40%
1410  if c=41 then gshape(x,y),card41%
1420  if c=42 then gshape(x,y),card42%
1430  if c=43 then gshape(x,y),card43%
1440  if c=44 then gshape(x,y),card44%
1450  if c=45 then gshape(x,y),card45%
1460  if c=46 then gshape(x,y),card46%
1470  if c=47 then gshape(x,y),card47%
1480  if c=48 then gshape(x,y),card48%
1490  if c=49 then gshape(x,y),card49%
1500  if c=50 then gshape(x,y),card50%
1510  if c=51 then gshape(x,y),card51%
1520  if c=52 then gshape(x,y),card52%
1600  return
1900  rem if zx=0 then chain merge "win",2000:zx=1
2000  rem calculate winnings
2003  zx=1
2004  flu=0:str=0
2005  H$="hcds"
2006  C$="123456789TJQK"
2010  ?at(77,80);"CALCULATE WINNINGS"
2011  s=1:v=c1:gosub 2020:a=q
2012  v=c2:gosub 2020:b=q
2013  v=c3:gosub 2020:c=q
2014  v=c4:gosub 2020:d=q
2015  v=c5:gosub 2020:e=q
2019  goto 2030
2020  t=int((v-1)/13):q=v-t*13
2021  k$(s) = mid$ (H$,t+1,1)
2022  n$(s)=mid$(c$,q,1)
2023  rem: ?k$(s)
2024  rem: ?n$(s)
2026  s=s+1
2029  return
2030  rem goto subroutine check for straight or ROYAL
2032  if K$(1)=K$(2) and K$(1)=K$(3) and K$(1)=K$(4) and K$(1)=k$(5) then flu=1:goto 3000
2040  rem ** 4 of kind
2041  if a=b and a=c and a=d then 5030
2042  if a=c and a=d and a=e then 5030
2043  if a=b and a=d and a=e then 5030
2044  if a=b and a=c and a=e then 5030
2045  if b=c and b=d and b=e then 5030
2050  if a=b and a=c then if d=e then 5040
2051  if a=c and a=d then if b=e then 5040
2052  if a=c and a=e then if b=d then 5040
2053  if a=b and a=d then if c=e then 5040
2054  if a=b and a=e then if c=d then 5040
2055  if a=d and a=e then if b=c then 5040
2056  if b=c and b=d then if a=e then 5040
2057  if b=c and b=e then if a=d then 5040
2058  if c=d and c=e then if a=b then 5040
2059  if b=d and b=e then if a=c then 5040
2060  if a=b and a=c then 5070
2061  if a=c and a=d then 5070
2062  if a=c and a=e then 5070
2063  if a=b and a=d then 5070
2064  if a=b and a=e then 5070
2065  if a=d and a=e then 5070
2066  if b=c and b=d then 5070
2067  if b=c and b=e then 5070
2068  if c=d and c=e then 5070
2069  if b=d and b=e then 5070
2070  if a=b and c=d then 5080
2071  if a=b and c=e then 5080
2072  if a=c and b=d then 5080
2073  if a=c and b=e then 5080
2074  if a=d and b=c then 5080
2075  if a=d and b=e then 5080
2076  if a=e and b=c then 5080
2077  if a=e and b=d then 5080
2078  if b=c and d=e then 5080
2079  if a=c and d=e then 5080
2080  if a=e and c=d then 5080
2081  if a=b and d=e then 5080
2082  if a=b and b=e then 5080
2083  if b=e and c=d then 5080
2084  if a=d and c=e then 5080
2085  IF B=D AND C=E THEN 5080
2090  rem 1 pair
2091  if a=b or a=c or a=d or a=e then j=a:goto 5090
2092  if b=c or b=d or b=e then j=b:goto 5090
2093  if c=d or c=e then j=c:goto 5090
2094  if d=e then j=d:goto 5090
2095  '
2096  '
2097  rem goto 5095
3000  rem sort straights and royal
3002  if a=1 then if b=13 or c=13 or d=13 or e=13 then a=14
3003  if b=1 then if a=13 or c=13 or d=13 or e=13 then b=14
3004  if c=1 then if a=13 or b=13 or d=13 or e=13 then c=14
3005  if d=1 then if a=13 or b=13 or c=13 or e=13 then d=14
3006  if e=1 then if a=13 or b=13 or c=13 or d=13 then e=14
3010  for s=1 to 15
3011  if s=a then t=a:a=0:goto 3020
3012  if s=b then t=b:b=0:goto 3020
3013  if s=c then t=c:c=0:goto 3020
3014  if s=d then t=d:d=0:goto 3020
3015  if s=e then t=e:e=0:goto 3020
3016  next
3020  for s=1 to 15
3021  if s=a then u=a:a=0:goto 3030
3022  if s=b then u=b:b=0:goto 3030
3023  if s=c then u=c:c=0:goto 3030
3024  if s=d then u=d:d=0:goto 3030
3025  if s=e then u=e:e=0:goto 3030
3026  next
3030  for s=1 to 15
3031  if s=a then v=a:a=0:goto 3040
3032  if s=b then v=b:b=0:goto 3040
3033  if s=c then v=c:c=0:goto 3040
3034  if s=d then v=d:d=0:goto 3040
3035  if s=e then v=e:e=0:goto 3040
3036  next
3040  for s=1 to 15
3041  if s=a then y=a:a=0:goto 3050
3042  if s=b then y=b:b=0:goto 3050
3043  if s=c then y=c:c=0:goto 3050
3044  if s=d then y=d:d=0:goto 3050
3045  if s=e then y=e:e=0:goto 3050
3046  next
3050  for s=1 to 15
3051  if s=a then z=a:goto 3060
3052  if s=b then z=b:goto 3060
3053  if s=c then z=c:goto 3060
3054  if s=d then z=d:goto 3060
3055  if s=e then z=e:goto 3060
3056  next
3060  '
3070  if t+1=u and u+1=v and v+1=y and y+1=z then str=1  
3079  if str=1 and flu=1 and z=14 then 5010
3080  if str=1 and flu=1 then 5020
3083  if str=1 then 5060
3085  if flu=1 then 5050
3087  rem royal ???????
3089  goto 5095
5000  rem calculate pay-out.=po
5010  ?"ROYAL FLUSH":PO=250
5015  goto 5100
5020  ?"STRAIGHT FLUSH":PO=50
5025  goto 5100
5030  ?"4 OF A KIND":PO=25
5035  goto 5100
5040  ?"FULL HOUSE":PO=8
5045  goto 5100
5050  ?"FLUSH":PO=5
5055  goto 5100
5060  ?"STRAIGHT":PO=4
5065  goto 5100
5070  ?"3 OF A KIND":PO=3
5075  goto 5100
5080  ?"2 PAIRS":PO=2
5085  goto 5100
5090  ?"ONE PAIR ";:PO=1
5091  if j=1 then j=14
5092  if j<11 then ?"--YOU NEED JACKS OR BETTER ":po=0:goto 5110
5094  goto 5100
5095  ?"NOTHING":PO=0
5100  '
5105  pot=pot+(bet*po)
5106  ?at (170,88);"YOU WIN $";bet*po
5110  gosub 7000
6000  rem
6003  pena 4:penb 6
6005  ?at(20,150);"  TRY AGAIN    OR      QUIT  "
6010  ask mouse x%,y%,b%:if b%=4 and x%<160 then 10
6012  if b%=4 then chain "casino",37,all
6014  gosub 6080
6015  ?at(20,150);"              "
6017  ?at(200,150);"QUIT ?"
6018  gosub 6080
6021  ?at(20,150);"  TRY AGAIN ?"
6025  ?at(200,150);"      "
6050  goto 6010
6080  sleep 1*10^5:return
7000  rem
7010  ?at(30,9);"YOU HAVE $";pot;"IN YOUR POCKET"
7020  return
7100  rem
7105  PENB 7
7110  ?at(60,y );"ROYAL FLUSH PAYS 250:1"
7120  ?"STRAIGHT FLUSH 20:1     FLUSH      5:1  "
7130  ?"4 OF KIND      25:1     3 OF KIND  3:1    "
7140  ?"FULL HOUSE      8:1     2 PAIR     2:1 "
7150  ?"STRAIGHT        4:1     JACKS +    1:1"
7200  RETURN
