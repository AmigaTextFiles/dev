include "inc/exec/types.inc";

def COPPER_MOVE = 0;
def COPPER_WAIT = 1;
def CPRNXTBUF = 2;
def CPR_NT_LOF = $8000;
def CPR_NT_SHT = $4000;
def CPR_NT_SYS = $2000;

struct CopIns is
  OpCode:word;

  u3:union is
    nxtlist:ulong;

    u4:struct is

      u1:union is
        VWaitPos:word;
        DestAddr:word;
      ;

      u2:union is
        HWaitPos:word;
        DestData:word;
      ;
    ;
  ;
;

def NXTLIST = u3.nxtlist;
def VWAITPOS = u3.u4.u1.VWaitPos;
def DESTADDR = u3.u4.u1.DestAddr;
def HWAITPOS = u3.u4.u2.HWaitPos;
def DESTDATA = u3.u4.u2.DestData;

struct cprlist is
  Next:ulong;
  start:ulong;
  MaxCount:word;
;

struct CopList is
  Next:ulong;
  _CopList:ulong;
  _ViewPort:ulong;
  CopIns:ulong;
  CopPtr:ulong;
  CopLStart:ulong;
  CopSStart:ulong;
  Count:word;
  MaxCount:word;
  DyOffset:word;
  Cop2Start:ulong;
  Cop3Start:ulong;
  Cop4Start:ulong;
  Cop5Start:ulong;
  SLRepeat:uword;
  Flags:uword;
;

def EXACT_LINE = 1;
def HALF_LINE = 2;

struct UCopList is
  Next:ulong;
  FirstCopList:ulong;
  CopList:ulong;
;

struct copinit is
  vsync_hblank[2]:uword;
  diagstrt[12]:uword;
  fm0[2]:uword;
  diwstart[10]:uword;
  bplcon2[2]:uword;
  sprfix[2*8]:uword;
  sprstrtup[(2*8*2)]:uword;
  wait14[2]:uword;
  norm_hblank[2]:uword;
  jump[2]:uword;
  wait_forever[6]:uword;
  sprstop[8]:uword;
;

