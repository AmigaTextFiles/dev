/*
sc:c/sc opt txt/DecodeCVID.c
*/

#include "Decode.h"
#include "Utils.h"
#include "YUV.h"
#include "GlobalVars.h"

/* /// "blockInc" */
#define blockInc(x,y,xmax) {  \
  x+=4;                       \
  if (x>=xmax) { x=0; y+=4; } \
}
/* \\\ */

#define cvidMaxStrips 16

/* /// "structs" */
struct Color2x2 {
  RGBTriple rgb0, rgb1, rgb2, rgb3;
  ulong clr00, clr01, clr02, clr03;
  ulong clr10, clr11, clr12, clr13;
  ulong clr20, clr21, clr22, clr23;
  ulong clr30, clr31, clr32, clr33;
};

struct CVIDData {
  struct Color2x2 *cvidMaps0[cvidMaxStrips];
  struct Color2x2 *cvidMaps1[cvidMaxStrips];
  long cvidVMap0[cvidMaxStrips];
  long cvidVMap1[cvidMaxStrips];
};
/* \\\ */

/* /// "proto types" */
void __regargs YUV2x2toRGB(ulong y0, ulong y1, ulong y2, ulong y3, ulong u, ulong v, struct Color2x2 *cmap2x2);
void __regargs Color2x2Blk1RGB(uchar *to, ulong x, ulong y, ulong width, struct Color2x2 *cmap2x2);
void __regargs Color2x2Blk4RGB(uchar *to, ulong x, ulong y, ulong width, struct Color2x2 *cm0, struct Color2x2 *cm1, struct Color2x2 *cm2, struct Color2x2 *cm3);

void __regargs YUV2x2toGray(ulong y0, ulong y1, ulong y2, ulong y3, ulong u, ulong v, struct Color2x2 *cmap2x2);
void __regargs Color2x2Blk1Gray(uchar *to, ulong x, ulong y, ulong width, struct Color2x2 *cmap2x2);
void __regargs Color2x2Blk4Gray(uchar *to, ulong x, ulong y, ulong width, struct Color2x2 *cm0, struct Color2x2 *cm1, struct Color2x2 *cm2, struct Color2x2 *cm3);

void __regargs YUV2x2to332Dith14(ulong y0, ulong y1, ulong y2, ulong y3, ulong u, ulong v, struct Color2x2 *cmap2x2);
void __regargs YUV2x2to332Dith42(ulong y0, ulong y1, ulong y2, ulong y3, ulong u, ulong v, struct Color2x2 *cmap2x2);
void __regargs Color2x2Blk1332Dith(uchar *to, ulong x, ulong y, ulong width, struct Color2x2 *cmap2x2);
void __regargs Color2x2Blk4332Dith(uchar *to, ulong x, ulong y, ulong width, struct Color2x2 *cm0, struct Color2x2 *cm1, struct Color2x2 *cm2, struct Color2x2 *cm3);
/* \\\ */

void __regargs (*yuv2x2_14) (ulong y0, ulong y1, ulong y2, ulong y3, ulong u, ulong v, struct Color2x2 *cmap2x2);
void __regargs (*yuv2x2_42) (ulong y0, ulong y1, ulong y2, ulong y3, ulong u, ulong v, struct Color2x2 *cmap2x2);
void __regargs (*color2x2blk1) (uchar *to, ulong x, ulong y, ulong width, struct Color2x2 *cmap2x2);
void __regargs (*color2x2blk4) (uchar *to, ulong x, ulong y, ulong width, struct Color2x2 *cm0, struct Color2x2 *cm1, struct Color2x2 *cm2, struct Color2x2 *cm3);

/* /// "SelectCVIDFuncs()" */
__asm void SelectCVIDFuncs(REG(a0) struct CVIDData *spec,
                           REG(d0) uchar _gray,
                           REG(d1) uchar _dither)
{
  if (_gray) {
    yuv2x2_14=YUV2x2toGray;
    yuv2x2_42=YUV2x2toGray;
    color2x2blk1=Color2x2Blk1Gray;
    color2x2blk4=Color2x2Blk4Gray;
  } else if (_dither) {
    yuv2x2_14=YUV2x2to332Dith14;
    yuv2x2_42=YUV2x2to332Dith42;
    color2x2blk1=Color2x2Blk1332Dith;
    color2x2blk4=Color2x2Blk4332Dith;
  } else {
    yuv2x2_14=YUV2x2toRGB;
    yuv2x2_42=YUV2x2toRGB;
    color2x2blk1=Color2x2Blk1RGB;
    color2x2blk4=Color2x2Blk4RGB;
  }
}
/* \\\ */

