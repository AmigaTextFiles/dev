
; soc29b.s
; zeigt den Text - credits - an

; *************** PARAMETER DES SCREENS 1 ***************

StartX=129								; horizontaler Start des Plots	129=$81
StartY=50								; vertikaler Start des Plots	50=$32

NbPlane1=1								; 1
SizeX1=640+64							; 704
SizeY1=64+12+8*2						; 92
TraceX1=640								; Breite des zu plottenden Bildes ...
										; ... von StartX aus

DisplayX1=640							;  Breite des zu betrachtenden Bildes ...
										; ... von StartDisplayX aus.

StartDisplayX1=129						; sichtbarer horizontaler Anfang des Bildes.
										; 129=$81
StopX1=DisplayX1/2+StartDisplayX1-256	; sichtbares horizontales Ende des Bildes  
										; 640/2 + 129-256 = 193 = $c1
DDF_Strt1=(StartX-9)/2					; 129 = $81-9/2=60 = $3c
DDF_Stop1=DDF_Strt1+(TraceX1/4-8)		; $3c+(640/4-8)=$3c+152=212 = $d4

ModuloPair1=(SizeX1-TraceX1)/8+SizeX1/8		; (704-640)/8 + 704/8 = 8+88=96 = $60
ModuloImpair1=(SizeX1-TraceX1)/8+SizeX1/8	; (704-640)/8 + 704/8 = 8+88=96 = $60


	SECTION CiriCop,CODE

Anfang:
	move.l	4.w,a6					; Execbase
	jsr	-$78(a6)					; Disable
	lea	GfxName(PC),a1				; Libname
	jsr	-$198(a6)					; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop			; speichern alte COP

	MOVE.L	#BITPLANE,d0			; Bitplane
	LEA	BPLPOINTERS,A1				; Bitplanepointer in Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	bsr credits

	move.l	#COPPERLIST,$dff080		; unsere COP
	move.w	d0,$dff088				; START COP
	move.w	#0,$dff1fc				; NO AGA!
	move.w	#$c00,$dff106

;waitmouse2:
;	btst	#2,$dff016				; right mousebutton?
;	bne.s	waitmouse2

mainloop:
loop: 
	move.l $dff004,d0
	and.l #$000fff00,d0
	cmp.l #$00010100,d0				; auf Ende des-Rasterdurchlaufs warten
	bne.s loop
	
	; nothing to do here
	
	btst	#6,$bfe001				; linke Maustaste gedrückt?
	bne.s	mainloop	

;------------------------
; exit
	move.l	OldCop(PC),$dff080		; Pointen auf die SystemCOP
	move.w	d0,$dff088				; Starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)					; Enable
	move.l	GfxBase(PC),a1
	jsr	-$19e(a6)					; Closelibrary
	rts

;	Daten
GfxName:
	dc.b	"graphics.library",0,0
GfxBase:
	dc.l	0
OldCop:
	dc.l	0
	
	rts
	
credits:
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

	rts
	

	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$100,$0200			; 0 Bitplanes
;-------
	dc.w	$d201,$fffe			; warten auf Zeile $d2

	dc.w	$100,$9204			; Hires, interlace, 1 Bitplane
	dc.w	$102,0
	dc.w	$104,0

	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$00c1			; DiwStop
	dc.w	$92,$3c				; DdfStart	$38 ; DDF_Strt1
	dc.w	$94,$d4				; DdfStop   $d0 ; DDF_Stop1
	
	dc.w	$108,$60			; Bpl1Mod ModuloPair1
	dc.w	$10a,$60			; Bpl2Mod ModuloImpair1

BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste Bitplane
	
	dc.w	$180,$555			; Color0	; Hintergrund Schwarz
	dc.w	$182,$FFF			; Color1	; Vordergrund (Schrift)

	dc.w	$ffff,$fffe			; Ende der Copperlist
	
bitplane:
	blk.b	20480,$00

Screen1_adr:	
	dc.l bitplane				; hierfür wurde zuvor Speicherplatz angefordert

Credits_adr:	
	incbin "credits.txt"
	even

Font8_adr:	
	incbin "logo.fnt"
	
	end

