
; Lektion 09

EIN CRACKTRO AUF DEM AMIGA PROGRAMMIEREN (1/2)

3. Juni 2017 Amiga, 68000 Assembler, Blitter, Copper, Cracktro

Anlässlich der Veröffentlichung des zweiten Dokumentarfilms der Formidable-
Reihe Von Schlafzimmer zu Millionen dieses Mal dem Commodore Amiga gewidmet,
nehmen wir uns einen Moment Zeit, um noch einmal auf einen der vielen Aspekte
der damaligen Szene zurückzublicken: die Produktion von Cracktros.
Nehmen wir als Beispiel einen Cracktro, der vor einem Vierteljahrhundert für
die berühmte Band Paradox codiert wurde:

Cracktro auf Amiga

Dieser Cracktro wurde ausgewählt, weil sein Code gefunden wurde und er den
Blitter und den Copper verwendet, zwei der Coprozessoren des Amiga, deren
Originalität der Architektur somit hervorgehoben werden kann.
Beachten Sie, dass es möglich ist, eine Videoaufzeichnung des auf YouTube
produzierten Ergebnisses anzusehen. Das Cracktro ist sogar Teil der Auswahl an
HTML5-Portierungen von We Are Back, aber die Autoren dieser Portierung haben
den bemerkenswertesten Effekt ignoriert: die Verwendung einer Schriftart mit
variablem Leerzeichen ... Dagegen haben ihre Flashtro- Gegenstücke perfekt
abgeschnitten.

Dieser Artikel ist der erste in einer Reihe von zwei. Nachdem er daran erinnert
hat, wie man eine Entwicklungsumgebung in 68000-Assembler im Kontext eines
Amiga-Emulators implementiert, wird er einen der beiden grafischen
Coprozessoren, den Blitter, vorstellen. Der zweite Artikel wird den anderen
Grafik-Coprozessor, den Copper, vorstellen und eine kleine Zusammenfassung über
das Interesse machen, das eine Rückkehr in die Vergangenheit heute wecken kann.

Klicken Sie hier, um den Code (knapp tausend Anweisungen in 68000-Assembler)
und die Daten des Cracktros herunterzuladen.

EMULIEREN SIE DEN AMIGA IN WINDOWS

