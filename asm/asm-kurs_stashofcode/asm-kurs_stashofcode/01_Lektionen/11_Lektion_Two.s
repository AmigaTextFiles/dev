
; Lektion 11

SCOOPEX "TWO": DIE CODIERUNG EINES CRACKTROS AUF DEM AMIGA 500

16. November 2018 Amiga, Monteur 68000, Blitter, Copper

Bitte schön! Wir versprechen, dass es die letzte für die Straße ist, und wir
holen trotzdem eine zurück. Es ist schwierig, von der Assembler-Programmierung 
der Videohardware des Amiga 500 loszukommen, solange das Wissen über letzteres
perfektioniert zu sein scheint, dass es FX zu erstellen oder, bescheidener,
zu reproduzieren gibt.
Ein Vierteljahrhundert nach dem "letzten" stoßen wir wieder zusammen mit
Scoopex "TWO" an, Cracktro, der 2018 als Vorspeise für den Port des Spiels
Starquake von Galahad der glorreichen Gruppe Scoopex codiert wurde.
Scoopex "TWO": Ein Cracktro für A500 im Jahr 2018
Im Menü: BOBs, die sich bewegen, Drucker, der angezeigt wird, und Rotozoom, der
sich dreht. Und wie immer scheinen ein paar Lektionen von allgemeinerem
Umfang als das Ausgangsfach die Möglichkeit zu bieten, darauf zu verzichten.

Update vom 22.11.2018: Optimierung des JavaScript-Codes des rotozoom, um ihn
	dem Autor der Portierung des Cractro in HTML5 auf Flashtro zur Verfügung
	zu stellen.
Update vom 19.11.2018: Eine Box (ein wenig lang, aber es scheint mir
	interessant zu sein) zum Thema Authentizität hinzugefügt, die durch die
	Emulation eines Spiels aufgeworfen wird.
Update 18/11/2018: Klicken Sie hier, um copperScreen.s herunterzuladen, ein
	Programm, mit dem Sie einen Copperbildschirm aus jeder Höhe in jede
	vertikale Position generieren können.
Update vom 17.11.2018: Außerdem ist ein Video des Cracktros auf YouTube
	verfügbar. Darüber hinaus erzählt Galahad das interessante Making-of der
	Portierung des Spiels in einem Thread des englischen Amiga Bord.

Klicken Sie hier, um das Archiv mit dem Cracktro-Code und den Daten
herunterzuladen.
Dieses Archiv enthält die folgenden Dateien:

scoopexTWOv4.adf	Das Image einer Autoboot-Diskette zum Testen des Cracktro
scoopexTWO.s		Die Quelle des Cracktro
Common/PTplayer		Die Quelle des Modul-Players
common/advancedPrinter.s	Die Quelle des Druckers
common/bob.s				Die Quelle der BOBs-Anzeige
common/debug.s				Die Quelle von Debugroutinen
common/fade.s				Die Quelle des Fades
common/interpolate.s		Die Quelle des linearen Interpolators
common/registers.s			Die Definition der Konstanten der Hardwareregister
common/wait.s				Die Quelle der Erwartung des Rasters
Daten/alienKingTut320x256x5.rawb	Das Bild in RAWB
data/scoopexTWOLogo320x64x4.rawb	Das Logo in RAWB
data/fontBevelled8x8x1.raw			Polizei in RAW
data/salah's_fists.mod				Das Modul
tools/advancedPrinter.html			Ein Tool zum Testen des Druckeralgorithmus
tools/bitmapConverter.html			Ein Tool zum Konvertieren eines Bildes in
									RAW und RAWB
tools/scoopexTWO.xlsm				Ein Tool, um die Beschreibung eines Puzzles
									in Binärdaten umzuwandeln
Werkzeuge/Stile.css					Ein Blatt mit CSS-Stilen, die von früheren
									Tools verwendet wurden
Werkzeuge/alienKingTut320x256x5.gif		Das Bild in GIF
Werkzeuge/SchriftSchrift8x8x1.png		Polizei in PNG
Werkzeuge/scoopexTWOLogo320x64x4.gif	Das Bild in GIF

NB: Dieser Artikel liest sich am besten, wenn man sich das ausgezeichnete Sound
Traveller-Modul anhört, das von Supernao / Virtual Dreams für R.A.W. #8
komponiert wurde, aber es ist eine Frage des persönlichen Geschmacks...

DAS PUZZLE

Der erste FX des Cracktros ist daher die progressive Montage eines
320 x 256 Bildes in 5 Bitebenen aus quadratischen Elementen. Ein Quadrat kann
eine mehrere variable Seite von 16 - 16, 32 und 64 Pixeln haben. Es betritt den
Bildschirm durch eine der vier Kanten von außen. Es bewegt sich horizontal -
wenn es vom linken oder rechten Rand kommt - oder vertikal - wenn es von der
oberen oder unteren Kante kommt - mit einer sauberen Geschwindigkeit. Es
stoppt, wenn es die Position erreicht hat, an der es im Bild ausgeschnitten
wurde.

Hier galt es, mehrere "Herausforderungen" zu meistern:
Verschieben Sie die maximale Anzahl von Quadraten gleichzeitig in einen
Rahmen (dh: 1/50Heit des zweiten);
Lassen Sie die Quadrate immer von allen Seiten kommen.
Die Lösung des ersten Problems liegt definitiv in der Ausbeutung von BOBs.

