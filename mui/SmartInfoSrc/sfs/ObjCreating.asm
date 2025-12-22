*-----------------------------------------------*
*	@CreateObjects				*
*-----------------------------------------------*

CreateObjects:
	bsr	Tee_CustomClass
	beq.b	.x

	bsr	CreateMainWindow
	bsr	CreatePrefsWindow

	bsr	CreateMenus

	CREATEOBJECT	MUIC_Application,ApplicationTags
	move.l	d0,App(a4)
	beq.b	.x

	TEE_METODI	WI_Main-t(a5),WI_Main_Metodit
	TEE_METODI	WI_PrefsWindow-t(a5),WI_Prefs_Metodit

	TEE_METODI	LV_LaiteLista-t(a5),LV_LaiteLista_Metodit

;	TEE_METODI	BT_Suorita_SFScheck-t(a5),BT_Suorita_SFScheck_Metodit
	TEE_METODI	BT_Eheyt‰_SFS-t(a5),BT_Eheyt‰_SFS_Metodit

	TEE_METODI	BT_Prefs_Save-t(a5),BT_Prefs_Save_Metodit
	TEE_METODI	BT_Prefs_Use-t(a5),BT_Prefs_Use_Metodit
	TEE_METODI	BT_Prefs_Cancel-t(a5),BT_Prefs_Cancel_Metodit

	bsr	AdjustConfig

	moveq	#-1,d0
.x	rts

*-----------------------------------------------*
*	@LueKyn‰t				*
*-----------------------------------------------*

LueKyn‰t:
	move.l	intui(a4),a6
	move.l	PP_UsedBlock-t(a5),a0
	lea	PenSpec1(a4),a1
	bsr	.get_pen_spec
	move.l	PP_RemovedBlock-t(a5),a0
	lea	PenSpec2(a4),a1
	bsr	.get_pen_spec
	move.l	PP_NewBlock-t(a5),a0
	lea	PenSpec3(a4),a1

.get_pen_spec:
	move.l	#MUIA_Pendisplay_Spec,d0
	jmp	_LVOGetAttr(a6)

*-----------------------------------------------*
*       @AdjustConfig				*
*-----------------------------------------------*

AdjustConfig:
	tst.b	bfConfigExists(a4)
	bne.b	.ohita

	TEE_METODI	PP_UsedBlock-t(a5),PP_UsedBlock_Metodit
	TEE_METODI	PP_RemovedBlock-t(a5),PP_RemovedBlock_Metodit
	TEE_METODI	PP_NewBlock-t(a5),PP_NewBlock_Metodit
	bra	LueKyn‰t

.ohita	move.l	intui(a4),a6
	move.l	PP_UsedBlock-t(a5),a0
	SET2	#MUIA_Pendisplay_Spec,PenSpec1(a4)
	move.l	PP_RemovedBlock-t(a5),a0
	SET2	#MUIA_Pendisplay_Spec,PenSpec2(a4)
	move.l	PP_NewBlock-t(a5),a0
	SET2	#MUIA_Pendisplay_Spec,PenSpec3(a4)
	bra	UseConfig2

*-----------------------------------------------*
*	@CreateMenus				*
*-----------------------------------------------*

CreateMenus:
	move.l	muimaster(a4),a6
	move.l	sp,d1
	clr.l	-(sp)
	move.l	#MUIO_MenustripNM_CommandKeyCheck,-(sp)
	lea	MenuTags-t(a5),a0
	move.l	a0,-(sp)
	move.l	sp,a0
	move.l	d1,-(sp)
	move.l	#MUIO_MenustripNM,d0
	jsr	_LVOMUI_MakeObjectA(a6)
	move.l	d0,MN_Menustrip-t(a5)
	move.l	(sp)+,sp
	rts

*-----------------------------------------------*
*	@CreateMainWindow			*
*-----------------------------------------------*

CreateMainWindow:
	move.l	muimaster(a4),a6

		CREATEOBJECT	MUIC_NList,DeviceListTags
		move.l	d0,LV_LaiteLista_obj-t(a5)

		CREATEOBJECT	MUIC_NListview,DeviceListviewTags
		move.l	d0,LV_LaiteLista-t(a5)
		move.l	d0,MainWindowDefaultObject-t(a5)

