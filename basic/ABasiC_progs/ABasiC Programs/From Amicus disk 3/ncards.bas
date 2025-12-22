5     t=0
10    dv=570:dim card%(dv),sm%(18),sms%(4,18),lg%(23),lgs%(4,22)
45    peno 15
46    outline 1
47    drawmode 0
50    pena 2:box(50,50;110,120),1
51    pena 0:draw(50,50):draw(110,50):draw(50,120):draw(110,120)
53    sshape(50,50;111,121),card%
55    for x= 0 to 1:read pat%(x):next
60    pattern 2, pat%()
70    data &b1111000011110000,&b0000111100001111
75    gshape(100,100),card%
76    pena 4:box(105,105;155,165)
77    peno 1:circle(130,135),22,.5:circle(130,135),15,1.5:rem draw(116,126 to 144,145)
78    pena 1:penb 4:paint(110,110),1
80    dim card53%(570)
85    sshape(100,100;161,171),card53%
90    pattern 0,off%
91    drawmode 1
105   rgb 0,15,15,15
106   outline 0
107   scnclr
110   pena 2:draw(50,50):pena 4
115   gosub 900
120   rem draw small heart
121   draw(52,50 to 53,50):draw(55,50 to 56,50)
122   draw(51,51 to 57,51)
123   draw(51,52 to 57,52)
124   draw(51,53 to 57,53)
125   draw(52,54 to 56,54)
126   draw(53,55 to 55,55)
127   draw(54,56)
129   sshape(50,50;58,57),sm%
130   for x=0 to 18:sms%(1,x)=sm%(x):next
131   gosub 900
132   draw(52,50 to 53,50):draw(57,50 to 58,50)
133   draw(to 59,51 to 60,52 to 60,54 to 55,59)
134   draw(to 50,54 to 50,52 to 51,51 to 52,50 to 53,50 to 54,51 )
135   draw(to 55,52 to 56,51 to 57,50)
136   paint (55,55),1
138   sshape (50,50;61,60),lg%
140   for x= 0 to 22:lgs%(1,x)=lg%(x):next
200   rem draw clubs
210   gosub 900:pena 1
220   draw(53,50 to 54,50)
221   draw(53,51 to 54,51)
222   draw(51,52 to 52,52)
223   draw(55,52 to 56,52)
224   draw(51,53 to 52,53)
225   draw(55,53 to 56,53)
226   draw(53,54 to 54,54)
227   draw(53,55 to 54,55)
228   draw(52,56 to 55,56)
230   sshape (50,50;57,57),sm%
235   for x=0 to 18:sms%(2,x)=sm%(x):next
240   gosub 900:pena 1
241   draw (55,50 to 55,59)
242   draw(50,54 to 60,54)
243   draw(53,59 to 58,59)
244   draw(54,51 to 56,51)
245   draw(54,52 to 56,52)
246   draw(51,53 to 59,53)
247   draw(51,55 to 52,55)
248   draw(58,53 to 59,53)
249   draw(58,55 to 59,55)
250   draw(54,56 to 56,56)
251   draw(54,57 to 56,57)
252   draw(54,58 to 56,58)
256   sshape(50,50;61,60),lg%
257   for x%= 0 to 22:lgs%(2,x%)=lg%(x%):next
300   rem diamonds
310   gosub 900:pena 4
320   draw(54,50 to 57,53 to 54,56 to 51,53 to 54,50)
321   pena 4:paint (54,55) ,1
326   sshape(50, 50;58,57),sm%
327   for x=0 to 18:sms%(3,x)= sm%(x):next
330   gosub 900:pena 4
331   draw(55,50 to 60,55 to 55,60 to 50,55 to 55,50)
332   paint(55,55),1
334   sshape(50,50;61,61),lg%
335   for x=0 to 22:lgs%(3,x)= lg%(x):next
400   rem spades
410   gosub 900:pena 1
420   draw(54,50)
421   draw(53,51 to 55,51)
422   draw(52,52 to 56,52)
423   draw(51,53 to 57,53)
424   draw(51,54 to 57,54)
425   draw(53,55 to 55,55)
426   draw(52,56 to 56,56)
427   sshape(50,50;58,57),sm%
428   for x=0 to 18:sms%(4,x)=sm%(x):next
430   gosub 900:pena 1
431   draw(55,50 to 60,55 to 60,56 to 59,57 to 51,57 to 50,56 to 50,55 to 55,50)
432   draw(54,58 to 56,58)
433   draw(52,59 to 58,59)
434   paint(55,55),1
436   sshape (50,50;61,60),lg%
437   for x=0 to 22:lgs%(4,x)=lg%(x):next
888   t=0
899   goto 1000
900   pena 2:box(25,25;100,100),1:pena 4:return
1000  rem ***** draw cards *****
1005  gosub 8000
1010  scnclr
1015  x=100:y=100
1020  gshape(x,y),card%
1025  graphic 1
1030  penb 2
1035  pena r
1039  rem *** aces ***
1040  ? at (x+2,y+9);"A"
1050  gshape(x+1,y+11),sm%
1051  a=2:d=2
1055  b=10:e=18
1060  gosub 9000
1065  gshape(x+25,y+32),lg%
1070  if t= 0 then dim card1%(570):sshape(100,100;161,171),card1%
1072  if t=1 then dim card14%(570):sshape(100,100;161,171),card14%
1073  if t=2 then dim card27%(570):sshape(100,100;161,171),card27%
1074  if t=3 then dim card40%(570):sshape(100,100;161,171),card40%
1080  gshape(x,y),card%
1085  pena r:?at(x+2,y+9);"2"
1090  gosub 9010
1095  gshape(x+25,y+10),lg%
1096  a=2:b=8
1097  d=2:e=17
1098  gosub 9000
1099  a=20:d=10
1100  b=35:e=20
1105  gosub 9000
1110  if t=0 then dim card2%(570):sshape(100,100;161,171),card2%
1111  if t=1 then dim card15%(570):sshape(100,100;161,171),card15%
1112  if t=2 then dim card28%(570):sshape(100,100;161,171),card28%
1113  if t=3 then dim card41%(570):sshape(100,100;161,171),card41%
1120  rem three on two
1125  pena r:?at(x+2,y+9);"3"
1130  gosub 9050
1135  gshape(x+25,y+31),lg%
1140  if t=0 then dim card3%(570):sshape(100,100;161,171),card3%
1141  if t=1 then dim card16%(570):sshape(100,100;161,171),card16%
1142  if t=2 then dim card29%(570):sshape(100,100;161,171),card29%
1143  if t=3 then dim card42%(570):sshape(100,100;161,171),card42%
1150  rem  four
1155  gosub 9020
1160  pena r:?at(x+2,y+9);"4"
1165  gosub 9010
1170  gshape(x+15,y+10),lg%
1175  gshape(x+35,y+10),lg%
1176  a=2:b=8:d=2:e=20:gosub 9000
1177  a=15:b=25:d=10:e=20:gosub 9000
1178  a=35:b=45:gosub 9000
1185  if t=0 then dim card4%(570):sshape(100,100;161,171),card4%
1186  if t=1 then dim card17%(570):sshape(100,100;161,171),card17%
1187  if t=2 then dim card30%(570):sshape(100,100;161,171),card30%
1188  if t=3 then dim card43%(570):sshape(100,100;161,171),card43%
1195  rem five on four
1200  pena r:?at(x+2,y+9);"5"
1205  gosub 9050
1210  gshape(x+25,y+32),lg%
1215  if t=0 then dim card5%(570):sshape(100,100;161,171),card5%
1216  if t=1 then dim card18%(570):sshape(100,100;161,171),card18%
1217  if t=2 then dim card31%(570):sshape(100,100;161,171),card31%
1218  if t=3 then dim card44%(570):sshape(100,100;161,171),card44%
1225  rem six on five
1230  pena r:?at(x+2,y+9);"6"
1235  outline 0:pena 2:box(x+25,y+32;x+35,y+42),1
1240  outline 1:gosub 9050
1245  gshape(x+15,y+32),lg%
1250  gshape(x+35,y+32),lg%
1255  if t=0 then dim card6%(570):sshape(100,100;161,171),card6%
1256  if t=1 then dim card19%(570):sshape(100,100;161,171),card19%
1257  if t=2 then dim card32%(570):sshape(100,100;161,171),card32%
1258  if t=3 then dim card45%(570):sshape(100,100;161,171),card45%
1265  rem seven on six
1270  pena r:?at(x+2,y+9);"7"
1275  gosub 9050
1280  gshape(x+25,y+20),lg%
1285  if t=0 then dim card7%(570):sshape(100,100;161,171),card7%
1286  if t=1 then dim card20%(570):sshape(100,100;161,171),card20%
1287  if t=2 then dim card33%(570):sshape(100,100;161,171),card33%
1288  if t=3 then dim card46%(570):sshape(100,100;161,171),card46%
1295  rem eight
1300  gosub 9020
1305  pena r:?at(x+2,y+9);"8"
1310  gosub 9010
1315  gshape(x+15,y+10),lg%
1320  gshape(x+35,y+10),lg%
1325  gshape(x+15,y+24),lg%
1330  gshape(x+35,y+24),lg%
1331  a=2:b=8:d=2:e=20
1332  gosub 9000
1333  a=15:b=25:d=10:e=34
1334  gosub 9000
1335  a=35:b=45
1336  gosub 9000
1340  if t=0 then dim card8%(570):sshape(100,100;161,171),card8%
1341  if t=1 then dim card21%(570):sshape(100,100;161,171),card21%
1342  if t=2 then dim card34%(570):sshape(100,100;161,171),card34%
1343  if t=3 then dim card47%(570):sshape(100,100;161,171),card47%
1350  rem nine on eight
1355  pena r:?at(x+2,y+9);"9"
1360  gosub 9050
1365  gshape(x+25,y+16),lg%
1370  if t=0 then dim card9%(570):sshape(100,100;161,171),card9%
1371  if t=1 then dim card22%(570):sshape(100,100;161,171),card22%
1372  if t=2 then dim card35%(570):sshape(100,100;161,171),card35%
1373  if t=3 then dim card48%(570):sshape(100,100;161,171),card48%
1380  rem ten on nine
1385  pena r:?at(x+1,y+9);"10"
1386  a=2:b=15
1387  d=2:e=10
1388  gosub 9000
1389  a=25:b=35
1390  d=15:e=30
1391  gosub 9000
1395  if t=0 then dim card10%(570):sshape(100,100;161,171),card10%
1396  if t=1 then dim card23%(570):sshape(100,100;161,171),card23%
1397  if t=2 then dim card36%(570):sshape(100,100;161,171),card36%
1398  if t=3 then dim card49%(570):sshape(100,100;161,171),card49%
1400  '
1405  rem jack
1410  gosub 9020
1415  pena r:?at(x+1,y+9);"J"
1420  gosub 9010
1425  pena 1:draw(x+10,y+35 to x+10,y+10 to x+50,y+10 to x+50,y+35)
1426  gshape(x+14,y+14),lg%
1427  a=2:b=8:d=2:e=20:gosub 9000
1428  a=9:b=11:d=9:e=35:gosub 9000
1429  a=12:b=24:e=25:gosub 9000
1430  a=24:b=50:d=10:e=11:gosub 9000
1431  a=50:b=51:e=35:gosub 9000
1435  if t=0 then dim card11%(570):sshape(100,100;161,171),card11%
1436  if t=1 then dim card24%(570):sshape(100,100;161,171),card24%
1437  if t=2 then dim card37%(570):sshape(100,100;161,171),card37%
1438  if t=3 then dim card50%(570):sshape(100,100;161,171),card50%
1445  rem queen
1450  pena r:?at(x+2,y+9);"Q"
1455  gosub 9050
1461  if t=0 then dim card12%(570):sshape(100,100;161,171),card12%
1462  if t=1 then dim card25%(570):sshape(100,100;161,171),card25%
1463  if t=2 then dim card38%(570):sshape(100,100;161,171),card38%
1464  if t=3 then dim card51%(570):sshape(100,100;161,171),card51%
1470  rem king
1475  pena r:?at(x+2,y+9);"K"
1480  gosub 9050
1485  if t=0 then dim card13%(570):sshape(100,100;161,171),card13%
1486  if t=1 then dim card26%(570):sshape(100,100;161,171),card26%
1487  if t=2 then dim card39%(570):sshape(100,100;161,171),card39%
1488  if t=3 then dim card52%(570):sshape(100,100;161,171),card52%
1495  t=t+1
1496  if t>3 then 1498
1497  goto 1000
1498  chain "dice1",0,all
7000  rem
7005  scnclr
7010  x=00:y=50
7015  gshape(x,y),card1%
7020  x=x+20
7030  gosub 8500
7040  gshape(x,y),card2%
7050  x=x+20
7060  gosub 8500
7070  gshape(x,y),card3%
7080  x=x+20
7090  gosub 8500
7100  gshape(x,y),card4%
7110  x=x+20
7120  gosub 8500
7130  gshape(x,y),card5%
7140  x=x+20
7150  gosub 8500
7160  gshape(x,y),card6%
7170  x=x+20
7180  gosub 8500
7190  gshape(x,y),card7%
7200  x=x+20
7210  gosub 8500
7220  gshape(x,y),card8%
7230  x=x+20
7240  gosub 8500
7250  gshape(x,y),card9%
7260  x=x+20
7270  gosub 8500
7280  gshape(x,y),card10%
7290  x=x+20
7300  gosub 8500
7310  gshape(x,y),card11%
7320  x=x+20
7330  gosub 8500
7340  gshape(x,y),card12%
7350  x=x+20
7360  gosub 8500
7370  gshape(x,y),card13%
8000  rem
8001  if t=0 then 8010
8002  if t=1 then 8020
8003  if t=2 then 8030
8004  if t=3 then 8040 
8005  if t>3 then end
8010  for x=0 to 18:sm%(x)=sms%(1,x):next
8011  for x=0 to 22:lg%(x)=lgs%(1,x):next
8012  r=4:rem pen color
8015  goto 1010
8020  for x=0 to 18:sm%(x)=sms%(2,x):next
8021  for x=0 to 22:lg%(x)=lgs%(2,x):next
8022  r=1
8025  goto 1010
8030  for x=0 to 18:sm%(x)=sms%(3,X):next
8031  for x=0 to 22:lg%(x)=lgs%(3,x):next
8032  r=4
8035  goto 1010
8040  for x=0 to 18:sm%(x)=sms%(4,x):next
8041  for x=0 to 22:lg%(x)=lgs%(4,x):next
8042  r=1
8045  goto 1010
8500  for t= 1 to 2000:next:return
8999  stop
9000  rem *** routine for copy left top to right bottom
9001  for ac= a to b: rem across
9002  for dn= d to e: rem down
9003  n= pixel (x+ac,y+dn):pena n
9004  draw(x+60-ac,y+70-dn)
9005  next dn:next ac
9006  return
9010  gshape(x+1,y+11),sm%:return: rem small shape to top left
9020  rem ** print blank card **
9021  gshape(x,y),card%:return
9022  rem
9050  rem routine for number top to bottom only
9051  for a= 0 to 10
9052  for d= 0 to 10
9053  n= pixel (x+a,y+d):pena n
9054  draw(x+60-a,y+70-d)
9055  next d:next a
9056  return
9057  rem
10000 rem
10010 get a$
10020 if a$= "q" then return
10030 if a$="c" then input "color";n:pena n:goto 10020
