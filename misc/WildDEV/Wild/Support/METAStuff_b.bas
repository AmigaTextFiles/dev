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
 SHARED hx,hy
 xos=ProX(x,z)+hx
 yos=ProY(y,z)+hy
 ros=ABS((ABS(r)*256)/(z+256))
 PRINT "ros ",ros,xos,yos
 CIRCLE (xos,yos),ros,3,,,1
END SUB

' Condizioni per ogni sfera:
' essere tangente a tre facce almeno, che determinano quasi tutto.
' poi, trovate le coordinate del centro in funzione del raggio, provare con tutte
' le altre facce il raggio massimo.
' Trovo centro (px,py,pz) in funzione del raggio:
' sistema 4x3:
' ax*px+ay*py+az*pz=r*|a| (a è la normale della face!)
' idem per b e c.
' L'equazione deriva dalla formula per la distanza face-point: d=ProdScal/|normale|
' guarda anche la procedura METADistanceFacePoint
' Risolvo il sistema, lasciando r come parametro.
' Matrice: 	| ax ay az |	| r*|a| |
'		| bx by bz |	| r*|b| |
'		| cx cy cz |    | r*|c| |
' MA ! ERRORE !
' px,py,pz erano relativi al punto c di ogni face!
' cx,cy,cz sono gli assoluti: cx=px-xc(face)
' L'equazione diventa:
' ax*cx+ay*cy+az*cz=r*|a|+xc*ax+yc*ay+zc*az
' NEW: r*|a| = r !  |a| ora è 1 (normalizzati i vettori normali)

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
  czb=Dot(Face(fc,FACPB%),DOTZ%)-czcy
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
  

' la matrice:
' | ax ay az | | ma |
' | bx by bz | | mb |
' | cx cy cz | | mc |

  ma=axc*kax+ayc*kay+azc*kaz		' OKVERIFIED
  mb=bxc*kbx+byc*kby+bzc*kbz		' OKPROBABLY
  mc=cxc*kcx+cycy*kcy+czc*kcz		' OKPROBABLY
  PRINT "ma,mb,mc ",ma,mb,mc
  det=kax*kby*kcz+kay*kbz*kcx+kaz*kbx*kcy-kaz*kby*kcx-kay*kbx*kcz-kax*kbz*kcy	'OKMIFIDO
  PRINT "det ",det

' ora:
' cx=		| r|a|+ma ay az|
'		| r|b|+mb by bz|
'		| r|c|+mc cy cz|/det

  mako=kby*kcz-kbz*kcy
  mbko=kcy*kaz-kay*kcz
  mcko=kay*kbz-kaz*kby
  PRINT "mxko a,b,c ",mako,mbko,mcko
  cxtn=mako*ma+mbko*mb+mcko*mc	' termine noto nell'equazione: cx=(cxtn+r*rcxko)/det
  rcxko=mako+mbko+mcko		' coefficiente del raggio nell'eq sopra.

  mako=kbx*kcz-kbz*kcx
  mbko=kcx*kaz-kax*kcz
  mcko=kax*kbz-kaz*kbx
  PRINT "myko a,b,c ",mako,mbko,mcko
  cytn=-(mako*ma+mbko*mb+mcko*mc)	' termine noto nell'equazione: cy=(cytn+r*rcyko)/det
  rcyko=-(mako+mbko+mcko)		' coefficiente del raggio nell'eq sopra.
  					' SEGNO - PERCHE è un posto dispari (seconda colonna)
					' + correttamente avrei dovuto cambiare il segno dei mako,mbko,mcko
  mako=kby*kcx-kbx*kcy
  mbko=kcy*kax-kay*kcx
  mcko=kay*kbx-kax*kby
  PRINT "mzko a,b,c ",mako,mbko,mcko
  cztn=mako*ma+mbko*mb+mcko*mc	' termine noto nell'equazione: cz=(cztn+r*rczko)/det
  rczko=mako+mbko+mcko		' coefficiente del raggio nell'eq sopra.
  
  ' SEMBRA TUTTO OK FIN QUI !! 

  PRINT "ctn x,y,z ",cxtn,cytn,cztn
  PRINT "rko x,y,z ",rcxko,rcyko,rczko
' ora:
' cx=(cxtn+r*rcxko)/det
' cy=(cytn+r*rcyko)/det  
' cz=(cztn+r*rczko)/det  
' kfx*cx+kfy*cy+kfz*cz>r*|kf|	per testare le altre facce e trovare il >r possibile.
' quindi:
' kfx*cxtn/det+kfy*cytn/det+kfz*cztn/det>r*(|kf|-rcxko/det-rcyko/det-rczko/det)
' MA! NO!
' cx assoluti, ma devo relativizzarli! (come ho fatto prima con i ma,mb,mc)
' la disequazione di prima (2 sopra) diventa:
' kfx*(cx-fxc)+kfy*(cy-fyc)+kfz*(cz-fzc)>r*|kf|
' quindi:
' kfx*(cxtn/det+r*rcxko/det-fxc) ...
  kfxko=cxtn/det
  kfyko=cytn/det
  kfzko=cztn/det
  rkotn=-(rcxko+rcyko+rczko)/det
  PRINT "kfko x,y,z,r",kfxko,kfyko,kfzko,rkotn
' kfx*(kfxko-fxc)+...>r*(|kf|+rkotn)
' ftn>r*frko	

  rmin=BigSR
'  FOR j=1 TO NFAC
'   IF j<>fa AND j<>fb AND j<>fc
'    fxc=Dot(Face(j,FACPC%),DOTX%)
'    fyc=Dot(Face(j,FACPC%),DOTY%)
'    fzc=Dot(Face(j,FACPC%),DOTZ%)
'    fxa=Dot(Face(j,FACPA%),DOTX%)-fxc
'    fya=Dot(Face(j,FACPA%),DOTY%)-fyc
'    fza=Dot(Face(j,FACPA%),DOTZ%)-fzc
'    fxb=Dot(Face(j,FACPB%),DOTX%)-fxc
'    fyb=Dot(Face(j,FACPB%),DOTY%)-fyc
'    fzb=Dot(Face(j,FACPB%),DOTZ%)-fzc
'    kfx=fzb*fya-fza*cyb
'    kfy=fza*fxb-fzb*cxa
'    kfz=fxa*fyb-fya*cxb
'    lkf=(kfx^2+kfy^2+kfz^2)^.5
'    frko=(lkf+rkotn)
'''    IF frko<=0 THEN PRINT "ERROR!",frko,lkf,rkotn
'    ftn=kfx*(kfxko-fxc)+kfy*(kfyko-fyc)+kfz*(kfzko-fzc)
'    rminf=ftn/frko
'    cxf=(cxtn+rminf*rcxko)/det
'    cyf=(cytn+rminf*rcyko)/det
'    czf=(cztn+rminf*rczko)/det
'    PRINT "frko,ftn",frko,ftn
'    PRINT rmin,cxf,cyf,czf,cxtn,cytn,cztn
'   END IF  
'   IF rminf<rmin THEN rmin=rminf
'  NEXT j
 END IF 
 r=20
 cxf=(cxtn+r*rcxko)/det
 cyf=(cytn+r*rcyko)/det
 czf=(cztn+r*rczko)/det
 PRINT "x,y,z",cxf,cyf,czf
 CALL SphereDraw(cxf,cyf,czf,r)
 
 PRINT "dfa ",METADistancePointFace(fa,cxf,cyf,czf)
 PRINT "dfb ",METADistancePointFace(fb,cxf,cyf,czf)
 PRINT "dfc ",METADistancePointFace(fc,cxf,cyf,czf)
'NEXT i

 


  

