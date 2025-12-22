/****************************************************************************
*
* $RCSfile: garbage.c $
* $Revision: 1.0 $
* $Date: 1996/12/01 06:28:53 $
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
* garbage.c -- Garbage collector library functions
*
* This file contains all the garbage collector functions.  Each externally
* available function is documented using the standard AutoDoc format.
*
* The garbage collector is a simple way of tracking system resources.  Most
* importantly, it will handle all the details of resource deallocation at
* any time.  For example, you can open several libraries and then close
* all the libraries in one function call.  This is especially important
* in an error condition.  The garbage collector will also let you explicitly
* free resources when they are not needed any more without flushing the
* entire collection at once.
*
* There are two function calls required to control the garbage collector:
* createGarbageCollector() and deleteGarbageCollector().
*
* The remaining function calls are simple extensions to the standard OS
* function calls with the extra "collector" pointer added.  In this way,
* the operating system remains unpatched and the user has complete control
* over the garbage collection.  For example, the user may want to use a
* separate garbage collection for each requester and then a final collection
* to control everything.
*/
#include <exec/memory.h>
#include <exec/nodes.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include "garbage.h"


/*** Resource types ***/
#define COLLECTOR	((RESOURCE_TYPE)0)	/* garbage collector! */
#define LIBRARY		((RESOURCE_TYPE)1)	/* system library */
#define MEMORY		((RESOURCE_TYPE)2)	/* memory allocation */


/*** Resource strings ***/
const STRPTR COLLECTOR_STR		= "Garbage Collector";
const STRPTR LIBRARY_STR		= "Library";
const STRPTR MEMORY_STR			= "Memory";
const STRPTR UNKNOWN_STR		= "Unknown";

const STRPTR PRINT_FMT_STR		= "%4lu) %s\n";


/****** garbage.lib/createGarbageCollector **********************************
*
*   NAME
*   createGarbageCollector -- Create a garbage collector.
*
*   SYNOPSIS
*   gc = createGarbageCollector(parent, tags)
*
*   struct garbageCollector *createGarbageCollector
*       (struct garbageCollector *, struct TagItem *);
*
*   FUNCTION
*   Create a garbage collector to control the garbage.  Each garbage
*   collection requires one garbage collector to look after it.
*
*   INPUTS
*   parent - Parent garbage collector (may be NULL).
*   tags   - List of tags which alter the garbage collector's behaviour
*            (may be NULL).
*
*   RESULT
*   gc - Pointer to a newly created garbage collector or NULL on error.
*
*   BUGS
*   No known bugs.
*
*   SEE ALSO
*   deleteGarbageCollector()
*
*****************************************************************************
*
*/
struct garbageCollector *createGarbageCollector(
	struct garbageCollector *collector, struct TagItem *tags)
{
	garbageItem *item;
	struct garbageCollector *new_collector;

	new_collector = AllocVec(sizeof(struct garbageCollector), MEMF_ANY);
	if ( new_collector != NULL )  {
		NewList(&new_collector->gc_Garbage);
		new_collector->gc_ParentItem = NULL;

		if ( collector != NULL )  {
			item = AllocVec(sizeof(garbageItem), MEMF_ANY);
			if ( item == NULL )  {
				FreeVec(new_collector);
				return(NULL);
			}

			item->gi_Node.ln_Succ	= NULL;
			item->gi_Node.ln_Pred	= NULL;
			item->gi_Node.ln_Type	= NT_USER;
			item->gi_Node.ln_Pri	= 0;
			item->gi_Node.ln_Name	= NULL;
			item->gi_Type			= COLLECTOR;
			item->gi_Resource		= (APTR)new_collector;

			AddHead(&collector->gc_Garbage, (struct Node*)item);
			new_collector->gc_ParentItem = item;
		}
	}

	return(new_collector);
}


/****** garbage.lib/deleteGarbageCollector **********************************
*
*   NAME
*   deleteGarbageCollector -- Delete a garbage collector.
*
*   SYNOPSIS
*   deleteGarbageCollector(collector)
*
*   VOID deleteGarbageCollector(struct garbageCollector *);
*
*   FUNCTION
*   Deletes a garbage collector and frees all associated resources.  If the
*   garbage collector has child garbage collectors, those collectors are
*   freed also.
*
*   INPUTS
*   collector - Pointer to a valid garbage collector or NULL.
*
*   BUGS
*   No known bugs.
*
*   SEE ALSO
*   createGarbageCollector(), freeGarbage()
*
*****************************************************************************
*
*/
VOID deleteGarbageCollector(struct garbageCollector *collector)
{
	if ( collector != NULL )  {
		freeGarbage(collector);

		if ( collector->gc_ParentItem != NULL )  {
			Remove((struct Node*)collector->gc_ParentItem);
			FreeVec(collector->gc_ParentItem);
		}

		FreeVec(collector);
	}
}


