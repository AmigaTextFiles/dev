
	PicCon 2.50

PicCon Copyright © 1993 - 1994 Morten Eriksen

Kickstart 2.04 oder höher erforderlich.

Eigenschaften: Es verwendet die datatypes.library, damit es JPEG, GIF und 
andere lesen kann, wenn Sie die Datentypen haben. Wenn datatypes.library nicht
vorhanden ist, wird ein normaler IFF ILBM-Lader verwendet, der auch ANIMATIONEN
lesen kann. Es ist mit den Modi OCS, ECS und AGA kompatibel und kann Bilder in
vielen Modi, in Formaten wie RAW BITPLANES, CHUNKYMODE, SPRITES speichern.
Sogar die Paletten von Farben können in ECS (4 Bit pro RGB-Komponente) oder in
AGA (8 Bit pro RGB-Komponente) aus der 24-Bit-AGA-Palette gespeichert werden.
Plus Unterstützung für Super Nintendo (SNES) und Sega Megadrive, obwohl es
weniger wichtig ist.
Kurz gesagt, mit diesem Programm können Sie alles tun, sogar Kaffee kochen.
Viele seiner Funktionen sind für uns völlig nutzlos und viele weitere sind
überflüssig, weil sie mit dem Zeichenprogramm gemacht werden können.
Tatsächlich ist die normalste Verwendung dieses IffConverter das Laden eines
iff image, um es in RAW-Bitebenen oder Sprites (auch AGA) zu speichern. Sie
können alle anderen Optionen studieren, aber Sie werden nur wenige benötigen.

Hinweis:

PicCon ist Shareware, daher verfügt diese Version nicht über alle aktiven
Optionen. das ist:
1) Es werden keine Einstellungen gespeichert oder geladen.
2) Es "symbolisiert" nicht
3) Hier und da gibt es Nachrichten, die Sie daran erinnern, dass Sie sich
   registrieren müssen

Wenn Sie die registrierte Version (persönliche Lizenz) erhalten möchten,
müssen Sie an den Autor eine leere Diskette und 15 US-Dollar senden:

        Morten Eriksen
		Lauritz Jenssens gt. 10
		7045 Trondheim
        NORWAY

Dies stellt sicher, dass Sie über die neueste registrierte Version und Upgrades
verfügen. Wenn Sie nach der Registrierung auf die neueste Version aktualisieren
möchten, müssen Sie dies tun. Senden Sie ihm das Geld für 1 Diskette, das Paket
und das Porto, das er mit etwa 4 US-Dollar berechnet.

Wenn Sie im Internet sind und eine E-Mail haben, wo Sie die Datei erhalten
können, registrieren Sie sich. Senden Sie ihm einfach 15 US-Dollar und fordern
Sie die Datei unter Angabe der E-Mail-Adresse an.
Für Upgrades fragen Sie einfach, und die Datei wird "per E-Mail" gesendet.

Hier ist seine E-Mail:

        mortene@idt.unit.no


Das Programm benötigt die Dateien diskfont.library, asl.library und
reqtools.library.
Um die Vorteile von datatypes.library nutzen zu können, muss diese
Bibliothek in LIBS vorhanden sein: und einige Bilddatentypen in SYS:
Classes / DataTypes und die Korrespondenten Datentypdeskriptoren in
Sys: Devs / DataTypes.

-	-	-	-	-	-	-	-	-	-
			INFORMATIONEN ZUR VERWENDUNG
-	-	-	-	-	-	-	-	-	-

		*	MENÜ Project	*

Open picture	; Laden Sie das IFF-Bild, sowohl ECS als auch AGA.
		; Bei einigen Datentypen können Sie auch JPEG, GIF, PCX hochladen ...)

Fit picture	; Laden Sie ein Bild wie Open Picture hoch, aber lassen Sie die
		; Palette und die Anzahl von Farben gleich, wie zuletzt hochgeladen.
		; Dieser Vorgang kann jedoch durchgeführt werden mit dem
		; Paint-Programm.

Open ANIM5	; Laden Sie eine Animation im Dpaint-Format hoch
		; (op5-Komprimierung).
		; Sie wählen den Rahmen mit den Tasten "+" und "-".
		; Um alle Frames auf einmal zu speichern, können Sie die Funktion
		; ANIM speichern verwenden

