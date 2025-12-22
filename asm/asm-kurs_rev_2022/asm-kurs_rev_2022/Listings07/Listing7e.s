
; Listing7e.s	EIN SPRITE WIRD SOWOHL VERTIKAL ALS AUCH HORIZONTAL MIT
;				ZWEI TABELLEN BEWEGT (VORGEFERTIGTEN WERTEN)
;
; Im Kommentar wird erklärt, wie man sich selbst Tabellen herstellen kann.

	SECTION CipundCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Libname
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	Pointen auf das "leere" PIC

	MOVE.L	#BITPLANE,d0	; wohin pointen
	LEA	BPLPOINTERS,A1		; COP-Pointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Pointen auf den Sprite

	MOVE.L	#MEINSPRITE,d0	; Adresse des Sprite in d0
	LEA	SpritePointers,a1	; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088		; START COP
	move.w	#0,$dff1fc		; NO AGA!
	move.w	#$c00,$dff106	; NO AGA!

mouse:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	bne.s	mouse


	bsr.s	BewegeSpriteX	; Bewege Sprite 0 in X-Richtung
	bsr.w	BewegeSpriteY	; Bewege Sprite 0 in Y-Richtung

Warte:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	beq.s	Warte

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse


	move.l	OldCop(PC),$dff080	; Pointen auf die alte SystemCOP
	move.w	d0,$dff088		; Starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable
	move.l	gfxbase(PC),a1
	jsr	-$19e(a6)			; Closelibrary
	rts

;	Daten

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0

; In diesem Beispiel wurden die Routinen und Tabellen aus den vorigen
; Beispielen verwendet, wir verändern damit die X- und die Y-Position
; des Sprites. Da beide Tabellen 200 Werte haben, werden immer die
; gleichen Paare zusammenkommen:

; Wert 1 der Tabelle X + Wert 1 der Tabelle Y
; Wert 2 der Tabelle X + Wert 2 der Tabelle Y
; Wert 3 der Tabelle X + Wert 3 der Tabelle Y
; ....
; Das Resultat ist dann, daß der Sprite in die Diagonale geht, wie wir es schon
; gesehen haben, wenn man addq.b #1,HSTART und addq.b #1,VSTART/VSTOP
; zusammengibt.


; Diese Routine bewegt den Sprite indem die auf das Byte HSTART, also
; dem Byte seiner X-Pos, zugreift. Es werden die Werte einer vorausberechneten
; Tabelle (TABX) eingesetzt. Wenn wir nur auf HSTART agieren, dann bewegen wir
; den Sprite um jeweils 2 Pixel, und nicht nur einem, deswegen ist der Scroll
; etwas "ruckelig", vor allem wenn er langsamer wird.
; In den nächsten Listings werden wir dieses Manko beheben und mit einem Pixel
; scrollen.

BewegeSpriteX:
	ADDQ.L	#1,TABXPOINT		; Pointe auf das nächste Byte
	MOVE.L	TABXPOINT(PC),A0	; Adresse, die im Long TABXPOINT enthalten ist
								; wird in a0 kopiert
	CMP.L	#ENDETABX-1,A0		; Sind wir beim letzten Long der TAB?
	BNE.S	NOBSTARTX			; noch nicht? dann mach´ weiter
	MOVE.L	#TABX-1,TABXPOINT	; Starte wieder beim ersten Long
NOBSTARTX:
	MOVE.b	(A0),HSTART			; Kopiert das Byte aus der Tabelle nach HSTART
	rts

TABXPOINT:
	dc.l	TABX-1		; BEMERKUNG: Die Werte in der Tabelle sind Bytes,
						; deswegen arbeiten wir mit einem ADDQ.L #1,TABXPOINT
						; und nicht mit #2 wie es bei Word der Fall wäre oder
						; mit #4, Longword.

; Tabelle mit vordefinierten X-Koordinaten.
; Zu Bemerken, daß die X-Werte innerhalb der Grenzen $40 und $d8 sein müssen,
; in der Tabelle kommen deswegen keine Werte vor, die kleiner als $40 oder
; größer als $d8 sind.

TABX1: ; TABX
	dc.b	$41,$43,$46,$48,$4A,$4C,$4F,$51,$53,$55,$58,$5A ; 200 Werte
	dc.b	$5C,$5E,$61,$63,$65,$67,$69,$6B,$6E,$70,$72,$74
	dc.b	$76,$78,$7A,$7C,$7E,$80,$82,$84,$86,$88,$8A,$8C
	dc.b	$8E,$90,$92,$94,$96,$97,$99,$9B,$9D,$9E,$A0,$A2
	dc.b	$A3,$A5,$A7,$A8,$AA,$AB,$AD,$AE,$B0,$B1,$B2,$B4
	dc.b	$B5,$B6,$B8,$B9,$BA,$BB,$BD,$BE,$BF,$C0,$C1,$C2
	dc.b	$C3,$C4,$C5,$C5,$C6,$C7,$C8,$C9,$C9,$CA,$CB,$CB
	dc.b	$CC,$CC,$CD,$CD,$CE,$CE,$CE,$CF,$CF,$CF,$CF,$D0
	dc.b	$D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0,$CF,$CF,$CF
	dc.b	$CF,$CE,$CE,$CE,$CD,$CD,$CC,$CC,$CB,$CB,$CA,$C9
	dc.b	$C9,$C8,$C7,$C6,$C5,$C5,$C4,$C3,$C2,$C1,$C0,$BF
	dc.b	$BE,$BD,$BB,$BA,$B9,$B8,$B6,$B5,$B4,$B2,$B1,$B0
	dc.b	$AE,$AD,$AB,$AA,$A8,$A7,$A5,$A3,$A2,$A0,$9E,$9D
	dc.b	$9B,$99,$97,$96,$94,$92,$90,$8E,$8C,$8A,$88,$86
	dc.b	$84,$82,$80,$7E,$7C,$7A,$78,$76,$74,$72,$70,$6E
	dc.b	$6B,$69,$67,$65,$63,$61,$5E,$5C,$5A,$58,$55,$53
	dc.b	$51,$4F,$4C,$4A,$48,$46,$43,$41
ENDETABX1:

