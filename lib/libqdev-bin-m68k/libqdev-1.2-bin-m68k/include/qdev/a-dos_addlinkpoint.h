/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * dos_addlinkpoint.h
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
 * $VER: a-dos_addlinkpoint.h 1.18 (02/05/2012)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___ADDLINKPOINT_H_INCLUDED___
#define ___ADDLINKPOINT_H_INCLUDED___

#define QDEV_DOS_PRV_MINCALLS        16
#define QDEV_DOS_PRV_MINFILES         8
#define QDEV_DOS_PRV_MINARGLEN     1024
#define QDEV_DOS_PRV_MAXARGLEN    (QDEV_DOS_PRV_MINARGLEN + 2)
#define QDEV_DOS_PRV_FLMINLEN       256
#define QDEV_DOS_PRV_FLMAXLEN     (QDEV_DOS_PRV_FLMINLEN + 2)
#define QDEV_DOS_PRV_FSQEXSIZE     2048
#define QDEV_DOS_PRV_MAXTXTLEN    65535
#define QDEV_DOS_PRV_ONEBLOCK       512
#define QDEV_DOS_PRV_NOREPLY     -32768
#define QDEV_DOS_PRV_TERMSIG      SIGBREAKF_CTRL_C
#define QDEV_DOS_PRV_SYNCSIG      SIGBREAKF_CTRL_F
#define QDEV_DOS_PRV_HTTPFILE     ".httpdevice"
#define QDEV_DOS_PRV_ONCECHAR     '@'
#define QDEV_DOS_PRV_PIPECHAR     '&'

#define QDEV_DOS_PRV_FCIRCULAR    0x00000001
#define QDEV_DOS_PRV_FCOMMAND     0x00000002
#define QDEV_DOS_PRV_FRUNONCE     0x00000004

#define QDEV_DOS_PRV_FW_ACCESS    0x0001

/*
 * These macros select or deselect node in the client
 * structure!
*/
#define QDEV_DOS_PRV_SKIPNODE(al)             \
(                                             \
  (void *)((ULONG)(al) +                      \
            (ULONG)sizeof(struct MinNode))    \
)
#define QDEV_DOS_PRV_ADDRNODE(al)             \
(                                             \
  (void *)((ULONG)(al) -                      \
            (ULONG)sizeof(struct MinNode))    \
)



/*
 * This is client structure 'llac' ---> 'call', its size should
 * be kept as small as possible due to preallocation of it in a
 * cluster('QDEV_DOS_PRV_MINCALLS')!
*/
struct dos_alp_llac
{
  struct MinNode        al_node;        /* Node of this structure           */
  struct FileLock       al_fl;          /* File lock structure              */
  LONG                  al_fdaddr;      /* File descriptor address          */
  struct FileInfoBlock  al_fib;         /* Local copy of 'af_fib'           */
  ULONG                 al_flags;       /* Local copy of 'af_flags'         */
  LONG                  al_wait;        /* Local copy of 'af_wait'          */
  struct Process       *al_pr;          /* Route packets here               */
  struct Process       *al_cpr;         /* Additional CLI process           */
};

struct dos_alp_file
{
  struct MinNode        af_node;        /* Node of this structure           */
  struct FileInfoBlock  af_fib;         /* File info block                  */
  ULONG                 af_flags;       /* File flags(private)              */
  LONG                  af_wait;        /* Time to wait for I/O             */
  UBYTE                 af_tasks[QDEV_DOS_PRV_FLMAXLEN];
                                        /* Task incl./excl. buffer          */
  UBYTE                 af_cli[QDEV_DOS_PRV_FLMAXLEN];
                                        /* CLI command buffer               */
  UBYTE                *af_cmd;         /* CLI command pointer              */
  UBYTE                *af_args;        /* CLI argument pointer             */
};

struct dos_alp_main
{
  void                 *am_cluster;     /* Client cluster space             */
  void                 *am_fcluster;    /* File cluster space               */
  struct MinList        am_links;       /* List of links(directory)         */
  struct MinList        am_clilist;     /* List of all the clients          */
  UBYTE                *am_devname;     /* This d. name(without ':')        */
  struct DosList       *am_dol;         /* Doslist pointer                  */
  struct DosList        am_vol;         /* Volume data                      */
  struct DosPacket     *am_dp;          /* Primary packet                   */
  void                 *am_last;        /* Last valid entry                 */
  struct dos_alp_file   am_af;          /* Root file(not on the list)       */
  LONG                  am_isfs;        /* Is handler a filesystem?         */
  LONG                  am_wrprot;      /* Write protection ctrl            */
  LONG                  am_dfiles;      /* Num. of discarded files          */
  LONG                  am_filenull;    /* NULL in full path                */
  UBYTE                 am_fileline[QDEV_DOS_PRV_MAXARGLEN];
                                        /* Full path buffer space           */
  UBYTE                 am_argline[QDEV_DOS_PRV_MAXARGLEN];
                                        /* Arg. parser buffer space         */
};

#endif /* ___ADDLINKPOINT_H_INCLUDED___ */
