#ifndef DPKERNEL_H
#define DPKERNEL_H TRUE

/*
**   $VER: dpkernel.h V2.1
**
**   General include file for programs using the dpkernel.
**
**   (C) Copyright 1996-1998 DreamWorld Productions.
**       All Rights Reserved.
*/

#ifndef SYSTEM_TYPES_H
#include <system/types.h>
#endif

#ifndef SYSTEM_REGISTER_H
#include <system/register.h>
#endif

/***************************************************************************/

#define DPKVersion  2
#define DPKRevision 1

#define   M68K_REGISTERS TRUE
#define   M68K_CPU       TRUE
#define   MACHINE_AMIGA  TRUE
/*#define MACHINE_MAC    FALSE */
/*#define MACHINE_IBMPC  TRUE  */
/*#define PENTIUM_CPU    TRUE  */
/*#define _USE_DPKBASE   TRUE  */

#define MISSION_CRITICAL TRUE

#ifdef __SASC
  #define LIBPTR  __asm
  #define LIBFUNC __asm __saveds
  #define FUNC    __asm
  #define mreg(r) register r
  #define FNCALL inline
#else
 #ifdef _DCC
   #define LIBPTR
   #define LIBFUNC
   #define FUNC
   #define mreg(r) r
   #define FNCALL inline
 #else
   #define LIBPTR
   #define LIBFUNC
   #define FUNC
   #define mreg(r)
   #define FNCALL inline
 #endif
#endif

/****************************************************************************
** Tag definitions.
*/

#define SKIPENTRY   0
#define ENDLIST     -1
#define LISTEND     -1
#define TAGEND      0
#define DEFAULT     0

#define TBYTE       0L
#define TLONG       (1L<<31)
#define TWORD       (1L<<30)
#define TAPTR       (1L<<29)|TLONG
#define TSTEPIN     (1L<<28)
#define TSTEPOUT    (1L<<27)
#define TTRIGGER    (1L<<26)

#define TALLTAGS    (TBYTE|TLONG|TWORD|TAPTR|TSTEPIN|TSTEPOUT|TTRIGGER)

#ifndef TAG_IGNORE
 #ifdef MACHINE_AMIGA
  #include <utility/tagitem.h>
 #else
  typedef ULONG Tag;
  struct TagItem {
    Tag	ti_Tag;        /* Identifies the type of data */
    ULONG ti_Data;       /* Type-specific data */
  };

  #define TAG_IGNORE  (1L)
  #define TAG_MORE    (2L)
  #define TAG_SKIP    (3L)
 #endif
#endif /* TAG_IGNORE */

/****************************************************************************
** ID flags for Get().
*/

#define GET_NOTRACK (0x00010000L)
#define GET_PUBLIC  (0x00020000L)
#define GET_SHARE  ((0x00040000L)|GET_PUBLIC)

/****************************************************************************
** Function synonyms.
*/

#define DMsg(a)    DPrintF(NULL,a)
#define EMsg(a)    DPrintF("Error:",a)

#define Display(a)   Show(a)
#define Visible(a)   Show(a)
#define Invisible(a) Hide(a)
#define GetParent(a) GetContainer(a)

/****************************************************************************
** Header used for all objects.
*/

struct Head {
  WORD   ID;
  WORD   Version;
  struct SysObject *Class;
  struct Stats     *Stats;
};

/****************************************************************************
** The Stats structure is private to the system, and is handled by Get()
*/

struct Stats {
  LONG empty;                /* */
  APTR Private;              /* A reserved pointer for use by child objects */
  LONG Flags;                /* General flags */
  struct DPKTask *Exclusive; /* Tells us who owns any exclusive lock */
  WORD LockCount;            /* A running count of active locks if nesting */
  WORD emp;                  /* */
  LONG MemFlags;             /* Recommended memory allocation flags */
  APTR Container;            /* Set if the object was initialised to a container */
  struct Resource *ResourceList;
  LONG TotalData;            /* Total data/code memory */
  LONG TotalVideo;           /* Total video memory */
  LONG TotalSound;           /* Total sound memory */
  LONG TotalBlit;            /* Total blitter memory */
};

#define ST_SHARED      0x00000001L  /* The object is being openly shared */
#define ST_EXCLUSIVE   0x00000002L  /* If the object is exclusive to a task */
#define ST_PUBLIC      0x00000004L  /* If the object can be passed around */
#define ST_NOTRACKING  0x00000008L  /* Do not track resources on this object */
#define ST_INITIALISED 0x00000010L  /* This is set by Init() */

struct Resource {
  struct Resource *Prev;  /* Previous resource on chain */
  struct Resource *Next;  /* Next resource on chain */
  APTR Pointer;           /* Pointer to the resource */
  WORD Type;              /* RSF_OBJECT, RSF_MEMORY */
};

#define RSF_OBJECT   1
#define RSF_MEMORY   2
#define RSF_HARDWARE 3
#define RSF_ROUTINE  4

/****************************************************************************
** Raw Data object.
*/

#define VER_RAWDATA  1
#define TAGS_RAWDATA ((ID_SPCTAGS<<16)|ID_RAWDATA)

