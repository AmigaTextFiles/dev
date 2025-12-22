/*
**   $VER: segments.e V1.0
**
**   Segment Definitions.
**
**   (C) Copyright 1996-1998 DreamWorld Productions.
**       All Rights Reserved.
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register','gms/misc/time'
MODULE 'gms/files/files'

/****************************************************************************
** Segment object.
*/

CONST VER_SEGMENT  = 1,
      TAGS_SEGMENT = $FFFB0000 OR ID_SEGMENT

OBJECT segment
  head[1] :ARRAY OF head     /* 00: Standard structure header */
  prev    :PTR TO segment    /* 12: Previous segment */
  next    :PTR TO segment    /* 16: Next segment */
  memtype :LONG              /* 20: Memory type (eg MEM_DATA) */
  address :PTR TO CHAR       /* 24: Pointer to segment start */
  source  :PTR TO filename   /* 28: Source of segment */
  cpu     :INT               /* 32: The CPU type if it is a MEM_CODE segment */
ENDOBJECT

CONST SGA_Prev    = 12 OR TAPTR,
      SGA_Next    = 16 OR TAPTR,
      SGA_MemType = 20 OR TLONG,
      SGA_Source  = 28 OR TAPTR,
      SGA_CPU     = 32 OR TWORD
