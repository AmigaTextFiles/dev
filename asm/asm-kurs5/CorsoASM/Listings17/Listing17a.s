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

; Listing17a.s = mask1.s

* ACHTUNG:
; Diese Quelle basiert auf Lektion 11h4.s von Randys-Kurs.
; es zeigt die Maskierung auch für vertikale Positionen
; größer als $80. Kommentare am Ende der Quelle
; die Originalquelle stammt von Randy - RJ
; Hey Randy, ich hoffe, es macht dir nichts aus, wenn ich deine Arbeit verbessere!
; Friendship RULEZ! :)))) (The Dark Coder)
 
	SECTION	DK,code
	;incdir	"/include/"			; wenn in einem Verzeichnis ein Ordner include
								; und in einem anderen Ordner die Quelle ist
								; (also zuerst eine Pfadebene höher gehen)
	incdir	"include/"			; wenn in einem Verzeichnis ein Ordner include
								; und im selben Verzeichnis die Quelle ist 
	include	"MVstartup.s"		; Startup Code: Nimmt
								; Systemprüfung vor und Aufruf
								; durch Platzieren der START-Routine: 
								; A5=$DFF000

			;5432109876543210
DMASET	EQU	%1000001010000000		; nur copper DMA

Start:
	lea	$dff000,a5
	move	#DMASET,dmacon(a5)		; DMACON - aktivieren copper
								

	move.l	#COPPERLIST,cop1lc(a5)	; Zeiger COP
	move	d0,copjmp1(a5)			; Start COP

mouse:

; Beachten Sie die doppelte Überprüfung der Synchronität
; notwendig, da der Copper-Move weniger als EINE Rasterzeile auf 68030 benötigt
	move.l	#$1ff00,d1			; Bits durch UND auswählen
	move.l	#$13000,d2			; warte auf Zeile $130 (304)
.waity1
	move.l	vposr(a5),d0		; vposr und vhposr
	and.l	d1,d0				; wählen Sie nur die Bits der vertikalen Pos.
	cmp.l	d2,d0				; warte auf Zeile $130 (304)
	bne.s	.waity1

.waity2
	move.l	vposr(a5),d0
	and.l	d1,d0
	cmp.l	d2,d0
	beq.s	.waity2

	btst	#2,potinp(a5)		; rechte Maustaste gedrückt?
	beq.s	.noMuovi			; wenn ja führe MuoviCopper nicht aus
	bsr.s	MuoviCopper			; Routine, die die WAIT-Maskierung nutzt
.noMuovi

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts

*****************************************************************************

MuoviCopper:
	tst.b	SuGiu				; Sollen wir rauf oder runter gehen? wenn SuGiu
								; gelöscht ist (d.h. der TST überprüft den BEQ)
								; dann springen wir zu VAIGIU, wenn es stattdessen $FF ist
								; (wenn dieser TST nicht verifiziert ist)
								; wir steigen weiter auf (machen subqs)
	beq.w	VAIGIU
	cmp.b	#$80,BARRA			; Haben wir die Zeile $80 erreicht?
	sne	SuGiu					; Wenn ja, sind wir oben und müssen runter
								; In Randys Code war ein springender Beq
								; zu einem Code, der das Flag löschte.
								; Mit dem SCC geht es schneller und spart
								; Speicher. Es ist ratsam immer Scc
								; zu verwenden, um die Flags zu ändern
	subq.b	#1,BARRA
	rts

VAIGIU:
	cmp.b	#$F0,BARRA			; Haben wir die Zeile $F0 erreicht?
	seq	SuGiu					; Wenn ja, sind wir ganz unten und müssen wieder hoch
								; Auch hier haben wir das BEQ durch ein SEQ ersetzt
								
	addq.b	#1,BARRA
	rts

SuGiu:	dc.b	0				; Richtungs-Flag
								; $00 - runter, $FF - rauf

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


