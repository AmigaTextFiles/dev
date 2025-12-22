/*
sc:c/sc opt txt/DecodeYUV2.c
*/

#include "Decode.h"
#include "YUV.h"
#include "GlobalVars.h"
#include "Utils.h"

struct YUV2Data {
  ulong dummy;
};

void __regargs YUV211111toRGB(uchar *image, ulong width, ulong height, ulong ix, ulong iy);
void __regargs YUV211111to332(uchar *image, ulong width, ulong height, ulong ix, ulong iy);
void __regargs YUV211111to332Dith(uchar *image, ulong width, ulong height, ulong ix, ulong iy);

void __regargs (*yuv211111) (uchar *image, ulong width, ulong height, ulong ix, ulong iy);
ulong yuv2RowIncMult;

/* /// "SelectYUV2Funcs()" */
__asm void SelectYUV2Funcs(REG(a0) struct YUV2Data *spec,
                           REG(d0) uchar _gray,
                           REG(d1) uchar _dither)
{
  if (_gray) {
    yuv211111=YUV211111to332;
    yuv2RowIncMult=1;
  } else if (_dither) {
    yuv211111=YUV211111to332Dith;
    yuv2RowIncMult=1;
  } else {
    yuv211111=YUV211111toRGB;
    yuv2RowIncMult=4;
  }
}
/* \\\ */

/* /// "DecodeYUV2A()" */
__asm void DecodeYUV2A(REG(a0) uchar *from,
                       REG(a1) uchar *to,
                       REG(d0) ulong width,
                       REG(d1) ulong height,
                       REG(d2) ulong encSize,
                       REG(a2) struct YUV2Data *spec)
{
  uchar *ip=to;
  ulong rowInc=(width<<1)*yuv2RowIncMult;
  ulong mx=width>>1;
  ulong ycnt=0;
  ulong y=height;

  while(y>0) {
    uchar *yp, *up, *vp;
    ulong x=mx;
    if(ycnt==0) {
      yp=yuvBuf->yBuf;
      up=yuvBuf->uBuf;
      vp=yuvBuf->vBuf;
    }
    while(x--) {
      *yp++=from[0];
      *up++=(from[1])^0x80;
      *yp++=from[2];
      *vp++=(from[3])^0x80;
      from+=4;
    }
    ycnt++;
    y--;
    if((ycnt>=2) || (y==0)) {
      if (gray) mycopymem((ulong *)yuvBuf->yBuf,(ulong *)ip,rowInc);
      else yuv211111(ip,width,ycnt,width,ycnt);
      ycnt=0;
      ip+=rowInc;
    }
  }
}
/* \\\ */

/* /// "DecodeYUV2B()" */
__asm void DecodeYUV2B(REG(a0) uchar *from,
                       REG(a1) uchar *to,
                       REG(d0) ulong width,
                       REG(d1) ulong height,
                       REG(d2) ulong encSize,
                       REG(a2) struct YUV2Data *spec)
{
  uchar *ip=to;
  ulong rowInc=(width<<1)*yuv2RowIncMult;
  ulong mx=width>>1;
  ulong ycnt=0;
  ulong y=height;

  while(y>0) {
    uchar *yp,*up,*vp;
    ulong x=mx;
    if(ycnt==0) {
      yp=yuvBuf->yBuf;
      up=yuvBuf->uBuf;
      vp=yuvBuf->vBuf;
    }
    while(x--) {
      *yp++=from[0];
      *up++=from[1];
      *yp++=from[2];
      *vp++=from[3];
      from+=4;
    }
    ycnt++;
    y--;
    if((ycnt>=2) || (y==0)) {
      if (gray) mycopymem((ulong *)yuvBuf->yBuf,(ulong *)ip,rowInc);
      else yuv211111(ip,width,ycnt,width,ycnt);
      ycnt=0;
      ip+=rowInc;
    }
  }
}
/* \\\ */

