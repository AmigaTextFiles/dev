@DATABASE "gg:doc/NDK/Guide/Include/gadgets/string.h"
@MASTER   "gg:os-include/gadgets/string.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:45
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/string.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/string.h" LINK File}


@{b}#defines@{ub}

@{"SHK_AMOUNT" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 68}           @{"SHK_CUSTOM" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 61}        @{"SHK_FLOAT" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 64}
@{"SHK_HEXADECIMAL" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 72}      @{"SHK_HEXIDECIMAL" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 65}   @{"SHK_HOTKEY" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 70}
@{"SHK_IPADDRESS" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 63}        @{"SHK_PASSWORD" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 62}      @{"SHK_POSTALCODE" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 67}
@{"SHK_TELEPHONE" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 66}        @{"SHK_UPPERCASE" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 69}     @{"STRINGA_AllowMarking" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 54}
@{"STRINGA_GetBlockPos" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 41}  @{"STRINGA_HookType" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 34}  @{"STRINGA_Mark" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 48}
@{"STRINGA_MinVisible" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File" 29}   

@ENDNODE
@NODE File "gadgets/string.h"
#ifndef GADGETS_STRING_H
#define GADGETS_STRING_H
/*
**      $VER: string.h 45.1 (07.03.2001)
**      Includes Release 45.1
**
**      Definitions for the string.gadget BOOPSI class
**
**      (C) Copyright 2000-2001 Amiga, Inc.
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

/* string.gadget accepts the same tag parameters as the ROM strgclass
 * in addition to those listed below.
 */

#define STRINGA_MinVisible              (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x0055000)
    /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Minimum character length to domain min size on. [ISG]
     *         In a layout, a nominal domain would be 2 times this value.
     */

#define STRINGA_HookType                (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x0055001)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Use which built-in hook function? [I]
         */

/* The following tags are new for v45
*/

#define STRINGA_GetBlockPos             (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x0055010)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Returns the position of the first and last character
         * of the marked block. The upper 16bit (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) of the long-word contain
         * the start position and the lower 16bit (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) the end position.
         * When nothing is marked both values will be -1. [G]
         */

#define STRINGA_Mark                    (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x0055011)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Mark the given block. The upper 16bit of the longword contain
         * the start position and the lower one the end position. If one or both
         * values are -1, the current block will be unmarked. [ISU]
         */

#define STRINGA_AllowMarking    (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x0055012)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Enable/disable marking, defaults to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}. [ISUG]
         */


/* Support hook types for @{"STRINGA_HookType" LINK File 34}
 */
#define SHK_CUSTOM              0
#define SHK_PASSWORD    1
#define SHK_IPADDRESS   2
#define SHK_FLOAT               3
#define SHK_HEXIDECIMAL 4
#define SHK_TELEPHONE   5
#define SHK_POSTALCODE  6
#define SHK_AMOUNT              7
#define SHK_UPPERCASE   8
#define SHK_HOTKEY              9       /* new for v45 */

#define SHK_HEXADECIMAL @{"SHK_HEXIDECIMAL" LINK File 65}

#endif /* GADGETS_STRING_H */
@ENDNODE
