
; Listing17r3.s = Scacchiera.S

***********************************************************************
T;				CHECKED SQUARE

; L'effetto e' ottenuto in questo modo: lo schermo ha modulo -40, per cui la
; prima riga e' ripetuta per tutto lo schermo. Si precalconano in un buffer
; le varie "posizioni" delle bande orizzontali, solo una linea, poi si blitta
; ad ogni frame quella giusta, che viene "allungata". Col copper poi si
; vambia la palette in senso orizzontale creando gli scacchi dalle strisce.
****************************************************************************
; Lezione

; continuare a commentare parti complexxe

	Section	scacchiera,code

;	Include	"DaWorkBench.s"	; togliere il ; prima di salvare con "WO"

*****************************************************************************
	include	"//Sources/startup2.s"	; salva interrupt, dma eccetera.
*****************************************************************************


; Con DMASET decidiamo quali canali DMA aprire e quali chiudere

		;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane, blitter DMA ON.
WaitDisk EQU	%0				; wegen startup2

START:

; Puntiamo la PIC

	MOVE.L	#BplEffect,D0
	MOVE.W	D0,Bplpoint2
	SWAP	D0
	MOVE.W	D0,Bplpoint1

	MOVE.L	#BplEffect+56,d0
	MOVE.W	D0,Bplpoint4
	SWAP	D0
	MOVE.W	D0,Bplpoint3

	MOVE.L	#CLEARBITP,d0	;BPL PULITO (dove si puo' printare un testo)
	MOVE.W	D0,Bplpoint6
	SWAP	D0
	MOVE.W	D0,Bplpoint5

	MOVE.W	#DMASET,$96(a5)		; DMACON - abilita bitplane, copper
					; e sprites.

	movem.l	d0-d7/a0-a7,-(SP)
;	BSR.W	AzzeraColBlitter	; non occorre...
	BSR.W	SistemaTabelle
	BSR.W	FaiscacchiNeiPlanes
	BSR.W	CreaLaCop
	movem.l	(SP)+,d0-d7/a0-a7

	move.l	#COPLIST,$80(a5)	; Puntiamo la nostra COP
	move.w	d0,$88(a5)		; Facciamo partire la COP
	move.w	#0,$1fc(a5)		; Disattiva l'AGA
	move.w	#$c00,$106(a5)		; Disattiva l'AGA
	move.w	#$11,$10c(a5)		; Disattiva l'AGA

mouse:
	MOVE.L	#$1ff00,d1	; bit per la selezione tramite AND
	MOVE.L	#$0ff00,d2	; linea da aspettare = $ff
Waity1:
	MOVE.L	4(A5),D0	; VPOSR e VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Seleziona solo i bit della pos. verticale
	CMPI.L	D2,D0		; aspetta la linea $fa
	BNE.S	Waity1

	BSR.S	BlittaStrisceVert	; Allarga e strettisci le strisce
					; verticali con opportune blittate di
					; copia da buffer predefiniti.

	btst.b	#2,$16(a5)	; tasto destro premuto?
	beq.s	NonCoppare
	BSR.W	MAKECOP1	; cambia colore in modo da completare la
				; scacchera...
Noncoppare:

	MOVE.L	#$1ff00,d1	; bit per la selezione tramite AND
	MOVE.L	#$0ff00,d2	; linea da aspettare = $ff
Aspetta:
	MOVE.L	4(A5),D0	; VPOSR e VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Seleziona solo i bit della pos. verticale
	CMPI.L	D2,D0		; aspetta la linea $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001	; Mouse premuto?
	bne.s	mouse
	rts			; esci

******************************************************************************
; Questa routine cambia i bitplanes: allarga o strettisce le strisce verticali
; che in pratica sono la prima linea ripetuta per tutto lo schermo tramite
; un modulo -40. Cioe' deve soltanto operare su 1 linea, la prima.
******************************************************************************

BlittaStrisceVert:
	MOVEA.L	Tabba2Pointer(PC),A0
	MOVE.W	(A0),D0
	MOVE.W	D0,D1
	ASR.W	#3,D0		; offset destinazione ok
	ANDI.B	#15,D1
	ROR.W	#4,D1
	ADDI.W	#$9F0,D1
	MOVEA.L	TabbaBufferPointer(PC),A0
	MOVE.W	(A0),D2		; offset sorgente
	LEA	BplBufToBlit,A0
	LEA	BlittaData,A1
	ADDA.W	D2,A0		; sorgente
	ADDA.W	D0,A1		; destinazione
	BTST.b	#6,2(A5)