/* /// "YUV211111toRGB()" */
void __regargs YUV211111toRGB(uchar *to,
                              ulong width,
                              ulong height,
                              ulong ix,
                              ulong iy)
{
  ulong mx=(width>>1);
  ulong my=height;
  ulong inc=width*4;
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  while (my--) {
    RGBTriple *ip=(RGBTriple *)to;
    uchar *yp=yBuf;
    uchar *up=uBuf;
    uchar *vp=vBuf;
    ulong x=mx;
    while (x--) {
      ulong iu=*up++;
      ulong iv=*vp++;
      long v2r=vrTab[iv];
      long uv2g=vgTab[iv]+ugTab[iu];
      long u2b=ubTab[iu];
      DecYUVRGB(ip[0],*yp++,v2r,uv2g,u2b);
      DecYUVRGB(ip[1],*yp++,v2r,uv2g,u2b);
      ip+=2;
    }
    to+=inc;
    yBuf+=ix;
    uBuf+=(ix>>1);
    vBuf+=(ix>>1);
  }
}
/* \\\ */

/* /// "YUV211111to332()" */
void __regargs YUV211111to332(uchar *to,
                              ulong width,
                              ulong height,
                              ulong ix,
                              ulong iy)
{
  ulong mx=(width>>1);
  ulong my=height;
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  while (my--) {
    uchar *ip=(uchar *)to;
    uchar *yp=yBuf;
    uchar *up=uBuf;
    uchar *vp=vBuf;
    ulong x=mx;
    while (x--) {
      ulong iu=*up++;
      ulong iv=*vp++;
      long v2r=vrTab[iv];
      long uv2g=vgTab[iv]+ugTab[iu];
      long u2b=ubTab[iu];

      DecYUV332(ip,*yp++,v2r,uv2g,u2b);
      DecYUV332(ip,*yp++,v2r,uv2g,u2b);
    }
    to+=width;
    yBuf+=ix;
    uBuf+=(ix>>1);
    vBuf+=(ix>>1);
  }
}
/* \\\ */

/* /// "YUV211111to332Dith()" */
void __regargs YUV211111to332Dith(uchar *to,
                                  ulong width,
                                  ulong height,
                                  ulong ix,
                                  ulong iy)
{
  ulong mx=(width>>1);
  ulong my=height;
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  while (my) {
    ulong x=mx;
    long re=0, ge=0, be=0;
    uchar *ip0, *ip1;
    uchar *yp0, *yp1;
    uchar *up0, *up1;
    uchar *vp0, *vp1;
    ip0=to;
    yp0=yBuf;
    up0=uBuf;
    vp0=vBuf;
    if (my>1) {
      ip1=ip0+width;
      yp1=yp0+ix;
      up1=up0+(ix>>2);
      vp1=vp0+(ix>>2);
      my-=2;
    } else {
      ip1=ip0;
      yp1=yp0;
      up1=up0;
      vp1=vp0;
      my=0;
    }
    while (x--) {
      ulong iu, iv;
      long v2r0, uv2g0, u2b0;
      long v2r1, uv2g1, u2b1;
      iu=*up0++;
      iv=*vp0++;
      v2r0=vrTab[iv];
      uv2g0=vgTab[iv]+ugTab[iu];
      u2b0=ubTab[iu];
      iu=*up1++;
      iv=*vp1++;
      v2r1=vrTab[iv];
      uv2g1=vgTab[iv]+ugTab[iu];
      u2b1=ubTab[iu];

      DecYUV332Dith(*ip0++,*yp0++,v2r0,uv2g0,u2b0);
      re>>=1; ge>>=1; be>>=1;
      DecYUV332Dith(*ip1++,*yp1++,v2r1,uv2g1,u2b1);
      re>>=1; ge>>=1; be>>=1;

      DecYUV332Dith(*ip1++,*yp1++,v2r1,uv2g1,u2b1);
      re>>=1; ge>>=1; be>>=1;
      DecYUV332Dith(*ip0++,*yp0++,v2r0,uv2g0,u2b0);
      re>>=1; ge>>=1; be>>=1;
    }
    to+=(width<<1);
    yBuf+=(ix<<1);
    uBuf+=(ix>>1);
    vBuf+=(ix>>1);
  }
}
/* \\\ */

