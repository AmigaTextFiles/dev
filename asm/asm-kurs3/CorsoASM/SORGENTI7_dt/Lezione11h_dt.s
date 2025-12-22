
; Lezione11h.s	Verwenden von COP2LC ($dff084), um eine dynamische copperliste zu erstellen,
		; Das ist eine copperliste, die bei jedem Frame zwischen 2 copperlisten wechselt
		; um die Glaubwürdigkeit eine Nuance "zu erhöhen".
		; Rechtsklick, um den Unterschied zu sehen!

	SECTION	DynaCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s" ; speichern Sie Interrupt, DMA und so weiter.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; nur copper und bitplane DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:
;	Zeiger auf unsere BITPLANE

	MOVE.L	#BITPLANE,d0
	LEA	BPLPOINTERS,A1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Zeiger alle Sprites auf das Sprite null

	MOVE.L	#SpriteNullo,d0		; Adresse von sprite in d0
	LEA	SpritePointers,a1		; Zeiger in copperlist
	MOVEQ	#8-1,d1				; alle 8 sprite
NulLoop:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	addq.w	#8,a1
	dbra	d1,NulLoop

	bsr.w	InitCops	; Erstelle die 2 copperlisten zum "Tauschen"

	lea	$dff000,a6
	MOVE.W	#DMASET,$96(a6)		; DMACON - aktivieren bitplane, copper		
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A6),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $130 (304)
	BNE.S	Waity1

	btst	#2,$16(a6)	; richtige Taste gedrückt?
	beq.s	NonSwappare	; Wenn nicht tauschen (netter Unsinn!)

	movem.l	CoppPointer1(PC),d0-d1	; Stellen Sie die Adressen von den 2 copperlisten 
									; in d0 und in d1 mit nur einem MOVEM ein
	move.l	d0,CoppPointer2			; Ordnung umtauschen ...
	move.l	d1,CoppPointer1			; ...
	move.w	d1,Cop2lcl		; Und schreiben Sie die andere copperliste2
	swap	d1				; als nächstes zu springen
	move.w	d1,Cop2lch		; die COPJMP2 ($dff08a)
nonSwappare:

	bsr.w	PrintCarattere	; Drucken Sie jeweils ein Zeichen

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; warte auf Zeile $130 (304)
Aspetta:
	MOVE.L	4(A6),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse
	rts					; exit


CoppPointer1:
		dc.l	ColInt1
CoppPointer2:
		dc.l	ColInt2

*****************************************************************************
* Routine, die die 2 copperlisten erstellt, die angezeigt werden sollen		*
* abwechselnd auf COP2LC zeigen und mit COPJMP2 starten					    *
*****************************************************************************

