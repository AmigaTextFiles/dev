Lektion 17

1. ReadMe.txt
2. copper.txt
3. plasm.txt
4. shadebobs.txt
5. Display
6. Copper



      ____ ___ _____  ___  ___  ___  ___
     (_,  V   ),  . \|,  ~]   |(___)|   |
..-----|o      |o  |  )o  7o  | \o  /o|  |------.    ^    ^    ^    ^   ^
|  ___|___Y___|_____/|___!_____/___L____|____  |   +----------------------+
| ( , !   )___)/,___)(___),  . \|,  \  \/,___) |   |Feel the DEATH inside!|
`--\o    /|o  (___  \|o  |o  |  )o      )__  \-'   `----------------------'
.p.\___/ |___(______)___!_____/|___!___|_____)       v    v    v    v   v

 WHQ: Extrema +39-861-413362
 IHQ: DoWn ToWn +39-2-48000352


Das gesamte Material in diesem Verzeichnis ist *** COPYDEATH *** Morbid
Visions. Die Morbid Visions (oder einer der Autoren) übernehmen keine
Verantwortung für direkte oder indirekte Schäden, die durch die Verwendung des
oben genannten Materials verursacht werden, einschließlich Kochen des Monitors!

ANMERKUNGEN ZU DEN QUELLEN
Die Quellen wurden für den ASM-One 1.29 von T.F.A. geschrieben. Alle Quellen
haben am Anfang ein INCDIR "Infamy: MV_Code/". Zum Assemblieren müssen Sie ein
"ASSIGN INFAMIA:" für das Verzeichnis ausführen, das den MV_Code-Verzeichnis
enthält oder Sie müssen die INCDIRs in den Quellen bearbeiten. All die Quellen
verwenden denselben Startcode, der in der Datei MVStartup.S enthalten ist.
Dies ist ein SEHR einfacher Startcode, der nur für Tests verwendet werden kann.
Verwenden Sie ihn nicht für Ihre Demos!

In den Quellen verwenden wir die dunklen Regeln, die durch die dunklen Texte
der Coding Mortale festgelegt wurden, den Büchern, in denen die Philosophie
der Codierung der Morbid Visions zum Ausdruck kommt. Um das Lesen für
diejenigen zu erleichtern, die an die Quellen von Randys Kurs gewöhnt sind,
listen wir einige der Dunklen Regeln auf, die sich von den Konventionen 
unterscheiden, die während des Kurses befolgt wurden:

