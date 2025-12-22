*-----------------------------------------------*
*	@Suorita_SFScheck			*
*-----------------------------------------------*

Suorita_SFScheck:
	ALOITA
	move.l	exec(a4),a6
	move.l	ActiveEntry(a4),a1
	lea	putchar,a2
	lea	ll_DeviceName(a1),a0
	lea	PutkiTiedosto(a4),a1
	move.l	a0,(a4)
	move.l	a1,4(a4)
	lea	SFScheckFormat-t(a5),a0
	move.l	a4,a1
	lea	16(a4),a3
	jsr	_LVORawDoFmt(a6)

	move.l	dos(a4),a6
	move.l	a3,d1
	moveq	#0,d2
	moveq	#0,d3
	jsr	_LVOExecute(a6)
	tst.l	d0
	beq	.x

.x	LOPETA
	rts

*-----------------------------------------------*
*	@Eheyt‰_SFS				*
*-----------------------------------------------*

Eheyt‰_SFS:
	ALOITA
	bsr	CreateDefragWindow
	beq.b	.x

	bsr	EnableStartDefrag

	bsr	InitDefrag
	beq.b	.virhe

	move.l	ll_Version(a3),d0
	cmp.w	#MIN_REVISION,d0
	bhs.b	.jatka
	swap	d0
	cmp.w	#MIN_VERSION+1,d0
	blo.b	.virhe

.jatka	move.l	WI_DefragWindow(a4),a0
	bsr	AvaaIkkuna
	tst.l	lfWindowOpen(a4)
	beq	.x

	move.l	BT_Eheyt‰_SFS-t(a5),a0
	SETI	MUIA_Disabled,TRUE


;	TEE_METODI	MP_Kartta-t(a5),ReDrawMetodit

.x	LOPETA
	rts

.virhe	move.l	intui(a4),a6
	move.l	BT_Start_Defragment-t(a5),a0
	SETI	MUIA_Disabled,TRUE
	bra.b	.jatka

*-----------------------------------------------*
*	@SwitchDefrag				*
*-----------------------------------------------*

SwitchDefrag:
	ALOITA
	move.l	intui(a4),a6
	move.l	DefragWindowChild_A-t(a5),a0
	SETI	MUIA_Group_ActivePage,MUIV_Group_ActivePage_Advance
	not.b	bfStopDefrag(a4)
	bne.b	.pois

	tst.l	CurrPkt(a4)
	bne.b	.pois

	move.l	TimerBase(a4),a6
	lea	StartTime(a4),a0
	jsr	_LVOGetSysTime(a6)
	lea	ElapsedTime(a4),a1
	jsr	_LVOSubTime(a6)

	bsr	AskTimerInt
	bsr	Defrag

.pois	LOPETA
	rts

*-----------------------------------------------*
*	@StartDefrag				*
*-----------------------------------------------*

StartDefrag:
	ALOITA
	clr.b	bfStopDefrag(a4)
	clr.b	bfQuitDefrag(a4)

	bsr	DisableStartDefrag

	bsr	AbortPacket

	move.l	DefragEntry(a4),a3

	bsr	AddBuffers

	bsr	Tyhjenn‰Roskakori

	move.l	#ACTION_SFS_DEFRAGMENT_INIT,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	bsr	L‰het‰Paketti
	beq.b	.virhe

;	bsr	LockDevice
	beq.b	.x

	move.l	ll_MsgPort(a3),SFSport_Abort(a4)

	move.l	TimerBase(a4),a6
	lea	StartTime(a4),a0
	jsr	_LVOGetSysTime(a6)

	bsr	AskTimerInt

	bsr	Defrag

.x	LOPETA
	rts

.virhe	GETSTR	MSG_SFS_ERROR
	move.l	d0,a2
	bsr	InfoRequester
	bsr	EnableStartDefrag
	bra.b	.x

*-----------------------------------------------*
*	@AbortDefrag				*
*-----------------------------------------------*

AbortDefrag:
	ALOITA
	st	bfStopDefrag(a4)
	bsr	EnableStartDefrag
	LOPETA
	rts

*-----------------------------------------------*
*       @SavePrefs				*
*-----------------------------------------------*

SavePrefs:
	ALOITA
	bsr	UseConfig
	lea	EnvarcConfigName-t(a5),a1
	bsr	SaveConfig
	TEE_METODI	App(a4),TallennaAsetukset_ENVARC_Metodit
	LOPETA
	rts

*-----------------------------------------------*
*	@UsePrefs				*
*-----------------------------------------------*

UsePrefs:
	ALOITA
	bsr	UseConfig
	LOPETA
	rts

*-----------------------------------------------*
*	@CancelPrefs				*
*-----------------------------------------------*

CancelPrefs:
	ALOITA
	bsr	LoadConfig
	bsr	AdjustConfig
	move.l	intui(a4),a6
	move.l	WI_PrefsWindow-t(a5),a0
	SETI	MUIA_Window_Open,FALSE
	TEE_METODI	App(a4),LataaAsetukset_Metodit
	LOPETA
	rts
