
; Listing13b3.s	; Multiplikation - Sonderfälle
; Zeile 548
	
; Für Multiplikationen und Divisionen mit Vielfachen von 2 in ASL/ASR konvertieren
; Hier sind einige Sonderfälle, um MULS / MULU in etwas anderes zu ändern:

	
	section code_N, CODE_F

start:
	;move.w #$4000,$dff09a	; Interrupts disable
waitmouse:  
	;btst	#6,$bfe001		; left mousebutton?
	;bne.s	Waitmouse	
	
	lea result,a0			; 12
	lea resultop,a1			; 12
	;bra mul6				; 10 (Abkürzung)

;-----------------------------------------------------
mul3:
	move.l  faktor,d0		; 20 Zyklen					; 16Bit-value
	;ext.l	d0											; $00008000 --> $FFFF8000 (nur für 16Bit)!
	muls	#3,d0			; 46						; result 32Bit-longword
	move.l	d0,(a0)+		; 12						; Ergebnis in Tab speichern
mul5:
	move.l  faktor,d0		; 20
	muls	#5,d0			; 46
	move.l	d0,(a0)+		; 12						; Ergebnis in Tab speichern
mul6:	
	move.l  faktor,d0		; 20
	muls	#6,d0			; 46
	move.l	d0,(a0)+		; 12						; Ergebnis in Tab speichern
mul7:	
	move.l  faktor,d0		; 20
	muls	#7,d0			; 48
	move.l	d0,(a0)+		; 12						; Ergebnis in Tab speichern
mul9:
	move.l  faktor,d0		; 20
	mulu	#9,d0			; 48
	move.l	d0,(a0)+		; 12						; Ergebnis in Tab speichern
mul10:
	move.l  faktor,d0		; 20
	mulu	#10,d0			; 46
	move.l	d0,(a0)+		; 12						; Ergebnis in Tab speichern
mul12:
	move.l  faktor,d0		; 20
	mulu	#12,d0			; 46
	move.l	d0,(a0)+		; 12						; Ergebnis in Tab speichern
	nop	

	; Ergebnis:	7*46=322
;-----------------------------------------------------
;	mul*.w #3,dx -> move.l dx,ds
;					add.l dx,dx
;					add.l ds,dx

mul3op:
	move.l  faktor,d0						; 20
	move.l	d0,d1							; 4 \
	add.l	d0,d0		; d0=d0*2			; 8   = 20
	add.l	d1,d0		; d0=(d0*2)+d0		; 8 /
	move.l	d0,(a1)+						; 12		; Ergebnis in Tab speichern
;-----------------------------------------------------
;	mul*.w #5,dx -> move.l dx,ds
;					asl.l #2,dx
;					add.l ds,dx	

mul5op:
	move.l  faktor,d0						; 20
	move.l	d0,d1							; 4 \
	asl.l	#2,d0	; d0=d0*4				; 12   = 24
	add.l	d1,d0	; d0=(d0*4)+d0			; 8 /
	move.l	d0,(a1)+						; 12		; Ergebnis in Tab speichern
;-----------------------------------------------------
;	mul*.w #6,dx -> add.l dx,dx
;					move.l dx,ds
;					add.l dx,dx
;					add.l ds,dx

mul6op:	
	move.l  faktor,d0						; 20
	add.l	d0,d0							; 8 \
	move.l	d0,d1							; 4	 \ = 28
	add.l	d0,d0							; 8	 /	
	add.l	d1,d0							; 8 /
	move.l	d0,(a1)+						; 12		; Ergebnis in Tab speichern
;-----------------------------------------------------
;	mul*.w #7,dx -> move.l dx,ds
;					asl.l #3,dx
;					sub.l ds,dx

mul7op:	
	move.l  faktor,d0						; 20
	move.l	d0,d1							; 4 \
	asl.l	#3,d0							; 14 \ = 26
	sub.l	d1,d0							; 8 /
	move.l	d0,(a1)+						; 12		; Ergebnis in Tab speichern
;-----------------------------------------------------
;	mul*.w #9,dx -> move.l dx,ds
;					asl.l #3,dx
;					add.l ds,dx

mul9op:	
	move.l  faktor,d0						; 20
	move.l	d0,d1							; 4 \
	asl.l	#3,d0							; 14 \ = 26
	add.l	d1,d0							; 8 /
	move.l	d0,(a1)+						; 12		; Ergebnis in Tab speichern
;-----------------------------------------------------
;	mul*.w #10,dx -> add.l dx,dx
;					move.l dx,ds
;					asl.l #2,dx
;					add.l ds,dx

mul10op:	
	move.l  faktor,d0						; 20
	add.l	d0,d0							; 8 \
	move.l	d0,d1							; 4  \ = 32
	asl.l	#2,d0							; 12 /
	add.l	d1,d0							; 8 /
	move.l	d0,(a1)+						; 12		; Ergebnis in Tab speichern
;-----------------------------------------------------
;	mul*.w #12,dx -> asl.l #2,dx
;					move.l dx,ds
;					add.l dx,dx
;					add.l ds,dx

mul12op:
	move.l  faktor,d0						; 20
	asl.l	#2,d0							; 12 \
	move.l	d0,d1							; 4   \ = 32
	add.l	d0,d0							; 8  /
	add.l	d1,d0							; 8 /
	move.l	d0,(a1)+						; 12		; Ergebnis in Tab speichern
;-----------------------------------------------------
; Ergebnis: 20+24+28+26+26+32+32=188
ende:
	nop
	;move.w #$C000,$dff09a	; Interrupts enable
	rts

