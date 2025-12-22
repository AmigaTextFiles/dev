10    ' ROR V1.01 (c) 1985 Kevin A. Bjorke
20    dim oldcol%(2,31),map!(32,32),tile%(641):r!=0.:min!=0.:max!=0.:coff%=0:flag%=0:esc$=chr$(27)
30    def fnkr!(x!,y!)=x!/y!+r!*(rnd(1)-.5):def fncolr!(p!)=int((p!-min!)/range!)
40    screen 1,1,0:scnclr:? "ROR V 1.01":ask mouse x%,y%,b%:randomize x%*y%
50    ?:? "One Moment.....":gosub 140:gosub 250:gosub 90:gosub 300
60    get a$:if a$=esc$ then gosub 480:end
70    gosub 140:gosub 250:gosub 300:goto 60
80    end
90    '   Store & replace original colors
100   screen 0,5,0:for reg%=0 to 31:ask rgb reg%,x%,y%,z%
110   oldcol%(0,reg%)=x%:oldcol%(1,reg%)=y%:oldcol%(2,reg%)=z%
120   r%=reg%
130   rgb reg%,r%,r%,r%:next reg%:return
140   ' Build Topology
150   for c%=5 to 1 step -1:st%=2^c%:bk%=st%\2:r!=8.*2.^(c%-5)
160   if flag% then gosub 560
170   for a%=bk% to 32 step st%:a1%=a%-bk%:a2%=a%+bk%
180   for b%=bk% to 32 step st%:b1%=b%-bk%:b2%=b%+bk%
190   map!(a%,b2%)=fnkr((map!(a1%,b2%)+map!(a2%,b2%)),2.)
200   map!(a2%,b%)=fnkr((map!(a2%,b1%)+map!(a2%,b2%)),2.):if flag% then gosub 520
210   if a%=bk% then map!(0,b%)=fnkr((map!(0,b1%)+map!(0,b2%)),2.)
220   if b%=bk% then map!(a%,0)=fnkr((map!(a1%,0)+map!(a2%,0)),2.)
230   map!(a%,b%)=fnkr((map!(a1%,b1%)+map!(a2%,b1%)+map!(a1%,b2%)+map!(a2%,b2%)),4.)
240   next b%,a%,c%:return
250   ' Calculate color set
260   min!=0.:max!=0.:for a%=0 to 32:for b%=0 to 32:if flag% then gosub 520
270   if map!(a%,b%)>max! then max!=map!(a%,b%) else if map!(a%,b%)<min! then min!=map!(a%,b%)
280   next b%:if flag% then gosub 560
290   next a%:range!=(max!-min!)/31.:return
300   ' Draw map
310   peno 31:box(127,63;193,129),0
320   for a%=0 to 32:reg%=fncolr!(map!(a%,a%)):gosub 460
330   x%=a%+128:xx%=192-a%:y%=a%+64:yy%=128-a%:box (x%,y%;xx%,yy%),0
340   if a%=32 then 400
350   for b%=a%+1 to 32
360   reg%=fncolr!(map!(a%,b%)):gosub 460:box (x%,b%+64;xx%,128-b%),0
370   reg%=fncolr!(map!(b%,a%)):gosub 460:box (b%+128,y%;192-b%,yy%),0
380   if flag% then gosub 520
390   next b%
400   next a%:sshape(128,64;192,128),tile%:if not flag% then gosub 430
410   return
420   '
430   for a%=0 to 256 step 64:for b%=0 to 128 step 64
440   gshape (a%,b%),tile%():next b%,a%:flag%=-1:return
450   '
460   if reg%>31 then reg%=31
470   peno reg%:return
480   ' Put old colors back
490   screen 1,1,0:for reg%=0 to 31
500   rgb reg%,oldcol%(0,reg%),oldcol%(1,reg%),oldcol%(2,reg%)
510   next reg%:return
520   ' Cycle colors
530   coff%=coff%+1:if coff%>31 then coff%=0
540   for reg%=0 to 31:r%=(reg%+coff%) and 31
550   rgb reg%,r%,r%,r%:next reg%:return
560   ' copy ROR blocks
570   gshape(int(rnd(1)*9)*32,int(rnd(1)*5)*32),tile%:return
