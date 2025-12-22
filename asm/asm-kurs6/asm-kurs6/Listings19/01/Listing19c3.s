
; Listing19c3.s
; debugging an assembler program with a programm breakpoint
; start and run from asmone	
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

;  f <address>           Add/remove breakpoint.
;  fl                    List breakpoints.
;  fd                    Remove all breakpoints.
;  d <address> [<lines>] Disassembly starting at <address>.
;  t [instructions]      Step one or more instructions.
;  fi                    Step forward until PC points to RTS, RTD or RTE.
;  a <address>           Assembler.
;------------------------------------------------------------------------------

start:

waitmouse:  
	btst	#6,$bfe001	; left mousebutton?
	bne.s	Waitmouse	

	move.w	#0,d0		; Set i do 0
	
.loop:	
	cmp.w	#31,d0		; is i = 31?
	beq	.done			; yes, take branch
	add.w	#1,d0		; no, add 1 to i
; do something
	bra	.loop			; continue loop

.done:
	nop
	
.exit:  moveq	#0,d0
	rts
	end

;------------------------------------------------------------------------------
>r
Filename:Listing19c4.s
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
00022CC0 66f6                     BNE.B #$f6 == $00022cb8 (T)
00022CC2 303c 0000                MOVE.W #$0000,D0
00022CC6 0c40 001f                CMP.W #$001f,D0
00022CCA 6700 000a                BEQ.W #$000a == $00022cd6 (F)
00022CCE 0640 0001                ADD.W #$0001,D0
00022CD2 6000 fff2                BT .W #$fff2 == $00022cc6 (T)
00022CD6 4e71                     NOP
00022CD8 7000                     MOVEQ #$00,D0
00022CDA 4e75                     RTS
00022CDC 1234 5678                MOVE.B (A4,D5.W[*8],$78) == $00000078 (68020+) [00],D1
>f 22CC2																		; step 2 - set breakpoint
Breakpoint added.
>x																				; leave the debugger
;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button		
																				; now click left mousebutton and the Debugger 
																				; reopens and wait on this line
>d pc																			; the actual program
00022CC2 303c 0000                MOVE.W #$0000,D0
00022CC6 0c40 001f                CMP.W #$001f,D0								; now we want change the line cmp.w	#31,d0	; is i = 31?
00022CCA 6700 000a                BEQ.W #$000a == $00022cd6 (T)					; in a nop and BEQ.W in BRA
00022CCE 0640 0001                ADD.W #$0001,D0
00022CD2 6000 fff2                BT .W #$fff2 == $00022cc6 (T)
00022CD6 4e71                     NOP
00022CD8 7000                     MOVEQ #$00,D0
00022CDA 4e75                     RTS
00022CDC 1234 5678                MOVE.B (A4,D5.W[*8],$78) == $00000078 (68020+) [00],D1
00022CE0 0002 2d58                OR.B #$58,D2
;------------------------------------------------------------------------------																																						
>a 22CC6																		; step 3 - after insert, don't forget to press Enter
00022CC6 >nop																	; a cmp.w is 2 words long
00022CC6 4e71                     NOP											; a nop is one word 			
00022CC8 >nop																	; therefore we set 2 nop
00022CC8 4e71                     NOP											; 
00022CCA >bra 22CD6																; for the beq.w we set a bra <adress>
00022CCA 6000 000a                BT .W #$000a == $00022cd6 (T)
00022CCE >																		; Enter
;------------------------------------------------------------------------------	
>d pc																			; watch the result
00022CC2 303c 0000                MOVE.W #$0000,D0
00022CC6 4e71                     NOP											; this was CMP.W #$001f,D0
00022CC8 4e71                     NOP											; this was CMP.W #$001f,D0
00022CCA 6000 000a                BT .W #$000a == $00022cd6 (T)					; this was BEQ.W #$000a == $00022cd6 (T)
00022CCE 0640 0001                ADD.W #$0001,D0
00022CD2 6000 fff2                BT .W #$fff2 == $00022cc6 (T)
00022CD6 4e71                     NOP
00022CD8 7000                     MOVEQ #$00,D0
00022CDA 4e75                     RTS
00022CDC 1234 5678                MOVE.B (A4,D5.W[*8],$78) == $00000078 (68020+) [00],D1
;------------------------------------------------------------------------------	
>t																				; step 4 - trace (one step)
Cycles: 4 Chip, 8 CPU. (V=210 H=20 -> V=210 H=24)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 4e71 (NOP) Chip latch 00000000
00022CC6 4e71                     NOP
Next PC: 00022cc8
>t																				; step 5 - trace (one step)
Cycles: 2 Chip, 4 CPU. (V=210 H=24 -> V=210 H=26)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6000 (Bcc) 4e71 (NOP) Chip latch 00000000
00022CC8 4e71                     NOP
Next PC: 00022cca
>t																				; step 6 - trace (one step)
Cycles: 2 Chip, 4 CPU. (V=210 H=26 -> V=210 H=28)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 000a (ILLEGAL) 6000 (Bcc) Chip latch 00000000
00022CCA 6000 000a                BT .W #$000a == $00022cd6 (T)
Next PC: 00022cce
>t																				; step 7 - trace (one step)
Cycles: 5 Chip, 10 CPU. (V=210 H=28 -> V=210 H=33)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 7000 (MOVE) 4e71 (NOP) Chip latch 00000000
00022CD6 4e71                     NOP
Next PC: 00022cd8
>fi																				; step 8 - step forward until PC points to RTS
Cycles: 4 Chip, 8 CPU. (V=210 H=33 -> V=210 H=37)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 1234 (MOVE) 4e75 (RTS) Chip latch 00000000
00022CDA 4e75                     RTS
Next PC: 00022cdc
>x

	end

We hacked this little program.