faktor:
	; positive Zahlen
	;dc.l	2			; 12*2=24
	;dc.l	$1555		; 12*$1555	=$FFFF
	;dc.l	$3000		; 12*$3000	=$24000
	;dc.l	$AAAAAAA	; 12*$AAAAAAA=0x7FFFFFF8	; nicht für muls, mulu (da ausserhalb 16bit)

	; negative Zahlen
	;dc.l	-1			; 12*(-1)	=$FFFFFFF4	
	dc.l	-32768

	
result:	
	blk.l 8,$0

line: 
	blk.w 8,$1111	; Trennlinie

resultop:
	blk.l 8,$0	

	end

;------------------------------------------------------------------------------
r
Filename: Listing13b3.s
>a
Pass1
Pass2
No Errors
>ad		; asmone Debugger

>h.w result


Multiply the 16-bit destination operand by the 16-bit source operand and store
the result in the destination. Both the source and destination are 16-bit word
values and the destination result is a 32-bit longword. The product is
therefore a correct product and is not truncated. MULU performs multiplication
with unsigned values and MULS performs multiplication with twos complement
values.

Operation: [destination] <- [destination] * [source]
MULS <ea>,Dn
MULU <ea>,Dn


; positive Zahlen
Faktor: 2
>m $c1b2fa 5
00C1B2FA 0000 0006 0000 000A 0000 000C 0000 000E  ................	; muls
00C1B30A 0000 0012 0000 0014 0000 0018 0000 0000  ................	; mulu
00C1B31A 1111 1111 1111 1111 1111 1111 1111 1111  ................	
00C1B32A 0000 0006 0000 000A 0000 000C 0000 000E  ................	; = muls
00C1B33A 0000 0012 0000 0014 0000 0018 0000 0000  ................	; = mulu
>

Faktor: $1555														; nur untere 16 Bit im Ziel
>m $c1b2fa 5
00C1B2FA 0000 3FFF 0000 6AA9 0000 7FFE 0000 9553  ..?...j........S	; muls
00C1B30A 0000 BFFD 0000 D552 0000 FFFC 0000 0000  .......R........	; mulu
00C1B31A 1111 1111 1111 1111 1111 1111 1111 1111  ................
00C1B32A 0000 3FFF 0000 6AA9 0000 7FFE 0000 9553  ..?...j........S	; = muls
00C1B33A 0000 BFFD 0000 D552 0000 FFFC 0000 0000  .......R........	; = mulu
>

Faktor: $3000
>m $c1b2fa 5														; Ziel 32 Bit
00C1B2FA 0000 9000 0000 F000 0001 2000 0001 5000  .......... ...P.	; muls
00C1B30A 0001 B000 0001 E000 0002 4000 0000 0000  ..........@.....	; mulu
00C1B31A 1111 1111 1111 1111 1111 1111 1111 1111  ................
00C1B32A 0000 9000 0000 F000 0001 2000 0001 5000  .......... ...P.	; = muls
00C1B33A 0001 B000 0001 E000 0002 4000 0000 0000  ..........@.....	; = mulu
>

>?$7fffffff/12
0x0AAAAAAA = %00001010101010101010101010101010 = 178956970 = 178956970
>
Faktor:	$0AAAAAAA													; >16 Bit !
>m $c1b2fa 5
00C1B2FA FFFE FFFE FFFE 5552 FFFD FFFC FFFD AAA6  ......UR........	; error source >16 Bit
00C1B30A 0005 FFFA 0006 AAA4 0007 FFF8 0000 0000  ................	; error source >16 Bit
00C1B31A 1111 1111 1111 1111 1111 1111 1111 1111  ................
00C1B32A 1FFF FFFE 3555 5552 3FFF FFFC 4AAA AAA6  ....5UUR?...J...	; = muls ok
00C1B33A 5FFF FFFA 6AAA AAA4 7FFF FFF8 0000 0000  _...j...........	; = mulu ok
>

																	; negative Zahlen
Faktor: -1		= $FFFF												; es wird kein ext.l benötigt
>m $c1b2fa 5
00C1B2FA FFFF FFFD FFFF FFFB FFFF FFFA FFFF FFF9  ................	; muls
00C1B30A 0008 FFF7 0009 FFF6 000B FFF4 0000 0000  ................	; error nicht für mulu
00C1B31A 1111 1111 1111 1111 1111 1111 1111 1111  ................
00C1B32A FFFF FFFD FFFF FFFB FFFF FFFA FFFF FFF9  ................	; = muls
00C1B33A FFFF FFF7 FFFF FFF6 FFFF FFF4 0000 0000  ................	; = muls
>

Faktor: -32768	= $8000
>m $c1b2fa 5
00C1B2FA FFFE 8000 FFFD 8000 FFFD 0000 FFFC 8000  ................
00C1B30A 0004 8000 0005 0000 0006 0000 0000 0000  ................	; error nicht für mulu
00C1B31A 1111 1111 1111 1111 1111 1111 1111 1111  ................
00C1B32A FFFE 8000 FFFD 8000 FFFD 0000 FFFC 8000  ................
00C1B33A FFFB 8000 FFFB 0000 FFFA 0000 0000 0000  ................
>?-32768
0xFFFF8000 = %11111111111111111000000000000000 = 4294934528 = -32768
>


Hinweis: Wenn es sich um ein "MULS" handelt, muss häufig ein "ext.l dx" als erste
Anweisung hinzugefügt werden, um das Vorzeichen auf Langwort zu erweitern.

	ext.l	d0											; $00008000 --> $FFFF8000 (nur für 16Bit)!

Dies ist nicht erorderlich, da bei der Multiplikation zwei 16 Bit-Zahlen 
multipliziert werden und das Ergebnis gemäß dem mulu/muls-Befehl in einem 32 Bit Register steht.
Das 32 Bit Ergebnis wird dabei automatisch vorzeichenrichtig erweitert.
