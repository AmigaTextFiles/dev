
; Lektion 10

SCOOPEX "ONE": DIE CODIERUNG EINES AGA-CRACKTROS AUF AMIGA

25. Juni 2019 AGA, Amiga, Assembler 68000, Blitter, Copper

Wie in einem langen Artikel über die Scoopex "TWO" -Codierung besprochen , war
Scoopex "ONE" in den Kartons geblieben. Als Scoopex "TWO" auf dem Amiga 500 
ausgestrahlt wurde, stellte sich nämlich heraus, dass dieser Cracktro, und der,
der ihm auf dem Amiga 1200 vorausgehen sollte , aufgrund eines
Konfigurationsfehlers von WinUAE nur im Frame lief. Die Emulation war nicht
originalgetreu, die Hardware stahl dem MC68000 nicht so viele Zyklen wie in
der Realität.
Bei Scoopex "TWO" wurde das Problem durch Downsizing gelöst . Es blieb eine
Lösung für Scoopex "ONE" zu finden . Während der Programmierung eines
bevorstehenden BBS-Intros für die Gruppe Desire wurde sie gefunden. Hier ist
das Detail der Codierung von Scoopex "ONE" , einem Cracktro für Amiga 1200:

Scoopex "ONE": Ein Cracktro für A1200 im Jahr 2019
Dieser Cracktro nutzt einige Möglichkeiten, die der AGA-Chipsatz ( Advanced
Graphics Architecture ) bietet: die Anzeige in 256 Farben und den
"Burst"-Modus, der es der Hardware ermöglicht, Daten von den Bitplanes in
64-Bit-Paketen zu lesen. Als solches stellt dieses Cracktro eine gute
Einführung in die Programmierung der Hardware des Amiga 1200 dar, für
diejenigen, die sich wieder mit der Vergangenheit der glorreichsten Reihe von
Mikrocomputern verbinden möchten.
Dieses Cracktro wurde von Scoopex immer noch nicht verwendet, aber ich hatte
das Gefühl, dass es nach Monaten des Wartens notwendig war ... nicht länger
zu warten. A priori sollte es für die Veröffentlichung einer AGA-Version von
Hired Guns verwendet werden . Wir werden sehen...
Zum Anhören beim Lesen des Artikels...

Klicken Sie hier , um den vollständigen Cracktro-Code und die Daten
herunterzuladen.

Dieses Archiv enthält die folgenden Dateien:
scoopexONEv6.adf	Das Image einer Autoboot-Diskette zum Testen des cracktro
scoopexONEv6.s						die Quelle des Cracktro
common/ptplayer						Die Quelle des Modulplayers
common/debug.s						Die Quelle der Debugging-Routinen
gemeinsam/interpoliert.s			Die Quelle des linearen Interpolators
gemeinsam/Drucker.s					Die Quelle des Druckers
gemeinsam/register.s				Definition von Hardware-Registerkonstanten
gemeinsam/wartet					Die Quelle der Erwartung des Rasters
data/fontWobbly8x8x1.raw			Schriftart in RAW
data/scoopexONESkull320x152x1.raw	Das RAW-Bild
data/scoopexONELogo320x64x4.raw	Das Logo in RAW
data/smash9.mod	Das Modul


Wie immer müssen Sie einen Emulator wie WinUAE und ein Tool wie ASM-One
verwenden, um den Code zusammenzustellen und auszuführen. Weitere Erläuterungen
finden Sie in diesem Artikel.

DAS ERSCHEINUNGSBILD DES LOGOS

Das Logo ist ein 320 x 64 Pixel großes Bild in 16 Farben, d.h. 4 Bitplanes. Es
wird nach und nach von Quadraten entdeckt, die unabhängig voneinander
schwingen. Tatsächlich beginnen sie nicht nur nicht gleichzeitig zu schwingen,
sondern wenn sie zu schwingen beginnen, sind sie nicht in Phase.
Vibration ist eine zyklische Animation, bei der die Seite eines 8 x 8 Quadrats
bei jedem Schritt um 2 Pixel abnimmt, bis sie 0 erreicht, und wieder um 2 Pixel
zunimmt, bis sie ihre ursprüngliche Größe erreicht ( spSquareBitmaps ):

Animation eines vibrierenden 8x8-Quadrats

