/*
sc:c/sc opt txt/DecodeJPEG.c
*/

#include "Decode.h"
#include "YUV.h"
#include "Utils.h"
#include "GlobalVars.h"
#include "JPEG.h"

/* /// "define's und Variablen" */
ulong bytes_pixel;
extern long xa_dither_flag;

uchar  *jpg_buff = 0;
long  jpg_bsize = 0;

long   jpg_h_bnum;
ulong  jpg_h_bbuf;

long   *jpg_quant_tables[JJ_NUM_QUANT_TBLS];
ulong  jpg_marker = 0;
ulong  jpg_saw_SOI,jpg_saw_SOF,jpg_saw_SOS;
ulong  jpg_saw_DHT,jpg_saw_DQT,jpg_saw_EOI;
ulong  jpg_std_DHT_flag = 0;
long   jpg_dprec,jpg_height,jpg_width;
long   jpg_num_comps,jpg_comps_in_scan;
long   jpg_nxt_rst_num;
long   jpg_rst_interval;

ulong xa_mjpg_kludge;

JJ_HUFF_TBL jpg_ac_huff[JJ_NUM_HUFF_TBLS];
JJ_HUFF_TBL jpg_dc_huff[JJ_NUM_HUFF_TBLS];

COMPONENT_HDR jpg_comps[JPG_MAX_COMPS + 1];

long JJ_ZAG[DCTSIZE2+16] = {
  0,  1,  8, 16,  9,  2,  3, 10,
 17, 24, 32, 25, 18, 11,  4,  5,
 12, 19, 26, 33, 40, 48, 41, 34,
 27, 20, 13,  6,  7, 14, 21, 28,
 35, 42, 49, 56, 57, 50, 43, 36,
 29, 22, 15, 23, 30, 37, 44, 51,
 58, 59, 52, 45, 38, 31, 39, 46,
 53, 60, 61, 54, 47, 55, 62, 63,
  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0
};

ulong jpg_MCUbuf_size = 0;
uchar *jpg_Ybuf = 0;
uchar *jpg_Ubuf = 0;
uchar *jpg_Vbuf = 0;
short jpg_dct_buf[DCTSIZE2];
/* \\\ */

struct JPEGData {
  long *quantTab[JJ_NUM_QUANT_TBLS];
};

struct JPEGData *JPGData;

/* /// "proto-types" */
ulong jpg_decode_111111(uchar *image, ulong width, ulong height, ulong interleave, ulong row_offset, ulong imagex, ulong imagey, ulong gray);
ulong jpg_decode_211111(uchar *image, ulong width, ulong height, ulong interleave, ulong row_offset, ulong imagex, ulong imagey);
ulong jpg_decode_221111(uchar *image, ulong width, ulong height, ulong interleave, ulong row_offset, ulong imagex, ulong imagey);
ulong jpg_decode_411111(uchar *image, ulong width, ulong height, ulong interleave, ulong row_offset, ulong imagex, ulong imagey);
void __regargs (*mcu111111) (uchar *to, ulong width, ulong height, ulong rowSize, ulong ipSize);
void __regargs (*mcu211111) (uchar *to, ulong width, ulong height, ulong rowSize, ulong ipSize);
void __regargs (*mcu221111) (uchar *to, ulong width, ulong height, ulong rowSize, ulong ipSize);
void __regargs (*mcu411111) (uchar *to, ulong width, ulong height, ulong rowSize, ulong ipSize);
void jpg_huff_build(JJ_HUFF_TBL *htbl, uchar *hbits, uchar *hvals);
ulong jpg_huffparse(register COMPONENT_HDR *comp, register short *dct_buf, ulong *qtab, uchar *OBuf);
void j_rev_dct (short *data, uchar *outptr, uchar *rnglimit);
void JPG_Setup_Samp_Limit_Table();
void JPG_Free_Samp_Limit_Table();
ulong jpg_std_DHT(void);
ulong jpg_search_marker(ulong marker, uchar **data_ptr, long *data_size);
ulong jpg_read_SOI(void);
ulong jpg_read_SOF(void);
ulong jpg_read_SOS(void);
ulong jpg_read_DQT(void);
ulong jpg_read_DRI(void);
ulong jpg_read_DHT(void);
ulong jpg_skip_marker(void);
ulong jpg_get_marker(void);
ulong jpg_read_markers(void);
ulong jpg_read_EOI_marker(void);
ulong jpg_read_RST_marker(void);
void jpg_init_input(uchar *buff, long buff_size);
void jpg_huff_reset(void);
/* \\\ */

/* /// "mcu1hInnerTail" */
#define mcu1hInnerTail(inc1) { \
  skip++;                      \
  if (skip>=8) {               \
    skip=0;                    \
    yp+=inc1;                  \
    up+=inc1;                  \
    vp+=inc1;                  \
  }                            \
}
/* \\\ */

/* /// "mcu2hInnerTail" */
#define mcu2hInnerTail(inc1,inc2) { \
  skip++;                           \
  if (skip==4)                      \
    yp+=inc1;                       \
  else                              \
    if (skip>=8) {                  \
      skip=0;                       \
      yp+=inc2;                     \
      up+=inc1;                     \
      vp+=inc1;                     \
    }                               \
}
/* \\\ */

/* /// "mcu4hInnerTail" */
#define mcu4hInnerTail(inc1,inc2) { \
  skip++;                           \
  if (skip>=8) {                    \
    skip=0;                         \
    yp+=inc2;                       \
    up+=inc1;                       \
    vp+=inc1;                       \
  } else                            \
    if (!(skip & 1)) yp+=inc1;      \
}
/* \\\ */

