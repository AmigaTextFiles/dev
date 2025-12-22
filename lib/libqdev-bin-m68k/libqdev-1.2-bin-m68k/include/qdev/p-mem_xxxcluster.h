/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_xxxcluster.h
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
 * $VER: p-mem_xxxcluster.h 1.02 (12/09/2011)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXCLUSTER_H_INCLUDED___
#define ___XXXCLUSTER_H_INCLUDED___

#define QDEV_MEM_PRV_MINSPCLEN 4



struct mem_clr_head
{
  struct mem_clr_head    *ch_next;       /* Ptr to next cluster             */
  struct SignalSemaphore  ch_sem;        /* Semaphore protection            */
  ULONG                   ch_size;       /* Size of one chunk               */
  ULONG                   ch_chunks;     /* Number of chunks                */
  ULONG                   ch_flags;      /* Memory alloc. flags             */
  ULONG                   ch_total;      /* Cluster size                    */
  ULONG                   ch_list;       /* Free chunk list                 */
  UBYTE                   ch_space[QDEV_MEM_PRV_MINSPCLEN];
                                         /* Cluster buffer                  */

  /* 
   * No new members allowed at this point, because 'ch_space' will
   * be larger than that minimum!!!
  */
};

#endif /* ___XXXCLUSTER_H_INCLUDED___ */
