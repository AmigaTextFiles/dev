
; Listing5m2.s	"SCHLIESSEN"  DES VIDEOFENSTERS MIT DEN DIWSTART/STOP ($8e/$90)

	SECTION  CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName(PC),a1		; Adresse des Namen der zu öffnenden Library
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes (immer auf $26 nach GfxBase)

;	POINTEN AUF UNSERE BITPLANES

	MOVE.L	#PIC,d0			; in d0 kommt die Adresse unserer PIC
	LEA	BPLPOINTERS,A1		; in a1 kommt die Adresse der Bitplane-
							; Pointer der Copperlist
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier sind es 3)
							; für den DBRA - Zyklus

POINTBP:
	move.w	d0,6(a1)		; kopiert das niederwertige Word der Plane-
							; Adresse ins richtige Word der Copperlist
	swap	d0				; vertauscht die 2 Word in d0 (1234 > 3412)

	move.w	d0,2(a1)		; kopiert das hochwertige Word der Adresse des 
							; Plane in das richtige Word in der Copperlist
	swap	d0				; vertauscht erneut die 2 Word von d0
	ADD.L	#40*256,d0		; Zählen 10240 zu D0 dazu, -> nächstes Plane

	addq.w	#8,a1			; zu den nächsten Bplpointers in der Cop
	dbra	d1,POINTBP		; Wiederhole D1 mal POINTBP (D1=n. bitplanes)

	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh noch nicht weiter

	btst	#2,$dff016		; wenn die rechte Maustaste gerdückt ist, dann
	beq.s	Warte			; überspringe die Scrollroutine (blockiert)

	bsr.w	DIWHORIZONTAL	; Zeigt die Funktion des DIWSTART und DIWSTOP
	bsr.w	DIWVERTIKAL	; 

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte			; Wenn ja, geh nicht weiter, warte!

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088		; starten die alte COP


	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable - stellt Multitasking wieder her
	move.l	GfxBase(PC),a1	; Basis der Library, die es zu schließen gilt
							; (Libraries werden geöffnet UND geschlossen!)
	jsr	-$19e(a6)			; Closelibrary - schließt die Graphics lib
	rts
 
; DATEN


GfxName:
	dc.b	"graphics.library",0,0

GfxBase:		; Hier hinein kommt die Basisadresse der graphics.lib,
	dc.l	0	; ab hier werden die Offsets gemacht

OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist
	dc.l	0	; des Betriebssystemes



DIWHORIZONTAL:
	CMPI.B	#$FF,DIWXSTART	; Sind wir bei maximal DIWSTART angekommen?
	BEQ.S	ENDE			; wenn ja, dann können wir nicht weiter
	ADDQ.B	#2,DIWXSTART	; wenn nicht, dann zähl 1 dazu
ENDE:
	TST.B	DIWXSTOP		; Sind wir beim Minimum von DIWSTOP? ($00)?
	BEQ.S	ENDE2			; wenn ja können wir nicht noch mehr abziehen
	SUBQ.B	#2,DIWXSTOP		; wenn nicht, 1 wegzählen
ENDE2:
	RTS						; Ende der Routine, Ausstieg


DIWVERTIKAL:
	CMPI.B	#$95,DIWYSTOP	; Sind wir beim richtigen DIWSTOP angekommen?
	BEQ.S	ENDE3			; wenn ja, brauchen wir nicht weitergehen
	ADDQ.B	#1,DIWYSTART	; zählen 1 zum Start dazu
	SUBQ.B	#1,DIWYSTOP		; ziehen 1 vom Stop ab
ENDE3:
	RTS						; Raus aus der Routine

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8E				; DIWSTART - Anfang Videofenster
DIWYSTART:
	dc.b	$2c				; DIWSTRT $YY
DIWXSTART:
	dc.b	$81				; DIWSTRT $XX (erhöhen es bis $ff)

	dc.w	$90				; DIWSTOP - Ende des Videofensters
DIWYSTOP:
	dc.b	$fe				; DiwStop YY
DIWXSTOP:
	dc.b	$c1				; DiwStop XX (verringern es bis $00)
	dc.w	$92,$0038		; DdfStart
	dc.w	$94,$00d0		; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0011001000000000	; Bits 13 und 12 an!! (3 = %011)
									; 3 Bitplanes Lowres, nicht Lace
BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste	 Bitplane
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane
	dc.w	$e8,$0000,$ea,$0000	; dritte Bitplane

	dc.w	$0180,$000		; color0
	dc.w	$0182,$475		; color1
	dc.w	$0184,$fff		; color2
	dc.w	$0186,$ccc		; color3
	dc.w	$0188,$999		; color4
	dc.w	$018a,$232		; color5
	dc.w	$018c,$777		; color6
	dc.w	$018e,$444		; color7

	dc.w	$ca07,$fffe
	dc.w	$180,$456		; Bemerke: Die Hintergrundfarbe wird vom
							; Diwstart-Diwstop nicht beeinflußt

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	Bild

PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format
							; das wir zuvor mit dem
							; Kefcon konvertiert haben

	end

In diesem Listing wurden sowohl die XX als auch die YY der DIWSTART und
DIWSTOP verändert, um das Bild zu erwürgen.