Load image	; Diese Funktion dient zum Laden von RAW-Daten, was nützlich ist
		; für Dateien, die zuvor von IFF in RAW konvertiert wurden.
		; Wenn Sie ein RAW laden, lädt das Programm es unter der Annahme
		; das es das gleiche Format wie im Menü "Settings/Imageformat"
		; angegeben hat. Wenn Sie die Größe und Anzahl der Bitebenen der
		; Figur vergessen haben, benötigen Sie sooooo manche Tests.

Load palette	; Diese Funktion lädt und verwendet eine Palette wie in der 
		; Abbildung aktuell angezeigt. Das Format der Palette muss
		; im Menü "Settings/Paletteformat" angegeben werden.

Save image	; Speichern Sie das aktuelle Bild in dem im Menü "Settings/
		; Imageformat" festgelegten Format. Wenn Sie kein bestimmtes Rechteck
		; ausgewählt haben wird die gesamte Figur gespeichert.
		; Die Größe der Figur ist in der Menüleiste sichtbar.

Save palette	; Speichern Sie die Palette im ausgewählten Format unter 
		; den verfügbaren im Menü "Settings/Paletteformat".

Save grid	; In der nicht registrierten Version deaktiviert

Save ANIM	; Speichern Sie alle Frames einer geladenen Animation
		; Laden Sie ANIM in der Reihenfolge, in der es im Moment angezeigt wird.
		; Sie müssen "%%%" in den Namen eingeben, um Platz zu lassen
		; für die Frame-Nummer, zum Beispiel "anim%%%.raw"
		; Es werden die Frames "anim000.raw", "anim001.raw" usw. gespeichert.

Save data as	; Sie wählen, ob die Daten in RAW-Quelle Assembler, C, Pascal
		; sein müssen oder andere. Wir brauchen RAW oder zumindest
		; für kleine Sprites oder Assembler-Figuren, d.h. viele DCs oder 
		; dc.w. PicCon entscheidet selbst, ob .b, .w oder .l verwendet werden.

Change screenmode ; Ändern Sie den Videomodus wie in DEVS beschrieben: Monitore /,
		; vorausgesetzt, WB 2.1 oder 3.x existiert und ist vorhanden

Modify palette	; So nehmen Sie die neuesten Änderungen an der Palette vor,
			; wie in Dpaint

Load prefs	; In der nicht registrierten Version deaktiviert

Save prefs	; In der nicht registrierten Version deaktiviert

Info		; Informationen zum PIC und zum ausgewählten Rechteck.

About PicCon	; Informationen zum Programm und zum Autor

Iconify		; In der nicht registrierten Version deaktiviert

Quit		; Programm beenden


-	-	-	-	-	-	-	-	-	-

		*	MENÜ Edit	*

Cut frame	; Es wird verwendet, um einen rechteckigen Teil der Figur 
		; wie bei KEFCON auszuwählen. Sie müssen nicht einmal im Menü suchen,
		; weil es bereits am Anfang aktiv ist. Drücken Sie die linke Maustaste
		; und halten sie die Taste gedrückt für den Block, den Sie auswählen 
		; möchten und "vergrößern" Sie das Rechteck, bis es von der
		; richtigen Größe ist, an dieser Stelle die Taste loslassen.
		; Um die Breite oder Länge zu "sperren", halten Sie die rechte oder 
		; linke Umschalttaste. Der Mauszeiger enthält die Koordinaten der Figur,
		; wenn Sie jedoch einen Block auswählen, enthält dieser stattdessen die 
		; Abmessungen. Wenn die Koordinate ein Vielfaches von 8 ist, ändert
		; sich die Farbe, um sie anzuzeigen (nützlich für die Auswahl von Sprites
		; oder Blöcke zu blitten). Beachten Sie, dass, wenn die Figur auf 
		; einfarbigen Hintergrund ist können Sie die Funktion aus dem Menü
		; "Autocrop" verwenden, um es in ein Rechteck aufzunehmen.
		; Wenn die Auswahl leicht falsch ist, kann sie mit 
		; der Funktion "Set Frame" korrigiert werden.
