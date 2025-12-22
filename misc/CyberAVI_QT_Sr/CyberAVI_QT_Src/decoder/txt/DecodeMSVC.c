/*
sc:c/sc opt txt/DecodeMSVC.c
*/

#include "Decode.h"
#include "Utils.h"
#include "YUV.h"
#include "GlobalVars.h"

struct MSVCData {
  ulong dummy;
};

/* /// "blockInc" */
#define blockInc(x,y,xmax) { \
                      x+=4; \
                      if (x>=xmax) { \
                        x=0; \
                        y-=4; \
                      } \
                   }
/* \\\ */

/* /// "cram8c#" */
#define cram8c1(ip,clr,rdec) { \
  ip[0]=ip[1]=ip[2]=ip[3]=clr; ip-=rowDec; \
  ip[0]=ip[1]=ip[2]=ip[3]=clr; ip-=rowDec; \
  ip[0]=ip[1]=ip[2]=ip[3]=clr; ip-=rowDec; \
  ip[0]=ip[1]=ip[2]=ip[3]=clr;             \
/* \
  *ip=clr; ip=(ulong *)((ulong)ip-rdec); \
  *ip=clr; ip=(ulong *)((ulong)ip-rdec); \
  *ip=clr; ip=(ulong *)((ulong)ip-rdec); \
  *ip=clr; \
*/ \
}

#define cram8c2(ip,flag,cA,cB,rowDec) { \
  ip[0]=(flag & 0x01) ? (cB) : (cA);    \
  ip[1]=(flag & 0x02) ? (cB) : (cA);    \
  ip[2]=(flag & 0x04) ? (cB) : (cA);    \
  ip[3]=(flag & 0x08) ? (cB) : (cA);    \
  ip-=rowDec;                           \
  ip[0]=(flag & 0x10) ? (cB) : (cA);    \
  ip[1]=(flag & 0x20) ? (cB) : (cA);    \
  ip[2]=(flag & 0x40) ? (cB) : (cA);    \
  ip[3]=(flag & 0x80) ? (cB) : (cA);    \
}

#define cram8c4(ip,flag,cA0,cA1,cB0,cB1,rowDec) { \
  ip[0]=(flag & 0x01) ? (cB0) : (cA0);            \
  ip[1]=(flag & 0x02) ? (cB0) : (cA0);            \
  ip[2]=(flag & 0x04) ? (cB1) : (cA1);            \
  ip[3]=(flag & 0x08) ? (cB1) : (cA1);            \
  ip-=rowDec;                                     \
  ip[0]=(flag & 0x10) ? (cB0) : (cA0);            \
  ip[1]=(flag & 0x20) ? (cB0) : (cA0);            \
  ip[2]=(flag & 0x40) ? (cB1) : (cA1);            \
  ip[3]=(flag & 0x80) ? (cB1) : (cA1);            \
}
/* \\\ */

/* /// "DecodeMSVC8to332()" */
__asm void DecodeMSVC8to332(REG(a0) uchar *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) struct MSVCData *spec)
{
  long exitflag=0;
  ulong code0;
  ulong code1;
  ulong blockCnt=((width*height)>>4)+1;
  long xp=0;
  long yp=height-1;
  ulong rowDec=width;

  while(!exitflag) {
    code0=from[0];
    code1=from[1];
    from+=2;
    blockCnt--;
    if (((code1==0) && (code0==0) && !blockCnt) || (yp<0))
      exitflag=1;
    else {
      if ((code1>=0x84) && (code1<=0x87)) {
        ulong skip=((code1-0x84)<<8)+code0;
        blockCnt-=(skip-1);
        while(skip--) blockInc(xp,yp,rowDec);
      } else {
        uchar *iptr=(to+yp*width+xp);
        if (code1>=0x90) {
          uchar cA0,cA1,cB0,cB1;
          cB0=remap[from[0]];
          cA0=remap[from[1]];
          cB1=remap[from[2]];
          cA1=remap[from[3]];
          cram8c4(iptr,code0,cA0,cA1,cB0,cB1,rowDec); iptr-=rowDec;
          cB0=remap[from[4]];
          cA0=remap[from[5]];
          cB1=remap[from[6]];
          cA1=remap[from[7]];
          cram8c4(iptr,code1,cA0,cA1,cB0,cB1,rowDec);
          from+=8;
        } else if (code1<0x80) {
          uchar cA,cB;
          cB=remap[from[0]];
          cA=remap[from[1]];
          from+=2;
          cram8c2(iptr,code0,cA,cB,rowDec); iptr-=rowDec;
          cram8c2(iptr,code1,cA,cB,rowDec);
        } else {
          code0=remap[code0];
          cram8c1(iptr,code0,rowDec);
        }
        blockInc(xp,yp,rowDec);
      }
    }
  }
}
/* \\\ */

