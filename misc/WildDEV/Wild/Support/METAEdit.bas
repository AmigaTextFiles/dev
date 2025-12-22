SCREEN 1,720,455,2,5
WINDOW 1,"METAEdit ...",(0,0)-(640,400),,1
PALETTE 0,.6,.7,.8
PALETTE 1,0,0,0
PALETTE 2,1,1,1
PALETTE 3,1,.8,.2
DIM DotWM$(3)
DotWM$(DOTX%)="x"
DotWM$(DOTY%)="y"
DotWM$(DOTZ%)="z"
MAXDOTMAP%=3
DIM EdgeWM$(2)
EdgeWM$(EDGPA%)="pa"
EdgeWM$(EDGPB%)="pb"
MAXEDGMAP%=2
DIM FaceWM$(15)
FaceWM$(FACPA%)="pa"
FaceWM$(FACPB%)="pb"
FaceWM$(FACPC%)="pc"
FaceWM$(FACLA%)="la"
FaceWM$(FACLB%)="lb"
FaceWM$(FACLC%)="lc"
FaceWM$(FACPLUS%)="plus"
FaceWM$(FACMINUS%)="minus"
FaceWM$(FACTXA%)="txa"
FaceWM$(FACTXB%)="txb"
FaceWM$(FACTXC%)="txc" 
FaceWM$(FACTYA%)="tya"
FaceWM$(FACTYB%)="tyb"
FaceWM$(FACTYC%)="tyc"
FaceWM$(FACTEX%)="tex"
MAXFACMAP%=15
DIM TexWM$(11)
TexWM$(TEXFILE%)="file"
TexWM$(TEXPALETTE%)="palette"
TexWM$(TEXSIZEX%)="sizex"
TexWM$(TEXSIZEY%)="sizey"
MAXTEXMAP%=11

'$INCLUDE BASU:_Cut.bas
'$INCLUDE BASU:_NumInt.bas
'$INCLUDE BASU:_Command.bas
'$INCLUDE BASU:_METAConsts.bas
'$INCLUDE BASU:_CutWord.bas
'$INCLUDE BASU:_LoadMETA.bas
'$INCLUDE BASU:_Prox.bas
'$INCLUDE BASU:_SafeLine.bas
'$INCLUDE BASU:_METAViewTD.bas
'$INCLUDE BASU:_WAITKEY.bas
'$INCLUDE BASU:_CutSpace.bas
'$INCLUDE BASU:_CommandInput.bas
'$INCLUDE BASU:_Contain.bas
'$INCLUDE BASU:_SaveMETA.bas
'$INCLUDE BASU:_SuperPrint.bas
'$INCLUDE BASU:_FileReq.bas
'$INCLUDE BASU:_LoadPalette.bas
'$INCLUDE BASU:_WAITHIT.bas

viewmode&=VIEWMODE_WIRE&+VIEWFLAG_SELSHOW&+VIEWFLAG_SELNORM&+VIEWFLAG_SHOWFACES&+VIEWFLAG_SHOWPNTS&+VIEWFLAG_SELPNTS&
CurFace=1:CurTexture=1
METAIN$=FileReq$("WildPJ:Support/META/","Select META input...","#?.META")
LoadMETA(METAIN$)

FOR i=1 TO 12
 READ ObjRef(i)
NEXT i
GOSUB Refresh
WINDOW 2,"Console...",(210,20)-(410,100),,1
REPEAT cons
 WINDOW OUTPUT 1
 LOCATE 1,1
 COLOR 2,1
 PRINT "CF:";CurFace,"CTX";CurTexture
 WINDOW OUTPUT 2
 CALL CommandInput
 SELECT CASE CM$
  CASE "X"
   EXIT cons
  CASE "?"
   GOSUB Help
  CASE "MOVER" 
   GOSUB Mover
  CASE "SELF" 
   GOSUB SelFace
  CASE "FLIP" 
   GOSUB Flip
  CASE "EXG"
   GOSUB Exg
  CASE "NORM"
   GOSUB Norm
  CASE "CENTON"
   GOSUB CenterOn
  CASE "TEXPB"
   GOSUB TexturePosBorder
  CASE "TEXPI"
   GOSUB TexturePosGfxInput
  CASE "TEXMP"
   GOSUB TexturePlaneMap
  CASE "TEXLOAD"
   GOSUB TextureLoad
  CASE "TEXSHOW"
   GOSUB TextureShow
  CASE "CURTEX"
   CurTexture=VAL(PA$(1))
  CASE "OFFS"
   GOSUB Offset
  CASE ELSE
   PRINT "Unknow."
 END SELECT
