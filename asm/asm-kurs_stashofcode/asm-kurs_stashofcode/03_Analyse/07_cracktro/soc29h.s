
; soc29h.s
; 3D-Effekt

; Code von Yragael für Maximilian / Paradox

	section prg,code_c
	include "short_registers.s"
	include "exec_lib.i"

; *************** PARAMETER DES SCREENS (1) ***************

StartX=129							; horizontaler Start des Plots
StartY=50							; vertikaler Start des Plots

; *************** PARAMETER DES SCREENS 0 ***************

NbPlane0=5							; 5
SizeX0=320							; 320
SizeY0=160							; 160	

TraceX0=320							; Breite des zu plottenden Bildes ...
									; ... von StartX aus

DisplayX0=320						;  Breite des zu betrachtenden Bildes ...
									; ... von StartDisplayX aus.

StartDisplayX0=129					; sichtbarer horizontaler Anfang des Bildes.
									; 129=$81
StopX0=DisplayX0+StartDisplayX0-256	; sichtbares horizontales Ende des Bildes 
									; 320+129-256=193 = $c1
DDF_Strt0=(StartX-17)/2				; (129-17)/2=56 = $38
DDF_Stop0=DDF_Strt0+(TraceX0/2-8)	; $38+(320/2-8) = 208 = $d0

ModuloPair0=(SizeX0-TraceX0)/8		; (320-320)/8=0
ModuloImpair0=(SizeX0-TraceX0)/8	; (320-320)/8=0

PlaneSize0=SizeY0*SizeX0/8			; 160*320/8= 160*40=6400

; *************** PARAMETER DES SCREENS 1 ***************

NbPlane1=1							; 1
SizeX1=640+64						; 704
SizeY1=64+12+8*2					; 92

TraceX1=640							; Breite des zu plottenden Bildes ...
									; ... von StartX aus

DisplayX1=640						;  Breite des zu betrachtenden Bildes ...
									; ... von StartDisplayX aus.

StartDisplayX1=129					; sichtbarer horizontaler Anfang des Bildes.
									; 129=$81	
StopX1=DisplayX1/2+StartDisplayX1-256	; sichtbares horizontales Ende des Bildes  
									; 640/2 + 129-256 = 193 = $c1
DDF_Strt1=(StartX-9)/2				; 129 = $81-9/2=60 = $3c
DDF_Stop1=DDF_Strt1+(TraceX1/4-8)	; $3c+(640/4-8)=$3c+152=212 = $d4

ModuloPair1=(SizeX1-TraceX1)/8+SizeX1/8		; (704-640)/8 + 704/8 = 8+88=96 = $60
ModuloImpair1=(SizeX1-TraceX1)/8+SizeX1/8	; (704-640)/8 + 704/8 = 8+88=96 = $60

PlaneSize1=SizeY1*SizeX1/8			; 92*704/8=8096

; *************** PARAMETER DES SCREENS (2) ***************

DisplayY=SizeY0+SizeY1/2			; Höhe des anzuzeigenden Bildes ...
									; ... ab StartY
									; 160+92/2=206
StopY=DisplayY+StartY-256			; sichtbares vertikales Ende des Bildes
									; 206+50-256=0
; *************** KONSTANTEN ***************

;BobSizeX=16*16						; 16 Bobs mit je 16 Pixel Breite
;BobSizeY=8							; und 8 Pixel Höhe
;ScrollHeight=12
;FontWidth=64
FontHeight=64
;SpaceWidth=16						; Wert in Pixel des Zeichens SpaceWidth
;DeltaChar=4						; Pixelwert der SpaceWidth zwischen zwei Buchstaben
;fontSizeX=640
CentreZ=510
DeltaX=1
DeltaY=2
DeltaZ=1
MEMF_CLEAR=$10000
MEMF_CHIP=$2
MEMF_FAST=$4

Cop0Size=32*4+10*4+8*NbPlane0+SizeY0*3*4+4+2*4+7*4+8*NbPlane1+8+2*4+4
Cop1Size=32*4+10*4+8*NbPlane0+SizeY0*3*4+4+2*4+7*4+8*NbPlane1+8+2*4+4

; 32*4 (palette screen 0)
; 9*4+8*NbPlane0 (instructions bezogen auf den screen 0)
; SizeY0*3*4 (waits, modulos)
; 4 (wait Änderung des screens)
; 2*4 (palette screen 1)
; 7*4+8*NbPlane1 (instructions ezogen auf den  1)
; 8 (wait, Änderung color 0)
; 4*2 (Änderung der copperlist)
; +4 $FFFF FFFE (Ende der copperlist)

; *************** MACROS ***************

; ----- warte auf blitter -----

WAITBLIT:	macro
Wait_Blit0\@
		btst #14,DMACONR(a5)
		bne Wait_Blit0\@
Wait_Blit1\@
		btst #14,DMACONR(a5)
		bne Wait_Blit1\@
		endm

; ----- warte auf VBL -----

WAITVBL:	macro
Wait_VBL\@
		cmp.b #$FF,VHPOSR(a5)
		bne Wait_VBL\@
		endm

; *************** HAUPTPROGRAMM ***************

; +++++ Um 6 verschiedenfarbige Seiten auf zwei Bitplanes anzuzeigen, wird
; +++++ die Tatsache ausgenutzt, dass, wenn eine Seite sichtbar ist, ihre Gegenteil
; +++++ unsichtbar ist.
; +++++ Man zeichnet die beiden gegenüberliegenden Seiten so, dass sie die gleiche Farbe haben.
; +++++ die gleiche Farbe verwenden. Man verwendet also drei Farben.
; +++++ Wenn eine Seite angezeigt wird und ihre Gegenseite verschwindet, ändert man
; +++++ der Wert der gemeinsamen Farbe, so dass man 2 Seiten mit unterschiedlichen Farben erhält.
; +++++ unterschiedlichen Seiten.
; +++++ Die Farben werden am Anfang der Copperlist gelesen, d.h. lange vor dem Beginn der Copperlist.
; +++++ bevor diese bei der Anzeige der Gesichter geändert wird, werden die
; +++++ Farben werden auf dem Bildschirm erst bei der nächsten VBL geändert, und zwar am
; +++++ dem Swapping der Bitplanes!

; +++++ Außerdem nimmt man eine angepasste Größe des Blitterfensters.

; +++++ Man benutzt eine eigene Palette, die man in einem Zug durch die
; +++++ der Copperlist statt aufeinanderfolgender Bewegungen nach und nach.
; +++++ der Flächenlesung


; ----- Register sichern -----

	movem.l d0-d7/a0-a6,-(sp)

