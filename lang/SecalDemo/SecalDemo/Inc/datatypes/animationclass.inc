include "inc/utility/tagitem.inc";
include "inc/datatypes/datatypesclass.inc";
include "inc/datatypes/pictureclass.inc";
include "inc/datatypes/soundclass.inc";
include "inc/libraries/iffparse.inc";

def ANIMATIONDTCLASS = "animation.datatype";

def ADTA_Dummy = (DTA_Dummy+600);

def ADTA_ModeID = PDTA_ModeID;
def ADTA_KeyFrame = PDTA_BitMap;
def ADTA_ColorRegisters = PDTA_ColorRegisters;
def ADTA_CRegs = PDTA_CRegs;
def ADTA_GRegs = PDTA_GRegs;
def ADTA_ColorTable = PDTA_ColorTable;
def ADTA_ColorTable2 = PDTA_ColorTable2;
def ADTA_Allocated = PDTA_Allocated;
def ADTA_NumColors = PDTA_NumColors;
def ADTA_NumAlloc = PDTA_NumAlloc;
def ADTA_Remap = PDTA_Remap;
def ADTA_Screen = PDTA_Screen;
def ADTA_NumSparse = PDTA_NumSparse;
def ADTA_SparseTable = PDTA_SparseTable;
def ADTA_Width = (ADTA_Dummy+1);
def ADTA_Height = (ADTA_Dummy+2);
def ADTA_Depth = (ADTA_Dummy+3);
def ADTA_Frames = (ADTA_Dummy+4);
def ADTA_Frame = (ADTA_Dummy+5);
def ADTA_FramesPerSecond = (ADTA_Dummy+6);
def ADTA_FrameIncrement = (ADTA_Dummy+7);
def ADTA_Sample = SDTA_Sample;
def ADTA_SampleLength = SDTA_SampleLength;
def ADTA_Period = SDTA_Period;
def ADTA_Volume = SDTA_Volume;
def ADTA_Cycles = SDTA_Cycles;

struct AnimHeader is
  ah_Operation:ubyte;
  ah_Mask:ubyte;
  ah_Width:uword;
  ah_Height:uword;
  ah_Left:word;
  ah_Top:word;
  ah_AbsTime:ulong;
  ah_RelTime:ulong;
  ah_Interleave:ubyte;
  ah_Pad0:ubyte;
  ah_Flags:ulong;
  ah_Pad[16]:ubyte;
;

def ADTM_Dummy = ($700);

def ADTM_LOADFRAME = ($701);
def ADTM_UNLOADFRAME = ($702);
def ADTM_START = ($703);
def ADTM_PAUSE = ($704);
def ADTM_STOP = ($705);
def ADTM_LOCATE = ($706);

struct adtFrame is
  MethodID:ulong;
  alf_TimeStamp:ulong;
  alf_Frame:ulong;
  alf_Duration:ulong;
  alf_BitMap:ulong;
  alf_CMap:ulong;
  alf_Sample:ulong;
  alf_SampleLength:ulong;
  alf_Period:ulong;
  alf_UserData:ulong;
;

struct adtStart is
  MethodID:ulong;
  asa_Frame:ulong;
;

