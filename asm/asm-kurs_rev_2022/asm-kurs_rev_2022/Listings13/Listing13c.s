
; Listing13c.s - Einfluss der Adressierungsart 
; Zeile 645
; verschiedene moves
; https://68kcounter-web.vercel.app/

 start:
	move.w #$4000,$dff09a		; Interrupts disable
	move.w #$7fff,$dff096		; dma disable
	;move.w #$0200,$dff096		; or
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
	;bra adr_mode3				

; Kombinationen erste Reihe
adr_mode:
	move.w	d0,d1				; Dn,Dn					; move.w d0,d1									; 4 cy
	move.w	d0,a1				; Dn,An					; movea.w d0,a1									; 4 cy
	move.w	d0,(a1)				; Dn,(An)				; move.w d0,(a1) [0000]							; 8 cy
	move.w	d0,(a1)+			; Dn,(An)+				; move.w d0,(a1)+ [0000]						; 8 cy
	move.w	d0,-(a1)			; Dn,-(An)				; move.w d0,-(a1) [001f]						; 8 cy
	move.w	d0,$1234(a1)		; Dn,(d16,An)			; move.w d0,(a1,$1234) == $00001234 [0000]		; 12 cy
	move.w	d0,$12(a1,d1)		; Dn,(d8,An,Xn)			; move.w d0,(a1,d1.W,$12) == $00000012 [081c]	; 14 cy
	move.w	d0,$1234.w			; Dn,(xxx.W)			; move.w d0,$1234 [0000]						; 12 cy 
	move.w	d0,$1234.l			; Dn,(xxx.L)			; move.w d0,$00001234 [0000]					; 16 cy
               
;-------------------------------; 
; Kombinationen erste Spalte
adr_mode2:	
	move.w	a0,d1				; An,Dn					; move.w a0,d1																						; 4 cy
	move.w	(a1),d1				; (An),Dn				; move.w (a1) [0000],d1																				; 8 cy
	move.w	(a1)+,d1			; (An)+,Dn				; move.w (a1)+ [0000],d1																			; 8 cy
	move.w	-(a1),d1			; -(An),Dn				; move.w -(a1) [001f],d1																			; 10 cy
	move.w	$1234(a1),d0		; (d16,An),Dn			; move.w (a1,$1234) == $00001234 [0000],d0															; 12 cy
	move.w	(a0,d0.w),d0		; (d8,An,Xn)*,Dn		; move.w (a0,d0.W,$00) == $00000000 [0000],d0														; 14 cy
	move.w	$1234.w,d0			; (xxx).W,Dn			; move.w $1234 [0000],d0																			; 12 cy
	move.w	$1234.l,d0			; (xxx).L,Dn			; move.w $00001234 [0000],d0																		; 16 cy
	move.w	label(pc),d0		; (d16,PC),Dn			; move.w (pc,$0034) == $000227fe [0000],d0															; 12 cy 
	move.w	label(pc,d2.l),d0	; (d8,PC,Xn)*,Dn		; move.w (pc,d2.L,$30=$000227fe) == $000227fe [0000],d0												; 14 cy
	move.w	#15,d0				; #(data),Dn			; move.w #$000f,d0																					; 8 cy		

;-------------------------------;	
; gemischte Gruppe
adr_mode3:	
	move.w	$1234(a1),(a0)					; (d16,An),(An)				; move.w (a1,$1234) == $00001234 [0000],(a0) [0000]									; 16 cy
	move.w	$12(a1,a2.w),(a0)				; (d8,An,Xn),(An)			; move.w (a1,a2.W,$12) == $00000012 [081c],(a0) [0000]								; 18 cy
	move.w	$1234.w,(a0)+					; (xxx).W,(An)				; move.w $1234 [0000],(a0)+ [0000]													; 16 cy
	move.w	label(pc),-(a0)					; (d16,PC),-(An)			; move.w (pc,$001c) == $00021840 [0000],-(a0) [001f]								; 16 cy
	move.w	label(pc,d2.l),$1234(a1)		; (d8,PC,Xn)*,(d16,An)		; move.w (pc,d2.L,$18=$00021840) == $00021840 [0000],(a1,$1234) == $00001234 [0000]	; 22 cy
	move.w	$12(a1,a2.w),$12(a1,d2.w)		; (d8,An,Xn),(d8,An,Xn)		; move.w (a1,a2.W,$12) == $00000012 [081c],(a1,d2.W,$12) == $00000012 [081c]		; 24 cy
	move.w	d1,	$12(a1,a2.w)				; Dn,(d8,An,Xn)				; move.w d1,(a1,a2.W,$12) == $00000012 [081c]										; 14 cy
	move.w	(a1)+,$12(a1,a2.l)				; (An)+,(d8,An,Xn)			; move.w (a1)+ [0000],(a1,a2.L,$12) == $00000012 [081c]								; 18 cy
	move.w	-(a1),$1234.w					; -(An),(xxx).W				; move.w -(a1) [001f],$1234 [0000]													; 18 cy
		
