
ASSEMBLERKURS - LEKTION 19: WinUAE Debugger

Autor: Göran Strack

Diese Lektion ist entstanden, weil ich selbst auf der Suche nach einer guten
Anleitung bzw. einem Tutorial war und dabei nicht richtig fündig wurde. Am
Anfang wollte ich für alle einzelnen Befehle Anwendungsmöglichkeiten finden um
ihre grundsätzliche Funktion zu verstehen. Im weiteren Verlauf wollte ich dann
sehen wo der Debugger im praktischen Einsatz nützliche Dienste leisten kann.

Um es gleich vorneweg zu sagen, zu allen Befehlen konnte ich noch keine
sinnvollen Beispiele finden.

Diese Kommandos sind u.a.:
b - Step to previous state capture position
I <custom event>      Send custom event string
f <addr1> <addr2>     Step forward until <addr1> <= PC <= <addr2>.
fo <num> <reg> <oper> <val> [<mask> <val2>] Conditional register breakpoint.
   reg=Dx,Ax,PC,USP,ISP,VBR,SR. oper:!=,==,<,>,>=,<=,-,!- (-=val to val2 range).

Und daher wird diese Lektion ggf. in der Zukunft noch erweitert.

Diese Lektion ist eine Erweiterung des vorhandenen Kurses. Es wird teilweise
auf vorhandene Programmlistings zurückgegriffen. 

Da dieser Assemblerkurs den ASMOne verwendet, sind auch die Beispiele in dieser
Lektion mit diesem Tool (Programmierwerkzeug) erstellt wurden.

Es gibt natürlich viele Wege, sich die Beispielprogramme anzusehen und
daraus zu lernen. Nur zur Information sieht die Situation bei mir so aus.

Als Editor nutze ich Atmel Studio 7. Es hat den Vorteil, dass man mehrere 
Dateien parallel öffnen kann. Weiterhin bietet dieses Programm am rechten Rand
eine Laufleiste zum Suchen. Dies ist zum Beispiel praktisch um beispielsweise
nach dem Eingabeprompt ">" zu suchen.  Damit findet man beim Durchscrollen der
Listings schnell alle eingegeben Befehle. (Diese werden im Atmel Studio orange
unterlegt.) Als Datei wähle ich File/New File/Assembly File. Dadurch werden
Codezeilen schwarz und Kommentare grün dargestellt. 

Als Emulation habe ich in WinUAE eine Amiga 500 bzw. A1200-Konfiguration mit
einer hinzugefügten Harddisk (dh1) in der in einem Verzeichnis die Sourcecodes
liegen. Im weiteren Verlauf habe ich einen savestate z.B. "asm-kurs" angelegt
mit dem ich bei einem Absturz (Guru, etc.) schnell wieder zurückspringen kann.
(Savestate speichern unter: WinUAE/Miscellaneous/Save state)

D.h. Die Bearbeitung der Sourccodes erfolgt im Editor. Anschließend wird zur
Emulation gewechselt und getestet.

