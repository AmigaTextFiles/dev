/* vectordemo in E by $#%! */

CONST R=100,N=1            /* SET N=1..7 (number of shades) */

DEF alt,flag,solid

PROC main()
  DEF  w,phi:PTR TO LONG,theta:PTR TO LONG
  IF w:=OpenW(0,11,200,110,$200,$E,'DvG Equalizer !?',NIL,1,NIL)
    SetRast(stdrast,6)
    RefreshWindowFrame(w)
    phi:=[74,72,70,68,66,64,62,60]
    theta:=[60,68,66,64,62,60,58,56]
    setmiddle3d(100,60)
    setpers3d(750,300)
    solid:=90
    alt:=0
    REPEAT
      drawshape(phi[N],theta[N],6,alt)
      IF (alt>=solid) OR (alt<0) THEN zuf()
      IF flag=TRUE THEN ab()
      IF flag=FALSE THEN auf()
      shiftlist(theta)
      IF Mouse()=1 THEN shiftlist(phi)
      drawshape(phi[N],theta[N],2,alt)
      Delay(1)
    UNTIL GetMsg(Long(w+$56))
    CloseW(w)
  ENDIF
ENDPROC

PROC auf()
    INC alt
    INC alt
ENDPROC

PROC ab()
    DEC alt
    DEC alt
ENDPROC

PROC zuf()
    IF alt<0 THEN solid:=Rnd(90)
    IF flag=FALSE THEN flag:=TRUE ELSE flag:=FALSE
ENDPROC


PROC drawshape(phi,theta,col,alt)
  init3d(phi,theta)
  polygon3d([-100,50,0,
             100,50,0,
             100,-50,0,
             -100,-50,0,
             -100,50,0],col)
  polygon3d([-100,0,0,
             100,0,0],col)
  polygon3d([-55,0,0,
             -55,0,alt+(-30),
             -25,0,alt+(-10),
             -25,0,0],col)
  polygon3d([-15,0,0,
             -15,0,alt,
             15,0,alt,
             15,0,0],col)
  polygon3d([55,0,0,
             55,0,alt+(-30),
             25,0,alt+(-10),
             25,0,0],col)

ENDPROC

PROC shiftlist(list:PTR TO LONG)
  DEF x,l,i
  l:=N+1; i:=list[0]
  IF l THEN FOR x:=l TO 1 STEP -1 DO list[x]:=list[x-1]
  i:=i+3; IF i>=360 THEN i:=i-360; list[0]:=i
ENDPROC

PROC polygon3d(list:PTR TO LONG,col)
  DEF n,i,sx,sy,ox,oy,f=FALSE
  n:=ListLen(list)/3
  FOR i:=1 TO n
    vec3d(list[]++,list[]++,list[]++,{sx},{sy})
    IF f THEN Line(ox,oy,sx,sy,col) ELSE f:=TRUE
    ox:=sx; oy:=sy;
  ENDFOR
ENDPROC

PROC init3d(phi,theta)
        LEA     sintab(PC),A0           /* uses A0,A1,D0 */
        LEA     c1(PC),A1
        MOVE.L  phi,D0
        LSL.W   #1,D0
        MOVE.W  0(A0,D0.W),6(A1)
        ADD.W   #180,D0
        MOVE.W  0(A0,D0.W),2(A1)
        MOVE.L  theta,D0
        LSL.W   #1,D0
        MOVE.W  0(A0,D0.W),4(A1)
        ADD.W   #180,D0
        MOVE.W  0(A0,D0.W),(A1)
ENDPROC

PROC setpers3d(irho,id)        /* for average size rho:d = 5:2 */
        LEA     rho(PC),A0
        MOVE.W  irho.W,(A0)
        MOVE.W  id.W,2(A0)
ENDPROC

PROC setmiddle3d(x,y)
        LEA     midx(PC),A0
        MOVE.W  x.W,(A0)
        MOVE.W  y.W,2(A0)
ENDPROC

c1:     INT     $00c2
c2:     INT     $0045
s1:     INT     $00a3
s2:     INT     $00f5
rho:    INT     2000
d:      INT     900
midx:   INT     160
midy:   INT     128

PROC vec3d(x,y,z,sx,sy)
        MOVE.L  x,D0
        MOVE.L  y,D1
        MOVE.L  z,D2
        MOVE.L  A4,-(A7)
        MOVE.W  c1(PC),D3
        MOVE.W  c2(PC),D4
        MOVE.W  s1(PC),D5
        MOVE.W  s2(PC),D6
        MOVE    D0,D7                   /* EXPECTS X,Y,Z IN D0-D2 */
        MULS    D5,D7                   /* TRASHES ALL REGS BUT A5-A7 */
        ASR.L   #8,D7
        MOVE    D7,A0                   /* TEMP1 = X*S1 */
        MOVE    D1,D7
        MULS    D3,D7
        ASR.L   #8,D7
        SUB     A0,D7
        MOVE    D7,A2                   /* XE = Y*C1-TEMP1 */
        MOVE    D1,D7
        MULS    D5,D7
        ASR.L   #8,D7
        MULS    D4,D7
        ASR.L   #8,D7
        MOVE    D7,A0                   /* TEMP1 = Y*S1*C2 */
        MOVE    D0,D7
        MULS    D3,D7
        ASR.L   #8,D7
        MULS    D4,D7
        ASR.L   #8,D7
        MOVE    D7,A1                   /* TEMP2 = X*C1*C2 */
        MOVE    D2,D7
        MULS    D6,D7
        ASR.L   #8,D7
        SUB     A0,D7
        SUB     A1,D7
        MOVE    D7,A3                   /* YE = Z*S2-TEMP1-TEMP2 */
        MULS    D6,D0
        ASR.L   #8,D0
        MULS    D3,D0
        ASR.L   #8,D0
        MOVE    D0,A0                   /* TEMP1 = X*S2*C1 */
        MULS    D6,D1
        ASR.L   #8,D1
        MULS    D5,D1
        ASR.L   #8,D1
        MOVE    D1,A1                   /* TEMP2 = Y*S2*S1 */
        NEG     D2
        MULS    D4,D2
        ASR.L   #8,D2
        ADD     rho(PC),D2
        SUB     A0,D2
        SUB     A1,D2                   /* ZE(D2) = -Z*C2+RHO-TEMP1-TEMP2 */
        MOVE    A2,D3
        MOVE    A3,D4
        MOVE    d(PC),D0
        MOVE    D0,D1
        MULS    D3,D0
        DIVS    D2,D0
        ADD     midx(PC),D0             /* SX(D0) = D*XE/ZE+160 */
        NEG     D1
        MULS    D4,D1
        DIVS    D2,D1
        ADD     midy(PC),D1             /* SY(D1) = -D*YE/ZE+128 */
        MOVE.L  (A7)+,A4
        MOVE.L  sx,A0
        EXT.L   D0
        MOVE.L  D0,(A0)
        MOVE.L  sy,A0
        EXT.L   D1
        MOVE.L  D1,(A0)
ENDPROC

sintab: INT     $0000,$0004,$0008,$000D,$0011,$0016,$001A,$001F
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