- Die Größe der Operanden wird nur angezeigt, wenn sie von der 
Standardeinstellung unterschiedlich ist. (Denken Sie daran, dass dies
standardmäßig der Fall ist, wenn nichts angegeben ist geht ASMOne davon aus,
dass die Dimension WORD ist, mit Ausnahme von Anweisungen mit fester Größe,
wie z.B. Scc (mit BYTE-Dimension), BTST (mit der Dimension BYTE, wenn sich das
Ziel im Speicher befindet und LONG, wenn das Ziel ein Register ist) usw.

Zum Beispiel:
 move	d0,d1		entspricht		move.w	d0,d1
 btst	#6,$bfe001	entspricht		btst.b	#6,$bfe001
 btst	#14,d0		entspricht		btst.l	#14,d0
 lea	label,a0	entspricht		lea.l	label,a0

- Der Blitter-Double-Wait-Test wird NICHT durchgeführt: Um auf den Blitter
zu warten führen wir einfach durch:

.wait
	btst	#6,dmaconr(a5)		; warte auf den Blitter
	bne.s	.wait

Der berühmte Agnus BUG ist nur in sehr wenigen zusammengesetzten Exemplaren
auf dem ersten A1000 vorhanden und tritt auch nur unter bestimmten Umständen
auf. Dieser Fehler ist alltäglich geworden, aber eigentlich hat niemand ihn
gesehen. Die Tests, die wir mit dem Hobbit / MV A1000 durchgeführt haben,
haben den BUG nicht gefunden. ALLE unsere OCS-Routinen funktionieren
ALLE AUF OCS Amigas OHNE den Doppeltest. Wenn nun auch die AGA-Ära auf den 
Sonnenuntergang zugeht macht es keinen Sinn, diesen unnötigen zusätzlichen
BTSTs mitzunehmen, das ruiniert nur die Ästhetik der Quellen.

- Oft werden MACROs und lokale Labels verwendet, die den Code verbessern
ordentlich und leserlich.

 Morbid Visions


 2. Datei copper.txt

 VERY ADVANCED COPPER


In diesem Artikel werden wir über die fortgeschrittenen Programmiertechniken
des coppers sprechen. Die Inspiration für diesen Artikel war, als ich in
Lektion 11 des Asm-Kurses von Randy las, dass die Anweisung SKIP des Coppers
nutzlos ist. Ich bin nicht dieser Meinung und während des Kursschreiben (an dem
ich mitgearbeitet habe, indem ich in den Lektionen 7, 9 und 10 die meisten
geschrieben habe) teilte ich dies Randy anhand einiger Beispiele mit. Ich habe
ihn gebeten, sie in Lektion 11 mit aufzunehmen. Leider hat Randy das nicht
getan, vielleicht aus Zeitmangel oder vielleicht weil er das Material verloren
hat, dass ich ihm geschickt hatte. Aber ich mag die Idee nicht, dass junge
Programmierer, die den Kurs gelesen haben (wie viele gibt es?), glauben, dass
der SKIP nutzlos ist, weil es im Gengensatz zu einem der dunklen Axiome der
Philosophie steht - Morbide Visionen:

 Amiga RULEZ => Hardware Amiga perfekt => HW frei von unnötigen Dingen.

Der AGA weist ebenfalls Defekte auf, der OCS jedoch nicht. Also dachte ich
über das Schreiben nach. In diesem Artikel geht es um SKIP und auch um die
Maskierung von Koordinaten des coppers, ein Thema, das im Kurs eher 
zusammenfassend behandelt wird. Wir werden in der Tat sehen, dass SKIP in
einigen Fälle sehr nützlich ist und dass die Möglichkeiten der Maskierung der
Koordinaten des coppers viel größer ist als erklärt wurde, zum Beispiel werden
wir sehen, dass auch die horizontalen Positionen maskiert werden können. Die
Techniken, die wir in diesem Artikel behandeln, können uns nicht das Ray
Tracing in Echtzeit erlauben (sonst hätte Randy es auch bemerkt), aber unter
bestimmten Umständen können sie uns jedoch einige kostbare Rasterzeilen
ersparen. Und wie in den dunklen Texten der tödlichen Kodierung behauptet wird,
dass eines der Ziele eines Codierers darin besteht, die Hardware maximal
auszunutzen, müssen wir auch in der Lage sein, diese Techniken auszunutzen.
Beginnen wir mit einer detaillierteren Beschreibung des vom copper verwendeten
Formats für WAIT- und SKIP-Anweisungen. Diese 2 Anweisungen haben ein sehr
ähnliches Format, darum werden wir eine einzige Beschreibung für beide machen.
Die Beschreibung Über die Funktionsweise des SKIP werden wir später sehen. Wie
Sie wissen besteht jede copper-Anweisung aus 2 WORTEN. Das Format des ersten
Wortes ist in der folgenden Tabelle beschrieben:

     ERSTES WORD INSTRUKTION WAIT UND SKIP
     -------------------------------------
     Bit 0           Immer auf 1 einstellen.

     Bits 7 - 1      Horizontale Position des Elektronenstrahls (HP).

     Bits 15 - 8     Vertikale Position des Elektronenstrahls (VP).

Diese beiden Aussagen basieren auf dem Verhalten, der Überprüfung eines 
bestimmten Zustands, welches (normalerweise) das Erreichen bzw. die Überwindung
der Position durch den Elektronenstrahl ist, die durch die VP- und HP-Bitfelder 
angegeben wird. Wie wir gleich sehen werden, ist es möglich, diesen Zustand
durch Halten zu ändern. Wir berücksichtigen auch den Zustand des Blitters.
Später werden wir auch das Verhalten des SKIP beschreiben. Schauen wir und das
zweite WORT an:

     ZWEITES WORD INSTRUKTION WAIT UND SKIP
     --------------------------------------
	 Bit 0           Für WAIT auf 0 und für SKIP auf 1 setzen.

	 Bits 7 - 1      Bit Maske Position horizontal (HE).

	 Bits 14 - 8     Bit Maske Position vertikal (VE).

     Bit 15          Blitter-finished-disable bit. 
					 Normalerweise auf 1 eingestellt.

Bit 0 wird vom copper verwendet, um zu wissen, ob der betreffende Befehl ein
WAIT oder ein SKIP ist. Die HE- und VE-Bitfelder werden jeweils zur Maskierung 
der horizontalen und vertikalen Positionen verwendet. Die Operation ist wie
folgt: Der copper vergleicht den von HP und VP angegebenen Standort mit der
Position des Elektronenstrahls unter Verwendung nur der Bits, bei denen die
entsprechenden Bits von HE und VE auf 1 gesetzt sind. Wenn wir zum Beispiel bei
einem WAIT die Bits von HE alle auf 1 setzen, während die Bits 8-12 von VE
auf 0 und die Bits 13 und 14 auf 1 gesetzt sind, wartet der copper darauf, dass
der Elektronenstrahl die horizontale Position HP (weil alle Bits von HE auf 1
sind) und die vertikale Position, bei denen die Bits 13 und 14 von HE gleich
den Bits 13 und 14 von VP erreicht sind (weil sie die einzigen Bits von VE
sind, die auf 1 gesetzt sind). Sehen wir uns einige bemerkenswerte Fälle an.
Wenn wir ALLE HP- und VP-Bits verwenden möchten (dh wir verwenden nicht die
Maskierung) müssen wir alle Bits von HE und VE auf 1 setzen. In diesem Fall,
wenn wir ein WAIT haben, nimmt das zweite WORT den Wert $FFFE an. Sie kennen
es gut. Wenn wir stattdessen ein WAIT wollen, das die vertikalen Positionen
vollständig ignorieren, aber alle Bits der horizontale berücksichtigen,
erhalten wir für das zweite WORT den Wert $80FE, wie es z.B. im Beispiel in
Lektion 11 von Randys Kurs ist.
Mit Bit 15, dieser Option können Sie die Bedingung ändern, die in den beiden
Anweisungen überprüft wird, wenn dieses Bit auf 1 gesetzt wird. Andernfalls
verhalten sie sich normal.
Sie müssen auch überprüfen, ob der Blitter einen möglichen Blitt beendet hat.	
(dh BLTBUSY, Bit 14 von DMACONR muss 0 sein). Zum Beispiel, im Fall von WAIT
wartet es mit dem fraglichen Bit bei 0, ob die durch die VP- und HP-Bits
angegebene Videoposition erreicht ist und es wird auch auf das Ende eines
möglichen Blitts gewartet. Dies kann in dem Fall hilfreich sein, wenn Sie
Blittings durchführen möchten, die mit der Position der Elektronenstrahls
elektronisch synchronisiert sind.

Die Aufmerksamen werden die Tatsache nicht übersehen haben, dass aufgrund der
Anwesenheit des Blitter Finished Disable-Bit, die VE-Bits eins weniger als
die VP-Bits sind. Genauer gesagt gibt es in VE kein Bit, das dem höchsten Bit 
korrospondierend von VP entspricht. Dies bedeutet, dass dieses Bit (Bit 8 der
vertikalen Position des Bildschirms) NICHT maskiert werden kann. Dieser Fakt
hat wichtige Konsequenzen. In der Tat wird in Anwendungen die Maskierung
verwendet, um Anweisungen zu haben, die sich auf die gleiche Weise in
verschiedenen Bildschirmpositionen verhalten. Die Tatsache, nicht in der Lage
zu sein Bit 8 der vertikalen Position zu maskieren, verhindert daher das
Haben von Anweisungen, die sich in Bereichen des Bildschirms gleich verhalten,
die Bit 8 der unterschiedlichen vertikalen Position haben.
Das typische Beispiel, dass auch von Randy gezeigt wird, ist das WAIT, dass
auf eine bestimmte horizontale Position wartet, unabhängig davon, in welcher
Zeile es sich befindet. Wenn wir versuchen würden solch ein WAIT durch Setzen
von DC.W $00xx,$80FE zu machen, würden wir tatsächlich ein WAIT bekommen, dass
auf eine Bildschirmposition wartet, bei der Bit 8 der vertikalen Position 0
und die horizontale Position xx ist. Die Anweisung wird ausgeführt, wenn Bit 8
und die Elektronenstrahlposition gleich 0 ist und es wartet nach Wunsch darauf,
dass der Elektronenstrahl die horizontale Position xx erreicht hat.
Ansonsten wenn Bit 8 der vertikalen Position des Elektronenstrahls 1 ist und		
das Bit 8 von VP 0 ist, wird die WAIT-Bedingung sofort überprüft, daher
blockiert solche Anweisung NICHT den copper. Wegen dieses Phänomens behauptet
Randy in seinem Kurs funktioniert das Maskieren nicht bei Zeilen zwischen $80
und $FF. Dies ist eine entschieden voreilige Schlussfolgerung.
In der Tat, um den gewünschten Effekt zu erzielen, verwenden Sie einfach ein
WAIT, dass die niedrigen Bits von VP, wie im vorherigen Fall maskiert, aber das
nicht maskierbare Bit von VP bei 1 platziert, was ein DC.W $80xx,$80FE ist.
Solches WAIT in den Zeilen zwischen $80 und $FF hat gleichzeitig das nicht 
maskierbare Bit von VP, d.h. den Wert von Bit 8 der vertikalen Position des
Elektronenstrahls und es wird daher in jeder Zeile auf die horizontale Position
xx gewartet. Als Beispiel-Anwendung schlagen wir den Effekt in der Quelle
MV_Code / Copper / mask1.s vor wie von Randy verwendet, um die Maskierung
vertikaler Positionen (im Gegensatz zu Randy) in Zeilen zwischen $80 und $FF
zu veranschaulichen.
Erlauben Sie uns an dieser Stelle, respektable Leser, den Anfang des 
Scrolltextes des berühmten INTROs KickReset von Razor 1911 zu paraphrasieren.
"Randy sagte uns, dass dies nicht möglich war ... trotzdem ist es hier !! :))

Es sollte jedoch beachtet werden, dass ein maskiertes WAIT bei dem Bit 8 von VP
auf 1 gesetzt ist, wenn es in einer Zeile ausgeführt wird, in der Bit 8 der
vertikalen Position gleich Bit 8 der vertikalen Position gleich 0 ist, wird der
Copper IMMER blockiert, da die Nummer der Zeilennummer immer kleiner als
die in WAIT angegebene Position betrachtet wird.

Dies bedeutet, dass das WAIT unseres Beispiels den gewünschten Effekt erzielt
(Warten auf die horizontale Position xx NUR in Zeilen zwischen $80 und $FF.) 
Was wäre, wenn wir die WAIT-Maske auf den gesamten Bildschirm verwenden
wollten?? Die Quelle MV_Code / Copper / mask2.s ist genau eine Implementierung
des in der vorherigen Quelle, die über den Bildschirm funktioniert. Ich
verweise auf den Quellkommentar für eine Beschreibung der verwendeten
Techniken.

Wir kommen also zur Anweisung SKIP. Wie bereits erwähnt, hat es ein sehr 
ähnliches Format wie bei WAIT. Das Verhalten des SKIP ist wie folgt:
es bewirkt, dass der copper die folgende Anweisung überspringt, wenn der
Elektronenstrahl die angegebene Position erreicht bzw. überschritten hat.
Betrachten Sie beispielsweise folgende Anweisungen:

		dc.w	$4037,$ffff	; Skip (überspringen),
							; wenn Sie die Zeile $40 überschreiten
ISTR1:	dc.w	$182,$0456	; copper move-Anweisung
ISTR2:	dc.w	$182,$0fff	; copper move-Anweisung

Wenn der copper den SKIP-Befehl ausführt, prüft er, wo der Elektronenstrahl
ist und ob die durch die Bits VP und HP des SKIPs angegebene Position 
(im Beispiel HP = $36 und VP = $40) überschritten wurde. Wenn ja überspringt
der copper die folgende Anweisung (bei ISTR1) und führt die Anweisung 
danach aus (dh die Anweisung bei ISTR2). Wenn stattdessen der Elektronenstrahl
noch nicht die angegebene Position erreicht hat wird (normalerweise) die
nächste Anweisung ausgeführt, als ob der SKIP nicht vorhanden wäre.
Wie wir bereits gesagt haben, hat die Maskierung der Positionen mittels der
VE- und HE-Bits des zweiten WORD eine selbe Art und Weise wie beim WAIT.					
Darüber hinaus kann auch für den SKIP das Bit Blitter Finished Disable auf 0
sein, wodurch der Sprung unter Berücksichtigung des Status des Blitters
durchgeführt wird.

Mit SKIP können Sie Schleifen in der copperliste erstellen. D.h.
In der copperliste befinden sich eine Reihe von Copperanweisungen, die
wiederholt werden bis der Elektronenstrahl eine bestimmte Position erreicht.
Zur Realisierung der Schleife wird auch das COP2LC-Register verwendet. Der
Mechanismus ist durch das folgende Beispiel veranschaulicht:

im Hauptprogramm

	move.l	#Copperloop,COP2LC(A5)	; schreibt die Schleifenadresse
									; im COP2LC-Register

und in die copperliste geben Sie die folgenden Anweisungen ein:

	dc.w	$2007,$FFFE	; WAIT Zeile $20
Copperloop:
	dc.w	$180,$F00	; copper Anweisungen der Schleife
	dc.w	$180,$0F0
	dc.w	$180,$00F

	.
	.

	dc.w	$180,$F0F	; letzte Anweisung der Schleife
	dc.w	$4007,$ffff	; SKIP wenn Sie die Grenze $40 überschreiten 
	dc.w	$8a,0		; COPJMP2 Springe zum Anfang der Schleife

	dc.w	$182,$00F	; Anweisung außerhalb der Schleife

Die Bedienung ist sehr einfach. Nach der Zeile $20 tritt der copper in die
Schleife. Nachdem alle Anweisungen der Schleife ausgeführt wurden, gelangt es
zum SKIP. An diesem Punkt, wenn der Elektronenstrahl die Zeile $40 noch 
NICHT überschritten hat (dh er ist höher auf dem Bildschirm) überspringt
der copper NICHT die folgende Anweisung. Die folgende Anweisung schreibt jedoch
in COPJMP2. Dies führt zu einem coppersprung zu der in COP2LC geschriebenen
Adresse. An der Adresse steht der erste Befehl der Schleife. Auf diese Weise
wird die Schleife wiederholt. Nach einer bestimmten Anzahl von Wiederholungen
wird der Elektronenstrahl die $40-Linie erreichen. Zu diesem Zeitpunkt, erfolgt
SKIP und der copper überspringt den Befehl, in COPJMP2 zu schreiben.
Auf diese Weise springt es nicht mehr zum Anfang der Schleife, sondern führt
den ersten Befehl außerhalb der Schleife aus.

Wofür sind die Schleifen in der copperliste gut? Es ist klar, dass wir es immer 
auch ohne machen können: Anstatt die Schleife zu machen, schreiben wir so oft
den Teil der copperliste der wiederholt werden soll. Auf diese Weise sparen wir
uns das SKIP und die Anweisung, die in COPJMP2 schreibt, die den copper etwas
langsamer macht. Die Verwendung von Schleifen hat jedoch einige Vorteile: An
erster Stelle sparen wir Speicher, weil wir nur das "kurze" Stück copperliste
schreiben. Zweitens, wenn das wiederholte Copperlistenstück vom Prozessor
modifiziert werden muss, um einen Effekt zu erzielen, muss natürlich nur das
Copperlistenstück einmal (durch die Schleifen) modifiziert werden, was die
Arbeit des Prozessors erheblich beschleunigt.

Die Verwendung von WAIT-Anweisungen in Schleifen ist mit einigen Problemen
verbunden. Angenommen, wir haben eine Schleife, die sich von Zeile $20 bis
Zeile $70 wiederholt und innerhalb der Schleife ein WAIT in Zeile $38.
Was geschieht? Bei der ersten Ausführung der Schleife blockiert das WAIT den
copper. Nach Zeile $38 wird der copper entsperrt, erreicht das Ende der
Schleife und wiederholt es. An diesem Punkt, wenn der Elektronenstrahl die 
Zeile $38 passiert hat, wird das WAIT keinen copper mehr blockieren. Als
Ergebnis führt die Ausführung der ersten Iteration der Schleife zu
unterschiedlichen Ergebnissen gegenüber den folgenden Iterationen.

Normalerweise ist dies nicht das, was Sie wollen. In Schleifen mit dem copper
wäre es wünschenswert, auf eine bestimmte Zeile in der Anzeigenschleife jeder
Iteration warten zu können. Zum Beispiel möchten Sie vielleicht so etwas:

CopperLoop:
		; verschiedene Anweisungen

		Warten Sie 4 Zeilen ab dem Beginn der Iteration

		; verschiedene Anweisungen

		Wiederholen Sie die Schleife bis zu einer bestimmten Zeile.

Wie kann ein solcher Mechanismus implementiert werden? Es ist notwendig ein
WAIT mit einigen maskierten Teilen der vertikalen Position zu verwenden.
Angenommen, wir haben eine Schleife, die 16 Rasterzeilen umfasst und die wir
von Zeile $10 bis Zeile $70 wiederholen möchten, dh für 96 Zeilen. Da 96/16 = 6
ist, führt der copper 6 Iterationen durch. Beachten Sie, dass 96 durch 16 
teilbar ist (es gibt keinen Rest), was bedeutet, dass der Elektronenstrahl
genau dann Zeile 96 erreicht, wenn der copper die sechste Iteration beendet. 
Wir wollen in jeder Iteration der Schleife, dass der copper in der vierten
Zeile ab dem Beginn der Iteration hängt.

Um dies zu erreichen, verwenden wir ein WAIT, in dem wir die signifikanten
Bits der vertikalen Position maskieren. In diesem Fall, da die Schleife
sich alle 16 Zeilen wiederholt, muss sich das WAIT alle 16 Zeilen gleich
verhalten und muss nicht die Positionsunterschiede zwischen einer Gruppe von 16 
Zeien und die anderen berücksichtigen. Daher müssen nur die 4 Bits die eine
Gruppe von 16 Zeilen bilden berücksichtigt werden.
Um die Bits der vertikalen Position zu maskieren, werden wie im Kurs erklärt
die Bits von 8 bis 14 des zweiten Wortes des WAIT verwendet.
Wenn eins dieser Bits auf 1 gesetzt wird (wie üblich), wird das entsprechende
Bit der vertikalen Position genutzt. Andereseits wenn eines dieser Bits
zurückgesetzt ist, ist es maskiert.

Betrachten wir zum Beispiel Folgende WAIT Anweisung:

	dc.w	$0301,$8FFE

Diese Anweisung wartet auf die vierte Zeile einer Gruppe von 16 Zeilen. Mal			
sehen was in unserem Beispiel passiert?  Die Schleife beginnt in Zeile $20.
Das copper führt die ersten Anweisungen aus und erfüllt das WAIT. Es werden
nur die 4 Bits weniger bedeutsam als die Position berücksichtigt, auf die es
auf eine Zeile wartet das diese 4 Bits auf dem Wert $3 hat (tatsächlich im
zweiten WORT die Bits 12, 13, 14 die den Bits 5, 6 und 7 der vertikalen
Position entsprechen, liegen bei 0).

Dies geschieht in Zeile $23. Zu diesem Zeitpunkt wird der copper entsperrt. Die
zweite Wiederholung der Schleife beginnt bei Zeile $30. Auch hier kommt der
copper zum Wait und wartet auf eine Zeile mit den 4 niedrigstwertigen Bits
mit dem Wert $3. Das passiert in Zeile $33, die immer noch die vierte Zeile
der Schleife ist.
Dieses Verhalten wird bei jeder nachfolgenden Iteration wiederholt. Wenn wir 
8 Zeilen lange Iterationen mit WAITs dieses Typs wollten, sollten wir nur die
3 niedrigstwertigen Bits der Position aktiviert lassen. Beachten Sie, dass
diese Technik nur dann leicht zu implementieren ist, wenn die Länge einer
Iteration eine Potenz von 2 ist. Ein Beispiel für eine Copperschleife ist die
Quelle MV_Code / Copper / skip1.s.

Eine Einschränkung der Verwendung von WAITs in der von uns gezeigten Weise ist
aufgrund der Tatsache, dass das höchstwertige Bit der vertikalen Position nicht
maskiert werden kann. 
 
Dies verhindert, dass wir Schleifen erstellen, die sich	in gleicher Weise
verhalten wie über der Zeile $80, wo das höchstsignifikante Bit 0 ist, beide
unten, wobei das höchstwertige Bit 1 ist, gerade weil wir diesen Unterschied
nicht durch maskieren ignorieren können.

Die einzige Lösung besteht darin, zwei Schleifen zu verwenden, von denen eine
oberhalb von $80 und eine darunter ausgeführt wird, wie in
MV_Code / Copper / skip2.s gezeigt.

Ein etwas komplexeres Beispiel ist die Quelle MV_Code / Copper / skip3.s.
In dieser Quelle werden die copperlisten mit MACROs anstatt mittels DC.W
geschrieben. Mit MACROs kann beispielsweise CMOVE $0f0,COLOR00 geschrieben
werden, anstelle von DC.W $180,$0f0 und im Fall von WAIT WAIT $07 $60
anstelle von DC.W $6007,$FFFE. Es ist eine stilistische Wahl, die (mir
persönlich) die Quellen viel sauberer und aufgeräumter macht. Auch (in diesen)
vermeiden Sie so viele "ablenkende" Fehler beim Schreiben der copperliste, wie
z.B. zu vergessen, dass das Bit 0 des ersten WAIT-Wortes auf 1 eingestellt sein
MUSS. Im ersten Teil des Artikels habe ich sie nicht verwendet, weil ich
während der Erklärung des SKIPs sie nicht mit weiteren Ideen verwirren wollte.
Ich empfehle daher jedem, sie zu benutzen. In der Quelle dort sind reduzierte
Versionen meiner Makros, die Sie verbessern und in Ihre Quellen aufnehmen
können.

Mit SKIPs können Sie natürlich Wiederholungsschleifen sogar innerhalb der
gleichen Zeile des Bildschirms erstellen. Wegen der Langsamkeit des coppers,
(1 Anweisung = 8 Pixel) ist die Anzahl der Iterationen pro Zeile
normalerweise ziemlich klein. Sie können ein Beispiel in der Quelle 
MV_Code / Copper / skip4.s sehen.

                                       The Dark Coder / Morbid Visions

3. Datei plasm.txt


Das Plasma		(Lektion von The Dark Coder)

In diesem Text werden wir über den "Plasma"-Effekt sprechen. Insbesondere
werden wir sehen, wie wir Plasmaeffekte mit Techniken, die bei allen Amiga
angewendet werden können erstellen. Heutzutage dank des AGA-Chipsatzes und der
68020-Prozessoren und höher werden auch verschiedene Plasmen hergestellt,
basierend auf Techniken wie "chunky Pixel". Die Effekte, die wir in diesem
Text diskutieren werden, können jedoch auch auf dem guten alten Amiga 500
verwendet werden.
Die grundlegende Technik zur Herstellung eines Plasmas ist die Verwendung
einer copperliste, die einige Farbregister kontinuierlich ändert, mittels
aufeinanderfolgenden "copper moves". Wir haben bereits in Lektion 11 gesehen,
wie man viele copperlisten dieses Typs baut und benutzt. Insbesondere in
den Beispielen Lektion11g1.s, Lektion11g2.s und Lektion11g3.s, in denen wir
Farb-Gradienten mit copperlisten gemacht haben, in dem wir den Inhalt von
COLOR00 verändert haben.
Es handelt sich jedoch um statische copperlisten. Der Hauptunterschied zwischen
diesen Beispielen und Plasma ist genau das: Bei einem Plasmaeffekt wird eine
copperlist so strukturiert verwendet, aber dynamisch, so dass in jedem Frame
die Farben im COLOR00-Register geschrieben werden. 
Jeder "copper move" besteht aus 2 Wörtern:

	dc.w	$180,COLOR	; Struktur eines "copper move"

Das erste Wort enthält die Adresse von COLOR00 und das zweite den Wert von
schreibe in dieses Register. Um den Plasmaeffekt zu erzielen, müssen wir 
diesen Wert bei jedem Frame variieren, dh wir müssen jedes Mal einen anderen
Wert in das zweite Wort schreiben, das den "copper move" macht.
Das Problem ist, dass wir diesen Vorgang für alle "copper moves" wiederholen
müssen, die Teil der copperlist sind. Es ist daher eine große Menge von zu
ändernden Daten. Da sich die copperliste im CHIP-RAM befindet, können wir den
Blitter verwenden, um Änderungen vorzunehmen.
Abschließend also, der Plasma-Effekt, wird durch eine Routine hergestellt,
die (unter Verwendung des Blitters) aus einer Tabelle Farben liest und sie in 
die copperliste kopiert. Durch Variieren, der kopierten Farben in jedem Frame
wird das Plasma erstellt. Beachten Sie, dass für diesen Effekt die Verwendung
von Bitplanes nicht erforderlich ist, da Sie alles durch ändern der
Hintergrundfarbe machen.
Aus diesem Grund wird es als "0-Bitebenen"-Plasma bezeichnet, im Gegensatz zu
den anderen Varianten, die wir später sehen werden. Ein Beispiel für ein
0-Bitebenen-Plasma ist plasm1.s.
Eine signifikante Verbesserung des Effekts ist das RGB-Plasma. Es unterscheidet
sich vom normalem Plasma, weil die Farben nicht einfach aus einer Tabelle
kopiert werden, sondern wie folgt "berechnet" sind:
Die Komponenten R, G und B werden separat gelesen (aus 3 verschiedenen Quellen
einer Farbe) und werden dann mit einem OR verknüpft. Auf diese Weise, weil die
Komponenten R, G und B kontinuierlich zwischen einem "copper move" und dem
anderen variieren werden mehr Farben produziert. In der Praxis wird eine
Blitt-Operation beim Kopieren verwendet, die ein ODER zwischen 3 Quellen
ausführt, die die Komponenten R, G und B enthalten. Ein erstes Beispiel für ein
RGB-Plasma ist plasm2.s.
Um den Effekt weiter zu verstärken, wird versucht, das Plasma so zu machen.
Eine einfache Möglichkeit, dies zu tun, besteht darin, die Start-Position
jeder Plasma-Zeile zu bestimmen. Dies kann sehr einfach durchgeführt werden
da die Startposition durch die WAIT-Anweisung bestimmt wird, die am Anfang 
jeder Zeile der copperliste steht. Eine Variation dieser Art ist in
plasm3.s dargestellt.
Leider haben jedoch die horizontalen WAIT Positionen eine Auflösung von
4 Pixel, was bedeutet, dass es nur möglich ist die Startposition des Plasmas in
"Schritten" von 4 Pixel zu variieren. In geeigneter Weise können die Parameter
des Beispiels plasm3.s Phänomens hervorgehoben werden.
Um weniger ruckartige Schwingungen zu erhalten, verwenden wir eine andere
Technik, das eine Bitebene verwendet und daher als "1-Bitebenen"-Plasma
bezeichnet wird. Die Technik ist die folgende: Es wird eine 8-Pixel-breite
vertikale "gestreifte" Bitebene verwendet. Auf diese Weise hat das Bild
8 Pixel, die mit COLOR00 gefärbt sind, dann 8 Pixel gefärbt mit COLOR01, dann
wieder 8 mit COLOR00 und so weiter. In der Korrespondenz verwenden wir eine
copperliste ähnlich der in den vorherigen Beispielen, aber es wechselt einen
"copper move" in COLOR00 mit einem in COLOR01. Die Situation ist dargestellt
durch die folgende Abbildung:

Ziel
des 
"copper move":	| COL.0 | COL.1 | COL.0 | COL.1 | COL.0 | COL.1  - - -


Zeile von
bitplane:	000000001111111100000000111111110000000011111111 - - -											

Wie Sie sehen können, besteht eine genaue Übereinstimmung zwischen der
angezeigten Farbe und dem geänderten Register der copperliste. Ein Farbregister
behält seinen Wert für einen Abstand von 16 Pixeln konstant, aber diese Farbe
wird nur für die 8 Pixel der Bitebene angezeigt, die sie auswählen (dh nur für
die 8 Pixel bei 0) im Fall von COLOR00 und nur die Pixel bei 1 im Fall von
COLOR01). Bisher haben wir mit unserer Bitplane genau das Gleiche gemacht wie
zuvor, als wir darauf verzichtet haben. Aber jetzt komt das Neue.
Wir können den Hardwarescroll benutzen, um die Bitebene horizontal zu bewegen.
Beachten Sie, dass wenn der Wert des Bildlaufs von 0 bis 7 variiert, bleibt
die Farbe jeder Gruppe von 8 Pixeln immer gleich. Tatsächlich variiert der in
einem Register enthaltene Wert alle 16 Pixel. Mit Scrollwerten von 0 bis 7
verschieben wir die Gruppe immer um 8 Pixel innerhalb dieses "Bandes" von
16 Pixeln. Wenn wir stattdessen größere Werte verwenden, werden einige der
Pixel in der Gruppe aus dem Band herauskommen, vorausgesetzt es ist eine neue
Farbe.
Schauen wir uns das Phänomen anhand einiger Zahlen genauer an. Beachten Sie,
wie die Farbregister ihren Wert pro Bänder von 16 Pixeln konstant halten.
Die Bänder der 2 Register überlappen sich: die Bänder von COLOR01 beginnen und
enden in der Mitte von COLOR00 und umgekehrt.
Wenn wir einen Scrollwert von 0 verwenden, haben wir die folgende Situation:

Wert in
COLOR01		        |	   Wert 1     |    Wert 2       |    Wert 3		|   - -
			V			      V	      V	       
scroll=0:	00000000.11111111.00000000.11111111.00000000.11111111 - - -
			^				  ^					^				  ^
Wert in		|				  |					|				  |
COLOR00		|    Wert 1		  |    Wert 2	    |    Wert 3		  |   - - 

Wie Sie sehen können, befindet sich jede Gruppe von 8 Pixeln mit dem Wert 0 in
Übereinstimmung mit den ersten 8 Pixeln (dh die am weitesten links liegenden)
jedes 16er-Bandes, für das COLOR00 einen konstanten Wert annimmt.
Gleiches gilt für Gruppen von 8 Pixeln in Bezug auf die 16-Pixel-Bänder, für
die COLOR01 auf 1 gesetzt die Konstante bleibt.

Mit zunehmendem Scrollwert bewegen sich die Gruppen von 8 Pixeln in Richtung 
der rechten Ränder der Bänder. Zum Beispiel. Folgendes passiert, wenn
der Scroll 4 Pixel beträgt:

Wert in 
COLOR01		        |    Wert 1    |    Wert 2    |    Wert 3  |   - - 
					V	           V	          V	       
scroll=4:	1111000000001111111100000000111111110000000011111111 - - -
			^			   ^	          ^		         ^
