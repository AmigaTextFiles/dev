10    scnclr
30    ask mouse x%, y%, b%
40    if x%=x1% and y%=y1% goto 30
45    peno 0
50    box(x1%-5,y1%-5;x1%+5,y1%+5)
55    peno 1
60    box(x%-5,y%-5;x%+5,y%+5)
70    x1%=x%: y1%=y%
80    goto 30
