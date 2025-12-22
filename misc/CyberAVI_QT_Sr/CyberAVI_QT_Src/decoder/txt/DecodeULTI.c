/*
sc:c/sc opt txt/DecodeULTI.c
*/

#include "Decode.h"
#include "GlobalVars.h"
#include "YUV.h"

#define ultiChromNorm 0
#define ultiChromUniq 1
#define ultiStream0 0x0
#define ultiStream1 0x4

/* /// "ulti0000" */
#define ulti0000(ip,CST,c0,c1,c2,c3,r_inc) { \
  *ip++=(CST)c0; *ip++=(CST)c1; *ip++=(CST)c2; *ip=(CST)c3; ip+=r_inc; \
  *ip++=(CST)c0; *ip++=(CST)c1; *ip++=(CST)c2; *ip=(CST)c3; ip+=r_inc; \
  *ip++=(CST)c0; *ip++=(CST)c1; *ip++=(CST)c2; *ip=(CST)c3; ip+=r_inc; \
  *ip++=(CST)c0; *ip++=(CST)c1; *ip++=(CST)c2; *ip=(CST)c3; }
/* \\\ */

/* /// "ulti0225" */
#define ulti0225(ip,CST,c0,c1,c2,c3,r_inc) { \
  *ip++=(CST)c1; *ip++=(CST)c2; *ip++=(CST)c3; *ip=(CST)c3; ip+=r_inc; \
  *ip++=(CST)c0; *ip++=(CST)c1; *ip++=(CST)c2; *ip=(CST)c3; ip+=r_inc; \
  *ip++=(CST)c0; *ip++=(CST)c1; *ip++=(CST)c2; *ip=(CST)c3; ip+=r_inc; \
  *ip++=(CST)c0; *ip++=(CST)c0; *ip++=(CST)c1; *ip=(CST)c2; }
/* \\\ */

/* /// "ulti0450" */
#define ulti0450(ip,CST,c0,c1,c2,c3,r_inc) { \
  *ip++=(CST)c1; *ip++=(CST)c2; *ip++=(CST)c3; *ip=(CST)c3; ip+=r_inc; \
  *ip++=(CST)c1; *ip++=(CST)c2; *ip++=(CST)c2; *ip=(CST)c3; ip+=r_inc; \
  *ip++=(CST)c0; *ip++=(CST)c1; *ip++=(CST)c1; *ip=(CST)c2; ip+=r_inc; \
  *ip++=(CST)c0; *ip++=(CST)c0; *ip++=(CST)c1; *ip=(CST)c2; }
/* \\\ */

/* /// "ulti0675" */
#define ulti0675(ip,CST,c0,c1,c2,c3,r_inc) { \
  *ip++=(CST)c2; *ip++=(CST)c3; *ip++=(CST)c3; *ip=(CST)c3; ip+=r_inc; \
  *ip++=(CST)c1; *ip++=(CST)c2; *ip++=(CST)c2; *ip=(CST)c3; ip+=r_inc; \
  *ip++=(CST)c0; *ip++=(CST)c1; *ip++=(CST)c1; *ip=(CST)c2; ip+=r_inc; \
  *ip++=(CST)c0; *ip++=(CST)c0; *ip++=(CST)c0; *ip=(CST)c1; }
/* \\\ */

/* /// "ulti0900" */
#define ulti0900(ip,CST,c0,c1,c2,c3,r_inc) { \
  *ip++=(CST)c3; *ip++=(CST)c3; *ip++=(CST)c3; *ip=(CST)c3; ip+=r_inc; \
  *ip++=(CST)c2; *ip++=(CST)c2; *ip++=(CST)c2; *ip=(CST)c2; ip+=r_inc; \
  *ip++=(CST)c1; *ip++=(CST)c1; *ip++=(CST)c1; *ip=(CST)c1; ip+=r_inc; \
  *ip++=(CST)c0; *ip++=(CST)c0; *ip++=(CST)c0; *ip=(CST)c0; }
/* \\\ */

/* /// "ulti1125" */
#define ulti1125(ip,CST,c0,c1,c2,c3,r_inc) { \
  *ip++=(CST)c3; *ip++=(CST)c3; *ip++=(CST)c3; *ip=(CST)c2; ip+=r_inc; \
  *ip++=(CST)c3; *ip++=(CST)c2; *ip++=(CST)c2; *ip=(CST)c1; ip+=r_inc; \
  *ip++=(CST)c2; *ip++=(CST)c1; *ip++=(CST)c1; *ip=(CST)c0; ip+=r_inc; \
  *ip++=(CST)c1; *ip++=(CST)c0; *ip++=(CST)c0; *ip=(CST)c0; }
/* \\\ */

/* /// "ulti1350" */
#define ulti1350(ip,CST,c0,c1,c2,c3,r_inc) { \
  *ip++=(CST)c3; *ip++=(CST)c3; *ip++=(CST)c2; *ip=(CST)c2; ip+=r_inc; \
  *ip++=(CST)c3; *ip++=(CST)c2; *ip++=(CST)c1; *ip=(CST)c1; ip+=r_inc; \
  *ip++=(CST)c2; *ip++=(CST)c2; *ip++=(CST)c1; *ip=(CST)c0; ip+=r_inc; \
  *ip++=(CST)c1; *ip++=(CST)c1; *ip++=(CST)c0; *ip=(CST)c0; }
/* \\\ */

