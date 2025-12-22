/* $Id: glyph.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/libraries', 'target/exec/nodes'
{#include <diskfont/glyph.h>}
NATIVE {DISKFONT_GLYPH_H} CONST

TYPE FIXED IS NATIVE {FIXED} VALUE


NATIVE {GlyphEngine} OBJECT glyphengine
    {gle_Library}	library	:PTR TO lib
    {gle_Name}	name	:ARRAY OF CHAR
ENDOBJECT

NATIVE {FIXED} CONST

NATIVE {GlyphMap} OBJECT glyphmap
    {glm_BMModulo}	bmmodulo	:UINT
    {glm_BMRows}	bmrows	:UINT
    {glm_BlackLeft}	blackleft	:UINT
    {glm_BlackTop}	blacktop	:UINT
    {glm_BlackWidth}	blackwidth	:UINT
    {glm_BlackHeight}	blackheight	:UINT
    {glm_XOrigin}	xorigin	:FIXED
    {glm_YOrigin}	yorigin	:FIXED
    {glm_X0}	x0	:INT
    {glm_Y0}	y0	:INT
    {glm_X1}	x1	:INT
    {glm_Y1}	y1	:INT
    {glm_Width}	width	:FIXED
    {glm_BitMap}	bitmap	:PTR TO UBYTE
ENDOBJECT

NATIVE {GlyphWidthEntry} OBJECT glyphwidthentry
    {gwe_Node}	node	:mln
    {gwe_Code}	code	:UINT
    {gwe_Width}	width	:FIXED
ENDOBJECT
