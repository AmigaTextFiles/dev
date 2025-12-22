100   REM - Oriental Game of Gomoko - Version 1.0 - ABasiC
200   REM - By Gary D. Walborn
300   REM - November 2, 1985
400   REM - You may freely use and distribute this program without profit.
500   REM - Please do not remove these heading lines
1000  screen 1,3
1010  player%=1:computer%=2:empty%=0
1020  dim a%(10,10)
1030  size%=10:zero%=0:one%=1
1100  for r=0 to 8:read reg%(r):next r
1200  window 2,10,10,500,80,"Instructions"
1300  cmd #2
1400  print "    This game is played on a 10 x 10 grid.  During the"
1500  print "play, you may cover one grid intersection with a marker"
1600  print "The object of the game is to place 5 markers in a row --"
1700  print "5 adjacent markers in a row -- horizontally, vertically, "
1800  print "horizontally, vertically, or along either diagonal."
1850  print "Place the cursor and click the mouse to move."
1900  print "If I prevent you from placing 5 markers in a row, I win!"
2000  cmd #0
2100  a$="Read the instruction. Then press enter":gosub 11500
2200  input a$
2300  gosub 6800:gosub 7200
2600  for i%=one% to size%:for j%=one% to size%:a%(i%,j%)=empty%:next j%:next i%
2700  a$="We alter nate moves. You go first!":gosub 11500
2800  a$="Your move":gosub 11500
2900  gosub 10700
3000  if i%=-1 then 6500
3100  x%=i%:y%=j%:gosub 5600:if l%=player% then 3400
3200  a$="That is not a leegal move. Try again!":gosub 11500
3300  goto 2800
3400  if a%(i%,j%)=empty% then 3700
3500  a$="That square is occupied. Try again!":gosub 11500
3600  goto 2900
3700  a%(i%,j%)=player%:gosub 9600
3800  p%=player%:gosub 11900:if win%=one% then 6200
3900  Rem *** Computer tries intelligent move ***
4000  For e%=-1 to 1:for f%=-1 to 1: if e%+f%-e%*f%=0 then 4400
4100  x%=i%+e%:y%=j%+f%:gosub 5600
4200  if l%=empty% then 4400
4300  if a%(x%,y%)=player% then 5200
4400  next f%:next e%
4500  Rem ***Computer tries random move***
4600  x%=int(size%*rnd(1))+1:y%=int(size%*rnd(1))+1:gosub 5600:if l%=0 then 4600
4700  if a%(x%,y%)<>empty% then 4600
4800  a%(x%,y%)=computer%:i%=x%:j%=y%:gosub 9600
4900  p%=computer%:gosub 11900:if win%=one% then 6400
5000  gosub 15700:if win%=one% then 6400
5100  goto 2800
5200  x%=i%-e%:y%=j%-f%:gosub 5600
5300  if l%=zero% then 4600
5400  goto 4700
5500  Rem See if move is legal
5600  l%=one%:if x%<player% then 6100
5700  if x%>size% then 6100
5800  if y%<one% then 6100
5900  if y%>size% then 6100
6000  return
6100  l%=zero%:return
6200  a$="You win! That was a nice move!":gosub 11500
6300  goto 6500
6400  a$="I win! Better luck next time!":gosub 11500
6500  a$="Thank you for the game!":gosub 11500
6600  a$="Please click the mouse to continue.":gosub 11500
6650  gosub 10700
6700  close 1:close 2:end
6800  window 1,10,10,400,150,"Gomoko by Gary D. Walborn"
6900  cmd #1:ask window savew%,saveh%
7000  cmd #0
7100  return
7200  cmd #1:a$="Just a moment.":gosub 11500
7300  ask window width%,height%
7400  savew%=width%:saveh%=height%
7500  pena 2
7600  box (0,0;width%,height%),1
7700  pena 5
7800  dx=width%/12
7900  dy=height%/12
8000  for x=dx+dx/2 to 11*dx step dx
8100  draw (x,0 to x,height%)
8200  next x
8300  for y=dy+dy/2 to 11*dy step dy
8400  draw (0,y to width%,y)
8500  next y
8600  for i%=one% to size%:for j%=one% to size%
8700  tx%=i%*dx+dx/2:ty%=j%*dy+dy/2
8800  peno 1
8900  if a%(i%,j%)<>empty% then circle (tx%,ty%),dx/8
9000  if a%(i%,j%)=player% then pena 0
9100  if a%(i%,j%)=computer% then pena 3
9200  if a%(i%,j%)<>empty% then paint (tx%,ty%)
9300  next j%:next i%
9400  cmd #0
9500  return
9600  cmd #1
9700  ask window width%,height%
9800  if height%<>saveh% or width%<>savew% goto 7200
9900  tx%=i%*dx+dx/2:ty%=j%*dy+dy/2
10000 peno 1
10100 circle (tx%,ty%),dx/8
10200 if a%(i%,j%)=player% then pena 0
10300 if a%(i%,j%)=computer% then pena 3
10400 paint (tx%,ty%)
10500 cmd #0
10600 return
10700 cmd #1:ask mouse mx%,my%,mb%
10800 ask window width%,height%
10900 if width%<>savew% or height%<>saveh% then gosub 7200
11000 if mb%=empty% then 10700
11100 if mx%>width% or my%>height% then 10700
11200 i%=int(mx%/dx):j%=int(my%/dy)
11300 cmd #0
11400 return
11500 b$=translate$(a$)
11600 b%=narrate(b$,reg%())
11700 return
11800 data 130,0,150,0,22200,64,10,1,0
11900 win%=0
12000 for ty%=1 to size%
12100 c%=empty%
12200 for tx%=1 to size%
12300 if a%(tx%,ty%)=p% then c%=c%+one% else c%=0
12400 if c%=5 then win%=one%
12500 next tx%:next ty%
12600 for tx%=one% to size%
12700 c%=zero%
12800 for ty%=one% to size%
12900 if a%(tx%,ty%)=p% then c%=c%+one% else c%=zero%
13000 if c%=5 then win%=one%
13100 next ty%:next tx%
13200 for tx%=1 to 5
13300 for ty%=1 to 5
13400 d%=size%-tx%
13500 maxd%=size%-ty%
13600 if d%<maxd% then maxd%=d%
13700 maxd%=maxd%-one%
13800 c%=zero%
13900 if a%(tx%,ty%)<>p% then 14400
14000 for d%=zero% to maxd%
14100 if a%(tx%+d%,ty%+d%)=p% then c%=c%+one% else c%=zero%
14200 if c%=5 then win%=one%
14300 next d%
14400 next ty%:next tx%
14500 for tx%=5 to 10
14600 for ty%=0 to 5
14700 if tx%<10-ty% then maxd%=tx% else maxd%=10-ty%
14800 maxd%=maxd%-one%
14900 c%=zero%
15000 if a%(tx%,ty%)<>p% then 15500
15100 for d%=zero% to maxd%
15200 if a%(tx%-d%,ty%+d%)=p% then c%=c%+one% else c%=zero%
15300 if c%=5 then win% = one%
15400 next d%
15500 next ty%:next tx%
15600 return
15700 win%=one%
15800 for tx%=one% to size%
15900 for ty%=one% to size%
16000 if a%(tx%,ty%)=empty% then win%=zero%
16100 next ty%:next tx%
16200 return
