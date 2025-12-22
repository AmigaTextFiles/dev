*-----------------------------------------------*
*	@MuotoileLaiteLista			*
*-----------------------------------------------*

MuotoileLaiteLista:
	move.l	a2,-(sp)
	move.l	#HDImageSpec,(a2)+
	lea	ll_DeviceName(a1),a0
	move.l	a0,(a2)+
	lea	ll_VolumeName(a1),a0
	move.l	a0,(a2)+
	lea	ll_DiskUsage(a1),a0
	move.l	a0,(a2)
	move.l	(sp)+,a2
	moveq	#0,d0
	rts

*-----------------------------------------------*
*	@J‰rjest‰LaiteLista			*
*-----------------------------------------------*

J‰rjest‰LaiteLista:
	movem.l	a2-a6,-(sp)
	lea	b,a4
	move.l	a1,a3
	move.l	a2,a5
	move.l	localebase(a4),a6
	move.l	SystemLocale(a4),a0
	lea	ll_DeviceName(a3),a1
	lea	ll_DeviceName(a5),a2
	moveq	#-1,d0
	move.l	#SC_ASCII,d1
	jsr	_LVOStrnCmp(a6)
	tst.l	d0
	bne.b	.x
	lea	ll_VolumeName-ll_DeviceName(a3),a1
	lea	ll_VolumeName-ll_DeviceName(a5),a2
	move.l	SystemLocale(a4),a0
	moveq	#-1,d0
	move.l	#SC_ASCII,d1
	jsr	_LVOStrnCmp(a6)
	tst.l	d0
.x	movem.l	(sp)+,a2-a6
	rts

*-----------------------------------------------*
*       @SuljeDefrag				*
*-----------------------------------------------*

SuljeDefrag:
	ALOITA
	st	bfStopDefrag(a4)
	st	bfQuitDefrag(a4)
	move.l	intui(a4),a6
	move.l	WI_DefragWindow(a4),a0
	SETI	MUIA_Window_Open,FALSE
	move.l	BT_Eheyt‰_SFS-t(a5),a0
	SETI	MUIA_Disabled,FALSE
	lea	t_DefStartTime-t(a5),a3
	move.l	TX_Defrag_Time-t(a5),a0
	SET2	#MUIA_Text_Contents,A3
	LOPETA
	rts