Tatsächlich:
Sprites sind ungeeignet. Erstens, wie hier erklärt, sind sie wie Hobbits, das
heißt, praktisch und bunt, aber klein und wenige in der Anzahl. Dann und vor
allem hat das zu komponierende Bild 5 Bitebenen, während die Sprites
bestenfalls kombiniert werden können, um ein Objekt in 4 Bitebenen zu
komponieren.
Die CPU ist nicht besser. Erstens ist seine Macht zu begrenzt, um es dem
Blitter vorzuziehen, wenn es um die Anzeige auf 5-Bitebenen geht. Selbst wenn
es möglich ist, CPU und Blitter zu kombinieren, wäre es schrecklich
kompliziert, das Display zu parallelisieren, da es sicher sein kann, wenn sich
das in der CPU angezeigte Quadrat und das im Blitter angezeigte nicht
überlappen.
Bei den Quadraten handelt es sich also um BOBs, also auf den Blitter kopierte
Datenblöcke, die hier ausführlich dargestellt werden. Die verwendeten Routinen
sind _bobDrawBOB und _bobClearBOBFast, berücksichtigt in bob.s. Diese Routinen
werden mit einem Luxus an Details kommentiert, bis zu dem Punkt, dass es bald
mehr Kommentarzeilen als Code in dieser Datei gibt. Wenn Sie nichts verstehen,
nachdem Sie zuerst auf den Artikel verwiesen haben, dann tut es mir leid, aber
die Programmierung der Amiga-Hardware ist möglicherweise nicht für Sie.
Betrachten Sie Keramik (Atari STF) oder Makramee (Atari STE)?
Zur Anzeige von BOBs gibt es nichts mehr zu sagen. Beachten Sie nur, dass ein
BOB nicht beschnitten ist, was bedeutet, dass er, obwohl er teilweise sichtbar
ist, weil er von außen durch eine Kante im Bild eintritt, vollständig in
Bitebenen gezeichnet wird. Letztere sind daher viel breiter als das
dargestellte Bild: Sie sind von einer Kante umgeben, deren Dicke der maximalen
Seite eines BOB entspricht.
Sicherlich ermöglicht das Clipping eines BOB es, die Anzeige zu beschleunigen -
das ist das eigentliche Interesse eines jeden Clippings. In einem Cracktro ist
es jedoch immer riskant, auf einen FX zurückzugreifen, dessen Berechnungszeit
variabel ist: Sie wissen nie, wann die Spitzenlast auftreten wird, was das
Risiko des Verpassens eines Frames vervielfacht - nicht die Ausführung der
Hauptschleife im Frame zu halten. Darüber hinaus erfordert der Clip das
Programmieren von Clipping, was in diesem Fall, in dem das Puzzle nicht der
Haupteffekt ist, Zeitverschwendung ist - wir gehen den Betrachter nicht
stundenlang in einer 3D-Welt spazieren.
Umgekehrt muss beachtet werden, dass kein Clipping Ressourcen verbraucht,
sondern in erster Linie Speicher. 5 Bitebenen in 320 x 256 belegen
51.200 Bytes, was bereits beträchtlich ist. Wenn Sie BOBs anzeigen möchten,
deren Seite 64 Pixel erreichen kann, müssen Bitebenen von 448 x 384 angegeben
werden, was 107.520 Bytes entspricht. Dieser Platz muss verdoppelt werden, da
es wichtig ist, im doppelten Puffer zu arbeiten, um ein Flackern zu vermeiden,
wie hier erläutert. In der Tat muss es sogar verdreifacht werden, weil es immer
noch notwendig ist, einen Puffer hinzuzufügen, der dem endgültigen Bild
entspricht, das zusammengesetzt wird, dh ein Bild, bei dem ein BOB ein für alle
Mal kopiert wird, wenn es sein Ziel erreicht - dieses Bild wird in den hinteren
Puffer kopiert, um es mit jeder Iteration zu löschen. Schließlich müssen wir
den Platz hinzufügen, der vom ursprünglichen Bild in 320 x 256 eingenommen
wird, wo die BOBs geschnitten werden. Gesamt: 373.760 Bytes. Mazette! Wie wir
sehen werden, war dies nicht ohne ein Downsizing...
Im Gegensatz zu ihrer Anzeige erfordert das Erscheinen von BOBs einige
Kommentare. Um zu verhindern, dass BOBs zu viel von einer bestimmten Seite zu
kommen scheinen, muss sichergestellt werden, dass sie zunächst ziemlich
gleichmäßig auf alle Startpositionen verteilt werden, die sie entlang der
verschiedenen Bildschirmränder einnehmen können. Diese Reflexion führte
zunächst zur Entwicklung eines Algorithmus, der eine solche Verteilung
sicherstellt und auch darauf abzielt, dass die BOBs einer Spalte, die einer
horizontalen Kante zugeordnet ist, entlang dieser Spalte gut verteilt sind -
das gleiche gilt für die BOBs einer Zeile, die einer vertikalen Kante
zugeordnet ist:

Das JavaScript-Tool zum Komponieren des Puzzles

Es ist nicht sinnvoll, auf die Details dieses Algorithmus einzugehen, weil...
es wurde nicht verwendet. Lektion Nummer eins, wie der Mandarin sagen würde:
Im Leben gibt es immer weniger Gutes, aber es ist teurer. Die Idee, jedes Mal,
wenn der Cracktro startet, eine Verteilung von BOBs zu generieren, ist nett,
hat aber zwei Nachteile. Zuallererst zwingt es dazu, diese Generation zu
programmieren, die langweilig ist, für den Programmierer zu sterben. Dann
und vor allem kann das Puzzle nur aus BOBs auf der gleichen Seite
zusammengesetzt werden, was für den Betrachter langweilig ist.
Aus diesem Grund wurde eine andere Lösung gewählt. Es besteht darin, ein wenig
Zeit damit zu verschwenden, das Puzzle basierend auf BOBs auf verschiedenen
Seiten manuell zusammenzustellen, bevor die Komposition als Daten exportiert
wird. Es gibt nur ein Puzzle, aber es ist sicherlich auf eine aufregendere
Weise für den Betrachter zum Nachdenken zusammengestellt.

Ein Makro in Excel wurde erstellt, um diese Arbeit zu erleichtern. Sie
analysiert eine Reihe von Formen, die von Hand hinzugefügt wurden, wobei sie
die Möglichkeit nutzt, die Formen auf dem Raster eines in Raster umgewandelten
Blattes auszurichten. Aus jeder Form leitet das Makro die Seite des
entsprechenden BOB aus den Abmessungen und den Rand des Bildes, über den dieses
BOB eingeben muss, aus der Farbe ab (dunkelrot für einen Eintrag vom linken
Rand, hellgrün für einen Eintrag von oben usw.). Schließlich assoziiert es dem
BOB einen Geschwindigkeitsvektor, der von der Kante abgeleitet wird, und weist
ihm eine zufällige Norm zwischen zwei Terminals zu. Was will man mehr? Das ist
die Nummer zwei Lektion: Nur weil man das Meer mit einem Löffel leeren muss,
heißt das nicht, dass man den Bagger nebenan ignorieren muss.

Das Excel-Tool zum Komponieren von Puzzles

Die Daten in einem vom Makro generierten BOB sehen folgendermaßen aus:
	DC.W 16, 16, 64, 0, 352, 32, 352, 32, 96, 32, -7, 0, 0
Es ist eine Struktur, die wie folgt lautet:
0	Breite (Vielfaches von 16)
2	Höhe
4	Koordinaten im Bild, in dem das BOB ausgeschnitten wird (x, y)
8	Koordinaten im vorderen Puffer (x, y)
12	Koordinaten im hinteren Puffer (x, y)
16	Ankunftskoordinaten (x, y)
20	Geschwindigkeit (x, y)
24	Zustand

Ein BOB kann die folgenden Zustände annehmen:
PZ_STATE_TODISPLAY	Das BOB sollte einfach im hinteren Puffer angezeigt werden
PZ_STATE_TOMOVE		Das BOB muss aus dem hinteren Puffer gelöscht, verschoben
					und erneut im hinteren Puffer angezeigt werden.
PZ_STATE_TOREMOVE	Sobald der BOB an seinem Bestimmungsort angekommen ist,
					muss er in das endgültige Bild kopiert werden.
PZ_STATE_TOIGNORE	Die BOB sollte während dieser Hauptschleife nicht
					berücksichtigt werden.

Die Existenz eines Zustands PZ_STATE_TODISPLAY, bei dem es sich um den
Anfangszustand eines BOB handelt, ist gerechtfertigt, da es notwendig ist, ein
BOB zum ersten Mal anzuzeigen, bevor mit dem Verschieben begonnen wird, und es
dann in einer Schleife anzuzeigen.
Die Hauptschleife durchquert die Bob PZ_NB_DISPLAYEDBOBS liste und steuert
die Anzeige von BOBs innerhalb der maximalen Anzahl von BOBs, die gleichzeitig
bewegt werden können. Beim Amiga 500 ist dieses Maximum auf 12 eingestellt,
die Seite eines BOB kann 16 oder 32 Pixel betragen. Dies ergab sich aus einem
Test der gewählten Zusammensetzung.
Es wäre möglich gewesen, größere BOBs zu verwenden. 64-Pixel-seitige BOBs
erzeugen jedoch nicht immer den besten Effekt. In der Tat, für den Betrachter,
scheinen sie sich seltsamerweise nicht im Bild zu bewegen, während sie sich im
Bild bewegen! Sie können es testen, indem Sie die für A1200 vorgesehene Version
zusammenbauen - die A500-Version verwendet keine so großen BOBs. Ändern Sie
dazu die Konstante A500 in 0 und die Konstante DEBUG in 1:
Testen Sie das Puzzle auf dem A1200, um zu überprüfen, ob alles in den Rahmen
passt

