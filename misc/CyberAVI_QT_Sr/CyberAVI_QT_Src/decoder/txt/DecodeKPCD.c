/*
sc:c/sc opt txt/DecodeKPCD.c
*/

#include "Decode.h"
#include "YUV.h"
#include "GlobalVars.h"
#include "Utils.h"

struct KPCDData {
  ulong dummy;
};

void __regargs YUV221111toRGB(uchar *image, ulong width, ulong height, ulong ix, ulong iy);
void __regargs YUV221111to332(uchar *image, ulong width, ulong height, ulong ix, ulong iy);
void __regargs YUV221111to332Dith(uchar *image, ulong width, ulong height, ulong ix, ulong iy);

void __regargs (*yuv221111) (uchar *image, ulong width, ulong height, ulong ix, ulong iy);
ulong kpcdRowIncMult;

/* /// "SelectKPCDFuncs()" */
__asm void SelectKPCDFuncs(REG(a0) struct KPCDData *spec,
                           REG(d0) uchar _gray,
                           REG(d1) uchar _dither)
{
  if (_gray) {
    yuv221111=YUV221111to332;
    kpcdRowIncMult=1;
  } else if (_dither) {
    yuv221111=YUV221111to332Dith;
    kpcdRowIncMult=1;
  } else {
    yuv221111=YUV221111toRGB;
    kpcdRowIncMult=4;
  }
}
/* \\\ */

/* /// "DecodeKPCD()" */
__asm void DecodeKPCD(REG(a0) uchar *from,
                      REG(a1) uchar *to,
                      REG(d0) ulong width,
                      REG(d1) ulong height,
                      REG(d2) ulong encSize,
                      REG(a2) struct KPCDData *spec)
{
  uchar *dp=from, *ip=to;
  ulong halfWidth=width>>1;
  ulong doubWidth=width<<1;
  ulong srcInc=width*3;
  ulong rowInc=doubWidth;
  struct YUVBuffer yuv;

  if (gray) {
    while (height>1) {
      mycopymem((ulong *)dp,(ulong *)ip,doubWidth); // bei Graustufen nur y-Plane kopieren, viel schneller als Kopieren in YUV-Routine
      dp+=srcInc;
      ip+=rowInc;
      height-=2;
    }
    if (height) mycopymem((ulong *)dp,(ulong *)ip,width);
  } else {
    rowInc*=kpcdRowIncMult;
    yuvBuf=&yuv;
    while (height>1) {
      yuv.yBuf=dp;
      yuv.uBuf=dp+doubWidth;
      yuv.vBuf=dp+doubWidth+halfWidth;
      yuv221111(ip,width,2,width,2);
      dp+=srcInc;
      ip+=rowInc;
      height-=2;
    }
    if (height) {
      yuv.yBuf=dp;
      yuv.uBuf=dp+width;
      yuv.vBuf=dp+width+halfWidth;
      yuv221111(ip,width,1,width,1);
    }
  }
}
/* \\\ */

/* /// "YUV221111toRGB()" */
void __regargs YUV221111toRGB(uchar *to,
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
  ulong flag=0;

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
    if (flag==0)
      flag=1;
    else {
      flag=0;
      uBuf+=(ix>>1);
      vBuf+=(ix>>1);
    }
  }
}
/* \\\ */

/* /// "YUV221111to332()" */
void __regargs YUV221111to332(uchar *to,
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
  ulong flag=0;

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
    if (flag==0)
      flag=1;
    else {
      flag=0;
      uBuf+=(ix>>1);
      vBuf+=(ix>>1);
    }
  }
}
/* \\\ */

/* /// "YUV221111to332Dith()" */
void __regargs YUV221111to332Dith(uchar *to,
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

  while (my>0) {
    ulong x=mx;
    long re=0, ge=0, be=0;
    uchar *ip0, *ip1;
    uchar *yp0, *yp1;
    uchar *up=uBuf;
    uchar *vp=vBuf;
    ip0=to;
    yp0=yBuf;
    if (my>1) {
      ip1=ip0+width;
      yp1=yp0+width;
      my-=2;
    } else {
      ip1=ip0;
      yp1=yp0;
      my=0;
    }
    while (x--) {
      ulong iu=*up++;
      ulong iv=*vp++;
      long v2r=vrTab[iv];
      long uv2g=vgTab[iv]+ugTab[iu];
      long u2b=ubTab[iu];

      DecYUV332Dith(*ip0++,*yp0++,v2r,uv2g,u2b);
      re>>=1; ge>>=1; be>>=1;
      DecYUV332Dith(*ip1++,*yp1++,v2r,uv2g,u2b);
      re>>=1; ge>>=1; be>>=1;
      DecYUV332Dith(*ip1++,*yp1++,v2r,uv2g,u2b);
      re>>=1; ge>>=1; be>>=1;
      DecYUV332Dith(*ip0++,*yp0++,v2r,uv2g,u2b);
      re>>=1; ge>>=1; be>>=1;
    }
    to+=(width<<1);
    yBuf+=(ix<<1);
    uBuf+=(ix>>1);
    vBuf+=(ix>>1);
  }
}
/* \\\ */

