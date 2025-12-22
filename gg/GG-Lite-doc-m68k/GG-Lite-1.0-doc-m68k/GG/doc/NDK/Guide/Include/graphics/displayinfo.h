@DATABASE "gg:doc/NDK/Guide/Include/graphics/displayinfo.h"
@MASTER   "gg:os-include/graphics/displayinfo.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:53
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/displayinfo.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/displayinfo.h" LINK File}


@{b}Structures@{ub}

@{"DimensionInfo" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 121}  @{"DisplayInfo" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 53}  @{"MonitorInfo" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 138}  @{"NameInfo" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 164}  @{"QueryHeader" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 45}
@{"VecInfo" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 177}        


@{b}Typedefs@{ub}

@{"DisplayInfoHandle" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 35}


@{b}#defines@{ub}

@{"DI_AVAIL_NOCHIPS" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 73}           @{"DI_AVAIL_NOMONITOR" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 74}
@{"DI_AVAIL_NOTWITHGENLOCK" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 75}    @{"DIPF_IS_AA" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 88}
@{"DIPF_IS_BEAMSYNC" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 101}           @{"DIPF_IS_DBUFFER" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 116}
@{"DIPF_IS_DRAGGABLE" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 99}          @{"DIPF_IS_DUALPF" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 80}
@{"DIPF_IS_ECS" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 84}                @{"DIPF_IS_EXTRAHALFBRITE" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 103}
@{"DIPF_IS_FOREIGN" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 118}            @{"DIPF_IS_GENLOCK" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 96}
@{"DIPF_IS_HAM" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 82}                @{"DIPF_IS_LACE" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 79}
@{"DIPF_IS_PAL" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 94}                @{"DIPF_IS_PANELLED" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 100}
@{"DIPF_IS_PF2PRI" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 81}             @{"DIPF_IS_PROGBEAM" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 117}
@{"DIPF_IS_SCANDBL" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 109}            @{"DIPF_IS_SPRITES" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 95}
@{"DIPF_IS_SPRITES_ATT" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 106}        @{"DIPF_IS_SPRITES_BORDER" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 108}
@{"DIPF_IS_SPRITES_CHNG_BASE" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 110}  @{"DIPF_IS_SPRITES_CHNG_PRI" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 112}
@{"DIPF_IS_SPRITES_CHNG_RES" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 107}   @{"DIPF_IS_WB" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 98}
@{"DISPLAYNAMELEN" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 162}             @{"DTAG_DIMS" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 40}
@{"DTAG_DISP" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 39}                  @{"DTAG_MNTR" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 41}
@{"DTAG_NAME" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 42}                  @{"DTAG_VEC" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 43}
@{"MCOMPAT_MIXED" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 158}              @{"MCOMPAT_NOBODY" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 160}
@{"MCOMPAT_SELF" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 159}               

@ENDNODE
@NODE File "graphics/displayinfo.h"
#ifndef GRAPHICS_DISPLAYINFO_H
#define GRAPHICS_DISPLAYINFO_H
/*
**      $VER: displayinfo.h 39.13 (31.5.1993)
**      Includes Release 45.1
**
**      include define file for displayinfo database
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif /* EXEC_TYPES_H */

#ifndef GRAPHICS_GFX_H
#include <@{"graphics/gfx.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File"}>
#endif /* GRAPHICS_GFX_H */

#ifndef GRAPHICS_MONITOR_H
#include <@{"graphics/monitor.h" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File"}>
#endif /* GRAPHICS_MONITOR_H */

#ifndef GRAPHICS_MODEID_H
#include <@{"graphics/modeid.h" LINK "gg:doc/NDK/Guide/Include/graphics/modeid.h/File"}>
#endif /* GRAPHICS_MODEID_H */

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif /* UTILITY_TAGITEM_H */

/* the "public" handle to a DisplayInfoRecord */

typedef @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} DisplayInfoHandle;

/* datachunk type identifiers */

#define DTAG_DISP               0x80000000
#define DTAG_DIMS               0x80001000
#define DTAG_MNTR               0x80002000
#define DTAG_NAME               0x80003000
#define DTAG_VEC                0x80004000      /* internal use only */

struct QueryHeader
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   StructID;       /* datachunk type identifier */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   DisplayID;      /* copy of display record key   */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   SkipID;         /* @{"TAG_SKIP" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 45} -- see tagitems.h */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   Length;         /* length of local data in double-longwords */
};

struct DisplayInfo
{
        @{"struct  QueryHeader" LINK File 45} Header;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   NotAvailable;   /* if @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} available, else see defines */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   PropertyFlags;  /* Properties of this mode see defines */
        @{"Point" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 39}   Resolution;     /* ticks-per-pixel X/Y                 */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   PixelSpeed;     /* aproximation in nanoseconds         */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   NumStdSprites;  /* number of standard amiga sprites    */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   PaletteRange;   /* OBSOLETE - use Red/Green/Blue bits instead */
        @{"Point" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 39}   SpriteResolution; /* std sprite ticks-per-pixel X/Y    */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   pad[4];         /* used internally */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   RedBits;        /* number of Red bits this display supports (V39) */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   GreenBits;      /* number of Green bits this display supports (V39) */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   BlueBits;       /* number of Blue bits this display supports (V39) */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   pad2[5];        /* find some use for this. */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   reserved[2];    /* terminator */
};