Grab frame	; Wenn die Objekte in farbigen Rechtecken eingeschlossen sind
		; können Sie diese Option verwenden, um sie auszuwählen.
		; Wählen Sie einfach die Farbe aus, aus der das Rechteck besteht
		; zuvor um das Objekt gezeichnet, und klicken Sie auf innerhalb.
		; Wenn das Rechteck "Löcher" enthält, funktioniert es nicht.
		; Beim zweiten Mal wird die Umrissfarbe nicht benötigt
		; rechteckig, um es zu ändern, müssen Sie das Menü 
		; "Settings/Set new grabpen" verwenden

Box frame	; Diese Funktion bewirkt, dass der Block ausgewählt wird, indem
		; nach der Größe des Rechtecks im Voraus gefragt oder unter
		; Verwendung des letzten ausgewählt wird.
		; Nützlich für die Auswahl vieler identischer Stücke.	

Set frame	; Um das Rechteck auszuwählen, geben Sie die Koordinaten
		; seiner Winkel direkt ein. Auch nützlich zur Korrektur eines
		; bereits ausgewählten Rechtecks mit 1 0 2 Pixel Fehler.

Free frame	; "Geben Sie" das ausgewählte Rechteck frei ein und 
			; vergrößern Sie es auf das ganze Bild.

Autocrop	; Diese Option beschränkt das Rechteck automatisch auf
			; die Grenzen der Figur, Leerzeichen eliminieren.

Autoscan	; In der nicht registrierten Version deaktiviert

Flip X		; Diese beiden Optionen "spiegeln", dh sie drehen den Block um
Flip Y		; horizontal oder vertikal ausgewählt.
		; Wenn Sie keinen Block ausgewählt haben, drehen Sie das gesamte Bild um.
		; HINWEIS: Wird nicht im HAM-Modus verwendet, dies führt zu "verschmieren".


-	-	-	-	-	-	-	-	-	-

		***************************
		*	MENÜ Settings	  *
		***************************

***************
* Imageformat *
***************

In dem angezeigten Fenster wird das Format ausgewählt, in dem das Bild mit
"Projekt / Bild speichern" gespeichert werden soll..

Einstellungen im Fenster "Imageformat":

****************************************************************************

* Bitplanes *	; Speichern Sie das Bild in RAW, d.h. in aufeinanderfolgenden
Bitebenen:

  <- Breite ->

  +--------------+
  |              |     ^
  |              |     |
  |  Bitplane 0  |	 Höhe
  |              |     |
  |              |     |
  +--------------+     v
  |              |     ^
  |              |     |
  |  Bitplane 1  |   Höhe
  |              |     |
  |              |     |
  +--------------+     v
  |              |     ^
  |              |     |
  |  Bitplane 2  |   Höhe
  |              |     |
  |              |     |
  +--------------+     v
         |
         |
         .
         .
        etc

Für die Figuren in HAM8 sollten die beiden Steuerbitebenen am Anfang
($dff0e0 und $dff0e4) sein, aber sie müssen tatsächlich nach unten gehen.
PicCon speichert die RAW HAM8-Bilder zu Beginn mit den Steuerebenen.

	Optionen der "Bitplanes":

Blitterwords

Wenn Sie dieses Format auf etwas anderes als "None" einstellen, wird es
gespeichert mit einer zusätzlichen Wortspalte (16 Pixel, 2 Bytes) rechts,
links oder auf beiden Seiten (beiden) der Bitebenen. Dies kann verwendet
werden, um die Verschiebungen des Blitters zu verwenden.

Ausrichtung

Es dient dazu, den Rahmen (Block) auf volle Bytes (8 Pixel) und volle Wörter
auszurichten (16 Pixel), Langwort (32 Pixel) oder Vierwort (64 Pixel).
Zum Beispiel, wenn wir einen 65 Pixel breiten Block ausgewählt haben, wenn Sie
die Byte-Ausrichtung auswählen wird 72 Pixel breit gespeichert (weil das 
Vielfache von 8 sind 16 ... 56,64,72,80 ... und 65 kommt vor 72).
Wenn Sie stattdessen die Wortausrichtung (16 Pixel) auswählen, wird es 
80 Pixel breit gespeichert (tatsächlich: 32,48,64,80,96 ...).
Wenn Sie die Langwortausrichtung (32 Pixel) auswählen, wird eine Breite von
96 Pixel gespeichert und schließlich mit der Quadword-Ausrichtung (64 Bit)
wird es 128 breit sein.
Für AGA-Modi müssen Bitebenen mehrere Adressränder von 64 haben zum Beispiel.

