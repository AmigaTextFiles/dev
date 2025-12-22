/* $Id: layersext.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/utility/tagitem'
{#include <graphics/layersext.h>}
NATIVE {GRAPHICS_LAYERSEXT_H} CONST

NATIVE {LA_Dummy}	CONST LA_DUMMY	= (TAG_USER + 1234)

/* Tags for CreateLayerTagList */

NATIVE {LA_Type}		CONST LA_TYPE		= (LA_DUMMY + 1) /* LAYERSIMPLE, LAYERSMART (default) -or LAYERSUPER */
NATIVE {LA_Priority}	CONST LA_PRIORITY	= (LA_DUMMY + 2) /* -128 .. 127 or LPRI_NORMAL (default) or LPRI_BACKDROP */
NATIVE {LA_Behind}	CONST LA_BEHIND	= (LA_DUMMY + 3) /* BOOL. Default is FALSE */
NATIVE {LA_Invisible}	CONST LA_INVISIBLE	= (LA_DUMMY + 4) /* BOOL. Default is FALSE */
NATIVE {LA_BackFill}	CONST LA_BACKFILL	= (LA_DUMMY + 5) /* struct Hook *. Default is LAYERS_BACKFILL */
NATIVE {LA_SuperBitMap}	CONST LA_SUPERBITMAP	= (LA_DUMMY + 6) /* struct BitMap *. Default is NULL (none) */
NATIVE {LA_Shape}	CONST LA_SHAPE	= (LA_DUMMY + 7) /* struct Region *. Default is NULL (rectangular shape) */

NATIVE {LPRI_NORMAL} 	CONST LPRI_NORMAL 	= 0
NATIVE {LPRI_BACKDROP}	CONST LPRI_BACKDROP	= -50
