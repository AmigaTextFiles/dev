10    scnclr
20    dim a%(1000),b%(1000)
30    sshape(0,0;20,20),b%()
40    box(1,1;19,19),1
50    sshape(0,0;20,20),a%()
60    gshape(0,0),b%()
70    for i%=1% to 2%
80    for x%=0% to 250
90    gshape(x%,50),b%()
100   gshape(x%+1,50),a%()
110   next x%
120   for x%=250 to 0 step -1
130   gshape(x%+1,50),b%()
140   gshape(x%,50),a%()
150   next x%
160   for y%=0% to 150%
170   gshape(100%,y%),b%()
180   gshape(100%,y%+1%),a%()
190   next y%
200   for y%=150% to 0% step -1%
210   gshape(100%,y%+1%),b%()
220   gshape(100%,y%),a%()
230   next y%
240   next i%
250   for i%=1% to 2%
260   y%=0%
270   for x%=0% to 150%
280   gshape(x%,50%),b%()
290   gshape(x%+1%,50%),a%()
300   gshape(100%,y%),b%()
310   gshape(100%,y%+1%),a%()
320   y%=y%+1%
330   next x%
340   for x%=150% to 0% step -1%
350   gshape(x%+1%,50%),b%()
360   gshape(x%,50%),a%()
370   gshape(100%,y%+1%),b%()
380   gshape(100%,y%),a%()
390   y%=y%-1%
400   next x%
410   next i%
420   goto 70
430   end
