1     col% = 2
5     dim xx(500),yy(500)
10    input"divide segments by how many";space
20    print"click your points."
40    gosub 1000
50    c%=0
60    xx(c%)=x%:yy(c%)=y%
65    scnclr
70    draw (x%,y%)
80    c%=c%+1
90    gosub 1000
100   if (x%<5) and (y%<5) then goto 200
110   xx(c%)=x%:yy(c%)=y%
120   draw(to x%,y%)
125   sleep 500000
130   if c% < 499 then goto 80
200   draw(to xx(0),yy(0))
210   '                **********
220   for i% = 0 to c%-1
230   xx(i%)=xx(i%) + ((xx(i%+1)-xx(i%))/space)
240   yy(i%)=yy(i%) + ((yy(i%+1)-yy(i%))/space)
245   xx(c%)=xx(0):yy(c%)=yy(0)
250   next i%
260   xx(c%)=xx(0)
265   yy(c%)=yy(0)
270   draw(xx(0),yy(0))
280   for i%=0to c%
290   draw(to xx(i%),yy(i%))
300   next i%
305   gosub 2000
310   goto 220
1000  ask mouse x%,y%,b%
1010  if b% = 0 then goto 1000
1020  return
2000  col% = col% + 1
2010  col% = col% mod 15
2020  pena col%
2025  penb col%
2030  return
2035  penb col%
