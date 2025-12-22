1     rem mouse.menu John R Blackburn Nov 1985
4     lx=1:ly=3:lp=1
6     s1$="please be patient while i am surching for basic programs"
7     s2$="i am now loading "
8     s3$="you have selected"
10    screen 1,1,0
20    dim a$(50)
30    print at (30,10) inverse(1) "SEARCHING FOR BASIC PROGRAMS"
31    print at (0,0)
32    ss$=s1$:gosub 500
35    chdir "ram:"
50    shell "list df0: p #?.bas quick to list.prg"
60    open "i",#2,"df0:list.prg"
70    for x = 0 to 41
80    line input#2, a$(x)
90    if not eof(2) then goto 100
95    y=x: goto 108
100   next x
108   close #2:chdir "df0:"
110   scnclr:print at (10,1) inverse(1) "PRESS LEFT MOUSE BUTTON TO LOAD SELECTED PROGRAM"
111   for x = 1 to (y-1)
112   t = instr(1,a$(x),"."): t=t-1
114   a$(x)=left$(a$(x),t)
116   px = 1
117   if x>20 then px = 40
118   py=x+2
119   if x>20 then py=(x-20)+2
120   print at (px,py) x; a$(x)
130   next x
200   ask mouse mx%,my%,b%
210   if b%=4 then goto 400
300   if my%<18 then goto 200
305   if my%> 175 then goto 200
310   p= fix((my%-10)/8)
320   if mx%>320 then p=p+20
330   if p<1 or p> (y-1) then goto 200
350   px=1
355   if p>20 then px=40
360   py=p+2
365   if p>20 then py=(p-20)+2
368   if px=lx and py=ly then goto 200
369   print at (lx,ly) lp; a$(lp)
370   print at (px,py) inverse(1) p; a$(p)
371   print at (0,0)
375   lx=px:ly=py:lp=p
380   ss$=s3$+a$(p):gosub 500
384   sleep 10^6
385   ask mouse mx%,my%,b%
386   if b%=4 then goto 400
387   sleep 10^6
395   goto 200
400   scnclr:print at (30,10) inverse(1) "LOADING ";a$(p)
401   print at (0,0)
402   ss$=s2$+a$(p):gosub 500
410   chain a$(p)
500   s$=translate$(ss$)
510   s%=narrate(s$)
520   return
