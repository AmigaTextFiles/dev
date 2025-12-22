
; Listing19c2.s
; debugging an assembler program with a programm breakpoint
; start and run from asmone	
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

; change to Console Debugger with xx and restart WinUAE

;  f <address>           Add/remove breakpoint.
;  fl                    List breakpoints.
;  fd                    Remove all breakpoints.
;  d <address> [<lines>] Disassembly starting at <address>.
;  t [instructions]      Step one or more instructions.
;  fi                    Step forward until PC points to RTS, RTD or RTE.
;  z    Step through one instruction - useful for JSR, DBRA etc.
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
Filename:Listing19c2.s
>a
Pass1
Pass2
No Errors
>j
																				; start the programm
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
>d pc
00026CF0 0839 0006 00bf e001      BTST.B #$0006,$00bfe001
00026CF8 66f6                     BNE.B #$f6 == $00026cf0 (T)
00026CFA 303c 0000                MOVE.W #$0000,D0								; set breakpoint on this line
00026CFE 0c40 001f                CMP.W #$001f,D0
00026D02 6700 000a                BEQ.W #$000a == $00026d0e (F)
00026D06 0640 0001                ADD.W #$0001,D0
00026D0A 6000 fff2                BT .W #$fff2 == $00026cfe (T)
00026D0E 4e71                     NOP
00026D10 7000                     MOVEQ #$00,D0
00026D12 4e75                     RTS
>f 26CFA																		; step 2 - set breakpoint
Breakpoint added.
>x																				; leave the debugger
	
;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button
																				; now click left mousebutton and the debugger reopens
																				; and wait on this line

>r																				; step 3 - the actual state of the register
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60E08
USP  00C60E08 ISP  00C61E08
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0000 (OR) 303c (MOVE) Chip latch 00000000
00026CFA 303c 0000                MOVE.W #$0000,D0								; we waiting on this line	
Next PC: 00026cfe
;------------------------------------------------------------------------------
>d pc																			; disassembled programm
00026CFA 303c 0000                MOVE.W #$0000,D0								; we waiting on this line
00026CFE 0c40 001f                CMP.W #$001f,D0
00026D02 6700 000a                BEQ.W #$000a == $00026d0e (T)
00026D06 0640 0001                ADD.W #$0001,D0
00026D0A 6000 fff2                BT .W #$fff2 == $00026cfe (T)
00026D0E 4e71                     NOP
00026D10 7000                     MOVEQ #$00,D0
00026D12 4e75                     RTS
00026D14 1234 5678                MOVE.B (A4,D5.W[*8],$78) == $00000078 (68020+) [00],D1
00026D18 0000 0000                OR.B #$00,D0
;------------------------------------------------------------------------------
>t																				; step 4 - try several times the t command
Cycles: 4 Chip, 8 CPU. (V=105 H=28 -> V=105 H=32)								; and observe the registers
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60E08
USP  00C60E08 ISP  00C61E08
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 001f (OR) 0c40 (CMP) Chip latch 00000000
00026CFE 0c40 001f                CMP.W #$001f,D0
Next PC: 00026d02
;------------------------------------------------------------------------------
>t21																			; step 5 - more then one step
Cycles: 99 Chip, 198 CPU. (V=105 H=32 -> V=105 H=131)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000							; watch register d0
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60E08
USP  00C60E08 ISP  00C61E08
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 000a (ILLEGAL) 6700 (Bcc) Chip latch 00000000
00026D02 6700 000a                BEQ.W #$000a == $00026d0e (F)
Next PC: 00026d06
;------------------------------------------------------------------------------
>d pc
00026D02 6700 000a                BEQ.W #$000a == $00026d0e (F)
00026D06 0640 0001                ADD.W #$0001,D0
00026D0A 6000 fff2                BT .W #$fff2 == $00026cfe (T)
00026D0E 4e71                     NOP
00026D10 7000                     MOVEQ #$00,D0
00026D12 4e75                     RTS
00026D14 1234 5678                MOVE.B (A4,D5.W[*8],$78) == $00000078 (68020+) [00],D1
00026D18 0000 0000                OR.B #$00,D0
;------------------------------------------------------------------------------
>z																				; step 6 - z works if bra .loop is the next command 
Cycles: 6 Chip, 12 CPU. (V=105 H=131 -> V=105 H=137)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60E08
USP  00C60E08 ISP  00C61E08
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 0001 (OR) 0640 (ADD) Chip latch 00000000
00026D06 0640 0001                ADD.W #$0001,D0
Next PC: 00026d0a
;------------------------------------------------------------------------------
>z																				; step 7 - z works if bra .loop is the next command 
Cycles: 4 Chip, 8 CPU. (V=105 H=137 -> V=105 H=141)
  D0 00000006   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60E08
USP  00C60E08 ISP  00C61E08
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch fff2 (ILLEGAL) 6000 (Bcc) Chip latch 00000000
00026D0A 6000 fff2                BT .W #$fff2 == $00026cfe (T)
Next PC: 00026d0e
;------------------------------------------------------------------------------
>z																				; step 8 - z now !
Cycles: 489 Chip, 978 CPU. (V=105 H=141 -> V=107 H=176)
  D0 0000001F   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60E08
USP  00C60E08 ISP  00C61E08
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 7000 (MOVE) 4e71 (NOP) Chip latch 00000000
00026D0E 4e71                     NOP
Next PC: 00026d10
;------------------------------------------------------------------------------
>fi																				; step 9 - go to rts (Step forward until PC
Cycles: 4 Chip, 8 CPU. (V=107 H=176 -> V=107 H=180)								; points to RTS, RTD or RTE.)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60E08
USP  00C60E08 ISP  00C61E08
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 1234 (MOVE) 4e75 (RTS) Chip latch 00000000
00026D12 4e75                     RTS										   ; rts
Next PC: 00026d14
;------------------------------------------------------------------------------
>d pc 3
00026D12 4e75                     RTS
00026D14 1234 5678                MOVE.B (A4,D5.W[*8],$78) == $00000078 (68020+) [00],D1
00026D18 0000 0000                OR.B #$00,D0
>x																				; leave the debugger

	end

Note:
The z-command steps through the part of code if bra is the next command,
else the z works like the t command. Also you can see information on how
many clock cycles or which raster time has elapsed.