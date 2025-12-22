	MC68020

*	Project started ??-May-1999

	incdir	"hd2:ohjelmointi/lähdekoodit/sfs/"

	include	"lvos.i"
	include	"lvo/mui_lib.i"
	include	"devices/timer.i"
	include	"dos/datetime.i"
	include	"dos/dos.i"
	include	"dos/dosasl.i"
	include	"dos/dosextens.i"
	include	"dos/dostags.i"
	include	"exec/execbase.i"
	include	"exec/memory.i"
	include	"fs/nodes.i"
	include	"fs/query.i"
	include	"fs/packets.i"
	include	"libraries/gadtools.i"
	include	"libraries/locale.i"
	include	"libraries/mui.i"
	include	"utility/hooks.i"
	include	"workbench/workbench.i"

	include	"MUI/NListview_mcc.i"

	include	"macros.i"

CH_Prefs_EmptyRecycled_ID	EQU	'CHK0'
CH_Prefs_Serialize_ID		EQU	'CHK1'

CATCOMP_NUMBERS	SET	1
CATCOMP_STRINGS	SET	1

MUIM_Oma_ReDraw	EQU	$7CF70000
MUIM_Oma_Render	EQU	$7CF70001

step_bufsize	EQU	201

MIN_VERSION	EQU     1
MIN_REVISION	EQU	80

	STRUCTURE Laite,0
	APTR	ll_Seuraava
	APTR	ll_MsgPort
	ULONG	ll_TotalBlocks
	ULONG	ll_Version
	STRUCT	ll_DeviceName,16
	STRUCT	ll_VolumeName,256
	STRUCT	ll_CreationDate,16
	STRUCT	ll_CreationTime,16
	STRUCT	ll_DiskUsage,8
	LABEL	Laite_SIZEOF

	STRUCTURE Muuttujat,0
	STRUCT	buffer,260
	STRUCT	VersionText,16
	STRUCT	TimeText,16
	STRUCT	StartTime,TV_SIZE
	STRUCT	ElapsedTime,TV_SIZE
	STRUCT	MyInfoData,id_SIZEOF
	STRUCT	MyDateTime,dat_SIZEOF
	STRUCT	PutkiTiedosto,32
	STRUCT	LaiteLista,4
	APTR	cliwin
	APTR	exec
	APTR	task
	APTR	catalog
	APTR	App
	APTR	PerusLammikko
	APTR	SystemLocale
	APTR	ActiveEntry
	APTR	timerport
	APTR	timer_io
	APTR	TimerBase

	;	Defrag
	APTR	DefragEntry		; <- ActiveEntry
	APTR	MsgPort
	APTR	SFSport
	APTR	SFSport_Abort

	APTR	TextBuffer		; b+16
	APTR	GeneralInfoFormat
	APTR	GeneralInfoFormat2
	APTR	GeneralInfoFormat3
	APTR	StartEndOffsetText
	APTR	CacheSizeText
	APTR	CopyBackText
	APTR	WriteThroughText
	APTR	NoneText
	APTR	CaseSensitiveText
	APTR	RecycledText
	APTR	NSDText
	APTR	TD64Text
	APTR	SCSIDirectText
	APTR	StandardText

	APTR	Defrag_mcc
	LABEL	WI_Defrag
	APTR	WI_DefragWindow

	APTR	DeviceName
	APTR	VolumeName
	ULONG	DAddBufs

	ULONG	PacketError		; dp_Res2

	APTR	PenSpec1		; 32 tavua
	APTR	PenSpec2
	APTR	PenSpec3

	LABEL	MyPen
	ULONG	UsedPen
	ULONG	RemovedPen
	ULONG	NewPen

	APTR	CurrPkt
	APTR	CurrData
	APTR	packet0
	APTR	packet1
	APTR	data0
	APTR	data1
	APTR	DefragBitMap
	APTR	RenderData

	ULONG	LaiteLkm
	ULONG	SignalMask
	ULONG	PacketMask
	ULONG	TimerMask

	APTR	RenderInfo
	APTR	MUI_RastPort

	ULONG	lastread
	ULONG	lastwritten
	ULONG	lastblocks

	ULONG	MUI_TotalBlocks
	ULONG	MUI_LeftOffset
	ULONG	MUI_TopOffset
	ULONG	MUI_Width
	ULONG	MUI_Height

	ULONG	ppu
	ULONG	bpu
	ULONG	uw
	ULONG	uh
	ULONG	uhor
	ULONG	uver
	ULONG	endline
	ULONG	btotal

		ULONG	lfWindowOpen
		ULONG	lfEmptyRecycled
		ULONG	lfSerialize

		UBYTE	bfStopDefrag	; 0 = epätosi
		UBYTE	bfQuitDefrag	; 0 = epätosi
		UBYTE	bfTimerActive	; 0 = timer unactive
		UBYTE	bfBitMapExists	; 0 = ei ole

		UBYTE	bfUpdatePens
		UBYTE	bfConfigExists	; 0 = ei config-tiedostoa
		UBYTE	bfInhibited	; 0 = epätosi
		STRUCT	UNUSED_BYTES,1

		LABEL	Kirjastot
		APTR	muimaster
		APTR	localebase
		APTR	intui
		APTR	gfxbase

		APTR	dos		; jää viimeiseksi
		LABEL	KirjastotLoppuu

	STRUCT	ConfigData,3*32

	LABEL	Muuttujat_SIZE

