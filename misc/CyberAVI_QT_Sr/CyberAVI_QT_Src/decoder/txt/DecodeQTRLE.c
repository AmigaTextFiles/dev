/*
sc:c/sc opt txt/DecodeQTRLE.c
*/

#include "Decode.h"
#include "YUV.h"
#include "Utils.h"

struct QTRLEData {
  uchar gray;
  uchar *rngLimit;
  struct RGBTriple *cmap;
};

/* /// "DecodeQTRLE1()" */
__asm void DecodeQTRLE1(REG(a0) uchar *from,
                        REG(a1) uchar *to,
                        REG(d0) ulong width,
                        REG(d1) ulong height,
                        REG(d2) ulong encSize,
                        REG(a2) uchar *spec)
{
  long x, y, lines, d;

  if (encSize<8) return;
  from+=4;
  d=get16(from);
  if (d & 0x0008) {
    y=get16(from);
    from+=2;
    lines=get16(from);
    from+=2;
  } else {
    y=0;
    lines=height;
  }
  x=0;
  y--;
  lines++;
  while (lines) {
    ulong xskip, cnt;
    uchar *iptr;
    xskip=*from++;
    cnt=*from++;
    if (cnt==0) break;
    if ((xskip==0x80) & (cnt==0x00)) {
      lines=0;
      y++;
      x=0;
    } else if ((xskip==0x80) && (cnt==0xff)) {
      lines--;
      y++;
      x=0;
    } else {
      if (xskip & 0x80) {
        lines--;
        y++;
        x=xskip & 0x7f;
      } else {
        x+=xskip;
      }
      iptr=to+(y*width)+(x<<4);
      if (cnt<0x80) {
        x+=cnt;
        while(cnt--) {
          ulong i, mask;
          d=get16(from);
          mask=0x8000;
          for (i=0; i<16; i++) {
            *iptr++=(d & mask) ? 0 : 1;
            mask>>=1;
          }
        }
      } else {
        cnt=0x100-cnt;
        x+=cnt;
        d=get16(from);
        while (cnt--) {
          ulong i, mask;
          mask=0x8000;
          for (i=0; i<16; i++) {
            *iptr++=(d & mask) ? 0 : 1;
            mask>>=1;
          }
        }
      }
    }
  }
}
/* \\\ */

/* /// "DecodeQTRLE4()" */
__asm void DecodeQTRLE4(REG(a0) uchar *from,
                        REG(a1) uchar *to,
                        REG(d0) ulong width,
                        REG(d1) ulong height,
                        REG(d2) ulong encSize,
                        REG(a2) uchar *spec)
{
  long x, y, lines, d;

  if (encSize<8) return;
  from+=4;
  d=get16(from);
  if (d & 0x0008) {
    y=get16(from);
    from+=2;
    lines=get16(from);
    from+=2;
  } else {
    y=0;
    lines=height;
  }
  x=-1;
  while (lines) {
    ulong xskip, cnt;
    if (x==-1) {
      xskip=*from++;
      if (xskip==0) break;
    } else {
      xskip=0;
    }
    cnt=*from++;
    if (cnt==0x00) {
      lines=0;
      y++;
      x=-1;
    } else if (cnt==0xff) {
      lines--;
      y++;
      x=-1;
    } else {
      uchar *iptr;
      if (xskip & 0x80) {
        lines--;
        y++;
        x=xskip & 0x7f;
      } else {
        x+=xskip;
      }
      iptr=to+(y*width)+(x<<3);
      if (cnt<0x80) {
        x+=cnt;
        while (cnt--) {
          ulong i, shift, d0;
          d0=get32(from);
          shift=32;
          for (i=0; i<8; i++) {
            shift-=4;
            *iptr++=(d0>>shift) & 0x0f;
          }
        }
      } else {
        ulong d0;
        cnt=0x100-cnt;
        d0=get32(from);
        while (cnt--) {
          ulong i, shift;
          shift=32;
          for (i=0; i<8; i++) {
            shift-=4;
            *iptr++=(d0>>shift) & 0x0f;
          }
        }
      }
    }
  }
}
/* \\\ */

