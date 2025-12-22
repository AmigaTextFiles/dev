
;	REFERENZTABELLE FÜR DIE 68000 PROGRAMMIERUNG - LEVEL 2

	                            !     !
				  _..'/\        |\___/|        /\-.._
	           ./||||||\\.      |||||||      .//||||||\.
	        ./||||||||||\\|..   |||||||   ..|//||||||||||\.
	     ./||||||||||||||\||||||||||||||||||||/|||||||||||||\.
	   ./|||||||||||||||||||||||||||||||||||||||||||||||||||||\.
	  /|||||||||||||||||||||||||||||||||||||||||||||||||||||||||\
	 '|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||`
	'||||'     `|||||/'   ``\|||||||||||||/''   `\||||||'     `|||`
	|/'          `\|/         \!|||||||!/         \|/'          `\|
	V              V            \|||||/            V              V
	`              `             \|||/             '              '
	                              \./
Autor: Fabio Ciucci				   V

Kurz die Adressierungsarten:

*******************************************************************************
 move.l #123,xxxx		; unmittelbar: den Wert nach dem # in das
						; Ziel kopieren
*******************************************************************************
 move.l xxxx,$50000		; absolut lang (ein langes Wort, soweit die
						; Speicheradressen auf Ihrem Computer gehen!).
*******************************************************************************
 move.l xxxx,$500.w	    ; absolut kurz (Adresse kleiner als $7FFF)
 						; Beispiel: "move.l 4.w,a6"
*******************************************************************************
 move.l	xxxx,D0		    ; Datenregister direkt (auf Dx-Datenregister kann
						; mit .b, .w und .l zugegriffen werden)
*******************************************************************************
 move.l	xxxx,A0		    ; Adressregister direkt (ein Zugriff ist nur
				; mit .w und .l auf ein Adressregister Ax möglich, tatsächlich
				; ein "move.b d0,a0" zum Beispiel würde einen Fehler ergeben,
				; ebenso wird ein move.b a0,d0 nicht assembliert!)
*******************************************************************************
 move.l	xxxx,(a0)	   ; Adressregister indirekt (d.h. es steht nicht
				; im Ax-Register, sondern an der Adresse die in dem Register
				; steht; Sie können mit .b, .w und .l arbeiten).
*******************************************************************************
 move.l	xxxx,(a0)+	   ; Adressregister indirekt mit Postinkrement
				; (nach dem Kopieren wird a0 um 1 erhöht, wenn
				; die Anweisung .b war, um 2 wenn .w und um 4 wenn .l)
*******************************************************************************
 move.l	xxxx,-(a0)	   ; Adressregister indirekt mit Predekrement
				; (zuerst wird das Register dekrementiert, um 1 wenn
				; die Anweisung .b war, um 2 wenn .w und 4 wenn .l, dann
				; erfolgt indirektes Kopieren, dh an die Adresse, die
				; im Register enthalten ist
*******************************************************************************
 move.l	xxxx,$123(a0)	   ; Adressregister indirekt mit OFFSET (Abstand der
				; Adressierung) - die Kopie erfolgt an die
				; Adresse, die sich aus der Summe des Inhalts des
				; Adressregisters plus Offset ergibt, im
				; Bereich zwischen -32768 und 32767 ($8000-$7fff)
*******************************************************************************
 move.l	xxxx,$12(a0,d0.w)  ; Adressregister indirekt mit OFFSET und INDEX
				; In diesem Fall wird der Index addiert, sowie
				; des Offset und der Inhalt des Registers Ax.
				; der Offset kann zwischen -128 und +127 variieren ($80-$7f)
				; der Index ist ein Daten- oder Adressregister von dem
				; nur seine niedrigen 16 Bit oder alle 32 Bit berücksichtigt
				; werden. Beispiele:

					move.l	$12(a1,d2.w),d0
					move.l	$12(a1,d2.l),d0
					move.l	$12(a1,a2.w),d0
					move.l	$12(a1,a2.l),d0

*******************************************************************************
 move.l offset(PC),xxxx	   ; Relativ zum PC mit OFFSET; normalerweise wird
				; der Offset vom Assembler berechnet, indem wir
				; ein Label setzen, wo wir schreiben wollen, Bsp:

					move.l	label(pc),d0

				; Das Label darf nicht weiter als $7fff entfernt sein,
				; weil der maximale Offset -32768 und 32767 beträgt
				; Hinweis: Normalerweise können Sie den (PC) nur zum 
				; Quelloperanden setzen und nicht zum Zieloperanden,
				; zB "move.l d0,label(PC)" existiert nicht.
				; Die einzige Anweisung, die dies erlaubt ist BTST:

		btst.l	d0,label(pc)

				; Ebenso 3 Anweisungen, die nur einen
				; Operanden haben, erlauben diese Adressierung

		jmp	label(pc)
		jsr	label(pc)
		pea	label(pc)

*******************************************************************************
 move.l offset(PC,d0.w),xxxx ; PC-Relativ mit OFFSET und INDEX; auch in
				; diesem Fall wird der Offset vom Assembler unter Verwendung 
				; der Label berechnet. Denken Sie daran, dass das Label
				; nicht mehr als 127 Byte von der Anweisung entfernt liegen
				; darf, wobei der maximale Offset -127, + 127 ist. 

		move.l	LabCanez(pc,d2.w),d0
		move.l	LabGatto(pc,d2.l),d0
		move.l	LabTopol(pc,a2.w),d0
		move.l	Labella1(pc,a2.l),d0

			    ; Wie wir für die Adressierung ohne Index gesehen haben,
				; können Sie diese Adressierung nur für den
				; Quelloperanden verwenden und nicht für
				; Zieloperanden. Zum Beispiel:
				; "move.l d0,Labella1(pc,a2.l)" existiert nicht!
				; Nur der BTST erlaubt es im zweiten Operanden:

		btst.l	d0,label(pc,a2.w)

			    ; Und 3 Anweisungen mit Operandenn:

		jmp	label(pc,d2.l)
		jsr	label(pc,d2.w)
		pea	label(pc,d2.w)

*******************************************************************************
 move.w d1,SR		    ; Status Register
*******************************************************************************
 move.w	d1,ccr		    ; Condition Code Register
*******************************************************************************

Noch kurz:

Adressierungsarten											Syntax
------------------											------

Datenregister direkt										 Dn
Adressregister direkt										 An
Adressregister indirekt										 (An)
Adressregister indirekt	mit Postinkrement					 (An)+
Adressregister indirekt	mit Predekrement					 -(An)
Adressregister indirekt	mit Offset (max 32767)				 w(An)
Adressregister indirekt	mit Offset und Index				 b(An,Rx)
Absolut kurz												 w
Absolut lang												 l
Program Counter mit Offset (berechnet von asmone)			 w(PC)
Program Counter mit Offset und Index						 b(PC,Rx)
unmittelbar													 #x
Status Register												 SR
Condition Code Register										 CCR


******************************************************************************

			DAS STATUS REGISTER: SR

SR - Status Register: die 16 Bit dieses Registers werden nur verwendet
wenn der Prozessor im Supervisor-Modus ist; ansonsten für den Programmierer
die 8 niederwertigen Bits, genannt Conditition Coderegister (CCR) verfügbar.
Sehen wir uns die Funktionen von SR im Detail an:

bit 0 - Carry (C): wird auf 1 gesetzt, wenn das Ergebnis einer Addition einen
Übertrag erzeugt, oder wenn ein Subtrahent größer als der Minuend ist, d.h.
wenn eine Unterschreitung ein "entlehnen" erfordert. Das Carry-Bit enthält
außerdem das höher- oder niederwertige Bit eines Operanden einer Verschiebung
oder Rotation. Es wird auf Null gesetzt, wenn die letzte durchgeführte
Operation keinen Übertrag, keine "Entlehnung" generiert.

bit 1 - Overflow (V): wird gesetzt, wenn das Ergebnis der letzten Operation
zwischen vorzeichenbehafteten Zahlen zu groß ist um im Zieloperanden enthalten
zu sein, z.B. wenn das Ergebnis die Grenzen -128 .. +127 im Byte-Feld
überschreitet. Zum Beispiel ergibt ein add.b 80 + 80 einen Überlauf, weil
+127 überschritten wurde. Im .w-Feld sind die Grenzen -32768 .. + 32767,
und im Bereich .l sind es - / + 2 Milliarden. Beachten Sie, dass die Summe
80 + 80 im Byte-Feld nicht die Flags Carry und eXtend setzt, sondern nur das
oVerflow-Flag, da 160 nicht 255 überschreitet, das Maximum, das in einem Byte
für normale Zahlen enthalten sein kann.

bit 2 - Zero (Z): wird gesetzt, wenn die Operation das Ergebnis Null erzeugt
(nützlich auch um das Dekrementieren eines Zählers zu kontrollieren), sowie
beim Vergleichen zwei identischer Operanden.

bit 3 - Negativ (N): es wird auf 1 gesetzt, wenn das hohe Bit der Zahl im 
Zweierkomplementformat gesetzt ist. In der Praxis, wenn das Ergebnis eine
negative Zahl ist, wird dieses Bit gesetzt, andernfalls wird es zurückgesetzt.
Das Zweierkomplement erhält man, indem man das Einerkomplement des Operanden
hat (d.h. Invertieren aller Bits), und 1 addiert wird; zum Beispiel +26 in
binär ist %00011010; sein Einerkomplement ist %11100101 (Invertierung der Bits
0 in Bits 1 und umgekehrt); Hinzufügen von 1 ergibt %11100110.
Bit 7, genannt Vorzeichenbit, wird in Bit 3 des Statusregisters kopiert;
Im Fall von -26 wird beispielsweise N gesetzt, was eine negative Zahl anzeigt.

bit 4 - Extend (X): ist eine Wiederholung des Carry-Bits und wird  in
Operationen in BCD-Notation (Binary Coded Decimal) verwendet: die Dezimalzahl
20 beispielsweise wird nicht mit 00010100 dargestellt, sondern in der
Form zwei für Zehner, und null Einer 0010 0000) und in den (erweiterten)
'extended' Binäroperationen wie ADDX und SUBX, Sonderversionen der Additions-
und Subtraktionsanweisungen ADD und SUB.

Terminologie:

Nibble:
Ein halbes Byte. Nicht direkt adressierbar, aber aus dem Byte durch
Verschiebungen und Rotationen extrahierbar. Das rechte Nibble (genannt
"low" oder "less significant") und das linke Nibble (genannt "high" oder
"most significant").

Stack:
Wörtlich "stapeln". Es ist ein Speicherbereich zum Speichern von Registerwerten
nach dem LIFO-Prinzip, (last in first out) der letzte eingegebene Wert, der
sich ganz oben auf dem Stapel befindet, ist auch der erste, der wieder
entnommen wird). Wenn im Laufe des Programms in ein Unterprogramm verzweigt
wird, wird der Wert vom PC (Program Counter) auf dem Stack gespeichert,
welcher als Rücksprungadresse am Ende des Unterprogramms "genommen" wird.


RICHTLINIEN UND EIGENSCHAFTEN DES ASSEMBLERS:

Der von uns verwendete Assembler, in unserem Fall ASMONE, wandelt das Listing
vom ASCII-Textformat ins Binärformat entsprechend den Anweisungen und Daten die
im Listing selbst enthalten sind. Es hat bestimmte besondere Konventionen und
Richtlinien (Direktiven) die Sie wissen müssen, zusätzlich zu den eigentlichen
68000-Anweisungen, die in diesem Text aufgeführt sind.

Erstens, wenn .b, .w oder .l in der Operation nicht angegeben ist,
nimmt es immer das .w an; ein Beispiel:

	move	d0,d1

wird assembliert als "MOVE.W d0,d1". Ähnlich wie:

	move	d0,12(a0,d0)

wird assembliert als

	MOVE.W	D0,$0C(A0,D0.W)

Daher wird auch das als Index verwendete Register d0 als d0.w betrachtet. Aus
diesem Grund ist es IMMER ratsam, die verschiedenen .b, .w und .l in den
Anweisungen anzugeben, oder wir werden nie sicher sein, wie das Ganze assembliert 
werden kann, vor allem von verschiedenen Assemblern.

Daneben gibt es noch weitere Besonderheiten, zum Beispiel bei Instruktionen wie
ASL,ASR,LSR,ROL ROR,ROXL,ROXR, die bei SHIFT um nur ein Bit in diesen beiden
Formen geschrieben sein können:

	(form1)
		ROL.w	#1,d3
		ROL.w	#1,(a0)
	(form2)
		ROL.w	d3
		ROL.w	(a0)

Wenn die Verschiebung größer als 1 ist, muss sie natürlich angegeben werden!
	
	z.B.:
		ROL.W	#3,d3

Ein weitere WICHTIGE Operation, die vom Assembler ausgeführt wird, ist das
automatische Erkennen, wann es notwendig ist MOVEA oder MOVE zu verwenden,
tatsächlich existieren zwei spezifische Anweisungen: der MOVE für allgemeine
Kopien, außer für Kopien in ADRESSE-Register AN, die mit MOVEA ausgeführt
werden.

In der Tat:
		MOVE.W	#10,d0
		MOVE.W	d1,d2

Diese Operationen liegen in der Verantwortung des MOVE, während:

		movea.w	d1,a0
		movea.l	a1,a0
		movea.w	(a1),a0

Es handelt sich um Operationen in Richtung Adressregister, daher sind sie
MOVEA!!! In Wirklichkeit, is es nicht notwendig, es jedes Mal zu kennzeichnen,
ob wir einen MOVE oder ein MOVEA machen, denn der ASMONE macht es für uns.
Geben Sie einfach immer MOVE an:

		move.w	a1,a0
		move.l	d0,d1
		move.l	(a1),a4

Diese 3 Anweisungen werden richtig assembliert, die erste und dritte als
MOVEA und die zweite als MOVE. Sie können MOVEA sogar angeben, wenn es
nicht korrekt ist und der richtige MOVE wird assembliert:

		movea.l	d0,d1

Es wird assembliert als MOVE.L d0,d1.

Das gleiche gilt für ADD,ADDI,ADDA;SUB,SUBI,SUBA;AND,ANDI;CMP CMPA,CMPI
EOR,EORI;OR,ORI: Nehmen wir den Fall von ADD als Beispiel für all diese
Gruppen von Befehlen: Es gibt 3 Arten von ADD, die die gleiche
Additionsoperation erledigen, aber auf anderen Operanden. Nun, wenn sie
eine Summe wie diese machen wollen, folgt:

	ADD.W	d0,d1

Das heißt, zwischen den Registern reicht zum Beispiel das einfache ADD,
während, wenn Sie eine Summe zu einem Adressregister haben wollen, gibt
es das passende ADDA:

	ADDA.L	d0,a1

Wenn Sie eine Konstante mit der #Unmittelbar-Adressierung hinzufügen müssen,
da ist das passende ADDI:

	ADDI.W	#10,d0

Nun, wir sollten immer ADDs schreiben und auf den Fall achten:

		add.l	(a1),d0
		addi.b	#$12,(a1)
		add.b	label(pc,d2.w),d0
		adda.l	(a1),a0
		add.w	$12(a1,d2.l),d0
		adda.w	(a1)+,a0
		add.b	$12(a1,d2.w),d0
		adda.w	label(pc),a0
		addi.w	#$1234,$1234.w

Natürlich akzeptieren fast alle Assembler immer ADD bei der Kompilierung
und assemblieren ADDI/ADDA/ADD entsprechend richtig:

		add.l	(a1),d0
		add.b	#$12,(a1)
		add.b	label(pc,d2.w),d0
		add.l	(a1),a0
		add.w	$12(a1,d2.l),d0
		add.w	(a1)+,a0
		add.b	$12(a1,d2.w),d0
		add.w	label(pc),a0
		add.w	#$1234,$1234.w

Schreiben Sie also immer ADD und sparen Sie sich die Aufteilung der Anweisung
in die 3 verschiedenen Fälle, so ist es immer noch ein ADD. Das gleiche gilt
für die anderen Anweisungen, die den "kleinen Bruder" mit der Endung "A" für
für Adressregister und mit "I" für Konstanten haben.
Schreiben Sie daher immer:

	MOVE	- für Anweisungen MOVE,MOVEA
	ADD		- für Anweisungen ADD,ADDI,ADDA
	SUB		- für Anweisungen SUB,SUBI,SUBA
	AND		- für Anweisungen AND,ANDI
	CMP		- für Anweisungen CMP,CMPA,CMPI
	EOR		- für Anweisungen EOR,EORI
	OR		- für Anweisungen OR,ORI

Die Erfinder der Assembler haben uns damit 10 Anweisugen erspart. Sie haben
17 in nur 7 "zusammengeführt". Aber wenn Sie ein Wahnsinniger und ein Ästhet
sind können Sie alle 17 (mah!) in den Listings angeben.

Ein Tipp: wenn Sie zum Beispiel auf ein Adressregister agieren:

	MOVEA.L	xxxx,Ax
	CMPA.L	Ax,Ax
	ADDA.L	xxxx,Ax
	SUBA.L	xxxx,Ax

Verwenden Sie immer die Erweiterung .L und niemals .W, da Adressen eine Länge
von einem longword haben, und vor allem, weil diese Anweisungen nicht auf
Register wie die anderen für die .W-Adressierung wirken, besonders keine
Adressierung .B erlauben:
Tatsächlich handelt ein MOVEA.W oder ein ADDA.W nicht nach dem Low-Wort des 
Adressregisters, sondern auf die gesamte Adresse, indem das "fehlende" hohe
Wort mit einer Kopie von Bit 15 des Low-Words gefüllt wird. So etwas
Ähnliches wie die EXT-Anweisung tritt auf (siehe Befehl), und dies kann FATAL
für manche Routinen sein. Diese "Erweiterung" bedeutet nämlich, dass zum
Beispiel ein ADD.W #$5000,a0 den Wert $00005000 hinzufügt, weil Bit 15 von
$5000 gelöscht ist, während ein ADD.W #$B000,A0 eine Erhöhung auf $FFFFB000
bewirkt, was sehr gefährlich ist.

Eine andere Konvention ist, dass das Register A7 auch als SP angegeben werden
kann:

	movem.l	d0-d7/a0-a6,-(SP) <-> movem.l d0-d7/a0-a6,-(a7)

Machen wir weiter mit den Konventionen: Wir wissen, um einen Kommentarbereich
zu definieren, ist es notwendig dem Kommentartext ein ; voranzustellen, aber
Sie können auch von einem Sternchen "*" vorangestellt sein:

	move.l	4.w,a6	* Kommentar!

Aber in Wirklichkeit könnte man nach der Anweisung direkt den Kommentar
schreiben ohne ein "*" oder ";" voranzustellen: 

	move.l	4.w,a6	Kommentar!

Allerdings erlauben nicht alle Assembler dies, und es hängt auch von der
Voreinstellungen der verschiedenen Assembler ab, also immer das ";" vor die
Kommentaren setzen.

Es gibt auch EQUATES, also Symbole, die wir definieren und verwenden können
anstelle der Nummern im Listing:

NumeroPlanes	EQU	5

	move.w	#NumeroPlanes,d0	; assembliert als MOVE.W #5,d0

Equates werden ähnlich wie Label definiert, sie haben beliebige Namen und
müssen nicht mit Abstand vom Anfang sein, aber im Gegensatz zu Labeln müssen
sie nicht mit ":" enden. Anstelle von EQU können Sie auch das Symbol "="
verwenden.

-	-	-	-	-	-	-	-	-	-

Natürlich, wenn es Operationen oder Ausdrücke gibt, werden diese in der
Assemblierungsphase gelöst, wie es durch Eingeben des Ausdrucks mit dem
Befehl "?" in der Befehlszeile des ASMONE gemacht wird:

	MOVE.W	#(10*3)+2,D0	; es wird assembliert als MOVE.W #32,d0
	MOVE.W	#(30/3)+2,d0	; es wird assembliert als MOVE.W #12,d0
	
Ebenso können die für Berechnungen definierten Gleichungen verwendet werden:

	move.w	#NumeroPlanes*2,d0

Oder Sie können Offsets von einigen Labeln angeben:

	MOVE.b	d0,SPRITE+1
	MOVE.b	d1,SPRITE+2
	MOVE.b	d2,SPRITE+3

Wir haben bereits gesehen, dass dies der Erstellung von 3 Labeln für jedes Byte
hinter dem SPRITE-Label entspricht. Zum Beispiel, um 100 Byte nach einem Label
zu schreiben:

	MOVE.B	d0,label+100

Und so weiter. Der Offset im Speicher wird so berechnet, als ob ein Label
100 Bytes nach dem Label vorhanden wäre (die Zahl zählt immer 1 Byte !!!).

Schließlich können Sie zum Beispiel sogar ein LABEL-EQUATE angeben:

HSTART:	EQU	*+1
VSTOP:	EQU	*+2

MIOSPRITE:		; Länge 13 Zeilen
	dc.b $50	; VSTART
	dc.b $90	; HSTART
	dc.b $5d	; VSTOP
	dc.b $00
	...

In diesem Fall wird das "*" nach dem EQU verwendet, was "DIESE ADDRESSE"
bedeutet, dann können wir übersetzen in: "HSTART: diese Adresse + 1" usw.
Anstatt die Label zwischen einem Byte und einem anderen zu platzieren, haben
wir sie auf einen bestimmten Abstand von diesem Byte definiert, aber wir
haben "den Offset" von diesem Punkt aus.
Bei HSTART und VSTOP beziehen wir uns auf die angegebenen Bytes, als ob die
Label an dieser Stelle platziert wurden. (Beispiel: "M HSTART": 90 5c 00 ....)
Dieser Trick mit dem "*" nach dem EQU kann auch für Bcc verwendet werden:

	move.l	d1,d2
;*-6
	move.b	(a1),d0
;*-2
	cmp.b	(a1),d0
	beq.s	*-2
	dbra	d2,*-6

In diesem Fall können wir anstelle des Assemblers den Offset für Bcc und DBcc
berechnen. (Ich habe einige ; zur Kennzeichnung der Offsets als Label angegeben
um es klarer zu machen). Die Verwendung von Label ist jedoch sicher bequemer.

Es kann nützlich sein, wenn Sie die Direktive "REPT" verwenden, die einen
bestimmten Teil Daten oder Code wiederholt:

	REPT	100	; 100 mal

	dc.b	"ciao"

	ENDR		; Ende des zu wiederholenden Teils

Mit dieser Direktive schreiben wir 100 Mal "ciao" in den Speicher. Natürlich,
wenn Sie ein LABEL verwenden würden, würde der Fehler "label already exists"
auftreten, daher könnten Sie den vorherigen Trick verwenden:

	REPT	100	; 100 mal

	move.l	d1,d2
;*-6
	move.b	(a1),d0
;*-2
	cmp.b	(a1),d0
	beq.s	*-2
	dbra	d2,*-6

	ENDR

Es gibt den Befehl "SET", der "eine Variable definiert", damit können Sie über
REPT, Tabellen oder Anweisungen nacheinander erstellen, zum Beispiel um eine
Tabelle mit Vielfachen von 2 zu erstellen:

TABELLA:
	dc.b	0,2,4,6,8,10,12,14,16,18

können wir auch schreiben:


TABELLA:

A set 0			; A ist gleich 0

	Rept	10	; mach das Stück 10 mal von hier bis ENDR

	dc.b	A*2	; lege (col dc.b) A*2 in den Speicher
A set A+1		; Bei der nächsten "Schleife" hat A den Wert A+1

	Endr

Der REPT-Befehl existiert jedoch nicht in allen Assemblern und oft wird das
Listing dadurch unübersichtlich. Es ist am besten es nicht zu verwenden, es sei
denn, es spart viel "manuelle" Schreibarbeit.

Um diesen Teil abzuschließen, sind hier die Operationen, die in den
"Ausdrücken" eingegeben werden können und beim Assemblieren aufgelöst werden,
die auch auch verwendet werden können, bei Verwendung des "?" um von der 
Befehlszeile aus zu berechnen:


	()	Klammern	; Ex: (10*2)*(3+5)
	*	Multiplikation
	+	Addition
	-	Subtraktion
	/	Division
	^	Potenz      (Bsp: "moveq #2^4,d0", assembliert "moveq #16,d0")

Es gibt auch LOGISCHE-Bitoperatoren:

	&	AND	(Bsp: %01010101 & %00001111 = %00000101
	!	OR	(Bsp: %00110011 ! %11000011 = %11110011
	~	EOR	(Bsp: %00110011 ~ %11000011 = %11110000
	>>	Shift nach rechts (Bsp: $50>>2 = $14) (%01010000>>2 = 00010100)
	<<	Shift nach links (wie LSL) (eg: $14<<2 = $50)

Diese können sehr nützlich sein, zum Beispiel um .l Werte in zwei Wörter zu
"trennen" usw. Angenommen, Sie möchten einen langen Wert in ein Wort teilen,
wobei die niedrigen 8 Bits in ein Ziel und die hohen 8 Bits in einem anderen
eingefügt werden. Wir können eine Equate definieren und den Wert vom ASMONE
"aufbrechen" lassen, also können wir jedes Mal einfach das equate ändern:


MICS	equ	2000


	move.b  #(MICS&$FF),$400(a4)	; setze das Low-Byte der Zeit
	move.b  #(MICS>>8),$500(a4)		; setze das High Byte der Zeit

(MICS & $FF) bedeutet also MICS AND $00FF, und wie wir wissen, AND löscht die
Bits, die im zweiten Operanden null sind und lässt sie unverändert, in diesem
Fall sind die ersten 8, d.h. $FF (%11111111). Da MICS = 2000 ist, das sind
$07d0, in diesem Fall ist die Operation $07d0 AND $00FF, also ist das Ergebnis
$00d0, das ist das LOW BYTE des Wortes. Die Anweisung ist wie folgt aufgebaut:

	MOVE.B	#$D0,$400(A4)

MICS >> 8 ist gleichbedeutend mit $07d0 LSR 8, das Ergebnis ist also das hohe 
"verschobene" Byte anstelle des niedrigen: $0007:

	MOVE.B	#$07,$500(A4)

Sie können auch die Adressen eines Langworts in 2 Wörter aufteilen, die als
Beispiel in Zeigern auf Bitplanes eingestellt werden können:

INDIRIZZO	EQU	$75000

Copperlist:
	dc.w	$e0,INDIRIZZO>>16	; hohes Wort der Adresse in BPL0PTH
	dc.w	$e2,INDIRIZZO&$FFFF	; niedriges Wort der Adresse in BPL0PTL

Alles wird so assembliert:

	dc.w	$e0,$0007
	dc.w	$e2,$5000

Es ist jedoch besser, auf die Bitplanes mit einer Routine zu zeigen und keine 
absoluten (FESTEN) Adressen zu verwenden. Diese Operatoren sind sehr nützlich,
denken Sie immer daran.

Weiter gehts mit den Direktiven:

	END		; zeigt das Ende des Listings an, das was nach dem END steht
			; wird nicht assembliert

Dann gibt es noch die Anweisungen bezüglich der Ausrichtung auf gerade oder
ungerade Adressen:

	EVEN	; ausrichten auf GERADE Addressen (Wort-Ausrichtung, 16 Bit)
	ODD		; ausrichten auf UNGERADE Addressen

Even funktioniert, wenn der Fehler "Word at odd address" auftritt. Ansonsten
kann es auf LongWord (32 Bit) oder auf 64 Bit ausgerichtet werden. Zum Beispiel
beim AGA CHIPSATZ, erfordern bestimmte Grafik Auflösungen, dass Bitplanes an
Adressen mit Vielfachen von 64 Bit ausgerichtet sind, und diese Direktive ist
unverzichtbar. Zur Ausrichtung verwenden wir CNOP:

	CNOP	Size[,Offset]

	cnop	0,2		; auf Wort ausrichten (16 Bit) Äquivalent zu EVEN
	cnop	0,4		; auf longword ausrichten (32 bit)
	cnop	0,8		; auf Adressen ausrichten, die durch 8 teilbar sind (64 Bit)
	cnop	0,16	;...

Apropos Ausrichtung: Denken Sie daran, dass sie bei einer ungeraden Adresse nur
in .b operieren können, ansonsten führt ein MOVE.W oder MOVE.L #xxx,Adresse zu
einem totalen Absturz mit Reset und GURU MEDITATION / SOFTWARE FAILURE.

Eine weitere sehr wichtige Direktive ist die DC.x, mit der Sie Bytes, Wörter 
und Langwörter, insbesondere Copperlist oder Tabellen speichern können:

	dc.w	$1234,$4567,$8901,$2345...

Oder für Label, die als Variablen mit einem einzelnen Wort/Langwort verwendet
werden:

GfxBase:
	dc.l	0

Wenn Sie Text schreiben, verwenden Sie dc.b und setzen den Text 
wischen "" oder ''

	dc.b	"Testo ASCII",$10,$11

Und Sie können auch dezimale / hexadezimale / binäre Werte auf die gleiche
Zeile setzen, trennen Sie sie einfach durch Kommas. Denken Sie daran, dass nach
einem Text oder in jedem Fall nach einm dc.b EVEN eingestellt werden muss, um
die eventuelle ungerade Adresse auszugleichen!

Seine Variante ist die DCB.x, die verschiedene Bytes, Wörter oder Langwörter im
Speicher ablegt, zum Beispiel:

	dcb.b	100,$55	; 100 aufeinanderfolgende $55 Bytes im Speicher speichern
	dcb.b	50,$00	; 50 bytes gelöscht

Diese Direktive kann zur Kompatibilität mit dem alten (aber mythisch) SEKA auch
BLK genannt werden, jedoch wird DCB universell verwendet.

Mit der SECTION BSS, verwenden Sie die Direktive "DS.x [Zahl]" um anzugeben,
wie viel Platz belegt werden soll, der nur aus Leerzeichen besteht:  

	ds.b	100			; 100 bytes gelöscht

Apropos SECTION, SECTION ist eine Direktive des Assemblers, der die Funktion
hat, Teile des Codes je nach ihrer Art in CHIP oder im FAST-RAM zuzuweisen.
In beschissenen oder alten Computern, zum Beispiel MSDOS oder anderen
archäologische Funden, gibt es kein Multitasking und keine Relocation von
Programmen im Speicher. In der Tat werden Programme so gemacht, dass sie an
bestimmte, präzise Speicheradressen gehen, während auf dem Amiga jedes
Programm "verschoben", dh in einen beliebigen freien Speicherbereich kopiert
werden kann, also können verschiedene Programme gleichzeitig an verschiedenen
Adressen im Speicher sein.
Wie auch immer, unter Windows kann man mehr als ein Programm in den Speicher
laden, aber jedes Programm arbeitet allein, ohne Multitasking HAHAHAHAHAHAH!
Die Wirkung dieser Direktiven wird jedoch beim Speichern der ausführbaren
Datei mit "WO" sichtbar, tatsächlich gibt es im ausführbaren Amiga-Format die
Hunks, d.h. die mit der SECTION bezeichneten Speicherteile, die vom mythischen
Amiga-Betriebssystem allokiert (zugewiesen) werden.
Aber wenn wir mit ASMONE assemblieren 'a' und springen 'j', wenn die
AutoAlloc-Option nicht aktiviert ist, werden alle Sections in CHIP
assembliert (Wenn wir bei der Eingangsfrage von ASMONE mit C geantwortet
haben!). Im ASMONE ist diese Option standardmäßig ausgeschaltet. 
Sie können es über das Menü Project / Preferences ../ AutoAlloc aktivieren.
Allerdings benötigt AutoAlloc mehr Speicher, da zusätzlich zu dem zu Beginn
zugewiesenen Speicher, jedes Mal, MEHR für die Sections zugewiesen wird. Die
SECTION kann CODE, DATA oder BSS sein und zu CHIP oder PUBLIC gehen, d.h.
in einen beliebigen Speicher. Um anzuzeigen, dass es in den Chip geht, wird ein
_C hinzugefügt:

	Section	Grafica,DATA_C	; Daten, in CHIP!!!

Eine weitere SEHR NÜTZLICHE Direktive ist das INCBIN, das Daten von der
Festplatte lädt, und es im Speicher an der Stelle ablegt, an der sich das
Incbin selbst befindet:

	INCBIN	"nomefile"

Eine ähnliche Direktive ist INCLUDE "filename", die stattdessen ASCII-Text
enthält, das heißt, ein Quelltext, der zusammen mit dem Rest des Codes
assembliert wird. Es kann verwendet werden, um "universell verwendete" Routinen
einzubinden, wie z.B. Startup- oder Musikroutine. Ich rate jedoch davon ab, zu
viele INCLUDES zu verwenden, denn dann kommt man an den Punkt, nicht zu wissen,
was in dem Listing ist, und wenn Sie eine der Dateien vermissen, die sie
einbiden wollen, heißt es: Auf Wiedersehen Assembler!

Die mit INCBIN und INCLUDE verbundene Direktive INCDIR, legt fest aus welchem
Verzeichnis Dateien geladen werden sollen. Aber Achtung, das letzte INCDIR ist
für alle später geladenen Listings gültig, also wenn die einzubindenden Dateien
woanders liegen muss man INCDIR zurücksetzen. Beispiele:

	INCDIR	"dh0:sorgentozzi/mieifiles"	; entscheidet ein dir

	INCDIR	""	; das Verzeichnis zurücksetzen, das Verzeichnis wird das aktuelle

Ich rate davon ab, Ihre Quellen mit INCDIR und INCLUDE zu füllen, denn dann
wenn Sie Ihr Listing zum Beispiel einem Freund zeigen wollen, müssen Sie Ihren
armen Quelltext in etwa fünfzig kleine Dateien auf die Festplatte kopieren, und
es wird schwer sein, sie alle in den verschiedenen Verzeichnissen der Festplatte
zu finden. Schließlich müssen Sie, sobald Sie bei diesem Freund sind, alle 
INCDIR-Pfade ändern, und vielleicht werden Sie feststellen, dass eine Datei
fehlt und Sie müssen es aufgeben, das Programm laufen zu lassen.
Ein cleverer Einsatz von INCBIN / INCLUDE kann folgendermaßen aussehen: Für
das INCBIN können alle kleineren Daten, unter 5Kb, zum Beispiel Sprites oder
kleine Tabellen, im DC.x-Format aufgenommen werden, während Bilder oder Musik,
die größer als 5K sind, bequem mit INCBIN geladen werden können: Auf diese 
Weise sind die "losen" Dateien so gering wie möglich, und das Listing ist kurz.
Für INCLUDES gilt dasselbe: Sie können das Include allenfalls für die Musik 
Routine oder für den Startup verwenden, aber niemand verbietet, INCLUDE
überhaupt nicht zu verwenden. Im Kurs wurde es verwendet, um die "Startup1.s" 
einzubinden, mehr als alles andere, um Platz zu sparen, der auf einer
Diskette nicht sehr groß ist.
Vielleicht möchten Sie zur Zufriedenheit ein, "A" und "J" machen und sofort
sofort etwa zehn 3D-Festkörpern mit etwa fünfzig Kugeln und den Equalizer
sehen ohne Laden von INCLUDE für 30 Minuten ????

Es gäbe auch bedingte Assemblies (IF, ENDIF, ELSE), aber sie sind nicht das 
Ende der Welt, bei Bedarf werden sie später erklärt.

Auch die MACROs (MACRO, ENDM) werden ggf. später erklärt, da sie nur eine Art
EQUATE verschiedener Befehle sind und und auf sie kann man größtenteils 
verzichten.

Was die lokalen Label (die mit dem vorangestellten ".") angeht, denke ich, dass
sie eine dumme Frivolität sind, für diejenigen, die keine Phantasie haben und
sich keine Namen für ihre Label ausdenken können. Nun gut, vielleicht habe ich
etwas übertrieben, aber ich glaube nicht, dass sie einen besonderen Nutzen
haben. Also machen Sie mir bitte keine Quellen mit Label mit einem
vorangestellten Punkt vor einem Label, sonst entfernen Sie sich von meiner
aktuellen ideologischen Codermeinung.

-	-	-	-	-	-	-	-	-	-

Ein paar Direktiven, die heute nicht mehr in Mode sind, die aber nützlich sein
könnten, sind ORG und LOAD, die in der Praxis verwendet werden, um die 
Anweisungen in unserem Listing an  FESTEN, ABSOLUTEN, NON-RELOCATABLE Adressen
zuzuweisen. Offensichtlich wurden diese Befehle zu der Zeit verwendet, als
diese Demos gemacht wurden die heute auf modernen Computern nicht mehr
funktionieren, denn WENN SIE EINE DEMO / SPIEL IM FORMAT EINER AUSFÜHRBAREN
DATEI ERSTELLEN, DARF ES KEINE ABSOLUTEN ADRESSEN GEBEN, SONDERN NUR SECTION!
Die Verwendung von ORG und LOAD wurde beibehalten, um ein Demo-/Autoboot-Spiel
zu machen, d.h. ein TRACKMO (Demo auf Tracks mit Non-Dos-Loading) oder ein
Spiel alten Typs. Andererseits sind die neuesten Demos und die neuesten Spiele
zunehmend auf der Festplatte installierbar, insbesondere die BESTEN Demos und
die BESTEN Spiele (siehe BANSHEE und BRIAN THE LION für Spiele). 
Ich glaube wirklich, dass Autoboot-Disketten in den nächsten Jahren
verschwinden werden, denn sie sind weder auf HD installierbar noch leicht auf
CD32 oder CD-ROM konvertierbar und das einzig Sichere ist, dass HDs und CD-ROMs
immer mehr beliebter werden.
Es ist auch die Tatsache, dass ALLES, was auf der Festplatte installiert wird,
MSDOS-PCs so beliebt gemacht hat (sogar Bestechungsgelder, wissen Sie).
In diesem Kurs dachte ich, ich würde einen großen Teil darüber schreiben, wie
man einen DiskLoader per Hardware macht und vielleicht einen Kopierer wie
XCOPY / DCOPY, als ich vor einem Jahr mit der Programmierung anfing. Aber in
Anbetracht der Realität habe ich beschlossen, mich nicht mit MFM Laden über
Hardware oder Autoboot zu befassen, weil ich Ihnen beibringen würde, etwas zu
tun, das Ihre Produktion benachteiligen würde!!!! Die beste Option ist das
Laden von Dateien mit dem Betriebssystem, z.B. DOS.LIBRARY, wie es die 
neuesten und besten Produktionen tun.
Ich rate Ihnen also dringend, nur ausführbare Dateien zu programmieren, die mit
"WO" gespeichert werden, keinen veralteten Autoboot und, was noch schlimmer
ist, das Listing wie folgt zu beginnen:

	ORG		$30000	; organisiert den Code mit absoluten Adressen ab $30000
	LOAD	$30000	; an der Adresse $30000 assemblieren 

Auch weil, wenn Sie 1MB oder 2MB Chip ohne FAST haben, wie A500+ / A600 
und A1200, standardmässig wird ASMONE selbst nach $30000 geladen, die
überschrieben werden und alles geht in GURU MEDITATION über. (Ich erinnere mich
noch an die Smau von 91 oder 92, wie die dummen Kinder ASMONE auf den A600
luden und sich wunderten, warum die gestohlenen oder kopierten Quellen, die sie
als ihr Werk ausgeben wollten, nicht funktionierten, HAHAHAHA! Nun, es waren
Quellen, die sie damals 1987-1988 auf Disketten gefunden hatten, und sie waren
voll von ORG und LOAD HAHAHAHAH!).

-	-	-	-	-	-	-	-	-

Dann gibt es andere Besonderheiten auf der Ebene der Assemblers, die von 
ASMONE-Einstellungen abhängen und das sind die:

Aus dem Menü: Assembler/assemble../Ucase=Lcase

Diese Option bedeutet Upper case = Lower case und bezieht sich auf Groß- oder
Kleinbuchstaben, aus denen das LABEL besteht. Normalerweise ist diese Option
gesetzt, daher berücksichtigt der Assembler die Großbuchstaben und
Kleinbuchstaben gleichermaßen, und Sie können schreiben:

LaBel1:
	btst	#6,$bfe001
	bne.s	labEL1

Das heißt, es reicht aus, dass das "Wort", das das Label bildet, dasselbe ist,
auch wenn Groß- und Kleinschreibung unterschiedlich sind. Mit Ucase = Lcase
deaktiviert, würden die beiden Bezeichnungen stattdessen als unterschiedlich
betrachtet, und es würde eine Fehlermeldung erscheinen, daher sollten Sie
schreiben:

Label1:
	btst	#6,$bfe001
	bne.s	Label1

Auf jeden Fall sollte jedes Label gleich sein, auch was die Groß- und
Kleinschreibung angeht. Da wir normalerweise vergessen, welche Zeichen wir 
groß- und kleingeschrieben haben, ist es besser, es so zu belassen, es lebe die
Freiheit!

Ein Hinweis zu Label: Der Befehl "=S" aus der Befehlszeile zeigt die
SYMBOLTABLE an. Das ist die Liste aller Label mit Offsets.

Letzter Hinweis: Wenn Sie einen Quelltext mit einer Million Labels compilieren,
zum Zeitpunkt des Speichern der ausführbaren Datei mit "WO" geht alles in GURU
MEDITATION über, es sei denn Sie führen einen schönen "Stack 20000" aus, bevor
Sie ASMONE ausführen.

******************************************************************************

Legende:
-------
   Dn	Datenregister		(n zwischen 0-7)
   An	Adressregister		(n zwischen 0-7 - A7 wird auch SP genannt)
    b	Konstante 8-bit		( von -128 ($80) bis +127 ($7f) )
    w	Konstante 16-bit	( von -32768 ($8000) bis +32767 ($7fff) )
    l	Konstante 32-bit	( maaximal $FFFFFFFF )
    x	Konstante 8-, 16-, 32-bit
   Rx	Indexregister; unter diesen kann es geben:

		Dn.W	16 bits die unteren (low-word) eines Datenregisters
		Dn.L	Alle 32 Bits eines Datenregisters
		An.W	16 bits die unteren (low-word) eines Adressregisters
		An.L	Alle 32 Bits eines Adressregisters

                           --------------------------

 
 \==================================|                    _=_ 
  \_________________________________/              ___/==+++==\___ 
	       """\__      \"""       |======================================/ 
		     \__    \_          / ..  . _/--===+_____+===--"" 
			\__   \       _/.  .. _/         `+' 
     USS ENTERPRISE	 \__ \   __/_______/                      \ / 
	NCC-1701	  ___-\_\-'---==+____|                  ---==O=- 
		    __--+" .    . .        "==_                     / \ 
		    /  |. .  ..     -------- | \ 
		    "==+_    .   .  -------- | / 
			 ""\___  . ..     __==" 
			       """"--=--"" 
 
 

	                                  _____
	                              _.-'     `-._
	                           .-'  ` || || '  `-.
	 _______________  _      ,'   \\          //  `.
	/               || \    /'  \   _,-----._   /   \
	|_______________||_/   /  \\  ,' \ | | / `.  //  \
	   |    |             _] \   / \  ,---.  / \   // \
	   |     \__,--------/\ `   | \  /     \  / |/   - |
	   )   ,-'       _,-'  |- |\-._ | .---, |  -|   == |
	   || /_____,---' || |_|= ||   `-',--. \|  -| -  ==|
	   |:(==========o=====_|- ||     ( O  )||  -| -  --|
	   || \~~~~~`---._|| | |= ||  _,-.`--' /|  -| -  ==|
	   )   `-.__      `-.  |- |/-'  | `---' |  -|   == |
	   |     /  `--------\/ ,   | /  \     /  \ |\   - |
	 __|____|_______  _    ] /   \ /  `---'  \ /   \\ /
	|               || \   \  //  `._/ | | \_.'  \\  /
	\_______________||_/    \   /    `-----'    \   /
	                         `.  //           \\  ,'
	                           `-._   || ||   _,-'
	                               `-._____,-'


                           --------------------------

;	LISTE ALLER ANWEISUNGEN des 68000:

HINWEIS: Es gibt Anweisungen, die fast nie verwendete wie ABCD, SBCD, SBCD,
      LINK, UNLK, weder der TAS-Befehl der auf dem Amiga nicht verwendet werden
	  sollte, noch ILLEGAL oder RESET, die nur eine Ausnahme der Peripheriegeräte
	  erzeugen.


Legende:

Condition codes:

	C	Carry (das heißt, übertragen)

	V	Overflow (außerhalb der Größe)

	Z	Zero

	N	Negativ

	X	Extend

	Status der Condition codes:

Symbol   Bedeutung
-------  -----------

   *     entsprechend dem Ergebnis der Operation einstellen
   -     Nicht verändert
   0     Gelöscht
   1     Gesetzt
   U     Status nach der Operation UNDEFINED
   I     Set aus den unmittelbaren Daten

	Weitere Symbole zur Adressierung:

<ea>     Effektiver Adressierungsoperand
<data>   Daten unmittelbar
<label>  Label des Assemblers (ASMONE)
<vector> Instruction exception vector TRAP (0-15)
<rg.lst> Liste der Anweisungsregister MOVEM

							       Condition Codes
							       ---------------
										  Assembler   Data
Instruction Description		               Syntax     Size		  X N Z V C
-----------------------                   ---------   ----        ---------
***************************************************************** X N Z V C ***
ADD      Addition binär                    Dn,<ea>     BWL        * * * * *
                                           <ea>,Dn

	HINWEIS: Es gibt 3 Arten von dedizierten ADDs: für Datenregister (ADD), für
    Adressregister (ADDA) und für Konstanten (ADDI). Der Assembler akzeptiert
	jedoch auch das einfache ADD zur Angabe von ADDA und ADDI, so dass Sie immer
	ADD schreiben können, auch wenn Sie Adressregister oder Konstanten
	"hinzufügen", der Assembler wird es als ADDA oder ADDI assemblieren.

	Die Summe von 2 Binärwerten wird als Ergebnis im Zieloperanden gespeichert.
	FLAG: Carry und eXtend = 1 wenn es zu einem Übertrag kommt, andernfallls = 0
	Negativ = 1 wenn das Ergebnis negativ ist, Negativ = 0 wenn es positiv ist.
	oVerflow = 1 wenn das Ergebnis die Größe überschreitet .b, .w oder .l des ADD
	Zero = 1 wenn das Ergebnis Null ist

	Bsp:

	Dn,<ea>
		add.b	d0,d1
		add.w	d0,(a1)
		add.l	d0,(a1)+
		add.b	d0,-(a1)
		add.w	d0,$1234(a1)
		add.l	d0,$12(a1,d2.w)
		add.b	d0,$12(a1,d2.l)
		add.b	d0,$12(a1,a2.w)
		add.w	d0,$12(a1,a2.l)
		add.l	d0,$1234.w
		add.w	d0,$12345678

	<ea>,Dn
		add.b	d1,d0
		add.w	a1,d0		; Anm.: nur add.w und add.l von Reg. Ax
		add.l	(a1),d0
		add.w	(a1)+,d0
		add.b	-(a1),d0
		add.l	$1234(a1),d0
		add.b	$12(a1,d2.w),d0
		add.w	$12(a1,d2.l),d0
		add.w	$12(a1,a2.w),d0
		add.b	$12(a1,a2.l),d0
		add.l	$1234.w,d0
		add.w	$12345678,d0

		add.w	label(pc),d0
		add.b	label(pc,d2.w),d0
		add.l	label(pc,d2.l),d0
		add.w	label(pc,a2.w),d0
		add.b	label(pc,a2.l),d0

***************************************************************** X N Z V C ***
ADDA     Binäre Addition im Register An   <ea>,An     -WL         - - - - -

	Wie ADD, aber speziell für Additionen in Adressregistern bestimmt,
	daher sind nur adda.w und adda.l möglich, nicht adda.b.
	Beachten Sie, dass arithmetische FLAGs von dieser Operation nicht
	betroffen sind, im Gegensatz zu ADD.

	Rat: Verwenden Sie IMMER die Erweiterung .L

	Bsp:

	<ea>,An
		adda.l	d1,a0
		adda.l	a1,a0
		adda.l	(a1),a0
		adda.l	(a1)+,a0
		adda.l	-(a1),a0
		adda.l	$1234(a1),a0
		adda.l	$12(a1,d2.w),a0
		adda.l	$12(a1,d2.l),a0
		adda.l	$12(a1,a2.w),a0
		adda.l	$12(a1,a2.l),a0
		adda.l	$1234.w,a0
		adda.l	$12345678,a0
		adda.l	label(pc),a0
		adda.l	label(pc,d2.w),a0
		adda.l	label(pc,d2.l),a0
		adda.l	label(pc,a2.w),a0
		adda.l	label(pc,a2.l),a0

		adda.l	#$1234,a1	; Hinweis: Wenn Sie eine Konstante 
							; zu einem Adressregister "ADDEN" müssen,
							; die Bildung ist nicht addi, sondern adda,
							; und es kann nicht .b sein.

	; Außerdem unterscheidet sich die Funktion von .w und .l von der allgemeinen:
	; Wenn man auf ADDRESS-Registern operiert, operiert man jedes Mal auf der
	; ganzen Adresse, d.h. auf das ganze LONGWORD. Also, wenn wir ADD.W #$12,a0 	
	; oder ADD.L #$12,a0 machen gibt es keine Unterschiede, denn in beiden 
	; Fällen haben wir $12 hinzugefügt, was eine positive Zahl ist die in einem
	; Wort enthalten sein kann. Aber man muss auf den Fall achten, wenn die
	; .w-Zahl die Sie hinzufügen möchten, größer als $7fff wird, denn dann wird
	; der Wert des Vorzeichenbits in die Bits von 16 bis 31 kopiert,
	; machen wir ein Beispiel:

		lea	$1000,a0
		ADDA.W	#$9200,a0	; addiere $FFFF9200 zu a0

	; In diesem Fall ist das Ergebnis $FFFFA200, eine wirklich schlechte Adresse!
	; Achten Sie also darauf, fast immer ADDA.L zu verwenden, da diese
	; Eigenschaft der 32-Bit-Erweiterung des Vorzeichens bei allen
	; ADDA-Adressierungen üblich ist. (sowie SUBA, CMPA, MOVEA)

***************************************************************** X N Z V C ***
ADDI     Addition unmittelbar		       #x,<ea>     BWL        * * * * *

	Addition eines #unmittelbar-Wertes, also einer Konstanten, zum Ziel.
	Die Flags verhalten sich wie bei der ADD-Anweisung:
	FLAG: Carry eund eXtend = 1 wenn es zu einem Übertrag kommt, andernfallls = 0
	Negativ = 1 wenn das Ergebnis negativ ist, Negativ = 0 wenn es positiv ist.
	oVerflow = 1 wenn das Ergebnis die Größe überschreitet .b, .w oder .l des ADD
	Zero = 1 wenn das Ergebnis Null ist

	Bsp:

	#x,<ea>
		addi.w	#$1234,		d1		; Die Ziele wurden für bessere
		addi.b	#$12,		(a1)	; Lesbarkeit mit Abständen angegeben 
		addi.l	#$12345678,	(a1)+	; 
		addi.w	#$1234,		-(a1)
		addi.b	#$12,		$1234(a1)
		addi.w	#$1234,		$12(a1,d2.w)
		addi.l	#$12345678,	$12(a1,d2.l)
		addi.w	#$1234,		$12(a1,a2.w)
		addi.b	#$12,		$12(a1,a2.l)
		addi.w	#$1234,		$1234.w
		addi.l	#$12345678,	$12345678

		adda.l	#$1234,a1	; Hinweis: Wenn Sie eine Konstante 
							; zu einem Adressregister "ADDEN" müssen,
							; lauetet die Anwisung nicht addi, sondern adda,
							; und es kann nicht .b sein.

***************************************************************** X N Z V C ***
ADDQ     Addition von #unmittelbar 3-bit  #<1-8>,<ea>   BWL       * * * * *

	Es bedeutet ADD Quick, also schnelle Addition einer Zahl von 1 bis 8,
	was genau wie ADDI funktioniert, deshalb ist es besser, immer 
	ADDQ anstelle von ADDI für die Summe der Zahlen von 1 bis 8 zu verwenden, 
	da es diesen speziellen Befehl gibt. Flags verhalten sich wie ADD:
	FLAG: Carry und eXtend = 1 wenn es zu einem Übertrag kommt, andernfallls = 0
	Negativ = 1 wenn das Ergebnis negativ ist, Negativ = 0 wenn es positiv ist.
	oVerflow = 1 wenn das Ergebnis die Größe überschreitet .b, .w oder .l des ADD
	Zero = 1 wenn das Ergebnis Null ist

	Bsp:

	#<1-8>,<ea>
		addq.w	#1,d1
		addq.w	#1,a1	; HINWEIS: Es ist nicht möglich, q.b auf Ax-Register
		addq.w	#1,(a1)
		addq.l	#1,(a1)+
		addq.l	#1,-(a1)
		addq.w	#1,$1234(a1)
		addq.b	#1,$12(a1,d2.w)
		addq.w	#1,$12(a1,d2.l)
		addq.w	#1,$12(a1,a2.w)
		addq.l	#1,$12(a1,a2.l)
		addq.w	#1,$1234.w
		addq.l	#1,$12345678

***************************************************************** X N Z V C ***
ADDX     ADD mit flag eXtend                Dy,Dx      BWL        * * * * *
                                         -(Ay),-(Ax)

	Diese Addition wird verwendet, um binäre Summen mit mehrfacher Genauigkeit
	zu bilden, 64-bit, um genau zu sein. Es unterscheidet sich von ADD dadurch,
	dass das FLAG X zum Ergebnis der Operation addiert wird. 
	Flags werden auf diese Weise beeinflusst:
	FLAG: Carry und eXtend = 1 wenn es zu einem Übertrag kommt, andernfallls = 0
	Zero = 1 wenn das Ergebnis Null ist, andernfallls bleibt es unverändert

	Bsp:

	Dy,Dx
		addx.b	d0,d1		; addx.b, addx.w, addx.l möglich 

	-(Ay),-(Ax)
		addx.b	-(a0),-(a1)	; addx.b, addx.w, addx.l möglich

	Nehmen wir ein Beispiel für eine 64 Bit-Summe: Wir wollen die Summe der
	64 bit-Hexadezimalwerte  $002e305a9cde0920 und $00001437a9204883 addieren.
	Wir können dies tun:

	move.l	#$002e305a,d0	;\ erster Wert in d0 und d1
	move.l	#$9cde0920,d1	;/
	move.l	#$00001437,d2	;\ zweiter Wert in d2 und d3
	move.l	#$a9204883,d3	;/
	add.l	d1,d3		; Summe der niedrigen Langwörter der 2 64-Bit-Zahlen
						; Jetzt steht der mögliche Übertrag im X-Flag
	addx.l	d0,d2		; Summe der hohen Langwörter, mit der Addition des
						; X-Flags, das den möglichen Übertrag der  Summe
						; der niedrigen Langwörter ist.

	Wir haben die 64-Bit-Summe in den Registern d3 (niedrige 32 Bits) und d2
	(hohe Bits). Wenn es die Summe die möglichen 64 Bit überschreitet (aber
	was will man da noch hinzufügen?) dann wird das Carry-FLAG gesetzt.

***************************************************************** X N Z V C ***
AND      AND logisch zwischen bits         Dn,<ea>     BWL        - * * 0 0
					   <ea>,Dn

	Die logische UND-Verknüpfung wird zwischen den einzelnen Bits der
	Quelle und denen des Ziels durchgeführt, und das Ergebnis wird im Ziel
	gespeichert. Hier ist eine bitweise UND-Tabelle:

	0 AND 0 = 0
	0 AND 1 = 0
	1 AND 0 = 0
	1 AND 1 = 1

	Daher besteht die Hauptverwendung darin, einige Bits zu "maskieren", zum
	Beispiel: ein AND.B #%00001111,d0 hat den Effekt, dass die 4 hohen Bits
	gelöscht werden und die 4 niedrigen Bits unverändert bleiben, so dass wir
	sagen können, dass wir nur die die niedrigen 4 Bits des Wertes in d0
	"ausgewählt" haben.
	FLAG: eXtend nicht verändert, oVerflow und Carry stets 0
	Negativ und Zero je nach Ergebnis des AND gesetzt oder zurückgesetzt

	Bsp:

	Dn,<ea>
		and.w	d0,d1		; Eine UND-Verwendung über ein direktes
		and.b	d0,(a1)		; Adressregisterist ist nicht möglich, zum
		and.w	d0,(a1)+	; Beispiel "and.w a0,d0" existiert nicht.
		and.l	d0,-(a1)
		and.w	d0,$1234(a1)
		and.b	d0,$12(a1,d2.w)
		and.b	d0,$12(a1,d2.l)
		and.w	d0,$12(a1,a2.w)
		and.l	d0,$12(a1,a2.l)
		and.w	d0,$1234.w
		and.b	d0,$12345678

	<ea>,Dn
		and.b	d1,d0		; wie oben, "and.w d0,a0" existiert nicht
		and.w	(a1),d0
		and.b	(a1)+,d0
		and.w	-(a1),d0
		and.b	$1234(a1),d0
		and.l	$12(a1,d2.w),d0
		and.b	$12(a1,d2.l),d0
		and.w	$12(a1,a2.w),d0
		and.b	$12(a1,a2.l),d0
		and.b	$1234.w,d0
		and.l	$12345678,d0
		and.l	label(pc),d0
		and.b	label(pc,d2.w),d0
		and.w	label(pc,d2.l),d0
		and.b	label(pc,a2.w),d0
		and.l	label(pc,a2.l),d0

***************************************************************** X N Z V C ***
ANDI     AND bitweise mit unmittelbar  #<data>,<ea>   BWL        - * * 0 0

	Wie die AND-Anweisung, aber speziell für #unmittelbare-Werte.
	FLAG: eXtend nicht verändert, oVerflow und Carry immer 0
	Negativ und Zero je nach Ergebnis des AND gesetzt oder zurückgesetzt 

	Bsp:

	#<data>,<ea>
		andi.b	#$12,		d1		; Die Ziele wurden für bessere
		andi.l	#$12345678,	(a1)	; Lesbarkeit mit Abständen angegeben 
		andi.b	#$12,		(a1)+	
		andi.w	#$1234,		-(a1)
		andi.l	#$12345678,	$1234(a1)
		andi.w	#$1234,		$12(a1,d2.w)
		andi.b	#$12,		$12(a1,d2.l)
		andi.w	#$1234,		$12(a1,a2.w)
		andi.l	#$12345678,	$12(a1,a2.l)
		andi.l	#$12345678,	$1234.w
		andi.b	#$12,		$12345678

		andi.b	#$12,ccr
		andi.w	#$1234,sr	; *** PRIVILEGIERTE INSTRUKTION ***

***************************************************************** X N Z V C ***
ASL      Arithmetic Shift Left            #<1-8>,Dy    BWL        * * * * *
                                            Dx,Dy
                                            <ea>

	Arithmetische Verschiebung nach links. Unter Verschiebung verstehen wir ein
	"Scrollen" von Bits, in diesem Fall nach links, zB: %0001 verschoben um 2:
	%0100 das heißt, die Bits, aus denen die Zahl besteht, werden nach links
	"verschoben"; im Fall der ASL werden die niedrigen Bits mit Nullen
	"aufgefüllt", während die "ausgehenden" Bits auf der linken Seite in die
	Carry- und Extend-FLAGs kopiert werden. Bei der #Direktadressierung ist die
	maximale Verschiebung #8, während im Dx, Dy-Format die ersten 6 Bits des
	Dx-Registers verwendet werden, daher kann die Verschiebung von 0 bis 63 ($3f)
	gehen. 
	Die FLAGs werden alle gemäß der Operation verändert; beim Carry	und im 
	eXtend wird das High-Bit "released" kopiert

				   Wert der nach links
					verschoben wird
					 ------------
	   Flag X/C <-- |<- <- <- <- | <--- 0 - eine Null kommt von rechts
 					 ------------

	; Adressen wie zB ASR,LSL,LSR,ROL,ROR,ROXL,ROXR
	
	Bsp:

	#<1-8>,Dy
		asl.b	#2,d1	; .b, .w und .l möglich, maximal asl.x #8,Dy

	Dx,Dy
		asl.b	d0,d1	; .b, .w und .l möglich, die maximale Verschiebung in
						; in diesem Fall ist 63 (die ersten 6 Bits 
						; des Datenregisters werden verwendet)
	<ea>
		asl.w	(a1)		; Hinweis: Das "asl <ea>" kann nur .w sein,
		asl.w	(a1)+		; es ist nicht möglich .b oder .l zu verwenden
		asl.w	-(a1)		; Hinweis2: Sie können auch die Form schreiben
		asl.w	$1234(a1)	;  "asl.w #1,(a1)", "asl.w #1,xxx", aber
		asl.w	$12(a1,d2.w)	; normalerweise schreiben Sie einfach
		asl.w	$12(a1,d2.l)	; "asl.w <ea>" für 1-Bit-Verschiebungen
		asl.w	$12(a1,a2.w)	
		asl.w	$12(a1,a2.l)
		asl.w	$1234.w
		asl.w	$12345678

***************************************************************** X N Z V C ***
ASR      Arithmetic Shift Right           #<1-8>,Dy    BWL        * * * * *
                                            Dx,Dy
                                            <ea>

	Arithmetische Verschiebung nach rechts. Mit Verschiebung verstehen wir ein
	"Scrollen" von Bits, in diesem Fall nach rechts, zB: %0100 verschoben um 2:
	das heißt, die Bits, aus denen die Zahl besteht, werden nach rechts
	"verschoben". Bei jeder Verschiebung wird das niedrige Bit des Zielregisters
	in die Carry- und eXtend-Bits kopiert, während das höchste Bit UNVERÄNDERT
	bleibt. (im Gegensatz zum LSR, also dem LOGICAL SHIFT nach rechts, bei dem
	das höchste Bit auf Null gesetzt wird).
	Daher behält der ASR im Gegensatz zum LSR das Vorzeichenbit bei. Bei der 
	#Direktadressierung beträgt die maximale Verschiebung #8, dh 3 Bits,
	während im Dx, Dy-Format die ersten 6 Bits des Dx-Registers verwendet werden,
	daher kann die Verschiebung von 0 bis 63 gehen ($3f)
    Die FLAGs werden alle gemäß der Operation verändert; im Carry und im
	eXtend wird das Low-Bit "ausgelassen" kopiert

			   Wert der nach rechts
				verschoben wird
				 ------------
		    /-->|-> -> -> ->| ---> Flag X/C
 		    |    ------------
		    |_____|
	Das hohe Bit wird repliziert, um das Vorzeichen beizubehalten

	; Adressen wie zB ASL,LSL,LSR,ROL,ROR,ROXL,ROXR

	Bsp:

	#<1-8>,Dy
		asr.b	#2,d1	; .b, .w und .l möglich, maximal asr.x #8,Dy

	Dx,Dy
		asr.b	d0,d1	; .b, .w und .l möglich, die maximale Verschiebung in
						; in diesem Fall ist 63 (die ersten 6 Bits 
						; des Datenregisters werden verwendet)

	<ea>asr.w (a1)		; nur .w möglich. Es ist äquivalent zu asr.w #1,<ea>
		asr.w	(a1)+	; lesen Sie den Hinweis zur ASL-Anweisung
		asr.w	-(a1)
		asr.w	$1234(a1)
		asr.w	$12(a1,d2.w)
		asr.w	$12(a1,d2.l)
		asr.w	$12(a1,a2.w)
		asr.w	$12(a1,a2.l)
		asr.w	$1234.w
		asr.w	$12345678

***************************************************************** X N Z V C ***
Bcc      Conditional Branch            Bcc.S <label>   BW-        - - - - -
                                       Bcc.W <label>

	Test von Bedingungscodes und Verzweigungen. Mit cc meinen wir einen der
	folgenden: hi,ls,cc,cs,ne,eq,vc,vs,pl,mi,ge,lt,gt,le,ra.
	Sie können nur .s (d.h. .b) oder .w sein, nicht .l.
	FLAG: Es werden keine Flags geändert
	Sie können nach einem CMP, einem TST oder sogar nach einem ADD usw.
	verwendet werden. In der Praxis wird diese Anweisung verwendet, um Sprünge 
	zu bestimmten Labels zu machen wenn und nur wenn sich die Flags in einer
	bestimmten Position befinden. Die einzige ist die BRA, was Branch Always
	bedeutet, also ALWAYS JUMP, was jedes Mal springt.
	In anderen Fällen hängt es von den Bedingungscodes ab. In der Zwischenzeit, 
	lassen Sie uns die möglichen Bccs sehen:

	Bsp:	(Betrachten Sie die Situation nach a CMP.x OP1,OP2)

		bhi.s	label	; > (Wenn OP2 größer als OP1 ist) (OP=Operand)
				; (HIgher ) - OP2 > OP1, ohne Vorzeichen
				; * wenn Carry=0 und Z=0
	
		bgt.w	label	; > (Wenn OP2 größer als OP1 ist) mit Vorzeichen
				; (Greather Than) OP2 > OP1, mit Vorzeichen
				; * (N and V or not N and not V) and not Z

		bcc.s	label	; >= (auch genannt BHS) - * Wenn Carry = 0
				; (Carry bit Clear) - OP2 >= OP1, ohne Vorzeichen

		bge.s	label	; >= (Wenn OP2 größer oder gleich OP1 ist)
				; (Greather than or Equal) OP2>=OP1, mit Vorzeichen
				; * wenn N=1 und V=1, oder N=0 und V=0

		beq.s	label	; = (Wenn Z = 1), (null oder gleiche Operanden)
				; (Equal) OP2 = OP1, für Zahl mit oder ohne Vorzeichen

		bne.w	label	; >< (Wenn Z = 0), (Wenn OP1 anders als OP2 ist)
				; (Not Equal), für Zahlen mit oder ohne Vorzeichen

		bls.w	label	; <= (Wenn OP2 kleiner oder gleich OP1 ist)
				; für Zahl ohne Vorzeichen (Low or Same)
				; * Wenn Carry = 1 oder Z = 1

		ble.w	label	; < (Wenn OP2 kleiner oder gleich OP1 ist) für
				; Zahlen mit Vorzeichen
				; * N and not V or not N and V or Z

		bcs.w	label	; < (auch genannt BLO) - * Wenn Carry = 1
				; (Carry bit Set) - OP2 < OP1, ohne Vorzeichen

		blt.w	label	; < (Wenn OP2 kleiner als OP1 ist)
				; (Less Than), für Zahlen mit Vorzeichen

		bpl.w	label	; + (Wenn Negativ = 0), d.h., wenn das Ergebnis
				; positiv ist (PLus)

		bmi.s	label	; - (Wenn Negativ = 1), d.h., wenn das Ergebnis
				; negativ ist (Minus)

		bvc.w	label	; Wenn Bit Overflow V=0 ist (für Zahlen
				; mit Vorzeichen) - NO OVERFLOW (V-bit Clear)

		bvs.s	label	; Wenn Bit Overflow V=1 ist (für Zahlen
				; mit Vorzeichen) - OVERFLOW (V-bit gesetzt)

		bra.s	label	; immer, springt immer! Wie JMP


Die Verwendungsmöglichkeiten dieser bedingten Sprünge sind unendlich, zum
Beispiel mit einem:

		TST.B	d0
		BEQ.S	Label

	Es kommt vor, dass wenn d0=0 ist, dann wird das Z (Null)-Flag gesetzt
	beq (Z=1, null gleiche Operanden) springt zu Label. Oder:

		CMP.W	d0,d1
		bhi.s	label	; > (wenn OP2 größer als OP1 ist)		

	Wenn in diesem Fall d1 größer als d0 ist, springt der BEQ zum Label.
	Beachten Sie, dass der CMP das Ziel (d1) mit der Quelle vergleicht,
	und nicht umgekehrt!

	Lassen Sie uns einige Fälle mit einem ADD machen:

	ADD.W	d0,d1
	BCS.s	label	; Wenn es einen Übertrag gibt, gehe zum Label (es bedeutet, 
	; das wir haben den Wert, den das Wort enthalten kann, überschritten haben)

	ADD.L	d3,d4
	BEQ.s	label	; wenn das Ergebnis Null ist, zum Label springen

	ADD.B	d1,d2
	BVS.s	Label	; Overflow! die Summe zweier Zahlen mit gleichen 
	; Vorzeichen, ob positiv oder negativ, ist größer als der Bereich der in 
	; einem Byte im 2er-Komplement möglich ist (-127 .. + 128).

	Sehen wir uns nun an, wie man die Bccs nach CMP.x OP1,OP2 verwendet	
	
		beq.s	label	; OP2 =  OP1 - für alle Zahlen
		bne.w	label	; OP2 >< OP1 - für alle Zahlen
		bhi.s	label	; OP2 >  OP1 - ohne Vorzeichen
		bgt.w	label	; OP2 >  OP1 - mit Vorzeichen
		bcc.s	label	; OP2 >= OP1 - ohne Vorzeichen, auch genannt *"BHS"*
		bge.s	label	; OP2 >= OP1 - mit Vorzeichen
		bls.w	label	; OP2 <= OP1 - ohne Vorzeichen
		ble.w	label	; OP2 <= OP1 - mit Vorzeichen
		bcs.w	label	; OP2 <  OP1 - ohne Vorzeichen, auch genannt *"BLO"*
		blt.w	label	; OP2 <  OP1 - mit Vorzeichen

	Und jetzt, wie man sie nach einem TST.x OP1 verwendet

		beq.s	label	; OP1 =  0 - für alle Zahlen
		bne.w	label	; OP1 >< 0 - für alle Zahlen
		bgt.w	label	; OP1 >  0 - mit Vorzeichen
		bpl.s	label	; OP1 >= 0 - mit Vorzeichen (oder BGE)
		ble.w	label	; OP1 <= 0 - mit Vorzeichen
		bmi.w	label	; OP1 <  0 - mit Vorzeichen (oder BLT)

	Letztere gelten beispielsweise auch nach einem ADD.x oder einem SUB.x

		ADD.W	d1,d2
		beq.s	ErgebnisZero
		bpl.s	ErgebnisGroesseralsZero
		bmi.s	ErgebnisKleineralsZero

	Dies spart ein mögliches TST.w d2 nach dem ADD.

***************************************************************** X N Z V C ***
BCHG     Test a Bit and CHanGe             Dn,<ea>     B-L        - - * - -
                                        #<data>,<ea>

	Diese Operation ändert ein einzelnes spezifiziertes Bit, mit "ändern" meinen
	wir, wenn es 0 war, wird es auf 1 gesetzt, wenn es 1 war, wird es auf 0
	gesetzt. Dazu wird es zuerst getestet, indem das Z-Flag gesetzt wird, und
	danach wird es mit einem NOT "geändert".
	FLAG: Nur das Z wird geändert
	Wenn der Zieloperand ein Datenregister ist, lautet die Anweisung immer .L, 
	und es ist möglich, ein Bit von 0 bis 31 mit dem  Quelloperanden anzugeben.
	Wenn der Zieloperand ein Speicherbyte ist, dann ist die Anweisung immer .B
	und mit dem Quellenoperanden kann ein Bit von 0 bis 7 angegeben werden.

	; Adressierung wie BSET, BCLR; der BTST hat noch ein paar mehr (PC)

	Bsp:

	Dn,<ea>
		bchg.l	d1,d2		; nur .L bei Betrieb mit 
							; Datenregister. In diesem Fall 
							; können Sie ein Bit zwischen 0 und 31
							; angeben

		bchg.b	d1,(a1)		; nur .B bei Betrieb an
		bchg.b	d1,(a1)+	; Adressen. In diesem Fall
		bchg.b	d1,-(a1)	; können Sie ein Bit zwischen 0 und 7
		bchg.b	d1,$1234(a1)	; angeben
		bchg.b	d1,$12(a1,d2.w)
		bchg.b	d1,$12(a1,d2.l)
		bchg.b	d1,$12(a1,a2.w)
		bchg.b	d1,$12(a1,a2.l)
		bchg.b	d1,$1234.w
		bchg.b	d1,$12345678

	#<data>,<ea>
		bchg.l	#1,d2		; nur .L bei Betrieb mit 
							; Datenregister. In diesem Fall 
							; können Sie ein Bit zwischen 0 und 31
							; angeben

		bchg.b	#1,(a1)		; nur .B bei Betrieb an
		bchg.b	#1,(a1)+	; Adressen. In diesem Fall
		bchg.b	#1,-(a1)	; können Sie ein Bit zwischen 0 und 7
		bchg.b	#1,$1234(a1)	; angeben. Beachten Sie jedoch,
		bchg.b	#1,$12(a1,d2.w)	; dass der ASMONE fälschlicherweise
		bchg.b	#1,$12(a1,d2.l)	; auch Werte höher als 7 assembliert, in diesem
		bchg.b	#1,$12(a1,a2.w)	; Fall das Bit, auf dem operiert werden soll, 
		bchg.b	#1,$12(a1,a2.l)	; zum Beispiel, wenn #13, #13-8 = 5.
		bchg.b	#1,$1234.w
		bchg.b	#1,$12345678

	Hinweis:
		leider assembliert ASMONE auch bchg auch mit Werten größer als 7
		zusammen, (zum Beispiel würde das DevPac einen Fehler ausgeben).
		GEBEN Sie NIEMALS für bchg.b NIEMALS Werte höher als 7 an!
		Wenn jedoch ein Listing diesen Wert enthält, wird die Anweisung
		trotzdem ausgeführt, und das Bit wird durch Subtrahieren von 8 "berechnet",
		oder wenn die Zahl größer als 16 ist, durch Subtrahieren von 2 * 8, 3 * 8
		etc. Hier ist zum Beispiel eine Liste von Äquivalenten
		des bchg.b #1,xxx, natürlich nur zur Information:

		bchg.b	#1,<ea>
		bchg.b	#1+8,<ea>		; d.h. #9
		bchg.b	#1+8*2,<ea>		; d.h. #17
		bchg.b	#1+8*3,<ea>		; d.h. #25
		bchg.b	#1+8*4,<ea>		; d.h. #33
		bchg.b	#1+8*5,<ea>		; d.h. #41
		...
		bchg.b	#1+8*30,<ea>	; d.h. #241
		bchg.b	#1+8*31,<ea>	; d.h. #249 (maximum 255)

		Der ASMONE (und 68000?) Fehler ist vorhanden für BCHG,BSET,BCLR,BTST
		Anweisungen 

***************************************************************** X N Z V C ***
BCLR     Test a Bit and CLeaR              Dn,<ea>     B-L        - - * - -
                                        #<data>,<ea>

	Dieser Befehl setzt das angegebene Bit zurück.
	Wenn der Zieloperand ein Datenregister ist, lautet die Anweisung
	immer .L und es ist möglich, ein Bit von 0 bis 31 mit dem 
	Quelloperanden anzugeben.
	Wenn der Zieloperand ein Speicherbyte ist, lautet die Anweisung
    immer .B und mit dem Quellenoperanden kann ein Bit von 0 bis 7
	angegeben werden.

	; Adressierung wie BCHG, BSET; der BTST hat noch ein paar mehr (PC)

	Bsp:

	Dn,<ea>
		bclr.l	d1,d2		; nur .L bei Betrieb mit 
							; Datenregister. In diesem Fall 
							; können Sie ein Bit zwischen 0 und 31
							; angeben

		bclr.b	d1,(a1)		; nur .B bei Betrieb an
		bclr.b	d1,(a1)+	; Adressen. In diesem Fall
		bclr.b	d1,-(a1)	; können Sie ein Bit zwischen 0 und 7
		bclr.b	d1,$1234(a1)	; angeben
		bclr.b	d1,$12(a1,d2.w)
		bclr.b	d1,$12(a1,d2.l)
		bclr.b	d1,$12(a1,a2.w)
		bclr.b	d1,$12(a1,a2.l)
		bclr.b	d1,$1234.w
		bclr.b	d1,$12345678

	#<data>,<ea>
		bclr.l	#1,d2		; nur .L bei Betrieb mit 
							; Datenregister. In diesem Fall 
							; können Sie ein Bit zwischen 0 und 31
							; angeben

		bclr.b	#1,(a1)		; nur .B bei Betrieb an
		bclr.b	#1,(a1)+	; Adressen. In diesem Fall
		bclr.b	#1,-(a1)	; können Sie ein Bit zwischen 0 und 7
		bclr.b	#1,$1234(a1)	; angeben
		bclr.b	#1,$12(a1,d2.w)
		bclr.b	#1,$12(a1,d2.l)
		bclr.b	#1,$12(a1,a2.w)
		bclr.b	#1,$12(a1,a2.l)
		bclr.b	#1,$1234.w
		bclr.b	#1,$12345678

	Hinweis:
		leider assembliert ASMONE auch bclr mit höheren Werten als 7, 
		(zum Beispiel würde der DevPac einen Fehler ausgeben).
		GEBEN Sie NIEMALS für bclr.b Werte höher als 7 an!
		Weitere Informationen finden Sie in der Anmerkung zum BCHG

***************************************************************** X N Z V C ***
BSET     Test a Bit and SET                Dn,<ea>     B-L        - - * - -
                                        #<data>,<ea>

	Dieser Befehl SETZT das angegebene Bit auf 1.
	Wenn der Zieloperand ein Datenregister ist, lautet die Anweisung
	immer .Lund es ist möglich, ein Bit von 0 bis 31 mit dem 
	Quelloperanden anzugeben.
	Wenn der Zieloperand ein Speicherbyte ist, lautet die Anweisung
	immer .B und mit dem Quelloperanden kann ein Bit von 0 bis 7 angegeben
	werden.


	; Adressierung wie BCHG, BCLR; der BTST hat noch ein paar mehr (PC)

	Bsp:

	Dn,<ea>
		bset.l	d1,d2		; nur .L bei Betrieb mit
							; Datenregister. Sie können ein Bit 
							; zwischen 0 und 31 angeben

		bset.b	d1,(a1)		; nur .B bei Betrieb an
		bset.b	d1,(a1)+	; Adressen. In diesem Fall 
		bset.b	d1,-(a1)	; können sie ein Bit zwischen
		bset.b	d1,$1234(a1)	; 0 und 7 angeben
		bset.b	d1,$12(a1,d2.w)
		bset.b	d1,$12(a1,d2.l)
		bset.b	d1,$12(a1,a2.w)
		bset.b	d1,$12(a1,a2.l)
		bset.b	d1,$1234.w
		bset.b	d1,$12345678

	#<data>,<ea>
		bset.l	#1,d2		; nur .L bei Betrieb mit
							; Datenregister. Sie können ein Bit 
							; zwischen 0 und 31 angeben

		bset.b	#1,(a1)		; nur .B bei Betrieb an
		bset.b	#1,(a1)+	; Adressen. In diesem Fall 
		bset.b	#1,-(a1)	; können sie ein Bit zwischen
		bset.b	#1,$1234(a1)	; 0 und 7 angeben
		bset.b	#1,$12(a1,d2.w)
		bset.b	#1,$12(a1,d2.l)
		bset.b	#1,$12(a1,a2.w)
		bset.b	#1,$12(a1,a2.l)
		bset.b	#1,$1234.w
		bset.b	#1,$12345678

	Hinweis:
		leider assembliert ASMONE auch bset mit höheren Werten als 7, 
		(zum Beispiel würde der DevPac einen Fehler ausgeben).
		GEBEN Sie NIEMALS Werte höher als 7 für bset.b an!
		Weitere Informationen finden Sie im Hinweis zum BCHG

***************************************************************** X N Z V C ***
BTST     Bit TeST                          Dn,<ea>     B-L        - - * - -
                                       #<data>,<ea>

	Die Anweisung TESTET ob das angegebene Bit ZERO ist.
	Wenn der Zieloperand ein Datenregister ist, dann ist die Anweisung
	immer .L und mit dem Quellenoperanden kann ein Bit von 0 bis 31
	angegeben werden.
	Wenn der Zieloperand ein Speicherbyte ist, dann ist die Anweisung
    immer .B und mit dem Quellenoperanden kann ein Bit von 0 bis 7
	angegeben werden.

	; Adressierung  wie BCHG, BSET, BCLR, zusätzlich verwaltet es das PC
	; Register

	Bsp:

	Dn,<ea>
		btst.l	d1,d2		; nur .L bei Betrieb mit 
							; Datenregister. In diesem Fall 
							; können Sie ein Bit zwischen 0 und 31
							; angeben

		btst.b	d1,(a1)		; nur .B bei Betrieb an
		btst.b	d1,(a1)+	; Adressen. In diesem Fall 
		btst.b	d1,-(a1)	; können sie ein Bit zwischen
		btst.b	d1,$1234(a1)	; 0 und 7 angeben
		btst.b	d1,$12(a1,d2.w)
		btst.b	d1,$12(a1,d2.l)
		btst.b	d1,$12(a1,a2.w)
		btst.b	d1,$12(a1,a2.l)
		btst.b	d1,$1234.w
		btst.b	d1,$12345678

		btst.b	d1,label(pc)		; das BTST kann auch die
		btst.b	d1,label(pc,d2.w)	; Adressierung relativ zum
		btst.b	d1,label(pc,d2.l)	; PC als Ziel verwendeten !!!
		btst.b	d1,label(pc,a2.w)
		btst.b	d1,label(pc,a2.l)

	#<data>,<ea>
		btst.l	#1,d2		; nur .L bei Betrieb mit 
							; Datenregister. In diesem Fall 
							; können Sie ein Bit zwischen 0 und 31
							; angeben

		btst.b	#1,(a1)		; nur .B bei Betrieb an
		btst.b	#1,(a1)+	; Adressen. In diesem Fall 
		btst.b	#1,-(a1)	; können sie ein Bit zwischen
		btst.b	#1,$1234(a1)	; 0 und 7 angeben
		btst.b	#1,$12(a1,d2.w)
		btst.b	#1,$12(a1,d2.l)
		btst.b	#1,$12(a1,a2.w)
		btst.b	#1,$12(a1,a2.l)
		btst.b	#1,$1234.w
		btst.b	#1,$12345678

		btst.b	#1,label(pc)		; das BTST kann auch die
		btst.b	#1,label(pc,d2.w)	; dAdressierung relativ zum
		btst.b	#1,label(pc,d2.l)	; PC als Ziel verwendeten !!!
		btst.b	#1,label(pc,a2.w)
		btst.b	#1,label(pc,a2.l)

	Hinweis:
		leider assembliert ASMONE auch btst mit höheren Werten als 7, 
		(zum Beispiel würde der DevPac einen Fehler ausgeben).
		GEBEN Sie NIEMALS Werte höher als 7 für btst.b an!
		Weitere Informationen finden Sie im Hinweis zum BCHG

***************************************************************** X N Z V C ***
BSR      Branch to SubRoutine          BSR.S <label>   BW-        - - - - -
                                        BSR.W <label>

	Diese Anweisung springt zum Label wie JSR und kehrt zurück, wenn es
	das Ende der Unterroutine gefunden hat (das rts).
	FLAG: Es werden keine Flags geändert

		bsr.s	label	; .s (d.h. .b) möglich oder .w (NICHT .L!)

***************************************************************** X N Z V C ***
CHK      CHecK Dn Against Bounds           <ea>,Dn     -W-        - * U U U

	Diese Anweisung prüft, ob der im Zieldatenregister enthaltene 16-Bit-Wert
	kleiner Null oder größer als ein bestimmter Quelloperand ist.
	Liegt der Wert innerhalb der Grenzen, geht man zur nächsten 
	Anweisung weiter, andernfalls wird eine Exception ausgelöst, aber diese 
	Anweisung wird jedoch NIEMALS verwendet und es wird einfach alles an GURU  
	MEDITATION gesendet... sie wird nicht gebraucht, man benutzt sie nicht.

***************************************************************** X N Z V C ***
CLR      CLeaR (zurücksetzen)              <ea>       BWL        - 0 1 0 0

	Diese Anweisung löscht das Ziel, wie z. B.  move.x #0,<ea>
	FLAG: eXtend nicht verändert, Zero = 1, die anderen zurückgesetzt

	Bsp:

	<ea>
		clr.b	d1	; .b, .w und .l möglich 
		clr.w	(a1)
		clr.b	(a1)+
		clr.w	-(a1)
		clr.l	$1234(a1)
		clr.w	$12(a1,d2.w)
		clr.b	$12(a1,d2.l)
		clr.w	$12(a1,a2.w)
		clr.b	$12(a1,a2.l)
		clr.w	$1234.w
		clr.l	$12345678

***************************************************************** X N Z V C ***
CMP      CoMPare (vergleichen)             <ea>,Dn     BWL        - * * * *

	Vergleichen Sie durch Subtraktion die Quelle mit einem Datenregister.
	Achten Sie darauf, dass in Fällen, in denen Sie zwei Operanden 
	mit BMI, BPL, BHI usw. überprüfen möchten, welcher größer ist, was der
	ZielOperand, OP2 ist, welcher mit der Quelle (OP1) verglichen wird.
	Sie können diese Tatsache besser bei der Bcc-Anweisung sehen
	FLAG: eXtend nicht verändert, die anderen entsprechend dem Vergleich.

	Bsp:

	<ea>,Dn
		cmp.b	d1,d0
		cmp.w	a1,d0		; Hinweis: cmp.b ist mit Ax nicht möglich
		cmp.w	(a1),d0
		cmp.b	(a1)+,d0
		cmp.w	-(a1),d0
		cmp.l	$1234(a1),d0
		cmp.w	$12(a1,d2.w),d0
		cmp.l	$12(a1,d2.l),d0
		cmp.w	$12(a1,a2.w),d0
		cmp.l	$12(a1,a2.l),d0
		cmp.w	$1234.w,d0
		cmp.b	$12345678,d0
		cmp.w	label(pc),d0
		cmp.l	label(pc,d2.w),d0
		cmp.w	label(pc,d2.l),d0
		cmp.b	label(pc,a2.w),d0
		cmp.w	label(pc,a2.l),d0

***************************************************************** X N Z V C ***
CMPA     CoMPare Address                   <ea>,An     -WL        - * * * *

	Diese Anweisung funktioniert wie der CMP, ist aber für Vergleiche
	mit Adressregistern, bei denen der CMP nicht möglich ist.
	Die Adressen müssen als vorzeichenlose Zahlen betrachtet werden, daher ist
	es notwendig, die Bccs für solche Zahlen zu verwenden:

	beq.s	label	; OP2 =  OP1
	bne.w	label	; OP2 >< OP1
	bhi.s	label	; OP2 >  OP1
	bcc.s	label	; OP2 >= OP1 - auch genannt *"BHS"*
	bls.w	label	; OP2 <= OP1
	bcs.w	label	; OP2 <  OP1 - auch genannt *"BLO"*

	FLAG: eXtend nicht verändert, die anderen abhängig vom Vergleich.

	Tipp: Verwenden Sie IMMER die Erweiterung .L

	Bsp:

	<ea>,An
		cmpa.l	d1,a0		; Hinweis: cmpa.b ist nicht möglich !!
		cmpa.l	a1,a0
		cmpa.l	(a1),a0
		cmpa.l	(a1)+,a0
		cmpa.l	-(a1),a0
		cmpa.l	$1234(a1),a0
		cmpa.l	$12(a1,d2.w),a0
		cmpa.l	$12(a1,d2.l),a0
		cmpa.l	$12(a1,a2.w),a0
		cmpa.l	$12(a1,a2.l),a0
		cmpa.l	$1234.w,a0
		cmpa.l	$12345678,a0
		cmpa.l	label(pc),a0
		cmpa.l	label(pc,d2.w),a0
		cmpa.l	label(pc,d2.l),a0
		cmpa.l	label(pc,a2.w),a0
		cmpa.l	label(pc,a2.l),a0

		cmpa.l	#$1234,a1	; Hinweis: zum Vergleich eines #unmittelbaren mit
					; einem Ax-Adressregister, verwenden Sie
					; die cmpa-Anweisung, nicht cmpi.
					
	Beachten Sie, dass bei einem CMPA.W xxxx,Ax 32 Bit verglichen werden
	und nicht 16, wie es für .w scheinen mag.
	Der 16-Bit-Quelloperand wird um das Vorzeichen auf 32 Bit erweitert, d.h.
	der Wert des Vorzeichenbits 15 wird in die Bits 16 bis 31 kopiert.
	Zum Beispiel:

		lea	$1234,a0
		CMPA.W	#$1234,a0	; cmp $00001234,a0
		beq.s	SaltaLabel

	In diesem Fall ist die Zahl positiv, also im Zweierkomplement ist das
	hohe Bit Null und alle anderen (von 16 bis 31) werden zurückgesetzt,
	und wir springen zu SaltaLabel, da es dasselbe ist.
	In diesem Fall stattdessen:

		lea	$9200,a0
		CMPA.W	#$9200,a0	; cmp $FFFF9200,a0, weil $9200 klar
							; VORZEICHEN .w negativ ist (-28672)
		beq.s	SaltaLabel

	In diesem Fall wird $9200 zu einem Langwort erweitert und da $9200 negativ 
	in vorzeichenbehafteter Notation ist, werden die hohen Bits mit 1 gefüllt,
	also vergleichen wir zwischen $FFFF9200 und $9200, und springen nicht zu
	SaltaLabel. Hätten wir stattdessen ein CMPA.L #$9200,0 verwendet, hätten
	wir den Sprung bekommen.
	Wie Sie sehen, gibt es bei Zahlen unter $7fff keine Unterschiede zwischen
	CMPA.L und CMPA.W, während es das für höhere Zahlen gibt. ACHTUNG!

***************************************************************** X N Z V C ***
CMPI     CoMPare Immediate              #<data>,<ea>   BWL        - * * * *

	Diese Anweisung ist wie die CMP-Anweisung, ist aber dem Vergleich 
	einer #unmittelbaren (eine konstanten Zahl) mit dem Ziel gewidmet.
	Dies geschieht durch Subtraktion des #Immediate-Operanden vom Ziel,
	das Ergebnis dieser Operation ändert die Flags entsprechend.
	FLAG: eXtend nicht verändert, die anderen nach dem Vergleich.

	Bsp:

	<data>,<ea>
		cmpi.w	#$1234,		d1		; Die Ziele wurden für bessere
		cmpi.l	#$12345678,	(a1)	; Lesbarkeit mit Abständen angegeben 
		cmpi.b	#$12,		(a1)+	
		cmpi.w	#$1234,		-(a1)
		cmpi.l	#$12345678,	$1234(a1)
		cmpi.b	#$12,		$12(a1,d2.w)
		cmpi.w	#$1234,		$12(a1,d2.l)
		cmpi.b	#$12,		$12(a1,a2.w)
		cmpi.l	#$12345678,	$12(a1,a2.l)
		cmpi.w	#$1234,		$1234.w
		cmpi.b	#$12,		$12345678

		cmpa.w	#$1234,a1	; Hinweis: Zum Vergleich eines #unmittelbare 
							; mit einem Ax-Adressregister, verwenden Siw
							; die cmpa-Anweisung, nicht cmpi.

***************************************************************** X N Z V C ***
CMPM     CoMPare Memory                  (Ay)+,(Ax)+   BWL        - * * * *

	Dieser Befehl wird verwendet, um Speicherplätze zu vergleichen.
	FLAG: eXtend wird nicht verändert, die anderen werden entsprechend der
	Operation verändert

	Bsp:

	(Ay)+,(Ax)+
		cmpm.w	(a0)+,(a1)+	; cmpm.b, cmpm.w und cmpm.l möglich 

	Es kann verwendet werden, um eine Routine wie diese zu ersetzen:

	move.w	(a0)+,d0
	cmp.w	(a1)+,d0

***************************************************************** X N Z V C ***
DBcc     Looping Instruction          DBcc Dn,<label>  -W-        - - - - -

	Diese Anweisung dient im Wesentlichen dazu, LOOPs zu erstellen, d.h.
	Zyklen, bei denen die Anzahl der Zyklen durch ein Daten-Register geregelt
	wird, das bei jedem Zyklus verringert wird.
	Die Anweisung erlaubt die Verwendung aller cc als Bcc, aber fast immer
	wird es in der Form DBRA (auch DBF genannt) verwendet, wodurch die Schleife
	jedes Mal ausgeführt wird, ohne die Bedingungscodes zu prüfen.
	Um komplizierte Schleifen zu machen, können Sie immer noch alle CCs verwenden.
	Beachten Sie, dass im Gegensatz zu Bcc der DBcc zum	Label springt nur
	wenn die Bedingung FALSE ist!
	FLAG: Es werden keine Flags geändert
	
	Bsp:	(Siehe Bcc für die Beschreibung des cc)

	DBcc Dn,<label>
		dbra	d0,label	; auch genannt DBF, bedeutet zu
							; einem Label zu springen jedes Mal, bis der
							; Zähler d0 noch nicht am Ende ist

		dbhi	d0,label ; > für Zahlen ohne Vorzeichen
		dbgt	d0,label ; > für Zahlen mit Vorzeichen
		dbcc	d0,label ; >= für Zahlen ohne Vorzeichen - auch DBHS genannt 
		dbge	d0,label ; >= für Zahlen mit Vorzeichen
		dbeq	d0,label ; = für alle Zahlen
		dbne	d0,label ; >< für alle Zahlen
		dbls	d0,label ; <= für Zahlen ohne Vorzeichen
		dble	d0,label ; <= für Zahlen mit Vorzeichen
		dbcs	d0,label ; < für Zahlen ohne Vorzeichen - auch DBLO genannt 
		dblt	d0,label ; < für Zahlen mit Vorzeichen
		dbpl	d0,label ; wenn Negativ = 0 (PLus)
		dbmi	d0,label ; wenn Negativ = 1, (Minus) für Zahlen mit Vorzeichen
		dbvc	d0,label ; V=0, kein OVERFLOW
		dbvs	d0,label ; V=1 OVERFLOW

***************************************************************** X N Z V C ***
DIVS     DIVide Signed                     <ea>,Dn     -W-        - * * * 0

	Binäre Division mit Vorzeichen. Eine der langsamsten Anweisungen.
	Der Zieloperand, der 32-Bit-Dividend, wird durch die 16-Bit-Quelle
	(Teiler) dividiert, genau wie bei DIVU.
	Es ist eine Division von ganzen Zahlen, da es keine Kommas gibt.
	Wenn Sie zum Beispiel 5:2 rechnen, ist das Ergebnis 2, der Rest ist 1.
	Das im Zieldatenregister abgelegte Ergebnis ist ein longword aufgeteilt
	in 2 Wörter, das den Quotienten und den Rest enthält.
	Der Quotient wird in den unteren 16 Bits gespeichert (0-15).
	In den höheren 16 Bits (16-31) wird der Rest der Division gespeichert,
	dem das Vorzeichen der Dividende zugewiesen wird.
	Der Unterschied zu DIVU besteht nur darin, dass es als binäre
	Arithmetik mit Vorzeichen (2er-Komplement) beaachtet wird.
	Bei einer Division durch Null geht der Computer zum GURU, und zwar wird
	eine Vektorausnahme an Position $14 ausgeführt.
	FLAG: eXtend wird dabei nicht verändert, der Carry zurückgesetzt
	die anderen werden entsprechend dem Quotienten verändert.
	Beachten Sie, wenn das Ergebnis zu groß ist, um im Low-Word des Registers
	enthalten zu sein (wenn der Quotient die Grenze +32767 -32768 der 
	vorzeichenbehafteten Zahlen überschreitet), wird das Overflow-Flag gesetzt.
	Daher müssen Sie es nach der Teilung überprüfen, um sicherzugehen, dass das
	Ergebnis korrekt ist, denn wenn es nicht exakt ist, werden die Operanden nicht
	geändert.

	Bsp:

	<ea>,Dn
		divs.w	d1,d0		; nur .w möglich 
		divs.w	(a1),d0
		divs.w	(a1)+,d0
		divs.w	-(a1),d0
		divs.w	$1234(a1),d0
		divs.w	$12(a1,d2.w),d0
		divs.w	$12(a1,d2.l),d0
		divs.w	$12(a1,a2.w),d0
		divs.w	$12(a1,a2.l),d0
		divs.w	$1234.w,d0
		divs.w	$12345678,d0
		divs.w	label(pc),d0
		divs.w	label(pc,d2.w),d0
		divs.w	label(pc,d2.l),d0
		divs.w	label(pc,a2.w),d0
		divs.w	label(pc,a2.l),d0
		divs.w	#$1234,d0

	Hinweis: Es ist nicht möglich, ein Adressregister An als Operanden zu verwenden

	Versuchen wir eine Division:

	moveq	#-33,d0	; 32-Bit-Zahl mit VORZEICHEN zum Dividieren
	moveq	#5,d1	; Divisor
	divs	d1,d0	; d0 teilen in d1-Teile, d.h. -33/5

	das Ergebnis in d0 ist $FFFDFFFA, wobei $FFFD = -3 und $FFFA = -6 ist,
	Tatsächlich ist -33 geteilt durch 5 -6, Rest -3. Der Rest ist negativ, weil
	das Vorzeichen des Rests immer das des Dividenden ist.

***************************************************************** X N Z V C ***
DIVU     DIVide Unsigned                   <ea>,Dn     -W-        - * * * 0

	Binäre Division ohne Vorzeichen. Sie ist eine der leistungsfähigsten, aber
	auch eine der langsamsten Anweisungen. Führt eine binäre Division zwischen
	einem 32-Bit-Zieloperanden (Dividend) und einem 16-Bit Quelloperanden (Teiler) 
	durch. Die Division erfolgt zwischen Zahlen ohne Vorzeichen und ist eine
	Division von Ganzzahlen, da kein Komma vorhanden ist.
	Wenn Sie zum Beispiel 5:2 rechnen, ist das Ergebnis 2, der Rest ist 1.
	Das Ergebnis der Division mit Quotient und Rest wird im Zieldatenregister
	gespeichert.
	Der Quotient wird in den unteren 16 Bits (0-15) gespeichert. 
	In den höheren 16 Bits (16-31) wird der Rest der Division gespeichert.
	Bei einer Division durch Null geht der Computer zum GURU, und zwar wird
	eine Vektorausnahme an Position $14 ausgeführt.
	FLAG: eXtend wird nicht verändert, der Carry wird zurückgesetzt
	die anderen werden entsprechend des Quotienten verändert.
	Beachten Sie, wenn das Ergebnis zu groß ist, um im Low-Word des
	Registers enthalten zu sein wird das Overflow-Flag gesetzt.
	Daher ist es notwendig, es nach der Teilung zu überprüfen, um sicherzugehen
	dass das Ergebnis stimmt. Wenn es nicht korrekt ist, werden die Operanden nicht
	verändert und nur das oVerflow-Flag wird gesetzt.

	Bsp:

	<ea>,Dn
		divu.w	d1,d0		; nur .w möglich 
		divu.w	(a1),d0
		divu.w	(a1)+,d0
		divu.w	-(a1),d0
		divu.w	$1234(a1),d0
		divu.w	$12(a1,d2.w),d0
		divu.w	$12(a1,d2.l),d0
		divu.w	$12(a1,a2.w),d0
		divu.w	$12(a1,a2.l),d0
		divu.w	$1234.w,d0
		divu.w	$12345678,d0
		divu.w	label(pc),d0
		divu.w	label(pc,d2.w),d0
		divu.w	label(pc,d2.l),d0
		divu.w	label(pc,a2.w),d0
		divu.w	label(pc,a2.l),d0
		divu.w	#$1234,d0

	Hinweis: Es ist nicht möglich, ein Adressregister An als Operanden zu verwenden

	Versuchen wir eine Division:

	moveq	#33,d0	; 32-Bit-Zahl zum Dividieren
	moveq	#5,d1	; Divisor
	divu.w	d1,d0	; d0 teilen in d1-Teile, d.h. 33/5

	das Ergebnis in d0 ist $00030006, tatsächlich ist 33 geteilt durch 5 6, Rest 3.

***************************************************************** X N Z V C ***
EOR      Exclusive OR                      Dn,<ea>     BWL        - * * 0 0

	Diese Anweisung führt das bitweise exklusive ODER mit dem Ziel durch.
	In der Praxis ist das Ergebnisbit nur dann 1, wenn die Operanden
	unterschiedlich sind.
	Hier ist die Ergebnistabelle, die den Unterschied mit ODER hervorhebt:

	0 EOR 0 = 0
	0 EOR 1 = 1
	1 EOR 0 = 1
	1 EOR 1 = 0	; Das ist der Unterschied zum OR! tatsächlich 1 ODER 1 = 1.

	Einige Beispiele:

	0000000001 EOR 1101011101 = 1101010000 - 1 Bit gelöscht
	1000000000 EOR 0010011000 = 1010011000 - 1 Bit gesetzt

	Das Bit wird also nur gesetzt, wenn eines der Bits auf 1 steht und
	nicht, wenn beide auf 1 stehen, wie es beim OR der Fall ist.
	FLAG: eXtend nicht verändert, oVerflow und Carry gelöscht, Negativ und Zero
	entsprechend dem Ergebnis der Operation geändert

	Bsp:

	Dn,<ea>
		eor.b	d1,d2		; .b, .w, .l möglich 
		eor.w	d1,(a1)
		eor.b	d1,(a1)+
		eor.w	d1,-(a1)
		eor.l	d1,$1234(a1)
		eor.w	d1,$12(a1,d2.w)
		eor.l	d1,$12(a1,d2.l)
		eor.w	d1,$12(a1,a2.w)
		eor.b	d1,$12(a1,a2.l)
		eor.l	d1,$1234.w
		eor.w	d1,$12345678

***************************************************************** X N Z V C ***
EORI     Exclusive OR Immediate         #<data>,<ea>   BWL        - * * 0 0


	Wie EOR, aber spezifisch für #unmittelbar als Quelle
	FLAG: eXtend nicht verändert, oVerflow und Carry gelöscht, Negativ und Zero
	entsprechend dem Ergebnis der Operation geändert

	Bsp:

	#<data>,<ea>
		eori.w	#$1234,		d1		; Die Ziele wurden für bessere
		eori.b	#$12,		(a1)	; Lesbarkeit mit Abständen angegeben 
		eori.w	#$1234,		(a1)+	
		eori.b	#$12,		-(a1)
		eori.l	#$12345678,	$1234(a1)
		eori.w	#$1234,		$12(a1,d2.w)
		eori.b	#$12,		$12(a1,d2.l)
		eori.l	#$12345678,	$12(a1,a2.w)
		eori.b	#$12,		$12(a1,a2.l)
		eori.w	#$1234,		$1234.w
		eori.l	#$12345678,	$12345678

		eori.b	#$12,ccr
		eori.w	#$1234,sr	; *** PRIVILEGIERTE INSTRUKTION ***

***************************************************************** X N Z V C ***
EXG      Exchange any two registers         Rx,Ry      --L        - - - - -

	Tauschet den Inhalt von 2 Registern aus, sowohl Adressen als auch Daten.
	FLAG: keine werden geändert

	Bsp:

	Rx,Ry
		exg	d0,d1
		exg	d0,a1
		exg	a0,a1 

***************************************************************** X N Z V C ***
EXT      Sign EXTend                         Dn        -WL        - * * 0 0

	Diese Anweisung "ERWEITERT" eine in einem Datenregister enthaltene Zahl
	mit Vorzeichen. Sie wird insbesondere für negative Zahlen verwendet, da
	sie nichts anderes tut, als die Bits 8 bis 15 (bei EXT.W) oder 16 bis 31
	(bei EXT.L) durch "Replizieren" des Vorzeichenbits (7 wenn EXT.W,
	oder 15 wenn EXT.L) zu "füllen". Es "transformiert" bei EXT.W von .b 
	nach .w, EXT.L von .w nach .l, indem es alle Bits als Vorzeichenbit setzt.
	Sie erhalten die gleiche Zahl (insbesondere wenn negativ) auch im .w- oder
	.l-Format, ausgehend von einem .b. 
	Nehmen wir ein Beispiel: d0 = $000000FB. Wir wissen das $FB -5 ist wenn wir
	im Byte mit Vorzeichen Feld sind, aber im .w oder .l Feld ist es einfach
	$FB = 251 positiv. Mit einem EXT.W d0 bekommen wir d0 = $0000FFFB, 	also
	ist $FFFB -5 im .w-Feld mit Vorzeichen.
	Mit einem EXT.L werden wir jetzt $FFFFFFFB erhalten, was -5 im .l-Feld mit 
	Vorzeichen ist!

	Bsp:

	Dn
		ext.w	d0	; verwandelt von .b in .w
		ext.l	d0	; verwandelt von .w in .l

Um ein Byte zu einem Langwort zu erweitern, müssen Sie zuerst ext.w und dann ein 
ext.l. ausführen zum Beispiel:

	move.b	#$80,d0		; d0.b = -128
	ext.w	d0		; d0.w = $ff80  (-128.w)
	ext.l	d0		; d0.l = $ffffff80  (-128.l)

***************************************************************** X N Z V C ***
JMP      JuMP to Affective Address          <ea>                  - - - - -

	Springt zur Zielroutine, ähnlich wie beim BRA.
	FLAG: Es werden keine geändert.

	Bsp:

	<ea>
		jmp	(a1)
		jmp	$1234(a1)
		jmp	$12(a1,d2.w)
		jmp	$12(a1,d2.l)
		jmp	$12(a1,a2.w)
		jmp	$12(a1,a2.l)
		jmp	$1234.w
		jmp	$12345678
		jmp	label(pc)
		jmp	label(pc,d2.w)
		jmp	label(pc,d2.l)
		jmp	label(pc,a2.w)
		jmp	label(pc,a2.l)

***************************************************************** X N Z V C ***
JSR      Jump to SubRoutine                 <ea>                  - - - - -

	Springt zum Zielunterprogramm und kehrt zurück, wenn sie fertig ist
	(wenn diese Subroutine das RTS gefunden hat) Anweisung ähnlich BSR
	FLAG: Es werden keine Flags geändert

	Bsp:

	<ea>
		jsr	(a1)
		jsr	$1234(a1)
		jsr	$12(a1,d2.w)
		jsr	$12(a1,d2.l)
		jsr	$12(a1,a2.w)
		jsr	$12(a1,a2.l)
		jsr	$1234.w
		jsr	$12345678
		jsr	aa17(pc)
		jsr	label(pc,d2.w)
		jsr	label(pc,d2.l)
		jsr	label(pc,a2.w)
		jsr	label(pc,a2.l)

***************************************************************** X N Z V C ***
LEA      Load Effective Address            <ea>,An     --L        - - - - -

	Laden einer Adresse in ein An-Adressregister.
	Zum Beispiel nach einem "LEA $10000,a0", A0 = $10000. In diesem Fall
	funktioniert die Anweisung wie ein "MOVE.L #$10000,a0", ist aber schneller.
	ACHTUNG: Der LEA-Befehl unterscheidet sich vom MOVEA!! In der Tat kann es 
	verwirrend sein, wenn wir ein "LEA $12(a0),a1" haben, zum Beispiel: in a1
	geht die in a0 enthaltene Adresse plus Offset, also $12, und nicht der Inhalt 
	dieser Adresse, wie es bei der indirekten Adressierung passieren würde.
	Zum Beispiel das Schreiben von "LEA $12(a0),a0" entspricht einem
	"ADDA.W #$12,a0".
	FLAG: es werden keine geändert

	Bsp:

	<ea>,An
		lea	(a1),a0		; Hinweis: in diesem Fall wird der Wert
						; von a1 nach a0 kopiert, wie MOVE.L a1,a0 !!!
						; nicht zu verwechseln mit dem move.l (a1),a0
						; was stattdessen eine indirekte Adressierung ist

		lea	$1234(a1),a0	; In diesem Fall wird die in a1 + $1234 enthaltene
						; Adresse nach a0 kopiert, nicht verwechseln
						; mit der indirekten Adressierung!
						; es ist ein LEA und kein MOVE !!!!!!!!
		lea	$12(a1,d2.w),a0
		lea	$12(a1,d2.l),a0
		lea	$12(a1,a2.w),a0
		lea	$12(a1,a2.l),a0
		lea	$1234.w,a0
		lea	$12345678,a0
		lea	label(pc),a0
		lea	label(pc,d2.w),a0
		lea	label(pc,d2.l),a0
		lea	label(pc,a2.w),a0
		lea	label(pc,a2.l),a0

***************************************************************** X N Z V C ***
LSL      Logical Shift Left                 Dx,Dy      BWL        * * * 0 *
                                          #<1-8>,Dy
                                            <ea>

	Logische Verschiebung nach links. Unter Verschiebung verstehen wir ein
	"Scrollen" von Bits, in diesem Fall nach links, zB: %0001 verschoben um 2:
	%0100 das heißt, die Bits, aus denen die Zahl besteht, werden nach links
	"verschoben": im Fall von LSL werden die niedrigen Bits mit Nullen
	"aufgefüllt", während die "ausgehenden" Bits auf der linken Seite in die
	Carry- und Extend-FLAGs kopiert werden. Es ist praktisch das gleiche wie ASL,
	der Unterschied	zwischen LOGISCHER-Verschiebung und ARITHMETISCHER-
	Verschiebung ist zwischen ASR und LSR und nicht zwischen ASL und LSL.
	FLAG: der oVerflow wird zurückgesetzt, das eXtend und das Carry enthalten das
	"ausgehende" hohe Bit, Negativ und Zero werden entsprechend der Operation 
	verändert.

				   Wert der nach links
					verschoben wird
					 ------------
	   Flag X/C <-- |<- <- <- <- | <--- 0 - Eingabe einer Null von rechts
 					 ------------

	; Adressierung wie ASL,ASR,LSR,ROL,ROR,ROXL,ROXR

	Bsp:

	Dx,Dy
		lsl.w	d0,d1	; .b, .w und .l möglich, die maximale Verschiebung
						; in diesem Fall ist 63 (die ersten 6 Bits 
						; des Datenregisters werden verwendet)

	#<1-8>,Dy
		lsl.w	#2,d1	; .b, .w und .l möglich, maximal lsl.x #8,Dy

	<ea>
		lsl.w	(a1)	; nur .w möglich, gleichwertig lsl.w #1,<ea>
		lsl.w	(a1)+
		lsl.w	-(a1)
		lsl.w	$1234(a1)
		lsl.w	$12(a1,d2.w)
		lsl.w	$12(a1,d2.l)
		lsl.w	$12(a1,a2.w)
		lsl.w	$12(a1,a2.l)
		lsl.w	$1234.w
		lsl.w	$12345678

***************************************************************** X N Z V C ***
LSR      Logical Shift Right                Dx,Dy      BWL        * * * 0 *
                                          #<1-8>,Dy
                                            <ea>

	Logische Verschiebung nach rechts. Unter Verschiebung verstehen wir ein 
	"Scrollen" von Bits, in diesem Fall nach rechts, zB: %0100 verschoben um 2:
	%0001 das heißt, die Bits, aus denen die Zahl besteht, werden nach rechts
	"verschoben": Bei jeder Verschiebung wird das niedrige Bit des Zielregisters
	in das Carry- und eXtend-Bit kopiert, während das höchste Bit GELÖSCHT wird.
	(im Gegensatz zum ASR, dh dem ARITHMETISCHEN SHIFT rechts, wo das höchste Bit
	unverändert bleibt)
	FLAG: der oVerflow wird zurückgesetzt, das eXtend und das Carry enthalten das
	niedrige "ausgehende" Bit, Negativ und Zero werden entsprechend der Operation 
	verändert.

									   Wert der nach rechts
										verschoben wird
										   ------------
Eingabe einer Null von links	  - 0 --->|-> -> -> ->| ---> Flag X/C
			    						   ------------

	; Adressierung wie ASL,ASR,LSL,ROL,ROR,ROXL,ROXR

	Bsp:

	Dx,Dy
		lsr.w	d0,d1	; .b, .w und .l möglich, die maximale Verschiebung
						; in diesem Fall ist 63 (die ersten 6 Bits 
						; des Datenregisters werden verwendet)

	#<1-8>,Dy
		lsr.w	#2,d1	; .b, .w und .l möglich, maximal lsr.x #8,Dy

	<ea>
		lsr.w	(a1)	; nur .w möglich, gleichwertig lsr.w #1,<ea>
		lsr.w	(a1)+
		lsr.w	-(a1)
		lsr.w	$1234(a1)
		lsr.w	$12(a1,d2.w)
		lsr.w	$12(a1,d2.l)
		lsr.w	$12(a1,a2.w)
		lsr.w	$12(a1,a2.l)
		lsr.w	$1234.w
		lsr.w	$12345678

***************************************************************** X N Z V C ***
MOVE     Between Effective Addresses      <ea>,<ea>    BWL        - * * 0 0

	Kopiert den Inhalt des Quelloperanden in den Zieloperanden.
	FLAG: eXtend bleibt unverändert, oVerflow und Carry werden zurückgesetzt
	Negativ und Zero werden entsprechend der Operation verändert.
	Hier wäre die Liste zu lang, nur ein paar Beispiele:

	<ea>,<ea>
		move.w	$1234(a1),		(a0)	; Die Ziele wurden für bessere
		move.w	$12(a1,a2.w),	(a0)	; Lesbarkeit mit Abständen angegeben 
		move.w	$1234.w,		(a0)+		
		move.w	label(pc),		-(a0)
		move.w	label(pc,d2.l),	$1234(a1)
		move.w	$12(a1,a2.w),	$12(a1,d2.w)
		move.w	d1,				$12(a1,a2.w)
		move.w	(a1)+,			$12(a1,a2.l)
		move.w	-(a1),			$1234.w

	Hinweis: um direkt in ein Adressregister zu "verschieben", existiert
	der spezielle MOVEA-Befehl ("movea.w d0,a0"). Der Assembler
	akzeptiert jedoch auch den einfachen move für die Adressregister,
	der zu MOVEA ohne Probleme assembliert wird.


***************************************************************** X N Z V C ***
MOVE     To CCR                           <ea>,CCR     -W-        I I I I I

	MOVE-Befehl zum Ändern des CCR, das heißt des Condition	Code Register,
	d.h. die niedrigen 8 Bits von SR, also die Zustandscodes. Erstellt eine
	Kopie der unteren 8 Bits des Quelloperanden zu den unteren 8 Bits des SR.
	FLAG: Natürlich werden sie alle geändert, wenn wir sie umschreiben!

	Bsp:

	<ea>,CCR
		move.w	d1,ccr		; nur .w
		...					; etc, wie MOVE normal.
	
		move.w	#$0012,ccr	; nur das Low-Byte der Quelle
							; wird in CCR kopiert, was ein BYTE ist!

***************************************************************** X N Z V C ***
MOVE     To SR                             <ea>,SR     -W-        I I I I I

	*** PRIVILEGIERTE INSTRUKTION! Nur im Supervisor-Modus ausführen! ***

	Dies ist ein spezieller move, um das Statusregister zu ändern.
	FLAGS: Offensichtlich geändert, da CCR das niedrige Byte von SR ist!

	Bsp:

	<ea>,SR
		move.w	d1,sr		; nur .w
		...					; etc, wie move

		move.w	#$1234,SR

***************************************************************** X N Z V C ***
MOVE     From SR                           SR,<ea>     -W-        - - - - -

	*** PRIVILEGIERTE INSTRUKTION! Nur im Supervisor-Modus ausführen! ***

	Auf dem 68000 ist er nicht privilegiert, aber auf dem
	68010/20/30/40/60 ist er privilegiert, so dass eine Ausführung im
	Benutzermodus nur zu einem GURU auf einem 1200er oder einem anderen
	Amiga mit 68010 oder höher führt.
	Kopieren Sie den Inhalt des Statusregisters in das Ziel.

	Bsp:

	SR,<ea>
		move.w	sr,d1		; nur .w
		move.w	sr,(a1)
		move.w	sr,(a1)+
		move.w	sr,-(a1)
		move.w	sr,$1234(a1)
		move.w	sr,$12(a1,d2.w)
		move.w	sr,$12(a1,d2.l)
		move.w	sr,$12(a1,a2.w)
		move.w	sr,$12(a1,a2.l)
		move.w	sr,$1234.w
		move.w	sr,$12345678

***************************************************************** X N Z V C ***
MOVE     USP to/from Address Register      USP,An      --L        - - - - -
                                           An,USP

	*** PRIVILEGIERTE INSTRUKTION! Nur im Supervisor-Modus ausführen! ***

	Kopiert den User Stack Pointer, d.h. den Zeiger auf den User Mode 
	Stack (a7), in ein Adressregister oder umgekehrt.

	Bsp:

	USP,An
		move.l	usp,a0

	An,USP
		move.l	a0,usp

***************************************************************** X N Z V C ***
MOVEA    MOVE Address                      <ea>,An     -WL        - - - - -

	MOVE-Befehl, der dem Kopieren in An-Adressregister gewidmet ist.
	Daher ist es nicht möglich, in Bytelänge zu kopieren (.b).
	Hinweis: der Assembler akzeptiert auch "move" für "movea", z.B.
	"move.l d1,a0" wird korrekt ohne Fehler in "movea.l d1, a0" assembliert.
	Es reicht also aus, immer "move" zu schreiben und die Aufgabe des
	richtigen assemblierens ASMONE zu überlassen.
	FLAG: Keine werden geändert

	Tipp: Verwenden Sie immer die Erweiterung .L

	Bsp:

	<ea>,An
		movea.l	d1,a0
		movea.l	a1,a0
		movea.l	(a1),a0
		movea.l	(a1)+,a0
		movea.l	-(a1),a0
		movea.l	$1234(a1),a0
		movea.l	$12(a1,d2.w),a0
		movea.l	$12(a1,d2.l),a0
		movea.l	$12(a1,a2.w),a0
		movea.l	$12(a1,a2.l),a0
		movea.l	$1234.w,a0
		movea.l	$12345678,a0
		movea.l	label(pc),a0
		movea.l	label(pc,d2.w),a0
		movea.l	label(pc,d2.l),a0
		movea.l	label(pc,a2.w),a0
		movea.l	label(pc,a2.l),a0

		movea.l	#$1234,a0

	Beachten Sie, dass ein MOVEA.W xxxx,ax alle 32 Bits kopiert und nicht 16,
	wie es für die .w scheinen mag. Der 16-Bit-Quelloperand wird durch das
	Vorzeichen auf 32 Bit erweitert, dh der Wert des Vorzeichenbits 15, wird
	in die Bits 16 bis 31 kopiert.
	Zum Beispiel:

		MOVEA.W	#$1234,a0	; a0=$00001234
		MOVEA.W	#$9200,a0	; a0=$FFFF9200, weil $9200 in
							; SIGNED .w negativ (-28672) ist
		MOVEA.L	#$9200,a0	; a0=$00009200, aber dann ist es besser
							; LEA $9200,a0 zu benutzen: 

	Wie Sie sehen können, gibt es für Zahlen unter $7fff keine Unterschiede
	zwischen MOVEA.L und MOVEA.W, während es für höhere Zahlen welche gibt.
	Es ist daher praktisch, den LEA xxxxx,ax für Werte über $7fff zu verwenden,
	das es keine Fehlermöglichkeiten gibt und es schneller ist.
	Achtung auch in diesem Fall:

	move.l	#$a000,d0	; Adresse in d0
	movea.w	d0,a0		; a0 = $FFFFa000

	Ein Movea war ausgesprochen praktisch!!!!

***************************************************************** X N Z V C ***
MOVEM    MOVE Multiple            <register list>,<ea> -WL        - - - - -
                                  <ea>,<register list>

 Diese Anweisung wird verwendet, um eine Liste von Registern, Daten und /
    oder Adressen, in einen Speicherbereich oder umgekehrt zu kopieren.
	Um die Liste der Adressen zu definieren, wird die folgende Syntax
	verwendet: für aufeinanderfolgende Register schreiben Sie das erste und das
	letzte Register der Reihe, getrennt durch ein "-", z.B. d0-d5 bedeutet
	d0, d1, d2, d3, d4, d5.
	Für alle Register, die nicht in einer Reihe stehen, werden sie durch Trennung 
	von den anderen "einzelnen" Registern oder von den anderen Serien mit einem 
	"/" angegeben, zum Beispiel: d0 / d3 / d6 bedeutet die Register d0, d3, d6.
	Lassen Sieuns einen "gemischten" Fall untersuchen: d0 / d2 / d4-d7 / a0-a3 
	bezeichnet die Register d0, d2, d4, d5, d6, d7, a0, a1, a2, a3.
	Wenn die Anweisung .word lautet, werden die Wörter aus dem Speicher in die
	Register kopiert, aber mit einem 32-Bit-Vorzeichen "erweitert", d.h. Bit 15
	des Vorzeichens wird wiederholt, um die Bits 16 bis 31 zu füllen.

	Bsp:

	<register list>,<ea>
		movem.l	d0/d2/d4/d6/a0/a2,$12345678	; nur .w oder .l
		movem.w	d0-d3/d6-d7/a6-a7,(a1)
		movem.l	d3-d4/d6-d7/a3-a4,-(a1)
		movem.w	d0-d7/a0-a1/a3-a4,$1234(a1)
		movem.w	d6-d7/a1/a3/a5/a7,$12(a1,d2.w)
		movem.l	d0/d2/d4/a3-a4/a6,$12(a1,d2.l)
		movem.l	a0-a1/a3-a4/a6-a7,$12(a1,a2.w)
		movem.w	d0-d1/d3-d4/d6-d7,$12(a1,a2.l)
		movem.l	d0-d1/d3-d4/d6-d7,$1234.w
		movem.w	d0-d1/d3-d4/d6-d7,$12345678

	<ea>,<register list>
		movem.w	(a1),d0-d7/a0-a6
		movem.l	(a1)+,d0-d7/a0-a6
		movem.w	$1234(a1),d0-d7/a0-a6
		movem.l	$12(a1,d2.w),d0-d7/a0-a6
		movem.w	$12(a1,d2.l),d0-d7/a0-a6
		movem.w	$12(a1,a2.w),d0-d7/a0-a6
		movem.l	$12(a1,a2.l),d0-d7/a0-a6
		movem.l	$1234.w,d0-d7/a0-a6
		movem.w	$12345678,d0-d7/a0-a6
		movem.w	label(pc),d0-d7/a0-a6
		movem.l	label(pc,d2.w),d0-d7/a0-a6
		movem.w	label(pc,d2.l),d0-d7/a0-a6
		movem.l	label(pc,a2.w),d0-d7/a0-a6
		movem.w	label(pc,a2.l),d0-d7/a0-a6

	Eine häufige Verwendung ist das Speichern und Wiederherstellen aller oder
	ein Teil der Register auf dem Stack:

	movem.l	d0-d7/a0-a6,-(SP)	; alle Register auf dem Stack speichern
	....
	movem.l	(SP)+,d0-d7/a0-a6	; alle Register vom Stack nehmen
 
	Hinweis: Die Reihenfolge der Register ist immer gleich, zuerst die
	Datenregister, vom kleinsten bis zum größten, dann die Adressregister.
	Es wird so geschrieben:

		movem.l	a0/d2-d4/a6/a2/d7,-(SP)

	In der Praxis wird es in der richtigen Reihenfolge assembliert:

		MOVEM.L	D2-D4/D7/A0/A2/A6,-(A7)

	Bei dieser Sache muss man darauf achten, die Register nicht	"vertauscht"
	wieder herzustellen, sondern sich davon vergewissern, dass sie korrekt
	wiederhergestellt werden.

***************************************************************** X N Z V C ***
MOVEP    MOVE Peripheral                  Dn,x(An)     -WL        - - - - -
                                        x(An),Dn

	Dieses MOVE kopiert die niedrigen Bytes des Quelloperanden in den 
	Zieloperanden. Machen wir einige PRAKTISCHE Beispiele:

	Bsp 1:

	x(An),Dn
		movep.w	$1234(a1),d0	; .w und .l möglich 

Word:
	moveq	#0,d0
	lea	dati(PC),a1
	movep.w	0(a1),d0
	rts			; d0 = $00001030

LongWord:
	lea	dati(PC),a1
	movep.l	0(a1),d0
	rts			; d0 = $10305070


dati:
	dc.l	$10203040
	dc.l	$50607080

	***	***	***	***

	Bsp 2:

	Dn,x(An)
		movep.w	d0,$1234(a1)	;  .w und .l möglich

Word:
	move.l	#$10203040,d0
	lea	dati(PC),a1
	movep.w	d0,0(a1)
	rts			; 0(a1) = $30004000

LongWord:
	move.l	#$10203040,d0
	lea	dati(PC),a1
	movep.l	d0,0(a1)
	rts			; 0(a1) = $10002000 , $30004000

dati:
	dc.l	$00000000
	dc.l	$00000000
  
	Diese Anweisung wird nicht oft verwendet, dient vor allem der Kommunikation 
	mit Peripheriegeräten (so scheint es). Es könnte jedoch nützlich sein für
	ein seltsames Mischen von Bytes in Ihren Programmen!
	Wenn Sie nicht alles verstehen, debuggen Sie die Routinen.

***************************************************************** X N Z V C ***
MOVEQ    MOVE 8-bit immediate         #<-128.+127>,Dn  --L        - * * 0 0

	Move Quick, Befehl zum Laden eines Datenregisters mit einem 
	#Immediate-Wert zwischen -128 und +127, der schneller ist als der übliche 
	"MOVE.L #Immediate,Dn.
	Die Operation ist wie MOVE.L und sollte immer dann verwendet werden,
	wenn es aufgrund der höheren Ausführungsgeschwindigkeit möglich ist.
	FLAG: eXtend bleibt unverändert, oVerflow und Carry sind gelöscht
    Negativ und Zero werden entsprechend der Operation verändert.

	Bsp:

	#<-128.+127>,Dn
		moveq	#10,d0
		moveq	#-10,d0	; d0 = $FFFFFFF6

***************************************************************** X N Z V C ***
MULS     MULtiply Signed                   <ea>,Dn     -W-        - * * 0 0

 	Multiplikation mit Vorzeichen. Zwei vorzeichenbehaftete 16-Bit-Zahlen
	die von -32768 bis +32767 gehen können,	werden multipliziert, so dass der
	maximale positive Wert 1073741824 ist, während der negative Wert 
	-1073709056 ist, ein Übertrag oder ein Überlauf kann also nicht vorkommen.
	Es wird nur das niederwertige Wort der Quelloperanden gelesen, also eine
	Zahl, z.B. $00123456 wird als $00003456 gelesen.
	Das 32-Bit-Ergebnis wird im Zieldatenregister gespeichert. Das Vorzeichen
	des Ergebnisses folgt den Regeln + * + = +, + * - = -, - * + = 
	-, - * - = +.
	FLAG: der eXtend bleibt unverändert, Overflow und Carry werden gelöscht, 
	Negativ und Zero werden entsprechend der Operation geändert.

	Bsp:

	<ea>,Dn
		muls.w	d1,d0
		muls.w	(a1),d0
		muls.w	(a1)+,d0
		muls.w	-(a1),d0
		muls.w	$1234(a1),d0
		muls.w	$12(a1,d2.w),d0
		muls.w	$12(a1,d2.l),d0
		muls.w	$12(a1,a2.w),d0
		muls.w	$12(a1,a2.l),d0
		muls.w	$1234.w,d0
		muls.w	$12345678,d0
		muls.w	label(pc),d0
		muls.w	label(pc,d2.w),d0
		muls.w	label(pc,d2.l),d0
		muls.w	label(pc,a2.w),d0
		muls.w	label(pc,a2.l),d0
		muls.w	#$1234,d0

	Hinweis: Es ist nicht möglich, ein Adressregister An als Operanden zu
	         verwenden

***************************************************************** X N Z V C ***
MULU     MULtiply Unsigned                 <ea>,Dn     -W-        - * * 0 0
	
	Multiplikation ohne Vorzeichen.	Zwei 16-Bit-Zahlen werden multipliziert,
	das 32-Bit Ergebnis wird im Zieldatenregister gespeichert.
	Beim 68000 ist nur die MULU.w möglich, im Gegensatz zum 68020+.
	Es wird nur das Low-Word der Quelloperanden gelesen, also eine Zahl, 
	z.B. $00123456 wird als $00003456 gelesen.
	Da sowohl der Multiplikand als auch der Multiplikator 16 Bit lang sind,
	d.h. max. 65535, kann das Produkt 4294836225, die volle Länge, nicht
	überschreiten, daher ist keine Überlaufbedingung möglich.
	FLAG: eXtend bleibt unverändert, Overflow und Carry werden gelöscht, 
	Negativ und Zero werden entsprechend der Operation geändert.

	Bsp:

	<ea>,Dn
		mulu.w	d1,d0
		mulu.w	(a1),d0
		mulu.w	(a1)+,d0
		mulu.w	-(a1),d0
		mulu.w	$1234(a1),d0
		mulu.w	$12(a1,d2.w),d0
		mulu.w	$12(a1,d2.l),d0
		mulu.w	$12(a1,a2.w),d0
		mulu.w	$12(a1,a2.l),d0
		mulu.w	$1234.w,d0
		mulu.w	$12345678,d0
		mulu.w	label(pc),d0
		mulu.w	label(pc,d2.w),d0
		mulu.w	label(pc,d2.l),d0
		mulu.w	label(pc,a2.w),d0
		mulu.w	label(pc,a2.l),d0
		mulu.w	#$1234,d0

	Hinweis: Es ist nicht möglich, ein Adressregister An als Operanden zu
		     verwenden

***************************************************************** X N Z V C ***
NEG      NEGate                             <ea>       BWL        * * * * *

	Dieser Befehl führt die Negation durch, dh er subtrahiert den Zieloperanden
	von 0 wodurch er mindestens negativ wird. (Bsp: 0-5 = -5!!!).

	Bsp:

	<ea>
		neg.w	d1
		neg.b	(a1)
		neg.w	(a1)+
		neg.l	-(a1)
		neg.w	$1234(a1)
		neg.b	$12(a1,d2.w)
		neg.w	$12(a1,d2.l)
		neg.b	$12(a1,a2.w)
		neg.w	$12(a1,a2.l)
		neg.l	$1234.w
		neg.w	$12345678

***************************************************************** X N Z V C ***
NEGX     NEGate with eXtend                 <ea>       BWL        * * * * *

	Der einzige Unterschied zu NEG ist, dass das eXtend-Flag auch von 0
	subtrahiert wird.

***************************************************************** X N Z V C ***
NOP      No OPeration                        NOP                  - - - - -
	
	Dieser "dumme" Befehl dient nur dazu, "Platz" zu belegen, genauer gesagt 
	ein Wort ($4e71), denn bei seiner Ausführung passiert nichts, und nicht
	einmal die FLAGs werden verändert. Der eigentliche Hauptzweck ist der des 
	"NOP-ing", d.h. das Kopieren von $4e71, d.h. des NOP, über die 
	verschiedenen SUBQ.W #1,LIVES, um TRAINERS zu machen.
	Wehe Ihnen, wenn Sie auf die Idee kommen, Verzögerungen zu erzeugen, indem
	Sie einen Spin von NOP oder einen DBRA-Zyklus von NOP !! Auf schnellen
	Prozessoren würde diese Verzögerung "verschwinden". Verzögern Sie nur mit
	dem VBLANK oder mit dem CIA-Timer!

	Bsp:
		nop

***************************************************************** X N Z V C ***
NOT      Gegenteil von 1	                <ea>       BWL        - * * 0 0

	Logisches NICHT des Ziels. Der NOT invertiert Bit für Bit den
	Zielort:

		NOT 0 = 1
		NOT 1 = 0

	Zum Beispiel würde $12, d.h. %00010010, zu %11101101
	FLAG: eXtend bleibt unverändert, oVerflow und Carry werden gelöscht
	Negativ und Zero werden entsprechend der Operation geändert.

	Bsp:

	<ea>
		not.b	d1
		not.w	(a1)
		not.w	(a1)+
		not.l	-(a1)
		not.w	$1234(a1)
		not.l	$12(a1,d2.w)
		not.w	$12(a1,d2.l)
		not.b	$12(a1,a2.w)
		not.l	$12(a1,a2.l)
		not.w	$1234.w
		not.l	$12345678

***************************************************************** X N Z V C ***
OR       Bit-wise OR                       <ea>,Dn     BWL        - * * 0 0
                                           Dn,<ea>

	Bitweises logisches ODER der Quelle mit dem Ziel, Ergebnis
	im Ziel. Hier ist die OP-Tabelle:

	0 OR 0 = 0
	0 OR 1 = 1
	1 OR 0 = 1
	1 OR 1 = 1

	ENTWEDER DAS EINE ODER DAS ANDERE BIT MUSS 1 SEIN, um 1 zu ergeben, einfach.
	Es kann zum Setzen von Bits verwendet werden (im Gegensatz zu AND, das zum
	Löschen von Bits dient). Zum Beispiel hat ein OR.B #%00001111,d0 den Effekt,
	die 4 Low-Bits zu setzen und die 4 High-Bits unverändert zu lassen.
	FLAG: eXtend bleibt unverändert, Overflow und Carry werden gelöscht, 
	Negative und Zero werden entsprechend der Operation geändert.

	Bsp:

	Dn,<ea>
		or.w	d0,d1
		or.b	d0,(a1)
		or.w	d0,(a1)+
		or.b	d0,-(a1)
		or.w	d0,$1234(a1)
		or.l	d0,$12(a1,d2.w)
		or.w	d0,$12(a1,d2.l)
		or.b	d0,$12(a1,a2.w)
		or.w	d0,$12(a1,a2.l)
		or.l	d0,$1234.w
		or.w	d0,$12345678

	<ea>,Dn
		or.l	d1,d0
		or.w	(a1),d0
		or.w	(a1)+,d0
		or.b	-(a1),d0
		or.w	$1234(a1),d0
		or.b	$12(a1,d2.w),d0
		or.w	$12(a1,d2.l),d0
		or.l	$12(a1,a2.w),d0
		or.w	$12(a1,a2.l),d0
		or.l	$1234.w,d0
		or.b	$12345678,d0
		or.w	label(pc),d0
		or.w	label(pc,d2.w),d0
		or.l	label(pc,d2.l),d0
		or.w	label(pc,a2.w),d0
		or.b	label(pc,a2.l),d0

***************************************************************** X N Z V C ***
ORI      Bit-wise OR with Immediate     #<data>,<ea>   BWL        - * * 0 0


	Bitweises logisches ODER der Quelle mit dem Ziel, Ergebnis
	im Ziel. Hier ist die OP-Tabelle:

	0 OR 0 = 0
	0 OR 1 = 1
	1 OR 0 = 1
	1 OR 1 = 1

	ENTWEDER DAS EINE ODER DAS ANDERE BIT MUSS 1 SEIN, um 1 zu ergeben, einfach.
	Es kann verwendet werden, um Bits zu setzen (im Gegensatz zu AND, das zum 
	Löschen von Bits dient). Zum Beispiel hat ein OR.B #%00001111,d0 den Effekt,
	die 4 Low-Bits zu setzen und die 4 High-Bits unverändert zu lassen. 	
	FLAG: eXtend bleibt unverändert, der Overflow und Carry werden gelöscht, 
	Negativ und Zero werden entsprechend der Operation geändert.

	Bsp:

	#<data>,<ea>
		ori.w	#$1234,		d1		; Die Ziele wurden für bessere
		ori.b	#$12,		(a1)	; Lesbarkeit mit Abständen angegeben 
		ori.w	#$1234,		(a1)+	
		ori.l	#$12345678,	-(a1)
		ori.w	#$1234,		$1234(a1)
		ori.b	#$12,		$12(a1,d2.w)
		ori.w	#$1234,		$12(a1,d2.l)
		ori.l	#$12345678,	$12(a1,a2.w)
		ori.b	#$12,		$12(a1,a2.l)
		ori.w	#$1234,		$1234.w
		ori.b	#$12,		$12345678

		ori.b	#$12,ccr
		ori.w	#$1234,sr	; *** PRIVILEGIERTE INSTRUKTION

***************************************************************** X N Z V C ***
PEA      Push Effective Address             <ea>       --L        - - - - -

	Laden einer Adresse auf den Stack. Als MOVE.L #Adresse,-(SP), sozusagen.
	Achten Sie darauf, dass der Stack-Zeiger 4 Bytes weiter nach hinten
	verschoben wird, bei der Verwendung von MOVE.L #Address,-(SP).
	Eine Anwendung könnte beispielsweise so aussehen:

	PEA	Copperlist(PC)
	MOVE.L	(SP)+,$dff080

	Aber warum sollte der Stack jemals auf eine Copperliste zeigen?
	Tatsächlich wird diese Anweisung nicht häufig verwendet.

	Bsp:

	<ea>
		pea	(a1)
		pea	$1234(a1)
		pea	$12(a1,d2.w)
		pea	$12(a1,d2.l)
		pea	$12(a1,a2.w)
		pea	$12(a1,a2.l)
		pea	$1234.w
		pea	$12345678
		pea	label(pc)
		pea	label(pc,d2.w)
		pea	label(pc,d2.l)
		pea	label(pc,a2.w)
		pea	label(pc,a2.l)

***************************************************************** X N Z V C ***
ROL      ROtate Left                      #<1-8>,Dy    BWL        - * * 0 *
                                            Dx,Dy
                                            <ea>

	Rotation der Bits nach links. Sie führt eine Verschiebung wie LSL durch,
	aber in diesem Fall werden die Bits "gedreht", d.h. die Bits, die nach links
	"rausgehen", landen im Carry, werden dann aber nach rechts in den leeren
	Raum kopiert, im Gegensatz zu LSL, wo die "neuen" Bits auf der rechten Seite
	gelöscht werden.
	Wenn wir zum Beispiel %11100001 haben, haben wir mit einer ROL #2 %10000111. 
	(mit LSL hätten wir %10000100 gehabt).
	FLAG: eXtend nicht verändert, oVerflow gelöscht, die anderen entsprechend der
	Operation geändert. (Im Carry das hohe Bit)

					 Wert der nach links
					   verschoben wird
					    ------------
	     Flag C <---+<--|<- <- <- <-|<-+
		    	|     ------------  |
		    	 \_>____>_____>___/
	Das Bit, das links rausgeht, kommt rechts rein!

	; Adressierung wie ASL,ASR,LSL,LSR,ROR,ROXL,ROXR

	Bsp:

	Dx,Dy
		rol.w	d0,d1	; .b, .w, .l möglich ,  die maximale Verschiebung in
						; diesem Fall ist 63 (die ersten 6 Bits des
						; Datenregisters werden verwendet)

	#<1-8>,Dy
		rol.w	#2,d1	; .b, .w, .l möglich , maximal rol.x #8,Dy

	<ea>
		rol.w	(a1)	; nur .w möglich; schreiben von rol.w #1,<ea>
		rol.w	(a1)+	; ist äquivalent
		rol.w	-(a1)
		rol.w	$1234(a1)
		rol.w	$12(a1,d2.w)
		rol.w	$12(a1,d2.l)
		rol.w	$12(a1,a2.w)
		rol.w	$12(a1,a2.l)
		rol.w	$1234.w
		rol.w	$12345678

***************************************************************** X N Z V C ***
ROR      ROtate Right                     #<1-8>,Dy    BWL        - * * 0 *
                                            Dx,Dy
                                            <ea>

	Rotation der Bits nach rechts. Sie führt eine Verschiebung wie LSR durch,
	aber in diesem Fall werden die Bits "gedreht", die Bits, die nach rechts
	"rausgehen" landen im Carry, werden dann aber nach links in den leeren
	Raum kopiert, im Gegensatz zu LSR, wo die "neuen" Bits auf der linken Seite
	gelöscht werden.
	Wenn wir zum Beispiel %10000111 haben, haben wir mit einem ROR #2 %11100001.
	(mit LSR hätten wir %00100001 gehabt).
	FLAG: eXtend nicht verändert, oVerflow gelöscht, die anderen entsprechend der
	Operation geändert. (Im Carry das hohe Bit)

					Wert der nach rechts
					 verschoben wird
					 ------------
				+-->|-> -> -> ->|--+--> Flag C
		    	|    ------------  |
		    	\_<____<_____<____/
	Das Bit, das rechts herauskommt, kommt links herein!

	; Adressierung wie ASL,ASR,LSL,LSR,ROL,ROXL,ROXR

	; wie oben

	Bsp:

	Dx,Dy
		ror.w	d0,d1	; möglich .b, .w, .l, die maximale Verschiebun
				; in diesem Fall 63 (die ersten 6 Bits werden verwendet
				; des Datenregisters)

	#<1-8>,Dy
		ror.w	#2,d1	; .b, .w, .l möglich, maximal ror.x #8,Dy

	<ea>
		ror.w	(a1)	; nur .w möglich, gleichwertig ROR #1,<ea>
		ror.w	(a1)+
		ror.w	-(a1)
		ror.w	$1234(a1)
		ror.w	$12(a1,d2.w)
		ror.w	$12(a1,d2.l)
		ror.w	$12(a1,a2.w)
		ror.w	$12(a1,a2.l)
		ror.w	$1234.w
		ror.w	$12345678

***************************************************************** X N Z V C ***
ROXL     ROtate Left with eXtend          #<1-8>,Dy    BWL        * * * 0 *
                                            Dx,Dy
                                            <ea>

	Anweisung wie ROL, mit dem Unterschied, dass das höchstwertige Bit, das
	verschoben wird, im eXtend wie auch im Carry landet. Es wird
	für mehrfache Präzisionsverschiebungen verwendet, da das eXtend-Flag von
	rechts kommt: Es reicht aus, den möglichen Übertrag einer vorherigen
	Verschiebung zu haben, mit einem ROXL wird diese Verschiebung unter
	Berücksichtigung des vorher erzeugten eXtend-Flag weiter.
	Außerdem verhält sich das Flag X wie das "neunte" Bit des Registers
	(wenn .B) oder das "siebzehnte", wenn in .w, oder das "zweiunddreißigste"
	in .L, und nimmt an der Rotation teil, indem es in das Register zurückkehrt.

					Wert der nach links    flag X aktualisiert
						 verschoben wird   /
						 ------------     /
	     Flag C <---+<--|<- <- <- <-|<--|X|-<-+
		    	|		 ------------	  |
		    	 \_>____>_____>____>__>__/
	Das Bit, das links rausgeht, kommt rechts rein!

	; Adressierung wie ASL,ASR,LSL,LSR,ROL,ROR,ROXR

***************************************************************** X N Z V C ***
ROXR     ROtate Right with eXtend         #<1-8>,Dy    BWL        * * * 0 *
                                            Dx,Dy
                                            <ea>

	Anweisung wie ROR, mit dem Unterschied, dass das niederwertigste Bit, das
	verschoben wird, im eXtend und im Carry landet.
	Außerdem verhält sich das Flag X wie das "neunte" Bit des Registers 
	(wenn .B) oder das "siebzehnte", wenn in .w, oder das "zweiunddreißigste"
	in .L, und nimmt an der Rotation teil, indem es in das Register zurückkehrt.

	Wird für mehrfache Präzisionsverschiebungen verwendet

    flag X aktualisiert	   Wert der nach rechts 
		     \             verschoben wird
		      \      ------------
		  +->-|X|-->|-> -> -> ->|--+--> Flag C
		  |  	     ------------  |
		   \__<___<____<_____<____/
	Das Bit, das rechts herauskommt, kommt links herein!

***************************************************************** X N Z V C ***
RTE      ReTurn from Exception               RTE                  I I I I I

	Rückkehr von einer Ausnahme, einem Trap oder einem Interrupt.
	Durch unmittelbare Daten veränderte Flags

	Bsp:
		rte

***************************************************************** X N Z V C ***
RTR      ReTurn and Restore                  RTR                  I I I I I

	Rückkehr mit Rücksetzen des CCR-Bytes

	Bsp:
		rtr

***************************************************************** X N Z V C ***
RTS      ReTurn from Subroutine              RTS                  - - - - -

	Rückkehr von einem BSR oder JSR. Keine Flags geändert

	Bsp:
		rts

***************************************************************** X N Z V C ***
Scc      Set to -1 if True, 0 if False      <ea>       B--        - - - - -

	Diese Anweisung SETZT alle Bits eines Bytes (sie wandelt es in $FF), sofern
	die cc-Bedingungen erfüllt sind, andernfalls wird das Byte ($00) 
	zurückgesetzt. Es gibt 2 Befehle, die das Byte immer setzen oder dieses Byte
	immer zurücksetzen, sie heißen ST und SF.
	
	Bsp:	(siehe Bcc für die Beschreibung des cc)

	<ea>
		st.b	d1	; nur .b - Always set
		st.b	(a1)
		st.b	(a1)+
		st.b	-(a1)
		st.b	$1234(a1)
		st.b	$12(a1,d2.w)
		st.b	$12(a1,d2.l)
		st.b	$12(a1,a2.w)
		st.b	$12(a1,a2.l)
		st.b	$1234.w
		st.b	$12345678

	Die gleiche Adressierung für:

		sf	<ea>		; nur .b, Never Set

		shi.s	<ea>	; > für vorzeichenlose Zahlen
		sgt.w	<ea>	; > für vorzeichenbehaftete Zahlen
		scc.s	<ea>	; >= für Zahlen ohne Vorzeichen - auch genannt SHS
		sge.s	<ea>	; >= für Zahlen mit Vorzeichen
		seq.s	<ea>	; = für alle Zahlen
		sne.w	<ea>	; >< für alle Zahlen
		sls.w	<ea>	; <= für Zahlen ohne Vorzeichen
		sle.w	<ea>	; <= für Zahlen mit Vorzeichen
		scs.w	<ea>	; < für Zahlen ohne Vorzeichen - auch genannt SLO
		slt.w	<ea>	; < für Zahlen mit Vorzeichen
		spl.w	<ea>	; wenn Negativ = 0 (PLus)
		smi.s	<ea>	; wenn Negativ = 1, (Minus) Zahlen mit Vorzeichen
		svc.w	<ea>	; V=0, kein OVERFLOW
		svs.s	<ea>	; V=1 OVERFLOW

***************************************************************** X N Z V C ***
STOP     Enable & wait for interrupts      #<data>                I I I I I

	Bsp:
		stop	#$1234

***************************************************************** X N Z V C ***
SUB      SUBtract binary                   Dn,<ea>     BWL        * * * * *
                                           <ea>,Dn

	Dieser Befehl subtrahiert den Quelloperanden vom Zieloperanden und
	speichert das Ergebnis im Zieloperanden.
	Die Flags werden entsprechend dem Ergebnis der Operation verändert.
	Das C (Carry)-Flag wird gesetzt, wenn die Subtraktion ein Darlehen
	ergibt (dh das Ergebnis "geht nicht in den Zieloperanden ein").


	Bsp:

	Dn,<ea>
		sub.b	d0,d1
		sub.w	d0,(a1)
		sub.l	d0,(a1)+
		sub.w	d0,-(a1)
		sub.w	d0,$1234(a1)
		sub.l	d0,$12(a1,d2.w)
		sub.w	d0,$12(a1,d2.l)
		sub.w	d0,$12(a1,a2.w)
		sub.w	d0,$12(a1,a2.l)
		sub.b	d0,$1234.w
		sub.l	d0,$12345678

	<ea>,Dn
		sub.w	d1,d0
		sub.l	a1,d0
		sub.w	(a1),d0
		sub.b	(a1)+,d0
		sub.w	-(a1),d0
		sub.b	$1234(a1),d0
		sub.w	$12(a1,d2.w),d0
		sub.l	$12(a1,d2.l),d0
		sub.w	$12(a1,a2.w),d0
		sub.l	$12(a1,a2.l),d0
		sub.w	$1234.w,d0
		sub.b	$12345678,d0
		sub.w	label(pc),d0
		sub.b	label(pc,d2.w),d0
		sub.w	label(pc,d2.l),d0
		sub.l	label(pc,a2.w),d0
		sub.w	label(pc,a2.l),d0

***************************************************************** X N Z V C ***
SUBA     SUBtract binary from An           <ea>,An     -WL        - - - - -

	SUB-Operation speziell für Adressregister. Es ist daher nicht möglich die
	Erweiterung .b zu verwenden.
	Es werden keine Flags geändert.

	Tipp: Verwenden Sie IMMER die Erweiterung .L

	Bsp:

	<ea>,An
		suba.l	d1,a0
		suba.l	a1,a0
		suba.l	(a1),a0
		suba.l	(a1)+,a0
		suba.l	-(a1),a0
		suba.l	$1234(a1),a0
		suba.l	$12(a1,d2.w),a0
		suba.l	$12(a1,d2.l),a0
		suba.l	$12(a1,a2.w),a0
		suba.l	$12(a1,a2.l),a0
		suba.l	$1234.w,a0
		suba.l	$12345678,a0
		suba.l	label(pc),a0
		suba.l	aa45(pc,d2.w),a0
		suba.l	aa45(pc,d2.l),a0
		suba.l	aa45(pc,a2.w),a0
		suba.l	aa45(pc,a2.l),a0

		suba.l	#$1234,a1	; Hinweis: Für die Subtraktion von
				; #unmittelbar von Ax-Adressregistern steht das
				; SUBA zur Verfügung und nicht das SUBI
				; Siehe den Kommentar zu ADDA für die
				; bedeutet von .w und .l
				; in diesem Fall.

***************************************************************** X N Z V C ***
SUBI     SUBtract Immediate                #x,<ea>     BWL        * * * * *

	Spezifische SUB-Version zum Subtrahieren eines #Immediate
	Die Flags werden entsprechend dem Ergebnis der Operation geändert.
	Das C (Carry)-Flag wird gesetzt, wenn die Subtraktion ein Darlehen ergibt
	(dh das Ergebnis "geht nicht in den Zieloperanden ein").

	Bsp:

	#x,<ea>
		subi.l	#$12345678,	d1		; Die Ziele wurden für bessere
		subi.b	#$12,		(a1)	; Lesbarkeit mit Abständen angegeben 
		subi.w	#$1234,		(a1)+	
		subi.w	#$1234,		-(a1)
		subi.b	#$12,		$1234(a1)
		subi.l	#$12345678,	$12(a1,d2.w)
		subi.w	#$1234,		$12(a1,d2.l)
		subi.b	#$12,		$12(a1,a2.w)
		subi.l	#$12345678,	$12(a1,a2.l)
		subi.b	#$12,		$1234.w
		subi.b	#$12,		$12345678

		suba.w	#$1234,a1	; Hinweis: Für die Subtraktion von
							; #unmittelbar von Ax-Adressregistern
							; ist SUBA vorhanden und nicht SUBI

***************************************************************** X N Z V C ***
SUBQ     SUBtract 3-bit immediate       #<data>,<ea>   BWL        * * * * *

	Es bedeutet SUB Quick, also schnelles Subtrahieren einer Zahl von 1 bis 8,
	das funktioniert genau wie das SUBI, deshalb ist es besser die, immer SUBQ 
	anstelle von SUBI für den Subtaktion für Zahlen von 1 bis 8 zu verwenden, da
	es diese speziellen Befehl gibt. Die Flags verhalten sich wie bei ADD / SUB:
	Das C (Carry)-Flag wird gesetzt, wenn die Subtraktion ein Darlehen ergibt
	(dh das Ergebnis "geht nicht in den Zieloperanden ein").
	Negativ = 1 wenn das Ergebnis negativ ist, Negativ = 0 wenn es positiv ist.
	oVerflow = 1 wenn das Ergebnis die Größe überschreitet .b, .w oder .l wie ADD
	Zero = 1 wenn das Ergebnis Null ist

	Bsp:

	#<data>,<ea>
		subq.b	#1,d1
		subq.w	#1,a1	; nicht möglich in .b auf Adressregister Ax!
		subq.w	#1,(a1)
		subq.b	#1,(a1)+
		subq.w	#1,-(a1)
		subq.l	#1,$1234(a1)
		subq.w	#1,$12(a1,d2.w)
		subq.b	#1,$12(a1,d2.l)
		subq.w	#1,$12(a1,a2.w)
		subq.b	#1,$12(a1,a2.l)
		subq.w	#1,$1234.w
		subq.l	#1,$12345678

***************************************************************** X N Z V C ***
SUBX     SUBtract eXtended                  Dy,Dx      BWL        * * * * *
                                         -(Ay),-(Ax)

	SUB-Befehl mit "erweiterter" Genauigkeit, da er den Quelloperanden und das
	eXtend-Bit vom Zieloperanden subtrahiert. Siehe ADDX.

	Bsp:

	Dy,Dx
		subx.w	d0,d1		; .b, .w und .l möglich 

	-(Ay),-(Ax)
		subx.w	-(a0),-(a1)	; .b, .w und .l möglich 


***************************************************************** X N Z V C ***
SWAP     SWAP words of Dn                    Dn        -W-        - * * 0 0

	Austausch der Worte eines Datenregisters. Wenn wir zum Beispiel 
	d0= $11223344 haben, nach einem swap, ist d0 = $33441122
	Das HOHE-Wort (Bits 16-31) wird mit dem NIEDRIGEN-Wort (Bits 0-15)
	vertauscht 

	Bsp:
		swap	d0

***************************************************************** X N Z V C ***
TRAP     Execute TRAP Exception           #<vector>               - - - - -

	Diese Anweisung wird verwendet, um Ausnahmen zu generieren, sie wird
	normalerweise verwendet, um Anweisungen im Supervisor-Modus auszuführen.

	Bsp:
		trap	#0

	Führt den Vektor unter der Adresse $80 aus.

***************************************************************** X N Z V C ***
TRAPV    TRAPV Exception if V-bit Set       TRAPV                 - - - - -

	Diese Anweisung löst eine Ausnahme (Exception) aus (Vektor $1c), aber nur,
	wenn zum Zeitpunkt der Ausführung das oVerflow-Bit = 1 ist.

	Bsp:
		trapv

***************************************************************** X N Z V C ***
TST      TeST for Negativ or zero          <ea>       BWL        - * * 0 0

	Diese Anweisung testet das Ziel und aktualisiert die Flags Negativ und Zero. 
	Es wird verwendet, um zu prüfen, ob der Operand Null oder negativ ist. Die
	Flags Carry und oVerflow-Flags werden gelöscht.

	Bsp:

	<ea>
		tst.w	d1		; Hinweis: Sie können keinen TST an einer Ax-Adresse
		tst.w	(a1)	; durchführen. "TST.W a0" ist unmöglich.
		tst.w	(a1)+
		tst.w	-(a1)
		tst.w	$1234(a1)
		tst.w	$12(a1,d2.w)
		tst.w	$12(a1,d2.l)
		tst.w	$12(a1,a2.w)
		tst.w	$12(a1,a2.l)
		tst.w	$1234.w
		tst.w	$12345678

*******************************************************************************

Jetzt eine Liste mit den Bedeutungen der GURU-MEDITATION-Meldungen, nur für
den Fall, dass Ihr Computer sich selbst zurücksetzt, wenn Sie ein Programm
ausführen, können Sie zumindest wissen, warum und welche Anweisung es war:

GURU $00000002	- BUS ERROR				($08)
GURU $00000003	- ADDRESS ERROR			($0C)
GURU $00000004	- ILLEGAL INSTRUCTION	($10)
GURU $00000005	- DIVISION BY ZERO		($14)
GURU $00000006	- CHK,CHK2				($18)	; auf 68020+
GURU $00000007	- TRAPV,TRAPCC			($1c)	; auf 68020+
GURU $00000008	- PRIVILEGE VIOLATION	($20)
GURU $00000009	- TRACE					($24)
GURU $0000000A	- LINEA EMULATOR 1010	($28)
GURU $0000000B	- LINEF EMULATOR 1111	($2c)

2) Bus error: Der Busfehler tritt auf, wenn auf fremde und nicht vorhandene 
	 Adressen zugegriffen wird, und oft ist es die MMU, die diesen Fehler
	 verursacht, in Computern, die ihn haben. (in geschützten Speicher schreiben)

3) Address error: Wenn Sie versuchen, ein Wort oder Langwort welches an einer
		 ungeraden Adresse gespeichert ist auszuführen oder zu lesen. z.B:

	move.l	#$4e754e75,label ; write.l an eine ungerade Adresse (auf 68020 ist
							; es möglich, das geht durch...)
	bra.s	label			; zu ungerader Adresse springen (diese GURU
	rts			; sogar auf einem 68020+, denn ab 68020
				; wurde es ermöglicht, move long
				; auch an ungeraden Adressen, aber es ist
				; immer "verboten", einen jmp  zu
				; ungeraden Adressen durchzuführen.

	dc.b	0	; ein Byte im Weg
label:
	dc.b	0,0,0,0	; ungerade Adresse!

4) Illegal instruction: Wenn binärer Code ausgeführt wird, der mit keinem
			Befehl des 680x0 übereinstimmt. Es kann auch mit dem
			entsprechenden "ILLEGAL"-Befehl generiert werden.

5) Division by 0: Es ist nicht möglich, eine Zahl durch Null zu teilen!!!

8) Privilege Violation: Wenn Sie versuchen, eine privilegierte Anweisung
			im USER-Modus anstelle des SUPERVISOR-Modus auszuführen.
			Zum Beispiel mit ANDI, ORI, MOVE auf dem SR arbeiten.

A) Linef Emulator 1010: Wenn Sie einen unbekannten Binärcode, der
			mit %1010 beginnt, also $Axxx. Die Anweisungen, die so
			beginnen existieren nicht, daher wird diese Ausnahme ausgelöst.

B) Linef Emulator 1111: Wenn Sie Binarcode ausführen, der mit $Fxxx beginnt.
			Einige der mathematischen Coprozessor-Anweisungen und von der mmu
			aber fangen so an. Während also auf einem Rechner ohne mmu/fpu
			diese Codes eine LINE-F-Ausnahme auslösen, könnten 
			68882/68851 Anweisungen ausgeführt werden.

*******************************************************************************

Eine Tabelle mit Potenzen von 2 könnte dienen ... (max: ein Langwort)

       2^n		n
  |_____________|_____________|
	2			1
	4			2
	8			3
	16			4
	32			5
	64			6
	128			7
	256			8
	512			9
	1024		10
	2048		11
	4096		12
	8192		13
	16384		14
	32768		15
	65536		16
	131072		17
	262144		18
	524288		19
	1048576		20
	2097152		21
	4194304		22
	8388608		23
	16777216	24
	33554432	25
	67108864	26
	134217728	27
	268435456	28
	536870912	29
	1073741824	30
	2147483648	31
	4294967296	32

*******************************************************************************

Abschließend finden Sie hier eine kurze Tabelle mit Optimierungen und
Ratschlägen, welche Anweisungen eher verwendet werden sollten als andere; es
wird ein ganzes Kapitel über Optimierungen geschrieben werden, aber jetzt
lernen Sie dieses Evangelium auswendig, besonders, wenn ich solche Anweisungen
wie "MOVE.L #label,a0" oder "add.w #4,d0" sehe, weine ich.


 ANWEISUNG Beispiel		| ÄQUIVALENT, ABER SCHNELLER
------------------------|-----------------------------------------------
add.X #6,XXX			| addq.X #6,XXX		(maximal 8)
sub.X #7,XXX			| subq.X #7,XXX		(maximal 8)
MOVE.X LABEL,XX			| MOVE.X LABEL(PC),XX	(wenn in gleicher SECTION)
LEA LABEL,AX			| LEA LABEL(PC),AX	(wenn in gleicher SECTION)
MOVE.L #30,d1			| moveq #30,d1		(min #-128, max #+127)
CLR.L d4				| MOVEQ #0,d4		(nur bei Datenregister)
ADD.X/SUB.X #12000,a3	| LEA (+/-)12000(a3),A3	(min -32768, max 32767)
MOVE.X #0,XXX			| CLR.X XXX			; move #0 ist dumm!
CMP.X  #0,XXX			| TST.X XXX			; das TST, wo Sie es lassen?
Per azzerare un reg. Ax	| SUBA.L A0,A0		; besser als "LEA 0,a0".
JMP/JSR	XXX				| BRA/BSR XXX		(wenn XXX nahe ist)
MOVE.X #12345,AX		| LEA 12345,AX		(nur Adress-Register!)
MOVE.L 0(a0),d0			| MOVE.L (a0),d0	(entfernt den Offset, wenn er 0 ist!!!)
LEA	(A0),A0				| HAHAHAHA! Entfernen Sie diese Anweisung, sie hat keine Wirkung!!
LEA	4(A0),A0			| ADDQ.W #4,A0		; sie hören nie auf zu lernen und
											; zu optimieren, was?

Die nachstehende Tabelle ist mit Vorsicht zu genießen, da die Anweisungen, die
als gleichwertig angegeben werden, nicht genau gleichwertig sind, insbesondere 
weil der Rest der Divisionen verloren geht. Es ist jedoch immer ratsam, zu
versuchen, ob man eine Multiplikation oder eine Division ersetzen kann, da 
sie die langsamsten Anweisungen überhaupt sind. Sie können die "Rechtfertigung"
der Gleichheit überprüfen, indem man die Tabelle der 2er-Potenzen zu Rate
zieht.

MULU.w	#2,d0		| ADD.l d0,d0 ; das scheint mir klar!
MULU.w	#4,d0		| LSL.l #2,d0 ; manchmal braucht es zuerst ein EXT.L D0
MULS.w	#4,d0		| ASL.l #2,d0 ; um jeglichen "Schmutz" im hohen Wort
MULS.w	#8,d0		| ASL.l #3,d0 ; zu beseitigen, was im Fall des MULS
MULS.w	#16,d0		| ASL.l #4,d0 ; nicht der Fall ist.
MULS.w	#32,d0		| ASL.l #5,d0 ; während es bei ASL
MULS.w	#64,d0		| ASL.l #6,d0 ; zusammen mit dem Rest verschoben wird.
MULS.w	#128,d0		| ASL.l #7,d0
MULS.w	#256,d0		| ASL.l #8,d0
DIVS.w	#2,d0		| ASR.L #1,d0	; Achtung: DEN REST IGNORIEREN!!!!!!!
DIVS.w	#4,d0		| ASR.L #2,d0
DIVS.w	#8,d0		| ASR.L #3,d0
DIVS.w	#16,d0		| ASR.L #4,d0
DIVS.w	#32,d0		| ASR.L #5,d0
DIVS.w	#64,d0		| ASR.L #6,d0
DIVS.w	#128,d0		| ASR.L #7,d0
DIVS.w	#256,d0		| ASR.L #8,d0
DIVU.w	#2,d0		| LSR.L #1,d0	; Achtung: DEN REST IGNORIEREN!!!!!!!!
DIVU.w	#4,d0		| LSR.L #2,d0
DIVU.w	#8,d0		| LSR.L #3,d0
DIVU.w	#16,d0		| LSR.L #4,d0
DIVU.w	#32,d0		| LSR.L #5,d0
DIVU.w	#64,d0		| LSR.L #6,d0
DIVU.w	#128,d0		| LSR.L #7,d0
DIVU.w	#256,d0		| LSR.L #8,d0

Wir haben diese Substitution erfolgreich in der Druck-Routine des Textes
in Listing8b.s verwendet, zum Beispiel:

	MULU.W	#8,d2

Das wurde umgewandelt in:

	LSL.W	#3,D2		; MULTIPLIZIEREN SIE DIE VORHERIGE ZAHL MIT 8,
						; die Zeichen sind 8 Pixel hoch

Nehmen wir einige Beispiele:

	muls.w	#4,d0

	kann ersetzt werden durch:

	ext.l	d0
	asl.l	#2,d0

	Manchmal ist EXT nicht erforderlich, wenn das High-Word von d0 gelöscht ist.

	-		-		-		-

Bedenken Sie schließlich, dass sie die AX- und Dx-REGISTER genau dafür erfunden
wurden, um sie voll zu nutzen. LOptimieren wir zum Beispiel eine Schleife wie
diese:

	move.w	#2000-1,d7	; Anzahl loops
Loop1:
	move.w	#$0234,$dff180
	move.w	#$0567,$dff182
	move.w	#$089a,$dff184
	move.w	#$0bcd,$dff186
	dbra	d7,Loop1
	rts

Achten Sie nicht auf die Nutzlosigkeit der Schleife, nehmen wir an, sie ist für
etwas gut, und das wir sie beschleunigen wollen: Hier ist eine anständige
 Beschleunigung:
 
	move.w	#$0234,d0
	move.w	#$0567,d1
	move.w	#$089a,d2
	move.w	#$0bcd,d3
	lea	$dff000,a0		; Basis für offsets
	move.w	#2000-1,d7	; Anzahl loops
Loop1:
	move.w	d0,$180(a0)
	move.w	d1,$182(a0)
	move.w	d2,$184(a0)
	move.w	d3,$186(a0)
	dbra	d7,Loop1
	rts

Diese Schleife ist TAUSEND mal schneller, weil das Verschieben eines Wertes aus
einem Dx-Datenregister schneller als ein "move #xxx,dest", auch der Zugriff
auf Adressen über Adressregister ist schneller als das Schreiben der Adresse
oder des Labels. Durch "Übertreiben" könnten wir mehr optimieren:


	move.w	#$0234,d0
	move.w	#$0567,d1
	move.w	#$089a,d2
	move.w	#$0bcd,d3
	lea	$dff180,a0
	lea	$dff182,a1
	lea	$dff184,a2
	lea	$dff186,a3
	move.w	#2000-1,d7	; Anzahl loops
Loop1:
	move.w	d0,(a0)
	move.w	d1,(a1)
	move.w	d2,(a2)
	move.w	d3,(a3)
	dbra	d7,Loop1
	rts

Wir haben jetzt 3 weitere Adressregister belegt, aber wir sparen die
Offsets, was die Geschwindigkeit noch weiter erhöht und die Größe des Codes
reduziert! Natürlich sind diese Optimierungen nur in Schleifen oder
Codeteilen nützlich die sehr oft ausgeführt werden.

