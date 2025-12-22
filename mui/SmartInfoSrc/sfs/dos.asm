*-----------------------------------------------*
*	@GetSomeVolumes				*
*-----------------------------------------------*

GetSomeVolumes:
	lea	LaiteLista(a4),a3
	move.l	dos(a4),a6
	move.l	#LDF_DEVICES!LDF_READ,d1
	jsr	_LVOLockDosList(a6)
	move.l	d0,d7

.loop1	move.l	dos(a4),a6
	move.l	d7,d1
	move.l	#LDF_DEVICES!LDF_READ,d2
	jsr	_LVONextDosEntry(a6)
	move.l	d0,a2
	move.l	d0,d7
	beq.b	.valmis

	tst.l	dol_Task(a2)
	beq.b	.loop1

	move.l	dol_Name(a2),d1
	lsl.l	#2,d1
	jsr	_LVOIsFileSystem(a6)
	tst.l	d0
	beq.b	.loop1

	move.l	#Laite_SIZEOF,d0
	bsr	AllocVecPooled
	move.l	d0,(a3)
	beq.b	.loop1
	move.l	d0,a3
	move.l	dol_Task(a2),ll_MsgPort(a3)
	move.l	dol_Name(a2),a0
	lea	ll_DeviceName(a3),a1
	bsr	copy_name

	move.b	#':',(a1)+
	clr.b	(a1)
	bra.b	.loop1

.valmis	move.l	#LDF_DEVICES!LDF_READ,d1
	jsr	_LVOUnLockDosList(a6)

	move.l	task(a4),a0
	move.l	pr_WindowPtr(a0),d6
	move.l	#-1,pr_WindowPtr(a0)

	lea	LaiteLista(a4),a3
.loop3	move.l	(a3),d0
	beq.b	.jatka
	move.l	d0,a3

	bsr	HaeLaiteTiedot2
	tst.l	d0
	beq.b	.loop3

	move.l	a3,AddSorted-t(a5)
	move.l	sfs_version-t(a5),ll_Version(a3)

	bsr	ResolveVolumeData
	beq.b	.loop3

	addq.l	#1,LaiteLkm(a4)
	TEE_METODI	LV_LaiteLista-t(a5),AddEntrySorted
	bra.b	.loop3

.jatka	move.l	task(a4),a0
	move.l	d6,pr_WindowPtr(a0)
	rts

copy_name:
	add.l	a0,a0
	moveq	#0,d0
	add.l	a0,a0
	move.b	(a0)+,d0
	beq.b	.x
	subq.l	#1,d0
.loop2	move.b	(a0)+,(a1)+
	dbf	d0,.loop2
.x	rts

*-----------------------------------------------*
*	@ResolveVolumeData			*
*-----------------------------------------------*

ResolveVolumeData:
	lea	ll_DeviceName(a3),a1
	move.l	#ACCESS_READ,d2
	move.l	a1,d1
	jsr	_LVOLock(a6)
	move.l	d0,d7
	beq.b	.x

	lea	MyInfoData(a4),a0
	move.l	d0,d1
	move.l	a0,d2
	jsr	_LVOInfo(a6)

	move.l	MyInfoData+id_VolumeNode(a4),a2
	lea	MyDateTime(a4),a1
	add.l	a2,a2
	lea	ll_CreationDate(a3),a0
	add.l	a2,a2
	move.l	a0,dat_StrDate(a1)
	lea	ll_CreationTime(a3),a0
	move.l	a0,dat_StrTime(a1)

	move.l	dol_VolumeDate+ds_Days(a2),ds_Days(a1)
	move.l	dol_VolumeDate+ds_Minute(a2),ds_Minute(a1)
	move.l	dol_VolumeDate+ds_Tick(a2),ds_Tick(a1)
	move.l	a1,d1
	jsr	_LVODateToStr(a6)

	lea	ll_VolumeName(a3),a1
	move.l	dol_Name(a2),a0
	bsr	copy_name
	clr.b	(a1)

	move.l	d7,d1
	jsr	_LVOUnLock(a6)

	move.l	a3,d3
	move.l	MyInfoData+id_NumBlocksUsed(a4),d0
	mulu.l	#100,d0
	lea	putchar(pc),a2
	divu.l	MyInfoData+id_NumBlocks(a4),d0
	move.l	exec(a4),a6
	move.w	d0,(a4)
	lea	DiskUsageFormat-t(a5),a0
	move.l	a4,a1
	lea	ll_DiskUsage(a3),a3
	jsr	_LVORawDoFmt(a6)
	move.l	d3,a3

	moveq	#-1,d0
.x	rts

*-----------------------------------------------*
*	@LoadConfig				*
*-----------------------------------------------*

LoadConfig:
	clr.b	bfConfigExists(a4)
	lea	EnvConfigName-t(a5),a1
	bsr	GetConfig
	bne.b	.x
	lea	EnvarcConfigName-t(a5),a1
	bra	GetConfig
.x	rts

*-----------------------------------------------*
*	@GetConfig				*
*-----------------------------------------------*

GetConfig:
	move.l	dos(a4),a6
	move.l	a1,d1
	move.l	#MODE_OLDFILE,d2
	jsr	_LVOOpen(a6)
	move.l	d0,d7
	beq.b	.x
	move.l	d0,d1
	lea	ConfigData(a4),a2
	move.l	#3*32,d3
	move.l	a2,d2
	jsr	_LVORead(a6)
	move.l	d7,d1
	jsr	_LVOClose(a6)

	lea	PenSpec1(a4),a3
	moveq	#3,d0
