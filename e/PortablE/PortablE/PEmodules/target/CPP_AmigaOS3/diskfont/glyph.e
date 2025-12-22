/* $VER: glyph.h 9.1 (19.6.1992) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/libraries', 'target/exec/nodes'
{#include <diskfont/glyph.h>}
NATIVE {DISKFONT_GLYPH_H} CONST

TYPE FIXED IS NATIVE {FIXED} VALUE


/* A GlyphEngine must be acquired via OpenEngine and is read-only */
NATIVE {GlyphEngine} OBJECT glyphengine
    {gle_Library}	library	:PTR TO lib /* engine library */
    {gle_Name}	name	:ARRAY OF CHAR		/* library basename: e.g. "bullet" */
    /* private library data follows... */
ENDOBJECT

NATIVE {FIXED} CONST		/* 32 bit signed w/ 16 bits of fraction */

NATIVE {GlyphMap} OBJECT glyphmap
    {glm_BMModulo}	bmmodulo	:UINT	/* # of bytes in row: always multiple of 4 */
    {glm_BMRows}	bmrows	:UINT		/* # of rows in bitmap */
    {glm_BlackLeft}	blackleft	:UINT	/* # of blank pixel columns at left */
    {glm_BlackTop}	blacktop	:UINT	/* # of blank rows at top */
    {glm_BlackWidth}	blackwidth	:UINT	/* span of contiguous non-blank columns */
    {glm_BlackHeight}	blackheight	:UINT	/* span of contiguous non-blank rows */
    {glm_XOrigin}	xorigin	:FIXED	/* distance from upper left corner of bitmap */
    {glm_YOrigin}	yorigin	:FIXED	/*   to initial CP, in fractional pixels */
    {glm_X0}	x0	:INT		/* approximation of XOrigin in whole pixels */
    {glm_Y0}	y0	:INT		/* approximation of YOrigin in whole pixels */
    {glm_X1}	x1	:INT		/* approximation of XOrigin + Width */
    {glm_Y1}	y1	:INT		/* approximation of YOrigin + Width */
    {glm_Width}	width	:FIXED		/* character advance, as fraction of em width */
    {glm_BitMap}	bitmap	:PTR TO UBYTE		/* actual glyph bitmap */
ENDOBJECT

NATIVE {GlyphWidthEntry} OBJECT glyphwidthentry
    {gwe_Node}	node	:mln	/* on list returned by OT_WidthList inquiry */
    {gwe_Code}	code	:UINT		/* entry's character code value */
    {gwe_Width}	width	:FIXED		/* character advance, as fraction of em width */
ENDOBJECT
