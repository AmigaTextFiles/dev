
; Listing3f.s	; BALKEN, DER RAUF-UND RUNTERGEHT, ERSTELLT MIT MOVE & WAIT
				; DER COPPERS, UNTER DER $FF-ZEILE

; Dieses Listing ist identisch mit dem Listing3d.s, mit der
; einzigen Ausnahme, daß der Balken sich unterhalb der $FF-Grenze
; befindet, die wir noch nie überschritten haben.

	SECTION CIPundCOP,CODE	; auch Fast ist	OK

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

; Die Routine BewegeCopper ist die gleiche geblieben, nur die Werte der
; maximalen bzw. minimalen Höhe haben sich geändert: $0a für das obere
; Limit des Bildschirms und $2c für unten..


BewegeCopper:
	LEA	BALKEN,a0			; in a0 kommt die Adresse von Balken
	TST.B	RAUFRUNTER		; Müßen wir steigen oder sinken? Wenn RaufRunter
						    ; auf 0 steht (wenn TST also BEQ liefert), dann
							; springen wir auf GEHRUNTER, wenn es hingegen
							; auf $FF ist (TST also nicht eintrifft), fahren
	beq.w	GEHRUNTER		; wir fort und führen somit den "steigenden" Teil
							; aus
	
	cmpi.b	#$0a,(a0)		; sind wir bei Zeile $0a+$ff angekommen?
	beq.s	SetzRunter		; wenn ja, sind wir oben angekommen und
	subq.b	#1,(a0)			; müßen runter
	subq.b	#1,8(a0)
	subq.b	#1,8*2(a0)		; nun ändern wir die anderen Wait: der
	subq.b	#1,8*3(a0)		; Abstand zwischen einem und dem anderen beträgt
	subq.b	#1,8*4(a0)		; 8 Byte
	subq.b	#1,8*5(a0)
	subq.b	#1,8*6(a0)
	subq.b	#1,8*7(a0)		; hier müßen wir alle 9 Wait des roten Balken
	subq.b	#1,8*8(a0)		; ändern, wenn wir ihn steigen und sinken lassen
	subq.b	#1,8*9(a0)		; wollen.
	rts


SetzRunter:
	clr.b	RAUFRUNTER		; Setzt RAUFRUNTER auf 0, beim TST.B RAUFRUNTER
	rts						; wird das BEQ zu Routine GEHRUNTER verzweigen,
							; und der Balken wird sinken

GEHRUNTER:
	cmpi.b	#$2c,8*9(a0)	; sind wir bei Zeile $2c angekommen?
	beq.s	SetzRauf		; wenn ja, sind wir untern und müßen wieder
	addq.b	#1,(a0)			; steigen
	addq.b	#1,8(a0)
	addq.b	#1,8*2(a0)		; nun ändern wir die anderen Wait: der
	addq.b	#1,8*3(a0)		; Abstand zwischen einem und dem anderen beträgt
	addq.b	#1,8*4(a0)		; 8 Byte
	addq.b	#1,8*5(a0)
	addq.b	#1,8*6(a0)
	addq.b	#1,8*7(a0)		; hier müßen wir alle 9 Wait des roten Balken
	addq.b	#1,8*8(a0)		; ändern, wenn wir ihn steigen und sinken lassen
	addq.b	#1,8*9(a0)		; wollen.
	rts

SetzRauf:
	move.b	#$ff,RAUFRUNTER ; Wenn das Label nicht auf NULL ist,
	rts						; bedeutet es, daß wir steigen müßen
		

;   Dieses Byte, das von dem Label RAUFRUNTER markiert ist, ist ein FLAG,
;   also eine "Fahne" (man kann es sich so vorstellen), einmal ist sie
;   auf $FF, ein anderes Mal auf $00, je nachdem ob wir steigen oder sinken
;   müßen! Es ist wie eine Flagge, denn wenn sie unten ist ($00) bedeutet
;   es, daß wir runter müßen, wenn sie gehißt ist ($FF), dann müßen wir
;   rauf. Es wird eine Kontrolle gemacht, auf welcher Zeile wir uns
;   befinden, und verglichen, ob wir oben oder unter angelangt sind. Ist
;   das der Fall, dann sagt uns das Flag, welche Richtung wir danach
;   einschlagen müßen, und dann ändern wir ihren Zustand mit clr.b RAUFRUNTER
;   oder move.b #$ff,RAUFRUNTER.

;	DATEN...

RAUFRUNTER:
	dc.b	0,0

GfxName:
	dc.b	"graphics.library",0,0	; Bemerkung: um Charakter in den
							; Speicher zu geben, verwenden wir
							; immer das dc.b und setzen sie
							; unter "" oder ´´, Abschluß mit ,0