; ----- Initialisierung -----

	bsr Init

; ------ Initialisierung der Parameter ------

	;lea Text_adr,a4						; Zeiger auf Scrolltext
	movea.l Screen0Buffer_adr,a0		; Zeiger auf Screen0Buffer
	move.w #2*(360-DeltaX),AngleX
	move.w #2*(360-DeltaY),AngleY
	move.w #2*(360-DeltaZ),AngleZ
	moveq #0,d0							; Startwert für Scrolltext
	move.w d0,-(sp)						; Wert wird in Scrolltext-Routine abgefragt

; ------ Hauptprogramm ------

Main_Loop:
	WAITVBL

; ------ austauschen der Bitplanes ------	

	move.l a0,d0
	movea.l Cop0_adr,a0
	movea.l Cop1_adr,a1
	lea 32*4+10*4+2(a0),a0
	lea 32*4+10*4+2(a1),a1
	move.w (a0),d1
	swap d1
	move.w 4(a0),d1
	rept NbPlane0-1
	swap d0
	move.w d0,(a0)
	move.w d0,(a1)
	swap d0
	move.w d0,4(a0)
	move.w d0,4(a1)
	addi.l #PlaneSize0/2,d0
	addq.w #8,a0
	addq.w #8,a1
	endr
	move.l d1,a0

; ----- Musik -----

	;bsr module_adr+24

; ------ Eingabe von Palettenfarben -----

	movea.l Cop0_adr,a1
	movea.l Cop1_adr,a3
	addq.w #6,a1
	addq.w #6,a3
	lea Color_adr,a2
	rept 15
	move.w (a2),(a1)
	move.w (a2)+,(a3)
	addq.w #4,a1
	addq.w #4,a3
	endr
	lea Color_adr,a2
	addq.w #4,a1
	addq.w #4,a3
	rept 15
	move.w (a2),(a1)
	move.w (a2)+,(a3)
	addq.w #4,a1
	addq.w #4,a3
	endr


; ------ löscht den Arbeitsplanebuffer ------

	WAITBLIT
	move.w #20,BLTDMOD(a5)			; BLTDMOD 20 bytes
	move.w #$0000,BLTCON1(a5)		; keine Sondermodi
	move.w #%0000000100000000,BLTCON0(a5)	; nur Kanal D
	lea 10(a0),a1					; 
	move.l a1,BLTDPTH(a5)			; Ziel - Kanal D - Bitplane
	move.w #SizeX0/16-10+64*SizeY0*(NbPlane0-1)/2,BLTSIZE(a5)	; 320/16-10+64*160*(5-1)/2=10 Wörter und 320 Zeilen
																; $500a	

; ------ ausführen rotation X ------

	move.w AngleX,d1
	subq.w #2*DeltaX,d1
	bge AngleX_OK
	move.w #2*(360-DeltaX),d1
AngleX_OK:
	move.w d1,AngleX

; ------ ausführen  rotation Y ------

	move.w AngleY,d1
	subq.w #2*DeltaY,d1
	bge AngleY_OK
	move.w #2*(360-DeltaY),d1
AngleY_OK:
	move.w d1,AngleY

; ------ ausführen rotation Z ------

	move.w AngleZ,d1
	subq.w #2*DeltaZ,d1
	bge AngleZ_OK
	move.w #2*(360-DeltaZ),d1
AngleZ_OK:
	move.w d1,AngleZ

; ----- berechnet die Koordinaten -----

	lea Coor2D_adr,a1
	lea Scene0Strt_adr,a2
	rept 8
	move.w (a2)+,d0
	move.w (a2)+,d1
	move.w (a2)+,d2

; +++++ rotation X +++++

	move.w AngleX,d3
	lea Cosinus_adr,a6
	move.w (a6,d3.w),d5				; d5=cosX
	swap d5
	lea Sinus_adr,a6
	move.w (a6,d3.w),d5				; d5=cosX:sinX
	move.w d1,d3					; d3=y
	muls d5,d1
	swap d1
	rol.l #1,d1						; d1=ysinX
	move.w d2,d6
	muls d5,d6		
	swap d6
	rol.l #1,d6						; d6=zsinX
	swap d5							; d5=sinX:cosX
	muls d5,d3		
	swap d3
	rol.l #1,d3						; d3=ycosX
	add.w d3,d6						; d6=ycosX+zsinX
	muls d5,d2		
	swap d2
	rol.l #1,d2						; d2=zcosX
	sub.w d1,d2						; d2=zcosX-ysinX
	move.w d6,d1					; d1=ycosX+zsinX

; +++++ rotation Y +++++

	move.w AngleY,d3
	lea Cosinus_adr,a6
	move.w (a6,d3.w),d5				; d5=cosY
	swap d5
	lea Sinus_adr,a6
	move.w (a6,d3.w),d5				; d5=cosY:sinY
	move.w d0,d3					; d3=x
	muls d5,d0		
	swap d0
	rol.l #1,d0						; d0=xsinY
	move.w d2,d6
	muls d5,d6		
	swap d6
	rol.l #1,d6						; d6=zsinY
	swap d5							; d5=sinY:cosY
	muls d5,d3		
	swap d3
	rol.l #1,d3						; d3=xcosY
	addi.w d3,d6					; d6=xcosY+zsinY
	muls d5,d2		
	swap d2
	rol.l #1,d2						; d2=zcosY
	sub.w d0,d2						; d2=zcosY-xsinY
	move.w d6,d0					; d0=zcosY+xsinY

; +++++ rotation Z +++++

	move.w AngleZ,d3
	lea Cosinus_adr,a6
	move.w (a6,d3.w),d5				; d5=cosZ
	swap d5
	lea Sinus_adr,a6
	move.w (a6,d3.w),d5				; d5=cosZ:sinZ
	move.w d0,d3					; d3=x
	muls d5,d0		
	swap d0
	rol.l #1,d0						; d0=xsinZ
	move.w d1,d6
	muls d5,d6		
	swap d6
	rol.l #1,d6						; d6=ysinZ
	swap d5							; d5=sinZ:cosZ
	muls d5,d3		
	swap d3
	rol.l #1,d3						; d3=xcosZ
	add.w d3,d6						; d6=xcosZ+ysinZ
	muls d5,d1		
	swap d1
	rol.l #1,d1						; d1=ycosZ
	sub.w d0,d1						; d1=ycosZ-xsinZ
	move.w d6,d0					; d0=xcosZ+ysinZ

