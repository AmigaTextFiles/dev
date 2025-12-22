#ifndef FILES_FILES_H
#define FILES_FILES_H TRUE

/*
**   $VER: files.h V1.0
**
**   File definitions.
**
**   (C) Copyright 1996-1998 DreamWorld Productions.
**       All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/****************************************************************************
** Module information.
*/

#define FileModVersion  1
#define FileModRevision 0

/****************************************************************************
** Mini structures for source and destination operations.
*/

struct Source {      /* Source structure, for internal use only */
  WORD ID;
  APTR Src;
};

struct FileName {    /* Filename structure */
  WORD ID;           /* ID_FILENAME */
  BYTE *Name;        /* Pointer to filename */
};

struct MemPtr {      /* Memory location structure */
  WORD ID;           /* ID_MEMPTR */
  APTR Address;      /* Pointer to memory area */
  LONG Size;         /* Must supply a size unless you are a MemBlock */
};

/****************************************************************************
** Seek positions.
*/

#define POS_BEGINNING 0
#define POS_CURRENT   1
#define POS_END       2

#define POS_START POS_BEGINNING

/****************************************************************************
** File Object.
*/

#define VER_FILE  1
#define TAGS_FILE ((ID_SPCTAGS<<16)|ID_FILE)

typedef struct File {
  struct Head Head;       /* [00] (-R) Standard structure header */
  LONG   BytePos;         /* [12] (-R) Current position in file */
  LONG   Flags;           /* [16] (IR) File opening flags */
  struct Head *Source;    /* [20] (IR) Direct pointer to the original Source structure */
  struct File *Prev;      /* [24] (-R) Previous file in chain */
  struct File *Next;      /* [28] (-R) Next file in chain */
  APTR   DataProcessor;   /* [32] (--) Not available for program use */

  /*** Private fields start now ***/

  struct Time *prvDate;
  BYTE   *prvComment;
  LONG   prvSize;
  LONG   prvHandle;
  LONG   prvKey;
  WORD   prvAFlags;
  struct SysObject *prvFileIO;
} OBJFile;

/* File tags */

#define FLA_Flags   (TLONG|16)
#define FLA_Source  (TAPTR|20)

/****************************************************************************
** Opening flags for Files and Directories.
*/

#define FL_OLDFILE     0
#define FL_WRITE       (1L<<0)
#define FL_EXCLUSIVE   (1L<<1)
#define FL_DATAPROCESS (1L<<2)
#define FL_FIND        (1L<<3)
#define FL_NOUNPACK    (1L<<4)
#define FL_NOBUFFER    (1L<<5)
#define FL_NEWFILE     (1L<<6)
#define FL_ALPHASORT   (1L<<7)
#define FL_READ        (1L<<8)
#define FL_AUTOCREATE  (1L<<9)

#define FL_NOPACK      FL_NOUNPACK

/****************************************************************************
** Permission flags for Files and Directories.
*/

#define FPT_READ     0x00000001
#define FPT_WRITE    0x00000002
#define FPT_EXECUTE  0x00000004
#define FPT_DELETE   0x00000008
#define FPT_SCRIPT   0x00000010
#define FPT_HIDDEN   0x00000020
#define FPT_ARCHIVE  0x00000040
#define FPT_PASSWORD 0x00000080

/****************************************************************************
** Directory Object.  The format/version of the DirEntry and FileEntry
** structures is dependent on the directory version.
*/

#define VER_DIRECTORY  1
#define TAGS_DIRECTORY (ID_SPCTAGS<<16)|ID_DIRECTORY

typedef struct Directory {
  struct Head Head;             /* [00] Standard header */
  struct Directory *ChildDir;   /* [12] First directory in list */
  struct File      *ChildFile;  /* [16] First file in list */
  struct FileName  *Source;     /* [20] Location and Name of this directory */
  LONG   Flags;                 /* [24] Opening Flags (see file flags) */
  struct Directory *Next;       /* [28] Next directory in this list */
  struct Directory *Prev;       /* [32] Previous directory in this list */

  /*** Private fields ***/

  WORD   prvAFlags;
  BYTE   *prvComment;
  struct Time *prvDate;
  struct FileLock *prvLock;
} OBJDirectory;

#define DIRA_Source (TAPTR|20)
#define DIRA_Flags  (TLONG|24)

#endif /* FILES_FILES_H */

