/*
sc:c/sc opt txt/DecodeRLE.c
*/

#include "Decode.h"
#include "YUV.h"
#include "Utils.h"
#include "GlobalVars.h"

struct RLEData {
  ulong dummy;
};

/* /// "DecodeRLE8toRGB()" */
__asm void DecodeRLE8toRGB(REG(a0) uchar *from,
                           REG(a1) uchar *to,
                           REG(d0) ulong width,
                           REG(d1) ulong height,
                           REG(d2) ulong encSize,
                           REG(a2) struct RLEData *spec)
{
  long x, y;
  uchar *iptr;
  ulong mod, opcode, d;
  ulong rowDec=width*2*4;

  x=0;
  y=height-1;
  while (y>=0) {
    mod=*from++;
    opcode=*from++;
    if (mod==0x00) {
      if (opcode==0x00) {
        while (x>width) { x-=width; y--; };
        x=0;
        y--;
      } else if (opcode==0x01) {
        y=-1;
      } else if (opcode==0x02) {
        ulong yskip, xskip;
        xskip=*from++;
        yskip=*from++;
        x+=xskip;
        y-=yskip;
      } else {
        long cnt=opcode;
        while (x>=width) { x-=width; y--; };
        iptr=(to+(y*width+x)*4);
        while (cnt--) {
          if (x>=width) {
            x-=width;
            y--;
            iptr-=rowDec; /* iptr=(to+(y*width+x)); */
          }
          d=*from++;
          Idx332ToRGB(d,iptr[1],iptr[2],iptr[3]);
          iptr+=4;
          x++;
        }
        if(opcode & 0x01) from++;
      }
    } else {
      long color, cnt;
      while (x>=width) { x-=width; y--; };
      cnt=mod;
      color=opcode;
      iptr=(to+(y*width+x)*4);
      while (cnt--) {
        if (x>=width) {
          x-=width;
          y--;
          iptr-=rowDec; /* iptr=(to+(y*width+x)); */
        }
        Idx332ToRGB(color,iptr[1],iptr[2],iptr[3]);
        iptr+=4;
        x++;
      }
    }
  }
}
/* \\\ */

/* /// "DecodeRLE8to332()" */
__asm void DecodeRLE8to332(REG(a0) uchar *from,
                           REG(a1) uchar *to,
                           REG(d0) ulong width,
                           REG(d1) ulong height,
                           REG(d2) ulong encSize,
                           REG(a2) struct RLEData *spec)
{
  long x, y;
  uchar *iptr;
  ulong mod, opcode;

  x=0;
  y=height-1;
  while (y>=0) {
    mod=*from++;
    opcode=*from++;
    if (mod==0x00) {
      if (opcode==0x00) {
        while (x>width) { x-=width; y--; };
        x=0;
        y--;
      } else if (opcode==0x01) {
        y=-1;
      } else if (opcode==0x02) {
        ulong yskip, xskip;
        xskip=*from++;
        yskip=*from++;
        x+=xskip;
        y-=yskip;
      } else {
        long cnt=opcode;
        while (x>=width) { x-=width; y--; };
        iptr=(to+(y*width+x));
        while (cnt--) {
          if (x>=width) {
            x-=width;
            y--;
            iptr-=(width*2); /* iptr=(to+(y*width+x)); */
          }
          *iptr++=remap[*from++];
          x++;
        }
        if(opcode & 0x01) from++;
      }
    } else {
      long color, cnt;
      while (x>=width) { x-=width; y--; };
      cnt=mod;
      color=remap[opcode];
      iptr=(to+(y*width+x));
      while (cnt--) {
        if (x>=width) {
          x-=width;
          y--;
          iptr-=(width*2); /* iptr=(to+(y*width+x)); */
        }
        *iptr++=color;
        x++;
      }
    }
  }
}
/* \\\ */

