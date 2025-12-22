
;=========================================================================
;
;		TurboCopyMem 3.13
;
;		- sehr schnelle Kopierroutine
;		- für gerade Adressen und Länge
;		- unterstützt überlappendes Kopieren
;		- alle Registerinhalte bleiben erhalten
;		- minimaler Overhead
;		- Länge NULL ist zulässig
;		- kopiert maximal 16MB
;
;		v3.0	- unterstützt überlappendes Kopieren
;		v3.1	- Overhead drastisch optimiert
;		v3.12	- Overhead nochmal minimal verkleinert
;		v3.13	- unterstützt jetzt auch ungerade Längen und Adressen.
;
;	>	a0	Startadresse [gerade]
;		a1	Zieladresse [gerade]
;		d0.l	Länge [Bytes, gerade]

		cnop	0,4

tcm_bytecopy	cmp.l	a1,a0
		blt.b	.rueck

.vorlop		move.b	(a0)+,(a1)+
		subq.l	#1,d0
		bne.b	.vorlop
		bra.b	.raus

.rueck		add.l	d0,a0
		add.l	d0,a1
.ruecklop	move.b	-(a0),-(a1)
		subq.l	#1,d0
		bne.b	.ruecklop

.raus		movem.l	(a7)+,a0/a1/d0/d2
		rts


		cnop	0,4

TurboCopyMem:	movem.l	a0/a1/d0/d2,-(a7)

		btst	#0,d0
		bne.b	tcm_bytecopy
		move.l	a0,d2
		btst	#0,d2
		bne.b	tcm_bytecopy
		move.l	a1,d2
		btst	#0,d2
		bne.b	tcm_bytecopy
		
		move.l	d0,d2

		cmp.l	a1,a0
		blt.s	tcm_rueck

		clr.b	d0
		tst.l	d0
		beq.s	tcm_vorw_small

		sub.l	d0,d2
		swap	d2
		lsr.l	#8,d0
		subq.w	#1,d0
		move.w	d0,d2

		movem.l	d1/d3-d7/a2-a6,-(a7)
		moveq	#44,d1
tcm_vorw256	movem.l	(a0)+,d0/d3-d7/a2-a6		; 44 Bytes
		movem.l	d0/d3-d7/a2-a6,(a1)
		add.l	d1,a1
		movem.l	(a0)+,d0/d3-d7/a2-a6		; 44 Bytes
		movem.l	d0/d3-d7/a2-a6,(a1)
		add.l	d1,a1
		movem.l	(a0)+,d0/d3-d7/a2-a6		; 44 Bytes
		movem.l	d0/d3-d7/a2-a6,(a1)
		add.l	d1,a1
		movem.l	(a0)+,d0/d3-d7/a2-a6		; 44 Bytes
		movem.l	d0/d3-d7/a2-a6,(a1)
		add.l	d1,a1
		movem.l	(a0)+,d3-d7/a2-a6		; 40 Bytes
		movem.l	d3-d7/a2-a6,(a1)
		moveq	#40,d0
		add.l	d0,a1
		movem.l	(a0)+,d3-d7/a2-a6		; 40 Bytes
		movem.l	d3-d7/a2-a6,(a1)
		add.l	d0,a1
		dbf	d2,tcm_vorw256
		movem.l	(a7)+,d1/d3-d7/a2-a6

		swap	d2

tcm_vorw_small	lsr.w	#1,d2
		subq.w	#1,d2
		bmi.s	tcm_nosmall

tcm_vorw_smlop	move.w	(a0)+,(a1)+
		dbf	d2,tcm_vorw_smlop

tcm_nosmall	movem.l	(a7)+,a0/a1/d0/d2
tcm_end		rts


tcm_rueck	add.l	d0,a0
		add.l	d0,a1

		clr.b	d0
		tst.l	d0
		beq.s	tcm_rueck_small

		sub.l	d0,d2
		swap	d2
		lsr.l	#8,d0
		subq.w	#1,d0
		move.w	d0,d2

		movem.l	d1/d3-d7/a2-a6,-(a7)
		moveq	#44,d1
tcm_rueck256	sub.l	d1,a0
		movem.l	(a0),d0/d3-d7/a2-a6		; 44 Bytes
		movem.l	d0/d3-d7/a2-a6,-(a1)
		sub.l	d1,a0
		movem.l	(a0),d0/d3-d7/a2-a6		; 44 Bytes
		movem.l	d0/d3-d7/a2-a6,-(a1)
		sub.l	d1,a0
		movem.l	(a0),d0/d3-d7/a2-a6		; 44 Bytes
		movem.l	d0/d3-d7/a2-a6,-(a1)
		sub.l	d1,a0
		movem.l	(a0),d0/d3-d7/a2-a6		; 44 Bytes
		movem.l	d0/d3-d7/a2-a6,-(a1)
		moveq	#40,d0
		sub.l	d0,a0
		movem.l	(a0),d3-d7/a2-a6		; 40 Bytes
		movem.l	d3-d7/a2-a6,-(a1)
		sub.l	d0,a0
		movem.l	(a0),d3-d7/a2-a6		; 40 Bytes
		movem.l	d3-d7/a2-a6,-(a1)
		dbf	d2,tcm_rueck256
		movem.l	(a7)+,d1/d3-d7/a2-a6

		swap	d2

tcm_rueck_small	lsr.w	#1,d2
		subq.w	#1,d2
		bmi.s	tcm_rueck_nosml
tcm_rueck_smlop	move.w	-(a0),-(a1)
		dbf	d2,tcm_rueck_smlop

tcm_rueck_nosml	movem.l	(a7)+,a0/a1/d0/d2
		rts

;=========================================================================
