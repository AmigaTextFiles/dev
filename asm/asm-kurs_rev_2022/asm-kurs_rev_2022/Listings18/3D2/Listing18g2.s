
; Listing18g2.s = VECTOR-LOGOFX4.S

;************************************************
;*	    VECTORLINES 2.0		        *
;*					        *
;*  Coder: EXECUTOR			        *
;************************************************
;se si usano piu' oggetti, ricordarsi di inserire il loro indirizzo
;nella routine per calcolare gli offsets interni dei vettori


;>EXTERN	"df1:ramjamlogo.l",EOBJCOORDSTABLE

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

	;JMP	$50000
	
	
	;ORG	$50000
	;LOAD	$50000
	

ESTART:
	MOVEM.L	D0-D7/A0-A6,-(A7)	; Put registers on stack
	BSR	EDEMOIRQ			; demo irq
	bsr	Eclearscreen68000
	bsr	MakeLinePoints
	bsr	Edoubleset	
	bsr	Emovement		; to load right values in regs....
	
*******Here There is your code*********

;LOOP:

EWAITbeam:
	bsr	EWaitOF
	bsr	Edoubleset2
	bsr	Edoubleset

	bsr Emovement
	bsr Econversion
	bsr Eclearscreen
	bsr Ereconversion
	bsr Eline
	bsr Efillscreen

;	move.w #$0fff,$dff180
	btst #$06,$bfe001
	bne Ewaitbeam
	

***************************************
EEND:

	BSR	ESYSTEMIRQ		; system irq
	MOVEM.L	(A7)+,D0-D7/A0-A6	; Get registers from stack
	MOVEQ.L	#$00,d0
	RTS

;***********************************
;*   CLOSE ALL SYSTEM INTERRUPTS   *
;*				 *
;*      START DEMO INTERRUPTS      *
;***********************************
EDEMOIRQ:
	MOVE.L	$4.W,A6			; Exec pointer to A6
	LEA.L	EGfxName(PC),A1		; Set library pointer
	MOVEQ	#0,D0
	JSR	OldOpenLibrary(A6)	; Open graphics.library
	MOVE.L	D0,A1			; Use Base-pointer
	MOVE.L	$26(A1),EOLDCOP1		; Store copper1 start addr
	MOVE.L	$32(A1),EOLDCOP2		; Store copper1 start addr
	JSR	CloseLibrary(A6)	; Close graphics library

	MOVE.W	$DFF01C,EINTENA		; Store old INTENA
	MOVE.W	$DFF002,EDMACON		; Store old DMACON
	MOVE.W	$DFF010,EADKCON		; Store old ADKCON

	MOVE.W	#$7FFF,$DFF09A		; Clear interrupt enable

	BSR.L	EWAITOF

	MOVE.W	#$7FFF,$DFF096		; Clear DMA channels
	MOVE.L	#ECOPLIST,$DFF080	; Copper1 start address
	MOVE.W	#DMASET!$8200,$DFF096	; DMA kontrol data
	MOVE.L	$6C.W,EOldIrq3		; Store old inter pointer
	MOVE.L	#EIRQ3,$6C.W		; Set interrupt pointer

	MOVE.W	#$7FFF,$DFF09C		; Clear request
	MOVE.W	#$C020,$DFF09A		; Interrupt enable
	RTS
	
;*****************************************
;*					 *
;*   RESTORE SYSTEM INTERRUPTS ECT ECT   *
;*					 *
;*****************************************
ESYSTEMIRQ:
	MOVE.W	#$7FFF,$DFF09A		; Disable interrupts

	BSR.L	EWAITOF

	MOVE.W	#$7FFF,$DFF096
	MOVE.L	EOldCop1(PC),$DFF080	; Restore old copper1
	MOVE.L	EOldCop2(PC),$DFF084	; Restore old copper1
	MOVE.L	EOldIrq3(PC),$6C.W	; Restore inter pointer
	MOVE.W	EDMACON,D0		; Restore old DMACON
	OR.W	#$8000,D0
	MOVE.W	D0,$DFF096		
	MOVE.W	EADKCON,D0		; Restore old ADKCON
	OR.W	#$8000,D0
	MOVE.W	D0,$DFF09E
	MOVE.W	EINTENA,D0		; Restore inter data
	OR.W	#$C000,D0
	MOVE.W	#$7FFF,$DFF09C
	MOVE.W	D0,$DFF09A
	RTS
	
