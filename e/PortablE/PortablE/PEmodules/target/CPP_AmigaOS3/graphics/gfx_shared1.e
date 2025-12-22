OPT NATIVE, PREPROCESS
MODULE 'target/graphics/gfx_shared2'
MODULE 'target/exec/nodes', 'target/exec/semaphores', 'target/utility/tagitem', 'target/exec/types'

NATIVE {CopIns} OBJECT copins
    {OpCode}	opcode	:INT /* 0 = move, 1 = wait */
	{u3.nxtlist}	nxtlist	:PTR TO coplist
	{u3.u4.u1.VWaitPos}	vwaitpos	:INT	      /* vertical beam wait */
	{u3.u4.u1.DestAddr}	destaddr	:INT	      /* destination address of copper move */
	{u3.u4.u2.HWaitPos}	hwaitpos	:INT	      /* horizontal beam wait position */
	{u3.u4.u2.DestData}	destdata	:INT	      /* destination immediate data to send */
ENDOBJECT

NATIVE {CopList} OBJECT coplist
    {Next}	next	:PTR TO coplist  /* next block for this copper list */
    {_CopList}	coplist_	:PTR TO coplist	/* system use */
    {_ViewPort}	viewport_	:PTR TO viewport    /* system use */
    {CopIns}	copins	:PTR TO copins /* start of this block */
    {CopPtr}	copptr	:PTR TO copins /* intermediate ptr */
    {CopLStart}	coplstart	:PTR TO UINT     /* mrgcop fills this in for Long Frame*/
    {CopSStart}	copsstart	:PTR TO UINT     /* mrgcop fills this in for Short Frame*/
    {Count}	count	:INT	   /* intermediate counter */
    {MaxCount}	maxcount	:INT	   /* max # of copins for this block */
    {DyOffset}	dyoffset	:INT	   /* offset this copper list vertical waits */
->#ifdef V1_3
->    {Cop2Start}	cop2start	:PTR TO UINT
->    {Cop3Start}	cop3start	:PTR TO UINT
->    {Cop4Start}	cop4start	:PTR TO UINT
->    {Cop5Start}	cop5start	:PTR TO UINT
->#endif
    {SLRepeat}	slrepeat	:UINT
    {Flags}	flags	:UINT
ENDOBJECT

NATIVE {UCopList} OBJECT ucoplist
    {Next}	next	:PTR TO ucoplist
    {FirstCopList}	firstcoplist	:PTR TO coplist /* head node of this copper list */
    {CopList}	coplist	:PTR TO coplist	   /* node in use */
ENDOBJECT


NATIVE {ViewPort} OBJECT viewport
	{Next}	next	:PTR TO viewport
	{ColorMap}	colormap	:PTR TO colormap	/* table of colors for this viewport */
					/* if this is nil, MakeVPort assumes default values */
	{DspIns}	dspins	:PTR TO coplist	/* used by MakeVPort() */
	{SprIns}	sprins	:PTR TO coplist	/* used by sprite stuff */
	{ClrIns}	clrins	:PTR TO coplist	/* used by sprite stuff */
	{UCopIns}	ucopins	:PTR TO ucoplist	/* User copper list */
	{DWidth}	dwidth	:INT
	{DHeight}	dheight	:INT
	{DxOffset}	dxoffset	:INT
	{DyOffset}	dyoffset	:INT
	{Modes}	modes	:UINT
	{SpritePriorities}	spritepriorities	:UBYTE
	{ExtendedModes}	extendedmodes	:UBYTE
	{RasInfo}	rasinfo	:PTR TO rasinfo
ENDOBJECT

NATIVE {ViewPortExtra} OBJECT viewportextra
	{n}	xln	:xln
	{ViewPort}	viewport	:PTR TO viewport	/* backwards link */
	{DisplayClip}	displayclip	:rectangle	/* MakeVPort display clipping information */
	/* These are added for V39 */
	{VecTable}	vectable	:APTR		/* Private */
	{DriverData}	driverdata[2]	:ARRAY OF APTR
	{Flags}	flags	:UINT
	{Origin}	origin[2]	:ARRAY OF tpoint		/* First visible point relative to the DClip.
					 * One for each possible playfield.
					 */
	{cop1ptr}	cop1ptr	:ULONG			/* private */
	{cop2ptr}	cop2ptr	:ULONG			/* private */
ENDOBJECT

NATIVE {RasInfo} OBJECT rasinfo
   {Next}	next	:PTR TO rasinfo	    /* used for dualpf */
   {BitMap}	bitmap	:PTR TO bitmap
   {RxOffset}	rxoffset	:INT
	{RyOffset}	ryoffset	:INT	   /* scroll offsets in this BitMap */
ENDOBJECT

NATIVE {ColorMap} OBJECT colormap
	{Flags}	flags	:UBYTE
	{Type}	type	:UBYTE
	{Count}	count	:UINT
	{ColorTable}	colortable	:APTR
	{cm_vpe}	vpe	:PTR TO viewportextra
	{LowColorBits}	lowcolorbits	:APTR
	{TransparencyPlane}	transparencyplane	:UBYTE
	{SpriteResolution}	spriteresolution	:UBYTE
	{SpriteResDefault}	spriteresdefault	:UBYTE	/* what resolution you get when you have set SPRITERESN_DEFAULT */
	{AuxFlags}	auxflags	:UBYTE
	{cm_vp}	vp	:PTR TO viewport
	{NormalDisplayInfo}	normaldisplayinfo	:APTR
	{CoerceDisplayInfo}	coercedisplayinfo	:APTR
	{cm_batch_items}	batch_items	:ARRAY OF tagitem
	{VPModeID}	vpmodeid	:ULONG
	{PalExtra}	palextra	:PTR TO paletteextra
	{SpriteBase_Even}	spritebase_even	:UINT
	{SpriteBase_Odd}	spritebase_odd	:UINT
	{Bp_0_base}	bp_0_base	:UINT
	{Bp_1_base}	bp_1_base	:UINT

ENDOBJECT

NATIVE {PaletteExtra} OBJECT paletteextra
	{pe_Semaphore}	semaphore	:ss		/* shared semaphore for arbitration	*/
	{pe_FirstFree}	firstfree	:UINT				/* *private*				*/
	{pe_NFree}	nfree	:UINT				/* number of free colors		*/
	{pe_FirstShared}	firstshared	:UINT				/* *private*				*/
	{pe_NShared}	nshared	:UINT				/* *private*				*/
	{pe_RefCnt}	refcnt	:PTR TO UBYTE				/* *private*				*/
	{pe_AllocList}	alloclist	:PTR TO UBYTE				/* *private*				*/
	{pe_ViewPort}	viewport	:PTR TO viewport			/* back pointer to viewport		*/
	{pe_SharableColors}	sharablecolors	:UINT			/* the number of sharable colors.	*/
ENDOBJECT


->OBJECT rectangle

->OBJECT tpoint

->OBJECT bitmap


NATIVE {ExtendedNode} OBJECT xln
	{xln_Succ}	succ	:PTR TO ln
	{xln_Pred}	pred	:PTR TO ln
	{xln_Type}	type	:UBYTE
	{xln_Pri}	pri	:BYTE
	{xln_Name}	name	:ARRAY OF CHAR
	{xln_Subsystem}	subsystem	:UBYTE
	{xln_Subtype}	subtype	:UBYTE
	{xln_Library}	library	:VALUE
	{xln_Init}	init	:NATIVE {LONG	(*)()} PTR
ENDOBJECT