/* /// "MCU111111toRGB()" */
void __regargs MCU111111toRGB(uchar *to,
                              ulong width,
                              ulong height,
                              ulong rowSize,
                              ulong ipSize)
{
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  ipSize>>=2;
  while (height>0) {
    RGBTriple *iptr=(RGBTriple *)to;
    uchar *yptr=yBuf;
    uchar *uptr=uBuf;
    uchar *vptr=vBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      RGBTriple *ip=iptr;
      uchar *yp=yptr;
      uchar *up=uptr;
      uchar *vp=vptr;
      if (height<=0) return;
      xi=width;
      skip=0;
      while (xi--) {
        ulong u0=*up++;
        ulong v0=*vp++;
        long cr=vrTab[v0];
        long cg=vgTab[v0]+ugTab[u0];
        long cb=ubTab[u0];
        iDecYUVRGB(ip[0],*yp++,cr,cg,cb);
        mcu1hInnerTail(56);
        ip++;
      }
      yptr+=8;
      uptr+=8;
      vptr+=8;
      height--;
      iptr+=ipSize;
    }
    yBuf+=rowSize;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "MCU111111to332()" */
void __regargs MCU111111to332(uchar *to,
                              ulong width,
                              ulong height,
                              ulong rowSize,
                              ulong ipSize)
{
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  while (height>0) {
    uchar *iptr=(uchar *)to;
    uchar *yptr=yBuf;
    uchar *uptr=uBuf;
    uchar *vptr=vBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      uchar *ip=iptr;
      uchar *yp=yptr;
      uchar *up=uptr;
      uchar *vp=vptr;
      if (height<=0) return;
      xi=width;
      skip=0;
      while (xi--) {
        if (gray) {
          *ip++=*yp++;
        } else {
          ulong u0=*up++;
          ulong v0=*vp++;
          long cr=vrTab[v0];
          long cg=vgTab[v0]+ugTab[u0];
          long cb=ubTab[u0];
          DecYUV332(ip,*yp++,cr,cg,cb);
        }
        mcu1hInnerTail(56);
      }
      yptr+=8;
      uptr+=8;
      vptr+=8;
      height--;
      iptr+=ipSize;
    }
    yBuf+=rowSize;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "MCU111111to332Dith()" */
void __regargs MCU111111to332Dith(uchar *to,
                                  ulong width,
                                  ulong height,
                                  ulong rowSize,
                                  ulong ipSize)
{
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  while (height>0) {
    uchar *iptr=(uchar *)to;
    uchar *yptr=yBuf;
    uchar *uptr=uBuf;
    uchar *vptr=vBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      uchar *ip=iptr;
      uchar *yp=yptr;
      uchar *up=uptr;
      uchar *vp=vptr;
      long re=0, ge=0, be=0;
      if (height<=0) return;
      xi=width;
      skip=0;
      while (xi--) {
        ulong u0=*up++;
        ulong v0=*vp++;
        long cr=vrTab[v0];
        long cg=vgTab[v0]+ugTab[u0];
        long cb=ubTab[u0];
        DecYUV332Dith(*ip++,*yp++,cr,cg,cb);
        mcu1hInnerTail(56);
      }
      yptr+=8;
      uptr+=8;
      vptr+=8;
      height--;
      iptr+=ipSize;
    }
    yBuf+=rowSize;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "MCU111111toGray()" */
void __regargs MCU111111toGray(uchar *to,
                               ulong width,
                               ulong height,
                               ulong rowSize,
                               ulong ipSize)
{
  uchar *yBuf=yuvBuf->yBuf;

  while (height>0) {
    uchar *iptr=(uchar *)to;
    uchar *yptr=yBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      uchar *ip=iptr;
      uchar *yp=yptr;
      if (height<=0) return;
      xi=width;
      skip=0;
      while (xi--) {
        *ip++=*yp++;
        skip++;
        if (skip>=8) {skip=0; yp+=56; }
      }
      yptr+=8;
      height--;
      iptr+=ipSize;
    }
    yBuf+=rowSize;
  }
}
/* \\\ */

/* /// "MCU211111toRGB()" */
void __regargs MCU211111toRGB(uchar *to,
                              ulong width,
                              ulong height,
                              ulong rowSize,
                              ulong ipSize)
{
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  ipSize>>=2;
  while (height>0) {
    RGBTriple *iptr=(RGBTriple *)to;
    uchar *yptr=yBuf;
    uchar *uptr=uBuf;
    uchar *vptr=vBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      RGBTriple *ip=iptr;
      uchar *yp=yptr;
      uchar *up=uptr;
      uchar *vp=vptr;
      if (height<=0) return;
      xi=width;
      skip=0;
      while (xi--) {
        ulong u0=*up++;
        ulong v0=*vp++;
        long cr=vrTab[v0];
        long cg=vgTab[v0]+ugTab[u0];
        long cb=ubTab[u0];
        iDecYUVRGB(ip[0],*yp++,cr,cg,cb);
        iDecYUVRGB(ip[1],*yp++,cr,cg,cb);
        mcu2hInnerTail(56,56);
        ip+=2;
      }
      yptr+=8;
      uptr+=8;
      vptr+=8;
      height--;
      iptr+=ipSize;
    }
    yBuf+=rowSize<<1;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "MCU211111to332()" */
void __regargs MCU211111to332(uchar *to,
                              ulong width,
                              ulong height,
                              ulong rowSize,
                              ulong ipSize)
{
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  while (height>0) {
    uchar *iptr=(uchar *)to;
    uchar *yptr=yBuf;
    uchar *uptr=uBuf;
    uchar *vptr=vBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      uchar *ip=iptr;
      uchar *yp=yptr;
      uchar *up=uptr;
      uchar *vp=vptr;
      if (height<=0) return;
      xi=width;
      skip=0;
      while (xi--) {
        if (gray) {
          ip[0]=yp[0];
          ip[1]=yp[1];
          ip+=2;
          yp+=2;
        } else {
          ulong u0=*up++;
          ulong v0=*vp++;
          long cr=vrTab[v0];
          long cg=vgTab[v0]+ugTab[u0];
          long cb=ubTab[u0];
          DecYUV332(ip,*yp++,cr,cg,cb);
          DecYUV332(ip,*yp++,cr,cg,cb);
        }
        mcu2hInnerTail(56,56);
      }
      yptr+=8;
      uptr+=8;
      vptr+=8;
      height--;
      iptr+=ipSize;
    }
    yBuf+=rowSize<<1;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "MCU211111to332Dith()" */
void __regargs MCU211111to332Dith(uchar *to,
                                  ulong width,
                                  ulong height,
                                  ulong rowSize,
                                  ulong ipSize)
{
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  while (height>0) {
    uchar *iptr=(uchar *)to;
    uchar *yptr=yBuf;
    uchar *uptr=uBuf;
    uchar *vptr=vBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      uchar *ip=iptr;
      uchar *yp=yptr;
      uchar *up=uptr;
      uchar *vp=vptr;
      long re=0, ge=0, be=0;
      if (height<=0) return;
      xi=width;
      skip=0;
      while (xi--) {
        ulong u0=*up++;
        ulong v0=*vp++;
        long cr=vrTab[v0];
        long cg=vgTab[v0]+ugTab[u0];
        long cb=ubTab[u0];
        DecYUV332Dith(*ip++,*yp++,cr,cg,cb);
        DecYUV332Dith(*ip++,*yp++,cr,cg,cb);
        mcu2hInnerTail(56,56);
      }
      yptr+=8;
      uptr+=8;
      vptr+=8;
      height--;
      iptr+=ipSize;
    }
    yBuf+=rowSize<<1;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "MCU221111toRGB()" */
void __regargs MCU221111toRGB(uchar *to,
                              ulong width,
                              ulong height,
                              ulong rowSize,
                              ulong ipSize)
{
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  ipSize>>=2;
  while (height>0) {
    RGBTriple *iptr=(RGBTriple *)to;
    uchar *yptr=yBuf;
    uchar *uptr=uBuf;
    uchar *vptr=vBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      RGBTriple *ip0, *ip1;
      uchar *yp, *up, *vp;
      if (height<=0) return;
      if (yi==4) yptr+=64;
      yp=yptr; up=uptr; vp=vptr;
      ip0=iptr;
      iptr+=ipSize;
      ip1=iptr;
      iptr+=ipSize;
      xi=width;
      skip=0;
      while (xi--) {
        ulong u0=*up++;
        ulong v0=*vp++;
        long cr=vrTab[v0];
        long cg=vgTab[v0]+ugTab[u0];
        long cb=ubTab[u0];
        iDecYUVRGB(ip1[0],yp[8],cr,cg,cb);
        iDecYUVRGB(ip0[0],*yp++,cr,cg,cb);
        iDecYUVRGB(ip1[1],yp[8],cr,cg,cb);
        iDecYUVRGB(ip0[1],*yp++,cr,cg,cb);
        mcu2hInnerTail(56,184);
        ip0+=2;
        ip1+=2;
      }
      yptr+=16;
      uptr+=8;
      vptr+=8;
      height-=2;
    }
    yBuf+=rowSize<<2;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "MCU221111to332()" */
void __regargs MCU221111to332(uchar *to,
                              ulong width,
                              ulong height,
                              ulong rowSize,
                              ulong ipSize)
{
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  while (height>0) {
    uchar *iptr=(uchar *)to;
    uchar *yptr=yBuf;
    uchar *uptr=uBuf;
    uchar *vptr=vBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      uchar *ip0, *ip1;
      uchar *yp, *up, *vp;
      if (height<=0) return;
      if (yi==4) yptr+=64;
      yp=yptr; up=uptr; vp=vptr;
      ip0=iptr;
      iptr+=ipSize;
      ip1=iptr;
      iptr+=ipSize;
      xi=width;
      skip=0;
      while (xi--) {
        if (gray) {
          *ip1++=yp[8];
          *ip0++=*yp++;
          *ip1++=yp[8];
          *ip0++=*yp++;
        } else {
          ulong u0=*up++;
          ulong v0=*vp++;
          long cr=vrTab[v0];
          long cg=vgTab[v0]+ugTab[u0];
          long cb=ubTab[u0];
          DecYUV332(ip1,yp[8],cr,cg,cb);
          DecYUV332(ip0,*yp++,cr,cg,cb);
          DecYUV332(ip1,yp[8],cr,cg,cb);
          DecYUV332(ip0,*yp++,cr,cg,cb);
        }
        mcu2hInnerTail(56,184);
      }
      yptr+=16;
      uptr+=8;
      vptr+=8;
      height-=2;
    }
    yBuf+=rowSize<<2;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "MCU221111to332Dith()" */
void __regargs MCU221111to332Dith(uchar *to,
                                  ulong width,
                                  ulong height,
                                  ulong rowSize,
                                  ulong ipSize)
{
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  while (height>0) {
    uchar *iptr=(uchar *)to;
    uchar *yptr=yBuf;
    uchar *uptr=uBuf;
    uchar *vptr=vBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      uchar *ip0, *ip1;
      uchar *yp, *up, *vp;
      long re=0, ge=0, be=0;
      if (height<=0) return;
      if (yi==4) yptr+=64;
      yp=yptr; up=uptr; vp=vptr;
      ip0=iptr;
      iptr+=ipSize;
      ip1=iptr;
      iptr+=ipSize;
      xi=width;
      skip=0;
      while (xi--) {
        ulong u0=*up++;
        ulong v0=*vp++;
        long cr=vrTab[v0];
        long cg=vgTab[v0]+ugTab[u0];
        long cb=ubTab[u0];
        DecYUV332Dith(*ip1++,yp[8],cr,cg,cb);
        DecYUV332Dith(*ip0++,*yp++,cr,cg,cb);
        DecYUV332Dith(*ip1++,yp[8],cr,cg,cb);
        DecYUV332Dith(*ip0++,*yp++,cr,cg,cb);
        mcu2hInnerTail(56,184);
      }
      yptr+=16;
      uptr+=8;
      vptr+=8;
      height-=2;
    }
    yBuf+=rowSize<<2;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "MCU411111toRGB()" */
void __regargs MCU411111toRGB(uchar *to,
                              ulong width,
                              ulong height,
                              ulong rowSize,
                              ulong ipSize)
{
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  ipSize>>=2;
  while (height>0) {
    RGBTriple *iptr=(RGBTriple *)to;
    uchar *yptr=yBuf;
    uchar *uptr=uBuf;
    uchar *vptr=vBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      RGBTriple *ip=iptr;
      uchar *yp=yptr;
      uchar *up=uptr;
      uchar *vp=vptr;
      if (height<=0) return;
      xi=width;
      skip=0;
      while (xi--) {
        ulong u0=*up++;
        ulong v0=*vp++;
        long cr=vrTab[v0];
        long cg=vgTab[v0]+ugTab[u0];
        long cb=ubTab[u0];
        iDecYUVRGB(ip[0],*yp++,cr,cg,cb);
        iDecYUVRGB(ip[1],*yp++,cr,cg,cb);
        iDecYUVRGB(ip[2],*yp++,cr,cg,cb);
        iDecYUVRGB(ip[3],*yp++,cr,cg,cb);
        mcu4hInnerTail(56,56);
        ip+=4;
      }
      yptr+=8;
      uptr+=8;
      vptr+=8;
      height--;
      iptr+=ipSize;
    }
    yBuf+=rowSize<<2;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "MCU411111to332()" */
void __regargs MCU411111to332(uchar *to,
                              ulong width,
                              ulong height,
                              ulong rowSize,
                              ulong ipSize)
{
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  while (height>0) {
    uchar *iptr=(uchar *)to;
    uchar *yptr=yBuf;
    uchar *uptr=uBuf;
    uchar *vptr=vBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      uchar *ip=iptr;
      uchar *yp=yptr;
      uchar *up=uptr;
      uchar *vp=vptr;
      if (height<=0) return;
      xi=width;
      skip=0;
      while (xi--) {
        if (gray) {
          ip[0]=yp[0];
          ip[1]=yp[1];
          ip[2]=yp[2];
          ip[3]=yp[3];
          ip+=4;
          yp+=4;
        } else {
          ulong u0=*up++;
          ulong v0=*vp++;
          long cr=vrTab[v0];
          long cg=vgTab[v0]+ugTab[u0];
          long cb=ubTab[u0];
          DecYUV332(ip,*yp++,cr,cg,cb);
          DecYUV332(ip,*yp++,cr,cg,cb);
          DecYUV332(ip,*yp++,cr,cg,cb);
          DecYUV332(ip,*yp++,cr,cg,cb);
        }
        mcu4hInnerTail(56,56);
      }
      yptr+=8;
      uptr+=8;
      vptr+=8;
      height--;
      iptr+=ipSize;
    }
    yBuf+=rowSize<<2;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "MCU411111to332Dith()" */
void __regargs MCU411111to332Dith(uchar *to,
                                  ulong width,
                                  ulong height,
                                  ulong rowSize,
                                  ulong ipSize)
{
  long *ubTab=yuvTab->ubTab;
  long *vrTab=yuvTab->vrTab;
  long *ugTab=yuvTab->ugTab;
  long *vgTab=yuvTab->vgTab;
  long *yTab=yuvTab->yTab;
  uchar *yBuf=yuvBuf->yBuf;
  uchar *uBuf=yuvBuf->uBuf;
  uchar *vBuf=yuvBuf->vBuf;

  while (height>0) {
    uchar *iptr=(uchar *)to;
    uchar *yptr=yBuf;
    uchar *uptr=uBuf;
    uchar *vptr=vBuf;
    ulong xi, yi, skip;
    for (yi=0; yi<8; yi++) {
      uchar *ip=iptr;
      uchar *yp=yptr;
      uchar *up=uptr;
      uchar *vp=vptr;
      long re=0, ge=0, be=0;
      if (height<=0) return;
      xi=width;
      skip=0;
      while (xi--) {
        ulong u0=*up++;
        ulong v0=*vp++;
        long cr=vrTab[v0];
        long cg=vgTab[v0]+ugTab[u0];
        long cb=ubTab[u0];
        DecYUV332Dith(*ip++,*yp++,cr,cg,cb);
        DecYUV332Dith(*ip++,*yp++,cr,cg,cb);
        DecYUV332Dith(*ip++,*yp++,cr,cg,cb);
        DecYUV332Dith(*ip++,*yp++,cr,cg,cb);
        mcu4hInnerTail(56,56);
      }
      yptr+=8;
      uptr+=8;
      vptr+=8;
      height--;
      iptr+=ipSize;
    }
    yBuf+=rowSize<<2;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "jpg_read_SOI()" */
ulong jpg_read_SOI()
{
  // DEBUG_LEVEL1 kprintf("SOI: \n");
  jpg_rst_interval = 0;
  return(xaTRUE);
}
/* \\\ */

/* /// "jpg_read_SOF()" */
ulong jpg_read_SOF()
{
  long len,ci;
  COMPONENT_HDR *comp;
  
  JJ_INPUT_xaSHORT(len);
  if (xa_mjpg_kludge) len -= 6;
  else len -= 8;

  JJ_INPUT_xaBYTE(jpg_dprec);
  JJ_INPUT_xaSHORT(jpg_height);
  JJ_INPUT_xaSHORT(jpg_width);
  JJ_INPUT_xaBYTE(jpg_num_comps);

  // DEBUG_LEVEL1 kprintf("SOF: dprec %x res %d x %d comps %x\n",jpg_dprec,jpg_width,jpg_height,jpg_num_comps);

  for(ci = 0; ci < jpg_num_comps; ci++)
  { ulong c;
    if (ci > JPG_MAX_COMPS)     comp = &jpg_comps[JPG_DUMMY_COMP];
    else                        comp = &jpg_comps[ci];
    JJ_INPUT_xaBYTE(comp->id);
    JJ_INPUT_xaBYTE(c);
    comp->hvsample = c;
    JJ_INPUT_xaBYTE(comp->qtbl_num);
    // DEBUG_LEVEL1 kprintf("   id %x hvsamp %x qtbl %x\n",comp->id,c,comp->qtbl_num);
  }
  return (ulong)(JJ_INPUT_CHECK(0));
}
/* \\\ */

/* /// "jpg_read_SOS()" */
ulong jpg_read_SOS()
{ long len,i;
  long jpg_Ss, jpg_Se, jpg_AhAl;

  JJ_INPUT_xaSHORT(len);
  /* if (xa_mjpg_kludge) len += 2; length ignored */

  JJ_INPUT_xaBYTE(jpg_comps_in_scan);

  for (i = 0; i < jpg_comps_in_scan; i++)
  { long j,comp_id,htbl_num;
    COMPONENT_HDR *comp = 0;

    JJ_INPUT_xaBYTE(comp_id);
    j = 0;
    while(j < jpg_num_comps)
    { comp = &jpg_comps[j];
      if (comp->id == comp_id) break;
      j++;
    }
    if (j > jpg_num_comps) {
      // kprintf("JJ: bad id %x",comp_id);
      return(xaFALSE);
    }

    JJ_INPUT_xaBYTE(htbl_num);
    comp->dc_htbl_num = (htbl_num >> 4) & 0x0f;
    comp->ac_htbl_num = (htbl_num     ) & 0x0f;
    // DEBUG_LEVEL1 kprintf("     id %x dc/ac %x\n",comp_id,htbl_num);
  }
  JJ_INPUT_xaBYTE(jpg_Ss);
  JJ_INPUT_xaBYTE(jpg_Se);
  JJ_INPUT_xaBYTE(jpg_AhAl);
  return (ulong)(JJ_INPUT_CHECK(0));
}
/* \\\ */

/* /// "jpg_read_DQT()" */
ulong jpg_read_DQT()
{ long len;
  JJ_INPUT_xaSHORT(len);
  if ( !xa_mjpg_kludge ) len -= 2;

  // DEBUG_LEVEL1 kprintf("DQT:\n");

  while(len > 0)
  { long i,tbl_num,prec;
    long *quant_table;

    JJ_INPUT_xaBYTE(tbl_num);  len -= 1;
    // DEBUG_LEVEL1 kprintf("     prec/tnum %02x\n",tbl_num);

    prec = (tbl_num >> 4) & 0x0f;
    prec = (prec)?(2 * DCTSIZE2):(DCTSIZE2);  /* 128 or 64 */
    tbl_num &= 0x0f;
    if (tbl_num > 4) {
      // kprintf("JJ: bad DQT tnum %x\n",tbl_num);
      return(xaFALSE);
    }

/*
    if (jpg_quant_tables[tbl_num] == 0)
    {
      jpg_quant_tables[tbl_num] = (long *)malloc(64 * sizeof(long));
      if (jpg_quant_tables[tbl_num] == 0)
        { kprintf("JJ: DQT alloc err %x \n",tbl_num); return(xaFALSE); }
    }
*/
    len -= prec;
    if (JJ_INPUT_CHECK(prec)==xaFALSE) return(xaFALSE);
    quant_table = jpg_quant_tables[tbl_num];
    if (prec==128)
    { ulong tmp;
      for (i = 0; i < DCTSIZE2; i++)
        { JJ_INPUT_xaSHORT(tmp); quant_table[ JJ_ZAG[i] ] = (long) tmp; }
    }
    else
    { ulong tmp;
      for (i = 0; i < DCTSIZE2; i++)
        { JJ_INPUT_xaBYTE(tmp); quant_table[ JJ_ZAG[i] ] = (long) tmp; }
    }
  }
  return(xaTRUE);
}
/* \\\ */

/* /// "jpg_read_DRI()" */
ulong jpg_read_DRI()
{ long len;
  JJ_INPUT_xaSHORT(len);
  JJ_INPUT_xaSHORT(jpg_rst_interval);
  // DEBUG_LEVEL1 kprintf("DRI: int %x\n",jpg_rst_interval);
  return(xaTRUE);
}
/* \\\ */

/* /// "jpg_skip_marker()" */
ulong jpg_skip_marker()
{ long len,tmp;
  JJ_INPUT_xaSHORT(len); 
  // DEBUG_LEVEL1 kprintf("SKIP: marker %x len %x\n",jpg_marker,len);
  len -= 2; if (JJ_INPUT_CHECK(len)==xaFALSE) return(xaFALSE);
  while(len--) JJ_INPUT_xaBYTE(tmp); /* POD improve this */
  return(xaTRUE);
}
/* \\\ */

/* /// "jpg_read_DHT()" */
ulong jpg_read_DHT()
{
  long len;
  JJ_HUFF_TBL *htable;
  uchar  *hbits;
  uchar  *hvals;

  jpg_std_DHT_flag = 0;
  JJ_INPUT_xaSHORT(len);
  if (xa_mjpg_kludge) len += 2;
  len -= 2;
  if (JJ_INPUT_CHECK(len)==xaFALSE) return(xaFALSE);

  while(len > 0)
  { long i,index,count;
    JJ_INPUT_xaBYTE(index);
    /* POD index check */
    if (index & 0x10)                           /* AC Table */
    {
      index &= 0x0f;
      htable = &(jpg_ac_huff[index]);
      hbits  = jpg_ac_huff[index].bits;
      hvals  = jpg_ac_huff[index].vals;
    }
    else                                        /* DC Table */
    {
      htable = &(jpg_dc_huff[index]);
      hbits  = jpg_dc_huff[index].bits;
      hvals  = jpg_dc_huff[index].vals;
    }
    hbits[0] = 0;               count = 0;
    for (i = 1; i <= 16; i++)
    {
      JJ_INPUT_xaBYTE(hbits[i]);
      count += hbits[i];
    }
    len -= 17;
    if (count > 256) {
      // kprintf("JJ: DHT bad count %d\n",count);
      return(xaFALSE);
    }

    for (i = 0; i < count; i++) JJ_INPUT_xaBYTE(hvals[i]);
    len -= count;

    jpg_huff_build(htable,hbits,hvals);

  } /* end of len */
  return(xaTRUE);
}
/* \\\ */

/* /// "jpg_get_marker()" */
ulong jpg_get_marker()
{
  long c;

  for(;;)
  {
    JJ_INPUT_xaBYTE(c);
    while(c != 0xFF)    /* look for FF */
    {
      if (JJ_INPUT_CHECK(1)==xaFALSE) return(xaFALSE);
      JJ_INPUT_xaBYTE(c);
    }
    /* now we've got 1 0xFF, keep reading until next 0xFF */
    do
    {
      if (JJ_INPUT_CHECK(1)==xaFALSE) return(xaFALSE);
      JJ_INPUT_xaBYTE(c);
    } while (c == 0xFF);
    if (c != 0) break; /* ignore FF/00 sequences */
  }
  jpg_marker = c;
  return(xaTRUE);
}
/* \\\ */

/* /// "jpg_read_markers()" */
ulong jpg_read_markers()
{
  for(;;)
  { 
    if (jpg_get_marker() == xaFALSE) return(xaFALSE);
    // DEBUG_LEVEL1 kprintf("JJ: marker %x\n",jpg_marker);
    switch(jpg_marker)
    {
      case M_SOI: 
        if (jpg_read_SOI()==xaFALSE) return(xaFALSE);
        jpg_saw_SOI = xaTRUE;
        break;
      case M_SOF0: 
      case M_SOF1: 
        if (jpg_read_SOF()==xaFALSE) return(xaFALSE);
        jpg_saw_SOF = xaTRUE;
        break;
      case M_SOS: 
        if (jpg_read_SOS()==xaFALSE) return(xaFALSE);
        jpg_saw_SOS = xaTRUE;
        jpg_nxt_rst_num = 0;
        return(xaTRUE);
        break;
      case M_DHT:
        if (jpg_read_DHT()==xaFALSE) return(xaFALSE);
        jpg_saw_DHT = xaTRUE;
        break;
      case M_DQT:
        if (jpg_read_DQT()==xaFALSE) return(xaFALSE);
        jpg_saw_DQT = xaTRUE;
        break;
      case M_DRI:
        if (jpg_read_DRI()==xaFALSE) return(xaFALSE);
        break;
      case M_EOI:
        // kprintf("JJ: reached EOI without data\n");
        return(xaFALSE);
        break;
     case M_RST0:                /* these are all parameterless */
     case M_RST1:
     case M_RST2:
     case M_RST3:
     case M_RST4:
     case M_RST5:
     case M_RST6:
     case M_RST7:
     case M_TEM:
        break;
      default:
        if (jpg_skip_marker()==xaFALSE) return(xaFALSE);
        // DEBUG_LEVEL1 kprintf("JJ: skipped marker %x\n",jpg_marker);
        break;
    } /* end of switch */
  } /* end of forever */
}
/* \\\ */

/* /// "jpg_huff_build()" */
void jpg_huff_build(JJ_HUFF_TBL *htbl, uchar *hbits, uchar *hvals)
{ ulong clen,num_syms,p,i,si,code,lookbits;
  ulong l,ctr;
  uchar huffsize[257];
  ulong huffcode[257];

  /*** generate code lengths for each symbol */
  num_syms = 0;
  for(clen = 1; clen <= 16; clen++)
  {
    for(i = 1; i <= (ulong)(hbits[clen]); i++)
                                huffsize[num_syms++] = (uchar)(clen);
  }
  huffsize[num_syms] = 0;

  /*** generate codes */
  code = 0;
  si = huffsize[0];
  p = 0;
  while (huffsize[p])
  {
    while ( ((ulong)huffsize[p]) == si)
    {
      huffcode[p++] = code;
      code++;
    }
    code <<= 1;
    si++;
  }

/* Init mincode/maxcode/valptr arrays */
  p = 0;
  for (l = 1; l <= 16; l++) 
  {
    if (htbl->bits[l]) 
    {
      htbl->valptr[l] = p; /* huffval[] index of 1st symbol of code length l */
      htbl->mincode[l] = huffcode[p]; /* minimum code of length l */
      p += (ulong)(htbl->bits[l]);
      htbl->maxcode[l] = huffcode[p-1]; /* maximum code of length l */
    } 
    else
    {
      htbl->valptr[l] = 0;  /* not needed */
      htbl->mincode[l] = 0; /* not needed */
      htbl->maxcode[l] = 0; /* WAS -1; */   /* -1 if no codes of this length */
    }
  }
  htbl->maxcode[17] = 0xFFFFFL; /* ensures huff_DECODE terminates */


/* Init huffman cache */
  // memset((char *)htbl->cache, 0, ((1<<HUFF_LOOKAHEAD) * sizeof(xaUSHORT)) );
  // for (p=0; p<(1<<HUFF_LOOKAHEAD); p++) htbl->cache[p]=0;
  mymemset((ulong *)htbl->cache, 0, ((1<<HUFF_LOOKAHEAD) * sizeof(ushort)) );

  p = 0;
  for (l = 1; l <= HUFF_LOOKAHEAD; l++) 
  {
    for (i = 1; i <= (ulong) htbl->bits[l]; i++, p++)
    { short the_code = (ushort)((l << 8) | htbl->vals[p]);

      /* l = current code's length, p = its index in huffcode[] & huffval[]. */
      /* Generate left-justified code followed by all possible bit sequences */

      lookbits = huffcode[p] << (HUFF_LOOKAHEAD-l);
      for (ctr = 1 << (HUFF_LOOKAHEAD-l); ctr > 0; ctr--) 
      {
        htbl->cache[lookbits] = the_code;
        lookbits++;
      }
    }
  }
}
/* \\\ */

/* /// "jpg_init_input()" */
void jpg_init_input(uchar *buff, long buff_size)
{
  jpg_buff = buff;
  jpg_bsize = buff_size;
}
/* \\\ */

/* /// "jpg_huff_reset()" */
void jpg_huff_reset()
{
  jpg_comps[0].dc = 0;
  jpg_comps[1].dc = 0;
  jpg_comps[2].dc = 0;
  jpg_h_bbuf = 0;  /* clear huffman bit buffer */
  jpg_h_bnum = 0;
}
/* \\\ */

/* /// "jpg_read_EOI_marker()" */
ulong jpg_read_EOI_marker()
{ 
  /* POD make sure previous code restores bit buffer to input stream */ 
  while( jpg_get_marker() == xaTRUE)
  {
    if (jpg_marker == M_EOI) {jpg_saw_EOI = xaTRUE; return(xaTRUE); }
  }
  return(xaFALSE);
}
/* \\\ */

/* /// "jpg_read_RST_marker()" */
ulong jpg_read_RST_marker()
{
  if ( (jpg_marker >= M_RST0) && (jpg_marker <= M_RST7) ) 
  {
    // DEBUG_LEVEL1 kprintf("JJ: RST marker %x found\n",jpg_marker);
    return(xaTRUE);
  }
  else
  {
    // kprintf("JJ: NON-restart marker found %x\n",jpg_marker);
    // kprintf("JJ: should resync-to-restart\n");
  }
  return(xaTRUE); /* POD NOTE just for now */
}
/* \\\ */

/* /// "define's" */
#define jpg_huff_EXTEND(val,sz) ((val) < (1<<((sz)-1)) ? (val) + (((-1)<<(sz)) + 1) : (val))

#define JJ_HBBUF_FILL8(hbbuf,hbnum) { \
  register ulong _tmp;                \
  hbbuf <<= 8;                        \
  if (jpg_marker)                     \
    return(xaFALSE);                  \
  else                                \
    JJ_INPUT_xaBYTE(_tmp);            \
  while(_tmp == 0xff) {               \
    register ulong _t1;               \
    JJ_INPUT_xaBYTE(_t1);             \
    if (_t1 == 0x00)                  \
      break;                          \
    else                              \
      if (_t1 == 0xff)                \
        continue;                     \
      else {                          \
        jpg_marker = _t1;             \
        _tmp = 0x00;                  \
        break;                        \
      }                               \
  }                                   \
  hbbuf |= _tmp;                      \
  hbnum += 8;                         \
}

#define JJ_HBBUF_FILL8_1(hbbuf,hbnum) { \
  register ulong __tmp;                 \
  hbbuf <<= 8;                          \
  hbnum += 8;                           \
  if (jpg_marker)                       \
    __tmp = 0x00;                       \
  else                                  \
    JJ_INPUT_xaBYTE(__tmp);             \
  while(__tmp == 0xff) {                \
    register ulong _t1;                 \
    JJ_INPUT_xaBYTE(_t1);               \
    if (_t1 == 0x00)                    \
      break;                            \
    else                                \
      if (_t1 == 0xff)                  \
        continue;                       \
      else {                            \
        jpg_marker = _t1;               \
        __tmp = 0x00;                   \
        break;                          \
      }                                 \
  }                                     \
  hbbuf |= __tmp;                       \
}

#define JJ_HUFF_DECODE(huff_hdr,htbl, hbnum, hbbuf, result) {           \
  register ulong _tmp, _hcode;                                          \
  while(hbnum < 16) JJ_HBBUF_FILL8_1(hbbuf,hbnum);                      \
  _tmp = (hbbuf >> (hbnum - 8)) & 0xff;                                 \
  _hcode = (htbl)[_tmp];                                                \
  if (_hcode) {                                                         \
    hbnum -= (_hcode >> 8);                                             \
    (result) = _hcode & 0xff;                                           \
  } else {                                                              \
    register ulong _hcode, _shift, _minbits = 9;                        \
    _tmp = (hbbuf >> (hbnum - 16)) & 0xffff; /* get 16 bits */          \
    _shift = 16 - _minbits;                                             \
    _hcode = _tmp >> _shift;                                            \
    while(_hcode > huff_hdr->maxcode[_minbits]) {                       \
      _minbits++;                                                       \
      _shift--;                                                         \
      _hcode = _tmp >> _shift;                                          \
    }                                                                   \
    if (_minbits > 16) {                                                \
      /* kprintf("JHDerr\n"); */                                        \
      return(xaFALSE);                                                  \
    } else {                                                            \
      hbnum -= _minbits;                                                \
      _hcode -= huff_hdr->mincode[_minbits];                            \
      result = huff_hdr->vals[ (huff_hdr->valptr[_minbits] + _hcode) ]; \
    }                                                                   \
  }                                                                     \
}

#define JJ_HUFF_MASK(s) ((1 << (s)) - 1)

#define JJ_GET_BITS(n, hbnum, hbbuf, result) {     \
  hbnum -= n;                                      \
  while(hbnum < 0) JJ_HBBUF_FILL8_1(hbbuf,hbnum);  \
  (result) = ((hbbuf >> hbnum) & JJ_HUFF_MASK(n)); \
}
/* \\\ */

/* /// "jpg_huffparse()" */
ulong jpg_huffparse(register COMPONENT_HDR *comp, register short *dct_buf, ulong *qtab, uchar *OBuf)
{ long i,dcval;
  ulong size;
  JJ_HUFF_TBL *huff_hdr = &(jpg_dc_huff[ comp->dc_htbl_num ]);
  ushort *huff_tbl = huff_hdr->cache;
  uchar *limit = rngLimit + (CENTERJSAMPLE); // + MAXJSAMPLE + 1);
  ulong c_cnt,pos = 0;

  JJ_HUFF_DECODE(huff_hdr,huff_tbl,jpg_h_bnum,jpg_h_bbuf,size);

  // DEBUG_LEVEL2 kprintf(" HUFF DECODE: size %d\n",size);

  if (size)
  { ulong bits;
    JJ_GET_BITS(size,jpg_h_bnum,jpg_h_bbuf,bits);
    dcval = jpg_huff_EXTEND(bits, size);
    comp->dc += dcval;
    // DEBUG_LEVEL2 kprintf("   dcval %d  -dc %d\n",dcval,comp->dc);
  }
  dcval = comp->dc;

  /* clear reset of dct buffer */
  // memset((char *)(dct_buf),0,(DCTSIZE2 * sizeof(short)));
  // for (i=0; i<DCTSIZE2; i++) dct_buf[i]=0;
  mymemset((ulong *)(dct_buf),0,(DCTSIZE2 * sizeof(short)));

  dcval *= (long)qtab[0];
  dct_buf[0] = (short)dcval;
  c_cnt = 0;

  huff_hdr = &(jpg_ac_huff[ comp->ac_htbl_num ]);
  huff_tbl = huff_hdr->cache;
  i = 1;
  while(i < 64)
  { long level;       ulong run,tmp;
    JJ_HUFF_DECODE(huff_hdr,huff_tbl,jpg_h_bnum,jpg_h_bbuf,tmp); 
    size =  tmp & 0x0f;
    run = (tmp >> 4) & 0x0f; /* leading zeroes */
    // DEBUG_LEVEL2 kprintf("     %d) tmp %x size %x run %x\n",i,tmp,size,run);
    if (size)
    { long coeff;
      i += run; /* skip zeroes */
      JJ_GET_BITS(size, jpg_h_bnum,jpg_h_bbuf,level);
      coeff = (long)jpg_huff_EXTEND(level, size);
      // DEBUG_LEVEL2 kprintf("                   size %d coeff %x\n",size,coeff);
      pos = JJ_ZAG[i];
      coeff *= (long)qtab[ pos ];
      if (coeff)
      { c_cnt++;
        dct_buf[ pos ] = (short)(coeff);
      }
      i++;
    }
    else
    {
      if (run != 15) break; /* EOB */
      i += 16;
    }
  }

  if (c_cnt) j_rev_dct(dct_buf, OBuf, limit);
  else
  { register uchar *op = OBuf;
    register int jj = 8;
    short v = *dct_buf;
    register uchar dc;
    v = (v < 0)?( (v-3)>>3 ):( (v+4)>>3 );
    dc = limit[ (int) (v & RANGE_MASK) ];
    while(jj--)
    { op[0] = op[1] = op[2] = op[3] = op[4] = op[5] = op[6] = op[7] = dc;
      op += 8;
    }
  }
  return(xaTRUE);
}
/* \\\ */

/* /// "jpg_std_DHT()" */
ulong jpg_std_DHT()
{
  long ttt,len;
  JJ_HUFF_TBL *htable;
  uchar  *hbits,*Sbits;
  uchar  *hvals,*Svals;

  static uchar dc_luminance_bits[17] =
    { /* 0-base */ 0, 0, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0 };
  static uchar dc_luminance_vals[] =
    { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 };

  static uchar dc_chrominance_bits[17] =
    { /* 0-base */ 0, 0, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0 };
  static uchar dc_chrominance_vals[] =
    { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 };

  static uchar ac_luminance_bits[17] =
    { /* 0-base */ 0, 0, 2, 1, 3, 3, 2, 4, 3, 5, 5, 4, 4, 0, 0, 1, 0x7d };
  static uchar ac_luminance_vals[] =
    { 0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,
      0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
      0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
      0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
      0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
      0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
      0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
      0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
      0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
      0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
      0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
      0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
      0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
      0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
      0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
      0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
      0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
      0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
      0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
      0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
      0xf9, 0xfa };

  static uchar ac_chrominance_bits[17] =
    { /* 0-base */ 0, 0, 2, 1, 2, 4, 4, 3, 4, 7, 5, 4, 4, 0, 1, 2, 0x77 };
  static uchar ac_chrominance_vals[] =
    { 0x00, 0x01, 0x02, 0x03, 0x11, 0x04, 0x05, 0x21,
      0x31, 0x06, 0x12, 0x41, 0x51, 0x07, 0x61, 0x71,
      0x13, 0x22, 0x32, 0x81, 0x08, 0x14, 0x42, 0x91,
      0xa1, 0xb1, 0xc1, 0x09, 0x23, 0x33, 0x52, 0xf0,
      0x15, 0x62, 0x72, 0xd1, 0x0a, 0x16, 0x24, 0x34,
      0xe1, 0x25, 0xf1, 0x17, 0x18, 0x19, 0x1a, 0x26,
      0x27, 0x28, 0x29, 0x2a, 0x35, 0x36, 0x37, 0x38,
      0x39, 0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48,
      0x49, 0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
      0x59, 0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68,
      0x69, 0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
      0x79, 0x7a, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
      0x88, 0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96,
      0x97, 0x98, 0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5,
      0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4,
      0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3,
      0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2,
      0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda,
      0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9,
      0xea, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
      0xf9, 0xfa };

  for(ttt=0;ttt<4;ttt++)
  { ulong index = ttt & 1;
    long i,count;

    if (ttt <= 1)  /* DC tables */ 
    {
      htable = &(jpg_dc_huff[index]);
      hbits  = jpg_dc_huff[index].bits;
      hvals  = jpg_dc_huff[index].vals;
        if (index==0) { Sbits = dc_luminance_bits; Svals = dc_luminance_vals; }
        else { Sbits = dc_chrominance_bits; Svals = dc_chrominance_vals; }
    }
    else /* AC tables */
    {
      htable = &(jpg_ac_huff[index]);
      hbits  = jpg_ac_huff[index].bits;
      hvals  = jpg_ac_huff[index].vals;
        if (index==0) { Sbits = ac_luminance_bits; Svals = ac_luminance_vals; }
        else { Sbits = ac_chrominance_bits; Svals = ac_chrominance_vals; }
    }
    hbits[0] = 0;               count = 0;
    for (i = 1; i <= 16; i++)
    {
      hbits[i] = Sbits[i];
      count += hbits[i];
    }
    // len -= 17;
    if (count > 256) {
      // kprintf("JJ: STD DHT bad count %d\n",count);
      return(xaFALSE);
    }

    for (i = 0; i < count; i++) hvals[i] = Svals[i];
    // len -= count;

    jpg_huff_build(htable,hbits,hvals);

  } /* end of i */
  jpg_std_DHT_flag = 1;
  return(xaTRUE);
}
/* \\\ */

/* /// "jpg_search_marker()" */
ulong jpg_search_marker(ulong marker, uchar **data_ptr, long *data_size)
{ ulong d = 0;
  uchar *dptr = *data_ptr;
  long dsize = *data_size;

  while( dsize )
  {
    if (d == 0xff) /* potential marker */
    {
      d = *dptr++; dsize--;
      if (d == marker) 
      {
        *data_size = dsize; *data_ptr = dptr;   
        return(xaTRUE); /* found marker */
      }
    } else { d = *dptr++; dsize--; }
  }
  *data_size = dsize; *data_ptr = dptr;         
  return(xaFALSE);
}
/* \\\ */

/* /// "Tabellen und define's" */
char std_luminance_quant_tbl[64] = {
  16,  11,  12,  14,  12,  10,  16,  14,
  13,  14,  18,  17,  16,  19,  24,  40,
  26,  24,  22,  22,  24,  49,  35,  37,
  29,  40,  58,  51,  61,  60,  57,  51,
  56,  55,  64,  72,  92,  78,  64,  68,
  87,  69,  55,  56,  80, 109,  81,  87,
  95,  98, 103, 104, 103,  62,  77, 113,
 121, 112, 100, 120,  92, 101, 103,  99
};
 
char std_chrominance_quant_tbl[64] = {
  17,  18,  18,  24,  21,  24,  47,  26,
  26,  47,  99,  66,  56,  66,  99,  99,
  99,  99,  99,  99,  99,  99,  99,  99,
  99,  99,  99,  99,  99,  99,  99,  99,
  99,  99,  99,  99,  99,  99,  99,  99,
  99,  99,  99,  99,  99,  99,  99,  99,
  99,  99,  99,  99,  99,  99,  99,  99,
  99,  99,  99,  99,  99,  99,  99,  99
};

#define JPG_HANDLE_RST(rst_int,rst_cnt) {                                       \
  if ( ((rst_int) && (rst_cnt==0)) /* || (jpg_marker)*/ ) {                     \
    jpg_h_bbuf = 0;                                                             \
    jpg_h_bnum = 0;                                                             \
    /* DEBUG_LEVEL1 kprintf("  jRST_INT %d rst_cnt %d\n", rst_int,rst_cnt); */  \
    if (jpg_marker) {                                                           \
      /* DEBUG_LEVEL1 kprintf("  jpg_marker(%x)\n",jpg_marker); */              \
      if (jpg_marker == M_EOI) {                                                \
        jpg_saw_EOI = xaTRUE;                                                   \
        return(xaTRUE);                                                         \
      } else                                                                    \
        if ( !((jpg_marker >= M_RST0) && (jpg_marker <= M_RST7))) {             \
          /* kprintf("JPEG: unexp marker(%x)\n",jpg_marker); */                 \
          return(xaFALSE);                                                      \
        }                                                                       \
      jpg_marker = 0;                                                           \
    } else                                                                      \
      if (jpg_read_RST_marker()==xaFALSE) {                                     \
        /* kprintf("RST marker false\n"); */                                    \
        return(xaFALSE);                                                        \
      }                                                                         \
      jpg_comps[0].dc = jpg_comps[1].dc = jpg_comps[2].dc = 0;                  \
      rst_cnt = rst_int;                                                        \
  } else                                                                        \
    rst_cnt--;                                                                  \
};

#define JPG_TST_MARKER(rst_int,rst_cnt) {                          \
  if (jpg_marker) {                                                \
    /* DEBUG_LEVEL1 kprintf("  jpg_marker(%x)\n",jpg_marker); */   \
    if (jpg_marker == M_EOI) {                                     \
      jpg_saw_EOI = xaTRUE;                                        \
      /* return(xaTRUE); */                                        \
     } else                                                        \
       if ( !((jpg_marker >= M_RST0) && (jpg_marker <= M_RST7))) { \
         /* kprintf("JPEG: unexp marker(%x)\n",jpg_marker); */     \
         return(xaFALSE);                                          \
       } else {                                                    \
         jpg_comps[0].dc = jpg_comps[1].dc = jpg_comps[2].dc = 0;  \
         rst_cnt = rst_int;                                        \
         jpg_marker = 0;                                           \
         jpg_h_bbuf = 0;                                           \
         jpg_h_bnum = 0;                                           \
       }                                                           \
  }                                                                \
};
/* \\\ */

/* /// "jpg_decode_111111()" */
ulong jpg_decode_111111(uchar *image, ulong width, ulong height, ulong interleave, ulong row_offset, ulong imagex, ulong imagey, ulong xgray)
{
  uchar *iptr = image;
  ulong x,mcu_cols,mcu_rows;
  ulong *qtab0,*qtab1,*qtab2;
  uchar *Ybuf,*Ubuf,*Vbuf;
  ulong rst_count;
  ulong orow_size = imagex*bytes_pixel;

  if (row_offset) iptr += row_offset * orow_size;
  orow_size *= interleave;
  if (interleave == 2) imagey >>= 1;

  qtab0 = jpg_quant_tables[ jpg_comps[0].qtbl_num ];
  qtab1 = jpg_quant_tables[ jpg_comps[1].qtbl_num ];
  qtab2 = jpg_quant_tables[ jpg_comps[2].qtbl_num ];

  mcu_cols = (width  + 7) / 8;
  mcu_rows = (height + 7) / 8;
  // DEBUG_LEVEL1 kprintf("111111 begin MCUS(%d,%d)\n",mcu_cols,mcu_rows);
  jpg_marker = 0x00;

  rst_count = jpg_rst_interval;
  while(mcu_rows--)
  { 
    Ybuf = yuvBuf->yBuf; Ubuf = yuvBuf->uBuf; Vbuf = yuvBuf->vBuf;
    x = mcu_cols;
    while(x--)
    { 
      // DEBUG_LEVEL1 kprintf("  MCU XY(%d,%d)\n",x,mcu_rows);
      JPG_HANDLE_RST(jpg_rst_interval,rst_count);

      jpg_huffparse(&jpg_comps[0],jpg_dct_buf,qtab0,Ybuf); Ybuf += DCTSIZE2;
      if (gray==0)
      {
        jpg_huffparse(&jpg_comps[1],jpg_dct_buf,qtab1,Ubuf); Ubuf += DCTSIZE2;
        jpg_huffparse(&jpg_comps[2],jpg_dct_buf,qtab2,Vbuf); Vbuf += DCTSIZE2;
      } 
      JPG_TST_MARKER(jpg_rst_interval,rst_count);
    } /* end of mcu_cols */

    // DEBUG_LEVEL1 kprintf("imagey %d\n",imagey);
    // (void)(color_func)(iptr,imagex,xaMIN(imagey,8),(mcu_cols * DCTSIZE2), orow_size, &jpg_YUVBufs,&def_yuv_tabs, map_flag,map,chdr);
    if (xgray) MCU111111toGray(iptr,imagex,xaMIN(imagey,8),(mcu_cols * DCTSIZE2), orow_size);
    else       mcu111111(iptr,imagex,xaMIN(imagey,8),(mcu_cols * DCTSIZE2), orow_size);
    imagey -= 8;  iptr += (orow_size << 3);

  } /* end of mcu_rows */
  if (jpg_marker) { jpg_h_bbuf = 0; jpg_h_bnum = 0; }
  return(xaTRUE);
}
/* \\\ */

/* /// "jpg_decode_211111()" */
ulong jpg_decode_211111(uchar *image, ulong width, ulong height, ulong interleave, ulong row_offset, ulong imagex, ulong imagey)
{
  uchar *iptr = image;
  ulong x,mcu_cols,mcu_rows;
  ulong *qtab0,*qtab1,*qtab2;
  uchar *Ybuf,*Ubuf,*Vbuf;
  ulong rst_count;
  ulong orow_size = imagex*bytes_pixel;

  if (row_offset) iptr += row_offset * orow_size;
  orow_size *= interleave;
  if (interleave == 2) imagey >>= 1;
  imagex++; imagex >>= 1;

  qtab0 = jpg_quant_tables[ jpg_comps[0].qtbl_num ];
  qtab1 = jpg_quant_tables[ jpg_comps[1].qtbl_num ];
  qtab2 = jpg_quant_tables[ jpg_comps[2].qtbl_num ];

  mcu_cols = (width  + 15) / 16;
  mcu_rows = (height +  7) / 8;
  // DEBUG_LEVEL1 kprintf("211111 begin MCUS(%d,%d)\n",mcu_cols,mcu_rows);
  jpg_marker = 0x00;

  rst_count = jpg_rst_interval;
  while(mcu_rows--)
  { 
    Ybuf = yuvBuf->yBuf; Ubuf = yuvBuf->uBuf; Vbuf = yuvBuf->vBuf;
    x = mcu_cols;
    while(x--)
    { /* DEBUG_LEVEL1 kprintf("MCU XY(%d,%d)\n", x,mcu_rows); */

      JPG_HANDLE_RST(jpg_rst_interval,rst_count);

      jpg_huffparse(&jpg_comps[0],jpg_dct_buf,qtab0,Ybuf); Ybuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[0],jpg_dct_buf,qtab0,Ybuf); Ybuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[1],jpg_dct_buf,qtab1,Ubuf); Ubuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[2],jpg_dct_buf,qtab2,Vbuf); Vbuf += DCTSIZE2;
      JPG_TST_MARKER(jpg_rst_interval,rst_count);
    } /* end of mcu_cols */

    // (void)(color_func)(iptr,imagex,xaMIN(imagey,8),(mcu_cols * DCTSIZE2), orow_size, &jpg_YUVBufs,&def_yuv_tabs, map_flag,map,chdr);
    mcu211111(iptr,imagex,xaMIN(imagey,8),(mcu_cols * DCTSIZE2), orow_size);
    imagey -= 8;  iptr += (orow_size << 3);

  } /* end of mcu_rows */
  if (jpg_marker) { jpg_h_bbuf = 0; jpg_h_bnum = 0; }
  return(xaTRUE);
}
/* \\\ */

/* /// "jpg_decode_221111()" */
ulong jpg_decode_221111(uchar *image, ulong width, ulong height, ulong interleave, ulong row_offset, ulong imagex, ulong imagey)
{ uchar *iptr = image;
  long x,mcu_cols,mcu_rows;
  ulong *qtab0,*qtab1,*qtab2;
  uchar *Ybuf,*Ubuf,*Vbuf;
  ulong rst_count;
  ulong orow_size = imagex*bytes_pixel;

  if (row_offset) iptr += row_offset * orow_size;
  orow_size *= interleave;
  if (interleave == 2) imagey >>= 1;
  imagex++; imagex >>= 1;  /* 2h */
  qtab0 = jpg_quant_tables[ jpg_comps[0].qtbl_num ];
  qtab1 = jpg_quant_tables[ jpg_comps[1].qtbl_num ];
  qtab2 = jpg_quant_tables[ jpg_comps[2].qtbl_num ];

  mcu_cols = (width  + 15) / 16;
  mcu_rows = (height + 15) / 16;
  // DEBUG_LEVEL1 kprintf("221111 begin MCUS(%d,%d)\n",mcu_cols,mcu_rows);
  jpg_marker = 0x00;

  rst_count = jpg_rst_interval;
  while(mcu_rows--)
  { Ybuf = yuvBuf->yBuf; Ubuf = yuvBuf->uBuf; Vbuf = yuvBuf->vBuf;
    x = mcu_cols; while(x--)
    { // DEBUG_LEVEL1 kprintf("  MCU XY(%d,%d)\n",x,mcu_rows);

      JPG_HANDLE_RST(jpg_rst_interval,rst_count);

        /* Y0 Y1 Y2 Y3 U V */
      jpg_huffparse(&jpg_comps[0],jpg_dct_buf,qtab0,Ybuf); Ybuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[0],jpg_dct_buf,qtab0,Ybuf); Ybuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[0],jpg_dct_buf,qtab0,Ybuf); Ybuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[0],jpg_dct_buf,qtab0,Ybuf); Ybuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[1],jpg_dct_buf,qtab1,Ubuf); Ubuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[2],jpg_dct_buf,qtab2,Vbuf); Vbuf += DCTSIZE2;
      JPG_TST_MARKER(jpg_rst_interval,rst_count);
    } /* end of mcu_cols */

    // (void)(color_func)(iptr,imagex,xaMIN(imagey,16),(mcu_cols * DCTSIZE2),orow_size,&jpg_YUVBufs,&def_yuv_tabs,map_flag,map,chdr);
    mcu221111(iptr,imagex,xaMIN(imagey,16),(mcu_cols * DCTSIZE2), orow_size);
    imagey -= 16;  iptr += (orow_size << 4);

  } /* end of mcu_rows */
  if (jpg_marker) { jpg_h_bbuf = 0; jpg_h_bnum = 0; }
  // DEBUG_LEVEL1 kprintf("411: done\n");
  return(xaTRUE);
}
/* \\\ */

