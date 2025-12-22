
ASSEMBLERKURS - LEKTION 13:  OPTIMIERUNG DES ASSEMBLER CODES

Author: Fabio Ciucci, Ugo Erra

Danksagung: Michael Glew, 2-Cool/LSD, Subhuman/Epsilon


Das Schreiben von Assembler-Routinen bedeutet nicht unbedingt, dass ihr eigener
Code mit voller Geschwindigkeit ausgeführt wird. In der Tat nicht immer kann
der Assemblercode als der beste in Bezug auf die erreichbare Geschwindigkeit
eingestuft werden. Betrachten wir die zahlreichen sich im Umlauf befindenden
Demos und genau diejenigen, die sich in den meisten Fällen mit 3D-Grafiken
beschäftigen. In den meisten Fällen (fast immer) sind die Routinen für Effekte
wie Rotationen, Zoom, Welterkundung usw. gleich, aber ihre Implementierung in
Assembler-Code ist anders, da jeder Programmierer versucht sie bestmöglich zu
implementieren, so dass sie mit maximaler Geschwindigkeit ausgeführt werden.
Dies wird durch Optimierungstechniken erreicht, die jeder gute Assemblercoder
kennen muss. Die Techniken sind zahlreich und sicherlich wird es einige Zeit
dauern, bis sie sie auf ganz natürliche Weise anwenden. Es gibt verschiedene
Arten der Optimierung und viele dieser Techniken, die ich erklären werde,
gelten für den 68000, aber die gleichen sind auch für Mikroprozessoren wie den
68040 oder 68060.
Das erste, was Sie zur Verfügung haben müssen, ist eine Tabelle mit den 
Prozessorzyklen jeder einzelnen 68000-Anweisung, die Sie in dieser Lektion
zusammengefasst finden.
Wenn Sie einen kurzen Blick auf diese Tabelle werfen, werden Sie vielleicht
erstaunt sein, wieviel "Zeit" für die Ausführung jedes Befehls benötigt wird,
und möglicherweise haben Sie bis zu diesem Punkt geglaubt, dass jede Anweisung
in der gleichen Zeit ausgeführt wird. Nun, sie haben sich geirrt!!!
Beachten Sie zunächst die Zeit, die eine Multiplikations-Anweisung (MULU) im
Vergleich zu einer Addition (ADD) benötigt und Sie werden sofort verstehen,
warum Optimierung wichtig ist:

	ADD				; Ausführungszeit: 6 bis 12+ Taktzyklen

	MULS			; Ausführungszeit: 70+ Taktzyklen

Daher ist es leicht zu verstehen, wie diese Anweisung optimiert werden kann:

langsam:		MULU.W	#2,D0		; 70+ Zyklen

optimiert:		ADD.W	d0,d0		; 6+ Zyklen

Ich gehe davon aus, dass Multiplikationen und Divisionen die beiden langsamsten
Anweisungen sind. Sehen wir uns eine ungefähre Liste der Befehle an, sortiert
vom schnellsten bis zum langsamsten: (Zyklen sind bestenfalls!)

EXT, SWAP, NOP, MOVEQ				; 4 Zyklen -> die schnellsten!

TST, BTST, ADDQ, SUBQ, AND, OR, EOR	; 4 + Adressierung, Geschwindigkeit...

MOVE, ADD, SUB, CMP, LEA			; 4+ Adressierung, aber oft sind die
									; Adressierungen "schwer" auszuführen

Dann haben wir BCLR/BCHG/BSET mit 8+, LSR/LSL/ASR/ASL/ROR/ROL mit 6 +2n, wobei
n die Anzahl der durchzuführenden Verschiebungen ist und schliesslich haben
wir:

	MULS/MULU		; 70+ !
	DIVU			; 140+ !!
	DIVS			; 158+ !!!

Es sollte auch daran erinnert werden:

	BEQ,BNE,BRA...	; 10
	DBRA			; 10
	BSR				; 18
	JMP				; 12
	RTS				; 16
	JSR				; 16/20

Achten Sie also darauf, nicht zu viele Unterprogrammaufrufe zu tätigen, da alle
BSR + RTS für die Rückkehr mindestens 18 + 16 = 34 Zyklen verbrauchen!
Wennn Sie immer kurze Unterprogramme in die Hauptschleife setzen, ist es eine
Verschwendung. Sie verlieren 34 Zyklen für BSR + RTS, um eine Handvoll
Anweisungen auszuführen!

EXAMPLE:
	BSR.S	ROUT1	; 18
	BSR.S	ROUT2	; 18
	BSR.S	ROUT3	; 18
	RTS

ROUT1:
	MOVE.W	d0,d1
	RTS				; 16
ROUT2:
	MOVEQ	#0,d2
	MOVEQ	#0,d3
	RTS				; 16
ROUT3:
	LEA	label1(PC),A0
	RTS				; 16

Diese Version spart 34 * 3 = 96 Zyklen:

EXAMPLEFIX:
	MOVE.W	d0,d1
	MOVEQ	#0,d2
	MOVEQ	#0,d3
	LEA	label1(PC),A0
	RTS

Neben dem Befehl selbst zählt auch die verwendete Adressierungsart.
Beispielsweise:

	MOVE.L	(a0),d0					; 12

ist schneller als:

	MOVE.L	$12(a0,d1.w),LABEL1		; 34

Dennoch handelt es sich um MOVE-Anweisungen. Es mag Ihnen jedoch logisch
erscheinen, warum die zweite Anweisung langsamer ist als die erste:
Der Prozessor muss den Offset berechnen, indem er den Wert von d1 plus $12
zu a0 addiert. Dazu macht er eine Kopie, und wo? Im Speicher mit einem Label,
anstatt in einem Register, das viel schneller ist, da die Register INNERHALB
des Prozessors sind, während der Speicher außerhalb liegt und um ihn zu
erreichen müssen die Daten durch die Leitungen der Hauptplatine laufen!!!!!

*****************************************************************************
* OPTIMIERUNGEN DER ERSTEN EBENE: "AUSTAUSCH" UND "AUSWAHL" DER ANWEISUNGEN *
*****************************************************************************

Hier sind die Adressierungsmodi vom schnellsten zum langsamsten sortiert:
Hinweis: die Zahlen nach dem "," sind die Taktzyklen, die zu der von der
Anweisung verwendeten Zeit hinzuzurechnen sind, bei Byte-Word/Longword die
Zeit, die der Befehl benötigt


Datenregister direkt									 Dn/An	    ; 0

Adressregister indirekt (oder mit Postinkrement) 		 (An)/(An)+ ; 4/8
unmittelbar												 #x			; 4/8

Adressregister indirekt mit Predekrement				-(An)	    ; 6/10

Adressregister  indirekt mit Offset (max 32767)			 w(An)	    ; 8/12
Absolut kurz											 w			; 8/12
Program Counter mit Offset (berechnet vom asmone)		 w(PC)	    ; 8/12

Program Counter mit Offset und Index					b(PC,Rx)    ; 10/14
Adressregister indirekt mit Offset und Index			b(An,Rx)    ; 10/14

Absolut lang											l			; 12/16


Wie Sie sehen, benötigt die Adressierung von "MOVE.L LABEL1,LABEL2" 16+16=32
Zyklen, ein "MOVE.L #1234,d0" beansprucht nur 8+0=8 Zyklen.
Es ist offensichtlich, dass .W-Anweisungen schneller sind als .L-Anweisungen,
zum Beispiel Adressierung (An), .W benötigt 4 Zyklen und .L 8 Zyklen!

Diese Beispiele sind jedoch SEHR indikativ, denn auch mit den Tabellen in der
Hand ist es schwierig, die wirkliche Ausführungszeit der Routine zu berechnen.
Wir sind aber immer sicher, dass ein BSR schneller als ein JSR ist, das ADDQ 
schneller als ADD ist und vor allem wenn es uns gelingt ein MULU/DIVU/MULS/DIVS
durch etwas anderes zu ersetzen, haben wir mit Sicherheit alles beschleunigt!

Wir sprechen hier von "Befehlsänderungen", d.h. kleinen Änderungen durch
Ersetzen langsamer Anweisungen durch schnellere. Aber die Kunst der
Optimierungen, die wahre Königin der Demo-Szene, beinhaltet auch die Verwendung
von "vorberechneten" Tabellen, anstatt eine Mega-Funktion zu implementieren,
die die gleichen Ergebnisse liefert und unzählige andere Dinge.

Aber es gibt auch den Nachteil: Mega-optimierter Code mit Tabellen und anderen 
Tricks sind oft weniger lesbar und verständlich und weniger "editierbar". Also,
vermeiden Sie den Fehler, in den viele von uns verfallen sind, zuerst die
Routine optimieren zu wollen, bevor sie sie Schritt für Schritt fertig erstellt
haben. Dies verlangsamt nur die Entwicklung der fraglichen Routine, besonders
wenn man Anfänger ist, denn was nützt eine mega-optimierte Routine, die die
Perspektive berechnet, wenn wir nicht mehr "drum herum" die Routine zum
Zeichnen und Drehen des Körpers schreiben können? Oder wir verstehen gar nicht
mehr warum sie funktioniert? 

---->>>>> NIEMALS MIT DER OPTIMIERUNG EINER ROUTINE BEGINNEN, WENN SIE NOCH
NICHT VOLLSTÄNDIG BEENDET IST UND FUNKTIONIERT.

Denken Sie bei der Optimierung daran, Kopien der verschiedenen Listings
aufzubewahren um Schritte der Optimierung "zurückzugehen"!!!
DANN WERDEN WIR DIE GEÄNDERTE VERSION ERNEUT OPTIMIEREN!

Diese Warnung wird Ihnen seltsam vorkommen, aber ein Listung, das einmal
optimiert wurde, ist selbst für den Autor oft unverständlich. Nun, wenn es SEHR
optimiert ist, kann das passieren! 

Denken Sie jedoch daran, dass Optimierungen in Teilen des Listings durchgeführt
werden müssen, deren Durchführung tatsächlich lange dauert: Zum Beispiel macht
es keinen Sinn, eine Routine zu optimieren, die nur einmal beim Start oder
einmal pro Frame ausgeführt wird. Die ersten Routinen, die optimiert werden
müssen, sind diejenigen, die viele Male pro Frame ausgeführt werden, dh die in
den dbra-Schleifen oder auf jeden Fall in verschiedenen Schleifen.
Zum Beispiel wie in diesem Listing:

Bau:
	cmp.w	#$ff,$dff006	; warten auf Wblank
	bne.s	Bau
	bsr.s	routine1
	bsr.s	routine2
	btst	#6,$bfe001		; warten auf die Maus
	bne.s	Bau
	rts

Routine1:
	move.w	#label2,d6
	move.w	d0,d1
	move.w	d2,d3
	and.w	d4,d5
	rts

Routine2:
	move.w	#200,d7
	lea	label2(PC),a0
	lea	label3(PC),a1
loop1:
	move.w	(a0)+,d0
	move.w	(a0)+,d1
	add.w	d0,d5
	add.w	d0,d6
	move.w	d5,(a1)+
	move.w	d5,(a2)+
	dbra	d7,loop1
	rts

In diesem Fall ist es offensichtlich, dass 99% der Zeit durch das 200-Mal
durchlaufen der Routine2 verloren geht. Folglich, wenn wir diese Schleife
optimiert haben, sodass sie doppelt so schnell läuft, würde das gesamte
Programm doppelt so schnell laufen, während, wenn die Geschwindigkeit der
Routine1 dreifach oder vierfach so schnell wäre, würden Sie den Unterschied
vielleicht nicht einmal bemerken!!!!!

Um zu sehen, wie viele "Rasterzeilen" eine Routine benötigt, verwenden Sie
einfach den coppermonitor, die alte Methode der Änderung der Farbe am Anfang
und am Ende der Routine. Auf diese Weise zeigt der "Streifen" die Zeit in
"Videozeilen" an, die für die Ausführung verwendet wurde:

Bau:
	cmp.w	#$90,$dff006	; warten auf Wblank
	bne.s	Bau
	bsr.s	routine1
	move.w	#$F00,$dff180	; Color0: rot
	bsr.s	routine2
	move.w	#$000,$dff180	; Color0: schwarz
	btst	#6,$bfe001		; warten auf die Maus
	bne.s	Bau
	rts

In diesem Fall warten wir auf die Zeile $90 in der Mitte des Bildschirms. Dann
führen wir Routine 1 aus, unwichtig, und dann ändern wir die Farbe (rot). Dann
führen wir die Routine2 aus und ändern die Farbe in (schwarz) zurück. Auf dem
Bildschirm erscheint ein roter Streifen ... das ist die "Zeit", in der die
Routine2 ausgeführt wird. Um zu sehen, ob sich die Geschwindigkeit verbessert
oder verschlechtert, genügt es zu sehen, ob der Streifen länger oder kürzer
wird.
Einige Verrückte (wie mein Freund, hedgehog) kleben ein Stück Klebeband auf den
Monitor in Höhe der letzten farbigen Zeile um bei jeder Änderung eine leichte
Verbesserung oder Verschlechterung festzustellen. Ich persönlich lege einen
Finger darauf oder schau mit dem Auge. Wir haben dieses System jedoch bereits
in der Blitter-Lektion und in Listing11n1.s und den Folgenden, um die Wartezeit
der CIAA / CIAB-Chip zu "visualisieren" gesehen. Übrigens können Sie auch die
Timer verwenden, um die Zeiten "numerisch" zu berechnen, aber das
Farbwechselsystem ist unkomplizierter.

Beginnen wir aber zunächst mit den elementaren Optimierungen, die Sie "beim
Schreiben" kennen sollten. Am einfachsten ist es zu wissen, welche Anweisung
unter den möglichen zu wählen ist, wenn man eine bestimmte Aufgabe erledigen
möchte. Tatsächlich kann ein und dieselbe Operation auf verschiedene Arten
ausgeführt werden!
Sehen wir uns zum Beispiel dieses Listing an:

	lea	LABEL1,a0
	move.l	0(a0),d0
	move.l	2(a0),d1
	ADD.W	#5,d0
	SUB.W	#5,d1
	MULU.W	#2,d0
	MOVE.L	#30,d2
	RTS

