
; Listing13g2.s - Routine aufrufen (Fallunterscheidung)
; Zeile 1230

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
	lea Table,a0				; only for debugging

	moveq #9,d0					; welche Routine aufrufen?
	bra test4					; Abkürzung
	

test:							; d0=0 --> Routine 1, d0=1 --> Routine 2,...
	cmp.b	#0,d0
	beq.w	Rout1
	cmpi.b	#1,d0
	beq.w	Rout2
	cmp.b	#2,d0
	beq.w	Rout3
	cmpi.b	#3,d0
	beq.w	Rout4
	cmp.b	#4,d0
	beq.w	Rout5
	cmpi.b	#5,d0
	beq.w	Rout6
	cmp.b	#6,d0
	beq.w	Rout7
	cmpi.b	#7,d0
	beq.w	Rout8
	cmp.b	#8,d0
	beq.w	Rout9
	cmp.b	#9,d0
	beq.w	Rout10
	nop
;-------------------------------;
test2:							; d0=1 --> Routine 1, d0=2 --> Routine 2,...
	subq.b	#1,d0				; wir entfernen 1. Wenn d0 = 0 ist, wird das Z-Flag gesetzt
	beq.w	Rout1				; Folglich war d0 1 und wir springen zu Rout1
	subq.b	#1,d0				; etc.
	beq.w	Rout2
	subq.b	#1,d0
	beq.w	Rout3
	subq.b	#1,d0
	beq.w	Rout4
	subq.b	#1,d0
	beq.w	Rout5
	subq.b	#1,d0
	beq.w	Rout6
	subq.b	#1,d0
	beq.w	Rout7
	subq.b	#1,d0
	beq.w	Rout8
	subq.b	#1,d0
	beq.w	Rout9
	subq.b	#1,d0
	beq.w	Rout10
;-------------------------------;
test3:							; d0=0 --> Routine 1, d0=1 --> Routine 2,...
	;Add.w	d0,d0		  ;\ d0*4, um den Versatz in der Tabelle zu finden,
	;Add.w	d0,d0		  ;/       bestehend aus Langwörtern (4 bytes!)
	lsl.w	#2,d0																; 10 cy
	Move.l	Table(pc,d0.w),a0	; in a0 die Adresse der richtigen Routine		; 18 cy
	Jmp	(a0)																	; 8 cy

;-------------------------------;
test4:
	move.b	Table2(pc,d0.w),d0	; den richtigen Versatz von der Tabelle holen	; 10 cy
	jmp	Table2(pc,d0)			; füge es der Tabelle hinzu und springe!		; 14 cy

;-------------------------------;
test5:
	add.w	d0,d0				; d0*2											; 4 cy
	move.w	Table3(pc,d0.w),d0	; den richtigen Versatz von der Tabelle holen	; 14 cy
	jmp	Table3(pc,d0)			; füge es der Tabelle hinzu und springe!		; 14 cy

;-------------------------------;
test6:
	add.w	d0,d0				; d0*2											; 4 cy
	lea	Table3(pc),a0															; 8 cy	
	move.w	(a0,d0.w),d0														; 14 cy
	jmp	(a0,d0.w)																; 14 cy

;-------------------------------;	
exit:
	nop							; an dieser Stelle ist die Aufgabe erledigt
	move.w #$C000,$dff09a		; Interrupts enable
	rts

Table:
	dc.l	Rout1	; 0 (Wert in d0, um die Routine aufzurufen)
	dc.l	Rout2	; 1
	dc.l	Rout3	; 2
	dc.l	Rout4	; 3
	dc.l	Rout5	; 4
	dc.l	Rout6	; 5
	dc.l	Rout7	; 6
	dc.l	Rout8	; 7
	dc.l	Rout9	; 8
	dc.l	Rout10	; 9
	
Table2:	
	dc.b	Rout1-Table2	; 0
	dc.b	Rout2-Table2	; 1
	dc.b	Rout3-Table2	; 2	
	dc.b	Rout4-Table2	; 3
	dc.b	Rout5-Table2	; 4
	dc.b	Rout6-Table2	; 5
	dc.b	Rout7-Table2	; 6
	dc.b	Rout8-Table2	; 7
	dc.b	Rout9-Table2	; 8
	dc.b	Rout10-Table2	; 9
	even

