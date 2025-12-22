
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Profyler v1.0 © 2022 by Mike Steed					  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Profyle Data								Last modified 07-Jan-22	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 This header defines the profile data that is shared between LibProfyle and
 an external application (normally Profyler) that wants to make use of that
 data. The data lives in or is referenced by a block of OS4 named memory,
 which may be accessed by both LibProfyle and by Profyler. LibProfyle cre-
 ates and maintains the data, while Profyler reads it, crunches the numbers,
 and reports the results to the user.

 Named memory exists for just this sort of purpose. Named memory is public,
 allowing Profyler to find it. The memory is semaphore protected to allow
 access by different tasks without causing corruption; each task locks the
 memory when accessing it, causing any others that try to lock it to wait
 until the memory is available.

 Memory that is referenced by the named memory, but that is not actually
 part of it, is protected by convention- each task agrees not to access that
 memory unless the named memory is locked. This allows the use of memory
 pools, which are not available in named memory.

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

// -------------------------------------------------------------------------
// === Includes ===

#include <exec/types.h>
#include <exec/ports.h>
#include <exec/tasks.h>
#include <exec/avl.h>

// -------------------------------------------------------------------------
// === Prototypes ===


// -------------------------------------------------------------------------
// === Macros ===


// -------------------------------------------------------------------------
// === Defines ===

// The call stack consists of an array of these structures, one for each
// function call that is currently underway. The top of the stack is the
// currently executing function, its caller lives below it, and so on.
// There's normally no need for Profyler to look at the call stack, as all
// the data there eventually ends up in the profile database. But it could be
// used to give a real-time call graph of the target program, if desired.
struct CallRecord
{
	// The start address of the function, as passed to the prolog by the
	// compiler. Used to look up the function's name in the symbol table.
	// Also serves as the AVL key for the function's entry in the profile
	// database, since it's guaranteed to be unique.
	APTR FuncID;

	// The address from which the function was called, as passed to the pro-
	// log by the compiler. May be used to look up the caller's name in the
	// symbol table. This does not have a corresponding field in the profile
	// database, since any given function may have multiple callers.
	APTR Caller;

	// The value of the system EClock on entry to the function.
	uint64 StartTime;

	// The value of the overhead counter (in EClock ticks) on entry to the
	// function. Used to prevent profiling overhead from being counted as
	// part of the function execution time.
	uint64 StartOverhead;

	// The value of the pause timer (in EClock ticks) on entry to the func-
	// tion. Used to avoid counting time where profiling is paused as part of
	// the function execution time.
	uint64 StartPauseTime;

	// The total execution time (in EClock ticks) of all profiled functions
	// called by this one. The overhead time of those functions has already
	// been subtracted.
	uint64 CalledFunctionTimer;

	// A pointer to the profile database record for this function, cached by
	// the prolog to avoid having to look it up again in the epilog.
	APTR DatabaseRecord;
};

// The size of a CallRecord.
#define CALLREC_SIZE		(sizeof(struct CallRecord))

// The profile database consists of one of these records for each function
// that has been profiled. The data in the record represents all completed
// calls to the function, and is updated when each function call returns (the
// numbers for main() will be zero until the program ends, for example).
struct FuncRecord
{
	// Used to link the function records together into an Exec AVL tree that
	// makes up the profile database. By putting this at the start of the
	// structure we can pass a pointer to the structure to any code that ex-
	// pects a pointer to an AVLNode.
	struct AVLNode Link;

	// The start address of the function, as passed to the prolog by the
	// compiler. Used to look up the function's name in the symbol table.
	// Also serves as the AVL key for the database, since it's guaranteed to
	// be unique.
	APTR FuncID;

	// The number of times the function has executed. Initialized to zero
	// when the record is created, and incremented by the epilog. This rep-
	// resents the number of times the function has returned (completed), not
	// the number of times it has been called.
	uint32 CallCount;

