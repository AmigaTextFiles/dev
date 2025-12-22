
; Listing5m.s	VERSCHIEBEN DES VIDEOFENSTER MIT DEM DIWSTART ($dff08e)

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

	btst	#2,$dff016		; wenn die rechte Maustaste gedrückt ist,
	beq.s	Warte			; überspringe die Routine

	bsr.s	DIWRaufRunter	; Läßt Bild rauf und runter gehen durch
							; verändern des DIWStart/Stop

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte			; Wenn nicht, geh nicht weiter

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


; Diese Routine agiert ganz einfach auf das Byte YY des $dff08e in
; der Copperlist, dem DIWSTART; dieses Register definiert den Anfang
; des Videofensters, das "zentriert" werden kann, wie man es aus dem
; Preferences der Workbench kennt. In unserem Fall lassen wir dieses
; Videofenster einfach etwas weiter unten beginnen, deswegen verschiebt
; sich dessen Inhalt. Hier wird, im Unterschied zum Scroll, nichts
; angezeigt, was sich "oberhalb" des Bildes befindet, weil wir hier
; ja das ganze Fenster verstellen, und nicht nur den Inhalt.
; Interessant in der Routine ist ein Word, COUNTER, das dazu verwendet
; wird, 35 Frames abzuwarten, wenn das Logo oben angekommen ist.
; Ich habe auch zwei "neue" Anweisungen verwendet, mit denen ihr noch
; nicht Bekanntschaft geschlossen habt, aber in dieser Routine
; äußerst nützlich sind; es handelt sich zum Einen um das BHI, einem Befehl
; aus der Familie der BEQ/BNE. Er springt zu einer Routine, wenn das
; CMP, also "VERGLEICHE", als Resultat liefert, daß der Wert größer ist.
; In unserem Fall springt das BHI.s LOGOD nur zu LOGOD, wenn Counter
; den Wert 35 erreicht hat, bzw. jedes darauf folgende Mal, bei 36, 37...
; Der andere Befehl ist das BCHG, das BIT CHANGE bedeutet, oder auf
; Deutsch "Vertausche das Bit". Es stammt aus der noblen Familie der
; BTST, und es vertauscht das angegebene Bit: BCHG #1,Label stürzt
; sich auf das Bit 1 von Label, wenn es 0 war wird es 1, und wenn es
; 1 war wird es ... was wohl? ... 0! Genau!


DIWRaufRunter:
	ADDQ.W	#1,COUNTER		; wir vermerken die Durchführung
	CMPI.W	#35,COUNTER		; sind mindestens 35 Frames vergangen?
	BHI.S	LOGOD			; wenn ja, dann geh zur Routine LOGOD
	RTS						; ansonsten zurück ohne sie auszuführen

LOGOD:
	BTST	#1,FLAGDIW		; Müßen wir nach oben gehen?
	BEQ.S	UP				; Wenn ja, führe die Routine "UP" aus
	SUBQ.B	#2,DIWSCX		; Geh in 2er-Schritten nach oben, etwas schneller
	CMPI.B	#$2c,DIWSCX		; Sind wir oben? (Normaler Wert: $2c81)
	BEQ.S	CHANGEUPDOWN2	; wenn ja, ändere Richtung
	RTS

UP:
	ADDQ.B	#1,DIWSCX		; Geh langsam nach unten, in 1er-Schritten
	CMPI.B	#$70,DIWSCX		; Sind wir unten? (Position $70)
	BEQ.S	CHANGEUPDOWN	; wenn ja, ändern wir Richtung
	RTS

CHANGEUPDOWN
	BCHG	#1,FLAGDIW		; vertausche das Richtungsbit
	RTS

CHANGEUPDOWN2
	BCHG	#1,FLAGDIW		; vertausche das Richtungsbit und
	CLR.W	COUNTER			; setze COUNTER auf NULL, wir sind am Ende!
	RTS

FLAGDIW:
	dc.w	0

COUNTER:
	dc.w	0


	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8E
DIWSCX:
	dc.w	$2c81			; DIWSTRT = $YYXX Beginn des Videofenster

	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0038		; DdfStart
	dc.w	$94,$00d0		; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

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

PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format

	end


