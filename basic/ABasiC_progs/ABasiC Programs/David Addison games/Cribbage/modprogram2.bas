5     screen 0,5
10    su=.12:ru=1-su
20    for i=0 to 3:for j=0 to 3:if i mod 2=j mod 2 then 40
30    y(1)=49:y(2)=0:y(3)=0:y(4)=49:goto 50
40    y(1)=0:y(2)=49:y(3)=49:y(4)=0
50    x(1)=20:x(2)=20:x(3)=89:x(4)=89
60    for n=0 to 18:x1=x(4)+i*69:y1=y(4)+j*49
70    for m=1 to 4:x2=x(m)+i*69:y2=y(m)+j*49
80    draw(x1,y1 to x2,y2),m mod 2+1:x1=x2:y1=y2:nj=m mod 4+1
90    xd(m)=ru*x(m)+su*x(nj):yd(m)=ru*y(m)+su*y(nj):next m
100   for p=1 to 4:x(p)=xd(p):y(p)=yd(p):next p,n,j,i
120   get a$:if a$="" then 120 else scnclr:end