END REPEAT cons
CALL SaveMETA(METAIN$)
WINDOW CLOSE 2
WINDOW CLOSE 1
SCREEN CLOSE 1
END

TextureShow:
GOSUB TextureLoadImage
SCREEN 2,320,320,8,1
T$=Num$(CurTexture)+":"+Tex$(CurTexture,TEXNAME%)+" X,Y:"+Num$(Tex(CurTexture,TEXSIZEX%))+"x"+Num$(Tex(CurTexture,TEXSIZEY%))+" Mem:"+Num$(Tex(CurTexture,TEXSIZEX%)*Tex(CurTexture,TEXSIZEY%))
WINDOW 3,T$,,8,2
WINDOW OUTPUT 3
CALL LoadPalette(Tex$(CurTexture,TEXPALETTE%),2)
xa=(WINDOW(2)-Tex(CurTexture,TEXSIZEX%))/2
ya=(WINDOW(3)-Tex(CurTexture,TEXSIZEY%))/2
txpx!=1
FOR i=1 TO Tex(CurTexture,TEXSIZEY%)
 FOR j=1 TO Tex(CurTexture,TEXSIZEX%)
  PSET (j,i),ASC(MID$(Tex$(CurTexture,TEXIMAGE%),txpx!,1))
  txpx!=txpx!+1
  IF INKEY$<>"" THEN GOTO TS_X
 NEXT j
NEXT i
TS_X:
a$=WAITKEY$
WINDOW CLOSE 3
SCREEN CLOSE 2
RETURN

TextureLoadImage:
IF FEXISTS(Tex$(CurTexture,TEXFILE%))
 OPEN Tex$(CurTexture,TEXFILE%) FOR INPUT AS 1
 texsize=LOF(1)
 Tex$(CurTexture,TEXIMAGE%)=INPUT$(texsize,1)
 Tex(CurTexture,TEXSIZEX%)=INT(texsize^.5)
 Tex(CurTexture,TEXSIZEY%)=INT(texsize^.5)
END IF
RETURN

TextureLoad:
NTEX=NTEX+1
CurTexture=NTEX
Tex$(CurTexture,TEXFILE%)=FileReq$("Escapelevels:","Select a chunky image","#?")
Tex$(CurTexture,TEXPALETTE%)=FileReq$("Escapelevels:","Select his palette","#?")
GOSUB TextureLoadImage
Tex(CurTexture,USED%)=LOADED%
GOSUB TextureShow
RETURN

TextureBWShow:
GOSUB TextureLoadImage
wid=Tex(CurTexture,TEXSIZEX%)
hei=Tex(CurTexture,TEXSIZEY%)
WINDOW 3,"Select points",(0,0)-(wid,hei+32),0,1
xa=0
ya=0
xb=xa+wid
yb=ya+hei
LINE (xa,ya)-(xb,yb),1,bf
LINE (xa,ya)-(xb,yb),2,b
FOR y=0 TO hei-1 STEP 1
 FOR x=0 TO wid-1 STEP 2
  a!=x+y*wid+1
  PSET (x,y),ASC(MID$(Tex$(CurTexture,TEXIMAGE%),a!,1))
 NEXT x
NEXT y
RETURN

TexturePlaneMap:		' I,J,[A/S]
PA$(1)=UCASE$(PA$(1)):a$=PA$(1)
SELECT CASE a$
 CASE "X"
  IOF%=DOTX%
 CASE "Y"
  IOF%=DOTY%
 CASE "Z"
  IOF%=DOTZ%
 CASE ELSE
  IOF%=DOTX%
END SELECT
PA$(2)=UCASE$(PA$(2)):a$=PA$(2)
SELECT CASE a$
 CASE "X"
  JOF%=DOTX%
 CASE "Y"
  JOF%=DOTY%
 CASE "Z"
  JOF%=DOTZ%
 CASE ELSE
  JOF%=DOTZ%
END SELECT
PA$(3)=UCASE$(PA$(3))
IF PA$(3)<>"A" THEN PA$(3)="S"

