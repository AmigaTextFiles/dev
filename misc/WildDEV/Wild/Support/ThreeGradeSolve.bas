DEFDBL a,b,c,d,x,y
'$include basu:_waitkey.bas

SCREEN 1,720,400,2,5
WINDOW 1,"Funzione di grado 3",,,1

ox=200
oy=100

'INPUT "Spazio iniziale funzione a                       ",ad
'INPUT "Velocità iniziale funzione a                     ",ac
'INPUT "Accelerazione iniziale funzione a                ",ab:ab=ab/2
'INPUT "Variazione di accelerazione funzione a           ",aa:aa=aa/6

'INPUT "Spazio iniziale funzione b                       ",bd
'INPUT "Velocità iniziale funzione b                     ",bc
'INPUT "Accelerazione iniziale funzione b                ",bb:bb=bb/2
'INPUT "Variazione di accelerazione funzione b           ",ba:ba=ba/6

ad=0	:ac=-520	:ab=10	:aa=.10				:ab=ab/2:aa=aa/6
bd=0	:bc=-500:bb=-21	:ba=+.1				:bb=bb/2:ba=ba/6
cd=ad-bd:cc=ac-bc:cb=ab-bb:ca=aa-ba

s=1:ox=360:oy=200:sy=.001
GOSUB Draw
REPEAT see
 a$=WaitKey$
 IF a$="6" THEN ox=ox+1:GOSUB Draw
 IF a$="4" THEN ox=ox-1:GOSUB Draw
 IF a$="8" THEN oy=oy-1:GOSUB Draw
 IF a$="2" THEN oy=oy+1:GOSUB Draw
 IF a$="+" THEN s=s*1.3:GOSUB Draw
 IF a$="-" THEN s=s*.7:GOSUB Draw 
 IF a$="x" THEN EXIT see
 IF a$="c" THEN CLS:GOSUB Draw
END REPEAT see
WINDOW CLOSE 1
SCREEN CLOSE 1
END

Draw: 
COLOR 2,0:LOCATE 1,1:PRINT SPACE$(50):LOCATE 1,1:PRINT "a:a,b,c,d",aa,ab,ac,ad
''COLOR 1,0:LOCATE 2,1:PRINT SPACE$(50):LOCATE 2,1:PRINT "b:a,b,c,d",ba,bb,bc,bd
''COLOR 3,0:LOCATE 3,1:PRINT SPACE$(50):LOCATE 3,1:PRINT "c:a,b,c,d",ca,cb,cc,cd
GOSUB Axis
CALL DrawThree(aa,ab,ac,ad,2)
''CALL DrawThree(ba,bb,bc,bd,1)
''CALL DrawThree(ca,cb,cc,cd,3)
RETURN

SUB DrawThree(a,b,c,d,col)
SHARED ox,oy,s,sy
LOCAL i
FOR i=0 TO 720
x=(i-ox)/s
y=-(x^3*a+x^2*b+x*c+d)*sy+oy
yy=(x^2*a*3+b*2*x+c)
IF ABS(yy)<5 THEN CIRCLE (i,y),5,3:PRINT x,(-b-SQR(b*b+2*a*c))/a
IF y>0 AND y<400 THEN PSET (i,y),col:IF ABS((-b/(2*a))-x)<.5 THEN CIRCLE (i,y),5,col
NEXT i
END SUB

Axis:
LINE (0,oy)-(720,oy),3
LINE (ox,0)-(ox,400),3
RETURN