/* /// "DecodeMSVC8toRGB()" */
__asm void DecodeMSVC8toRGB(REG(a0) uchar *from,
                            REG(a1) uchar *to,
                            REG(d0) ulong width,
                            REG(d1) ulong height,
                            REG(d2) ulong encSize,
                            REG(a2) struct MSVCData *spec)
{
  long exitflag=0;
  ulong code0;
  ulong code1;
  ulong blockCnt=((width*height)>>4)+1;
  long xp=0;
  long yp=height-1;
  ulong rowDec=width;

  while(!exitflag) {
    code0=from[0];
    code1=from[1];
    from+=2;
    blockCnt--;
    if (((code1==0) && (code0==0) && !blockCnt) || (yp<0))
      exitflag=1;
    else {
      if ((code1>=0x84) && (code1<=0x87)) {
        ulong skip=((code1-0x84)<<8)+code0;
        blockCnt-=(skip-1);
        while(skip--) blockInc(xp,yp,rowDec);
      } else {
        RGBTriple *iptr=(RGBTriple *)(to+(yp*width+xp)*4);
        if (code1>=0x90) {
          RGBTriple clrA0, clrA1, clrB0, clrB1;
          clrA0.alpha=0;
          clrA1.alpha=0;
          clrB0.alpha=0;
          clrB1.alpha=0;
          Idx332ToRGB(from[0],clrB0.red,clrB0.green,clrB0.blue);
          Idx332ToRGB(from[1],clrA0.red,clrA0.green,clrA0.blue);
          Idx332ToRGB(from[2],clrB1.red,clrB1.green,clrB1.blue);
          Idx332ToRGB(from[3],clrA1.red,clrA1.green,clrA1.blue);
          cram8c4(iptr,code0,clrA0,clrA1,clrB0,clrB1,rowDec); iptr-=rowDec;
          Idx332ToRGB(from[4],clrB0.red,clrB0.green,clrB0.blue);
          Idx332ToRGB(from[5],clrA0.red,clrA0.green,clrA0.blue);
          Idx332ToRGB(from[6],clrB1.red,clrB1.green,clrB1.blue);
          Idx332ToRGB(from[7],clrA1.red,clrA1.green,clrA1.blue);
          cram8c4(iptr,code1,clrA0,clrA1,clrB0,clrB1,rowDec);
          from+=8;
        } else if (code1<0x80) {
          RGBTriple clrA, clrB;
          clrA.alpha=0;
          clrB.alpha=0;
          Idx332ToRGB(from[0],clrB.red,clrB.green,clrB.blue);
          Idx332ToRGB(from[1],clrA.red,clrA.green,clrA.blue);
          cram8c2(iptr,code0,clrA,clrB,rowDec); iptr-=rowDec;
          cram8c2(iptr,code1,clrA,clrB,rowDec);
          from+=2;
        } else {
          RGBTriple clr;
          clr.alpha=0;
          Idx332ToRGB(code0,clr.red,clr.green,clr.blue);
          cram8c1(iptr,clr,rowDec);
        }
        blockInc(xp,yp,rowDec);
      }
    }
  }
}
/* \\\ */

