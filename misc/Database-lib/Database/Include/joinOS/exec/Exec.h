#ifndef _EXEC_H_
#define _EXEC_H_ 1

/* Exec.h
 *
 *	This are the basic functions and structures needed to implement something
 * like Exec under Windoof.
 *	These functions implement the basics needed to get shared access to memory
 * and system structures from multiple (Windoof) processes.
 */

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

#ifdef _AMIGA

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef EXEC_EXECBASE_H
#include <exec/execbase.h>
#endif

#else

/* --- Global variable shared by every (Windoof) process -------------------- */

extern struct ExecBase *SysBase;

/* --- Granularity of shared memory ----------------------------------------- */

/* Granularity of shared memory blocks.
 */
#define SHARED_BLOCKSIZE 0x00010000

/* Already allocated shared memory-blocks are marked as MEMF_UNLOCKED, if they
 * are freed, so they can be reused.
 */
#define MEMF_LOCKED		0x00000000	/* in use */
#define MEMF_UNLOCKED	0x00000001	/* not in use */

/* --- Library structure, basic structure of all librarys ------------------- */

/* A pointer to an appended structure of this type is returned by an
 * OpenLibrary(), this is the entry-point for every exec-alike library.
 */
struct Library		/* word-aligned, size 34 */
{
	struct Node lib_Node;
	UBYTE lib_Flags;			/* internal flags, DON'T DEPEND ON VALUES FOUND HERE */
	UBYTE lib_pad;
	UWORD lib_NegSize;		/* number of bytes before library, for compatibility
									 * only, always 0 */
	UWORD lib_PosSize;		/* number of bytes after library */
   UWORD lib_Version;		/* major */
   UWORD lib_Revision;		/* minor */
	APTR	lib_IdString;		/* ASCII identification */
	ULONG lib_Sum;				/* the checksum itself, for compatibility only, 0 */
	UWORD	lib_OpenCnt;		/* number of current opens */
};

/* defines for lib_Flags
 */
#define LIB_LOADDYNAMIC 1	/* library is loaded dynamically */

/* --- Basic Structure to hold Entry-points to systems lists ---------------- */

/* This is the base structure, holding all information needed for Exec.
 * THIS STRUCTURE IS STRICTLY PRIVATE, NEVER ACCESS IT FROM APPLICATION CODE.
 */
struct ExecBase
{
	struct Library LibNode;		/* standard library node */
	UWORD	SoftVer;					/* kickstart release number (obs.) */
	APTR MemList;					/* Exec's shared memory pool */
	struct List DeviceList;		/* list of all devices */
	struct List LibList;			/* list of all opened librarys */
	struct List PortList;		/* all public message ports */
	struct List TaskReady;		/* all tasks and processes */
	struct List TaskWait;		/* for compatibility only, always empty */
	struct List SemaphoreList;	/* all public signal semaphores */
	ULONG	ex_TaskID;				/* next available task-Id */
};

/* Type definition for function without arguments and with ULONG as return value.
 */
typedef LONG (*FuncPC)(void);

/* --- private structure of the entry-point to the shared system ---------- */

/* THESE STRUCTURES ARE STRICTLY PRIVATE TO EXEC'S FUNCTIONS */

/* This structure is used to handle mapped shared memory regions, this structure
 *	is added to the end of the GeneralControlBlock everytime a new shared memory
 *	region is created.
 */
struct SharedMemHeader
{
	APTR	Address;					/* the addresses of the mapped region.*/
	ULONG Size;						/* the size of the memory region */
	ULONG Type;						/* flag, 0 if the region is in use */
};

/* This structure will have a size of:
 *		sizeof (struct GeneralControlBlock) + (MappedRegions-1) * 8
 *
 * Everytime a new memory region is mapped, MappedRegions is increased by one,
 *	and the pointer to that region and the size of it is appended to this
 * structure.
 */
	
/* This structure is found at the begin of the shared memory block
 *	"GeneralControlBlock", it holds the pointers to the shared structures
 * defined for this system and additional free space, that could be used for
 * temporary process-local memory (this memory should only be used internaly
 * by the Exec's functions and must be used in forbidden state and freed
 * again before leaving forbidden state).
 * This first block is exact 64kByte in size.
 */

struct GeneralControlBlock
{
	struct ExecBase *SysBase;
	APTR DosBase;							/* struct DosBase * */
	APTR IntuiBase;						/* struct IntuiBase * */
	ULONG Offset;							/* Byte-offset to first unused byte */
	ULONG MappedRegions;					/* # of mapped regions */
	struct SharedMemHeader Region;	/* the first shared memory region
												 * (used by Exec) */
};

#endif		/* _AMIGA */
#endif		/* _EXEC_H_ */