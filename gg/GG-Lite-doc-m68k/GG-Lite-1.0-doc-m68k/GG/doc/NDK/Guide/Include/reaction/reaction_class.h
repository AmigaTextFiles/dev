@DATABASE "gg:doc/NDK/Guide/Include/reaction/reaction_class.h"
@MASTER   "gg:os-include/reaction/reaction_class.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:12
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "reaction/reaction_class.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"reaction/reaction_class.h" LINK File}


@{b}Structures@{ub}

@{"gpClipRect" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_class.h/File" 40}  @{"SpecialPens" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_class.h/File" 20}


@{b}#defines@{ub}

@{"GM_CLIPRECT" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_class.h/File" 33}  @{"GMC_INVISIBLE" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_class.h/File" 52}  @{"GMC_PARTIAL" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_class.h/File" 51}  @{"GMC_VISIBLE" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_class.h/File" 50}

@ENDNODE
@NODE File "reaction/reaction_class.h"
#ifndef REACTION_REACTION_CLASS_H
#define REACTION_REACTION_CLASS_H
/*
**      $VER: reaction_class.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      reaction class author definitions
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef INTUITION_CGHOOKS_H
#include <@{"intuition/cghooks.h" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File"}>
#endif

/*
 * PRIVATE!
 */
struct SpecialPens
{
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} sp_Version;        /* Currently 0 */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} sp_DarkPen;        /* XEN/Thick extended locked pen */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} sp_LightPen;       /* XEN/Thick extended locked pen */
        /* NOTE: This structure may grow! */
};

/*****************************************************************************
 * Custom method defined and supported by some Reaction Gadgets
 * When this method is supported by more (all?) Reaction Gadgets
 * this structure may move to @{"intuition/gadgetclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File"}
 */
#define GM_CLIPRECT  (0x550001L)

/* The @{"GM_CLIPRECT" LINK File 33} method is used to pass a gadget a cliprect
 * it should install before rendering to @{"ObtainGIRPort()" LINK "gg:doc/NDK/Guide/intuition/ObtainGIRPort"} rastports
 * to support proper usage within virtual groups.
 */

struct gpClipRect
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                MethodID;       /* @{"GM_CLIPRECT" LINK File 33}              */
        @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25}   *gpc_GInfo;      /* GadgetInfo               */
        @{"struct Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27}    *gpc_ClipRect;   /* Rectangle To Clip To     */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                gpc_Flags;      /* Flags                    */
};

/* Possible return values from @{"GM_CLIPRECT" LINK File 33}
 */
#define GMC_VISIBLE                     2
#define GMC_PARTIAL                     1
#define GMC_INVISIBLE           0

/**************************************************************************/

#endif /* REACTION_REACTION_CLASS_H */
@ENDNODE