TABX: ; TABX2
	dc.b	$8A,$8D,$90,$93,$95,$98,$9B,$9E,$A1,$A4,$A7,$A9 ; 150 Werte
	dc.b	$AC,$AF,$B1,$B4,$B6,$B8,$BA,$BC,$BF,$C0,$C2,$C4
	dc.b	$C6,$C7,$C8,$CA,$CB,$CC,$CD,$CE,$CE,$CF,$CF,$D0
	dc.b	$D0,$D0,$D0,$D0,$CF,$CF,$CE,$CE,$CD,$CC,$CB,$CA
	dc.b	$C8,$C7,$C6,$C4,$C2,$C0,$BF,$BC,$BA,$B8,$B6,$B4
	dc.b	$B1,$AF,$AC,$A9,$A7,$A4,$A1,$9E,$9B,$98,$95,$93
	dc.b	$90,$8D,$8A,$86,$83,$80,$7D,$7B,$78,$75,$72,$6F
	dc.b	$6C,$69,$67,$64,$61,$5F,$5C,$5A,$58,$56,$54,$51
	dc.b	$50,$4E,$4C,$4A,$49,$48,$46,$45,$44,$43,$42,$42
	dc.b	$41,$41,$40,$40,$40,$40,$40,$41,$41,$42,$42,$43
	dc.b	$44,$45,$46,$48,$49,$4A,$4C,$4E,$50,$51,$54,$56
	dc.b	$58,$5A,$5C,$5F,$61,$64,$67,$69,$6C,$6F,$72,$75
	dc.b	$78,$7B,$7D,$80,$83,$86
ENDETABX:


	even					; damit gleichen wir die folgende Adresse aus


; Diese Routine bewegt den Sprite nach Oben und nach Unten, indem sie auf
; die Bytes VSTART und VSTOP zugreift, also den Anfangs- und Endkoordinaten
; des Sprites. Es werden schon vordefinierte Koordinaten aus TABY eingesetzt.

BewegeSpriteY:
	ADDQ.L	#1,TABYPOINT		; Pointe auf das nächste Byte
	MOVE.L	TABYPOINT(PC),A0	; Adresse, die im Long TABXPOINT enthalten ist
								; wird in a0 kopiert
	CMP.L	#ENDETABY-1,A0		; Sind wir beim letzten Long der TAB?
	BNE.S	NOBSTARTY			; noch nicht? dann mach´ weiter
	MOVE.L	#TABY-1,TABYPOINT	; Starte wieder beim ersten Long
NOBSTARTY:
	moveq	#0,d0				; Lösche d0
	MOVE.b	(A0),d0				; kopiere Byte aus der Tabelle in d0
	MOVE.b	d0,VSTART			; kopieren das Byte in VSTART
	ADD.B	#13,D0				; Addiere die Länge des Sprite, um die
								; Endposition	(VSTOP) zu ermitteln
	move.b	d0,VSTOP			; Gib diesen Wert in VSTOP
	rts

TABYPOINT:
	dc.l	TABY-1		; BEMERKUNG: Die Werte in der Tabelle sind Bytes,
						; deswegen arbeiten wir mit einem ADDQ.L #1,TABXPOINT
						; und nicht mit #2 wie es bei Word der Fall wäre oder
						; mit #4, Longword.

; Tabelle mit vordefinierten Y-Koordinaten.
; Zu Bemerken, daß die Y-Werte innerhalb der Grenzen $2c und $f2 sein müssen,
; in der Tabelle kommen deswegen keine Werte vor, die kleiner als $2c oder
; größer als $f2 sind.

TABY:
	dc.b	$EE,$EB,$E8,$E5,$E2,$DF,$DC,$D9,$D6,$D3,$D0,$CD ; Rekord-
	dc.b	$CA,$C7,$C4,$C1,$BE,$BB,$B8,$B5,$B2,$AF,$AC,$A9 ; hochsprung!
	dc.b	$A6,$A4,$A1,$9E,$9B,$98,$96,$93,$90,$8E,$8B,$88 ;
	dc.b	$86,$83,$81,$7E,$7C,$79,$77,$74,$72,$70,$6D,$6B ; 200 Werte
	dc.b	$69,$66,$64,$62,$60,$5E,$5C,$5A,$58,$56,$54,$52
	dc.b	$51,$4F,$4D,$4B,$4A,$48,$47,$45,$44,$42,$41,$3F
	dc.b	$3E,$3D,$3C,$3A,$39,$38,$37,$36,$35,$34,$33,$33
	dc.b	$32,$31,$30,$30,$2F,$2F,$2E,$2E,$2D,$2D,$2D,$2C
	dc.b	$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2D,$2D,$2D
	dc.b	$2E,$2E,$2F,$2F,$30,$30,$31,$32,$33,$33,$34,$35
	dc.b	$36,$37,$38,$39,$3A,$3C,$3D,$3E,$3F,$41,$42,$44
	dc.b	$45,$47,$48,$4A,$4B,$4D,$4F,$51,$52,$54,$56,$58
	dc.b	$5A,$5C,$5E,$60,$62,$64,$66,$69,$6B,$6D,$70,$72
	dc.b	$74,$77,$79,$7C,$7E,$81,$83,$86,$88,$8B,$8E,$90
	dc.b	$93,$96,$98,$9B,$9E,$A1,$A4,$A6,$A9,$AC,$AF,$B2
	dc.b	$B5,$B8,$BB,$BE,$C1,$C4,$C7,$CA,$CD,$D0,$D3,$D6
	dc.b	$D9,$DC,$DF,$E2,$E5,$E8,$EB,$EE
ENDETABY:


	 SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81		; DiwStrt
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$38			; DdfStart
	dc.w	$94,$d0			; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod
				; 5432109876543210
	dc.w	$100,%0001001000000000  ; Bit 12 an!! 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste Bitplane

	dc.w	$180,$000		; Color0	; Hintergrund Schwarz
	dc.w	$182,$123		; Color1	; Farbe 1 des Bitplane, die
							; in diesem Fall leer ist,
							; und deswegen nicht erscheint

	dc.w	$1A2,$F00		; Color17, oder COLOR1 des Sprite0 - ROT
	dc.w	$1A4,$0F0		; Color18, oder COLOR2 des Sprite0 - GRÜN
	dc.w	$1A6,$FF0		; Color19, oder COLOR3 des Sprite0 - GELB

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


; ************ Hier ist der Sprite: NATÜRLICH muß er in CHIP RAM sein! ********

