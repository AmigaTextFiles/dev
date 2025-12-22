include "inc/exec/types.inc";
include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";
include "inc/exec/ports.inc";
include "inc/exec/libraries.inc";

struct NexxStr is
  ns_Ivalue:long;
  ns_Length:uword;
  ns_Flags:ubyte;
  ns_Hash:ubyte;
  ns_Buff[8]:byte;
;

def NXADDLEN = 9;

def NSB_KEEP = 0;
def NSB_STRING = 1;
def NSB_NOTNUM = 2;
def NSB_NUMBER = 3;
def NSB_BINARY = 4;
def NSB_FLOAT = 5;
def NSB_EXT = 6;
def NSB_SOURCE = 7;

def NSF_KEEP = (1<<NSB_KEEP);
def NSF_STRING = (1<<NSB_STRING);
def NSF_NOTNUM = (1<<NSB_NOTNUM);
def NSF_NUMBER = (1<<NSB_NUMBER);
def NSF_BINARY = (1<<NSB_BINARY);
def NSF_FLOAT = (1<<NSB_FLOAT);
def NSF_EXT = (1<<NSB_EXT);
def NSF_SOURCE = (1<<NSB_SOURCE);

def NSF_INTNUM = (NSF_NUMBER|NSF_BINARY|NSF_STRING);
def NSF_DPNUM = (NSF_NUMBER|NSF_FLOAT);
def NSF_ALPHA = (NSF_NOTNUM|NSF_STRING);
def NSF_OWNED = (NSF_SOURCE|NSF_EXT|NSF_KEEP);
def KEEPSTR = (NSF_STRING|NSF_SOURCE|NSF_NOTNUM);
def KEEPNUM = (NSF_STRING|NSF_SOURCE|NSF_NUMBER|NSF_BINARY);

struct RexxArg is
  ra_Size:long;
  ra_Length:uword;
  ra_Flags:ubyte;
  ra_Hash:ubyte;
  ra_Buff[8]:byte;
;

struct RexxMsg is
  rm_Node:Message;
  rm_TaskBlock:ulong;
  rm_LibBase:ulong;
  rm_Action:long;
  rm_Result1:long;
  rm_Result2:long;
  rm_Args[16]:ulong;
  rm_PassPort:ulong;
  rm_CommAddr:ulong;
  rm_FileExt:ulong;
  rm_Stdin:long;
  rm_Stdout:long;
  rm_avail:long;
;

def ARG0(rmp) = (rmp->rm_Args[0]);
def ARG1(rmp) = (rmp->rm_Args[1]);
def ARG2(rmp) = (rmp->rm_Args[2]);

def MAXRMARG = 15;

def RXCOMM = $01000000;
def RXFUNC = $02000000;
def RXCLOSE = $03000000;
def RXQUERY = $04000000;
def RXADDFH = $07000000;
def RXADDLIB = $08000000;
def RXREMLIB = $09000000;
def RXADDCON = $0a000000;
def RXREMCON = $0b000000;
def RXTCOPN = $0c000000;
def RXTCCLS = $0d000000;

def RXFB_NOIO = 16;
def RXFB_RESULT = 17;
def RXFB_STRING = 18;
def RXFB_TOKEN = 19;
def RXFB_NONRET = 20;

def RXFF_NOIO = (1<<RXFB_NOIO);
def RXFF_RESULT = (1<<RXFB_RESULT);
def RXFF_STRING = (1<<RXFB_STRING);
def RXFF_TOKEN = (1<<RXFB_TOKEN);
def RXFF_NONRET = (1<<RXFB_NONRET);

def RXCODEMASK = $ff000000;
def RXARGMASK = $0000000f;

struct RexxRsrc is
  rr_Node:Node;
  rr_Func:word;
  rr_Base:ulong;
  rr_Size:long;
  rr_Arg1:long;
  rr_Arg2:long;
;

def RRT_ANY = 0;
def RRT_LIB = 1;
def RRT_PORT = 2;
def RRT_FILE = 3;
def RRT_HOST = 4;
def RRT_CLIP = 5;

def GLOBALSZ = 200;

struct RexxTask is
  rt_Global[200]:byte;
  rt_MsgPort:MsgPort;
  rt_Flags:ubyte;
  rt_SigBit:byte;
  rt_ClientID:ulong;
  rt_MsgPkt:ulong;
  rt_TaskID:ulong;
  rt_RexxPort:ulong;
  rt_ErrTrap:ulong;
  rt_StackPtr:ulong;
  rt_Header1:List;
  rt_Header2:List;
  rt_Header3:List;
  rt_Header4:List;
  rt_Header5:List;
;

def RTFB_TRACE = 0;
def RTFB_HALT = 1;
def RTFB_SUSP = 2;
def RTFB_TCUSE = 3;
def RTFB_WAIT = 6;
def RTFB_CLOSE = 7;

def MEMQUANT = 16;
def MEMMASK = $fffffff0;

def MEMQUICK = (1<<0);
def MEMCLEAR = (1<<16);

struct SrcNode is
  sn_Succ:ulong;
  sn_Pred:ulong;
  sn_Ptr:ulong;
  sn_Size:long;
;

