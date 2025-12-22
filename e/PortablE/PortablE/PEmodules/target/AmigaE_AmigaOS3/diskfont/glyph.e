/* $VER: glyph.h 9.1 (19.6.1992) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/libraries', 'target/exec/nodes'
{MODULE 'diskfont/glyph'}

TYPE FIXED IS VALUE


NATIVE {glyphengine} OBJECT glyphengine
    {library}	library	:PTR TO lib /* engine library */
    {name}	name	:ARRAY OF CHAR		/* library basename: e.g. "bullet" */
    /* private library data follows... */
ENDOBJECT

NATIVE {glyphmap} OBJECT glyphmap
    {bmmodulo}	bmmodulo	:UINT	/* # of bytes in row: always multiple of 4 */
    {bmrows}	bmrows	:UINT		/* # of rows in bitmap */
    {blackleft}	blackleft	:UINT	/* # of blank pixel columns at left */
    {blacktop}	blacktop	:UINT	/* # of blank rows at top */
    {blackwidth}	blackwidth	:UINT	/* span of contiguous non-blank columns */
    {blackheight}	blackheight	:UINT	/* span of contiguous non-blank rows */
    {xorigin}	xorigin	:FIXED	/* distance from upper left corner of bitmap */
    {yorigin}	yorigin	:FIXED	/*   to initial CP, in fractional pixels */
    {x0}	x0	:INT		/* approximation of XOrigin in whole pixels */
    {y0}	y0	:INT		/* approximation of YOrigin in whole pixels */
    {x1}	x1	:INT		/* approximation of XOrigin + Width */
    {y1}	y1	:INT		/* approximation of YOrigin + Width */
    {width}	width	:FIXED		/* character advance, as fraction of em width */
    {bitmap}	bitmap	:PTR TO UBYTE		/* actual glyph bitmap */
ENDOBJECT

NATIVE {glyphwidthentry} OBJECT glyphwidthentry
    {node}	node	:mln	/* on list returned by OT_WidthList inquiry */
    {code}	code	:UINT		/* entry's character code value */
    {width}	width	:FIXED		/* character advance, as fraction of em width */
ENDOBJECT
