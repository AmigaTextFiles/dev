10    n% = 20
20    for x% = 0 to 3
30    for y% = 0 to 3
40    pena x%*4 + y%
50    a% = x%*n%
60    b% = y%*n%
70    peno 1
80    box(a%,b%;a%+n%,b%+n%),1
90    next y%,x%
100   dim a%(1000)
110   i%=narrate("PLEY4S DHAX MAW3S AET DHAX TAA4P LEH4FT KOH4RNER",n%())
120   ask mouse x%,y%,b%
130   if b%=0% then 120
140   i%=narrate("PLEY4S DHAX MAW3S AET DHAX BAA4TAHM RAY3T KOH4RNER",n%())
150   ask mouse x2%,y2%,b%
160   if b%=0% then 150
170   i%=narrate("NAW STAA4RT PEY3NTIHNX",n%())
180   sshape(x%,y%;x2%,y2%),a%()
190   scnclr
200   drawmode 2
210   box(x%,y%;x2%,y2%)
220   drawmode 0
230   for i=1 to 1000
240   next i
250   ask mouse x%,y%,b%
260   if b%=0% then 250
270   gshape(x%,y%),a%()
280   goto 250
