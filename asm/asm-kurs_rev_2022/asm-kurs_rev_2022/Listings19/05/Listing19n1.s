
; Listing19n1.s
; How does the smc - debugger command works?
; start and run from asmone	
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

; smc [<0-1>]           Enable self-modifying code detector. 1 = enable break. 

;------------------------------------------------------------------------------
; This is a short test programm in which the branches opcode
; is changed by adding 1 from $62 to $6f. (self modifying code)

waitmouse:  
	btst	#6,$bfe001	; left mousebutton?
	bne.s	Waitmouse	
start:
	;...
	move.b #1,d1
	move.b #1,d2
	sub.b d1,d2  
;--------------------------------------------------------
bcc:
	; branches after unsigned comparisons
	bhi.s bitset	; $62xx
	;bhs.s bitset	; $64 == bcc	
	;blo.s bitset	; $65 == bcs	
	;bls.s bitset	; $63
	; branches on flag status
	;bcc.s bitset	; $64
	;bcs.s bitset	; $65
	;bne.s bitset	; $66
	;beq.s bitset	; $67
	;bvc.s bitset	; $68
	;bvs.s bitset	; $69
	;bpl.s bitset	; $6a
	;bmi.s bitset	; $6b	
	; branches after signed comparisons
	;bge.s bitset	; $6c
	;blt.s bitset	; $6d
	;bgt.s bitset	; $6e
	;ble.s bitset	; $6f	
	;...
	nop
bitset:
	;...
	nop
exit:
	add.b #$1,bcc	
	cmp.b #$70,bcc
	bne start		

	rts
	end

;------------------------------------------------------------------------------
>r
Filename:Listing19n1.s
>a
Pass1
Pass2
No Errors
>j
;------------------------------------------------------------------------------
; 1. Test - >smc 1
;------------------------------------------------------------------------------	
																					; start the programm
																					; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																					; open the Debugger with Shift+F12

>d pc
000241E8 66f6                     BNE.B #$f6 == $000241e0 (T)
000241EA 123c 0001                MOVE.B #$01,D1
000241EE 143c 0001                MOVE.B #$01,D2
000241F2 9401                     SUB.B D1,D2
000241F4 6202                     BHI.B #$02 == $000241f8 (T)
000241F6 4e71                     NOP
000241F8 4e71                     NOP
000241FA 0639 0001 0002 41f4      ADD.B #$01,$000241f4 [62]
00024202 0c39 0070 0002 41f4      CMP.B #$70,$000241f4 [62]
0002420A 6600 ffde                BNE.W #$ffde == $000241ea (T)
>f 241EA																			; set program breakpoint
Breakpoint added.
>w 0 0 80000 none																	; memwatch breakpoint
Memwatch breakpoints enabled
 0: 00000000 - 0007FFFF (524288) RWI NONE
>smc 1																				; smc enabled
SMCD enabled. Break=1
>x																					; leave the debugger
;------------------------------------------------------------------------------
																					; now click left mouse-button, the debuger reopens
>d pc
000241EA 123c 0001                MOVE.B #$01,D1
000241EE 143c 0001                MOVE.B #$01,D2
000241F2 9401                     SUB.B D1,D2
000241F4 6202                     BHI.B #$02 == $000241f8 (F)
000241F6 4e71                     NOP
000241F8 4e71                     NOP
000241FA 0639 0001 0002 41f4      ADD.B #$01,$000241f4 [62]
00024202 0c39 0070 0002 41f4      CMP.B #$70,$000241f4 [62]
0002420A 6600 ffde                BNE.W #$ffde == $000241ea (F)
0002420E 4e75                     RTS
;------------------------------------------------------------------------------
>g																					; run
Breakpoint 0 triggered.
Cycles: 45 Chip, 90 CPU. (V=105 H=18 -> V=105 H=63)
  D0 00000000   D1 00000001   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 0001 (OR) 123c (MOVE) Chip latch 00000000
000241EA 123c 0001                MOVE.B #$01,D1
Next PC: 000241ee
;------------------------------------------------------------------------------
>g																					; run
SMC at 000241F4 - 000241F5 (1) from 000241FA										; smc found
Cycles: 4 Chip, 8 CPU. (V=105 H=63 -> V=105 H=67)
  D0 00000000   D1 00000001   D2 00000001   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 6302 (Bcc) 9401 (SUB) Chip latch 00000000
000241F2 9401                     SUB.B D1,D2
Next PC: 000241f4
;------------------------------------------------------------------------------
>g																					; run
Breakpoint 0 triggered.
Cycles: 36 Chip, 72 CPU. (V=105 H=71 -> V=105 H=107)
  D0 00000000   D1 00000001   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 0001 (OR) 123c (MOVE) Chip latch 00000000
