
	IFND	MISCMACROS_I
MISCMACROS_I		SET	1

;-------------------------------------------------------------------------


Lock			MACRO

		move.l	a0,-(a7)
		move.l	a6,-(a7)
		lea	\1,a0
		move.l	(execbase,pc),a6
		jsr	(_LVOObtainSemaphore,a6)
		move.l	(a7)+,a6
		move.l	(a7)+,a0

			ENDM

LockShared		MACRO

		move.l	a0,-(a7)
		move.l	a6,-(a7)
		lea	\1,a0
		move.l	(execbase,pc),a6
		jsr	(_LVOObtainSemaphoreShared,a6)
		move.l	(a7)+,a6
		move.l	(a7)+,a0

			ENDM

Unlock			MACRO
		
		move.l	a0,-(a7)
		move.l	a6,-(a7)
		lea	\1,a0
		move.l	(execbase,pc),a6
		jsr	(_LVOReleaseSemaphore,a6)
		move.l	(a7)+,a6
		move.l	(a7)+,a0

			ENDM

;-------------------------------------------------------------------------

;-------------------------------------------------------------------------

GetTag		MACRO

		move.l	\2,d0
		move.l	\3,d1
		beq.b	.skip\@

		move.l	d1,a0
		move.l	d0,d1
		move.l	\1,d0

		jsr	(_LVOGetTagData,a6)
.skip\@
		
		ENDM

;-------------------------------------------------------------------------

	ENDC
