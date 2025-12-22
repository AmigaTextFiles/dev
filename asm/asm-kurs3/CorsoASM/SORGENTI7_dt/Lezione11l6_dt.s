
; Lezione11l6.s		Routine Interlaced Mode Management (640x512)
;			der das Bit 15 (LOF) von VPOSR ($dff004) liest.
;			Wenn Sie die rechte Taste drücken, wird diese Prozedur nicht ausgeführt
;			und Sie bemerken, wie die geraden Zeilen oder sogar Zeilen manchmal 
;			seltsam in "pseudo-non-lace" bleiben.

	SECTION	Interlace,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; nur copper und bitplane DMA

WaitDisk	EQU	30

scr_bytes	= 80	; Anzahl der Bytes für jede horizontale Zeile.
			; Daraus berechnen wir die Bildschirmbreite,
			; Multiplizieren von Bytes mit 8: normaler Bildschirm 320/8 = 40
			; z.B. für einen 336 Pixel breiten Bildschirm 336/8 = 42
			; Beispielbreiten:
			; 264 pixel = 33 / 272 pixel = 34 / 280 pixel = 35
			; 360 pixel = 45 / 368 pixel = 46 / 376 pixel = 47
			; ... 640 pixel = 80 / 648 pixel = 81 ...

scr_h		= 256	; Bildschirmhöhe in Zeilen
scr_x		= $81	; Startbildschirm, XX-Position (normal $xx81) (129)
scr_y		= $2c	; Startbildschirm, YY-Position (normal $2cxx) (44)
scr_res		= 2	; 2 = HighRes (640*xxx) / 1 = LowRes (320*xxx)
scr_lace	= 1	; 0 = non interlace (xxx*256) / 1 = interlace (xxx*512)
ham			= 0	; 0 = non ham / 1 = ham
scr_bpl		= 1	; Anzahl Bitplanes

; Parameter automatisch berechnet

scr_w		= scr_bytes*8		; Bildschirmbreite
scr_size	= scr_bytes*scr_h	; Größe in Bytes des Bildschirms
BPLC0	= ((scr_res&2)<<14)+(scr_bpl<<12)+$200+(scr_lace<<2)+(ham<<11)
DIWS	= (scr_y<<8)+scr_x
DIWSt	= ((scr_y+scr_h/(scr_lace+1))&255)<<8+(scr_x+scr_w/scr_res)&255
DDFS	= (scr_x-(16/scr_res+1))/2
DDFSt	= DDFS+(8/scr_res)*(scr_bytes/2-scr_res)


START:

;	Zeiger bitplanes in copperlist

	MOVE.L	#BITPLANE,d0	; in d0 Adresse der Bitplane
	LEA	BPLPOINTERS,A1		; Zeiger auf COPPERLIST
	move.w	d0,6(a1)		; kopiert das niedrige Wort der Bitplaneadresse
	swap	d0				; tauscht die 2 Wörter von d0 aus (1234 > 3412)
	move.w	d0,2(a1)		; kopiert das hohe Wort der Bitplaneadresse


	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$01000,d2	; warte auf Zeile $010
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $010
	BNE.S	Waity1
Waity2:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $010
	Beq.S	Waity2

	btst	#2,$16(A5)	; rechte Maustaste gedrückt?
	beq.s	NonLaceint

	bsr.s	laceint		; Routine splittet ungerade oder gerade Linien
						; je nach LOF-Bit für
						; das Interlace
NonLaceint:
	bsr.w	PrintCarattere	; Drucken Sie jeweils ein Zeichen

	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse

	rts

******************************************************************************
; INTERLACE ROUTINE - Test Bit LOF (Long Frame) um zu wissen, ob Sie
; gerade oder ungerade Zeilen anzeigen und entsprechend wechseln müssen.
******************************************************************************

LACEINT:
	MOVE.L	#BITPLANE,D0	; Adresse bitplane
	btst.b	#15-8,4(A5)		; VPOSR LOF bit?
	Beq.S	Faidispari		; wenn ja, zeigen Sie auf ungerade Zeilen
	ADD.L	#scr_bytes,D0	; Oder fügen Sie die Länge einer Zeile hinzu,
							; Starten der Ansicht von den geraden Zeilen!
							; zweitens: gerade Zeilen werden angezeigt!
FaiDispari:
	LEA	BPLPOINTERS,A1		; PLANE ZEIGER IN COPLIST
	MOVE.W	D0,6(A1)		; Zeiger auf das Bild
	SWAP	D0
	MOVE.W	D0,2(A1)
	RTS

*****************************************************************************
;			Druck Routine
*****************************************************************************