WBLIT0:
	BTST.b	#6,2(A5)	; dmaconr - aspetta la fine della blittata
	BNE.S	WBLIT0
	MOVEM.L	A0/A1,$50(A5)		; BLTAPT 6 BLTDPT
	MOVE.L	#0,$64(A5)		; BLTAMOD = 0
	MOVE.W	D1,$40(A5)		; BLTCON0
	MOVE.W	#(1<<6)+56,$58(A5)	; BLTSIZE :largh. 56 words,
					;  altezza 1 linea
	ADDQ.L	#2,Tabba3Pointer
	ADDQ.L	#2,TabbaBufferPointer
	CMPI.L	#Tabba3END,Tabba3Pointer	; Fine tabba3?
	BMI.S	NonFiniTabba3
	MOVE.L	#Tabba3,Tabba3Pointer		; Riparti a puntare tabba3
	MOVE.L	#TabbaBuffer,TabbaBufferPointer
NonFiniTabba3:
	ADDQ.L	#2,Tabba2Pointer
	CMPI.L	#Tabba2END,Tabba2Pointer	; Fine tabba2?
	BMI.S	NonFiniTabba2
	MOVE.L	#Tabba2,Tabba2Pointer	; Riparti a puntare tabba2
NonFiniTabba2:
	RTS

******************************************************************************
; Questa routine cambia la copperlist: cambia i color1 e color2 per creare
; le divisioni in senso verticale, altrimenti ci sarebbero solo barre unite.
******************************************************************************

MAKECOP1:
	MOVE.W	#0,$42(A5)
	LEA	COPPYEFFECT,A0
	MOVEA.L	CopTabbaPointer(PC),A1
	MOVEA.L	Tabba3Pointer(PC),A2
	MOVE.W	(A2),D2
	MOVE.W	#$F0,D1
	ADD.W	(A1),D1
	LEA	0(A0,D1.W),A0
	MOVEA.L	A0,A1
	MOVEQ	#12,D1
	SUBA.W	D1,A0
	MOVE.W	D2,D3
	LEA	COPPYEFFECT,A2
	LEA	COPPYEFFECTEND,A3
	MOVE.W	#$F88,D4	;COLOR 1 DEGLI SCACCHI
	MOVE.W	#$8f8,D5	;COLOR 2 DEGLI SCACCHI
MAKECOP2:
	CMPA.L	A2,A0
	BLE.S	MAKECOP4
	MOVE.W	D4,6(A0)
	MOVE.W	D5,10(A0)
	SUBA.W	D1,A0
	DBRA	D3,MAKECOP2
	MOVE.W	D2,D3
MAKECOP3:
	CMPA.L	A2,A0
	BLE.S	MAKECOP4
	MOVE.W	D5,6(A0)
	MOVE.W	D4,10(A0)
	SUBA.W	D1,A0
	DBRA	D3,MAKECOP3
	MOVE.W	D2,D3
	BRA.S	MAKECOP2

MAKECOP4:
	MOVE.W	D2,D3
MAKECOP5:
	CMPA.L	A3,A1
	BGE.S	MAKECOP7
	MOVE.W	D5,6(A1)
	MOVE.W	D4,10(A1)
	ADDA.W	D1,A1
	DBRA	D3,MAKECOP5
	MOVE.W	D2,D3
MAKECOP6:
	CMPA.L	A3,A1
	BGE.S	MAKECOP7
	MOVE.W	D4,6(A1)
	MOVE.W	D5,10(A1)
	ADDA.W	D1,A1
	DBRA	D3,MAKECOP6
	MOVE.W	D2,D3
	BRA.S	MAKECOP5

MAKECOP7:
	ADDQ.L	#2,CopTabbaPointer
	CMPI.L	#CopTabbaEND,CopTabbaPointer
	BMI.S	MAKECOPEND
	MOVE.L	#CopTabba,CopTabbaPointer
MAKECOPEND:
	RTS

*****************************************************************************
; Questa routine crea gli "scacchi" nei bitplanes: $FFFF0000FFFF0000....
*****************************************************************************

FaiscacchiNeiPlanes:
	LEA	BplBufToBlit,A0
	MOVE.W	#200-1,D7	; numero di linee verticali
	MOVE.L	#$FFFFFFFF,D1
	MOVE.L	D1,D2
	MOVE.L	D1,D3
	MOVE.L	D1,D4
	MOVE.L	D1,D5
	MOVE.L	D1,D6
	MOVE.L	D1,D0