/* /// "DecodeMSVC16toRGB()" */
__asm void DecodeMSVC16toRGB(REG(a0) uchar *from,
                             REG(a1) uchar *to,
                             REG(d0) ulong width,
                             REG(d1) ulong height,
                             REG(d2) ulong encSize,
                             REG(a2) struct MSVCData *spec)
{
  long exitflag=0;
  ulong code0;
  ulong code1;
  ulong blockCnt=((width*height)>>4)+1;
  long xp=0;
  long yp=height-1;
  ulong rowDec=width;

  while(!exitflag) {
    code0=*from++;
    code1=*from++;
    blockCnt--;
    if (((code1==0) && (code0==0) && !blockCnt) || (yp<0)) {
      exitflag=1;
      continue;
    }
    if ((code1>=0x84) && (code1<=0x87)) {
      ulong skip=((code1-0x84)<<8)+code0;
      blockCnt-=(skip-1);
      while(skip--) blockInc(xp,yp,rowDec);
    } else {
      RGBTriple *iptr=(RGBTriple *)(to+(yp*width+xp)*4);
      if (code1<0x80) {
        ulong cA, cB;
        RGBTriple clrA0, clrB0;
        cB=get16pc(from);
        cA=get16pc(from);
        clrA0.alpha=0;
        clrB0.alpha=0;
        RGB16toRGB24(cA,clrA0.red,clrA0.green,clrA0.blue);
        RGB16toRGB24(cB,clrB0.red,clrB0.green,clrB0.blue);
        if (cB & 0x8000) {
          RGBTriple clrA1, clrB1;
          cB=get16pc(from);
          cA=get16pc(from);
          clrA1.alpha=0;
          clrB1.alpha=0;
          RGB16toRGB24(cA,clrA1.red,clrA1.green,clrA1.blue);
          RGB16toRGB24(cB,clrB1.red,clrB1.green,clrB1.blue);
          cram8c4(iptr,code0,clrA0,clrA1,clrB0,clrB1,rowDec); iptr-=rowDec;
          cB=get16pc(from);
          cA=get16pc(from);
          RGB16toRGB24(cA,clrA0.red,clrA0.green,clrA0.blue);
          RGB16toRGB24(cB,clrB0.red,clrB0.green,clrB0.blue);
          cB=get16pc(from);
          cA=get16pc(from);
          RGB16toRGB24(cA,clrA1.red,clrA1.green,clrA1.blue);
          RGB16toRGB24(cB,clrB1.red,clrB1.green,clrB1.blue);
          cram8c4(iptr,code1,clrA0,clrA1,clrB0,clrB1,rowDec);
        } else {
          cram8c2(iptr,code0,clrA0,clrB0,rowDec); iptr-=rowDec;
          cram8c2(iptr,code1,clrA0,clrB0,rowDec);
        }
      } else {
        ulong cA=(code1<<8) | code0;
        RGBTriple clr;
        clr.alpha=0;
        RGB16toRGB24(cA,clr.red,clr.green,clr.blue);
        cram8c1(iptr,clr,rowDec);
      }
      blockInc(xp,yp,rowDec);
    }
  }
}
/* \\\ */

/* /// "DecodeMSVC16to332()" */
__asm void DecodeMSVC16to332(REG(a0) uchar *from,
                             REG(a1) uchar *to,
                             REG(d0) ulong width,
                             REG(d1) ulong height,
                             REG(d2) ulong encSize,
                             REG(a2) struct MSVCData *spec)
{
  long exitflag=0;
  ulong code0;
  ulong code1;
  ulong blockCnt=((width*height)>>4)+1;
  long xp=0;
  long yp=height-1;
  ulong rowDec=width;

  while(!exitflag) {
    code0=from[0];
    code1=from[1];
    from+=2;
    blockCnt--;
    if (((code1==0) && (code0==0) && !blockCnt) || (yp<0)) {
      exitflag=1;
      continue;
    }
    if ((code1>=0x84) && (code1<=0x87)) {
      ulong skip=((code1-0x84)<<8)+code0;
      blockCnt-=(skip-1);
      while(skip--) blockInc(xp,yp,width);
    } else {
      uchar *iptr=(char *)(to+((yp*width)+xp));
      if (code1<0x80) {
        ulong cA, cB, cC, cD;
        uchar cA0,cB0;
        cB=get16pc(from);
        cA=get16pc(from);
        RGB16toColor(cA,cA0);
        RGB16toColor(cB,cB0);
        if (cB & 0x8000) {
          uchar cA1, cB1;
          cB=get16pc(from);
          cA=get16pc(from);
          RGB16toColor(cA,cA1);
          RGB16toColor(cB,cB1);
          cram8c4(iptr,code0,cA0,cA1,cB0,cB1,rowDec); iptr-=rowDec;
          cB=get16pc(from);
          cA=get16pc(from);
          cD=get16pc(from);
          cC=get16pc(from);
          RGB16toColor(cA,cA0);
          RGB16toColor(cB,cB0);
          RGB16toColor(cC,cA1);
          RGB16toColor(cD,cB1);
          cram8c4(iptr,code1,cA0,cA1,cB0,cB1,rowDec);
        } else {
          cram8c2(iptr,code0,cA0,cB0,rowDec); iptr-=rowDec;
          cram8c2(iptr,code1,cA0,cB0,rowDec);
        }
      } else {
        uchar *iptr=to+yp*width+xp;
        ulong cA=(code1<<8) | code0;
        uchar clr;
        RGB16toColor(cA,clr);
        cram8c1(iptr,cA,rowDec);
      }
      blockInc(xp,yp,rowDec);
    }
  }
}
/* \\\ */

