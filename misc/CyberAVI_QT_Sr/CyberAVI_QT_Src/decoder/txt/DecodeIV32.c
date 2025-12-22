/*
sc:c/sc opt txt/DecodeIV32.c
*/

#include "Decode.h"
#include "YUV.h"
#include "GlobalVars.h"
#include "Utils.h"

#define xaULONG ulong
#define max(a,b) (((a)>(b)) ? (a) : (b))
#define min(a,b) (((a)>(b)) ? (b) : (a))

/* /// "structs" */
typedef struct
{
  xaULONG cmd;                  /* decode or query */
  xaULONG skip_flag;            /* skip_flag */
  xaULONG imagex,imagey;        /* Image Buffer Size */
  xaULONG imaged;               /* Image depth */
  xaULONG *chdr;                /* Color Map Header */
  xaULONG map_flag;             /* remap image? */
  xaULONG *map;                 /* map to use */
  xaULONG xs,ys;                /* pos of changed area */
  xaULONG xe,ye;                /* size of change area */
  xaULONG special;              /* Special Info */
  void *extra;                  /* Decompression specific info */
} XA_DEC_INFO;

struct IV32Data {
  uchar gray;
  uchar dither;
  struct YUVTable *yuvTab;
  uchar *rngLimit;
  struct RGBTriple *cmap;
  ulong *x;
};

struct xayuvt {
  ulong bla;
  long *y;
  long *ub, *vr, *ug, *vg;
};

struct xayuvb {
  uchar *y, *u, *v, *buf;
  ulong size;
  ushort yw,yh,uvw,uvh;
};
/* \\\ */

extern __asm void IV32Entry(REG(a0) uchar *from,
                            REG(a1) uchar *to,
                            REG(a2) XA_DEC_INFO *info,
                            REG(d0) xaULONG dsize);

struct IV32Data *iv32Data;

/* /// "SelectIV32Funcs()" */
__asm void SelectIV32Funcs(REG(a0) struct IV32Data *spec,
                           REG(d0) uchar reduce,
                           REG(d1) uchar dither)
{
/*
  if (reduce) {
    if (dither) yuv441111=YUV441111to332Dith;
    else yuv441111=YUV441111to332;
  } else {
    yuv441111=YUV441111toRGB;
  }
*/
  gray=spec->gray;
  rngLimit=spec->rngLimit;
  yuvTab=spec->yuvTab;
  cmap=spec->cmap;
  iv32Data=spec;
}
/* \\\ */

/* /// "DecodeIV32()" */
__asm void DecodeIV32(REG(a0) uchar *from,
                      REG(a1) uchar *to,
                      REG(d0) ulong width,
                      REG(d1) ulong height,
                      REG(d2) ulong encSize,
                      REG(a2) ulong spec)
{
  XA_DEC_INFO info;
  info.cmd=0;
  info.skip_flag=0;
  info.imagex=width;
  info.imagey=height;
  info.imaged=24;
  info.chdr=0;
  info.map_flag=0;
  info.map=0;
  info.special=1;

  IV32Entry(from,to,&info,encSize);
}
/* \\\ */

/* /// "BreakFuncs" */
void __stdargs BreakFunc1(ulong x1,ulong x2,ulong x3,ulong x4,ulong x5,ulong x6,ulong x7)
{
  iv32Data->x[0]=x1;
  iv32Data->x[1]=x2;
  iv32Data->x[2]=x3;
  iv32Data->x[3]=x4;
  iv32Data->x[4]=x5;
  iv32Data->x[5]=x6;
  iv32Data->x[6]=x7;
}
/* \\\ */

/* /// "color funcs" */
extern void __regargs YUV441111toRGB(uchar *image, ulong width, ulong height, ulong ix, ulong iy);
extern void __regargs YUV441111to332(uchar *image, ulong width, ulong height, ulong ix, ulong iy);
extern void __regargs YUV441111to332Dith(uchar *image, ulong width, ulong height, ulong ix, ulong iy);

