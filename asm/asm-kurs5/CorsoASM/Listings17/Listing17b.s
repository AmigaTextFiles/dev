		************************************
		*       /\/\                       *
		*      /    \                      *
		*     / /\/\ \ O R B_I D           *
		*    / /    \ \   / /              *
		*   / /    __\ \ / /               *
		*   ¯¯     \ \¯¯/ / I S I O N S    *
		*           \ \/ /                 *
		*            \  /                  *
		*             \/                   *
		*     Feel the DEATH inside!       *
		************************************
		* Coded by:                        *
		* The Dark Coder / Morbid Visions  *
		************************************

; Listing17b.s = skip1.s

; Kommentare am Ende der Quelle

	SECTION	DK,code

	incdir	"Include/"
	include	MVstartup.s		; Startup Code: Nimmt
							; Systemprüfung vor und Aufruf
							; durch Platzieren der START-Routine: 
							; A5=$DFF000

			;5432109876543210
DMASET	EQU	%1000001010000000		; copper DMA

Start:

	move	#DMASET,dmacon(a5)
	move.l	#COPPERLIST,cop1lc(a5)
	move	d0,copjmp1(a5)

	move.l	#copperloop,cop2lc(a5)	; Laden der loop-Adresse
									; in COP2LC

mouse:	
	bsr	MuoviCopper

; Beachten Sie die doppelte Überprüfung der Synchronität
; notwendig, da Muovicopper-Bewegungen auf 68030 WENIGER als EINE Rasterlinie erfordern
	move.l	#$1ff00,d1		; Bits durch UND auswählen
	move.l	#$13000,d2		; warte auf Zeile $130 (304)
.waity1
	move.l	vposr(a5),d0	; vposr und vhposr
	and.l	d1,d0			; wählen Sie nur die Bits der vertikalen Pos.
	cmp.l	d2,d0			; warte auf Zeile $130 (304)
	bne.s	.waity1

.waity2
	move.l	vposr(a5),d0
	and.l	d1,d0
	cmp.l	d2,d0
	beq.s	.waity2

	btst	#6,$bfe001		; Maus gedrückt?
	bne.s	mouse

	rts

************************************************
* Diese Routine durchläuft die Farben in der copperlist
MuoviCopper:
	lea	copperloop,a0

	move.w	6(a0),d0

	moveq	#7-1,d1			; nur 8 Farben werden durchgetaktet
.loop	
	move.w	14(a0),6(a0)
	addq.l	#8,a0
	dbra	d1,.loop

	move.w	d0,6(a0)
	rts

	SECTION	COPPER,DATA_C

COPPERLIST:

; Bar 1
	dc.l $01800111
	dc.l $2907fffe
	dc.l $01800a0a
	dc.l $2a07fffe
	dc.l $0180011f
	dc.l $2b07fffe
	dc.l $01800000

	dc.w	$3007,$FFFE		; warte auf Zeile $30

copperloop:					; Ab hier beginnt die Schleife
	dc.w	$0007,$87fe		; Warte Startzeile 0 - wie sie sind
							; Die Bits 3 bis 7 der Position sind vertikal maskiert
							; dieses Wait wird auf alle
							; Zeilen warten wo die Bits 0 bis 2 gelöscht sind
							; d.h. $30, $38, $40, $48 usw.
	dc.w	$180,$080
	dc.w	$0107,$87fe		; Warten auf den Anfang von Zeile 1 - so wie sie sind
							; Die Bits 3 bis 7 der Position sind maskiert
							; vertikal wird dieses Wait auf alle 
							; Zeilen mit den Bits 0 bis 2 am Wert %001 warten
							; das sind die Zeilen $31, $39, $41, $49, etc.
	dc.w	$180,$0a0
	dc.w	$0207,$87fe
	dc.w	$180,$0c0
	dc.w	$0307,$87fe
	dc.w	$180,$0e0
	dc.w	$0407,$87FE
	dc.w	$180,$0c0
	dc.w	$0507,$87FE
	dc.w	$180,$0a0
	dc.w	$0607,$87FE
	dc.w	$180,$080
	dc.w	$0707,$87FE
	dc.w	$180,$088
	dc.w	$00e1,$80FE		; Warten auf das Ende der letzten Zeile der Schleife
							; Diese Anweisung ist notwendig, da
							; wenn das WAIT von Zeile 0 ausgeführt wird
							; vor dem Ende von Zeile 7 blockiert nicht

	dc.w	$6007,$ffff		; SKIP bei Zeile $60
	dc.w	$8a,0			; Schreiben in COPJMP2 - zum Anfang der Schleife springen 

	dc.w	$180,$000
	dc.w	$FFDF,$FFFE		; warte auf Zeile 255

