
; Listing9f2.s		Charakter mit dem Blitter schreiben

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA ; $83C0


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#2-1,D1				; Anzahl der Bitebenen (hier sind 2)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0			; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	LEA	TESTO(PC),A0			; Adresse des zu druckenden Textes in a0
	LEA	BITPLANE,A3				; Adresse der Ziel-Bitebene in a3
	bsr.w	Stampa				; Drucken der Textzeilen auf dem Bildschirm

	LEA	TESTO2(PC),A0			; Adresse des zu druckenden Textes in a0
	LEA	BITPLANE2,A3			; Adresse der Ziel-Bitebene in a3
	bsr.w	Stampa				; Drucken der Textzeilen auf dem Bildschirm

mouse:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse				; wenn nicht, gehe zurück zu mouse:

	rts


;***************************************************************************
; Routine, die 16x20 Pixel breite Zeichen druckt
;
; A0 = zeigt auf die Tabelle mit den zu druckenden Zeichen
; A3 = zeigt auf die Bitebene, auf der gedruckt werden soll
;***************************************************************************

;	........................
;	:     .______.         :
;	:     l_  _ ¬l    xCz  ¦
;	¦     C©)(®) ·)        |
;	|     l¯C.   T .       |
;	|    __¯¯¯¯) l ::.     |
;	|   (__¯¯¯¯__) ::::.   |
;	¦    __T¯¯T__  ::::::. |
;	`---/  `--'  \---------'
;	    ¯¯¯¯¯¬¯¯¯¯

STAMPA:
	MOVEQ	#10-1,D3			; Anzahl der zu druckenden Zeilen: 10

PRINTRIGA:
	MOVEQ	#20-1,D0			; Anzahl der Spalten pro Reihe: 20

PRINTCHAR2:
	MOVEQ	#0,D2				; d2 löschen
	MOVE.B	(A0)+,D2			; Nächstes Zeichen in d2
	SUB.B	#$20,D2				; ZIEHE 32 VOM ASCII-WERT DES BUCHSTABEN AB,
								; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
								; (Das $20 entspricht), IN $00, DAS
								; AUSRUFUNGSZEICHEN ($21) IN $01....
	ADD.L	D2,D2				; WIR MULTIPLIZIEREN DEN WERT MIT 2,
								; weil jedes Zeichen 16 Pixel breit ist.
								; Auf diese Weise finden wir den Offset.
	MOVE.L	D2,A2

	ADD.L	#FONT,A2			; DEN GEFUNDENEN CHARAKTER IM FONT FINDEN ...

	btst	#6,$02(a5)			; warte auf das Ende des Blitters
waitblit:
	btst	#6,$02(a5)
	bne.s	waitblit

	move.l	#$09f00000,$40(a5)	; BLTCON0: Kopie A nach D
	move.l	#$ffffffff,$44(a5)	; BLTAFWM und BLTALWM wir erklären es später

	move.l	a2,$50(a5)			; BLTAPT: Adresse font (Quelle A)
	move.l	a3,$54(a5)			; BLTDPT; Adresse bitplane (Ziel D)
	move	#120-2,$64(a5)		; BLTAMOD: modulo font
	move	#40-2,$66(a5)		; BLTDMOD: modulo bitplanes
	move	#(20<<6)+1,$58(a5)	; BLTSIZE: 16 Pixel, das ist 1 Wort.
								; * 20 Zeilen Höhe. Zu bemerken ist, dass für
								; das Verschieben der 20 aus Bequemlichkeit
								; das Shift Symbol <<, links verwendet wird
								; (20 << 6) entspricht (20 * 64).

	ADDQ.w	#2,A3				; A3+2, wir erweitern um 16 Bit (NÄCHSTES CHARAKTER)

	DBRA	D0,PRINTCHAR2		; WIR DRUCKEN D0 (20) ZEICHEN PRO REIHE

	ADD.W	#40*19,A3			; wir bewegen uns 19 Zeilen nach unten.

	DBRA	D3,PRINTRIGA		; wir drucken D3 Zeilen
	RTS



; Achtung! Nur diese Zeichen sind in der Schriftart verfügbar:
;
; !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ

		; Anzahl der Zeichen pro Zeile: 20
