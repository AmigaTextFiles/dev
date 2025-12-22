10    screen 1,4,0: randomize -1: pena 7
11    rgb 1,15,15,15:rgb 8,10,8,6
12    rgb 11,0,10,15
20    dim d(64,32)
30    input "Number of levels <1-6> ";le: if le < 1 or le > 6 then 30
40    ds=2: for n=1 to le:ds=ds+2^(n-1):next n
50    mx=ds-1:my=mx/2:rh=pi*30/180:vt=rh*1.2
60    for n=1 to le:L=10000/1.8^n
70    ?: ? "Working on level ";n
80    ib=mx/2^n:sk=ib*2
90    gosub 150: ' *** Assign heights along X in array ***
100   gosub 220: ' *** Assign heights along Y in array ***
110   gosub 290: ' *** Assign heights along diag. in array ***
120   next n
130   goto 640:  ' *** Draw ***
140   ' *** Heights along x ***
150   for ye = 0 to mx - 1 step sk
160   for xe = ib+ye to mx step sk
170   ax = xe-ib: ay = ye: gosub 370: d1=d: ax = xe+ib: gosub 370:                 d2 = d
180   d = (d1+d2)/2 + rnd(1) * L/2 - L/4: ax = xe: ay = ye: gosub 420
190   next xe
200   next ye: return
210   ' *** Heights along Y ***
220   for xe = mx to 1 step -sk
230   for ye = ib to xe step sk
240   ax = xe: ay = ye + ib: gosub 370: d1 = d: ay = ye - ib: gosub 370:           d2 = d
250   d = (d1+d2)/2 + rnd(1) * L/2 - L/4: ax = xe: ay = ye: gosub 420
260   next ye
270   next xe: return
280   ' *** Heights along diag. ***
290   for xe = 0 to mx - 1 step sk
300   for ye = ib to mx - xe step sk
310   ax = xe + ye - ib: ay = ye - ib: gosub 370: d1 = d
320   ax = xe + ye + ib: ay = ye + ib: gosub 370: d2 = d
330   ax = xe + ye: ay = ye: d = (d1+d2)/2 + rnd(1) * L/2 - L/4:                  gosub 420
340   next ye
350   next xe: return
360   ' *** Return data from array ***
370   if ay > my then 390
380   by = ay: bx = ax: goto 400
390   by = mx+1-ay: bx = mx-ax
400   d = d(bx,by): return
410   ' *** Put data into array ***
420   if ay > my then 440
430   by = ay: bx = ax: goto 450
440   by = mx+1-ay: bx = mx-ax
450   d(bx,by) = d: return
460   ' *** Put in sea level here ***
470   if xo <> -999 then 500
480   if zz < 0 then gosub 1070: z2 = zz: zz = 0: goto 620
490   gosub 1090: goto 610
500   if z2 > 0 and zz > 0 then 610
510   if z2 < 0 and zz < 0 then z2 = zz: zz = 0: goto 620
520   w3 = zz/(zz-z2): x3 = (x2-xx) * w3 + xx: y3 = (y2-yy) * w3 + yy:             z3 = 0
530   zt = zz: yt = yy: xt = xx
540   if zz > 0 then 590
550   ' *** Going into water ***
560   zz = z3: yy = y3: xx = x3: gosub 950
570   gosub 1070: zz = 0: yy = yt: xx = xt: z2 = zt: goto 620
580   ' *** Coming up out of water ***
590   zz = z3: yy= y3: xx= x3: gosub 950
600   gosub 1090: zz = zt: yy = yt: xx = xt
610   z2 = zz
620   x2 = xx: y2 = yy: return
630   ' **** Display here ****
640   gosub 1100: ' *** Set up plotting device or screen ***
650   xs = .04: ys = .04: zs = .04: ' *** scaling factors ***
660   for ax = 0 to mx: xo = -999: for ay = 0 to ax
670   gosub 370: zz = d: yy = ay/mx * 10000: xx = ax/mx * 10000 - yy/2
680   gosub 940: next ay: next ax
690   for ay = 0 to mx: xo = -999: for ax = ay to mx
700   gosub 370: zz = d: yy = ay/mx * 10000: xx = ax/mx * 10000 - yy/2
710   gosub 940: next ax: next ay
720   for ex = 0 to mx: xo = -999: for ey = 0 to mx-ex
730   ax = ex + ey: ay = ey: gosub 370: zz = d: yy = ay/mx *10000
740   xx = ax/mx * 10000 - yy/2: gosub 940: next ey: next ex
750   goto 1130: ' *** done plotting, goto end loop ***
760   ' *** Rotate ***
770   if xx <> 0 then 800
780   if yy <= 0 then ra = -pi/2: goto 820
790   ra = pi/2: goto 820
800   ra = atn(yy/xx)
810   if xx < 0 then ra = ra + pi
820   r1 = ra + rh: rd = sqr (xx*xx + yy*yy)
830   xx = rd * cos(r1): yy = rd * sin(r1)
840   return
850   ' *** Tilt down ***
860   rd = sqr(zz*zz + xx*xx)
870   if xx = 0 then ra = pi/2: goto 900
880   ra = atn (zz/xx)
890   if xx < 0 then ra = ra + pi
900   r1 = ra - vt
910   xx = rd * cos(r1) + xx: zz = rd * sin(r1)
920   return
930   ' *** Move or plot to (xp,yp)
940   gosub 470
950   xx = xx * xs: yy = yy * ys: zz = zz * zs
960   gosub 770: ' *** Rotate ***
970   gosub 860: ' *** Tilt up ***
980   if xo = -999 then pr$ = "M"
985   if xo <> -999 then pr$ = "D"
990   xp = int(yy) + cx: yp = int(zz)
1000  gosub 1030
1010  return
1020  ' *** plot line here ***
1030  xp = xp * 1.3: yp = 33.14 - .623 * yp
1040  if pr$ = "M" then x8 = xp: y8 = yp: xo = x
1045  if y8 > 199 or y8 < 0 or yp > 199 or yp < 0 then return
1050  draw (x8,y8 to xp,yp): x8 = xp: y8 = yp: return
1060  ' *** switch to sea color ***
1070  pena 11: return
1080  ' *** switch to land color ***
1090  pena 8: return
1100  ' * * * setup plotting device or screen * * *
1110  scnclr: pena 1: area (0,0 to 0,200 to 620,200 to 620,0 to 0,0):              return
1120  ' *** End loop ***
1130  getkey a$
1140  end
60000 '   This program come from "Creative Computing" July 1985 pp 78-82
60010 ' by Michiel van de Panne.  He used the method of generating
60020 ' fractal landscapes from the September 1984 issue of "Scientific
60030 ' American".  To modify the program you can change the color of
60040 ' pena in line 1070 and in line 1090.  You can change the
60050 ' background color by changing pena to a different color in line
60060 ' 1110.  The program can only handle 6 levels with a dimension of
60070 ' d(64,32) in line 20 -- if you want to wait for level 7 to be
60080 ' plotted, change line 20 to dimension d as dim d(128,64) for 
60090 ' 16384 triangles to generated.
60100 '   The size of the landscape can be scaled in line 1030.
60110 ' Line 10 and lines 1030-1040 have the computer dependent code.
60120 ' To remove the seas from the landscape change line 470 to read
60130 ' 470 return
