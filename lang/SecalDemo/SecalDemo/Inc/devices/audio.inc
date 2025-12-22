include "inc/exec/io.inc";

def AUDIONAME = "audio.device";

def ADHARD_CHANNELS = 4;

def ADALLOC_MINPREC = -128;
def ADALLOC_MAXPREC = 127;

def ADCMD_FREE = (CMD_NONSTD+0);
def ADCMD_SETPREC = (CMD_NONSTD+1);
def ADCMD_FINISH = (CMD_NONSTD+2);
def ADCMD_PERVOL = (CMD_NONSTD+3);
def ADCMD_LOCK = (CMD_NONSTD+4);
def ADCMD_WAITCYCLE = (CMD_NONSTD+5);
def ADCMD_ALLOCATE = 32;

def ADIOB_PERVOL = 4;
def ADIOF_PERVOL = (1<<4);
def ADIOB_SYNCCYCLE = 5;
def ADIOF_SYNCCYCLE = (1<<5);
def ADIOB_NOWAIT = 6;
def ADIOF_NOWAIT = (1<<6);
def ADIOB_WRITEMESSAGE = 7;
def ADIOF_WRITEMESSAGE = (1<<7);

def ADIOERR_NOALLOCATION = -10;
def ADIOERR_ALLOCFAILED = -11;
def ADIOERR_CHANNELSTOLEN = -12;

struct IOAudio is
  ioa_Request:IORequest;
  ioa_AllocKey:word;
  ioa_Data:ulong;
  ioa_Length:ulong;
  ioa_Period:uword;
  ioa_Volume:uword;
  ioa_Cycles:uword;
  ioa_WriteMsg:Message;
;

