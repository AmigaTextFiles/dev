1     screen 1,2,0
2     width 40
5     print"DOG STAR ADVENTURE  by Lance Miklus"
6     print
9     print" Adapted for the PET by David Malmberg"
12    print "from APPLESEED - January 1980"
20    print
25    print "Ported to the AMIGA by
30    print
35    print "           Don White
36    print "           47 Ariel Court
37    print "           Nepean, Ontario
38    print "           K1A 0M2
39    print "           (613) 829-2082
40    print
45    print "           November 1985"
50    print:print "Press any key to continue"
52    getkey x$
55    scnclr
100   gosub 2820
105   dim a(10)
110   scnclr
115   input"Do you wish instructions";a$
120   if left$(a$,1)="y"then gosub 6000
130   scnclr
140   lc=2:sl=40:gf=50:tb=1
150   goto 2210
160   if tc<25 or int(rnd(1)*gf)<>1 then 260
170   if tc=300 then gf=20
180   if lc<3 or lc=9 or lc=26 or lc=36 or lc=37 then 260
190   if lc>26 and lc<31 then 260
200   print"Holy Smokes!!  An armed stormtrooper"
201   print"just walked in."
210   gosub 2550:if vb<>12 or no<>15 then 1370
220   x=13:gosub 2770:if y<>-1 then 1370
230   if bl=0 then print"I'm out of ammunition!":goto 1380
240   print"ZZZAP!!!  No more stormtrooper!"
250   bl=bl-1:if bl=0 then print"I'm out of ammunition!"
260   if md<>tc then 290
270   x=22:gosub 2770:if y<>-1 then 290
280   print:print"Your Big Mac is cold."
290   gosub 2550:tc=tc+1
300   if vb=0 and no=0 then 320
310   goto 340
320   print"I don't know how to do that.":goto 160
330   print"Nothing happened.":goto 160
340   if vb>1 or no>7 then 470
350   if no=0 then vb=0:goto 300
360   if ds(lc,no-1)=0 then print"I can't go that way.":goto 160
370   if dr=1 and ds(lc,no-1)>2 and ds(lc,no-1)<6 then 375
371   goto 380
375   print"I can't go that way.  the flight deck"
376   print"doors need to be closed....agh!!!..."
377   print"..no air!!!":goto 160
380   if no=3 and lc=31 and dj<>-1 then print m0$:goto 160
390   if lc=35 and ds(lc,no-1)=36 and ob(21,1)<>0 then 395
391   goto 400
395   print"the robot won't let me.":goto 160
400   if lc=17 and ob(13,1)=17 then 1370
410   if lc=9 and ob(5,1)=9 then 1370
420   if lc=9 or lc=17 then he$(lc)=""
430   lc=ds(lc,no-1)
440   if lc=34 then he$(lc)=""
450   if lc=26 then 2470
460   goto 2210
470   if vb=3 then 2210
480   if vb<>2 then 650
490   if no=0 then print"I don't know what a ";no$(0);" is.":goto 160
500   if cr>5 then print"I can't carry any more...too heavy!":goto 160
505   kk=0:i=0
510   i=i+1
512   if ob(i,0)=(no)then kk=i
514   if i<lo then 510
515   if kk=0 then 320
520   i=kk
530   if ob(i,1)=-1 then print"I'm already carrying it.":goto 160
540   if ob(i,1)<>lc then print"I don't see it.":goto 160
550   if no<>37 then 580
560   x=13:gosub 2770:if y<>-1 then print"I don't have a blaster to put it in.":goto 160
570   bl=4:ob(i,1)=0:print"My blaster's reloaded.":goto 160
580   if no=15 or no=25 or no=34 then print"He looks p-r-e-t-t-y mean to me.":goto 160
590   cr=cr+1:ob(i,1)=-1:print"ok."
600   if no=14 and cm<>1 then print"A voice says...SESAME!":cm=1
610   if no=22 and md=0 then md=tc+50
620   if no=12 then he$(2)=""
630   if no=13 then he$(7)=""
640   goto 160
650   if vb<>4 then 700
660   print:print"I'm carrying..."
670   k=0:for i=1 to lo:if ob(i,1)=-1 then print ob$(i):k=1
680   next i:if k=0 then print"nothing"
690   print:goto 160
700   if vb<>5 then 720
710   gosub 2730:goto 160
720   if vb<>6 then 810
730   if no=0 then 490
740   if lc=2 then print:print"There's no room here.":goto 160
750   ic=0:for i=1 to lo:if ob(i,1)=lc then ic=ic+1
760   next i:if ic>12 then print"There's not enough room...dump something.":goto 160
765   i=0
766   i=i+1
770   if ob(i,0)=(no)then 790
780   if i<lo then 766
785   goto 320
790   if ob(i,1)<>-1 then print"I'm not carrying it.":goto 160
800   cr=cr-1:ob(i,1)=lc:print"OK.":goto 160
810   if vb<>7 then 840
820   if he$(lc)=""then print"How am I supposed to know what to do?":goto 160
830   print:print he$(lc):goto 160
840   if vb<>8 then 1030
850   scnclr:input"Press 'c' to continue";k$:if left$(k$,1)<>"c"then 850
860   tl$="dog star data":open "o",#1,"dog star data"
870   a(1)=tb:a(2)=tc:a(3)=cm:a(4)=dr:a(5)=bl
875   a(6)=md:a(7)=gf:a(8)=dj:a(9)=cr:a(10)=lc
876   print#1,tl$
878   for i=0 to 10:print#1,a(i):next i
880   for i=0 to lo:for j=0 to 2:print#1,ob(i,j):next j:next i
890   close 1:print:print"game saved."
900   print"May the force be with you.":end
1030  if vb<>9 then 1190
1040  scnclr:input"Press 'c' to continue";k$:if left$(k$,1)<>"c"then 1040
1050  open "i",#1,"dog star data"
1060  input#1,tl$:print:print"reading ";tl$
1080  for i=0 to 10:input#1,a(i):print"*";:next i
1090  for i=0 to lo:for j=0 to 2:input#1,ob(i,j):next j:print"*";:next i
1100  close 1
1110  tb=a(1):tc=a(2):cm=a(3):dr=a(4):bl=a(5)
1120  md=a(6):gf=a(7):dj=a(8):cr=a(9):lc=a(10)
1130  goto 2210
1190  if vb<>10 then 1270
1200  input"do you want to save game ";k$:if left$(k$,1)="y"then 850
1210  print"May the force be with you.":end
1270  if vb<>11 then 1410
1280  if no<>10 then 320
1290  if lc<>2 and lc<>11 then print"What button?":goto 160
1300  if lc=11 and tb then tb=0:print n2$:goto 160
1310  if lc=11 and not tb then tb=1:print n3$:goto 160
1320  x=12:gosub 2770:if y<>1 then 330
1330  x=24:gosub 2770:if y<>1 then 330
1340  if tb=1 then print n3$:goto 330
1350  if dr=0 then print n4$:goto 330
1360  goto 2370
1370  scnclr:print"Help!!!"
1380  print"Vader's soldiers are everywhere."
1385  print"I've been captured."
1390  print"I'm a prisoner...woe is me..."
1400  goto 2430
1410  if vb<>12 or no=0 then 1520
1420  if bl=0 then print"But I don't have any ammunition left.":goto 160
1430  x=13:gosub 2770:if y<>-1 then print"But I don't have a blaster.":goto 160
1440  x=no:gosub 2770:if y=-1 then print"I can't...I'm holding it.":goto 160
1450  if no=34 then print"ZZZAP!":bl=bl-1:goto 160
1460  if y<>lc then print"I don't see it.":goto 160
1470  i=0
1471  i=i+1
1475  if ob(i,0)=(no)then 1490
1476  if i<lo then 1471
1480  goto 320
1490  ob(i,1)=0:print"ZZZAP!!!  the ";no$(no);" vaporized!"
1500  bl=bl-1:if bl=0 then print"I'm out of ammunition."
1510  goto 160
1520  if vb<>13 then 1600
1530  if no=0 then print"Say what?":goto 160
1540  x=14:gosub 2770
1550  if y<>-1 or no<>19 then print"OK...";no$(no):goto 160
1560  if dr=1 then 330
1570  dr=1:scnclr:print"A voice comes over the p.a..."
1575  print"   opening flight deck doors"
1580  if lc>2 and lc<6 then print:print"...yips!!! There's no air!!!...croak...":end
1590  goto 160
1600  if vb<>14 then 1780
1610  if no<>20 and no<>16 and no<>11 and no<>33 then 330
1620  if no=20 then 1710
1630  if no<>16 then 1670
1640  if ob(6,1)=-1 then print"Sorry.  I'm not a cartographer.":goto 160
1650  if ob(6,1)=lc then print"Try...get map":goto 160
1660  print"it's not here.":goto 160
1670  x=no:gosub 2770:if y<>lc and y<>-1 then 1660
1680  if no=11 then print"it says needs turbo"
1690  if no=33 then print"it says out of order"
1700  goto 160
1710  if lc<>13 then print"I don't see any.":goto 160
1720  print:print"It says on the wall..."
1730  print"Your mother's got a big nose"
1740  print"Kilroy was here"
1750  print"For a good time call 6557"
1760  print"Say security"
1770  goto 160
1780  if vb<>15 then 1860
1790  if no=0 then print"What's a ";no$(no);"?":goto 160
1800  if no<>22 then print"Don't be ridiculous!":goto 160
1810  x=22:gosub 2770:if y<>-1 then print"I'm not holding it.":goto 160
1820  i=0
1821  i=i+1
1825  if ob(i,0)=22 then 1840
1826  if i<lo then 1821
1830  print"I don't know where it is.":goto 160
1840  ob(i,1)=0:print"CHOMP...CHOMP...hummm, good!"
1850  goto 160
1860  if vb<>16 or no<>23 or lc<>16 then 1900
1870  x=23:gosub 2770:if y<>-1 then print:print m1$:goto 160
1880  ob(11,1)=0:ob(14,1)=16:cr=cr-1:print:print m2$
1890  goto 160
1900  if vb<>18 then 1940
1902  if no=19 then 1560
1905  if no<>36 then 1940
1910  if no<>36 or lc<>31 then 320
1920  x=17:gosub 2770:if y<>-1 then print m3$:goto 160
1930  he$(31)="":dj=-1:print:print m4$:goto 160
1940  if vb<>19 or no=0 then 2070
1950  if no<>34 then print"That's stupid!":goto 160
1960  if lc<>35 then print:print m5$:goto 160
1970  x=22:gosub 2770:if y<>-1 then print:print m6$:goto 160
1980  if no=35 then print m7$:goto 160
1990  if no<>34 then print no$(0);m8$:goto 160
2000  if tc>md then print m9$:goto 160
2010  i=0
2011  i=i+1
2012  if ob(i,0)=34 then k=i:goto 2030
2015  if i<lo then 2011
2020  goto 320
2030  i=0
2031  i=i+1
2032  if ob(i,0)=22 then 2050
2035  if i<lo then 2031
2040  goto 320
2050  print n0$:he$(35)=""
2060  ob(k,1)=0:ob(i,1)=0:goto 160
2070  if vb<>17 then 2090
2080  if vb<>20 then 2180
2090  if vb<>20 then 2180
2100  if no=0 then 320
2110  x=no:gosub 2770:if y=-1 then print"That's impossible...I'm carrying it.":goto 160
2120  if y=lc then 2150
2130  if no<11 or no=19 or no=20 or no=30 then 320
2140  print"I can't hit it if I can't see it!":goto 160
2150  if no=15 or no=25 or no=31 then print"I'd rather not...he might hit back!":goto 160
2160  if no=35 then print"That's not nice!!!":goto 160
2170  goto 330
2180  if vb<>21 then 2200
2190  print"I'm not strong enough to kill anything!":goto 160
2200  goto 320
2210  scnclr:print ds$(lc):a$=""
2220  if lc=35 then gf=10
2230  if lc=7 then 2300
2240  k=0:for i=1 to lo:if ob(i,1)<>lc then 2280
2250  if k=0 then k=1:print:print"Around me I see --- ":a$=ob$(i):goto 2280
2260  if len(a$)+5+len(ob$(i))>40 then print a$:a$=ob$(i):goto 2280
2270  a$=a$+"    "+ob$(i)
2280  next i
2290  if a$<>""then print a$
2300  print:print"Obvious directions are ";:k=0
2310  for i=0 to 5:if ds(lc,i)=0 then 2340
2320  if k<>0 then print",";
2330  print no$(i+1);:k=k+1
2335  if k=3 then print""
2340  next i
2350  if k=0 then print"Unknown";
2360  print".":goto 160
2370  print"CLEAR":gosub 2730
2380  if j<>0 then 2390
2381  print"We have failed in our mission.  The"
2382  print"forces of Princess Leia will be"
2383  print"conquered.":goto 2430
2390  if j<>sc then 2410
2391  print"We are heroes.  The forces of Princess"
2392  print"Leia will conquer the evil imperial"
2393  print"soldiers, and freedom will prevail"
2394  print"throughout the galaxy!":goto 2350
2410  print"We have helped the forces of Princess"
2411  print"Leia defend the galaxy.  Long live the"
2412  print"forces of freedom!"
2430  print:print"May the force be with you!"
2440  print:input"Do you want to play again ";a$
2450  if left$(a$,1)="y"then 110
2460  end
2470  scnclr:print"A voice calls out...who goes there?"
2480  gosub 2550
2490  if vb<>13 or no<>30 then 1370
2500  print n1$
2510  gosub 2550
2520  x=31:gosub 2770:if y<>-1 then 1370
2530  if vb<>17 or no<>31 then 1370
2540  goto 2210
2550  z9=fre(0):print:print"What should I do";:input cm$
2560  if cm$="n"then cm$="north"
2570  if cm$="e"then cm$="east"
2580  if cm$="s"then cm$="south"
2590  if cm$="w"then cm$="west"
2600  if cm$="u"then cm$="up"
2610  if cm$="d"then cm$="down"
2620  vb$(0)="":no$(0)="":vb=0:no=0:if len(cm$)=0 then return
2630  for zl=1 to len(cm$)
2631  if mid$(cm$,zl,1)<>" "then vb$(0)=vb$(0)+mid$(cm$,zl,1):goto 2635
2632  zl=len(cm$)
2635  next zl
2640  for zl=1 to lv
2641  zz=4:yy=len(vb$(zl)):if yy<zz then zz=yy
2642  if vb$(zl)<>""and left$(vb$(0),zz)=left$(vb$(zl),zz)then vb=zl:zl=lv
2650  next zl
2660  if vb=0 then no$(0)=vb$(0):goto 2690
2670  if len(vb$(0))+1>len(cm$)then no=0:return
2680  no$(0)=right$(cm$,len(cm$)-1-len(vb$(0)))
2690  no=0:for zl=1 to ln
2691  zz=4:yy=len(no$(zl)):if yy<zz then zz=yy
2692  if no$(zl)<>""then if left$(no$(0),zz)=left$(no$(zl),zz)then no=zl:zl=ln
2700  next zl
2710  return
2730  j=0:for i=1 to lo:if ob(i,1)=1 then j=j+ob(i,2)
2740  next i:print"Out of a maximum of ";sc;"points"
2741  print"you have ";j;"points."
2750  if j=0 then print"You are not doing spectacularly well!"
2760  return
2770  zl=-1
2771  zl=zl+1
2772  if ob(zl,0)=x then y=ob(zl,1):return
2775  if zl<lo then 2771
2780  y=-99:return
2800  input a$:return
2820  sc=215:bt=0
2850  lv=21:dim vb$(lv)
2860  for i=1 to lv:read vb$(i):next i
2870  data go,get,look,inventory,score,drop,help,save,load,quit,push,shoot
2880  data say,read,eat,copy,show,open,feed,hit,kill
2920  ln=37:dim no$(ln)
2930  for i=1 to ln:read no$(i):next i
2940  data north,east,south,west,up,down,"","",""
2945  data button,tag,fuel,blaster,communicator
2950  data stormtrooper,map,keys,necklace,sesame,grafitti,cape,big mac,tape,turbo
2960  data scientist,plans,schematic,device,gun,security,i.d.,crystal,sign
2970  data robot,princess,door,ammunition
3060  cl=37:dim ds$(cl),ds(cl,5),he$(cl)
3070  for i=1 to cl
3090  for zl=0 to 5:read ds(i,zl):next zl
3100  next i
3110  ds$(1)="I'm in the passenger and storage area "
3111  ds$(1)=ds$(1)+"of the Millennium Falcon.  There's an"
3112  ds$(1)=ds$(1)+" exit here to leave the ship."
3115  data 2,0,0,0,0,3
3120  ds$(2)="I'm in the cockpit of the falcon.  A    "
3121  ds$(2)=ds$(2)+"large red button is labeled push to     "
3122  ds$(2)=ds$(2)+"blast off."
3125  data 0,0,1,0,0,0
3130  ds$(3)="I'm standing next to the Millennium     "
3131  ds$(3)=ds$(3)+"Falcon which is located on a huge deck."
3135  data 18,0,4,0,1,0
3140  ds$(4)="I'm out on the flight deck of Darth     "
3141  ds$(4)=ds$(4)+"Vader's battlecruiser."
3145  data 3,5,4,4,0,0
3150  ds$(5)=ds$(4)
3155  data 4,6,5,4,0,0
3160  ds$(6)="I'm in a hallway.  There are doors on   "
3161  ds$(6)=ds$(6)+"all sides.  The door to the north says: "
3162  ds$(6)=ds$(6)+"closed for the day"
3165  data 7,0,8,5,0,0
3170  ds$(7)="I'm in the supply depot.  Around me I   "
3171  ds$(7)=ds$(7)+"see all kinds of things."
3175  data 0,0,6,0,0,0
3180  ds$(8)="I'm at the end of one of the hallways.  "
3181  ds$(8)=ds$(8)+"I can hear voices nearby.  They sound   "
3182  ds$(8)=ds$(8)+"like stormtroopers."
3185  data 6,10,0,9,0,12
3190  ds$(9)="I'm in the strategic planning room."
3195  data 11,8,0,0,0,0
3200  ds$(10)="I'm in the decontamination room."
3205  data 0,14,0,8,0,0
3210  ds$(11)="This area is the tractor beam control   "
3211  ds$(11)=ds$(11)+"room. There is a sign on the bulkhead:  "
3212  ds$(11)=ds$(11)+"      Only Authorized Personnel         "
3213  ds$(11)=ds$(11)+"          may push buttons!           "
3215  data 0,0,9,0,0,0
3220  ds$(12)="I'm in another hallway.  To the east is "
3221  ds$(12)=ds$(12)+"a restroom."
3225  data 15,13,0,0,8,0
3230  ds$(13)="This is what is commonly called (on     "
3231  ds$(13)=ds$(13)+"earth), the bathroom. There's grafitti "
3232  ds$(13)=ds$(13)+"on the walls and pipes going up through "
3233  ds$(13)=ds$(13)+"the ceiling."
3235  data 15,0,0,12,27,0
3240  ds$(14)="This seems to be an interrogation room."
3245  data 0,0,0,10,0,0
3250  ds$(15)="I'm in the officers lounge."
3255  data 0,0,13,12,0,0
3260  ds$(16)="This is the computer center.  The crt   "
3261  ds$(16)=ds$(16)+"says: COPY TAPE"
3265  data 17,0,18,0,0,0
3270  ds$(17)="I'm in a testing laboratory."
3275  data 0,0,16,0,0,0
3280  ds$(18)="I'm in a hallway.  A large arrow points "
3281  ds$(18)=ds$(18)+"east and says: TO THE VAULT"
3285  data 16,25,3,19,0,0
3290  ds$(19)="This is the entrance to the development "
3291  ds$(19)=ds$(19)+"lab section."
3295  data 20,18,21,20,22,0
3300  ds$(20)="I'm in a long corridor.  There are labs "
3301  ds$(20)=ds$(20)+"all around me."
3305  data 19,23,21,20,22,24
3310  ds$(21)="I'm in a research lab."
3315  data 20,0,0,0,0,0
3320  ds$(22)="I'm lost!!!"
3325  data 22,22,22,22,22,20
3330  ds$(23)=ds$(21)
3335  data 0,0,0,0,20,0
3340  ds$(24)=ds$(21)
3345  data 0,0,0,20,0,0
3350  ds$(25)="I'm near the entrance to the vault.  A  "
3351  ds$(25)=ds$(25)+"sign says: AUTHORIZED PERSONNEL ONLY"
3355  data 0,26,0,18,0,0
3360  ds$(26)="I'm in the vault."
3365  data 0,0,0,25,0,0
3370  ds$(27)="I'm in a pipe tunnel that leads in all  "
3371  ds$(27)=ds$(27)+"directions."
3375  data 28,27,27,27,27,13
3380  ds$(28)=ds$(27)
3385  data 29,29,29,29,30,29
3390  ds$(29)="I'm lost in a maze of pipes."
3395  data 28,29,29,29,29,27
3400  ds$(30)="I'm in a maze of pipes.  Below me I     "
3401  ds$(30)=ds$(30)+"think I see the jail."
3405  data 29,29,28,29,29,31
3410  ds$(31)="I'm in the jail."
3415  data 32,33,34,35,0,0
3420  ds$(32)="I'm in a jail cell."
3425  data 0,0,31,0,0,0
3430  ds$(33)=ds$(32)
3435  data 0,0,0,31,0,0
3440  ds$(34)=ds$(32)
3445  data 31,0,0,0,0,0
3450  ds$(35)="I'm at the security desk.  To the north "
3451  ds$(35)=ds$(35)+"is an elevator."
3455  data 36,31,0,0,0,0
3460  ds$(36)="I'm in the elevator."
3465  data 0,0,35,0,37,0
3470  ds$(37)=ds$(36)
3475  data 0,0,14,0,0,36
3500  lo=23:dim ob$(lo),ob(lo,2)
3510  for i=1 to lo:read ob$(i):next i
3520  data"A tag which says: needs turbo","anti-matter fuel","blaster"
3530  data communicator,a very surprised stormtrooper,a map of the ship
3540  data some keys,a shinestone necklace,princess leia's cape,a big mac
3550  data a cassette tape,a turboencabulator,an evil looking scientist
3560  data secret attack plans,death ray schematic,cloaking device
3570  data micro laser gun,i.d. card,malidum crystals (the treasury)
3580  data"a sign which says: out of order",an attack robot,princess leia
3590  data ammunition
3600  for i=1 to lo:for zl=0 to 2:read ob(i,zl):next zl,i
3601  data 11,5,0
3602  data 12,5,5
3603  data 13,7,0
3604  data 14,9,0
3605  data 15,9,0
3606  data 16,29,20
3607  data 17,9,0
3608  data 18,10,20
3609  data 21,14,5
3610  data 22,15,0
3611  data 23,7,0
3612  data 24,17,5
3613  data 25,17,0
3614  data 26,0,20
3615  data 27,9,20
3616  data 28,17,20
3617  data 29,24,20
3618  data 31,17,0
3619  data 32,26,30
3620  data 33,3,0
3621  data 34,35,0
3622  data 35,34,50
3623  data 37,7,0
3900  he$(1)="We're suppose to leave the stuff here."
3910  he$(2)="I wonder if we have enough fuel."
3920  he$(7)="How about a blaster?"
3930  he$(9)="Try to shoot the stormtrooper."
3940  he$(13)="Read the grafitti."
3950  he$(17)="Try to shoot the scientist."
3960  he$(22)="I'm as confused as you are!":he$(29)=he$(22)
3970  he$(31)="It might help if we had some keys to    "
3971  he$(31)=he$(31)+"open any locked doors."
3980  he$(35)="Did you bring anything to eat?"
3990  m0$="Can't go in there.  The door is locked. "
4000  m1$="I'm not carrying any blank tape."
4010  m2$="The AMIGA recorded on the tape, then it   "
4011  m2$=m2$+"printed: ATTACK PLANS--VERY SECRET"
4020  m3$="I can't.  I'm not carrying any keys."
4030  m4$="OK...the door to the jail is unlocked."
4040  m5$="There's no robot here!"
4050  m6$="But I don't have any Big Macs."
4055  m7$="The Princess thanks you for a delicious"
4056  m7$=m7$+"meal."
4060  m8$="doesn't eat hamburger."
4070  m9$="Nothing happened.  The Big Mac is cold."
4090  n0$="The attack robot eats the Big Mac and   "
4091  n0$=n0$+"disappears."
4100  n1$="I'm at the identification terminal.  On "
4101  n1$=n1$+"the screen it says: SHOW I.D."
4110  n2$="The tractor beam is off."
4120  n3$="The tractor beam is on."
4130  n4$="You forgot to open the flight deck      "
4131  n4$=n4$+"doors."
4140  return
6000  print"You are the only hope of saving"
6010  print"Princess Leia and the freedom fighting"
6015  print"force."
6020  print:print"Her ship has been captured by Darth"
6030  print"Vader and she is being held prisoner on"
6040  print"his battlecruiser.  On board her ship"
6050  print"was the entire treasury of the freedom"
6060  print"fighting forces.  The Princess was also"
6070  print"wearing a necklace of shinestones, with"
6080  print"one stone encoded with the secret"
6090  print"strength and location of the freedom"
6100  print"forces."
6110  print:print"Darth Varder must not discover the"
6120  print"secret or else he will launch an attack"
6130  print"and peace will be lost to the galaxy"
6140  print"for eons to come."
6150  print:print"Press RETURN to continue."
6160  get a$:if a$=""then 6160
6170  scnclr:print"Disguised as a trading ship, you have"
6180  print"just landed on Darth Vader's ship. You"
6190  print"must rescue the Princess, her necklace,"
6200  print"and the treasury.  If you fail to get"
6210  print"the Princess, in the interest of peace"
6220  print"you must at least do everything you can"
6230  print"to foil Vader's plans."
6240  print:print"You must exercise extreme caution."
6250  print"Stormtroopers are everywhere on the "
6260  print"ship.  Only a single rescuer, moving"
6270  print"stealthily, has a chance.  The odds"
6280  print"against you are overwhelming--but for"
6290  print"the sake of the galaxy, you must try!"
6300  print:print"MAY THE FORCE BE WITH YOU."
6310  print"Press RETURN to continue."
6320  get a$:if a$=""then 6320
6330  scnclr:print"During this adventure AMIGA will be"
6340  print"your alter ego.  You take actions by"
6350  print"giving the AMIGA a series of ordinary"
6360  print"English commands of one or two words."
6370  print"examples are: go north, get sign, drop"
6380  print"necklace, eat big mac, etc.  Inventory"
6390  print"will call up a list of the items you"
6400  print"are carrying.  Help may result in a"
6410  print"helpful hint.  Look may reveal very"
6420  print"signficant details that will help you"
6430  print"to win.  Other words in the AMIGA's "
6440  print"lexicon are score, and quit."
6490  print:print"The AMIGA will accept various forms for"
6500  print"some commands.  For example:n, north,"
6510  print"and go north are equivalent.  The AMIGA"
6520  print"looks at only the first four letters of"
6530  print"each word, so inve will get the same"
6540  print"result as inventory."
6690  print:print"Press RETURN to continue."
6700  get a$:if left$(a$,1)=""then 6700
6750  scnclr:print"Save will cause the current game"
6760  print"status to be saved on disk.  Load will"
6770  print"enable you to resume a previously saved"
6780  print"game."
6790  print:print"Remember, everything you encounter in"
6800  print"your Dog Star Adventure has a purpose."
6810  print"there are clues everywhere, but it will"
6820  print"take imagination, perseverance and luck"
6830  print"to rescue the Princess and save the"
6840  print"galaxy."
6900  print:print"Press RETURN to begin."
6910  get a$:if left$(a$,1)=""then 6910
6920  return
