include "inc/exec/types.inc";

struct StringExtend is
  Font:ulong;
  Pens[2]:ubyte;
  ActivePens[2]:ubyte;
  InitialModes:ulong;
  EditHook:ulong;
  WorkBuffer:ulong;
  Reserved[4]:ulong;
;

struct SGWork is
  Gadget:ulong;
  StringInfo:ulong;
  WorkBuffer:ulong;
  PrevBuffer:ulong;
  Modes:ulong;
  IEvent:ulong;
  Code:uword;
  BufferPos:word;
  NumChars:word;
  Actions:ulong;
  LongInt:long;
  GadgetInfo:ulong;
  EditOp:uword;
;

def EO_NOOP = ($0001);

def EO_DELBACKWARD = ($0002);
def EO_DELFORWARD = ($0003);
def EO_MOVECURSOR = ($0004);
def EO_ENTER = ($0005);
def EO_RESET = ($0006);
def EO_REPLACECHAR = ($0007);
def EO_INSERTCHAR = ($0008);
def EO_BADFORMAT = ($0009);
def EO_BIGCHANGE = ($000a);
def EO_UNDO = ($000b);
def EO_CLEAR = ($000c);
def EO_SPECIAL = ($000d);

def SGM_REPLACE = (1<<0);
def SGM_FIXEDFIELD = (1<<1);
def SGM_NOFILTER = (1<<2);
def SGM_EXITHELP = (1<<7);

def SGM_NOCHANGE = (1<<3);
def SGM_NOWORKB = (1<<4);
def SGM_CONTROL = (1<<5);
def SGM_LONGINT = (1<<6);

def SGA_USE = ($1);
def SGA_END = ($2);
def SGA_BEEP = ($4);
def SGA_REUSE = ($8);
def SGA_REDISPLAY = ($10);

def SGA_NEXTACTIVE = ($20);
def SGA_PREVACTIVE = ($40);

def SGH_KEY = (1);
def SGH_CLICK = (2);

