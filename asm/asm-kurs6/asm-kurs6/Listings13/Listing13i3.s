
; Listing13i3.s	; relativ (PC)
; Zeile 1811

start:
	move.w #$4000,$dff09a		; Interrupts disable
	move.w #$7fff,$dff096		; dma disable	for all cycles for cpu
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
	nop
;-------------------------------;
; Um jedoch alles mit dem PC schnell in Verbindung zu bringen, gibt es ein
; System. Wenn in einem bekannten Adressregister, zum Beispiel a5, die Adresse
; vom Beginn des Programms ist oder auf jeden Fall eine bekannte Adresse unseres
; Programms, geben Sie einfach unser Label als a5 + Offset an, um das fragliche
; Label zu finden. Aber sollten wir dies "VON HAND" tun???? Neiiiiiin!
; Hier ist ein sehr schneller Weg, um dies zu tun:

; S:								; Label der Referenz
; MYPROGGY:
;	LEA	$dff002,A6				; in a6 haben wir das custom Register
;	LEA	S(PC),A5				; in a5 das Register für den Labelversatz
;	MOVE.L	#$123,LABEL2-S(A5)	; label2-s = offset! Beispiel: "$364(a5)"
;	MOVE.L	LABEL2(PC),d0		; hier handeln wir normal
;	MOVE.L	d0,LABEL3-S(A5)		; gleiche Rede.
;	move.l	#$400,$96-2(a6)		; Dmacon (in a6 ist $dff002!!!)
;	...

; Nehmen wir an, Sie haben das A5-Register "verschmutzt" ... 
; laden Sie es einfach neu!

;	LEA	S(PC),A5
;	move.l	$64(a1),OLDINT1-S(A5)
;	CLR.L	LABEL1-S(A5)

; Es scheint klar zu sein, oder? Sie hätten das Label BAU: anstelle von 'S:
; nennen können, aber ich denke, dass es nützlich ist, es S:, E:, I: zu nennen,
; was kürzer zu schreiben ist.
; Die einzige Einschränkung besteht darin, dass wenn das Label mehr als 32 KB von
; der Referenz entfernt ist gehen wir über die Adressierungsgrenzen hinaus. Das
; ist kein unüberwindbares Problem. In der Tat ist es genug, ein Referenzlabel
; alle 30K zu setzen und sich auf das nächste zu beziehen, zum Beispiel:

;B:
;	...
;	LEA	B(PC),A5
;	MOVE.L	D0,LABEL1-B(A5)
;	...

; 30K Pass

;C:

;	LEA	C(PC),A5
;	MOVE.L	(a0),LABEL40-C(A5)
;	...


S:								; Label der Referenz
MYPROGGY:
	LEA	$dff002,A6				; in a6 haben wir das custom Register			12 cy
	LEA	S(PC),A5				; in a5 das Register für den Labelversatz		 8 cy

	MOVE.L	#$123,LABEL2-S(A5)	; label2-s = offset! Beispiel: "$364(a5)"		24 cy
	MOVE.L	LABEL2(PC),d0		; hier handeln wir normal						16 cy
	MOVE.L	d0,LABEL3-S(A5)		; gleiche Rede.									16 cy
	move.l	#$400,$96-2(a6)		; Dmacon (in a6 ist $dff002!!!)					24 cy
	bra b						; 10 cy
	
	even
label1:
	dc.l	$12345678			; ** out of Range 16bit
label2:							; lea	label1(PC),a0
	dc.l	$22223333
label3:
	dc.l	$44445555
dest:
	dc.l	$60000

	cnop 0,32768				; 30k Pass	
B:
	;...
	LEA	B(PC),A5				; 8 cy										
	MOVE.L	D0,LABEL1-B(A5)		; 16 cy
	;...
	bra c						; 10 cy


	cnop 0,32768				; 30k Pass
C:
	;...
	LEA	C(PC),A5				; 8 cy
	MOVE.L	(a0),LABEL40-C(A5)	; 24 cy
	;...
	
	nop	