Dasselbe können Sie erreichen, indem Sie diese Anweisungen auswählen:

	lea	LABEL1(PC),a0	; schnellere (PC) Adressierung
	move.l	(a0),d0		; kein Offset 0 erforderlich !!
	move.l	2(a0),d1	; das bleibt so
	ADDQ.W	#5,d0		; Nummer kleiner als 8, Sie können ADDQ verwenden!
	SUBQ.W	#5,d1		; das Gleiche gilt für SUBQ!
	ADD.W	d0,d0		; spart 60 Zyklen!! D0*2 ist das gleiche wie D0+D0!!!
	MOVEQ	#30,d2		; Zahl kleiner als 127, ich kann MOVEQ verwenden!
	RTS

Die Routine ist viel schneller und immer noch gut lesbar. Also, als erstes gilt
es darauf zu achten, die entsprechenden Quick-Anweisungen zu verwenden, wie
z.B. ADDQ /SUBQ / MOVEQ, wenn die Zahl klein genug ist, Multiplikationen und
Divisionen zu entfernen wann immer es möglich ist, Adressierungen relativ zum
(PC) oder zu Registern + Offset zu verwenden anstelle der reinen LABEL, etc.
Mit ein wenig Erfahrung wird es für Sie selbstverständlich sein, die
schnelleren Anweisungen zu wählen, und Sie werden gleich beim ersten Mal wie
das zweite aufgeführte Listing schreiben, anstatt wie das erste aufgeführte
Listing, das Sie hoffentlich schon jetzt nicht mehr schreiben!!!!

Hier ist ein weiteres Beispiel für die Optimierung von "Swap" -Anweisungen:

	Move.l	#3,d0		; 12 Zyklen
	Clr.l	d0			; 6 Zyklen
	Add.l	#3,a0		; 16 Zyklen
;
	Move.l	#5,Label	; 28 Zyklen

Optimierte "Austausch"-Version:

	Moveq	#3,d0		; 4 Zyklen
	Moveq	#0,d0		; 4 Zyklen
	Addq.w	#3,a0		; 4 Zyklen
;
	Moveq	#5,d0		; 4 Zyklen
	Move.l	d0,Label	; 20 Zyklen, gesamt 24 Zyklen

Ich könnte mit solchen Beispielen noch lange weitermachen, aber Sie müssen
natürlich nicht alle möglichen Fälle auswendig kennen! Vielmehr ist es
notwendig, "die Methode", die Philosophie der optimierten Codierung, zu
verstehen. Es gibt zum Beispiel Techniken, um das Laden von 32 Bit-Werten
in Register zu beschleunigen:

	move.l	#$100000,d0	; 12 Zyklen

optimierte Version:

	moveq	#10,d0		; 4 Zyklen
	Swap	d0			; 4 Zyklen, insgesamt 8 Zyklen

Ein anderer SEHR WICHTIGER Punkt ist, dass der Zugriff auf den Speicher (dh auf
die Label) viel LANGSAMER ist als der Zugriff auf Daten- und Adressregister.
Daher ist es eine gute Angewohnheit, alle Register zu verwenden und Label so
wenig wie möglich zu berühren. Zum Beispiel dieses Listing:

	MOVE.L	#200,LABEL1
	MOVE.L	#10,LABEL2
	ADD.L	LABEL1,LABEL2

Sie können VIEL optimieren, indem Sie schreiben :

	move.l	#200,d0
	moveq	#10,d1
	add.l	d0,d1

Achten Sie nicht auf die Dummheit des Beispiels, sondern auf die Tatsache, dass 
während wir im ersten Beispiel 4 Zugriffe auf den sehr langsamen RAM gemacht
haben, indem wir die Daten über die wirren Drähte der Hauptplatine geleitet
haben, wurde im zweiten Fall alles in der CPU erledigt, was das ganze
beschleunigt. Wenn Ihnen die Datenregister ausgehen, verwenden Sie auch die
Adressregister, um Daten zu speichern, anstatt auf Label zuzugreifen! Verwenden
Sie nach Möglichkeit auch .w anstelle von .l-Anweisungen, z.B. das Listing oben
könnte neu optimiert werden:

	move.w	#200,d1
	moveq	#10,d0
	add.w	d0,d1

In diesem Fall belegen die Anweisungen 8 statt 12 Zyklen ... und das ist nicht
wenig! Aber achten Sie darauf, dass das hohe Wort zurückgesetzt wird und / oder
nie gebraucht wird!!

Die profitabelsten "Austausch"-Optimierungen sind jedoch diejenigen, die die
Multiplikations- (70 Zyklen) und Divisionsanweisungen (158 Zyklen) eliminieren
und man kann sagen, dass in dieser Hinsicht eine Wissenschaft darüber
entstanden ist.
Der einfachste Fall ist, wenn wir Zahlen mit Potenzen von 2 dividieren oder
multiplizieren müssen, weil wir dann Shiftanweisungen verwenden können die,
genau so viele Zyklen benötigen, wie unten angegeben:

	lsl.w	6+2n		; n = Anzahl der Verschiebungen
	asr.w	6+2n
	lsr.l	8+2n
	asr.l	8+2n

Hier gibt n die Anzahl der Bits an und die Anzahl der Zyklen bezieht sich
darauf, wenn die Register verwendet werden.
Die zu befolgende Regel ist im Allgemeinen die folgende: (für MULS oder MULU)

Hinweis: Manchmal wird ein EXT.L D0 vor den ASLs, die die MULS ersetzen,
verwendet, während vor den ASLs, die die MULUs ersetzen, eine Reinigung des 
hohen Wortes mit "swap d0, clr.w d0, swap d0" erforderlich sein kann.

MULS.w	#2,d0		| ADD.L d0,d0 ; das scheint mir klar zu sein!

MULS.w	#4,d0		| ADD.L d0,d0 ; das auch!
					| ADD.L d0,d0

MULS.w	#8,d0		| ASL.l #3,d0 ; von 8 bis 256 ist ASL praktisch
MULS.w	#16,d0		| ASL.l #4,d0
MULS.w	#32,d0		| ASL.l #5,d0
MULS.w	#64,d0		| ASL.l #6,d0
MULS.w	#128,d0		| ASL.l #7,d0
MULS.w	#256,d0		| ASL.l #8,d0

Wenn es Probleme mit den MULUs gibt, kann das hohe Wort bereinigt werden:

mulu.w #n,dx ->	swap dx				; n ist 2^m, 2..2^8
				clr.w dx			; (2,4,8,16,32,64,128,256)
				swap dx
				asl.l #m,dx

Bei den MULS kann es genügen, ein "ext.l" vor das asl zu setzen.

muls #n,dx ->	ext.l dx			; n ist 2^m, 2..2^8
				asl.l #m,dx

Während für die DIVISIONEN:

DIVS.w	#2,d0		| ASR.L #1,d0	; Achtung: Ignorieren Sie den Rest!!
DIVS.w	#4,d0		| ASR.L #2,d0
DIVS.w	#8,d0		| ASR.L #3,d0
DIVS.w	#16,d0		| ASR.L #4,d0
DIVS.w	#32,d0		| ASR.L #5,d0
DIVS.w	#64,d0		| ASR.L #6,d0
DIVS.w	#128,d0		| ASR.L #7,d0
DIVS.w	#256,d0		| ASR.L #8,d0

DIVU.w	#2,d0		| LSR.L #1,d0	; Achtung: Ignorieren Sie den Rest!!
DIVU.w	#4,d0		| LSR.L #2,d0
DIVU.w	#8,d0		| LSR.L #3,d0
DIVU.w	#16,d0		| LSR.L #4,d0
DIVU.w	#32,d0		| LSR.L #5,d0
DIVU.w	#64,d0		| LSR.L #6,d0
DIVU.w	#128,d0		| LSR.L #7,d0
DIVU.w	#256,d0		| LSR.L #8,d0

Wie Sie wissen, bleibt nach einer Division das Ergebnis im niedrigen Wort und
der Rest im hohen Wort. Wenn Sie stattdessen die DIVS / DIVU durch eine
Verschiebung ersetzen, steht das Ergebnis im niedrigen Wort und das hohe Wort
wird auf Null zurückgesetzt... es ist also NICHT DAS GLEICHE, seien Sie
vorsichtig!
Im ungünstigsten Fall, wenn n=8 ist, erhalten Sie genau eine Anzahl von
6+2*8=22 Zyklen für Wörter und 8+2*8=24 Zyklen für Langwörter, so dass die
Einsparungen garantiert sind. Sie sollten auch wissen, dass bei einem 68020 die
Anzahl der Zyklen für die Shift-Anweisungen unabhängig von der Anzahl der
Verschiebungen gleich ist.
Denken Sie auch daran, das die Durchführung der Swap-Anweisung 4 Zyklen dauert,
was in vielen Situationen, in denen die Anzahl der zu verschiebenden Bits groß
ist nützlich sein kann. Lassen Sie uns in diesem Zusammenhang einige Beispiele
ansehen:

; 9 Bit Links-Verschiebung

	Lsl.l	#8,d0
	Add.l	d0,d0

; 16 Bit Links-Verschiebung

	Swap	d0
	Clr.w	d0

; 24 Bit Links-Verschiebung

	Swap	d0
	Clr.w	d0
	Lsl.l	#8,d0

; 16 Bit Rechts-Verschiebung

	Clr.w	d0
	Swap	d0

; 24 Bit Rechts-Verschiebung

	Clr.w	d0
	Swap	d0
	Lsr.l	#8,d0

Wie Sie sehen, fehlt es nicht an Techniken für die Verschiebung und sie können
eine Menge davon bekommen. Wie immer liegt es an Ihnen, in die richtige
Perspektive einzunehmen und zu versuchen, die gewünschte Optimierung
vorzunehmen. Also für Potenzen von 2 haben sie kein großes Problem in einer
angemessenen Zeit zu multiplizieren und zu dividieren.
Probleme könnten entstehen, wenn die Zahl keine Zweierpotenz ist, das ist zwar
richtig, aber für viele Werte können wir immer noch um das Problem umgehen.
Betrachten wir den Fall, in dem wir den in einem Register enthaltenen Wert mit
3 multiplizieren. Denken sie daran, dass Sie einen Ausdruck wie 3*x, auch als
2*x+x schreiben können. An diesem Punkt haben Sie Ihr Problem gelöst, weil:

Ihr Code lautet wird:

	Move.l	d0,d1
	Add.l	d0,d0 ; d0=d0*2
	Add.l	d1,d0 ; d0=(d0*2)+d0

Betrachten wir einen anderen Fall zum Beispiel für n=5, dann haben wir 5*x,
also 4*x+x: Als Code erhalten wir das:

	Move.l	d0,d1
	Asl.l	#2,d0 ; d0=d0*4
	Add.l	d1,d0 ; d0=(d0*4)+d0

Betrachten Sie schließlich einen anderen Fall, in dem n=20 ist, dann haben
wir 20*x, aber 20*x=4*(5*x)=4*(4*x+x)

	Move.l	d0,d1
	Asl.l	#2,d0 ; d0=d0*4
	Add.l	d1,d0 ; d0=(d0*4)+d0
	Asl.l	#2,d0 ; d0=4*((d0*4)+d0)

Kurz gesagt, können wir versuchen, die Zahl in Primfaktoren aufzulösen und
feststellen wie viele 2en es gibt, aber immer auch eine kleine Notiz über
die Anzahl der Zyklen notieren, um zu sehen, ob es zu uns passt oder nicht.
Viele von Ihnen sind vielleicht überrascht, dass die Optimierung eines
einfachen MULU oder DIVU hier behandelt wird, aber denken Sie an die Fälle, in
denen diese in Schleifen stehen, in diesem Fall sind diese Techniken wirklich
sehr nützlich, aber selbst wenn die MULU nicht nicht in einer Schleife steht,
was kostet es Sie, sie durch etwas Besseres zu ersetzen?
Da wir gerade beim Thema sind, lassen Sie uns kurz über die Implementierung 
von Ausdrücken in Assember sprechen. Was ich Ihnen sagen werde, ist nichts
Besonderes, aber oft wird einer trivialen Tatsache keine Beachtung geschenkt.
Wenn wir eine Funktion implementieren müssen, tun wir dies normalerweise
in dem wir die Werte in die Register laden und alle Operationen ausführen.
Um Prozessorzeit bei der Berechnung der Funktionen zu sparen, ist es besser,
mathematische Terme zusammenzufassen, so wie sie es in der Schule gelernt
haben.

In der Tat betrachten wir einen trivialen Ausdruck:

a*d0+b*d1+a*d3+b*d5 kann geschrieben werden als:

a*(d0+d3)+b*(d1+d5)

Auf diese Weise sparen wir zwei Multiplikationen.

Um die richtige Anweisung zu wählen, muss man nur wissen, welche von zwei
gleichwertigen Anweisungen die schnellste ist. Ich präsentiere eine ähnliche
Tabelle wie die am Ende von 68000-2.txt, mit "langsamen" Befehlen und
"schnellen" Äquivalenten, die zu verwenden sind:

 ANWEISUNG Beispiel		| ÄQUIVALENT, ABER SCHNELLER
------------------------|-----------------------------------------------
add.X #6,XXX			| addq.X #6,XXX		(maximal 8)
sub.X #7,XXX			| subq.X #7,XXX		(maximal 8)
MOVE.X LABEL,XX			| MOVE.X LABEL(PC),XX	(wenn in der gleichen SECTION)
LEA LABEL,AX			| LEA LABEL(PC),AX	(wenn in der gleichen SECTION)
MOVE.L #30,d1			| moveq #30,d1		(min #-128, max #+127)
CLR.L d4				| MOVEQ #0,d4		(nur für Datenregister)
ADD.X/SUB.X #12000,a3	| LEA (+/-)12000(a3),A3	(min -32768, max 32767)
MOVE.X #0,XXX			| CLR.X XXX			; #0 zu bewegen ist dumm!
CMP.X  #0,XXX			| TST.X XXX			; das TST, wo Sie es verlassen?
Reg. Ax	zurücksetzen	| SUB.L A0,A0		; besser als "LEA 0,a0"		
JMP/JSR	XXX				| BRA/BSR XXX		(wenn XXX in der Nähe ist)
MOVE.X #label,AX		| LEA label,AX		(nur Adressregister!)
MOVE.L 0(a0),d0			| MOVE.L (a0),d0	(Offset entfernen, wenn es 0 ist!!!)
LEA	(A0),A0				| HAHAHAHA!         ; es hat keine Wirkung!!
LEA	4(A0),A0			| ADDQ.W #4,A0		; bis zu 8
addq.l #3,a0			| addq.w #3,a0		; nur Adressregister , max 8
Bcc.W label				| Bcc.S label       ; Beq,Bne,Bsr... dist. <128

