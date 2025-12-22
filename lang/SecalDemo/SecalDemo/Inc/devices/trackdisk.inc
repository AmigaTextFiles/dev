include "inc/exec/io.inc";
include "inc/exec/devices.inc";

def NUMCYLS = 80;
def MAXCYLS = (NUMCYLS+20);
def NUMHEADS = 2;
def NUMTRACKS = (NUMCYLS*NUMHEADS);

def NUMSECS = 11;
def NUMUNITS = 4;

def TD_SECTOR = 512;
def TD_SECSHIFT = 9;

def TD_NAME = "trackdisk.device";

def TDF_EXTCOM = (1<<15);

def TD_MOTOR = (CMD_NONSTD+0);
def TD_SEEK = (CMD_NONSTD+1);
def TD_FORMAT = (CMD_NONSTD+2);
def TD_REMOVE = (CMD_NONSTD+3);
def TD_CHANGENUM = (CMD_NONSTD+4);
def TD_CHANGESTATE = (CMD_NONSTD+5);
def TD_PROTSTATUS = (CMD_NONSTD+6);
def TD_RAWREAD = (CMD_NONSTD+7);
def TD_RAWWRITE = (CMD_NONSTD+8);
def TD_GETDRIVETYPE = (CMD_NONSTD+9);
def TD_GETNUMTRACKS = (CMD_NONSTD+10);
def TD_ADDCHANGEINT = (CMD_NONSTD+11);
def TD_REMCHANGEINT = (CMD_NONSTD+12);
def TD_GETGEOMETRY = (CMD_NONSTD+13);
def TD_EJECT = (CMD_NONSTD+14);
def TD_LASTCOMM = (CMD_NONSTD+15);

def ETD_WRITE = (CMD_WRITE|TDF_EXTCOM);
def ETD_READ = (CMD_READ|TDF_EXTCOM);
def ETD_MOTOR = (TD_MOTOR|TDF_EXTCOM);
def ETD_SEEK = (TD_SEEK|TDF_EXTCOM);
def ETD_FORMAT = (TD_FORMAT|TDF_EXTCOM);
def ETD_UPDATE = (CMD_UPDATE|TDF_EXTCOM);
def ETD_CLEAR = (CMD_CLEAR|TDF_EXTCOM);
def ETD_RAWREAD = (TD_RAWREAD|TDF_EXTCOM);
def ETD_RAWWRITE = (TD_RAWWRITE|TDF_EXTCOM);

struct IOExtTD is
  iotd_Req:IOStdReq;
  iotd_Count:ulong;
  iotd_SecLabel:ulong;
;

struct DriveGeometry is
  dg_SectorSize:ulong;
  dg_TotalSectors:ulong;
  dg_Cylinders:ulong;
  dg_CylSectors:ulong;
  dg_Heads:ulong;
  dg_TrackSectors:ulong;
  dg_BufMemType:ulong;
  dg_DeviceType:ubyte;
  dg_Flags:ubyte;
  dg_Reserved:uword;
;

def DG_DIRECT_ACCESS = 0;
def DG_SEQUENTIAL_ACCESS = 1;
def DG_PRINTER = 2;
def DG_PROCESSOR = 3;
def DG_WORM = 4;
def DG_CDROM = 5;
def DG_SCANNER = 6;
def DG_OPTICAL_DISK = 7;
def DG_MEDIUM_CHANGER = 8;
def DG_COMMUNICATION = 9;
def DG_UNKNOWN = 31;

def DGB_REMOVABLE = 0;
def DGF_REMOVABLE = 1;

def IOTDB_INDEXSYNC = 4;
def IOTDF_INDEXSYNC = (1<<4);

def IOTDB_WORDSYNC = 5;
def IOTDF_WORDSYNC = (1<<5);

def TD_LABELSIZE = 16;

def TDB_ALLOW_NON_3_5 = 0;
def TDF_ALLOW_NON_3_5 = (1<<0);

def DRIVE3_5 = 1;
def DRIVE5_25 = 2;
def DRIVE3_5_150RPM = 3;

def TDERR_NotSpecified = 20;
def TDERR_NoSecHdr = 21;
def TDERR_BadSecPreamble = 22;
def TDERR_BadSecID = 23;
def TDERR_BadHdrSum = 24;
def TDERR_BadSecSum = 25;
def TDERR_TooFewSecs = 26;
def TDERR_BadSecHdr = 27;
def TDERR_WriteProt = 28;
def TDERR_DiskChanged = 29;
def TDERR_SeekError = 30;
def TDERR_NoMem = 31;
def TDERR_BadUnitNum = 32;
def TDERR_BadDriveType = 33;
def TDERR_DriveInUse = 34;
def TDERR_PostReset = 35;

struct TDU_PublicUnit is
  tdu_Unit:Unit;
  tdu_Comp01Track:uword;
  tdu_Comp10Track:uword;
  tdu_Comp11Track:uword;
  tdu_StepDelay:ulong;
  tdu_SettleDelay:ulong;
  tdu_RetryCnt:ubyte;
  tdu_PubFlags:ubyte;
  tdu_CurrTrk:uword;
  tdu_CalibrateDelay:ulong;
  tdu_Counter:ulong;
;

def TDPB_NOCLICK = 0;
def TDPF_NOCLICK = (1<<0);

