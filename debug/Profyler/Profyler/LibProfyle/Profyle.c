
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Profyler v1.0 © 2022 by Mike Steed					  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	LibProfyle Code								Last modified 10-Jan-22	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 This is the code for LibProfyle. This library gets linked into the program
 to be profiled (the target), and performs the tracking and timing of the
 program's functions. The data it collects is made available to an external
 application (Profyler) for analysis and display to the user.

 Most of the library functions are automatically linked into the target pro-
 gram, with no source code changes required. The "prolog" and "epilog" func-
 tions are automatically called by the compiler when the target is compiled
 with the '-finstrument-functions' option. That pulls in the constructor and
 destructor functions that set up and take down the profiling functionality;
 they are automatically executed by the target's startup and shutdown code.

 Only the functions that pause and resume profiling need to be manually call-
 ed by the target, via macros. They get linked in whether or not they're
 used, but they're small and after all, are only present when profiling.

============================================================================
***************************************************************************/

/***************************************************************************
============================================================================

 This library is free software; you can redistribute it and/or modify it
 under the terms of the GNU Lesser General Public License as published by
 the Free Software Foundation; either version 2.1 of the License, or (at
 your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FIT-
 NESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
 for more details.

 You should have received a copy of the GNU Lesser General Public License
 along with this library; if not, write to the Free Software Foundation,
 Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

============================================================================
***************************************************************************/

/***************************************************************************
*																		   *
* Setup																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Includes ===

#define __NOLIBBASE__			// we want to manage libraries ourself
#define __NOGLOBALIFACE__		// same for interfaces

// If set to a non-zero value, the raw profile data will be dumped to stdout
// when the destructor runs. This is intended only for testing of LibProfyle
// during development, not for normal use.
#define REPORT 0

#include <exec/types.h>
#include <exec/execbase.h>
#include <exec/exectags.h>
#include <exec/ports.h>
#include <exec/devices.h>
#include <exec/avl.h>
#include <devices/timer.h>

#include "ProfyleData.h"

#include <string.h>

#if REPORT
#include <stdio.h>
#endif

#include <proto/exec.h>
#include <proto/timer.h>

// -------------------------------------------------------------------------
// === Prototypes ===

static int32 AVLNodeComp(struct AVLNode *Node1, struct AVLNode *Node2);
static int32 AVLKeyComp(struct AVLNode *Node, AVLKey Key);

#if REPORT
static void ReportFunc(struct FuncRecord *FuncRec);
static void Report(void);
#endif

// -------------------------------------------------------------------------
// === Macros ===


/***************************************************************************
*																		   *
* Data																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Defines ===

// Set the constructor and destructor functions to the highest priority when
// using versions of GCC that support prioritization. This allows other con-
// structors and destructors to be profiled. (Actually, prioritization was
// introduced around GCC 4.7, but we assume no Amiga versions between 4.2.4
// and 5.0 were made.)
#if __GNUC__ < 5
	#define PRIORITY
#else
	#define PRIORITY (101)
#endif


// The call stack is allocated in blocks of this many elements. The default
// of 100 is enough for 100 levels of call nesting, plenty for most any non-
// recursive program. For heavily recursive programs this may be increased to
// a larger value to reduce the number of times the call stack must be en-
// larged during profiling. The user does this by defining a larger value in
// the makefile.
#ifndef CALL_STACK_QUANTUM
	#define CALL_STACK_QUANTUM		100
#endif

// The EClockVal structure used by the timer device happens to have the same
// memory footprint as a uint64 on a big-endian processor. For speed, we make
// use of this to convert between the two with no overhead. This is highly
// non-portable, and will break if OS4 ever moves to a little-endian process-
// or.
union EClock
{
	struct EClockVal AsEClkVal;
	uint64 AsUint64;
};

// -------------------------------------------------------------------------
// === Locals ===

// We depend on some of these variables being NULL on startup; the startup
// code ensures this (BSS is zeroed).

// This structure contains all of LibProfyle's local variables. They are
// accessed via this structure rather than directly to reduce the risk of
// name collisions with the target program (a limited form of name scoping).
// Because it's in BSS, the compiler knows the address of each field and can
// read it directly, with no need to index off of the struct's address. Thus,
// there is no loss of speed compared to accessing non-struct variables.
static struct
{
	// A pointer to the named memory shared with Profyler. Also serves as a
	// flag indicating whether profiling is to be performed- if NULL, profil-
	// ing is disabled (and none of the other variables should be considered
	// valid).
	struct ProfyleData *Profyle;
 
	// The name of the named memory.
	TEXT TargetName[TARGET_NAME_LEN];

	// A pointer to the main Exec interface. We keep our own copy of this so
	// we're not dependent on the target to set this up for us.
	struct ExecIFace *IExec;

	// A pointer to the timer device's library base. Also serves as an indi-
	// cation that the timer device is open (NULL if it isn't).
	struct Library *TimerBase;

	// A pointer to the timer device's library interface.
	struct TimerIFace *ITimer;

	// A pointer to the message port required to open the timer device.
	struct MsgPort *TimerPort;

	// A pointer to the IO request required to open the timer device.
	struct TimeRequest *TimerIO;

	// A pointer to a message to be used to contact Profyler.
	struct Message *ProfylerMsg;

	// A pointer to a message port to which replies to ProfylerMsg are sent.
	struct MsgPort *ProfylerReply;

	// A pointer to an object pool from which to allocate database records.
	APTR DBasePool;

	// If non-zero then profiling is paused. This is a counter rather than a
	// BOOL so that recursive pausing won't throw it off.
	uint32 Paused;

	// The current overhead count, in EClock ticks.
	uint64 Overhead;

	// The value of the EClock when ProfylePause() last executed.
	uint64 PauseStart;

	// The accumulated pause time, in EClock ticks.
	uint64 PauseTime;
} Vars;

// -------------------------------------------------------------------------
// === Globals ===

// We depend on some of these variables being NULL on startup; the startup
// code ensures this (BSS is zeroed).

/***************************************************************************
*																		   *
* Code																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Private code ===

/***************************************************************************

 AVLNodeComp(Node1, Node2)

 This is a callback function for use in accessing an Exec AVL tree. It com-
 pares two nodes in the tree, and returns their sort order.

 The nodes are declared as pointers to AVLNodes since that's what the OS4 in-
 cludes specify, but they're actually pointers to the AVLNodes at the front
 of FuncRecords, which make up the contents of the profile database.

 The key used to sort the database records is the profiled function's ad-
 dress. The nodes are sorted in address order, from lowest address to high-
 est.

 In -----------------------------------------------------------------------

 Node1 = A pointer to the first function record to be compared.

 Node2 = A pointer to the second function record to be compared.

 Out ----------------------------------------------------------------------

 A positive number if the first node is greater than the second; a negative
 number if the second node is greater than the first, or zero if the two
 nodes are equal.

***************************************************************************/