/* /// "DecodeMSVC16to332Dith()" */
__asm void DecodeMSVC16to332Dith(REG(a0) uchar *from,
                                 REG(a1) uchar *to,
                                 REG(d0) ulong width,
                                 REG(d1) ulong height,
                                 REG(d2) ulong encSize,
                                 REG(a2) struct MSVCData *spec)
{
  long exitflag=0;
  ulong code0, code1;
  ulong blockCnt=((width*height)>>4)+1;
  long xp=0;
  long yp=height-1;
  ulong rowDec=width;

  while(!exitflag) {
    code0=from[0];
    code1=from[1];
    from+=2;
    blockCnt--;
    if (((code1==0) && (code0==0) && !blockCnt) || (yp<0)) {
      exitflag=1;
      continue;
    }
    if ((code1>=0x84) && (code1<=0x87)) {
      ulong skip=((code1-0x84)<<8)+code0;
      blockCnt-=(skip-1);
      while(skip--) blockInc(xp,yp,rowDec);
    } else {
      ulong r, g, b;
      uchar *iptr=to+((yp*width)+xp);
      if (code1<0x80) {
        ulong cA, cB, cC, cD;
        uchar cA0,cB0;
        cB=get16pc(from);
        cA=get16pc(from);
        if (cB & 0x8000) {
          ulong cA1, cB1;
          RGB16toColor(cA,cA0);
          RGB16toColor(cB,cB0);
          cB=get16pc(from);
          cA=get16pc(from);
          RGB16toColor(cA,cA1);
          RGB16toColor(cB,cB1);
          cram8c4(iptr,code0,cA0,cA1,cB0,cB1,rowDec); iptr-=rowDec;
          cB=get16pc(from);
          cA=get16pc(from);
          cD=get16pc(from);
          cC=get16pc(from);
          RGB16toColor(cA,cA0);
          RGB16toColor(cB,cB0);
          RGB16toColor(cC,cA1);
          RGB16toColor(cD,cB1);
          cram8c4(iptr,code1,cA0,cA1,cB0,cB1,rowDec);
        } else {
          ulong clr0a, clr0b, clr1a, clr1b;
          long re=0, ge=0, be=0;
          RGB16toRGB24(cA,r,g,b);
          DitherGetRGB(r,g,b,re,ge,be,clr0a);
          DitherGetRGB(r,g,b,re,ge,be,clr1a);
          RGB16toRGB24(cB,r,g,b);
          DitherGetRGB(r,g,b,re,ge,be,clr0b);
          DitherGetRGB(r,g,b,re,ge,be,clr1b);
          iptr[0]=(code0 & 0x01) ? (clr0b) : (clr0a);
          iptr[1]=(code0 & 0x02) ? (clr1b) : (clr1a);
          iptr[2]=(code0 & 0x04) ? (clr0b) : (clr0a);
          iptr[3]=(code0 & 0x08) ? (clr1b) : (clr1a);
          iptr-=rowDec;
          iptr[0]=(code0 & 0x10) ? (clr1b) : (clr1a);
          iptr[1]=(code0 & 0x20) ? (clr0b) : (clr0a);
          iptr[2]=(code0 & 0x40) ? (clr1b) : (clr1a);
          iptr[3]=(code0 & 0x80) ? (clr0b) : (clr0a);
          iptr-=rowDec;
          iptr[0]=(code1 & 0x01) ? (clr0b) : (clr0a);
          iptr[1]=(code1 & 0x02) ? (clr1b) : (clr1a);
          iptr[2]=(code1 & 0x04) ? (clr0b) : (clr0a);
          iptr[3]=(code1 & 0x08) ? (clr1b) : (clr1a);
          iptr-=rowDec;
          iptr[0]=(code1 & 0x10) ? (clr1b) : (clr1a);
          iptr[1]=(code1 & 0x20) ? (clr0b) : (clr0a);
          iptr[2]=(code1 & 0x40) ? (clr1b) : (clr1a);
          iptr[3]=(code1 & 0x80) ? (clr0b) : (clr0a);
        }
      } else {
        ulong cA=(code1<<8) | code0;
        ulong clr0, clr1;
        long re=0, ge=0, be=0;
        RGB16toRGB24(cA,r,g,b);
        DitherGetRGB(r,g,b,re,ge,be,clr0);
        DitherGetRGB(r,g,b,re,ge,be,clr1);
        iptr[0]=clr0; iptr[1]=clr1; iptr[2]=clr0; iptr[3]=clr1; iptr-=rowDec;
        iptr[0]=clr1; iptr[1]=clr0; iptr[2]=clr1; iptr[3]=clr0; iptr-=rowDec;
        iptr[0]=clr0; iptr[1]=clr1; iptr[2]=clr0; iptr[3]=clr1; iptr-=rowDec;
        iptr[0]=clr1; iptr[1]=clr0; iptr[2]=clr1; iptr[3]=clr0;
      }
      blockInc(xp,yp,rowDec);
    }
  }
}
/* \\\ */