Interleaved

Wird für spezielle Blitter-Modi verwendet. Die Bitebenen werden wie folgt
gespeichert:

  +--------------+--------------+
  |              |              |
  |              |              |
  |              |              |
  |              |              |
  |  Bitplane 0  |  Bitplane 1  |-- . . etc
  |              |              |
  |              |              |
  |              |              |
  |              |              |
  +--------------+--------------+

struct Image

Es wird für Betriebssystemfunktionen verwendet, es ist uns egal.

Mask

Wenn diese Option beim Speichern ausgewählt ist, wird eine Blockmaske
(ausgewählt) erstellt und gespeichert. Nützlich, um sich die Mühe zu ersparen
die Form der Figur in eine Bitebene manuell zu speichern. Die Maske (für den
Blitter) wird erstellt, indem aus allen Bitebenen ein "ODER" zwischen ihnen 
erstellt wird. Sie erhalten eine Art "Schatten" des Objekts.

Hinweis: Wenn die Option "Interleaved" aktiviert ist, wird der ausgewählte
Block als blittermask in diesem Format gespeichert:


  +----------+----------+        +----------+
  |          |          |        |          |
  |          |          |        |          |
  |          |          |        |          |
  |          |          |        |          |
  |  Mask    |  Mask    |....... |  Mask    |
  | plane0   | plane1   |        | planeN   |
  |          |          |        |          |
  |          |          |        |          |
  |          |          |        |          |
  +----------+----------+        +----------+


Es werden N Masken gespeichert, eine pro Bitebene.

Dieses Format kann verwendet werden, um so viele Bits zu maskieren, wie in
jeder Bitebene mit einer einzelnen Blittata (wenn der Bildschirm interleaved
ist!).

Invert mask

Wenn diese Option aktiviert ist, werden alle Nullen im Block in 1 geändert und
umgekehrt.

******************************************************************************

* Chunky *

Der Chunky-Modus ist ein Modus, der von IBM PC / MSDOS VGA-Karten verwendet
wird, aber auch von Grafikkarten für Amiga, wie dem Picasso II. Der CD32 hat
einen Chip namens Akiko, der für die Konvertierung vom Chunky-Modus in den
Bitplanes-Modus verantwortlich ist.
In der Praxis funktioniert das so: Wir wissen, dass man um einen 256er Farben 
Bildschirm auf Amiga (AGA) zu machen, 8 Bitebenen, dh 8 Bits pro Pixel
benötigt. Ein Byte (8 Bit) kann 256 verschiedene "Fälle" definieren. In diesem
Fall werden die 256 Farben anders in der Palette definiert.
Wenn wir beispielsweise 256 Graustufen definieren, ab Farbe 0 = Schwarz bis
Farbe 1 = Weiß. Dh sind alle 8 Bitebenen zurückgesetzt ist die Farbe schwarz,
bei allen 1 ist die Farbe weiß.
Stellen Sie sich vor, Sie haben immer diese Palette, aber wir ändern den Weg
einen 320 * 200-Bildschirm von Bitebenen nach Chunky zu definieren. Der Chunky
teilt den Bildschirm in 320 * 200 Pixel, aber nur zu einer "großen Bitebene",
in der für jedes Pixel ein Byte anstelle von 8x 1-Bit-Bitebenen entspricht.
In der Praxis verschmilzt es die Bitebenen. Jetzt haben wir das, damit das
erste Pixel oben weiß wird, benötigen Sie ein "MOVE.B #$FF,SCREEN". Um das
zweite Pixel weiß werden zu lassen ein "MOVE.B #$FF,SCREEN + 1" und so weiter.
Um die Farbe eines Pixels zu ändern, ändern Sie einfach das zugeordnete Byte,
wobei ein Wert zwischen $00 und $ff angegeben wird, um anzugeben, welche der
256 Farben der Palette verwendet werden soll.
Um das erste Byte der zweiten Zeile einzuschalten, überspringen Sie einfach die
erste Zeile, die aus 320 Pixeln besteht, also 320Bytes, also
"MOVE.B #$FF,SCREEN + 320". Auf dem Amiga gibt es diesen Weg der Anzeige nicht,
es sei denn, Sie haben eine Grafikkarte.

	Optionen von "Chunky":

