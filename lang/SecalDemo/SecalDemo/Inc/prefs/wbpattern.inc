include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";

struct WBPatternPrefs is
  wbp_Reserved[4]:ulong;
  wbp_Which:uword;
  wbp_Flags:uword;
  wbp_Revision:byte;
  wbp_Depth:byte;
  wbp_DataLength:uword;
;

def WBP_ROOT = 0;
def WBP_DRAWER = 1;
def WBP_SCREEN = 2;

def WBPF_PATTERN = $0001;
def WBPF_NOREMAP = $0010;

def MAXDEPTH = 3;
def DEFPATDEPTH = 2;

def PAT_WIDTH = 16;
def PAT_HEIGHT = 16;

