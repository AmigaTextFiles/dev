/* -------------------------------------------
   file:    view3d.e
   by:      Sean Harbour Copyright (C) 1994
   Compile: EC view3d.e

   MODULE:  view3d.m

   A collection of procedures to enable the
   viewing of 3d objects.

   Data Structure for net3d:

   pts:=[[x1,y1,z1]:point,
         [x2,y2,z2]:point,
             ...
         [xn,yn,zn]:point]

   faces:=[[p11,p12,...],
           [p21,p22,...],
                ...
           [pn1,pn2,...]

   normals:=[[x1,y1,z1]:point,
             [x2,y2,z2]:point,
                 ...
             [xn,yn,zn]:point]

------------------------------------------- */

OPT MODULE

EXPORT OBJECT point
  x,y,z
ENDOBJECT

-> display a 2d representation of a set of 3d points

EXPORT PROC point3d(pts:PTR TO LONG,rast,colour=1)
  DEF coord:PTR TO point,i,npts,x,y

  SetAPen(rast,colour)

  npts:=ListLen(pts)
  FOR i:=0 TO (npts-1)
    coord:=pts[i]
    x,y:=trans3d(coord.x,coord.y,coord.z)
    RectFill(rast,x-1,y-1,x+1,y+1)
  ENDFOR

ENDPROC

-> display a 2d representation of a 3d closed loop

EXPORT PROC polygon3d(pts:PTR TO LONG,rast,colour=1)
  DEF coord:PTR TO point,i,npts,x,y

  SetAPen(rast,colour)

  npts:=ListLen(pts)
  coord:=pts[0]
  x,y:=trans3d(coord.x,coord.y,coord.z)
  Move(rast,x,y)
  FOR i:=1 TO (npts-1)
    coord:=pts[i]
    x,y:=trans3d(coord.x,coord.y,coord.z)
    Draw(rast,x,y)
  ENDFOR
  coord:=pts[0]
  x,y:=trans3d(coord.x,coord.y,coord.z)
  Draw(rast,x,y)

ENDPROC

-> display a 2d representation of a 3d net of patches

EXPORT CONST MAXPTS=20             /* default maximum number of points allowed */
EXPORT CONST MAXFACES=40           /* default maximum number of faces  allowed */

EXPORT PROC net3d(pts:PTR TO LONG,faces:PTR TO LONG,normals:PTR TO LONG,rast)
  DEF i,j,k,npts,nfaces,nvertices,x,xpt[MAXPTS]:ARRAY,y,ypt[MAXPTS]:ARRAY,z,zpt[MAXPTS]:ARRAY
  DEF index:PTR TO LONG,coord:PTR TO point,tmp,sort[MAXFACES]:ARRAY,on[MAXPTS]:ARRAY
  DEF active,depth[MAXFACES]:ARRAY,sum,tst

  npts:=ListLen(pts)-1
  nfaces:=ListLen(faces)-1

-> rotate vertices

  FOR i:=0 TO npts
    coord:=pts[i]
    x,y,z:=trans3d(coord.x,coord.y,coord.z)
    xpt[i]:=x
    ypt[i]:=y
    zpt[i]:=z
  ENDFOR

-> rotate normals to faces

-> 3d coordinate transformation to determine visibility [0=No,1=Yes]

  FOR i:=0 TO nfaces
    coord:=normals[i]
    x:=coord.x
    y:=coord.y
    z:=coord.z

        LEA     c1(PC),A0

        MOVE.L  x,D0
        MOVE.L  y,D1
        MOVE.L  z,D2

        MOVE.W  00(A0),D3          /* D3 = (2^8)*cos(phi) */
        MOVE.W  02(A0),D4          /* D4 = (2^8)*sin(phi) */

/* A1=y*cos(phi)-z*sin(phi) */

        MOVE    D1,D6
        MULS    D3,D6
        MOVE    D2,D7
        MULS    D4,D7
        SUB.L   D7,D6
        ASR.L   #8,D6
        MOVE    D6,A1

/* A3=y*sin(phi)+z*cos(phi) */

        MOVE    D1,D6
        MULS    D4,D6
        MOVE    D2,D7
        MULS    D3,D7
        ADD.L   D7,D6
        ASR.L   #8,D6
        MOVE    D6,A3

        MOVE.W  04(A0),D3          /* D3 = (2^8)*cos(theta) */
        MOVE.W  06(A0),D4          /* D4 = (2^8)*sin(theta) */

