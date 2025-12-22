
; soc04e.s
; Parameter Plasma

BORDER_COLOR=$0000
OFFSET_AMPLITUDE=10
OFFSET_ROW_SPEED=2

RED_START  =359<<1		; Wert zwischen 0 und 720	(Winkelwert * 2)
GREEN_START=90<<1
BLUE_START =60<<1

RED_ROW_SPEED  =1
GREEN_ROW_SPEED=3
BLUE_ROW_SPEED =12

RED_FRAME_SPEED  =3
GREEN_FRAME_SPEED=3
BLUE_FRAME_SPEED =6

RED_AMPLITUDE   =18		; OFFSET_AMPLITUDE+RED_AMPLITUDE muss <= 29 sein 
GREEN_AMPLITUDE =15		; OFFSET_AMPLITUDE+GREEN_AMPLITUDE muss <= 29 sein 
BLUE_AMPLITUDE  =19		; OFFSET_AMPLITUDE+BLUE_AMPLITUDE muss <= 29 sein 

MINTERMS_SPEED=100		; In Frames ausgedrückt (1/50 Sekunden)


start:
	moveq #3,d1							; 256-1 Schleifenzähler
_rows:
	; Generieren der Copperlist
	
	move.w redSinus,d3					; rote Komponenete nach d3
	
	; Animieren des Sinus der Komponenten

	move.w redSinus,d3					; aktuellen Wert holen
	subi.w #RED_FRAME_SPEED<<1,d3		; rote Frame Geschwindigkeit * 2 subtrahieren 
	bge _noRedSinusUnderflow			; wenn größer, gleich 0, dann übersrpringen
	addi.w #360<<1,d3					; ansonsten auf Startwert setzen (720)
_noRedSinusUnderflow:
	move.w d3,redSinus					; aktuellen Wert zurückspeichern

	dbf d1,_rows

	rts

;----------Daten ----------

	SECTION yragael,DATA_C
bitplane:			DC.L 0
rgbOffsets:			DC.L 0
rowOffsets:			DC.L 0
graphicslibrary:	DC.B "graphics.library",0
	even
copperList0:		DC.L 0
copperList1:		DC.L 0
olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
redSinus:			DC.W RED_START
greenSinus:			DC.W GREEN_START
blueSinus:			DC.W BLUE_START