/* /// "DecodeCVID()" */
__asm void DecodeCVID(REG(a0) uchar *from,
                      REG(a1) uchar *to,
                      REG(d0) ulong width,
                      REG(d1) ulong height,
                      REG(d2) ulong encSize,
                      REG(a2) struct CVIDData *spec)
{
  long x, y, cvidMapNum;
  ulong len;
  ulong kk, strips, cNum, yTop;

  x=0;
  y=0;
  yTop=0;
  from++;
  len=get24(from);
  if (len!=encSize) {
    if (len & 0x01) len++;
    if (len!=encSize) return;
  }
  /* xsz=get16(from); ysz=get16(from); */
  from+=4;
  strips=get16(from);
  cvidMapNum=strips;

  for (kk=0; kk<strips; kk++) {
    ulong i, topCid, cid, x0, y0, x1, y1;
    long topSize, cSize;
    struct Color2x2 *cvidCMap0=spec->cvidMaps0[kk];
    struct Color2x2 *cvidCMap1=spec->cvidMaps1[kk];
    if (spec->cvidVMap0[kk]==0) {
      ulong idx;
      struct Color2x2 *src, *dst;
      idx=(kk==0)?(strips-1):(kk-1);
      src=spec->cvidMaps0[idx];
      dst=spec->cvidMaps0[kk];
      spec->cvidVMap0[kk]=1;
      mycopymem((ulong *)&src[0],(ulong *)&dst[0],sizeof(struct Color2x2)*256); /* früher :for (i=0; i<256; i++) dst[i]=src[i] */
    }
    if (spec->cvidVMap1[kk]==0) {
      ulong idx;
      struct Color2x2 *src, *dst;
      idx=(kk==0)?(strips-1):(kk-1);
      src=spec->cvidMaps1[idx];
      dst=spec->cvidMaps1[kk];
      spec->cvidVMap1[kk]=1;
      mycopymem((ulong *)&src[0],(ulong *)&dst[0],sizeof(struct Color2x2)*256); /* früher :for (i=0; i<256; i++) dst[i]=src[i] */
    }
    from+=2; /* topCid=get16(from); */
    topSize=get16(from);
    from+=4; /* y0=get16(from); x0=get16(from); */
    y1=get16(from);
    from+=2; /* x1=get16(from); */

    yTop+=y1;
    topSize-=12;
    x=0;
    /* if (x1!=width) {} */
    while (topSize>0) {
      cid=get16(from);
      cSize=get16(from);
      topSize-=cSize;
      cSize-=4;
      switch (cid) {
        case 0x2000:
        case 0x2200:
          { ulong i;
            struct Color2x2 *cvidMap;
            void __regargs (*yuv2x2) (ulong y0, ulong y1, ulong y2, ulong y3, ulong u, ulong v, struct Color2x2 *cmap2x2);
            if (cid==0x2200) {
              cvidMap=cvidCMap1;
              for (i=0; i<cvidMapNum; i++) spec->cvidVMap1[i]=0;
              spec->cvidVMap1[kk]=1;
              yuv2x2=yuv2x2_14;
            } else {
              cvidMap=cvidCMap0;
              for (i=0; i<cvidMapNum; i++) spec->cvidVMap0[i]=0;
              spec->cvidVMap0[kk]=1;
              yuv2x2=yuv2x2_42;
            }
            cNum=cSize/6;
            for (i=0; i<cNum; i++) {
              ulong Y0, Y1, Y2, Y3, U, V;
              Y0=from[0];
              Y1=from[1];
              Y2=from[2];
              Y3=from[3];
              U=(from[4])^0x80;
              V=(from[5])^0x80;
              yuv2x2(Y0,Y1,Y2,Y3,U,V,cvidMap);
              cvidMap++;
              from+=6;
            }
          }
          break;

        case 0x2100:
        case 0x2300:
          { ulong k, flag, mask;
            struct Color2x2 *cvidMap;
            void __regargs (*yuv2x2) (ulong y0, ulong y1, ulong y2, ulong y3, ulong u, ulong v, struct Color2x2 *cmap2x2);
            if (cid==0x2300) {
              cvidMap=cvidCMap1;
              yuv2x2=yuv2x2_14;
            } else {
              cvidMap=cvidCMap0;
              yuv2x2=yuv2x2_42;
            }
            while (cSize>0) {
              flag=*(ulong *)from; from+=4; /* get32(from) */
              cSize-=4;
              mask=0x80000000;
              while (mask) { /* for (k=0; k<32; k++) { */
                if (mask & flag) {
                  ulong Y0, Y1, Y2, Y3, U, V;
                  Y0=from[0];
                  Y1=from[1];
                  Y2=from[2];
                  Y3=from[3];
                  U=(from[4])^0x80;
                  V=(from[5])^0x80;
                  cSize-=6;
                  from+=6;
                  yuv2x2(Y0,Y1,Y2,Y3,U,V,cvidMap);
                }
                cvidMap++;
                mask>>=1;
              }
            }
            /* if (cSize!=0) {} */
          }
          break;

        case 0x3000:
          { ulong flag;
            while ((cSize>0) && (y<yTop)) {
              ulong mask;
              long j;
              flag=*(ulong *)from; from+=4; /* get32(from) */
              cSize-=4;
              mask=0x80000000;
              while (mask) { /* for (j=0; j<32; j++) { */
                if (y>=yTop) break;
                if (mask & flag) {
                  ulong d0, d1, d2, d3;
                  d0=from[0];
                  d1=from[1];
                  d2=from[2];
                  d3=from[3];
                  cSize-=4;
                  from+=4;
                  color2x2blk4(to,x,y,width,&cvidCMap0[d0],&cvidCMap0[d1],&cvidCMap0[d2],&cvidCMap0[d3]);
                } else {
                  ulong d;
                  d=*from++;
                  cSize--;
                  color2x2blk1(to,x,y,width,&cvidCMap1[d]);
                }
                blockInc(x,y,width);
                mask>>=1;
              }
              if (cSize<4) {
                from+=cSize;
                cSize=0;
              }
            }
            if (cSize) from+=cSize;
          }
          break;

        case 0x3200:
          { while ((cSize>0) && (y<yTop)) {
              ulong d;
              d=*from++;
              cSize--;
              color2x2blk1(to,x,y,width,&cvidCMap1[d]);
              blockInc(x,y,width);
            }
            if (cSize) from+=cSize;
          }
          break;

        case 0x3100:
          { ulong flag, flag0, flag1, flag2;
            flag1=flag2=0;
            flag0=1;
            while ((cSize>0) && (y<yTop)) {
              ulong mCode;
              long j;
              flag=*(ulong *)from; from+=4; /* get32(from) */
              cSize-=4;
              for (j=30; j>=0; j-=2) {
                if (y>=yTop) break;
                mCode=(flag>>j) & 0x03;
                switch (mCode) {
                  case 0x0:
                    { flag0=1;
                      if (flag1) {
                        ulong d=*from++;
                        flag1=0;
                        cSize--;
                        color2x2blk1(to,x,y,width,&cvidCMap1[d]);
                      }
                      blockInc(x,y,width);
                    }
                    break;

                  case 0x1:
                    { flag1=1;
                      if ((flag2) || (flag0)) {
                        flag0=flag2=0;
                      } else {
                        ulong d=*from++;
                        cSize--;
                        color2x2blk1(to,x,y,width,&cvidCMap1[d]);
                      }
                    }
                    break;

                  case 0x2:
                    { flag2=1;
                      if (flag1) {
                        ulong d0, d1, d2, d3;
                        flag1=0;
                        d0=from[0];
                        d1=from[1];
                        d2=from[2];
                        d3=from[3];
                        cSize-=4;
                        from+=4;
                        color2x2blk4(to,x,y,width,&cvidCMap0[d0],&cvidCMap0[d1],&cvidCMap0[d2],&cvidCMap0[d3]);
                        blockInc(x,y,width);
                      } else {
                        ulong d=*from++;
                        cSize--;
                        color2x2blk1(to,x,y,width,&cvidCMap1[d]);
                      }
                    }
                    break;

                  case 0x3:
                    { ulong d0, d1, d2, d3;
                      d0=from[0];
                      d1=from[1];
                      d2=from[2];
                      d3=from[3];
                      cSize-=4;
                      from+=4;
                      color2x2blk4(to,x,y,width,&cvidCMap0[d0],&cvidCMap0[d1],&cvidCMap0[d2],&cvidCMap0[d3]);
                    }
                    break;
                }
                blockInc(x,y,width);
              }
            }
            if (cSize) from+=cSize;
          }
          break;

        case 0x2400:
        case 0x2600:
          { ulong i, cNum;
            struct Color2x2 *cvidMap;
            if (cid==0x2600) {
              cvidMap=cvidCMap1;
              for (i=0; i<cvidMapNum; i++) spec->cvidVMap1[i]=0;
              spec->cvidVMap1[kk]=1;
            } else {
              cvidMap=cvidCMap0;
              for (i=0; i<cvidMapNum; i++) spec->cvidVMap0[i]=0;
              spec->cvidVMap0[kk]=1;
            }
            if (dither) {
              color2x2blk1=Color2x2Blk1Gray;
              color2x2blk4=Color2x2Blk4Gray;
            }
            cNum=cSize/4;
            for (i=0; i<cNum; i++) {
              cvidMap[i].clr00=from[0];
              cvidMap[i].clr10=from[1];
              cvidMap[i].clr20=from[2];
              cvidMap[i].clr30=from[3];
              from+=4;
            }
          }
          break;

        case 0x2500:
        case 0x2700:
          { ulong k, flag, mask, ci;
            struct Color2x2 *cvidMap;
            if (cid==0x2700)
              cvidMap=cvidCMap1;
            else
              cvidMap=cvidCMap0;
            if (dither) {
              color2x2blk1=Color2x2Blk1Gray;
              color2x2blk4=Color2x2Blk4Gray;
            }
            ci=0;
            while (cSize>0) {
              flag=*(ulong *)from; from+=4; /* get32(from) */
              cSize-=4;
              mask=0x80000000;
              while (mask) { /* for (k=0; k<32; k++) { */
                if (mask & flag) {
                  cvidMap[ci].clr00=from[0];
                  cvidMap[ci].clr10=from[1];
                  cvidMap[ci].clr20=from[2];
                  cvidMap[ci].clr30=from[3];
                  from+=4;
                  cSize-=4;
                }
                ci++;
                mask>>=1;
              }
            }
            /* if (cSize!=0) {} */
          }
          break;

        default:
          return;
          break;
      }
    }
  }
}
/* \\\ */

