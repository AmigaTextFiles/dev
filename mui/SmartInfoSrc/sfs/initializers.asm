*-----------------------------------------------*
*	@Localize				*
*-----------------------------------------------*

Localize:
	move.l	localebase(a4),a6
	MENUSTR	PROJECT,MT_Project
	MENUSTR	PROJECT_SETTINGS,MI_Asetukset
	MENUSTR	PROJECT_MUI_SETTINGS,MI_MUI_Asetukset
	MENUSTR	PROJECT_ABOUT,MI_Tietoja
	MENUSTR	PROJECT_ABOUT_MUI,MI_TietojaMUI
	MENUSTR	PROJECT_QUIT,MI_Quit

	GETSTR2	MSG_GENERAL_INFO_FORMAT
	move.l	d0,GeneralInfoFormat(a4)
	GETSTR2	MSG_GENERAL_INFO_FORMAT2
	move.l	d0,GeneralInfoFormat2(a4)
	GETSTR2	MSG_GENERAL_INFO_FORMAT3
	move.l	d0,GeneralInfoFormat3(a4)
	GETSTR2	MSG_START_END_OFFSET_FORMAT
	move.l	d0,StartEndOffsetText(a4)
	GETSTR2	MSG_CACHE_SIZE_FORMAT
	move.l	d0,CacheSizeText(a4)
	GETSTR2	MSG_COPYBACK
	move.l	d0,CopyBackText(a4)
	GETSTR2	MSG_WRITE_THROUGH
	move.l	d0,WriteThroughText(a4)
	GETSTR2	MSG_NONE
	move.l	d0,NoneText(a4)
	GETSTR2 MSG_CASE_SENSITIVE
	move.l	d0,CaseSensitiveText(a4)
	GETSTR2	MSG_RECYCLED
	move.l	d0,RecycledText(a4)
	GETSTR2	MSG_NSD
	move.l	d0,NSDText(a4)
	GETSTR2	MSG_TD64
	move.l	d0,TD64Text(a4)
	GETSTR2	MSG_SCSI_DIRECT
	move.l	d0,SCSIDirectText(a4)
	GETSTR2	MSG_STANDARD
	move.l	d0,StandardText(a4)
	rts

*-----------------------------------------------*
*	@AvaaKirjastot				*
*-----------------------------------------------*

AvaaKirjastot:
	lea	libnametable-t(a5),a3
	lea	Kirjastot(a4),a2
.loop1	move.l	(a3)+,d0
	beq.b	.x
	move.l	d0,a1
	moveq	#0,d0
	move.b	(a1)+,d0
	move.l	a1,(a4)
	move.w	d0,4(a4)
	jsr	_LVOOpenLibrary(a6)
	move.l	d0,(a2)+
	bne.b	.loop1
	move.l	dos(a4),a6
	lea	t_ERR_NO_LIBRARY-t(a5),a1
	move.l	a1,d1
	move.l	a4,d2
	jmp	_LVOVPrintf(a6)
.x	rts

*-----------------------------------------------*
*	@SuljeKirjastot				*
*-----------------------------------------------*

SuljeKirjastot:
	move.l	exec(a4),a6
	lea	Kirjastot(a4),a2
	moveq	#kirjastoja,d2
.loop1	move.l	(a2)+,a1
	jsr	_LVOCloseLibrary(a6)
	dbf	d2,.loop1
	rts

*-----------------------------------------------*
*	@DoPostInit				*
*-----------------------------------------------*

DoPostInit:
	bsr	GetSomeVolumes

	move.l	intui(a4),a6
	move.l	LV_LaiteLista-t(a5),a0
	SETI	MUIA_NList_Active,0

	move.l	#MUIA_Application_Base,d0
	move.l	App(a4),a0
	move.l	a4,a1
	jsr	_LVOGetAttr(a6)
	move.l	exec(a4),a6
	lea	PutkiFormaatti-t(a5),a0
	move.l	a4,a1
	lea	putchar,a2
	lea	PutkiTiedosto(a4),a3
	jmp	_LVORawDoFmt(a6)

*-----------------------------------------------*
*	@Initialize				*
*-----------------------------------------------*

Initialize:
	bsr	CreatePackets
	beq.b	.x
	bsr	AvaaTimerDevice
	beq.b	.x
	bsr	TeePoolot
	beq.b	.x
	bsr	VaraaStepPuskurit
	beq.b	.x
	move.l	localebase(a4),a6		; avataan katalogi
	suba.l	a0,a0
	lea	catalogname-t(a5),a1
	lea	localetags-t(a5),a2
	jsr	_LVOOpenCatalogA(a6)
	move.l	d0,catalog(a4)
	suba.l	a0,a0
	jsr	_LVOOpenLocale(a6)
	move.l	d0,SystemLocale(a4)
	bsr	Localize
	lea	16(a4),a0
	move.l	a0,TextBuffer(a4)
	move.b	#DTF_SUBST,MyDateTime+dat_Flags(a4)
	moveq	#-1,d0
.x	rts

*-----------------------------------------------*
*	@UnInitialize				*
*-----------------------------------------------*

