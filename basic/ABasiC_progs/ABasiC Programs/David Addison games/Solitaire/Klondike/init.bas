1     ' KLONDIKE SOLITAIR by David Addison  ©1986
2     ' This program is in the Public Domain
3     '
4     '
5     clr:screen 1,3:scnclr:graphic 1
8     ?:?:?:?:? spc(23);"******  KLONDIKE  SOLITAIR  ******":?:? spc(23);"        by   David Addison"
10    ?:?:?:? spc(8);"   Click directly on card to put in Foundation, above or below"
11    ? spc(8);"will pick cards up.  If card can't be played on Foundation the"
12    ? spc(8);"cards will be picked up."
13    ?:? spc(8);"   Click on back of card in lower left corner to draw from deck."
15    ?:?:?:?:? spc(25);"******  PLEASE  STANDBY  ******"
17    gosub 28000
18    restore:goto 1110
20    wave 256,timbre1%():for az=0 to 64 step 20:qq=sound(1,1,1,az,800):qq=sound(2,1,1,az,500):next az:rem **** DRAW CARD ****
23    c=va:on su goto 36,46,24,28
24    gshape(x,y),diamond%():pena 6:goto 56
28    gshape(x,y),heart%():pena 6:goto 56
36    gshape(x,y),spade%():pena 4:goto 56
46    gshape(x,y),club%():pena 4
56    ? at(x+2,y+9);mid$(c$,c,1):? at(x+51,y+45);mid$(c$,c,1):gosub 15000:return
70    su=int(num/100)
80    va=num-100*su
90    return
100   if hf=1 then gosub 1480:return
110   if in>51 then 1490
120   od(in(0))=d(in):in=in+1:x=x(0):y=(in(0)*4)-2:let num=od(in(0)):gosub 70:gosub 20:in(0)=in(0)+1
125   if in>51 then x=x(0):y=139:for i=y+44 to y step -4:gshape(x,i),blank%():next i
140   return
150   '
188   rem
189   rem if cu<7 then ? at(13,17);chr$(left(cu));
190   return
280   if hf=1 then gosub 1480:return
290   st=cu
300   if in(cu)=0 then gosub 1510:return
310   if cu=0 then let num=od(in(0)-1):goto 330
320   let num=c(cu,0)
330   hf=1
340   if cu=0 then 390
341   j=y(left(cu))+y(in(cu)-1)+52
350   for i=y(0)+j to y(0)+y(left(cu))+2 step -4:gshape(x(cu),i),blank%():next i:gosub 150
390   if cu=0 then for i=(in(0)*4)+56 to (in(0)*4)-4 step -4:gshape(x(0),i),blank%():next i
392   j=0:if cu=0 then if in(0)-1>0 then let num=od(in(0)-2):gosub 70:x=x(0):y=((in(0)-1)*4)-6:gosub 20:goto 400
395   if p(cu,0)=0 then for i=y(j)+52 to y(j) step -4:gshape(x(cu),i),blank%():next i:goto 399
396   wave 256,timbre%():for i=3 to 0 step -1:gshape(x(cu),y(left(cu)-1)),back%():qq=sound(1,1,1,64,(i+1)*1000):qq=sound(2,1,1,64,(i+1)*1000):next i
399   if cu=0 then gosub 150
400   gosub 14000:return
410   if hf=0 then gosub 1520:return
420   if cu=0 then gosub 590:return
430   if st=cu then gosub 750:return
440   if in(cu)=0 then gosub 630:return
450   let num=c(cu,in(cu)-1)
460   gosub 70:ts=su:tv=va
470   if st=0 then let num=od(in(0)-1):goto 490
480   let num=c(st,0)
490   gosub 70:if ((ts=1) or (ts=2)) and ((su=1) or (su=2)) then gosub 1530:return
500   if ((ts=3) or (ts=4)) and ((su=3) or (su=4)) then gosub 1540:return
510   if tv<>va+1 then gosub 1550:return
520   if st=0 then gosub 700:return
530   gosub 25100:for i=0 to in(st)-1:let num=c(st,i):c(cu,in(cu))=num:gosub 70:x=x(cu):y=y(in(cu))+y(left(cu))+2
535   in(cu)=in(cu)+1:gosub 150:gosub 20
540   c(st,i)=0:next i:in(st)=0:hf=0
550   if p(st,0)=0 then return
560   let num=p(st,0):gosub 70:x=x(st):y=y(0)+y(left(st)-1)+2:gosub 20:c(st,in(st))=num:in(st)=1
570   for i=0 to 4:p(st,i)=p(st,i+1):next i:p(st,5)=0:left(st)=left(st)-1:if left(st)<0 then left(st)=0
575   gosub 188
580   return
590   if st<>0 then gosub 1560:return
600   gosub 25100:let num=od(in(0)-1):gosub 70:x=x(cu):y=((in(0)-1)*4)-2:gosub 20:gosub 150
610   flag=1:hf=0
620   return
630   if st=0 then let num=od(in(0)-1):goto 650
640   let num=c(st,0)
650   gosub 70
660   if va<>13 then gosub 1570:return
670   if st=0 then gosub 700:return
680   gosub 530
690   return
700   x=x(cu):y=y(in(cu))+y(left(cu))+2:c(cu,in(cu))=num:in(cu)=in(cu)+1:gosub 150:gosub 20
710   in(0)=in(0)-1:od(in(0))=0:hf=0:return
720   if in>51 then x=x(0):y=139:for i=y+44 to y step -4:gshape(x,i),blank%():next i:return
730   if in(0)>0 then let num=od(in(0)-1):gosub 70:x=x(0):y=((in(0)-1)*4)-2:gosub 20
740   return
750   gosub 25100:for i=0 to in(cu)-1:let num=c(cu,i):gosub 70:x=x(cu):y=y(i)+y(left(cu))+2:gosub 20:next i
760   hf=0
770   return
780   let num=od(in(0)-1):gosub 70:fl=1
785   if (f(su)<>va-1) and (f(su)=0) then return
790   if f(su)<>va-1 then tv=f(su):return
795   for i=(in(0)*4)+64 to (in(0)*4)-4 step -4:gshape(x(0),i),blank%():next i
800   gosub 980
810   od(in(cu))=0
820   if in(cu)=0 then gosub 720:return
830   gosub 730
835   gosub 150
840   return
850   if p(cu,0)=0 then for i=y(0)+52 to y(0) step -4:gshape(x(cu),i),blank%():next i:goto 875
855   j=y(left(cu))+52:for i=y(0)+j to y(0)+y(left(cu))+2 step -4:gshape(x(cu),i),blank%():next i
860   wave 256,timbre%():for i=3 to 0 step -1:gshape(x(cu),y(left(cu)-1)),back%():qq=sound(1,1,1,64,(i+1)*1000):qq=sound(2,1,1,64,(i+1)*1000):next i
875   c(cu,0)=p(cu,0):gosub 14000
880   if p(cu,0)=0 then return
890   let num=c(cu,0):x=x(cu):y=y(0)+y(left(cu)-1)+2:gosub 70:gosub 20
900   in(cu)=1
910   for i=0 to 4:p(cu,i)=p(cu,i+1):next i:p(cu,5)=0:left(cu)=left(cu)-1:if left(cu)<0 then left(cu)=0
915   gosub 188
920   return
930   if hf=1 then return
935   fl=0
940   if in(cu)=0 then return
950   if cu=0 then gosub 780:return
960   let num=c(cu,in(cu)-1):gosub 70
965   if (f(su)<>va-1) and (f(su)=0) then return
970   if f(su)<>va-1 then tv=f(su):return
980   x=x(1)
990   if su=1 then y=y1
1000  if su=2 then y=y2
1010  if su=3 then y=y3
1020  if su=4 then y=y4
1030  gosub 20:f(su)=va:fdation=1:money=money+5:gosub 27000
1040  in(cu)=in(cu)-1:if fl=1 then return
1050  c(cu,in(cu))=0
1060  if in(cu)=0 then gosub 850:return
1070  rem
1072  for i=y(in(cu))+64+y(left(cu))+2 to y(in(cu))+y(left(cu))+2 step -4:gshape(x(cu),i),blank%()
1075  next i
1090  x=x(cu):y=y(in(cu)-1)+y(left(cu))+2:let num=c(cu,in(cu)-1):gosub 70:gosub 20
1100  return
1110  dim c(8,12),p(8,5),d(51),od(23),f(4),x(8),y(13),in(8)
1115  dim back%(400),spade%(400),club%(400),diamond%(400),heart%(400),blank%(100),box%(1000),tempbox%(1000),left(8):what=4
1116  dim quit%(200),regsave%(100),tx$(13):c$="A23456789TJQK":money=0
1117  restore 1590:for i=1 to 13:read tx$(i):next i
1120  gosub 20000:gosub 20100
1150  for i=0 to 6:for j=0 to 5:c(i,j)=0:p(i,j)=0:next j:for j=6 to 11:c(i,j)=0:next j:next i
1160  for i=0 to 23:od(i)=0:next i
1170  for i=0 to 4:f(i)=0:next i
1180  for i=0 to 8:x(i)=i*69:y(i)=(i*8)-2:next i
1190  for i=9 to 12:y(i)=(i*8)-2:next i
1200  y1=-2:y2=45:y3=92:y4=139:y(13)=0:money=money-52
1220  in=0:for i=1 to 4:for j=1 to 13:d(in)=100*i+j:in=in+1:next j:next i
1230  randomize -1:for i=51 to 0 step -1:x=int(rnd(1)*i)+1:t=d(x):d(x)=d(i):d(i)=t:next i
1240  in=0:for i=1 to 6:for j=0 to i-1:p(i+2,j)=d(in):in=in+1:next j:next i
1250  for i=0 to 6:c(i+2,0)=d(in):in=in+1:left(i+2)=i:next i
1260  graphic 1
1290  scnclr:gosub 27000:gosub 30000
1300  for i=2 to 8:in(i)=1:next i:in(0)=0
1310  gosub 100
1320  cu=0:oc=0:x=x(cu):hf=0:fdation=0
1330  if hf=1 then ask mouse xpos%,ypos%,b%:gosub 25000
1335  ask mouse xpos%,ypos%,b%:if b%<>4 then 1330
1336  if xpos%<0 or ypos%<0 or xpos%>617 or ypos%>186 then 1330
1337  cu=int(xpos%/69):if cu=1 then 1330
1338  if xpos%>137 and xpos%<192 and ypos%>168 and ypos%<185 then 1420
1340  if hf=1 then what=5:goto 1400
1350  if cu=0 and ypos%>139 then what=3:goto 1400
1352  if cu<>0 then 1360
1353  if ypos%>(in(cu)*4) and ypos%<(in(cu)*4)+44 then what=2:goto 1400
1355  if ypos%<(in(cu)*4) or ypos%>(in(cu)*4)+44 then what=4:goto 1400
1357  goto 1330
1360  if ypos%>y(in(cu))+y(left(cu))+2 and ypos%<(y(in(cu))+y(left(cu))+2)+44 then what=2:goto 1400
1370  if ypos%<y(in(cu))+y(left(cu))+2 or ypos%>(y(in(cu))+y(left(cu))+2)+44 then what=4:goto 1400
1390  goto 1330
1400  if what=3 then gosub 100:goto 1330
1402  if what=4 then gosub 280:gosub 27000:goto 1330
1403  if what=5 then gosub 410:goto 1330
1404  if what=2 then gosub 930:if fdation=1 then 1620 else what=4:goto 1400
1410  goto 1330
1420  sshape(138,168;618,187),tempbox%():gshape(138,168),box%()
1425  a$="Do you want to end this hand?  (Y or N)":long=len(a$):long=int(long/2):pena 4:? at(377-(long*8),180);a$
1430  get a$:if a$="" then 1430
1432  if instr("Yy",a$)>=1 then 1440
1435  if instr("Nn",a$)>=1 then 1438
1436  goto 1430
1438  gshape(138,168),tempbox%():goto 1335
1440  gshape(138,168),box%():a$="Play another Hand?  (Y or N)":long=len(a$):long=int(long/2):pena 4:? at(377-(long*8),180);a$
1442  get a$:if a$="" then 1442
1444  if instr("Yy",a$)>=1 then scnclr:goto 1150
1446  if instr("Nn",a$)>=1 then system
1448  goto 1442
1450  end
1460  gosub 150
1470  return
1480  a$="YOU'VE ALREADY PICKED UP A CARD":GOSUB 16000:GOTO 1610
1490  a$="THERE ARE NO MORE CARDS IN THE DECK!":GOSUB 16000:GOTO 1610
1510  a$="THERE ARE NO CARDS HERE TO PICK UP":gosub 16000:goto 1610
1520  a$="YOU DO NOT HAVE ANY CARDS TO DROP":gosub 16000:goto 1610
1530  a$="YOU CAN'T PLAY BLACK ON BLACK":gosub 16000:goto 1610
1540  a$="YOU CAN'T PLAY RED ON RED":gosub 16000:goto 1610
1550  a$="YOU CAN'T DROP A"+tx$(va)+" ON A"+tx$(tv):gosub 16000:goto 1610
1560  a$="YOU CAN'T DROP CARDS HERE":gosub 16000:goto 1610
1570  a$="YOU CAN ONLY DROP A KING HERE":gosub 16000:goto 1610
1580  a$="START YOUR FOUNDATION WITH AN ACE":gosub 16000:goto 1610
1590  data "N  ACE"," TWO"," THREE"," FOUR"," FIVE"," SIX"," SEVEN","N EIGHT"," NINE"," TEN"," JACK"," QUEEN"," KING"
1610  rem
1615  return
1620  if f(1)<13 or f(2)<13 or f(3)<13 or f(4)<13 then fdation=0:gosub 27000:goto 1330
1630  gosub 27000:sshape(138,168;618,187),tempbox%():gshape(138,168),box%()
1640  a$="***  YOU WIN !!  Care to play again? (Y/N)  ***":long=len(a$):long=int(long/2):pena 4:? at(377-(long*8),180);a$
1650  get a$:if a$="" then 1650
1655  if instr("Yy",a$)>0 then 1700
1660  if instr("Nn",a$)>0 then 1800
1670  goto 1650
1700  scnclr:goto 1150
1800  system
11000 return
13000 time=40000
13005 sleep(time)
13010 return
14000 time=90000:goto 13005
15000 time=70000:goto 13005
16000 long=len(a$):long=int(long/2)
16010 sshape(138,168;618,187),tempbox%()
16020 gshape(138,168),box%()
16030 pena 4:print at(377-(long*8),180);a$
16040 sleep(2*10^6)
16050 gshape(138,168),tempbox%()
16090 return
20000 bload "heart_dat",varptr(regsave%(0))
20010 ct=0:for i%=0 to 31
20020 rgb i%,regsave%(ct),regsave%(ct+1),regsave%(ct+2)
20030 ct=ct+3:next i%
20040 return
20100 bload "heart",varptr(heart%(0))
20110 bload "diamond",varptr(diamond%(0))
20120 bload "club",varptr(club%(0))
20130 bload "spade",varptr(spade%(0))
20140 bload "blank",varptr(blank%(0))
20150 bload "back",varptr(back%(0))
20160 bload "box",varptr(box%(0))
20170 bload "quit",varptr(quit%(0))
20190 return
25000 rem *** shadow box ***
25010 drawmode 2
25020 x2%=xpos%:y2%=ypos%
25030 box(x2%-30,y2%;x2%+30,y2%+44)
25040 ask mouse x%,y%,b%
25050 if b%<>0 then box(x2%-30,y2%;x2%+30,y2%+44):xpos%=x2%:ypos%=y2%:drawmode 0:return
25060 if x%=x2% and y%=y2% then 25040
25070 box(x2%-30,y2%;x2%+30,y2%+44)
25080 x2%=x%:y2%=y%
25090 box(x2%-30,y2%;x2%+30,y2%+44)
25095 goto 25040
25100 return:drawmode 2:box(oldxpos%,oldypos%;oldxpos%+43,oldypos%+59)
25110 drawmode 0:return
27000 drawmode 1:penb 0:pena 6:? at(8,136);"$";:? using "#####";money
27010 drawmode 0:return
28000 dim timbre%(255),timbre1%(255):k#=2*3.14159265#/256
28010 for i=0 to 255
28020 timbre%(i)=31*(sin(i*k#)+sin(2*i*k#)+sin(4*i*k#)+sin(4*i*k#))
28030 next i
28040 for i=0 to 255
28050 timbre1%(i)=-127+(rnd(1)*255)
28060 next i
28070 wave 256,timbre1%()
28080 audio 15,1
28090 return
30000 gshape(0,139),back%():peno 5:box(69,0;69+59,0+44),0:box(69,47;69+59,47+44),0:box(69,94;69+59,94+44),0:box(69,141;69+59,141+44),0
30005 xx%=x(2):yy%=y(0)+2:gosub 32000
30010 let num=c(2,0):gosub 70:x=x(2):y=y(0):gosub 20
30020 for i=1 to 6:for j=0 to i-1
30030 xx%=x(i+2):yy%=y(j)+2:gosub 32000
30040 x=x(i+2):y=y(j):gshape(x,y),back%()
30050 next j
30060 xx%=x(i+2):yy%=y(j)+2:gosub 32000
30070 let num=c(i+2,0):gosub 70:x=x(i+2):y=y(j):gosub 20
30080 next i
30090 gshape(137,168),quit%():return
32000 peno 4:drawmode 2:ystep=139-yy%:xstep=xx%/10
32010 ystep=int(ystep/xstep)+2:y=139
32020 for x=5 to xx% step 20:y=y-ystep
32030 box(x,y;x+59,y+43),0
32050 box(x,y;x+59,y+43),0
32060 next x
32090 drawmode 0:return
