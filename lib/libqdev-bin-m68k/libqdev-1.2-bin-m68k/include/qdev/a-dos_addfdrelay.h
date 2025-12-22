/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * dos_addfdrelay.h
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
 * $VER: a-dos_addfdrelay.h 1.46 (18/04/2012)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___ADDFDRELAY_H_INCLUDED___
#define ___ADDFDRELAY_H_INCLUDED___

/*
 * Important! Please study the code first before you hack on these
 * values!
*/
#define QDEV_DOS_PRV_MINLEN          4
#define QDEV_DOS_PRV_RESERVED        8
#define QDEV_DOS_PRV_CHNAMLEN       16
#define QDEV_DOS_PRV_CHFMTLEN       64
#define QDEV_DOS_PRV_FNAMELEN      128
#define QDEV_DOS_PRV_STATLEN       256
#define QDEV_DOS_PRV_FLMINLEN      256
#define QDEV_DOS_PRV_FLMAXLEN  (QDEV_DOS_PRV_FLMINLEN + 2) 
#define QDEV_DOS_PRV_FLUSHREQ      256
#define QDEV_DOS_PRV_TOTCALLS      256
#define QDEV_DOS_PRV_MINALLOC     1024
#define QDEV_DOS_PRV_MINDELAY    35000
#define QDEV_DOS_PRV_SYNCPRI         0
#define QDEV_DOS_PRV_DEFTSIG   SIGBREAKF_CTRL_C
#define QDEV_DOS_PRV_NOREPLY    -32768
#define QDEV_DOS_PRV_NULLCHAN  "NULL"
#define QDEV_DOS_PRV_NULLFILE  ""
#define QDEV_DOS_PRV_DECALIGN  0x03000000
#define QDEV_DOS_PRV_CHANSTAT  0x4348414E     /* 'C' 'H' 'A' 'N'            */
#define QDEV_DOS_PRV_PIPESTAT  0x50495045     /* 'P' 'I' 'P' 'E'            */
#define QDEV_DOS_PRV_PATHSTAT  0x50415448     /* 'P' 'A' 'T' 'H'            */
#define QDEV_DOS_PRV_STATSTAT  0x53544154     /* 'S' 'T' 'A' 'T'            */
#define QDEV_DOS_PRV_VCRSEQ    0x1B5B7000     /* ESC '[' 'p'  0             */
#define QDEV_DOS_PRV_VCRSYNC   "0000"
#define QDEV_DOS_PRV_VFNAME    "ROLLOVER = "
#define QDEV_DOS_PRV_CONNAME   "CONSOLE: = "
#define QDEV_DOS_PRV_PIPENAME  "PIPETYPE = "
#define QDEV_DOS_PRV_RTNAME    "FDROUTER = "

#define QDEV_DOS_PRV_FGENEOF   0x00000001
#define QDEV_DOS_PRV_FFAILNR   0x00000002
#define QDEV_DOS_PRV_FFAILNW   0x00000004
#define QDEV_DOS_PRV_FQUERY    0x00000008

/*
 * VCR sync. macros.
*/
#define QDEV_DOS_PRV_MAKESYNC(ptr, seq, mark) \
({                                            \
  UBYTE *___m_sptr = (UBYTE *)ptr;            \
  *(ULONG *)&___m_sptr[0] = (ULONG)seq;       \
  *(ULONG *)&___m_sptr[4] = (ULONG)seq;       \
  *(ULONG *)&___m_sptr[2] = *(ULONG *)mark;   \
})
#define QDEV_DOS_PRV_CMPSYNC(sync1, sync2)    \
({                                            \
  ULONG *___m_sync1 = (ULONG *)sync1;         \
  ULONG *___m_sync2 = (ULONG *)sync2;         \
  ((___m_sync1[0] == ___m_sync2[0]) &&        \
  ((___m_sync1[1] & 0xFFFFFF00)     ==        \
   (___m_sync2[1] & 0xFFFFFF00)));            \
})
 
/*
 * These macros select or deselect second node in the client
 * structure!
*/
#define QDEV_DOS_PRV_CALLTONODE(fl)           \
(                                             \
  (void *)((ULONG)(fl) +                      \
            (ULONG)sizeof(struct MinNode))    \
)
#define QDEV_DOS_PRV_NODETOCALL(fl)           \
(                                             \
  (void *)((ULONG)(fl) -                      \
            (ULONG)sizeof(struct MinNode))    \
)

/*
 * New and very custom packet type!
*/
#define ACTION_TIMER_PACKET    65536



struct dos_fdr_main
{
  void                *fm_cluster;      /* Client cluster space             */
  struct MinList       fm_chanlist;     /* List of all the channels         */
  struct MinList       fm_clilist;      /* List of all the clients          */
  struct dos_fdr_chan *fm_chandef;      /* Def. channel('CONSOLE:')         */
  LONG                 fm_chancount;    /* Number of channels               */
  LONG                 fm_fdtotal;      /* Number of all file desc.         */
  LONG                 fm_clitotal;     /* Number of all clients            */
  LONG                 fm_fdcheck;      /* File desc. check address         */
  UBYTE               *fm_devname;      /* This dev. name(without ':')      */
  LONG                 fm_flushreq;     /* Flush dead chans requests        */
  LONG                 fm_flushcnt;     /* Flush dead chans counter         */
  LONG                 fm_flushnum;     /* Number of flushed chans          */
  struct DosList      *fm_dol;          /* Doslist pointer                  */
  struct DosPacket    *fm_dp;           /* Primary packet                   */
  struct timerequest   fm_treq;         /* Master request space             */
  void                *fm_gluefp;       /* Packet glue func. pointer        */
};