ROTOZOOM

Rotozoom hat die Besonderheit, Copper intensiv zu nutzen. Dies liegt daran,
dass das rotierende Bild durch eine Reihe von MOVE erzeugt wird, die die
Farbe 0 alle 8 LowRes-Pixel einer Bildschirmzeile ändern. Das Manöver, das mit
jeder Zeile auf 8 Zeilen wiederholt wird, ermöglicht es, insgesamt ein Bild
zu erzeugen, dessen Auflösung 40 x 32 "Pixel" beträgt - Quadrate von
8 x 8 Pixeln.
Grundsätzlich verwendete der Rotozoom Farbe 1 und nicht Farbe 0 - die Rückkehr
zu Farbe 0 wird im Teil über die Codierung von erzählt. Die Idee war nicht so
sehr, das Verschleieren der Ränder des Bildschirms, die in Farbe 0 angezeigt
werden, zu vermeiden, sondern die Bitebene 1 zu weben, um den "Big Pixel" -
Effekt zu begrenzen. Das Ergebnis schien jedoch zu düster. Darüber hinaus wäre
es notwendig gewesen, müde zu werden, um die Auswirkungen des Zauderns auf die
Definition der Palette zu berücksichtigen, damit das Logo und der Text nicht
leiden. Zu Ihrer Information, hier ist, wie es ausgesehen hätte:

Dithering von Copperbildern

Aber warum nicht stattdessen versuchen, eine Linie aus zwei von 4 Pixel LowRes
zu verschieben, indem Sie auf der horizontalen Position des WAIT am Anfang
der Linie spielen, wird der aufmerksame Leser fragen?
Sehr geehrter Leser, ich stelle fest, dass Sie diesen Artikel gelesen haben,
der erklärt, wie man ein solches Bild am Copper erzeugt. Sie vergessen jedoch
zu beachten, dass diese Technik vorgestellt wird, bevor Sie diejenige erwähnen,
die die Copperschleifen ausnutzt. Eine Schleife am Copper auf 8 Linien erlaubt
es jedoch nur, streng die gleiche Sequenz von 40 MOVE zu wiederholen, wodurch
das Manöver verboten wird. Und der Bildschirm, den Sie im Cracktro betrachten
können, wird vollständig mit Copperschleifen hergestellt ...
Mit List wird derselbe Leser darauf hinweisen, dass der soeben zitierte Artikel
mit einem Cliffhanger endete, der eine Erwartung weckte, die umso 
beunruhigender war, als der zweite Teil des Artikels nie veröffentlicht wurde.
War es nicht eine Frage der Überraschung, die man schlecht verheißen konnte?
In der Tat, lieber Leser, die Verwendung von Copperschleifen zur Wiederholung
des 40 MOVE erzeugt dort diesen Effekt:

Glitches zur Herstellung eines 40 x 32-Bildschirms mit Copperschleifen

"Es ist nicht schmutzig", wie der andere sagte, aber es ist nicht schön, werden
wir hinzufügen. Ohne den zweiten Teil des Artikels zu verderben, der eines
Tages herauskommen wird - es ist ein noch schmerzhafteres Thema zu erklären als
die hier behandelte horizontale Zoom-Hardware ... -, lerne daher, lieber
Leser, dass es eine Lösung gibt, und dass sie im vorliegenden Cracktro genau
ausgenutzt wird, um den von diesem Rotozoom verwendeten Copperbildschirm
anzuzeigen. Es wird nicht mehr gesagt, aber es ist leicht zu erraten, wenn
man die Reihe von INSTRUCTIONS WAIT in rzWAITs und SKIP in rzSKIPs liest, dass
es notwendig ist, die Schleifen zu schneiden, die sonst strittige Zeilen
enthalten würden.
Reflexion getan, Vorbeugen ist besser als heilen. Ich werde nicht das Risiko
eingehen, den zweiten Teil des Artikels nie zu schreiben, und dass ich eines
Tages meine Festplatte vergrabe - oder dass sie mit mir begraben ist -
während sie Code enthält, der von anderen verwendet werden könnte, um die
Amiga-Szene zum Leben zu erwecken. Klicken Sie hier, um copperScreen.s 
herunterzuladen, ein Programm, mit dem Sie einen Copperbildschirm aus jeder
Höhe in jede vertikale Position generieren können.
Die Verwendung von Copperschleifen begrenzt die Zeit, die zum Ändern des
Bildes erforderlich ist, indem die Werte geändert werden, die MOVE in das
COLOR01-Register schreibt. In der Tat reicht es aus, eine Reihe von 40 MOVE
zu modifizieren, um das Erscheinungsbild von 8 Zeilen auf dem Bildschirm 
der einer Zeile von "Pixeln" zu ändern, anstatt 8 zu modifizieren. Dies ist
es einfach, was es ermöglicht, einen Vollbild-Rotozoom zu erreichen, der
in den Rahmen passt.
Der kleine Bonus ist, dass das Copperbild eine echte Farbe hat, in dem Sinne,
dass es keine Palette hat, wobei jedes "Pixel" seine eigene Farbe annimmt.
Diese Möglichkeit wird im Cracktro jedoch nicht ausgenutzt, denn die Idee war,
das schöne Bild vor dem Rotozoomer zu zeigen. Aber um das Bild zu zeigen,
musste es als Bild angezeigt werden, also nur in 32 Farben.
Abgesehen vom Copper-Display ist der Rotozoom an sich recht einfach. Da es
jedes Mal, wenn es darum geht, ein Bild zu verzerren, ist der Fehler, den man
nicht machen sollte, vom Bild aus zu beginnen, um zum Bildschirm zu gehen -
berechnen Sie die Koordinaten des Pixels auf dem Bildschirm von denen eines
Pixels des Bildes -, während es notwendig ist, das Gegenteil zu tun. In diesem
Fall ist es daher notwendig, den Bildschirm im Bild zu drehen und zu zoomen,
damit sich das Bild drehen und zoomen kann.
So werden die Koordinaten der Eckpunkte einer Darstellung des Bildschirms im
Bild durch Rotation und Zoom berechnet, und dann wird jede Zeile des
Bildschirms gleichzeitig auf dem Bildschirm gescannt - die Reihe von 40 MOVE,
die die Linie der "Pixel" bilden - und in dieser Darstellung. Jedem "Pixel"
wird somit ein Pixel des Bildes zugeordnet, dessen Farbe von dem MOVE
aufgenommen wird, aus dem sich das "Pixel" ergibt.

Zerlegung von rotozoom

Mit Ausnahme der Multiplikationen, die erforderlich sind, um Bilder von drei
Punkten pro Drehung zu berechnen, beinhalten Berechnungen nur Additionen und
Subtraktionen, um Zeit zu sparen. Möglich wird dies durch die verallgemeinerte
Verwendung des Lucas-Algorithmus, der es sehr einfach macht, eine Größe nach
einer anderen in einem bestimmten Verhältnis zu entwickeln, wie es bei der
Ordinate als Funktion der Abszisse der Fall ist, wenn eine gerade Linie einer
bestimmten Steigung gezeichnet wird.
Um dxM zu berechnen1 und dyM1 basierend auf dxM0 und dyM0wird der
Lucas-Algorithmus verwendet, um Werte in den Verhältnissen zwischen:

screenDX und oben;
topDX und topDY;
screenDY und links;
leftDX und leftDY.