Wert in		|			   |	          |		         |
COLOR00		|    Wert 1    |    Wert 2    |    Wert 3    |   - - 

Wenn der Scrollwert 7 Pixel beträgt, werden die Gruppen von 8 Pixeln an den
Kanten an den rechten Seiten der Bänder ausgerichtet (bzw. die Pixel bei 0 mit
den Bändern von COLOR00 und und Pixel mit 1 mit den Bändern von COLOR01):


Wert in
COLOR01			    |    Wert 1    |    Wert 2    |    Wert 3		 |   - - 
					V			   V			  V	       
scroll=7:	1111111000000001111111100000000111111110000000011111111 - - -
			^			   ^			  ^				 ^
Wert in		|			   |			  |			     |
COLOR00		|    Wert 1	   |    Wert 2	  |    Wert 3    |   - - 


Sobald der Bildlauf 8 überschreitet, gehen die Gruppen von 8 Pixeln über die
Ränder der Bänder hinaus. Dies bedeutet, dass die 8 Pixel in der Gruppe nicht
mehr den gleichen Wert haben. Die folgende Abbildung zeigt die Situation für
einen Scroll von 8 Pixel.

Wert in
COLOR01		        |    Wert 1    |    Wert 2    |    Wert 3  |   - - 
					V	           V	          V	       
scroll=8:	11111111000000001111111100000000111111110000000011111111 - - -
		    ^			   ^	          ^		         ^
Wert in  	|	           |	          |		         |
COLOR00		|    Wert 1    |    Wert 2    |    Wert 3    |   - - 

In dieser Situation fallen die ersten 7 Pixel jeder Gruppe von 8 in ein Band
und daher erscheinen sie mit der im Farbregister enthaltenen Farbe für dieses
Band, während die letzten in das folgende Band fallen und daher in der Farbe
erscheinen, die vom Farbregister im neuen Band angenommen wird.
Dieses Phänomen schafft abrupte Farbveränderungen, die das Plasma unangenehm
machen. Dieser Effekt basiert auf dem "mischenden" Eindruck von Farben.
Im Beispiel plasm4.s wird diese Technik angewendet.
Die Verwendung von Bitebenen ermöglicht es uns auch, Masken von Plasmas
überlagernd zu verwenden. Ein Beispiel ist in plasm5.s.
Die in den letzten beiden Beispielen gezeigte Technik hat die Grenze in der 
horizontalen Schwingung, die auf eine Breite von 8 Pixel begrenzt ist. Dies
liegt an der Tatsache, dass jedes Farbregister über einen Bereich von 16 Pixeln
konstant bleibt und das jede Pixelgruppe 8 Pixel breit ist. Aus diesem Grund
kann sich die Gruppe im Bereich von 16-8 = 8 Pixel bewegen. Um die Breite der
Schwingungen zu erhöhen ist es notwendig, die Bänder zu verbreitern, und dazu
ist es notwendig mehrere Farbregister zu verwenden und es ist erforderlich die
Register alle 8 Pixel zu ändern.
Zusammenfassend ist es daher notwendig, eine Hauptanzahl der Bitebenen zu
verwenden. Beachten Sie, dass wir in den vorherigen Beispielen die Schwingungen 
mit dem Hardware-Scroll gemacht haben, der es uns ermöglicht, bis zu 16 Pixel
zu bewegen. Diese weitere Einschränkung kann durch Schwenken der Bitebenen 
mit dem Blitter überwunden werden. In diesem Fall erfordert die Schwingung
natürlich eine viel langsamere Routine und spezielle Tricks werden verwendet
um es zu erreichen.
In dem Beispiel plasm6.s, das diese "Monographie" über Plasma abschließt,
werden wir sehen, wie man ein Plasma mit einer horizontalen Schwingung von
56 Pixeln macht.
Alle Plasmen, die wir gesehen haben, können durch Variation von Paramtern
und die Tabellen, die die Farben (oder deren Komponenten) enthalten während
der Ausführung interessanter gemacht werden. 

4. Datei shadebobs.txt

;By DeathBringer/MORBID VISIONS

Shade Bobs

