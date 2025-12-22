SCREEN 1,320,256,3,1
WINDOW 1,"Pyper MultiColor demo...",,,1

xa=100:ya=100:xb=200:yb=200

LINE (xa,ya)-(xb,yb),4,bf
FOR i=xa TO xb STEP 2
LINE (i,ya)-(i,yb),5
NEXT i
FOR j=ya TO yb STEP 2
LINE (xa,j)-(xb,j),6
NEXT j
FOR i=xa TO xb STEP 2
 FOR j=ya TO yb STEP 2
  PSET (i,j),7
 NEXT j
NEXT i
x=xa:sx=(xb-xa)/4
FOR i=4 TO 7
 LINE (x,ya-30)-(x+sx,ya-2),i,bf
 x=x+sx
NEXT i


SUB SetRGB(c,r,g,b)
 PALETTE c,r/255,g/255,b/255
END SUB

RealR=&H9f
RealG=&H4f
RealB=&H6f

GOSUB ShowMC

FOR i=0 TO 255
 RealR=i/1
 RealG=i/2
 RealB=i/8
 GOSUB ShowMC
NEXT i

FOR i=0 TO 255
 RealR=RND(255)*255
 RealG=RND(255)*255
 RealB=RND(255)*255
 GOSUB ShowMC
NEXT i

END

ShowMC:
CALL SetRGB(0,RealR,RealG,RealB)

' Find color 1
' find the min component (r,g,b)
' find the deltas

FindR=RealR
FindG=RealG
FindB=RealB
GOSUB FindBest
Had1R=BestR
Had1G=BestG
Had1B=BestB
CALL SetRGB(4,Had1R,Had1G,Had1B)

' the remaining 3:
' rem*3+had1=4*real
' rem=(4*real-had1)/3

RemainR=4*RealR/3-(Had1R)/3
RemainG=4*RealG/3-(Had1G)/3
RemainB=4*RealB/3-(Had1B)/3
FindR=RemainR
FindG=RemainG
FindB=RemainB
GOSUB FindBest
Had2R=BestR
Had2G=BestG
Had2B=BestB
CALL SetRGB(5,Had2R,Had2G,Had2B)

RemainR=4*RealR/2-(Had1R+Had2R)/2
RemainG=4*RealG/2-(Had1G+Had2G)/2
RemainB=4*RealB/2-(Had1B+Had2B)/2
FindR=RemainR
FindG=RemainG
FindB=RemainB
GOSUB FindBest
Had3R=BestR
Had3G=BestG
Had3B=BestB
CALL SetRGB(6,Had3R,Had3G,Had3B)

RemainR=4*RealR-(Had1R+Had2R+Had3R)
RemainG=4*RealG-(Had1G+Had2G+Had3G)
RemainB=4*RealB-(Had1B+Had2B+Had3B)
FindR=RemainR
FindG=RemainG
FindB=RemainB
GOSUB FindBest
Had4R=BestR
Had4G=BestG
Had4B=BestB
CALL SetRGB(7,Had4R,Had4G,Had4B)
'LOCATE 1,1
'PRINT SPACE$(50)
'PRINT SPACE$(50)
'PRINT SPACE$(50)
'PRINT SPACE$(50)
'LOCATE 1,1
'PRINT "1";Had1R,Had1G,Had1B
'PRINT "2";Had2R,Had2G,Had2B
'PRINT "3";Had3R,Had3G,Had3B
'PRINT "4";Had4R,Had4G,Had4B
ErrR=RealR-(Had1R+Had2R+Had3R+Had4R)/4
ErrG=RealG-(Had1G+Had2G+Had3G+Had4G)/4
ErrB=RealB-(Had1B+Had2B+Had3B+Had4G)/4
LOCATE 1,1
PRINT SPACE$(35)
LOCATE 1,1
PRINT ErrR,ErrG,ErrB
RETURN

FindBest:
 IF FindR>255 THEN FindR=255
 IF FindG>255 THEN FindG=255
 IF FindB>255 THEN FindB=255
 MinC=FindR
 IF FindG<MinC THEN MinC=FindG
 IF FindB<MinC THEN MinC=FindB
 MaxC=FindR
 IF FindG>MaxC THEN MaxC=FindG
 IF FindB>MaxC THEN MaxC=FindB
 MaxS=0:MaxN=0
 DeltaR=FindR-MinC
 DeltaG=FindG-MinC
 DeltaB=FindB-MinC
 DeltaMax=(MaxC-MinC)/2
 IF DeltaR>DeltaMax
  MaxS=MaxS+FindR:MaxN=MaxN+1
 END IF
 IF DeltaG>DeltaMax
  MaxS=MaxS+FindG:MaxN=MaxN+1
 END IF
 IF DeltaB>DeltaMax
  MaxS=MaxS+FindB:MaxN=MaxN+1
 END IF
 IF MaxN>0
  MaxS=MaxS/MaxN
  IF DeltaR>DeltaMax THEN BestR=MaxS ELSE BestR=0
  IF DeltaG>DeltaMax THEN BestG=MaxS ELSE BestG=0
  IF DeltaB>DeltaMax THEN BestB=MaxS ELSE BestB=0
 ELSE
  MinS=(FindR+FindG+FindB)/3
  BestR=MinS
  BestB=MinS
  BestG=MinS
 END IF
RETURN
  



 

