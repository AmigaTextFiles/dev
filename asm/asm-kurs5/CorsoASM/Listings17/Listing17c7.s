; Listing17c7.s = BluePlasma.S
; Plasma 2 bitplanes - Autor des Originals: unbekannt
;
; Geändert / Behoben by Randy/Ram Jam in 1995

	SECTION prg,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

;*****************************************************************************
	incdir ""
	include	"startup2.s"		; speichern copperlist etc.
;*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA

WaitDisk	EQU	10

width	= 48
depth	= 320
fspeed	= 100

START:
	bsr.w	make_stable			; sintable

	bsr.w	setup_copcols		; copperlist

	move.l	#pic,d0
	move.w	d0,pl0l
	swap	d0
	move.w	d0,pl0h
	move.l	#wind,d0
	move.w	d0,pl1l
	swap	d0
	move.w	d0,pl1h

	move.l	#pic+(40*40)+6,marker
	clr.w	effectstage

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper

	move.w	#0,$64(a5)			; bltamod
	move.w	#4*(width+2)-2,$66(a5)	; bltdmod
	move.l	#$09f00000,$40(a5)	; bltcon0/1
	move.l	#-1,$44(a5)			; bltfwm/lwm

	bsr.s	fadeeffect			; alles initialisieren (wie man 1 Schleife macht)
	bsr.w	sine_vert			; Vertikaler Sinus mit Blitter-Schleife
	bsr.w	sine_horiz			; bplcon1 in der Copperlist mit der CPU modifizieren 

	move.l	#newcopper,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

loop:
	MOVE.L	#$1ff00,d1			; Bits durch UND auswählen
	MOVE.L	#$0e000,d2			; warte auf Zeile $e0
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $e0
	BNE.S	Waity1

	bsr.s	fadeeffect			; Effekt wählen
	bsr.w	sine_vert			; Vertikaler Sinus mit Blitter-Schleife
	bsr.w	sine_horiz			; bplcon1 in der Copperlist mit der CPU modifizieren 

	btst #6,$bfe001				; Maus gedrückt?
	bne.s loop
	RTS							; exit


mempty:
	dc.l memory1


;*****************************************************************************
;	Ändern der Effekte gemäß der Liste.
;*****************************************************************************

fadeeffect:
	move.w	effectstage(PC),d0
	lea	oldeffect(PC),a0
	move.l	neweffect(PC),a1
	lea	thiseffect(PC),a2
	moveq	#4-1,d7
nextelement:
	move.w	(a0)+,d1
	move.w	(a1)+,d2
	move.w	d2,d3
	sub.w	d1,d3
	muls.w	d0,d3
	divs.w	#fspeed,d3
	add.w	d3,d1
	move.w	d1,(a2)+
	dbra	d7,nextelement

	cmp.w	#fspeed,effectstage
	beq.s	nexteffect
	addq.w	#1,effectstage
	rts

nexteffect:
	lea	thiseffect(PC),a0
	lea	oldeffect(PC),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	add.l	#4*2,neweffect
	clr.w	effectstage
	move.l	neweffect(PC),a0
	cmp.w	#$ffff,(a0)
	beq.s	firsteffect
	rts

firsteffect:
	move.l	#effectlist,neweffect
	rts

;*****************************************************************************

setup_copcols:
	lea	copcols,a0				; Farbe in coplist
	move.w	#$4039,d2			; wait
	move.w	#(depth/2)-1,d7
sc_loop1:
	move.w	#(width/2)-1,d6
	move.w	#$102,(a0)+			; dff102 bplcon1
	move.w	d7,(a0)+
	move.w	d2,(a0)				; Wait erstes word
	addq.w	#1,a0				; zweites byte (pos. XX)
	bset.b	#0,(a0)+
	add.w	#$0100,d2			; Wait 1 Zeile tiefer
	move.w	#$fffe,(a0)+		; wait zweites word
sc_loop2:
	move.w	#$186,(a0)+			; Color3
	clr.w	(a0)+
	move.w	#$184,(a0)+			; Color2
	clr.w	(a0)+
	dbra	d6,sc_loop2
	dbra	d7,sc_loop1
	rts


;*****************************************************************************
;    Bearbeiten Sie bplcon1 ($dff102) in der copperliste für horizontales Scrollen
;*****************************************************************************

sine_horiz:
	move.w	chanh(PC),d6
	add.w	d6,kstageh
	move.w	kstageh(PC),d0
	move.w	disph(PC),d1
	move.w	#$7ffe,d2
	lea	copcols+1+4,a0
	move.l 	mempty(PC),a1
	move.w	#(depth/2)-1,d7
loop_sh:
	add.w	d1,d0
	and.w	d2,d0
	move.w	(a1,d0.w),d6
	move.w	d6,d5
	lsr.b	#1,d5
	and.w	#$0f,d5
	move.w	d5,-3(a0)
	lsr.w	#3,d6
	add.w	d6,d6
	add.w	#$17,d6
	move.b	d6,(a0)
	lea	4*(width+2)(a0),a0
	dbra	d7,loop_sh
	rts