Das Szenario, ein Quadrat des Logos zu enthüllen, war Gegenstand einer Reihe
von Tests, bevor dasjenige gefunden wurde, das das Auge nicht schockiert:
zunächst ist das Logo - gezeichnet in Bitplanes 1 bis 4 - vollständig hinter
einem schwarzen Rechteck verborgen - gezeichnet in Bitplane 6;
ein Quadrat erscheint - gezeichnet in der Bitebene 5 - dessen Seite Null ist,
aber pro Schritt um 2 Pixel zunimmt, wodurch ein weißes Quadrat erzeugt wird,
das sich auf einem schwarzen Hintergrund ausdehnt;
wenn die Seite des Quadrats 8 Pixel erreicht, wird der schwarze Hintergrund
dieses Quadrats in der Bitebene 6 gelöscht;
das Quadrat setzt seine zyklische Animation fort, aber jetzt, da der schwarze
Hintergrund gelöscht wurde, erscheint das Logo an den Rändern des Quadrats,
wenn seine Seite abnimmt;
Nach einer bestimmten Anzahl von Zyklen ( SP_SQUARES_TTL ) stoppt die
Animation des Quadrats, während die Seite des Quadrats null ist, wodurch das
darunter liegende Logo vollständig sichtbar wird.
Der Zustand von jedem der (320 / 8) * (64 / 8) = 320 Quadrate ( spSquaresData )
enthält eine Wartezeit vor dem Beginn seiner Animation und den aktuellen Frame
seiner Animation. Die Anfangszustände werden mithilfe von Excel vordefiniert,
um eine zufällige Verzögerung pro Quadrat zu generieren, da zu diesem Zeitpunkt
kein Interesse daran besteht, einen PRNG zu programmieren.
Das erzeugte Ergebnis ist somit folgendes:
Darstellung des Logos in Scoopex "ONE"
Es wäre möglich, aber schwierig, die Zeit zu berechnen, die von der Animation
der Quadrate bis zur vollständigen Enthüllung des Logos benötigt wird. Aus
diesem Grund passte Notorious/Scoopex die komponierte Musik empirisch an,
sobald das Cracktro geplant war, sodass das Ende des ersten Teils der Musik gut
mit dem Ende der Logo-Enthüllung zusammenfiel.

DAS TEILCHENSYSTEM

Der Haupteffekt im Cracktro ist ein Partikelsystem:

Das Scoopex "ONE" Partikelsystem

Ein Partikel ist ein 8 x 8 Pixel großes Objekt, das eine Scheibe darstellt,
deren Durchmesser sich in 9 Schritten von 8 auf 0 Pixel ändert. Diese
fortschreitende Verringerung des Durchmessers um ein Pixel pro Schritt hat den
Nachteil, dass eine Scheibe entsteht, die in der Oberfläche des Objekts
schwingt, was aber bei Bewegung des Objekts für den Betrachter kaum wahrnehmbar
ist.

Und in Bewegung ist es.