;*** DATA AREA ***

EGfxName		DC.B	'graphics.library',0
		even
EOldIrq3		DC.L	0
EOldCop1		DC.L	0
EOldCop2		DC.L	0
EINTENA		DC.W	0
EDMACON		DC.W	0
EADKCON		DC.W	0

;**********************************
;*				  *
;*    INTERRUPT ROUTINE. LEVEL 3  *
;*				  *
;**********************************

EIRQ3:
	MOVEM.L	D0-D7/A0-A6,-(A7)	; Put registers on stack

	MOVE.W	#$4020,$DFF09C		; Clear interrupt request
	MOVEM.L	(A7)+,D0-D7/A0-A6	; Get registers from stack
	RTE

;**********************************
EWAITOF:
	move.l	$dff004,d2		;Wait the start of the vertirq
	and.l	#$0001ff00,d2		;and the start of the video scan
	cmp.l	#$00012000,d2
	beq	EWAITOFE
	bra	EWAITOF
EWAITOFE:
	rts
;**********************************
	
*********************************************
;	   3D  ROUTINES
*********************************************


Ewaitblit:
	btst #$0e,$dff002
	bne.s Ewaitblit
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


Escreen: dc.l $70000,$72800,$75000,$77800,$7a000,$7c800

; SCHERMI ALLOCATI A $70000 

MAKELINEPOINTS:
sl2:    moveq #00,d0
        lea yposmat,a1
yposloop:
        move.l #$0000,a0
        move.l d0,d1
        mulu #40,d1
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
	


Eclearscreen68000:
	clr.l $0
	lea $70000,a1
	move.w #$3fff,d0
Eclearloop:
	clr.l (a1)+
	dbf d0,Eclearloop
	rts
	

Escriptloc:      dc.l Efunzinescript

;A = x,y,z,rotx,roty,rotz	   set start coordinates
;B = xadd,yadd,zadd,rotxadd,rotyadd,rotzadd,times to repeat    modify
;C = resmod,fadd,object,lines,palette    set a new object
; modulo schermo,modulo totale (rasterscreen)
;D = frompalette,topalette	  fade from 1 to 2
;Z = address			goto.....

Eefxcounter:
	dc.w	0
	

Exadd:   dc.w 0
Eyadd:   dc.w 0
Ezadd:   dc.w 0
Erotxinc:dc.w 0
Erotyinc:dc.w 0
Erotzinc:dc.w 0

*********************************************
;       SCRIPT DEI MOVIMENTI DEI SOLIDI

Efunzinescript:

	dc.w 'C'
	DC.L EOBJCOORDSTABLE
	DC.W 'A',164,128,-6370,0,0,0
	DC.W 'B',0,0,33,2,0,0,180
	DC.W 'B',0,0,0,2,0,0,720
	DC.W 'B',0,0,0,0,0,3,240
	DC.W 'B',0,0,-10,0,2,0,320

	dc.w 'Z'
	dc.l EFUNZINESCRIPT
	
Escriptefx:
	dc.l Estartcoords,Emodify,Edefineobj

Emovement:
	tst.w	Eefxcounter
	bne.s	Emovement2
	bra.L	Escriptreader
Emovement2:
	subq.w	#1,Eefxcounter
	lea.l	EOBJPOS,a0

	lea	Exadd,a1
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
	blt.s	Erot1
	sub.w	#360,(a0)
Erot1:   tst.w	(a0)
	bpl.s	Erot12
	add.w	#360,(a0)

Erot12:  add.w	d4,2(a0)
	cmp.w	#360,2(a0)
	blt.s	Erot2
	sub.w	#360,2(a0)
Erot2:   tst.w	2(a0)
	bpl.s	Erot22
	add.w	#360,2(a0)

Erot22:  add.w	d5,4(a0)
	cmp.w	#360,4(a0)
	blt.s	Erot3
	sub.w	#360,4(a0)
Erot3:   tst.w	4(a0)
	bpl.s	Erot33
	add.w	#360,4(a0)

Erot33:
	rts

Escriptreader:
	move.l	Escriptloc,a0
	cmp.w	#'Z',(a0)
	beq.L	Escriptgoto
	lea	Escriptefx,a1
	move.w	(a0),d0
	sub.w	#65,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,a1
	move.l	(a1),a3
	jmp	(a3)
	bra	Emovement
	rts

