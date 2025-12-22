include "inc/exec/nodes.inc";

def LIB_VECTSIZE = 6;
def LIB_RESERVED = 4;
def LIB_BASE = (-LIB_VECTSIZE);
def LIB_USERDEF = (LIB_BASE-(LIB_RESERVED*LIB_VECTSIZE));
def LIB_NONSTD = (LIB_USERDEF);

def LIB_OPEN = (-6);
def LIB_CLOSE = (-12);
def LIB_EXPUNGE = (-18);
def LIB_EXTFUNC = (-24);

struct Library is
  lib_Node:Node;
  lib_Flags:ubyte;
  lib_pad:ubyte;
  lib_NegSize:uword;
  lib_PosSize:uword;
  lib_Version:uword;
  lib_Revision:uword;
  lib_IdString:ulong;
  lib_Sum:ulong;
  lib_OpenCnt:uword;
;

def LIBF_SUMMING = (1<<0);
def LIBF_CHANGED = (1<<1);
def LIBF_SUMUSED = (1<<2);
def LIBF_DELEXP = (1<<3);

def lh_Node = lib_Node;
def lh_Flags = lib_Flags;
def lh_pad = lib_pad;
def lh_NegSize = lib_NegSize;
def lh_PosSize = lib_PosSize;
def lh_Version = lib_Version;
def lh_Revision = lib_Revision;
def lh_IdString = lib_IdString;
def lh_Sum = lib_Sum;
def lh_OpenCnt = lib_OpenCnt;

