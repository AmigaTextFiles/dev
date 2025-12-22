
; soc29g.s
; Scrolltext

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


;BobSizeX=16*16
;BobSizeY=8
ScrollHeight=12
FontWidth=64
FontHeight=64
SpaceWidth=16						; Wert in Pixel des Zeichens SpaceWidth
DeltaChar=4							; Pixelwert der Freiraum zwischen zwei Buchstaben
fontSizeX=640
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

; ----- Register sichern -----

	movem.l d0-d7/a0-a6,-(sp)

; ----- Initialisierung -----

	bsr Init

; ------ Initialisierung der Parameter ------

	lea Text_adr,a4							; Zeiger auf Scrolltext
	movea.l Screen0Buffer_adr,a0			; Zeiger auf Screen0Buffer
	;move.w #2*(360-DeltaX),AngleX
	;move.w #2*(360-DeltaY),AngleY
	;move.w #2*(360-DeltaZ),AngleZ
	moveq #0,d0								; Startwert für Scrolltext
	move.w d0,-(sp)							; Wert wird in Scrolltext-Routine abgefragt


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

	; bsr module_adr+24

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
	
	; Scroll über den gesamten Bildschirm - Blitt mit Verschiebung

	movea.l Screen1_adr,a1			; Anfangsadresse Bitplane
	add.w #(ScrollHeight+FontHeight)*NbPlane1*SizeX1/8-2,a1	; Offset 
	moveq #2,d1						; Scrollgeschwindigkeit		$0002 = BSH2
	ror.w #4,d1						;							$2000
	bset #1,d1						; mode descending			$2002
	move.w d1,BLTCON1(a5)			; $2002		
	move.w #%0000010111001100,BLTCON0(a5) ; $05CC - Kanal B und D, D=B
	move.w #$0000,BLTDMOD(a5)		; BLTDMOD = 0
	move.w #$0000,BLTBMOD(a5)		; BLTBMOD = 0
	move.l a1,BLTBPTH(a5)			; Quelle - Kanal B
	move.l a1,BLTDPTH(a5)			; Ziel - Kanal D
	move.w #SizeX1/16+64*FontHeight*NbPlane1,BLTSIZE(a5) ; (640+64)/16=44 Wörter Breite 64*1=Zeilen Höhe

; ----- Buchstabenanzeige -----

	move.w (sp)+,d0					; Breite-Wert nach d0
	dbf d0,Scroll_End				; solange wie Breite-Wert >=0 ist, dann zum Ende springen

Scroll_NextChar:
	move.b (a4)+,d1					; aktuelles Byte (Charakter) lesen
	bne Scroll_CharOK				; wenn Charakter nicht Null, Zeichen lesen
	lea Text_adr,a4					; ansonsten, Anfangsadresse des Scrolltextes wieder von vorn
	bra Scroll_NextChar				; unbedingter Sprung zurück
Scroll_CharOK:

	cmp.b #$20,d1					; $20 ist der ASCII-Abstand (das Leerzeichen)
	bne Scroll_NoSpace				; wenn es kein Leerzeichen ist, dann überspringen	
	moveq #SpaceWidth/2,d0			; scrollspeed=2			(16/2=8)
	
; dieser Blitt "druckt" das Zeichen (Space) welches reingescrollt wird, löscht also	
	
	movea.l Screen1_adr,a2			; Anfangsadresse Bitplane
	add.w #ScrollHeight*NbPlane1*SizeX1/8+(SizeX1-FontWidth)/8,a2		; 12*1*(640+64)/8+((640+64)-64)/8=1136
	WAITBLIT
	move.w #%0000000111001100,BLTCON0(a5)	; $01CC - Kanal D=B
	move.w #$0000,BLTCON1(a5)		; keine Sondermodi
	move.w #$0000,BLTBDAT(a5)		; BLTBDAT - fester Wert $0
	move.l a2,BLTDPTH(a5)			; Ziel - Kanal D
	move.w #(SizeX1-FontWidth)/8,BLTDMOD(a5)	; BLTDMOD = ((640+64)-64)/8=80 - eine Zeile, wegen hires
	move.w #FontWidth/16+64*NbPlane1*FontHeight,BLTSIZE(a5)	; 64/16=4 Wörter Breite und 64*1 Zeilen
	bra Scroll_End					; zum Ende springen
Scroll_NoSpace:						; wenn hier wird ein neues Zeichen gedruckt

	lea AlphaData_adr,a1			; Adresse Feld mit Reihenfolge der Zeichen
	moveq #-6,d2					; d2 mit -6 laden		