/* /// "DecodeQTRLE8()" */
__asm void DecodeQTRLE8(REG(a0) uchar *from,
                        REG(a1) uchar *to,
                        REG(d0) ulong width,
                        REG(d1) ulong height,
                        REG(d2) ulong encSize,
                        REG(a2) uchar *spec)
{
  long y, lines, d;

  if (encSize<8) return;
  from+=4;
  d=get16(from);
  if (d & 0x0008) {
    y=get16(from);
    from+=2;
    lines=get16(from);
    from+=2;
  } else {
    y=0;
    lines=height;
  }

  while (lines--) {
    ulong xskip, cnt;
    uchar *iptr;
    xskip=*from++;
    if (xskip==0) break;
    cnt=*from++;
    iptr=to+(y*width)+4*(xskip-1);
    while (cnt!=0xff) {
      if (cnt==0x00) {
        xskip=*from++;
        iptr+=4*(xskip-1);
      } else if (cnt<0x80) {
        cnt*=4;
        while (cnt--) *iptr++=*from++;
      } else {
        uchar d1, d2, d3, d4;
        cnt=0x100-cnt;
        d1=from[0];
        d2=from[1];
        d3=from[2];
        d4=from[3];
        from+=4;
        while (cnt--) {
          iptr[0]=d1;
          iptr[1]=d2;
          iptr[2]=d3;
          iptr[3]=d4;
          iptr+=4;
        }
      }
      cnt=*from++;
    }
    y++;
  }
}
/* \\\ */

/* /// "DecodeQTRLE16toRGB()" */
__asm void DecodeQTRLE16toRGB(REG(a0) uchar *from,
                              REG(a1) uchar *to,
                              REG(d0) ulong width,
                              REG(d1) ulong height,
                              REG(d2) ulong encSize,
                              REG(a2) uchar *spec)
{
  long y, lines, d;
  uchar r, g, b;

  if (encSize<8) return;
  from+=4;
  d=get16(from);
  if (d & 0x0008) {
    y=get16(from);
    from+=2;
    lines=get16(from);
    from+=2;
  } else {
    y=0;
    lines=height;
  }
  while (lines--) {
    ulong d, xskip, cnt;
    uchar *iptr;
    xskip=*from++;
    if (xskip==0) break;
    cnt=*from++;
    iptr=to+(y*width+xskip-1)*3;
    while (cnt!=0xff) {
      if (cnt==0x00) {
        xskip=*from++;
        iptr+=3*(xskip-1);
      } else if (cnt<0x80) {
        while (cnt--) {
          d=get16(from);
          ColorToRGB(d,r,g,b);
          iptr[0]=r;
          iptr[1]=g;
          iptr[2]=b;
          iptr+=3;
        }
      } else {
        cnt=0x100-cnt;
        d=get16(from);
        ColorToRGB(d,r,g,b);
        while (cnt--) {
          iptr[0]=r;
          iptr[1]=g;
          iptr[2]=b;
          iptr+=3;
        }
      }
      cnt=*from++;
    }
    y++;
  }
}
/* \\\ */

/* /// "DecodeQTRLE16to332()" */
__asm void DecodeQTRLE16to332(REG(a0) uchar *from,
                              REG(a1) uchar *to,
                              REG(d0) ulong width,
                              REG(d1) ulong height,
                              REG(d2) ulong encSize,
                              REG(a2) struct QTRLEData *spec)
{
  long y, lines, d;
  uchar gray=spec->gray;

  if (encSize<8) return;
  from+=4;
  d=get16(from);
  if (d & 0x0008) {
    y=get16(from);
    from+=2;
    lines=get16(from);
    from+=2;
  } else {
    y=0;
    lines=height;
  }
  while (lines--) {
    ulong d, xskip, cnt;
    uchar *iptr;
    xskip=*from++;
    if (xskip==0) break;
    cnt=*from++;
    iptr=to+(y*width+xskip-1);
    while (cnt!=0xff) {
      if (cnt==0x00) {
        xskip=*from++;
        iptr+=(xskip-1);
      } else if (cnt<0x80) {
        if (gray) {
          while (cnt--) {
            d=get16(from);
            ColorTo332Gray(d,*iptr++);
          }
        } else {
          while (cnt--) {
            d=get16(from);
            ColorTo332(d,*iptr++);
          }
        }
      } else {
        cnt=0x100-cnt;
        d=get16(from);
        if (gray) {ColorTo332Gray(d,d);} else {ColorTo332(d,d);}
        while (cnt--) *iptr++=d;
      }
      cnt=*from++;
    }
    y++;
  }
}
/* \\\ */