Escriptgoto:
	move.l	2(a0),Escriptloc
	bra	Escriptreader
	rts     

Estartcoords:
	addq.l	#2,a0
	lea.l	EOBJPOS,a2
	move.w	6(a0),(a2)
	move.w	8(a0),2(a2)
	move.w	10(a0),4(a2)
	tst.w	(a0)
	beq	Esc1
	move.w	(a0),6(a2)
Esc1:    tst.w	2(a0)
	beq	Esc2
	move.w	2(a0),8(a2)
Esc2:    tst.w	4(a0)
	beq	Esc3
	move.w	4(a0),10(a2)
Esc3:    add.l	#12,a0 
	move.l	a0,Escriptloc
	bra	Escriptreader
	rts
Emodify:
	addq.l	#2,a0
	lea	Exadd,a2
	move.w	(a0),(a2)
	move.w	2(a0),2(a2)
	move.w	4(a0),4(a2)
	move.w	6(a0),6(a2)
	move.w	8(a0),8(a2)
	move.w	10(a0),10(a2)
	move.w	12(a0),Eefxcounter
	add.l	#14,a0    
	move.l	a0,Escriptloc
	bra	Emovement
	rts

Edefineobj:
	move.l	2(a0),a1
	move.l	4(a1),a2
	move.l	8(a1),a3
	add.l	#4,a1
	add.l	a1,a2
	add.l	a1,a3
	move.l	a2,EOBJCOORDS
	move.l	a3,EOBJCOORDS+4
	add.l	#6,a0
	move.l	a0,Escriptloc
	bra	Escriptreader
	rts

Edoubleset:
	lea	Epointers,a2
	move.l	Escreen+4,d3
	add.l	#12*40,d3
	move.w	d3,6(a2)
	swap	d3
	move.w	d3,2(a2)

	move.l	Escreen+8,d3
	add.l	#12*40,d3
	move.w	d3,14(a2)
	swap	d3
	move.w	d3,10(a2)

	move.l	Escreen+12,d3
	add.l	#12*40,d3
	move.w	d3,22(a2)
	swap	d3
	move.w	d3,18(a2)

	move.l	Escreen+16,d3
	add.l	#12*40,d3
	move.w	d3,30(a2)
	swap	d3
	move.w	d3,26(a2)

	move.l	Escreen+20,d3
	add.l	#12*40,d3
	move.w	d3,38(a2)
	swap	d3
	move.w	d3,34(a2)

	rts

Edoubleset2:
	lea	Escreen,a1
	move.l	(a1),a0
	move.l	4(a1),(a1)
	move.l	8(a1),4(a1)
	move.l	12(a1),8(a1)
	move.l	16(a1),12(a1)
	move.l	20(a1),16(a1)
	move.l	a0,20(a1)

	rts



**********************************


Econversion:
	lea	EOBJCOORDS,a5
	move.l	(a5),a5
	
	
	lea	EOBJPOS,a0
	lea	Ematsin,a1

	lea	EOBJTABLE1,a6
Emasterrotaction:

	move.w	(a0),d0	
	add.w	d0,d0
	lea	(a1,d0.w),a4	; sin(x)

	move.w	2(a0),d0
	add.w	d0,d0
	LEA	(A1,D0.W),A2	; sin(y)

	move.w	4(a0),d0
	add.w	d0,d0
	LEA	(a1,d0.w),A1	; sin(z)
	
	move.w	(a5)+,d7
	subq.w	#1,d7
		
Econvloop:
	move.w	(a5),d1
	move.w	2(a5),d2
	move.w	4(a5),d3
	add.w	#6,a5

Erotxz:  tst.w	(a0)
	beq.s	Erotxy
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
Erotxy:  tst.w	2(a0)
	beq.s	Erotyz
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

Erotyz:  tst.w	4(a0)
	beq.s	Erotend
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
Erotend:
	add.w	Eobjpos+10,d3
	movem.w	d1-d3,(a6)
	addq.l	#8,a6
	dbf	d7,Econvloop
	move.w	#$7fff,(a6)
	rts



Ereconversion:

	lea	EOBJTABLE1,a0
	lea	EOBJPOS,a3
	lea	EOBJTABLE2,a5

Ereconvloop:
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

Edpointsloop:
	move.w	d1,(a5)+
	move.w	d2,(a5)+

	add.w	#8,a0	
	cmp.w	#$7fff,(a0)
	bne	Ereconvloop
	rts

