@DATABASE "gg:doc/NDK/Guide/Include/intuition/cghooks.h"
@MASTER   "gg:os-include/intuition/cghooks.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:50
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "intuition/cghooks.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"intuition/cghooks.h" LINK File}


@{b}Structures@{ub}

@{"GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25}  @{"PGX" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 69}


@{b}#defines@{ub}

@{"CUSTOM_HOOK()" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 77}

@ENDNODE
@NODE File "intuition/cghooks.h"
#ifndef INTUITION_CGHOOKS_H
#define INTUITION_CGHOOKS_H 1
/*
**  $VER: cghooks.h 38.1 (11.11.1991)
**  Includes Release 45.1
**
**  Custom Gadget processing
**
**  (C) Copyright 1988-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif

/*
 * Package of information passed to custom and 'boopsi'
 * gadget "hook" functions.  This structure is READ ONLY.
 */
struct GadgetInfo {

    @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133}               *gi_Screen;
    @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909}               *gi_Window;     /* null for screen gadgets */
    @{"struct Requester" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 144}            *gi_Requester;  /* null if not @{"GTYP_REQGADGET" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 455} */

    /* rendering information:
     * don't use these without cloning/locking.
     * Official way is to call ObtainRPort()
     */
    @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52}             *gi_RastPort;
    @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27}                *gi_Layer;

    /* copy of dimensions of screen/window/g00/req(/group)
     * that gadget resides in.  Left/Top of this box is
     * offset from window mouse coordinates to gadget coordinates
     *          screen gadgets:                 0,0 (from screen coords)
     *  window gadgets (no g00):        0,0
     *  GTYP_GZZGADGETs (borderlayer):          0,0
     *  GZZ innerlayer gadget:          borderleft, bordertop
     *  Requester gadgets:              reqleft, reqtop
     */
    @{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896}                 gi_Domain;

    /* these are the pens for the window or screen      */
    struct
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   DetailPen;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   BlockPen;
    }                           gi_Pens;

    /* the Detail and Block pens in gi_DrInfo->dri_Pens[] are
     * for the screen.  Use the above for window-sensitive
     * colors.
     */
    @{"struct DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 66}             *gi_DrInfo;

    /* reserved space: this structure is extensible
     * anyway, but using these saves some recompilation
     */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                       gi_Reserved[6];
};

/*** system private data structure for now ***/
/* prop gadget extra info       */
struct PGX      {
    @{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896} pgx_Container;
    @{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896} pgx_NewKnob;
};

/* this casts MutualExclude for easy assignment of a hook
 * pointer to the unused MutualExclude field of a custom gadget
 */
#define CUSTOM_HOOK( gadget ) ( (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *) (gadget)->MutualExclude)

#endif
@ENDNODE
