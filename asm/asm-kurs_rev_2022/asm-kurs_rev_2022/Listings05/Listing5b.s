
; Listing5b.s	SCROLLEN EINES BILDES NACH LINKS UND RECHTS MIT DEM $dff102

	SECTION	CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName(PC),a1		; Adresse des Namen der zu öffnenden Lib in a1
	jsr	-$198(a6)			; OpenLibrary, Routine der EXEC, die Libraris
							; öffnet, und als Resultat in d0 die Basisadr.
							; derselben Bibliothek liefert, ab welcher
							; die Offsets (Distanzen) zu machen sind
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes (immer auf $26 nach
							; GfxBase)

;	POINTEN AUF UNSERE BITPLANES

	MOVE.L	#PIC,d0			; in d0 kommt die Adresse von unserer PIC
							; bzw. wo ihre erste Bitplane beginnt

	LEA	BPLPOINTERS,A1		; in a1 kommt die Adresse der Bitplane-
							; Pointer der Copperlist
	MOVEQ	#2,D1			;	 Anzahl der Bitplanes -1 (hier sind es 3)
							; für den DBRA - Zyklus
POINTBP:
	move.w	d0,6(a1)		; kopiert das niederwertige Word der Plane-
							; Adresse ins richtige Word der Copperlist
	swap	d0				; vertauscht die 2 Word in d0 ( 1234 > 3412)

	move.w	d0,2(a1)		; kopiert das hochwertige Word der Adresse des 
							; Plane in das richtige Word in der Copperlist
	swap	d0				; vertauscht erneut die 2 Word von d0
	ADD.L	#40*256,d0		; Zählen 10240 zu D0 dazu, somit zeigen wir
							; auf das zweite Bitplane (befindet sich direkt
							; nach dem ersten), wir zählen praktisch Länge
							; eines Plane dazu

	addq.w	#8,a1			; a1 enthält nun die Adresse der nächsten
							; Bplpointers in der	Copperlist, die es
							; einzutragen gilt
	dbra	d1,POINTBP		; Wiederhole D1 mal POINTBP (D1= bitplanes)


	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh nicht weiter


	bsr.s	BewegeCopper	; Scrollt Bild hin und her. Hier: COMMODORE


	btst	#2,$dff016		; wenn die rechte Maustaste gedrückt ist,
	beq.s	Warte			; überspringe die Scrollroutine

	bsr.w	BewegeCopper2	; Bewegt das Bild maximal 16 Pixel links
							; oder rechts, unter Verwendung des $dff102
							; hier: der Schriftzug AMIGA

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

OldCop:		 	; Hier hinein kommt die Adresse der Orginal-Copperlist
	dc.l	0	; des Betriebssystemes


;	Diese Routine verschiebt das Wort "COMMODORE" und wirkt auf MEINCON1


BewegeCopper:
	TST.B	FLAG			; Müßen wir vor oder zurück? Wenn FLAG NULL
							; ist (TST also BEQ ergibt), dann springen wir
							; nach Vorne, wenn es hingegen auf $FF ist,
							; (TST also nicht BEQ ergibt), dann fahren wir
							; mit dem zurückgehen fort (mit den sub)
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

;************************************************************************

;	Diese Routine bewegt die Schrift "AMIGA", agiert auf MAINCON1


BewegeCopper2:
	TST.B	FLAG2			; Müßen wir vor oder zurück? Wenn FLAG NULL
							; ist (TST also BEQ ergibt), dann springen wir
							; nach Vorne, wenn es hingegen auf $FF ist,
							; (TST also nicht BEQ ergibt), dann fahren wir
							; mit dem zurückgehen fort (mit den sub)
	beq.w	Vorne2
	cmpi.b	#$00,MainCon1	; sind wir auf der Standartposition angekommen,
							; also ganz hinten?
	beq.s	GehNachVorne2	; wenn ja, dann müßen wir nach vorne!
	sub.b	#$11,MainCon1	; wir ziehen 1 vom Scroll der geraden/ungeraden
	rts						; Bitplanes ab ($ff,$ee,$dd,$cc,$bb,$aa,$99..)
							; gehen somit nach LINKS
