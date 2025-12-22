
; Listing19d1.s
;
; memory-watchpoint: possible combinations and explanations
;
; w <num> <address> <length> <R/W/I/F/C> [<value>[.x]] 
;						 (read/write/opcode/freeze/mustchange).
;                        Add/remove memory watchpoints.
1. w
2. w <num>	= w [0 - 7]
3. w <num> <address>
4. w <num> <address> <length>
5. w <num> <address> <length> <R/W/I/F/C>
6. w <num> <address> <length> <R/W/I/F/C> [<value>[.x]]
7. w <num> <address> <length> <R/W/I/F/C> [<value>[.x]] <channel>

different combinations are possible	with 2 options
8. w <num> <R/W/I/F/C>

different combinations are possible	with 3 options
9.  w <num> <address> <R/W/I/F/C>
10. w <num> <address> [<value>[.x]]
11. w <num> <address> <channel>

different combinations are possible	with 4 options
12. w <num> <address> <length> <channel
13. w <num> <address> <R/W/I/F/C> <channel> 

different combinations are possible	with 5 options
14. w <num> <address> <length> <R/W/I/F/C> <channel> 

;------------------------------------------------------------------------------
																				; 1. 
																				; w	list all memory watchpoints
>w
 0: 00029052 - 0002905B (10) RWI L CPU
;------------------------------------------------------------------------------
																				; 2. 
																				; w <num>	= w [0 - 7]	delete the numbered memory watchpoint
>w 0																			; w <num> deletes watchpoint <num>.
Memwatch 0 removed
;------------------------------------------------------------------------------
																				; 3.
																				; w <num> <address>	
																				; If address is specified, watchpoint <num> is set to address.
																				; To use another watchpoint change the watchpoint number to 1, 2, 3 etc.
>w 0 29052
 0: 00029052 - 00029052 (1) RWI CPU
>w 0 100
 0: 00000100 - 00000100 (1) RWI CPU 
;------------------------------------------------------------------------------
																				; 4. 
																				; w <num> <address> <length>
>w 0 100 2																		; length here 2 bytes
 0: 00000100 - 00000101 (2) RWI CPU												; range bytes 100 and 101
>w 0 1000 $1100-$100															; also possible a term for the length
 0: 00001000 - 00001FFF (4096) RWI CPU		
>w 0 1000 $1000																	; its the same												
 0: 00001000 - 00001FFF (4096) RWI CPU
 
;------------------------------------------------------------------------------
																				; 5. 
																				; w <num> <address> <length> <R/W/I/F/C>
>w 1 20000 A R

>w 2 20000 %101 W
;------------------------------------------------------------------------------
																				; 6.
																				; w <num> <address> <length> <R/W/I/F/C> [<value>[.x]]

>w 0 100 10 W !345

>w 0 1000 10 R 23.l

;------------------------------------------------------------------------------
																				; 7.
																				; w <num> <address> <length> <R/W/I/F/C> [<value>[.x]] <channel>

>w 0 100 10 W !345 ALL
0: 00000100 - 0000010F (16)  W  =159.w ALL
>w 0 1000 10 R !35 COP
0: 00001000 - 0000100F (16) R   =23.b COP
>w 0 1000 10 R 23.l COP
0: 00001000 - 0000100F (16) R   =23.l COP
>w 0 1000 10 R 23.b COP
0: 00001000 - 0000100F (16) R   =23.b COP
>w 0 1000 10 R 23.w COP
0: 00001000 - 0000100F (16) R   =23.w COP
;------------------------------------------------------------------------------
																				; 8.
																				; w <num> <R/W/I/F/C>

>w 0 R
Memwatch breakpoints enabled
>w 0 W

;------------------------------------------------------------------------------
																				; 9.
																				; w <num> <address> <R/W/I/F/C>
>w 0 1000 R

;------------------------------------------------------------------------------
																				; 10.
																				; w <num> <address> [<value>[.x]]
