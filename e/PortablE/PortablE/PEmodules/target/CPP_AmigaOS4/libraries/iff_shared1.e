/* $Id: iff.h,v 23.2 93/05/24 16:03:28 chris Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/libraries/iff_shared2', 'target/libraries/iff_shared3', 'target/libraries/iff_shared4', 'target/libraries/iff_shared5', 'target/libraries/iff_shared6'
MODULE 'target/exec/types'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/datatypes/animationclass', 'target/datatypes/datatypes', 'target/datatypes/pictureclass', 'target/datatypes/soundclass'
{
#include <clib/iff_protos.h>	//this shouldn't really be needed
#include <proto/iff.h>
}
{
struct Library* IFFBase = NULL;
struct IffIFace* IIff = NULL;
}
NATIVE {LIBRARIES_IFF_H} CONST
NATIVE {PROTO_IFF_H} CONST

NATIVE {IFFBase} DEF iffbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IIff} DEF

PROC new()
	InitLibrary('iff.library', NATIVE {(struct Interface **) &IIff} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC


NATIVE {IFFNAME} CONST
STATIC iffname = 'iff.library'

NATIVE {IFFVERSION} CONST IFFVERSION = 23					/* Current library version */

/****************************************************************************
**	Error codes (returned by IFFL_IFFError())
*/

NATIVE {IFFL_ERROR_BADTASK}			CONST IFFL_ERROR_BADTASK			= -1	/* IFFL_IFFError() called by wrong task */
NATIVE {IFFL_ERROR_OPEN}				CONST IFFL_ERROR_OPEN				= 16	/* Can't open file */
NATIVE {IFFL_ERROR_READ}				CONST IFFL_ERROR_READ				= 17	/* Error reading file */
NATIVE {IFFL_ERROR_NOMEM}			CONST IFFL_ERROR_NOMEM			= 18	/* Not enough memory */
NATIVE {IFFL_ERROR_NOTIFF}			CONST IFFL_ERROR_NOTIFF			= 19	/* File is not an IFF file */
NATIVE {IFFL_ERROR_WRITE}			CONST IFFL_ERROR_WRITE			= 20	/* Error writing file */
NATIVE {IFFL_ERROR_NOILBM}			CONST IFFL_ERROR_NOILBM			= 24	/* IFF file is not of type ILBM */
NATIVE {IFFL_ERROR_NOBMHD}			CONST IFFL_ERROR_NOBMHD			= 25	/* BMHD chunk not found */
NATIVE {IFFL_ERROR_NOBODY}			CONST IFFL_ERROR_NOBODY			= 26	/* BODY chunk not found */
NATIVE {IFFL_ERROR_BADCOMPRESSION}	CONST IFFL_ERROR_BADCOMPRESSION	= 28	/* Unknown compression type */
NATIVE {IFFL_ERROR_NOANHD}			CONST IFFL_ERROR_NOANHD			= 29	/* ANHD chunk not found */
NATIVE {IFFL_ERROR_NODLTA}			CONST IFFL_ERROR_NODLTA			= 30	/* DLTA chunk not found */


/****************************************************************************
**	Common IFF IDs
*/

NATIVE {IFFL_MAKE_ID} CONST	->IFFL_MAKE_ID(a,b,c,d) ((ULONG)(a)<<24L|(ULONG)(b)<<16L|(c)<<8|(d))

/*
**	Generic IFF IDs
*/
->#ifndef ID_FORM		/* don't redefine these if iffparse.h is included */
->"CONST ID_FORM" is on-purposely missing from here (it can be found in 'libraries/iff_shared2')
->"CONST ID_CAT"  is on-purposely missing from here (it can be found in 'libraries/iff_shared2')
->"CONST ID_LIST" is on-purposely missing from here (it can be found in 'libraries/iff_shared2')
->"CONST ID_PROP" is on-purposely missing from here (it can be found in 'libraries/iff_shared2')
->#endif

/*
**	Specific IFF IDs
*/
->"CONST ID_ANIM" is on-purposely missing from here (it can be found in 'libraries/iff_shared6')
->"CONST ID_ANHD" is on-purposely missing from here (it can be found in 'libraries/iff_shared6')
NATIVE {ID_ANNO} CONST ID_ANNO = "ANNO"
->"CONST ID_BMHD" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')
->"CONST ID_BODY" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')
->"CONST ID_CAMG" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')
NATIVE {ID_CLUT} CONST ID_CLUT = "CLUT"
->"CONST ID_CMAP" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')
->"CONST ID_CRNG" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')
NATIVE {ID_CTBL} CONST ID_CTBL = "CTBL"
->"CONST ID_DLTA" is on-purposely missing from here (it can be found in 'libraries/iff_shared6')
->"CONST ID_ILBM" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')
NATIVE {ID_SHAM} CONST ID_SHAM = "SHAM"