Für Multiplikationen und Divisionen mit Vielfachen von 2, umgerechnet in
ASL / ASR, siehe die Tabelle oben.

Hier sind einige Sonderfälle, um MULS / MULU in etwas anderes zu ändern:

Hinweis: Wenn es sich um ein "MULS" handelt, ist es of notwendig, "ext.l dx"
als erste Anweisung hinzuzufügen, um das Vorzeichen auf Langwort zu erweitern.

mul*.w #3,dx -> move.l dx,ds
				add.l dx,dx
				add.l ds,dx
------------------------------------
mul*.w #5,dx -> move.l dx,ds
				asl.l #2,dx
				add.l ds,dx
------------------------------------
mul*.w #6,dx -> add.l dx,dx
				move.l dx,ds
				add.l dx,dx
				add.l ds,dx
------------------------------------
mul*.w #7,dx -> move.l dx,ds
				asl.l #3,dx
				sub.l ds,dx
------------------------------------
mul*.w #9,dx -> move.l dx,ds
				asl.l #3,dx
				add.l ds,dx
------------------------------------
mul*.w #10,dx -> add.l dx,dx
				move.l dx,ds
				asl.l #2,dx
				add.l ds,dx
------------------------------------
mul*.w #12,dx -> asl.l #2,dx
				move.l dx,ds
				add.l dx,dx
				add.l ds,dx
------------------------------------
mulu.w #12,dx -> swap dx	; HEI! oft ist es notwendig, das hohe Wort für 
				clr.w dx	; MULUs zurückzusetzen ... beachten Sie dies auch... 
				swap dx		; für mulu #3, #5, #6 ....

				asl.l #2,dx		; normale mulu #12
				move.l dx,ds
				add.l dx,dx
				add.l ds,dx
------------------------------------

Wenn Sie das hohe Wort der Register mehrmals zurücksetzen müssen, können Sie
auch Folgendes verwenden:

	move.l	#$0000FFFF,ds	; 1 Register wird benötigt, um $FFFF zu halten

	and.l	ds,dx			; das ist schneller als tauschen, aber
			; erfordert ein Register, das $0000FFFF enthält,
			; andernfalls ist "AND.L #$FFFF,dx" nicht schneller ...

Zusammenfassend kann man sagen, dass es im Fall von MULS, da es 
vorzeichenbehafted ist, notwendig sein kann, das sie am Anfang ein "EXT.L"
machen müssen. 
Andererseits kann es im Falle von MULUs hingegen erforderlich sein, das das
hohe Wort des Registers zurückzusetzen.

zusammengefasst:

asl.x #2,dy -> 	add.x dy,dy
				add.x dy,dy
------------------------------------
asl.l #16,dx -> swap dx
				clr.w dx
------------------------------------
asl.w #2,dy -> 	add.w dy,dy
				add.w dy,dy
------------------------------------
asl.x #1,dy -> 	add.x dy,dy
------------------------------------
asr.l #16,dx -> swap dx
				ext.l dx
------------------------------------
bsr label -> 	bra label
				rts
------------------------------------
clr.x n(ax,rx) -> move.x ds,n(ax,rx)	; ds muss natürlich 0 sein!
------------------------------------
lsl.l #16,dx -> swap dx
				clr.w dx
------------------------------------
move.b #-1,(ax) -> st (ax)
------------------------------------
move.b #-1,dest -> st dest
------------------------------------
move.b #x,mn ->	move.w #xy,mn
				move.b #y,mn+1
------------------------------------
move.x ax,ay -> lea n(ax),ay			; -32767 <= n <= 32767
				add.x #n,ay
------------------------------------
move.x ax,az -> lea n(ax,ay),az			;  az=n+ax+ay, n<=32767
				add.x #n,az
				add.x ay,az
------------------------------------
sub.x #n,ax -> 	lea -n(ax),ax			; -32767 <= n <= -9, 9 <= n <= 32767
------------------------------------

An dieser Stelle sehen Sie die Ausführungszeit der verschiedenen Anweisungen.
Zur Ausführungszeit des Befehls muss die für die verschiedenen Adressierungen
aufgewendete Zeit addiert werden, deren Ausführungszeit wir bereits gesehen
haben. Beachten Sie, dass dies die normalen 68000 Ausführungszeiten sind!
Zum Beispiel werden im 68040 die MULS/MULUs über Hardware implementiert und
benötigen daher weniger Zyklen!

>>>				MOVE.B und MOVE.W				   <<<

+-------------+---------------------------------------------------------------+
|             |                           ZIEL		                          |
+   QUELLE    +---------------------------------------------------------------+
|             | Dn | An |(An)|(An)+|-(An)|(d16,An)|(d8,An,Xn)*|(xxx.W)|(xxx).L|
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
| Dn / An     | 4  | 4  | 8  |  8  |  8  |   12   |    14     |  12   |  16   |
| (An)        | 8  | 8  | 12 | 12  | 12  |   16   |    18     |  16   |  20   |
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
| (An)+       | 8  | 8  | 12 | 12  | 12  |   16   |    18     |  16   |  20   |
| -(An)       | 10 | 10 | 14 | 14  | 14  |   18   |    20     |  18   |  22   |
| (d16,An)    | 12 | 12 | 16 | 16  | 16  |   20   |    22     |  20   |  24   |
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
| (d8,An,Xn)* | 14 | 14 | 18 | 18  | 18  |   22   |    24     |  22   |  26   |
| (xxx).W     | 12 | 12 | 16 | 16  | 16  |   20   |    22     |  20   |  24   |
| (xxx).L     | 16 | 16 | 20 | 20  | 20  |   24   |    26     |  24   |  28   |
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
| (d16,PC)    | 12 | 12 | 16 | 16  | 16  |   20   |    22     |  20   |  24   |
| (d8,PC,Xn)* | 14 | 14 | 18 | 18  | 18  |   22   |    24     |  22   |  26   |
| #(data)     | 8  | 8  | 12 | 12  | 12  |   16   |    18     |  16   |  20   |
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
* Die Größe des Indexregisters (Xn) (.w oder .l) ändert nichts an der
 Geschwindigkeit.

>>>				    MOVE.L			   <<<

+-------------+---------------------------------------------------------------+
|             |                           ZIEL		                          |
+   QUELLE    +---------------------------------------------------------------+
|             | Dn | An |(An)|(An)+|-(An)|(d16,An)|(d8,An,Xn)*|(xxx.W)|(xxx).L|
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
| Dn o  An    | 4  | 4  | 12 | 12  | 12  |   16   |    18     |  16   |  20   |
| (An)        | 12 | 12 | 20 | 20  | 20  |   24   |    26     |  24   |  28   |
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
| (An)+       | 12 | 12 | 20 | 20  | 20  |   24   |    26     |  24   |  28   |
| -(An)       | 14 | 14 | 22 | 22  | 22  |   26   |    28     |  26   |  30   |
| (d16,An)    | 16 | 16 | 24 | 24  | 24  |   28   |    30     |  28   |  32   |
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
| (d8,An,Xn)* | 18 | 18 | 26 | 26  | 26  |   30   |    32     |  30   |  34   |
| (xxx).W     | 16 | 16 | 24 | 24  | 24  |   28   |    30     |  28   |  32   |
| (xxx).L     | 20 | 20 | 28 | 28  | 28  |   22   |    34     |  32   |  36   |
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
| (d,PC)      | 16 | 16 | 24 | 24  | 24  |   28   |    30     |  28   |  32   |
| (d,PC,Xn)*  | 18 | 18 | 26 | 26  | 26  |   30   |    32     |  30   |  34   |
| #(data)     | 12 | 12 | 20 | 20  | 20  |   24   |    26     |  24   |  28   |
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
* Die Größe des Indexregisters (Xn) (.w oder .l)ändert nichts an der
 Geschwindigkeit.

Und jetzt die anderen Anweisungen.
Anmerkung:

#  - Operand unmittelbar
An - Adressregister
Dn - Datenregister
ea - ein Operand, der durch eine tatsächliche Adresse angegeben wird
M  - effektive Adresse
+  - Addition der Zeit für die Berechnung der Adresse (Adressierung)

+-------------+-----------+------------+-----------+-----------+
| Instruct.	  |   Size    | op<ea>,An¹ | op<ea>,Dn | op Dn,<M> |
+-------------+-----------+------------+-----------+-----------+
|             | Byte,Word |     8+     |     4+    |     8+    |
|  ADD/ADDA   +-----------+------------+-----------+-----------+
|             |   Long    |     6+     |     6+    |    12+    |
+-------------+-----------+------------+-----------+-----------+
|             | Byte,Word |     -      |     4+    |     8+    |
|  AND        +-----------+------------+-----------+-----------+
|             |   Long    |     -      |     6+    |    12+    |
+-------------+-----------+------------+-----------+-----------+
|             | Byte,Word |     6+     |     4+    |     -     |
|  CMP/CMPA   +-----------+------------+-----------+-----------+
|             |   Long    |     6+     |     6+    |     -     |
+-------------+-----------+------------+-----------+-----------+
|  DIVS       |     -     |     -      |   158+    |     -     |
+-------------+-----------+------------+-----------+-----------+
|  DIVU       |     -     |     -      |   140+    |     -     |
+-------------+-----------+------------+-----------+-----------+
|             | Byte,Word |     -      |     4     |     8+    |
|  EOR        +-----------+------------+-----------+-----------+
|             |   Long    |     -      |     8     |    12+    |
+-------------+-----------+------------+-----------+-----------+
|  MULS/MULU  |     -     |     -      |    70+    |     -     |
+-------------+-----------+------------+-----------+-----------+
|             | Byte,Word |     -      |     4+    |     8+    |
|  OR         +-----------+------------+-----------+-----------+
|             |   Long    |     -      |     6+    |    12+    |
+-------------+-----------+------------+-----------+-----------+
|             | Byte,Word |     8+     |     4+    |     8+    |
|  SUB        +-----------+------------+-----------+-----------+
|             |   Long    |     6+     |     6+    |    12+    |
+-------------+-----------+------------+-----------+-----------+

+-------------+-----------+---------+---------+--------+
| Instruct.   |   Size    | op #,Dn | op #,An | op #,M |
+-------------+-----------+---------+---------+--------+
|             | Byte,Word |    8    |    -    |   12+  |
|  ADDI       +-----------+---------+---------+--------+
|             |   Long    |    16   |    -    |   20+  |
+-------------+-----------+---------+---------+--------+
|             | Byte,Word |    4    |    4    |    8+  |
|  ADDQ       +-----------+---------+---------+--------+
|             |   Long    |    8    |    8    |   12+  |
+-------------+-----------+---------+---------+--------+
|             | Byte,Word |    8    |    -    |   12+  |
|  ANDI       +-----------+---------+---------+--------+
|             |   Long    |   14    |    -    |   20+  |
+-------------+-----------+---------+---------+--------+
|             | Byte,Word |    8    |    -    |    8+  |
|  CMPI       +-----------+---------+---------+--------+
|             |   Long    |   14    |    -    |   12+  |
+-------------+-----------+---------+---------+--------+
|             | Byte,Word |    8    |    -    |   12+  |
|  EORI/SUBI  +-----------+---------+---------+--------+
|             |   Long    |   16    |    -    |   20+  |
+-------------+-----------+---------+---------+--------+
|  MOVEQ      |   Long    |    4    |    -    |   -    |
+-------------+-----------+---------+---------+--------+
|             | Byte,Word |    8    |    -    |   12+  |
|  ORI        +-----------+---------+---------+--------+
|             |   Long    |   16    |    -    |   20+  |
+-------------+-----------+---------+---------+--------+
|             | Byte,Word |    4    |    8    |    8+  |
|  SUBQ       +-----------+---------+---------+--------+
|             |   Long    |    8    |    8    |   12+  |
+-------------+-----------+---------+---------+--------+

+-------------+-----------+----------+--------+
| Instruct.   |   Size    | Register | Memory |
+-------------+-----------+----------+--------+
|  NBCD       |   Byte    |    6     |    8+  |
+-------------+-----------+----------+--------+
|             | Byte,Word |    4     |    8+  |
|  CLR/NEG    +-----------+----------+--------+
|  NEGX/NOT   |   Long    |    6     |   12+  |
+-------------+-----------+----------+--------+
|             | Byte,False|    4     |    8+  |
|  Scc        +-----------+----------+--------+
|             | Byte,True |    6     |    8+  |
+-------------+-----------+----------+--------+
|  TAS        |   Byte    |    4     |   14+  |
+-------------+-----------+----------+--------+
|  TST   | Byte,Word,Long |    4     |    4+  |
+-------------+-----------+----------+--------+
|  LSR/LSL    | Byte,Word |  6 + 2n  |   8+   |
|  ASR/ASL    +-----------+----------+--------+
|  ROR/ROL    |   Long    |  8 + 2n  |   -    |
|  ROXR/ROXL  |           |          |        |
+-------------+-----------+----------+--------+
Hinweis: n ist die Anzahl der Shifts!

Bit Manipulation Anweisung Ausführungszeit
+-------------+-----------+-------------------+-------------------+
|             |           |       Dynamic     |       Static      |
| Instruct.   |   Size    +----------+--------+----------+--------+
|             |           | Register | Memory | Register | Memory |
+-------------+-----------+----------+--------+----------+--------+
|             |   Byte    |    -     |   8+   |    -     |  12+   |
|  BCHG/BSET  +-----------+----------+--------+----------+--------+
|             |   Long    |    8     |   -    |    12    |   -    |
+-------------+-----------+----------+--------+----------+--------+
|             |   Byte    |    -     |   8+   |    -     |  12+   |
|  BCLR       +-----------+----------+--------+----------+--------+
|             |   Long    |   10     |   -    |    14    |   -    |
+-------------+-----------+----------+--------+----------+--------+
|             |   Byte    |    -     |   4+   |    -     |   8+   |
|  BTST       +-----------+----------+--------+----------+--------+
|             |   Long    |    6     |   -    |    10    |   -    |
+-------------+-----------+----------+--------+----------+--------+

