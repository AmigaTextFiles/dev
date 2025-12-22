include "inc/exec/types.inc";

struct BootBlock is
  bb_id[4]:ubyte;
  bb_chksum:long;
  bb_dosblock:long;
;

def BOOTSECTS = 2;

def BBNAME_DOS = $444f5300;
def BBNAME_KICK = $4b49434b;

