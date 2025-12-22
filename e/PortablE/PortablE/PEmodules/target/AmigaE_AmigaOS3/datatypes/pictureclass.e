/* $VER: pictureclass.h 45.1 (23.10.2000) */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/libraries/iff_shared3'
MODULE 'target/utility/tagitem', 'target/datatypes/datatypesclass', 'target/libraries/iffparse'
MODULE 'target/exec/types'
{MODULE 'datatypes/pictureclass'}

NATIVE {PICTUREDTCLASS} CONST
#define PICTUREDTCLASS picturedtclass
STATIC picturedtclass = 'picture.datatype'

/*****************************************************************************/

/* Picture attributes */

/* Mode ID of the picture (ULONG) */
NATIVE {PDTA_MODEID}		CONST PDTA_MODEID		= (DTA_DUMMY + 200)

/* Bitmap header information (struct BitMapHeader *) */
NATIVE {PDTA_BITMAPHEADER}	CONST PDTA_BITMAPHEADER	= (DTA_DUMMY + 201)

/* Pointer to a class-allocated bitmap, that will end
 * up being freed by picture.class when DisposeDTObject()
 * is called (struct BitMap *).
 */
NATIVE {PDTA_BITMAP}		CONST PDTA_BITMAP		= (DTA_DUMMY + 202)

/* Picture colour table (struct ColorRegister *) */
NATIVE {PDTA_COLORREGISTERS}	CONST PDTA_COLORREGISTERS	= (DTA_DUMMY + 203)

/* Color table to use with SetRGB32CM() (ULONG *) */
NATIVE {PDTA_CREGS}		CONST PDTA_CREGS		= (DTA_DUMMY + 204)

/* Color table; this table is initialized during the layout
 * process and will contain the colours the picture will use
 * after remapping. If no remapping takes place, these colours
 * will match those in the PDTA_CRegs table (ULONG *).
 */
NATIVE {PDTA_GREGS}		CONST PDTA_GREGS		= (DTA_DUMMY + 205)

/* Shared pen table; this table is initialized during the layout
 * process while the picture is being remapped (UBYTE *).
 */
NATIVE {PDTA_COLORTABLE}		CONST PDTA_COLORTABLE		= (DTA_DUMMY + 206)

/* Shared pen table; in most places this table will be identical to
 * the PDTA_ColorTable table. Some of the colours in this table might
 * match the original colour palette a little better than the colours
 * picked for the other table. The picture.datatype uses the two tables
 * during remapping, alternating for each pixel (UBYTE *).
 */
NATIVE {PDTA_COLORTABLE2}	CONST PDTA_COLORTABLE2	= (DTA_DUMMY + 207)

/* OBSOLETE; DO NOT USE */
NATIVE {PDTA_ALLOCATED}		CONST PDTA_ALLOCATED		= (DTA_DUMMY + 208)

/* Number of colors used by the picture. (UWORD) */
NATIVE {PDTA_NUMCOLORS}		CONST PDTA_NUMCOLORS		= (DTA_DUMMY + 209)

/* Number of colors allocated by the picture (UWORD) */
NATIVE {PDTA_NUMALLOC}		CONST PDTA_NUMALLOC		= (DTA_DUMMY + 210)

/* Remap the picture (BOOL); defaults to TRUE */
NATIVE {PDTA_REMAP}		CONST PDTA_REMAP		= (DTA_DUMMY + 211)

/* Screen to remap to (struct Screen *) */
NATIVE {PDTA_SCREEN}		CONST PDTA_SCREEN		= (DTA_DUMMY + 212)

/* Free the source bitmap after remapping (BOOL) */
NATIVE {PDTA_FREESOURCEBITMAP}	CONST PDTA_FREESOURCEBITMAP	= (DTA_DUMMY + 213)

/* Pointer to a Point structure */
NATIVE {PDTA_GRAB}		CONST PDTA_GRAB		= (DTA_DUMMY + 214)

/* Pointer to the destination (remapped) bitmap */
NATIVE {PDTA_DESTBITMAP}		CONST PDTA_DESTBITMAP		= (DTA_DUMMY + 215)

/* Pointer to class-allocated bitmap, that will end
 * up being freed by the class after DisposeDTObject()
 * is called (struct BitMap *)
 */
NATIVE {PDTA_CLASSBITMAP}	CONST PDTA_CLASSBITMAP	= (DTA_DUMMY + 216)

/* Number of colors used for sparse remapping (UWORD) */
NATIVE {PDTA_NUMSPARSE}		CONST PDTA_NUMSPARSE		= (DTA_DUMMY + 217)

/* Pointer to a table of pen numbers indicating
 * which colors should be used when remapping the image.
 * This array must contain as many entries as there
 * are colors specified with PDTA_NumSparse (UBYTE *).
 */
NATIVE {PDTA_SPARSETABLE}	CONST PDTA_SPARSETABLE	= (DTA_DUMMY + 218)

/* Index number of the picture to load (ULONG). (V44) */
CONST PDTA_WHICHPICTURE	= (DTA_DUMMY + 219)

/* Get the number of pictures stored in the file (ULONG *). (V44) */
CONST PDTA_GETNUMPICTURES	= (DTA_DUMMY + 220)

/* Maximum number of colours to use for dithering (ULONG). (V44) */
CONST PDTA_MAXDITHERPENS	= (DTA_DUMMY + 221)

/* Quality of the dithering algorithm to be used during colour
 * quantization (ULONG). (V44)
 */
CONST PDTA_DITHERQUALITY	= (DTA_DUMMY + 222)

/* Pointer to the allocated pen table (UBYTE *). (V44) */
CONST PDTA_ALLOCATEDPENS	= (DTA_DUMMY + 223)

