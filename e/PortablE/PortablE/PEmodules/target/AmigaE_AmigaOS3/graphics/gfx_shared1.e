OPT NATIVE, PREPROCESS
MODULE 'target/graphics/gfx_shared2'
MODULE 'target/exec/nodes', 'target/exec/semaphores', 'target/utility/tagitem', 'target/exec/types'

NATIVE {copins} OBJECT copins
    {opcode}	opcode	:INT /* 0 = move, 1 = wait */
	{nxtlist}	nxtlist	:PTR TO coplist
	{vwaitpos}	vwaitpos	:INT	      /* vertical beam wait */
	{destaddr}	destaddr	:INT	      /* destination address of copper move */
	{hwaitpos}	hwaitpos	:INT	      /* horizontal beam wait position */
	{destdata}	destdata	:INT	      /* destination immediate data to send */
ENDOBJECT

NATIVE {coplist} OBJECT coplist
    {next}	next	:PTR TO coplist  /* next block for this copper list */
    {coplist_}	coplist_	:PTR TO coplist	/* system use */
    {viewport_}	viewport_	:PTR TO viewport    /* system use */
    {copins}	copins	:PTR TO copins /* start of this block */
    {copptr}	copptr	:PTR TO copins /* intermediate ptr */
    {coplstart}	coplstart	:PTR TO UINT     /* mrgcop fills this in for Long Frame*/
    {copsstart}	copsstart	:PTR TO UINT     /* mrgcop fills this in for Short Frame*/
    {count}	count	:INT	   /* intermediate counter */
    {maxcount}	maxcount	:INT	   /* max # of copins for this block */
    {dyoffset}	dyoffset	:INT	   /* offset this copper list vertical waits */

    {slrepeat}	slrepeat	:UINT
    {flags}	flags	:UINT
ENDOBJECT

NATIVE {ucoplist} OBJECT ucoplist
    {next}	next	:PTR TO ucoplist
    {firstcoplist}	firstcoplist	:PTR TO coplist /* head node of this copper list */
    {coplist}	coplist	:PTR TO coplist	   /* node in use */
ENDOBJECT


NATIVE {viewport} OBJECT viewport
	{next}	next	:PTR TO viewport
	{colormap}	colormap	:PTR TO colormap	/* table of colors for this viewport */
					/* if this is nil, MakeVPort assumes default values */
	{dspins}	dspins	:PTR TO coplist	/* used by MakeVPort() */
	{sprins}	sprins	:PTR TO coplist	/* used by sprite stuff */
	{clrins}	clrins	:PTR TO coplist	/* used by sprite stuff */
	{ucopins}	ucopins	:PTR TO ucoplist	/* User copper list */
	{dwidth}	dwidth	:INT
	{dheight}	dheight	:INT
	{dxoffset}	dxoffset	:INT
	{dyoffset}	dyoffset	:INT
	{modes}	modes	:UINT
	{spritepriorities}	spritepriorities	:UBYTE
	{extendedmodes}	extendedmodes	:UBYTE
	{rasinfo}	rasinfo	:PTR TO rasinfo
ENDOBJECT

NATIVE {viewportextra} OBJECT viewportextra
	{xln}	xln	:xln
	{viewport}	viewport	:PTR TO viewport	/* backwards link */
	{displayclip}	displayclip	:rectangle	/* MakeVPort display clipping information */
	/* These are added for V39 */
	{vectable}	vectable	:APTR		/* Private */
	{driverdata}	driverdata[2]	:ARRAY OF APTR
	{flags}	flags	:UINT
	{origin}	origin[2]	:ARRAY OF tpoint		/* First visible point relative to the DClip.
					 * One for each possible playfield.
					 */
	{cop1ptr}	cop1ptr	:ULONG			/* private */
	{cop2ptr}	cop2ptr	:ULONG			/* private */
ENDOBJECT

NATIVE {rasinfo} OBJECT rasinfo
   {next}	next	:PTR TO rasinfo	    /* used for dualpf */
   {bitmap}	bitmap	:PTR TO bitmap
   {rxoffset}	rxoffset	:INT
	{ryoffset}	ryoffset	:INT	   /* scroll offsets in this BitMap */
ENDOBJECT

NATIVE {colormap} OBJECT colormap
	{flags}	flags	:UBYTE
	{type}	type	:UBYTE
	{count}	count	:UINT
	{colortable}	colortable	:APTR
	{vpe}	vpe	:PTR TO viewportextra
	{lowcolorbits}	lowcolorbits	:APTR
	{transparencyplane}	transparencyplane	:UBYTE
	{spriteresolution}	spriteresolution	:UBYTE
	{spriteresdefault}	spriteresdefault	:UBYTE	/* what resolution you get when you have set SPRITERESN_DEFAULT */
	{auxflags}	auxflags	:UBYTE
	{vp}	vp	:PTR TO viewport
	{normaldisplayinfo}	normaldisplayinfo	:APTR
	{coercedisplayinfo}	coercedisplayinfo	:APTR
	{batch_items}	batch_items	:ARRAY OF tagitem
	{vpmodeid}	vpmodeid	:ULONG
	{palextra}	palextra	:PTR TO paletteextra
	{spritebase_even}	spritebase_even	:UINT
	{spritebase_odd}	spritebase_odd	:UINT
	{bp_0_base}	bp_0_base	:UINT
	{bp_1_base}	bp_1_base	:UINT

ENDOBJECT

NATIVE {paletteextra} OBJECT paletteextra
	{semaphore}	semaphore	:ss		/* shared semaphore for arbitration	*/
	{firstfree}	firstfree	:UINT				/* *private*				*/
	{nfree}	nfree	:UINT				/* number of free colors		*/
	{firstshared}	firstshared	:UINT				/* *private*				*/
	{nshared}	nshared	:UINT				/* *private*				*/
	{refcnt}	refcnt	:PTR TO UBYTE				/* *private*				*/
	{alloclist}	alloclist	:PTR TO UBYTE				/* *private*				*/
	{viewport}	viewport	:PTR TO viewport			/* back pointer to viewport		*/
	{sharablecolors}	sharablecolors	:UINT			/* the number of sharable colors.	*/
ENDOBJECT


->OBJECT rectangle

->OBJECT tpoint

->OBJECT bitmap


NATIVE {xln} OBJECT xln
	{succ}	succ	:PTR TO ln
	{pred}	pred	:PTR TO ln
	{type}	type	:UBYTE
	{pri}	pri	:BYTE
	{name}	name	:ARRAY OF CHAR
	{subsystem}	subsystem	:UBYTE
	{subtype}	subtype	:UBYTE
	{library}	library	:VALUE
	{init}	init	:PTR /*LONG	(*xln_Init)()*/
ENDOBJECT
