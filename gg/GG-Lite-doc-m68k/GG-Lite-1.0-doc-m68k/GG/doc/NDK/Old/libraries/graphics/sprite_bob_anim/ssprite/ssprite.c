/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

/* ssprite.c 19oct89
**
** lattice c 5.04
** lc -b1 -cfist -v -y ssprite.c
** blink FROM LIB:c.o ssprite.o LIB LIB:lc.lib LIB:amiga.lib TO ssprite
*/
#include "exec/types.h"
#include "graphics/gfx.h"
#include "graphics/gfxbase.h"
#include "graphics/gfxmacros.h"
#include "graphics/sprite.h"
#include "hardware/custom.h"
#include "hardware/dmabits.h"
#include "libraries/dos.h"

#include <stdlib.h>
#include <proto/all.h>

struct GfxBase *GfxBase = NULL;
extern struct Custom far custom ;

/* real boring sprite data */
UWORD chip sprite_data[ ] =
	{
	0, 0,           /* position control */
	0xffff, 0x0000, /* image data line 1, color 1 */
	0xffff, 0x0000, /* image data line 2, color 1 */
	0x0000, 0xffff, /* image data line 3, color 2 */
	0x0000, 0xffff, /* image data line 4, color 2 */
	0x0000, 0x0000, /* image data line 5, transparent */
	0x0000, 0xffff, /* image data line 6, color 2 */
	0x0000, 0xffff, /* image data line 7, color 2 */
	0xffff, 0xffff, /* image data line 8, color 3 */
	0xffff, 0xffff, /* image data line 9, color 3 */
	0, 0            /* reserved, must init to 0 0 */
	};

VOID main(int argc, char **argv)
{
struct SimpleSprite		sprite;
struct ViewPort		   *viewport;

SHORT sprite_num;
SHORT delta_move;
SHORT ktr1;
SHORT ktr2;
SHORT color_reg;

int return_code;

return_code = RETURN_OK;

if (NULL == (GfxBase = (struct GfxBase *)OpenLibrary("graphics.library",33L)))
	return_code = RETURN_FAIL;
else
	{
	/* opened library, need a viewport to do a sprite
	** in real life you use the viewport of the screen that you open
	** for your application.
	*/
	viewport = GfxBase->ActiView->ViewPort ;

	if (-1 == (sprite_num = GetSprite(&sprite, 2)))
		return_code = RETURN_WARN;
	else
		{
		/* got a sprite.
		** calculate the correct base color register number and
		** set up the color registers.
		*/
		color_reg = 16 + ((sprite_num & 0x06) << 1);
		SetRGB4(viewport, (long)color_reg + 1, 12,  3,  8);
		SetRGB4(viewport, (long)color_reg + 2, 13, 13, 13);
		SetRGB4(viewport, (long)color_reg + 3,  4,  4, 15);

		sprite.x = 0;       /* initialize position and size info	*/
		sprite.y = 0;       /* to match that shown in sprite_data	*/
		sprite.height = 9;  /* so system knows layout of data later */

		/* install sprite data and move sprite to start position. */
		ChangeSprite(NULL, &sprite, sprite_data);
		MoveSprite(NULL, &sprite, 30, 0);

		/* move the sprite to and fro (?) */
		for ( ktr1 = 0, delta_move = 1;
			  ktr1 < 6;
			  ktr1++, delta_move = -delta_move)
			{
			for ( ktr2 = 0; ktr2 < 185; ktr2++)
				{
				MoveSprite(NULL, &sprite, (LONG)(sprite.x + delta_move),
										  (LONG)(sprite.y + delta_move));
				WaitTOF(); /* one move per video frame */
				if (ktr2 == 80)
					OFF_SPRITE ;
				if (ktr2 == 100)
					ON_SPRITE ;
				}
			}
		/* NOTE:  if you turn off the sprite at the wrong time
		** (when it is being displayed), the sprite will appear as
		** a vertical bar on the screen.  To really get rid of the
		** sprite, you must OFF_SPRITE while it is not displayed.
		** this is hard in a multi-tasking system (the solution is
		** not addressed in this program).
		*/
		ON_SPRITE ; /* just to be sure */
		FreeSprite((LONG)sprite_num);
		}
	CloseLibrary((struct Library *)GfxBase);
	}
exit(return_code);
}