Ein Partikel wird von einem Generator erzeugt und auf dem Bildschirm als nicht
animiertes Partikel dargestellt - eine Scheibe mit 8 Pixeln Durchmesser. Es
gibt PARTICLE_SEEDS- Generatoren, die in regelmäßigen Abständen entlang einer
vorberechneten Trajektorie von PATH_LENGTH- Positionen verteilt sind. Diese
Trajektorie ist vom Typ eines parametrischen Gleichungssystems wie eine
Lissajous-Kurve.
Ein Generator erzeugt alle PARTICLE_DELAY- Frames ein Partikel. Das Teilchen
erscheint an der Position, die dann vom Generator eingenommen wird. Er bewegt
sich gemäß einem Richtungsvektor, dessen Koordinaten einfach die Differenz
zwischen den Koordinaten der Position des Generators und seiner vorherigen
Position sind. Um zu verhindern, dass hochfrequent erzeugte Partikel zu
ähnliche Flugbahnen einnehmen, werden diese Koordinaten durch zufällige
Addition einer empirisch ermittelten Konstante (2) in Abhängigkeit von der
horizontalen und vertikalen Position des Rasters zum Zeitpunkt der Erzeugung
leicht verwischt. Anschließend ändern sich diese Koordinaten nur, wenn das
Teilchen eine Kante erreicht, an der das Teilchen abprallt. Die Geschwindigkeit
des Teilchens ist anfänglich PARTIKEL_GESCHWINDIGKEIT.
Wie berechnet man die neue Position eines Partikels bei jedem Frame? Der
MC68020 ist sicherlich schneller als der MC68000 bei der Durchführung von
Multiplikationen und Divisionen, aber im Einklang mit der Arbeit am Amiga 500
kam es hier nicht in Frage, auf solche Operationen zurückzugreifen. Die
Position des Partikels wird auf der Grundlage eines sehr einfachen Algorithmus
berechnet, der es ermöglicht, zwei ganzzahlige Werte nur durch Additionen und
Subtraktionen zu dividieren, wobei so vorgegangen wird, als ob es darum ginge,
eine gerade Linie basierend auf Pixeln zu ziehen. Dieser Algorithmus ist
derselbe wie der im Scoopex- Artikel "TWO" diskutierte - damals als
Lucas-Algorithmus präsentiert, aber dieser Algorithmus ist im Internet so
schlecht dokumentiert, dass ich nicht sicher bin, ob ich es so identifizieren
kann ...
Es ist klar, dass der Richtungsvektor des Teilchens eine - manchmal sehr grobe
- Annäherung an die Tangente an die Bahn des Generators an der Position ist,
die der Generator einnimmt, und es ist ebenso klar, dass die Verschiebung des
Teilchens von PARTICLE_SPEED Pixel entlang der größten Abmessung dieses Vektors
bei jedem Frame ist eine Annäherung - auch manchmal sehr grob - einer
Geschwindigkeit von PARTICLE_SPEED Pixeln entlang dieses Vektors. Auf dem
Bildschirm sieht es aber gut aus.
Ein Partikel hat eine begrenzte Lebensdauer, die auf PARTICLE_TTL- Frames
festgelegt ist. Mit zunehmendem Alter schreitet ihr Bild in der Animation
voran und ihre Geschwindigkeit wird verlangsamt, sodass sie durch eine immer
kleinere Scheibe dargestellt wird, die sich immer langsamer bewegt.
Letztendlich verschwindet das Partikel und seine Geschwindigkeit erreicht 0,
wenn es abläuft. Wie bei der Berechnung der Position ermöglicht ein
Algorithmus die lineare Interpolation des Index des Bildes des Partikels und
die lineare Interpolation seiner Geschwindigkeit über die gesamte Lebensdauer
des Partikels nur unter Verwendung von Additionen und Subtraktionen.
Die Anzahl lebender Partikel ist auf NB_PARTICLES begrenzt. Um eine solche
Anzahl von Partikeln erfolgreich anzuzeigen, muss PARTICLE_TTL daher auf
NB_PARTICLES * PARTICLE_DELAY / PARTICLE_SEEDS gesetzt werden.
Die Liste der lebenden Partikel wird als Liste von Strukturen geführt, die aus
den folgenden Feldern besteht:

OFFSET_PARTICLE_BITMAP	Index des Bildes des Partikels in der Liste der Bilder
						seiner Animation ptParticleBitmaps
OFFSET_PARTIKEL_X		Teilchen Abszisse
OFFSET_PARTICLE_Y		Y-Achse des Partikels
OFFSET_PARTICLE_SPEED	Geschwindigkeit des Teilchens entlang des
						Richtungsvektors
OFFSET_PARTICLE_TTL		Verbleibende Partikellebensdauer
OFFSET_PARTICLE_INCX0	Inkrement der Abszisse des Partikels entlang der
						größten Dimension des Richtungsvektors
OFFSET_PARTICLE_INCY0	Inkrement der Partikelordinate entlang der
						größten Dimension des Richtungsvektors
OFFSET_PARTICLE_INCX1	Inkrement der Abszisse des Partikels entlang der
						kleinsten Dimension des Richtungsvektors
OFFSET_PARTICLE_INCY1	Inkrement der Partikel-Ordinate entlang der
						kleinsten Dimension des Richtungsvektors
OFFSET_PARTICLE_MINDXDY	Minimum der Amplituden in Abszisse und Ordinate
						des Richtungsvektors
OFFSET_PARTICLE_MAXDXDY	Maximum der Amplituden in Abszisse und Ordinate
						des Richtungsvektors
OFFSET_PARTICLE_ACCUMULATOR	Akkumulator

