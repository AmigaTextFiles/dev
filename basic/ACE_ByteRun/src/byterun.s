; History
; 1.0 - First release, SuperOptimizer FULL output
; 1.1 - Optimized compare operations (-96 bytes)

	xref _AbsExecBase
	xref _LVOPermit
	xdef _SUB_CMP_BR
	xref _LVOForbid
	xdef _SUB_DCMP_BR
	xref _EXIT_PROG
	SECTION code,CODE
	jmp	_lab0
_SUB_WIEVIELGLEICH:
	link	a5,#-12
	move.l	($4).w,a6
	jsr	_LVOPermit(a6)
	MOVEQ	#0,d3
	move.l	d3,-8(a5)
	move.l	-4(a5),a0
	move.b	(a0),d0
	ext.w	d0
	bge.s	_lab1
	not.w	d0
	move.w	#255,d1
	sub.w	d0,d1
	move.w	d1,d0
_lab1:
	move.w	d0,-10(a5)
	move.w	d0,-12(a5)
_lab2:
	move.w	-12(a5),d0
	cmp.w	-10(a5),d0
	bne.s	_lab6
	move.l	-8(a5),d0
	add.l	#1,d0
	move.l	d0,-8(a5)
	move.l	-4(a5),d0
	add.l	-8(a5),d0
	move.l	d0,a0
	move.b	(a0),d0
	ext.w	d0
	bge.s	_lab5
	not.w	d0
	move.w	#255,d1
	sub.w	d0,d1
	move.w	d1,d0
_lab5:
	move.w	d0,-12(a5)
	jmp	_lab2
_lab6:
	move.l	-8(a5),d0
_EXIT_SUB_WIEVIELGLEICH:
	unlk	a5
	rts	  
_lab0:
	jmp	_lab7
_SUB_CMP_BR:
	link	a5,#-46
	move.l	($4).w,a6
	jsr	_LVOPermit(a6)
	MOVEQ	#0,d3
	move.l	d3,-16(a5)
	move.l	d3,-20(a5)
_lab8:
	move.l	-16(a5),d0
	cmp.l	-12(a5),d0
	bge.s	_lab26
	move.l	-4(a5),d0
	add.l	-16(a5),d0
	move.l	d0,-28(a5)
	move.l	($4).w,a6
	jsr	_LVOForbid(a6)
	move.l	-28(a5),-12(sp)
	jsr	_SUB_WIEVIELGLEICH
	move.l	d0,-24(a5)
	CmP.l	#2,d0
	ble.s	_lab17
	CmP.l	#129,-24(a5)
	ble.s	_lab15
	move.l	#129,-24(a5)
_lab15:
	move.l	-4(a5),d0
	add.l	-16(a5),d0
	move.l	d0,a0
	move.b	(a0),d0
	ext.w	d0
	bge.s	_lab16
	not.w	d0
	move.w	#255,d1
	sub.w	d0,d1
	move.w	d1,d0
_lab16:
	move.w	d0,-30(a5)
	move.l	#257,d0
	sub.l	-24(a5),d0
	move.w	d0,-32(a5)
	move.l	-8(a5),d0
	add.l	-20(a5),d0
	move.l	d0,a0
	move.w	-32(a5),d0
	move.b	d0,(a0)
	move.l	-8(a5),d0
	add.l	-20(a5),d0
	add.l	#1,d0
	move.l	d0,a0
	move.w	-30(a5),d0
	move.b	d0,(a0)
	move.l	-16(a5),d0
	add.l	-24(a5),d0
	move.l	d0,-16(a5)
	move.l	-20(a5),d0
	add.l	#2,d0
	move.l	d0,-20(a5)
	jmp	_lab25
_lab17:
	MOVEQ	#0,d3
	move.l	d3,-36(a5)
	move.l	d3,-40(a5)
_lab18:
	CmP.l	#3,-40(a5)
	bge.s	_lab21
	move.l	-36(a5),d0
	add.l	#1,d0
	move.l	d0,-36(a5)
	move.l	-4(a5),d0
	add.l	-16(a5),d0
	add.l	-36(a5),d0
	move.l	d0,-44(a5)
	move.l	($4).w,a6
	jsr	_LVOForbid(a6)
	move.l	-44(a5),-12(sp)
	jsr	_SUB_WIEVIELGLEICH
	move.l	d0,-40(a5)
	jmp	_lab18
_lab21:
	CmP.l	#128,-36(a5)
	ble.s	_lab24
	move.l	#128,-36(a5)
