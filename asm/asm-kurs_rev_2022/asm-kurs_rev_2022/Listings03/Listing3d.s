
; Listing3d.s	; BALKEN, DER RAUF-UND RUNTERGEHT, ERSTELLT MIT MOVE & WAIT
				; DES COPPERS

;	In diesem Listing wird ein Label als FLAG verwendet, also als
;	Signal, ob unser Balken steigen oder sinken muß. Analysiert
;	dieses Programm sehr genau, es ist das erste im Kurs, das
;	Probleme im Bereich der bedingten Sprünge/Schleifen bereiten
;	kann.

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
							; des Betriebssystemes
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


BewegeCopper:
	LEA	BALKEN,a0			; in a0 kommt die Adresse von Balken
	TST.B	RAUFRUNTER		; Müßen wir steigen oder sinken? Wenn RaufRunter
							; auf 0 steht (wenn TST also BEQ liefert), dann
						    ; springen wir auf GEHRUNTER, wenn es hingegen
						    ; auf $FF ist (TST also nicht eintrifft), fahren
	beq.w	GEHRUNTER		; wir fort und führen somit den "steigenden" Teil
							; aus
	
	cmpi.b	#$82,8*9(a0)	; sind wir bei Zeile $82 angekommen?
	beq.s	SetzRunter		; wenn ja, sind wir oben angekommen und
	subq.b	#1,(a0)			; müßen runter
	subq.b	#1,8(a0)		;
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
	cmpi.b	#$fc,8*9(a0)	; sind wir bei Zeile $fc angekommen?
	beq.s	SetzRauf		; wenn ja, sind wir unten und müßen wieder
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


; Dieses Byte, das von dem Label RAUFRUNTER markiert ist, ist ein FLAG,
; also eine "Fahne" (man kann es sich so vorstellen), einmal ist sie
; auf $FF, ein anderes Mal auf $00, je nachdem ob wir steigen oder sinken
; müßen! Es ist wie eine Flagge, denn wenn sie unten ist ($00) bedeutet
; es, daß wir runter müßen, wenn sie gehißt ist ($FF), dann müßen wir
; rauf. Es wird eine Kontrolle gemacht, auf welcher Zeile wir uns
; befinden, und verglichen, ob wir oben oder unter angelangt sind. Ist
; das der Fall, dann sagt uns das Flag, welche Richtung wir danach
; einschlagen müßen, und dann ändern wir ihren Zustand mit clr.b RAUFRUNTER
; oder move.b #$ff,RAUFRUNTER.

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
							; Die Copperlist MÜSSEN in die CHIP RAM!
COPPERLIST:
	dc.w	$100,$200		; BPLCON0
	dc.w	$180,$000		; COLOR0 - Beginne die COP mit SCHWARZ
	dc.w	$4907,$FFFE		; WAIT - Warte auf Zeile $49 (73)
	dc.w	$180,$001		; COLOR0 - sehr dunkles Blau
	dc.w	$4a07,$FFFE		; WAIT - Zeile 74 ($4a)
	dc.w	$180,$002		; ein bißchen helleres Blau
	dc.w	$4b07,$FFFE		; Zeile 75 ($4b)
	dc.w	$180,$003		; helleres  Blau
	dc.w	$4c07,$FFFE		; nächste Zeile
	dc.w	$180,$004		; helleres  Blau
	dc.w	$4d07,$FFFE		; nächste Zeile
	dc.w	$180,$005		; helleres  Blau
	dc.w	$4e07,$FFFE		; nächste Zeile
	dc.w	$180,$006		; Blau auf 6
	dc.w	$5007,$FFFE		; überspringe 2 Zeilen:
							; von $4e bis $50, also von 78 bis 80
	dc.w	$180,$007		; Blau auf 7
	dc.w	$5207,$FFFE		; überspringe 2 Zeilen
	dc.w	$180,$008		; Blau auf 8
	dc.w	$5507,$FFFE		; überspringe 3 Zeilen
	dc.w	$180,$009		; Blau auf 9
	dc.w	$5807,$FFFE		; überspringe 3 Zeilen
	dc.w	$180,$00a		; Blau auf 10
	dc.w	$5b07,$FFFE		; überspringe 3 Zeilen
	dc.w	$180,$00b		; Blau auf 11
	dc.w	$5e07,$FFFE		; überspringe 3 Zeilen
	dc.w	$180,$00c		; Blau auf 12
	dc.w	$6207,$FFFE		; überspringe 4 Zeilen
	dc.w	$180,$00d		; Blau auf 13
	dc.w	$6707,$FFFE		; überspringe 5 Zeilen
	dc.w	$180,$00e		; Blau auf 14
	dc.w	$6d07,$FFFE		; überspringe 6 Zeilen
	dc.w	$180,$00f		; Blau auf 15
	dc.w	$780f,$FFFE		; Zeile $78
	dc.w	$180,$000		; Farbe SCHWARZ