; +++++ perspective +++++

	add.w #CentreZ,d2
	ext.l d0
	asl.l #8,d0
	divs d2,d0
	ext.l d1
	asl.l #7,d1
	divs d2,d1
	add.w #SizeX0/2,d0
	add.w #SizeY0/4,d1
	move.w d0,(a1)+
	move.w d1,(a1)+
	endr

	lea Scene0Strt_adr,a2
	rept 8
	move.w (a2)+,d0
	move.w (a2)+,d1
	move.w (a2)+,d2

; +++++ rotation Y +++++

	move.w AngleY,d3
	lea Cosinus_adr,a6
	move.w (a6,d3.w),d5				; d5=cosY
	swap d5
	lea Sinus_adr,a6
	move.w (a6,d3.w),d5				; d5=cosY:sinY
	move.w d0,d3					; d3=x
	muls d5,d0		
	swap d0
	rol.l #1,d0						; d0=xsinY
	move.w d2,d6
	muls d5,d6		
	swap d6
	rol.l #1,d6						; d6=zsinY
	swap d5							; d5=sinY:cosY
	muls d5,d3		
	swap d3
	rol.l #1,d3						; d3=xcosY
	addi.w d3,d6					; d6=xcosY+zsinY
	muls d5,d2		
	swap d2
	rol.l #1,d2						; d2=zcosY
	sub.w d0,d2						; d2=zcosY-xsinY
	move.w d6,d0					; d0=zcosY+xsinY

; +++++ rotation Z +++++

	move.w AngleZ,d3
	lea Cosinus_adr,a6
	move.w (a6,d3.w),d5				; d5=cosZ
	swap d5
	lea Sinus_adr,a6
	move.w (a6,d3.w),d5				; d5=cosZ:sinZ
	move.w d0,d3					; d3=x
	muls d5,d0		
	swap d0
	rol.l #1,d0						; d0=xsinZ
	move.w d1,d6
	muls d5,d6		
	swap d6
	rol.l #1,d6						; d6=ysinZ
	swap d5							; d5=sinZ:cosZ
	muls d5,d3		
	swap d3
	rol.l #1,d3						; d3=xcosZ
	add.w d3,d6						; d6=xcosZ+ysinZ
	muls d5,d1		
	swap d1
	rol.l #1,d1						; d1=ycosZ
	sub.w d0,d1						; d1=ycosZ-xsinZ
	move.w d6,d0					; d0=xcosZ+ysinZ

; +++++ rotation X +++++

	move.w AngleX,d3
	lea Cosinus_adr,a6
	move.w (a6,d3.w),d5				; d5=cosX
	swap d5
	lea Sinus_adr,a6
	move.w (a6,d3.w),d5				; d5=cosX:sinX
	move.w d1,d3					; d3=y
	muls d5,d1
	swap d1
	rol.l #1,d1						; d1=ysinX
	move.w d2,d6
	muls d5,d6		
	swap d6
	rol.l #1,d6						; d6=zsinX
	swap d5							; d5=sinX:cosX
	muls d5,d3		
	swap d3
	rol.l #1,d3						; d3=ycosX
	add.w d3,d6						; d6=ycosX+zsinX
	muls d5,d2		
	swap d2
	rol.l #1,d2						; d2=zcosX
	sub.w d1,d2						; d2=zcosX-ysinX
	move.w d6,d1					; d1=ycosX+zsinX

; +++++ perspective +++++

	add.w #CentreZ,d2
	ext.l d0
	asl.l #8,d0
	divs d2,d0
	ext.l d1
	asl.l #7,d1
	divs d2,d1
	add.w #SizeX0/2,d0
	add.w #SizeY0/4,d1
	move.w d0,(a1)+
	move.w d1,(a1)+
	endr

; ----- Palette Reinitialisierung -----

	lea Color_adr,a1
	rept 31
	move.w #0,(a1)+
	endr

; ------ zeichnet die Linien ------
	
	lea Color_adr,a3
	lea Coor2D_adr,a2
	lea Face0Strt_adr,a1
	WAITBLIT
	move.w #$FFFF,BLTBDAT(a5)
	move.w #SizeX0/8,BLTCMOD(a5)
	move.w #SizeX0/8,BLTDMOD(a5)
	move.w #$8000,BLTAFWM(a5)
	move.w #$8000,BLTADAT(a5)

	move.w #FaceSize/20-1,d4
Face_Loop:
	move.w 2(a1),d0					; C
	move.w 4(a1),d1					; A
	move.w 6(a1),d2					; B
	move.w (a2,d2.w),d3				; d3=Xb
	sub.w (a2,d1.w),d3				; d3=Xb-Xa=X
	move.w 2(a2,d0.w),d5			; d5=Yc
	sub.w 2(a2,d1.w),d5				; d5=Yc-Ya=Y'
	muls d3,d5						; d5=XY'
	move.w (a2,d0.w),d3				; d3=Xc
	sub.w (a2,d1.w),d3				; d3=Xc-Xa=X'
	move.w 2(a2,d2.w),d6			; d6=Yb
	sub.w 2(a2,d1.w),d6				; d6=Yb-Ya=Y
	muls d6,d3						; d3=YX'
	sub.w d3,d5						; d5=XY'-YX'
	ble Face_Hidden

	move.l a0,d7
	move.w (a1)+,d0
	lea (a0,d0.w),a0

	rept 3
	move.w (a1)+,d0
	move.w 2(a2,d0.w),d1
	move.w (a2,d0.w),d0
	move.w (a1),d2
	move.w 2(a2,d2.w),d3
	move.w (a2,d2.w),d2
	bsr DrawLine
	endr

	move.w (a1)+,d0
	move.w 2(a2,d0.w),d1
	move.w (a2,d0.w),d0
	move.w -8(a1),d2
	move.w 2(a2,d2.w),d3
	move.w (a2,d2.w),d2
	bsr DrawLine

	movea.l d7,a0

	move.w 8(a1),d1
	move.w (a1)+,d0
	add.w d1,(a3,d0.w)
	move.w (a1)+,d0
	add.w d1,(a3,d0.w)
	move.w (a1)+,d0
	add.w d1,(a3,d0.w)
	move.w (a1)+,d0
	add.w d1,(a3,d0.w)
	addq.w #2,a1

	dbf d4,Face_Loop
	bra Face_End
Face_Hidden:
	lea 20(a1),a1
	dbf d4,Face_Loop
Face_End:

merde:

; ----- Flächenfüllung -----

