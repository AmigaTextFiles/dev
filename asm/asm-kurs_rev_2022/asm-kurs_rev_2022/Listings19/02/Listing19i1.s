
; Listing19i1.s
; Copper Debugger - Scanline, CCK
; 
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

; fc <CCKs to wait>     Wait n color clocks.

;------------------------------------------------------------------------------

start:
	move.w #$4000,$dff09a		; Interrupts disable
loop: 
	move.l $dff004,d0
	and.l #$000fff00,d0
	cmp.l #$00013700,d0
	bne.s loop

	;bsr somethingtodo
	btst #6,$bfe001
	bne loop
	move.w #$C000,$dff09a		; Interrupts enable	
	rts
	
	end

;------------------------------------------------------------------------------
>r
Filename:Listing19i1.s
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

>t																				
Cycles: 5 Chip, 10 CPU. (V=210 H=49 -> V=210 H=54)								; step through the program to know the buscycles
	D0 0000D200   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 00df (ILLEGAL) 2039 (MOVE) Chip latch 00000000
00021CB4 2039 00df f004           MOVE.L $00dff004,D0			
Next PC: 00021cba
;------------------------------------------------------------------------------
>t
Cycles: 10 Chip, 20 CPU. (V=210 H=54 -> V=210 H=64)
	D0 8000D23A   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 000f (ILLEGAL) 0280 (AND) Chip latch 00000000
00021CBA 0280 000f ff00           AND.L #$000fff00,D0
Next PC: 00021cc0
;------------------------------------------------------------------------------
>t
Cycles: 8 Chip, 16 CPU. (V=210 H=64 -> V=210 H=72)
	D0 0000D200   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0001 (OR) 0c80 (CMP) Chip latch 00000000
00021CC0 0c80 0001 3700           CMP.L #$00013700,D0
Next PC: 00021cc6
;------------------------------------------------------------------------------
>t
Cycles: 7 Chip, 14 CPU. (V=210 H=72 -> V=210 H=79)
	D0 0000D200   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 0839 (BTST) 66ec (Bcc) Chip latch 00000000
00021CC6 66ec                     BNE.B #$ec == $00021cb4 (T)
Next PC: 00021cc8
;------------------------------------------------------------------------------
>t
Cycles: 5 Chip, 10 CPU. (V=210 H=79 -> V=210 H=84)
	D0 0000D200   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 00df (ILLEGAL) 2039 (MOVE) Chip latch 00000000
00021CB4 2039 00df f004           MOVE.L $00dff004,D0
Next PC: 00021cba
>
;------------------------------------------------------------------------------
																				;								 buscycles										HPOS
																				; MOVE.L $00dff004,D0			;	10			; Cycles: 10 Chip, 20 CPU. (V=210 H=54 -> V=210 H=64)
																				; AND.L #$000fff00,D0			;	8			; Cycles: 8 Chip, 16 CPU. (V=210 H=64 -> V=210 H=72)	
																				; CMP.L #$00013700,D0			;	7			; Cycles: 7 Chip, 14 CPU. (V=210 H=72 -> V=210 H=79)	
																				; BNE.B #$ec == $00021cb4 (T)	;   5			; Cycles: 5 Chip, 10 CPU. (V=210 H=79 -> V=210 H=84)
																												; Sum = 30
;------------------------------------------------------------------------------
>fc 30																			; fc <CCKs to wait>     Wait n color clocks.	
; Cycles: 30 Chip, 60 CPU. (V=210 H=84 -> V=210 H=114)							; we start from here: V=210 H=84
	D0 0000D200   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 00df (ILLEGAL) 2039 (MOVE) Chip latch 00000000
00021CB4 2039 00df f004           MOVE.L $00dff004,D0							; one round further , 30 cycles
Next PC: 00021cba
;------------------------------------------------------------------------------
>t
Cycles: 10 Chip, 20 CPU. (V=210 H=114 -> V=210 H=124)							; now on H=114	(H=84+30=114)
	D0 8000D276   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 000f (ILLEGAL) 0280 (AND) Chip latch 00000000
00021CBA 0280 000f ff00           AND.L #$000fff00,D0							; now on HPOS=124
Next PC: 00021cc0

;------------------------------------------------------------------------------
>fc 60																			; fc <CCKs to wait>     Wait n color clocks.
; Cycles: 60 Chip, 120 CPU. (V=210 H=124 -> V=210 H=184)						; we start from here: V=210 H=84
	D0 8000D2B2   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 000f (ILLEGAL) 0280 (AND) Chip latch 00000000
00021CBA 0280 000f ff00           AND.L #$000fff00,D0							; two rounds further , 60 cycles
Next PC: 00021cc0
;------------------------------------------------------------------------------
>t
Cycles: 8 Chip, 16 CPU. (V=210 H=184 -> V=210 H=192)							; now on H=184	(H=124+60=184)
	D0 0000D200   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0001 (OR) 0c80 (CMP) Chip latch 00000000