/* /// "jpg_decode_411111()" */
ulong jpg_decode_411111(uchar *image, ulong width, ulong height, ulong interleave, ulong row_offset, ulong imagex, ulong imagey)
{ uchar *iptr = image;
  long x,mcu_cols,mcu_rows;
  ulong *qtab0,*qtab1,*qtab2;
  uchar *Ybuf,*Ubuf,*Vbuf;
  ulong rst_count;
  ulong orow_size = imagex*bytes_pixel;

  if (row_offset) iptr += row_offset * orow_size;
  orow_size *= interleave;
  if (interleave == 2) imagey >>= 1;
  imagex +=3; imagex >>= 2; /* 4h */
  qtab0 = jpg_quant_tables[ jpg_comps[0].qtbl_num ];
  qtab1 = jpg_quant_tables[ jpg_comps[1].qtbl_num ];
  qtab2 = jpg_quant_tables[ jpg_comps[2].qtbl_num ];

  mcu_cols = (width  + 31) / 32;
  mcu_rows = (height + 7) / 8;
  // DEBUG_LEVEL1 kprintf("411111 begin MCUS(%d,%d)\n",mcu_cols,mcu_rows);
  jpg_marker = 0x00;

  rst_count = jpg_rst_interval;
  while(mcu_rows--)
  { Ybuf = yuvBuf->yBuf; Ubuf = yuvBuf->uBuf; Vbuf = yuvBuf->vBuf;
    x = mcu_cols; while(x--)
    { // DEBUG_LEVEL1 kprintf("  MCU XY(%d,%d)\n",x,mcu_rows);

      JPG_HANDLE_RST(jpg_rst_interval,rst_count);

        /* Y0 Y1 Y2 Y3 U V */
      jpg_huffparse(&jpg_comps[0],jpg_dct_buf,qtab0,Ybuf); Ybuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[0],jpg_dct_buf,qtab0,Ybuf); Ybuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[0],jpg_dct_buf,qtab0,Ybuf); Ybuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[0],jpg_dct_buf,qtab0,Ybuf); Ybuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[1],jpg_dct_buf,qtab1,Ubuf); Ubuf += DCTSIZE2;
      jpg_huffparse(&jpg_comps[2],jpg_dct_buf,qtab2,Vbuf); Vbuf += DCTSIZE2;
      JPG_TST_MARKER(jpg_rst_interval,rst_count);
    } /* end of mcu_cols */

    // (void)(color_func)(iptr,imagex,xaMIN(imagey,8),(mcu_cols * DCTSIZE2),orow_size,&jpg_YUVBufs,&def_yuv_tabs,map_flag,map,chdr);
    mcu411111(iptr,imagex,xaMIN(imagey,8),(mcu_cols * DCTSIZE2), orow_size);
    imagey -= 8;  iptr += (orow_size << 3);

  } /* end of mcu_rows */
  if (jpg_marker) { jpg_h_bbuf = 0; jpg_h_bnum = 0; }
  // DEBUG_LEVEL1 kprintf("411: done\n");
  return(xaTRUE);
}
/* \\\ */

