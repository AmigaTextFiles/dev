/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_xxxterm.h
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
 * $VER: a-mem_xxxterm.h 1.00 (14/09/2012)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXTERM_H_INCLUDED___
#define ___XXXTERM_H_INCLUDED___

/*
 * Virtual terminal essentials.
*/
#define QDEV_MEM_PRV_TERMID    0x5445524D  /* 'T' 'E' 'R' 'M'               */
#define QDEV_MEM_PRV_TERMMIN     4
#define QDEV_MEM_PRV_TERMTAB   256
#define QDEV_MEM_PRV_TERMEXP   256
#define QDEV_MEM_PRV_TERMFILL  0xFFF0000000000020

/*
 * SGR blocks and the expansion templates.
*/
#define QDEV_MEM_PRV_KEEP_FS   0xF000000020000000
#define QDEV_MEM_PRV_CHARMASK  0x00000000000000FF
#define QDEV_MEM_PRV_PENMASK   0xFFF0000000000000
#define QDEV_MEM_PRV_PENCLEAR  0x0FF0000000000000
#define QDEV_MEM_PRV_SGRMASK   0x00000000FFFF0000
#define QDEV_MEM_PRV_SGRFMT    "\x1B[%s%dm"
#define QDEV_MEM_PRV_SINGFMT   "\x1B%s"
#define QDEV_MEM_PRV_POSFMT    "\x1B[%d;%dH"
#define QDEV_MEM_PRV_POSRFMT   "\x1B[%d;%dR"
#define QDEV_MEM_PRV_SDSSFMT   "\x1B[ s"

/*
 * Terminal I/O control flags.
*/
#define QDEV_MEM_PRV_FNEWLINE  0x0000000000000100
#define QDEV_MEM_PRV_FNODITCH  0x0000000000000200
#define QDEV_MEM_PRV_FNOCHAR   0x0000000000000400
#define QDEV_MEM_PRV_FSGRSYNC  0x0000000000000800

/*
 * SGR mappers per terminal "byte".
*/
#define QDEV_MEM_PRV_FATBOLD   0x0000000000010000
#define QDEV_MEM_PRV_FATFAINT  0x0000000000020000
#define QDEV_MEM_PRV_FATITAL   0x0000000000040000
#define QDEV_MEM_PRV_FATUNDER  0x0000000000080000
#define QDEV_MEM_PRV_FATREV    0x0000000000100000
#define QDEV_MEM_PRV_FATCONCL  0x0000000000200000
#define QDEV_MEM_PRV_FDTBOLD   0x0000000000400000
#define QDEV_MEM_PRV_FDTITAL   0x0000000000800000
#define QDEV_MEM_PRV_FDTUNDER  0x0000000001000000
#define QDEV_MEM_PRV_FDTREV    0x0000000002000000
#define QDEV_MEM_PRV_FDTCONCL  0x0000000004000000
#define QDEV_MEM_PRV_FDTALL    0x0000000008000000
#define QDEV_MEM_PRV_FKTASDSS  0x0000000010000000
#define QDEV_MEM_PRV_FKTCLEAR  0x0000000020000000
#define QDEV_MEM_PRV_FKTSEAL   0x0000000040000000

/*
 * Flag groups, except QDEV_MEM_PRV_FDTALL!
*/
#define QDEV_MEM_PRV_FAAASGR                  \
        (QDEV_MEM_PRV_FATBOLD  |              \
         QDEV_MEM_PRV_FATFAINT |              \
         QDEV_MEM_PRV_FATITAL  |              \
         QDEV_MEM_PRV_FATUNDER |              \
         QDEV_MEM_PRV_FATREV   |              \
         QDEV_MEM_PRV_FATCONCL)
#define QDEV_MEM_PRV_FDDDSGR                  \
        (QDEV_MEM_PRV_FDTBOLD  |              \
         QDEV_MEM_PRV_FDTITAL  |              \
         QDEV_MEM_PRV_FDTUNDER |              \
         QDEV_MEM_PRV_FDTREV   |              \
         QDEV_MEM_PRV_FDTCONCL)
#define QDEV_MEM_PRV_FALLSGR                  \
        (QDEV_MEM_PRV_FAAASGR  |              \
         QDEV_MEM_PRV_FDDDSGR)

