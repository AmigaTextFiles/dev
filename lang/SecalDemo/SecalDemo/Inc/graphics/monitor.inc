include "inc/exec/semaphores.inc";
include "inc/graphics/gfxnodes.inc";
include "inc/graphics/gfx.inc";

struct MonitorSpec is
  ms_Node:ExtendedNode;
  ms_Flags:uword;
  ratioh:long;
  ratiov:long;
  total_rows:uword;
  total_colorclocks:uword;
  DeniseMaxDisplayColumn:uword;
  BeamCon0:uword;
  min_row:uword;
  ms_Special:ulong;
  ms_OpenCount:uword;
  ms_transform:ulong;
  ms_translate:ulong;
  ms_scale:ulong;
  ms_xoffset:uword;
  ms_yoffset:uword;
  ms_LegalView:Rectangle;
  ms_maxoscan:ulong;
  ms_videoscan:ulong;
  DeniseMinDisplayColumn:uword;
  DisplayCompatible:ulong;
  DisplayInfoDataBase:List;
  DisplayInfoDataBaseSemaphore:SignalSemaphore;
  ms_MrgCop:ulong;
  ms_LoadView:ulong;
  ms_KillView:ulong;
;

def TO_MONITOR = 0;
def FROM_MONITOR = 1;
def STANDARD_XOFFSET = 9;
def STANDARD_YOFFSET = 0;

def MSB_REQUEST_NTSC = 0;
def MSB_REQUEST_PAL = 1;
def MSB_REQUEST_SPECIAL = 2;
def MSB_REQUEST_A2024 = 3;
def MSB_DOUBLE_SPRITES = 4;
def MSF_REQUEST_NTSC = (1<<MSB_REQUEST_NTSC);
def MSF_REQUEST_PAL = (1<<MSB_REQUEST_PAL);
def MSF_REQUEST_SPECIAL = (1<<MSB_REQUEST_SPECIAL);
def MSF_REQUEST_A2024 = (1<<MSB_REQUEST_A2024);
def MSF_DOUBLE_SPRITES = (1<<MSB_DOUBLE_SPRITES);

def REQUEST_NTSC = (1<<MSB_REQUEST_NTSC);
def REQUEST_PAL = (1<<MSB_REQUEST_PAL);
def REQUEST_SPECIAL = (1<<MSB_REQUEST_SPECIAL);
def REQUEST_A2024 = (1<<MSB_REQUEST_A2024);

def DEFAULT_MONITOR_NAME = "default.monitor";
def NTSC_MONITOR_NAME = "ntsc.monitor";
def PAL_MONITOR_NAME = "pal.monitor";
def STANDARD_MONITOR_MASK = (REQUEST_NTSC|REQUEST_PAL);

def STANDARD_NTSC_ROWS = 262;
def STANDARD_PAL_ROWS = 312;
def STANDARD_COLORCLOCKS = 226;
def STANDARD_DENISE_MAX = 455;
def STANDARD_DENISE_MIN = 93;
def STANDARD_NTSC_BEAMCON = ($0000);
def STANDARD_PAL_BEAMCON = (DISPLAYPAL);

def SPECIAL_BEAMCON = (VARVBLANK|LOLDIS|VARVSYNC|VARHSYNC|VARBEAM|CSBLANK|VSYNCTRUE);

def MIN_NTSC_ROW = 21;
def MIN_PAL_ROW = 29;
def STANDARD_VIEW_X = $81;
def STANDARD_VIEW_Y = $2c;
def STANDARD_HBSTRT = $06;
def STANDARD_HSSTRT = $0b;
def STANDARD_HSSTOP = $1c;
def STANDARD_HBSTOP = $2c;
def STANDARD_VBSTRT = $0122;
def STANDARD_VSSTRT = $02a6;
def STANDARD_VSSTOP = $03aa;
def STANDARD_VBSTOP = $1066;

def VGA_COLORCLOCKS = (STANDARD_COLORCLOCKS/2);
def VGA_TOTAL_ROWS = (STANDARD_NTSC_ROWS*2);
def VGA_DENISE_MIN = 59;
def MIN_VGA_ROW = 29;
def VGA_HBSTRT = $08;
def VGA_HSSTRT = $0e;
def VGA_HSSTOP = $1c;
def VGA_HBSTOP = $1e;
def VGA_VBSTRT = $0000;
def VGA_VSSTRT = $0153;
def VGA_VSSTOP = $0235;
def VGA_VBSTOP = $0ccd;

def VGA_MONITOR_NAME = "vga.monitor";

def VGA70_COLORCLOCKS = (STANDARD_COLORCLOCKS/2);
def VGA70_TOTAL_ROWS = 449;
def VGA70_DENISE_MIN = 59;
def MIN_VGA70_ROW = 35;
def VGA70_HBSTRT = $08;
def VGA70_HSSTRT = $0e;
def VGA70_HSSTOP = $1c;
def VGA70_HBSTOP = $1e;
def VGA70_VBSTRT = $0000;
def VGA70_VSSTRT = $02a6;
def VGA70_VSSTOP = $0388;
def VGA70_VBSTOP = $0f73;

def VGA70_BEAMCON = (SPECIAL_BEAMCON xor VSYNCTRUE);
def VGA70_MONITOR_NAME = "vga70.monitor";

def BROADCAST_HBSTRT = $01;
def BROADCAST_HSSTRT = $06;
def BROADCAST_HSSTOP = $17;
def BROADCAST_HBSTOP = $27;
def BROADCAST_VBSTRT = $0000;
def BROADCAST_VSSTRT = $02a6;
def BROADCAST_VSSTOP = $054c;
def BROADCAST_VBSTOP = $1c40;
def BROADCAST_BEAMCON = (LOLDIS|CSBLANK);
def RATIO_FIXEDPART = 4;
def RATIO_UNITY = (1<<RATIO_FIXEDPART);

struct AnalogSignalInterval is
  asi_Start:uword;
  asi_Stop:uword;
;

struct SpecialMonitor is
  spm_Node:ExtendedNode;
  spm_Flags:uword;
  do_monitor:ulong;
  reserved1:ulong;
  reserved2:ulong;
  reserved3:ulong;
  hblank:AnalogSignalInterval;
  vblank:AnalogSignalInterval;
  hsync:AnalogSignalInterval;
  vsync:AnalogSignalInterval;
;

