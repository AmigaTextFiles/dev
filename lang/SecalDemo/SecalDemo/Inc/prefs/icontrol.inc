include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";

struct IControlPrefs is
  ic_Reserved[4]:long;
  ic_TimeOut:uword;
  ic_MetaDrag:word;
  ic_Flags:ulong;
  ic_WBtoFront:ubyte;
  ic_FrontToBack:ubyte;
  ic_ReqTrue:ubyte;
  ic_ReqFalse:ubyte;
;

def ICB_COERCE_COLORS = 0;
def ICB_COERCE_LACE = 1;
def ICB_STRGAD_FILTER = 2;
def ICB_MENUSNAP = 3;
def ICB_MODEPROMOTE = 4;

def ICF_COERCE_COLORS = (1<<0);
def ICF_COERCE_LACE = (1<<1);
def ICF_STRGAD_FILTER = (1<<2);
def ICF_MENUSNAP = (1<<3);
def ICF_MODEPROMOTE = (1<<4);