MEINSPRITE:		; Länge 13 Zeilen
VSTART:
	dc.b $50	; Vertikale Anfangsposition des Sprite (von $2c bis $f2)
HSTART:	
	dc.b $90	; Horizontale Anfangsposition des Sprite (von $40 bis $d8)
VSTOP:
	dc.b $5d	; $50+13=$5d	; Vertikale Endposition des Sprite
	dc.b $00
 dc.w	%0000000000000000,%0000110000110000 ; Binäres Format für ev. Änderungen
 dc.w	%0000000000000000,%0000011001100000
 dc.w	%0000000000000000,%0000001001000000
 dc.w	%0000000110000000,%0011000110001100 ; BINÄR 00=COLOR 0 (DURCHSICHTIG)
 dc.w	%0000011111100000,%0110011111100110 ; BINÄR 10=COLOR 1 (ROT)
 dc.w	%0000011111100000,%1100100110010011 ; BINÄR 01=COLOR 2 (GRÜN)
 dc.w	%0000110110110000,%1111100110011111 ; BINÄR 11=COLOR 3 (GELB)
 dc.w	%0000011111100000,%0000011111100000
 dc.w	%0000011111100000,%0001111001111000
 dc.w	%0000001111000000,%0011101111011100
 dc.w	%0000000110000000,%0011000110001100
 dc.w	%0000000000000000,%1111000000001111
 dc.w	%0000000000000000,%1111000000001111
 dc.w	0,0		; 2 word auf NULL definieren das Ende des Sprite.


	SECTION LEERESPLANE,BSS_C	; Ein auf 0 gesetztes Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end

Bis  jetzt  haben  wir den Sprite horizontal, vertikal und diagonal laufen
lassen, aber niemals Kurven. Gut, ihr müßt nur dieses  Listing  verändern,
um  alle  möglichen  Kurven  zu  erzeugen, denn wir können seine X- und Y-
Koordianten ändern, wie wir wollen. In diesem Listing sind beide  Tabellen
gleich  lang,  200  Werte,  deswegen werden wir immer die gleichen "Paare"
haben:


 Wert 1 der Tabelle X + Wert 1 der Tabelle Y
 Wert 2 der Tabelle X + Wert 2 der Tabelle Y
 Wert 3 der Tabelle X + Wert 3 der Tabelle Y

 ....

Daraus  ergibt  sich immer die gleiche Oszillierung in die Diagonale. Wenn
aber eine der beiden Tabellen kürzer wäre, dann  würde  diese  früher  von
vorne  beginnen  als  die  andere.  Und  das  würde dann immer neue Muster
ergeben, denn jedesmal kämen andere Paare zusammen:

 Wert 23 der Tabelle X + Wert 56 der Tabelle Y
 Wert 24 der Tabelle X + Wert 57 der Tabelle Y
 Wert 25 der Tabelle X + Wert 58 der Tabelle Y
....

Diese Werte würden dann kurvenförmige Schwingungen des Sprites ergeben.

Probiert mal, folgende Tabelle der X-Werte statt  der  alten  einzusetzen:
(Amiga+b+c+i zum Kopieren, Amiga+b+x um ein Stück zu löschen)

TABX2:
	dc.b	$8A,$8D,$90,$93,$95,$98,$9B,$9E,$A1,$A4,$A7,$A9 ; 150 Werte
	dc.b	$AC,$AF,$B1,$B4,$B6,$B8,$BA,$BC,$BF,$C0,$C2,$C4
	dc.b	$C6,$C7,$C8,$CA,$CB,$CC,$CD,$CE,$CE,$CF,$CF,$D0
	dc.b	$D0,$D0,$D0,$D0,$CF,$CF,$CE,$CE,$CD,$CC,$CB,$CA
	dc.b	$C8,$C7,$C6,$C4,$C2,$C0,$BF,$BC,$BA,$B8,$B6,$B4
	dc.b	$B1,$AF,$AC,$A9,$A7,$A4,$A1,$9E,$9B,$98,$95,$93
	dc.b	$90,$8D,$8A,$86,$83,$80,$7D,$7B,$78,$75,$72,$6F
	dc.b	$6C,$69,$67,$64,$61,$5F,$5C,$5A,$58,$56,$54,$51
	dc.b	$50,$4E,$4C,$4A,$49,$48,$46,$45,$44,$43,$42,$42
	dc.b	$41,$41,$40,$40,$40,$40,$40,$41,$41,$42,$42,$43
	dc.b	$44,$45,$46,$48,$49,$4A,$4C,$4E,$50,$51,$54,$56
	dc.b	$58,$5A,$5C,$5F,$61,$64,$67,$69,$6C,$6F,$72,$75
	dc.b	$78,$7B,$7D,$80,$83,$86
ENDETABX:

Nun könnt ihr euren Sprite am Bildschirm bewundern,  wir  er  realistische
und  variable  Bewegungen  ausführt.  Das  ist das  Ergebnis  der
unterschiedlichen Längen der Tabellen.

Mit  zwei  Tabellen,  einer  für  die  XX-Richtung  und  einer	für  die
YY-Richtung,  werden  auch verschiedene kurvenförmige Bewegungen bei Demos
und Spielen hergestellt, z.B. den Wurf einer Granate:

		    .  .
	      .	     .
	    .	      .
	 o /		   .
	/||	     
	 /\			 BOOM!!

Der Verlauf  der  Richtung  der  Bombe  unseres  Helden  wurde  durch  das
Vorausberechnen  dieser  in  XX  und YY Koordinaten simuliert. Da sich das
Männchen auf jeder beliebigen Position am Bildschirm befinden konnte, z.B.
ganz  links unten oder mitte-rechts, wird einfach die Position des Werfers
zu der Kurve addiert,  und  somit  wird  die  Bombe  vom  richtigen  Punkt
abgeworfen  und  geht  dann (hoffentlich) ins Ziel. Oder auch die Bewegung
eines Geschwaders von außerirdischen Raumschiffen:


						   @  @  @  @  @  @  @  @ <--
					   @	  @
					@			 @

					@  			 @
					   @      @ 
	   <--  @  @  @  @  @  @


Die Anwendungsgebiete der Tabellen sind unendlich.

