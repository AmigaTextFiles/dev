
; Listing3c3.s	; BALKEN, DER SINKT, ERSTELLT MIT EINEM MOVE&WAIT DES COPPER
				; (UM IHN ZUM SINKEN ZU BRINGEN RECHTE MAUSTASTE)
				
	SECTION VerlaufCOP,CODE	; auch Fast ist	OK

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
	move.l	#COPPERLIST,$dff080  ; COP1LC - "Zeiger" auf unsere COP
							; (deren Adresse)
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
mouse:	
	cmpi.b	#$ff,$dff006	; VHPOSR - sind wir bei Zeile 255 angekommen?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

	btst	#2,$dff016		; POTINP - Rechte Maustaste gedrückt?
	bne.s	Warte			; Wenn nicht, führe BEWEGECOPPER nicht aus

	bsr.s	BewegeCopper	; Diese Subroutine läßt das WAIT sinken!
							; Sie wird einmal pro Frame ausgeführt.

Warte:
	cmpi.b	#$ff,$dff006	; VHPOSR:
							; Sind wir noch auf $FF? Wenn ja, warte auf die
	beq.s	Warte			; nächste Zeile (00). Ansonsten wird BewegeCopper


	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088		; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable - stellt Multitasking wieder her
	move.l	GfxBase(PC),a1	; Basis der Library, die es zu schließen gilt
							; (Libraries werden geöffnet UND geschlossen!!)
	jsr	-$19e(a6)			; Closelibrary - schließt die Graphics lib
	rts	

;	Mit dieser Routine bewege ich einen Balken aus 10 Wait nach unten

BewegeCopper:
	cmpi.b	#$fc,BALKEN		; sind wir bei Zeile $fc angekommen?
	beq.s	Beendet			; wenn ja, dann sind wir unten und stoppen
	addq.b	#1,BALKEN		; WAIT 1 verändert
	addq.b	#1,BALKEN2		; WAIT 2 verändert
	addq.b	#1,BALKEN3		; WAIT 3 verändert
	addq.b	#1,BALKEN4		; WAIT 4 verändert
	addq.b	#1,BALKEN5		; WAIT 5 verändert
	addq.b	#1,BALKEN6		; WAIT 6 verändert
	addq.b	#1,BALKEN7		; WAIT 7 verändert
	addq.b	#1,BALKEN8		; WAIT 8 verändert
	addq.b	#1,BALKEN9		; WAIT 9 verändert
	addq.b	#1,BALKEN10		; WAIT 10 verändert
Beendet:
	rts


;	DATEN...


GfxName:
	dc.b	"graphics.library",0,0	; Bemerkung: um Charakter in den
							; Speicher zu geben, verwenden wir
							; immer das dc.b und setzen sie
							; unter "" oder ´´, Abschluß mit ,0


GfxBase:	    ; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0   ; ab hier werden die Offsets gemacht
	

OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0	; Betriebssystems


	SECTION MyMagicCop,DATA_C ; Dieser Befehl veranlaßt das Betriebssystem,
				; das folgende Datensegment in die CHIP-RAM
				; zu laden, obligatorisch.
				; Die Copperlist MÜSSEN in die CHIP RAM!

COPPERLIST:
	dc.w	$100,$200		; BPLCON0 - nur Hintergrundfarbe
	dc.w	$180,$000		; COLOR0 - Beginne die Cop mit Farbe SCHWARZ

BALKEN:
	dc.w	$7907,$FFFE		; WAIT - Warte auf Zeile  $79
	dc.w	$180,$300		; COLOR0 - Beginne den roten BALKEN: Rot auf 3
BALKEN2:
	dc.w	$7a07,$FFFE		; WAIT - nächste Zeile
	dc.w	$180,$600		; COLOR0 - Rot a 6
BALKEN3:
	dc.w	$7b07,$FFFE
	dc.w	$180,$900		; Rot auf 9
BALKEN4:
	dc.w	$7c07,$FFFE
	dc.w	$180,$c00		; Rot auf 12
BALKEN5:
	dc.w	$7d07,$FFFE
	dc.w	$180,$f00		; Rot auf 15 (maximal)
BALKEN6:
	dc.w	$7e07,$FFFE
	dc.w	$180,$c00		; Rot auf 12
