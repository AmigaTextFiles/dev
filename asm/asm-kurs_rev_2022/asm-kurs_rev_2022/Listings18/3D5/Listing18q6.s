
; Listing18q6.s = Unlimited-Vectors.S

;************************************************
;*	     Unlimited Vectors	                *
;*		   v2.0		                * 
;*                                              *
;*  Coder: EXECUTOR			        *
;*  			                        *
;************************************************
;se si usano piu' oggetti, ricordarsi di inserire il loro indirizzo
;nella routine per calcolare gli offsets interni dei vettori


;>EXTERN	"df1:obj2.f",OBJCOORDSTABLE

;*****************
;*   Constants   *
;*****************

OldOpenLibrary	= -408
CloseLibrary	= -414

DMASET=	%1000010111000000
;	 -----a-bcdefghij

;	a: Blitter Nasty
;	b: Bitplane DMA (if this isn't set, sprites disappear!)
;	c: Copper DMA
;	d: Blitter DMA
;	e: Sprite DMA
;	f: Disk DMA
;	g-j: Audio 3-0 DMA

	;JMP	$35000
	
	
	;ORG	$35000
	;LOAD	$35000
	

START:
	movem.l	d0-d7/a0-a6,-(a7)
	BSR	DEMOIRQ			; demo irq
	BSR	MAKELINEPOINTS
	bsr	clearscreen68000
	bsr	objadd
	bsr	doubleset	
	bsr	movement		; to load right values in regs....
		
*******Here There is your code*********

;LOOP:

WAITbeam:
	bsr	WaitOF
	bsr	doubleset2
	bsr	doubleset

	bsr objcolors
	bsr conversion
	bsr clearscreen2
	bsr movement
	bsr hidden
wwb:	bsr reconversion
	bsr line
	bsr fill2
	bsr fade
	bsr waitblit
	bsr	MAKEMASK
	bsr	COPYMASK
	move.l	XPOINT,a0
	cmp.l	#ENDSINX,a0
	bne	CB
	lea	SINX,a0
	move.l	#SINX,XPOINT
CB:
	move.l	YPOINT,a1
	cmp.l	#ENDSINY,a1
	bne	CB2
	lea	SINY,a1
	move.l	#SINY,YPOINT
CB2:
	move.w	(a0),d0
	add.w	#128,d0
	move.w	(a1),d1
	add.w	#96,d1
	move.l	screen2,a0
	bsr	Blit_it
	add.l	#2,XPOINT
	add.l	#2,YPOINT
	
;	move.w #$0fff,$dff180
	btst #$06,$bfe001
	bne waitbeam
	

***************************************
END:

	BSR	SYSTEMIRQ		; system irq
	MOVEM.L	(A7)+,D0-D7/A0-A6	; Get registers from stack
	MOVEQ.L	#$00,d0
	RTS

XPOINT:
	dc.l	SINX
YPOINT:
	dc.l	SINY
	
;***********************************
;*   CLOSE ALL SYSTEM INTERRUPTS   *
;*				 *
;*      START DEMO INTERRUPTS      *
;***********************************
DEMOIRQ:
	MOVE.L	$4.W,A6			; Exec pointer to A6
	LEA.L	GfxName(PC),A1		; Set library pointer
	MOVEQ	#0,D0
	JSR	OldOpenLibrary(A6)	; Open graphics.library
	MOVE.L	D0,A1			; Use Base-pointer
	MOVE.L	$26(A1),OLDCOP1		; Store copper1 start addr
	MOVE.L	$32(A1),OLDCOP2		; Store copper1 start addr
	JSR	CloseLibrary(A6)	; Close graphics library

	MOVE.W	$DFF01C,INTENA		; Store old INTENA
	MOVE.W	$DFF002,DMACON		; Store old DMACON
	MOVE.W	$DFF010,ADKCON		; Store old ADKCON

	MOVE.W	#$7FFF,$DFF09A		; Clear interrupt enable

	BSR.L	WAITOF

	MOVE.W	#$7FFF,$DFF096		; Clear DMA channels
	MOVE.L	#COPLIST,$DFF080	; Copper1 start address
	MOVE.W	#DMASET!$8200,$DFF096	; DMA kontrol data
	MOVE.L	$6C.W,OldIrq3		; Store old inter pointer
	MOVE.L	#IRQ3,$6C.W		; Set interrupt pointer

	MOVE.W	#$7FFF,$DFF09C		; Clear request
	MOVE.W	#$C020,$DFF09A		; Interrupt enable
	RTS
	
;*****************************************
;*					 *
;*   RESTORE SYSTEM INTERRUPTS ECT ECT   *
;*					 *
;*****************************************
SYSTEMIRQ:
	MOVE.W	#$7FFF,$DFF09A		; Disable interrupts

	BSR.L	WAITOF

	MOVE.W	#$7FFF,$DFF096
	MOVE.L	OldCop1(PC),$DFF080	; Restore old copper1
	MOVE.L	OldCop2(PC),$DFF084	; Restore old copper1
	MOVE.L	OldIrq3(PC),$6C.W	; Restore inter pointer
	MOVE.W	DMACON,D0		; Restore old DMACON
	OR.W	#$8000,D0
	MOVE.W	D0,$DFF096		
	MOVE.W	ADKCON,D0		; Restore old ADKCON
	OR.W	#$8000,D0
	MOVE.W	D0,$DFF09E
	MOVE.W	INTENA,D0		; Restore inter data
	OR.W	#$C000,D0
	MOVE.W	#$7FFF,$DFF09C
	MOVE.W	D0,$DFF09A
	RTS
	
;*** DATA AREA ***

GfxName		DC.B	'graphics.library',0
		even
OldIrq3		DC.L	0
OldCop1		DC.L	0
OldCop2		DC.L	0
INTENA		DC.W	0
DMACON		DC.W	0
ADKCON		DC.W	0

;**********************************
;*				  *
;*    INTERRUPT ROUTINE. LEVEL 3  *
;*				  *
;**********************************

IRQ3:
	MOVEM.L	D0-D7/A0-A6,-(A7)	; Put registers on stack

	MOVE.W	#$4020,$DFF09C		; Clear interrupt request
	MOVEM.L	(A7)+,D0-D7/A0-A6	; Get registers from stack
	RTE

;**********************************
WAITOF:	move.l	$dff004,d2		;Wait the start of the vertirq
	and.l	#$0001ff00,d2		;and the start of the video scan
	cmp.l	#$00012000,d2
	beq	WAITOFE
	bra	WAITOF
WAITOFE:
	rts
;**********************************
	
*********************************************
;	   3D  ROUTINES
*********************************************


waitblit:
	btst #$0e,$dff002
	bne.s waitblit
	rts
bltadat = $074
bltbdat = $072
bltcdat = $070
bltApth = $050
bltAptl = $052
bltBpth = $04c
bltBptl = $04e
bltCpth = $048
bltCptl = $04a
bltDpth = $054
bltDptl = $056
bltAmod = $064
bltBmod = $062
bltCmod = $060
bltDmod = $066
bltcon0 = $040
bltcon1 = $042
bltsize = $058
bltAmk1 = $044
bltAmk2 = $046


screen:		dc.l $50000
screen2:	dc.l $60000,$65000,$6a000,$6f000

; SCHERMI ALLOCATI A $60000 e $67800

MAKELINEPOINTS:
sl2:    moveq #00,d0
	lea yposmat,a1
yposloop:
	move.l #$0000,a0
	move.l d0,d1
	mulu #16,d1
	add.l d1,a0
	move.l a0,(a1)+
	addq.w #$01,d0
	cmp.w #639,d0
	bne.s yposloop

	moveq #$00,d1
	lea xposmat,a0
xloop:  move.w d1,d0
	clr.w d2
	move.w #$0b5a,d3
	ror.w #$4,d0
	lsl.b #$1,d0
	move.b d0,d2
	add.w d2,(a0)+
	and.w #$f000,d0
	add.w d0,d3
	move.w d3,(a0)+
	addq.w #$01,d1
	cmp.w #799,d1
	bne.s xloop
	rts
	
clearscreen68000:
	clr.l $0
	lea $50000,a1
	move.w #$bfff,d0
clearloop:
	clr.l (a1)+
	dbf d0,clearloop
	rts
	

scriptloc:      dc.l funzinescript

;A = x,y,z,rotx,roty,rotz	   set start coordinates
;B = xadd,yadd,zadd,rotxadd,rotyadd,rotzadd,times to repeat    modify
;C = resmod,fadd,object,lines,palette    set a new object
; modulo schermo,modulo totale (rasterscreen)
;D = frompalette,topalette	  fade from 1 to 2
;Z = address			goto.....

efxcounter:
	dc.w	0
	

xadd:   dc.w 0
yadd:   dc.w 0
zadd:   dc.w 0
rotxinc:dc.w 0
rotyinc:dc.w 0
rotzinc:dc.w 0

*********************************************
;       SCRIPT DEI MOVIMENTI DEI SOLIDI

funzinescript:

	dc.w 'C',0
	DC.L OBJCOORDSTABLE,OBJCOORDSTABLE+1024,OBJPALETTE
	DC.W 'A',31,31,-7370,0,0,0
FUNZINESCRIPT2:
	dc.w 'D'
	dc.l OBJpalette2,OBJpalette
	DC.W 'B',0,0,0,1,0,1,180
	DC.W 'B',0,0,0,2,0,1,200
	DC.W 'B',0,0,0,1,1,0,40
	DC.W 'B',0,0,0,0,1,1,50
	DC.W 'B',0,0,0,2,0,1,50
	DC.W 'B',0,0,0,1,1,1,50
	DC.W 'B',0,0,0,1,2,0,50
	DC.W 'B',0,0,0,1,1,1,50
	DC.W 'B',0,0,0,1,0,1,100
	DC.W 'B',0,0,0,1,2,1,50
	DC.W 'B',0,0,0,1,2,2,50
	DC.W 'B',0,0,0,2,2,2,50
	DC.W 'B',0,0,0,2,1,2,50
	DC.W 'B',0,0,0,1,2,1,50
	DC.W 'B',0,0,0,2,2,1,150
	dc.w 'D'
	dc.l OBJpalette3,OBJpalette
	DC.W 'B',0,0,0,-2,0,0,80
	DC.W 'B',0,0,0,2,2,3,40
	DC.W 'B',0,0,0,2,2,3,40
	DC.W 'B',0,0,0,2,2,3,40
	DC.W 'B',0,0,0,2,2,3,40
	DC.W 'B',0,0,0,2,2,3,40
	DC.W 'B',0,0,0,2,2,3,40
	dc.w 'B',0,0,0,3,3,4,130

	dc.w 'Z'
	dc.l FUNZINESCRIPT2
	
scriptefx:
	dc.l startcoords,modify,defineobj,fadepalette

movement:
	tst.w	efxcounter
	bne.s	movement2
	bra.L	scriptreader
movement2:
	subq.w	#1,efxcounter
	lea.l	OBJPOS,a0

	lea	xadd,a1
	move.w	(a1),d0
	move.w	2(a1),d1
	move.w	4(a1),d2
	move.w	6(a1),d3
	move.w	8(a1),d4
	move.w	10(a1),d5

	add.w	d0,6(a0)
	add.w	d1,8(a0)
	add.w	d2,10(a0)

	add.w	d3,(a0)
	cmp.w	#360,(a0)
	blt.s	rot1
	sub.w	#360,(a0)
rot1:   tst.w	(a0)
	bpl.s	rot12
	add.w	#360,(a0)

rot12:  add.w	d4,2(a0)
	cmp.w	#360,2(a0)
	blt.s	rot2
	sub.w	#360,2(a0)
rot2:   tst.w	2(a0)
	bpl.s	rot22
	add.w	#360,2(a0)

rot22:  add.w	d5,4(a0)
	cmp.w	#360,4(a0)
	blt.s	rot3
	sub.w	#360,4(a0)
rot3:   tst.w	4(a0)
	bpl.s	rot33
	add.w	#360,4(a0)

rot33:
	rts

scriptreader:
	move.l	scriptloc,a0
	cmp.w	#'Z',(a0)
	beq.L	scriptgoto
	lea	scriptefx,a1
	move.w	(a0),d0
	sub.w	#65,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,a1
	move.l	(a1),a3
	jmp	(a3)
	bra	movement
	rts

scriptgoto:
	move.l	2(a0),scriptloc
	bra	scriptreader
	rts     

startcoords:
	addq.l	#2,a0
	lea.l	OBJPOS,a2
	move.w	6(a0),(a2)
	move.w	8(a0),2(a2)
	move.w	10(a0),4(a2)
	tst.w	(a0)
	beq	sc1
	move.w	(a0),6(a2)
sc1:    tst.w	2(a0)
	beq	sc2
	move.w	2(a0),8(a2)
sc2:    tst.w	4(a0)
	beq	sc3
	move.w	4(a0),10(a2)
sc3:    add.l	#12,a0 
	move.l	a0,scriptloc
	bra	scriptreader
	rts
modify:
	addq.l	#2,a0
	lea	xadd,a2
	move.w	(a0),(a2)
	move.w	2(a0),2(a2)
	move.w	4(a0),4(a2)
	move.w	6(a0),6(a2)
	move.w	8(a0),8(a2)
	move.w	10(a0),10(a2)
	move.w	12(a0),efxcounter
	add.l	#14,a0    
	move.l	a0,scriptloc
	bra	movement
	rts

defineobj:
	move.l	4(a0),OBJCOORDS
	move.l	8(a0),OBJCOORDS+4
	move.l	12(a0),objcolor
	add.l	#16,a0
	move.l	a0,scriptloc
	bra	scriptreader
	rts

fadepalette:
	move.l	2(a0),frompalette
	move.l	6(a0),topalette
	move.w	#16*4,FADETIME
	move.w	#03,FADETIME2
	add.l	#10,a0
	move.l	a0,scriptloc
	bra	scriptreader
	
frompalette:	dc.l	0
topalette:	dc.l	0
FADETIME:	dc.w	0
FADETIME2:	dc.w	0


FADE:
	tst.w	FADETIME
	beq	FADEXIT
	sub.w	#01,FADETIME
	tst.w	FADETIME2
	bne	FADEXIT2
	move.w	#03,FADETIME2
	move.l	frompalette,a0
	move.l	topalette,a1
	move.w 	#8-1,d7
	bsr 	XSFUMA
	bra	FADEXIT
FADEXIT2:
	sub.w	#01,FADETIME2
FADEXIT:
	rts

XSFUMA:
	move.w 	(a0),d0
	move.w 	(a0),d1
	move.w 	(a0),d2
	move.w 	(a1),d3
	move.w 	(a1),d4
	move.w 	(a1),d5
	andi.w 	#$0f00,d0
	lsr.w 	#$08,d0
	andi.w 	#$00f0,d1
	lsr.w 	#$04,d1
	andi.w 	#$000f,d2
	andi.w 	#$0f00,d3
	lsr.w 	#$08,d3
	andi.w 	#$00f0,d4
	lsr.w 	#$04,d4
	andi.w 	#$000f,d5
	cmp.w 	d0,d3
	beq 	XCONT1
	blt 	XCONT2
	subi.w 	#$0001,d3
	bra 	XCONT1

XCONT2:
	addi.w 	#$0001,d3

XCONT1:
	cmp.w 	d1,d4
	beq 	XCONT3
	blt 	XCONT4
	subi.w 	#$0001,d4
	bra 	XCONT3

XCONT4:
	addi.w 	#$0001,d4

XCONT3:
	cmp.w 	d2,d5
	beq 	XCONT5
	blt 	XCONT6
	subi.w 	#$0001,d5
	bra 	XCONT5

XCONT6:
	addi.w 	#$0001,d5

XCONT5:
	lsl.w 	#$08,d3
	lsl.w 	#$04,d4
	add.w 	d3,d5
	add.w 	d4,d5
	move.w 	d5,(a1)
	addq.l 	#02,a0
	addq.l 	#02,a1
	dbf 	d7,XSFUMA
	rts

doubleset:
	lea	pointers,a2
	move.l	screen2+4,a1
	move.l	a1,d3
	move.w	d3,6(a2)
	swap	d3
	move.w	d3,2(a2)
	swap	d3
	add.w	#40,d3
	move.w	d3,14(a2)
	swap	d3
	move.w	d3,10(a2)
	rts

doubleset2:
	lea	screen2,a0
	move.l	12(a0),a1
	move.l	8(a0),12(a0)
	move.l	4(a0),8(a0)
	move.l	(a0),4(a0)
	move.l	a1,(a0)
	rts
	

objpalette:
	dc.w $000,$000,$000,$000,$000,$000,$000,$000
objpalette2:
	dc.w $000,$00c,$00a,$008,$000,$000,$000,$000
objpalette3:
	dc.w $000,$c44,$a44,$844,$000,$000,$000,$000

objcolors:
	move.l	objcolor,a0
	lea	colors,a1
	move.w	(a0),2(a1)
	move.w	2(a0),6(a1)
	move.w	4(a0),10(a1)
	move.w	6(a0),14(a1)
	move.w	8(a0),18(a1)
	move.w	10(a0),22(a1)
	move.w	12(a0),26(a1)
	move.w	14(a0),30(a1)
	rts

**********************************

hidden:
;   a4  ftable    a5  3dcoords

ftest:
	lea.l	OBJTABLE1,a5
	move.l	OBJCOORDS+4,a4
	
ftestloop:
	move.l	(a4)+,a0
	cmp.l	#$ffffffff,a0
	beq.s	ftestloopend
	move.l	(a0),a0
	move.l	a5,a1
	bsr	signtest
	bra	ftestloop
ftestloopend:
	rts

*****************
*** Sichttest ***
*****************
;a0   coordstable
;a1   coords

signtest:
	movem.l	d0-d7/a0-a6,-(a7)
	move.w	6(a0),d7
	lsl.w	#3,d7
	move.w	(a1,d7.w),d0
	move.w	2(a1,d7.w),d1
	move.w	4(a1,d7.w),d2
	asr.w	#3,d0
	asr.w	#3,d1
	asr.w	#3,d2
	move.w	d0,a3
	move.w	d1,a4
	move.w	d2,a5
	move.w	2+6(a0),d7
	lsl.w	#3,d7
	move.w	(a1,d7.w),d0
	move.w	2(a1,d7.w),d1
	move.w	4(a1,d7.w),d2
	asr.w	#3,d0
	asr.w	#3,d1
	asr.w	#3,d2
	move.w	4+6(a0),d7
	lsl.w	#3,d7
	move.w	(a1,d7.w),d3
	move.w	2(a1,d7.w),d4
	move.w	4(a1,d7.w),d5
	asr.w	#3,d3
	asr.w	#3,d4
	asr.w	#3,d5
	sub.w	a3,d0	;v
	sub.w	a4,d1
	sub.w	a5,d2
	sub.w	a3,d3	;w
	sub.w	a4,d4
	sub.w	a5,d5
	move.w	d0,vx+2
	move.w	d0,vx2+2
	move.w	d1,vy+2
	move.w	d1,vy2+2
	move.w	d2,vz+2
	move.w	d2,vz2+2
	move.w	d3,d0
	move.w	d4,d1
	move.w	d5,d2
vy:
	muls	#0,d5
vz:
	muls	#0,d1
	sub.w	d1,d5
			;x
vz2:
	muls	#0,d3
vx:
	muls	#0,d2
	sub.w	d2,d3
			;y
vx2:
	muls	#0,d4
vy2:
	muls	#0,d0
	sub.w	d0,d4
			;z
	move.w	a3,d0
	move.w	a4,d1
	move.w	a5,d2

	muls	d0,d5
	muls	d1,d3
	muls	d2,d4
	add.l	d3,d4
	add.l	d4,d5
	tst.l	d5
	bge.s	unsign
asign:
	move.w	#1,(a0)
	bra.s	signend
unsign:
	move.w	#0,(a0)
signend:
	movem.l	(a7)+,d0-d7/a0-a6
	rts


*************************************************

conversion:
	lea	OBJCOORDS,a5
	move.l	(a5),a5
;	move.l	a5,$7fff0
	
	
	lea	OBJPOS,a0
	lea	matsin,a1

	lea	OBJTABLE1,a6
masterrotaction:

	move.w	(a0),d0	
	add.w	d0,d0
	lea	(a1,d0.w),a4	; sin(x)

	move.w	2(a0),d0
	add.w	d0,d0
	LEA	(A1,D0.W),A2	; sin(y)

	move.w	4(a0),d0
	add.w	d0,d0
	LEA	(a1,d0.w),A1	; sin(z)
	

convloop:
	move.w	(a5),d1
	asl.w	#2,d1
	move.w	4(a5),d2
	asl.w	#2,d2
	move.w	8(a5),d3
	asl.w	#2,d3
	add.w	#14,a5

rotxz:  tst.w	(a0)
	beq.s	rotxy
	move.w	d1,d4		;x
	move.w	d3,d6		;z
	muls	180(a4),d4	;x*cos(x)
	muls	(a4),d6		;z*cos(x)
	sub.l	d6,d4		;x*cos(x)-z*cos(x)
	add.l	d4,d4
	swap	d4		;x
	muls	(a4),d1		;x*sin(x)
	muls	180(a4),d3	;z*cos(x)
	add.l	d1,d3		;x*sin(x)+z*cos(x)
	add.l	d3,d3
	swap	d3		;z
	move.w	d4,d1
rotxy:  tst.w	2(a0)
	beq.s	rotyz
	move.w	d1,d4		;x
	move.w	d2,d6		;y
	muls	180(a2),d4	;x*cos(y)
	muls	(a2),d6		;y*sin(y)
	sub.l	d6,d4		;x*cos(y)-y*sin(y)
	add.l	d4,d4
	swap	d4		;x
	muls	(a2),d1		;x*sin(y)
	muls	180(a2),d2	;y*cos(y)
	add.l	d1,d2		;x*sin(y)+y*cos(y)
	add.l	d2,d2
	swap	d2		;y
	move.w	d4,d1

rotyz:  tst.w	4(a0)
	beq.s	rotend
	move.w	d2,d4		;y
	move.w	d3,d6		;z
	muls	180(a1),d4	;y*cos(z)
	muls	(a1),d6		;z*sin(z)
	sub.l	d6,d4		;y*cos(z)-z*sin(z)
	add.l	d4,d4
	swap	d4		;y
	muls	(a1),d2		;y*sin(z)
	muls	180(a1),d3	;z*cos(z)
	add.l	d2,d3		;y*sin(z)+z*cos(z)
	add.l	d3,d3
	swap	d3		;z
	move.w	d4,d2
rotend:
	add.w	objpos+10,d3
	movem.w	d1-d3,(a6)
	addq.l	#8,a6
	cmp.w	#$7fff,(a5)
	bne	convloop
	move.w	#$7fff,(a6)
	
	rts




reconversion:

	lea	OBJTABLE1,a0
	lea	OBJPOS,a3
	lea	OBJTABLE2,a5

reconvloop:
	move.w	(a0),d1
	move.w	2(a0),d2
	move.w	4(a0),d3

	ext.l	d1
	ext.l	d2
	ext.l	d3
	asl.l	#8,d1
	asl.l	#8,d2
	divs	d3,d1
	divs	d3,d2		
	add.w	6(a3),d1
	add.w	8(a3),d2

dpointsloop:
	move.w	d1,(a5)+
	move.w	d2,(a5)+

	add.w	#8,a0	
	cmp.w	#$7fff,(a0)
	bne	reconvloop
	rts

matsin:
	dc.w	0,572,1144,1715,2286,2856
	dc.w	3425,3993,4560,5126,5690,6252
	dc.w	6813,7371,7927,8481,9032,9580
	dc.w	10126,10668,11207,11743,12275,12803
	dc.w	13328,13848,14364,14876,15383,15886
	dc.w	16383,16876,17364,17846,18323,18794
	dc.w	19260,19720,20173,20621,21062,21497,21925
	dc.w	22347,22762,23170,23571,23964
	dc.w	24351,24730,25101,25465,25821,26169
	dc.w	26509,26841,27165,27481,27788,28087
	dc.w	28377,28659,28932,29196,29451,29697
	dc.w	29934,30162,30381,30591,30791,30982
	dc.w	31163,31335,31498,31650,31794,31927
	dc.w	32051,32165,32269,32364,32448,32523
	dc.w	32588,32642,32687,32722,32747,32762
	dc.w	32767,32762,32747,32722,32687,32642
	dc.w	32588,32523,32448,32364,32269,32165
	dc.w	32051,31927,31794,31650,31498,31335
	dc.w	31163,30982,30791,30591,30381,30162
	dc.w	29934,29697,29451,29196,28932,28659
	dc.w	28377,28087,27788,27481,27165,26841
	dc.w	26509,26169,25821,25465,25101,24730
	dc.w	24351,23964,23571,23170,22762,22347
	dc.w	21925,21497,21062,20621,20173,19720
	dc.w	19260,18794,18323,17846,17364,16876
	dc.w	16384,15886,15383,14876,14364,13848
	dc.w	13328,12803,12275,11743,11207,10668
	dc.w	10126,9580,9032,8481,7927,7371
	dc.w	6813,6252,5690,5126,4560,3993
	dc.w	3425,2856,2286,1715,1144,572
	dc.w	0,-571,-1143,-1714,-2285,-2855
	dc.w	-3425,-3993,-4560,-5125,-5689,-6252
	dc.w	-6812,-7370,-7927,-8480,-9031,-9580
	dc.w	-10125,-10667,-11206,-11742,-12274,-12803
	dc.w	-13327,-13847,-14364,-14875,-15383,-15885
	dc.w	-16383,-16876,-17363,-17846,-18323,-18794
	dc.w	-19259,-19719,-20173,-20620,-21062,-21497
	dc.w	-21925,-22347,-22761,-23169,-23570,-23964
	dc.w	-24350,-24729,-25100,-25464,-25820,-26168
	dc.w	-26509,-26841,-27165,-27480,-27787,-28086
	dc.w	-28377,-28658,-28931,-29195,-29450,-29696
	dc.w	-29934,-30162,-30381,-30590,-30790,-30981
	dc.w	-31163,-31335,-31497,-31650,-31793,-31927
	dc.w	-32050,-32164,-32269,-32363,-32448,-32522
	dc.w	-32587,-32642,-32687,-32722,-32747,-32762
	dc.w	-32767,-32762,-32747,-32722,-32687,-32642
	dc.w	-32587,-32522,-32448,-32363,-32269,-32164
	dc.w	-32050,-31927,-31793,-31650,-31497,-31335
	dc.w	-31163,-30981,-30790,-30590,-30381,-30162
	dc.w	-29934,-29696,-29450,-29195,-28931,-28658
	dc.w	-28377,-28086,-27787,-27480,-27165,-26841
	dc.w	-26509,-26168,-25820,-25464,-25100,-24729
	dc.w	-24350,-23964,-23570,-23169,-22761,-22347
	dc.w	-21925,-21497,-21062,-20620,-20173,-19719
	dc.w	-19259,-18794,-18323,-17846,-17363,-16876
	dc.w	-16383,-15885,-15383,-14875,-14364,-13847
	dc.w	-13327,-12803,-12274,-11742,-11206,-10667
	dc.w	-10125,-9580,-9031,-8480,-7927,-7370
	dc.w	-6812,-6252,-5689,-5125,-4560,-3993
	dc.w	-3425,-2855,-2285,-1714,-1143,-571
	dc.w	0,572,1144,1715,2286,2856
	dc.w	3425,3993,4560,5126,5690,6252
	dc.w	6813,7371,7927,8481,9032,9580
	dc.w	10126,10668,11207,11743,12275,12803
	dc.w	13328,13848,14364,14876,15383,15886
	dc.w	16383,16876,17364,17846,18323,18794
	dc.w	19260,19720,20173,20621,21062,21497
	dc.w	21925,22347,22762,23170,23571,23964
	dc.w	24351,24730,25101,25465,25821,26169
	dc.w	26509,26841,27165,27481,27788,28087
	dc.w	28377,28659,28932,29196,29451,29697
	dc.w	29934,30162,30381,30591,30791,30982
	dc.w	31163,31335,31498,31650,31794,31927
	dc.w	32051,32165,32269,32364,32448,32523
	dc.w	32588,32642,32687,32722,32747,32762
	dc.w	32767,32762,32747,32722,32687,32642
	dc.w	32588,32523,32448,32364,32269,32165
	dc.w	32051,31927,31794,31650,31498,31335
	dc.w	31163,30982,30791,30591,30381,30162
	dc.w	29934,29697,29451,29196,28932,28659
	dc.w	28377,28087,27788,27481,27165,26841
	dc.w	26509,26169,25821,25465,25101,24730
	dc.w	24351,23964,23571,23170,22762,22347
	dc.w	21925,21497,21062,20621,20173,19720
	dc.w	19260,18794,18323,17846,17364,16876
	dc.w	16384,15886,15383,14876,14364,13848
	dc.w	13328,12803,12275,11743,11207,10668
	dc.w	10126,9580,9032,8481,7927,7371
	dc.w	6813,6252,5690,5126,4560,3993
	dc.w	3425,2856,2286,1715,1144,572
	dc.w	0,-571,-1143,-1714,-2285,-2855
	dc.w	-3425,-3993,-4560,-5125,-5689,-6252
	dc.w	-6812,-7370,-7927,-8480,-9031,-9580
	dc.w	-10125,-10667,-11206,-11742,-12274,-12803
	dc.w	-13327,-13847,-14364,-14875,-15383,-15885
	dc.w	-16383,-16876,-17363,-17846,-18323,-18794
	dc.w	-19259,-19719,-20173,-20620,-21062,-21497
	dc.w	-21925,-22347,-22761,-23169,-23570,-23964
	dc.w	-24350,-24729,-25100,-25464,-25820,-26168
	dc.w	-26509,-26841,-27165,-27480,-27787,-28086
	dc.w	-28377,-28658,-28931,-29195,-29450,-29696
	dc.w	-29934,-30162,-30381,-30590,-30790,-30981
	dc.w	-31163,-31335,-31497,-31650,-31793,-31927
	dc.w	-32050,-32164,-32269,-32363,-32448,-32522
	dc.w	-32587,-32642,-32687,-32722,-32747,-32762
	dc.w	-32767,-32762,-32747,-32722,-32687,-32642
	dc.w	-32587,-32522,-32448,-32363,-32269,-32164
	dc.w	-32050,-31927,-31793,-31650,-31497,-31335
	dc.w	-31163,-30981,-30790,-30590,-30381,-30162
	dc.w	-29934,-29696,-29450,-29195,-28931,-28658
	dc.w	-28377,-28086,-27787,-27480,-27165,-26841
	dc.w	-26509,-26168,-25820,-25464,-25100,-24729
	dc.w	-24350,-23964,-23570,-23169,-22761,-22347
	dc.w	-21925,-21497,-21062,-20620,-20173,-19719
	dc.w	-19259,-18794,-18323,-17846,-17363,-16876
	dc.w	-16383,-15885,-15383,-14875,-14364,-13847
	dc.w	-13327,-12803,-12274,-11742,-11206,-10667
	dc.w	-10125,-9580,-9031,-8480,-7927,-7370
	dc.w	-6812,-6252,-5689,-5125,-4560,-3993
	dc.w	-3425,-2855,-2285,-1714,-1143,-571


line:   
	move.l	OBJCOORDS+4,a5
	

line2:  bsr	waitblit
	lea	$dff000,a0
	move.w	#16,bltcmod(a0)
	move.w	#16,bltdmod(a0)
	move.l	screen,bltcpth(a0)
	move.l	screen,bltdpth(a0)
	move.l	#$ffffffff,bltamk1(a0) 
	move.w	#$8000,bltadat(a0)
	move.w	#$ffff,bltbdat(a0)

;parametri fissi della line
;determino l'indirizzo (word dove inizia la linea)
;e lo shift
	lea	OBJTABLE2,a1
	lea	yposmat,a3  
	lea	xposmat,a4


al2:	move.l	(a5)+,a6
	cmp.l	#$ffffffff,a6
	beq	ll2cont

	move.l	(a6),a2
	move.w	(a2),d6
	tst.w	d6
	bne	al2

ll2:	move.l	(a6)+,a2
	cmp.l	#$ffffffff,a2
	beq	al2

	move.w	(a2)+,d6
	bra.s	ll4
ll2cont:
	rts
ll4:    move.w	(a2)+,d7
	subq.w	#2,d7
	
	move.w	(a2)+,color
	movem.l	a5/a6,-(a7)
lineloop:
	move.w	(a2)+,d6
	lsl.w	#2,d6
	move.w	(a1,d6.w),d1
	move.w	2(a1,d6.w),d3
	move.w	(a2),d6
	lsl.w	#2,d6
	move.w	(a1,d6.w),d2
	move.w	2(a1,d6.w),d4
	cmp.w	d3,d4
	ble.s	linefinal
	exg	d3,d4
	exg	d1,d2
linefinal:
	add.w	d3,d3
	add.w	d3,d3
	add.w	d1,d1
	add.w	d1,d1

	move.w	d1,d0
	move.l	screen(pc),a5
	add.l	(a3,d3.w),a5
	add.w	(a4,d1.w),a5
	lsr.w	#2,d3
	lsr.w	#2,d1

	sub.w   d3,d4;y lenght
	bpl.s   octchoose1
	neg.w   d4
	sub.w   d1,d2;xlenght
	bpl.s 	octchoose2
	neg.w   d2
	cmp.w   d4,d2
	bpl.s   octchoose3
	moveq   #77-64+2,d6
	bra.s   octchoosend
octchoose1:
	sub.w   d1,d2;xlenght
	bpl.s   octchoose4
	neg.w   d2
	cmp.w   d4,d2
	bpl.s   octchoose5
	moveq   #73-64+2,d6
	bra.s   octchoosend
octchoose2:
	cmp.w   d4,d2
	bpl.s   octchoose7
	moveq   #69-64+2,d6
	bra.s   octchoosend
octchoose4:
	cmp.w   d4,d2
	bpl.s   octchoose6
	moveq   #65-64+2,d6
	bra.s   octchoosend
octchoose3:
	moveq   #93-64+2,d6
	bra.s   octchoosend1
octchoose5:
	moveq   #85-64+2,d6
	bra.s   octchoosend1
octchoose6:
	moveq   #81-64+2,d6
	bra.s   octchoosend1
octchoose7:
	moveq   #89-64+2,d6
	bra.s   octchoosend1
octchoosend:
	exg     d2,d4
octchoosend1:
	move.w	d4,d5
; 2*y - x
	sub.w	d2,d5
	move.w	d5,d3    ;(d3 = y-x)
	add.w	d4,d5
	add.w	d5,d5
; 4(y-x)
	add.w	d3,d3
	add.w	d3,d3
	bpl.w	sign
	bset	#6,d6
; 4*y
sign:
	add.w	d4,d4
	add.w	d4,d4

;size
	addq.w	#$01,d2
	lsl.w	#$06,d2
	or.w	#$2,d2

	move.l	a5,a6
	move.w	2(a4,d0.w),d1
	and.w	#$f000,d1
	rol.w	#4,d1
	neg.w	d1
	add.w	#15,d1
	bclr	#3,d1
	bne.s	corr
	addq.w	#1,a6
corr:
	btst	#$00,color+1
	beq.s	cc0
awline:
	btst	#$0e,2(a0)
	bne.s	awline

	bchg	d1,(a6)
	move.w	d3,bltamod(a0);4(y-x)
	move.w	d6,bltcon1(a0);octant
	move.w	d4,bltbmod(a0);4y
	move.w	d5,bltaptl(a0);2y-x
	move.w	a5,bltcptl(a0)
	move.w	a5,bltdptl(a0)
	move.w	2(a4,d0.w),bltcon0(a0)
	move.w	d2,bltsize(a0);xlenght
cc0:    
	lea	8(a5),a5
	
	btst	#$01,color+1
	beq.s	cc1
bwline:
	btst	#$0e,2(a0)
	bne.s	bwline
	bchg	d1,8(a6)
	move.w	d3,bltamod(a0);4(y-x)
	move.w	d6,bltcon1(a0);octant
	move.w	d4,bltbmod(a0);4y
	move.w	d5,bltaptl(a0);2y-x
	move.w	a5,bltcptl(a0)
	move.w	a5,bltdptl(a0)
	move.w	2(a4,d0.w),bltcon0(a0)
	move.w	d2,bltsize(a0);xlenght

cc1:

cc2:    dbf	d7,lineloop
	movem.l	(a7)+,a5/a6
	bra	ll2	



linend: rts
color:  dc.w 0

fill:
	bsr	waitblit
	lea	$dff000,a0
	move.l	#$ffffffff,bltamk1(a0)
	move.l	#$09f00012,bltcon0(a0)
	move.l	screen,a1
;	add.l	startingloc,a1
	move.l	a1,bltapth(a0)
	move.l	a1,bltdpth(a0)
;	move.w	modulo,bltamod(a0)
;	move.w	modulo,bltdmod(a0)
;	move.w	blitsize,bltsize(a0)
	rts

fill2:
	bsr	waitblit
	lea	$dff000,a0
	move.l	#$ffffffff,bltamk1(a0)
	move.l	#$09f00012,bltcon0(a0)
	move.l	screen,a1
	add.l	#16*64-2,a1
	move.l	a1,bltapth(a0)
	move.l	a1,bltdpth(a0)
	move.w	#$00,bltamod(a0)
	move.w	#$00,bltdmod(a0)
	move.w	#64*64+16,bltsize(a0)
	rts

clearscreen:
	bsr	waitblit
	lea	$dff000,a0
	move.l	#$01000002,bltcon0(a0)
	move.l	screen,a1
;	add.l	startingloc2,a1
	move.l	a1,bltdpth(a0)
;	move.w	modulo2,bltdmod(a0)
;	move.w	blitsize2,d0
	move.w	d0,bltsize(a0)
	rts

clearscreen2:
	bsr	waitblit
	lea	$dff000,a0
	move.l	#$01000002,bltcon0(a0)
	move.l	screen,a1
	add.l	#16*64-2,a1
	move.l	a1,bltdpth(a0)
	move.w	#$00,bltdmod(a0)
	move.w	#64*64+16,bltsize(a0)
	rts




*********************************************************
;This routine adds the Lableadresses to all 
;adresses in the objects.
;Insert the Load-Lables after -objectsaddtable-!!!

Objectsaddtable:
	dc.l	objcoordstable
	dc.l	$ffffffff

objadd:
	lea	objectsaddtable(pc),a0
objadd1:
	move.l	(a0)+,d0
	cmp.l	#$ffffffff,d0
	beq.s	objaddend
	lea	1024,a2			
	add.l	d0,a2
objadd2:
	cmp.l	#$ffffffff,(a2)+
	beq.s	objadd1
	add.l	d0,-4(a2)
	move.l	-4(a2),a3
objadd3:
	cmp.l	#$ffffffff,(a3)+
	beq.s	objadd2
	add.l	d0,-4(a3)	
	bra	objadd3
objaddend:
	rts

**************************************************


;Input:
;	d0 [X value position]
;	d1 [Y value position]
;	a0 [pointer to bplane]

;Output:
;	d0 [Trashed]
;	d1 [Trashed]
;	d2 [Trashed]
;	d3 [Trashed]
;	a0 [Trashed]

Blit_It:
	btst	#$0e,$dff002			;Wait free blitter
	bne Blit_it
	move.l  #0,d2				;Put 0 in d2,d3
	move.l	#0,d3				;
	move.w	d1,d2				;Y offset
	mulu.w	#80,d2				;
	move.w  d0,d3
	divu.w	#8,d3				;Calcolate the offset
	and.w	#%1111111111111110,d3		;and the shifting
	add.w	d3,d2				;value and add in a0
	add.l	d2,a0		
	move.l	a0,$dff054			;Put a0 in blit-channel
	move.l	a0,$dff048			;C and D
	move.l	screen,$dff04c			;Put Object
	move.l	#MASK,$dff050			;and Mask
	move.w	#-2,$dff064			;Module...
	move.w	#-2,$dff062
	move.w	#30,$dff060
	move.w	#30,$dff066
	mulu.w	#8,d3
	sub.w	d3,d0	
	lsl.w	#8,d0
	lsl.w	#4,d0
	move.w	d0,$dff042			;Shifting value
	or.w	#$0fca,d0			;LF=ca, all channels  
	move.w	d0,$dff040			;active
	move.l	#$ffff0000,$dff044		;WordMask
	move.w	#128*64+5,$dff058		;Start and Size
	rts


MAKEMASK:
	bsr	Waitblit
	move.l	screen,a0
	move.l	a0,$dff050
	add.l	#8,a0
	move.l	a0,$dff04c
	move.l	#Mask,$dff054
	move.l	#$0dfc0000,$dff040
	move.l	#$ffffffff,$dff044
	move.w	#0,$dff060
	move.w	#8,$dff062
	move.w	#8,$dff064
	move.w	#8,$dff066
	move.w	#64*64+4,$dff058
	rts
	
COPYMASK:
	bsr	Waitblit
	move.l	#MASK,$dff050
	move.l	#MASK+8,$dff054
	move.l	#$ffffffff,$dff044
	move.l	#$09f00000,$dff040
	move.w	#8,$dff064
	move.w	#8,$dff066
	move.w	#64*64+4,$dff058
	rts
	
MASK:
	blk.b	16*64
	
						



**************************************************
;OBJECT DATA STRUCTURE------------------------------------------------

	
OBJCOORDS:
	dc.l	OBJCOORDSTABLE,OBJCOORDSTABLE+1024
;	questi sono gli indirizzi dell'oggetto

OBJPOS:
	dc.w	100,50,100		;xrot,yrot,zrot
	dc.w	160,100,-200		;xpos,ypos,zpos
	dc.w	0,0,0
	dc.w	0,0,0
	
OBJCOLOR:
	dc.l	0
	
OBJTABLE1:
	blk.b	1024,0
OBJTABLE2:
	blk.b	1024,0

OBJCOORDSTABLE:
;	blk.b	4000,0		;load here your object
	incbin  "obj2.f"	;>EXTERN	"df1:obj2.f",OBJCOORDSTABLE
xposmat:
	blk.l 900,0
yposmat:
	blk.l 700,0
	blk.l 200,0
	
SINX:
	DC.B	$00,$00,$00,$01,$00,$02,$00,$03
	DC.B	$00,$04,$00,$05,$00,$06,$00,$07
	DC.B	$00,$08,$00,$09,$00,$0A,$00,$0B
	DC.B	$00,$0C,$00,$0D,$00,$0E,$00,$0F
	DC.B	$00,$10,$00,$11,$00,$12,$00,$13
	DC.B	$00,$14,$00,$15,$00,$16,$00,$17
	DC.B	$00,$18,$00,$19,$00,$1A,$00,$1B
	DC.B	$00,$1C,$00,$1D,$00,$1E,$00,$1F
	DC.B	$00,$20,$00,$21,$00,$21,$00,$22
	DC.B	$00,$23,$00,$24,$00,$25,$00,$26
	DC.B	$00,$27,$00,$28,$00,$29,$00,$2A
	DC.B	$00,$2B,$00,$2C,$00,$2C,$00,$2D
	DC.B	$00,$2E,$00,$2F,$00,$30,$00,$31
	DC.B	$00,$32,$00,$33,$00,$33,$00,$34
	DC.B	$00,$35,$00,$36,$00,$37,$00,$38
	DC.B	$00,$38,$00,$39,$00,$3A,$00,$3B
	DC.B	$00,$3C,$00,$3C,$00,$3D,$00,$3E
	DC.B	$00,$3F,$00,$3F,$00,$40,$00,$41
	DC.B	$00,$42,$00,$42,$00,$43,$00,$44
	DC.B	$00,$45,$00,$45,$00,$46,$00,$47
	DC.B	$00,$47,$00,$48,$00,$49,$00,$49
	DC.B	$00,$4A,$00,$4B,$00,$4B,$00,$4C
	DC.B	$00,$4C,$00,$4D,$00,$4E,$00,$4E
	DC.B	$00,$4F,$00,$4F,$00,$50,$00,$51
	DC.B	$00,$51,$00,$52,$00,$52,$00,$53
	DC.B	$00,$53,$00,$54,$00,$54,$00,$55
	DC.B	$00,$55,$00,$56,$00,$56,$00,$56
	DC.B	$00,$57,$00,$57,$00,$58,$00,$58
	DC.B	$00,$58,$00,$59,$00,$59,$00,$5A
	DC.B	$00,$5A,$00,$5A,$00,$5B,$00,$5B
	DC.B	$00,$5B,$00,$5C,$00,$5C,$00,$5C
	DC.B	$00,$5C,$00,$5D,$00,$5D,$00,$5D
	DC.B	$00,$5D,$00,$5E,$00,$5E,$00,$5E
	DC.B	$00,$5E,$00,$5E,$00,$5F,$00,$5F
	DC.B	$00,$5F,$00,$5F,$00,$5F,$00,$5F
	DC.B	$00,$5F,$00,$60,$00,$60,$00,$60
	DC.B	$00,$60,$00,$60,$00,$60,$00,$60
	DC.B	$00,$60,$00,$60,$00,$60,$00,$60
	DC.B	$00,$60,$00,$60,$00,$60,$00,$60
	DC.B	$00,$60,$00,$60,$00,$60,$00,$60
	DC.B	$00,$5F,$00,$5F,$00,$5F,$00,$5F
	DC.B	$00,$5F,$00,$5F,$00,$5F,$00,$5E
	DC.B	$00,$5E,$00,$5E,$00,$5E,$00,$5E
	DC.B	$00,$5D,$00,$5D,$00,$5D,$00,$5D
	DC.B	$00,$5C,$00,$5C,$00,$5C,$00,$5C
	DC.B	$00,$5B,$00,$5B,$00,$5B,$00,$5A
	DC.B	$00,$5A,$00,$5A,$00,$59,$00,$59
	DC.B	$00,$58,$00,$58,$00,$58,$00,$57
	DC.B	$00,$57,$00,$56,$00,$56,$00,$56
	DC.B	$00,$55,$00,$55,$00,$54,$00,$54
	DC.B	$00,$53,$00,$53,$00,$52,$00,$52
	DC.B	$00,$51,$00,$51,$00,$50,$00,$4F
	DC.B	$00,$4F,$00,$4E,$00,$4E,$00,$4D
	DC.B	$00,$4C,$00,$4C,$00,$4B,$00,$4B
	DC.B	$00,$4A,$00,$49,$00,$49,$00,$48
	DC.B	$00,$47,$00,$47,$00,$46,$00,$45
	DC.B	$00,$45,$00,$44,$00,$43,$00,$42
	DC.B	$00,$42,$00,$41,$00,$40,$00,$3F
	DC.B	$00,$3F,$00,$3E,$00,$3D,$00,$3C
	DC.B	$00,$3C,$00,$3B,$00,$3A,$00,$39
	DC.B	$00,$38,$00,$38,$00,$37,$00,$36
	DC.B	$00,$35,$00,$34,$00,$33,$00,$33
	DC.B	$00,$32,$00,$31,$00,$30,$00,$2F
	DC.B	$00,$2E,$00,$2D,$00,$2C,$00,$2C
	DC.B	$00,$2B,$00,$2A,$00,$29,$00,$28
	DC.B	$00,$27,$00,$26,$00,$25,$00,$24
	DC.B	$00,$23,$00,$22,$00,$21,$00,$21
	DC.B	$00,$20,$00,$1F,$00,$1E,$00,$1D
	DC.B	$00,$1C,$00,$1B,$00,$1A,$00,$19
	DC.B	$00,$18,$00,$17,$00,$16,$00,$15
	DC.B	$00,$14,$00,$13,$00,$12,$00,$11
	DC.B	$00,$10,$00,$0F,$00,$0E,$00,$0D
	DC.B	$00,$0C,$00,$0B,$00,$0A,$00,$09
	DC.B	$00,$08,$00,$07,$00,$06,$00,$05
	DC.B	$00,$04,$00,$03,$00,$02,$00,$01
	DC.B	$00,$00,$FF,$FF,$FF,$FE,$FF,$FD
	DC.B	$FF,$FC,$FF,$FB,$FF,$FA,$FF,$F9
	DC.B	$FF,$F8,$FF,$F7,$FF,$F6,$FF,$F5
	DC.B	$FF,$F4,$FF,$F3,$FF,$F2,$FF,$F1
	DC.B	$FF,$F0,$FF,$EF,$FF,$EE,$FF,$ED
	DC.B	$FF,$EC,$FF,$EB,$FF,$EA,$FF,$E9
	DC.B	$FF,$E8,$FF,$E7,$FF,$E6,$FF,$E5
	DC.B	$FF,$E4,$FF,$E3,$FF,$E2,$FF,$E1
	DC.B	$FF,$E0,$FF,$DF,$FF,$DF,$FF,$DE
	DC.B	$FF,$DD,$FF,$DC,$FF,$DB,$FF,$DA
	DC.B	$FF,$D9,$FF,$D8,$FF,$D7,$FF,$D6
	DC.B	$FF,$D5,$FF,$D4,$FF,$D4,$FF,$D3
	DC.B	$FF,$D2,$FF,$D1,$FF,$D0,$FF,$CF
	DC.B	$FF,$CE,$FF,$CD,$FF,$CD,$FF,$CC
	DC.B	$FF,$CB,$FF,$CA,$FF,$C9,$FF,$C8
	DC.B	$FF,$C8,$FF,$C7,$FF,$C6,$FF,$C5
	DC.B	$FF,$C4,$FF,$C4,$FF,$C3,$FF,$C2
	DC.B	$FF,$C1,$FF,$C1,$FF,$C0,$FF,$BF
	DC.B	$FF,$BE,$FF,$BE,$FF,$BD,$FF,$BC
	DC.B	$FF,$BB,$FF,$BB,$FF,$BA,$FF,$B9
	DC.B	$FF,$B9,$FF,$B8,$FF,$B7,$FF,$B7
	DC.B	$FF,$B6,$FF,$B5,$FF,$B5,$FF,$B4
	DC.B	$FF,$B4,$FF,$B3,$FF,$B2,$FF,$B2
	DC.B	$FF,$B1,$FF,$B1,$FF,$B0,$FF,$AF
	DC.B	$FF,$AF,$FF,$AE,$FF,$AE,$FF,$AD
	DC.B	$FF,$AD,$FF,$AC,$FF,$AC,$FF,$AB
	DC.B	$FF,$AB,$FF,$AA,$FF,$AA,$FF,$AA
	DC.B	$FF,$A9,$FF,$A9,$FF,$A8,$FF,$A8
	DC.B	$FF,$A8,$FF,$A7,$FF,$A7,$FF,$A6
	DC.B	$FF,$A6,$FF,$A6,$FF,$A5,$FF,$A5
	DC.B	$FF,$A5,$FF,$A4,$FF,$A4,$FF,$A4
	DC.B	$FF,$A4,$FF,$A3,$FF,$A3,$FF,$A3
	DC.B	$FF,$A3,$FF,$A2,$FF,$A2,$FF,$A2
	DC.B	$FF,$A2,$FF,$A2,$FF,$A1,$FF,$A1
	DC.B	$FF,$A1,$FF,$A1,$FF,$A1,$FF,$A1
	DC.B	$FF,$A1,$FF,$A0,$FF,$A0,$FF,$A0
	DC.B	$FF,$A0,$FF,$A0,$FF,$A0,$FF,$A0
	DC.B	$FF,$A0,$FF,$A0,$FF,$A0,$FF,$A0
	DC.B	$FF,$A0,$FF,$A0,$FF,$A0,$FF,$A0
	DC.B	$FF,$A0,$FF,$A0,$FF,$A0,$FF,$A0
	DC.B	$FF,$A1,$FF,$A1,$FF,$A1,$FF,$A1
	DC.B	$FF,$A1,$FF,$A1,$FF,$A1,$FF,$A2
	DC.B	$FF,$A2,$FF,$A2,$FF,$A2,$FF,$A2
	DC.B	$FF,$A3,$FF,$A3,$FF,$A3,$FF,$A3
	DC.B	$FF,$A4,$FF,$A4,$FF,$A4,$FF,$A4
	DC.B	$FF,$A5,$FF,$A5,$FF,$A5,$FF,$A6
	DC.B	$FF,$A6,$FF,$A6,$FF,$A7,$FF,$A7
	DC.B	$FF,$A8,$FF,$A8,$FF,$A8,$FF,$A9
	DC.B	$FF,$A9,$FF,$AA,$FF,$AA,$FF,$AA
	DC.B	$FF,$AB,$FF,$AB,$FF,$AC,$FF,$AC
	DC.B	$FF,$AD,$FF,$AD,$FF,$AE,$FF,$AE
	DC.B	$FF,$AF,$FF,$AF,$FF,$B0,$FF,$B1
	DC.B	$FF,$B1,$FF,$B2,$FF,$B2,$FF,$B3
	DC.B	$FF,$B4,$FF,$B4,$FF,$B5,$FF,$B5
	DC.B	$FF,$B6,$FF,$B7,$FF,$B7,$FF,$B8
	DC.B	$FF,$B9,$FF,$B9,$FF,$BA,$FF,$BB
	DC.B	$FF,$BB,$FF,$BC,$FF,$BD,$FF,$BE
	DC.B	$FF,$BE,$FF,$BF,$FF,$C0,$FF,$C1
	DC.B	$FF,$C1,$FF,$C2,$FF,$C3,$FF,$C4
	DC.B	$FF,$C4,$FF,$C5,$FF,$C6,$FF,$C7
	DC.B	$FF,$C8,$FF,$C8,$FF,$C9,$FF,$CA
	DC.B	$FF,$CB,$FF,$CC,$FF,$CD,$FF,$CD
	DC.B	$FF,$CE,$FF,$CF,$FF,$D0,$FF,$D1
	DC.B	$FF,$D2,$FF,$D3,$FF,$D4,$FF,$D4
	DC.B	$FF,$D5,$FF,$D6,$FF,$D7,$FF,$D8
	DC.B	$FF,$D9,$FF,$DA,$FF,$DB,$FF,$DC
	DC.B	$FF,$DD,$FF,$DE,$FF,$DF,$FF,$DF
	DC.B	$FF,$E0,$FF,$E1,$FF,$E2,$FF,$E3
	DC.B	$FF,$E4,$FF,$E5,$FF,$E6,$FF,$E7
	DC.B	$FF,$E8,$FF,$E9,$FF,$EA,$FF,$EB
	DC.B	$FF,$EC,$FF,$ED,$FF,$EE,$FF,$EF
	DC.B	$FF,$F0,$FF,$F1,$FF,$F2,$FF,$F3
	DC.B	$FF,$F4,$FF,$F5,$FF,$F6,$FF,$F7
	DC.B	$FF,$F8,$FF,$F9,$FF,$FA,$FF,$FB
	DC.B	$FF,$FC,$FF,$FD,$FF,$FE,$FF,$FF
ENDSINX:
		
SINY:
	DC.B	$00,$00,$00,$01,$00,$02,$00,$02
	DC.B	$00,$03,$00,$04,$00,$05,$00,$06
	DC.B	$00,$06,$00,$07,$00,$08,$00,$09
	DC.B	$00,$0A,$00,$0A,$00,$0B,$00,$0C
	DC.B	$00,$0D,$00,$0E,$00,$0E,$00,$0F
	DC.B	$00,$10,$00,$11,$00,$11,$00,$12
	DC.B	$00,$13,$00,$14,$00,$15,$00,$15
	DC.B	$00,$16,$00,$17,$00,$18,$00,$18
	DC.B	$00,$19,$00,$1A,$00,$1B,$00,$1B
	DC.B	$00,$1C,$00,$1D,$00,$1D,$00,$1E
	DC.B	$00,$1F,$00,$20,$00,$20,$00,$21
	DC.B	$00,$22,$00,$22,$00,$23,$00,$24
	DC.B	$00,$24,$00,$25,$00,$26,$00,$26
	DC.B	$00,$27,$00,$28,$00,$28,$00,$29
	DC.B	$00,$29,$00,$2A,$00,$2B,$00,$2B
	DC.B	$00,$2C,$00,$2C,$00,$2D,$00,$2E
	DC.B	$00,$2E,$00,$2F,$00,$2F,$00,$30
	DC.B	$00,$30,$00,$31,$00,$31,$00,$32
	DC.B	$00,$32,$00,$33,$00,$33,$00,$34
	DC.B	$00,$34,$00,$35,$00,$35,$00,$36
	DC.B	$00,$36,$00,$36,$00,$37,$00,$37
	DC.B	$00,$38,$00,$38,$00,$38,$00,$39
	DC.B	$00,$39,$00,$3A,$00,$3A,$00,$3A
	DC.B	$00,$3B,$00,$3B,$00,$3B,$00,$3C
	DC.B	$00,$3C,$00,$3C,$00,$3C,$00,$3D
	DC.B	$00,$3D,$00,$3D,$00,$3D,$00,$3E
	DC.B	$00,$3E,$00,$3E,$00,$3E,$00,$3E
	DC.B	$00,$3F,$00,$3F,$00,$3F,$00,$3F
	DC.B	$00,$3F,$00,$3F,$00,$3F,$00,$3F
	DC.B	$00,$40,$00,$40,$00,$40,$00,$40
	DC.B	$00,$40,$00,$40,$00,$40,$00,$40
	DC.B	$00,$40,$00,$40,$00,$40,$00,$40
	DC.B	$00,$40,$00,$40,$00,$40,$00,$40
	DC.B	$00,$40,$00,$40,$00,$40,$00,$3F
	DC.B	$00,$3F,$00,$3F,$00,$3F,$00,$3F
	DC.B	$00,$3F,$00,$3F,$00,$3F,$00,$3E
	DC.B	$00,$3E,$00,$3E,$00,$3E,$00,$3E
	DC.B	$00,$3D,$00,$3D,$00,$3D,$00,$3D
	DC.B	$00,$3C,$00,$3C,$00,$3C,$00,$3C
	DC.B	$00,$3B,$00,$3B,$00,$3B,$00,$3A
	DC.B	$00,$3A,$00,$3A,$00,$39,$00,$39
	DC.B	$00,$38,$00,$38,$00,$38,$00,$37
	DC.B	$00,$37,$00,$36,$00,$36,$00,$36
	DC.B	$00,$35,$00,$35,$00,$34,$00,$34
	DC.B	$00,$33,$00,$33,$00,$32,$00,$32
	DC.B	$00,$31,$00,$31,$00,$30,$00,$30
	DC.B	$00,$2F,$00,$2F,$00,$2E,$00,$2E
	DC.B	$00,$2D,$00,$2C,$00,$2C,$00,$2B
	DC.B	$00,$2B,$00,$2A,$00,$29,$00,$29
	DC.B	$00,$28,$00,$28,$00,$27,$00,$26
	DC.B	$00,$26,$00,$25,$00,$24,$00,$24
	DC.B	$00,$23,$00,$22,$00,$22,$00,$21
	DC.B	$00,$20,$00,$20,$00,$1F,$00,$1E
	DC.B	$00,$1D,$00,$1D,$00,$1C,$00,$1B
	DC.B	$00,$1B,$00,$1A,$00,$19,$00,$18
	DC.B	$00,$18,$00,$17,$00,$16,$00,$15
	DC.B	$00,$15,$00,$14,$00,$13,$00,$12
	DC.B	$00,$11,$00,$11,$00,$10,$00,$0F
	DC.B	$00,$0E,$00,$0E,$00,$0D,$00,$0C
	DC.B	$00,$0B,$00,$0A,$00,$0A,$00,$09
	DC.B	$00,$08,$00,$07,$00,$06,$00,$06
	DC.B	$00,$05,$00,$04,$00,$03,$00,$02
	DC.B	$00,$02,$00,$01,$00,$00,$FF,$FF
	DC.B	$FF,$FE,$FF,$FE,$FF,$FD,$FF,$FC
	DC.B	$FF,$FB,$FF,$FA,$FF,$FA,$FF,$F9
	DC.B	$FF,$F8,$FF,$F7,$FF,$F6,$FF,$F6
	DC.B	$FF,$F5,$FF,$F4,$FF,$F3,$FF,$F2
	DC.B	$FF,$F2,$FF,$F1,$FF,$F0,$FF,$EF
	DC.B	$FF,$EF,$FF,$EE,$FF,$ED,$FF,$EC
	DC.B	$FF,$EB,$FF,$EB,$FF,$EA,$FF,$E9
	DC.B	$FF,$E8,$FF,$E8,$FF,$E7,$FF,$E6
	DC.B	$FF,$E5,$FF,$E5,$FF,$E4,$FF,$E3
	DC.B	$FF,$E3,$FF,$E2,$FF,$E1,$FF,$E0
	DC.B	$FF,$E0,$FF,$DF,$FF,$DE,$FF,$DE
	DC.B	$FF,$DD,$FF,$DC,$FF,$DC,$FF,$DB
	DC.B	$FF,$DA,$FF,$DA,$FF,$D9,$FF,$D8
	DC.B	$FF,$D8,$FF,$D7,$FF,$D7,$FF,$D6
	DC.B	$FF,$D5,$FF,$D5,$FF,$D4,$FF,$D4
	DC.B	$FF,$D3,$FF,$D2,$FF,$D2,$FF,$D1
	DC.B	$FF,$D1,$FF,$D0,$FF,$D0,$FF,$CF
	DC.B	$FF,$CF,$FF,$CE,$FF,$CE,$FF,$CD
	DC.B	$FF,$CD,$FF,$CC,$FF,$CC,$FF,$CB
	DC.B	$FF,$CB,$FF,$CA,$FF,$CA,$FF,$CA
	DC.B	$FF,$C9,$FF,$C9,$FF,$C8,$FF,$C8
	DC.B	$FF,$C8,$FF,$C7,$FF,$C7,$FF,$C6
	DC.B	$FF,$C6,$FF,$C6,$FF,$C5,$FF,$C5
	DC.B	$FF,$C5,$FF,$C4,$FF,$C4,$FF,$C4
	DC.B	$FF,$C4,$FF,$C3,$FF,$C3,$FF,$C3
	DC.B	$FF,$C3,$FF,$C2,$FF,$C2,$FF,$C2
	DC.B	$FF,$C2,$FF,$C2,$FF,$C1,$FF,$C1
	DC.B	$FF,$C1,$FF,$C1,$FF,$C1,$FF,$C1
	DC.B	$FF,$C1,$FF,$C1,$FF,$C0,$FF,$C0
	DC.B	$FF,$C0,$FF,$C0,$FF,$C0,$FF,$C0
	DC.B	$FF,$C0,$FF,$C0,$FF,$C0,$FF,$C0
	DC.B	$FF,$C0,$FF,$C0,$FF,$C0,$FF,$C0
	DC.B	$FF,$C0,$FF,$C0,$FF,$C0,$FF,$C0
	DC.B	$FF,$C0,$FF,$C1,$FF,$C1,$FF,$C1
	DC.B	$FF,$C1,$FF,$C1,$FF,$C1,$FF,$C1
	DC.B	$FF,$C1,$FF,$C2,$FF,$C2,$FF,$C2
	DC.B	$FF,$C2,$FF,$C2,$FF,$C3,$FF,$C3
	DC.B	$FF,$C3,$FF,$C3,$FF,$C4,$FF,$C4
	DC.B	$FF,$C4,$FF,$C4,$FF,$C5,$FF,$C5
	DC.B	$FF,$C5,$FF,$C6,$FF,$C6,$FF,$C6
	DC.B	$FF,$C7,$FF,$C7,$FF,$C8,$FF,$C8
	DC.B	$FF,$C8,$FF,$C9,$FF,$C9,$FF,$CA
	DC.B	$FF,$CA,$FF,$CA,$FF,$CB,$FF,$CB
	DC.B	$FF,$CC,$FF,$CC,$FF,$CD,$FF,$CD
	DC.B	$FF,$CE,$FF,$CE,$FF,$CF,$FF,$CF
	DC.B	$FF,$D0,$FF,$D0,$FF,$D1,$FF,$D1
	DC.B	$FF,$D2,$FF,$D2,$FF,$D3,$FF,$D4
	DC.B	$FF,$D4,$FF,$D5,$FF,$D5,$FF,$D6
	DC.B	$FF,$D7,$FF,$D7,$FF,$D8,$FF,$D8
	DC.B	$FF,$D9,$FF,$DA,$FF,$DA,$FF,$DB
	DC.B	$FF,$DC,$FF,$DC,$FF,$DD,$FF,$DE
	DC.B	$FF,$DE,$FF,$DF,$FF,$E0,$FF,$E0
	DC.B	$FF,$E1,$FF,$E2,$FF,$E3,$FF,$E3
	DC.B	$FF,$E4,$FF,$E5,$FF,$E5,$FF,$E6
	DC.B	$FF,$E7,$FF,$E8,$FF,$E8,$FF,$E9
	DC.B	$FF,$EA,$FF,$EB,$FF,$EB,$FF,$EC
	DC.B	$FF,$ED,$FF,$EE,$FF,$EF,$FF,$EF
	DC.B	$FF,$F0,$FF,$F1,$FF,$F2,$FF,$F2
	DC.B	$FF,$F3,$FF,$F4,$FF,$F5,$FF,$F6
	DC.B	$FF,$F6,$FF,$F7,$FF,$F8,$FF,$F9
	DC.B	$FF,$FA,$FF,$FA,$FF,$FB,$FF,$FC
	DC.B	$FF,$FD,$FF,$FE,$FF,$FE,$FF,$FF
ENDSINY:	


	CNOP	0,4
	
;*****************************
;*			     *
;*      COPPER1 PROGRAM      *
;*			     *
;*****************************

COPLIST:
	dc.w $0104,$0004
	dc.w $0100,$2200
	dc.w $0108,0040
	dc.w $010a,0040
	dc.w $0092,$0038
	dc.w $0094,$00d0
	dc.w $008e,$2c81
	dc.w $0090,$2cc1
pointers:
	dc.w $00e0,$0007
	dc.w $00e2,$0000
	dc.w $00e4,$0007
	dc.w $00e6,$0000
		
	;dc.w $0180,$0fff
colors:
	dc.w $0180,$0000
	dc.w $0182,$0f00
	dc.w $0184,$0c00
	dc.w $0186,$0a00
	dc.w $0188,$0800
	dc.w $018a,$0700
	dc.w $018c,$0600
	dc.w $018e,$0500
	
	dc.w $0102,$0000
	dc.w $0180,$0006
	
	dc.w $ffff,$fffe



