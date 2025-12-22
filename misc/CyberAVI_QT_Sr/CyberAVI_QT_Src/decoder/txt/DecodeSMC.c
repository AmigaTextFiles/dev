/*
sc:c/sc opt txt/DecodeSMC.c
*/

#include "Decode.h"

#define smcMaxCnt 256

struct SMCData {
  ulong smc8[2*smcMaxCnt];
  ulong smcA[4*smcMaxCnt];
  ulong smcC[8*smcMaxCnt];
};

/* /// "blockInc" */
#define blockInc(x,y,xmax) { \
                      x+=4; \
                      if (x>=xmax) { \
                        x=0; \
                        y+=4; \
                      } \
                   }
/* \\\ */

/* /// "smcO2I" */
#define smcO2I(ip,op,rInc) {                                              \
  ip[0]=op[0]; ip[1]=op[1]; ip[2]=op[2]; ip[3]=op[3]; ip+=rInc; op+=rInc; \
  ip[0]=op[0]; ip[1]=op[1]; ip[2]=op[2]; ip[3]=op[3]; ip+=rInc; op+=rInc; \
  ip[0]=op[0]; ip[1]=op[1]; ip[2]=op[2]; ip[3]=op[3]; ip+=rInc; op+=rInc; \
  ip[0]=op[0]; ip[1]=op[1]; ip[2]=op[2]; ip[3]=op[3];                     \
}
/* \\\ */

/* /// "smcC1" */
#define smcC1(ip,c,rInc) {                      \
  ip[0]=c; ip[1]=c; ip[2]=c; ip[3]=c; ip+=rInc; \
  ip[0]=c; ip[1]=c; ip[2]=c; ip[3]=c; ip+=rInc; \
  ip[0]=c; ip[1]=c; ip[2]=c; ip[3]=c; ip+=rInc; \
  ip[0]=c; ip[1]=c; ip[2]=c; ip[3]=c; ip+=rInc; \
}
/* \\\ */

/* /// "smcC2" */
#define smcC2(ip,c0,c1,mask,rInc) { \
  ip[0]=(mask & 0x80) ? c1 : c0;    \
  ip[1]=(mask & 0x40) ? c1 : c0;    \
  ip[2]=(mask & 0x20) ? c1 : c0;    \
  ip[3]=(mask & 0x10) ? c1 : c0;    \
  ip+=rInc;                         \
  ip[0]=(mask & 0x08) ? c1 : c0;    \
  ip[1]=(mask & 0x04) ? c1 : c0;    \
  ip[2]=(mask & 0x02) ? c1 : c0;    \
  ip[3]=(mask & 0x01) ? c1 : c0;    \
}
/* \\\ */

/* /// "smcC4" */
#define smcC4(ip,c,maskA,maskB,rInc) { \
  ip[0]=c[(maskA>>6) & 0x03];          \
  ip[1]=c[(maskA>>4) & 0x03];          \
  ip[2]=c[(maskA>>2) & 0x03];          \
  ip[3]=c[ maskA     & 0x03];          \
  ip+=rInc;                            \
  ip[0]=c[(maskB>>6) & 0x03];          \
  ip[1]=c[(maskB>>4) & 0x03];          \
  ip[2]=c[(maskB>>2) & 0x03];          \
  ip[3]=c[ maskB     & 0x03];          \
}
/* \\\ */

/* /// "smcC8" */
#define smcC8(ip,c,mask,rInc) { \
  ip[0]=c[(mask>>21) & 0x07];   \
  ip[1]=c[(mask>>18) & 0x07];   \
  ip[2]=c[(mask>>15) & 0x07];   \
  ip[3]=c[(mask>>12) & 0x07];   \
  ip+=rInc;                     \
  ip[0]=c[(mask>> 9) & 0x07];   \
  ip[1]=c[(mask>> 6) & 0x07];   \
  ip[2]=c[(mask>> 3) & 0x07];   \
  ip[3]=c[ mask      & 0x07];   \
}
/* \\\ */

/* /// "smcC16" */
#define smcC16(ip,dp) { \
  ip[0]=dp[0];          \
  ip[1]=dp[1];          \
  ip[2]=dp[2];          \
  ip[3]=dp[3];          \
}
/* \\\ */

