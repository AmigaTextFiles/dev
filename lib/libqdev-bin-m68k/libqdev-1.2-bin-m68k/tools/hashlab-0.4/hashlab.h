/*
 * hashlab.h
 * by megacz
*/

#ifndef ___HASHLAB_H_INCLUDED___
#define ___HASHLAB_H_INCLUDED___

#ifdef __amigaos__
#include <exec/execbase.h>
#include <exec/io.h>
#include <proto/alib.h>
#include <proto/timer.h>
#include <sys/ioctl.h>
#include <errno.h>
#endif

#include "qdev.h"
#include "qversion.h"

/*
 * Module internals.
*/
#define _HASHLAB_MODULEFCODE    QDEV_MOD_ADE_DUMMYCODE
#define _HASHLAB_MODULEMAGIC    0x484C4142  /* 'H' 'L' 'A' 'B'              */
#define _HASHLAB_MODULEIFUNC    _hashlab_init
#define _HASHLAB_MODULECFUNC    _hashlab_cleanup
#define _HASHLAB_MODULERFUNC    _hashlab_routine

/*
 * Module flags.
*/
#define _HASHLAB_F_32BIT        0x00000001  /* Function does 32bit hashes   */
#define _HASHLAB_F_64BIT        0x00000002  /* Function does 64bit hashes   */
#define _HASHLAB_F_96BIT        0x00000004  /* Function does 96bit hashes   */
#define _HASHLAB_F_128BIT       0x00000008  /* Function does 128bit hashes  */
#define _HASHLAB_F_EQCASE       0x10000000  /* Function equalizes case      */

/*
 * Routine return codes.
*/
#define _HASHLAB_R_ALLOKAY       0
#define _HASHLAB_R_CANTHASH     -1



#define _HASHLAB_MODULEHEADER(n, v, r, d)     \
__asm("\t  .text"                             \
"  \n\t	.even"                                \
"  \n\t .globl   ___failsafe"                 \
"  \n\t___failsafe:"                          \
"  \n\t .long "                               \
       QDEV_HLP_MKSTR(_HASHLAB_MODULEFCODE)   \
"  \n\t .long "                               \
       QDEV_HLP_MKSTR(_HASHLAB_MODULEMAGIC)   \
"  \n\t .long _"                              \
       QDEV_HLP_MKSTR(_HASHLAB_MODULEIFUNC)   \
"  \n\t .long _"                              \
       QDEV_HLP_MKSTR(_HASHLAB_MODULECFUNC)   \
"  \n\t .long _"                              \
       QDEV_HLP_MKSTR(_HASHLAB_MODULERFUNC)   \
"  \n\t .long 0"                              \
"  \n\t .data");                              \
static const UBYTE ___version[] = "\0$VER: "  \
           n " " QDEV_HLP_MKSTR(v) "."        \
               QDEV_HLP_MKSTR(r) " " d "\0";  \



struct _hashlab
{
  UBYTE *hl_text;         /* Name of the module                             */
  ULONG  hl_ver;          /* Version of the module                          */
  ULONG  hl_rev;          /* Revision of the module                         */
  ULONG  hl_flags;        /* Flags of the module                            */
};



void *_HASHLAB_MODULEIFUNC(void);
void _HASHLAB_MODULECFUNC(void *);
LONG _HASHLAB_MODULERFUNC(void *, VUQ128 *, UBYTE *);



/*
 * Client stuff.
*/
#define HASHLAB_DUMTSIZE     0     /* Dummy buffer size for the line        */
#define HASHLAB_MINTSIZE    16     /* Min. buffer size for the line         */
#define HASHLAB_DEFTSIZE   128     /* Def. buffer size for the line         */
#define HASHLAB_INCHUNKS   128     /* Initial num. of chunks per cluster    */
#define HASHLAB_IMCHUNKS   512     /* Initial num. of chunks for mirror     */
#define HASHLAB_IGCHUNKS   512     /* Initial num. of chunks for msg.       */
#define HASHLAB_MAXTASKS     8     /* Parallel coll. det. count (15 max)    */
#define HASHLAB_DEFTASKS     1     /* Default number of initial tasks       */
#define HASHLAB_TOGGSIG    SIGBREAKF_CTRL_F
                                   /* Output toggle signal                  */
