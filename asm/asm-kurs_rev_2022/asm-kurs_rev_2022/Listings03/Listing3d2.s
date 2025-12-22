 
; Listing3d2.s	; BALKEN, DER RAUF-UND RUNTERGEHT, ERSTELLT MIT MOVE & WAIT
				; DES COPPERS
				
;	Routine wird einmal alle drei Frames ausgeführt
	
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

frame:
	cmpi.b	#$fe,$dff006	; Sind wir auf Zeile 254? (muß die Runde nochmal
	bne.s	frame			; drehen!) Wenn nicht, geh nicht weiter


frame2:
	cmpi.b	#$fd,$dff006    ; Sind wir auf Zeile 253? (muß die Runde nochmal
	bne.s	frame2	        ; drehen!) Wenn nicht, geh nicht weiter


	bsr.s	BewegeCopper	; Eine Routine, die den Balken bewegt


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

;	Routine mit dem ZOOM-Effekt verändert, wie wir ihn schon kennen

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
	subq.b	#1,(a0)	 		; müßen runter
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
	cmpi.b	#$fa,8*9(a0)	; sind wir bei Zeile $fa angekommen?
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
	dc.w	$180,$000		; COLOR0 - Beginne die COP mit SCHWARZ
	dc.w	$4907,$FFFE		; WAIT - Warte auf Zeile $49 (73)
	dc.w	$180,$001		; COLOR0 - sehr dunkles Blau
	dc.w	$4a07,$FFFE		; WAIT - Zeile 74 ($4a)
	dc.w	$180,$002		; ein bißchen helleres Blau
	dc.w	$4b07,$FFFE		; Zeile 75 ($4b)
	dc.w	$180,$003		; helleres	Blau
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
	dc.w	$180,$300		; Beginne den roten Balken: Rot auf 3
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

In diesem Beispiel wird die Routine BewegeCopper einmal  alle  drei  Frame
ausgeführt,   also   einmal   alle   3   fünfzigstel   Sekunden,   um  die
Geschwindigkeit  zu  reduzieren.  Verwendet  wurde   die   Strategie   der
verschiedenen  Cmp  mit dem $dff006. Andererseits wirkt die Bewegung nicht
mehr so flüßig, wie man an dem unteren Teil des Balkens an seinem  Ruckeln
bemerkt.

Nun  ist  die Zeit gekommen, euch einige Tricks des Gewerbes beizubringen.
Wenn lange Copperlist verändert  werden  müßen,  z.B.  alle  07  durch  87
ersetzt  werden  müßen, dann kann der REPLACE-Befehl des Editors verwendet
werden. Er ermöglicht uns, gewisse Strings  (Wörter,  Teile  von  Wörtern,
Buchstabenreihen)  durch  andere  zu  ersetzen.  Um  die genannte Änderung
vornehmen zu können, positioniert euch mit dem Cursor an  den  Anfang  der
Copperlist,  dann  drückt zugleich die Tasten "AMIGA-SHIFT-R", und oben am
Bildschirm  erscheint  die  Schrift  "Search  for:".  Hier  ist  der  Text
einzugeben,   der   zu  ersetzten  ist,  danach  RETURN  In  unserem  FAll
"07,$fffe". Nun erscheint "Replace with:". Hier kommt der  Text  hinein  ,
der  an  Stelle  des vorher eingegebenen kommen soll, bei unserem Beispiel
"87,$FFFE". Nun wird der Cursor zum ersten 70,$fffe springen, und es  wird
die  Schrift  "Replace: (Y/N/L/G)" auftauchen. Nun muß entschieden werden,
ob das 07 durch das 08 ersetzt werden soll. Wenn ja, drückt Y, wenn nicht,
N.  Dieses beendet, wird der Cursor zum nächsten 07,$fffe springen und die
Frage wiederholen. Ändert ruhig alle bis zum Ende der  Copperlist,  steigt
dann aber mit ESC aus, um nicht auch die im darunterstehenden Text (diesem
Text!) in Mitleidenschaft zu  ziehen.  Wenn  ihr  G  drückt,  werden  alle
07,$fffe im Text ausgetauscht, bis zum Ende. Denkt gut darüber nach, bevor
ihr das G (GLOBAL) verwendet, ihr könntet etwas ändern, was ihr gar  nicht
wolltet, einfach weil es aus dem Blickfeld war. Es ist besser, mit dem Y /
N fortzufahren, bis man das Ende der interessierten Zone erreicht hat, und
dann  mit  ESC  aussteigen,  oder  L  bei der letzten Änderung drücken, es
bedeutet LOCALE, also LETZTE Änderung.

Einmal die Änderung vollbracht,  startet  das  Listing:  nun  werden  alle
Farbüberläufe  in  der  Mitte  des  Balkens stattfinden, er wird irgendwie
"Stufen" bekommen. Das ist die Folge dessen, weil wir die  Farbe  eben  in
der Mitte des Bildschirmes ändern ($87) anstatt am Anfang (07).

Probiert  nun,  alles  nochmal  zu  verändern, indem ihr als Orginalstring
"87,$ff" eingebt, und als zu ersetzender String "$67,$ff". Nun werden sich
die  Stufen  weiter rechts befinden. Zum Schluß, macht noch diesen Effekt:
Zur Zeit habt ihr alle Wait zu $67 verändert, gut. Versucht  nun,  sie  in
$67  zu  verwandeln, aber bei der Abfrage, gebt einmal Y und einmal N ein,
bis zum Ende. Jetzt wird eine Zeile bei $67 Farbe ändern, die  andere  bei
$69, usw, es wird eine Art Ziegelmauer-Effekt geben:

	ooooooo+++++
	oooo++++++++
	oooooo++++++
	oooo++++++++
	oooooo++++++


