include "inc/exec/io.inc";

struct IOPArray is
  PTermArray0:ulong;
  PTermArray1:ulong;
;

struct IOExtPar is
  IOPar:IOStdReq;
  io_PExtFlags:ulong;
  io_Status:ubyte;
  io_ParFlags:ubyte;
  io_PTermArray:IOPArray;
;

def PARB_SHARED = 5;
def PARF_SHARED = (1<<5);
def PARB_SLOWMODE = 4;
def PARF_SLOWMODE = (1<<4);
def PARB_FASTMODE = 3;
def PARF_FASTMODE = (1<<3);
def PARB_RAD_BOOGIE = 3;
def PARF_RAD_BOOGIE = (1<<3);

def PARB_ACKMODE = 2;
def PARF_ACKMODE = (1<<2);

def PARB_EOFMODE = 1;
def PARF_EOFMODE = (1<<1);

def IOPARB_QUEUED = 6;
def IOPARF_QUEUED = (1<<6);
def IOPARB_ABORT = 5;
def IOPARF_ABORT = (1<<5);
def IOPARB_ACTIVE = 4;
def IOPARF_ACTIVE = (1<<4);

def IOPTB_RWDIR = 3;
def IOPTF_RWDIR = (1<<3);
def IOPTB_PARSEL = 2;
def IOPTF_PARSEL = (1<<2);
def IOPTB_PAPEROUT = 1;
def IOPTF_PAPEROUT = (1<<1);
def IOPTB_PARBUSY = 0;
def IOPTF_PARBUSY = (1<<0);

def PARALLELNAME = "parallel.device";

def PDCMD_QUERY = (CMD_NONSTD);
def PDCMD_SETPARAMS = (CMD_NONSTD+1);

def ParErr_DevBusy = 1;
def ParErr_BufTooBig = 2;
def ParErr_InvParam = 3;
def ParErr_LineErr = 4;
def ParErr_NotOpen = 5;
def ParErr_PortReset = 6;
def ParErr_InitErr = 7;

