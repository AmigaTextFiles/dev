#ifndef _EXEC_PROTOS_H_
#define _EXEC_PROTOS_H_

/* ExecProtos.h
 *
 * These are the function prototypes for Exec's functions.
 */

#ifdef _AMIGA

/* -------------------------------------------------------------------------- */
/* --- Amiga-Part ----------------------------------------------------------- */
/* -------------------------------------------------------------------------- */

#include <proto/exec.h>
#include <clib/alib_protos.h>

/* --- Alias-definitions for Exec functions --------------------------------- */

#define SemaphoreRelease(sigSem) ReleaseSemaphore(sigSem)

#else			/* _AMIGA */

/* -------------------------------------------------------------------------- */
/* --- Windoof-Part --------------------------------------------------------- */
/* -------------------------------------------------------------------------- */

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _MEMORY_H_
#include <joinOS/exec/Memory.h>
#endif

#ifndef _LISTS_H_
#include <joinOS/exec/Lists.h>
#endif

#ifndef _PORTS_H_
#include <joinOS/exec/Ports.h>
#endif

#ifndef _TASKS_H_
#include <joinOS/exec/Tasks.h>
#endif

#ifndef _ALERTS_H_
#include <joinOS/exec/Alerts.h>
#endif

#ifndef EXPORT
#define EXPORT __declspec(dllimport)
#endif

/* --- Library's base pointer ----------------------------------------------- */

extern struct ExecBase *SysBase;

/* --- Alerts and Errormessages --------------------------------------------- */

EXPORT void Alert (ULONG);

/* --- Basic functions, to access librarys ---------------------------------- */

EXPORT struct ExecBase *GetSysBase (void);
EXPORT struct Library *OpenLibrary(STRPTR libName, ULONG version);
EXPORT void CloseLibrary(struct Library *library);
EXPORT void AddLibrary (struct Library *library);
EXPORT void RemLibrary (struct Library *library);
EXPORT void Forbid(void);
EXPORT void Permit(void);

/* --- Task handling functions ---------------------------------------------- */

EXPORT struct Task *CreateTask (STRPTR Name, BYTE Pri, APTR InitPC, ULONG StackSize);
EXPORT void DeleteTask (struct Task *ta);
EXPORT APTR AddTask (struct Task* NewTask, APTR InitalPC, APTR FinalPC);
EXPORT void RemTask (struct Task *Task);
EXPORT struct Task *FindTask(STRPTR name);
EXPORT BYTE SetTaskPri(struct Task *task, LONG priority);
EXPORT VOID StackSwap(struct StackSwapStruct *newStack);

/* --- public memory allocation functions ----------------------------------- */

EXPORT void *AllocMem (ULONG size, ULONG attributes);
EXPORT void FreeMem (APTR mem, ULONG size);
EXPORT void *AllocVec (ULONG size, ULONG attributes);
EXPORT void FreeVec (void *mem);
EXPORT struct MemList *AllocEntry(struct MemList *memList);
EXPORT void FreeEntry (struct MemList *memList);
EXPORT void *AllocStack (struct Task *task, ULONG size);
EXPORT void FreeStack (struct Task *task, ULONG size);
EXPORT void *Allocate (struct MemHeader *membh, ULONG size);
EXPORT void Deallocate (struct MemHeader *membh, APTR mem, ULONG size);

/* --- public memory pool functions ----------------------------------------- */

EXPORT void *CreatePool (ULONG MemFlags, ULONG PuddleSize, ULONG ThreshSize);
EXPORT void *AllocPooled (void *PoolHeader, ULONG size);
EXPORT void FreePooled (void *PoolHeader, void *mem, ULONG size);
EXPORT void DeletePool (void* PoolHeader);

/* --- public supportfunctions for memory ----------------------------------- */

EXPORT void ClearMemHeader (struct MemHeader *membh);
EXPORT ULONG AvailMemory (struct List *memList, ULONG Attributes);
EXPORT ULONG AvailMem(ULONG Attribute);
EXPORT ULONG TypeOfMem (void *address);
EXPORT void FillMem (APTR mem, ULONG size, UBYTE byte);

/* --- List manipulating functions ------------------------------------------ */

EXPORT void NewList (struct List *list);
EXPORT void AddHead (struct List *list, struct Node *node);
EXPORT void AddTail (struct List *list, struct Node *node);
EXPORT struct Node *RemHead (struct List *list);
EXPORT struct Node *RemTail (struct List *list);
EXPORT void Insert (struct List *list, struct Node *node, struct Node *pred);
EXPORT void Remove (struct Node *node);
EXPORT void Enqueue (struct List *list, struct Node *node);
EXPORT struct Node *FindName (struct List *list, UBYTE *name);
EXPORT ULONG CountNodes (struct List *list);

/* --- Task signaling functions --------------------------------------------- */

