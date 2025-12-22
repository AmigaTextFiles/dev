
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Profyler v1.00 © 2022 by Mike Steed					  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Profyler IPC Module							Last modified 20-Dec-21	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 The Inter-Process Communication (IPC) module encapsulates the communication
 functionality of Profyler between itself and external target programs. It
 creates and monitors a public message port that targets may use to signal
 when they are starting up or shutting down, and it scans the OS4 named mem-
 ory space for profile data placed there by target programs, and reads that
 data and passes it to the Database module for processing and storage.

============================================================================
***************************************************************************/

/***************************************************************************
============================================================================

 This program is free software; you can redistribute it and/or modify it
 under the terms of the GNU General Public License as published by the Free
 Software Foundation; either version 2 of the License, or (at your option)
 any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 more details.
 
 You should have received a copy of the GNU General Public License along
 with this program; if not, write to the Free Software Foundation, Inc.,
 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

============================================================================
***************************************************************************/

/***************************************************************************
*																		   *
* Setup																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Includes ===

#define __NOLIBBASE__
#define __NOGLOBALIFACE__

#include <exec/types.h>
#include <exec/ports.h>
#include <exec/nodes.h>
#include <exec/exectags.h>
#include <exec/avl.h>
#include <dos/dosextens.h>

#include "Profyler.h"
#include "ProfIPC.h"
#include "ProfyleData.h"
#include "ProfDB.h"
#include "ProfGUI.h"

#include <string.h>

#include <proto/exec.h>
#include <proto/dos.h>

// -------------------------------------------------------------------------
// === Prototypes ===

struct ProfyleData *ObtainTargetData(uint32 Target);
void ReleaseTargetData(uint32 Target);
BOOL NewTarget(uint32 Target, struct ProfyleData *ProfData);
BOOL GetProfileData(uint32 Target, 	struct ProfyleData *ProfData);
BOOL TargetStart(struct ProfyleMessage *Msg);
void TargetStop(struct ProfyleMessage *Msg);

// -------------------------------------------------------------------------
// === Macros ===


/***************************************************************************
*																		   *
* Data																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Defines ===

// If the database has more than this number of entries we assume it will
// take some time to read or update it, and so put the GUI to sleep while
// we're doing so.
#define BIG_DBASE	50

// -------------------------------------------------------------------------
// === Locals ===

// We depend on some of these variables being NULL on startup; the startup
// code ensures this (BSS is zeroed).

// The IPC module's local data. It's small, so we put it in BSS to avoid the
// need to allocate it.
static struct
{
	// The public message port to which targets communicate.
	struct MsgPort *ProfylerPort;
} Envmt;

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

 ProfData = ObtainTargetData(Target)

 Locate the OS4 named memory that corresponds to the specified target pro-
 gram. This memory is created by that program, and contains the profile data
 it has gathered. If there is no such memory then NULL is returned.

 If found, the named memory is locked, to allow it to be accessed without in-
 terference from the target program. If the target tries to access the memory
 while locked, it will be put to sleep.

 Likewise, if we try to obtain the named memory while the target program has
 it locked, we will be put to sleep until the lock is released. This won't
 take long, as the target only locks the memory briefly while updating the
 profile data at entry to and exit from each profiled function.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	cause NULL to be returned. 

 Out ----------------------------------------------------------------------

 ProfData = A pointer to the profile data associated with the target, or NULL
	if no such data could be found.

***************************************************************************/

struct ProfyleData *ObtainTargetData(uint32 Target)
{
	struct ProfyleData *ProfData;
	TEXT Name[TARGET_NAME_LEN];

	// Abort if the target value is invalid.
	if((Target == 0) || (Target > MAX_TARGETS)) return(NULL);

	// Turn the target number into the name of the associated named memory.
	strcpy(Name, TARGET_NAME);
	Name[TARGET_NUM] = '0' + (TEXT)Target;

	// Try to get a lock on memory with that name in the Profyler name space.
	// If the memory is already locked we'll sleep here until it's unlocked,
	// If the named memory can't be found the pointer will be NULL.
	ProfData = IExec->LockNamedMemory(PROFYLE_NAMESPACE, Name);

	// Return the result to the caller.
	return(ProfData);
}

