SCREEN 1,720,455,2,5
WINDOW 1,"METAStuffing ...",(0,0)-(640,400),,1

'$INCLUDE BASU:_METAConsts.bas
'$INCLUDE BASU:_CutWord.bas
'$INCLUDE BASU:_LoadMETA.bas
'$INCLUDE BASU:_Prox.bas
'$INCLUDE BASU:_SafeLine.bas
'$INCLUDE BASU:_METAViewTD.bas
'$INCLUDE BASU:_WAITKEY.bas

CONST STUCX%=1
CONST STUCY%=2
CONST STUCZ%=3
CONST STUR%=4
CONST STUFACS%=10
CONST STUMAX%=30

METAIN$="EscapeLevels:META/Tree.META"
LoadMETA(METAIN$)
WILDOUT$="Ram:Stuff.s"
FOR i=1 TO 12
 READ ObjRef(i)
NEXT i
viewmode&=VIEWMODE_WIRE&+VIEWFLAG_SELSHOW&
CurFace=1

ST=100
REPEAT cyc
a$=UCASE$(WAITKEY$)
SELECT CASE a$
 CASE "X"
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
GOSUB stuffing
END
Refresh:
CALL METAViewTD
CLS
CALL METARedrawTD(1,1,WINDOW(2),WINDOW(3),viewmode&)
RETURN


DATA 0,0,1000
DATA 1,0,0
DATA 0,1,0
DATA 0,0,1

Stuffing:
DIM Stuff(500,STUMAX%),Usf(10)

MAXD&=0:BESTA=0:BESTB=0
FOR i=1 TO NDOT-1
 FOR j=i+1 TO NDOT
  D&=(Dot(i,DOTX%)-Dot(j,DOTX%))^2+(Dot(i,DOTY%)-Dot(j,DOTY%))^2+(Dot(i,DOTZ%)-Dot(j,DOTZ%))^2
  IF D&>MAXD& THEN MAXD&=D&:BESTA=i:BESTB=j
 NEXT j
NEXT i

BigSCX=(Dot(BESTA,DOTX%)+Dot(BESTB,DOTX%))/2
BigSCY=(Dot(BESTA,DOTY%)+Dot(BESTB,DOTY%))/2
BigSCZ=(Dot(BESTA,DOTZ%)+Dot(BESTB,DOTZ%))/2
BigSR=MAXD&^.5

SUB DrawX(x,y,r,c)
 LINE (x-r,y-r)-(x+r,y+r),c
 LINE (x-r,y+r)-(x+r,y-r),c
END SUB

FUNCTION METADistancePointFace(f,x,y,z)
 SHARED Face(),Dot(),hx,hy
 Cx=Dot(Face(f,FACPC%),DOTX%)
 Cy=Dot(Face(f,FACPC%),DOTY%)
 Cz=Dot(Face(f,FACPC%),DOTZ%)
 YOSC=Dot(Face(f,FACPC%),DOTYOS%)
 XOSC=Dot(Face(f,FACPC%),DOTXOS%)
 CALL DrawX(XOSC+hx,YOSC+hy,5,3)
 Ax=Dot(Face(f,FACPA%),DOTX%)-Cx
 Ay=Dot(Face(f,FACPA%),DOTY%)-Cy
 Az=Dot(Face(f,FACPA%),DOTZ%)-Cz
 Bx=Dot(Face(f,FACPB%),DOTX%)-Cx
 By=Dot(Face(f,FACPB%),DOTY%)-Cy
 Bz=Dot(Face(f,FACPB%),DOTZ%)-Cz
 xr=x-Cx
 yr=y-Cy
 zr=z-Cz
 Ik=Bz*Ay-Az*By
 Jk=Az*Bx-Bz*Ax
 Kk=By*Ax-Bx*Ay
 Lk=(Ik^2+Jk^2+Kk^2)^.5
 PS=Ik*xr+Jk*yr+Kk*zr
 d=PS/Lk
 METADistancePointFace=d
END FUNCTION