_lab24:
	move.l	-36(a5),d0
	sub.l	#1,d0
	move.w	d0,-46(a5)
	move.l	-8(a5),d0
	add.l	-20(a5),d0
	move.l	d0,a0
	move.w	-46(a5),d0
	move.b	d0,(a0)
	move.l	-4(a5),d0
	add.l	-16(a5),d0
	move.l	d0,a0
	move.l	-8(a5),d0
	add.l	-20(a5),d0
	add.l	#1,d0
	move.l	d0,a1
	move.l	-36(a5),d0
	move.l	($4).w,a6
	jsr	-624(a6)
	move.l	-16(a5),d0
	add.l	-36(a5),d0
	move.l	d0,-16(a5)
	move.l	-20(a5),d0
	add.l	-36(a5),d0
	add.l	#1,d0
	move.l	d0,-20(a5)
_lab25:
	jmp	_lab8
_lab26:
	move.l	-20(a5),d0
_EXIT_SUB_CMP_BR:
	unlk	a5
	rts	  
_lab7:
	jmp	_lab27
_SUB_DCMP_BR:
	link	a5,#-26
	move.l	($4).w,a6
	jsr	_LVOPermit(a6)
	MOVEQ	#0,d3
	move.l	d3,-16(a5)
	move.l	d3,-20(a5)
_lab28:
	move.l	-20(a5),d0
	cmp.l	-12(a5),d0
	bge.s	_lab42
	move.l	-4(a5),d0
	add.l	-16(a5),d0
	move.l	d0,a0
	move.b	(a0),d0
	ext.w	d0
	bge.s	_lab31
	not.w	d0
	move.w	#255,d1
	sub.w	d0,d1
	move.w	d1,d0
_lab31:
	move.w	d0,-22(a5)
	move.l	-16(a5),d0
	add.l	#1,d0
	move.l	d0,-16(a5)
	CmP.w	#-1,-22(a5)
	ble.s	_lab35
	CmP.w	#128,-22(a5)
	bge.s	_lab35
	move.w	-22(a5),d0
	add.w	#1,d0
	move.w	d0,-22(a5)
	move.l	-4(a5),d0
	add.l	-16(a5),d0
	move.l	d0,a0
	move.l	-8(a5),d0
	add.l	-20(a5),d0
	move.l	d0,a1
	move.w	-22(a5),d0
	EXT.L	d0
	move.l	($4).w,a6
	jsr	-624(a6)
	move.w	-22(a5),d0
	ext.l	d0
	move.l	d0,d1
	move.l	-20(a5),d0
	add.l	d1,d0
	move.l	d0,-20(a5)
	move.w	-22(a5),d0
	ext.l	d0
	move.l	d0,d1
	move.l	-16(a5),d0
	add.l	d1,d0
	move.l	d0,-16(a5)
	jmp	_lab41
_lab35:
	move.l	-4(a5),d0
	add.l	-16(a5),d0
	move.l	d0,a0
	move.b	(a0),d0
	ext.w	d0
	bge.s	_lab36
	not.w	d0
	move.w	#255,d1
	sub.w	d0,d1
	move.w	d1,d0
_lab36:
	move.w	d0,-24(a5)
	move.l	-16(a5),d0
	add.l	#1,d0
	move.l	d0,-16(a5)
	move.w	#256,d0
	sub.w	-22(a5),d0
	move.w	d0,-22(a5)
	move.w	#0,-26(a5)
	move.w	d0,-(sp)
	move.w	#1,-(sp)
_lab37:
	move.w	-26(a5),d0
	move.w	2(sp),d1
	tst.w	(sp)
	blt	_lab38
	cmp.w	d1,d0
	bgt	_lab40
	jmp	_lab39
_lab38:
	cmp.w	d1,d0
	blt	_lab40
_lab39:
	move.l	-8(a5),d0
	add.l	-20(a5),d0
	move.l	d0,d7
	move.w	-26(a5),d0
	ext.l	d0
	move.l	d0,d1
	move.l	d7,d0
	add.l	d1,d0
	move.l	d0,a0
	move.w	-24(a5),d0
	move.b	d0,(a0)
	move.w	(sp),d0
	add.w	d0,-26(a5)
	jmp	_lab37
_lab40:
	addq	#4,sp
	move.w	-26(a5),d0
	ext.l	d0
	move.l	d0,d1
	move.l	-20(a5),d0
	add.l	d1,d0
	move.l	d0,-20(a5)
_lab41:
	jmp	_lab28
_lab42:
_EXIT_SUB_DCMP_BR:
	unlk	a5
	rts	  
_lab27:
	SECTION mem,BSS
_EXECBase	ds.l 1
_dataptr:	ds.l 1
	END