WinUAE ist der Emulator schlechthin, um den Amiga im Kontext von Windows
wiederzubeleben. Es reicht jedoch nicht aus, es wiederherzustellen, um es
verwenden zu können. Außerdem benötigen Sie das Amiga-ROM, Kickstart
(mindestens in Version 1.3). Um das Cracktro kompilieren zu können, muss
außerdem das Betriebssystem, die Workbench (mindestens in Version 1.3)
installiert sein. Kickstart und Workbench unterliegen weiterhin Rechten. Sie
werden von Amiga Forever für zehn Euro vertrieben.
Wie jede Demonstration von Programmier-, Grafik- und Musikfähigkeiten, die zu
dieser Zeit ihr Geld wert war, wurde der Cracktro in Assembler 68000 codiert.
In diesem Artikel konzentrieren wir uns auf den Teil des Codes, der die
Grafikeffekte verwaltet (übrigens, lassen Sie es Caesar zurückgegeben werden,
was Caesar überlassen wird: Der Teil, der die Musik spielt, ist "Coded by Lars
'ZAP' Hamre/Amiga Freelancers" und "Modified by Estrup/Static Bytes").

Von einer Erweiterung der Nutzung von WinUAE kann hier keine Rede sein. Der
Zweck dieses Artikels ist es, daran zu erinnern, wie es war, die Hardware des
Amigas direkt zu programmieren, und zu versuchen, einige Lehren daraus für
heute zu ziehen, nicht dazu anzuregen, auf diese Weise erneut zu programmieren.
Nur die Programmierer der damaligen Zeit konnten von der Idee motiviert werden,
den Cracktro aus den zur Verfügung gestellten Daten zusammenzustellen, und zwar
immer wieder. Diese müssen unbedingt erfahren genug sein, um in WinUAE zu
navigieren und eine vom Amiga 500 oder höher inspirierte Konfiguration mit
erweitertem Speicher und Festplattenemulation zu erstellen. Die wenigen
nachstehenden Informationen werden es ihnen ermöglichen, ihr Gedächtnis
aufzufrischen, um die Fortsetzung sicherzustellen.

Klicken Sie hier, um Cracktro-Quelle und Daten herunterzuladen. Um die Quelle
zu kompilieren und mit den Daten innerhalb einer ausführbaren Datei zu
verknüpfen, müssen Sie ASM-One verwenden:

Cracktro im Debug-Modus in ASM-One ausführen

Nach der Installation der Workbench auf einer Festplattenemulation (dem
klassischen DH0: Volume) müssen Sie reqtools.library im Libs-Verzeichnis des
Systems installieren, um ASM-One auszuführen. Außerdem müssen Sie mit einem 
Shell-Kommando SOURCES: dem Verzeichnis zuweisen, das den Code und die Daten
enthält (Beispiel: weisen Sie SOURCES: DH0:cracktros zu, wenn Sie dort den
Inhalt des Archivs in einem Cube - Unterverzeichnis abgelegt haben).
Nach dem Start von ASM-One können Sie beispielsweise einen Arbeitsbereich im
Fast-Speicher von 100 KB zuweisen, dann die Quelle über den Befehl R (Read)
laden und über den Befehl A kompilieren (Assemble), nicht ohne angegeben zu
haben, dass die Groß-/Kleinschreibung ignoriert werden muss, indem Sie zum
Assembler-Menü , Assemble-Untermenü gehen, um die UCase=LCase-Option zu
aktivieren. 
Anschließend können Sie die ausführbare Datei mit dem Befehl WO (Write Object)
speichern. Soweit es die Dokumentation betrifft, war die Referenz für jeden
Programmierer (wir werden "Coder" sagen, um zum Zeitgeist zurückzukehren) das
Amiga Hardware Reference Manual (Addison-Wesley hatte eine angenehmer zu
lesende Ausgabe davon veröffentlicht). Präzise und klar, weil von den 
Ingenieuren von Commodore selbst geschrieben, lieferte das Handbuch alle
nötigen Informationen, um sich dem hinzugeben, was manche als "Metal-Bashing"
bezeichneten, nämlich die direkte Programmierung der Hardware in Assembler
unter Umgehung des Betriebssystems darüber hinaus verkürzt es die
Ausführungszeit vollständig.

Jeder französische Programmierer, der sich in den 80er Jahren die Zähne
ausgebissen hat, kennt den kleinen Krieg, der sich den Verehrern des
Atari ST und des Amiga entgegenstellte, den beiden 16-Bit-Maschinen, die auf
dem nationalen Markt konkurrierten. Objektiv ist festzuhalten, dass die
Fähigkeiten des Amigas die des Atari ST auf dem Gebiet der Grafik weit
übertroffen haben. Dabei konnte sich der Programmierer nicht nur auf den
Motorola 68000 Prozessor verlassen, sondern vor allem auf zwei sehr
leistungsfähige Coprozessoren: den Blitter und den Copper.

Beginnen wir mit der Präsentation des ersten. Der Blitter kann Blöcke kopieren
und Linien zeichnen. Es wird gesteuert, indem Bits von 16-Bit-Registern gesetzt
werden, die sich an bestimmten Adressen befinden (zum Beispiel befindet sich
das Blitter BLTCON0-Steuerregister an Adresse $DFF040 oder $00DFF040, um genau
zu sein, der 68000-Adressspeicher auf 32 Bit).

SPEICHERBLÖCKE KOPIEREN

Der Blitter kann in seiner Kopierfunktion Wort für Wort (16 Bit) bis zu drei
Blöcke an unterschiedlichen Adressen (Quellen A, B und C) lesen und bitweise
kombinieren. Für jeden Block muss die 32-Bit-Adresse des ersten Wortes über
die BLTxPTH- und BLTxPTL-Register spezifiziert werden, die dem höchstwertigen
Wort und dem niederwertigsten Wort der fraglichen Adresse entsprechen.
Außerdem müssen Sie über das BLTxMOD-Register das Modulo angeben, d.h. die
Anzahl der Bytes, die zur Adresse des Wortes hinzugefügt werden, das auf das
letzte Wort einer Zeile des Blocks folgt, um das erste Wort der folgenden Zeile
zu adressieren. In der folgenden Abbildung beträgt das Modulo beispielsweise
2 Wörter, also 4 Bytes (Speicher ist natürlich ein linearer Adressraum, aber
der Blitter ermöglicht es daher, ihn als Oberfläche darzustellen):

Adressieren eines Speicherblocks durch den Blitter

Nachdem die Adressen (zwangsläufig gerade) angegeben sind, genügt es, im
BLTSIZE-Register die Breite und die Höhe der Blöcke (zwangsläufig gleich)
anzugeben. Ein Block kann bis zu 1024 x 1024 Bit groß sein (etwas weniger
breit, wenn das später besprochene Verschieben und Maskieren verwendet wird).
Die Einheit ist das Wort (dh: 16 Bit), die Höhe wird mit den Bits 6 bis 15
von BLTSIZE und die Breite mit den Bits 0 bis 5 angegeben, also in Pseudocode:
BLTSIZE = (Höhe << 6) + Breite.

BLTSIZE ist ein Strobe, also ein Register, dessen einfacher Schreibzugriff eine
Aktion auslöst, in diesem Fall die erwartete Kopie. 
Die Verknüpfung der Quellen entspricht einer ODER-Verknüpfung von acht
UND-Verknüpfungen der Quellen. Die allgemeine Formel ist zwangsläufig recht
komplex und wird mit einer Kombination von Bits aus dem niedrigen Byte eines
der 16-Bit-Steuerregister des Blitters, BLTCON0, angegeben (X bezeichnet das
Quellbit X und x bezeichnet das NICHT dieses Bits):

Kombination	BLTCON0-Bit
abc	0
abC	1
aBc	2
aBC	3
Abc	4
AbC	5
ABc	6
ABC	7

Das Bit des Ziels D, das sich aus der Kombination der Bits der Quellen A, B und
C ergibt, wird also zunächst auf acht Arten berechnet, indem die Bits der
möglicherweise invertierten Quellen UND-verknüpft werden:

Kombination von Quellen durch den Blitter

Dann werden diese acht Versionen von D ODER-verknüpft, um das letzte Bit zu
bestimmen:

Kombination von Quellenkombinationen durch den Blitter

Diese allgemeine Operation kann verfeinert werden, da Sie mit den
Steuerregistern des Blitters BLTCON0 und BLTCON1 viele andere Dinge angeben
können:
- Aktivieren oder deaktivieren Sie die Quellen A, B und C und das Ziel D (das
Deaktivieren des Ziels ermöglicht es, eine Kopie zu simulieren, um über ein vom
Blitter gesetztes Steuerbit zu überprüfen, ob es nur Bits auf 0 generiert hat:
ein Mittel zum Testen eines Pixels - genaue Kollision ohne Berechnung).
Tatsächlich werden alle Quellen immer kombiniert und das Ergebnis an das Ziel
zurückgegeben, indem sie Wort für Wort durch BLTxDAT-Datenregister geleitet
werden. Durch Deaktivieren einer Quelle ist es jedoch möglich, den Wert des
entsprechenden Datenregisters einzufrieren, als ob dasselbe Wort von einer
festen Adresse gelesen würde (außer dass es daher nicht aus dem Speicher
gelesen wird, sondern einfach aus BLTxDAT gelesen wird, ist es möglich, das
gewünschte Wort vor dem Kopieren dorthin zu schreiben).

- Verschiebe die an den Quellen A und B (nicht C) gelesenen Wörter um
0 bis 15 Bits nach rechts. Dies ist eine Barrel-Verschiebung, d.h. jedes Bit,
das rechts von dem an Adresse X gelesenen Wort ausgegeben wird, wird links von
dem an Adresse X + 2 gelesenen Wort wieder eingeführt. Und für das erste Wort
einer Zeile des von einer Quelle adressierten Blocks, wirst du sagen? Nullen
werden auf der linken Seite eingeführt.

- Blöcke mit aufsteigender oder absteigender Adresse lesen. Dadurch wird eine
Quelle überschrieben. Um beispielsweise ein Bild einer Zeile wieder
zusammenzusetzen, muss es auf sich selbst kopiert werden, indem die Adresse
erhöht wird: Die Anfangsadresse der Quelle ist die des ersten Wortes der
zweiten Zeile, während die Anfangsadresse des Ziels die des ersten Wortes der 
ersten Zeile ist, und diese Adressen werden gleichzeitig erhöht (aufsteigender
Modus). Um das Bild einer Zeile zu verringern, muss es umgekehrt auf sich
selbst kopiert werden, indem die Adresse verringert wird: Die Anfangsadresse
der Quelle ist die des letzten Wortes der vorletzten Zeile, während die
Anfangsadresse des Ziels die des letzten Wortes der letzten Zeile ist, und
diese Adressen verringern sich gleichzeitig (descending-Modus).

Adressieren im aufsteigenden oder absteigenden Modus, um ein Bild eine Zeile
nach oben oder unten zu verschieben

Schließlich ermöglichen es zwei Register BLTAFWM und BLTALWM, Masken zu
definieren, die auf das erste Wort und auf das letzte Wort anzuwenden sind, das
an der Quelle A (nicht B oder C) gelesen wird. Um was zu tun? Zum Beispiel
Sprites zu beschneiden - Software-Sprites, die Copper verwalten Sprites, für
ihren Teil Material.

Im Cracktro ermöglicht eine Kopie mit Verschiebung, die bei jedem Frame durch
den Blitter durchgeführt wird, das Scrollen zu erzeugen (ein Block an der in A1
berechneten Adresse wird in absteigender Weise auf sich selbst kopiert, indem
seine Bits um die Anzahl von Bits verschoben werden, die der 
Scrollgeschwindigkeit in Pixel pro Frame entspricht):

	lea $DFF000,a5
	moveq #2,d1						; Scrollgeschwindigkeit
	ror.w #4,d1
	bset #1,d1						; mode descending
	movea.l Screen1_adr,a1
	add.w #(ScrollHeight+FontHeight)*NbPlane1*SizeX1/8-2,a1
	move.w #%0000010111001100,BLTCON0(a5)
	move.w d1,BLTCON1(a5)
	move.w #$0000,BLTDMOD(a5)
	move.w #$0000,BLTBMOD(a5)
	move.l a1,BLTBPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #SizeX1/16+64*FontHeight*NbPlane1,BLTSIZE(a5)

Im Detail ist es daher 11001100, das im niederwertigsten Byte von BLTCON0
gespeichert ist, um die Bits von Quelle B identisch zum Ziel zu kopieren.
Tatsächlich ist die implementierte logische Kombination dann
aBc + aBC + ABc + ABC, das heißt, dass das Bit der Quelle B beibehalten wird,
unabhängig von den Werten der Bits der Quellen A und C (außerdem deaktiviert).

Aber ich vergaß... Während er Speicherblöcke kopiert, kann der Blitter sie
füllen, indem er alle Bits, die er findet, auf einer Zeile positioniert. In
diesem Modus unternimmt der Blitter nichts, bis das gelesene Bit 1 ist, setzt
alle danach gelesenen Bits, bis er ein Bit 1 liest, und springt dann zurück. Es
ist möglich, diese Operation umzukehren, wodurch der Blitter gezwungen wird,
die von Anfang an gelesenen Bits zu setzen, solange er kein 1-Bit gelesen hat,
nichts zu tun, bis er ein 1-Bit liest, und dann eine Schleife zurück.

Normale und umgekehrte Befüllung durch den Blitter

Es gibt zwei Variationen dieser Füllung, eine, bei der die Bits der linken
Grenze beibehalten werden (inklusive Füllung) und eine, bei der die Bits der
linken Grenze gelöscht werden (exklusive Füllung):

Inklusive-Füllung und Exklusiv-Füllung des Blitters

Die Exklusiv-Füllung, wozu? Um die Herstellung von sehr genau gefüllten Flächen
zu ermöglichen, bei denen ein Scheitelpunkt, der auf einer Linie erscheint, nur
durch ein Pixel dargestellt wurde und nicht durch die zwei
nebeneinanderliegenden Pixel, die vor Beginn des Füllens gezeichnet werden
müssen, um zu verhindern, dass der Blitter die Linie sowieso füllt.

In Cracktro wird diese Funktionalität verwendet, um die Oberflächen der Würfel
zu füllen, die daher gezeichnet werden, wobei darauf zu achten ist, dass auf
jeder Seite nur ein Punkt pro Linie enthalten ist. Und um diese Seiten zu
verfolgen, ist es ... der Blitter, der immer noch verwendet wird, wie wir
später sehen werden.

Abschließend zu dieser Blitter-Kopierfunktion sei noch angemerkt, dass alle
genannten Möglichkeiten (Shifting, Masking, logische Verknüpfung von Quellen
und Füllung) problemlos kombiniert und in einer Pipeline nacheinander
ausgeführt werden können. Das Handbuch gibt einige Tipps zum Ausnutzen der
Pipeline-Füllung, aber dies ist ein besonders fortgeschrittenes Thema - eines,
von dem die Commodore-Ingenieure nicht garantieren konnten, dass es anhält.

LINIEN ZEICHNEN

Durch die Positionierung eines bestimmten Bits von BLTCON1 ist es möglich, den
Blitter zu bitten, entweder einen Block zu kopieren, indem er ihn füllt oder
nicht, sondern eine gerade Linie von maximal 1024 Pixeln unter Verwendung
eines Musters zu zeichnen. In diesem Modus interpretiert der Blitter bestimmte
Bits der BLTCON0- und BLTCON1-Register unterschiedlich.

Um eine gerade Linie zwischen A (xA,yA) und B (xB,yB) zu ziehen, müssen Sie
Folgendes wissen:

- die Koordinaten des Startpunkts;
- der Oktant wo sich der Punkt B befindet, bezogen auf den Mittelpunkt A;
- die Absolutwerte der Abszissen- und Ordinatendifferenzen.

Oktanten, mit denen die Position von Punkten einer geraden Linie in Blitter
angegeben werden kann

Zur Esoterik trägt der Blitter die Zahl des Oktanten bei, muss aber mit der
Steigung des Bildes der Geraden im Oktanten 6 versehen werden. Aus diesem Grund
müssen später die verwendete Größen dx und dy wie folgt berechnet werden:

dx = max(abs(yB - yA), abs(xB - xA))
dy = min(abs(yB - yA), abs(xB - xA))

Registert				Verwendung

BLTCPTH und BLTCPTL		Adresse des Bitplane-Wortes, das das dem Pixel A
						entsprechende Bit enthält
BLTDPTH und BLTDPTL		Dasselbe
BLTAMOD					4 * (dy - dx)
BLTBMOD					4*dy
BLTCMOD					Bitplane-Breite in Byte
BLTDMOD					Dasselbe
BLTAPTL					(4*dy)-(2*dx)
BLTAFWM					$FFFF
BLTALWM					$FFFF
BLTADAT					$8000

BLTBDAT	Muster der Linie über 16 Pixel ($FFFF für eine durchgezogene Linie)

BLTCON0	Die Kombination aus einer Anzahl von Bits, die durch
  Systemanforderungen gesetzt werden müssen, und signifikanten Bits, wobei
  letztere sind:
- vier Bits, die der Position von Pixel A in dem Wort entsprechen, dessen
  Adresse über BLTCPTH/BLTDPTH und BLTCPTL/BLTCPTL bereitgestellt wird;
- acht Bits, die der logischen Kombination des über BLTADAT gelieferten
  Maskenpixels, des über BLTBDAT gelieferten Musters und des von BLCDAT
  entnommenen Ziels entsprechen.

BLTCON1	Die Kombination aus einer Anzahl von Bits, die durch
  Systemanforderungen gesetzt werden müssen, und signifikanten Bits, wobei
  letztere sind:
- vier Bits, die der Position des ersten Bits entsprechen, das verwendet werden
  soll, um in dem über BLTBDAT gelieferten Muster nach rechts zu verfolgen;
- ein Bit, das angibt, ob (4 * dy) - (2 * dx) negativ ist;
- drei Bits, die die Nummer des Oktanten angeben;
- ein Bit, das angibt, ob der Blitter nur ein Pixel pro Pixelzeile in der
  Bitebene zeichnen soll.

BLTSIZE	((dx + 1) << 6) + 2

Das Zeichnen einer geraden Linie ist eine Blockkopieroperation, die drei
Quellen A, B und C kombiniert, wobei C der Bitebene entspricht, in der die
gerade Linie gezeichnet werden muss, A dem Bit, das in der Bitebene
positioniert werden muss, um dort ein Pixel der geraden Linie zu zeichnen.
B das Muster, das bestimmen muss, ob das aktuelle Pixel der Linie tatsächlich
in die Bitebene gezeichnet werden muss. Die Kombination der verwendeten Quellen
ist daher AB + AC, aber andere können in Betracht gezogen werden - 
insbesondere ABC + AB, um eine gerade Linie zu ziehen, die durch einfaches
erneutes Zeichnen gelöscht werden kann. Der rechte Plot wird als Blockkopie
gestartet, indem in das BLTSIZE-Register geschrieben wird.

Im Cracktro, nachdem bestimmte Register ein für alle Mal initialisiert wurden
(BLTALWM wurde vergessen!) ...:

	move.w #$FFFF,BLTBDAT(a5)
	move.w #SizeX0/8,BLTCMOD(a5)
	move.w #SizeX0/8,BLTDMOD(a5)
	move.w #$8000,BLTAFWM(a5)
	move.w #$8000,BLTADAT(a5)

...das Diagramm rechts wurde in die folgende Routine einbezogen:

; *************** Linie zeichnen ***************

; Eingang
; 	A0=adresse bitplane
; 	D0=Xi
; 	D1=Yi
; 	D2=Xf
; 	D3=Yf

; A6,D5,D6

DrawLine:

; ----- Punktterminierung -----

	cmp.w d1,d3
	beq DrawLine_End
	bge DrawLine_UpDown
	exg d0,d2
	exg d1,d3
DrawLine_UpDown:
	subq.w #1,d3

; ------ Berechnung Startadresse -----
	
	moveq #0,d6
	move.w d1,d6
	lsl.l #3,d6
	move.l d6,d5
	lsl.l #2,d5
	add.l d5,d6						; d6=y1*Anzahl Bytes pro Zeile
	add.l a0,d6						; +Startadresse Bitplane
	moveq #0,d5
	move.w d0,d5
	lsr.w #3,d5
	bclr #0,d5
	add.l d5,d6						; +x1/8

; ----- Oktantensuche -----

	moveq #0,d5
	sub.w d1,d3						; d3=Dy=y2-y1
	bpl.b Dy_Pos
	bset #2,d5
	neg d3
Dy_Pos:	
	sub.w d0,d2						; d2=Dx=x2-x1
	bpl.b Dx_Pos
	bset #1,d5
	neg d2
Dx_Pos:
	cmp.w d3,d2						; Dx-Dy
	bpl.b DxDy_Pos
	bset #0,d5
	exg d3,d2						; ainsi d3=Pdelta et d2=Gdelta
DxDy_Pos:
	add.w d3,d3						; d3=2*Pdelta

; ----- BLTCON0 -----
	
	and.w #$F,d0
	ror.w #4,d0
	or.w #$B4A,d0

; ----- BLTCON1 -----

	lea Octant_adr,a6
	move.b (a6,d5.w),d5
	lsl #2,d5
	bset #0,d5
	bset #1,d5

; ----- warte auf blitter -----

	WAITBLIT

; ----- BLTCON1, BLTBMOD, BLTAPTL, BLTAMOD -----

	move.w d3,BLTBMOD(a5)
	sub.w d2,d3
	bge.s DrawLine_NoBit
	bset #6,d5
DrawLine_NoBit:
	move.w d3,BLTAPTL(a5)
	sub.w d2,d3
	move.w d3,BLTAMOD(a5)

; ----- BLTSIZE -----

	lsl #6,d2
	add.w #66,d2

; ----- Start blitter -----

	move.w d5,BLTCON1(a5)
	move.w d0,BLTCON0(a5)
	move.l d6,BLTCPTH(a5)
	move.l d6,BLTDPTH(a5)
	move.w d2,BLTSIZE(a5)

; ----- Ende -----

DrawLine_End:

	rts

Wie bereits erwähnt, basiert diese Linienzeichnung auf eine Eigenschaft des
Blitters, das es erlaubt, das Zeichnen der Linie auf ein Pixel pro Pixelzeile
in der Bitebene zu beschränken:

Zeichnen Sie Flächenkonturen für die Blitter-Füllung

Wenn alle Flächen im selben Bereich gezeichnet wurden, ist es klar, dass der
Blitter nicht jedes richtig ausfüllen konnte. Beim Cracktro berücksichtigt ein
Trick die Tatsache, dass ein Würfel nie mehr als drei Flächen gleichzeitig
freilegt, zwei mal zwei, die sich eine Seite teilen, und nur eine, um einen
Pfad zu erzeugen, den der Blitter füllen kann.
Seien A, B und C die drei sichtbaren Flächen (die nur eine oder zwei sein
können) zu einem bestimmten Zeitpunkt. In einer Bitebene werden A und C
sorgfältig gezeichnet, wobei die Seite weggelassen wird, die sie gemeinsam
haben, während in einer anderen Bitebene B und C gezeichnet werden, wobei die
gleiche Vorsichtsmaßnahme getroffen wird.

Zeichnen zusammenhängender Oberflächenkonturen zum Füllen von Blitter

Unter diesen Bedingungen ist es möglich, jede der Bitplanes problemlos mit dem
Blitter zu füllen, so dass:

- die Bits der Pixel von A in der ersten Bitebene auf 1
  und in der zweiten auf 0 sind;
- die Bits der Pixel von B in der zweiten Bitebene auf 0
  und in der zweiten auf 1 sind;
- die Bits der Pixel von C in den zwei Bitebenen auf 1 sind.

Da die Kombination der in den Bitebenen erscheinenden Bits eines Pixels die
Nummer der Farbe ergibt, in der dieses Pixel angezeigt werden muss, kann somit
jede der Flächen in einer bestimmten Farbe angezeigt werden, wobei eine kleine
Arbitrierung die Pixel zuordnet von der gemeinsamen Seite von A und B zu einer
dieser Flächen - die Füllung ist eine exklusive Füllung. Am Ende brauchte es
mit dem Blitter nur zwei Füllvorgänge und nicht drei, um drei Flächen mit
unterschiedlichen Farben zu füllen:

Einfärbung der sichtbaren Flächen

CPU-PARALLELBETRIEB

Um den Blitter abzuschließen, sollte beachtet werden, dass parallel zum
Prozessor gearbeitet wird, da er über direkten Speicherzugriff (DMA) verfügt -
ist es sogar möglich, der CPU zu verbieten, ihm Speicherzugriffszyklen zu
stehlen -, starten Sie einfach eine Kopie (mit oder ohne Füllung) oder eine
Linienzeichnung und fahre fort, als ob nichts gewesen wäre. Letztendlich
müssen Sie sicherstellen, dass der Blitter seine Aufgabe erfüllt hat, was
durch das Testen eines Bits des DMACONR-Steuerregisters erfolgt.
Im Cracktro taucht dieser Test häufig auf, um ihn nicht zu einer Routine zu
machen, zu der man springen und dann zurückkehren müsste, während
Ausführungszyklen verloren gehen, erscheint er in Form eines Makros (der
Test wird endgültig verdoppelt Grund hier dargestellt):

WAITBLIT:	macro
Wait_Blit0\@
		btst #14,DMACONR(a5)
		bne Wait_Blit0\@
Wait_Blit1\@
		btst #14,DMACONR(a5)
		bne Wait_Blit1\@
		endm

Im Allgemeinen gab es keine kleinen Einsparungen bei den Ausführungszyklen,
um "in den frame zu passen" (dh sicherzustellen, dass ein Bild mit jedem
Wischen des Bildschirms reproduziert wurde, dh 50 Mal pro Sekunde in der
PAL-Welt, um eine flüssige Animation zu erzeugen auf dem Bildschirm),
was dazu führte, dass Codewiederholungen, also Makros wie WAITBLIT,
gegenüber Routinen bevorzugt wurden.
