*
* argarraydone.asm
*
* binary source for EPP Module argarray.e
*
	opt l-	; non-linkable, keep other default optimisations

	include	asmsupp.i
	include	exec/exec_lib.i
	include	workbench/icon_lib.i

		rsreset
argarray	rs.l 1
argarraysize	rs.l 1
diskobject	rs.l 1

_ArgArrayInit
	cargs	#0,iconbase.l,argarraydatabase.l
	movea.l	argarraydatabase(sp),a2
	move.l	(a2),d0		; argarray(a2)
	beq.s	noArray
	movea.l	d0,a1
	movea.l	4.w,a6
	CALLSYS	FreeVec
	clr.l	(a2)		; argarray(a2)=NULL

noArray	move.l	diskobject(a2),d0
	beq.s	noDiskObject
	movea.l	d0,a0
	move.l	(sp),a6		; iconbase(sp)
	CALLSYS	FreeDiskObject
	clr.l	diskobject(a2)	; NULL to prevent crash if second call to us

noDiskObject

