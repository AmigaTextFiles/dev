OPT MODULE
OPT EXPORT

MODULE 'exec/nodes'

OBJECT ml
  ln:ln
  numentries:WORD
-> Um, what about 'me[1]:ARRAY OF me'
ENDOBJECT     /* SIZEOF=16 */

OBJECT me
  addr:LONG
  reqs:LONG @ addr
  length:LONG
ENDOBJECT     /* SIZEOF=8 */

CONST MEMF_ANY=0,
      MEMF_PUBLIC=1,
      MEMF_CHIP=2,
      MEMF_FAST=4,
      MEMF_VIRTUAL = 8, /* Memory that is mapped/paged */
      MEMF_EXECUTABLE = 16, /* Memory that contains executable code */
      MEMF_LOCAL=$100,
      MEMF_24BITDMA=$200,
      MEMF_KICK=$400,
      MEMF_PRIVATE = $800, /* Memory that is only _visible_ to the  allocator task */
      MEMF_SHARED = $1000, /* Memory that is visible and accessible to all tasks */
      MEMF_CLEAR=$10000,
      MEMF_LARGEST=$20000,
      MEMF_REVERSE=$40000,
      MEMF_TOTAL=$80000,
      MEMF_HWALIGNED = $100000, /* AllocMem: Allocate aligned to hardware page size */
      MEMF_DELAYED = $200000, /* AllocMem: Delay physical memory mapping */
      MEMF_NO_EXPUNGE = $80000000,

      MEM_BLOCKSIZE=8,
      MEM_BLOCKMASK=7

OBJECT memhandlerdata
  requestsize:LONG
  requestflags:LONG
  flags:LONG
ENDOBJECT     /* SIZEOF=12 */

CONST MEMHF_RECYCLE=1,
      MEM_DID_NOTHING=0,
      MEM_ALL_DONE=-1,
      MEM_TRY_AGAIN=1

OBJECT mh
  ln:ln
  attributes:INT  -> This is unsigned
  first:PTR TO mc
  lower:LONG
  upper:LONG
  free:LONG
ENDOBJECT     /* SIZEOF=32 */

OBJECT mc
  next:PTR TO mc
  bytes:LONG
-> Um, 'size:LONG' was an error
ENDOBJECT     /* SIZEOF=NONE !!! */


CONST
    MEMATTRF_WRITETHROUGH     = (1 SHL 0), /* Stores in this area update cache
                                           * and memory */
    MEMATTRF_CACHEINHIBIT     = (1 SHL 1), /* Caches are inhibited in this
                                           * area */
    MEMATTRF_COHERENT         = (1 SHL 2), /* Coherency required, stores to
                                           * same region will be serialized */
    MEMATTRF_GUARDED          = (1 SHL 3), /* Ensure in-order execute of memory
                                           * accesses */

    MEMATTRF_REFERENCED       = (1 SHL 4), /* Page containing memory location
                                           * has been referenced (used) */
    MEMATTRF_CHANGED          = (1 SHL 5), /* Page containing memory location
                                           * has been changed */

    /* The following are mutually exclusive */
    MEMATTRF_SUPER_RW         = (0 SHL 6),
    MEMATTRF_SUPER_RW_USER_RO = (1 SHL 6),
    MEMATTRF_SUPER_RW_USER_RW = (2 SHL 6),
    MEMATTRF_SUPER_RO_USER_RO = (3 SHL 6),
    MEMATTRF_RW_MASK          = (3 SHL 6),

    MEMATTRF_EXECUTE          = (1 SHL 9), /* CPU can execute instructions
                                           * from this memory */

    MEMATTRF_NOT_MAPPED       = (1 SHL 10), /* Special flag: The memory is not
                                           * mapped at all. This flag is only
                                           * used as return value of
                                           * GetMemoryAttr */
    MEMATTRF_RESERVED1        = (1 SHL 11), /* Used by the system */
    MEMATTRF_RESERVED2        = (1 SHL 12), /* _NEVER_ use these */
    MEMATTRF_RESERVER3        = (1 SHL 13)

CONST MEMATTRF_READ_WRITE = MEMATTRF_SUPER_RW_USER_RW
CONST MEMATTRF_READ_ONLY  = MEMATTRF_SUPER_RO_USER_RO

/****** GetMemoryAttrs flags ******************************************/
CONST GMAF_REPORT_CR = (1 SHL 0)

/****** AllocSysObject flags ******************************************/

CONST ASOF_NOTRACK = (1 SHL 1) /* Used internally to indicate no tracking of object */
