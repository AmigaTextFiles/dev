  {      nonvolatile.library interface structures and defintions. }


{$I "Include:Exec/Nodes.i"}
{$I "Include:Exec/Lists.i"}

{***************************************************************************}

Type
 NVInfo = Record
    nvi_MaxStorage,
    nvi_FreeStorage : Integer;
 end;
 NVInfoPtr = ^NVInfo;

{***************************************************************************}


 NVEntry = Record
    nve_Node        : MinNode;
    nve_Name        : String;
    nve_Size,
    nve_Protection  : Integer;
 end;
 NVEntryPtr = ^NVEntry;

const
{ bit definitions for mask in SetNVProtection().  Also used for
 * NVEntry.nve_Protection.
 }
 NVEB_DELETE  = 0 ;
 NVEB_APPNAME = 31;

 NVEF_DELETE  = 1;
 NVEF_APPNAME = -2147483648;


{***************************************************************************}


{ errors from StoreNV() }
 NVERR_BADNAME   = 1;
 NVERR_WRITEPROT = 2;
 NVERR_FAIL      = 3;
 NVERR_FATAL     = 4;



{ --- functions in V40 or higher (Release 3.1) --- }

FUNCTION CopyNV(appName, itemName : String; killRequesters : Integer) : Address;
    External;

PROCEDURE FreeNVData(Data : Address);
    External;

FUNCTION StoreNV(appName, itemName : String; Data : Address; length,
                 killrequesters : Integer) : WORD;
    External;

FUNCTION DeleteNV(appName, itemName : String; KillRequester : Integer) : Boolean;
    External;

FUNCTION GetNVInfo(KillRequesters : Integer) : NVInfoPtr;
    External;

FUNCTION GetNVList(appName : String; KillRequesters : Integer) : MinListPtr;
    External;

FUNCTION SetNVProtection(appName, itemName : String; mask, KillRequesters : Integer) : Boolean;
    External;



