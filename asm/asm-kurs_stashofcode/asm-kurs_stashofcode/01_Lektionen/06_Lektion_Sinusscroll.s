
; Lektion 06

CODIEREN EINES SINUSSCROLLERS AUF DEM AMIGA (1/5)

26. Juni 2017 Amiga, Assembler 68000, Blitter, Copper, Sinus Scroller

Einer der von Programmierern auf dem Amiga am häufigsten verwendeten Effekte
war der Sinus-Scroll, d.h. die Parade von Text, der durch die Änderung der
Ordinate aufeinanderfolgender Pixelspalten gemäß einem Sinus verzerrt wurde,
wie zum Beispiel in diesem Intro der Falcon-Gruppe:

Bild: Eine schöner Sinus Scroller von Falon auf Amiga 500, aber nicht am Pixel

Das Muss ist der Sinus-Scroll mit einem Pixel, bei dem jede dieser Spalten an
einer bestimmten Ordinate angezeigt wird. Die Erzeugung eines solchen Effekts
erfordert jedoch viel Rechenzeit, wie wir zeigen werden, indem wir zunächst nur
die CPU verwenden. Um den Effekt zu verlängern, entlasten wir die CPU, indem
wir zwei Grafik-Coprozessoren anfordern: den Blitter und den Copper.
Dieser Artikel kann von jedem gelesen werden, da er für diejenigen geschrieben
wurde, die noch nie in 68000-Assembler codiert haben, geschweige denn die 
Amiga-Hardware angreifen.

Klicken Sie hier, um das Archiv mit dem Code und den Daten des hier
vorgestellten Programms herunterzuladen.

Dieses Archiv enthält mehrere Quellen:

sinescroll.s		ist die Basisversion, über die wir sprechen werden,
					bis wir optimieren;
sinescroll_final.s	ist die optimierte Version der Basisversion;
sinescroll_star.s	ist die verschönerte Version der optimierten Version.

Dieser Artikel ist der erste von fünf Artikeln. Wir werden sehen, wie man in
einer Entwicklungsumgebung auf einem mit WinUAE emulierten Amiga installiert
und die grundlegende Copperliste codiert, um etwas auf dem Bildschirm
anzuzeigen.

NB: Dieser Artikel liest sich am besten, wenn man sich das ausgezeichnete Modul
anhört, das Nuke / Anarchy für den Zeitschriftenteil von Stolen Data #7
komponiert hat, aber es ist eine Frage des persönlichen Geschmacks...

Update 12.07.2017: Entfernung der BLTPRI-Einstellung in DMACON, um die
Leistung zu verbessern.
Update 17.07.2017: Deaktivierung der Funktion zum Speichern von Markierungen
in ASM-One, um gemischte PC / Amiga-Bearbeitung zu erleichtern.

Klicken Sie hier, um diesen Artikel auf Englisch zu lesen.

Update 30.05.2018: Benutzer von Notepad++ können hier klicken, um eine
verbesserte Version von UDL 68K Assembly (v4) zu erhalten.
Update 16.06.2018: StingRay/Scoopex hat geholfen, co(q)uilles zu
korrigieren, Vokabular anzupassen und Details für die Kompatibilität
hinzuzufügen. Danke ihm!

INSTALLIEREN SIE EINE ENTWICKLUNGSUMGEBUNG

Es ist von vornherein zu beachten, dass die gesamte Dokumentation, die zur
Codierung des hier vorgestellten Sinus Scroller mobilisiert wurde, online zu
finden ist:
 - das Amiga-Hardware-Referenzhandbuch, das detailliert beschreibt, wie die
   Amiga-Hardware programmiert wird;
 - das M68000 Family Programmer's User Manual, das die 68000-Anweisungen
   detailliert beschreibt;
 - das Benutzerhandbuch für M68000 8- / 16- / 32-Bit-Mikroprozessoren,
   in dem die Ausführungszeit dieser Mikroprozessoren aufgeführt ist;
 - das ASM-One-Handbuch, von dem es eine neuere Version im AmigaGuide-Format im
   Archiv des Tools zum Nachschlagen auf Amiga zu finden ist.

Gleiches gilt für die Tools, beginnend mit dem Amiga-Emulator. Tatsächlich ist
es heutzutage nicht mehr erforderlich, einen Amiga bei eBay zu kaufen,
um auf diesem Computer zu codieren. Wir werden den ausgezeichneten WinUAE-
Emulator verwenden, den wir bitten, eine Festplatte aus einem Verzeichnis auf
dem PC zu simulieren. Dadurch können wir den Code in einem Texteditor unter
Windows bearbeiten und zum Assemblieren und Testen mit ASM-One auf einem von
WinUAE emulierten Amiga 1200 laden.

Nach dem Herunterladen und Installieren von WinUAE müssen wir das ROM und das
Betriebssystem wiederherstellen, nämlich Kickstart und Workbench in ihren
3.1-Versionen. Kickstart und Workbench unterliegen weiterhin dem Urheber-
rechtsschutz. Sie werden für rund zehn Euro von Amiga Forever vermarktet.

Beginnen wir in WinUAE damit, die Konfiguration eines Amiga 1200 in Hardware
neu zu erstellen:

- in CPU und FPU, wählen Sie eine 68020;
- in Chipset wählen wir AGA;
- in ROM wählen wir Kickstart 3.1;
- im RAM entscheiden wir uns für 2 MB Chip no Slow at all;
- in CD & Hard drives, klicken Sie auf Add Directory or Achives... hinzufügen
  und fügen Sie ein Device namens DH0: hinzu, das sich auf ein Verzeichnis auf
  unserem PC bezieht, in dem wir die Dateien dieser Festplattensimulation
  finden.

Diese Konfiguration speichern wir nach ihrer Erstellung. Klicken wir dazu auf
Hardware, geben Sie ihm einen Namen und klicken Sie auf Speichern. Anschließend
können wir die Konfiguration jederzeit per Doppelklick neu laden.
Gehen wir im gleichen Abschnitt zu Diskettenlaufwerke, um das Einlegen in das
DF0-Diskettenlaufwerk zu simulieren: der ersten Workbench-Diskette - der mit
Install 3.1 bezeichneten. Stellen wir bei dieser Gelegenheit die
Emulationsgeschwindigkeit des Diskettenlaufwerks auf das Maximum (Schieberegler
ganz nach links, auf Turbo), um keine Zeit mehr zu verschwenden.
Wir können dann auf Reset klicken, um die Emulation zu starten.

Nachdem die Workbench von der Diskette geladen wurde, muss diese auf der
Festplatte installiert werden, um lange Ladezeiten zu vermeiden. Doppelklicken
Sie auf das Install 3.1 Diskettensymbol, Dann auf sein Install -
Verzeichnis, und schließlich auf dem von der Version der Installation, die wir
wollen. Folgen wir nun dem Installationsprozess der Workbench auf der Festplatte:

Bild: Installation der Workbench 3.1 auf der DH0-Festplatte:

Sobald das Betriebssystem auf der Festplatte installiert ist, müssen wir die
Entwicklungsumgebung installieren. Um die Quelle zusammenzustellen und mit den
Daten innerhalb einer ausführbaren Datei zu verknüpfen, verwenden wir ASM-One.
Wie alle unten genannten Dateien müssen wir nur das Archiv auf Ihren PC
herunterladen und dessen Inhalt in einem Unterverzeichnis des Verzeichnisses
ablegen, in dem die Festplatte emuliert wird. Denken Sie daran, dass in der
Workbench nur die Verzeichnisse mit einer .info- Datei sichtbar sind. Die
einfachste Lösung besteht also darin, das Verzeichnis von der Workbench aus
zu erstellen - klicken Sie mit der rechten Maustaste auf die Taskleiste oben
auf dem Bildschirm, erinnern Sie sich?

Um ASM-One zu verwenden, müssen wir:

- Klicken Sie hier, um reqtools.library herunterzuladen und diese Datei in das
Libs- Verzeichnis zu kopieren. Diese Funktionsbibliothek wird von ASM-One
verwendet, um uns ein Dialogfeld zur Verfügung zu stellen, das die Navigation
im Dateisystem erleichtert.

- Verwenden Sie einen Shell-Befehl (im Systemverzeichnis), um SOURCES: dem
Verzeichnis zuzuweisen, das den Code und die Daten enthält (zum Beispiel:
assign SOURCES: DH0:sinescroll). Um dies zu vermeiden, können wir diese
Zeile in eine User-Startup-Datei schreiben, die im S-Verzeichnis gespeichert
wird.

Nach dem Starten von ASM-One weisen wir beispielsweise einen beliebigen
Arbeitsbereich im Speicher (Chip oder Fast) von 100 KB zu. Gehen wir im
Assembler-Menü zu Prozessor und wählen 68000, da wir für Amiga 500
programmieren werden. Geben Sie den R (Read)-Befehl ein, um die Quelle
zu laden.

Zum Compilieren und Testen gibt es zwei Lösungen:
- Wenn wir debuggen wollen, drücken wir die Tasten
Amiga (rechts) + Shift (rechts) + D , wobei die Amiga-Taste (rechts) mit der
Windows- Taste (rechts) emuliert wird. Wir greifen also auf den Debugger zu,
von wo aus wir zeilenweise durch Drücken der Pfeiltaste nach unten oder global
durch Drücken der Amiga (rechts) + R- Tasten ausführen können.

Wenn wir nicht debuggen möchten, können wir immer die 
Amiga-Tasten (rechts) + Umschalt (rechts) + A drücken oder den A (Assemble)
-Befehl zum Assemblieren eingeben und dann den J (Jump)-Befehl eingeben, um
die Ausführung zu starten.

Wir werden danach keine weiteren Funktionen von ASM-One verwenden, es sei denn,
um eine ausführbare Datei zu generieren. Dies liegt daran, dass wir zum
Schreiben von Code auf ASM-One verzichten können: Wir verwenden einen
Texteditor unter Windows, der es ermöglicht, eine ANSI-kodierte Textdatei, wie
zum Beispiel das ausgezeichnete Notepad++, zu speichern und die Datei zu laden.
Einer, um es zusammenzubauen und auszuführen, wann immer wir wollen.

Um trotz allem Code sowohl in ASM-One als auch in Notepad++ zu schreiben, da
sich dies gelegentlich als praktisch erweisen kann, deaktivieren wir das
Speichern von Markierungen, die Sonderzeichen am Kopf der Datei einführen.
Gehen Sie im ASM-One Projekt-Menü zu Preferences (Einstellungen) und
deaktivieren Sie Save marks (Markierungen speichern).

Beachten Sie, dass wir für einen noch schnelleren Zugriff auf die so
eingerichtete Entwicklungsumgebung die Taste F12 drücken können, nachdem
ASM-One geladen und ein Arbeitsbereich im Speicher zugewiesen wurde. Klicken
Sie in der erscheinenden Oberfläche von WinUAE auf Miscellaneous in Host, dann
auf Save State ... um den Zustand zu speichern. Anschließend, wenn wir WinUAE
gestartet haben, müssen wir nur noch Ihre Amiga 1200 Konfiguration laden, auf
Load State ... klicken um den State zu laden, dann auf OK klicken um den
Amiga 1200 im fraglichen Zustand zu finden - wir können WinUAE sogar so
konfigurieren, dass der Zustand mit der Konfiguration geladen wird. Praktisch!

MACHEN SIE SICH MIT DEM 68000 ASSEMBLER VERTRAUT

Der 68000 hat 8 Datenregister (D0 bis D7) und ebenso viele Adressregister
(A0 bis A7, letzteres dient jedoch als Stackpointer). Sein Befehlssatz ist
ziemlich umfangreich, aber wir werden nur einen sehr kleinen Satz davon
verwenden, da unsere bedauerliche Unwissenheit hier der glückseligen
Einfachheit halber bequem übergehen kann.

Die 68000-Anweisungen können mehrere Variationen haben. Anstatt eine
langwierige Überprüfung aller Variationen der Anleitungen unseres Spiels,
wie begrenzt sie auch sein mögen, sollten diese wenigen Beispiele ausreichen,
damit Sie sich zurechtfinden:

Anweisungen				Beschreibung

Speichern
MOVE.W $1234,A0			Speichert in A0 den 16-Bit-Wert, der an der
						Adresse	$1234 enthalten ist
MOVE.W $1234,D0			Gleiches mit D0
MOVE.W #$1234,A0		Speichert in A0 den 16-Bit-Wert $1234
MOVE.W #$1234,A0		Gleiches mit D0
LEA $4,A0				Speichert in A0 den 32-Bit-Wert $4
LEA variabel,A0			Speichert in A0 die Adresse des Bytes der dem
						Label "variable" folgt
LEA 31(A0),A1			Speichert in A1 das Ergebnis der Addition von 31
						zum Inhalt von A0
LEA 31(A0,DO.W),A1		Speichert in A1 das Ergebnis der Addition des in A0
						enthaltenen 32-Bit-Wertes, des in D0 enthaltenen
						16-Bit-Wertes und schließlich von 31
MOVE.L variabel,A0		Speichert in A0 den 32-Bit-Wert, der dem Label
						"variable" folgt
MOVE.L variabel,D0		Gleiches mit D0
CLR.W D0				Speichert den 16-Bit-Wert 0 in D0
MOVEQ #-7,D0			Speichert in D0 den 8-Bit-Wert -7, erweitert auf 32 Bit
MOVE.W D0,D1			Speichert in D1 den in D0 enthaltenen 16-Bit-Wert
MOVE.B(A0),D0			Speichert in D0 den 8-Bit-Wert, der an der in A0 enthaltenen
						Adresse enthalten ist
MOVE.L(A0)+,D0			Speichern Sie in D0 den 32-Bit-Wert, der an der in A0
						enthaltenen Adresse enthalten ist, und addieren Sie
						dann 4 zu dem in A0 enthaltenen Wert, um den nächsten
						32-Bit-Wert zu adressieren
MOVE.B(A0,D0.W)+,D1		Speichert in D1 den in der Adresse enthaltenen
						32-Bit-Wert, der sich aus der Addition der in A0 enthaltenen
						Adresse und des in D0 enthaltenen 16-Bit-Werts ergibt,
						addiert dann 1 zu dem in A0 enthaltenen Wert, um den
						nächsten 8-Bit-Wert zu adressieren

Sprünge
JMP-Ziel				Springt zur Anweisung mit der Überschrift "Ziel" ohne
					    Rückkehrmöglichkeit
BRA-Ziel				Wie JMP (um es einfach auszudrücken)
BNE-Ziel				Wie JMP, aber nur, wenn das Z-Flag (Null) des
						CPU-internen Zustandsregisters nicht gesetzt ist