#define HASHLAB_SYNCSIG    SIGBREAKF_CTRL_E
                                   /* Subprocesses synchronisation sig.     */
#define HASHLAB_TERMSIG    SIGBREAKF_CTRL_C
                                   /* Global termination signal             */
#define HASHLAB_TESTTEXT   "The quick brown fox jumps over the lazy dog"
                                   /* Hashing routine feedback input data   */
#define HASHLAB_DISTIME      1     /* Service discovery time in seconds     */
#define HASHLAB_MAXWRITE   128     /* Number of chunks(struct hashentryd)   */
#define HASHLAB_MAXCOLLS   666     /* Maximum collsions to catch            */

#define HASHLAB_M_ERROR    0x00000001
#define HASHLAB_M_QUIT     0x00000002
#define HASHLAB_M_HCOLL    0x00000004



struct hashentry
{
  void               *he_next;     /* Next hash entry                       */
  void               *he_mlist;    /* Mirror list                           */
  LONG                he_num;      /* Line/hash number                      */
  VUQ128              he_hash;     /* Current hash value                    */
  UBYTE               he_text[HASHLAB_DUMTSIZE];
                                   /* Text to be hashed                     */
};

struct mirrorentry
{
  void               *me_next;     /* Next mirror entry                     */
  LONG                me_num;      /* Mirrored line num.                    */
};

struct hashlabdata
{
  void               *hld_list;    /* Hash list                             */
  void               *hld_clu;     /* Hash cluster                          */
  void               *hld_mclu;    /* Mirror cluster                        */
  void               *hld_gclu;    /* Msg. cluster                          */
  LONG               *hld_cptr;    /* Tot. colls ptr.                       */
  LONG                hld_mcoll;   /* Max collisions                        */
};

struct hashmessage
{
  struct MinNode      hm_mn;       /* Message node                          */
  void               *hm_data;     /* Data pointer                          */
  LONG                hm_type;     /* Type of data                          */
};

struct doublevu
{
  VUQ128 db_vu1;                   /* Twin hash space                       */
  VUQ128 db_vu0;                   /* Primary hash space                    */
};