/* /// "ulti1575" */
#define ulti1575(ip,CST,c0,c1,c2,c3,r_inc) { \
  *ip++=(CST)c3; *ip++=(CST)c3; *ip++=(CST)c2; *ip=(CST)c1; ip+=r_inc; \
  *ip++=(CST)c3; *ip++=(CST)c2; *ip++=(CST)c1; *ip=(CST)c0; ip+=r_inc; \
  *ip++=(CST)c3; *ip++=(CST)c2; *ip++=(CST)c1; *ip=(CST)c0; ip+=r_inc; \
  *ip++=(CST)c2; *ip++=(CST)c1; *ip++=(CST)c0; *ip=(CST)c0; }
/* \\\ */

/* /// "ultiC2" */
#define ultiC2(ip,flag,c0,c1,rinc) { \
  *ip++=(flag&0x80)?(c1):(c0); \
  *ip++=(flag&0x40)?(c1):(c0); \
  *ip++=(flag&0x20)?(c1):(c0); \
  *ip++=(flag&0x10)?(c1):(c0); \
  ip+=rinc; \
  *ip++=(flag&0x08)?(c1):(c0); \
  *ip++=(flag&0x04)?(c1):(c0); \
  *ip++=(flag&0x02)?(c1):(c0); \
  *ip++=(flag&0x01)?(c1):(c0); \
}
/* \\\ */

/* /// "ultiC4" */
#define ultiC4(ip,CST,c0,c1,c2,c3,r_inc) { \
  *ip++=(CST)c0; *ip++=(CST)c0; *ip++=(CST)c1; *ip=(CST)c1; ip+=r_inc; \
  *ip++=(CST)c0; *ip++=(CST)c0; *ip++=(CST)c1; *ip=(CST)c1; ip+=r_inc; \
  *ip++=(CST)c2; *ip++=(CST)c2; *ip++=(CST)c3; *ip=(CST)c3; ip+=r_inc; \
  *ip++=(CST)c2; *ip++=(CST)c2; *ip++=(CST)c3; *ip=(CST)c3; }
/* \\\ */

/* /// "ultirgbC2" */
#define ultirgbC2(p,msk,clr0,clr1,rinc) { \
 *p++=(msk & 0x80) ? clr1 : clr0;         \
 *p++=(msk & 0x40) ? clr1 : clr0;         \
 *p++=(msk & 0x20) ? clr1 : clr0;         \
 *p++=(msk & 0x10) ? clr1 : clr0;         \
 p+=rinc;                                 \
 *p++=(msk & 0x08) ? clr1 : clr0;         \
 *p++=(msk & 0x04) ? clr1 : clr0;         \
 *p++=(msk & 0x02) ? clr1 : clr0;         \
 *p++=(msk & 0x01) ? clr1 : clr0;         \
}
/* \\\ */

/* /// "blockInc" */
#define blockInc(x,y,w) { x+=8; \
                          if (x>=w) { \
                            x=0; \
                            y+=8; \
                          } \
                        }
/* \\\ */

struct UltiData {
  uchar *ltcTab;
  long cr[16];
  long cb[16];
  long crcb[256];
};

/* /// "GetULTIColorRGB" */
#define GetULTIColorRGB(lum,chrom,tripl) {              \
  ulong cr, cb;                                         \
  long tlum=lum<<14;                                    \
  cb=(chrom>>4) & 0x0f;                                 \
  cr=chrom & 0x0f;                                      \
  tripl.alpha=0;                                        \
  tripl.red=rngLimit[(tlum+spec->cr[cr]) >> 12];        \
  tripl.green=rngLimit[(tlum+spec->crcb[chrom]) >> 12]; \
  tripl.blue=rngLimit[(tlum+spec->cb[cb]) >> 12];       \
}
/* \\\ */

/* /// "UltiLTCtoRGB()" */
void UltiLTCtoRGB(RGBTriple *ip,
                  ulong rinc,
                  ulong y0,
                  ulong y1,
                  ulong y2,
                  ulong y3,
                  ulong chrom,
                  ulong angle,
                  struct UltiData *spec)
{
  ulong i;
  RGBTriple t[4];
  uchar idx[16];
  uchar *ix;

  if (angle & 0x08) {
    angle &= 0x07;
    GetULTIColorRGB(y3,chrom,t[0]);
    GetULTIColorRGB(y2,chrom,t[1]);
    GetULTIColorRGB(y1,chrom,t[2]);
    GetULTIColorRGB(y0,chrom,t[3]);
  } else {
    GetULTIColorRGB(y0,chrom,t[0]);
    if (y1==y0) t[1]=t[0];
    else GetULTIColorRGB(y1,chrom,t[1]);
    if (y2==y1) t[2]=t[1];
    else GetULTIColorRGB(y2,chrom,t[2]);
    if (y3==y2) t[3]=t[2];
    else GetULTIColorRGB(y3,chrom,t[3]);
  }
  ix=idx;
  switch (angle) {
    case 0: ulti0000(ix,uchar,0,1,2,3,1); break;
    case 1: ulti0225(ix,uchar,0,1,2,3,1); break;
    case 2: ulti0450(ix,uchar,0,1,2,3,1); break;
    case 3: ulti0675(ix,uchar,0,1,2,3,1); break;
    case 4: ulti0900(ix,uchar,0,1,2,3,1); break;
    case 5: ulti1125(ix,uchar,0,1,2,3,1); break;
    case 6: ulti1350(ix,uchar,0,1,2,3,1); break;
    case 7: ulti1575(ix,uchar,0,1,2,3,1); break;
    default: ultiC4(ix,uchar,0,1,2,3,1); break;
  }
  ix=idx;
  for (i=0; i<16; i++) {
    *ip++=t[*ix++];
    if ((i & 3)==3) ip+=rinc;
  }
}
/* \\\ */