; Bar 2
	dc.l $01800000
	dc.l $1407fffe
	dc.l $0180011f
	dc.l $1507fffe
	dc.l $01800a0a
	dc.l $1607fffe
	dc.l $01800111

	dc.w	$FFFF,$FFFE		; Ende der copperlist

	end

Dieses Beispiel zeigt eine Verwendung von copperschleifen. Wir wollen eine
Copperliste machen die die Farbe COLOR00 in jede Rasterzeile ändert. Wie Sie in
den ersten Lektionen des Kurses gelernt haben, reicht es aus, eine copperliste
zu schreiben, die an jeder Zeile wartet, gefolgt von einem Coppermove im
COLOR00-Register. Wenn wir zum Beispiel das COLOR00 von Zeile 30 bis Zeile 60 
ändern wollen, müssen wir die folgenden Anweisungen in der copperliste
schreiben:

	dc.w	$3007,$fffe		; warte auf Zeile $30
	dc.w	$180,$345		; schreibt in color00
	dc.w	$3107,$fffe		; warte auf Zeile $31
	dc.w	$180,$456		; schreibt in color00
	
	.
	.

	dc.w	$6007,$fffe		; warte auf Zeile $60
	dc.w	$180,$000		; schreibt in color00

Dieses Stück copperliste belegt 4 Wörter pro Rasterzeile für insgesamt
8 * ($60-$30) = 384 Bytes. Wenn wir Farben fließen lassen wollen, müssen wir
eine 68000-Routine verwenden, die alle Farben liest und wie die Routine 
MuoviCopper dieses Beispiels neu schreibt. Diese Routine muss für jede 
Rasterzeile durchlaufen werden. In unserem Fall also $30 = 48 Iterationen.
Wenn die in COLOR00 zu schreibenden Farben alle unterschiedlich sind, ist dies
die einzige mögliche Methode. Wenn die Farben jedoch nicht unterschiedlich
sind, sich aber nach einer Weile wiederholen, ist dies der mögliche Fall, eine
Copperschleife zu verwenden. In unserem Beispiel möchten wir eine Folge von
8 Farben wiederholen. Da unser Effekt von $30 bis $60 (48 Zeilen) geht
bedeutet das, dass wir dieselbe Sequenz sechsmal wiederholen. Wir können
dann eine copperschleife schreiben, die die 8 Farben in Bereich der 
Zeilen $30 bis $60 wiederholt. Die Schleife (die Sie im Listing sehen
können) belegt 4 Wörter für jede Farbe, die es schreibt, plus weitere
3 Anweisungen, die jeweils 2 Wörter belegen (das Warten bis zum Ende der
letzten Zeile, das Überspringen und die die in COPJMP2 schreibt),
für insgesamt 8 * 4 + 3 * 2 = 38 Wörter oder 76 Bytes, gegenüber den 384 der
Copperliste ohne Schleife. Darüber hinaus muss die Routine, die die
Farben wiederholt nur 8 Iterationen ausführen, gegenüber 48 Iterationen im
"traditionellen" Fall, das heißt, es geht ungefähr 6 mal schneller.
