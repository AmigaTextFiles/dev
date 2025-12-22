*
* argarrayinit.asm
*
* binary source for EPP Module argarray.e
*
	opt l-	; non-linkable, keep other default optimisations

	include	asmsupp.i
	include	exec/memory.i
	include	exec/exec_lib.i
	include	workbench/startup.i
	include	workbench/workbench.i
	include	workbench/icon_lib.i

		rsreset
argarray	rs.l 1
argarraysize	rs.l 1
diskobject	rs.l 1

_ArgArrayInit
	movem.l	d5-7/a2-4,-(sp)
	cargs	#24,argc.l,argv.l,iconbase.l,tooltypesarrayptr.l,argarraydatabase.l
	move.l	argarraydatabase(sp),a4
	suba.l	a2,a2
	move.l	argv(sp),a3
	move.l	argc(sp),d7
	beq.s	fromWB

	moveq	#1,d0
	cmp.l	d0,d7
	bne.s	fromCLI
	moveq	#0,d0
	bra.s	end

fromCLI	move.l	d7,d0
	asl.l	#2,d0
	move.l	d0,argarraysize(a4)
	move.l	#MEMF_CLEAR,d1
	LINKSYS	AllocVec,4.w
	move.l	d0,(a4)		; argarray(a4)
	beq.s	end

	moveq	#0,d6
	subq.l	#1,d7
	moveq	#0,d5
	bra.s	while
wend	movea.l	(a4),a0		; argarray(a4)
	adda.l	d5,a0
	move.l	4(a3,d5.l),(a0)
	addq.l	#1,d6
	addq.l	#4,d5
while	cmp.l	d7,d6
	bcs.s	wend
	move.l	(a4),d0		; argarray(a4)
	bra.s	end

fromWB	movea.l	sm_ArgList(a3),a0		; get 1rst wbarg (prg's icon)
	movea.l	wa_Name(a0),a0			; get it's name ('<prg>')
	LINKSYS	GetDiskObject,iconbase+4(sp)	; +4 car move.l a6,-(sp)
	move.l	d0,diskobject(a4)
	beq.s	noDiskObject
	movea.l	d0,a0
	movea.l	do_ToolTypes(a0),a2

noDiskObject
	move.l	a2,d0
end	move.l	tooltypesarrayptr(sp),a0
	move.l	d0,(a0)
	movem.l	(sp)+,d5-7/a2-4

