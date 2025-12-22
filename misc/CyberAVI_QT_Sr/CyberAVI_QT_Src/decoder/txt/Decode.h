#ifndef DECODE_H
#define DECODE_H

#define uchar unsigned char
#define ushort unsigned short
#define ulong unsigned long

struct YUVTable {
  long ubTab[256];
  long vrTab[256];
  long ugTab[256];
  long vgTab[256];
  long yTab[256];
};

struct YUVBuffer {
  uchar *yBuf;
  uchar *uBuf;
  uchar *vBuf;
};

typedef struct {
  uchar alpha;
  uchar red;
  uchar green;
  uchar blue;
} RGBTriple;

#define CommonData              \
  uchar gray;                   \
  uchar dither;                 \
  struct YUVTable *yuvTab;      \
  struct YUVBuffer *yuvBuf;     \
  uchar *rngLimit;              \
  uchar *remapPal;              \
  struct RGBTriple *penPal      \

#define scale4  4369
#define scale5  2114
#define scale6  1040
#define scale8   257
#define scale9   128
#define scale10   64
#define scale11   32
#define scale13    8

#define NULL 0L

#define REG(d) register __ ## d

/* /// "RGBto332" */
#define RGBto332(r,g,b,scale) (uchar)((((r*scale) & 0xe000)>>0x08) | (((g*scale) & 0xe000)>>0x0b) | (((b*scale) & 0xc000)>>0x0e))
/* \\\ */

/* /// "RGB5toGray" */
#define RGB5toGray(r,g,b) (uchar)((scale10*(r*11+g*16+b*5)) >> 8)
/* \\\ */

/* /// "RGB8toGray" */
#define RGB8toGray(r,g,b) (uchar)((r*11+g*16+b*5) >> 5)
/* \\\ */

/* /// "ColorToRGB" */
#define ColorToRGB(color,r,g,b) {                   \
  ulong _r, _g, _b;                                 \
  _r=(color >> 10) & 0x1f; r=(_r << 3) | (_r >> 2); \
  _g=(color >>  5) & 0x1f; g=(_g << 3) | (_g >> 2); \
  _b= color & 0x1f;        b=(_b << 3) | (_b >> 2); \
}
/* \\\ */

/* /// "ColorTo332" */
#define ColorTo332(from,to) {        \
  ulong r,g,b;                       \
  r = (from >> 10) & 0x1f;           \
  g = (from >>  5) & 0x1f;           \
  b =  from & 0x1f;                  \
  to=remap[RGBto332(r,g,b,scale5)];  \
}
/* \\\ */

/* /// "ColorTo332Gray" */
#define ColorTo332Gray(from,to) { \
  ulong r,g,b;                    \
  r=(from >> 10) & 0x1f;          \
  g=(from >>  5) & 0x1f;          \
  b= from & 0x1f;                 \
  to=RGB5toGray(r,g,b);           \
}
/* \\\ */



/* /// "Idx332ToRGB" */
#define Idx332ToRGB(idx,r,g,b) { \
  r=pens[idx].red;               \
  g=pens[idx].green;             \
  b=pens[idx].blue;              \
}
/* \\\ */

/* /// "RGBtoCol332" */
#define RGBtoCol332(r,g,b,scale) (      \
  ((((r)*(scale)) & rMask) >> rShift) | \
  ((((g)*(scale)) & gMask) >> gShift) | \
  ((((b)*(scale)) & bMask) >> bShift) )
/* \\\ */

/* /// "RGB16toColor" */
#define RGB16toColor(rgb16,col332) {       \
  ulong r,g,b;                             \
  r = (rgb16 >> 10) & 0x1f;                \
  g = (rgb16 >>  5) & 0x1f;                \
  b =  rgb16        & 0x1f;                \
  col332=remap[RGBtoCol332(r,g,b,scale5)]; \
}
/* \\\ */

/* /// "RGB16toColorNoMap" */
#define RGB16toColorNoMap(rgb16,col332) { \
  ulong r,g,b;                            \
  r = (rgb16 >> 10) & 0x1f;               \
  g = (rgb16 >>  5) & 0x1f;               \
  b =  rgb16        & 0x1f;               \
  col332=RGBtoCol332(r,g,b,scale5);       \
}
/* \\\ */

/* /// "RGB24toColor" */
#define RGB24toColor(r,g,b,col332) {       \
  col332=remap[RGBtoCol332(r,g,b,scale8)]; \
}
/* \\\ */

/* /// "RGB24toColorNoMap" */
#define RGB24toColorNoMap(r,g,b,col332) { \
  col332=RGBtoCol332(r,g,b,scale8);       \
}
/* \\\ */

/* /// "RGB16toRGB24" */
#define RGB16toRGB24(rgb16,r,g,b) {                 \
  ulong _r, _g, _b;                                 \
  _r=(rgb16 >> 10) & 0x1f; r=(_r << 3) | (_r >> 2); \
  _g=(rgb16 >>  5) & 0x1f; g=(_g << 3) | (_g >> 2); \
  _b= rgb16        & 0x1f; b=(_b << 3) | (_b >> 2); \
}
/* \\\ */

/* /// "get16pc" */
#define get16pc(dptr) (*dptr++) | (*dptr++)<<8
/* \\\ */

/* /// "get16" */
#define get16(dptr) (*dptr++)<<8 | (*dptr++)
/* \\\ */

/* /// "get24pc" */
#define get24pc(dptr) (*dptr++) | (*dptr++)<<8 | (*dptr++)<<16
/* \\\ */

/* /// "get24" */
#define get24(dptr) (*dptr++)<<16 | (*dptr++)<<8 | (*dptr++)
/* \\\ */

/* /// "get32pc" */
#define get32pc(dptr) (*dptr++) | (*dptr++)<<8 | (*dptr++)<<16 | (*dptr++)<<24
/* \\\ */

/* /// "get32" */
#define get32(dptr) (*dptr++)<<24 | (*dptr++)<<16 | (*dptr++)<<8 | (*dptr++)
/* \\\ */

#endif