/* /// "DecodeULTItoRGB()" */
__asm void DecodeULTItoRGB(REG(a0) uchar *from,
                           REG(a1) uchar *to,
                           REG(d0) ulong width,
                           REG(d1) ulong height,
                           REG(d2) ulong encSize,
                           REG(a2) struct UltiData *spec)
{
  ulong rinc=width-4; // (width-4)*4;
  ulong exitflag=0;
  long blockCnt=((width*height)>>6)+1;
  long x=0;
  long y=0;
  RGBTriple *iptr;
  ulong streamMode=ultiStream0;
  ulong chromMode=ultiChromNorm;
  ulong chromNextUniq=0;
  ulong bhedr;
  ulong opcode;
  ulong chrom;

  while (!exitflag) {
    bhedr=*from++;
    if ((y>height) || (blockCnt<0)) {
      exitflag=1;
      continue;
    } else if ((bhedr & 0xf8)==0x70) {
      switch (bhedr) {
        case 0x70: {
                     ulong d;
                     d=*from++;
                     streamMode=(d==0)?(ultiStream0):(ultiStream1);
                   }
                   break;
        case 0x71: chromNextUniq=1;
                   break;
        case 0x72: /* chromMode=(chromMode==ultiChromNorm)?(ultiChromUniq):(ultiChromNorm); */
                   chromMode^=1;
                   break;
        case 0x73: exitflag=1;
                   break;
        case 0x74: {
                     ulong cnt;
                     cnt=*from++;
                     blockCnt-=cnt;
                     while (cnt--) blockInc(x,y,width);
                   }
                   break;

        default: exitflag=1;
                 break;
      }
    } else {
      ulong chromFlag;
      ulong quadrant;
      ulong msh;

      blockCnt--;
      if ((chromMode==ultiChromUniq) || (chromNextUniq)) {
        chromNextUniq=0;
        chromFlag=1;
        chrom=0;
      } else {
        chromFlag=0;
        if (bhedr!=0x00) chrom=*from++;
      }
      msh=8;
      for (quadrant=0; quadrant<4; quadrant++) {
        ulong tx, ty;
        if (quadrant==0) { tx=x; ty=y; }
        else if (quadrant==1) ty+=4;
        else if (quadrant==2) tx+=4;
        else ty-=4;
        iptr=(RGBTriple *)(to+(ty*width+tx)*4);
        msh-=2;
        opcode=((bhedr>>msh) & 0x03) | streamMode;
        switch (opcode) {
          case 0x04:
          case 0x00: break;

          case 0x05:
          case 0x01: {
                       ulong angle;
                       ulong y0, y1;
                       if (chromFlag) chrom=*from++;
                       y0=*from++;
                       angle=(y0>>6) & 0x03;
                       y0 &= 0x3f;
                       if (angle==0) {
                         UltiLTCtoRGB(iptr,rinc,y0,y0,y0,y0,chrom,angle,spec);
                       } else {
                         y1=y0+1;
                         if (y1>63) y1=63;
                         if (angle==3) angle=12;
                         else if (angle==2) angle=6;
                         else angle=2;
                         UltiLTCtoRGB(iptr,rinc,y0,y0,y1,y1,chrom,angle,spec);
                       }
                     }
                     break;

          case 0x02: {
                       ulong angle;
                       ulong ltcIdx;
                       ulong y0, y1, y2, y3;
                       uchar *tmp;
                       if (chromFlag) chrom=*from++;
                       ltcIdx=get16(from);
                       angle=(ltcIdx>>12) & 0x0f;
                       ltcIdx=(ltcIdx & 0x0fff)<<2;
                       tmp=&(spec->ltcTab[ltcIdx]);
                       y0=tmp[0];
                       y1=tmp[1];
                       y2=tmp[2];
                       y3=tmp[3];
                       UltiLTCtoRGB(iptr,rinc,y0,y1,y2,y3,chrom,angle,spec);
                     }
                     break;

          case 0x03: {
                       ulong d;
                       if (chromFlag) chrom=*from++;
                       d=*from++;
                       if (d & 0x80) {
                         ulong angle;
                         ulong y0, y1, y2, y3;
                         angle=(d>>4) & 0x07;
                         d=(d<<8) | (from[0]);
                         y0=(d>>6) & 0x3f;
                         y1=d & 0x3f;
                         y2=(from[1]) & 0x3f;
                         y3=(from[2]) & 0x3f;
                         from+=3;
                         UltiLTCtoRGB(iptr,rinc,y0,y1,y2,y3,chrom,angle,spec);
                       } else {
                         ulong y0, y1;
                         uchar flag0, flag1;
                         RGBTriple t0, t1;
                         uchar r0, r1, g0, g1, b0, b1;
                         flag0=from[0];
                         flag1=d;
                         y0=(from[1]) & 0x3f;
                         y1=(from[2]) & 0x3f;
                         from+=3;
                         GetULTIColorRGB(y0,chrom,t0);
                         GetULTIColorRGB(y1,chrom,t1);
                         ultirgbC2(iptr,flag1,t0,t1,rinc); iptr+=rinc;
                         ultirgbC2(iptr,flag0,t0,t1,rinc);
                       }
                     }
                     break;

          case 0x06: {
                       ulong y0, y1, y2, y3;
                       if (chromFlag) chrom=*from++;
                       y3=get24(from);
                       y0=(y3>>18) & 0x3f;
                       y1=(y3>>12) & 0x3f;
                       y2=(y3>>6) & 0x3f;
                       y3 &= 0x3f;
                       UltiLTCtoRGB(iptr,rinc,y0,y1,y2,y3,chrom,0x10,spec);
                     }
                     break;

          case 0x07: {
                       ulong i, d, y[16];
                       if (chromFlag) chrom=*from++;
                       d=get24(from);
                       i=0;
                       y[i++]=(d>>18) & 0x3f;
                       y[i++]=(d>>12) & 0x3f;
                       y[i++]=(d>>6) & 0x3f;
                       y[i++]=d & 0x3f;
                       d=get24(from);
                       y[i++]=(d>>18) & 0x3f;
                       y[i++]=(d>>12) & 0x3f;
                       y[i++]=(d>>6) & 0x3f;
                       y[i++]=d & 0x3f;
                       d=get24(from);
                       y[i++]=(d>>18) & 0x3f;
                       y[i++]=(d>>12) & 0x3f;
                       y[i++]=(d>>6) & 0x3f;
                       y[i++]=d & 0x3f;
                       d=get24(from);
                       y[i++]=(d>>18) & 0x3f;
                       y[i++]=(d>>12) & 0x3f;
                       y[i++]=(d>>6) & 0x3f;
                       y[i  ]=d & 0x3f;
                       for (i=0; i<16; i++) {
                         GetULTIColorRGB(y[i],chrom,*iptr);
                         iptr++;
                         if ((i%4)==3) iptr+=rinc;
                       }
                     }
                     break;
          default: break;
        }
      }
      blockInc(x,y,width);
    }
  }
}
/* \\\ */