Um die Wahrheit zu sagen, die Rolle der Felder dieser Struktur kann nur
verstanden werden, indem man den Code studiert, der es ermöglicht, ein Teilchen
in jedem Frame zu bewegen. Wie man sieht, bewegt sich das Teilchen, wenn die
Koordinaten des Richtungsvektors (DX, DY) sind, um die Anzahl von Pixeln
entsprechend seiner Geschwindigkeit entlang max (DX, DY) und um eine Anzahl
von Pixeln proportional entlang min(DX ). , DY) . Um die Programmierung zu 
vereinfachen, werden Inkrementpaare von derselben Schleife verwendet,
unabhängig davon, ob DX größer als DY oder kleiner als DY ist:

DX ≥ DY	DX < DY
inklX0	DX ≥ 0? 1:-1	0
incY0	0	DY ≥ 0? 1:-1
incX1	0	DY ≥ 0? 1:-1
incY1	DX ≥ 0? 1:-1	0

Welche geben:

	move.w OFFSET_PARTICLE_X(a0),d1
	move.w OFFSET_PARTICLE_Y(a0),d2
	move.w OFFSET_PARTICLE_ACCUMULATOR(a0),d3
	move.w OFFSET_PARTICLE_SPEED(a0),d4
_ptMoveParticleSpeedLoop:
	add.w OFFSET_PARTICLE_MINDXDY(a0),d3
	cmp.w OFFSET_PARTICLE_MAXDXDY(a0),d3
	blt _ptMoveParticlesNoAccumlatorOverflow
	sub.w OFFSET_PARTICLE_MAXDXDY(a0),d3
	add.w OFFSET_PARTICLE_INCX1(a0),d1
	add.w OFFSET_PARTICLE_INCY1(a0),d2
_ptMoveParticlesNoAccumlatorOverflow:
	add.w OFFSET_PARTICLE_INCX0(a0),d1
	add.w OFFSET_PARTICLE_INCY0(a0),d2
	subq #1,d4
	bne _ptMoveParticleSpeedLoop
	move.w d3,OFFSET_PARTICLE_ACCUMULATOR(a0)

Diese Liste von Partikelstrukturen soll bis zu NB_PARTICLES-Einträge enthalten.
Dies wird als Barrel bezeichnet, d.h. eine Liste, die so verwaltet wird, als ob
sie kreisförmig wäre, wobei der erste Eintrag als nach dem letzten kommend
betrachtet wird. Sein Anfang wird von ptParticlesStart referenziert, sein Ende
von ptParticlesEnd. Der Eintrag des ersten lebenden Partikels wird von
ptFirstParticle referenziert und der Eintrag nach dem des letzten lebenden
Partikels von ptNextParticle.
Wenn ein Partikel erstellt wird, wird seine Struktur dem Eintrag hinzugefügt,
auf den von ptNextParticle verwiesen wird , und dieser Zeiger wird
inkrementiert, indem er zurück zu ptParticlesStart geschleift wird, wenn er
jemals ptParticlesEnd erreicht . Daher werden Partikelstrukturen
konstruktionsbedingt vom ältesten zum jüngsten Eintrag aus dem Eintrag
sortiert, auf den durch ptFirstParticle verwiesen wird.
Die Partikelliste wird in jedem Frame besucht, um Strukturen von Partikeln zu
eliminieren, deren Lebensdauer abgelaufen ist. Da die Liste so sortiert ist,
wie wir es gerade gesagt haben, besteht das Manöver einfach darin,
ptFirstParticle zu inkrementieren, indem es zu ptParticlesStart
zurückgeschleift wird, wenn es jemals ptParticlesEnd erreicht.

PARTIKELREDUZIERUNG

Wie man vermuten kann, ist die Anzahl der auf dem Bildschirm sichtbaren
Partikel NB_PARTICULES weit überlegen. Tatsächlich wird diese Zahl einfach
vervierfacht, indem zwei Techniken verwendet werden: Persistenz und
Umkehrung. Sie ermöglichen nicht nur die Vervielfältigung der Partikel,
sondern bereichern auch die Palette, die ansonsten auf zwei Farben beschränkt
wäre, darunter eine für den Hintergrund. Wie man sieht, wäre das Ergebnis dann
recht flach:

Die Partikel-Bitebene 1

Afterglow besteht darin, die Bitebene, die das dahinter angezeigte Bild
enthält, zurückzuschieben und das neue Bild in der Bitebene zu zeichnen, die
ihren Platz einnimmt. Hier wird bei jedem Rahmen T die vorherige Bitebene 1,
die die während Rahmen T-1 gezeichneten Partikel enthält, zur Bitebene 3, und
die Partikel werden in eine neue Bitebene gezeichnet - die die vorherige
Bitebene 3 sein könnte.
Dadurch werden die Partikel nicht mehr ein-, sondern dreifarbig dargestellt.
Die Forschung zeigt, dass die Verwendung einer hellen Farbe dort, wo sich die
Partikel der T- und T+1-Frames überlappen, ein interessantes Ergebnis liefert:

Teilchendoppeldecker 1 und 3, wobei 3 die vorherige 1 ist

Das Spiegeln besteht darin, das Bild in einer Bitebene mit der rechten Seite
nach oben und in einer anderen Bitebene, die sich normalerweise hinten
befindet, mit der Oberseite nach unten anzuzeigen. Zur Erinnerung: Um die
Startadresse der nächsten Zeile zu bestimmen, addiert die Hardware einen Wert
- das Modulo - zur Endadresse der gerade gezeichneten Zeile. Der Modulo kann
negativ sein und in einem Register gelesen werden - BPL1MOD für ungerade
Bitebenen, BPL2MOD für gerade Bitebenen - dies ermöglicht, dass ungerade
Bitebenen in geraden Bitebenen verkehrt herum angezeigt werden, oder umgekehrt.
Hier sind die Bitebenen 2 und 4 umgekehrte Versionen der Bitebenen 1 bzw. 3.
Dadurch werden die Partikel nicht mehr in drei, sondern in fünfzehn Farben
dargestellt. Diese Zahl ist jedoch theoretisch. Die Forschung zeigt, dass man,
um die Illusion einer Partikelvervielfachung zu erwecken, dem Betrachter nicht
helfen sollte, Partikel von Bitplanes 2 und 4 von denen der Bitplanes 1 und 3
zu unterscheiden, und daher eher die dreifarbige Palette dieser neuesten 
Bitplanes verallgemeinern sollte:
Die Bitebenen 1, 3, 2 und 4 von Partikeln, wobei die 2 und 4 die
umgekehrten 1 und 3 sind Remanenz und Rollover nehmen keine CPU-Zeit in
Anspruch, da es nur darum geht, ein paar Wörter in der Copperliste zu ändern -
und selbst dann ist es manchmal nicht einmal jedes Frame. Die resultierende
Partikelreduzierung ist wirtschaftlich. Schließlich ... dürfen wir nicht
vernachlässigen, dass die Verwendung zusätzlicher Bitplanes dazu führt, dass
der CPU gerade oder sogar ungerade Zyklen gestohlen werden. Wir werden darauf
zurückkommen.

Am Ende ist die Organisation der Bitplanes wie folgt:

Bitebene	Verwenden
1			Teilchen zum Zeitpunkt T
2			Invertierte Bitebene 1
3			Partikel zum Zeitpunkt T-1
4			Invertierte Bitebene 3
5			Logo-Bitebene 1, Text-Bitebene
6			Logo-Bitplane 2, Totenkopf-Bitplane
7			Logo Bitplane 3
8			Bitebene 4 des Logos

Um ihn lesbar zu machen, wird der Text im Vordergrund angezeigt und verdeckt
alles dahinter. Andererseits lässt der Schädel halbdurchsichtig die
vorbeiziehenden Teilchen erahnen. Diese Effekte werden erzielt, indem mit
bestimmten Farben der Palette gespielt wird, möglicherweise von einer
bestimmten Höhe auf dem Bildschirm, um Farben wiederzuverwenden.
Beispielsweise werden unter dem Logo alle Farben mit gesetztem Bit 5
(32, 33 usw.) an TEXT_COLOR übergeben, um den Text anzuzeigen, da sie nicht
mehr verwendet werden, um das Logo anzuzeigen, das diese Bitebene mit dem Text
teilt.
Wie hier erläutert, hat das Raster Zeit, sich um 8 LowRes-Pixel zu bewegen,
während Copper eine MOVE ausführt. Folglich muss diesem Coprozessor Zeit
gegeben werden, die MOVEs auszuführen, die die Farben modifizieren, bevor das
Raster beginnt, die Linie zu ziehen, wo diese Farben verwendet werden müssen.
Hier muss ab der Zeile DISPLAY_Y+HALFBRIGHT_Y-2, die der vorletzten Zeile vor
der des weißen Trennzeichens entspricht - und nicht der letzten vor der des
Trennzeichens - die Operation beginnen.

DER DRUCKER

Zum Drucker wurde hier schon alles gesagt. Tatsächlich ist der Scoopex
"ONE"-Drucker eine ältere Version des Scoopex "TWO"-Druckers.

