/* $Id: gfxbase.h 21159 2004-03-04 12:58:56Z falemagn $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/interrupts', 'target/exec/execbase', 'target/exec/libraries', 'target/exec/lists', 'target/graphics/monitor'
MODULE 'target/graphics/view', 'target/graphics/copper', 'target/graphics/text', 'target/graphics/sprite', 'target/hardware/blit', 'target/exec/semaphores', 'target/exec/tasks', 'target/exec/types'
{#include <graphics/gfxbase.h>}
NATIVE {GRAPHICS_GFXBASE_H} CONST

NATIVE {GRAPHICSNAME} CONST
#define GRAPHICSNAME graphicsname
STATIC graphicsname = 'graphics.library'

NATIVE {GfxBase} OBJECT gfxbase
/* Standard Library Node */
    {LibNode}	lib	:lib

    {ActiView}	actiview	:PTR TO view
    {copinit}	copinit	:PTR TO copinit
    {cia}	cia	:PTR TO SLONG
    {blitter}	blitter	:PTR TO SLONG
    {LOFlist}	loflist	:PTR TO UINT
    {SHFlist}	shflist	:PTR TO UINT
    {blthd}	blthd	:PTR TO bltnode
    {blttl}	blttl	:PTR TO bltnode
    {bsblthd}	bsblthd	:PTR TO bltnode
    {bsblttl}	bsblttl	:PTR TO bltnode
    {vbsrv}	vbsrv	:is
    {timsrv}	timsrv	:is
    {bltsrv}	bltsrv	:is

/* Fonts */
    {TextFonts}	textfonts	:lh
    {DefaultFont}	defaultfont	:PTR TO textfont

    {Modes}	modes	:UINT
    {VBlank}	vblank	:BYTE
    {Debug}	debug	:BYTE
    {BeamSync}	beamsync	:INT
     {system_bplcon0}	system_bplcon0	:INT
    {SpriteReserved}	spritereserved	:UBYTE
    {bytereserved}	bytereserved	:UBYTE
    {Flags}	flags	:UINT
    {BlitLock}	blitlock	:INT
    {BlitNest}	blitnest	:INT

    {BlitWaitQ}	blitwaitq	:lh
    {BlitOwner}	blitowner	:PTR TO tc
    {TOF_WaitQ}	tof_waitq	:lh

    {DisplayFlags}	displayflags	:UINT  /* see below */
    {SimpleSprites}	simplesprites	:ARRAY OF PTR TO simplesprite

    {MaxDisplayRow}	maxdisplayrow	:UINT
    {MaxDisplayColumn}	maxdisplaycolumn	:UINT
    {NormalDisplayRows}	normaldisplayrows	:UINT
    {NormalDisplayColumns}	normaldisplaycolumns	:UINT
    {NormalDPMX}	normaldpmx	:UINT
    {NormalDPMY}	normaldpmy	:UINT

    {LastChanceMemory}	lastchancememory	:PTR TO ss

    {LCMptr}	lcmptr	:PTR TO UINT
    {MicrosPerLine}	microsperline	:UINT
    {MinDisplayColumn}	mindisplaycolumn	:UINT
    {ChipRevBits0}	chiprevbits0	:UBYTE     /* see below */
    {MemType}	memtype	:UBYTE
    {crb_reserved}	crb_reserved[4]	:ARRAY OF UBYTE
    {monitor_id}	monitor_id	:UINT

    {hedley}	hedley[8]	:ARRAY OF ULONG
    {hedley_sprites}	hedley_sprites[8]	:ARRAY OF ULONG
    {hedley_sprites1}	hedley_sprites1[8]	:ARRAY OF ULONG
    {hedley_count}	hedley_count	:INT
    {hedley_flags}	hedley_flags	:UINT
    {hedley_tmp}	hedley_tmp	:INT

    {hash_table}	hash_table	:PTR TO SLONG
    {current_tot_rows}	current_tot_rows	:UINT
    {current_tot_cclks}	current_tot_cclks	:UINT
    {hedley_hint}	hedley_hint	:UBYTE
    {hedley_hint2}	hedley_hint2	:UBYTE
    {nreserved}	nreserved[4]	:ARRAY OF ULONG
    {a2024_sync_raster}	a2024_sync_raster	:PTR TO SLONG
    {control_delta_pal}	control_delta_pal	:UINT
    {control_delta_ntsc}	control_delta_ntsc	:UINT

    {current_monitor}	current_monitor	:PTR TO monitorspec
    {MonitorList}	monitorlist	:lh
    {default_monitor}	default_monitor	:PTR TO monitorspec
    {MonitorListSemaphore}	monitorlistsemaphore	:PTR TO ss

    {DisplayInfoDataBase}	displayinfodatabase	:PTR
    {TopLine}	topline	:UINT
    {ActiViewCprSemaphore}	activiewcprsemaphore	:PTR TO ss

