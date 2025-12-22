@DATABASE "gg:doc/NDK/Guide/Include/gadgets/checkbox.h"
@MASTER   "gg:os-include/gadgets/checkbox.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:22
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/checkbox.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/checkbox.h" LINK File}


@{b}#defines@{ub}

@{"CHECKBOX_BackgroundPen" LINK "gg:doc/NDK/Guide/Include/gadgets/checkbox.h/File" 34}  @{"CHECKBOX_BevelStyle" LINK "gg:doc/NDK/Guide/Include/gadgets/checkbox.h/File" 37}   @{"CHECKBOX_Checked" LINK "gg:doc/NDK/Guide/Include/gadgets/checkbox.h/File" 43}
@{"CHECKBOX_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/checkbox.h/File" 26}          @{"CHECKBOX_FillTextPen" LINK "gg:doc/NDK/Guide/Include/gadgets/checkbox.h/File" 31}  @{"CHECKBOX_TextPen" LINK "gg:doc/NDK/Guide/Include/gadgets/checkbox.h/File" 28}
@{"CHECKBOX_TextPlace" LINK "gg:doc/NDK/Guide/Include/gadgets/checkbox.h/File" 40}      

@ENDNODE
@NODE File "gadgets/checkbox.h"
#ifndef GADGETS_CHECKBOX_H
#define GADGETS_CHECKBOX_H
/*
**      $VER: checkbox.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the checkbox.gadget BOOPSI class
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

/* Additional attributes defined by the checkbox.gadget class */
#define CHECKBOX_Dummy                  (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x11000)

#define CHECKBOX_TextPen                (@{"CHECKBOX_Dummy" LINK File 26}+1)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Pen to use for text (~0 uses @{"TEXTPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 96}). */

#define CHECKBOX_FillTextPen    (@{"CHECKBOX_Dummy" LINK File 26}+2)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Pen to use for fill (~0 uses @{"FILLTEXTPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 100}). */

#define CHECKBOX_BackgroundPen  (@{"CHECKBOX_Dummy" LINK File 26}+3)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Pen to use for background (~0 uses @{"BACKGROUNDPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 101}) */

#define CHECKBOX_BevelStyle             (@{"CHECKBOX_Dummy" LINK File 26}+4)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Optional outer bevel style - OBSOLETE */

#define CHECKBOX_TextPlace              (@{"CHECKBOX_Dummy" LINK File 26}+5)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Gadget Text Location (@{"PLACETEXT_LEFT" LINK "gg:doc/NDK/Guide/Include/libraries/gadtools.h/File" 101} or @{"PLACETEXT_RIGHT" LINK "gg:doc/NDK/Guide/Include/libraries/gadtools.h/File" 102}). */

#define CHECKBOX_Checked                @{"GA_Selected" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 96}
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Checkmark state. */

/*****************************************************************************/

#endif /* GADGETS_CHECKBOX_H */
@ENDNODE
