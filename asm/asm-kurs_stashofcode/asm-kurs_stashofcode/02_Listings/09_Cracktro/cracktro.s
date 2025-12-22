
; Code von Yragael für Maximilian / Paradox

	section prg,code_c
	include "short_registers.s"
	include "exec_lib.i"

; *************** PARAMETER DES SCREENS (1) ***************

StartX=129							; horizontaler Start des Plots
StartY=50							; vertikaler Start des Plots

; *************** PARAMETER DES SCREENS 0 ***************

NbPlane0=5
SizeX0=320
SizeY0=160

TraceX0=320							; Breite des zu plottenden Bildes bei ...
									; ... von StartX aus

DisplayX0=320						;  Breite des zu betrachtenden Bildes bei ...
									; ... von StartDisplayX aus.

StartDisplayX0=129					; sichtbarer horizontaler Anfang des Bildes.

StopX0=DisplayX0+StartDisplayX0-256	; sichtbares horizontales Ende des Bildes 

DDF_Strt0=(StartX-17)/2 
DDF_Stop0=DDF_Strt0+(TraceX0/2-8)

ModuloPair0=(SizeX0-TraceX0)/8
ModuloImpair0=(SizeX0-TraceX0)/8

PlaneSize0=SizeY0*SizeX0/8

; *************** PARAMETER DES SCREENS 1 ***************

NbPlane1=1
SizeX1=640+64
SizeY1=64+12+8*2

TraceX1=640							; Breite des zu plottenden Bildes bei ...
									; ... von StartX aus

DisplayX1=640						;  Breite des zu betrachtenden Bildes bei ...
									; ... von StartDisplayX aus.

StartDisplayX1=129					; sichtbarer horizontaler Anfang des Bildes.

StopX1=DisplayX1/2+StartDisplayX1-256	; sichtbares horizontales Ende des Bildes  

DDF_Strt1=(StartX-9)/2 
DDF_Stop1=DDF_Strt1+(TraceX1/4-8)

ModuloPair1=(SizeX1-TraceX1)/8+SizeX1/8
ModuloImpair1=(SizeX1-TraceX1)/8+SizeX1/8

PlaneSize1=SizeY1*SizeX1/8

; *************** PARAMETER DES SCREENS (2) ***************

DisplayY=SizeY0+SizeY1/2			; Höhe des anzuzeigenden Bildes bei ...
									; ... ab StartY

StopY=DisplayY+StartY-256			; sichtbares vertikales Ende des Bildes

; *************** KONSTANTEN ***************

BobSizeX=16*16
BobSizeY=8
ScrollHeight=12
FontWidth=64
FontHeight=64
SpaceWidth=16						; Wert in Pixel des Zeichens SpaceWidth
DeltaChar=4							; Pixelwert der SpaceWidth zwischen zwei Buchstaben
fontSizeX=640
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

; +++++ Um 6 verschiedenfarbige Seiten auf zwei Bitplanes anzuzeigen, wird man
; +++++ nutzt die Tatsache, dass, wenn eine Seite sichtbar ist, ihr Gegenteil sichtbar ist.
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

; +++++ Man benutzt eine eigene Palette, die man in einem Zug durch die .
; +++++ der Copperlist statt aufeinanderfolgender Bewegungen nach und nach.
; +++++ der Flächenlesung


; ----- Register sichern -----

	movem.l d0-d7/a0-a6,-(sp)

; ----- Initialisierung -----

	bsr Init

; ----- Initialisierung Musik -----

	bsr Module_adr
	bsr Module_adr+4
	moveq #0,d0
	bsr Module_adr+12

; ----- credits -----

	lea Credits_adr,a1
	movea.l Screen1_adr,a0
	add.w #(SizeY1-8)*NbPlane1*SizeX1/8,a0
Credits_Loop:
	moveq #0,d1
	move.b (a1)+,d1
	cmp.b #$1B,d1
	beq Credits_End
	subi.b #$20,d1
	lsl.w #3,d1
	movea.l a0,a2
	lea Font8_adr,a3
	add.w d1,a3
	rept 8
	move.b (a3)+,(a2)
	lea NbPlane1*SizeX1/8(a2),a2
	endr
	addq.w #1,a0					; nächstes Zeichen
	jmp Credits_Loop
Credits_End:

; ------ Initialisierung der Parameter ------

	lea Text_adr,a4
	movea.l Screen0Buffer_adr,a0
	move.w #2*(360-DeltaX),AngleX
	move.w #2*(360-DeltaY),AngleY
	move.w #2*(360-DeltaZ),AngleZ
	moveq #0,d0
	move.w d0,-(sp)

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

	bsr module_adr+24

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

; ----- scroll -----

	moveq #2,d1						; Scrollgeschwindigkeit
	ror.w #4,d1
	bset #1,d1						; mode ascending
	movea.l Screen1_adr,a1
	add.w #(ScrollHeight+FontHeight)*NbPlane1*SizeX1/8-2,a1
	move.w #%0000010111001100,BLTCON0(a5)
	move.w d1,BLTCON1(a5)
	move.w #$0000,BLTDMOD(a5)
	move.w #$0000,BLTBMOD(a5)
	move.l a1,BLTBPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #SizeX1/16+64*FontHeight*NbPlane1,BLTSIZE(a5)

; ----- Buchstabenanzeige -----

	move.w (sp)+,d0
	dbf d0,Scroll_End

Scroll_NextChar:
	move.b (a4)+,d1
	bne Scroll_CharOK
	lea Text_adr,a4
	bra Scroll_NextChar
Scroll_CharOK:

	cmp.b #$20,d1
	bne Scroll_NoSpace
	moveq #SpaceWidth/2,d0			; scrollspeed=2
	movea.l Screen1_adr,a2
	add.w #ScrollHeight*NbPlane1*SizeX1/8+(SizeX1-FontWidth)/8,a2
	WAITBLIT
	move.w #%0000000111001100,BLTCON0(a5)
	move.w #$0000,BLTCON1(a5)
	move.w #$0000,BLTBDAT(a5)
	move.l a2,BLTDPTH(a5)
	move.w #(SizeX1-FontWidth)/8,BLTDMOD(a5)
	move.w #FontWidth/16+64*NbPlane1*FontHeight,BLTSIZE(a5)
	bra Scroll_End
Scroll_NoSpace:

	lea AlphaData_adr,a1
	moveq #-6,d2
Scroll_SearchChar:
	addq.w #6,d2
	cmp.b (a1)+,d1
	bne Scroll_SearchChar
	lea Alpha_adr,a1
	move.w 2(a1,d2.w),d1
	lsl.w #4,d1
	move.w d1,d3
	lsl.w #2,d3
	add.w d3,d1
	add.w (a1,d2.w),d1

	move.w 4(a1,d2.w),d0
	add.w #DeltaChar,d0
	lsr.w #1,d0						; Scrollgeschwindigkeit = 2
	subq.w #1,d0

	lea Font_adr,a1
	add.w d1,a1
	movea.l Screen1_adr,a2
	lea ScrollHeight*NbPlane1*SizeX1/8+(SizeX1-FontWidth)/8(a2),a2
	WAITBLIT
	move.w #%0000010111001100,BLTCON0(a5)
	move.w #$0000,BLTCON1(a5)
	move.l a1,BLTBPTH(a5)
	move.l a2,BLTDPTH(a5)
	move.w #(fontSizeX-FontWidth)/8,BLTBMOD(a5)
	move.w #(SizeX1-FontWidth)/8,BLTDMOD(a5)
	move.w #FontWidth/16+64*NbPlane1*FontHeight,BLTSIZE(a5)

Scroll_End:
	move.w d0,-(sp)

; ------ löscht den Arbeitsplanebuffer ------

	WAITBLIT
	move.w #20,BLTDMOD(a5)
	move.w #$0000,BLTCON1(a5)
	move.w #%0000000100000000,BLTCON0(a5)
	lea 10(a0),a1
	move.l a1,BLTDPTH(a5)
	move.w #SizeX0/16-10+64*SizeY0*(NbPlane0-1)/2,BLTSIZE(a5)

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
; +++++ dann nicht eine dritte Farbe bilden.

	WAITBLIT
	move.w #20,BLTBMOD(a5)
	move.w #20,BLTDMOD(a5)
	move.w #%0000010111001100,BLTCON0(a5)
	move.w #%0000000000011010,BLTCON1(a5)
	movea.l a0,a1
	add.l #(NbPlane0-1)*PlaneSize0/2-12,a1
	move.l a1,BLTBPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #SizeX0/16-10+64*(NbPlane0-1)*SizeY0/2,BLTSIZE(a5)

