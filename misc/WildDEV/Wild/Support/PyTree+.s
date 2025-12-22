; PyTree macro: calcs the sqr of a number, using a scalable table.
; WARNING: NEGATIVE NUMBERS GIVE ABSURDE RESULTS! NO INTERNAL CHECK!
; Optimization 1. Eliminate cmps, use only a unique sub at start.

PyTree	MACRO	;\1=x \2=Ax pointing to table \3=x^.5(result) \4=skratch
	bra.b	cyc\@
jump\@	move.l	(\2),\3
	ble.b	fnd\@
	lea.l	(\2,\3.l),\2
cyc\@	move.l	(\2)+,\4
	sub.l	\1,\4
	beq.b	exact\@
	blt.b	jump\@
	tst.l	(\2)
	bmi.b	fnd\@
	addq.l	#8,\2
	bra.b	cyc\@
exact\@	move.l	4(\2),\3
	bra.b	had\@
fnd\@	addq.l	#4,\2
	move.l	(\2)+,\3
	beq.b	had\@
	blt.b	low\@
high\@	subq.l	#2,\3
	sub.l	\3,\4
	bgt.b	high\@
	bra.b	had\@
low\@	add.l	\3,\4
	addq.l	#2,\3
	ble.b	low\@
	subq.l	#2,\3
had\@	lsr.l	#1,\3
	ENDM

''	move.l	#896*896,d0
''	lea.l	Table,a0
''	PyTree	d0,a0,d1,d2
''	rts
''Table	incbin	"ram:pytree.table"
	
; Tested with 900*900: ok,exact (goes into high cycle)
; Tested with 900*900+1: ok,same
; Tested with 895*895: ok,exact (goes into low cycle)
; Tested with 895*895+1: BAD, gives 896. correct !
; ReTested with 895*895+1: ok,gives 895
; ReTested with 895*895: ok,gives 895
; Tested with 896*896: ok,gives 896, BUT DOES THE low CYCLE! 896 is in the table! must do directly!
; ReTested with 896*896: ok,does directly.
; Post-Opt1:
; ReTested with 896*896: ok,gives 896 (no more directly,table changed.)

