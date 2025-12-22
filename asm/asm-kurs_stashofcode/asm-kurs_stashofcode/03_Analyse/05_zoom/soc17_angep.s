
; soc17_angep.s = zoom0.s

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr, stashofcode@gmail.com) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Beispiel für das Verbergen von Linien durch Änderung von DIWSTRT, DIWSTOP, BPLxPTH/L und BPLxMOD.
; Sie verkleinern einfach das Bild (PICTURE_DX x PICTURE_DY Pixel), indem Sie die ersten ZOOM_N Zeilen,
; die mittleren ZOOM_N Zeilen und die letzten ZOOM_N Zeilen ausblenden und das Ergebnis auf dem
; Bildschirm vertikal zentrieren. Das Bild wird normal angezeigt und gezoomt, wenn die linke
; Maustaste gedrückt und wieder losgelassen wird. Dazu werden die Werte, die mit MOVE in die
; Copperlist geschrieben werden, verändert.

;********** Konstanten **********

; Programm

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=5
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+2*(1+1+1)*4+4
	; 10*4					Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4		Adressen der Bitebenen
	; (1<<DISPLAY_DEPTH)*4	Palette
	; 2*(1+1+1)*4			2 Mal die Sequenz: WAIT, MOVE auf BPL1MOD und MOVE auf BPL2MOD
	; 4						$FFFFFFFE
