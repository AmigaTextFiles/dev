/*
sc:c/sc opt txt/DecodeRAW.c
*/

#include "Decode.h"
#include "YUV.h"

struct RAWData {
  uchar gray;
  uchar *rngLimit;
  struct RGBTriple *cmap;
};

/* /// "DecodeRAW1()" */
__asm void DecodeRAW1(REG(a0) uchar *from,
                      REG(a1) uchar *to,
                      REG(d0) ulong width,
                      REG(d1) ulong height,
                      REG(d2) ulong encSize,
                      REG(a2) uchar *spec)
{
  ulong black=0x00;
  ulong white=0x01;
  ulong i=(width*height)>>1;

  while (i--) {
    ulong d=*from++;
    to[0]=(d & 0x80) ? white : black;
    to[1]=(d & 0x40) ? white : black;
    to[2]=(d & 0x20) ? white : black;
    to[3]=(d & 0x10) ? white : black;
    to[4]=(d & 0x08) ? white : black;
    to[5]=(d & 0x04) ? white : black;
    to[6]=(d & 0x02) ? white : black;
    to[7]=(d & 0x01) ? white : black;
    to+=8;
  }
}
/* \\\ */

/* /// "DecodeRAW4()" */
__asm void DecodeRAW4(REG(a0) uchar *from,
                      REG(a1) uchar *to,
                      REG(d0) ulong width,
                      REG(d1) ulong height,
                      REG(d2) ulong encSize,
                      REG(a2) uchar *spec)
{
  ulong i=(width*height)>>1;

  while (i--) {
    ulong d=*from++;
    to[0]=(d>>4);
    to[1]=d & 0x0f;
    to+=2;
  }
}
/* \\\ */

/* /// "DecodeRAW16toRGB()" */
__asm void DecodeRAW16toRGB(REG(a0) ushort *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) uchar *spec)
{
  ulong i=width*height;

  while (i--) {
    ulong d, r, g, b;
    d=*from++;
    ColorToRGB(d,r,g,b);
    to[0]=r;
    to[1]=g;
    to[2]=b;
    to+=3;
  }
}
/* \\\ */

/* /// "DecodeRAW16to332()" */
__asm void DecodeRAW16to332(REG(a0) ushort *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) struct RAWData *spec)
{
  ulong i=width*height;

  if (spec->gray) {
    while (i--) {
      ulong d;
      d=*from++;
      ColorTo332Gray(d,*to++);
    }
  } else {
    while (i--) {
      ulong d;
      d=*from++;
      ColorTo332(d,*to++);
    }
  }
}
/* \\\ */

/* /// "DecodeRAW16to332Dith()" */
__asm void DecodeRAW16to332Dith(REG(a0) ushort *from,
                                REG(a1) uchar *to,
                                REG(d0) ulong width,
                                REG(d1) ulong height,
                                REG(d2) ulong encSize,
                                REG(a2) struct RAWData *spec)
{
  uchar *rngLimit=spec->rngLimit;
  struct RGBTriple *cmap=spec->cmap;

  while (height--) {
    uchar r, g, b;
    long re=0, ge=0, be=0, w=width;
    while (w--) {
      ulong d, color;
      d=*from++;
      ColorToRGB(d,r,g,b);
      DitherGetRGB(r,g,b,re,ge,be,color);
      *to++=color;
    }
  }
}
/* \\\ */

/* /// "DecodeRAW24to332()" */
__asm void DecodeRAW24to332(REG(a0) uchar *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) struct RAWData *spec)
{
  ulong i=width*height;

  if (spec->gray) {
    while (i--) {
      uchar r, g, b;
      r=from[0];
      g=from[1];
      b=from[2];
      from+=3;
      *to++=RGB8toGray(r,g,b);
    }
  } else {
    while (i--) {
      uchar r, g, b;
      r=from[0];
      g=from[1];
      b=from[2];
      from+=3;
      *to++=RGBto332(r,g,b,scale8);
    }
  }
}
/* \\\ */

/* /// "DecodeRAW24to332Dith()" */
__asm void DecodeRAW24to332Dith(REG(a0) uchar *from,
                                REG(a1) uchar *to,
                                REG(d0) ulong width,
                                REG(d1) ulong height,
                                REG(d2) ulong encSize,
                                REG(a2) struct RAWData *spec)
{
  uchar *rngLimit=spec->rngLimit;
  struct RGBTriple *cmap=spec->cmap;

  while (height--) {
    uchar r, g, b;
    long re=0, ge=0, be=0, w=width;
    while (w--) {
      ulong color;
      r=*from++;
      g=*from++;
      b=*from++;
      DitherGetRGB(r,g,b,re,ge,be,color);
      *to++=color;
    }
  }
}
/* \\\ */

/* /// "DecodeRAW32toRGB()" */
__asm void DecodeRAW32toRGB(REG(a0) uchar *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) uchar *spec)
{
  ulong i=width*height;

  while (i--) {
    to[0]=from[1]; /* r */
    to[1]=from[2]; /* g */
    to[2]=from[3]; /* b */
    to+=3;
    from+=4;
  }
}
/* \\\ */

/* /// "DecodeRAW32to332()" */
__asm void DecodeRAW32to332(REG(a0) uchar *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) struct RAWData *spec)
{
  ulong i=width*height;

  if (spec->gray) {
    while (i--) {
      uchar r, g, b;
      r=from[1];
      g=from[2];
      b=from[3];
      from+=4;
      *to++=RGB8toGray(r,g,b);
    }
  } else {
    while (i--) {
      uchar r, g, b;
      r=from[1];
      g=from[2];
      b=from[3];
      from+=4;
      *to++=RGBto332(r,g,b,scale8);
    }
  }
}
/* \\\ */

/* /// "DecodeRAW32to332Dith()" */
__asm void DecodeRAW32to332Dith(REG(a0) uchar *from,
                                REG(a1) uchar *to,
                                REG(d0) ulong width,
                                REG(d1) ulong height,
                                REG(d2) ulong encSize,
                                REG(a2) struct RAWData *spec)
{
  uchar *rngLimit=spec->rngLimit;
  struct RGBTriple *cmap=spec->cmap;

  while (height--) {
    uchar r, g, b;
    long re=0, ge=0, be=0, w=width;
    while (w--) {
      ulong color;
      r=from[1];
      g=from[2];
      b=from[3];
      from+=4;
      DitherGetRGB(r,g,b,re,ge,be,color);
      *to++=color;
    }
  }
}
/* \\\ */

