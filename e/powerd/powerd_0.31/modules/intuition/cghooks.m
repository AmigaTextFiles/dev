MODULE  'intuition/intuition',
      'intuition/screens',
      'graphics/rastport',
      'graphics/clip'

#define CUSTOM_HOOK(g) (g::Gadget.MutualExclude)

OBJECT GadgetInfo
  Screen:PTR TO Screen,
  Window:PTR TO Window,
  Requester:PTR TO Requester,
  RastPort:PTR TO RastPort,
  Layer:PTR TO Layer,
  Domain:IBox,
  DetailPen:UBYTE,
  BlockPen:UBYTE,
  DrInfo:PTR TO DrawInfo,
  Reserved[6]:ULONG

// Um, this object was missing
OBJECT PGX
  Container:IBox,
  NewKnob:IBox
