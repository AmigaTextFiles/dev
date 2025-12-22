#ifndef GRAPHICS_GFXBASE_H
#define GRAPHICS_GFXBASE_H

#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif
#ifndef EXEC_INTERRUPTS_H
MODULE  'exec/interrupts'
#endif
#ifndef	GRAPHICS_MONITOR_H
MODULE  'graphics/monitor'
#endif
OBJECT GfxBase

		  LibNode:Library
		 ActiView:PTR TO View
		 copinit:PTR TO copinit	
	cia:PTR TO LONG			
	blitter:PTR TO LONG		
	LOFlist:PTR TO UWORD
	SHFlist:PTR TO UWORD
		 blthd:PTR TO bltnode
blttl:PTR TO bltnode
		 bsblthd:PTR TO bltnode
bsblttl:PTR TO bltnode
		 vbsrv:Interrupt
timsrv:Interrupt
bltsrv:Interrupt
			 TextFonts:List
		 DefaultFont:PTR TO TextFont
	Modes:UWORD			
	VBlank:BYTE
	Debug:BYTE
	BeamSync:WORD
	bplcon0:WORD		
	SpriteReserved:UBYTE
	bytereserved:UBYTE
	Flags:UWORD
	BlitLock:WORD
	BlitNest:WORD
		 BlitWaitQ:List
		 BlitOwner:PTR TO Task
		 WaitQ:List
	DisplayFlags:UWORD		
					
		 SimpleSprites:LONG
	MaxDisplayRow:UWORD		
	MaxDisplayColumn:UWORD	
	NormalDisplayRows:UWORD
	NormalDisplayColumns:UWORD
	
	NormalDPMX:UWORD		
	NormalDPMY:UWORD		
		 LastChanceMemory:PTR TO SignalSemaphore
	LCMptr:PTR TO UWORD
	MicrosPerLine:UWORD		
	MinDisplayColumn:UWORD
	ChipRevBits0:UBYTE
	MemType:UBYTE
	reserved[4]:UBYTE
	id:UWORD
	hedley[8]:LONG
	sprites[8]:LONG	
	sprites1[8]:LONG	
	count:WORD
	flags:UWORD
	tmp:WORD
	table:PTR TO LONG
	tot_rows:UWORD
	tot_cclks:UWORD
	hint:UBYTE
	hint2:UBYTE
	nreserved[4]:LONG
	sync_raster:PTR TO LONG
	delta_pal:UWORD
	delta_ntsc:UWORD
		 monitor:PTR TO MonitorSpec
		 MonitorList:List
		 monitor:PTR TO MonitorSpec
		 MonitorListSemaphore:PTR TO SignalSemaphore
	DisplayInfoDataBase:PTR TO LONG
	TopLine:UWORD
		 ActiViewCprSemaphore:PTR TO SignalSemaphore
	UtilBase:PTR TO LONG		
	ExecBase:PTR TO LONG		
	bwshifts:PTR TO UBYTE
	StrtFetchMasks:PTR TO UWORD
	StopFetchMasks:PTR TO UWORD
	Overrun:PTR TO UWORD
	RealStops:PTR TO WORD
	SpriteWidth:UWORD	
	SpriteFMode:UWORD		
	SoftSprites:BYTE	
	arraywidth:BYTE
	DefaultSpriteWidth:UWORD	
	SprMoveDisable:BYTE
	WantChips:UBYTE
	BoardMemType:UBYTE
	Bugs:UBYTE
	LayersBase:PTR TO LONG
	ColorMask:LONG
	IVector:LONG
	IData:LONG
	SpecialCounter:LONG		
	DBList:LONG
	MonitorFlags:UWORD
	ScanDoubledSprites:UBYTE
	BP3Bits:UBYTE
		 MonitorVBlank:AnalogSignalInterval
		 monitor:PTR TO MonitorSpec
	ProgData:LONG
	ExtSprites:UBYTE
	pad3:UBYTE
	GfxFlags:UWORD
	VBCounter:LONG
		 HashTableSemaphore:PTR TO SignalSemaphore
	HWEmul[9]:PTR TO LONG
ENDOBJECT

#define ChunkyToPlanarPtr HWEmul[0]

#define NTSC		1
#define GENLOC		2
#define PAL		4
#define TODA_SAFE	8
#define REALLY_PAL	16	
#define LPEN_SWAP_FRAMES	32
				
#define BLITMSG_FAULT	4

#define	GFXB_BIG_BLITS	0
#define	GFXB_HR_AGNUS	0
#define GFXB_HR_DENISE	1
#define GFXB_AA_ALICE	2
#define GFXB_AA_LISA	3
#define GFXB_AA_MLISA	4	
#define GFXF_BIG_BLITS	1
#define	GFXF_HR_AGNUS	1
#define GFXF_HR_DENISE	2
#define GFXF_AA_ALICE	4
#define GFXF_AA_LISA	8
#define GFXF_AA_MLISA	16	

#define SETCHIPREV_A	GFXF_HR_AGNUS
#define SETCHIPREV_ECS	(GFXF_HR_AGNUS OR GFXF_HR_DENISE)
#define SETCHIPREV_AA	(GFXF_AA_ALICE OR GFXF_AA_LISA OR SETCHIPREV_ECS)
#define SETCHIPREV_BEST $ffffffff

#define BUS_16		0
#define NML_CAS		0
#define BUS_32		1
#define DBL_CAS		2
#define BANDWIDTH_1X	(BUS_16 OR NML_CAS)
#define BANDWIDTH_2XNML	BUS_32
#define BANDWIDTH_2XDBL	DBL_CAS
#define BANDWIDTH_4X	(BUS_32 OR DBL_CAS)

#define NEW_DATABASE	1
#define GRAPHICSNAME	'graphics.library'
#endif	
