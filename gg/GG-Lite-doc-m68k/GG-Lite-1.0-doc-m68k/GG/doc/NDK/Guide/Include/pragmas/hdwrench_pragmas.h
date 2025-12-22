@DATABASE "gg:doc/NDK/Guide/Include/pragmas/hdwrench_pragmas.h"
@MASTER   "gg:os-include/pragmas/hdwrench_pragmas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:31
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "pragmas/hdwrench_pragmas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"pragmas/hdwrench_pragmas.h" LINK File}

@ENDNODE
@NODE File "pragmas/hdwrench_pragmas.h"
#pragma libcall HDWBase HDWOpenDevice 1e 0802
#pragma libcall HDWBase HDWCloseDevice 24 0
#pragma libcall HDWBase RawRead 2a 0802
#pragma libcall HDWBase RawWrite 30 801
#pragma libcall HDWBase WriteBlock 36 801
#pragma libcall HDWBase ReadRDBs 3c 0
#pragma libcall HDWBase WriteRDBs 42 0
#pragma libcall HDWBase QueryReady 48 801
#pragma libcall HDWBase QueryInquiry 4e 9802
#pragma libcall HDWBase QueryModeSense 54 981004
#pragma libcall HDWBase QueryFindValid 5a A2109806
#pragma libcall HDWBase QueryCapacity 60 9802
#pragma libcall HDWBase ReadMountfile 66 98003
#pragma libcall HDWBase ReadRDBStructs 6c 0802
#pragma libcall HDWBase WriteMountfile 72 09803
#pragma libcall HDWBase WriteRDBStructs 78 801
#pragma libcall HDWBase InMemMountfile 7e 98003
#pragma libcall HDWBase InMemRDBStructs 84 10803
#pragma libcall HDWBase OutMemMountfile 8a 109804
#pragma libcall HDWBase OutMemRDBStructs 90 09803
#pragma libcall HDWBase FindDiskName 96 801
#pragma libcall HDWBase FindControllerID 9c 9802
#pragma libcall HDWBase FindLastSector a2 0
#pragma libcall HDWBase FindDefaults a8 8002
#pragma libcall HDWBase LowlevelFormat ae 801
#pragma libcall HDWBase VerifyDrive b4 801
@ENDNODE
