
; Listing20b.s 		RT - Read Track von Diskette mit ASMone
;					WT - Write Track auf Diskette mit ASMone

	ORG $20000
	LOAD $20000
	JUMPPTR start

start:
	rts

	org $21000
BUF:
	dcb.l	5000,"TRK!"
		
	end
	
Das Programm ausführen und zuerst mit m BUF den Speicherbereich ansehen.
Nun Diskette einlegen (z.b. Workbench) und in ASMOne eingeben:

>RT					; RT = read track
RAM PTR>BUF			; Ziel 	
DISK PTR>0			; welchen Track einlesen? in diesem Fall Track 0
LENGTH>1			; wieviele Tracks einlesen? in diesem Fall 1 Track
>h.l buf			; Ergebnis ansehen

Von $21000 bis $22600 wurden Daten eingelesen. d.h. $1600Bytes (=5632 Bytes)
5632 Bytes/11 tracks=512 Bytes

Jede Diskette hat 80 Tracks auf beiden Seiten.	
Jeder Track hat 11 Sektoren. 80*2*11=1760 Sektoren.

Jeder Sektor hat 512Bytes.
1760 * 512Bytes= 901120Bytes
901120Bytes/1024=880kBytes


Test für WT:

WinUAE/Floppy drives
new Floppy disk image/ Create standard disk 
disk label: test

Synonym:
>WT
RAM PTR>BUF			; Ziel	
DISK PTR>0			; welchen Track speichern? in diesem Fall Track 0
LENGTH>1			; wieviele Tracks speichern? in diesem Fall 1 Track