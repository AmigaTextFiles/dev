include "inc/exec/types.inc";
include "inc/graphics/gfx.inc";

struct AreaInfo is
  VctrTbl:ulong;
  VctrPtr:ulong;
  FlagTbl:ulong;
  FlagPtr:ulong;
  Count:word;
  MaxCount:word;
  FirstX,FirstY:word;
;

struct TmpRas is
  RasPtr:ulong;
  Size:long;
;

struct GelsInfo is
  sprRsrvd:byte;
  Flags:ubyte;
  gelHead:ulong;
  gelTail:ulong;
  nextLine:ulong;
  lastColor:ulong;
  collHandler:ulong;
  leftmost,rightmost,topmost,bottommost:word;
  firstBlissObj,lastBlissObj:ulong;
;

struct RastPort is
  Layer:ulong;
  BitMap:ulong;
  AreaPtrn:ulong;
  TmpRas:ulong;
  AreaInfo:ulong;
  GelsInfo:ulong;
  Mask:ubyte;
  FgPen:byte;
  BgPen:byte;
  AOlPen:byte;
  DrawMode:byte;
  AreaPtSz:byte;
  linpatcnt:byte;
  dummy:byte;
  Flags:uword;
  LinePtrn:uword;
  cp_x,cp_y:word;
  minterms[8]:ubyte;
  PenWidth:word;
  PenHeight:word;
  Font:ulong;
  AlgoStyle:ubyte;
  TxFlags:ubyte;
  TxHeight:uword;
  TxWidth:uword;
  TxBaseline:uword;
  TxSpacing:word;
  RP_User:ulong;
  longreserved[2]:ulong;
  wordreserved[7]:uword;
  reserved[8]:ubyte;
;

def JAM1 = 0;
def JAM2 = 1;
def COMPLEMENT = 2;
def INVERSVID = 4;

def FRST_DOT = $01;
def ONE_DOT = $02;
def DBUFFER = $04;

def AREAOUTLINE = $08;
def NOCROSSFILL = $20;

