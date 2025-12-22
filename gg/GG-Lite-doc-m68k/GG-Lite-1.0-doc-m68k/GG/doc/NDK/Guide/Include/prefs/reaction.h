@DATABASE "gg:doc/NDK/Guide/Include/prefs/reaction.h"
@MASTER   "gg:os-include/prefs/reaction.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:56
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/reaction.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/reaction.h" LINK File}


@{b}Structures@{ub}

@{"ReactionPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/reaction.h/File" 28}


@{b}#defines@{ub}

@{"FONTNAMESIZE" LINK "gg:doc/NDK/Guide/Include/prefs/reaction.h/File" 26}  @{"ID_RACT" LINK "gg:doc/NDK/Guide/Include/prefs/reaction.h/File" 24}

@ENDNODE
@NODE File "prefs/reaction.h"
#ifndef PREFS_REACTION_H
#define PREFS_REACTION_H
/*
**      $VER: reaction.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Reaction preferences file definitions
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif

#ifndef GRAPHICS_TEXT_H
#include <@{"graphics/text.h" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File"}>
#endif


/*****************************************************************************/

#define ID_RACT @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('R','A','C','T')

#define @{"FONTNAMESIZE" LINK "gg:doc/NDK/Guide/Include/prefs/font.h/File" 35} (128)

struct ReactionPrefs
{
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}     rp_BevelType; /* see <@{"reaction/reaction_prefs.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File"}> */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}     rp_GlyphType; /* see (@{"reaction/reaction_prefs.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File"}> */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}     rp_LayoutSpacing;
        @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}      rp_3DProp;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}     rp_LabelPen;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}     rp_LabelPlace;
        @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}      rp_3DLabel;
        @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}      rp_SimpleRefresh;
        @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}      rp_3DLook;
        @{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65} rp_FallbackAttr;
        @{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65} rp_LabelAttr;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}     rp_FallbackName[@{"FONTNAMESIZE" LINK File 26}];
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}     rp_LabelName[@{"FONTNAMESIZE" LINK File 26}];
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}     rp_Pattern[256];
};

#endif /* PREFS_REACTION_H */
@ENDNODE