Seien Sie vorsichtig, denn der Algorithmus wird nicht auf die gleiche Weise
verwendet, um eine Linie zwischen (x0, y0) und (x1, y1) zu ziehen, als einen
Wert zwischen [v0, v1] in n Schritten zu interpolieren. Klicken Sie hier, um
die Quelle des Liniendiagramms und der Interpolation in JavaScript zu testen
und anzuzeigen.
Anstatt Seiten im Kontext dieses Artikels zu füllen, schien es einfacher zu
sein, den Rotozoom-Algorithmus auf JavaScript zu portieren, um die nächsten
Vorberechnungen durchzuführen. Klicken Sie hier, um die Quelle zu testen und
anzuzeigen, um sie zu verstehen. Auch dies ist eine Portierung des Algorithmus.
Es ist klar, dass, wenn es notwendig wäre, den FX in JavaScript zu realisieren,
es ein ganz anderer Algorithmus ist, der mobilisiert würde, um ein bestimmtes
Leistungsniveau zu erreichen - oder sogar, einfach eine Funktion der
Canvas 2D API oder WebGL aufzurufen.

Portieren des rotozoom-Algorithmus auf JavaScript

Grob gesagt, wie das Diagramm zuvor vermuten lässt, wird der Copperbildschirm
von oben nach unten und von links nach rechts durchquert. Dieser Fortschritt
erfolgt gleichzeitig in dem Rechteck, das dem Bild dieses Bildschirms im
darzustellenden Bild entspricht. So ist es möglich, ein "Pixel" des
Bildschirms mit Copper mit einem Pixel des Bildes zu assoziieren.

DER DRUCKER

Der Drucker sieht nach nichts aus, aber er ist fähig. Tatsächlich ist es der FX
des Cracktros, dessen Programmierung am längsten dauerte. Wie was, 
Lektionsnummer: Der Teufel steckt immer im Detail.
Um zu vermeiden, dass dieser Artikel überladen wird, klicken Sie hier, um auf
eine Portierung des Algorithmus in JavaScript zuzugreifen und so die Quelle zu
testen und zu visualisieren, um Folgendes zu verstehen:

Entwicklung des Druckeralgorithmus in JavaScript

Im Gegensatz zur Portierung des Rotozoom ist diese Portierung nicht wirklich
eine. Die Komplexität des Algorithmus erforderte den entgegengesetzten Ansatz,
nämlich zuerst in JavaScript zu implementieren, dann auf Assembler 68000 zu
portieren:
Portieren des Druckeralgorithmus zum Assembler 68000

Daher die Lektion numero cuatro: Um ein Pestacle zu produzieren, muss man
hinter den Kulissen genauso arbeiten wie auf der Bühne.
Was den Algorithmus komplex macht, ist die Vielzahl von Sonderzeichen
(Leerzeichen, Zeilenende, Seitenende) und Verzögerungen (zwischen zwei
Zeichen, zwischen zwei Seiten) sowie die Artikulation des Seitendruckers mit
einem Zeichendrucker, die variieren kann. In der Tat hat der Drucker den
Vorteil, dass er leicht konfiguriert werden kann, um eine bestimmte Routine
der Animation der Anzeige eines Charakters zu verwenden. Wenn Sie einen Blick
auf advancedPrinter.s werfen, werden Sie feststellen, dass nicht weniger als
sieben Gewehrdrucker verfügbar sind: Basic, Roller, Raiser, Animator, Shifter,
Interwiner und Assembler.

Die Programmierung des Druckers bot die Möglichkeit, die Art und Weise, wie
Code für eine einfache Wiederverwendung berücksichtigt wird, zu verfeinern,
nicht ohne die Praxis in Richtung der Verwendung von Datenstrukturen anstelle
von Registern zu driften, um Parameter zu übergeben und den Zustand
beizubehalten - kurz gesagt, der Code zieht in Richtung des kompilierten C.
Um den Drucker so zu verwenden, wie es im Hauptprogramm des Cracktros der Fall
ist, genügt es, mit der Quelldatei zu beginnen:

	INCLUDE "SOURCES:common/advancedPrinter.s"

Dann ist es notwendig, eine Konstante zu definieren, die es ermöglicht, die
Baugruppe auf den einzigen Code des verwendeten Druckers zu beschränken, dh auf
den Code des Druckers von Seiten in allen Fällen und auf den Drucker von 
Zeichen, die im jeweiligen Fall speziell angegeben sind. Diese Lösung der
Teilmontage wurde der der Gesamtmontage vorgezogen, um den vom Druckercode
belegten Speicherplatz auf den einzigen tatsächlich verwendeten Code zu
beschränken:

PRT_PRINTER=5

Der Drucker kann dann gestartet werden, indem zunächst eine
Initialisierungsroutine aufgerufen wird. Letzteres benötigt eine gute Anzahl
von Parametern, so dass der Drucker in sehr unterschiedlichen
Videokonfigurationen arbeiten kann. Die systematische Definition von
Konstanten OFFSET_PRINTERSETUP_* ermöglicht es, sich besser mit ihnen zu
identifizieren:
	
	lea prtSetupData,a0
	move.l rzFrontBuffer,d0
	addi.l #((RZ_TEXTBITPLANE-1)+RZ_TEXTY*RZ_DISPLAY_DEPTH)*(DISPLAY_DX>>3),d0
	move.l d0,OFFSET_PRINTERSETUP_BITPLANE(a0)
	move.w #DISPLAY_DX>>3,OFFSET_PRINTERSETUP_BITPLANEWIDTH(a0)
	move.w #(RZ_DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),OFFSET_PRINTERSETUP_BITPLANEMODULO(a0)
	move.w #RZ_TEXTDY,OFFSET_PRINTERSETUP_BITPLANEHEIGHT(a0)
	move.b #RZ_TEXTCHARDELAY,OFFSET_PRINTERSETUP_CHARDELAY(a0)
	move.w #RZ_TEXTPAGEDELAY,OFFSET_PRINTERSETUP_PAGEDELAY(a0)
	move.l #font,OFFSET_PRINTERSETUP_FONT(a0)
	move.l #printerText,OFFSET_PRINTERSETUP_TEXT(a0)
	bsr _prtSetup

Rufen Sie in der Hauptschleife einfach eine Routine durch Iteration auf:
	
	bsr _prtStep

Ähnlich am Ende der Hauptschleife, um die vom Drucker beanspruchten Ressourcen
freizugeben:

	bsr _prtEnd

Es ist schwer, es einfacher zu machen. Beachten Sie, dass die für die
Initialisierung verwendete Datenstruktur nicht im laufenden Betrieb in einer
Datendeklaration aufgefüllt werden kann, um die Anzahl der Druckeranweisungen
in dem Programm, das sie verwendet, weiter zu begrenzen.

DAS HAUPTPROGRAMM

