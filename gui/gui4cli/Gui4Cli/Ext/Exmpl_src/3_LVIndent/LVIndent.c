
/****************************************************************
**
**	LVIndent.c - 6/9/98 - dck@hol.gr
**	
**	This program will get a lock on Gui4Cli and then
**	indent the current listview by inserting 3 spaces at the 
**	start of each line.
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

// prototypes
int sendmsg(UBYTE * , struct g4cmsg * , struct ExecBase * , struct DosLibrary * );
int indentlist(struct GCmain * , UBYTE * , struct ExecBase * , struct DosLibrary * );

// ==============================================================
// This is the function where execution starts.
// Lock Gui4Cli, get the *GCmain pointer and call the function 
// which will indent the current listview (end of the file)
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
	if (ret = sendmsg ("Gui4Cli", &msg, SysBase, DOSBase)) 
	    goto endprog;

	// The pointer to Gui4Cli's main structure, is in msg.gcmain
	gc = msg.gcmain;

	// make sure that it's valid..
	if (gc && (gc->magic == MM_G4C))
	{
 	    if (indentlist (gc, "   ", SysBase, DOSBase)) ret = 0;
	}

	// *must* unlock Gui4Cli after we're through using it..
	msg.type = GM_UNLOCK;
	sendmsg ("Gui4Cli", &msg, SysBase, DOSBase);
	
	// now send a command to nudge the lv into redrawing itself
	msg.type = GM_COMMAND;
	strcpy (command, "LVMove 0");
	msg.com = command;
	sendmsg ("Gui4Cli", &msg, SysBase, DOSBase);

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


// ==============================================================
// Indent the listview - return success
// go through all records, delete old, replace with new..
// gcm   = the main Gui4Cli structure
// instr = the string to indent it with
// ==============================================================

indentlist (struct GCmain *gcm, UBYTE *instr,
	    struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	LONG   inlen, totlen;
	struct fulist *fls;
	struct lister *fl, *nextfl;
	UBYTE  *buff;
	
	inlen = strlen(instr);
	
	// get pointer to current listview, checking it..
	if (!(fls = gcm->curlv) || !fls->ls) return (0);
	
	// do the whole list..
	fl = (struct lister *)(fls->ls->lh_Head);
	while (nextfl = (struct lister *)(fl->node.ln_Succ))
	{
	   // get the buffer we need.. (NOTE totlen + 1 - always!)
	   totlen = inlen + fl->length;
	   if (!(buff = (UBYTE *)AllocMem(totlen + 1, MEMF_CLEAR)))
	   {   PutStr ("No memory!\n");
	       return (0);
	   }
	
	   // construct the line..
	   strcpy (buff, instr);
	   strcat (buff, fl->start);
	   // replace old line
	   FreeMem (fl->start, fl->length + 1); // note +1
	   fl->start  = buff;   
	   fl->length = totlen;
	
		// adjust the max line length counter (just do it..)
		if (fls->maxlength < fl->length) fls->maxlength = fl->length;

	   // do next line..
	   fl = nextfl;
	}
	
	return (1); // ok..
}



