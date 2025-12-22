
/***************************************************************************
*==========================================================================*
*=																		  =*
*=				StructorPlus Test v0.0 © 2022 by Mike Steed				  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Test profiling of C++ con/destructors		Last modified 09-Dec-21	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 This is a simple program with which to test Profyler and LibProfyle. It
 tests profiling of C++ constructors and destructors, including those that
 run at global scope.

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

// A simple test class with a constructor and a destructor.
class TestClass {
	// Data
	uint32 Dummy;

public:
	// Methods
	TestClass();
	~TestClass();
};

// -------------------------------------------------------------------------
// === Locals ===

// The program's version string.
static CONST_STRPTR VerStrg USED_VAR = "$VER: StructorPlus Test 0.0 " __AMIGADATE__;

// The minimum stack size for the program.
static CONST_STRPTR StackStrg USED_VAR = "$STACK:65536";

// -------------------------------------------------------------------------
// === Globals ===

// Create a global instance of our test class. The constructor is invoked
// before main() runs, and the destructor is invoked after main() exits.
TestClass TheGlobalClass;

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

 TestClass Constructor

 Send greetings from the class constructor to stdout.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

TestClass::TestClass()
{
	MyPrintf((STRPTR)"Hello from class constructor!\n");
}

/***************************************************************************

 TestClass Destructor

 Send greetings from the class destructor to stdout.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

TestClass::~TestClass()
{
	MyPrintf((STRPTR)"Hello from class destructor!\n");
}

/***************************************************************************

 Hello()

 Send greetings from the main program to stdout.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void Hello(void)
{
	MyPrintf((STRPTR)"Hello from main!\n");
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
	TestClass *TheClass;

	// Create a local instance of our test class, which will invoke the
	// class constructor.
	TheClass = new TestClass;

	// Say Hello!
	Hello();

	// Destroy the local instance of our test class, which will invoke the
	// class destructor.
	delete TheClass;

	return(0);
}