/* /// "YUV2x2toRGB()" */
void __regargs YUV2x2toRGB(ulong y0,
                           ulong y1,
                           ulong y2,
                           ulong y3,
                           ulong u,
                           ulong v,
                           struct Color2x2 *cmap2x2)
{
  long cr, cg, cb;

  cr=yuvTab->vrTab[v];
  cg=yuvTab->ugTab[u]+yuvTab->vgTab[v];
  cb=yuvTab->ubTab[u];

  YUVtoRGB(y0,cr,cg,cb,cmap2x2->rgb0);
  YUVtoRGB(y1,cr,cg,cb,cmap2x2->rgb1);
  YUVtoRGB(y2,cr,cg,cb,cmap2x2->rgb2);
  YUVtoRGB(y3,cr,cg,cb,cmap2x2->rgb3);
}
/* \\\ */

/* /// "Color2x2Blk1RGB()" */
void __regargs Color2x2Blk1RGB(uchar *to,
                               ulong x,
                               ulong y,
                               ulong width,
                               struct Color2x2 *cm)
{
  ulong rowInc=width;
  RGBTriple *ip=(RGBTriple *)(to+(y*width+x)*4);

  ip[0]=cm->rgb0;
  ip[1]=cm->rgb0;
  ip[2]=cm->rgb1;
  ip[3]=cm->rgb1;
  ip+=rowInc;
  ip[0]=cm->rgb0;
  ip[1]=cm->rgb0;
  ip[2]=cm->rgb1;
  ip[3]=cm->rgb1;
  ip+=rowInc;
  ip[0]=cm->rgb2;
  ip[1]=cm->rgb2;
  ip[2]=cm->rgb3;
  ip[3]=cm->rgb3;
  ip+=rowInc;
  ip[0]=cm->rgb2;
  ip[1]=cm->rgb2;
  ip[2]=cm->rgb3;
  ip[3]=cm->rgb3;
}
/* \\\ */

