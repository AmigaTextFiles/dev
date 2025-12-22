include "inc/exec/types.inc";

struct RigidDiskBlock is
  rdb_ID:ulong;
  rdb_SummedLongs:ulong;
  rdb_ChkSum:long;
  rdb_HostID:ulong;
  rdb_BlockBytes:ulong;
  rdb_Flags:ulong;
  rdb_BadBlockList:ulong;
  rdb_PartitionList:ulong;
  rdb_FileSysHeaderList:ulong;
  rdb_DriveInit:ulong;
  rdb_Reserved1[6]:ulong;
  rdb_Cylinders:ulong;
  rdb_Sectors:ulong;
  rdb_Heads:ulong;
  rdb_Interleave:ulong;
  rdb_Park:ulong;
  rdb_Reserved2[3]:ulong;
  rdb_WritePreComp:ulong;
  rdb_ReducedWrite:ulong;
  rdb_StepRate:ulong;
  rdb_Reserved3[5]:ulong;
  rdb_RDBBlocksLo:ulong;
  rdb_RDBBlocksHi:ulong;
  rdb_LoCylinder:ulong;
  rdb_HiCylinder:ulong;
  rdb_CylBlocks:ulong;
  rdb_AutoParkSeconds:ulong;
  rdb_HighRDSKBlock:ulong;
  rdb_Reserved4:ulong;
  rdb_DiskVendor[8]:byte;
  rdb_DiskProduct[16]:byte;
  rdb_DiskRevision[4]:byte;
  rdb_ControllerVendor[8]:byte;
  rdb_ControllerProduct[16]:byte;
  rdb_ControllerRevision[4]:byte;
  rdb_Reserved5[10]:ulong;
;

def IDNAME_RIGIDDISK = $5244534b;

def RDB_LOCATION_LIMIT = 16;

def RDBFB_LAST = 0;
def RDBFF_LAST = $01;
def RDBFB_LASTLUN = 1;
def RDBFF_LASTLUN = $02;
def RDBFB_LASTTID = 2;
def RDBFF_LASTTID = $04;
def RDBFB_NORESELECT = 3;
def RDBFF_NORESELECT = $08;
def RDBFB_DISKID = 4;
def RDBFF_DISKID = $10;
def RDBFB_CTRLRID = 5;
def RDBFF_CTRLRID = $20;
def RDBFB_SYNCH = 6;
def RDBFF_SYNCH = $40;

struct BadBlockEntry is
  bbe_BadBlock:ulong;
  bbe_GoodBlock:ulong;
;

struct BadBlockBlock is
  bbb_ID:ulong;
  bbb_SummedLongs:ulong;
  bbb_ChkSum:long;
  bbb_HostID:ulong;
  bbb_Next:ulong;
  bbb_Reserved:ulong;
  bbb_BlockPairs[61]:BadBlockEntry;
;

def IDNAME_BADBLOCK = $42414442;

struct PartitionBlock is
  pb_ID:ulong;
  pb_SummedLongs:ulong;
  pb_ChkSum:long;
  pb_HostID:ulong;
  pb_Next:ulong;
  pb_Flags:ulong;
  pb_Reserved1[2]:ulong;
  pb_DevFlags:ulong;
  pb_DriveName[32]:ubyte;
  pb_Reserved2[15]:ulong;
  pb_Environment[17]:ulong;
  pb_EReserved[15]:ulong;
;

def IDNAME_PARTITION = $50415254;

def PBFB_BOOTABLE = 0;
def PBFF_BOOTABLE = 1;
def PBFB_NOMOUNT = 1;
def PBFF_NOMOUNT = 2;

struct FileSysHeaderBlock is
  fhb_ID:ulong;
  fhb_SummedLongs:ulong;
  fhb_ChkSum:long;
  fhb_HostID:ulong;
  fhb_Next:ulong;
  fhb_Flags:ulong;
  fhb_Reserved1[2]:ulong;
  fhb_DosType:ulong;
  fhb_Version:ulong;
  fhb_PatchFlags:ulong;
  fhb_Type:ulong;
  fhb_Task:ulong;
  fhb_Lock:ulong;
  fhb_Handler:ulong;
  fhb_StackSize:ulong;
  fhb_Priority:long;
  fhb_Startup:long;
  fhb_SegListBlocks:long;
  fhb_GlobalVec:long;
  fhb_Reserved2[23]:ulong;
  fhb_Reserved3[21]:ulong;
;

def IDNAME_FILESYSHEADER = $46534844;

struct LoadSegBlock is
  lsb_ID:ulong;
  lsb_SummedLongs:ulong;
  lsb_ChkSum:long;
  lsb_HostID:ulong;
  lsb_Next:ulong;
  lsb_LoadData[123]:ulong;
;

def IDNAME_LOADSEG = $4c534547;

