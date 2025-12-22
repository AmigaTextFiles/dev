
		include	libraries/powerpc_lib.i
		include	powerpc/powerpc.i
		
* --- PPC calling wild macro --- (checks the module if it is 68k or not.)

wiCallModule	MACRO	; a6=libbase \1:lvo,\2="Async" of not.
		cmp.b	#TYPEH_CPU_WARPUP,wm_Types+wy_TypeH(a6)
		bne.b	.nowarpup\@
		lea.l	-PP_SIZE(a7),a7
		movem.l	d0/d1,PP_REGS(a7)
		movem.l	a0/a1,PP_REGS+8*4(a7)
		move.l	a6,PP_REGS+14*4(a7)
		beq.b	.nobasep\@
		movea.l	a7,a0
		movea.l	a0,a1
		move.l	a6,(a1)+
		move.l	a6,-(a7)
		move.l	\1,(a1)+
		IFNC	'Async','\2'
		clr.l	(a1)+
		ELSE
		moveq.l	#1,d0
		move.l	d0,(a1)+
		ENDC
		clr.l	(a1)+
		movea.l	wm_WildBase(a6),a6
		clr.l	(a1)+
		movea.l	wi_PowerPCBase(a6),a6
		Call	RunPPC
		movea.l	(a7)+,a6
		move.l	PP_REGS(a7),d0
.nobasep\@	lea.l	PP_SIZE(a7),a7
		bra.b	.done\@
.nowarpup\@	tst.l	a6
		beq.b	.nobase\@
		move.l	a5,-(a7)
		movea.l	a6,a5
		add.l	\1,a5
		jsr	(a5)
		movea.l	(a7)+,a5
.nobase\@
.done\@		
		ENDM	