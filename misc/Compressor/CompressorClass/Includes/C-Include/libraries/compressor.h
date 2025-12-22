#ifndef CLASSES_COMPRESSOR_H
#define CLASSES_COMPRESSOR_H

#ifndef XPK_XPK_H
#include <libraries/xpk.h>
#endif

#ifndef EXEC_TYPE_H
#include <exec/types.h>
#endif


/* Some useful constants used by my class */
#define PASSWORDLENGTH     0x50
#define METHODLENGTH       6


/* Currently all flags */
#define CCF_HIDEPASSWORD      1<<0
#define CCF_SCREENLOCKED      1<<1
#define CCF_INTERNALPROGRESS  1<<2


/* IFF-ID to write the Prefschunk */
#define ID_CCCP 0x43434350


/* Macros */
#define PACKSIZE(size)    ((ULONG)size + ((ULONG)size>>5) + (XPK_MARGIN<<1))
#define UNPACKSIZE(size)  ((ULONG)size + XPK_MARGIN)
#define MEMSIZE(adr)      *(ULONG *)((ULONG)adr - 4)


/* Tag-Values */
#define CCA_METHODINDEX      0xFFFF0000
#define CCA_MODE             0xFFFF0001
#define CCA_PASSWORD         0xFFFF0002
#define CCA_PROGRESSHOOK     0xFFFF0003
#define CCA_XPKPACKERINFO    0xFFFF0004
#define CCA_XPKMODE          0xFFFF0005
#define CCA_METHODLIST       0xFFFF0006
#define CCA_PREFSCHUNK       0xFFFF0007
#define CCA_METHOD           0xFFFF0008
#define CCA_NUMPACKERS       0xFFFF0009
#define CCA_HIDEPASSWORD     0xFFFF000A
#define CCA_FLAGS            0xFFFF000B
#define CCA_SCREEN           0xFFFF000C
#define CCA_SCREENLOCKED     0xFFFF000D
#define CCA_TEXTATTR         0xFFFF000E
#define CCA_PUBSCREENNAME    0xFFFF000F
#define CCA_MEMPOOL          0xFFFF0010
#define CCA_INTERNALPROGRESS 0xFFFF0011

/* Methods */
#define CCM_FILE2FILE      0xFFAA0000
#define CCM_FILE2MEM       0xFFAA0001
#define CCM_MEM2MEM        0xFFAA0003
#define CCM_FILES2FILES    0xFFAA0002
#define CCM_PREFSGUI       0xFFAA0004
#define CCM_EXAMINE        0xFFAA0005


/* Messages */
struct ccmExamine {
  LONG    methodid;         /* CCM_EXAMINE                             */
  STRPTR  com_Source;       /* sourcefile or NULL                      */
  APTR    com_Memory;       /* memory area or NULL                     */
  ULONG   com_MemoryLen;    /* length of the memory area or NULL       */
  ULONG   *com_SizeAddr;    /* address to write the original length to */
};     /* SIZEOF=16 */

struct ccmMem2Mem {
  ULONG   methodid;           /* CCM_MEM2MEM                            */
  ULONG   com_Compressing;    /* 0 = decompression, else compression    */
  APTR    com_Source;         /* sourcememory                           */
  APTR    com_Destination;    /* destination memory or address of APTR  */
  ULONG   com_SourceLen;      /* length of source memory                */
  ULONG   com_DestinationLen; /* length of destination memory or 0      */
  ULONG   *com_OutLen;        /* address to write the written length to */
};     /* SIZEOF=28 */

struct ccmFile2Mem {
  ULONG   methodid;           /* CCM_FILE2MEM                           */
  ULONG   com_Compressing;    /* 0 = decompression, else compression    */
  STRPTR  com_Source;         /* sourcefile                             */
  APTR    com_Memory;         /* destination memory or address of APTR  */
  ULONG   com_Length;         /* length of destination memory or 0      */
  ULONG   *com_OutLen;        /* address to write the written length to */
};     /* SIZEOF=24 */

struct ccmFiles2Files {
  ULONG   methodid;           /* CCM_FILES2FILES                        */
  ULONG   com_Compressing;    /* 0 = decompression, else compression    */
  ULONG   *com_Sources;       /* NULL-terminated list with sourcefiles  */
  ULONG   *com_Destinations;  /* NULL or NULL-terminated list           */
  ULONG   *com_Results;       /* NULL or NULL-terminated list           */
  STRPTR  com_Suffix;         /* NULL or suffix                         */
};     /* SIZEOF=24 */

struct ccmFile2File {
  ULONG   methodid;           /* CCM_FILE2FILE                          */
  STRPTR  com_Source;         /* sourcefile                             */
  STRPTR  com_Destination;    /* destinationfile                        */
  ULONG   com_Compressing;    /* 0 = decompression, else compression    */
};     /* SIZEOF=16 */

#endif