; +++++ Die Füllung erfolgt im ECE-Ausschlussverfahren, damit die Konturen
; +++++ die für 2 Flächen in unterschiedlichen Bitplanes gleich sind, nicht
; +++++ eine dritte Farbe bilden.
	bra aaa
	WAITBLIT
	move.w #20,BLTBMOD(a5)
	move.w #20,BLTDMOD(a5)
	move.w #%0000010111001100,BLTCON0(a5)	; 05CC	(A & B & C) | (A & B & !C) | (!A & B & C) | (!A & B & !C) --> A+B | !A+B --> B
	;move.w #%0000000000011010,BLTCON1(a5)	; 001A	--> EFE, IFE, DESC
	;move.w #$001A,BLTCON1(a5)
	;move.w #$0012,BLTCON1(a5)				; EFE, DESC
	;move.w #$000A,BLTCON1(a5)				; IFE, DESC
	;move.w #$0016,BLTCON1(a5)				; EFE, FCI, DESC
	move.w #$000E,BLTCON1(a5)				; IFE, FCI, DESC
	movea.l a0,a1
	add.l #(NbPlane0-1)*PlaneSize0/2-12,a1	; (5-1)*6400/2-12=12788 = $31F4
	move.l a1,BLTBPTH(a5)					; Quelle
	move.l a1,BLTDPTH(a5)					; Ziel
	move.w #SizeX0/16-10+64*(NbPlane0-1)*SizeY0/2,BLTSIZE(a5)		; 320/16-10+64*(5-1)*160/2 --> 10 Wörter Breite und 320 Zeilen
aaa:

; ----- Maustest -----

	btst #6,$bfe001
	bne Main_Loop

; ----- Ende -----

	move.w (sp)+,d0
	;bsr module_adr+16
	;bsr module_adr+8
	bsr End

; ----- Register wiederherstellen -----

	movem.l (sp)+,d0-d7/a0-a6

	rts

; *************** GERADENVERFOLGUNG ***************

; Eingang
; 	A0=adresse bitplane
; 	D0=Xi
; 	D1=Yi
; 	D2=Xf
; 	D3=Yf

; A6,D5,D6

DrawLine:

; ----- Punktterminierung -----

	cmp.w d1,d3
	beq DrawLine_End
	bge DrawLine_UpDown
	exg d0,d2
	exg d1,d3
DrawLine_UpDown:
	subq.w #1,d3

; ------ Berechnung rechte Abfahrtsadresse -----
	
	moveq #0,d6
	move.w d1,d6
	lsl.l #3,d6
	move.l d6,d5
	lsl.l #2,d5
	add.l d5,d6						; d6=y1*Anzahl Bytes pro Zeile
	add.l a0,d6						; +Startadresse Bitplane
	moveq #0,d5
	move.w d0,d5
	lsr.w #3,d5
	bclr #0,d5
	add.l d5,d6						; +x1/8

; ----- Oktantensuche -----

	moveq #0,d5
	sub.w d1,d3						; d3=Dy=y2-y1
	bpl.b Dy_Pos
	bset #2,d5
	neg d3
Dy_Pos:	
	sub.w d0,d2						; d2=Dx=x2-x1
	bpl.b Dx_Pos
	bset #1,d5
	neg d2
Dx_Pos:
	cmp.w d3,d2						; Dx-Dy
	bpl.b DxDy_Pos
	bset #0,d5
	exg d3,d2						; ainsi d3=Pdelta et d2=Gdelta
DxDy_Pos:
	add.w d3,d3						; d3=2*Pdelta

; ----- BLTCON0 -----
	
	and.w #$F,d0
	ror.w #4,d0
	or.w #$B4A,d0

; ----- BLTCON1 -----

	lea Octant_adr,a6
	move.b (a6,d5.w),d5
	lsl #2,d5
	bset #0,d5
	bset #1,d5

; ----- warte auf blitter -----

	WAITBLIT

; ----- BLTCON1, BLTBMOD, BLTAPTL, BLTAMOD -----

	move.w d3,BLTBMOD(a5)
	sub.w d2,d3
	bge.s DrawLine_NoBit
	bset #6,d5
DrawLine_NoBit:
	move.w d3,BLTAPTL(a5)
	sub.w d2,d3
	move.w d3,BLTAMOD(a5)

; ----- BLTSIZE -----

	lsl #6,d2
	add.w #66,d2

; ----- Start blitter -----

	move.w d5,BLTCON1(a5)
	move.w d0,BLTCON0(a5)
	move.l d6,BLTCPTH(a5)
	move.l d6,BLTDPTH(a5)
	move.w d2,BLTSIZE(a5)

; ----- Ende -----

DrawLine_End:

	rts

; *************** INITIALISIERUNG ***************

Init:

; -----Speicherreservierung screen 0 -----

	move.l #NbPlane0*PlaneSize0,d0
	move.l #MEMF_CHIP+MEMF_CLEAR,d1
	CALLEXEC AllocMem
	move.l d0,Screen0_adr

; ----- Speicherreservierung screen buffer 0 -----

	move.l #(NbPlane0-1)*PlaneSize0,d0
	move.l #MEMF_CHIP+MEMF_CLEAR,d1
	CALLEXEC AllocMem
	move.l d0,Screen0Buffer_adr

; ----- Speicherreservierung screen 1 -----

	move.l #NbPlane1*PlaneSize1,d0
	move.l #MEMF_CHIP+MEMF_CLEAR,d1
	CALLEXEC AllocMem
	move.l d0,Screen1_adr

; ----- Speicherreservierung copper 0 -----

	move.l #Cop0Size,d0
	move.l #MEMF_CHIP,d1
	CALLEXEC AllocMem
	move.l d0,Cop0_adr

; ----- Speicherreservierung copper 1 -----

	move.l #Cop1Size,d0
	move.l #MEMF_CHIP,d1
	CALLEXEC AllocMem
	move.l d0,Cop1_adr