/* /// "GetULTIColor332" */
#define GetULTIColor332(lum,chrom,color)       \
{                                              \
  /* für Graustufen nur Luminanz kopieren */   \
  /* color=lum<<2; */                          \
  ulong cr, cb, ra, ga, ba;                    \
  long tlum=lum<<14;                           \
  cb=(chrom>>4) & 0x0f;                        \
  cr=chrom & 0x0f;                             \
  ra=rngLimit[(tlum+spec->cr[cr]) >> 12];      \
  ga=rngLimit[(tlum+spec->crcb[chrom]) >> 12]; \
  ba=rngLimit[(tlum+spec->cb[cb]) >> 12];      \
  color=RGBtoCol332(ra,ga,ba,scale8);          \
}                                              \
/* \\\ */

/* früher
  tmp=(tlum+spec->cr[cr])>>14;                       \
  if (tmp<0) tmp=0; else if (tmp>63) tmp=63; ra=tmp; \
  tmp=(tlum+spec->cb[cb])>>14;                       \
  if (tmp<0) tmp=0; else if (tmp>63) tmp=63; ba=tmp; \
  tmp=(tlum+spec->crcb[chrom])>>14;                  \
  if (tmp<0) tmp=0; else if (tmp>63) tmp=63; ga=tmp; \
  color=RGBtoCol332(ra,ga,ba,scale6);                \
*/

/* /// "UltiLTCto332()" */
void UltiLTCto332(uchar *ip,
                  ulong rinc,
                  ulong y0,
                  ulong y1,
                  ulong y2,
                  ulong y3,
                  ulong chrom,
                  ulong angle,
                  struct UltiData *spec)
{
  ulong c0, c1, c2, c3;

  if (angle & 0x08) {
    angle &= 0x07;
    GetULTIColor332(y3,chrom,c0);
    GetULTIColor332(y2,chrom,c1);
    GetULTIColor332(y1,chrom,c2);
    GetULTIColor332(y0,chrom,c3);
  } else {
    GetULTIColor332(y0,chrom,c0);
    if (y1==y0) c1=c0;
    else GetULTIColor332(y1,chrom,c1);
    if (y2==y1) c2=c1;
    else GetULTIColor332(y2,chrom,c2);
    if (y3==y2) c3=c2;
    else GetULTIColor332(y3,chrom,c3);
  }
  switch(angle) {
    case 0: ulti0000(ip,uchar,c0,c1,c2,c3,rinc); break;
    case 1: ulti0225(ip,uchar,c0,c1,c2,c3,rinc); break;
    case 2: ulti0450(ip,uchar,c0,c1,c2,c3,rinc); break;
    case 3: ulti0675(ip,uchar,c0,c1,c2,c3,rinc); break;
    case 4: ulti0900(ip,uchar,c0,c1,c2,c3,rinc); break;
    case 5: ulti1125(ip,uchar,c0,c1,c2,c3,rinc); break;
    case 6: ulti1350(ip,uchar,c0,c1,c2,c3,rinc); break;
    case 7: ulti1575(ip,uchar,c0,c1,c2,c3,rinc); break;
    default: ultiC4(ip,uchar,c0,c1,c2,c3,rinc); break;
  }
}
/* \\\ */