Ihr werdet euch nun  fragen:  Müssen  wir  uns  diese  Tabellen  per  Hand
ausrechnen,  und  die  Kurve  Pi  mal Daumen erraten? NEIN. Der Asmone hat
einen Befehl, den "CS" (oder "IS"), der  ausreicht,  um  die  Tabellen  zu
errechnen,  die  wir  in  diesem Kurs verwenden (ich habe sie wirklich mit
diesem Befehl gemacht!). Wenn es einer  ganz  speziellen  Tabelle  bedarf,
dann  kann  man  sich  auch  ein Programm schreiben, das einen eine solche
erstellt.

Ich nehme das Argument "wie mache ich mir eine Tabelle?" voraus:

Der Befehl CS bedeutet  "CREATE  SINUS",  für  diejenigen,  die  sich  ein
bißchen mit Trigonometrie auskennen bedeutet das "Ist das alles?", während
für diejenigen, die sie nicht kennen, es ein "Was iss´n das?" werden wird.
Da  das nur ein Vorwort ist, werde ich nur erklären, wie man die Parameter
für die Befehle "CS" und "IS" vergibt.
Der Befehl "CS" erzeugt die Werte im  Speicher  an  der  Adresse  oder  am
Label,  das  angegeben  wird,  wenn  z.B. schon eine Tab mit 200 Werten am
Label TABX besteht, und wir als Adresse "TABX" angeben, dann wird nach dem
Assemblieren  eine  andere Tabelle zu 200 Bytes erstellen, dann wird diese
letzte  beim  Ausführen  verwendet werden.  Wenn wir  aber  nochmal
assemblieren, dann wird wieder die alte, orginale zum Vorschein kommen, da
der Text (dc.b $xx,$xx...) ja nicht gelöscht wurde.  Um  eine  Tabelle  zu
speichern kann sie über einer anderen mit gleichviel Werten erzeugt werden
oder man kann einen sogenannten "Buffer" machen, also ein Stück  Speicher,
der zum Erstellen und Abspeichern von Tabellen gewidmet ist.
Machen wir ein praktisches Beispiel: Wir  wollen  eine  spezielle  Tabelle
machen,  die 512 Bytes lang ist, und wir wollen sie auf Disk speichern, um
sie dann mit dem Befehl incbin hereinladen zu können:


TABX: incbin "TABELLE1"

Um  so  eine  Tabelle  erzeugen  zu  können,  müssen wir zuerst eine leere
Portion Speicher für die Tabelle schaffen. Sie muß 512 Bytes groß sein, um
dann mit dem Befehl "CS" die Tabelle zu erstellen:

PLATZ:
	dcb.b	512,0	; 512 Byte auf NULL, dort kommt dann die Tabelle rein
ENDEPLATZ:

Einmal assembliert werden wir eine Tabelle erzeugen und als Ziel
"PLATZ" angeben:

 DEST> PLATZ

Und natürlich 512 Werte generieren, von der Größe eines BYTE:

 AMOUNT> 512
 SIZE (B/W/L)> B

Nun haben  wir  512  Bytes,  die  die  Tabelle  ergeben,  von  PLATZ:  bis
ENDEPLATZ:,  wir  müssen dieses Stück jetzt auf Disk abspeichern. Dazu hat
der ASMONE den  Befehl  "WB"  (Write  Binary,  oder  "Schreibe  ein  Stück
Speicher").  Um  unsere  TAB abzuspeichern müssen wir folgende Operationen
machen:

1) "WB" tippen und den Namen des File eingeben, z.B. "TABELLE1"
2) Bei der Frage BEG> (Begin, oder "ab wo?") PLATZ schreiben
3) Bei der Frage END> (Ende) ENDEPLATZ eingeben.

Das ist alles, nun haben wir einen File, der Tabelle1 heißt  und  den  wir
später mit incbin hereinholen können.

Der  Befehl  WB  kann  dazu  verwendet  werden,  ein jedes beliebige Stück
Speicher abzuspeichern! Ihr könnt versuchen,  einen  Sprite  abzuspeichern
und ihn dann mit dem INCBIN einbinden.

Die  andere  Methode  ist  das "IS", oder INSERT SINUS, also Sinus im Text
einfügen. Damit wird die Tabelle direkt  in  Textformat  dc.b  im  Listing
erzeugt. Sie kann bei kleinen Tabellen recht bequem sein.

Einfach  den  Cursor  dorthin  platzieren, wo wir die Tabelle haben wollen,
z.B. unter  dem  Label  "TABX:",  ESC  drücken  um  zur  Kommandozeile  zu
wechseln,  und  dann  die Tabelle mit "IS" anstatt mit "CS" erstellen. Die
Prozedur und die Parameter sind die gleichen. Nochmals ESC drücken, um  in
den  Editor  zurückzugelangen  und  ihr  werdet die Tabelle als dc.b unter
TABX: vorfinden.

Aber sehen wir nun, wie wir eine SINTAB mit den Befehlen CS oder IS erstellen:


 DEST> Zieladresse- oder Label, z.B.: DEST>tabx
 BEG> Startwinkel (0-360) (es können auch Werte größer als 360 eing. werden)
 END> Endwinkel (0-360)
 AMOUNT> Anzahl der zu generierenden Werte (z.B.: 200, wie in diesem Listing)
 AMPLITUDE> Amplitude, also höchster zu erreichender Wert
 YOFFSET> Offset (Zahl, die dazugezählt werden soll, um alles nach "Oben"
 		   zu versetzen)
 SIZE (B/W/L)> Dimension der Werte (byte,word,long)
 MULTIPLIER> "Multiplizieren" (Multipliziert die Amplitude)
 HALF CORRECTION>Y/N	\ diese dienen zum "glätten" der Kurve,
 ROUND CORRECTION>Y/N	/ falls irgendwo Sprünge auftreten

Wer weiß, was ein Sinus und ein Cosinus ist, der versteht im Flug, was  zu
tun  ist,  den  anderen  kann  ich sagen, daß BEG> und END> den Start bzw.
Zielwinkel der Welle angeben, also die Form der Welle, ob  diese  steigend
oder  fallend  beginnt.  Es  folgen  einige  Beispiele  mit  der Zeichnung
daneben.

- Mit AMOUNT> gibt man an, wieviele Werte die Tabelle haben soll.
- Mit AMPLITUDE definiert man die Amplitude der Welle, also welchen Maximal-
  wert sie erreichen soll, oder Minimalwert, wenn die Kurve ins Negative
  startet.