PRINTcarattere:
	MOVE.L	PuntaTESTO(PC),A0	; Adresse des zu druckenden Textes a0
	MOVEQ	#0,D2				; d2 löschen
	MOVE.B	(A0)+,D2			; Nächstes Zeichen in d2
	CMP.B	#$ff,d2				; Ende des Textsignals? ($FF)
	beq.s	FineTesto			; Wenn ja, beenden Sie ohne zu drucken
	TST.B	d2					; Zeilenende-Signal? ($00)
	bne.s	NonFineRiga			; Wenn nicht, nicht aufhören

	ADD.L	#scr_bytes*7,PuntaBITPLANE	; wir gehen zum Anfang
	ADDQ.L	#1,PuntaTesto		; erste Zeichenzeile danach
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
	ADD.L	#FONT,A2	; FINDE DEN GEWÜNSCHTEN BUCHSTABEN IM FONT...

	MOVE.L	PuntaBITPLANE(PC),A3 ; Adresse Ziel-Bitplane in a3

				; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)	; Drucke Zeile 1 des Zeichens
	MOVE.B	(A2)+,scr_bytes(A3)		; Drucke Zeile  2  " "
	MOVE.B	(A2)+,scr_bytes*2(A3)	; Drucke Zeile  3  " "
	MOVE.B	(A2)+,scr_bytes*3(A3)	; Drucke Zeile  4  " "
	MOVE.B	(A2)+,scr_bytes*4(A3)	; Drucke Zeile  5  " "
	MOVE.B	(A2)+,scr_bytes*5(A3)	; Drucke Zeile  6  " "
	MOVE.B	(A2)+,scr_bytes*6(A3)	; Drucke Zeile  7  " "
	MOVE.B	(A2)+,scr_bytes*7(A3)	; Drucke Zeile  8  " "

	ADDQ.L	#1,PuntaBitplane ; wir rücken 8 Bits vor (NÄCHSTES ZEICHEN)
	ADDQ.L	#1,PuntaTesto	 ; nächstes zu druckendes Zeichen

FineTesto:
	RTS

PuntaTesto:
	dc.l	TESTO

PuntaBitplane:
	dc.l	BITPLANE

;	$00 für "Zeilenende" - $FF für "Textende"

		; Anzahl der Zeichen pro Zeile: 40
TESTO:	     ;		  1111111111222222222233333333334
             ;   1234567890123456789012345678901234567890
	dc.b	' Che scritte piccole! Non si leggono nem'   ; 1
	dc.b	'meno... ma sono in 640x512!             ',0 ; 1b
;
	dc.b	'Provate a premere il tasto destro e potr'   ; 2
	dc.b	'ete verificare cosa vedono i coder che  ',0 ; 2b
;
	dc.b	"non sanno come funziona l'interlace, hah"   ; 3
	dc.b	"aha! In fondo e' semplice, no?          ",0 ; 3b
;
	dc.b	'Programmate, fate qualche demo o qualche'   ; 4
	dc.b	" gioco, e' la cosa piu' creativa che si ",0 ; 4b
;
	dc.b	'possa fare nel mondo contemporaneo.     '   ; 5
	dc.b	'                                        ',$FF ; 5b - Ende

	EVEN


;	Die FONT-Zeichen 8x8.

FONT:
	incbin	"assembler2:sorgenti4/nice.fnt"

******************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8e,DIWS	; DiwStrt
	dc.w	$90,DIWSt	; DiwStop
	dc.w	$92,DDFS	; DdfStart
	dc.w	$94,DDFSt	; DdfStop

	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,80		; Bpl1Mod \ INTERLACE: modulo = Länge Zeile!
	dc.w	$10a,80		; Bpl2Mod / um sie zu überspringen (die geraden)

				; 5432109876543210
;	dc.w	$100,%1001001000000100	; 1 bitplane, HIRES LACE 640x512
;					; Beachten Sie das Bit 2 Set für LACE!!

	dc.w	$100,BPLC0	; BplCon0 -> lassen Sie es uns automatisch berechnen!


BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$180,$226	; color0 - Hintergrund
	dc.w	$182,$0b0	; color1 - plane 1 Position normal, und
						; der "klebende" Teil an der Spitze.

	dc.w	$FFFF,$FFFE	; Ende copperlist

******************************************************************************

	SECTION	MIOPLANE,BSS_C

BITPLANE:
	ds.b	scr_bytes*scr_h	; 80*512 eine bitplane Hires int. 640x512

	end

Es sei darauf hingewiesen, dass das System der automatischen Berechnung der
diwstart/stop usw gilt. Denken Sie jedoch für das Interlace daran,
setzen Sie das Modulo auf "scr_bytes", in diesem Fall auf 80.

