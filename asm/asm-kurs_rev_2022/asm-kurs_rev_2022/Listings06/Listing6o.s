
; Listing6o.s	LINKS UND RECHTS-SCROLL EINES PLAYFIELDS, DAS
;				GRÖßER IST ALS DER BILDSCHIRM SELBST (HIER 640
;				PIXEL BREIT) RECHTE TASTE STOPPT DEN SCROLL

	SECTION	CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Namen der Lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase		;
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

; Achtung! Um das Bild zu "zentrieren" müssen wir 2 Bytes weiter nach "hinten"
; pointen, damit das Pic um 16 P. nach "vorne" rückt, da es wegen des DDFSTART
; nun 16 Pixel weiter hinten beginnt (um den häßlichen Fehler außerhalb der
; sichtbaren Zone zu verlegen).

;	POINTEN AUF UNSERE BITPLANES

	MOVE.L	#BITPLANE-2,d0	; in d0 kommt die Adresse der Bitplane -2,
							; also 16 Pixel, da die ersten 16 Pixel verdeckt
							; sind und wir sie "überspringen" müssen
	LEA	BPLPOINTERS,A1		; COP - Pointer
	move.w	d0,6(a1)
	swap	d0		
	move.w	d0,2(a1)	

	bsr.w	Print			; Bringt den Text auf die Bitplane!

	move.l	#COPPERLIST,$dff080	; COP1LC - unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse

	btst	#2,$dff016		; Rechte Taste gedrückt?
	beq.s	Warte			; wenn ja, scrolle nicht

	bsr.w	MEGAScroll		; Scrollen eines Bildes, das 640 Pixel breit
							; ist, innerhalb eines 320 Pixel breiten Screen

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


; Die Routine Megascroll dient nur dazu, die schon gesehene Routine "Rechts:"
; 320 Mal auszuführen, danach 320 Mal die Routine "Links:", um das Bild wieder
; in die Startposition zu bringen. Dann beginnt der Zyklus von vorne. Um
; festzuhalten,wie oft die einzelnen Routinen "Rechts:" oder "Links:"ausgeführt
; wurden, verwenden wir das Word "WieOft", zu dem wir bei jedem Frame
; 1 dazuzählen. Um ein 640 Pixel großes Bild auf einem 320 Pixel großen Screen
; herumscrollen zu lassen, muß es um 320 Pixel verschoben werden:
;
;
; Am Anfang:
;	 _______________________________
;	|		|		|
;	|   Bildschirm  |				|
;	| <-   320   -> |				|
;	|		|		|
;	| <- Bild im Speicher zu 640 -> |
;	|		|		|
;	|		|		|
;	 -------------------------------
;
; Wenn wir 320 Pixel nach rechts gescrollt sind:
;	 _______________________________
;	|		|		|
;	|		|  Bildschirm			|
;	|		| <-  320   ->			|
;	|		|		|
;	| <- Bild im Speicher zu 640 -> |
;	|		|		|
;	|		|		|
;	 -------------------------------
;
; Dann weitere 320 Pixel nach links und wir sehen wieder die ersten 320 Pixel
; des 640 breiten Bildes.
; Mit dem ersten Bit des Word RechtsLinks halten wir fest, ob wir nach links
; oder rechts gehen müssen. Um den Wert des Bit zu verändern, also von EINS
; auf NULL oder NULL auf EINS, wird der Befehl BCHG, also BIT CHANGE,
; verwendet. Wir kennen ihn schon aus einem anderen Listing.


MEGAScroll:
	addq.w	#1,WieOft		; Signalisieren einen weiteren Durchgang
	cmp.w	#320,WieOft		; Sind wir auf 320?
	bne.S	BewegNochMal	; Wenn nicht, scrolle noch weiter
	BCHG.B	#1,RechtsLinks	; Wenn wir aber auf 320 sind, wechsle Richtung
	CLR.w	WieOft			; und setze "WieOft" auf NULL
	rts

BewegNochMal:
	BTST	#1,RechtsLinks	; Müssen wir rechts oder links gehen?
	BEQ.S	GehLinks
	bsr.s	Rechts			; Scrolle ein Pixel nach rechts
	rts

GehLinks:
	bsr.s	Links			; Scrolle ein Pixel nach links
	rts

; Dieses Word zählt, wie oft wir Links bzw. Rechts gegangen sind.

