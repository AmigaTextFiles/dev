/*
sc:c/sc opt txt/DecodeRPZA.c
*/

#include "Decode.h"
#include "YUV.h"

struct RPZAData {
  uchar gray;
  uchar *rngLimit;
  struct RGBTriple *cmap;
};

/* /// "blockInc" */
#define blockInc(x,y,xmax,im0,im1,im2,im3,binc,rinc) { \
  x+=4;                                                \
  im0+=binc;                                           \
  im1+=binc;                                           \
  im2+=binc;                                           \
  im3+=binc;                                           \
  if (x>=xmax) {                                       \
    x=0;                                               \
    y+=4;                                              \
    im0+=rinc;                                         \
    im1+=rinc;                                         \
    im2+=rinc;                                         \
    im3+=rinc;                                         \
  }                                                    \
}
/* \\\ */

/* /// "rpzargbC1" */
#define rpzargbC1(ip,r,g,b) {    \
  ip[ 0]=ip[ 3]=ip[ 6]=ip[ 9]=r; \
  ip[ 1]=ip[ 4]=ip[ 7]=ip[10]=g; \
  ip[ 2]=ip[ 5]=ip[ 8]=ip[11]=b; \
}
/* \\\ */

/* /// "rpzargbC4" */
#define rpzargbC4(ip,r,g,b,mask) {                                   \
  ulong idx;                                                         \
  idx=(mask>>6) & 0x03; ip[ 0]=r[idx]; ip[ 1]=g[idx]; ip[ 2]=b[idx]; \
  idx=(mask>>4) & 0x03; ip[ 3]=r[idx]; ip[ 4]=g[idx]; ip[ 5]=b[idx]; \
  idx=(mask>>2) & 0x03; ip[ 6]=r[idx]; ip[ 7]=g[idx]; ip[ 8]=b[idx]; \
  idx= mask     & 0x03; ip[ 9]=r[idx]; ip[10]=g[idx]; ip[11]=b[idx]; \
}
/* \\\ */

/* /// "rpzargbC16" */
#define rpzargbC16(ip,r,g,b) {           \
  ip[ 0]=r[0]; ip[ 1]=g[0]; ip[ 2]=b[0]; \
  ip[ 3]=r[1]; ip[ 4]=g[1]; ip[ 5]=b[1]; \
  ip[ 6]=r[2]; ip[ 7]=g[2]; ip[ 8]=b[2]; \
  ip[ 9]=r[3]; ip[10]=g[3]; ip[11]=b[3]; \
  r+=4; g+=4; b+=4;                      \
/*                                    \
  *ip++=*r++; *ip++=*g++; *ip++=*b++; \
  *ip++=*r++; *ip++=*g++; *ip++=*b++; \
  *ip++=*r++; *ip++=*g++; *ip++=*b++; \
  *ip++=*r++; *ip++=*g++; *ip++=*b++; \
*/                                    \
}
/* \\\ */

/* /// "GetAVRGBColors" */
#define GetAVRGBColors(cA,cB,r,g,b) {          \
  ulong rA, gA, bA, rB, gB, bB, ra, ga, ba;    \
  rA=(cA>>10) & 0x1f; r[3]=(rA<<3) | (rA>>2);  \
  gA=(cA>> 5) & 0x1f; g[3]=(gA<<3) | (gA>>2);  \
  bA= cA & 0x1f;      b[3]=(bA<<3) | (bA>>2);  \
                                               \
  rB=(cB>>10) & 0x1f; r[0]=(rB<<3) | (rB>>2);  \
  gB=(cB>> 5) & 0x1f; g[0]=(gB<<3) | (gB>>2);  \
  bB= cB & 0x1f;      b[0]=(bB<<3) | (bB>>2);  \
                                               \
  ra=(21*rA+11*rB)>>5; r[2]=(ra<<3) | (ra>>2); \
  ra=(11*rA+21*rB)>>5; r[1]=(ra<<3) | (ra>>2); \
                                               \
  ga=(21*gA+11*gB)>>5; g[2]=(ga<<3) | (ga>>2); \
  ga=(11*gA+21*gB)>>5; g[1]=(ga<<3) | (ga>>2); \
                                               \
  ba=(21*bA+11*bB)>>5; b[2]=(ba<<3) | (ba>>2); \
  ba=(11*bA+21*bB)>>5; b[1]=(ba<<3) | (ba>>2); \
}
/* \\\ */