; ----- Erzeugung der copperlist 0 -----

	movea.l Cop0_adr,a0

	move.l #$01800000,(a0)+				; dc.w $180,$0	- Color0
	move.w #$0182,d0					; dc.w $182		- Color1
	rept 15
	move.w d0,(a0)+
	addq.w #2,d0
	move.w #$0000,(a0)+
	endr
	move.l #$01A00035,(a0)+				; dc.w $1a0,$35	- Color16
	move.w #$01A2,d0					; dc.w $1a2		- Color17
	rept 15
	move.w d0,(a0)+
	addq.w #2,d0
	move.w #$0000,(a0)+
	endr

	move.w #$008E,(a0)+					; DIWSTRT		dc.w $008E,$3281
	move.w #StartY*256+StartDisplayX0,(a0)+
	move.w #$0090,(a0)+					; DIWSTOP		dc.w $0090,$00c1
	move.w #StopY*256+StopX0,(a0)+
	move.w #$0100,(a0)+					; BPLCON0		dc.w $0100,$5200
	move.w #NbPlane0,d0
	ror.w #4,d0
	bset #9,d0
	move.w d0,(a0)+
	move.w #$0102,(a0)+					; BPLCON1		dc.w $0102,$0
	move.w #$0000,(a0)+
	move.w #$0104,(a0)+					; BPLCON2		dc.w $0104,$0
	move.w #$0000,(a0)+
	move.w #$0092,(a0)+					; DDFSTRT		dc.w $0092,$0038
	move.w #DDF_Strt0,(a0)+
	move.w #$0094,(a0)+					; DDFSTOP		dc.w $0094,$00d0
	move.w #DDF_Stop0,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD		dc.w $0108,$0
	move.w #ModuloPair0,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD		dc.w $010A,$0
	move.w #ModuloImpair0,(a0)+
	move.l #$01FC0000,(a0)+				; FMODE			dc.w $01FC,$0

	move.l Screen0_adr,d0				; lädt Anfangsadresse des Screens 
	move.w #$00E0,d1					; $00e0
	rept NbPlane0-1						; 5-1
	move.w d1,(a0)+						; Bitplanepointerregister in Copperlist
	addq.w #2,d1						; nächste Bitplanepointerregister
	swap d0								; Hi-Lo Anteil vertauschen
	move.w d0,(a0)+						; hohen Anteil der Adresse in Copperlist
	move.w d1,(a0)+						; nächste Bitplanepointerregister
	addq.w #2,d1						; nächstes Bitplanepointerregister
	swap d0								; Hi-Lo Anteil vertauschen
	move.w d0,(a0)+						; niedrigen Anteil der Adresse
	addi.l #PlaneSize0/2,d0				; Offset hinzuaddieren, halbe Planesize addieren
	endr								; für 5 Bitplanes wiederholen

	move.l Screen0_adr,d0				; lädt Anfangsadresse des Screens				
	addi.l #(NbPlane0-1)*PlaneSize0,d0	; Offset (5-1)*(160*(320/8), komplette Planesize addieren				
	move.w d1,(a0)+						; Bitplanepointerregister in Copperlist, 5. Bitplane BPL5PTx
	addq.w #2,d1						; nächste Bitplanepointerregister
	swap d0								; Hi-Lo Anteil vertauschen
	move.w d0,(a0)+						; hohen Anteil der Adresse in Copperlist
	move.w d1,(a0)+						; nächste Bitplanepointerregister
	swap d0								; Hi-Lo Anteil vertauschen
	move.w d0,(a0)+						; niedrigen Anteil der Adresse

	move.w #StartY,d0					; Anfangszeile 50=$32
	lsl.w #8,d0							; um 8 Bits nach links verschieben
	or.w #$01,d0						; Bit0 ist immer 1
	moveq #SizeY0/2-1,d1				; 160/2-1 Wait-Positionen	
	
Modulo_Loop0:							; gefolgt von Modulo-Wechsel	
	move.w d0,(a0)+						; dc.w $3201
	move.w #$FFFE,(a0)+					; dc.w $3201,$fffe
	move.w #$0108,(a0)+					; BPL1MOD		dc.w $0108,$ffd8		; -40	Zeile wiederholen
	move.w #-SizeX0/8,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD		dc.w $010A,$ffd8		; -40	Zeile wiederholen
	move.w #-SizeX0/8,(a0)+
	addi.w #$0100,d0					; nächste Zeile
	move.w d0,(a0)+						; nächstes wait	dc.w $3301,$fffe
	move.w #$FFFE,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD		dc.w $0108,$0
	move.w #ModuloPair0,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD		dc.w $010A,$0
	move.w #ModuloImpair0,(a0)+
	addi.w #$0100,d0
	dbf d1,Modulo_Loop0					; wiederholen bis alle Zeilen fertig

	move.w #StartY+SizeY0,d0			; Anfangszeile 50=$32 + 160=$A0 = $d2
	lsl.w #8,d0							; um 8 Bits nach links verschieben
	or.w #$01,d0						; Bit0 ist immer 1
	move.w d0,(a0)+						; dc.w $d201		, Wait-Position in Copperlist
	move.w #$FFFE,(a0)+					; dc.w $d201,$fffe	, Wait-Maske

	move.l #$01800005,(a0)+				; Farbregisterwerte ändern
	move.l #$01820FFF,(a0)+				; blauer Streifen

	move.w #$0100,(a0)+					; BPLCON0		dc.w $100,$9204	hires, interlace, 1 Bitplane
	move.w #NbPlane1,d0					; 1
	ror.w #4,d0							; bpu0
	bset #9,d0							; color
	bset #15,d0							; hires
	bset #2,d0							; lace	
	move.w d0,(a0)+
	move.w #$0102,(a0)+					; BPLCON1		dc.w $102,$0
	move.w #$0000,(a0)+
	move.w #$0104,(a0)+					; BPLCON2		dc.w $104,$0
	move.w #$0000,(a0)+
	move.w #$0092,(a0)+					; DDFSTRT		dc.w $92,$003c 
	move.w #DDF_Strt1,(a0)+
	move.w #$0094,(a0)+					; DDFSTOP		dc.w $94,$00d4
	move.w #DDF_Stop1,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD		dc.w $0108,$0060
	move.w #ModuloPair1,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD		dc.w $010A,$0060
	move.w #ModuloImpair1,(a0)+
	move.l #$01FC0000,(a0)+				; FMODE			dc.w $01FC,$0

	move.l Screen1_adr,d0				; Bitplanepointer für Screen 1 in Copperlist
	move.w #$00E0,d1					; BPL1PTH		dc.w $00e0
	rept NbPlane1						; 1
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	;addi.l #PlaneSize1,d0				; kann hier eingespart werden
	endr

	move.w #StartY+SizeY0+FontHeight/2+8,d0	; Anfangszeile 50=$32 + 160=$A0 = $d2 + 64/2+8 = 250 = $FA
	lsl.w #8,d0							; 
	or.w #$01,d0						; dc.w $fa01
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+					; dc.w $fa01,$fffe

	move.l #$01800000,(a0)+				; Farbregisterwert zurück auf schwarz

	move.l Cop1_adr,d0					; Copperpointer auf Copperlist 1 setzen
	move.w #$0082,(a0)+					; COP1LCL
	move.w d0,(a0)+
	move.w #$0080,(a0)+					; COP1LCH
	swap d0
	move.w d0,(a0)+

	move.l #$FFFFFFFE,(a0)