/* /// "DecodeSMC()" */
__asm void DecodeSMC(REG(a0) uchar *from,
                     REG(a1) uchar *to,
                     REG(d0) ulong width,
                     REG(d1) ulong height,
                     REG(d2) ulong encSize,
                     REG(a2) struct SMCData *spec)
{
  long x, y, len, rowInc;
  ulong i, cnt, hiCode, code, *c;
  ulong smc8Cnt, smcACnt, smcCCnt;

  smc8Cnt=0;
  smcACnt=0;
  smcCCnt=0;
  x=0;
  y=0;
  rowInc=width;

  from++;
  len=get24(from);
  len-=4;
  while (len>0) {
    code=*from++;
    hiCode=code & 0xf0;
    code=(code & 0x0f)+1;
    len--;
    switch (hiCode) {
      case 0x00:
      case 0x10:
        {
          if (hiCode==0x10) {
            cnt=*from++;
            cnt++;
            len--;
          } else {
            cnt=code;
          }
          while (cnt--) blockInc(x,y,width);
        }
        break;

      case 0x20:
      case 0x30:
        {
          ulong tx, ty;
          uchar *op;
          if (hiCode==0x30) {
            cnt=*from++;
            cnt++;
            len--;
          } else {
            cnt=code;
          }
          if (x==0) {
            ty=y-4;
            tx=width-4;
          } else {
            ty=y;
            tx=x-4;
          }
          op=to+(ty*width+tx);
          while (cnt--) {
            uchar *iptr=to+(y*width+x);
            uchar *optr=op;
            smcO2I(iptr,optr,rowInc);
            blockInc(x,y,width);
          }
        }
        break;

      case 0x40:
      case 0x50:
        {
          ulong cnt, cnt1;
          long mtx, mty, tx, ty;
          if (hiCode==0x50) {
            cnt1=*from++;
            cnt1++;
            len--;
          } else {
            cnt1=code;
          }
          mtx=x-8;
          mty=y;
          if (mtx<0) {
            mtx+=width;
            mty-=4;
          }
          while (cnt1--) {
            uchar *iptr, *optr;
            cnt=2;
            tx=mtx;
            ty=mty;
            while (cnt--) {
              iptr=to+(y*width+x);
              optr=to+(ty*width+tx);
              smcO2I(iptr,optr,rowInc);
              blockInc(x,y,width);
              blockInc(tx,ty,width);
            }
          }
        }
        break;

      case 0x60:
      case 0x70:
        {
          ulong ct, cnt;
          if (hiCode==0x70) {
            cnt=*from++;
            cnt++;
            len--;
          } else {
            cnt=code;
          }
          ct=*from++;
          len--;
          while (cnt--) {
            uchar *iptr=to+(y*width+x);
            smcC1(iptr,ct,rowInc);
            blockInc(x,y,width);
          }
        }
        break;

      case 0x80:
      case 0x90:
        {
          ulong cnt=code;
          if (hiCode==0x80) {
            c=&spec->smc8[smc8Cnt<<1];
            smc8Cnt++;
            if (smc8Cnt==smcMaxCnt) smc8Cnt=0;
            for (i=0; i<2; i++) c[i]=*from++;
            len-=2;
          } else {
            c=&spec->smc8[(*from++)<<1];
            len--;
          }
          while (cnt--) {
            ulong mask0, mask1;
            uchar *iptr=to+(y*width+x);
            mask0=from[0];
            mask1=from[1];
            from+=2;
            len-=2;
            smcC2(iptr,c[0],c[1],mask0,rowInc); iptr+=rowInc;
            smcC2(iptr,c[0],c[1],mask1,rowInc);
            blockInc(x,y,width);
          }
        }
        break;

      case 0xa0:
      case 0xb0:
        {
          ulong cnt=code;
          if (hiCode==0xa0) {
            c=&spec->smcA[smcACnt<<2];
            smcACnt++;
            if (smcACnt==smcMaxCnt) smcACnt=0;
            for (i=0; i<4; i++) c[i]=*from++;
            len-=4;
          } else {
            c=&spec->smcA[(*from++)<<2];
            len--;
          }
          while (cnt--) {
            ulong mask0, mask1, mask2, mask3;
            uchar *iptr=to+(y*width+x);
            mask0=from[0];
            mask1=from[1];
            mask2=from[2];
            mask3=from[3];
            from+=4;
            len-=4;
            smcC4(iptr,c,mask0,mask1,rowInc); iptr+=rowInc;
            smcC4(iptr,c,mask2,mask3,rowInc);
            blockInc(x,y,width);
          }
        }
        break;

      case 0xc0:
      case 0xd0:
        {
          ulong cnt=code;
          if (hiCode==0xc0) {
            c=&spec->smcC[smcCCnt<<3];
            smcCCnt++;
            if (smcCCnt==smcMaxCnt) smcCCnt=0;
            for (i=0; i<8; i++) c[i]=*from++;
            len-=8;
          } else {
            c=&spec->smcC[(*from++)<<3];
            len--;
          }
          while (cnt--) {
            ulong t, mBits0, mBits1;
            uchar *iptr=to+(y*width+x);
            t=get16(from);
            mBits0=(t & 0xfff0)<<8;
            mBits1=(t & 0x000f)<<8;
            t=get16(from);
            mBits0|=(t & 0xfff0)>>4;
            mBits1|=(t & 0x000f)<<4;
            t=get16(from);
            mBits1|=(t & 0xfff0)<<8;
            mBits1|=(t & 0x000f);
            len-=6;
            smcC8(iptr,c,mBits0,rowInc); iptr+=rowInc;
            smcC8(iptr,c,mBits1,rowInc);
            blockInc(x,y,width);
          }
        }
        break;

      case 0xe0:
        {
          ulong cnt=code;
          while (cnt--) {
            uchar *iptr=to+(y*width+x);
            smcC16(iptr,from); iptr+=rowInc; from+=4;
            smcC16(iptr,from); iptr+=rowInc; from+=4;
            smcC16(iptr,from); iptr+=rowInc; from+=4;
            smcC16(iptr,from); iptr+=rowInc; from+=4;
            len-=16;
            blockInc(x,y,width);
          }
        }
        break;
      default: break;
    }
  }
}
/* \\\ */