/* Library Bases */
    {UtilBase}	utilbase	:PTR TO lib
    {ExecBase}	execbase	:PTR TO execbase

    {bwshifts}	bwshifts	:PTR TO BYTE
    {StrtFetchMasks}	strtfetchmasks	:PTR TO UINT
    {StopFetchMasks}	stopfetchmasks	:PTR TO UINT
    {Overrun}	overrun	:PTR TO UINT
    {RealStops}	realstops	:PTR TO INT
    {SpriteWidth}	spritewidth	:UINT
    {SpriteFMode}	spritefmode	:UINT
    {SoftSprites}	softsprites	:BYTE
    {arraywidth}	arraywidth	:BYTE
    {DefaultSpriteWidth}	defaultspritewidth	:UINT
    {SprMoveDisable}	sprmovedisable	:BYTE
    {WantChips}	wantchips	:UBYTE
    {BoardMemType}	boardmemtype	:UBYTE
    {Bugs}	bugs	:UBYTE
    {gb_LayersBase}	layersbase	:PTR TO ULONG
    {ColorMask}	colormask	:ULONG
    {IVector}	ivector	:APTR
    {IData}	idata	:APTR
    {SpecialCounter}	specialcounter	:ULONG
    {DBList}	dblist	:APTR
    {MonitorFlags}	monitorflags	:UINT
    {ScanDoubleSprites}	scandoubledsprites	:UBYTE
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
ENDOBJECT
NATIVE {ChunkyToPlanarPtr} CONST

/* DisplayFlags */
NATIVE {NTSC}             CONST NTSC             = $1
NATIVE {GENLOC}           CONST GENLOC           = $2
NATIVE {PAL}              CONST PAL              = $4
NATIVE {TODA_SAFE}        CONST TODA_SAFE        = $8
NATIVE {REALLY_PAL}       CONST REALLY_PAL       = $10
NATIVE {LPEN_SWAP_FRAMES} CONST LPEN_SWAP_FRAMES = $20

/* ChipRevBits */
NATIVE {GFXB_BIG_BLITS}     CONST GFXB_BIG_BLITS     = 0
NATIVE {GFXF_BIG_BLITS} CONST GFXF_BIG_BLITS = $1
NATIVE {GFXB_HR_AGNUS}      CONST GFXB_HR_AGNUS      = 0
NATIVE {GFXF_HR_AGNUS}  CONST GFXF_HR_AGNUS  = $1
NATIVE {GFXB_HR_DENISE}     CONST GFXB_HR_DENISE     = 1
NATIVE {GFXF_HR_DENISE} CONST GFXF_HR_DENISE = $2
NATIVE {GFXB_AA_ALICE}      CONST GFXB_AA_ALICE      = 2
NATIVE {GFXF_AA_ALICE}  CONST GFXF_AA_ALICE  = $4
NATIVE {GFXB_AA_LISA}       CONST GFXB_AA_LISA       = 3
NATIVE {GFXF_AA_LISA}   CONST GFXF_AA_LISA   = $8
NATIVE {GFXB_AA_MLISA}      CONST GFXB_AA_MLISA      = 4
NATIVE {GFXF_AA_MLISA}  CONST GFXF_AA_MLISA  = $10

/* For use in SetChipRev() */
NATIVE {SETCHIPREV_A}    CONST SETCHIPREV_A    = GFXF_HR_AGNUS
NATIVE {SETCHIPREV_ECS}  CONST SETCHIPREV_ECS  = (GFXF_HR_AGNUS OR GFXF_HR_DENISE)
NATIVE {SETCHIPREV_AA}   CONST SETCHIPREV_AA   = (SETCHIPREV_ECS OR GFXF_AA_ALICE OR GFXF_AA_LISA)
NATIVE {SETCHIPREV_BEST} CONST SETCHIPREV_BEST = $FFFFFFFF

NATIVE {BUS_16}  CONST BUS_16  = 0
NATIVE {BUS_32}  CONST BUS_32  = 1
NATIVE {NML_CAS} CONST NML_CAS = 0
NATIVE {DBL_CAS} CONST DBL_CAS = 2

NATIVE {BANDWIDTH_1X}    CONST BANDWIDTH_1X    = (BUS_16 OR NML_CAS)
NATIVE {BANDWIDTH_2XNML} CONST BANDWIDTH_2XNML = BUS_32
NATIVE {BANDWIDTH_2XDBL} CONST BANDWIDTH_2XDBL = DBL_CAS
NATIVE {BANDWIDTH_4X}    CONST BANDWIDTH_4X    = (BUS_32 OR DBL_CAS)

NATIVE {BLITMSG_FAULT} CONST BLITMSG_FAULT = 4

/* PRIVATE */
NATIVE {NEW_DATABASE} CONST NEW_DATABASE = 1
