/* $VER: gfxbase.h 39.21 (21.4.1993) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/lists', 'target/exec/libraries', 'target/exec/interrupts', 'target/graphics/monitor'
MODULE 'target/graphics/view', 'target/graphics/copper', 'target/graphics/text', 'target/graphics/sprite', 'target/hardware/blit', 'target/exec/semaphores', 'target/exec/tasks', 'target/exec/types'
{MODULE 'graphics/gfxbase'}

NATIVE {gfxbase} OBJECT gfxbase
	{lib}	lib	:lib
	{actiview}	actiview	:PTR TO view
	{copinit}	copinit	:PTR TO copinit	/* ptr to copper start up list */
	{cia}	cia	:PTR TO VALUE			/* for 8520 resource use */
	{blitter}	blitter	:PTR TO VALUE		/* for future blitter resource use */
	{loflist}	loflist	:PTR TO UINT
	{shflist}	shflist	:PTR TO UINT
	{blthd}	blthd	:PTR TO bltnode
	{blttl}	blttl	:PTR TO bltnode
	{bsblthd}	bsblthd	:PTR TO bltnode
	{bsblttl}	bsblttl	:PTR TO bltnode
	{vbsrv}	vbsrv	:is
	{timsrv}	timsrv	:is
	{bltsrv}	bltsrv	:is
	{textfonts}	textfonts	:lh
	{defaultfont}	defaultfont	:PTR TO textfont
	{modes}	modes	:UINT			/* copy of current first bplcon0 */
	{vblank}	vblank	:BYTE
	{debug}	debug	:BYTE
	{beamsync}	beamsync	:INT
	{system_bplcon0}	system_bplcon0	:INT		/* it is ored into each bplcon0 for display */
	{spritereserved}	spritereserved	:UBYTE
	{bytereserved}	bytereserved	:UBYTE
	{flags}	flags	:UINT
	{blitlock}	blitlock	:INT
	{blitnest}	blitnest	:INT

	{blitwaitq}	blitwaitq	:lh
	{blitowner}	blitowner	:PTR TO tc
	{tof_waitq}	tof_waitq	:lh
	{displayflags}	displayflags	:UINT		/* NTSC PAL GENLOC etc*/
					/* flags initialized at power on */
	{simplesprites}	simplesprites	:ARRAY OF PTR TO simplesprite
	{maxdisplayrow}	maxdisplayrow	:UINT		/* hardware stuff, do not use */
	{maxdisplaycolumn}	maxdisplaycolumn	:UINT	/* hardware stuff, do not use */
	{normaldisplayrows}	normaldisplayrows	:UINT
	{normaldisplaycolumns}	normaldisplaycolumns	:UINT
	/* the following are for standard non interlace, 1/2 wb width */
	{normaldpmx}	normaldpmx	:UINT		/* Dots per meter on display */
	{normaldpmy}	normaldpmy	:UINT		/* Dots per meter on display */
	{lastchancememory}	lastchancememory	:PTR TO ss
	{lcmptr}	lcmptr	:PTR TO UINT
	{microsperline}	microsperline	:UINT		/* 256 time usec/line */
	{mindisplaycolumn}	mindisplaycolumn	:UINT
	{chiprevbits0}	chiprevbits0	:UBYTE
	{memtype}	memtype	:UBYTE
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
	{monitorlist}	monitorlist	:lh
	{default_monitor}	default_monitor	:PTR TO monitorspec
	{monitorlistsemaphore}	monitorlistsemaphore	:PTR TO ss
	{displayinfodatabase}	displayinfodatabase	:PTR
	{topline}	topline	:UINT
	{activiewcprsemaphore}	activiewcprsemaphore	:PTR TO ss
	{utilbase}	utilbase	:PTR TO ULONG		/* for hook and tag utilities. had to change because of name clash	*/
	{execbase}	execbase	:PTR TO ULONG		/* to link with rom.lib	*/
	{bwshifts}	bwshifts	:PTR TO UBYTE
	{strtfetchmasks}	strtfetchmasks	:PTR TO UINT
	{stopfetchmasks}	stopfetchmasks	:PTR TO UINT
	{overrun}	overrun	:PTR TO UINT
	{realstops}	realstops	:PTR TO INT
	{spritewidth}	spritewidth	:UINT	/* current width (in words) of sprites */
	{spritefmode}	spritefmode	:UINT		/* current sprite fmode bits	*/
	{softsprites}	softsprites	:BYTE	/* bit mask of size change knowledgeable sprites */
	{arraywidth}	arraywidth	:BYTE
	{defaultspritewidth}	defaultspritewidth	:UINT	/* what width intuition wants */
	{sprmovedisable}	sprmovedisable	:BYTE
	{wantchips}	wantchips	:UBYTE
	{boardmemtype}	boardmemtype	:UBYTE
	{bugs}	bugs	:UBYTE
	{layersbase}	layersbase	:PTR TO ULONG
	{colormask}	colormask	:ULONG
	{ivector}	ivector	:APTR
	{idata}	idata	:APTR
	{specialcounter}	specialcounter	:ULONG		/* special for double buffering */
	{dblist}	dblist	:APTR
	{monitorflags}	monitorflags	:UINT
	{scandoubledsprites}	scandoubledsprites	:UBYTE
	{bp3bits}	bp3bits	:UBYTE
	{monitorvblank}	monitorvblank	:analogsignalinterval
	{natural_monitor}	natural_monitor	:PTR TO monitorspec
	{progdata}	progdata	:APTR
	{extsprites}	extsprites	:UBYTE
	{pad3}	pad3	:UBYTE
	{gfxflags}	gfxflags	:UINT
	{vbcounter}	vbcounter	:ULONG
	{hashtablesemaphore}	hashtablesemaphore	:PTR TO ss
	{hwemul}	hwemul[9]	:ARRAY OF PTR TO ULONG
	{hwemul[0]} chunkytoplanarptr:PTR TO ULONG	->alias
ENDOBJECT

/* Values for GfxBase->DisplayFlags */
NATIVE {NTSC}		CONST NTSC		= 1
NATIVE {GENLOC}		CONST GENLOC		= 2
NATIVE {PAL}		CONST PAL		= 4
NATIVE {TODA_SAFE}	CONST TODA_SAFE	= 8
NATIVE {REALLY_PAL}	CONST REALLY_PAL	= 16	/* what is actual crystal frequency
				 (as opposed to what bootmenu set the agnus to)?
				 (V39) */
NATIVE {LPEN_SWAP_FRAMES}	CONST LPEN_SWAP_FRAMES	= 32

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
