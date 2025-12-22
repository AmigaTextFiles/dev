include "inc/exec/lists.inc";

include "inc/exec/semaphores.inc";

def LAYERSIMPLE = 1;
def LAYERSMART = 2;
def LAYERSUPER = 4;
def LAYERUPDATING = $10;
def LAYERBACKDROP = $40;
def LAYERREFRESH = $80;
def LAYERIREFRESH = $200;
def LAYERIREFRESH2 = $400;
def LAYER_CLIPRECTS_LOST = $100;

struct Layer_Info is
  top_layer:ulong;
  check_lp:ulong;
  obs:ulong;
  FreeClipRects:ulong;
  PrivateReserve1:long;
  PrivateReserve2:long;
  Lock:SignalSemaphore;
  gs_Head:MinList;
  PrivateReserve3:word;
  PrivateReserve4:ulong;
  Flags:uword;
  fatten_count:byte;
  LockLayersCount:byte;
  PrivateReserve5:word;
  BlankHook:ulong;
  LayerInfo_extra:ulong;
;

def NEWLAYERINFO_CALLED = 1;

def LAYERS_NOBACKFILL = 1;
def LAYERS_BACKFILL = 0;