BEQ-Ziel				Wie JMP, aber nur wenn Z positioniert ist
BGE-Ziel				Wie JMP, aber nur wenn Z oder C (Übertragen) eingestellt ist
BLE-Ziel				Wie JMP, aber nur wenn Z positioniert ist oder C nicht
BGT-Ziel				Wie JMP, aber nur wenn C gesetzt ist
DBF D0, Ziel			Subtrahiert 1 von dem in D0 enthaltenen Wert und springt zu
						der Anweisung, der die Überschrift "Ziel" vorangeht, wenn das
						Ergebnis nicht -1 ist
JSR-Ziel				Wie JMP, jedoch mit Rückgabemöglichkeit
RTS						Zur Anweisung springen, die der zuletzt ausgeführten JSR folgt

Berechnungen
BTST #4,D0				Testet den Wert von Bit 4 von Wert in D0
BCLR #6,D0				Setzt Bit 6 des in D0 enthaltenen Wertes auf 0
LSL.W #1,D0				Verschiebt den in D0 enthaltenen 16-Bit-Wert um 1 Bit
						nach links (vorzeichenlose Multiplikation mit 2^1 = 2)
LSR.B #4,D0				Verschiebt den in D0 enthaltenen 8-Bit-Wert um 4 Bit
						nach links (Vorzeichenlose Division durch 2^4 = 16)
ASL.W #1,d0				Wie LSL, aber mit Beibehaltung des Vorzeichenbits
						(Vorzeichenmultiplikation mit 2^1 = 2)
ASR.B #4,D0				Wie LSR, aber mit Beibehaltung des Vorzeichenbits
						(Division vorzeichenbehaftet durch 2^4 = 16)
SWAP D0					Vertauscht den höherwertigen 16-Bit-Wert
						(Bit 31 bis 16) und den niederwertigen 16-Bit-Wert
						(Bit 15 bis 0) in D0
CMP.W D0,D1				Vergleichen Sie den in D1 enthaltenen 16-Bit-Wert
						mit dem in D0 enthaltenen 16-Bit-Wert
ADDQ.W 2,D0				Addiert den 3-Bit-Wert 2 zu dem in D0. enthaltenen
						16-Bit-Wert
ADD.B D0,D1				Addiert den in D0 enthaltenen 8-Bit-Wert zum in D1
						enthaltenen Wert
SUB.L D0,D1				Subtrahiert den 32-Bit-Wert in D0 vom Wert in D1

Somit ist es möglich, die Operationen an den Daten auf einen
8-Bit-, 16-Bit- oder 32-Bit-Wert zu begrenzen. Wenn ein Register an einer
solchen Operation beteiligt ist, wird dann das niedrigstwertige Byte, das
niedrigstwertige Wort oder der gesamte darin enthaltene Wert manipuliert.
Beispielsweise:

	move.l #$01234567,d0	; D0=$01234567
	moveq #-1,d1			; D1=$FFFFFFFF
	move.b d0,d1			; D1=$FFFFFF67
	move.w d1,d0			; D0=$0123FF67

Die Ausführung eines Befehls führt zu einer Aktualisierung der Flags des
internen Zustandsregisters der CPU. Es ist ziemlich intuitiv. Beispielsweise:
	
	move.b value,d0			; D0=[value]
	beq _valueZero			; Jump to _valueZero if [value] is 0
	btst #2,d0				; Test bit 2 of [value]
	bne _bit2NotZero		; Jump to _bit2NotZero if the bit is 0
	;...
_valueZero:
	;...
_bit2NotZero:
	;...

Die einzige Feinheit, die wir uns erlauben, besteht darin, die Rechenzeit zu
begrenzen, indem wir auf binäre Operationen anstelle von Multiplikationen oder
Divisionen zurückgreifen. Beispielsweise:
	
	move.l #157,d0			; D0=157
	move.l d0,d1			; D1=157
	lsl.w #5,d0				; D0=157*2^5 so D0=157*32
	lsl.w #3,d1				; D1=157*2^3 so D1=157*8
	add.w d0,d1				; D0=157*2^5+157*2^3 so D0=157*40

Wir werden nur sehr wenige Variablen verwenden. Diese werden am Ende des Codes
im folgenden Modell deklariert:

value8:		DC.B $12
	EVEN					; EVEN because the address of value16 shall be even
value16:	DC.W $1234
value32:	DC.L $12345678

Wie bereits erwähnt, teilt EVEN ASM-One mit, dass es ein Füllbyte zwischen
$12 und $1234 einfügen muss, damit dieser letztere Wert an einer geraden
Adresse liegt. Wieso denn? Dies liegt daran, dass der 68000 nur 16-Bit- oder
32-Bit-Werte an geraden Adressen lesen kann.

VERABSCHIEDEN SIE SICH VOM BETRIEBSSYSTEM

ASM-One ermöglicht die Generierung einer ausführbaren Datei, die im Kontext des
Betriebssystems ausgeführt werden soll. Unser Code wird sich jedoch nicht auf
das Betriebssystem verlassen. Tatsächlich werden wir sogar versuchen, es zu
entfernen, um die vollständige Kontrolle über die Hardware zu erlangen. Unser
einziges Zugeständnis an das Betriebssystem besteht darin, nirgendwo im
Speicher zu tippen und es daher zu bitten, uns die für uns notwendigen Plätze
zuzuweisen, die wir am Ende freigeben werden. In der Zwischenzeit wird das
Betriebssystem vollständig umgangen.

; Stack the registers

	movem.l d0-d7/a0-a6,-(sp)

; Allocate a block of Chip memory and set it to 0 for Copper list

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperlist

; Same thing for the bitplanes

	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplaneA

	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplaneB

	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplaneC

; Same thing for the font

	move.l #256<<5,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,font16

; Shut down the system

	movea.l $4,a6
	jsr -132(a6)

StingRay/Scoopex: "Stellen Sie sicher, dass Sie LoadView(0) aufrufen,
gefolgt von zwei Aufrufen von WaitTOF(), bevor Sie DMA/Interrupts und
dergleichen deaktivieren, da dies Ihrem Code ermöglicht, auf nicht-nativen
Bildschirmen (dh: RTG) zu arbeiten. Es ist für Benutzer mit Grafikkarten
ziemlich ärgerlich, ihre Karte deaktivieren zu müssen, nur um eine
Demo zu starten. :) " Seien Sie vorsichtig!

AllocMem() und Forbid() sind die beiden hier verwendeten OS Exec-
Bibliotheksfunktionen. Um eine Exec-Funktion aufzurufen, müssen wir eine Reihe
von Registern ausfüllen, in denen diese Funktion erwartet, Parameter lesen zu
können, und dann einen Sprung zum richtigen Offset einer Indirektionstabelle
- einer JMP- Tabelle - durchführen, deren Adresse sich unter Adresse $4
befindet. Die Funktion gibt ihre Ergebnisse in einer Reihe von Registern
zurück. Somit gibt AllocMem() die Adresse des zugewiesenen Speicherblocks in D0
zurück.
AllocMem() wird hier verwendet, um Speicher für die Copperliste zuzuweisen,
für drei Bitplanes - wir werden dreifache Pufferung durchführen - und für den
Zeichenfont - werden wir einen 16x16-Font aus einem 8x8-Font machen. All diese
Speicherplätze werden im Chip angefordert, dem einzigen Speicher, auf den der
Copper und der Blitter zugreifen können, im Gegensatz zum Fast-Speicher.
Es reicht nicht aus, Forbid() aufzurufen, um das Betriebssystem
herunterzufahren. In der Tat kann das Betriebssystem Code installiert oder
zugelassen haben, der ausgeführt wird, wenn ein Hardwareereignis auftritt.
Wenn beispielsweise der Elektronenstrahl das Abtasten des Bildschirms beendet
hat, erzeugt die Hardware ein Hardware-VERTB-Ereignis. Dieses Ereignis führt zu
einem Level-3-Interrupt der CPU. Die CPU unterbricht ihre Arbeit, um den Code
auszuführen, dessen Adresse in Eintragsnummer 27 ihrer Interrupt-Vektortabelle
angegeben ist - dem Interrupt-Vektor 27 -, d.h. der Adresse $6C:

Bild: Aufruf des Interrupt Manager Level 3 Interrupt Autovector bei einem
VERTB-Ereignis

Wenn unser Code solche Hardware-Interrupts verwenden würde, müssten wir zuerst
die Vektoren umleiten, d.h. sicherstellen, dass sie auf eine RTE-Anweisung
zeigen:

; Umleiten der Interrupt-Vektoren (Code). Hardware-Interrupts erzeugen
; CPU-Interrupts der Ebene 1 bis 6, die den Vektoren 25 bis 30 entsprechen und
; auf die Adressen $64 bis $78 zeigen

	REPT 6
	lea vectors,a1
	REPT 6
	move.l (a0),(a1)+
	move.l #_rte,(a0)+
	ENDR

;...

; Diverts the interrupt vectors (data part)

_rte:
	rte

vectors:	BLK.L 6		; To avoid allocating memory for 6 longs

Noch brutaler wäre es, alle Interrupt-Vektoren der CPU auf einen RTE-Befehl zu
verweisen. Dies liegt daran, dass die CPU nicht nur die Vektoren der Interrupts
der Ebene N (von 0 bis 7) hat, sondern 255 Vektoren, wie beispielsweise
Vektor 5 - der Code, auf den sie zeigt, wird im Fall einer Division durch Null
aufgerufen. Das wäre jedoch überflüssig.

StingRay/Scoopex: "68010+ CPUs erlauben das Verschieben der Basisadresse des
vom VBR verwendeten Vektors, was bedeutet, dass dieser Code auf Maschinen
nicht funktioniert, sobald der VBR verschoben wurde" Seien Sie vorsichtig!

In diesem Fall werden wir diese Interrupts nicht verwenden, also müssen wir
sie nur sperren. Dazu müssen wir INTENAR einlesen, um den Zustand der
aktivierten Interrupts abzurufen, diesen Zustand speichern und dann die
Interrupts durch Schreiben in INTENA sperren.

Hardware-Register

Dies ist die Gelegenheit, die Art und Weise festzulegen, in der unser Code mit
der Hardware in Dialog tritt. Dies geschieht über 16-Bit-Register mit der
Adresse $DFF000 plus einem geraden Offset. INTENAR befindet sich beispielsweise
an der Adresse $DFF01C. Wir werden eine Empfehlung aus dem Handbuch anwenden,
um Tippfehler zu begrenzen und das Lesen zu erleichtern. Wir werden $DFF000 in
einem Adressregister speichern - es wird A5 sein - und wir werden die Register
mit Konstanten adressieren, deren Werte die Offsets sind. Beispielsweise:
INTENA = $09A

Jedes Register ist sehr spezifisch. Die Bedeutung jedes seiner Bits wird im
Amiga Hardware Reference Manual detailliert beschrieben  ein echtes Handbuch,
sehr gut geschrieben von Autoren, die ihr Thema vollständig beherrschen. Die
Herausforderung dieses Artikels besteht nicht darin, den Inhalt dieses
wesentlichen Handbuchs zu kopieren. Es wird daher empfohlen, in Anhang A des
letzteren nachzulesen, was über das Register gesagt wurde, und dann
weiterzulesen.
Es ist auch möglich, dass Hardware-Interrupts anstehen. Unabhängig davon, ob
sie die Möglichkeit hat, die CPU zu unterbrechen oder nicht, signalisiert die
Hardware die Gründe, aus denen sie sie unterbrechen möchte, in INTREQ - was
mit INTREQR ein ähnliches Paar wie das derzeit gesehene bildet. Um sich jedoch
eines Tages die Möglichkeit der Verwendung von Interrupts zu leisten - was
hier, wie wir wiederholen, nicht der Fall sein wird - müssen wir in INTREQR
den Zustand der Interrupt-Anfragen lesen und diese Anfragen dann durch
Schreiben in INTREQ quittieren, um sie nicht mit denen, die die von der
Hardware später generiert werden zu verwechseln.
Ein letztes Register muss gelesen werden: es ist DMACONR. Auf dem Amiga haben
die Coprozessoren direkten Zugriff auf den Speicher oder DMA. Auch hier
beabsichtigen wir, dies zu kontrollieren, um den DMA-Zugriff auf diejenigen zu
beschränken, die für uns von Nutzen sind. Wir müssen also den Zustand der
Kanäle in DMACONR lesen, um den Zustand der aktivierten DMA-Kanäle abzurufen,
diesen Zustand speichern und dann die Kanäle stummschalten, indem wir in DMACON
schreiben - um zu beginnen, schalten wir sie alle stumm.
INTENA, INTREQ und DMACON arbeiten nach dem gleichen Modell: Um einen Interrupt
zu verhindern, einen Interrupt zu bestätigen oder einen DMA-Kanal zu
unterbrechen, müssen wir ein Wort schreiben, dessen Bit 15 auf 0 und das dem
Interrupt oder dem Kanal entsprechende Bit auf 1 ist.

All dies führt dazu, zu schreiben:
	- $7FFF in INTENA. Wir hätten das INTEN-Bit einfach ausschalten können,
		    aber wenn Sie in Zukunft Interrupts verwenden möchten, müssen Sie
			nicht wieder diejenigen deaktivieren, die Ihnen nicht wichtig sind,
			bevor Sie INTEN und die wieder aktivieren die Ihnen wichtig sind.
	- $7FFF in INTREQ. Dieses Register enthält auch ein INTEN-Bit.
	- $07FF in DMACON. Für das DMAEN-Bit gilt hier die Bemerkung, die für INTEN
			gilt. Aus Faulheit hätten wir 7FFF schreiben können, aber die
			Bits 11 bis 14 sind zum Schreiben unbrauchbar.

; Shut down the hardware interrupts and the DMAs

	lea $dff000,a5
	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

Ist alles sauber? Sicherlich nicht. Es gibt keine saubere Möglichkeit, das
Betriebssystem schnell herunterzufahren. Aus diesem Grund sprechen wir auch von
Metal Bashing. Endlich ist es soweit: Wir haben jetzt die volle Kontrolle über
die Hardware. Beginnen wir mit der Konfiguration des Displays.

ANZEIGE KONFIGURIEREN

In einem früheren Artikel haben wir die Grafik-Coprozessoren des Amiga
vorgestellt, darunter auch den Copper, der das Display steuert. Wir haben
erklärt, dass das Copper über eine Liste von Befehlen, die Copperliste,
programmiert wird, die in Form einer Sequenz von Opcodes, lang (32 Bit), in
hexadezimaler Schreibweise bereitgestellt werden soll. Der Copper hat drei
Befehle (WAIT, MOVE und SKIP), aber es ist nur MOVE, den wir vorerst
verwenden werden, um den Copper aufzufordern, bestimmte Werte in die
Register zu schreiben, die die Anzeige steuern.
Genauer gesagt haben wir auch erklärt, wie diese Anzeige funktioniert. Es
basiert auf Bitebenen, überlagerten Bitebenen, sodass das Lesen des Bits an den
Koordinaten (x,y) in der Bitebene N Bit N-1 den Farbindex des entsprechenden
Pixels in der Palette usw. ergibt. Die Anzahl der Farben wird daher durch die
Anzahl der Bitebenen bestimmt: N Bitebenen für 2^N Farben. Hier werden wir eine
Bitplane darstellen, also in zwei Farben - einschließlich der Hintergrundfarbe.
Um uns leicht zurechtzufinden, definieren wir einige Konstanten:

