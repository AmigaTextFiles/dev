; Listing17g4.s	vertikal und horizontales Copper-Masking
; ANZEIGEN EINES BILDES IN 320*256 mit 1 Plane (2 Farben)
; als 16x16-Raster 


 SECTION CIPundCOP,CODE

Anfang:
	move.l	4.w,a6				; Execbase in a6
	jsr	-$78(a6) 				; Disable - stoppt das Multitasking
	lea	GfxName(PC),a1			; Adresse des Namen der zu öffnenden Lib in a1
	jsr	-$198(a6)				; OpenLibrary, Routine der EXEC
	move.l	d0,GfxBase			; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop		; hier speichern wir die Adresse der Copperlist
								; des Betriebssystemes (immer auf $26 nach GfxBase)

;******************************************************************************
;HIER LASSEN WIR UNSERE BPLPOINTERS IN DER COPPELIST UNSERE BITPLANES ANPOINTEN
;******************************************************************************

	MOVE.L	#PIC,d0				; in d0 kommt die Adresse von unserer PIC
	LEA	BPLPOINTERS,A1			; in a1 kommt die Adresse der Bitplane-Pointer der Copperlist
	MOVEQ	#1-1,D1				; Anzahl der Bitplanes 0 (hier ist es 1)
POINTBP:
	move.w	d0,6(a1)			; niederwertige Word der Plane-Adresse
	swap	d0					; vertauscht die 2 Word in d0 (Z.B.: 1234 > 3412)			     
	move.w	d0,2(a1)			; hochwertige Word der Adresse des 			      
	swap	d0					; orginale Adresse wieder hergestellt
	ADD.L	#40*256,d0			; Zählen 10240 zu D0 dazu, nächste Bitplane
	addq.w	#8,a1				; Adresse der nächsten bplpointers in der Copperlist
	dbra	d1,POINTBP			; Wiederhole D1 mal POINTBP (D1=num of bitplanes)


	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP					
	move.w	d0,$dff088			; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc			; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106		; BPLCON3 - Deaktiviert das AGA
	
mouse:	
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse				; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080 	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088			; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)				; Enable - stellt Multitasking wieder her
	move.l	GfxBase(PC),a1		; Basis der Library, die es zu schließen gilt
								; (Libraries werden geöffnet UND geschlossen!)
	jsr	-$19e(a6)				; Closelibrary - schließt die Graphics lib
	rts

GfxName:
	dc.b	"graphics.library",0,0	

GfxBase:	     ; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0    ; ab hier werden die Offsets gemacht

OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist
	dc.l	0	; des Betriebssystemes


	SECTION GRAPHIC,DATA_C

PIC:
	incbin	"320x256x1_raster.raw"	; Bild im RAW 1 Bitplane

COPPERLIST:

	; Die Sprites lassen wir auf NULL zeigen, also pointen, um sie zu 
	; eliminieren ansonsten geistern sie umher uns stören uns nur!!!

	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000
	
	dc.w	$8e,$2c81	; DiwStrt	Register mit Standartwerten
	dc.w	$90,$2cc1	; DiwStop	
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	; das BPLCON0 ($dff100) für einen Bildschirm mit 2 Bitplanes: (4 Farben)
				; 5432109876543210
	dc.w	$100,%0001001000000000	; bit 12 an!!		  (1 = %001)	1 Bitplanes: (2 Farben)
	;dc.w	$100,%0010001000000000	; bit 13 an!!		  (2 = %010)	2 Bitplanes: (4 Farben)
	;dc.w	$100,%0011001000000000	; bits 13 und 12 an!! (3 = %011)	3 Bitplanes: (8 Farben)

;	Wir lassen die Bitplanes direkt anpointen, indem wir die Register
;	$dff0e0 und folgende hier in der Copperlist einfügen. Die
;	Adressen der Bitplanes werden dann von der Routine POINTBP
;	automatisch eingetragen

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste	Bitplane - BPL0PT
	;dc.w $e4,$0000,$e6,$0000	; zweite Bitplane - BPL1PT
	;dc.w $e8,$0000,$ea,$0000	; dritte Bitplane - BPL2PT

;	Die 8 Farben des Bildes werden hier definiert:

	dc.w	$0180,$000	; color0
	dc.w	$0182,$FFF	; color1
	;dc.w	$0184,$fff	; color2
	;dc.w	$0186,$ccc	; color3
	;dc.w	$0188,$999	; color4
	;dc.w	$018a,$232	; color5
	;dc.w	$018c,$777	; color6
	;dc.w	$018e,$444	; color7
	