GOSUB TextureBWShow
MINI=Dot(1,IOF%)
MAXI=MINI
MINJ=Dot(1,JOF%)
MAXJ=MINJ
FOR i=1 TO NDOT
 II=Dot(i,IOF%)
 JJ=Dot(i,JOF%)
 IF II<MINI THEN MINI=II
 IF II>MAXI THEN MAXI=II
 IF JJ<MINJ THEN MINJ=JJ
 IF JJ>MAXJ THEN MAXJ=JJ
NEXT i
DEI=MAXI-MINI
DEJ=MAXJ-MINJ
GOSUB TGI_HavePoint:RXA=TX:RYA=TY
GOSUB TGI_HavePoint:RXB=TX:RYB=TY
RWI=RXB-RXA
RHE=RYB-RYA
FOR i=1 TO NFAC
 IP=Dot(Face(i,FACPA%),IOF%)
 JP=Dot(Face(i,FACPA%),JOF%)
 GOSUB TPM_DoDot
 PXA%=TX:PYA%=TY
 IP=Dot(Face(i,FACPB%),IOF%)
 JP=Dot(Face(i,FACPB%),JOF%)
 GOSUB TPM_DoDot
 PXB%=TX:PYB%=TY
 IP=Dot(Face(i,FACPC%),IOF%)
 JP=Dot(Face(i,FACPC%),JOF%)
 GOSUB TPM_DoDot
 PXC%=TX:PYC%=TY 
 LINE (xa+PXA%,ya+PYA%)-(xa+PXB%,ya+PYB%),2
 LINE (xa+PXC%,ya+PYC%)-(xa+PXB%,ya+PYB%),2
 LINE (xa+PXA%,ya+PYA%)-(xa+PXC%,ya+PYC%),2
 CUR$="N"
 IF PA$(3)="S"
  CurFace=i
  GOSUB Refresh
  WINDOW OUTPUT 3
  LOCATE hei/8+2,1
  INPUT "Y/n ";CUR$
  CUR$=UCASE$(CUR$)
 END IF
 IF PA$(3)="A" OR CUR$<>"N"
  Face(i,FACTXA%)=PXA%
  Face(i,FACTYA%)=PYA%
  Face(i,FACTXB%)=PXB%
  Face(i,FACTYB%)=PYB%
  Face(i,FACTXC%)=PXC%
  Face(i,FACTYC%)=PYC%
 END IF
NEXT i 
WINDOW CLOSE 3
RETURN

TPM_DoDot:
TX=RXA+((IP-MINI)*RWI/DEI)
TY=RYA+((JP-MINJ)*RHE/DEJ)
RETURN

TGI_HavePoint:
LOCATE hei/8+2,1:CALL WAITHIT:B=MOUSE(0):TX=MOUSE(1):TY=MOUSE(2)
RETURN


TexturePosGfxInput:
GOSUB TextureBWShow
WINDOW OUTPUT 3
GOSUB TGI_HavePoint:PXA%=TX:PYA%=TY
GOSUB TGI_HavePoint:PXB%=TX:PYB%=TY
LINE (xa+PXA%,ya+PYA%)-(xa+PXB%,ya+PYB%),3
GOSUB TGI_HavePoint:PXC%=TX:PYC%=TY
LINE (xa+PXC%,ya+PYC%)-(xa+PXB%,ya+PYB%),3
LINE (xa+PXA%,ya+PYA%)-(xa+PXC%,ya+PYC%),3
Face(CurFace,FACTXA%)=PXA%
Face(CurFace,FACTYA%)=PYA%
Face(CurFace,FACTXB%)=PXB%
Face(CurFace,FACTYB%)=PYB%
Face(CurFace,FACTXC%)=PXC%
Face(CurFace,FACTYC%)=PYC%
WINDOW CLOSE 3
WINDOW OUTPUT 2
RETURN