kirjastoja	EQU	(KirjastotLoppuu-Kirjastot)/4-1


alku	move.l	4.w,a6
	clr.l	-(sp)
	sub.l	a1,a1
	jsr	_LVOFindTask(a6)
	move.l	d0,a2
	tst.l	pr_CLI(a2)
	bne.b	.cli
	lea	pr_MsgPort(a2),a0
	jsr	_LVOWaitPort(a6)
	lea	pr_MsgPort(a2),a0
	jsr	_LVOGetMsg(a6)
	move.l	d0,(sp)

.cli	lea	t,a5
	move.l	(a5),a4

	move.l	a2,task(a4)
	move.l	a6,exec(a4)

	lea	dosname-t(a5),a1
	moveq	#39,d0
	jsr	_LVOOpenLibrary(a6)
	move.l	d0,dos(a4)
	beq	xt_Loppu

	bsr	AvaaKirjastot
	bne	xt_SuljeKirjastot

	bsr	Initialize
	beq	xt_UnInitialize

	bsr	LoadConfig

	move.l	exec(a4),a6
	move.w	AttnFlags(a6),d0
	btst	#AFF_68010,d0
	bne.b	.68020
	GETSTR	MSG_020_REQUIRED
	move.l	d0,a2
	GETSTR2	MSG_INTUI_OK_GAD
	move.l	d0,a1
	move.l	muimaster(a4),a6
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	lea	AppTitleText-t(a5),a0
	suba.l	a3,a3
	jsr	_LVOMUI_RequestA(a6)
	bra	xt_SuljeKirjastot

.68020	bsr	CreateObjects
	beq	xt_UnInitialize

	TEE_METODI	App(a4),LataaAsetukset_Metodit

	bsr	DoPostInit

	move.l	WI_Main-t(a5),a0
	bsr	AvaaIkkuna
	beq.b	xt_LopetaSovellus2

	clr.l	ErrorCode-t(a5)

.loop1	TEE_METODI	App(a4),OdotusMetodit
	cmp.l	#MUIV_Application_ReturnID_Quit,d0
	beq.b	xt_LopetaSovellus2

	tst.l	d0
	beq.b	.skip1
	move.l	d0,a0
	jsr	(a0)

