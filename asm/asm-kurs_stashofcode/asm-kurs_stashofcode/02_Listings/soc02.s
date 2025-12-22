
; soc02.s = vertb1.s

; Programmiert von Yragael für Stash of Code
; (http://www.stashofcode.fr) im Jahr 2017.

; Diese Arbeit wird unter den Bedingungen der Creative Commons
; Namensnennung-Keine kommerzielle Nutzung-Weitergabe unter
; gleichen Bedingungen 4.0 UK-Lizenz zur Verfügung gestellt.

; In dieser Version:
;
; - Auf der halben Höhe des Bildschirms verwandelt das Copper die Farbe in Rot ($0F00).
; - Im letzten Viertel der Bildschirmhöhe ändert der Copper die Farbe in Schwarz ($0000), 
; indem er einen VERTB-Interrupt auslöst
; - Nach dem Ende der Bildschirmhöhe ändert die Hardware die Farbe in Blau ($000F),
; indem sie einen VERTB-Interrupt auslöst
; - Im ersten Viertel der Bildschirmhöhe ändert die CPU die Farbe in Grün ($00F0),
; indem sie einen VERTB-Interrupt auslöst
;
; Da der Interrupt-Manager ein Feld (color) verwendet, um die Farbe zu ändern, besteht
; die kleine Schwierigkeit darin, sicherzustellen, dass wir das Copper aktivieren und die 
; Interrupts zum richtigen Zeitpunkt verwalten, damit das vorherige Szenario korrekt
; ausgeführt wird. Dazu müssen Sie auf das Ende eines VERTB warten und das Ereignis bestätigen.

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
COPSIZE=4*4+4

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

	jsr -132(a6)

; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	jsr -198(a6)
	move.l d0,copperlist

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

;---------- Copperlist ----------

	move.l copperlist,a0

; Warten auf halber Höhe des Bildschirms

	move.w #((DISPLAY_Y+((2*DISPLAY_DY)>>2))<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+

; Farbe ändern in rot ($0F00)

	move.w #COLOR00,(a0)+
	move.w #$0F00,(a0)+

; Warten auf das letzte Viertel der Bildschirmhöhe

	move.w #((DISPLAY_Y+((3*DISPLAY_DY)>>2))<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+

; einen VERTB-Interrupt auslösen, um die Farbe in Schwarz zu ändern ($0000)

	move.w #INTREQ,(a0)+
	move.w #$8020,(a0)+

; Ende

	move.l #$FFFFFFFE,(a0)+

;---------- Hauptprogramm ----------

; Warten, bis das Ende eines VERTB feststeht, in welcher 
; Reihenfolge die Farben verwendet werden: VERTB nach CPU,
; copper, VERTB nach copper, VERTB nach Hardware

_waitVERTB:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	bne _waitVERTB

; Bestätigen Sie das letzte VERTB-Ereignis, um zu verhindern,
; dass es den Level 3-Interrupt der CPU auslöst

	move.w #$0020,INTREQ(a5)

; VERTB-Interrupt aktivieren

	movea.l VBRPointer,a0
	move.l #_VERTB,$6C(a0)
	move.w #$C020,INTENA(a5)	; INTEN=1, VERTB=1

; Copperlist aktivieren

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)
	move.w #$8280,DMACON(a5)	; DMAEN=1, COPEN=1

; Hauptschleife
	
_loop:

; auf das erste Viertel der Bildschirmhöhe warten

_wait0:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmpi.w #DISPLAY_Y+((1*DISPLAY_DY)>>2),d0
	blt _wait0

; VERTB-Interrupt auslösen, um die Farbe in Grün zu ändern ($00F0)

	move.w #$8020,INTREQ(a5)

; auf eine nächste Zeile warten

_wait1:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	bne _wait1					; Warten Sie auf Zeile 0, da der Code weniger
								; Zeit benötigt als das Raster, um die Zeilen
								; DISPLAY_Y + DISPLAY_DY auf 312 zu verschieben
								; und daher zur Zeile 0 zurückzukehren

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

; Hardware-Interrupts und DMAs wiederherstellen

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

	jsr -138(a6)

; Speicher wieder freigeben

	movea.l copperlist,a1
	move.l #COPSIZE,d0
	jsr -210(a6)

;  Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;---------- Interruptt ----------

	; VERTB

_VERTB:
	movem.l d0/a0,-(sp)
	; Erforderlich, aber auf geänderte Register beschränkt

; COLOR0 ändern

	lea colors,a0
	move.w (a0),COLOR00(a5)

; Farben wechseln

	move.w (a0),d0
	move.w 2(a0),(a0)+
	move.w 2(a0),(a0)+
	move.w d0,(a0)

;  VERTB-Ereignis bestätigen

	move.w #$0020,INTREQ(a5)
	movem.l (sp)+,d0/a0		
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
VBRPointer:			DC.L 0
vectors:			BLK.L 6
copperlist:			DC.L 0
colors:				DC.W $00F0, $0000, $000F
;color:				DC.w 3

	end


Die Copperliste ändert die Hintergrundfarbe auf halber Höhe (Zeile $AC) in rot
und fodert bei Erreichen des letzten Viertels des Bildschirms (Zeile $EC) einen
VERTB Interrupt an. Bei der Bearbeitung der Interrupt-Routine wird die erste
Farbe des Farbfeldes in das Fabregister Color00 kopiert und anschließend 
werden die Farben des Feldes getauscht. 

In der Hauptschleife wird durch VPOSR auf die Rasterzeile $6C gewartet und bei
Erreichen ein VERTB Interrupt softwaretechnisch angefordert und die 
Hintergrundfarbe in grün geändert. 
 
Danach wird durch die Hauptschleife auf die Zeile 0 gewartet und anschließend
das Drücken der Maustaste abgefragt. Parallel dazu läuft die Copperliste und
schaltet bei Erreichen der Zeile $AC die Hintergrundfarbe auf rot um.

Beim Übergang von Zeile 313 nach 0 wird der VERTB Interrupt durch die Hardware
ausgelöst und die die Hintergrundfarbe auf blau geändert.

blau 	- bei Erreichen Zeile 0					- ($00) - VertB - durch Hardware
grün 	- nach erstem Viertel des Bildschirms	- ($6C) - VertB - durch Software
rot  	- nach Hälfte des Bildschirms 			- ($AC)         - durch Copperliste 
schwarz - bei letzten Viertel des Bildschirms	- ($EC) - VertB - durch Software angefordert durch Copperliste
	