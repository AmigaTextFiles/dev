*
* argstring.asm
*
* binary source for EPP Module argarray.e
*
	opt l-	; non-linkable, keep other default optimisations

	include	asmsupp.i
	include	workbench/icon_lib.i

ArgString
	cargs	#0,ttypes.l,entry.l,default.l,resultptr.l,iconbase.l
	movem.l	default(sp),d2/a2
	move.l	(sp),d0
	beq.s	_default
	movea.l	d0,a0
	movea.l	entry(sp),a1
	movea.l	iconbase(sp),a6
	CALLSYS	FindToolType
	tst.l	d0
	bne.s	end
_default
	move.l	d2,d0
end	move.l	d0,(a2)