SUB SphereDraw(x,y,z,r)
 SHARED hx,hy,ObjRef()
 mx=x*ObjRef(REF_I%+REF_X%)+y*ObjRef(REF_J%+REF_X%)+z*ObjRef(REF_K%+REF_X%)+ObjRef(REF_O%+REF_X%)
 my=x*ObjRef(REF_I%+REF_Y%)+y*ObjRef(REF_J%+REF_Y%)+z*ObjRef(REF_K%+REF_Y%)+ObjRef(REF_O%+REF_Y%)
 mz=x*ObjRef(REF_I%+REF_Z%)+y*ObjRef(REF_J%+REF_Z%)+z*ObjRef(REF_K%+REF_Z%)+ObjRef(REF_O%+REF_Z%)
 xos=ProX(mx,mz)+hx
 yos=ProY(my,mz)+hy
 ros=ABS((ABS(r)*256)/(mz+256))
' PRINT "ros ",ros,xos,yos
 CIRCLE (xos,yos),ros,3,,,1
END SUB

' Condizioni per ogni sfera:
' essere tangente a tre facce almeno, che determinano quasi tutto.
' poi, trovate le coordinate del centro in funzione del raggio, provare con tutte
' le altre facce il raggio massimo.
' novo metodo, più lento probabilmente ma chi se ne frega. 
' E' lo stesso, solo che faccio un sistema 4x4 per ogni 4 facce, di cui 3 sono
' le tangenti fisse, la quarta è un ciclo, per trovare il raggio maggiore possibile.
'
' kax*(cx-oax)+kay*(cy-oay)+kaz*(cz-oaz)=r
' quindi
' kax*cx+kay*cy+kaz*cz-r=oax*kax+oay*kay+oaz*kaz !!! (bene! è costante !)
' matrice:
' |kax kay kaz -1| 	|ma| 	(ma=oax*kax+oay*...)
' |kbx kby kbz -1| 	|mb|
' |kcx kcy kcz -1| 	|mc|
' |kfx kfy kfz -1| 	|mf|	(f=faccia ciclata)