Scroll_SearchChar:
	addq.w #6,d2					; d2 ist der Offset um das Zeichen in Alpha_adr zu finden dc.w x,x,x (6 Bytes oder 3 Wörter)
	cmp.b (a1)+,d1					; mit aktuellen Zeichen vergleichen, in d1 ist das aktuelle Zeichen
	bne Scroll_SearchChar			; wenn nicht Null, dann zurückspringen (solange bis das Zeichen gefunden wurde)
	lea Alpha_adr,a1				; ansonsten, Anfangsadresse der Zeichen 
									; (Byte horizontale Position, Zeile, Breite in Bits)
	move.w 2(a1,d2.w),d1			; die Zeile des Zeichens in d1
	lsl.w #4,d1						; Zeile * 16 	
	move.w d1,d3					; Kopie in d3
	lsl.w #2,d3						; 16 * 4 = 64
	add.w d3,d1						; d1=d1+d3	=> d1=(Zeile*16)+64
	add.w (a1,d2.w),d1				; d1=d1 + Anfangsadresse Zeichen + horizontale Position

	move.w 4(a1,d2.w),d0			; Anfangsadresse der Zeichen + Offset+4 = Breite in Bits
	add.w #DeltaChar,d0				; Pixelwert der Freiraum zwischen zwei Buchstaben
	lsr.w #1,d0						; Breite/2 wegen Scrollgeschwindigkeit = 2
	subq.w #1,d0					; (Breite/2)-1

	lea Font_adr,a1					; Anfangsadresse Font
	add.w d1,a1						; ermittelten Offset hinzuaddieren
	movea.l Screen1_adr,a2			; Anfangsadresse Bitplane
	lea ScrollHeight*NbPlane1*SizeX1/8+(SizeX1-FontWidth)/8(a2),a2	; 12*1*(640+64)/8+((640+64)-64)/8=1136
	WAITBLIT

; Zeichen reinkopieren
	move.w #%0000010111001100,BLTCON0(a5)	; $05CC - Kanal B und D, D=B
	move.w #$0000,BLTCON1(a5)		; keine Sondermodi
	move.l a1,BLTBPTH(a5)			; Quelle - Kanal D
	move.l a2,BLTDPTH(a5)			; Ziel - Kanal D
	move.w #(fontSizeX-FontWidth)/8,BLTBMOD(a5) ; BLTBMOD = (640-64)/8=72 - eine Zeile
	move.w #(SizeX1-FontWidth)/8,BLTDMOD(a5)	; BLTDMOD = ((640+64)-64)/8=80 - eine Zeile
	move.w #FontWidth/16+64*NbPlane1*FontHeight,BLTSIZE(a5)	; 64/16=4 Wörter Breite und 64*1 Zeilen

Scroll_End:
	move.w d0,-(sp)					; xxx-Wert von d0 auf dem Stack speichern

	; ------ löscht den Arbeitsplanebuffer ------

	WAITBLIT
	move.w #20,BLTDMOD(a5)			; BLTDMOD 20 bytes
	move.w #$0000,BLTCON1(a5)		; keine Sondermodi
	move.w #%0000000100000000,BLTCON0(a5)	; nur Kanal D
	lea 10(a0),a1					; 
	move.l a1,BLTDPTH(a5)			; Ziel - Kanal D - Bitplane
	move.w #SizeX0/16-10+64*SizeY0*(NbPlane0-1)/2,BLTSIZE(a5)	; 320/16-10+64*160*(5-1)/2=10 Wörter und 320 Zeilen
																; $500a	

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

Vectors_end:	rte
Vectors_bak:	blk.l $2E
DMACON_bak:	dc.w 0
INTENA_bak:	dc.w 0
Color_adr:	blk.w 31
Screen0_adr:	dc.l 0
Screen0Buffer_adr:	dc.l 0
Screen1_adr:	dc.l 0
;AngleX:		dc.w 0
;AngleY:		dc.w 0
;AngleZ:		dc.w 0
Cop0_adr:	dc.l 0
Cop1_adr:	dc.l 0
;Coor2D_adr:	blk.w CoorSize
;Module_adr:	incbin "mod.hold_of_fame.pc"
;Bob_adr:	incbin "square-half.raw"
;Font8_adr:	incbin "logo.fnt"
Font_adr:	incbin "coma-med.raw"
Credits_adr:	incbin "credits.txt"
	even
Text_adr:	incbin "propor.scrl"
		dc.b 0
	even
GFX_name:	dc.b 'graphics.library',0
	even

	dc.b 0


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

; Byte horizontale Position, Zeile, Breite in Bits

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