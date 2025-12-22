{ Monitor.i }

{$I   "Include:Exec/Semaphores.i"}
{$I   "Include:Graphics/GFX.i"}
{$I   "Include:Hardware/Custom.i"}
{$I   "Include:Graphics/GFXNodes.i"}

Type
 AnalogSignalInterval = Record
  asi_Start,
  asi_Stop  : Short;
 END;
 AnalogSignalIntervalPtr = ^AnalogSignalInterval;

 SpecialMonitor = Record
  spm_Node      : ExtendedNodePtr;
  spm_Flags     : Short;
  do_monitor,
  reserved1,
  reserved2,
  reserved3     : Address;
  hblank,
  vblank,
  hsync,
  vsync : AnalogSignalInterval;
 END;
 SpecialMonitorPtr = ^SpecialMonitor;


 MonitorSpec = Record
    ms_Node     : ExtendedNodePtr;
    ms_Flags    : Short;
    ratioh,
    ratiov      : Integer;
    total_rows,
    total_colorclocks,
    DeniseMaxDisplayColumn,
    BeamCon0,
    min_row     : Short;
    ms_Special  : SpecialMonitorPtr;
    ms_OpenCount : Short;
    ms_transform,
    ms_translate,
    ms_scale    : Address;
    ms_xoffset,
    ms_yoffset  : Short;
    ms_LegalView : Rectangle;
    ms_maxoscan,       { maximum legal overscan }
    ms_videoscan  : Address;      { video display overscan }
    DeniseMinDisplayColumn : Short;
    DisplayCompatible      : Integer;
    DisplayInfoDataBase    : List;
    DisplayInfoDataBaseSemaphore : SignalSemaphorePtr;
    ms_reserved00,
    ms_reserved01 : Integer;
 END;
 MonitorSpecPtr = ^MonitorSpec;

const
  TO_MONITOR            =  0;
  FROM_MONITOR          =  1;
  STANDARD_XOFFSET      =  9;
  STANDARD_YOFFSET      =  0;

  MSB_REQUEST_NTSC      =  0;
  MSB_REQUEST_PAL       =  1;
  MSB_REQUEST_SPECIAL   =  2;
  MSB_REQUEST_A2024     =  3;
  MSB_DOUBLE_SPRITES    =  4;
  MSF_REQUEST_NTSC      =  1;
  MSF_REQUEST_PAL       =  2;
  MSF_REQUEST_SPECIAL   =  4;
  MSF_REQUEST_A2024     =  8;
  MSF_DOUBLE_SPRITES    =  16;


{ obsolete, v37 compatible definitions follow }
  REQUEST_NTSC          =  1;
  REQUEST_PAL           =  2;
  REQUEST_SPECIAL       =  4;
  REQUEST_A2024         =  8;

  DEFAULT_MONITOR_NAME  =  "default.monitor";
  NTSC_MONITOR_NAME     =  "ntsc.monitor";
  PAL_MONITOR_NAME      =  "pal.monitor";
  STANDARD_MONITOR_MASK =  ( REQUEST_NTSC OR REQUEST_PAL ) ;

  STANDARD_NTSC_ROWS    =  262;
  STANDARD_PAL_ROWS     =  312;
  STANDARD_COLORCLOCKS  =  226;
  STANDARD_DENISE_MAX   =  455;
  STANDARD_DENISE_MIN   =  93 ;
  STANDARD_NTSC_BEAMCON =  $0000;
  STANDARD_PAL_BEAMCON  =  DISPLAYPAL ;

  SPECIAL_BEAMCON       = ( VARVBLANK OR LOLDIS OR VARVSYNC OR VARHSYNC OR VARBEAM OR CSBLANK OR VSYNCTRUE);

  MIN_NTSC_ROW    = 21   ;
  MIN_PAL_ROW     = 29   ;
  STANDARD_VIEW_X = $81  ;
  STANDARD_VIEW_Y = $2C  ;
  STANDARD_HBSTRT = $06  ;
  STANDARD_HSSTRT = $0B  ;
  STANDARD_HSSTOP = $1C  ;
  STANDARD_HBSTOP = $2C  ;
  STANDARD_VBSTRT = $0122;
  STANDARD_VSSTRT = $02A6;
  STANDARD_VSSTOP = $03AA;
  STANDARD_VBSTOP = $1066;

  VGA_COLORCLOCKS = (STANDARD_COLORCLOCKS/2);
  VGA_TOTAL_ROWS  = (STANDARD_NTSC_ROWS*2);
  VGA_DENISE_MIN  = 59   ;
  MIN_VGA_ROW     = 29   ;
  VGA_HBSTRT      = $08  ;
  VGA_HSSTRT      = $0E  ;
  VGA_HSSTOP      = $1C  ;
  VGA_HBSTOP      = $1E  ;
  VGA_VBSTRT      = $0000;
  VGA_VSSTRT      = $0153;
  VGA_VSSTOP      = $0235;
  VGA_VBSTOP      = $0CCD;

  VGA_MONITOR_NAME      =  "vga.monitor";

{ NOTE: VGA70 definitions are obsolete - a VGA70 monitor has never been
 * implemented.
 }
  VGA70_COLORCLOCKS = (STANDARD_COLORCLOCKS/2) ;
  VGA70_TOTAL_ROWS  = 449;
  VGA70_DENISE_MIN  = 59;
  MIN_VGA70_ROW     = 35   ;
  VGA70_HBSTRT      = $08  ;
  VGA70_HSSTRT      = $0E  ;
  VGA70_HSSTOP      = $1C  ;
  VGA70_HBSTOP      = $1E  ;
  VGA70_VBSTRT      = $0000;
  VGA70_VSSTRT      = $02A6;
  VGA70_VSSTOP      = $0388;
  VGA70_VBSTOP      = $0F73;

  VGA70_BEAMCON     = (SPECIAL_BEAMCON XOR VSYNCTRUE);
  VGA70_MONITOR_NAME=      "vga70.monitor";

  BROADCAST_HBSTRT  =      $01  ;
  BROADCAST_HSSTRT  =      $06  ;
  BROADCAST_HSSTOP  =      $17  ;
  BROADCAST_HBSTOP  =      $27  ;
  BROADCAST_VBSTRT  =      $0000;
  BROADCAST_VSSTRT  =      $02A6;
  BROADCAST_VSSTOP  =      $054C;
  BROADCAST_VBSTOP  =      $1C40;
  BROADCAST_BEAMCON =      ( LOLDIS OR CSBLANK );
  RATIO_FIXEDPART   =      4;
  RATIO_UNITY       =      16;

FUNCTION CloseMonitor(m : MonitorSpecPtr) : Integer;
    External;

FUNCTION OpenMonitor(name : String; ModeID : Integer) : MonitorSpecPtr;
    External;


