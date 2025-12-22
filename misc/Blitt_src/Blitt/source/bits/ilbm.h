#ifndef ILBM_H
#define ILBM_H
#ifndef COMPILER_H
#include        <iff/compiler.h>
#endif
#ifndef GRAPHICS_GFX_H
#include        <graphics/gfx.h>
#endif
#include        <iff/iff.h>
#define ID_ILBM MakeID('I','L','B','M')
#define ID_BMHD MakeID('B','M','H','D')
#define ID_CMAP MakeID('C','M','A','P')
#define ID_GRAB MakeID('G','R','A','B')
#define ID_DEST MakeID('D','E','S','T')
#define ID_SPRT MakeID('S','P','R','T')
#define ID_CAMG MakeID('C','A','M','G')
#define ID_CRNG MakeID('C','R','N','G')
#define ID_CCRT MakeID('C','C','R','T')
#define ID_BODY MakeID('B','O','D','Y')
typedef UBYTE   Masking;
#define mskNone 0
#define mskHasMask      1
#define mskHasTransparentColor  2
#define mskLasso        3
typedef UBYTE   Compression;
#define cmpNone 0
#define cmpByteRun1     1
#define x320x200Aspect  10
#define y320x200Aspect  11
#define x320x400Aspect  20
#define y320x400Aspect  11
#define x640x200Aspect  5
#define y640x200Aspect  11
#define x640x400Aspect  10
#define y640x400Aspect  11
typedef struct  {
UWORD   w,      h;
WORD    x,      y;
UBYTE   nPlanes;
Masking masking;
Compression     compression;
UBYTE   pad1;
UWORD   transparentColor;
UBYTE   xAspect,        yAspect;
WORD    pageWidth,      pageHeight;
}       BitMapHeader;
#define RowBytes(w) (((w) + 15) >> 4 << 1)
typedef struct  {
UBYTE   red,    green,  blue;
}       ColorRegister;
#define sizeofColorRegister     3
typedef WORD    Color4;
#define MaxAmDepth      6
typedef struct  {
WORD    x,      y;
}       Point2D;
typedef struct  {
UBYTE   depth;
UBYTE   pad1;
UWORD   planePick;
UWORD   planeOnOff;
UWORD   planeMask;
}       DestMerge;
typedef UWORD   SpritePrecedence;
typedef struct  {
ULONG   ViewModes;
}       CamgChunk;
typedef struct  {
WORD    pad1;
WORD    rate;
WORD    active;
UBYTE   low,    high;
}       CRange;
typedef struct  {
WORD    direction;
UBYTE   start;
UBYTE   end;
LONG    seconds;
LONG    microseconds;
WORD    pad;
}       CcrtChunk;
#define PutBMHD(context, bmHdr) \
PutCk(context,ID_BMHD,sizeof(BitMapHeader),(BYTE *)bmHdr)
#define PutGRAB(context, point2D) \
PutCk(context,ID_GRAB,sizeof(Point2D),(BYTE *)point2D)
#define PutDEST(context, destMerge) \
PutCk(context,ID_DEST,sizeof(DestMerge),(BYTE *)destMerge)
#define PutSPRT(context, spritePrec) \
PutCk(context,ID_SPRT,sizeof(SpritePrecedence),(BYTE *)spritePrec)
#define PutCAMG(context,camg) \
PutCk(context,ID_CAMG,sizeof(CamgChunk),(BYTE *)camg)
#define PutCRNG(context,crng) \
PutCk(context,ID_CRNG,sizeof(CRange),(BYTE *)crng)
#define PutCCRT(context,ccrt) \
PutCk(context,ID_CCRT,sizeof(CcrtChunk),(BYTE *)ccrt)
extern  IFFP    InitBMHdr();
extern  IFFP    PutCMAP();
extern  IFFP    PutBODY();
#define GetBMHD(context,bmHdr) \
IFFReadBytes(context,(BYTE *)bmHdr,sizeof(BitMapHeader))
#define GetGRAB(context,point2D) \
IFFReadBytes(context,(BYTE *)point2D,sizeof(Point2D))
#define GetDEST(context,destMerge) \
IFFReadBytes(context,(BYTE *)destMerge,sizeof(DestMerge))
#define GetSPRT(context,spritePrec) \
IFFReadBytes(context,(BYTE *)spritePrec,sizeof(SpritePrecedence))
#define GetCAMG(context,camg) \
IFFReadBytes(context,(BYTE *)camg,sizeof(CamgChunk))
#define GetCRNG(context,crng) \
IFFReadBytes(context,(BYTE *)crng,sizeof(CRange))
#define GetCCRT(context,ccrt) \
IFFReadBytes(context,(BYTE *)ccrt,sizeof(CcrtChunk))
#define MaxSrcPlanes    16+1
extern  IFFP    GetCMAP();
extern  IFFP    GetBODY();
#endif  ILBM_H
