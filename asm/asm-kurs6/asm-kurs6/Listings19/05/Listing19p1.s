
; Listing19p1.s
; 
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

; il [<mask>]           Exception breakpoint.
;------------------------------------------------------------------------------

start:
	btst	#2,$dff016			; right mousebutton?
	bne.s	start
	
	bsr exc1					; Division by Zero												; $00000014 05:    DIV BY 0
	;bsr exc2					; Privilege Violation (im User Mode)       reset				; $00000020 08:    PRIVIL VIO
	;bsr exc3					; Adress Error (68000 and 68010)								; $0000000C 03:    ADR ERROR
	;bsr exc4					; Illegaler Opcode												; $00000010 04:    ILLEG OPC
	;bsr exc5					; Line-A														; $00000028 10:    LINEA EMU	

	nop
	rts

;------------------------------------------------------------------------------
; 1. Division by Zero        divu    #0,d0
exc1:
	move.b	#10,d0
	move.b	#2,d1
	divu    d1,d0			; d0=10/2=5
	sub.b	#1,d1
	divu    d1,d0			; d0=10/1=10
	sub.b	#1,d1
	divu    d1,d0			; d0=10/0= --> Exception
	nop
	rts
	
;------------------------------------------------------------------------------
; 2. Privilege Violation (im User Mode)       reset
exc2:
	reset
	nop						; for fi nop
	rts

;------------------------------------------------------------------------------
; 3. Adress Error (data access only with 68000 and 68010)
exc3:     
	move.w  $1,d0
	nop
	rts

;------------------------------------------------------------------------------
; 4. Illegaler Opcode
exc4:
    dc.w    $4afc			; illegal
	nop
	rts

;------------------------------------------------------------------------------
; 5. Line-A
exc5:
    dc.w    $a000
	nop
	rts

	end


