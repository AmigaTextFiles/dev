include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";

struct SerialPrefs is
  sp_Reserved[3]:long;
  sp_Unit0Map:ulong;
  sp_BaudRate:ulong;
  sp_InputBuffer:ulong;
  sp_OutputBuffer:ulong;
  sp_InputHandshake:ubyte;
  sp_OutputHandshake:ubyte;
  sp_Parity:ubyte;
  sp_BitsPerChar:ubyte;
  sp_StopBits:ubyte;
;

def PARITY_NONE = 0;
def PARITY_EVEN = 1;
def PARITY_ODD = 2;
def PARITY_MARK = 3;
def PARITY_SPACE = 4;

def HSHAKE_XON = 0;
def HSHAKE_RTS = 1;
def HSHAKE_NONE = 2;

