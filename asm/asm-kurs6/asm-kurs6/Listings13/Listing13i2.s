
; Listing13i2.s	; relativ (PC)
; Zeile 1713

start:
	move.w #$4000,$dff09a		; Interrupts disable
	move.w #$7fff,$dff096		; dma disable	for all cycles for cpu
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
	nop
	;bra Test4					; Abkürzung
;-------------------------------;
Test1:	
	;move.l	label1(PC),d0

; Es ist jedoch unmöglich, diese Anweisung relativ zum PC zu machen:

;	move.l	d0,label1

; Wie macht man das? Es ist kein sehr bedeutentes Problem, aber nehmen wir an,
; wir haben in einer Schleife diesen Befehl viele Male ausgeführt.
; Wenn wir das Label nicht relativ zum PC machen können, können wir es relativ 
; zu einem gemeinsamen Adressregister machen!
; Die naheliegendste Methode ist diese:

;	move.x	XXXX,label	->	lea	label(PC),a0
;							move.x  XXXX,(a0)

;	tst.x	label		->	lea	label(PC),a0
;							tst.x	(a0)


	;move.l	d0,label1(PC)		; invalid adressing mode
	;tst.w label1(PC)			; invalid adressing mode

	lea	label1(PC),a0			; - move.x	XXXX,label		8 cy
	move.l  d0,(a0)				; /							12 cy	
	
	lea	label1(PC),a0			; - tst.x  label			8 cy
	tst.w	(a0)				; /							8 cy
	nop							; sum=36 cy	
	;bra exit
;-------------------------------;
Test2:

; Beachten Sie, dass Sie auch die # unmittelbaren Werte durch Werte, die in
; Datenregister geladen werden ersetzen müssen, solange die Werte zwischen 
; -80 und +7f liegen um das "moveq" zuzulassen:

;	move.l	#xx,dest	->	moveq	#xx,d0
;							move.l	d0,dest

;	ori.l	#xx,dest	->	moveq	#xx,d0
;							or.l	d0,dest

;	addi.l	#xx,dest	->	moveq	#xx,d0
;							add.l	d0,dest


	move.l	#$7f,dest			; 28 cy	 ->
	moveq	#$7f,d0				; 4 cy
	move.l	d0,dest				; 20 cy
	
	ori.l	#$7f,dest			; 36 cy  ->	
	moveq	#$7f,d0				; 4 cy
	or.l	d0,dest				; 28 cy
	
	addi.l	#$7f,dest			; 36 cy ->	
	moveq	#$7f,d0				; 4 cy
	add.l	d0,dest				; 28 cy
	nop							; sum=192 cy	
;-------------------------------;
Test3:
								; cy to the next nop
RoutineSchifosa:				; 4cy + 8cy + 1023 * 186cy + 188cy = 190.478cy
	move.w	#1024-1,d7			; 8 cy Anzahl der Schleifen		
LoopSquallido:	
	add.l	#$567,label2		; 36 cy
	sub.l	#$23,label3			; 36 cy
	move.l	label2(PC),(a0)+	; 24 cy
	move.l	label3(PC),(a0)+	; 24 cy
	add.l	#30,(a0)+			; 28 cy
	sub.l	#20,(a0)+			; 28 cy
	dbra	d7,LoopSquallido	; 10 cy / (1x 12 cy		>fo d7==0	>g)
	;rts
	nop							
;-------------------------------;
; Dies kann so optimiert werden:
								;  cy to the next nop	
RoutineDecente:					
	moveq	#30,d0				; 4 cy	wir laden die notwendigen Register...	
	moveq	#20,d1				; 4 cy
	move.l	#$567,d2			; 12 cy
	moveq	#$23,d3				; 4 cy
	lea	label2(PC),a1			; 8 cy
	lea	label3(PC),a2			; 8 cy
	move.w	#1024-1,d7			; Anzahl der Schleifen  ; 8 cy
LoopNormale:
	add.l	d2,(a1)				; 20 cy
	sub.l	d3,(a2)				; 20 cy
	move.l	(a1),(a0)+			; 20 cy
	move.l	(a2),(a0)+			; 20 cy
	add.l	d0,(a0)+			; 20 cy
	sub.l	d1,(a0)+			; 20 cy
	dbra	d7,LoopNormale		; 10 cy	/ (1x 12 cy		>fo d7==0	>g)
	;rts
	nop	
;-------------------------------;
Test4:
; Um es zu übertreiben, können wir endlich die Anzahl der 
; auszuführenden Dbra sparen:

