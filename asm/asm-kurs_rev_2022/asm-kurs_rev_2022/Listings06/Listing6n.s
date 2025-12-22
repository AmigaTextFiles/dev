
; Listing6n.s	HORIZONTALTER SCROLL ÜBER MEHR ALS 16 PIXEL, UNTER
;				VERWENDUNG DES BPLCON1 UND DER BITPLANEPOINTERS -
;				RECHTE TASTE UM NACH LINKS ZU SCROLLEN

	SECTION	CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Namen der Lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase		;
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	POINTEN AUF UNSERE BITPLANES

	MOVE.L	#PIC,d0			; wohin pointen
	LEA	BPLPOINTERS,A1		; COP - Pointers
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier sind es 3)
							; für den DBRA - Zyklus
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0		; + Länge Bitplane
	addq.w	#8,a1
	dbra	d1,POINTBP

	move.l	#COPPERLIST,$dff080	; COP1LC - unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse
	
	btst	#2,$dff016		; Rechte Taste gedrückt?
	beq.s	GehLinks		; wenn ja, geh nach links!

	bsr.w	Rechts			; Läßt das Bild nach rechts scrollen, indem es
							; das BPLCON1 und die Pointer verändert
	bra.s	Warte

GehLinks:
	bsr.w	Links			; Bewegt Bild nach links

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte		

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse

	move.l	OldCop(PC),$dff080	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088		; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable
	move.l	GfxBase(PC),a1
	jsr	-$19e(a6)			; Closelibrary 
	rts


; DATEN


GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0


; Diese Routine läßt das Bild nach Rechts scrollen, sie verwendet dazu das
; BPLCON1 und die Bitplanepointers in der Copperlist. MEINBPCON1 ist
; das Byte des BPLCON1.

Rechts:
	CMP.B	#$ff,MEINBPCON1	; sind wir bei maximalen Scroll angelangt (15)?
	BNE.s	CON1ADDA		; wenn nicht, weiter um ein weiteres

	LEA	BPLPOINTERS,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0

	subq.l	#2,d0			; pointet 16 Bit weiter nach hinten, das Bild
							; scrollt um 16 Pixel nach Rechts
	clr.b	MEINBPCON1		; löscht den Hardwarescroll des BPLCON1 ($dff102)
							; denn wir haben 16 Pixel schon mit den Bitplane-
							; Pointers "übersprungen", wir müssen wieder bei
							; NULL beginnen, um mit dem $dff102 um jeweils
							; 1 Pixel nach rechts zu gehen.

	LEA	BPLPOINTERS,A1		; Pointer in der COPPERLIST
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier sind es 3)

POINTBP2:
	move.w	d0,6(a1)		; kopiert das niederw. Word der Adress des Plane
	swap	d0				; vertauscht die 2 Word von d0 (z.B.: 1234 > 3412)
	move.w	d0,2(a1)		; kopiert das höherw. Word der Adresse des Plane
	swap	d0				; vertauscht die 2 Word von d0 (3412 > 1234)
	ADD.L	#40*256,d0		; + Länge Bitplane -> nächstes Bitplane
	addq.w	#8,a1			; zu den nächsten bplpointers in der Cop
	dbra	d1,POINTBP2		; Wiederhole D1 Mal POINTBP (D1=num of bitplanes)
	rts

CON1ADDA:
	add.b	#$11,MEINBPCON1 ; scrolle ein Pixel nach vorne
	rts

;	Routine, die nach Links scrollt, identisch mit der vorherigen:

LINKS:
	TST.B	MEINBPCON1		; sind wir bei minimalen Scroll angelangt (00)?
	BNE.s	CON1SUBBA		; wenn nicht, zurück um ein weiteres

	LEA	BPLPOINTERS,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0
	
	addq.l	#2,d0			; pointet 16 Bit weiter nach vorne, das Bild
							; scrollt um 16 Pixel nach Links
	move.b	#$FF,MEINBPCON1	; Hardwarescroll auf 00 (BPLCON1, $dff102)
	
	LEA	BPLPOINTERS,A1		; Pointer in der COPPERLIST
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier sind es 3)
POINTBP3:
	move.w	d0,6(a1)		; kopiert das niederw. Word der Adress des Plane
	swap	d0				; vertauscht die 2 Word von d0 (z.B.: 1234 > 3412)
	move.w	d0,2(a1)		; kopiert das höherw. Word der Adresse des Plane
	swap	d0				; vertauscht die 2 Word von d0 (3412 > 1234)
	ADD.L	#40*256,d0		; + Länge Bitplane -> nächstes Bitplane
	addq.w	#8,a1			; zu den nächsten bplpointers in der Cop
	dbra	d1,POINTBP3		; Wiederhole D1 Mal POINTBP (D1=num of bitplanes)
	rts