static int32 AVLNodeComp(struct AVLNode *Node1, struct AVLNode *Node2)
{
	// Compare the two function addresses. There's an awful lot of casting
	// required to simply subtract one number from another.
	return((int32)((struct FuncRecord *)Node1)->FuncID -
		(int32)((struct FuncRecord *)Node2)->FuncID);
}

/***************************************************************************

 AVLKeyComp(Node, Key)

 This is a callback function for use in accessing an Exec AVL tree. It com-
 pares a node in the tree to a standalone key value, and returns their sort
 order.

 The node is declared as a pointer to an AVLNode since that's what the OS4
 includes specify, but it's actually a pointer to the AVLNode at the front
 of a FuncRecord, which makes up the contents of the profile database.

 The key used to sort the database records is the profiled function's ad-
 dress. The nodes are sorted in address order, from lowest address to high-
 est.

 In -----------------------------------------------------------------------

 Node = A pointer to the function record to be compared.

 Key = The key to be compared.

 Out ----------------------------------------------------------------------

 A positive number if the node is greater than the key; a negative number if
 key is greater than the node, or zero if the two are equal.

***************************************************************************/

static int32 AVLKeyComp(struct AVLNode *Node, AVLKey Key)
{
	// Compare the function address to the key.
	return((int32)((struct FuncRecord *)Node)->FuncID - (int32)Key);
}

