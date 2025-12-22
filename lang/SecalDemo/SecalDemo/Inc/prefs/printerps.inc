include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";

struct PrinterPSPrefs is
  ps_Reserved[4]:long;
  ps_DriverMode:ubyte;
  ps_PaperFormat:ubyte;
  ps_Reserved1[2]:ubyte;
  ps_Copies:long;
  ps_PaperWidth:long;
  ps_PaperHeight:long;
  ps_HorizontalDPI:long;
  ps_VerticalDPI:long;
  ps_Font:ubyte;
  ps_Pitch:ubyte;
  ps_Orientation:ubyte;
  ps_Tab:ubyte;
  ps_Reserved2[8]:ubyte;
  ps_LeftMargin:long;
  ps_RightMargin:long;
  ps_TopMargin:long;
  ps_BottomMargin:long;
  ps_FontPointSize:long;
  ps_Leading:long;
  ps_Reserved3[8]:ubyte;
  ps_LeftEdge:long;
  ps_TopEdge:long;
  ps_Width:long;
  ps_Height:long;
  ps_Image:ubyte;
  ps_Shading:ubyte;
  ps_Dithering:ubyte;
  ps_Reserved4[9]:ubyte;
  ps_Aspect:ubyte;
  ps_ScalingType:ubyte;
  ps_Reserved5:ubyte;
  ps_Centering:ubyte;
  ps_Reserved6[8]:ubyte;
;

def DM_POSTSCRIPT = 0;
def DM_PASSTHROUGH = 1;

def PF_USLETTER = 0;
def PF_USLEGAL = 1;
def PF_A4 = 2;
def PF_CUSTOM = 3;

def FONT_COURIER = 0;
def FONT_TIMES = 1;
def FONT_HELVETICA = 2;
def FONT_HELV_NARROW = 3;
def FONT_AVANTGARDE = 4;
def FONT_BOOKMAN = 5;
def FONT_NEWCENT = 6;
def FONT_PALATINO = 7;
def FONT_ZAPFCHANCERY = 8;

def PITCH_NORMAL = 0;
def PITCH_COMPRESSED = 1;
def PITCH_EXPANDED = 2;

def ORIENT_PORTRAIT = 0;
def ORIENT_LANDSCAPE = 1;

def TAB_4 = 0;
def TAB_8 = 1;
def TAB_QUART = 2;
def TAB_HALF = 3;
def TAB_INCH = 4;

def IM_POSITIVE = 0;
def IM_NEGATIVE = 1;

def SHAD_BW = 0;
def SHAD_GREYSCALE = 1;
def SHAD_COLOR = 2;

def DITH_DEFAULT = 0;
def DITH_DOTTY = 1;
def DITH_VERT = 2;
def DITH_HORIZ = 3;
def DITH_DIAG = 4;

def ASP_HORIZ = 0;
def ASP_VERT = 1;

def ST_ASPECT_ASIS = 0;
def ST_ASPECT_WIDE = 1;
def ST_ASPECT_TALL = 2;
def ST_ASPECT_BOTH = 3;
def ST_FITS_WIDE = 4;
def ST_FITS_TALL = 5;
def ST_FITS_BOTH = 6;

def CENT_NONE = 0;
def CENT_HORIZ = 1;
def CENT_VERT = 2;
def CENT_BOTH = 3;

