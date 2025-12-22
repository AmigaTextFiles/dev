
; Lezione14-5d.s:  ** FAKE-SURROND-EFFEKT **
			; N.B.: funktioniert gut auf langsamen Computern für
			; Verzögerung zwischen den beiden Stimmen.

; Debuggen wie zuvor

WLMB	macro
\@	btst	#6,$bfe001
	bne.s	\@
	endm

WRMB	macro
\@	btst	#10,$dff016
	bne.s	\@
	endm

	SECTION	PlayLongSamples,CODE

Start:
	bset	#1,$bfe001		; schaltet den Tiefpassfilter aus
							; >>>> PARAMETER <<<<
	lea	sample,a0			; Adresse sample
	move.l	#sample_end-sample,d0	; Länge sample in byte
	;move.w	#17897,d1		; Lesefrequenz		Datei fehlt
	move.w  #21056,d1	
	moveq	#64,d2			; Lautstärke

	moveq	#0,d3			; Stimme 0
	bsr.w	playlongsample_init
	moveq	#3,d3			; Stimme 3
	bsr.w	playlongsample_init
	WLMB
	moveq	#1,d3			; Stimme 1
	bsr.s	playlongsample_init
	moveq	#2,d3			; Stimme 2
	bsr.s	playlongsample_init
	WRMB

	moveq	#0,d3			; ausschalten Stimme 0 
	bsr.w	playlongsample_restore
	moveq	#1,d3			; ausschalten Stimme 1
	bsr.w	playlongsample_restore
	moveq	#2,d3			; ausschalten Stimme 2
	bsr.w	playlongsample_restore
	moveq	#3,d3			; ausschalten Stimme 3
	bsr.w	playlongsample_restore
	rts



***************************************
*****  Play Long Sample Routines  *****
***************************************

PlayLongSample_init:
		; [a0=sample adr]
		; [d0.l=Länge.b sample, d1.w=Frequenz, d2.w=volume]
		; [d3.w=Stimme (0..3)]
		; * Autovektor Lv4 IRQ muss verfügbar sein *

_LVOSupervisor	equ	-30
Clock		equ	3546895
AFB_68010	equ	0
AttnFlags	equ	296

	movem.l	d0-d7/a0-a1/a6,-(sp)
	and.w	#3,d3			; maximal 3 Kanäle
 	lea	$dff000,a6
	moveq	#1,d4
	lsl.w	d3,d4
	move.w	d4,d6
	and.w	$2(a6),d4		; Maske DMA der Stimme
	move.w	#1<<7,d5
	lsl.w	d3,d5
	move.w	d5,d7
	and.w	$1c(a6),d5		; Maske INT der Stimme
	add.w	d3,d3			; d3=d3*2: drückt word offset aus
	lea	olddmas(pc),a1
	move.w	d4,(a1,d3.w)	; speichern des alten DMA-Status der Stimme
	lea	oldints(pc),a1
	move.w	d5,(a1,d3.w)	; speichern des alten INT-Status der Stimme
	move.w	d7,$9c(a6)		; löscht eventuellen IRQ
	move.w	d6,$96(a6)		; DMA der Stimme ausschalten
	move.w	d7,$9a(a6)		; INT der Stimme ausschalten
	sub.l	a1,a1			; FAST CLEAR An
	move.l	4.w,a6
	btst	#afb_68010,attnflags+1(a6)	; 68010+ ?
	beq.s	.no010
	lea	.getvbr(pc),a5
	jsr	_LVOSupervisor(a6)
.No010:	cmp.l	#lv4irq,$70(a1)
	beq.s	.nochg
	move.l	$70(a1),oldlv4		; alten Aautovektor Level 4 speichern
	move.l	#lv4irq,$70(a1)		; neuen Eigenvektor setzen
.NoChg:	lsl.w	#4-1,d3			; d3=d3*8: drückt 16 byte Offset aus
	lea	$dff0a0,a6
	move.w	d2,$8(a6,d3.w)		; setzen AUDxVOL
	move.l	#clock,d2
	divu.w	d1,d2				; d2.w=clock/freq = Periode
	move.w	d2,$6(a6,d3.w)		; setzen AUDxPER
	lea	$dff000,a6
	or.w	#$8000,d7
	move.w	d7,$9a(a6)			; schaltet INT der Stimme ein
	lea	plsregs(pc,d3.w),a1
	movem.l	d0/a0,(a1)			; Register fest
	movem.l	d0/a0,4*2(a1)		; Arbeitsregister
	move.w	d7,$9c(a6)			; IRQ-Stärke der Stimme...
	movem.l	(sp)+,d0-d7/a0-a1/a6
	rts
.GetVBR:
	dc.l	$4e7a9801	; movec	vbr,a1	;  Basis der Ausnahmevektoren
	rte
;--------------------------------------
PLSRegs:	; MUSS ZWISCHEN _INIT UND _IRQ FÜR DEN ADRESSMODUS SEIN
			; GENUTZT: XX (PC, Rn), DER NUR 8 BITS MIT EINEM "XX" -ZEICHEN ERLAUBT
PLSAud0Regs:	dc.l	0,0	; Länge, Zeiger - fest
		dc.l	0,0			; Länge, Zeiger - variabel
PLSAud1Regs:	dc.l	0,0	; Länge, Zeiger - fest
		dc.l	0,0			; Länge, Zeiger - variabel
PLSAud2Regs:	dc.l	0,0	; Länge, Zeiger - fest
		dc.l	0,0			; Länge, Zeiger - variabel
PLSAud3Regs:	dc.l	0,0	; Länge, Zeiger - fest
		dc.l	0,0			; Länge, Zeiger - variabel