DISPLAY_DEPTH=1
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C

Folgende Anzeigeeinstellungen müssen angegeben werden:
 - Die Auflösung. Die Pixel werden in niedriger Auflösung angezeigt, was keine
   besondere Bitpositionierung in irgendeinem Register erfordert.
 - Die Anzahl der Bitebenen. BPUx-Bits von BPLCON0 sollten diese Nummer
   ergeben, d.h. DISPLAY_DEPTH.
 - Farbdisplay. Das COLOR-Bit von BPLCON0 muss gesetzt sein.
 - Der zu scannende Videopixelbereich. DIWSTRT muss die Koordinaten seiner
   oberen linken Ecke und DIWSTOP die seiner unteren rechten Ecke enthalten.
   Diese Koordinaten werden in Pixeln in einem ganz besonderen Bezugssystem
   ausgedrückt, dem der Kathodenstrahlröhre. Normalerweise beginnt die
   Oberfläche bei ($81,$2C) und erstreckt sich horizontal über DISPLAY_DX Pixel
   und vertikal über DISPLAY_DY Pixel. Beachten Sie, dass wir aufgrund der
   begrenzten Anzahl von Bits in DIWSTOP 256 von den dort geschriebenen
   Koordinaten subtrahieren müssen.
 - Die horizontalen Koordinaten, von denen aus das Lesen der anzuzeigenden
   Pixeldaten gestartet und gestoppt werden soll. Diese Abszissen werden im
   gleichen Koordinatensystem wie die Winkel der Videooberfläche in DIWSTRT und
   DIWSTOP ausgedrückt. Die Hardware liest Pixeldaten in 16-Pixel-Paketen.
   Außerdem vergeht ein wenig Zeit zwischen dem Beginn des Lesens dieser Daten
   durch die Hardware und dem Beginn der Anzeige der entsprechenden Pixel.
   Vorausgesetzt, dass DISPLAY_DX ein Vielfaches von 16 ist, muss das
   Datenlesen bei (DISPLAY_X-17)>> 1 beginnen.

Pixelplot

Was Sie verstehen müssen, ist, dass die Geschwindigkeit des Elektronenstrahls
konstant ist, sobald die Auflösung festgelegt ist - niedrige oder hohe
horizontale Auflösung, mit oder ohne vertikale Verschachtelung. Tatsächlich
tastet es immer die gesamte Oberfläche der Kathodenstrahlröhre ab und verfolgt
die Pixel, indem es mit mehr oder weniger Intensität auf die roten, grünen und
blauen Bereiche der Leuchtstoffe über eine bestimmte Länge trifft, wobei eine
Folge von Leuchtstoffen ein Pixel bildet. Alles, was der Amiga tun kann, ist,
den Strahl zu bitten, nur die Leuchtstoffe einer bestimmten Oberfläche der
Röhre zu treffen, wobei er mit unterschiedlicher Intensität auf die roten,
grünen und blauen Punkte trifft, aus denen diese Leuchtstoffe bestehen.
DIWSTRT und DIWSTOP ermöglichen die Kontrolle der Lage und Abmessungen der
jeweiligen Fläche. DDFSTRT und DDFSTOP ermöglichen es, die Positionen zu
kontrollieren, von denen aus der Amiga entscheidet, fortzufahren und das Lesen
von Daten aus den Bitebenen zu stoppen, um die Intensitäten von Rot, Grün und
Blau abzuleiten, die dem Elektronenstrahl mitgeteilt werden.
Mit anderen Worten, wir dürfen uns nicht täuschen: Es ist nicht möglich, eine
ganze Zeile einer Bitebene auf einer mehr oder weniger breiten Zeile des
Bildschirms darzustellen und vertikal genauso vorzugehen - eine Art Videozoom.
Einmal über Bits von BPLCON0 entschieden, sind die horizontalen und vertikalen
Auflösungen tatsächlich fest: Was auch immer passiert, der Elektronenstrahl
verfolgt ein Pixel in 140ns und es dauert 1/50stel Sekunde, um den gesamten
Bildschirm auf einer bestimmten Breite und Höhe zu verfolgen.
Der Amiga interagiert mit einem Maler, der immer dieselbe Fläche mit der
gleichen Geschwindigkeit überstreicht und nur akzeptiert, dass wir jeden
Moment modifizieren - na ja, zumindest die Zeit, in der er ein Pixel zeichnet
- was er aus seinen Töpfen mit Rot, Grün und Blauer Farbe schöpft.
Alle anderen Einstellungen sollten deaktiviert sein. Beispielsweise kommt es
nicht in Frage, die Anzeige ungerader Bitebenen horizontal um einige Pixel
zu verzögern, so dass die PF1Hx-Bits von BPLCON1 auf 0 geändert werden. Oder
es kommt nicht in Frage, in hoher Auflösung anzuzeigen, also wird das HRES-Bit
von BPLCON0 auf 0 geändert.
Welche geben:

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(DISPLAY_DEPTH<<12)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #0,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #0,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+

Die Pixeldaten befinden sich in den Bitebenen. Wir müssen daher angeben, wo sie
sich im Speicher befinden, indem wir ihre Adressen in die Registerpaare BPLxPTH
(16 höchstwertige Bits der Adresse) und BPLxPTL (16 niederwertige Bits der
Adresse) schreiben:
	
	move.l bitplaneA,d0
	move.w #BPL1PTL,(a0)+
	move.w d0,(a0)+
	swap d0
	move.w #BPL1PTH,(a0)+
	move.w d0,(a0)+

Die Hardware inkrementiert den Inhalt von BPLxPTH und BPLxPTL, während sie beim
Anzeigen einer Zeile Daten aus der Bitebene liest. Am Ende dieser Zeile fügt
die Hardware diesen Registern eine bestimmte Anzahl von Bytes hinzu, um die
ersten Pixel der folgenden Zeile zu adressieren: das ist das Modulo. Mit
BPL1MOD können Sie den Modulo von ungeraden Bitplanes und BPL2MOD den von
geraden Bitplanes angeben. Im Moment wird nur BPL1MOD verwendet, da es nur eine
Bitebene gibt, Bitebene 1, die daher eine ungerade Bitebene ist. Dieses Modulo
ist 0, da die Bitebene DISPLAY_DX Pixel breit ist und wir DISPLAY_DX Pixel pro
Zeile anzeigen möchten:

	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+

Nachdem die Bits des aktuellen Pixels in den Bitebenen abgerufen wurden, kann
die Hardware daraus den Index in einer Palette der Farbe des fraglichen Pixels
ableiten. Wir spezifizieren die beiden Farben aus unserer Palette, indem wir
ihre Werte in COLOR00 und COLOR01 schreiben:
	
	move.w #COLOR00,(a0)+
	move.w #$0000,(a0)+
	move.w #COLOR01,(a0)+
	move.w #SCROLL_COLOR,(a0)+

Der emulierte Amiga ist ein Amiga 1200 mit dem AGA-Chipsatz, aber der Code, den
wir schreiben, soll auf einem Amiga 500 mit dem OCS-Chipsatz funktionieren.
Wenn es um Video geht, ist die Abwärtskompatibilität von AGA mit dem OCS nahezu
perfekt. Wir müssen nur daran denken, 0 in FMODE zu schreiben:
	
	move.w #FMODE,(a0)+
	move.w #$0000,(a0)+

Schließlich erkennt der Copper das Ende der Copperliste, wenn er auf einen
unmöglichen WAIT-Befehl stößt:

	move.l #$FFFFFFFE,(a0)

Wir werden auf das Schreiben von WAIT zurückkommen, wenn wir versuchen,
Schatten- und Spiegeleffekte hinzuzufügen.
Da die Copperliste erstellt wird, können wir dem Copper bitten, sie
auszuführen. Dies geschieht in zwei Stufen:
 - die Adresse der Copperliste über COP1LCH und COP1LCL bereitstellen, was von
   einem MOVE.L aus erfolgen kann, da diese Register wie BPLxPTH und BPLxPTL
   zusammenhängend sind;
 - Schreiben Sie einen beliebigen Wert in COPJMP1, weil es ein Strobe ist,
   dh ein Register, das eine Aktion auslöst, sobald Sie seinen Wert ändern.
	
	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

Der Copper muss weiterhin per DMA auf den Speicher zugreifen können. Dies ist
die Gelegenheit, seinen DMA-Kanal wieder zu öffnen, aber auch die Möglichkeit,
die Hardware die Daten aus den Bitplanes und dem des Blitters zu lesen. Wir
nutzen diese Gelegenheit, um die Zugriffszyklen auf den Speicher durch den
Blitter zu schützen, damit er nicht von der CPU gestohlen wird (das Amiga-
Hardware-Referenzhandbuch enthält nicht viele Erklärungen zu diesem Thema ...):
	
	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

Da die Hardware konfiguriert wird, können wir jetzt den Code eingeben, der
generiert, was angezeigt werden soll ...


;------------------------------------------------------------------------------
; Teil 2

CODIEREN EINES SINUSSCROLLERS AUF DEM AMIGA (2/5)

30. Juni 2017 Amiga, Assembler 68000, Blitter, Copper, Sinus Scroller

Dieser Artikel ist der zweite in einer Reihe von fünf, die sich der
Programmierung eines Sinus-Scrolls mit einem Pixel auf dem Amiga widmet, einem
Effekt, der von Democodern und anderen Crackern auf Amiga weit verbreitet war
... bis er aus der Mode kam und von jedem in Reichweite gebracht wurde der
berühmte DemoMaker der Red Sector Inc. Gruppe, oder RSI:

Bild: Der DemoMaker von Red Sector Inc. (RSI), nur für Lamer

Im ersten Artikel haben wir gesehen, wie man in einer Entwicklungsumgebung auf
einem mit WinUAE emulierten Amiga installiert und die grundlegende Copperliste
codiert, um etwas auf dem Bildschirm anzuzeigen.
In diesem zweiten Artikel werden wir sehen, wie Sie eine 16x16-Schrift
vorbereiten, um die Pixelspalten von Zeichen einfach anzuzeigen, die zum
Verzerren von Text erforderlichen Sinuswerte durch Ändern der Ordinate der
Spalten vorab zu berechnen und eine Dreifachpufferung richtig einzurichten

Wechseln Sie die Bilder auf dem Bildschirm.

Klicken Sie hier, um das Archiv mit dem Code und den Daten des hier gezeigten
Programms herunterzuladen - es ist das gleiche wie in den anderen Artikeln.
NB: Dieser Artikel liest sich am besten, wenn man sich das ausgezeichnete
Modul anhört, das Nuke / Anarchy für den Zeitschriftenteil von Stolen Data #7
komponiert hat, aber es ist eine Frage des persönlichen Geschmacks ...

Update 23.07.2017: Korrektur eines kleinen Fehlers in der Abbildung zur
Verformung. Klicken Sie hier, um diesen Artikel auf Englisch zu lesen.

GENERIEREN SIE EINE 16X16-SCHRIFT MIT WOHLGEORDNETEN PIXELN

In Abwesenheit von Drosseln sind wir mit Amseln zufrieden. Da wir in unseren
Archiven keine Datei gefunden haben, die einer 16x16-Schrift entspricht,
werden wir eine 8x8-Schrift verwenden, deren Abmessungen wir verdoppeln. Das
Ergebnis wird der Laufruhe der Sinus-Scroll-Darstellung nicht gerecht, aber es
geht weiter.
Die Datei font8.raw enthält die Schriftart 8x8. ASM-One wird übrigens mit der
INCBIN-Direktive angewiesen, den assemblierten Code mit aus einer Datei
gelesenen Daten zu verknüpfen:

font8: INCBIN "Quellen: 2017/sinescroll/font8.fnt"

Es ist eine Folge von 94 ASCII-Zeichen, die der Reihe nach gegeben sind, jedes
Zeichen in Form einer 8x8-Bit-Matrix, deren Bytes der Reihe nach gegeben sind -
die Bitmap des Zeichens auf einer Bitebene. Optisch sieht die Schriftart, da
die Organisation im Speicher anders ist, wie folgt aus:

Bild: Die 94 Zeichen der 8x8-Schriftart, die über mehrere Zeilen angezeigt werden

Um einen Sinus-Scroll mit einem Pixel zu erzeugen, müssen wir die Pixelspalten
eines Zeichens in unterschiedlichen Höhen zeichnen. Um Spalte N zu zeichnen,
werden wir sicherlich keine Zeit damit verschwenden, Zeile 0 zu lesen, den Wert
von Bit N daraus zu extrahieren, das entsprechende Pixel auf dem Bildschirm zu
zeichnen oder zu löschen und all dies für die anderen 7 Zeilen zu wiederholen.
Wir möchten auf einmal die 8 Werte von Bit N lesen, die die Spalte N bilden.
Dies erfordert eine Drehung von -90 Grad auf die Bitmap:

Bild: 8x8-Schriftumwandlung für die Spaltenanzeige

Übrigens, da wir eine 16x16-Schrift haben möchten, verdoppeln wir jede Zeile
und jede Spalte:

Bild: Zeichen vergrößern

Dies führt zu folgendem Code, der recht einfach ist:
	
	lea font8,a0
	move.l font16,a1
	move.w #256-1,d0
_fontLoop:
	moveq #7,d1
_fontLineLoop:
	clr.w d5
	clr.w d3
	clr.w d4
_fontColumnLoop:
	move.b (a0,d5.w),d2
	btst d1,d2
	beq _fontPixelEmpty
	bset d4,d3
	addq.b #1,d4
	bset d4,d3
	addq.b #1,d4
	bra _fontNextPixel
_fontPixelEmpty:
	addq.b #2,d4
_fontNextPixel:
	addq.b #1,d5
	btst #4,d4
	beq _fontColumnLoop
	move.w d3,(a1)+
	move.w d3,(a1)+
	dbf d1,_fontLineLoop
	lea 8(a0),a0
	dbf d0,_fontLoop

In diesem Code wird die neue 16x16-Schriftart an der in font16 enthaltenen
Adresse gespeichert. Es ist ein Speicherplatz von 256 * 16 * 2 Bytes, den
wir zuvor zugewiesen haben: 256 Zeichen von 16 Zeilen zu je 16 Pixeln
(2 Byte), deren Inhalt schließlich als Folge von zurückgegebenen Zeichen
präsentiert wird:

Bild: Die 16x16-Schriftart im Speicher (2 Byte pro Zeile)

SCROLLEN SIE DEN TEXT IM FRAME

