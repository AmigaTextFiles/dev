
; Lektion 07

EINIGE ASSEMBLER-ROUTINEN FÜR DEMOMAKER AUF AMIGA

23. Juli 2018 Amiga, 68000-Assembler

Diejenigen, die neu in der Programmierung von Amiga-Hardware in MC68000-
Assembler sind, kratzen sich oft am Kopf, wenn sie versuchen, grundlegende
Funktionen auszuführen:
Laden und Anzeigen eines Bildes, Lesen von Tastaturtasten usw.

Bild: Das berühmte "KingTut.iff" von Deluxe Paint

"King Tut", die Quintessenz der ILBM-IFF-Datei, gezeichnet von Avril Harrison
im Jahr 1986 für Deluxe Paint. © Electronis Arts.
Um die Aufgabe zu vereinfachen, bietet diese Seite die Quelle für Routinen, die
solche Aufgaben abdecken, die wir erschwinglich haben wollten, indem wir uns
auf das strikte Minimum beschränkten.
Vorerst finden wir die Quellen der folgenden Routinen ...:
Laden Sie ein Bild im IFF-ILBM-Format und zeigen Sie es an

Erkennt Tastendrücke durch Polling oder Interrupt

Um diesen Code mit ASM-One zu assemblieren, ist diese Datei erforderlich, die
die Liste der Offsets der Hardwareregister enthält.
Der Artikel wird im Laufe der Errungenschaften angereichert.
Diese Aktualisierungen werden gemeldet.
Update 19.08.2018:	Fehler bei der Interpretation des von Read()
	zurückgegebenen Werts in IFF.s behoben.
Update vom 10.02.2018: Alle Sourcen wurden um eine "StingRay's Stuff"-Sektion
	erweitert, die den ordnungsgemäßen Betrieb auf allen Amiga-Modellen,
	insbesondere mit Grafikkarte, gewährleistet.
Update 13.10.2018: Es wurde ein Fehler im Code behoben, der darauf wartet, dass
	zwei Rasterzeilen passieren, um den CIA-Interrupt zu bestätigen.

LADEN SIE EIN BILD IM IFF-ILBM-FORMAT UND ZEIGEN SIE ES AN

Laden und Anzeigen einer IFF-ILBM-Datei in 5 Bitebenen mit beliebigen
Abmessungen, vorausgesetzt, dass sie DISPLAY_DX x DISPLAY_DY nicht
überschreiten und dass ihre Tiefe (ihre Anzahl von Bitebenen) gleich
DISPLAY_DEPTH ist.
Hinweis! Manche Software speichert Bilder in mehr Bitplanes, als Sie vielleicht
denken (zB das hervorragende Pro Motion NG, das systematisch 8 Bitplanes
speichert).

Einer der Vorteile dieses Programms ist, dass es auf der Kommandozeile
funktioniert: IFF <picture.iff>. Es enthält daher den gesamten Code, der
erforderlich ist, um zu überprüfen, ob ein Argument zum Lesen über ReadArgs()
bereitgestellt wurde, und um eine Datei über Read() zu laden. Die Teile des
Programms, die diese beiden Funktionen abdecken, wurden ausreichend abgeschirmt
und faktorisiert, um leicht wiederverwendet werden zu können.

Klicken Sie hier, um die Datei herunterzuladen.

TASTENDRUCK DURCH POLLING ODER INTERRUPT ERKENNEN

