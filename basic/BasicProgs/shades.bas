10    ask mouse x%,y%,b%
20    if b%=0 then goto 10
30    rgb 0, (x%*32)/640, 0, (y%*32)/200
40    goto 10