/*
 * This macro allows to set and/or clear SGR per
 * byte and in global tracker.
*/
#define QDEV_MEM_PRV_SGRTWINS(reg, clr, set)  \
({                                            \
  UQUAD *___m_reg = reg;                      \
  *___m_reg &= ~clr;                          \
  ad->ad_tsgr &= ~clr;                        \
  *___m_reg |= set;                           \
  ad->ad_tsgr |= set;                         \
})

/*
 * SGR/Rast color extractors.
*/
#define QDEV_MEM_PRV_GETRAST(reg)             \
({                                            \
  UQUAD *___m_reg2 = reg;                     \
  (*___m_reg2 >> 60);                         \
})
#define QDEV_MEM_PRV_GETBPEN(reg)             \
({                                            \
  UQUAD *___m_reg2 = reg;                     \
  ((*___m_reg2 << 4) >> 60);                  \
})
#define QDEV_MEM_PRV_GETFPEN(reg)             \
({                                            \
  UQUAD *___m_reg2 = reg;                     \
  ((*___m_reg2 << 8) >> 60);                  \
})

/*
 * SGR/Rast color savers.
*/
#define QDEV_MEM_PRV_SETRAST(reg, col)        \
({                                            \
  UQUAD *___m_reg = reg;                      \
  *___m_reg &= ~0xF000000000000000;           \
  *___m_reg |= ((UQUAD)col << 60);            \
})
#define QDEV_MEM_PRV_SETBPEN(reg, col)        \
({                                            \
  UQUAD *___m_reg = reg;                      \
  *___m_reg &= ~0x0F00000000000000;           \
  *___m_reg |= ((UQUAD)col << 56);            \
})
#define QDEV_MEM_PRV_SETFPEN(reg, col)        \
({                                            \
  UQUAD *___m_reg = reg;                      \
  *___m_reg &= ~0x00F0000000000000;           \
  *___m_reg |= ((UQUAD)col << 52);            \
})

/*
 * SGR flag expander macro.
*/
#define QDEV_MEM_PRV_FLAGEXP(r, c, d, x, e, y)\
({                                            \
  UQUAD *___m_reg = r;                        \
  if (*___m_reg & d)                          \
  {                                           \
    if (x != -1)                              \
    {                                         \
      c(NULL, x);                             \
    }                                         \
  }                                           \
  if (*___m_reg & e)                          \
  {                                           \
    if (y != -1)                              \
    {                                         \
      c(NULL, y);                             \
    }                                         \
  }                                           \
})

/*
 * Dirty flag preserving macros.
*/
#define QDEV_MEM_PRV_FLAGSAFE(flags, code)    \
({                                            \
  QDEV_MEM_PRV_BASESAFE                       \
  (                                           \
    flags,                                    \
    QDEV_MEM_PRV_BYTESAFE                     \
    (                                         \
      code                                    \
    );                                        \
  );                                          \
})

#define QDEV_MEM_PRV_BASESAFE(flags, code)    \
({                                            \
  UQUAD ___m_flags = flags;                   \
  UQUAD ___m_bits =                           \
    *((UQUAD *)ad->ad_buf) & ___m_flags;      \
  code                                        \
  *((UQUAD *)ad->ad_buf) &= ~___m_flags;      \
  *((UQUAD *)ad->ad_buf) |= ___m_bits;        \
})

#define QDEV_MEM_PRV_BYTESAFE(code)           \
({                                            \
  UQUAD ___m_bits2 =                          \
      (*dreg & ~(QDEV_MEM_PRV_CHARMASK |      \
                 QDEV_MEM_PRV_FNEWLINE |      \
                 QDEV_MEM_PRV_FNOCHAR));      \
  code                                        \
  *dreg &= ~QDEV_MEM_PRV_PENCLEAR;            \
  *dreg |= ___m_bits2;                        \
})

#define QDEV_MEM_PRV_SGRGLUE(reg)             \
({                                            \
  UQUAD *___m_reg = reg;                      \
  if (ad->ad_tsgr != QDEV_MEM_PRV_PENCLEAR)   \
  {                                           \
    *___m_reg &= ~QDEV_MEM_PRV_PENCLEAR;      \
    *___m_reg |= ad->ad_tsgr;                 \
  }                                           \
})