Ordinary

In der Regel wird 1 Byte für jedes Pixel gespeichert. Zum Beispiel, wenn
Sie 5 Bitebenen haben, wobei die Bits in den Ebenen 0 und 3 gesetzt und in den
Ebenen 1, 2 und 4 zurückgesetzt sind hat das Chunky-Pixel diesen Wert:

 bit# 7 6 5 4 3 2 1 0  
    % 0 0 0 0 1 0 0 1 = $09

(Die Bits der nicht verwendeten Bitebenen werden auf Null gesetzt)

Der normale Weg ist kompatibel mit Picasso-Karte und VGA.

Packed

Mit dieser Option werden die Pixel jedes Bytes nach links verschoben um
unnötige Bits zu entfernen. Im obigen Beispiel hätten wir %01001xyz, wobei
xyz die Bits sind, die um das Pixel danach verschoben werden. Es kann verwendet
werden, um Platz zu sparen oder für bestimmte Routinen, die es im 
Bitebenenformat "dekomprimieren".


VGA ModeX

Speichern Sie das Bild für den X-Modus, der vom VGA des PC-MSDOS verwendet wird
(Bytebenen). Es dient nur für diejenigen, die MSDOS VGA programmieren möchten!
(Pussa weg!)


12 bit truecolor

In diesem Fall werden die Pixel nicht als Farbnummer aus der Palette
gespeichert, sondern die Rot-, Grün- und Blauwerte jedes Pixels und eines
Wortes werden pro Pixel direkt gespeichert. 
Beispielsweise wird ein rotes Pixel als $0f00 gespeichert, ein graues
wie $0888. Dieser Modus kann für copperschirme oder Pseudoroutinen verwendet
werden 12-Bit-Texturabbildung (4096 Farben), wie Doom-Klone.
Die EHB- und HAM-Zahlen werden korrekt konvertiert.

24 bit truecolor

Dieser Modus ist wie "12 Bit True Color", jedoch mit 8 Bit pro RGB-Komponente
statt 4 Bits. Wie Sie wissen, ergeben 256 * 256 * 256 Möglichkeiten maximal
16.777.216 Farben zur Auswahl. Jedes Pixel wird als 3 Bytes gespeichert.
das heißt (R + G + B).

As longwords

Mit dieser Option werden die TrueColor-Pixel so gespeichert, dass sie jeweils
entlang eines Langwortes vorhanden sind. Dies kann Verschiebungen vermeiden und
den Betrieb von allen Textur-Mapping-Routinen beschleunigen, die aus einem Bild
in diesem Format zeichnen.

Transpose matrix	; transponiert die Pixelmatrix

Rotate matrix		; Dreht die Pixelmatrix um 90 °, 180 °, 270 °.

******************************************************************************

* Sprites *

Es wird das RAW-Speicherformat im AMIGA SPRITE-Format ausgewählt.

Spritewidth

Sie können die "Spritewidth" auswählen, dh die Breite des Sprites. Wie Sie
wissen, ist es für Amiga OCS und ECS 16 Pixel breit, während es sogar 32 oder
64 Pixel in den mit AGA ausgestatteten Amigas wie 1200 oder 4000 breit sein
kann.

Attached

Um Sprites mit mehr als 3 Farben anzuzeigen, müssen Sie sie an zwei A's
"anhängen", was zu 15 Farben führt. Durch Setzen von "Attached" wird das Sprite
wie folgt gespeichert:

  +--------------+
  |              |
  |              |
  |   Sprite 0   |
  |              |
  |              |
  +--------------+
  |              |
  |              |
  |   Sprite 1   |
  |              |
  |              |
  +--------------+


CTRLwords

Wenn diese Option festgelegt ist, werden die Steuerbytes am Anfang des
Sprites und Termination am Ende hinzugefügt.
Die Anzahl der zu den Sprite-Daten hinzugefügten Bytes hängt von der Breite
des Sprites ab. Bei 16 Pixel breiten Sprites werden am Anfang 2 Wörter
hinzugefügt und 2 Wörter am Ende. Bei den 32 Pixel breiten Sprites werden
2 Langwörter am Anfang und 2 am Ende hinzugefügt und schließlich werden für
64 Pixel breite Sprites 4 Langwörter am Anfang und 4 am Ende hinzugefügt.
Achten Sie darauf, einen Block mit einer Breite von 16, 32 oder 64 Pixel
auszuwählen. Es speichert auch die zusätzlichen Pixel nach dem Sprite.