ÜBERGÄNGE

Übergänge sind in einem Cracktro ebenso notwendig wie schmerzhaft zu
programmieren, und dieser hier, der der erste der kürzlich gestarteten Serie
war, war eine Gelegenheit für mich, mich daran zu erinnern. Wieso den?
Erstens die technische Herausforderung, die es darstellt. Manchmal muss man
viel Zeit aufwenden, um einen Weg zu finden, den Übergangscode in den
Cracktro-Code zu integrieren. Da der Übergangscode gleichzeitig ausgeführt
werden muss, muss er mit den verfügbaren Ressourcen auskommen, die leicht
gezählt werden können, da ein FX, der per Definition viel davon verbraucht, in
Bearbeitung ist.
Dann ist die Aufgabe besonders undankbar. Es ist so, dass es zu nichts
Spektakulärem führt. Welchen Wert hat es, zwei Linien von der Mitte des 
Bildschirms wachsen zu lassen, bis sie den Bildschirm in zwei Teile teilen,
bevor sie eine nach oben und die andere nach unten verschieben, um einen
kaum sichtbaren Hintergrund zu enthüllen, den der Text fast vollständig
bedeckt?
Die Definition eines Übergangs lautet wie folgt: Es ist ein kleines Nichts, das
zwischen zwei großen Dingen stattfindet, von denen das eine zum Niedergang,
das andere zum Entstehen gebracht werden muss und das an sich nichts 
Interessantes hat. Ein Übergang sollte mit begrenzten Ressourcen in einer
komplexen Umgebung wenig bewirken, aber er sollte es perfekt tun.
Empfindlich...

BURST-MODUS UND TRIPLE-BUFFERING ZUR LEISTUNGSSTEIGERUNG

Das Cracktro betreibt acht Bitplanes. Wenn wir wissen, dass auf dem Amiga 500
nach 4 Bitplanes das Hinzufügen von Bitplanes dazu führt, dass sogar
DMA-Zyklen von der CPU gestohlen werden, können wir vermuten, dass eine
solche Tiefe die Leistung auf dem Amiga 1200 aufgrund der
Abwärtskompatibilität beeinträchtigen wird, was zu einer starken Begrenzung der
Anzahl von führt Partikel. Tatsächlich stellt sich das heraus, es sei denn, Sie
nutzen eine Funktionalität der Videohardware aus, die darin besteht, die Daten
der Bitplanes nicht in Paketen von 16 Pixeln, sondern in Paketen von 64 Pixeln
zu lesen - eine Art Burst-Modus, werden wir sagen.
A priori müssten dann die Adressen der Bitplanes auf 64 Bit ausgerichtet
werden. Zumindest ist dies erforderlich, um AGA-spezifische 64-Pixel-breite
Sprites anzuzeigen, wie mit dem in diesem Artikel zum Download angebotenen Code
getestet werden kann - beachten Sie die Anwesenheit der Direktiven CNOP 0.8. In
diesem Fall erschien es jedoch nicht notwendig, eine solche Angleichung zu
erzwingen. Die von AllocMem() beim Zuweisen von Bitplanes im Speicher
zurückgegebene Adresse wird ohne Probleme direkt verwendet.
Backward Accounting verpflichtet, das Lesen von Paketen zu 64 Pixeln ist
standardmäßig nicht aktiviert. Dazu ist es notwendig, bestimmte Bits im
FMODE-Register AGA-spezifisch zu positionieren. Darüber hinaus müssen die Werte
der Register DDFSTRT und DDFSTOP angepasst werden, die angeben, in welchem
​​​​Moment die Hardware mit dem Lesen beginnen und das Lesen der Bytes der 
Bitplanes, die den Pixeln einer Zeile entsprechen, sowie der von die Register
der Modulos BPL1MOD und BPL2MOD, die spezifizieren, wie viele Bytes die 
Hardware zu den Bitebenenzeigern am Ende der Ausgabe einer Zeile hinzufügen 
soll. So finden wir in der Copperliste des cracktro:

move.w #DDFSTRT,(a0)+
move.w #$0038,(a0)+ ;Abgerufen durch Disassemblieren der Workbench-AGA-Copperliste :)
move.w #DDFSTOP,(a0)+
move.w #$00D8,(a0)+ ;Abgerufen durch Disassemblieren der Workbench-AGA-Copperliste :)
move.w #BPL1MOD,(a0)+
move.w #-8,(a0)+
move.w #BPL2MOD,(a0)+
move.w #-8,(a0)+

