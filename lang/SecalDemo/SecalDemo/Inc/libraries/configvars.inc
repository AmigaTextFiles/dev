include "inc/exec/types.inc";
include "inc/exec/nodes.inc";
include "inc/libraries/configregs.inc";

struct ConfigDev is
  cd_Node:Node;
  cd_Flags:ubyte;
  cd_Pad:ubyte;
  cd_Rom:ExpansionRom;
  cd_BoardAddr:ulong;
  cd_BoardSize:ulong;
  cd_SlotAddr:uword;
  cd_SlotSize:uword;
  cd_Driver:ulong;
  cd_NextCD:ulong;
  cd_Unused[4]:ulong;
;

def CDB_SHUTUP = 0;
def CDB_CONFIGME = 1;
def CDB_BADMEMORY = 2;
def CDB_PROCESSED = 3;

def CDF_SHUTUP = $01;
def CDF_CONFIGME = $02;
def CDF_BADMEMORY = $04;
def CDF_PROCESSED = $08;

struct CurrentBinding is
  cb_ConfigDev:ulong;
  cb_FileName:ulong;
  cb_ProductString:ulong;
  cb_ToolTypes:ulong;
;