Der vorhandene Debugger, Monitor (Editor, Assembler) des ASMOne bietet bereits
gute Dienste. Nur zur Erinnerung:

	ASMOne commands
	---------------

	>v 		Listet directory auf
	>v/		geht eine directory Ebene zurück
	>v 01	wechselt in das entsprechende Verzeichnis 01
	>!		Ausrufezeichen, beendet asmone (Exit)
			mit R anschließend Neustart asmone im selben Verzeichnis möglich
			mit Y - Ende
			mit N - Abbruch
	>=C 006	liefert Informationen zu den Custom Chip-Register
	>?		Umwandlung/ Berechnung zwischen dezimal, binär, hexadezimal, 				
	
	Register anzeigen
	>?SR	Statusregister	
	>?PC	Programm counter
	>?D5 	D5	Register
	>?A2	A2	Register

	mit		
	ESC-Taste		in den Editor wechseln
	ESC-Taste		zurück in die Kommandozeile	
	Strg + Esc		erzeugt halbe Seite Editor und Kommandozeile
					mit Ctrl und Esc (Amiga) bzw.
	Multitasking:
	asmone-Fenster mit der Maus nach unten verschieben - Workbench wird
	sichtbar	
	

	read, assemble, write and start
	-------------------------------

	>r		
	Filename>	prg_name.s	.s bzw. .asm-Datei einlesen			
	>a 		für assemblieren		
	>ao		assemble optimized (Speicheroptimierung)	
	>j		für jump / startet das Programm		
	>w				
	Filenmae> 	prg_name.s	speichert Quelltext
	>wo				
	Filename> 	prg_name	erzeugt ausführbare Objektdatei		
	>wb		write binary


	Editior commands	(im Editor)
	-------------------------------

	CTRL+Shift+s	- search text
	CTRL+s	- search next text recurrence
	CTRL+d	- delete line
	CTRL+b	- mark text block		Amiga+b (WinUAE = Strg+b)
	>select Area 		Cursor Down			Cursor Down
	
	CTRL+c	- copy					Amiga+c (WinUAE = Strg+c)
	CTRL+x							Amiga+x (WinUAE = Strg+x)  ausschneiden	

	CTRL+i  - insert				Amiga+i (WinUAE = Strg+i)  insert
	
		
	im Quelltext springen:
	----------------------
	CTRL+t	- go on top of document
	CTRL+T	- go to the end of document	

	mit			
	>Alt Gr + Cursor Up			nach Zeile 1
	>Alt Gr + Cursor Down		nach letzter Zeile

	>Shift + Cursor Up			eine Seite nach oben
	>Shift + Cursor Down		eine Seite nach unten


	nach dem Assemblieren
	---------------------
	>=S		Symboltabelle anzeigen
	>M Adresse/Label	zeigt Bytewert an der Speicherstelle an
			mit Return werden die nächsten Bytes angezeigt
	>=ende-init	(kB-Größe - ergibt z.b. Source 1599)	
	>X		zeigt alle Register
				
	mit 
	>h.b (h.w, h.l)		
	>H.l $25B40		zeigt den Speicher longwortweise an
	>H.w $25B40		zeigt den Speicher wortweise an 
	>H.b $25B40		zeigt den Speicher byteweise an
	
	>D Anfang	Disassembler
	zeigt an:			
	links:	reale Adressen		
	mitte:	Befehle - reale Form		
	rechts:	disassemblierte Form		(Versuch des asmone)
		
	>ad		Debugger
			Cursor	Down	(step)  - Einzelschritt 
			Cursor	right	(enter) - jump through jsr	
	>K		Einzelschritt nächster Befehl
	

	Debugger
	--------

	CTRL+s	- Step n

	Breakpoints
	CTRL+B	- breakpoint Adresse		
	CTRL+b	- breakpoint mark
	CTRL+a	- add watch
	CTRL+r	- run
	CTRL+j	- jump to line
	

	diverse
	-------
		
	>i		insert code from extetrnal file
	>u		update file
	>is		create sinus (asmone 1.07+)


Auch die ActionReplay bietet umfangreiche Möglichkeiten zur Programmanalyse
usw. (Weitere Möglichkeiten bieten u.a. MonAm, maptapper, hrtmmon, resource)

Maptapper ist ein Tool mit dem Gamemaps für HOL (Hall of Light) erstellt werden
können. Es wurde 2013 von Codetapper programmiert.

Mit dem Programm ist es möglich: Sprite (4), Sprite (16), Logos, Tilemaps
als Grafik zu visualisieren, welche dann als png-Datei gespeichert werden kann.

Nach der Visualisierung der Tilemaps ist es im Weiteren möglich die Gamemaps zu
erstellen. https://codetapper.com/amiga/maptapper/

hrtmon ist z.B. unter WinUAE/ROM/Cartridge ROM file:
Freezer: HRTMon v2.37 (built-in) zu finden.

resource: http://amiga-dev.wikidot.com/tool:resource

Ich empfehle auch zwei hilfreiche Internetseiten:
https://68kcounter-web.vercel.app/
http://amigafonteditor.ozzyboshi.com/register_conversion.html

Hier soll es aber hauptsächlich um den WinUAE-Debugger gehen, da dieser immer
verfügbar ist. Trotzdem rate ich dazu alle Möglichkeiten auch in Kombination
anzuwenden. Manchmal ist schon der ASMOne Debugger sehr hilfreich.

Es gibt im Debugger den sogenannten GUI und den Console-Debugger. Der GUI wird
nicht mehr unterstützt. Von Toni wird immer erwähnt nur den Console-Debugger
zu verwenden. Wenn man sich einmal an die Arbeit mit dem Console-Debugger 
gewöhnt hat, wechselt man eigentlich auch nicht zurück in den GUI.
Trotzdem möchte ich mit dem GUI beginnen.

