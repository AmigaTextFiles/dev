10    screen 0,4
20    scnclr: k=0
30    for j=1 to 15
40    if j<10 then ?" "j else ?j
50    pena j: peno j
60    box (30,2+k;120,4+k),1: k=k+8: next
70    print at (0,18)"";:input "Which color (1-15)";n$
80    n=val(n$):if n$="" then end else if n<1 or n>15 then 70
90    pena n
100   print at (0,22) ""; :input "Dragon (1-8)";n$
110   n=val(n$): if n$="" then 20 else if n<1 or n>9 then 100
120   scnclr
130   f=128:e=0:k=4^n
140   for x=1 to n:u=f:f=-e/2:e=u/2:next
150   x=80:y=70:locate (x,y)
160   for m=1 to k:z=m:x=x+f:y=y+e:draw (to x,y)
170   for a=0 to 1:z=z/2:q=int(z):a=z-q:next
180   a=(-(q/2=int(q/2))*2-1):u=f:f=a*e:e=-a*u
190   next
200   goto 100
