@database TransCat
@author "zIgUS"
@node "Main" "TransCat_Deutsch.guide"
@$ver: TransCat documentation 1.20 [08.09.99]
@remark Translated by Dirk Neubauer <dirk.neubauer@guestrow.netsurf.de>


                              @{b}TransCat@{ub} v1.20
                              **************
                               [08.09.1999]


             @{"   Copyright    " link "Copyright"}  Rechtliche Informationen über TransCat.
             @{"  Installation  " link "Installation"}  Wie installiert man TransCat.
             @{"   Einführung   " link "Introducting"}  Einführung in TransCat.
             @{"   Benutzung    " link "Use"}  Wie benutzt man TransCat.
             @{"  Zukünftiges   " link "The Futur"}  Die Zukunft von TransCat.
             @{"   Geschichte   " link "Historic"}  Und immer wieder die Geschichte...
             @{"  Übersetzung   " link "Translation"}  Übersetzung der Kataloge.

             @{"    Kontakt     " link "Contact"}  Meine Adresse.
@EndNode


@Node "Copyright" "Rechtliche Informationen über TransCat."

 Wichtig :
 =========

 TransCat ist © 1998-1999 bei zIgUS. Alle Rechte vorbehalten.

 TransCat ist Shareware. Durch Bezahlen von 50 FF, 15 US$ oder 25 DM kannst
 du dich @{"registrieren" link "Registration"} und erhältst eine Vollversion.

 Die Demoversion kann frei vertrieben werden.
 Die registrierten Nutzer dürfen ihre Version nicht weitergeben.

 TransCat wird vertrieben, wie es ist, ohne jegliche Garantie, klar und deutlich.
 In keinem Fall kann der Autor für irgendwelche Schäden, direkt oder indirekt,
 oder Missgeschicke oder Datenverluste durch Nutzung und Anwendung dieser Software
 haftbar gemacht werden. Das ganze Risiko der Nutzung liegt beim Nutzer.

 Sämtliche mitgelieferten Dateien des Archives dürfen nicht verändert werden.
 Jede veränderte Version sollte gemeldet werden.

 Ich warne vor der Benutzung modifizierter Version. Man kann damit unglückliche
 Überraschungen erleben. Sie fördern auch nicht gerade die zukünftige Entwicklung
 von TransCat.
@EndNode


@Node "Registration" "Registrierung für TransCat."

 TransCat ist Shareware, diese Demoversion besitzt folgende Einschränkungen :

  · Man kann keine Katalogübersetzungen (.ct) speichern.
  · Der Name des Autors steht nicht im Katalog.

 Die Vollversion erhält man durch Bezahlung der Registrationsgebühr.

 Diese kostet :  50 FF 15US$ 25 DM

 Die Bezahlung gilt nur, wenn ich nach dem Wechseln wirklich 50 FF erhalte.
 Falls ich weniger als 50 FF bekomme, musst du nachbezahlen.

 Falls du einen Drucker hast, drucke den Registrationstext aus.


 Schicke diesen bitte an mich mit deinen Eintragungen :

      K L A X
      P.O. Box 14
      21601 Longvic CEDEX
      France


 Die Registrierung wird noch am selben Tag bearbeitet und nächsten Tag verschickt.

 Ich werde mich bei dir für die Unterstützung meiner Arbeit bedanken.
 Denke daran : Ein Softwarekauf führt zur Weiterentwicklung dieser !
@EndNode

@Node "Installation" "Wie installiert man..."

 @{b}Installation@{ub}

 Nicht sehr schwer !

 Du musst nur das Verzeichnis an die gewünschte Stelle und die fgl.library
 nach LIBS: kopieren.
@EndNode

@Node "Introducting" "Über TransCat..."

  Programmierung von zIgUS  © 1998-1999
  TransCat läuft nur auf A1200 oder besser.


  TransCat benutzt folgende libraries :

      - fgl.library
      - asl.library

  Sowie @{"MUI" link "mui"} 3.6 oder neuer.

  TransCat wurde 100 % in Assembler programmiert und optimiert. Falls du
  Fehler findest oder irgendwelche Vorschläge für weitere Optionen hast,
  @{"kontaktiere mich" link "Contact"}.
