/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_xxxpooled.h
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
 * $VER: a-mem_xxxpooled.h 1.05 (27/12/2010)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXPOOLED_H_INCLUDED___
#define ___XXXPOOLED_H_INCLUDED___

#define QDEV_MEM_PRV_DEFPCHIPSIZE 1024
#define QDEV_MEM_PRV_DEFTCHIPSIZE QDEV_MEM_PRV_DEFPCHIPSIZE
#define QDEV_MEM_PRV_DEFPFASTSIZE 16384
#define QDEV_MEM_PRV_DEFTFASTSIZE QDEV_MEM_PRV_DEFPFASTSIZE



struct qdev_mem_pool
{
  struct SignalSemaphore mp_sem;       /* Semaphore protection              */
  LONG                   mp_init;      /* This will latch params            */
  void                  *mp_pool;      /* Address of the memory pool        */
  LONG                   mp_pudsize;   /* Puddle size                       */
  LONG                   mp_tressize;  /* Treshold                          */
  ULONG                  mp_allocs;    /* How many allocs so far            */
  ULONG                  mp_total;     /* Total number of bytes allocated   */
  ULONG                  mp_oflags;    /* Copy of memory flags              */
};

#endif /* ___XXXPOOLED_H_INCLUDED___ */
