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

; Listing17a2.s = mask2.s

* ACHTUNG:
; Diese Quelle basiert auf Listing11h4.s von Randys-Kurs.
; Es zeigt, wie die Maskierung auch für vertikale Positionen über den gesamten
; Bildschirm durchgeführt wird. Kommentare am Ende der Quelle.
; die Originalquelle stammt von Randy - RJ
; Hey Randy, ich hoffe, es macht dir nichts aus, wenn ich deine Arbeit verbessere!
; Friendship RULEZ! :)))) (The Dark Coder)
 
	SECTION	DK,code
	incdir "/Sources/include/"
	include	MVstartup.s			; Startup Code: Nimmt
								; Systemprüfung vor und Aufruf
								; durch Platzieren der START-Routine: 
								; A5=$DFF000

			;5432109876543210
DMASET	EQU	%1000001010000000	; nur copper DMA

Start:
	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper
					
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bits durch UND auswählen
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $130 (304)
	BNE.S	Waity1

	btst	#2,$dff016			; rechte Maustaste gedrückt?
	beq.s	mouse2				; wenn ja führe MuoviCopper nicht aus

	bsr.s	MuoviCopper			; Routine, die die WAIT-Maskierung nutzt

mouse2:
	MOVE.L	#$1ff00,d1			; Bits durch UND auswählen
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts

*****************************************************************************

MuoviCopper:
	move	PosBarra(pc),d0		; liest Position Bar

	tst.b	SuGiu				; Sollen wir rauf oder runter gehen? wenn SuGiu 
								; gelöscht ist (d.h. der TST überprüft den BEQ)
								; dann springen wir zu VAIGIU, wenn es stattdessen $FF ist
								; (wenn dieser TST nicht verifiziert ist)
								; steigen wir weiter auf (machen subqs)
	beq.w	VAIGIU

	cmp	#$34,d0					; Vergleiche mit der Obergrenze
	sne	SuGiu					; das Flag entsprechend setzen

; aktualisiert die Balkenposition in der Variable und CLIST
	move	PosBarra(pc),d0
	subq	#1,d0
	move	d0,PosBarra
	move.b	d0,Barra			; das niedrige Byte in die copperliste schreiben

; Das zweite WAIT 255 muss aktiviert werden, wenn die letzte Zeile der
; Bar sich in Zeile $FE befindet, dh wenn PosBarra = $fe-8 ist
	cmp	#$fe-8,d0
	bne.s	.NoAttiva2			; wenn sich die Bar zu kreuzen beginnt
	move.b	#$ff,Attendi255_2	; Zeile 255 aktiviert das zweite WAIT 255
	bra.s	.change				; Überspringen Sie die Zeile $100 
.NoAttiva2

; Das erste WAIT 255 muss deaktiviert werden, wenn die erste Zeile der
; Bar an Zeile $ff ist
	cmp	#$ff,d0
	bne.s	.NoDisattiva1		; 
	move.b	#$00,Attendi255_1	; Zeile 255 deaktiviert das erste WAIT 255
.NoDisattiva1

.change
	move	#$7f,d0
	bsr	AdjustClist

	move	#$ff,d0
	bsr	AdjustClist

	rts

VAIGIU:
	cmp	#$114,d0				; Vergleiche mit dem unten stehenden Limit
	seq	SuGiu					; Setzen Sie das Flag entsprechend

; Aktualisiert die Balkenposition in der Variable und CLIST
	move	PosBarra(pc),d0
	addq	#1,d0
	move	d0,PosBarra
	move.b	d0,Barra			; das niedrige Byte in die copperliste schreiben

; Das zweite WAIT 255 muss deaktiviert werden, wenn die letzte Zeile der
; Bar in der Zeile $FF ist , dh wenn PosBarra = $ff-8 ist
	cmp	#$ff-8,d0
	bne.s	.NoDisattiva2		; wenn sich die Bar zu kreuzen beginnt
	move.b	#0,Attendi255_2		; Zeile 255 aktiviert das zweite WAIT 255
	bra.s	.change				; Überspringen Sie die Zeile $100 
.NoDisattiva2