/****** garbage.lib/openLibrary *********************************************
*
*   NAME
*   openLibrary -- Gain access to a library.
*
*   SYNOPSIS
*   library = openLibrary(collector, lib_name, version)
*
*   struct Library *openLibrary(struct garbageCollector *, STRPTR, ULONG);
*
*   FUNCTION
*   This function is an direct extension of the OpenLibrary() function.
*   It behaves exactly like the Exec function call with the addition of
*   garbage control.
*
*   INPUTS
*   collector - Pointer to a valid garbage collector (may be NULL).
*   lib_name  - Name of the library to open (may be NULL).
*   version   - Minimum version number of the library to open.
*
*   RESULT
*   library - Pointer to the library.
*
*   BUGS
*   No known garbage collector bugs.
*   See the OpenLibrary() autodoc for more information.
*
*   SEE ALSO
*   closeLibrary(), exec.library/OpenLibrary()
*
*****************************************************************************
*
*/
struct Library *openLibrary(struct garbageCollector *collector,
	STRPTR library_name, ULONG min_version)
{
	garbageItem *item;
	struct Library *library;

	if ( collector == NULL || library_name == NULL )
		return(NULL);

	library = OpenLibrary(library_name, min_version);

	if ( library != NULL )  {
		item = AllocVec(sizeof(garbageItem), MEMF_ANY);
		if ( item == NULL )  {
			CloseLibrary(library);
			return(NULL);
		}

		item->gi_Node.ln_Succ	= NULL;
		item->gi_Node.ln_Pred	= NULL;
		item->gi_Node.ln_Type	= NT_USER;
		item->gi_Node.ln_Pri	= 0;
		item->gi_Node.ln_Name	= NULL;
		item->gi_Type			= LIBRARY;
		item->gi_Resource		= (APTR)library;

		AddHead(&collector->gc_Garbage, (struct Node*)item);
	}

	return(library);
}


/****** garbage.lib/closeLibrary ********************************************
*
*   NAME
*   closeLibrary -- Conclude access to a library.
*
*   SYNOPSIS
*   closeLibrary(collector, library)
*
*   VOID closeLibrary(struct garbageCollector *, struct Library *);
*
*   FUNCTION
*   This function is an direct extension of the CloseLibrary() function.
*   It behaves exactly like the Exec function call with the addition of
*   garbage control.
*
*   INPUTS
*   collector - Pointer to a valid garbage collector (may be NULL).
*   library   - Pointer to the library to close (may be NULL).
*
*   NOTES
*   This function does not attempt to find the collector in charge of the
*   library resource when collectors are nested.  You must specify the
*   collector in control of the library to be closed.
*
*   BUGS
*   No known bugs.
*
*   SEE ALSO
*   openLibrary(), exec.library/CloseLibrary()
*
*****************************************************************************
*
*/
VOID closeLibrary(struct garbageCollector *collector,
	struct Library *library)
{
	struct Node *node;
	garbageItem *item;

	if ( collector == NULL || library == NULL )
		return;

	node = collector->gc_Garbage.lh_Head;
	while ( node->ln_Succ != NULL )  {
		item = (garbageItem*)node;

		if ( item->gi_Type == LIBRARY && item->gi_Resource == (APTR)library )  {
			CloseLibrary(library);
			Remove(node);
			FreeVec(item);
		}

		node = node->ln_Succ;
	}
}


/****** garbage.lib/allocVec ************************************************
*
*   NAME
*   allocVec -- Allocate memory and keep track of the size.
*
*   SYNOPSIS
*   memory = allocVec(collector, size, attributes)
*
*   APTR allocVec(struct garbageCollector *, ULONG, ULONG);
*
*   FUNCTION
*   This function is an direct extension of the AllocVec() function.
*   It behaves exactly like the Exec function call with the addition of
*   garbage control.  See the AllocVec() autodoc for more information.
*
*   INPUTS
*   collector  - Pointer to a garbage collector (may be NULL).
*   size       - Size of the memory block to allocate (in bytes).
*   attributes - Attributes of the memory block to be allocated.
*
*   RESULT
*   memory - Pointer to the allocated memory block or NULL on error.
*
*   BUGS
*   No known bugs.
*
*   SEE ALSO
*   freeVec(), exec.library/AllocVec()
*
*****************************************************************************
*
*/
APTR allocVec(struct garbageCollector *collector, ULONG size,
	ULONG attributes)
{
	garbageItem *item;
	APTR memory;

	if ( collector == NULL )
		return(NULL);

	memory = AllocVec(size, attributes);
	if ( memory != NULL )  {
		item = AllocVec(sizeof(garbageItem), MEMF_ANY);
		if ( item == NULL )  {
			FreeVec(memory);
			return(NULL);
		}

		item->gi_Node.ln_Succ	= NULL;
		item->gi_Node.ln_Pred	= NULL;
		item->gi_Node.ln_Type	= NT_USER;
		item->gi_Node.ln_Pri	= 0;
		item->gi_Node.ln_Name	= NULL;
		item->gi_Type			= MEMORY;
		item->gi_Resource		= memory;

		AddHead(&collector->gc_Garbage, (struct Node*)item);
	}

	return(memory);
}


