WINDOW 1,"TreeUse"
DEFLNG a-Z
CONST SIZE&=4096
OPEN "Ram:PyTree.table" FOR INPUT AS 1
DIM Quad(SIZE&),Disp(SIZE&),Jump(SIZE&)
FOR i=0 TO SIZE& 
 IF i/1000=INT(i/1000) THEN PRINT i
 a$=INPUT$(12,1)
 Quad(i)=CVL(LEFT$(a$,4))
 Jump(i)=CVL(MID$(a$,5,4))
 Disp(i)=CVL(RIGHT$(a$,4))
NEXT i
CLOSE 1

calc=4900^2

cur=0
cycle:
PRINT "cur: ",cur,INT(Disp(cur)-1)/2,Jump(cur)
IF Quad(cur)<calc
 PRINT "jump!",
 ju=Jump(cur)+4
 PRINT ju,ju/12
 cur=cur+INT((ju/12))
 IF Jump(cur)<=0 THEN PRINT "result";INT(Disp(cur)-1)/2:GOTO fine
ELSE
 cur=cur+1
 IF Jump(cur)<0 THEN PRINT "result";INT(Disp(cur)-1)/2:GOTO fine
END IF
GOTO cycle
fine:
