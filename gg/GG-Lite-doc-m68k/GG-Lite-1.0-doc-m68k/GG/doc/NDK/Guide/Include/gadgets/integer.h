@DATABASE "gg:doc/NDK/Guide/Include/gadgets/integer.h"
@MASTER   "gg:os-include/gadgets/integer.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:32
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/integer.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/integer.h" LINK File}


@{b}#defines@{ub}

@{"INTEGER_Arrows" LINK "gg:doc/NDK/Guide/Include/gadgets/integer.h/File" 42}   @{"INTEGER_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/integer.h/File" 27}       @{"INTEGER_MaxChars" LINK "gg:doc/NDK/Guide/Include/gadgets/integer.h/File" 32}  @{"INTEGER_Maximum" LINK "gg:doc/NDK/Guide/Include/gadgets/integer.h/File" 39}
@{"INTEGER_Minimum" LINK "gg:doc/NDK/Guide/Include/gadgets/integer.h/File" 36}  @{"INTEGER_MinVisible" LINK "gg:doc/NDK/Guide/Include/gadgets/integer.h/File" 45}  @{"INTEGER_Number" LINK "gg:doc/NDK/Guide/Include/gadgets/integer.h/File" 29}    @{"INTEGER_SkipVal" LINK "gg:doc/NDK/Guide/Include/gadgets/integer.h/File" 48}

@ENDNODE
@NODE File "gadgets/integer.h"
#ifndef GADGETS_INTEGER_H
#define GADGETS_INTEGER_H
/*
**      $VER: integer.h 45.1 (07.11.2000)
**      Includes Release 45.1
**
**      Definitions for the integer.gadget BOOPSI class
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

/* Additional attributes defined by the Integer class
 */
#define INTEGER_Dummy           (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x0002000)

#define INTEGER_Number          (@{"INTEGER_Dummy" LINK File 27}+1)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) The value in the gadget.  Defaults to 0. */

#define INTEGER_MaxChars        (@{"INTEGER_Dummy" LINK File 27}+2)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Maximum number of characters for the numer (including
         * negative sign.  Defaults to 10. */

#define INTEGER_Minimum         (@{"INTEGER_Dummy" LINK File 27}+3)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Minimum value for the number. */

#define INTEGER_Maximum         (@{"INTEGER_Dummy" LINK File 27}+4)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Maximum value for the number. */

#define INTEGER_Arrows          (@{"INTEGER_Dummy" LINK File 27}+5)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Should arrows be available.  Defaults to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}. */

#define INTEGER_MinVisible      (@{"INTEGER_Dummy" LINK File 27}+6)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Minimum number of digits to be visible.  Defaults to 0. (V41) */

#define INTEGER_SkipVal (@{"INTEGER_Dummy" LINK File 27}+7)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) In-/decrease the number by the given value when user presses
         * the arrows, defaults to 1. (V45)
         */

#endif /* GADGETS_INTEGER_H */
@ENDNODE
