@DATABASE "gg:doc/NDK/Guide/Include/devices/conunit.h"
@MASTER   "gg:os-include/devices/conunit.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:22
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/conunit.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/conunit.h" LINK File}


@{b}Structures@{ub}

@{"ConUnit" LINK "gg:doc/NDK/Guide/Include/devices/conunit.h/File" 53}


@{b}#defines@{ub}

@{"CONFLAG_DEFAULT" LINK "gg:doc/NDK/Guide/Include/devices/conunit.h/File" 44}  @{"CONFLAG_NODRAW_ON_NEWSIZE" LINK "gg:doc/NDK/Guide/Include/devices/conunit.h/File" 45}  @{"CONU_CHARMAP" LINK "gg:doc/NDK/Guide/Include/devices/conunit.h/File" 39}  @{"CONU_LIBRARY" LINK "gg:doc/NDK/Guide/Include/devices/conunit.h/File" 34}
@{"CONU_SNIPMAP" LINK "gg:doc/NDK/Guide/Include/devices/conunit.h/File" 40}     @{"CONU_STANDARD" LINK "gg:doc/NDK/Guide/Include/devices/conunit.h/File" 35}              @{"MAXTABS" LINK "gg:doc/NDK/Guide/Include/devices/conunit.h/File" 50}       @{"PMB_ASM" LINK "gg:doc/NDK/Guide/Include/devices/conunit.h/File" 48}
@{"PMB_AWM" LINK "gg:doc/NDK/Guide/Include/devices/conunit.h/File" 49}          

@ENDNODE
@NODE File "devices/conunit.h"
#ifndef DEVICES_CONUNIT_H
#define DEVICES_CONUNIT_H
/*
**      $VER: conunit.h 36.15 (20.11.1990)
**      Includes Release 45.1
**
**      Console device unit definitions
**
**      (C) Copyright 1986-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include        <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_PORTS_H
#include        <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif

#ifndef DEVICES_CONSOLE_H
#include        <@{"devices/console.h" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File"}>
#endif

#ifndef DEVICES_KEYMAP_H
#include        <@{"devices/keymap.h" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File"}>
#endif

#ifndef DEVICES_INPUTEVENT_H
#include        <@{"devices/inputevent.h" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File"}>
#endif

/* ---- console unit numbers for @{"OpenDevice()" LINK "gg:doc/NDK/Guide/exec/OpenDevice"} */
#define CONU_LIBRARY    -1      /* no unit, just fill in IO_DEVICE field */
#define CONU_STANDARD   0       /* standard unmapped console */

/* ---- New unit numbers for @{"OpenDevice()" LINK "gg:doc/NDK/Guide/exec/OpenDevice"} - (V36) */

#define CONU_CHARMAP    1       /* bind character map to console */
#define CONU_SNIPMAP    3       /* bind character map w/ snip to console */

/* ---- New flag defines for @{"OpenDevice()" LINK "gg:doc/NDK/Guide/exec/OpenDevice"} - (V37) */

#define CONFLAG_DEFAULT                 0
#define CONFLAG_NODRAW_ON_NEWSIZE       1


#define PMB_ASM         (@{"M_LNM" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 96}+1)       /* internal storage bit for AS flag */
#define PMB_AWM         (@{"PMB_ASM" LINK File 48}+1)     /* internal storage bit for AW flag */
#define MAXTABS         80


struct  ConUnit {
    @{"struct  MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} cu_MP;
    /* ---- read only variables */
    @{"struct  Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *cu_Window;  /* intuition window bound to this unit */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_XCP;             /* character position */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_YCP;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_XMax;            /* max character position */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_YMax;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_XRSize;          /* character raster size */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_YRSize;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_XROrigin;        /* raster origin */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_YROrigin;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_XRExtant;        /* raster maxima */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_YRExtant;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_XMinShrink;      /* smallest area intact from resize process */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_YMinShrink;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_XCCP;            /* cursor position */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_YCCP;

    /* ---- read/write variables (writes must must be protected) */
    /* ---- storage for AskKeyMap and SetKeyMap */
    @{"struct  KeyMap" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 21} cu_KeyMapStruct;
    /* ---- tab stops */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   cu_TabStops[@{"MAXTABS" LINK File 50}]; /* 0 at start, 0xffff at end of list */

    /* ---- console rastport attributes */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    cu_Mask;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    cu_FgPen;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    cu_BgPen;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    cu_AOLPen;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    cu_DrawMode;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    cu_Obsolete1;       /* was cu_AreaPtSz -- not used in V36 */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    cu_Obsolete2;       /* was cu_AreaPtrn -- not used in V36 */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   cu_Minterms[8];     /* console minterms */
    @{"struct  TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *cu_Font;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   cu_AlgoStyle;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   cu_TxFlags;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   cu_TxHeight;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   cu_TxWidth;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   cu_TxBaseline;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    cu_TxSpacing;

    /* ---- console MODES and RAW EVENTS switches */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   cu_Modes[(@{"PMB_AWM" LINK File 49}+7)/8];    /* one bit per mode */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   cu_RawEvents[(@{"IECLASS_MAX" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 72}+8)/8];
};

#endif  /* DEVICES_CONUNIT_H */
@ENDNODE
