
; Lektion 05

ZOOM-HARDWARE MIT BPLXMOD UND BPLCON1 AUF AMIGA

10. September 2018 Amiga, 68000 Assembler, Blitter, Copper

Der Schock der Ankunft des Super Nintendo Ende 1991 für Fans von 16-Bit-
Mikroprozessoren war Mode 7. Die Konsole war in der Lage, eine große Bitmap
im Frame zu drehen und zu skalieren, und es war möglich, sie zu optimieren,
um einen perspektivischen Effekt zu erzeugen.

Der Amiga 500 war doppelt eingeschränkt, um solche Effekte erfolgreich zu 
erzeugen: keine spezielle Schaltung dafür und eine Organisation der angezeigten
Daten in Form von Bitebenen, die viele Operationen durch die CPU und / oder dem
Blitter erfordert, um dies zu erreichen. Das hinderte einige jedoch nicht
daran, solche Effekte zu produzieren, zum Beispiel den Zoom beim Start der
World of Commodore 92-Demo von Sanity:

Bild: Vergrößern Sie Sanitys World of Commodore 92-Demo	; figure1-13-768x606.png

Unter all diesen Zoomeffekten mit oder ohne Perspektive stützten sich die
meisten auf den vertikalen Hardware-Zoom, der in den frühen Tagen des Amigas
entdeckt wurde, und einige auf den viel später entwickelten horizontalen
Hardware-Zoom.

Wie geht man mit der Hardware bei einen dieser Zooms vor?
Was ist insbesondere dieser berühmte "$102 Trick", der regelmäßig in den Foren
von Demomakern erwähnt wird, oft kurz und manchmal ausschweifend?
Und wie weit kann man so zoomen? All dies und mehr im Folgenden.

Update vom 11.09.2018 (morgens): Die Figur, die das Hardware-Horizontal-
	Zoom-Szenario darstellt (ein Schritt zu viel!) und die "magische Tabelle"
	(Bug im HTML5-Generator-Programm!) korrigiert.
Update vom 11.09.2018 (abends): Einen Absatz und eine Abbildung hinzugefügt, um
	zu erklären, warum der Hardware-Horizontalzoom die Anzahl der Bitplanes
	auf 4 begrenzt.
Update 12.09.2018 (am): Das Ende des Abschnitts über den Übergang von der
	Verschleierung zur Unterdrückung geändert, um zu erklären, warum und wie
	optimiert werden kann.
Update vom 10.01.2018: Alle Sourcen wurden um eine "StingRay's Stuff"-Sektion
	erweitert, die den ordnungsgemäßen Betrieb auf allen Amiga-Modellen, 
	insbesondere mit Grafikkarte, gewährleistet.
Klicken Sie hier, um das Archiv herunterzuladen, das den Code und die Daten der
hier vorgestellten Programme enthält.

Dieses Archiv enthält mehrere Quellen:
zoom0.s , um obere, mittlere und untere Zeilen eines Bildes mit vertikalem
	Hardware-Zoom auszublenden und letzteres vertikal auf dem Bildschirm neu zu
	zentrieren;
zoom1.s , um zu identifizieren, wann Copper verwendet werden soll, um den Wert
	von BPLCON1 zu modifizieren, um eine Anzahl von Spalten zu verbergen, die
	aus den letzten Pixeln einer Gruppe von 16 Pixeln gebildet werden;
zoom2.s zum Visualisieren des Ergebnisses, das durch den horizontalen
	Hardware-Zoom erzeugt wird, basierend auf der vorherigen Technik, die
	verallgemeinert wurde, um 1 bis 15 Spalten von Pixeln eines Bildes zu
	verbergen;
zoom3.s zum Testen eines Zooms basierend auf der vorherigen Technik, um ein
	306-Pixel-Bild auf eine Breite von 15 Pixeln zu reduzieren;
zoom4.s , um einen Zoom zu testen, der einen horizontalen Hardware-Zoom und
	einen vertikalen Hardware-Zoom kombiniert, um ein Bild mit 306 x 256 Pixel
	auf 15 x 15 Pixel zu reduzieren.

NB: Dieser Artikel lässt sich am besten lesen, wenn man sich das hervorragende
Helmet for sale Modul anhört, das von Jason / Kefrens für RAW #2
komponiert wurde, aber das ist eine Frage des persönlichen Geschmacks ...

DER VERTIKALE HARDWARE-ZOOM, EINE BANALE VERWENDUNG VON MODULOS

Wie hier erklärt, zeigt die Hardware ein Bild an, das aus Bitebenen besteht,
deren Adressen ihr über die Paare von BPLxPTH/BPLxPTL-Registern bereitgestellt
werden. Nachdem die Daten einer Zeile gelesen und angezeigt wurden, addiert die
Hardware das Äquivalent in Bytes zu diesen Adressen - 40 Bytes für einen
320 Pixel breiten Bildschirm - und fügt dann ein Modulo hinzu. Dieses Modulo
wird in BPL1MOD für ungerade Bitebenen (1,3 usw.) und in BPL2MOD für gerade
Bitebenen (2,4 usw.) gespeichert.
Wenn man weiß, dass die Hardware daher Register einliest, die der Copper
(mindestens) in jeder Zeile des Bildschirms ändern kann, ist es leicht zu
sehen, wie man diesen Vorgang ausnutzt. Nehmen wir als Beispiel ein Bild mit
320 x 256 Pixeln in 16 Farben, also 4 Bitebenen.
Es ist möglich, den Copper aufzufordern, auf den Beginn einer Zeile zu warten
und in die BPLxPTH/L-Register zu schreiben, um die Adresse der angezeigten
Zeile zu ändern. Diese Adresse wird entsprechend dem Zoom bestimmt, um Zeilen
zu überspringen oder zu wiederholen oder einfach zur nächsten Zeile zu
wechseln. Die Copperliste enthält dann insbesondere einen folgenden Block pro
Zeile N, hier zur besseren Lesbarkeit in Pseudocode dargestellt:
	
	WAIT <Anfang von Zeile N>
	MOVE <Wert>, BLTP1PTH
	MOVE <Wert>, BLTP1PTL
	MOVE <Wert>, BLTP2PTH
	MOVE <Wert>, BLTP2PTL
	MOVE <Wert>, BLTP3PTH
	MOVE <Wert>, BLTP3PTL
	MOVE <Wert>, BLTP4PTH
	MOVE <Wert>, BLTP4PTL