EXPORT ULONG Wait(ULONG signalSet);
EXPORT BYTE AllocSignal (BYTE signalNum);
EXPORT void FreeSignal(BYTE signalNum);
EXPORT ULONG SetSignal(ULONG newSignals, ULONG signalSet);
EXPORT void Signal (struct Task *task, ULONG signalSet);

/* --- Message port functions ----------------------------------------------- */

EXPORT struct MsgPort *CreatePort(UBYTE *name, LONG pri);
EXPORT struct MsgPort *CreateMsgPort(void);
EXPORT void DeletePort (struct MsgPort *mp);
EXPORT void DeleteMsgPort (struct MsgPort *mp);
EXPORT struct MsgPort *FindPort (STRPTR PortName);
EXPORT void AddPort(struct MsgPort *mp);
EXPORT void RemPort (struct MsgPort *mp);

/* --- Message handling functions ------------------------------------------- */

EXPORT void PutMsg (struct MsgPort *port, struct Message *message);
EXPORT struct Message *GetMsg (struct MsgPort *port);
EXPORT void ReplyMsg(struct Message *msg);
EXPORT struct Message *WaitPort(struct MsgPort *port);

/* --- Semaphore functions -------------------------------------------------- */

EXPORT struct SignalSemaphore *CreateSignalSemaphore (STRPTR name, BYTE pri);
EXPORT void DeleteSignalSemaphore (struct SignalSemaphore *sigSem);
EXPORT void InitSemaphore (struct SignalSemaphore *sigSem);
EXPORT void AddSemaphore(struct SignalSemaphore *sigSem);
EXPORT void RemSemaphore(struct SignalSemaphore *sigSem);
EXPORT struct SignalSemaphore *FindSemaphore(STRPTR name);
EXPORT LONG AttemptSemaphore(struct SignalSemaphore *sigSem);
EXPORT LONG AttemptSemaphoreShared(struct SignalSemaphore *sigSem);
EXPORT void ObtainSemaphore (struct SignalSemaphore *sigSem);
EXPORT void ObtainSemaphoreList(struct List *sigSem);
EXPORT void ObtainSemaphoreShared(struct SignalSemaphore *sigSem);
EXPORT void SemaphoreRelease (struct SignalSemaphore *sigSem);
EXPORT void ReleaseSemaphoreList(struct List *list);

/* --- General purpose public functions ------------------------------------- */

EXPORT void MakeUniqueName (UBYTE *Buffer, ULONG Count);

/* --- Defines for Exec functions ------------------------------------------- */

/* These functions are not implemented under Windoof, they are just another
 * name of an existing Windoof (or Exec) function.
 */

#define Disable() Forbid()
/* SYNOBSIS
 *		Disable();
 *		void Disable (void);
 *
 * FUNCTION
 *		This function prevents interrupts from being handled by the system, until
 *		a matching Enable() is executed. Disable() implies Forbid().
 *
 *		DO NOT USE THIS CALL WITHOUT GOOD JUSTIFICATION. THIS CALL IS VERY
 *		DANGEROUS!
 *
 * RESULTS
 *		All interrupt processing is deferred until the task executing makes
 *		a call to Enable() or is placed in a wait state.  Normal task
 *		rescheduling does not occur while interrupts are disabled.  In order
 *		to restore normal interrupt processing, the programmer must execute
 *		exactly one call to Enable() for every call to Disable().
 *
 * IMPORTANT REMINDER:
 *
 *		It is important to remember that there is a danger in using
 *		disabled sections.  Disabling interrupts for more than ~250
 *		microseconds will prevent vital system functions (especially serial
 *		I/0) from operating in a normal fashion.
 *
 *		Think twice before using Disable(), then think once more.
 *		After all that, think again.  With enough thought, the need
 *		for a Disable() can often be eliminated.  For the user of many
 *		device drivers, a write to disable *only* the particular interrupt
 *		of interest can replace a Disable().  For example:
 *				MOVE.W	#INTF_PORTS,_intena
 *		Do not use a macro for Disable(), insist on the real thing.
 *
 *		This call may be made from interrupts, it will have the effect
 *		of locking out all higher-level interrupts (lower-level interrupts
 *		are automatically disabled by the CPU).
 *
 *		Note: In the event of a task entering a Wait() after disabling
 *				interrupts, the system "breaks" the disabled state and runs
 *				normally until the task which called Disable() is rescheduled.
 *
 * NOTE
 *		This call is guaranteed to preserve all registers.
 *
 * SPECIAL NOTE
 *		Because the Windoof systems Exec implementation doesn't support
 *		interrupt-handling, this function is implemented as a call to Forbid().
 */