>w 0 $dff058 2																	; You can set memwatch point to BLTSIZE to detect start of blits
Memwatch breakpoints enabled
 0: 00DFF058 - 00DFF059 (2) RWI CPU
>g
Memwatch 0: break at 00DFF058.W  W  00000050 PC=0002A5DC CPUDW (000)
Cycles: 50942 Chip, 101884 CPU. (V=105 H=10 -> V=16 H=104)
  D0 00001000   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0839 (BTST) 0002 (OR) Chip latch 00000002
0002a5dc 33fc 0050 00df f058      move.w #$0050,$00dff058
0002a5e4 0839 0002 00df f016      btst.b #$0002,$00dff016
Next PC: 0002a5ec																		

;------------------------------------------------------------------------------
																				; 11.
																				; w <num> <address> <channel>
>w 0 29052
 0: 00029052 - 00029052 (1) RWI CPU
>w 0 29052 BLT
 0: 00029052 - 0002905C (11) RWI L CPU
>w 0 29052 COP
 0: 00029052 - 0002905D (12) RWI CPU
>w 0 29052 BLTA
 0: 00029052 - 0002905C (11) RWI L CPU
>w 0 29052 ALL
 0: 00029052 - 0002905B (10) RWI L CPU
>w 0 29052 BLTD
 0: 00029052 - 0002905C (11) RWI L CPU
>
;------------------------------------------------------------------------------
																				; 12.
																				; w <num> <address> <length> <channel> 
>w 0 100 10 ALL
 0: 00000100 - 0000010F (16) RWI ALL
>w 0 100 10 NONE
 0: 00000100 - 0000010F (16) RWI NONE
>w 0 100 10 DMA
 0: 00000100 - 0000010F (16) RWI DMA
 >w 0 29052 64 BLTD
 0: 00029052 - 000290B5 (100) RWI L BLTD
;------------------------------------------------------------------------------
																				; 13.
																				; w <num> <address> <R/W/I/F/C> <channel> 

>w 0 29052 R COP
>w 0 29052 I BLTD
>w 0 29052 I ALL
>w 0 29052 RW ALL
>w 0 29052 RWI CPU
>w 0 29052 RW CPU
>w 0 29052 R DSK
>w 0 29052 R AUD
>w 0 29052 RWI AUD
																				; different combinations are possible with 5 options
;------------------------------------------------------------------------------
																				; 14.
																				; w <num> <address> <length> <R/W/I/F/C> <channel> 
>w 0 100 10 W DMA
Memwatch breakpoints enabled
 0: 00000100 - 0000010F (16)  W  DMA
>w 0 100 10 I DMA
 0: 00000100 - 0000010F (16)   I DMA
>w 0 100 10 R DMA
 0: 00000100 - 0000010F (16) R   DMA
>w 0 100 10 RW DMA
 0: 00000100 - 0000010F (16) RW  DMA
>w 0 100 10 WI DMA
 0: 00000100 - 0000010F (16)  WI DMA
>w 0 100 10 IW DMA
 0: 00000100 - 0000010F (16)  WI DMA
>w 0 100 10 F DMA
 0: 00000100 - 0000010F (16) RWI F DMA
>w 0 100 10 FRW DMA
 0: 00000100 - 0000010F (16) RW  F DMA
 

 >w 0 29052 100 RWI AUD
 0: 00029052 - 00029151 (256) RWI AUD
>w 0 29052 100 RWI DSK
 0: 00029052 - 00029151 (256) RWI DSK
>w 0 29052 100 RWI SPR
 0: 00029052 - 00029151 (256) RWI SPR
>w 0 29052 100 RWI BPL
 0: 00029052 - 00029151 (256) RWI BPL
>w 0 29052 100 RWI LLL
 0: 00029052 - 00029151 (256) RWI =0 CPU
>w 0 29052 100 FRW LLL
 0: 00029052 - 00029151 (256) RW  F =0 CPU
>w 0 29052 100 FRW BPL
 0: 00029052 - 00029151 (256) RW  F BPL

 