;*****************************************************************************
;		 Vertikaler Sinus mit Blitt-Schleife
;*****************************************************************************

sine_vert:	
	move.w	chan(PC),d6
	add.w	d6,kstage
	move.w	kstage(PC),d0
 	move.w	disp(PC),d1
	lea	copcols+6+4,a0
	move.l 	mempty(PC),a1		; sintab
	lea	colors,a2
	move.w	#width-1,d7
loop_sv:
	add.w	d1,d0
	and.w	#$7ffe,d0
	move.w	(a1,d0.w),d6		; sin
	add.w	d6,d6
	lea	(a2,d6.w),a3
	btst	#6,$02(a5)			; DmaConr
abwait
	btst	#6,$02(a5)			; DmaConr - WaitBlit
	bne.s	abwait
	move.l	a3,$50(a5)			; BltApt
	move.l	a0,$54(a5)			; BltDpt
	move.w	#64*depth/2+2/2,$58(a5)	; bltsize
	addq.w	#4,a0
	dbra	d7,loop_sv
	rts

;*****************************************************************************
; Diese Routine erstellt eine SinTab
;*****************************************************************************

make_stable:
	move.l	mempty(PC),a0
	move.w	#$ffff/4,d7			; 16384 words, das sind 32768 bytes
	moveq	#0,d6
ms_more:
	move.w	d6,d0
	addq.w	#4,d6
	bsr.s	get_sine
	move.w	d0,(a0)+
	dbra	d7,ms_more
	rts

get_sine:
	movem.l	d1-d7/a0-a6,-(a7)
	and.l	#$ffff,d0
	move.w	d0,d3
	bclr	#15,d0
	move.w	#$7fff,d1
	sub.w	d0,d1
	mulu.w	d1,d0
	lsr.l	#8,d0
	lsr.l	#5,d0
	btst	#15,d3
	beq.b	highbump
	neg.w	d0
	subq.w	#1,d0
highbump:
	add.w	#$8000,d0
	divu.w	#380,d0
	movem.l	(a7)+,d1-d7/a0-a6
	rts

;*****************************************************************************

marker:
	dc.l 0


effectstage:
	dc.w	0

thiseffect:
chan:
	dc.w	0
disp:
	dc.w	0
chanh:
	dc.w	0
disph:
	dc.w	0
oldeffect:
	dcb.w	4,0
neweffect:
	dc.l	effectlist

effectlist:

	; Reihenfolge
	; 3	Sinusgeschwindigkeit runter
	; 4	Sinusgeschwindigkeit aufwärts

;	dc.w	100,-500,-100,100
;	dc.w	200,-500,-200,200
;	dc.w	300,-500,-300,300
;	dc.w	400,-500,-400,400
;	dc.w	500,-500,-500,500
;	dc.w	600,-500,-600,600
;	dc.w	700,-500,-700,700

;	dc.w	800,-400,600,500
;	dc.w	600,500,-500,300
;	dc.w	400,600,900,400
;	dc.w	-800,400,-200,500
	dc.w	-500,300,600,600
	dc.w	400,500,-400,400
	dc.w	-100,400,800,800
	dc.w	400,500,-400,1400
;	dc.w	-400,600,-300,500
;	dc.w	600,300,400,900
;	dc.w	-400,500,-500,1000
	dc.w	$ffff,$ffff,$ffff,$ffff

nexttosave
	dc.l	effect_store

effect_store:
	ds.w	4*200

kstage:
	dc.w	0
kstage2:
	dc.w	0
kstageh:
	dc.w	0

;*****************************************************************************
;	 Word Farbe $0RGB blitt in copperlist
;*****************************************************************************

	Section	RobaInChip,data_C

