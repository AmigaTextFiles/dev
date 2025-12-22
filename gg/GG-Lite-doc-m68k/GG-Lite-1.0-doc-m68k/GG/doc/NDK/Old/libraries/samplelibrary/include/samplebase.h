/*
 *
 * samplebase.h -- C include file defining sample.library base
 *
 * Copyright (C) 1985, 1988 Commodore Amiga Inc.  All rights reserved.
 *
 */

#ifndef SAMPLE_BASE_H
#define SAMPLE_BASE_H

#ifndef  EXEC_TYPES_H
#include  <exec/types.h>
#endif   EXEC_TYPES_H

#ifndef  EXEC_LISTS_H
#include  <exec/lists.h>
#endif   EXEC_LISTS_H

#ifndef  EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif   EXEC_LIBRARIES_H

/* library data structures
 *
 *  Note that the library base begins with a library node
 */

struct SampleBase {
   struct Library LibNode;
   UBYTE  Flags;
   UBYTE  pad;
   /* We are now longword aligned */
   ULONG  SysLib;
   ULONG  DosLib;
   ULONG  SegList;
   };


#define SAMPLENAME   "sample.library"

#endif EXEC_SAMPLEBASE_H
