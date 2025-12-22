*
* argint.asm
*
* binary source for EPP Module argarray.e
*
	opt l-	; non-linkable, keep other default optimisations

	include	asmsupp.i
	include	workbench/icon_lib.i
	include	dos/dos_lib.i

ArgInt	cargs	#0,ttypes.l,entry.l,defaultptr.l,iconbase.l,dosbase.l
	move.l	(sp),d0
	beq.s	default
	movea.l	d0,a0
	movea.l	entry(sp),a1
	movea.l	iconbase(sp),a6
	CALLSYS	FindToolType
	move.l	d0,d1
	beq.s	default
	move.l	defaultptr(sp),d2
	movea.l	dosbase(sp),a6
	CALLSYS	StrToLong
default