- Mit YOFFSET entscheidet man, wieviel die ganze Kurve "gehoben" werden soll,
  wieviel also zu jedem Wert der Tabelle addiert werden soll. Wenn eine Tab
  z.B. aus 0,1,2,3,4,5,4,3,2,1,0 besteht, mit einem YOFFSET von 0, dann wird
  durch ein YOFFSET von 10 die Tabelle so aussehen:

	 10,11,12,13,14,15,14,13,12,11,10.

  Bei den Sprites haben wir z.B. den Fall, daß das X bei $40 startet und bei
  $d8 ankommt, unser YOFFSET wird also $40 sein, um die eventuellen $00 in
  $40 zu "verwandeln", die $01 in $41 usw.
- Mit SIZE entscheiden wir, ob die Werte der Tabelle aus Byte, Word oder
  Longword bestehen sollen. Die Spritekoordinaten werden in BYTE angegeben.
- MULTIPLIER> ist ein Multiplikator der Amplitude, wenn man nichts multipliz.
  will einfach 1 eingeben.

Nun  bleibt  noch  übrig, zu verstehen, wie die "Form der Welle" definiert
wird, also das Wichtigste. Dafür können wir nur BEG> und  END>  verwenden,
die sich auf den Start und den Endwinkel dieser Welle beziehen. Denen, die
mit  Trigonometrie  nichts  gemeinsam  haben,  rate  ich,  sie  etwas	zu
studieren.  Sie  ist  recht  wichtig,  vor allem bei den dreidimensionalen
Routinen. Kurzum kann ich es so erklären: stellt  euch  den  Umfang  eines
Kreises  mit  dem  Mittelpunkt  O  und  einem  beliebigen  Radius vor (Aus
technischen Gründen ist der Kreis nicht rund...), der sich im  Mittelpunkt
der  Achsen  X  und  Y befindet (0,0): (zeichnet euch diese Durchgänge auf
Papier nach)

				   |
				   | y
				   |
				  _L_
				 / | \	Achse x
		--------|--o--|---------»
				 \_L_/
				   |
				   |
				   |


Nehmen wir nun an, dieser  Kreis  sei  eine  Uhr  mit  einem  Zeiger,  der
rückwärts geht (ein blödes Beispiel!), der bei dieser Position startet:

						  90 grad
						_____
					   /	 \
					  /		  \
					 /		   \
	    180 grad	(	  O---» ) 0 grad
					 \		   /
					  \		  /
					   \_____/

					 270 grad

(Denkt einfach, das sei ein Kreis!!!) Es ist praktisch 3  Uhr.  An  Stelle
der Stunden haben wir hier die Grade, die vom Zeiger angezeigt werden, und
das gegenüber der X-Achse. Um 12 Uhr z.B. ist er auf 90 Grad:


						  90 grad
						_____
					   /  ^  \
					  /   |   \
					 /    |    \
			180 grad(     O     ) 0 grad
					 \		   /
					  \		  /
					   \_____/

					 270 grad


Und das sind 45 Grad:


						  90 grad
						_____
					   /     \
					  /     / \
					 /     /   \
			180 grad(     O     ) 0 grad (oder 360, die komplette Runde)
					 \		   /
					  \	      /
					   \_____/

					 270 grad


Alles klar mit dieser dummen  Uhr,  die  rückwärts  läuft  und  statt  der
Stunden  die  Grad  anzeigt?? Nun kommen wir zum Zusammenhang zwischen den
BEG> und END> des Befehles "VS". Mit dieser Uhr können wir nun eine Studie
anfertigen,  die uns den Verlauf des Sinus (oder des Cosinus, wieso nicht)
angibt. Stellen wir uns vor,  wir  lassen  den  Zeiger  eine  volle  Runde
drehen:  wenn  wir  in  einer  danebenstehenden  Grafik  den  Verlauf  der
Zeigerspitze gegenüber der Y-Achse aufzeichnen, werden wir  bemerken,  daß
sie bei 0 beginnt, bis zu einem Maximum ansteigt, das bei 90 Grad erreicht
ist, wieder sinkt, bis es bei 180 Grad wieder den Nullpunkt  erreicht  hat
und  weitersinkt  bis zu einem Minimum bei 270 Grad. Ab hier geht´s wieder
aufwärts bis zum anfänglichen Nullpunkt bei 360 Grad  (der  Startposition,
oder 0 Grad).



			  90 grad 
			_____
		   /	 \
		  /		  \
		 /		   \
 180 g.	(     O---» ) 0 grad 	*-----------------------------------
		 \		   /			0	   90	   180		270		 360 (grad )
		  \		  /
		   \_____/
		 270 grad 


			  90 grad 
			_____
		   /	 \ 	45 grad 
		  /		/ \- - - - - - - - *
		 /     /   \			 *
 180 g.	(     O     ) 0 grad 	*-------------------------------------
		 \		   /			0	   90	   180		270		 360 (grad )
		  \	      /
		   \_____/
		 270 grad 


	      90 grad 
			_____ _ _ _ _ _ _ _ _ _ _ _ *
		   /  ^  \ 					 * 
		  /   |   \ 			   *
		 /    |    \			 *
 180 g.	(     O     ) 0 grad 	*-----------------------------------
		 \		   /			0	   90	   180		270		 360 (grad )
		  \		  /
		   \_____/
		 270 grad 


			  90 grad 
			_____ 					   * *
		   /     \ 	135 grad		 *     *
		  / \     \- - - - - - - - * - - - - *
		 /   \     \			 *
 180 g.	(     O     ) 0 grad 	*-----------------------------------
		 \		   /			0	   90	   180		270		 360 (grad )
		  \		  /
		   \_____/
		 270 grad 


			  90 grad 
			_____ 					   * *
		   /     \ 					 *     *
		  /		  \				   *	     *
		 /		   \			 *	          *
 180 g.	( <---O     ) 0 grad 	*---------------*---------------------
		 \		   /			0	   90	   180		270		 360 (grad )
		  \		  /
		   \_____/
		 270 grad 


			  90 grad 
			_____ 					   * *
		   /     \ 					 *     *
		  /		  \				   *	     *
		 /		   \			 *			   *
 180 g.	(     O     ) 0 grad 	*---------------*---------------------
		 \   /	   /			0	   90	   180		270		 360 (grad )
		  \ /	  /- - - - - - - - - - - - - - - - -*
		   \_____/		225 grad 
		 270 grad 


			  90 grad  
			_____ 					   * *
		   /     \ 					 *     *
		  /		  \				   *	     *
		 /		   \			 *	           *
 180 g.	(     O     ) 0 grad 	*---------------*---------------------
		 \    |	   /			0	   90	   180		270		 360 (grad )
		  \   |	  /								   *
		   \__L__/									 *
		 270 grad  - - - - - - - - - - - - - - - - - - *


			  90 grad 
			_____ 					   * *
		   /     \ 					 *     *
		  /		  \				   *		 *
		 /		   \			 *			   *
 180 g.	(     O     ) 0 grad 	*---------------*---------------------
		 \	   \   /			0	   90	   180		270		 360 (grad )
		  \	 	\ /- - - - - - - - - - - - - - - - * - - - -	*
		   \_____/		315 grad 					 *		  *
		 270 grad 									    *  *


			  90 grad 
			_____ 					   * *
		   /     \ 					 *     *
		  /		  \				   *	     *
		 /		   \			 *	           *
 180 g.	(     O---> ) 0 grad 	*---------------*----------------*----
		 \ 		   /			0	   90	   180		270		 360 (grad )
		  \		  /								   *			*
		   \_____/		360 grad 				     *		  *
		 270 grad 									    *  *


