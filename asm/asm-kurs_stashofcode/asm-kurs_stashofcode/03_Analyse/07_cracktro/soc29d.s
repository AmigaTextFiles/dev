
; soc29d.s
; zeigt den blauen Farbbalken und den Hires, Lace Schriftzug

; Code von Yragael für Maximilian / Paradox

	section prg,code_c
	include "short_registers.s"
	include "exec_lib.i"

; *************** PARAMETER DES SCREENS (1) ***************

StartX=129							; horizontaler Start des Plots
StartY=50							; vertikaler Start des Plots

; *************** PARAMETER DES SCREENS 0 ***************

NbPlane0=5
;SizeX0=320
SizeY0=160

;TraceX0=320						; Breite des zu plottenden Bildes bei ...
									; ... von StartX aus

DisplayX0=320						;  Breite des zu betrachtenden Bildes bei ...
									; ... von StartDisplayX aus.

StartDisplayX0=129					; sichtbarer horizontaler Anfang des Bildes.

StopX0=DisplayX0+StartDisplayX0-256	; sichtbares horizontales Ende des Bildes 

;DDF_Strt0=(StartX-17)/2 
;DDF_Stop0=DDF_Strt0+(TraceX0/2-8)

;ModuloPair0=(SizeX0-TraceX0)/8
;ModuloImpair0=(SizeX0-TraceX0)/8

;PlaneSize0=SizeY0*SizeX0/8

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


PlaneSize1=SizeY1*SizeX1/8

; *************** PARAMETERS DES SCREEN (2) ***************

DisplayY=SizeY0+SizeY1/2			; Höhe des anzuzeigenden Bildes ...
									; ... ab StartY

StopY=DisplayY+StartY-256			; sichtbares vertikales Ende des Bildes

; *************** KONSTANTEN ***************

;BobSizeX=16*16
;BobSizeY=8
;ScrollHeight=12
;FontWidth=64
FontHeight=64
;SpaceWidth=16						; Wert in Pixel des Zeichens SpaceWidth
;DeltaChar=4						; Pixelwert der SpaceWidth zwischen zwei Buchstaben
;fontSizeX=640
;CentreZ=510
;DeltaX=1
;DeltaY=2
;DeltaZ=1
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

;WAITBLIT:	macro
;Wait_Blit0\@
;		btst #14,DMACONR(a5)
;		bne Wait_Blit0\@
;Wait_Blit1\@
;		btst #14,DMACONR(a5)
;		bne Wait_Blit1\@
;		endm

; ----- warte auf VBL -----

WAITVBL:	macro
Wait_VBL\@
		cmp.b #$FF,VHPOSR(a5)
		bne Wait_VBL\@
		endm


; ----- Register sichern -----

	movem.l d0-d7/a0-a6,-(sp)

; ----- Initialisierung -----

	bsr Init

; ----- Initialisierung Musik -----



; ----- credits -----

	lea Credits_adr,a1							; lädt die Adresse des Labels (nicht dessen Wert)
	movea.l Screen1_adr,a0						; lädt den Wert an der Adresse des Labels
	add.w #(SizeY1-8)*NbPlane1*SizeX1/8,a0		; (92-8)*1*(704/8)=7392 = $1CE0 (Offset addieren) zur Bitplaneadresse
Credits_Loop:
	moveq #0,d1							; d1 zurücksetzen
	move.b (a1)+,d1						; nächstes Textzeichen 
	cmp.b #$1B,d1						; wenn Endemarkierung
	beq Credits_End						; dann springe zum Ende
	subi.b #$20,d1						; -$20, wegen ASCII Zeichen im Font
	lsl.w #3,d1							; *8, weil das Zeichen 8 Bytes groß ist
	movea.l a0,a2						; Adresse wo der Text gedruckt werden soll
	lea Font8_adr,a3					; Anfangsadresse des Fonts
	add.w d1,a3							; den Offset des Zeichens dazu addieren
	rept 8								; 8 * wiederholen, weil ein Zeichen 8 Zeilen hat
	move.b (a3)+,(a2)					; die einzelnen Zeilen des Zeichens drucken
	lea NbPlane1*SizeX1/8(a2),a2		; Adresse um 1*(704/8)=88 Bytes erhöhen
	endr
	addq.w #1,a0						; nächstes Zeichen
	jmp Credits_Loop					; in der Schleife bleiben, bis Ende Zeichen erkannt wird