/* /// "Color2x2Blk4RGB()" */
void __regargs Color2x2Blk4RGB(uchar *to,
                               ulong x,
                               ulong y,
                               ulong width,
                               struct Color2x2 *cm0,
                               struct Color2x2 *cm1,
                               struct Color2x2 *cm2,
                               struct Color2x2 *cm3)
{
  ulong rowInc=width;
  RGBTriple *ip=(RGBTriple *)(to+(y*width+x)*4);

  ip[0]=cm0->rgb0;
  ip[1]=cm0->rgb1;
  ip[2]=cm1->rgb0;
  ip[3]=cm1->rgb1;
  ip+=rowInc;
  ip[0]=cm0->rgb2;
  ip[1]=cm0->rgb3;
  ip[2]=cm1->rgb2;
  ip[3]=cm1->rgb3;
  ip+=rowInc;
  ip[0]=cm2->rgb0;
  ip[1]=cm2->rgb1;
  ip[2]=cm3->rgb0;
  ip[3]=cm3->rgb1;
  ip+=rowInc;
  ip[0]=cm2->rgb2;
  ip[1]=cm2->rgb3;
  ip[2]=cm3->rgb2;
  ip[3]=cm3->rgb3;
}
/* \\\ */

/* /// "YUV2x2toGray()" */
void __regargs YUV2x2toGray(ulong y0,
                            ulong y1,
                            ulong y2,
                            ulong y3,
                            ulong u,
                            ulong v,
                            struct Color2x2 *cmap2x2)
{
  cmap2x2->clr00=y0;
  cmap2x2->clr10=y1;
  cmap2x2->clr20=y2;
  cmap2x2->clr30=y3;
}
/* \\\ */

