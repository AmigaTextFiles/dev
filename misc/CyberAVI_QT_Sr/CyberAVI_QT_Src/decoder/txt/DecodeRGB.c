/*
sc:c/sc opt txt/DecodeRGB.c
*/

#include "Decode.h"
#include "YUV.h"
#include "Utils.h"
#include "GlobalVars.h"

struct RGBData {
  ulong dummy;
};

/* /// "DecodeRGB4toRGB()" */
__asm void DecodeRGB4toRGB(REG(a0) uchar *from,
                           REG(a1) uchar *to,
                           REG(d0) ulong width,
                           REG(d1) ulong height,
                           REG(d2) ulong encSize,
                           REG(a2) struct RGBData *spec)
{
  long x, y;
  uchar *iptr;
  ulong oddCnt, rowInc=width*4;

  oddCnt=((width & 0x03)==1)?1:0;

  iptr=to+(height-1)*width*4;
  for (y=height-1; y>0; y--) {
    RGBTriple *ip=(RGBTriple *)iptr;
    for (x=width; x>0; x-=2) {
      uchar d, d1;
      d=*from++;
      d1=(d>>4) & 0x0f;
      Idx332ToRGB(d1,ip[0].red,ip[0].green,ip[0].blue);
      d1=d & 0x0f;
      Idx332ToRGB(d1,ip[1].red,ip[1].green,ip[1].blue);
      ip+=2;
    }
    from+=oddCnt; /* for (x=oddCnt; x>0; x--) from++; */
    iptr-=rowInc;
  }
}
/* \\\ */

/* /// "DecodeRGB4to332()" */
__asm void DecodeRGB4to332(REG(a0) uchar *from,
                           REG(a1) uchar *to,
                           REG(d0) ulong width,
                           REG(d1) ulong height,
                           REG(d2) ulong encSize,
                           REG(a2) struct RGBData *spec)
{
  long x, y;
  uchar *iptr;
  ulong oddCnt, rowInc=width;

  oddCnt=((width & 0x03)==1)?1:0;

  iptr=to+(height-1)*width;
  for (y=height-1; y>0; y--) {
    ulong d;
    uchar *ip=iptr;
    for (x=width; x>0; x-=2) {
      d=*from++;
      ip[0]=remap[d>>4];
      ip[1]=remap[d & 0x0f];
      ip+=2;
    }
    from+=oddCnt; /* for (x=oddCnt; x>0; x--) from++; */
    iptr-=rowInc;
  }
}
/* \\\ */

/* /// "DecodeRGB8toRGB()" */
__asm void DecodeRGB8toRGB(REG(a0) uchar *from,
                           REG(a1) uchar *to,
                           REG(d0) ulong width,
                           REG(d1) ulong height,
                           REG(d2) ulong encSize,
                           REG(a2) struct RGBData *spec)
{
  long x, y;
  uchar *iptr;
  ulong oddCnt;
  ulong rowInc=width*4;

  oddCnt=4-(width & 0x03);
  if (oddCnt==4) oddCnt=0;

  iptr=to+(height-1)*width*4;
  for (y=height-1; y>0; y--) {
    uchar *ip=iptr;
    for (x=width; x>0; x--) {
      uchar d=*from++;
      Idx332ToRGB(d,ip[1],ip[2],ip[3]);
      ip+=4;
    }
    from+=oddCnt;
    iptr-=rowInc;
  }
}
/* \\\ */

/* /// "DecodeRGB8to332()" */
__asm void DecodeRGB8to332(REG(a0) uchar *from,
                           REG(a1) uchar *to,
                           REG(d0) ulong width,
                           REG(d1) ulong height,
                           REG(d2) ulong encSize,
                           REG(a2) struct RGBData *spec)
{
  long x, y;
  uchar *iptr, *ip;
  ulong oddCnt, rowInc=width;

  oddCnt=4-(width & 0x03);
  if (oddCnt==4) oddCnt=0;

  iptr=to+(height-1)*width;
  for (y=height-1; y>0; y--) {
    ip=iptr;
    for (x=width; x>0; x--) {
      *ip++=remap[*from++];
    }
    from+=oddCnt;
    iptr-=rowInc;
  }
}
/* \\\ */

/* /// "DecodeRGB16toRGB()" */
__asm void DecodeRGB16toRGB(REG(a0) uchar *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) struct RGBData *spec)
{
  long x, y;
  uchar *iptr;
  ulong rowInc=width*4;

  iptr=to+(height-1)*width*4;
  for (y=height-1; y>0; y--) {
    uchar *ip=iptr;
    for (x=width; x>0; x--) {
      ulong col;
      col=get16pc(from);
      RGB16toRGB24(col,ip[1],ip[2],ip[3]);
      ip+=4;
    }
    iptr-=rowInc;
  }
}
/* \\\ */

/* /// "DecodeRGB16to332()" */
__asm void DecodeRGB16to332(REG(a0) uchar *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) struct RGBData *spec)
{
  long x, y;
  uchar *iptr;
  ulong rowInc=width;

  iptr=to+(height-1)*width;
  for (y=height-1; y>0; y--) {
    uchar *ip=iptr;
    for (x=width; x>0; x--) {
      ulong col;
      col=get16pc(from);
      RGB16toColor(col,*ip++);
    }
    iptr-=rowInc;
  }
}
/* \\\ */