/* /// "j_rev_dct()" */
#ifdef RIGHT_SHIFT_IS_UNSIGNED
#define SHIFT_TEMPS     long shift_temp;
#define RIGHT_SHIFT(x,shft)  \
        ((shift_temp = (x)) < 0 ? \
         (shift_temp >> (shft)) | ((~((long) 0)) << (32-(shft))) : \
         (shift_temp >> (shft)))
#else
#define SHIFT_TEMPS
#define RIGHT_SHIFT(x,shft)     ((x) >> (shft))
#endif

#define PASS1_BITS  2

#define ONE     ((long) 1)

#define CONST_BITS 13

#define CONST_SCALE (ONE << CONST_BITS)

#define FIX(x)  ((long) ((x) * CONST_SCALE + 0.5))

#define DESCALE(x,n)  RIGHT_SHIFT((x) + (ONE << ((n)-1)), n)

#define MULTIPLY(var,const)  ((var) * (const))

void j_rev_dct (short *data, uchar *outptr, uchar *limit)
{
  long tmp0, tmp1, tmp2, tmp3;
  long tmp10, tmp11, tmp12, tmp13;
  long z1, z2, z3, z4, z5;
  long d0, d1, d2, d3, d4, d5, d6, d7;
  register short *dataptr;
  int rowctr;
  SHIFT_TEMPS

  /* Pass 1: process rows. */
  /* Note results are scaled up by sqrt(8) compared to a true IDCT; */
  /* furthermore, we scale the results by 2**PASS1_BITS. */

  dataptr = data;

  for (rowctr = DCTSIZE-1; rowctr >= 0; rowctr--)
  {
    /* Due to quantization, we will usually find that many of the input
     * coefficients are zero, especially the AC terms.  We can exploit this
     * by short-circuiting the IDCT calculation for any row in which all
     * the AC terms are zero.  In that case each output is equal to the
     * DC coefficient (with scale factor as needed).
     * With typical images and quantization tables, half or more of the
     * row DCT calculations can be simplified this way.
     */

    register int *idataptr = (int*)dataptr;
    d0 = dataptr[0];
    d1 = dataptr[1];
    if ((d1 == 0) && (idataptr[1] | idataptr[2] | idataptr[3]) == 0) {
      /* AC terms all zero */
      if (d0) {
          /* Compute a 32 bit value to assign. */
          short dcval = (short) (d0 << PASS1_BITS);
          register int v = (dcval & 0xffff) | ((dcval << 16) & 0xffff0000);

          idataptr[0] = v;
          idataptr[1] = v;
          idataptr[2] = v;
          idataptr[3] = v;
      }

      dataptr += DCTSIZE;       /* advance pointer to next row */
      continue;
    }
    d2 = dataptr[2];
    d3 = dataptr[3];
    d4 = dataptr[4];
    d5 = dataptr[5];
    d6 = dataptr[6];
    d7 = dataptr[7];

    /* Even part: reverse the even part of the forward DCT. */
    /* The rotator is sqrt(2)*c(-6). */
    if (d6) {
        if (d4) {
            if (d2) {
                if (d0) {
                    /* d0 != 0, d2 != 0, d4 != 0, d6 != 0 */
                    z1 = MULTIPLY(d2 + d6, FIX(0.541196100));
                    tmp2 = z1 + MULTIPLY(d6, - FIX(1.847759065));
                    tmp3 = z1 + MULTIPLY(d2, FIX(0.765366865));

                    tmp0 = (d0 + d4) << CONST_BITS;
                    tmp1 = (d0 - d4) << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp1 + tmp2;
                    tmp12 = tmp1 - tmp2;
                } else {
                    /* d0 == 0, d2 != 0, d4 != 0, d6 != 0 */
                    z1 = MULTIPLY(d2 + d6, FIX(0.541196100));
                    tmp2 = z1 + MULTIPLY(d6, - FIX(1.847759065));
                    tmp3 = z1 + MULTIPLY(d2, FIX(0.765366865));

                    tmp0 = d4 << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp2 - tmp0;
                    tmp12 = -(tmp0 + tmp2);
                }
            } else {
                if (d0) {
                    /* d0 != 0, d2 == 0, d4 != 0, d6 != 0 */
                    tmp2 = MULTIPLY(d6, - FIX(1.306562965));
                    tmp3 = MULTIPLY(d6, FIX(0.541196100));

                    tmp0 = (d0 + d4) << CONST_BITS;
                    tmp1 = (d0 - d4) << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp1 + tmp2;
                    tmp12 = tmp1 - tmp2;
                } else {
                    /* d0 == 0, d2 == 0, d4 != 0, d6 != 0 */
                    tmp2 = MULTIPLY(d6, -FIX(1.306562965));
                    tmp3 = MULTIPLY(d6, FIX(0.541196100));

                    tmp0 = d4 << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp2 - tmp0;
                    tmp12 = -(tmp0 + tmp2);
                }
            }
        } else {
            if (d2) {
                if (d0) {
                    /* d0 != 0, d2 != 0, d4 == 0, d6 != 0 */
                    z1 = MULTIPLY(d2 + d6, FIX(0.541196100));
                    tmp2 = z1 + MULTIPLY(d6, - FIX(1.847759065));
                    tmp3 = z1 + MULTIPLY(d2, FIX(0.765366865));

                    tmp0 = d0 << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp0 + tmp2;
                    tmp12 = tmp0 - tmp2;
                } else {
                    /* d0 == 0, d2 != 0, d4 == 0, d6 != 0 */
                    z1 = MULTIPLY(d2 + d6, FIX(0.541196100));
                    tmp2 = z1 + MULTIPLY(d6, - FIX(1.847759065));
                    tmp3 = z1 + MULTIPLY(d2, FIX(0.765366865));

                    tmp10 = tmp3;
                    tmp13 = -tmp3;
                    tmp11 = tmp2;
                    tmp12 = -tmp2;
                }
            } else {
                if (d0) {
                    /* d0 != 0, d2 == 0, d4 == 0, d6 != 0 */
                    tmp2 = MULTIPLY(d6, - FIX(1.306562965));
                    tmp3 = MULTIPLY(d6, FIX(0.541196100));

                    tmp0 = d0 << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp0 + tmp2;
                    tmp12 = tmp0 - tmp2;
                } else {
                    /* d0 == 0, d2 == 0, d4 == 0, d6 != 0 */
                    tmp2 = MULTIPLY(d6, - FIX(1.306562965));
                    tmp3 = MULTIPLY(d6, FIX(0.541196100));

                    tmp10 = tmp3;
                    tmp13 = -tmp3;
                    tmp11 = tmp2;
                    tmp12 = -tmp2;
                }
            }
        }
    } else {
        if (d4) {
            if (d2) {
                if (d0) {
                    /* d0 != 0, d2 != 0, d4 != 0, d6 == 0 */
                    tmp2 = MULTIPLY(d2, FIX(0.541196100));
                    tmp3 = MULTIPLY(d2, FIX(1.306562965));

                    tmp0 = (d0 + d4) << CONST_BITS;
                    tmp1 = (d0 - d4) << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp1 + tmp2;
                    tmp12 = tmp1 - tmp2;
                } else {
                    /* d0 == 0, d2 != 0, d4 != 0, d6 == 0 */
                    tmp2 = MULTIPLY(d2, FIX(0.541196100));
                    tmp3 = MULTIPLY(d2, FIX(1.306562965));

                    tmp0 = d4 << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp2 - tmp0;
                    tmp12 = -(tmp0 + tmp2);
                }
            } else {
                if (d0) {
                    /* d0 != 0, d2 == 0, d4 != 0, d6 == 0 */
                    tmp10 = tmp13 = (d0 + d4) << CONST_BITS;
                    tmp11 = tmp12 = (d0 - d4) << CONST_BITS;
                } else {
                    /* d0 == 0, d2 == 0, d4 != 0, d6 == 0 */
                    tmp10 = tmp13 = d4 << CONST_BITS;
                    tmp11 = tmp12 = -tmp10;
                }
            }
        } else {
            if (d2) {
                if (d0) {
                    /* d0 != 0, d2 != 0, d4 == 0, d6 == 0 */
                    tmp2 = MULTIPLY(d2, FIX(0.541196100));
                    tmp3 = MULTIPLY(d2, FIX(1.306562965));

                    tmp0 = d0 << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp0 + tmp2;
                    tmp12 = tmp0 - tmp2;
                } else {
                    /* d0 == 0, d2 != 0, d4 == 0, d6 == 0 */
                    tmp2 = MULTIPLY(d2, FIX(0.541196100));
                    tmp3 = MULTIPLY(d2, FIX(1.306562965));

                    tmp10 = tmp3;
                    tmp13 = -tmp3;
                    tmp11 = tmp2;
                    tmp12 = -tmp2;
                }
            } else {
                if (d0) {
                    /* d0 != 0, d2 == 0, d4 == 0, d6 == 0 */
                    tmp10 = tmp13 = tmp11 = tmp12 = d0 << CONST_BITS;
                } else {
                    /* d0 == 0, d2 == 0, d4 == 0, d6 == 0 */
                    tmp10 = tmp13 = tmp11 = tmp12 = 0;
                }
            }
        }
    }


    /* Odd part per figure 8; the matrix is unitary and hence its
     * transpose is its inverse.  i0..i3 are y7,y5,y3,y1 respectively.
     */

    if (d7) {
        if (d5) {
            if (d3) {
                if (d1) {
                    /* d1 != 0, d3 != 0, d5 != 0, d7 != 0 */
                    z1 = d7 + d1;
                    z2 = d5 + d3;
                    z3 = d7 + d3;
                    z4 = d5 + d1;
                    z5 = MULTIPLY(z3 + z4, FIX(1.175875602));

                    tmp0 = MULTIPLY(d7, FIX(0.298631336));
                    tmp1 = MULTIPLY(d5, FIX(2.053119869));
                    tmp2 = MULTIPLY(d3, FIX(3.072711026));
                    tmp3 = MULTIPLY(d1, FIX(1.501321110));
                    z1 = MULTIPLY(z1, - FIX(0.899976223));
                    z2 = MULTIPLY(z2, - FIX(2.562915447));
                    z3 = MULTIPLY(z3, - FIX(1.961570560));
                    z4 = MULTIPLY(z4, - FIX(0.390180644));

                    z3 += z5;
                    z4 += z5;

                    tmp0 += z1 + z3;
                    tmp1 += z2 + z4;
                    tmp2 += z2 + z3;
                    tmp3 += z1 + z4;
                } else {
                    /* d1 == 0, d3 != 0, d5 != 0, d7 != 0 */
                    z1 = d7;
                    z2 = d5 + d3;
                    z3 = d7 + d3;
                    z5 = MULTIPLY(z3 + d5, FIX(1.175875602));

                    tmp0 = MULTIPLY(d7, FIX(0.298631336));
                    tmp1 = MULTIPLY(d5, FIX(2.053119869));
                    tmp2 = MULTIPLY(d3, FIX(3.072711026));
                    z1 = MULTIPLY(d7, - FIX(0.899976223));
                    z2 = MULTIPLY(z2, - FIX(2.562915447));
                    z3 = MULTIPLY(z3, - FIX(1.961570560));
                    z4 = MULTIPLY(d5, - FIX(0.390180644));

                    z3 += z5;
                    z4 += z5;

                    tmp0 += z1 + z3;
                    tmp1 += z2 + z4;
                    tmp2 += z2 + z3;
                    tmp3 = z1 + z4;
                }
            } else {
                if (d1) {
                    /* d1 != 0, d3 == 0, d5 != 0, d7 != 0 */
                    z1 = d7 + d1;
                    z2 = d5;
                    z3 = d7;
                    z4 = d5 + d1;
                    z5 = MULTIPLY(z3 + z4, FIX(1.175875602));

                    tmp0 = MULTIPLY(d7, FIX(0.298631336));
                    tmp1 = MULTIPLY(d5, FIX(2.053119869));
                    tmp3 = MULTIPLY(d1, FIX(1.501321110));
                    z1 = MULTIPLY(z1, - FIX(0.899976223));
                    z2 = MULTIPLY(d5, - FIX(2.562915447));
                    z3 = MULTIPLY(d7, - FIX(1.961570560));
                    z4 = MULTIPLY(z4, - FIX(0.390180644));

                    z3 += z5;
                    z4 += z5;

                    tmp0 += z1 + z3;
                    tmp1 += z2 + z4;
                    tmp2 = z2 + z3;
                    tmp3 += z1 + z4;
                } else {
                    /* d1 == 0, d3 == 0, d5 != 0, d7 != 0 */
                    tmp0 = MULTIPLY(d7, - FIX(0.601344887));
                    z1 = MULTIPLY(d7, - FIX(0.899976223));
                    z3 = MULTIPLY(d7, - FIX(1.961570560));
                    tmp1 = MULTIPLY(d5, - FIX(0.509795578));
                    z2 = MULTIPLY(d5, - FIX(2.562915447));
                    z4 = MULTIPLY(d5, - FIX(0.390180644));
                    z5 = MULTIPLY(d5 + d7, FIX(1.175875602));

                    z3 += z5;
                    z4 += z5;

                    tmp0 += z3;
                    tmp1 += z4;
                    tmp2 = z2 + z3;
                    tmp3 = z1 + z4;
                }
            }
        } else {
            if (d3) {
                if (d1) {
                    /* d1 != 0, d3 != 0, d5 == 0, d7 != 0 */
                    z1 = d7 + d1;
                    z3 = d7 + d3;
                    z5 = MULTIPLY(z3 + d1, FIX(1.175875602));

                    tmp0 = MULTIPLY(d7, FIX(0.298631336));
                    tmp2 = MULTIPLY(d3, FIX(3.072711026));
                    tmp3 = MULTIPLY(d1, FIX(1.501321110));
                    z1 = MULTIPLY(z1, - FIX(0.899976223));
                    z2 = MULTIPLY(d3, - FIX(2.562915447));
                    z3 = MULTIPLY(z3, - FIX(1.961570560));
                    z4 = MULTIPLY(d1, - FIX(0.390180644));

                    z3 += z5;
                    z4 += z5;

                    tmp0 += z1 + z3;
                    tmp1 = z2 + z4;
                    tmp2 += z2 + z3;
                    tmp3 += z1 + z4;
                } else {
                    /* d1 == 0, d3 != 0, d5 == 0, d7 != 0 */
                    z3 = d7 + d3;

                    tmp0 = MULTIPLY(d7, - FIX(0.601344887));
                    z1 = MULTIPLY(d7, - FIX(0.899976223));
                    tmp2 = MULTIPLY(d3, FIX(0.509795579));
                    z2 = MULTIPLY(d3, - FIX(2.562915447));
                    z5 = MULTIPLY(z3, FIX(1.175875602));
                    z3 = MULTIPLY(z3, - FIX(0.785694958));

                    tmp0 += z3;
                    tmp1 = z2 + z5;
                    tmp2 += z3;
                    tmp3 = z1 + z5;
                }
            } else {
                if (d1) {
                    /* d1 != 0, d3 == 0, d5 == 0, d7 != 0 */
                    z1 = d7 + d1;
                    z5 = MULTIPLY(z1, FIX(1.175875602));

                    z1 = MULTIPLY(z1, FIX(0.275899379));
                    z3 = MULTIPLY(d7, - FIX(1.961570560));
                    tmp0 = MULTIPLY(d7, - FIX(1.662939224));
                    z4 = MULTIPLY(d1, - FIX(0.390180644));
                    tmp3 = MULTIPLY(d1, FIX(1.111140466));

                    tmp0 += z1;
                    tmp1 = z4 + z5;
                    tmp2 = z3 + z5;
                    tmp3 += z1;
                } else {
                    /* d1 == 0, d3 == 0, d5 == 0, d7 != 0 */
                    tmp0 = MULTIPLY(d7, - FIX(1.387039845));
                    tmp1 = MULTIPLY(d7, FIX(1.175875602));
                    tmp2 = MULTIPLY(d7, - FIX(0.785694958));
                    tmp3 = MULTIPLY(d7, FIX(0.275899379));
                }
            }
        }
    } else {
        if (d5) {
            if (d3) {
                if (d1) {
                    /* d1 != 0, d3 != 0, d5 != 0, d7 == 0 */
                    z2 = d5 + d3;
                    z4 = d5 + d1;
                    z5 = MULTIPLY(d3 + z4, FIX(1.175875602));

                    tmp1 = MULTIPLY(d5, FIX(2.053119869));
                    tmp2 = MULTIPLY(d3, FIX(3.072711026));
                    tmp3 = MULTIPLY(d1, FIX(1.501321110));
                    z1 = MULTIPLY(d1, - FIX(0.899976223));
                    z2 = MULTIPLY(z2, - FIX(2.562915447));
                    z3 = MULTIPLY(d3, - FIX(1.961570560));
                    z4 = MULTIPLY(z4, - FIX(0.390180644));

                    z3 += z5;
                    z4 += z5;

                    tmp0 = z1 + z3;
                    tmp1 += z2 + z4;
                    tmp2 += z2 + z3;
                    tmp3 += z1 + z4;
                } else {
                    /* d1 == 0, d3 != 0, d5 != 0, d7 == 0 */
                    z2 = d5 + d3;

                    z5 = MULTIPLY(z2, FIX(1.175875602));
                    tmp1 = MULTIPLY(d5, FIX(1.662939225));
                    z4 = MULTIPLY(d5, - FIX(0.390180644));
                    z2 = MULTIPLY(z2, - FIX(1.387039845));
                    tmp2 = MULTIPLY(d3, FIX(1.111140466));
                    z3 = MULTIPLY(d3, - FIX(1.961570560));

                    tmp0 = z3 + z5;
                    tmp1 += z2;
                    tmp2 += z2;
                    tmp3 = z4 + z5;
                }
            } else {
                if (d1) {
                    /* d1 != 0, d3 == 0, d5 != 0, d7 == 0 */
                    z4 = d5 + d1;

                    z5 = MULTIPLY(z4, FIX(1.175875602));
                    z1 = MULTIPLY(d1, - FIX(0.899976223));
                    tmp3 = MULTIPLY(d1, FIX(0.601344887));
                    tmp1 = MULTIPLY(d5, - FIX(0.509795578));
                    z2 = MULTIPLY(d5, - FIX(2.562915447));
                    z4 = MULTIPLY(z4, FIX(0.785694958));

                    tmp0 = z1 + z5;
                    tmp1 += z4;
                    tmp2 = z2 + z5;
                    tmp3 += z4;
                } else {
                    /* d1 == 0, d3 == 0, d5 != 0, d7 == 0 */
                    tmp0 = MULTIPLY(d5, FIX(1.175875602));
                    tmp1 = MULTIPLY(d5, FIX(0.275899380));
                    tmp2 = MULTIPLY(d5, - FIX(1.387039845));
                    tmp3 = MULTIPLY(d5, FIX(0.785694958));
                }
            }
        } else {
            if (d3) {
                if (d1) {
                    /* d1 != 0, d3 != 0, d5 == 0, d7 == 0 */
                    z5 = d1 + d3;
                    tmp3 = MULTIPLY(d1, FIX(0.211164243));
                    tmp2 = MULTIPLY(d3, - FIX(1.451774981));
                    z1 = MULTIPLY(d1, FIX(1.061594337));
                    z2 = MULTIPLY(d3, - FIX(2.172734803));
                    z4 = MULTIPLY(z5, FIX(0.785694958));
                    z5 = MULTIPLY(z5, FIX(1.175875602));

                    tmp0 = z1 - z4;
                    tmp1 = z2 + z4;
                    tmp2 += z5;
                    tmp3 += z5;
                } else {
                    /* d1 == 0, d3 != 0, d5 == 0, d7 == 0 */
                    tmp0 = MULTIPLY(d3, - FIX(0.785694958));
                    tmp1 = MULTIPLY(d3, - FIX(1.387039845));
                    tmp2 = MULTIPLY(d3, - FIX(0.275899379));
                    tmp3 = MULTIPLY(d3, FIX(1.175875602));
                }
            } else {
                if (d1) {
                    /* d1 != 0, d3 == 0, d5 == 0, d7 == 0 */
                    tmp0 = MULTIPLY(d1, FIX(0.275899379));
                    tmp1 = MULTIPLY(d1, FIX(0.785694958));
                    tmp2 = MULTIPLY(d1, FIX(1.175875602));
                    tmp3 = MULTIPLY(d1, FIX(1.387039845));
                } else {
                    /* d1 == 0, d3 == 0, d5 == 0, d7 == 0 */
                    tmp0 = tmp1 = tmp2 = tmp3 = 0;
                }
            }
        }
    }

    /* Final output stage: inputs are tmp10..tmp13, tmp0..tmp3 */

    dataptr[0] = (short) DESCALE(tmp10 + tmp3, CONST_BITS-PASS1_BITS);
    dataptr[7] = (short) DESCALE(tmp10 - tmp3, CONST_BITS-PASS1_BITS);
    dataptr[1] = (short) DESCALE(tmp11 + tmp2, CONST_BITS-PASS1_BITS);
    dataptr[6] = (short) DESCALE(tmp11 - tmp2, CONST_BITS-PASS1_BITS);
    dataptr[2] = (short) DESCALE(tmp12 + tmp1, CONST_BITS-PASS1_BITS);
    dataptr[5] = (short) DESCALE(tmp12 - tmp1, CONST_BITS-PASS1_BITS);
    dataptr[3] = (short) DESCALE(tmp13 + tmp0, CONST_BITS-PASS1_BITS);
    dataptr[4] = (short) DESCALE(tmp13 - tmp0, CONST_BITS-PASS1_BITS);

    dataptr += DCTSIZE;         /* advance pointer to next row */
  }

  /* Pass 2: process columns. */
  /* Note that we must descale the results by a factor of 8 == 2**3, */
  /* and also undo the PASS1_BITS scaling. */

  dataptr = data;
  for (rowctr = DCTSIZE-1; rowctr >= 0; rowctr--)
  {
    /* Columns of zeroes can be exploited in the same way as we did with rows.
     * However, the row calculation has created many nonzero AC terms, so the
     * simplification applies less often (typically 5% to 10% of the time).
     * On machines with very fast multiplication, it's possible that the
     * test takes more time than it's worth.  In that case this section
     * may be commented out.
     */

    d0 = dataptr[DCTSIZE*0];
    d1 = dataptr[DCTSIZE*1];
    d2 = dataptr[DCTSIZE*2];
    d3 = dataptr[DCTSIZE*3];
    d4 = dataptr[DCTSIZE*4];
    d5 = dataptr[DCTSIZE*5];
    d6 = dataptr[DCTSIZE*6];
    d7 = dataptr[DCTSIZE*7];

    /* Even part: reverse the even part of the forward DCT. */
    /* The rotator is sqrt(2)*c(-6). */
    if (d6) {
        if (d4) {
            if (d2) {
                if (d0) {
                    /* d0 != 0, d2 != 0, d4 != 0, d6 != 0 */
                    z1 = MULTIPLY(d2 + d6, FIX(0.541196100));
                    tmp2 = z1 + MULTIPLY(d6, - FIX(1.847759065));
                    tmp3 = z1 + MULTIPLY(d2, FIX(0.765366865));

                    tmp0 = (d0 + d4) << CONST_BITS;
                    tmp1 = (d0 - d4) << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp1 + tmp2;
                    tmp12 = tmp1 - tmp2;
                } else {
                    /* d0 == 0, d2 != 0, d4 != 0, d6 != 0 */
                    z1 = MULTIPLY(d2 + d6, FIX(0.541196100));
                    tmp2 = z1 + MULTIPLY(d6, - FIX(1.847759065));
                    tmp3 = z1 + MULTIPLY(d2, FIX(0.765366865));

                    tmp0 = d4 << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp2 - tmp0;
                    tmp12 = -(tmp0 + tmp2);
                }
            } else {
                if (d0) {
                    /* d0 != 0, d2 == 0, d4 != 0, d6 != 0 */
                    tmp2 = MULTIPLY(d6, - FIX(1.306562965));
                    tmp3 = MULTIPLY(d6, FIX(0.541196100));

                    tmp0 = (d0 + d4) << CONST_BITS;
                    tmp1 = (d0 - d4) << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp1 + tmp2;
                    tmp12 = tmp1 - tmp2;
                } else {
                    /* d0 == 0, d2 == 0, d4 != 0, d6 != 0 */
                    tmp2 = MULTIPLY(d6, -FIX(1.306562965));
                    tmp3 = MULTIPLY(d6, FIX(0.541196100));

                    tmp0 = d4 << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp2 - tmp0;
                    tmp12 = -(tmp0 + tmp2);
                }
            }
        } else {
            if (d2) {
                if (d0) {
                    /* d0 != 0, d2 != 0, d4 == 0, d6 != 0 */
                    z1 = MULTIPLY(d2 + d6, FIX(0.541196100));
                    tmp2 = z1 + MULTIPLY(d6, - FIX(1.847759065));
                    tmp3 = z1 + MULTIPLY(d2, FIX(0.765366865));

                    tmp0 = d0 << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp0 + tmp2;
                    tmp12 = tmp0 - tmp2;
                } else {
                    /* d0 == 0, d2 != 0, d4 == 0, d6 != 0 */
                    z1 = MULTIPLY(d2 + d6, FIX(0.541196100));
                    tmp2 = z1 + MULTIPLY(d6, - FIX(1.847759065));
                    tmp3 = z1 + MULTIPLY(d2, FIX(0.765366865));

                    tmp10 = tmp3;
                    tmp13 = -tmp3;
                    tmp11 = tmp2;
                    tmp12 = -tmp2;
                }
            } else {
                if (d0) {
                    /* d0 != 0, d2 == 0, d4 == 0, d6 != 0 */
                    tmp2 = MULTIPLY(d6, - FIX(1.306562965));
                    tmp3 = MULTIPLY(d6, FIX(0.541196100));

                    tmp0 = d0 << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp0 + tmp2;
                    tmp12 = tmp0 - tmp2;
                } else {
                    /* d0 == 0, d2 == 0, d4 == 0, d6 != 0 */
                    tmp2 = MULTIPLY(d6, - FIX(1.306562965));
                    tmp3 = MULTIPLY(d6, FIX(0.541196100));

                    tmp10 = tmp3;
                    tmp13 = -tmp3;
                    tmp11 = tmp2;
                    tmp12 = -tmp2;
                }
            }
        }
    } else {
        if (d4) {
            if (d2) {
                if (d0) {
                    /* d0 != 0, d2 != 0, d4 != 0, d6 == 0 */
                    tmp2 = MULTIPLY(d2, FIX(0.541196100));
                    tmp3 = MULTIPLY(d2, FIX(1.306562965));

                    tmp0 = (d0 + d4) << CONST_BITS;
                    tmp1 = (d0 - d4) << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp1 + tmp2;
                    tmp12 = tmp1 - tmp2;
                } else {
                    /* d0 == 0, d2 != 0, d4 != 0, d6 == 0 */
                    tmp2 = MULTIPLY(d2, FIX(0.541196100));
                    tmp3 = MULTIPLY(d2, FIX(1.306562965));

                    tmp0 = d4 << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp2 - tmp0;
                    tmp12 = -(tmp0 + tmp2);
                }
            } else {
                if (d0) {
                    /* d0 != 0, d2 == 0, d4 != 0, d6 == 0 */
                    tmp10 = tmp13 = (d0 + d4) << CONST_BITS;
                    tmp11 = tmp12 = (d0 - d4) << CONST_BITS;
                } else {
                    /* d0 == 0, d2 == 0, d4 != 0, d6 == 0 */
                    tmp10 = tmp13 = d4 << CONST_BITS;
                    tmp11 = tmp12 = -tmp10;
                }
            }
        } else {
            if (d2) {
                if (d0) {
                    /* d0 != 0, d2 != 0, d4 == 0, d6 == 0 */
                    tmp2 = MULTIPLY(d2, FIX(0.541196100));
                    tmp3 = MULTIPLY(d2, FIX(1.306562965));

                    tmp0 = d0 << CONST_BITS;

                    tmp10 = tmp0 + tmp3;
                    tmp13 = tmp0 - tmp3;
                    tmp11 = tmp0 + tmp2;
                    tmp12 = tmp0 - tmp2;
                } else {
                    /* d0 == 0, d2 != 0, d4 == 0, d6 == 0 */
                    tmp2 = MULTIPLY(d2, FIX(0.541196100));
                    tmp3 = MULTIPLY(d2, FIX(1.306562965));

                    tmp10 = tmp3;
                    tmp13 = -tmp3;
                    tmp11 = tmp2;
                    tmp12 = -tmp2;
                }
            } else {
                if (d0) {
                    /* d0 != 0, d2 == 0, d4 == 0, d6 == 0 */
                    tmp10 = tmp13 = tmp11 = tmp12 = d0 << CONST_BITS;
                } else {
                    /* d0 == 0, d2 == 0, d4 == 0, d6 == 0 */
                    tmp10 = tmp13 = tmp11 = tmp12 = 0;
                }
            }
        }
    }

    /* Odd part per figure 8; the matrix is unitary and hence its
     * transpose is its inverse.  i0..i3 are y7,y5,y3,y1 respectively.
     */
    if (d7) {
        if (d5) {
            if (d3) {
                if (d1) {
                    /* d1 != 0, d3 != 0, d5 != 0, d7 != 0 */
                    z1 = d7 + d1;
                    z2 = d5 + d3;
                    z3 = d7 + d3;
                    z4 = d5 + d1;
                    z5 = MULTIPLY(z3 + z4, FIX(1.175875602));

                    tmp0 = MULTIPLY(d7, FIX(0.298631336));
                    tmp1 = MULTIPLY(d5, FIX(2.053119869));
                    tmp2 = MULTIPLY(d3, FIX(3.072711026));
                    tmp3 = MULTIPLY(d1, FIX(1.501321110));
                    z1 = MULTIPLY(z1, - FIX(0.899976223));
                    z2 = MULTIPLY(z2, - FIX(2.562915447));
                    z3 = MULTIPLY(z3, - FIX(1.961570560));
                    z4 = MULTIPLY(z4, - FIX(0.390180644));

                    z3 += z5;
                    z4 += z5;

                    tmp0 += z1 + z3;
                    tmp1 += z2 + z4;
                    tmp2 += z2 + z3;
                    tmp3 += z1 + z4;
                } else {
                    /* d1 == 0, d3 != 0, d5 != 0, d7 != 0 */
                    z1 = d7;
                    z2 = d5 + d3;
                    z3 = d7 + d3;
                    z5 = MULTIPLY(z3 + d5, FIX(1.175875602));

                    tmp0 = MULTIPLY(d7, FIX(0.298631336));
                    tmp1 = MULTIPLY(d5, FIX(2.053119869));
                    tmp2 = MULTIPLY(d3, FIX(3.072711026));
                    z1 = MULTIPLY(d7, - FIX(0.899976223));
                    z2 = MULTIPLY(z2, - FIX(2.562915447));
                    z3 = MULTIPLY(z3, - FIX(1.961570560));
                    z4 = MULTIPLY(d5, - FIX(0.390180644));

                    z3 += z5;
                    z4 += z5;

                    tmp0 += z1 + z3;
                    tmp1 += z2 + z4;
                    tmp2 += z2 + z3;
                    tmp3 = z1 + z4;
                }
            } else {
                if (d1) {
                    /* d1 != 0, d3 == 0, d5 != 0, d7 != 0 */
                    z1 = d7 + d1;
                    z2 = d5;
                    z3 = d7;
                    z4 = d5 + d1;
                    z5 = MULTIPLY(z3 + z4, FIX(1.175875602));

                    tmp0 = MULTIPLY(d7, FIX(0.298631336));
                    tmp1 = MULTIPLY(d5, FIX(2.053119869));
                    tmp3 = MULTIPLY(d1, FIX(1.501321110));
                    z1 = MULTIPLY(z1, - FIX(0.899976223));
                    z2 = MULTIPLY(d5, - FIX(2.562915447));
                    z3 = MULTIPLY(d7, - FIX(1.961570560));
                    z4 = MULTIPLY(z4, - FIX(0.390180644));

                    z3 += z5;
                    z4 += z5;

                    tmp0 += z1 + z3;
                    tmp1 += z2 + z4;
                    tmp2 = z2 + z3;
                    tmp3 += z1 + z4;
                } else {
                    /* d1 == 0, d3 == 0, d5 != 0, d7 != 0 */
                    tmp0 = MULTIPLY(d7, - FIX(0.601344887));
                    z1 = MULTIPLY(d7, - FIX(0.899976223));
                    z3 = MULTIPLY(d7, - FIX(1.961570560));
                    tmp1 = MULTIPLY(d5, - FIX(0.509795578));
                    z2 = MULTIPLY(d5, - FIX(2.562915447));
                    z4 = MULTIPLY(d5, - FIX(0.390180644));
                    z5 = MULTIPLY(d5 + d7, FIX(1.175875602));

                    z3 += z5;
                    z4 += z5;

                    tmp0 += z3;
                    tmp1 += z4;
                    tmp2 = z2 + z3;
                    tmp3 = z1 + z4;
                }
            }
        } else {
            if (d3) {
                if (d1) {
                    /* d1 != 0, d3 != 0, d5 == 0, d7 != 0 */
                    z1 = d7 + d1;
                    z3 = d7 + d3;
                    z5 = MULTIPLY(z3 + d1, FIX(1.175875602));

                    tmp0 = MULTIPLY(d7, FIX(0.298631336));
                    tmp2 = MULTIPLY(d3, FIX(3.072711026));
                    tmp3 = MULTIPLY(d1, FIX(1.501321110));
                    z1 = MULTIPLY(z1, - FIX(0.899976223));
                    z2 = MULTIPLY(d3, - FIX(2.562915447));
                    z3 = MULTIPLY(z3, - FIX(1.961570560));
                    z4 = MULTIPLY(d1, - FIX(0.390180644));

                    z3 += z5;
                    z4 += z5;

                    tmp0 += z1 + z3;
                    tmp1 = z2 + z4;
                    tmp2 += z2 + z3;
                    tmp3 += z1 + z4;
                } else {
                    /* d1 == 0, d3 != 0, d5 == 0, d7 != 0 */
                    z3 = d7 + d3;

                    tmp0 = MULTIPLY(d7, - FIX(0.601344887));
                    z1 = MULTIPLY(d7, - FIX(0.899976223));
                    tmp2 = MULTIPLY(d3, FIX(0.509795579));
                    z2 = MULTIPLY(d3, - FIX(2.562915447));
                    z5 = MULTIPLY(z3, FIX(1.175875602));
                    z3 = MULTIPLY(z3, - FIX(0.785694958));

                    tmp0 += z3;
                    tmp1 = z2 + z5;
                    tmp2 += z3;
                    tmp3 = z1 + z5;
                }
            } else {
                if (d1) {
                    /* d1 != 0, d3 == 0, d5 == 0, d7 != 0 */
                    z1 = d7 + d1;
                    z5 = MULTIPLY(z1, FIX(1.175875602));

                    z1 = MULTIPLY(z1, FIX(0.275899379));
                    z3 = MULTIPLY(d7, - FIX(1.961570560));
                    tmp0 = MULTIPLY(d7, - FIX(1.662939224));
                    z4 = MULTIPLY(d1, - FIX(0.390180644));
                    tmp3 = MULTIPLY(d1, FIX(1.111140466));

                    tmp0 += z1;
                    tmp1 = z4 + z5;
                    tmp2 = z3 + z5;
                    tmp3 += z1;
                } else {
                    /* d1 == 0, d3 == 0, d5 == 0, d7 != 0 */
                    tmp0 = MULTIPLY(d7, - FIX(1.387039845));
                    tmp1 = MULTIPLY(d7, FIX(1.175875602));
                    tmp2 = MULTIPLY(d7, - FIX(0.785694958));
                    tmp3 = MULTIPLY(d7, FIX(0.275899379));
                }
            }
        }
    } else {
        if (d5) {
            if (d3) {
                if (d1) {
                    /* d1 != 0, d3 != 0, d5 != 0, d7 == 0 */
                    z2 = d5 + d3;
                    z4 = d5 + d1;
                    z5 = MULTIPLY(d3 + z4, FIX(1.175875602));

                    tmp1 = MULTIPLY(d5, FIX(2.053119869));
                    tmp2 = MULTIPLY(d3, FIX(3.072711026));
                    tmp3 = MULTIPLY(d1, FIX(1.501321110));
                    z1 = MULTIPLY(d1, - FIX(0.899976223));
                    z2 = MULTIPLY(z2, - FIX(2.562915447));
                    z3 = MULTIPLY(d3, - FIX(1.961570560));
                    z4 = MULTIPLY(z4, - FIX(0.390180644));

                    z3 += z5;
                    z4 += z5;

                    tmp0 = z1 + z3;
                    tmp1 += z2 + z4;
                    tmp2 += z2 + z3;
                    tmp3 += z1 + z4;
                } else {
                    /* d1 == 0, d3 != 0, d5 != 0, d7 == 0 */
                    z2 = d5 + d3;

                    z5 = MULTIPLY(z2, FIX(1.175875602));
                    tmp1 = MULTIPLY(d5, FIX(1.662939225));
                    z4 = MULTIPLY(d5, - FIX(0.390180644));
                    z2 = MULTIPLY(z2, - FIX(1.387039845));
                    tmp2 = MULTIPLY(d3, FIX(1.111140466));
                    z3 = MULTIPLY(d3, - FIX(1.961570560));

                    tmp0 = z3 + z5;
                    tmp1 += z2;
                    tmp2 += z2;
                    tmp3 = z4 + z5;
                }
            } else {
                if (d1) {
                    /* d1 != 0, d3 == 0, d5 != 0, d7 == 0 */
                    z4 = d5 + d1;

                    z5 = MULTIPLY(z4, FIX(1.175875602));
                    z1 = MULTIPLY(d1, - FIX(0.899976223));
                    tmp3 = MULTIPLY(d1, FIX(0.601344887));
                    tmp1 = MULTIPLY(d5, - FIX(0.509795578));
                    z2 = MULTIPLY(d5, - FIX(2.562915447));
                    z4 = MULTIPLY(z4, FIX(0.785694958));

                    tmp0 = z1 + z5;
                    tmp1 += z4;
                    tmp2 = z2 + z5;
                    tmp3 += z4;
                } else {
                    /* d1 == 0, d3 == 0, d5 != 0, d7 == 0 */
                    tmp0 = MULTIPLY(d5, FIX(1.175875602));
                    tmp1 = MULTIPLY(d5, FIX(0.275899380));
                    tmp2 = MULTIPLY(d5, - FIX(1.387039845));
                    tmp3 = MULTIPLY(d5, FIX(0.785694958));
                }
            }
        } else {
            if (d3) {
                if (d1) {
                    /* d1 != 0, d3 != 0, d5 == 0, d7 == 0 */
                    z5 = d1 + d3;
                    tmp3 = MULTIPLY(d1, FIX(0.211164243));
                    tmp2 = MULTIPLY(d3, - FIX(1.451774981));
                    z1 = MULTIPLY(d1, FIX(1.061594337));
                    z2 = MULTIPLY(d3, - FIX(2.172734803));
                    z4 = MULTIPLY(z5, FIX(0.785694958));
                    z5 = MULTIPLY(z5, FIX(1.175875602));

                    tmp0 = z1 - z4;
                    tmp1 = z2 + z4;
                    tmp2 += z5;
                    tmp3 += z5;
                } else {
                    /* d1 == 0, d3 != 0, d5 == 0, d7 == 0 */
                    tmp0 = MULTIPLY(d3, - FIX(0.785694958));
                    tmp1 = MULTIPLY(d3, - FIX(1.387039845));
                    tmp2 = MULTIPLY(d3, - FIX(0.275899379));
                    tmp3 = MULTIPLY(d3, FIX(1.175875602));
                }
            } else {
                if (d1) {
                    /* d1 != 0, d3 == 0, d5 == 0, d7 == 0 */
                    tmp0 = MULTIPLY(d1, FIX(0.275899379));
                    tmp1 = MULTIPLY(d1, FIX(0.785694958));
                    tmp2 = MULTIPLY(d1, FIX(1.175875602));
                    tmp3 = MULTIPLY(d1, FIX(1.387039845));
                } else {
                    /* d1 == 0, d3 == 0, d5 == 0, d7 == 0 */
                    tmp0 = tmp1 = tmp2 = tmp3 = 0;
                }
            }
        }
    }

    /* Final output stage: inputs are tmp10..tmp13, tmp0..tmp3 */


    outptr[DCTSIZE*0] = limit[ (int) DESCALE(tmp10 + tmp3,
                                CONST_BITS+PASS1_BITS+3) & RANGE_MASK];
    outptr[DCTSIZE*7] = limit[ (int) DESCALE(tmp10 - tmp3,
                                CONST_BITS+PASS1_BITS+3) & RANGE_MASK];
    outptr[DCTSIZE*1] = limit[ (int) DESCALE(tmp11 + tmp2,
                                CONST_BITS+PASS1_BITS+3) & RANGE_MASK];
    outptr[DCTSIZE*6] = limit[ (int) DESCALE(tmp11 - tmp2,
                                CONST_BITS+PASS1_BITS+3) & RANGE_MASK];
    outptr[DCTSIZE*2] = limit[ (int) DESCALE(tmp12 + tmp1,
                                CONST_BITS+PASS1_BITS+3) & RANGE_MASK];
    outptr[DCTSIZE*5] = limit[ (int) DESCALE(tmp12 - tmp1,
                                CONST_BITS+PASS1_BITS+3) & RANGE_MASK];
    outptr[DCTSIZE*3] = limit[ (int) DESCALE(tmp13 + tmp0,
                                CONST_BITS+PASS1_BITS+3) & RANGE_MASK];
    outptr[DCTSIZE*4] = limit[ (int) DESCALE(tmp13 - tmp0,
                                CONST_BITS+PASS1_BITS+3) & RANGE_MASK];

    dataptr++;                  /* advance pointer to next column */
    outptr++;
  }
}
/* \\\ */

