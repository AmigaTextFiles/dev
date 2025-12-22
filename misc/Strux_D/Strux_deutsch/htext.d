
        Hilfstexte zu Strux
        © 1992 by Andreas Günther
        
      \        bedeutet "neue Zeile"

      #m xyyz  Menühilfe
               x  ist die Menü-Nummer,
               yy ist die Item-Nummer,
               z  ist die SubItem-Nummer

      #w xx    Fensterhilfe
               xx ist die Fensternummer

      #e xx    Begriffserklärung, die Nummern xx müssen in aufsteigender
               Reihenfolge sein

      #c       Auflistung der Begriffe in Reihenfolge

      "#" muß am Anfang der Zeile stehen, der Titel in der nächsten Zeile
      und ab der folgenden Zeile der Hilfstext. Der Text kann mit "#"
      beendet werden.


#m 0000
Menü: Projekt
In diesem Menü sind sämtliche Funktionen zu finden, die
das gesamte Projekt betreffen.

#m 0010
Menüpunkt: Projekt » neu
Es wird das gesamte Diagramm mit allen
Verfeinerungen gelöscht, sodaß ein neues Projekt begonnen werden kann.\
Der Inhalt des Zwischenspeichers bleibt dabei erhalten.

#m 0020
Untermenü: Projekt » öffnen
Ein neues Diagramm wird geladen.\
Das gerade bearbeitete Diagramm wird dabei gelöscht. Wurde es
seit dem letzten Speichern verändert, so wird darauf hingewiesen und auf
eine Bestätigung gewartet.

#m 0021
Menüpunkt: Projekt » öffnen » Strux-Diagramm ...
Ein Projekt im Strux-Format wird geladen.\
Das gerade bearbeitete Diagramm wird dabei gelöscht. Wurde es
seit dem letzten Speichern verändert, so wird darauf hingewiesen und auf
eine Bestätigung gewartet.\
Das Projekt wird in einem Dateiauswahlfenster gewählt und anschließend
geladen. Wenn "Abbrechen" angeklickt wird, bleibt das alte Diagramm
erhalten.\\
Der Pfad, in dem sich die Diagrammdateien befinden, kann im Menüpunkt
"Einstellungen » Programm ..." eingestellt und gespeichert werden.\\
Ein Projekt im Strux-Format kann auch geladen werden, indem sein
Piktogramm von der Workbench auf das Strux-Fenster geschoben wird.

#m 0022
Menüpunkt: Projekt » öffnen » Text ...
Ein Programm wird als Quelltext (in der Programmiersprache "Pascal" oder "C")
geladen und als Diagramm dargestellt.\
Das gerade bearbeitete Diagramm wird dabei gelöscht. Wurde es
seit dem letzten Speichern verändert, so wird darauf hingewiesen und auf
eine Bestätigung gewartet.\
Der Quelltext wird in einem Dateiauswahlfenster gewählt und anschließend
geladen. Wenn "Abbrechen" angeklickt wird, bleibt das alte Diagramm
erhalten.\
Anschließend muß die Programmiersprache gewählt werden, in welcher der
Quelltext verfaßt ist.\
Der Text wird nun geladen und ein Auswahlfenster gezeigt, in welchem
sämtliche Programmteile (Prozeduren bzw. Funktionen) des Programms aufgelistet
sind. Es kann nun der Programmteil gewählt werden, welcher geladen werden soll.
Der Ladevorgang läßt sich auch in diesem Schritt noch abbrechen.\
Nach Anklicken des Symbols "Laden" wird der gewählte Programmteil mit sämtlichen
Verfeinerungen übersetzt und angezeigt.\\
Der Pfad, in dem sich die Textdateien befinden, kann im Menüpunkt
"Einstellungen » Programm ..." eingestellt und gespeichert werden.


#m 0040
Menüpunkt: Projekt » speichern
Das Diagramm wird im Strux-Format gespeichert. Dabei wird der
zuletzt beim Laden oder Speichern benutzte Dateiname verwendet.

#m 0050
Untermenü: Projekt » speichern als
Das momentan bearbeitete Diagramm wird gespeichert. Dabei kann das
Format und der benutzte Dateiname gewählt werden.

#m 0051
Menüpunkt: Projekt » speichern als » Strux-Diagramm ...
Das Diagramm wird im Strux-Format gespeichert.\
Der Name wird in einem Dateiauswahlfenster gewählt, anschließend
wird das Diagramm unter diesem Namen gespeichert. Wenn "Abbrechen" angeklickt 
wird, so wird das Diagramm nicht gespeichert und ein evtl. bereits unter
dem Namen auf der Disk vorhandenes Diagramm bleibt erhalten.\
Ob zu dem Diagramm ein Piktogramm erzeugt wird, kann im Menüpunkt
"Einstellungen » Piktogramme erzeugen ?" eingestellt werden.\\
Der Pfad, in dem sich die Diagrammdateien befinden, kann im Menüpunkt
"Einstellungen » Programm ..." eingestellt und gespeichert werden.

#m 0052
Menüpunkt: Projekt » speichern als » Text ...
Das Diagramm wird als Text gespeichert.\
Der Name wird in einem Dateiauswahlfenster gewählt, anschließend
wird das Diagramm als Text unter diesem Namen gespeichert. Wenn "Abbrechen"
angeklickt wird, so wird das Diagramm nicht gespeichert und eine evtl.
bereits unter dem Namen vorhandene Datei bleibt erhalten.\
Bei der Übersetzung des Diagramms in einen Text wird die eingestellte
Übersetzungstabelle benutzt. Sie läßt sich im Menüpunkt "Einstellungen »
Übersetzungstabelle" einstellen. Der Text wird im ASCII-Format gespeichert.\
Falls noch keine Übersetzungstabelle eingestellt wurde, wird eine
Fehlermeldung ausgegeben und man bekommt die Möglichkeit, eine Tabelle
zu öffnen.\
Ob zu dem Text ein Piktogramm erzeugt wird, kann im Menüpunkt
"Einstellungen » Piktogramme erzeugen" eingestellt werden.\\
Der Pfad, in dem sich die Textdateien befinden, kann im Menüpunkt
"Einstellungen » Programm ..." eingestellt und gespeichert werden.

#m 0053
Menüpunkt: Projekt » speichern als » Grafik ...
Das Diagramm wird als Grafik gespeichert.\
Der Name wird in einem Dateiauswahlfenster gewählt, anschließend
wird das Diagramm als Grafik unter diesem Namen gespeichert. Wenn "Abbrechen"
angeklickt wird, so wird das Diagramm nicht gespeichert und eine evtl.
bereits unter dem Namen vorhandene Datei bleibt erhalten.\
Die Grafik wird im üblichen IFF-ILBM-Format gespeichert.\
Ob zu der Grafik ein Piktogramm erzeugt wird, kann im Menüpunkt
"Einstellungen » Piktogramme erzeugen" eingestellt werden.\\
Der Pfad, in dem sich die Grafikdateien befinden, kann im Menüpunkt
"Einstellungen » Programm ..." eingestellt und gespeichert werden.

