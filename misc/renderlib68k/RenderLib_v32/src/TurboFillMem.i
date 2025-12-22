
;=========================================================================
;
;		TurboFillMem 1.1
;		1992/1995, Timm S. Müller
;
;		- sehr schnelle Füllroutine
;		- beliebiges Füllbyte
;		- Startadresse muß nicht geradzahlig sein
;		- Länge muß nicht geradzahlig sein
;		- alle Registerinhalte bleiben erhalten
;		- geringer Overhead
;		- Länge NULL ist zulässig
;		- füllt maximal 16MB
;
;	>	a0	Startadresse
;		d0.l	Länge [Bytes]
;		d1.b	Füllbyte


		cnop	0,4

TurboFillMem:	tst.l	d0
		beq.s	tfm_l7

		movem.l	a0/d0-d3,-(a7)

		add.l	d0,a0
		move.l	a0,d2
		btst	#0,d2
		beq.s	tfm_l5

		move.b	d1,-(a0)
		subq.l	#1,d0

tfm_l5		move.l	d0,d2
		lsr.l	#8,d2
		tst.w	d2
		beq.s	tfm_l1
		move.l	d2,d3
		lsl.l	#8,d3
		sub.l	d3,d0
		movem.l	a1-a6/d0/d3-d7,-(a7)
		and.w	#$ff,d1
		move.w	d1,d3
		lsl.w	#8,d3
		or.w	d3,d1			
		move.w	d1,d3
		swap	d3
		move.w	d1,d3
		move.l	d3,d0
		move.l	d3,d1
		move.l	d3,d4
		move.l	d3,d5
		move.l	d3,d6
		move.l	d3,d7
		move.l	d3,a1
		move.l	d3,a2
		move.l	d3,a3
		move.l	d3,a4		
		move.l	d3,a5
		move.l	d3,a6
		subq.w	#1,d2		
tfm_l3		movem.l	d0/d1/d3-d7/a1-a6,-(a0)
		movem.l	d0/d1/d3-d7/a1-a6,-(a0)
		movem.l	d0/d1/d3-d7/a1-a6,-(a0)
		movem.l	d0/d1/d3-d7/a1-a6,-(a0)
		movem.l	d0/d1/d3-d7/a1-a5,-(a0)
		dbf	d2,tfm_l3
		movem.l	(a7)+,a1-a6/d0/d3-d7

tfm_l1		tst.w	d0
		beq.s	tfm_l4

		subq.w	#1,d0
tfm_l2		move.b	d1,-(a0)
		dbf	d0,tfm_l2

tfm_l4		movem.l	(a7)+,a0/d0-d3

tfm_l7		rts
