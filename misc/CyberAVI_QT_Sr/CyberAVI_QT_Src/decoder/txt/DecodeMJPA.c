/*
sc:c/sc opt txt/DecodeMJPA.c
*/

#include "Decode.h"
#include "YUV.h"
#include "Utils.h"
#include "GlobalVars.h"
#include "JPEG.h"

/* /// "define's und Variablen" */
extern ulong bytes_pixel;

extern long xa_dither_flag;

extern uchar  *jpg_buff;
extern long  jpg_bsize;

extern long   jpg_h_bnum;
extern ulong  jpg_h_bbuf;

extern long   *jpg_quant_tables[JJ_NUM_QUANT_TBLS];
extern ulong  jpg_marker;
extern ulong  jpg_saw_SOI,jpg_saw_SOF,jpg_saw_SOS;
extern ulong  jpg_saw_DHT,jpg_saw_DQT,jpg_saw_EOI;
extern ulong  jpg_std_DHT_flag;
extern long   jpg_dprec,jpg_height,jpg_width;
extern long   jpg_num_comps,jpg_comps_in_scan;
extern long   jpg_nxt_rst_num;
extern long   jpg_rst_interval;

extern ulong xa_mjpg_kludge;

extern JJ_HUFF_TBL jpg_ac_huff[JJ_NUM_HUFF_TBLS];
extern JJ_HUFF_TBL jpg_dc_huff[JJ_NUM_HUFF_TBLS];

extern COMPONENT_HDR jpg_comps[JPG_MAX_COMPS + 1];

extern long JJ_ZAG[DCTSIZE2+16];

extern ulong jpg_MCUbuf_size;
extern uchar *jpg_Ybuf;
extern uchar *jpg_Ubuf;
extern uchar *jpg_Vbuf;
extern short jpg_dct_buf[DCTSIZE2];
/* \\\ */

struct MJPAData {
  long *quantTab[JJ_NUM_QUANT_TBLS];
};

/* /// "proto-types" */
void __regargs (*mjpamcu211111) (uchar *to, ulong width, ulong height, ulong rowSize, ulong ipSize);
ulong mjpa_decode_211111(uchar *image, ulong width, ulong height, ulong interleave, ulong row_offset, ulong imagex, ulong imagey);
extern void jpg_huff_build(JJ_HUFF_TBL *htbl, uchar *hbits, uchar *hvals);
extern ulong jpg_huffparse(register COMPONENT_HDR *comp, register short *dct_buf, ulong *qtab, uchar *OBuf);
extern void j_rev_dct (short *data, uchar *outptr, uchar *rnglimit);
extern void JPG_Setup_Samp_Limit_Table();
extern void JPG_Free_Samp_Limit_Table();
extern ulong jpg_std_DHT(void);
extern ulong jpg_search_marker(ulong marker, uchar **data_ptr, long *data_size);
extern ulong jpg_read_SOI(void);
extern ulong jpg_read_SOF(void);
extern ulong jpg_read_SOS(void);
extern ulong jpg_read_DQT(void);
extern ulong jpg_read_DRI(void);
extern ulong jpg_read_DHT(void);
extern ulong jpg_skip_marker(void);
extern ulong jpg_get_marker(void);
extern ulong jpg_read_markers(void);
extern ulong jpg_read_EOI_marker(void);
extern ulong jpg_read_RST_marker(void);
extern void jpg_init_input(uchar *buff, long buff_size);
extern void jpg_huff_reset(void);
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

/* /// "defines" */
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

/* /// "mjpaMCU211111toRGB()" */
void __regargs mjpaMCU211111toRGB(uchar *to,
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
  ulong oipSize=ipSize;
  ipSize<<=1;

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
        ulong u0=*up++;
        ulong v0=*vp++;
        long cr=vrTab[v0];
        long cg=vgTab[v0]+ugTab[u0];
        long cb=ubTab[u0];
        iDecYUVRGB(ip,*yp++,cr,cg,cb);
        iDecYUVRGB(ip,*yp++,cr,cg,cb);
        mcu2hInnerTail(56,56);
      }
      yptr+=8;
      uptr+=8;
      vptr+=8;
      height--;
      mycopymem((ulong *)iptr,(ulong *)(iptr+oipSize),oipSize);
      iptr+=ipSize;
    }
    yBuf+=rowSize<<1;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "mjpaMCU211111to332()" */
void __regargs mjpaMCU211111to332(uchar *to,
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
  ulong oipSize=ipSize;
  ipSize<<=1;

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
      mycopymem((ulong *)iptr,(ulong *)(iptr+oipSize),oipSize);
      iptr+=ipSize;
    }
    yBuf+=rowSize<<1;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "mjpaMCU211111to332Dith()" */
void __regargs mjpaMCU211111to332Dith(uchar *to,
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
  ulong oipSize=ipSize;
  ipSize<<=1;

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
      mycopymem((ulong *)iptr,(ulong *)(iptr+oipSize),oipSize);
      iptr+=ipSize;
    }
    yBuf+=rowSize<<1;
    uBuf+=rowSize;
    vBuf+=rowSize;
  }
}
/* \\\ */

/* /// "mjpa_decode_211111()" */
ulong mjpa_decode_211111(uchar *image, ulong width, ulong height, ulong interleave, ulong row_offset, ulong imagex, ulong imagey)
{
  uchar *iptr = image;
  ulong x,mcu_cols,mcu_rows;
  ulong *qtab0,*qtab1,*qtab2;
  uchar *Ybuf,*Ubuf,*Vbuf;
  ulong rst_count;
  ulong orow_size = imagex * bytes_pixel;

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
    mjpamcu211111(iptr,imagex,xaMIN(imagey,8),(mcu_cols * DCTSIZE2), orow_size);
    // imagey -= 8;  iptr += (orow_size << 3);
    imagey -= 8;  iptr += (orow_size << 4);

  } /* end of mcu_rows */
  if (jpg_marker) { jpg_h_bbuf = 0; jpg_h_bnum = 0; }
  return(xaTRUE);
}
/* \\\ */

/* /// "SelectMJPAFuncs()" */
__asm void SelectMJPAFuncs(REG(a0) struct MJPAData *spec,
                           REG(d0) uchar _gray,
                           REG(d1) uchar _dither)
{
  ulong x;

  for (x=0; x<JJ_NUM_QUANT_TBLS; x++) jpg_quant_tables[x]=spec->quantTab[x];
  if (_gray) {
    bytes_pixel=1;
    mjpamcu211111=mjpaMCU211111to332;
  } else if (_dither) {
    bytes_pixel=1;
    mjpamcu211111=mjpaMCU211111to332Dith;
  } else {
    bytes_pixel=4;
    mjpamcu211111=mjpaMCU211111toRGB;
  }
}
/* \\\ */

/* /// "DecodeMJPA()" */
__asm void DecodeMJPA(REG(a0) uchar *delta,
                      REG(a1) uchar *image,
                      REG(d0) ulong myWidth,
                      REG(d1) ulong myHeight,
                      REG(d2) ulong dsize,
                      REG(a2) struct MJPAData *spec)
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
      if (jpg_comps[0].hvsample == 0x21) /* 211 */
        { mjpa_decode_211111(image,jpg_width,jpg_height,interleave,row_offset,
                        imagex,imagey); }
      else
      { // kprintf("JPG: cmps %d %d mcu %04x %04x %04x unsupported\n",
        //         jpg_num_comps,jpg_comps_in_scan,jpg_comps[0].hvsample,
        //         jpg_comps[1].hvsample,jpg_comps[2].hvsample);
        break;
      }
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

