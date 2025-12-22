@DATABASE "gg:doc/NDK/Guide/Include/devices/prtgfx.h"
@MASTER   "gg:os-include/devices/prtgfx.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:39
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/prtgfx.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/prtgfx.h" LINK File}


@{b}Structures@{ub}

@{"PrtInfo" LINK "gg:doc/NDK/Guide/Include/devices/prtgfx.h/File" 39}


@{b}Unions@{ub}

@{"colorEntry" LINK "gg:doc/NDK/Guide/Include/devices/prtgfx.h/File" 30}


@{b}#defines@{ub}

@{"PCMBLACK" LINK "gg:doc/NDK/Guide/Include/devices/prtgfx.h/File" 22}  @{"PCMBLUE" LINK "gg:doc/NDK/Guide/Include/devices/prtgfx.h/File" 23}    @{"PCMCYAN" LINK "gg:doc/NDK/Guide/Include/devices/prtgfx.h/File" 21}  @{"PCMGREEN" LINK "gg:doc/NDK/Guide/Include/devices/prtgfx.h/File" 24}  @{"PCMMAGENTA" LINK "gg:doc/NDK/Guide/Include/devices/prtgfx.h/File" 20}  @{"PCMRED" LINK "gg:doc/NDK/Guide/Include/devices/prtgfx.h/File" 25}
@{"PCMWHITE" LINK "gg:doc/NDK/Guide/Include/devices/prtgfx.h/File" 26}  @{"PCMYELLOW" LINK "gg:doc/NDK/Guide/Include/devices/prtgfx.h/File" 19}  

@ENDNODE
@NODE File "devices/prtgfx.h"
#ifndef DEVICES_PRTGFX_H
#define DEVICES_PRTGFX_H
/*
**      $VER: prtgfx.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      graphics printer driver structure definitions
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef GRAPHICS_RASTPORT_H
#include <@{"graphics/rastport.h" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File"}>
#endif

/****************************************************************************/

#define PCMYELLOW       0               /* byte index for yellow */
#define PCMMAGENTA      1               /* byte index for magenta */
#define PCMCYAN         2               /* byte index for cyan */
#define PCMBLACK        3               /* byte index for black */
#define PCMBLUE         @{"PCMYELLOW" LINK File 19}       /* byte index for blue */
#define PCMGREEN        @{"PCMMAGENTA" LINK File 20}      /* byte index for green */
#define PCMRED          @{"PCMCYAN" LINK File 21}         /* byte index for red */
#define PCMWHITE        @{"PCMBLACK" LINK File 22}        /* byte index for white */

/****************************************************************************/

union colorEntry
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   colorLong;      /* quick access to all of YMCB */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   colorByte[4];   /* 1 entry for each of YMCB */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    colorSByte[4];  /* ditto (except signed) */
};

/****************************************************************************/

 /* printer info */struct PrtInfo
{
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                    (*pi_render)();         /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *       pi_rp;                  /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *       pi_temprp;              /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *                 pi_RowBuf;              /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *                 pi_HamBuf;              /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"union colorEntry" LINK File 30} *      pi_ColorMap;            /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"union colorEntry" LINK File 30} *      pi_ColorInt;            /* color intensities for entire row */
        @{"union colorEntry" LINK File 30} *      pi_HamInt;              /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"union colorEntry" LINK File 30} *      pi_Dest1Int;            /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"union colorEntry" LINK File 30} *      pi_Dest2Int;            /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *                 pi_ScaleX;              /* array of scale values for X */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *                 pi_ScaleXAlt;           /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *                 pi_dmatrix;             /* pointer to dither matrix */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *                 pi_TopBuf;              /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *                 pi_BotBuf;              /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */

        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_RowBufSize;          /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_HamBufSize;          /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_ColorMapSize;        /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_ColorIntSize;        /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_HamIntSize;          /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_Dest1IntSize;        /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_Dest2IntSize;        /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_ScaleXSize;          /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_ScaleXAltSize;       /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */

        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_PrefsFlags;          /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                   pi_special;             /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_xstart;              /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_ystart;              /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_width;               /* source width (in pixels) */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_height;              /* source height (in pixels) */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                   pi_pc;                  /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                   pi_pr;                  /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_ymult;               /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_ymod;                /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                    pi_ety;                 /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_xpos;                /* offset to start printing picture */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_threshold;           /* threshold value (from prefs) */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_tempwidth;           /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_flags;               /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */

        /* V44 additions */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *                 pi_ReduceBuf;           /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   pi_ReduceBufSize;       /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *           pi_SourceHook;          /* PRIVATE - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *                 pi_InvertHookBuf;       /* RESERVED - DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */
};

#endif  /* DEVICES_PRTGFX_H */
@ENDNODE