Ich hoffe, mich klar genug ausgedrückt zu haben, vor allem für diejenigen,
die  bei  Mathematik  gerade  auf Diät sind: um eine Kurve, die steigt und
sinkt, braucht man nur als Anfangswinkel 0 und Endwinkel  180  eingeben!!!
Für  eine  Kurve, die sinkt und steigt als BEG> 180 und END> 360 eingeben.
So auch für alle anderen Kurven. Durch ändern der AMPLITUDE,  YOFFSET  und
MULTIPLIER  macht  ihr  Kurven,  die  länger  oder  kürzer,  breiter  oder
schmäler, höher oder niedriger sind. Es können auch Werte größer  als  360
verwendet  werden,  um  die  Kurve  beim  "zweiten  Uhrendurchgang"  noch
aufzuzeichnen, da die Funktion ja immer gleich ist:

/\/\/\/\/\/\/\/\/\/\/\.....

Machen wir einige Beispiele: (Unter der Zeichnung wird eine Anmerkung über die
			      effektive Tabelle gemacht: 0,1,2,3...999,1000..
			      oder dessen Inhalt)
  EIN BEISPIEL VON SINUS:

					   +	 __
  DEST>cosintabx	   _ _ _/_ \_ _ _ _ _ _  = 512 words:
  BEG>0							\__/
  END>360			   -   0      360
  AMOUNT>512	0,1,2,3...999,1000,999..3,2,0,-1,-2,-3..-1000,-999,...-2,-1,0
  AMPLITUDE>1000
  YOFFSET>0
  SIZE (B/W/L)>W
  MULTIPLIER>1


  EIN BEISPIEL VON COSINUS:

 						+	  _		 _
  DEST>cosintabx	    _ _ _ _\_ _ /_ _ _ _  = 512 words:
  BEG>90						\__/
  END>360+90		   -	90      450
  AMOUNT>512	1000,999..3,2,0,-1,-2,-3..-1000,-999,...-2,-1,0,1,2...999,1000
  AMPLITUDE>1000
  YOFFSET>0
  SIZE (B/W/L)>W
  MULTIPLIER>1


EIN WEITERES BEISPIEL:

 						 +	 ___
  DEST>cosintabx	   _ _ _/_ _\_ _ _ _  = 800 words:
  BEG>0				    
  END>180				 -	0  180
  AMOUNT>800		0,1,2,3,4,5...999,1000,999..3,2,1,0 (800 valori)
  AMPLITUDE>1000
  YOFFSET>0
  SIZE (B/W/L)>W
  MULTIPLIER>1


EIN WEITERES BEISPIEL:		  _
 						+	 / \
  DEST>cosintabx	   _ _ _/_ _\_ _ _ _  = 800 words:
  BEG>0				    
  END>180				 -	0  180
  AMOUNT>800		0,1,2,3,4,5...1999,2000,1999..3,2,1,0 (800 valori)
  AMPLITUDE>1000
  YOFFSET>0
  SIZE (B/W/L)>W
  MULTIPLIER>2	<--


EIN WEITERES BEISPIEL:		 _		_
						 +	  \    /
  DEST>cosintabx	    _ _ _ _\__/_ _ _ _  = 512 words:
  BEG>90			   
  END>360+90			 -	90      450
  AMOUNT>512	     2000,1999..3,2,0,1,2...1999,2000
  AMPLITUDE>1000
  YOFFSET>1000
  SIZE (B/W/L)>W
  MULTIPLIER>1


LETZTES BEISPIEL:			 _		_
						 +	  \    /
  DEST>cosintabx	    _ _ _ _\__/_ _ _ _  = 360 words:
  BEG>90			   
  END>360+90			 -	90      450
  AMOUNT>360	     304,303..3,2,0,1,2...303,304
  AMPLITUDE>152
  YOFFSET>152
  SIZE (B/W/L)>W
  MULTIPLIER>1
  HALF CORRECTION>Y
  ROUND CORRECTION>N


Hier nun die Anleitung, wie ihr die Tabellen der vorigen Beispiele mit den
Koordianten  XX  und  YY  ersetzen  könnt:  (Parameter  für das CS und der
endgültigen Tabelle)

Für die X-Koordinaten, die von $40 bis $d8 gehen

