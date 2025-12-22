#ifndef LIBRARIES_VMEM_H
#define LIBRARIES_VMEM_H

/*
**	$Filename: libraries/vmemory.h $
**	$Release: 1.0 $
**
**	(?) Copyright 1996 A.C.M. the Assembler-Magician
**	    All Rights Reserved
*/
   
#ifndef	EXEC_TYPES_H
#include	<exec/types.h>
#endif	/* EXEC_TYPES_H */

#ifndef	EXEC_LISTS_H
#include	<exec/lists.h>
#endif	/* EXEC_LISTS_H */

#ifndef	EXEC_LIBRARIES_H
#include	<exec/libraries.h>
#endif	/* EXEC_LIBRARIES_H */

#define VMEMORYNAME    "vmemory.library"
#define VMEMORYVERSION 1L

struct VMemoryBase {
  struct Library LibNode;
  APTR SysLib;
  APTR DosLib;			/* Read only - Pointer to Doslibrary */
  APTR TBase;			/* Read only - Pointer to EntryTable */
  ULONG TCount;                 /* Read only - How much Entries */
  APTR NEntry;                  /* Read only - Pointer to next clear Entry */
  ULONG NIndex;                 /* Read only - Number of next clear Entry  */
  ULONG OldIndex;               /* Read only - Last Entry wich was written */
  APTR PagePath;                /* Read only - Pointer to Path of Pages */
  APTR RenPath;			/* Read only - Pointer to OldRenamename */
  APTR PageName;                /* Read only - Pointer to Name of Prefsfile */
  APTR SegList;
  UBYTE Flags;
  UBYTE Pad;
};

/*
* Structure of VMemoryEntry
* The Pagename of the Memblock is a simply Data-File, wich was created
* with the dos.library.
* The name is the Path, who was found in PagePath + ASCII-Value of the Index.
*/

struct VMemoryEntry {

  ULONG Index;			/* Index of the Entry */
  ULONG Size;			/* Size of the Memory-Block */
  APTR Adresse;			/* Adress, from where the Block was copied */
};

/* Errors for the VMemoryLibrary */

#define VMEM_OK       	    0L		/* All OK .. */
#define VMEM_TABLEFULL     -1L          /* No more Entries possible */
#define VMEM_NOPREFSFILE   -2L          /* No Prefs-File was created */
#define VMEM_NOSTARTMEMORY -3L          /* No StartMemory for Entries */ 
#define VMEM_NOFILEOPEN    -4L		/* No such File found */
#define VMEM_FAILWRITE     -5L		/* Failure at Write MemBlock */
#define VMEM_NOEMPTYENTRY  -6L		/* No Empty Entry found */
#define VMEM_NOENTRYFREED  -7L		/* No such Entry exists */
#define VMEM_FAILREAD      -8L		/* Failure at Read MemBlock */
#define VMEM_NOENTRYFOUND  -9L		/* No such Entry found */
#define VMEM_PAGEOCCUPIED  -10L		/* Entry is occupied */
#endif