+-------------+-------------------+--------+-----------+
|             |                   | Branch |  Branch   |
| Instruct.   |   Displacement    | Taken  | Not Taken |
+-------------+-------------------+--------+-----------+
|             |       Byte        |   10   |     8     |
|  Bcc        +-------------------+--------+-----------+
|             |       Word        |   10   |    12     |
+-------------+-------------------+--------+-----------+
|             |       Byte        |   10   |     -     |
|  BRA        +-------------------+--------+-----------+
|             |       Word        |   10   |     -     |
+-------------+-------------------+--------+-----------+
|  BSR        |     Byte,word     |   18   |     -     |
+-------------+-------------------+--------+-----------+
|             |      cc true      |   -    |    12     |
|             +-------------------+--------+-----------+
|             |  cc false, Count  |        |     _     |
|  DBcc       |    Not Expired    |   10   |           |
|             +-------------------+--------+-----------+
|             | cc false, Counter |   _    |           |
|             |      Expired      |        |    14     |
+-------------+-------------------+--------+-----------+

+----+----+---+-----+-----+--------+-----------+------+-------+-------+-------+
|Ins.|Sz|(An)|(An)+|-(An)|(d16,An)|(d8,An,Xn)+|(x).W|(x).L|(d16,PC)|(d8,PC,Xn)*
+----+---+----+-----+-----+-------+-----------+-----+-----+--------+----------+
| JMP| -  | 8  |  -  | -  |  10   |   14      | 10  | 12  |  10    |    14    |
+----+----+----+-----+----+-------+-----------+-----+-----+--------+----------+
| JSR| -  | 16 |  -  | -  |  18   |   22      | 18  | 20  |  18    |    22    |
+----+----+----+-----+----+-------+-----------+-----+-----+--------+----------+
| LEA| -  | 4  |  -  | -  |  8    |   12      |  8  | 12  |  8     |    12    |
+----+----+-----+-----+----+------+-----------+-----+-----+--------+----------+
| PEA| -  | 12  |  -  | -  |  16  |   20      | 16  | 20  |  16    |    20    |
+-----+----+-----+-----+----+-----+-----------+-----+-----+--------+----------+
|     |Word|12+4n|12+4n| _  |16+4n|  18+4n    |16+4n|20+4n| 16+4n  |  18+4n   |
|     |    |     |     |    |     |           |     |     |        |          |
|MOVEM+----+-----+-----+----+-----+-----------+-----+-----+--------+----------+
|M->R |Long|12+8n|12+8n| _  |16+8n|  18+8n    |16+8n|20+8n| 16+8n  |  18+8n   |
|     |    |     |     |    |     |           |     |     |        |          |
+-----+----+-----+-----+----+-----+-----------+-----+-----+--------+----------+
|     |Word| 8+4n|  _  |8+4n|12+4n|  14+4n    |12+4n|16+4n|   _    |    _     |
|     |    |     |     |    |     |           |     |     |        |          |
|MOVEM+----+-----+-----+----+-----+-----------+-----+-----+--------+----------+
|R->M |Long| 8+8n|  _  |8+8n|12+8n|  14+8n    |12+8n|16+8n|   _    |    _     |
|     |    |     |     |    |     |           |     |     |        |          |
+-----+----+-----+-----+----+-----+-----------+-----+-----+--------+----------+
Hinweis: n ist die Anzahl der zu verschiebenden Register.


EXT/SWAP/NOP	4
EXG				6
UNLK			12
LINK/RTS		16
RTE				20

Bedenken Sie schließlich, dass Ausnahmen 44 Zyklen dauern, wenn es sich um 
einen Interrupt handelt, 34 wenn es sich um einen TRAP handelt. Plus 20 für die
RTE !!! Ich empfehle, eine Optimierung IMMER zu kommentieren, zum Beispiel wenn
Sie diese Routine optimieren wollen:

	movem.l	label1(PC),d1-d4
	mulu.w	#16,d1
	mulu.w	#3,d2
	muls.w	#5,d3
	divu.w	#8,d4
	rts

Durch die Optimierung wäre das Ergebnis:

	movem.l	label1(PC),d1-d4
	asl.l	#4,d1		; mulu.w #16,d1
	move.l	d2,d5		; \
	add.l	d2,d2		;  > mulu.w #3,d2
	add.l	d5,d2		; /
	move.l	d3,d5		; \
	asl.l	#2,d3		;  > muls.w #5,d3
	add.l	d5,d3		; /
	asr.l	#3,d4		; divu.w #8,d4
	rts

Zusätzlich zur Verwendung des d5-Registers haben wir das Lesen des Listings 
erschwert. Wäre es auf den ersten Blick verständlich was mit den Registern
d1, d2, d3 und d4 passiert, wenn wir die Kommentare nicht hingeschrieben
hätten? Und stellen Sie sich vor, wir müssten auch das hohe Wort vor den MULUs
bereinigen und es vor den MULS verlängern:

	movem.l	label1(PC),d1-d4
	swap	d1
	clr.w	d1
	swap	d1
	asl.l	#4,d1
	swap	d2
	clr.w	d2
	swap	d2
	move.l	d2,d5
	add.l	d2,d2
	add.l	d5,d2
	ext.l	d3
	move.l	d3,d5
	asl.l	#2,d3
	add.l	d5,d3
	asr.l	#3,d4
	rts

Oder Sie können das hohe Wort auf die schnellste Weise zurücksetzen:

	move.l	#$FFFF,d6
	...
	movem.l	label1(PC),d1-d4
	and.l	d6,d1
	asl.l	#4,d1
	and.l	d6,d2
	move.l	d2,d5
	add.l	d2,d2
	add.l	d5,d2
	ext.l	d3
	move.l	d3,d5
	asl.l	#2,d3
	add.l	d5,d3
	asr.l	#3,d4
	rts

Wenn Sie nach einem Monat des Schreibens zu Ihrem Listing zurückkehren, würden
sie erkennen, das all diese unverständlichen Anweisungen nichts anderes machen
als 3 Multiplikationen und eine Division? SIE WÜRDEN VIEL ZEIT BRAUCHEN, oder
vielleicht sogar das Listing löschen und im Falle einer Änderung von vorne
beginnen. Ich habe die Kommentare nicht zu dieser neuesten Version hinzugefügt,
um verständlich zu machen wie GRUNDLEGEND es ist, Kommentare für Optimierungen
abzugeben, wie im vorherigen Listing. Deshalb: 
KOMMENTIEREN SIE IMMER DIE OPTIMIERUNGEN!!!!!!!!!!!!

Ein weiteres Beispiel: siehe diese 3 Anweisungen:

	move.l	a1,a0
	add.w	#80,a0
	add.l	d0,a0

Das gleiche kann so gemacht werden:

	lea	80(a1,d0.l),a0	; oder d0.w wenn das niedrige Wort von d0 ausreicht.

*****************************************************************************
* OPTIMIERUNGEN AUF ZWEITER EBENE: DIE "TABELLEN -> VORBERECHNUNG!			*
*****************************************************************************

Lassen Sie uns nun über Tabellen sprechen, eines der wichtigsten Themen für
Optimierung, das mit dem Großbuchstaben O, mit dem Sie schneller arbeiten
können, als jeder C-Compiler, BASIC usw.
Die Tabellen für die Optimierung sind "ähnlich" zu denen, die in wir in
früheren Lektionen gesehen haben z.B. die die Bewegungs-Koordinaten der Sprites
enthalten oder andere.
In diesem Fall können wir sagen, dass wir die verschiedenen Positionen, die 
die Objekte eingenommen haben "vorberechnet" haben, aber hier geht es um eine
Tabelle die verwendet wird, um die Ergebnisse einer gegebenen Multiplikation,
Division oder ganze mathematische Funktionen "vorberechnet" werden, also ist
der Fall ein bisschen anders. Nehmen wir ein konkretes Beispiel.

Angenommen, wir haben eine Routine, die eine Reihe von Werten von 0 bis 100
verarbeitet und irgendwann müssen wir eine Multiplikation mit einer
Konstanten c durchführen. Wenn diese Routine viele Male ausgeführt werden
muss, dann wird diese Multiplikation viel Zeit verschwenden.
Wie kann man das Problem umgehen? Wir erstellen eine Tabelle mit allen Werten
von unserem "Bereich" von 0..100 mit bereits multiplizierten c. 
Das ist solche Sache:

Table:
	dc.w	0*c
	dc.w	1*c
	dc.w	2*c
	dc.w	3*c
	.
	dc.w	n*c
	.
	dc.w	100*c

Zu diesem Zeitpunkt ist es einfach, auf die Tabelle zuzugreifen, da der 
mit c multiplizierte Wert für d0 angegeben ist, haben wir das:

	Lea	Table,a0		; Adresse der Tabelle
	Add.w	d0,d0		; d0 * 2, um den Offset der Tabelle zu finden,
						; da jeder Wert ein Wort lang ist
	Move.w	(a0,d0.w),d0; Kopieren des richtigen Werts aus der Tabelle nach d0

Einfach, oder? Der einzige Nachteil ist, dass wir ein 100 Wörter langes Listing
haben, um die Tabelle zu erhalten. Wenn diese Tabelle nicht größer als
256 Bytes wäre, könnten wir schreiben:

	Add.w	d0,d0				; d0*2, jeder Wert 1 Wort, d.h. 2 Bytes
	Move.w	Table(pc,d0.w),d0	; kopiere den richtigen Wert aus der Tabelle

Wäre das Listing für 68020+ , würde eine einzige Anweisung ausreichen:

	Move.w	Table(pc,d0.w*2),d0	; Anweisung für 68020 oder höher

Letzteres ist jedoch eine Vorwegnahme, denn die spezifischen Optimierungen für 
68020 werden wir später behandeln.
Die gebräuchlichste Lösung für "kurze" Tabellen besteht jedoch darin, sie in
einem BSS-Abschnitt durch eine Routine zu erstellen. Auf diese Weise wird die
ausführbare Datei nicht länger, sondern nimmt nur wenig Speicher in Anspruch 
(es sei denn, Sie machen eine Tabelle die 500KB lang ist, in diesem Fall nimmt
es VIEL mehr Speicher in Anspruch, heheheeh!)

Wenn Sie aufmerksam waren, wir haben in den vorherigen Lektionen bereits einige
"tabellarische" Listings aufgeführt, eine zum Entfernen eines "MULU.W #40", die
sehr häufig vorkommt, da 40 die Länge einer Lowres-Bildschirmzeile ist.
Sehen Sie sich das Beispiel sorgfältig an, es ist Listing8n2.s in dem beide
Versionen im Vergleich optimiert und normal vorhanden sind. Schauen Sie sich
auch die vorherigen Listings an, um die normalen und optimierten Routinen
einzeln zu sehen. Das Problem war:

	mulu.w	#largschermo,d1		; d.h. mulu.w #40,d1

Hier ist der Trick, um das Problem zu beheben:

; LASSEN SIE UNS EINE TABELLE MIT DEN VIELFACHEN VON 40 VORBERECHNEN,
; dh mit der Breite des Bildschirms, um eine Multiplikation für jeden
; Plot zu vermeiden.

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

	lea	MulTab,a0			; Adressraum mit 256 Wörtern zum Schreiben
							; der Vielfachen von 40 ...
	moveq	#0,d0			; wir beginnen mit 0 ...
	move.w	#256-1,d7		; Anzahl der benötigten Vielfachen von 40
PreCalcLoop
	move.w	d0,(a0)+		; wir speichern das aktuelle Vielfache
	add.w	#LargSchermo,d0	; Bildbreite hinzufügen, nächstes Vielfaches
	dbra	d7,PreCalcLoop	; Wir erstellen die gesamte MulTab
	....

	SECTION	Precalc,bss

MulTab:
	ds.w	256	; Beachten Sie, dass der aus Nullen bestehende Abschnitt
; bss nicht die tatsächliche Länge der ausführbaren Datei verlängert.

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

Dies dient der Berechnung der Tabelle. Dann anstelle der Mulu:

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

	lea	MulTab,a1			; Adresse der Tabelle mit Vielfachen von
							; der Breite des Bildschirms in a1 vorberechnet
	add.w	d1,d1			; d1*2, um den Versatz in der Tabelle zu finden
	add.w	(a1,d1.w),d0	; Kopiere das richtige Vielfache
							; von der Tabelle nach d0
-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

Kurz gesagt, dies ist die Methode der Tabellierung einer Multiplikation.
Natürlich wussten wir hier, dass d1 nur von 0 bis 255 gehen kann, folglich
haben wir nur 256 Vielfache vorberechnet. Wenn d1 stattdessen einen Bereich
von 0 bis 65000 gehabt hätte, hätten wir eine 128Kb lange Tabelle erstellen
müssen und das wäre vielleicht nicht einmal praktisch!

Wenn das maximale Ergebnis in der Tabelle $FFFF (65535) nicht überschreitet,
reicht das Erstellen einer Tabelle mit .Word-Werten aus. Wenn andererseits die
höchsten Werte diesen Wert überschreiten, muss die Tabelle aus einem Langwort
bestehen. In diesem Fall müssen wir den Weg ändern, um den Offset zu finden:
nicht mehr * 2, sondern * 4!

	lea	MulTab,a1			; Adresse der Tabelle mit Vielfachen von
							; der Breite des Bildschirms in a1 vorberechnet
	add.w	d1,d1			; d1*4, um den Versatz in der Tabelle zu finden
	add.w	d1,d1			;
	move.l	(a1,d1.w),d0	; Kopieren Sie das richtige Vielfache
							; von der Tabelle nach d0

Was die Tabelle der Divisionen betrifft, so ist die Sache analog, man macht
einfach eine Routine mit einer Schleife, die in jeder Schleife eine steigende
Zahl dividiert und speichert die Ergebnisse in der Tabelle. In diesem Fall
können Sie wählen, ob Sie nur das niedrige Wort mit dem Ergebnis oder auch das 
hohe mit dem Rest speichern möchten, wenn es unserem Zweck dient.
	
Eine grundlegende Sache ist, die Tabelle "vor Ort" zu erstellen, NIEMALS
EINE TABELLE EINFÜGEN, VOR ALLEM, WENN VIELE KB AN VORBERECHNETEN LANGWÖRTERN
VORHANDEN SIND.

Wenn wir beispielsweise eine Multab von 20 KB vorberechnet haben, stellen Sie
sich den Unterschied vor zwischen einer ausführbaren Datei, die sie beim Start
berechnet, und einer, die eine bereits vorberechnete durch incbin einschließt
vor. Beispiel:

	file1	->	Länge = 40K	; Berechnen der Tabelle beim Starten
	file1	->	Länge = 60K	; Tabelle mit incbin einbinden

