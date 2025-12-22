include "inc/exec/types.inc";
include "inc/exec/libraries.inc";
include "inc/exec/semaphores.inc";
include "inc/libraries/configvars.inc";

struct BootNode is
  bn_Node:Node;
  bn_Flags:uword;
  bn_DeviceNode:ulong;
;

struct ExpansionLibBase is
  LibNode:Library;
  Flags:ubyte;
  eb_Private01:ubyte;
  eb_Private02:ulong;
  eb_Private03:ulong;
  eb_Private04:CurrentBinding;
  eb_Private05:List;
  MountList:List;
;

def EE_OK = 0;
def EE_LASTBOARD = 40;
def EE_NOEXPANSION = 41;
def EE_NOMEMORY = 42;
def EE_NOBOARD = 43;
def EE_BADMEM = 44;

def EBB_CLOGGED = 0;
def EBF_CLOGGED = (1<<0);
def EBB_SHORTMEM = 1;
def EBF_SHORTMEM = (1<<1);
def EBB_BADMEM = 2;
def EBF_BADMEM = (1<<2);
def EBB_DOSFLAG = 3;
def EBF_DOSFLAG = (1<<3);
def EBB_KICKBACK33 = 4;
def EBF_KICKBACK33 = (1<<4);
def EBB_KICKBACK36 = 5;
def EBF_KICKBACK36 = (1<<5);
def EBB_SILENTSTART = 6;
def EBF_SILENTSTART = (1<<6);

def EBB_START_CC0 = 7;
def EBF_START_CC0 = (1<<7);

