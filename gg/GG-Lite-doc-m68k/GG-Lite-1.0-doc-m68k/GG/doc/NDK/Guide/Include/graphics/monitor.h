@DATABASE "gg:doc/NDK/Guide/Include/graphics/monitor.h"
@MASTER   "gg:os-include/graphics/monitor.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:04
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/monitor.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/monitor.h" LINK File}


@{b}Structures@{ub}

@{"AnalogSignalInterval" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 152}  @{"MonitorSpec" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 25}  @{"SpecialMonitor" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 158}


@{b}#defines@{ub}

@{"BROADCAST_BEAMCON" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 148}      @{"BROADCAST_HBSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 143}      @{"BROADCAST_HBSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 140}
@{"BROADCAST_HSSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 142}       @{"BROADCAST_HSSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 141}      @{"BROADCAST_VBSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 147}
@{"BROADCAST_VBSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 144}       @{"BROADCAST_VSSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 146}      @{"BROADCAST_VSSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 145}
@{"DEFAULT_MONITOR_NAME" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 78}   @{"FROM_MONITOR" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 56}          @{"MIN_NTSC_ROW" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 93}
@{"MIN_PAL_ROW" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 94}            @{"MIN_VGA70_ROW" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 127}         @{"MIN_VGA_ROW" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 109}
@{"MSB_DOUBLE_SPRITES" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 64}     @{"MSB_REQUEST_A2024" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 63}     @{"MSB_REQUEST_NTSC" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 60}
@{"MSB_REQUEST_PAL" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 61}        @{"MSB_REQUEST_SPECIAL" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 62}   @{"MSF_DOUBLE_SPRITES" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 69}
@{"MSF_REQUEST_A2024" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 68}      @{"MSF_REQUEST_NTSC" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 65}      @{"MSF_REQUEST_PAL" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 66}
@{"MSF_REQUEST_SPECIAL" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 67}    @{"NTSC_MONITOR_NAME" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 79}     @{"PAL_MONITOR_NAME" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 80}
@{"RATIO_FIXEDPART" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 149}        @{"RATIO_UNITY" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 150}           @{"REQUEST_A2024" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 76}
@{"REQUEST_NTSC" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 73}           @{"REQUEST_PAL" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 74}           @{"REQUEST_SPECIAL" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 75}
@{"SPECIAL_BEAMCON" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 91}        @{"STANDARD_COLORCLOCKS" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 85}  @{"STANDARD_DENISE_MAX" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 86}
@{"STANDARD_DENISE_MIN" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 87}    @{"STANDARD_HBSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 100}       @{"STANDARD_HBSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 97}
@{"STANDARD_HSSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 99}        @{"STANDARD_HSSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 98}       @{"STANDARD_MONITOR_MASK" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 81}
@{"STANDARD_NTSC_BEAMCON" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 88}  @{"STANDARD_NTSC_ROWS" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 83}    @{"STANDARD_PAL_BEAMCON" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 89}
@{"STANDARD_PAL_ROWS" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 84}      @{"STANDARD_VBSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 104}       @{"STANDARD_VBSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 101}
@{"STANDARD_VIEW_X" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 95}        @{"STANDARD_VIEW_Y" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 96}       @{"STANDARD_VSSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 103}
@{"STANDARD_VSSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 102}        @{"STANDARD_XOFFSET" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 57}      @{"STANDARD_YOFFSET" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 58}
@{"TO_MONITOR" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 55}             @{"VGA70_BEAMCON" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 137}         @{"VGA70_COLORCLOCKS" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 124}
@{"VGA70_DENISE_MIN" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 126}       @{"VGA70_HBSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 131}          @{"VGA70_HBSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 128}
@{"VGA70_HSSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 130}           @{"VGA70_HSSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 129}          @{"VGA70_MONITOR_NAME" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 138}
@{"VGA70_TOTAL_ROWS" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 125}       @{"VGA70_VBSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 135}          @{"VGA70_VBSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 132}
@{"VGA70_VSSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 134}           @{"VGA70_VSSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 133}          @{"VGA_COLORCLOCKS" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 106}
@{"VGA_DENISE_MIN" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 108}         @{"VGA_HBSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 113}            @{"VGA_HBSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 110}
@{"VGA_HSSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 112}             @{"VGA_HSSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 111}            @{"VGA_MONITOR_NAME" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 119}
@{"VGA_TOTAL_ROWS" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 107}         @{"VGA_VBSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 117}            @{"VGA_VBSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 114}
@{"VGA_VSSTOP" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 116}             @{"VGA_VSSTRT" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 115}            

@ENDNODE
@NODE File "graphics/monitor.h"
#ifndef GRAPHICS_MONITOR_H
#define GRAPHICS_MONITOR_H
/*
**      $VER: monitor.h 39.7 (9.6.1992)
**      Includes Release 45.1
**
**      graphics monitorspec definintions
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_SEMAPHORES_H
#include        <@{"exec/semaphores.h" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File"}>
#endif

#ifndef GRAPHICS_GFXNODES_H
#include        <@{"graphics/gfxnodes.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h/File"}>
#endif

#ifndef GRAPHICS_GFX_H
#include        <@{"graphics/gfx.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File"}>
#endif

struct  MonitorSpec
{
    @{"struct      ExtendedNode" LINK "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h/File" 17}    ms_Node;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       ms_Flags;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        ratioh;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        ratiov;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       total_rows;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       total_colorclocks;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       DeniseMaxDisplayColumn;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       BeamCon0;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       min_row;
    @{"struct      SpecialMonitor" LINK File 158}  *ms_Special;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       ms_OpenCount;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        (*ms_transform)();
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        (*ms_translate)();
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        (*ms_scale)();
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       ms_xoffset;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       ms_yoffset;
    @{"struct      Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27}       ms_LegalView;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        (*ms_maxoscan)();       /* maximum legal overscan */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        (*ms_videoscan)();      /* video display overscan */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       DeniseMinDisplayColumn;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}       DisplayCompatible;
    @{"struct      List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} DisplayInfoDataBase;
    @{"struct      SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} DisplayInfoDataBaseSemaphore;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        (*ms_MrgCop)();
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        (*ms_LoadView)();
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        (*ms_KillView)();
};

#define TO_MONITOR              0
#define FROM_MONITOR            1
#define STANDARD_XOFFSET        9
#define STANDARD_YOFFSET        0

#define MSB_REQUEST_NTSC        0
#define MSB_REQUEST_PAL         1
#define MSB_REQUEST_SPECIAL     2
#define MSB_REQUEST_A2024       3
#define MSB_DOUBLE_SPRITES      4
#define MSF_REQUEST_NTSC        (1 << @{"MSB_REQUEST_NTSC" LINK File 60})
#define MSF_REQUEST_PAL         (1 << @{"MSB_REQUEST_PAL" LINK File 61})
#define MSF_REQUEST_SPECIAL             (1 << @{"MSB_REQUEST_SPECIAL" LINK File 62})
#define MSF_REQUEST_A2024               (1 << @{"MSB_REQUEST_A2024" LINK File 63})
#define MSF_DOUBLE_SPRITES              (1 << @{"MSB_DOUBLE_SPRITES" LINK File 64})


/* obsolete, v37 compatible definitions follow */
#define REQUEST_NTSC            (1 << @{"MSB_REQUEST_NTSC" LINK File 60})
#define REQUEST_PAL             (1 << @{"MSB_REQUEST_PAL" LINK File 61})
#define REQUEST_SPECIAL         (1 << @{"MSB_REQUEST_SPECIAL" LINK File 62})
#define REQUEST_A2024           (1 << @{"MSB_REQUEST_A2024" LINK File 63})

#define DEFAULT_MONITOR_NAME    "default.monitor"
#define NTSC_MONITOR_NAME       "ntsc.monitor"
#define PAL_MONITOR_NAME        "pal.monitor"
#define STANDARD_MONITOR_MASK   ( @{"REQUEST_NTSC" LINK File 73} | @{"REQUEST_PAL" LINK File 74} )

#define STANDARD_NTSC_ROWS      262
#define STANDARD_PAL_ROWS       312
#define STANDARD_COLORCLOCKS    226
#define STANDARD_DENISE_MAX     455
#define STANDARD_DENISE_MIN     93
#define STANDARD_NTSC_BEAMCON   ( 0x0000 )
#define STANDARD_PAL_BEAMCON    ( @{"DISPLAYPAL" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 154} )

#define SPECIAL_BEAMCON ( @{"VARVBLANK" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 147} | @{"LOLDIS" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 148} | @{"VARVSYNC" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 150} | @{"VARHSYNC" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 151} | @{"VARBEAM" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 152} | @{"CSBLANK" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 156} | @{"VSYNCTRUE" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 158})

#define MIN_NTSC_ROW    21
#define MIN_PAL_ROW     29
#define STANDARD_VIEW_X 0x81
#define STANDARD_VIEW_Y 0x2C
#define STANDARD_HBSTRT 0x06
#define STANDARD_HSSTRT 0x0B
#define STANDARD_HSSTOP 0x1C
#define STANDARD_HBSTOP 0x2C
#define STANDARD_VBSTRT 0x0122
#define STANDARD_VSSTRT 0x02A6
#define STANDARD_VSSTOP 0x03AA
#define STANDARD_VBSTOP 0x1066

#define VGA_COLORCLOCKS (@{"STANDARD_COLORCLOCKS" LINK File 85}/2)
#define VGA_TOTAL_ROWS  (@{"STANDARD_NTSC_ROWS" LINK File 83}*2)
#define VGA_DENISE_MIN  59
#define MIN_VGA_ROW     29
#define VGA_HBSTRT      0x08
#define VGA_HSSTRT      0x0E
#define VGA_HSSTOP      0x1C
#define VGA_HBSTOP      0x1E
#define VGA_VBSTRT      0x0000
#define VGA_VSSTRT      0x0153
#define VGA_VSSTOP      0x0235
#define VGA_VBSTOP      0x0CCD

#define VGA_MONITOR_NAME        "vga.monitor"

/* NOTE: VGA70 definitions are obsolete - a VGA70 monitor has never been
 * implemented.
 */
#define VGA70_COLORCLOCKS (@{"STANDARD_COLORCLOCKS" LINK File 85}/2)
#define VGA70_TOTAL_ROWS 449
#define VGA70_DENISE_MIN 59
#define MIN_VGA70_ROW   35
#define VGA70_HBSTRT    0x08
#define VGA70_HSSTRT    0x0E
#define VGA70_HSSTOP    0x1C
#define VGA70_HBSTOP    0x1E
#define VGA70_VBSTRT    0x0000
#define VGA70_VSSTRT    0x02A6
#define VGA70_VSSTOP    0x0388
#define VGA70_VBSTOP    0x0F73

#define VGA70_BEAMCON   (@{"SPECIAL_BEAMCON" LINK File 91} ^ @{"VSYNCTRUE" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 158})
#define VGA70_MONITOR_NAME      "vga70.monitor"

#define BROADCAST_HBSTRT        0x01
#define BROADCAST_HSSTRT        0x06
#define BROADCAST_HSSTOP        0x17
#define BROADCAST_HBSTOP        0x27
#define BROADCAST_VBSTRT        0x0000
#define BROADCAST_VSSTRT        0x02A6
#define BROADCAST_VSSTOP        0x054C
#define BROADCAST_VBSTOP        0x1C40
#define BROADCAST_BEAMCON       ( @{"LOLDIS" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 148} | @{"CSBLANK" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 156} )
#define RATIO_FIXEDPART 4
#define RATIO_UNITY     (1 << @{"RATIO_FIXEDPART" LINK File 149})

struct  AnalogSignalInterval
{
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       asi_Start;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       asi_Stop;
};

struct  SpecialMonitor
{
    @{"struct      ExtendedNode" LINK "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h/File" 17}    spm_Node;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       spm_Flags;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        (*do_monitor)();
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        (*reserved1)();
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        (*reserved2)();
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        (*reserved3)();
    @{"struct      AnalogSignalInterval" LINK File 152}    hblank;
    @{"struct      AnalogSignalInterval" LINK File 152}    vblank;
    @{"struct      AnalogSignalInterval" LINK File 152}    hsync;
    @{"struct      AnalogSignalInterval" LINK File 152}    vsync;
};

#endif  /* GRAPHICS_MONITOR_H */
@ENDNODE
