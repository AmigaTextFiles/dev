
; Listing11o1.s		Laden einer Datendatei mit der dos.library

	Section DosLoad,code

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

Maincode:
	movem.l	d0-d7/a0-a6,-(SP)	; speichern der Register auf dem stack
	move.l	4.w,a6				; ExecBase in a6
	LEA	DosName(PC),A1			; Dos.library
	JSR	-$198(A6)				; OldOpenlib
	MOVE.L	D0,DosBase
	BEQ.s	EXIT				; Wenn Null, raus! Fehler!

Mouse:
	btst.b	#6,$bfe001			; ciaapra - linke Maustaste
	bne.s	Mouse

	bsr.s	CaricaFile			; Laden einer Datei mit der dos.library

	MOVE.L	DosBase(PC),A1		; DosBase in A1 um die Bibliothek zu schließen
	move.l	4.w,a6				; ExecBase in A6
	jsr	-$19E(a6)				; CloseLibrary - dos.library schließen
EXIT:
	movem.l	(SP)+,d0-d7/a0-a6	; wiederherstellen der Register vom stack
	RTS							; zu ASMONE oder Dos/WorkBench zurückkehren


DosName:
	dc.b	"dos.library",0
	even

DosBase:						; Zeiger auf die Basis der Dos Library
	dc.l	0

*****************************************************************************
; Routine, die eine Datei einer bestimmten Länge mit einem angegeben
; Namen lädt. Sie müssen den gesamten Pfad angeben, falls er existiert!
*****************************************************************************

CaricaFile:
	move.l	#filename,d1		; Adresse mit String "Dateiname + Pfad"
	MOVE.L	#$3ED,D2			; AccessMode: MODE_OLDFILE - Datei, die 
								; schon existiert, damit wir lesen können.
	MOVE.L	DosBase(PC),A6
	JSR	-$1E(A6)				; LVOOpen - "Öffnen" der Datei
	MOVE.L	D0,FileHandle		; Speichern des handle
	BEQ.S	ErrorOpen			; Wenn d0 = 0 ist, liegt ein Fehler vor!

	MOVE.L	D0,D1				; FileHandle in d1 für das Lesen
	MOVE.L	#buffer,D2			; Ziel-Adresse in d2
	MOVE.L	#42240,D3			; Dateilänge (GENAU!)
	MOVE.L	DosBase(PC),A6
	JSR	-$2A(A6)				; LVORead - Lesen der Datei und kopieren in den Puffer

	MOVE.L	FileHandle(pc),D1	; FileHandle in d1
	MOVE.L	DosBase(PC),A6
	JSR	-$24(A6)				; LVOClose - schließe die Datei.
ErrorOpen:
	rts


FileHandle:
	dc.l	0

; Textzeichenfolge, endet mit einer 0, auf die d1 vorher zeigen muss
; zum ÖFFNEN der dos.lib. Es ist besser, den gesamten Pfad zu setzen.

Filename:
	dc.b	"/Sources/amiet.raw",0	; Pfad und Dateiname
	even

******************************************************************************
; Puffer, in dem das Image über doslib von der Diskette (oder Festplatte) geladen wird
******************************************************************************

	section	mioplanaccio,bss

buffer:
LOGO:
	ds.b	6*40*176			; 6 bitplanes * 176 lines * 40 bytes (HAM)

	end


Anmerkung vom Übersetzer:
	>a							; vor Ausführung 
	>h.b Logo					; - alle Daten sind $00
	>m Logo+$890				; - alle Daten sind $00	
	    
	>j							; nach Ausführung
	>h.b Logo					; - keine Daten eingelesen?	doch, teste: 
	>m Logo+$890				; 
	Ergebnis: 7C 99 BC 6C ...	; öffne Datei AMIET.raw mit einem Hex-Viewer
	