Mit Ausnahme der Initialisierung - Speicherzuweisungen und Hardwareübernahme -
und der Finalisierung - Freigabe des zugewiesenen Speichers und der
Systemwiederherstellung - enthält das Hauptprogramm die Reihenfolge der
Schleifen, die den aufeinanderfolgenden FX des Cracktro entsprechen: 
Puzzle, Fade, Rotozoom.
Die Schwierigkeit in einer Produktion, die FX verkettet, besteht darin, dass
normalerweise nicht alle FX auf einmal initialisiert werden können und ihre
Ausführung einfach verkettet werden kann. Es ist notwendig, Übergänge zu
programmieren, um die gerade beendeten FX abzuschließen - Speicher
freizugeben - und diejenige zu initialisieren, die starten wird - Speicher
zuweisen, die Konfiguration der Hardware zu ändern.
Grundsätzlich ist ein Übergang besonders schmerzhaft zu programmieren, da es
sich um eine Form der Initialisierung handelt, die live mit begrenzten
Ressourcen stattfindet. In der Tat, ist das Prinzip eines FX nicht an die
Grenzen zu gehen, indem alle verfügbaren Ressourcen mobilisiert werden? Um 
von einem FX zum anderen zu wechseln, hat der Encoder daher alle Chancen,
trocken zu enden: mehr Speicher, mehr CPU-Zyklen. Infolgedessen muss es für
einen Rückgang des Regimes des ersten FX und einen Anstieg der Geschwindigkeit
des nächsten vorsorgen. Mit anderen Worten, es reicht nicht aus, einen FX
programmiert zu haben, der mit voller Geschwindigkeit läuft; Es ist immer noch
notwendig, es so eingestellt zu haben, dass es jede Diät hält.
Unter diesen Bedingungen ist die Programmierung eines Übergangs noch 
schmerzhafter, wenn FX ursprünglich nicht so konzipiert wurden, dass sie
aufeinander folgen. Sie müssen nicht nur den FX-Code erneut eingeben, um ihn
konfigurierbar zu machen, sondern Sie müssen auch die Initialisierungen und
Finalisierungen neu schreiben, indem Sie den Klebstoff zwischen ihnen
herstellen. Dies ist die Nummer vijf-Lektion: 
Entwerfen Sie immer ein stückweises Puzzle oder planen Sie, dass das Teil
von dem Moment an, in dem es entworfen wird, in das Puzzle passen muss.
In diesem Fall ist ein Übergang notwendig, um Speicher freizugeben, da es 
unmöglich wäre, alles, was das Puzzle und der Rotozoom benötigen, auf einmal
zuzuweisen und sehr unterschiedliche Copperlisten zu verketten. Um zu
vermeiden, dass es zu brutal ist, war es am besten, dem Weiß der Palette des
Bildes, das am Ende des Puzzles zusammengestellt wurde, eine Überblendung
hinzuzufügen, bevor der Rotozoom angezeigt wurde. Zweifellos wäre dann eine
umgekehrte Überblendung - von Weiß auf die Palette des Rotozoom - willkommen
gewesen, aber wie bereits erklärt, hat der Rotozoom keine Palette, wobei jedes
"Pixel" in echter Farbe angezeigt wird; Es wäre daher eine Wunde gewesen,
ein solches Fade auszuarbeiten.

CODIERUNG VON

Die Entstehung dieses Cracktros reicht weit zurück. Nachdem ich im Sommer 2017
im Rahmen der Veröffentlichung von Artikeln über meine Cracktros für Programme!
- online auf dieser Seite hier und da - zu den Freuden des Programmierens der
Amiga-Hardware als Assembler zurückgekehrt war, beschloss ich, mich in der
Programmierung verschiedener und abwechslungsreicher FX, einschließlich
Rotozoom, neu zu starten. Es war einer der letzten FX, die ich ausprobiert 
habe, bevor ich den Amiga in den späten 1990er Jahren fallen ließ. Eine
Möglichkeit, sich wieder mit dem Thread zu verbinden, also.
Grundsätzlich ist meine Idee, eine Demo zu produzieren. Es scheint mir jedoch
schnell, dass die Arbeit, die dies für Übergänge erfordern würde,
beträchtlich wäre - letztere müssten umso mehr gepflegt werden, da die FX nicht
sehr weit gehen würden. Es ist also endlich in Richtung der Produktion eines
Cracktros, den ich wende. Die Gelegenheit wurde mir während eines Austauschs
von Galahad gegeben, der mir anbot, einen für den Hafen auf Amiga des Spiels
Starquake zu machen, das er fertigstellte. Los geht es.
Um einen Cracktro zu produzieren, benötigen Sie mindestens einen Programmierer
und einen Musiker, und ein Grafikdesigner kann helfen. In der Vergangenheit
habe ich nur einmal die Dienste eines Grafikdesigners in Anspruch genommen,
um diesen Cracktro für Skid Row zu produzieren.
Für den Musiker muss ich nicht sehr weit suchen. In der Tat ist Monty nicht
verfügbar, aber Galahad beauftragt Notorious / Scoopex, der schnell ein Modul
liefert.
Für den Grafikdesigner stellen sich die Dinge als viel komplizierter heraus.
Als ich Monty erneut kontaktieren wollte, fand ich heraus, dass er zusammen mit
Crown / Cryptoburners und Asle die bemerkenswerte Website Amiga Music 
Preservation (AMP for the intimate) mitbegründet hat. Die letzten beiden
erlauben es mir, mit Alien / Paradox in Kontakt zu treten, was mir ein schönes
Logo produziert.
Also beginne ich mit der Programmierung eines Cracktros, der ein kleines System
von Partikeln ausnutzt. Sehr schnell stellt sich heraus, dass die Partikel nur
multipliziert werden können, um einen interessanten FX auf einem A1200 zu 
erzeugen. Es ist also ein AGA-Cracktro, den ich an Galahad liefere. Es wurde
an diesem Datum nicht veröffentlicht - auf jeden Fall werde ich es wegen der
"Entdeckung", die später erwähnt wird, überarbeiten müssen - aber hier eine
Übersicht:
Vorschau auf Scoopex "ONE" (Version nicht "zyklusgenau")

Galahad bestätigt den Empfang, gibt aber an, dass es kein AGA-Spiel gibt, das
bald erscheinen soll. Also hält er es unter dem Ellbogen und sagt mir, dass
Starquake für einen A500 gedacht ist, ich kann immer einen anderen für OCS
machen. Macht nichts, also los geht's wieder.
Ich gehe zurück auf die Suche nach einem Musiker und einem Grafikdesigner. Zum
ersten Mal haben mich Crown und Asle mit ihrem Sidekick Curt Cool / Depth in 
Kontakt gebracht. Für den Grafikdesigner, der nicht mehr in der Lage ist, Alien
zu erreichen, greife ich auf die einzige Lösung zurück, die mir noch bleibt,
einen Anruf bei den Leuten auf der Wanted-Seite der Bühne. Es ist ein Schwert
im Wasser. Da hat Notorious mich mit Sim1 / Wanted Team in Kontakt gebracht.
Nachdem Sim1 die Idee aufgedeckt wurde, dass dieser Cracktro eine Hommage an 
Grafikdesigner sein würde - der erste war als Hommage an Programmierer gedacht
- hat letzterer die Idee, die Grafiken von Deluxe Paint II zu übernehmen,
nämlich das berühmte Tutanchamun-Kochen, das von Avril Harrison entworfen
wurde. Tolle Idee, sagte ich ihm, und er fing an zu zeichnen, während ich
anfing zu programmieren.
Ein Faktor, den ich nur schwer integrieren konnte, ist, dass diejenigen, die
immer noch an der Amiga-Szene teilnehmen, das nicht nur tun müssen. Darüber
hinaus können sie ziemlich akribisch sein, was die Zeit zur Herstellung eines
Cracktros weiter verlängert. Aber Sim1 ist sehr beschäftigt und akribisch.
Mitte September, als Galahad mir mitteilt, dass es Zeit ist zu schließen,
weil er Starquakes Diskette an die Duplizierung schicken muss, habe ich
die Programmierung des Cracktros beendet, Curt Cool hat das Komponieren des
Moduls abgeschlossen, aber Sim1 hat seine Version von Tutanchamun immer noch
nicht fertiggestellt.
Es ist ein Wochenende. Ich schreibe in einer Katastrophe an Ramon B5 / Desire,
der nach der Veröffentlichung meines Aufrufs bekannt wurde, mir anzubieten,
für Desire zu produzieren, und versicherte, dass es kein Problem in ihm gab,
einen Musiker und einen Grafikdesigner zu finden, die alles, was man will,
rechtzeitig produzieren. Ramon B5 gibt den Ball an Alien weiter, mit dem ich
wieder in Kontakt komme. Ein paar Stunden später - ja, nur ein paar Stunden!
- Alien gibt mir ein schönes Bild, das er am nächsten Tag überarbeitet, um
mir eine endgültige Version zu liefern. Das Ganze erzeugt einen schönen Effekt:
Erste Version von Scoopex "TWO" (nicht zyklusgenau)

