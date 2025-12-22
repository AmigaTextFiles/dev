
; soc01.s = vertb0.s

; Programmiert von Yragael für Stash of Code
; (http://www.stashofcode.fr) im Jahr 2017.

; Diese Arbeit wird unter den Bedingungen der Creative Commons
; Namensnennung-Keine kommerzielle Nutzung-Weitergabe unter
; gleichen Bedingungen 4.0 UK-Lizenz zur Verfügung gestellt.

; Test der Umleitung von $6C, um einen Code unter Interrupt VERTB zu setzen. 
; Der Copper wartet auf die Mitte des Bildschirms und ändert COLOR00 in $0F00 (rot).
; Die CPU liest VPOSR und VHPOSR ein, um auf das obere Viertel des Bildschirms zu warten,
; speichert $00F0 (grün) in color und löst einen Interrupt der Ebene 3 aus, indem VERTB
; in INTREQ gesetzt wird. Der Interrupt-Handler ändert COLOR00 in Farbe (grün), speichert
; $000F (blau) in color und bestätigt das Ereignis durch Löschen von VERTB in INTREQ.
; Schließlich wartet die Hardware auf das Ende des Frames (überschreitet die 313. Zeile in PAL)
; und löst dann einen Interrupt der Ebene 3 aus, indem VERTB in INTREQ gesetzt wird. 
; Der Interrupt-Handler setzt $000F (blau) in COLOR00, es ist nutzlos,
; aber wir verhindern es nicht, indem wir den Handler-Code mit einem Test verkomplizieren - 
; und bestätigt das Ereignis durch Löschen von VERTB in INTREQ.

; Die Hardware setzt IMMER das Bit, das einem Ereignis in INTREQ entspricht. Es wird jedoch
; nur dann ein zugehöriger CPU-Interrupt generiert (z.B. ein Interrupt der Ebene 3 für das
; VERTB-Ereignis), wenn das entsprechende Bit in INTENA gesetzt ist. Außerdem löscht die
; Hardware NIEMALS das Bit in INTREQ: Dies ist die Aufgabe des Ereignismanagers. Wenn VERTB
; einen CPU-Interrupt verursacht, der Interrupt-Handler (Vektor 27 => Adresse $6C) das
; Ereignis jedoch nicht durch Löschen von VERTB in INTREQ bestätigt, wird dieser Handler
; permanent aufgerufen, da die Hardware den Interrupt Level 3 - Die CPU gibt die Kontrolle
; aber kaum zurück. Beachten Sie, dass es möglich ist, ein Ereignis anstelle der CPU zu
; generieren, indem das entsprechende Bit in INTREQ gesetzt wird. Ein Test zeigt, dass wenn
; VERTB während des Frames manuell positioniert wird (dh: move.w #$8020,INTREQ(a5)),
; die Hardware es dennoch weiterhin am Ende des Frames positioniert.

;---------- Direktiven ----------

	SECTION yragael,CODE_C

;---------- Konstanten ----------

; Register

VPOSR=$004
INTENA=$09A
INTENAR=$01C
INTREQ=$09C
INTREQR=$01E
DMACON=$096
DMACONR=$002
COLOR00=$180
COP1LCH=$080
COPJMP1=$088

; Programm

DISPLAY_Y=$2C
DISPLAY_DY=256
COPSIZE=2*4+4

;---------- Initialisierung ----------

; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)

; StingRay's stuff

	lea graphicsLibrary,a1
	movea.l $4,a6
	jsr -408(a6)				; OpenLibrary ()
	move.l d0,graphicsBase
	move.l graphicsBase,a6
	move.l $22(a6),view
	movea.l #0,a1
	jsr -222(a6)				; LoadView ()
	jsr -270(a6)				; WaitTOF ()
	jsr -270(a6)				; WaitTOF ()
	jsr -228(a6)				; WaitBlit ()
	jsr -456(a6)				; OwnBlitter ()
	move.l graphicsBase,a1
	movea.l $4,a6
	jsr -414(a6)				; CloseLibrary ()

	moveq #0,d0					; Default VBR is $0
	movea.l $4,a6
	btst #0,296+1(a6)			; 68010+?
	beq _is68000
	lea _getVBR,a5
	jsr -30(a6)					; SuperVisor ()
	move.l d0,VBRPointer
	bra _is68000
_getVBR:
	;movec vbr,d0
	dc.l $4e7a0801				; movec vbr,d0
	rte
_is68000:

; System ausschalten

	jsr -132(a6)				; = JSR	-$84(a6)  FORBID - Multitasking deaktivieren

; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0			; Größe des Blocks in bytes
	move.l #$10002,d1			; Typ des Speichers - Chip RAM
	jsr -198(a6)				; = jsr	-$c6(a6) Allocmem
	move.l d0,copperlist		; die Startadresse des Speicherblocks zugeordnet

; Hardware-Interrupts und DMA sichern

	lea $DFF000,a5
	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

; Interrupt-Vektoren

	movea.l VBRPointer,a0
	lea $64(a0),a0
	lea vectors,a1
	REPT 6						; Hardware-Interrupts erzeugen Interrupts der Stufen 1 bis 6, 
								; die den Vektoren 25 bis 30 entsprechen und auf die Adressen
								; $64 bis $78 zeigen
	move.l (a0),(a1)+
	move.l #_rte,(a0)+
	ENDR

; Copperlist erstellen

	move.l copperlist,a0
	move.w #((DISPLAY_Y+(DISPLAY_DY>>1))<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+
	move.w #COLOR00,(a0)+
	move.w #$0F00,(a0)+
	move.l #$FFFFFFFE,(a0)+

;---------- Hauptprogramm ----------

; Copperlist aktivieren

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)
	move.w #$8280,DMACON(a5)	; DMAEN=1, COPEN=1
	