Wer sich der Ausrichtung der Daten im Speicher sicher ist, kann darauf
verzichten, in BPLxPTH zu schreiben, da er weiß, dass sich sein Wert nicht
ändert, egal welcher Offset hinzugefügt wird, um in den Bitebenen
voranzukommen, aber es spielt keine Rolle: Es ist das Prinzip, das wir hier
veranschaulichen.
Es ist auch möglich, in BPL1MOD und BPL2MOD einfach einzuschreiben. In diesem
Fall ist es die Adresse der folgenden Zeile und nicht die Adresse der aktuellen
Zeile, die betroffen ist, da die Hardware die Modulos am Ende der Zeile
verwendet. Die Copperliste enthält dann insbesondere einen folgenden Block pro
Zeile N, die hier wiederum zur besseren Lesbarkeit in Pseudocode dargestellt 
ist:
	
	WAIT <Anfang von Zeile N-1>
	MOVE <Wert>, BPL1MOD
	MOVE <Wert>, BPL2MOD

Die Verwendung von BPLxMOD wirkt sich ohne Unterscheidung auf alle ungeraden
Bitebenen und/oder alle geraden Bitebenen aus. Dies stellt jedoch kein Problem
dar, da der zu erzielende Zoom im Allgemeinen der einzige Effekt ist, der in
Bitebenen erzeugt werden muss. Darüber hinaus ist die Verwendung dieser
Register wirtschaftlicher als die Verwendung von BPLxPTH/L.
In der Tat dürfen wir nicht vergessen, dass der Zoomfaktor von Frame zu Frame
variiert. Die Copperliste muss durch die CPU oder den Blitter geändert werden,
um die Werte zu aktualisieren, die der Copper in die verwendeten Register 
schreibt. Aber die Rechnung ist schnell gemacht:
- bei BPLxPTH/L ist es notwendig, die Werte durch zwei MOVEs pro Bitebene zu
ändern, d.h. insgesamt 8 Werte (möglicherweise 4 durch Spielen auf der
Ausrichtung im Speicher); 
- mit BPLxMOD müssen Sie die Werte durch nur zwei MOVEs ändern, also 2 Werte
insgesamt.
Es reicht jedoch nicht aus, Linien zu verbergen, um einen Zoom zu erzeugen: Das
Bild muss in jedem Stadium auf dem Bildschirm zentriert bleiben. Das Ändern der
Modulos führt jedoch zu einer Komprimierung des Bildes nach oben auf dem
Bildschirm. Um dies zu kompensieren, muss das Bild um die Hälfte der Anzahl
verdeckter Linien nach unten gedrückt werden. Dies ist dank mindestens zweier
Lösungen möglich:
- die vertikale Startposition der Anzeige im DIWSTRT-Register und die Höhe
dieser Anzeige im DIWSTOP-Register zu modifizieren;
- die vertikale Position eines Copper WAIT modifizieren, eine Position, von der
aus MOVEs die BPLxPTH/L-Register modifizieren, um auf die Startadressen der
Bitebenen des gezoomten Bildes zu zeigen.

In jedem Fall ist es nutzlos, die vertikale Position der WAITs zu modifizieren,
die dem Copper mitteilen, bei welcher Zeile er warten muss, bevor er den MOVE
ausführt, der durch Schreiben eines Werts in BPLxMOD das Verbergen einer oder
mehrerer Zeilen bewirkt oder nicht. In der Tat müssen Sie bei jedem Schritt des
Zooms nur direkt im Code der Copperliste die Werte aktualisieren, die diese
MOVEs in BPLxMOD schreiben, wobei die neue vertikale Position des Bildes
berücksichtigt wird, um diese MOVEs auszuwählen. Kurz gesagt, wenn es notwendig
ist, die Höhe eines Bildes in N Schritten von 256 auf 0 Pixel zu reduzieren,
reicht es aus, eine Copperliste zu erstellen, die immer 256 WAIT gefolgt von
MOVE auf BPLxMOD enthält, und bei jedem Schritt die Werte zu ändern dass diese
MOVE in BPLxMOD schreiben, um den Zoom zu animieren.
Im fertigen Programm zoom4.s wurde der Einfachheit halber die erste Lösung
übernommen. Es sollte beachtet werden, dass dies eine Modifikation von
BPLxPTH/L beinhaltet, um eine oder mehrere der ersten Zeilen auszublenden.
Modulo ist nämlich ein Wert, den die Hardware zur Adresse der gerade
angezeigten Zeile addiert. Aber per Definition kommt die erste Zeile nicht nach
einer anderen Zeile. Dies ist jedoch der einzige Fall, in dem diese Register
auf Zoom geändert werden.
Weiterhin ist zu beachten, dass der Elektronenstrahl also weder oberhalb noch
unterhalb des gezoomten Bildes nachzeichnet. Unter diesen Bedingungen ist es
unmöglich, die Banner anzuzeigen, die das gezoomte Bild umrahmen. Dazu müssen
Sie sich für die zweite Lösung entscheiden.
Die folgende Abbildung fasst zusammen, was passiert, wenn die Zeilen 0, 1, 2
und 5 des Bildes ausgeblendet werden müssen:
Da dadurch vier Zeilen ausgeblendet werden sollen, wird DIWSTART so
modifiziert, dass die Anzeige drei Zeilen tiefer beginnt, wodurch
sichergestellt wird, dass das Bild vertikal auf dem Bildschirm zentriert
bleibt. Folglich wird auch DIWSTOP reduziert, sodass die Hardware nach dem
Anzeigen der 256. Zeile des Bildes keinen Müll anzeigt.

Um die ersten drei Zeilen auszublenden, kann BPLxMOD nicht verwendet werden. Es
ist also BPLxPTH/L, das vor Beginn der Anzeige von Zeile 3 modifiziert wird. Um
Zeile 5 auszublenden, sprang BPLxMOD auf das Äquivalent einer Zeile in Bytes
oder 40 Bytes, bevor Zeile 4 die Anzeige beendete.

Bild: Prinzip des Hardware-Vertikalzooms	; figure2-14.png

