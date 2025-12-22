include "inc/exec/types.inc";
include "inc/exec/lists.inc";
include "inc/exec/ports.inc";
include "inc/devices/clipboard.inc";

struct IFFHandle is
  iff_Stream:ulong;
  iff_Flags:ulong;
  iff_Depth:long;
;

def IFFF_READ = 0;
def IFFF_WRITE = 1;
def IFFF_RWBITS = (IFFF_READ|IFFF_WRITE);
def IFFF_FSEEK = (1<<1);
def IFFF_RSEEK = (1<<2);
def IFFF_RESERVED = $ffff0000;

struct IFFStreamCmd is
  sc_Command:long;
  sc_Buf:ulong;
  sc_NBytes:long;
;

struct ContextNode is
  cn_Node:MinNode;
  cn_ID:long;
  cn_Type:long;
  cn_Size:long;
  cn_Scan:long;
;

struct LocalContextItem is
  lci_Node:MinNode;
  lci_ID:ulong;
  lci_Type:ulong;
  lci_Ident:ulong;
;

struct StoredProperty is
  sp_Size:long;
  sp_Data:ulong;
;

struct CollectionItem is
  ci_Next:ulong;
  ci_Size:long;
  ci_Data:ulong;
;

struct ClipboardHandle is
  cbh_Req:IOClipReq;
  cbh_CBport:MsgPort;
  cbh_SatisfyPort:MsgPort;
;

def IFFERR_EOF = -1;
def IFFERR_EOC = -2;
def IFFERR_NOSCOPE = -3;
def IFFERR_NOMEM = -4;
def IFFERR_READ = -5;
def IFFERR_WRITE = -6;
def IFFERR_SEEK = -7;
def IFFERR_MANGLED = -8;
def IFFERR_SYNTAX = -9;
def IFFERR_NOTIFF = -10;
def IFFERR_NOHOOK = -11;
def IFF_RETURN2CLIENT = -12;

def IFFPARSE_SCAN = 0;
def IFFPARSE_STEP = 1;
def IFFPARSE_RAWSTEP = 2;

def IFFSLI_ROOT = 1;
def IFFSLI_TOP = 2;
def IFFSLI_PROP = 3;

def IFFSIZE_UNKNOWN = -1;

def IFFCMD_INIT = 0;
def IFFCMD_CLEANUP = 1;
def IFFCMD_READ = 2;
def IFFCMD_WRITE = 3;
def IFFCMD_SEEK = 4;
def IFFCMD_ENTRY = 5;
def IFFCMD_EXIT = 6;
def IFFCMD_PURGELCI = 7;