;		TeeObj	MUIO_Button,MSG_PERFORM_SFSCHECK_GAD,BT_Suorita_SFScheck
		TeeObj	MUIO_Button,MSG_DEFRAGMENT_GAD,BT_Eheyt‰_SFS

	;	ikkunan toinen puolisko

		TeeLabel	MSG_START_OFFSET,NO_FLAGS,TX_StartOffset_obj
		TeeLabel	MSG_END_OFFSET,NO_FLAGS,TX_EndOffset_obj
		TeeLabel	MSG_DEVICE_API,NO_FLAGS,TX_DeviceAPI_obj
		TeeLabel	MSG_BYTES_PER_BLOCK,NO_FLAGS,TX_BytesPerBlock_obj
		TeeLabel	MSG_TOTAL_BLOCKS,NO_FLAGS,TX_TotalBlocks_obj
		TeeLabel	MSG_CACHE_ACCESSES,NO_FLAGS,TX_CacheAccesses_obj
		TeeLabel	MSG_CACHE_MISSES,NO_FLAGS,TX_CacheMisses_obj
		TeeLabel	MSG_READ_AHEAD_CACHE,NO_FLAGS,TX_ReadAheadCache_obj
		TeeLabel	MSG_DOS_BUFFERS,NO_FLAGS,TX_DOS_Buffers_obj
		TeeLabel	MSG_SFS_SETTINGS,NO_FLAGS,TX_SFS_Settings_obj

		CREATEOBJECT	MUIC_Text,TextTags
		move.l	d0,TX_StartOffset-t(a5)
		CREATEOBJECT	MUIC_Text,TextTags
		move.l	d0,TX_EndOffset-t(a5)
		CREATEOBJECT	MUIC_Text,TextTags
		move.l	d0,TX_DeviceAPI-t(a5)
		CREATEOBJECT	MUIC_Text,TextTags
		move.l	d0,TX_BytesPerBlock-t(a5)
		CREATEOBJECT	MUIC_Text,TextTags
		move.l	d0,TX_TotalBlocks-t(a5)
		CREATEOBJECT	MUIC_Text,TextTags
		move.l	d0,TX_CacheAccesses-t(a5)
		CREATEOBJECT	MUIC_Text,TextTags
		move.l	d0,TX_CacheMisses-t(a5)
		CREATEOBJECT	MUIC_Text,TextTags
		move.l	d0,TX_ReadAheadCache-t(a5)
		CREATEOBJECT	MUIC_Text,TextTags
		move.l	d0,TX_DOS_Buffers-t(a5)
		CREATEOBJECT	MUIC_Text,TextTags
		move.l	d0,TX_SFS_Settings-t(a5)

		CREATEOBJECT	MUIC_Text,TextTags
		move.l	d0,TX_GeneralInfo-t(a5)

	CREATEOBJECT	MUIC_Group,MainWindowGroup_B
	move.l	d0,MainWindowChild_B-t(a5)

	CREATEOBJECT	MUIC_Group,MainWindowGroup_A
	move.l	d0,MainWindowChild_A-t(a5)

	CREATEOBJECT	MUIC_Group,MainWindowGroup_C
	move.l	d0,MainWindowChild_C-t(a5)

	CREATEOBJECT	MUIC_Group,MainWindowRootGroup
	move.l	d0,MainWinRootGroup-t(a5)

	CREATEOBJECT	MUIC_Window,MainWinTags
	move.l	d0,WI_Main-t(a5)
	move.l	d0,tgMainWindow0-t(a5)
	rts

*-------------------------------------------------------*
*	@CreateDefragWindow				*
*-------------------------------------------------------*

CreateDefragWindow:
	move.l	intui(a4),a6

	tst.l	WI_DefragWindow(a4)
	bne	.valmis

		move.l	Defrag_mcc(a4),a0
		move.l	mcc_Class(a0),a0
		suba.l	a1,a1
		lea	MapTags-t(a5),a2
		jsr	_LVONewObjectA(a6)
		move.l	d0,MP_Kartta-t(a5)

	GETSTR	MSG_DEFRAGMENT_WIN
	move.l	d0,DefragWindowTitle-t(a5)

	move.l	muimaster(a4),a6

		TeeObj	MUIO_Button,MSG_PAUSE_DEFRAGMENT_GAD,BT_Pause_Defragment
		TeeObj	MUIO_Button,MSG_CONTINUE_DEFRAGMENT_GAD,BT_Continue_Defragment

	CREATEOBJECT	MUIC_Group,DefragWindowGroup_A
	move.l	d0,DefragWindowChild_A-t(a5)

		TeeObj	MUIO_Button,MSG_START_DEFRAGMENT_GAD,BT_Start_Defragment
		TeeObj	MUIO_Button,MSG_ABORT_DEFRAGMENT_GAD,BT_Abort_Defragment

		CREATEOBJECT	MUIC_Text,TimeTextTags
		move.l	d0,TX_Defrag_Time-t(a5)

		CREATEOBJECT	MUIC_Rectangle,NO_TAGS
		move.l	d0,RE_Rectangle-t(a5)

	CREATEOBJECT	MUIC_Group,DefragWindowGroup_B
	move.l	d0,DefragWindowChild_B-t(a5)

	CREATEOBJECT	MUIC_Group,DefragWindowGroup_C
	move.l	d0,DefragWindowChild_C-t(a5)

	CREATEOBJECT	MUIC_Group,DefragWindowGroup_D
	move.l	d0,DefragWindowChild_D-t(a5)

	CREATEOBJECT	MUIC_Group,DefragWindowGroup
	move.l	d0,DefragWindowChild-t(a5)

	CREATEOBJECT	MUIC_Window,DefragWindowTags
	move.l	d0,WI_DefragWindow(a4)
	beq.b	.x

	move.l	d0,UusiIkkuna-t(a5)

	TEE_METODI	App(a4),Lis‰‰IkkunaMetodit
	TEE_METODI	WI_DefragWindow(a4),WI_Defrag_Metodit

	TEE_METODI	BT_Start_Defragment-t(a5),BT_Start_Defrag_Metodit
	TEE_METODI	BT_Pause_Defragment-t(a5),BT_Switch_Defrag_Metodit
	TEE_METODI	BT_Continue_Defragment-t(a5),BT_Switch_Defrag_Metodit
	TEE_METODI	BT_Abort_Defragment-t(a5),BT_Abort_Defrag_Metodit

	moveq	#-1,d0