;--------------------------------------
PlayLongSample_IRQ:
		; [a1=PLSAudxRegs]
		; [d3.w=voce]
	movem.l	d0-d3/a0-a1/a6,-(sp)
	and.w	#3,d3			; maximal 3 Stimmen
	move.w	d3,d2
	lsl.w	#4,d3			; d3=d3*16: drückt einen Offset von 16 Bytes aus
	lea	plsregs(pc,d3.w),a1
	movem.l	4*2(a1),d0/a0	; Arbeitsregister
	lea	$dff0a0,a6
	move.l	a0,$0(a6,d3.w)	; einstellen AUDxLC
	move.l	d0,d1			; d1.l=Länge fehlt
	and.l	#~(128*1024-1),d1	;fehlt noch mehr als 128 kB
	bne.s	.long			; wenn ja: gehe zu .long
	move.l	d0,d1			; wenn nein: Länge verwenden fehlt (< 128 kB)
.Long:	lsr.l	#1,d1		; trasformiert die Länge die gespielt werden soll in WORD
	move.w	d1,$4(a6,d3.w)	; einstellen AUDxLEN
	add.l	#128*1024,a0	; Zeigen Sie mit a0 auf den nächsten Block
	sub.l	#128*1024,d0	; Länge MENO 128 kB
	bhi.s	.noloop			; d0 => 1 ? (MINDESTENS noch 1 byte vermisst)
	movem.l	(a1),d0/a0		; wenn nein: original Register wiederherstellen
.NoLoop:movem.l	d0/a0,4*2(a1)		; speichern d0 und a0 in Kopien
	move.w	#%1<<7,d0
	lsl.w	d2,d0
	move.w	d0,$dff09c		; löscht den IRQ der Stimme,
							; Ein neuer Interrupt kam gerade heraus
	moveq	#%1,d0
	lsl.w	d2,d0
	or.w	#$8200,d0		; schaltet DMA der Stimme ein
	move.w	d0,$dff096
	movem.l	(sp)+,d0-d3/a0-a1/a6
	rts
;--------------------------------------
PlayLongSample_restore:
		; [d3.w=Stimme (0..3)]
	movem.l	d0-d1/d3/a0/a6,-(sp)
	and.w	#3,d3			; maximal 3 Stimmen
 	lea	$dff000,a6
	moveq	#1,d0
	lsl.w	d3,d0
	move.w	#1<<7,d1
	lsl.w	d3,d1
	move.w	d1,$9c(a6)		; löscht alle IRQ der Stimme
	move.w	d0,$96(a6)		; schaltet INT der Stimme aus
	move.w	d1,$9a(a6)		; schaltet DMA der Stimme aus
	move.w	$1c(a6),d0
	and.w	#$0780,d0		; aus allen Stimmen = letzte Stimme?
	bne.s	.NoOFF
	sub.l	a0,a0			; wenn ja:...
	move.l	4.w,a6
	btst	#afb_68010,attnflags+1(a6)
	beq.s	.no010
	lea	.getvbr(pc),a5
	jsr	_LVOSupervisor(a6)
.No010:	move.l	oldlv4(pc),$70(a0)	; ... setzt den alten Eigenvektor zurück
.NoOFF:	lea	$dff000,a6
	add.w	d3,d3			; d3=d3*2: drückt word Offset aus
	move.w	oldints(pc,d3.w),d0
	or.w	#$8000,d0
	move.w	d0,$9a(a6)		; alten INT einschalten 
	move.w	olddmas(pc,d3.w),d0
	or.w	#$8000,d0
	move.w	d0,$96(a6)		; alten DMA einschalten 
	movem.l	(sp)+,d0-d1/d3/a0/a6
	rts
.GetVBR:
	dc.l	$4e7a8801	; movec	vbr,a0	; Basis der Ausnahmevektoren
	rte
;--------------------------------------
OldINTs:dc.w	0,0,0,0
OldDMAs:dc.w	0,0,0,0
OldLv4:	dc.l	0


***************************************
*****  Level 4 Interrupt Handler  *****
***************************************

	cnop	0,8
Lv4IRQ:	
	move.w	d3,-(sp)
	pea	.exit(pc)		; push return für RTS auf dem stack

	moveq	#3,d3
	btst	#10-8,$dff01e		; aud3 IRQ ?
	bne.w	playlongsample_irq	; wenn ja: Rückkehr zu _IRQ

	moveq	#2,d3
	btst	#9-8,$dff01e		; aud2 IRQ ?
	bne.w	playlongsample_irq

	moveq	#1,d3
	btst	#8-8,$dff01e		; aud1 IRQ ?
	bne.w	playlongsample_irq

	moveq	#0,d3				; aud0 IRQ ?
	btst	#7,$dff01f
	bne.w	playlongsample_irq

.Exit:	move.w	(sp)+,d3		; kehre auch für das RTS des _IRQ zurück
	rte




	SECTION	Sample,DATA_C

	; MammaGamma by Alan Parsons Project (©1981)
Sample:
	;incbin	"assembler2:sorgenti8/Mammagamma.17897"	; Datei fehlt
	incbin	"assembler3:sorgenti8/carrasco.21056"
Sample_end:

	END


Es gibt nicht viel zu sagen... Es ist keine echte Umgebung, aber es sieht so aus... 
Versuchen die beiden Stimmen mit einer Schleife oder so etwas mehr zu verzögern
und zuhören welche Effekte es hat (machen Sie den "elektrischen Säge" -Effekt
mit einer hohen Verzögerung).
...Achten Sie darauf, nicht zu lange zu verzögern: Sie würden ein Echo erzeugen...