/****** garbage.lib/freeVec *************************************************
*
*   NAME
*   freeVec -- Return allocVec() memory to the system.
*
*   SYNOPSIS
*   freeVec(collector, memory)
*
*   VOID freeVec(struct garbageCollector *, APTR);
*
*   FUNCTION
*   This function is an direct extension of the FreeVec() function.
*   It behaves exactly like the Exec function call with the addition of
*   garbage control.  See the FreeVec() autodoc for more information.
*
*   INPUTS
*   collector - Pointer to a garbage collector (may be NULL).
*   memory    - Pointer to the memory block to be freed (may be NULL).
*
*   BUGS
*   No known bugs.
*
*   SEE ALSO
*   allocVec(), exec.library/FreeVec()
*
*****************************************************************************
*
*/
VOID freeVec(struct garbageCollector *collector, APTR memory)
{
	struct Node *node;
	garbageItem *item;

	if ( collector == NULL || memory == NULL )
		return;

	node = collector->gc_Garbage.lh_Head;
	while ( node->ln_Succ != NULL )  {
		item = (garbageItem*)node;

		if ( item->gi_Type == MEMORY && item->gi_Resource == memory )  {
			FreeVec(memory);
			Remove(node);
			FreeVec(item);
		}

		node = node->ln_Succ;
	}
}


/****** garbage.lib/printGarbage ********************************************
*
*   NAME
*   printGarbage -- Prints garbage collection to a file.
*
*   SYNOPSIS
*   count = printGarbage(collector, file_handle)
*
*   LONG printGarbage(struct garbageCollector *, BPTR);
*
*   FUNCTION
*   This function prints the contents of a garbage collection to the given
*   file handle.  The output includes what position and type of each
*   resource in reverse allocation order.
*
*   INPUTS
*   collector   - Pointer to a garbage collector (may be NULL).
*   file_handle - File handle (may be NULL).
*
*   RESULT
*   count - The number of bytes output or -1 on error.
*
*   EXAMPLE
*   The following is the output from the allocation of two libraries and one
*   block of memory (in that order):
*       1) Memory
*       2) Library
*       3) Library
*
*   NOTES
*   This function does not recursively follow a garbage collector tree.
*
*   BUGS
*   No known bugs.
*
*   SEE ALSO
*
*****************************************************************************
*
*/
LONG printGarbage(struct garbageCollector *collector, BPTR file_handle)
{
	IMPORT struct DOSBase *DOSBase;
	struct Node *node;
	garbageItem *item;
	STRPTR type_str;
	ULONG i;
	LONG count;

	if ( collector == NULL || file_handle == NULL )
		return(-1);

	i = 1;
	count = 0;
	node = collector->gc_Garbage.lh_Head;
	while ( node->ln_Succ != NULL )  {
		item = (garbageItem*)node;

		switch ( item->gi_Type )  {
			case COLLECTOR:	type_str = COLLECTOR_STR;	break;
			case LIBRARY:	type_str = LIBRARY_STR;		break;
			case MEMORY:	type_str = MEMORY_STR;		break;
			default:		type_str = UNKNOWN_STR;
		}

		count += FPrintf(file_handle, PRINT_FMT_STR, i, type_str);

		i++;
		node = node->ln_Succ;
	}

	return(count);
}


/****** garbage.lib/freeGarbage *********************************************
*
*   NAME
*   freeGarbage -- Free a garbage collection.
*
*   SYNOPSIS
*   freeGarbage(collector)
*
*   VOID freeGarbage(struct garbageCollector *);
*
*   FUNCTION
*   This function frees a garbage collection held by the specified garbage
*   collector.  The garbage collector itself is not freed by this function.
*   This allows the reuse of garbage collectors.  To delete the garbage
*   collector itself, use the deleteGarbageCollector() function.
*
*   Any child garbage collectors will also be automatically freed.
*
*   INPUTS
*   collector - Pointer to a garbage collector (may be NULL).
*
*   BUGS
*   No known bugs.
*
*   SEE ALSO
*   deleteGarbageCollector()
*
*****************************************************************************
*
*/
VOID freeGarbage(struct garbageCollector *collector)
{
	struct Node *node;
	garbageItem *item;

	if ( collector == NULL )
		return;

	node = collector->gc_Garbage.lh_Head;
	while ( (node = RemHead(&collector->gc_Garbage)) != NULL )  {
		item = (garbageItem*)node;

		if ( item->gi_Resource != NULL )  {
			switch ( item->gi_Type )  {
				case COLLECTOR:
					freeGarbage((struct garbageCollector*)item->gi_Resource);
					FreeVec(item->gi_Resource);
					break;
				case LIBRARY:
					CloseLibrary((struct Library*)item->gi_Resource);
					break;
				case MEMORY:
					FreeVec(item->gi_Resource);
					break;
			}
		}

		FreeVec(item);
	}
}