/* /// "DecodeULTIto332()" */
__asm void DecodeULTIto332(REG(a0) uchar *from,
                           REG(a1) uchar *to,
                           REG(d0) ulong width,
                           REG(d1) ulong height,
                           REG(d2) ulong encSize,
                           REG(a2) struct UltiData *spec)
{
  ulong rinc=width-3;
  ulong exitflag=0;
  long blockCnt=((width*height)>>6)+1;
  long x=0;
  long y=0;
  uchar *iptr;
  ulong streamMode=ultiStream0;
  ulong chromMode=ultiChromNorm;
  ulong chromNextUniq=0;
  ulong bhedr;
  ulong opcode;
  ulong chrom;

  while (!exitflag) {
    bhedr=*from++;
    if ((y>height) || (blockCnt<0)) {
      exitflag=1;
      continue;
    } else if ((bhedr & 0xf8)==0x70) {
      switch (bhedr) {
        case 0x70: {
                     ulong d;
                     d=*from++;
                     streamMode=(d==0)?(ultiStream0):(ultiStream1);
                   }
                   break;
        case 0x71: chromNextUniq=1;
                   break;
        case 0x72: /* chromMode=(chromMode==ultiChromNorm)?(ultiChromUniq):(ultiChromNorm); */
                   chromMode^=1;
                   break;
        case 0x73: exitflag=1;
                   break;
        case 0x74: {
                     ulong cnt;
                     cnt=*from++;
                     blockCnt-=cnt;
                     while (cnt--) blockInc(x,y,width);
                   }
                   break;

        default: exitflag=1;
                 break;
      }
    } else {
      ulong chromFlag;
      ulong quadrant;
      ulong msh;

      blockCnt--;
      if ((chromMode==ultiChromUniq) || (chromNextUniq)) {
        chromNextUniq=0;
        chromFlag=1;
        chrom=0;
      } else {
        chromFlag=0;
        if (bhedr!=0x00) chrom=*from++;
      }
      msh=8;
      for(quadrant=0; quadrant<4; quadrant++) {
        ulong tx,ty;
        if (quadrant==0) { tx=x; ty=y; }
        else if (quadrant==1) ty+=4;
        else if (quadrant==2) tx+=4;
        else ty-=4;
        iptr=(to+(ty*width+tx));
        msh-=2;
        opcode=((bhedr>>msh) & 0x03) | streamMode;
        switch (opcode) {
          case 0x04:
          case 0x00: break;

          case 0x05:
          case 0x01: {
                       ulong angle;
                       ulong y0,y1;
                       if (chromFlag) chrom=*from++;
                       y0=*from++;
                       angle=(y0>>6) & 0x03;
                       y0 &= 0x3f;
                       if (angle==0) {
                         UltiLTCto332(iptr,rinc,y0,y0,y0,y0,chrom,angle,spec);
                       } else {
                         y1=y0+1;
                         if (y1>63) y1=63;
                         if (angle==3) angle=12;
                         else if (angle==2) angle=6;
                         else angle=2;
                         UltiLTCto332(iptr,rinc,y0,y0,y1,y1,chrom,angle,spec);
                       }
                     }
                     break;

          case 0x02: {
                       ulong angle;
                       ulong ltcIdx;
                       ulong y0,y1,y2,y3;
                       uchar *tmp;
                       if (chromFlag) chrom=*from++;
                       ltcIdx=get16(from);
                       angle=(ltcIdx>>12) & 0x0f;
                       ltcIdx=(ltcIdx & 0x0fff)<<2;
                       tmp=&(spec->ltcTab[ltcIdx]);
                       y0=tmp[0];
                       y1=tmp[1];
                       y2=tmp[2];
                       y3=tmp[3];
                       UltiLTCto332(iptr,rinc,y0,y1,y2,y3,chrom,angle,spec);
                     }
                     break;

          case 0x03: {
                       ulong d;
                       if (chromFlag) chrom=*from++;
                       d=*from++;
                       if (d & 0x80) {
                         ulong angle;
                         ulong y0,y1,y2,y3;
                         angle=(d>>4) & 0x07;
                         d=(d<<8) | (from[0]);
                         y0=(d>>6) & 0x3f;
                         y1=d & 0x3f;
                         y2=(from[1]) & 0x3f;
                         y3=(from[2]) & 0x3f;
                         from+=3;
                         UltiLTCto332(iptr,rinc,y0,y1,y2,y3,chrom,angle,spec);
                       } else {
                         ulong y0,y1;
                         uchar flag0,flag1;
                         ulong c0,c1;
                         ulong trinc=rinc-1;
                         flag0=from[0];
                         flag1=d;
                         y0=(from[1]) & 0x3f;
                         y1=(from[2]) & 0x3f;
                         from+=3;
                         GetULTIColor332(y0,chrom,c0);
                         GetULTIColor332(y1,chrom,c1);
                         ultiC2(iptr,flag1,c0,c1,trinc); iptr+=trinc;
                         ultiC2(iptr,flag0,c0,c1,trinc);
                       }
                     }
                     break;

          case 0x06: {
                       ulong y0,y1,y2,y3;
                       if (chromFlag) chrom=*from++;
                       y3=get24(from);
                       y0=(y3>>18) & 0x3f;
                       y1=(y3>>12) & 0x3f;
                       y2=(y3>>6) & 0x3f;
                       y3 &= 0x3f;
                       UltiLTCto332(iptr,rinc,y0,y1,y2,y3,chrom,0x10,spec);
                     }
                     break;

          case 0x07: {
                       ulong i,d,y[16];
                       ulong trinc=rinc-1;
                       if (chromFlag) chrom=*from++;
                       d=get24(from);
                       i=0;
                       y[i++]=(d>>18) & 0x3f;
                       y[i++]=(d>>12) & 0x3f;
                       y[i++]=(d>>6) & 0x3f;
                       y[i++]=d & 0x3f;
                       d=get24(from);
                       y[i++]=(d>>18) & 0x3f;
                       y[i++]=(d>>12) & 0x3f;
                       y[i++]=(d>>6) & 0x3f;
                       y[i++]=d & 0x3f;
                       d=get24(from);
                       y[i++]=(d>>18) & 0x3f;
                       y[i++]=(d>>12) & 0x3f;
                       y[i++]=(d>>6) & 0x3f;
                       y[i++]=d & 0x3f;
                       d=get24(from);
                       y[i++]=(d>>18) & 0x3f;
                       y[i++]=(d>>12) & 0x3f;
                       y[i++]=(d>>6) & 0x3f;
                       y[i  ]=d & 0x3f;
                       for(i=0; i<16; i++) {
                         GetULTIColor332(y[i],chrom,*iptr);
                         iptr++;
                         if ((i%4)==3) iptr+=trinc;
                       }
                     }
                     break;
          default: break;
        }
      }
      blockInc(x,y,width);
    }
  }
}
/* \\\ */