/*
 * Below you will find two hacks that allow to lower mem.
 * consumption.  I  made  a mistake while writing hashlab.
 * The problem child is cluster allocator used for storing
 * text data. This is especially the case with very long
 * lines,  since each line in memory is of highest length,
 * which makes memory usage rediculously high...
*/
#ifdef ___HASHLAB_USEPOOLS
/*
 * Pool allocator hack. Kinda slow, but lesser mem. usage.
*/
#define X_mem_alloccluster(a, b, c)           \
({                                            \
  static ULONG emuptr[2] = {0, 0};            \
  if ((emuptr[0] = (ULONG)AllocVec(           \
                  (a) * 2, MEMF_PUBLIC)))     \
  {                                           \
    emuptr[1] = (ULONG)(emuptr[0] + (a));     \
    QDEV_MEM_XXXVPINIT(                       \
                   MEMF_CHIP, 1024, 1024);    \
    QDEV_MEM_XXXVPINIT(                       \
                   MEMF_FAST, 8192, 1024);    \
  }                                           \
  &emuptr[0];                                 \
})
#define X_mem_freecluster(a)                  \
({                                            \
  ULONG *emunode = a;                         \
  mem_setvecpooled(MEMF_CHIP,                 \
                     QDEV_MEM_XXXVPI_FREE,    \
                    QDEV_MEM_XXXVPV_NOCH);    \
  mem_setvecpooled(MEMF_FAST,                 \
                     QDEV_MEM_XXXVPI_FREE,    \
                    QDEV_MEM_XXXVPV_NOCH);    \
  FreeVec((void *)emunode[0]);                \
})
#define X_mem_getmemcluster(a)                \
({                                            \
  static ULONG emutrig = 0;                   \
  ULONG *emunode = a;                         \
  emunode = (ULONG *)(                        \
       emutrig ? emunode[1] : emunode[0]);    \
  emutrig = 1;                                \
  (void *)emunode;                            \
})
#define X_mem_freememcluster(a)
#undef FGets
#define FGets(a, b, c)                        \
({                                            \
  struct hashentry *poolhe;                   \
  UBYTE *string;                              \
  LONG strsize;                               \
  STRPTR (*_FGets)(REGARG(BPTR, d1),          \
                       REGARG(STRPTR, d2),    \
                      REGARG(ULONG, d3)) =    \
           mem_addrfromlvo(DOSBase, -336);    \
  if ((string = _FGets(a, b, c)))             \
  {                                           \
    strsize = txt_strlen(b) + 1;              \
    if ((poolhe = mem_allocvecpooled(         \
       sizeof(struct hashentry) + strsize,    \
                            MEMF_PUBLIC)))    \
    {                                         \
      poolhe->he_text[0] = '\0';              \
      txt_strncat(                            \
             poolhe->he_text, b, strsize);    \
      he = poolhe;                            \
      string = poolhe->he_text;               \
    }                                         \
    else                                      \
    {                                         \
      goto ___noalloc;                        \
    }                                         \
  }                                           \
  string;                                     \
})
#define X_MEMORYUSAGE()                       \
({                                            \
  LONG memusage;                              \
  memusage = mem_setvecpooled(MEMF_CHIP,      \
                     QDEV_MEM_XXXVPI_REAL,    \
                    QDEV_MEM_XXXVPV_NOCH);    \
  memusage += mem_setvecpooled(MEMF_FAST,     \
                     QDEV_MEM_XXXVPI_REAL,    \
                    QDEV_MEM_XXXVPV_NOCH);    \
  memusage;                                   \
})
#else
#ifdef ___HASHLAB_USEALLOC
/*
 * Native allocator hack. Might be slow, but low mem usage.
*/
#define X_mem_alloccluster(a, b, c)           \
({                                            \
  static ULONG emuptr[2] = {0, 0};            \
  if ((emuptr[0] = (ULONG)AllocVec(           \
                  (a) * 2, MEMF_PUBLIC)))     \
  {                                           \
    emuptr[1] = (ULONG)(emuptr[0] + (a));     \
  }                                           \
  &emuptr[0];                                 \
})
#define X_mem_freecluster(a)                  \
({                                            \
  ULONG *emunode = a;                         \
  struct hashentry *heptr = hld.hld_list;     \
  void *currptr;                              \
  while ((currptr = heptr))                   \
  {                                           \
    heptr = heptr->he_next;                   \
    FreeVec(currptr);                         \
  }                                           \
  FreeVec((void *)emunode[0]);                \
})
#define X_mem_getmemcluster(a)                \
({                                            \
  static ULONG emutrig = 0;                   \
  ULONG *emunode = a;                         \
  emunode = (ULONG *)(                        \
       emutrig ? emunode[1] : emunode[0]);    \
  emutrig = 1;                                \
  (void *)emunode;                            \
})
#define X_mem_freememcluster(a)
#undef FGets
#define FGets(a, b, c)                        \
({                                            \
  struct hashentry *alloche;                  \
  UBYTE *string;                              \
  LONG strsize;                               \
  STRPTR (*_FGets)(REGARG(BPTR, d1),          \
                       REGARG(STRPTR, d2),    \
                      REGARG(ULONG, d3)) =    \
           mem_addrfromlvo(DOSBase, -336);    \
  if ((string = _FGets(a, b, c)))             \
  {                                           \
    strsize = txt_strlen(b) + 1;              \
    if ((alloche = AllocVec(                  \
       sizeof(struct hashentry) + strsize,    \
                            MEMF_PUBLIC)))    \
    {                                         \
      alloche->he_text[0] = '\0';             \
      txt_strncat(                            \
            alloche->he_text, b, strsize);    \
      he = alloche;                           \
      string = alloche->he_text;              \
    }                                         \
    else                                      \
    {                                         \
      goto ___noalloc;                        \
    }                                         \
  }                                           \
  string;                                     \
})
#define X_MEMORYUSAGE()                       \
({                                            \
  ((sizeof(struct hashentry) + 4) * num) +    \
                  Seek(fd, 0, OFFSET_END);    \
})
#else
/*
 * Cluster allocator. Fastest possible, but memory hungry!
*/
#define X_mem_alloccluster   mem_alloccluster
#define X_mem_freecluster    mem_freecluster
#define X_mem_getmemcluster  mem_getmemcluster
#define X_mem_freememcluster mem_freememcluster
#define X_MEMORYUSAGE()                       \
({                                            \
  struct mem_clr_head *ch = hld.hld_clu;      \
  LONG memusage = 0;                          \
  while (ch)                                  \
  {                                           \
    memusage += ch->ch_total;                 \
    ch = ch->ch_next;                         \
  }                                           \
  memusage;                                   \
})
#endif
#endif



