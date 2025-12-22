
; Listing20b2.s 	RS - Read Sector von Diskette mit ASMone
;					WS - Write Sector
					; einfache bootfähige Diskette erstellen

BOOT:
	dc.l "DOS"<<8				; disk type		oder dc.b	'DOS',0		
	dc.l 0						; checksum	
	dc.l 880					; root block

START:
Waitmouse:						; diese LABEL steht als Referenzpunkt für das bne
	move.w	$dff006,$dff180		; gib den Wert von $dff006 in $dff180
								; also von VHPOSR in COLOR00
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	Waitmouse			; wenn nicht, kehre zu Waitmouse zurück
								; und wiederhole
	rts							; Ende, steig aus
								; Achtung: an dieser Stelle erfolgt kein sauberer
								; Ausstieg zurück zum Betriebssystem	

	end
	

Der Bootblock ist zwei Sektoren lang (1024 Bytes) und startet bei Sektor 0.
Der Diskettenname ist im Sektor 880 ($370).

>WS
RAM PTR>BOOT		; Ziel	
DISK PTR>0			; in welchen Sektor speichern? in diesem Fall Sektor 0
LENGTH>2			; wieviele Sektoren speichern? in diesem Fall 2 Sektoren
	
ASM-One schreibt nun den Bootblock, und Sie müssen nur noch CC verwenden, um
die Prüfsumme (Checksum) zu berechnen, und die Diskette bootet.

Diskette erstellen unter:
WinUAE/Floppy/new floppy image/ create standard disk
Disk label: bootdisk
kein Haken bei Bootblock,
kein Haken bei FFS

Diskette unter Floppy drives/ DF0: einlegen

>a
Pass1
Pass2
No Errors
>WS
RAM PTR>BOOT		; Ziel	
DISK PTR>0			; in welchen Sektor speichern? in diesem Fall Sektor 0
LENGTH>2			; wieviele Sektoren speichern? in diesem Fall 2 Sektoren
>CC					; ASMone berechnet die Checksumme und speichert sie in
					; der zweiten long-Adresse auf der Diskette
