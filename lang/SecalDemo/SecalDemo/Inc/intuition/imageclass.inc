include "inc/utility/tagitem.inc";

def CUSTOMIMAGEDEPTH = (-1);

def IA_Dummy = (TAG_USER+$20000);

def IA_Left = (IA_Dummy+$01);
def IA_Top = (IA_Dummy+$02);
def IA_Width = (IA_Dummy+$03);
def IA_Height = (IA_Dummy+$04);
def IA_FGPen = (IA_Dummy+$05);
def IA_BGPen = (IA_Dummy+$06);
def IA_Data = (IA_Dummy+$07);
def IA_LineWidth = (IA_Dummy+$08);
def IA_Pens = (IA_Dummy+$0e);
def IA_Resolution = (IA_Dummy+$0f);

def IA_APattern = (IA_Dummy+$10);
def IA_APatSize = (IA_Dummy+$11);
def IA_Mode = (IA_Dummy+$12);
def IA_Font = (IA_Dummy+$13);
def IA_Outline = (IA_Dummy+$14);
def IA_Recessed = (IA_Dummy+$15);
def IA_DoubleEmboss = (IA_Dummy+$16);
def IA_EdgesOnly = (IA_Dummy+$17);

def SYSIA_Size = (IA_Dummy+$0b);
def SYSIA_Depth = (IA_Dummy+$0c);
def SYSIA_Which = (IA_Dummy+$0d);
def SYSIA_DrawInfo = (IA_Dummy+$18);

def SYSIA_ReferenceFont = (IA_Dummy+$19);
def IA_SupportsDisable = (IA_Dummy+$1a);
def IA_FrameType = (IA_Dummy+$1b);

def SYSISIZE_MEDRES = (0);
def SYSISIZE_LOWRES = (1);
def SYSISIZE_HIRES = (2);

def DEPTHIMAGE = ($00);
def ZOOMIMAGE = ($01);
def SIZEIMAGE = ($02);
def CLOSEIMAGE = ($03);
def SDEPTHIMAGE = ($05);
def LEFTIMAGE = ($0a);
def UPIMAGE = ($0b);
def RIGHTIMAGE = ($0c);
def DOWNIMAGE = ($0d);
def CHECKIMAGE = ($0e);
def MXIMAGE = ($0f);

def MENUCHECK = ($10);
def AMIGAKEY = ($11);

def FRAME_DEFAULT = 0;
def FRAME_BUTTON = 1;
def FRAME_RIDGE = 2;
def FRAME_ICONDROPBOX = 3;

def IM_DRAW = $202;
def IM_HITTEST = $203;
def IM_ERASE = $204;
def IM_MOVE = $205;

def IM_DRAWFRAME = $206;
def IM_FRAMEBOX = $207;
def IM_HITFRAME = $208;
def IM_ERASEFRAME = $209;

def IDS_NORMAL = (0);
def IDS_SELECTED = (1);
def IDS_DISABLED = (2);
def IDS_BUSY = (3);
def IDS_INDETERMINATE = (4);
def IDS_INACTIVENORMAL = (5);
def IDS_INACTIVESELECTED = (6);
def IDS_INACTIVEDISABLED = (7);
def IDS_SELECTEDDISABLED = (8);

def IDS_INDETERMINANT = IDS_INDETERMINATE;

struct impFrameBox is
  MethodID:ulong;
  imp_ContentsBox:ulong;
  imp_FrameBox:ulong;
  imp_DrInfo:ulong;
  imp_FrameFlags:ulong;
;

struct impDraw is
  MethodID:ulong;
  imp_RPort:ulong;
  imp_Offset:struct is
    X:word;
    Y:word;
  ;

  imp_State:ulong;
  imp_DrInfo:ulong;
  imp_Dimensions:struct is
    Width:word;
    Height:word;
  ;
;

struct impErase is
  MethodID:ulong;
  imp_RPort:ulong;
  imp_Offset:struct is
    X:word;
    Y:word;
  ;
  imp_Dimensions:struct is
    Width:word;
    Height:word;
  ;
;

struct impHitTest is
  MethodID:ulong;
  imp_Point:struct is
    X:word;
    Y:word;
  ;
  imp_Dimensions:struct is
    Width:word;
    Height:word;
  ;
;

