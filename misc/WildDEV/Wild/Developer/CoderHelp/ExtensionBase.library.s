
		include	WildInc.gs
		include	Wild/wild.i
		include PyperLibMaker.i
		include	PyperMacro.i
		include	Wild/modules_macros.i

EXTTYPES1	EQU	TYPEA_FULLCOMPATIBLE<<24+TYPEB_FULLCOMPATIBLE<<16+TYPEC_FULLCOMPATIBLE<<8+TYPED_FULLCOMPATIBLE
EXTTYPES2	EQU	TYPEE_FULLCOMPATIBLE<<24+TYPEF_FULLCOMPATIBLE<<16+TYPEG_FULLCOMPATIBLE<<8+TYPEH_FULLCOMPATIBLE

		Lib	ExtensionBase,1,0,08.9.1998,wdm_SIZEOF
		Lib	FUNCTIONS
		Lib	OpenLib
		Lib	CloseLib
		Lib	ExpugneLib
		Lib	ExtFuncLib

		Lib	SetModuleTags
		Lib	GetModuleTags
		Lib	SetUpModule
		Lib	CloseModule
		Lib	RefreshModule

		Lib	CODE

		Lib	Init
		exg	a0,d0
		move.l	d0,LIB_SIZE(a0)
		move.l	#MODTYPES1,wm_Types(a0)
		move.l	#MODTYPES2,wm_Types+4(a0)
		clr.w	wm_CNT(a0)
		
		; Here you can do the First init !
		; Take care !!! Preserve A0(LibBase) and D0(Don'tKnow)
		
		exg	a0,d0
		rts

		Lib	OpenLib
		add.w	#1,LIB_OPENCNT(a6)
		bset	#LIBB_DELEXP,LIB_FLAGS(a6)	; MODULES DEFAULT ARE WANTED TO FREE THEIR MEMORY WHEN CLOSED SO THE EXPUGNE FLAG IS SET ,USUALLY. CLEAR IT ONLY IF REALLY NEEDED.
		
		; Here you can do any init you want, but take care: EVERY time the
		; lib is opened, this init is done. The first time-only init is
		; in the Init routine
		
		move.l	a6,d0
		rts

		Lib	CloseLib
		subq.w	#1,LIB_OPENCNT(a6)
		bne.b	ExtFuncLib
		btst	#LIBB_DELEXP,LIB_FLAGS(a6)
		beq.b	ExtFuncLib

		Lib	ExpugneLib
		movem.l	d2/a5/a6,-(sp)
		tst.w	LIB_OPENCNT(a6) 
		bne.b	.still_openned

		;On this place free all resources which has been
		;allocated in init part. a6 contain library base.

		move.l	LIB_SIZE(a6),d2
		move.l	a6,a5
		move.l	4.w,a6
		move.l	a5,a1
		jsr	_LVORemove(a6)
		move.l	a5,a1
		moveq	#0,d0
		move.w	LIB_NEGSIZE(a5),d0
		sub.w	d0,a1
		add.w	LIB_POSSIZE(a5),d0
		jsr	_LVOFreeMem(a6)
		move.l	d2,d0
		movem.l	(sp)+,d2/a5/a6
		rts
.still_openned
		Lib	ExtFuncLib
		moveq	#0,d0
		rts

		;... here your funcs ...

		Lib	END