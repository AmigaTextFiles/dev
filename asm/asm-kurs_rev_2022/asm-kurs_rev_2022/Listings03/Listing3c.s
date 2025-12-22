
; Listing3c.s	; BALKEN, DER SINKT, ERSTELLT MIT EINEM MOVE & WAIT DES COPPER
				; (UM IHN ZUM SINKEN ZU BRINGEN RECHTE MAUSTASTE)

	SECTION	ZWEITECOP,CODE	; auch Fast ist OK

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName,a1			; Adresse des Namen der zu öffnenden Library in a1
	jsr	-$198(a6)			; OpenLibrary, Routine der EXEC, die Libraris
							; öffnet, und als Resultat in d0 die Basisadresse
							; derselben Bibliothek liefert, ab welcher
							; die Offsets (Distanzen) zu machen sind
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes (immer auf $26 nach
							; GfxBase)
	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
							; (deren Adresse)
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
mouse:	 
	cmpi.b	#$ff,$dff006	; VHPOSR - sind wir bei Zeile 255 angekommen?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

	btst	#2,$dff016		; POTINP - Rechte Maustaste gedrückt?
	bne.s	Warte			; Wenn nicht, führe BEWEGECOPPER nicht aus

	bsr.s	BewegeCopper	; Die erste Bewegung am Bildschirm!!!!
							; Diese Subroutine läßt das WAIT sinken!
							; Sie wird einmal pro Frame ausgeführt, denn
							; das bsr.s BewegeCopper führt die Routine
							; BewegeCopper aus, und wenn sie beendet ist
							; (mit einem RTS), dann kommt der 68000 hier
							; zurück und führt Routine Warte aus, und so
							; weiter.


Warte:						; Wenn wir uns noch auf Zeile $ff befinden, auf
							; die wir vorhin gewartet haben, dann geh nicht
							; weiter.
	
	cmpi.b	#$ff,$dff006	; Sind wir noch auf $FF? Wenn ja, warte auf die
	beq.s	Warte			; nächste Zeile (00). Ansonsten wird BewegeCopper
							; wieder ausgeführt. Dieses Problem besteht nur
							; bei sehr kurzen und folglich schnellen Routinen,
							; die in weniger als einem "Pinselstrich" (Rasterline)
							; ausgeführt werden können: Der mouse-Zyklus wartet
							; auf Zeile $FF, danach wird BewegeCopper ausgeführt,
							; aber wenn es zu schnell geht, dann befinden wir uns
							; noch auf Zeile $FF und wenn wir zur Maus zurückkehren
							; sind wir ja auf $ff, und alles wird nochmals
							; durchlaufen, und das öfter als einmal pro Frame!
							; Also würde die Routine öfters als einmal pro
							; FRAME aufgerufen! Vor allem auf A4000ern"
							; Diese Kontrolle fängt dieses Problem ab, indem
							; es auf die nächste Zeile wartet, bevor es zu
							; mouse: zurückkehrt. Um die Zeile $FF abzuwarten ist
							; die klassische 50stel Sekunde erforderlich.
							; Bemerkung: Alle Monitor und Fernseher erstellen
							; das Bild gleich schnell, während ein Computer sich
							; von einem anderen durch Prozessorgeschwindigkeit
							; u.ä. unterscheidet. Das ist der Grund, warum Progr.,
							; die mit dem $dff006 getimet sind, auf einem
							; A500 gleich schnell laufen wie auf einem A4000.
							; Das Timing wird später noch genauer behandelt,
							; im Moment versuchen wir, den Copper zu verstehen.



	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080  ; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088	    ; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable - stellt Multitasking wieder her
	move.l	GfxBase(PC),a1	; Basis der Library, die es zu schließen gilt
							; (Libraries werden geöffnet UND geschlossen!!)
	jsr	-$19e(a6)			; Closelibrary - schließt die Graphics lib
	rts	

