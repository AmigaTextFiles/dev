10    '  ***** Spiralizer *****
20    '  **  hi-res (640X200) version **
30    '
40    '  ** Translated from the Atari 800 **
50    '  ** by David Milligan, 70707,2521  11/2/85    **
60    ' 
70    '  ***  This came out of an Atari magazine a couple
80    '  ***  of years ago, and I can't remember which one.
90    '  ***  The listing I worked off of had been severely
100   '  ***  hacked by someone trying to do graphic dumps
110   '  ***  to a DEC lineprinter, so it looks kinda rough.
120   '
130   '  ***  Another graphics toy, this does a pretty good
140   '  ***  job of mimicking the Spirographs we played with
150   '  ***  when we were kids, er, physically younger kids.
160   '
170   '
180   dim a$(3),x$(4)
190   ask window wid%,hi%:if wid%>600 then 210
200   screen 1,4,0
210   rgb 0,0,0,0:rgb 1,15,15,15
220   rgb 3,15,6,0
230   rgb 9,0,0,15:rgb 10,3,6,15
240   rgb 11,7,7,15:rgb 12,12,0,14
250   rgb 13,15,2,14
260   rgb 15,0,0,0
270   gosub 1070
280   goto 1160
290   g=4:z=5
300   scnclr
310   '
320   '  ****  Speed Input ****
330   '
340   ?" Speed (-50 to 50) ";:input x$
350   z=val(x$):if x$="" then z=5
360   if z<-50 or z>50 then z=5
370   k=z:? z:k=k-1
380   oldspeed=z
390   '
400   '  **** Radius Input ****
410   '
420   g=3:z=35:?" Radius (1-60) ";:input z
430   if z<1 or z>60 then z=35
440   r=z:? z:r=r+13:s=1
450   oldrad=z
460   '
470   '  **** Spin Input ****
480   '
490   z=1:?" Spin (1 to 18) ";:input a$:gosub 1010
500   if z<1 or z>18 then z=1:? z
510   oldspin=z
520   a=1/z:if z>1 and z<9 then 650
530   '
540   ' **** Movement Prompt ****
550   '
560   sm=1:m=2:?" Movement or Decrement (m/d)";
570   getkey x$
580   if x$="m" then sm=0:goto 610
590   if x$="d" then m=0:goto 610
600   m=0:sm=0:x$="none"
610   ?x$
620   '
630   '  **** Clear Screen Prompt ****
640   '
650   ?" Clear Screen (y/n) ";
660   getkey a$:if a$<>"n" then gosub 1060:goto 680
670   ? "no";
680   w=1:z=139:if m=2 then z=80:if a=1 then w=5:m=1:z=122
690   if sm-a=0 then w=5
700   if a<1 then k=k+a
710   c=1e-03:if a<1/9 then m=m/2:c=c/2
720   j=r:i=79-r
730   close #2
740   cmd 1
750   draw((z+20)*2,6)
760   col=2
770   pena col:rgb 0,0,0,0
780   rgb 15,0,0,0
790   '
800   '  ***  Main Loop ***
810   '
820   cnt=0
830   for t=0 to 6.2831/a*w step .06283
840   if sm then j=r*s:i=79*s-j:s=s-c
850   draw(to ((z+t*m-sin(t)*j+sin(t*k)*i)+20)*2,85-cos(t)*j-cos(t*k)*i)
860   cnt=cnt+1
870   if cnt>100 then cnt=0:col=col+1:if col=15 then col=2
880   pena col
890   ask mouse x%,y%,b%:if b%<>0 then 1160
900   next t
910   '
920   '  **** Poll Mouse Button ****
930   '
940   ask mouse x%,y%,b%:if b%=0 then 940
950   goto 1160
960   scnclr
970   rgb 0,6,9,15:rgb 1,0,0,0
980   rgb 15,11,11,11
990   goto 290
1000  '
1010  sign=1:if left$(a$,1)="-" then a$=mid$(a$,2):sign=-1
1020  z=0:for i=1 to len(a$):z=z*10+asc(mid$(a$,i,i))-48
1030  next i:z=sign*z:return
1040  '
1050  '
1060  cmd 1:scnclr:cmd 2:return
1070  window #1,0,0,640,200,"Spiralizer"
1080  cmd 1:graphic(1):return
1090  '
1100  '  ***  menu window  ***
1110  '
1120  window #2,0,10,250,110,"Spiralizer Menu"
1130  cmd 2:graphic(0):scnclr:return
1140  '
1150  '
1160  gosub 1120
1170  ? at(2,2);" Press '0' to exit"
1180  ? at(2,4);" Press any other key"
1190  ? at(2,5);" to begin."
1200  getkey a$
1210  if a$="0" then 1240
1220  scnclr
1230  goto 320
1240  gosub 1060
1250  close 2,1
1260  rgb 0,6,9,15:rgb 1,0,0,0
1270  rgb 15,11,11,11
1280  end