Freude! Alles ist fertig und ich kann rechtzeitig ein Archiv an Galahad 
schicken. Der einzige schwarze Punkt ist, dass ich Sim1 mitteilen muss, dass
seine Arbeit nicht beibehalten wird, was immer peinlich ist, denn selbst wenn
sie nicht abgeschlossen ist, ist sie nicht weniger weit fortgeschritten -
beim letzten Mal fehlte nur seine Barbichette beim King Tut.
Ein paar Tage später bestätigte Galahad den Empfang, argumentierte aber, dass
das Intro auf einer "A500 512k" nicht funktionierte. Wie das, ein "A500 512k"?
Sollte nicht jeder A500, der diesen Namen verdient, seinen 512 Kb Chip und eine
512 Kb Erweiterung von Fast haben? Nun, nein, nicht im Fall des Remakes von
Starquake, das entschieden Wurzeln sein will. Galahad entschuldigt sich dafür,
dass ich vergessen habe, es zu erwähnen, also gehe ich in einer Katastrophe
wieder zur Arbeit.
Nach verschiedenen Berechnungen zur Auswertung des benötigten Speichers stellt
sich heraus, dass es keine anderen Lösungen als Downsizing gibt.
Aus dem Gedächtnis:
Es ist notwendig, die maximale Seite der BOBs von 64 auf 32 Pixel zu
reduzieren, um den Rand um die drei Puffer des Puzzles zu reduzieren;
Die Größe des Teils des verCopperten Bildes muss von 320 x 256 auf 200 x 200
reduziert werden.
Das erste Downsizing stört nicht allzu sehr, denn die BOBs von 64 Pixeln Seite
waren keine Legion im Puzzle. In der Tat ist es nicht noch schlimmer, weil ich
festgestellt habe, dass sie durch das Bewegen sogar im Rahmen den Eindruck
erweckten, sich nicht im Rahmen zu bewegen. Das zweite Downsizing ist
problematischer, da es zu einer Zoombeschränkung führt. Aber hey, es geht
vorbei. Also liefere ich in Eile an Galahad eine neue Version, die sicherlich
auf einem A500 mit nur 512 KB Chip funktioniert.
Ein paar Wochen später - nach dem Ansturm der vorherigen Ereignisse, ich gebe
zu, dass ich die Zeit etwas lang finde - signalisiert mir Galahad wieder. Er
erklärt mir, dass der Cracktro ihm eine schwere Zeit bereitet hat. Sicherlich!
Um es auf die Diskette zu bringen, musste er einfach das Trackloading neu
schreiben, um Einheiten mit feinerer Granularität zu adressieren: Sektoren
anstelle von Tracks. Außerdem musste er dafür sorgen, dass der Code nach dem
Auspacken verschoben wurde. Auf diesem sendet es die Diskette an Photon / 
Scoopex für letzte Tests, bevor die Duplizierung beginnt.
Ein paar Tage später eine E-Mail von Photon, die überrascht ist, dass sie
manchmal während des Rotozooms "einfriert". "Einfrieren"? Kein Zweifel, ich 
könnte feststellen, dass dieses #@! Der Spieler verpasst manchmal eine
Handlung, aber selbst wenn es bedauerlich ist, fand ich es nicht so peinlich,
nach einer Lösung zu suchen - ich hatte genug Probleme mit meinem Code, um 
danach in dem anderer zu suchen, ich sage mir, dass ich denke, sicherlich
falsch, dass das Problem nicht von mir kommt.
Ich bitte Photon daher, zu klären, was es mit "einfrieren" meint und mir die
Version zu schicken, die es hat. Ich teste: nicht mehr als das, was mir schon
aufgefallen war. Nach einem Austausch sagt er mir, dass ich, wenn ich WinUAE
verwende, gut daran täte, die zyklusgenaue (vollständige) Option zu aktivieren.
Die Option was? DIE OPTION WAS? Im Ernst, ist das ein Sketch? Wie der andere
muss ich sagen "Oh der Knödel!"?
Ich gebe zu, dass ich mich in dem Moment von einer Welle der Entmutigung 
überwältigt fühlte. Warum dachten die ansonsten brillanten Schöpfer von WinUAE,
dass es standardmäßig nicht nützlich wäre, eine möglichst treue Emulation 
anzubieten, bis zu dem Punkt, dass insbesondere die CPU nicht die Zyklen 
findet, die sie braucht, wenn sie von der DMA monopolisiert werden, weiß ich
nicht. Schließlich bleibt die Tatsache, dass ich, seit ich wieder angefangen
hatte, auf dem Amiga zu programmieren, die Option nicht bemerkt hatte, und dass
ich daher viel schneller als in der Realität für einen Amiga programmiert
hatte. Von dort aus die Lektion Nummer sześć: Lesen Sie immer das
Kleingedruckte.
Was ist zu tun? Der Rotozoom ist offensichtlich sehr weit davon entfernt,
im Rahmen zu halten. Sofort vermute ich, dass die Lösung darin besteht, die
Anzahl der Bitplanes zu reduzieren, um DMA-belegte Zyklen freizugeben, die
die CPU verwenden könnte. Nach ein paar Stunden am nächsten Tag produziere ich
in der Nacht eine neue Version des Rotozooms, die in den Rahmen passt,
Stimmungsschwankungen in der Nähe des Spielers. Dafür musste ich die Idee 
aufgeben, dass der Rotozoom Vollbild sein würde. Ich habe die Copperliste
geändert, um einen MOVE auf BPLCON0 einzuführen, der die Anzahl der Bitplanes
von 4 auf 1 nach der Logobasis reduziert. Das Ergebnis ist wie folgt:

Zweite zyklusgenaue Version von Scoopex "TWO" (zyklusgenau)

Es vergeht, aber am nächsten Morgen finde ich es überhaupt nicht herrlich.
Grundsätzlich sollte der Cracktro die Möglichkeit eliminieren, Copperschleifen
zu verwenden, um einen ganzen MOVE-basierten Bildschirm zu manipulieren.
Durch die Reduzierung der Oberfläche dieses Bildschirms scheint es mir, dass
ich daher den Punkt verfehle. Ich nutze das, was Photon mir noch nicht
geantwortet hat, um am Morgen nach einer anderen Lösung zu suchen.
Nach verschiedenen Tests stellt sich heraus, dass die einzige Lösung für den
Rotozoom, um in den Rahmen zu passen, leider darin besteht, die Anzahl der
Bitplanes auf... nur eine. Diese Bitebene muss für das Logo und den Text
verwendet werden. Der Rotozoom sollte nicht mehr die Farbe 1, sondern die
Farbe 0 ändern.
Unter anderem führt die drastische Reduzierung der Anzahl der Bitplanes zum
Auswurf des prächtigen Logos von Alien, das daher für einen anderen Anlass
dienen wird. Im Katastrophenfall ersetze ich es durch einen "Scoopex", so 
wenig hässlich wie möglich. Ich produziere es in Eile mit dem großartigen 
Pro Motion NG, mit dem Sie glücklicherweise Text mit jeder Schriftart eingeben
können, einschließlich der Ravie, die mir ein weniger katastrophales Ergebnis
zu liefern scheint als die anderen. Das Ergebnis ist wie folgt:

