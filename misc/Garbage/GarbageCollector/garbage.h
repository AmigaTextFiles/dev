/****************************************************************************
*
* $RCSfile: garbage.h $
* $Revision: 1.0 $
* $Date: 1996/12/01 06:29:10 $
* $Author: ssolie $
*
*****************************************************************************
*
* Copyright (c) 1996 Software Evolution.  All Rights Reserved.
*
* You are hereby granted the right to copy and distribute verbatim copies of
* this program if the contents are preserved and remain unchanged.  You are
* not permitted to use any portion of the program source code in any product
* or service being sold for profit without the prior written concent from
* its author.
*
* No guarantee or warranty of any kind is given.  Use at your own risk.
*
*****************************************************************************
*
* garbage.h -- Garbage Collector header file
*
* This header file contains all the definitions and function prototypes
* needed to use the garbage collector library.
*/
#ifndef GARBAGE_COLLECTOR_H
#define GARBAGE_COLLECTOR_H

#include <dos/dos.h>
#include <exec/types.h>
#include <exec/lists.h>
#include <utility/tagitem.h>


/*** Datatype definitions ***/
typedef ULONG RESOURCE_TYPE;		/* type of resource */

typedef struct {
	struct Node		gi_Node;		/* embedded node */
	RESOURCE_TYPE	gi_Type;		/* type of resource */
	APTR			gi_Resource;	/* pointer to the resource */
} garbageItem;


struct garbageCollector {
	struct List gc_Garbage;			/* list of garbage */
	garbageItem *gc_ParentItem;		/* pointer to parent item or NULL */
};


/*** Function prototypes ***/
struct garbageCollector *createGarbageCollector(
	struct garbageCollector *collector, struct TagItem *tags);
VOID deleteGarbageCollector(struct garbageCollector *collector);
struct Library *openLibrary(struct garbageCollector *collector,
	STRPTR library_name, ULONG min_version);
VOID closeLibrary(struct garbageCollector *collector,
	struct Library *library);
APTR allocVec(struct garbageCollector *collector, ULONG size,
	ULONG attributes);
VOID freeVec(struct garbageCollector *collector, APTR memory);
LONG printGarbage(struct garbageCollector *collector, BPTR file_handle);
VOID freeGarbage(struct garbageCollector *collector);


#endif
