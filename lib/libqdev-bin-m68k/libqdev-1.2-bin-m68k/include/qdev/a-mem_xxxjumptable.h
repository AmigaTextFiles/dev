/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_xxxjumptable.h
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
 * $VER: a-mem_xxxjumptable.h 1.00 (12/09/2014)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXJUMPTABLE_H_INCLUDED___
#define ___XXXJUMPTABLE_H_INCLUDED___

#define QDEV_PRV_LBS_JMPINST    0x4EF9 /* Direct pointer JMP instruction    */
#define QDEV_PRV_LBS_JSRINST    0x4EB9 /* Direct pointer JSR instruction    */
#define QDEV_PRV_LBS_RESERVED   4      /* Count of reserved slots           */
#define QDEV_PRV_LBS_NAMELEN    64     /* lib_Node.ln_Name capacity         */

#define QDEV_PRV_LBS_JTCALL_R_G 0x0001 /* Relative call using global base   */
#define QDEV_PRV_LBS_JTCALL_A_G 0x0002 /* Absolute call using global base   */
#define QDEV_PRV_LBS_JTCALL_R_I 0x0003 /* Relative call using inline base   */
#define QDEV_PRV_LBS_JTCALL_A_I 0x0004 /* Absolute call using inline base   */

#define QDEV_PRV_LBS_SLOT2OFF(slot) (slot * sizeof(struct qdev_lbs_slot))
#define QDEV_PRV_LBS_OFF2SLOT(off)  (off / sizeof(struct qdev_lbs_slot))

#define QDEV_PRV_LBS_BASESLOTS(base)          \
QDEV_PRV_LBS_OFF2SLOT(                        \
       ((struct Library *)base)->lib_NegSize)

#define QDEV_PRV_LBS_ISLOCALVECT(jtab)        \
((*(struct Library **)jtab)->lib_Node.ln_Type \
                     == ___QLBS_NT_LOCALVECT)

#define QDEV_PRV_LBS_SETVECTNAME(jtab, name)  \
({                                            \
  struct Library *___m_lib =                  \
                  *((struct Library **)jtab); \
  *___m_lib->lib_Node.ln_Name = '\0';         \
  txt_strncat(___m_lib->lib_Node.ln_Name,     \
                 name, QDEV_PRV_LBS_NAMELEN); \
})

#define QDEV_PRV_LBS_SETMAINBASE(jtab, base)  \
({                                            \
  struct Library *___m_lib =                  \
                  *((struct Library **)jtab); \
  void *___m_base =                           \
                  ___m_lib->lib_Node.ln_Succ; \
  if (base)                                   \
  {                                           \
    ___m_lib->lib_Node.ln_Succ =              \
                         (struct Node *)base; \
  }                                           \
  ___m_base;                                  \
})

#define QDEV_PRV_LBS_GETCALLTYPE(jtab, slot)  \
({                                            \
  struct Library *___m_lib =                  \
                  *((struct Library **)jtab); \
  struct qdev_lbs_jent *___m_lj =             \
   (struct qdev_lbs_jent *)___m_lib->lib_Sum; \
  ___m_lj -= slot;                            \
  ___m_lj = (struct qdev_lbs_jent *)          \
           (LONG)___m_lj->lj_u.lj_relg.lj_id; \
  (LONG)___m_lj;                              \
})



struct qdev_lbs_slot
{
  UWORD ls_inst;                       /* m68k op code (JMP/JSR)            */
  ULONG ls_addr;                       /* Direct routine pointer            */ 
};

struct qdev_lbs_jent
{
  union
  {
    /*
     * Relative-global call entry.
    */
    struct
    {
      UWORD lj_w1;
      UWORD lj_w2;
      UWORD lj_w3;
      UWORD lj_off;
      UWORD lj_w5;
      UWORD lj_w6;
      UWORD lj_w7;
      UWORD lj_w8;
      UWORD lj_id;                     /* QDEV_PRV_LBS_JTCALL_R_G           */
      ULONG lj_l1;
    } lj_relg;

    /*
     * Absolute-global call entry.
    */
    struct
    {
      UWORD lj_w1;
      UWORD lj_w2;
      UWORD lj_w3;
      ULONG lj_fp;
      UWORD lj_w6;
      UWORD lj_w7;
      UWORD lj_w8;
      UWORD lj_id;                     /* QDEV_PRV_LBS_JTCALL_A_G           */
      ULONG lj_l1;
    } lj_absg;

    /*
     * Relative-inline call entry.
    */
    struct
    {
      UWORD lj_w1;
      UWORD lj_w2;
      UWORD lj_w3;
      UWORD lj_w4;
      UWORD lj_off;
      UWORD lj_w6;
      UWORD lj_w7;
      UWORD lj_w8;
      UWORD lj_id;                     /* QDEV_PRV_LBS_JTCALL_R_I           */
      ULONG lj_ud;
    } lj_reli;

    /*
     * Absolute-inline call entry.
    */
    struct
    {
      UWORD lj_w1;
      UWORD lj_w2;
      UWORD lj_w3;
      UWORD lj_w4;
      ULONG lj_fp;
      UWORD lj_w7;
      UWORD lj_w8;
      UWORD lj_id;                     /* QDEV_PRV_LBS_JTCALL_A_I           */
      ULONG lj_ud;
    } lj_absi;
  } lj_u;
};

#endif /* ___XXXJUMPTABLE_H_INCLUDED___ */