Ematsin:

       dc.w       0,572,1144,1715,2286,2856,3425,3993,4560,5126,5690,6252
       dc.w       6813,7371,7927,8481,9032,9580,10126,10668,11207,11743,12275,12803
       dc.w       13328,13848,14364,14876,15383,15886,16383,16876,17364,17846,18323,18794
       dc.w       19260,19720,20173,20621,21062,21497,21925,22347,22762,23170,23571,23964
       dc.w       24351,24730,25101,25465,25821,26169,26509,26841,27165,27481,27788,28087
       dc.w       28377,28659,28932,29196,29451,29697,29934,30162,30381,30591,30791,30982
       dc.w       31163,31335,31498,31650,31794,31927,32051,32165,32269,32364,32448,32523
       dc.w       32588,32642,32687,32722,32747,32762,32767,32762,32747,32722,32687,32642
       dc.w       32588,32523,32448,32364,32269,32165,32051,31927,31794,31650,31498,31335
       dc.w       31163,30982,30791,30591,30381,30162,29934,29697,29451,29196,28932,28659
       dc.w       28377,28087,27788,27481,27165,26841,26509,26169,25821,25465,25101,24730
       dc.w       24351,23964,23571,23170,22762,22347,21925,21497,21062,20621,20173,19720
       dc.w       19260,18794,18323,17846,17364,16876,16384,15886,15383,14876,14364,13848
       dc.w       13328,12803,12275,11743,11207,10668,10126,9580,9032,8481,7927,7371
       dc.w       6813,6252,5690,5126,4560,3993,3425,2856,2286,1715,1144,572
       dc.w       0,-571,-1143,-1714,-2285,-2855,-3425,-3993,-4560,-5125,-5689,-6252
       dc.w       -6812,-7370,-7927,-8480,-9031,-9580,-10125,-10667,-11206,-11742,-12274,-12803
       dc.w       -13327,-13847,-14364,-14875,-15383,-15885,-16383,-16876,-17363,-17846,-18323,-18794
       dc.w       -19259,-19719,-20173,-20620,-21062,-21497,-21925,-22347,-22761,-23169,-23570,-23964
       dc.w       -24350,-24729,-25100,-25464,-25820,-26168,-26509,-26841,-27165,-27480,-27787,-28086
       dc.w       -28377,-28658,-28931,-29195,-29450,-29696,-29934,-30162,-30381,-30590,-30790,-30981
       dc.w       -31163,-31335,-31497,-31650,-31793,-31927,-32050,-32164,-32269,-32363,-32448,-32522
       dc.w       -32587,-32642,-32687,-32722,-32747,-32762,-32767,-32762,-32747,-32722,-32687,-32642
       dc.w       -32587,-32522,-32448,-32363,-32269,-32164,-32050,-31927,-31793,-31650,-31497,-31335
       dc.w       -31163,-30981,-30790,-30590,-30381,-30162,-29934,-29696,-29450,-29195,-28931,-28658
       dc.w       -28377,-28086,-27787,-27480,-27165,-26841,-26509,-26168,-25820,-25464,-25100,-24729
       dc.w       -24350,-23964,-23570,-23169,-22761,-22347,-21925,-21497,-21062,-20620,-20173,-19719
       dc.w       -19259,-18794,-18323,-17846,-17363,-16876,-16383,-15885,-15383,-14875,-14364,-13847
       dc.w       -13327,-12803,-12274,-11742,-11206,-10667,-10125,-9580,-9031,-8480,-7927,-7370
       dc.w       -6812,-6252,-5689,-5125,-4560,-3993,-3425,-2855,-2285,-1714,-1143,-571
       dc.w       0,572,1144,1715,2286,2856,3425,3993,4560,5126,5690,6252
       dc.w       6813,7371,7927,8481,9032,9580,10126,10668,11207,11743,12275,12803
       dc.w       13328,13848,14364,14876,15383,15886,16383,16876,17364,17846,18323,18794
       dc.w       19260,19720,20173,20621,21062,21497,21925,22347,22762,23170,23571,23964
       dc.w       24351,24730,25101,25465,25821,26169,26509,26841,27165,27481,27788,28087
       dc.w       28377,28659,28932,29196,29451,29697,29934,30162,30381,30591,30791,30982
       dc.w       31163,31335,31498,31650,31794,31927,32051,32165,32269,32364,32448,32523
       dc.w       32588,32642,32687,32722,32747,32762,32767,32762,32747,32722,32687,32642
       dc.w       32588,32523,32448,32364,32269,32165,32051,31927,31794,31650,31498,31335
       dc.w       31163,30982,30791,30591,30381,30162,29934,29697,29451,29196,28932,28659
       dc.w       28377,28087,27788,27481,27165,26841,26509,26169,25821,25465,25101,24730
       dc.w       24351,23964,23571,23170,22762,22347,21925,21497,21062,20621,20173,19720
       dc.w       19260,18794,18323,17846,17364,16876,16384,15886,15383,14876,14364,13848
       dc.w       13328,12803,12275,11743,11207,10668,10126,9580,9032,8481,7927,7371
       dc.w       6813,6252,5690,5126,4560,3993,3425,2856,2286,1715,1144,572
       dc.w       0,-571,-1143,-1714,-2285,-2855,-3425,-3993,-4560,-5125,-5689,-6252
       dc.w       -6812,-7370,-7927,-8480,-9031,-9580,-10125,-10667,-11206,-11742,-12274,-12803
       dc.w       -13327,-13847,-14364,-14875,-15383,-15885,-16383,-16876,-17363,-17846,-18323,-18794
       dc.w       -19259,-19719,-20173,-20620,-21062,-21497,-21925,-22347,-22761,-23169,-23570,-23964
       dc.w       -24350,-24729,-25100,-25464,-25820,-26168,-26509,-26841,-27165,-27480,-27787,-28086
       dc.w       -28377,-28658,-28931,-29195,-29450,-29696,-29934,-30162,-30381,-30590,-30790,-30981
       dc.w       -31163,-31335,-31497,-31650,-31793,-31927,-32050,-32164,-32269,-32363,-32448,-32522
       dc.w       -32587,-32642,-32687,-32722,-32747,-32762,-32767,-32762,-32747,-32722,-32687,-32642
       dc.w       -32587,-32522,-32448,-32363,-32269,-32164,-32050,-31927,-31793,-31650,-31497,-31335
       dc.w       -31163,-30981,-30790,-30590,-30381,-30162,-29934,-29696,-29450,-29195,-28931,-28658
       dc.w       -28377,-28086,-27787,-27480,-27165,-26841,-26509,-26168,-25820,-25464,-25100,-24729
       dc.w       -24350,-23964,-23570,-23169,-22761,-22347,-21925,-21497,-21062,-20620,-20173,-19719
       dc.w       -19259,-18794,-18323,-17846,-17363,-16876,-16383,-15885,-15383,-14875,-14364,-13847
       dc.w       -13327,-12803,-12274,-11742,-11206,-10667,-10125,-9580,-9031,-8480,-7927,-7370
       dc.w       -6812,-6252,-5689,-5125,-4560,-3993,-3425,-2855,-2285,-1714,-1143,-571



