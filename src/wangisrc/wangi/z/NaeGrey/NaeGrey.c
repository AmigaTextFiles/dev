//
// NaeGrey, 1995 Lee Kindness.
// Patches the Fault() and PrintFault() functions in dos.library so that
// they return a user defined strings! (ie. Bananna in diskdrive :)
//
// This source is in the public domain, do with it as you wish...
//

// ANSI headers
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
// #include <stdio.h>

// Amiga headers
#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <dos/dos.h>

// Protos
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/dos.h>

// Amiga.lib
#include <clib/alib_protos.h>

#include "NaeGrey_rev.h"

// The OpenScreen function offsets
#define OpenScreenOffset -198
#define OpenScreenTagListOffset -612

// File from which the strings are to read from
#define ERRSFILENAME "S:FaultStrings"

enum {
	JMPINSTR = 0x4ef9
};

typedef struct JmpEntry {
	UWORD Instr;
	APTR Func;
} JmpEntry;

// ErrorStringNode
typedef struct ESNode {
	struct ESNode *es_Succ;
	struct ESNode *es_Pred;
	UBYTE es_Type;
	BYTE es_Pri;
	STRPTR es_String;
	LONG es_Number;
} ESNode;

// Prototypes
static BOOL OpenScreenReplace(void);
static void OpenScreenRestore(void);
static BOOL OpenScreenTagListReplace(void);
static void OpenScreenTagListRestore(void);
static struct Screen * __asm new_OpenScreen(register __a0 struct NewScreen *,
                             register __a6 struct Library *);
static struct Screen * __asm new_OpenScreenTagList(register __a0 struct NewScreen *,
                             register __a1 ULONG *,
                             register __a6 struct Library *);

// Local variables
static char verstring[] = VERSTAG;
static char port_name[] = "NaeGrey_Port";
static struct Screen * __asm (*old_OpenScreen)(register __a0 struct NewScreen *,
                             register __a6 struct Library *);
static struct Screen * __asm (*old_OpenScreenTagList)(register __a0 struct NewScreen *,
                             register __a1 ULONG *,
                             register __a6 struct Library *);
static JmpEntry *OpenScreenEntry;
static JmpEntry *OpenScreenTagListEntry;
static struct List *codes;
static struct Remember *grk;

// *************************************************************************
//
// The main method for replacing an Amiga OS function as safe as
// possible is to place the function with a jump table that is
// allocated.  While the function is replaced, the jump table simply
// jumps to my routine:
//
// jmp  _new_OpenScreen
//
// When the user asks the program to quit, we can't simply put the
// pointer back that SetFunction() gives us since someone else might
// have replaced the function.  So, we first see if the pointer we
// get back points to the out jump table.  If so, then we _can_ put
// the pointer back like normal (no one has replaced the function
// while we has it replaced).  But if the pointer isn't mine, then
// we have to replace the jump table function pointer to the old
// function pointer:
//
// jmp  _old_OpenScreen
//
// Finally, we only deallocate the jump table _if_ we did not have
// to change the jump table.
//

main(void)
{
	struct MsgPort *port;
	struct Library *lib;
	
	// Work around...
	lib = (struct Library *)IntuitionBase;
	if (lib->lib_Version > 36) {
		grk = NULL;
		// FindPort() Forbid()
		Forbid();

		port = FindPort(port_name);
		if (port) {
			struct MsgPort *reply_port;
			
			// We are already active, send a msg to the other 
			// occurance telling it to quit
	
			// Create a reply port
			reply_port = CreateMsgPort();
			if (reply_port) {
				struct Message msg;
	
				// Set fields in message structure
				msg.mn_ReplyPort = reply_port;
				msg.mn_Length = sizeof(struct Message);
	
				// Send the message
				PutMsg(port, &msg);
	
				// Finished with port, so stop FindPort() Forbid()
				Permit();
	
				// Wait for a reply
				do {
					WaitPort(reply_port);
				} while (GetMsg(reply_port) == NULL);
	
				// Clear and Delete reply_port Forbid()
				Forbid();
	
				// Clear any messages
				while (GetMsg(reply_port));
	
				// Delete the reply port
				DeleteMsgPort(reply_port);
	
				// Clear and Delete reply_port stop Forbid()
				Permit();
			} else {
				// Finished with port, so stop FindPort() Forbid()
				Permit();
			}
		} else if (port = CreateMsgPort()) {
			struct Message *msg;
	
			// Finished with port, so stop FindPort() Forbid()
			Permit();
	
			// Setup quitting port
			port->mp_Node.ln_Name = port_name;
			port->mp_Node.ln_Pri = -120;
	
			// Add quitting port to public list
			AddPort(port);
	
			// Attempt to replace function
			if (OpenScreenReplace()) {
				if (OpenScreenTagListReplace()) {
					ULONG sig, sret;
					BOOL finished;
					finished = FALSE;
					sig = 1 << port->mp_SigBit;
					// Wait for someone to signal me to quit or CTRL-C
					do {
						sret = Wait(SIGBREAKF_CTRL_C | sig);
						if (sret & sig) {
							// signaled
							msg = GetMsg(port);
							if (msg) {
								ReplyMsg(msg);
								finished = TRUE;
							}
						}
						if (sret & SIGBREAKF_CTRL_C)
							finished = TRUE;
					} while (!finished);
		
					// Restore function
					OpenScreenTagListRestore();
				}
				// Restore function
				OpenScreenRestore();
			}
	
			// Remove port from public access
			RemPort(port);
	
			// Clear and Delete port Forbid()
			Forbid();
	
			// Clear the port of messages
			while (msg = GetMsg(port)) {
				ReplyMsg(msg);
			}
	
			// Closedown quitting port
			DeleteMsgPort(port);
	
			// Clear and Delete port stop Forbid()
			Permit();
		}
		FreeRemember(&grk, TRUE);
	}
}