; ----- Schachbrettanimation -----

	movea.l Screen0_adr,a1
	add.w #(NbPlane0-1)*PlaneSize0+(SizeY0/2-8*BobSizeY)*SizeX0/8/2+12,a1
	lea Check_adr,a2
	moveq #8-1,d0
Check_loopX:
	moveq #8-1,d1
Check_loopY:
	move.w (a2),d2
	subq.w #2,(a2)+
	bge Check_NoLoop	
	move.w #15*2,-2(a2)
Check_NoLoop:
	lea Bob_adr,a3
	add.w d2,a3
	movea.l a1,a6
	rept 8
	move.w (a3),(a6)
	lea SizeX0/8(a6),a6
	lea BobSizeX/8(a3),a3
	endr
	addq.w #2,a1
	dbf d1,Check_LoopY
	lea BobSizeY*SizeX0/8-8*2(a1),a1
	dbf d0,Check_LoopX
	WAITBLIT

; ----- Maustest -----

	btst #6,$bfe001
	bne Main_Loop

; ----- Ende -----

	move.w (sp)+,d0
	bsr module_adr+16
	bsr module_adr+8
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

	move.l #$01800000,(a0)+
	move.w #$0182,d0
	rept 15
	move.w d0,(a0)+
	addq.w #2,d0
	move.w #$0000,(a0)+
	endr
	move.l #$01A00035,(a0)+
	move.w #$01A2,d0
	rept 15
	move.w d0,(a0)+
	addq.w #2,d0
	move.w #$0000,(a0)+
	endr

	move.w #$008E,(a0)+					; DIWSTRT
	move.w #StartY*256+StartDisplayX0,(a0)+
	move.w #$0090,(a0)+					; DIWSTOP
	move.w #StopY*256+StopX0,(a0)+
	move.w #$0100,(a0)+					; BPLCON0
	move.w #NbPlane0,d0
	ror.w #4,d0
	bset #9,d0
	move.w d0,(a0)+
	move.w #$0102,(a0)+					; BPLCON1
	move.w #$0000,(a0)+
	move.w #$0104,(a0)+					; BPLCON2
	move.w #$0000,(a0)+
	move.w #$0092,(a0)+					; DDFSTRT
	move.w #DDF_Strt0,(a0)+
	move.w #$0094,(a0)+					; DDFSTOP
	move.w #DDF_Stop0,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD
	move.w #ModuloPair0,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD
	move.w #ModuloImpair0,(a0)+
	move.l #$01FC0000,(a0)+

	move.l Screen0_adr,d0
	move.w #$00E0,d1
	rept NbPlane0-1
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	addi.l #PlaneSize0/2,d0
	endr
	move.l Screen0_adr,d0
	addi.l #(NbPlane0-1)*PlaneSize0,d0
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	move.w d1,(a0)+
	swap d0
	move.w d0,(a0)+

	move.w #StartY,d0
	lsl.w #8,d0
	or.w #$01,d0
	moveq #SizeY0/2-1,d1
Modulo_Loop0:
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD
	move.w #-SizeX0/8,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD
	move.w #-SizeX0/8,(a0)+
	addi.w #$0100,d0
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD
	move.w #ModuloPair0,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD
	move.w #ModuloImpair0,(a0)+
	addi.w #$0100,d0
	dbf d1,Modulo_Loop0

	move.w #StartY+SizeY0,d0
	lsl.w #8,d0
	or.w #$01,d0
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+

	move.l #$01800005,(a0)+
	move.l #$01820FFF,(a0)+

	move.w #$0100,(a0)+					; BPLCON0
	move.w #NbPlane1,d0
	ror.w #4,d0
	bset #9,d0
	bset #15,d0
	bset #2,d0
	move.w d0,(a0)+
	move.w #$0102,(a0)+					; BPLCON1
	move.w #$0000,(a0)+
	move.w #$0104,(a0)+					; BPLCON2
	move.w #$0000,(a0)+
	move.w #$0092,(a0)+					; DDFSTRT
	move.w #DDF_Strt1,(a0)+
	move.w #$0094,(a0)+					; DDFSTOP
	move.w #DDF_Stop1,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD
	move.w #ModuloPair1,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD
	move.w #ModuloImpair1,(a0)+
	move.l #$01FC0000,(a0)+

	move.l Screen1_adr,d0
	move.w #$00E0,d1
	rept NbPlane1
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	;addi.l #PlaneSize1,d0
	endr

	move.w #StartY+SizeY0+FontHeight/2+8,d0
	lsl.w #8,d0
	or.w #$01,d0
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+

	move.l #$01800000,(a0)+

	move.l Cop1_adr,d0
	move.w #$0082,(a0)+					; COP1LCL
	move.w d0,(a0)+
	move.w #$0080,(a0)+					; COP1LCH
	swap d0
	move.w d0,(a0)+

	move.l #$FFFFFFFE,(a0)

