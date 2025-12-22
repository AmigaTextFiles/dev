10    ' Mandel.Bas - (C) 1985 Kevin A. Bjorke
20    ' 25724 Salceda Road, Valencia CA 91355   CIS74756,464
30    '
40    lmt%=127:ht%=150:wd%=150:depth%=4:acorn=-2.:bcorn=-1.25:sidex=2.5:sidey=2.5
50    cl%=2^depth%:n%=(lmt%+1)/cl%:e$=chr$(27)
60    gx=sidex/wd%:gy=sidey/ht%
70    scnclr:drawmode 1:peno 1:pena 4:penb 2:graphic(1)
80    ? at(wd%+16,80);inverse(1);" MANDEL ";:penb 0:pena 6:? at(wd%+16,89);"by";at(wd%+16,98);"Kevin Bjorke"
90    pena 1:? at(wd%+3,8);acorn;at(wd%+3,ht%);acorn+sidey;at(0,ht%+10);bcorn;at(wd%-24,ht%+10);bcorn+sidex;
100   ? at(wd%+12,32);"<ESC> to End";at (wd%+12,50);"Left Button";at(wd%+20,58);"to Zoom."
110   graphic(0):box (0,0;wd%+1,ht%+1),1
115   ac=acorn:y%=1
120   bc=bcorn:x%=1
130   az=0:bz=0:ct%=0
140   while (ct%<lmt%) and (sqr(az*az+bz*bz)<2.)
150   tz=az*az-bz*bz+ac:bz=2*az*bz+bc:az=tz:ct%=ct%+1:wend
160   ask mouse p%,q%,b%:if b%=4 then goto 280
170   get a$:if a$=e$ then end
180   draw (x%,y%),ct%\n%:bc=bc+gx:x%=x%+1:if x%<=wd% then 130
190   ac=ac+gy:y%=y%+1:if y%<=ht% then 120
200   goto 115
230   '
240   ask mouse p%,q%,b%:if b%=4 then 240 else return
250   ask mouse p%,q%,b%:if b%=0 or p%<1 or q%<1 or p%>wd% or q%>ht% then 240 else return
260   gosub 240:gosub 250:return
270   '
280   gosub 260:s%=p%:t%=q%:drawmode 2:gosub 240
290   ask mouse p%,q%,b%:if b%=4 then 310
300   for m%=1 to 2:box(s%,t%;p%,q%),0:next m%:goto 290
310   if p%<1 or p%>wd% or q%<1 or q%>ht% then 290
320   box(s%,t%;p%,q%),0:drawmode 2
330   bcorn=bcorn+(s%-1)*gx:acorn=acorn+(t%-1)*gy
340   sidex=(p%-s%)*gx:sidey=(q%-t%)*gy:if sidex=0. then sidex=gx/2
350   if sidey=0. then sidey=gy/2
360   goto 60
370   '
380   ' Mandel.Bas allows you to view slices of the Mandelbrot set, a
390   '   fractal construct of complex number operations. Each point in
400   '   the displayed image is the representation of a complex point
410   '   "c" -- the imaginary part as horizontal, the real vertical.
420   ' Mandel.Bas allows you to use the Amiga's mouse to "Zoom In"
430   '   on selected pieces of the set -- you can select arbitrary
440   '   windows at any time.
450   '
460   ' Currently, Mandel.Bas is designed to be used with the default
470   ' number of colors & reso -- changing the values of "depth%"
480   ' and "wd%", along with an appropriate screen command, can let
490   ' hi-res junkies get even more colorful pictures, at the price
500   ' of additional computing time.
510   '                                 --Kevin Bjorke
520   ' /* eof */