/* /// "SelectJPEGFuncs()" */
__asm void SelectJPEGFuncs(REG(a0) struct JPEGData *spec,
                           REG(d0) uchar _gray,
                           REG(d1) uchar _dither)
{
  ulong x;

  JPGData=spec;
  for (x=0; x<JJ_NUM_QUANT_TBLS; x++) jpg_quant_tables[x]=spec->quantTab[x];
  if (_gray) {
    mcu111111=MCU111111to332;
    mcu211111=MCU211111to332;
    mcu221111=MCU221111to332;
    mcu411111=MCU411111to332;
    bytes_pixel=1;
  } else if (_dither) {
    mcu111111=MCU111111to332Dith;
    mcu211111=MCU211111to332Dith;
    mcu221111=MCU221111to332Dith;
    mcu411111=MCU411111to332Dith;
    bytes_pixel=1;
  } else {
    mcu111111=MCU111111toRGB;
    mcu211111=MCU211111toRGB;
    mcu221111=MCU221111toRGB;
    mcu411111=MCU411111toRGB;
    bytes_pixel=4;
  }
}
/* \\\ */

/* /// "DecodeJPEG()" */
__asm void DecodeJPEG(REG(a0) uchar *delta,
                      REG(a1) uchar *image,
                      REG(d0) ulong myWidth,
                      REG(d1) ulong myHeight,
                      REG(d2) ulong dsize,
                      REG(a2) struct JPEGData *spec)
{
  ulong imagex = myWidth;
  ulong imagey = myHeight;
  // void *extra = dec_info->extra;
  long base_y;
  ulong jpg_type;
  ulong interleave,row_offset;

  // jpg_type = (ulong)(extra);
  jpg_type=0x00;
  // xa_mjpg_kludge = (jpg_type & 0x40)?(0x40):(0x00);
  xa_mjpg_kludge=0x00;

/* init buffer stuff */
  jpg_init_input(delta,dsize);

  base_y = 0;
  while(base_y < imagey)
  {
    jpg_saw_EOI = jpg_saw_DHT = xaFALSE;
    // hier war der ganze IJPG-Kram
    {
      /* read markers */
      jpg_saw_SOI = jpg_saw_SOF = jpg_saw_SOS = jpg_saw_DHT = jpg_saw_DQT = xaFALSE;
      if (jpg_read_markers() == xaFALSE) {
        // jpg_free_stuff();
        // kprintf("JPG: rd marker err\n");
        return;
      }
      jpg_huff_reset();

      interleave = (jpg_height <= ((imagey>>1)+1) )?(2):(1);
      row_offset = ((interleave == 2) && (base_y == 0))?(1):(0);
    }
    jpg_marker = 0x00;
    // if (jpg_width > imagex) JPG_Alloc_MCU_Bufs(0,jpg_width,0,xaFALSE);


    if ((jpg_saw_DHT != xaTRUE) && (jpg_std_DHT_flag==0))
    {
      // DEBUG_LEVEL1 kprintf("standard DHT tables\n");
      jpg_std_DHT();
    }
    // DEBUG_LEVEL1 kprintf("JJ: imagexy %d %d  jjxy %d %d basey %d\n",imagex,imagey,jpg_width,jpg_height,base_y);

    if (   (jpg_num_comps == 3) && (jpg_comps_in_scan == 3)
        && (jpg_comps[1].hvsample == 0x11) && (jpg_comps[2].hvsample== 0x11) )
    {
      if (jpg_comps[0].hvsample == 0x41) /* 411 */
        { jpg_decode_411111(image,jpg_width,jpg_height,interleave,row_offset,
                        imagex,imagey); }
      else if (jpg_comps[0].hvsample == 0x22) /* 221 */
        { jpg_decode_221111(image,jpg_width,jpg_height,interleave,row_offset,
                        imagex,imagey); }
      else if (jpg_comps[0].hvsample == 0x21) /* 211 */
        { jpg_decode_211111(image,jpg_width,jpg_height,interleave,row_offset,
                        imagex,imagey); }
      else if (jpg_comps[0].hvsample == 0x11) /* 111 */
        { jpg_decode_111111(image,jpg_width,jpg_height,interleave,row_offset,
                        imagex,imagey,0); }
      else
      { // kprintf("JPG: cmps %d %d mcu %04x %04x %04x unsupported\n",
        //         jpg_num_comps,jpg_comps_in_scan,jpg_comps[0].hvsample,
        //         jpg_comps[1].hvsample,jpg_comps[2].hvsample);
        break;
      }
    }
    else if ( (jpg_num_comps == 1) || (jpg_comps_in_scan == 1) )
    {
      jpg_decode_111111(image,jpg_width,jpg_height,interleave,row_offset,
                        imagex,imagey,1);
    }
    else
    { // kprintf("JPG: cmps %d %d mcu %04x %04x %04x unsupported.\n",
      //           jpg_num_comps,jpg_comps_in_scan,jpg_comps[0].hvsample,
      //           jpg_comps[1].hvsample,jpg_comps[2].hvsample);
      break;
    }

    base_y += ((interleave == 1)?(imagey):(jpg_height));
    if (jpg_marker == M_EOI) { jpg_saw_EOI = xaTRUE; jpg_marker = 0x00; }
    else if (jpg_saw_EOI==xaFALSE) if (jpg_read_EOI_marker() == xaFALSE) break;
  }
  return;
}
/* \\\ */

