
; Listing19c4.s	(; Debugger with failure)
; debugging an assembler program with a programm breakpoint
; start and run from shell	
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

;  fp "<name>"/<addr>    Step forward until process <name> or <addr> is active.
;  fl                    List breakpoints.
;  fd                    Remove all breakpoints.
;  d <address> [<lines>] Disassembly starting at <address>.
;  t [instructions]      Step one or more instructions.
;  fi                    Step forward until PC points to RTS, RTD or RTE.
;------------------------------------------------------------------------------

start:

;waitmouse:  
;	btst	#6,$bfe001	; left mousebutton?
;	bne.s	Waitmouse	

	lea	dog,a0
	move.L	#dog,a1
	move.L	dog,a2
	move.l	#$AA,cat1
	move.l	a1,cat2
	move.l	a2,cat3
	move.l	#$BB,cat1
	move.l	a1,cat2
	move.l	a2,cat3
	rts

dog:
	dc.l	$12345678
cat1:
	dc.l	0
cat2:
	dc.l	0
cat3:
	dc.l	0

	end
;------------------------------------------------------------------------------
																				; make an exe-file
>r 
Listing19c4.s
>a
Pass1
Pass2
No Errors
>wo
filename:L19c4
																				; change to shell by multitasking
																				; or leave asmone with >!
																				; >list ; show the files in shell
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12

>fp "L19c4"
																				; the x-command is not possible now
;------------------------------------------------------------------------------
																				; in the shell
>L19c4																			; insert (Listing19c4) and start the program with enter
																				; we don't need to wait for the left mousebutton
;------------------------------------------------------------------------------
																				; the debugger leaves open !

  D0 00000000   D1 00000000   D2 40000000   D3 52718245
  D4 000E77FE   D5 00000000   D6 80000000   D7 C0000000
  A0 00C0040C   A1 00C031DA   A2 00FDFF50   A3 00C00410
  A4 00FC0FE2   A5 00C041E0   A6 00C00276   A7 00C80000
USP  00C04222 ISP  00C80000
T=00 S=1 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=1
Prefetch 4e72 (STOP) 2000 (MOVE) Chip latch 00000003
00fc0f94 60e6                     bra.b #$e6 == $00fc0f7c (T)
Next PC: 00fc0f96
;------------------------------------------------------------------------------
>fp "L19c4"																		; Step forward until process <name> is active.
Breakpoint 0 triggered.															; with ""
Cycles: 1690310 Chip, 3380620 CPU. (V=210 H=0 -> V=184 H=168)
  D0 00000001   D1 00C22A88   D2 00000FA0   D3 00000FA8
  D4 00000001   D5 0000003E   D6 00308A49   D7 00308A56
  A0 00C22A88   A1 00C22B98   A2 00C063D8   A3 00C1C284
  A4 00C25650   A5 00FF4134   A6 00FF4128   A7 00C2564C
USP  00C2564C ISP  00C80000
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 41f9 (LEA) 00c1 (ILLEGAL) Chip latch 00000003
00c1c288 41f9 00c1 c2c8           lea.l $00c1c2c8,a0
Next PC: 00c1c28e
;------------------------------------------------------------------------------
>d pc
00c1c288 41f9 00c1 c2c8           lea.l $00c1c2c8,a0
00c1c28e 227c 00c1 c2c8           movea.l #$00c1c2c8,a1
00c1c294 2479 00c1 c2c8           movea.l $00c1c2c8 [12345678],a2
00c1c29a 23fc 0000 00aa 00c1 c2cc move.l #$000000aa,$00c1c2cc [00000000]
00c1c2a4 23c9 00c1 c2d0           move.l a1,$00c1c2d0 [00000000]
00c1c2aa 23ca 00c1 c2d4           move.l a2,$00c1c2d4 [00000000]
00c1c2b0 23fc 0000 00bb 00c1 c2cc move.l #$000000bb,$00c1c2cc [00000000]
00c1c2ba 23c9 00c1 c2d0           move.l a1,$00c1c2d0 [00000000]
00c1c2c0 23ca 00c1 c2d4           move.l a2,$00c1c2d4 [00000000]
00c1c2c6 4e75                     rts  == $00ff492e
>
;------------------------------------------------------------------------------  
>t																				; one step
Breakpoint 0 triggered.															; failure (no breakpoint)
Cycles: 6 Chip, 12 CPU. (V=184 H=168 -> V=184 H=174)
  D0 00000001   D1 00C22A88   D2 00000FA0   D3 00000FA8
  D4 00000001   D5 0000003E   D6 00308A49   D7 00308A56
  A0 00C1C2C8   A1 00C22B98   A2 00C063D8   A3 00C1C284
  A4 00C25650   A5 00FF4134   A6 00FF4128   A7 00C2564C