SettaLinee:
	MOVEM.L	D0-D6,(A0)	; scrivi 28 bytes $FF
	LEA	112(A0),A0	; salta 84+28 bytes, lasciandone 84 azzerati
	DBRA	D7,SettaLinee

	LEA	BplBufToBlit,A0
	MOVE.W	#200-1,D0	; Numero di linee verticali
	MOVEQ	#1,D1
lbC00023C:
	MOVE.W	D1,D5
	MOVE.W	#$E0,D2
	MOVE.W	D2,D7
	MOVEA.L	A0,A1
lbC000246:
	MOVE.W	D2,D3
	MOVE.W	D3,D4
	LSR.W	#3,D3
	NOT.B	D4
	BSET	D4,0(A0,D3.W)
	MOVE.W	D7,D3
	MOVE.W	D7,D4
	LSR.W	#3,D3
	NOT.B	D4
	BCLR	D4,0(A0,D3.W)
	ADDQ.W	#1,D2
	SUBQ.W	#1,D7
	CMPI.W	#$1C0,D2
	BGT.S	lbC00027A
	DBRA	D5,lbC000246
	ADD.W	D1,D2
	SUB.W	D1,D7
	MOVE.W	D1,D5
	CMPI.W	#$1C0,D2
	BGT.S	lbC00027A
	BRA.S	lbC000246

lbC00027A:
	MOVEA.L	A1,A2
	MOVEA.L	A1,A3
	LEA	$38(A2),A2
	MOVE.W	#13,D7
lbC000286:
	MOVE.L	(A3)+,D6
	EORI.L	#$FFFFFFFF,D6
	MOVE.L	D6,(A2)+
	DBRA	D7,lbC000286
	ADDQ.W	#1,D1
	LEA	$70(A0),A0
	DBRA	D0,lbC00023C
	RTS

******************************************************************************
; 			Crea la copperlist
******************************************************************************

CreaLaCop:
	LEA	COPPYEFFECT,A0
	MOVE.W	#$2801,D1	; WAIT - comincia dalla linea $28
	MOVE.W	#205-1,D0
CreaLaCop2:
	MOVE.W	D1,(A0)+	; metti prima word wait (YYXX)
	MOVE.W	#$FFFE,(A0)+	; metti seconda word wait
	MOVE.W	#$182,(A0)+	; Metti registro color1
	MOVE.W	#0,(A0)+	; Metti valore color1
	MOVE.W	#$184,(A0)+	; Metti registro color2
	MOVE.W	#0,(A0)+	; Metti valore color2
	ADDI.W	#$0100,D1	; Fai waitare una linea sotto
	DBRA	D0,CreaLaCop2
	RTS

******************************************************************************
; Azzera i bitplanes con il blitter
******************************************************************************

AzzeraColBlitter:
	MOVE.L	#BplBufToBlit,$54(A5)	; BPLDPT
	MOVE.L	#$01000000,$40(A5)	; BPLCON0/1 - solo destinazione: clear
	MOVE.L	#$FFFFFFFF,$44(A5)	; BLTAFWM/LWM (mask)
	MOVE.L	#0,$64(A5)		; BLTAMOD
	MOVE.W	#(200<<6)+56,$58(A5)	; larghezza 56 words, altezza 200 linee
	BTST.b	#6,2(A5)
WBLIT3:
	BTST.b	#6,2(A5)	; dmaconr - aspetta la fine della blittata
	BNE.S	WBLIT3

	MOVE.L	#BplEffect,$54(A5)	; BLTDPT
	MOVE.W	#$0100,$40(A5)		; BPLCON0 - solo destinazione: clear
	MOVE.W	#(1<<6)+56,$58(A5)	; largh. 56 words, altezza 1 linea
WBLIT5:
	BTST.b	#6,2(A5)	; dmaconr - aspetta la fine della blittata
	BNE.S	WBLIT5

	MOVE.L	#BplBufToBlit2,$54(A5)	; BLTDPT
	MOVE.W	#$0100,$40(A5)		; BPLCON0 - solo Dest: clear!
	MOVE.W	#(16<<6)+21,$58(A5)	; largh. 21 words, altezza 16 linee
BLIT7:
	BTST.b	#6,2(A5)	; dmaconr - aspetta la fine della blittata
	BNE.S	BLIT7
	rts

******************************************************************************
; Questa routine sistema i puntatori alle tabelle e crea TabbaBuffer
******************************************************************************

SistemaTabelle:
	MOVE.L	#Tabba2,Tabba2Pointer
	MOVE.L	#Tabba3,Tabba3Pointer
	MOVE.L	#CopTabba,CopTabbaPointer
	MOVE.L	#TabbaBuffer,TabbaBufferPointer

	LEA	CopTabba(PC),A0
	LEA	CopTabbaEND(PC),A1