#m 0070
Untermenü: Projekt » drucken
Das Diagramm wird ausgedruckt. Dabei werden die in Drucker-Voreinstellern
(auf der Workbench) gemachten Einstellungen benutzt, z.B. der Druckertyp
oder das Format.

#m 0071
Menüpunkt: Projekt » drucken » Alles
Das gesamte Diagramm (mit sämtlichen Verfeinerungen) wird ausgedruckt.\
Es erscheint ein Fenster, in welchem der Ausdruck abgebrochen werden kann.\
Die in den Drucker-Voreinstellern (auf der Workbench) gemachten Einstellungen werden
benutzt, z.B. der Druckertyp oder das Format.

#m 0072
Menüpunkt: Projekt » drucken » Angezeigtes
Das momentan angezeigte Diagramm (ohne Verfeinerungen) wird ausgedruckt.\
Es erscheint ein Fenster, in welchem der Ausdruck abgebrochen werden kann.\
Die in den Drucker-Voreinstellern (auf der Workbench) gemachten Einstellungen werden
benutzt, z.B. der Druckertyp oder das Format.

#m 0073
Menüpunkt: Projekt » drucken » Clip
Der Inhalt des Zwischenspeichers (mit sämtlichen Verfeinerungen) wird ausgedruckt.\
Es erscheint ein Fenster, in welchem der Ausdruck abgebrochen werden kann.\
Die in den Drucker-Voreinstellern (auf der Workbench) gemachten Einstellungen werden
benutzt, z.B. der Druckertyp oder das Format.

#m 0090
Menüpunkt: Projekt » Info ...
Informationen über das Programm.\
Der Name des Public-Schirms, auf welchem sich Programm gerade befindet,
wird hier angezeigt.

#m 0110
Menüpunkt: Projekt » Strux verlassen ...
Das Programm wird beendet. Vorher erscheint jedoch eine Sicherheitsabfrage,
in welcher die Wahl wieder rückgängig gemacht oder das
Diagramm noch gespeichert werden kann, wenn es seit dem letzen Speichern
oder Laden verändert wurde. (Das Diagramm wird dann im Strux-Format
gespeichert, es erscheint ein Dateiauswahlfenster)\
Vor dem endgültigen Beenden des
Programms sollte man sicher sein, daß alle wichtigen Sachen gespeichert sind.

#m 1000
Menü: Bearbeiten
Hier sind alle Funktionen zu finden, die zur Bearbeitung des Diagramms
wichtig sind.