Table3:	
	dc.w	Rout1-Table3	; 0
	dc.w	Rout2-Table3	; 1
	dc.w	Rout3-Table3	; 2
	dc.w	Rout4-Table3	; 3
	dc.w	Rout5-Table3	; 4
	dc.w	Rout6-Table3	; 5
	dc.w	Rout7-Table3	; 6
	dc.w	Rout8-Table3	; 7
	dc.w	Rout9-Table3	; 8
	dc.w	Rout10-Table3	; 9


;-------------------------------; die Untterroutinen

Rout1:
	nop
	bra exit		

Rout2:
	nop
	bra exit
		
Rout3:
	nop
	bra exit

Rout4:
	nop
	bra exit

Rout5:
	nop
	bra exit

Rout6:
	nop
	bra exit
		
Rout7:
	nop
	bra exit

Rout8:
	nop
	bra exit

Rout9:
	nop
	bra exit

Rout10:
	nop
	bra exit

	end

;------------------------------------------------------------------------------
r
Filename: Listing13g2.s
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
0002276c 66f6                     bne.b #$f6 == $00022764 (T)
0002276e 41f9 0002 283c           lea.l $0002283c,a0							; Table
00022774 7009                     moveq #$09,d0
00022776 6000 0098                bra.w #$0098 == $00022810 (T)
0002277a 0c00 0000                cmp.b #$00,d0
0002277e 6700 0102                beq.w #$0102 == $00022882 (F)
00022782 0c00 0001                cmp.b #$01,d0
00022786 6700 0100                beq.w #$0100 == $00022888 (F)
0002278a 0c00 0002                cmp.b #$02,d0
0002278e 6700 00fe                beq.w #$00fe == $0002288e (F)
>f 22774
Breakpoint added.
>g
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 634893 Chip, 1269786 CPU. (V=105 H=6 -> V=105 H=30)
  D0 00000054   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0002283C   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 7009 (MOVE) 6000 (Bcc) Chip latch 00006000
00022774 7009                     moveq #$09,d0
Next PC: 00022776
;------------------------------------------------------------------------------
>t
Cycles: 2 Chip, 4 CPU. (V=105 H=30 -> V=105 H=32)
  D0 00000009   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0002283C   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 6000 (Bcc) 0098 (OR) Chip latch 00000098
00022776 6000 0098                bra.w #$0098 == $00022810 (T)
Next PC: 0002277a
;------------------------------------------------------------------------------
>t
Cycles: 5 Chip, 10 CPU. (V=105 H=32 -> V=105 H=37)
  D0 00000009   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0002283C   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 103b (MOVE) 0052 (OR) Chip latch 00000052
00022810 103b 0052                move.b (pc,d0.W,$52=$00022864) == $0002286d [54],d0
Next PC: 00022814
;------------------------------------------------------------------------------
>t
Cycles: 7 Chip, 14 CPU. (V=105 H=37 -> V=105 H=44)
  D0 00000054   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0002283C   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4efb (JMP) 004e (ILLEGAL) Chip latch 0000004E
00022814 4efb 004e                jmp (pc,d0.W,$4e=$00022864) == $000228b8		; $228b8
Next PC: 00022818
;------------------------------------------------------------------------------
>t
Cycles: 7 Chip, 14 CPU. (V=105 H=44 -> V=105 H=51)
  D0 00000054   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0002283C   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 6000 (Bcc) Chip latch 00006000
000228b8 4e71                     nop											; $228b8
Next PC: 000228ba
;------------------------------------------------------------------------------
>d 2283c
0002283c 0002 2882                or.b #$82,d2									; Rout1
00022840 0002 2888                or.b #$88,d2
00022844 0002 288e                or.b #$8e,d2
00022848 0002 2894                or.b #$94,d2
0002284c 0002 289a                or.b #$9a,d2
00022850 0002 28a0                or.b #$a0,d2
00022854 0002 28a6                or.b #$a6,d2
00022858 0002 28ac                or.b #$ac,d2
0002285c 0002 28b2                or.b #$b2,d2
00022860 0002 28b8                or.b #$b8,d2									; Rout10 = $228b8
>fd
All breakpoints removed.
>