000241EA 123c 0001                MOVE.B #$01,D1
Next PC: 000241ee
;------------------------------------------------------------------------------
>g
SMC at 000241F4 - 000241F5 (1) from 000241FA										; smc found
Cycles: 4 Chip, 8 CPU. (V=105 H=107 -> V=105 H=111)
  D0 00000000   D1 00000001   D2 00000001   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 6402 (Bcc) 9401 (SUB) Chip latch 00000000
000241F2 9401                     SUB.B D1,D2
Next PC: 000241f4
;------------------------------------------------------------------------------
>d 241F4 1																			; smc - instruction
000241F4 6402                     BCC.B #$02 == $000241f8 (T)
;------------------------------------------------------------------------------
>fd

>w 0

> x


;------------------------------------------------------------------------------
; 1. Test - >smc 0
;------------------------------------------------------------------------------
>r
Filename:Listing19n1.s
>a
Pass1
Pass2
No Errors
>j
;------------------------------------------------------------------------------

>d pc
00024EA0 66f6                     BNE.B #$f6 == $00024e98 (T)
00024EA2 123c 0001                MOVE.B #$01,D1
00024EA6 143c 0001                MOVE.B #$01,D2
00024EAA 9401                     SUB.B D1,D2
00024EAC 6202                     BHI.B #$02 == $00024eb0 (T)
00024EAE 4e71                     NOP
00024EB0 4e71                     NOP
00024EB2 0639 0001 0002 4eac      ADD.B #$01,$00024eac [62]
00024EBA 0c39 0070 0002 4eac      CMP.B #$70,$00024eac [62]
00024EC2 6600 ffde                BNE.W #$ffde == $00024ea2 (T)
>f 24EA2																		; set program breakpoint
Breakpoint added.
>w 0 0 80000 none																; memwatch breakpoint
 0: 00000000 - 0007FFFF (524288) RWI NONE
>smc 0	
SMCD disabled																	
>smc 0																			; smc enabled
SMCD enabled. Break=0
>x
;------------------------------------------------------------------------------
																				; now click left mouse-button, the debuger reopens
>d pc
00024EA2 123c 0001                MOVE.B #$01,D1
00024EA6 143c 0001                MOVE.B #$01,D2
00024EAA 9401                     SUB.B D1,D2
00024EAC 6202                     BHI.B #$02 == $00024eb0 (F)
00024EAE 4e71                     NOP
00024EB0 4e71                     NOP
00024EB2 0639 0001 0002 4eac      ADD.B #$01,$00024eac [62]
00024EBA 0c39 0070 0002 4eac      CMP.B #$70,$00024eac [62]
00024EC2 6600 ffde                BNE.W #$ffde == $00024ea2 (F)
00024EC6 4e75                     RTS
;------------------------------------------------------------------------------
>g																				; run
Breakpoint 0 triggered.
Cycles: 45 Chip, 90 CPU. (V=210 H=33 -> V=210 H=78)
  D0 00000000   D1 00000001   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 0001 (OR) 123c (MOVE) Chip latch 00000000
00024EA2 123c 0001                MOVE.B #$01,D1
Next PC: 00024ea6
;------------------------------------------------------------------------------
>g																				; run
SMC at 00024EAC - 00024EAD (1) from 00024EB2									; smc found
Breakpoint 0 triggered.
Cycles: 44 Chip, 88 CPU. (V=210 H=78 -> V=210 H=122)
  D0 00000000   D1 00000001   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 0001 (OR) 123c (MOVE) Chip latch 00000000
00024EA2 123c 0001                MOVE.B #$01,D1
Next PC: 00024ea6
;------------------------------------------------------------------------------
>g																				; run
SMC at 00024EAC - 00024EAD (1) from 00024EB2									; smc found
Breakpoint 0 triggered.
Cycles: 44 Chip, 88 CPU. (V=210 H=122 -> V=210 H=166)
  D0 00000000   D1 00000001   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 0001 (OR) 123c (MOVE) Chip latch 00000000
00024EA2 123c 0001                MOVE.B #$01,D1
Next PC: 00024ea6
;------------------------------------------------------------------------------
>g																				; run
SMC at 00024EAC - 00024EAD (1) from 00024EB2
Breakpoint 0 triggered.
Cycles: 45 Chip, 90 CPU. (V=210 H=166 -> V=210 H=211)
  D0 00000000   D1 00000001   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 0001 (OR) 123c (MOVE) Chip latch 00000000
00024EA2 123c 0001                MOVE.B #$01,D1
Next PC: 00024ea6
;------------------------------------------------------------------------------
>d 24EAC 1																		; smc - instruction
00024EAC 6602                     BNE.B #$02 == $00024eb0 (T)

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

>smc 0
SMCD disabled
>smc 0
SMCD enabled. Break=0
>smc 1
SMCD disabled
>smc 1
SMCD enabled. Break=1
>x


from EAB:

You need to add "dummy" memwatch range, for example "w 0 0 80000 none" if code is
in chip ram. 




