
Again:
		movem.l	d0-d7/a0-a6,-(a7)
		moveq		#20,d1
2$		move.l	#30000,d0
1$		nop
		dbra		d0,1$
		dbra		d1,2$
		bsr		Again

	END