Nach der Initialisierung kommt die Hauptschleife. Sein Aufbau ist besonders
einfach:
 - warten, bis der Elektronenstrahl - den unteren Rand des Anzeigefensters
   "erreicht": dies ist keine Möglichkeit, es ist sicher
 - Zeichne den Text von der aktuellen Position und inkrementiere diese
   Position;
 - Testen Sie, ob der Benutzer mit der linken Maustaste klickt, und
   wiederholen Sie die Schleife.
Um auf den Elektronenstrahl zu warten, müssen Sie lediglich seine 9-Bit-
Vertikalposition in VPOSR für Bit 8 und VHPOSR für Bit 0 bis 7 auslesen.
Wichtig ist, sich nicht mit Bit 0 bis 7 zufrieden zu geben, da Anzeige in PAL,
könnten wir uns entscheiden, eine Bildschirmhöhe anzugeben, bei der die
Position DISPLAY_Y + DISPLAY_DY $FF überschreitet. Dies ist in der Tat der
Fall, da $2C + 256 = 300 ergibt ...
Es wäre möglich zu warten, bis die Hardware das Ende des frames signalisiert,
indem man das VERTB-Bit testet, das sie in INTREQ setzt, und dann dieses Bit
zur Bestätigung löscht - die Hardware löscht nie ein Bit, das es in INTREQ
gesetzt hat:

_loop:
	move.w INTREQR(a5),d0
	btst #5,d0
	bne _loop
	move.w #$0020,INTREQ(a5)

Dies würde jedoch nur passieren, wenn Zeile 312 - die letzte der
313 PAL-Zeilen - überschritten wird, also deutlich nach der Zeile
DISPLAY_Y + DISPLAY_DY, nach der wir nichts mehr zu zeichnen haben. Es ist daher
besser zu warten, bis der Elektronenstrahl diese letzte Zeile erreicht, um mit
der Wiedergabe des nächsten Frames zu beginnen. So viel Zeit gespart!
Der Code geht davon aus, dass eine Iteration der Hauptschleife länger dauert
als der Elektronenstrahl, um die Linien DISPLAY_Y + DISPLAY_DY bis 312 zu
zeichnen. Wenn dies nicht der Fall wäre, müsste ein Test hinzugefügt werden, um
auf den Strahl in Zeile 0 zu warten. Dies würde die Hauptschleife verlangsamen,
um auf der Frequenz eines Frames zu bleiben, dh jede 50. Sekunde in PAL.
Um zu testen, ob der Benutzer mit der linken Maustaste klickt, testen Sie
einfach Bit 6 von CIAAPRA, einem 8-Bit-Register von einem der 8520er, der
Ein- und Ausgänge steuert, deren Adresse $BFE001 ist.

_loop:

_waitVBL:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmp.w #DISPLAY_Y+DISPLAY_DY,d0
	blt _waitVBL

	; Code to execute here
	; Code, der hier im Frame ausgeführt werden soll
	btst #6,$bfe001
	bne _loop

Ist dieser Rahmen gesetzt, können ernste Dinge beginnen. Die erste Aufgabe zu
Beginn des Frames besteht darin, die Bitebene anzuzeigen, in der wir den
Sinus-Scroll während des vorherigen Frames gezeichnet haben. Dies ist das
Prinzip der Doppelpufferung: Zeichnen Sie niemals in der angezeigten Bitebene,
um das Flimmern zu vermeiden.

Flicker und Doppelpufferung

Angenommen, Sie beginnen, ein rotes "R" auf grünem Hintergrund über ein blaues
"Y" auf gelbem Hintergrund zu zeichnen, während der Elektronenstrahl beginnt,
die Bitebenen anzuzeigen. Es ist möglich, dass die CPU zu einem Zeitpunkt
beginnt, das "R" zu zeichnen, wenn der Strahl bereits einen guten Teil des
"Y" angezeigt hat und schneller als der Elektronenstrahl wird, dass sie einen
Teil der Bitebenen modifiziert, der letzterer noch nicht angezeigt hat.
Infolgedessen beginnt der Strahl, die Daten aus den Bitebenen zu lesen, nachdem
und nicht bevor die CPU sie modifiziert hat, und zeigt daher einen Teil des "R"
nach einem Teil des "Y" an:

Bild: Flimmern beim Zeichnen in der angezeigten Bitebene

Wenn sich das angezeigte Bild mit jedem Frame ändert, erzeugt dieser Wettlauf
zwischen dem Elektronenstrahl und der CPU eine Überlappung aufeinanderfolgender
Bilder ausgehend von einer Position, die im Allgemeinen variiert: dies ist das
Flimmern.
Um dies zu vermeiden, müssen Sie das "R" in versteckten Bitebenen zeichnen, die
sich von denen unterscheiden, in denen das "Y" gezeichnet ist, und ihrerseits
angezeigt werden. Wenn der Frame endet, fragen Sie nach der Anzeige der
Bitplanes, in denen das "R" gezeichnet wurde, und beginnen Sie mit dem Zeichnen
des nächsten Buchstabens in den Bitplanes, in denen das "Y" gezeichnet ist. Dies
ist eine doppelte Pufferung.
Wir werden jedoch nicht nur doppelte Pufferung durchführen. Da der Blitter über
DMA verfügt, kann er tatsächlich eine Bitebene löschen, während die CPU eine 
andere einzieht und die Hardware eine dritte anzeigt. Es ist dreifache
Pufferung:

Bild: Zirkuläre Permutation von Triple-Buffering-Bitplanes

Nach zirkulärer Permutation der drei Bitebenen ...:

	move.l bitplaneA,d0
	move.l bitplaneB,d1
	move.l bitplaneC,d2
	move.l d1,bitplaneA
	move.l d2,bitplaneB
	move.l d0,bitplaneC

... es reicht also aus, die Adresse der Bitplane zu ändern, um anzuzeigen, wo
sie zur Versorgung von BPL1PTH und BPL1PTL in der Copperliste verwendet wird:
	
	movea.l copperlist,a0
	move.w d1,9*4+2(a0)
	move.w d1,10*4+2(a0)
	swap d1
	move.w d1,11*4+2(a0)
	move.w d1,12*4+2(a0)

Von da an ist es möglich, das Löschen der zuvor auf dem Blitter angezeigten
Bitebene zu starten:
	
	WAITBLIT
	move.w #0,BLTDMOD(a5)
	move.w #$0000,BLTCON1(a5)
	move.w #$0100,BLTCON0(a5)
	move.l bitplaneC,BLTDPTH(a5)
	move.w #(DISPLAY_DX>>4)!(256<<6),BLTSIZE(a5)

Wie in einem früheren Artikel erklärt, kann der Blitter Bit-für-Bit
-Quellspeicherblöcke in einem Zielspeicherblock logisch kombinieren. Dafür
basiert es auf einer Formel, die durch die Positionierung von Bits in BLTCON0
beschrieben werden muss, eine logische Verknüpfung durch ODER von logischen
Verknüpfungen durch UND der Daten aus den Quellen A, B und C, möglicherweise
invertiert durch NOT - zum Beispiel D = aBc + aBC + ABc + ABC , was D = B
ergibt, d.h. Kopieren in den Zielspeicherblock D Quellspeicherblock B. Wenn wir
D = 0 angeben, indem wir alle anderen Terme weglassen, die die Formel bilden
können, fragen wir den Blitter, um den Zielspeicherblock mit 0 zu füllen.
Der Blitter läuft parallel zur CPU, Sie müssen nicht warten, bis er das
Löschen des aktuellen Frames der Sinus-Scroll-Animation in seiner Bitebene
beendet hat, um mit dem Zeichnen des nächsten Frames in einer anderen
Bitebene zu beginnen. Es wird immer Zeit geben, auf den Blitter zu warten,
wenn wir ihn verwenden möchten, um einen Charakter zu zeichnen, indem wir
ihn bitten ... um Linien zu zeichnen!

NACH EINEM SINUS VERFORMEN

Das Prinzip des Ein-Pixel-Sinus-Scrolls besteht darin, die 16 Pixelspalten,
die ein Zeichen bilden, in unterschiedlichen Höhen zu zeichnen, wobei
letztere nach dem Sinus eines inkrementierten Winkels zwischen zwei Spalten
berechnet werden.
Die Formel zur Berechnung der Ordinate der Spalte x lautet daher:

y=SCROLL_Y+(SCROLL_AMPLITUDE>>1)*(1+sin(βx))

... wobei β x der Wert des Winkels β für Spalte x ist, inkrementiert um
SINE_SPEED_PIXEL in der nächsten Spalte.

Beachten Sie, dass die Amplitude der Ordinate dann
[ -SCROLL_AMPLITUDE >> 1 , SCROLL_AMPLITUDE >> 1 ] ist, was einer Höhe von
SCROLL_AMPLITUDE + 1 entspricht, wenn SCROLL_AMPLITUDE gerade ist und
SCROLL_AMPLITUDE, wenn dieser Wert ungerade ist.

Zum Beispiel mit SCROLL_Y = 0 , SCROLL_AMPLITUDE = 17 und SINE_SPEED_PIXEL = 10:

Vertikale Verformung von Zeichen entlang eines Sinus

Hoppla! Wir haben ein Detail vergessen: Die Funktion sin() ist nicht im
Befehlssatz 68000 enthalten. Da es nicht in Frage kommt, eine Funktion aus
einer Bibliothek aufzurufen, die teure Berechnungen in CPU-Taktzyklen
durchführt, werden wir die Sinuswerte vorberechnen ​für alle Winkel von
0 bis 359 Grad in 1-Grad-Schritten. Das heißt, wir stellen sie in Form einer
gebrauchsfertigen Tabelle zur Verfügung.
Re-oops! Wir haben ein weiteres Detail vergessen: Wir wissen nicht, wie man mit
Gleitkommazahlen umgeht. Aus den gleichen Gründen werden wir die Sinuswerte als
ganze Zahlen vorberechnen. Und da die Amplitude der Werte [-1, 1] beträgt,
müssen wir diese Werte mit einem Faktor multiplizieren, sonst wären sie auf
-1, 0 und 1 beschränkt. Kurz gesagt, um Excel-Formeln zu verwenden , berechnen
wir ROUND (K * SIN (A); 0), wobei K der Faktor und A der Winkel ist.
Wir werden diesen Faktor nicht zufällig auswählen. Da bei einer Multiplikation
ein Sinuswert verwendet wird, muss der Operation tatsächlich eine Division
durch den fraglichen Faktor folgen. Aus Gründen der Wirtschaftlichkeit
schließen wir die Verwendung des DIVS-Befehls aus, der in Zyklen sehr aufwendig
ist. Es handelt sich um eine arithmetische Verschiebung von Bits nach rechts,
also eine ganzzahlige Division mit Vorzeichen einer Potenz von 2. Der Faktor
muss also die Form 2^N annehmen.
Wir wählen N auf 15 für eine hervorragende Genauigkeit der Sinuswerte und die
Möglichkeit, einen SWAP-Befehl (Verschiebung um 16 Bit nach rechts, daher
Division durch 2^16 gefolgt von einem ROL-Befehl zu verwenden. Verschiebung um
ein Bit nach links, also Multiplikation mit 2), was in Zyklen sparsamer ist
als ein 15-Bit-ASR.L. Die Sinustabelle sieht dann so aus:

sinus:	DC.W 0			; sin(0)*2^15
		DC.W 572		; sin(1)*2^15
		DC.W 1144		; sin(2)*2^15
		DC.W 1715		; sin(3)*2^15
		;...

Es gibt ein kleines Problem, das gelöst werden muss. Tatsächlich führt die
Durchführung einer Multiplikation mit Vorzeichen von 2^N zu einem
16-Bit-Überlauf, wenn der Sinuswert -1 oder 1 ist. Somit ergibt
1 * 32768 = 32768, einen 17-Bit-Wert mit Vorzeichen, der daher nicht in die
Wertetabelle mit Vorzeichen 16 Bit des Sinus passt. Unter diesen Bedingungen
könnte diese Tabelle keine Werte enthalten, die genau den Umrechnungen von
-1 und 1 entsprechen, sondern nur sehr nahe Annäherungen: -32767 und 32767.
Wir beschließen, diese Ungenauigkeit nicht zu tolerieren, und deshalb wird N
von 15 auf 14 reduziert, obwohl wir dadurch gezwungen sind, dem SWAP mit
einem 2-Bit-ROL.L statt einem zu folgen. Demonstration, dass dies an den
Grenzen liegt:
	
	move.w #$7FFF,d0	; 2^15-1=32767
	move.w #$C000,d1	; sin(-90)*2^14
	muls d1,d0			; $E0004000
	swap d0				; $4000E000
	rol.l #2,d0			; $00038001 => $8001=-32767 OK

	move.w #$7FFF,d0	; 2^15-1=32767
	move.w #$4000,d1	; sin(90)*2^14
	muls d1,d0			; $1FFFC000
	swap d0				; $C0001FFF
	rol.l #2,d0			; $00007FFF => $7FFF=32767 OK

Letztlich sieht die Sinustabelle so aus:

sinus:	DC.W 0			; sin(0)*2^14
		DC.W 286		; sin(1)*2^14
		DC.W 572		; sin(2)*2^14
		DC.W 857		; sin(3)*2^14
		;...

Das 16-Bit-Ergebnis der Multiplikation eines in D1 gespeicherten 16-Bit-Wertes
mit Vorzeichen mit dem Sinus eines in Grad ausgedrückten Winkels, der in D0
gespeichert ist, wird wie folgt erhalten:
	
	lea sinus,a0
	lsl.w #1,d0
	move.w (a0,d0.w),d2
	muls d2,d1
	swap d1
	rol.l #2,d1

Definieren Sie SCROLL_DY als die Höhe des Bandes, das der Sinus-Scroll auf dem
Bildschirm einnehmen kann. Daher muss SCROLL_AMPLITUDE so sein, dass
(SCROLL_AMPLITUDE>>1)*(1+sin(βx)) Werte generiert, die in
[0, SCROLL_DY-16] enthalten sind. Dies ist nur möglich, wenn dieses Intervall
eine ungerade Anzahl von Werten hat, also wenn SCROLL_DY-16 gerade ist. Das ist
gut, denn wir möchten, dass der Bildlauf vertikal auf der Ordinate SCROLL_Y
zentriert ist, was bedeutet, dass SCROLL_DY gerade ist, weil DISPLAY_DY, die
Höhe des Bildschirms, gerade ist. Welche geben:

SCROLL_DY=100
SCROLL_AMPLITUDE=SCROLL_DY-16
SCROLL_Y=(DISPLAY_DY-SCROLL_DY)>>1

Wo wir gerade dabei sind, definieren wir Konstanten, die die Abszisse
definieren, an der das Scrollen beginnt, und die Anzahl der Pixel, die es
überspannt. Standardmäßig ist dies die volle Breite des Bildschirms:

SCROLL_DX=DISPLAY_DX
SCROLL_X=(DISPLAY_DX-SCROLL_DX)>>1

