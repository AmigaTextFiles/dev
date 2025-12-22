WINDOW 1,"PyTree table maker"
DEFLNG a-Z

CONST SIZE&=3000
DIM Quad(SIZE&),Disp(SIZE&),Displace(SIZE&),Remain(SIZE&),JumpTo(SIZE&)

Initial=	23160
FirstDisplace=	11580
Quad(0)=Initial^2
Disp(0)=Initial*2+1
Displace(0)=FirstDisplace
Remain(0)=SIZE&-1
MinRange=999999
MaxRange=0
PRINT "Calcing..."
FOR i=0 TO SIZE&-1
 IF INT(i/5000)=i/5000 THEN PRINT 
 IF INT(i/1000)=i/1000 THEN PRINT i,
 IF Quad(i)<>0
  MajorSpace=INT(Remain(i)/2)
  MinorSpace=Remain(i)-MajorSpace
  MinorStart=i+1
  MajorStart=MinorStart+MinorSpace
  JumpTo(i)=MajorStart
  CurBase=INT((Disp(i)-1)/2)
  IF MinorSpace<=0 THEN Remain(i)=-1
'  PRINT "       ","n","base","rem","jump/disp"
'  PRINT "Curr:  ",i,CurBase,Remain(i),JumpTo(i);MinorSpace
  IF Quad(MinorStart)=0 AND MinorSpace>0
   MinorBase=CurBase-Displace(i)
   IF MinorBase<MinRange THEN MinRange=MinorBase
   Quad(MinorStart)=MinorBase^2
   Disp(MinorStart)=MinorBase*2+1
   Displace(MinorStart)=INT(Displace(i)/2)
   Remain(MinorStart)=MinorSpace-1
'   PRINT "Minor: ",MinorStart,MinorBase,Remain(MinorStart),Disp(MinorStart)
  END IF
  IF Quad(MajorStart)=0 AND MajorSpace>0
   MajorBase=CurBase+Displace(i)
   IF MajorBase>MaxRange THEN MaxRange=MajorBase
   Quad(MajorStart)=MajorBase^2
   Disp(MajorStart)=MajorBase*2+1
   Displace(MajorStart)=INT(Displace(i)/2)
   Remain(MajorStart)=MajorSpace-1
'   PRINT "Major: ",MajorStart,MajorBase,Remain(MajorStart),Disp(MajorStart)
  END IF
 END IF
NEXT i

OPEN "ram:PyTree.table" FOR OUTPUT AS 1
PRINT
PRINT "Table range: min =";MinRange,"max =";MaxRange
PRINT "        $^2: min=$";HEX$(MinRange^2),"max=$";HEX$(MaxRange^2)
PRINT
PRINT "Writing..."

FOR i=0 TO SIZE&-1
 IF INT(i/5000)=i/5000 THEN PRINT 
 IF INT(i/1000)=i/1000 THEN PRINT i,
 ju=JumpTo(i)-i
 juofs=ju*12-4
 IF Remain(i)=-1 THEN juofs=-1				' indicated the end of a descending tree.
 PRINT #1,MKL$(Quad(i));MKL$(juofs);MKL$(Disp(i));
NEXT i
CLOSE 1




  
  
  