from EAB:
Toni says, UAE's debugger was never designed for "friendly" debugging...

WinUAE Debugger GUI
===============================================================================

Shift+F12 (oder auch Ende+F12) - öffnet den WinUAE Debugger

x	- Debugger verlassen
xx  - Switch between console and GUI debugger
q	- WinUAE komplett beenden

F1 - OUT1	- Hauptfenster (viele Informationen)
F2 - OUT2	- 
F3 - MEM1	- 1. Speicheransicht (*)
F4 - MEM2	- 2. Speicheransicht (*)
F5 - DASM1  - 1. Disassembler für Speicherbereich
F6 - DASM2	- 2. Disassembler für Speicherbereich
F7 - BRKPTS - zeigt Liste der Breakpoints
F8 - MISC	- zeigt CIA Register, Diskettenlaufwerke
F9 - CUSTOM - Custom-Chip-Registerinhalte 

* mit Feld zur Eingabe der Adresse

DASM1 /DASM2
Linien:
	Die Linien deuten auf ein Unterprogrammende hin RTS, RTE.
Pfeile:
	Die Pfeile auf der linke Seite zeigen auf die Sprungziele
	in Richtung höherer oder tieferen Adressen.
Set to PC:
	Die aktuelle Adresse wird auf den program counter gesetzt. 
Auto Set:
	
Bewegen/ Scrollen beim Speicher Anzeigen
	F11, F12 Einzelschritt durch den Programmcode

	F11 - Einzelschritt	(wie z-command)
	F12 - Einzelschritt (wie t-command)

nicht wirklich seitenweise hoch/runter aber
	Alt+Pfeil links/rechts bewegt 8 Zeilen hoch/runter
	Alt+Arrow hoch/runter bewegt 1 Zeile hoch/runter

Kommandozeile:
	alte eingegebene Befehle werden durch Cursor UP angezeigt

Farben:
	alle Änderungen werden blau markiert


HILFE FüR WinUAE Debugger (HELP for UAE Debugger) (WinUAE 4.9)
===============================================================================

mit Shift-F12 aktiviert.