; Das erste WAIT 255 muss aktiviert werden, wenn die erste Zeile der
; Bar auf Linie $100 ist 
	cmp	#$100,d0
	bne.s	.NoAttiva1			; 
	move.b	#$ff,Attendi255_1	; Zeile 255 aktiviert das erste WAIT 255
.NoAttiva1

.change
	move	#$80,d0
	bsr	AdjustClist

	move	#$100,d0
	bsr	AdjustClist

	rts


;Finito:
;	rts

; Variablen
PosBarra	dc.w	$34			; Position Bar
SuGiu:		dc.b	0			; Richtungs-Flag


*******************************
* Routine, die CLIST korrigiert
* D0 - Zielzeile, dh eine Zeile, die die Eingabe auf einen anderen 
* Bildschirmbereich begrenzt.

	cnop	0,4
AdjustClist
	move	PosBarra(pc),d1		; Balkenkoordinate der ersten Zeile
	move	d1,d2

	addq	#8,d2				; Position der letzten Zeilenleiste (es gibt 9 Zeilen)
	cmp	d0,d2					; Vergleiche mit der Ziellinie
	blo.s	.exit				; Wenn kleiner, ist die gesamte Bar
								; über der Ziellinie

	sub	d1,d0					; subtrahiert die Position von der Ziellinie
	blo.s	.exit				; Wenn D1> D0, ist die gesamte Bar
								; unterhalb der Ziellinie
						
								; sonst sagt uns der Unterschied
								; Welche Reihe der Leiste die gleiche Position
								; zu dem der Ziellinie hat.

; In D0 ist die zu ändernde WAIT-Ordnung angegeben:
; Mit 12 multiplizieren, Versatz zwischen 2 WAIT
	asl	#2,d0					; 4*d0
	move	d0,d1				; 4*d0 (Kopie)
	add	d0,d0					; 8*d0 = 2*(4*d0) 
	add	d1,d0					; 12*d0 = 4*d0+8*d0	

	lea	PrimaWaitMascherata,a0
	bchg	#7,(a0,d0.w)
	
.exit
	rts
	
*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$100,$200
	dc.w	$180,$000			; Anfangsfarbe copper Farbe SCHWARZ

	dc.w	$2c07,$FFFE			; eine kleine grüne Bar
	dc.w	$180,$010
	dc.w	$2d07,$FFFE
	dc.w	$180,$020
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

Attendi255_1:
	dc.w	$00E1,$FFFE			; warte auf Zeile 255

Barra:
	dc.w	$3407,$FFFE			; warte auf Zeile $34 (WAIT NORMAL!)
								; Dieses Wait ist der "Chef" des Wartens
								; maskierte folgen, tatsächlich folgen sie ihm
								; wie Handlanger: wenn das warten
								; um 1 sinkt, werden alle Waits maskiert
								; nach unten gehen um 1 usw.

	dc.w	$180,$300			; Ich starte den roten Balken: rot mit 3

PrimaWaitMascherata:
	dc.w	$00E1,$80FE			; Dieses WAIT wartet auf das Ende einer Zeile.
								; Dies ist ein Wait mit vertikal maskierter Position
								; Weil die Anweisung NACH der Zeile $80 ausgeführt
								; werden muss, das hohe Bit (nicht maskierbar)
								; muss auf 1 gesetzt werden.

	dc.w	$0001,$FFFE			; Dieses WAIT ist eine "nutzlose" Anweisung
								; Tatsächlich blockiert es niemals den copper.
								; Ihr Zweck ist es einige Zeit für den copper
								; zu verlieren, damit der folgende CMOVE ausgeführt
								; wird, wenn der Elektronenstrahl die
								; nächste Zeile startet.

	dc.w	$180,$600			; rot mit 6

	dc.w	$00E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$900			; rot mit 9

	dc.w	$00E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$c00			; rot mit 12

	dc.w	$00E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$f00			; rot mit 15 (al massimo)

	dc.w	$00E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$c00			; rot mit 12

	dc.w	$00E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$900			; rot mit 9

	dc.w	$00E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$600			; rot mit 6

	dc.w	$00E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$300			; rot mit 3

	dc.w	$00E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$000			; color schwarz