/* /// "DecodeQTRLE16to332Dith()" */
__asm void DecodeQTRLE16to332Dith(REG(a0) uchar *from,
                                  REG(a1) uchar *to,
                                  REG(d0) ulong width,
                                  REG(d1) ulong height,
                                  REG(d2) ulong encSize,
                                  REG(a2) struct QTRLEData *spec)
{
  long y, lines, d;
  uchar *rngLimit=spec->rngLimit;
  struct RGBTriple *cmap=spec->cmap;

  if (encSize<8) return;
  from+=4;
  d=get16(from);
  if (d & 0x0008) {
    y=get16(from);
    from+=2;
    lines=get16(from);
    from+=2;
  } else {
    y=0;
    lines=height;
  }
  while (lines--) {
    ulong d, xskip, cnt;
    uchar *iptr;
    ulong r, g, b, color;
    long re=0, ge=0, be=0;
    xskip=*from++;
    if (xskip==0) break;
    cnt=*from++;
    iptr=to+(y*width+xskip-1);
    while (cnt!=0xff) {
      if (cnt==0x00) {
        xskip=*from++;
        iptr+=(xskip-1);
      } else if (cnt<0x80) {
        while (cnt--) {
          d=get16(from);
          ColorToRGB(d,r,g,b);
          DitherGetRGB(r,g,b,re,ge,be,color);
          *iptr++=color;
        }
      } else {
        cnt=0x100-cnt;
        d=get16(from);
        ColorToRGB(d,r,g,b);
        while (cnt--) {
          DitherGetRGB(r,g,b,re,ge,be,color);
          *iptr++=color;
        }
      }
      cnt=*from++;
    }
    y++;
  }
}
/* \\\ */

/* /// "DecodeQTRLE24toRGB()" */
__asm void DecodeQTRLE24toRGB(REG(a0) uchar *from,
                              REG(a1) uchar *to,
                              REG(d0) ulong width,
                              REG(d1) ulong height,
                              REG(d2) ulong encSize,
                              REG(a2) uchar *spec)
{
  long y, lines, d;
  uchar r, g, b;

  if (encSize<8) return;
  from+=4;
  d=get16(from);
  if (d & 0x0008) {
    y=get16(from);
    from+=2;
    lines=get16(from);
    from+=2;
  } else {
    y=0;
    lines=height;
  }
  while (lines--) {
    ulong xskip, cnt;
    uchar *iptr;
    xskip=*from++;
    if (xskip==0) break;
    cnt=*from++;
    iptr=to+(y*width+xskip-1)*3;
    while (cnt!=0xff) {
      if (cnt==0x00) {
        xskip=*from++;
        iptr+=3*(xskip-1);
      } else if (cnt<0x80) {
        while (cnt--) {
          iptr[0]=from[0]; /* r */
          iptr[1]=from[1]; /* g */
          iptr[2]=from[2]; /* b */
          iptr+=3;
          from+=3;
        }
      } else {
        cnt=0x100-cnt;
        r=from[0];
        g=from[1];
        b=from[2];
        from+=3;
        while (cnt--) {
          iptr[0]=r;
          iptr[1]=g;
          iptr[2]=b;
          iptr+=3;
        }
      }
      cnt=*from++;
    }
    y++;
  }
}
/* \\\ */

