	;This is the second example file for debugging.

   addsym

StartProgram:
		bsr		Long

		moveq		#0,d0
		bsr		recur

		moveq		#0,d0
		rts

Long:
		moveq		#0,d0
		moveq		#1,d1
		moveq		#2,d2
		moveq		#3,d3
		moveq		#4,d4
		moveq		#5,d5
		moveq		#6,d6
		moveq		#7,d7
		rts

recur:
		addq.l	#1,d0
		cmp.l		#200,d0
		bgt.s		theend
		bsr		recur
theend:
		rts

      END