/* /// "ulti0000dith" */
#define ulti0000dith(r_inc) { \
  *ip++=c0; *ip++=d1; *ip++=c2; *ip=d3; ip+=r_inc; \
  *ip++=d0; *ip++=c1; *ip++=d2; *ip=c3; ip+=r_inc; \
  *ip++=c0; *ip++=d1; *ip++=c2; *ip=d3; ip+=r_inc; \
  *ip++=d0; *ip++=c1; *ip++=d2; *ip=c3; }
/* \\\ */

/* /// "ulti0225dith" */
#define ulti0225dith(r_inc) { \
  *ip++=c1; *ip++=d2; *ip++=c3; *ip=d3; ip+=r_inc; \
  *ip++=d0; *ip++=c1; *ip++=d2; *ip=c3; ip+=r_inc; \
  *ip++=c0; *ip++=d1; *ip++=c2; *ip=d3; ip+=r_inc; \
  *ip++=d0; *ip++=c0; *ip++=d1; *ip=c2; }
/* \\\ */

/* /// "ulti0450dith" */
#define ulti0450dith(r_inc) { \
  *ip++=c1; *ip++=d2; *ip++=c3; *ip=d3; ip+=r_inc; \
  *ip++=d1; *ip++=c2; *ip++=d2; *ip=c3; ip+=r_inc; \
  *ip++=c0; *ip++=d1; *ip++=c1; *ip=d2; ip+=r_inc; \
  *ip++=d0; *ip++=c0; *ip++=d1; *ip=c2; }
/* \\\ */

/* /// "ulti0675dith" */
#define ulti0675dith(r_inc) { \
  *ip++=c2; *ip++=d3; *ip++=c3; *ip=d3; ip+=r_inc; \
  *ip++=d1; *ip++=c2; *ip++=d2; *ip=c3; ip+=r_inc; \
  *ip++=c0; *ip++=d1; *ip++=c1; *ip=d2; ip+=r_inc; \
  *ip++=d0; *ip++=c0; *ip++=d0; *ip=c1; }
/* \\\ */

/* /// "ulti0900dith" */
#define ulti0900dith(r_inc) { \
  *ip++=c3; *ip++=d3; *ip++=c3; *ip=d3; ip+=r_inc; \
  *ip++=d2; *ip++=c2; *ip++=d2; *ip=c2; ip+=r_inc; \
  *ip++=c1; *ip++=d1; *ip++=c1; *ip=d1; ip+=r_inc; \
  *ip++=d0; *ip++=c0; *ip++=d0; *ip=c0; }
/* \\\ */

/* /// "ulti1125dith" */
#define ulti1125dith(r_inc) { \
  *ip++=c3; *ip++=d3; *ip++=c3; *ip=d2; ip+=r_inc; \
  *ip++=d3; *ip++=c2; *ip++=d2; *ip=c1; ip+=r_inc; \
  *ip++=c2; *ip++=d1; *ip++=c1; *ip=d0; ip+=r_inc; \
  *ip++=d1; *ip++=c0; *ip++=d0; *ip=c0; }
/* \\\ */

/* /// "ulti1350dith" */
#define ulti1350dith(r_inc) { \
  *ip++=c3; *ip++=d3; *ip++=c2; *ip=d2; ip+=r_inc; \
  *ip++=d3; *ip++=c2; *ip++=d1; *ip=c1; ip+=r_inc; \
  *ip++=c2; *ip++=d2; *ip++=c1; *ip=d0; ip+=r_inc; \
  *ip++=d1; *ip++=c1; *ip++=d0; *ip=c0; }
/* \\\ */

/* /// "ulti1575dith" */
#define ulti1575dith(r_inc) { \
  *ip++=c3; *ip++=d3; *ip++=c2; *ip=d1; ip+=r_inc; \
  *ip++=d3; *ip++=c2; *ip++=d1; *ip=c0; ip+=r_inc; \
  *ip++=c3; *ip++=d2; *ip++=c1; *ip=d0; ip+=r_inc; \
  *ip++=d2; *ip++=c1; *ip++=d0; *ip=c0; }
/* \\\ */