/* /// "DecodeQTRLE24to332()" */
__asm void DecodeQTRLE24to332(REG(a0) uchar *from,
                              REG(a1) uchar *to,
                              REG(d0) ulong width,
                              REG(d1) ulong height,
                              REG(d2) ulong encSize,
                              REG(a2) struct QTRLEData *spec)
{
  long y, lines, d;
  uchar r, g, b;
  uchar gray=spec->gray;

  if (encSize<8) return;
  from+=4;
  d=get16(from);
  if (d & 0x0008) {
    y=get16(from);
    from+=2;
    lines=get16(from);
    from+=2;
  } else {
    y=0;
    lines=height;
  }
  while (lines--) {
    ulong d, xskip, cnt;
    uchar *iptr;
    xskip=*from++;
    if (xskip==0) break;
    cnt=*from++;
    iptr=to+(y*width+xskip-1);
    while (cnt!=0xff) {
      if (cnt==0x00) {
        xskip=*from++;
        iptr+=(xskip-1);
      } else if (cnt<0x80) {
        if (gray) {
          while (cnt--) {
            r=from[0];
            g=from[1];
            b=from[2];
            from+=3;
            *iptr++=RGB8toGray(r,g,b);
          }
        } else {
          while (cnt--) {
            r=from[0];
            g=from[1];
            b=from[2];
            from+=3;
            *iptr++=RGBto332(r,g,b,scale8);
          }
        }
      } else {
        cnt=0x100-cnt;
        r=from[0];
        g=from[1];
        b=from[2];
        from+=3;
        d=(gray) ? RGB8toGray(r,g,b) : RGBto332(r,g,b,scale8);
        while (cnt--) *iptr++=d;
      }
      cnt=*from++;
    }
    y++;
  }
}
/* \\\ */

/* /// "DecodeQTRLE24to332Dith()" */
__asm void DecodeQTRLE24to332Dith(REG(a0) uchar *from,
                                  REG(a1) uchar *to,
                                  REG(d0) ulong width,
                                  REG(d1) ulong height,
                                  REG(d2) ulong encSize,
                                  REG(a2) struct QTRLEData *spec)
{
  long y, lines, d;
  ulong r, g, b;
  uchar *rngLimit=spec->rngLimit;
  struct RGBTriple *cmap=spec->cmap;

  if (encSize<8) return;
  from+=4;
  d=get16(from);
  if (d & 0x0008) {
    y=get16(from);
    from+=2;
    lines=get16(from);
    from+=2;
  } else {
    y=0;
    lines=height;
  }
  while (lines--) {
    ulong xskip, cnt, color;
    uchar *iptr;
    long re=0, ge=0, be=0;
    xskip=*from++;
    if (xskip==0) break;
    cnt=*from++;
    iptr=to+(y*width+xskip-1);
    while (cnt!=0xff) {
      if (cnt==0x00) {
        xskip=*from++;
        iptr+=(xskip-1);
      } else if (cnt<0x80) {
        while (cnt--) {
          r=from[0];
          g=from[1];
          b=from[2];
          from+=3;
          DitherGetRGB(r,g,b,re,ge,be,color);
          *iptr++=color;
        }
      } else {
        cnt=0x100-cnt;
        r=from[0];
        g=from[1];
        b=from[2];
        from+=3;
        while (cnt--) {
          DitherGetRGB(r,g,b,re,ge,be,color);
          *iptr++=color;
        }
      }
      cnt=*from++;
    }
    y++;
  }
}
/* \\\ */

/* /// "DecodeQTRLE32toRGB()" */
__asm void DecodeQTRLE32toRGB(REG(a0) uchar *from,
                              REG(a1) uchar *to,
                              REG(d0) ulong width,
                              REG(d1) ulong height,
                              REG(d2) ulong encSize,
                              REG(a2) uchar *spec)
{
  long y, lines, d;
  uchar r, g, b;

  if (encSize<8) return;
  from+=4;
  d=get16(from);
  if (d & 0x0008) {
    y=get16(from);
    from+=2;
    lines=get16(from);
    from+=2;
  } else {
    y=0;
    lines=height;
  }
  while (lines--) {
    ulong xskip, cnt;
    uchar *iptr;
    xskip=*from++;
    if (xskip==0) break;
    cnt=*from++;
    iptr=to+(y*width+xskip-1)*3;
    while (cnt!=0xff) {
      if (cnt==0x00) {
        xskip=*from++;
        iptr+=3*(xskip-1);
      } else if (cnt<0x80) {
        while (cnt--) {
          iptr[0]=from[1]; /* r */
          iptr[1]=from[2]; /* g */
          iptr[2]=from[3]; /* b */
          iptr+=3;
          from+=4;
        }
      } else {
        cnt=0x100-cnt;
        r=from[1];
        g=from[2];
        b=from[3];
        from+=4;
        while (cnt--) {
          iptr[0]=r;
          iptr[1]=g;
          iptr[2]=b;
          iptr+=3;
        }
      }
      cnt=*from++;
    }
    y++;
  }
}
/* \\\ */