GfxBase:	    ; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0   ; ab hier werden die Offsets gemacht



OldCop:		    ; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0   ; Betriebssystemes


	SECTION GRAPHIC,DATA_C	; Dieser Befehl veranlaßt das Betriebssystem,
							; das folgende Datensegment in die CHIP-RAM
							; zu laden, obligatorisch.
							; Die Cpperlist MÜSSEN in die CHIP RAM!
	
COPPERLIST:
	dc.w	$100,$200		; BPLCON0
	dc.w	$180,$000		; COLOR0 - Beginne Cop mit SCHWARZ

	dc.w	$2c07,$FFFE		; WAIT - Ein kleiner fixer Balken in grün
	dc.w	$180,$010		; COLOR0
	dc.w	$2d07,$FFFE		; WAIT
	dc.w	$180,$020		; COLOR0
	dc.w	$2e07,$FFFE
	dc.w	$180,$030
	dc.w	$2f07,$FFFE
	dc.w	$180,$040
	dc.w	$3007,$FFFE
	dc.w	$180,$030
	dc.w	$3107,$FFFE
	dc.w	$180,$020
	dc.w	$3207,$FFFE
	dc.w	$180,$010
	dc.w	$3307,$FFFE
	dc.w	$180,$000

	dc.w	$ffdf,$fffe		; ACHTUNG! WAIT AM ENDE DER ZEILE FF!
							; die folgenden Wait sind unter der Zeile
							; $FF und starten wieder bei $00!!

	dc.w	$0107,$FFFE		; Ein fixer, grüner Balken UNTER der Zeile $FF!
	dc.w	$180,$010
	dc.w	$0207,$FFFE
	dc.w	$180,$020
	dc.w	$0307,$FFFE
	dc.w	$180,$030
	dc.w	$0407,$FFFE
	dc.w	$180,$040
	dc.w	$0507,$FFFE
	dc.w	$180,$030
	dc.w	$0607,$FFFE
	dc.w	$180,$020
	dc.w	$0707,$FFFE
	dc.w	$180,$010
	dc.w	$0807,$FFFE
	dc.w	$180,$000

BALKEN:
	dc.w	$0907,$FFFE		; Warte auf Zeile $79
	dc.w	$180,$300		; Beginne roten Balken: Rot auf 3
	dc.w	$0a07,$FFFE		; nächste Zeile
	dc.w	$180,$600		; Rot auf 6
	dc.w	$0b07,$FFFE
	dc.w	$180,$900		; Rot auf 9
	dc.w	$0c07,$FFFE
	dc.w	$180,$c00		; Rot auf 12
	dc.w	$0d07,$FFFE
	dc.w	$180,$f00		; Rot auf 15 (Maximum)
	dc.w	$0e07,$FFFE
	dc.w	$180,$c00		; Rot auf 12
	dc.w	$0f07,$FFFE
	dc.w	$180,$900		; Rot auf 9
	dc.w	$1007,$FFFE
	dc.w	$180,$600		; Rot auf 6
	dc.w	$1107,$FFFE
	dc.w	$180,$300		; Rot auf 3
	dc.w	$1207,$FFFE
	dc.w	$180,$000		; Farbe SCHWARZ

	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST


	end



EIN   WUNDER!   Wir   haben   es   geschafft,  farbige  Balken  unter  die
berühmt-berüchtigte Zeile $FF zu setzen! Und es reicht der Befehl

	dc.w	$ffdf,$fffe

und bei $0107 starten, um im unteren Teil des Bildschirmes zu warten.  Das
ist  so,  weil  ein  Byte nur 256 Werte darstellen kann, also bis $FF. Das
bedeutet, daß wenn wir eine Zeile abwarten wollen, die  unter  $FF  liegt,
wir $FFdf,$FFFE schreiben müßen, danach startet die Numerierung wieder bei
NULL, und geht soweit, wie der Bildschirm halt  reicht,  ca  bis  $30.  Zu
Bemerken ist, daß der amerikanische Fernsehstandart NTSC nur bis zur Zeile
$FF kommt, oder knapp mehr in Overscan,  die  Amerikaner  sehen  also  den
unteren  Teil  des  Bildes  nicht.  Aber das kümmert uns nur wenig, da der
Amiga ja vor allem in Europa verbreitet ist, und die  meisten  Demos  oder
Spiele  ja  eh  in  PAL  geschrieben  sind.  In  manchen Fällen machen die
Spieleprogrammierer eine NTSC-Version, die  dann  ausschließlich  für  den
Markt in den USA bestimmt ist.

Bemerkung: Bisher konnten wir mit dem $dff006 nur Zeilen bis $FF abfragen,
ich werde euch später beibringen, wie man mit  einem  $dffxxx  eine  Zeile
nach $FF korrekt abfragt.


