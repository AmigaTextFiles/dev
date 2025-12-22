100   def fnr(x)=int(x*rnd(20)+1)
110   screen 1,4,3:graphic 1
120   rows=640
130   cols=200
140   scnclr
150   input "40 or 80 columns(40,80):";sclen
160   if sclen<>40 and sclen<>80 then 150
170   if sclen=40 then screen 0,1,0:rows=320
180   scnclr:graphic 0
190   dim x(40),y(40),m(40),n(40)
200   a=40:b=0
210   n1=50:n2=20
220   rem set colors here
230   x(a)=rows/2+fnr(n1):x(a)=x(a)-fnr(n1)
240   y(a)=cols/2+fnr(n1):y(a)=y(a)-fnr(n1)
250   m(a)=rows/2+fnr(n1):m(a)=m(a)-fnr(n1)
260   m(a)=cols/2+fnr(n1):n(a)=n(a)-fnr(n1)
270   v=fnr(n2):v=v-fnr(n2)
280   w=fnr(n2):w=w-fnr(n2)
290   e=fnr(n2):e=e-fnr(n2)
300   f=fnr(n2):f=f-fnr(n2)
310   if x(a)<0 then x(a)=0:v=-v
320   if x(a)>rows-1 then x(a)=rows-1:v=-v
330   if y(a)<0 then y(a)=0:w=-w
340   if y(a)>cols-1 then y(a)=cols-1:w=-w
350   if m(a)<0 then m(a)=a:e=-e
360   if m(a)>rows-1 then m(a)=rows-1:e=-e
370   if n(a)<0 then n(a)=0:f=-f
380   if n(a)>cols-1 then n(a)=cols-1:f=-f
390   draw(x(b),y(b) to m(b),n(b)),sc
400   draw(x(a),y(a) to m(a),n(a)),cl
410   if cflag=1 then cl=cl+1
420   if cl>15 then cl=0
430   x=x(a):y=y(a):m=m(a):n=n(a)
440   if a=40 then a=-1
450   if b=40 then b=-1
460   a=a+1
470   b=b+1
480   x(a)=x+v:y(a)=y+w
490   m(a)=m+e:n(a)=n+f
500   get c$
510   if c$="p" then gosub 560
520   if c$="c" then cflag=1-cflag
530   goto 310
540   j=int(j*rnd(a)+1)
550   return
560   get a$:if a$="" then 560
570   return
