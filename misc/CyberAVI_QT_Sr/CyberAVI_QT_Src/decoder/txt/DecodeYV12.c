/*
sc:c/sc opt txt/DecodeYV12.c
*/

#include "Decode.h"
#include "YUV.h"
#include "GlobalVars.h"
#include "Utils.h"

struct YV12Data {
  ulong dummy;
};

extern void __regargs YUV221111toRGB(uchar *image, ulong width, ulong height, ulong ix, ulong iy);
extern void __regargs YUV221111to332(uchar *image, ulong width, ulong height, ulong ix, ulong iy);
extern void __regargs YUV221111to332Dith(uchar *image, ulong width, ulong height, ulong ix, ulong iy);

void __regargs (*yv12yuv221111) (uchar *image, ulong width, ulong height, ulong ix, ulong iy);

/* /// "SelectYV12Funcs()" */
__asm void SelectYV12Funcs(REG(a0) struct YV12Data *spec,
                           REG(d0) uchar _gray,
                           REG(d1) uchar _dither)
{
  if (_gray) {
    yv12yuv221111=YUV221111to332;
  } else if (_dither) {
    yv12yuv221111=YUV221111to332Dith;
  } else {
    yv12yuv221111=YUV221111toRGB;
  }
}
/* \\\ */

/* /// "DecodeYV12()" */
__asm void DecodeYV12(REG(a0) uchar *from,
                      REG(a1) uchar *to,
                      REG(d0) ulong width,
                      REG(d1) ulong height,
                      REG(d2) ulong encSize,
                      REG(a2) struct YV12Data *spec)
{
  ulong size=width*height;
  struct YUVBuffer buf;

  if (gray)
    mycopymem((ulong *)from,(ulong *)to,size);
  else {
    yuvBuf=&buf;
    buf.yBuf=from;
    buf.uBuf=from+size+(size>>2);
    buf.vBuf=from+size;
    yv12yuv221111(to,width,height,width,height);
  }
}
/* \\\ */

