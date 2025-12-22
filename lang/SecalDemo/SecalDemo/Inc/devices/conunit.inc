include "inc/exec/types.inc";
include "inc/exec/ports.inc";
include "inc/devices/console.inc";
include "inc/devices/keymap.inc";
include "inc/devices/inputevent.inc";

def CONU_LIBRARY = -1;
def CONU_STANDARD = 0;

def CONU_CHARMAP = 1;
def CONU_SNIPMAP = 3;

def CONFLAG_DEFAULT = 0;
def CONFLAG_NODRAW_ON_NEWSIZE = 1;

def PMB_ASM = (M_LNM+1);
def PMB_AWM = (PMB_ASM+1);
def MAXTABS = 80;

struct ConUnit is
  cu_MP:MsgPort;
  cu_Window:ulong;
  cu_XCP:word;
  cu_YCP:word;
  cu_XMax:word;
  cu_YMax:word;
  cu_XRSize:word;
  cu_YRSize:word;
  cu_XROrigin:word;
  cu_YROrigin:word;
  cu_XRExtant:word;
  cu_YRExtant:word;
  cu_XMinShrink:word;
  cu_YMinShrink:word;
  cu_XCCP:word;
  cu_YCCP:word;
  cu_KeyMapStruct:KeyMap;
  cu_TabStops[80]:uword;
  cu_Mask:byte;
  cu_FgPen:byte;
  cu_BgPen:byte;
  cu_AOLPen:byte;
  cu_DrawMode:byte;
  cu_Obsolete1:byte;
  cu_Obsolete2:ulong;
  cu_Minterms[8]:ubyte;
  cu_Font:ulong;
  cu_AlgoStyle:ubyte;
  cu_TxFlags:ubyte;
  cu_TxHeight:uword;
  cu_TxWidth:uword;
  cu_TxBaseline:uword;
  cu_TxSpacing:word;
  cu_Modes[(((20+1)+1)+7)/8]:ubyte;
  cu_RawEvents[($15+8)/8]:ubyte;
;

