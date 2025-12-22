/* $VER: view.h 39.34 (31.5.1993) */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared1'
MODULE 'target/exec/types', 'target/exec/semaphores', 'target/graphics/gfx', 'target/graphics/copper', 'target/graphics/gfxnodes', 'target/graphics/monitor', 'target/graphics/displayinfo', 'target/hardware/custom'
MODULE 'target/exec/ports'
{MODULE 'graphics/view'}

->"OBJECT viewport" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')

NATIVE {view} OBJECT view
	{viewport}	viewport	:PTR TO viewport
	{lofcprlist}	lofcprlist	:PTR TO cprlist   /* used for interlaced and noninterlaced */
	{shfcprlist}	shfcprlist	:PTR TO cprlist   /* only used during interlace */
	{dyoffset}	dyoffset	:INT
	{dxoffset}	dxoffset	:INT   /* for complete View positioning */
				   /* offsets are +- adjustments to standard #s */
	{modes}	modes	:UINT		   /* such as INTERLACE, GENLOC */
ENDOBJECT

NATIVE {viewextra} OBJECT viewextra
	{xln}	xln	:xln
	{view}	view	:PTR TO view		/* backwards link */
	{monitor}	monitor	:PTR TO monitorspec	/* monitors for this view */
	{topline}	topline	:UINT
ENDOBJECT

->"OBJECT viewportextra" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')

/* All these VPXF_ flags are private */
NATIVE {VPXB_FREE_ME}		CONST VPXB_FREE_ME		= 0
NATIVE {VPXF_FREE_ME}		CONST VPXF_FREE_ME		= $1
NATIVE {VPXB_VP_LAST}		CONST VPXB_VP_LAST		= 1
NATIVE {VPXF_VP_LAST}		CONST VPXF_VP_LAST		= $2
NATIVE {VPXB_STRADDLES_256}	CONST VPXB_STRADDLES_256	= 4
NATIVE {VPXF_STRADDLES_256}	CONST VPXF_STRADDLES_256	= $10
NATIVE {VPXB_STRADDLES_512}	CONST VPXB_STRADDLES_512	= 5
NATIVE {VPXF_STRADDLES_512}	CONST VPXF_STRADDLES_512	= $20


NATIVE {EXTEND_VSTRUCT}	CONST EXTEND_VSTRUCT	= $1000	/* unused bit in Modes field of View */

NATIVE {VPF_A2024}	      CONST VPF_A2024	      = $40	/* VP?_ fields internal only */
NATIVE {VPF_TENHZ}	      CONST VPF_TENHZ	      = $20
NATIVE {VPB_A2024}	      CONST VPB_A2024	      = 6
NATIVE {VPB_TENHZ}	      CONST VPB_TENHZ	      = 4

/* defines used for Modes in IVPargs */

NATIVE {GENLOCK_VIDEO}	CONST GENLOCK_VIDEO	= $0002
NATIVE {V_LACE}		CONST V_LACE		= $0004
NATIVE {V_DOUBLESCAN}	CONST V_DOUBLESCAN	= $0008
NATIVE {V_SUPERHIRES}	CONST V_SUPERHIRES	= $0020
NATIVE {V_PFBA}		CONST V_PFBA		= $0040
NATIVE {V_EXTRA_HALFBRITE} CONST V_EXTRA_HALFBRITE = $0080
NATIVE {GENLOCK_AUDIO}	CONST GENLOCK_AUDIO	= $0100
NATIVE {V_DUALPF}		CONST V_DUALPF		= $0400
NATIVE {V_HAM}		CONST V_HAM		= $0800
NATIVE {V_EXTENDED_MODE}	CONST V_EXTENDED_MODE	= $1000
NATIVE {V_VP_HIDE}	CONST V_VP_HIDE	= $2000
NATIVE {V_SPRITES}	CONST V_SPRITES	= $4000
NATIVE {V_HIRES}		CONST V_HIRES		= $8000

->"OBJECT rasinfo" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')

->"OBJECT colormap" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')

NATIVE {COLORMAP_TYPE_V1_2}	CONST COLORMAP_TYPE_V1_2	= $00
NATIVE {COLORMAP_TYPE_V1_4}	CONST COLORMAP_TYPE_V1_4	= $01
NATIVE {COLORMAP_TYPE_V36} CONST COLORMAP_TYPE_V36 = COLORMAP_TYPE_V1_4	/* use this definition */
NATIVE {COLORMAP_TYPE_V39}	CONST COLORMAP_TYPE_V39	= $02

/* Flags variable */
NATIVE {COLORMAP_TRANSPARENCY}	CONST COLORMAP_TRANSPARENCY	= $01
NATIVE {COLORPLANE_TRANSPARENCY}	CONST COLORPLANE_TRANSPARENCY	= $02
NATIVE {BORDER_BLANKING}		CONST BORDER_BLANKING		= $04
NATIVE {BORDER_NOTRANSPARENCY}	CONST BORDER_NOTRANSPARENCY	= $08
NATIVE {VIDEOCONTROL_BATCH}	CONST VIDEOCONTROL_BATCH	= $10
NATIVE {USER_COPPER_CLIP}	CONST USER_COPPER_CLIP	= $20
CONST BORDERSPRITES	= $40

