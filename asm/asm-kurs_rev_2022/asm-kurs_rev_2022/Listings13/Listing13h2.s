
; Listing13h2.s	Datenbereich kopieren (Variante mit rept und Variable)
; Zeile 1626
; 364 Bytes kopieren	
; 7 copies of 13 registers with 2 words 7*13*2 words = 182 words (364 bytes)
; 1654 Zyklen (unwesentlich schlechter, dafür Codezeilen gespart)

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;

	Lea	Source,a0				; Quelle									; 12 Zyklen
	Lea	Dest,a1					; Ziel										; 12 Zyklen
FASTCOPY:								; Ich benutze 13 Register
.pos    set     $0000	
	rept	7							; wiederholen7 movem...
	movem.l	(a0)+,d0-d7/a2-a6			; Daten lesen						; 116 Zyklen
	movem.l	d0-d7/a2-a6,$34*.pos(a1)	; Daten schreiben					; 112 Zyklen
.pos    set     .pos+1
	endr

;-------------------------------;		
	nop							; an dieser Stelle ist die Aufgabe erledigt	; 4 Zyklen
	move.w #$C000,$dff09a		; Interrupts enable							; 20 Zyklen	
	rts

Source:
	blk.w 1024,$FFFF			; the dates could also have been different!
		
Dest:
	blk.w 1024,$0000
	end


;------------------------------------------------------------------------------
r
Filename: Listing13h2.s
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
000226c8 66f6                     bne.b #$f6 == $000226c0 (T)
000226ca 41f9 0002 2728           lea.l $00022728,a0
000226d0 43f9 0002 2f28           lea.l $00022f28,a1
000226d6 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
000226da 48e9 7cff 0000           movem.l d0-d7/a2-a6,(a1,$0000) == $00023222
000226e0 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
000226e4 48e9 7cff 0034           movem.l d0-d7/a2-a6,(a1,$0034) == $00023256
000226ea 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
000226ee 48e9 7cff 0068           movem.l d0-d7/a2-a6,(a1,$0068) == $0002328a
000226f4 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
>d
000226f8 48e9 7cff 009c           movem.l d0-d7/a2-a6,(a1,$009c) == $000232be
000226fe 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
00022702 48e9 7cff 00d0           movem.l d0-d7/a2-a6,(a1,$00d0) == $000232f2
00022708 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
0002270c 48e9 7cff 0104           movem.l d0-d7/a2-a6,(a1,$0104) == $00023326
00022712 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
00022716 48e9 7cff 0138           movem.l d0-d7/a2-a6,(a1,$0138) == $0002335a
0002271c 4e71                     nop
0002271e 33fc c000 00df f09a      move.w #$c000,$00dff09a
00022726 4e75                     rts  == $00c4f6d8
>f 226ca
Breakpoint added.
>fl
0: PC == 000226ca [00000000 00000000]

>

;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 1407274 Chip, 2814548 CPU. (V=105 H=0 -> V=105 H=24)
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022B8E   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 41f9 (LEA) 0002 (OR) Chip latch 00000002
000226ca 41f9 0002 2728           lea.l $00022728,a0
Next PC: 000226d0
;------------------------------------------------------------------------------
>fi nop
Cycles: 827 Chip, 1654 CPU. (V=105 H=24 -> V=108 H=170)
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022894   A1 00022F28   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 33fc (MOVE) Chip latch 000033FC
0002271c 4e71                     nop
Next PC: 0002271e
;------------------------------------------------------------------------------
>m ra1
00022F28 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022F38 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022F48 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022F58 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022F68 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022F78 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022F88 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022F98 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022FA8 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022FB8 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022FC8 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022FD8 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022FE8 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022FF8 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023008 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023018 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023028 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023038 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023048 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023058 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
>m
00023068 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023078 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023088 FFFF FFFF FFFF FFFF FFFF FFFF 0000 0000  ................
00023098 0000 0000 0000 0000 0000 0000 0000 0000  ................
>fd
All breakpoints removed.
>