Lesen einer auf der Tastatur gedrückten Taste durch direkten Angriff auf die
Register des CIA A. Zwei Modi sind möglich:
Polling: Die Hauptschleife muss regelmäßig eine Routine aufrufen, die
überprüft, ob eine Taste gedrückt oder losgelassen wurde (hier klicken, um die
Datei herunterzuladen);
Interrupt: Die Hauptschleife wird durch die Ausführung einer Routine
unterbrochen, die auftritt, wenn eine Taste gedrückt oder losgelassen wurde
(hier klicken, um die Datei herunterzuladen).
Der Amiga hat zwei 8520 Coprozessoren, bekannt als CIA (Complex Interface
Adapter): CIA A und CIA B.
CIA A ist eine Schaltung, die mehrere Funktionalitäten hat, die wahrscheinlich
eine Interruptanforderung der Ebene 2 erzeugen (Vektor zeigt auf $68).
Es ist unwahrscheinlich, dass CIA B eine solche Interruptanforderung
erzeugt. Unter anderem (mit seinen A- und B-Timern, seinem Alarm oder
Datenaustausch - zweifellos über die seriellen und parallelen Ports) kann der
CIA A einen Interrupt erzeugen, weil er gerade das letzte der 8 Bits
empfangen hat, die per Tastatur gesendet wurden beim Drücken oder Loslassen
einer Taste.
Tatsächlich ist der CIA A über seine Pins CNT (KCLK-Signal) und SP
(KDAT-Signal) mit der Tastatur verbunden: Die Tastatur sendet die Bits mit der
Rate der ansteigenden Flanken ihres eigenen Taktsignals an den CIA A.
Wenn CIA A das letzte der 8 Bits empfangen hat, schaltet er die 8 Bits in
seinem SDR-Register ($BFEC01) um und setzt das SP-Bit in seinem
ICR-Interruptregister ($BFED01).
Dabei generiert er einen Interrupt-Request der Ebene 2, der die Positionierung
des PORTS-Bits des INTREQ-Registers bewirkt.
Unter diesen Bedingungen muss der an der Adresse $68 untergebrachte
Interrupt-Manager damit beginnen, dass er verifiziert, dass es tatsächlich
CIA A ist, das der Ursprung der Interrupt-Anforderung ist. Dazu muss er das
SP-Bit des ICR-Registers testen. Man beachte, dass dieser Lesezugriff auf das
ICR-Register den Vorteil hat, dass er die Bestätigung aller
Interruptanforderungen des CIA A bewirkt, so dass letzterer aufhört,
seine Interruptanforderung der Ebene 2 aufrechtzuerhalten. Ohne diese
Bestätigung würde der CIA A das Signal aufrechterhalten mit dem er in seinem
Zustand eine Interrupt von der CPU anfordert, würde dies beim Verlassen
des Interrupt-Managers sofort zu einer Neupositionierung des PORTS-Bits in
INTREQ führen, also zu einem erneuten Aufruf an diesen.
Wenn das SP-Bit auf 1 ist, kann der Interrupt-Handler das SDR-Register lesen.
Seine Bits 7 bis 1 entsprechen den Umkehrungen der Bits 6 bis 0 des Codes der
Taste (die Liste der Codes ist hier), und sein Bit 0 zeigt an, ob die Taste
gedrückt (Bit auf 1) oder losgelassen (Bit auf 0) .
Der Interrupt-Manager muss dann das Lesen des SDR-Registers bestätigen, indem
er das SPMODE-Bit des CRA-Registers ($BFEE01) für 85 Mikrosekunden setzt,
bevor er dieses Bit wieder löscht.
Schließlich muss der Interrupt-Handler wie immer die Interrupt-Anfrage
bestätigen, indem er das PORTS-Bit in INTREQ löscht.
Damit das alles funktioniert, muss der CIA A vorher konfiguriert werden.
Zunächst ist es daher erforderlich, das SPMODE-Bit im CRA-Register des CIA A zu
löschen, um den CIA A in den "IN"-Modus zu schalten: In diesem Modus beginnt
der CIA A, das KDAT-Signal einzulesen seinem Pin SP mit der Rate der
ansteigenden Flanken des KCLK-Signals an seinem CNT-Pin.
Weitere Erläuterungen finden Sie im Amiga Hardware Reference Manual und einem
Beispiel im englischen Amiga Board-Forum.
