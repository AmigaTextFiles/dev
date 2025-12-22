/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_grabqarea.h
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
 * $VER: a-mem_grabqarea.c 1.00 (12/08/2012)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___GRABQAREA_H_INCLUDED___
#define ___GRABQAREA_H_INCLUDED___

#define QDEV_MEM_PRV_ABSOLUTELEN   512  /* Real qarea length                */
#define QDEV_MEM_PRV_TOTALQSLOTS    16  /* Number of qslots                 */



struct qarea
{
  struct SignalSemaphore  qa_dst;       /* mem_dosynctask() priv. semaphore */
  struct List             qa_ulist;     /* Users may link their stuff here  */
  LONG                   *qa_slot[QDEV_MEM_PRV_TOTALQSLOTS];
                                        /* Quick slots, this is reserved    */
};

#endif /* ___GRABQAREA_H_INCLUDED___ */