;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
>i																				; dump contents of interrupt and trap vectors
$00000000 00:    Reset:SSP $00000000  $00000080 32:      TRAP 00 $00FC0836
$00000004 01:     EXECBASE $00C00276  $00000084 33:      TRAP 01 $00FC0838
$00000008 02:    BUS ERROR $00FC0818  $00000088 34:      TRAP 02 $00FC083A
$0000000C 03:    ADR ERROR $00FC081A  $0000008C 35:      TRAP 03 $00FC083C
$00000010 04:    ILLEG OPC $00FC081C  $00000090 36:      TRAP 04 $00FC083E
$00000014 05:     DIV BY 0 $00FC081E  $00000094 37:      TRAP 05 $00FC0840
$00000018 06:          CHK $00FC0820  $00000098 38:      TRAP 06 $00FC0842
$0000001C 07:        TRAPV $00FC0822  $0000009C 39:      TRAP 07 $00FC0844
$00000020 08:   PRIVIL VIO $00FC090E  $000000A0 40:      TRAP 08 $00FC0846
$00000024 09:        TRACE $00FC0826  $000000A4 41:      TRAP 09 $00FC0848
$00000028 10:    LINEA EMU $00FC0828  $000000A8 42:      TRAP 10 $00FC084A
$0000002C 11:    LINEF EMU $00FC082A  $000000AC 43:      TRAP 11 $00FC084C
$00000038 14:   FORMAT ERR $00FC0830  $000000B0 44:      TRAP 12 $00FC084E
$0000003C 15:   INT Uninit $00FC0832  $000000B4 45:      TRAP 13 $00FC0850
$00000060 24:   INT Unjust $00FC0834  $000000B8 46:      TRAP 14 $00FC0852
$00000064 25:    Lvl 1 Int $00FC0C8E  $000000BC 47:      TRAP 15 $00FC0854
$00000068 26:    Lvl 2 Int $00FC0CE2
$0000006C 27:    Lvl 3 Int $00FC0D14
$00000070 28:    Lvl 4 Int $00FC0D6C
$00000074 29:    Lvl 5 Int $00FC0DFA
$00000078 30:    Lvl 6 Int $00FC0E40
$0000007C 31:          NMI $00FC0E86
;------------------------------------------------------------------------------
>m 14																			; m 14 = $00FC 081E
00000014 00FC 081E 00FC 0820 00FC 0822 00FC 090E  ....... ..."....				
00000024 00FC 0826 00FC 0828 00FC 082A 00FC 082C  ...&...(...*...,
00000034 00FC 082E 00FC 0830 00FC 0832 00FC 0834  .......0...2...4
00000044 00FC 0834 00FC 0834 00FC 0834 00FC 0834  ...4...4...4...4
00000054 00FC 0834 00FC 0834 00FC 0834 00FC 0834  ...4...4...4...4
00000064 00FC 0C8E 00FC 0CE2 00FC 0D14 00FC 0D6C  ...............l
00000074 00FC 0DFA 00FC 0E40 00FC 0E86 00FC 0836  .......@.......6
00000084 00FC 0838 00FC 083A 00FC 083C 00FC 083E  ...8...:...<...>
00000094 00FC 0840 00FC 0842 00FC 0844 00FC 0846  ...@...B...D...F
000000A4 00FC 0848 00FC 084A 00FC 084C 00FC 084E  ...H...J...L...N
000000B4 00FC 0850 00FC 0852 00FC 0854 00C0 CA0C  ...P...R...T....
000000C4 00C0 CA0E 00C0 CA10 00C0 CA12 00C0 CA14  ................
000000D4 00C0 CA16 00C0 CA18 00C0 CA1A 00C0 CA1C  ................
000000E4 00C0 CA1E 00C0 CA20 00C0 CA22 00C0 CA24  ....... ..."...$
000000F4 00C0 CA26 00C0 CA28 00C0 CA2A 0000 0000  ...&...(...*....
00000104 0000 0000 0000 0000 0000 0000 0000 0000  ................
;------------------------------------------------------------------------------
>m fc081e																		; m 14 = $00FC 081E
00FC081E 616C 616A 6168 6166 6164 6162 6160 615E  alajahafadaba`a^
00FC082E 615C 6132 6130 6020 616A 6168 6166 6164  a\a2a0` ajahafad
00FC083E 6162 6160 615E 615C 615A 6158 6156 6154  aba`a^a\aZaXaVaT
00FC084E 6152 6150 614E 614C 007C 0700 2F3C 8100  aRaPaNaL.|../<..
00FC085E 000A 6000 278E 007C 0700 0497 00FC 0816  ..`.'..|........
00FC086E E2EF 0002 6000 277C 0497 00FC 0816 E2EF  ....`.'|........
00FC087E 0002 082F 0005 000C 6748 6000 2766 0497  .../....gH`.'f..
00FC088E 00FC 0816 E2EF 0002 082F 0005 0004 6732  ........./....g2
00FC089E 6000 2750 0497 00FC 07F8 E2EF 0002 082F  `.'P.........../
00FC08AE 0005 0004 6600 273C 6018 42A7 3F6F 000A  ....f.'<`.B.?o..
00FC08BE 0002 026F 0FFF 0002 E2EF 0002 E2EF 0002  ...o............
00FC08CE 60C6 48E7 00C0 2078 0004 2068 0114 2F68  `.H... x.. h../h
00FC08DE 0032 0004 205F 4E75 007C 2000 4879 00FC  .2.. _Nu.| .Hy..
00FC08EE 08F4 40E7 4ED5 4E75 007C 2000 518F 40D7  ..@.N.Nu.| .Q.@.
00FC08FE 2F7C 00FC 08F4 0002 3F7C 0020 0006 4ED5  /|......?|. ..N.
00FC090E 0CAF 00FC 08E6 0002 670A 0CAF 00FC 08F6  ........g.......
00FC091E 0002 660A 2F7C 00FC 08F4 0002 4ED5 007C  ..f./|......N..|
00FC092E 0700 2F3C 0000 0008 6000 FF5E 0000 48E7  ../<....`..^..H.
00FC093E 1838 4E55 FFF2 264F 268B 5893 42AB 0004  .8NU..&O&.X.B...
00FC094E 274B 0008 2448 4A92 6B0A 285A 281A 6100  'K..$HJ.k.(Z(.a.
>

;------------------------------------------------------------------------------
; 1. Division by Zero a) normal trace bey step b) g-run c) with il
;------------------------------------------------------------------------------
>r
Filename:Listing19p1.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 6100 (BSR) Chip latch 00006100
0002662c 66f6                     bne.b #$f6 == $00026624 (T)
Next PC: 0002662e
>d pc
0002662c 66f6                     bne.b #$f6 == $00026624 (T)
0002662e 6100 0006                bsr.w #$0006 == $00026636
00026632 4e71                     nop
00026634 4e75                     rts  == $00c4f6d8
00026636 103c 000a                move.b #$0a,d0
0002663a 123c 0002                move.b #$02,d1
0002663e 80c1                     divu.w d1,d0
00026640 0401 0001                sub.b #$01,d1
00026644 80c1                     divu.w d1,d0
00026646 0401 0001                sub.b #$01,d1
>f 2662e
Breakpoint added.
>x
;------------------------------------------------------------------------------
Breakpoint 0 triggered.															; now click right mouse and the debugger reopens	
Cycles: 4253916 Chip, 8507832 CPU. (V=105 H=8 -> V=105 H=44)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6100 (BSR) 0006 (OR) Chip latch 00000006
0002662e 6100 0006                bsr.w #$0006 == $00026636
Next PC: 00026632
;------------------------------------------------------------------------------
>d pc
0002662e 6100 0006                bsr.w #$0006 == $00026636
00026632 4e71                     nop
00026634 4e75                     rts  == $00c4f6d8
00026636 103c 000a                move.b #$0a,d0
0002663a 123c 0002                move.b #$02,d1
0002663e 80c1                     divu.w d1,d0
00026640 0401 0001                sub.b #$01,d1
00026644 80c1                     divu.w d1,d0
00026646 0401 0001                sub.b #$01,d1
0002664a 80c1                     divu.w d1,d0
;------------------------------------------------------------------------------
>t																				; step-by-step
Cycles: 9 Chip, 18 CPU. (V=105 H=44 -> V=105 H=53)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF4
USP  00C5FDF4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 103c (MOVE) 000a (ILLEGAL) Chip latch 0000000A
00026636 103c 000a                move.b #$0a,d0
Next PC: 0002663a
>t
Cycles: 4 Chip, 8 CPU. (V=105 H=53 -> V=105 H=57)
 >t