MoltipliTabba:
	MOVE.W	(A0),D0		; Prendi un valore da CopTabba
	MULU.W	#12,D0		; Moltiplicalo per 12
	MOVE.W	D0,(A0)		; E rimettilo al posto del valore originario
	ADDQ.W	#2,A0
	CMP.L	A0,A1
	BGE.S	MoltipliTabba

	LEA	Tabba3(PC),A0
	LEA	Tabba3END(PC),A1
	LEA	TabbaBuffer(PC),A2
FaiTabbaBuffer:
	MOVE.W	(A0),D0		; Prendi un valore da Tabba3
	MULS.W	#112,D0		; Moltiplicalo per 112
	MOVE.W	D0,(A2)		; E mettilo in TabbaBuffer
	ADDQ.W	#2,A0
	ADDQ.W	#2,A2
	CMPA.L	A0,A1
	BGE.S	FaiTabbaBuffer
	RTS

Tabba2Pointer:
	dc.l	0
Tabba3Pointer:
	dc.l	0
CopTabbaPointer:
	dc.l	0
TabbaBufferPointer:
	dc.l	0

; 121 valori .word

Tabba2:
	dc.w	$2C,$2E,$30,$32,$35,$37,$39,$3B,$3D,$40,$42,$44
	dc.w	$45,$47,$49,$4B,$4C,$4E,$4F,$50,$52,$53,$54,$55
	dc.w	$55,$56,$57,$57,$57,$57,$57,$57,$57,$57,$56,$56
	dc.w	$55,$54,$54,$53,$51,$50,$4F,$4E,$4C,$4A,$49,$47
	dc.w	$45,$43,$41,$3F,$3D,$3B,$39,$37,$34,$32,$30,$2D
	dc.w	$2B,$29,$27,$24,$22,$20,$1E,$1B,$19,$17,$15,$13
	dc.w	$11,$F,$E,$C,$A,9,8,6,5,4,3,2,1,1,0,0,0,0,0,0,0,0
	dc.w	1,1,2,3,4,5,6,7,8,$A,$B,$D,$F,$10,$12,$14,$16,$18
	dc.w	$1A,$1C,$1F,$21,$23,$25,$28,$2A
Tabba2END:
	dc.w	$2C


; 410 valori .word

Tabba3:
	dc.w	0,1,2,3,4,5,6,7,8,9,$A,$B,$C,$D,$E,$F,$10,$11,$12
	dc.w	$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E
	dc.w	$1F,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A
	dc.w	$2B,$2C,$2D,$2E,$2F,$30,$31,$32,$33,$34,$35,$36
	dc.w	$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F,$40,$41,$42
	dc.w	$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E
	dc.w	$4F,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5A
	dc.w	$5B,$5C,$5D,$5E,$5F,$60,$61,$62,$62,$62,$63,$64
	dc.w	$65,$66,$67,$68,$69,$6A,$6B,$6C,$6D,$6E,$6F,$70
	dc.w	$71,$72,$72,$73,$74,$75,$76,$77,$78,$79,$7A,$7B
	dc.w	$7C,$7D,$7E,$7F,$80,$81,$82,$83,$84,$85,$86,$87
	dc.w	$88,$89,$8A,$8B,$8C,$8D,$8E,$8F,$90,$91,$92,$93
	dc.w	$94,$95,$96,$97,$98,$99,$9A,$9B,$9C,$9D,$9E,$9F
	dc.w	$A0,$A1,$A2,$A3,$A4,$A5,$A6,$A7,$A8,$A9,$AA,$AB
	dc.w	$AC,$AD,$AE,$AF,$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7
	dc.w	$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3
	dc.w	$C4,$C5,$C5,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C7
	dc.w	$C6,$C5,$C4,$C3,$C2,$C1,$C0,$BF,$BE,$BD,$BC,$BB
	dc.w	$BA,$B9,$B8,$B7,$B6,$B5,$B4,$B3,$B2,$B1,$B0,$AF
	dc.w	$AE,$AD,$AC,$AB,$AA,$A9,$A8,$A7,$A6,$A5,$A4,$A3
	dc.w	$A2,$A1,$A0,$9F,$9E,$9D,$9C,$9B,$9A,$99,$98,$97
	dc.w	$96,$95,$94,$93,$92,$91,$90,$8F,$8E,$8D,$8C,$8B
	dc.w	$8A,$89,$88,$87,$86,$85,$84,$83,$82,$81,$80,$7F
	dc.w	$7E,$7D,$7C,$7B,$7A,$79,$78,$77,$76,$75,$74,$73
	dc.w	$72,$71,$70,$6F,$6E,$6D,$6C,$6B,$6A,$69,$68,$67
	dc.w	$66,$65,$64,$63,$62,$61,$60,$5F,$5E,$5D,$5C,$5B
	dc.w	$5A,$59,$57,$56,$55,$54,$53,$52,$51,$50,$4F,$4E
	dc.w	$4D,$4C,$4B,$4A,$49,$48,$47,$46,$45,$44,$43,$42
	dc.w	$41,$40,$3F,$3E,$3D,$3C,$3B,$3A,$39,$38,$37,$36
	dc.w	$35,$34,$33,$32,$31,$30,$2F,$2E,$2D,$2C,$2B,$2A
	dc.w	$29,$28,$27,$26,$25,$24,$23,$22,$21,$20,$1F,$1E
	dc.w	$1D,$1C,$1B,$1A,$19,$18,$17,$16,$15,$14,$13,$12
	dc.w	$11,$10,$F,$E,$D,$C,$B,$A,9,8,7,6,5,4,3,2,1,0