Attendi255_2:
	dc.w	$FFE1,$FFFE			; warten auf Zeile 255

	dc.w	$2007,$FFFE			; warten auf Zeile $FD
	dc.w	$180,$00a			; blaue Intensität 10
	dc.w	$2107,$FFFE			; nächste Zeile
	dc.w	$180,$00f			; blaue Intensität maximal (15)

	dc.w	$FFFF,$FFFE			; ENDE COPPERLIST

	end

In diesem Beispiel zeigen wir, wie die örtliche vertikale Maskierung über den
gesamten Bildschirm verwendet wird. Wir haben die übliche Bar, die sich diesmal
über den Bildschirm bewegt. Wie wir wissen, verwenden wir WAIT mit Y Maske. Das 
Bit 8 der angegebenen Position muss auf den gleichen Wert wie die vertikale
Position gesetzt werden, in der die Anweisung ausgeführt werden soll. Der
Einfachheit halber werden im Folgenden die Zeilen 0 bis $7F als Zone 1 des
Bildschirms, die Zeilen von $80 bis $FF als Zone 2 und die Zeilen ab $100 als
Zone 3 angegeben.

Wenn wir solche dynamischen Copperlisten haben, mit der ein maskiertes WAIT an
jeder Position des Bildschirms durchgeführt werden kann, ist die einzige
Möglichkeit, die maskierten WAITs "on the fly" zu ändern. Wie wir sagten
haben wir in skip1.s in Bezug auf Randys Code WAITs mit Maskierung
DC.W $0007,$80FE durch einfache NICHT maskierte WAITs DC.W $0001,$FFFE, die das
Gleiche tun ersetzt.
Auf diese Weise haben wir die Anzahl der maskierten WAITs in der CLIST halbiert
und folglich auch die Anzahl der durchzuführenden Änderungen! In unserem Fall
müssen wir nur die WAITs ändern, die auf das Ende einer Zeile warten. Wenn wir
auf das Ende einer Zeile in Zone 1 oder 3 warten müssen, müssen wir ein
DC.W $00E1,$80FE haben, während wenn wir in Zone 2 warten, brauchen wir ein
DC.W $80E1,$80FE. Wir müssen also Bit 8 dieser Anweisung entsprechend setzen.

Die Aufmerksamen werden sich sofort fragen: "Aber wer kann uns dazu bringen, es
an dieser Stelle zu tun?
Verwenden Sie das maskierte WAIT, wenn wir die CLIST trotzdem ändern müssen?".
Die Beobachtung ist tatsächlich richtig, wie Sie sich erinnern werden, kann
dieser Effekt auch mit nicht maskierten WAITs erreicht werden und der Vorteil
von Nicht maskierten WAITs ist genau das, nicht alle WAITs in jedem frame
modifizieren zu müssen.
Die Änderungen, die an den nicht maskierten WAITs vorgenommen werden müssen,
sind jedoch viele kleine. Tatsächlich ist es notwendig, Bit 8 der vertikalen
Position zu invertieren, NUR eines WAITS, wenn dieses WAIT von Zone 1 zu Zone 2
übergeht (oder umgekehrt) oder wenn es von Zone 2 zu Zone 3 geht (oder
umgekehrt), was nur gelegentlich passiert.
Wenn sich der Balken wie in diesem Fall nur in jedem Frame um 1 bewegt, ist es
offensichtlich, dass von allen WAITs, aus denen sich die Bar zusammensetzt
höchstens EIN WAIT von einem Bereich zum anderen geht.

Zusammenfassend, in dem Fall, in dem wir das nicht maskierte WAIT verwenden,
müssen wir Alle Waits in jeden Frame ändern. Mit dem NICHT maskierten WAIT
ändern wir stattdessen EIN WAIT in SEHR WENIGEN Frames. Es ist daher
offensichtlich, dass das WAIT NICHT maskiert ist Sie sind immer noch sehr
profitabel.

Lassen Sie uns die praktische Umsetzung sehen. Wie gesagt jedes Mal, wenn ein
WAIT von einer Zone zur anderen geht müssen wir ein Bit ändern, das heißt, wir
können es infach invertieren. Beim Übergang von Zone 2 zu Zone 3 haben wir noch
ein Problem: Die WAIT-Anweisung wartet auf Zeile 255.