COLOR 1,0
NSTU=0
MINR=20
'FOR i=1 TO NDOT
 GOSUB Refresh
 NUSF=0
 FOR j=1 TO NFAC
  IF Face(j,FACPA%)=i OR Face(j,FACPB%)=i OR Face(j,FACPC%)=i THEN NUSF=NUSF+1:Usf(NUSF)=j
 NEXT j
 IF NUSF>=3
  fa=Usf(1)
  fb=Usf(2)
  fc=Usf(3)

  PRINT "Faces: ",fa;fb;fc
  
  axc=Dot(Face(fa,FACPC%),DOTX%)
  ayc=Dot(Face(fa,FACPC%),DOTY%)
  azc=Dot(Face(fa,FACPC%),DOTZ%)
  axa=Dot(Face(fa,FACPA%),DOTX%)-axc
  aya=Dot(Face(fa,FACPA%),DOTY%)-ayc
  aza=Dot(Face(fa,FACPA%),DOTZ%)-azc
  axb=Dot(Face(fa,FACPB%),DOTX%)-axc
  ayb=Dot(Face(fa,FACPB%),DOTY%)-ayc
  azb=Dot(Face(fa,FACPB%),DOTZ%)-azc
  kax=azb*aya-aza*ayb
  kay=aza*axb-azb*axa
  kaz=axa*ayb-aya*axb
  lka=(kax^2+kay^2+kaz^2)^.5
  kax=kax/lka
  kay=kay/lka
  kaz=kaz/lka
  bxc=Dot(Face(fb,FACPC%),DOTX%)
  byc=Dot(Face(fb,FACPC%),DOTY%)
  bzc=Dot(Face(fb,FACPC%),DOTZ%)
  bxa=Dot(Face(fb,FACPA%),DOTX%)-bxc
  bya=Dot(Face(fb,FACPA%),DOTY%)-byc
  bza=Dot(Face(fb,FACPA%),DOTZ%)-bzc
  bxb=Dot(Face(fb,FACPB%),DOTX%)-bxc
  byb=Dot(Face(fb,FACPB%),DOTY%)-byc
  bzb=Dot(Face(fb,FACPB%),DOTZ%)-bzc
  kbx=bzb*bya-bza*byb
  kby=bza*bxb-bzb*bxa
  kbz=bxa*byb-bya*bxb
  lkb=(kbx^2+kby^2+kbz^2)^.5
  kbx=kbx/lkb
  kby=kby/lkb
  kbz=kbz/lkb
  cxc=Dot(Face(fc,FACPC%),DOTX%)
  cycy=Dot(Face(fc,FACPC%),DOTY%)
  czc=Dot(Face(fc,FACPC%),DOTZ%)
  cxa=Dot(Face(fc,FACPA%),DOTX%)-cxc
  cya=Dot(Face(fc,FACPA%),DOTY%)-cycy
  cza=Dot(Face(fc,FACPA%),DOTZ%)-czc
  cxb=Dot(Face(fc,FACPB%),DOTX%)-cxc
  cyb=Dot(Face(fc,FACPB%),DOTY%)-cycy
  czb=Dot(Face(fc,FACPB%),DOTZ%)-czc
  kcx=czb*cya-cza*cyb
  kcy=cza*cxb-czb*cxa
  kcz=cxa*cyb-cya*cxb
  lkc=(kcx^2+kcy^2+kcz^2)^.5
  kcx=kcx/lkc
  kcy=kcy/lkc
  kcz=kcz/lkc				' fin qui penso sia tutto OK.
  					' coi vettori normalizzati (lk=1) è meglio.
  PRINT "ka ",kax,kay,kaz
  PRINT "kb ",kbx,kby,kbz
  PRINT "kc ",kcx,kcy,kcz

  PRINT "oa ",axc,ayc,azc
  PRINT "ob ",bxc,byc,bzc
  PRINT "oc ",cxc,cycy,czc

  ma=axc*kax+ayc*kay+azc*kaz
  mb=bxc*kbx+byc*kby+bzc*kbz
  mc=cxc*kcx+cycy*kcy+czc*kcz
 
  f=4
  fxc=Dot(Face(f,FACPC%),DOTX%)
  fyc=Dot(Face(f,FACPC%),DOTY%)
  fzc=Dot(Face(f,FACPC%),DOTZ%)
  fxa=Dot(Face(f,FACPA%),DOTX%)-fxc
  fya=Dot(Face(f,FACPA%),DOTY%)-fyc
  fza=Dot(Face(f,FACPA%),DOTZ%)-fzc
  fxb=Dot(Face(f,FACPB%),DOTX%)-fxc
  fyb=Dot(Face(f,FACPB%),DOTY%)-fyc
  fzb=Dot(Face(f,FACPB%),DOTZ%)-fzc
  kfx=fzb*fya-fza*fyb
  kfy=fza*fxb-fzb*fxa
  kfz=fxa*fyb-fya*fxb
  lkf=(kfx^2+kfy^2+kfz^2)^.5
  kfx=kfx/lkf
  kfy=kfy/lkf
  kfz=kfz/lkf
  
  mf=fxc*kfx+fyc*kfy+fzc*kfz

