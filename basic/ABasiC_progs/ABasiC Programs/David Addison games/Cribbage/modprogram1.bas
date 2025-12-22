5     screen 0,5
10    su=.1:ru=1-su:ii=1:c=1
20    for j=0 to 3:ii=-ii:jj=1:for i=0 to 6:jj=-jj:if i<j or i>6-j then 110
30    if j<2 or i>2 then c=c mod 3+1
40    if j=3 then c=c mod 3+1
50    x(1)=0:x(2)=39:x(3)=78:y(1)=0:y(3)=0:if ii=jj then y(2)=48 else y(2)=-48
60    for n=1 to 11:x1=3+x(3)+i*39:y1=165-y(3)-j*48+ii*jj*24
70    for m=1 to 3:x2=3+x(m)+i*39:y2=165-y(m)-j*48+ii*jj*24:c=c mod 3+1
80    draw(x1,y1 to x2,y2),c:x1=x2:y1=y2:nj=m mod 3+1
90    xd(m)=ru*x(m)+su*x(nj):yd(m)=ru*y(m)+su*y(nj):next m
100   for p=1 to 3:x(p)=xd(p):y(p)=yd(p):next p,n
110   next i,j
120   get a$:if a$="" then 120 else scnclr:end