******************************************************************************

* WB icon *	; Speichern Sie die Figur als Symbol für WorkBench

* Fontset *	; Speichert die Figur als Standard-Amiga-Schriftart, aber nicht dort
			; interessant wenn wir unsere eigenen Routinen
			; zum Drucken unsere Schriften verwenden!
			
IFF ILBM	; Speichern des aktuellen Blocks oder Bildes als IFF.
			; Es kann verwendet werden, um eine alte RAW zu konvertieren, von
			; der Sie die ursprüngliche IFF verloren haben.

SNES modes	; Speichern im Super Nintendo-Format! Es ist uns egal.

Megadrive	; Speichern im Sega Megadrive-Format! Es ist uns egal.

******************************************************************************

*****************
* Paletteformat *
*****************

Die Einstellungen in diesem Fenster bestimmen, wie die Palette gespeichert wird
mit dem Befehl "Project/Save palette":

4 bits		; Standard-OCS / ECS-Modus mit 4 Bit pro RGB-Komponente.
			; 1 word für Farbe $0RGB.

8 bits		; AGA-Modus mit 8 Bit pro RGB-Komponente, 1 Langwort pro Farbe
			; $00RRGGBB. Zum Beispiel ist $00FF0000 hellrot, während
			; $0000ff00 ist hellgrün. Das erste Byte wird nicht verwendet
			; auf Null gesetzt, das zweite ist ROT, gefolgt von GRÜN und BLAU.

32 bits		; speichen von 32 Bit pro RGB-Komponente, 3 Langwörter pro Farbe.
			; (es scheint nicht sehr nützlich zu sein!)

LoadRGB4	; OCS/ECS - Für Funktionen des Betriebssystems, kein Interesse.

LoadRGB32	; AGA - Für Funktionen des Betriebssystems, kein Interesse.

IFF ILBM	; IFF-Format der Palette, zum Beispiel zum Laden mit Dpaint

SNES 5 bits		; kein Interesse...

Megadrive 3 bit ; kein Interesse...

VGA 6 bits	; Dies ist das MS-DOS VGA-Format mit einer Palette
			; von 64 * 64 * 64 = 262144 mögliche Farben anstelle der 16 Millionen
			; der AGA. Dies liegt daran, dass jede RGB-Komponente aus 6 Bits statt 8 
			; besteht. Jede Farbe belegt 1 Langwort und ist zusammengesetzt aus den
			; Bits 0-5 = BLAU, 6-11 = GRÜN, 12-17 = ROT, 18-31 nicht benutzt
			; Zum Beispiel ist das leuchtende Rot:

			  %00000000.00000011.11110000.00000000
										    ^^^^^^blau
									 ^^^^.^^grün
							  ^^.^^^^rot
			   ^^^^^^^^.^^^^^^nicht benutzt

Copperlist	; Speichern Sie die Palette als copperlist mit den Farb-Registern,
			; um direkt in unsere copperliste aufgenommen zu werden.
			; Wenn "4 Bits pro Komponente" ausgewählt sind, wird eine
			; OCS / ECS-copperliste gespeichert, wenn "8 Bits" ausgewählt sind,
			; wird die AGA-Palette gespeichert.

******************************************************************************

*****************
* Grid settings *
*****************

Das Speichern des "Rasters" ist in der nicht registrierten Version deaktiviert.

******************************************************************************

*****************
* Miscellaneous *
*****************

* Seite 1: *

Always open panel	; So rufen Sie das Koordinatenfeld auf
					; Jedes Mal, wenn eine neue Figur geladen wird.

Auto save prefs on exit	; In der nicht registrierten Version deaktiviert

Confirm loads		; Jeder neue Load müssen Sie bestätigen.

Confirm overwrites	; Fragt den Benutzer, ob er die Dateien überschreiben soll

Confirm quit		; Er bittet um Bestätigung des Ausgangs.