Eclearscreen:
	bsr	Ewaitblit
	lea	$dff000,a0
	move.l	#$01000000,bltcon0(a0)
	move.l	Escreen,a1
	add.l	#48*40,a1
	move.l	a1,bltdpth(a0)
	move.w	#$0000,bltdmod(a0)
	move.w	#160*64+20,bltsize(a0)
	rts


Eline:   
	bsr	EwaitBlit
	
        lea	$dff000,a0
        move.w	#40,bltcmod(a0)
        move.w	#40,bltdmod(a0)
        move.l	Escreen,bltcpth(a0)
        move.l	Escreen,bltdpth(a0)
        move.l	#$ffffffff,bltamk1(a0) 
        move.w	#$8000,bltadat(a0)
        move.w	#$ffff,bltbdat(a0)

        lea	yposmat,a3  
        lea	xposmat,a4
	lea	EOBJTABLE2,a5
	move.l	EOBJCOORDS+4,a6	
	move.w	(a6)+,d7
	subq.w	#1,d7
lineloop3:
	move.w	(a6)+,d5
	move.w	(a6)+,d6
	lsl.w	#2,d5
	lsl.w	#2,d6
	move.w	(a5,d5.w),d1
	move.w	2(a5,d5.w),d3
	move.w	(a5,d6.w),d2
	move.w	2(a5,d6.w),d4

	movem.l	d7/a5/a6,-(a7)
	bsr	LineStart
	movem.l	(a7)+,d7/a5/a6
	dbf	d7,lineloop3
	rts

