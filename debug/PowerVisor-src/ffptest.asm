		exeobj
		objfile	ffptest
		mc68881
		debug
		addsym

		move.b	#$11,d0
		move.w	#$2222,d1
		move.l	#$33333333,d2
		fmove.b	#11,fp0
		fmove.w	#2222,fp1
		fmove.l	#33333333,fp2
		fmove.s	#1.5,fp3
		fmove.d	#1.5,fp4
		fmove.x	#1.5,fp5
		fmove.p	#15,fp6

		fmove.x	#7.777777,fp7

1$		bra.b		1$
		rts

	end
