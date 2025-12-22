include "inc/exec/types.inc";
include "inc/exec/nodes.inc";

struct NVInfo is
  nvi_MaxStorage:ulong;
  nvi_FreeStorage:ulong;
;

struct NVEntry is
  nve_Node:MinNode;
  nve_Name:ulong;
  nve_Size:ulong;
  nve_Protection:ulong;
;

def NVEB_DELETE = 0;
def NVEB_APPNAME = 31;

def NVEF_DELETE = (1<<NVEB_DELETE);
def NVEF_APPNAME = (1<<NVEB_APPNAME);

def NVERR_BADNAME = 1;
def NVERR_WRITEPROT = 2;
def NVERR_FAIL = 3;
def NVERR_FATAL = 4;

def SizeNVData(DataPtr) = ((DataPtr[-1])-4);