/*
 * Server stuff.
*/
#ifdef __amigaos__
#define _HASHLABD_SWAPLONG(long)
#else
#define _HASHLABD_SWAPLONG QDEV_HLP_SWAPLONG
#endif

#define HASHLABD_PORT      31704         /* Default client/daemon port       */
#define HASHLABD_MAXPROC   HASHLAB_MAXTASKS
                                         /* Maximum server threads           */
#define HASHLABD_STACK     65536         /* Amount of stack per thread       */
#define HASHLABD_TRYAGAN       5         /* Fatal error retry interval       */
#define HASHLABD_SCKTIME      30         /* Time to wait for I/O(secs)       */
#define HASHLABD_MAXWAIT       1         /* Client introduction time         */
#define HASHLABD_MEMLIM      128         /* Max memory per thread(megs)      */
#define HASHLABD_ONEMEG    (1024 * 1024) /* One megabyte                     */
#define HASHLABD_MAXREAD    4096         /* Max data to read in one go       */
#define HASHLABD_MAXTRES   16000         /* Max delay value in micros        */

#define HASHLABD_M_QUERY   0x48454C50    /* 'H' 'E' 'L' 'P'                  */
#define HASHLABD_M_ANSWER  0x54414441    /* 'T' 'A' 'D' 'A'                  */

#define HASHLABD_M_ALLOK   0x4F4B4159    /* 'O' 'K' 'A' 'Y'                  */
#define HASHLABD_M_DSIZE   0x53495A45    /* 'S' 'I' 'Z' 'E'                  */
#define HASHLABD_M_NOROOM  0x524F4F4D    /* 'R' 'O' 'O' 'M'                  */
#define HASHLABD_M_CHKSUM  0x4353554D    /* 'C' 'S' 'U' 'M'                  */
#define HASHLABD_M_PING    0x50494E47    /* 'P' 'I' 'N' 'G'                  */
#define HASHLABD_M_HCOLL   0x424F4F4D    /* 'B' 'O' 'O' 'M'                  */
#define HASHLABD_M_HTELL   0x54454C4C    /* 'T' 'E' 'L' 'L'                  */
#define HASHLABD_M_QUIT    0x51554954    /* 'Q' 'U' 'I' 'T'                  */



struct hashlabmsg
{
  unsigned long   hlm_head;    /* Message type                              */
  unsigned long   hlm_size;    /* Size of data                              */
  unsigned long   hlm_data;    /* Size of chunk                             */
  unsigned long   hlm_inum;    /* Int. entry                                */
};

struct hashlabwrap
{
  struct hashlabmsg  hlw_hlm;   /* Default message                          */
  int                hlw_icnt;  /* Default slot                             */
  void              *hlw_imem;  /* Default pointer                          */
};

/*
 * This is crippled 'struct hashentry'. Its only 20 bytes
 * wide, so transferring data over the LAN should be quite
 * fast.
*/
struct hashentryd
{
  ULONG               hed_addr;    /* Cell address                          */
  VUQ128              hed_hash;    /* Current hash value                    */
};

#endif