/*
 * Out-of-node parameter selector/detector.
*/
#define QDEV_MEM_PRV_OONPARAM(toon, num)      \
({                                            \
  (toon & (1 << num));                        \
})

/*
 * Read stream control flags.
*/
#define QDEV_MEM_PRV_FREADLF   0x00000001
#define QDEV_MEM_PRV_FREADCD   0x00000002
#define QDEV_MEM_PRV_FREADDC   0x00000004
#define QDEV_MEM_PRV_FREADON   0x00000008
#define QDEV_MEM_PRV_FREADDI   0x00000010
#define QDEV_MEM_PRV_FREADTM   0x00000020
#define QDEV_MEM_PRV_FREADCP   0x00000040
#define QDEV_MEM_PRV_FREADSK   0x00000080

/*
 * Terminal modes.
*/
#define QDEV_MEM_PRV_FMODE_SET 0x00000001
#define QDEV_MEM_PRV_FMODE_LNM 0x00000002
#define QDEV_MEM_PRV_FMODE_ASM 0x00000004
#define QDEV_MEM_PRV_FMODE_AWM 0x00000008
#define QDEV_MEM_PRV_FMODE_G1  0x00000010



/*
 * Innocent compatibility kludge...
*/
#ifndef _STRING_H_
#define _STRING_H_
typedef LONG size_t;
void  *memmove (void *, const void *, size_t);
#endif



struct mem_act_data
{
  LONG    ad_id;                 /* Terminal identification value           */
  LONG    ad_cols;               /* Max amount of cols this term. offers    */
  LONG    ad_rows;               /* Max amount of rows this term. offers    */
  LONG    ad_xpos;               /* Current cursor position(column)         */
  LONG    ad_ypos;               /* Current cursor position(row)            */
  LONG    ad_size;               /* Real size of the 'ad_buf' term. area    */
  LONG    ad_bytes;              /* Bytefied size of the terminal area      */
  LONG    ad_tval;               /* Sequence parameter value holder(temp.)  */
  LONG    ad_tlen;               /* Number of params available in 'ad_tab'  */
  LONG    ad_toon;               /* Bitfield of parameteres out of node     */
  LONG    ad_tooc;               /* Last state of out of node parameters    */
  LONG    ad_mode;               /* Terminal behaviour flags(modes)         */
  UQUAD   ad_fill;               /* Terminal fill pattern(default char)     */
  UQUAD   ad_tsgr;               /* Global terminal SGR flagset tracker     */
  UQUAD   ad_tact;               /* Global terminal SGR that is active      */
  UQUAD  *ad_treg;               /* Terminal tracking register(last byte)   */
  UBYTE  *ad_ereg;               /* Sequence expansion pointer(curr. char)  */
  UBYTE  *ad_eend;               /* Sequence expansion end pointer          */
  void *(*ad_mmfp)(void *, const void *, size_t);
                                 /* 'memmove()' or the like function ptr    */
  void  (*ad_clrfp)(void *, LONG, LONG);
                                 /* Clear terminal fp(ad, start, end);      */
  void  (*ad_scrfp)(void *, LONG);
                                 /* Scroll terminal fp(ad, [-]lines);       */
  void  (*ad_oplfp)(void *, LONG);
                                 /* Ins/del term. lines fp(ad, [-]lines);   */
  void  (*ad_opcfp)(void *, LONG);
                                 /* Ins/del term. chars fp(ad, [-]chars);   */
  void  (*ad_ucbfp)(void *, UQUAD *);
                                 /* CB called upon ASCII character write    */
  void  (*ad_uokfp)(void *, LONG);
                                 /* CB called after each finished write     */
  void   *ad_udata;              /* General purpose userdata pointer        */
  LONG    ad_tab[QDEV_MEM_PRV_TERMTAB];
                                 /* Sequence param. table(left to right)    */
  UBYTE   ad_exp[QDEV_MEM_PRV_TERMEXP];
                                 /* Sequence expansion buffer when reading  */
  UBYTE   ad_buf[QDEV_MEM_PRV_TERMMIN];
                                 /* Terminal area of 'ad_size' + 4          */

  /*
   * No new members allowed at this point, since 'ad_buf' implicitly
   * defines more than QDEV_MEM_PRV_TERMMIN!
  */
};

#endif /* ___XXXTERM_H_INCLUDED___ */