; ----- Erzeugung copperlist 1 -----

	move.l Cop1_adr,a0

	move.l #$01800000,(a0)+
	move.w #$0182,d0
	rept 15
	move.w d0,(a0)+
	addq.w #2,d0
	move.w #$0000,(a0)+
	endr
	move.l #$01A00035,(a0)+
	move.w #$01A2,d0
	rept 15
	move.w d0,(a0)+
	addq.w #2,d0
	move.w #$0000,(a0)+
	endr

	move.w #$008E,(a0)+					; DIWSTRT
	move.w #StartY*256+StartDisplayX0,(a0)+
	move.w #$0090,(a0)+					; DIWSTOP
	move.w #StopY*256+StopX0,(a0)+
	move.w #$0100,(a0)+					; BPLCON0
	move.w #NbPlane0,d0
	ror.w #4,d0
	bset #9,d0
	move.w d0,(a0)+
	move.w #$0102,(a0)+					; BPLCON1
	move.w #$0000,(a0)+
	move.w #$0104,(a0)+					; BPLCON2
	move.w #$0000,(a0)+
	move.w #$0092,(a0)+					; DDFSTRT
	move.w #DDF_Strt0,(a0)+
	move.w #$0094,(a0)+					; DDFSTOP
	move.w #DDF_Stop0,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD
	move.w #ModuloPair0,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD
	move.w #ModuloImpair0,(a0)+
	move.l #$01FC0000,(a0)+

	move.l Screen0_adr,d0
	move.w #$00E0,d1
	rept NbPlane0-1
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	addi.l #PlaneSize0/2,d0
	endr
	move.l Screen0_adr,d0
	addi.l #(NbPlane0-1)*PlaneSize0,d0
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	move.w d1,(a0)+
	swap d0
	move.w d0,(a0)+

	move.w #StartY,d0
	lsl.w #8,d0
	or.w #$01,d0
	moveq #SizeY0/2-1,d1
Modulo_Loop1:
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD
	move.w #-SizeX0/8,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD
	move.w #-SizeX0/8,(a0)+
	addi.w #$0100,d0
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD
	move.w #ModuloPair0,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD
	move.w #ModuloImpair0,(a0)+
	addi.w #$0100,d0
	dbf d1,Modulo_Loop1

	move.w #StartY+SizeY0,d0
	lsl.w #8,d0
	or.w #$01,d0
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+

	move.l #$01800005,(a0)+
	move.l #$01820FFF,(a0)+

	move.w #$0100,(a0)+					; BPLCON0
	move.w #NbPlane1,d0
	ror.w #4,d0
	bset #9,d0
	bset #15,d0
	bset #2,d0
	move.w d0,(a0)+
	move.w #$0102,(a0)+					; BPLCON1
	move.w #$0000,(a0)+
	move.w #$0104,(a0)+					; BPLCON2
	move.w #$0000,(a0)+
	move.w #$0092,(a0)+					; DDFSTRT
	move.w #DDF_Strt1,(a0)+
	move.w #$0094,(a0)+					; DDFSTOP
	move.w #DDF_Stop1,(a0)+
	move.w #$0108,(a0)+					; BPL1MOD
	move.w #ModuloPair1,(a0)+
	move.w #$010A,(a0)+					; BPL2MOD
	move.w #ModuloImpair1,(a0)+
	move.l #$01FC0000,(a0)+

	move.l Screen1_adr,d0
	addi.l #SizeX1/8,d0
	move.w #$00E0,d1
	rept NbPlane1
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	;addi.l #PlaneSize1,d0
	endr

	move.w #StartY+SizeY0+FontHeight/2+8,d0
	lsl.w #8,d0
	or.w #$01,d0
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+

	move.l #$01800000,(a0)+

	move.l Cop0_adr,d0
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
Module_adr:	incbin "mod.hold_of_fame.pc"
Bob_adr:	incbin "square-half.raw"
Font8_adr:	incbin "logo.fnt"
Font_adr:	incbin "coma-med.raw"
Credits_adr:	incbin "credits.txt"
	even
