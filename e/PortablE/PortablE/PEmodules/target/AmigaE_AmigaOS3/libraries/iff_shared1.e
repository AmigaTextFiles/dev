/* $Id: iff.h,v 23.2 93/05/24 16:03:28 chris Exp $ */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/libraries/iff_shared2', 'target/libraries/iff_shared3', 'target/libraries/iff_shared4', 'target/libraries/iff_shared5', 'target/libraries/iff_shared6'
MODULE 'target/exec/types', 'target/datatypes/animationclass', 'target/datatypes/datatypes', 'target/datatypes/pictureclass', 'target/datatypes/soundclass'
{MODULE 'libraries/iff'}

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
TYPE IFFL_HANDLE IS PTR


/*
**	Generic IFF chunk structure
*/
OBJECT iffl_chunk
	ckid	:VALUE
	cksize	:VALUE
/*  UBYTE ckData[ckSize] (variable sized data) */
ENDOBJECT


/*
**	BMHD chunk (BitMapHeader) of ILBM files
*/
NATIVE {bmh} OBJECT bmh
	{width}	width	:UINT
	{height}	height	:UINT
	{xpos}	xpos	:INT
	{ypos}	ypos	:INT
	{nplanes}	nplanes	:UBYTE
	{masking}	masking	:UBYTE
	{compression}	compression	:UBYTE
	{pad1}	pad1	:UBYTE
	{transpcol}	transpcol	:UINT
	{xaspect}	xaspect	:UBYTE
	{yaspect}	yaspect	:UBYTE
	{pagewidth}	pagewidth	:INT
	{pageheight}	pageheight	:INT
ENDOBJECT


/*
**	ANHD chunk (AnimHeader) of ANIM files
*/
NATIVE {anh} OBJECT anh
	{operation}	operation	:UBYTE
	{mask}	mask	:UBYTE
	{w}	w	:UINT
	{h}	h	:UINT
	{x}	x	:INT
	{y}	y	:INT
	{abstime}	abstime	:ULONG
	{reltime}	reltime	:ULONG
	{interleave}	interleave	:UBYTE
	{pad0}	pad0	:UBYTE
	{bits}	bits	:ULONG
	{pad}	pad[16]	:ARRAY OF UBYTE
ENDOBJECT
