/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_xxxpicture.h
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
 * $VER: a-mem_xxxpicture.h 1.07 (29/02/2012)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXPICTURE_H_INCLUDED___
#define ___XXXPICTURE_H_INCLUDED___

#define QDEV_MEM_PRV_NORMALMAGIC    0x4C4F474F  /* 'L' 'O' 'G' 'O'          */
#define QDEV_MEM_PRV_PACKEDMAGIC    0x4C4F434F  /* 'L' 'O' 'C' 'O'          */
#define QDEV_MEM_PRV_MINGUIGFXVER   10L
#define QDEV_MEM_PRV_HASHINGFUNC    mem_pjw64hash



struct mem_pic_data
{
  struct ColorMap         *pd_cm;         /* ColorMap pointer               */
  struct Library          *pd_ggb;        /* GuiGFXBase pointer             */
  APTR                     pd_dh;         /* Draw handle                    */
  ULONG                    pd_frames;     /* Number of frames               */
  ULONG                    pd_fdly;       /* Frame delay in micros          */
  ULONG                    pd_cdly;       /* Cycle delay in micros          */
  WORD                     pd_ptab[QDEV_MEM_RBP_PTABSIZE];
                                          /* Local pen cache                */
  WORD                     pd_htab[QDEV_MEM_RBP_PTABSIZE];
                                          /* Global pen cache               */
};

struct mem_pic_opti
{
  struct BitMap           *po_bm;         /* Bitmap address                 */
  VUQUAD                   po_hash;       /* Hash of that bitmap            */
};

#endif /* ___XXXPICTURE_H_INCLUDED___ */