WieOft:
	DC.W	0

; Wenn das Bit 1 von RechtsLinks auf NULL ist, dann scrollt die Routine
; nach links, wenn es auf EINS ist, dann nach rechts

RechtsLinks:
	DC.W	0

; Diese Routine scrollt ein Bitplane nach rechts, indem es auf das BPLCON1
; und den Bitplanepointers in der Copperlist einwirkt. MEINBPCON1 ist das 
; Byte des BPLCON1.

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
	move.w	d0,6(a1)		; kopiert das niederw. Word der Adress des Plane
	swap	d0				; vertauscht die 2 Word von d0 (z.B.: 1234 > 3412)
	move.w	d0,2(a1)		; kopiert das höherw. Word der Adresse des Plane
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

	move.w	d0,6(a1)		; kopiert das niederw. Word der Adress des Plane
	swap	d0				; vertauscht die 2 Word von d0 (z.B.: 1234 > 3412)
	move.w	d0,2(a1)		; kopiert das höherw. Word der Adresse des Plane
	rts

CON1SUBBA:
	sub.b	#$11,MEINBPCON1 ; scrolle ein Pixel nach hinten
	rts


;	Routine, die 8x8 Pixel große Buchstaben druckt
 
PRINT:
	LEA	TEXT(PC),A0			; Adresse des zu druckenden Textes in a0
	LEA	BITPLANE,A3			; Adresse des Ziel-Bitplanes in a3
	MOVEQ	#25-1,D3		; ANZAHL DER ZEILEN, DIE ZU DRUCKEN SIND -> 25
PRINTZEILE:
	MOVEQ	#80-1,D0		; ANZAHL DER SPALTEN EINER ZEILE: 80 (HIRES!)

PRINTCHAR2:			
	MOVEQ	#0,D2			; Löscht D2
	MOVE.B	(A0)+,D2		; Nächster Charakter in d2
	SUB.B	#$20,D2			; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG,
							; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
							; (Das $20 entspricht), IN $00, DAS
							; AUSRUFUNGSZEICHEN ($21) IN $01...
	MULU.W	#8,D2			; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
							; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D2,A2
	ADD.L	#FONT,A2		; FINDE DEN GEWÜNSCHTEN BUCHSTEBEN IM FONT

							; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,80(A3)	; Drucke Zeile 2  "	"
	MOVE.B	(A2)+,80*2(A3)	; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,80*3(A3)	; Drucke Zeile 4  "	"
	MOVE.B	(A2)+,80*4(A3)	; Drucke Zeile 5  "	"
	MOVE.B	(A2)+,80*5(A3)	; Drucke Zeile 6  "	"
	MOVE.B	(A2)+,80*6(A3)	; Drucke Zeile 7  "	"
	MOVE.B	(A2)+,80*7(A3)	; Drucke Zeile 8  "	"

	ADDQ.w	#1,A3			; A3+1, wir gehen um 8 Bit weiter (zum
							; nächsten Buchstaben

	DBRA	D0,PRINTCHAR2	; DRUCKEN D0 (80) ZEICHEN PRO ZEILE

	ADD.W	#80*7,A3		; "Return", neue Zeile

	DBRA	D3,PRINTZEILE	; Wir drucken D3 Zeilen
	RTS