Cycles: 4 Chip, 8 CPU. (V=105 H=57 -> V=105 H=61) 
>t
Cycles: 67 Chip, 134 CPU. (V=105 H=61 -> V=105 H=128) 
>t
Cycles: 4 Chip, 8 CPU. (V=105 H=128 -> V=105 H=132) 
>t
Cycles: 68 Chip, 136 CPU. (V=105 H=132 -> V=105 H=200) 
>t
Cycles: 4 Chip, 8 CPU. (V=105 H=200 -> V=105 H=204) 
>t
Exception 5, PC=0002664C														; Exception 5, PC=0002664C			
Cycles: 19 Chip, 38 CPU. (V=105 H=204 -> V=105 H=223)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60DF2
USP  00C5FDF4 ISP  00C60DF2
T=00 S=1 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 616c (BSR) 616a (BSR) Chip latch 0000081E
00fc081e 616c                     bsr.b #$6c == $00fc088c
Next PC: 00fc0820
>fd
All breakpoints removed.
>x
;------------------------------------------------------------------------------
; 1. Division by Zero b) g-run
;------------------------------------------------------------------------------
>r
Filename:Listing19p1.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 6100 (BSR) Chip latch 00006100
0002828c 66f6                     bne.b #$f6 == $00028284 (T)
Next PC: 0002828e
>d pc
0002828c 66f6                     bne.b #$f6 == $00028284 (T)
0002828e 6100 0006                bsr.w #$0006 == $00028296
00028292 4e71                     nop
00028294 4e75                     rts  == $00c4f6d8
00028296 103c 000a                move.b #$0a,d0
0002829a 123c 0002                move.b #$02,d1
0002829e 80c1                     divu.w d1,d0
000282a0 0401 0001                sub.b #$01,d1
000282a4 80c1                     divu.w d1,d0
000282a6 0401 0001                sub.b #$01,d1
>f 2828e
Breakpoint added.
>x
;------------------------------------------------------------------------------
Breakpoint 0 triggered.															; now click right mouse and the debugger reopens	
Cycles: 4973604 Chip, 9947208 CPU. (V=105 H=3 -> V=105 H=37)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6100 (BSR) 0006 (OR) Chip latch 00000006
0002828e 6100 0006                bsr.w #$0006 == $00028296
Next PC: 00028292
;------------------------------------------------------------------------------
>fi nop																			; don't stop
Cycles: 1742331 Chip, 3484662 CPU. (V=105 H=37 -> V=268 H=143)
  D0 00000001   D1 00000002   D2 000003CA   D3 00000000
  D4 000028A0   D5 00000082   D6 0000000C   D7 00000000
  A0 00DFF000   A1 00C1A294   A2 00C06AB0   A3 00C0AEE4
  A4 00008DA8   A5 00C1A2D4   A6 00C028F6   A7 00C1A24C
