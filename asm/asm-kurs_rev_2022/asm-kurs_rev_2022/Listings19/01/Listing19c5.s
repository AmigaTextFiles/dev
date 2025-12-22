
; Listing19c5.s
; debugging an assembler program with a programm breakpoint
; start and run from asmone	
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

;  f <address>           Add/remove breakpoint.
;  fl                    List breakpoints.
;  fd                    Remove all breakpoints.
;  d <address> [<lines>] Disassembly starting at <address>.
;  t [instructions]      Step one or more instructions.
;  fi                    Step forward until PC points to RTS, RTD or RTE.
;  g [<address>]         Start execution at the current address or <address>.
;  z   Step through one instruction - useful for JSR, DBRA etc.

;  z   for JSR, more than one breakpoint, analyze ROM-routines
;------------------------------------------------------------------------------
;

start:

waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
	
anfang:
	move.l	4.w,a6				; Execbase
	jsr	-$78(a6)				; Disable
	lea	GfxName(PC),a1			; Libname
	jsr	-$198(a6)				; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop		; speichern die alte COP

;mouse:
;	btst	#6,$bfe001			; Mouse gedrückt?
;	bne.s	mouse

	;...
	move.l	OldCop(PC),$dff080	; Pointen auf die alte SystemCopperlist
	move.w	d0,$dff088			; Starten die alte SystemCopperlist

	move.l	4.w,a6
	jsr	-$7e(a6)				; Enable
	move.l	gfxbase(PC),a1
	jsr	-$19e(a6)				; Closelibrary
	rts

;	Daten

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0

	end

;------------------------------------------------------------------------------
>r
Filename:Listing19c5.s
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
0002197C 66f6                     BNE.B #$f6 == $00021974 (T)
0002197E 2c78 0004                MOVEA.L $0004 [00c00276],A6
00021982 4eae ff88                JSR (A6,-$0078) == $ffffff88
00021986 43fa 0036                LEA.L (PC,$0036) == $000219be,A1
0002198A 4eae fe68                JSR (A6,-$0198) == $fffffe68
0002198E 23c0 0002 19d0           MOVE.L D0,$000219d0 [00000000]
00021994 2c40                     MOVEA.L D0,A6
00021996 23ee 0026 0002 19d4      MOVE.L (A6,$0026) == $00000026 [082600fc],$000219d4 [00000000]
0002199E 23fa 0034 00df f080      MOVE.L (PC,$0034) == $000219d4 [00000000],$00dff080
000219A6 33c0 00df f088           MOVE.W D0,$00dff088
>f 2197E																		; step 2 - set breakpoint
Breakpoint added.
>x																				; leave the debugger
;------------------------------------------------------------------------------				
																				; now click left mouse and the Debugger reopens and wait on this line