BALKEN7:
	dc.w	$7f07,$FFFE
	dc.w	$180,$900		; Rot auf  9
BALKEN8:
	dc.w	$8007,$FFFE
	dc.w	$180,$600		; Rot auf  6
BALKEN9:
	dc.w	$8107,$FFFE
	dc.w	$180,$300		; Rot auf  3
BALKEN10:
	dc.w	$8207,$FFFE
	dc.w	$180,$000		; Farbe SCHWARZ

	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST

	end

Um den Balken sinken zu lassen, müßen wir nur die Copperlist verändern, in
diesem  Beispiel  alle  Wait, die den Balken zusammensetzen. Geändert wird
das erste Byte, also das, das die vertikale Zeile definiert:

BALKEN:
	dc.w	$7907,$FFFE		; WAIT - Warte auf Zeile  $79
	dc.w	$180,$300		; COLOR0 - Beginne den roten BALKEN: Rot auf 3
BALKEN2:
	dc.w	$7a07,$FFFE		; WAIT - nächste Zeile
	dc.w	$180,$600		; COLOR0 - Rot a 6
	...

Wenn man nun ein Label vor dieses Byte gibt, ändert man dieses, indem  man
auf das Label selbst zugreift, hier BALKEN:

*******************************************************************************
 
Ich rate euch, viele Änderungen vorzunehmen,  auch  die  zufälligsten  und
verwegensten,   um   mit  dem  COPPER  vertraut  zu  werden:  Hier  einige
Ratschläge:

Änderung1: Probiert ; vor den ersten fünf ADDQ.b zu geben:

;	addq.b	#1,BALKEN		; WAIT 1 verändert
;	addq.b	#1,BALKEN2		; WAIT 2 verändert
;	addq.b	#1,BALKEN3		; WAIT 3 verändert
;	addq.b	#1,BALKEN4		; WAIT 4 verändert
;	addq.b	#1,BALKEN5		; WAIT 5 verändert
	addq.b	#1,BALKEN6		; WAIT 6 verändert
	addq.b	#1,BALKEN7		; WAIT 7 verändert
	....

Es wird einen "Vorhang fällt"-Effekt geben,  denn  der  Untergang  beginnt
hier bei der Mitte des Balkens, und da die letzte Farbe gilt bis sie nicht
geändert wird, in diesem Fall ist  die  letzte  Farbe  vor  dem  Wait  des
unteren  Teiles  des  Balkens  der bis zum Schluß reicht rot, schaut es so
aus, als ob der Balken sich strecken würde bis er am Ende des  Bildschirms
ankommt. (A.d.Ü: !?!?!?). Entfernt die ; und kommt zu Änderung2:

Änderung2: Für einen "ZOOM"-Effekt modifiziert folgenderweise:

	
	addq.b	#1,BALKEN
	addq.b	#2,BALKEN2
	addq.b	#3,BALKEN3
	addq.b	#4,BALKEN4
	addq.b	#5,BALKEN5
	addq.b	#6,BALKEN6
	addq.b	#7,BALKEN7
	addq.b	#8,BALKEN8
	addq.b	#8,BALKEN9
	addq.b	#8,BALKEN10

(Verwendet Amiga+b+c+i)

Habt  ihr  verstanden,  wieso  sich  der  Balken  ausdehnt?  Weil, anstatt
gleichzeitig nach unten zu  gehen,  die  verschiedenen  Wait  verschiedene
"Geschwindigkeiten"  haben.  Darum  distanzieren  sich die unteren von den
oberen.

Änderung3: Diesmal "dehnen" wir den Balken nicht nach unten,  sondern  von
der Mitte aus:

	subq.b	#5,BALKEN
	subq.b	#4,BALKEN2
	subq.b	#3,BALKEN3
	subq.b	#2,BALKEN4
	subq.b	#1,BALKEN5
	addq.b	#1,BALKEN6
	addq.b	#2,BALKEN7
	addq.b	#3,BALKEN8
	addq.b	#4,BALKEN9
	addq.b	#5,BALKEN10
	
Wir  haben  die  ersten  fünf  addq in subq abgeändert, und somit wird der
obere Teil des Balken statt zu sinken steigen. Alles wird ähnlich vor sich
gehen,  wie  beim  Zoom-Effekt, nur eine Hälfte nach oben, die andere nach
unten.


