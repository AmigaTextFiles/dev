*-----------------------------------------------*
*	@AktiivinenLaite			*
*-----------------------------------------------*

AktiivinenLaite:
	ALOITA
	TEE_METODI	LV_LaiteLista-t(a5),GetActiveEntry
	move.l	(a4),d0
	beq.b	.x

	move.l	d0,a3
	move.l	d0,ActiveEntry(a4)
	bsr	HaeLaiteTiedot
	bsr	ResolveVolumeData
	bsr	PäivitäLaiteTekstit

.x	LOPETA
	rts

*-----------------------------------------------*
*	@PäivitäLaiteTekstit			*
*-----------------------------------------------*

PäivitäLaiteTekstit:
	lea	ll_CreationDate(a3),a0
	lea	ll_CreationTime(a3),a1
	move.l	ll_Version(a3),d0
	move.l	a0,(a4)
	move.l	a1,4(a4)
	move.l	d0,8(a4)
	move.l	GeneralInfoFormat2(a4),a0
	tst.l	d0
	beq.b	.ok
	move.l	GeneralInfoFormat3(a4),a0
	cmp.l	#$10050,d0
	beq.b	.ok
	move.l	GeneralInfoFormat(a4),a0
.ok	bsr	.do_format
	move.l	TX_GeneralInfo-t(a5),a0
	bsr	.set_text

	move.l	sfs_start_byteh-t(a5),(a4)
	move.l	sfs_start_bytel-t(a5),4(a4)
	move.l	StartEndOffsetText(a4),a0
	bsr	.do_format
	move.l	TX_StartOffset-t(a5),a0
	bsr	.set_text

	move.l	sfs_end_byteh-t(a5),(a4)
	move.l	sfs_end_bytel-t(a5),4(a4)
	move.l	StartEndOffsetText(a4),a0
	bsr	.do_format
	move.l	TX_EndOffset-t(a5),a0
	bsr	.set_text

	move.l	sfs_block_size-t(a5),(a4)
	bsr	.do_number_format
	move.l	TX_BytesPerBlock-t(a5),a0
	bsr	.set_text

	move.l	sfs_total_blocks-t(a5),(a4)
	move.l	sfs_total_blocks-t(a5),ll_TotalBlocks(a3)
	bsr	.do_number_format
	move.l	TX_TotalBlocks-t(a5),a0
	bsr	.set_text

	move.l	sfs_cache_accesses-t(a5),(a4)
	bsr	.do_number_format
	move.l	TX_CacheAccesses-t(a5),a0
	bsr	.set_text

	move.l	sfs_cache_buffers-t(a5),(a4)
	bsr	.do_number_format
	move.l	TX_DOS_Buffers-t(a5),a0
	bsr	.set_text

	; cache misses

	clr.l	4(a4)
	move.l	sfs_cache_misses-t(a5),(a4)
	beq.b	.jatka
	move.l	(a4),d0
	move.l	sfs_cache_accesses-t(a5),d2
	mulu.l	#10000,d0
	divu.l	d2,d0				; ((misses*10000)/accesses)/100
	divu.w	#100,d0
	swap	d0
	move.l	d0,4(a4)
.jatka	lea	CacheMissesFormat-t(a5),a0
	bsr	.do_format
	move.l	TX_CacheMisses-t(a5),a0
	bsr	.set_text

	move.l	sfs_cache_lines-t(a5),(a4)
	move.l	sfs_cache_readaheadsize-t(a5),4(a4)
	move.l	CopyBackText(a4),8(a4)
	tst.l	sfs_cache_mode-t(a5)
	bne.b	.jatka2
	move.l	WriteThroughText(a4),8(a4)
.jatka2	move.l	CacheSizeText(a4),a0
	bsr	.do_format
	move.l	TX_ReadAheadCache-t(a5),a0
	bsr	.set_text

	move.l	sfs_device_api-t(a5),d0
	move.l	NSDText(a4),d3
	subq.l	#1,d0
	beq.b	.valmis
	move.l	TD64Text(a4),d3
	subq.l	#1,d0
	beq.b	.valmis
	move.l	SCSIDirectText(a4),d3
	subq.l	#1,d0
	beq.b	.valmis
	move.l	StandardText(a4),d3
.valmis	move.l	TX_DeviceAPI-t(a5),a0
	SET2	#MUIA_Text_Contents,D3

	move.l	NoneText(a4),(a4)
	tst.l	sfs_is_casesensitive-t(a5)
	beq.b	.jatka3
	move.l	CaseSensitiveText(a4),(a4)
	tst.l	sfs_has_recycled-t(a5)
	beq.b	.simple_case
	move.l	RecycledText(a4),4(a4)
	lea	DoubleStringFormat-t(a5),a0
	bsr	.do_format
	move.l	TX_SFS_Settings-t(a5),a0
	bra	.set_text

.jatka3	tst.l	sfs_has_recycled-t(a5)
	beq.b	.simple_case
	move.l	RecycledText(a4),(a4)
.simple_case:
	move.l	TX_SFS_Settings-t(a5),a0
	SET2	#MUIA_Text_Contents,(A4)
	rts

.do_number_format:
	lea	NumberFormat-t(a5),a0
.do_format:
	move.l	a3,-(sp)
	move.l	exec(a4),a6
	move.l	a4,a1
	lea	putchar(pc),a2
	move.l	TextBuffer(a4),a3
	jsr	_LVORawDoFmt(a6)
	move.l	(sp)+,a3
	rts

.set_text:
	move.l	intui(a4),a6
	SET2	#MUIA_Text_Contents,TextBuffer(a4)
	rts

*-----------------------------------------------*
*	@HaeLaiteTiedot				*
*-----------------------------------------------*

HaeLaiteTiedot:
	clr.l	sfs_cache_accesses-t(a5)
	clr.l	sfs_cache_misses-t(a5)
	clr.l	sfs_start_byteh-t(a5)
	clr.l	sfs_start_bytel-t(a5)
	clr.l	sfs_end_byteh-t(a5)
	clr.l	sfs_end_bytel-t(a5)
	clr.l	sfs_device_api-t(a5)
	clr.l	sfs_block_size-t(a5)
	clr.l	sfs_total_blocks-t(a5)
	clr.l	sfs_rootblock-t(a5)
	clr.l	sfs_rootblock_objectnodes-t(a5)
	clr.l	sfs_rootblock_extents-t(a5)
	clr.l	sfs_first_bitmap_block-t(a5)
	clr.l	sfs_first_adminspace-t(a5)
	clr.l	sfs_cache_lines-t(a5)
	clr.l	sfs_cache_readaheadsize-t(a5)
	clr.l	sfs_cache_mode-t(a5)
	clr.l	sfs_cache_buffers-t(a5)
	clr.l	sfs_is_casesensitive-t(a5)
	clr.l	sfs_has_recycled-t(a5)
HaeLaiteTiedot2:
	clr.l	sfs_version-t(a5)
	lea	SFSQueryTags-t(a5),a1
	move.l	dos(a4),a6
	moveq	#0,d4
	move.l	ll_MsgPort(a3),d1
	move.l	#ACTION_SFS_QUERY,d2
	move.l	a1,d3
	move.l	d4,d5		; ->0
	move.l	d4,d6		; ->0
	move.l	d4,d7		; ->0
	jmp	_LVODoPkt(a6)