Credits_End:


; ------ Hauptprogramm ------

Main_Loop:
	WAITVBL

; ----- Maustest -----

	btst #6,$bfe001
	bne Main_Loop

	bsr End

; ----- Register wiederherstellen -----

	movem.l (sp)+,d0-d7/a0-a6

	rts


	; *************** INITIALISIERUNG ***************

Init:
	; -----Speicherreservierung screen 0 -----

	;move.l #NbPlane0*PlaneSize0,d0
	;move.l #MEMF_CHIP+MEMF_CLEAR,d1
	;CALLEXEC AllocMem
	;move.l d0,Screen0_adr

; ----- Speicherreservierung screen buffer 0 -----

	;move.l #(NbPlane0-1)*PlaneSize0,d0
	;move.l #MEMF_CHIP+MEMF_CLEAR,d1
	;CALLEXEC AllocMem
	;move.l d0,Screen0Buffer_adr

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

	move.w #$008E,(a0)+					; DIWSTRT		dc.w $008E,$3281
	move.w #StartY*256+StartDisplayX0,(a0)+
	move.w #$0090,(a0)+					; DIWSTOP		dc.w $0090,$00c1
	move.w #StopY*256+StopX0,(a0)+
	move.w #$0100,(a0)+					; BPLCON0		dc.w $0100,$0200
	move.w #$200,(a0)+	
	
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
		
	move.w #$008E,(a0)+					; DIWSTRT		dc.w $008E,$3281
	move.w #StartY*256+StartDisplayX0,(a0)+
	move.w #$0090,(a0)+					; DIWSTOP		dc.w $0090,$00c1
	move.w #StopY*256+StopX0,(a0)+
	move.w #$0100,(a0)+					; BPLCON0		dc.w $0100,$0200
	move.w #$200,(a0)+	
	
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
	addi.l #SizeX1/8,d0					; DAS IST DER EINZIGE UNTERSCHIED ZWISCHEN BEIDEN COPPERLISTEN (INTERLACE)
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
	;WAITBLIT

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

	;movea.l Screen0_adr,a1
	;move.l #NbPlane0*PlaneSize0,d0
	;CALLEXEC FreeMem

; ----- Speicherfreigabe screen buffer 0 -----

	;movea.l Screen0Buffer_adr,a1
	;move.l #(NbPlane0-1)*PlaneSize0,d0
	;CALLEXEC FreeMem

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



Vectors_end:	rte
Vectors_bak:	blk.l $2E
DMACON_bak:	dc.w 0
INTENA_bak:	dc.w 0
;Color_adr:	blk.w 31
;Screen0_adr:	dc.l 0
;Screen0Buffer_adr:	dc.l 0
Screen1_adr:	dc.l 0
;AngleX:		dc.w 0
;AngleY:		dc.w 0
;AngleZ:		dc.w 0
Cop0_adr:	dc.l 0
Cop1_adr:	dc.l 0
;Coor2D_adr:	blk.w CoorSize
;Module_adr:	incbin "mod.hold_of_fame.pc"
;Bob_adr:	incbin "square-half.raw"
Font8_adr:	incbin "logo.fnt"
;Font_adr:	incbin "coma-med.raw"
Credits_adr:	incbin "credits.txt"
	even
;Text_adr:	incbin "propor.scrl"
	dc.b 0
	even
GFX_name:	dc.b 'graphics.library',0
	even