/* Quality for scaling. (V45) */
CONST PDTA_SCALEQUALITY	= (DTA_DUMMY + 224)

/*****************************************************************************/

/* When querying the number of pictures stored in a file, the
 * following value denotes "the number of pictures is unknown".
 */
CONST PDTANUMPICTURES_UNKNOWN = (0)

/*****************************************************************************/

/* V43 extensions (attributes) */

/* Set the sub datatype interface mode (LONG); see "Interface modes" below */
CONST PDTA_SOURCEMODE		= (DTA_DUMMY + 250)

/* Set the app datatype interface mode (LONG); see "Interface modes" below */
CONST PDTA_DESTMODE		= (DTA_DUMMY + 251)

/* Allocates the resulting bitmap as a friend bitmap (BOOL) */
CONST PDTA_USEFRIENDBITMAP	= (DTA_DUMMY + 255)

/* NULL or mask plane for use with BltMaskBitMapRastPort() (PLANEPTR) */
CONST PDTA_MASKPLANE		= (DTA_DUMMY + 258)

/*****************************************************************************/

/* Interface modes */
CONST PMODE_V42 = (0)	/* Compatibility mode */
CONST PMODE_V43 = (1)	/* Extended mode */

/*****************************************************************************/

/* V43 extensions (methods) */

CONST PDTM_DUMMY = (DTM_DUMMY + $60)

/* Transfer pixel data to the picture object in the specified format */
CONST PDTM_WRITEPIXELARRAY = (PDTM_DUMMY + 0)

/* Transfer pixel data from the picture object in the specified format */
CONST PDTM_READPIXELARRAY = (PDTM_DUMMY + 1)

/* PDTM_WRITEPIXELARRAY, PDTM_READPIXELARRAY */
OBJECT pdtblitpixelarray
	methodid	:ULONG
	pixeldata	:APTR		/* The pixel data to transfer to/from */
	pixelformat	:ULONG	/* Format of the pixel data (see "Pixel Formats" below) */
	pixelarraymod	:ULONG	/* Number of bytes per row */
	left	:ULONG		/* Left edge of the rectangle to transfer pixels to/from */
	top	:ULONG		/* Top edge of the rectangle to transfer pixels to/from */
	width	:ULONG		/* Width of the rectangle to transfer pixels to/from */
	height	:ULONG		/* Height of the rectangle to transfer pixels to/from */
ENDOBJECT

/* Pixel formats */
CONST PBPAFMT_RGB	= 0	/* 3 bytes per pixel (red, green, blue) */
CONST PBPAFMT_RGBA	= 1	/* 4 bytes per pixel (red, green, blue, alpha channel) */
CONST PBPAFMT_ARGB	= 2	/* 4 bytes per pixel (alpha channel, red, green, blue) */
CONST PBPAFMT_LUT8	= 3	/* 1 byte per pixel (using a separate colour map) */
CONST PBPAFMT_GREY8	= 4	/* 1 byte per pixel (0==black, 255==white) */

/*****************************************************************************/

/* V45 extensions (methods) */

/* Scale pixel data to the specified size */
CONST PDTM_SCALE = (PDTM_DUMMY + 2)

/* PDTM_SCALE */
OBJECT pdtscale
	methodid	:ULONG
	newwidth	:ULONG	/* The new width the pixel data should have */
	newheight	:ULONG	/* The new height the pixel data should have */
	flags	:ULONG		/* should be 0 for now */
ENDOBJECT

/*****************************************************************************/

/* Masking techniques */
NATIVE {MSKNONE}			CONST MSKNONE			= 0
NATIVE {MSKHASMASK}		CONST MSKHASMASK		= 1
NATIVE {MSKHASTRANSPARENTCOLOR}	CONST MSKHASTRANSPARENTCOLOR	= 2
NATIVE {MSKLASSO}		CONST MSKLASSO		= 3
NATIVE {MSKHASALPHA}		CONST MSKHASALPHA		= 4

/* Compression techniques */
NATIVE {CMPNONE}			CONST CMPNONE			= 0
NATIVE {CMPBYTERUN1}		CONST CMPBYTERUN1		= 1
NATIVE {CMPBYTERUN2}		CONST CMPBYTERUN2		= 2	/* NOTE: unused (V44) */

/* Bitmap header (BMHD) structure */
NATIVE {bitmapheader} OBJECT bitmapheader
	{width}	width	:UINT		/* Width in pixels */
	{height}	height	:UINT		/* Height in pixels */
	{left}	left	:INT		/* Left position */
	{top}	top	:INT		/* Top position */
	{depth}	depth	:UBYTE		/* Number of planes */
	{masking}	masking	:UBYTE		/* Masking type */
	{compression}	compression	:UBYTE	/* Compression type */
	{pad}	pad	:UBYTE
	{transparent}	transparent	:UINT	/* Transparent color */
	{xaspect}	xaspect	:UBYTE
	{yaspect}	yaspect	:UBYTE
	{pagewidth}	pagewidth	:INT
	{pageheight}	pageheight	:INT
ENDOBJECT

/*****************************************************************************/

/* Color register structure */
NATIVE {colorregister} OBJECT colorregister
	{red}	red	:UBYTE
	{green}	green	:UBYTE
	{blue}	blue	:UBYTE
ENDOBJECT

/*****************************************************************************/

/* IFF types that may be in pictures */
->"CONST ID_ILBM" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')
->"CONST ID_BMHD" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')
->"CONST ID_CMAP" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')
->"CONST ID_CRNG" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')
NATIVE {ID_GRAB}	CONST ID_GRAB	= "GRAB"
NATIVE {ID_SPRT}	CONST ID_SPRT	= "SPRT"
NATIVE {ID_DEST}	CONST ID_DEST	= "DEST"
->"CONST ID_CAMG" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')

->"CONST ID_BODY" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')