TexturePosBorder:
PA$(1)=UCASE$(PA$(1))
S$=PA$(1)
SELECT CASE S$
 CASE "AB" 
  TXI%=FACTXA%:TYI%=FACTYA%:TXF%=FACTXB%:TYF%=FACTYB%:TXM%=FACTXC%:TYM%=FACTYC%
 CASE "BA"
  TXI%=FACTXB%:TYI%=FACTYB%:TXF%=FACTXA%:TYF%=FACTYA%:TXM%=FACTXC%:TYM%=FACTYC%
 CASE "AC"
  TXI%=FACTXA%:TYI%=FACTYA%:TXF%=FACTXC%:TYF%=FACTYC%:TXM%=FACTXB%:TYM%=FACTYB%
 CASE "CA"
  TXI%=FACTXC%:TYI%=FACTYC%:TXF%=FACTXA%:TYF%=FACTYA%:TXM%=FACTXB%:TYM%=FACTYB%
 CASE "BC"
  TXI%=FACTXB%:TYI%=FACTYB%:TXF%=FACTXC%:TYF%=FACTYC%:TXM%=FACTXA%:TYM%=FACTYA%
 CASE "CB"
  TXI%=FACTXC%:TYI%=FACTYC%:TXF%=FACTXB%:TYF%=FACTYB%:TXM%=FACTXA%:TYM%=FACTYA%
 CASE ELSE
  TXI%=FACTXA%:TYI%=FACTYA%:TXF%=FACTXB%:TYF%=FACTYB%:TXM%=FACTXC%:TYM%=FACTYC%
END SELECT
PA$(2)=UCASE$(PA$(2))
S$=PA$(2)
SELECT CASE S$
 CASE "T"
  PXA%=0:PYA%=0:PXB%=Tex(CurTexture,TEXSIZEX%):PYB%=PYA%
  PXC%=VAL(PA$(3)):PYC%=Tex(CurTexture,TEXSIZEY%)
 CASE "B"
  PXA%=0:PYA%=Tex(CurTexture,TEXSIZEY%):PXB%=Tex(CurTexture,TEXSIZEX%):PYB%=PYA%
  PXC%=VAL(PA$(3)):PYC%=0
 CASE "R"
  PXA%=Tex(CurTexture,TEXSIZEX%):PYA%=Tex(CurTexture,TEXSIZEY%):PXB%=PXA%:PYB%=0
  PXC%=0:PYC%=VAL(PA$(3))
 CASE "L"
  PXA%=0:PYA%=Tex(CurTexture,SIZEY%):PXB%=0:PYB%=0
  PYC%=VAL(PA$(3)):PXC%=Tex(CurTexture,TEXSIZEX%)
END SELECT
Face(CurFace,TXI%)=PXA%
Face(CurFace,TYI%)=PYA%
Face(CurFace,TXF%)=PXB%
Face(CurFace,TYF%)=PYB%
Face(CurFace,TXM%)=PXC%
Face(CurFace,TYM%)=PYC%
RETURN

CenterOn:
CP=VAL(PA$(1))
IF Dot(CP,USED%)<>0
 XP=Dot(CP,DOTX%)
 YP=Dot(CP,DOTY%)
 ZP=Dot(CP,DOTZ%)
 GOSUB Offsettize
END IF 
GOSUB Refresh
RETURN

Offset:
XP=VAL(PA$(1))
YP=VAL(PA$(2))
ZP=VAL(PA$(3))
Offsettize:
FOR i=1 TO NDOT
 Dot(i,DOTX%)=Dot(i,DOTX%)-XP
 Dot(i,DOTY%)=Dot(i,DOTY%)-YP
 Dot(i,DOTZ%)=Dot(i,DOTZ%)-ZP
NEXT i
ObjRef(REF_X%+REF_O%)=ObjRef(REF_X%+REF_O%)-XP
ObjRef(REF_Y%+REF_O%)=ObjRef(REF_Y%+REF_O%)-YP
ObjRef(REF_Z%+REF_O%)=ObjRef(REF_Z%+REF_O%)-ZP
RETURN

Flip:
PA$(1)=UCASE$(PA$(1))
IF Contain("X",PA$(1)) THEN MX=-1 ELSE MX=1
IF Contain("Y",PA$(1)) THEN MY=-1 ELSE MY=1
IF Contain("Z",PA$(1)) THEN MZ=-1 ELSE MZ=1
FOR i=1 TO NDOT
 Dot(i,DOTX%)=Dot(i,DOTX%)*MX
 Dot(i,DOTY%)=Dot(i,DOTY%)*MY
 Dot(i,DOTZ%)=Dot(i,DOTZ%)*MZ
NEXT i
GOTO Refresh

Exg:
PA$(1)=UCASE$(PA$(1))
IF Contain("XY",PA$(1)) 
 FOR i=1 TO NDOT
  d=Dot(i,DOTX%)
  Dot(i,DOTX%)=Dot(i,DOTY%)
  Dot(i,DOTY%)=d
 NEXT i