void __stdargs XA_YUV1611_To_RGB(uchar *image, ulong imagex, ulong imagey, ulong i_x, ulong i_y, struct xayuvb *yuv_bufs, struct xayuvt *yuv_tabs, ulong map_flag, ulong *map, ulong *chdr)
{
  struct YUVBuffer yuv;
  yuv.yBuf=yuv_bufs->y;
  yuv.uBuf=yuv_bufs->u;
  yuv.vBuf=yuv_bufs->v;
  yuvBuf=&yuv;
  mycopymem((ulong *)yuv_tabs->y,(ulong *)(&yuvTab->yTab),1024);
  mycopymem((ulong *)yuv_tabs->ug,(ulong *)(&yuvTab->ugTab),1024);
  mycopymem((ulong *)yuv_tabs->ub,(ulong *)(&yuvTab->ubTab),1024);
  mycopymem((ulong *)yuv_tabs->vg,(ulong *)(&yuvTab->vgTab),1024);
  mycopymem((ulong *)yuv_tabs->vr,(ulong *)(&yuvTab->vrTab),1024);
  YUV441111toRGB(image,imagex,imagey,imagex,imagey);
}

void __stdargs XA_YUV1611_To_332(uchar *image, ulong imagex, ulong imagey, ulong i_x, ulong i_y, ulong yuv_bufs, ulong yuv_tabs, ulong map_flag, ulong *map, ulong *chdr)
{
  yuvBuf=(struct YUVBuffer *)yuv_bufs;
  YUV441111to332(image,imagex,imagey,i_x,i_y);
}

void __stdargs XA_YUV1611_To_332_Dither(uchar *image, ulong imagex, ulong imagey, ulong i_x, ulong i_y, ulong yuv_bufs, ulong yuv_tabs, ulong map_flag, ulong *map, ulong *chdr)
{
  yuvBuf=(struct YUVBuffer *)yuv_bufs;
  YUV441111to332Dith(image,imagex,imagey,i_x,i_y);
}

void __stdargs XA_YUV1611_To_CF4(uchar *image, ulong imagex, ulong imagey, ulong i_x, ulong i_y, ulong yuv_bufs, ulong yuv_tabs, ulong map_flag, ulong *map, ulong *chdr)
{
  yuvBuf=(struct YUVBuffer *)yuv_bufs;
  YUV441111to332(image,imagex,imagey,i_x,i_y);
}

void __stdargs XA_YUV1611_To_CF4_Dither(uchar *image, ulong imagex, ulong imagey, ulong i_x, ulong i_y, ulong yuv_bufs, ulong yuv_tabs, ulong map_flag, ulong *map, ulong *chdr)
{
  yuvBuf=(struct YUVBuffer *)yuv_bufs;
  YUV441111to332Dith(image,imagex,imagey,i_x,i_y);
}

void __stdargs XA_YUV1611_To_CLR8(uchar *image, ulong imagex, ulong imagey, ulong i_x, ulong i_y, ulong yuv_bufs, ulong yuv_tabs, ulong map_flag, ulong *map, ulong *chdr)
{
  yuvBuf=(struct YUVBuffer *)yuv_bufs;
  YUV441111toRGB(image,imagex,imagey,i_x,i_y);
}

void __stdargs XA_YUV1611_To_CLR16(uchar *image, ulong imagex, ulong imagey, ulong i_x, ulong i_y, ulong yuv_bufs, ulong yuv_tabs, ulong map_flag, ulong *map, ulong *chdr)
{
  yuvBuf=(struct YUVBuffer *)yuv_bufs;
  YUV441111toRGB(image,imagex,imagey,i_x,i_y);
}