/* /// "DecodeRGB16to332Dith()" */
__asm void DecodeRGB16to332Dith(REG(a0) uchar *from,
                                REG(a1) uchar *to,
                                REG(d0) ulong width,
                                REG(d1) ulong height,
                                REG(d2) ulong encSize,
                                REG(a2) struct RGBData *spec)
{
  long x, y;
  uchar *iptr;
  ulong rowInc=width;

  iptr=to+(height-1)*width;
  for (y=height-1; y>0; y--) {
    long re=0, ge=0, be=0;
    uchar *ip=iptr;
    for (x=width; x>0; x--) {
      long r, g, b, col;
      col=get16pc(from);
      RGB16toRGB24(col,r,g,b);
      DitherGetRGB(r,g,b,re,ge,be,*ip++);
    }
    iptr-=rowInc;
  }
}
/* \\\ */

/* /// "DecodeRGB24toRGB()" */
__asm void DecodeRGB24toRGB(REG(a0) uchar *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) struct RGBData *spec)
{
  long x, y;
  uchar *iptr;
  uchar oddFlag;
  ulong rowInc=width*4;

  iptr=to+(height-1)*width*4;
  oddFlag=width & 0x01;
  for (y=height-1; y>0; y--) {
    uchar *ip=iptr;
    for (x=width; x>0; x--) {
      ip[1]=from[2];
      ip[2]=from[1];
      ip[3]=from[0];
      ip+=4;
      from+=3;
    }
    if (oddFlag) from++;
    iptr-=rowInc;
  }
}
/* \\\ */

/* /// "DecodeRGB24to332()" */
__asm void DecodeRGB24to332(REG(a0) uchar *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) struct RGBData *spec)
{
  long x, y;
  uchar *iptr;
  uchar oddFlag;
  ulong rowInc=width;

  iptr=to+(height-1)*width;
  oddFlag=width & 0x01;
  for (y=height-1; y>0; y--) {
    uchar *ip=iptr;
    for (x=width; x>0; x--) {
      RGB24toColor(from[2],from[1],from[0],*ip++);
      from+=3;
    }
    if (oddFlag) from++;
    iptr-=rowInc;
  }
}
/* \\\ */

/* /// "DecodeRGB24to332Dith()" */
__asm void DecodeRGB24to332Dith(REG(a0) uchar *from,
                                REG(a1) uchar *to,
                                REG(d0) ulong width,
                                REG(d1) ulong height,
                                REG(d2) ulong encSize,
                                REG(a2) struct RGBData *spec)
{
  long x, y;
  uchar *iptr;
  uchar oddFlag;
  ulong rowInc=width;

  iptr=to+(height-1)*width;
  oddFlag=width & 0x01;
  for (y=height-1; y>0; y--) {
    long re=0, ge=0, be=0;
    uchar *ip=iptr;
    for (x=width; x>0; x--) {
      ulong r, g, b;
      r=from[2];
      g=from[1];
      b=from[0];
      DitherGetRGB(r,g,b,re,ge,be,*ip++);
      from+=3;
    }
    if (oddFlag) from++;
    iptr-=rowInc;
  }
}
/* \\\ */

/* /// "DecodeRGB32toRGB()" */
__asm void DecodeRGB32toRGB(REG(a0) uchar *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) struct RGBData *spec)
{
  long x,y;
  uchar *iptr;
  ulong rowInc=width*4;

  iptr=to+(height-1)*width*4;
  for (y=height-1; y>0; y--) {
    uchar *ip=iptr;
    for (x=width; x>0; x--) {
      ip[1]=from[2];
      ip[2]=from[1];
      ip[3]=from[0];
      ip+=4;
      from+=4;
    }
    iptr-=rowInc;
  }
}
/* \\\ */

/* /// "DecodeRGB32to332()" */
__asm void DecodeRGB32to332(REG(a0) uchar *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) struct RGBData *spec)
{
  long x,y;
  uchar *iptr;
  ulong rowInc=width;

  iptr=to+(height-1)*width;
  for (y=height-1; y>0; y--) {
    uchar *ip=iptr;
    for (x=width; x>0; x--) {
      RGB24toColor(from[2],from[1],from[0],*ip++);
      from+=4;
    }
    iptr-=rowInc;
  }
}
/* \\\ */

/* /// "DecodeRGB32to332Dith()" */
__asm void DecodeRGB32to332Dith(REG(a0) uchar *from,
                                REG(a1) uchar *to,
                                REG(d0) ulong width,
                                REG(d1) ulong height,
                                REG(d2) ulong encSize,
                                REG(a2) struct RGBData *spec)
{
  long x, y;
  uchar *iptr;
  uchar oddFlag;
  ulong rowInc=width;

  iptr=to+(height-1)*width;
  oddFlag=width & 0x01;
  for (y=height-1; y>0; y--) {
    long re=0, ge=0, be=0;
    uchar *ip=iptr;
    for (x=width; x>0; x--) {
      ulong r, g, b;
      r=from[2];
      g=from[1];
      b=from[0];
      DitherGetRGB(r,g,b,re,ge,be,*ip++);
      from+=4;
    }
    if (oddFlag) from++;
    iptr-=rowInc;
  }
}
/* \\\ */

