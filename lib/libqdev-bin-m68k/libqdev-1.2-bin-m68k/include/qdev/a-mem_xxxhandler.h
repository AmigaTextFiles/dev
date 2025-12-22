/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_xxxhandler.h
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
 * $VER: a-mem_xxxhandler.h 1.06 (15/08/2014)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXHANDLER_H_INCLUDED___
#define ___XXXHANDLER_H_INCLUDED___

#define QDEV_MEM_PRV_STATUSID 0x51444556       /* 'Q' 'D' 'E' 'V'           */
#define QDEV_MEM_PRV_MAXINDEX 32               /* Total slots available     */

#define QDEV_MEM_PRV_FFREESIG 0x00000001       /* Signal will be freed      */
#define QDEV_MEM_PRV_FSLOTUSE 0x00000002       /* Slot already in use       */
#define QDEV_MEM_PRV_FNATCODE 0x00000004       /* Native handler called     */
#define QDEV_MEM_PRV_FEXTINIT 0x00000008       /* Slot managed remotely     */
#define QDEV_MEM_PRV_FKEEPSIG 0x00000010       /* Signal not removable      */

#define QDEV_MEM_PRV_LEXTINIT 1                /* Level 1, initialize       */
#define QDEV_MEM_PRV_LEXTKILL 0                /* Level 0, deinitialize     */

#define QDEV_MEM_PRV_SLOTPTR(tc, sigbit)      \
(((tc)->tc_ExceptData &&                      \
  ((struct mem_exr_glob *)(tc)->tc_ExceptData)\
->eg_status == QDEV_MEM_PRV_STATUSID) ?       \
 &((struct mem_exr_glob *)(tc)->tc_ExceptData)\
->eg_ei[sigbit] : NULL)



struct mem_exr_rman
{
  LONG              *er_entflags;   /* Pointer to slot flags                */
  LONG              *er_reserved;   /* Reserved for later                   */
  LONG             (*er_remote)(LONG, void *, void *, void *);
                                    /* Remote setup/cleanup                 */
};

struct mem_exr_ient
{
  LONG               ei_entflags;   /* Flags of this entry                  */
  ULONG            (*ei_usercode)   /* User exception code                  */
              (REGARG(ULONG, d0),
             REGARG(void *, a1));
  APTR              *ei_userdata;   /* User exception data                  */  
};

struct mem_exr_glob
{
  ULONG                eg_status;   /* Status of this structure             */
  ULONG                eg_count;    /* Number of handler entries            */
  struct mem_exr_ient  eg_ei[(QDEV_MEM_PRV_MAXINDEX + 1)];
                                    /* Handler slots plus one               */
};

#endif /* ___XXXHANDLER_H_INCLUDED___ */