NATIVE {CMF_CMTRANS}	CONST CMF_CMTRANS	= 0
NATIVE {CMF_CPTRANS}	CONST CMF_CPTRANS	= 1
NATIVE {CMF_BRDRBLNK}	CONST CMF_BRDRBLNK	= 2
NATIVE {CMF_BRDNTRAN}	CONST CMF_BRDNTRAN	= 3
NATIVE {CMF_BRDRSPRT}	CONST CMF_BRDRSPRT	= 6

NATIVE {SPRITERESN_ECS}		CONST SPRITERESN_ECS		= 0
/* ^140ns, except in 35ns viewport, where it is 70ns. */
NATIVE {SPRITERESN_140NS}	CONST SPRITERESN_140NS	= 1
NATIVE {SPRITERESN_70NS}		CONST SPRITERESN_70NS		= 2
NATIVE {SPRITERESN_35NS}		CONST SPRITERESN_35NS		= 3
NATIVE {SPRITERESN_DEFAULT}	CONST SPRITERESN_DEFAULT	= -1

/* AuxFlags : */
NATIVE {CMAB_FULLPALETTE} CONST CMAB_FULLPALETTE = 0
NATIVE {CMAF_FULLPALETTE} CONST CMAF_FULLPALETTE = $1
NATIVE {CMAB_NO_INTERMED_UPDATE} CONST CMAB_NO_INTERMED_UPDATE = 1
NATIVE {CMAF_NO_INTERMED_UPDATE} CONST CMAF_NO_INTERMED_UPDATE = $2
NATIVE {CMAB_NO_COLOR_LOAD} CONST CMAB_NO_COLOR_LOAD = 2
NATIVE {CMAF_NO_COLOR_LOAD} CONST CMAF_NO_COLOR_LOAD = $4
NATIVE {CMAB_DUALPF_DISABLE} CONST CMAB_DUALPF_DISABLE = 3
NATIVE {CMAF_DUALPF_DISABLE} CONST CMAF_DUALPF_DISABLE = $8


->"OBJECT paletteextra" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')

/* flags values for ObtainPen */

NATIVE {PENB_EXCLUSIVE} CONST PENB_EXCLUSIVE = 0
NATIVE {PENB_NO_SETCOLOR} CONST PENB_NO_SETCOLOR = 1

NATIVE {PENF_EXCLUSIVE} CONST PENF_EXCLUSIVE = $1
NATIVE {PENF_NO_SETCOLOR} CONST PENF_NO_SETCOLOR = $2

/* obsolete names for PENF_xxx flags: */

NATIVE {PEN_EXCLUSIVE} CONST PEN_EXCLUSIVE = PENF_EXCLUSIVE
NATIVE {PEN_NO_SETCOLOR} CONST PEN_NO_SETCOLOR = PENF_NO_SETCOLOR

/* precision values for ObtainBestPen : */

NATIVE {PRECISION_EXACT}	CONST PRECISION_EXACT	= -1
NATIVE {PRECISION_IMAGE}	CONST PRECISION_IMAGE	= 0
NATIVE {PRECISION_ICON}	CONST PRECISION_ICON	= 16
NATIVE {PRECISION_GUI}	CONST PRECISION_GUI	= 32


/* tags for ObtainBestPen: */
NATIVE {OBP_PRECISION} CONST OBP_PRECISION = $84000000
NATIVE {OBP_FAILIFBAD} CONST OBP_FAILIFBAD = $84000001


NATIVE {MVP_OK}		CONST MVP_OK		= 0	/* you want to see this one */
NATIVE {MVP_NO_MEM}	CONST MVP_NO_MEM	= 1	/* insufficient memory for intermediate workspace */
NATIVE {MVP_NO_VPE}	CONST MVP_NO_VPE	= 2	/* ViewPort does not have a ViewPortExtra, and
				 * insufficient memory to allocate a temporary one.
				 */
NATIVE {MVP_NO_DSPINS}	CONST MVP_NO_DSPINS	= 3	/* insufficient memory for intermidiate copper
				 * instructions.
				 */
NATIVE {MVP_NO_DISPLAY}	CONST MVP_NO_DISPLAY	= 4	/* BitMap data is misaligned for this viewport's
				 * mode and depth - see AllocBitMap().
				 */
NATIVE {MVP_OFF_BOTTOM}	CONST MVP_OFF_BOTTOM	= 5	/* PRIVATE - you will never see this. */


NATIVE {MCOP_OK}		CONST MCOP_OK		= 0	/* you want to see this one */
NATIVE {MCOP_NO_MEM}	CONST MCOP_NO_MEM	= 1	/* insufficient memory to allocate the system
				 * copper lists.
				 */
NATIVE {MCOP_NOP}	CONST MCOP_NOP	= 2	/* MrgCop() did not merge any copper lists
				 * (eg, no ViewPorts in the list, or all marked as
				 * hidden).
				 */

NATIVE {dbufinfo} OBJECT dbufinfo
	{link1}	link1	:APTR
	{count1}	count1	:ULONG
	{safemessage}	safemessage	:mn		/* replied to when safe to write to old bitmap */
	{userdata1}	userdata1	:APTR			/* first user data */

	{link2}	link2	:APTR
	{count2}	count2	:ULONG
	{dispmessage}	dispmessage	:mn	/* replied to when new bitmap has been displayed at least
							once */
	{userdata2}	userdata2	:APTR			/* second user data */
	{matchlong}	matchlong	:ULONG
	{copptr1}	copptr1	:APTR
	{copptr2}	copptr2	:APTR
	{copptr3}	copptr3	:APTR
	{beampos1}	beampos1	:UINT
	{beampos2}	beampos2	:UINT
ENDOBJECT