Text_adr:	incbin "propor.scrl"
		dc.b 0
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

AlphaData_adr:
	dc.b $41,$42,$43,$44,$45,$46,$47,$48,$49,$4A
	dc.b $4B,$4C,$4D,$4E,$4F,$50,$51,$52,$53,$54
	dc.b $55,$56,$57,$58,$59,$5A,$61,$62,$63,$64
	dc.b $65,$66,$67,$68,$69,$6A,$6B,$6C,$6D,$6E
	dc.b $6F,$70,$71,$72,$73,$74,$75,$76,$77,$78
	dc.b $79,$7A,$31,$32,$33,$34,$35,$36,$37,$38
	dc.b $39,$30,$2C,$2E,$21,$3F,$7E,$28,$29,$27
	even

Alpha_adr:

; Byte horizontale Position, Zeile, Breite in Byte, Komplement in Bits

; A
	dc.w 0,0,37
; B
	dc.w 8,0,30
; C
	dc.w 16,0,27
; D
	dc.w 24,0,34
; E
	dc.w 32,0,28
; F
	dc.w 40,0,26
; G
	dc.w 48,0,33
; H
	dc.w 56,0,36
; I
	dc.w 64,0,14
; J
	dc.w 72,0,18
; K
	dc.w 0,64,33
; L
	dc.w 8,64,26
; M
	dc.w 16,64,41
; N
	dc.w 24,64,35
; O
	dc.w 32,64,34
; P
	dc.w 40,64,28
; Q
	dc.w 48,64,34
; R
	dc.w 56,64,32
; S
	dc.w 64,64,22
; T
	dc.w 72,64,30
; U
	dc.w 0,128,34
; V
	dc.w 8,128,36
; W
	dc.w 16,128,52
; X
	dc.w 24,128,32
; Y
	dc.w 32,128,39
; Z
	dc.w 40,128,24
; a
	dc.w 48,128,23
; b
	dc.w 56,128,25
; c
	dc.w 64,128,18
; d
	dc.w 72,128,26
; e
	dc.w 0,192,21
; f
	dc.w 8,192,17
; g
	dc.w 16,192,27
; h
	dc.w 24,192,30
; i
	dc.w 32,192,14
; j
	dc.w 40,192,14
; k
	dc.w 48,192,30
; l
	dc.w 56,192,14
; m
	dc.w 64,192,45
; n
	dc.w 72,192,29
; o
	dc.w 0,256,22
; p
	dc.w 8,256,25
; q
	dc.w 16,256,26
; r
	dc.w 24,256,20
; s
	dc.w 32,256,16
; t
	dc.w 40,256,16
; u
	dc.w 48,256,25
; v
	dc.w 56,256,24
; w
	dc.w 64,256,35
; x
	dc.w 72,256,24
; y
	dc.w 0,320,30
; z
	dc.w 8,320,21
; 1
	dc.w 16,320,16
; 2
	dc.w 24,320,22
; 3
	dc.w 32,320,21
; 4
	dc.w 40,320,26
; 5
	dc.w 48,320,22
; 6
	dc.w 56,320,23
; 7
	dc.w 64,320,23
; 8
	dc.w 72,320,25
; 9
	dc.w 0,384,23
; 0
	dc.w 8,384,23
; ,
	dc.w 16,384,8
; .
	dc.w 24,384,8
; !
	dc.w 32,384,10
; ?
	dc.w 40,384,18
; ~
	dc.w 48,384,13
; (
	dc.w 56,384,13
; )
	dc.w 64,384,13
; '
	dc.w 72,384,8

Check_adr:
	dc.w 0*2,1*2,2*2,3*2,4*2,5*2,6*2,7*2
	dc.w 1*2,2*2,3*2,4*2,5*2,6*2,7*2,8*2
	dc.w 2*2,3*2,4*2,5*2,6*2,7*2,8*2,7*2
	dc.w 3*2,4*2,5*2,6*2,7*2,8*2,7*2,6*2
	dc.w 4*2,5*2,6*2,7*2,8*2,7*2,6*2,5*2
	dc.w 5*2,6*2,7*2,8*2,7*2,6*2,5*2,4*2
	dc.w 6*2,7*2,8*2,7*2,6*2,5*2,4*2,3*2
	dc.w 7*2,8*2,7*2,6*2,5*2,4*2,3*2,2*2
