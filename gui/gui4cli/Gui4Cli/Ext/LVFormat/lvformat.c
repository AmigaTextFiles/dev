
/***********************************************************************
*
*	LVFormat.c by D. Keletsekis (7/10/98) - dck@hol.gr
*
*	This program was made to be used with the CedBar.gc gui, a icon
*	bar for the CygnusEd editor. It can, however, be used anywhere
*	else too, if you need any of it's funtions.
*
*	It creates a port named "LVFormat" and will sit around waiting
*	for commands sent from Gui4Cli using the CALL command. It will
*	then perform whatever action is required, on the CURRENT listview.
*	
*	These are the commands you can CALL from Gui4Cli :
*
*	Indent  [string]
*	- Will indent the current listview by whatever "string"
*	  contains. (Optional - default is 3 spaces).
*	  ex: CALL LVFormat INDENT ">>>"	 ; indent by 3 > thingies..
*
*	UnIndent
*	- Will find the minimum indentation and will move all text
*	  in by that much.
*
*	AGClean
*	- Will remove all AmigaGuide formating from the current LV.
*
*	WRAP [Length] [Justify] [Header]
*	- Will wrap the selected text. The wraping is intelligent
*	  in that it will try to figure out your indentations and
*	  wrap the text so that they remain as they were.
*	- The options you can give are :
*	  Length	 - The length that you want the lines wraped to. The
*			 default, if you give weird values, is 60.
*	  Justify - This must be either "" (i.e. nothing) or :
*			 JUST	  - meaning justify the text by adding extra 
*					  spaces to make up the line length.
*			 UNJUST - remove all these extra spaces.
*			 CENTER - center the text (automatically unjust)
*			 RESET  - remove all extra spacing & indentations.
*	  Header	 - a string of characters that wrap should consider
*			 as part of the line header. This is usefull for
*			 wrapping email messages etc, by giving ">/" or
*			 whatever your mailer uses. Spaces are always in.
*
************************************************************************/
// define this for faster exec calls
#define __USESYSBASE

#include <exec/exec.h>
#include <exec/execbase.h>
#include <exec/memory.h>
#include <dos/dosextens.h>
#include <dos/rdargs.h>
#include <dos/dostags.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include <dos.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <graphics/text.h>

// the Gui4Cli include file
#include <Gui4Cli.h> // use "Gui4Cli.h" if you keep it in same dir

// declare a version string (if you want..)
static const char VERSION[] = "\0$VER: LVFormat 1.0 (D.Keletsekis 15/9/98)";

// the prototypes - other includes at end of file..
#include "lvformat_protos.h"

// ===============================================================
//		MAIN() - note there is no need for a main() function
// The program starts at the 1st function it finds, which
// can be any name..
// ===============================================================

LONG anyname(void)
{
	struct ExecBase *SysBase = (*((struct ExecBase **) 4));
	struct DosLibrary *DOSBase=NULL;
	struct Process *myself = (struct Process *)(SysBase->ThisTask);

	struct MsgPort *myport=NULL;				 // our port
	struct g4cmsg	*msg;		// Gui4Cli message pointer
	int	 rc = 10;			// return code
	LONG	 stayalive = 1;	// Quit counter
	BOOL	 msgreplied;		// flag
	LONG	 num=60;		// default wrap length
	SHORT	 just=0;		// justify flag

	// -------------------- open the dos library or die..

	if (!(DOSBase = (struct DosLibrary *)OpenLibrary("dos.library", 36L)))
	{	myself->pr_Result2 = ERROR_INVALID_RESIDENT_LIBRARY;
		goto endprog;
	}

	// --------------------- Open message port or die..

	if (!(myport = openport ("LVFormat", SysBase, DOSBase)))
	{	PutStr ("Couldn't open LVFormat port!\n");
		goto endprog;
	}

	// ---------------------- Main wait() & process loop

	while (stayalive > 0)
	{
		WaitPort (myport);
		msg = (struct g4cmsg *)GetMsg(myport);
		msgreplied = 0;  // flag that message is outstanding

		// check that the message is like we expect it..
		if ((msg->magic != 392001) || (msg->type != GM_COMMAND) || (!msg->gcmain) || (!msg->com))
		{	 msg->res = 20;  // indicate error
			 goto endloop;	  // skip message
		}
		
		// --------------- Parse & execute the commands..
		// The command name is in msg->com and it's already converted
		// into upper case by Gui4Cli.

		else if (!strcmp(msg->com, "INDENT"))			// Indent [IndentString]
		{
			// if they sent us an argument..
			if (msg->args[0]) 
				indentlist (msg->gcmain, msg->args[0], SysBase, DOSBase);
			else // default = indent by 3 spaces
				indentlist (msg->gcmain, "	  ", SysBase, DOSBase);
		}

		else if (!strcmp(msg->com, "UNINDENT"))		// remove all leading spaces
		{
			  unindentlist (msg->gcmain, SysBase, DOSBase);
		}

		else if (!strcmp(msg->com, "AGCLEAN"))			// clear amiga guide stuff
		{
			  agclean (msg->gcmain, SysBase, DOSBase);
		}

		// WRAP [LineLength] [JUST/UNJUST] [HeaderCharacters]
		else if (!strcmp(msg->com, "WRAP"))
		{
			  // get wrap length (default = 60)
			  if (msg->args[0])
					if ((StrToLong(msg->args[0], &num)) <= 0) num = 60;

			  // get justification mode (just/unjust or nothing)
			  if (msg->args[1])
			  {	makeupper(msg->args[1]); 
					just=0;
					if		  (!strcmp(msg->args[1], "JUST"))	just = 1;
					else if (!strcmp(msg->args[1], "UNJUST")) just = 2;
					else if (!strcmp(msg->args[1], "CENTER")) just = 3;
					else if (!strcmp(msg->args[1], "RESET"))	just = 4;
			  }

		// args[2] contains the header chars, if any.
			  rewrap (msg->gcmain, num, msg->args[2], just, SysBase, DOSBase);
		}

		// Quiting :
		// A gui which wants to use us will "Register", so we ++stayalive
		// and quit only when all registered guis have told us to quit.
		else if (!strcmp(msg->com, "QUIT"))					  // asked to quit
			  --stayalive;
		else if (!strcmp(msg->com, "REGISTER"))			  // add a life
			  ++stayalive;

		endloop:
		if (!msgreplied) ReplyMsg ((struct Message *)msg);

	}	// end of main while(stayalive) loop

	rc = 0; // everything ok..

	// ---------------------- END PROG - CLEAN UP

	endprog :
	if (myport) closeport (myport, SysBase, DOSBase);
	if (DOSBase) CloseLibrary((struct Library *)DOSBase);
	return (rc);
}

