
	IFND	MEMHANDLER_I
MEMHANDLER_I		SET	1

		INCLUDE	exec/semaphores.i

;=========================================================================
;-------------------------------------------------------------------------
;
;		CreateRenderMemHandler
;
;		Alloziert und initialisiert einen RenderMemHandler.
;		RMHTYPE_POOL setzt v39 voraus (wird nicht geprüft).
;
;	>	a0	APTR	private memory or NULL
;		d0	ULONG	size of private memory or NULL
;		d1	UWORD	type (RMHTYPE_POOL, RMHTYPE_PRIVATE or
;				RMHTYPE_PUBLIC)	
;		d2	ULONG	MEMF_... für PUBLIC und POOLED
;	<	d0	APTR	RenderMemHandler or NULL
;
;-------------------------------------------------------------------------

CreateRenderMemHandler:
	
		movem.l	d1-d7/a0-a6,-(a7)

		move.l	a0,d6			; private memory merken
		move.l	d0,d7			; private size merken
		move.w	d1,d5

		move.l	d2,d4

		move.l	(execbase,pc),a6

		moveq	#rmh_SIZEOF,d0		; Speicher für MemHandler-Struktur holen
		move.l	#MEMF_ANY+MEMF_CLEAR,d1
		jsr	(_LVOAllocMem,a6)
		tst.l	d0
		beq.b	armh_end		; vergiß es
		
		move.l	d0,a5

		move.w	d5,d1

		move.w	d1,(rmh_type,a5)	; handler-type eintragen
		move.l	d4,(rmh_memflags,a5)	; memflags MEMF_ eintragen

		cmp.w	#RMHTYPE_POOL,d1
		beq.b	armh_pool
		
		cmp.w	#RMHTYPE_PRIVATE,d1
		beq.b	armh_private
		
		cmp.w	#RMHTYPE_PUBLIC,d1
		beq.b	armh_public


		;	schiefgegangen, Struktur freigeben:

armh_fail	move.l	a5,a1
		moveq	#rmh_SIZEOF,d0
		jsr	(_LVOFreeMem,a6)
		moveq	#0,d0			; FAIL
		bra.b	armh_end


		;	dynamischen v39 exec Pool anlegen:
		
armh_pool	move.l	d4,d0			; MEMF_
		move.l	#RMH_PUDSIZE,d1
		move.l	d1,d2
		jsr	(_LVOCreatePool,a6)
		tst.l	d0
		beq.b	armh_fail
		
		move.l	d0,(rmh_poolheader,a5)

	lea	(rmh_semaphore,a5),a0
	move.l	a0,a1
	moveq	#SS_SIZE/2-1,d0
.clrsl	clr.w	(a1)+
	dbf	d0,.clrsl
	jsr	(_LVOInitSemaphore,a6)

		move.l	a5,d0
		bra.b	armh_end


		;	statischen privaten Pool anlegen
		
armh_private	move.l	d6,a0			; private memory
		move.l	d7,d0			; private memory size
		bsr.w	_InitPool		; MemHeader am Speicheranfang anlegen
		tst.l	d0
		beq.b	armh_fail
		
		move.l	d0,(rmh_privateheader,a5)
		move.l	a5,d0
		bra.b	armh_end


armh_public	move.l	a5,d0			; Memhandler-Struktur
	

armh_end	movem.l	(a7)+,d1-d7/a0-a6
		rts

;-------------------------------------------------------------------------
;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		DeleteRenderMemHandler
;
;		Gibt eine RenderMem-Struktur und einen
;		assoziierten Pool frei.
;
;		- Public Memory muß von Hand freigegeben worden sein
;		- Mit privaten Pools geschieht nichts
;		- Exec v39 pools werden ans System zurückgegeben
;
;	>	a0	APTR	RenderMemHandler
;
;-------------------------------------------------------------------------

DeleteRenderMemHandler:

		move.l	(rmh_nestcount,a0),d0
		bne.b	drmh_illegal

		cmp.w	#RMHTYPE_PRIVATE,(rmh_type,a0)
		beq.b	drmh_raus

		move.l	a6,-(a7)
		move.l	(execbase,pc),a6

		cmp.w	#RMHTYPE_POOL,(rmh_type,a0)
		bne.b	drmh_nopool
		
		move.l	a0,-(a7)
		move.l	(rmh_poolheader,a0),a0
		jsr	(_LVODeletePool,a6)
		move.l	(a7)+,a0

drmh_nopool	move.l	a0,a1
		moveq	#rmh_SIZEOF,d0
		jsr	(_LVOFreeMem,a6)

		move.l	(a7)+,a6

drmh_raus	rts

drmh_illegal	illegal

;-------------------------------------------------------------------------
;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		AllocRenderVecClear
;
;		Alloziert Speicher über einen RenderMemHandler
;		und löscht den Buffer
;
;	>	a0	APTR	RenderMemHandler oder NULL
;		d0	ULONG	Size
;	<	d0	APTR	mem oder NULL
;
;-------------------------------------------------------------------------

AllocRenderVecClear:
		move.l	d0,-(a7)

		bsr.b	AllocRenderVec
		tst.l	d0
		bne.b	.ok

		addq.w	#4,a7
		rts

.ok		move.l	d0,a0
		move.l	(a7)+,d0
		moveq	#0,d1
		bsr	TurboFillMem
		move.l	a0,d0
		rts
		
;-------------------------------------------------------------------------
;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		AllocRenderVec
;
;		Alloziert Speicher über einen RenderMemHandler.
;
;	>	a0	APTR	RenderMemHandler oder NULL
;		d0	ULONG	Size
;	<	d0	APTR	mem oder NULL
;
;-------------------------------------------------------------------------