GehNachVorne2:
	clr.b	FLAG2			; Durch Nullsetzen des FLAG wird bei TST.B FLAG
	rts						; das BEQ die Routine nach Vorne springen lassen,
							; und das Bild wird vorschreiten (nach rechts)

Vorne2:
	cmpi.b	#$ff,MainCon1	; Sind wir beim Maximalscroll nach vorne ($ff)
							; angekommen?? ($f gerade und $f ungerade)
	beq.s	GehNachHinten2	; wenn ja müßen wir zurückgehen
	add.b	#$11,MainCon1	; zähle 1 zum Bitplanescroll dazu, gerade und
							; ungerade ($11,$22,$33,$44 etc..)
	rts						; GEH NACH RECHTS

GehNachHinten2:
	move.b	#$ff,FLAG2		; Wenn das Label FLAG nicht auf NULL ist,
	rts						; dann bedeutet das, daß wir nach links
							; zurückgehen müßen

;	Dieses Byte ist ein FLAG, es zeigt uns an, ob wir vor oder
;	zurück gehen müßen.

FLAG2:
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


	dc.w	$102			; BplCon1 - DAS REGISTER
	dc.b	$00				; BplCon1 - DAS NICHT VERWENDETE BYTE!!!
MeinCon1:
	dc.b	$00				; BplCon1 - DAS VERWENDETE BYTE!!!


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

	dc.w	$7007,$fffe		; Warten auf das Ende der "COMMODORE"-Schrift

	dc.w	$102			; BplCon1 - DAS REGISTER
	dc.b	$00				; BplCon1 - DAS NICHT VERWENDETE BYTE!!!
MainCon1:
	dc.b	$ff				; BplCon1 - DAS VERWENDETE BYTE!!!

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	BILD

PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format

	end

Dieses  Beispiel  haben  wir  erhalten, indem wir die Routine BewegeCopper
kopiert haben und die Namen vertauscht haben, oder vielmehr, ihnen einfach
einen  2er  hinten drangehängt haben. Oft wird diese Methode verwendet, um
Programmstücke nicht neuschreiben zu müßen. Einfach den Trick  Amiga+b+c+i
verwenden  und  los  geht´s.  Was  die Copperlist angeht, habe ich nur ein
weiteres $dff102 hinzugefügt, dessen Name MainCon1  ist,  alles  nach  dem
Wait $7007, also unter dem Commodore-Schriftzug. Es wird also nur das Bild
unterhalb dieser Zeile verändert, also dem "AMIGA". Um  die  zwei  Hälften
"phasenverschoben"  hin- und herlaufen zu lassen, braucht man nur den Loop
statt mit $00 mit $FF, also 15, starten zu lassen,  und  BewegeCopper  und
BewegeCopper2 laufen in die gegengesetzte Richtung.

	dc.w	$102		; BplCon1 - DAS REGISTER
	dc.b	$00			; BplCon1 - DAS NICHT VERWENDETE BYTE!!!
MeinCon1:
	dc.b	$00			; BplCon1 - DAS VERWENDETE BYTE!!!
	
	...

	dc.w	$102		; BplCon1 - DAS REGISTER
	dc.b	$00			; BplCon1 - DAS NICHT VERWENDETE BYTE!!!
MainCon1:
	dc.b	$ff			; BplCon1 - DAS VERWENDETE BYTE!!!

Tauscht das Byte MainCon1: aus, setzt statt $ff $55 odes was anderes  ein,
dann wird alles vielleicht ein bißchen mehr einleuchten.

Mit  der rechten Maustaste blockiert man nur das zweite $102. Probiert das
Wait zu ändern, um andere Scrollmuster zu erzeugen, z.B.:


	dc.w	$a007,$fffe
 
Teilt die "AMIGA"-Schrift in zwei Teile.