	// The total time (in EClock ticks) spent executing the function across
	// all the times it has been called. Includes the time spent executing
	// any other functions that this function calls. Divide this by the call
	// count to get the average inclusive execution time of the function.
	// Initialized to zero when the record is created, and updated by the
	// epilog.
	uint64 InclusiveTime;

	// The total time (in EClock ticks) spent executing the function across
	// all the times it has been called. Excludes the time spent executing
	// any profiled functions that this function calls. Divide this by the
	// call count to get the average exclusive execution time of the func-
	// tion. Initialized to zero when the record is created, and updated by
	// the epilog.
	uint64 ExclusiveTime;
};

// The size of a FuncRecord.
#define FUNCREC_SIZE		(sizeof(struct FuncRecord))

// The namespace in which all LibProfyle named memory lives. This reduces the
// chance of name collisions with other applications, and limits the number
// of names that need to be searched when looking for targets.
#define PROFYLE_NAMESPACE	"Profyle Targets"

// The base name of named memory blocks created by LibProfyle. The '#' at the
// end is replaced with the target number, a single ASCII numeral between 1
// and 9.
#define TARGET_NAME			"Target.#"

// The length of the target name, including the trailing NUL.
#define TARGET_NAME_LEN		(sizeof(TARGET_NAME))

// The offset into the TARGET_NAME to the '#' character; write an ASCII digit
// representing the target number here to generate that target's name.
#define TARGET_NUM			(sizeof(TARGET_NAME) - 2)

// The contents of the OS4 named memory block that is shared between a pro-
// gram being profiled and an external program that wants to use that data.
struct ProfyleData
{
	// A pointer to the target's Exec Task struct for tasks, and the Task
	// struct at the beginning of the DOS Process struct for DOS processes.
	// This may be used to find the target's name. Additionally, only this
	// task is allowed to update the profile data, to prevent multiple
	// threads from corrupting the data.
	struct Task *Target;

	// The current status of the profiler. Not currently used; is always 0.
	uint32 Status;

	// A pointer to the (bottom of the) function call stack, which is an
	// array of CallRecords. The address may change if the stack needs to be
	// enlarged.
	struct CallRecord *CallStack;

	// The maximum number of entries in the function call stack. May change
	// if the stack needs to be enlarged.
	int32 StackSize;

	// The index of the top of the function call stack (representing the
	// currently executing function), or -1 if the stack is empty. This may
	// be greater than StackSize if the call stack overflowed and couldn't be
	// enlarged.
	int32 TOS;

	// A pointer to a function record (specifically, the AVLNode that's lo-
	// cated at the beginning of the function record) that represents the
	// root of the Exec AVL tree that comprises the profile database, or NULL
	// if the database is empty.
	struct FuncRecord *Database;

	// The current number of entries in the profile database.
	uint32 DBaseSize;
};

// The size of the named memory block.
#define PROFDATA_SIZE		(sizeof(struct ProfyleData))

// The name of the public message port that Profyler opens to receive mess-
// ages from target programs.
#define PROFYLER_PORT_NAME	"Profyler Port"

// The message that is sent from LibProfyle to Profyler's public port to let
// the latter know when some event of interest is happening with the target
// program.
struct ProfyleMessage
{
	// A standard Exec Message.
	struct Message Mesg;

	// A magic number to confirm that this is a LibProfyle message.
	uint32 MessageID;

	// What is happening; one of the TARGET_XXX defines.
	uint8 Event;

	// The number of this target.
	uint8 TargetNum;
};

// The size of a ProfyleMessage.
#define PROFMSG_SIZE		(sizeof(struct ProfyleMessage))

// The magic ID number.
#define PROFYLE_MSG_ID \
	((uint32)('P')<<24 | (uint32)('F')<<16 | (uint32)('Y')<<8 | (uint32)('L'))

// What event is being reported by the ProfyleMessage.
#define TARGET_STARTUP		1	// profiled application is starting up
#define TARGET_SHUTDOWN		2	// profiled application is shutting down

// -------------------------------------------------------------------------
// === Globals ===

