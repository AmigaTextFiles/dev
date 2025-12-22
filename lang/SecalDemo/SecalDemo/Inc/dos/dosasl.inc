include "inc/exec/libraries.inc";
include "inc/exec/lists.inc";
include "inc/dos/dos.inc";

struct AnchorPath is
  ap_Base:ulong;
  ap_Last:ulong;
  ap_BreakBits:long;
  ap_FoundBreak:long;
  ap_Flags:byte;
  ap_Reserved:byte;
  ap_Strlen:word;
  ap_Info:FileInfoBlock;
  ap_Buf[1]:ubyte;
;

def ap_First = ap_Base;
def ap_Current = ap_Last;
def ap_Length = ap_Flags;

def APB_DOWILD = 0;
def APF_DOWILD = 1;

def APB_ITSWILD = 1;
def APF_ITSWILD = 2;

def APB_DODIR = 2;
def APF_DODIR = 4;

def APB_DIDDIR = 3;
def APF_DIDDIR = 8;

def APB_NOMEMERR = 4;
def APF_NOMEMERR = 16;

def APB_DODOT = 5;
def APF_DODOT = 32;

def APB_DirChanged = 6;
def APF_DirChanged = 64;

def APB_FollowHLinks = 7;
def APF_FollowHLinks = 128;

struct AChain is
  an_Child:ulong;
  an_Parent:ulong;
  an_Lock:long;
  an_Info:FileInfoBlock;
  an_Flags:byte;
  an_String[1]:ubyte;
;

def DDB_PatternBit = 0;
def DDF_PatternBit = 1;
def DDB_ExaminedBit = 1;
def DDF_ExaminedBit = 2;
def DDB_Completed = 2;
def DDF_Completed = 4;
def DDB_AllBit = 3;
def DDF_AllBit = 8;
def DDB_Single = 4;
def DDF_Single = 16;

def P_ANY = $80;
def P_SINGLE = $81;
def P_ORSTART = $82;
def P_ORNEXT = $83;
def P_OREND = $84;
def P_NOT = $85;
def P_NOTEND = $86;
def P_NOTCLASS = $87;
def P_CLASS = $88;
def P_REPBEG = $89;
def P_REPEND = $8a;
def P_STOP = $8b;

def COMPLEX_BIT = 1;
def EXAMINE_BIT = 2;

def ERROR_BUFFER_OVERFLOW = 303;
def ERROR_BREAK = 304;
def ERROR_NOT_EXECUTABLE = 305;

