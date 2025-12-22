include "inc/exec/ports.inc";

struct IORequest is
  io_Message:Message;
  io_Device:ulong;
  io_Unit:ulong;
  io_Command:uword;
  io_Flags:ubyte;
  io_Error:byte;
;

struct IOStdReq is
  io_Message:Message;
  io_Device:ulong;
  io_Unit:ulong;
  io_Command:uword;
  io_Flags:ubyte;
  io_Error:byte;
  io_Actual:ulong;
  io_Length:ulong;
  io_Data:ulong;
  io_Offset:ulong;
;

def DEV_BEGINIO = (-30);
def DEV_ABORTIO = (-36);

def IOB_QUICK = 0;
def IOF_QUICK = (1<<0);

def CMD_INVALID = 0;
def CMD_RESET = 1;
def CMD_READ = 2;
def CMD_WRITE = 3;
def CMD_UPDATE = 4;
def CMD_CLEAR = 5;
def CMD_STOP = 6;
def CMD_START = 7;
def CMD_FLUSH = 8;

def CMD_NONSTD = 9;

