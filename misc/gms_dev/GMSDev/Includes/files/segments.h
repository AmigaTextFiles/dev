#ifndef FILES_SEGMENTS_H
#define FILES_SEGMENTS_H TRUE

/*
**   $VER: segments.h (June 1998)
**
**   Segment Definitions.
**
**   (C) Copyright 1996-1998 DreamWorld Productions.
**       All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/****************************************************************************
** Segment object.
*/

#define VER_SEGMENT  2
#define TAGS_SEGMENT (ID_SPCTAGS<<16)|ID_SEGMENT

typedef struct Segment {
  struct Head Head;        /* [00] Standard structure header */
  struct Segment *Prev;    /* [12] Previous segment */
  struct Segment *Next;    /* [16] Next segment */
  LONG   MemType;          /* [20] Memory type (eg MEM_DATA) */
  APTR   Address;          /* [24] Pointer to segment start */
  struct FileName *Source; /* [28] Source of segment */
  WORD   CPU;              /* [32] The CPU type if it is a MEM_CODE segment */
  WORD   emp;              /* [34] */
  LONG   Size;             /* [36] Total size of the segment in bytes */

  /* Private fields below */

  APTR   prvDOSSeg;
} OBJ_SEGMENT;

#define SGA_Prev    (12|TAPTR)
#define SGA_Next    (16|TAPTR)
#define SGA_MemType (20|TLONG)
#define SGA_Address (24|TAPTR)
#define SGA_Source  (28|TAPTR)
#define SGA_CPU     (32|TWORD)
#define SGA_Size    (36|TLONG)

/****************************************************************************
** This structure is identical to the standard segment struct but defines
** the Address as a function (ANSI-C prevents function<->data type
** conversion).
*/

typedef struct CodeSegment {
  struct Head Head;
  struct Segment *Prev;
  struct Segment *Next;
  LONG   MemType;
  LIBPTR void (*Address)(mreg(__d0) LONG ID, mreg(__d1) LONG Version,
           mreg(__d2) LONG Revision, mreg(__a1) struct DPKBase *DPKBase,
           mreg(__a0) BYTE *Arguments);
  struct FileName *Source;

  /*** Private fields below ***/

  APTR   prvDOSSeg;
} OBJ_CODESEGMENT;

#endif /* FILES_SEGMENTS_H */