Die ShadeBob-Routine ist im Wesentlichen eine Implementierung der Fähigkeit
des Blitters zu addieren. Denken Sie nur an jedes Pixel auf dem Bildschirm
ist eine binäre n-stellige Zahl, wobei n beispielsweise die Anzahl der
Bitebenen ist. Mit 5 Bitebenen wäre die Situation wie folgt:

Plane5        0        0        0        0        0
Plane4        0        0        1        0        1
Plane3        0        1        0        1        0
Plane2        0        1        1        0        1
Plane1        1        0        1        0        0
-----------------------------------------------------
Anzahl        1        6       11        4        10

Die Routine addiert 1 zu dieser Zahl unter Verwendung einer einfachen
angewendeten Technik in binären Zählern und mit raffinierten Verbesserungen
wie sie auch im Addierer in unserer ALU vorhanden sind.

Um den Schatten auszuführen, müssen wir 1 zu der von allen dargestellten Zahl 
die bitplanes hinzufügen. Hier ist wie.

Die Tatsache, dass Binärzahlen hinzugefügt werden, erleichtert unser Leben
jedoch erheblich. Zuerst berechnen wir, ob es einen Übertrag zwischen einer
Bitebene und einer anderen gibt, wenn dies geschieht, wenn Sie es für die
Stellen in einer normalen Addition berechnen, und dann berechne die Summe.

Es ist klar, dass es einen Übertrag gibt, wenn beide Bits gleich 1 sind und die
Summe ist 1, wenn die Bits unterschiedlich sind, 0, wenn die Bits gleich sind 
(0 + 0, 1 + 1). Sie können es einfach anhand der folgenden Tabelle überprüfen:

Bitplane | Bit Hinzufügen | Summe | Übertrag 
--------------------------------------------
    0    |        0       |   0   |    0   
    0    |        1       |   1   |    0  
    1    |        0       |   1   |    0  
    1    |        1       |   0   |    1  
---------------------------------------------    

Jetzt können wir sehen, welche Funktionen hinzugefügt und übertragen werden:

Summe = Bitplane XOR Bit

Übertrag = Bitplane AND Bit

An diesem Punkt wiederholen Sie einfach die vorherige Prozedur für alle
Bitebenen. Hinzufügen des Carry, und das war's !!!

Beispiel:
        Anzahl       Bit Hinzufügen          Summe            Übertrag
------------------------------------------------------------------------
plane1  1        +          __1        =        0                1 ->\    
                           /      /---------------------<-------------|
plane2  1        +        /   1 <-     =        0                1 ->\  
                         /        /-----------------------------------|
plane3  0        +       |    1 <-     =        1                0 ->\   
                         |        /-----------------------------------|
plane4  0        +       |    0 <-     =        0                0
        ^                |                      ^
        |                |                      |
        3        +        \_->1        =        4
------------------------------------------------------------------------
        
Unser 1-Bitplane-Bob repräsentiert die Maske, die angibt, welche Pixel
interessant für die Addition des Frame.
Sie nehmen den Bob und den betroffenen Bildschirmbereich und führen ein UND durch
als Ziel ein zusätzliches Gebiet namens Carry.
Sobald dies erledigt ist, nimm den Bob und führe das XOR mit der entsprechenden
Bitebene aus Bildschirm, um die Summe zu erhalten.
Dann nutzen wir den Carry-Bereich weiter, als wäre es unser Bob für jede
Bitplane. Es sind eindeutig 2 Carry Bereiche erforderlich !!!


