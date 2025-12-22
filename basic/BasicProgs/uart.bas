10    scnclr:gosub 40
20    getkey char$:if char$="/" then 200
30    gosub 150:gosub 160:print char$;:goto 20
40    'Serial I/O driver
50    'config
60    baud%=1200
70    iobase%=&hdff000
80    serdatr%=&h18+iobase%
90    serdat%=&h30+iobase%
100   serper%=&h32+iobase%
110   intreq%=&h9c+iobase%
120   poke_w serper%,(1/baud%)/(.2794*1e-06)
130   return
140   'write
150   poke_w serdat%,asc(char$)+256:return
160   'read
170   char%=peek_w(serdatr%)
180   if (char% and 16384) = 0 then char$="":return
190   char$=chr$(char% and 255):poke intreq%,8:return
200   gosub 160:print char$;:goto 200