/* /// "Color2x2Blk1Gray()" */
void __regargs Color2x2Blk1Gray(uchar *to,
                                ulong x,
                                ulong y,
                                ulong width,
                                struct Color2x2 *cm)
{
  ulong rowInc=width;
  RGBTriple *ip=(RGBTriple *)(to+(y*width+x)*4);
  RGBTriple rgb0, rgb1;

  rgb0.alpha=0;
  rgb1.alpha=0;
  rgb0.red=rgb0.green=rgb0.blue=cm->clr00;
  rgb1.red=rgb1.green=rgb1.blue=cm->clr10;
  ip[0]=rgb0;
  ip[1]=rgb0;
  ip[2]=rgb1;
  ip[3]=rgb1;
  ip+=rowInc;
  ip[0]=rgb0;
  ip[1]=rgb0;
  ip[2]=rgb1;
  ip[3]=rgb1;
  ip+=rowInc;
  rgb0.red=rgb0.green=rgb0.blue=cm->clr20;
  rgb1.red=rgb1.green=rgb1.blue=cm->clr30;
  ip[0]=rgb0;
  ip[1]=rgb0;
  ip[2]=rgb1;
  ip[3]=rgb1;
  ip+=rowInc;
  ip[0]=rgb0;
  ip[1]=rgb0;
  ip[2]=rgb1;
  ip[3]=rgb1;
}
/* \\\ */

/* /// "Color2x2Blk4Gray()" */
void __regargs Color2x2Blk4Gray(uchar *to,
                                ulong x,
                                ulong y,
                                ulong width,
                                struct Color2x2 *cm0,
                                struct Color2x2 *cm1,
                                struct Color2x2 *cm2,
                                struct Color2x2 *cm3)
{
  ulong rowInc=width;
  RGBTriple *ip=(RGBTriple *)(to+(y*width+x)*4);
  RGBTriple rgb;

