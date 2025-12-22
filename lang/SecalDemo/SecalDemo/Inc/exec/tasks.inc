include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";

struct Task is
  tc_Node:Node;
  tc_Flags:ubyte;
  tc_State:ubyte;
  tc_IDNestCnt:byte;
  tc_TDNestCnt:byte;
  tc_SigAlloc:ulong;
  tc_SigWait:ulong;
  tc_SigRecvd:ulong;
  tc_SigExcept:ulong;
  tc_TrapAlloc:uword;
  tc_TrapAble:uword;
  tc_ExceptData:ulong;
  tc_ExceptCode:ulong;
  tc_TrapData:ulong;
  tc_TrapCode:ulong;
  tc_SPReg:ulong;
  tc_SPLower:ulong;
  tc_SPUpper:ulong;
  tc_Switch:ulong;
  tc_Launch:ulong;
  tc_MemEntry:List;
  tc_UserData:ulong;
;

struct StackSwapStruct is
  stk_Lower:ulong;
  stk_Upper:ulong;
  stk_Pointer:ulong;
;

def TB_PROCTIME = 0;
def TB_ETASK = 3;
def TB_STACKCHK = 4;
def TB_EXCEPT = 5;
def TB_SWITCH = 6;
def TB_LAUNCH = 7;

def TF_PROCTIME = (1<<0);
def TF_ETASK = (1<<3);
def TF_STACKCHK = (1<<4);
def TF_EXCEPT = (1<<5);
def TF_SWITCH = (1<<6);
def TF_LAUNCH = (1<<7);

def TS_INVALID = 0;
def TS_ADDED = 1;
def TS_RUN = 2;
def TS_READY = 3;
def TS_WAIT = 4;
def TS_EXCEPT = 5;
def TS_REMOVED = 6;

def SIGB_ABORT = 0;
def SIGB_CHILD = 1;
def SIGB_BLIT = 4;
def SIGB_SINGLE = 4;
def SIGB_INTUITION = 5;
def SIGB_NET = 7;
def SIGB_DOS = 8;

def SIGF_ABORT = (1<<0);
def SIGF_CHILD = (1<<1);
def SIGF_BLIT = (1<<4);
def SIGF_SINGLE = (1<<4);
def SIGF_INTUITION = (1<<5);
def SIGF_NET = (1<<7);
def SIGF_DOS = (1<<8);

