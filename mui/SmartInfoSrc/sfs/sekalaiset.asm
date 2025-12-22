putchar move.b	d0,(a3)+
	rts

*---------------------------------------*
*	@TeeObjekti_Checkmark		*
*---------------------------------------*

TeeObjekti_Checkmark:
	move.l	d1,-(sp)
	MOVEQ.L	#MUIO_Checkmark,D0
	MOVE.L	SP,A0
	JSR	_LVOMUI_MakeObjectA(A6)
	MOVE.L	D0,D2
	ADDQ.W	#4,SP
	beq.b	.x
	MOVE.L	intui(A4),A6
	MOVE.L	D0,A0
	LEA	AddCheckMarkTags-t(A5),A1
	JSR	_LVOSetAttrsA(A6)
	MOVE.L	muimaster(A4),A6
	MOVE.L	D2,D0
.x	RTS

*---------------------------------------*
*	@TeeObjekti_Label		*
*---------------------------------------*

TeeObjekti_Label:
	MOVE.L	localebase(A4),A6
	MOVE.L	catalog(A4),A0
	JSR	_LVOGetCatalogStr(A6)
TeeObjekti_Teksti:
	MOVE.L	muimaster(A4),A6
	MOVE.L	D2,-(SP)
	MOVE.L	D0,-(SP)
	MOVE.L	SP,A0
	MOVE.L	#MUIO_Label,D0
	JSR	_LVOMUI_MakeObjectA(A6)
	ADDQ.L	#8,SP
	RTS

*---------------------------------------*
*	@TeeObjekti			*
*---------------------------------------*

TeeObjekti:
	move.l	muimaster(a4),a6
	CLR.L	-(SP)
	MOVE.L	D1,-(SP)
	MOVE.L	SP,A0
	JSR	_LVOMUI_MakeObjectA(A6)
	ADDQ.W	#8,SP
	MOVE.L	D0,D2
	beq.b	.x
	MOVE.L	intui(A4),A6
	MOVE.L	D0,A0
	LEA	AddHelpStringTags-t(A5),A1
	JSR	_LVOSetAttrsA(A6)
	MOVE.L	muimaster(A4),A6
	MOVE.L	D2,D0
.x	RTS

*---------------------------------------*
*	@TeeNimiObjekti			*
*---------------------------------------*

TeeNimiObjekti:
	move.l	muimaster(a4),a6
	move.l	d1,-(sp)
	move.l	d0,-(sp)
	move.l	sp,a0
	move.l	#MUIO_Label,d0
	jsr	_LVOMUI_MakeObjectA(a6)
	addq.w	#8,sp
	rts

*---------------------------------------*
*	@NukuHyvin			*
*---------------------------------------*

NukuHyvin:
	move.l	intui(a4),a6
	move.l	App(a4),a0
	SETI	MUIA_Application_Sleep,TRUE
	rts

*---------------------------------------*
*	@Huomenta			*
*---------------------------------------*

Huomenta:
	move.l	intui(a4),a6
	move.l	App(a4),a0
	SETI	MUIA_Application_Sleep,FALSE
	rts

*---------------------------------------*
*	@AvaaIkkuna			*
*---------------------------------------*

AvaaIkkuna:
	move.l	intui(a4),a6
	move.l	a0,d2
	SETI	MUIA_Window_Open,TRUE
	move.l	d2,a0
	move.l	#MUIA_Window_Open,d0
	lea	lfWindowOpen(a4),a1
	jsr	_LVOGetAttr(a6)
	tst.l	lfWindowOpen(a4)
	beq	AppCreationError
	rts

*---------------------------------------*
*	@AllocVecPooled			*
*					*
*	INPUT				*
*					*
*	D0 - muistialueen koko		*
*					*
*	RESULT				*
*					*
*	D0 - uusi muistialue tai nolla	*
*	A0 - uusi muistialue		*
*---------------------------------------*

AllocVecPooled:
	move.l	exec(a4),a6
	addq.l	#4,d0
	move.l	d0,(a4)
	move.l	PerusLammikko(a4),a0
	jsr	_LVOAllocPooled(a6)
	tst.l	d0
	beq.b	.x
	move.l	d0,a0
	move.l	(a4),(a0)+
	move.l	a0,d0
.x	rts

*---------------------------------------*
*	@FreeVecPooled			*
*---------------------------------------*

FreeVecPooled:
	move.l	a1,d0
	beq.b	.x
	move.l	-(a1),d0
	move.l	PerusLammikko(a4),a0
	jmp	_LVOFreePooled(a6)
.x	rts

*---------------------------------------*
*	@CheckCheckMark			*
*---------------------------------------*

CheckCheckMark:
	move.l	intui(a4),a6
	move.l	#MUIA_Selected,d0
	move.l	a4,a1
	jmp	_LVOGetAttr(a6)

*-----------------------------------------------*
*	@UseConfig				*
*-----------------------------------------------*

UseConfig:
	bsr	UseConfig2
	bsr	LueKynät
	st	bfUpdatePens(a4)
	lea	PenSpec1(a4),a2
	lea	ConfigData(a4),a3

	moveq	#2,d0

.loop1	move.l	(a2)+,a0
	moveq	#7,d1
.loop2	move.l	(a0)+,(a3)+
	dbf	d1,.loop2
	dbf	d0,.loop1

	lea	EnvConfigName-t(a5),a1
	bsr	SaveConfig

	move.l	intui(a4),a6
	move.l	WI_PrefsWindow-t(a5),a0
	SETI	MUIA_Window_Open,FALSE

	move.l	MP_Kartta-t(a5),d7
	beq.b	.x
	TEE_METODI	D7,ReDrawMetodit
	TEE_METODI	App(a4),TallennaAsetukset_ENV_Metodit
.x	rts

*-----------------------------------------------*
*	@UserConfig2				*
*-----------------------------------------------*

UseConfig2:
	move.l	intui(a4),a6
	move.l	CH_Prefs_EmptyRecycled-t(a5),a0
	lea	lfEmptyRecycled(a4),a1
	jsr	_LVOGetAttr(a6)
	move.l	CH_Prefs_Serialize-t(a5),a0
	lea	lfSerialize(a4),a1
	jmp	_LVOGetAttr(a6)
