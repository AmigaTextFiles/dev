@DATABASE "gg:doc/NDK/Guide/Include/prefs/wbpattern.h"
@MASTER   "gg:os-include/prefs/wbpattern.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:58
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/wbpattern.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/wbpattern.h" LINK File}


@{b}Structures@{ub}

@{"WBPatternPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 25}


@{b}#defines@{ub}

@{"DEFPATDEPTH" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 72}               @{"ID_PTRN" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 21}              @{"MAXDEPTH" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 71}
@{"PAT_HEIGHT" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 76}                @{"PAT_WIDTH" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 75}            @{"WBP_DRAWER" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 39}
@{"WBP_ROOT" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 38}                  @{"WBP_SCREEN" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 40}           @{"WBPF_DITHER_BAD" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 52}
@{"WBPF_DITHER_BEST" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 54}          @{"WBPF_DITHER_DEF" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 51}      @{"WBPF_DITHER_GOOD" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 53}
@{"WBPF_DITHER_MASK" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 50}          @{"WBPF_NOREMAP" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 46}         @{"WBPF_PATTERN" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 43}
@{"WBPF_PLACEMENT_CENTER" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 65}     @{"WBPF_PLACEMENT_MASK" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 63}  @{"WBPF_PLACEMENT_SCALE" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 66}
@{"WBPF_PLACEMENT_SCALEGOOD" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 67}  @{"WBPF_PLACEMENT_TILE" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 64}  @{"WBPF_PRECISION_DEF" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 58}
@{"WBPF_PRECISION_EXACT" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 61}      @{"WBPF_PRECISION_ICON" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 59}  @{"WBPF_PRECISION_IMAGE" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 60}
@{"WBPF_PRECISION_MASK" LINK "gg:doc/NDK/Guide/Include/prefs/wbpattern.h/File" 57}       

@ENDNODE
@NODE File "prefs/wbpattern.h"
#ifndef PREFS_WBPATTERN_H
#define PREFS_WBPATTERN_H
/*
**      $VER: wbpattern.h 45.1 (12.11.2000)
**      Includes Release 45.1
**
**      File format for wbpattern preferences
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif

/*****************************************************************************/

#define ID_PTRN @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('P','T','R','N')

/*****************************************************************************/

struct WBPatternPrefs
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        wbp_Reserved[4];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}        wbp_Which;       /* Which pattern is it */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}        wbp_Flags;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}         wbp_Revision;    /* Must be set to zero */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}         wbp_Depth;       /* Depth of pattern */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}        wbp_DataLength;  /* Length of following data */
};

/*****************************************************************************/

/* constants for WBPatternPrefs.wbp_Which */
#define WBP_ROOT        0
#define WBP_DRAWER      1
#define WBP_SCREEN      2

/* wbp_Flags values */
#define WBPF_PATTERN    0x0001
    /* Data contains a pattern */

#define WBPF_NOREMAP    0x0010
    /* Don't remap the pattern */

        /* @{"PDTA_DitherQuality" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 123}: see pictureclass.h */
#define WBPF_DITHER_MASK        0x0300
#define WBPF_DITHER_DEF         0x0000 /* DitherQuality: Default */
#define WBPF_DITHER_BAD         0x0100 /* DitherQuality: 0 */
#define WBPF_DITHER_GOOD        0x0200 /* DitherQuality: 2 */
#define WBPF_DITHER_BEST        0x0300 /* DitherQuality: 4 */

        /* @{"OBP_Precision" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 245}: see pictureclass.h */
#define WBPF_PRECISION_MASK      0x0C00
#define WBPF_PRECISION_DEF       0x0000
#define WBPF_PRECISION_ICON      0x0400
#define WBPF_PRECISION_IMAGE     0x0800
#define WBPF_PRECISION_EXACT     0x0C00

#define WBPF_PLACEMENT_MASK      0x3000
#define WBPF_PLACEMENT_TILE      0x0000
#define WBPF_PLACEMENT_CENTER    0x1000
#define WBPF_PLACEMENT_SCALE     0x2000
#define WBPF_PLACEMENT_SCALEGOOD 0x3000

/*****************************************************************************/

#define MAXDEPTH        3       /*  Max depth supported (8 colors) */
#define DEFPATDEPTH     2       /*  Depth of default patterns */

/*  Pattern width & height: */
#define PAT_WIDTH       16
#define PAT_HEIGHT      16

/*****************************************************************************/

#endif /* PREFS_WBPATTERN_H */
@ENDNODE