struct RawData {
  struct Head Head;  /* Standard structure header */
  LONG   Size;       /* Size of the data in bytes */
  APTR   Data;       /* Pointer to the data */

  /*** Private fields below ***/

  BYTE prvAFlags;    /* Private */
  BYTE prvPad;       /* Private */
};

/****************************************************************************
** List object.
*/

#define VER_ITEMLIST  1
#define TAGS_ITEMLIST ((ID_SPCTAGS<<16)|ID_ITEMLIST)

struct ItemList {
  struct Head Head;  /* Standard header */
  APTR   *Array;     /* Pointer to the list's array, terminated with -1 */
  LONG   MaxSize;    /* Maximum amount of objects that this list can hold */

  /*** Private fields below ***/

  APTR   prvMemory;
};

/****************************************************************************
** Universal errorcodes returned by certain functions.
*/

#define ERR_OK            0  /* Function went OK (also NULL) */
#define ERR_NOMEM         1  /* Not enough memory available */
#define ERR_NOPTR         2  /* Required pointer not present */
#define ERR_INUSE         3  /* Previous allocations have not been freed */
#define ERR_STRUCT        4  /* Structure version not supported or not found */
#define ERR_FAILED        5  /* General failure */
#define ERR_FILE          6  /* File error, eg file not found */
#define ERR_BADDATA       7  /* There is an error in the given data */
#define ERR_SEARCH        8  /* A search routine in this function failed */
#define ERR_SCRTYPE       9  /* Screen type not recognised */
#define ERR_MODULE       10  /* Trouble initialising/using a module */
#define ERR_RASTCOMMAND  11  /* Invalid raster command detected */
#define ERR_RASTERLIST   12  /* Complete rasterlist failure */
#define ERR_NORASTER     13  /* Expected rasterlist is missing from Screen */
#define ERR_DISKFULL     14  /* Disk full error */
#define ERR_FILEMISSING  15  /* File not found */
#define ERR_WRONGVER     16  /* Wrong version or version not supported */
#define ERR_MONITOR      17  /* Monitor driver not found or cannot be used */
#define ERR_UNPACK       18  /* Problem with unpacking of data */
#define ERR_ARGS         19  /* Invalid arguments passed to function */
#define ERR_NODATA       20  /* No data is available for use */
#define ERR_READ         21  /* Error reading data from file */
#define ERR_WRITE        22  /* Error writing data to file */
#define ERR_LOCK         23  /* Could not obtain lock on object */
#define ERR_EXAMINE      24  /* Could not examine directory or file */
#define ERR_LOSTCLASS    25  /* This object has lost its class reference */
#define ERR_NOACTION     26  /* This object does not support the required action */
#define ERR_NOSUPPORT    27  /* Object does not support the given data */
#define ERR_MEMORY       28  /* General memory error */
#define ERR_TIMEOUT      29  /* Function timed-out before successful completion */
#define ERR_NOSTATS      30  /* This object has lost its stats structure */
#define ERR_GET          31  /* Error in Get()ing an object */
#define ERR_INIT         32  /* Error in Init()ialising an object */
#define ERR_NOPERMISSION 33  /* Security violation */

/*** Synonyms ***/

#define ERR_SUCCESS   ERR_OK
#define ERR_DATA      ERR_BADDATA
#define ERR_LOSTSTATS ERR_NOSTATS
#define ERR_NOCLASS   ERR_LOSTCLASS
#define ERR_STATS     ERR_NOSTATS
#define ERR_SECURITY  ERR_NOPERMISSION

/****************************************************************************
** Memory types used by AllocMemBlock().  This is generally identical to the
** exec definitions but CHIP is renamed to VIDEO (displayable memory) and
** there is an addition of BLIT and SOUND specific memory.
*/

#define MEM_DATA      0
#define MEM_PUBLIC    (1L<<0)
#define MEM_VIDEO     (1L<<1)
#define MEM_BLIT      (1L<<2)
#define MEM_SOUND     (1L<<3)
#define MEM_CODE      (1L<<4)
#define MEM_PRIVATE   (1L<<5)
#define MEM_NOCLEAR   (1L<<6)
#define MEM_RESOURCED (1L<<7)
#define MEM_UNTRACKED (1L<<31)

#define MEM_AUDIO     MEM_SOUND

#define AllocPublic(size,flags) AllocMemBlock((size),(flags)|MEM_PUBLIC)
#define AllocPrivate(size,flags) AllocMemBlock((size),(flags)|MEM_PRIVATE)

/***************************************************************************/

#ifndef SYSTEM_MISC_H
#include <system/misc.h>
#endif

#ifndef SYSTEM_MODULES_H
#include <system/modules.h>
#endif

#ifndef GRAPHICS_BLITTER_H
#include <graphics/blitter.h>
#endif

#ifndef GRAHICS_PICTURES_H
#include <graphics/pictures.h>
#endif

#ifndef GRAPHICS_SCREENS_H
#include <graphics/screens.h>
#endif

#ifndef INPUT_JOYPORTS_H
#include <input/joyports.h>
#endif

#ifndef SOUND_SOUND_H
#include <sound/sound.h>
#endif

#ifndef FILES_FILES_H
#include <files/files.h>
#endif

#endif /* DPKERNEL_H */