;
;	Diese kleine Routine bringt das Wait des Copper zum sinken, indem es
;	erhöht wird, bei der ersten Ausführung wird das
;
;	dc.w	$2007,$FFFE	; Warte auf Zeile $20
;
;	so verändert werden:
;
;	dc.w	$2107,$FFFE	; Warte auf Zeile $21! (Dannn $22,$23 ecc.)
;
;	Bemerkung: Hat man einmal den Maximalwert eines Bytes erreicht, also
;		  $FF, dann wird bei einem weiterem ADDQ.B #1,BALKEN alles
;		  wieder bei 0 starten, bis es $FF erreicht usw.

BewegeCopper:
	addq.b	#1,BALKEN		; WAIT 1 verändert, Balken sinkt um eine Zeile
	rts

; Probiert das ADDQ durch ein SUBQ zu ersetzen, und der Balken wir steigen!!!!

; Probiert,das addq/subq #1,BALKEN durch #2 , #3 oder mehr zu ersetzen,
; ihr werdet somit die Geschwingigkeit verändern, der Balken wird um 2 bzw.
; 3 oder mehr Zeilen pro Frame rauf oder runtergehen.
; (Für Zahlen größer als 8 muß statt einem ADDQ.B ein ADD.B verwendet werden)


;	DATEN...


GfxName:
	dc.b	"graphics.library",0,0	; Bemerkung: um Charakter in den
							; Speicher zu geben, verwenden wir
							; immer das dc.b und setzen sie
							; unter "" oder ´´, Abschluß mit ,0


GfxBase:					; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0				; ab hier werden die Offsets gemacht
	

OldCop:						; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0				; Betriebssystemes


	SECTION GRAPHIC,DATA_C	; Dieser Befehl veranlaßt das Betriebssystem,
							; das folgende Datensegment in die CHIP-RAM
							; zu laden, obligatorisch.
							; Die Copperlist MÜSSEN in die CHIP RAM!

COPPERLIST:
	dc.w	$100,$200		; BPLCON0 - keine Bitplanes, nur Hintergrund
	dc.w	$180,$004		; COLOR0 - Beginne die COP mit DUNKELBLAU

BALKEN:
	dc.w	$7907,$FFFE		; WAIT - Warte auf Zeile $79
	dc.w	$180,$600		; COLOR0 - Hier beginnt die rote Zone:
							; ROT auf 6
	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST

	end

Ahh! Ich habe das (PC) beim "lea GfxName,a1"  vergessen,  aber  nun  ist´s
dran. Wem aufgefallen ist, daß es gesetzt werden konnte, der bekommt einen
Pluspunkt.  In  diesem  Programm  wird  eine  mit   dem   Elektronenstrahl
synchronisierte  Bewegung  erzeugt,  und  siehe da, der Balken bewegt sich
flüßig nach unten.

Bemerkung1: In diesem Listing kann  einen  die  Struktur  des  Zyklus  des
Maustests,	kombiniert   mit   dem   Test   der   Position   des   Beams
(Elektronenstrahls) ein wenig verwirren. Das, was ihr verstehen müßt, ist,
daß die Routinen, oder Subroutinen, die zwischen Mouse: und Warte: stehen,
ein  mal  Pro  BildschirmFrame  ausgeführt  werden.  Probiert  das   bsr.s
BewegeCopper   durch  die  Routine  selbst  zu  ersetzen,  ohne  dem  RTS,
klarerweise:

mouse:	 
	cmpi.b	#$ff,$dff006	; VHPOSR - sind wir bei Zeile 255 angekommen?
	bne.s	mouse			; Wenn nicht, geh nicht weiter


;	bsr.s	BewegeCopper	; Diese Routine wird einmal pro Fotogramm
;							; ausgeführt (damit´s flüßig wirkt).

	addq.b	#1,BALKEN