/* A2=x*cos(theta)-A3*sin(theta) */

        MOVE    D0,D6
        MULS    D3,D6
        MOVE    A3,D7
        MULS    D4,D7
        SUB.L   D7,D6
        ASR.L   #8,D6
        MOVE    D6,A2

/* D3=x*sin(theta)+A3*cos(theta) */

        MOVE    D0,D6
        MULS    D4,D6
        MOVE    A3,D7
        MULS    D3,D7
        ADD.L   D7,D6
        ASR.L   #8,D6
        MOVE    D6,D2

-> determine visibility [0=No,1=Yes]

        MOVEQ.L #0,D1
        CMP     #0,D2
        BGT     visible
        MOVEQ.L #1,D1
visible:
        MOVE.L  D1,tmp

        on[i]:=tmp
  ENDFOR

-> sort faces according to depth

  active:=0
  i:=0
  WHILE (active < nfaces) AND (i < nfaces)
    WHILE on[i]=0
        INC  i
    ENDWHILE
    sort[active]:=i
        INC  active
        INC  i
  ENDWHILE

  FOR i:=0 TO (active-1)
    index:=faces[sort[i]]
    nvertices:=ListLen(index)
    sum:=0
    FOR j:=0 TO (nvertices-1)
      k:=index[j]
      sum:=sum+zpt[k]
    ENDFOR
    depth[i]:=sum/nvertices
  ENDFOR

-> bubble sort entries of depth

  tst:=0
  WHILE tst=0
    tst:=1
    FOR i:=0 TO (active-2)
      IF depth[sort[i]] > depth[sort[i+1]]
        tmp:=sort[i]
        sort[i]:=sort[i+1]
        sort[i+1]:=tmp
        tst:=0
      ENDIF
    ENDFOR
  ENDWHILE

-> display 3d patches

  FOR i:=0 TO (active-1)
    index:=faces[sort[i]]
    nvertices:=ListLen(index)

    k:=index[0]
    x:=xpt[k]
    y:=ypt[k]
    AreaMove(rast,x,y)
    FOR j:=1 TO (nvertices-1)
      k:=index[j]
      x:=xpt[k]
      y:=ypt[k]
      AreaDraw(rast,x,y)
    ENDFOR
    AreaEnd(rast)
  ENDFOR

ENDPROC

EXPORT PROC setpers3d(irho=1000,idistance=400)
/* for average size, rho:distance = 5:2 */
        LEA     rho(PC),A0
        MOVE.W  irho.W,0(A0)
        MOVE.W  idistance.W,2(A0)
ENDPROC

EXPORT PROC setorigin3d(x=180,y=128)
        LEA     xcentre(PC),A0
        MOVE.W  x.W,00(A0)
        MOVE.W  y.W,02(A0)
ENDPROC

-> init3d: Specify orientation of 3d polygon

-> phi   = angle of rotation about x-axis
-> theta = angle of rotation about y-axis
-> psi   = angle of rotation about z-axis

EXPORT PROC init3d(phi=0,theta=0,psi=0)
        LEA     sine(PC),A0        /* uses A0,A1,D0 */
        LEA     c1(PC),A1

        MOVE.W  phi.W,D0
        LSL.W   #1,D0
        MOVE.W  0(A0,D0.W),02(A1)  /* s1 = (2^8)*sin(phi)   */
        ADD.W   #180,D0
        MOVE.W  0(A0,D0.W),00(A1)  /* c1 = (2^8)*cos(phi)   */

        MOVE.W  theta.W,D0
        LSL.W   #1,D0
        MOVE.W  0(A0,D0.W),06(A1)  /* s2 = (2^8)*sin(theta) */
        ADD.W   #180,D0
        MOVE.W  0(A0,D0.W),04(A1)  /* c2 = (2^8)*cos(theta) */

        MOVE.W  psi.W,D0
        LSL.W   #1,D0
        MOVE.W  0(A0,D0.W),10(A1)  /* s3 = (2^8)*sin(psi)   */
        ADD.W   #180,D0
        MOVE.W  0(A0,D0.W),08(A1)  /* c3 = (2^8)*cos(psi)   */
ENDPROC

-> 3d to 2d coordinate transformation

EXPORT PROC trans3d(x,y,z)
        LEA     c1(PC),A0

        MOVE.L  x,D0
        MOVE.L  y,D1
        MOVE.L  z,D2

        MOVE.W  00(A0),D3          /* D3 = (2^8)*cos(phi) */
        MOVE.W  02(A0),D4          /* D4 = (2^8)*sin(phi) */