/* /// "DecodeRPZAtoRGB()" */
__asm void DecodeRPZAtoRGB(REG(a0) uchar *from,
                           REG(a1) uchar *to,
                           REG(d0) ulong width,
                           REG(d1) ulong height,
                           REG(d2) ulong encSize,
                           REG(a2) struct RPZAData *spec)
{
  ulong code;
  uchar *im0, *im1, *im2, *im3;
  long rowInc, len, x, y;
  const long blockInc=12;

  from++;
  len=get24(from);
  if (len!=encSize) return;
  len-=4;

  rowInc=width*3;
  im0=to;
  im1=im0+rowInc;
  im2=im1+rowInc;
  im3=im2+rowInc;
  rowInc=width*9;
  x=0;
  y=0;

  while(len>0) {
    code=*from++;
    len--;
    if ((code>=0xa0) && (code<=0xbf)) {
      ulong color, skip;
      uchar r, g, b;
      color=get16(from);
      len-=2;
      skip=code-0x9f;
      ColorToRGB(color,r,g,b);
      while(skip--) {
        uchar *ip0=im0, *ip1=im1, *ip2=im2, *ip3=im3;
        rpzargbC1(ip0,r,g,b);
        rpzargbC1(ip1,r,g,b);
        rpzargbC1(ip2,r,g,b);
        rpzargbC1(ip3,r,g,b);
        blockInc(x,y,width,im0,im1,im2,im3,blockInc,rowInc);
      }
    } else if ((code>=0x80) && (code<=0x9f)) {
      ulong skip=code-0x7f;
      while (skip--) blockInc(x,y,width,im0,im1,im2,im3,blockInc,rowInc);
    } else if ((code<0x80) || ((code>=0xc0) && (code<=0xdf))) {
      ulong cA, cB;
      if (code>=0xc0) {
        cA=get16(from);
        len-=4;
      } else {
        cA=(code<<8) | *from++;
        len-=3;
      }
      cB=get16(from);
      if ((code<0x80) && ((cB & 0x8000)==0)) {
        ulong i, d;
        uchar r[16], g[16], b[16];
        uchar *ip0, *ip1, *ip2, *ip3, *tr, *tg, *tb;
        ColorToRGB(cA,r[0],g[0],b[0]);
        ColorToRGB(cB,r[1],g[1],b[1]);
        for (i=2; i<16; i++) {
          d=get16(from);
          ColorToRGB(d,r[i],g[i],b[i]);
        }
        len-=28;
        ip0=im0; ip1=im1; ip2=im2; ip3=im3;
        tr=r; tg=g; tb=b;
        rpzargbC16(ip0,tr,tg,tb);
        rpzargbC16(ip1,tr,tg,tb);
        rpzargbC16(ip2,tr,tg,tb);
        rpzargbC16(ip3,tr,tg,tb);
        blockInc(x,y,width,im0,im1,im2,im3,blockInc,rowInc);
      } else {
        ulong mCnt;
        uchar r[4], g[4], b[4];
        if (code<0x80) mCnt=1; else mCnt=code-0xbf;
        GetAVRGBColors(cA,cB,r,g,b);
        while (mCnt--) {
          uchar *ip0=im0, *ip1=im1, *ip2=im2, *ip3=im3;
          ulong mask;
          mask=from[0];
          rpzargbC4(ip0,r,g,b,mask);
          mask=from[1];
          rpzargbC4(ip1,r,g,b,mask);
          mask=from[2];
          rpzargbC4(ip2,r,g,b,mask);
          mask=from[3];
          rpzargbC4(ip3,r,g,b,mask);
          blockInc(x,y,width,im0,im1,im2,im3,blockInc,rowInc);
          from+=4;
          len-=4;
        }
      }
    }
  }
}
/* \\\ */

