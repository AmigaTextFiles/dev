/* $VER: gfxbase.h 39.21 (21.4.1993) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/lists', 'target/exec/libraries', 'target/exec/interrupts', 'target/graphics/monitor'
MODULE 'target/graphics/view', 'target/graphics/copper', 'target/graphics/text', 'target/graphics/sprite', 'target/hardware/blit', 'target/exec/semaphores', 'target/exec/tasks', 'target/exec/types'
{#include <graphics/gfxbase.h>}
NATIVE {GRAPHICS_GFXBASE_H} CONST

NATIVE {GfxBase} OBJECT gfxbase
	{LibNode}	lib	:lib
	{ActiView}	actiview	:PTR TO view
	{copinit}	copinit	:PTR TO copinit	/* ptr to copper start up list */
	{cia}	cia	:PTR TO VALUE			/* for 8520 resource use */
	{blitter}	blitter	:PTR TO VALUE		/* for future blitter resource use */
	{LOFlist}	loflist	:PTR TO UINT
	{SHFlist}	shflist	:PTR TO UINT
	{blthd}	blthd	:PTR TO bltnode
	{blttl}	blttl	:PTR TO bltnode
	{bsblthd}	bsblthd	:PTR TO bltnode
	{bsblttl}	bsblttl	:PTR TO bltnode
	{vbsrv}	vbsrv	:is
	{timsrv}	timsrv	:is
	{bltsrv}	bltsrv	:is
	{TextFonts}	textfonts	:lh
	{DefaultFont}	defaultfont	:PTR TO textfont
	{Modes}	modes	:UINT			/* copy of current first bplcon0 */
	{VBlank}	vblank	:BYTE
	{Debug}	debug	:BYTE
	{BeamSync}	beamsync	:INT
	{system_bplcon0}	system_bplcon0	:INT		/* it is ored into each bplcon0 for display */
	{SpriteReserved}	spritereserved	:UBYTE
	{bytereserved}	bytereserved	:UBYTE
	{Flags}	flags	:UINT
	{BlitLock}	blitlock	:INT
	{BlitNest}	blitnest	:INT

	{BlitWaitQ}	blitwaitq	:lh
	{BlitOwner}	blitowner	:PTR TO tc
	{TOF_WaitQ}	tof_waitq	:lh
	{DisplayFlags}	displayflags	:UINT		/* NTSC PAL GENLOC etc*/
					/* flags initialized at power on */
	{SimpleSprites}	simplesprites	:ARRAY OF PTR TO simplesprite
	{MaxDisplayRow}	maxdisplayrow	:UINT		/* hardware stuff, do not use */
	{MaxDisplayColumn}	maxdisplaycolumn	:UINT	/* hardware stuff, do not use */
	{NormalDisplayRows}	normaldisplayrows	:UINT
	{NormalDisplayColumns}	normaldisplaycolumns	:UINT
	/* the following are for standard non interlace, 1/2 wb width */
	{NormalDPMX}	normaldpmx	:UINT		/* Dots per meter on display */
	{NormalDPMY}	normaldpmy	:UINT		/* Dots per meter on display */
	{LastChanceMemory}	lastchancememory	:PTR TO ss
	{LCMptr}	lcmptr	:PTR TO UINT
	{MicrosPerLine}	microsperline	:UINT		/* 256 time usec/line */
	{MinDisplayColumn}	mindisplaycolumn	:UINT
	{ChipRevBits0}	chiprevbits0	:UBYTE
	{MemType}	memtype	:UBYTE
	{crb_reserved}	crb_reserved[4]	:ARRAY OF UBYTE
	{monitor_id}	monitor_id	:UINT
	{hedley}	hedley[8]	:ARRAY OF ULONG
	{hedley_sprites}	hedley_sprites[8]	:ARRAY OF ULONG	/* sprite ptrs for intuition mouse */
	{hedley_sprites1}	hedley_sprites1[8]	:ARRAY OF ULONG	/* sprite ptrs for intuition mouse */
	{hedley_count}	hedley_count	:INT
	{hedley_flags}	hedley_flags	:UINT
	{hedley_tmp}	hedley_tmp	:INT
	{hash_table}	hash_table	:PTR TO VALUE
	{current_tot_rows}	current_tot_rows	:UINT
	{current_tot_cclks}	current_tot_cclks	:UINT
	{hedley_hint}	hedley_hint	:UBYTE
	{hedley_hint2}	hedley_hint2	:UBYTE
	{nreserved}	nreserved[4]	:ARRAY OF ULONG
	{a2024_sync_raster}	a2024_sync_raster	:PTR TO VALUE
	{control_delta_pal}	control_delta_pal	:UINT
	{control_delta_ntsc}	control_delta_ntsc	:UINT
	{current_monitor}	current_monitor	:PTR TO monitorspec
	{MonitorList}	monitorlist	:lh
	{default_monitor}	default_monitor	:PTR TO monitorspec
	{MonitorListSemaphore}	monitorlistsemaphore	:PTR TO ss
	{DisplayInfoDataBase}	displayinfodatabase	:PTR
	{TopLine}	topline	:UINT
	{ActiViewCprSemaphore}	activiewcprsemaphore	:PTR TO ss
	{UtilBase}	utilbase	:PTR TO ULONG		/* for hook and tag utilities. had to change because of name clash	*/
	{ExecBase}	execbase	:PTR TO ULONG		/* to link with rom.lib	*/
	{bwshifts}	bwshifts	:PTR TO UBYTE
	{StrtFetchMasks}	strtfetchmasks	:PTR TO UINT
	{StopFetchMasks}	stopfetchmasks	:PTR TO UINT
	{Overrun}	overrun	:PTR TO UINT
	{RealStops}	realstops	:PTR TO INT
	{SpriteWidth}	spritewidth	:UINT	/* current width (in words) of sprites */
	{SpriteFMode}	spritefmode	:UINT		/* current sprite fmode bits	*/
	{SoftSprites}	softsprites	:BYTE	/* bit mask of size change knowledgeable sprites */
	{arraywidth}	arraywidth	:BYTE
	{DefaultSpriteWidth}	defaultspritewidth	:UINT	/* what width intuition wants */
	{SprMoveDisable}	sprmovedisable	:BYTE
	{WantChips}	wantchips	:UBYTE
	{BoardMemType}	boardmemtype	:UBYTE
	{Bugs}	bugs	:UBYTE
	{gb_LayersBase}	layersbase	:PTR TO ULONG
	{ColorMask}	colormask	:ULONG
	{IVector}	ivector	:APTR
	{IData}	idata	:APTR
	{SpecialCounter}	specialcounter	:ULONG		/* special for double buffering */
	{DBList}	dblist	:APTR
	{MonitorFlags}	monitorflags	:UINT
	{ScanDoubledSprites}	scandoubledsprites	:UBYTE
	{BP3Bits}	bp3bits	:UBYTE
	{MonitorVBlank}	monitorvblank	:analogsignalinterval
	{natural_monitor}	natural_monitor	:PTR TO monitorspec
	{ProgData}	progdata	:APTR
	{ExtSprites}	extsprites	:UBYTE
	{pad3}	pad3	:UBYTE
	{GfxFlags}	gfxflags	:UINT
	{VBCounter}	vbcounter	:ULONG
	{HashTableSemaphore}	hashtablesemaphore	:PTR TO ss
	{HWEmul}	hwemul[9]	:ARRAY OF PTR TO ULONG
	{HWEmul[0]} chunkytoplanarptr:PTR TO ULONG	->alias