UnInitialize:
	bsr	FreeBitMap
	bsr	DeletePackets
	bsr	SuljeTimerDevice
	bsr	TuhoaPoolot
	bsr	VapautaStepPuskurit
	move.l	localebase(a4),a6
	move.l	catalog(a4),a0
	jsr     _LVOCloseCatalog(a6)
	move.l	SystemLocale(a4),a0
	jmp	_LVOCloseLocale(a6)

*-----------------------------------------------*
*	@CreatePackets				*
*-----------------------------------------------*

CreatePackets:
	move.l	exec(a4),a6
	jsr	_LVOCreateMsgPort(a6)
	move.l	d0,MsgPort(a4)
	beq.b	.x
	move.l	d0,a0
	moveq	#0,d1
	moveq	#0,d2
	move.b	MP_SIGBIT(a0),d1
	bset.l	d1,d2
	move.l	dos(a4),a6
	move.l	d2,PacketMask(a4)

	move.l	#DOS_STDPKT,d1
	move.l	#0,d2
	jsr	_LVOAllocDosObject(a6)
	move.l	d0,packet0(a4)
	beq.b	.x
	move.l	#DOS_STDPKT,d1
	move.l	#0,d2
	jsr	_LVOAllocDosObject(a6)
	move.l	d0,packet1(a4)
.x	rts

*-----------------------------------------------*
*	@DeletePackets				*
*-----------------------------------------------*

DeletePackets:
	move.l	exec(a4),a6
	move.l	MsgPort(a4),a0
	jsr	_LVODeleteMsgPort(a6)
	move.l	dos(a4),a6
	move.l	packet0(a4),d2
	move.l	#DOS_STDPKT,d1
	jsr	_LVOFreeDosObject(a6)
	move.l	packet1(a4),d2
	move.l	#DOS_STDPKT,d1
	jmp	_LVOFreeDosObject(a6)

*-----------------------------------------------*
*	@VaraaStepPuskurit			*
*-----------------------------------------------*

VaraaStepPuskurit:
	move.l	#step_bufsize*4,d0
	move.l	#MEMF_PUBLIC,d1
	jsr	_LVOAllocVec(a6)
	move.l	d0,data0(a4)
	beq.b	.x
	move.l	#step_bufsize*4,d0
	move.l	#MEMF_PUBLIC,d1
	jsr	_LVOAllocVec(a6)
	move.l	d0,data1(a4)
.x	rts

*-----------------------------------------------*
*	@VapautaStepPuskurit			*
*-----------------------------------------------*

VapautaStepPuskurit:
	move.l	data0(a4),a1
	jsr	_LVOFreeVec(a6)
	move.l	data1(a4),a1
	jmp	_LVOFreeVec(a6)

*---------------------------------------*
*	@AvaaTimerDevice		*
*---------------------------------------*

AvaaTimerDevice:
	move.l	exec(a4),a6
	jsr	_LVOCreateMsgPort(a6)
	move.l	d0,timerport(a4)
	beq.b	.x
	move.l	d0,a0
	moveq	#0,d1
	moveq	#0,d2
	move.b	MP_SIGBIT(a0),d1
	bset.l	d1,d2
	move.l	d2,TimerMask(a4)
	or.l	PacketMask(a4),d2
	move.l	#IOTV_SIZE,d0
	move.l	d2,SignalMask(a4)
	jsr	_LVOCreateIORequest(a6)
	move.l	d0,timer_io(a4)
	beq.b	.x
	lea	timername-t(a5),a0
	move.l	d0,a1
	clr.l	IOTV_TIME+TV_SECS(a1)
	clr.l	IOTV_TIME+TV_MICRO(a1)
	move.l	d0,a2
	moveq	#UNIT_VBLANK,d0
	moveq	#0,d1
	jsr	_LVOOpenDevice(a6)
	tst.l	d0
	bne.b	.virhe
	move.l	IO_DEVICE(a2),TimerBase(a4)
	rts
.virhe	moveq	#0,d0
.x	rts

*---------------------------------------*
*	@SuljeTimerDevice		*
*---------------------------------------*

SuljeTimerDevice:
	move.l	exec(a4),a6
	tst.l	TimerBase(a4)
	beq.b	.skip1
	move.l	timer_io(a4),a1
	jsr	_LVOCloseDevice(a6)
.skip1	move.l	timer_io(a4),a0
	jsr	_LVODeleteIORequest(a6)
	move.l	timerport(a4),a0
	jmp	_LVODeleteMsgPort(a6)

*-----------------------------------------------*
*	@TeePoolot				*
*-----------------------------------------------*

TeePoolot:
	move.l	exec(a4),a6
	move.l	#MEMF_ANY!MEMF_CLEAR,d0
	move.l	#2048,d1
	move.l	#Laite_SIZEOF,d2
	jsr	_LVOCreatePool(a6)
	move.l	d0,PerusLammikko(a4)
	rts

*-----------------------------------------------*
*	@TuhoaPoolot				*
*-----------------------------------------------*

TuhoaPoolot:
	move.l	exec(a4),a6
	move.l	PerusLammikko(a4),a0
	jmp	_LVODeletePool(a6)
