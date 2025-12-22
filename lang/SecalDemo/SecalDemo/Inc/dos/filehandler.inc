include "inc/exec/ports.inc";
include "inc/dos/dos.inc";

struct DosEnvec is
  de_TableSize:ulong;
  de_SizeBlock:ulong;
  de_SecOrg:ulong;
  de_Surfaces:ulong;
  de_SectorPerBlock:ulong;
  de_BlocksPerTrack:ulong;
  de_Reserved:ulong;
  de_PreAlloc:ulong;
  de_Interleave:ulong;
  de_LowCyl:ulong;
  de_HighCyl:ulong;
  de_NumBuffers:ulong;
  de_BufMemType:ulong;
  de_MaxTransfer:ulong;
  de_Mask:ulong;
  de_BootPri:long;
  de_DosType:ulong;
  de_Baud:ulong;
  de_Control:ulong;
  de_BootBlocks:ulong;
;

def DE_TABLESIZE = 0;
def DE_SIZEBLOCK = 1;
def DE_SECORG = 2;
def DE_NUMHEADS = 3;
def DE_SECSPERBLK = 4;
def DE_BLKSPERTRACK = 5;
def DE_RESERVEDBLKS = 6;
def DE_PREFAC = 7;
def DE_INTERLEAVE = 8;
def DE_LOWCYL = 9;
def DE_UPPERCYL = 10;
def DE_NUMBUFFERS = 11;
def DE_MEMBUFTYPE = 12;
def DE_BUFMEMTYPE = 12;
def DE_MAXTRANSFER = 13;
def DE_MASK = 14;
def DE_BOOTPRI = 15;
def DE_DOSTYPE = 16;
def DE_BAUD = 17;
def DE_CONTROL = 18;
def DE_BOOTBLOCKS = 19;

struct FileSysStartupMsg is
  fssm_Unit:ulong;
  fssm_Device:long;
  fssm_Environ:long;
  fssm_Flags:ulong;
;

struct DeviceNode is
  dn_Next:long;
  dn_Type:ulong;
  dn_Task:ulong;
  dn_Lock:long;
  dn_Handler:long;
  dn_StackSize:ulong;
  dn_Priority:long;
  dn_Startup:long;
  dn_SegList:long;
  dn_GlobalVec:long;
  dn_Name:long;
;