.skip1	move.l	Signal-t(a5),d0
	beq.b	.loop1
	move.l	exec(a4),a6
	or.l	SignalMask(a4),d0
	jsr	_LVOWait(a6)
	move.l	d0,d1
	move.l	d0,Signal-t(a5)
	and.l	PacketMask(a4),d1
	beq.b	.timer
	move.l	d0,-(sp)
	bsr	LueViesti
	move.l	(sp)+,d0

.timer	and.l	TimerMask(a4),d0
	beq.b	.loop1
	bsr	GetTimerMsg
	bra.b	.loop1

xt_LopetaSovellus:
	addq.l	#4,sp

xt_LopetaSovellus2:
	bsr	AbortPacket

	move.l	muimaster(a4),a6
	move.l	App(a4),a0
	jsr	_LVOMUI_DisposeObject(a6)
	move.l	Defrag_mcc(a4),a0
	jsr	_LVOMUI_DeleteCustomClass(a6)

xt_UnInitialize:
	bsr	UnInitialize

xt_SuljeKirjastot:
	bsr	SuljeKirjastot

xt_Loppu:
	move.l	(sp)+,d2
	beq.b	.x
	jsr	_LVOForbid(a6)
	move.l	d2,a1
	jsr	_LVOReplyMsg(a6)
.x	move.l	ErrorCode-t(a5),d0
	rts

	include	"initializers.asm"
	include	"CustomClass.asm"
	include	"defrag.asm"
	include	"timer.asm"
	include	"dos.asm"
	include	"gui.asm"
	include	"sekalaiset.asm"
	include	"ObjCreating.asm"
	include	"requesters.asm"
	include	"käsittelijät/muut.asm"
	include	"käsittelijät/nappulat.asm"
	include	"käsittelijät/valikot.asm"

	include	"käsittelijät/muut_abs.asm"
	include	"käsittelijät/nappulat_abs.asm"
	include	"käsittelijät/valikot_abs.asm"

	SECTION	Muuttujat,BSS

b:	ds.b	Muuttujat_SIZE

	SECTION	Vakiot,DATA

t:	dc.l	b

Signal	dc.l	0

	include	"mui/groups/defrag.asm"
	include	"mui/groups/prefs.asm"
	include	"mui/groups.asm"
	include	"mui/metodit/defrag.asm"
	include	"mui/metodit/prefs.asm"
	include	"mui/metodit.asm"
	include	"mui/tags.asm"
	include	"mui/windows.asm"
	include	"hooks.asm"
	include	"menut.asm"

SFSQueryTags:
	dc.l	ASQ_CACHE_ACCESSES
sfs_cache_accesses:
	dc.l	0
	dc.l	ASQ_CACHE_MISSES
sfs_cache_misses:
	dc.l	0
	dc.l	ASQ_START_BYTEH
sfs_start_byteh:
	dc.l	0
	dc.l	ASQ_START_BYTEL
sfs_start_bytel:
	dc.l	0
	dc.l	ASQ_END_BYTEH
sfs_end_byteh:
	dc.l	0
	dc.l	ASQ_END_BYTEL
sfs_end_bytel:
	dc.l	0
	dc.l	ASQ_DEVICE_API
sfs_device_api:
	dc.l	0
	dc.l	ASQ_BLOCK_SIZE
sfs_block_size:
	dc.l	0
	dc.l	ASQ_TOTAL_BLOCKS
sfs_total_blocks:
	dc.l	0
	dc.l	ASQ_ROOTBLOCK
sfs_rootblock:
	dc.l	0
	dc.l	ASQ_ROOTBLOCK_OBJECTNODES
sfs_rootblock_objectnodes:
	dc.l	0
	dc.l	ASQ_ROOTBLOCK_EXTENTS
sfs_rootblock_extents:
	dc.l	0
	dc.l	ASQ_FIRST_BITMAP_BLOCK
sfs_first_bitmap_block:
	dc.l	0
	dc.l	ASQ_FIRST_ADMINSPACE
