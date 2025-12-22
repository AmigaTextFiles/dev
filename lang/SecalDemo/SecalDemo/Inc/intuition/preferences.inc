include "inc/exec/types.inc";
include "inc/devices/timer.inc";

def FILENAME_SIZE = 30;
def DEVNAME_SIZE = 16;

def POINTERSIZE = ((1+16+1)*2);

def TOPAZ_EIGHTY = 8;
def TOPAZ_SIXTY = 9;

struct Preferences is
  FontHeight:byte;
  PrinterPort:ubyte;
  BaudRate:uword;
  KeyRptSpeed:timeval;
  KeyRptDelay:timeval;
  DoubleClick:timeval;
  PointerMatrix[(1+16+1)*2]:uword;
  XOffset:byte;
  YOffset:byte;
  color17:uword;
  color18:uword;
  color19:uword;
  PointerTicks:uword;
  color0:uword;
  color1:uword;
  color2:uword;
  color3:uword;
  ViewXOffset:byte;
  ViewYOffset:byte;
  ViewInitX,ViewInitY:word;
  EnableCLI:word;
  PrinterType:uword;
  PrinterFilename[30]:ubyte;
  PrintPitch:uword;
  PrintQuality:uword;
  PrintSpacing:uword;
  PrintLeftMargin:uword;
  PrintRightMargin:uword;
  PrintImage:uword;
  PrintAspect:uword;
  PrintShade:uword;
  PrintThreshold:word;
  PaperSize:uword;
  PaperLength:uword;
  PaperType:uword;
  SerRWBits:ubyte;
  SerStopBuf:ubyte;
  SerParShk:ubyte;
  LaceWB:ubyte;
  Pad[12]:ubyte;
  PrtDevName[16]:ubyte;
  DefaultPrtUnit:ubyte;
  DefaultSerUnit:ubyte;
  RowSizeChange:byte;
  ColumnSizeChange:byte;
  PrintFlags:uword;
  PrintMaxWidth:uword;
  PrintMaxHeight:uword;
  PrintDensity:ubyte;
  PrintXOffset:ubyte;
  wb_Width:uword;
  wb_Height:uword;
  wb_Depth:ubyte;
  ext_size:ubyte;
;

def LACEWB = (1<<0);
def LW_RESERVED = 1;

def SCREEN_DRAG = (1<<14);
def MOUSE_ACCEL = (1<<15);

def PARALLEL_PRINTER = $00;
def SERIAL_PRINTER = $01;

def BAUD_110 = $00;
def BAUD_300 = $01;
def BAUD_1200 = $02;
def BAUD_2400 = $03;
def BAUD_4800 = $04;
def BAUD_9600 = $05;
def BAUD_19200 = $06;
def BAUD_MIDI = $07;

def FANFOLD = $00;
def SINGLE = $80;

def PICA = $000;
def ELITE = $400;
def FINE = $800;

def DRAFT = $000;
def LETTER = $100;

def SIX_LPI = $000;
def EIGHT_LPI = $200;

def IMAGE_POSITIVE = $00;
def IMAGE_NEGATIVE = $01;

def ASPECT_HORIZ = $00;
def ASPECT_VERT = $01;

def SHADE_BW = $00;
def SHADE_GREYSCALE = $01;
def SHADE_COLOR = $02;

def US_LETTER = $00;
def US_LEGAL = $10;
def N_TRACTOR = $20;
def W_TRACTOR = $30;
def CUSTOM = $40;

def EURO_A0 = $50;
def EURO_A1 = $60;
def EURO_A2 = $70;
def EURO_A3 = $80;
def EURO_A4 = $90;
def EURO_A5 = $a0;
def EURO_A6 = $b0;
def EURO_A7 = $c0;
def EURO_A8 = $d0;

def CUSTOM_NAME = $00;
def ALPHA_P_101 = $01;
def BROTHER_15XL = $02;
def CBM_MPS1000 = $03;
def DIAB_630 = $04;
def DIAB_ADV_D25 = $05;
def DIAB_C_150 = $06;
def EPSON = $07;
def EPSON_JX_80 = $08;
def OKIMATE_20 = $09;
def QUME_LP_20 = $0a;
def HP_LASERJET = $0b;
def HP_LASERJET_PLUS = $0c;

def SBUF_512 = $00;
def SBUF_1024 = $01;
def SBUF_2048 = $02;
def SBUF_4096 = $03;
def SBUF_8000 = $04;
def SBUF_16000 = $05;

def SREAD_BITS = $f0;
def SWRITE_BITS = $0f;
def SSTOP_BITS = $f0;
def SBUFSIZE_BITS = $0f;
def SPARITY_BITS = $f0;
def SHSHAKE_BITS = $0f;

def SPARITY_NONE = 0;
def SPARITY_EVEN = 1;
def SPARITY_ODD = 2;
def SPARITY_MARK = 3;
def SPARITY_SPACE = 4;

def SHSHAKE_XON = 0;
def SHSHAKE_RTS = 1;
def SHSHAKE_NONE = 2;

def CORRECT_RED = $0001;
def CORRECT_GREEN = $0002;
def CORRECT_BLUE = $0004;

def CENTER_IMAGE = $0008;

def IGNORE_DIMENSIONS = $0000;
def BOUNDED_DIMENSIONS = $0010;
def ABSOLUTE_DIMENSIONS = $0020;
def PIXEL_DIMENSIONS = $0040;
def MULTIPLY_DIMENSIONS = $0080;

def INTEGER_SCALING = $0100;

def ORDERED_DITHERING = $0000;
def HALFTONE_DITHERING = $0200;
def FLOYD_DITHERING = $0400;

def ANTI_ALIAS = $0800;
def GREY_SCALE2 = $1000;

def CORRECT_RGB_MASK = (CORRECT_RED|CORRECT_GREEN|CORRECT_BLUE);
def DIMENSIONS_MASK = (BOUNDED_DIMENSIONS|ABSOLUTE_DIMENSIONS|PIXEL_DIMENSIONS|MULTIPLY_DIMENSIONS);
def DITHERING_MASK = (HALFTONE_DITHERING|FLOYD_DITHERING);