#if REPORT
/***************************************************************************

 ReportFunc(FuncRec)

 For test purposes, print a report on the current contents of the given pro-
 file database record to stdout. Minimal processing of the data is performed.

 In -----------------------------------------------------------------------

 FuncRec = A pointer to a FuncRecord containing the data for a single func-
	tion.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void ReportFunc(struct FuncRecord *FuncRec)
{
	// Do nothing if there is no record to report on.
	if(!FuncRec) return;

	// Add a header at the start of the record.
	printf("\n=== Function Record ===\n");

	// Report the function ID/address.
	printf("Function ID/Address = %p\n", FuncRec->FuncID);

	// Report the call count.
	printf("Call Count = %lu\n", FuncRec->CallCount);

	// Report the inclusive execution time.
	printf("Inclusive Time = %llu\n", FuncRec->InclusiveTime);

	// Report the exclusive execution time.
	printf("Exclusive Time = %llu\n", FuncRec->ExclusiveTime);

	// Add a blank line at the end.
	printf("\n");
}

/***************************************************************************

 Report()

 For test purposes, print a report on the current contents of the profile
 database to stdout by calling ReportFunc for each function record in the
 database.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void Report(void)
{
	struct FuncRecord *FuncRec;

	// If profiling is disabled, do nothing further (avoid accessing invalid
	// memory).
	if(!Vars.Profyle) return;

	// Get a pointer to the first database record, or NULL if the database is
	// empty.
	FuncRec = (struct FuncRecord *)
		Vars.IExec->AVL_FindFirstNode((struct AVLNode *)Vars.Profyle->Database);

	// Loop as long as there are entries to report on.
	while(FuncRec)
	{
		// Report on the database entry.
		ReportFunc(FuncRec);

		// Locate the next entry, or NULL if none.
		FuncRec = (struct FuncRecord *)
			Vars.IExec->AVL_FindNextNodeByAddress((struct AVLNode *)FuncRec);
	}
}
#endif

// -------------------------------------------------------------------------
// === Public code ===

/***************************************************************************

 __cyg_profile_func_enter(FuncAddr, RtnAddr)

 A call to this special function is inserted by GCC at the beginning of every
 function that is compiled with -finstrument-functions. It executes after the
 function's stack frame is set up, but before any of its code executes. It
 provides a suitable place to begin profiling of that function.

 Profyler refers to this function as the prolog, which is the name that SAS/C
 uses for its profiler entry function, and is much easier to say and type
 than cyg_profile_func_enter.

 In -----------------------------------------------------------------------

 FuncAddr = The address of the function that is being profiled. The address
	corresponds to the function's entry in the symbol table.

 RtnAddr = The address that the function being profiled will return to. This
	address is within the function that called the profiled function, but is
	not its symbol table address.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void __cyg_profile_func_enter(void *FuncAddr, void *RtnAddr)
{
	union EClock EClk1, EClk2;
	struct CallRecord *CallRec;
	struct FuncRecord *FuncRec;
	int32 NewSize;

	// If profiling is disabled, do nothing further.
	if(!Vars.Profyle) return;

	// Get the current EClock time. We want to do this as close to the begin-
	// ning of the prolog as possible, so everything in the prolog will be
	// counted as overhead.
	Vars.ITimer->ReadEClock(&EClk1.AsEClkVal);

	// To prevent multi-threaded code from corrupting the profile data, we
	// only allow the task/process that ran the constructor to be profiled.
	// Check to see if that task/process is the one that's running now. If
	// not, do nothing further. For speed we access the named memory without
	// locking it first; that's OK, as the variable we access is read-only.
	if(Vars.IExec->FindTask(NULL) != Vars.Profyle->Target) return;

	// Lock the named memory, so we can safely modify it. If Profyler already
	// has it locked we'll go to sleep until it's unlocked again. This will
	// be counted as part of the overhead.
	Vars.IExec->LockNamedMemory(PROFYLE_NAMESPACE, Vars.TargetName);

	// Bump the call stack index to add a new entry for this function call.
	Vars.Profyle->TOS++;

	// If we've just (and only just) run out of stack, enlarge it. If that
	// fails we won't try to enlarge it again, as that would leave an empty
	// hole in the stack if a later attempt was to succeed.
	if(Vars.Profyle->TOS == Vars.Profyle->StackSize)
	{
		// Determine the new stack size, one quantum larger than the old one.
		NewSize = Vars.Profyle->StackSize + CALL_STACK_QUANTUM;

		// Allocate the new, larger call stack array. No need to zero it, as
		// we initialize all fields explicitly.
		CallRec = Vars.IExec->AllocVecTags(NewSize * CALLREC_SIZE,
			AVT_Type, MEMF_SHARED, TAG_END);

		// Switch to the new stack if we got one. If not, we'll keep the old
		// stack, but will not try to access it until the TOS drops back in
		// range.
		if(CallRec)
		{
			// Copy the contents of the old stack to the new one.
			memcpy(CallRec, Vars.Profyle->CallStack,
				Vars.Profyle->StackSize * CALLREC_SIZE);

			// Free the old stack array.
			Vars.IExec->FreeVec(Vars.Profyle->CallStack);

			// Update the stack pointer and size in the named memory.
			Vars.Profyle->CallStack = CallRec;
			Vars.Profyle->StackSize = NewSize;
		}
	}

	// Get a pointer to our call stack entry. If the TOS is beyond the end of
	// the stack (because we couldn't allocate a larger stack) set the point-
	// er to NULL.
	CallRec = (Vars.Profyle->TOS < Vars.Profyle->StackSize) ?
		&Vars.Profyle->CallStack[Vars.Profyle->TOS] : NULL;

	// Don't try to access the call stack entry if there isn't one- we'll
	// just not collect data until the stack is back in range.
	if(CallRec)
	{
		// Initialize the new entry with the function address and return
		// address passed by the compiler.
		CallRec->FuncID = FuncAddr;
		CallRec->Caller = RtnAddr;

		// Zero the called function timer.
		CallRec->CalledFunctionTimer = 0;

		// Remember the current value of the pause timer.
		CallRec->StartPauseTime = Vars.PauseTime;

		// Find the record for our function in the profile database, if it
		// (and the database) exists.
		FuncRec = (struct FuncRecord *)
			Vars.IExec->AVL_FindNode((struct AVLNode *)Vars.Profyle->Database,
			FuncAddr, AVLKeyComp);

		// If there's no record for our function, let's create one. This will
		// also create the database if it's currently empty.
		if(!FuncRec)
		{
			// Allocate a new blank function record from the item pool.
			FuncRec = (struct FuncRecord *)
				Vars.IExec->ItemPoolAlloc(Vars.DBasePool);

			// If we got the record, initialize it and add it to the data-
			// base.
			if(FuncRec)
			{
				// Store our function's address as the ID. All other fields
				// are already zeroed, and don't require further initializa-
				// tion.
				FuncRec->FuncID = FuncAddr;

				// Add the record to the database. The only way this can fail
				// is if the record is already in the database, and we've al-
				// ready checked for that. This line prevents the 'strict-
				// aliasing' optimization from being used.
				Vars.IExec->AVL_AddNode((struct AVLNode **)&Vars.Profyle->Database,
					(struct AVLNode *)FuncRec, AVLNodeComp);

				// Bump the database record count, which lets Profyler know
				// how many entries there are.
				Vars.Profyle->DBaseSize++;
			}
		}

		// Set a pointer to the database entry for our function. If we could-
		// n't create an entry, the pointer will be NULL.
		CallRec->DatabaseRecord = FuncRec;
	}

	// Get the EClock time again. We want to do this as close to the end of
	// the prolog as possible, to accurately capture the overhead. However,
	// there are some things that can only be done after this. They will be
	// counted as part of the execution time of the profiled function.
	Vars.ITimer->ReadEClock(&EClk2.AsEClkVal);

	// Unless profiling is paused, calculate how much time has elapsed since
	// the first EClock reading. That time is all profiling overhead, so keep
	// track of it so it won't be counted as part of the execution time of
	// any higher-level functions. Skip this if paused, since this is all
	// being counted as part of the pause time instead.
	if(!Vars.Paused) Vars.Overhead += EClk2.AsUint64 - EClk1.AsUint64;

	// Set those fields in the call stack entry that depend on the current
	// EClock time, but only if there is a call stack entry.
	if(CallRec)
	{
		// The current time becomes the start time of our function. This
		// avoids counting any time used earlier in the prolog.
		CallRec->StartTime = EClk2.AsUint64;

		// Remember the overhead value as of the start of our function, so we
		// can tell how much it has changed by the time the function ends.
		CallRec->StartOverhead = Vars.Overhead;
	}

	// We're done- unlock the named memory.
	Vars.IExec->UnlockNamedMemory(PROFYLE_NAMESPACE, Vars.TargetName);
}

/***************************************************************************

 __cyg_profile_func_exit(FuncAddr, RtnAddr)

 A call to this special function is inserted by GCC at the end of every func-
 tion that is compiled with -finstrument-functions. It executes after the
 function's code ends, but before the function's stack frame is torn down. It
 provides a suitable place to complete profiling of that function.

 Profyler refers to this function as the epilog, which is the name that SAS/C
 uses for its profiler exit function, and is much easier to say and type than
 cyg_profile_func_exit.

 In -----------------------------------------------------------------------

 FuncAddr = The address of the function that is being profiled. The address
	corresponds to the function's entry in the symbol table.

 RtnAddr = The address that the function being profiled will return to. This
	address is within the function that called the profiled function, but is
	not its symbol table address.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void __cyg_profile_func_exit(void *FuncAddr, void *RtnAddr)
{
	union EClock EClk1, EClk2;
	uint64 RunTime, OverTime, PauseTime;
	struct CallRecord *CallRec, *CallerRec;
	struct FuncRecord *FuncRec;

	// If profiling is disabled, do nothing further.
	if(!Vars.Profyle) return;

	// Get the current EClock time. We want to do this as close to the begin-
	// ning of the epilog as possible, so everything in the epilog will be
	// counted as overhead.
	Vars.ITimer->ReadEClock(&EClk1.AsEClkVal);

	// To prevent multi-threaded code from corrupting the profile data, we
	// only allow the task/process that ran the constructor to be profiled.
	// Check to see if that task/process is the one that's running now. If
	// not, do nothing further. For speed we access the named memory without
	// locking it first; that's OK, as the variable we access is read-only.
	if(Vars.IExec->FindTask(NULL) != Vars.Profyle->Target) return;

	// Lock the named memory, so we can safely modify it. If Profyler already
	// has it locked we'll go to sleep until it's unlocked again. This will
	// be counted as part of the overhead.
	Vars.IExec->LockNamedMemory(PROFYLE_NAMESPACE, Vars.TargetName);

	// Get the entry for our function from the call stack. Normally this will
	// be the top entry on the stack, but we need to handle certain cases
	// where that's not true.
	for(;;)
	{
		// Get a pointer to the topmost call stack entry. If the stack is
		// empty or the TOS is beyond the end of the stack (because we could-
		// n't allocate a larger stack) set the pointer to NULL.
		CallRec = ((Vars.Profyle->TOS >= 0) && (Vars.Profyle->TOS <
			Vars.Profyle->StackSize)) ? 
			&Vars.Profyle->CallStack[Vars.Profyle->TOS] : NULL;

		// If the stack is empty or there is no call record because the stack
		// couldn't be enlarged, proceed anyway- we'll just skip profiling of
		// this function.
		if(!CallRec) break;

		// If there is a call record and it matches our function, proceed
		// with the profiling,
		if(CallRec->FuncID == FuncAddr) break;

		// The call record isn't for our function (perhaps we're exiting a
		// different function due to longjmp). Pop the current entry from the
		// call stack and check the one below it.
		Vars.Profyle->TOS--;
	}

	// If profiling is paused, pretend there's no call record so we won't
	// profile this function (since the times wouldn't be correct).
	if(Vars.Paused) CallRec = NULL;

	// Don't try to access the call stack entry if there isn't one- we'll
	// just not collect data until the stack is back in range or the pause
	// has ended.
	if(CallRec)
	{
		// Calculate the unadjusted execution time of our function by sub-
		// tracting the EClock time when it started from that when it ended.
		RunTime = EClk1.AsUint64 - CallRec->StartTime;

		// Calculate the total amount of time that profiling was paused while
		// our function executed. May be zero if profiling was not paused.
		PauseTime = Vars.PauseTime - CallRec->StartPauseTime;

		// Calculate the total amount of profiler overhead time that occurred
		// while our function executed. This includes the overhead of any
		// functions that our function called (and so on). It does not in-
		// clude the overhead of our own prolog and epilog, as that is not
		// part of the measured execution time. The overhead may be zero if
		// no other functions were called.
		OverTime = Vars.Overhead - CallRec->StartOverhead;

		// Subtract the pause time and the overhead time from the measured
		// execution time of our function, to derive the adjusted execution
		// time. There should never be underflow, but just in case...
		if(PauseTime) RunTime = PauseTime < RunTime ? RunTime - PauseTime : 0;
		if(OverTime) RunTime = OverTime < RunTime ? RunTime - OverTime : 0;

		// Get a pointer to our caller's call stack entry. If our entry is
		// the first on the stack (we have no profiled caller) set the point-
		// er to NULL.
		CallerRec = Vars.Profyle->TOS ?
			&Vars.Profyle->CallStack[Vars.Profyle->TOS - 1] : NULL;

		// If we have a caller, add our adjusted execution time to its called
		// function timer.
		if(CallerRec) CallerRec->CalledFunctionTimer += RunTime;

		// For speed, cache a pointer to the profile database entry for our
		// function. This may be NULL, if we couldn't create a database en-
		// try.
		FuncRec = CallRec->DatabaseRecord;

		// If there is no database record for our function, we can't collect
		// any data for it.
		if(FuncRec)
		{
			// Bump the call count for our function, now that it has ended.
			FuncRec->CallCount++;

			// Add the adjusted execution time of this call to the inclusive
			// execution time of all calls so far.
			FuncRec->InclusiveTime += RunTime;

			// Subtract the execution time of any functions our function
			// called from the execution time, to derive the exclusive exe-
			// cution time. Protect against underflow.
			if(CallRec->CalledFunctionTimer)
			{
				RunTime = (CallRec->CalledFunctionTimer < RunTime) ?
					RunTime - CallRec->CalledFunctionTimer : 0;
			}

			// Add that to the exclusive execution time of all calls so far. 
			FuncRec->ExclusiveTime += RunTime;
		}
	}

	// Adjust the function call stack to remove the entry for our function,
	// now that we're done with it. If this was the only entry on the stack,
	// TOS becomes -1, indicating that the stack is empty.
	Vars.Profyle->TOS--;

	// Don't update the overhead if profiling is paused, since everything is
	// being counted as part of the pause time instead.
	if(!Vars.Paused)
	{
		// Get the EClock time again. We do this as close to the end of the
		// epilog as possible, to accurately capture the overhead.
		Vars.ITimer->ReadEClock(&EClk2.AsEClkVal);

		// Subtract the current time from that at entry to the epilog, to de-
		// termine the overhead time of the epilog. Add that to the total
		// overhead time.
		OverTime = EClk2.AsUint64 - EClk1.AsUint64;
		Vars.Overhead += OverTime;
	}

	// We're done- unlock the named memory.
	Vars.IExec->UnlockNamedMemory(PROFYLE_NAMESPACE, Vars.TargetName);
}

/***************************************************************************

 ProfylePause()

 Pause profiling of the target program. Any time that elapses between a call
 to this function and a call to ProfyleResume() will not be counted. This
 allows calls to Wait() or other functions that wait for an outside event or
 that otherwise take a long time to complete to not inflate the execution
 time of the program.

 Only external functions (normally, system library calls) should be called
 between ProfylePause() and ProfyleResume(). Any profiled functions that are
 called while paused will not have their times recorded.

 Calls to ProfylePause() nest, such that ProfyleResume() must be called the
 same number of times before profiling will resume.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void ProfylePause(void)
{
	union EClock EClk;

	// If profiling is disabled, do nothing further.
	if(!Vars.Profyle) return;

	// Get the current EClock time. We do this as close to the start of the
	// function as possible, so the overhead of the function is counted as
	// part of the pause time.
	Vars.ITimer->ReadEClock(&EClk.AsEClkVal);

	// To prevent multi-threaded code from corrupting the profile data, we
	// only allow the task/process that ran the constructor to control pro-
	// filing. Check to see if that task/process is the one that's running
	// now. If not, do nothing further. For speed we access the named memory
	// without locking it first; that's OK, as the variable we access is
	// read-only.
	if(Vars.IExec->FindTask(NULL) != Vars.Profyle->Target) return;

	// If we're already paused (pause count is non-zero) do nothing. Bump the
	// pause counter, so we'll need to resume as many times as we've paused
	// before the pause really ends.
	if(Vars.Paused++) return;

	// The pause count has just become non-zero, so save the current time as
	// the start time of the pause.
	Vars.PauseStart = EClk.AsUint64;
}

/***************************************************************************

 ProfyleResume()

 Resume profiling of a target program that was paused by ProfylePause().
 Safely does nothing if called without calling ProfylePause() first.

 Calls to ProfylePause() nest, such that ProfyleResume() must be called the
 same number of times before profiling will resume.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void ProfyleResume(void)
{
	union EClock EClk;

	// If profiling is disabled, do nothing further.
	if(!Vars.Profyle) return;

	// If not paused (pause count is zero), do nothing.
	if(!Vars.Paused) return;

	// To prevent multi-threaded code from corrupting the profile data, we
	// only allow the task/process that ran the constructor to control pro-
	// filing. Check to see if that task/process is the one that's running
	// now. If not, do nothing further. For speed we access the named memory
	// without locking it first; that's OK, as the variable we access is
	// read-only.
	if(Vars.IExec->FindTask(NULL) != Vars.Profyle->Target) return;

	// Decrement the pause count. Do nothing if it's still non-zero; we'll
	// just remain paused.
	if(--Vars.Paused) return;

	// The pause count has hit zero, so we need to unpause. Get the current
	// EClock time. Most of the overhead time of this function will be count-
	// ed as part of the pause time.
	Vars.ITimer->ReadEClock(&EClk.AsEClkVal);

	// Subtract the EClock time when the pause began, to determine how much
	// time has passed since then. Add that to the accumulated pause time.
	Vars.PauseTime += EClk.AsUint64 - Vars.PauseStart;
}

/***************************************************************************

 ProfyleDestructor()

 This is a GCC destructor function, which executes as part of the shutdown
 code, following exit from main(). It is automatically added to a program
 when it is linked with LibProfyle.

 Clean up any resources set up by the constructor. May safely be called from
 the constructor itself if initialization fails or aborts prior to complet-
 ion; will clean up only as much as necessary.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

__attribute__((destructor PRIORITY))
void ProfyleDestructor(void)
{
	struct MsgPort *ProfylerPort;

	// If the named memory is present then profiling is enabled, and we have
	// some extra work to do.
	if(Vars.Profyle)
	{
		// Look for Profyler's public message port. Disable multitasking so
		// it can't go away on us before we can talk to it.
		Vars.IExec->Forbid();
		ProfylerPort = Vars.IExec->FindPort(PROFYLER_PORT_NAME);

		// If we found the port, send a shutdown message to it, to let Pro-
		// fyler know that the target program is shutting down.
		if(ProfylerPort)
		{
			// Make our message into a shutdown message.
			((struct ProfyleMessage *)Vars.ProfylerMsg)->Event =
				TARGET_SHUTDOWN;

			// Send the message to Profyler, then re-enable multitasking so
			// Profyler can respond to it.
			Vars.IExec->PutMsg(ProfylerPort, Vars.ProfylerMsg);
			Vars.IExec->Permit();

			// Go to sleep while we wait for the message to come back, then
			// remove the message from the reply port.
			Vars.IExec->WaitPort(Vars.ProfylerReply);
			Vars.IExec->GetMsg(Vars.ProfylerReply);
		}
		else
		{
			// Re-enable multitasking if we couldn't find Profyler's port.
			// We'll proceed without sending the shutdown message.
			Vars.IExec->Permit();
		}

		// Lock the named memory, to ensure we have exclusive access to it.
		// If Profyler has it locked, we'll sleep here until it's unlocked.	
		Vars.IExec->LockNamedMemory(PROFYLE_NAMESPACE, Vars.TargetName);

#if REPORT
		// For testing purposes, dump the contents of the profile database
		// to stdout.
		Report();
#endif

		// Delete the call stack, which is referenced only by the named mem-
		// ory, and not by a local variable.
		Vars.IExec->FreeVec(Vars.Profyle->CallStack);

		// Zero out the named memory, so Profyler will know it's not valid if
		// it gets a look at it before we can delete it.
		memset(Vars.Profyle, 0, PROFDATA_SIZE);

		// Unlock the named memory, since we can't delete it if it's locked.
		// If Profyler is waiting to obtain the lock, it'll gain access to
		// the memory at this point. If so, it'll recognize that the memory
		// is not valid, and will unlock it again.
		Vars.IExec->UnlockNamedMemory(PROFYLE_NAMESPACE, Vars.TargetName);

		// Free the named memory. We do this repeatedly until successful, in
		// case Profyler did get a lock on it. This may be unnecessary, as
		// FreeNamedMemory() may do this itself, but the docs are unclear.
		while(!Vars.IExec->FreeNamedMemory(PROFYLE_NAMESPACE,
			Vars.TargetName));

		// Zero out the named memory pointer.
		Vars.Profyle = NULL;
	}

	// The rest of the cleanup occurs whether or not profiling was enabled,
	// so we can clean up if aborting from any point in the initialization.

	// Delete the Profyler reply port, if present. Remove any messages from
	// the port first (there shouldn't be any, but just in case...).
	if(Vars.ProfylerReply)
	{
		while(Vars.IExec->GetMsg(Vars.ProfylerReply));
		Vars.IExec->FreeSysObject(ASOT_PORT, (APTR)Vars.ProfylerReply);
		Vars.ProfylerReply = NULL;
	}

	// Delete the Profyler message, if present.
	if(Vars.ProfylerMsg)
	{
		Vars.IExec->FreeSysObject(ASOT_MESSAGE, (APTR)Vars.ProfylerMsg);
		Vars.ProfylerMsg = NULL;
	}

	// Delete the database item pool, if present.
	if(Vars.DBasePool)
	{
		// Delete the database item pool, which effectively deletes the pro-
		// file database.
		// Vars.IExec->ItemPoolFlush(Vars.DBasePool);
		Vars.IExec->FreeSysObject(ASOT_ITEMPOOL, Vars.DBasePool);
		Vars.DBasePool = NULL;
	}

	// Drop the timer device's library interface, if we've obtained it.
	if(Vars.ITimer)
	{
		Vars.IExec->DropInterface((struct Interface *)Vars.ITimer);
		Vars.ITimer = NULL;
	}

	// Close the timer device, if open.
	if(Vars.TimerBase)
	{
		Vars.IExec->CloseDevice((struct IORequest *)Vars.TimerIO);
		Vars.TimerBase = NULL;
	}

	// Delete the IO request we used to open the timer device, if present.
	if(Vars.TimerIO)
	{
		Vars.IExec->FreeSysObject(ASOT_IOREQUEST, (APTR)Vars.TimerIO);
		Vars.TimerIO = NULL;
	}

	// Delete the message port we used to open the timer device, if present.
	if(Vars.TimerPort)
	{
		Vars.IExec->FreeSysObject(ASOT_PORT, (APTR)Vars.TimerPort);
		Vars.TimerPort = NULL;
	}

	// There's no need to drop the main Exec interface, as Exec can never be
	// closed. We do zero our pointer to it.
	Vars.IExec = NULL;
}

/***************************************************************************

 ProfyleConstructor()

 This is a GCC constructor function, which executes as part of the startup
 code, prior to entry to main(). It is automatically added to a program when
 it is linked with LibProfyle.

 Perform the initialization required to add profiling to the target program
 with which we are linked. The target program must have startup code or the
 constructor won't be run, but otherwise we assume as little as possible
 about the program.

 If initialization fails, anything that has been initialized is cleaned up,
 and the target program will run without profiling.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

__attribute__((constructor PRIORITY))
void ProfyleConstructor(void)
{
	struct CallRecord *CallStack = NULL;
	struct MsgPort *ProfylerPort;
	uint32 TargetNum;
	uint32 Forbidden = FALSE;

	// Get the main interface for Exec. We obviously can't call GetInter-
	// face() to do this, so we get it directly from ExecBase. This can't
	// fail.
	Vars.IExec = (struct ExecIFace *)(*(struct ExecBase **)4)->MainInterface;

	// Open the timer device for use as a library. First create a reply port.
	// (It's not required when only using the device as a library, but allo-
	// cating the IO request will fail without it.)
	Vars.TimerPort = Vars.IExec->AllocSysObjectTags(ASOT_PORT, TAG_END);
	if(!Vars.TimerPort) goto Fail;

	// Next, create a blank IO request, then use it to open the timer device
	// (which unit doesn't matter, as we're not going to use it). Abort on
	// failure.
	Vars.TimerIO = Vars.IExec->AllocSysObjectTags(ASOT_IOREQUEST,
		ASOIOR_Size, sizeof(struct TimeRequest), ASOIOR_ReplyPort,
		Vars.TimerPort, TAG_END);
	if(!Vars.TimerIO) goto Fail;
	if(Vars.IExec->OpenDevice(TIMERNAME, UNIT_VBLANK,
		(struct IORequest *)Vars.TimerIO, 0)) goto Fail;

	// Finally, extract the timer device's library base, and from that get
	// the interface. Abort on failure.
	Vars.TimerBase = (struct Library *)Vars.TimerIO->Request.io_Device;
	Vars.ITimer =
		(struct TimerIFace *)Vars.IExec->GetInterface(Vars.TimerBase, "main",
		1, NULL);
	if(!Vars.ITimer) goto Fail;

	// Create an item pool for function records. Abort if we can't. The mem-
	// ory is shared, since other programs need to access it. No garbage
	// collection is necessary, since we only allocate items and never free
	// them.
	Vars.DBasePool = Vars.IExec->AllocSysObjectTags(ASOT_ITEMPOOL,
		ASOITEM_MFlags, (MEMF_SHARED | MEMF_CLEAR), ASOITEM_ItemSize,
		FUNCREC_SIZE, ASOITEM_GCPolicy, ITEMGC_NONE, TAG_END);
	if(!Vars.DBasePool) goto Fail;

	// Allocate memory for the function call stack. Abort if we can't. The
	// memory is shared, since other programs need to access it.
	CallStack = Vars.IExec->AllocVecTags(CALL_STACK_QUANTUM * CALLREC_SIZE,
		AVT_Type, MEMF_SHARED, TAG_END);
	if(!CallStack) goto Fail;

	// Create the message port to which Profyler will reply when we contact
	// it. Abort on failure.
	Vars.ProfylerReply = Vars.IExec->AllocSysObjectTags(ASOT_PORT, TAG_END);
	if(!Vars.ProfylerReply) goto Fail;

	// Create the message that will be used to contact Profyler. Abort on
	// failure.
	Vars.ProfylerMsg = Vars.IExec->AllocSysObjectTags(ASOT_MESSAGE,
		ASOMSG_ReplyPort, Vars.ProfylerReply, ASOMSG_Size, PROFMSG_SIZE,
		TAG_END);
	if(!Vars.ProfylerMsg) goto Fail;

	// Set the magic ID code in the message, so Profyler will know it's from
	// a target program.
	((struct ProfyleMessage *)Vars.ProfylerMsg)->MessageID = PROFYLE_MSG_ID;

	// Disable multitasking while we create the named memory block, to ensure
	// that no other target simultaneously tries to create a block with the
	// same name, and so that Profyler can't find the block before we can
	// lock and initialize it.
	Vars.IExec->Forbid();
	Forbidden = TRUE;

	// Find the first available target name (in case any other programs are
	// currently being profiled). Up to nine targets are possible.
	strcpy(Vars.TargetName, TARGET_NAME);
	for(TargetNum = 1; TargetNum < 10; TargetNum++)
	{
		// Derive a target name to check for by inserting the target number.
		Vars.TargetName[TARGET_NUM] = '0' + (TEXT)TargetNum;

		// If we couldn't find a block of memory with that name in the Pro-
		// fyler namespace, then that name must be available- terminate the
		// search. Otherwise, check the next name.
		if(!Vars.IExec->FindNamedMemory(PROFYLE_NAMESPACE,
			Vars.TargetName)) break;
	}

	// If the target number is out of range, then all of the target names
	// must be in use. Abort- we'll run without profiling.
	if(TargetNum == 10) goto Fail;

	// Save the target number in our message, for future use.
	((struct ProfyleMessage *)Vars.ProfylerMsg)->TargetNum = (uint8)TargetNum;

	// Allocate a block of named memory using the target name. Abort on fail-
	// ure. The presence of the named memory also signals to the rest of the
	// profiling code that profiling is enabled; if it's not present the rest
	// of the code does nothing.
	Vars.Profyle = Vars.IExec->AllocNamedMemory(PROFDATA_SIZE,
		PROFYLE_NAMESPACE, Vars.TargetName, NULL);
	if(!Vars.Profyle) goto Fail;

	// Lock the named memory, so Profyler won't be able to gain access to it
	// until we've had a chance to initialize it.
	Vars.IExec->LockNamedMemory(PROFYLE_NAMESPACE, Vars.TargetName);

	// It's safe to allow multitasking again.
	Vars.IExec->Permit();
	Forbidden = FALSE;

	// Initialize the named memory. Start by getting the address of the tar-
	// get task/process (that's us).
	Vars.Profyle->Target = Vars.IExec->FindTask(NULL);

	// Initialize the profiler status.
	Vars.Profyle->Status = 0;

	// Set up the call stack, which is empty at this point.
	Vars.Profyle->CallStack = CallStack;
	Vars.Profyle->StackSize = CALL_STACK_QUANTUM;
	Vars.Profyle->TOS = -1;

	// Set up the profile database, which is empty at this point.
	Vars.Profyle->Database = NULL;
	Vars.Profyle->DBaseSize = 0;

	// As part of BSS, Overhead, PauseStart and PauseTime are already zeroed.

	// The named memory has now been initialized, so we can unlock it and
	// allow Profyler to access it as it pleases.
	Vars.IExec->UnlockNamedMemory(PROFYLE_NAMESPACE, Vars.TargetName);

	// Look for Profyler's public message port. Disable multitasking so it
	// can't go away on us before we can talk to it.
	Vars.IExec->Forbid();
	ProfylerPort = Vars.IExec->FindPort(PROFYLER_PORT_NAME);

	// If we found the port, send a startup message to it, to let Profyler
	// know that a new target program is starting up.
	if(ProfylerPort)
	{
		// Make our message into a startup message.
		((struct ProfyleMessage *)Vars.ProfylerMsg)->Event = TARGET_STARTUP;

		// Send the message to Profyler, then re-enable multitasking so Pro-
		// fyler can respond to it.
		Vars.IExec->PutMsg(ProfylerPort, Vars.ProfylerMsg);
		Vars.IExec->Permit();

		// Go to sleep while we wait for the message to come back, then re-
		// move the message from the reply port.
		Vars.IExec->WaitPort(Vars.ProfylerReply);
		Vars.IExec->GetMsg(Vars.ProfylerReply);
	}
	else
	{
		// Re-enable multitasking if we couldn't find Profyler's port. We'll
		// proceed without sending the startup message.
		Vars.IExec->Permit();
	}

	// Profiling has been set up and is ready to go.
	return;

	// Come here to clean up if anything goes wrong.
Fail:
	// Re-enable multitasking if it's disabled.
	if(Forbidden) Vars.IExec->Permit();

	// If we haven't allocated and initialized the named memory yet, we have
	// to manually free the memory that it references.
	if(CallStack) Vars.IExec->FreeVec(CallStack);

	// Clean up everything else.
	ProfyleDestructor();
}
