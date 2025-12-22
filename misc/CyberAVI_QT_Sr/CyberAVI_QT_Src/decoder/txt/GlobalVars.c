#include "Decode.h"

uchar gray;
uchar dither;
uchar *rngLimit;
uchar *remap;
RGBTriple *pens;
struct YUVTable *yuvTab;
struct YUVBuffer *yuvBuf;
ulong rMask, gMask, bMask;
ulong rShift, gShift, bShift;

struct Globals {
  uchar gray;
  uchar dither;
  struct YUVTable *yuvTab;
  struct YUVBuffer *yuvBuf;
  uchar *rngLimit;
  uchar *remap;
  RGBTriple *pens;
};

__asm void SetGlobalVars(REG(a0) struct Globals *gl)
{
  gray=gl->gray;
  dither=gl->dither;
  yuvTab=gl->yuvTab;
  yuvBuf=gl->yuvBuf;
  rngLimit=gl->rngLimit;
  remap=gl->remap;
  pens=gl->pens;
}

struct MaskBits {
  ulong rMask, gMask, bMask;
  ulong rShift, gShift, bShift;
};

__asm void SetMaskNBits(REG(a0) struct MaskBits *mb)
{
  rShift=mb->rShift;
  gShift=mb->gShift;
  bShift=mb->bShift;
  rMask=mb->rMask;
  gMask=mb->gMask;
  bMask=mb->bMask;
}