copperpos:	
;------------------------------------------------------------------------------
; 3. vertikale Maske $6c
;------------------------------------------------------------------------------

	dc.w	$1a07,$fffe
	dc.w	$180,$444	; Color0 - grau

	dc.w	$2c07,$fffe	; lasse es weg oder ändere es in dc.w	$2307,$fffe
						; und sehe selbst 
						; der Grund, das maskierte wait wird auch bei
						; $04, $0c, $14, $1c; $24 ausgeführt	
;--- 1. maskiertes wait	----
	dc.w	$6c07,$87fe	; maskiertes wait		; $2c
	dc.w	$180,$f00	; rot
	dc.w	$2f07,$fffe	;
	dc.w	$180,$444	; grau

	dc.w	$00e1,$80FE
;--- 2. maskiertes wait	----
	dc.w	$6c07,$87fe	; maskiertes wait		; $34
	dc.w	$180,$00f	; rot
	dc.w	$3707,$fffe	; Zeile $37
	dc.w	$180,$444	; grau

    dc.w	$00e1,$80FE
;--- 3. maskiertes wait	----
	dc.w	$6c07,$87fe	; maskiertes wait		; $3c
	dc.w	$180,$f00	; rot
	dc.w	$3f07,$fffe	; Zeile $3f
	dc.w	$180,$444	; grau

	dc.w	$00e1,$80FE
;--- 4. maskiertes wait	----
	dc.w	$6c07,$87fe	; maskiertes wait		; $44
	dc.w	$180,$00f	; rot
	dc.w	$4707,$fffe	; Zeile $47
	dc.w	$180,$444	; grau

	dc.w	$00e1,$80FE
;--- 5. maskiertes wait	----
	dc.w	$6c07,$87fe	; maskiertes wait		; $4c
	dc.w	$180,$f00	; rot
	dc.w	$4f07,$fffe	; Zeile $4f
	dc.w	$180,$444	; grau

	dc.w	$00e1,$80FE
;--- 6. maskiertes wait	----
	dc.w	$6c07,$87fe	; maskiertes wait		; $54
	dc.w	$180,$00f	; rot
	dc.w	$5707,$fffe	; Zeile $57
	dc.w	$180,$444	; grau
;------------------------------------------------------------------------------

	dc.w	$ffff,$fffe	; Ende der Copperlist

	end


Beispiele:

;------------------------------------------------------------------------------
; 1. horizontale Maske
;------------------------------------------------------------------------------

	dc.w	$40c1,$ff7e	;				; $10 ; $18 ; $90	; $98
	dc.w	$180,$f00	; rot
	
	dc.w	$40c1,$ff7e	;
	dc.w	$180,$444	; grau

	dc.w	$4091,$fffe	;
	dc.w	$180,$444	; grau

	dc.w	$40c1,$ff7e	;				; $10 ; $18 ; $90	; $98
	dc.w	$180,$f00	; rot
	
	dc.w	$40c1,$ff7e	;
	dc.w	$180,$444	; grau


;--- Alle horizontalen maskierten Positionen ---
;40   01000000   dez= 64
;41   01000001   dez= 65
;C0   11000000   dez= 192
;C1   11000001   dez= 193
;Das sind 4 Treffer.
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
; 2. vertikale Maske $2c
;------------------------------------------------------------------------------

	dc.w	$1a07,$fffe
	dc.w	$180,$444	; Color0 - grau

	dc.w	$2c07,$fffe	; lasse es weg oder ändere es in dc.w	$2307,$fffe
						; und sehe selbst 
						; der Grund, das maskierte wait wird auch bei
						; $04, $0c, $14, $1c; $24 ausgeführt	
;--- 1. maskiertes wait	----
	dc.w	$2c07,$87fe	; maskiertes wait		; $2c
	dc.w	$180,$f00	; rot
	dc.w	$2f07,$fffe	;
	dc.w	$180,$444	; grau

	dc.w	$00e1,$80FE
;--- 2. maskiertes wait	----
	dc.w	$2c07,$87fe	; maskiertes wait		; $34
	dc.w	$180,$00f	; rot
	dc.w	$3707,$fffe	; Zeile $37
	dc.w	$180,$444	; grau

    dc.w	$00e1,$80FE
