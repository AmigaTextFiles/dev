include "inc/exec/types.inc";

def HD_SCSICMD = 28;

struct SCSICmd is
  scsi_Data:ulong;
  scsi_Length:ulong;
  scsi_Actual:ulong;
  scsi_Command:ulong;
  scsi_CmdLength:uword;
  scsi_CmdActual:uword;
  scsi_Flags:ubyte;
  scsi_Status:ubyte;
  scsi_SenseData:ulong;
  scsi_SenseLength:uword;
  scsi_SenseActual:uword;
;

def SCSIF_WRITE = 0;
def SCSIF_READ = 1;
def SCSIB_READ_WRITE = 0;

def SCSIF_NOSENSE = 0;
def SCSIF_AUTOSENSE = 2;
def SCSIF_OLDAUTOSENSE = 6;
def SCSIB_AUTOSENSE = 1;
def SCSIB_OLDAUTOSENSE = 2;

def HFERR_SelfUnit = 40;
def HFERR_DMA = 41;
def HFERR_Phase = 42;
def HFERR_Parity = 43;
def HFERR_SelTimeout = 44;
def HFERR_BadStatus = 45;

def HFERR_NoBoard = 50;