Dritte Version von Scoopex "TWO" (zyklusgenau, aber kratzt)
Es ist die v7, und ich gebe zu, dass ich diesen Cracktro, geschweige denn
seinen Code, nicht einmal im Porträt mehr sehen kann. Ich schicke es an Photon
und Galahad, bitte den ersteren zu testen und warne ihn, dass er an diesem
Wochenende arbeiten wird, da ich den Code noch an mehreren Stellen geändert
habe. Übrigens frage ich ihn, ob er es nicht seltsam fand, dass sich der
Rotozoom nicht im Rahmen dreht. Er würde es nicht vermissen, dass er es nicht
wagte, es mir zu sagen... Wenn wir nicht nur gealtert sind, sondern auch
unsere Standards gesenkt haben, liegt das daran, dass alles in
Katzenschwänze gegangen ist.
Unnötig zu sagen, dass ich dabei den gesamten Code für Amiga, der auf dieser
Website zur Verfügung gestellt wird, in "zyklusgenauer" Konfiguration erneut
teste. Glücklicherweise entdecke ich keine Probleme, außer hier, wenn der
Stern auf der Rückseite der Sinusrolle hinzugefügt wird. Für Interessierte
habe ich das Problem behoben, indem ich auf verschiedene Optimierungen 
zurückgegriffen habe - eine Parallelisierung des Betriebs zum Blitter und zur
CPU für A1200; eine Animationsvorberechnung für A500 - und aktualisierte 
den Artikel. Schließlich ist die Ehre ausgeschlossen!
Aber es ist noch nicht vorbei. Ohne Neuigkeiten über den Moment von Galahad
und Photon beschließe ich, Stormtrooper, dem ehemaligen Kameraden der
Amiga-Ära, den Cracktro zum Testen zu geben. Er erzählt mir, dass der 
Rotozoom manchmal einen Rahmen verpasst und dass dies die Musik beeinflusst,
die "kratzt". Kurz gesagt, ich kann das Problem, das ich unter den Teppich
kehren wollte, nicht länger ignorieren. Ich erinnere mich dann an einen
Vorschlag von Photon, in dem erwähnt wurde, dass ich auf das Ende des 
rames warte, während ich darauf warte, dass das Raster eine bestimmte
vertikale Position erreicht. Flöte! Es ist in der Tat ein Überbleibsel
von Tests. Ich modifiziere den Code, um zu warten, bis das Raster diese
vertikale Position erreicht oder überschreitet: keine verpassten Frames
mehr, also keine "Kratzer" mehr zu Hause.
Dies ist die v8, die ich an Galahad und Photon schicke. Wenn sie ihre
Briefkästen öffnen, werden sie mich hassen, das ist sicher. Aber das ist
das geringste Problem: Versteht man, dass der Albtraum vorbei ist? Die
Tatsache, dass weder Galahad noch Photon mir gesagt haben, dass die erste
Version des Rotzooms eindeutig nicht im Bild lief, macht mir keine Sorgen. 
Testen wir dasselbe? Um ehrlich zu sein, wer hat an einem echten Amiga 
getestet? Ich sehe mich mit dem Problem der Qualias konfrontiert: Jemanden zu
fragen, ob der Cracktro im Rahmen läuft, ist wie ihn zu bitten, die Farbe Rot
zu beschreiben. Die einzige Lösung besteht darin, durch einen Vergleich 
vorzugehen. Ich packe mehrere Versionen von Scoopex "ONE" und Scoopex "TWO" auf
einem ADF, die erste Version jedes Cracktros hält notwendigerweise im Rahmen
- nur 50 Partikel in Scoopex "ONE", rotozoom beginnt erst nach dem Logo und
auf einer Bitebene in Scoopex "TWO".
Ich schicke die ADF an Crown und Asle und bitte sie, auf echtem Amiga zu
testen. Mangel an Schüssel: Sie haben keine zur Verfügung. Crown schickt mich
zurück zu Curt Cool, an den ich daher die ADF weiterleite. Gleichzeitig 
bestelle ich bei eBay ein Kit zum Übertragen von Dateien zwischen PC und
A1200 über eine SD-Karte, die in einen CF-Adapter gesteckt wurde, selbst in
eine PCMCIA-Karte gerutscht - es ist ein einfaches Leben! Denn in diesem
Moment beginne ich mich zu fragen, ob ich nicht mehr der einzige auf der
Erde bin, der noch einen A500 und einen A1200 in einwandfreiem Zustand hat.
Es ist wahr, dass in diesem Abenteuer die ganze Zeit ein wenig die Welt auf
den Kopf gestellt wird.

Die Authentizität von Emulator-Produktionen

In dieser Nachricht aus diesem Thread aus dem englischen Amiga Bord, berichtet
Galahad darüber, wie er Starquake trug. Insbesondere berichtet er von seiner
Enttäuschung:
Auf A1200 spielt es sich genau so, wie es sollte, aber es ist zu träge auf
A500, es liegt an der Art und Weise, wie die Konvertierung durchgeführt wird,
und ich dachte fälschlicherweise, dass die Action auf dem Bildschirm kein
großes Problem sein würde, aber es stellt sich heraus, dass ich falsch lag.
Nach den Reaktionen im Thread zu urteilen, ist der Empfang von Starquake jedoch
sehr günstig: Es stört offensichtlich niemanden, das Spiel auf einer
Konfiguration laufen zu lassen, die nicht diejenige ist, für die es
ursprünglich gedacht war - ein einfacher A500 mit 512 KB Chip. Das ist
überraschend. Starquake wurde also nicht von einem Publikum erwartet, das sich
auf der Suche nach wahrer Authentizität wieder mit der Vergangenheit in ihren
kleinsten Details verbinden wollte, oder anders ausgedrückt?