RoutineOK:						;  cy to the next nop
	moveq	#30,d0				; 4 cy
	moveq	#20,d1				; 4 cy
	move.l	#$567,d2			; 12 cy
	moveq	#$23,d3				; 4 cy
	lea	label2(PC),a1			; 8 cy
	lea	label3(PC),a2			; 8 cy
	move.w	#(1024/8)-1,d7		; 8 cy  Anzahl der Schleifen = 128 
LoopOK:

	rept	8					; Ich wiederhole 8 mal das Stück...

	add.l	d2,(a1)				; 20 cy
	sub.l	d3,(a2)				; 20 cy
	move.l	(a1),(a0)+			; 20 cy
	move.l	(a2),(a0)+			; 20 cy
	add.l	d0,(a0)+			; 20 cy
	sub.l	d1,(a0)+			; 20 cy

	endr

	dbra	d7,LoopOK			; 10 cy	/ (1x 12 cy		>fo d7==0	>g)
	;rts
	nop
;-------------------------------;
exit:
	nop							; an dieser Stelle ist die Aufgabe erledigt
	move.w #$C000,$dff09a		; Interrupts enable
	rts

	;cnop 0,32768
label1:
	dc.l	$12345678			; ** out of Range 16bit
label2:							; lea	label1(PC),a0
	dc.l	$22223333
label3:
	dc.l	$44445555
dest:
	dc.l	$60000

	end

;------------------------------------------------------------------------------
r
Filename: Listing13i2.s
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
000220fc 66f6                     bne.b #$f6 == $000220f4 (T)
000220fe 4e71                     nop
00022100 41fa 012a                lea.l (pc,$012a) == $0002222c,a0
00022104 2080                     move.l d0,(a0) [00000000]
00022106 41fa 0124                lea.l (pc,$0124) == $0002222c,a0
0002210a 4a50                     tst.w (a0) [0000]
0002210c 4e71                     nop
0002210e 23fc 0000 007f 0002 2238 move.l #$0000007f,$00022238 [00060000]
00022118 707f                     moveq #$7f,d0
0002211a 23c0 0002 2238           move.l d0,$00022238 [00060000]
>f 22100
Breakpoint added.
>

;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 7460370 Chip, 14920740 CPU. (V=210 H=6 -> V=210 H=21)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 41fa (LEA) 012a (BTST) Chip latch 0000012A
00022100 41fa 012a                lea.l (pc,$012a) == $0002222c,a0
Next PC: 00022104
;------------------------------------------------------------------------------
>fi nop													
Cycles: 18 Chip, 36 CPU. (V=210 H=21 -> V=210 H=39)								; Test 1 sum=36 cy	
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0002222C   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 23fc (MOVE) Chip latch 000023FC
0002210c 4e71                     nop
Next PC: 0002210e
;------------------------------------------------------------------------------
>fi nop
Cycles: 96 Chip, 192 CPU. (V=210 H=39 -> V=210 H=135)							; Test 2 sum=192 cy
  D0 0000007F   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0002222C   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 3e3c (MOVE) Chip latch 00000000
00022144 4e71                     nop
Next PC: 00022146
;------------------------------------------------------------------------------
>fi nop
Cycles: 95535 Chip, 191070 CPU. (V=210 H=135 -> V=5 H=103)						; Test 3 sum=4cy + 8cy + 1023 * 186cy + 188cy = 190.478cy
  D0 0000007F   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0002622C   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 4e71 (NOP) 701e (MOVE) Chip latch 0000701E
00022176 4e71                     nop
Next PC: 00022178
;------------------------------------------------------------------------------
>fi nop
Cycles: 66731 Chip, 133462 CPU. (V=5 H=103 -> V=299 H=96)
  D0 0000001E   D1 00000014   D2 00000567   D3 00000023
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0002A22C   A1 00022230   A2 00022234   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 4e71 (NOP) 701e (MOVE) Chip latch 0000701E
000221a0 4e71                     nop
Next PC: 000221a2
;------------------------------------------------------------------------------
>fi nop
Cycles: 62279 Chip, 124558 CPU. (V=299 H=96 -> V=260 H=177)
  D0 0000001E   D1 00000014   D2 00000567   D3 00000023
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0002E22C   A1 00022230   A2 00022234   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 4e71 (NOP) 4e71 (NOP) Chip latch 00004E71
0002221e 4e71                     nop
Next PC: 00022220
>d pc
0002221e 4e71                     nop
00022220 4e71                     nop
00022222 33fc c000 00df f09a      move.w #$c000,$00dff09a
0002222a 4e75                     rts  == $00c4f6d8

>fd
All breakpoints removed.
>x
