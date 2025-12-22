OPT NATIVE, PREPROCESS
MODULE 'target/graphics/gfx_shared2'
MODULE 'target/exec/nodes', 'target/exec/semaphores', 'target/utility/tagitem', 'target/exec/types'

NATIVE {CopIns} OBJECT copins
    {OpCode}	opcode	:INT

    {u3.nxtlist}	nxtlist	:PTR TO coplist
    {u3.u4.u1.VWaitPos}	vwaitpos	:INT
    {u3.u4.u1.DestAddr}	destaddr	:INT
    {u3.u4.u2.HWaitPos}	hwaitpos	:INT
    {u3.u4.u2.DestData}	destdata	:INT
ENDOBJECT

NATIVE {CopList} OBJECT coplist
    {Next}	next	:PTR TO coplist
    {_CopList}	coplist_	:PTR TO coplist
    {_ViewPort}	viewport_	:PTR TO viewport
    {CopIns}	copins	:PTR TO copins
    {CopPtr}	copptr	:PTR TO copins

    {CopLStart}	coplstart	:PTR TO UINT
    {SopSStart}	copsstart	:PTR TO UINT
    {Count}	count	:INT
    {MaxCount}	maxcount	:INT
    {DyOffset}	dyoffset	:INT
->#ifdef V1_3
->    {Cop2Start}	slrepeat	:PTR TO UINT
->    {Cop3Start}	flags	:PTR TO UINT
->    {Cop4Start}	cop4start	:PTR TO UINT
->    {Cop5Start}	cop5start	:PTR TO UINT
->#endif
    {SLRepeat}	slrepeat	:UINT
    {Flags}	flags	:UINT    /* see below */
ENDOBJECT

NATIVE {UCopList} OBJECT ucoplist
    {Next}	next	:PTR TO ucoplist
    {FirstCopList}	firstcoplist	:PTR TO coplist
    {CopList}	coplist	:PTR TO coplist
ENDOBJECT


NATIVE {ViewPort} OBJECT viewport
    {Next}	next	:PTR TO viewport

    {ColorMap}	colormap	:PTR TO colormap
    {DspIns}	dspins	:PTR TO coplist
    {SprIns}	sprins	:PTR TO coplist
    {ClrIns}	clrins	:PTR TO coplist
    {UCopIns}	ucopins	:PTR TO ucoplist

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

    {ViewPort}	viewport	:PTR TO viewport
    {DisplayClip}	displayclip	:rectangle

    {VecTable}	vectable	:APTR
    {DriverData}	driverdata[2]	:ARRAY OF APTR
    {Flags}	flags	:UINT
    {Origin}	origin[2]	:ARRAY OF tpoint
    {cop1ptr}	cop1ptr	:ULONG
    {cop2ptr}	cop2ptr	:ULONG
ENDOBJECT

NATIVE {ColorMap} OBJECT colormap
    {Flags}	flags	:UBYTE      /* see below */
    {Type}	type	:UBYTE       /* see below */
    {Count}	count	:UINT
    {ColorTable}	colortable	:APTR

    {cm_vpe}	vpe	:PTR TO viewportextra

    {LowColorBits}	lowcolorbits	:APTR
    {TransparencyPlane}	transparencyplane	:UBYTE
    {SpriteResolution}	spriteresolution	:UBYTE  /* see below */
    {SpriteResDefault}	spriteresdefault	:UBYTE
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

NATIVE {RasInfo} OBJECT rasinfo
    {Next}	next	:PTR TO rasinfo
    {BitMap}	bitmap	:PTR TO bitmap

    {RxOffset}	rxoffset	:INT
    {RyOffset}	ryoffset	:INT
ENDOBJECT

NATIVE {PaletteExtra} OBJECT paletteextra
	{pe_Semaphore}	semaphore	:ss
	{pe_FirstFree}	firstfree	:UINT
	{pe_NFree}	nfree	:UINT
	{pe_FirstShared}	firstshared	:UINT
	{pe_NShared}	nshared	:UINT
	{pe_RefCnt}	refcnt	:PTR TO UBYTE
	{pe_AllocList}	alloclist	:PTR TO UBYTE
	{pe_ViewPort}	viewport	:PTR TO viewport
	{pe_SharableColors}	sharablecolors	:UINT
ENDOBJECT


->OBJECT rectangle

->OBJECT tpoint

->OBJECT bitmap


NATIVE {ExtendedNode} OBJECT xln
    {xln_Succ}	succ	:PTR TO ln
    {xln_Pred}	pred	:PTR TO ln

    {xln_Type}	type	:UBYTE      /* see below */
    {xln_Pri}	pri	:BYTE
    {xln_Name}	name	:ARRAY OF CHAR
    {xln_Subsystem}	subsystem	:UBYTE
    {xln_Subtype}	subtype	:UBYTE
    {xln_Library}	library	:VALUE
    {xln_Init}	init	:NATIVE {LONG (*)()} PTR
ENDOBJECT
