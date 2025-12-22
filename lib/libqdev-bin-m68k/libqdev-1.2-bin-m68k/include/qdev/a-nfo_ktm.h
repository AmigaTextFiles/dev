/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * nfo_ktm.h
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
 * $VER: a-nfo_ktm.h 1.07 (04/06/2011)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___KTM_H_INCLUDED___
#define ___KTM_H_INCLUDED___

#define QDEV_NFO_PRV_MAXCLINUM  4096
#define QDEV_NFO_PRV_MINCHUNKS    16

/*
 * I can see your face now ;-) , well i wanted space to be well
 * declared lol.
*/
#define QDEV_NFO_PRV_NAMESIZE    256
#define QDEV_NFO_PRV_EXTRASIZE     1
#define QDEV_NFO_PRV_ADDRSIZE      9
#define QDEV_NFO_PRV_TYPESIZE      7
#define QDEV_NFO_PRV_PRIOSIZE      4
#define QDEV_NFO_PRV_CLISIZE       4
#define QDEV_NFO_PRV_STATESIZE    12
#define QDEV_NFO_PRV_STACKSIZE     7
#define QDEV_NFO_PRV_WHOLESIZE    \
        (QDEV_NFO_PRV_NAMESIZE  + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_NAMESIZE  + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_EXTRASIZE)
#define QDEV_NFO_PRV_PARAMSIZE    \
        (QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_ADDRSIZE  + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_TYPESIZE  + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_PRIOSIZE  + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_CLISIZE   + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_STATESIZE + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_ADDRSIZE  + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_STACKSIZE + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_EXTRASIZE + \
         QDEV_NFO_PRV_EXTRASIZE)
#define QDEV_NFO_PRV_TEXTSIZE     \
        (QDEV_NFO_PRV_PARAMSIZE + \
         QDEV_NFO_PRV_WHOLESIZE)

#define TS_FROZEN 0xFF



struct nfo_ktm_data
{
  void            *kd_cluster;      /* Cluster address                      */
  struct MinList   kd_list;         /* List of fetched tasks                */
  ULONG            kd_faddr;        /* First found task address             */
  UBYTE           *kd_name;         /* Thing to find                        */
  UBYTE           *kd_patt;         /* Pattern to match                     */
  ULONG            kd_addr;         /* CLI num. or task address             */
  ULONG            kd_flags;        /* Function control flags               */
  LONG             kd_setarg;       /* Arg. to be used(flags)               */
  LONG           (*kd_strcmp)(const UBYTE *, const UBYTE *);
                                    /* String compare function              */
  LONG           (*kd_strpat)(UBYTE *, UBYTE *);
                                    /* Pattern match function               */
};

struct nfo_ktm_task
{
  struct MinNode  kl_node;          /* Node of this structure               */
  UBYTE           kl_tasktext[QDEV_NFO_PRV_TEXTSIZE];
                                    /* Textual task representation          */
};

#endif /* ___KTM_H_INCLUDED___ */
