
/***************************************************************************
*==========================================================================*
*=																		  =*
*=				Recursion Test v0.0 © 2022 by Mike Steed				  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Simple program to be profiled				Last modified 19-Aug-21	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 This is a simple program with which to test Profyler and LibProfyle. It
 tests the profiling of recursive function calls.

============================================================================
***************************************************************************/

/***************************************************************************
============================================================================

 This program is public domain software, and is free for use by anyone, with
 no strings attached.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.

============================================================================
***************************************************************************/

/***************************************************************************
*																		   *
* Setup																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Includes ===

#include <exec/types.h>
#include <dos/dos.h>

#include "profyle.h"

#include <stdio.h>

#include <proto/exec.h>

// -------------------------------------------------------------------------
// === Prototypes ===


// -------------------------------------------------------------------------
// === Macros ===


/***************************************************************************
*																		   *
* Data																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Defines ===


// -------------------------------------------------------------------------
// === Locals ===

// The program's version string.
static CONST_STRPTR VerStrg USED_VAR = "$VER: Recursion Test 0.0 " __AMIGADATE__;

// The minimum stack size for the program.
static CONST_STRPTR StackStrg USED_VAR = "$STACK:65536";

// -------------------------------------------------------------------------
// === Globals ===


/***************************************************************************
*																		   *
* Code																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Private code ===

/***************************************************************************

 MyPrintf(String)

 Print a string, with no arguments, to stdout. This is a simple shell around
 printf to allow that library function to be roughly profiled.

 In -----------------------------------------------------------------------

 String = A string to be printed with printf(). No arguments are allowed.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void MyPrintf(STRPTR String)
{
	printf(String);
}

/***************************************************************************

 CR()

 Print a newline to stdout.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void CR(void)
{
	MyPrintf("\n");
}

/***************************************************************************

 Wazzup()

 Print a message to stdout indicating what we're up to.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void Wazzup(void)
{
	MyPrintf("Recursion Test!");
	CR();
}

/***************************************************************************

 Recurse(Limit)

 If the recursion limiter has hit zero, output a newline and return. Other-
 wise output a message, decrement the recursion limiter, and call ourself
 with the new value.

 In -----------------------------------------------------------------------

 Limit = The recursion limit.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void Recurse(int32 Limit)
{
	if(Limit)
	{
		MyPrintf("Recursing...");
		Recurse(--Limit);
	}
	else
	{
		CR();
	}
}

// -------------------------------------------------------------------------
// === Public code ===

/***************************************************************************

 result = main(argc, argv)

 The entry point to the program, called by the compiler's startup code when
 the program is run. If it don't happen here, it don't happen. When this
 routine exits the program terminates.

 In -----------------------------------------------------------------------

 argc = The number of arguments passed to the program when it was run. Will
	always be at least 1 if run from DOS, as the first argument is the name
	of the program itself. If argc is zero, the program was run from the
	Workbench.

 argv = A pointer to an array of pointers -- the number of which is given by
	argc -- to the program's arguments (all ASCIIZ strings). The first arg-
	ument is the name of the program; the remainder were entered by the user.
	If run from Workbench (argc is zero) argv points to a WBStartup message
	that contains (among other things) the program arguments supplied by the
	Workbench.

 Out ----------------------------------------------------------------------

 result = The return code from the program- an error code if non-zero, or
	zero if there were no errors. Ignored if the program was run from the
	Workbench.

***************************************************************************/

int main(int argc, char **argv)
{
	// Let 'em know what we're up to.
	Wazzup();

	// The actual recursion test, with the given recursion limit.
	Recurse(10);

	return(0);
}
