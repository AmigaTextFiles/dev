10    'MiniPaint program by Henry Birdseye
20    'As of 10/12/85 at 11:44
30    'click color menu once to activate menu,
40    ' then again over color to select
50    ' or over "quit." to quit.
60    ' once points are selected, mouse to
70    ' far upper left corner to finish figure.
80    ' feel free to change this program.
90    ' call The Unknown TBBS for Amiga uploads
100   ' at (303) 988-8155.
1000  dim fig%(1000)
1010  gosub 1470
1020  scnclr
1030  gosub 1340
1040  gosub 5000
1060  gosub 1290
1070  pena col%
1080  i%=0
1090  gosub 1210
1100  if (x%<5) and (y%<5) then goto 1160
1110  fig%(i%)=x%:fig%(i%+1)=y%
1120  gosub 1320
1130  i%=i%+2
1140  goto 1090
1150  '
1160  '
1170  fig%(i%)=fig%(0):fig%(i%+1)=fig%(1)
1180  i%=(i%/2)+1
1190  mat area i%,fig%()
1200  goto 1030
1210  ask mouse x%,y%,b%
1220  if b%=0 then goto 1210
1230  sleep 500000
1240  return
1250  window #1,0,0,150,300
1260  cmd 1
1270  print"click mouse in here,":print"then choose a color."
1280  return
1290  close #1
1300  cmd 0
1310  return
1320  if i%=0 then draw(fig%(i%),fig%(i%+1)) else draw(to fig%(i%),fig%(i%+1))
1330  return
1340  window #1,0,0,175,300
1350  cmd 1
1360  print"click mouse, then"
1370  print"choose colors."
1380  for j%= 0 to 15
1390  pena j%
1400  for k%= 0 to 3
1410  sq%(k%*2+1)= int(k%/2)*9 + j%*10 + 16
1420  next k%
1430  mat area 4,sq%()
1440  next j%
1450  print at (1,23); "quit.";
1460  return
1470  'initialize boxes
1480  for i%=0 to 7
1490  read sq%(i%)
1500  next i%
1510  return
1520  data 0,20,100,20,100,25,0,25
5000  gosub 1210
5010  if y%>176 then gosub 1290:stop
5020  if y%<16  then goto 5000
5030  col% = ((y%-10)/10) - 1
5035  if col% < 0 then col% = 0
5040  return