;-------------------------------;	
	nop							; an dieser Stelle ist die Aufgabe erledigt
	move.w #$C000,$dff09a		; Interrupts enable	        
	rts

label:
	dc.w $0000, $0001, $0002, $0003, $0004, $0005, $0006, $0007

	end


Without this instruction move.w #$7fff,$dff096		; dma disable
you get sometimes higher results for cycle usage because rasterslots are
stolen from dma channels. Also if all dma channels are deactived the refresh-
slot on beginning of the rasterline stays every time activ. (DRAM)
Try out. (I was first confused.)


>>>				MOVE.B und MOVE.W				   <<<

+-------------+---------------------------------------------------------------+
|             |                           ZIEL		                          |
+   QUELLE    +---------------------------------------------------------------+
|             | Dn | An |(An)|(An)+|-(An)|(d16,An)|(d8,An,Xn)*|(xxx.W)|(xxx).L|
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
| Dn / An     | 4  | 4  | 8  |  8  |  8  |   12   |    14     |  12   |  16   |
| (An)        | 8  | 8  | 12 | 12  | 12  |   16   |    18     |  16   |  20   |
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
| (An)+       | 8  | 8  | 12 | 12  | 12  |   16   |    18     |  16   |  20   |
| -(An)       | 10 | 10 | 14 | 14  | 14  |   18   |    20     |  18   |  22   |
| (d16,An)    | 12 | 12 | 16 | 16  | 16  |   20   |    22     |  20   |  24   |
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
| (d8,An,Xn)* | 14 | 14 | 18 | 18  | 18  |   22   |    24     |  22   |  26   |
| (xxx).W     | 12 | 12 | 16 | 16  | 16  |   20   |    22     |  20   |  24   |
| (xxx).L     | 16 | 16 | 20 | 20  | 20  |   24   |    26     |  24   |  28   |
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
| (d16,PC)    | 12 | 12 | 16 | 16  | 16  |   20   |    22     |  20   |  24   |
| (d8,PC,Xn)* | 14 | 14 | 18 | 18  | 18  |   22   |    24     |  22   |  26   |
| #(data)     | 8  | 8  | 12 | 12  | 12  |   16   |    18     |  16   |  20   |
+-------------+----+----+----+-----+-----+--------+-----------+-------+-------+
* Die Größe des Indexregisters (Xn) (.w oder .l) ändert nichts an der
 Geschwindigkeit.

