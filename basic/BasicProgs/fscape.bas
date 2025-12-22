10    '          Fracscapes
20    '              or
30    '    3-D Fractal landscapes
40    '
50    '   by Michiel van de Panne
60    '   From the july issue of Creative Computing (R.I.P.)
70    '
80    '    hacked unmercifully and
90    '   modified for the Amiga from
100   '   the Mac version by
110   '   David Milligan, 70707,2521
120   '   and Ted Ingalls
130   '         10-19-85
140   '
150   '  **  This program will construct a realistic
160   '  **  3-D landscape fractal from many random numbers
170   '  **  in up to seven levels of detail, simulating
180   '  **  mountain ranges, coastlines, sea floor and/or
190   '  **  surfaces, lakes, islands, etc.
200   '  **  Once the array used to do the drawing is created,
210   '  **  it can be saved to disk and reloaded and re-drawn.
220   '  **  We saved the array rather than the screen because
230   '  **  (1) we couldn't figure out how to find the start
240   '  **  of screen memory from ABasiC and couldn't get
250   '  **  a 640x200 screen stuffed into an array, and
260   '  **  (2) the array can be re-drawn with different scaling
270   '  **  factors for perspective changes and with sea level on 
280   '  **  or off (default is off).
290   '  **  The length of time required to draw an array depends
300   '  **  on the number of levels selected. For each increase
310   '  **  in level the number of triangular subdivisions
320   '  **  is quadrupled. A level 7 landscape has the highest
330   '  **  'resolution', but takes over an hour to draw.
340   '
350   '  **  One of the main things we added to the original
360   '  **  program was color. The 12 colors are selected
370   '  **  by what we determined was altitude to render
380   '  **  forests, water, snow, dirt, etc.
390   '  **  Considering we understand vitually nothing
400   '  **  of the math involved, it works pretty well.
410   '  **  If you've got a better idea, have at it.
420   '  **  This program is definately NOT polished,
430   '  **  optimized or bug free, but it is fun to
440   '  **  play with.
450   '  **  While I don't understand them, I find fractal
460   '  **  graphics generation fascinating. If you've
470   '  **  got a nifty fractal program, upload it here
480   '  **  or sing out via E-mail.
490   '
500   '           David Milligan, 70707,2521
510   '
520   scnclr
530   '
540   rem *** Set Screen to 640 x 200 ***
550   '
560   ask window wid%,hi%
570   if wid%<600 then screen 1,4,0
580   '
590   '   *** Program Initialization ***
600   '
610   dim d(128,65),name$(40):a%=varptr(d(0,0)):l%=33280:le=0
620   gosub 4450:gosub 690:gosub 770:gosub 3300:goto 2760
630   '
640   rem *** Trap Mouse Button ***
650   '
660   ask mouse x%,y%,b%:if b%=0 then 660
670   return
680   '
690   rem *** Turn Off Cursor ***
700   '
710   rgb 15,0,0,0:return
720   '
730   rem *** Turn Cursor on ***
740   '
750   rgb 15,11,11,11:return
760   '
770   rem *** Set Program Colours ***
780   '
790   rgb 0,0,0,0
800   rgb 1,15,15,15
810   rgb 3,8,8,8:' light grey
820   rgb 4,5,5,5:' dark grey
830   rgb 5,7,4,3:' light brown
840   rgb 6,6,3,2:' dark brown
850   rgb 7,0,4,0:' medium green
860   rgb 8,0,0,12:' light blue
870   rgb 9,0,0,10:' blue
880   rgb 10,0,0,7:' medium blue
890   rgb 11,0,0,4:' dark blue
900   rgb 12,0,6,0:' green
910   rgb 13,0,7,0:' light green
920   rgb 14,0,2,0 :' dark green
930   return
940   '
950   '   *** Calculate array data and insert ***
960   '
970   print at (8,3);"Working on Level "
980   ds=2:for n=1 to le:ds=ds+2^(n-1):next n
990   mx=ds-1:my=mx/2:rh=pi*30/180:vt=rh*1.2
1000  for n=1 to le:l=10000/1.8^n
1010  print at (26,3);n
1020  ib=mx/2^n:sk=ib*2
1030  randomize -1
1040  gosub 1120:rem Assign heights along x in array
1050  gosub 1210:rem *** Assign heights along Y ***
1060  gosub 1300:rem *** Assign heights along Z ***
1070  next n
1080  scnclr:goto 2680
1090  '
1100  '   *** Heights along X ***
1110  '
1120  for ye=0 to mx-1 step sk
1130  for xe=ib+ye to mx step sk
1140  ax=xe-ib:ay=ye:gosub 1400:d1=d:ax=xe+ib:gosub 1400:d2=d
1150  d=(d1+d2)/2+rnd(1)*l/2-l/4:ax=xe:ay=ye:gosub 1470
1160  next xe
1170  next ye:return
1180  '
1190  rem *** Heights along Y ***
1200  '
1210  for xe=mx to 1 step -sk
1220  for ye=ib to xe step sk
1230  ax=xe:ay=ye+ib:gosub 1400:d1=d:ay=ye-ib:gosub 1400:d2=d
1240  d=(d1+d2)/2+rnd(1)*l/2-l/4:ax=xe:ay=ye:gosub 1470
1250  next ye
1260  next xe:return
1270  '
1280  rem *** Heights along Z ***
1290  '
1300  for xe=0 to mx-1 step sk
1310  for ye=ib to mx-xe step sk
1320  ax=xe+ye-ib:ay=ye-ib:gosub 1400:d1=d
1330  ax=xe+ye+ib:ay=ye+ib:gosub 1400:d2=d
1340  ax=xe+ye:ay=ye:d=(d1+d2)/2+rnd(1)*l/2-l/4:gosub 1470
1350  next ye
1360  next xe:return
1370  '
1380  rem *** Return data from array ***
1390  '
1400  if ay>my then 1420
1410  by=ay:bx=ax:goto 1430
1420  by=mx+1-ay:bx=mx-ax
1430  d=d(bx,by):return
1440  '
1450  rem *** Put data into array ***
1460  '
1470  if ay>my then 1490
1480  by=ay:bx=ax:goto 1500
1490  by=mx+1-ay:bx=mx-ax
1500  d(bx,by)=d:return
1510  '
1520  rem *** Sea level section ***
1530  '
1540  if sealevel=0 then gosub 1750:return
1550  if xo<>-999 then 1580
1560  if zz<0 then gosub 2010:z2=zz:zz=0:goto 1740
1570  gosub 2050:goto 1730
1580  if z2>0 and zz>0 then gosub 1750:goto 1730
1590  if z2<0 and zz<0 then z2=zz:zz=0:goto 1740
1600  w3=zz/(zz-z2):x3=(x2-xx)*w3+xx:y3=(y2-yy)*w3+yy:z3=0
1610  zt=zz:yt=yy:xt=xx
1620  if zz>0 then 1710
1630  '
1640  rem *** Going into water ***
1650  '
1660  zz=z3:yy=y3:xx=x3:gosub 2320
1670  gosub 2010:zz=0:yy=yt:xx=xt:z2=zt:goto 1740
1680  '
1690  rem *** Coming out of water ***
1700  '
1710  zz=z3:yy=y3:xx=x3:gosub 2320
1720  gosub 2050:zz=zt:yy=yt:xx=xt
1730  z2=zz
1740  x2=xx:y2=yy:return
1750  '
1760  '  *** New Color Subroutine ***
1770  '
1780  if zz<0 then goto 1890
1790  if zz>950 then pena 2:return
1800  if zz>850 then pena 3:return
1810  if zz>750 then pena 4:return
1820  if zz>650 then pena 5:return
1830  if zz>550 then pena 6:return
1840  if zz>450 then pena 13:return
1850  if zz>350 then pena 12:return
1860  if zz>100 then pena 7:return
1870  gosub 2050
1880  return
1890  '
1900  '  *** below sea level ***
1910  '
1920  if zz>-200 then gosub 2010:return
1930  if zz>-500 then pena 9:return
1940  if zz>-800 then pena 10:return
1950  if zz>-1200 then pena 11:return
1960  pena 11
1970  return
1980  '
1990  rem *** Switch to sea level color ***
2000  '
2010  pena 8:f1=1:return
2020  '
2030  rem *** Switch to land color ***
2040  '
2050  pena 14
2060  f1=0:return
2070  '
2080  '   *** Rotation ***
2090  '
2100  if xx<>0 then 2130
2110  if yy<=0 then ra=-pi/2:goto 2150
2120  ra=pi/2:goto 2150
2130  ra=atn(yy/xx)
2140  if xx<0 then ra=ra+pi
2150  r1=ra+rh:rd=sqr(xx*xx+yy*yy)
2160  xx=rd*cos(r1):yy=rd*sin(r1)
2170  return
2180  '
2190  rem *** Tilt down ***
2200  '
2210  rd=sqr(zz*zz+xx*xx)
2220  if xx=0 then ra=pi/2:goto 2250
2230  ra=atn(zz/xx)
2240  if xx<0 then ra=ra+pi
2250  r1=ra-vt
2260  xx=rd*cos(r1)+xx:zz=rd*sin(r1)
2270  return
2280  '
2290  rem *** Plot to (xp,yp) ***
2300  '
2310  gosub 1540
2320  xx=xx*xs:yy=yy*ys:zz=zz*zs
2330  gosub 2100:rem *** Rotate ***
2340  gosub 2210:rem *** Tilt up ***
2350  if xo=-999 then pr$="M" else pr$="D"
2360  xp=int(yy)+cx:yp=int(zz)
2370  gosub 2400
2380  return
2390  '
2400  rem *** do plotting here ***
2410  '
2420  ask mouse x%,y%,b%:if b%<>0 then 2760
2430  xp=xp*1.38:yp=48.53-0.663*yp:if pr$="M" then x8=xp:y8=yp
2440  draw (x8,y8 to xp,yp):x8=xp:y8=yp:xo=xp
2450  return
2460  '
2470  rem *** Plot X Axis ***
2480  '
2490  for ax=0 to mx:xo=-999:for ay=0 to ax
2500  gosub 1400:zz=d:yy=ay/mx*10000:xx=ax/mx*10000-yy/2
2510  gosub 2310:next ay:next ax
2520  return
2530  '
2540  rem *** Plot Y Axis ***
2550  '
2560  for ay=0 to mx:xo=-999:for ax=ay to mx
2570  gosub 1400:zz=d:yy=ay/mx*10000:xx=ax/mx*10000-yy/2
2580  gosub 2310:next ax:next ay
2590  return
2600  '
2610  rem *** Plot Z Axis ***
2620  '
2630  for ex=0 to mx:xo=-999:for ey=0 to mx-ex
2640  ax=ex+ey:ay=ey:gosub 1400:zz=d:yy=ay/mx*10000
2650  xx=ax/mx*10000-yy/2:gosub 2310:next ey:next ex
2660  return
2670  '
2680  '   *** Setup Screen ***
2690  '
2700  close 2:cmd 1:graphic(1):gosub 760
2710  tax=ax:tay=ay
2720  gosub 2630
2730  gosub 2560
2740  gosub 2490
2750  '
2760  rem *** Main Menu Section ***
2770  '
2780  gosub 3370
2790  print at(4,2);"-> Use Keyboard to Select <-"
2800  print at(6,4);"1 - Start New Landscape"
2810  ? at(6,5);"2 - Draw Existing Array"
2820  ? at(6,6);"3 - Save Fractal Array"
2830  ? at(6,7);"4 - Load Fractal Array"
2840  ? at(6,8);"5 - Reset Scaling Factors"
2850  ? at(6,9);"6 - Set Sea Level Options"
2860  rem ? at(6,10);"7 - Read & Display Mouse x,y"
2870  ? at(6,11);"7 - Close This Window !"
2880  ? at(10,12);"Click the Left Button"
2890  ? at(10,13);"To Restore Menu"
2900  ? at(6,14);"0 - Exit to ABasiC"
2910  pena 0:gosub 4500
2920  print at(10,16);"Selection (0-8) ";:input a$
2930  query=val(a$):print at(10,16);spc(20):erase a$
2940  on query goto 3120,4140,3650,3760,4240,4010,4000,4000,4000
2950  '
2960  rem *** Program exit ***
2970  '
2980  scnclr:close 3
2990  cmd 1:scnclr:close 1
3000  cmd 0:pena 0
3010  '
3020  rem *** Restore ABasiC's colours ***
3030  '
3040  rgb 0,6,9,15
3050  rgb 1,0,0,0
3060  rgb 2,15,15,15
3070  gosub 750
3080  clr:end
3090  '
3100  rem *** Start a new fractal screen ***
3110  '
3120  scnclr:close 3
3130  '
3140  rem *** New landscape ***
3150  '
3160  cmd 1:graphic(1):scnclr
3170  gosub 3330
3180  '
3190  rem *** Prompt to begin drawing ***
3200  '
3210  print at(2,2);"Click the Left Mouse Button to Start."
3220  print at(4,4);"Click While Drawing to Abort."
3230  gosub 660:scnclr
3240  print at(8,3);"Number of levels ";:input le
3250  scnclr:if le<1 or le>7 then 3240
3260  goto 950
3270  '
3280  rem *** Windows ***
3290  '
3300  window #1,0,0,639,199,"Fracscapes"
3310  return
3320  '
3330  window #2,120,50,340,60,"New Fracscape"
3340  cmd #2:graphic(0):scnclr
3350  return
3360  '
3370  window #3,100,20,300,160,"Main Menu"
3380  cmd 3:graphic(0):scnclr
3390  return
3400  '
3410  window #4,100,50,400,40,"Save Array"
3420  cmd 4:graphic(0):scnclr
3430  return
3440  '
3450  window #5,100,100,400,40,"Load Array"
3460  cmd 5:graphic(0):scnclr
3470  return
3480  '
3490  window #6,100,20,340,130,"Array Description"
3500  cmd 6:graphic(0):scnclr
3510  return
3520  '
3530  window #7,100,30,340,60,"Sea Level Options"
3540  cmd 7:graphic(0):scnclr
3550  return
3560  '
3570  window #8,50,20,340,50,"Draw Array in Memory"
3580  cmd 8:graphic(0)
3590  return
3600  '
3610  window #9,150,30,300,130,"Scaling Settings"
3620  cmd 9:graphic(0)
3630  return
3640  '
3650  rem *** screen save ***
3660  '
3670  on error goto 4540
3680  gosub 3410:name$=""
3690  print at(2,2);"Save Array as -> ";:line input name$
3700  d(0,65)=le:d(1,65)=mx:d(2,65)=my:d(3,65)=tax:d(4,65)=tay
3710  d(5,65)=xs:d(6,65)=ys:d(7,65)=zs:d(8,65)=sealevel
3720  bsave name$,a%,l%
3730  scnclr:close 4:cmd 3
3740  goto 4110
3750  '
3760  rem *** Screen Load ***
3770  '
3780  ' on error goto 5000
3790  gosub 3450:name$=""
3800  print at(2,2);"Name of Array to Load -> ";:line input name$
3810  bload name$,a%
3820  le=d(0,65):mx=d(1,65):my=d(2,65):ax=d(3,65):ay=d(4,65)
3830  xs=d(5,65):ys=d(6,65):zs=d(7,65):sealevel=d(8,65)
3840  scnclr:close 5
3850  gosub 3490
3860  ? at(7,2);"Array name -> ";name$
3870  ? at(7,4);"Number of Levels -> ";le
3880  if sealevel=0 then level$="off" else level$="on"
3890  ? at(7,6);"Sea Level Display -> ";level$
3900  ? at(7,8);"Scaling Values ->  X= ";xs
3910  ? at(26,9);"Y= ";ys
3920  ? at(26,10);"Z= ";zs
3930  ? at(5,13);"Click left button to continue"
3940  gosub 640
3950  scnclr:close #6:cmd 3
3960  goto 4110
3970  '
3980  rem *** Turn off menu window ***
3990  '
4000  scnclr:close 3:gosub 660:goto 2760
4010  '
4020  ' **** Set Sea Level Option ****
4030  '
4040  gosub 3530
4050  print at (2,3);"Display sea level surface (Y/N) ";:input a$
4060  if a$="y" or a$="Y" then sealevel=1 else sealevel=0:goto 4070
4070  scnclr:close 7:cmd 3
4080  '
4090  '  ***  Error Trap ***
4100  '
4110  on error goto 4540
4120  query=0:erase a$
4130  goto 2920
4140  '
4150  ' *** Redraw old Array ***
4160  '
4170  if le=0 then 2920
4180  gosub 3570
4190  print at(2,2);"Clear Screen Before Re-Draw (Y/N) ";:input a$
4200  scnclr:close 8:cmd 3:scnclr:close 3:cmd 1:graphic(1)
4210  if a$="y" or a$="Y" then scnclr
4220  erase a$:goto 2700
4230  '
4240  ' *** Scaling Settings ***
4250  '
4260  gosub 3610
4270  graphic(0)
4280  print at(5,2);"Current Scaling Settings :"
4290  print at(13,4);"X= ";xs
4300  print at(13,5);"Y= ";ys
4310  print at(13,6);"Z= ";zs
4320  print at(5,8);"Press C to Change Settings"
4330  print at(11,9);"D for Default Settings"
4340  print at(11,10);"X to Exit"
4350  gosub 4500
4360  print at(13,12);"Selection ";:input a$
4370  if a$="c" or a$="C" then 4420
4380  if a$="d" or a$="D" then gosub 4460:goto 4410
4390  if a$<>"x" and a$<>"X" then 4410
4400  scnclr:close 9:cmd 3:goto 4110
4410  scnclr:erase a$:goto 4280
4420  print at(13,12);spc(16)
4430  print at(4,12);"Input New X,Y,Z ";:input xs,ys,zs
4440  goto 4410
4450  '
4460  ' *** Stock Scaling Factors ***
4470  '
4480  xs=.04:ys=.04:zs=.05:return
4490  '
4500  for i=0 to 10
4510  get a$:erase a$:next i
4520  on error goto 4540
4530  return
4540  '
4550  '
4560  '    **** error trap ****
4570  '
4580  '
4590  fmem%=fre
4600  window #10,100,100,300,90,"Rats - An Error Occurred"
4610  cmd #10:graphic(0):scnclr
4620  ?at(2,2);"Error # ";err;" occurred at line ";erl
4630  ?at(2,4);err$(err)
4640  ?at(2,5);"There are ";fmem%;" bytes of memory showing"
4650  ?at(2,7);"Click left button to continue...."
4660  gosub 640
4670  scnclr:close 10,3,4,5,6
4680  goto 2760
