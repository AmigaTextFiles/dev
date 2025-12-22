5     dim a$(3)
6     a$(0)="red":a$(1)="grn":a$(2)="blu"
10    screen 0,5,0
20    for y%=0to 3
30    for x%=0to 7
40    col%=(x%*4)+y%
50    pena col%
60    xx%=x%*23:yy%=y%*23
70    box (xx%,yy%;xx%+23,yy%+23),1
80    next
90    next
100   graphic(1)
105   pena 1
110   widt%=180'ask window widt%,y%
120   bst%=100
130   for i%=0 to 2
140   'box(30,bst%+(i%*10);widt%,bst%+9+(i%*10))
145   print at(0,bst%+8+i%*10);a$(i%)
150   next
155   ii=(widt%-30)/16
160   for i%=0 to 16
170   x%=i%*ii + 30%
180   draw(x%,bst%-6 to x%,bst%)
190   next
1000  ask mouse wx%,wy%,b%
1010  if b%=0 then 1000
1015  if wx%>181 then goto 1000
1020  if wy%>92 then goto 2000
1025  p%=wx%:q%=wy%
1030  wx%=(wx%-9)/23
1040  wy%=(wy%-11)/23
1050  col%=wx%*4+wy%
1055  gosub 2040
1056  ask mouse x%,y%,b%
1057  if b%<>0 then goto 1056
1060  goto 1000
2000  if wy%<=bst% or wy%>130 then goto 1000
2005  ask mouse wx%,wy%,b%
2007  if b%=0 then goto 2005
2008  wx%=wx%-8
2009  if wx%<30 then goto 2000
2010  wy%=wy%-bst%-6
2015  which%=wy%/10
2016  if xy%<0 then wy%=0
2020  place = (wx%-30)/9.375
2030  color%=place
2031  hue%(which%)=color%
2032  rgb col%,hue%(0),hue%(1),hue%(2)
2033  gosub 2040
2034  ask mouse x%,y%,b%
2035  if b%<>0 then goto 2034
2036  goto 2000
2040  ask rgb col%,hue%(0),hue%(1),hue%(2)
2041  pena col%:box(31,bst%;widt%,bst%+30),1
2045  pena 1
2050  for i%=0 to 2
2060  box(31,bst%+2+(i%*10);39+(hue%(i%)*ii),bst%+9+(i%*10)),1
2070  next
2080  return
