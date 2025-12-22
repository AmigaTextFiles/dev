5     '**** AMIGA OTHELLO ****
6     ' by David Addison c1986
7     ' this program is put into the public domain  ENJOY!
80    goto 860
90    m=29
100   ' **** MAIN LOOP ****
105   on error goto 11000:i=1
110   if i=1 then rgb 13,15,11,0 else rgb 13,6,9,15
115   ask mouse x%,y%,b%:if b%=4 and p(1)=0 and p(2)=0 then 1460
120   if pass=2 then 1850
130   x1=7*abs(i=2):y1=7*abs(i=1)
140   x=34+225*abs(i=2):y=101:drawmode 2:box(x,y;x+14,y+7):drawmode 0
150   for v=64 to 0 step -6:qq=sound(1,1,2,v,3000):qq=sound(2,1,2,v,3000+3000*abs(i=2)):next v
160   f=0:on p(i)+1 goto 200,440,440
170   i=i+1:if i<3 then 110
180   m=m-1:if m<0 then 1850
190   goto 105
200   ' **** COMPUTER'S TURN ****
210   max=0:tempx=0:tempy=0:x1=0
212   y1=0
220   if grid(x1,y1) then 270
230   va=0:d1=-1
232   d2=-1
240   on error goto 10260
250   if grid(x1+d1,y1+d2)=3-i then 280
260   on error goto 10270:d2=d2+1:if d2<2 then 240
265   d1=d1+1:if d1<2 then 232
270   y1=y1+1:if y1<8 then 220
275   x1=x1+1:if x1<8 then 212
277   x1=tempx:y1=tempy:f=0:goto 370
280   a=2
285   on error goto 10300:temp=grid(x1+d1*a,y1+d2*a):if temp=0 then 260
290   if temp=i then 310
300   a=a+1:if a<8 then 285
305   goto 260
310   va=va+a
320   if x1=0 or x1=7 then va=va*4
330   if y1=0 or y1=7 then va=va*4
340   if x1=1 or x1=6 or y1=1 or y1=6 then va=va/6
345   randomize -1
350   if va>max or (va=max and rnd>0.5) then max=va:tempx=x1:tempy=y1
360   goto 260
370   if max=0 then 520
375   on error goto 11000
380   destx=wherex((tempy*8)+tempx)+1:desty=wherey((tempy*8)+tempx)+2
390   drawmode 2:box(x,y;x+14,y+7)
400   x=x+(abs(destx>x)-abs(destx<x)):y=y+abs(desty>y)-abs(desty<y)
410   box(x,y;x+14,y+7)
420   if x=destx and y=desty then drawmode 0:goto 560
430   goto 390
440   rem **** HUMAN'S TURN ****
445   drawmode 2
450   ask mouse x%,y%,b%:if b%<>4 then 450
452   if x%>0 and x%<21 and y%>143 and y%<164 then if x1>0 then x1=x1-1:goto 470
454   if x%>19 and x%<41 and y%>162 and y%<187 then if x1<7 then x1=x1+1:goto 470
456   if x%>19 and x%<41 and y%>143 and y%<164 then if y1>0 then y1=y1-1:goto 470
458   if x%>0 and x%<21 and y%>162 and y%<187 then if y1<7 then y1=y1+1:goto 470
460   if x%>60 and x%<103 and y%>167 and y%<187 then 560
462   if x%>195 and x%<239 and y%>167 and y%<187 then 520
463   goto 450
465   box(x,y;x+14,y+7)
470   destx=wherex((y1*8)+x1)+1:desty=wherey((y1*8)+x1)+2
472   box(x,y;x+14,y+7)
474   x=x+(abs(destx>x)-abs(destx<x)):y=y+abs(desty>y)-abs(desty<y)
476   box(x,y;x+14,y+7)
477   if x=destx and y=desty then 490
480   goto 472
490   goto 450
520   box(x,y;x+14,y+7):drawmode 0
530   sshape(110,87;199,110),temppic%():gshape(110,87),ipass%():pass=pass+1:for v=60 to 0 step -10:for v1=v to 0 step -10
540   qq=sound(1,1,2,v1,3000):qq=sound(2,1,2,v1,3000+3000*abs(i=2)):next v1:next v:sleep(3*10^6):gshape(110,87),temppic%():goto 800
550   rem **** FLIP CHIPS ****
560   if grid(x1,y1) then 840
570   d1=-1
575   d2=-1
580   on error goto 10600
590   if grid(x1+d1,y1+d2)=3-i then 620
600   on error goto 10610:d2=d2+1:if d2<2 then 580
605   d1=d1+1:if d1<2 then 575
607   if f=0 then 840
610   goto 800
620   for a=2 to 7:on error goto 10600:temp=grid(x1+d1*a,y1+d2*a):if temp=0 then 600
630   if temp=i then 650
640   next a:goto 600
650   if f=0 then sc(3-i)=sc(3-i)+1:gosub 720
660   if pass>0 then pass=pass-1
670   f=1:for b=1 to a-1
680   x1=x1+d1:y1=y1+d2:gosub 720
690   next b:x1=x1-d1*(b-1):y1=y1-d2*(b-1)
700   goto 600
710   rem **** PLOT CHIPS ****
720   drawmode 0
725   z=pixel(wherex((y1*8)+x1)+5,wherey((y1*8)+x1)+5)
730   if (z=3 or z=23 or z=7) and i=1 then gg=pip((y1*8)+x1):gosub 20000:goto 770
750   if (z=3 or z=23 or z=5) and i=2 then gg=pip((y1*8)+x1)+1:gosub 20000
770   for v=34 to 0 step -6:qq=sound(1,1,2,v,3000):qq=sound(2,1,2,v,3000+3000*abs(i=2)):next v
780   sc(i)=sc(i)+1:sc(3-i)=sc(3-i)-1:grid(x1,y1)=i:return
790   rem **** PRINT SCORES + MISC. SUBS ****
800   pena 0:? at(48,50);inverse(1) "  ":? at(50,48);inverse(1) "  ":pena 18:locate(48,50):? using "##";sc(1):pena 5:locate(50,48):? using "##";sc(1)
805   pena 0:? at(285,50);inverse(1) "  ":? at(287,48);inverse(1) "  ":pena 18:locate(285,50):? using "##";sc(2)
806   pena 7:locate(287,48):? using "##";sc(2)
810   pena 0:? at(64+221*abs(i=2),62);inverse(1) "  ":? at(66+221*abs(i=2),60);inverse(1) "  "
815   pena 18:locate(64+221*abs(i=2),62):? using "##";m:if i=1 then pena 5 else pena 7
816   locate(66+221*abs(i=2),60):? using "##";m
820   if sc(1)=0 or sc(2)=0 then 1850
830   goto 170
840   for v=64 to 0 step -1:qq=sound(1,1,2,v,1000):qq=sound(2,1,2,v,1000):next v:goto 450
850   rem **** INITIALIZATION ****
860   screen 0,5:drawmode 0:graphic 1
880   dim grid(7,7),p(2),sc(2),picture%(10000),gold%(700),blue%(700),computer%(200),mouse%(200),ipass%(500),pip(63),wherex(63),wherey(63)
890   dim pip1%(100),pip2%(100),pip3%(100),pip4%(100),pip5%(100),pip6%(100),pip7%(100),pip8%(100),temppic%(500),start%(300)
900   dim pip9%(100),pip10%(100),pip11%(100),pip12%(100),pip13%(100),pip14%(100),regsave%(100),sinewave%(11),onewin%(600),twowin%(600),tie%(600)
1000  bload "othelloscreen",varptr(picture%(0))
1005  bload "gold",varptr(gold%(0))
1010  bload "blue",varptr(blue%(0))
1015  bload "computer",varptr(computer%(0))
1020  bload "mouse",varptr(mouse%(0))
1025  bload "ipass",varptr(ipass%(0))
1030  bload "pip1",varptr(pip1%(0))
1035  bload "pip2",varptr(pip2%(0))
1040  bload "pip3",varptr(pip3%(0))
1045  bload "pip4",varptr(pip4%(0))
1050  bload "pip5",varptr(pip5%(0))
1055  bload "pip6",varptr(pip6%(0))
1060  bload "pip7",varptr(pip7%(0))
1065  bload "pip8",varptr(pip8%(0))
1070  bload "pip9",varptr(pip9%(0))
1075  bload "pip10",varptr(pip10%(0))
1080  bload "pip11",varptr(pip11%(0))
1085  bload "pip12",varptr(pip12%(0))
1090  bload "pip13",varptr(pip13%(0))
1095  bload "pip14",varptr(pip14%(0))
1100  bload "othelloscreen_dat",varptr(regsave%(0))
1105  bload "onewin",varptr(onewin%(0))
1110  bload "twowin",varptr(twowin%(0))
1115  bload "tie",varptr(tie%(0))
1120  bload "start",varptr(start%(0))
1125  gosub 30000
1460  rem **** PRE-GAME SETUP ****
1465  on error goto 11000
1470  gshape(0,0),picture%()
1480  restore 1490:for i=0 to 63:read wherex(i):next i
1490  data 146,162,178,194,210,226,242,258,130,146,162,178,194,210,226,242,114,130,146,162,178,194,210,226,98,114,130,146,162,178,194,210
1491  data 82,98,114,130,146,162,178,194,66,82,98,114,130,146,162,178,50,66,82,98,114,130,146,162,33,50,66,82,98,114,130,146
1500  restore 1510:for i=0 to 63:read wherey(i):next i
1510  data 43,51,59,67,75,83,91,99,51,59,67,75,83,91,99,107,59,67,75,83,91,99,107,115,67,75,83,91,99,107,115,123
1511  data 75,83,91,99,107,115,123,131,83,91,99,107,115,123,131,139,91,99,107,115,123,131,139,147,99,107,115,123,131,139,147,155
1530  restore 1540:for i=0 to 63:read pip(i):next i
1540  data 5,11,13,11,13,11,13,11,7,1,3,1,3,1,3,1,9,3,1,3,1,3,1,3,7,1,3,1,3,1,3,1,9,3,1,3,1,3,1,3,7,1,3,1,3,1,3,1,9,3,1,3,1,3,1,3,7,1,3,1,3,1,3,1
1550  restore 1560:for i=0 to 11:read sinewave%(i):next i
1555  audio 15,1:wave 6,sinewave%
1560  data 100,90,60,100,90,60,-100,-90,-60,-100,-90,-60
1690  for x=0 to 7:for y=0 to 7:grid(x,y)=0:next y:next x
1700  grid(4,3)=1:grid(3,4)=1:grid(3,3)=2:grid(4,4)=2
1702  gshape(146,91),pip2%():gshape(146,107),pip2%():gshape(130,99),pip3%():gshape(162,99),pip3%():rgb 13,9,9,9
1710  p(1)=1:p(2)=0:sc(1)=2:sc(2)=2:pass=0
1730  rem **** PLAYER SELECTION ****
1735  sshape(129,33;180,51),temppic%():gshape(129,33),start%():time=0
1740  ask mouse x%,y%,b%:time=time+1:if time>3000 then p(1)=0:p(2)=0:gshape(129,33),temppic%():goto 1820
1742  if b%<>4 then 1740 else time=0
1745  if x%>4 and x%<88 and y%>31 and y%<62 then gosub 24000
1750  if x%>221 and x%<298 and y%>31 and y%<62 then gosub 25000
1755  if x%>128 and x%<180 and y%>32 and y%<52 then gshape(129,33),temppic%():goto 1820
1760  sleep(0.5*10^6):goto 1740
1820  gshape(0,28),gold%():gshape(221,28),blue%()
1840  goto 90
1850  ' **** GAME OVER ****
1860  time=0:on error goto 11000
1870  if sc(1)=sc(2) then gshape(86,90),tie%():rgb 13,9,9,9:goto 1930
1890  if sc(1)>sc(2) then gshape(86,90),onewin%():rgb 13,15,11,0:goto 1930
1900  if sc(2)>sc(1) then gshape(86,90),twowin%():rgb 13,6,9,15
1930  ask mouse x%,y%,b%:time=time+1:if time>3000 then 1940
1935  if b%<>4 then 1930
1940  goto 1470
10260 resume 260
10270 resume 270
10300 resume 300
10600 resume 600
10610 resume 610
11000 pena 18:drawmode 0:locate(0,5):? "error # ";err:? "at line ";erl
11010 rgb 1,0,0,0:rgb 31,12,12,12:system
20000 h=(y1*8)+x1:on gg goto 20001,20002,20003,20004,20005,20006,20007,20008,20009,20010,20011,20012,20013,20014
20001 gshape(wherex(h),wherey(h)),pip1%():return
20002 gshape(wherex(h),wherey(h)),pip2%():return
20003 gshape(wherex(h),wherey(h)),pip3%():return
20004 gshape(wherex(h),wherey(h)),pip4%():return
20005 gshape(wherex(h),wherey(h)),pip5%():return
20006 gshape(wherex(h),wherey(h)),pip6%():return
20007 gshape(wherex(h),wherey(h)),pip7%():return
20008 gshape(wherex(h),wherey(h)),pip8%():return
20009 gshape(wherex(h),wherey(h)),pip9%():return
20010 gshape(wherex(h),wherey(h)),pip10%():return
20011 gshape(wherex(h),wherey(h)),pip11%():return
20012 gshape(wherex(h),wherey(h)),pip12%():return
20013 gshape(wherex(h),wherey(h)),pip13%():return
20014 gshape(wherex(h),wherey(h)),pip14%():return
24000 p(1)=p(1)+1
24010 if p(1)>1 then p(1)=0
24020 if p(1)=0 then gshape(12,51),computer%() else gshape(12,51),mouse%()
24030 return
25000 p(2)=p(2)+2
25010 if p(2)>2 then p(2)=0
25020 if p(2)=0 then gshape(229,51),computer%() else gshape(229,51),mouse%()
25030 return
30000 cnt=0
30010 for i=0 to 31
30020 rgb i,regsave%(cnt),regsave%(cnt+1),regsave%(cnt+2):cnt=cnt+3
30030 next i
30040 return