;AGM-Burst-Modus

move.w #FMODE,(a0)+
move.w #$0003,(a0)+

Zur Anekdote, der Hinweis auf die Demontage der Copperliste AGA zur Bestimmung
der Werte von DFFSTRT und DDFSTOP ist ein Zeugnis der tiefen Undurchsichtigkeit
dieser Register... Sicherlich enthält das Amiga Hardware Reference Manual viele
Erklärungen mit auf den Weg der Berechnung dieser Werte, aber wer ins Detail
geht, stellt schnell fest, dass die Argumentation eher eine Abstraktion als 
eine Realität zu sein scheint, was eine Übertragung auf den vorliegenden Fall
erschwert. Um diese Werte zu ermitteln, habe ich daher die Copper-Liste aus der
Workbench zerlegt, nachdem ich die Auflösung an die des Cracktro angepasst
hatte:

Demontage der Copper-Liste von der Workbench

Zurück zum Cracktro. Das Lesen von Daten aus Bitplanes in 64-Pixel-Paketen ist
nicht die einzige Technik, die die CPU entlasten kann. Eine weitere sehr
effektive Technik, die in Cracktro verwendet wird, ist die Verwendung von
Triple-Buffering anstelle von Double-Buffering. Das Prinzip wurde bereits in
diesem Artikel zur Realisierung einer Sinusspirale auf OCS erläutert - die
Technik ist nicht spezifisch für die AGA. Um es kurz in Erinnerung zu rufen:
die Hardware zeigt eine erste Bitebene an, die das Bild N enthält;
parallel dazu zeichnet die CPU das N+1-Bild in einer zweiten Bitebene;
parallel dazu löscht der Blitter das N-1-Bild in einer dritten Bitebene.

Insgesamt ermöglicht das Einlesen von 64-Pixel-Paketen und Triple-Buffering,
die maximale Anzahl der angezeigten Partikel von 70 auf ... 300 zu erhöhen,
also von 280 auf 1.200 scheinbare Partikel, dank der zuvor beschriebenen
Multiplikatoreffekte - Persistenz und Umkehrung. Nur so war es möglich, den
Cracktro aus den Kartons zu holen, in denen er gelassen wurde.

DIE KODIERUNG VON

Die Geschichte dieses Cracktro reicht bis in den Sommer 2017 zurück. Ausgehend
von der Idee, eine Demo zu produzieren, programmiere ich mehrere FX für
Amiga 500, darunter eine erste Version des zuvor vorgestellten Partikelsystems:

Das ursprüngliche Partikelsystem