/* /// "rpzaC1" */
#define rpzaC1(ip0,ip1,ip2,ip3,c) { \
  ip0[0]=ip0[1]=ip0[2]=ip0[3]=c;    \
  ip1[0]=ip1[1]=ip1[2]=ip1[3]=c;    \
  ip2[0]=ip2[1]=ip2[2]=ip2[3]=c;    \
  ip3[0]=ip3[1]=ip3[2]=ip3[3]=c;    \
}
/* \\\ */

/* /// "rpzaC4" */
#define rpzaC4(ip,c,mask) {    \
  ip[0]=c[((mask>>6) & 0x03)]; \
  ip[1]=c[((mask>>4) & 0x03)]; \
  ip[2]=c[((mask>>2) & 0x03)]; \
  ip[3]=c[( mask     & 0x03)]; \
}
/* \\\ */

/* /// "rpzaC16" */
#define rpzaC16(ip0,ip1,ip2,ip3,c) {                  \
  *ip0++=*c++; *ip0++=*c++; *ip0++=*c++; *ip0++=*c++; \
  *ip1++=*c++; *ip1++=*c++; *ip1++=*c++; *ip1++=*c++; \
  *ip2++=*c++; *ip2++=*c++; *ip2++=*c++; *ip2++=*c++; \
  *ip3++=*c++; *ip3++=*c++; *ip3++=*c++; *ip3++=*c;   \
}
/* \\\ */

/* /// "GetAVColors" */
#define GetAVColors(cA,cB,c) {         \
  ulong rA5, gA5, bA5, rB5, gB5, bB5;  \
  ulong r05, g05, b05, r15, g15, b15;  \
                                       \
  rA5=(cA >> 10) & 0x1f;               \
  gA5=(cA >>  5) & 0x1f;               \
  bA5= cA & 0x1f;                      \
                                       \
  rB5=(cB >> 10) & 0x1f;               \
  gB5=(cB >>  5) & 0x1f;               \
  bB5= cB & 0x1f;                      \
                                       \
  r05=(21*rA5+11*rB5) >> 5;            \
  r15=(11*rA5+21*rB5) >> 5;            \
                                       \
  g05=(21*gA5+11*gB5) >> 5;            \
  g15=(11*gA5+21*gB5) >> 5;            \
                                       \
  b05=(21*bA5+11*bB5) >> 5;            \
  b15=(11*bA5+21*bB5) >> 5;            \
                                       \
  if (gray) {                          \
    c[0]=RGB5toGray(rB5,gB5,bB5);      \
    c[1]=RGB5toGray(r15,g15,b15);      \
    c[2]=RGB5toGray(r05,g05,b05);      \
    c[3]=RGB5toGray(rA5,gA5,bA5);      \
  } else {                             \
    c[0]=RGBto332(rB5,gB5,bB5,scale5); \
    c[1]=RGBto332(r15,g15,b15,scale5); \
    c[2]=RGBto332(r05,g05,b05,scale5); \
    c[3]=RGBto332(rA5,gA5,bA5,scale5); \
  }                                    \
}
/* \\\ */

