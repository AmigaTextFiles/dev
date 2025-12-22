include "inc/exec/types.inc";
include "inc/exec/nodes.inc";

def CD_RESET = 1;
def CD_READ = 2;
def CD_WRITE = 3;
def CD_UPDATE = 4;
def CD_CLEAR = 5;
def CD_STOP = 6;
def CD_START = 7;
def CD_FLUSH = 8;
def CD_MOTOR = 9;
def CD_SEEK = 10;
def CD_FORMAT = 11;
def CD_REMOVE = 12;
def CD_CHANGENUM = 13;
def CD_CHANGESTATE = 14;
def CD_PROTSTATUS = 15;

def CD_GETDRIVETYPE = 18;
def CD_GETNUMTRACKS = 19;
def CD_ADDCHANGEINT = 20;
def CD_REMCHANGEINT = 21;
def CD_GETGEOMETRY = 22;
def CD_EJECT = 23;

def CD_INFO = 32;
def CD_CONFIG = 33;
def CD_TOCMSF = 34;
def CD_TOCLSN = 35;

def CD_READXL = 36;

def CD_PLAYTRACK = 37;
def CD_PLAYMSF = 38;
def CD_PLAYLSN = 39;
def CD_PAUSE = 40;
def CD_SEARCH = 41;

def CD_QCODEMSF = 42;
def CD_QCODELSN = 43;
def CD_ATTENUATE = 44;

def CD_ADDFRAMEINT = 45;
def CD_REMFRAMEINT = 46;

def CDERR_OPENFAIL = (-1);
def CDERR_ABORTED = (-2);
def CDERR_NOCMD = (-3);
def CDERR_BADLENGTH = (-4);
def CDERR_BADADDRESS = (-5);
def CDERR_UNITBUSY = (-6);
def CDERR_SELFTEST = (-7);

def CDERR_NotSpecified = 20;
def CDERR_NoSecHdr = 21;
def CDERR_BadSecPreamble = 22;
def CDERR_BadSecID = 23;
def CDERR_BadHdrSum = 24;
def CDERR_BadSecSum = 25;
def CDERR_TooFewSecs = 26;
def CDERR_BadSecHdr = 27;
def CDERR_WriteProt = 28;
def CDERR_NoDisk = 29;
def CDERR_SeekError = 30;
def CDERR_NoMem = 31;
def CDERR_BadUnitNum = 32;
def CDERR_BadDriveType = 33;
def CDERR_DriveInUse = 34;
def CDERR_PostReset = 35;
def CDERR_BadDataType = 36;
def CDERR_InvalidState = 37;

def CDERR_Phase = 42;
def CDERR_NoBoard = 50;

def TAGCD_PLAYSPEED = $0001;
def TAGCD_READSPEED = $0002;
def TAGCD_READXLSPEED = $0003;
def TAGCD_SECTORSIZE = $0004;
def TAGCD_XLECC = $0005;
def TAGCD_EJECTRESET = $0006;

struct CDInfo is
  PlaySpeed:uword;
  ReadSpeed:uword;
  ReadXLSpeed:uword;
  SectorSize:uword;
  XLECC:uword;
  EjectReset:uword;
  Reserved1[4]:uword;
  MaxSpeed:uword;
  AudioPrecision:uword;
  Status:uword;
  Reserved2[4]:uword;
;

def CDSTSB_CLOSED = 0;
def CDSTSB_DISK = 1;
def CDSTSB_SPIN = 2;
def CDSTSB_TOC = 3;
def CDSTSB_CDROM = 4;
def CDSTSB_PLAYING = 5;
def CDSTSB_PAUSED = 6;
def CDSTSB_SEARCH = 7;
def CDSTSB_DIRECTION = 8;

def CDSTSF_CLOSED = $0001;
def CDSTSF_DISK = $0002;
def CDSTSF_SPIN = $0004;
def CDSTSF_TOC = $0008;
def CDSTSF_CDROM = $0010;
def CDSTSF_PLAYING = $0020;
def CDSTSF_PAUSED = $0040;
def CDSTSF_SEARCH = $0080;
def CDSTSF_DIRECTION = $0100;

def CDMODE_NORMAL = 0;
def CDMODE_FFWD = 1;
def CDMODE_FREV = 2;

struct RMSF is
  Reserved:ubyte;
  Minute:ubyte;
  Second:ubyte;
  Frame:ubyte;
;

union LSNMSF is
  MSF:RMSF;
  LSN:ulong;
;

struct CDXL is
  Node:MinNode;
  Buffer:ulong;
  Length:long;
  Actual:long;
  IntData:ulong;
  IntCode:ulong;
;

struct TOCSummary is
  FirstTrack:ubyte;
  LastTrack:ubyte;
  LeadOut:LSNMSF;
;

struct TOCEntry is
  CtlAdr:ubyte;
  Track:ubyte;
  Position:LSNMSF;
;

union CDTOC is
  Summary:TOCSummary;
  Entry:TOCEntry;
;

struct QCode is
  CtlAdr:ubyte;
  Track:ubyte;
  Index:ubyte;
  Zero:ubyte;
  TrackPosition:LSNMSF;
  DiskPosition:LSNMSF;
;

def CTLADR_CTLMASK = $f0;

def CTL_CTLMASK = $d0;

def CTL_2AUD = $00;
def CTL_2AUDEMPH = $10;
def CTL_4AUD = $80;
def CTL_4AUDEMPH = $90;
def CTL_DATA = $40;

def CTL_COPYMASK = $20;

def CTL_COPY = $20;

def CTLADR_ADRMASK = $0f;

def ADR_POSITION = $01;
def ADR_UPC = $02;
def ADR_ISRC = $03;
def ADR_HYBRID = $05;