ENDOBJECT

NATIVE {ChunkyToPlanarPtr} CONST






/* Values for GfxBase->DisplayFlags */
NATIVE {NTSC}		CONST NTSC		= 1
NATIVE {GENLOC}		CONST GENLOC		= 2
NATIVE {PAL}		CONST PAL		= 4
NATIVE {TODA_SAFE}	CONST TODA_SAFE	= 8
NATIVE {REALLY_PAL}	CONST REALLY_PAL	= 16	/* what is actual crystal frequency
				 (as opposed to what bootmenu set the agnus to)?
				 (V39) */
NATIVE {LPEN_SWAP_FRAMES}	CONST LPEN_SWAP_FRAMES	= 32
				/* LightPen software could set this bit if the
				 * "lpen-with-interlace" fix put in for V39
				 * does not work. This is true of a number of
				 * Agnus chips.
				 * (V40).
				 */

NATIVE {BLITMSG_FAULT}	CONST BLITMSG_FAULT	= 4

/* bits defs for ChipRevBits */
NATIVE {GFXB_BIG_BLITS}	CONST GFXB_BIG_BLITS	= 0
NATIVE {GFXB_HR_AGNUS}	CONST GFXB_HR_AGNUS	= 0
NATIVE {GFXB_HR_DENISE}	CONST GFXB_HR_DENISE	= 1
NATIVE {GFXB_AA_ALICE}	CONST GFXB_AA_ALICE	= 2
NATIVE {GFXB_AA_LISA}	CONST GFXB_AA_LISA	= 3
NATIVE {GFXB_AA_MLISA}	CONST GFXB_AA_MLISA	= 4	/* internal use only. */

NATIVE {GFXF_BIG_BLITS}	CONST GFXF_BIG_BLITS	= 1
NATIVE {GFXF_HR_AGNUS}	CONST GFXF_HR_AGNUS	= 1
NATIVE {GFXF_HR_DENISE}	CONST GFXF_HR_DENISE	= 2
NATIVE {GFXF_AA_ALICE}	CONST GFXF_AA_ALICE	= 4
NATIVE {GFXF_AA_LISA}	CONST GFXF_AA_LISA	= 8
NATIVE {GFXF_AA_MLISA}	CONST GFXF_AA_MLISA	= 16	/* internal use only */

/* Pass ONE of these to SetChipRev() */
NATIVE {SETCHIPREV_A}	CONST SETCHIPREV_A	= GFXF_HR_AGNUS
NATIVE {SETCHIPREV_ECS}	CONST SETCHIPREV_ECS	= (GFXF_HR_AGNUS OR GFXF_HR_DENISE)
NATIVE {SETCHIPREV_AA}	CONST SETCHIPREV_AA	= (GFXF_AA_ALICE OR GFXF_AA_LISA OR SETCHIPREV_ECS)
NATIVE {SETCHIPREV_BEST} CONST SETCHIPREV_BEST = $ffffffff

/* memory type */
NATIVE {BUS_16}		CONST BUS_16		= 0
NATIVE {NML_CAS}		CONST NML_CAS		= 0
NATIVE {BUS_32}		CONST BUS_32		= 1
NATIVE {DBL_CAS}		CONST DBL_CAS		= 2
NATIVE {BANDWIDTH_1X}	CONST BANDWIDTH_1X	= (BUS_16 OR NML_CAS)
NATIVE {BANDWIDTH_2XNML}	CONST BANDWIDTH_2XNML	= BUS_32
NATIVE {BANDWIDTH_2XDBL}	CONST BANDWIDTH_2XDBL	= DBL_CAS
NATIVE {BANDWIDTH_4X}	CONST BANDWIDTH_4X	= (BUS_32 OR DBL_CAS)

/* GfxFlags (private) */
NATIVE {NEW_DATABASE}	CONST NEW_DATABASE	= 1

NATIVE {GRAPHICSNAME}	CONST
#define GRAPHICSNAME graphicsname
STATIC graphicsname	= 'graphics.library'
