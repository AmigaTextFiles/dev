/* DOSBase.h
 *
 * The basic structures used for AmigaDOS library-base.
 */

#ifndef _DOSBASE_H_
#define _DOSBASE_H_ 1

#ifndef _AMIGADOS_H_
#include <joinOS/dos/AmigaDOS.h>
#endif

#ifdef _AMIGA

#ifndef DOS_DOSEXTENS_H
#include <dos/dosextens.h>
#endif

#else

#ifndef _EXEC_H_
#include <joinOS/exec/exec.h>
#endif

#ifndef _SEMAPHORE_H_
#include <joinOS/exec/semaphore.h>
#endif

/* --- ErrorString structure ------------------------------------------------ */

/* This structure defines the messages for AmigaDos error codes as returned
 * by Fault() or PrintFault().
 * The main purpose of this array is to allow for easier localization of the
 * operating system.
 * Since it contains undocumented private messages used internally by the
 * system (e.g. for system requesters), it should probably not be altered by
 * anything but the locale.library.
 */

struct ErrorString
{
	LONG *estr_Nums;
	UBYTE *estr_Strings;
};

/* estr_Nums points to an array of valid AmigaDos error code ranges (two
 * longwords for each range, the lower boundary being the first longword),
 * i.e. those codes for which messages are stored in estr_Strings. The
 * range array is terminated by a zero value for the lower boundary of a
 * range. the messages themselves are NUL-terminated strings preceded by
 * the length of the entire message including the teminatior in the first
 * byte.
 */

/* --- DosLibrary structure ------------------------------------------------- */

/* This is the entry-point to the AmigaDOS library.
 * A pointer to this structure is returned, when the AmigaDOS library is
 * opened using Exec's OpenLibrary()-call.
 * This structure is nearly completely different to that one found in Amiga
 * systems.
 *
 * NEVER ACCESS ANY FIELDS OF THIS STRUCTURE DIRECTLY FROM WITHIN USER -
 * APPLICATIONS, EXCEPT THE FIELDS IN dl_lib OR dl_Root.
 *
 * dl_Error may be also save to access, but there is no reason for any
 * user-application to access the entries in the structure found there
 * direct.
 */

struct DosLibrary
{
	struct Library	dl_lib;		/* underlying Exec library */
	struct RootNode *dl_Root;	/* pointer to RootNode, described below */
	APTR	dl_GV;					/* obsolet, not used */
	LONG	dl_A2;					/* obsolet, not used */
	LONG	dl_A5;					/* obsolet, not used */
	LONG	dl_A6;					/* obsolet, not used */
	struct ErrorString *dl_Errors;	/* pointer to messages for AmigaDos error codes */
};

/* --- RootNode structure -------------------------------------------------- */

/* A pointer to this structure is found in DosLibrary's field dl_Root.
 * This structure exists only once.
 */

struct RootNode
{
	BPTR rn_TaskArray;
		/* BPTR to struct TaskArray, obsolet, copy of first TaskArray found in
		 * rn_CliList */
	BPTR rn_ConsoleSegment;
		/* BPTR to SegList for new CLI processes */
	struct DateStamp rn_Time;
		/* current date, updated on every call to DateStamp() */
	LONG rn_RestartSeg;
		/* obsolet, no longer used (pre-2.0) */
	BPTR rn_Info;
		/* BPTR to struct DosInfo, described below */
	BPTR rn_FileHandlerSegment;
		/* BPTR to SegList of default filehandler process */
	struct MinList rn_CliList;
		/* list of struct CliProcList */
	struct MsgPort *rn_BootProc;
		/* the processID of the boot filesystem. It is the default for the field
		 * pr_FileSystemTask of the Process structure to be able to resolve the
		 * ZERO lock.
		 */
	BPTR rn_ShellSegment;
		/* BPTR to the AmigaShell's SegList, currently the same as rn_ConsoleSegment */
	BPTR rn_Flags;
		/* Dos flags */
};

/* Defines for rn_Flags:
 */
