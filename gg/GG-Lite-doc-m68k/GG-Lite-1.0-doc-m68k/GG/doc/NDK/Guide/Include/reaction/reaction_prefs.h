@DATABASE "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h"
@MASTER   "gg:os-include/reaction/reaction_prefs.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:16
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "reaction/reaction_prefs.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"reaction/reaction_prefs.h" LINK File}


@{b}Structures@{ub}

@{"UIPrefs" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File" 30}


@{b}#defines@{ub}

@{"BVT_GT" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File" 59}  @{"BVT_THICK" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File" 61}  @{"BVT_THIN" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File" 60}  @{"BVT_XEN" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File" 62}           @{"BVT_XENTHIN" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File" 63}  @{"ClassActPrefs" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File" 28}
@{"GLT_3D" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File" 68}  @{"GLT_FLAT" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File" 67}   @{"GLT_GT" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File" 66}    @{"RAPREFSSEMAPHORE" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File" 20}  

@ENDNODE
@NODE File "reaction/reaction_prefs.h"
#ifndef REACTION_REACTION_PREFS_H
#define REACTION_REACTION_PREFS_H
/*
**      $VER: reaction_prefs.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Reaction preferences definitions
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_SEMAPHORES_H
#include <@{"exec/semaphores.h" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File"}>
#endif

/*
 * Obtain this semaphore while reading the preferences
 */
#define RAPREFSSEMAPHORE "REACTION-PREFS"

/* WARNING: This structure has been changing, and will continue to change.
 * In the future, this structure might possible be accesssed at a higher
 * level via a tag list. For now, except for class authors wishing our
 * support in handling prefs, this is data is to be considered off limits.
 */

#define ClassActPrefs UIPrefs

struct UIPrefs
{
        /* Set PrefsVersion to 1 */
        @{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40}   cap_Semaphore;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                                    cap_PrefsVersion;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                                    cap_PrefsSize;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}                                    cap_BevelType;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                                    cap_LayoutSpacing;
        @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}                                     cap_3DLook;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                                    cap_LabelPen;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}                                    cap_LabelPlace;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}                                    cap_3DLabel;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                                   *cap_Reserved1;
        @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}                                     cap_SimpleRefresh;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}                                    cap_Pattern[256];
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                                   *cap_Reserved2;

        @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}                                     cap_3DProp;
        @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}                                     cap_Reserved3;

        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}                                    cap_GlyphType; /* currently unsupported/unused!! */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}                                    cap_Reserved4;

        @{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65}                 *cap_FallbackAttr;
        @{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65}                 *cap_LabelAttr;
};


/* Bevel Types */
#define BVT_GT      0   /* GadTools style 2:1 bevels */
#define BVT_THIN    1   /* CA 1:1 bevels */
#define BVT_THICK   2   /* CA 2:1 4 color thick bevels */
#define BVT_XEN     3   /* 4 color Xen-Style inspired 1/2 shine bevels */
#define BVT_XENTHIN 4   /* 3 color Xen-Style inspired thin 1/2 shine 1:1 bevels */

/* Glyph Types */
#define GLT_GT    0
#define GLT_FLAT  1
#define GLT_3D    2

#endif /* REACTION_REACTION_PREFS_H */
@ENDNODE