; DEST> tabx
; BEG> 0		 ___ $d0
; END> 180		/   \40
; AMOUNT> 200
; AMPLITUDE> $d0-$40	; $40,$41,$42...$ce,$cf,d0,$cf,$ce...$43,$41....
; YOFFSET> $40	; die NULL wird in $40 verwandelt
; SIZE (B/W/L)> b
; MULTIPLIER> 1

	dc.b	$41,$43,$46,$48,$4A,$4C,$4F,$51,$53,$55,$58,$5A
	dc.b	$5C,$5E,$61,$63,$65,$67,$69,$6B,$6E,$70,$72,$74
	dc.b	$76,$78,$7A,$7C,$7E,$80,$82,$84,$86,$88,$8A,$8C
	dc.b	$8E,$90,$92,$94,$96,$97,$99,$9B,$9D,$9E,$A0,$A2
	dc.b	$A3,$A5,$A7,$A8,$AA,$AB,$AD,$AE,$B0,$B1,$B2,$B4
	dc.b	$B5,$B6,$B8,$B9,$BA,$BB,$BD,$BE,$BF,$C0,$C1,$C2
	dc.b	$C3,$C4,$C5,$C5,$C6,$C7,$C8,$C9,$C9,$CA,$CB,$CB
	dc.b	$CC,$CC,$CD,$CD,$CE,$CE,$CE,$CF,$CF,$CF,$CF,$D0
	dc.b	$D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0,$CF,$CF,$CF
	dc.b	$CF,$CE,$CE,$CE,$CD,$CD,$CC,$CC,$CB,$CB,$CA,$C9
	dc.b	$C9,$C8,$C7,$C6,$C5,$C5,$C4,$C3,$C2,$C1,$C0,$BF
	dc.b	$BE,$BD,$BB,$BA,$B9,$B8,$B6,$B5,$B4,$B2,$B1,$B0
	dc.b	$AE,$AD,$AB,$AA,$A8,$A7,$A5,$A3,$A2,$A0,$9E,$9D
	dc.b	$9B,$99,$97,$96,$94,$92,$90,$8E,$8C,$8A,$88,$86
	dc.b	$84,$82,$80,$7E,$7C,$7A,$78,$76,$74,$72,$70,$6E
	dc.b	$6B,$69,$67,$65,$63,$61,$5E,$5C,$5A,$58,$55,$53
	dc.b	$51,$4F,$4C,$4A,$48,$46,$43,$41

--	--	--	--	--	--	--	--	--	--

; DEST> tabx			$d0
; BEG> 180		\____/  $40
; END> 360
; AMOUNT> 200
; AMPLITUDE> $d0-$40	; $cf,$cd,$ca...$42,$41,$40,$41,$42...$ca,$cd,$cf
; YOFFSET> $d0	; Kurve unter NULL! Also müssen wir $d0 dazuzählen
; SIZE (B/W/L)> b
; MULTIPLIER> 1

	dc.b	$CF,$CD,$CA,$C8,$C6,$C4,$C1,$BF,$BD,$BB,$B8,$B6
	dc.b	$B4,$B2,$AF,$AD,$AB,$A9,$A7,$A5,$A2,$A0,$9E,$9C
	dc.b	$9A,$98,$96,$94,$92,$90,$8E,$8C,$8A,$88,$86,$84
	dc.b	$82,$80,$7E,$7C,$7A,$79,$77,$75,$73,$72,$70,$6E
	dc.b	$6D,$6B,$69,$68,$66,$65,$63,$62,$60,$5F,$5E,$5C
	dc.b	$5B,$5A,$58,$57,$56,$55,$53,$52,$51,$50,$4F,$4E
	dc.b	$4D,$4C,$4B,$4B,$4A,$49,$48,$47,$47,$46,$45,$45
	dc.b	$44,$44,$43,$43,$42,$42,$42,$41,$41,$41,$41,$40
	dc.b	$40,$40,$40,$40,$40,$40,$40,$40,$40,$41,$41,$41
	dc.b	$41,$42,$42,$42,$43,$43,$44,$44,$45,$45,$46,$47
	dc.b	$47,$48,$49,$4A,$4B,$4B,$4C,$4D,$4E,$4F,$50,$51
	dc.b	$52,$53,$55,$56,$57,$58,$5A,$5B,$5C,$5E,$5F,$60
	dc.b	$62,$63,$65,$66,$68,$69,$6B,$6D,$6E,$70,$72,$73
	dc.b	$75,$77,$79,$7A,$7C,$7E,$80,$82,$84,$86,$88,$8A
	dc.b	$8C,$8E,$90,$92,$94,$96,$98,$9A,$9C,$9E,$A0,$A2
	dc.b	$A5,$A7,$A9,$AB,$AD,$AF,$B2,$B4,$B6,$B8,$BB,$BD
	dc.b	$BF,$C1,$C4,$C6,$C8,$CA,$CD,$CF

--	--	--	--	--	--	--	--	--	--

;								    ___$d8
; DEST> tabx	                   /   \ $d0-$40 ($90)
; BEG> 0					  \___/     $48
; END> 360
; AMOUNT> 200
; AMPLITUDE> ($d0-$40)/2 ; Amplitude sowohl über als auch unter NULL, wir
			 ; müssen also Halbe-Halbe machen, Hälfte unten, Hälfte
			 ; oben. Also teilen wir die Amplitude durch zwei
; YOFFSET> $90		; und verschieben alles nach Oben, um -72 in $48 zu
; SIZE (B/W/L)> b	; verwandeln
; MULTIPLIER> 1

	dc.b	$91,$93,$96,$98,$9A,$9C,$9F,$A1,$A3,$A5,$A7,$A9
	dc.b	$AC,$AE,$B0,$B2,$B4,$B6,$B8,$B9,$BB,$BD,$BF,$C0
	dc.b	$C2,$C4,$C5,$C7,$C8,$CA,$CB,$CC,$CD,$CF,$D0,$D1
	dc.b	$D2,$D3,$D3,$D4,$D5,$D5,$D6,$D7,$D7,$D7,$D8,$D8
	dc.b	$D8,$D8,$D8,$D8,$D8,$D8,$D7,$D7,$D7,$D6,$D5,$D5
	dc.b	$D4,$D3,$D3,$D2,$D1,$D0,$CF,$CD,$CC,$CB,$CA,$C8
	dc.b	$C7,$C5,$C4,$C2,$C0,$BF,$BD,$BB,$B9,$B8,$B6,$B4
	dc.b	$B2,$B0,$AE,$AC,$A9,$A7,$A5,$A3,$A1,$9F,$9C,$9A
	dc.b	$98,$96,$93,$91,$8F,$8D,$8A,$88,$86,$84,$81,$7F
	dc.b	$7D,$7B,$79,$77,$74,$72,$70,$6E,$6C,$6A,$68,$67
	dc.b	$65,$63,$61,$60,$5E,$5C,$5B,$59,$58,$56,$55,$54
	dc.b	$53,$51,$50,$4F,$4E,$4D,$4D,$4C,$4B,$4B,$4A,$49
	dc.b	$49,$49,$48,$48,$48,$48,$48,$48,$48,$48,$49,$49
	dc.b	$49,$4A,$4B,$4B,$4C,$4D,$4D,$4E,$4F,$50,$51,$53
	dc.b	$54,$55,$56,$58,$59,$5B,$5C,$5E,$60,$61,$63,$65
	dc.b	$67,$68,$6A,$6C,$6E,$70,$72,$74,$77,$79,$7B,$7D
	dc.b	$7F,$81,$84,$86,$88,$8A,$8D,$8F