Die Ordinate jeder Spalte eines Zeichens der Sinus Scroller kann berechnet werden,
es ist jetzt möglich, letztere zu zeichnen. Zuerst müssen Sie das Scrollen und
die Animation einrichten ...

;------------------------------------------------------------------------------
; Teil 3

CODIEREN EINES SINUSSCROLLERS AUF DEM AMIGA (3/5)

3. Juli 2017 Amiga, Assembler 68000, Blitter, Copper, Sinus Scroller

Dieser Artikel ist der dritte in einer Reihe von fünf, die sich der
Programmierung eines Ein-Pixel-Sinus-Scrolls auf dem Amiga widmet, einem
Effekt, der seit einiger Zeit von Democodern und anderen Cracktros weit
verbreitet ist. Zum Beispiel in diesem Cracktro aus der Supplex-Gruppe:

Bild: Sinus Scroller in einem Cracktro der Gruppe Supplex

Im ersten Artikel haben wir gesehen, wie man in einer Entwicklungsumgebung auf
einem mit WinUAE emulierten Amiga installiert und die grundlegende Copperliste
codiert, um etwas auf dem Bildschirm anzuzeigen. Im zweiten Artikel haben wir
gesehen, wie man eine 16x16-Schrift vorbereitet, um die Pixelspalten der
Zeichen darin einfach anzuzeigen, die zum Warp-Text erforderlichen Sinuswerte
durch Ändern der Ordinate der Spalten vorzuberechnen und eine dreifache
Pufferung richtig einzurichten zum Wechseln der Bilder auf dem Bildschirm.

In diesem dritten Artikel gehen wir der Sache auf den Grund, indem wir sehen,
wie man den Sinus Scroller zuerst mit der CPU, dann mit dem Blitter zeichnet 
und animiert.
Klicken Sie hier, um das Archiv mit dem Code und den Daten des hier gezeigten
Programms herunterzuladen - es ist das gleiche wie in den anderen Artikeln.

NB: Dieser Artikel liest sich am besten, wenn man sich das ausgezeichnete Modul
anhört, das Nuke / Anarchy für den Zeitschriftenteil von Stolen Data #7
komponiert hat, aber es ist eine Frage des persönlichen Geschmacks ...

Klicken Sie hier , um diesen Artikel auf Englisch zu lesen.

SCROLLEN UND ANIMIEREN SIE DEN Sinus Scroller

Die Hauptschleife kann nun vollständig beschrieben werden. Es führt bei jeder
Iteration nacheinander die folgenden Aufgaben aus:
 - warten Sie, bis der Elektronenstrahl das Zeichnen des frames beendet hat;
 - drehen Sie die drei Bitebenen kreisförmig, um das letzte Bild anzuzeigen;
 - warte auf den Blitter und starte das Löschen der Bitebene C, die das
   vorletzte Bild enthält;
 - Zeichne den Text in Bitebene B, der das vorletzte Bild enthielt;
   den Index der ersten Spalte des ersten Zeichens des zu zeichnenden Textes
   animieren;
 - animieren Sie den Sinus dieser ersten Spalte;
 - Testen Sie, ob die linke Maustaste gedrückt ist.

Die ersten drei Aufgaben wurden bereits beschrieben. Wir werden daher folgendes
beschreiben.
Der Sinus-Scroll wird von einer Schleife gezeichnet, die SCROLL_DX
aufeinanderfolgende Zeichenspalten von Text aus der SCROLL_X- Spalte in der
Bitebene zeichnet. Die Indizes der ersten zu zeichnenden Spalte und des ersten
Zeichens, aus dem sie stammt, werden in den Variablen scrollColumn bzw.
scrollChar gespeichert. Der Sinus - Offset von der ersten Spalte der Sinus
Welle ist in einer gehaltenen Winkel variabel.
Lassen Sie uns das Problem der Sinus-Scroll-Animation in der Hauptschleife
sofort lösen. Das Scrollen des Textes entlang eines Sinus wäre nicht von
großem Interesse, wenn der Sinus nicht selbst animiert wäre - es würde einfach
so aussehen, als ob Sie eine Achterbahn fahren würden. Dazu dekrementieren wir
den Sinus-Offset der ersten Spalte des Sinus-Scrolls bei jedem Frame, nicht
ohne zu vergessen, den möglichen Überlauf zu verwalten:
	
	move.w angle,d0
	sub.w #(SINE_SPEED_FRAME<<1),d0
	bge _angleFrameNoLoop
	add.w #(360<<1),d0
_angleFrameNoLoop:
	move.w d0,angle

Außerdem muss der Text von links nach rechts scrollen. Dazu inkrementieren wir
den Index der ersten Spalte im Text um SCROLL_SPEED. Hier haben wir es mit zwei
möglichen Überläufen zu tun: dem Überlauf eines Zeichens, um von der letzten
Spalte eines Zeichens in die erste des nächsten Zeichens zu gelangen, und dem
Überlauf des Textes, vom letzten Zeichen des Textes zum Ersten:
	
	move.w scrollColumn,d0
	addq.w #SCROLL_SPEED,d0
	cmp.b #15,d0				; Ist die nächste Spalte nach der letzten 
								; Spalte des aktuellen Zeichens?
	ble _scrollNextColumn		; Wenn nicht, die Spalte belassen
	sub.b #15,d0				; Wenn ja, Wert ändern für eine Spalte im
								; nächsten Zeichen ...
	move.w scrollChar,d1
	addq.w #1,d1				; ... und gehe zum nächsten Zeichen
	lea text,a0
	move.b (a0,d1.w),d2
	bne _scrollNextChar			; ... und prüfen, ob dieses nächste Zeichen
								; hinter dem Textende liegt
	clr.w d1					; ... und wenn ja, dann zurück zum ersten
								; Zeichen des Textes
_scrollNextChar:
	move.w d1,scrollChar
_scrollNextColumn:
	move.w d0,scrollColumn