BARRA:
	dc.w	$8407,$FFFE			; warte auf Zeile $84 (WAIT NORMAL!)
								; Dieses Wait ist der "Chef" des Wartens
								; maskierte folgen, tatsächlich folgen sie ihm
								; wie Handlanger: wenn das warten
								; um 1 sinkt, werden alle Waits maskiert
								; nach unten gehen um 1 usw.

	dc.w	$180,$300			; Ich starte den roten Balken: rot mit 3

	dc.w	$80E1,$80FE			; Dieses WAIT wartet auf das Ende einer Zeile.
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

	dc.w	$80E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$900			; rot mit 9

	dc.w	$80E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$c00			; rot mit 12

	dc.w	$80E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$f00			; rot mit 15 (maximal)

	dc.w	$80E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$c00			; rot mit 12

	dc.w	$80E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$900			; rot mit 9

	dc.w	$80E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$600			; rot mit 6

	dc.w	$80E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$300			; rot mit 3

UltimaFineRiga:
	dc.w	$80E1,$80FE			; auf das Zeilenende warten
	dc.w	$0001,$FFFE			; nutzloses WAIT das den Copper verlangsamt

	dc.w	$180,$000			; color schwarz

	dc.w	$fd07,$FFFE			; warten auf Zeile $FD
	dc.w	$180,$00a			; blaue Intensität 10
	dc.w	$fe07,$FFFE			; nächste Zeile
	dc.w	$180,$00f			; blaue Intensität maximal (15)

	dc.w	$FFFF,$FFFE			; ENDE COPPERLIST

	end

Randys Kurs zeigt in Lektion11h4.s, wie man eine Bar mit dem Copper durch
WAITs mit maskierter vertikaler Position macht.
Die Technik, mit der Sie die Aktualisierung der verglichenen Copperliste
beschleunigen können wenn WAIT mit NICHT maskierten vertikalen Positionen
verwendet wird.
In der Quelle wird auch die Unmöglichkeit behauptet, diese Technik anzuwenden
in vertikalen Positionen zwischen $80 und $FF. Wir zitieren direkt aus dem
Vortragskommentar 11h4.s:

"Man kann also sagen, dass die Maskierung im oberen Teil des Bildschirm von
$00 bis $7f und unterhalb der NTSC-Zone, dh nach dem $FFDF,$FFFE arbeitet."

Nun das ist falsch !!!
Wie wir auch im Artikel "More Advanced Copper" dazu erläutert haben, ist es
durchaus möglich, eine Maskierung an Positionen zwischen $80 und $FF mit einem
sehr einfachen Trick zu verwenden. In der Tat ergibt sich das Problem aus der
Tatsache, dass das höchste Bit der vertikalen Position des coppers nicht
maskierbar ist und daher, dass die Position die in WAIT (oder SKIP) angegeben
ist und die Elektronen-Strahlenposition vom copper zum Vergleich nicht
verwendet wird.
Randy verwendet in der Quelle Lektion11h4.s seines Kurses WAITs mit den 
7 maskierten Low-Bits der vertikalen Position, um auf das Ende einer Zeile
zu warten. Die WAITs, die Randy verwendet, sind DC.W $00E1,$80FE, die das
Bit 8 der zu wartenden vertikalen Position (d.h. Bit 15 des ersten WORTES)
auf 0 setzen.
Wenn ein solches WAIT durchgeführt wird, wenn sich der Elektronenstrahl
an einer vertikalen Position befindet, wobei Bit 8 auf 0 gesetzt ist (d.h.
weniger als $80 oder größer als $FF), wobei die 8 Bits den gleichen Wert
haben und wenn die anderen Bits der vertikalen Position deaktiviert sind,
wird die horizontale Position berücksichtigt, und daher wartet das WAIT wie
gewünscht auf das Zeilenende.
Wenn stattdessen ein solches WAIT durchgeführt wird, wenn sich der
Elektronenstrahl an einer vertikalen Position befindet, wobei Bit 8 auf 1
gesetzt ist (d.h. größer als oder gleich $80 und kleiner als oder gleich $FF),
wobei Bit 8 der vertikalen Position des Elektronenstrahls größer als Bit 8
der in angegebenen Wait-Position, dann betrachtet der copper die von WAIT
angegebene Position als geringer als der Elektronenstrahl und wartet NICHT
auf das Ende der Zeile.
Wie warten Sie dann auf das Ende einer Zeile, deren vertikale Position das
Bit 8 auf 1 gesetzt hat? Es ist sehr einfach, WAIT wie folgt zu verwenden:

  DC.W $80E1,$80FE