Console: >
>h
          HELP for UAE Debugger
         -----------------------

  g [<address>]         Start execution at the current address or <address>.
  c                     Dump state of the CIA, disk drives and custom registers.
  r                     Dump state of the CPU.
  r <reg> <value>       Modify CPU registers (Dx,Ax,USP,ISP,VBR,...).
  rc[d]                 Show CPU instruction or data cache contents.
  m <address> [<lines>] Memory dump starting at <address>.
  a <address>           Assembler.
  d <address> [<lines>] Disassembly starting at <address>.
  t [instructions]      Step one or more instructions.
  z                     Step through one instruction - useful for JSR, DBRA etc.
  f                     Step forward until PC in RAM ("boot block finder").
  f <address>           Add/remove breakpoint.
  fa <address> [<start>] [<end>]
                        Find effective address <address>.
  fi                    Step forward until PC points to RTS, RTD or RTE.
  fi <opcode> [<w2>] [<w3>] Step forward until PC points to <opcode>.
  fp "<name>"/<addr>    Step forward until process <name> or <addr> is active.
  fl                    List breakpoints.
  fd                    Remove all breakpoints.
  fs <lines to wait> | <vpos> <hpos> Wait n scanlines/position.
  fc <CCKs to wait>     Wait n color clocks.
  fo <num> <reg> <oper> <val> [<mask> <val2>] Conditional register breakpoint.
   reg=Dx,Ax,PC,USP,ISP,VBR,SR. oper:!=,==,<,>,>=,<=,-,!- (-=val to val2 range).
  f <addr1> <addr2>     Step forward until <addr1> <= PC <= <addr2>.
  e[x]                  Dump contents of all custom registers, ea = AGA colors.
  i [<addr>]            Dump contents of interrupt and trap vectors.
  il [<mask>]           Exception breakpoint.
  o <0-2|addr> [<lines>]View memory as Copper instructions.
  od                    Enable/disable Copper vpos/hpos tracing.
  ot                    Copper single step trace.
  ob <addr>             Copper breakpoint.
  H[H] <cnt>            Show PC history (HH=full CPU info) <cnt> instructions.
  C <value>             Search for values like energy or lifes in games.
  Cl                    List currently found trainer addresses.
  D[idxzs <[max diff]>] Deep trainer. i=new value must be larger, d=smaller,
                        x = must be same, z = must be different, s = restart.
  W <addr> <values[.x] separated by space> Write into Amiga memory.
  W <addr> 'string'     Write into Amiga memory.
  Wf <addr> <endaddr> <bytes or string like above>, fill memory.
  Wc <addr> <endaddr> <destaddr>, copy memory.
  w <num> <address> <length> <R/W/I> <F/C/L/N> [<value>[.x]] (read/write/opcode)
					   (freeze/mustchange/logonly/nobreak).
                        Add/remove memory watchpoints.
  wd [<0-1>]            Enable illegal access logger. 1 = enable break.
  L <file> <addr> [<n>] Load a block of Amiga memory.
  S <file> <addr> <n>   Save a block of Amiga memory.
  s "<string>"/<values> [<addr>] [<length>]
                        Search for string/bytes.
  T or Tt               Show exec tasks and their PCs.
  Td,Tl,Tr,Tp,Ts,TS,Ti,TO,TM,Tf Show devs, libs, resources, ports, semaphores,
                        residents, interrupts, doslist, memorylist, fsres.
  b                     Step to previous state capture position.
  M<a/b/s> <val>        Enable or disable audio channels, bitplanes or sprites.
  sp <addr> [<addr2][<size>] Dump sprite information.
  di <mode> [<track>]   Break on disk access. R=DMA read,W=write,RW=both,P=PIO.
                        Also enables level 1 disk logging.
  did <log level>       Enable disk logging.
  dj [<level bitmask>]  Enable joystick/mouse input debugging.
  smc [<0-1>]           Enable self-modifying code detector. 1 = enable break.
  dm                    Dump current address space map.
  v <vpos> [<hpos>]     Show DMA data (accurate only in cycle-exact mode).
                        v [-1 to -4] = enable visual DMA debugger.
  vh [<ratio> <lines>]  "Heat map"
  I <custom event>      Send custom event string
  ?<value>              Hex ($ and 0x)/Bin (%)/Dec (!) converter and calculator.
  x                     Close debugger.
  xx                    Switch between console and GUI debugger.
  mg <address>          Memory dump starting at <address> in GUI.
  dg <address>          Disassembly starting at <address> in GUI.
  q                     Quit the emulator. You don't want to use this command.

Numbers:
are usually hexadecimal by default (a few exceptions default to decimal)
prepend a number with $ or 0x force hexadecimal
prepend a number with ! to force decimal

>  x                    Close debugger.

Das Schließen des Debuggers-Fensters mit dem Klicken auf das Kreuz oben rechts
führt auch zum Schließen von WinUAE, sowie die Tastenkombination Ctrl+C.

Es gibt ein paar undokumenteierte Befehle:	vm,vo,vh?,vhc,vhd die in den Listings
auch gezeigt werden.

Und es gibt laut EAB noch weitere Debugger Befehle zu denen ich jedoch keine
Anwendungsbeispiele gefunden habe. https://eab.abime.net/showthread.php?t=91321 

Auszug:
Other new debugger features:

- Early boot segtracker-like feature for loadable libraries and others, enable
  in misc panel.

New debugger commands:

- tr = break when PC points to any allocated debug memory
- tl = break when PC matches next source line, step to next source line.
- seg = list loaded program's segments.
- segs = list all segtracker loaded segments.
- u = inhibit current debugmem break to debugger method. (ua = inhibit all,
        uc = clear all)
- TL = scan and match library bases (exec library, device and resource lists)
        with loaded amiga.lib
       .fd symbols. Automatically done when starting debug mem debugging session.
- rs = show tracked stack frame.
- rss = show tracked supervisor stack frame.
- ts = break when tracked stack frame count decreases. (=tracked stack frame
       matched executed RTS)
- tsp = break when tracked stack frame count decreases or increases.
       (RTS/BSR/JSR).
- tse/tsd = enable/disable full stack frame tracking. Can be used when no
       debugmem debugging is active.

ts/tsp stores current supervisor mode and only breaks to debugger if stack
frame operation has same supervisor mode.

All debugger commands that take address or register value also support
symbol names. (for example "d __stext")
"library/lvo" is also resolved if library was found when scanned with TL. 
(for example "d exec/wait" disassembles Wait())

