/****************************************************************
**
**	GCTalk.c by dck@hol.gr
**
**	This little program is to show you how to talk to 
**	Gui4Cli. All it does is to get a lock on the main
**	Gui4Cli structure and print out the names of all
**	the currently loaded guis and then a simple command 
**	to Gui4Cli for execution.
**
**	There is an other version of this called GCTalkNS.c
**	(in this dir) which uses the SAS "nostartup" option 
**	to produce an even smaller executable.
**
******************************************************************/
// some of these may not be needed..
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

// Gui4Cli.h include file (assuming it's in the include: dir)
#include <Gui4Cli.h>

// prototype
int sendmsg (UBYTE *, struct g4cmsg *);

// ==============================================================
// MAIN - print the names of all loaded guis
// ==============================================================

LONG main (void)
{
	struct Process *myself = (struct Process *)FindTask(NULL);
	struct MsgPort *myport;

	struct g4cmsg  msg;	// the message we'll use
	struct GCmain  *gc;	// Gui4Cli's main structure
	struct guifile *gf;	// a gui file pointer
	LONG   ret = 10;	// our return code
      
	// this is our proccess's message port
	myport = &myself->pr_MsgPort;

	// clear & set up the message structure
	memset ((char *)&msg, 0, sizeof(msg));
	msg.node.mn_ReplyPort = myport;
	msg.node.mn_Length = sizeof(struct g4cmsg);
	msg.magic = 392001; // so that g4c recognises us
	msg.type = GM_LOCK; // make it a lock message

	// send the message - a return of 0 means ok
	// otherwise there was a failure and we exit indicating error
	if (ret = sendmsg ("Gui4Cli", &msg)) return (ret);

	// The pointer to Gui4Cli's main structure, is in msg.gcmain
	gc = msg.gcmain;

	// make sure that it's valid..
	if (gc && (gc->magic == MM_G4C))
	{
	    // print out the names of all the guis currently loaded
	    for (gf = gc->topguifile; gf; gf = gf->next)
 	        Printf ("FILE: %s\n", gf->name);
	}

	// *must* unlock Gui4Cli after we're through using it..
	msg.type = GM_UNLOCK;
	sendmsg ("Gui4Cli", &msg);

	// now for my next trick...
	// we send a command to Gui4Cli to execute..
	msg.com  = "SETVAR *GlobVar \'Some value\'";
	msg.type = GM_COMMAND;
	ret = sendmsg ("Gui4Cli", &msg);
	// now global var *GlobVar will contain the words "Some value" 

	// that's all..
	return (ret);
}


// ==============================================================
// Send a message, wait for reply.. 
// -->> return 0 for OK or error code otherwise
// - portname = the name of Gui4Cli message port (usually Gui4Cli)
// - msg = the message we received
// ==============================================================

sendmsg (UBYTE *portname, struct g4cmsg *msg)
{
	struct MsgPort *gcport, *myport;
	
	// get a pointer to our message port (for code clarity)
	myport = msg->node.mn_ReplyPort;

	Forbid();
	if (gcport = FindPort(portname))
	{
	   PutMsg (gcport, &msg->node);
	   Permit();
	   // wait for reply..
	   WaitPort (myport);
	   msg = (struct g4cmsg *)GetMsg (myport);
	   // return Gui4Cli's return code (probably 0 meaning OK)
	   return (msg->res);
	}
	Permit();
	PutStr ("Could not find port!\n"); 
	return (10);
}