Dieses WAIT unterscheidet sich von dem von Randy verwendeten, weil es Bit 8 der 
vertikalen Position auf 1 gesetzt hat. Auf diese Weise, wenn es getan wird,
wenn der Elektronenstrahl sich in vertikaler Position befindet, wobei Bit 8
gesetzt ist bis 1 sind die gleichwertigen Bits 8 und da die anderen Bits der
vertikalen Position deaktiviert sind, wird die horizontale Position
berücksichtigt, und daher wartet WAIT wie gewünscht auf das Zeilenende.

Mit WAIT diesen Typs können wir die beschriebene Technik anwenden, um in der
Quelle Lezione11h4.s, den Balken in den Zeilen zwischen  $80 und $FF zu
verschieben. Beachten Sie jedoch, dass WAITs diesen Typs NICHT in Zeilen
funktionieren bei denen Bit 8 der vertikalen Position auf 0 gesetzt sind.

In der Tat, wenn die Ausführung in diesen Zeilen stattfindet, wo das Bit 8 der
vertikalen Position des Elektronenstrahls kleiner als die mit Bit 8 im Wait
angegebene Position ist, betrachtet der Copper die Position im wait als größer,
als die des Elektronenstrahls und darum wartet er beim Wait (blockiert den
Wait) bis der Elektronenstrahl die Zeile erreicht, wo Bit 8 auf 1 ist ($80
 oder die Copperliste startet wieder von vorn.

Es erreicht eine Zeile mit Bit 8 auf 1 ($80) oder die copperliste wird nicht
von Anfang an neu gestartet. Mit den in dieser Quelle verwendeten WAITs können
wir also die Bewegung des Balkens NUR in Zeilen zwischen $80 und $FF ausführen.
Sehen heißt glauben.

Wie bewegen wir dann eine Bar über den gesamten Bildschirm?
Wir werden dies im Beispiel "mask2.s" sehen. In der Zwischenzeit möchte ich
darauf hinweisen, dass wir in unserer copperliste einen weiteren Unterschied zu
der Quelle von Randy haben. Tatsächlich verwendet Randy ein paar WAITs:

	dc.w	$00E1,$80FE	; AUF DIE NÄCHSTE ZEILE WARTEN
	dc.w	$0007,$80FE	; MIT dem "maskierten" Wait bei Y

Das erste WAIT wartet auf das Ende einer Zeile. Aber wie Sie wissen beginnt
physisch eine Linie über den Bildschirm, wenn der Copper bereits die 
Position $7 erreicht hat. Wenn sich nach dem ersten WARTEN sofort das Copper
Move COLOR00 ändert, würden Sie die Farbänderung am rechten Bildschirmrand
sehen (wieder sehen ist glauben). Hierzu ist das zweite WAIT erforderlich.
Warten Sie auf die Position $7. Beachten Sie jedoch, dass der Copper eine
kurze Zeit benötigt um von Position $E1 zu Position $7 der folgenden Zeile
zu gelangen. Deshalb, um den unerwünschten Effekt zu vermeiden, kann auch eine
andere Lösung gewählt werden:
Zwischen dem Warten auf das Ende der Zeile und dem CMOVE, das COLOR00 ändert,
setzen sie eine copperanweisung, die nichts bewirkt, zum Beispiel WAIT (NOT
maskiert), die auf Position 0,0 wartet und daher immer übergeben wird.
Selbst wenn die Anweisung unbrauchbar ist, muss das copper einige Zeit
verschwenden, um es zu betreiben, und diese Zeitverschwendung ist genug.
Währenddessen erreicht der Elektronenstrahl die Position $7, dann wird der
CMOVE COLOR00 in einer solchen Position ausgeführt, dass der Farbwechsel am
rechten Rand ist. In diesem Beispiel haben wir diese Technik übernommen, also
setzen wir anstelle von Randys DC.W $0007,$80FE einige einfache und NICHT
maskiertee WAITs in Zeile 0, dh DC.W $0001,$FFFE ein.
Warum haben wir das gemacht? Das erfahren Sie im Beispiel "mask2.s" !!!!
