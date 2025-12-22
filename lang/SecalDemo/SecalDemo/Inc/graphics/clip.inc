include "inc/exec/types.inc";
include "inc/graphics/gfx.inc";
include "inc/exec/semaphores.inc";
include "inc/utility/hooks.inc";

def NEWLOCKS = ;

struct Layer is
  front:ulong;
  back:ulong;
  ClipRect:ulong;
  rp:ulong;
  bounds:Rectangle;
  reserved[4]:ubyte;
  priority:uword;
  Flags:uword;
  SuperBitMap:ulong;
  SuperClipRect:ulong;
  Window:ulong;
  Scroll_X,Scroll_Y:word;
  cr:ulong;
  cr2:ulong;
  crnew:ulong;
  SuperSaveClipRects:ulong;
  _cliprects:ulong;
  LayerInfo:ulong;
  Lock:SignalSemaphore;
  BackFill:ulong;
  reserved1:ulong;
  ClipRegion:ulong;
  saveClipRects:ulong;
  Width,Height:word;
  reserved2[18]:ubyte;
  DamageList:ulong;
;

struct ClipRect is
  Next:ulong;
  prev:ulong;
  lobs:ulong;
  BitMap:ulong;
  bounds:Rectangle;
  _p1:ulong;
  _p2:ulong;
  reserved:long;
  Flags:long;
;

def CR_NEEDS_NO_CONCEALED_RASTERS = 1;
def CR_NEEDS_NO_LAYERBLIT_DAMAGE = 2;

def ISLESSX = 1;
def ISLESSY = 2;
def ISGRTRX = 4;
def ISGRTRY = 8;