AllocRenderVec:	movem.l	d2/d3,-(sp)

		addq.l	#8,d0
		move.l	d0,d2
		move.l	a0,d3

		bsr.b	AllocRenderMem
		tst.l	d0
		beq.b	arv_fail

		move.l	d0,a0
		move.l	d3,(a0)+
		move.l	d2,(a0)+
		move.l	a0,d0

arv_fail	movem.l	(sp)+,d2/d3
		rts

;-------------------------------------------------------------------------
;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		AllocRenderMem
;
;		Alloziert Speicher über einen RenderMemHandler.
;
;	>	a0	APTR	RenderMemHandler oder NULL
;		d0	ULONG	Size
;	<	d0	APTR	mem oder NULL
;
;-------------------------------------------------------------------------

AllocRenderMem:	movem.l	a6/a2,-(a7)

		move.l	(execbase,pc),a6

		move.l	a0,a2
		move.l	a0,d1
		bne.b	arm_handlerda

		moveq	#MEMF_ANY,d1
		jsr	(_LVOAllocMem,a6)
		bra.b	arm_raus

arm_handlerda	cmp.w	#RMHTYPE_POOL,(rmh_type,a0)
		beq.b	arm_pool

		cmp.w	#RMHTYPE_PRIVATE,(rmh_type,a0)
		beq.b	arm_private

arm_public	move.l	(rmh_memflags,a0),d1		; MEMF_
		jsr	(_LVOAllocMem,a6)
		tst.l	d0
		bne.b	arm_success
		bra.b	arm_raus

arm_pool

	lea	(rmh_semaphore,a2),a0
	jsr	(_LVOObtainSemaphore,a6)

		move.l	(rmh_poolheader,a2),a0
		jsr	(_LVOAllocPooled,a6)

	lea	(rmh_semaphore,a2),a0
	jsr	(_LVOReleaseSemaphore,a6)

		tst.l	d0
		bne.b	arm_success
		bra.b	arm_raus


arm_private	move.l	(rmh_privateheader,a0),a0
		jsr	(_LVOAllocate,a6)
		tst.l	d0
		beq.b	arm_raus

arm_success	addq.l	#1,(rmh_nestcount,a2)

arm_raus	movem.l	(a7)+,a6/a2
		rts


;-------------------------------------------------------------------------
;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		FreeRenderVec
;
;		Gibt Speicher an einen RenderMemHandler zurück.
;
;	>	a0	APTR	mem
;
;-------------------------------------------------------------------------

FreeRenderVec:	;	>	a0	Mem

		move.l	a0,d0
		beq.b	.raus

		move.l	-(a0),d0
		move.l	-(a0),a1
		exg	a0,a1
		bra.w	FreeRenderMem

.raus		rts

;-------------------------------------------------------------------------
;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		FreeRenderMem
;
;		Gibt einen Speicherblock an einen
;		RenderMemHandler zurück.
;
;	>	a0	APTR	RenderMemHandler
;		a1	APTR	mem
;		d0	ULONG	size
;
;-------------------------------------------------------------------------

FreeRenderMem:	move.l	a6,-(a7)

		move.l	(execbase,pc),a6

		move.l	a0,d1
		beq.b	frm_public

		subq.l	#1,(rmh_nestcount,a0)
		bmi	drmh_illegal

		cmp.w	#RMHTYPE_POOL,(rmh_type,a0)
		beq.b	frm_pool

		cmp.w	#RMHTYPE_PRIVATE,(rmh_type,a0)
		beq.b	frm_private

frm_public	jsr	(_LVOFreeMem,a6)
		move.l	(a7)+,a6
		rts

frm_pool
		move.l	a2,-(a7)

		move.l	a0,a2

		lea	(rmh_semaphore,a2),a0
		jsr	(_LVOObtainSemaphore,a6)

		move.l	(rmh_poolheader,a2),a0
		jsr	(_LVOFreePooled,a6)

		lea	(rmh_semaphore,a2),a0
		jsr	(_LVOReleaseSemaphore,a6)

		move.l	(a7)+,a2
		move.l	(a7)+,a6
		rts

frm_private	move.l	(rmh_privateheader,a0),a0
		jsr	(_LVODeallocate,a6)
		move.l	(a7)+,a6
		rts

;-------------------------------------------------------------------------
;=========================================================================


;-------------------------------------------------------------------------
;
;		InitPool
;		1995, Timm S. Müller
;
;		Legt in einem Speicherbereich einen Pool an.
;		Aus diesem Pool kann später mit AllocPool
;		nach Belieben Speicher besorgt werden.
;		Auch können in einem Pool problemlos
;		Sub-Pools angelegt werden.
;
;	>	a0	Mem
;		d0	Size [Bytes]
;	<	d0	Pool oder NULL
;
;-------------------------------------------------------------------------

_InitPool:	movem.l	a0-a2/d7,-(a7)

		moveq	#0,d7
		sub.l	#MH_SIZE+MC_SIZE,d0
		cmp.l	#16,d0
		blt.b	inp_fail

		lea	MH_SIZE(a0),a1

		clr.l	LN_SUCC(a0)
		clr.l	LN_PRED(a0)
		move.w	#NT_MEMORY<<8,LN_TYPE(a0)
		clr.l	LN_NAME(a0)
		clr.w	MH_ATTRIBUTES(a0)
		move.l	a1,MH_FIRST(a0)
		move.l	a1,MH_LOWER(a0)
		lea	(a1,d0.l),a2
		move.l	a2,MH_UPPER(a0)
		move.l	d0,MH_FREE(a0)

		clr.l	MC_NEXT(a1)
		move.l	d0,MC_BYTES(a1)		

		move.l	a0,d7
		
inp_fail	move.l	d7,d0
		movem.l	(a7)+,a0-a2/d7
		rts

;-------------------------------------------------------------------------

	ENDC