/***************************************************************************

 ReleaseTargetData(Target)

 Unlock the OS4 named memory corresponding to the specified target program.
 This allows the target program to again access the memory without being put
 to sleep. Do nothing if the memory can't be found.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values are
	ignored.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void ReleaseTargetData(uint32 Target)
{
	TEXT Name[TARGET_NAME_LEN];

	// Abort if the target value is invalid.
	if((Target == 0) || (Target > MAX_TARGETS)) return;

	// Turn the target number into the name of the associated named memory.
	strcpy(Name, TARGET_NAME);
	Name[TARGET_NUM] = '0' + (TEXT)Target;

	// Unlock any memory with that name. Do nothing if no such memory is
	// found. If the target program is sleeping while waiting to obtain a
	// lock on the memory it will resume running.
	IExec->UnlockNamedMemory(PROFYLE_NAMESPACE, Name);
}

/***************************************************************************

 Success = NewTarget(Target, ProfData)

 Create a new database and GUI tab for the specified target. The name of the
 target program is extracted from the supplied profile data, and is used to
 give a title to the GUI tab. If the target already has a database/GUI tab,
 they are deleted/closed to make way for the new ones.

 This function only creates the database and GUI tab; it does not extract or
 display any profile data that might be present. Use GetProfileData() and
 DB_Display() to do that.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values cause
	failure.

 ProfData = A pointer to the profile data associated with the target, as re-
	turned by ObtainTargetData(). NULL causes failure.

 Out ----------------------------------------------------------------------

 Success = TRUE if the new database and GUI tab were created, or FALSE if
	not.

***************************************************************************/

BOOL NewTarget(uint32 Target, struct ProfyleData *ProfData)
{
	struct Process *Proc;
	struct CommandLineInterface *CLI;
	STRPTR TargetName;
	BOOL Success;

	// Assume failure until we've confirmed otherwise.
	Success = FALSE;

	// Abort if the input parameters are invalid.
	if((Target == 0) || (Target > MAX_TARGETS) || !ProfData) return(Success);

	// For convenience, assume that the profile data points to a DOS process
	// rather than an Exec task, since the former contains the latter, allow-
	// ing us to access either without casting.
	Proc = (struct Process *)ProfData->Target;

	// Find the name of the target program, which varies depending on how it
	// was launched.
	if((Proc->pr_Task.tc_Node.ln_Type == NT_PROCESS) && Proc->pr_CLI)
	{
		// The target program is a process, and it was launched from a CLI or
		// shell. Extract the name from the associated CLI.
		CLI = (struct CommandLineInterface *)BADDR(Proc->pr_CLI);
		TargetName = BADDR(CLI->cli_CommandName);

		// The name is a BSTR, so we have to skip the length byte at the be-
		// ginning. Under OS4 all BSTRs are NUL terminated, so we can then
		// treat it as a regular ASCIIZ string.
		if(TargetName) TargetName++;

		// Strip off any path that may be present, so we get just the program
		// name. NULL pointers pass through unchanged.
		TargetName = (STRPTR)IDOS->FilePart(TargetName);
	}
	else
	{
		// Tasks and WB-launched programs have the name in the task's link
		// node.
		TargetName = Proc->pr_Task.tc_Node.ln_Name;
	}

	// If the name pointer ends up NULL for some reason, substitute a blank
	// name.
	if(!TargetName) TargetName = "";

	// If there is already a database for this target, delete it and the cor-
	// responding GUI tab to make way for the new ones. No harm if either the
	// database or the GUI tab do not exist.
	GUI_RemoveTarget(Target);

	// Create a new database for the new target. Fail if we can't.
	if(DB_Create(Target, TargetName))
	{
		// We've got a database. Create a GUI tab to display it.
		if(GUI_AddTarget(Target, DB_Title(Target)))
		{
			// Success!
			Success = TRUE;
		}
		else
		{
			// We failed to create the GUI tab. Delete the database, since
			// we've got no way to display it.
			DB_Delete(Target);
		}
	}

	// Let the caller know how it went.
	return(Success);
}