/* A1=y*cos(phi)-z*sin(phi) */

        MOVE    D1,D6
        MULS    D3,D6
        MOVE    D2,D7
        MULS    D4,D7
        SUB.L   D7,D6
        ASR.L   #8,D6
        MOVE    D6,A1

/* A3=y*sin(phi)+z*cos(phi) */

        MOVE    D1,D6
        MULS    D4,D6
        MOVE    D2,D7
        MULS    D3,D7
        ADD.L   D7,D6
        ASR.L   #8,D6
        MOVE    D6,A3

        MOVE.W  04(A0),D3          /* D3 = (2^8)*cos(theta) */
        MOVE.W  06(A0),D4          /* D4 = (2^8)*sin(theta) */

/* A2=x*cos(theta)-A3*sin(theta) */

        MOVE    D0,D6
        MULS    D3,D6
        MOVE    A3,D7
        MULS    D4,D7
        SUB.L   D7,D6
        ASR.L   #8,D6
        MOVE    D6,A2

/* D2=x*sin(theta)+A3*cos(theta) */

        MOVE    D0,D6
        MULS    D4,D6
        MOVE    A3,D7
        MULS    D3,D7
        ADD.L   D7,D6
        ASR.L   #8,D6
        ADD.W   rho(PC),D6         /* z=z+Pz */
        MOVE    D6,D2

        MOVE.W  08(A0),D3          /* D3 = (2^8)*cos(psi) */
        MOVE.W  10(A0),D4          /* D4 = (2^8)*sin(psi) */

/* D0=A2*cos(psi)-A1*sin(psi) */

        MOVE    A2,D6
        MULS    D3,D6
        MOVE    A1,D7
        MULS    D4,D7
        SUB.L   D7,D6
        ASR.L   #8,D6
        MOVE    D6,D0

/* D1=A2*sin(psi)+A1*cos(psi) */

        MOVE    A2,D6
        MULS    D4,D6
        MOVE    A1,D7
        MULS    D3,D7
        ADD.L   D7,D6
        ASR.L   #8,D6
        MOVE    D6,D1

/* Apply perspective projection */

        MULS    distance(PC),D0
        DIVS    D2,D0

        ADD.W   xcentre(PC),D0     /* xpt = distance*(x/z)+xcentre */

        MULS    distance(PC),D1
        DIVS    D2,D1

        ADD.W   ycentre(PC),D1     /* ypt = distance*(y/z)+ycentre */

        EXT.L   D0
        EXT.L   D1
        EXT.L   D2

ENDPROC D0

/* END OF OBJECT */

c1:       INT         0
/* s1: */ INT         0
/* c2: */ INT         0
/* s2: */ INT         0
/* c3: */ INT         0
/* s3: */ INT         0

rho:      INT      2000
distance: INT       800

xcentre:  INT       160
ycentre:  INT       128

