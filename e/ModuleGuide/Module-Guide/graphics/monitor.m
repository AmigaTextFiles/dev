@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/monitor.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT monitorspec
@{fg shine}(   0)@{fg text}   xln:xln @{fg shine}(or ARRAY OF xln)@{fg text}
@{fg shine}(  24)@{fg text}   flags:INT
@{fg shine}(  26)@{fg text}   ratioh:LONG
@{fg shine}(  30)@{fg text}   ratiov:LONG
@{fg shine}(  34)@{fg text}   total_rows:INT
@{fg shine}(  36)@{fg text}   total_colorclocks:INT
@{fg shine}(  38)@{fg text}   denisemaxdisplaycolumn:INT
@{fg shine}(  40)@{fg text}   beamcon0:INT
@{fg shine}(  42)@{fg text}   min_row:INT
@{fg shine}(  44)@{fg text}   special:PTR TO specialmonitor
@{fg shine}(  48)@{fg text}   opencount:INT
@{fg shine}(  50)@{fg text}   transform:LONG
@{fg shine}(  54)@{fg text}   translate:LONG
@{fg shine}(  58)@{fg text}   scale:LONG
@{fg shine}(  62)@{fg text}   xoffset:INT
@{fg shine}(  64)@{fg text}   yoffset:INT
@{fg shine}(  66)@{fg text}   legalview:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(  74)@{fg text}   maxoscan:LONG
@{fg shine}(  78)@{fg text}   videoscan:LONG
@{fg shine}(  82)@{fg text}   denisemindisplaycolumn:INT
@{fg shine}(  84)@{fg text}   displaycompatible:LONG
@{fg shine}(  88)@{fg text}   displayinfodatabase:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 102)@{fg text}   didbsemaphore:ss @{fg shine}(or ARRAY OF ss)@{fg text}
@{fg shine}( 148)@{fg text}   mrgcop:LONG
@{fg shine}( 152)@{fg text}   loadview:LONG
@{fg shine}( 156)@{fg text}   killview:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=160 */

@{fg shine}(----)@{fg text} OBJECT specialmonitor
@{fg shine}(   0)@{fg text}   xln:xln @{fg shine}(or ARRAY OF xln)@{fg text}
@{fg shine}(  24)@{fg text}   flags:INT
@{fg shine}(  26)@{fg text}   do_monitor:LONG
@{fg shine}(  30)@{fg text}   reserved1:LONG
@{fg shine}(  34)@{fg text}   reserved2:LONG
@{fg shine}(  38)@{fg text}   reserved3:LONG
@{fg shine}(  42)@{fg text}   hblank:analogsignalinterval @{fg shine}(or ARRAY OF analogsignalinterval)@{fg text}
@{fg shine}(  46)@{fg text}   vblank:analogsignalinterval @{fg shine}(or ARRAY OF analogsignalinterval)@{fg text}
@{fg shine}(  50)@{fg text}   hsync:analogsignalinterval @{fg shine}(or ARRAY OF analogsignalinterval)@{fg text}
@{fg shine}(  54)@{fg text}   vsync:analogsignalinterval @{fg shine}(or ARRAY OF analogsignalinterval)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=58 */

@{fg shine}(----)@{fg text} OBJECT analogsignalinterval
@{fg shine}(   0)@{fg text}   start:INT
@{fg shine}(   2)@{fg text}   stop:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

CONST STANDARD_VIEW_X=$81,
      STANDARD_VIEW_X=$81,
      STANDARD_VIEW_Y=$2C,
      STANDARD_VIEW_Y=$2C,
      REQUEST_SPECIAL=4,
      MSF_REQUEST_SPECIAL=4,
      MSB_REQUEST_SPECIAL=2,
      REQUEST_A2024=8,
      MSF_REQUEST_A2024=8,
      MSB_REQUEST_A2024=3,
      BROADCAST_BEAMCON=$808,
      SPECIAL_BEAMCON=$1B8A,
      STANDARD_PAL_BEAMCON=$20,
      STANDARD_NTSC_BEAMCON=0,
      VGA_TOTAL_ROWS=$83,
      STANDARD_PAL_ROWS=$138,
      STANDARD_NTSC_ROWS=$106,
      MSF_DOUBLE_SPRITES=16,
      MSB_DOUBLE_SPRITES=4,
      MIN_VGA_ROW=29,
      MIN_PAL_ROW=29,
      MIN_NTSC_ROW=21,
      STANDARD_MONITOR_MASK=3,
      BROADCAST_VBSTOP=$1C40,
      BROADCAST_VSSTOP=$54C,
      BROADCAST_HBSTOP=$27,
      BROADCAST_HSSTOP=23,
      VGA_VBSTOP=$CCD,
      VGA_VSSTOP=$235,
      VGA_HBSTOP=30,
      VGA_HSSTOP=28,
      STANDARD_VBSTOP=$1066,
      STANDARD_VSSTOP=$3AA,
      STANDARD_HBSTOP=$2C,
      STANDARD_HSSTOP=28,
      RATIO_FIXEDPART=4,
      VGA_DENISE_MIN=$3B,
      STANDARD_DENISE_MIN=$5D,
      RATIO_UNITY=16,
      REQUEST_NTSC=1,
      MSF_REQUEST_NTSC=1,
      MSB_REQUEST_NTSC=0,
      VGA_COLORCLOCKS=$71,
      STANDARD_COLORCLOCKS=$E2,
      BROADCAST_VSSTRT=$2A6,
      BROADCAST_VBSTRT=0,
      BROADCAST_HSSTRT=6,
      BROADCAST_HBSTRT=1,
      VGA_VSSTRT=$153,
      VGA_VBSTRT=0,
      VGA_HSSTRT=14,
      VGA_HBSTRT=8,
      STANDARD_VSSTRT=$2A6,
      STANDARD_VBSTRT=$122,
      STANDARD_HSSTRT=11,
      STANDARD_HBSTRT=6,
      FROM_MONITOR=1,
      TO_MONITOR=0,
      STANDARD_YOFFSET=0,
      STANDARD_XOFFSET=9,
      REQUEST_PAL=2,
      MSF_REQUEST_PAL=2,
      MSB_REQUEST_PAL=1,
      STANDARD_DENISE_MAX=$1C7

#define VGA_MONITOR_NAME/0
#define PAL_MONITOR_NAME/0
#define NTSC_MONITOR_NAME/0
#define DEFAULT_MONITOR_NAME/0
@endnode