@EndNode

@Node "MUI" "Über MUI..."


                    @{b}MUI - MagicUserInterface@{ub}

                 (c) Copyright 1993/97 bei Stefan Stuntz


 MUI ist ein System zum Erstellen und Verwalten grafischer Benutzerober-
 flächen. Mit der Hilfe eines Einstellungsprogramms kann der Nutzer die
 Anwendung an seine persönlichen Wünsche anpassen.

 MUI wird als Shareware vertrieben. Um ein komplettes Paket mit vielen
 Beispielen und weiteren Informationen über die Registrierung zu erhalten,
 suche nach einer Datei "muiXXusr.lha" (XX steht für die neueste Version)
 auf den örtlichen Mailboxen oder Public Domain Disketten.

         Wenn du dich direkt registrieren möchtest, sende


                        DM 30.-  oder  US$ 20.-

                                 an

                            Stefan Stuntz
                       Eduard-Spranger-Straße 7
                            80935 München
                               GERMANY
@EndNode

@Node "Use" "Wie benutzt man TransCat..."
                        _          ._______  ___       .--.__
                       ¡¬\         |      / ¡  ¬\_____ |  ¦ ¬|
                       | _\  /\    ¦  ___/  |    \   / |  |  |
                       ¦  \\// \   | __)_   |  \  \ /  |  |  |
                       `---\/   \  |    ¬\  |  ¦\  /   |  ¯  |
                            l____\ l______\ `--' \/    l_____¦

                       ---------------------------------------
                       @{"Projekt" link "project"}  @{"Aktionen" link "actions"}  @{"Import" link "import"}  @{"Export" link "export"}

 @{b}Filter@{ub} : gestattet das Suchen nach einem Namen im Katalog, Man kann als Jokerzeichen
          das Zeichen "*" benutzen.
          Tastaturkurzbefehl : "f".

 @{b}Übersetzt@{ub} : Prozentangabe über die übersetzten Elemente des Katalogs.

 @{b}Position@{ub} : Die Positionsangabe des angewählten Strings.

 @{b}Anzeige@{ub} : Gestattet die Auswahl der Anzeige, entweder alles oder nur die nicht übersetzten
           Elemente des Kataloges (in diesem Modus werden die übersetzten Elemente nicht angezeigt).
           Tastaturkurzbefehl : "a".

 @{b}Elemente@{ub} : Zeigt die Anzahl der im Katalog enthaltenen Elemente.

 @{b}Tastaturkurzbefehl "e"@{ub} : Gestattet das Bearbeiten des aktuellen Strings.

 @{b}Tastaturkurzbefehl "c"@{ub} : Gestattet das Kopieren des aktuellen Strings.

 @{b}Tastaturkurzbefehl "T"@{ub} : Gestattet den Zugriff auf einen Texteditor.

 @{b}Information über@{ub} :

  - @{fg shine}\el@{fg text} linksbündiger Text
  - @{fg shine}\ec@{fg text} zentrierter Text
  - @{fg shine}\er@{fg text} rechtsbündiger Text
  - @{fg shine}\eb@{fg text} fett
  - @{fg shine}\eu@{fg text} unterstrichen
  - @{fg shine}\ei@{fg text} kursiv
  - @{fg shine}\e1@{fg text} weiß geschrieben
  - @{fg shine}\e0@{fg text} schwarz geschrieben
  - @{fg shine}\en@{fg text} normaler Modus
  - @{fg shine}\n@{fg text}  Zeilenende
  - @{fg shine}\t@{fg text}  Tabulator

@EndNode


@Node "Project" "Projektmenü"

 @{b}Katalog öffnen@{ub} : Gestattet das Einlesen jeden Katalogs.

 @{b}Katalog speichern@{ub} : Gestattet das Speichern des Katalogs mit allen Änderungen.

 @{b}Katalog-Information@{ub} : Informationen über den eingeladenen Katalog :
                           - Name des Autors (nur in der registrierten Version).
                           - Name des Katalogs.
                           - Sprache des Katalogs (Für registrierte Nutzer ist deren
                             bevorzugte Sprache voreingestellt).
                           - Version des Katalogs.
                           - Revision des Katalogs.

 @{b}Über@{ub} : Informationen über TransCat, hier findest du auch die Registrierung.

 @{b}Beenden@{ub} : Gestattet das Beenden von TransCat.
