include "inc/exec/types.inc";
include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";
include "inc/exec/ports.inc";
include "inc/exec/libraries.inc";
include "inc/exec/tasks.inc";
include "inc/devices/parallel.inc";
include "inc/devices/serial.inc";
include "inc/devices/timer.inc";
include "inc/dos/dosextens.inc";
include "inc/intuition/intuition.inc";

struct DeviceData is
  dd_Device:Library;
  dd_Segment:ulong;
  dd_ExecBase:ulong;
  dd_CmdVectors:ulong;
  dd_CmdBytes:ulong;
  dd_NumCommands:uword;
;

def P_OLDSTKSIZE = $0800;
def P_STKSIZE = $1000;
def P_BUFSIZE = 256;
def P_SAFESIZE = 128;

struct PrinterData is
  pd_Device:DeviceData;
  pd_Unit:MsgPort;
  pd_PrinterSegment:long;
  pd_PrinterType:uword;
  pd_SegmentData:ulong;
  pd_PrintBuf:ulong;
  pd_PWrite:ulong;
  pd_PBothReady:ulong;
  pd_ior0:union is
    pd_p0:IOExtPar;
    pd_s0:IOExtSer;
  ;
  pd_ior1:union is
    pd_p1:IOExtPar;
    pd_s1:IOExtSer;
  ;
  pd_TIOR:timerequest;
  pd_IORPort:MsgPort;
  pd_TC:Task;
  pd_OldStk[$0800]:ubyte;
  pd_Flags:ubyte;
  pd_pad:ubyte;
  pd_Preferences:Preferences;
  pd_PWaitEnabled:ubyte;
  pd_Flags1:ubyte;
  pd_Stk[$1000]:ubyte;
;

def pd_PIOR0 = pd_ior0.pd_p0;
def pd_SIOR0 = pd_ior0.pd_s0;
def pd_PIOR1 = pd_ior1.pd_p1;
def pd_SIOR1 = pd_ior1.pd_s1;

def PPCB_GFX = 0;
def PPCF_GFX = $1;
def PPCB_COLOR = 1;
def PPCF_COLOR = $2;

def PPC_BWALPHA = $00;
def PPC_BWGFX = $01;
def PPC_COLORALPHA = $02;
def PPC_COLORGFX = $03;

def PCC_BW = $01;
def PCC_YMC = $02;
def PCC_YMC_BW = $03;
def PCC_YMCB = $04;
def PCC_4COLOR = $04;
def PCC_ADDITIVE = $08;
def PCC_WB = $09;
def PCC_BGR = $0a;
def PCC_BGR_WB = $0b;
def PCC_BGRW = $0c;

def PCC_MULTI_PASS = $10;

struct PrinterExtendedData is
  ped_PrinterName:ulong;
  ped_Init:ulong;
  ped_Expunge:ulong;
  ped_Open:ulong;
  ped_Close:ulong;
  ped_PrinterClass:ubyte;
  ped_ColorClass:ubyte;
  ped_MaxColumns:ubyte;
  ped_NumCharSets:ubyte;
  ped_NumRows:uword;
  ped_MaxXDots:ulong;
  ped_MaxYDots:ulong;
  ped_XDotsInch:uword;
  ped_YDotsInch:uword;
  ped_Commands:ulong;
  ped_DoSpecial:ulong;
  ped_Render:ulong;
  ped_TimeoutSecs:long;
  ped_8BitChars:ulong;
  ped_PrintMode:long;
  ped_ConvFunc:ulong;
;

struct PrinterSegment is
  ps_NextSegment:ulong;
  ps_runAlert:ulong;
  ps_Version:uword;
  ps_Revision:uword;
  ps_PED:PrinterExtendedData;
;

