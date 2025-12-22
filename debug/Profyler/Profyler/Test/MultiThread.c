
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Simple Test v0.0 © 2022 by Mike Steed				  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Simple multi-threaded example				Last modified 08-Sep-21	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 This is a simple program with which to test Profyler and LibProfyle. It
 tests profiling of a multi-threaded application, demonstrating that only
 the main program is profiled, and not the second thread it creates.

 Adapted from the CreateNewProc() example code in the autodocs. OS 4.1 is
 required, but because this is just a test it does not check this.

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
#include <dos/dostags.h>

#include "profyle.h"

#include <stdio.h>

#include <proto/exec.h>
#include <proto/dos.h>

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
static CONST_STRPTR VerStrg USED_VAR = "$VER: Multi-Thread Test 0.0 " __AMIGADATE__;

// The minimum stack size for the program.
static CONST_STRPTR StackStrg USED_VAR = "$STACK:65536";

// -------------------------------------------------------------------------
// === Globals ===

// A semaphore used to synchronize the main program and the child it cre-
// ates, to ensure that the parent does not exit before the child has.
struct SignalSemaphore SyncSem;

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

// -------------------------------------------------------------------------
// === Public code ===

/***************************************************************************

 Child(Args, ArgLen, SysBase)

 This function is launched as a child process of the main program. It forms
 a second thread of execution that runs in parallel with the main program.
 It outputs a message to the parent's console, delays a second, then exits.

 Because this function (and any it calls) run as part of a different pro-
 cess, it/they will not be profiled.

 In -----------------------------------------------------------------------

 Args = A string containing the arguments to the child process, if any.

 ArgLen = The length of the argument string, if any.

 Sysbase = A pointer to Exec's SysBase.

 Out ----------------------------------------------------------------------

 Result = The return code from the child process; use the same values that
	a DOS program would use.

***************************************************************************/

int32 Child(STRPTR *Args, int32 ArgLen, struct ExecBase *Sysbase)
{
	// Output a message to our parent's console.
	MyPrintf("The child says Hello!\n");

	// Add a delay before exiting, to demonstrate that the main program
	// does not exit before the child does.
	IDOS->Delay(50);

	// Return success.
    return(0);
}

/***************************************************************************

 Entry(Sem)

 This function is called just before the child function begins to execute.
 It obtains the semaphore provided by the parent program, which prevents the
 parent from exiting before the child does.

 This function is called from the child's context, and so is not profiled.

 In -----------------------------------------------------------------------

 Sem = A pointer to a SignalSemaphore provided by the main program.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void Entry(struct SignalSemaphore *Sem)
{
    IExec->ObtainSemaphoreShared(Sem);
}


/***************************************************************************

 Final(RC, Sem)

 This function is called just after the child function terminates.  It re-
 leases the semaphore provided by the parent program, allowing the parent
 program to exit now that the child is no longer running.

 This function is called from the child's context, and so is not profiled.

 In -----------------------------------------------------------------------

 RC = A copy of the return code from the child process.

 Sem = A pointer to a SignalSemaphore provided by the main program.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void Final(int32 RC, struct SignalSemaphore *Sem)
{
    IExec->ReleaseSemaphore(Sem);
}

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
	// Initialize the synchronization semaphore.
	IExec->InitSemaphore(&SyncSem);

	// Output a message to let the world know what we're up to.
	MyPrintf("Giving birth to child...\n");

	// Create the child process, which will run in parallel to us. The child
	// shares the resources of the parent, so it has access to the same var-
	// iables, I/O streams, libraries, etc. If this fails we'll continue
	// anyway.
    IDOS->CreateNewProcTags(
		// Run the function Child() as the child process.
		NP_Entry,     Child,
		NP_Child,     TRUE,

		// Set up the process entry hook.
		NP_EntryCode, Entry,
		NP_EntryData, &SyncSem,

		// Set up the process exit hook.
		NP_FinalCode, Final,
		NP_FinalData, &SyncSem,

		TAG_DONE);

	// Try to obtain the synchronization semaphore. This will cause us to
	// go to sleep until the child task unlocks the semaphore as it exits.
	// Add a bit of delay first, to allow the child to get going. Otherwise
	// we'll obtain the semaphore before the child can do so.
	IDOS->Delay(1);
	IExec->ObtainSemaphore(&SyncSem);

	// The semaphore is ours, so the child task must have exited.
	IExec->ReleaseSemaphore(&SyncSem);

	// Output a message to let the world know that we're done.
	MyPrintf("The child has died.\n");

	return(0);
}