Warte:						; Wenn wir uns noch auf Zeile $ff befinden, auf
							; die wir vorhin gewartet haben, dann geh nicht
							; weiter.

	cmpi.b	#$ff,$dff006	; Sind wir noch auf $FF? Wenn ja, warte auf die
	beq.s	Warte

In diesem Fall ändert sich nichts am Resultat, denn  statt  das  addq  als
Subroutine  auszuführen, wird es direkt geschrieben, und vielleicht ist es
in dieser Situation  auch  bequemer;  aber  wenn  die  Subroutinen  länger
werden,  dann  rentiert  sich ein BSR auf jeden Fall, wenn man nicht total
die Übersicht  verlieren  will.  Wenn  ihr  z.B.  das  bsr.s  BewegeCopper
verdoppelt,  dann  wird die Routine zwei Mal pro Frame aufgerufen, und die
Geschwindigkeit verdoppelt sich:

	bsr.s	BewegeCopper	; Routine, die einmal pro Frame ausgeführt wird
	bsr.s	BewegeCopper	; Routine, die einmal pro Frame ausgeführt wird

Der Nutzen der Subroutinen liegt  genau  darin,  das  Programm  klarer  zu
gestalten,  stellt  euch vor, die Routinen, die zwischen Mouse: und Warte:
liegen, seien tausende von Zeilen lang! Man würde  wohl  den  Zusammenhang
verlieren.  Wenn  wir aber jede Routine mit Namen aufrufen, dann gestaltet
sich alles viel leichter.

*

Um den Balken sinken  zu  lassen,  brauchen  wir  nur  die  Copperlist  zu
verändern,  in diesem spezifischen Beispiel wird das WAIT in seinem ersten
Byte verändert, also dem,  das  die  vertikale  Linie  definiert,  die  es
abzuwarten gilt:

BALKEN:

	dc.w	$7907,$FFFE		; WAIT - Warte auf Zeile $79

	dc.w	$180,$600		; COLOR0 - Hier beginnt die rote Zone : ROT auf 6

Durch setzen eines  Label  vor  diesem  Byte  kann  auf  das  Byte  selbst
zugegriffen werden, wenn man auf dem Label agiert, in diesem Fall BALKEN.

Änderungen:  Versucht  die Farbe zu ändern, anstatt das Wait: ihr müßt nur
ein Label in in der Copperlist setzen, wo ihr wollt, und ihr könnt ändern,
was euch gefällt. Gebt BALKEN zur Farbe, wie hier gezeigt:


COPPERLIST:
	dc.w	$100,$200		; BPLCON0 - keine Bitplanes, nur Hintergrund
	dc.w	$180,$004		; COLOR0 - Beginne die COP mit DUNKELBLAU

;;;;BALKEN:
	dc.w	$7907,$FFFE		; WAIT - Warte auf Zeile $79
	dc.w	$180			; COLOR0
BALKEN:						; *** NEUE LABEL BEIM WERT DER FARBE
	dc.w	$600			; Beginn der roten Zone : Rot auf 6
	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST
		
Wir werden eine Änderung der  Intensität  des  Rotes  erhalten,  denn  wir
ändern des ersten Bytes links der Farbe: $0RGB, also $0R, also ROT!!!

Probiert nun, auf das ganze Word der Farbe zuzugreifen: ändert die Routine
so:

	addq.w  #1,BALKEN		; statt .B setzen wir .W
	rts

Testet es, und ihr werdet bemerken, daß  die  Farben  sich  unregelmäßigen
folgen,  denn  es wird die ganze Zahl verändert: $601, $602...$631, $632..
Dadurch werden nicht geordnete Farben generiert.

Bemerkung: Der Befehl  dc.b  gibt  Bytes,  Words  oder  Longwords  in  den
Speicher, deswegen erhält man das gleiche Resultat durch:

	dc.w	$180,$600		; COLOR0

	oder:

	dc.w	$180			; Register COLOR0
	dc.w	$600			; Wert von COLOR0
	
Es gibt keine Schwierigkeiten mit der Syntax wie bei einem Move.