.x	rts

.valmis	move.l	DefragWindowChild-t(a5),a0
	SETI	MUIA_Group_ActivePage,MUIV_Group_ActivePage_First
	moveq	#-1,d0
	rts

*-----------------------------------------------*
*	@CreatePrefsWindow			*
*-----------------------------------------------*

CreatePrefsWindow:
	GETSTR	MSG_PREFS_WIN
	move.l	d0,PrefsWindowTitle-t(a5)
	GETSTR2	MSG_PREFS_DEFRAG_GUI_TITLE
	move.l	d0,PrefsTitle-t(a5)
	GETSTR2	MSG_PREFS_DEFRAG_OPTIONS_TITLE
	move.l	d0,PrefsOptionsTitle-t(a5)

	move.l	muimaster(a4),a6

		CREATEOBJECT	MUIC_Poppen,PopUpPenTags
		move.l	d0,PP_UsedBlock-t(a5)
		CREATEOBJECT	MUIC_Poppen,PopUpPenTags
		move.l	d0,PP_RemovedBlock-t(a5)
		CREATEOBJECT	MUIC_Poppen,PopUpPenTags
		move.l	d0,PP_NewBlock-t(a5)

		CREATEOBJECT	MUIC_BetterString,AddBuffersStringTags
		move.l	d0,STR_Prefs_AddBuffers-t(a5)

		TeeLabel	MSG_USED_BLOCK,NO_FLAGS,PP_UsedBlock_obj
		TeeLabel	MSG_REMOVED_BLOCK,NO_FLAGS,PP_RemovedBlock_obj
		TeeLabel	MSG_NEW_BLOCK,NO_FLAGS,PP_NewBlock_obj

		TeeLabel	MSG_PREFS_EMPTY_RECYCLED,MUIO_Label_LeftAligned,CH_Prefs_EmptyRecycled_obj
		TeeLabel	MSG_PREFS_SERIALIZE_DISK,MUIO_Label_LeftAligned,CH_Prefs_Serialize_obj
		TeeLabel	MSG_PREFS_ADDBUFFERS,NO_FLAGS,STR_Prefs_AddBuffers_obj

		TeeCheckmark	TRUE,CH_Prefs_EmptyRecycled
		TeeCheckmark	TRUE,CH_Prefs_Serialize

		CREATEOBJECT	MUIC_Rectangle,NO_TAGS
		move.l	d0,RE_Prefs1-t(a5)
		CREATEOBJECT	MUIC_Rectangle,HorizBarTags
		move.l	d0,RE_Prefs2-t(a5)

		TeeObj	MUIO_Button,MSG_SAVE_PREFS_GAD,BT_Prefs_Save
		TeeObj	MUIO_Button,MSG_USE_PREFS_GAD,BT_Prefs_Use
		TeeObj	MUIO_Button,MSG_CANCEL_PREFS_GAD,BT_Prefs_Cancel

	CREATEOBJECT	MUIC_Group,PrefsWindowGroup_A
	move.l	d0,PrefsWindowChild_A-t(a5)

	CREATEOBJECT	MUIC_Group,PrefsWindowGroup_B1
	move.l	d0,PrefsWindowChild_B1-t(a5)

	CREATEOBJECT	MUIC_Group,PrefsWindowGroup_B2
	move.l	d0,PrefsWindowChild_B2-t(a5)

	CREATEOBJECT	MUIC_Group,PrefsWindowGroup_B3
	move.l	d0,PrefsWindowChild_B3-t(a5)

	CREATEOBJECT	MUIC_Group,PrefsWindowGroup_B
	move.l	d0,PrefsWindowChild_B-t(a5)

	CREATEOBJECT	MUIC_Group,PrefsWindowGroup_C
	move.l	d0,PrefsWindowChild_C-t(a5)

	CREATEOBJECT	MUIC_Group,PrefsWindowGroup
	move.l	d0,PrefsWindowChild-t(a5)

	CREATEOBJECT	MUIC_Window,PrefsWindowTags
	move.l	d0,WI_PrefsWindow-t(a5)
	rts