' kax*(cx-oax)+kay*(cy-oay)+kaz*(cz-oaz)=r
' kax*cx+kay*cy+kaz*cz-r=oax*kax+oay*kay+oaz*kaz !!! (bene! è costante !)
' matrice:
' |kax kay kaz -1| 	|ma| 	(ma=oax*kax+oay*...)
' |kbx kby kbz -1| 	|mb|
' |kcx kcy kcz -1| 	|mc|
' |kfx kfy kfz -1| 	|mf|	(f=faccia ciclata)

 det4=-(kax*kby*kcz+kay*kbz*kcx+kaz*kbx*kcy-kaz*kby*kcx-kay*kbx*kcz-kax*kbz*kcy)
 det3=(kax*kby*kfz+kay*kbz*kfx+kaz*kbx*kfy-kaz*kby*kfx-kay*kbx*kfz-kax*kbz*kfy)
 det2=-(kax*kcy*kfz+kay*kcz*kfx+kaz*kcx*kfy-kaz*kcy*kfx-kay*kcx*kfz-kax*kcz*kfy)
 det1=(kbx*kcy*kaz+kby*kcz*kfx+kbz*kcx*kfy-kbz*kcy*kfx-kby*kcx*kfz-kbx*kcz*kfy)
 det=det1+det2+det3+det4
 
 detx4=-(ma*kby*kcz+kay*kbz*mc+kaz*mb*kcy-kaz*kby*mc-kay*mb*kcz-ma*kbz*kcy)
 detx3=(ma*kby*kfz+kay*kbz*mf+kaz*mb*kfy-kaz*kby*mf-kay*mb*kfz-ma*kbz*kfy)
 detx2=-(ma*kcy*kfz+kay*kcz*mf+kaz*mc*kfy-kaz*kcy*mf-kay*mc*kfz-ma*kcz*kfy)
 detx1=(mb*kcy*kaz+kby*kcz*mf+kbz*mc*kfy-kbz*kcy*mf-kby*mc*kfz-mb*kcz*kfy)
 detx=detx1+detx2+detx3+detx4

 dety4=-(kax*mb*kcz+ma*kbz*kcx+kaz*kbx*mc-kaz*mb*kcx-ma*kbx*kcz-kax*kbz*mc)
 dety3=(kax*mb*kfz+ma*kbz*kfx+kaz*kbx*mf-kaz*mb*kfx-ma*kbx*kfz-kax*kbz*mf)
 dety2=-(kax*mc*kfz+ma*kcz*kfx+kaz*kcx*mf-kaz*mc*kfx-ma*kcx*kfz-kax*kcz*mf)
 dety1=(kbx*mc*kaz+mb*kcz*kfx+kbz*kcx*mf-kbz*mc*kfx-mb*kcx*kfz-kbx*kcz*mf)
 dety=dety1+dety2+dety3+dety4
 
 detz4=-(kax*kby*mb+kay*mb*kcx+ma*kbx*kcy-ma*kby*kcx-kay*kbx*mb-kax*mb*kcy)
 detz3=(kax*kby*mf+kay*mb*kfx+ma*kbx*kfy-ma*kby*kfx-kay*kbx*mf-kax*mb*kfy)
 detz2=-(kax*kcy*mf+kay*mb*kfx+ma*kcx*kfy-ma*kcy*kfx-kay*kcx*mf-kax*mb*kfy)
 detz1=(kbx*kcy*ma+kby*mb*kfx+mb*kcx*kfy-mb*kcy*kfx-kby*kcx*mf-kbx*mb*kfy)
 detz=detz1+detz2+detz3+detz4

 detr4=-ma*det4
 detr3=-mb*det3
 detr2=-mc*det2
 detr1=-mf*det1
 detr=detr1+detr2+detr3+detr4

 PRINT "ma,b,c,f",ma,mb,mc,mf
 PRINT "d tot,x,y,z,r",det,detx,dety,detz,detr
 
 cxf=detx/det
 cyf=dety/det
 czf=detz/det
 r=detr/det  
 PRINT "r,x,y,z",r,cxf,cyf,czf
 CALL SphereDraw(cxf,cyf,czf,r)
 
 PRINT "dfa ",METADistancePointFace(fa,cxf,cyf,czf)
 PRINT "dfb ",METADistancePointFace(fb,cxf,cyf,czf)
 PRINT "dfc ",METADistancePointFace(fc,cxf,cyf,czf)
 PRINT "dff ",METADistancePointFace(f,cxf,cyf,czf)
 PRINT "mydfa ",kax*(cxf-axc)+kay*(cyf-ayc)+kaz*(czf-azc)
 END IF
'NEXT i

 


  

