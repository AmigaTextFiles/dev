/* $VER: penmap.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/imageclass'
{#include <images/penmap.h>}
NATIVE {IMAGES_PENMAP_H} CONST

/* Additional attributes defined by penmap.image
 */
NATIVE {PENMAP_Dummy}			CONST PENMAP_DUMMY			= (REACTION_DUMMY + $18000)

NATIVE {PENMAP_SelectBGPen}		CONST PENMAP_SELECTBGPEN		= (PENMAP_DUMMY + 1)
	/* (WORD) Selected render background pen. */

NATIVE {PENMAP_SelectData}		CONST PENMAP_SELECTDATA		= (PENMAP_DUMMY + 2)
	/* () Optional renderng data for mode IDS_SELECTED. */

NATIVE {PENMAP_RenderBGPen}		CONST PENMAP_RENDERBGPEN		= IA_BGPEN
	/* (WORD) Background pen. */

NATIVE {PENMAP_RenderData}		CONST PENMAP_RENDERDATA		= IA_DATA
	/* () rendering data for mode IDS_NORMAL. */

NATIVE {PENMAP_Palette}			CONST PENMAP_PALETTE			= (PENMAP_DUMMY + 3)
	/* () OM_NEW/OM_SET/OM_GET palette data. */

NATIVE {PENMAP_Screen}			CONST PENMAP_SCREEN			= (PENMAP_DUMMY + 4)
	/* (struct Screen *) Screen this penmap will be displayed in. */

NATIVE {PENMAP_ImageType}		CONST PENMAP_IMAGETYPE		= (PENMAP_DUMMY + 5)
	/* (UWORD) Currently Unsupported. */

NATIVE {PENMAP_Transparent}		CONST PENMAP_TRANSPARENT		= (PENMAP_DUMMY + 6)
	/* (UWORD) OM_NEW/OM_SET - If set, color entry 0 will map
	 * to screen/window background pen. */

NATIVE {PENMAP_Precision}		CONST PENMAP_PRECISION		= (PENMAP_DUMMY + 8)
	/* (UWORD) OM_NEW/OM_SET -ObtainBestPen precision, defaults to PRECISION_IMAGE */

NATIVE {PENMAP_ColorMap}			CONST PENMAP_COLORMAP			= (PENMAP_DUMMY + 9)
	/* (struct ColorMap *) OM_NEW/OM_SET - ColorMap to use when remapping pens */

NATIVE {PENMAP_MaskBlit}			CONST PENMAP_MASKBLIT			= (PENMAP_DUMMY + 10)
	/* (BOOL) Blit image using blitmask for true transparancy, recommended
	 * when a penmap is used in a layout group for a logo, allowing the backfill
	 * to show thru/around the image. Penmap will automatically create the
	 * required mask plane for you.
	 */

/*****************************************************************************/

/* Definitions for PENMAP_ImageType
 */
NATIVE {IMAGE_CHUNKY}	CONST IMAGE_CHUNKY	= 0	/* Supported Default */
NATIVE {IMAGE_IMAGE}		CONST IMAGE_IMAGE		= 1	/* Currently unsupported. */
NATIVE {IMAGE_DRAWLIST}	CONST IMAGE_DRAWLIST	= 2	/* Currently unsupported. */

/* Macros to extract the source width and height data.
 */
NATIVE {IMAGE_WIDTH} CONST	->IMAGE_WIDTH(i)	 (((UWORD *)(i))[0])
NATIVE {IMAGE_HEIGHT} CONST	->IMAGE_HEIGHT(i)	(((UWORD *)(i))[1])