Ich für meinen Teil würde dazu neigen, zwei Erklärungen zu erwähnen:
Diejenigen, die immer noch echten Amiga verwenden, haben Konfigurationen, deren
Leistung die des Basis-A500 bei weitem übertrifft. Solange das Spiel auf ihrem
Computer läuft, läuft es mit der richtigen Geschwindigkeit, so dass sie nur
Feuer sehen. Tatsächlich sind sie noch weniger geneigt, etwas anderes zu sehen
als für sie, ein Amiga ist der Amiga, den sie derzeit benutzen - es ist ein
bisschen so, als hätten sie ihr Amiga-Alter noch nie gesehen, da es jeden Tag
unmerklich gealtert ist. Es würde ihnen nicht in den Sinn kommen, das Spiel auf
einem einfachen A500 auszuführen.
Diejenigen, die einen solchen Amiga nicht verwenden, greifen auf einen Emulator
zurück, der es sehr einfach macht, die Konfiguration zu ändern, um das Spiel
mit der richtigen Geschwindigkeit auszuführen. Aber diese Manipulation
erscheint ihnen umso weniger künstlich, als es etwas ist, an das sie sich vom
Emulator gewöhnt haben. In der Tat ist bekannt, dass die Emulation einiger
Spiele eine ganz bestimmte Konfiguration erfordert. Darüber hinaus wurden viele
Spiele im Laufe der Zeit gepatcht, um auf allen Konfigurationen zu laufen, so
dass es möglich geworden ist, einen Amiga zu emulieren, der leistungsfähiger
ist als ein Basis-A500, und sich daran zu halten. Kurz gesagt, auch hier ist
die Tendenz, nur Feuer zu sehen.
Aus diesen Gründen scheint sich der Begriff der Authentizität unter
Afficionados nicht auf Authentizität in dem Sinne zu beziehen, in dem der Laie
sie verstehen könnte. Auf jeden Fall waren die Einsätze vielleicht für sie
anderswo: Das Projekt erschien ihnen als das, Starquake nach Amiga zu portieren,
damit diejenigen, die es auf anderen Plattformen spielten, wieder in dieser
Madeleine von Proust beißen konnten, aber auf ihrem geliebten Fahrrad von
Commodore. Unter diesen Bedingungen wird die Tatsache, dass das Spiel auf einem
einfachen A500 nicht mit der richtigen Geschwindigkeit läuft, ihnen umso
nebensächlicher vorgekommen sein, als es ihnen wahrscheinlich entgangen sein
wird.
Dennoch zeugt der Kontrast zwischen der Enttäuschung, die Galahad erlebt hat,
und der Rezeption seines Spielports von der Variabilität des Begriffs der
Authentizität, wenn es darum geht, sich wieder mit der Computervergangenheit
zu verbinden. In einem Kontext, in dem niemand mehr die ursprüngliche Maschine
verwendet, neigt jeder dazu, danach zu urteilen, was es ihm ermöglicht,
Software- oder Hardware-Emulation zu sehen - ein Spiel für A500 auf A1200
auszuführen, es ist eine Form der Emulation -, auf die er zurückgreift.
Dies wirft eine Frage auf: Was ist eine "authentische" Emulation (*)? Wenn
derjenige, der sich durchsetzt, der der Mehrheit ist, dann müssen wir uns
bewusst sein, dass es sehr weit von der Nachahmung im engeren Sinne entfernt
sein kann, das heißt, in dem Sinne, dass das, was auf dem Bildschirm der
emulierenden Maschine erscheint, genau das wäre, was auf dem der emulierten
Maschine erscheinen würde. In der Tat ist dies immer wahrer, während
diejenigen, die nachahmen, immer weniger Bedenken haben, die emulierte 
Maschine aus ihren Kisten zu nehmen, oder sogar, dass sie nicht mehr die
Möglichkeit haben, oder sogar, dass sie sie nie besessen haben!
In der Tat könnten sie sogar enttäuscht sein, wenn sie ein Originalspiel auf
dem ursprünglichen Computer ausführen müssten. Es ist, dass in einigen Fällen
die Emulation über das Original hinausgeht. Dies gilt insbesondere für
langsame Spiele zu der Zeit, die beschleunigt werden, und / oder solche, deren
Bildqualität verbessert wird - wir denken an Spiele, die prozedurale Grafiken
nutzen, oder vor allem Spiele, die auf 3D-Grafiken basieren, wobei Spiele, die
auf Vektorgrafiken basieren, selten sind. Ein karikiertes Beispiel: The Legend
of Zelda: Ocarina of Time auf Nintendo 64 oder Emulator spielen. Der
Unterschied ist offensichtlich, sowohl in der Geschwindigkeit der Ausführung
als auch in der Finesse des Bildes, wie es hier zu sehen ist.
Umgekehrt, um das Thema in all seinen Facetten zu beleuchten, sollte beachtet
werden, dass Emulation weniger gut funktionieren kann als das Original. In
diesem äußerst interessanten Artikel berichtet der Autor, dass die
Grafikdesigner japanischer Videospielverlage damit beschäftigt waren, die
Unvollkommenheiten von Kathodenstrahlröhrenbildschirmen auszunutzen,
insbesondere den Abstand zwischen den Zeilen - die fragliche "0,5-Pixel"
-Technik. Und wie der Autor berichtet, indem er eindrucksvolle Screenshots
produziert, ist eine Emulation weit davon entfernt, den Charme des erzeugten
Bildes wiederherstellen zu können, indem sie sich auf diese Ausnutzung dessen
verlässt, was rückwirkend als Unvollkommenheit des Materials erscheinen kann.
Dies wirft eine weitere Frage auf: Um von der Nachahmung einer Maschine zu
sprechen, womit meinen wir "Maschine"? Sollten wir es nicht versäumen, den
Bildschirm einzubeziehen?
Aus all dem erschließen wir eine Entwicklung - einige mögen eine Drift sehen, 
aber die ganze Frage ist genau zu wissen, ob es wirklich eine ist -, dass die
Art und Weise, wie der Hafen von Starquake durchgeführt wurde, letztendlich
ziemlich gut veranschaulicht. Wer sich auf einem Emulator entwickelt, kann
wirklich von sich behaupten, für die emulierte Maschine entwickelt zu haben?
Noch bevor es darum geht, die Zulässigkeit eines Anspruchs auf ein Gesetz zu
beurteilen - um derjenige zu sein, der wirklich in der Tradition steht -,
muss gerade die Möglichkeit des Anspruchs diskutiert werden. Kann eine
Maschine richtig emuliert werden? Das heißt, in all seinen Qualitäten, aber
auch in all seinen Mängeln? Ist die Wahrnehmung desjenigen, der sich auf 
Emulation verlässt, nicht irreduzibel voreingenommen, selbst wenn er versucht,
das Beste zu tun?
Diese Reflexion über Authentizität ist nicht neu. Wir können es an das von
Philip K. Dick in The Man in the High Castle geteilte aufhängen, oder an das
grundlegendere, von dem Plutarch berichtet, indem er an das Schiff des Theseus
erinnert, und es muss jeden Kurator animieren. Es wird jedoch zweifellos durch
die Technik der Emulation erneuert.
(*) Beachten Sie, dass wir so formuliert alles sehen, was das Problem paradox
haben kann, also relativ zum Standpunkt desjenigen, der es formuliert ...
Curt Cool antwortet, dass auf der A500 alles mit der gleichen Geschwindigkeit
funktioniert. Ich verstehe nichts mehr, aber da Galahad mir eine endgültige
Version der Diskette des Spiels schickt, auf der die V8 funktioniert,
beschließe ich, es dabei zu belassen. Nicht ohne zu bemerken, dass Galahad
endlich die für das Spiel erforderliche Grundkonfiguration von 512 KB auf 
1 MB angehoben hat. Ich hätte das erste Downsizing vermeiden können.
Jedenfalls. Solange dieser Cracktro verteilt wird, kommt es darauf an...
Wir werden es besser machen, wenn es ein Starquake II gibt!

BITTE SCHÖN!

Wir werden es nicht verbergen, dieser Cracktro ist bei weitem nicht der beste
auf dem Amiga 500. Es hält jedoch stand. Der FX geht gut, mit Hilfe der schönen
Grafik und der guten Musik, die für diesen Anlass gemacht wurde. Der letzte,
den ich zu Beginn dieses Artikels erwähnt habe, ist daher kein Glas Picrate.
Wenn es nicht Champagner ist, ist es zumindest ein gutes Sauternes, das Kleid
passt gut zu den Tönen auf dem Bildschirm.
Kein Cracktro, der den Namen verdient, ohne Credits und Grüße. Für erstere:

Code von Ihrem Diener ;
Bild von Alien / Paradox ;
Musik von Curt Cool / Depth.

Für letzteres verweise ich auf die Seiten des Cracktro. Dennoch möchte ich mich
besonders bedanken...:
Galahad / Scoopex, der mir die Möglichkeit bot, diesen Cracktro zu machen, und
der so weit ging, das Trackloading seines Starquake-Hafens so umzuschreiben,
dass es auf die Diskette passt;
Sim1 / Wanted Team, mit dem ich angefangen hatte zu arbeiten, dessen Produktion
ich aber nicht nutzen konnte, weil die Fristen drängten;
Ramon B5 / Desire, der den Tag gerettet hat, indem er Disaster Alien um Hilfe
gerufen hat, um die Fristen mitten am Wochenende einzuhalten.