In Bezug auf den Speicherverbrauch sind sie gleichwertig, aber wenn Sie ein
40K- oder 64K-Intro machen würden, könnte man sich die immense Platzersparnis
vorstellen, auf Kosten von 1 oder 2 Sekunden der Vorberechnung am Anfang. 
Aber selbst wenn Sie ein Spiel oder ein Programm erstellen würden, würde die
Tatsache, dass es mehr als 20k (oder mehr) kostet, es Ihnen ermöglichen, mehr
Material auf die Diskette zu legen und eine größere Verbreitung in den BBSen
finden, da sie kleiner ist.
Dann gibt es noch einen weiteren Anreiz, die Tabellen an Ort und Stelle
vorzuberechnen: Die Tatsache, dass man das Listing leicht ändern kann, z.B.
wenn man mit 80 statt 40 multiplizieren möchte. Der Dumme, der mit dem INCBIN
eine Tabelle mit den Vielfachen von 40 mit eingefügt hat, müsste die
Multiplikationsroutine mit 80 umschreiben, sie ausführen und die Binärdatei
speichern, während der SCHLAUE der die Routine im Listing hat, einfach 40 in 80
ändern muss und alles weitere macht es von selbst.
Schließlich ist die Bedienung, insbesondere bei Vorberechnungen komplexer
Routinen VIEL klarer, wenn man die ursprüngliche Routine, die die Tabelle
erstellt, im Blick hat. 
Daher sollten Sie TABELLEN "vor Ort" In LEEREN SPEICHERBEREICHEN VORBERECHNEN, 
INSBESONDERE IN BSS-ABSCHNITTEN, WENN ES GROSSE TABELLEN SIND.

Der Rat, den ich Ihnen geben kann, ist, immer zu versuchen, ALLES zu
tabellieren.

Wenn Sie sehr gut aufgepasst haben, sollten Sie sich auch daran erinnern, dass
in Lektion11 ein Listing einer Tabellenoptimierung unterzogen wurde, die
weitaus riskanter ist, als die jetzt zu sehen ist. 
Tatsächlich wird eine ganze Routine anstelle von nur einer Multiplikation 
aufgezeichnet. Es ist kein Zufall, dass ich es in Lektion 11 und nicht in 8
eingefügt habe! Das "normale" Listing ist Listing11l5.s, das "tabellarische"
Listing ist Listing11l5b.s.
Überprüfen Sie, wie die starke Optimierung stattgefunden hat, die ich erneut
vorschlage.

Dies ist die "normale" Routine:

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

Animloop:
	moveq	#0,d0
	move.b	(A0)+,d0	; Nächstes byte in d0
	MOVEQ	#8-1,D1		; 8 Bits zum Überprüfen und Erweitern.
BYTELOOP:
	BTST.l	D1,d0		; Test des aktuellen Schleifenbits
	BEQ.S	bitclear	; zurückgesetzt?
	ST.B	(A1)+		; wenn nicht, setze byte (=$FF)
	BRA.S	bitset
bitclear:
	clr.B	(A1)+		; Wenn es gelöscht ist, wird das Byte gelöscht
bitset:
	DBRA	D1,BYTELOOP	; Überprüfen und erweitern Sie alle Bits des Bytes
	DBRA	D7,Animloop	; Konvertieren Sie den gesamten Frame

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

Wir haben nichts getan, als alle Möglichkeiten vorab zu berechnen:

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

****************************************************************************
; Routine, die alle möglichen 8 Bytes in Kombination mit den möglichen 8 Bit
; vorberechnet. Mit allem meinen wir $FF, das sind 255.
****************************************************************************

PrecalcoTabba:
	lea	Precalctabba,a1	; Ziel
	moveq	#0,d0		; von Null anfangen
FaiTabba:
	MOVEQ	#8-1,D1		; 8 Bits zum Überprüfen und Erweitern.
BYTELOOP:
	BTST.l	D1,d0		; Test des aktuellen Schleifenbits
	BEQ.S	bitclear	; zurückgesetzt?
	ST.B	(A1)+		; wenn nicht, setze byte (=$FF)
	BRA.S	bitset
bitclear:
	clr.B	(A1)+		; Wenn es gelöscht ist, wird das Byte gelöscht
bitset:
	DBRA	D1,BYTELOOP	; Überprüfen und erweitern Sie alle Bits des Bytes:
						; D1, das jedes Mal fällt, macht den btst von
						; alle Bits.
	ADDQ.W	#1,D0		; Nächster Wert
	CMP.W	#256,d0		; Haben wir alle gemacht? (max $FF)
	bne.s	FaiTabba
	rts

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

Und ändern Sie die "Executive" -Routine:

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

Animloop:
	moveq	#0,d0
	move.b	(A0)+,d0	; Nächstes Byte in d0
	lsl.w	#3,d0		; d0 * 8, um den Wert in der Tabelle zu finden
						; (d.h. der Versatz von seinem Anfang)
	lea	Precalctabba,a2
	lea	0(a2,d0.w),a2	; In a2 die Adresse in der 8-Byte-Tabelle
						; genau richtig für die "Erweiterung" der 8 Bits.
	move.l	(a2)+,(a1)+	; 4 bytes erweitern
	move.l	(a2),(a1)+	; 4 bytes erweitern (gesamt 8 bytes!!)

	DBRA	D7,Animloop	; Konvertieren Sie den gesamten Frame

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

Wie Sie sehen, handelt es sich hier um eine Art der Optimierung, die eine
gewisse Erfahrung und eine gewisse Intuition erfordert.
Mechanisch gesehen ist einfach zu sagen: "Ich versuche, alle Multiplikationen
und Divisionen zu tabellieren und alle möglichen addqs und moveqs zu setzen".
Aber auch wenn ich davon weiß, wenn sie "seltsame" Routinen wie die bereits
gesehene finden, welche durch btst aus einem ganzen Byte es auf 8 Bytes
erweitert, ist es notwendig das Auge eines Luchses zu haben, um zu verstehen,
wie man es optimiert. Es ist dieses Luchsauge, das den Unterschied zwischen
einer 3D-Routine ausmacht, die ruckelt, wenn sie sich 10 Punkte dreht, und
einer, die in einer Fünfzigstelsekunde geht, während sie sich 8192 mal dreht.
Und natürlich kann man nicht eine Liste mit allen möglichen Routinen mit allen
möglichen Optimierungen auflisten.
Es ist notwendig, das Auge eines Luchses zu bekommen, indem man die wenigen
vorgestellten Beispiele sieht.

******************************************************************************
*		VERSCHIEDENE OPTIMIERUNGEN - GEMISCHTE GRUPPE					     *
******************************************************************************

Betrachten wir den Fall, in dem wir für jeden Wert in d0 eine bestimmte Routine
ausführen müssen und nehmen wir außerdem an, dass diese möglichen Werte 
zwischen 0 und 10 sind. Nun, wir könnten versucht sein, so etwas zu tun:

	Cmp.b	#1,d0
	Beq.s	Rout1
	Cmpi.b	#2,d0
	Beq.s	Rout2
	...
	Cmp.b	#10,d0
	Beq.s	Rout10

Es ist eine sehr schlechte Idee, zumindest hätten wir das tun können:

	Subq.b	#1,d0	; wir entfernen 1. Wenn d0 = 0 ist, wird das Z-Flag gesetzt
	Beq.s	Rout1	; Folglich war d0 1 und wir springen zu Rout1
	Subq.b	#1,d0	; etc.
	Beq.s	Rout2
	...
	Subq.b	#1,d0
	Beq.s	Rout10

Tatsächlich ist das schon besser, aber wir sind Perfektionisten und mit Hilfe
einer Tabelle machen wir das:

	Add.w	d0,d0		  ;\ d0*4, um den Versatz in der Tabelle zu finden,
	Add.w	d0,d0		  ;/       bestehend aus Langwörtern (4 bytes!)
	Move.l	Table(pc,d0.w),a0 ; in a0 die Adresse der richtigen Routine
	Jmp	(a0)

Table:
	dc.l	Rout1	; 0 (Wert in d0, um die Routine aufzurufen)
	dc.l	Rout2	; 1
	dc.l	Rout3	; 2
	dc.l	Rout4	; 3
	dc.l	Rout5	; 4
	dc.l	Rout6	; 5
	dc.l	Rout7	; 6
	dc.l	Rout8	; 7
	dc.l	Rout9	; 8
	dc.l	Rout10	; 9

Auf diese Weise vergleichen wir nicht und es ist offensichtlich, dass dies eine
sehr gute Technik ist, wenn wir die zu vergleichenden Werte kennen und sie
aufeinanderfolgend sind.
Ich möchte auch darauf hinweisen, dass wir bei intensiv Nutzung der Tabellen,
sogar mit Zweierpotenzen arbeiten können was uns selbst diese beiden Add.w
erspart. Wenn Sie also Routine 1 wollen, brauchen Sie d0=0, wenn Sie Rout2
möchten d0=4, wenn Sie Rout3 möchten d0=8 und so weiter.

Es gibt zum Beispiel auch Variationen dieses Systems:

	move.b	Table(pc,d0.w),d0	; den richtigen Versatz aus der Tabelle holen
	jmp	Table(pc,d0)			; zu Table hinzufügen und springen!

Table:	
	dc.b	Rout1-Table	; 0
	dc.b	Rout2-Table	; 1
	dc.b	Rout3-Table	; 2
	...
	even

Bei diesem System brauchen wir d0 nicht multiplizieren, da wir eine
Offsettabelle der Routinen von der Tabelle selbst gemacht haben. Hier sind es
.byte-Offsets, weil die Routinen als klein angenommen werden und Nachbarn sind.
Ansonsten können die Offsets .words sein:

	add.w	d0,d0				; d0*2
	move.w	Table(pc,d0.w),d0	; den richtigen Versatz von der Tabelle holen
	jmp	Table(pc,d0)			; füge es der Tabelle hinzu und springe!

Table:	
	dc.w	Rout1-Table	; 0
	dc.w	Rout2-Table	; 1
	dc.w	Rout3-Table	; 2
	...

Der Vorteil dieses Systems besteht darin, dass das Register d0 nicht mit 4,
sondern nur mit 2 multipliziert werden muss. 
Wenn Sie die Tabelle nicht nahe genug herankriegen, können Sie dies tun:

	add.w	d0,d0				; d0*2
	lea	Table(pc),a0
	move.w	(a0,d0.w),d0
	jmp	(a0,d0.w)

Table:	
	dc.w	Rout1-Table	; 0
	dc.w	Rout2-Table	; 1
	dc.w	Rout3-Table	; 2
	...

Wir haben den Sprung zu Routinen bereits mit subq.b #1,d0 implementiert gefolgt
von den BEQs, ohne CMP oder TST. Wir wollen uns mit deren Verwendung verbunden
mit den Condition Codes befassen. (Überprüfen Sie es gut in 68000-2.txt)
Wir Assemblerprogrammierer können uns den Luxus erlauben, drei Bedingungen auf
einmal zu testen. In der Tat betrachten wir das Beispiel:

	Add.w	#x,d0		; die CCs sind in irgendeiner Weise eingestellt
	Beq.s	Zero		; das Ergebnis ist Null
	Blt.s	Negativo	; das Ergebnis ist kleiner als Null
	...					; ansonsten ist das Ergebnis positiv...

Wenn Sie also ein Ergebnis testen müssen, versuchen Sie immer, dies nach der
letzten mathematischen Operation zu tun, und nicht am Ende, wenn der cc etwas 
anderes anzeigt. Es wäre gut, wenn Sie wissen, welche CC's die verschiedenen 
Anweisungen beeinflussen.

Ich rate Ihnen auch, die Bccs entsprechend ihrer Wahrscheinlichkeit der
Ausführung zuerst zu platzieren, das sind praktisch diejenigen, die mit
größerer Wahrscheinlichkeit die Kontrolle übertragen. Ein weiterer
interessanter Fall ist zum Beispiel dieser: Wir haben eine Reihe von Werten,
wir wissen nicht wie viele, aber wir wissen, dass sie mit einer Null enden ... 
Angenommen, wir müssen sie von einem Speicherbereich in einen anderen kopieren.
Wir könnten so etwas tun:

	Lea	Source,a0
	Lea	Dest,a1
CpLoop:
	Move.b	(a0)+,d0	; Quelle -> d0
	Move.b	d0,(a1)+	; d0 -> Ziel
	Tst.b	d0			; d0=0?
	Bne.s	CpLoop		; Wenn noch nicht, weiter

Aber wir können es auf folgende Weise besser machen:

	Lea	Source,a0
	Lea	Dest,a1
CpLoop:
	Move.b	(a0)+,(a1)+	; Quelle -> Ziel
	Bne.s	CpLoop		; flag 0 gesetzt? Wenn noch nicht, weiter!

Wie Sie sehen können, erledigt der 68000 in diesem Fall alles von selbst.

Sprechen wir jetzt über die Aufrufe der Subroutinen und damit über das Movem.
Die Verwendung von Subroutinen ist natürlich sehr nützlich bei der Erstellung
von Programmen, aber bei der Optimierung Ihres Codes sollten Sie beachten, dass
Sie anstelle des Befehlspaars BSR Label / RTS auch das BRA Label gefolgt von
einem weiteren BRA am Ende des Unterprogramms verwenden können, das Sie zu der
Anweisung zurückbringt, das unmittelbar auf das BRA Label folgt, aber diese
Optimierung liegt in Ihrem Ermessen.
Verwenden Sie jedoch, immer BSR anstelle von JSR, wenn Sie können, und ebenso
BRA anstelle von JMP, wenn möglich. Um jedoch auf die Verwendung von Routinen
zurückzukommen, so kommt es häufig vor, dass wir den Inhalt der Register
löschen müssen, bevor wir mit ihnen arbeiten, aber wir können uns jedes Mal
eine Menge "Moveq #0,Dx" und "Sub.l Ax,Ax" sparen. Tatsächlich machen wir das
zu Beginn des Hauptprogramms und sehen was passiert, wenn wir unsere
Subroutinen aufrufen. Beispiel:

	Moveq	#0,d0	;
	Moveq	#0,d1
	...
	Moveq	#0,d7
	Move.l	d0,a0
		..
   	Move.l	d0,a6
Main:
	Bsr.s	Pippo
	Bsr.s	Pluto
	Bsr.s	Paperino
	...
	Bra.s	Main

Nun, wenn wir den Inhalt der verwendeten Register bei jedem Aufruf speichern,
werden wir jedes Mal, wenn eine Routine endet und zur nächsten geht "saubere"
Register haben. Es ist offensichtlich, dass dies für unseren Code gut ist.
Ansonsten könnten Sie mit einer Anweisung alle Register reinigen, und zwar:

	movem.l	TantiZeri(PC),d0-d7/a0-a6

