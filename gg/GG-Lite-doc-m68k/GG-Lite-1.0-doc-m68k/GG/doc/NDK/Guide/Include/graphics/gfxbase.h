@DATABASE "gg:doc/NDK/Guide/Include/graphics/gfxbase.h"
@MASTER   "gg:os-include/graphics/gfxbase.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:57
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/gfxbase.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/gfxbase.h" LINK File}


@{b}Structures@{ub}

@{"GfxBase" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 26}


@{b}#defines@{ub}

@{"BANDWIDTH_1X" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 181}    @{"BANDWIDTH_2XDBL" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 183}  @{"BANDWIDTH_2XNML" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 182}  @{"BANDWIDTH_4X" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 184}
@{"BLITMSG_FAULT" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 153}   @{"BUS_16" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 177}           @{"BUS_32" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 179}           @{"ChunkyToPlanarPtr" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 130}
@{"DBL_CAS" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 180}         @{"GENLOC" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 139}           @{"GFXB_AA_ALICE" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 159}    @{"GFXB_AA_LISA" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 160}
@{"GFXB_AA_MLISA" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 161}   @{"GFXB_BIG_BLITS" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 156}   @{"GFXB_HR_AGNUS" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 157}    @{"GFXB_HR_DENISE" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 158}
@{"GFXF_AA_ALICE" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 166}   @{"GFXF_AA_LISA" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 167}     @{"GFXF_AA_MLISA" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 168}    @{"GFXF_BIG_BLITS" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 163}
@{"GFXF_HR_AGNUS" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 164}   @{"GFXF_HR_DENISE" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 165}   @{"GRAPHICSNAME" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 189}     @{"LPEN_SWAP_FRAMES" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 145}
@{"NEW_DATABASE" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 187}    @{"NML_CAS" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 178}          @{"NTSC" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 138}             @{"PAL" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 140}
@{"REALLY_PAL" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 142}      @{"SETCHIPREV_A" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 171}     @{"SETCHIPREV_AA" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 173}    @{"SETCHIPREV_BEST" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 174}
@{"SETCHIPREV_ECS" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 172}  @{"TODA_SAFE" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 141}        