  rgb.alpha=0;
  rgb.red=rgb.green=rgb.blue=cm0->clr00;
  ip[0]=rgb;
  rgb.red=rgb.green=rgb.blue=cm0->clr10;
  ip[1]=rgb;
  rgb.red=rgb.green=rgb.blue=cm1->clr00;
  ip[2]=rgb;
  rgb.red=rgb.green=rgb.blue=cm1->clr10;
  ip[3]=rgb;
  ip+=rowInc;
  rgb.red=rgb.green=rgb.blue=cm0->clr20;
  ip[0]=rgb;
  rgb.red=rgb.green=rgb.blue=cm0->clr30;
  ip[1]=rgb;
  rgb.red=rgb.green=rgb.blue=cm1->clr20;
  ip[2]=rgb;
  rgb.red=rgb.green=rgb.blue=cm1->clr30;
  ip[3]=rgb;
  ip+=rowInc;
  rgb.red=rgb.green=rgb.blue=cm2->clr00;
  ip[0]=rgb;
  rgb.red=rgb.green=rgb.blue=cm2->clr10;
  ip[1]=rgb;
  rgb.red=rgb.green=rgb.blue=cm3->clr00;
  ip[2]=rgb;
  rgb.red=rgb.green=rgb.blue=cm3->clr10;
  ip[3]=rgb;
  ip+=rowInc;
  rgb.red=rgb.green=rgb.blue=cm2->clr20;
  ip[0]=rgb;
  rgb.red=rgb.green=rgb.blue=cm2->clr30;
  ip[1]=rgb;
  rgb.red=rgb.green=rgb.blue=cm3->clr20;
  ip[2]=rgb;
  rgb.red=rgb.green=rgb.blue=cm3->clr30;
  ip[3]=rgb;
}
/* \\\ */

/* /// "YUV2x2to332Dith14()" */
void __regargs YUV2x2to332Dith14(ulong y0,
                                 ulong y1,
                                 ulong y2,
                                 ulong y3,
                                 ulong u,
                                 ulong v,
                                 struct Color2x2 *cmap2x2)
{
  long cr, cg, cb;
  ulong clr;
  long r, g, b;
  long re, ge, be;
  long ya, yb, yc, yd;
  long yy0, yy1, yy2, yy3;

  cr=yuvTab->vrTab[v];
  cg=yuvTab->ugTab[u]+yuvTab->vgTab[v];
  cb=yuvTab->ubTab[u];

  yy0=(long)(yuvTab->yTab[y0]);
  yy1=(long)(yuvTab->yTab[y1]);
  yy2=(long)(yuvTab->yTab[y2]);
  yy3=(long)(yuvTab->yTab[y3]);

  ya=yy0;
  yb=(yy0+yy1) >> 1;
  yc=(yy0+yy2) >> 1;
  yd=(yy0+yy1+yy2+yy3) >> 2;

  dith2x2CGen(cmap2x2->clr03,yd,r,g,b,0,0,0);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  dith2x2CGen(cmap2x2->clr02,yc,r,g,b,re,ge,be);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  dith2x2CGen(cmap2x2->clr00,ya,r,g,b,re,ge,be);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  dith2x2CGen(cmap2x2->clr01,yb,r,g,b,re,ge,be);

  ya=(yy1+yy0) >> 1;
  yb=yy1;
  yc=(yy0+yy1+yy2+yy3) >> 2;
  yd=(yy1+yy3) >> 1;

  dith2x2CGen(cmap2x2->clr10,ya,r,g,b,0,0,0);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  dith2x2CGen(cmap2x2->clr11,yb,r,g,b,re,ge,be);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  dith2x2CGen(cmap2x2->clr13,yd,r,g,b,re,ge,be);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  dith2x2CGen(cmap2x2->clr12,yc,r,g,b,re,ge,be);

  ya=(yy2+yy0) >> 1;
  yb=(yy0+yy1+yy2+yy3) >> 2;
  yc=yy2;
  yd=(yy2+yy3) >> 1;

  dith2x2CGen(cmap2x2->clr20,ya,r,g,b,0,0,0);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  dith2x2CGen(cmap2x2->clr21,yb,r,g,b,re,ge,be);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  dith2x2CGen(cmap2x2->clr23,yd,r,g,b,re,ge,be);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  dith2x2CGen(cmap2x2->clr22,yc,r,g,b,re,ge,be);

  ya=(yy0+yy1+yy2+yy3) >> 2;
  yb=(yy3+yy1) >> 1;
  yc=(yy3+yy2) >> 1;
  yd=yy3;

  dith2x2CGen(cmap2x2->clr33,yd,r,g,b,0,0,0);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  dith2x2CGen(cmap2x2->clr32,yc,r,g,b,re,ge,be);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  dith2x2CGen(cmap2x2->clr30,ya,r,g,b,re,ge,be);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  dith2x2CGen(cmap2x2->clr31,yb,r,g,b,re,ge,be);
}
/* \\\ */

/* /// "YUV2x2to332Dith42()" */
void __regargs YUV2x2to332Dith42(ulong y0,
                                 ulong y1,
                                 ulong y2,
                                 ulong y3,
                                 ulong u,
                                 ulong v,
                                 struct Color2x2 *cmap2x2)
{
  long cr, cg, cb;
  ulong clr;
  long r, g, b;
  long re, ge, be, yy;

