/****************************************************************
**
**	GCTalk_NS.c by dck@hol.gr
**
**	This is the NOSTARTUP version of GCTalk.c
**
**	This little program is to show you how to talk to 
**	Gui4Cli. All it does is to get a lock on the main
**	Gui4Cli structure and print out the names of all
**	the currently loaded guis and then send a simple 
**	command to Gui4Cli for execution.
**
******************************************************************/
// define this for faster exec calls
#define __USESYSBASE
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
int sendmsg (UBYTE *, struct g4cmsg *, struct ExecBase *, struct DosLibrary *);

// ==============================================================
// This is the function where execution starts because it's the
// first one declared.. it can have any name. 
// The main() function is not needed any longer
// ==============================================================

int anyname (void)
{
	// these are the libraries we need
	struct ExecBase *SysBase = (*((struct ExecBase **) 4));
	struct DosLibrary *DOSBase=NULL;
	// this is us..
	struct Process *myself = (struct Process *)(SysBase->ThisTask);

	struct MsgPort *myport;
	struct g4cmsg  msg;	// the message we'll use
	struct GCmain  *gc;	// Gui4Cli's main structure
	struct guifile *gf;	// a gui file pointer
	UBYTE  command[100];	// a temporary buffer
	LONG   ret = 10;	// our return code
      
	// open the dos library or die..
	if (!(DOSBase = (struct DosLibrary *)OpenLibrary("dos.library", 36L)))
	{   myself->pr_Result2 = ERROR_INVALID_RESIDENT_LIBRARY;
	    goto endprog;
	}

	// this is our proccess's message port
	myport = &myself->pr_MsgPort;

	// clear & set up the message structure
	memset ((char *)&msg, 0, sizeof(msg));
	msg.node.mn_ReplyPort = myport;
	msg.node.mn_Length = sizeof(struct g4cmsg);
	msg.magic = 392001; // so that g4c recognises us

	// make it a lock message
	msg.type = GM_LOCK;

	// send the message - a return of 0 means ok
	// otherwise there was a failure and we exit indicating error
	if (ret = sendmsg ("Gui4Cli", &msg, SysBase, DOSBase)) return (ret);

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
	sendmsg ("Gui4Cli", &msg, SysBase, DOSBase);

	// now for my next trick...
	// we send a command to Gui4Cli to execute..
	strcpy (command, "SETVAR *GlobVar \'Some value\'");
	msg.com  = command;
	msg.type = GM_COMMAND;
	ret = sendmsg ("Gui4Cli", &msg, SysBase, DOSBase);
	// now global var *GlobVar will contain the words "Some value" 

	// that's all..
	endprog:
	if (DOSBase) CloseLibrary((struct Library *)DOSBase);
	return (ret);
}


// ==============================================================
// Send a message, wait for reply.. 
// -->> return 0 for OK or error code otherwise
// - portname = the name of Gui4Cli message port (usually Gui4Cli)
// - msg = the message we received
// note : we pass sysbase & dosbase as arguments, because we 
//        will be using functions in those libararies..
// ==============================================================

sendmsg (UBYTE *portname, struct g4cmsg *msg,
	 struct ExecBase *SysBase, struct DosLibrary *DOSBase)
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