Bei erstmaligen Öffnen des Debuggers steht in der ersten Zeile 
Couldn't open 'amiga.lib' und hier ist wahrscheinlich auch die Ursache zu
suchen. Für die normale Arbeit mit dem Debugger ist die 'amiga.lib' nicht
erforderlich. amiga.lib ist Bestandteil der AmigaOS SDK (NDK). Es wird
verwendet, um LVO-Namen zu finden, wenn das geladene Programm uaedbg		
Debugging-Symbole enthält.


REFERENZKARTE ACTION REPLAY (nur zum Vergleich)
===============================================================================

Referenzkarte siehe Listing19a.s	

Die Action Replay wird über WinUAE/Hardware/ROM/Cartridge ROM files eingebunden.
Dazu muss die entsprechende Datei z.B. Action Replay Mk III v3.17 (256k) im
entsprechenden Pfad (System ROMs) liegen.

und kann dann über:
Page Up		--> aktiviert werden
Page Down	--> Liste commands
x			--> Restart Programm
F9			--> Tastatur US/German umschalten

Action Replay soll aber hier nicht das Thema sein.


AUSGABE REGISTER, SPEICHER, etc.
===============================================================================

In Listing19b1.s sehen wir Ergebnisse reiner Ausgabebefehle, wie:

  c                     Dump state of the CIA, disk drives and custom registers.
  r                     Dump state of the CPU.
  rc[d]                 Show CPU instruction or data cache contents.
  m <address> [<lines>] Memory dump starting at <address>.
  e[x]                  Dump contents of all custom registers, ea = AGA colors.
  i [<addr>]            Dump contents of interrupt and trap vectors.
  il [<mask>]           Exception breakpoint.
  dm                    Dump current address space map.
  mg <address>          Memory dump starting at <address> in GUI.
  o <0-2|addr> [<lines>]View memory as Copper instructions.
  d <address> [<lines>] Disassembly starting at <address>.
  H[H] <cnt>            Show PC history (HH=full CPU info) <cnt> instructions.
  T or Tt               Show exec tasks and their PCs.
  Td,Tl,Tr,Tp,Ts,TS,Ti,TO,TM,Tf Show devs, libs, resources, ports, semaphores,
                        residents, interrupts, doslist, memorylist, fsres.
  sp <addr> [<addr2][<size>] Dump sprite information.
 

 ÄNDERUNG REGISTER, SPEICHER, etc.
===============================================================================
 
 und im Listing19b2.s die Wirkungsweise der Schreibbefehle
 
  W <addr> <values[.x]				separated by space> Write into Amiga memory.
  W <addr> 'string'					Write into Amiga memory.
  Wf <addr> <endaddr> <bytes or string like above>, fill memory.
  Wc <addr> <endaddr> <destaddr>, copy memory.
  r <reg> <value>					Modify CPU registers (Dx,Ax,USP,ISP,VBR,...).	


 SUCHEN UND FINDEN
===============================================================================
 
 im Listing19b3.s

 s "<string>"/<values> [<addr>] [<length>]
                        Search for string/bytes.
 fa <address> [<start>] [<end>]
                        Find effective address <address>.
 fi <opcode> Step forward until PC points to <opcode>. 
 fi <opcode> [<w2>] [<w3>] Step forward until PC points to <opcode>
 f                     Step forward until PC in RAM ("boot block finder").


PROGRAMM-BREAKPOINT
===============================================================================

Im Listing Listing19c1.s setzen wir einen Programmbreakpoint.
und sehen die Wirkungsweise von: 
  f <address>           Add/remove breakpoint.
  fl                    List breakpoints.
  fd                    Remove all breakpoints.
  d <address> [<lines>] Disassembly starting at <address>.
  t [instructions]      Step one or more instructions.
  fi                    Step forward until PC points to RTS, RTD or RTE.
  g [<address>]         Start execution at the current address or <address>.

Die Beschreibung für dieses Listings ist für den GUI-Debugger.

Es können mehrere Programmbreakpoints gesetzt und bei Bedarf einzeln entfernt
werden.

Ab dem nächsten Beispiel ist die Beschreibung für den Console-Debugger.
Um zum Console-Debugger zu wechseln.

 xx						Switch between console and GUI debugger.

In Listing19c2.s sehen wir die Wirkungsweise von
 z					   Step through one instruction - useful for JSR, DBRA etc.
 
In Listing19c3.s sehen wir die Wirkungsweise von 
 a <address>           Assembler.