sfs_first_adminspace:
	dc.l	0
	dc.l	ASQ_CACHE_LINES
sfs_cache_lines:
	dc.l	0
	dc.l	ASQ_CACHE_READAHEADSIZE
sfs_cache_readaheadsize:
	dc.l	0
	dc.l	ASQ_CACHE_MODE
sfs_cache_mode:
	dc.l	0
	dc.l	ASQ_CACHE_BUFFERS
sfs_cache_buffers:
	dc.l	0
	dc.l	ASQ_IS_CASESENSITIVE
sfs_is_casesensitive:
	dc.l	0
	dc.l	ASQ_HAS_RECYCLED
sfs_has_recycled:
	dc.l	0
	dc.l	ASQ_VERSION
sfs_version:
	dc.l	0
	dc.l	TAG_DONE

ErrorCode:
	dc.l	20

libnametable:
	dc.l	muimastername
	dc.l	localelibname
	dc.l	intuiname
	dc.l	gfxname
	dc.l	0

localetags:
	dc.l	OC_BuiltInLanguage,t_English
	dc.l	TAG_DONE

PreParse:
	dc.b  27,'c',0
PreParse2:
	dc.b  27,'r',0

pixw	dc.b	1,2,3,2,3,4,3,5,4,5,4,6,5,6,5,6,6
pixh	dc.b	1,1,1,2,2,2,3,2,3,3,4,3,4,4,5,5,6

;	dc.b	1,2,3,4,6,8,9,10,12,15,16,18,20,24,25,30,36

DoubleTxtHeight:
	dc.b	10,0

	include	"tekstit/sfs.strings.asm"
	include	"mui/classes.asm"

*-----------------------------------------------*
*	@Formatointilausekkeet			*
*-----------------------------------------------*

DeviceListFormat:
	dc.b	',,,',0

SFScheckFormat:
	dc.b	'SFScheck %s >%s',0

PutkiFormaatti:
	dc.b	'PIPE:%s.putki',0

CacheMissesFormat:
	dc.b	'%lU (%d.%02.d%%)',0
DoubleStringFormat:
	dc.b	'%s%s',0
NumberFormat:
	dc.b	'%lU',0
VersionNumberFormat:
	dc.b	'%d.%d',0
TimeFormat:
	dc.b	'%02.d:%02.d:%02.d',0
DiskUsageFormat:
	dc.b	'%d%%',0

*-----------------------------------------------*
*	@Init					*
*-----------------------------------------------*

catalogname:
	dc.b	'smartinfo.catalog',0

t_English:
	dc.b	'english',0

t_ERR_NO_LIBRARY:
	dc.b	'Unable to open %s. Version %d or newer required.',10,0

*-----------------------------------------------*
*	@Muut					*
*-----------------------------------------------*

t_DefStartTime:
	dc.b	'00:00:00',0

HDImageSpec:
	dc.b	27,'I[6:23,8]',0

EnvarcConfigName:
	dc.b	'ENVARC:MUI/SmartInfo.config',0
EnvConfigName:
	dc.b	'ENV:MUI/SmartInfo.config',0

AppTitleText:
	dc.b	'Smart Info v1.04',0
t_AppBase:
	dc.b	'SMARTINFO',0
t_AppRights:
t_AuthorInfo:
	dc.b	'Ilkka Lehtoranta',0
t_AppTitle:
	dc.b	'Smart Info',0
t_VerString:
	dc.b	'$VER: Smart Info 1.04 (30.11.1999)',0
t_AppDescription:
	dc.b	'SmartFileSystem Info and Defragment Tool',0

Numerals:
	dc.b	'01234567689',0

timername:
	dc.b	'timer.device',0
muimastername:
	dc.b	11,'muimaster.library',0
localelibname:
	dc.b	38,'locale.library',0
intuiname:
	dc.b	39,'intuition.library',0
gfxname	dc.b	36,'graphics.library',0

dosname	dc.b	'dos.library',0

	END