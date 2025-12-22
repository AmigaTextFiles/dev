#include "Decode.h"

extern uchar gray;
extern uchar dither;
extern uchar *rngLimit;
extern uchar *remap;
extern RGBTriple *pens;
extern struct YUVTable *yuvTab;
extern struct YUVBuffer *yuvBuf;
extern ulong rShift, gShift, bShift;
extern ulong rMask, gMask, bMask;

