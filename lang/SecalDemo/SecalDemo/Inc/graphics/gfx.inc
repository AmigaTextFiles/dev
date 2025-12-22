include "inc/exec/types.inc";

def BITSET = $8000;
def BITCLR = 0;

struct Rectangle is
  MinX,MinY:word;
  MaxX,MaxY:word;
;

struct Rect32 is
  MinX,MinY:long;
  MaxX,MaxY:long;
;

struct Point is
  x,y:word;
;

struct BitMap is
  BytesPerRow:uword;
  Rows:uword;
  Flags:ubyte;
  Depth:ubyte;
  pad:uword;
  Planes[8]:ulong;
;

def RASSIZE(w,h) = ((h)*(((w)+15)>>3&$fffe));

def BMB_CLEAR = 0;
def BMB_DISPLAYABLE = 1;
def BMB_INTERLEAVED = 2;
def BMB_STANDARD = 3;
def BMB_MINPLANES = 4;

def BMF_CLEAR = (1<<BMB_CLEAR);
def BMF_DISPLAYABLE = (1<<BMB_DISPLAYABLE);
def BMF_INTERLEAVED = (1<<BMB_INTERLEAVED);
def BMF_STANDARD = (1<<BMB_STANDARD);
def BMF_MINPLANES = (1<<BMB_MINPLANES);

def BMA_HEIGHT = 0;
def BMA_DEPTH = 4;
def BMA_WIDTH = 8;
def BMA_FLAGS = 12;