END IF
IF Contain("XZ",PA$(1)) 
 FOR i=1 TO NDOT
  d=Dot(i,DOTX%)
  Dot(i,DOTX%)=Dot(i,DOTZ%)
  Dot(i,DOTZ%)=d
 NEXT i
END IF
IF Contain("ZY",PA$(1)) 
 FOR i=1 TO NDOT
  d=Dot(i,DOTZ%)
  Dot(i,DOTZ%)=Dot(i,DOTY%)
  Dot(i,DOTY%)=d
 NEXT i
END IF
GOTO Refresh

Norm:
REPEAT cyc
WINDOW OUTPUT 2
a$=UCASE$(WAITKEY$)
SELECT CASE a$
 CASE CHR$(13)
  EXIT cyc
 CASE "X"
  d=Face(CurFace,FACPA%)
  Face(CurFace,FACPA%)=Face(CurFace,FACPB%)
  Face(CurFace,FACPB%)=d
END SELECT
GOSUB NextFace
GOSUB Refresh
END REPEAT cyc
RETURN

Refresh:
CALL METAViewTD
WINDOW OUTPUT 1
COLOR 1,0:CLS
CALL METARedrawTD(1,1,WINDOW(2),WINDOW(3),viewmode&)
RETURN

SelFace:
IF PA$(1)<>""
 FOR i=1 TO LEN(PA$(1))
  c$=MID$(PA$(1),i,1)
  IF c$="+" THEN GOSUB NextFace
  IF c$="-" THEN GOSUB PrecFace
 NEXT i
 GOSUB Refresh
 RETURN
END IF
REPEAT cyc
WINDOW OUTPUT 2
a$=UCASE$(WAITKEY$)
SELECT CASE a$
 CASE CHR$(13)
  EXIT cyc
 CASE "+"
  GOSUB NextFace
 CASE "-"
  GOSUB PrecFace
END SELECT
GOSUB Refresh
END REPEAT cyc
RETURN

NextFace:
  CurFace=CurFace+1
  IF CurFace>NFAC THEN CurFace=1
  RETURN
PrecFace:
  CurFace=CurFace-1
  IF CurFace<1 THEN CurFace=NFAC
  RETURN

Mover:
ST=100
STA=5*(3.1415926/180)
REPEAT cyc
WINDOW OUTPUT 2
a$=UCASE$(WAITKEY$)
SELECT CASE a$
 CASE CHR$(13)
  EXIT cyc
 CASE "["
  ObjRef(REF_O%+REF_X%)=ObjRef(REF_O%+REF_X%)-ST
 CASE "]"
  ObjRef(REF_O%+REF_X%)=ObjRef(REF_O%+REF_X%)+ST
 CASE "-"
  ObjRef(REF_O%+REF_Y%)=ObjRef(REF_O%+REF_Y%)-ST
 CASE "+"
  ObjRef(REF_O%+REF_Y%)=ObjRef(REF_O%+REF_Y%)+ST
 CASE "*"
  ObjRef(REF_O%+REF_Z%)=ObjRef(REF_O%+REF_Z%)+ST
 CASE "9"
  ObjRef(REF_O%+REF_Z%)=ObjRef(REF_O%+REF_Z%)-ST
 CASE "2"
  CALL RotRef(STA,REF_J%,REF_K%)
 CASE "8"
  CALL RotRef(-STA,REF_J%,REF_K%)
 CASE "6"
  CALL RotRef(STA,REF_I%,REF_K%)
 CASE "4"
  CALL RotRef(-STA,REF_I%,REF_K%)
 CASE "5"
  CALL RotRef(STA,REF_I%,REF_J%)
END SELECT
GOSUB Refresh
END REPEAT cyc
RETURN

Help:
C$=UCASE$(PA$(1))
SELECT CASE C$
 CASE ELSE
  PRINT "? [COMMAND] :Help of COMMAND or this summary"
  PRINT "            :of commands without explanations."
  PRINT "?,X"
  PRINT "MOVER,SELF,FLIP,NORM,CENTON,TEXPB"
  PRINT "TEXLOAD,TEXSHOW,OFFS,TEXPI,CURTEX"
END SELECT
RETURN 

DATA 0,0,500
DATA 1,0,0
DATA 0,1,0
DATA 0,0,1