TantiZeri:
	dcb.b	15,0

Wir kommen nun zur Movem-Anweisung und untersuchen ihre Stärken und Schwächen.

Schauen wir uns zunächst die Anzahl der Prozessorzyklen des Movem, insbesondere
bei Langworttransfers an: Die Übertragung von Registern in den Speicher
verwendet 8 + 8n, wobei n die Anzahl der Register angibt, beobachten wir auch
die Anzahl der Zyklen, die stattdessen ein einfaches Move.l Dx (Ax) verwendet:
12 Zyklen. Der gewöhnliche Ingenieur könnte sich nun folgende Frage stellen:
Wenn ich mehrere lange Wörter in verschiedenene Register übertragen muss,
inwieweit sollte ich den klassischen Move.l Dx (Ax) verwenden? Nun, auch
diesmal hat der Ingenieur eine korrekte Beobachtung gemacht, und zwar 
betrachten wir einen Extremfall, in dem wir den Inhalt der Register D0..D7 und
A0..A6 übertragen müssen: wir bräuchten genau 8 + 7 = 15 Move.l für insgesamt
15 * 12 = 180 Zyklen. Wenn wir stattdessen das Movem verwenden, hätten wir 
8 + 8 * 15 = 128 Zyklen, das ist eine Einsparung von 52 Zyklen!
An dieser Stelle wird deutlich, dass natürlich das Mammut Movem verwendet
werden muss, wenn große Datenmengen übertragen werden müssen. Wenn nur zwei
Register verwendet werden, sollte das normale Move.l verwendet werden. An
dieser Stelle sehen wir eine Reihe praktischer Anwendungen, die mit einem nicht
optimierten Code beginnen bis zu einem optimierten.
Angenommen, wir müssen 1200 Bytes vom Speicherort Table zurücksetzen.
Anfänger würden es so machen:

	Lea	Table,a0		; 12 Zyklen
	Move.w	#1200-1,d7	; 8 Zyklen
CleaLoop:
	Clr.b	(a0)+		; 12 Zyklen 
	Dbne	d7,CleaLoop ; 10 Zyklen / (1*14 Zyklen)

Diese Art von Code ist schrecklich!! Mal sehen, wie lange es dauert ... die
ersten zwei Anweisungen dauern 20 Zyklen, dann muss das clr.b 1200 mal
ausgeführt werden d.h. 1200 * 12 = 14400 Zyklen, außerdem muss das Dbne
hinzugefügt werden was  1199 * 10 = 11990 Zyklen durchgeführt werden muss
plus 14 am Ende.
Zusammenfassung 20 + 14400 + 11990 + 14 = 26424!!! Nun, das alles ist keinen
Kommentar wert. Wir hätten zumindest so etwas tun können:

	Lea	Table,a0
	Move.w	#(1200/4)-1,d7	; Anzahl der Bytes geteilt durch 4, für das clr.l !
Clr:
	Clr.l	(a0)+		; Wir setzen jeweils 4 Bytes zurück ...
	Dbra	d7,Clr		; und wir machen 1/4 der Schleifen.

Tatsächlich löschen wir mit einem Clr.l mindestens 4 Bytes auf einmal und da
wir 1200 zu löschen haben, würden wir 1200/4 = 300 Zyklen machen und viel
weniger im Vergleich zu früher benötigen (rechnen Sie aus Mitleid selbst nach).
Um noch mehr zu optimieren, können wir dies tun:

	Lea	Table,a0
	Move.w	#(1200/16)-1,d7	; Anzahl der Bytes geteilt durch 16 für das clr.l !
Clr:
	Clr.l	(a0)+		; zurücksetzen 4 bytes
	Clr.l	(a0)+		; zurücksetzen 4 bytes
	Clr.l	(a0)+		; zurücksetzen 4 bytes
	Clr.l	(a0)+		; zurücksetzen 4 bytes
	Dbra	d7,Clr		; und wir machen 1/16 der Schleifen.

Allerdings kann auch diese Art von Code als schlecht eingestuft werden. Lassen 
Sie uns versuchen, es mithilfe eines Datenregisters weiter zu optimieren:

	Lea	Table,a0
	moveq	#0,d0		; "move.l d0" schneller als ein "CLR"!
	Move.w	#(1200/32)-1,d7	; Anzahl der Bytes geteilt durch 32
Clr:
	move.l	d0,(a0)+	; zurücksetzen 4 bytes
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	Dbra	d7,Clr		; und wir machen 1/32 der Schleifen.

Mit dieser Version haben wir die Optimierung aufgrund der Verringerung der
auszuführenden dbra erhöht, und wir haben die Tatsache ausgenutzt, dass die
Verwendung von Registern mega-schnell ist, sogar schneller als "CLR".

Wir kommen jetzt dazu, das Movem zu benutzen und sehen, was passiert:

	movem.l	TantiZeri(PC),d0-d6/a0-a6	; alle Register löschen
						; außer d7 und a7, natürlich,
						; welcher der stack ist. Sie können
						; so oder mit vielen moveq #0,Dx zurücksetzen...
					
; Jetzt haben wir 7 + 7 = 14 Register gelöscht, insgesamt 14*4=56 byte.
; Wir müssen 1200 Byte/56 Byte = 21 übertragen, aber 21*56=1176 Byte, und
; weitere 1200-1176 = 24 Byte müssen noch erledigt werden, was wir separat
; tun werden.

	Move.l	a7,SalvaStack	; wir speichern den Stack in einem Label
	Lea	Table+1200,a7	; in A7 einfügen (oder SP, es ist das gleiche Register)
						; die Adresse des Endes des zu reinigenden Bereichs.
	Moveq	#21-1,d7	; Anzahl der auszuführenden movem (2100/56=21)
CleaLoop:
	Movem.l	d0-d6/a0-a6,-(a7)	; Wir setzen "rückwärts" zurück 56 bytes.
								; Wenn Sie sich erinnern, das movem arbeitet
								; schreibend "rückwärts" für den Stack.
	Dbra	d7,CleaLoop
	Movem.l	d0-d5,(a7)+	  		; die hohen 24 bytes zurücksetzen
	Move.l	SalvaStack(PC),a7 	; den Stack wieder in SP setzen
	rts

SalvaStack:
	dc.l	0

Rechnen wir mal nach: Das interne MOVEM benötigt genau 8+8*14=120 Zyklen, es
muss 21 Mal ausgeführt werden, also 21*120=2520 Zyklen, zu denen müssen wir
die gesamte Initialisierungs- und Schließphase hinzurechnen, aber keine Sorge,
die oben genannten Fälle werden nicht überschritten. Wir können noch mehr
Perfektionist sein, indem wir den Code erweitern, d h. die Schleifen
eliminieren und so viele MOVEMs wie nötig einfügen; keine Angst, die Code-
Erweiterung ist eine weit verbreitete Technik, besonders wenn man nicht mehr
weiß, was man optimieren soll. Wir werden sim Folgenden eine Reihe von
Beispielen sehen. Im ersten Fall würde jedoch folgendes passieren:

	Move.l	a7,SalvaStack	; wir speichern den Stack in einem Label
	Lea	Table+1200,a7	; in A7 einfügen (oder SP, es ist das gleiche Register)
				; die Adresse des Endes des zu reinigenden Bereichs.
CleaLoop:

	rept	20				  ; wiederholen 20 movem...
	Movem.l	d0-d7/a0-a6,-(a7) ; Wir setzen "rückwärts" zurück 60 bytes.
	endr

	Move.l	SalvaStack(PC),a7 ; den Stack wieder in SP setzen
	rts

Beachten Sie, dass wir nachdem wir das dbra eliminiert haben, auch das Register
d7 verwenden können, wodurch wir mit jedem Movem 4 Bytes mehr zurücksetzen
können. Auf diese Weise ist 1200/60 genau 20. Demos verwenden normalerweise
dieses System, das schnellste!

Schauen wir uns die Code-Erweiterungstechnik genauer an. Beachten Sie diese
Routine:

ROUTINE2:
	MOVEQ	#64-1,D0	; 64 Zyklen
SLOWLOOP2:
	MOVE.W	(a2),(a1)
	ADDQ.w	#4,a1
	ADDQ.w	#8,a2
	DBRA	D0,SLOWLOOP2

Und hier ist die sehr beschleunigte Routine:

ROUTINE2:
	MOVE.W	(a2),(a1)
	MOVE.W	8(a2),4(a1)
	MOVE.W	8*2(a2),4*2(a1)
	MOVE.W	8*3(a2),4*3(a1)
	MOVE.W	8*4(a2),4*4(a1)
	MOVE.W	8*5(a2),4*5(a1)
	MOVE.W	8*6(a2),4*6(a1)
	MOVE.W	8*7(a2),4*7(a1)
	.....
	MOVE.W	8*63(a2),4*63(a1)

Wir haben die Zeit für das DBRA und die 2 Addqs entfernt! Es muss jedoch gesagt
werden, dass 68020 und höhere Prozessoren Befehls-Cache haben, die Schleifen mit
einer Länge von weniger als 256 Bytes beschleunigen. Es kann also vorkommen,
dass es für 68000 optimiert und langsamer, als auf 68020 ausgeführt wird.
Folglich wäre es gut, eine Vermittlung wie diese durchzuführen:

ROUTINE2:
	MOVEQ	#4-1,D0				; nur 4 Zyklen (64/16)
FASTLOOP2:
	MOVE.W	(a2),(a1)			; 1
	MOVE.W	8(a2),4(a1)			; 2
	MOVE.W	8*2(a2),4*2(a1)		; 3
	MOVE.W	8*3(a2),4*3(a1)		; 4
	MOVE.W	8*4(a2),4*4(a1)		; 5
	MOVE.W	8*5(a2),4*5(a1)		; ...
	MOVE.W	8*6(a2),4*6(a1)
	MOVE.W	8*7(a2),4*7(a1)
	MOVE.W	8*8(a2),4*8(a1)
	MOVE.W	9*9(a2),4*9(a1)
	MOVE.W	8*10(a2),4*10(a1)
	MOVE.W	8*11(a2),4*11(a1)
	MOVE.W	8*12(a2),4*12(a1)
	MOVE.W	8*13(a2),4*13(a1)
	MOVE.W	8*14(a2),4*14(a1)
	MOVE.W	8*15(a2),4*15(a1)	; 16
	ADD.w	#4*16,a1
	ADD.w	#8*16,a2
	DBRA	D0,FASTLOOP2

Dies gilt auch für das Löschen mit dem Movem und die anderen Routinen, bei
denen wir einen Teppich wiederholen.

Lassen Sie uns nun einige nützliche Beobachtungen machen:
Die selbstinkrementierende indirekte Adressierungsmethode ist etwas, das man
immer im Hinterkopf behalten sollte. In der Tat benötigt die indirekte
Adressierung, sowohl ohne als auch mit Inkrement die gleiche Anzahl von Zyklen.
Ein sehr guter Fall ist die Verwendung des Blitters, und wir werden später ein
Beispiel dieser Art sehen.
Die zweite Methode, mit der wir zum Kopieren der 1200 Bytes verwendet haben,
ist jedoch nicht komplett zu verwerfen: Wenn wir eine Kopie machen müssten,
könnten wir es viel besser machen, aber denken Sie an den Fall, indem wir 1200
Bytes maskieren mussten: Wir sind zwangsläufig gezwungen, eine Dbcc-Schleife zu
verwenden. Versuchen Sie in diesen Fällen, die Vorteile der Dbcc-Anweisung zu
nutzen und denken Sie daran, dass auf einem 680xx mit Cache diese Arten von
Schleifen mit TURBO-Geschwindigkeit ausgeführt werden.
Darüber hinaus eignen sich die DBcc-Anweisungen auch hervorragend für
Vergleiche. Hier ein Beispiel:

	Move.w	Len(PC),d0		; Max Länge zu suchen <> 0
	Move.l	String(PC),a0	
	Moveq	#Char,d1		; Character zu suchen
FdLoop:
	Cmp.b	(a0)+,d1
	Dbne.s	d0,FdLoop

Der folgende Schleife überprüft zwei Dinge gleichzeitig, und zwar wird der cc
EQ gesetzt, wenn wir alle Len (Anzahl der Zeichen) untersucht haben, oder wenn
das Zeichen gefunden wurde, könnten wir in diesem Fall auch sagen an welcher
Position es sich befindet.
An dieser Stelle möchte ich die letzten Beispiele zum Movem und machen, und
zwar speziell zum Kopieren von Speicherzonen: Im Gegensatz zum Nullsetzen 
müssen wir hier Daten abrufen und dann kopieren, aber sehen wir uns sofort ein
Beispiel an:

	Lea	Start,a0
	Lea	Dest,a1
FASTCOPY:								; Ich benutze 13 Register
	Movem.l	(a0)+,d0-d7/a2-a6
	Movem.l	d0-d7/a2-a6,(a1)
	Movem.l	(a0)+,d0-d7/a2-a6
	Movem.l	d0-d7/a2-a6,$34(a1)			; $34
	Movem.l	(a0)+,d0-d7/a2-a6
	Movem.l	d0-d7/a2-a6,$34*2(a1)		; $34*2
	Movem.l	(a0)+,d0-d7/a2-a6
	Movem.l	d0-d7/a2-a6,$34*3(a1)
	Movem.l	(a0)+,d0-d7/a2-a6
	Movem.l	d0-d7/a2-a6,$34*4(a1)
	Movem.l	(a0)+,d0-d7/a2-a6
	Movem.l	d0-d7/a2-a6,$34*5(a1)
	Movem.l	(a0)+,d0-d7/a2-a6
	Movem.l	d0-d7/a2-a6,$34*6(a1)
	Movem.l	(a0)+,d0-d7/a2-a6

Zunächst einmal haben wir hier die Technik der Code-Erweiterung übernommen
(wenn man sie so nennen kann). Sie mag übertrieben sein, aber sie ist sehr
effizient. Nun, was haben wir getan? Wir nehmen 13*4 Bytes vom Speicherort, auf
den a0 zeigt und kopieren sie an den Speicherort auf den a1 zeigt, wobei wir
darauf achten, den Offset zu a1 nach jedem kopieren zu erhöhen. Falls Sie den
Code erweitern möchten, stört es wenn Sie alle diese Anweisungen sehen. Sie
können die Rept-Direktive verwenden:

	REPT		100
	And.l		(a0)+,(a1)+
	ENDR