****************************************

LineStart:
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
        move.l	Escreen,a5
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
        bpl.s	sign
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
        btst	#$0e,2(a0)
        bne.s	corr

        bchg	d1,(a6)
        move.w	d3,bltamod(a0);4(y-x)
        move.w	d6,bltcon1(a0);octant
        move.w	d4,bltbmod(a0);4y
        move.w	d5,bltaptl(a0);2y-x
        move.w	a5,bltcptl(a0)
        move.w	a5,bltdptl(a0)
        move.w	2(a4,d0.w),bltcon0(a0)
        move.w	d2,bltsize(a0);xlenght

	rts
	
Efillscreen:
        bsr	Ewaitblit
        lea	$dff000,a0
	move.l	#$ffffffff,bltamk1(a0)
        move.l	#$09f00012,bltcon0(a0)
        move.l	Escreen,a1
	add.l	#40*208,a1
        move.l	a1,bltdpth(a0)
	move.l	a1,bltapth(a0)
        move.w	#$0000,bltdmod(a0)
        move.w	#$0000,bltamod(a0)
        move.w	#160*64+20,bltsize(a0)
        rts


;OBJECT DATA STRUCTURE------------------------------------------------

	
EOBJCOORDS:
	dc.l	EOBJCOORDSTABLE,EOBJCOORDSTABLE+1024
;	questi sono gli indirizzi dell'oggetto

EOBJPOS:
	dc.w	100,50,100		;xrot,yrot,zrot
	dc.w	160,100,-200		;xpos,ypos,zpos
	dc.w	0,0,0
	dc.w	0,0,0
	
EOBJCOLOR:
	dc.l	0
	
EOBJTABLE1:
	blk.b	1024,0
EOBJTABLE2:
	blk.b	1024,0


EOBJCOORDSTABLE:
;	blk.b	1456,0		;load here your object
	incbin "ramjamlogo.l"	;>EXTERN	"df1:ramjamlogo.l",EOBJCOORDSTABLE

xposmat:
	blk.l 900,0
yposmat:
	blk.l 700,0

	


	CNOP	0,4
	
;*****************************
;*			     *
;*      COPPER1 PROGRAM      *
;*			     *
;*****************************

ECOPLIST:
	dc.w $0104,$0004
	dc.w $0100,$5200
	dc.w $0108,0000
	dc.w $010a,0000
	dc.w $0092,$0038
	dc.w $0094,$00d0
	dc.w $008e,$3481
	dc.w $0090,$1cc1
Epointers:
	dc.w $00e0,$0000
	dc.w $00e2,$0000
	dc.w $00e4,$0000
	dc.w $00e6,$0000
	dc.w $00e8,$0000
	dc.w $00ea,$0000
	dc.w $00ec,$0000
	dc.w $00ee,$0000
	dc.w $00f0,$0000
	dc.w $00f2,$0000
		

	dc.w $0102,$0000
	dc.w $0180,$0006


Ecolors:
	dc.w $0182,$0335
	dc.w $0184,$0335
	dc.w $0186,$0668
	dc.w $0188,$0335
	dc.w $018a,$0668
	dc.w $018c,$0668
	dc.w $018e,$099b
	dc.w $0190,$0335
	dc.w $0192,$0668
	dc.w $0194,$0668
	dc.w $0196,$099b
	dc.w $0198,$0668
	dc.w $019a,$099b
	dc.w $019c,$099b
	dc.w $019e,$0cce
	dc.w $01a0,$0335
	dc.w $01a2,$0668
	dc.w $01a4,$0668
	dc.w $01a6,$099b
	dc.w $01a8,$0668
	dc.w $01aa,$099b
	dc.w $01ac,$099b
	dc.w $01ae,$0cce
	dc.w $01b0,$0668
	dc.w $01b2,$099b
	dc.w $01b4,$099b
	dc.w $01b6,$0cce
	dc.w $01b8,$099b
	dc.w $01ba,$0cce
	dc.w $01bc,$0cce
	dc.w $01be,$0eef
		

	dc.w $3409,$fffe
	dc.w $0180,$0fff
	dc.w $3509,$fffe
	dc.w $0180,$0000
	dc.w $ffdf,$fffe
	dc.w $1c09,$fffe
	dc.w $0180,$0fff
	dc.w $1d09,$fffe
	dc.w $0180,$0006
	

	dc.w $ffff,$fffe