USP  00C2564C ISP  00C80000
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 227c (MOVEA) 00c1 (ILLEGAL) Chip latch 00000003
00c1c28e 227c 00c1 c2c8           movea.l #$00c1c2c8,a1
Next PC: 00c1c294
;------------------------------------------------------------------------------ 
>t 3																			; three steps (don#t work)
Breakpoint 0 triggered.															; failure (no breakpoint)
Cycles: 6 Chip, 12 CPU. (V=184 H=174 -> V=184 H=180)
  D0 00000001   D1 00C22A88   D2 00000FA0   D3 00000FA8
  D4 00000001   D5 0000003E   D6 00308A49   D7 00308A56
  A0 00C1C2C8   A1 00C1C2C8   A2 00C063D8   A3 00C1C284
  A4 00C25650   A5 00FF4134   A6 00FF4128   A7 00C2564C
USP  00C2564C ISP  00C80000
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 2479 (MOVEA) 00c1 (ILLEGAL) Chip latch 00000003
00c1c294 2479 00c1 c2c8           movea.l $00c1c2c8 [12345678],a2
Next PC: 00c1c29a
;------------------------------------------------------------------------------
>fi																				; fi - run to next rts, don't work
Breakpoint 0 triggered.															; failure (no breakpoint)
Cycles: 10 Chip, 20 CPU. (V=184 H=180 -> V=184 H=190)
  D0 00000001   D1 00C22A88   D2 00000FA0   D3 00000FA8
  D4 00000001   D5 0000003E   D6 00308A49   D7 00308A56
  A0 00C1C2C8   A1 00C1C2C8   A2 12345678   A3 00C1C284
  A4 00C25650   A5 00FF4134   A6 00FF4128   A7 00C2564C
USP  00C2564C ISP  00C80000
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 23fc (MOVE) 0000 (OR) Chip latch 00000003
00c1c29a 23fc 0000 00aa 00c1 c2cc move.l #$000000aa,$00c1c2cc [00000000]
Next PC: 00c1c2a4
;------------------------------------------------------------------------------
>fi rts																			; fi - run to next rts, don't work
Breakpoint 0 triggered.															; failure (no breakpoint)
Cycles: 14 Chip, 28 CPU. (V=184 H=190 -> V=184 H=204)
  D0 00000001   D1 00C22A88   D2 00000FA0   D3 00000FA8
  D4 00000001   D5 0000003E   D6 00308A49   D7 00308A56
  A0 00C1C2C8   A1 00C1C2C8   A2 12345678   A3 00C1C284
  A4 00C25650   A5 00FF4134   A6 00FF4128   A7 00C2564C
USP  00C2564C ISP  00C80000
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 23c9 (MOVE) 00c1 (ILLEGAL) Chip latch 00000003
00c1c2a4 23c9 00c1 c2d0           move.l a1,$00c1c2d0 [00000000]
Next PC: 00c1c2aa
;------------------------------------------------------------------------------
>x																				; leave the debugger
 
