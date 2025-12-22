		exeobj
		objfile	test2
		debug
		addsym

Start:
		moveq		#0,d0
		moveq		#5,d2

Again:
		move.l	d0,d1
		move.l	d1,d3
		bsr		TestOddAddress
		move.l	d3,d4
		move.l	d4,d5
		move.l	d5,d6
		move.l	d6,d7
		bra.b		Loop1

Loop2:
		move.l	#1000,d1
Loop3:
		subq.l	#3,d3
		addq.l	#4,d4
		subq.l	#5,d5
		addq.l	#6,d6
		subq.l	#7,d7
		dbra		d1,Loop3
		bra.b		Again

Loop1:
		addq.l	#1,d0
		cmp.l		#50000,d0
		beq.b		TheEnd
		bra.b		Loop2

TheEnd:
		rts

TestOddAddress:
		move.l	d2,-(a7)

		moveq		#10,d2
		lea		(FormatFiles,pc),a0
		lea		(Data,pc),a1
		move.w	(2,a0),(4,a1)
		moveq		#20,d2

		move.l	(a7)+,d2
		rts


Data:
		dc.b		"test1"
		dc.b		"test2"
		dc.b		"#"

	EVEN

		dc.b	65				;To make even

FormatFiles:
		dc.b	"+++"
		dc.b	"+++"
		dc.b	"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

	end
