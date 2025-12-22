;rE
	machine mc68020

; d0 - size
	xdef	_ReNewR
_ReNewR:
	move.l	d0,-(a7)
;IFN _repool THEN IFN _repool:=CreatePool($10005,$2000,$1000) THEN Raise("MEM")
	move.l	__repool,d0
	bne	NewEnd_else1_0
NewEnd_if2:
	move.l	#65541,d0
	move.l	#8192,d1
	move.l	#4096,d2
	movea.l	_ExecBase,a6
	jsr	-696(a6)
	move.l	d0,__repool
	beq	NewEnd_else2_0
NewEnd_else1_0:
;AllocVecPooled(_repool,size)
	move.l	d0,a0
	move.l	(a7)+,d0
	jsr	_AllocVecPooled
	tst.l	d0
	beq	NewEnd_else2_0
	rts
NewEnd_else2_0:
;Raise("MEM")
	move.l	#5064013,d0
	move.l	#0,d1
	jsr	_Raise
	rts

; a0 - pool
; a1 - mem
	xdef	_ReDispose
_ReDispose:
	move.l	a0,-(a7)
;IF mem THEN FreeVecPooled(_repool,mem)
	move.l	a1,d0
	beq	NewEnd_else3_0
;FreeVecPooled(_repool,mem)
	move.l	__repool,a0
	jsr	_FreeVecPooled
NewEnd_else3_0:
	move.l	(a7)+,a0
	rts

; a0 - pool
	xdef	_ReDisposeAll
_ReDisposeAll:
;DeletePool(_repool)
	move.l	__repool,a0
	movea.l	_ExecBase,a6
	jsr	-702(a6)
	rts

	xref	_FreeVecPooled
	xref	_AllocVecPooled
	xref	_Raise
	cnop	0,2

	section	".tocd",data
	xref	_laststackptr
	xref	_lastexceptptr
	xref	_lastframeptr
	xref	_ExecBase
	xref	_exceptioninfo
__repool:
	dc.l	0
	xref	_exception
