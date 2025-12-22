
; Listing5d.s	SCROLLEN EINES BILDES NACH OBEN UND UNTEN DURCH ÄNDERN
;				DER BITPLANEPOINTERS, KOMBINIERT MIT EINEM LINKS-RECHTS-
;				SCROLL, ERZEUGT MIT DEM $dff102 (BPLCON0)

	SECTION	CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName(PC),a1		; Adresse des Namen der zu öffnenden Lib in a1
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes.
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

	bsr.w	BewegeCopper	; bewegt das Bild nach oben und unten,
							; eine Zeile pro Durchgang. Verändert
							; Bitplanepointers
 
	btst	#2,$dff016		; wenn die rechte Maustaste gedrückt ist,
	beq.s	Warte			; überspringe die Scrollroutine

	bsr.w	BewegeCopper2	; Scrollt Bild links und rechts mit dem $dff102

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir noch auf Zeile 255?
	beq.s	Warte			; Wenn ja, geh nicht weiter

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

;	Diese Routine bewegt das Bild nach oben und unten, imdem sie auf
;	die Bitplanepointer in der Copperlist zugreift (Mit dem Label
;	BPLPOINTERS).
;	Die Struktur ist ähnlich mit der in Listing3d.s
;	Als erstes geben wir die Adresse, die dir BPLPOINTERS gerade anpointen
;	in d0, dann addieren oder subtrahieren wir 40 Bytes von d0, und
;	setzen dann diesen neuen Wert in die Copperlist ein. Dafür verwenden
;	wir wieder die gleiche Routine POINTBP.

BewegeCopper:
	LEA	BPLPOINTERS,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0

	TST.B	RaufRunter		; Müßen wir nach oben oder unten?

	beq.w	GehRunter
	cmp.l	#PIC-(40*30),d0 ; sind wir weit genug OBEN?
	beq.s	SetzRunter		; wenn ja, sind wir am Ende und müßen runter
	sub.l	#40,d0			; subtrahieren 40, also 1 Zeile, dadurch
							; wandert das Bild nach UNTEN
	bra.s	Ende

SetzRunter:
	clr.b	RaufRunter		; Durch Löschen von RaufRunter wird das TST
	bra.s	Ende			; danach wieder BEQ ermöglichen ->
							; BEQ wird zur Routine GehRunter springen

GehRunter:
	cmpi.l	#PIC+(40*30),d0 ; sind wir weit genug UNTEN?
	beq.s	SetzRauf		; wenn ja, sind wir am unteren Ende und
							; müßen wieder rauf
	add.l	#40,d0			; Addieren 40, also 1 Zeile, somit scrollt
							; das Bild nach OBEN
	bra.s	Ende

SetzRauf:
	move.b	#$ff,RaufRunter ; Wenn das Label nicht auf NULL steht,
	rts						; bedeutet das, daß wir rauf müßen

Ende:						; POINTEN DIE BITPLANEPOINTER AN
	LEA	BPLPOINTERS,A1		; POINTER in der COPPERLIST
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier: 3)
POINTBP2:
	move.w	d0,6(a1)		; kopiert das niederw. Word der Adress des Pl.
	swap	d0				; vertauscht die 2 Word von d0 (1234 > 3412)
	move.w	d0,2(a1)		; kopiert das höherw. Word der Adresse des Pl.
	swap	d0				; vertauscht die 2 Word von d0 (3412 > 1234)
	ADD.L	#40*256,d0		; + Länge Bitplane -> nächstes Bitplane
	addq.w	#8,a1			; zu den nächsten bplpointers in der Cop
	dbra	d1,POINTBP2		; Wiederhole D1 Mal POINTBP (D1=n. bitplanes)
	rts


;	Dieses Byte, vom Label RaufRunter markiert, ist ein FLAG.

RaufRunter:
	dc.b	0,0

;***************************************************************************

BewegeCopper2:
	TST.B	FLAG			; Müßen wir vor oder zurück?
	beq.w	Vorne
	cmpi.b	#$00,MeinCon1	; sind wir auf der Standartposition angekommen,
							; also ganz hinten?
	beq.s	GehNachVorne	; wenn ja, dann müßen wir nach vorne!
	sub.b	#$11,MeinCon1	; wir ziehen 1 vom Scroll der geraden/ungeraden
	rts						; Bitplanes ab ($ff,$ee,$dd,$cc,$bb,$aa,$99..)
							; gehen somit nach LINKS
GehNachVorne:
	clr.b	FLAG			; Durch Nullsetzen des FLAG wird bei TST.B FLAG
	rts						; das BEQ die Routine nach Vorne springen lassen,
							; und das Bild wird vorschreiten (nach rechts)

Vorne:
	cmpi.b	#$ff,MeinCon1	; Sind wir beim Maximalscroll nach vorne ($ff)
							; angekommen?? ($f gerade und $f ungerade)
	beq.s	GehNachHinten	; wenn ja müßen wir zurückgehen
	add.b	#$11,MeinCon1	; zähle 1 zum Bitplanescroll dazu, gerade und
							; ungerade ($11,$22,$33,$44 etc..)
	rts						; GEH NACH RECHTS

GehNachHinten:
	move.b	#$ff,FLAG		; Wenn das Label FLAG nicht auf NULL ist,
	rts						; dann bedeutet das, daß wir nach links
							; zurückgehen müßen

;	Dieses Byte ist ein FLAG, es zeigt uns an, ob wir vor oder
;	zurück gehen müßen.

FLAG:
	dc.b	0,0

	Section	COpp,data_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8e,$2c81		; DiwStrt	(Register mit Standartwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0038		; DdfStart
	dc.w	$94,$00d0		; DdfStop

	dc.w	$102			; BplCon1 - DAS REGISTER
	dc.b	$00				; BplCon1 - DAS NICHT VERWENDETE BYTE!!!
MeinCon1:
	dc.b	$00				; BplCon1 - DAS VERWENDETE BYTE!!!

	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

			    ; 5432109876543210	; BPLCON0:
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

	dcb.b	40*30,0 ; dieses Stück voller Nullen ist notwendig, da wir
					; beim Anzeigen weiter über und unter das Pic selbst
					; gehen und diesen Teil anzeigen. Wären hier keine
					; Nullen, würden die Byte angezeigt, die sich gerade
					; in diesem Teil des Speichers befinden. Das Resultat
					; wäre Chaos am Bildschirm. Aber durch $0000 wird immer
					; Farbe0 angezeigt, also der Hintergrund.

PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format

	dcb.b	40*30,0 ; siehe oben
	
	end


Nichts neues, nur eine Kombination der vorherigen Listings.

