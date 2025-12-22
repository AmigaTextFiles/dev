#ifndef YUV_H
#define YUV_H

#include "Decode.h"

/* /// "DecYUVRGB" */
#define DecYUVRGB(ip,y,v2r,uv2g,u2b) {      \
  register long yy=yTab[y];                 \
  ip.alpha=0;                               \
  ip.red=(uchar)(rngLimit[(yy+v2r)>>6]);    \
  ip.green=(uchar)(rngLimit[(yy+uv2g)>>6]); \
  ip.blue=(uchar)(rngLimit[(yy+u2b)>>6]);   \
}
/* \\\ */

/* /// "DecYUV332" */
#define DecYUV332(ip,y,v2r,uv2g,u2b) { \
  register long _r, _g, _b, yy;        \
  yy=yTab[y];                          \
  _r=(long)(rngLimit[(yy+v2r)>>6]);    \
  _g=(long)(rngLimit[(yy+uv2g)>>6]);   \
  _b=(long)(rngLimit[(yy+u2b)>>6]);    \
  *ip++=RGBto332(_r,_g,_b,scale8);     \
}
/* \\\ */

/* /// "DecYUV332Dith" */
#define DecYUV332Dith(val,y,v2r,uv2g,u2b) {             \
  long _r, _g, _b, yy;                                  \
  yy=yTab[y];                                           \
  _r=rngLimit[((yy+v2r) >> 6)+re];                      \
  _g=rngLimit[((yy+uv2g) >> 6)+ge];                     \
  _b=rngLimit[((yy+u2b) >> 6)+be];                      \
  yy=(_r & 0xe0) | ((_g & 0xe0)>>3) | ((_b & 0xc0)>>6); \
  re=_r-pens[yy].red;                                   \
  ge=_g-pens[yy].green;                                 \
  be=_b-pens[yy].blue;                                  \
  val=remap[yy];                                        \
}
/* \\\ */

/* /// "YUVtoRGB" */
#define YUVtoRGB(y,cr,cg,cb,tripl) { \
  long yy=yuvTab->yTab[y];           \
  tripl.alpha=0;                     \
  tripl.red=rngLimit[(yy+cr)>>6];    \
  tripl.green=rngLimit[(yy+cg)>>6];  \
  tripl.blue=rngLimit[(yy+cb)>>6];   \
}
/* \\\ */

/* /// "YUVto332" */
#define YUVto332(y,cr,cg,cb,clr) { \
  long r, g, b;                    \
  long yy=yuvTab->yTab[y];         \
  r=rngLimit[(yy+cr)>>6];          \
  g=rngLimit[(yy+cg)>>6];          \
  b=rngLimit[(yy+cb)>>6];          \
  RGB24toColor(r,g,b,clr);         \
}
/* \\\ */

/* /// "dith2x2CGen" */
#define dith2x2CGen(_cc,_Y,r,g,b,re,ge,be) { \
  r=rngLimit[((_Y+cr) >> 6)+re];             \
  g=rngLimit[((_Y+cg) >> 6)+ge];             \
  b=rngLimit[((_Y+cb) >> 6)+be];             \
  RGB24toColorNoMap(r,g,b,clr);              \
  _cc=remap[clr];                            \
}
/* \\\ */

/* /// "dith2x2EGen" */
#define dith2x2EGen(clr,r,g,b,re,ge,be) { \
  re=r-pens[clr].red;                     \
  ge=g-pens[clr].green;                   \
  be=b-pens[clr].blue;                    \
}
/* \\\ */

/* /// "DitherGetRGB" */
#define DitherGetRGB(r,g,b,re,ge,be,col) {                \
  long r1, g1, b1;                                        \
  ulong idx;                                              \
  r1=(long)rngLimit[r+re];                                \
  g1=(long)rngLimit[g+ge];                                \
  b1=(long)rngLimit[b+be];                                \
  RGB24toColorNoMap(r1,g1,b1,idx);                        \
  re=r1-pens[idx].red;                                    \
  ge=g1-pens[idx].green;                                  \
  be=b1-pens[idx].blue;                                   \
  col=remap[idx];                                         \
}
/* \\\ */

/* /// "iDecYUVRGB" */
#define iDecYUVRGB(ip,y,v2r,uv2g,u2b) {       \
  long yy=yTab[y];                            \
  ip.alpha=0;                                 \
  ip.red  =(uchar)(rngLimit[(yy+v2r)>>6]);    \
  ip.green=(uchar)(rngLimit[(yy+uv2g)>>6]);   \
  ip.blue =(uchar)(rngLimit[(yy+u2b)>>6]);    \
}
/* \\\ */

#endif

