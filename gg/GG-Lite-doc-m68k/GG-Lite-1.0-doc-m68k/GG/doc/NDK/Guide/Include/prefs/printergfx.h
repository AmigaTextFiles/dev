@DATABASE "gg:doc/NDK/Guide/Include/prefs/printergfx.h"
@MASTER   "gg:os-include/prefs/printergfx.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:53
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/printergfx.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/printergfx.h" LINK File}


@{b}Structures@{ub}

@{"PrinterGfxPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 31}


@{b}#defines@{ub}

@{"ID_PGFX" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 28}            @{"PA_HORIZONTAL" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 50}         @{"PA_VERTICAL" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 51}
@{"PCCB_BLUE" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 66}          @{"PCCB_GREEN" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 65}            @{"PCCB_RED" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 64}
@{"PCCF_BLUE" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 70}          @{"PCCF_GREEN" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 69}            @{"PCCF_RED" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 68}
@{"PD_ABSOLUTE" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 75}        @{"PD_BOUNDED" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 74}            @{"PD_FLOYD" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 82}
@{"PD_HALFTONE" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 81}        @{"PD_IGNORE" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 73}             @{"PD_MULTIPLY" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 77}
@{"PD_ORDERED" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 80}         @{"PD_PIXEL" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 76}              @{"PGFB_ANTI_ALIAS" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 87}
@{"PGFB_CENTER_IMAGE" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 85}  @{"PGFB_INTEGER_SCALING" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 86}  @{"PGFF_ANTI_ALIAS" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 91}
@{"PGFF_CENTER_IMAGE" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 89}  @{"PGFF_INTEGER_SCALING" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 90}  @{"PI_NEGATIVE" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 61}
@{"PI_POSITIVE" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 60}        @{"PS_BW" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 54}                 @{"PS_COLOR" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 56}
@{"PS_GREY_SCALE2" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 57}     @{"PS_GREYSCALE" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 55}          

@ENDNODE
@NODE File "prefs/printergfx.h"
#ifndef PREFS_PRINTERGFX_H
#define PREFS_PRINTERGFX_H
/*
**      $VER: printergfx.h 38.2 (3.7.1991)
**      Includes Release 45.1
**
**      File format for graphics printer preferences
**
**      (C) Copyright 1991-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif


/*****************************************************************************/


#define ID_PGFX @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('P','G','F','X')


struct PrinterGfxPrefs
{
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  pg_Reserved[4];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pg_Aspect;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pg_Shade;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pg_Image;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}  pg_Threshold;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pg_ColorCorrect;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pg_Dimensions;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pg_Dithering;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pg_GraphicFlags;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pg_PrintDensity;              /* Print density 1 - 7 */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pg_PrintMaxWidth;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pg_PrintMaxHeight;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pg_PrintXOffset;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pg_PrintYOffset;
};

/* constants for PrinterGfxPrefs.pg_Aspect */
#define PA_HORIZONTAL 0
#define PA_VERTICAL   1

/* constants for PrinterGfxPrefs.pg_Shade */
#define PS_BW           0
#define PS_GREYSCALE    1
#define PS_COLOR        2
#define PS_GREY_SCALE2  3

/* constants for PrinterGfxPrefs.pg_Image */
#define PI_POSITIVE 0
#define PI_NEGATIVE 1

/* flags for PrinterGfxPrefs.pg_ColorCorrect */
#define PCCB_RED   1    /* color correct red shades   */
#define PCCB_GREEN 2    /* color correct green shades */
#define PCCB_BLUE  3    /* color correct blue shades  */

#define PCCF_RED   (1<<0)
#define PCCF_GREEN (1<<1)
#define PCCF_BLUE  (1<<2)

/* constants for PrinterGfxPrefs.pg_Dimensions */
#define PD_IGNORE   0  /* ignore max width/height settings */
#define PD_BOUNDED  1  /* use max w/h as boundaries        */
#define PD_ABSOLUTE 2  /* use max w/h as absolutes         */
#define PD_PIXEL    3  /* use max w/h as prt pixels        */
#define PD_MULTIPLY 4  /* use max w/h as multipliers       */

/* constants for PrinterGfxPrefs.pg_Dithering */
#define PD_ORDERED      0  /* ordered dithering */
#define PD_HALFTONE     1  /* halftone dithering        */
#define PD_FLOYD        2  /* Floyd-Steinberg dithering */

/* flags for PrinterGfxPrefs.pg_GraphicsFlags */
#define PGFB_CENTER_IMAGE       0       /* center image on paper */
#define PGFB_INTEGER_SCALING    1       /* force integer scaling */
#define PGFB_ANTI_ALIAS         2       /* anti-alias image      */

#define PGFF_CENTER_IMAGE       (1<<0)
#define PGFF_INTEGER_SCALING    (1<<1)
#define PGFF_ANTI_ALIAS         (1<<2)


/*****************************************************************************/


#endif /* PREFS_PRINTERGFX_H */
@ENDNODE
