4     scnclr
5     pena 2
6     peno 1
10    ask mouse x%, y%, b%
15    if b% = 0 goto 10
20    box(x%-5,y%-5;x%+5,y%+5),1
30    goto 10