@ENDNODE
@NODE File "graphics/gfxbase.h"
#ifndef GRAPHICS_GFXBASE_H
#define GRAPHICS_GFXBASE_H
/*
**      $VER: gfxbase.h 39.21 (21.4.1993)
**      Includes Release 45.1
**
**      graphics base definitions
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif
#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif
#ifndef EXEC_INTERRUPTS_H
#include <@{"exec/interrupts.h" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File"}>
#endif
#ifndef GRAPHICS_MONITOR_H
#include <@{"graphics/monitor.h" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File"}>
#endif

struct GfxBase
{
        @{"struct  Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}  LibNode;
        @{"struct  View" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 64} *ActiView;
        @{"struct  copinit" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 100} *copinit;       /* ptr to copper start up list */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    *cia;                   /* for 8520 resource use */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    *blitter;               /* for future blitter resource use */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *LOFlist;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *SHFlist;
        @{"struct  bltnode" LINK "gg:doc/NDK/Guide/Include/hardware/blit.h/File" 88} *blthd,*blttl;
        @{"struct  bltnode" LINK "gg:doc/NDK/Guide/Include/hardware/blit.h/File" 88} *bsblthd,*bsblttl;
        @{"struct  Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} vbsrv,timsrv,bltsrv;
        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20}     TextFonts;
        @{"struct  TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *DefaultFont;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Modes;                  /* copy of current first bplcon0 */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    VBlank;
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    @{"Debug" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 73};
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    BeamSync;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    system_bplcon0;         /* it is ored into each bplcon0 for display */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   SpriteReserved;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   bytereserved;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Flags;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    BlitLock;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    BlitNest;

        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} BlitWaitQ;
        @{"struct  Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *BlitOwner;
        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} TOF_WaitQ;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   DisplayFlags;           /* @{"NTSC" LINK File 138} @{"PAL" LINK File 140} @{"GENLOC" LINK File 139} etc*/
                                        /* flags initialized at power on */
        @{"struct  SimpleSprite" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 17} **SimpleSprites;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   MaxDisplayRow;          /* hardware stuff, do not use */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   MaxDisplayColumn;       /* hardware stuff, do not use */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   NormalDisplayRows;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   NormalDisplayColumns;
        /* the following are for standard non interlace, 1/2 wb width */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   NormalDPMX;             /* Dots per meter on display */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   NormalDPMY;             /* Dots per meter on display */
        @{"struct  SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *LastChanceMemory;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *LCMptr;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   MicrosPerLine;          /* 256 time usec/line */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   MinDisplayColumn;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ChipRevBits0;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   MemType;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   crb_reserved[4];
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   monitor_id;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   hedley[8];
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   hedley_sprites[8];      /* sprite ptrs for intuition mouse */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   hedley_sprites1[8];     /* sprite ptrs for intuition mouse */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    hedley_count;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   hedley_flags;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    hedley_tmp;
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    *hash_table;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   current_tot_rows;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   current_tot_cclks;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   hedley_hint;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   hedley_hint2;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   nreserved[4];
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    *a2024_sync_raster;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   control_delta_pal;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   control_delta_ntsc;
        @{"struct  MonitorSpec" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 25} *current_monitor;
        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} MonitorList;
        @{"struct  MonitorSpec" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 25} *default_monitor;
        @{"struct  SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *MonitorListSemaphore;
        @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24}    *DisplayInfoDataBase;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   TopLine;
        @{"struct  SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *ActiViewCprSemaphore;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   *UtilBase;              /* for hook and tag utilities. had to change because of name clash      */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   *ExecBase;              /* to link with rom.lib */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *bwshifts;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *StrtFetchMasks;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *StopFetchMasks;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *Overrun;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    *RealStops;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   SpriteWidth;    /* current width (in words) of sprites */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   SpriteFMode;            /* current sprite fmode bits    */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    SoftSprites;    /* bit mask of size change knowledgeable sprites */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    arraywidth;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   DefaultSpriteWidth;     /* what width intuition wants */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    SprMoveDisable;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   WantChips;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   BoardMemType;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   Bugs;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   *gb_LayersBase;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ColorMask;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    IVector;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    IData;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   SpecialCounter;         /* special for double buffering */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    DBList;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   MonitorFlags;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ScanDoubledSprites;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   BP3Bits;
        @{"struct  AnalogSignalInterval" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 152} MonitorVBlank;
        @{"struct  MonitorSpec" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 25} *natural_monitor;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    ProgData;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ExtSprites;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   pad3;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   GfxFlags;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   VBCounter;
        @{"struct  SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *HashTableSemaphore;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   *HWEmul[9];
};

#define ChunkyToPlanarPtr HWEmul[0]






/* Values for GfxBase->DisplayFlags */
#define NTSC            1
#define GENLOC          2
#define PAL             4
#define TODA_SAFE       8
#define REALLY_PAL      16      /* what is actual crystal frequency
                                 (as opposed to what bootmenu set the agnus to)?
                                 (V39) */
#define LPEN_SWAP_FRAMES        32
                                /* LightPen software could set this bit if the
                                 * "lpen-with-interlace" fix put in for V39
                                 * does not work. This is true of a number of
                                 * Agnus chips.
                                 * (V40).
                                 */

#define BLITMSG_FAULT   4

/* bits defs for ChipRevBits */
#define GFXB_BIG_BLITS  0
#define GFXB_HR_AGNUS   0
#define GFXB_HR_DENISE  1
#define GFXB_AA_ALICE   2
#define GFXB_AA_LISA    3
#define GFXB_AA_MLISA   4       /* internal use only. */

#define GFXF_BIG_BLITS  1
#define GFXF_HR_AGNUS   1
#define GFXF_HR_DENISE  2
#define GFXF_AA_ALICE   4
#define GFXF_AA_LISA    8
#define GFXF_AA_MLISA   16      /* internal use only */

/* Pass ONE of these to @{"SetChipRev()" LINK "gg:doc/NDK/Guide/graphics/SetChipRev"} */
#define SETCHIPREV_A    @{"GFXF_HR_AGNUS" LINK File 164}
#define SETCHIPREV_ECS  (@{"GFXF_HR_AGNUS" LINK File 164} | @{"GFXF_HR_DENISE" LINK File 165})
#define SETCHIPREV_AA   (@{"GFXF_AA_ALICE" LINK File 166} | @{"GFXF_AA_LISA" LINK File 167} | @{"SETCHIPREV_ECS" LINK File 172})
#define SETCHIPREV_BEST 0xffffffff

/* memory type */
#define BUS_16          0
#define NML_CAS         0
#define BUS_32          1
#define DBL_CAS         2
#define BANDWIDTH_1X    (@{"BUS_16" LINK File 177} | @{"NML_CAS" LINK File 178})
#define BANDWIDTH_2XNML @{"BUS_32" LINK File 179}
#define BANDWIDTH_2XDBL @{"DBL_CAS" LINK File 180}
#define BANDWIDTH_4X    (@{"BUS_32" LINK File 179} | @{"DBL_CAS" LINK File 180})

/* GfxFlags (private) */
#define NEW_DATABASE    1

#define GRAPHICSNAME    "graphics.library"

#endif  /* GRAPHICS_GFXBASE_H */
@ENDNODE
