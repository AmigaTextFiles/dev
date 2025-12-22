5     screen 0,5
6     n% = 60
10    for i% = 0 to n%\4
20    pena (i% mod 28)+3
25    j% = i%*2
30    box(j%,j%;n%-j%,n%-j%),1
40    next
50    dim a%(1000)
60    sshape(0,0;n%,n%),a%()
70    for i% = 0 to 4
80    for j% = 0 to 2
90    gshape(i%*n%,j%*n%),a%()
100   next : next
190   ask rgb 3, r%,g%,b%
200   for i% = 31 to 3 step -1
210   ask rgb i%, r1%,g1%,b1%
220   rgb i% ,r%,g%,b%
230   r%=r1% : b% = b1% : g% = g1%
240   next
250   goto 190
