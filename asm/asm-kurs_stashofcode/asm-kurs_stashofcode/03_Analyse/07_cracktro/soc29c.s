
; soc29c.s - Erstellung der Copperliste 0

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

; *************** PARAMETERS DES SCREEN 1 ***************

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

; *************** PARAMETERS DES SCREEN (2) ***************

DisplayY=SizeY0+SizeY1/2			; Höhe des anzuzeigenden Bildes bei ...
									; ... ab StartY

StopY=DisplayY+StartY-256			; sichtbares vertikales Ende des Bildes

; ***************

FontHeight=64
MEMF_CHIP=$2

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


start:
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


; ----- Initialisierung -----

	bsr Init

	rts


	; *************** INITIALISIERUNG ***************

Init:

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

	move.l Cop1_adr,d0					; Copperpointer auf Copperlist 1 setzen
	move.w #$0082,(a0)+					; COP1LCL
	move.w d0,(a0)+
	move.w #$0080,(a0)+					; COP1LCH
	swap d0
	move.w d0,(a0)+

	move.l #$FFFFFFFE,(a0)
	
	rts
	

Screen0_adr:		dc.l $11223344
Screen0Buffer_adr:	dc.l 0
Screen1_adr:		dc.l 0
Cop0_adr:			dc.l 0
Cop1_adr:			dc.l 0

	end