; ----- Erzeugung copperlist 1 -----

	move.l Cop1_adr,a0

	move.l #$01800000,(a0)+				; dc.w $180,$0	- Color0
	move.w #$0182,d0					; dc.w $182		- Color1
	rept 15
	move.w d0,(a0)+
	addq.w #2,d0
	move.w #$0000,(a0)+
	endr
	move.l #$01A00035,(a0)+				; dc.w $1a0,$35	- Color16
	move.w #$01A2,d0					; dc.w $1a2		- Color17
	rept 15
	move.w d0,(a0)+
	addq.w #2,d0
	move.w #$0000,(a0)+
	endr

	move.w #$008E,(a0)+					; DIWSTRT		dc.w $008E,$3281
	move.w #StartY*256+StartDisplayX0,(a0)+
	move.w #$0090,(a0)+					; DIWSTOP		dc.w $0090,$00c1
	move.w #StopY*256+StopX0,(a0)+
	move.w #$0100,(a0)+					; BPLCON0		dc.w $0100,$5200
	move.w #NbPlane0,d0
	ror.w #4,d0
	bset #9,d0
	move.w d0,(a0)+
	move.w #$0102,(a0)+					; BPLCON1		dc.w $0102,$0
	move.w #$0000,(a0)+
	move.w #$0104,(a0)+					; BPLCON2		dc.w $0104,$0
	move.w #$0000,(a0)+
	move.w #$0092,(a0)+					; DDFSTRT		dc.w $0092,$0038
	move.w #DDF_Strt0,(a0)+
	move.w #$0094,(a0)+					; DDFSTOP		dc.w $0094,$00d0
	move.w #DDF_Stop0,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD		dc.w $0108,$0
	move.w #ModuloPair0,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD		dc.w $010A,$0
	move.w #ModuloImpair0,(a0)+
	move.l #$01FC0000,(a0)+				; FMODE			dc.w $01FC,$0
		
	move.l Screen0_adr,d0				; lädt Anfangsadresse des Screens 
	move.w #$00E0,d1					; $00e0
	rept NbPlane0-1						; 5-1
	move.w d1,(a0)+						; Bitplanepointerregister in Copperlist
	addq.w #2,d1						; nächste Bitplanepointerregister
	swap d0								; Hi-Lo Anteil vertauschen
	move.w d0,(a0)+						; hohen Anteil der Adresse in Copperlist
	move.w d1,(a0)+						; nächste Bitplanepointerregister
	addq.w #2,d1						; nächstes Bitplanepointerregister
	swap d0								; Hi-Lo Anteil vertauschen
	move.w d0,(a0)+						; niedrigen Anteil der Adresse
	addi.l #PlaneSize0/2,d0				; Offset hinzuaddieren, halbe Planesize addieren
	endr								; für 5 Bitplanes wiederholen

	move.l Screen0_adr,d0				; lädt Anfangsadresse des Screens				
	addi.l #(NbPlane0-1)*PlaneSize0,d0	; Offset (5-1)*(160*(320/8), komplette Planesize addieren				
	move.w d1,(a0)+						; Bitplanepointerregister in Copperlist, 5. Bitplane BPL5PTx
	addq.w #2,d1						; nächste Bitplanepointerregister
	swap d0								; Hi-Lo Anteil vertauschen
	move.w d0,(a0)+						; hohen Anteil der Adresse in Copperlist
	move.w d1,(a0)+						; nächste Bitplanepointerregister
	swap d0								; Hi-Lo Anteil vertauschen
	move.w d0,(a0)+						; niedrigen Anteil der Adresse
	
	move.w #StartY,d0					; Anfangszeile 50=$32
	lsl.w #8,d0							; um 8 Bits nach links verschieben
	or.w #$01,d0						; Bit0 ist immer 1
	moveq #SizeY0/2-1,d1				; 160/2-1 Wait-Positionen	
	
Modulo_Loop1:							; gefolgt von Modulo-Wechsel	
	move.w d0,(a0)+						; dc.w $3201
	move.w #$FFFE,(a0)+					; dc.w $3201,$fffe
	move.w #$0108,(a0)+					; BPL1MOD		dc.w $0108,$ffd8		; -40	Zeile wiederholen
	move.w #-SizeX0/8,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD		dc.w $010A,$ffd8		; -40	Zeile wiederholen
	move.w #-SizeX0/8,(a0)+
	addi.w #$0100,d0					; nächste Zeile
	move.w d0,(a0)+						; nächstes wait	dc.w $3301,$fffe
	move.w #$FFFE,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD		dc.w $0108,$0
	move.w #ModuloPair0,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD		dc.w $010A,$0
	move.w #ModuloImpair0,(a0)+
	addi.w #$0100,d0
	dbf d1,Modulo_Loop1					; wiederholen bis alle Zeilen fertig
	
	move.w #StartY+SizeY0,d0			; Anfangszeile 50=$32 + 160=$A0 = $d2
	lsl.w #8,d0							; um 8 Bits nach links verschieben
	or.w #$01,d0						; Bit0 ist immer 1
	move.w d0,(a0)+						; dc.w $d201		, Wait-Position in Copperlist
	move.w #$FFFE,(a0)+					; dc.w $d201,$fffe	, Wait-Maske

	move.l #$01800005,(a0)+				; Farbregisterwerte ändern
	move.l #$01820FFF,(a0)+				; blauer Streifen
		
	move.w #$0100,(a0)+					; BPLCON0		dc.w $100,$9204	hires, interlace, 1 Bitplane
	move.w #NbPlane1,d0
	ror.w #4,d0							; bpu0
	bset #9,d0							; color
	bset #15,d0							; hires
	bset #2,d0							; lace	
	move.w d0,(a0)+
	move.w #$0102,(a0)+					; BPLCON1		dc.w $102,$0
	move.w #$0000,(a0)+
	move.w #$0104,(a0)+					; BPLCON2		dc.w $104,$0
	move.w #$0000,(a0)+
	move.w #$0092,(a0)+					; DDFSTRT		dc.w $92,$003c 
	move.w #DDF_Strt1,(a0)+
	move.w #$0094,(a0)+					; DDFSTOP		dc.w $94,$00d4
	move.w #DDF_Stop1,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD		dc.w $0108,$0060
	move.w #ModuloPair1,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD		dc.w $010A,$0060
	move.w #ModuloImpair1,(a0)+
	move.l #$01FC0000,(a0)+				; FMODE			dc.w $01FC,$0

	move.l Screen1_adr,d0				; Bitplanepointer für Screen 1 in Copperlist
	move.w #$00E0,d1					; BPL1PTH		dc.w $00e0
	rept NbPlane1						; 1
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	;addi.l #PlaneSize1,d0				; kann hier eingespart werden
	endr

	move.w #StartY+SizeY0+FontHeight/2+8,d0	; Anfangszeile 50=$32 + 160=$A0 = $d2 + 64/2+8 = 250 = $FA
	lsl.w #8,d0							; 
	or.w #$01,d0						; dc.w $fa01
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+					; dc.w $fa01,$fffe

	move.l #$01800000,(a0)+				; Farbregisterwert zurück auf schwarz

	move.l Cop0_adr,d0					; Copperpointer auf Copperlist 1 setzen
	move.w #$0082,(a0)+					; COP1LCL
	move.w d0,(a0)+
	move.w #$0080,(a0)+					; COP1LCH
	swap d0
	move.w d0,(a0)+

	move.l #$FFFFFFFE,(a0)

