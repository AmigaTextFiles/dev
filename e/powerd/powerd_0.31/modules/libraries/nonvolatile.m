MODULE 'exec/nodes'

OBJECT NVInfo
 MaxStorage:ULONG,
 FreeStorage:ULONG

OBJECT NVEntry
 Node:MinNode,
 Name:PTR TO UBYTE,
 Size:ULONG,
 Protection:ULONG

FLAG NVE_DELETE,
 NVE_APPNAME=31

CONST NVERR_BADNAME=1,
 NVERR_WRITEPROT=2,
 NVERR_FAIL=3,
 NVERR_FATAL=4

#define SizeNVData(DataPtr) ((DataPtr[-1])-4)
