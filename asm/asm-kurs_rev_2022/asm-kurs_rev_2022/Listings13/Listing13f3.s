
; Listing13f3.s	Code-Erweiterungstechnik
; Zeile 1568
; 64*2 Bytes=128 Bytes kopieren	, wegen Befehls-Cache auf 68020 "vermittelte" Technik
; 1392 Zyklen

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse: 
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	

	lea	Table,a2				; Quelle
	lea	Table2,a1				; Ziel

;-------------------------------;
ROUTINE2:
	MOVEQ	#4-1,D0				; nur 4 Zyklen (64/16)							; 4 Zyklen
FASTLOOP2:
	MOVE.W	(a2),(a1)			; 1												; 12 Zyklen
	MOVE.W	8(a2),4(a1)			; 2												; 20 Zyklen
	MOVE.W	8*2(a2),4*2(a1)		; 3
	MOVE.W	8*3(a2),4*3(a1)		; 4
	MOVE.W	8*4(a2),4*4(a1)		; 5
	MOVE.W	8*5(a2),4*5(a1)		; ...
	MOVE.W	8*6(a2),4*6(a1)
	MOVE.W	8*7(a2),4*7(a1)
	MOVE.W	8*8(a2),4*8(a1)
	MOVE.W	8*9(a2),4*9(a1)
	MOVE.W	8*10(a2),4*10(a1)
	MOVE.W	8*11(a2),4*11(a1)
	MOVE.W	8*12(a2),4*12(a1)
	MOVE.W	8*13(a2),4*13(a1)
	MOVE.W	8*14(a2),4*14(a1)
	MOVE.W	8*15(a2),4*15(a1)	; 16
	ADD.w	#4*16,a1															; 12 Zyklen
	ADD.w	#8*16,a2															; 12 Zyklen
	DBRA	D0,FASTLOOP2														; 10 Zyklen / (14 Zyklen)
;-------------------------------;	
	nop							; an dieser Stelle ist die Aufgabe erledigt
	move.w #$C000,$dff09a		; Interrupts enable
	rts

Table:
	blk.w 1024,$FFFF
		
Table2:
	blk.w 1024,$0000
	end

;------------------------------------------------------------------------------
r
Filename: Listing13f3.s
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
000240c8 66f6                     bne.b #$f6 == $000240c0 (T)
000240ca 45f9 0002 414c           lea.l $0002414c,a2
000240d0 43f9 0002 494c           lea.l $0002494c,a1
000240d6 7003                     moveq #$03,d0
000240d8 3292                     move.w (a2) [ffff],(a1) [0000]
000240da 336a 0008 0004           move.w (a2,$0008) == $0002484a [ffff],(a1,$0004) == $00025046 [0000]
000240e0 336a 0010 0008           move.w (a2,$0010) == $00024852 [ffff],(a1,$0008) == $0002504a [0000]
000240e6 336a 0018 000c           move.w (a2,$0018) == $0002485a [ffff],(a1,$000c) == $0002504e [0000]
000240ec 336a 0020 0010           move.w (a2,$0020) == $00024862 [ffff],(a1,$0010) == $00025052 [0000]
000240f2 336a 0028 0014           move.w (a2,$0028) == $0002486a [ffff],(a1,$0014) == $00025056 [0000]
>f 240ca
Breakpoint added.
>fl
0: PC == 000240ca [00000000 00000000]

>
;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button	
>g																				; step 3 - run program
Breakpoint 0 triggered.															; step 4 - press now left mousebutto
Cycles: 2032063 Chip, 4064126 CPU. (V=210 H=13 -> V=105 H=22)					; WinUAE-Debugger output
  D0 FFFFFFFF   D1 0000005A   D2 00000010   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0002181C   A1 00025042   A2 00024842   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 45f9 (LEA) 0002 (OR) Chip latch 00000000
000240ca 45f9 0002 414c           lea.l $0002414c,a2
Next PC: 000240d0
;------------------------------------------------------------------------------
>t
Cycles: 6 Chip, 12 CPU. (V=105 H=22 -> V=105 H=28)
  D0 FFFFFFFF   D1 0000005A   D2 00000010   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0002181C   A1 00025042   A2 0002414C   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 43f9 (LEA) 0002 (OR) Chip latch 00000000
000240d0 43f9 0002 494c           lea.l $0002494c,a1
Next PC: 000240d6
;------------------------------------------------------------------------------
>t
Cycles: 6 Chip, 12 CPU. (V=105 H=28 -> V=105 H=34)
  D0 FFFFFFFF   D1 0000005A   D2 00000010   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0002181C   A1 0002494C   A2 0002414C   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 7003 (MOVE) 3292 (MOVE) Chip latch 00000000
000240d6 7003                     moveq #$03,d0
Next PC: 000240d8
;------------------------------------------------------------------------------
>m 2414c 3
0002414C FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0002415C FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0002416C FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
;------------------------------------------------------------------------------
>m 2494c 3
0002494C 0000 0000 0000 0000 0000 0000 0000 0000  ................
0002495C 0000 0000 0000 0000 0000 0000 0000 0000  ................
0002496C 0000 0000 0000 0000 0000 0000 0000 0000  ................
;------------------------------------------------------------------------------
>fi nop
Cycles: 696 Chip, 1392 CPU. (V=105 H=34 -> V=108 H=49)
  D0 0000FFFF   D1 0000005A   D2 00000010   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0002181C   A1 00024A4C   A2 0002434C   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 33fc (MOVE) Chip latch 00000000
00024140 4e71                     nop
Next PC: 00024142
;------------------------------------------------------------------------------
>m 2494c
0002494C FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................				; 4 word * 16 lines = 64 words (or 128 bytes)
0002495C FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
0002496C FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
0002497C FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
0002498C FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
0002499C FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
000249AC FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
000249BC FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
000249CC FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
000249DC FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
000249EC FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
000249FC FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
00024A0C FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
00024A1C FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
00024A2C FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
00024A3C FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
00024A4C 0000 0000 0000 0000 0000 0000 0000 0000  ................
00024A5C 0000 0000 0000 0000 0000 0000 0000 0000  ................
00024A6C 0000 0000 0000 0000 0000 0000 0000 0000  ................
00024A7C 0000 0000 0000 0000 0000 0000 0000 0000  ................
;------------------------------------------------------------------------------
>fd
All breakpoints removed.
>x

Zusammenfassung:
4+4*(12+(15*20)+12+12)+3*10+14
>?4+4*336+30+14
0x00000570 = %00000000000000000000010101110000 = 1392 = 1392
>