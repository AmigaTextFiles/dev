/************************************************************
 *                                                          *
 *         Trivial Server demo for IPC                      *
 *                                                          *
 *                Pete Goodeve 89:4:01                      *
 *                                                          *
 *  [This module has only been compiled under Lattice;      *
 *   it will need some modification for Manx/Aztec;         *
 *   ... I'd be very grateful if someone would do the       *
 *   conversion...]                                         *
 *                                                          *
 *                                                          *
 *  This is just a "working skeleton" Server [shades of     *
 *  Harryhausen...?] that simply opens a port, looks for    *
 *  any LINE, TEXT, or STRG items it can print out in any   *
 *  messages sent to it, and replies the message..          *                          *
 *                                                          *
 *  (Note that it expects all messages to have a replyport  *
 *  -- any that don't will be discarded without reclaiming  *
 *  memory.  Other servers can be set up to delete messages *
 *  properly if they follow the rules.)                     *
 *                                                          *
 *                                                          *
 *  The only special message ID recognized by this server   *
 *  is QUIT, which always causes an immediate exit (after   *
 *  replying to any remaining messages).                    *
 *  It will also quit if it is sent a cntrl-C break.        *
 *                                                          *
 *                                                          *
 ************************************************************/

/*** This code has been written to be compiled under Lattice 4 or 5
*   -- if you are using another compiler, you will have to adjust
*   these includes (and maybe other parts of the code) to make it work.
***/

#ifdef LATTICE
#if LATTICE_40 | LATTICE_50
#include "IPC_proto.h"
/* ...else (not recent Lattice) will need library linkage stubs (IPC.o) */
#include <proto/exec.h>
#endif
#endif

/*** if proto/exec.h is not included, you should declare the following:
APTR OpenLibrary(char *, int);
void CloseLibrary(APTR);
struct Message * Getmsg(struct MsgPort *);
***/
/** (or without parameters if your compiler doesn't accept them) **/


#include "IPC.h"

#include "stdio.h"

#include "exec/memory.h"
#include "libraries/dos.h"

/************************************************************/

/*
 *  Define the ID codes recognized by server
 *
 *  (MAKE_ID is defined in IPC.h)
 */

/* Message IDs: */
#define QUIT  MAKE_ID('Q','U','I','T')

#define LINE  MAKE_ID('L','I','N','E')
    /* indicates a complete line of text -- omitting newline */

#define TEXT  MAKE_ID('T','E','X','T')
    /* Text block -- may include newlines */

#define STRG  MAKE_ID('S','T','R','G')
    /* general non-specific ASCII STRinG (normally less than a line) */



/************************************************************/

    /*** Global Variables: ***/


struct Library * IPCBase = NULL; /* Base pointer for the IPC Library */


struct IPCPort *import=NULL; /* this is the port we serve */

struct IPCMessage *imsg=NULL; /* we only handle one message at a time,
                                 so a global pointer is useful */


void procitem(); /* (just using old-style forward ref...)*/
void Cleanup();

int active = TRUE; /* when this goes FALSE, it's time to quit */

ULONG importsig = 0; /* signal mask for port */

/************************************************************/



    /***************************
     *
     *  Main program entry point:
     *
     ***************************/

void main()
{
    ULONG sigset;  /* set to signals that woke up Wait() */


    /* Before anything else, we need the IPC Library: */
    IPCBase = OpenLibrary("ppipc.library",0);
    if (!IPCBase) {
        puts(
        "Couldn't find ppipc.library!\nHave you installed it in LIBS: ?\n");
        exit(20);
    }

    setnbf(stdout); /* so we can see output! (unbuffered) */

    import = ServeIPCPort("Demo");
    if (!import) {
        puts("Print Server already exists ... exiting");
        Cleanup();
        return;
    }

    /* Get the signal bit for the port for later convenience: */
    /* (Note that, because we did not include IPCPorts.h, IPCPorts
        are identical to MsgPorts as far as the user is concerned;
        if we DID need IPCPorts.h, this statement would have to
        be changed appropriately.) */
    importsig = 1<<import->mp_SigBit;


    /*
     ***  The main loop: ***
     *  -- first we process any outstanding messages, looping until
     *  no more are found
     *  -- then we go to sleep until woken up by another message (or
     *  a cntrl-C).
     */
    do {
        while ( procimsg()) ;  /* loop to satisfy messages */

        /*
         *  Now wait for further messages, unless 'active' is FALSE
         */
        if (active) {
            /* Note that Wait() must be used rather than WaitPort()
               if we want to wake up on IPP_NOTIFY as well as messages */
            sigset = Wait(importsig | SIGBREAKF_CTRL_C);
            if (sigset & SIGBREAKF_CTRL_C) {
                active = FALSE;
                ShutIPCPort(import); /* note: multiple calls don't hurt! */
                continue; /* so we clear out any messages that sneak in */
            }
        }
    } while (active);
    /*** end of main loop ***/

    puts("Server terminating...\n");

    Cleanup();
}
/*** end of _main ***/


void Cleanup()
{
    if (import) LeaveIPCPort(import);
    CloseLibrary(IPCBase);
}


/************************************************************/



/*
 *  Process incoming messages
 *  -- returns FALSE if there are none, otherwise TRUE.
 *  (In a functional server this procedure would recognize the message ID
 *  and invoke the appropriate handling procedures.)
 */

procimsg() {
    struct IPCItem *item;
    int count, i;
    if (!(imsg = (struct IPCMessage *) GetMsg(import))) return FALSE;
    switch (imsg->ipc_Id) {

       case QUIT:
               active = FALSE;
               ShutIPCPort(import);
               puts("server got QUIT message...");
               break;

       default:
               item = imsg->ipc_Items;
               count = imsg->ipc_ItemCount;
               for (i=0; i<count; i++)
                   procitem(&item[i]);
               break;
    }

    if (imsg->ipc_Msg.mn_ReplyPort)
        ReplyMsg(imsg);
    else
        puts("received message with no reply port -- MEMORY WILL BE LOST!!");

    return TRUE;
}

void procitem(item) struct IPCItem *item;
{
    switch (item->ii_Id) {
       case LINE:
                puts(item->ii_Ptr); /* this appends a newline */
                break;
       case TEXT:
                fputs(item->ii_Ptr, stdout); /* this doesn't */
                break;
       case STRG:
                fputs(item->ii_Ptr, stdout);
                fputc('|', stdout); /* supply a separator */
                break;
       default:
                item->ii_Flags |= IPC_NOTKNOWN;
                imsg->ipc_Flags |= IPC_CHECKITEM;
                break;
    }
}

/************************************************************/

