include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";

struct PrinterGfxPrefs is
  pg_Reserved[4]:long;
  pg_Aspect:uword;
  pg_Shade:uword;
  pg_Image:uword;
  pg_Threshold:word;
  pg_ColorCorrect:ubyte;
  pg_Dimensions:ubyte;
  pg_Dithering:ubyte;
  pg_GraphicFlags:uword;
  pg_PrintDensity:ubyte;
  pg_PrintMaxWidth:uword;
  pg_PrintMaxHeight:uword;
  pg_PrintXOffset:ubyte;
  pg_PrintYOffset:ubyte;
;

def PA_HORIZONTAL = 0;
def PA_VERTICAL = 1;

def PS_BW = 0;
def PS_GREYSCALE = 1;
def PS_COLOR = 2;
def PS_GREY_SCALE2 = 3;

def PI_POSITIVE = 0;
def PI_NEGATIVE = 1;

def PCCB_RED = 1;
def PCCB_GREEN = 2;
def PCCB_BLUE = 3;

def PCCF_RED = (1<<0);
def PCCF_GREEN = (1<<1);
def PCCF_BLUE = (1<<2);

def PD_IGNORE = 0;
def PD_BOUNDED = 1;
def PD_ABSOLUTE = 2;
def PD_PIXEL = 3;
def PD_MULTIPLY = 4;

def PD_ORDERED = 0;
def PD_HALFTONE = 1;
def PD_FLOYD = 2;

def PGFB_CENTER_IMAGE = 0;
def PGFB_INTEGER_SCALING = 1;
def PGFB_ANTI_ALIAS = 2;

def PGFF_CENTER_IMAGE = (1<<0);
def PGFF_INTEGER_SCALING = (1<<1);
def PGFF_ANTI_ALIAS = (1<<2);