/* /// "ultiC2dith" */
#define ultiC2dith(ip,flag,c0,c1,d0,d1,rinc) { \
  *ip++=(flag&0x80)?(c1):(c0); \
  *ip++=(flag&0x40)?(d1):(d0); \
  *ip++=(flag&0x20)?(c1):(c0); \
  *ip++=(flag&0x10)?(d1):(d0); \
  ip+=rinc; \
  *ip++=(flag&0x08)?(d1):(d0); \
  *ip++=(flag&0x04)?(c1):(c0); \
  *ip++=(flag&0x02)?(d1):(d0); \
  *ip++=(flag&0x01)?(c1):(c0); \
}
/* \\\ */

/* /// "ultiC4dith" */
#define ultiC4dith(r_inc) { \
  *ip++=c0; *ip++=d0; *ip++=c1; *ip=d1; ip+=r_inc; \
  *ip++=d0; *ip++=c0; *ip++=d1; *ip=c1; ip+=r_inc; \
  *ip++=c2; *ip++=d2; *ip++=c3; *ip=d3; ip+=r_inc; \
  *ip++=d2; *ip++=c2; *ip++=d3; *ip=c3; }
/* \\\ */

/* /// "GetULTIColor332Dith" */
#define GetULTIColor332Dith(lum,chrom,col1,col2)          \
{                                                         \
  ulong cr, cb, ra, ga, ba;                               \
  long tlum=lum<<14;                                      \
  cb=(chrom>>4) & 0x0f;                                   \
  cr=chrom & 0x0f;                                        \
  ra=rngLimit[(tlum+spec->cr[cr]) >> 12];                 \
  ga=rngLimit[(tlum+spec->crcb[chrom]) >> 12];            \
  ba=rngLimit[(tlum+spec->cb[cb]) >> 12];                 \
  DitherGetRGB(ra,ga,ba,re,ge,be,col1);                   \
  DitherGetRGB(ra,ga,ba,re,ge,be,col2);                   \
}                                                         \
/* \\\ */

/* /// "UltiLTCto332Dith()" */
void UltiLTCto332Dith(uchar *ip,
                      ulong rinc,
                      ulong y0,
                      ulong y1,
                      ulong y2,
                      ulong y3,
                      ulong chrom,
                      ulong angle,
                      struct UltiData *spec)
{
  ulong c0, c1, c2, c3;
  ulong d0, d1, d2, d3;
  long re=0, ge=0, be=0;

  if (angle & 0x08) {
    angle &= 0x07;
    GetULTIColor332Dith(y3,chrom,c0,d0);
    GetULTIColor332Dith(y2,chrom,c1,d1);
    GetULTIColor332Dith(y1,chrom,c2,d2);
    GetULTIColor332Dith(y0,chrom,c3,d3);
  } else {
    GetULTIColor332Dith(y0,chrom,c0,d0);
    if (y1==y0) {c1=c0; d1=d0;}
    else GetULTIColor332Dith(y1,chrom,c1,d1);
    if (y2==y1) {c2=c1; d2=d1;}
    else GetULTIColor332Dith(y2,chrom,c2,d2);
    if (y3==y2) {c3=c2; d3=d2;}
    else GetULTIColor332Dith(y3,chrom,c3,d3);
  }
  /* c0=c1=c2=c3=d0=d1=d2=d3=0; */
  switch(angle) {
    case 0: ulti0000dith(rinc); break;
    case 1: ulti0225dith(rinc); break;
    case 2: ulti0450dith(rinc); break;
    case 3: ulti0675dith(rinc); break;
    case 4: ulti0900dith(rinc); break;
    case 5: ulti1125dith(rinc); break;
    case 6: ulti1350dith(rinc); break;
    case 7: ulti1575dith(rinc); break;
    default: ultiC4dith(rinc); break;
  }
}
/* \\\ */