Include pen 0 in penstats ; Schließt die Farbe 0 in die Statistik ein oder nicht
				; Farben (Menü Miscellaneous/Frame Manipulation))

Inform saves	; Informiert Sie jedes Mal, was gespeichert wurde.

Lock mode		; Sperrt einen Videomodus und laden Sie alle Bilder in diesem
				; Videomodus FÜR STÄRKE.

Requesters on Workbench ; Damit requester auf der WorkBench angezeigt werden
			; (zum Beispiel für die Palette, die Sie lesen, nicht sehr gut).

Save Autoscan offsets	; Bei Verwendung der Autoscan-Funktion
			; alle Blöcke haben die gleiche Größe, es kann nicht helfen.

* Seite 2: *

Set filecomments	; Wenn diese Option aktiviert ist, werden RAW-Bilder erstellt
		; gespeichert mit dem Format und als Kommentardatei die Größe des Blocks.
		; Um den Kommentar von der Datei zu sehen
		; einfach eine "Dateinamenliste" aus Shell erstellen.
		; Nützlich, um das Format nicht zu vergessen
		; .RAW-Datei.

Use asm 'Sections'	; Entfernen Sie diese Option, um die Direktive 
		; "section" beim Speichern von Assembler-Quellen zu entfernen.

Use mousecoordinates	; Koordinaten löschen.

Use reqtools.library	; Verwenden Sie Reqtools Requester anstelle von ASL.

******************************************************************************

**************
* Image load *
**************

Stellen Sie die Parameter der zu ladenden Figur mit "Project/Load image" ein.
Nützlich zum Einstellen der Breite, Höhe und Anzahl der Bitebenen eines RAW 
Bildes das wieder in IFF konvertiert werden soll. Sie müssen auch auswählen, 
ob das Bild normal, HAM oder Extra HalfBrite ist.

******************************************************************************

*******************
* Set new grabpen *
*******************

Wählen Sie eine neue Farbe für die Funktion "Edit/Grab frame".

******************************************************************************

		*********************************
		*	MENU Miscellaneous	*
		*********************************

Untermenü:

************
* Panel... *
************

Open panel	; Öffnet das Bedienfeld mit x- und y-Koordinaten.

Close panel	; Schließt das Bedienfeld

****************
* Animation... *
****************

Next cell	; Nächstes Bild der Animation

Prev cell	; Vorheriger Frame

*************************
* Image manipulation... *
*************************

Trace pens	; Diese Funktion findet alle nicht verwendeten oder verwendeten Farben
		; zweimal in der Palette und verschiebt es bis zum Ende. Wenn die
		; die Anzahl der nicht verwendeten oder duplizierten Farben ist so, dass eine
		; oder mehr Bitebenen nicht erforderlich sind (zum Beispiel wenn sie
		; 13 Farben in einem 5-Bitebenen-Bild verwenden.
		; Die Zahl wird um 1 Bitebene oder mehr skaliert.
		; Nützlich zum Entfernen unnötiger Bitebenen

EHB->normal	; Konvertieren Sie eine EHB-Figur mit 6 Bitebenen (mit 32 Farben
		; editierbar) in einer AGA-Figur mit 6 Bitebenen (mit 64 Farben
		; real und editierbar).

Remove plane	; entfernen letzte bitplane.

Append plane	; Fügt eine zusätzliche Bitebene hinzu (natürlich gelöscht)

Make gray		; Verwandeln Sie die Palette in Grautöne.

Make brighter	; Erhöhen Sie die Helligkeit

Make darker		; Verdunkelt die Figur

Make negative	; Generieren Sie das Negativ des Bildes

Scale size		; Reduziert das Bild.

Scale depth		; Reduziert die Anzahl der Bitebenen

Reselect pens	; Ändern Sie die Farben der Menüs
				; (wenn sie falsch gelesen werden).

*************************
* Frame manipulation... *
*************************

Pen stats	; zeichnet ein Histogramm der Verwendung von Farben
			; im ausgewählten Rechteck

Remap pens	; Sie können alle Pixel von einer Farbe in einer anderen Farbe 
			; verschieben oder austauschen. Diese Funktion funktioniert im
			; ausgewählten Rechteck.

*******************
* SNES support... *
*******************

Fake SNES		; kein Interesse...

Remake Amiga	; kein Interesse...