struct dos_fdr_stat
{
  LONG                 fs_statlen;      /* Status data buf. length          */
  UBYTE               *fs_statptr;      /* Status data pointer              */
  UBYTE                fs_statbuf[QDEV_DOS_PRV_MINLEN];
                                        /* Status data buffer               */

  /* 
   * No new members allowed at this point, because 'fs_statbuf' can be
   * larger than that minimum!!!
  */
};

struct dos_fdr_glue
{
  struct Interrupt     fg_is;           /* Interrupt structure              */
  struct MsgPort       fg_mp;           /* Custom message port              */
};

/*
 * This is client structure 'llac' ---> 'call', its size should
 * be kept as small as possible due to preallocation of it in a
 * cluster('QDEV_DOS_PRV_TOTCALLS')! It is too big already...
*/
struct dos_fdr_llac
{
  struct MinNode       fl_node;         /* Node of this structure           */
  struct MinNode       fl_pnode;        /* Node used for pipe I/O           */
  struct dos_fdr_glue  fl_fg;           /* Packet glue logic                */
  void                *fl_ptr;          /* Channel, pipe or stat ptr        */
  ULONG                fl_status;       /* Type of the pointer              */
  ULONG                fl_chrstore;     /* Single char container            */
  LONG                 fl_rollrlen;     /* Rollover read length             */
  LONG                 fl_rollrpos;     /* Rollover cursor position         */
  LONG                 fl_flags;        /* Client behaviour flags           */
  ULONG                fl_tcaddr;       /* Address of the caller            */
  struct timerequest   fl_treq;         /* Timer request space              */
  struct DosPacket     fl_tdp;          /* Special timer packet             */
};

struct dos_fdr_chan
{
  struct MinNode       fc_node;         /* Node of this structure           */
  struct dos_fdr_llac *fc_fl;           /* Client forward pointer           */
  struct dos_fdr_file *fc_vff;          /* Virtual file pointer             */
  struct DateTime      fc_chandat;      /* Channel creation time            */
  struct MinList       fc_fdlist;       /* List of file descriptors         */
  LONG                 fc_fdcount;      /* Number of file descriptors       */
  LONG                 fc_clicount;     /* Client count on this chan.       */
  LONG                 fc_clfiles;      /* Close files if no clients?       */
  LONG                 fc_striplen;     /* Current size of strip buf.       */
  UBYTE               *fc_stripbuf;     /* Current strip buffer ptr         */
  UBYTE               *fc_stripend;     /* Strip done indicator/ptr         */
  ULONG                fc_passhash;     /* Password hash value              */
  ULONG                fc_status;       /* Type of the channel              */
  LONG                 fc_vcrstate;     /* VCR turned on or off             */
  LONG                 fc_vcrchr;       /* VCR last character               */
  struct DosPacket     fc_vcrdp;        /* VCR fake relay packet            */
  struct EClockVal     fc_vcrev;        /* VCR time rasterisation           */
  UBYTE                fc_vcrseq[QDEV_CNV_UXXXLEN];
                                        /* VCR time sequence                */
  ULONG                fc_reserved[QDEV_DOS_PRV_RESERVED];
                                        /* Reserved area                    */
  UBYTE                fc_channame[QDEV_DOS_PRV_CHNAMLEN];
                                        /* This channel name                */
  UBYTE                fc_chfmtbuf[QDEV_DOS_PRV_CHFMTLEN];
                                        /* Channel format buffer            */
  UBYTE                fc_chfmtout[QDEV_DOS_PRV_CHFMTLEN];
                                        /* Channel format output            */
};

struct dos_fdr_file
{
  struct MinNode       ff_node;         /* Node of this structure           */
  struct MinList       ff_rlist;        /* List of all readers(pipes)       */
  struct MinList       ff_wlist;        /* List of all writers(pipes)       */
  struct MinList       ff_alist;        /* List of waiting clients          */
  LONG                 ff_awaits;       /* Reader awaits char(pipes)        */
  LONG                 ff_xmode;        /* Input mode, raw or cooked        */
  LONG                 ff_fmtbool;      /* Is format allowed now?           */
  LONG                 ff_stripansi;    /* Should ANSI be filtered?         */ 
  LONG                 ff_fdaddr;       /* File descriptor address          */
  LONG                 ff_fdclose;      /* Auto close on relay term?        */
  LONG                 ff_fdbuf;        /* File descriptor buffered?        */
  UBYTE               *ff_fdvptr;       /* Virtual file data pointer        */
  ULONG                ff_fdvsize;      /* Virtual file data size           */
  ULONG                ff_failcnt;      /* Number of relay failures         */
  ULONG                ff_tcaddr;       /* Address of the fd owner          */
  ULONG                ff_tcsig;        /* Sig. owner on relay term?        */
  UBYTE                ff_fname[QDEV_DOS_PRV_FNAMELEN];
                                        /* Filename of custom file          */
};

#endif /* ___ADDFDRELAY_H_INCLUDED___ */