USP  00C1A24C ISP  00C80000
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 4e71 (NOP) Chip latch 0000E000
00fc5a6c 4e71                     nop
Next PC: 00fc5a6e
;------------------------------------------------------------------------------
>fd
All breakpoints removed.
>x

;------------------------------------------------------------------------------
; 1. Division by Zero c) with il (with exception breakpoint)
;------------------------------------------------------------------------------
>r
Filename:Listing19p1.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 6100 (BSR) Chip latch 00006100
00027670 66f6                     bne.b #$f6 == $00027668 (T)
Next PC: 00027672
>d pc
00027670 66f6                     bne.b #$f6 == $00027668 (T)
00027672 6100 0006                bsr.w #$0006 == $0002767a
00027676 4e71                     nop
00027678 4e75                     rts  == $00c4f6d8
0002767a 103c 000a                move.b #$0a,d0
0002767e 123c 0002                move.b #$02,d1
00027682 80c1                     divu.w d1,d0
00027684 0401 0001                sub.b #$01,d1
00027688 80c1                     divu.w d1,d0
0002768a 0401 0001                sub.b #$01,d1
>f 27672
Breakpoint added.
>x
;------------------------------------------------------------------------------
Breakpoint 0 triggered.															; now click right mouse and the debugger reopens
Cycles: 7029490 Chip, 14058980 CPU. (V=210 H=6 -> V=210 H=37)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6100 (BSR) 0006 (OR) Chip latch 00000006
00027672 6100 0006                bsr.w #$0006 == $0002767a
Next PC: 00027676
;------------------------------------------------------------------------------
>il
Exception breakpoint mask: FFFFFFFF 00FFFFFF
;------------------------------------------------------------------------------
>fi nop																			; run to next nop
Cycles: 0 Chip, 0 CPU. (V=210 H=37 -> V=210 H=37)								; breaks here
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60DF2
USP  00C5FDF4 ISP  00C60DF2
T=00 S=1 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 616c (BSR) 616a (BSR) Chip latch 0000081E
00fc081e 616c                     bsr.b #$6c == $00fc088c						; now you can trace the exception	
Next PC: 00fc0820
;------------------------------------------------------------------------------
>il
Exception breakpoint mask: 00000000 00000000
>fd
All breakpoints removed.
>x