TESTO:	    ;         11111111112
			;12345678901234567890
	dc.b	' PRIMA RIGA TESTO 1 ' ; 1
	dc.b	'                    ' ; 2
	dc.b	'     /   /          ' ; 3
	dc.b	'    /   /           ' ; 4
	dc.b	'                    ' ; 5
	dc.b	'S S A R G           ' ; 6
	dc.b	'                    ' ; 7
	dc.b	'                    ' ; 8
	dc.b	'FABIO CIUCCI        ' ; 9
	dc.b	'                    ' ; 10

	EVEN


		; Anzahl der Zeichen pro Zeile: 20
TESTO2:	    ;         11111111112
			;12345678901234567890
	dc.b	'                    ' ; 1
	dc.b	'SECONDA RIGA TESTO 2' ; 2
	dc.b	'     /   /          ' ; 3
	dc.b	'    /   /           ' ; 4
	dc.b	'                    ' ; 5
	dc.b	'SESTA RIGA          ' ; 6
	dc.b	'                    ' ; 7
	dc.b	'                    ' ; 8
	dc.b	'F B O C U C         ' ; 9
	dc.b	'    AMIGA RULEZ     ' ; 10

	EVEN

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

	dc.w	$100,$2200			; bplcon0 - 2 bitplane lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
BPLPOINTERS2:
	dc.w	$e4,0,$e6,0			; zweite bitplane

	dc.w	$180,$000			; color0 - Hintergrund
	dc.w	$182,$19a			; color1 - erste bitplane
	dc.w	$184,$f62			; color2 - zweite bitplane
	dc.w	$186,$1e4			; color3 - erste+zweite bitplane

	dc.w	$FFFF,$FFFE			; Ende copperlist


;****************************************************************************

; Der FONT von 16x20 Zeichen ist hier gespeichert. IN CHIP RAM, weil es
; mit dem Blitter kopiert wird, und nicht mit dem Prozessor!

FONT:
	incbin	"/Sources/font16x20.raw"
	

;****************************************************************************

	SECTION	PLANEVUOTO,BSS_C

BITPLANE:
	ds.b	40*256		; bitplane lowres
BITPLANE2:
	ds.b	40*256		; bitplane lowres

	end

;****************************************************************************

In diesem Beispiel verwenden wir den Blitter, um Zeichen auf dem Bildschirm zu
drucken. 10 Zeilen mit je 20 Zeichen werden gedruckt.
Als Quelle haben wir eine Schriftart, die aus einer einzelnen Bitebene besteht.
Der Zielbildschirm hingegen besteht aus 2 Bitebenen: Auf diese Weise haben wir
3 Farben für die Charakter (d.h. die Farben 1,2 und 3, weil Farbe 0 für den
Hintergrund ist).
Um eine Schrift mit der Farbe 1 zu drucken, kopieren wir sie nur in die
Bitebene 1. Wenn wir es mit Farbe 2 drucken, kopieren wir es nur in Bitebene 2
und wenn wir es mit der Farbe 3 drucken, kopieren wir es in beide Bitebenen.
Wir haben etwas ähnliches in Listing6h.s mit dem 8x8 Font gemacht. Der Druck
erfolgt jeweils in eine Bitplane. Der zu druckende Text ist in 2 Tabellen
(eine pro Bitebene) an den Labeln TEXTO und TEXTO2 enthalten.

Jede "map" oder seitenweise Ascii wird byteweise in den Offsetwert konvertiert.
Fügen Sie den Offset der Fontadresse hinzu, um zu wissen, welcher Charakter 
gedruckt werden soll.

Die Arbeit erledigt die Druckroutine, die einmal pro Bitebene aufgerufen wird.
Die Routine besteht aus 2 verschachtelten Schleifen (ineinander gesteckt). Die
innere Schleife druckt eine Reihe von Zeichen von links nach rechts. Der
externe Zyklus wiederholt den internen Zyklus 10 Mal und druckt 10 Zeilen
insgesamt.
Lassen Sie uns nun im Detail untersuchen, wie die Blitts aufgerufen werden.
Wir verwenden eine Schrift von 60 Zeichen 16 * 20. Die Schriftart ist in einer
"unsichtbaren" Bitebene enthalten. 960 Pixel breit und 20 Zeilen hoch, in
denen sie gezeichnet sind alle 60 Zeichen nebeneinander.
(In der Tat 60 * 16 = 960) in dieser Reihenfolge (ASCII):

 !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ

