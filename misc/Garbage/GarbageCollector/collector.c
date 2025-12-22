/****************************************************************************
*
* $RCSfile: collector.c $
* $Revision: 1.0 $
* $Date: 1996/12/01 06:28:41 $
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
* collector.c -- Garbage collector function testing suite
*
* This program fully tests the garbage collector function library.  It
* uses all of the functions in the garbage collector library and is a good
* example on how to fully utilize the garbage collector.
*
* All output is to stdout.
*/
#include <exec/memory.h>
#include <clib/dos_protos.h>
#include <pragmas/dos_pragmas.h>
#include "garbage.h"


/*** Local function prototypes ***/
VOID main(VOID);
VOID test_garbage(struct garbageCollector *collector);
VOID test_library(struct garbageCollector *collector);
VOID test_memory(struct garbageCollector *collector);


/*** Global variables ***/
IMPORT struct DOSBase *DOSBase;


/*
 * main -- Main program entry point
 *
 * This function drives the lower level test functions.
 */
VOID main(VOID)
{
	struct garbageCollector *main_collector;

	Printf("Garbage Collector Library Test Suite\n");
	Printf("\n");

	Printf("This program tests the following functions:\n");
	Printf("\tcreateGarbageCollector()\n");
	Printf("\tdeleteGarbageCollector()\n");
	Printf("\tfreeGarbage()\n");
	Printf("\tprintGarbage()\n");
	Printf("\topenLibrary()\n");
	Printf("\tcloseLibrary()\n");
	Printf("\tallocVec()\n");
	Printf("\tfreeVec()\n");
	Printf("\n");

	Printf("calling createGarbageCollector()...\n");
	main_collector = createGarbageCollector(NULL, NULL);
	if ( main_collector == NULL )  {
		Printf("\tFailed!\n");
		return;
	}
	Printf("Done.\n");

	test_library(main_collector);
	test_memory(main_collector);
	test_garbage(main_collector);

	Printf("calling deleteGarbageCollector()...\n");
	deleteGarbageCollector(main_collector);
	Printf("Done.\n");
}


/*
 * test_garbage -- Test Garbage related functions
 *
 * This function tests the Garbage related functions.  It is most useful
 * to call this function after there is something in the collection.
 */
VOID test_garbage(struct garbageCollector *collector)
{
	struct garbageCollector *sub_collector;
	struct garbageCollector *sub_sub_collector;

	Printf("calling printGarbage()...\n");
	printGarbage(collector, Output());
	Printf("Done.\n");

	Printf("calling createGarbageCollector()...\n");
	sub_collector = createGarbageCollector(collector, NULL);
	Printf("Done.\n");

	Printf("calling createGarbageCollector()...\n");
	sub_sub_collector = createGarbageCollector(sub_collector, NULL);
	Printf("Done.\n");

	test_memory(sub_collector);
	test_memory(sub_sub_collector);

	Printf("calling printGarbage()...\n");
	Printf("main:\n");
	printGarbage(collector, Output());
	Printf("sub:\n");
	printGarbage(sub_collector, Output());
	Printf("Done.\n");
	Printf("sub sub:\n");
	printGarbage(sub_sub_collector, Output());
	Printf("Done.\n");

	Printf("calling deleteGarbageCollector()...\n");
	deleteGarbageCollector(sub_collector);
	Printf("Done.\n");

	Printf("calling printGarbage()...\n");
	printGarbage(collector, Output());
	Printf("Done.\n");

	Printf("calling freeGarbage()...\n");
	freeGarbage(collector);
	Printf("Done.\n");

	Printf("calling printGarbage()...\n");
	printGarbage(collector, Output());
	Printf("Done.\n");
}


/*
 * test_memory -- Test garbage collector memory functions
 *
 * This function tests the garbage collector memory functions.
 */
VOID test_memory(struct garbageCollector *collector)
{
	APTR chunk1, chunk2, chunk3;

	Printf("calling allocVec()...\n");
	chunk1 = allocVec(collector, (ULONG)1024, MEMF_CHIP);
	chunk2 = allocVec(collector, (ULONG)1024, MEMF_FAST);
	chunk3 = allocVec(collector, (ULONG)1024, MEMF_PUBLIC);
	Printf("Done.\n");
}


/*
 * test_library -- Test garbage collector library functions
 *
 * This function tests the garbage collector library functions.
 */
VOID test_library(struct garbageCollector *collector)
{
	struct Library *lib1, *lib2, *lib3;

	Printf("calling openLibrary()...\n");
	lib1 = openLibrary(collector, "graphics.library", (ULONG)0);
	lib2 = openLibrary(collector, "layers.library", (ULONG)0);
	lib3 = openLibrary(collector, "gadtools.library", (ULONG)0);
	Printf("Done.\n");
}