;------------------------------------------------------------------------------
;	
>il !5																			; set mask									
Exception breakpoint mask: 00000000 00000005
>fi nop																			; don't work		
Cycles: 1810527 Chip, 3621054 CPU. (V=210 H=37 -> V=48 H=12)
  D0 00C06290   D1 00FF4030   D2 00000000   D3 0000001A
  D4 0000001B   D5 0000001C   D6 0000001D   D7 0000001E
  A0 00C06290   A1 00FF4030   A2 00C01514   A3 00C06706
  A4 00FF47E0   A5 00C0667A   A6 00C06290   A7 00C014E0
USP  00C014E0 ISP  00C80000
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 6000 (Bcc) Chip latch 00006000
00c0628a 4e71                     nop
Next PC: 00c0628c
>

;------------------------------------------------------------------------------
; 2. Privilege Violation a) normal b) with il
;------------------------------------------------------------------------------
>r
Filename:Listing19p1.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 6100 (BSR) Chip latch 00006100
00024b3c 66f6                     bne.b #$f6 == $00024b34 (T)
Next PC: 00024b3e
>d pc
00024b3c 66f6                     bne.b #$f6 == $00024b34 (T)
00024b3e 6100 0020                bsr.w #$0020 == $00024b60
00024b42 4e71                     nop
00024b44 4e75                     rts  == $00c4f6d8
00024b46 103c 000a                move.b #$0a,d0
00024b4a 123c 0002                move.b #$02,d1
00024b4e 80c1                     divu.w d1,d0
00024b50 0401 0001                sub.b #$01,d1
00024b54 80c1                     divu.w d1,d0
00024b56 0401 0001                sub.b #$01,d1
>f 24b3e
Breakpoint added.
>il
Exception breakpoint mask: FFFFFFFF 00FFFFFF
>il
Exception breakpoint mask: 00000000 00000000
>x
;------------------------------------------------------------------------------
Breakpoint 0 triggered.															; now click right mouse and the debugger reopens
Cycles: 5826216 Chip, 11652432 CPU. (V=105 H=3 -> V=105 H=37)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6100 (BSR) 0020 (OR) Chip latch 00000020
00024b3e 6100 0020                bsr.w #$0020 == $00024b60
Next PC: 00024b42
;------------------------------------------------------------------------------
>t																				; step-by-step
Cycles: 9 Chip, 18 CPU. (V=105 H=37 -> V=105 H=46)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF4
USP  00C5FDF4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e70 (RESET) 4e75 (RTS) Chip latch 00004E75
00024b60 4e70                     reset
Next PC: 00024b62
;------------------------------------------------------------------------------
>t
Exception 8, PC=00024B60														; Exception 8, PC=00024B60
Cycles: 17 Chip, 34 CPU. (V=105 H=46 -> V=105 H=63)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60DF2
USP  00C5FDF4 ISP  00C60DF2
T=00 S=1 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0caf (CMP) 00fc (ILLEGAL) Chip latch 0000090E
00fc090e 0caf 00fc 08e6 0002      cmp.l #$00fc08e6,(a7,$0002) == $00c60df4 [00024b60]	; 00FC090E 0CAF 00FC 08E6 0002 670A 0CAF 00FC 08F6  ........g.......
Next PC: 00fc0916
>
;------------------------------------------------------------------------------
; 2. Privilege Violation a) normal b) with il
;------------------------------------------------------------------------------
>r
Filename:Listing19p1.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
;...
;------------------------------------------------------------------------------
Breakpoint 0 triggered.															; now click right mouse and the debugger reopens
Cycles: 5779000 Chip, 11558000 CPU. (V=105 H=3 -> V=210 H=37)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6100 (BSR) 0020 (OR) Chip latch 00000020
00024b42 6100 0020                bsr.w #$0020 == $00024b64
Next PC: 00024b46
;------------------------------------------------------------------------------
>il
Exception breakpoint mask: FFFFFFFF 00FFFFFF
;------------------------------------------------------------------------------
>fi nop																			; breaks if exception occurs
;Exception 8, PC=00024B60									; info fehlt
Cycles: 0 Chip, 0 CPU. (V=210 H=37 -> V=210 H=37)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60DF2
USP  00C5FDF4 ISP  00C60DF2
T=00 S=1 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0caf (CMP) 00fc (ILLEGAL) Chip latch 0000090E
00fc090e 0caf 00fc 08e6 0002      cmp.l #$00fc08e6,(a7,$0002) == $00c60df4 [00024b64]
Next PC: 00fc0916
>il
Exception breakpoint mask: 00000000 00000000
>fd
All breakpoints removed.
>x