// *************************************************************************

static BOOL OpenScreenReplace(void)
{
	// Allocate the jump table
	OpenScreenEntry = AllocMem(sizeof(JmpEntry), 0);
	if (OpenScreenEntry) {
		// Replacement Forbid()
		Forbid();

		// Replace the function with pointer to jump table
		old_OpenScreen = SetFunction((struct Library *)IntuitionBase,
											OpenScreenOffset, (ULONG (*)())OpenScreenEntry);

		// Setup the jump table
		OpenScreenEntry->Instr = JMPINSTR;
		OpenScreenEntry->Func = new_OpenScreen;

		// Clear the cpu's cache so the execution cache is valid
		CacheClearU();

		// Stop the replacement Forbid()
		Permit();

		return TRUE;
	} else {
		return FALSE;
	}
}

// *************************************************************************

static void OpenScreenRestore(void)
{
	BOOL my_table;
	ULONG (*func)();

	// Fix back Forbid()
	Forbid();

	// Put old pointer back and get current pointer at same time
	func = SetFunction((struct Library *)IntuitionBase, OpenScreenOffset,
							(ULONG (*)())old_OpenScreen);

	// Check to see if the pointer we get back is ours
	if ((JmpEntry *)func != OpenScreenEntry) {
		// If not, leave jump table in place
		my_table = FALSE;
		SetFunction((struct Library *)IntuitionBase, OpenScreenOffset,
					func);
		OpenScreenEntry->Func = old_OpenScreen;
	} else {
		// If so, free the jump table
		my_table = TRUE;
		FreeMem(OpenScreenEntry, sizeof(JmpEntry));
	}

	// Clear the cpu's cache so the execution cache is valid
	CacheClearU();

	// Stop fix back Forbid()
	Permit();

	// Let the user know if the jump table couldn't be freed
	if (!my_table) {
		DisplayBeep(NULL);
	}

	// Wait 5 seconds to try and guarantee that all tasks have
	// finished executing inside my replacement function before
	// quitting.  There's no real way to guarantee, though.
	Delay(250);
}

// *************************************************************************

static BOOL OpenScreenTagListReplace(void)
{
	// Allocate the jump table
	OpenScreenTagListEntry = AllocMem(sizeof(JmpEntry), 0);
	if (OpenScreenTagListEntry) {
		// Replacement Forbid()
		Forbid();

		// Replace the function with pointer to jump table
		old_OpenScreenTagList = SetFunction((struct Library *)IntuitionBase,
											OpenScreenTagListOffset, (ULONG (*)())OpenScreenTagListEntry);

		// Setup the jump table
		OpenScreenTagListEntry->Instr = JMPINSTR;
		OpenScreenTagListEntry->Func = new_OpenScreenTagList;

		// Clear the cpu's cache so the execution cache is valid
		CacheClearU();

		// Stop the replacement Forbid()
		Permit();

		return TRUE;
	} else {
		return FALSE;
	}
}

// *************************************************************************

static void OpenScreenTagListRestore(void)
{
	BOOL my_table;
	ULONG (*func)();

	// Fix back Forbid()
	Forbid();

	// Put old pointer back and get current pointer at same time
	func = SetFunction((struct Library *)IntuitionBase, OpenScreenTagListOffset,
							(ULONG (*)())old_OpenScreenTagList);

	// Check to see if the pointer we get back is ours
	if ((JmpEntry *)func != OpenScreenTagListEntry) {
		// If not, leave jump table in place
		my_table = FALSE;
		SetFunction((struct Library *)IntuitionBase, OpenScreenTagListOffset,
					func);
		OpenScreenTagListEntry->Func = old_OpenScreenTagList;
	} else {
		// If so, free the jump table
		my_table = TRUE;
		FreeMem(OpenScreenTagListEntry, sizeof(JmpEntry));
	}

	// Clear the cpu's cache so the execution cache is valid
	CacheClearU();

	// Stop fix back Forbid()
	Permit();

	// Let the user know if the jump table couldn't be freed
	if (!my_table) {
		DisplayBeep(NULL);
	}

	// Wait 5 seconds to try and guarantee that all tasks have
	// finished executing inside my replacement function before
	// quitting.  There's no real way to guarantee, though.
	Delay(250);
}

// *************************************************************************

static struct Screen * __saveds __asm new_OpenScreen(register __a0 struct NewScreen *nscrn,
                                      register __a6 struct Library *lib)
{
	//printf("OpenScreen()\n");
	return(old_OpenScreen(nscrn, lib));
}

// *************************************************************************

static struct Screen * __saveds __asm new_OpenScreenTagList(register __a0 struct NewScreen *nscrn,
                                      register __a1 ULONG *tags,
                                      register __a6 struct Library *lib)
{
	//printf("OpenScreenTagList()\n");
	return(old_OpenScreenTagList(nscrn, tags, lib));
}

// *************************************************************************