;------------------------------------------------------------------------------
r
Filename: Listing13c.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60D80
USP  00C60D80 ISP  00C61D80
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 3200 (MOVE) Chip latch 00000000
0002b3d4 66f6                     bne.b #$f6 == $0002b3cc (T)
Next PC: 0002b3d6
>d pc
0002b3d4 66f6                     bne.b #$f6 == $0002b3cc (T)
0002b3d6 3200                     move.w d0,d1
0002b3d8 3240                     movea.w d0,a1
0002b3da 3280                     move.w d0,(a1) [0000]
0002b3dc 32c0                     move.w d0,(a1)+ [0000]
0002b3de 3300                     move.w d0,-(a1) [001f]
0002b3e0 3340 1234                move.w d0,(a1,$1234) == $00001234 [0000]
0002b3e4 3380 1012                move.w d0,(a1,d1.W,$12) == $00000012 [081c]
0002b3e8 31c0 1234                move.w d0,$1234 [0000]
0002b3ec 33c0 0000 1234           move.w d0,$00001234 [0000]
>d
0002b3f2 3208                     move.w a0,d1
0002b3f4 3211                     move.w (a1) [0000],d1
0002b3f6 3219                     move.w (a1)+ [0000],d1
0002b3f8 3221                     move.w -(a1) [001f],d1
0002b3fa 3029 1234                move.w (a1,$1234) == $00001234 [0000],d0
0002b3fe 3030 0000                move.w (a0,d0.W,$00) == $00000000 [0000],d0
0002b402 3038 1234                move.w $1234 [0000],d0
0002b406 3039 0000 1234           move.w $00001234 [0000],d0
0002b40c 303a 003e                move.w (pc,$003e) == $0002b44c [0000],d0
0002b410 303b 283a                move.w (pc,d2.L,$3a=$0002b44c) == $0002b44c [0000],d0
>d
0002b414 303c 000f                move.w #$000f,d0
0002b418 30a9 1234                move.w (a1,$1234) == $00001234 [0000],(a0) [0000]
0002b41c 30b1 a012                move.w (a1,a2.W,$12) == $00000012 [081c],(a0) [0000]
0002b420 30f8 1234                move.w $1234 [0000],(a0)+ [0000]
0002b424 313a 0026                move.w (pc,$0026) == $0002b44c [0000],-(a0) [001f]
0002b428 337b 2822 1234           move.w (pc,d2.L,$22=$0002b44c) == $0002b44c [0000],(a1,$1234) == $00001234 [0000]
0002b42e 33b1 a012 2012           move.w (a1,a2.W,$12) == $00000012 [081c],(a1,d2.W,$12) == $00000012 [081c]
0002b434 3381 a012                move.w d1,(a1,a2.W,$12) == $00000012 [081c]
0002b438 3399 a812                move.w (a1)+ [0000],(a1,a2.L,$12) == $00000012 [081c]
0002b43c 31e1 1234                move.w -(a1) [001f],$1234 [0000]
>d
0002b440 4e71                     nop
0002b442 33fc c000 00df f09a      move.w #$c000,$00dff09a
0002b44a 4e75                     rts  == $00c50660
0002b44c 0000 0001                or.b #$01,d0
0002b450 0002 0003                or.b #$03,d2
0002b454 0004 0005                or.b #$05,d4
0002b458 0006 0007                or.b #$07,d6
0002b45c 1234 5678                move.b (a4,d5.W[*8],$78) == $00000078 (68020+) [00],d1
0002b460 0000 0000                or.b #$00,d0
0002b464 0000 0000                or.b #$00,d0
>r
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60D80
USP  00C60D80 ISP  00C61D80
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 3200 (MOVE) Chip latch 00000000
0002b3d4 66f6                     bne.b #$f6 == $0002b3cc (T)
Next PC: 0002b3d6
>f 2b3d6
Breakpoint added.
>
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 5504392 Chip, 11008784 CPU. (V=210 H=8 -> V=105 H=27)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60D80
USP  00C60D80 ISP  00C61D80
T=00 S=0 M=0 X=0 N=1 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 3200 (MOVE) 3240 (MOVEA) Chip latch 00000000
0002b3d6 3200                     move.w d0,d1
Next PC: 0002b3d8
>t														
Cycles: 2 Chip, 4 CPU. (V=105 H=27 -> V=105 H=29)		; 4 CPU = 4 cy
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60D80
USP  00C60D80 ISP  00C61D80
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 3240 (MOVEA) 3280 (MOVE) Chip latch 00000000
0002b3d8 3240                     movea.w d0,a1
Next PC: 0002b3da
>t														; now step by step all instructions
Cycles: 2 Chip, 4 CPU. (V=105 H=29 -> V=105 H=31)		; 4 CPU = 4 cy
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60D80
USP  00C60D80 ISP  00C61D80
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 3280 (MOVE) 32c0 (MOVE) Chip latch 00000000
0002b3da 3280                     move.w d0,(a1) [0000]
Next PC: 0002b3dc
>