#m 1010
Menüpunkt: Bearbeiten » Ausschneiden
Wenn kein Bereich markiert ist, so wird der aktuelle Block ausgeschnitten
und im Zwischenspeicher abgelegt.\
Ist jedoch ein Bereich markiert (siehe Menüpunkt "Bearbeiten » Bereich
Markieren"), so wird der gesamte markierte Bereich ausgeschnitten und im
Zwischenspeicher abgelegt.\
Der vorherige Inhalt des Zwischenspeichers geht dabei verloren !\
Es werden jeweils sämtliche Hauptverfeinerungen ausgeschnitten, d.h. alle
andersfarbig angezeigten. (siehe Menüpunkt "Verfeinerungen »
Hauptverfeinerung setzen")\
Der Inhalt des Zwischenspeichers kann z.B. anschließend an eine beliebige
Stelle eingefügt werden (mit dem Menüpunkt "Bearbeiten » Einfügen").\\
Die Texte der ausgeschnittenen Blöcke können auch von anderen Programmen
eingefügt werden, sofern sie den Zwischenspeicher (engl. "Clipboard") unterstützen.
Um Störungen mit anderen Programmen zu vermeiden, die auch den Zwischenspeicher
benutzen, kann die "Zwischenspeicher-Nummer" im Menüpunkt
"Einstellungen » Programm ..." geändert werden.\\
Wenn der Block sich selbst ausschneiden würde (durch Rekursion), so ist dieser
Menüpunkt gesperrt.


#m 1020
Menüpunkt: Bearbeiten » Kopieren
Wenn kein Bereich markiert ist, so wird der aktuelle Block im Zwischenspeicher
abgelegt, jedoch nicht aus dem Diagramm gelöscht.\
Ist jedoch ein Bereich markiert (siehe Menüpunkt "Bearbeiten » Bereich
Markieren"), so wird der gesamte markierte Bereich im
Zwischenspeicher abgelegt.\
Der vorherige Inhalt des Zwischenspeichers geht dabei verloren !\
Es werden jeweils sämtliche Hauptverfeinerungen mitkopiert, d.h. alle
andersfarbig angezeigten. (siehe Menüpunkt "Verfeinerungen »
Hauptverfeinerung setzen")\
Der Inhalt des Zwischenspeichers kann z.B. anschließend an eine beliebige
Stelle eingefügt werden (mit dem Menüpunkt "Bearbeiten » Einfügen").\\
Die Texte der kopierten Blöcke können auch von anderen Programmen
eingefügt werden, sofern sie den Zwischenspeicher unterstützen.\
Um Störungen mit anderen Programmen zu vermeiden, die auch den Zwischenspeicher
benutzen, kann die "Zwischenspeicher-Nummer" im Menüpunkt
"Einstellungen » Programm ..." geändert werden.

#m 1030
Menüpunkt: Bearbeiten » Einfügen
Der Inhalt des Zwischenspeichers wird hinter dem aktuellen Block in das Diagramm
eingefügt.\
Dabei bleibt der Inhalt erhalten und kann so an mehreren Stellen
eingefügt werden.

#m 1040
Menüpunkt: Bearbeiten » Ändern
Die Eigenschaften (Text oder Typ) des aktuellen Blocks können geändert werden.

#m 1041
Menüpunkt: Bearbeiten » Ändern » Text ...
Der Text des aktuellen Block kann geändert werden.\
Dazu erscheint ein Fenster,
in welchem der Text angezeigt wird und geändert werden kann.\
Wird die Eingabe mit RETURN oder durch Anklicken von "OK" beendet,
so wird der neue Text übernommen.\
Dagegen bleibt bei "Abbrechen" oder betätigen des Schließsymbols
der alte Text erhalten.

#m 1042
Menüpunkt: Bearbeiten » Ändern » Typ ...
Der Typ des aktuellen Blocks kann geändert werden.\
Dazu erscheint ein Fenster, in welchem eine Liste der möglichen Typen
für diesen Block angezeigt wird. Wenn nun ein Typ aus der Liste
ausgewählt und "OK" angeklickt wird, so wird dieser für den aktuellen
Block übernommen.\
Bei der Wahl von "Abbrechen" oder Betätigen des Schließsymbols wird der alte
Typ beibehalten.

#m 1060
Menüpunkt: Bearbeiten » Löschen
Wenn kein Bereich markiert ist, so wird der aktuelle Block unwiderruflich
gelöscht.
Ist jedoch ein Bereich markiert (siehe Menüpunkt "Bearbeiten » Bereich
Markieren"), so wird der gesamte markierte Bereich unwiderruflich gelöscht.\
Es werden jeweils sämtliche Hauptverfeinerungen gelöscht, d.h. alle
andersfarbig angezeigten. (siehe Menüpunkt "Verfeinerungen »
Hauptverfeinerung setzen")\\
Wenn der Block sich selbst löschen würde (durch Rekursion), so ist dieser
Menüpunkt gesperrt.

#m 1080
Menüpunkt: Bearbeiten » Bereich markieren
Der aktuelle Block wird als Anfang eines Bereichs definiert, der mehrere
Blöcke umfaßt.\
Wird der aktuelle Block nun nach unten bewegt oder ein
darunterliegender mit der Maus angeklickt, so vergrößert sich der markierte
Bereich. Ein markierter Bereich kann nun ausgeschnitten oder kopiert werden.
(Menüpunkte "Bearbeiten » Ausschneiden" bzw. "Bearbeiten » Kopieren")\
Ein Bereich kann auch dadurch markiert werden, daß man den ersten Block
des gewünschten Bereichs mit der Maus anklickt und dann die Maus mit
gedrückter (linker) Maustaste über den zu markierenden Bereich zieht.\
Während ein Bereich markiert wird, erscheint in der Titelleiste des
Bildschirms ein "M".\\
Die Markierung kann abgebrochen werden, wenn dieser Menüpunkt nocheinmal
ausgewählt wird, ein Block oberhalb des Anfangsblocks angeklickt wird oder
eine Stelle außerhalb des Diagramms angeklickt wird.

#m 1100
Menüpunkt: Bearbeiten » Öffne Clip ...
Ein Diagramm im Strux-Format wird in das Zwischenspeicher geladen.\
Der vorherige Inhalt des Zwischenspeichers geht dabei verloren.\
Das Diagramm wird in einem Dateiauswahlfenster gewählt und anschließend
geladen. Es kann dann z.B. an einer beliebige Stelle eingefügt werden.
(siehe "Bearbeiten » Einfügen")\
Wenn "Abbrechen" angeklickt wird, bleibt der alte Inhalt
des Zwischenspeichers erhalten.\\
Der Pfad, in dem sich die Diagrammdateien befinden, kann im Menüpunkt
"Einstellungen » Programm ..." eingestellt und gespeichert werden.

#m 1110
Untermenü: Bearbeiten » Speichere Clip als
Der Inhalt des Zwischenspeichers wird auf Disk gespeichert.

#m 1111
Menüpunkt: Bearbeiten » Speichere Clip als » Strux-Diagramm ...
Der Inhalt des Zwischenspeichers wird im Strux-Format auf Disk gespeichert.\
Der Name wird in einem Dateiauswahlfenster gewählt, anschließend
wird der Zwischenspeicher-Inhalt unter diesem Namen gespeichert. Wenn "Abbrechen"
angeklickt wird, so wird nicht gespeichert und eine evtl. bereits unter
dem Namen vorhandenes Datei bleibt erhalten.\
Ob zu der Datei ein Piktogramm erzeugt wird, kann im Menüpunkt
"Einstellungen » Piktogramme erzeugen" eingestellt werden.\\
Der Pfad, in dem sich die Diagrammdateien befinden, kann im Menüpunkt
"Einstellungen » Programm ..." eingestellt und gespeichert werden.

#m 1112
Menüpunkt: Bearbeiten » Speichere Clip als » Text ...
Der Inhalt des Zwischenspeichers wird als Text auf Disk gespeichert.\
Der Name wird in einem Dateiauswahlfenster gewählt, anschließend
wird der Zwischenspeicher-Inhalt als Text unter diesem Namen gespeichert. Wenn "Abbrechen"
angeklickt wird, so wird nicht gespeichert und eine evtl.
bereits unter dem Namen vorhandene Datei bleibt erhalten.\
Bei der Übersetzung des Diagramms in einen Text wird die eingestellte
Übersetzungstabelle benutzt. Sie läßt sich im Menüpunkt "Einstellungen »
Übersetzungstabelle" einstellen. Der Text wird im ASCII-Format gespeichert.\
Ob zu dem Text ein Piktogramm erzeugt wird, kann im Menüpunkt
"Einstellungen » Piktogramme erzeugen" eingestellt werden.\\
Der Pfad, in dem sich die Textdateien befinden, kann im Menüpunkt
"Einstellungen » Programm ..." eingestellt und gespeichert werden.

#m 1113
Menüpunkt: Bearbeiten » Speichere Clip als » Grafik ...
Der Inhalt des Zwischenspeichers wird als Grafik auf Disk gespeichert.\
Der Name wird in einem Dateiauswahlfenster gewählt, anschließend
wird der Zwischenspeicher-Inhalt als Grafik unter diesem Namen gespeichert. Wenn
"Abbrechen" angeklickt wird, so wird nicht gespeichert und eine evtl.
bereits unter dem Namen vorhandene Datei bleibt erhalten.\
Die Grafik wird im üblichen IFF-ILBM-Format gespeichert.\
Ob zu der Grafik ein Piktogramm erzeugt wird, kann im Menüpunkt
"Einstellungen » Piktogramme erzeugen" eingestellt werden.\\
Der Pfad, in dem sich die Grafikdateien befinden, kann im Menüpunkt
"Einstellungen » Programm ..." eingestellt und gespeichert werden.

#m 2000
Menü: Verfeinerungen
In diesem Menü sind alle Funktionen zur Verfeinerung von Blöcken zu finden.
Durch eine Verfeinerung kann die Funktion eines Blocks durch ein weiteres
Diagramm genauer spezifiziert werden.

#m 2010
Menüpunkt: Verfeinerungen » Block verfeinern
Der aktuelle Block wird verfeinert, d.h. er wird einem eigenen Diagramm
genauer definiert.\
Es erscheint ein neues Diagramm auf dem Bildschirm, welches als Überschrift
den Namen des Blocks enthält, der verfeinert wurde. Dieses Diagramm kann
wie gewohnt bearbeitet und noch weiter verfeinert werden.\
Ein verfeinerter Block wird durch Fettdruck angezeigt, wenn der Menüpunkt
"Verfeinerungen » Zeigen ?" eingeschaltet ist.\
Wenn ein Block schon verfeinert wurde, so gelangt man auch durch einen
Doppelklick auf den Block in die Verfeinerung.\\
Mit dem Menüpunkt "Verfeinerungen » Zurück zu höherer Ebene" kommt man zum
Block zurück, der verfeinert wurde.

#m 2020
Menüpunkt: Verfeinerungen » Zurück zu höherer Ebene
Es wird aus einer Verfeinerung in die nächsthöhere Ebene zurückgekehrt. Der
aktuelle Block ist danach der Block, welcher verfeinert wurde.\\
Man gelangt durch einen Doppelklick auf den oberen Rand des Diagramms
ebenfalls in die nächsthöhere Ebene.

#m 2030
Menüpunkt: Verfeinerungen » Zu höchster Ebene
Es wird zur höchsten Ebene zurückgekehrt.

#m 2050
Menüpunkt: Verfeinerungen » Zeigen ?
Hier wird ein- oder ausgeschaltet, ob alle Blöcke, die verfeinert wurden,
markiert werden.\
Sämtliche Blöcke, welche verfeinert wurden, werden in Fettdruck angezeigt.
Ein Block davon wird zusätzlich mit einer anderen Farbe angezeigt, an diesem
Block hängt die eigentliche Verfeinerung. Alle Operationen, die mit diesem
Block ausgeführt werden (Ausschneiden, Kopieren, Drucken usw.) haben dann
Wirkung auf die Verfeinerung.\
Die Markierung hat den Vorteil, daß man sofort erkennt, welche Blöcke schon
verfeinert wurden.

#m 2060
Untermenü: Verfeinerungen » Verfeinerungen zu "Subroutine"
In diesem Untermenü kann eingestellt werden, ob Verfeinerungen als 'Subroutine'
dargestellt werden sollen.\
Dies kann nützlich sein, da z.B. bei der Speicherung
als Text 'Subroutine's anders (z.B. als Prozeduraufruf) übersetzt
werden als andere Typen.

#m 2061
Menüpunkt: Verfeinerungen » Verfeinerungen zu "Subroutine" » Automatisch ?
Hier wird eingestellt, ob ein verfeinerter Block automatisch in den Typ
'Subroutine' verwandelt wird.\
Dies kann nützlich sein, da z.B. bei der Speicherung
als Text 'Subroutine's anders (z.B. als Prozeduraufruf) übersetzt
werden als andere Typen.\
Die Umwandlung des Typs ist nur bei Blöcken von Typ 'Action', 'Input' und
'Output' möglich. Alle anderen Blöcke behalten ihren Typ.

#m 2062
Menüpunkt: Verfeinerungen » Verfeinerungen zu "Subroutine" » Alle ändern
Sämtliche im Diagramm schon verfeinerten Blöcke erhalten den Typ 'Subroutine'.\
Dies kann nützlich sein, da z.B. bei der Speicherung
als Text 'Subroutine's anders (z.B. als Prozeduraufruf) übersetzt
werden als andere Typen.\
Die Umwandlung des Typs ist nur bei Blöcken von Typ 'Action', 'Input' und
'Output' möglich. Alle anderen Blöcke behalten ihren Typ.\\
ACHTUNG: Die Änderung kann nicht rückgängig gemacht werden.

#m 2070
Menüpunkt: Verfeinerungen » Hauptverfeinerung setzen
Wenn der aktuelle Block (unter dem Cursor) eine Verfeinerung besitzt, 
wird die Verfeinerung an diesen Block angehängt, d.h. er wird andersfarbig
markiert.\
Alle Operationen, die mit diesem
Block ausgeführt werden (Ausschneiden, Kopieren, Drucken usw.) haben dann
Wirkung auf die Verfeinerung.\\
Dieser Menüpunkt kann nicht angewählt werden, wenn sich der Block in einer
Rekursion befindet, d.h. sich direkt oder indirekt selbst verfeinert.



#m 3000
Menü: Hinzufügen
Hier kann ein neuer Block ins Diagramm eingefügt werden.\
Dabei stehen verschiedene Typen zur Verfügung.\
Ein neuer Block wird immer hinter dem aktuellen Block ins Diagramm
eingefügt.\
(in den Hilfstexten stehen in Klammern jeweils die Bezeichnungen nach
DIN 66262 bzw. DIN 66001)

#m 3010
Menüpunkt: Hinzufügen » Aktion ...
Eine einfache Aktion wird hinter dem aktuellen Block ins Diagramm
eingefügt.\
(DIN: Verarbeitung)

#m 3030
Menüpunkt: Hinzufügen » If Then ...
Eine einfache Entscheidung wird hinter dem aktuellen Block ins Diagramm
eingefügt. Der "ELSE"-Teil kann nachträglich hinzugefügt
werden.\
(DIN: Bedingte Verarbeitung)

#m 3040
Menüpunkt: Hinzufügen » If Then Else ...
Eine Entscheidung, bei der einer von zwei Programmzweigen ausgeführt wird,
wird hinter dem aktuellen Block ins Diagramm
eingefügt.\
(DIN: Einfache Alternative)

#m 3050
Menüpunkt: Hinzufügen » Select of ...
Eine Entscheidung, bei der zwischen mehreren Programmzweigen ausgewählt wird,
wird hinter dem aktuellen Block ins Diagramm
eingefügt.\
(DIN: Mehrfache Alternative)

#m 3060
Menüpunkt: Hinzufügen » Case ...
Ein weiterer Zweig wird bei einem 'Select'-Block hinzugefügt.\

#m 3070
Menüpunkt: Hinzufügen » Default/Else ...
An einen 'Select'-Block wird ein 'Default'-Zweig\
oder\
an einen 'If'-Block ein 'Else'-Zweig angefügt.

#m 3090
Menüpunkt: Hinzufügen » While ...
Eine Schleife wird hinter dem aktuellen Block ins Diagramm
eingefügt.\
(DIN: Wiederholung mit vorausgehender Bedingungsprüfung)

#m 3100
Menüpunkt: Hinzufügen » Repeat Until ...
Eine Schleife wird hinter dem aktuellen Block ins Diagramm
eingefügt.\
(DIN: Wiederholung mit nachfolgender Bedingungsprüfung)

#m 3110
Menüpunkt: Hinzufügen » For ... Repeat ...
Eine Zählschleife wird hinter dem aktuellen Block ins Diagramm
eingefügt.\
(DIN: Wiederholung mit vorausgehender Bedingungsprüfung)

#m 3120
Menüpunkt: Hinzufügen » Repeat Forever ...
Eine Endlosschleife wird hinter dem aktuellen Block ins Diagramm
eingefügt.\
(DIN: Wiederholung ohne Bedingungsprüfung)

#m 3130
Menüpunkt: Hinzufügen » Exit
Eine Anweisung, daß die Schleife verlassen werden soll, wird hinter dem
aktuellen Block ins Diagramm eingefügt.\
(DIN: Abbruchanweisung)

#m 3150
Menüpunkt: Hinzufügen » Subroutine ...
Der Aufruf eines Unterprogramms wird hinter dem aktuellen Block ins Diagramm
eingefügt.\
(DIN: Hinweis auf Dokumentation an anderer Stelle)

#m 3160
Menüpunkt: Hinzufügen » Program ...
Der Titel des Programms bzw. Verbindung zu anderen Programmen (im PAP)
wird hinter dem aktuellen Block ins Diagramm
eingefügt.\
(DIN: Verbindungsstelle)

#m 3170
Menüpunkt: Hinzufügen » Input ...
Eine Eingabe wird hinter dem aktuellen Block ins Diagramm
eingefügt.\
(DIN: Manuelle Verarbeitung)\\
Die Darstellung ist die gleiche wie beim Typ 'Output', die Unterscheidung
liegt darin, daß beim Speichern als Text die beiden Typen unterschiedlich
übersetzt werden.

#m 3180
Menüpunkt: Hinzufügen » Output ...
Eine Ausgabe wird hinter dem aktuellen Block ins Diagramm
eingefügt.\
(DIN: Manuelle Verarbeitung)\\
Die Darstellung ist die gleiche wie beim Typ 'Input', die Unterscheidung
liegt darin, daß beim Speichern als Text die beiden Typen unterschiedlich
übersetzt werden.

#m 3190
Menüpunkt: Hinzufügen » Parallel ...
Eine Gleichzeitige Verarbeitung mehrerer Programmzweige (Prozesse)
wird hinter dem aktuellen Block ins Diagramm
eingefügt.\
(DIN: Parallelverarbeitung)

#m 3200
Menüpunkt: Hinzufügen » Process ...
Ein weiterer Programmzweig wird zu einer Parallelverarbeitung hinzugefügt.



#m 4000
Menü: Einstellungen
Hier können sämtliche Einstellungen für das Programm gemacht werden.

#m 4010
Menüpunkt: Einstellungen » Diagramm ...
Es erscheint ein Fenster, in dem alle Einstellungen, welche die Darstellung
des Diagramms betreffen, gemacht werden können.\
Das sind:\
- Die Art der Darstellung (Struktogramm, PAP oder Pseudocode)\
- Der Zeichensatz für jede dieser Arten\\
Weitere Informationen erhält man durch drücken der 'Help'-Taste in
dem Fenster.

#m 4020
Menüpunkt: Einstellungen » Bildschirm ...
Es erscheint ein Fenster, in dem der Bildschirm, auf welchem das Programm
laufen soll, eingestellt werden kann.\
Dabei kann entweder ein bereits geöffneter Public-Schirm ausgewählt
oder ein eigener Bildschirm geöffnet werden.\\
Weitere Informationen erhält man durch drücken der 'Help'-Taste in
dem Fenster.

#m 4030
Menüpunkt: Einstellungen » Programm ...
Es erscheint ein Fenster, in dem alle Einstellungen, welche die Bedienung
des Programms betreffen, gemacht werden können.\
Das sind:\
- Die Pfade für Diagramm-, Text- und Grafikdateien\
- Einstellungen aus den Menüs "Verfeinerungen" und "Einstellungen"\
- Zwischenspeicher-Nummer\\
Weitere Informationen erhält man durch drücken der 'Help'-Taste in
dem Fenster.

#m 4050
Menüpunkt: Einstellungen » Übersetzungstabelle ...
Erstellen einer Übersetzungstabelle für das Speichern als Text.\
Es erscheint ein Fenster, in welchem die Umsetzungen sämtlicher
Programmkonstrukte eingetragen werden können.\
Außerdem kann eine Übersetzungstabelle geladen und gespeichert werden.\\
Weitere Informationen erhält man durch drücken der 'Help'-Taste in
dem Fenster.

#m 4070
Menüpunkt: Einstellungen » Piktogramme erzeugen ?
Hier kann eingestellt werden, ob für eine gespeicherte Datei
(Diagramm, Text oder Grafik) ein Piktogramm erzeugt werden soll.

#m 4080
Menüpunkt: Einstellungen » Workbench ?
Hier wird eingestellt, ob die Workbench geöffnet sein soll.\
Wird dieser Menüpunkt eingeschaltet (abgehakt), so wird versucht,
die Workbench zu öffnen, andernfalls wird versucht, die Workbench zu
schliessen. Sollte dies nicht gelingen, weil etwa noch Programme auf
der Workbench laufen, so erscheint eine Meldung.

#m 4100
Menüpunkt: Einstellungen » öffnen ...
Öffnen einer abgespeicherten Einstellung.\
Es erscheint ein Dateiauswahlfenster, in welchem eine Einstellung
gewählt werden kann. Es werden nur Dateien mit der Endung ".prefs"
angezeigt, um die Einstellungen besser finden zu können.\
Die gewählte Einstellung wird anschließend geladen und das Programm danach
eingestellt.\\
Beim Start von Strux werden die Einstellungen aus der Datei
"Strux.prefs" gelesen. Durch öffnen dieser Einstellung erhält man
also seine Starteinstellung zurück.

#m 4110
Menüpunkt: Einstellungen » speichern
Alle Einstellungen des Programms werden unter dem Namen gespeichert, mit
dem sie geladen wurden.\
Das sind neben den Einstellungen, die in den oberen vier Punkten dieses
Menüs gemacht werden können, noch die Position und Größe des
Strux-Fensters.\\
Beim Start von Strux werden die Einstellungen aus der Datei
"Strux.prefs" gelesen.

#m 4120
Menüpunkt: Einstellungen » speichern als ...
Alle Einstellungen des Programms werden gespeichert.\
Es erscheint ein Dateiauswahlfenster, in welchem der Name gewählt werden
kann, unter dem die momentanen Einstellungen gespeichert werden sollen.
Der Name sollte mit ".prefs" enden, um die Einstellungen später besser
finden zu können und sie von anderen Dateien zu unterscheiden.\
Beim Start von Strux werden die Einstellungen aus der Datei
"Strux.prefs" gelesen. Werden die Einstellungen also unter diesem
Namen im selben Verzeichnis wie Strux gespeichert, startet das
Programm von nun an mit diesen Einstellungen. So kann man
sich seine individuelle Arbeitsumgebung einstellen.\\
Folgende Einstellungen werden gespeichert:\
- Name des Public-Schirms\
- Darstellung auf eigenem Bildschirm ?\
- Größe, Modus, Farben, Zeichensatz des eigenen Bildschirms\
- Größe und Position des Fensters\
- Art der Darstellung
- Zeichensätze für die Arten der Darstellung\
- Einstellungen der Menüs\
- Zwischenspeicher-Nummer\
- Name der Übersetzungstabelle


#w 00
Strux
Im Hauptfenster wird das Diagramm dargestellt. Die Art der Darstellung
kann im Menüpunkt "Einstellungen » Diagramm" gewählt werden. Mit den
Rollbalken läßt sich der sichtbare Ausschnitt verschieben. Der aktuelle
Block wird durch eine inverse Darstellung angezeigt.\
Das Betätigen des Schließsymbols hat die gleiche Wirkung wie der
Menüpunkt "Projekt » Strux verlassen ...".
#

#w 01
Fenster: Typ ändern
Der Typ des aktuellen Blocks kann hier geändert werden.\
Es wird eine Liste der möglichen Typen für diesen Block gezeigt.
Wenn nun ein Typ aus der Liste ausgewählt und "OK" angeklickt wird, so wird
dieser Typ für den aktuellen Block übernommen und das Fenster geschlossen.\
Bei der Wahl von "Abbrechen" oder Betätigen des Schließsymbols wird der alte
Typ beibehalten.
#

#w 02
Fenster: Text eingeben
Wenn dieses Fenster erscheint, wird sofort die Texteingabe aktiviert, man
kann also sofort seinen Text eingeben.\
Wird die Texteingabe mit der Eingabetaste ("RETURN"-Taste) beendet oder
das "weiter"-Symbol angewählt, so wird der Text für den Block übernommen.\
Wenn "Abbrechen" oder das Schließsymbol gewählt wird, so wird die Aktion
abgebrochen und der vorherige Zustand des Diagramms bleibt erhalten.\
Wenn kein Text eingegeben wurde, im Diagramm jedoch einer erwartet wird,
so wird das Fehlen eines Textes durch "???" angezeigt. Soll ein Diagramm
keinen Text enthalten, so kann man die Anzeige von "???" durch Eingabe
eines Leerzeichens als Text unterbinden.
#

#w 03
Fenster: Diagramm-Voreinsteller
In diesem Fenster können alle Einstellungen, welche die Darstellung
des Diagramms betreffen, gemacht werden.\\
Darstellung:\
Hier kann gewählt werden, in welcher Form das Diagramm dargestellt werden
soll.\
- Struktogramm:\
Darstellung als Struktogramm nach Nassi-Shneiderman, die Sinnbilder der
DIN_66261 werden benutzt.\
- PAP:\
Darstellung als Programmablaufplan mit Sinnbildern aus DIN_66001 und
Programmkonstrukten, die in DIN_66262 festgelegt sind.\
- Pseudocode:\
Darstellung in einer Pseudosprache, in welcher die Konstrukte durch
Schlüsselwörter und die Struktur durch Einrückungen beschrieben werden.\\
Schriftart:\
Die gewählte Schriftart für jede der drei Darstellungarten wird gezeigt,
durch Betätigung eines "wählen ..."-Symbols können die Schriftarten geändert
werden. Dazu erscheint ein Zeichensatz-Auswahlfenster.\\
Bedeutung der Symbole "Speichern", "Benutzen", "Abbrechen":\
Alle drei Symbole schließen das Fenster.\
- "Speichern": die Einstellungen dieses Fensters werden gespeichert und
benutzt\
- "Benutzen": die Einstellungen dieses Fensters werden benutzt, gehen jedoch
beim Verlassen von Strux verloren\
- "Abbrechen": die alten Einstellungen bleiben erhalten, keine Änderung wird
übernommen\
Das Schließsymbol des Fensters hat die gleiche Wirkung wie das
"Abbrechen"-Symbol.
#

#w 04
Fenster: Bildschirm-Voreinsteller
Der Bildschirm, auf welchem das Programm laufen soll, kann hier eingestellt
werden.\
Oben im Fenster wird eine Liste aller momentan geöffneten Public-Schirme
gezeigt. Hier kann ein beliebiger Bildschirm ausgewählt werden. Voreingestellt
ist der Bildschirm, auf dem man mit Strux gerade arbeitet.\\
Wird das Auswahlfeld "eigener Bildschirm" eingeschaltet (Häkchen erscheint),
so öffnet Strux einen eigenen Bildschirm, die Auswahl aus der Liste ist
dann wirkungslos. Der eigene Bildschirm ist ein Public-Schirm, d.h. andere
Programme können Fenster auf diesem Bildschirm öffnen. Den Name des
Bildschirms erfährt man im Menüpunkt "Projekt » Info". Das Aussehen
kann durch die Symbole "Modus", "Schrift" und "Farben" festgelegt werden.\
- "Modus": Es erscheint ein Fenster, in dem der Bildschirmmodus eingestellt 
werden kann.\
- "Schriftart": In einem Zeichensatz-Auswahlfenster kann die Schriftart
für den Bildschirm gewählt werden. In dieser Schrift erscheinen die Menüs
und Fenster.\
- "Farben": Es erscheint ein Fenster, in dem die Farben eingestellt werden
können. Die Farbeinstellung ist nur möglich, wenn sich Strux auf einem
eigenen Bildschirm befindet.\\
Bedeutung der Symbole "Speichern", "Benutzen", "Abbrechen":\
Alle drei Symbole schließen das Fenster.\
- "Speichern": die Einstellungen dieses Fensters werden gespeichert und
benutzt, es wird also evtl. ein neuer Bildschirm geöffnet oder auf einen
anderen Public-Schirm gesprungen\
- "Benutzen": die Einstellungen dieses Fensters werden benutzt, es wird also
evtl. ein neuer Bildschirm geöffnet oder auf einen anderen Public-Schirm
gesprungen. Die Einstellungen gehen jedoch beim Verlassen von Strux verloren\
- "Abbrechen": die alten Einstellungen bleiben erhalten, keine Änderung wird
übernommen\
Das Schließsymbol des Fensters hat die gleiche Wirkung wie das
"Abbrechen"-Symbol.
#

#w 05
Fenster: Programm-Voreinsteller
- Pfade:\
Hier können die Pfade für Diagramm-, Text- und Grafikdateien eingestellt
werden. Die aktuellen Pfade werden angezeigt, durch Betätigen eines
"wählen ..."-Symbols kann mit Hilfe eines Verzeichnisauswahlfensters
ein neuer Pfad eingestellt werden.\\
- Verfeinerungen:\
Die Zustände der Menüpunkte "Verfeinerungen » zeigen ?" und 
"Verfeinerungen » Verfeinerungen zu Subroutine » Automatisch ?" können
eingestellt werden.\\
- Sonstiges:\
Die Zustände der Menüpunkte "Einstellungen » Workbench ?" und
"Einstellungen » Piktogramme erzeugen ?" können eingestellt werden.\\
- Zwischenspeicher-Nummer:\
Die Nummer des Zwischenspeichers (für Kopier-, Ausschneide- und
Einfügeoperationen) kann geändert werden. Normalerweise benutzen
alle Programme den Zwischenspeicher mit der Nummer Null, um Daten untereinander
austauschen zu können. Wenn der Datenaustausch aber nicht erwünscht ist,
kann eine andere Zwischenspeicher-Nummer eingestellt werden.\\
Bedeutung der Symbole "Speichern", "Benutzen", "Abbrechen":\
Alle drei Symbole schließen das Fenster.\
- "Speichern": die Einstellungen dieses Fensters werden gespeichert und
benutzt\
- "Benutzen": die Einstellungen dieses Fensters werden benutzt, gehen jedoch
beim Verlassen von Strux verloren\
- "Abbrechen": die alten Einstellungen bleiben erhalten, keine Änderung wird
übernommen\
Das Schließsymbol des Fensters hat die gleiche Wirkung wie das
"Abbrechen"-Symbol.
#

#w 06
Fenster: Bildschirmmodus
Hier wird das Format (Größe und Anzeigemodus) des eigenen Bildschirms
eingestellt.\
Oben im Fenster befindet sich eine Liste aller verfügbaren
Anzeigemodi.
Der gewünschte Modus kann aus dieser Liste gewählt werden.\
Die Breite und Höhe des Bildschirms läßt sich frei wählen, jedoch können
640 Pixel für die Breite und 200 Pixel für die Höhe nicht unterschritten
werden.\
Wenn das Auswahlfeld "Vorgaben" abgehakt ist, so wird die Standardgröße
des gewählten Anzeigemodus eingestellt.\
Im Auswahlfeld "Auto-Rollen" kann eingestellt werden, ob sich der 
Bildschirmausschnitt automatisch verschiebt, wenn die Bildschirmfläche
größer ist als auf dem Monitor darstellbar.\\
Mit "OK" werden diese Einstellungen übernommen, mit "Abbrechen" oder 
durch Betätigen des Schließsymbols bleiben die alten Einstellungen erhalten.
#

#w 07
Fenster: Farben einstellen
Farbeinstellung für den eigenen Bildschirm.\
In der Palette oben wird zunächst die Farbe ausgewählt, welche verändert
werden soll. Mit den Schiebereglern kann der Rot-, Grün- und Blauanteil
eingestellt werden.\
Durch Auswahl des Symbols "Workbenchfarben" wird die Farbeinstellung
der Workbench übernommen.\\
Mit "OK" werden die Farben übernommen, mit "Abbrechen" oder 
durch Betätigen des Schließsymbols bleiben die alten Farben erhalten.
#

#w 08
Fenster: Übersetzungstabelle erstellen
Erstellen einer Übersetzungstabelle für das Speichern als Text.\
Oben im Fenster wird der Name der momentan benutzten Übersetzungstabelle
angezeigt.\
Darunter befindet sich eine Liste, in welcher die Umsetzungen sämtlicher
Programmkonstrukte angezeigt werden. Nach Anklicken eines Eintrags kann
dieser im Texteingabefeld unter der Liste geändert werden.\\
Dabei gibt es einige Steuerzeichen:\
· %n : neue Zeile beginnen\
· %t : Text des Blocks\
· %bn: dazugehöriger Programmzweig, wobei n die Anzahl der Zeichen angibt,
um die der Block eingerückt werden soll\
· %v : (nur bei Hauptprogramm/Verfeinerung): zugehörige Verfeinerungen\\
Außerdem kann eingestellt werden, ob Leerzeichen als Unterstrich
ausgegeben werden. Dies ist bei Namen nützlich, die aus mehreren Worten
bestehen. Wird die Einstellung "nur bei Verf." gewählt, so werden die
Leerzeichen nur bei Namen von Verfeinerungen umgewandelt.\\
Mit "Öffnen ..." und "Speichern als ..." können Übersetzungstabellen geladen
und gespeichert werden, durch "Neu" entsteht eine leere Tabelle.\
"Speichern" speichert die Tabelle unter dem Namen, mit dem sie geladen
wurde und schließt das Fenster.\
Nach "Benutzen" wird die Tabelle benutzt, jedoch nicht abgespeichert.\
Bei "Abbrechen" wird die alte Tabelle beibehalten.
#

#w 10
Fenster: Quelltext laden
In der Liste werden die Namen sämtliche Prozeduren und Funktionen gezeigt,
die im Quelltext vorkommen. Der oberste Eintrag ist das Hauptprogramm,
wenn vorhanden. In C heißt es immer main, in Pascal ist es der Name,
der im Programmtext steht (z.B. ist der Name bei "PROGRAM titel
(INPUT,OUTPUT);..." 'titel').\
Es kann nun der Programmteil gewählt werden, welchen man übersetzt haben
möchte.\
"Laden" lädt den gewünschten Teil mit allen Verfeinerungen.\
"Abbrechen" bricht den Ladevorgang ab.
#

#w 11
Fenster: Hilfe  (dieses Fenster)
In diesem Fenster werden sämtliche Hilfstexte angezeigt.\
Mit dem Rollbalken und den Pfeilen rechts läßt sich der Text verschieben.\\
Es gibt Hilfe zu allen Menüs und Menüpunkten, zu allen Fenstern und zu
einigen Begriffen.\
Die Hilfstexte lassen sich folgendermaßen aufrufen:\\
- Menüs und Menüpunkte:\
Wählen Sie dabei wie gewohnt den Menüpunkt mit der rechten Maustaste
oder zeigen Sie auf einen Menütitel, halten Sie die rechte Maustaste
jedoch gedrückt und drücken Sie die "Help"-Taste. Der Hilfstext wird nun
kurz darauf in diesem Fenster angezeigt.\\
- Fenster:\
Aktivieren Sie das Fenster, indem Sie dort hineinklicken und
drücken die "Help"-Taste. Es erscheint dann ein Hilfstext zu dem Fenster.\\
- Begriffe:\
Wählen Sie das Symbol "Begriffe" unten in diesem Fenster. Es erscheint dann
eine Liste von Begriffen, zu denen Hilfstexte vorhanden sind. Durch Wahl
eines Begriffs (Anklicken mit der Maus)  wird der Hilfstext dazu angezeigt.\\
Wird die Hilfe nicht mehr benötigt, kann das
Fenster durch Betätigen des Schließsymbols entfernt werden.\\
Die Hilfstexte sollen zum schnellen Nachschlagen dienen und setzen
Grundkenntnisse über Strux voraus. Die Grundlagen dieses
Programms sind ausführlich im Handbuch beschrieben.
#


#c
Begriff auswählen:
aktueller Block\
Dateiauswahlfenster\
Diagramm\
Hauptverfeinerung\
Hilfe\
Pfeiltasten\
Strux-Format\
Tastatur\
Zeichensatzauswahlfenster\
Zwischenspeicher
#

#e 00
aktueller Block
Ein Block im Diagramm ist besonders markiert (mit einer anderen Farbe
unterlegt). Dies ist der "aktuelle Block", er entspricht etwa dem Cursor
in einer Textverarbeitung. Z.B. werden neue Blocks immer an diesen Block
angehängt, das Ausschneiden bezieht sich auf diesen Block usw.\
Um einen Block auszuwählen, d.h. ihn zum aktuellen Block zu machen,
klickt man ihn einfach mit der Maus an. Bei Konstrukten wie z.B.
einer Auswahl oder einer Schleife wird stets der gesamte Block mit den
anhängenden Verzweigungen bzw. Schleifenrumpf markiert und als
aktueller Block betrachtet.
#

#e 09
Zwischenspeicher
Wie z.B. bei Textprogrammen üblich, lassen sich auch hier Teile des Diagramms
ausschneiden oder kopieren und an anderer Stelle wieder einfügen. Das
zuletzt ausgeschnittene Teil wird gespeichert, bis das nächste mal etwas
ausgeschnitten oder kopiert wird. Der Speicher, in dem das Teil
zwischengespeichert wird, heißt "Zwischenspeicher".\
Es gibt verschiedene Zwischenspeicher mit den Nummern 0 bis 255.
Normalerweise benutzen
alle Programme den Zwischenspeicher mit der Nummer Null, um Daten untereinander
austauschen zu können. Wenn der Datenaustausch aber nicht erwünscht ist,
kann eine andere Zwischenspeicher-Nummer eingestellt werden. (Menüpunkt "Einstellungen
» Programm ...")
#

#e 01
Dateiauswahlfenster
Um Dateinamen auszuwählen, wird ein Dateiauswahlfenster ("Filerequester")
angezeigt. Dies ist das Standard-Dateiauswahlfenster, welches im
Handbuch zur Workbench ausführlich erklärt wird.\
Für genauere Informationen sollte man dort nachschlagen.
#

#e 03
Hauptverfeinerung
Eine Verfeinerung kann von mehreren Blöcken gleichen Namens aufgerufen werden,
das Diagramm der Verfeinerung existiert aber nur einmal und ist an einem
Block angehängt. Dieser Block ist die "Hauptverfeinerung".
Alle Operationen, die mit diesem Block ausgeführt werden (Ausschneiden,
Kopieren, Drucken usw.) haben dann Wirkung auf die Verfeinerung.\
Ist der Menüpunkt "Verfeinerungen » Zeigen ?" eingeschaltet, so wird dieser
Block andersfarbig beschriftet. Wenn mit den nur durch Fettschrift markierten
Blöcke Operationen ausgeführt werden, so haben diese Operationen keine
Auswirkungen auf die Verfeinerung !
#

#e 04
Hilfe
Im Hilfe-Fenster lassen sich zu allen Menüpunkten, Fenstern und einigen
Begriffen erläuternde Texte anzeigen.\
Während das Hilfe-Fenster angezeigt wird, kann gleichzeitig mit Strux
weitergearbeitet werden. Wird die Hilfe nicht mehr benötigt, kann das
Fenster durch Betätigen des Schließsymbols entfernt werden.\\
Die Hilfstexte lassen sich folgendermaßen aufrufen:\\
- Menüs und Menüpunkte:\
Wählen Sie dabei wie gewohnt den Menüpunkt mit der rechten Maustaste
oder zeigen Sie auf einen Menütitel, halten Sie die rechte Maustaste
jedoch gedrückt und drücken Sie die "Help"-Taste. Der Hilfstext wird nun
kurz darauf in diesem Fenster angezeigt.\\
- Fenster:\
Aktivieren Sie das Fenster, indem Sie dort hineinklicken und
drücken die "Help"-Taste. Es erscheint dann ein Hilfstext zu dem Fenster.\\
- Begriffe:\
Wählen Sie das Symbol "Begriffe" unten in diesem Fenster. Es erscheint dann
eine Liste von Begriffen, zu denen Hilfstexte vorhanden sind. Durch Wahl
eines Begriffs (Anklicken mit der Maus)  wird der Hilfstext dazu angezeigt.
#

#e 05
Pfeiltasten
Es besteht die Möglichkeit, die Pfeiltasten zu benutzen, um den aktuellen
Block zu wechseln. Dabei bedeuten die Tasten folgendes:\\
- ohne SHIFT oder CTRL-Taste:\
"oben"  : springe einen Block nach oben\
"unten" : springe einen Block nach unten\
"rechts": gehe in Verzweigung oder Schleifenrumpf\
"links" : springe einen Block nach oben\\
- mit SHIFT-Taste:\
"oben"  : springe zum nächsthöheren Konstrukt (z.B. aus Schleifenrumpf zurück
in die Schleifenanweisung)\
"unten" : gehe innerhalb der Verzweigung oder des Schleifenrumpfs zum
untersten Block\
"rechts": gehe in letzten Zweig, z.B. be Case-Anweisungen\\
- mit CTRL-Taste:\
"oben"  : springe zum Anfang des Diagramms\
"unten" : springe zum Ende des Diagramms\
#

#e 08
Zeichensatzauswahlfenster
Um Schriftarten (Zeichensätze) auszuwählen, wird ein Zeichensatzauswahlfenster
angezeigt. Dies ist das Standard-Zeichensatzauswahlfenster,
welches im Handbuch zur Workbench ausführlich erklärt wird.\
Für genauere Informationen sollte man dort nachschlagen.
#

#e 07
Tastatur
Sowohl die Menüpunkte als auch die Symbole in den Fenstern können durch
die Tastatur bedient werden, um ein schnelles
Arbeiten zu ermöglichen.\\
- Menüfunktionen:\
Die meisten Funktionen besitzen eine zugehörige Taste. Die zu den Funktionen
gehörenden Tasten stehen in den Menüs und müssen zusammen mit der rechten
AMIGA-Taste betätigt werden.\\
- Symbole in Fenstern:\
In den Fenstern können die Symbole, bei denen ein Buchstabe unterstrichen
ist mit der Buchstabentaste des unterstrichenen Buchstabens betätigt
werden. Listen kann man mit den Pfeiltasten durchblättern.
#

#e 02
Diagramm
Das gerade bearbeitete Projekt wird allgemein als "Diagramm" bezeichnet, da es
auf unterschiedliche Arten dargestellt werden kann, und zwar als Struktogramm,
Programmablaufplan (PAP) oder als Pseudocode (in Textform).\
Die Art der Darstellung kann im Diagramm-Voreinsteller gewählt werden, der
mit dem Menüpunkt "Einstellungen » Diagramm" erreicht werden kann.
#

#e 06
Strux-Format
Wird beim Speichern auf Disk das Strux-Format benutzt, wird das Diagramm
in allen Einzelheiten gespeichert, sodaß es nach dem Laden unverändert zur
Verfügung steht. Dieses Format kann jedoch von anderen Programmen nicht gelesen
werden.\
Wird das Diagramm als Text oder Grafik gespeichert, läßt es sich mit Strux nicht
vollständig rekonstruieren, da einige Informationen verloren gehen. Allerdings
kann es so mit anderen Programmen weiterverarbeitet werden.
#
