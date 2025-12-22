
; Listing19d2.s
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
	;move.b	$7ffff,d0			; w 0 $7ffff 1 (alternativ see bottom of text)

	lea	dog,a0
	move.L	#dog,a1				; Test 1		; move.l	$12345678,a1
	move.L	dog,a2								; movea.l	$00021000,a2
	move.l	#$AA,cat1
	move.l	a1,cat2
	move.l	a2,cat3
	move.l	#$BB,cat1
	move.l	a1,cat2
	move.l	a2,cat3

	sub.b #-2,$22020			; Test 2		

	rts

	org $21000
dog:
	dc.l	$12345678			; $21000
cat1:
	dc.l	0					; $21004
cat2:	
	dc.l	0					; $21008	
cat3:
	dc.l	0					; $2100c

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
Filename:Listing19d2.s
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
;------------------------------------------------------------------------------
>m 22000
00022000 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022010 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022020 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022030 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022040 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022050 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022060 FFFF FFFF 3233 3843 4120 2831 2920 5257  ....238CA (1) RW
;------------------------------------------------------------------------------
>m 23000
00023000 18C6 191A 1944 1998 19EC 1A16 1A6A 1A94  .....D.......j..
00023010 1AE8 1B12 1B3C 1B66 1B90 1BBA 1BBA 1BE4  .....<.f........
00023020 1BE4 1BE4 1BE4 1BE4 1BBA 1BBA 1B90 1B66  ...............f
00023030 1B3C 1B12 1AE8 1A94 1A6A 1A16 19EC 1998  .<.......j......
00023040 1944 191A 18C6 1872 181E 17F4 17A0 174C  .D.....r.......L
00023050 1722 16CE 16A4 1650 1626 15FC 15D2 15A8  .".....P.&......
00023060 157E 157E 1554 1554 1554 1554 1554 157E  .~.~.T.T.T.T.T.~
00023070 157E 15A8 15D2 15FC 1626 1650 16A4 16CE  .~.......&.P....
00023080 1722 174C 17A0 17F4 181E 1872 0000 0000  .".L.......r....
00023090 0000 0000 0000 0000 0000 0000 0000 0000  ................
>
;------------------------------------------------------------------------------
>w 0 21000																		; step 2 - set memwatchpoint w <num> <address>
Memwatch breakpoints enabled
 0: 00021000 - 00021000 (1) RWI CPU
>x																				; close debugger
;------------------------------------------------------------------------------						
																				; now click left mousebutton and the Debugger reopens
Memwatch 0: break at 00021000.W R   00000000 PC=00020016 CPUDR (000)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00021000   A1 00021000   A2 12345678   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0000 (OR) 23fc (MOVE) Chip latch 00000000
00020016 2479 0002 1000           MOVEA.L $00021000 [12345678],A2
0002001C 23fc 0000 00aa 0002 1004 MOVE.L #$000000aa,$00021004 [00000000]
Next PC: 00020026
>d pc																			; where are we now?
0002001C 23fc 0000 00aa 0002 1004 MOVE.L #$000000aa,$00021004 [00000000]
00020026 23c9 0002 1008           MOVE.L A1,$00021008 [00000000]
0002002C 23ca 0002 100c           MOVE.L A2,$0002100c [00000000]
00020032 23fc 0000 00bb 0002 1004 MOVE.L #$000000bb,$00021004 [00000000]
0002003C 23c9 0002 1008           MOVE.L A1,$00021008 [00000000]
00020042 23ca 0002 100c           MOVE.L A2,$0002100c [00000000]
00020048 4e75                     RTS
>d pc-10																		; some instructions before
0002000C 0002 1000                OR.B #$00,D2
00020010 227c 0002 1000           MOVEA.L #$00021000,A1							; the cause
00020016 2479 0002 1000           MOVEA.L $00021000 [12345678],A2				; PC stands here PC=00020016
;-----------------------------------------------------------------------------
>w 0 22010 30																	; step 3 - set memwatchpoint w <num> <address> <length>
Memwatch breakpoints enabled
 0: 00022010 - 0002203F (48) RWI CPU