Das Programm zoom0.s ist ein einfaches Beispiel, bei dem die ersten 16 Zeilen,
die mittleren 16 Zeilen und die letzten 16 Zeilen eines Bildes auf diese Weise
ausgeblendet werden - für die Schönheit der Geste ist dies das Dragon Sun-Bild
von Cougar/Sanity welches gebraucht wird:

Bild: Hardware-Vertikalzoom eines Bildes	; figure3-11.png

An dieser Stelle bleibt noch ein wesentlicher Punkt zu klären: Wie erkennt man
die zu verbergenden Linien bei einer bestimmten Zoomstufe? Diese Frage, die
sich in fast gleicher Weise für die Wahl der zu verbergenden Spalten stellt,
wird später behandelt.

DER HORIZONTALE HARDWARE-ZOOM, EINE ÜBERRASCHENDE ABLENKUNG VOM SCROLLEN

Die Geschichte wird zeigen, wem es zu verdanken ist, dass er den Trick
gefunden hat (wir sprechen hier vom brillanten Chaos/Sanity). Wie jeder weiß,
ist es möglich, die Hardware zu bitten, die Anzeige des Bildes auf dem
Bildschirm um eine Anzahl von Pixeln zwischen 0 und 15 zu verzögern. Der Wert
dieser Verzögerung muss im BPLCON1-Register angegeben werden, das 4 Bits hat
(PF1H3-0) für die Verzögerung von ungeraden Bitebenen (1,3 usw.) und 4 Bits
(PF2H3-0) für die Verzögerung von geraden Bitebenen (2,4 usw.). Dies ist das
Hardware-Scrolling.
Somit wird ein Wert von $005F in BPLCON1 die Anzeige von geraden Bitebenen um
5 Pixel und die von ungeraden Bitebenen um 15 Pixel verzögern. Sofern Sie nicht
Dual-Playfield verwenden oder versuchen, ungerade und gerade Bitebenen separat
zu handhaben, sind die für diese Bitebenen spezifizierten Verzögerungen
identisch. Es wird darum gehen, ein horizontales Scrollen zu erzeugen, indem
man auf BPLCON1 und auf den Paaren BPLxPTH / BPLxPTL spielt - wir werden uns
nicht mit diesem trivialen Thema befassen.
Die Hardware liest jedoch die Daten, die sie in Gruppen von 16 Pixeln anzeigt.
Es berücksichtigt jedes Mal die in BPLCON1 angegebenen Offsets, um die Anzeige
dieser Gruppe mehr oder weniger zu verzögern. Was würde passieren, wenn der
Wert dieser Offsets von einer Gruppe zur anderen reduziert würde? Würde die
Hardware nicht insbesondere die zweite Gruppe früher anzeigen und die letzten
Pixel der ersten überschreiben?
Genau das passiert. Und da das Ausblenden von Pixelspalten im Bild zu einer
Verringerung der Breite des letzteren führt, ist es angebracht, von
horizontalem Hardware-Zoom zu sprechen:

Bild: Ausblenden der letzten 2 Pixel einer Gruppe durch Reduzieren des
Hardware-Scrollings um 2	; figure4-11.png

Wir müssen noch eine praktische Frage klären: Wann und wie wird der Wert der
Offsets in BPLCON1 geändert? Wie gerade vorgeschlagen, muss das Schreiben in
BPLCON1 mit dem Zyklus des Lesens und Anzeigens von Pixelgruppen durch die
Hardware synchronisiert werden.
Jeder weiß, dass es immer möglich ist, auf eine Position des Elektronenstrahls
(das Raster) auf dem Bildschirm zu warten und in diesem Moment den Inhalt eines
Hardware-Registers zu ändern. Dieses Manöver kann durch die CPU durchgeführt
werden, aber wenn der Hardware-Zoom auf diese Weise durchgeführt werden müsste,
wäre es unmöglich, irgendetwas anderes während eines frames zu tun.
Glücklicherweise ist der Copper da und führt seine Copperliste parallel aus. 
Warum nicht die hier beschriebenen WAIT- und MOVE-Anweisungen verwenden, um das
gewünschte Ergebnis zu erzielen?
Das Programm zoom1.s veranschaulicht dies. Die Idee wird sein, auf die Position
zu warten, an der wir eine bestimmte Anzahl der letzten Pixel einer bestimmten
Gruppe verstecken wollen.
Aber wo warten? Eigentlich gäbe es zwei Lösungen: Verwenden Sie ein WAIT und
dann ein MOVE, um BPLCON1 zu modifizieren. Oder verketten Sie, wie im Fall eines
Plasmaeffekts, den MOVE in dem Wissen, dass ein MOVE 8 Pixel in niedriger
Auflösung benötigt, um ausgeführt zu werden, einschließlich eines MOVE, um
BPLCON1 zu modifizieren. Tatsächlich ist nur die zweite Lösung machbar.

Wieso denn? Weil es so ist. Alle Codierer, die horizontalen Hardware-Zoom
verwenden, tun dies. Warum nochmal? Denn es würde wirklich, aber dann wirklich,
Kopfschmerzen bereiten, die im WAIT anzugebende horizontale Position genau zu
berechnen, damit der MOVE zum richtigen Zeitpunkt ausgeführt wird - und wieder
wird nicht gesagt, dass dies möglich wäre. An diejenigen, die sich über diesen
Mangel an Strenge beschweren würden, sagen wir, um den Dingen auf den Grund zu
gehen, müsste man wissen, wie man jederzeit die Beziehung zwischen der
horizontalen Position des Elektronenstrahls erklären kann, wie sie ein WAIT 
des Coppers und der horizontale Wert formuliert, wie er in DDFSTRT erscheint.
Aber wenn es sicher möglich ist, bleibt es zu tun ...