;--- 3. maskiertes wait	----
	dc.w	$2c07,$87fe	; maskiertes wait		; $3c
	dc.w	$180,$f00	; rot
	dc.w	$3f07,$fffe	; Zeile $3f
	dc.w	$180,$444	; grau

	dc.w	$00e1,$80FE
;--- 4. maskiertes wait	----
	dc.w	$2c07,$87fe	; maskiertes wait		; $44
	dc.w	$180,$00f	; rot
	dc.w	$4707,$fffe	; Zeile $47
	dc.w	$180,$444	; grau

	dc.w	$00e1,$80FE
;--- 5. maskiertes wait	----
	dc.w	$2c07,$87fe	; maskiertes wait		; $4c
	dc.w	$180,$f00	; rot
	dc.w	$4f07,$fffe	; Zeile $4f
	dc.w	$180,$444	; grau

	dc.w	$00e1,$80FE
;--- 6. maskiertes wait	----
	dc.w	$2c07,$87fe	; maskiertes wait		; $54
	dc.w	$180,$00f	; rot
	dc.w	$5707,$fffe	; Zeile $57
	dc.w	$180,$444	; grau
;------------------------------------------------------------------------------

Maskieren = ausblenden, verdecken

Mit der Maske bleiben bestimmte Bitpositionen unberücksichtigt. Nur, die Bits
die in den VP und HP-Bitfeldern auf 1 eingestellt sind werden berücksichtigt.

Bei jeder Gleichheit von Strahlposition zur maskierten Wait-Position wird der
Wait ausgeführt egal ob die Strahlposition gleich oder größer der 
eingestellten Wait-Position ist.

Wer es nicht glaubt ersetzt das $2c z.B. durch $6c. Das würde das Wait vertikal
nach unten verschieben. Die maskierten waits bleiben aber gleich.

;------------------------------------------------------------------------------
; 3. vertikale Maske $6c
;------------------------------------------------------------------------------

	dc.w	$1a07,$fffe
	dc.w	$180,$444	; Color0 - grau

	dc.w	$6c07,$fffe	; lasse es weg oder ändere es in dc.w	$2307,$fffe
						; und sehe selbst 
						; der Grund, das maskierte wait wird auch bei
						; $04, $0c, $14, $1c; $24 ausgeführt	
;--- 1. maskiertes wait	----
	dc.w	$6c07,$87fe	; maskiertes wait		; $2c
	dc.w	$180,$f00	; rot
	dc.w	$2f07,$fffe	;
	dc.w	$180,$444	; grau

	dc.w	$00e1,$80FE
;--- 2. maskiertes wait	----
	dc.w	$6c07,$87fe	; maskiertes wait		; $34
	dc.w	$180,$00f	; rot
	dc.w	$3707,$fffe	; Zeile $37
	dc.w	$180,$444	; grau

    dc.w	$00e1,$80FE
;--- 3. maskiertes wait	----
	dc.w	$6c07,$87fe	; maskiertes wait		; $3c
	dc.w	$180,$f00	; rot
	dc.w	$3f07,$fffe	; Zeile $3f
	dc.w	$180,$444	; grau

	dc.w	$00e1,$80FE
;--- 4. maskiertes wait	----
	dc.w	$6c07,$87fe	; maskiertes wait		; $44
	dc.w	$180,$00f	; rot
	dc.w	$4707,$fffe	; Zeile $47
	dc.w	$180,$444	; grau

	dc.w	$00e1,$80FE
;--- 5. maskiertes wait	----
	dc.w	$6c07,$87fe	; maskiertes wait		; $4c
	dc.w	$180,$f00	; rot
	dc.w	$4f07,$fffe	; Zeile $4f
	dc.w	$180,$444	; grau

	dc.w	$00e1,$80FE
;--- 6. maskiertes wait	----
	dc.w	$6c07,$87fe	; maskiertes wait		; $54
	dc.w	$180,$00f	; rot
	dc.w	$5707,$fffe	; Zeile $57
	dc.w	$180,$444	; grau
;------------------------------------------------------------------------------

Die Anwendung von maskierten Waits ist es, wie schon gesehen, es in
Copperschleifen zu verwenden. (z.B. in allen geraden Zeilen oder in bestimmten
Abständen.)

dc.w $0001,$80fe	; wait for the next scanline, unabhängig von vertikaler Position
dc.w $2c07,$fffe 	; wait bestimmte vertikale und horizontale Position
dc.w $2c07,$ff00	; wait bestimmte vertikale Position, ignoriere horizontale Position