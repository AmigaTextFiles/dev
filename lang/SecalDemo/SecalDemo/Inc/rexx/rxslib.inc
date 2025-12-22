include "inc/rexx/storage.inc";

def RXSNAME = "rexxsyslib.library";
def RXSDIR = "REXX";
def RXSTNAME = "ARexx";

struct RxsLib is
  rl_Node:Library;
  rl_Flags:ubyte;
  rl_Shadow:ubyte;
  rl_SysBase:ulong;
  rl_DOSBase:ulong;
  rl_IeeeDPBase:ulong;
  rl_SegList:long;
  rl_NIL:long;
  rl_Chunk:long;
  rl_MaxNest:long;
  rl_NULL:ulong;
  rl_FALSE:ulong;
  rl_TRUE:ulong;
  rl_REXX:ulong;
  rl_COMMAND:ulong;
  rl_STDIN:ulong;
  rl_STDOUT:ulong;
  rl_STDERR:ulong;
  rl_Version:ulong;
  rl_TaskName:ulong;
  rl_TaskPri:long;
  rl_TaskSeg:long;
  rl_StackSize:long;
  rl_RexxDir:ulong;
  rl_CTABLE:ulong;
  rl_Notice:ulong;
  rl_RexxPort:MsgPort;
  rl_ReadLock:uword;
  rl_TraceFH:long;
  rl_TaskList:List;
  rl_NumTask:word;
  rl_LibList:List;
  rl_NumLib:word;
  rl_ClipList:List;
  rl_NumClip:word;
  rl_MsgList:List;
  rl_NumMsg:word;
  rl_PgmList:List;
  rl_NumPgm:word;
  rl_TraceCnt:uword;
  rl_avail:word;
;

def RLFB_TRACE = RTFB_TRACE;
def RLFB_HALT = RTFB_HALT;
def RLFB_SUSP = RTFB_SUSP;
def RLFB_STOP = 6;
def RLFB_CLOSE = 7;

def RLFMASK = (1<<RLFB_TRACE)|(1<<RLFB_HALT)|(1<<RLFB_SUSP);

def RXSCHUNK = 1024;
def RXSNEST = 32;
def RXSTPRI = 0;
def RXSSTACK = 4096;

def CTB_SPACE = 0;
def CTB_DIGIT = 1;
def CTB_ALPHA = 2;
def CTB_REXXSYM = 3;
def CTB_REXXOPR = 4;
def CTB_REXXSPC = 5;
def CTB_UPPER = 6;
def CTB_LOWER = 7;

def CTF_SPACE = (1<<CTB_SPACE);
def CTF_DIGIT = (1<<CTB_DIGIT);
def CTF_ALPHA = (1<<CTB_ALPHA);
def CTF_REXXSYM = (1<<CTB_REXXSYM);
def CTF_REXXOPR = (1<<CTB_REXXOPR);
def CTF_REXXSPC = (1<<CTB_REXXSPC);
def CTF_UPPER = (1<<CTB_UPPER);
def CTF_LOWER = (1<<CTB_LOWER);

