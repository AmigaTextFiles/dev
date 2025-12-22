1     rem BLACK JACK
50    rgb 0,5,13,0
90    goto 180
100   rem  Card Shuffle
110   dim n(52,10)
120   d=1
130   for dn=1 to d:for c=1 to 52:n(c,dn)=c:next:next
140   for dn= 1 to d
150   randomize
160   for c=1 to 52:c1=int(rnd(1)*52)+1:c2 =int(rnd(1)*52)+1:t=n(c1,dn)
170   n(c1,dn)=n(c2,dn):n(c2,dn)=t:next:next
175   ca=1:dn=1: rem renamed cards ca and decks dn
177   return
180   '
185   gosub 2040
200   rem set up table
202   graphic 1
205   scnclr
210   p3=0:p4=0:p5=0:p6=0
211   z=1:bet=0
212   gosub 295
220   peno 1:circle (150,0),390,.25
230   circle(150,130),20
231   paint(150,130),0
232   ?at(138,125);"BET"
233   ?at(138,135);bet
240   ask mouse x%,y%,b%:if b%<>4 then 240
242   box(110,40;190,60)
244   ?at(130,52);"DEAL ?"
250   if y%<100 then 300
255   ?at(138,135);bet+1:bet=bet+1:pot=pot-1:gosub 295
257   sleep 1*10^5
260   goto 240
295   ?at(20,7);" YOU HAVE"POT"IN YOUR POCKET "
296   rem x%=sound(9,0,0,32,240)
297   sleep 1*10^5
298   rem audio 9,-1
299   return
300   rem deal first cards
301   x=10:y=100:gosub 2010:' 1st
302   p1=v
306   x=10:y=10:gshape(x,y),card53%
307   gosub 2020:dc=n(ca,dn):d1=v:sleep 1*10^5
308   ca=ca+1:if ca>52 then gosub 2040
310   x=50:y=100:gosub 2010
311   p2=v
315   x=75:y=10:gosub 2010
316   d2=v
320   ' see if bj
325   p=p1+p2
326   if p=21 then gosub 2030:?at(20,130);" YOU HAVE A BLACK JACK ":goto 4000
330   d=d1+d2
332   if p=21 and d=21 then gosub 2030:goto 4000
335   if d=21 then gosub 2030:?at(20,80);" DEALER HAS BLACK JACK ":goto 2050
340   if p=11 or p=10 then 3000
350   rem deal rest of player
355   ?at(0,88);" CLICK IN YOUR CARDS TO HIT "
357   ?at(0,96);" CLICK IN DEALERS CARDS TO STAND"
360   ask mouse x%,y%,b%:if b%<>4 then 360
361   if y%>100 and z=1 goto 365
362   if y%>100 and z=2  goto 375:if y%>100 and z=3 goto 385
363   if y%<100 then 400
364   goto 360
365   x=90:y=100:gosub 2010:p3=v
366   p=p1+p2+p3:z=2
367   if p1=11 and p>21 then p=p-10
368   if p2=11 and p>21 then p=p-10
369   if p3=11 and p>21 then p=p-10
370   if p>21 then ?at(30,130);"  BUST  ":gosub 2030:goto 2050
373   sleep 1*10^6
374   goto 360
375   x=130:y=100:gosub 2010:p4=v
376   p=p1+p2+p3+p4:z=3
377   if p1=11 and p>21 then p=p-10
378   if p2=11 and p>21 then p=p-10
379   if p3=11 and p>21 then p=p-10
380   if p4=11 and p>21 then p=p-10
381   if p>21 then ?at(40,130);"BUST":gosub 2030:goto 2050
384   sleep 1*10^6:goto 360
385   x=170:y=100:gosub 2010:p5=v
386   p=p1+p2+p3+p4+p5:z=5
387   if p1=11 and p>21 then p=p-10
388   if p2=11 and p>21 then p=p-10
389   if p3=11 and p>21 then p=p-10
390   if p4=11 and p>21 then p=p-10
391   if p5=11 and p>21 then p=p-10
393   if p>21 then ?at(40,130);"  BUST ":gosub 2030:goto 2050
395   ?at(40,130);"YOU HAVE FIVE CARDS"
396   ?at(40,110);" YOU WIN "
397   goto 2050
399   stop
400   '
403   gosub 2030
404   if d>16 then 500
405   if d<17 then x=115:y=10:gosub 2010:d3=v
406   d=d1+d2+d3
408   if d1=11 and d>21 then d=d-10
410   if d2=11 and d>21 then d=d-10
412   if d3=11 and d>21 then d=d-10
413   if d>21 then ?at(30,60);"DEALER BUST":goto 4000
414   if d>16 then 500
415   if d<17 then x=155:y=10:gosub 2010:d4=v
416   d=d1+d2+d3+d4
417   if d1=11 and d>21 then d=d-10
418   if d2=11 and d>21 then d=d-10
419   if d3=11 and d>21 then d=d-10
420   if d4=11 and d>21 then d=d-10
422   if d>21 then ?at(30,60);"DEALER BUST":goto 4000
423   if d>16 then 500
425   if d<17 then x=195:y=10:gosub 2010:d5=v
426   d=d1+d2+d3+d4+d5
427   if d5=11 and d>21then d=d-10
432   if d>21 then 422
434   if d>16 then 500
435     if d<17 then x=235:y=10:gosub 2010:d6=v
436     d=d1+d2+d3+d4+d5+d6
442   if d>21 then 422
443   if d>16 then 500
445   stop :rem if gets this far needs another card
500   '
510   if p=d then ?at(30,30);"PUSH":?at(30,130);"PUSH":goto 4000
520   if p>d then ?at(30,130);" YOU WIN ":goto 4000
530   if p<d then ?at(30,130);" YOU LOSE ":goto 2050
999   stop
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
2000  rem start of subroutines
2001  end
2010  c=n(ca,dn):gosub 2020:ca=ca+1:gosub 1000
2011  if ca>52 then gosub 2040
2012  sleep 1*10^4
2018  return
2020  rem determine value
2022  v=n(ca,dn) mod 13
2024  if v>9 then v=10
2025  if v=0 then v=10
2026  if v=1 then v=11
2029  return
2030  c=dc:x=10:y=10:gosub 1000:return:rem print down card
2040  erase n
2042  ?at(130,180);"Shuffle
2044  sleep 2*10^6
2046  penb 8:?at(130,180);"       "
2048  gosub 100
2049  return
2050  rem
2052  pena 4:penb 6
2054  ?at(20,150);"  TRY AGAIN    OR      QUIT  "
2056  ask mouse x%,y%,b%:if b%=4 and x%<160 then 200
2058  if b%=4 then chain "casino",37,all
2060  gosub 2074
2062  ?at(20,150);"              "
2064  ?at(200,150);"QUIT ?"
2066  gosub 2074
2068  ?at(20,150);"  TRY AGAIN ?"
2070  ?at(200,150);"      "
2072  goto 2056
2074  sleep 1*10^5:return
3000  rem  DOUBLE DOWN
3002  pena 6:penb 4
3004  ?at(20,180);"          DOUBLE DOWN           "
3006  ask mouse x%,y%,b%:if b%=4 and x%<160 then 3030
3008  if b%=4 then 3025
3010  gosub 3024
3012  ?at(20,180);"      "
3014  ?at(230,180);"NO ?"
3016  gosub 3024
3018  ?at(20,180);" YES ?"
3020  ?at(230,180);"     "
3022  goto 3006
3024  sleep 1*10^5:return
3025  gosub 3028: goto 350:rem continue
3026  stop
3028  penb 8:?at(20,180);"                                ":return
3030  rem one card
3031  pot=pot-bet:gosub 295:bet=bet+bet
3032  gosub 3028:x=90:y=100:gosub 2010:p=p+v:if v=11 and p>21 then p=p-10:goto 400
3033  goto 400
4000  rem calculate winnings
4010  if p=d then pot=pot+bet:gosub 295:goto 2050
4020  for t=1 to bet*2:pot=pot+1:gosub 295:next:goto 2050
