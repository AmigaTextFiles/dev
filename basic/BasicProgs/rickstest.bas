10    screen 1,4,0
11    pena 4
20    scnclr : goto 1000
100   ask mouse x%,y%,b%:? at (0,0);x%;y%;
101   if b%=0 then 100
102   RETURN
1000  gosub 100
1010  x1%=x%:y1%=y%
1020  gosub 100
1030  x2%=x%:y2%=y%
1050  box(y1%,x1%;y2%,x2%) ,1
1060  gosub 100
1070  scnclr
1080  goto 1000
2000  BOX(50,50;100,100) ,1