#define Enable() Permit()
/* SYNOPSIS
 *		Enable();
 *		void Enable(void);
 *
 * FUNCTION
 *		Allow system interrupts to again occur normally, after a matching
 *		Disable() has been executed.
 *
 * RESULTS
 *		Interrupt processing is restored to normal operation. The
 *		programmer must execute exactly one call to Enable() for every call
 *		to Disable().
 *
 *  NOTE
 *		This call is guaranteed to preserve all registers.
 *
 * SPECIAL NOTE
 *		Because the Windoof systems Exec implementation doesn't support
 *		interrupt-handling, this function is implemented as a call to Permit().
 */

#define CopyMem(source,dest,bytes) CopyMemory((dest),(source),(bytes))
/* SYNOPSIS
 *		CopyMem (source, dest, bytes);
 *		void CopyMem (APTR, APTR, ULONG)
 *
 * FUNCTION
 *		CopyMem is a general purpose, fast memory copy function. It can deal with
 *		arbitrary length, with its pointers on arbitrary alignments.
 *
 *		Arbitrary overlapping copies are not supported, use MoveMem() instead.
 *
 *		The internal implementation of this function will change from system to
 *		system, and may be implemented via hardware DMA.
 *
 * INPUTS
 *		source	- a pointer to the source data region.
 *		dest		- a pointer to the destination data region.
 *		size		- the size (in bytes) of the memory area. Zero copies zero bytes.
 */

#define CopyMemQuick(source,dest,bytes) CopyMemory((dest),(source),(bytes))
/* SYNOPSIS
 *		CopyMemQuick (source, dest, bytes);
 *		void CopyMemQuick (ULONG *, ULONG *, ULONG)
 *
 * FUNCTION
 *		CopyMemQuick is a higly optimized memory copy function, with restrictions
 *		on the size and allignment of its arguments. Both the source and
 *		destination pointers must be longword aligned. In addition, the size must
 *		be an integral number of longwords (e.g. the size must be evenly
 *		divisible by four).
 *
 *		Arbitrary overlapping copies are not supported, use MoveMem() instead.
 *
 *		The internal implementation of this function will change from system to
 *		system, and may be implemented via hardware DMA.
 *
 * INPUTS
 *		source	- a pointer to the source data region, long aligned.
 *		dest		- a pointer to the destination data region, long aligned.
 *		size		- the size (in bytes) of the memory area. Zero copies zero bytes.
 */

#define MoveMem (source,dest,length) MoveMemory((dest),(source),(length))
/* SYNOPSIS
 *		MoveMem (source, dest, length);
 *		void MoveMem (APTR, APTR, ULONG)
 *
 * FUNCTION
 *		MoveMem is a general purpose, fast memory copy function. It can deal with
 *		arbitrary length, with its pointers on arbitrary alignments.
 *
 *		The function can deal with arbitrary overlapping memory blocks.
 *
 *		The internal implementation of this function will change from system to
 *		system, and may be implemented via hardware DMA.
 *
 * INPUTS
 *		source	- a pointer to the source data region.
 *		dest		- a pointer to the destination data region.
 *		length	- the size (in bytes) of the memory area. Zero copies zero bytes.
 */

#define ClearMem(mem,size) ZeroMemory((mem),(size))
/* SYNOPSIS
 * 	ClearMem(mem, size)
 * 	void ClearMem(APTR, ULONG)
 *
 * FUNCTION
 *		This function clears a block of memory.
 *		This means the whole block of memory if filled with ZERO.
 *		It can deal with arbitrary length, with its pointers on arbitrary
 *		alignments.
 *		The internal implementation of this function will change from system to
 *		system, and may be implemented via hardware DMA.
 *
 * INPUTS
 *		mem	- a pointer to the data region that should be cleared.
 *		size	- the size (in bytes) of the memory area. Zero clears zero bytes.
 */

#define IsValidMemList(memList) (((ULONG)(memList)) > (ULONG)0x0000FFFF)
/* SYNOPSIS
 *		BOOL IsValidMemList (struct MemList *);
 *
 *		succeed = IsValidMemList (memList);
 *
 * FUNCTION
 *		Because of the different return values - returned by AllocEntry() under
 *		the different systems - that indicates failure, you should use this macro
 *		to test the result of the function AllocEntry(), to write compatible code.
 *
 * INPUT
 *		memList - a pointer to a MemList structure as returned by AllocEntry().
 *
 * RESULT
 *		A boolean value indicating that the MemList structure is a valid MemList
 *		structure is returned.
 *		If TRUE is returned, AllocEntry() has succeed, else AllocEntry() failed
 *		and memList is the requirement that failed (something like MEMF_CHIP or
 *		MEMF_FAST etc.).
 *
 * EXAMPLE
 *			if (IsValidMemList(memlist = AllocEntry (aMemList)))
 *			{
 *				// succeed
 *			}
 *			else
 *			{
 *				// failure, memlist is the type of memory we failed to allocate
 *			}
 */

#endif	/* _AMIGA */

#endif	/* _EXEC_PROTOS_H_ */