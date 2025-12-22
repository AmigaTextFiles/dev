/*
sc:c/sc opt txt/DecodeYUV9.c
*/

#include "Decode.h"
#include "Utils.h"
#include "YUV.h"
#include "GlobalVars.h"

struct YUV9Data {
  ulong dummy;
};

void __regargs YUV441111toRGB(uchar *image, ulong width, ulong height, ulong ix, ulong iy);
void __regargs YUV441111to332(uchar *image, ulong width, ulong height, ulong ix, ulong iy);
void __regargs YUV441111to332Dith(uchar *image, ulong width, ulong height, ulong ix, ulong iy);

void __regargs (*yuv441111) (uchar *image, ulong width, ulong height, ulong ix, ulong iy);

/* /// "SelectYUV9Funcs()" */
__asm void SelectYUV9Funcs(REG(a0) struct YUV9Data *spec,
                           REG(d0) uchar _gray,
                           REG(d1) uchar _dither)
{
  if (_gray) {
    yuv441111=YUV441111to332;
  } else if (_dither) {
    yuv441111=YUV441111to332Dith;
  } else {
    yuv441111=YUV441111toRGB;
  }
}
/* \\\ */

/* /// "DecodeYUV9()" */
__asm void DecodeYUV9(REG(a0) uchar *from,
                      REG(a1) uchar *to,
                      REG(d0) ulong width,
                      REG(d1) ulong height,
                      REG(d2) ulong encSize,
                      REG(a2) struct YUV9Data *spec)
{
  ulong size=width*height;
  struct YUVBuffer buf;

  if (gray)
    mycopymem((ulong *)from,(ulong *)to,size); // bei Graustufen nur y-Plane kopieren, viel schneller als Kopieren in YUV-Routine
  else {
    yuvBuf=&buf;
    buf.yBuf=from;
    buf.uBuf=from+size+(size>>4);
    buf.vBuf=from+size;
    yuv441111(to,width,height,width,height);
  }
}
/* \\\ */

/* /// "YUV441111toRGB()" */
void __regargs YUV441111toRGB(uchar *to,
                              ulong width,
                              ulong height,
                              ulong ix,
                              ulong iy)
{
  ulong x,y;
  ulong iRowInc=width;
  ulong yRowInc=ix-3;
  ulong iRowInc12=4*(width<<2);
  ulong bufInc=(((ix>>2)+3)>>2)<<2;
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  for(y=0; y<height; y+=4) {
    RGBTriple *iptr=(RGBTriple *)to;
    uchar *yptr=yBuf;
    uchar *up=uBuf;
    uchar *vp=vBuf;
    for(x=0; x<width; x+=4) {
      RGBTriple *ip=iptr;
      uchar *yp=yptr;
      long v2r,uv2g,u2b;
      ulong iu,iv,cnt;
      iptr+=4;
      yptr+=4;
      iu=*up++;
      iv=*vp++;
      v2r=vrTab[iv];
      uv2g=vgTab[iv]+ugTab[iu];
      u2b=ubTab[iu];
      for (cnt=0; cnt<4; cnt++) {
        DecYUVRGB(ip[0],*yp++,v2r,uv2g,u2b);
        DecYUVRGB(ip[1],*yp++,v2r,uv2g,u2b);
        DecYUVRGB(ip[2],*yp++,v2r,uv2g,u2b);
        DecYUVRGB(ip[3],*yp  ,v2r,uv2g,u2b);
        ip+=iRowInc;
        yp+=yRowInc;
      }
    }
    to+=iRowInc12;
    yBuf+=(ix<<2);
    uBuf+=bufInc;
    vBuf+=bufInc;
  }
}
/* \\\ */