;------------------------------------------------------------------------------
;	
>il 8																			; set mask
Exception breakpoint mask: 00000000 00000008
>fi nop																			; don't break on exception		
Cycles: 407595 Chip, 815190 CPU. (V=105 H=37 -> V=22 H=167)
  D0 00C06290   D1 00FF4030   D2 00000000   D3 0000001A
  D4 0000001B   D5 0000001C   D6 0000001D   D7 0000001E
  A0 00C06290   A1 00FF4030   A2 00C01514   A3 00C06706
  A4 00FF47E0   A5 00C0667A   A6 00C06290   A7 00C014E0
USP  00C014E0 ISP  00C80000
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 6000 (Bcc) Chip latch 00006000
00c0628a 4e71                     nop
Next PC: 00c0628c
>

;------------------------------------------------------------------------------
; 3. Adress Error
;------------------------------------------------------------------------------
>r
Filename:Listing19p1.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
;...																			; same procedure 
>t
Cycles: 9 Chip, 18 CPU. (V=105 H=37 -> V=105 H=46)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF4
USP  00C5FDF4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 3039 (MOVE) 0000 (OR) Chip latch 00000000
00024baa 3039 0000 0001 
>t
Exception 3, PC=00024BB0														; Exception 3, PC=00024BB0
Cycles: 33 Chip, 66 CPU. (V=105 H=46 -> V=105 H=79)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60DEA
USP  00C5FDF4 ISP  00C60DEA
T=00 S=1 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 615a (BSR) 616e (BSR) Chip latch 0000081A
00fc081a 615a                     bsr.b #$5a == $00fc0876
Next PC: 00fc081c
>

;------------------------------------------------------------------------------
; 4. Illegaler Opcode
;------------------------------------------------------------------------------
>r
Filename:Listing19p1.s
>a
Pass1
Pass2
No Errors
>j		
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
;...																			; same procedure 
>t
Cycles: 0 Chip, 0 CPU. (V=64 H=28 -> V=64 H=28)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF4
USP  00C5FDF4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4afc (ILLEGAL) 4e71 (NOP) Chip latch 00004E71
00024c64 4afc                     illegal										; 4afc                     illegal 
Next PC: 00024c66
>t
Exception 4, PC=00024C64														; Exception 4, PC=00024C64
Cycles: 17 Chip, 34 CPU. (V=64 H=37 -> V=64 H=54)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60DF2
USP  00C5FDF4 ISP  00C60DF2
T=00 S=1 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 616e (BSR) 616c (BSR) Chip latch 0000081C
00fc081c 616e                     bsr.b #$6e == $00fc088c
Next PC: 00fc081e
>

;------------------------------------------------------------------------------
; 45. Line-A
;------------------------------------------------------------------------------
>r
Filename:Listing19p1.s
>a
Pass1
Pass2
No Errors
>j
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
;...																			; same procedure 
>t
Cycles: 9 Chip, 18 CPU. (V=105 H=44 -> V=105 H=53)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF4
USP  00C5FDF4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch a000 (ILLEGAL) 4e71 (NOP) Chip latch 00004E71
00024e6a a000                     illegal										; a000                     illegal
Next PC: 00024e6c
>t
Exception 10, PC=00024E6A														; Exception 10, PC=00024E6A
Cycles: 17 Chip, 34 CPU. (V=105 H=53 -> V=105 H=70)
  D0 00000005   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60DF2
USP  00C5FDF4 ISP  00C60DF2
T=00 S=1 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6162 (BSR) 6160 (BSR) Chip latch 00000828
00fc0828 6162                     bsr.b #$62 == $00fc088c
Next PC: 00fc082a