Lassen Sie uns zuerst sehen, wie Sie die WAITs ändern. Alle Änderungen werden 
von einer einzigen Routine verwaltet, die in allen Fällen funktioniert, an der
der Parameter der "Ziel"-Zeile übergeben wird, dh die Zeile, die den Durchgang
von einer Zone zu einer anderen bestimmt. Diese Routine bestimmt den MÖGLICHEN
Durchgang eines der WAITS über die Ziellinie und invertieren Sie folglich den
Status von Bit 8 des Y.
Beachten Sie, dass die Ziellinie $80 beträgt, wenn wir von Zone 1 nach Zone 2
gehen, denn sobald ein WAIT in Zeile $80 ausgeführt wird, muss sein Bit auf 1
gesetzt werden. Wenn wir andererseits von Zone 2 zu Zone 1 aufsteigen, wird die
Ziellinie zu $7F denn sobald ein WAIT in Zeile $80 ausgeführt wird, muss das
Bit auf 0 gesetzt werden. 

Natürlich muss bei jeder Iteration unsere Routine (AdjustClist) zweimal
durchgeführt sein, einmal, um den Übergang von Zone 1 zu Zone 2 zu überprüfen
(oder umgekehrt, wenn wir in die entgegengesetzte Richtung gehen) und einmal,
um den Übergang von Zone 2 zu Zone 3 zu überprüfen (oder umgekehrt, wenn wir in
die entgegengesetzte Richtung gehen).

Man könnte argumentieren, dass diese Routine (zweimal) ausgeführt werden muss
verlieren den Vorteil, weniger Änderungen an der CLIST vornehmen zu müssen
(im Vergleich zu im Fall von NICHT maskierten WAITs), aber es ist nicht so:
in der Tat diese Routine hat feste Ausführungskosten, während im Fall von
NICHT maskierten WAITs die Anzahl der durchzuführenden Änderungen der Anzahl
der Zeilen entspricht, aus denen die Bar besteht:
Denken Sie an den Fall eines 60 Zeilen hohen Balkens!!
Auch ist die Routine sehr kurz und wird im CACHE (falls vorhanden) ausgeführt
und tut dies (möglicherweise) ein einziger Zugriff auf den CHIP (die Änderung
des Einlaufs), während im NICHT maskierten Fall jede Änderung eines WAIT ein
CHIP-Zugriff ist.

Wie bereits erwähnt, ist der Übergang von Zone 2 zu Zone 3 ein weiteres
Problem. In der copperliste wartet tatsächlich ein WAIT auf die Zeile $FF
(255). Es ist offensichtlich, dass wenn unsere Bar höher ist, muss dieses WAIT 
nach den Anweisungen der Bar ausgeführt werden, während es zuerst ausgeführt
werden muss, wenn sich der Balken in Zone 3 befindet. Um dieses Problem zu
lösen verwenden wir 2 WAIT, die auf diese Zeile warten, eine vor und eine nach
den Anweisungen der Bar und wir aktivieren eine nach der anderen. Wie
deaktivieren und aktivieren wir ein WAIT? Einfach, ändern Sie es einfach, indem
Sie Y 0 als Position statt 255 setzen, um es zu deaktivieren, und setzen Sie
255 zurück, um es zu aktivieren.
Beachten Sie, da sich der Balken teilweise in Zone 2 und teilweise in Zone 3
befindet, muss keine der 2 WAITs aktiviert sein, da die Zeile wartet 255 wird
von der WAIT von der Bar selbst gemacht. Also (falls es von Zone 2 auf 3
abfällt), wenn sich der Balken in Zone 1 und 2 befindet ist das erste WAIT
deaktiviert und das zweite ist aktiviert. In dem Moment, wenn sich die letzte
Zeile der Bar in Zeile $FF befindet, wenn der Balken deaktiviert ist.
Solange sich der Balken zwischen den beiden Zonen befindet, bleiben beide Waits
bestehen deaktiviert und wenn die erste Zeile der Leiste in Zeile $100 steht
ist das erste WAIT  aktiviert. Wenn Sie nach oben gehen, folgen diese Aktionen
einander in umgekehrter Weise.