--	--	--	--	--	--	--	--	--	--

 TABELLE DER Y:

; Zu Bemerken, daß die Y-Position, um den Sprite ins Videofenster zu bringen,
; zwischen $2c und $f2 liegen muß, in der Tat sind in der Tabelle keine Byte
; enthalten, die größer als $f2 oder kleiner als $2c sind.

; DEST> taby			$f0 (d0)
; BEG> 180		\____/  $2c (40)
; END> 360
; AMOUNT> 200
; AMPLITUDE> $f0-$2c	; $ef,$ed,$ea...$2c...$ea,$ed,$ef
; YOFFSET> $f0
; SIZE (B/W/L)> b
; MULTIPLIER> 1

	dc.b	$EE,$EB,$E8,$E5,$E2,$DF,$DC,$D9,$D6,$D3,$D0,$CD ; Rekord-
	dc.b	$CA,$C7,$C4,$C1,$BE,$BB,$B8,$B5,$B2,$AF,$AC,$A9 ;
	dc.b	$A6,$A4,$A1,$9E,$9B,$98,$96,$93,$90,$8E,$8B,$88 ; hochsprung!
	dc.b	$86,$83,$81,$7E,$7C,$79,$77,$74,$72,$70,$6D,$6B
	dc.b	$69,$66,$64,$62,$60,$5E,$5C,$5A,$58,$56,$54,$52
	dc.b	$51,$4F,$4D,$4B,$4A,$48,$47,$45,$44,$42,$41,$3F
	dc.b	$3E,$3D,$3C,$3A,$39,$38,$37,$36,$35,$34,$33,$33
	dc.b	$32,$31,$30,$30,$2F,$2F,$2E,$2E,$2D,$2D,$2D,$2C
	dc.b	$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2D,$2D,$2D
	dc.b	$2E,$2E,$2F,$2F,$30,$30,$31,$32,$33,$33,$34,$35
	dc.b	$36,$37,$38,$39,$3A,$3C,$3D,$3E,$3F,$41,$42,$44
	dc.b	$45,$47,$48,$4A,$4B,$4D,$4F,$51,$52,$54,$56,$58
	dc.b	$5A,$5C,$5E,$60,$62,$64,$66,$69,$6B,$6D,$70,$72
	dc.b	$74,$77,$79,$7C,$7E,$81,$83,$86,$88,$8B,$8E,$90
	dc.b	$93,$96,$98,$9B,$9E,$A1,$A4,$A6,$A9,$AC,$AF,$B2
	dc.b	$B5,$B8,$BB,$BE,$C1,$C4,$C7,$CA,$CD,$D0,$D3,$D6
	dc.b	$D9,$DC,$DF,$E2,$E5,$E8,$EB,$EE


--	--	--	--	--	--	--	--	--	--


;									___  ($f0) $d8
; DEST> taby	                   /   \ ($f0-$2c) $d0-$40 ($90)
; BEG> 0					  \___/		 ($2c) $48
; END> 360
; AMOUNT> 200
; AMPLITUDE> ($f0-$2c)/2 ;
; YOFFSET> $8e	  ; wäre ein $f0-(($f0-$2c)/2)
; SIZE (B/W/L)> b
; MULTIPLIER> 1

	dc.b	$8E,$91,$94,$97,$9A,$9D,$A0,$A3,$A6,$A9,$AC,$AF
	dc.b	$B2,$B4,$B7,$BA,$BD,$BF,$C2,$C5,$C7,$CA,$CC,$CE
	dc.b	$D1,$D3,$D5,$D7,$D9,$DB,$DD,$DF,$E0,$E2,$E3,$E5
	dc.b	$E6,$E7,$E9,$EA,$EB,$EC,$EC,$ED,$EE,$EE,$EF,$EF
	dc.b	$EF,$EF,$F0,$EF,$EF,$EF,$EF,$EE,$EE,$ED,$EC,$EC
	dc.b	$EB,$EA,$E9,$E7,$E6,$E5,$E3,$E2,$E0,$DF,$DD,$DB
	dc.b	$D9,$D7,$D5,$D3,$D1,$CE,$CC,$CA,$C7,$C5,$C2,$BF
	dc.b	$BD,$BA,$B7,$B4,$B2,$AF,$AC,$A9,$A6,$A3,$A0,$9D
	dc.b	$9A,$97,$94,$91,$8E,$8B,$88,$85,$82,$7F,$7C,$79
	dc.b	$76,$73,$70,$6D,$6A,$68,$65,$62,$5F,$5D,$5A,$57
	dc.b	$55,$52,$50,$4E,$4B,$49,$47,$45,$43,$41,$3F,$3D
	dc.b	$3C,$3A,$39,$37,$36,$35,$33,$32,$31,$30,$30,$2F
	dc.b	$2E,$2E,$2D,$2D,$2D,$2D,$2C,$2D,$2D,$2D,$2D,$2E
	dc.b	$2E,$2F,$30,$30,$31,$32,$33,$35,$36,$37,$39,$3A
	dc.b	$3C,$3D,$3F,$41,$43,$45,$47,$49,$4B,$4E,$50,$52
	dc.b	$55,$57,$5A,$5D,$5F,$62,$65,$68,$6A,$6D,$70,$73
	dc.b	$76,$79,$7C,$7F,$82,$85,$88,$8B,$8d

--	--	--	--	--	--	--	--	--	--

Da die Tabellen alle schon bereit sind, eingesetzt zu werden, versucht sie
denen aus den Listings zu  ersetzen,  um  viele  verschiedene  Effekte  zu
erzeugen.  Probiert  auch,  selbst eigene, andere zu machen, mit mehr 100,
120, 300 Werten statt 200. Damit könnt ihr unendlich viele Schußlinien für
den Sprite berechnen.