TEXT:
             ; Anzahl Charakter pro Zeile: 40
             ;            1111111111222222222233333333334
             ;   1234567890123456789012345678901234567890
	dc.b	'   ERSTE ZEILE IN HIRES 640 PIXEL BREITE' ; 1a \ ZEILE 1
	dc.b	'!! -- -- -- --IMMER NOCH DIE ERSTE ZEILE' ; 1b /
	dc.b	'                ZWEITE ZEILE            ' ; 2  \ ZEILE 2
	dc.b	'AUCH NOCH ZWEITE ZEILE                  ' ;    /
	dc.b	'     /\  /                              ' ; 3
	dc.b	'                                        ' ;
	dc.b	'    /  \/                               ' ; 4
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 5
	dc.b	'                                        ' ;
	dc.b	'        SECHSTE ZEILE                   ' ; 6
	dc.b	'                      ENDE SECHSTE ZEILE' ;
	dc.b	'                                        ' ; 7
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 8
	dc.b	'                                        ' ;
	dc.b	'FABIO CIUCCI COMMUNICATION INTERNATIONAL' ; 9
	dc.b	' MARKETING TRUST TRADEMARK COPYRIGHTED  ' ;
	dc.b	'                                        ' ; 10
	dc.b	'                                        ' ;
	dc.b	'   1234567890 !@#$%^&*()_+|\=-[]{}      ' ; 11
	dc.b	'   DAS IST EIN TEST - 1,2,3 PROBE...    ' ;
	dc.b	'                                        ' ; 12
	dc.b	'                                        ' ;
	dc.b	'     ICH DENKE, ALSO BIN ICH... Wer sagt' ; 13
	dc.b	'e das doch noch gleich...?              ' ;
	dc.b	'                                        ' ; 14
	dc.b	'                                        ' ;
	dc.b	'  Und so geht unser Gedicht weiter:     ' ; 15
	dc.b	'                                        ' ;
	dc.b	'                  ...                   ' ; 16
	dc.b	'  "Mein Fraeulein! sein Sie munter,     ' ;
	dc.b	'                                        ' ; 17
	dc.b	'         <---                           ' ;
	dc.b	'    das ist ein altes Stueck;           ' ; 18
	dc.b	'                                        ' ;
	dc.b	'         --->                           ' ; 19
	dc.b	'    Hier vorne geht si unter            ' ;
	dc.b	'                                        ' ; 20
	dc.b	'         <---                           ' ;
	dc.b	'   Und kehrt von hinten zurueck."       ' ; 21
	dc.b	'                                        ' ;
	dc.b	'         --->                           ' ; 22
	dc.b	'    Ende. Na, wer hat s geschrieben?    ' ;
	dc.b	'                                        ' ; 23
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 24
	dc.b	'                                        ' ;
	dc.b	' C:\>_                                  ' ; 25
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 26
	dc.b	'                                        ' ;

	EVEN



	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8E,$2c81		; DiwStrt (Register mit Normalwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0030		; DdfStart (wegen Scroll modifiziert)
	dc.w	$94,$00d0		; DdfStop
	dc.w	$102			; BplCon1
	dc.b	0				; hochwertiges Byte des $dff102,nicht verwendet
MEINBPCON1:
	dc.b	0				; niederwertiges Byte des $dff102, verwendet
	dc.w	$104,0			; BplCon2
	dc.w	$108,40-2		; Bpl1Mod ( 40 für ein Bild, das 640 breit ist,
	dc.w	$10a,40-2		; Bpl2Mod   -2 um das DDFSTART auszugleichen)

			    ; 5432109876543210
	dc.w	$100,%0001001000000000  ; Bits 12 an - 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000		; erste Bitplane

	dc.w	$0180,$103		; Color0 - Hintergrund
	dc.w	$0182,$4ff		; Color1 - Schrift

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	Der FONT, Charakter 8x8

FONT:
;	incbin	"/Sources/metal.fnt"	; Breiter Zeichensatz
;	incbin	"/Sources/normal.fnt"	; Ähnlich dem aus dem Kickstart 1.3
	incbin	"/Sources/nice.fnt"	; Schmaler Zeichensatz

	SECTION MEIPLANE,BSS_C	; Die SECTION BSS können nur aus NULLEN
							; bestehen!!! Man verwendet das DS.B um zu
							; definieren, wieviele Nullen die Section
							; enthalten soll

BITPLANE:
	ds.b	80*256			; eine Bitplane, 640x256 breit (wie Hires)

	end


In diesem Listing ist die einzige Neuigkeit das Scrollen eines Bildes, das
größer	ist  als  der  Bildschirm  selbst.  Zuerst  ein  Wort  über  die
Modulo-Register:  bei  einem  Bildschirm  in  LOWRES  mit  normalen
DIWSTART/DIWSTOP-  Werten  ist  das  Modulo  40, das Bild wird also als 40
Bytes breit behandelt, jede Zeile hat 320 Pixel/40 Bytes.  Wenn  wir  aber
ein  Bild im Speicher haben, das 640 Pixel breit ist, wie es hier der Fall
ist, dann müssen wir das Modulo verändern. Denn daß das Bild  größer  ist,
kratzt  den  Copper nicht die Bohne, er wird immer ein Modulo 40 annehmen,
wenn es sich um LowRes handelt. Wir können dies  aber  mit  den  Registern
BPL1MOD	und	BPL2MOD  ändern:  das  Modulo  wird  zum  gängigen  Modulo
dazugegeben, es reicht also ein:

	dc.w	$108,40		; Bpl1Mod (40 für ein 640 Pixel breites Bild)
	dc.w	$10a,40		; Bpl2Mod

um ans Ende einer jeden 320 Pixel breiten Zeile (40 Bytes) zu springen, um
die  40  überstehenden  Bytes  zu  überspringen, und um mit der Anzeige am
Anfang der nächsten Zeile zu beginnen:


	 40 Bytes	 40 Bytes (jedesmal mit dem Modulo = 40 übersprungen)
	 _______________________________
	|		|		|
	|   Bildschirm  |				|
	| <-   320  ->  |				|
	|		|		|
	| <- Bild im Speicher zu 640 -> |
	|		|		|
	|		|		|
	 -------------------------------

Nun, wo wir den rechten Teil des Bildes zu 640 Pixel auf einem  320  Pixel
breiten  Schirm  angezeigt  haben,  indem  wir  einfach  die Modulo auf 40
gesetzt haben, müssen wir  die  gleiche  Modifizierung  vornehmen  wie  in
Listing6n.s, um den Anzeigefehler zu vermeiden. Die ersten 16 Pixel müssen
versteckt werden. Dazu lassen wir den  Screen  16  Pixel  früher  starten,
indem	wir  das  DDFSTART  verändern:  dc.w  $92,$30  ;  DDFSTART  =  $30
(Bildschirm startet
							; 16 Pixel früher, er verbreitert sich
							; also auf 42 Bytes pro Zeile, 336 Pixel
							; Breite, aber das DIWSTART "versteckt"
							; diese ersten 16 Pixel mit dem Fehler.

Da nun der Bildschirm alle 42  Bytes  eine  neue  Zeile  nimmt,  eine  Art
"RETURN", müssen wir das ausgleichen, indem wir 2 von den Modulo abziehen,
die 40 waren und nun 38 werden:

	dc.w	$108,40-2		; Bpl1Mod (40 für ein 640 breites Bild, das -2
	dc.w	$10a,40-2		; Bpl2Mod ist da, um das DDFSTART auszugleichen)

Im  Grunde  genommen  kann  man nicht sagen, daß ein Scroll von diesem Typ
"schwierig"  sei,  die  einzige  Schwierigkeit  liegt  darin,	sich	das
MODULO/DDFSTART/ANFANG  DES BITPLANE - System zu merken. Es gibt auch noch
eine andere Neuigkeit gegenüber Listing6n.s:


; Achtung! Um das Bild zu "zentrieren" müssen wir 2 Bytes weiter nach "hinten"
; pointen, damit das Pic um 16 P. nach "vorne" rückt, da es wegen des DDFSTART
; nun 16 Pixel weiter hinten beginnt (um den häßlichen Fehler außerhalb der
; sichtbaren Zone zu verlegen).


;	POINTEN AUF UNSERE BITPLANES

	MOVE.L  #BITPLANE-2,d0  ; in d0 kommt die Adresse des Bitplane -2,
							; also 16 P., da die ersten 16 Pixel verdeckt
							; sind und wir sie "überspringen" müssen

Da wir ja die ersten 16 Pixel "versteckt" haben, würden  auch  die  ersten
zwei  Buchstaben  vom  Text  verschwinden  (8  Pixel pro Buchstabe, 2*8=16
Pixel). Aber durch Verschieben des Bildes um 16 Pixel sehen wir  auch  die
ersten	16  Pixel  korrekt,  und  nicht  nach  links  verschoben  wie  in
Listing6n.s. Versucht, das -2 vom "MOVE.L #BITPLANE-2,d0" zu entfernen und
setzt einen ";" vor die Routine "

;	bsr.w	MEGAScroll

um  ein  stehendes  Bild  zu haben. Ihr werdet bemerken, daß die ersten 16
Pixel fehlen, und daß rechts zwei zuviel sind. Das  Pic  startet  eben  16
Pixel  vor  der  Norm. Um das zu überprüfen, "enthüllen" wir die ersten 16
Pixel:

	dc.w	$8e,$2c71		; DiwStrt ($81-16=$71)

Da sind sie, die "Verschollenen"!. Setzt wieder das -2 an seinen Platz und
entfernt  den  ";"  von der Routine, und ihr werdet sehen, wie der übliche
Fehler "Hinterm Vorhang" passiert.



