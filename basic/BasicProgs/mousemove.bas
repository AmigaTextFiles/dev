0     scnclr
10    rgb 0,15,0,0
20    dim a%(15000)
30    def fna(x)=int(rnd*x)+1
40    ask window width%,height%
50    for x=1 to 100
60    pena fna(15)
70    area(fna(width%),fna(height%) to fna(width%),fna(height%) to fna(width%),fna(height%))
80    next x
90    ask mouse x%,y%,b%
100   if b%=0 then 90
110   gosub 240:if st then 90
120   ask mouse x2%,y2%,b%
130   if (x%=x2%) and (y%=y2%) then 90
131   drawmode 2:box(x%,y%;x2%,y2%):box(x%,y%;x2%,y2%):drawmode 0
150   if b%=4 then 120
160   box(x%,y%;x2%,y2%)
170   if x2%>x% then x2%=x2%+1 else if x2%<x% then x2%=x2%-1
180   if y2%>y% then y2%=y2%+1 else if y2%<y% then y2%=y2%-1
190   sshape(x%,y%;x2%,y2%),a%()
195   get a$:if a$=chr$(13) then 90
200   ask mouse x%,y%,b%
210   if b%=0 then 195
220   gshape(x%,y%),a%()
230   goto 195
240   '
250   if (x%<0) or (y%<0) then st=-1:return
260   if x%>width% then st=-1:return
270   if y%>height% then st=-1:return
280   st=0:return
