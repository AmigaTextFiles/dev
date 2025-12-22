'$INCLUDE BASU:_LoadPalette.bas
'$INCLUDE BASU:_DoHSL.bas

DECLARE FUNCTION FMedian(a,b,c)

SCREEN 1,320,256,8,1
WINDOW 1,"Shaded resize...",,,1

pal$="EscapeLevels:BackGrounds/Various1.rgb32"
CALL LoadPalette(pal$,1)
CALL DoHSL

FUNCTION BestCol(RF%,GF%,BF%,ER%,EG%,EB%,RA%,RB%)
 SHARED R%(),G%(),B%()
 LOCAL p%,BER&,CER&,CEG&,CEB&,BC%,CE&
 BER&=2^20
 FOR p%=RA% TO RB%
  CER&=ABS(R%(p%)-RF%)*ER%
  CEG&=ABS(G%(p%)-GF%)*EG%
  CEB&=ABS(B%(p%)-BF%)*EB%
  CE&=CER&+CEG&+CEB&
  IF CE&<BER& THEN BER&=CE&:BC%=p%
 NEXT p%
 BestCol=BC%
END FUNCTION

tx$="EscapeLevels:BackGrounds/Foglie.txt"
OPEN tx$ FOR INPUT AS 1
IMAGE$=INPUT$(LOF(1),1)
CLOSE 1

'GOTO TexDRAW

DIM SHP%(255),USD%(255),RMP%(255)
FOR i=0 TO 255:USD%(i)=0:NEXT i

sx=16:sy=14:x=0:y=0
SHP%(0)=254

FOR i%=1 TO 254
 LINE (x,y)-(x+sx,y+sy),SHP%(i%-1),bf
 x=x+sx:IF x>sx*15 THEN x=0:y=y+sy
 BER&=2^20
 FOR j%=0 TO 255
  IF j%<>i%
   IF USD%(j%)=0
    f%=SHP%(i%-1)
    CER&=ABS(R%(j%)-R%(f%))
    CEG&=ABS(G%(j%)-G%(f%))
    CEB&=ABS(B%(j%)-B%(f%))
    CEH&=ABS(Hue%(j%)-Hue%(f%))
    CES&=ABS(Sat%(j%)-Sat%(f%))
    CEL&=ABS(Lum%(j%)-Lum%(f%))
    CT&=256/(CEL&+16)
    HT&=(Lum%(j%)+Lum%(f%))/4
    ST&=CT&
    LT&=(Lum%(j%)+Lum%(f%))/32
    CE&=CER&*CT&+CEG&*CT&+CEB&*CT&+CEH&*HT&+CES&*ST&+CEL&*LT&
    IF CE&<BER& THEN BER&=CE&:BC%=j%
   END IF
  END IF
 NEXT j%
 SHP%(i%)=BC%
 RMP%(BC%)=i%
 USD%(BC%)=1
NEXT i%

TEXDRAW:


CLS
a=230
b=249
x=0
FOR i=0 TO 1 STEP 1/100
 x=x+1
 LINE (x,1)-(x,10),FMedian(a,b,i)
NEXT i
LINE (0,10)-(20,20),a,bf
LINE (90,10)-(100,20),b,bf

'END

CLS
cxa=0:cya=0
stx=0:sty=.2
hsx=.2:hsy=0
dey=100

TEXPTR&=SADD(IMAGE$)

FUNCTION Median(a,b,ko)
 SHARED R%(),G%(),B%()
 nR=(R%(b)-R%(a))*ko+R%(a)
 nG=(R%(b)-R%(a))*ko+G%(a)
 nB=(R%(b)-R%(a))*ko+B%(a)
 m=BestCol(nR,nG,nB,1,1,1,0,255)
 Median=m
END FUNCTION

FUNCTION FMedian(a,b,ko)
 SHARED SHP%(),RMP%()
 FMedian=SHP%(RMP%(a)+(RMP%(b)-RMP%(a))*ko)
END FUNCTION

FOR y=1 TO 100
 cxl=cxa
 cyl=cya
 FOR x=1 TO 100
  xot=cxl
  yot=cyl
  cxl=cxl+hsx
  cyl=cyl+hsy
  exx=(xot-INT(xot))
  exy=(yot-INT(yot))		' eccedenze x e y
  
  cob=PEEKB(TEXPTR&+INT(xot)+INT(yot)*64+1)
  coex=PEEKB(TEXPTR&+INT(xot)+INT(yot)*64+2)
  coey=PEEKB(TEXPTR&+INT(xot)+INT(yot)*64+1+64)
    
  co1=FMedian(cob,coex,exx)
  co=FMedian(co1,coey,exy)
  
  PSET (x,y),co1
  PSET (x+100,y),co
  PSET (x,y+100),cob
 NEXT x
 cxa=cxa+stx
 cya=cya+sty
NEXT y

  
  
  
  
  
  