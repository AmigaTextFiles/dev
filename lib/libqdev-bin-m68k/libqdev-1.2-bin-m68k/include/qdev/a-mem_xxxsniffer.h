/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_xxxsniffer.h
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
 * $VER: a-mem_xxxsniffer.h 1.01 (15/08/2014)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXSNIFFER_H_INCLUDED___
#define ___XXXSNIFFER_H_INCLUDED___

struct mem_sni_ient
{
  struct Node          si_node;     /* Link list header                     */
  struct mem_sni_glob *si_sg;       /* Back pointer to globals              */
  LONG                 si_entflags; /* Flags of this entry                  */
  ULONG              (*si_usercode) /* User sniffer code                    */
               (REGARG(ULONG, d0),
              REGARG(void *, a1));
  APTR                *si_userdata; /* User sniffer data                    */
};

struct mem_sni_glob
{
  ULONG                sg_status;   /* Status of this structure             */
  ULONG                sg_count;    /* Number of handler entries            */
  LONG                 sg_sigbit;   /* Preallocated signal/slot             */
  struct Task         *sg_tc;       /* Patched task address                 */
  struct List          sg_list;     /* List of active sniffers              */
  struct mem_exr_rman *sg_er;       /* Remote management pointer            */
  struct mem_sni_ient  sg_natsi;    /* Native handler (wrapped)             */
};

#endif /* ___XXXSNIFFER_H_INCLUDED___ */
