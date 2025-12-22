/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_xxxsrcimage.h
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
 * $VER: p-mem_xxxsrcimage.h 1.00 (16/01/2013)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXSRCIMAGE_H_INCLUDED___
#define ___XXXSRCIMAGE_H_INCLUDED___

#define QDEV_PRV_PRL_S_TRIG   0x00000001   /* Symbol indicator toggle       */

#define QDEV_PRV_PRL_T_SYMB   0x00000000   /* Object is symbol              */
#define QDEV_PRV_PRL_T_SIZE   0x00000001   /* Object is size of table       */
#define QDEV_PRV_PRL_T_ELEM   0x00000002   /* Object is table element       */

#define QDEV_PRV_PRL_H_UWORD  0xF5724F8B   /* 'UWORD'                       */
#define QDEV_PRV_PRL_H_ULONG  0x50D81BE3   /* 'ULONG'                       */
#define QDEV_PRV_PRL_H_CHIP   0xDB6DFC8A   /* 'chip'                        */
#define QDEV_PRV_PRL_H_STRUCT 0x9300A38B   /* 'struct'                      */
#define QDEV_PRV_PRL_H_IMAGE  0x397031EB   /* 'Image'                       */
#define QDEV_PRV_PRL_H_NULL   0x48391EDF   /* 'NULL'                        */

#define QDEV_PRV_PRL_L_UWORD  sizeof(UWORD)
#define QDEV_PRV_PRL_L_ULONG  sizeof(ULONG)
#define QDEV_PRV_PRL_L_IMAGE  sizeof(struct Image)

#define QDEV_PRV_PRL_M_RGB4   QDEV_PRV_PRL_L_IMAGE
#define QDEV_PRV_PRL_M_RGB32  (QDEV_PRV_PRL_L_IMAGE + QDEV_PRV_PRL_L_ULONG)

#define QDEV_PRV_PRL_E_MEM    -2           /* ERROR: No memory avail        */
#define QDEV_PRV_PRL_E_STOR    1           /* ERROR: No storage size        */
#define QDEV_PRV_PRL_E_TABL    2           /* ERROR: Excess element         */
#define QDEV_PRV_PRL_E_ELEM    3           /* ERROR: Unknown element        */
#define QDEV_PRV_PRL_E_UNK     4           /* ERROR: Unknown method         */
#define QDEV_PRV_PRL_E_BAL     5           /* ERROR: Unbalanced code        */

#define QDEV_PRV_PRL_SYMLEN   32           /* Symbol name length            */
#define QDEV_PRV_PRL_MINLEN    4           /* Dummy table area size         */
#define QDEV_PRV_PRL_MAXTAB   33554432     /* Maximum size of table         */
#define QDEV_PRV_PRL_IMSYM     5           /* Image symbol reference        */



struct mem_prl_feed
{
  struct List  pf_tab;                /* List of tables(palettes)           */
  struct List  pf_im;                 /* List of Images(structures)         */
  UBYTE       *pf_ptr;                /* Parser: object pointer             */
  UBYTE       *pf_end;                /* Parser: object terminator          */
  LONG         pf_type;               /* Parser: type of object             */
  LONG         pf_bal;                /* Parser: balance of braces          */
  ULONG        pf_size;               /* Object: width of tab. elem         */
  void        *pf_node;               /* Object: last object addr           */
  ULONG        pf_hash;               /* Object: last symbol hash           */
  UBYTE        pf_name[(QDEV_PRV_PRL_SYMLEN + 1)];
                                      /* Object: last symbol name           */
};

struct mem_prl_tab
{
  struct Node  pt_node;               /* Table node for linking             */
  LONG         pt_len;                /* Size of the table (bytes)          */
  ULONG        pt_hash;               /* Hash of this table symbol          */
  UBYTE        pt_name[((QDEV_PRV_PRL_SYMLEN + 4) & ~3)];
                                      /* Name of this table symbol          */
  UBYTE        pt_tab[QDEV_PRV_PRL_MINLEN];
                                      /* Table area(implicit area)          */

  /*
   * No new members at this point possible due to area being allocated
   * implicitly!
  */
};

#endif /* ___XXXSRCIMAGE_H_INCLUDED___ */
