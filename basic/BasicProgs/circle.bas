5     scnclr
10    for i% = 0 to 90
20    peno (i% mod 12) + 3
25    j% = i%*2
30    circle (160,95),i%
40    next
190   ask rgb 3, r%,g%,b%
200   for i% = 15 to 3 step -1
210   ask rgb i%, r1%,g1%,b1%
220   rgb i% ,r%,g%,b%
230   r%=r1% : b% = b1% : g% = g1%
240   next
250   goto 190
