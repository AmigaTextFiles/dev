@DATABASE "gg:doc/NDK/Guide/Include/gadgets/palette.h"
@MASTER   "gg:os-include/gadgets/palette.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:39
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/palette.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/palette.h" LINK File}


@{b}#defines@{ub}

@{"PALETTE_Color" LINK "gg:doc/NDK/Guide/Include/gadgets/palette.h/File" 44}   @{"PALETTE_ColorOffset" LINK "gg:doc/NDK/Guide/Include/gadgets/palette.h/File" 45}   @{"PALETTE_ColorTable" LINK "gg:doc/NDK/Guide/Include/gadgets/palette.h/File" 46}
@{"PALETTE_Colour" LINK "gg:doc/NDK/Guide/Include/gadgets/palette.h/File" 29}  @{"PALETTE_ColourOffset" LINK "gg:doc/NDK/Guide/Include/gadgets/palette.h/File" 32}  @{"PALETTE_ColourTable" LINK "gg:doc/NDK/Guide/Include/gadgets/palette.h/File" 36}
@{"PALETTE_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/palette.h/File" 27}   @{"PALETTE_NumColors" LINK "gg:doc/NDK/Guide/Include/gadgets/palette.h/File" 47}     @{"PALETTE_NumColours" LINK "gg:doc/NDK/Guide/Include/gadgets/palette.h/File" 39}

@ENDNODE
@NODE File "gadgets/palette.h"
#ifndef GADGETS_PALETTE_H
#define GADGETS_PALETTE_H
/*
**      $VER: palette.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the Palette BOOPSI class
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef REACTION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <@{"intuition/gadgetclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File"}>
#endif

/*****************************************************************************/

/* Additional attributes defined by the Palette class
 */
#define PALETTE_Dummy                   (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x0004000)

#define PALETTE_Colour                  (@{"PALETTE_Dummy" LINK File 27}+1)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) The value in the gadget.  Defaults to 0. */

#define PALETTE_ColourOffset    (@{"PALETTE_Dummy" LINK File 27}+2)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Maximum number of characters for the numer (including
         * negative sign.  Defaults to 10. */

#define PALETTE_ColourTable             (@{"PALETTE_Dummy" LINK File 27}+3)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *) Minimum value for the number. */

#define PALETTE_NumColours              (@{"PALETTE_Dummy" LINK File 27}+4)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Maximum value for the number. */

/* American spellings.
 */
#define PALETTE_Color @{"PALETTE_Colour" LINK File 29}
#define PALETTE_ColorOffset @{"PALETTE_ColourOffset" LINK File 32}
#define PALETTE_ColorTable @{"PALETTE_ColourTable" LINK File 36}
#define PALETTE_NumColors @{"PALETTE_NumColours" LINK File 39}

#endif /* GADGETS_PALETTE_H */
@ENDNODE