.loop	move.l	a2,(a3)+
	lea	32(a2),a2
	dbf	d0,.loop
	st	bfConfigExists(a4)
	moveq	#-1,d0
.x	rts

*-----------------------------------------------*
*	@SaveConfig				*
*-----------------------------------------------*

SaveConfig:
	move.l	dos(a4),a6
	move.l	a1,d1
	move.l	#MODE_NEWFILE,d2
	jsr	_LVOOpen(a6)
	move.l	d0,d7
	beq.b	.x
	lea	ConfigData(a4),a2
	move.l	d0,d1
	move.l	a2,d2
	move.l	#3*32,d3
	jsr	_LVOWrite(a6)
	move.l	d7,d1
	jmp	_LVOClose(a6)
.x	rts

*-----------------------------------------------*
*	@Tyhjenn‰Roskakori			*
*-----------------------------------------------*

Tyhjenn‰Roskakori:
	tst.l	lfEmptyRecycled(a4)
	beq.b	.x
	move.l	#ACTION_SFS_LOCATE_OBJECT,d2
	move.l	#RECYCLEDNODE,d3
	move.l	#SHARED_LOCK,d4
	moveq	#0,d5
	bsr	L‰het‰Paketti
	beq.b	.x				; (hakemistoa ei ole)
	lsr.l	#2,d0
	move.l	d0,d7
	bsr	Tyhjenn‰Hakemisto
	move.l	d7,d1
	jmp	_LVOUnLock(a6)
.x	rts

*-----------------------------------------------*
*	@UpdateVolumeDate			*
*-----------------------------------------------*

UpdateVolumeDate:
	tst.l	lfSerialize(a4)
	beq.b	.x
	move.l	DefragEntry(a4),a3
	move.l	#ACTION_SERIALIZE_DISK,d2
	bra	L‰het‰Paketti
.x	rts

*-----------------------------------------------*
*	@L‰het‰Paketti				*
*-----------------------------------------------*

L‰het‰Paketti:
	move.l	dos(a4),a6
	move.l	ll_MsgPort(a3),d1
	moveq	#0,d6
	moveq	#0,d7
	jsr	_LVODoPkt(a6)
	tst.l	d0
	rts

*-----------------------------------------------*
*	@Tyhjenn‰Hakemisto			*
*						*
*	D7 - tyhjennett‰v‰ hakemisto (lock)	*
*-----------------------------------------------*

Tyhjenn‰Hakemisto:
	move.l	d7,d1
	jsr	_LVOCurrentDir(a6)
	move.l	d0,d6
	moveq	#0,d5
	move.l	d7,d1
	move.l	a4,d2
	jsr	_LVOExamine(a6)
	tst.l	d0
	beq.b	.end
	lea	fib_FileName(a4),a2

.loop1	move.l	d7,d1
	jsr	_LVOExNext(a6)
	tst.l	d0
	beq.b	.end			; hakemisto tyhj‰
	move.l	a2,d1
	jsr	_LVODeleteFile(a6)
	addq.l	#1,d5
	bra.b	.loop1

.end	move.l	d6,d1
	jmp	_LVOCurrentDir(a6)

*-----------------------------------------------*
*	@AddBuffers				*
*-----------------------------------------------*

AddBuffers:
	lea	ll_DeviceName(a3),a0
	lea	ll_VolumeName(a3),a1
	move.l	a0,DeviceName(a4)
	move.l	a1,VolumeName(a4)

	move.l	intui(a4),a6
	move.l	STR_Prefs_AddBuffers-t(a5),a0
	lea	DAddBufs(a4),a1
	move.l	#MUIA_String_Integer,d0
	jsr	_LVOGetAttr(a6)

	move.l	DAddBufs(a4),d2
	beq.b	.x
	move.l	dos(a4),a6
	move.l	DeviceName(a4),d1
	jsr	_LVOAddBuffers(a6)
	tst.l	d0
	bne.b	.x
	clr.l	DAddBufs(a4)
.x	rts

*-----------------------------------------------*
*	@RemBuffers				*
*-----------------------------------------------*

RemBuffers:
	move.l	DAddBufs(a4),d2
	beq.b	.x
	clr.l	DAddBufs(a4)
	neg.l	d2
	move.l	dos(a4),a6
	move.l	DeviceName(a4),d1
	jmp	_LVOAddBuffers(a6)
.x	rts

*-----------------------------------------------*
*	@LockDevice				*
*-----------------------------------------------*

LockDevice:
	move.l	dos(a4),a6
	move.l	#100,d1
	jsr	_LVODelay(a6)
	move.l	SFSport(a4),d1
	move.l	#ACTION_INHIBIT,d2
	move.l	#DOSTRUE,d3		; Inhibit
	jsr	_LVODoPkt(a6)
	tst.l	d0
	beq.b	.virhe
	st	bfInhibited(a4)
	rts

.virhe	lea	ll_VolumeName(a3),a2
	bsr	GetErrorString
	move.l	a2,(a4)
	GETSTR	MSG_CANT_LOCK
	move.l	d0,a2
	bsr	InfoRequester
	bra	EnableStartDefrag

*-----------------------------------------------*
*	@UnLockDevice				*
*-----------------------------------------------*

UnLockDevice:
	tst.b	bfInhibited(a4)
	beq.b	.x
	clr.b	bfInhibited(a4)
	move.l	dos(a4),a6
	move.l	SFSport_Abort(a4),d1
	move.l	#ACTION_INHIBIT,d2
	moveq	#DOSFALSE,d3			; UnInhibit
	jmp	_LVODoPkt(a6)
.x	rts