;-------------------------------;	
exit:
	nop							; an dieser Stelle ist die Aufgabe erledigt
	move.w #$C000,$dff09a		; Interrupts enable
	rts

label40:
	dc.l	$AABBCCDD

	end

;------------------------------------------------------------------------------
r
Filename: Listing13i3.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
>d pc
00021c60 66f6                     bne.b #$f6 == $00021c58 (T)
00021c62 4e71                     nop
00021c64 4df9 00df f002           lea.l $00dff002,a6
00021c6a 4bfa fff8                lea.l (pc,$fff8) == $00021c64,a5
00021c6e 2b7c 0000 0123 002a      move.l #$00000123,(a5,$002a) == $0000002a [082800fc]
00021c76 203a 0016                move.l (pc,$0016) == $00021c8e [22223333],d0
00021c7a 2b40 002e                move.l d0,(a5,$002e) == $0000002e [082a00fc]
00021c7e 2d7c 0000 0400 0094      move.l #$00000400,(a6,$0094) == $00000094 [00fc0840]
00021c86 6000 7fc0                bra.w #$7fc0 == $00029c48 (T)
00021c8a 1234 5678                move.b (a4,d5.W[*8],$78) == $00000078 (68020+) [00],d1
>f 21c64
Breakpoint added.
>

;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 6370776 Chip, 12741552 CPU. (V=105 H=10 -> V=0 H=31)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4df9 (LEA) 00df (ILLEGAL) Chip latch 000000DF
00021c64 4df9 00df f002           lea.l $00dff002,a6
Next PC: 00021c6a
;------------------------------------------------------------------------------
>t
Cycles: 6 Chip, 12 CPU. (V=0 H=31 -> V=0 H=37)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00DFF002   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4bfa (LEA) fff8 (ILLEGAL) Chip latch 0000FFF8
00021c6a 4bfa fff8                lea.l (pc,$fff8) == $00021c64,a5
Next PC: 00021c6e
;------------------------------------------------------------------------------
>t
Cycles: 4 Chip, 8 CPU. (V=0 H=37 -> V=0 H=41)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00021C64   A6 00DFF002   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 2b7c (MOVE) 0000 (OR) Chip latch 00000000
00021c6e 2b7c 0000 0123 002a      move.l #$00000123,(a5,$002a) == $00021c8e [22223333]
Next PC: 00021c76
;------------------------------------------------------------------------------
>t
Cycles: 12 Chip, 24 CPU. (V=0 H=41 -> V=0 H=53)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00021C64   A6 00DFF002   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 203a (MOVE) 0016 (OR) Chip latch 00000016
00021c76 203a 0016                move.l (pc,$0016) == $00021c8e [00000123],d0
Next PC: 00021c7a
;------------------------------------------------------------------------------
>t
Cycles: 8 Chip, 16 CPU. (V=0 H=53 -> V=0 H=61)
  D0 00000123   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00021C64   A6 00DFF002   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 2b40 (MOVE) 002e (OR) Chip latch 0000002E
00021c7a 2b40 002e                move.l d0,(a5,$002e) == $00021c92 [44445555]
Next PC: 00021c7e
;------------------------------------------------------------------------------
>t
Cycles: 8 Chip, 16 CPU. (V=0 H=61 -> V=0 H=69)
  D0 00000123   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00021C64   A6 00DFF002   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 2d7c (MOVE) 0000 (OR) Chip latch 00000000
00021c7e 2d7c 0000 0400 0094      move.l #$00000400,(a6,$0094) == $00dff096
Next PC: 00021c86
;------------------------------------------------------------------------------
>t
Cycles: 12 Chip, 24 CPU. (V=0 H=69 -> V=0 H=81)
  D0 00000123   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00021C64   A6 00DFF002   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 6000 (Bcc) 7fc0 (ILLEGAL) Chip latch 00007FC0
