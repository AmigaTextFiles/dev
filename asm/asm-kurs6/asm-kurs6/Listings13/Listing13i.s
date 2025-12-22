
; Listing13i.s	; mehrere Register auf einmal laden
; Zeile 1660

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;

bsp1:							; 260 cy to next nop
	lea	$dff180,a6
	movem.l	Colours(pc),d0-a5	; wir laden 14 Langwörter oder 28 Wörter
	movem.l	d0-a5,(a6)			; setzt 28 Farben auf einmal!!
	nop							; 108 cy to next nop
;-------------------------------;

bsp2:								
; Oder wenn Sie zu Beginn einer Routine viele Register laden müssen:
	MOVE.L	#$4232,D0
	MOVE.W	#$F20,D1
	MOVE.W	#$7FFF,D2
	MOVEQ	#0,D3
	MOVE.L	#123456,D4
	LEA	$DFF000,A0
	LEA	$BFE001,A1
	LEA	$BFD100,A2
	LEA	Schermo,A3
	LEA	BUFFER,A4
	nop							; 102 cy to next nop

; All dies kann mit nur 1 Routine zusammengefasst werden:
	MOVEM.L	VariaRoba(PC),D0-D4/A0-A4
;-------------------------------;	
	nop
	move.w #$C000,$dff09a		; Interrupts enable
	rts

Colours:						; ok this is from a copperlist
	dc.w  $180,$005A ; COLOR00  ; only an example...
	dc.w  $182,$0FFF ; COLOR01
	dc.w  $184,$0002 ; COLOR02
	dc.w  $186,$0F80 ; COLOR03
	dc.w  $188,$0000 ; COLOR04
	dc.w  $18A,$0000 ; COLOR05
	dc.w  $18C,$0000 ; COLOR06
	dc.w  $18E,$0000 ; COLOR07
	dc.w  $190,$0000 ; COLOR08
	dc.w  $192,$0000 ; COLOR09
	dc.w  $194,$0000 ; COLOR10
	dc.w  $196,$0000 ; COLOR11
	dc.w  $198,$0000 ; COLOR12
	dc.w  $19A,$0000 ; COLOR13
	dc.w  $19C,$0000 ; COLOR14
	dc.w  $19E,$0000 ; COLOR15
	dc.w  $1A0,$0000 ; COLOR16
	dc.w  $1A2,$0FFC ; COLOR17
	dc.w  $1A4,$0DEA ; COLOR18
	dc.w  $1A6,$0AC7 ; COLOR19
	dc.w  $1A8,$07B6 ; COLOR20
	dc.w  $1AA,$0494 ; COLOR21
	dc.w  $1AC,$0284 ; COLOR22
	dc.w  $1AE,$0164 ; COLOR23
	dc.w  $1B0,$0044 ; COLOR24
	dc.w  $1B2,$0023 ; COLOR25
	dc.w  $1B4,$0001 ; COLOR26
	dc.w  $1B6,$0F80 ; COLOR27
	dc.w  $1B8,$0C40 ; COLOR28
	dc.w  $1BA,$0820 ; COLOR29
	dc.w  $1BC,$0500 ; COLOR30
	dc.w  $1BE,$0200 ; COLOR31
	
VariaRoba:
	dc.l	$4243		; d0
	dc.l	$f20		; d1
	dc.l	$7fff		; d2
	dc.l	0			; d3
	dc.l	$123456		; d4
	dc.l	$dff000		; a0
	dc.l	$bfe001		; a1
	dc.l	$bfd100		; a2
	dc.l	Schermo		; a3
	dc.l	Buffer		; a4

Schermo:
	dc.l $ff

Buffer:
	dc.l $11

	end

;------------------------------------------------------------------------------
r
Filename: Listing13i1.s
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
0002162c 66f6                     bne.b #$f6 == $00021624 (T)
0002162e 4df9 00df f180           lea.l $00dff180,a6
00021634 4cfa 3fff 0050           movem.l (pc,$0050) == $00021688,d0-d7/a0-a5
0002163a 48d6 3fff                movem.l d0-d7/a0-a5,(a6)
0002163e 4e71                     nop
00021640 203c 0000 4232           move.l #$00004232,d0
00021646 323c 0f20                move.w #$0f20,d1
0002164a 343c 7fff                move.w #$7fff,d2
0002164e 7600                     moveq #$00,d3
00021650 283c 0001 e240           move.l #$0001e240,d4
>fl
No breakpoints.
>f 2162e
Breakpoint added.
>
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 7910510 Chip, 15821020 CPU. (V=105 H=0 -> V=210 H=14)
  D0 00004243   D1 00000F20   D2 00007FFF   D3 00000000
  D4 00123456   D5 018A0000   D6 018C0000   D7 018E0000
  A0 00DFF000   A1 00BFE001   A2 00BFD100   A3 00021726
  A4 0002172A   A5 019A0000   A6 00DFF180   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4df9 (LEA) 00df (ILLEGAL) Chip latch 000000DF
0002162e 4df9 00df f180           lea.l $00dff180,a6
Next PC: 00021634
>fi nop
Cycles: 130 Chip, 260 CPU. (V=210 H=14 -> V=210 H=144)
  D0 0180005A   D1 01820FFF   D2 01840002   D3 01860F80
  D4 01880000   D5 018A0000   D6 018C0000   D7 018E0000
  A0 01900000   A1 01920000   A2 01940000   A3 01960000
  A4 01980000   A5 019A0000   A6 00DFF180   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 203c (MOVE) Chip latch 0000203C
0002163e 4e71                     nop
Next PC: 00021640
>fi nop
Cycles: 54 Chip, 108 CPU. (V=210 H=144 -> V=210 H=198)
  D0 00004232   D1 01820F20   D2 01847FFF   D3 00000000
  D4 0001E240   D5 018A0000   D6 018C0000   D7 018E0000
  A0 00DFF000   A1 00BFE001   A2 00BFD100   A3 00021730
  A4 00021734   A5 019A0000   A6 00DFF180   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 4cfa (MVMEL) Chip latch 00004CFA
00021674 4e71                     nop
Next PC: 00021676
>fi nop
Cycles: 51 Chip, 102 CPU. (V=210 H=198 -> V=211 H=22)
  D0 00004243   D1 00000F20   D2 00007FFF   D3 00000000
  D4 00123456   D5 018A0000   D6 018C0000   D7 018E0000
  A0 00DFF000   A1 00BFE001   A2 00BFD100   A3 00021730
  A4 00021734   A5 019A0000   A6 00DFF180   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 33fc (MOVE) Chip latch 000033FC
0002167c 4e71                     nop
Next PC: 0002167e
>

