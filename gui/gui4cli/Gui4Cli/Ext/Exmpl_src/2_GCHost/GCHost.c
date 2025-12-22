
/***********************************************************************
*
*		  GCHost 1.0 - D. Keletsekis (27/8/98)
*
*		  This type of program can act as a host for Gui4Cli commands.
*
*		  What it does, is create a public message port called "MyPort"
*		  (port names are case sensitive!) and wait for commands from 
*		  Gui4Cli, sent via the CALL command, to this port. 
*
*		  When a command is received, it is executed, and may also return 
*		  some result back to Gui4Cli.
*
*		  This example has 4 possible commands it can handle :
*		  QUIT	 - will quit this program
*		  GUIS	 - will print out a list of all loaded guis
*		  ARGS	 - will print out a list of all arguments we received
*		  HELLO	 - will send a return buffer to Gui4Cli which can
*						be accessed from within Gui4Cli via $$CALL.RET
*
************************************************************************/

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

#include <Gui4Cli.h>

// prototypes
struct MsgPort *openport (char *);
void closeport (struct MsgPort *);

// ===============================================================
//		  MAIN()
// ===============================================================

main()
{
struct MsgPort *myport=NULL;				 // our port
struct g4cmsg	*msg;		// Gui4Cli message pointer
struct guifile *gf;		// Gui4Cli Gui file pointer
int	 rc = 10;					  // return code
BOOL	 endflag = 0;		// control flag
LONG	 c;

// --------------------- Open message port or die..

if (!(myport = openport ("MyPort")))
{	PutStr ("Couldn't open CedBar port!\n");
	goto endprog;
}

// ---------------------- Main wait() & process loop

while (!endflag)
{
	WaitPort (myport);
	msg = (struct g4cmsg *)GetMsg(myport);

	// check that the message is like we expect it..
	if ((msg->magic != 392001) || (msg->type != GM_COMMAND) || (!msg->gcmain) || (!msg->com))
	{	msg->res = 20;  // indicate error
		goto endloop;	  // skip message
	}

	// --------------- Parse & execute the commands..
	// The command name is in msg->com and it's already converted
	// into upper case by Gui4Cli.

	if (!strcmp(msg->com, "QUIT"))					// quit
	{
		++endflag;
	}

	else if (!strcmp(msg->com, "GUIS"))	 // print the names of all the guis
	{
		for (gf = msg->gcmain->topguifile; gf; gf = gf->next)
			Printf ("FILE: %s\n", gf->name);
	}

	else if (!strcmp(msg->com, "ARGS"))	 // print any arguments we received
	{
		for (c = 0; msg->args[c] && (c < 6); ++c)
		{
			Printf ("Argument %ld : %s\n", c, msg->args[c]);
		}
	}

	else if (!strcmp(msg->com, "HELLO")) // answer back..
	{
		// here we allocate a buffer which we attach to the message 
		// we received which will be sent back to Gui4Cli. The
		// contents of the buffer will be accessible from within
		// Gui4Cli via the $$CALL.RET internal variable.
		// NOTE : We MUST use AllocVec() to get the buffer.
		// NOTE2: Gui4Cli is responsible for freeing our buffer

		if (msg->msgret = (UBYTE *)AllocVec (50, MEMF_CLEAR))
		{
			strcpy (msg->msgret, "Hello there Gui4Cli!");
		}
	}

	// ... you can add more commands here ...

	endloop:

	// reply the message to Gui4Cli
	ReplyMsg ((struct Message *)msg);

}	// end of main while(!endflag) loop

rc = 0; // everything ok..

// ---------------------- END PROG - CLEAN UP

endprog :
if (myport) closeport (myport);
return (rc);
}

// ================================================================
//		  create a new public message port
// ================================================================

struct MsgPort *openport (char *portname)
{
	struct MsgPort *port=NULL;

	Forbid ();
	if ((port = FindPort(portname)) != NULL)	
	{	// if port already exists - return NULL
		port = NULL;
	}
	else
		port = CreatePort (portname, 0);
	Permit();

	return (port);
}

// ================================================================
//			free a public message port
// ================================================================

void closeport (struct MsgPort *port)
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