  cr=yuvTab->vrTab[v];
  cg=yuvTab->ugTab[u]+yuvTab->vgTab[v];
  cb=yuvTab->ubTab[u];

  yy=(long)(yuvTab->yTab[y0]);
  dith2x2CGen(cmap2x2->clr00,yy,r,g,b,0,0,0);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  yy=(long)(yuvTab->yTab[y2]);
  dith2x2CGen(cmap2x2->clr20,yy,r,g,b,re,ge,be);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  yy=(long)(yuvTab->yTab[y3]);
  dith2x2CGen(cmap2x2->clr30,yy,r,g,b,re,ge,be);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  yy=(long)(yuvTab->yTab[y1]);
  dith2x2CGen(cmap2x2->clr10,yy,r,g,b,re,ge,be);

  yy=(long)(yuvTab->yTab[y3]);
  dith2x2CGen(cmap2x2->clr31,yy,r,g,b,0,0,0);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  yy=(long)(yuvTab->yTab[y1]);
  dith2x2CGen(cmap2x2->clr11,yy,r,g,b,re,ge,be);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  yy=(long)(yuvTab->yTab[y0]);
  dith2x2CGen(cmap2x2->clr01,yy,r,g,b,re,ge,be);
  dith2x2EGen(clr,r,g,b,re,ge,be);
  yy=(long)(yuvTab->yTab[y2]);
  dith2x2CGen(cmap2x2->clr21,yy,r,g,b,re,ge,be);
}
/* \\\ */

/* /// "Color2x2Blk1332Dith()" */
void __regargs Color2x2Blk1332Dith(uchar *to,
                                   ulong x,
                                   ulong y,
                                   ulong width,
                                   struct Color2x2 *cm)
{
  ulong rowInc=width;
  uchar *ip=to+(y*width+x);

  ip[0]=(uchar)(cm->clr00);
  ip[1]=(uchar)(cm->clr01);
  ip[2]=(uchar)(cm->clr10);
  ip[3]=(uchar)(cm->clr11);
  ip+=rowInc;
  ip[0]=(uchar)(cm->clr02);
  ip[1]=(uchar)(cm->clr03);
  ip[2]=(uchar)(cm->clr12);
  ip[3]=(uchar)(cm->clr13);
  ip+=rowInc;
  ip[0]=(uchar)(cm->clr20);
  ip[1]=(uchar)(cm->clr21);
  ip[2]=(uchar)(cm->clr30);
  ip[3]=(uchar)(cm->clr31);
  ip+=rowInc;
  ip[0]=(uchar)(cm->clr22);
  ip[1]=(uchar)(cm->clr23);
  ip[2]=(uchar)(cm->clr32);
  ip[3]=(uchar)(cm->clr33);
}
/* \\\ */

/* /// "Color2x2Blk4332Dith()" */
void __regargs Color2x2Blk4332Dith(uchar *to,
                                   ulong x,
                                   ulong y,
                                   ulong width,
                                   struct Color2x2 *cm0,
                                   struct Color2x2 *cm1,
                                   struct Color2x2 *cm2,
                                   struct Color2x2 *cm3)
{
  ulong rowInc=width;
  uchar *ip=to+(y*width+x);

  ip[0]=(uchar)(cm0->clr00);
  ip[1]=(uchar)(cm0->clr10);
  ip[2]=(uchar)(cm1->clr01);
  ip[3]=(uchar)(cm1->clr11);
  ip+=rowInc;
  ip[0]=(uchar)(cm0->clr20);
  ip[1]=(uchar)(cm0->clr30);
  ip[2]=(uchar)(cm1->clr21);
  ip[3]=(uchar)(cm1->clr31);
  ip+=rowInc;
  ip[0]=(uchar)(cm2->clr01);
  ip[1]=(uchar)(cm2->clr11);
  ip[2]=(uchar)(cm3->clr00);
  ip[3]=(uchar)(cm3->clr10);
  ip+=rowInc;
  ip[0]=(uchar)(cm2->clr21);
  ip[1]=(uchar)(cm2->clr31);
  ip[2]=(uchar)(cm3->clr20);
  ip[3]=(uchar)(cm3->clr30);
}
/* \\\ */

