include "inc/exec/nodes.inc";

struct MemChunk is
  mc_Next:ulong;
  mc_Bytes:ulong;
;

struct MemHeader is
  mh_Node:Node;
  mh_Attributes:uword;
  mh_First:ulong;
  mh_Lower:ulong;
  mh_Upper:ulong;
  mh_Free:ulong;
;

struct MemEntry is
  me_Un:union is
    meu_Reqs:ulong;
    meu_Addr:ulong;
  ;
  me_Length:ulong;
;

struct MemList is
  ml_Node:Node;
  ml_NumEntries:uword;
  ml_ME[1]:MemEntry;
;

def ml_me = ml_ME;

def MEMF_ANY = (0);
def MEMF_PUBLIC = (1<<0);
def MEMF_CHIP = (1<<1);
def MEMF_FAST = (1<<2);
def MEMF_LOCAL = (1<<8);
def MEMF_24BITDMA = (1<<9);
def MEMF_KICK = (1<<10);

def MEMF_CLEAR = (1<<16);
def MEMF_LARGEST = (1<<17);
def MEMF_REVERSE = (1<<18);
def MEMF_TOTAL = (1<<19);

def MEMF_NO_EXPUNGE = (1<<31);

def MEM_BLOCKSIZE = 8;
def MEM_BLOCKMASK = (MEM_BLOCKSIZE-1);

struct MemHandlerData is
  memh_RequestSize:ulong;
  memh_RequestFlags:ulong;
  memh_Flags:ulong;
;

def MEMHF_RECYCLE = (1<<0);

def MEM_DID_NOTHING = (0);
def MEM_ALL_DONE = (-1);
def MEM_TRY_AGAIN = (1);

