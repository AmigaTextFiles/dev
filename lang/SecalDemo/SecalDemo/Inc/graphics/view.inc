include "inc/exec/types.inc";
include "inc/exec/semaphores.inc";
include "inc/graphics/gfx.inc";
include "inc/graphics/copper.inc";
include "inc/graphics/gfxnodes.inc";
include "inc/graphics/monitor.inc";
include "inc/graphics/displayinfo.inc";
include "inc/hardware/custom.inc";

struct ViewPort is
  Next:ulong;
  ColorMap:ulong;
  DspIns:ulong;
  SprIns:ulong;
  ClrIns:ulong;
  UCopIns:ulong;
  DWidth,DHeight:word;
  DxOffset,DyOffset:word;
  Modes:uword;
  SpritePriorities:ubyte;
  ExtendedModes:ubyte;
  RasInfo:ulong;
;

struct View is
  ViewPort:ulong;
  LOFCprList:ulong;
  SHFCprList:ulong;
  DyOffset,DxOffset:word;
  Modes:uword;
;

struct ViewExtra is
  n:ExtendedNode;
  View:ulong;
  Monitor:ulong;
  TopLine:uword;
;

struct ViewPortExtra is
  n:ExtendedNode;
  ViewPort:ulong;
  DisplayClip:Rectangle;
  VecTable:ulong;
  DriverData[2]:ulong;
  Flags:uword;
  Origin[2]:Point;
  cop1ptr:ulong;
  cop2ptr:ulong;
;

def VPXB_FREE_ME = 0;
def VPXF_FREE_ME = (1<<VPXB_FREE_ME);
def VPXB_LAST = 1;
def VPXF_LAST = (1<<VPXB_LAST);
def VPXB_STRADDLES_256 = 4;
def VPXF_STRADDLES_256 = (1<<VPXB_STRADDLES_256);
def VPXB_STRADDLES_512 = 5;
def VPXF_STRADDLES_512 = (1<<VPXB_STRADDLES_512);

def EXTEND_VSTRUCT = $1000;

def VPF_A2024 = $40;
def VPF_TENHZ = $20;
def VPB_A2024 = 6;
def VPB_TENHZ = 4;

def GENLOCK_VIDEO = $0002;
def LACE = $0004;
def DOUBLESCAN = $0008;
def SUPERHIRES = $0020;
def PFBA = $0040;
def EXTRA_HALFBRITE = $0080;
def GENLOCK_AUDIO = $0100;
def DUALPF = $0400;
def HAM = $0800;
def EXTENDED_MODE = $1000;
def VP_HIDE = $2000;
def SPRITES = $4000;
def HIRES = $8000;

struct RasInfo is
  Next:ulong;
  BitMap:ulong;
  RxOffset,RyOffset:word;
;

struct ColorMap is
  Flags:ubyte;
  Type:ubyte;
  Count:uword;
  ColorTable:ulong;
  cm_vpe:ulong;
  LowColorBits:ulong;
  TransparencyPlane:ubyte;
  SpriteResolution:ubyte;
  SpriteResDefault:ubyte;
  AuxFlags:ubyte;
  cm_vp:ulong;
  NormalDisplayInfo:ulong;
  CoerceDisplayInfo:ulong;
  cm_batch_items:ulong;
  VPModeID:ulong;
  PalExtra:ulong;
  SpriteBase_Even:uword;
  SpriteBase_Odd:uword;
  Bp_0_base:uword;
  Bp_1_base:uword;

;

def COLORMAP_TYPE_V1_2 = $00;
def COLORMAP_TYPE_V1_4 = $01;
def COLORMAP_TYPE_V36 = COLORMAP_TYPE_V1_4;
def COLORMAP_TYPE_V39 = $02;

def COLORMAP_TRANSPARENCY = $01;
def COLORPLANE_TRANSPARENCY = $02;
def BORDER_BLANKING = $04;
def BORDER_NOTRANSPARENCY = $08;
def VIDEOCONTROL_BATCH = $10;
def USER_COPPER_CLIP = $20;
def BORDERSPRITES = $40;

def CMF_CMTRANS = 0;
def CMF_CPTRANS = 1;
def CMF_BRDRBLNK = 2;
def CMF_BRDNTRAN = 3;
def CMF_BRDRSPRT = 6;

def SPRITERESN_ECS = 0;
def SPRITERESN_140NS = 1;
def SPRITERESN_70NS = 2;
def SPRITERESN_35NS = 3;
def SPRITERESN_DEFAULT = -1;

def CMAB_FULLPALETTE = 0;
def CMAF_FULLPALETTE = (1<<CMAB_FULLPALETTE);
def CMAB_NO_INTERMED_UPDATE = 1;
def CMAF_NO_INTERMED_UPDATE = (1<<CMAB_NO_INTERMED_UPDATE);
def CMAB_NO_COLOR_LOAD = 2;
def CMAF_NO_COLOR_LOAD = (1<<CMAB_NO_COLOR_LOAD);
def CMAB_DUALPF_DISABLE = 3;
def CMAF_DUALPF_DISABLE = (1<<CMAB_DUALPF_DISABLE);

struct PaletteExtra is
  pe_Semaphore:SignalSemaphore;
  pe_FirstFree:uword;
  pe_NFree:uword;
  pe_FirstShared:uword;
  pe_NShared:uword;
  pe_RefCnt:ulong;
  pe_AllocList:ulong;
  pe_ViewPort:ulong;
  pe_SharableColors:uword;
;

def PENB_EXCLUSIVE = 0;
def PENB_NO_SETCOLOR = 1;

def PENF_EXCLUSIVE = (1<<PENB_EXCLUSIVE);
def PENF_NO_SETCOLOR = (1<<PENB_NO_SETCOLOR);

def PEN_EXCLUSIVE = PENF_EXCLUSIVE;
def PEN_NO_SETCOLOR = PENF_NO_SETCOLOR;

def PRECISION_EXACT = -1;
def PRECISION_IMAGE = 0;
def PRECISION_ICON = 16;
def PRECISION_GUI = 32;

def OBP_Precision = $84000000;
def OBP_FailIfBad = $84000001;

def MVP_OK = 0;
def MVP_NO_MEM = 1;
def MVP_NO_VPE = 2;
def MVP_NO_DSPINS = 3;
def MVP_NO_DISPLAY = 4;
def MVP_OFF_BOTTOM = 5;

def MCOP_OK = 0;
def MCOP_NO_MEM = 1;
def MCOP_NOP = 2;

struct DBufInfo is
  dbi_Link1:ulong;
  dbi_Count1:ulong;
  dbi_SafeMessage:Message;
  dbi_UserData1:ulong;
  dbi_Link2:ulong;
  dbi_Count2:ulong;
  dbi_DispMessage:Message;
  dbi_UserData2:ulong;
  dbi_MatchLong:ulong;
  dbi_CopPtr1:ulong;
  dbi_CopPtr2:ulong;
  dbi_CopPtr3:ulong;
  dbi_BeamPos1:uword;
  dbi_BeamPos2:uword;
;