@EndNode

@Node "Actions" "Aktionenmenü"

 @{b}Leere Strings füllen@{ub} : Gestattet das Ausfüllen der leeren Strings des Katalogs.

 @{b}Position suchen@{ub} : Gestattet die Suche einer Position im Katalog.
@EndNode

@Node "Import" "Importmenü"

 @{b}Katalogbeschreibung@{ub} : Lädt eine Katalogbeschreibung (.cd), gewöhnlich
                       erstellt vom Autor der Software.

 @{b}Katalogübersetzung@{ub} : Lädt eine Katalogübersetzung (.ct), erstellt durch dich !!!
@EndNode

@Node "Export" "Exportmenü"

 @{b}Katalogbeschreibung@{ub} : Gestattet das Speichern einer Katalogbeschreibung.

 @{b}Katalogübersetzung@{ub} : Nur registrierte Nutzer können hier ihre Übersetzung speichern.

 @{b}ASM-Konstanten@{ub} : Erzeugt eine Datei mit Assemblerkonstanten des Katalogs.

 @{b}C-Konstanten@{ub} : Erzeugt eine Datei mit C-Konstanten des Katalogs.

 @{b}E-Konstanten@{ub} : Erzeugt eine Datei mit E-Konstanten des Katalogs.

 @{b}Blitz-Konstanten@{ub} : Erzeugt eine Datei mit Blitzkonstanten des Katalogs.
@EndNode

@Node "The Futur" "Was bringt die Zukunft..."

  - Ich warte auf eure Vorschläge !!!!!!!!
@EndNode

@Node "Historic" "Die Geschichte von TransCat"

  @{U}Version 1.20@{uU} :

  - Unterstützung eines Texteditors (sehr sinnvoll für komplexe Sätze)

 @{U}Version 1.14@{uU} :

  - Implementierung des Durchuschens eines Katalogs beim Laden der Software.

 @{U}Version 1.13@{uU} :

  - Fehler bei Katalogen größer als 5Kb behoben.

 @{U}Version 1.12@{uU} :

  - Modus Suchen/Ersetzen hinzugefügt
  - Fehler beim Lesen einiger Kataloge behoben.

 @{U}Version 1.01@{uU} :

  - Fehler beim Erzeugen einer Beschreibungsdatei behoben.

 @{U}Version 1.00@{uU} :

  - Die erste Veröffentlichung im Aminet.
@EndNode

@Node "Translation" "Übersetzung der Kataloge."

 TransCat ist für folgende Sprachen erhältlich :

  - Französisch : Katalogübersetzung  : Der Autor
                  Dokumentübersetzung : Der Autor

  - Englisch    : Katalogübersetzung  : Pascal Rullier
                  Dokumentübersetzung : Millot Lionel
                  Dokumentübersetzung : Schaaij Willem

  - Deutsch     : Katalogübersetzung  : Dirk Neubauer
                  Dokumentübersetzung : Dirk Neubauer

  - Spanisch    : Katalogübersetzung  : Fermín Venegas
                  Dokumentübersetzung : Fermín Venegas

  - Italienisch : Katalogübersetzung  : Virginio Savani
                  Dokumentübersetzung : Virginio Savani

  - Ungarisch   : Katalogübersetzung  : Garami Ferenc


 Falls du dazu bereit bist, den Katalog von TransCat
 in deine Sprache zu übersetzen, frage bei mir nach
 der Katalogbeschreibung (.cd).
@EndNode

@Node "Contact" "Meine Adresse ..."

  Du kannst mich unter folgender Anschrift erreichen :

      @{b}K L A X@{ub}
      P.O Box 14
      21601 Longvic CEDEX
      France

   Email  : rcilm021@dial.oleane.com
  IrcName : zIgUS ( on #artbas server irc.insat.com)
@EndNode

