include "inc/exec/types.inc";
include "inc/exec/nodes.inc";
include "inc/exec/interrupts.inc";

def CARDRESNAME = "card.resource";

struct CardHandle is
  cah_CardNode:Node;
  cah_CardRemoved:ulong;
  cah_CardInserted:ulong;
  cah_CardStatus:ulong;
  cah_CardFlags:ubyte;
;

struct DeviceTData is
  dtd_DTsize:ulong;
  dtd_DTspeed:ulong;
  dtd_DTtype:ubyte;
  dtd_DTflags:ubyte;
;

struct CardMemoryMap is
  cmm_CommonMemory:ulong;
  cmm_AttributeMemory:ulong;
  cmm_IOMemory:ulong;
  cmm_CommonMemSize:ulong;
  cmm_AttributeMemSize:ulong;
  cmm_IOMemSize:ulong;

;

def CARDB_RESETREMOVE = 0;
def CARDF_RESETREMOVE = (1<<CARDB_RESETREMOVE);

def CARDB_IFAVAILABLE = 1;
def CARDF_IFAVAILABLE = (1<<CARDB_IFAVAILABLE);

def CARDB_DELAYOWNERSHIP = 2;
def CARDF_DELAYOWNERSHIP = (1<<CARDB_DELAYOWNERSHIP);

def CARDB_POSTSTATUS = 3;
def CARDF_POSTSTATUS = (1<<CARDB_POSTSTATUS);

def CARDB_REMOVEHANDLE = 0;
def CARDF_REMOVEHANDLE = (1<<CARDB_REMOVEHANDLE);

def CARD_STATUSB_CCDET = 6;
def CARD_STATUSF_CCDET = (1<<CARD_STATUSB_CCDET);

def CARD_STATUSB_BVD1 = 5;
def CARD_STATUSF_BVD1 = (1<<CARD_STATUSB_BVD1);

def CARD_STATUSB_SC = 5;
def CARD_STATUSF_SC = (1<<CARD_STATUSB_SC);

def CARD_STATUSB_BVD2 = 4;
def CARD_STATUSF_BVD2 = (1<<CARD_STATUSB_BVD2);

def CARD_STATUSB_DA = 4;
def CARD_STATUSF_DA = (1<<CARD_STATUSB_DA);

def CARD_STATUSB_WR = 3;
def CARD_STATUSF_WR = (1<<CARD_STATUSB_WR);

def CARD_STATUSB_BSY = 2;
def CARD_STATUSF_BSY = (1<<CARD_STATUSB_BSY);

def CARD_STATUSB_IRQ = 2;
def CARD_STATUSF_IRQ = (1<<CARD_STATUSB_IRQ);

def CARD_VOLTAGE_0V = 0;
def CARD_VOLTAGE_5V = 1;
def CARD_VOLTAGE_12V = 2;

def CARD_ENABLEB_DIGAUDIO = 1;
def CARD_ENABLEF_DIGAUDIO = (1<<CARD_ENABLEB_DIGAUDIO);

def CARD_DISABLEB_WP = 3;
def CARD_DISABLEF_WP = (1<<CARD_DISABLEB_WP);

def CARD_INTB_SETCLR = 7;
def CARD_INTF_SETCLR = (1<<CARD_INTB_SETCLR);

def CARD_INTB_BVD1 = 5;
def CARD_INTF_BVD1 = (1<<CARD_INTB_BVD1);

def CARD_INTB_SC = 5;
def CARD_INTF_SC = (1<<CARD_INTB_SC);

def CARD_INTB_BVD2 = 4;
def CARD_INTF_BVD2 = (1<<CARD_INTB_BVD2);

def CARD_INTB_DA = 4;
def CARD_INTF_DA = (1<<CARD_INTB_DA);

def CARD_INTB_BSY = 2;
def CARD_INTF_BSY = (1<<CARD_INTB_BSY);

def CARD_INTB_IRQ = 2;
def CARD_INTF_IRQ = (1<<CARD_INTB_IRQ);

def CARD_INTERFACE_AMIGA_0 = 0;

def CISTPL_AMIGAXIP = $91;

struct TP_AmigaXIP is
  TPL_CODE:ubyte;
  TPL_LINK:ubyte;
  TP_XIPLOC[4]:ubyte;
  TP_XIPFLAGS:ubyte;
  TP_XIPRESRV:ubyte;
;

def XIPFLAGSB_AUTORUN = 0;
def XIPFLAGSF_AUTORUN = (1<<XIPFLAGSB_AUTORUN);