;-----------------------------------------------------------------------------
>m 22000
00022000 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................				; memory watchpoint adress range:
00022010 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................				; memory access start here:    $22010
00022020 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................				;							    ---
00022030 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................				; memory access end here:      $2203F
00022040 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022050 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022060 FFFF FFFF 3820 2836 3830 3230 2B29 205B  ....8 (68020+) [
>x																				; close debugger
;------------------------------------------------------------------------------						
																				; now click left mousebutton and the Debugger reopens
Memwatch 0: break at 00022020.B  W  00000001 PC=00020048 CPUDW (000)			; 0: 00022010 - 0002203F (48) RWI CPU
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00021000   A1 00021000   A2 12345678   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 2044 (MOVEA) 4e75 (RTS) Chip latch 00000000
00020048 0439 00fe 0002 2020      SUB.B #$fe,$00022020 [01]						; caused programline PC=00020048
00020050 4e75                     RTS
Next PC: 00020052
;------------------------------------------------------------------------------	
; >d pc-10																		; some instructions before
;00020040 1008                     ILLEGAL
;00020042 23ca 0002 100c           MOVE.L A2,$0002100c [12345678]
;00020048 0439 00fe 0002 2020      SUB.B #$fe,$00022020 [01]					; the cause
;00020050 4e75                     RTS
;-----------------------------------------------------------------------------
>w 0 22010 30  R DMA															; 3. w <num> <address> <length> <R/W/I/F/C> <channel> 
0: 00022010 - 0002203F (48) R   DMA
>w 1 22010 30  R CPU
1: 00022010 - 0002203F (48) R   CPU

>x																				; close debugger
;------------------------------------------------------------------------------						
																				; now click left mouse and the Debugger reopens																				
Memwatch 1: break at 00022020.B R   00000000 PC=00020048 CPUDR (000)			; memwatch 1: break because R CPU and not R DMA
  D0 00000000   D1 00000000   D2 00000000   D3 00000000							 
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00021000   A1 00021000   A2 12345678   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 2d2d (MOVE) 4e75 (RTS) Chip latch 00000000
00020048 0439 00fe 0002 2020      SUB.B #$fe,$00022020 [01]
00020050 4e75                     RTS
Next PC: 00020052
>
;---------------------------------------------------------------	
>w																				; list all memory watchpoints
 0: 00022010 - 0002203F (48) R   DMA
 1: 00022010 - 0002203F (48) R   CPU
>wd																				; its not delete the memory breakpoints like >fd
Illegal memory access logging enabled. Break=0									; !!!
>w 0
Memwatch 0 removed
>w 1
Memwatch 1 removed
>


;------------------------------------------------------------------------------
; from EAB
Much faster method to "find" your code is to have instruction like
clr.w $100 before the code you need to debug and use
memwatch point to break when $100 is accessed (for example "w 0 100 2")

The watch points are better to use in my opinion because you can filter on the
types of operation and the source of it (CPU, BLIITER channel, COPPER etc).
I use a write then a memwatch in $DFF180. Or any other color register that are
usually only written by the copper. Or read the register and use a read breakpoint.

;------------------------------------------------------------------------------
; alternativ to trigger a programstart debugging entry
	;btst	#6,$bfe001			; left mousebutton?
	;bne.s	Waitmouse
	move.b	$7ffff,d0			; w 0 $7ffff 1

;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
>w 0 $7ffff 1																	; set memorywatchpoint
 0: 0007FFFF - 0007FFFF (1) RWI CPU
>
;------------------------------------------------------------------------------
>r
Filename:Listing19d2.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm	
;------------------------------------------------------------------------------
																				; Debugger opens
Memwatch 0: break at 0007FFFF.B R   00000000 PC=00020000 CPUDR (000)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00021000   A1 00021000   A2 12345678   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 41f9 (LEA) 0002 (OR) Chip latch 00000002
00020000 1039 0007 ffff           move.b $0007ffff [00],d0
00020006 41f9 0002 1000           lea.l $00021000,a0
Next PC: 0002000c
>d pc
00020006 41f9 0002 1000           lea.l $00021000,a0
0002000c 227c 0002 1000           movea.l #$00021000,a1
00020012 2479 0002 1000           movea.l $00021000 [12345678],a2
00020018 23fc 0000 00aa 0002 1004 move.l #$000000aa,$00021004 [00000000]
00020022 23c9 0002 1008           move.l a1,$00021008 [00000000]
00020028 23ca 0002 100c           move.l a2,$0002100c [00000000]
0002002e 23fc 0000 00bb 0002 1004 move.l #$000000bb,$00021004 [00000000]
00020038 23c9 0002 1008           move.l a1,$00021008 [00000000]
0002003e 23ca 0002 100c           move.l a2,$0002100c [00000000]
00020044 0439 00fe 0002 2020      sub.b #$fe,$00022020 [ff]