/***************************************************************************

 Changed = GetProfileData(Target, ProfData)

 Extract the profile data captured by the target program from the given named
 memory block, and write it to the specified target's database. New records
 are added to the database as required, while existing records are updated to
 reflect the latest data. Cross-function fields in the database (the percent-
 ages) are updated to reflect the new database contents. The profile data is
 assumed to be locked, so it will not be modified while being read.

 The GUI is not updated to reflect any changes to the database; DB_Display()
 may be used to do this, if desired.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values cause
	failure.

 ProfData = A pointer to the profile data associated with the target, as re-
	turned by ObtainTargetData(). NULL causes failure.

 Out ----------------------------------------------------------------------

 Changed = TRUE if any changes were made to the database that might need to
	be sent to the GUI, or FALSE if there were no changes. FALSE is also re-
	turned if the input parameters are invalid.

***************************************************************************/

BOOL GetProfileData(uint32 Target, 	struct ProfyleData *ProfData)
{
	struct FuncRecord *FuncRec;
	BOOL Changed;

	// Assume no changes to the database until we learn otherwise.
	Changed = FALSE;

	// Abort if the input parameters are invalid.
	if((Target == 0) || (Target > MAX_TARGETS) || !ProfData) return(Changed);

	// Get a pointer to the first profile entry, or NULL if there aren't any.
	FuncRec = (struct FuncRecord *)
		IExec->AVL_FindFirstNode((struct AVLNode *)ProfData->Database);

	// Loop as long as there are entries to read.
	while(FuncRec)
	{
		// Extract the data from the entry and send it to the database. Note
		// that DB_PutRecord() returns TRUE even if the data written is the
		// same as the existing data.
		Changed |= DB_PutRecord(Target, FuncRec->FuncID, FuncRec->CallCount,
			FuncRec->InclusiveTime, FuncRec->ExclusiveTime);

		// Locate the next entry, or NULL if none.
		FuncRec = (struct FuncRecord *)
			IExec->AVL_FindNextNodeByAddress((struct AVLNode *)FuncRec);
	}

	// If any changes (may) have been made to the database, update the per-
	// centages.
	if(Changed) DB_Totalize(Target);

	// Let the caller know if the database was updated.
	return(Changed);
}

/***************************************************************************

 Success = TargetStart(Msg)

 Process a startup message received at the public message port. Target pro-
 grams send this message to let us know that they are starting up. We respond
 by creating a database to hold the target's profile data, and opening a tab
 in the GUI to display that information. If the target already has a database
 and GUI tab, they are deleted and replaced by the new ones.

 The target program is asleep while we process the startup message; it will
 resume running when we reply to the message. This way the time required to
 process the message does not count as part of the target's execution time.

 In -----------------------------------------------------------------------

 Msg = A pointer to the startup message sent by the target program.

 Out ----------------------------------------------------------------------

 Success = TRUE if the startup message was successfully processed, or FALSE
	if not.

***************************************************************************/

BOOL TargetStart(struct ProfyleMessage *Msg)
{
	uint32 Target;
	struct ProfyleData *ProfData;
	BOOL Success;

	// Assume failure until we've confirmed otherwise.
	Success = FALSE;

	// Which target is starting up?
	Target = Msg->TargetNum;

	// Obtain the named memory where the target is storing its profile data.
	// Abort if the memory can't be found or if the target number is bogus.
	ProfData = ObtainTargetData(Target);
	if(!ProfData) return(Success);

	// Create a new database and GUI tab for the target.
	Success = NewTarget(Target, ProfData);

	// Release the memory holding the profile data.
	ReleaseTargetData(Target);

	// Let the caller know how it went.
	return(Success);
}

