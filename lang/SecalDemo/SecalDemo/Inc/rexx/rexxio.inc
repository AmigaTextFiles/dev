include "inc/rexx/storage.inc";

def RXBUFFSZ = 204;

struct IoBuff is
  iobNode:RexxRsrc;
  iobRpt:ulong;
  iobRct:long;
  iobDFH:long;
  iobLock:ulong;
  iobBct:long;
  iobArea[204]:byte;
;

def RXIO_EXIST = -1;
def RXIO_STRF = 0;
def RXIO_READ = 1;
def RXIO_WRITE = 2;
def RXIO_APPEND = 3;

def RXIO_BEGIN = -1;
def RXIO_CURR = 0;
def RXIO_END = 1;

struct RexxMsgPort is
  rmp_Node:RexxRsrc;
  rmp_Port:MsgPort;
  rmp_ReplyList:List;
;

def DT_DEV = 0;
def DT_DIR = 1;
def DT_VOL = 2;

def ACTION_STACK = 2002;
def ACTION_QUEUE = 2003;