#define RNB_WILDSTAR	24			/* if set, the '*' character could be used as
										 * universal wild card (as a synonym for "#?" */
#define RNF_WILDSTAR	(1L<<24)

#define RNB_PRIVATE1	1	/* private for dos */
#define RNF_PRIVATE1	2

/* --- DosInfo structure ---------------------------------------------------- */

/* The DosInfo structure, which is pointed by the rn_Info field in the RootNode
 * structure, is used to handle informations about the dos-handlers and all
 * "resident" programs.
 */

struct DosInfo
{
	BPTR di_McName;	/* ? RootNameSpace for utility.library's NamedObjects ? */
	BPTR di_DevInfo;	/* BPTR to struct DosList */
	BPTR di_Devices;	/* ??? */
	BPTR di_Handlers;	/* ??? */
	APTR di_NetHand;	/* BPTR to struct Segment (dos resident list) */
	struct SignalSemaphore di_DevLock;		/* Semaphores used for ... */
	struct SignalSemaphore di_EntryLock;	/* ... LockDosList() */
	struct SignalSemaphore di_DeleteLock;
};

/* di_DevInfo - this field identifies a list of all handlers, volumes, and
 * assignments. As new entries are usually added to the beginning of this
 * list, this BCPL pointer does NOT remain constant and should be used -
 * just like the associated list itself - only with adequate precautions.
 *	There are accessor functions for this list (LockDosList(), NextDosEntry(),
 *	UnLockDosList(), etc.).
 */

/* di_NetHand - this field points to a singly linked list of Segments, a
 * so-called "DOS resident list". This list is used to hold SegLists.
 * It also contains the SegLists of the RootNode structure.
 */

/* di_DevLock, di_EntryLock, and di_DeleteLock are used internally for
 * single-threading the start-up of handlers and all other accesses to
 * the DosList.
 */

/* The other fields of this structure are not officially documented and are
 * used internally.
 */

/* --- TaskArray structure -------------------------------------------------- */

/* A structure of this type is embedded in the structure CliProcList found in
 * RootNode's rn_CliList, and for compatibility only in rn_TaskArray.
 * In rn_TaskArray is found a reverenz to the first entry in the CliProcList.
 */

struct TaskArray
{
	ULONG numCLIs; /* number of entries in the TaskArray (20) */
	struct MsgPort *processID [1];	/* [numCLIs] */
};

/* The size of this structure is variable, depending on 'numCLIs'.
 */

/* --- CliProcList structure ------------------------------------------------ */

/* This structures are linked into the list rn_CliList of the RootNode
 * structure. Every CLI process gets an unique number, which corresponds to
 * an entry in this list, using FindCliProc() programs are able to get the
 * processID of a CLI process associated with a specific number.
 * This is used - per example - by the CLI commands Status or ChangeTaskPri.
 */

struct CliProcList
{
	struct Node cpl_Node;
	LONG cpl_First;				/* number of first CLI entry in this structure */
	struct MsgPort **cpl_Array;/* struct TaskArray * */
	struct TaskArray cpl_TA;
};

/* cpl_Array points to a TaskArray structure as defined above, which must
 * directly follow the CliProcList structure in memory and must have been
 * allocated by a single call to AllocVec().
 * For compatibility with pre-2.0 software, the TaskArray structure pointed
 * by the first entry in the rn_CliList is identical to the one described by
 * rn_TaskArray.
 */

/* --- Segment structure ---------------------------------------------------- */

/* A linked list of this kind is found in DOSBase->di_NetHand, for every
 * resident handler code found in system. (currently the only one used is
 * "FileHandler" - the default filesystem). Others might be added via "Mount".
 *
 * Only access this list using the functions AddSegment(), FindSegment(), and
 * RemSegment().
 */

struct Segment
{
	BPTR seg_Next;		/* BPTR to next Segment */
	LONG seg_UC;		/* counter indicating how many times the code is used */
	BPTR seg_Seg;		/* BPTR to SegList */
	UBYTE seg_Name[4];	/* First 4 bytes of BSTR with handlers name */
};

/* Defines for seg_UC. If seg_UC is greater than zero, it is a counter of
 * how many times the particular SegList is in use.
 * If this value is equal zero, the SegList can savely be UnLoadSeg()ed and
 * the Segment be removed.
 *
 * The SegList - the BPTR 'seg_Seg' points to - should be treated as 'blackbox'
 * you should only use the value found in this field to pass it to dos.library's
 * functions (e.g. UnLoadSeg(), CreateProc(), etc.).
 */

#define CMD_SYSTEM	-1
#define CMD_INTERNAL	-2
#define CMD_DISABLED	-999

/* SPECIAL NOTE
 * 	DON'T USE ANY RESIDENT LIST ENTRY WITH THE seg_UC FIELD SET TO
 *		CMD_INTERNAL FOR USER APPLICATIONS, THEY ARE ABSOLUTELY SYSTEM PRIVATE.
 */

/* --- Handler structure ---------------------------------------------------- */

/* A linked list of this kind is found in DOSBase->dl_Root->rn_Info->di_Handlers,
 * for every started handler, one node of this kind is added to the list,
 * everytime GetHandlerPort() or GetDeviceProc() is called for a specific
 * handler, the access count of the Handler is increased, everytime
 * FreeHandlerPort() or FreeDeviceProc() is called, the count is decreased.
 *
 * NOTE: In a sequence of GetDeviceProc() only the last returned Handlers-node
 * is increased, so only a single call to FreeDeviceProc() is needed to release
 * the handler process.
 * It's up to the system to terminate and free not used Handlers, so you should
 * never parse this list by your own, any handler found might be refused at any
 * time. (AND THIS LIST IS NOT PART OF THE AmigaDOS).
 */

struct Handler
{
	struct Handler *hn_Next;	/* pointer to next handler in list */
	struct MsgPort *hn_Port;	/* pointer to handlers message port */
	ULONG hn_Count;				/* access count of handler */
};

/* --- DosList structure ---------------------------------------------------- */

/* This is a combined structure for devices, assigned directories, and volumes.
 *	For every device, volume, or assignment one node of this type is created
 * and linked to a list found in DosLibrary->di_DevInfo.
 */

struct DosList
{
	BPTR		dol_Next;	/* bptr to next device on list */
	LONG		dol_Type;	/* see DLT below */
	APTR     dol_Task;	/* message port of associated Dos handler */
	BPTR		dol_Lock;	/* lock of root directory for DLT_VOLUME and DLT_DIRECTORY */
	union {
		struct	/* dol_Type == DLT_DEVICE only */
		{
			/* NOTE: This structure is defined completely different to that one
			 * defined for AmigaOS, so don't access it in application code in any way!
			 */
			BSTR	dol_Handler;		/* file name to load if seglist is null */
			LONG	dol_StackSize;		/* stacksize to use when starting process */
			LONG	dol_Priority;		/* task priority when starting process */
			ULONG	dol_Startup;		/* startup message, send to handler */
			BPTR	dol_SegList;		/* SegList used to create handler process */
			BPTR	dol_GlobVec;		/* "Global Vector", misused under Windoof to
											 * distinguish between ROM-handlers and disk-resident handlers */

		} dol_handler;
		struct	/* dol_Type == DLT_VOLUME only */
		{
			struct DateStamp	dol_VolumeDate;	/* creation date, Amiga only */
			BPTR		dol_LockList;	/* outstanding locks */
			LONG		dol_DiskType;	/* BPTR to handler's Dos list entry (Windoof only) */
			LONG		dl_unused;		/* SerialNo of volume */
		} dol_volume;

		struct	/* dol_Type == DLT_DIRECTORY | DLT_LATE | DLT_NONBINDING */
		{
			UBYTE	*dol_AssignName;     /* name for non-or-late-binding assign */
			struct AssignList *dol_List; /* for multi-directory assigns (regular) */
		} dol_assign;
	} dol_misc;

	BSTR		dol_Name;	 /* bptr to bcpl name */
};

#define dol_SerialNo dol_misc.dol_volume.dl_unused	/* alias */

/* structure used for multi-directory assigns. AllocVec()ed. */

struct AssignList {
	struct AssignList *al_Next;
	BPTR		   al_Lock;
};

/* definitions for dol_Type */
#define DLT_DEVICE	0
#define DLT_DIRECTORY	1	/* assign */
#define DLT_VOLUME	2
#define DLT_LATE	3	/* late-binding assign */
#define DLT_NONBINDING	4	/* non-binding assign */
#define DLT_PRIVATE	-1	/* for internal use only */

/* Flags to be passed to LockDosList(), etc */
#define LDB_DEVICES	2
#define LDF_DEVICES	(1L << LDB_DEVICES)
#define LDB_VOLUMES	3
#define LDF_VOLUMES	(1L << LDB_VOLUMES)
#define LDB_ASSIGNS	4
#define LDF_ASSIGNS	(1L << LDB_ASSIGNS)
#define LDB_ENTRY	5
#define LDF_ENTRY	(1L << LDB_ENTRY)
#define LDB_DELETE	6
#define LDF_DELETE	(1L << LDB_DELETE)

/* you MUST specify one of LDF_READ or LDF_WRITE */
#define LDB_READ	0
#define LDF_READ	(1L << LDB_READ)
#define LDB_WRITE	1
#define LDF_WRITE	(1L << LDB_WRITE)

/* actually all but LDF_ENTRY (which is used for internal locking) */
#define LDF_ALL		(LDF_DEVICES|LDF_VOLUMES|LDF_ASSIGNS)

/* --- FileSysStartupMsg ---------------------------------------------------- */

/* A pointer to a structure of this type is stored in dol_Startup.
 *	A packet with a pointer to this structure in dp_Arg2 is passed as
 * initial message to an AmigaDos-handler if it's started.
 */
struct FileSysStartupMsg
{
	ULONG fssm_Unit;		/* unit number of device */
	BSTR fssm_Device;		/* NUL terminated, e.g. under Windoof "C:","D:",... */
	BPTR fssm_Environ;	/* BPTR to struct DosEnvec, currently not implemented */
	ULONG fssm_Flags;		/* flags to be used for accessing Exec device */
};

#endif			/* _AMIGA */

#endif			/* _DOSBASE_H_*/