
; Listing3c2.s	; BALKEN, DER SINKT, ERSTELLT MIT EINEM MOVE & WAIT DES COPPER
				; (UM IHN ZUM SINKEN ZU BRINGEN RECHTE MAUSTASTE)

				; Es wurde eine Kontrolle hinzugefügt, um ab einer
				; bestimmten Zeile des Scroll anzuhalten
		
	SECTION ZWEITECOP,CODE	; auch Fast ist	OK

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
	move.w	d0,$dff088	    ; COPJMP1 - Starten unsere COP
mouse:	
	cmpi.b	#$ff,$dff006	; VHPOSR - sind wir bei Zeile 255 angekommen?
	bne.s	mouse			; Wenn nicht, geh nicht weiter
							; oder wenn 255 erreicht gehe weiter
		

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
							; (Libraries werden geöffnet UND geschlossen!)
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
;	usw. bis der Maximalwert erreicht ist, in unserem Falle $fc


BewegeCopper:
	cmpi.b	#$fc,BALKEN		; sind wir bei Zeile $fc angekommen?
	beq.s	Beendet			; wenn ja, dann sind wir unten und stoppen
	addq.b	#1,BALKEN		; WAIT 1 verändert, Balken sinkt un eine Zeile
Beendet:
	rts

;	Wenn BALKEN $fc erreicht hat, dann wird das addq übersprungen.


;	P.S: Zur Zeit können wir den letzten Teil des Bildschirmes noch
;	nicht erreichen (nach $FF), ich erkläre euch später warum und
;	wie es geht.


;	DATEN...


GfxName:
	dc.b	"graphics.library",0,0	; Bemerkung: um Charakter in den
							; Speicher zu geben, verwenden wir
							; immer das dc.b und setzen sie
							; unter "" oder '', Abschluß mit ,0


GfxBase:	    ; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0   ; ab hier werden die Offsets gemacht



OldCop:		   ; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0  ; Betriebssystemes


	SECTION MeinCopper,DATA_C ; Dieser Befehl veranlaßt das Betriebssystem,
				; das folgende Datensegment in die CHIP-RAM
				; zu laden, obligatorisch.
				; Die Copperlist MÜSSEN in die CHIP RAM!

COPPERLIST:
	dc.w	$100,$200	; BPLCON0 - keine Bitplanes, nur Hintergrund
	dc.w	$180,$004	; COLOR0 - Beginne die COP mit DUNKELBLAU

BALKEN:
	dc.w	$2C07,$FFFE	; WAIT - Warte auf Zeile $79
	dc.w	$180,$600	; COLOR0 - Hier beginnt die rote Zone : ROT auf 6

	dc.w	$FFFF,$FFFE	; ENDE DER COPPERLIST

	end

Als Änderungen könntet ihr versuchen, das $fc in der Zeile

	cmpi.b	#$fc,BALKEN

durch andere Werte zu ersetzen, und ihr werdet bemerken, wie der Balken nur
bis zum gegebenen Wert sinkt.