;----------------------------------------------------------
DIWSTRT_val = (DISPLAY_Y<<8)!DISPLAY_X
DIWSTOP_val = (((DISPLAY_Y+DISPLAY_DY)&255)<<8)!((DISPLAY_X+DISPLAY_DX)&255)	; Begrenzung bis $7F
DDFSTRT_val = ((DISPLAY_X-17)>>1)&$00FC											; oder &$00F8
DDFSTOP_val = (((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00F8)				; oder $00F8

BPLCON0_val = (DISPLAY_DEPTH<<12)!$0200
BPLCON1_val = 0
BPLCON2_val = 0	; $0008															; PF2P2-0=1 => Bitplane des einzigen Playfields hinter dem Sprite 0
BPL1MOD_val = 0
BPL2MOD_val = 0
;----------------------------------------------------------
PICTURE_DX=DISPLAY_DX		; Konstante, die zur Verdeutlichung eingeführt wurde, indem zwischen dem,
							; was den Bildschirm (DISPLAY_*) betrifft, und dem, was das Bild (PICTURE_*)
							; betrifft, unterschieden wird.
PICTURE_DY=DISPLAY_DY		; dito
ZOOM_N=16

DEBUG=0

;********** Macros **********

; Warten Sie auf den Blitter. Wenn der zweite Operand eine Adresse ist, testet BTST nur
; die Bits 7-0 des gezeigten Bytes, aber da der erste Operand als Modulo-8-Bitnummer
; behandelt wird, bedeutet BTST #14,DMACONR(a5), dass das Bit 14%8=6 des höchstwertigen
; Bytes von DMACONR getestet wird, was gut zu BBUSY passt...

WAIT_BLITTER:	MACRO
_WAIT_BLITTER0\@
	btst #14,DMACONR(a5)	; Entspricht dem Testen von Bit 14 % 8 = 6 des höchstwertigen Bytes von DMACONR, also BBUSY
	bne _WAIT_BLITTER0\@
_WAIT_BLITTER1\@
	btst #14,DMACONR(a5)
	bne _WAIT_BLITTER1\@
	ENDM

;********** Initialisierung **********

	SECTION code,CODE

	; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)
	lea $DFF000,a5

	; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperList

	; System ausschalten

	movea.l $4,a6
	jsr -132(a6)

	; Warten Sie auf ein VERTB (damit die Sprites nicht sabbern) und
	; schalten Sie alle Hardware-Interrupts und DMAs aus.

	bsr _waitVERTB
	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

	; Umleitung von Hardware-Interrupt-Vektoren (Stufe 1 bis 6 entspricht
	; den Vektoren 25 bis 30, die auf die Adressen $64 bis $78 zeigen)

	lea $64,a0
	lea vectors,a1
	REPT 6
	move.l (a0),(a1)+
	move.l #_rte,(a0)+
	ENDR

;********** Copperlist **********

	movea.l copperList,a0

	move.w #DIWSTRT,(a0)+				; Konfiguration des Bildschirms				
	move.w #DIWSTRT_val,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #DIWSTOP_val,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #DDFSTRT_val,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #DDFSTOP_val,(a0)+

	move.w #BPLCON0,(a0)+
	move.w #BPLCON0_val,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #BPLCON1_val,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #BPLCON2_val,(a0)+	
	
	move.w #BPL1MOD,(a0)+
	move.w #BPL1MOD_val,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #BPL2MOD_val,(a0)+

	; Kompatibilität OCS mit AGA

	move.l #$01FC0000,(a0)+

	; Adressen der Bitebenen

	move.l #picture,d0					; Anfangsadresse bitplane
	move.w #BPL1PTH,d1
	moveq #DISPLAY_DEPTH-1,d2			; Anzahl der Bitebenen, hier 5
_bitplanes:
	move.w d1,(a0)+						; Registeradresse Offset in Copperlist BPL1PTH
	addq.w #2,d1						; Registeradresse Offset addieren 2 Bytes
	swap d0								; Wörter tauschen
	move.w d0,(a0)+						; hohes Wort der Adresse in Copperlist
	move.w d1,(a0)+						; Registeradresse Offset in Copperlist BPL1PTL
	addq.w #2,d1						; Registeradresse Offset addieren 2 Bytes
	swap d0								; Wörter tauschen
	move.w d0,(a0)+						; niedriges Wort der Adresse in Copperlist
	addi.l #PICTURE_DY*(PICTURE_DX>>3),d0	; Adresse nächste Bitplane  (256*(320/8)=10240 Bytes)
	dbf d2,_bitplanes					; wiederholen für alle Bitebenen

	; Palette

	lea picture,a1						; Anfangsadresse Bild
	addi.l #DISPLAY_DEPTH*PICTURE_DY*(PICTURE_DX>>3),a1	;  5*256*(320/8) die Farben liegen hinter dem Bild
	moveq #1,d0							; 00000001 = 1
	lsl.b #DISPLAY_DEPTH,d0				; 00100000 = 32 Anzahl Farben
	subq.b #1,d0						; 00011111 = 31 Schleifenzähler
	move.w #COLOR00,d1					; Farbregister Startwert
_colors:
	move.w d1,(a0)+						; Farbregister in Copperlist
	addq.w #2,d1						; nächster Farbregisterwert
	move.w (a1)+,(a0)+					; Farbwerte des Bildes kopieren
	dbf d0,_colors						; für alle Farbregister wiederholen

	; Verdeckung der ZOOM_N Mittellinien (derzeit neutralisiert)

	move.w #((DISPLAY_Y+((3*ZOOM_N)>>1)+((PICTURE_DY-ZOOM_N)>>1)-ZOOM_N-1)<<8)!$0001,(a0)+	; dc.w $AB01
	move.w #$8000!($7F<<8)!$FE,(a0)+	; dc.w $FFFE													
	move.w #BPL1MOD,(a0)+				; zu Beginn Modulowerte 0
	move.w #0,(a0)+						; 
	move.w #BPL2MOD,(a0)+				; 
	move.w #0,(a0)+						; 

	; Nach dieser Zeile und vor dem Ende der nächsten muss BPLxMOD auf seinen Anfangswert zurückgesetzt werden

	move.w #((DISPLAY_Y+((3*ZOOM_N)>>1)+((PICTURE_DY-ZOOM_N)>>1)-ZOOM_N)<<8)!$0001,(a0)+	; dc.w $AC01
	move.w #$8000!($7F<<8)!$FE,(a0)+	; dc.w $FFFE
	move.w #BPL1MOD,(a0)+				; zu Beginn Modulowerte 0
	move.w #0,(a0)+						; 
	move.w #BPL2MOD,(a0)+				; 
	move.w #0,(a0)+						; 

	; Ende

	move.l #$FFFFFFFE,(a0)

	; Wiederherstellung der DMA

	move.w #$83C0,DMACON(a5)			; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

	; copperlist aktivieren

	move.l copperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

;********** Hauptprogramm **********

	; Auf einen Mausklick warten

_waitLButtonPushed:
	btst #6,$BFE001
	bne _waitLButtonPushed
_waitLButtonReleased
	btst #6,$BFE001
	beq _waitLButtonReleased

	; Ändern Sie die Startadresse der Bitplanes, um die ersten ZOOM_N-Zeilen zu verbergen.

	movea.l copperList,a0					; Anfangsadresse Copperlist
	lea 10*4(a0),a0							; Offset hinzufügen wo die BPLxPT sind
	move.l #picture+ZOOM_N*(PICTURE_DX>>3),d0	; Anfangsadresse Bild + 16 * (320/8), d.h. 16 Zeilen vom Bild überspringen
	moveq #DISPLAY_DEPTH-1,d1				; Anzahl der Bitebenen, hier 5
_updateBitplanes:
	swap d0									; Wörter tauschen
	move.w d0,2(a0)							; Bitplanepointer hi-Wort speichern
	lea 4(a0),a0							; 4 bytes überspringen - für nächstes hi-wort
	swap d0									; Wörter tauschen
	move.w d0,2(a0)							; Bitplanepointer lo-Wort speichern
	lea 4(a0),a0							; 4 bytes überspringen - für nächstes lo-wort
	addi.l #PICTURE_DY*(PICTURE_DX>>3),d0	; 256*(320/8)=10240 Bytes - nächste Bitebene
	dbf d1,_updateBitplanes					; wiederholen für alle Bitebenen

	; Ändern Sie die Werte, die BPLxMOD in der Mitte des Bildschirms zugewiesen
	; wurden, um die ZOOM_N Mittellinien zu verbergen.

	movea.l copperList,a0					; Anfangsadresse Copperlist
	lea 10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+4(a0),a0	; Offset hinzufügen wo BPL1MOD ist
	move.w #ZOOM_N*(PICTURE_DX>>3),2(a0)	; BPL1MOD - 16*(320/8)=640 = $280 - BPL1MOD
	move.w #ZOOM_N*(PICTURE_DX>>3),4+2(a0)	; BPL2MOD - 16*(320/8)=640 = $280		

	; Ändern Sie DIWSTRT und DIWSTOP, um das Bild zu zentrieren und die letzten ZOOM_N-Zeilen auszublenden.

	movea.l copperList,a0					; Anfangsadresse Copperlist
	move.w #((DISPLAY_Y+((3*ZOOM_N)>>1))<<8)!DISPLAY_X,2(a0)									; dc.w $4481
	move.w #((DISPLAY_Y+DISPLAY_DY-((3*ZOOM_N)>>1)-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),4+2(a0)	; dc.w $14c1

	; Hauptschleife

_loop:
	btst #6,$BFE001
	bne _loop

;********** Ende **********

	; Hardware-Interrupts und DMAs ausschalten

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

	; Interrupts wiederherstellen

	lea $64,a0
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

	lea graphicslibrary,a1
	movea.l $4,a6
	jsr -408(a6)
	move.l d0,a1
	move.l 38(a1),COP1LCH(a5)
	clr.w COPJMP1(a5)
	jsr -414(a6)

	; System wiederherstellen

	movea.l $4,a6
	jsr -138(a6)

	; Speicher freigeben

	movea.l copperList,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;********** Routinen **********

	INCLUDE "common/registers.s"
	INCLUDE "common/wait.s"

;---------- Interrrupt-Handler ----------

_rte:
	rte

;********** Daten **********

	SECTION data,DATA_C

graphicslibrary:	DC.B "graphics.library",0
					EVEN
vectors:			BLK.L 6
copperList:			DC.L 0
bitplanes:			DC.L 0
olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
picture:			INCBIN "dragonSun320x256x5.raw"

	end

Programmbeschreibung: zoom0.s

Also, der Zoom-Effekt ist eine Illusion bei der Zeilen oder/und Spalten eines Bildes auf
geeignete Weise entfernt werden und das Bild dabei auf dem Bildschirm zentriert wird.

Beim Beispiel zoom0.s wird der vertikale Zoom gezeigt. Das Bild ist zu Beginn 320x256
Pixel groß. Die Werte für DIWSTRT, DIWSTOP sind entsprechend eingestellt:

vorher:
>o1
 00076d50: 008e 2c81            ;  DIWSTRT := 0x2c81
 00076d54: 0090 2cc1            ;  DIWSTOP := 0x2cc1

 Nach Ausführung der Zoom-Funktion ist das Bild 320x208 Pixel groß. Es wurden also 
 48 Pixel aus dem Bild entfernt. Das Bild wurde zentriert und die DIWSTRT, DIWSTOP
 Werte wurden angepasst. 

danach:
 00076d50: 008e 4481            ;  DIWSTRT := 0x4481		
 00076d54: 0090 14c1            ;  DIWSTOP := 0x14c1

 >?$44-$2c
0x00000018 = %00000000000000000000000000011000 = 24 = 24	; 24 Zeilen weniger 
>?$2c-$14
0x00000018 = %00000000000000000000000000011000 = 24 = 24	; 24 Zeilen weniger 
>?256-48
0x000000D0 = %00000000000000000000000011010000 = 208 = 208	; Höhe 208 Pixel

Das Bild fängt also 24 Pixel tiefer an und hört 24 Pixel höher auf.
Dafür wurde jeweils 3*16 Pixel aus dem Bild entfernt und zwar am Anfang, am Ende
und in der Mitte. 
Am Anfang des Bildes wurden die Bitplanepointer in der Copperliste neu gesetzt und
zwar auf den Wert Anfang des Bildes + 16 Zeilen tiefer.
Bei der Entfernung der Zeilen in der Mitte wurde ein positiver Modulo Wert an
der Zeile $AB gesetzt. Dadurch werden am Ende der Zeile (also ab der nächsten Zeile)
16 Zeilen des Bildes (16*40Bytes) übersprungen. Danach wird der Modulowert an 
Zeile $AC auf 0 zurückgesetzt. Modulowert: 16*(320/8)=640 = $280
Am Ende werden 16 Zeilen des Bildes durch das frühzeitigere Schließen des 
Videofensters entfernt.

1/3 oben			- 16 Pixel
1/3 in der Mitte	- 16 Pixel	
1/3 unten			- 16 Pixel

;------------------------------------------------------------------------------

DISPLAY_DY=256
ZOOM_N=16
PICTURE_DY=DISPLAY_DY

move.w #((DISPLAY_Y+((3*ZOOM_N)>>1)+((PICTURE_DY-ZOOM_N)>>1)-ZOOM_N-1)<<8)!$0001,(a0)+	; $AB01		
move.w #$8000!($7F<<8)!$FE,(a0)+														; $FFFE

move.w #((DISPLAY_Y+((3*ZOOM_N)>>1)+((PICTURE_DY-ZOOM_N)>>1)-ZOOM_N-1)<<8)!$0001,(a0)+	; $AB01	

(3*ZOOM_N)>>1						= 
(3*16)								= 48			= 00000000.00110000
(3*16)>>1							= 24			= 00000000.00011000
DISPLAY_Y							= $2C	= 44	= 00000000.00101100
((DISPLAY_Y+((3*ZOOM_N)>>1)			= $44			= 00000000.01000100

(PICTURE_DY-ZOOM_N)>>1				= (256-16)>>1			= 120 = 00000000.01111000
(PICTURE_DY-ZOOM_N)>>1)-ZOOM_N-1	= ((256-16)>>1)-16-1	= 102 = 00000000.01100111


(DISPLAY_Y+((3*ZOOM_N)>>1)+((PICTURE_DY-ZOOM_N)>>1)-ZOOM_N-1)				= $44+$67=$AB= 00000000.10101011

((DISPLAY_Y+((3*ZOOM_N)>>1)+((PICTURE_DY-ZOOM_N)>>1)-ZOOM_N-1)<<8)!$0001	= 10101011.00000001	dc.w $AB01


move.w #$8000!($7F<<8)!$FE,(a0)+	; $FFFE

$8000!($7F<<8)!$FE

$8000					=		10000000.00000000
$8000!($7F<<8)			=		11111111.00000000
$8000!($7F<<8)!$FE		=		11111111.11111110	= $FFFE


;------------------------------------------------------------------------------

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
ZOOM_N=16

move.w #((DISPLAY_Y+((3*ZOOM_N)>>1))<<8)!DISPLAY_X,2(a0)	; $4481
move.w #((DISPLAY_Y+DISPLAY_DY-((3*ZOOM_N)>>1)-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),4+2(a0)	; $14c1

move.w #((DISPLAY_Y+((3*ZOOM_N)>>1))<<8)!DISPLAY_X,2(a0)	; 

((DISPLAY_Y+((3*ZOOM_N)>>1))<<8)
((DISPLAY_Y+((3*ZOOM_N)>>1)							= $44		= 01000100.00000000
((DISPLAY_Y+((3*ZOOM_N)>>1))<<8)!DISPLAY_X			=			= 01000100.10000001			; $4481


move.w #((DISPLAY_Y+DISPLAY_DY-((3*ZOOM_N)>>1)-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),4+2(a0)	;

DISPLAY_Y				; $2c
DISPLAY_DY				; 256	
(3*ZOOM_N)>>1			; 3*16=48  48/2=24
(DISPLAY_Y+DISPLAY_DY-((3*ZOOM_N)>>1)-256)			= $14
<<8						; 8 Bits nach links shiften		= dc.w $14xx


(DISPLAY_Y+DISPLAY_DY-((3*ZOOM_N)>>1)&255

DISPLAY_X					= $81
DISPLAY_X+DISPLAY_DX		= $81+320		= $1c1
(DISPLAY_X+DISPLAY_DX-256)	= $c1 