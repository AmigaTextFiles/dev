/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_xxxhotvec.h
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
 * $VER: a-mem_xxxhotvec.h 1.02 (18/08/2014)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXHOTVEC_H_INCLUDED___
#define ___XXXHOTVEC_H_INCLUDED___

#define QDEV_PRV_MEM_HOT_NAME   "hotvec"
#define QDEV_PRV_MEM_HOT_NLEN      8
#define QDEV_PRV_MEM_HOT_MIN       4
#define QDEV_PRV_MEM_HOT_PRI    -111
#define QDEV_PRV_MEM_HOT_TYPE   NT_USER
#define QDEV_PRV_MEM_HOT_RSVL   0x003FFFFFUL /* Priv. id values to this val */
#define QDEV_PRV_MEM_HOT_RSVH   0x7FFFFFFFUL /* Dyn. id val. after this val */
#define QDEV_PRV_MEM_HOT_SKIP     16

#define QDEV_PRV_MEM_HOT_PTR(hot)             \
({                                            \
  ((struct mem_hot_root *)((struct MemList *) \
  hot)->ml_ME[0].me_Addr)->hr_vec;            \
})



struct mem_hot_root
{
  ULONG   hr_id;                           /* ID value of this hot vector   */
  ULONG   hr_hh;                           /* Additional hash of this root  */
  ULONG   hr_ent;                          /* Num. of vectors in this array */
  UBYTE   hr_name[QDEV_PRV_MEM_HOT_NLEN];  /* Hot name buf(ml_Node.ln_Name) */
  LONG  **hr_vec;                          /* Hot vector array pointer      */
};

#endif /* ___XXXHOTVEC_H_INCLUDED___ */