00021c86 6000 7fc0                bra.w #$7fc0 == $00029c48 (T)
Next PC: 00021c8a
;------------------------------------------------------------------------------
>d 29c48
00029c48 4bfa fffe                lea.l (pc,$fffe) == $00029c48,a5
00029c4c 2b40 8042                move.l d0,(a5,-$7fbe) == $00019ca6 [00000000]
00029c50 6000 7ff6                bra.w #$7ff6 == $00031c48 (T)
00029c54 0000 0000                or.b #$00,d0
00029c58 0000 0000                or.b #$00,d0
00029c5c 0000 0000                or.b #$00,d0
00029c60 0000 0000                or.b #$00,d0
00029c64 0000 0000                or.b #$00,d0
00029c68 0000 0000                or.b #$00,d0
00029c6c 0000 0000                or.b #$00,d0
;------------------------------------------------------------------------------
>t
Cycles: 5 Chip, 10 CPU. (V=0 H=81 -> V=0 H=86)
  D0 00000123   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00021C64   A6 00DFF002   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4bfa (LEA) fffe (ILLEGAL) Chip latch 0000FFFE
00029c48 4bfa fffe                lea.l (pc,$fffe) == $00029c48,a5
Next PC: 00029c4c
;------------------------------------------------------------------------------
>t
Cycles: 4 Chip, 8 CPU. (V=0 H=86 -> V=0 H=90)
  D0 00000123   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00029C48   A6 00DFF002   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 2b40 (MOVE) 8042 (OR) Chip latch 00008042
00029c4c 2b40 8042                move.l d0,(a5,-$7fbe) == $00021c8a [12345678]
Next PC: 00029c50
;------------------------------------------------------------------------------
>t
Cycles: 8 Chip, 16 CPU. (V=0 H=90 -> V=0 H=98)
  D0 00000123   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00029C48   A6 00DFF002   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 6000 (Bcc) 7ff6 (ILLEGAL) Chip latch 00007FF6
00029c50 6000 7ff6                bra.w #$7ff6 == $00031c48 (T)
Next PC: 00029c54
;------------------------------------------------------------------------------
>d 31c48
00031c48 4bfa fffe                lea.l (pc,$fffe) == $00031c48,a5
00031c4c 2b50 0016                move.l (a0) [00000000],(a5,$0016) == $00029c5e [00000000]
00031c50 4e71                     nop
00031c52 4e71                     nop
00031c54 33fc c000 00df f09a      move.w #$c000,$00dff09a
00031c5c 4e75                     rts  == $00c4f6d8
00031c5e aabb                     illegal
00031c60 ccdd                     mulu.w (a5)+ [4bfa],d6
00031c62 0000 1234                or.b #$34,d0
00031c66 5678 0000                addq.w #$03,$0000 [0000]
;------------------------------------------------------------------------------
>t
Cycles: 5 Chip, 10 CPU. (V=0 H=98 -> V=0 H=103)
  D0 00000123   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00029C48   A6 00DFF002   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4bfa (LEA) fffe (ILLEGAL) Chip latch 0000FFFE
00031c48 4bfa fffe                lea.l (pc,$fffe) == $00031c48,a5
Next PC: 00031c4c
;------------------------------------------------------------------------------
>t
Cycles: 4 Chip, 8 CPU. (V=0 H=103 -> V=0 H=107)
  D0 00000123   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00031C48   A6 00DFF002   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 2b50 (MOVE) 0016 (OR) Chip latch 00000016
00031c4c 2b50 0016                move.l (a0) [00000000],(a5,$0016) == $00031c5e [aabbccdd]
Next PC: 00031c50
;------------------------------------------------------------------------------
>t
Cycles: 12 Chip, 24 CPU. (V=0 H=107 -> V=0 H=119)
  D0 00000123   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00031C48   A6 00DFF002   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 4e71 (NOP) Chip latch 00004E71
00031c50 4e71                     nop
Next PC: 00031c52
;------------------------------------------------------------------------------
>fd
All breakpoints removed.
>x