Wir können jetzt mit dem Zeichnen des Sinus Scrollers fortfahren. Letzteres
wird durch die oben erwähnte Schleife bereitgestellt, die in der Hauptschleife
untergebracht ist. Bevor wir diese Schleife starten, müssen wir eine Reihe von
Initialisierungen durchführen, um die Verwendung von Registern zu maximieren
und die Notwendigkeit zum Abrufen von Daten im Speicher zu minimieren.
Zuerst bestimmen wir den Offset (D6) des Wortes in der Bitebene, in der
sich das Bit befindet, das der ersten zu zeichnenden Spalte entspricht, und
identifizieren dieses Bit (D7):

	; den Wort-Offset der Bitebene der ersten Spalte bestimmen, in der
	; gezeichnet werden soll
	moveq #SCROLL_X,d6
	lsr.w #3,d6		; Offset des Bytes in der Bitebene, in dem die Spalte liegt
	bclr #0,d6		; Offset des Wortes, in dem die Spalte liegt
					; (das gleiche ie lsr.w #4 then lsl.w #1)

	; Bestimmen Sie das Bit in diesem Wort, das dieser Spalte entspricht
	moveq #SCROLL_X,d4
	and.w #$000F,d4
	moveq #15,d7
	sub.b d4,d7		; Bit im Wort

Dann bestimmen wir die Adresse (A0) des aktuellen Zeichens sowie die (A1) des
Wortes im 16x16-Font seiner aktuellen Spalte (D4), das in die aktuelle Spalte
der momentan genannten Bitebene gezeichnet werden soll:
	
	move.w scrollChar,d0
	lea text,a0
	lea (a0,d0.w),a0
	move.w scrollPixel,d4
	clr.w d1
	move.b (a0)+,d1
	subi.b #$20,d1
	lsl.w #5,d1				; 32 Bytes pro Zeichen in 16x16-Schriftart
	move.w d4,d2			; Spalte des zu zeichnenden Zeichens
	lsl.w #1,d2				; 2 Bytes pro Zeile in der 16x16 Schriftart (Font)
	add.w d2,d1
	move.l font16,a1
	lea (a1,d1.w),a1		; Adresse (Wort) der zu zeichnenden Spalte
	
Im vorherigen Code wird der Offset der ersten Spalte eines Zeichens aus dem
ASCII-Code dieses Zeichens abgeleitet, von dem wir $20 abziehen müssen -
praktischer Aspekt der 8x8-Schriftart, die als Grundlage für die
16x16-Schriftart diente, die Zeichen sind so sortiert.
Schließlich führen wir verschiedene Initialisierungen von in der Schleife
wiederholt verwendeten Registern durch, einschließlich des Sinus-Offsets
der aktuellen Spalte (D0) und der Anzahl der noch zu zeichnenden Spalten (D1):

	move.w angle,d0
	move.w #SCROLL_DX-1,d1
	move.l bitplaneB,a2

Letztendlich sehen die Register am Anfang der Schleife so aus:

Register	Inhalt
D0			Sinus-Offset der aktuellen Spalte, in der in die Bitebene gezeichnet
			werden soll	
D1			Aktuelle Spalte zum Zeichnen in der Bitebene
D4			Aktuelle Spalte des aktuell zu zeichnenden Charakters
D6			Offset des Wortes in der Bitebene, das die aktuelle Spalte enthält,
			in der gezeichnet werden soll
D7			Bit in diesem Wort, das dieser Spalte entspricht
A0			Adresse des aktuellen Zeichens im Text
A1			Adresse des Wortes in der Schriftart, die der aktuellen Spalte
			dieses Zeichens entspricht
A2			Bitplane-Adresse, wo gezeichnet werden soll

Die Zeichenschleife der SCROLL_DX- Spalten des Sinus-Scrolls führt bei jeder
Iteration nacheinander die folgenden Aufgaben aus:
Berechnen der Adresse des Wortes, das das erste Pixel der Spalte in der
Bitebene enthält;
die aktuelle Spalte des aktuellen Zeichens anzeigen;
gehe zur nächsten Spalte des aktuellen Zeichens oder zur ersten Spalte des
nächsten Zeichens oder zum ersten Zeichen des Textes;
den Winkel der aktuellen Spalte verringern.
Die Berechnung der Adresse (A4) des Wortes, das das erste Pixel der Spalte
in der Bitebene enthält, basiert auf einer Multiplikation mit einem mit
einer Zweierpotenz vorberechneten Sinuswert, wie wir bereits gesehen haben:
	
	lea sinus,a6
	move.w (a6,d0.w),d1
	muls #(SCROLL_AMPLITUDE>>1),d1
	swap d1
	rol.l #2,d1
	add.w #SCROLL_Y+(SCROLL_AMPLITUDE>>1),d1
	move.w d1,d2
	lsl.w #5,d1
	lsl.w #3,d2
	add.w d2,d1	; D1=(DISPLAY_DX>>3)*D1=40*D1=(32*D1)+(8*D1)=(2^5*D1)+(2^3*D1)
	add.w d6,d1
	lea (a2,d1.w),a4

Ja! D1 wird hier als temporäre Variable verwendet, obwohl sie initialisiert
wurde, um als Zähler für die Schleife zu dienen. Dies liegt daran, dass uns,
wie wir gleich sehen werden, die Register ausgehen. Als Ergebnis beginnt und
endet die Schleife mit einem kurzen Austausch mit dem Stack:

_writeLoop:
	move.w d1,-(sp)
	;...
	move.w (sp)+,d1
	dbf d1,_writeLoop

Wir können dann die aktuelle Spalte des aktuellen Zeichens in der aktuellen
Spalte der Bitebene anzeigen. Das Prinzip der Anzeige ist recht einfach, da
die Schrift 16x16 einer Rotation unterzogen wurde, die es ermöglicht, die
aufeinanderfolgenden Bits eines Wortes zu testen, das der anzuzeigenden
Spalte entspricht, anstatt dasselbe Bit von aufeinanderfolgenden Wörtern
zu testen:

Bild: Ein Zeichen Pixel für Pixel anzeigen

Zeigt die aktuelle Spalte (Wort in A1) des aktuellen Zeichens in der aktuellen
Spalte der Bitebene (Bit D7 des Wortes in A4) an, dies ergibt:
	
	move.w (a1),d1
	clr.w d2
	moveq #LINE_DX,d5
_columnLoop:
	move.w (a4),d3
	btst d2,d1
	beq _pixelEmpty
	bset d7,d3
	bra _pixelFilled
_pixelEmpty:
	bclr d7,d3
_pixelFilled:
	move.w d3,(a4)
	lea DISPLAY_DX>>3(a4),a4
	addq.b #1,d2
	dbf d5,_columnLoop

Sobald diese Anzeige abgeschlossen ist, können wir mit der nächsten Spalte des
Textes fortfahren, dh der nächsten Spalte des aktuellen Zeichens oder der
ersten Spalte des nächsten Zeichens, es sei denn, das aktuelle Zeichen ist
das letzte und wir musste zum ersten Zeichen des Textes zurückschleifen und
den Text der Sinus Scroller endlos wiederholen:
	
	addq.b #1,d4
	btst #4,d4
	beq _writeKeepChar
	bclr #4,d4
	clr.w d1
	move.b (a0)+,d1
	bne _writeNoTextLoop
	lea text,a0
	move.b (a0)+,d1
_writeNoTextLoop
	subi.b #$20,d1
	lsl.w #5,d1
	move.l font16,a1
	lea (a1,d1.w),a1
	bra _writeKeepColumn
_writeKeepChar:
	lea 2(a1),a1
_writeKeepColumn:

Diese nächste Spalte befindet sich auf einer anderen Ordinate, bestimmt durch
Dekrementieren des aktuellen Sinus-Offsets ...:
	
	subq.w #(SINE_SPEED_PIXEL<<1),d0
	bge _anglePixelNoLoop
	add.w #(360<<1),d0
_anglePixelNoLoop:

... und es wird in der nächsten Spalte der Bitebene angezeigt, möglicherweise
in dem Wort, das dem aktuellen Wort folgt:
	
	subq.b #1,d7
	bge _pixelKeepWord
	addq.w #2,d6
	moveq #15,d7
_pixelKeepWord:

DIE WIRTSCHAFT DANK DES BLITTERS ANZIEHEN

Das Anzeigen von Spalten für die CPU ist eine schwere Aufgabe für die CPU. Es
gibt einen schnellen Weg, um es zu lindern: Verwenden Sie den Blitter.
In einem früheren Artikel haben wir gesehen, dass Sie mit dem Blitter Blöcke
kopieren und Linien zeichnen können. Dieses letzte Merkmal ist in diesem Fall
besonders interessant, da der Blitter eine Linie zeichnen kann, die ein Muster
von 16 Pixeln wiedergibt. Könnte dieses Muster nicht die Spalte eines zu
zeichnenden Zeichens sein? Bestimmt. Wir werden daher den Blitter verwenden,
um so viele Linien mit 16 Pixeln, vertikal und texturiert, zu zeichnen, wie
Spalten des Sinus-Scrolls zu zeichnen sind.
Das Zeichnen einer Spalte in der CPU erfolgt von oben nach unten, das Zeichnen
im Blitter muss jedoch in umgekehrter Reihenfolge erfolgen. Tatsächlich ist
das Muster der Spalte so ausgerichtet, dass sein Bit 15 nicht dem ersten Pixel
der Spalte entspricht, sondern ihrem letzten.

Bild: Anzeige einer einstelligen Spalte im Blitter

Das Konfigurieren des Blitters zum Zeichnen von Linien ist etwas mühsam, da
Sie Werte in mehreren Registern speichern müssen. Ein Großteil dieser
Initialisierung kann einmal und für alle zu zeichnenden Linien durchgeführt
werden. Tatsächlich wird der Inhalt der betreffenden Register während einer
Linienzeichnung nicht geändert. Sie gilt daher für alle Linien.
Beginnen wir mit der Definition einiger Parameter, um uns zurechtzufinden:

LINE_DX=15	; Anzahl Zeilen pro Zeile-1: LINE_DX = max (abs(15-0), abs(0,0))
LINE_DY=0	; Anzahl der Spalten der Zeile-1: LINE_DY = min (abs(15-0), abs(0,0))
LINE_OCTANT=1

Wir fahren dann mit dem wiederkehrenden Teil der Initialisierung des Blitters
fort:
	
	move.w #4*(LINE_DY-LINE_DX),BLTAMOD(a5)
	move.w #4*LINE_DY,BLTBMOD(a5)
	move.w #DISPLAY_DX>>3,BLTCMOD(a5)
	move.w #DISPLAY_DX>>3,BLTDMOD(a5)
	move.w #(4*LINE_DY)-(2*LINE_DX),BLTAPTL(a5)
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$FFFF,BLTALWM(a5)
	move.w #$8000,BLTADAT(a5)
	move.w #(LINE_OCTANT<<2)!$F041,BLTCON1(a5)
				; BSH3-0=15, SIGN=1, OVF=0, SUD/SUL/AUL=octant, SING=0, LINE=1

Für jede zu zeichnende Spalte müssen wir dem Blitter die Adresse des Wortes
mit dem Startpixel des rechten in BPLCPTH / BLTCPTL und BLTDPTH / BLTDPTL,
die Nummer dieses Pixels in BLTCON0 und das Muster des rechten in BLTADAT
mitteilen.
	
	WAITBLIT
	lea LINE_DX*(DISPLAY_DX>>3)(a4),a4
	move.l a4,BLTCPTH(a5)
	move.l a4,BLTDPTH(a5)
	move.w (a1),BLTBDAT(a5)
	move.w d7,d2
	ror.w #4,d2
	or.w #$0B4A,d2
	move.w d2,BLTCON0(a5)		
				; ASH3-0=pixel, USEA=1, USEB=0, USEC=1, USED=1, LF7-0=AB+AC=$4A

Ein Schreiben in BLTSIZE, das das Zeichnen einer Linie von 16 Pixeln anfordert,
ermöglicht es Ihnen, den Blitter zu starten:
	
	move.w #((LINE_DX+1)<<6)!$0002,BLTSIZE(a5)

Dieser Code ersetzt fast denjenigen, mit dem eine Spalte auf der CPU gezeichnet
wird. Der einzige bemerkenswerte Unterschied besteht darin, wie diese Spalte
identifiziert wird. Bei der CPU wird die Nummer des Bits im aktuellen Wort
verwendet. Beim Blitter ist es die Nummer des Pixels in diesem Wort. Diese
Nummerierungen sind zueinander entgegengesetzt: Pixel 15 entspricht Bit 0;
Pixel 14, bei Bit 1; etc.
In der Quelle koexistieren die Codes der Versionen für CPU und Blitter.
Eine BLITTER- Konstante wird verwendet, um zum Testen von einem zum anderen
zu wechseln (0 zum Zeichnen mit der CPU und 1 zum Zeichnen mit dem Blitter):

BLITTER=1

Der Wert dieser Konstante bedingt die Kompilierung von Codeteilen. Beispielsweise :
	
	IFNE BLITTER

	moveq #SCROLL_X,d7
	and.w #$000F,d7

	ELSE
	
	moveq #SCROLL_X,d4
	and.w #$000F,d4
	moveq #15,d7
	sub.b d4,d7

	ENDC

Es ist fertig! Der Sinus-Scroll wird angezeigt. Es bleibt jedoch, es zu
verschönern, indem einige kostengünstige Effekte in Zyklen hinzugefügt
werden, und insbesondere den Code zu optimieren ...

;------------------------------------------------------------------------------
; Teil 4

CODIEREN EINES SINUSSCROLLERS AUF DEM AMIGA (4/5)

6. Juli 2017 Amiga, Assembler 68000, Blitter, Copper, Sinus Scroller

Dieser Artikel ist der vierte in einer Reihe von fünf Artikeln, die sich der
Programmierung eines Ein-Pixel-Sinus-Scrolls auf dem Amiga widmet, ein Effekt,
der seit einiger Zeit von Democodern und anderen Cracks weit verbreitet ist.
Zum Beispiel in diesem so schönen wie Vintage- Intro von der Gruppe Miracle:

Bild: Sinus Scroller in einem Intro der Gruppe Miracle

Im ersten Artikel haben wir gesehen, wie man in einer Entwicklungsumgebung auf
einem mit WinUAE emulierten Amiga installiert und die grundlegende Copperliste
codiert, um etwas auf dem Bildschirm anzuzeigen. Im zweiten Artikel haben wir
gesehen, wie man eine 16x16-Schrift vorbereitet, um die Pixelspalten der
Zeichen darin einfach anzuzeigen, die zum Warp-Text erforderlichen Sinuswerte
durch Ändern der Ordinate der Spalten vorzuberechnen und eine dreifache
Pufferung richtig einzurichten zum Wechseln der Bilder auf dem Bildschirm.
Schließlich haben wir im dritten Artikel gesehen, wie man den Sinus-Scroll
zuerst mit der CPU, dann mit dem Blitter zeichnet und animiert.
In diesem vierten Artikel werden wir den Sinus-Scroll mit einigen
kostenlosen Effekten in Zyklen verschönern, die vom Copper bereitgestellt
werden, und die Hand so sauber wie möglich für das Betriebssystem zu machen.

Klicken Sie hier, um das Archiv mit dem Code und den Daten des hier
gezeigten Programms herunterzuladen - es ist das gleiche wie in den anderen
Artikeln.

NB: Dieser Artikel liest sich am besten, wenn man sich das ausgezeichnete Modul
anhört, das Nuke / Anarchy für den Zeitschriftenteil von Stolen Data #7
komponiert hat, aber es ist eine Frage des persönlichen Geschmacks ...

Update vom 17.07.2017: Warten auf den Blitter, bevor mit der Finalisierung
fortgefahren wird.

Klicken Sie hier, um diesen Artikel auf Englisch zu lesen.

FÜGEN SIE SCHATTEN UND SPIEGEL HINZU DANK DES COPPERS

Was ist ein Schattenwurf im Südosten, wenn nicht eine Bitebene, die wir von
unten selbst anzeigen, indem wir sie leicht nach rechts und unten
verschieben? Und was ist ein Spiegel, wenn nicht eine Bitebene, die wir ab
einer bestimmten Zeile weiterhin anzeigen, aber in letzterer Zeile für
Zeile nach oben statt nach unten gehen?
So gesehen erscheinen Spiegel- und Schatteneffekte trivial. Leicht zu sagen?
Einfach zu erledigen! Dank des Coppers, der es ermöglicht, am Anfang jeder
Zeile die Adresse, an der die Hardware die Daten aus der Bitebene lesen
muss, und die Verzögerung, mit der er sie anzeigen muss, sehr einfach zu
ändern.
Beginnen wir wie gewohnt mit der Definition der Parameter der zu erzeugenden
Effekte:

 - SHADOW_DX und SHADOW_DY entsprechen der Größe des Schattens rechts bzw.
   unten und SHADOW_COLOR der Farbe des letzteren;
 - MIRROR_Y entspricht der Ordinate, bei der der Spiegel beginnt, und
   MIRROR_COLOR und MIRROR_SCROLL_COLOR der Hintergrundfarbe bzw. der Farbe des
   Scrollers im Spiegel.

SHADOW_DX=2						; zwischen 0 und 15
SHADOW_DY=2
SHADOW_COLOR=$0777
MIRROR_Y=SCROLL_Y+SCROLL_DY
MIRROR_COLOR=$000A
MIRROR_SCROLL_COLOR=$000F

Versuchen wir also, klarer zu sehen, wie die Copperliste angezeigt werden
sollte. Die Erfahrung zeigt, dass es besser ist, den Fluss von Zeile-zu-Zeile-
Operationen zu skizzieren, anstatt kopfüber zu schreiben - der Copper
ermöglicht es Ihnen, MOVEs inline auszuführen, aber das wird hier nicht
nützlich sein. Um das Diagramm nicht zu überladen, muss durch die Erwähnung
einer Konstanten in eckigen Klammern DISPLAY_Y hinzugefügt werden.

Bild: WAIT and MOVE für Schatten und Spiegel

Der Schatten zuerst. Die Hardware liest die Daten aus der anzuzeigenden
Bitplane-Zeile an der 32-Bit-Adresse, die in den 16-Bit-Registern BLT1PTH und
BPL1PTL enthalten ist, die sie während ihres Fortschreitens entlang der Zeile
inkrementiert. Am Ende der Zeile, bevor die nächste gestartet wird, fügt es
BPL1MOD zu diesen Registern hinzu, um die Adresse zu erhalten, an der es
beginnt, die Daten für die nächste Zeile zu lesen.
Bisher war die Anzeige auf eine Bitebene, Bitebene 1 beschränkt. Wir fügen eine
Bitebene 2 hinzu, um der Hardware anzuzeigen, dass die Daten dieser zweiten
Bitebene die gleichen sind wie die der ersten:
	
	move.l bitplaneA,d0
	move.w #BPL1PTL,(a0)+
	move.w d0,(a0)+
	move.w #BPL2PTL,(a0)+
	move.w d0,(a0)+
	swap d0
	move.w #BPL1PTH,(a0)+
	move.w d0,(a0)+
	move.w #BPL2PTH,(a0)+
	move.w d0,(a0)+

Das Hinzufügen einer Bitplane bewirkt einige weitere Änderungen an der
Copperliste: spezifizieren Sie das Modulo gerader Bitplanes und nicht mehr nur
das von ungeraden Bitplanes:
	
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+

Geben Sie zwei zusätzliche Farben an, da die Palette auf 4 Farben erweitert
wird:

	move.w #COLOR02,(a0)+
	move.w #SCROLL_COLOR,(a0)+
	move.w #COLOR03,(a0)+
	move.w #SCROLL_COLOR,(a0)+

Indem wir DISPLAY_DEPTH auf 2 übergeben, ändern wir nebenbei den Wert, den das
Copper in BPLCON0 speichert, um die Anzahl der Bitplanes anzugeben, also hier
nichts zu ändern.
Bis zur Zeile [ SCROLL_Y + SHADOW_DY-1 ] werden die beiden Bitplanes
überlagert. Der Sinus-Scroll wird daher mit der Farbe 3 dargestellt, weshalb
SCROLL_COLOR in COLOR03 hinterlegt ist.
Von [ SCROLL_Y + SHADOW_DY ] werden die beiden Bitebenen verschoben:
Horizontal, indem an SHADOW_DX in BPLCON1 der Wert der Verzögerung übergeben
wird, mit der die Hardware die geraden Bitebenen anzeigt. Diese Änderung muss
beim Copper am Anfang der Zeile [ SCROLL_Y + SHADOW_DY ] angefordert werden.
Beachten Sie, dass SHADOW_DX 15 nicht überschreiten darf; darüber hinaus müssen
Sie gleichzeitig auf BPL2PTH, BPL2PTL und BPLCON1 spielen.
Vertikal durch Übergabe an [ -SHADOW_DY * (DISPLAY_DX >> 3) ] das Modulo der 
geraden Bitebenen in BPL2MOD. Diese Änderung muss vom Copper am Anfang der
Zeile [ SCROLL_Y + SHADOW_DY -1 ] angefordert werden, um die nächste Zeile
zu beeinflussen, wie zuvor erklärt.

Bild: Versetzen Sie Bitebenen, um Schatten zu erzeugen

Auf Zeile [ SCROLL_Y + SHADOW_DY ] wird die Zeilenadresse von Bitebene 2 zu der
von Bitebene 1 minus SHADOW_DY- Zeilen. Danach ist es notwendig, dass die
Anzeige der Bitebene 2 normal weiterläuft, und deshalb muss BPL2MOD am Anfang
der Zeile auf 0 zurückgehen [ SCROLL_Y + SHADOW_DY ]. Andernfalls würde die
wiederholte Zeile auf unbestimmte Zeit wiederholt.
Der Spiegel dann. Somit kann BPLxMOD verwendet werden, um die Hardware
aufzufordern, zurückzugehen, um die Anzeige von Bitplanes ab einer bestimmten
Zeile zu wiederholen. Wenn DISPLAY_DX der Breite der Bitplanes entspricht,
dann:
 - am Anfang der Zeile [ MIRROR_Y-1 ] wird das Modulo an - (DISPLAY_DX >> 3)
   übergeben, die Zeile [ MIRROR_Y-1 ] wiederholt, die auf der folgenden Zeile
   [ MIRROR_Y ] gezeichnet wird ;
 - am Anfang der Zeile [ MIRROR_Y ] wird durch Ändern von Modulo auf
   -2 * (DISPLAY_DX >> 3) die bereits gezeichnete Zeile [ MIRROR_Y-2 ] in der
   folgenden Zeile [ MIRROR_Y + 1 ] wiederholt, wodurch ein Spiegeleffekt
   erzeugt wird;
 - solange dieser Modulo beibehalten wird, wiederholt er auf Linie y die bei
   2 * MIRROR_Y-1-y gezeichnete Linie, wodurch der Spiegeleffekt
   aufrechterhalten wird.
Nachdem wir uns entschieden haben, dass der Beginn des Spiegeleffekts mit
dem Ende des Schatteneffekts zusammenfällt, müssen wir noch die Farben 0 und 3
über COLOR00 und COLOR03 am Anfang der Zeile [ MIRROR_Y ] ändern, damit der
Sinus Scroller zu in einem anderen Medium reflektiert werden.

Bild: Wiederholte Linien, die bereits gezeichnet wurden, um den Spiegel zu erzeugen

Alle MOVEs, die der Copper ausführen muss, um das gerade Beschriebene zu
erreichen, sollten nur ganz am Anfang bestimmter Zeilen auftreten. Diesen
Befehlen geht daher WAIT voraus, das den Copper anweist, zu warten, bis der
Elektronenstrahl bestimmte Linien erreicht oder passiert hat.
Zur Erinnerung: ein WAIT Befehl für eine Position ( x , y ) auf dem Bildschirm
nimmt die Form von zwei Worten, ein Wort (y<<8)!((x>>2)<<1)!$0001 , 
gefolgt von einem weiteren, das als Maske dient, um dem Copper anzuzeigen,
auf welche Bits der Koordinaten der Vergleich zwischen der angezeigten Position
und der des Elektronenstrahls erfolgen soll.
In diesem Fall möchten wir, dass das Copper einfach die Ordinaten vergleicht.
Alle unsere WAITs haben also die Form eines Wortes (y<<8)!$0001 gefolgt
von einem Wort $FF00.
Wir beginnen also mit der vertikalen Verschiebung des Schattens ...:
	
	move.w #((DISPLAY_Y+SCROLL_Y+SHADOW_DY-1)<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #-SHADOW_DY*(DISPLAY_DX>>3),(a0)+

... gefolgt vom horizontalen Versatz ...:

	move.w #((DISPLAY_Y+SCROLL_Y+SHADOW_DY)<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #SHADOW_DX<<4,(a0)+

... gefolgt vom Ende der vertikalen Verschiebung des Schattens und dem Beginn
des Spiegels ...:

	move.w #((DISPLAY_Y+MIRROR_Y-1)<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #-(DISPLAY_DX>>3),(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #(SHADOW_DY-1)*(DISPLAY_DX>>3),(a0)+

... gefolgt vom Ende der horizontalen Verschiebung des Schattens und der
Wiederholung der Linien im Spiegel sowie der in letzterem geltenden Palette:
	
	move.w #((DISPLAY_Y+MIRROR_Y)<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #-(DISPLAY_DX>>2),(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #-(DISPLAY_DX>>2),(a0)+
	move.w #COLOR00,(a0)+
	move.w #MIRROR_COLOR,(a0)+
	move.w #COLOR03,(a0)+
	move.w #MIRROR_SCROLL_COLOR,(a0)+

GIB DEM BETRIEBSSYSTEM ETWAS ZURÜCK

Wenn der Benutzer die Maustaste klickt, müssen wir dem Betriebssystem die
Kontrolle sauber zurückgeben - zumindest so sauber wie möglich, denn es gibt
keine Garantie, dass er sich von dem erholt, was wir ihm beim Arbeiten an
der Hardware angetan haben.
Zunächst stellen wir sicher, dass der Blitter nicht arbeitet:
	
	WAITBLIT

Dann deaktivieren wir die Interrupts und DMA-Kanäle ...:
	
	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

... und wir reaktivieren sie, nachdem wir sie in den Zustand zurückversetzt
haben, in dem wir sie vorgefunden haben:
	
	move.w olddmacon,d0
	bset #15,d0
	move.w d0,DMACON(a5)
	move.w oldintreq,d0
	bset #15,d0
	move.w d0,INTREQ(a5)
	move.w oldintena,d0
	bset #15,d0
	move.w d0,INTENA(a5)

Anschließend setzen wir die Workbench Copperliste wieder ein. Seine Adresse
befindet sich an einem bestimmten Offset von der Basisadresse der
Grafikbibliothek. Um darauf zuzugreifen, öffnen wir diese Bibliothek durch
einen Aufruf der OldOpenLib()-Funktion von Exec. Sobald die Adresse der Copper-
Liste abgerufen wurde, bitten wir den Copper, diese ab sofort zu verwenden:
	
	lea graphicslibrary,a1
	movea.l $4,a6
	jsr -408(a6)
	move.l d0,a1
	move.l 38(a1),COP1LCH(a5)
	clr.w COPJMP1(a5)
	jsr -414(a6)

Wir stellen den normalen Betrieb des Systems durch einen Aufruf der
Permit()-Funktion von Exec wieder her:
	
	movea.l $4,a6
	jsr -138(a6)

Wir geben den Speicherplatz frei, der im Speicher durch so viele Aufrufe der
FreeMem()-Funktion von Exec zugewiesen wurde:
	
	movea.l font16,a1
	move.l #256<<5,d0
	movea.l $4,a6
	jsr -210(a6)
	movea.l bitplaneA,a1
	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	movea.l $4,a6
	jsr -210(a6)
	movea.l bitplaneB,a1
	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	movea.l $4,a6
	jsr -210(a6)
	movea.l bitplaneC,a1
	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	movea.l $4,a6
	jsr -210(a6)
	movea.l copperlist,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

Von da an müssen wir nur noch die Register entstapeln und die Kontrolle
abgeben:

	movem.l (sp)+,d0-d7/a0-a6
	rts

Es bleibt abzuwarten, ob das alles in den frame passt, und den Code zu
optimieren, wenn dies nicht der Fall ist ...

;------------------------------------------------------------------------------
; Teil 5

CODIEREN EINES SINUSSCROLLERS AUF DEM AMIGA (5/5)

8. Juli 2017 Amiga, Assembler 68000, Blitter, Copper, Sinus Scroller

Dieser Artikel ist der fünfte und letzte Artikel in einer Reihe von fünf, die
sich der Programmierung eines Sinus-Scrolls mit einem Pixel auf dem Amiga
widmet, ein Effekt, der seit einiger Zeit von Demo-Programmierern und anderen
Cracks weit verbreitet ist. Zum Beispiel in diesem Cracktro aus der Angels-Gruppe:

Bild: Sinus Scroller in einem Cracktro der Angels-Gruppe

Im ersten Artikel haben wir gesehen, wie man in einer Entwicklungsumgebung auf
einem mit WinUAE emulierten Amiga installiert und die grundlegende Copperliste
codiert, um etwas auf dem Bildschirm anzuzeigen. Im zweiten Artikel haben wir
gesehen, wie man eine 16x16-Schrift vorbereitet, um die Pixelspalten der
Zeichen darin einfach anzuzeigen, die zum Warp-Text erforderlichen Sinuswerte
durch Ändern der Ordinate der Spalten vorzuberechnen und eine dreifache
Pufferung richtig einzurichten zum Wechseln der Bilder auf dem Bildschirm.
Schließlich haben wir im dritten Artikel gesehen, wie man den Sinus-Scroll
zuerst mit der CPU, dann mit dem Blitter zeichnet und animiert. Im vierten 
Artikel haben wir gesehen, wie man den Sinus-Scroll mit einigen kostenlosen
Zykluseffekten des Coppers verschönert.
In diesem fünften und letzten Artikel werden wir den Code optimieren, um sicher
zu sein, dass er in den frame passt, und um uns vor der Versuchung des Meeres
zu schützen, den Text zu ändern. Abschließend werden wir sehen, ob aus diesem
Eintauchen in die Assemblerprogrammierung der Amiga-Hardware nicht einige
Lehren gezogen werden können.
Klicken Sie hier, um das Archiv mit dem Code und den Daten des hier gezeigten
Programms herunterzuladen - es ist das gleiche wie in den anderen Artikeln.
NB: Dieser Artikel liest sich am besten, wenn man sich das ausgezeichnete Modul
anhört, das Nuke / Anarchy für den Zeitschriftenteil von Stolen Data #7 
komponiert hat, aber es ist eine Frage des persönlichen Geschmacks ...

Update 12.07.2017: Verbesserte Leistung nach der Entfernung der
BLTPRI-Positionierung in DMACON.
Update vom 27.10.2018: Nach der "Entdeckung" einer vergessenen Option in WinUAE
wurde ein Abschnitt hinzugefügt, der optimierte Versionen der Sinus Scroller mit
dem Stern vorstellt.
Klicken Sie hier, um diesen Artikel auf Englisch zu lesen.

VORBERECHNEN, UM IN DEN FRAME ZU PASSEN

Unser Sinus Scroller ist pixelbasiert, was besser ist als die der im ersten
Artikel erwähnten Falon-Gruppe, aber wir dürfen nicht vergessen, dass wir sie
auf Amiga 1200 und nicht auf Amiga 500, also auf einem viel schnelleren
Computer betreiben! Um zu wissen, ob unser Code gut funktioniert, müssen wir
ihn auf einem Amiga 500 testen.
Dazu legen wir die ausführbare Datei auf eine Diskette und booten von dieser
im Rahmen einer Amiga 500-Emulation.
Verwenden Sie in ASM-One die Inline-Befehle A (Assemble) zum Assemblieren,
dann WO (Write Object), um eine ausführbare Datei zu generieren und in SOURCES
zu speichern: als sinescroll.exe. Gehen wir also zur Workbench. Doppelklicken
Sie auf das DH0 Laufwerk - Symbol, dann auf das System - Ordner - Symbol und
schließlich auf das Shell - Symbol.
Drücken Sie F12, um auf die Konfiguration von WinUAE zuzugreifen. Klicken Sie
im Abschnitt Hardware auf Diskettenlaufwerke. Klicken wir auf Standarddiskette
erstellen, um eine im ADF-Format formatierte Diskette zu erstellen. Als
nächstes klicken wir auf ... rechts neben dem DF0- Laufwerk: und wählen diese
Datei aus, um das Einlegen der Diskette in das Laufwerk zu simulieren.
Abschließend klicken wir auf OK, um zur Workbench zurückzukehren.
Lassen Sie uns in der Shell diese Reihe von Befehlen ausführen, um die
Ausführung von sinescroll.exe zu befehlen, wenn wir von der Diskette booten:

install df0:
copy sources:sinescroll.exe df0:
makedir df0:s
echo "sinescroll.exe" > df0:s/Startup-Sequence

Das am Anfang dieses Artikels erwähnte Archiv enthält die ADF-Datei, die der
so vorbereiteten Diskette entspricht.
Lassen Sie uns also eine Amiga 500-Emulation erstellen - wir brauchen
Kickstart 1.3. Legen Sie anschließend die Diskette in das Laufwerk DF0: ein
und starten Sie die Simulation durch Klicken auf Reset. Der Sinus-Scroll
startet automatisch.
Das Ergebnis ist nur ein Spinnen im Schuss - um nicht gemein zu sein und zu
sagen: nicht im Schuss. Ist es schwierig zu behaupten, unter diesen
Bedingungen eine Sinus Scroller herzustellen, die so hoch ist wie die von Falon?
Bah!, wir könnten einen Trick gebrauchen. Ohne es hier zu dokumentieren, würde
er darin bestehen, die Zeilen kostengünstig zu verdoppeln und den Copper
aufzufordern, die Modulos in jeder Zeile zu ändern, um die oberste Zeile in
jeder zweiten Zeile zu wiederholen. Das Ergebnis würde an Finesse verlieren,
aber es könnte jeden täuschen.
Es bliebe immer, den Code so zu optimieren, dass er in den Rahmen passt.
Letzteres wurde geschrieben, ohne über die Leistung nachzudenken, wir sollten
uns nicht zu sehr den Kopf zerbrechen, um die Mittel zu finden, um eine 
schöne Zeitersparnis zu erzielen.
Zu diesem Zweck sollte man sich zunächst nicht nur auf das Benutzerhandbuch
für M68000 8- / 16- / 32-Bit-Mikroprozessoren beziehen, das die Anzahl der
Taktzyklen eines Befehls je nach verwendeter Variante angibt, sondern auch auf
das Amiga-Hardware-Referenzhandbuch, das erklärt, wie sich die CPU und die
verschiedenen Coprozessoren mit DMA-Zugriff die Speicherzugriffszyklen während
des Zeichnens teilen - die schöne Abbildung 6-9 im Handbuch.
Es wäre dann notwendig, an dem Algorithmus zu arbeiten, um zu einem effizienten
Code im Hinblick auf die eben erwähnten Zyklenverbräuche zu gelangen. Wie immer
sollte der erste Instinkt sein, zu versuchen, alles, was vorberechnet werden
kann, aus der Hauptschleife herauszuholen, solange der Speicher zum
Speichern der Vorberechnungen verfügbar ist.
Beispielsweise ist es möglich, die Ordinate jeder Spalte für alle Winkelwerte
zwischen 0 und 359 Grad im Voraus zu berechnen. Wenn eine Spalte angezeigt
wird, ist der Code, der bei jeder Iteration der Hauptschleife ausgeführt wird,
also nicht mehr ...:
	
	lea sinus,a6
	move.w (a6,d0.w),d1
	muls #(SCROLL_AMPLITUDE>>1),d1
	swap d1
	rol.l #2,d1
	add.w #SCROLL_Y+(SCROLL_AMPLITUDE>>1),d1
	move.w d1,d2
	lsl.w #5,d1
	lsl.w #3,d2
	add.w d2,d1
	add.w d6,d1
	lea (a2,d1.w),a4

...aber dieses:

	move.w (a2,d0.w),d4
	add.w d2,d4
	lea (a0,d4.w),a4

Oder es ist möglich, den Text vor der Schleife zu analysieren, um eine Liste
der Spalten zu erstellen, denen dieser Text entspricht. Diesmal werden ungefähr
zwanzig Zeilen, die bei jeder Iteration der Hauptschleife ausgeführt werden,
plötzlich durch die folgenden ersetzt:
	
	cmp.l a1,a3
	bne _nextColumnNoLoop
	movea.l textColumns,a1
_nextColumnNoLoop:

Nach Erschöpfung der Vorberechnungen ist es möglich, in den Code einzugreifen.
Um beispielsweise den Doppelblitter-Wartetest zu unterdrücken ...:

_waitBlitter0\@
	btst #14,DMACONR(a5)
	bne _waitBlitter0\@
_waitBlitter1\@
	btst #14,DMACONR(a5)
	bne _waitBlitter1\@

...wie das:

_waitBlitter0\@
	btst #14,DMACONR(a5)
	bne _waitBlitter0\@

Oder, um $0B4A im Voraus im Datenregister der CPU (hier D3) zu speichern, das
verwendet wird, um BLTCON0 zu liefern, wenn eine Spalte mit dem Blitter
gezeichnet wird ...:
	
	move.w d3,d7
	ror.w #4,d7
	or.w #$0B4A,d7
	move.w d2,BLTCON0(a5)

... was gibt (um zum nächsten Pixel zu gehen, addiere $1000 zu D3 und nicht
mehr 1, und teste das C-Flag des CPU-internen Zustandsregisters von BCC, um
ein Überschwingen des 16. Pixels zu erkennen, was zu einem D3 führt auf den
gewünschten Wert $0B4A zurücksetzen, der daher sinnlos ist zu fragen!):

	move.w d3,BLTCON0(a5)

Die Quelle dieser optimierten Version ist die Datei sinescroll_final.s, die
sich in dem am Anfang dieses Artikels erwähnten Archiv befindet.
Als Bonus enthält diese Quelle einen Code, der die Anzahl der Zeilen bestimmt,
die der Elektronenstrahl zwischen dem Beginn und dem Ende der Berechnungen
eines Frames durchläuft. Dieser Code zeigt diese Zahl dezimal oben links an
- in PAL, also bei 50 Hz, durchläuft der Elektronenstrahl 313 Zeilen. Um diese
Zeit der Berechnungen zu visualisieren, hat sich die Farbe 0 zu Beginn dieses
Zeitraums auf rot und am Ende auf grün geändert.
So kann man sehen, dass es beim Amiga 500 138 Zeilen braucht, um die Sinus
Scroller im frame (links) anzuzeigen, während es beim Amiga 1200 (rechts) nur
54 Zeilen braucht:

Bild: Zeit pro Frame, die von der optimierten Version auf dem Amiga 500 
      benötigt wird
Bild: Zeit pro Frame der optimierten Version auf dem Amiga 1200

Der durch diese Optimierung erzeugte Gewinn ist signifikant, aber zweifellos
begrenzter, auf dem Amiga 1200, wo die Anzahl der Zeilen von 62 auf 54 geht,
dh ein Gewinn von 13% - zur Information, die Anzahl der Zeilen einer Version,
bei der die Spalten auf die CPU und nicht auf den Blitter zurückgeführt werden,
geht nach der Optimierung von 183 auf 127 Zeilen, das heißt ein Gewinn von 31%!
Jede Sparsamkeit ist immer gut, aber es sollte nicht vergessen werden, dass
eine Vorberechnung immer den Speicher immobilisiert und eine Wartezeit für den
Benutzer erzeugt, wenn das Ergebnis dieser Vorberechnung nicht in Form von
verknüpften Daten gespeichert wurde. In diesem Fall führt die Vorberechnung der
Spalten der Gesamtheit des Textes zur Immobilisierung von 32 Bytes pro Zeichen
oder 34.656 Bytes für die 1.083 Zeichen unseres Textes. Okay, das ist noch 
vernünftig.
Somit passte der Sinus Scroller beim Amiga 500 nicht in den frame. Jetzt ist
mehr als genug Zeit, um sie zu verschönern! Lassen Sie uns es nicht 
vorenthalten, und ohne den Code, den dies bedeutet, detailliert zu beschreiben
- der Quellcode entspricht der Datei sinescroll_star.s, die sich in dem am 
Anfang dieses Artikels erwähnten Archiv befindet - fügen wir schließlich einen
Vektorstern hinzu der im Hintergrund rotiert, mit Schattenwurf und Spiegelung
im Spiegel wie der Sinus Scroller, diese Effekte kosten nichts mehr:
Mit Vektoranimation ist es besser ...
Um das Ganze darzustellen, braucht es 219 Zeilen beim Amiga 500 und 103 beim
Amiga 1200, ohne jegliche Optimierung - insbesondere ist die Füllung nicht auf
die vom Stern eingenommene Fläche beschränkt, was beim Amiga 500 viel Zeit
verschwendet. Wir könnten die Höhe des Sinus Scrollers leicht erhöhen, indem 
wir Linien mit einem Spiel auf dem Modulo in Copper wiederholen, ein 
Sternenfeld basierend auf wiederholten Hardware-Sprites in Copper hinzufügen,
den Effekt mit einem schönen Monty- Modul verschönern usw.
Aber das ist eine andere Geschichte...

SCHÜTZE DICH VOR DEN LAMERS

Ein Lamer könnte unseren schönen Sinus Scroller zerreißen! Insbesondere könnte
er einen Hex-Editor verwenden, um den Lauftext zu ändern. Um uns vor diesem 
Meer zu schützen, nehmen wir einen Basisschutz an, für den er den Preis zahlen
wird, wenn er es angreift.
Damit der Text nicht sichtbar ist, müssen wir ihn codieren. Lassen Sie uns
einfach die Bytes seiner Zeichen durch XOR mit TEXT_XOR kombinieren, einem Byte
mit einem beliebigen Wert. Daher erscheinen die Zeichen nicht als Zeichen in
einem Hex-Editor.
Und wenn der Lamer trotzdem die Operation erkennen sollte - was wir ihm bewusst
ermöglichen, indem wir den codierten Text einem Angriff auf der Grundlage einer
Wiederholungsanalyse aussetzen -, berechnen wir TEXT_CHECKSUM, eine Prüfsumme
des codierten Textes, und fügen ihn hier hinzu und dort wird ein Code 
aufgerufen, der bestätigt, dass der Text nicht manipuliert wurde. Dieser Code
berechnet die Prüfsumme des aktuellen Textes und ersetzt sie durch "Du bist ein
LAMER!" (von TEXT_CHECKSUM_LAMER Prüfsumme) wenn diese Prüfsumme keiner der
Prüfsummen unserer beiden Originaltexte entspricht:

Bild: Die Bestrafung des Lamers, der den Text der Sinus Scroller verändern würde

Lassen Sie uns diesen Code nicht faktorisieren, sondern wiederholen, um ihn an
verschiedenen Stellen laufen zu lassen, damit der Lamer ihn nicht loswerden
kann, indem er einfach einen RTS für die erste Anweisung dessen, was sonst sein
einziges Vorkommen wäre, ersetzt.

Seien Sie vorsichtig mit dem Kontext, in dem das Makro verwendet wird, da
es die Länge des Anfangstextes ändern kann (der mindestens so lang sein
muss wie "Du bist ein LAMER!" unter Androhung des Überschreibens von Daten)
und so den Code verwirren was war es, es zu durchsuchen?

; Control the integrity of the text to diplay. Watch for the context in which
; the macro is used, because the macro may modified the length of the initial
; text (which must be at least as long as "You are a LAMER!", or data wil be
; overwritten) and make the code that was using it go berzerk

CHECKTEXT:	MACRO
	movem.l d0-d1/a0-a1,-(sp)
	lea text,a0
	clr.l d0
	clr.l d1
_checkTextLoop\@
	move.b (a0)+,d0
	add.l d0,d1
	eor.b #TEXT_XOR,d0
	bne _checkTextLoop\@
	cmp.l textChecksum,d1
	beq _checkTextOK\@
	move.l #TEXT_CHECKSUM_LAMER,textChecksum
	lea text,a0
	lea textLamer,a1
_checkTextLamerLoop\@
	move.b (a1)+,d0
	move.b d0,(a0)+
	eor.b #TEXT_XOR,d0
	bne _checkTextLamerLoop\@
_checkTextOK\@
	movem.l (sp)+,d0-d1/a0-a1
	ENDM

Sehr Osterei. Wir sind jung, wir lachen.

EIN PAAR WORTE ZUM SCHLUSS

Die Codierung in 68000 Assembler ist eine anspruchsvolle Arbeit. Die große
Anzahl verfügbarer Register und das ständige Bemühen, ihre Verwendung zu
optimieren, führt dazu, dass der Codierer die Verwendung, die er beim Schreiben
des Codes verwendet, in seinem eigenen Speicher stapelt und entstapelt. Meiner
Erinnerung nach ist derjenige, der in 80x86-Assembler kodiert, mit dieser
Anforderung weniger konfrontiert, da die Anzahl der Register so gering und ihre
Verwendung so eingeschränkt ist, dass man sich ständig auf den Stack der CPU
verlassen muss, von dem er ist. Der Inhalt ist leichter zu merken als der von
13 Registern.
Ich hatte nicht die Idee, wieder auf Amiga zu codieren, als ich den Code für
ein Cracktro in der vorherigen Artikelserie noch einmal aufgreifen wollte. Beim
erneuten Lesen des Amiga-Hardware-Referenzhandbuchs fiel mir ein, dass ich nie
sehr weit gegangen war, um die Art und Weise zu studieren, wie der Blitter
Linien zeichnet, eine Funktion, von der ich wusste, dass sie insbesondere zur
Herstellung einer Sinus Scroller verwendet wird. Zum Schluss wollte ich noch etwas
klarstellen und habe diesen Effekt von Grund auf neu programmiert.

Ganz allgemein konnte ich beim Durchblättern dieses Handbuchs, aber auch des
68000 erkennen, wie sehr ich bei einer sehr oberflächlichen Vorstellung von
der damaligen Funktionsweise der Hardware und der CPU geblieben war. Wenn ich
also eine Lektion zu sagen habe, ist es, dass man sich jedes Mal, wenn man sich
für eine Technologie interessiert, die Mühe machen muss, alle ihre
Referenzdokumente gewissenhaft zu lesen, anstatt sich beispielsweise mit
Intuition zufrieden zu geben.
Denn mit diesem Regime gehen wir nicht nur das Risiko ein, wichtige Funktionen
zu verpassen, sondern auch das Risiko, einige davon falsch zu verstehen.
 
 Beispielsweise:
	btst #14,$dff002

Zuerst testet dieser Befehl Bit 14 des Wortes, das sich an der Adresse $DFF002
befindet. Tatsächlich zeigt das Lesen der Beschreibung von BTST im
Benutzerhandbuch für das Programmiergerät der M68000-Familie, dass, wenn der
erste Operand N ist und der zweite eine Adresse ist, es Bit N% 8 (dh: N Modulo 8)
des Bytes ist, das sich an der Adresse befindet das wird getestet. In diesem Fall
wird also Bit 14% 8 = 6 des Bytes an Adresse $DFF002 getestet. Dies entspricht
gut Bit 14 des höchstwertigen Bytes des an dieser Adresse gefundenen Wortes,
damit unsere Intuition relevant ist. Es ist jedoch Glück. Diese Annahme
bestimmter Operationen kann zu Fehlern führen, die umso schwieriger zu
korrigieren sind, als wir noch lange nicht ahnen, wo sie liegen.
Die Lektüre der Referenzdokumentation ist daher immer eine nur schwer zu
umgehende Voraussetzung für diejenigen, die eine Technologie wirklich
beherrschen wollen. Und ich meine das Referenzmaterial im Text und nicht eine
seiner populären Formen. Dies liegt daran, dass Popularisierung unter dem
Vorwand, Wissen zugänglich zu machen, zu oft Freiheiten mit sich bringt,
Abkürzungen nimmt und Sackgassen macht, die nur Talente in die Irre führen und
Mittelmäßigkeit fördern. Eine popularisierte Form von Referenzmaterial sollte
nie mehr als ein Einstiegspunkt dazu sein. Es kann nicht darauf verzichten, es
zumindest zu versuchen, es zu lesen, auch wenn sich dieses Unterfangen als
mühsam erweisen mag. VS'Amiga-Hardware-Referenzhandbuch!

Das wird alles für diese Zeit sein, und wahrscheinlich für immer, was die
Amiga-Assembler-Programmierung betrifft - der ich mich seit fast einem
Vierteljahrhundert nicht mehr gewidmet hatte. Ich widme dieses Werk einem alten
Freund, Stormtrooper, ohne dessen Motivation ich mich damals nie auf das
Metal-Bashing eingelassen hätte, und all denen, deren Spitznamen in den
unvermeidlichen Grüßen paradieren, die die Mutigen, die lesen können, werden
die Quelle dieser Sinus Scroller zusammenbauen. "Amiga regiert!"

"ZYKLUSGENAU" OPTIMIEREN

Anlässlich der Produktion eines Craktros ist mir kürzlich aufgefallen, dass ich
vergessen hatte, eine Option von WinUAE zu aktivieren, die eine exakte
Emulation der Hardware ermöglicht. Dies ist die zyklusgenaue (vollständige)
Option, die die zyklusgenaue (DMA / Speicherzugriff) Option aktiviert:

Bild: "Zyklusgenau", die kleine Option, die Sie verlieren wird ...

Die Aktivierung dieser Optionen ist unabdingbar, um für alle Amiga
originalgetreu programmieren zu können. Andernfalls hat die emulierte CPU viel
mehr Zyklen als sie tatsächlich hat, da Zyklen nicht vom DMA gestohlen werden.
Mit anderen Worten, das in WinUAE beobachtete Ergebnis ist wahrscheinlich viel
schneller als auf einem echten Amiga.
Das habe ich bei der Sinus Scroller gesehen, zum Glück nur, wenn der Stern
hinzugefügt wird. Auf Amiga 1200 habe ich dieses Problem wie folgt behoben:
 - durch Begrenzen der mit dem Blitter gefüllten Zone in der Bitebene des
   Sterns auf das diesen umschließende Rechteck;
 - durch Begrenzen der gelöschten Zone in der Bitebene des Sinus-Scrolls auf
   das von letzterem belegte Band und durch Löschen derselben aus der CPU,
   während der Blitter die Bitebene des Sterns füllt;
 - durch Begrenzen des gelöschten Bereichs in der Bitebene des Sterns auf das
   ihn umgebende Rechteck und auch durch Löschen aus der CPU, während der
   Blitter noch die Bitebene des Sterns füllt.

Klicken Sie hier, um die Quelle abzurufen. Die Zeit, die eine Iteration der
Hauptschleife benötigt, wird dann auf 240 Zeilen geschätzt, was genügend Raum
lässt, um Musik hinzuzufügen.
Auf dem Amiga 500 lässt diese Optimierung durch Parallelisierung immer noch
nicht zu, dass sie in den frame passt. Die einzige Lösung besteht daher darin,
die Bilder des Sterns vorab zu berechnen und das aktuelle Bild mit dem Blitter
in die Bitebene des Sterns zu kopieren. Da letzteres ein periodisches Muster
ist, ist es möglich, mit einer Vorberechnung von 360/5 = 72 Bildern zufrieden
zu sein. Diese Zahl ist durch die Rotationsgeschwindigkeit des Bildes zu
dividieren, unter der Bedingung, dass 72 ein Vielfaches ist.
Klicken Sie hier, um die Quelle abzurufen. Die Zeit, die eine Iteration der
Hauptschleife benötigt, wird dann mit 242 Zeilen bewertet - was auch die
Wirkung der Begrenzung des durch den Blitter gelöschten Bereichs in der
Bitebene der Sinus Scroller auf das von letzterem belegte Band beinhaltet -, was
genug Raum übrig lässt, um Musik hinzuzufügen. Offensichtlich läuft diese
Version noch schneller als die vorherige auf dem Amiga 1200, da die Zeit für
eine Iteration der Hauptschleife dann auf 183 Zeilen reduziert wird:

Bild: Zeit pro Frame der auf Amiga 500 optimierten Star-Version
Bild: Zeit pro Frame der auf Amiga 1200 optimierten Star-Version

Die "Entdeckung" der Option hat zur Folge, dass die oben im Artikel angegebenen
Zeiten daher falsch sind. Der Sinus-Scroll hält beim Amiga 500 und Amiga 1200
gut im Rahmen, aber eine Iteration der Hauptschleife dauert deutlich länger als
angegeben, nämlich 183 Zeilen beim Amiga 500 und 136 Zeilen beim Amiga 1200:

Bild: Zeit pro Frame, die von der optimierten Version auf dem Amiga 500 tatsächlich
benötigt wird
Bild: Zeit pro Frame, die von der optimierten Version auf dem Amiga 1200 tatsächlich
benötigt wird

Somit ist alles wieder in Ordnung!