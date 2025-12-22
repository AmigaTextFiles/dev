10    scnclr
20    dim loz%(12)
30    for i=0 to 11: read loz%(i):next
40    restore
50    ask mouse x%, y%, b%
60    if b% = 0 goto 50
70    for i%=0 to 10 step 2: loz%(i%)=loz%(i%)+x%: next
80    for i%=1 to 11 step 2: loz%(i%)=loz%(i%)+y%: next
90    mat area 6,loz%()
100   goto 30
110   data 10,0,20,10,20,30,10,40,0,30,0,10
