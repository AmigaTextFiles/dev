1     rem *****  CRAPS  *****
2     rem By BOB HUTCHINSON
3     rem V 1.0
4     '
5     '
10    scnclr
11    penb 2:?at(50,50);" "
12    pena 1:draw(51,50)
13    draw(51,48)
14    draw(51,46)
15    draw(54,50):draw(54,48):draw(54,46)
16    dim c%(20)
17    sshape(50,45;56,51),c%
18    gshape(100,100),c%
19    scnclr
20    pena 1:penb 8
21    graphic 1
22    x=100:y=100
23    ?at(x,y);" DON'T "
24    ?at(x+4,y+8);" COME  "
25    a=5:b=50
26    d=-7:e=8
27    gosub 90
28    '
29    dim d%(290)
30    sshape(154,120;170,165),d%
31    gshape (50,50),d%
32    rem draw table
33    graphic 1
34    scnclr:pena 1
35    draw(-5,110 to 329,110)
36    peno 1:pena 1
37    circle(280,167),20
38    penb 8
39    ?at(255,152);"       "
40    ?at(255,160);"       "
41    ?at(255,168);" "
42    ?at(255,176);"  "
43    ?at(255,184);"    "
44    draw(300,110 to 300,162)
45    draw(100,186 to 284,186)
46    pena 8:paint(120,120),0
47    pena 1
48    circle(275,161),15
49    ?at(256,174);"  "
50    ?at(255,166);"  "
51    ?at(255,158);"     "
52    ?at(264,150);"   "
53    ?at(180,184);"PASS LINE"
54    draw(100,176 to 270,176)
55    draw(290,110 to 290,160)
56    '**************
57    draw(100,174 to 260,174)
58    ?at(120,172);"DON'T PASS BAR"
59    draw(100,164 to 260,164)
60    '*************
61    ?at(65,125);"  4   5   6   8   9      "
62    ?at(237,125);"10"
63    '*****
64    draw(100,110 to 100,185)
65    draw(70,128 to 260,128)
66    draw(70,116 to 260,116)
67    draw(70,114 to 260,114)
68    draw(70,110 to 70,130)
69    draw(70,130 to 260,130)
70    draw(260,110 to 260,173)
71    draw(133,110 to 133,114)                     
72    draw(133,116 to 133,128)
73    draw(166,110 to 166,130)
74    draw(197,110 to 197,114)
75    draw(197,116 to 197,128)
76    draw(230,110 to 230,130)
77    gshape(265,111),d%
78    gshape(240,166),c%
79    gshape(248,166),c%
80    gshape(282,135),c%
81    gshape(282,128),c%
82    draw(260,155 to 290,155)
83    '
84    draw(285,172 to 251,150 to 100,150)
85    ?at(145,145);" COME "
86    dim table%(3400)
87    sshape(0,110;301,190),table%
88    goto 100
90    '
91    for ac= a to b: rem across
92    for dn= d to e: rem down
93    n= pixel (x+ac,y+dn):pena n
94    draw(x+60+dn,y+70-ac)
95    next dn:next ac
96    return
100   rem this is the dice drawing routine only -- lines 100-130
101   scnclr
102   common pot
103   rgb 0,15,15,15
104   rem:borderoff rgb 1,15,15,15
105   pena 4
106   dim blank%(500)
107   sshape(42,42;99,94),blank%
108   box(50,50;90,85),1
109   draw(70,68)
110   dim d1%(300)
111   sshape(50,50;91,86),d1%
112   pena 2
113   draw(70,68)
114   draw(70,66 to 72,68 to 70,70 to 68,68 to 70,66)
115   draw(70,67 to 71,68 to 70,69 to 69,68)
116   dim spot%(100)
117   sshape(68,66;73,71),spot%
118   rem draw(70,40 to 70,95)
119   rem draw(40,68 to 100,68)
120   scnclr
121   pena 4
122   draw(70,42 to 42,68)
123   draw(70,42 to 98,68)
124   draw(to 70,93 to 42,68)
125   paint(80,60),1
126   dim d2%(500)
127   sshape(42,42;99,94),d2%
128   scnclr
129   rem THIS IS THE END OF THE           DICE DRAWING ROUTINE
130   '
150   rem this is the routine only
151   scnclr
152   rgb 0,15,9,10
153   pena 2:penb 1
154   ?at(40,50);"CLICK UP HERE TO ROLL DICE":?at(40,60);"CLICK IN PASSLINE OR DON'T PASS ":?AT(40,70);"TO BET"
155   gshape(0,110),table%
156   penb 2
157   pena 1:x=0:y=0
158   GOSUB 343
159   goto 307
160   '
161   gshape(x-20,y-10),blank%
162   penb 3:?at(40,10);"                              "
163   rem draw(120,118):stopTHIS           IS THE POS'N OF THE CENTER
164   p=0:q=0
165   p1=0:q1=0
166   x=-9:y=45
167   x1=-70:y1=15
168   gshape(x-28,y-26),d2%:rem D2% uses a different corner than D1%
169   gshape(x1-28,y1-26),d2%
170   sleep 1*10^5
171   gshape(x-28,y-26),blank%
172   gshape(x1-28,y1-26),blank%
173   if p=0 then x=x+20
174   if p1=0 then x1=x1+20
175   if p=1 then x=x-20
176   if p1=1 then x1=x1-20
177   if q=0 then y=y+20
178   if q1=0 then y1=y1+20
179   if q=1 then y=y-20
180   if q1=1 then y1=y1-20
181   gshape(x-20,y-18),d1%
182   gshape(x1-20,y1-18),d1%
183   sleep 1*10^5
184   if p=1 and x<80 and y>60 then 199
185   gshape(x1-28,y1-26),blank%
186   gshape(x-28,y-26),blank%
187   if p1=0 then x1=x1+20
188   if p=0 then x=x+20
189   if p=1 then x=x-20
190   if p1=1 then x1=x1-20
191   if x>270 then p=1
192   if x1>270 then p1=1
193   rem if x<-10 then p=0
194   if y>60 then q=1
195   if y1>60 then q1=1
196   if y<39 then q=0
197   if y1<39 then q1=0
198   goto 168
199   '
200   gshape(x-28,y-26),blank%
201   gshape(x1-28,y1-26),blank%
202   x=x-10
203   x1=x1-20
204   if y1<60 then y1=y1+20
205   gshape(x-28,y-26),d2%
206   gshape(x1-28,y1-26),d2%
207   sleep 1*10^5
208   gshape(x-28,y-26),blank%
209   gshape(x1-28,y1-26),blank%
210   sleep 1*10^5
211   x=x-10
212   if y1<60 then y1=y1+20
213   gshape(x-20,y-10),d1%
214   gshape(x1-20,y1-18),d1%
215   sleep 1*10^5
216   if x<120 then 218
217   goto 199
218   '
219   randomize
220   n1=int(rnd*6+1)
221   n=int(rnd*6+1)
222   if n=1 then gosub 236
223   if n=2 then gosub 239
224   if n=3 then gosub 242
225   if n=4 then gosub 246
226   if n=5 then gosub 250
227   if n=6 then gosub 255
228   x=x1:y=y1-8
229   if n1=1 then gosub 236
230   if n1=2 then gosub 239
231   if n1=3 then gosub 242
232   if n1=4 then gosub 246
233   if n1=5 then gosub 250
234   if n1=6 then gosub 255
235   goto 270
236   rem one spot
237   gosub 260
238   return
239   '
240   gosub 261
241   return
242   '
243   gosub 260
244   gosub 261
245   return
246   '
247   gosub 264
248   gosub 261
249   return
250   '
251   gosub 260
252   gosub 261
253   gosub 264
254   return
255   '
256   gosub 261
257   gosub 264
258   gosub 267
259   return
260   gshape(x-2,y+6),spot%:return
261   gshape(x-13,y+14),spot%:rem lower left
262   gshape(x+9,y-2),spot%:rem upper right
263   return
264   gshape(x-13,y-2),spot%:rem upper left
265   gshape(x+9,y+14),spot%:rem lower right
266   return
267   gshape(x-13,y+6),spot%:rem center left
268   gshape(x+9,y+6),spot%:rem center right
269   return
270   rem calculation for over/un
271   pena 1
272   A=n+n1
273   if pl=1 then 277
274   if pl=2 then 290
275   if dpl=1 then 293
276   if dpl=2 then 298
277   if a=7 or a=11 then 344
278   if a=2 or a=3 or a=12 then 357
279   pl=2:point=a:gosub 280:goto 288
280   pena 6
281   if a=4 then paint(82,120),1
282   if a=5 then paint(102,120),1
283   if a=6 then paint(142,120),1
284   if a=8 then paint(174,120),1
285   if a=9 then paint(202,120),1
286   if a=10 then paint(232,120),1
287   return
288   ask mouse x%,y%,b%:if b%<>4 then 288
289   goto 160
290   if a=7 then goto 357
291   if a=point then goto 344
292   goto 288
293   if a=7 or a=11 then 344
294   if a=2 or a=3 then 344
295   point=a:gosub 280
296   dpl=2
297   goto 300
298   if a=7 then goto 344:rem win
299   if a=point then 357: rem lose
300   ask mouse x%,y%,b%:if b%<>4 then 300
301   goto 160
302   gosub 343
303   goto 150
304   sleep 3*10^6
305   ?at(30,100)"MAKE A BET OR GOTO ANOTHER GAME"
306   pena 2:penb 1:?at(0,108);"QUIT                              QUIT":pena 1:penb 2
307   '
308   bet=0:pl=0:dpl=0
309   ask mouse x%,y%,b%
310   if b%<>4 then 309
311   penb 3:?at(30,100);"                               ":?at(0,108);"                                      "
312   if  y%>175 and dpl=0 then goto 318
313   if y%<175 and y%>165 and pl=0 then 327
314   rem  if x%>100 and x%<200 and y%>110 then gosub 640
315   rem quit  if y%<110 and y%>100 then chain "cstopsino",37,all
316   if y%<100 and pl=1 or dpl=1 then 368
317   goto 309
318   rem pass line
319   pl=1
320   bet=bet+1:pot=pot-1
321   pena 1:penb 8:?at(139,183);bet
322   gosub 343
323   peno 2:circle(150,180),7:pena 2:paint(155,180),1
324   if bet>4 then 368
325   sleep .25*10^6
326   goto 309
327   'dont pass line
328   dpl=1
329   bet=bet+1:pot=pot-1
330   pena 1:penb 8:?at(169,171);bet
331   GOSUB 343
332   peno 2:circle(180,168),7:pena 2:paint(184,168),1
333   if bet>4 then 368
334   sleep .25*10^6
335   goto 309
336   '
337   stop
338   b3=b3+1:pot=pot-1
339   GOSUB 343
340   sleep .25*10^6
341   return
342   '
343   pena 1:penb 2:?at(40,10);" YOU HAVE"POT"IN YOUR POCKET ":RETURN
344   '
345   sleep 1*10^6
346   if a=7 or a=11 then gosub 354
347   if pl>0 then gosub 355:goto 350
348   if dpl=1 then gosub 366:goto 150
349   gosub 355
350   for t=1 to bet*2:pot=pot+1:sleep 1*10^5:gosub 343:next
351   '
352   goto 150
353   x%=narrate (A$):return
354   A$ = translate$ ("thats a natural! "):goto 353
355   A$ = translate$ ("you win!"):goto 353
356   goto 150
357   '
358   sleep 1*10^6
359   if a=2 or a=3 or a=12 then gosub 364:goto 150
360   if a=7 then gosub 365:goto 150
361   gosub 366
362   goto 150
363   x%=narrate (A$):return
364   A$ = translate$(" craps! you lose."):goto 363
365   A$ = translate$ (" seven! Thats a loser."):goto 363
366   A$ = translate$("you lose!"):goto 363
367   '
368   A$=translate$("coming out"):gosub 353:goto 160
369   return
370   stop
