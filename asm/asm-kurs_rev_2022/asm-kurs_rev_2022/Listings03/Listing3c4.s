
; Listing3c4.s	; BALKEN, DER SINKT, ERSTELLT MIT EINEM MOVE&WAIT DES COPPER
		; (UM IHN ZUM SINKEN ZU BRINGEN RECHT MAUSTASTE)

;	In diesem Listing wird ein schattierter Balken aus 10 Wait sinken.
;	Die Differenz zu Listing3c3.s liegt darin, daß hier nur ein
;	Label verwendet wird, und dann mit Offsets gearbeitet wird.

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
	LEA	BALKEN,a0			; in a0 kommt die Adresse von Balken
	cmpi.b	#$fc,8*9(a0)	; kontrolliere das letzt Wait, das den
	beq.s	Beendet			; untersten Teil des Balken definiert

	addq.b	#1,(a0)			; WAIT 1 geändert (indirekt, ohne Distanz)
	addq.b	#1,8(a0)		; nun ändern wir die anderen Wait: das Offset
	addq.b	#1,8*2(a0)		; zwischen einem Wait und dem anderen beträgt
	addq.b	#1,8*3(a0)		; 8 Byte, denn dc.w $xx07,$FFFE,$180,$xxxx
	addq.b	#1,8*4(a0)		; ist ein Long, und wenn wir also ab der Adrsse
	addq.b	#1,8*5(a0)		; des ersten Wait ein Offset von 8 Byte machen,
	addq.b	#1,8*6(a0)		; dann ändern wir das folgende dc.w $xx07,$FFFE.
	addq.b	#1,8*7(a0)		; Hier müßen wir alle 9 Wait des Balkens ändern
	addq.b	#1,8*8(a0)		; um ihn zum Sinken zu bringen!
	addq.b	#1,8*9(a0)		; letztes Wait! (das BALKEN10 des vorigen Listings)

Beendet:
	rts						; P.S: Mit diesem RTS kehren wir zum Mouse-Zyklus zurück,
							; der das Timing übernimmt

;	Bemerkung: * steht für "multipliziere", / für "dividiere"



;	DATEN...


GfxName:
	dc.b	"graphics.library",0,0	; Bemerkung: um Charakter in den
							; Speicher zu geben, verwenden wir
							; immer das dc.b und setzen sie
							; unter "" oder ´´, Abschluß mit ,0


GfxBase:	    ; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0   ; ab hier werden die Offsets gemacht



OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0	; Betriebssystemes


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
	dc.w	$7a07,$FFFE		; WAIT - nächste Zeile
	dc.w	$180,$600		; COLOR0 - Rot a 6
	dc.w	$7b07,$FFFE
	dc.w	$180,$900		; Rot auf 9
	dc.w	$7c07,$FFFE
	dc.w	$180,$c00		; Rot auf 12
	dc.w	$7d07,$FFFE
	dc.w	$180,$f00		; Rot auf 15 (maximal)
	dc.w	$7e07,$FFFE
	dc.w	$180,$c00		; Rot auf 12
	dc.w	$7f07,$FFFE
	dc.w	$180,$900		; Rot auf  9
	dc.w	$8007,$FFFE
	dc.w	$180,$600		; Rot auf  6
	dc.w	$8107,$FFFE
	dc.w	$180,$300		; Rot auf  3
	dc.w	$8207,$FFFE
	dc.w	$180,$000		; Farbe SCHWARZ

	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST

	end

Um den Balken sinken zu lassen, müßen wir nur die Copperlist verändern, in
diesem Beispiel alle Wait, die den Balken  zusammensetzen.  Geändert  wird
das erste Byte, also das, das die vertikale Zeile definiert:

BALKEN:
	dc.w	$7907,$FFFE		; WAIT - Warte auf Zeile  $79
	dc.w	$180,$300		; COLOR0 - Beginne den roten BALKEN: Rot auf 3
	dc.w	$7a07,$FFFE		; WAIT - nächste Zeile
	dc.w	$180,$600		; COLOR0 - Rot auf 6
	...

Wenn man nun ein Label vor dieses Byte gibt, ändert man dieses, indem  man
auf  das Label selbst zugreift, hier BALKEN. Aber unser Balken besteht aus
9 wait+color0, deswegen müßen wir alle 9 verändern, wenn wir  ihn  bewegen
wollen.  Verändert  werden  natürlich  nur  die  Wait,  die  Color0  (dc.w
$180,$xxx) bleiben unverändert. Um alle 9 Wait zu erreichen, ohne  überall
Labels  zu  setzen,  verwenden  wir Offsets. Das geht auch schneller. Dazu
geben wir in ein Register (a0) die Adresse des  ersten  Wait,  und  ändern
alle anderen durch Adressierungsdistanzen (Offset):

	LEA	BALKEN,a0

	cmp.i	#$fc,8*9(a0)	; kontrolliere das letzt Wait, das den
	beq.s	Beendet			; untersten Teil des Balken definiert

	addq.b	#1,(a0)			; ändere BALKEN:
	addq.b	#1,8(a0)		; ändere das Byte, das 2 Long nach BALKEN: ist
	addq.b	#1,8*2(a0)		; ändere das Byte, das 4 Long nach BALKEN: ist
	addq.b	#1,8*3(a0)		; ändere das Byte, das 6 Long nach BALKEN: ist
	addq.b	#1,8*4(a0)
	addq.b	#1,8*5(a0)
	addq.b	#1,8*6(a0)
	addq.b	#1,8*7(a0)
	addq.b	#1,8*8(a0)
	addq.b	#1,8*9(a0)
Beendet:
	rts	; P.S: Mit diesem RTS kehren wir zum Mouse-Zyklus zurück,
	
Bemerkung: Probiert ein "D BewegeCopper", und verifiziert daß die 8*2,
8*3... als

	ADDQ.B	#1,$8(A0)
	ADDQ.B	#1,$10(A0)
	ADDQ.B	#1,$18(A0)
	ADDQ.B	#1,$20(A0)
	ADDQ.B	#1,$28(A0)

assembliert werden, also mit dem Resultat aus 8*2 (=10 -> $10), 8*3 ($18)...

Als letzte Änderung, probiert das $fc in der Zeile

	cmpi.b	#$fc,8*9(a0)

durch einen kleineren Wert zu ersetzen, und kontrolliert,  ob  der  Balken
auch wirklich nur bis zur angegebenen Zeile sinkt.