In Listing19c4.s starten wird das Programm von der Shell und sehen eine
Anwendung für die Wirkungsweise von einen Programmbreakpoint über den Befehl:

 fp "<name>"/<addr>    Step forward until process <name> or <addr> is active.

In Listing19c5.s sehen wir wie mit dem z-command Unterprogrammaufrufe
übersprungen werden können.

 z - für JSR

In Listing19c6.s sehen wir einen Einsatz des fo-commands.

 fo <num> <reg> <oper> <val> [<mask> <val2>] Conditional register breakpoint.

Anmerkung:  Wir können auch debuggen ohne einen Breakpoint zu setzen:
 D.h. Shift+F12 ; Debugger öffnen und
>d				; d pc	Programm an aktueller Stelle disassemblieren
>g				; run - Programm fortsetzen (Debugger Fenster bleibt offen)
>x				; Programm fortsetzen - Debugger verlassen

Bei dem Wechselspiel Shift+F12 und >g und wieder Shift+F12 und >g muss mit
der Maus einmal kurz auf das WinUAE-Fenster geklickt werden, sonst wird durch
Shift+F12 der Debugger nicht gestartet und das Programm nicht unterbrochen.

 Folgendes ist auch möglich:
>d ra0+4		; "register A0 + 4"
>d pc-10		; um Bytes (Programmcode) an vorherigen Speicheradressen zu
				; disassemblieren (try and error)
Anmerkung2:
 Es ist nicht erforderlich ein Leerzeichen zwischen dem Befehl und dem Paramter
 zu setzen.

 >f2382a
Breakpoint added.
>fl
0: PC == 0002382a [00000000 00000000]

oder
>m20000 >d20000 >o1 


 MEMORY-WATCHPOINT
===============================================================================

In Listing19d1.s wird der Memory-Watchpoint erklärt.

 w <num> <address> <length> <R/W/I/F/C> [<value>[.x]] (read/write/opcode/freeze/mustchange).
                        Add/remove memory watchpoints.

In Listing19d2.s sehen wir uns die Wirkungsweise des Memory-Watchpoints 
in der Praxis an.

In Listing19d3.s	- freezing value


 LOAD AND SAVE MEMORY
===============================================================================

In Listing19e1.s wird ein Teil des Speichers als Datei gespeichert und in
Listing19e2.s wieder eingelesen.

  L <file> <addr> [<n>] Load a block of Amiga memory.
  S <file> <addr> <n>   Save a block of Amiga memory.

Leider gibt es keinen Befehl z.B. mr der einen Teil des Speichers 

  m 420