(Anmerkung vom Übersetzer: https://eab.abime.net/showthread.php?t=114023)

Somit ist der Copper so programmiert, dass er auf den Start jeder Zeile an der
empirisch bestimmten horizontalen Position $3D wartet und mit 40 MOVEs
fortfährt, von denen einige den Wert von BPLCON1 modifizieren, indem sie die
ebenfalls empirisch bestimmte Anfangsverzögerung reduzieren.
Es sollte angemerkt werden, dass eine solche Anforderung des Coppers die Anzahl
von Bitebenen und daher die Anzahl von Farben auf dem Bildschirm einschränkt.
Der Grund dafür wurde hier bereits dargestellt: Jenseits von 4 Bitebenen
stiehlt die Hardware dem Copper Zyklen, sodass dieser die Möglichkeit verliert,
beliebig viele MOVEs pro Zeile auszuführen:

Bild: Um die Bitplanes 5 und 6 anzuzeigen, stiehlt die Hardware Zyklen vom 
Copper ; figure10-2.png

In zoom1.s sieht der den Zoom betreffende Teil der Copperliste (allerdings
nach einer Initialisierung von BPLCON1 auf $00FF) so aus:
	
	; Zoomen

	move.w #ZOOM_Y<<8,d0
	move.w #ZOOM_DY-1,d1
_zoomLines:

	; Warten Sie auf den Zeilenanfang

	move.w d0,d2
	oder.w #$00!$0001,d2
	move.w d2,(a0)+
	move.w #$8000!($7F<<8)!$FE,(a0)+

	; BPLCON1 mit 15 Pixel Verzögerung initialisieren ($00FF)

	move.w #BPLCON1,(a0)+
	move.w #$00FF,(a0)+

	; Warte auf die Position auf der Zeile, die dem Beginn der Anzeige
	; entspricht (horizontale Position $3D in einem WAIT)

	move.w d0,d2
	oder.w #ZOOM_X!$0001,d2
	move.w d2,(a0)+
	move.w #$8000!($7F<<8)!$FE,(a0)+

	; Verkettet MOVEs, die nichts tun, bis zu demjenigen, der die
	; Verzögerung an ZOOM_BPLCON1 weitergeben muss

	IFNE ZOOM_MOVE		; Weil ASM-One bei einem REPT abstürzt, dessen Wert 0 ist...
	REPT ZOOM_MOVE
	move.l #ZOOM_NOP,(a0)+
	ENRD
	ENDC

	; Ändern Sie BPLCON1, um die Verzögerung auf ZOOM_BPLCON1 zu ändern

	move.w #BPLCON1,(a0)+
	move.w #ZOOM_BPLCON1,(a0)+
	
	;Verkettung von MOVEs, die bis zum Ende der Zeile nichts bewirken

	IFNE 39-ZOOM_MOVE	; Weil ASM-One bei einem REPT abstürzt, dessen Wert 0 ist...
	REPT 39-ZOOM_MOVE
	move.l #ZOOM_NOP,(a0)+
	ENRD
	ENDC

	; Gehe zur nächsten Zeile des gezoomten Zeilenstreifens

	addi.w #$0100,d0
	dbf d1,_zoomLines

	; BPLCON1 ($00FF) für Bildschirmende zurücksetzen

	move.w #BPLCON1,(a0)+
	move.w #$00FF,(a0)+

Die Copperliste enthält dann insbesondere einen folgenden Block pro Zeile N,
hier wiederum zur besseren Lesbarkeit in Pseudocode dargestellt:
	
	WAIT ($00,N)
	MOVE #$00FF,BPLCON1
	WAIT ($3D,N)
	REPT ZOOM_MOVE
	MOVE #$000,ZOOM_NOP
	ENRD
	MOVE #ZOOM_BPLCON1,BPLCON1
	REPT 39-ZOOM_MOVE
	MOVE #$000,ZOOM_NOP
	ENRD

DAS ANPASSEN DES HARDWARE-HORIZONTALZOOMS IST EINE ECHTE HERAUSFORDERUNG

Indem wir ZOOM_MOVE im vorherigen Programm modifizieren, geben wir den Index
des MOVE an, an dem der Copper ZOOM_BPLCON1 in BPLCON1 schreiben soll, da wir
wissen, dass BPLCON1 bei $00FF initialisiert ist. Das Ergebnis kann dann auf
dem Bildschirm beobachtet werden.
Damit letzteres deutlich sichtbar ist, wird der Effekt auf einem Streifen von
ZOOM_DY der Höhe wiederholt, in diesem Fall 20 Pixel, gefolgt von einem
Streifen derselben Höhe ohne Effekt. Außerdem ist in der Bitebene ein weißes
Muster auf rotem Hintergrund gezeichnet: Es ist eine Folge von Gruppen von
16 Pixeln: In der 1. Gruppe ist das letzte Pixel weiß; in der 2. Gruppe sind
die letzten beiden Pixel weiß; etc
Dieses Muster ermöglicht es, einen Effekt zu erzielen wie: "Wenn ich mich auf
der Ebene des MOVE positioniere, der der Gruppe mit 4 weißen Pixeln entspricht,
und ich BPLCON1 um 4 reduziere, beobachte ich das Verschwinden dieser 4 Pixel?"
Was zu beobachten ist, ist, dass die Ergebnisse sehr allgemein enttäuschend
sind. Wenn Sie beispielsweise BPLCON1 beim 18. MOVE an $0022 übergeben
(dh: ZOOM_MOVE gleich 17), wird Folgendes erzeugt:

Bild: Die Gefahren der Änderung von BPLCON1 während der Zeile
	; figure5-11.png

Sie können jedoch zufriedenstellend sein. Als Gegenbeispiel ergibt das
Übergeben von BPLCON1 mit $00EE beim 4. MOVE Folgendes: 

Bild: Das erfolgreiche Verbergen einer Spalte durch Modifizieren der
	 BPLCON1-Mittellinie	; figure6-8.png

Indem auf diese Weise vorgegangen wird, aber mit Hilfe eines komplizierteren
Programms, das es ermöglicht, mehrere MOVEs zu bestimmen, die die Verzögerung
um 1 in BPLCON1 reduzieren müssen, ist es möglich, eine Liste der 40 MOVEs zu
erstellen, die dies ermöglichen um die Breite des Bildes um 1 Pixel, 2 Pixel,
3 Pixel usw. bis zu 15 Pixel zu reduzieren, für einen gegebenen Anfangswert von
BPLCON1.
"Ein gegebener Anfangswert von BPLCON1"? Ist das nicht $00FF? Nein, denn Sie
müssen eine Einschränkung handhaben: Wenn eine Spalte ausgeblendet wird, werden
die folgenden Spalten auf dem Bildschirm um ein Pixel nach links verschoben.
Bei diesem Zug ist links ein Bild, dessen 15 Spalten verdeckt sind, um 15 Pixel
gepackt. Dies ist jedoch nicht zu erwarten, wenn beim Zoomen die Breite eines
Bildes von 320 auf 0 Pixel reduziert wird: Wie bei der Präsentation des
vertikalen Hardware-Zooms erwähnt, muss das Bild auf dem Bildschirm zentriert
bleiben.
Um dies zu erreichen, muss das folgende Szenario angenommen werden. In dieser
Figur repräsentiert jede Linie einen Zoomschritt. Links der Anfangswert von
BPLCON1. Rechts der Endwert. Zwischen den beiden bilden die 20 Gruppen von
16 Pixeln eine Zeile eines Bildes mit einer Breite von 320 Pixeln:
die Gruppen, deren letzte Pixel bereits in den vorherigen Schritten verdeckt
wurden, sind hellrot;
die Gruppe, deren letztes Pixel zu diesem Zeitpunkt verdeckt werden muss, ist
dunkelrot.
Für jede hellrote oder dunkelrote Gruppe wird der Wert von BPLCON1 um 1
verringert, um ein Pixel auszublenden.

Bild: Hardware-Horizontal-Zoom-Szenario ; figure7-8.png

Wie Sie sehen, zielt das Szenario darauf ab, die Kompression auf der linken
Seite des Bildes so weit wie möglich zu kompensieren, indem es jedes Mal,
wenn zwei Pixel verdeckt wurden, um ein Pixel nach rechts verschoben wird. Dies
ist ein Szenario, das aufgebaut wird, indem die Schritte vom letzten
zurückgegangen werden, da der Anfangswert von BPLCON1 dann $00FF sein muss, um
15 Pixel verbergen zu können.
Die Annahme dieses Szenarios hat eine entscheidende Konsequenz. Um das zu 
verstehen, müssen wir nun vier Dinge klar unterscheiden:

Der Bildschirm.

Dies ist der physische Bildschirm des Computers: Was die Referenzmarke
betrifft, wird sie nie verschoben, und ihre horizontale Auflösung beträgt immer
320 Pixel.

Das Bild.

Folgendes sieht der Betrachter auf dem Bildschirm: links eine Spalte der
Farbe 0, die durch den Anfangswert von BPLCON1 erzeugt wird, dann die
Bitebenen, deren sichtbarer Teil rechts durch eine Spalte gleicher Breite
weggeschnitten ist.

Bitebenen. 

Dies sind 320 Pixel breite Speicherplätze, von denen nur ein Teil im
Bildschirmbild sichtbar ist.

Die Zeichnung. 

Das ist es, was der Betrachter sehen soll, nämlich etwas, dessen Breite
allmählich reduziert wird, während es im Bild zentriert bleibt. Es ist das
Einbetten mehrerer Markierungen (die Zeichnung in der Bitebene, die Bitebene
im Bild, das Bild auf dem Bildschirm - aber wir können davon ausgehen, dass
ihre Markierungen verwirrt sind), was die gesamte Komplexität der Verwaltung
des horizontalen Hardware-Zooms ausmacht.
Wenn keine Spalte ausgeblendet ist, muss die Zeichnung auf dem Bildschirm
zentriert sein. Aber BPLCON1 hat dann den Wert $0077. Damit eine um 7 Pixel
nach links verschobene Zeichnung zentriert auf dem 320 Pixel breiten Bildschirm
erscheint, darf die Breite dieser Zeichnung 306 Pixel nicht überschreiten. Wenn
7 Pixel auf der linken Seite unbrauchbar sind, müssen 7 Pixel auf der rechten
Seite unbrauchbar sein: 14 Pixel insgesamt, die von 320 subtrahiert werden
müssen, was 306 ergibt.
Es handelt sich also um eine 306 Pixel breite Zeichnung, links eingekeilt in
320 Pixel breite Bitebenen, die höchstens zur Erzeugung des Zooms verwendet
werden können, die 14 Pixel breite Spalte rechts muss in Farbe 0 sein:

Bild: Die 306 Pixel breite Zeichnung in einer 320 Pixel breiten Bitebene
	 ; figure8-6.png

Das Szenario führt zu einer Liste, die den Wert von BPLCON1 am Anfang der Zeile
angibt und die MOVEs identifiziert, die diesen Wert verringern, um die letzte
Spalte von N Gruppen von 16 Pixeln zu verbergen und die Breite des Bildes um
ebenso viele Pixel zu reduzieren:

Die "magische Liste" des Hardware-Horizontalzooms	; figure9-5.png

Diese Liste ist absolut spezifisch:

der Folge von 40 MOVE einer Zeile muss ein WAIT an der horizontalen Position
$3D vorausgehen;
die Gruppen wurden durch Anwendung des Szenarios bestimmt, das nur ein Szenario
unter anderen ist.
Betrachten wir diese Liste als eine der "magischen Listen" des Amigas. Eine
andere "magische Liste" ist diejenige, die angibt, wie die Copperliste
organisiert werden muss, um Schleifen zu erzeugen, die über 8 Zeilen Serien von
40 MOVEs wiederholen, und dies über die gesamte Höhe eines PAL-Bildschirms, d.h.
sagen wir auf 256 Zeilen. Diese andere Liste wird im zweiten Teil dieses
Artikels vorgestellt und erklärt, sobald der Cracktro, der sie ausnutzt,
veröffentlicht wurde - es ist nicht so, dass noch nie jemand diese Liste
zusammengestellt hätte; es ist notwendig, den Code dieses Cracktros zum
Download vorschlagen zu können, damit der Artikel interessant zu lesen ist...
und heutzutage muss man warten, bis ein Spiel herauskommt, um ein Cracktro
freizugeben!
Zurück zu unserer Liste. Die Implementierung in das Programm zoom2.s führt zu
folgendem Ergebnis, bei dem eine 306 Pixel breite Zeichnung (weiße Linien auf
grauem Hintergrund), die in einer 320 Pixel breiten Bitebene (roter
Hintergrund) zentriert ist, allmählich herunterskaliert wird, wobei die letzten
Pixel von 15 Gruppen von 16 Pixel hintereinander ausgeblendet werden. Damit der
Zoom im Falle einer Animation allmählich erscheint, wechseln sich die
Verdeckungen links und rechts der mittleren Pixelgruppe ab. Die Zeichnung ist
in der oberen Hälfte des Bildschirms intakt; Es wird in die untere Hälfte des
Bildschirms gezoomt und verliert alle 8 Zeilen ein Pixel:

Bild: Reduzieren Sie die Breite eines Bildes schrittweise um 15 Pixel, während
Sie es zentrieren ; figure11-4.png

SCHALTEN SIE BEI MEHR ALS 15 PIXELN VON VERDECKUNG AUF UNTERDRÜCKUNG UM

BPLCON1 ermöglicht es, am Anfang jeder Zeile eine anfängliche Verzögerung von
höchstens 15 Pixeln einzuführen. Es können also höchstens 15 Pixel auf dieser
Linie verdeckt werden, was eindeutig nicht ausreicht, um einen Zoom zu
erzeugen, bei dem die Bildbreite von 320 auf 0 Pixel sinken würde.
Wenn die Möglichkeiten des Hardware-Horizontalzooms erschöpft sind (BPLCON1 
Wert am Anfang einer Zeile $00FF und allmählich auf $0000 reduziert), gibt es
keine andere Lösung, als mit einem Software-Horizontalzoom zu übernehmen. Es
geht dann darum, in den Bitplanes zu reproduzieren, was der Zuschauer auf dem
Bildschirm sieht, bevor er den Hardware-Zoom neu initialisiert (BPLCON1 im Wert
von $0077 am Anfang einer Zeile und nicht reduziert). Dies läuft darauf hinaus,
dass es notwendig ist, die Pixelspalten, die in den Bitebenen verborgen sind,
wirklich zu entfernen und die so zuletzt reduzierte Zeichnung horizontal neu 
zu zentrieren.
Um wie viele Pixel neu zentrieren? Wie bereits erwähnt, ist der Wert von
BPLCON1 $00FF, wenn eine Übernahme vom Hardware-Zoom erforderlich ist, was
einer Verschiebung von 15 Pixeln nach rechts entspricht. Außerdem beträgt der
Wert von BPLCON1, wenn keine Pixel ausgeblendet sind, $0077, was einer
Verschiebung von 7 Pixeln nach rechts entspricht. Folglich muss eine Zeichnung
erstellt werden, die, wenn die Bitplanes, die sie enthalten, auf diese Weise
verschoben werden, die folgenden Eigenschaften aufweist:

es wird 320 - 15 = 305 Pixel breit sein;
es erscheint um 15 Pixel nach rechts verschoben.

Kurz gesagt, einmal verkleinert, muss die Zeichnung um 15 - 7 = 8 Pixel nach
rechts in den Bitplanes verschoben werden. Wir sprechen über die Zeichnung und
nicht über die Bitplanes. Es versteht sich nämlich, dass sich die Breite des
letzteren nicht ändert; es ist die Zeichnung, die sie enthalten, die reduziert
wird, nicht sie.

Bild: Spalten löschen und das Ganze beim Zoomen per Software verschieben
	; figure12-3.png

Wie löschen? Es ist möglich, den Blitter zu verwenden, der großartig ist, um
Wörter nach rechts (im aufsteigenden Modus) sowie nach links (im absteigenden
Modus) zu verschieben, nachdem sie möglicherweise maskiert wurden, oder die CPU
oder sogar beides.
Optimierung ist möglich, ja sogar notwendig. Tatsächlich wird über den
Software-Zoom die Breite der Zeichnung in den Bitebenen bis zu dem Punkt
reduziert, an dem die Zeichnung nicht länger in bestimmte Gruppen von 16 Pixeln
eingreift, die sich links und rechts davon befinden.
Daher ist es unnötig, Spalten in diesen Gruppen zu löschen. Ebenso müssen diese
Säulen nicht mehr verdeckt werden. Diese Optimierungen sind obligatorisch, da
der Betrachter nicht verstehen würde, dass der Zoom zu pausieren scheint, weil
ein Schritt damit verbracht wird, eine leere Spalte zu verstecken. Es ist daher
notwendig zu bestimmen, welche Spalten während eines Hardware-Zoom-Zyklus
ausgeblendet und am Ende dieses Zyklus gemäß der Breite der Zeichnung zu Beginn
dieses Zyklus durch einen Software-Zoom gelöscht werden müssen. Folgendes wurde
getan, um das Programm zoom3.s mithilfe der Excel-Tabelle zu erstellen, die
in zoom.xlsx angezeigt wird:

Bild: Berechnung der zu verarbeitenden Gruppen bei jedem horizontalen Hardware-
Zoomzyklus. ; figure13-5.png

Da die Anzahl der zu löschenden Spalten im Debug-Modus (DEBUG-
Konstante auf 1 geändert) verringert wird, scheint es, dass die Zeit, die zum 
Löschen benötigt wird, abnimmt, während die Zeichnung immer weniger Gruppen in
den Bitebenen belegt. Diese Zeit ist zunächst so groß, dass die Löschung nicht
in den frame auf dem Amiga 500 passt. Vielmehr müsste man die Löschung einfach
aus der Hauptschleife nehmen und damit vorher die nachfolgenden Versionen des
Designs backen. Sie sollten alle in den Speicher passen.
Am Ende ist der Löschcode ziemlich komplex, und es würde zu weit führen, die
Details hier darzustellen. Wer mehr wissen will, kann auf die Quelle des
angegebenen Programms verweisen. Der Blitter wird dort nur verwendet, um durch
Verschieben und Maskieren die Wortspalten zu kopieren, die die Zeichnung
bilden, und nur diese.

DIE AUSWAHL DER AUSZUBLENDENDEN ZEILEN UND SPALTEN: DAS DILEMMA EINES INFORMATIKERS

Die vorgestellten Techniken zum Ausblenden/Löschen von Zeilen und Spalten
funktionieren gut, aber sie müssen einige Annahmen beachten. Diese Annahmen
beziehen sich darauf, wie die Zeilen und Spalten identifiziert werden, die in
einer bestimmten Zoomstufe ausgeblendet werden sollen. Insbesondere bestimmten
sie das zuvor vorgestellte Szenario für den horizontalen Hardware-Zoom.
Wenn es notwendig ist, N Zeilen und Spalten in einer bestimmten Zoomstufe
auszublenden, besteht der erste Reflex darin, zu versuchen, diese Zeilen
gleichmäßig über die Höhe und diese Spalten über die Breite der Zeichnung zu
verteilen. Wenn ich darüber nachdenke, basiert dies auf der Annahme, dass der
Zoom realistischer ist, wenn die Verdeckung diffus ist, da der Betrachter immer
genügend Informationen an jeder Stelle in der Zeichnung haben sollte, um wenn
nicht die ursprüngliche Zeichnung, zumindest die zu erkennen Zeichnung aus
dem vorherigen Schritt.
Dies ist jedoch nur eine Hypothese. Ginge es darum, einen Text zu zoomen,
würden die so willkürlich behandelten Zeichen mit Sicherheit schnell
unkenntlich. Streng genommen ist die Reduktion einer Zeichnung die Filterung
einer Botschaft, die nur unter der Bedingung zu einem akzeptablen Ergebnis
führen kann, dass die Bedeutung der betreffenden Botschaft zumindest minimal
berücksichtigt wird, selbst wenn es bedeutet, letztere neu zu formulieren.
Diese semantische Überlegung mag beim Echtzeitzoomen einer Zeichnung auf dem
Amiga stratosphärisch erscheinen, denn die zur Verfügung stehende
Rechenleistung verbietet zwar eine rigorose Berücksichtigung - wenn überhaupt
eine Berücksichtigung möglich ist! Es ist jedoch gut, dies zu erwähnen, um eine
Befragung ohne Ergebnis der Relevanz der angenommenen Hypothese zu vermeiden.
Damit meinen wir, dass wir durch den Versuch, die Verstellung zu zerstreuen,
versuchen, den Zuschauer mit den zur Verfügung stehenden Mitteln bestmöglich
einzuhüllen. Was die Hypothese begründet, sind nicht erlernte Berechnungen; 
es ist so, dass das resultierende Ergebnis für den Zuschauer ziemlich
überzeugend ist.
Schließlich ist es noch notwendig, die Hypothese wegen einer technischen
Einschränkung zu hinterfragen, die diese Anwendung ernsthaft einschränkt. Diese
Einschränkung bezieht sich auf den horizontalen Hardware-Zoom, der, wie wir
gesehen haben, nicht so flexibel ist wie der vertikale Hardware-Zoom.
Tatsächlich ist es unmöglich, die auszublendenden Spalten so einfach
auszuwählen wie die zu behandelnden Zeilen auf die gleiche Weise: Sie müssen
unter den letzten Pixeln von Gruppen von 16 Pixeln auswählen.

Um beispielsweise eine Zeichnung von 320 auf 318 Pixel zu reduzieren, indem
2 Spalten ausgeblendet werden, scheint es konsequent, die Spalten 106 und 214
auszublenden, wobei der Abstand zwischen den ausgeblendeten Spalten dann
regelmäßig ist:

106 Pixel zwischen den Spalten 0 und 105;
107 Pixel zwischen den Spalten 107 und 213;
106 Pixel zwischen den Spalten 215 und 320.

Nun entspricht Spalte 106 dem 10. Pixel der 6. Gruppe von 16 Pixeln einer
Zeile. Mit anderen Worten, es fällt schlecht, weil es nicht auf das Pixel einer
Gruppe fällt, die durch Reduzieren der Verzögerung um 1 vor der Anzeige der
letzteren verborgen werden kann. Kurz gesagt, es stört, weil es nicht dem
16. Pixel einer Gruppe von 16 Pixeln entspricht.
Die Verteilung der Pixelspalten, die verborgen werden können, ist
eingeschränkt. Wer die Breite einer Zeichnung schrittweise von 320 auf 0 Pixel
reduzieren möchte, indem er bei jedem Schritt eine neue Spalte von Pixeln
ausblendet, kann die von ihm ausgeblendeten Spalten bestenfalls alle 16 Pixel
verteilen. Und wieder sind es nicht alle 16 Pixel der Zeichnung, sondern alle
16 Pixel der Bitplanes, die die Zeichnung enthalten, wie wir gesehen haben.
Schließlich muss, unabhängig von der angenommenen Hypothese, diese auch in
einem anderen Punkt in Frage gestellt werden. Fahren wir mit dem horizontalen
Zoom-Beispiel fort. Unabhängig von der gerade erwähnten Einschränkung, wenn es
notwendig ist, versteckte Spalten zu verketten, wie ist es besser vorzugehen:
indem Sie bedenken, dass eine ausgeblendete Spalte nicht wieder auftauchen soll,
also eine neue Spalte ausblenden, auch wenn die gelöschten Spalten nicht
gleichmäßig über die gesamte Breite der Zeichnung verteilt sind?
indem man bedenkt, dass eine ausgeblendete Spalte wieder auftauchen kann, also
neue Spalten ausblendet, die zwangsläufig anders sein werden, die aber den
Vorteil haben, dass sie immer gleichmäßig über die gesamte Breite der Zeichnung
verteilt sind?
Auch hier handelt es sich um eine Frage, für die wir unendlich viel Zeit
aufwenden würden, da es im Hinblick auf die verfügbaren Mittel unmöglich ist,
die eine oder andere dieser Hypothesen beizubehalten, ohne die Wirkung zu
berücksichtigen, dass das Ergebnis, das Produkt hervorbringt auf den
Betrachter.
Für einen kartesischen Verstand ist diese Hardware-Zoom-Geschichte in jeder
Phase ein bisschen enttäuschend. Die Identifikation von MOVE, um BPLCON1 zum 
richtigen Zeitpunkt auf einer Linie zu modifizieren? Empirisch zu ermitteln.
Auszublendende Spalten und Zeilen identifizieren? Empirisch zu ermitteln. Die
Wahl, ausgeblendete Spalten und Zeilen wieder erscheinen zu lassen oder nicht? 
Empirisch zu ermitteln.
Aber es liegt daran, dass der kartesische Verstand die Domäne verwechselt hat.
Denken Sie daran, dass der Hardware-Zoom in einer Demo verwendet wird. Wie der
beeindruckende Navis / ASD jedoch sehr gut erklärt hat, besteht das Prinzip
jeder Demo darin, zu täuschen: "Wir müssen schummeln. Und Sie wissen, jeder tut
das. Deshalb unterscheiden sich Demos vom Erstellen von Spielen oder
Offline-Filmen."
Es ist das Wort des Meisters, weil wir das Genre nicht besser definieren
könnten. Aber es ist gut, dass wir regelmäßig daran erinnert werden, wofür wir
uns einsetzen sollen. Das ist der beste Weg, um nicht einer Illusion zum Opfer
zu fallen, der des Strebens nach Perfektion ohne Interesse für denjenigen, dem
wir die Früchte unserer Arbeit zugedacht haben, nämlich den Zuschauer. Und in
einer Demo geht es darum, Hollywood dazu zu bringen, Massen anzuziehen, nicht
französisches Kino, um sie fernzuhalten ... Wenn Sie nur für sich selbst
arbeiten, es sei denn, Sie sind ein Genie - aber wem ist diese Frage bereits
beantwortet -, werden Sie nicht bleiben Geschichte: Genie unterwirft;
der Dritte muss überzeugen.
Ohne uns also irgendwelche Illusionen über die Kategorie zu machen, zu der wir
gehören, lassen Sie uns unsere Erkundung der Freuden des Hardware-Zooms
wohlwollend abschließen.
Das Programm zoom4.s fügt den Hardware-Vertikalzoom der Kombination aus
Hardware- und Software-Horizontalzoom hinzu. Im Fall des vertikalen Zooms ist
das angenommene Szenario genau das gleiche wie das, das für das Verbergen der
Säulen angenommen wurde, das durch die Beschränkungen des horizontalen
Hardware-Zooms auferlegt wird. Ein für diesen Anlass erstelltes Tool in HTML5
ermöglichte es, die Indizes der zu verbergenden Zeilen zu generieren, während
der Zoom fortschreitet:

Bild: Ein in HTML erstelltes Tool zum Testen eines vertikalen Zoomszenarios
	; figure13-3.png

DER HORIZONTALE HARDWARE-ZOOM, EIN NUTZLOSER FUND?

Wir müssen die Hartnäckigkeit derjenigen begrüßen, die sich auf den
Hardware-Zoom eingelassen haben, um etwas damit zu machen, da der Effekt so
schwer zu meistern ist. Allerdings sollte man den Gewinn, den sie daraus
ziehen konnten, nicht überschätzen. Es liegt nicht daran, dass das Zoom im
frame bald im Vollbildmodus angezeigt wird, dass letzteres Hardware ist. Wenn
der horizontale Zoom sehr erfolgreich ist, gibt es tatsächlich allen Grund zu
der Annahme, dass es sich nicht um Hardware handelt.
So beginnt die berühmte Elysium - Demo von Sanity mit einem tadellosen Zoom
eines Bildes auf 4 Bitplanes. Aber die Disassemblierung der Copperliste zeigt
nur WAITs auf jeder Zeile, die zu Modifikationen von BPL1MOD und BPL2MOD
führen. Mit anderen Worten, hier wird nicht der horizontale Hardware-Zoom
verwendet, sondern nur der vertikale Hardware-Zoom:

Bild: Einwandfreier Zoom eines Bildes in 4 Bitplanes in Sanitys Elysium-Demo
	; figure14-2.png

Ein Beispiel für horizontales Zoomen mit Hardware findet sich in einer anderen
Sanity-Produktion, der Jesterday-Musikdisk. Diese Art von Zoom wird
verwendet, um die Walze zu erzeugen, die der Benutzer dreht, um ein Musikstück
zum Anhören auszuwählen:

Bild: Die Auswahlrolle in der Sanity Jesterday-Musikdiskette ; figure15-2.png

Noch origineller ist das Star Wars-Scrolling in The Fall von The Deadliners
& Lemon. Das Zerlegen der Copperliste zeigt, dass nicht nur das horizontale
Zoomen der Hardware verwendet wird, sondern der Effekt mit Bitplane-
Adressänderungen kombiniert wird, um Sprünge in ihnen auszuführen:

Bild: Scrollen im Star Wars-Stil in The Fall von The Deadliners & Lemon 
	; figure16-1.png

Dieses Scrollen muss für den Einfallsreichtum des Codierers erwähnt werden,
aber auch umgekehrt für seine mittelmäßige visuelle Qualität, die Buchstaben
sind so verzerrt 1). Wir haben Schriftrollen dieser Art gesehen, die viel
angenehmer zu betrachten sind, insbesondere die des unglaublichen Stardust
-Spiels, das weder horizontalen Hardware-Zoom noch vertikalen Hardware-Zoom
verwendet, und zwar in HiRes! :