/***************************************************************************

 TargetStop(Msg)

 Process a shutdown message received at the public message port. Target pro-
 grams send this message to let us know that they are shutting down. We re-
 spond by extracting the final profile data from the target and updating the
 GUI to display that information.

 The target program is asleep while we process the shutdown message; it will
 resume running (and will thereafter terminate) when we reply to the message.
 This way the time required to process the message does not count as part of
 the target's execution time.

 In -----------------------------------------------------------------------

 Msg = A pointer to the shutdown message sent by the target program.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void TargetStop(struct ProfyleMessage *Msg)
{
	uint32 Target;
	struct ProfyleData *ProfData;

	// Which target is shutting down?
	Target = Msg->TargetNum;

	// Obtain the named memory where the target is storing its profile data.
	// Abort if the memory can't be found or if the target number is bogus.
	ProfData = ObtainTargetData(Target);
	if(!ProfData) return;

	// If the database is large, put the GUI to sleep while we process it.
	if(ProfData->DBaseSize > BIG_DBASE) GUI_Sleep(TRUE);

	// Extract the profile data and use it to update the database. Update the
	// GUI to reflect any changes to the data.
	if(GetProfileData(Target, ProfData)) DB_Display(Target);

	// Reawaken the GUI. No harm if it wasn't asleep.
	GUI_Sleep(FALSE);

	// Release the memory holding the profile data.
	ReleaseTargetData(Target);
}

// -------------------------------------------------------------------------
// === Public code ===

/***************************************************************************

 Success = IPC_Start()

 Initialize the IPC module when the program starts up. If successful, the
 module is ready for action. If not, the program must abort. If initializa-
 tion fails then everything has been cleaned up, and there is no need to
 call IPC_Stop().

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Success = TRUE if the initialization was successful, or FALSE if it failed.

***************************************************************************/

BOOL IPC_Start(void)
{
	// Create the public message port.
	Envmt.ProfylerPort = IExec->AllocSysObjectTags(ASOT_PORT,
		ASOPORT_Public, TRUE, ASOPORT_Name, PROFYLER_PORT_NAME, TAG_END);
	if(!Envmt.ProfylerPort) goto Fail;

	// Done- return success.
	return(TRUE);

	// Come here if startup fails.
Fail:
	// Clean up anything that was successfully created.
	IPC_Stop();

	// Let the caller know we've failed.
	return(FALSE);
}

/***************************************************************************

 IPC_Stop()

 Shut down the IPC module when the program is quit. No harm comes if the
 module has never been initialized, if the initialization failed, or if
 IPC_Stop() has already been called.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void IPC_Stop(void)
{
	struct Message *Msg;

	// Delete the public message port, if present.
	if(Envmt.ProfylerPort)
	{
		// Prevent any new messages from arriving at the port from targets
		// that may still be running.
		IExec->Forbid();

		// Reply to any messages that are present at the port, to allow the
		// targets that sent them to resume operation.
		while(Msg = IExec->GetMsg(Envmt.ProfylerPort)) IExec->ReplyMsg(Msg);

		// Now we can safely delete the port.
		IExec->FreeSysObject(ASOT_PORT, (APTR)Envmt.ProfylerPort);

		// Okay to let the targets run now.
		IExec->Permit();
	}

	// Zero out the environment, so we know it's all disposed of in case
	// we're called again.
	memset(&Envmt, 0, sizeof(Envmt));
}

/***************************************************************************

 Signal = IPC_GetSignal()

 Return the signal mask associated with the public message port. This may be
 added to any other signals the program is waiting for, to allow it to wake
 up when a message arrives at the port.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Signal = The signal mask used by the public message port, suitable for use
	in a call to IExec->Wait().

***************************************************************************/

uint32 IPC_GetSignal(void)
{
	// Return a bitmask made from the message port's signal bit number.
	return(1 << Envmt.ProfylerPort->mp_SigBit);
}

/***************************************************************************

 IPC_Update(Target)

 Locate the named memory corresponding to the specified target program, ex-
 tract the profile data from it, write the data to the target's database,
 then update the target's GUI tab with the new database contents.

 The named memory holding the profile data is locked during this operation,
 which causes the target program to sleep when it tries to access the profile
 data. This prevents the data from changing while it is being read, and also
 prevents the time required for the update from being counted as part of the
 target's execution time.

 It is assumed that a database and GUI tab for the specified target already
 exists. If not then no update will occur. Use IPC_Scan() to find targets
 that aren't currently being tracked.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values are
	ignored.

 Out ----------------------------------------------------------------------

 Nothing

***************************************************************************/