/* /// "DecodeRPZAto332()" */
__asm void DecodeRPZAto332(REG(a0) uchar *from,
                           REG(a1) uchar *to,
                           REG(d0) ulong width,
                           REG(d1) ulong height,
                           REG(d2) ulong encSize,
                           REG(a2) struct RPZAData *spec)
{
  ulong code;
  uchar *im0, *im1, *im2, *im3;
  long rowInc, len, x, y;
  const long blockInc=4;
  uchar gray=spec->gray;

  from++;
  len=get24(from);
  if (len!=encSize) return;
  len-=4;

  rowInc=width;
  im0=to;
  im1=im0+rowInc;
  im2=im1+rowInc;
  im3=im2+rowInc;
  rowInc=width*3;
  x=0;
  y=0;

  while(len>0) {
    code=*from++;
    len--;
    if ((code>=0xa0) && (code<=0xbf)) {
      ulong color, skip;
      color=get16(from);
      len-=2;
      skip=code-0x9f;
      if (gray) {ColorTo332Gray(color,color);} else {ColorTo332(color,color);}
      while(skip--) {
        uchar *ip0=im0, *ip1=im1, *ip2=im2, *ip3=im3;
        rpzaC1(ip0,ip1,ip2,ip3,color);
        blockInc(x,y,width,im0,im1,im2,im3,blockInc,rowInc);
      }
    } else if ((code>=0x80) && (code<=0x9f)) {
      ulong skip=code-0x7f;
      while (skip--) blockInc(x,y,width,im0,im1,im2,im3,blockInc,rowInc);
    } else if ((code<0x80) || ((code>=0xc0) && (code<=0xdf))) {
      ulong cA, cB;
      if (code>=0xc0) {
        cA=get16(from);
        len-=4;
      } else {
        cA=(code<<8) | *from++;
        len-=3;
      }
      cB=get16(from);
      if ((code<0x80) && ((cB & 0x8000)==0)) {
        ulong i, d, c[16];
        ulong *clr;
        uchar *ip0=im0, *ip1=im1, *ip2=im2, *ip3=im3;
        if (gray) {
          ColorTo332Gray(cA,c[0]);
          ColorTo332Gray(cB,c[1]);
          for (i=2; i<16; i++) {
            d=get16(from);
            ColorTo332Gray(d,c[i]);
          }
        } else {
          ColorTo332(cA,c[0]);
          ColorTo332(cB,c[1]);
          for (i=2; i<16; i++) {
            d=get16(from);
            ColorTo332(d,c[i]);
          }
        }
        len-=28;
        clr=c;
        rpzaC16(ip0,ip1,ip2,ip3,clr);
        blockInc(x,y,width,im0,im1,im2,im3,blockInc,rowInc);
      } else {
        ulong mCnt, c[4];
        if (code<0x80) mCnt=1; else mCnt=code-0xbf;
        GetAVColors(cA,cB,c);
        while (mCnt--) {
          uchar *ip0=im0, *ip1=im1, *ip2=im2, *ip3=im3;
          ulong mask;
          mask=from[0];
          rpzaC4(ip0,c,mask);
          mask=from[1];
          rpzaC4(ip1,c,mask);
          mask=from[2];
          rpzaC4(ip2,c,mask);
          mask=from[3];
          rpzaC4(ip3,c,mask);
          blockInc(x,y,width,im0,im1,im2,im3,blockInc,rowInc);
          from+=4;
          len-=4;
        }
      }
    }
  }
}
/* \\\ */