Die Font16x20.iff-Datei ist vorhanden und es ist die ursprüngliche Schriftart.
Achten Sie darauf, dass die Charakter nach dem Sechzigsten fehlen:

	[\]^_`abcdefghijklmnopqrstuvwxyz{|}~

Wenn Sie Kleinbuchstaben und andere Symbole möchten, machen Sie Ihre eigene 
Schriftart und ihre Routine kann es lesen. Machen Sie sich selbst zum
"Standard". Da die Schriftarten 1 Wort (16 Pixel) und 20 Zeilen hoch sind, ist
die Größe der Blitts gleich. Die Modulo werden mit der üblichen Formel
berechnet.
Die Quell-Bitebene ist 60 Wörter breit (d.h. 960 Pixel, d.h. 120 Bytes)
und dann ist das Quellmodulo 2 * (60-1) = 120-2 = 118.
Die Ziel-Bitebene ist 20 Wörter breit (d.h. 320 Pixel, d.h. 40 Bytes)
und dann ist das Zielmodulo 2 * (20-1) = 40-2 = 38.
Mal sehen, wie die Zeiger gehandhabt werden. Der Zeiger auf das Ziel variiert
bei jedem Blitt, um den Charakter an einer anderen Position des Bildschirms zu
zeichnen, von links nach rechts und von oben nach unten.
Der Mechanismus ist der gleiche wie im Beispiel Listing9c2.s.
Der Zeiger auf die Quelle muss stattdessen jedes Mal auf das Zeichen zeigen,
das gedruckt werden soll. Die Daten der Quellbitplane sind wie folgt aufgebaut:

Adresse		Inhalt
FONT		erste Zeile (16 Pixel, dann 1 Wort) des Charakters '
FONT+2 		erste Zeile des Charakters '!'
FONT+4  	erste Zeile des Charakters '"'

.
.
.
FONT+120  	erste Zeile des Charakters 'Z'
FONT+122  	zweite Zeile des Charakters ' '
FONT+124  	zweite Zeile des Charakters '!'
.
.
.

FONT+2282 	letzte Zeile des Charakters ' '
FONT+2284 	letzte Zeile des Charakters '!'
.
FONT+2398 	letzte Zeile des Charakters 'Z'


Die Routine liest von der Tabelle den ASCII-Code des zu druckenden Zeichens
und berechnet die Adresse daraus. Die Methode ist sehr ähnlich zu der, die wir 
in Lektion 6 gesehen haben, als wir das gleiche mit dem Prozessor gemacht haben.
Aus dem ASCII - Code können wir den Abstand des Zeichens vom Anfang des Zeichens 
ableiten. Um dies zu tun, subtrahieren wir 32 (also den ASCII-Code des
Leerzeichens) Das erste Zeichen der Schriftart ist das Leerzeichen.
An dieser Stelle gehen wir anders vor als bei der Lektion 6.
Tatsächlich wurde die Schriftart von Lektion 6 "vertikal" gezeichnet, d.h.:


!
"
#

etc.

>
?
@
A
B
C
D
E
F
G

etc.

In diesem Fall müssen wir zur Berechnung der Adresse den Wert ASCII (minus 32)
mit dem vom Zeichen belegten Speicher multiplizieren.
In diesem Fall wird die Schrift jedoch "horizontal" gezeichnet, da wir an der
Adresse des ersten Wortes der zu zeichnenden Schrift interessiert sind, sollten
wir den ASCII-Code (minus 32) mit dem belegten Speicherplatz multiplizieren
durch die ERSTE ZEILE eines jeden Zeichens, da die erste Zeile des Zeichens
die uns interessiert, wird NACH der ersten Zeile der vorangehenden Zeichen
gespeichert, aber VOR allen anderen vor der Zeile, (anders als in der
Lektion 6, in dem alle Zeilen eines Zeichens vor der nächstes Zeichen). Da
eine Zeile 2 Bytes belegt (1 Wort = 16 Pixel) müssen wir mit 2 multiplizieren,
was wir mit einem einfachen ADD tun können, es spart uns eine langsame MULU.