void __stdargs XA_YUV1611_To_CLR32(uchar *image, ulong imagex, ulong imagey, ulong i_x, ulong i_y, ulong yuv_bufs, ulong yuv_tabs, ulong map_flag, ulong *map, ulong *chdr)
{
  yuvBuf=(struct YUVBuffer *)yuv_bufs;
  YUV441111toRGB(image,imagex,imagey,i_x,i_y);
}
/* \\\ */

extern struct xayuvb indeo_bufs, L00012A;

extern void __stdargs IR32_Decode_Plane(uchar *buf1,
                                        uchar *buf2,
                                        ulong pWidth,
                                        ulong pHeight,
                                        uchar *f,
                                        ulong flag,
                                        uchar *tempfrom,
                                        uchar *planePtr,
                                        ulong ppWidth);

void DecodeIV32Plane(uchar *buf1,
                     uchar *buf2,
                     ulong pWidth,
                     ulong pHeight,
                     uchar *f,
                     ulong flag,
                     uchar *tempfrom,
                     uchar *planePtr,
                     ulong ppWidth)
{
}

/* /// "DecodeIV32_2()" */
__asm void DecodeIV32_2(REG(a0) uchar *from,
                      REG(a1) uchar *to,
                      REG(d0) ulong width,
                      REG(d1) ulong height,
                      REG(d2) ulong encSize,
                      REG(a2) ulong spec)
{
  ulong x1, x2;
  ulong yPlaneWidth, yPlaneHeight;
  ulong uvPlaneWidth, uvPlaneHeight;
  long yPlaneOffset, uPlaneOffset, vPlaneOffset;
  ulong flag;
  uchar *dptr=from, *tempfrom, *yPtr, *uPtr, *vPtr;
  struct xayuvb *buf1, *buf2;

  dptr+=0x12;
  x1=get16pc(dptr);
  x2=get32pc(dptr);
  flag=*dptr;
  dptr+=4;
  yPlaneHeight=get16pc(dptr);
  yPlaneWidth=get16pc(dptr);
  uvPlaneHeight=(yPlaneHeight/4+3) & 0x7ffc;
  uvPlaneWidth=(yPlaneWidth/4+3) & 0x7ffc;
  yPlaneOffset=get32pc(dptr);
  vPlaneOffset=get32pc(dptr);
  uPlaneOffset=get32pc(dptr);
  tempfrom=dptr+4;
  if (x2 != 0x80) {
    // if (x1 & 0x0100) return; // oder x1 & 0x0100 ??
    // Abfrage Skipflag

    if (x1 & 0x0200) {
      buf1=&L00012A;
      buf2=&indeo_bufs;
    } else {
      buf1=&indeo_bufs;
      buf2=&L00012A;
    }

    dptr=from+yPlaneOffset+0x10;
    yPlaneOffset=get32pc(dptr);
    yPtr=dptr+(yPlaneOffset<<1);
    DecodeIV32Plane(buf1->y,buf2->y,yPlaneWidth,yPlaneHeight,yPtr,flag,tempfrom,dptr,min(0xa0,yPlaneWidth));

    dptr=from+vPlaneOffset+0x10;
    vPlaneOffset=get32pc(dptr);
    vPtr=dptr+(vPlaneOffset<<1);
    DecodeIV32Plane(buf1->v,buf2->v,uvPlaneWidth,uvPlaneHeight,vPtr,flag,tempfrom,dptr,min(0x28,uvPlaneWidth));

    dptr=from+uPlaneOffset+0x10;
    uPlaneOffset=get32pc(dptr);
    uPtr=dptr+(uPlaneOffset<<1);
    DecodeIV32Plane(buf1->u,buf2->u,uvPlaneWidth,uvPlaneHeight,uPtr,flag,tempfrom,dptr,min(0x28,uvPlaneWidth));

    // XA_YUV1611_To_RGB(to,width,height,yPlaneWidth,yPlaneHeight,buf1,0,0,0,0);
    // YUV441111toRGB(to,width,height,yPlaneWidth,yPlaneHeight);
  }
}
/* \\\ */