CON1SUBBA:
	sub.b	#$11,MEINBPCON1 ; scrolle ein Pixel nach hinten
	rts



	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8E,$2c91		; DiwStrt ($81+16=$91)
	;dc.w	$8E,$2c81		; DiwStrt (Register mit Normalwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0038		; DdfStart
	;dc.w	$94,$00d0		; DdfStop

	dc.w	$92,$30			; DDFSTART = $30 (Bildschirm startet
							; 16 Pixel früher, er verbreitert sich
							; also auf 42 Bytes pro Zeile, 336 Pixel
							; Breite, aber das DIWSTART "versteckt"
							; diese ersten 16 Pixel mit dem Fehler.
							
	dc.w	$102			; BplCon1
	dc.b	0				; hochwertiges Byte des $dff102, nicht verwendet
MEINBPCON1:
	dc.b	0				; niederwertiges Byte des $dff102, verwendet
	dc.w	$104,0			; BplCon2
	;dc.w	$108,0			; Bpl1Mod
	;dc.w	$10a,0			; Bpl2Mod
	
	dc.w	$108,-2			; MODULO = -2, wir müssen die ersten
	dc.w	$10a,-2			; 16 Pixel "überspringen", indem wir
							; sie zwei Mal lesen lassen
	
				; 5432109876543210
	dc.w	$100,%0011001000000000  ; Bits 12 +13 an! (3 = %011)

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste  Bitplane
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane
	dc.w	$e8,$0000,$ea,$0000	; dritte Bitplane

	dc.w	$0180,$000		; Color0
	dc.w	$0182,$475		; Color1
	dc.w	$0184,$fff		; Color2
	dc.w	$0186,$ccc		; Color3
	dc.w	$0188,$999		; Color4
	dc.w	$018a,$232		; Color5
	dc.w	$018c,$777		; Color6
	dc.w	$018e,$444		; Color7
 
	dc.w	$FFFF,$FFFE		; Ende der Copperlist
	
	dcb.b	80*40,0			; auf NULL gesetzter Speicher vor dem Bitplane

PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"	; hier laden wir das Bild in RAW

	dcb.b	40,0			; siehe oben


	end

Furchtbar,  der  "Wackelkontakt" beim linken Rand des Monitors, gell?? Ihn
zu  eliminieren  ist  nicht  schwierig,  einfach  zwei  Kleinigkeiten
austauschen, schauen wir was und warum: das Warum ist darin zu suchen, daß
die DMA-Kanäle nicht über die Bewegung des Bildes informiert sind und  sie
somit unvorbereitet sind, und so nicht die Zeit haben, die ersten 16 Pixel
ganz Links zu lesen. Was können wir dagegen tun? Nichts.
Aber  wir  können  dieses  Mißgeschick  außerhalb  des  sichtbaren  Feldes
ablaufen  lassen,  erinnert ihr euch an die Kollegen DIWSTART und DIWSTOP?
Sie bestimmen die Größe des Bildschirmes,  auf  dem  die  Daten  angezeigt
werden.  Es leuchtet ein, daß wenn wir das Videofenster um 16 Pixel weiter
rechts starten lassen, das Problem "zugestopft" wird:

	dc.w	$8E,$2c91		; DiwStrt ($81+16=$91)

Tauscht den Wert aus und startet erneut das Listing. Auch wenn wir  dieses
Problem  beseitigt haben, jetzt tritt ein weiteres auf: wir haben nur mehr
304 Pixel zur Verfügung, und nicht mehr 320. Und dann ist alles auch  noch
verschoben!!  Aber  die  Register DDFSTART und DDFSTOP eilen uns zu Hilfe!
Diese Register kümmern sich um  die  Größe  des  Videofensters,  aber  auf
andere  Art  und  Weise. Während das DIWSTART/STOP wie ein schwarzes Stück
Papier ist, dessen rechteckigen Ausschnitt  wir  in  Dimension  und  Größe
ändern können, wie das Bild unten zeigt,


	#####################
	#####################
	#####			#####
	#####	Bild	#####
	#####			#####
	#####			#####
	#####			#####
	#####			#####
	#####			#####
	#####################
	#####################

ist das DDFSTART/STOP anders: damit verändern wir wirklich die Länge einer
Videozeile;  wenn wir z.B. den Bildschirm um 16 Pixel verbreitern, und ihn
somit 336 Pixel pro Zeile groß werden lassen,  also  42  Bytes  pro  Zeile
statt  40,  dann  müssen  wir wirklich 42 Bytes pro Zeile verarbeiten. Der
OVERSCAN-MODUS,  der  über  die  üblichen  320x256  bzw.  640x256  Pixel
hinausreicht,  wird  genau  mit den DDFSTART und DDFSTOP erreicht, ohne zu
vergessen, das Videofenster mit den DIWSTART und DIWSTOP zu "vergrößern".

Zurück  zu  unserem Problem: wir müssen zusehen, daß dieser Fehler, der 16
Pixel breit ist, außerhalb unseres Sichtfeldes stattfindet. Wir müssen mit
dem  DDFSTART  das Bild um 16 Pixel weiter rechts beginnen lassen, und ihn
bei der selben Position enden lassen, und die  Werte  in  DIWSTART/DIWSTOP
gleich  lassen.  Damit  werden  wir  immer  320x256  Pixel sehen, aber das
Videofenster ist in Wirklichkeit 336 Pixel breit,  und  der  Fehler  tritt
außerhalb  des  Bildschirmes  auf. Das Bild wird somit aber 42 Byte breit,
und das müssen wir diese 2 Bytes ( 16 Pixel) für jede  Zeile  im  Programm
ausgleichen.
Wie schaffen wir es, bei Ende der Zeile (jetzt bei Byte  42)  um  2  Bytes
zurückzugehen,  um  die Zeile korrekt anzuzeigen? Kurzum, daß die Rechnung
aufgeht? Indem wie dem Modulo 2 abziehen. In unserem Fall, mit dem  Modulo
auf NULL, einfach auf -2 setzen.
Um den Bildschirm 16 Pixel  früher  starten  zu  lassen,  müssen  folgende
Änderungen im DATA FETCH START (DDFSTART) vorgenommen werden:


	dc.w	$92,$30			; DDFSTART = $30 (Bildschirm startet
							; 16 Pixel früher, er verbreitert sich
							; also auf 42 Bytes pro Zeile, 336 Pixel
							; Breite, aber das DIWSTART "versteckt"
							; diese ersten 16 Pixel mit dem Fehler.


	dc.w	$108,-2			; MODULO = -2, wir müssen die ersten
	dc.w	$10a,-2			; 16 Pixel "überspringen", indem wir
							; sie zwei Mal lesen lassen


Bringt diese Änderungen an und stellt das DIWSTART wieder her:

	dc.w $8E,$2c81			; DiwStrt

Jetzt  ist  der  Scroll PERFEKT. Einzig und allein ist jetzt der Nachteil,
daß mit  vergrößern  des  Videofensters  der  Sprite7,  also  der  letzte,
verschwindet.

P.S.:  Wenn ihr ein bißchen spionieren wollt, was der Fehler außerhalb des
Bildes tut, und ob er noch existiert, lasst das DIWSTART 16  Pixel  früher
starten:

	dc.w	$8E,$2c71		; DiwStrt

Der ist immer noch da!!!!! Aber jetzt sieht ihn niemand.

Habt ihr gesehen, es war doch ein Kinderspiel, diesen Fehler aus der  Welt
zu  schaffen.  Einfach  das DDFSTART um 16 Pixel (bei $30) beginnen lassen
und 2 von den MODULO abziehen.