5. Display (Autor: Rock'n Roll)


Screen-Positionen DIW, DDF
--------------------------

Bekanntlich ist um den sichtbaren Screen ein schwarzer Rand. Gehen wir von
einem normalen Lowres-Screen mit (320x256) Pixeln aus so sind die typischen 
Einstellungen für diw und ddf folgende:

	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop

Warum?

Wir können z.B. durch Versuche die äusseren Begrenzungen des Bildschirmfensters
finden, bei dem ein 320x256 Lowres-Screen vollständig auf dem Bildschirm zu
sehen ist.

für DIWSTRT:
normal:				 v=$2c (44), h=$81 (129) 	dc.w	$8E,$2c81	; DiwStrt
linke, obere Ecke:	 v=$1a (26), h=$5c (92)		dc.w	$8E,$1a5c	; DiwStrt
linke, untere Ecke:	 v=$38 (56), h=$5c (92		dc.w	$8E,$385c	; DiwStrt
rechte, obere Ecke:	 v=$1a (26), h=$94 (148)	dc.w	$8E,$1a94	; DiwStrt
rechte, untere Ecke: v=$38 (56), h=$94 (148)	dc.w	$8E,$3894	; DiwStrt

und für DIWSTOP:
normal:				 v=$2c (44+256=300), h=$c1 (449)	
linke, obere Ecke:	 v=$1a (26+256=282), h=$9c (412)	
linke, untere Ecke:	 v=$38 (56+256=312), h=$9c (412) 	
rechte, obere Ecke:	 v=$1a (26+256=282), h=$d4 (468)     
rechte, untere Ecke: v=$38 (56+256=312), h=$d4 (468) 	

also:
dc.w	$90,$2cc1	; DiwStop	($81+320=$1c1=449)
dc.w	$90,$1a9c	; DiwStop	($5c+320=$19c=412)
dc.w	$90,$389c	; DiwStop	($5c+320=$19c=412)
dc.w	$90,$1ad4	; DiwStop	($94+320=$1d4=468)
dc.w	$90,$38d4	; DiwStop	($94+320=$1d4=468)

Wir haben also folgende Punkte gefunden:
linke, obere Ecke:	 h=$5c (92) , v=$1a (26)
linke, untere Ecke:  h=$9c (412), v=$38 (56+256=312)
rechte, obere Ecke:  h=$d4 (468), v=$1a (26)
rechte, untere Ecke: h=$d4 (468), v=$38 (56+256=312)


Gesamtgröße sichtbarer Bildschirmbereich:
		
		92,26 ($5c,$1a)						468,26 ($1d4,$1a)
						------------------
						|  ------------  |
						| |			   | |
						| |            | |
						| |			   | |
						| |			   | |
						| -------------- |
						------------------
	   92,312 ($5c,$138)			        468,312 ($1d4,$138)

Abbildung 1: Screenpositionen


Mit dem Wisssen können wir den normalen Lowres-Screen zentrieren.
Distanz x= 468-92=376	($1d4-$05c=376px) max overscan
Distanz y= 312-26=286	($138-$01a=286px) max overscan

Jetzt berechnen wir den Rest (Rand):
Rest x = 376-320=56		
Rest y = 286-256=30

Nun jeweils die Hälfte:
56/2=28 ($1c)
30/2=15 ($F)

Und verschieben den Screen entsprechend:
linke, obere Ecke:	 v=$1a (26)	, h=$5c (92)	dc.w	$8E,$1a5c	; DiwStrt
h=$5c+$1c=$78
v=$1a+$F=$29

Und erhalten:					dc.w	$8E,$2978	; DiwStrt	
								dc.w	$90,$29b8	; DiwStop
was etwas abweichend ist von	dc.w	$8E,$2c81	; DiwStrt
								dc.w	$90,$2cc1	; DiwStop
		
Die horizontale Position $81 (129) ist jedoch ein Vielfaches von 16 + 1Pixel.
128/16=8 und ist somit bedingt durch data fetch DDFSTRT geeigneter. 

Das Listing17f.s zeigt verschiedene Positionen des Screens auf dem Bildschirm.
Zudem springt ein Sprite zwischen den möglichen Screenecken.

Spezial-Anmerkung von EAB (ross) zu DIW:
---------------------------------------- 

horizontal:
$000~$05B hard blank (*)
$05c~$080 left soft blank
$081~$1c0 (320px)
$1c1~$1d3 right soft blank

Gesamtsumme:	($1d4-$05c=376px) max overscan

vertikal:
$000~$019 hard blank (on $019 you get first DMA sprite fetches)
$01a~$02b upper soft blank
$02c~$12b (256py)
$12c~$137 lower soft blank
$138 LOF last line (A1000 usable, other systems only COLOR00)

Gesamtsumme:	($138-$01a=286px) max overscan

Ab (*) CCK $e3 --> ($1c6) 'virtual lowres pixels' sind wir bereits in der
nächsten Zeile. Denise interner Zählerbereich ist von 2 bis 455
(mit 2 erweitert) und aus diesem Grund ist die letzte erreichbare 
Position für DIWSTOP(x) $c7.


Besonderheiten DIW
------------------

Nachdem die Screengröße und die Position auf dem Bildschirm festgelegt wurde,
gibt es weitere Besonderheiten oder Einschränkungen die zu beachten sind.
Diese Einschränkungen sind darauf zurückzuführen, dass wir nur $FF (255) Pixel
als vertikale bzw. horizontale Position angeben können und nicht z.B. den
Bereich von 0 bis 512.

Generell ist die Auflösung die mit den Registern DiwStrt und DiwStop erzielt
werden kann vertikal - eine Rasterzeile und horizontal - ein Pixel.
Ausserhalb des sichtbaren Bereichs wird die Rahmenfarbe mit der
Hintergrundfarbe, also Color00 angezeigt.

Allgemein gesagt:
DIWSTRT (Display Window Start) - $08 - legt horizontale und vertikale 
									   Startposition fest (Zeile und Spalte)
DIWSTOP (Display Window Stop)  - $90 - Endposition + 1	(z.B. Ende 250, dh.251)

DIWSTRT legt linke, obere Ecke fest
DIWSTRT  - H0 bis H7 - d.h. 8 Bits - 256 Spalten, d.h. von $0 bis $FF
		 - V0 bis V7 - d.h. 8 Bits - 256 Zeilen,  d.h. von $0 bis $FF
		   fehlende V8,H8 werden als 0 angesehen		 	

Das gleiche gilt für die horizontale Endposition, hier jedoch:
DIWSTOP  - H0 bis H7 - d.h. 8 Bits - 256 Spalten, d.h. von $0 bis $FF ; !!!	
		 - V0 bis V7 - d.h. 8 Bits - 256 Zeilen,  d.h. von $0 bis $FF ; wie oben
Das	fehlende V8 wird als 0 und
das	fehlende H8 wird als 1 angesehen	--> damit ist der Bereich von 256 und 511
											d.h. 1.0000.0000 bis 1.1111.1111

Das MSB der vertikalen Endposition, V8, wird durch invertieren des V7-Bits
erzeugt. Dadurch ist die Endposition im Bereich der Zeilen 128 bis 312 möglich.

bei Endpositionen von 256 bis 312 setzt man V7 auf 0 und damit V8 auf 1
bei Endpositionen von 128 bis 255 setzt man V7 auf 1 und damit V8 auf 0

theoretischer Screen:

V7=1
0.1000.0000 bis 0.1111.1111 = 128 bis 255	--> $80  bis $FF	
							  --> resultierend: $080 bis $0FF

V7=0 --> V8=1
1.0000.0000 bis 1.0111.1111	= 256 bis 511   --> $00 bis $7F
						      --> resultierend: $100 bis $17F

Eine vertikale Endposition kann daher nicht kleiner als 128 sein!
Und die vertikale Startposition kann nicht größer als 255 sein!

Beispiel:
Der normale Lowres-Screen (320x256 ) liegt bei:

	dc.w	$8E,$2c81	; DiwStrt - linke, obere Ecke festgelegt bei:
						; vertikal $2c (44), horiz. $81 (129)
	dc.w	$90,$2cc1	; DiwStop - rechte, untere Ecke festgelegt bei:						  
						; vertikal $(1)2c (300), horiz. $(1)c1 (449)

d.h.
DIWSTRT	$2c81	$VVHH	      $2c=44		 $81=129
DIWSTOP $2cc1	$VVHH	$2c=$12c=300	$c1=$1c1=449

für DIWSTOP: 
    HH - H8 ist 1		; das fehlende H8 wird als 1 angesehen:
	VV - $2c ist 0010.1100 und damit ist V7=0 -->
			 darausfolgt V8=1 --> 1.0010.1100=300	


Grenzen der DIWSTRT-DIWSTOP-Positionen (vertikal)
--------------------------------------------------

  --- $0		----- DIWSTRT von $00 bis $FF (0 bis 255) möglich
   |			|
   | - $1a      |	$1A - Beginn sichtbarer Bereich 
   |			
   |			
   |
   |
   |														|
   | -$7F													| 
   | -$80												 --- $80 (128)		
   | -$81											   höchste DIWSTOP-Position 
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |														|
   |				 letzte DIWSTRT-Position $FF			|
   | -$FF	   ----- DIWSTRT von $00 bis $FF möglich   ----- $FF (255) 
   |		   |											 $00 (256) =$(1)00
   |		   |
   |
   |				$137 - letzte sichtbare Zeile
  --- $138		
  										

															|
															|
													   ----- $7F(383) =$(1)7F
													   tiefste DIWSTOP-Position							   
													   	 

Abbildung 2: DIWSTRT-DIWSTOP-Positionen (vertikal)
															
oben:		Screen-Grenzen DIWSTRT: $1a (26)  bis DIWSTOP: $80 (128)		
Mitte:		Screen-Grenzen DIWSTRT: $81 (129) bis DIWSTOP: $FF (255)
unten:		Screen-Grenzen DIWSTRT: $FF (255) bis DIWSTOP: $38 (312)


Grenzen der DIWSTRT-DIWSTOP-Positionen (horizontal)
---------------------------------------------------

|----------------------------------------------------------------------|
|	   |	 | 					       |							   |	
$0    $5c	$81							$FF							 $(1)d4	
 ____						            ____		
|										| 
|										|		
	DIWSTRT: horizontal XX von $00 bis $FF d.h. von 0 bis 255



	DIWSTOP: horizontal XX von $00 bis $FF ist $(1)00=256 bis $(1)FF=511

										|								     |
									____|							      ___|
									$(1)00=256					    $(1)FF=511
									
Abbildung 3: DIWSTRT-DIWSTOP-Positionen (horizontal)

Die Programmbeispiele Listing17f2.s, Listing17f3.s, Listing17f3.s und
Listing17f4.s spielen mit den DiwStrt- und DiwStop-Werten.


DDF - Data Fetch
----------------

Die Berechnung für den Lowres-Screen erfolgt durch: 
DDFSTRT=(HSTRT/2)-8,5 AND $FFF8				Bsp: ($81/2)-8,5 AND $FFF8	=$38
DDFSTOP=DDFSTRT+(PixelproZeile/2-8)				  $18+(320/2-8)			=$d0

Warum? Und was bedeutet das?

Erstmal:
DDFSTRT kann nicht kleiner als $18 sein und
DDFSTOP	ist auf maximal $D8 begrenzt.

Übliche Werte sind $18,$20,$28,$30,$38,$40 usw. bis $D0, $D8. (Lowres-Screen)

Falls die Register mit Werten ungleich $x0, $x4, $x8 geladen werden, werden
die Bits Bit0 und Bit1 vom Register nicht beschrieben.
d.h. aus $F wird $C	(1111 --> 1100)

Im Grunde handelt es sich bei diesen Werten tatsächlich um die selbe
Pixelposition, wie in DiWStrt angegeben nur mit dem von der Hardware (Videologik)
benötigten zeitlichen Vorlauf.

Datafetch DMA wird vertikal automatisch mit DIWSTRT und DIWSTOP und horizontal
mit den Registern DDFSTRT und DDFSTOP eingestellt. Die Screengröße hat somit
einen entscheidenden Einfluß auf die Bitplane DMA-Nutzung.

Die Register DDFSTRT ($92) und DDFSTOP ($94) haben folgende Belegung:
Bit7-Bit0 = H8,H7,H6,H5,H4,H3, x, x

Daraus folgt, würde man die beiden Bits mit x weiter führen:
H8,H7,H6,H5,H4,H3,H2,H1	- Das heißt H0 fehlt
Im Grunde könnte man sich diese Folge auch als eine Division durch zwei
oder eine bereits erfolgte Rechtsverschiebung um eine Stelle vorstellen.
	
		H7,H6,H5,H4,H3,H2,H1,H0		(vor Verschiebung)
		H8,H7,H6,H5,H4,H3,H2,H1     (lsr #1,DDF...)(nach Verschiebung)
		H8,H7,H6,H5,H4,H3, x, x

Somit hat der eingetragene Wert nur einen halb so hohen Wert, als
man erwarten würde. Um auf den ursprünglichen Wert (Pixelposition) zu kommen,
muss man ihn wieder mit zwei multiplizieren.

Wenn wir also unseren bekannten Wert $38 in das Register schreiben, haben wir:
DDFSTRT	$38		($38=%0011.1000) 0, 0, 1, 1, 1, 0, 0, 0
					Bit7-Bit0 = H8,H7,H6,H5,H4,H3, x, x
und erhalten: $38*2 = 56*2=112 

kleine Anmerkung: es ist das selbe wie bei:
SPRCTRL Bit7-Bit0 = H8-H1, H0 ist in SPRxPOS und 
VHPOSR  Bit7-Bit0 = H8-H1, (2-Pixel Genauigkeit)

Zurück zu den DDF-Registern:
Uns stehen also 6 Bitwerte zur Verfügung, allerdings nur mit einer
4-Pixel-Genauigkeit. 

Im HRM steht: It is recommended that data-fetch start values be restricted to a
programming resolution of 16 pixels (8 clocks in low-resolution mode, 4 clocks
in high-resolution mode). The hardware requires some time after the first data
fetch before it can actually display the data. As a result, there is a
difference between the value of window start and data-fetch start of 4.5 color
clocks. (oder 8,5 Buszyklen im niedrig auflösenden Modus)

Jetzt muss man natürlich wissen was mit clock gemeint ist:
Der CPU-Takt bei PAL 68000 A500 ist 7.093.790Hz (system clock). Das doppelte bei
PAL 68020 A1200. Der CPU Takt ist bezogen auf die internen Custom Chip Buszyklen
das doppelte. (NTSC- 3.579.545 Hz, PAL- 3.546.895 Hz)

Das bedeutet:
1 chip cycle  = 3.546.895Hz PAL (281.94ns) = Buszyklus = 1 CCK (Color ClocK) 	
1 clock cycle = 7.093.790Hz				   = Systemtakt

Pro Rasterzeile haben wir 227,5 Buszyklen (CCKs), von $0 bis $E3 (0 bis 227) 
Als Pixelposition: $0*2 bis $E3*2	= $0 bis $1c6 = 0 bis 454
Also: 1 CCK = 2 Pixel

Für die horizontal Position $81 bedeutet das:
DIWSTRT = $81 (129)  Bit7-Bit0 = H7-H0  (1 Pixel Genauigkeit)
129-112=17pixel (ist 8.5 clock cycles zuvor) 1 clock cycle = 2 Pixel

In Listing17f5.s varrieren wir die Screengröße und zusätzlich die Datafetch-Werte.


Spezial-Anmerkung von EAB (ross) zu DDF: 
----------------------------------------

Eine andere Formel zur Berechnung der Pixelposition relativ zum DDFSTRT-Wert 
ist: DDFSTRT*2 + fetch_width + delay (*) -> $38*2+$10+$1 = $81 (DIW)
(*) delay is only for bitplanes data, not for sprites data. Was zu testen
wäre.

Maximum overscan 376 ist nicht durch 16 teilbar: darum 368

DDFSTOP=DDFSTRT+(PixelproZeile/2-8)	umgestellt nach PixelproZeile ist
PixelproZeile=(DDFSTOP-DDFSTRT+8)*2

Wenn wir DDFSTRT = $28 und DDFSTOP = $D8 setzen wird der Screen geöffnet auf:
$28 * 2 + $10 + $1 = $61 Diwstrt
$61 bis ($d8 + $8 - $28) * 2 + $61 - 1 = $1d0 (inklusiv). DiwStop

Mit $1d0 sind wir über $1c7, wodurch wir keine Kontrolle über den Rand haben.
Das hat Auswirkungen bei der Verwendung des Hardwarescrolls.

Durch die Begrenzung auf 368 Pixel verliert man 5 Pixel weit links
($5c, $5d, $5e, $5f, $60) und 3 Pixel weit rechts ($1d1, $1d2, $1d3).

Es ist nicht empfehlenswert diese Pixel zu nutzen, da sie gewönlich nicht
sichtbar sind. Ausserdem muss ein extra fetch (der nur auf der linke Seite noch
möglich ist, rechts sind wir durch die Hardware $d8 bereits begrenzt) und der
Hardwarescroll verwendet werden.

d.h.: DDFSTRT = $20, DDFSTOP = $D8 and BPLCON1 >= $33.
An diesem Punkt gebe es ungenutzte Pixel im fetch-Puffer und es gibt noch
einen anderen Seiteneffekt.


kleinerer Screen - angepasst an Logogröße
-----------------------------------------

Im Listing17f6.s wird gezeigt, wie ein Screen einem kleineren Bild angepasst werden
kann. Außerdem ist es durch die Copperliste möglich mehrere Screens mit dem selben
Logo zu haben. Die Bitplanepointer müssen dabei jeweils auf den Anfangswert der 
ersten Bitplane des Logos zurückgestellt werden, da die Bitplanepointer nach Anzeige
des Bildes am Beginn (der Adresse) der folgenden Bitplane des Logos steht.


6. Copper (Autor: Rock'n Roll)

Zum Copper wurde alles gesagt, oder?

Copper-Positionen
-----------------

aus Buch Amiga intern:
"Horizontal gibt es 113 mögliche Positionen, da die beiden unteren Bits der
horizontalen Position, HPO und HP1, nicht angegeben werden können. Das
Befehlswort des MOVE-Befehls enthält ja nur die Bits HP2 bis HP8. Die
horizontale Koordinate eines WAIT-Befehls lässt sich nur in Schritten von vier
niedrig auflösenden Punkten angeben."

d.h. horizontale Wait-Position:	HP8,HP7,HP6,HP5,HP4,HP3,HP2,x

Eine Darstellung mit allen 9 Bits wäre:
	HP8,HP7,HP6,HP5,HP4,HP3,HP2,HP1,HP0	(1-Pixel-Genauigkeit)
	=> 9 Bits $0 bis $1FF (0 bis 511)
	
Hier haben wir jedoch eine Rechtsverschiebung um eine Stelle was einer Division
durch 2 entspricht. Zudem steht uns HP1 nicht zur Verfügung. HP2 ist also
unsere kleinstmögliche Auflösung was einer 4 Pixelgenauigkeit entspricht.

	HP8,HP7,HP6,HP5,HP4,HP3,HP2,x	(lsr #1,DIW...)(nach Verschiebung)
									--> nur 4 Pixelgenau

  HP0 = 1 Pixelgenau, HP1 = 2 Pixelgenau, HP2= 4 Pixelgenau
  HP3 = 8 Pixelgenau (siehe DDFSTRT, DDFSTOP) 
 
Formal kann HP mit Werten von $0 bis $FE (0 bis 254) geladen werden. Mit 7 Bits
sind jedoch nur 128 unterschiedliche Einstellungen für eine horizontale Position
möglich. Am Ende sind es sogar nur 113 Positionen die zur Verfügung stehen.
Warum? Weil wir nur einen Positionsbereich von $0 bis $E2 (0 bis 226) haben.

wieder aus dem Buch Amiga intern:

"Die Abfrage der aktuellen Strahlposition

Da sich das gesamte DMA-Timing an der Position innerhalb einer Rasterzeile
orientiert, möchte man manchmal wissen, an welcher Stelle der Zeile sich der
Elektronenstrahl gerade befindet. Agnus besitzt dazu einen internen Zähler, der
sowohl die horizontale als auch die vertikale Bildschirmposition enthält, nach
der sich das gesamte System richtet. Zwei Register ermöglichen dem Prozessor
den Zugriff auf diese Zähler:

VHPOS $006 (lesen, VHPOSR) und $02C (schreiben, VHPOSW)
			 Bit-Nr.: 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
			Funktion: V7 V6 V5 V4 V3 V2 V1 V0 H8 H7 H6 H5 H4 H3 H2 H1

VPOS $004 (lesen, VPOSR) und $02A (schreiben, VPOSW)
			Bit-Nr.: 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
		   Funktion: LOF										   V8

Die mit Hl bis H8 bezeichneten Bits stellen die horizontale Strahlposition dar,
sie entsprechen direkt den Nummern für die einzelnen Buszyklen in Abbildung xxx
und haben damit eine Genauigkeit von zwei niedrig- oder vier hochauflösenden
Punkten.
Der Wert für die horizontale Position kann zwischen $0 und $E3 (0 bis 227)
liegen. Die horizontale Austastlücke fällt in den Bereich von $F bis $35.
Die Bits für die vertikale Position, also die aktuelle Bildschirmzeile, sind
auf zwei Register verteilt. Die unteren Bits V0 bis V7 liegen noch in VHPOS,
das oberste Bit, V8, befindet sich in VPOS. Zusammen ergeben sie die Nummer
der aktuellen Bildschirmzeile."

Aha, wegen der 2-Pixelgenauigkeit folgt:
$0 und $E3 (0 bis 227) bedeutet $0 bis $1c6 (0 bis 454) in Pixeln

und 454/4=113 (wegen nur 4 Pixelgenau bei horizontaler Waitposition)
Es stehen somit 113 horizontale Copperpositionen zur Verfügung oder
wie oben 226/2=113.

Das Listing17g.s zeigt eine Copper-Treppe mit den 90 (bzw. 113) Positionen.


Umrechnung: Pixelposition in horizontale Copper-Wait Position
-------------------------------------------------------------

Wenn wir nun unsere Pixelposition $81 (129) in eine horizontale Waitposition
umrechnen wollen, müssen wir $81 durch 2 dividieren. --> $40 oder wenn wir
ein Wait in der Mitte unseres Lowres-Screens wollen:
129+(320/2)=289	= $81+$A0=$121 dividiert durch 2 = $90
Es wäre also ein dc.w $2c91,$fffe erforderlich um in der Mitte des Screens
ein Wait zu platzieren.

Umgekehrt, wenn wir ein Copper-Wait haben müssen wir dieses mit zwei
multiplizieren um die Pixelposition zu erhalten.

dc.w $ffe1,$fffe		$E0=> $E0*2=$1c1=$81+$140	(129+320=449)

In Listing17g2.s sehen wir die Positionierung eines Copper-Moves an eine
horizontale Pixelposition unabhänig von einem festgelegten Screen und in
Abhängigkeit zu einem Lowres-Screen (320x256) mit festgelegter normaler
Screenposition.


Rasterstrahl/ Strahlposition und Copper-Positionen - Wo es schwierig wird
-------------------------------------------------------------------------

vertikal:   in Rasterzeilen
- Zeilen von 0 bis 312 sind möglich
- vertikale Austastlücke				von 0 bis 25
- vertikaler sichtbarer Bereich		    von 26 bis 312 ($1A bis $138) beschränkt

horizontal: in Pixelposition
- Spalten von 0 bis 468 sind möglich    von 0 bis 468 (0 bis $1d4) ?
- horizontale Austastlücke			    von 30 bis 106 ($1E bis $6A) ?
- horizontaler sichtbarer Bereich		ab 107 ($6B) ?

Strahlposition:	Wait-Command
kann horizontal von: $0 bis $E2 (0 bis 227) liegen 

Amiga intern sagt:
Die horizontale Austastlücke fällt in den Bereich von $F bis $35.
$F bis $35 bedeutet in Pixelposition $1E bis $6A (von 30 bis 106)
(als Pixelposition siehe oben !)

HRM sagt:
The standard screen (320 pixels wide) has an unused horizontal portion of
$04 to $47 (during which only the background color is displayed).
$04 to $47 von 8 bis 142 ??? 	

Unsere Screenposition ist $81 (129). In unserem Fall haben wir eine
horizontale Austastlücke von $0 bis $40 bzw. Wenn $5c (92) eingestellt wird
haben wir eine horizontale Austastlücke von $0 bis $2e. Oder? 

horizontale Waitposition:
$2E => 46*2=92   ($5c)  wäre die erste sichtbare Copperposition
$E2 => 226*2=452 ($1c4) wird als Ende genannt.
452-92=360

Man sieht es den Fragezeichen an, dass es noch Unklarheiten gibt...


Ausführungszeit Copperbefehle
-----------------------------

Der Copper arbeitet (mit kleinen Einschränkungen) von $0 bis $E2 (226) und
belegt die geraden DMA-Zyklen. Diese Zyklen, bei denen der Copper auf den
Bus zugreifen kann, werden auch als Copper Cycles bezeichnet.

HRM spricht von odd-numbered memory cycles und meint damit:
1st, 3rd etc. = $00, $02.. usw.
Copper cycles können bei Zugriff von anderen (mit höherer Priorität) im 
allgemeinen Bitplane "gestohlen" werden. 

Als DMA-Diagramm sieht das so aus:

DDFSTRT on $38
 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]       
    1          2        3          4        -       BPL4      BPL6      BPL2
  (free)              (free)              (free)			 (steal)
   COP                 COP                  COP                COP
  
 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
 COP  08C   BPL3       BPL5     BPL1
  (free)              (steal)
   COP                 COP                  COP                COP

Dabei gleich eine Besonderheit zu DDFSTRT von EAB (Toni Wilen):
DDFSTRT does not equal first bitplane slot. When DDFSTRT matches horizontal
position, it takes 4 cycles more before first bitplane slot is selected
(plane 8) because bitplane enable has multiple stages and internal RGA bus is
pipelined.

Ausführungszeit move
--------------------

Jedes copper-move benötigt nach einem anderen je 4 CCKs = 8 Pixel,
solange keine Bitplane copper cycles stiehlt.

	dc.w $0180,$444
	dc.w $0180,$555		; 4 CCKs (keine oder bis 4 bitplanes)

[38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
 COP  08C            COP  180            COP  08C            COP  180
 0   0180                0444                0180                0555

Bei 5 Bitplanes verschiebt sich ein Copper Buszugriff um 2 CCKs.
Bei 6 Bitplanes verschiebt sich ein Copper Buszugriff um 4 CCKs.

	dc.w $3031,$fffe
	dc.w $0180,$444
	dc.w $0180,$555		; 6 oder 8 CCKs (bei 5 oder 6 Bitplanes)


 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
 COP  08C            COP  180            COP  08C  BPL4 116  BPL6 11A  BPL2 112
 0   0180                0444                0180      0000      0000      8080
															 ( !!!!! )	

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
 COP  180  BPL3 114  BPL5 118  BPL1 110  COP  08C  BPL4 116  BPL6 11A  BPL2 112
     0444      0000      0000      8080      0180      0000      0000      8080
					 ( !!!!! )								 ( !!!!! )

Bsp: von $3c bis $43 = 8 CCKs (bei 6 Bitplanes)

Das erste move-command nach einem wait-command benötigt weitere 2 CCKs.
Es gibt also eine Lücke von zwei Buszyklen:

	dc.w $3031,$fffe	; wait for horizontal position HP0$30
	dc.w $0180,$444		; 8 CCks, erstes move nach einem wait

[30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]
   1                   2                 COP  08C            COP  180
                                            0180                0444
                                        00071808            0007180A

Erklärt wird das so:
Im ersten Buszyklus stimmt der Vergleich überein und im nächsten Buszyklus wird
eine DMA-Anfrage generiert. Schliesslich wird im nächsten Zyklus das nächste
Befehlswort gelesen. Somit ist die Ausführungszeit für den ersten move-command
nach einem wait: 4 copper cycle  => 8 CCKs = 16 pixel

"Copper comparison matches first, then in next cycle DMA request is generated. 
Finally following cycle reads next instruction word." von EAB (Toni Wilen)

Ausführungszeit wait
--------------------

Für ein wait-command gilt folgende Ausführungszeit:
		dc.w        $3031,$fffe
        dc.w        $180,$444
        dc.w        $3033,$fffe
        dc.w        $3035,$fffe
        dc.w        $ffff,$fffe 

Das wait-command benötigt oder endet nach 4 copper-cycles oder 8 CCKs.
(3 normal cycles: 2 to read copper instructions, 1 for wait to finish and
one "wasted")."
 
[38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]               
 COP  08C            COP  08C
 0  3033                FFFE             (sleep)             W       
 0007180C            0007180C
 99E1CC00  99E1CE00  99E1D000  99E1D200  99E1D400  99E1D600  99E1D800  99E1DA00
 
; <IR1> <IR2> <sleep start> (sleeping) <wakeup> (next instruction's IR1 fetch).

$38 - IR1 (fetch)	; copper-cyle 1
$3A - IR2			; copper-cyle 2
$3C - sleep start	; copper-cyle 3 - wasted - First refresh cycle is cycle 3
$3E - wakeup		; copper-cyle 4
und dann
$40 - IR1 (fetch)   ; copper-cyle 1 (again)

Bei 5 Bitplanes verschiebt sich ein Copper Buszugriff um 4 CCKs. Summe=12 CCKs

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
 COP  08C            COP  08C                      BPL4 116            BPL2 112
 0   3033                FFFE            (sleep)	   0000   W            8080

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
 COP  08C  BPL3 114  BPL5 118  BPL1 110  COP  08C  BPL4 116            BPL2 112
     3035      0000      0000      8080      FFFE      0000   (sleep)      8080
					 ( !!!!! )	
 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
           BPL3 114  BPL5 118  BPL1 110  COP  08C  BPL4 116  COP  08C  BPL2 112
  W            0000      0000      8080      3037      0000      FFFE      8080
					 ( !!!!! )

Bsp: von $40 bis $48	= 12 CCks	(dc.w  $3035,$fffe)

Bei 6 Bitplanes verschiebt sich ein Copper Buszugriff um 8 CCKs. Summe=16 CCKs

[38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
 COP  08C            COP  08C                      BPL4 116  BPL6 11A  BPL2 112
 0   3033                FFFE             (sleep)      0000      0000      8080

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
           BPL3 114  BPL5 118  BPL1 110  COP  08C  BPL4 116  BPL6 11A  BPL2 112
  W            0000      0000      8080      3035      0000      0000      8080
															( !!!!! )	
[48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
 COP  08C  BPL3 114  BPL5 118  BPL1 110            BPL4 116  BPL6 11A  BPL2 112
     FFFE      0000      0000      8080  (sleep)       0000      0000      8080
					( !!!!! )								( !!!!! )

 [50  80]  [51  81]  [52  82]  [53  83]  [54  84]  [55  85]  [56  86]  [57  87]
           BPL3 114  BPL5 118  BPL1 110  COP  08C  BPL4 116  BPL6 11A  BPL2 112
  W            0000      0000      8080      3037      0000      0000      8080
					( !!!!! )

Bsp: von $44 bis $53	= 16 CCks	(dc.w  $3035,$fffe)	

Ausführungszeit skip
--------------------

; ohne Sprung
[28  40]  [29  41]  [2A  42]  [2B  43]  [2C  44]  [2D  45]  [2E  46]  [2F  47]
 COP  08C            COP  180            COP  08C            COP  08C
     0180                00F0                3131                FF01

 [30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]
                     W                    COP  08C            COP  08A
 (sleep)                                     008A                0000

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
 COP  08C            COP  180            COP  08C            COP  180
 0   0180                0666                0180                0444

; mit Sprung
mit dc.w	; wenn dc.w $3121,$fffe auskommentiert
 [58  88]  [59  89]  [5A  90]  [5B  91]  [5C  92]  [5D  93]  [5E  94]  [5F  95]
 COP  08C            COP  08C  BPL1 110									W
     3131                FF01      8000				(sleep)

 [60  96]  [61  97]  [62  98]  [63  99]  [64 100]  [65 101]  [66 102]  [67 103]
 COP  08C            COP  08A  BPL1 110  COP  08C            COP  180
     008A                0000      8000      0180                0666

 [68 104]  [69 105]  [6A 106]  [6B 107]  [6C 108]  [6D 109]  [6E 110]  [6F 111]
 COP  08C            COP  08C  BPL1 110
     8007                FFFE      8000

	dc.w	$8007,$fffe		; ist wait-Position in Copperlist 2

Bsp: siehe Listing17g3.s
cop1:
	...
	dc.w	$3131,$ff01		; skip if VP >=31 & HP>=30
	dc.w	$8a,0			; copjmp2 start
	dc.w	$0180,$666		; cop 1
	dc.w	$0180,$444		; cop 1

cop2: ; copperlist 2
	dc.w	$8007,$fffe	 
	
Im Listing17g3.s geht es nur darum ein besseres Verständnis zu den sichtbaren und
"unsichtbaren" Copperpositionen zu bekommen. Es ist aber auch geeignet um mit
dem WinUAE Debugger verschiedene Situationen durchzuspielen.


Zusammenfassung:
----------------

Jede Copperanweisung besteht aus 2 Wörtern und benötigt zur Ausführung folgende
Zeit.
													CCKs
	move - nach erfolgreichen wait Vergleich		= 2	= 4 Pixel
	move - bis 4 bitplanes							= 4 = 8 Pixel
	move - 5 bitplane								= 5 = 10 Pixel
	move - 6 bitplane								= 6 = 12 Pixel

	wait - bis 4 bitplanes							= 4	= 8 Pixel
	wait - 5 bitplane								= 6 = 12 Pixel
	wait - 6 bitplane								= 8 = 16 Pixel

	skip ohne Sprung wie wait
	skip - ohne bis 4								= 4 = 8 Pixel
	skip - 5 bitplane								= 5 = 12 Pixel
	skip - 6 bitplane								= 6	= 16 Pixel
	skip mit Sprung									= + 2 CCKs zusätzlich
	

Copper-Masking
--------------

wieder aus dem Buch Amiga intern:
"Das zweite Befehlswort enthält die sogenannten Maskenbits. Mit ihnen kann man
festlegen, welche Bits der horizontalen und vertikalen Position überhaupt zum
Vergleich mit der aktuellen Strahlposition herangezogen werden. Nur die
Positions-Bits, deren zugehörige Masken-Bits gesetzt sind, werden beachtet.
Dies eröffnet vielfältige Möglichkeiten:

Ein Wait mit vertikaler Position $0F und vertikaler Maske $0F bewirkt, dass
alle 16 Zeilen die Wait-Bedingung erfüllt wird, nämlich immer, wenn die unteren
4 Bits auf 1 sind, da Bits 4 bis 6 nicht mehr in den Vergleich mit einbezogen
werden (Masken-Bits 4 bis 6 sind auf 0). Das 7. Bit der vertikalen Position
lässt sich nicht maskieren. Aus diesem Grund funktioniert das obige Beispiel
nur im Bereich der Zeilen 0 bis 127 und 256 bis 313."

Das Listing17g4.s dient nochmal dem Verständnis der Masken-Bits.


COPCON
------

wieder aus dem Buch Amiga intern:
"Bei der Registeradresse gibt es einige Einschränkungen. Normalerweise kann der
Copper die Register im Bereich von $000 bis $07F nicht beeinflussen. Setzt man
das unterste (und auch einzige) Bit im COPCON-Register, ist es dem Copper auch
möglich, in die Register von $040 bis $07F zu schreiben. Dadurch kann der Copper
dann den Blitter benutzen. Ein Zugriff auf die untersten Register ($000 bis $03F)
ist allerdings immer verboten."

Das Listing17h.s zeigt ein Beispiel wo der Copper in die Blitterregister
schreibt.


weitere Themen wären:
- Blitter-Copper-Schleifen
- DMA-Besonderheiten (z.b. am Anfang und am Ende einer Rasterzeile)
- ...


ENDE ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++