/* /// "YUV441111to332()" */
void __regargs YUV441111to332(uchar *to,
                              ulong width,
                              ulong height,
                              ulong ix,
                              ulong iy)
{
  ulong x, y;
  ulong iRowInc=width-4;
  ulong yRowInc=ix-3;
  ulong bufInc=(((ix>>2)+3)>>2)<<2;
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  for(y=0; y<height; y+=4) {
    uchar *iptr=(uchar *)to;
    uchar *yptr=yBuf;
    uchar *up=uBuf;
    uchar *vp=vBuf;
    for(x=0; x<width; x+=4) {
      uchar *ip=iptr;
      uchar *yp=yptr;
      long v2r, uv2g, u2b;
      ulong iu, iv, cnt;
      iptr+=4;
      yptr+=4;
      iu=*up++;
      iv=*vp++;
      v2r=vrTab[iv];
      uv2g=vgTab[iv]+ugTab[iu];
      u2b=ubTab[iu];
      for (cnt=0; cnt<4; cnt++) {
        DecYUV332(ip,*yp++,v2r,uv2g,u2b);
        DecYUV332(ip,*yp++,v2r,uv2g,u2b);
        DecYUV332(ip,*yp++,v2r,uv2g,u2b);
        DecYUV332(ip,*yp  ,v2r,uv2g,u2b);
        ip+=iRowInc;
        yp+=yRowInc;
      }
    }
    to+=(width<<2);
    yBuf+=(ix<<2);
    uBuf+=bufInc;
    vBuf+=bufInc;
  }
}
/* \\\ */

/* /// "YUV441111to332Dith()" */
void __regargs YUV441111to332Dith(uchar *to,
                                  ulong width,
                                  ulong height,
                                  ulong ix,
                                  ulong iy)
{
  ulong x, y;
  ulong iRowInc=width-3;
  ulong bufInc=(((ix>>2)+3)>>2)<<2;
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  for(y=0; y<height; y+=4) {
    uchar *iptr=to, *yptr=yBuf;
    uchar *up=uBuf, *vp=vBuf;
    long re=0, ge=0, be=0;
    for(x=0; x<width; x+=4) {
      uchar *ip=iptr;
      uchar *yp0, *yp1, *yp2, *yp3;
      long v2r, uv2g, u2b;
      ulong iu, iv;
      ulong r00, r01, r02, r03;
      ulong r10, r11, r12, r13;
      ulong r20, r21, r22, r23;
      ulong r30, r31, r32, r33;
      yp0=yptr;
      yp1=yp0+ix;
      yp2=yp1+ix;
      yp3=yp2+ix;
      iptr+=4;
      yptr+=4;
      iu=*up++;
      iv=*vp++;
      v2r=vrTab[iv];
      uv2g=vgTab[iv]+ugTab[iu];
      u2b=ubTab[iu];
      DecYUV332Dith(r00,*yp0++,v2r,uv2g,u2b);
      DecYUV332Dith(r10,*yp1++,v2r,uv2g,u2b);
      DecYUV332Dith(r20,*yp2++,v2r,uv2g,u2b);
      DecYUV332Dith(r30,*yp3++,v2r,uv2g,u2b);

      DecYUV332Dith(r31,*yp3++,v2r,uv2g,u2b);
      DecYUV332Dith(r21,*yp2++,v2r,uv2g,u2b);
      DecYUV332Dith(r11,*yp1++,v2r,uv2g,u2b);
      DecYUV332Dith(r01,*yp0++,v2r,uv2g,u2b);

      DecYUV332Dith(r02,*yp0++,v2r,uv2g,u2b);
      DecYUV332Dith(r12,*yp1++,v2r,uv2g,u2b);
      DecYUV332Dith(r22,*yp2++,v2r,uv2g,u2b);
      DecYUV332Dith(r32,*yp3++,v2r,uv2g,u2b);

      DecYUV332Dith(r33,*yp3  ,v2r,uv2g,u2b);
      DecYUV332Dith(r23,*yp2  ,v2r,uv2g,u2b);
      DecYUV332Dith(r13,*yp1  ,v2r,uv2g,u2b);
      DecYUV332Dith(r03,*yp0  ,v2r,uv2g,u2b);

      *ip++=r00; *ip++=r01; *ip++=r02; *ip  =r03; ip+=iRowInc;
      *ip++=r10; *ip++=r11; *ip++=r12; *ip  =r13; ip+=iRowInc;
      *ip++=r20; *ip++=r21; *ip++=r22; *ip  =r23; ip+=iRowInc;
      *ip++=r30; *ip++=r31; *ip++=r32; *ip  =r33;
    }
    to+=(width<<2);
    yBuf+=(ix<<2);
    uBuf+=bufInc;
    vBuf+=bufInc;
  }
}
/* \\\ */

