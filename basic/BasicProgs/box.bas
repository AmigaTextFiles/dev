10    n% = &HFFFF
11    drawmode 1
12    ask window wx%, wy%
15    w = rnd * wx%
16    h = rnd * wy%
17    x = rnd * wx%
18    y = rnd * wy%
20    for i% = 0 to 7
30    a%(i%) = rnd * n%
40    next
45    pa% = rnd * 15
46    pb% = rnd * 15
47    if pb% = pa% then pb% = pa% + 1
50    pattern 8, a%()
55    pena pa% : penb pb%
60    box(w,h;x,y), 1
70    goto 12