/* /// "DecodeRPZAto332Dith()" */
__asm void DecodeRPZAto332Dith(REG(a0) uchar *from,
                               REG(a1) uchar *to,
                               REG(d0) ulong width,
                               REG(d1) ulong height,
                               REG(d2) ulong encSize,
                               REG(a2) struct RPZAData *spec)
{
  ulong code;
  uchar *im0, *im1, *im2, *im3;
  long rowInc, len, x, y;
  const long blockInc=4;
  uchar gray=spec->gray;
  uchar *rngLimit=spec->rngLimit;
  struct RGBTriple *cmap=spec->cmap;

  from++;
  len=get24(from);
  if (len!=encSize) return;
  len-=4;

  rowInc=width;
  im0=to;
  im1=im0+rowInc;
  im2=im1+rowInc;
  im3=im2+rowInc;
  rowInc=width*3;
  x=0;
  y=0;

  while(len>0) {
    code=*from++;
    len--;
    if ((code>=0xa0) && (code<=0xbf)) {
      ulong color, skip;
      long re, ge, be, r, g, b, col;
      color=get16(from);
      len-=2;
      skip=code-0x9f;
      ColorToRGB(color,r,g,b);
      while(skip--) {
        uchar *ip0=im0, *ip1=im1, *ip2=im2, *ip3=im3;
        re=ge=be=0;
        DitherGetRGB(r,g,b,re,ge,be,col); ip0[0]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip0[1]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip1[1]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip1[0]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip2[0]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip3[0]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip3[1]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip2[1]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip2[2]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip3[2]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip3[3]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip2[3]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip1[3]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip1[2]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip0[2]=col;
        DitherGetRGB(r,g,b,re,ge,be,col); ip0[3]=col;
        blockInc(x,y,width,im0,im1,im2,im3,blockInc,rowInc);
      }
    } else if ((code>=0x80) && (code<=0x9f)) {
      ulong skip=code-0x7f;
      while (skip--) blockInc(x,y,width,im0,im1,im2,im3,blockInc,rowInc);
    } else if ((code<0x80) || ((code>=0xc0) && (code<=0xdf))) {
      ulong cA, cB;
      if (code>=0xc0) {
        cA=get16(from);
        len-=4;
      } else {
        cA=(code<<8) | *from++;
        len-=3;
      }
      cB=get16(from);
      if ((code<0x80) && ((cB & 0x8000)==0)) {
        uchar *cptr=from;
        uchar *ip0=im0, *ip1=im1, *ip2=im2, *ip3=im3;
        long re=0, ge=0, be=0, ra, ga, ba, col;
        from+=28;
        len-=28;
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip0[0]=col;
        ColorToRGB(cB,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip0[1]=col;
        cA=(cptr[6]<<8) | (cptr[7]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip1[1]=col;
        cA=(cptr[4]<<8) | (cptr[5]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip1[0]=col;
        cA=(cptr[12]<<8) | (cptr[13]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip2[0]=col;
        cA=(cptr[20]<<8) | (cptr[21]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip3[0]=col;
        cA=(cptr[22]<<8) | (cptr[23]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip3[1]=col;
        cA=(cptr[14]<<8) | (cptr[15]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip2[1]=col;
        cA=(cptr[16]<<8) | (cptr[17]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip2[2]=col;
        cA=(cptr[24]<<8) | (cptr[25]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip3[2]=col;
        cA=(cptr[26]<<8) | (cptr[27]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip3[3]=col;
        cA=(cptr[18]<<8) | (cptr[19]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip2[3]=col;
        cA=(cptr[10]<<8) | (cptr[11]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip1[3]=col;
        cA=(cptr[8]<<8) | (cptr[9]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip1[2]=col;
        cA=(cptr[0]<<8) | (cptr[1]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip0[2]=col;
        cA=(cptr[2]<<8) | (cptr[3]);
        ColorToRGB(cA,ra,ga,ba);
        DitherGetRGB(ra,ga,ba,re,ge,be,col); ip0[3]=col;
        blockInc(x,y,width,im0,im1,im2,im3,blockInc,rowInc);
      } else {
        uchar r[4], g[4], b[4];
        ulong mCnt;
        if (code<0x80) mCnt=1; else mCnt=code-0xbf;
        GetAVRGBColors(cA,cB,r,g,b);
        while (mCnt--) {
          uchar *ip0=im0, *ip1=im1, *ip2=im2, *ip3=im3;
          ulong mask0, mask1, mask2, mask3;
          long idx, re=0, ge=0, be=0, ra, ga, ba, col;
          mask0=from[0];
          mask1=from[1];
          mask2=from[2];
          mask3=from[3];
          from+=4;
          len-=4;
          idx=(mask0>>6) & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip0[0]=col;
          idx=(mask0>>4) & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip0[1]=col;
          idx=(mask1>>4) & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip1[1]=col;
          idx=(mask1>>6) & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip1[0]=col;
          idx=(mask2>>6) & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip2[0]=col;
          idx=(mask3>>6) & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip3[0]=col;
          idx=(mask3>>4) & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip3[1]=col;
          idx=(mask2>>4) & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip2[1]=col;
          idx=(mask2>>2) & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip2[2]=col;
          idx=(mask3>>2) & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip3[2]=col;
          idx= mask3     & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip3[3]=col;
          idx= mask2     & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip2[3]=col;
          idx= mask1     & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip1[3]=col;
          idx=(mask1>>2) & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip1[2]=col;
          idx=(mask0>>2) & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip0[2]=col;
          idx= mask0     & 0x03; ra=r[idx]; ga=g[idx]; ba=b[idx];
          DitherGetRGB(ra,ga,ba,re,ge,be,col); ip0[3]=col;
          blockInc(x,y,width,im0,im1,im2,im3,blockInc,rowInc);
        }
      }
    }
  }
}
/* \\\ */