void IPC_Update(uint32 Target)
{
	struct ProfyleData *ProfData;

	// Abort if the target number is invalid, or there is no database or GUI
	// tab for the target.
	if(!DB_Check(Target) || !GUI_CheckTarget(Target)) return;

	// We're good to go. Obtain the named memory for the target. Abort if
	// we can't. If the target was updating the data we'll sleep here until
	// it's done (which shouldn't be long).
	ProfData = ObtainTargetData(Target);
	if(!ProfData) return;

	// We've locked the named memory; the target will sleep if it tries to
	// access it. If the database is large, put the GUI to sleep while we
	// process it.
	if(ProfData->DBaseSize > BIG_DBASE) GUI_Sleep(TRUE);

	// Extract the profile data and update the database. If the database was
	// updated, update the GUI tab as well. Because the target is asleep, the
	// time required to do this does not count as part of the target's
	// execution time.
	if(GetProfileData(Target, ProfData)) DB_Display(Target);

	// Reawaken the GUI. No harm if it wasn't asleep.
	GUI_Sleep(FALSE);

	// Release the named memory. The target program will resume running.
	ReleaseTargetData(Target);
}

/***************************************************************************

 IPC_Scan()

 Scan Profyler's named memory space for memory blocks belonging to target
 programs that are running. If any are found that that are not currently be-
 ing tracked, add a database and GUI tab and extract and display the associ-
 ated profile data.

 Targets that already have a database are ignored. Specifically, their data-
 bases are not updated to reflect any changes to their profile data (IPC_Up-
 date() must be used to accomplish that). Nor will it be detected if the tar-
 get program is a different one than in the database; to detect that the GUI
 tab must be closed (thus deleting the database) before scanning.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void IPC_Scan(void)
{
	struct ProfyleData *ProfData;
	uint32 Target;

	// Check each possible target number.
	for(Target = 1; Target <= MAX_TARGETS; Target++)
	{
		// Only look for targets that don't already have a database.
		if(DB_Check(Target)) continue;

		// See if we can locate the target's named memory. If it exists and
		// the target is updating it, we'll sleep here until it's done.
		ProfData = ObtainTargetData(Target);
		if(!ProfData) continue;

		// We've located (and locked) the named memory associated with the
		// target. Now it's the target that will sleep if it tries to access
		// the memory. Create a new database and GUI tab for the new target.
		if(NewTarget(Target, ProfData))
		{
			// If the database is large, put the GUI to sleep while we
			// process it.
			if(ProfData->DBaseSize > BIG_DBASE) GUI_Sleep(TRUE);

			// Extract the profile data (if any) from the target, and update
			// the GUI to display it. Because the target program is asleep,
			// the time required to do this does not count as part of the
			// program's execution time.
			if(GetProfileData(Target, ProfData)) DB_Display(Target);

			// Reawaken the GUI. No harm if it wasn't asleep.
			GUI_Sleep(FALSE);
		}

		// Release the named memory. The target will resume running.
		ReleaseTargetData(Target);
	}
}

/***************************************************************************

 IPC_Incoming()

 A signal from the public message port has occurred, indicating that a mes-
 sage has arrived at the port. Fetch the message and confirm that it comes
 from a target program being profiled. If so, process it accordingly. If the
 message is not from a target program just reply to it and otherwise ignore
 it. Repeat for any other messages that may be present at the port. Return
 when the port is empty.

 Safely does nothing if there is no message at the port.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void IPC_Incoming()
{
	struct ProfyleMessage *Msg;

	// Remove a message from the port. Repeat as long as messages are pres-
	// ent, in case more than one has arrived. Do nothing if no messages are
	// present.
	while(Msg = (struct ProfyleMessage *)IExec->GetMsg(Envmt.ProfylerPort))
	{
		// Got a message. Confirm that it's from a target program. If it is,
		// the program will be stopped, waiting for us to reply.
		if((Msg->Mesg.mn_Length == PROFMSG_SIZE) &&
			(Msg->MessageID == PROFYLE_MSG_ID))
		{
			// Looks good- process the message. Ignore messages whose type
			// we don't recognize.
			if(Msg->Event == TARGET_STARTUP) TargetStart(Msg);
			else if(Msg->Event == TARGET_SHUTDOWN) TargetStop(Msg);
		}

		// Reply to the message, whether it's from a target program or not.
		// If it is, the program will resume running.
		IExec->ReplyMsg((struct Message *)Msg);
	}
}
