include "inc/exec/types.inc";

struct Node is
  ln_Succ:ulong;
  ln_Pred:ulong;
  ln_Type:ubyte;
  ln_Pri:byte;
  ln_Name:ulong;
;

struct MinNode is
  mln_Succ:ulong;
  mln_Pred:ulong;
;

def NT_UNKNOWN = 0;
def NT_TASK = 1;
def NT_INTERRUPT = 2;
def NT_DEVICE = 3;
def NT_MSGPORT = 4;
def NT_MESSAGE = 5;
def NT_FREEMSG = 6;
def NT_REPLYMSG = 7;
def NT_RESOURCE = 8;
def NT_LIBRARY = 9;
def NT_MEMORY = 10;
def NT_SOFTINT = 11;
def NT_FONT = 12;
def NT_PROCESS = 13;
def NT_SEMAPHORE = 14;
def NT_SIGNALSEM = 15;
def NT_BOOTNODE = 16;
def NT_KICKMEM = 17;
def NT_GRAPHICS = 18;
def NT_DEATHMESSAGE = 19;

def NT_USER = 254;
def NT_EXTENDED = 255;

