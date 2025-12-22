
/***************************************************************************
*==========================================================================*
*=																		  =*
*=				Exception Test v0.0 © 2022 by Mike Steed				  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Test profiling with C++ exceptions			Last modified 19-Aug-21	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 This is a simple program with which to test Profyler and LibProfyle. It
 tests the operation of C++ exception handling, and confirms that unlike
 setjmp/longjmp, throwing an exception does not bypass the epilogs of abort-
 ed functions. Thus LibProfyle does not need to fix up the profiler call
 stack, and is able to profile the aborted functions.

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
static CONST_STRPTR VerStrg USED_VAR = "$VER: Exception Test 0.0 " __AMIGADATE__;

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

 Yes, cout would be a more C++ way of outputting, but it also bloats this
 simple program (with its debug data) to multi-megabyte size.

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

 ThrowException()

 Throw an exception to be caught by TryCatch().

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void ThrowException()
{
	MyPrintf((STRPTR)"Throwing exception!\n");

	// This call returns to the catch(...) call in TryThrow. Comment this
	// line out to see a normal return from all the functions.
	throw 1;

	// This will not be executed; however the epilog at the end of the func-
	// tion does execute.
	MyPrintf((STRPTR)"You shouldn't see this.\n");
}

/***************************************************************************

 ThirdFunc()

 A function that uses the call stack after the exception is caught.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void ThirdFunc()
{
	MyPrintf((STRPTR)"ThirdFunc\n");
}

/***************************************************************************

 SecondFunc()

 Call the function that throws the exception.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void SecondFunc()
{
	MyPrintf((STRPTR)"SecondFunc...");

	// We don't return from this call.
	ThrowException();

	// This will not be executed; however the epilog at the end of the func-
	// tion does execute.
	MyPrintf((STRPTR)"...SecondFunc");
}

/***************************************************************************

 FirstFunc()

 Call another function to further fill the profiler call stack.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void FirstFunc()
{
	MyPrintf((STRPTR)"FirstFunc...");

	// We won't return from this call.
	SecondFunc();

	// This will not be executed; however the epilog at the end of the func-
	// tion does execute.
	MyPrintf((STRPTR)"...FirstFunc");
}

/***************************************************************************

 TryCatch()

 Set up to catch exceptions, then call a lower-level function to build up
 the profiler call stack and throw an exception from the bottom of it.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void TryCatch()
{
	MyPrintf((STRPTR)"Setting up to catch exceptions...\n");

	// Catch any exceptions thrown from within this block of code.
	try
	{
		MyPrintf((STRPTR)"Diving down...");

		// We won't return from this call.
		FirstFunc();
	}

	// Catch all exceptions thrown from within the try block, regardless of
	// type.
	catch(...)
	{
		MyPrintf((STRPTR)"...Back from the deep!\n");
	}

	// Do something after the exception is caught, but before this function
	// ends.
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
	// Set up and execute the exception handling.
	TryCatch();

	// Do something afterwards.
	ThirdFunc();

	return(0);
}
