include "inc/exec/types.inc";
include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";
include "inc/exec/ports.inc";

def PRD_RAWWRITE = (CMD_NONSTD+0);
def PRD_PRTCOMMAND = (CMD_NONSTD+1);
def PRD_DUMPRPORT = (CMD_NONSTD+2);
def PRD_QUERY = (CMD_NONSTD+3);

def aRIS = 0;
def aRIN = 1;
def aIND = 2;
def aNEL = 3;
def aRI = 4;

def aSGR0 = 5;
def aSGR3 = 6;
def aSGR23 = 7;
def aSGR4 = 8;
def aSGR24 = 9;
def aSGR1 = 10;
def aSGR22 = 11;
def aSFC = 12;
def aSBC = 13;

def aSHORP0 = 14;
def aSHORP2 = 15;
def aSHORP1 = 16;
def aSHORP4 = 17;
def aSHORP3 = 18;
def aSHORP6 = 19;
def aSHORP5 = 20;

def aDEN6 = 21;
def aDEN5 = 22;
def aDEN4 = 23;
def aDEN3 = 24;
def aDEN2 = 25;
def aDEN1 = 26;

def aSUS2 = 27;
def aSUS1 = 28;
def aSUS4 = 29;
def aSUS3 = 30;
def aSUS0 = 31;
def aPLU = 32;
def aPLD = 33;

def aFNT0 = 34;
def aFNT1 = 35;
def aFNT2 = 36;
def aFNT3 = 37;
def aFNT4 = 38;
def aFNT5 = 39;
def aFNT6 = 40;
def aFNT7 = 41;
def aFNT8 = 42;
def aFNT9 = 43;
def aFNT10 = 44;

def aPROP2 = 45;
def aPROP1 = 46;
def aPROP0 = 47;
def aTSS = 48;
def aJFY5 = 49;
def aJFY7 = 50;
def aJFY6 = 51;
def aJFY0 = 52;
def aJFY3 = 53;
def aJFY1 = 54;

def aVERP0 = 55;
def aVERP1 = 56;
def aSLPP = 57;
def aPERF = 58;
def aPERF0 = 59;

def aLMS = 60;
def aRMS = 61;
def aTMS = 62;
def aBMS = 63;
def aSTBM = 64;
def aSLRM = 65;
def aCAM = 66;

def aHTS = 67;
def aVTS = 68;
def aTBC0 = 69;
def aTBC3 = 70;
def aTBC1 = 71;
def aTBC4 = 72;
def aTBCALL = 73;
def aTBSALL = 74;
def aEXTEND = 75;

def aRAW = 76;

struct IOPrtCmdReq is
  io_Message:Message;
  io_Device:ulong;
  io_Unit:ulong;
  io_Command:uword;
  io_Flags:ubyte;
  io_Error:byte;
  io_PrtCommand:uword;
  io_Parm0:ubyte;
  io_Parm1:ubyte;
  io_Parm2:ubyte;
  io_Parm3:ubyte;
;

struct IODRPReq is
  io_Message:Message;
  io_Device:ulong;
  io_Unit:ulong;
  io_Command:uword;
  io_Flags:ubyte;
  io_Error:byte;
  io_RastPort:ulong;
  io_ColorMap:ulong;
  io_Modes:ulong;
  io_SrcX:uword;
  io_SrcY:uword;
  io_SrcWidth:uword;
  io_SrcHeight:uword;
  io_DestCols:long;
  io_DestRows:long;
  io_Special:uword;
;

def SPECIAL_MILCOLS = $0001;
def SPECIAL_MILROWS = $0002;
def SPECIAL_FULLCOLS = $0004;
def SPECIAL_FULLROWS = $0008;
def SPECIAL_FRACCOLS = $0010;
def SPECIAL_FRACROWS = $0020;
def SPECIAL_CENTER = $0040;
def SPECIAL_ASPECT = $0080;
def SPECIAL_DENSITY1 = $0100;
def SPECIAL_DENSITY2 = $0200;
def SPECIAL_DENSITY3 = $0300;
def SPECIAL_DENSITY4 = $0400;
def SPECIAL_DENSITY5 = $0500;
def SPECIAL_DENSITY6 = $0600;
def SPECIAL_DENSITY7 = $0700;
def SPECIAL_NOFORMFEED = $0800;
def SPECIAL_TRUSTME = $1000;

def SPECIAL_NOPRINT = $2000;

def PDERR_NOERR = 0;
def PDERR_CANCEL = 1;
def PDERR_NOTGRAPHICS = 2;
def PDERR_INVERTHAM = 3;
def PDERR_BADDIMENSION = 4;
def PDERR_DIMENSIONOVFLOW = 5;
def PDERR_INTERNALMEMORY = 6;
def PDERR_BUFFERMEMORY = 7;

def PDERR_TOOKCONTROL = 8;

def SPECIAL_DENSITYMASK = $0700;
def SPECIAL_DIMENSIONSMASK = (SPECIAL_MILCOLS|SPECIAL_MILROWS|SPECIAL_FULLCOLS|SPECIAL_FULLROWS|SPECIAL_FRACCOLS|SPECIAL_FRACROWS|SPECIAL_ASPECT);