Der Assembler generiert sie dann für Sie. Zum Schluss sehen wir uns ein
Beispiel zu den Farbregistern an:

	Lea	$dff180,a6
	Movem.l	Colours(pc),d0-a5	; wir laden 14 Langwörter oder 28 Wörter
	Movem.l	d0-a5,(a6)			; setzt 28 Farben auf einmal!!
	
Colours:	dc.w	...


Oder wenn Sie zu Beginn einer Routine viele Register laden müssen:


	MOVE.L	#$4232,D0
	MOVE.W	#$F20,D1
	MOVE.W	#$7FFF,D2
	MOVEQ	#0,D3
	MOVE.L	#123456,D4
	LEA	$DFF000,A0
	LEA	$BFE001,A1
	LEA	$BFD100,A2
	LEA	Schermo,A3
	LEA	BUFFER,A4
	...

All dies kann mit nur 1 Routine zusammengefasst werden:


	MOVEM.L	VariaRoba(PC),D0-D4/A0-A4
	...

VariaRoba:
	dc.l	$4243		; d0
	dc.l	$f20		; d1
	dc.l	$7fff		; d2
	dc.l	0			; d3
	dc.l	$123456		; d4
	dc.l	$dff000		; a0
	dc.l	$bfe001		; a1
	dc.l	$bfd100		; a2
	dc.l	Schermo		; a3
	dc.l	Buffer		; a4

Zum Movem-Befehl könnten wir noch viele andere Beispiele aufführen, aber ich
denke, Sie haben seine Nützlichkeit in bestimmten Fällen verstanden.

Aufrufe, die sich auf den Programmcounter (PC) beziehen, sind schneller als
Aufrufe zu normalen Labeln, weil sie "kleiner" sind. In der Tat müssen die
normalen Aufrufe die 32bit lange Adresse der Label enthalten, während die (PC)
Aufrufe nur den 16-Bit-Offset des PC-Registers enthalten, wodurch 2 Bytes und
Zeit gespart werden. Leider ist es genau die Tatsache, dass der Offset 16Bit
beträgt, was es uns nicht erlaubt, relativ zum PC weiter als 32k vorwärts oder
rückwärts zu gehen. Wir kommen nun zu einem Trick, um das gesamte Programm
relativ zum (PC) zu machen, was die Ausführung beschleunigt. Wie Sie wissen,
ist es möglich, dies zu tun:

	move.l	label1(PC),d0

Aber es ist jedoch unmöglich, diese Anweisung relativ zum PC zu machen:

	move.l	d0,label1

Wie macht man das? Dies ist kein großes Problem, aber nehmen wir an, wir haben
diese Anweisung viele Male in einer Schleife ausgeführt. Wenn wir das Label
nicht relativ zum PC machen können, können wir es relativ zu einem gemeinsamen
Adressregister machen! Die naheliegendste Methode ist diese:

	move.x	XXXX,label	->	lea	label(PC),a0
							move.x  XXXX,(a0)

	tst.x	label		->	lea	label(PC),a0
							tst.x	label

Beachten Sie, dass es auch Zeit spart, die #immediate Werte durch Werte aus 
Datenregistern zu ersetzen, solange die Werte zwischen -80 und + 7f liegen, um 
um die Verwendung von "MOVEQ" zu ermöglichen:

	move.l	#xx,dest	->	moveq	#xx,d0
							move.l	d0,dest


	ori.l	#xx,dest	->	moveq	#xx,d0
							or.l	d0,dest


	addi.l	#xx,dest	->	moveq	#xx,d0
							add.l	d0,dest

Insbesondere wenn es möglich ist, alle Register vor einer Schleife zu laden um
dann Zeit beim Laden zu sparen, können Sie auch "MOVE.L #xx,Dx" ausführen, die
Schleife ohne #immediate wird sich auszahlen!

Beispiel:

RoutineSchifosa:
	move.w	#1024-1,d7		; Anzahl der Schleifen
LoopSquallido:
	add.l	#$567,label2
	sub.l	#$23,label3
	move.l	label2(PC),(a0)+
	move.l	label3(PC),(a0)+
	add.l	#30,(a0)+
	sub.l	#20,(a0)+
	dbra	d7,LoopSquallido
	rts

Dies kann so optimiert werden':

RoutineDecente:
	moveq	#30,d0			; wir laden die notwendigen Register...
	moveq	#20,d1
	move.l	#$567,d2
	moveq	#$23,d3
	lea	label2(PC),a1
	lea	label3(PC),a2
	move.w	#1024-1,d7		; Anzahl der Schleifen
LoopNormale:
	add.l	d2,(a1)
	sub.l	d3,(a2)
	move.l	(a1),(a0)+
	move.l	(a2),(a0)+
	add.l	d0,(a0)+
	sub.l	d1,(a0)+
	dbra	d7,LoopNormale
	rts

Um es zu übertreiben, können wir endlich die Anzahl der 
auszuführenden Dbra sparen:

RoutineOK:
	moveq	#30,d0
	moveq	#20,d1
	move.l	#$567,d2
	moveq	#$23,d3
	lea	label2(PC),a1
	lea	label3(PC),a2
	move.w	#(1024/8)-1,d7	; Anzahl der Schleifen = 128
LoopOK:

	rept	8				; Ich wiederhole 8 mal das Stück...

	add.l	d2,(a1)
	sub.l	d3,(a2)
	move.l	(a1),(a0)+
	move.l	(a2),(a0)+
	add.l	d0,(a0)+
	sub.l	d1,(a0)+

	endr

	dbra	d7,LoopNormale
	rts

Um jedoch alles, was mit dem PC zu tun hat, schnell zu machen, gibt es ein
System. Wenn wir in einem festgelegten Adressregister, zum Beispiel a5, die
Adresse des Programmanfangs, oder auf jeden Fall eine in unserem Programm
bekannte Adresse haben, reicht es aus, unser Label als a5 + Offset anzugeben,
um das betreffende Label zu finden. Aber sollten wir dies "VON HAND" tun????
Nein, nein! Hier ist ein sehr schneller Weg, dies zu tun:

S:								; Label der Referenz
MYPROGGY:
	LEA	$dff002,A6				; in a6 haben wir das custom Register
	LEA	S(PC),A5				; in a5 das Register für den Labelversatz

	MOVE.L	#$123,LABEL2-S(A5)	; label2-s = offset! Beispiel: "$364(a5)"

	MOVE.L	LABEL2(PC),d0		; hier handeln wir normal

	MOVE.L	d0,LABEL3-S(A5)		; gleiche Rede.

	move.l	#$400,$96-2(a6)		; Dmacon (in a6 ist $dff002!!!)

	...

; Nehmen wir an, Sie haben das A5-Register "verschmutzt" ... 
; laden Sie es einfach neu!

	LEA	S(PC),A5
	move.l	$64(a1),OLDINT1-S(A5)
	CLR.L	LABEL1-S(A5)

Es scheint klar zu sein, oder? Sie hätten das Label BAU: anstelle von S:
nennen können, aber ich denke, dass es nützlich ist, es S:, E:, I: zu nennen,
was kürzer zu schreiben ist. Die einzige Einschränkung besteht darin, dass,
wenn das Label mehr als 32 KB vom Referenzlabel entfernt ist, überschreiten
wir die Adressierungsgrenzen. Das ist kein unüberwindbares Problem, denn es
reicht aus, alle 30K ein Referenzlabel zu setzen und auf das nächstgelegene
zu verweisen, zum Beispiel:

B:
	...
	LEA	B(PC),A5
	MOVE.L	D0,LABEL1-B(A5)
	...

; 30K Pass

C:

	LEA	C(PC),A5
	MOVE.L	(a0),LABEL40-C(A5)
	...

Dieses System macht es auch schwierig, Ihren Code zu disassemblieren für den
Fall, dass jemand Ihre Routinen mit einem Disassembler "stehlen" möchte.

Eine weitere Sache, die für Sie nützlich sein kann, ist die Verwendung von Bits
als Flags. Beispielsweise, wenn wir in unserem Programm Variablen haben, die
TRUE oder FALSE sein müssen, dh ON oder OFF, dann ist es sinnlos, für jedes ein
Byte zu verschwenden. Ein Bit reicht aus, und wir sparen Platz. Zum Beispiel:

Opzione1	=	0
VaiDestra	=	1		; gehe nach rechts oder links?
Avvicinamento	=	2	; Annäherung oder Rückzug?
Music		=	3		; Musik ein oder aus?
Candele		=	4		; Kerzen anzünden oder nicht anzünden?
FirePremuto	=	5		; jemand drückte Feuer?
Acqua		=	6		; im Teich unten?
Cavallette	=	7		; gibt es Heuschrecken?

Controllo:
	move.w	MieiFlags(PC),d0
	btst.l	#Opzione1,d0
	...


CambiaFlags:
	lea	MieiFlags(PC),a0
	bclr.b	#Opzione1,(a0)
	...

MieiFlags:
	dc.b	0
	even

Wenn Sie jedoch btst und bclr/bset/bchg nicht mögen, können Sie dies tun:

	bset.l	#Opzione1,d0	->	or.b	#1<<Opzione1,d0

	bclr.l	#Opzione1,d0	->	and.b	#~(1<<Opzione1),d0

	bchg.l	#Opzione1,d0	->	eor.b	#1<<Opzione1,d0

Beachten Sie die Nützlichkeit der asmone Verschiebefunktionen ">>" und "<<"
sowie das eor "~".

Um den Abschnitt über CPU-Optimierungen zu beenden, stelle ich einige Tricks
vor, die nur auf 68020 und höher beschleunigen, aber da sie nichts kosten, kann
es nützlich sein, um unsere Routinen auf schnelleren Computern spritziger zu
sehen.
Zunächst einmal gibt es die Caches, die es erlauben, Schleifen die bis zu 256 
Bytes lang sind, so dass sie ab der zweiten Schleifen aus dem internen Speicher
zur CPU!!!!!!!!!!!!!! und nicht aus dem langsamen Speicher (insbesondere wenn
Chip-Ram!) lesen. Folglich ist es gut, die Operationen so zu wiederholen, wie
wir es gesehen haben, in den verschiedenen Schleifen zu wiederholen, so dass
sie etwa 100-150 Bytes groß sind. Auf diese Weise laufen sie auf 68020+ viel
schneller als Routinen, in denen stattdessen so viele Anweisungen
aneinandergereiht werden, wie Schleifen zu erledigen sind. Um das
klarzustellen, wenn wir haben:

Routine1:
	move.w	#2048-1,d7
loop1:
	< Block mit Anweisungen >
	dbra	d7,loop1

Wir können es optimieren in:

Routine1:
	rept	2048
	< Block mit Anweisungen >
	endr	

Auf einem Basis 68000er ist es viel schneller, aber auf einem 68020 ist es
langsamer! Optimierung, die in allen Fällen so schnell wie möglich ist:

Routine1:
	move.w	#(2048/16)-1,d7
loop1:
	rept	16
	< Block mit Anweisungen >
	endr

	dbra	d7,loop1

Angenommen, der Befehlsblock ist 12 Bytes lang, dann sind 12*16=192, die sich
im Cache befinden und es geht sehr schnell auf 68020, während auf 68000 der
Unterschied zur der Version mit 2048 rept unmerklich ist und Sie sparen auch in
der Länge der ausführbaren Datei. Achten Sie nicht nur darauf, die Schleifen
nur 250 oder 256 Bytes lang zu machen, da der Cache nur nach bestimmten
"blocking" und "alignment" Bedingungen gefüllt werden kann. Bleiben Sie also
immer unter 180-200 Bytes, nur um sicher zu gehen.

Ein weiterer Punkt, den Sie beachten sollten, ist, dass Sie, wenn es möglich
ist einen aufeinanderfolgenden Zugriff auf den Speicher zu vermeiden. Beispiel:

	move.l	d0,(a0)
	move.l	d1,(a1)
	move.l	d2,(a2)
	sub.l	d2,d0
	eor.l	d0,d1
	add.l	d1,d2

Es sollte "umformuliert" werden in:

	move.l	d0,(a0)
	sub.l	d2,d0
	move.l	d1,(a1)
	eor.l	d0,d1
	move.l	d2,(a2)
	add.l	d1,d2

Wenn auf den Speicher zugegriffen wird (insbesondere wenn Chip-RAM), gibt es
die sogenannten WAIT STATE, dh Wartezeiten, bevor wieder geschrieben werden
kann. In dem ersten Beispiel gibt es zwischen einem Schreibvorgang und dem
anderen eine Totzeit, in der der Prozessor darauf wartet, dass die Daten in
den Speicher zurückgeschrieben werden.
Im zweiten Fall hingegen, wird nach dem Schreiben in den RAM eine Operation
zwischen Registern innerhalb der CPU ausgeführt, nach der Ablauf erneut auf den
Chip-RAM zugegriffen wird, sobald die Zugriffszeit abgelaufen ist. Beim Zugriff
auf 32-Bit-FAST-RAM, ist das Problem weit weniger schwerwiegend, aber es
besteht.

Schließlich mag der 68020+ wirklich Routinen und Label, die an Adressen mit
Vielfachen von 32 ausgerichtet sind, d.h. Langwort ausgerichtet.
Um auf 32-Bit auszurichten, genügt ein:

	CNOP	0,4

Vor der Routine oder dem Label. Auf 68000 gibt es keine Verbesserungen, aber
auf 68020+ gibt es sie, insbesondere wenn der ausgerichtete Code in Fast RAM
oder in Cache geht. Hier ist ein Beispiel:

Routine1:
	bsr.s	rotazione
	bsr.s	proiezione
	bsr.s	disegno
	rts

	cnop	0,4
rotazione:
	...
	rts

	cnop	0,4
proiezione:
	...
	rts

	cnop	0,4
disegno:
	...
	rts

Stellen Sie bei Labeln sicher, dass Sie nicht auf ungerade Adressen zugreifen,
wodurch es sich verlangsamt. Richten Sie diese stattdessen auch auf long aus:

Originalfassung:

Label1:
	dc.b	0
Label2:
	dc.b	0	; Adresse seltsam! "move.b xx, label1" wird langsam sein!
Label3:
	dc.w	0
Label4:
	dc.w	0
Label5:
	dc.l	0
Label6:
	dc.l	0
Label7:
	dc.l	0

ausgerichtete Version:

	cnop	0,4
Label1:
	dc.b	0
	cnop	0,4
Label2:
	dc.b	0
	cnop	0,4
Label3:
	dc.w	0
	cnop	0,4
Label4:
	dc.w	0
	cnop	0,4