; VERTB-Interrupt aktivieren

	movea.l VBRPointer,a0		; Vector Base Register Pointer bei A500 = $0
	move.l #_VERTB,$6C(a0)		; Level 3 Interrupt-Vektor Adresse
	move.w #$C020,INTENA(a5)	; INTEN=1, VERTB=1

; Hauptschleife
	
_loop:

; auf das erste Viertel der Bildschirmhöhe warten

_wait0:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmpi.w #DISPLAY_Y+(DISPLAY_DY>>2),d0	; erstes Viertel des Bildschirms
	blt _wait0

; VERTB Interrupt auslösen 

	move.w #$00F0,color			; grün vorbereiten
	move.w #$8020,INTREQ(a5)	; Vertb Interrupt anfordern

; auf die nächste Zeile warten

_wait1:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0				
	bne _wait1					; Warten Sie auf Zeile 0, da der Code weniger Zeit 
								; benötigt als das Raster, um die Zeilen
								; DISPLAY_Y + DISPLAY_DY auf 312 zu verschieben 
								; und daher zu Zeile 0 zurückzukehren

; auf linke Maustaste warten	

	btst #6,$BFE001
	bne _loop

;---------- Ende ----------

; Hardware-Interrupts und DMA

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

; Interruptvektoren wiederherstellen

	movea.l VBRPointer,a0
	lea $64(a0),a0
	lea vectors,a1
	REPT 6
	move.l (a1)+,(a0)+
	ENDR

; Hardware-Interrupts und DMA wiederherstellen

	move.w olddmacon,d0
	bset #15,d0
	move.w d0,DMACON(a5)
	move.w oldintreq,d0
	bset #15,d0
	move.w d0,INTREQ(a5)
	move.w oldintena,d0
	bset #15,d0
	move.w d0,INTENA(a5)

; Copperlist wiederherstellen 

	lea graphicsLibrary,a1
	movea.l $4,a6
	jsr -408(a6)				; OpenLibrary ()
	move.l d0,graphicsBase

	movea.l d0,a0
	move.l 38(a0),COP1LCH(a5)
	clr.w COPJMP1(a5)

; StingRay's stuff

	movea.l view,a1
	move.l graphicsBase,a6
	jsr -222(a6)				; LoadView ()
	jsr -462(a6)				; DisownBlitter ()
	move.l graphicsBase,a1
	movea.l $4,a6
	jsr -414(a6)				; CloseLibrary ()

; System wiederherstellen

	jsr -138(a6)				; = JSR	-$8A(A6)	PERMIT - aktiviert Multitasking

; Speicher wieder freigeben

	movea.l copperlist,a1		; Anfangsadresse des zugewiesen Speicherbereichs
	move.l #COPSIZE,d0			; Größe des Blocks in Bytes
	jsr -210(a6)				; jsr	-$d2(a6)		; FreeMem

; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;---------- Interrupt ----------

	; VERTB

_VERTB:
	;	movem.l d0-d7/a0-a6,-(sp)	
	; Erforderlich, aber auf geänderte Register beschränkt
	move.w color,COLOR00(a5)	; Farbe wechseln
	move.w #$000F,color			; blau vorbereiten

	; Bestätigen Sie das VERTB-Ereignis

	move.w #$0020,INTREQ(a5)	; Vertb Anforderung zurücksetzen
	;	movem.l (sp)+,d0-d7/a0-a6	
	; Erforderlich, aber auf geänderte Register beschränkt
	rte

	; Sperrung

_rte:
	rte

;---------- Daten ----------

graphicsLibrary:	DC.B "graphics.library",0
					EVEN
graphicsBase:		DC.L 0
view:				DC.L 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
olddmacon:			DC.W 0
VBRPointer:			DC.L 0		; Vector Base Register Pointer A500 = $0
vectors:			BLK.L 6
copperlist:			DC.L 0
color:				DC.W 0		


	end

In der Hauptschleife wird durch VPOSR auf die Rasterzeile $6C gewartet. Wenn
diese erreicht wurde, wird die Farbe $0F0 (grün) in die Variable color
geschrieben und ein VERTB Interrupt softwaretechnisch angefordert. In der
Interrupt-Behandlungsroutine wird die Farbe aus der Variable color nach
Color00 kopiert und der Interrupt Vertb quittiert.

--> ab Zeile $6C ist die Hintergrundfarbe grün

Dann wird durch die Hauptschleife auf die Zeile 0 gewartet und anschließend
das Drücken der Maustaste abgefragt. Parallel dazu läuft die Copperliste und
schaltet bei Erreichen der Zeile $AC die Farbe auf rot um.

--> ab Zeile $AC ist die Hintergrundfarbe rot 

Beim Übergang von Zeile 313 nach 0 wird der VERTB Interrupt durch die Hardware
ausgelöst. Bei der Bearbeitung der Interrupt-Routine wird die vorher 
eingestellte Farbe grün in Color00 kopiert und die neue Farbe blau in die
Variable color geschrieben.

--> ab Zeile 0 ist die Hintergrundfarbe grün

blau - bei Erreichen Zeile 0				- ($00) - VertB - durch Hardware
grün - nach erstem Viertel des Bildschirms	- ($6C) - durch Software VertB
rot  - nach Hälfte des Bildschirms 			- ($AC) - durch Copperliste	