BALKEN:
	dc.w	$7907,$FFFE		; Warte auf Zeile $79
	dc.w	$180,$300		; Beginne den roten Balken: Rot auf3
	dc.w	$7a07,$FFFE		; nächste Zeile
	dc.w	$180,$600		; Rot auf 6
	dc.w	$7b07,$FFFE
	dc.w	$180,$900		; Rot auf 9
	dc.w	$7c07,$FFFE
	dc.w	$180,$c00		; Rot auf 12
	dc.w	$7d07,$FFFE
	dc.w	$180,$f00		; Rot auf 15 (Maximum)
	dc.w	$7e07,$FFFE
	dc.w	$180,$c00		; Rot auf 12
	dc.w	$7f07,$FFFE
	dc.w	$180,$900		; Rot auf 9
	dc.w	$8007,$FFFE
	dc.w	$180,$600		; Rot auf 6
	dc.w	$8107,$FFFE
	dc.w	$180,$300		; Rot auf 3
	dc.w	$8207,$FFFE
	dc.w	$180,$000		; Farbe SCHWARZ

	dc.w	$fd07,$FFFE		; Warte auf Zeile $FD
	dc.w	$180,$00a		; Blau Intensität 10
	dc.w	$fe07,$FFFE		; nächste Zeile
	dc.w	$180,$00f		; Blau maximale Helligkeit (15)
	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST


	end

Jetzt geht der Balken rauf und runter. Geholfen hat uns dabei  ein  Label,
das  uns mitteilt, welche Richtung wir einschlagen mußten: wenn RAUFRUNTER
NULL ist, dann werden die Befehle ausgeführt, die den  Balken  zum  sinken
bringen,  umgekehrt,  wenn  es  auf  $FF  stand,  dann wurde die Serie von
Anweisungen ausgeführt, die den Balken zum steigen stimulieren. Am  Anfang
ist das Label auf 0, also werden die ADDQ durchgeführt, die den Balken zum
sinken bringen, bis, einmal unten angekommen, das Label umgeschrieben wird
(es kommt ein $FF rein), und deswegen beim TST.B RAUFRUNTER jetzt die SUBQ
angesprungen  werden,  die  ihn  zum  steigen  bringen.  Am  oberen   Ende
angekommen  kommt  wieder 0 ins FLAG RAUFRUNTER, und das Spielchen beginnt
von vorne. Mit dieser Routine können auf einfache Weise  die  Effekte  der
Änderungen  getestet  werden: Probiert einen ; vor den Befehlen zu setzen,
die die Zeile $FF mittels $dff006 abwarten:

mouse:	
	cmpi.b	#$ff,$dff006	; VHPOSR - sind wir bei Zeile 255 angekommen?
;	bne.s	mouse			; Wenn nicht, geh nicht weiter
	...

	bsr.s	BewegeCopper	; Diese Subroutine läßt das WAIT sinken!
							; Sie wird einmal pro Frame ausgeführt.
Warte:
	cmpi.b	#$ff,$dff006	; VHPOSR
;	beq.s	Warte

Jetzt verlieren wir das Timing mit dem Bildschirm, und der  Balken  spielt
verrückt,  versucht  es mal so auszuführen! Habt ihr´s gesehen, ihr hattet
nicht mal die Zeit, die Bewegung zu sehen! Vor allem, wenn ihr einen A1200
oder  einen  anderen  schnellen  Computer  habt. Nun lassen wir den Balken
langsamer  laufen,  und  zwar  dadurch,  daß  wir  die  Routine,  die  ihn
steigen/sinken  läßt,  nur einmal alle 2 Frames ausführen lassen statt
bei jedem: (entfernt auch den "Warte"-Zyklus)

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
;	bne.s	mouse			; Wenn nicht, geh nicht weiter

frame:
	cmpi.b	#$fe,$dff006	; Sind wir auf Zeile 254? (muß die Runde nochmal
	bne.s	frame			; drehen!) Wenn nicht, geh nicht weiter

	bsr.s	BewegeCopper

Warte:						; weggelassen, kein Risiko mehr...
;	cmpi.b	#$ff,$dff006	; VHPOSR
;	beq.s	Warte
	
In diesem Fall geht die Zeit von zwei Fotogrammen verloren, denn wenn  der
Beam  bei Zeile $FF ankommt, also 255, dann wird der erste Loop (Schleife)
verlassen und man steig in den zweiten ein, dem  frame-Loop:  dieser  aber
wartet  auf  Zeile  254!!! Um dahinzukommen muß der Beam aber zum Ende des
Bildschirms gelangen, und von vorne  starten,  deshalb  ergibt  sich  eine
Gesamtwartezeit  von  2 Fotogrammem (Frames). Ihr werdet bemerken, daß mit
dieser Änderung der Balken nur  mehr  den  halben  Zahn  drauf  hat.  Noch
langsamer wollt ihr es? Na gut, verlieren wir 3 Frames:

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
;	bne.s	mouse			; Wenn nicht, geh nicht weiter

frame:
	cmpi.b	#$fe,$dff006	; Sind wir auf Zeile 254? (muß die Runde nochmal
	bne.s	frame			; drehen!) Wenn nicht, geh nicht weiter
	

frame2:
	cmpi.b	#$fd,$dff006	; Sind wir auf Zeile 253? (muß die Runde nochmal
	bne.s	frame			; drehen!) Wenn nicht, geh nicht weiter

	bsr.s	BewegeCopper
	...

Auf die gleiche Weise haben wir hier beim Ausgang aus dem  2.  Loop  einen
dritten angehängt, und somit wieder ein Frame "verloren".

Um  zu  überprüfen, zu welcher Zeile ihr gekommen seid, steigt durch einen
Mausklick aus und probiert ein "M BALKEN", und ihr werdet den letzten Wert
erhalten, den das WAIT hatte.


