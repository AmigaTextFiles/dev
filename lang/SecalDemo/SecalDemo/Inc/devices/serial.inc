include "inc/exec/io.inc";

struct IOTArray is
  TermArray0:ulong;
  TermArray1:ulong;
;

def SER_DEFAULT_CTLCHAR = $11130000;

struct IOExtSer is
  IOSer:IOStdReq;
  io_CtlChar:ulong;
  io_RBufLen:ulong;
  io_ExtFlags:ulong;
  io_Baud:ulong;
  io_BrkTime:ulong;
  io_TermArray:IOTArray;
  io_ReadLen:ubyte;
  io_WriteLen:ubyte;
  io_StopBits:ubyte;
  io_SerFlags:ubyte;
  io_Status:uword;
;

def SDCMD_QUERY = CMD_NONSTD;
def SDCMD_BREAK = (CMD_NONSTD+1);
def SDCMD_SETPARAMS = (CMD_NONSTD+2);

def SERB_XDISABLED = 7;
def SERF_XDISABLED = (1<<7);
def SERB_EOFMODE = 6;
def SERF_EOFMODE = (1<<6);
def SERB_SHARED = 5;
def SERF_SHARED = (1<<5);
def SERB_RAD_BOOGIE = 4;
def SERF_RAD_BOOGIE = (1<<4);
def SERB_QUEUEDBRK = 3;
def SERF_QUEUEDBRK = (1<<3);
def SERB_7WIRE = 2;
def SERF_7WIRE = (1<<2);
def SERB_PARTY_ODD = 1;
def SERF_PARTY_ODD = (1<<1);
def SERB_PARTY_ON = 0;
def SERF_PARTY_ON = (1<<0);

def IO_STATB_XOFFREAD = 12;
def IO_STATF_XOFFREAD = (1<<12);
def IO_STATB_XOFFWRITE = 11;
def IO_STATF_XOFFWRITE = (1<<11);
def IO_STATB_READBREAK = 10;
def IO_STATF_READBREAK = (1<<10);
def IO_STATB_WROTEBREAK = 9;
def IO_STATF_WROTEBREAK = (1<<9);
def IO_STATB_OVERRUN = 8;
def IO_STATF_OVERRUN = (1<<8);

def SEXTB_MSPON = 1;
def SEXTF_MSPON = (1<<1);
def SEXTB_MARK = 0;
def SEXTF_MARK = (1<<0);

def SerErr_DevBusy = 1;
def SerErr_BaudMismatch = 2;
def SerErr_BufErr = 4;
def SerErr_InvParam = 5;
def SerErr_LineErr = 6;
def SerErr_ParityErr = 9;
def SerErr_TimerErr = 11;
def SerErr_BufOverflow = 12;
def SerErr_NoDSR = 13;
def SerErr_DetectedBreak = 15;

def SERIALNAME = "serial.device";

