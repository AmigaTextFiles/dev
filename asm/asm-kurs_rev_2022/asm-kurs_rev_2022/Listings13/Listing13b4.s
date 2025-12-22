
; Listing13b4.s	; Multiplikation - hohe Wort zurücksetzen vom Quell-Longword
; Zeile 580
	
; Für Multiplikationen und Divisionen mit Vielfachen von 2 in ASL/ASR konvertieren
; Hier sind einige Sonderfälle, um MULS / MULU in etwas anderes zu ändern:

; Vergleich mulu zu optimiert und Klärung Aussage hohe Wort zurücksetzen vom Quell-Longword?

	
	section code_N, CODE_F

start:
	move.w #$4000,$dff09a	; Interrupts disable
waitmouse:  
	btst	#6,$bfe001		; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
	lea result,a0			; 12
	lea resultop,a1			; 12
;------------------------------------------------------------------------------
mul12:
	move.l	#$123456,d0		; 12						; hohes Wort nicht zurückgesetzt		
	;move.l  faktor,d0		; 20
	mulu	#12,d0			; 46
	move.l	d0,(a0)+		; 12						; Ergebnis in Tab speichern
														; Ergebnis: $27408 (falsch)
;------------------------------------------------------------------------------
;mulu.w #12,dx -> swap dx	; HEI! oft ist es notwendig, das hohe Wort zurückzusetzen
;				clr.w dx	; für MULUs ... bedenken Sie dies auch... 
;				swap dx		; für mulu #3, #5, #6 ....

	move.l	#$123456,d0		; 12
	swap d0					; 4
	clr.w d0				; 4							
	swap d0					; 4							; hohes Wort zurückgesetzt	
	mulu	#12,d0			; 46
	move.l	d0,(a0)+		; 12						; Ergebnis in Tab speichern
														; Ergebnis: $27408 (falsch)
;------------------------------------------------------------------------------
;	move.l	#$0000FFFF,ds	; 1 Register wird benötigt, um $FFFF zu halten

;	and.l	ds,dx			; das ist schneller als tauschen, aber
							; erfordert ein Register, das $0000FFFF enthält,
							; Andernfalls ist "AND.L #$FFFF,dx" nicht mehr vorhanden
							; schnell...	
	move.l	#$123456,d0		; 12
	move.l	#$0000FFFF,d1	; 12
	and.l	d1,d0			; 8							; hohes Wort zurückgesetzt
	
	mulu	#12,d0			; 46
	move.l	d0,(a0)+		; 12						; Ergebnis in Tab speichern
														; Ergebnis: $27408 (falsch)
;------------------------------------------------------------------------------
; optimierte Variante:	
;	mulu.w #12,dx -> asl.l #2,dx
;					move.l dx,ds
;					add.l dx,dx
;					add.l ds,dx

mul12op:
	move.l	#$123456,d0									; hohes Wort nicht zurückgesetzt
	;move.l  faktor,d0						; 20
	asl.l	#2,d0							; 12 \
	move.l	d0,d1							; 4   \ = 32
	add.l	d0,d0							; 8  /
	add.l	d1,d0							; 8 /
	move.l	d0,(a1)+						; 12		; Ergebnis in Tab speichern
														; Ergebnis: $DA7408	(richtig)
;------------------------------------------------------------------------------	

	move.l	#$123456,d0	
	swap d0
	clr.w d0
	swap d0												; hohes Wort zurückgesetzt

	;move.l  faktor,d0						; 20
	asl.l	#2,d0							; 12 \
	move.l	d0,d1							; 4   \ = 32
	add.l	d0,d0							; 8  /
	add.l	d1,d0							; 8 /
	move.l	d0,(a1)+						; 12		; Ergebnis in Tab speichern
														; Ergebnis: $27408 (falsch)
;------------------------------------------------------------------------------	
	
	move.l	#$123456,d0	
	move.l	#$0000FFFF,d1
	and.l	d1,d0										; hohes Wort nicht zurückgesetzt

	;move.l  faktor,d0						; 20
	asl.l	#2,d0							; 12 \
	move.l	d0,d1							; 4   \ = 32
	add.l	d0,d0							; 8  /
	add.l	d1,d0							; 8 /
	move.l	d0,(a1)+						; 12		; Ergebnis in Tab speichern
														; Ergebnis: $27408 (falsch)
;------------------------------------------------------------------------------	
ende:
	nop
	move.w #$C000,$dff09a	; Interrupts enable
	rts

faktor:
	dc.l	2

result:	
	blk.l 8,$0

line: 
	blk.w 8,$1111			; Trennlinie

resultop:
	blk.l 8,$0	

	end


;------------------------------------------------------------------------------
r
Filename: Listing13b4.s
>a
Pass1
Pass2
No Errors
>ad		; asmone Debugger


Aus Lektion13:
mulu.w #12,dx -> swap dx	; HEI! oft ist es notwendig, das hohe Wort zurückzusetzen
				clr.w dx	; für MULUs ... bedenken Sie dies auch... 
				swap dx		; für mulu #3, #5, #6 ....

				asl.l #2,dx		; normal mulu #12
				move.l dx,ds
				add.l dx,dx
				add.l ds,dx

	move.l	#$0000FFFF,ds	; 1 Register wird benötigt, um $FFFF zu halten

	and.l	ds,dx			; das ist schneller als tauschen, aber
							; erfordert ein Register, das $0000FFFF enthält,
							; Andernfalls ist "AND.L #$FFFF,dx" nicht mehr vorhanden
							; schnell...


>m $c1b2ac 5
00C1B2AC 0002 7408 0002 7408 0002 7408 0000 0000  ..t...t...t.....
00C1B2BC 0000 0000 0000 0000 0000 0000 0000 0000  ................
00C1B2CC 1111 1111 1111 1111 1111 1111 1111 1111  ................
00C1B2DC 00DA 7408 0002 7408 0002 7408 0000 0000  ..t...t...t.....
00C1B2EC 0000 0000 0000 0000 0000 0000 0000 0000  ................
>
>?$123456*!12
0x00DA7408 = %00000000110110100111010000001000 = 14316552 = 14316552
>?$3456*!12
0x00027408 = %00000000000000100111010000001000 = 160776 = 160776
>

Das Ergebnis mit mulu ist $27408, da die Berechnung 16Bit*16Bit=32Bit ist. Bei
der optimierten Variante (hohes Wort nicht zurückgesetzt) wird hingeggen
32bit*16Bit gerechnet. Hier ist das Ergebnis $DA7408. Das Ergebnis ist in
diesem Fall richtig.

Grundsätzlich: Das hohe Wort muss nicht zurückgesetzt werden.