// ================================================================
//		create a new public message port
// ================================================================

struct MsgPort *openport (char *portname, struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	struct MsgPort *port=NULL;

	Forbid ();
	if ((port = FindPort(portname)) != NULL)	
	{	  // if port already exists - return NULL
		  port = NULL;
	}
	else
		  port = CreatePort (portname, 0);
	Permit();

	return (port);
}

// ================================================================
//	 free a public message port
// ================================================================

void closeport (struct MsgPort *port, struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	struct Message *msg;

	Forbid ();
	// empty port
	while (msg = GetMsg (port))
		ReplyMsg (msg);
	// remove port name since it's a public msg port
	if (port->mp_Node.ln_Name)
		RemPort (port);
	// delete port
	DeleteMsgPort (port);
	Permit ();
}

// ==============================================================
// Send a message, wait for reply.. 
// -->> return 0 for OK or error code otherwise
// - portname = the name of Gui4Cli message port (usually Gui4Cli)
// - type	  = GM_LOCK, GM_UNLOCK, GM_COMMAND etc..
// - command  = the command line or NULL
// ==============================================================

sendmsg (UBYTE *portname, LONG type, UBYTE *command,
	 struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	struct Process *myself = (struct Process *)(SysBase->ThisTask);
	struct MsgPort *gcport, *myport;
	struct g4cmsg	msg;

	// our port pointer;
	myport = &myself->pr_MsgPort;
	// clear & set up the message structure
	memset ((char *)&msg, 0, sizeof(msg));
	msg.node.mn_ReplyPort = myport;
	msg.node.mn_Length = sizeof(struct g4cmsg);
	msg.magic = 392001; // so that g4c recognises us
	msg.type = type;
	msg.com	= command;

	Forbid();
	if (gcport = FindPort(portname))
	{
		PutMsg (gcport, &msg.node);
		Permit();
		// wait for reply..
		WaitPort (myport);
		GetMsg (myport);
		// return Gui4Cli's return code (probably 0 meaning OK)
		return (msg.res);
	}
	Permit();
	PutStr ("Could not find port!\n"); 
	return (10);
}

// ==============================================================
// convert string to UPPER case 
// (since stricpm doesn't work without the startup code)
// ==============================================================
void makeupper (UBYTE *str)
{
	if (!str) return;
	while (*str)
	{	 if ((*str >= 'a') && (*str <= 'z')) *str -= 32;
		 ++str;
	} 
}

// ==============================================================
// check if char g occurs in str - return boolean
// ==============================================================
BOOL isin (UBYTE g, UBYTE *str)
{
	if (!str) return (0);
	while (*str)
	{	 if (*str == g) return (1);
		 ++str;
	}
	return (0);
}

// ================================================================
// include files here, so they are after the main function..

#include "indent.h"
#include "agclean.h"
#include "rewrap.h"
#include "lv_func.h"







