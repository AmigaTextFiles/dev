
; Listing20a.s		Booten von Disketten
		; in dem wir unser ausführbares Programm / Demo auf Diskette speichern

;------------------------------------------------------------------------------
1. ausführbares Programm erstellen

z.B.

>r
Filename:Listing10x.s
>a
Pass1
Pass2
No Errors
>wo
FILENAME>Demo.exe			; oder nur Demo (ohne .exe)
Sorting relo-area..
Writing hunk length..
Write hunk data..
File length =	5960 (=$00001748)
>
		
;------------------------------------------------------------------------------
2. leere Diskette erstellen

Diskette erstellen unter:
WinUAE: F12
WinUAE/Floppy drives/new floppy disk image/ create standard disk
Disk label: demo
kein Haken bei Bootblock,
kein Haken bei FFS

Diskette speichern/ Dateiname: Demo
Diskette unter Floppy drives/ DF0: einlegen

;------------------------------------------------------------------------------
3. auszuführendes Programm in die Datei startup-sequence schreiben

Die Datei startup-sequence wird mit dem Editor ed erzeugt und bekommt als Inhalt
nur den Namen der Datei die ausgeführt (gestartet) werden soll. hier: Demo.exe

von der Workbench den Editor "Ed 1.14" öffnen und Demo.exe (+ Enter) schreiben:

Amiga Shell öffnen
>ed	startup-sequence		; leere Textdatei anlegen mit Namen startup-sequence

ed Bedienung
ESC+q+Enter --> ohne speichern verlassen
ESC+x+Enter --> mit speichern verlassen
ESC+d+Enter --> eine Zeile löschen

;------------------------------------------------------------------------------
4. Diskette zur startfähigen Diskette machen

Amiga Shell öffnen
SYS:> install df0:							; macht eine formatierte Diskette
											; zur startfähigen Diskette
SYS:> copy dh1:Demo.exe to df0:				; natürlich euren Pfad wählen...
SYS:> makedir df0:s
SYS:> copy dh1:startup-sequence to df0:s

;------------------------------------------------------------------------------
5. im Zweifelsfall nochmal auf dem Datenträger nachschauen

SYS:>cd df0:
1.Demo:>
		 s (dir)
	Demo.exe
1.Demo:>cd s
1.Demo:s>dir
1.Demo:s>startup-sequence
1.Demo:s>ed startup-sequence

Ed 1.14
Demo.exe

alles richtig gemacht...

