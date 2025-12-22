
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					SetJump Test v0.0 © 2022 by Mike Steed				  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Test profiling with setjmp/longjmp			Last modified 19-Aug-21	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 This is a simple program with which to test Profyler and LibProfyle. It
 tests the response to a setjmp/longjmp operation that bypasses the epilogs
 at the end of the aborted functions. LibProfyle will fix up its profiler
 call stack when this occurs, but as a result none of the aborted functions
 will be profiled.

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
#include <setjmp.h>

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
static CONST_STRPTR VerStrg USED_VAR = "$VER: SetJump Test 0.0 " __AMIGADATE__;

// The minimum stack size for the program.
static CONST_STRPTR StackStrg USED_VAR = "$STACK:65536";

// A buffer for setjmp/longjmp.
static jmp_buf JumpBuf;

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

 JumpFrom()

 Use longjmp() to jump back to JumpTo(). This leaves all the profiler call
 stack entries between here and JumpTo orphaned, aince the epilogs of those
 functions mever execute.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void JumpFrom(void)
{
	MyPrintf("Jumping back!\n");

	// This call returns to the setjmp() call in JumpTo. Comment this line
	// out to see a normal return from all the functions.
	longjmp(JumpBuf, 1);

	// This will not be executed, nor will the epilog at the end of this
	// function.
	MyPrintf("You shouldn't see this.\n");
}

/***************************************************************************

 ThirdFunc()

 A function that uses the call stack after setjmp() returns.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void ThirdFunc(void)
{
	MyPrintf("ThirdFunc\n");
}

/***************************************************************************

 SecondFunc()

 Call the function that uses longjmp().

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void SecondFunc(void)
{
	MyPrintf("SecondFunc...");

	// We don't return from this call.
	JumpFrom();

	// This will not be executed, nor will the epilog at the end of this
	// function.
	MyPrintf("...SecondFunc");
}

/***************************************************************************

 FirstFunc()

 Call another function to further fill the profiler call stack.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void FirstFunc(void)
{
	MyPrintf("FirstFunc...");

	// We won't return from this call.
	SecondFunc();

	// This will not be executed, nor will the epilog at the end of this
	// function.
	MyPrintf("...FirstFunc");
}

/***************************************************************************

 JumpTo()

 Use setjmp() to to fix a point to return to via longjmp(), then call a
 lower-level function to build up the profiler call stack and then to jump
 back from the bottom of it.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void JumpTo(void)
{
	MyPrintf("Setting return point...\n");

	// We'll return from setjmp() twice.
	if(setjmp(JumpBuf))
	{
		// The second return, from longjmp().
		MyPrintf("...Back from the deep!\n");
	}
	else
	{
		// The first return, after the return point is set.
		MyPrintf("Diving down...");

		// We won't return from this call.
		FirstFunc();
	}

	// Do something after the longjmp() returns, but before this function
	// ends. This uses the profiler call stack before it's fixed up by this
	// function's epilog.
	ThirdFunc();
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
	// Set up and execute the longjmp.
	JumpTo();

	// Do something afterwards. This uses the profiler call stack after it's
	// fixed up.
	ThirdFunc();

	return(0);
}