;------------------------------------------------------------------------------

Betrachten wir den Fall, in dem wir für jeden Wert in d0 eine bestimmte Routine
ausführen müssen und außerdem nehmen wir an, dass diese möglichen Werte 
zwischen 0 und 10 sind. Nun, wir könnten versucht sein, so etwas zu tun:

	Cmp.b	#1,d0
	Beq.s	Rout1
	Cmpi.b	#2,d0
	Beq.s	Rout2
	...
	Cmp.b	#10,d0
	Beq.s	Rout10

Es ist eine sehr schlechte Idee, zumindest hätten wir das tun können:

	Subq.b	#1,d0	; wir entfernen 1. Wenn d0 = 0 ist, wird das Z-Flag gesetzt
	Beq.s	Rout1	; Folglich war d0 1 und wir springen zu Rout1
	Subq.b	#1,d0	; etc.
	Beq.s	Rout2
	...
	Subq.b	#1,d0
	Beq.s	Rout10

Tatsächlich ist das schon besser, aber wir sind Perfektionisten und mit Hilfe
einer Tabelle machen wir das:

	;Add.w	d0,d0		  ;\ d0*4, um den Versatz in der Tabelle zu finden,
	;Add.w	d0,d0		  ;/       bestehend aus Langwörtern (4 bytes!)
	lsl.w	#2,d0	
	Move.l	Table(pc,d0.w),a0 ; in a0 die Adresse der richtigen Routine
	Jmp	(a0)

Table:
	dc.l	Rout1	; 0 (Wert in d0, um die Routine aufzurufen)
	dc.l	Rout2	; 1
	dc.l	Rout3	; 2
	dc.l	Rout4	; 3
	dc.l	Rout5	; 4
	dc.l	Rout6	; 5
	dc.l	Rout7	; 6
	dc.l	Rout8	; 7
	dc.l	Rout9	; 8
	dc.l	Rout10	; 9

Auf diese Weise vergleichen wir nicht und es ist offensichtlich, dass es eine
sehr gute Technik ist, wenn wir die zu vergleichenden Werte kennen und sie
aufeinanderfolgend sind.
Ich möchte auch darauf hinweisen, dass wenn wir Tabellen intensiv nutzen,
könnten wir sogar mit der Potenz von zwei arbeiten und uns so selbst
diese beiden Add.w sparen. Wenn Sie also Routine 1 wollen, brauchen Sie d0=0,
wenn Sie Rout2 möchten d0=4, wenn Sie Rout3 möchten d0=8 und so weiter.

Es gibt zum Beispiel auch Variationen dieses Systems:

	move.b	Table(pc,d0.w),d0	; den richtigen Versatz von der Tabelle holen
	jmp	Table(pc,d0)			; füge es der Tabelle hinzu und springe!

Table:	
	dc.b	Rout1-Table	; 0
	dc.b	Rout2-Table	; 1
	dc.b	Rout3-Table	; 2
	...
	even

Mit diesem System müssen wir d0 nicht multiplizieren, weil wir eine
Offsettabelle der Routinen von der Tabelle selbst gemacht haben. Hier sind es
.byte-Offsets, weil die Routinen als klein angenommen werden und Nachbarn sind.
Andernfalls können die Offsets .words sein:

	add.w	d0,d0				; d0*2
	move.w	Table(pc,d0.w),d0	; den richtigen Versatz von der Tabelle holen
	jmp	Table(pc,d0)			; füge es der Tabelle hinzu und springe!

Table:	
	dc.w	Rout1-Table	; 0
	dc.w	Rout2-Table	; 1
	dc.w	Rout3-Table	; 2
	...

Der Vorteil dieses Systems ist, dass es nicht notwendig ist, Register d0 mit 4
zu multiplizieren, aber nur für 2.
Wenn Sie die Tabelle nicht nahe genug bringen können, können Sie dies tun:

	add.w	d0,d0				; d0*2
	lea	Table(pc),a0
	move.w	(a0,d0.w),d0
	jmp	(a0,d0.w)

Table:	
	dc.w	Rout1-Table	; 0
	dc.w	Rout2-Table	; 1
	dc.w	Rout3-Table	; 2
	...




