
; Listing19d4.s
; (WinUAE 4.9.0 A500 configuration)
; task: debugging a assembler program with a memory watchpoint
;	    from asmone
;
; explains:
; w <num> <address> <length> <R/W/I/F/C> [<value>[.x]] (read/write/opcode/freeze/mustchange).
;                        Add/remove memory watchpoints.
;----------------------------------------------------------
; 
	ORG $20000
	LOAD $20000
	JUMPPTR start

start:
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse


	move.b	#$AA,$22000			; mit >w 0 22000 2 fw	memory content stays unchangend
	move.w	#$0123,$22002		; mit >w 1 22002 2 fr
	move.l  $22000,d0
	rts

	org $22000
daten:
	blk.b 100,$FF

	org $23000
Sinustab:
	DC.W	$18C6,$191A,$1944,$1998,$19EC,$1A16,$1A6A,$1A94,$1AE8,$1B12
	DC.W	$1B3C,$1B66,$1B90,$1BBA,$1BBA,$1BE4,$1BE4,$1BE4,$1BE4,$1BE4
	DC.W	$1BBA,$1BBA,$1B90,$1B66,$1B3C,$1B12,$1AE8,$1A94,$1A6A,$1A16
	DC.W	$19EC,$1998,$1944,$191A,$18C6,$1872,$181E,$17F4,$17A0,$174C
	DC.W	$1722,$16CE,$16A4,$1650,$1626,$15FC,$15D2,$15A8,$157E,$157E
	DC.W	$1554,$1554,$1554,$1554,$1554,$157E,$157E,$15A8,$15D2,$15FC
	DC.W	$1626,$1650,$16A4,$16CE,$1722,$174C,$17A0,$17F4,$181E,$1872
EndSinustab:

	end

;------------------------------------------------------------------------------
>r
Filename:Listing19d4.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
Couldn't open 'amiga.lib'														; 'amiga.lib' not needed for normal work with debugger
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 13fc (MOVE) 66f6 (Bcc) Chip latch 00000000
00020008 66f6                     BNE.B #$f6 == $00020000 (T)
Next PC: 0002000a
;------------------------------------------------------------------------------
>d pc
00020008 66f6                     BNE.B #$f6 == $00020000 (T)
0002000A 13fc 00aa 0002 2000      MOVE.B #$aa,$00022000 [ff]
00020012 33fc 0123 0002 2002      MOVE.W #$0123,$00022002 [ffff]
0002001A 2039 0002 2000           MOVE.L $00022000 [ffffffff],D0
00020020 41f9 0002 1000           LEA.L $00021000,A0
00020026 227c 0002 1000           MOVEA.L #$00021000,A1
0002002C 2479 0002 1000           MOVEA.L $00021000 [12345678],A2
00020032 23fc 0000 00aa 0002 1004 MOVE.L #$000000aa,$00021004 [00000000]
0002003C 23c9 0002 1008           MOVE.L A1,$00021008 [00000000]
00020042 23ca 0002 100c           MOVE.L A2,$0002100c [00000000]
;------------------------------------------------------------------------------
>m 22000 2																		; view memory
00022000 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022010 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
;------------------------------------------------------------------------------
>f 2000A																		; step 2 - set breakpoint
Breakpoint added.
>w 0 22000 2 fw																	; step 3 - set memwatchpoint with freeze write
Memwatch breakpoints enabled
 0: 00022000 - 00022001 (2)  W  F CPU
>x																				; leave debugger
;------------------------------------------------------------------------------
																				; now click left mousebutton and the Debugger reopens
Breakpoint 0 triggered.
  D0 FFFF01FF   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00021000   A1 00021000   A2 12345678   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 00aa (OR) 13fc (MOVE) Chip latch 00000000
0002000A 13fc 00aa 0002 2000      MOVE.B #$aa,$00022000 [ff]					; actual pc=2000A (our breakpoint 0)
Next PC: 00020012
;------------------------------------------------------------------------------
>m 22000 2																		; view memory
00022000 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022010 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
;------------------------------------------------------------------------------
>fi																				; step 3 - run to the next rts
Cycles: 139 Chip, 278 CPU. (V=74 H=120 -> V=75 H=32)
  D0 FFFF0123   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00021000   A1 00021000   A2 12345678   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C64CDA
USP  00C63CE8 ISP  00C64CDA
T=00 S=1 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 007c (ORSR) 4e75 (RTS) Chip latch 00000000
00FC08E4 4e75                     RTS
Next PC: 00fc08e6
;------------------------------------------------------------------------------
>m 22000 2
00022000 FFFF 0123 FFFF FFFF FFFF FFFF FFFF FFFF  ...#............				; value on adress 22000 unchanged
00022010 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................				; because is freezed (w 0 22000 2 fw)
>
