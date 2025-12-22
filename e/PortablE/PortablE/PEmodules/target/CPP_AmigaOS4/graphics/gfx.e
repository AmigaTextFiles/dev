/* $Id: gfx.h,v 1.13 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/graphics/gfx_shared2'
MODULE 'target/exec/types', 'target/utility/tagitem'
{#include <graphics/gfx.h>}
NATIVE {GRAPHICS_GFX_H} CONST

NATIVE {BITSET} CONST BITSET = $8000
NATIVE {BITCLR} CONST BITCLR = 0

->"OBJECT rectangle" is on-purposely missing from here (it can be found in 'graphics/gfx_shared2')

NATIVE {Rect32} OBJECT rect32
    {MinX}	minx	:VALUE
    {MinY}	miny	:VALUE
    {MaxX}	maxx	:VALUE
    {MaxY}	maxy	:VALUE
ENDOBJECT

->"OBJECT tpoint" is on-purposely missing from here (it can be found in 'graphics/gfx_shared2')

NATIVE {PLANEPTR} CONST

->"OBJECT bitmap" is on-purposely missing from here (it can be found in 'graphics/gfx_shared2')

/* This macro is obsolete as of V39. AllocBitMap() should be used for allocating
   bitmap data, since it knows about the machine's particular alignment
   restrictions.
*/
NATIVE {RASSIZE} CONST	->RASSIZE(w,h) ((ULONG)(h)*( ((ULONG)(w)+15)>>3&0xFFFE))
#define RASSIZE(w,h) Rassize(w,h)
PROC Rassize(w,h) IS h * (Shr(w+15,3) AND $FFFE)

/* flags for AllocBitMap, etc. */
NATIVE {BMB_CLEAR}        CONST BMB_CLEAR        = 0
NATIVE {BMB_DISPLAYABLE}  CONST BMB_DISPLAYABLE  = 1
NATIVE {BMB_INTERLEAVED}  CONST BMB_INTERLEAVED  = 2
NATIVE {BMB_STANDARD}     CONST BMB_STANDARD     = 3
NATIVE {BMB_MINPLANES}    CONST BMB_MINPLANES    = 4
/*
 * New V45 flags follow. If this bit combination is set,
 * the AllocBitMap() friends pointer points to a tag
 * list describing further data
 */
NATIVE {BMB_HIJACKED}     CONST BMB_HIJACKED     = 7 /* must be clear                 */
NATIVE {BMB_RTGTAGS}      CONST BMB_RTGTAGS      = 8 /* must be one for tag extension */
NATIVE {BMB_RTGCHECK}     CONST BMB_RTGCHECK     = 9 /* must be one for tag extension */
NATIVE {BMB_FRIENDISTAG} CONST BMB_FRIENDISTAG = 10 /* must be one as well           */
NATIVE {BMB_INVALID}     CONST BMB_INVALID     = 11 /* must be clear                 */

NATIVE {BMF_CLEAR}       CONST BMF_CLEAR       = $1
NATIVE {BMF_DISPLAYABLE} CONST BMF_DISPLAYABLE = $2
NATIVE {BMF_INTERLEAVED} CONST BMF_INTERLEAVED = $4
NATIVE {BMF_STANDARD}    CONST BMF_STANDARD    = $8
NATIVE {BMF_MINPLANES}   CONST BMF_MINPLANES   = $10
NATIVE {BMF_HIJACKED}    CONST BMF_HIJACKED    = $80
NATIVE {BMF_RTGTAGS}     CONST BMF_RTGTAGS     = $100
NATIVE {BMF_RTGCHECK}    CONST BMF_RTGCHECK    = $200
NATIVE {BMF_FRIENDISTAG} CONST BMF_FRIENDISTAG = $400
NATIVE {BMF_INVALID}     CONST BMF_INVALID     = $800

NATIVE {BMF_CHECKMASK}   CONST BMF_CHECKMASK   = (BMF_HIJACKED    OR BMF_RTGTAGS OR BMF_RTGCHECK OR BMF_FRIENDISTAG OR BMF_INVALID)
NATIVE {BMF_CHECKVALUE}  CONST BMF_CHECKVALUE  = (BMF_RTGTAGS OR BMF_RTGCHECK OR BMF_FRIENDISTAG)

NATIVE {BITMAPFLAGS_ARE_EXTENDED} CONST	->BITMAPFLAGS_ARE_EXTENDED(a) ((a & BMF_CHECKMASK) == BMF_CHECKVALUE)

/* tags for AllocBitMap */
NATIVE {BMATags_Friend}                     CONST BMATAGS_FRIEND                     = (TAG_USER+0)
        /*
         * Specify a friend-bitmap by tags
         * Default is no friend bitmap
         */
NATIVE {BMATags_Depth}                      CONST BMATAGS_DEPTH                      = (TAG_USER+1)
        /*
         * depth of the bitmap. Default is the
         * depth parameter of AllocBitMap
         */