00021CC0 0c80 0001 3700           CMP.L #$00013700,D0
Next PC: 00021cc6

;------------------------------------------------------------------------------
; first and last HPOS?

>fc 1																			; we can not wait only one cck
	D0 0000D200   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0001 (OR) 0c80 (CMP) Chip latch 00000000
00021CC0 0c80 0001 3700           CMP.L #$00013700,D0
Next PC: 00021cc6
;------------------------------------------------------------------------------
>c																				; program runs the next cck from the actual instruction
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 0009d5 (00095a) ALARM 000000    CYC=83CEA600
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 009734 (000000) ALARM 0000ac    CLK=2
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 9E92 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 23f0 INTENA: 202c (202c) INTREQ: 0068 (0068) VPOS: d2 HPOS: de			; HPOS=$de=222
INT: 0028 IPL: -1
COP1LC: 00000420, COP2LC: 0001f280 COPPTR: 0001f314
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: a200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 100106.82 ms [frames: 675 time: 67572101]
;------------------------------------------------------------------------------
>fc 1																			; we can not wait only one cck
	D0 0000D200   D1 00000000   D2 00000000   D3 00000000						; executes the next instruction
	D4 00000000   D5 00000000   D6 00000000   D7 00000000						; CMP.L #$00013700,D0 which needs 7 cycles
	A0 00000000   A1 00000000   A2 00000000   A3 00000000						; so, VPOS: d2 HPOS: de	--> VPOS: d3 HPOS: 2
	A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8						; HPOS=$de=222+7 = 229; if 226 is the last 
USP  00C63CE8 ISP  00C64CE8														; so if are on the next line
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0									; $de=222+5=227 = $E3
Prefetch 0839 (BTST) 66ec (Bcc) Chip latch 00000000								; then next VPOS scanline and HPOS=2
00021CC6 66ec                     BNE.B #$ec == $00021cb4 (T)
Next PC: 00021cc8
;------------------------------------------------------------------------------
>c																				; program runs the next cck from the actual instruction
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 0009d5 (00095a) ALARM 000000    CYC=83CEB400
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 009735 (000000) ALARM 0000ac    CLK=2
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 9E92 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 23f0 INTENA: 202c (202c) INTREQ: 0068 (0068) VPOS: d3 HPOS: 2			; HPOS=2	(we are in the next scanline)
INT: 0028 IPL: -1
COP1LC: 00000420, COP2LC: 0001f280 COPPTR: 0001f314
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: a200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 100106.82 ms [frames: 675 time: 67572101]
;------------------------------------------------------------------------------
>t
Cycles: 5 Chip, 10 CPU. (V=211 H=2 -> V=211 H=7)
	D0 0000D200   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 00df (ILLEGAL) 2039 (MOVE) Chip latch 00000000
00021CB4 2039 00df f004           MOVE.L $00dff004,D0
Next PC: 00021cba
>
;------------------------------------------------------------------------------

; help from ross

move.l #3,d0 ; 12 cycles (instruction timing)

t
Cycles: 6 Chip, 12 CPU. (V=74 H=180 -> V=74 H=186)
D0 00000003 D1 00000000 D2 00000000 D3 00000000
D4 00000000 D5 00000000 D6 00000000 D7 00000000
A0 00000000 A1 00000000 A2 00000000 A3 00000000
A4 00000000 A5 00000000 A6 00000000 A7 00C60DB0
USP 00C60DB0 ISP 00C61DB0
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch d1fc (ADDA) 4280 (CLR) Chip latch 00000000
00025768 4280 CLR.L D0
Next PC: 0002576a


1. What does CCK (Color Clocks) mean?

CPU cycles are doubled in respect to internal/custom chips BUS cycles.
1 CCK = 1 chip cycle = 3546895Hz on PAL (281.94ns).
Of course CPU clock on PAL 68k A500 is 7093790Hz (double this for PAL 020 A1200).

Mainboard main crystal clock is 28375160Hz (chip clock*8); from this all the others
are derived (comprised the submultiple 90/180/270° different phase one).
With this clock you can display the 35ns super-hires pixels on ECS/AGA.

2. also what means cycles? .. Cycles: 6 Chip, 12 CPU

Move.l #3,d0 ; 12 cycles (instruction timing)
I can find this value 12(3/0) in the execution times table.
But where can I found this value 6 Chip cycles?

Usually you don't need to know the BUS cycles in relation to the CPU cycles
(which in any case are usually half).
The speech would become complicated because it depends on the DMA activity on
the BUS which on the Amiga is very high (fortunately, because it means that it
is a well-designed architecture!)

That instruction is known from the reported values that requires 3 accesses to
the memory (4 * 3 cycles), that is the duration of 6 internal BUS cycles.
But if the code is in chip memory then there can be contention and access will
take more than 12 CPU cycles (in fast ram this instruction require 12 cycles in
any condition).
However there is the alternative equal instruction which is moveq #3,d0, that
requires 4 cycles and a single access to the BUS.