sine:     INT     $0000,$0004,$0008,$000D,$0011,$0016,$001A,$001F
          INT     $0023,$0027,$002C,$0030,$0035,$0039,$003D,$0041
          INT     $0046,$004A,$004E,$0053,$0057,$005B,$005F,$0063
          INT     $0067,$006B,$006F,$0073,$0077,$007B,$007F,$0083
          INT     $0087,$008A,$008E,$0092,$0095,$0099,$009C,$00A0
          INT     $00A3,$00A7,$00AA,$00AD,$00B1,$00B4,$00B7,$00BA
          INT     $00BD,$00C0,$00C3,$00C6,$00C8,$00CB,$00CE,$00D0
          INT     $00D3,$00D5,$00D8,$00DA,$00DC,$00DF,$00E1,$00E3
          INT     $00E5,$00E7,$00E8,$00EA,$00EC,$00EE,$00EF,$00F1
          INT     $00F2,$00F3,$00F5,$00F6,$00F7,$00F8,$00F9,$00FA
          INT     $00FB,$00FB,$00FC,$00FD,$00FD,$00FE,$00FE,$00FE
          INT     $00FE,$00FE,$00FF,$00FE,$00FE,$00FE,$00FE,$00FE
          INT     $00FD,$00FD,$00FC,$00FB,$00FB,$00FA,$00F9,$00F8
          INT     $00F7,$00F6,$00F5,$00F3,$00F2,$00F1,$00EF,$00EE
          INT     $00EC,$00EA,$00E8,$00E7,$00E5,$00E3,$00E1,$00DF
          INT     $00DC,$00DA,$00D8,$00D5,$00D3,$00D0,$00CE,$00CB
          INT     $00C8,$00C6,$00C3,$00C0,$00BD,$00BA,$00B7,$00B4
          INT     $00B1,$00AD,$00AA,$00A7,$00A3,$00A0,$009C,$0099
          INT     $0095,$0092,$008E,$008A,$0087,$0083,$007F,$007B
          INT     $0077,$0073,$006F,$006B,$0067,$0063,$005F,$005B
          INT     $0057,$0053,$004E,$004A,$0046,$0041,$003D,$0039
          INT     $0035,$0030,$002C,$0027,$0023,$001F,$001A,$0016
          INT     $0011,$000D,$0008,$0004,$0000,$FFFC,$FFF8,$FFF3
          INT     $FFEF,$FFEA,$FFE6,$FFE1,$FFDD,$FFD9,$FFD4,$FFD0
          INT     $FFCB,$FFC7,$FFC3,$FFBF,$FFBA,$FFB6,$FFB2,$FFAD
          INT     $FFA9,$FFA5,$FFA1,$FF9D,$FF99,$FF95,$FF91,$FF8D
          INT     $FF89,$FF85,$FF81,$FF7D,$FF79,$FF76,$FF72,$FF6E
          INT     $FF6B,$FF67,$FF64,$FF60,$FF5D,$FF59,$FF56,$FF53
          INT     $FF4F,$FF4C,$FF49,$FF46,$FF43,$FF40,$FF3D,$FF3A
          INT     $FF38,$FF35,$FF32,$FF30,$FF2D,$FF2B,$FF28,$FF26
          INT     $FF24,$FF21,$FF1F,$FF1D,$FF1B,$FF19,$FF18,$FF16
          INT     $FF14,$FF12,$FF11,$FF0F,$FF0E,$FF0D,$FF0B,$FF0A
          INT     $FF09,$FF08,$FF07,$FF06,$FF05,$FF05,$FF04,$FF03
          INT     $FF03,$FF02,$FF02,$FF02,$FF02,$FF02,$FF01,$FF02
          INT     $FF02,$FF02,$FF02,$FF02,$FF03,$FF03,$FF04,$FF05
          INT     $FF05,$FF06,$FF07,$FF08,$FF09,$FF0A,$FF0B,$FF0D
          INT     $FF0E,$FF0F,$FF11,$FF12,$FF14,$FF16,$FF18,$FF19
          INT     $FF1B,$FF1D,$FF1F,$FF21,$FF24,$FF26,$FF28,$FF2B
          INT     $FF2D,$FF30,$FF32,$FF35,$FF38,$FF3A,$FF3D,$FF40
          INT     $FF43,$FF46,$FF49,$FF4C,$FF4F,$FF53,$FF56,$FF59
          INT     $FF5D,$FF60,$FF64,$FF67,$FF6B,$FF6E,$FF72,$FF76
          INT     $FF79,$FF7D,$FF81,$FF85,$FF89,$FF8D,$FF91,$FF95
          INT     $FF99,$FF9D,$FFA1,$FFA5,$FFA9,$FFAD,$FFB2,$FFB6
          INT     $FFBA,$FFBE,$FFC3,$FFC7,$FFCB,$FFD0,$FFD4,$FFD9
          INT     $FFDD,$FFE1,$FFE6,$FFEA,$FFEF,$FFF3,$FFF8,$FFFC
          INT     $0000,$0004,$0008,$000D,$0011,$0016,$001A,$001F
          INT     $0023,$0027,$002C,$0030,$0035,$0039,$003D,$0041
          INT     $0046,$004A,$004E,$0053,$0057,$005B,$005F,$0063
          INT     $0067,$006B,$006F,$0073,$0077,$007B,$007F,$0083
          INT     $0087,$008A,$008E,$0092,$0095,$0099,$009C,$00A0
          INT     $00A3,$00A7,$00AA,$00AD,$00B1,$00B4,$00B7,$00BA
          INT     $00BD,$00C0,$00C3,$00C6,$00C8,$00CB,$00CE,$00D0
          INT     $00D3,$00D5,$00D8,$00DA,$00DC,$00DF,$00E1,$00E3
          INT     $00E5,$00E7,$00E8,$00EA,$00EC,$00EE,$00EF,$00F1
          INT     $00F2,$00F3,$00F5,$00F6,$00F7,$00F8,$00F9,$00FA
          INT     $00FB,$00FB,$00FC,$00FD,$00FD,$00FE,$00FE,$00FE
          INT     $00FE,$00FE