NATIVE {BMATags_RGBFormat}                  CONST BMATAGS_RGBFORMAT                  = (TAG_USER+2)
        /*
         * private, do not set
         */
NATIVE {BMATags_Clear}                      CONST BMATAGS_CLEAR                      = (TAG_USER+3)
        /*
         * clear bitmap? Default is the BMF_CLEAR
         * flag specified value.
         */
NATIVE {BMATags_Displayable}                CONST BMATAGS_DISPLAYABLE                = (TAG_USER+4)
        /*
         * bitmap usable for hardware?
         * Default is the BMF_DISPLAYABLE flag.
         */
NATIVE {BMATags_NoMemory}                   CONST BMATAGS_NOMEMORY                   = (TAG_USER+6)
        /*
         * do not provide memory for the bitmap,
         * just allocate the structure
         * Default is false.
         */
NATIVE {BMATags_NoSprite}                   CONST BMATAGS_NOSPRITE                   = (TAG_USER+7)
        /*
         * disallow generation of a sprite
         * default is sprite enabled.
         */
NATIVE {BMATags_ModeWidth}                  CONST BMATAGS_MODEWIDTH                  = (TAG_USER+10)
        /*
         * width of the display mode in pixels.
         * Default is the width of the displayID
         * in the monitor database.
         */
NATIVE {BMATags_ModeHeight}                 CONST BMATAGS_MODEHEIGHT                 = (TAG_USER+11)
        /*
         * height of the display mode in pixels.
         * Default is the height of the displayID
         * in the monitor database.
         */
NATIVE {BMATags_RenderFunc}                 CONST BMATAGS_RENDERFUNC                 = (TAG_USER+12)
        /*
         * pointer to a function that is called
         * whenever the bitmap is loaded onto
         * the board.
         */
NATIVE {BMATags_SaveFunc}                   CONST BMATAGS_SAVEFUNC                   = (TAG_USER+13)
        /*
         * pointer to a function that is called
         * whenever the bitmap is removed from
         * the board.
         */
NATIVE {BMATags_UserData}                   CONST BMATAGS_USERDATA                   = (TAG_USER+14)
        /*
         * user data for the render/save functions
         * above.
         */
NATIVE {BMATags_Alignment}                  CONST BMATAGS_ALIGNMENT                  = (TAG_USER+15)
        /*
         * specify additional alignment (power of two)
         * for the bitmap rows. If this tag is set,
         * then bitplane rows are aligned to this
         * boundary. Otherwise, the native alignment
         * restriction is provided.
         */
NATIVE {BMATags_ConstantBytesPerRow}        CONST BMATAGS_CONSTANTBYTESPERROW        = (TAG_USER+16)
        /*
         * set with the above to enforce alignment
         * for displayable screens
         */
NATIVE {BMATags_UserPrivate}                CONST BMATAGS_USERPRIVATE                = (TAG_USER+17)

NATIVE {BMATags_DisplayID}                  CONST BMATAGS_DISPLAYID                  = (TAG_USER + $32)
        /* a display ID from the monitor data base
         * the system tries then to extract all necessary information
         * to build a suitable bitmap
         * This is intentionally identical to intuition SA_DisplayID
         */
NATIVE {BMATags_BitmapInvisible}            CONST BMATAGS_BITMAPINVISIBLE            = (TAG_USER + $37)
        /* if set to TRUE, the bitmap is not allocated on the graphics
         * board directly, but may remain in an off-hardware location
         * if the screen is invisible. This is intentionally
         * identically to SA_Behind. Default is FALSE
         */
NATIVE {BMATags_BitmapColors}               CONST BMATAGS_BITMAPCOLORS               = (TAG_USER + $29)
        /* ti_Data is an array of struct ColorSpec,
         * terminated by ColorIndex = -1.  Specifies
         * initial screen palette colors.
         * This is intentionally identically to SA_Colors
         */
NATIVE {BMATags_BitmapColors32}             CONST BMATAGS_BITMAPCOLORS32             = (TAG_USER + $43)
        /* Tag to set the bitmaps's initial palette colors
         * at 32 bits-per-gun.  ti_Data is a pointer
         * to a table to be passed to the
         * graphics.library/LoadRGB32() function.
         * This format supports both runs of color
         * registers and sparse registers.  See the
         * autodoc for that function for full details.
         * Any color set here has precedence over
         * the same register set by ABMA_BitmapColors.
         * Intentionally identical to SA_Colors32
         */

/* the following are for GetBitMapAttr() */
NATIVE {BMA_HEIGHT}  CONST BMA_HEIGHT  = 0
NATIVE {BMA_DEPTH}   CONST BMA_DEPTH   = 4
NATIVE {BMA_WIDTH}   CONST BMA_WIDTH   = 8
NATIVE {BMA_FLAGS}  CONST BMA_FLAGS  = 12