/* /// "DecodeULTIto332Dith()" */
__asm void DecodeULTIto332Dith(REG(a0) uchar *from,
                               REG(a1) uchar *to,
                               REG(d0) ulong width,
                               REG(d1) ulong height,
                               REG(d2) ulong encSize,
                               REG(a2) struct UltiData *spec)
{
  ulong rinc=width-3;
  ulong exitflag=0;
  long blockCnt=((width*height)>>6)+1;
  long x=0;
  long y=0;
  uchar *iptr;
  ulong streamMode=ultiStream0;
  ulong chromMode=ultiChromNorm;
  ulong chromNextUniq=0;
  ulong bhedr;
  ulong opcode;
  ulong chrom;

  while (!exitflag) {
    bhedr=*from++;
    if ((y>height) || (blockCnt<0)) {
      exitflag=1;
      continue;
    } else if ((bhedr & 0xf8)==0x70) {
      switch (bhedr) {
        case 0x70: {
                     ulong d;
                     d=*from++;
                     streamMode=(d==0)?(ultiStream0):(ultiStream1);
                   }
                   break;
        case 0x71: chromNextUniq=1;
                   break;
        case 0x72: /* chromMode=(chromMode==ultiChromNorm)?(ultiChromUniq):(ultiChromNorm); */
                   chromMode^=1;
                   break;
        case 0x73: exitflag=1;
                   break;
        case 0x74: {
                     ulong cnt;
                     cnt=*from++;
                     blockCnt-=cnt;
                     while (cnt--) blockInc(x,y,width);
                   }
                   break;

        default: exitflag=1;
                 break;
      }
    } else {
      ulong chromFlag;
      ulong quadrant;
      ulong msh;

      blockCnt--;
      if ((chromMode==ultiChromUniq) || (chromNextUniq)) {
        chromNextUniq=0;
        chromFlag=1;
        chrom=0;
      } else {
        chromFlag=0;
        if (bhedr!=0x00) chrom=*from++;
      }
      msh=8;
      for(quadrant=0; quadrant<4; quadrant++) {
        ulong tx,ty;
        if (quadrant==0) { tx=x; ty=y; }
        else if (quadrant==1) ty+=4;
        else if (quadrant==2) tx+=4;
        else ty-=4;
        iptr=(to+(ty*width+tx));
        msh-=2;
        opcode=((bhedr>>msh) & 0x03) | streamMode;
        switch (opcode) {
          case 0x04:
          case 0x00: break;

          case 0x05:
          case 0x01: {
                       ulong angle;
                       ulong y0,y1;
                       if (chromFlag) chrom=*from++;
                       y0=*from++;
                       angle=(y0>>6) & 0x03;
                       y0 &= 0x3f;
                       if (angle==0) {
                         UltiLTCto332Dith(iptr,rinc,y0,y0,y0,y0,chrom,angle,spec);
                       } else {
                         y1=y0+1;
                         if (y1>63) y1=63;
                         if (angle==3) angle=12;
                         else if (angle==2) angle=6;
                         else angle=2;
                         UltiLTCto332Dith(iptr,rinc,y0,y0,y1,y1,chrom,angle,spec);
                       }
                     }
                     break;

          case 0x02: {
                       ulong angle;
                       ulong ltcIdx;
                       ulong y0,y1,y2,y3;
                       uchar *tmp;
                       if (chromFlag) chrom=*from++;
                       ltcIdx=get16(from);
                       angle=(ltcIdx>>12) & 0x0f;
                       ltcIdx=(ltcIdx & 0x0fff)<<2;
                       tmp=&(spec->ltcTab[ltcIdx]);
                       y0=tmp[0];
                       y1=tmp[1];
                       y2=tmp[2];
                       y3=tmp[3];
                       UltiLTCto332Dith(iptr,rinc,y0,y1,y2,y3,chrom,angle,spec);
                     }
                     break;

          case 0x03: {
                       ulong d;
                       if (chromFlag) chrom=*from++;
                       d=*from++;
                       if (d & 0x80) {
                         ulong angle;
                         ulong y0,y1,y2,y3;
                         angle=(d>>4) & 0x07;
                         d=(d<<8) | (from[0]);
                         y0=(d>>6) & 0x3f;
                         y1=d & 0x3f;
                         y2=(from[1]) & 0x3f;
                         y3=(from[2]) & 0x3f;
                         from+=3;
                         UltiLTCto332Dith(iptr,rinc,y0,y1,y2,y3,chrom,angle,spec);
                       } else {
                         ulong y0,y1;
                         uchar flag0,flag1;
                         ulong c0, c1, d0, d1;
                         ulong trinc=rinc-1;
                         long re=0, ge=0, be=0;
                         flag0=from[0];
                         flag1=d;
                         y0=(from[1]) & 0x3f;
                         y1=(from[2]) & 0x3f;
                         from+=3;
                         GetULTIColor332Dith(y0,chrom,c0,d0);
                         GetULTIColor332Dith(y1,chrom,c1,d1);
                         ultiC2dith(iptr,flag1,c0,c1,d0,d1,trinc); iptr+=trinc;
                         ultiC2dith(iptr,flag0,c0,c1,d0,d1,trinc);
                       }
                     }
                     break;

          case 0x06: {
                       ulong y0,y1,y2,y3;
                       if (chromFlag) chrom=*from++;
                       y3=get24(from);
                       y0=(y3>>18) & 0x3f;
                       y1=(y3>>12) & 0x3f;
                       y2=(y3>>6) & 0x3f;
                       y3 &= 0x3f;
                       UltiLTCto332Dith(iptr,rinc,y0,y1,y2,y3,chrom,0x10,spec);
                     }
                     break;

          case 0x07: {
                       ulong i,d,y[16];
                       ulong trinc=rinc-1;
                       long re=0, ge=0, be=0;
                       if (chromFlag) chrom=*from++;
                       d=get24(from);
                       i=0;
                       y[i++]=(d>>18) & 0x3f;
                       y[i++]=(d>>12) & 0x3f;
                       y[i++]=(d>>6) & 0x3f;
                       y[i++]=d & 0x3f;
                       d=get24(from);
                       y[i++]=(d>>18) & 0x3f;
                       y[i++]=(d>>12) & 0x3f;
                       y[i++]=(d>>6) & 0x3f;
                       y[i++]=d & 0x3f;
                       d=get24(from);
                       y[i++]=(d>>18) & 0x3f;
                       y[i++]=(d>>12) & 0x3f;
                       y[i++]=(d>>6) & 0x3f;
                       y[i++]=d & 0x3f;
                       d=get24(from);
                       y[i++]=(d>>18) & 0x3f;
                       y[i++]=(d>>12) & 0x3f;
                       y[i++]=(d>>6) & 0x3f;
                       y[i  ]=d & 0x3f;
                       for(i=0; i<16; i++) {
                         GetULTIColor332Dith(y[i],chrom,*iptr,d);
                         iptr++;
                         if ((i%4)==3) iptr+=trinc;
                       }
                     }
                     break;
          default: break;
        }
      }
      blockInc(x,y,width);
    }
  }
}
/* \\\ */

