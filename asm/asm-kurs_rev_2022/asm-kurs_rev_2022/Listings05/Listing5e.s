
; Listing5e.s	HALBIERUNG EINES BILDES DURCH MODIFIZIERUNG DER MODULO-REGISTER

	SECTION	CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName(PC),a1		; Adresse des Namen der zu öffnenden Lib in a1
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes

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
	bne.s	mouse			; Wenn nicht, geh nicht weiter

Frame:
	cmpi.b	#$fe,$dff006	; sind wie auf Z. 254? (muß Runde wiederholen)
	bne.s	Frame			; wenn nicht, geh nicht weiter
Frame2:
	cmpi.b	#$fd,$dff006	; sind wie auf Zeile 253?
	bne.s	Frame2			; wenn nicht, geh nicht weiter
Frame3:
	cmpi.b	#$fc,$dff006	; sind wie auf Zeile  252?
	bne.s	Frame3
Frame4:
	cmpi.b	#$fb,$dff006	; sind wie auf Zeile  251?
	bne.s	Frame4
	
	btst	#2,$dff016		; wenn die rechte Maustaste gedrückt ist,
	beq.s	NichtBewegen	; überspringe die Routine

	bsr.s	BewegeCopper	; Effekt

NichtBewegen:
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088		; COPJMP1 - und starten sie

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

OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0	; Betriebssystemes


; Mit dieser Routine addiere oder subtrahiere ich 40 zu den Modulo-Registern,
; was eine halbierund der Pic zur Folge hat. Ich habe die Labelnamen gleich
; gelassen, um Zeit zu sparen.

BewegeCopper:
	TST.B	RaufRunter		; Müßen wir rauf oder runter?
	beq.w	GehRunter
	tst.w	MOD1			; Sind wir auf Normalwert des Modulo? (NULL)
	beq.s	SetzRunter		; wenn ja, Wert erhöhen
	sub.w	#40,MOD1		; subtrahieren 40, also 1 Zeile, somit "scrollt"
							; das Bild nach UNTEN und vergrößert sich zoom
	sub.w	#40,MOD2        ; zählen 40 von Modulo2 weg
	rts

SetzRunter:
	clr.b	RaufRunter		; Durch Löschen von RaufRunter wird das TST
	rts

GehRunter:
	cmpi.w	#40*20,MOD1		; haben wir genug halbiert??
	beq.s	SetzRauf		; wenn ja, müßen wir das Pic wieder in
							; Normalzustand bringen
	add.w	#40,MOD1		; Addieren 40, also 1 Zeile, somit "scrollt" das
							; Bild nach OBEN, womit es halbiert wird
	add.w	#40,MOD2		; Addieren 40 zum Modulo2
	rts

SetzRauf:
	move.b	#$ff,RaufRunter ; Wenn das Label nicht auf NULL steht,
	rts						; bedeutet das, daß wir rauf müßen

;	Dieses Byte, vom Label RaufRunter markiert, ist ein FLAG.

RaufRunter:
	dc.b	0,0


	SECTION GRAPHIC,DATA_C


COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8e,$2c81		; DiwStrt	(Register mit Standartwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0038		; DdfStart
	dc.w	$94,$00d0		; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2

	dc.w	$108			; Bpl1Mod
MOD1:
	dc.w	0				; Bpl1Mod
	dc.w	$10a
MOD2:
	dc.w	0				; Bpl2Mod

			    ; 5432109876543210  ; BPLCON0:
	dc.w	$100,%0011001000000000  ; Bits 13 und 12 an!! (3 = %011)
									; 3 Bitplanes Lowres, nicht Lace
BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste  Bitplane - BPL0PT
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane - BPL1PT
	dc.w	$e8,$0000,$ea,$0000	; dritte Bitplane - BPL2PT

	dc.w	$0180,$000		; Color0
	dc.w	$0182,$475		; Color1
	dc.w	$0184,$fff		; Color2
	dc.w	$0186,$ccc		; Color3
	dc.w	$0188,$999		; Color4
	dc.w	$018a,$232		; Color5
	dc.w	$018c,$777		; Color6
	dc.w	$018e,$444		; Color7
	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	BILD

	dcb.b	30*40,0			; Wegen der Bytes über und unter der Pic 
PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format

	dcb.b	30*40,0			; Wegen der Bytes über und unter der Pic Format

	end

Wenn ich ganz "sauber" arbeiten gewollt hätte, dann  hätte  ich  ein  Wait
unters  Bild  geben  müßen,  um  die  überflüßigen Bytes, die nach dem Pic
stehen, zu eliminieren. Aber die Hauptsache ist ja, euch zu erklären,  wie
die  Sache  mit den Modulo geht. Die Routine wird einmal alle 4 Fotogramme
(Frames) ausgeführt, um sie etwas langsamer zu gestalten.

