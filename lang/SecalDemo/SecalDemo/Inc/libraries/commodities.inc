include "inc/exec/types.inc";
include "inc/exec/ports.inc";

def CxFilter(d) = CreateCxObj(CX_FILTER,d,0);
def CxSender(port,id) = CreateCxObj(CX_SEND,port,id);
def CxSignal(task,sig) = CreateCxObj(CX_SIGNAL,task,sig);
def CxTranslate(ie) = CreateCxObj(CX_TRANSLATE,ie,0);
def CxDebug(id) = CreateCxObj(CX_DEBUG,id,0);
def CxCustom(action,id) = CreateCxObj(CX_CUSTOM,action,id);

struct NewBroker is
  nb_Version:byte;
  nb_Name:ulong;
  nb_Title:ulong;
  nb_Descr:ulong;
  nb_Unique:word;
  nb_Flags:word;
  nb_Pri:byte;
  nb_Port:ulong;
  nb_ReservedChannel:word;
;

def NB_VERSION = 5;

def CBD_NAMELEN = 24;
def CBD_TITLELEN = 40;
def CBD_DESCRLEN = 40;

def NBU_DUPLICATE = 0;
def NBU_UNIQUE = 1;
def NBU_NOTIFY = 2;

def COF_SHOW_HIDE = 4;

def CX_INVALID = 0;
def CX_FILTER = 1;
def CX_TYPEFILTER = 2;
def CX_SEND = 3;
def CX_SIGNAL = 4;
def CX_TRANSLATE = 5;
def CX_BROKER = 6;
def CX_DEBUG = 7;
def CX_CUSTOM = 8;
def CX_ZERO = 9;

def CXM_IEVENT = (1<<5);
def CXM_COMMAND = (1<<6);

def CXCMD_DISABLE = (15);
def CXCMD_ENABLE = (17);
def CXCMD_APPEAR = (19);
def CXCMD_DISAPPEAR = (21);
def CXCMD_KILL = (23);
def CXCMD_LIST_CHG = (27);
def CXCMD_UNIQUE = (25);

struct IX is
  ix_Version:ubyte;
  ix_Class:ubyte;
  ix_Code:uword;
  ix_CodeMask:uword;
  ix_Qualifier:uword;
  ix_QualMask:uword;
  ix_QualSame:uword;
;

def IX_VERSION = 2;

def IXSYM_SHIFT = 1;
def IXSYM_CAPS = 2;
def IXSYM_ALT = 4;

def IXSYM_SHIFTMASK = (IEQUALIFIER_LSHIFT|IEQUALIFIER_RSHIFT);
def IXSYM_CAPSMASK = (IXSYM_SHIFTMASK|IEQUALIFIER_CAPSLOCK);
def IXSYM_ALTMASK = (IEQUALIFIER_LALT|IEQUALIFIER_RALT);

def IX_NORMALQUALS = $7fff;

def CBERR_OK = 0;
def CBERR_SYSERR = 1;
def CBERR_DUP = 2;
def CBERR_VERSION = 3;

def COERR_ISNULL = 1;
def COERR_NULLATTACH = 2;
def COERR_BADFILTER = 4;
def COERR_BADTYPE = 8;