;------------------------------------------------------------------------------
; explanation
; w <num> <address> <length> <R/W/I/F/C> [<value>[.x]] 
;						 (read/write/opcode/freeze/mustchange).
;                        Add/remove memory watchpoints.

w <watchpoint number> <memory start address> <length in bytes> <flags> <value> <channel>
w <num> [<address> [<length> [<R/W/I/F/C> [<value>[.x] [<channel>]]]]] would be better
;------------------------------------------------------------------------------

from EAB:
Notes:
	address, length and value are interpreted as hexadecimal numbers, unless you specify 
	otherwise. Also note that the description in help is slightly incorrect as address, 
	length, trigger, value and channel operation are optional too.
watchpoint number: 
	You can have up to 8 memwatch breakpoints (0-7) and you can have any combination of
	them set/unset, for example watchpoints 2 and 5 set, the remaining ones not set.
memory start address:
	is clear
length in bytes:
	Default value for length is 1.
	Length is a numerical value and specifies the window size in memory where an
	access can trigger the watchpoint.
	Example: if you use w 0 1000 9 W, any longword that is written in the
	range $ffd (last byte of operation is in window) to $1008 (first one) triggers the
	watchpoint, so move.l #123,$ffd, sub.l #234,$1000, or add.l #345,$1008 would trigger.
flags:
	R/W/I/F/C> (read/write/opcode/freeze/mustchange)
	Default value for trigger operation is RWI.						

	Yes, when you've found values you can freeze them with the watchpoint command:
	w <watchpoint number> <memory start address> <length in bytes> <flags>

	To freeze your 1E7E6 address in Crazy Cars 3 you would do:

	Code:
	w 0 1E7E6 2 frw
	This sets freeze watchpoint 0 on the contents of that address and the following one.

	The flags are (from Toni):
	FR = writing changes value in memory normally, reading always return frozen value.
	FW = writing replaces value in memory with frozen value, reading returns original
	value in memory location.
	(of course only if location has not yet been written to)
	FRW = original operation, both reads and writes are frozen.
value:
	[<value>[.x]]
	If you would add 345 for value (w 0 1000 9 W !345), only the last one would trigger.
	For word sized operands the range would be $fff to $1008, for byte sized $1000 to $1008.
channel:
	All DMA channels have been recently added to memwatch points. CPU only is the default.
	Append extra string parameter(s) at the end of w command to change supported access types.

	"ALL"	 = everything,
	"NONE"	 = ??
	"CPU"	 = CPU only is the default.

	"CPU"  = is CPUDR + CPUDW + CPUI
	"CPUD" = is CPUDR + CPUDW
	"CPUDW" = write
	"CPUDR" = read
	"CPUI"  = instrcution

	"DMA" = "ALL" without CPU_I + CPU_D_R + CPU_D_W

	"COP" = copper only,
	"DSK" = disk only	 
	"AUD" = audio only  (is AUD0 + AUD1 + AUD2 + AUD3)
	"SPR" = sprite only (is SPR0 + SPR1 + SPR2 + SPR3 + SPR4 + SPR5 + SPR6 + SPR7)	
	"BPL" = bitplane    (is BPL0 + BPL1 + BPL2 + BPL3 + BPL4 + BPL5 + BPL6 + BPL7)	

	"BLT"  = ( is BLTA + BLTB + BLTC + BLTD )	= all blitter channels,
	"BLTD" = ( is BLTDN + BLTDL + BLTDF)

	"BLTA" = A only.
	"BLTB"
	"BLTC"
	"BLTD"
	"BLTDN" = normal
	"BLTDL" = line
	"BLTDF"	= fill

	Check debug.cpp memwatch_access_masks for all combinationsQuote:
	Originally Posted by Toni Wilen

	https://github.com/tonioni/WinUAE/blob/master/debug.cpp

	static const struct mw_acc memwatch_access_masks[] = ...
 
	; Flag L means: Only log the hit, don't break in debugger.
>w
 0: 00029052 - 0002905B (10) RWI L CPU
