10    goto 2041
1000  scnclr
1010  ask mouse h%,v%,b%
1020  if b%= 0 then 1010
1025  ? at (0,0) h%,v%;
1030  goto 1010
2000  scnclr
2001  pena 7
2005  for h%=0 to 650 step 10
2010  locate (h%,0)
2020  draw (to h%, 188)
2030  next h%
2040  rem ask mouse h%,v%,b% : if b%= 0 then 2040
2041  screen 0,5,0:pena 7:scnclr:box (10,10; 50,50),1
2042  circle (200,100),70: locate (200,100):paint (200,100),0
2050  for red%= 0 to 15
2051  for green%= 0 to 15
2052  for blue%=0 to 15
2055  rgb 7,red%,green%,blue%
2056  ? at (0,0) red%,green%,blue%;
2059  rem for timer%=0 to 1000: next timer%
2060  sleep 50000
2063  next blue%
2064  next green%
2065  next red%
