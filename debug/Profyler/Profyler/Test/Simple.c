
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Simple Test v0.0 © 2022 by Mike Steed				  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Simple program to be profiled				Last modified 10-Jan-22	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 This is a simple program with which to test Profyler and LibProfyle. It
 demonstrates basic profiling functionality, including the PROFILE_PAUSE and
 PROFILE_RESUME macros.

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
static CONST_STRPTR VerStrg USED_VAR = "$VER: Simple Test 0.0 " __AMIGADATE__;

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

 Space()

 Print a space to stdout.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void Space(void)
{
	MyPrintf(" ");
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

 Hello()

 Print "Hello" to stdout, followed by a space.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void Hello(void)
{
	MyPrintf("Hello");
	Space();
}

/***************************************************************************

 World!()

 Print "World!" to stdout, followed by a newline.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void World(void)
{
	MyPrintf("World!");
	CR();
}

/***************************************************************************

 Null()

 Do nothing. This should represent the smallest (and fastest) possible
 function. For even greater speed the function is inlined, though compiling
 with -finstrument-functions prevents this from occurring. Inline functions
 may need to be declared static when using -finstrument-functions to avoid
 compiler errors.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static inline void Null(void)
{
}

/***************************************************************************

 AlsoNull()

 Do nothing. This should represent the smallest (and fastest) possible
 function. For even greater speed the function is inlined, though compiling
 with -finstrument-functions prevents this from occurring. Inline functions
 may need to be declared static when using -finstrument-functions to avoid
 compiler errors.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static inline void AlsoNull(void)
{
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
	// Print "Hello World!" to the console.
	Hello();
	Null();
	AlsoNull();
	World();

	// Wait for a break (CTRL-C) before continuing. Disable profiling during
	// the wait, so it won't affect the profile times.
	PROFILE_PAUSE;
	IExec->Wait(SIGBREAKF_CTRL_C);
	PROFILE_RESUME;

	return(0);
}