/* availability */

#define DI_AVAIL_NOCHIPS        0x0001
#define DI_AVAIL_NOMONITOR      0x0002
#define DI_AVAIL_NOTWITHGENLOCK 0x0004

/* mode properties */

#define DIPF_IS_LACE            0x00000001
#define DIPF_IS_DUALPF          0x00000002
#define DIPF_IS_PF2PRI          0x00000004
#define DIPF_IS_HAM             0x00000008

#define DIPF_IS_ECS             0x00000010      /* note: ECS modes (SHIRES, VGA, and **
                                                                                        ** PRODUCTIVITY) do not support      **
                                                                                        ** attached sprites.                 **
                                                                                        */
#define DIPF_IS_AA              0x00010000      /* AA modes - may only be available
                                                ** if machine has correct memory
                                                ** type to support required
                                                ** bandwidth - check availability.
                                                ** (V39)
                                                */
#define DIPF_IS_PAL             0x00000020
#define DIPF_IS_SPRITES         0x00000040
#define DIPF_IS_GENLOCK         0x00000080

#define DIPF_IS_WB              0x00000100
#define DIPF_IS_DRAGGABLE       0x00000200
#define DIPF_IS_PANELLED        0x00000400
#define DIPF_IS_BEAMSYNC        0x00000800

#define DIPF_IS_EXTRAHALFBRITE  0x00001000

/* The following DIPF_IS_... flags are new for V39 */
#define DIPF_IS_SPRITES_ATT             0x00002000      /* supports attached sprites */
#define DIPF_IS_SPRITES_CHNG_RES        0x00004000      /* supports variable sprite resolution */
#define DIPF_IS_SPRITES_BORDER          0x00008000      /* sprite can be displayed in the border */
#define DIPF_IS_SCANDBL                 0x00020000      /* scan doubled */
#define DIPF_IS_SPRITES_CHNG_BASE       0x00040000
                                                                                        /* can change the sprite base colour */
#define DIPF_IS_SPRITES_CHNG_PRI        0x00080000
                                                                                        /* can change the sprite priority
                                                                                        ** with respect to the playfield(s).
                                                                                        */
#define DIPF_IS_DBUFFER         0x00100000      /* can support double buffering */
#define DIPF_IS_PROGBEAM        0x00200000      /* is a programmed beam-sync mode */
#define DIPF_IS_FOREIGN         0x80000000      /* this mode is not native to the Amiga */


struct DimensionInfo
{
        @{"struct  QueryHeader" LINK File 45} Header;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   MaxDepth;             /* log2( max number of colors ) */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   MinRasterWidth;       /* minimum width in pixels      */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   MinRasterHeight;      /* minimum height in pixels     */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   MaxRasterWidth;       /* maximum width in pixels      */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   MaxRasterHeight;      /* maximum height in pixels     */
        @{"struct  Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27}   Nominal;  /* "standard" dimensions        */
        @{"struct  Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27}   MaxOScan; /* fixed, hardware dependent    */
        @{"struct  Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27} VideoOScan; /* fixed, hardware dependent    */
        @{"struct  Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27}   TxtOScan; /* editable via preferences     */
        @{"struct  Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27}   StdOScan; /* editable via preferences     */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   pad[14];
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   reserved[2];          /* terminator */
};

struct MonitorInfo
{
        @{"struct  QueryHeader" LINK File 45} Header;
        @{"struct  MonitorSpec" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 25}  *Mspc;   /* pointer to monitor specification  */
        @{"Point" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 39}   ViewPosition;         /* editable via preferences          */
        @{"Point" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 39}   ViewResolution;       /* standard monitor ticks-per-pixel  */
        @{"struct  Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27} ViewPositionRange;  /* fixed, hardware dependent */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   TotalRows;            /* display height in scanlines       */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   TotalColorClocks;     /* scanline width in 280 ns units    */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   MinRow;       /* absolute minimum active scanline  */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Compatibility;        /* how this coexists with others     */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   pad[32];
        @{"Point" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 39}   MouseTicks;
        @{"Point" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 39}   DefaultViewPosition;  /* original, never changes */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   PreferredModeID;      /* for Preferences */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   reserved[2];          /* terminator */
};

/* monitor compatibility */

#define MCOMPAT_MIXED   0       /* can share display with other @{"MCOMPAT_MIXED" LINK File 158} */
#define MCOMPAT_SELF    1       /* can share only within same monitor */
#define MCOMPAT_NOBODY -1       /* only one viewport at a time */

#define DISPLAYNAMELEN 32

struct NameInfo
{
        @{"struct  QueryHeader" LINK File 45} Header;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   Name[@{"DISPLAYNAMELEN" LINK File 162}];
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   reserved[2];          /* terminator */
};

/******************************************************************************/

/* The following VecInfo structure is PRIVATE, for our use only
 * Touch these, and burn! (V39)
 */

struct VecInfo
{
        @{"struct  QueryHeader" LINK File 45}   Header;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    Vec;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    Data;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Type;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   pad[3];
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   reserved[2];
};

#endif  /* GRAPHICS_DISPLAYINFO_H */
@ENDNODE