;	  _________________
;	 /                 \
;	 \   ___     ___   /
;	__\  (__)   (__)  /__
;	\__\___  ` '  ___/__/
;	     \ \...../ /
;	      \_______/g®m


COLSTART	EQU	$660	; Startfarbe = gelb
COLTENDENZA	EQU	$001	; Trend (Mehrwert bei jedem Wait)

InitCops:
	move.l	#$4407fffe,d0	; Wait - Beginne mit der horizontalen Linie $44
	move.l	#$1800000,d1	; Color0
	move.w	#COLSTART,d2	; Color beim Start
	move.w	#COLTENDENZA,d3	; Zieltrend ($001/$010/$100)
	moveq	#2-1,d5			; 2 Copperlist zu tun
	lea	ColInt1,a1			; erste Copperlist
makecop:
	move.w	d2,d1		; Kopie colstart in d1 (in $180xxxx!)
	move.l	d0,(a1)+	; Setzen des WAIT in coplist
	move.l	d1,(a1)+	; Setzen des $180xxxx (color0) in coplist
	add.l	#$05000000,d0	; wait 5 Zeilen unter dem nächsten Mal
	move.l	d0,(a1)+	; Setzen wait
	move.l	d1,(a1)+	; Setzen des $180xxxx (color0)
	add.l	#$05000000,d0	; wait 5 Zeilen weiter unten
	move.w	d2,d4		; Kopie des colstart in d4
	and.w	#$00f,d4	; Wählen Sie nur die BLAUE Komponente
	cmp.w	#$00f,d4	; ist es maximal?
	beq.S	endcop		; wenn ja, endcop!
	move.w	d2,d4		; Ansonsten sehen wir das Grün:
	and.w	#$0f0,d4	; Wählen Sie nur die grüne Komponente.
	cmp.w	#$0f0,d4	; ist es maximal?
	beq.S	endcop		; wenn ja, endcop!
	move.w	d2,d4
	and.w	#$f00,d4	; Wählen Sie nur die rote Komponente.
	cmp.w	#$f00,d4	; ist es maximal?
	beq.S	endcop		; wenn ja, ENDCOP!
	add.w	d3,d2		; COLTENDENZA zu COLORSTART hinzufügen
	bra.S	makecop		; Und es geht weiter...
endcop:
	move.l	#$fffffffe,d0	; Ende copperlist in d0
	move.w	d2,d1		; Kopie COLORSTART in d1
	move.l	d0,(a1)+	; Ende copperlist
	move.l	#$4907fffe,d0
	move.l	#$1800000,d1
	move.w	#COLSTART,d2
	move.w	#COLTENDENZA,d3
	lea	ColInt2,a1
	dbf	d5,makecop
	rts


*****************************************************************************
;			Druck Routine 
*****************************************************************************

PRINTcarattere:
	movem.l	d2/a0/a2-a3,-(SP)
	MOVE.L	PuntaTESTO(PC),A0	; Adresse des zu druckenden Textes in a0
	MOVEQ	#0,D2				; löschen d2
	MOVE.B	(A0)+,D2			; Nächstes Zeichen in d2
	CMP.B	#$ff,d2				; Ende des Textsignals? ($FF)
	beq.s	FineTesto			; Wenn ja, beenden Sie ohne zu drucken
	TST.B	d2					; Zeilenende-Signal? ($00)
	bne.s	NonFineRiga			; Wenn nicht, nicht einpacken

	ADD.L	#40*7,PuntaBITPLANE	; Gehen wir zum Kopf
	ADDQ.L	#1,PuntaTesto		; erste Zeichenzeile nach
								; (überspringe die NULL)
	move.b	(a0)+,d2			; erstes Zeichen der Zeile nach
								; (überspringe die NULL)

NonFineRiga:
	SUB.B	#$20,D2		; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG
						; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
						; (Das $20 entspricht), IN $00, DAS
						; AUSRUFUNGSZEICHEN ($21) IN $01...
	LSL.W	#3,D2		; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
						; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D2,A2
	ADD.L	#FONT,A2	; FINDEN SIE DAS GEWÜNSCHTE ZEICHEN IN DER SCHRIFTART...

	MOVE.L	PuntaBITPLANE(PC),A3 ; Adresse der Ziel-Bitplane in a3

				; WIR DRUCKEN DAS ZEILENZEICHEN ZEILENWEISE
	MOVE.B	(A2)+,(A3)	; Drucke Zeile 1 des Zeichens
	MOVE.B	(A2)+,40(A3)	; Drucke Zeile 2  " "
	MOVE.B	(A2)+,40*2(A3)	; Drucke Zeile 3  " "
	MOVE.B	(A2)+,40*3(A3)	; Drucke Zeile 4  " "
	MOVE.B	(A2)+,40*4(A3)	; Drucke Zeile 5  " "
	MOVE.B	(A2)+,40*5(A3)	; Drucke Zeile 6  " "
	MOVE.B	(A2)+,40*6(A3)	; Drucke Zeile 7  " "
	MOVE.B	(A2)+,40*7(A3)	; Drucke Zeile 8  " "

	ADDQ.L	#1,PuntaBitplane ; wir bewegen uns 8 Bits vorwärts (NÄCHSTER ZEICHEN)
	ADDQ.L	#1,PuntaTesto	; nächstes zu druckendes Zeichen

FineTesto:
	movem.l	(SP)+,d2/a0/a2-a3
	RTS


PuntaTesto:
	dc.l	TESTO

PuntaBitplane:
	dc.l	BITPLANE

;	$00 für "Zeilenende" - $ FF für "Textende"

		; Anzahl der Zeichen pro Zeile: 40
TESTO:	     ;		  1111111111222222222233333333334
             ;   1234567890123456789012345678901234567890
	dc.b	'                                        ',0 ; 1
	dc.b	'    Questo listato utilizza il COP2LC   ',0 ; 2
	dc.b	'                                        ',0 ; 3
	dc.b	'    ($dff084) per far saltare, ad una   ',0 ; 4
	dc.b	'                                        ',0 ; 5
	dc.b	'    certa linea video, ad un altra      ',0 ; 6
	dc.b	'                                        ',0 ; 7
	dc.b	'    copperlist. Al termine di questa    ',0 ; 8
	dc.b	'                                        ',0 ; 9
	dc.b	'    riparte sempre e comunque la        ',0 ; 10
	dc.b	'                                        ',0 ; 11
	dc.b	'    copperlist 1 (in $dff180). Dunque   ',0 ; 12
	dc.b	'                                        ',0 ; 13
	dc.b	'    basta cambiare solo la cop2 a cui   ',0 ; 14
	dc.b	'                                        ',0 ; 15
	dc.b	'    puntare ogni frame, per DynamiCop!  ',0 ; 16
	dc.b	'                                        ',0 ; 17
	dc.b	'    Il tasto destro ferma lo scambio.   ',$FF ; 18

	EVEN

; Die FONT-Zeichen 8x8 (im CHIP von der CPU und nicht vom Blitter kopiert,)
; So kann es auch im FAST RAM sein. In der Tat wäre es besser!

FONT:
	incbin	"assembler2:sorgenti4/nice.fnt"

****************************************************************************

	Section	copperDynamic,data_C

copperlist:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod
				; 5432109876543210
	dc.w	$100,%0001001000000000	; 1 bitplane LOWRES 320x256

BPLPOINTERS:
	dc.w $e0,0,$e2,0		; erste	 bitplane

	dc.w	$180,COLSTART	; COLOR0 - colore "Anfang"
	dc.w	$182,$FF0		; color1 - Schrift

;	dc.w	$2ce1,$fffe	; Wait mindestens Y=$2c X=$d7

	dc.w	$84			; Register COP2LCH (Adresse copper 2!)
COP2LCH:
	dc.w	0
	dc.w	$86			; Register COP2LCL
COP2LCL:
	dc.w	0

	dc.w	$8a,$000	; COPJMP2 - Starte copperliste 2

****************************************************************************

; Platz für die copperlist 1

ColInt1:
	dcb.l	2*60,0

****************************************************************************

; Platz für die copperlist 2

ColInt2:
	dcb.l	2*60,0


*****************************************************************************

	SECTION	MIOPLANE,BSS_C

BITPLANE:
	ds.b	40*256		; bitplane lowres 320x256

SpriteNullo:			; Null-Sprite-Zeiger in copperlist
	ds.l	4			; in nicht verwendeten Zeigern

	END