Tabba3END:
	dc.w	0

; 121 valori .word (gli stessi di tabba2)

CopTabba:
	dc.w	$2C,$2E,$30,$32,$35,$37,$39,$3B,$3D,$40,$42,$44
	dc.w	$45,$47,$49,$4B,$4C,$4E,$4F,$50,$52,$53,$54,$55
	dc.w	$55,$56,$57,$57,$57,$57,$57,$57,$57,$57,$56,$56
	dc.w	$55,$54,$54,$53,$51,$50,$4F,$4E,$4C,$4A,$49,$47
	dc.w	$45,$43,$41,$3F,$3D,$3B,$39,$37,$34,$32,$30,$2D
	dc.w	$2B,$29,$27,$24,$22,$20,$1E,$1B,$19,$17,$15,$13
	dc.w	$11,$F,$E,$C,$A,9,8,6,5,4,3,2,1,1,0,0,0,0,0,0,0,0
	dc.w	1,1,2,3,4,5,6,7,8,$A,$B,$D,$F,$10,$12,$14,$16,$18
	dc.w	$1A,$1C,$1F,$21,$23,$25,$28,$2A
CopTabbaEND:
	dc.w	$2C


TabbaBuffer:
	dcb.w	819,0


	section	gni,data_C

BlittaData:
	dc.l	$10000
	dc.l	$30007
	dc.l	$10000
	dc.l	$7FFFFF

BplEffect:
	dcb.l	14616,0
BplBufToBlit:
	dcb.b	6552,0

BplBufToBlit2:
	dcb.B	15860,0

	Section	maicoppera,data_C

COPLIST:
	dc.W	$100,%0011011000000000	;4600
	dc.l	$1020000
	dc.l	$1040044	; PLAYFIELD PRIORITY

	dc.w	$108,-40	; BPL1MOD: modulo negativo, in modo che la
				; prima linea sia ripetuta per tutto lo
				; schermo.
	dc.w	$10a,0		; BPL2MOD: modulo normale, in modo da poter
				; scrivere testi o mettere qualsiasi cosa
				; senza problemi.
	dc.l	$8E2C81
	dc.l	$90F4C1
	dc.l	$920038
	dc.l	$9400D0
	dc.w	$180,$666	;SFONDO
	dc.w	$182,$666
	dc.w	$184,$666
	dc.w	$186,$FF6	; scritte in sovraimpressione
	dc.w	$18C,$FF6
	
	dc.W	$E0
Bplpoint1:
	DC.W	0
	dc.W	$E2
Bplpoint2:	
	DC.W	0
	dc.W	$E8	;$E8
Bplpoint3:
	DC.W	0
	dc.W	$EA	;$EA
Bplpoint4:
	DC.W	0
	dc.W	$E4
Bplpoint5:	DC.W	0
	dc.W	$E6
Bplpoint6:
	DC.W	0	;BITPLANE PER SCRITTE O CUBO..

COPPYEFFECT:
	dcb.w	1230,0
COPPYEFFECTEND:

	dc.w	$180,$666
	dc.w	$182,$666
	dc.w	$FFFF,$FFFE	; fine della copperlist

	section	plane,bss_C

CLEARBITP:		;BITPLANE PULITO
	Ds.B	10240	; 8000 basterebbe per ntsc

	END