colors:
	dc.w 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w 1,1,1,1,1,1,2,1,2,2,2,2,2,2,3,2
	dc.w 3,3,3,3,3,3,4,3,4,4,4,4,4,4,5,4
	dc.w 5,5,5,5,5,5,6,5,6,6,6,6,6,6,7,6
	dc.w 7,7,7,7,7,7,8,7,8,8,8,8,8,8,9,8
	dc.w 9,9,9,9,9,9,$a,9,$a,$a,$a,$a,$a,$a,$b,$a
	dc.w $b,$b,$b,$b,$b,$b,$c,$b,$c,$c,$c,$c,$c,$c,$d,$c
	dc.w $d,$d,$d,$d,$d,$d,$e,$d,$e,$e,$e,$e,$e,$e,$f,$e
	dc.w $f,$f,$f,$f,$f,$f,$f,$f,$e,$f,$e,$e,$e,$e,$e,$e
	dc.w $d,$e,$d,$d,$d,$d,$d,$d,$c,$d,$c,$c,$c,$c,$c,$c
	dc.w $b,$c,$b,$b,$b,$b,$b,$b,$a,$b,$a,$a,$a,$a,$a,$a
	dc.w 9,$a,9,9,9,9,9,9,8,9,8,8,8,8,8,8
	dc.w 7,8,7,7,7,7,7,7,6,7,6,6,6,6,6,6
	dc.w 5,6,5,5,5,5,5,5,4,5,4,4,4,4,4,4
	dc.w 3,4,3,3,3,3,3,3,2,3,2,2,2,2,2,2
	dc.w 1,2,1,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w 1,1,1,1,1,1,2,1,2,2,2,2,2,2,3,2
	dc.w 3,3,3,3,3,3,4,3,4,4,4,4,4,4,5,4
	dc.w 5,5,5,5,5,5,6,5,6,6,6,6,6,6,7,6
	dc.w 7,7,7,7,7,7,8,7,8,8,8,8,8,8,9,8
	dc.w 9,9,9,9,9,9,$a,9,$a,$a,$a,$a,$a,$a,$b,$a
	dc.w $b,$b,$b,$b,$b,$b,$c,$b,$c,$c,$c,$c,$c,$c,$d,$c
	dc.w $d,$d,$d,$d,$d,$d,$e,$d,$e,$e,$e,$e,$e,$e,$f,$e
	dc.w $f,$f,$f,$f,$f,$f,$f,$f,$e,$f,$e,$e,$e,$e,$e,$e
	dc.w $d,$e,$d,$d,$d,$d,$d,$d,$c,$d,$c,$c,$c,$c,$c,$c
	dc.w $b,$c,$b,$b,$b,$b,$b,$b,$a,$b,$a,$a,$a,$a,$a,$a
	dc.w 9,$a,9,9,9,9,9,9,8,9,8,8,8,8,8,8
	dc.w 7,8,7,7,7,7,7,7,6,7,6,6,6,6,6,6
	dc.w 5,6,5,5,5,5,5,5,4,5,4,4,4,4,4,4
	dc.w 3,4,3,3,3,3,3,3,2,3,2,2,2,2,2,2
	dc.w 1,2,1,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w 1,1,1,1,1,1,2,1,2,2,2,2,2,2,3,2
	dc.w 3,3,3,3,3,3,4,3,4,4,4,4,4,4,5,4
	dc.w 5,5,5,5,5,5,6,5,6,6,6,6,6,6,7,6
	dc.w 7,7,7,7,7,7,8,7,8,8,8,8,8,8,9,8
	dc.w 9,9,9,9,9,9,$a,9,$a,$a,$a,$a,$a,$a,$b,$a
	dc.w $b,$b,$b,$b,$b,$b,$c,$b,$c,$c,$c,$c,$c,$c,$d,$c
	dc.w $d,$d,$d,$d,$d,$d,$e,$d,$e,$e,$e,$e,$e,$e,$f,$e
	dc.w $f,$f,$f,$f,$f,$f,$f,$f,$e,$f,$e,$e,$e,$e,$e,$e
	dc.w $d,$e,$d,$d,$d,$d,$d,$d,$c,$d,$c,$c,$c,$c,$c,$c
	dc.w $b,$c,$b,$b,$b,$b,$b,$b,$a,$b,$a,$a,$a,$a,$a,$a
	dc.w 9,$a,9,9,9,9,9,9,8,9,8,8,8,8,8,8
	dc.w 7,8,7,7,7,7,7,7,6,7,6,6,6,6,6,6
	dc.w 5,6,5,5,5,5,5,5,4,5,4,4,4,4,4,4
	dc.w 3,4,3,3,3,3,3,3,2,3,2,2,2,2,2,2
	dc.w 1,2,1,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0


;*****************************************************************************
; Das Bild in Streifen und das "Fenster"

pic:
	dcb.w	40*200/2,$ff00
wind:
	dcb.w	40*200/2,$ffff

;*****************************************************************************

newcopper:
	dc.w	$008e,$3e91,$0090,$e0b1	; diwstart/stop
	dc.w	$0092,$0036,$0094,$00ce	; ddfstart/stop
	dc.w	$0102,$0000,$0104,$000a ; bplcon1/2
	dc.w	$0108,0,$010a,0			; bplmod
	dc.w	$0100,$200				; bplcon0 - 0 bitplanes
	dc.w	$3e09,$fffe				; Wait Zeile $39
	dc.w	$0100,$2200				; bplcon0 - 2 bitplanes

	dc.w	$00e0
pl0h:	dc.w	$0000
	dc.w	$00e2
pl0l:	dc.w	$0000
	dc.w	$00e4
pl1h:	dc.w	$0000
	dc.w	$00e6
pl1l:	dc.w	$0000

	dc.w	$180,$000
	dc.w	$182,$000
	dc.w	$184,$000
	dc.w	$186,$000

copcols:
	dcb.b	((8*(width/2))+8)*(depth/2)
	dc.w	$0180,$0000
	dc.w	$0100,$0200,$0102,0
	dc.w	$ffff,$fffe

;*****************************************************************************
;		 SinTab erstellt mit der Routine
;*****************************************************************************

	Section	Robaccia,bss

memory1:
	ds.w	16384

	end