>d pc																			; the actual program
0002197E 2c78 0004                MOVEA.L $0004 [00c00276],A6
00021982 4eae ff88                JSR (A6,-$0078) == $ffffff88
00021986 43fa 0036                LEA.L (PC,$0036) == $000219be,A1
0002198A 4eae fe68                JSR (A6,-$0198) == $fffffe68
0002198E 23c0 0002 19d0           MOVE.L D0,$000219d0 [00000000]
00021994 2c40                     MOVEA.L D0,A6
00021996 23ee 0026 0002 19d4      MOVE.L (A6,$0026) == $00000026 [082600fc],$000219d4 [00000000]
0002199E 23fa 0034 00df f080      MOVE.L (PC,$0034) == $000219d4 [00000000],$00dff080
000219A6 33c0 00df f088           MOVE.W D0,$00dff088
000219AC 2c78 0004                MOVEA.L $0004 [00c00276],A6
;------------------------------------------------------------------------------	
>t																				; step  3 - trace (step one)		
Cycles: 8 Chip, 16 CPU. (V=80 H=63 -> V=80 H=71)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C00276   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch ff88 (ILLEGAL) 4eae (JSR) Chip latch 00000000
00021982 4eae ff88                JSR (A6,-$0078) == $00c001fe					; jsr	-$78(a6) --> $78+00C0 0276  = $00 C0 01 FE
Next PC: 00021986
;------------------------------------------------------------------------------	
>m 0 6																			; memory from beginning adress 0
00000000 0000 0000 00C0 0276 00FC 0818 00FC 081A  .......v........				; on adress 4: 00C0 0276		
00000010 00FC 081C 00FC 081E 00FC 0820 00FC 0822  ........... ..."
00000020 00FC 090E 00FC 0826 00FC 0828 00FC 082A  .......&...(...*
00000030 00FC 082C 00FC 082E 00FC 0830 00FC 0832  ...,.......0...2
>m C00276 1																		; A6 00C00276	(move.l $4.w,a6)
00C00276 00C0 192E 00C0 03F0 0900 00FC 00A8 0400  ................
;------------------------------------------------------------------------------	
>z																				; step 4 - Step through one instruction - useful for JSR
Cycles: 41 Chip, 82 CPU. (V=102 H=167 -> V=102 H=208)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C00276   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=1 IMASK=0 STP=0
Prefetch 0036 (OR) 43fa (LEA) Chip latch 00000000
0002235A 43fa 0036                LEA.L (PC,$0036) == $00022392,A1
Next PC: 0002235e
;------------------------------------------------------------------------------	
>m 22392 2																		; LEA.L (PC,$0036) == $00022392,A1
00022392 6772 6170 6869 6373 2E6C 6962 7261 7279  graphics.library				; lea	GfxName(PC),a1			; Libname
000223A2 0000 0000 0000 0000 0000 1234 5678 0101  ...........4Vx..
;------------------------------------------------------------------------------	
>t																				; step  5 - trace (step one)	
Cycles: 4 Chip, 8 CPU. (V=102 H=208 -> V=102 H=212)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00022392   A2 00000000   A3 00000000							; A1=$22392
  A4 00000000   A5 00000000   A6 00C00276   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=1 IMASK=0 STP=0
Prefetch fe68 (ILLEGAL) 4eae (JSR) Chip latch 00000000
0002235E 4eae fe68                JSR (A6,-$0198) == $00c000de					; jsr	-$198(a6)				; OpenLibrary
Next PC: 00022362
;------------------------------------------------------------------------------																				
>d pc																			; where are we now?
0002235E 4eae fe68                JSR (A6,-$0198) == $00c000de
00022362 23c0 0002 23a4           MOVE.L D0,$000223a4 [00000000]				; set 2nd breakpoint after subroutine	
00022368 2c40                     MOVEA.L D0,A6
0002236A 23ee 0026 0002 23a8      MOVE.L (A6,$0026) == $00c0029c [ff3ffd89],$000223a8 [00000000]
00022372 23fa 0034 00df f080      MOVE.L (PC,$0034) == $000223a8 [00000000],$00dff080
0002237A 33c0 00df f088           MOVE.W D0,$00dff088
00022380 2c78 0004                MOVEA.L $0004 [00c00276],A6
00022384 4eae ff82                JSR (A6,-$007e) == $00c001f8
00022388 227a 001a                MOVEA.L (PC,$001a) == $000223a4 [00000000],A1
0002238C 4eae fe62                JSR (A6,-$019e) == $00c000d8
>f 22362																		; step 6 - set breakpoint
Breakpoint added.
>fl																				; list breakpoints
0: PC == 00022352 [00000000 00000000]
1: PC == 00022362 [00000000 00000000]											; 2nd breakpoint
;------------------------------------------------------------------------------																			
>g																				; run
Breakpoint 0 triggered.															; the breakpoint number is not correct (fixed in new versions)
Cycles: 941 Chip, 1882 CPU. (V=102 H=212 -> V=107 H=18)
  D0 00C028F6   D1 00022392   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00022392   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C00276   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 23c0 (MOVE) Chip latch 00000000
00022362 23c0 0002 23a4           MOVE.L D0,$000223a4 [00000000]				; move.l	d0,GfxBase
Next PC: 00022368
;------------------------------------------------------------------------------
>H 200																			; show the last 200 instructions
...
 0 0002235A 43fa 0036                LEA.L (PC,$0036) == $00022392,A1			; lea	GfxName(PC),a1			; Libname
 0 0002235E 4eae fe68                JSR (A6,-$0198) == $00c000de				; jsr	-$198(a6)				; OpenLibrary
 0 00C000DE 4ef9 00fc 146c           JMP $00fc146c
 0 00FC146C 7000                     MOVEQ #$00,D0
 0 00FC146E 4eae fdd8                JSR (A6,-$0228) == $00c0004e
 0 00C0004E 4ef9 00c0 6822           JMP $00c06822
 0 00C06822 518f                     SUBAQ.L #$08,A7
 0 00C06824 4879 00fe 46be           PEA.L $00fe46be
 0 00C0682A 6034                     BT .B #$34 == $00c06860 (T)
 0 00C06860 2f4d 0008                MOVE.L A5,(A7,$0008) == $00c63cdc [00000000]
 0 00C06864 4bfa 000c                LEA.L (PC,$000c) == $00c06872,A5
 0 00C06868 2f4d 0004                MOVE.L A5,(A7,$0004) == $00c63cd8 [00c06872]
 0 00C0686C 4bfa ff7c                LEA.L (PC,$ff7c) == $00c067ea,A5
 0 00C06870 4e75                     RTS
 0 00FE46BE 4e52 ffe0                LINK.W A2,#$ffe0
 0 00FE46C2 48ea 1b03 ffe8           MOVEM.L D0-D1/A0-A1/A3-A4,(A2,-$0018) == $00c63cbc
 0 00FE46C8 47ed 008c                LEA.L (A5,$008c) == $00c06876,A3
 0 00FE46CC 2549 ffe0                MOVE.L A1,(A2,-$0020) == $00c63cb4 [00022392]
 0 00FE46D0 6012                     BT .B #$12 == $00fe46e4 (T)
 0 00FE46E4 6100 01b8                BSR.W #$01b8 == $00fe489e
 0 00FE489E 4cea 0303 ffe8           MOVEM.L (A2,-$0018) == $00c63cbc,D0-D1/A0-A1
 0 00FE48A4 2f2b 0000                MOVE.L (A3,$0000) == $00c06876 [00fe48c0],-(A7) [00fe48c8]
 0 00FE48A8 2c6d 0022                MOVEA.L (A5,$0022) == $00c0680c [00c00276],A6
 0 00FE48AC 4e75                     RTS
 0 00FE48C0 226a ffe0                MOVEA.L (A2,-$0020) == $00c63cb4 [00022392],A1
 0 00FE48C4 4ead ffdc                JSR (A5,-$0024) == $00c067c6
 0 00C067C6 4ef9 00fc 1474           JMP $00fc1474
 0 00FC1474 2f02                     MOVE.L D2,-(A7) [00000000]
 0 00FC1476 2400                     MOVE.L D0,D2
 0 00FC1478 522e 0127                ADDQ.B #$01,(A6,$0127) == $00c0039d [ff]
 0 00FC147C 41ee 017a                LEA.L (A6,$017a) == $00c003f0,A0
 0 00FC1480 6100 0214                BSR.W #$0214 == $00fc1696
 0 00FC1696 2f0a                     MOVE.L A2,-(A7) [00fc1498]
 0 00FC1698 2448                     MOVEA.L A0,A2
 0 00FC169A 2209                     MOVE.L A1,D1
 0 00FC169C 2012                     MOVE.L (A2) [00c00276],D0
 0 00FC169E 6718                     BEQ.B #$18 == $00fc16b8 (F)
 0 00FC16A0 2440                     MOVEA.L D0,A2
 0 00FC16A2 2012                     MOVE.L (A2) [00c0192e],D0
 0 00FC16A4 6712                     BEQ.B #$12 == $00fc16b8 (F)
 0 00FC16A6 206a 000a                MOVEA.L (A2,$000a) == $00c00280 [00fc00a8],A0
 0 00FC16AA 2241                     MOVEA.L D1,A1
 0 00FC16AC b308                     CMPM.B (A0)+ [65],(A1)+ [67]
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16A0 2440                     MOVEA.L D0,A2
 0 00FC16A2 2012                     MOVE.L (A2) [00c028f6],D0
 0 00FC16A4 6712                     BEQ.B #$12 == $00fc16b8 (F)
 0 00FC16A6 206a 000a                MOVEA.L (A2,$000a) == $00c01938 [00fc4bb0],A0
 0 00FC16AA 2241                     MOVEA.L D1,A1
 0 00FC16AC b308                     CMPM.B (A0)+ [65],(A1)+ [67]
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16A0 2440                     MOVEA.L D0,A2
 0 00FC16A2 2012                     MOVE.L (A2) [00c04466],D0
 0 00FC16A4 6712                     BEQ.B #$12 == $00fc16b8 (F)
 0 00FC16A6 206a 000a                MOVEA.L (A2,$000a) == $00c02900 [00fc53fe],A0
 0 00FC16AA 2241                     MOVEA.L D1,A1
 0 00FC16AC b308                     CMPM.B (A0)+ [67],(A1)+ [67]					; $67 = g	the ascii-numbers
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc53fe [67]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [72],(A1)+ [72]					; $72 = r
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc53ff [72]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [61],(A1)+ [61]					; $61 = a
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc5400 [61]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [70],(A1)+ [70]					; $70 = p
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc5401 [70]	
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [68],(A1)+ [68]					; $68 = h
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc5402 [68]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [69],(A1)+ [69]					; $69 = i
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc5403 [69]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [63],(A1)+ [63]					; $63 =	c
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc5404 [63]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [73],(A1)+ [73]
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc5405 [73]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [2e],(A1)+ [2e]
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc5406 [2e]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [6c],(A1)+ [6c]
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc5407 [6c]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [69],(A1)+ [69]
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc5408 [69]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [62],(A1)+ [62]
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc5409 [62]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [72],(A1)+ [72]
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc540a [72]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [61],(A1)+ [61]
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc540b [61]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [72],(A1)+ [72]
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc540c [72]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [79],(A1)+ [79]
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc540d [79]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16AC b308                     CMPM.B (A0)+ [00],(A1)+ [00]
 0 00FC16AE 66f0                     BNE.B #$f0 == $00fc16a0 (T)
 0 00FC16B0 4a28 ffff                TST.B (A0,-$0001) == $00fc540e [00]
 0 00FC16B4 66f6                     BNE.B #$f6 == $00fc16ac (T)
 0 00FC16B6 200a                     MOVE.L A2,D0
 0 00FC16B8 2241                     MOVEA.L D1,A1
 0 00FC16BA 245f                     MOVEA.L (A7)+ [00fc1498],A2
 0 00FC16BC 4e75                     RTS
 0 00FC1484 4a80                     TST.L D0
 0 00FC1486 6712                     BEQ.B #$12 == $00fc149a (F)
 0 00FC1488 2040                     MOVEA.L D0,A0
 0 00FC148A b468 0014                CMP.W (A0,$0014) == $00c0290a [0022],D2
 0 00FC148E 6ef0                     BGT.B #$f0 == $00fc1480 (T)
 0 00FC1490 2f0e                     MOVE.L A6,-(A7) [00fc149e]
 0 00FC1492 2c48                     MOVEA.L A0,A6
 0 00FC1494 4eae fffa                JSR (A6,-$0006) == $00c028f0
 0 00C028F0 4ef9 00fc 6d40           JMP $00fc6d40
 0 00FC6D40 200e                     MOVE.L A6,D0
 0 00FC6D42 4e75                     RTS
 0 00FC1498 2c5f                     MOVEA.L (A7)+ [00fc149e],A6
 0 00FC149A 4eae ff76                JSR (A6,-$008a) == $00c001ec
 0 00C001EC 4ef9 00fc 1f9c           JMP $00fc1f9c
 0 00FC1F9C 532e 0127                SUBQ.B #$01,(A6,$0127) == $00c0039d [ff]
 0 00FC1FA0 6c1a                     BGE.B #$1a == $00fc1fbc (T)
 0 00FC1FA2 4a2e 0126                TST.B (A6,$0126) == $00c0039c [00]
 0 00FC1FA6 6c14                     BGE.B #$14 == $00fc1fbc (T)
 0 00FC1FBC 4e75                     RTS
 0 00FC149E 241f                     MOVE.L (A7)+ [00000000],D2
 0 00FC14A0 4e75                     RTS
 0 00FE48C8 2540 ffe4                MOVE.L D0,(A2,-$001c) == $00c63cb8 [00c028f6]
 0 00FE48CC 60e0                     BT .B #$e0 == $00fe48ae (T)
 0 00FE48AE 660e                     BNE.B #$0e == $00fe48be (T)
 0 00FE48BE 4e75                     RTS
 0 00FE46E8 6600 0132                BNE.W #$0132 == $00fe481c (T)
 0 00FE481C 202a ffe4                MOVE.L (A2,-$001c) == $00c63cb8 [00c028f6],D0
 0 00FE4820 4cea 1800 fff8           MOVEM.L (A2,-$0008) == $00c63ccc,A3-A4
 0 00FE4826 4e5a                     UNLK.L A2
 0 00FE4828 4e75                     RTS
 0 00C06872 2a5f                     MOVEA.L (A7)+ [00000000],A5
 0 00C06874 4e75                     RTS
 0 00FC1472 4e75                     RTS
 0 00022362 23c0 0002 23a4           MOVE.L D0,$000223a4 [00000000]				; move.l	d0,GfxBase 
>
;------------------------------------------------------------------------------
>d pc																			; where are we now?
00022362 23c0 0002 23a4           MOVE.L D0,$000223a4 [00000000]				; move.l	d0,GfxBase
00022368 2c40                     MOVEA.L D0,A6
0002236A 23ee 0026 0002 23a8      MOVE.L (A6,$0026) == $00c0029c [ff3ffd89],$000223a8 [00000000]
00022372 23fa 0034 00df f080      MOVE.L (PC,$0034) == $000223a8 [00000000],$00dff080
0002237A 33c0 00df f088           MOVE.W D0,$00dff088
00022380 2c78 0004                MOVEA.L $0004 [00c00276],A6
00022384 4eae ff82                JSR (A6,-$007e) == $00c001f8
00022388 227a 001a                MOVEA.L (PC,$001a) == $000223a4 [00000000],A1
0002238C 4eae fe62                JSR (A6,-$019e) == $00c000d8
00022390 4e75                     RTS
;------------------------------------------------------------------------------
>r
  D0 00C028F6   D1 00022392   D2 00000000   D3 00000000							; D0 = $C028F6
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00022392   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C00276   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 23c0 (MOVE) Chip latch 00000000
00022362 23c0 0002 23a4           MOVE.L D0,$000223a4 [00000000]				; move.l	d0,GfxBase
Next PC: 00022368
;------------------------------------------------------------------------------
>m 223a4 1
000223A4 0000 0000 0000 0000 1234 5678 0101 0000  .........4Vx....				; [00000000]
;------------------------------------------------------------------------------
>t																				; step 7 - trace (step one)
Cycles: 10 Chip, 20 CPU. (V=107 H=18 -> V=107 H=28)
  D0 00C028F6   D1 00022392   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00022392   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C00276   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 23ee (MOVE) 2c40 (MOVEA) Chip latch 00000000
00022368 2c40                     MOVEA.L D0,A6
Next PC: 0002236a
;------------------------------------------------------------------------------
>m 223a4 1
000223A4 00C0 28F6 0000 0000 1234 5678 0101 0000  ..(......4Vx....				; move.l	d0,GfxBase		GfxBase = $C0 28F6
>
