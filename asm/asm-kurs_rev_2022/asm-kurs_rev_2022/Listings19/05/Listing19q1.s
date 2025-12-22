
; Listing19q1.s
; Illegal Memory Access
; 
; (WinUAE 4.4.0 A500 configuration)
; Console-Debugger

; wd [<0-1>]            Enable illegal access logger. 1 = enable break.

;------------------------------------------------------------------------------

start:
	btst	#2,$dff016			; right mousebutton?
	bne.s	start	
waitmouse:
	move.w	#0,d0				; Set i do 0
	move.w $0,$040000			; data access chip-ram
	move.w $0,$C40000			; data access slow-ram
	move.w $0,$dff182			; data access custom-chips			; Color01
	move.w $0,$B80000			; data access CIA/ I/O
	move.w $0,$e0000			; data access Kickstart ROM
		
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	

exit:
	rts
	end

;------------------------------------------------------------------------------
>r
Filename:Listing19q1.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the right mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 303c (MOVE) Chip latch 0000303C
00027248 66f6                     bne.b #$f6 == $00027240 (T)
Next PC: 0002724a
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
>dm																				; memory dump as info	
00000000    2048K/4 =     512K ID C16 Chip memory
00200000    8192K/0 =    8192K -- F16 <none>
00A00000     512K/0 =     512K -- CIA CIA
00A80000     512K/1 =     512K ID F32 Non-autoconfig RAM #1
00B00000     512K/1 =     512K ID F32 Non-autoconfig RAM #2
00B80000     512K/0 =     512K -- CIA CIA
00C00000     512K/1 =     512K ID C16 Slow memory
00C80000    1024K/0 =    1024K -- C16 Custom chipset
00D80000     256K/0 =     256K -- C16 <none>
00DC0000      64K/0 =      64K -- C16 Battery backed up clock (MSM6242B)
00DD0000      64K/0 =      64K -- C16 <none>
00DE0000     128K/0 =     128K -- C16 Custom chipset
00E00000     512K/1 =     512K ID F16 Kickstart ROM (F6290043)
00E80000     512K/0 =     512K -- F16 <none>
00F00000      64K/1 =      64K -- F16 UAE Boot ROM
00F10000     448K/0 =     448K -- F16 <none>
00F80000     512K/1 =     512K ID F16 Kickstart ROM (F6290043)
;------------------------------------------------------------------------------
>d pc																			
00027248 66f6                     bne.b #$f6 == $00027240 (T)
0002724a 303c 0000                move.w #$0000,d0
0002724e 33f9 0000 0000 0004 0000 move.w $00000000 [0000],$00040000 [0000]
00027258 33f9 0000 0000 00c4 0000 move.w $00000000 [0000],$00c40000 [6100]
00027262 33f9 0000 0000 00df f182 move.w $00000000 [0000],$00dff182
0002726c 33f9 0000 0000 00b8 0000 move.w $00000000 [0000],$00b80000
00027276 33f9 0000 0000 000e 0000 move.w $00000000 [0000],$000e0000 [0000]
00027280 0839 0006 00bf e001      btst.b #$0006,$00bfe001
00027288 66c0                     bne.b #$c0 == $0002724a (T)
0002728a 4e75                     rts  == $00c4f6d8
;------------------------------------------------------------------------------
>f 2724e																		; task 1 - set breakpoint
Breakpoint added.
>x
;------------------------------------------------------------------------------
Breakpoint 0 triggered.
Cycles: 7034087 Chip, 14068174 CPU. (V=105 H=3 -> V=105 H=41)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33f9 (MOVE) 0000 (OR) Chip latch 00000000
0002724e 33f9 0000 0000 0004 0000 move.w $00000000 [0000],$00040000 [0000]
Next PC: 00027258
;------------------------------------------------------------------------------
>w 0 $0 $FF0001 none															; w 0 <start> <len> none																				
 0: 00000000 - 00FF0000 (16711681) RWI NONE										; it's need for wd (max. 16MB)
;------------------------------------------------------------------------------
>wd 1
Illegal memory access logging enabled. Break=1
>
;------------------------------------------------------------------------------
>g
W: 00BFC001=00 PC=0002726C
W: 00BFC000=00 PC=0002726C
Cycles: 51 Chip, 102 CPU. (V=105 H=41 -> V=105 H=92)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33f9 (MOVE) 0000 (OR) Chip latch 00000000
0002726c 33f9 0000 0000 00b8 0000 move.w $00000000 [0000],$00b80000
00027276 33f9 0000 0000 000e 0000 move.w $00000000 [0000],$000e0000 [0000]
Next PC: 00027280
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 38 Chip, 76 CPU. (V=105 H=102 -> V=105 H=140)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33f9 (MOVE) 0000 (OR) Chip latch 00000000
0002724e 33f9 0000 0000 0004 0000 move.w $00000000 [0000],$00040000 [0000]
Next PC: 00027258
;------------------------------------------------------------------------------
>g
W: 00BFC001=00 PC=0002726C
W: 00BFC000=00 PC=0002726C
Cycles: 50 Chip, 100 CPU. (V=105 H=140 -> V=105 H=190)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33f9 (MOVE) 0000 (OR) Chip latch 00000000
0002726c 33f9 0000 0000 00b8 0000 move.w $00000000 [0000],$00b80000
00027276 33f9 0000 0000 000e 0000 move.w $00000000 [0000],$000e0000 [0000]
Next PC: 00027280
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 37 Chip, 74 CPU. (V=105 H=202 -> V=106 H=12)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33f9 (MOVE) 0000 (OR) Chip latch 00000000
0002724e 33f9 0000 0000 0004 0000 move.w $00000000 [0000],$00040000 [0000]
Next PC: 00027258
>
;------------------------------------------------------------------------------
>wd 0
Cleared logging addresses 00000000 - 00000001
>w 0
Memwatch 0 removed
;------------------------------------------------------------------------------
>w 0 $0 $FF0001 none
 0: 00000000 - 00FF0000 (16711681) RWI NONE
>wd 1
Cleared logging addresses 00000001 - 00000002
>x																				; leave the debugger


from EAB
wd supports only first 16M of address space. Including Z3 space would require huge
amounts of RAM. w does not have any limits.

So the only possibility is to use the native MMU?
What we need is simply a log when unmapped memory is accessed.
Yes Z3 memory can be huge and problematic, but think about old games/demos/stuff
where 24-bit memory is usual. An option for a break/log
if ((high byte != 0) && (24-bit memory flag)) can be simple.
And wd working in 'low' 16MB memory space.

Toni Wilen	07 July 2019 20:37
Any CPU unmapped (address space where nothing is mapped) access is already logged
if misc panel illegal access option is ticked.
I suppose all zone mapped as <none> in current address space map trigger a log.

But how about the 'mirror' zone?
I tried wd for the addresses $80000-$1FFFFF but it didn't seem to work, nor in
$C00000 and up (off course not used in memory map).