; ----- forbid -----

	CALLEXEC Forbid

; ----- modif DMA,... -----

	lea $DFF000,a5
	move.w DMACONR(a5),DMACON_bak
	move.w INTENAR(a5),INTENA_bak
	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$7FFF,DMACON(a5)
	move.w #$2E-1,d0
	lea $8,a0
	lea Vectors_bak,a1
	lea Vectors_end,a2
Init_VecLoop:
	move.l (a0),(a1)+
	move.l a2,(a0)+
	dbf d0,Init_VecLoop
	move.l Cop1_adr,COP1LCH(a5)
	bclr #15,VPOSW(a5)
	clr.w COPJMP1(a5)
	move.w #$87C0,DMACON(a5)			; COPEN, BPLEN, BLTPRI, DMAEN

	rts

; *************** Ende DES PROGRAMMS ***************

End:	
	WAITBLIT

; ----- Wiederherstellung der DMA-Kanäle, ... ----

	move.w #$2E-1,d0
	lea Vectors_bak,a0
	lea $8,a1
End_VecLoop:
	move.l (a0)+,(a1)+
	dbf d0,End_VecLoop
	move.w DMACON_bak,d0
	bset #15,d0
	move.w d0,DMACON(a5)
	move.w INTENA_bak,d0
	bset #15,d0
	move.w d0,INTENA(a5)

; ----- permit -----

	CALLEXEC Permit

; ----- Speicherfreigabe screen 0 -----

	movea.l Screen0_adr,a1
	move.l #NbPlane0*PlaneSize0,d0
	CALLEXEC FreeMem

; ----- Speicherfreigabe screen buffer 0 -----

	movea.l Screen0Buffer_adr,a1
	move.l #(NbPlane0-1)*PlaneSize0,d0
	CALLEXEC FreeMem

; ----- Speicherfreigabe screen 1 -----

	movea.l Screen1_adr,a1
	move.l #NbPlane1*PlaneSize1,d0
	CALLEXEC FreeMem

; ----- Speicherfreigabe copper 0 -----

	movea.l Cop0_adr,a1
	move.l #Cop0Size,d0
	CALLEXEC FreeMem

; ----- Speicherfreigabe copper 1 -----

	movea.l Cop1_adr,a1
	move.l #Cop1Size,d0
	CALLEXEC FreeMem

; ----- Wiederherstellung copperlist -----

	lea GFX_name,a1
	CALLEXEC OldOpenLibrary
	move.l d0,a1
	move.l 38(a1),COP1LCH(a5)
	clr.w COPJMP1(a5)
	CALLEXEC CloseLibrary

	rts

; *************** VARIABLEN ***************

Scene0Strt_adr:
	dc.w -80,-80,80
	dc.w 80,-80,80
	dc.w 80,80,80
	dc.w -80,80,80
	dc.w -80,-80,-80
	dc.w 80,-80,-80
	dc.w 80,80,-80
	dc.w -80,80,-80
Scene0End_adr:

Face0Strt_adr:
	dc.w 0*PlaneSize0/2,0*4,3*4,2*4,1*4,0,8,16,24,$000F
	dc.w 0*PlaneSize0/2,6*4,7*4,4*4,5*4,0,8,16,24,$000B

	dc.w 1*PlaneSize0/2,0*4,1*4,5*4,4*4,2,10,18,26,$000B
	dc.w 1*PlaneSize0/2,6*4,2*4,3*4,7*4,2,10,18,26,$0009

	dc.w 0*PlaneSize0/2,6*4,5*4,1*4,2*4,4,12,20,28,$0007
	dc.w 1*PlaneSize0/2,6*4,5*4,1*4,2*4,4,12,20,28,$0007

	dc.w 0*PlaneSize0/2,0*4,4*4,7*4,3*4,4,12,20,28,$0005
	dc.w 1*PlaneSize0/2,0*4,4*4,7*4,3*4,4,12,20,28,$0005

	dc.w 2*PlaneSize0/2,8*4,11*4,10*4,9*4,6,8,10,12,$0F00
	dc.w 2*PlaneSize0/2,14*4,15*4,12*4,13*4,6,8,10,12,$0F00

	dc.w 3*PlaneSize0/2,8*4,9*4,13*4,12*4,14,16,18,20,$0B00
	dc.w 3*PlaneSize0/2,14*4,10*4,11*4,15*4,14,16,18,20,$0900

	dc.w 2*PlaneSize0/2,14*4,13*4,9*4,10*4,22,24,26,28,$0700
	dc.w 3*PlaneSize0/2,14*4,13*4,9*4,10*4,22,24,26,28,$0700

	dc.w 2*PlaneSize0/2,8*4,12*4,15*4,11*4,22,24,26,28,$0500
	dc.w 3*PlaneSize0/2,8*4,12*4,15*4,11*4,22,24,26,28,$0500
Face0End_adr:

FaceSize = Face0End_adr-Face0Strt_adr
CoorSize = 2*(Scene0End_adr-Scene0Strt_adr)/3

Vectors_end:	rte
Vectors_bak:	blk.l $2E
DMACON_bak:	dc.w 0
INTENA_bak:	dc.w 0
Color_adr:	blk.w 31
Screen0_adr:	dc.l 0
Screen0Buffer_adr:	dc.l 0
Screen1_adr:	dc.l 0
AngleX:		dc.w 0
AngleY:		dc.w 0
AngleZ:		dc.w 0
Cop0_adr:	dc.l 0
Cop1_adr:	dc.l 0
Coor2D_adr:	blk.w CoorSize
;Module_adr:	incbin "mod.hold_of_fame.pc"
;Bob_adr:	incbin "square-half.raw"		; 16 Bobs kleiner werdender Rechtecke
;Font8_adr:	incbin "logo.fnt"				; Font credits
;Font_adr:	incbin "coma-med.raw"			; Font-Daten des Scrolltextes
;Credits_adr:	incbin "credits.txt"		; Text credits
;	even
;Text_adr:	incbin "propor.scrl"			; Scrolltext
;		dc.b 0
	even
