/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_remapbitmap2.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * Following  contents covered by the  BSIPM  license not to be used in
 * commercial products nor redistributed separately nor modified by the
 * 3-rd parties other than mentioned in the license and under the terms
 * prior to recipient status.
 *
 * A  copy  of  the  BSIPM  document  and/or  source  code  along  with
 * commented modifications and/or separate changelog should be included
 * in this archive.
 *
 * NO WARRANTY OF ANY KIND APPLIES. ALL THE RISK AS TO THE QUALITY  AND
 * PERFORMANCE  OF  THIS  SOFTWARE  IS  WITH  YOU. SEE THE 'BLACK SALLY
 * IMITABLE PACKAGE MARK' DOCUMENT FOR MORE DETAILS.
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: a-mem_remapbitmap2.h 1.00 (22/01/2012)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___REMAPBITMAP2_H_INCLUDED___
#define ___REMAPBITMAP2_H_INCLUDED___

#define QDEV_MEM_PRV_PIXELREMAP(rgb32, cm,    \
                                 tab, pixel)  \
({                                            \
  REGISTER ULONG *___m_rgb;                   \
  if (tab[pixel] == -1)                       \
  {                                           \
    ___m_rgb = &rgb32[pixel * 3];             \
    tab[pixel] = (WORD)ObtainBestPen(cm,      \
      ___m_rgb[0], ___m_rgb[1], ___m_rgb[2],  \
                                  TAG_DONE);  \
  }                                           \
  tab[pixel];                                 \
})

#define QDEV_MEM_PRV_8PIX_REMAP(rgb32, cm,    \
                      tab, pix4_hi, pix4_lo)  \
({                                            \
  REGISTER ULONG ___m_inpix;                  \
  ___m_inpix = (pix4_hi >> 24);               \
  pix4_hi &= ~0xFF000000;                     \
  pix4_hi |= QDEV_MEM_PRV_PIXELREMAP(rgb32,   \
                 cm, tab, ___m_inpix) << 24;  \
  ___m_inpix = (pix4_hi >> 16) & 0x000000FF;  \
  pix4_hi &= ~0x00FF0000;                     \
  pix4_hi |= QDEV_MEM_PRV_PIXELREMAP(rgb32,   \
                 cm, tab, ___m_inpix) << 16;  \
  ___m_inpix = (pix4_hi >>  8) & 0x000000FF;  \
  pix4_hi &= ~0x0000FF00;                     \
  pix4_hi |= QDEV_MEM_PRV_PIXELREMAP(rgb32,   \
                 cm, tab, ___m_inpix) <<  8;  \
  ___m_inpix = (pix4_hi      ) & 0x000000FF;  \
  pix4_hi &= ~0x000000FF;                     \
  pix4_hi |= QDEV_MEM_PRV_PIXELREMAP(rgb32,   \
                 cm, tab, ___m_inpix);        \
  ___m_inpix = (pix4_lo >> 24);               \
  pix4_lo &= ~0xFF000000;                     \
  pix4_lo |= QDEV_MEM_PRV_PIXELREMAP(rgb32,   \
                 cm, tab, ___m_inpix) << 24;  \
  ___m_inpix = (pix4_lo >> 16) & 0x000000FF;  \
  pix4_lo &= ~0x00FF0000;                     \
  pix4_lo |= QDEV_MEM_PRV_PIXELREMAP(rgb32,   \
                 cm, tab, ___m_inpix) << 16;  \
  ___m_inpix = (pix4_lo >>  8) & 0x000000FF;  \
  pix4_lo &= ~0x0000FF00;                     \
  pix4_lo |= QDEV_MEM_PRV_PIXELREMAP(rgb32,   \
                 cm, tab, ___m_inpix) <<  8;  \
  ___m_inpix = (pix4_lo      ) & 0x000000FF;  \
  pix4_lo &= ~0x000000FF;                     \
  pix4_lo |= QDEV_MEM_PRV_PIXELREMAP(rgb32,   \
                 cm, tab, ___m_inpix);        \
})

#define QDEV_MEM_PRV_8PIX_P2C(planes, depth,  \
                   raspos, pix4_hi, pix4_lo)  \
({                                            \
  REGISTER UBYTE **___m_plane = planes;       \
  REGISTER ULONG ___m_planeno = depth;        \
  REGISTER ULONG ___m_ras8;                   \
  ___m_plane += ___m_planeno;                 \
  while (___m_planeno--)                      \
  {                                           \
    if (*--___m_plane)                        \
    {                                         \
      ___m_ras8 = (*(UBYTE *)(                \
         (LONG)*___m_plane + (LONG)raspos));  \
      pix4_hi |= ((___m_ras8 & 0x80)          \
                     << ___m_planeno) << 17;  \
      pix4_hi |= ((___m_ras8 & 0x40)          \
                     << ___m_planeno) << 10;  \
      pix4_hi |= ((___m_ras8 & 0x20)          \
                     << ___m_planeno) <<  3;  \
      pix4_hi |= ((___m_ras8 & 0x10)          \
                     << ___m_planeno) >>  4;  \
      pix4_lo |= ((___m_ras8 & 0x08)          \
                     << ___m_planeno) << 21;  \
      pix4_lo |= ((___m_ras8 & 0x04)          \
                     << ___m_planeno) << 14;  \
      pix4_lo |= ((___m_ras8 & 0x02)          \
                     << ___m_planeno) <<  7;  \
      pix4_lo |= ((___m_ras8 & 0x01)          \
                     << ___m_planeno);        \
    }                                         \
  }                                           \
})

#define QDEV_MEM_PRV_8PIX_C2P(planes, depth,  \
                   raspos, pix4_hi, pix4_lo)  \
({                                            \
  REGISTER UBYTE **___m_plane = planes;       \
  REGISTER ULONG ___m_planeno = depth;        \
  REGISTER ULONG ___m_ras8;                   \
  REGISTER ULONG ___m_bitpos;                 \
  ___m_plane += ___m_planeno;                 \
  while (___m_planeno--)                      \
  {                                           \
    if (*--___m_plane)                        \
    {                                         \
      ___m_bitpos = (1L << ___m_planeno);     \
      ___m_ras8 = 0;                          \
      ___m_ras8 |= ((pix4_hi & (___m_bitpos   \
             << 24)) >> 17) >> ___m_planeno;  \
      ___m_ras8 |= ((pix4_hi & (___m_bitpos   \
             << 16)) >> 10) >> ___m_planeno;  \
      ___m_ras8 |= ((pix4_hi & (___m_bitpos   \
             <<  8)) >>  3) >> ___m_planeno;  \
      ___m_ras8 |= ((pix4_hi & (___m_bitpos   \
                  )) <<  4) >> ___m_planeno;  \
      ___m_ras8 |= ((pix4_lo & (___m_bitpos   \
             << 24)) >> 21) >> ___m_planeno;  \
      ___m_ras8 |= ((pix4_lo & (___m_bitpos   \
             << 16)) >> 14) >> ___m_planeno;  \
      ___m_ras8 |= ((pix4_lo & (___m_bitpos   \
             <<  8)) >>  7) >> ___m_planeno;  \
      ___m_ras8 |= ((pix4_lo & (___m_bitpos   \
                  ))      ) >> ___m_planeno;  \
      (*(UBYTE *)((LONG)*___m_plane +         \
                (LONG)raspos)) =  ___m_ras8;  \
    }                                         \
  }                                           \
})

#endif /* ___REMAPBITMAP2_H_INCLUDED___ */
