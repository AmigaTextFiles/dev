include "inc/exec/types.inc";
include "inc/exec/nodes.inc";

struct CSource is
  CS_Buffer:ulong;
  CS_Length:long;
  CS_CurChr:long;
;

struct RDArgs is
  RDA_Source:CSource;
  RDA_DAList:long;
  RDA_Buffer:ulong;
  RDA_BufSiz:long;
  RDA_ExtHelp:ulong;
  RDA_Flags:long;
;

def RDAB_STDIN = 0;
def RDAF_STDIN = 1;
def RDAB_NOALLOC = 1;
def RDAF_NOALLOC = 2;
def RDAB_NOPROMPT = 2;
def RDAF_NOPROMPT = 4;

def MAX_TEMPLATE_ITEMS = 100;

def MAX_MULTIARGS = 128;

