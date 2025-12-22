@DATABASE "gg:doc/NDK/Guide/Include/graphics/view.h"
@MASTER   "gg:os-include/graphics/view.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:11
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/view.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/view.h" LINK File}


@{b}Structures@{ub}

@{"ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143}  @{"DBufInfo" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 279}       @{"PaletteExtra" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 210}  @{"RasInfo" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 136}  @{"View" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 64}  @{"ViewExtra" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 76}
@{"ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47}  @{"ViewPortExtra" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 86}  


@{b}#defines@{ub}

@{"BORDER_BLANKING" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 180}          @{"BORDER_NOTRANSPARENCY" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 181}    @{"BORDERSPRITES" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 184}
@{"CMAB_DUALPF_DISABLE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 206}      @{"CMAB_FULLPALETTE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 200}         @{"CMAB_NO_COLOR_LOAD" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 204}
@{"CMAB_NO_INTERMED_UPDATE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 202}  @{"CMAF_DUALPF_DISABLE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 207}      @{"CMAF_FULLPALETTE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 201}
@{"CMAF_NO_COLOR_LOAD" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 205}       @{"CMAF_NO_INTERMED_UPDATE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 203}  @{"CMF_BRDNTRAN" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 189}
@{"CMF_BRDRBLNK" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 188}             @{"CMF_BRDRSPRT" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 190}             @{"CMF_CMTRANS" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 186}
@{"CMF_CPTRANS" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 187}              @{"COLORMAP_TRANSPARENCY" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 178}    @{"COLORMAP_TYPE_V1_2" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 172}
@{"COLORMAP_TYPE_V1_4" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 173}       @{"COLORMAP_TYPE_V36" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 174}        @{"COLORMAP_TYPE_V39" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 175}
@{"COLORPLANE_TRANSPARENCY" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 179}  @{"DOUBLESCAN" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 124}               @{"DUALPF" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 129}
@{"ECS_SPECIFIC" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 13}             @{"EXTEND_VSTRUCT" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 113}           @{"EXTENDED_MODE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 131}
@{"EXTRA_HALFBRITE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 127}          @{"GENLOCK_AUDIO" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 128}            @{"GENLOCK_VIDEO" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 122}
@{"HAM" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 130}                      @{"HIRES" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 134}                    @{"LACE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 123}
@{"MCOP_NO_MEM" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 271}              @{"MCOP_NOP" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 274}                 @{"MCOP_OK" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 270}
@{"MVP_NO_DISPLAY" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 261}           @{"MVP_NO_DSPINS" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 258}            @{"MVP_NO_MEM" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 254}
@{"MVP_NO_VPE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 255}               @{"MVP_OFF_BOTTOM" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 264}           @{"MVP_OK" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 253}
@{"OBP_FailIfBad" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 246}            @{"OBP_Precision" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 245}            @{"PEN_EXCLUSIVE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 233}
@{"PEN_NO_SETCOLOR" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 234}          @{"PENB_EXCLUSIVE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 225}           @{"PENB_NO_SETCOLOR" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 226}
@{"PENF_EXCLUSIVE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 228}           @{"PENF_NO_SETCOLOR" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 229}         @{"PFBA" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 126}
@{"PRECISION_EXACT" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 238}          @{"PRECISION_GUI" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 241}            @{"PRECISION_ICON" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 240}
@{"PRECISION_IMAGE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 239}          @{"SPRITERESN_140NS" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 194}         @{"SPRITERESN_35NS" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 196}
@{"SPRITERESN_70NS" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 195}          @{"SPRITERESN_DEFAULT" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 197}       @{"SPRITERESN_ECS" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 192}
@{"SPRITES" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 133}                  @{"SUPERHIRES" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 125}               @{"USER_COPPER_CLIP" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 183}
@{"VIDEOCONTROL_BATCH" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 182}       @{"VP_HIDE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 132}                  @{"VPB_A2024" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 117}
@{"VPB_TENHZ" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 118}                @{"VPF_A2024" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 115}                @{"VPF_TENHZ" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 116}
@{"VPXB_FREE_ME" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 103}             @{"VPXB_LAST" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 105}                @{"VPXB_STRADDLES_256" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 107}
@{"VPXB_STRADDLES_512" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 109}       @{"VPXF_FREE_ME" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 104}             @{"VPXF_LAST" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 106}
@{"VPXF_STRADDLES_256" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 108}       @{"VPXF_STRADDLES_512" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 110}       

@ENDNODE
@NODE File "graphics/view.h"
#ifndef GRAPHICS_VIEW_H
#define GRAPHICS_VIEW_H
/*
**      $VER: view.h 39.34 (31.5.1993)
**      Includes Release 45.1
**
**      graphics view/viewport definintions
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#define ECS_SPECIFIC

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_SEMAPHORES_H
#include <@{"exec/semaphores.h" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File"}>
#endif

#ifndef GRAPHICS_GFX_H
#include <@{"graphics/gfx.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File"}>
#endif

#ifndef GRAPHICS_COPPER_H
#include <@{"graphics/copper.h" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File"}>
#endif

#ifndef GRAPHICS_GFXNODES_H
#include <@{"graphics/gfxnodes.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h/File"}>
#endif

#ifndef GRAPHICS_MONITOR_H
#include <@{"graphics/monitor.h" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File"}>
#endif

#ifndef GRAPHICS_DISPLAYINFO_H
#include <@{"graphics/displayinfo.h" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File"}>
#endif

#ifndef HARDWARE_CUSTOM_H
#include <@{"hardware/custom.h" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File"}>
#endif

struct ViewPort
{
        struct  ViewPort *Next;
        @{"struct  ColorMap" LINK File 143} *ColorMap;     /* table of colors for this viewport */
                                        /* if this is nil, @{"MakeVPort" LINK "gg:doc/NDK/Guide/graphics/MakeVPort"} assumes default values */
        @{"struct  CopList" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 62}  *DspIns;       /* used by @{"MakeVPort()" LINK "gg:doc/NDK/Guide/graphics/MakeVPort"} */
        @{"struct  CopList" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 62}  *SprIns;       /* used by sprite stuff */
        @{"struct  CopList" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 62}  *ClrIns;       /* used by sprite stuff */
        @{"struct  UCopList" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 89} *UCopIns;      /* User copper list */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    DWidth,DHeight;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    DxOffset,DyOffset;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Modes;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   SpritePriorities;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ExtendedModes;
        @{"struct  RasInfo" LINK File 136} *RasInfo;
};

struct View
{
        @{"struct  ViewPort" LINK File 47} *ViewPort;
        @{"struct  cprlist" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 55} *LOFCprList;   /* used for interlaced and noninterlaced */
        @{"struct  cprlist" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 55} *SHFCprList;   /* only used during interlace */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    DyOffset,DxOffset;   /* for complete View positioning */
                                   /* offsets are +- adjustments to standard #s */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Modes;             /* such as @{"INTERLACE" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 22}, @{"GENLOC" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 139} */
};

/* these structures are obtained via @{"GfxNew" LINK "gg:doc/NDK/Guide/graphics/GfxNew"} */
/* and disposed by @{"GfxFree" LINK "gg:doc/NDK/Guide/graphics/GfxFree"} */
struct ViewExtra
{
        @{"struct ExtendedNode" LINK "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h/File" 17} n;
        @{"struct View" LINK File 64} *View;              /* backwards link */
        @{"struct MonitorSpec" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 25} *Monitor;    /* monitors for this view */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} TopLine;
};

/* this structure is obtained via @{"GfxNew" LINK "gg:doc/NDK/Guide/graphics/GfxNew"} */
/* and disposed by @{"GfxFree" LINK "gg:doc/NDK/Guide/graphics/GfxFree"} */
struct ViewPortExtra
{
        @{"struct ExtendedNode" LINK "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h/File" 17} n;
        @{"struct ViewPort" LINK File 47} *ViewPort;      /* backwards link */
        @{"struct Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27} DisplayClip;   /* @{"MakeVPort" LINK "gg:doc/NDK/Guide/graphics/MakeVPort"} display clipping information */
        /* These are added for V39 */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}   VecTable;                /* Private */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}   DriverData[2];
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  Flags;
        @{"Point" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 39}  Origin[2];               /* First visible point relative to the DClip.
                                         * One for each possible playfield.
                                         */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cop1ptr;                  /* private */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cop2ptr;                  /* private */
};

/* All these VPXF_ flags are private */
#define VPXB_FREE_ME            0
#define VPXF_FREE_ME            (1 << @{"VPXB_FREE_ME" LINK File 103})
#define VPXB_LAST               1
#define VPXF_LAST               (1 << @{"VPXB_LAST" LINK File 105})
#define VPXB_STRADDLES_256      4
#define VPXF_STRADDLES_256      (1 << @{"VPXB_STRADDLES_256" LINK File 107})
#define VPXB_STRADDLES_512      5
#define VPXF_STRADDLES_512      (1 << @{"VPXB_STRADDLES_512" LINK File 109})


#define EXTEND_VSTRUCT  0x1000  /* unused bit in Modes field of View */

#define VPF_A2024             0x40      /* VP?_ fields internal only */
#define VPF_TENHZ             0x20
#define VPB_A2024             6
#define VPB_TENHZ             4

/* defines used for Modes in IVPargs */

#define GENLOCK_VIDEO   0x0002
#define LACE            0x0004
#define DOUBLESCAN      0x0008
#define SUPERHIRES      0x0020
#define PFBA            0x0040
#define EXTRA_HALFBRITE 0x0080
#define GENLOCK_AUDIO   0x0100
#define DUALPF          0x0400
#define HAM             0x0800
#define EXTENDED_MODE   0x1000
#define VP_HIDE 0x2000
#define SPRITES 0x4000
#define HIRES           0x8000

  /* used by callers to and InitDspC() */struct RasInfo
{
   struct   RasInfo *Next;          /* used for dualpf */
   @{"struct   BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *BitMap;
   @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    RxOffset,RyOffset;      /* scroll offsets in this BitMap */
};

struct ColorMap
{
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   Flags;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   Type;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Count;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    ColorTable;
        @{"struct  ViewPortExtra" LINK File 86} *cm_vpe;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    LowColorBits;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   TransparencyPlane;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   SpriteResolution;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   SpriteResDefault;       /* what resolution you get when you have set @{"SPRITERESN_DEFAULT" LINK File 197} */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   AuxFlags;
        @{"struct  ViewPort" LINK File 47} *cm_vp;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    NormalDisplayInfo;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    CoerceDisplayInfo;
        @{"struct  TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *cm_batch_items;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   VPModeID;
        @{"struct  PaletteExtra" LINK File 210} *PalExtra;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   SpriteBase_Even;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   SpriteBase_Odd;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Bp_0_base;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Bp_1_base;

};

/* if Type == 0 then ColorMap is V1.2/V1.3 compatible */
/* if Type != 0 then ColorMap is V38       compatible */
/* the system will never create other than V39 type colormaps when running V39 */

#define COLORMAP_TYPE_V1_2      0x00
#define COLORMAP_TYPE_V1_4      0x01
#define COLORMAP_TYPE_V36 @{"COLORMAP_TYPE_V1_4" LINK File 173}    /* use this definition */
#define COLORMAP_TYPE_V39       0x02

/* Flags variable */
#define COLORMAP_TRANSPARENCY   0x01
#define COLORPLANE_TRANSPARENCY 0x02
#define BORDER_BLANKING         0x04
#define BORDER_NOTRANSPARENCY   0x08
#define VIDEOCONTROL_BATCH      0x10
#define USER_COPPER_CLIP        0x20
#define BORDERSPRITES   0x40

#define CMF_CMTRANS     0
#define CMF_CPTRANS     1
#define CMF_BRDRBLNK    2
#define CMF_BRDNTRAN    3
#define CMF_BRDRSPRT    6

#define SPRITERESN_ECS          0
/* ^140ns, except in 35ns viewport, where it is 70ns. */
#define SPRITERESN_140NS        1
#define SPRITERESN_70NS         2
#define SPRITERESN_35NS         3
#define SPRITERESN_DEFAULT      -1

/* AuxFlags : */
#define CMAB_FULLPALETTE 0
#define CMAF_FULLPALETTE (1<<@{"CMAB_FULLPALETTE" LINK File 200})
#define CMAB_NO_INTERMED_UPDATE 1
#define CMAF_NO_INTERMED_UPDATE (1<<@{"CMAB_NO_INTERMED_UPDATE" LINK File 202})
#define CMAB_NO_COLOR_LOAD 2
#define CMAF_NO_COLOR_LOAD (1 << @{"CMAB_NO_COLOR_LOAD" LINK File 204})
#define CMAB_DUALPF_DISABLE 3
#define CMAF_DUALPF_DISABLE (1 << @{"CMAB_DUALPF_DISABLE" LINK File 206})


                             /* structure may be extended so watch out! */struct PaletteExtra
{
        @{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} pe_Semaphore;            /* shared semaphore for arbitration     */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   pe_FirstFree;                           /* *private*                            */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   pe_NFree;                               /* number of free colors                */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   pe_FirstShared;                         /* *private*                            */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   pe_NShared;                             /* *private*                            */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *pe_RefCnt;                             /* *private*                            */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *pe_AllocList;                          /* *private*                            */
        @{"struct ViewPort" LINK File 47} *pe_ViewPort;                   /* back pointer to viewport             */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   pe_SharableColors;                      /* the number of sharable colors.       */
};

/* flags values for @{"ObtainPen" LINK "gg:doc/NDK/Guide/graphics/ObtainPen"} */

#define PENB_EXCLUSIVE 0
#define PENB_NO_SETCOLOR 1

#define PENF_EXCLUSIVE (1l<<@{"PENB_EXCLUSIVE" LINK File 225})
#define PENF_NO_SETCOLOR (1l<<@{"PENB_NO_SETCOLOR" LINK File 226})

/* obsolete names for PENF_xxx flags: */

#define PEN_EXCLUSIVE @{"PENF_EXCLUSIVE" LINK File 228}
#define PEN_NO_SETCOLOR @{"PENF_NO_SETCOLOR" LINK File 229}

/* precision values for @{"ObtainBestPen" LINK "gg:doc/NDK/Guide/graphics/ObtainBestPenA"} : */

#define PRECISION_EXACT -1
#define PRECISION_IMAGE 0
#define PRECISION_ICON  16
#define PRECISION_GUI   32


/* tags for @{"ObtainBestPen" LINK "gg:doc/NDK/Guide/graphics/ObtainBestPenA"}: */
#define OBP_Precision 0x84000000
#define OBP_FailIfBad 0x84000001

/* From V39, @{"MakeVPort()" LINK "gg:doc/NDK/Guide/graphics/MakeVPort"} will return an error if there is not enough memory,
 * or the requested mode cannot be opened with the requested depth with the
 * given bitmap (for higher bandwidth alignments).
 */

#define MVP_OK          0       /* you want to see this one */
#define MVP_NO_MEM      1       /* insufficient memory for intermediate workspace */
#define MVP_NO_VPE      2       /* ViewPort does not have a ViewPortExtra, and
                                 * insufficient memory to allocate a temporary one.
                                 */
#define MVP_NO_DSPINS   3       /* insufficient memory for intermidiate copper
                                 * instructions.
                                 */
#define MVP_NO_DISPLAY  4       /* BitMap data is misaligned for this viewport's
                                 * mode and depth - see @{"AllocBitMap()" LINK "gg:doc/NDK/Guide/graphics/AllocBitMap"}.
                                 */
#define MVP_OFF_BOTTOM  5       /* PRIVATE - you will never see this. */

/* From V39, @{"MrgCop()" LINK "gg:doc/NDK/Guide/graphics/MrgCop"} will return an error if there is not enough memory,
 * or for some reason @{"MrgCop()" LINK "gg:doc/NDK/Guide/graphics/MrgCop"} did not need to make any copper lists.
 */

#define MCOP_OK         0       /* you want to see this one */
#define MCOP_NO_MEM     1       /* insufficient memory to allocate the system
                                 * copper lists.
                                 */
#define MCOP_NOP        2       /* @{"MrgCop()" LINK "gg:doc/NDK/Guide/graphics/MrgCop"} did not merge any copper lists
                                 * (eg, no ViewPorts in the list, or all marked as
                                 * hidden).
                                 */

struct DBufInfo {
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    dbi_Link1;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dbi_Count1;
        @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} dbi_SafeMessage;         /* replied to when safe to write to old bitmap */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dbi_UserData1;                     /* first user data */

        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    dbi_Link2;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dbi_Count2;
        @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} dbi_DispMessage; /* replied to when new bitmap has been displayed at least
                                                        once */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    dbi_UserData2;                  /* second user data */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dbi_MatchLong;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    dbi_CopPtr1;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    dbi_CopPtr2;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    dbi_CopPtr3;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   dbi_BeamPos1;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   dbi_BeamPos2;
};

#endif  /* GRAPHICS_VIEW_H */
@ENDNODE
