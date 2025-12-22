60    rem this is the routine only
62    scnclr
63    rgb 0,15,9,10
64    pena 2:penb 1
65    ?at(40,50);"CLICK UP HERE TO ROLL DICE"
66    ?AT(0,70);"CLICK BOX OF YOUR CHOICE TO MAKE BET"
70    draw(-5,110 to 329,110)
71    draw(100,110 to 100,200)
72    draw(200,110 to 200,200)
74    pena 11
75    paint(50,130),1
76    paint(280,130),1
77    pena 9:paint(120,130),1
79    pena 6:penb 11:graphic 1
80    ?at(30,150);"UNDER"
81    ?at(38,160);"1:1"
85    ?at(240,150);"OVER"
86    ?at(245,160);"1:1"
89    penb 9
90    ?at(130,150);"SEVEN"
91    ?at(138,160);"3:1"
95    penb 2
96    pena 1:x=0:y=0
97    GOSUB 660
98    goto 600
100   '
101   gshape(x-20,y-10),blank%
104   rem draw(120,118):stopTHIS           IS THE POS'N OF THE CENTER
106   p=0:q=0
108   p1=0:q1=0
110   x=-9:y=45
112   x1=-70:y1=15
114   gshape(x-28,y-26),d2%:rem D2% uses a different corner than D1%
116   gshape(x1-28,y1-26),d2%
118   sleep 1*10^5
120   gshape(x-28,y-26),blank%
122   gshape(x1-28,y1-26),blank%
124   if p=0 then x=x+20
126   if p1=0 then x1=x1+20
128   if p=1 then x=x-20
129   if p1=1 then x1=x1-20
130   if q=0 then y=y+20
131   if q1=0 then y1=y1+20
132   if q=1 then y=y-20
133   if q1=1 then y1=y1-20
134   gshape(x-20,y-18),d1%
135   gshape(x1-20,y1-18),d1%
136   sleep 1*10^5
138   if p=1 and x<80 and y>60 then 156
139   gshape(x1-28,y1-26),blank%
140   gshape(x-28,y-26),blank%
141   if p1=0 then x1=x1+20
142   if p=0 then x=x+20
144   if p=1 then x=x-20
145   if p1=1 then x1=x1-20
146   if x>270 then p=1
147   if x1>270 then p1=1
148   rem if x<-10 then p=0
150   if y>60 then q=1
151   if y1>60 then q1=1
152   if y<39 then q=0
153   if y1<39 then q1=0
154   goto 114
156   '
210   gshape(x-28,y-26),blank%
211   gshape(x1-28,y1-26),blank%
220   x=x-10
221   x1=x1-20
222   if y1<60 then y1=y1+20
240   gshape(x-28,y-26),d2%
241   gshape(x1-28,y1-26),d2%
250   sleep 1*10^5
260   gshape(x-28,y-26),blank%
261   gshape(x1-28,y1-26),blank%
270   sleep 1*10^5
280   x=x-10
281   if y1<60 then y1=y1+20
290   gshape(x-20,y-10),d1%
291   gshape(x1-20,y1-18),d1%
295   sleep 1*10^5
296   if x<120 then 300
299   goto 156
300   '
301   randomize
302   n1=int(rnd*6+1)
303   n=int(rnd*6+1)
304   if n=1 then gosub 320
305   if n=2 then gosub 326
306   if n=3 then gosub 332
307   if n=4 then gosub 340
308   if n=5 then gosub 348
309   if n=6 then gosub 358
310   x=x1:y=y1-8
311   if n1=1 then gosub 320
312   if n1=2 then gosub 326
313   if n1=3 then gosub 332
314   if n1=4 then gosub 340
315   if n1=5 then gosub 348
316   if n1=6 then gosub 358
317   goto 500
320   rem one spot
322   gosub 410
324   return
326   '
328   gosub 420
330   return
332   '
334   gosub 410
336   gosub 420
338   return
340   '
342   gosub 430
344   gosub 420
346   return
348   '
350   gosub 410
352   gosub 420
354   gosub 430
356   return
358   '
360   gosub 420
362   gosub 430
364   gosub 440
366   return
410   gshape(x-2,y+6),spot%:return
420   gshape(x-13,y+14),spot%:rem lower left
421   gshape(x+9,y-2),spot%:rem upper right
422   return
430   gshape(x-13,y-2),spot%:rem upper left
431   gshape(x+9,y+14),spot%:rem lower right
432   return
440   gshape(x-13,y+6),spot%:rem center left
441   gshape(x+9,y+6),spot%:rem center right
442   return
500   rem calculation for over/un
505   t=0
510   A=n+n1
511   if a<7 then a$="UNDER SEVEN"
512   IF A>7 then a$="OVER SEVEN"
513   if a=7 then a$="SEVEN"
515   graphic 1
520   ?at(50,100);"THE ROLL IS "A$
530   if a<7 and c=1 then ? "YOU WIN"bet*2:POT=POT+(BET*2):gosub 660:t=1
540   if a>7 and c2=1 then ? "YOU WIN"b2*2:pot=pot+(b2*2):gosub 660:t=1
550   if a=7 and c3 = 1 then ?"YOU WIN"b3*3:pot=pot+(b3*3)+b3:gosub 660:t=1
555   if t=0 then ?at(50,108);"YOU LOSE"
560   GOSUB 660
590   sleep 3*10^6
593   penb 11:?at(40,120);"    ":?at(235,120);"    ":penb 2
594   penb 9:?at (130,120);"    ":penb 2
595   ?at(30,100)"MAKE A BET OR GOTO ANOTHER GAME"
596   pena 2:penb 1:?at(0,108);"QUIT                              QUIT":pena 1:penb 2
600   '
601   bet=0:b2=0:b3=0
602   c1=0:c2=0:c3=0
610   ask mouse x%,y%,b%
611   if b%<>4 then 610
612   penb 3:?at(30,100);"                               ":?at(0,108);"                                      "
613   if x%<100 and y%>110 then gosub 620
614   if x%>200and y%>110  then gosub 630
615   if x%>100 and x%<200 and y%>110 then gosub 640
616   if y%<110 and y%>100 then chain "casino",37,all
617   if y%<100 then 100
618   goto 610
620   '
621   c=1
622   bet=bet+1:pot=pot-1
624   GOSUB 660
627   ?at(40,120);bet
628   sleep .25*10^6
629   return
630   '
631   c2=1
632   b2=b2+1:pot=pot-1
634   GOSUB 660
637   ?at(235,120);b2
638   sleep .25*10^6
639   return
640   '
641   c3=1
642   b3=b3+1:pot=pot-1
644   GOSUB 660
647   ?at(135,120);b3
648   sleep .25*10^6
649   return
650   '
660   pena 1:penb 2:?at(40,180);" YOU HAVE"POT"IN YOUR POCKET ":RETURN