GFX_name:	dc.b 'graphics.library',0
	even
Sinus_adr:
	dc.w 0,572,1144,1715,2286,2856
	dc.w 3425,3993,4560,5126,5690
	dc.w 6252,6813,7371,7927,8481
	dc.w 9032,9580,10126,10668,11207
	dc.w 11743,12275,12803,13328,13848
	dc.w 14365,14876,15384,15886,16384
	dc.w 16877,17364,17847,18324,18795
	dc.w 19261,19720,20174,20622,21063
	dc.w 21498,21926,22348,22763,23170
	dc.w 23571,23965,24351,24730,25102
	dc.w 25466,25822,26170,26510,26842
	dc.w 27166,27482,27789,28088,28378
	dc.w 28660,28932,29196,29452,29698
	dc.w 29935,30163,30382,30592,30792
	dc.w 30983,31164,31336,31499,31651
	dc.w 31795,31928,32052,32166,32270
	dc.w 32365,32449,32524,32588,32643
	dc.w 32688,32723,32748,32763,32767
Cosinus_adr:
	dc.w 32763,32748,32723,32688
	dc.w 32643,32588,32524,32449,32365
	dc.w 32270,32166,32052,31928,31795
	dc.w 31651,31499,31336,31164,30983
	dc.w 30792,30592,30382,30163,29935
	dc.w 29698,29452,29196,28932,28660
	dc.w 28378,28088,27789,27482,27166
	dc.w 26842,26510,26170,25822,25466
	dc.w 25102,24730,24351,23965,23571
	dc.w 23170,22763,22348,21926,21498
	dc.w 21063,20622,20174,19720,19261
	dc.w 18795,18324,17847,17364,16877
	dc.w 16384,15886,15384,14876,14365
	dc.w 13848,13328,12803,12275,11743
	dc.w 11207,10668,10126,9580,9032
	dc.w 8481,7927,7371,6813,6252
	dc.w 5690,5126,4560,3993,3425
	dc.w 2856,2286,1715,1144,572,0

	dc.w -572,-1144,-1715,-2286,-2856
	dc.w -3425,-3993,-4560,-5126,-5690
	dc.w -6252,-6813,-7371,-7927,-8481
	dc.w -9032,-9580,-10126,-10668,-11207
	dc.w -11743,-12275,-12803,-13328,-13848
	dc.w -14365,-14876,-15384,-15886,-16384
	dc.w -16877,-17364,-17847,-18324,-18795
	dc.w -19261,-19720,-20174,-20622,-21063
	dc.w -21498,-21926,-22348,-22763,-23170
	dc.w -23571,-23965,-24351,-24730,-25102
	dc.w -25466,-25822,-26170,-26510,-26842
	dc.w -27166,-27482,-27789,-28088,-28378
	dc.w -28660,-28932,-29196,-29452,-29698
	dc.w -29935,-30163,-30382,-30592,-30792
	dc.w -30983,-31164,-31336,-31499,-31651
	dc.w -31795,-31928,-32052,-32166,-32270
	dc.w -32365,-32449,-32524,-32588,-32643
	dc.w -32688,-32723,-32748,-32763,-32767

	dc.w -32763,-32748,-32723,-32688
	dc.w -32643,-32588,-32524,-32449,-32365
	dc.w -32270,-32166,-32052,-31928,-31795
	dc.w -31651,-31499,-31336,-31164,-30983
	dc.w -30792,-30592,-30382,-30163,-29935
	dc.w -29698,-29452,-29196,-28932,-28660
	dc.w -28378,-28088,-27789,-27482,-27166
	dc.w -26842,-26510,-26170,-25822,-25466
	dc.w -25102,-24730,-24351,-23965,-23571
	dc.w -23170,-22763,-22348,-21926,-21498
	dc.w -21063,-20622,-20174,-19720,-19261
	dc.w -18795,-18324,-17847,-17364,-16877
	dc.w -16384,-15886,-15384,-14876,-14365
	dc.w -13848,-13328,-12803,-12275,-11743
	dc.w -11207,-10668,-10126,-9580,-9032
	dc.w -8481,-7927,-7371,-6813,-6252
	dc.w -5690,-5126,-4560,-3993,-3425
	dc.w -2856,-2286,-1715,-1144,-572

	dc.w 0,572,1144,1715,2286,2856
	dc.w 3425,3993,4560,5126,5690
	dc.w 6252,6813,7371,7927,8481
	dc.w 9032,9580,10126,10668,11207
	dc.w 11743,12275,12803,13328,13848
	dc.w 14365,14876,15384,15886,16384
	dc.w 16877,17364,17847,18324,18795
	dc.w 19261,19720,20174,20622,21063
	dc.w 21498,21926,22348,22763,23170
	dc.w 23571,23965,24351,24730,25102
	dc.w 25466,25822,26170,26510,26842
	dc.w 27166,27482,27789,28088,28378
	dc.w 28660,28932,29196,29452,29698
	dc.w 29935,30163,30382,30592,30792
	dc.w 30983,31164,31336,31499,31651
	dc.w 31795,31928,32052,32166,32270
	dc.w 32365,32449,32524,32588,32643
	dc.w 32688,32723,32748,32763,32767

; Oktentabelle: y2-y1,x2-x1,Dx-Dy
; wenn <0, dann 0 wenn >=0, dann 1. Zum Beispiel: 
; y2-y1<0 also 1
; x2-x1<0 also 1
; Dx-Dy<0 also 1
; der Oktantcode ist also .b, der sich an der Adresse octant+111 befindet.
	
Octant_adr:
	dc.b 4	; 000 y1<y2 x1<x2 Dx>Dy		 
	dc.b 0	; 001 y1<y2 x1<x2 Dx<Dy
	dc.b 5	; 010 y1<y2 x1>x2 Dx>Dy
	dc.b 2	; 011 y1<y2 x1>x2 Dx<Dy
	dc.b 6	; 100 y1>y2 x1<x2 Dx>Dy
	dc.b 1	; 101 y1>y2 x1<x2 Dx<Dy	
	dc.b 7	; 110 y1>y2 x1>x2 Dx>Dy	
	dc.b 3	; 111 y1>y2 x1>x2 Dx<Dy
	even