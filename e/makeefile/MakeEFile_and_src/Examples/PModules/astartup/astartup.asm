*
* astartup.asm
*
* source pour astartup.bin -> astartup.e
*
	opt l-
	include	exec/types.i
	include	exec/memory.i
	include	exec/exec_lib.i
	include	dos/dosextens.i
	include	dos/dos_lib.i
	include	workbench/startup.i

	movem.l	a2-5,-(sp)
	cargs	#16,argptr.l,wbmessage.l,dosbase.l,argcptr.l,argvptr.l,databaseptr.l,errorptr.l

 STRUCTURE  SVar,0
    ULONG   sv_Size
    LONG    sv_WbOutput
    ULONG   sv_ArgvBufPtr
    ULONG   sv_MaxArgc
    LABEL   sv_ArgvArray
    LABEL   SV_SIZEOF

	movea.l	argptr(sp),a0
	movea.l	(a0),a2		; a2={arg[]}
	move.l	a2,a0
	moveq	#-1,d0
loop	tst.b	(a0)+
	dbeq	d0,loop
	not.l	d0
	move.l	d0,d2

	suba.l	a1,a1
	move.l	4.w,a6
	jsr	_LVOFindTask(a6)
	move.l	d0,a4

	move.l	pr_CLI(a4),d0
	bne.s	vcnt
	moveq	#2,d4
	moveq	#8,d2
	bra.s	wbnoargs

vcnt	movea.l	a2,a0
	moveq	#3,d4
vcnt1	cmpi.b	#' ',(a0)
	bne.s	vcnt2
	addq.l	#1,d4
vcnt2	tst.b	(a0)+
	bne.s	vcnt1

wbnoargs
	move.l	d4,d0
	lsl.l	#2,d0
	move.l	d0,d5
	add.l	d2,d0
	add.l	#SV_SIZEOF+1,d0

	move.l	d0,d3
	move.l	#(MEMF_PUBLIC!MEMF_CLEAR),d1
	jsr	_LVOAllocMem(a6)
	tst.l	d0
	bne.s	okMem
	move.l	argcptr(sp),a0
	clr.l	(a0)
	move.l	argvptr(sp),a0
	clr.l	(a0)
	move.l	databaseptr(sp),a0
	clr.l	(a0)
	moveq	#-1,d0
	move.l	errorptr(sp),a0
	move.l	d0,(a0)
	bra	end

okMem	move.l	d0,a5
	move.l	d3,(a5)		; sv_Size
	subq.l	#1,d4
	move.l	d4,sv_MaxArgc(a5)
	lea.l	sv_ArgvArray(a5),a0
	adda.l	d5,a0
	move.l  a0,sv_ArgvBufPtr(a5)

	move.l	pr_CLI(a4),d0
	beq	fromWorkbench

	lsl.l	#2,d0
	movea.l	d0,a0
	move.l	cli_CommandName(a0),d0
	lsl.l	#2,d0

	move.l	sv_ArgvBufPtr(a5),a1
	lea	sv_ArgvArray(a5),a3

	move.l	d0,a0
	moveq.l	#0,d0
	move.b	(a0)+,d0
	clr.b	(a0,d0.l)
	move.l	a0,(a3)+
	moveq	#1,d3

	lea	(a2,d2.l),a0
stripjunk
	cmp.b	#' ',-(a0)
	dbhi	d2,stripjunk

	clr.b	1(a0)

newarg	move.b	(a2)+,d1
	beq.s	parmExit
	cmp.b	#' ',d1
	beq.s	newarg
	cmp.b	#9,d1
	beq.s	newarg

	cmp.l	sv_MaxArgc(a5),d3
	beq.s	parmExit

	move.l	a1,(a3)+
	addq.w	#1,d3

	cmp.b	#'"',d1
	beq.s	doquote

	move.b	d1,(a1)+

nextchar
	move.b	(a2)+,d1
	beq.s	parmExit
	cmp.b	#' ',d1
	beq.s	endarg

	move.b	d1,(a1)+
	bra.s	nextchar

endarg	clr.b	(a1)+
	bra.s	newarg

doquote	move.b	(a2)+,d1
	beq.s	parmExit
	cmp.b	#'"',d1
	beq.s	endarg

	cmp.b	#'*',d1
	bne.s	addquotechar

	move.b	(a2)+,d1
	move.b	d1,d2
	and.b	#$df,d2         ;d2 is temp toupper'd d1

	cmp.b	#'N',d2         ;check for dos newline char
	bne.s	checkEscape

	;--     got a *N -- turn into a newline
	moveq	#10,d1
	bra.s	addquotechar

checkEscape
	cmp.b	#'E',d2
	bne.s	addquotechar

	;--     got a *E -- turn into a escape
	moveq	#27,d1

addquotechar
	move.b	d1,(a1)+
	bra.s	doquote

parmExit
        ;------ all done -- null terminate the arguments
	clr.b	(a1)
	clr.l	(a3)

	lea	sv_ArgvArray(a5),a1
	move.l	argvptr(sp),a0
	move.l	a1,(a0)
	move.l	argcptr(sp),a0
	move.l	d3,(a0)
	move.l	databaseptr(sp),a0
	move.l	a5,(a0)
	move.l	errorptr(sp),a0
	clr.l	(a0)

	bra.s	end

fromWorkbench
	move.l	wbmessage(sp),a2
	move.l	sm_ArgList(a2),d0
	beq.s	1$
	move.l	d0,a0
	move.l	wa_Lock(a0),d1
	move.l	dosbase(sp),a6
	jsr	_LVOCurrentDir(a6)	; CurrentDir=<program's dir>

1$	move.l	argvptr(sp),a0
	move.l	a2,(a0)			; _argv=wbmessage
	move.l	argcptr(sp),a0
	clr.l	(a0)			; _argc=0
	move.l	databaseptr(sp),a0
	clr.l	(a0)
	move.l	errorptr(sp),a0
	clr.l	(a0)			; pseudo RETURN_OK

end	movem.l	(sp)+,a2-5