00000420 0180 005A 00E2 0000 0120 0000 0122 0C80  ...Z..... ..."..
00000430 0124 0000 0126 0478 0128 0000 012A 0478  .$...&.x.(...*.x

gleich in dc's zum Kopieren umwandelt.


 AKTIVIEREN/ DEAKTIVIEREN audio channels, bitplanes or sprites
===============================================================================

In Listing19f1.s sehen wir die Wirkungsweise von Ms <val> zum 
aktivieren und deaktivieren der Sprite-Kanäle.

   M<a/b/s> <val>        Enable or disable audio channels, bitplanes or sprites.

siehe Listing7f.s (Spritepriorität der 8 Sprites)


SPRITE-RIPPING
===============================================================================

In Listing19g1.s holen wir uns die Sprite Daten des Mauszeigers.

  sp <addr> [<addr2][<size>] Dump sprite information.


HEAT-MAP
===============================================================================

In Listing19h1.s sehen wir allgemeine Angaben über die Anwendung der "Heat-map".

  vh [<ratio> <lines>]  "Heat map"

In Listing19h2.s sehen wir in einem einfachen Beispiel die "Heat-map" in der
Praxis.


SCANLINE
===============================================================================

In Listing19i1.s sehen wir eine Anwendung des "fc-commands".

  fc <CCKs to wait>     Wait n color clocks.

In Listing19i2.s wird die Funktionsweise des "fs-commands" erklärt.

  fs <lines to wait> | <vpos> <hpos> Wait n scanlines/position.
  

TRAINER
===============================================================================

In Listing19j1.s sehen wir drei Beispiele für die Spieletrainer-Funktion.

  C <value>             Search for values like energy or lifes in games.
  Cl                    List currently found trainer addresses.


und in Listing19j2.s sehen wir ein Beispiel für die Deeptrainer-Funktion.

 D[idxzs <[max diff]>] Deep trainer. i=new value must be larger, d=smaller,
                       x = must be same, z = must be different, s = restart.


DMA-DEBUGGER
===============================================================================

In Listing19k1.s schauen wir wie der DMA-Debugger aktiviert und deaktiviert
werden kann und welche Unterschiede es hinsichtlich der verschiedenen Größen
und Transparent-Modi es beim Visual DMA-Debugger gibt.
Hier auch gleich der Hinweis: Unter WinUAE/Chipset den Haken bei 
cycle-exact setzen um DMA und CPU Speicherzugriffe zu sehen, ansonsten
werden nur die Speicherzugriffe der DMA-Kanäle angezeigt.

Weiterhin können die DMA-Kanäle separat visuell aktiviert und deaktiviert
werden und die Farben individuell eingestellt werden.

 v			= enable DMA debugger.
 v [-1]		= enable DMA debugger.
 v [-2 to -6] = enable visual DMA debugger.
 vo			= DMA debugger off
 vm = show status 
 vm <channel> <sub index>
			= enable/disable toggle.
			   (sub index is not used but must be included)
 vm <channel> <sub index> <hex rgb>
			= change color of channel.
			  If sub index is zero: all sub index colors are changed.

In Listing19k2.s untersuchen wir die obere Zeile wo wir den Mauspfeil platzieren.

 v <vpos>			; mousepointer is in the upper-left corner on screen
 v <vpos> [<hpos>]  ; mousepointer is not in the upper-left corner on screen

In Listing19k3.s wird gezeigt, wie es möglich ist sich die Speicherzugriffe 
von DMA und CPU anzusehen. (Nur wenn cycle-exact-mode aktiviert ist !!!)

In Listing19k4.s wird ein Beispiel für einen Blitter-Cycle Sequenz gezeigt.

In Listing19k5.s werden die Markierungen bezüglich Bitplane, Datafetch usw.
gezeigt.


COPPER DEBUGGER
===============================================================================
 
 In Listing19l1.s sehen wir wie wir den Speicher als Copper-Anweisungen anzeigen
 können und die Wirkungsweise des Copper Debuggers.  
 
  o <0-2|addr> [<lines>]View memory as Copper instructions.
  od                    Enable/disable Copper vpos/hpos tracing.
  
In Listing19l2.s untersuchen wir parallel Copper-Debugger und DMA-Debugger.

In Listing19l3.s sehen wir die Wirkungsweise des Copper tracings

  ot                    Copper single step trace.
  ob <addr>             Copper breakpoint.
    
In Listing19l4.s sehen wir ein Beispiel für Copper tracing und DMA-Debugger.


PC HISTORY
===============================================================================

In Listing19m1.s sehen wir eine Anwendung der History Ausgabe.

 H[H] <cnt>            Show PC history (HH=full CPU info) <cnt> instructions.


 SELF MODIFYING CODE - SMC 
===============================================================================

In Listing19n1.s sehen wir eine Anwendung für den smc-command.

 smc [<0-1>]           Enable self-modifying code detector. 1 = enable break.


JOYSTICK/MOUSE INPUT DEBUGGING
===============================================================================

In Listing19o1.s sehen wir eine Anwendung des input debuggers.

 dj [<level bitmask>] Enable joystick/mouse input debugging. 


EXCEPTION
===============================================================================

In Listing19p1.s sehen wir eine Anwendung für den il-command.
Exception breakpoint.

il [<mask>]           Exception breakpoint.


ILLEGAL MEMORY ACCESS
===============================================================================

In Listing19q1.s sehen wir eine Anwendung für den wd-command.

wd [<0-1>]            Enable illegal access logger. 1 = enable break.


DISK LOGGING
===============================================================================

In Listing19r1.s sehen wir eine Anwendung für den di/did-command.

di <mode> [<track>]   Break on disk access. R=DMA read,W=write,RW=both,P=PIO.
                      Also enables level 1 disk logging.
did <log level>       Enable disk logging.


ANWENDUNG/ LOGO RIPPING
===============================================================================

In Listing19s1.s wird gezeigt wie das Logo "Diskette Workbench 1.3" gerippt
werden kann.

Wer will kann sich den Reset Vorgang in Einzelschritten in Listing19s2.s
ansehen.


Nutzen Sie die Möglichkeiten...