/* /// "DecodeQTRLE32to332()" */
__asm void DecodeQTRLE32to332(REG(a0) uchar *from,
                              REG(a1) uchar *to,
                              REG(d0) ulong width,
                              REG(d1) ulong height,
                              REG(d2) ulong encSize,
                              REG(a2) struct QTRLEData *spec)
{
  long y, lines, d;
  uchar r, g, b;
  uchar gray=spec->gray;

  if (encSize<8) return;
  from+=4;
  d=get16(from);
  if (d & 0x0008) {
    y=get16(from);
    from+=2;
    lines=get16(from);
    from+=2;
  } else {
    y=0;
    lines=height;
  }
  while (lines--) {
    ulong d, xskip, cnt;
    uchar *iptr;
    xskip=*from++;
    if (xskip==0) break;
    cnt=*from++;
    iptr=to+(y*width+xskip-1);
    while (cnt!=0xff) {
      if (cnt==0x00) {
        xskip=*from++;
        iptr+=(xskip-1);
      } else if (cnt<0x80) {
        if (gray) {
          while (cnt--) {
            r=from[1];
            g=from[2];
            b=from[3];
            from+=4;
            *iptr++=RGB8toGray(r,g,b);
          }
        } else {
          while (cnt--) {
            r=from[1];
            g=from[2];
            b=from[3];
            from+=4;
            *iptr++=RGBto332(r,g,b,scale8);
          }
        }
      } else {
        cnt=0x100-cnt;
        r=from[1];
        g=from[2];
        b=from[3];
        from+=4;
        d=(gray) ? RGB8toGray(r,g,b) : RGBto332(r,g,b,scale8);
        while (cnt--) *iptr++=d;
      }
      cnt=*from++;
    }
    y++;
  }
}
/* \\\ */

/* /// "DecodeQTRLE32to332Dith()" */
__asm void DecodeQTRLE32to332Dith(REG(a0) uchar *from,
                                  REG(a1) uchar *to,
                                  REG(d0) ulong width,
                                  REG(d1) ulong height,
                                  REG(d2) ulong encSize,
                                  REG(a2) struct QTRLEData *spec)
{
  long y, lines, d;
  ulong r, g, b;
  uchar *rngLimit=spec->rngLimit;
  struct RGBTriple *cmap=spec->cmap;

  if (encSize<8) return;
  from+=4;
  d=get16(from);
  if (d & 0x0008) {
    y=get16(from);
    from+=2;
    lines=get16(from);
    from+=2;
  } else {
    y=0;
    lines=height;
  }
  while (lines--) {
    ulong xskip, cnt, color;
    uchar *iptr;
    long re=0, ge=0, be=0;
    xskip=*from++;
    if (xskip==0) break;
    cnt=*from++;
    iptr=to+(y*width+xskip-1);
    while (cnt!=0xff) {
      if (cnt==0x00) {
        xskip=*from++;
        iptr+=(xskip-1);
      } else if (cnt<0x80) {
        while (cnt--) {
          r=from[1];
          g=from[2];
          b=from[3];
          from+=4;
          DitherGetRGB(r,g,b,re,ge,be,color);
          *iptr++=color;
        }
      } else {
        cnt=0x100-cnt;
        r=from[1];
        g=from[2];
        b=from[3];
        from+=4;
        while (cnt--) {
          DitherGetRGB(r,g,b,re,ge,be,color);
          *iptr++=color;
        }
      }
      cnt=*from++;
    }
    y++;
  }
}
/* \\\ */

