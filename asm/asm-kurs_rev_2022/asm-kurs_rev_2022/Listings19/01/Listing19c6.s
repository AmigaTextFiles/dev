
; Listing19c6.s
; debugging an assembler program with a programm breakpoint
; start and run from asmone	
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

;  f <address>           Add/remove breakpoint.
;  f <addr1> <addr2>     Step forward until <addr1> <= PC <= <addr2>.
;  fo <num> <reg> <oper> <val> [<mask> <val2>] Conditional register breakpoint.
;  reg=Dx,Ax,PC,USP,ISP,VBR,SR. oper:!=,==,<,>,>=,<=,-,!- (-=val to val2 range).
;  fl                    List breakpoints.
;  fd                    Remove all breakpoints.
;  d <address> [<lines>] Disassembly starting at <address>.
;  t [instructions]      Step one or more instructions.
;------------------------------------------------------------------------------

	ORG $20000
	LOAD $20000
	JUMPPTR start

start:

waitmouse:  
	btst	#6,$bfe001	; left mousebutton?
	bne.s	waitmouse	

	move.b #8,d0

	move.l #$20F00,a0
	move.l #$21032,a0
	move.l #$21132,a0
	move.l #$21000,a0
	move.l #$20FFF,a0
	move.l #$210FF,a0
	move.l #$211FF,a0
	move.l #$2105F,a0
	
	;lea	dog,a0
	move.L	#dog,a1
	move.L	dog,a2
	move.l	#$AA,cat1
	move.l	a1,cat2
	move.l	a2,cat3
	move.l	#$BB,cat1
	move.l	a1,cat2
	move.l	a2,cat3
	rts

	org $21000
dog:						; $21000
	dc.l	$12345678			
cat1:						; $21004					
	dc.l	0
cat2:						; $21008
	dc.l	0
cat3:						; $2100c
	dc.l	0

	end

;------------------------------------------------------------------------------
>r
Filename:Listing19c6.s
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
00020008 66f6                     BNE.B #$f6 == $00020000 (T)
0002000A 41f9 0002 1000           LEA.L $00021000,A0
00020010 227c 0002 1000           MOVEA.L #$00021000,A1
00020016 2479 0002 1000           MOVEA.L $00021000 [12345678],A2
0002001C 23fc 0000 00aa 0002 1004 MOVE.L #$000000aa,$00021004 [00000000]
00020026 23c9 0002 1008           MOVE.L A1,$00021008 [00000000]
0002002C 23ca 0002 100c           MOVE.L A2,$0002100c [00000000]
00020032 23fc 0000 00bb 0002 1004 MOVE.L #$000000bb,$00021004 [00000000]
0002003C 23c9 0002 1008           MOVE.L A1,$00021008 [00000000]
00020042 23ca 0002 100c           MOVE.L A2,$0002100c [00000000]																				
>fo 0 A0==$21000																; step 1 - set a conditional breakpoint
Breakpoint added.																; fo <num> <reg> <oper> <val> Conditional register breakpoint.
>fl																				; list breakpoints
0: A0 == 00021000 [ffffffff 00000000]
>
>x																				; leave the debugger
;------------------------------------------------------------------------------				
																				; now click left mouse and the Debugger reopens and wait on this line
>d pc																			; the actual program

Breakpoint 0 triggered.
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00021000   A1 00000000   A2 00000000   A3 00000000							; A0 00021000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 227c (MOVEA) Chip latch 00000000
00020010 227c 0002 1000           MOVEA.L #$00021000,A1
Next PC: 00020016
;------------------------------------------------------------------------------	
>d pc																			; the actual program
00020010 227c 0002 1000           MOVEA.L #$00021000,A1
00020016 2479 0002 1000           MOVEA.L $00021000 [12345678],A2
0002001C 23fc 0000 00aa 0002 1004 MOVE.L #$000000aa,$00021004 [00000000]
00020026 23c9 0002 1008           MOVE.L A1,$00021008 [00000000]
0002002C 23ca 0002 100c           MOVE.L A2,$0002100c [00000000]
00020032 23fc 0000 00bb 0002 1004 MOVE.L #$000000bb,$00021004 [00000000]
0002003C 23c9 0002 1008           MOVE.L A1,$00021008 [00000000]
00020042 23ca 0002 100c           MOVE.L A2,$0002100c [00000000]
00020048 4e75                     RTS
0002004A 0000 0000                OR.B #$00,D0
>fl
0: A0 == 00021000 [ffffffff 00000000]

>fd
All breakpoints removed.
>
