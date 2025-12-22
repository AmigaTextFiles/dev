/* $VER: composite.h 53.11 (31.1.2010) */
OPT NATIVE
OPT POINTER, PREPROCESS
MODULE 'target/exec/types'
MODULE 'target/utility/tagitem'
{#include <graphics/composite.h>}
NATIVE {GRAPHICS_COMPOSITE_H} CONST

NATIVE {enPDOperator} DEF
NATIVE {COMPOSITE_Clear}				CONST COMPOSITE_CLEAR				= 0
NATIVE {COMPOSITE_Src}				CONST COMPOSITE_SRC				= 1
NATIVE {COMPOSITE_Dest}				CONST COMPOSITE_DEST				= 2
NATIVE {COMPOSITE_Src_Over_Dest}		CONST COMPOSITE_SRC_OVER_DEST		= 3
NATIVE {COMPOSITE_Dest_Over_Src}		CONST COMPOSITE_DEST_OVER_SRC		= 4
NATIVE {COMPOSITE_Src_In_Dest}		CONST COMPOSITE_SRC_IN_DEST		= 5
NATIVE {COMPOSITE_Dest_In_Src}		CONST COMPOSITE_DEST_IN_SRC		= 6
NATIVE {COMPOSITE_Src_Out_Dest}		CONST COMPOSITE_SRC_OUT_DEST		= 7
NATIVE {COMPOSITE_Dest_Out_Src}		CONST COMPOSITE_DEST_OUT_SRC		= 8
NATIVE {COMPOSITE_Src_Atop_Dest}		CONST COMPOSITE_SRC_ATOP_DEST		= 9
NATIVE {COMPOSITE_Dest_Atop_Src}		CONST COMPOSITE_DEST_ATOP_SRC		= 10
NATIVE {COMPOSITE_Src_Xor_Dest}		CONST COMPOSITE_SRC_XOR_DEST		= 11
NATIVE {COMPOSITE_Plus}				CONST COMPOSITE_PLUS				= 12

NATIVE {COMPOSITE_NumOperators} 		CONST COMPOSITE_NUMOPERATORS 		= 13


/* Tag items for the Composite call */
NATIVE {COMPTAG_Base}	CONST COMPTAG_BASE	= TAG_USER

/* (uint32) X clip coordinate on source bitmap (defaults to 0) */
NATIVE {COMPTAG_SrcX}			CONST COMPTAG_SRCX			= (COMPTAG_BASE + 0)

/* (uint32) Y clip coordinate on source bitmap (defaults to 0) */
NATIVE {COMPTAG_SrcY}			CONST COMPTAG_SRCY			= (COMPTAG_BASE + 1)

/* (uint32) Width of clip rectangle on source (defaults to full width) */
NATIVE {COMPTAG_SrcWidth}		CONST COMPTAG_SRCWIDTH		= (COMPTAG_BASE + 2)

/* (uint32) Height of clip rectangle on source (defaults to full height) */
NATIVE {COMPTAG_SrcHeight}		CONST COMPTAG_SRCHEIGHT		= (COMPTAG_BASE + 3)

/* (uint32) X clip coordinate on dest bitmap (defaults to 0) */
NATIVE {COMPTAG_DestX}			CONST COMPTAG_DESTX			= (COMPTAG_BASE + 4)

/* (uint32) Y clip coordinate on dest bitmap (defaults to 0) */
NATIVE {COMPTAG_DestY}			CONST COMPTAG_DESTY			= (COMPTAG_BASE + 5)

/* (uint32) Width of clip rectangle on dest (defaults to full width) */
NATIVE {COMPTAG_DestWidth}		CONST COMPTAG_DESTWIDTH		= (COMPTAG_BASE + 6)

/* (uint32) Height of clip rectangle on dest (defaults to full height) */
NATIVE {COMPTAG_DestHeight}		CONST COMPTAG_DESTHEIGHT		= (COMPTAG_BASE + 7)

/* (fixpoint) (additional) Alpha for source bitmap (no default) */
NATIVE {COMPTAG_SrcAlpha}		CONST COMPTAG_SRCALPHA		= (COMPTAG_BASE + 8)

/* (fixpoint) (additional) Alpha for destination bitmap (no default) */
NATIVE {COMPTAG_DestAlpha}		CONST COMPTAG_DESTALPHA		= (COMPTAG_BASE + 9)

/* (fixpoint) X scale factor for source bitmap (defaults to 1.0) */
NATIVE {COMPTAG_ScaleX}			CONST COMPTAG_SCALEX			= (COMPTAG_BASE + 10)

/* (fixpoint) Y scale factor for source bitmap (defaults to 1.0) */
NATIVE {COMPTAG_ScaleY}			CONST COMPTAG_SCALEY			= (COMPTAG_BASE + 11)

/* (struct Bitmap *) Alpha mask for source. Specifying this tag overrides any
 * alpha that might be present in the source bitmap.
 */
NATIVE {COMPTAG_SrcAlphaMask}	CONST COMPTAG_SRCALPHAMASK	= (COMPTAG_BASE + 12)

/* (struct Bitmap *) Alpha mask for the destination. Specifying this tag
 * overrides any alpha that might be present in the destination bitmap.
 */
NATIVE {COMPTAG_DestAlphaMask}	CONST COMPTAG_DESTALPHAMASK	= (COMPTAG_BASE + 13)

/* (uint32, see defines below) Specifies a set of flags that may modify the
 * operation. See the defines below
 */
NATIVE {COMPTAG_Flags}				CONST COMPTAG_FLAGS				= (COMPTAG_BASE + 18)

/* (int32) X Coordinate on the destination bitmap that the operation should be
 * applied to. Defaults to zero.
 */
NATIVE {COMPTAG_OffsetX}				CONST COMPTAG_OFFSETX				= (COMPTAG_BASE + 20)

/* (int32) Y Coordinate on the destination bitmap that the operation should be
 * applied to. Defaults to zero.
 */
NATIVE {COMPTAG_OffsetY}				CONST COMPTAG_OFFSETY				= (COMPTAG_BASE + 21)

/* (struct BitMap *) when the source and/or destination bitmaps are located in
 * main memory, this tag tells the graphics system to upload the bitmaps to
 * the same board the friend bitmap is located on.
 */
NATIVE {COMPTAG_FriendBitMap}		CONST COMPTAG_FRIENDBITMAP		= (COMPTAG_BASE + 22)

/* (uint32) the same as above, but a DisplayID is used as reference to the board
 * and not a bitmap.
 */
NATIVE {COMPTAG_DisplayID}			CONST COMPTAG_DISPLAYID			= (COMPTAG_BASE + 23)

/* (uint32) the X/Y coordinates on the src alpha map to use for compositing. If not
 * specified, use the same as the SrcX and SrcY
 */
NATIVE {COMPTAG_SrcAlphaX}			CONST COMPTAG_SRCALPHAX			= (COMPTAG_BASE + 14)
NATIVE {COMPTAG_SrcAlphaY}			CONST COMPTAG_SRCALPHAY			= (COMPTAG_BASE + 15)

/* (uint32) the X/Y coordinates on the destination alpha map to use. If not
 * specified, use the DestX and DestY
 */
NATIVE {COMPTAG_DestAlphaX}			CONST COMPTAG_DESTALPHAX			= (COMPTAG_BASE + 16)
NATIVE {COMPTAG_DestAlphaY}			CONST COMPTAG_DESTALPHAY			= (COMPTAG_BASE + 17)

/*
 * The following group of tag items deals with direct triangle mapping. Read the
 * autodoc for a detailed explanation
 */
NATIVE {COMPTAG_VertexArray}			CONST COMPTAG_VERTEXARRAY			= (COMPTAG_BASE + 30)
NATIVE {COMPTAG_IndexArray}			CONST COMPTAG_INDEXARRAY			= (COMPTAG_BASE + 31)
NATIVE {COMPTAG_VertexFormat}		CONST COMPTAG_VERTEXFORMAT		= (COMPTAG_BASE + 32)
NATIVE {COMPTAG_NumTriangles}		CONST COMPTAG_NUMTRIANGLES		= (COMPTAG_BASE + 33)

/*
 * This group of tag items can be used to specify up to four colors, either
 * as an 32 bit ARGB value, or as a set of discreet fixpoint numbers.
 *
 * The fixpoint numbers range is 0 to 1. Specifying a fixpoint component
 * overrides the ARGB value completely.
 */
NATIVE {COMPTAG_Color0}				CONST COMPTAG_COLOR0				= (COMPTAG_BASE + 40)
NATIVE {COMPTAG_Color1}				CONST COMPTAG_COLOR1				= (COMPTAG_BASE + 41)
NATIVE {COMPTAG_Color2}				CONST COMPTAG_COLOR2				= (COMPTAG_BASE + 42)
NATIVE {COMPTAG_Color3}				CONST COMPTAG_COLOR3				= (COMPTAG_BASE + 43)

NATIVE {COMPTAG_Color0_Red}			CONST COMPTAG_COLOR0_RED			= (COMPTAG_BASE + 44)
NATIVE {COMPTAG_Color0_Green}		CONST COMPTAG_COLOR0_GREEN		= (COMPTAG_BASE + 45)
NATIVE {COMPTAG_Color0_Blue}			CONST COMPTAG_COLOR0_BLUE			= (COMPTAG_BASE + 46)
NATIVE {COMPTAG_Color0_Alpha}		CONST COMPTAG_COLOR0_ALPHA		= (COMPTAG_BASE + 47)

NATIVE {COMPTAG_Color1_Red}			CONST COMPTAG_COLOR1_RED			= (COMPTAG_BASE + 48)
NATIVE {COMPTAG_Color1_Green}		CONST COMPTAG_COLOR1_GREEN		= (COMPTAG_BASE + 49)
NATIVE {COMPTAG_Color1_Blue}			CONST COMPTAG_COLOR1_BLUE			= (COMPTAG_BASE + 50)
NATIVE {COMPTAG_Color1_Alpha}		CONST COMPTAG_COLOR1_ALPHA		= (COMPTAG_BASE + 51)

NATIVE {COMPTAG_Color2_Red}			CONST COMPTAG_COLOR2_RED			= (COMPTAG_BASE + 52)
NATIVE {COMPTAG_Color2_Green}		CONST COMPTAG_COLOR2_GREEN		= (COMPTAG_BASE + 53)
NATIVE {COMPTAG_Color2_Blue}			CONST COMPTAG_COLOR2_BLUE			= (COMPTAG_BASE + 54)
NATIVE {COMPTAG_Color2_Alpha}		CONST COMPTAG_COLOR2_ALPHA		= (COMPTAG_BASE + 55)

NATIVE {COMPTAG_Color3_Red}			CONST COMPTAG_COLOR3_RED			= (COMPTAG_BASE + 56)
NATIVE {COMPTAG_Color3_Green}		CONST COMPTAG_COLOR3_GREEN		= (COMPTAG_BASE + 57)
NATIVE {COMPTAG_Color3_Blue}			CONST COMPTAG_COLOR3_BLUE			= (COMPTAG_BASE + 58)
NATIVE {COMPTAG_Color3_Alpha}		CONST COMPTAG_COLOR3_ALPHA		= (COMPTAG_BASE + 59)


/*
 * Reserved
 */
NATIVE {COMPTAG_Private}				CONST COMPTAG_PRIVATE				= (COMPTAG_BASE + 34)
NATIVE {COMPTAG_Private2}			CONST COMPTAG_PRIVATE2			= (COMPTAG_BASE + 35)

/* Vertex Array format flags */
NATIVE {COMPVF_STW0_Present}			CONST COMPVF_STW0_PRESENT			= $02
NATIVE {COMPVF_STW1_Present}			CONST COMPVF_STW1_PRESENT			= $04

/*
 * Flags for the COMPTAG_Flags tag item
 *
 * Currently defined flags are:
 * COMPFLAG_SrcAlphaOverride - If set, the value specified in SrcAlpha overrides
 * 		the value in the source bitmap, which means that the source bitmap is
 *      assumed to have a constant alpha over the entire image. If not set,
 * 		the SrcAlpha value is used to modulate/scale any other alpha channel.
 * COMPFLAG_DestAlphaOverride - Like COMPFLAG_SrcAlphaOverride, for the
 * 		destination bitmap.
 * COMPFLAG_SrcFilter - If set, enables bilinear filtering of the source bitmap
 * 		while scaling. While this can improve the quality of scaled images,
 * 		it might cause a dramatic slowdown when the operation is emulated
 * 		in software.
 * COMPFLAG_DestFilter - Like COMPFLAG_SrcFilter for the destination bitmap.
 * COMPFLAG_HardwareOnly - If set, the call will fail with an error code if
 * 		the operation cannot be performed in hardware. Reasons for this include
 * 		software-only bitmaps, unsupported color formats, etc.
 * COMPFLAG_ForceSoftware - If set, the operation will be emulated in software
 * 		even if it could be performed in hardware. This is mostly useful for
 * 		testing purposes. Setting this overrides COMPFLAG_HardwareOnly.
 * COMPFLAG_Color1Modulate - 	If set, then Color 1 is used as a modulate
 *  color for the src bitmap. That is, each color component of each pixel
 *  in the source bitmap is	multiplied with the color 1 (including its
 *  alpha). All other effects stay in effect. This flag can essentially
 *  be used to "tint" a bitmap in the given color
 */

NATIVE {COMPFLAG_SrcAlphaOverride}	CONST COMPFLAG_SRCALPHAOVERRIDE	= 1 SHL 0
NATIVE {COMPFLAG_DestAlphaOverride}	CONST COMPFLAG_DESTALPHAOVERRIDE	= 1 SHL 1
NATIVE {COMPFLAG_SrcFilter}			CONST COMPFLAG_SRCFILTER			= 1 SHL 2
NATIVE {COMPFLAG_HardwareOnly}		CONST COMPFLAG_HARDWAREONLY		= 1 SHL 3
NATIVE {COMPFLAG_IgnoreDestAlpha}	CONST COMPFLAG_IGNOREDESTALPHA	= 1 SHL 4
NATIVE {COMPFLAG_ForceSoftware}		CONST COMPFLAG_FORCESOFTWARE		= 1 SHL 7
NATIVE {COMPFLAG_Color1Modulate}		CONST COMPFLAG_COLOR1MODULATE		= 1 SHL 8

/* Helper Macros to convert to/from fixpoint numbers */
NATIVE {COMP_FIX_ONE} CONST COMP_FIX_ONE = $00010000
NATIVE {COMP_FLOAT_TO_FIX} CONST	->COMP_FLOAT_TO_FIX(f) (int32)((float)COMP_FIX_ONE * f)
NATIVE {COMP_FIX_TO_FLOAT} CONST	->COMP_FIX_TO_FLOAT(fix) ((float)fix / (float)COMP_FIX_ONE)
NATIVE {COMP_FIX_TO_UINT32} CONST	->COMP_FIX_TO_UINT32(fix) ((fix) / COMP_FIX_ONE)

#define COMP_FLOAT_TO_FIX(f) Comp_float_to_fix(f)
PROC Comp_float_to_fix(f:FLOAT) IS NATIVE {COMP_FLOAT_TO_FIX(} f {)} ENDNATIVE !!VALUE

#define COMP_FIX_TO_FLOAT(fix) Comp_fix_to_float(fix)
PROC Comp_fix_to_float(fix) IS NATIVE {COMP_FIX_TO_FLOAT(} fix {)} ENDNATIVE !!FLOAT

#define COMP_FIX_TO_UINT32(fix) Comp_fix_to_uint32(fix)
PROC Comp_fix_to_uint32(fix) IS NATIVE {COMP_FIX_TO_UINT32(} fix {)} ENDNATIVE !!VALUE

/* Possible constants for Source */
NATIVE {COMPSRC_SOLIDCOLOR} CONST COMPSRC_SOLIDCOLOR = 1 !!VALUE!!PTR ->!!PTR TO bitmap

NATIVE {enCompositeError} DEF
NATIVE {COMPERR_Success}				CONST COMPERR_SUCCESS				= 0
NATIVE {COMPERR_Incompatible}		CONST COMPERR_INCOMPATIBLE		= 1 	/* Incompatible bitmaps for operation */
NATIVE {COMPERR_Value}				CONST COMPERR_VALUE				= 2 	/* An input value is out of range */
NATIVE {COMPERR_SoftwareFallback}	CONST COMPERR_SOFTWAREFALLBACK	= 3 	/* Operation would fall back to
	 								       software emulation and hardware
	 									   only was requested */
NATIVE {COMPERR_OutOfMemory}			CONST COMPERR_OUTOFMEMORY			= 4  /* The operation tried to allocate
	 									   memory but failed */
NATIVE {COMPERR_Generic}				CONST COMPERR_GENERIC				= 5  /* Some generic error has occurred */
NATIVE {COMPERR_UnknownOperator}		CONST COMPERR_UNKNOWNOPERATOR		= 6	/* Unknown operator specified */
NATIVE {COMPERR_MissingInput}		CONST COMPERR_MISSINGINPUT		= 7  /* Missing a mandatory tag item */