->"CONST ID_8SVX" is on-purposely missing from here (it can be found in 'libraries/iff_shared5')
NATIVE {ID_ATAK} CONST ID_ATAK = "ATAK"
->#ifndef ID_NAME
->"CONST ID_NAME" is on-purposely missing from here (it can be found in 'libraries/iff_shared4')
->#endif
NATIVE {ID_RLSE} CONST ID_RLSE = "RLSE"
->"CONST ID_VHDR" is on-purposely missing from here (it can be found in 'libraries/iff_shared5')


/****************************************************************************
**	Modes for IFFL_OpenIFF()
*/

NATIVE {IFFL_MODE_READ}	CONST IFFL_MODE_READ	= 0
NATIVE {IFFL_MODE_WRITE}	CONST IFFL_MODE_WRITE	= 1


/****************************************************************************
**	Modes for IFFL_CompressBlock() and IFFL_DecompressBlock()
*/

NATIVE {IFFL_COMPR_NONE}		CONST IFFL_COMPR_NONE		= $0000		/* generic */
NATIVE {IFFL_COMPR_BYTERUN1}	CONST IFFL_COMPR_BYTERUN1	= $0001		/* ILBM */
NATIVE {IFFL_COMPR_FIBDELTA}	CONST IFFL_COMPR_FIBDELTA	= $0101		/* 8SVX */


/****************************************************************************
**	Structure definitions
*/

/*
**	The private IFF 'FileHandle' structure
*/
NATIVE {IFFL_HANDLE} CONST
TYPE IFFL_HANDLE IS NATIVE {IFFL_HANDLE} PTR


/*
**	Generic IFF chunk structure
*/
NATIVE {IFFL_Chunk} OBJECT iffl_chunk
	{ckID}	ckid	:VALUE
	{ckSize}	cksize	:VALUE
/*  UBYTE ckData[ckSize] (variable sized data) */
ENDOBJECT


/*
**	BMHD chunk (BitMapHeader) of ILBM files
*/
NATIVE {IFFL_BMHD} OBJECT bmh
	{w}	width	:UINT
	{h}	height	:UINT
	{x}	xpos	:INT
	{y}	ypos	:INT
	{nPlanes}	nplanes	:UBYTE
	{masking}	masking	:UBYTE
	{compression}	compression	:UBYTE
	{pad1}	pad1	:UBYTE
	{transparentColor}	transpcol	:UINT
	{xAspect}	xaspect	:UBYTE
	{yAspect}	yaspect	:UBYTE
	{pageWidth}	pagewidth	:INT
	{pageHeight}	pageheight	:INT
ENDOBJECT


/*
**	ANHD chunk (AnimHeader) of ANIM files
*/
NATIVE {IFFL_ANHD} OBJECT anh
	{Operation}	operation	:UBYTE
	{Mask}	mask	:UBYTE
	{W}	w	:UINT
	{H}	h	:UINT
	{X}	x	:INT
	{Y}	y	:INT
	{AbsTime}	abstime	:ULONG
	{RelTime}	reltime	:ULONG
	{Interleave}	interleave	:UBYTE
	{pad0}	pad0	:UBYTE
	{Bits}	bits	:ULONG
	{pad}	pad[16]	:ARRAY OF UBYTE
ENDOBJECT


/****************************************************************************
**	IFF library function prototypes (ANSI C)
*/

NATIVE {IFFL_CloseIFF} PROC
NATIVE {IFFL_CompressBlock} PROC
NATIVE {IFFL_DecodePic} PROC
NATIVE {IFFL_DecompressBlock} PROC
NATIVE {IFFL_FindChunk} PROC
NATIVE {IFFL_GetBMHD} PROC
NATIVE {IFFL_GetColorTab} PROC
NATIVE {IFFL_GetViewModes} PROC
NATIVE {IFFL_IFFError} PROC
NATIVE {IFFL_ModifyFrame} PROC
->NATIVE {IFFL_NewOpenIFF} PROC
NATIVE {IFFL_OpenIFF} PROC
NATIVE {IFFL_PopChunk} PROC
->NATIVE {IFFL_PPOpenIFF} PROC
NATIVE {IFFL_PushChunk} PROC
NATIVE {IFFL_SaveBitMap} PROC
NATIVE {IFFL_SaveClip} PROC
NATIVE {IFFL_WriteChunkBytes} PROC