Bild: Stardusts Star Wars-Schriftrolle, absolut perfekt ; figure17-1.png

Aus all dem lassen sich einige Lehren ziehen:

Erstens kann die Fokussierung auf Coprozessoren dazu führen, dass man aus den
Augen verliert, dass man mit der CPU durchaus viele Effekte erzielen kann,
möglicherweise viel erfolgreicher. Es ist wie immer: Wir konzentrieren uns auf
das Zubehör zu Lasten der Hauptsache, weil wir von der Technik eingenommen
werden und den Algorithmus vernachlässigen.
"Legends never die", wie der andere sagt. Der Herbst geht auf den April 2018
zurück! Ehrlich gesagt, wer hätte gedacht, dass es mehr als 30 Jahre nach
seiner Veröffentlichung immer noch Programmierer geben würde, die sich neue
Anwendungen der Amiga 500-Hardware ausdenken? Auch hier gilt wie immer:
Schöpfen Sie schon mal die Möglichkeiten eines alten Topfes aus, der
sprichwörtlich immer die beste Marmelade macht?

1) Das schmälert nicht den Verdienst des Programmierers, der eine technische
Meisterleistung vollbracht hat. Außerdem enthält die Demo optisch sehr
gelungene Effekte, insbesondere Sequenzen, deren Umsetzung wohl Wahnsinnsarbeit
erfordert haben muss. Zum Thema Sequenzen, lesen Sie hier ein Interview mit
Chaos/Sanity, erschienen 1993 in The Jungle #2. Zu Recht sehr berühmter
Programmierer, der offensichtlich alle hoch hinaus nahm - lesen Sie
"Chaos - Bitte nur Superlative" veröffentlicht in RAW #7, um darüber zu
lachen - aber sein Punkt war relevant.