Label5:
	dc.l	0
Label6:
	dc.l	0 ; diese 2 sind definitiv ausgerichtet, 
Label7:		  ;	es besteht keine Notwendigkeit für cnop
	dc.l	0

Um zu überprüfen, ob ein Label auf 32-Bit ausgerichtet ist, assemblieren Sie
es und prüfen Sie dann, an welcher Adresse dieses Label sich befindet mit dem
Befehl "M", dann dividieren Sie die Adresse durch 4 und multiplizieren das
Ergebnis erneut mit 4. Wenn die ursprüngliche Adresse zurückgegeben wird,
bedeutet dies, dass es ein Vielfaches von 4 ist und alles ist OK, wenn es
anders ist, bedeutet dies, dass es einen Rest gibt und es kein Vielfaches von
4 ist. Setzen Sie dann "dc.w 0" über die Adresse und versuchen Sie, es "von
Hand" auszurichten und schicke den Assembler ins Land, das ein wenig gespielt
wird. Wenn Ihre Routine jedoch bereits bis zur fünfzigsten ruckelfrei auf A500
läuft, ersparen Sie sich all diese "cnop 0,4" in ihrem Listing. "Cnop" nur in
den Listings mit sehr schweren Routinen aufführen, die nicht innerhalb eines
frames funktionieren, wie z.B. fraktale Routinen oder "übertriebene" 
3D-Routinen usw.

******************************************************************************
*			OPTIMIERUNGEN VON BLITTER										 *
******************************************************************************

Am Ende werden wir ein weiteres Beispiel zum Blitter aufführen.
Die Art von Optimierungen, die wir bisher behandelt haben, beziehen sich nur 
auf den 68000er und sind daher unabhängig von der Maschine, auf die wir Bezug
genommen haben. Wir werden nun hardwarebezogene Optimierungen vom Amiga
diskutieren, genau genomen zum Blitter.
Wie Sie wissen, ist der Blitter ein leistungsstarker Coprozessor zum Bewegen
von Daten viel schneller als der Basis 68000er (beachten Sie jedoch, dass er
langsamer ist als ein 68020+!). Es ist gut, das Meiste mit dem Blitter zu
machen. Eine allgemein akzeptierte Philosophie für Blitts ist, das ich nach dem
Start der Datenübertragung früher fertig bin. Sie müssen sich jedoch immer gut
an das Bit namens "blitter-nasty" halten, das dem Blitter in Bezug auf die CPU
eine höhere Priorität einräumt. In der Praxis wird der Bus für die Übertragung
von Daten die meiste Zeit dem Blitter gehören, sehen wir uns ein Beispiel an:

a6=$dff000
			; angenommen, wir haben alle Register initialisiert
	
	Move.w	d0,$58(a6)		; BLTSIZE - der Blitter beginnt
Wblit:
	Move.w	#$8400,$96(a6)	; einschalten blit nasty
Wblit1:
	Btst	#6,2(a6)		; warten, bis der Blitter fertig ist
	Bne.s	Wblit1
	Move.w	#$400,$96(a6)	; ausschalten blit nasty
	....

Dies ist ein trivialer Fall, denn während der Blitter arbeitet, könnte die CPU
etwas anderes tun, so dass die Warteschleife nicht unproduktiv ist. In der Tat
blockiert diese Funktion auf Computern mit nur CHIP-RAM vollständig den
Prozessor und sollte vielleicht nie verwendet werden.
Aber der Fall, in dem wir das blitter nasty aktivieren können und sollten, ist
in Fällen in denen wir auf dem Bildschirm eine Bitplane Bob pro Bitplane
kopieren müssen, denn da normalerweise die CPU zwischen den Blitts warten muss,
können wir das nasty blit aktivieren. Sehen wir uns ein Beispiel an:

BLITZ:						; die Register wurden bereits aktiviert
	Move.w	#$8400,$96(a6)	; einschalten blit nasty
	Move.l	Plane0,$50(a6)	; Zeiger Kanal A
	Move.l	a1,$54(a6)		; Zeiger Kanal D
	Move.w	d0,$58(a6)		; Start Blitter!!!
WBL1:
	Btst	#6,2(a6)		; hier muss die CPU auf das Ende warten...
	Bne.s	WBL1			; also muss der Blitter maximal gehen!
	Move.l	Plane1,$50(a6)	; Zeiger Kanal A
	Move.l	a2,$54(a6)		; Zeiger Kanal D
	Move.w	d0,$58(a6)		; Start Blitter!!!
WBL2:
	Btst	#6,2(a6)		; wie oben
	Bne.s	WBL2
	Move.l	Plane2,$50(a6)	; ebenso
	Move.l	a3,$54(a6)
	Move.w	d0,$58(a6)
WBL3:
	Btst	#6,2(a6)
	Bne.s	WBL3
	Move.w	#$400,$96(a6)	; an dieser Stelle kann auch das Bit blit nasty
	Rts						; deaktiviert werden.


Dieses Beispiel gibt mir die Gelegenheit, Sie auf eine Eigenschaft des Blitters
hinzuweisen, nämlich wenn einige Werte seiner Register nicht verändert werden,
zum Beispiel in den Moduloregistern (BltAMod, BltBMod usw.). Wir werden am Ende
des Blitts die gleichen Werte vorfinden, so dass keine Notwendigkeit besteht
sie erneut zu initialisieren, wenn das Modulo für den nächsten Blit gleich ist.
Gleiches gilt für Register wie BltCon0, BltCon1, BltFWM, BltLWM, aber es gilt
nicht für Zeigerregister, wenn sie mit einer inkrementellen Adressierung
arbeiten. Dies legt Folgendes nahe: Angenommen, wir haben einen 5-Bitplane-Bob
eine nach der anderen in einer "Video"-Bitplane zu platzieren, dann laden wir
jedes Mal den Zeiger auf die "Video"-Bitplane in Register D und den Zeiger auf
den Bob in A: Nach dem ersten Blit wird das Register D geladen mit dem gleichen
Wert plus einem bestimmten Betrag, um auf die nächste Bitebene zu zeigen, aber
es wäre nutzlos es für Kanal A so zu tun, da unser Bob mit aufeinanderfolgende
Bitebenen im Speicher gespeichert wurde. Nach dem ersten Blit zeigt Kanal A
automatisch auf die zweite Bitebene des Bobs.
Wir können auch gute Ergebnisse erzielen, wenn wir Folgendes tun. Wir
reservieren einen Speicherbereich mit allen Werten, die an die Register des
Blitters übergeben werden sollen (in unserem Fall beginnt der Bereich mit
DataBlit). In einigen Adressregistern laden wir also die Registeradressen des
Blitters, damit wir schneller darauf zugreifen können, und wir kopieren die
vorgefertigten Daten zum Starten des Blitters durch direkten Zugriff auf die
CPU-Register. Sehen wir uns ein Beispiel an:

	Lea	$dff002,a6			; a6 = DMAConR
	Move.l	DataBlit(pc),a5	; dann zeigt a5 auf eine Wertetabelle
							; vorberechnet

; Laden wir nun die Adressregister

	Lea	$40-2(a6),a0		; a0 = BltCon0
	Lea	$62-2(a6),a1		; a1 = BltBMod
	Lea	$50-2(a6),a2		; a2 = BltApt
	Lea	$54-2(a6),a3		; a3 = BltDpt
	Lea	$58-2(a6),a4		; a4 = BltSize
	Moveq	#6,d0			; d0 Konstante zur Überprüfung des Zustands
							; des Blitters.
	Move.w	(a5)+,D7		; Anzahl der Blittings
	Move.w	#$8400,$96-2(a6) ; nasty enable
BLITLOOP:
	Btst	d0,(a6)			; Wie immer warten wir auf das Ende einiger
	Bne.s	BLITLOOP		; Operationen.
; Bevor wir nach unten schauen, machen wir eine
; Beobachtung, wenn ich in a0 den Wert $40000 habe
; führe ich die Anweisung in drei verschiedenen Fällen aus
							; a)Move.b #"1",(a0)
							; b)Move.w #"12",(a0)
							; c)Move.l #"1234",(a0)
							; Ich werde die folgende Sache bekommen:
							;           (a)	(b)	(c)
							; $40000	"1"	"1"	"1"
							; $40001	"0"	"2"	"2"
							; $40002	"0"	"0"	"3"
							; $40003	"0"	"0"	"4"
							; Wir werden jetzt so etwas tun...
	Move.l	(a5)+,(a0)		; $dff040-42 das ist Bltcon0-Bltcon1
	Move.l	(a5)+,(a1)		; $dff062-64 das ist BltBMod-BltAMod
	Move.l	(a5)+,(a2)		; $dff050 - Kanal A
	Move.l	(a5)+,(a3)		; $dff054 - Kanal D
	Move.l	(a5)+,(a4)		; $dff058 - BLTSIZE... START!!
	Dbra	d7,BLITLOOP		; Dies für d7 mal.


In diesem Beispiel haben wir verschiedene Optimierungstechniken verwendet, die
wir bereits besprochen haben, auf jeden Fall wollen wir einige davon sehen.
Zuallererst, wenn wir eine Schleife mehrmals ausführen müssen und sich im
Inneren eine Operation befindet, die eine Konstante (d.h. ein unmittelbares
Datum) beinhaltet ist es besser, diesen Wert in ein Register zu schreiben, das
nicht in der Schleife verwendet wird. Dann Führen Sie die Operation mit diesem
Wert direkt mit dem Register in der Schleife aus, das es enthält, um den
Zugriff auf den Speicher zu vermeiden.
In unserem Fall haben wir diese Strategie verwendet, indem wir den Bit-Wert
zum Testen in das Register d0 geladen haben, um zu überprüfen, ob der Blitter
seine Aufgabe beendet hat.
In der Praxis haben wir eine der ersten Regeln übernommen, die ich eingangs
erwähnt habe, und zwar immer zu versuchen, die Werte in den Registern zu
halten. Außerdem haben wir $dff002 als Basis verwendet und nicht $dff000. Das
wurde gemacht, um die Zeit zu eliminieren, die im Waitblit zur Berechnung des
Offsets verwendet wird:

	Btst	#6,2(a6)		; a6 = $dff000

Es ist langsamer als:

	btst	d0,(a6)			; a6 = $dff002, d0 = 6

Denken Sie daran, vor (a6) eine -2 zu setzen, um den richtigen Versatz zu
erhalten:

	$54-2(a6)				; BltDpt
	$58-2(a6)				; BltSize
	$96-2(a6)				; DmaCon
	...

Es ist wichtig, dass der Waitblit schnell ist, denn je früher er "merkt", dass 
der Blitt vorbei ist, desto eher beginnt der nächste!
Vermeiden Sie aus diesem Grund, den Waitblit mit einem BSR aufzurufen und
setzen Sie ihn immer vor Ort ein, und wiederhole ihn sogar jedes Mal, wenn Sie 
ihn brauchen.
Den gleichen Diskurs, den wir jetzt gemacht haben, haben wir auch auf die 
Register des Blitters angewendet, indem wir sie in die CPU-Register geladen
haben, um den Zugriff auf den Speicher zu vermeiden (in der Praxis greifen wir
ohnehin auf den Speicher zu, um den Blitter zu initialisieren, aber wir
vermeiden es, jedes Mal die Adresse aus dem Speicher zu holen).
Wir haben auch einen Trick verwendet, den jeder verwendet, der Spiele oder
Demos programmiert. Das heißt, anstatt die Abmessungen des Bobs im Speicher zu
halten und dann den bltsize-Wert zu berechnen, behalten wir den bltsize-Wert
direkt bei. Wir haben es über die DataBlit-Tabelle gemacht. Aber wie ich oben
erwähnt habe, kann der 68000 jedoch etwas anderes tun, während der Blitter
arbeitet, zum Beispiel, wenn der Blitter einen Speicherbereich löscht, kann der
68000 als guter Christ, ihm zum Beispiel helfen:


	btst	#6,2(a6)
WaitBlit:
	btst	#6,2(a6)
	bne.s	WaitBlit
	Moveq	#-1,d0
	Move.l	d0,$44(a6)			; -1 = $ffffffff
	Move.l	#$9f00000,$40(a6)
	Moveq	#0,d1
	Move.l	d1,$64(a6)
	Move.l	a0,$50(a6)
	Move.l	a1,$54(a6)
	Move.w	#$4414,$58(a6)		; Der Blitter beginnt zu reinigen...
	Move.l	a7,OldSp
	Movem.l	CLREG(pc),d0-d7/a0-a6	; Register reinigen
	Move.l	Screen(pc),a7		; Adresse der zu löschenden Zone
	Add.w	#$a8c0,a7			; zum Ende gehen (+$a8c0)

	Rept		1024			; der 68000 beginnt mit der Reinigung
	Movem.l	d0-d7/a0-a6,-(a7)	; 60 Bytes reinigen 1024 Mal
	EndR

	Lea	$dff000,a6
	Movea.l	OLDSP(pc),a7
	Rts

CLREG:
	ds.l	15


Wie Sie sehen können, reinigen hier der Blitter und die CPU zur Hälfte
den Bildschirm "gleichzeitig". Natürlich darf in diesem Fall das blitter
nasty nicht gesetzt sein, sonst kann die CPU nicht in Ruhe reinigen.

Der beste Weg, die Leistung Ihres Programms zu steigern, ist jedoch sehr
oft, die eigenen Algorithmen zu verbessern. Denken sie zum Beispiel nicht,
dass die Implementierung eines schlechten Sortieralgorithmus in Assembler wie
Bubble Sort schneller ist als der beste Sortieralgorithmus wie z.B. Quick
Sort, der in C implementiert ist.
Wenn Ihr Algorithmus auch nach Anwendung der besten Optimierungstechniken
einfach nicht schneller laufen will, dann löschen Sie ihn und schreiben Sie
ihn komplett neu mit einem besseren Algorithmus von Anfang an.
Und selbst wenn Sie den besten Algorithmus haben, versuchen Sie ihn immer zu
optimieren, sodass es auf Computern ausgeführt werden kann, die auch nicht
schnell sind. Nicht wie in der Welt der PCs, wo ein 486-Programmierer
zufrieden ist, wenn der Code nur auf seiner eigenen Konfiguration schnell
ausgeführt wird.

Was braucht es, um schnelle Routinen zu machen, wenn dann auf der Verpackung
des Spiels oder des Programms zu lesen ist: 
MINDESTKONFIGURATION: PENTIUM 60MHz mit 8MB RAM.