Dann kam mir die Idee, die Anzahl der Teilchen mit den Techniken der Persistenz
und Umkehrung zu vervielfachen. Allerdings gibt es ein Problem: Wenn ich dafür
vier Bitplanes mobilisiere, bleibt mir nur noch eine für ein Logo übrig, was
auf fünf Bitplanes anwächst. Zweifellos wäre es möglich, die Bitplanes der
Partikel zu verwenden, aber es gäbe zwei Einschränkungen:
Neuzeichnen des Logos in diesen Bitplanes bei jedem Frame, was auf Kosten der
Anzahl von Partikeln erfolgen würde;
dem Grafikdesigner die Palette aufzwingen, aber nichts sagt, dass sie ihn
angesichts der leuchtenden Farben verzaubert, und es ist schon ziemlich
schwierig, eine zu finden.
Infolgedessen entscheide ich mich für den Amiga 1200 und wechsele somit von
OCS zu AGA. Auf dieser Maschine werde ich acht Bitplanes haben, die perfekt
dafür geeignet sind, ein Logo in 16 Farben über den Partikeln anzuzeigen.
Fertig, ich schicke das Cracktro an Galahad, der sich bei mir bedankt und mir
mitteilt, dass vorerst keine AGA-Spielveröffentlichung geplant ist.
Andererseits ist er dabei, die Portierung eines ST-Spiels auf den Amiga 500 zu
veröffentlichen. Wenn mir das Herz so sagt, ist ein Cracktro für OCS
willkommen. Dies ist die Scoopex-Geschichte "ZWEI", die zuvor hier erzählt
wurde.
Wie in dieser Story berichtet, habe ich zum Zeitpunkt der Ausstrahlung von
Scoopex "TWO" festgestellt, dass dieser Cracktro aufgrund eines
WinUAE-Konfigurationsfehlers nicht im Frame läuft. Die Emulation ist nicht
originalgetreu, die Hardware stiehlt dem MC68000 nicht so viele Zyklen wie in
der Realität. Alles läuft so ab, als hätte ich die Rechenkapazitäten des Amigas
überschätzt.
Da ich zuvor Scoopex "ONE" programmiert habe, stelle ich fest , dass das
Problem auch diesen Cracktro betrifft. Sobald WinUAE richtig konfiguriert ist,
sinkt die maximale Anzahl der im Frame darstellbaren Partikel dramatisch von
über 500 auf knapp über 70. Unter diesen Bedingungen kann der FX nicht mehr
überzeugen und Scoopex "TWO" kann daher nicht ohne Risiko vertrieben werden.
Schande. Eine Chance, dass Galahad zu diesem Zeitpunkt keine 
AGA-Veröffentlichung auf Cracktro wartete, weil er offensichtlich den gleichen
Fehler gemacht hatte wie ich ...
Wir müssen eine Lösung finden oder den Code begraben. Allerdings beschäftige
ich mich schon intensiv mit der Programmierung anderer Kleinigkeiten - allen
voran "Scoopex THREE", ein Trainermenü für StingRay. Also ließ ich es los und
sagte mir, dass ich eines Tages darauf zurückkommen werde ... oder nie! Denn
zu der Zeit muss ich zugeben, dass ich nicht sehr gut sehe, wie ich es
besser machen könnte.
Lange Zeit später muss ich mich mit der AGA zusammentun, um zu erklären, wie
man Sprites mit einer Breite von 64 Pixeln in 256 Farben anzeigt, als Teil des
Schreibens eines Artikels über diese Hobbits von Videohardware. Da erinnere ich
mich - was schade ist, denn ich war einer der Leute, die damals mit der
Dokumentation begannen -, dass der AGA solche Sprites mit beschleunigten
Wiedergabedaten im Videospeicher anzeigen kann.
Die Untersuchung der inoffiziellen AGA-Dokumentation - wie ich bereits
erklärte, Commodore hat diese Hardware nie offiziell dokumentiert - sagt mir,
dass das gleiche für Bitplanes gilt. Ich gehe eine vernünftige Wette ein, dass
dies Zyklen für die CPU freisetzen kann und es mir daher ermöglicht, die
Anzahl der Partikel zu erhöhen. Ich teste, und es stellt sich heraus, dass es
tatsächlich der Fall ist.
Der Gewinn ist da, aber er bleibt begrenzt in Bezug auf die Anzahl der
Teilchen, von denen ich ausgegangen bin. Um es noch mehr zu steigern,
entschied ich mich sofort für die Triple-Buffering-Technik, die ich damals
aus Schleim verworfen hatte. Dies zwingt mich, einen kleinen Teil des Codes
neu zu schreiben. Nichts allzu Ernstes, wenn ich sehe, dass mir diese mit der
anderen Technik verbundene Technik letztendlich erlaubt, eine viel größere
Anzahl von Partikeln zu erreichen und einen Effekt auf dem Bildschirm zu
erzeugen, der dem nahe kommt, den ich zuerst erreicht habe.
Der Cracktro ist gespeichert. Es kann auf kleinen und großen Bildschirmen
gespielt werden. Puh!

UND LOS GEHT'S!

Es besteht kein Zweifel, dass es mit dem AGA-Chipsatz möglich ist, beim
Zusammenbau besser zu werden. Das Partikelsystem ist jedoch ziemlich cool -
obwohl es möglich wäre, seine Kraft auf andere Weise zu demonstrieren, als die
Generatoren einfach entlang einer vorberechneten Flugbahn kreisen zu lassen.
Und schließlich heben die schöne Grafik und die exzellente Musik das Ganze
hervor und machen es zu etwas, das zusammenhält.

Kein Cracktro, der diesen Namen verdient, ohne Credits und Grüße. Zum ersten:
Code von Ihnen wirklich ;
Bild von Alien/Paradox ;
Musik von Notorious/Scoopex .

Für letzteres verweise ich auf die Seiten des Cracktro. Trotzdem möchte ich
mich ganz besonders bei Galahad / Scoopex bedanken, die mich motiviert haben,
indem sie mir die Möglichkeit geboten haben, diesen Cracktro zu senden ... 
bis es eines Tages ist!
