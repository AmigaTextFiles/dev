/************************************************************
 *                                                          *
 *           Simple Client Demo for IPC                     *
 *                                                          *
 *                Pete Goodeve 89:4:01                      *
 *                                                          *
 *  [This module has only been compiled under Lattice;      *
 *   it will need some modification for Manx/Aztec;         *
 *   ... I'd be very grateful if someone would do the       *
 *   conversion...]                                         *
 *                                                          *
 *                                                          *
 *  To exit the client program type an 'end-of-file'        *
 *  (cntrl-'\').                                            *
 *                                                          *
 *  It is a simple "synchronous" client: when it sends a    *
 *  message it waits for the reply before continuing        *
 *  (unlike others that may continue with other activities  *
 *  while the server is processing a message).  The main    *
 *  loop is simple:                                         *
 *                                                          *
 *          Wait for line from keyboard command             *
 *          Send message                                    *
 *          Wait for reply                                  *
 *          Loop to wait for keyboard again.                *
 *                                                          *
 *                                                          *
 ************************************************************/

#ifdef LATTICE
#if LATTICE_40 | LATTICE_50
#include "IPC_proto.h"
/* ...else (not recent Lattice) will need library linkage stubs (IPC.o) */
#include <proto/exec.h>
/**  if no proto/exec.h, you also should define
* struct MsgPort * CreatePort(char *, int);
..**/
#endif
#endif

#include "IPC.h"
#include <exec/memory.h>
#include <stdio.h>

#define LINESZ 255

/*
 *  Define the ID codes recognized by the print format server
 *
 *  (MAKE_ID is defined in IPC.h)
 */

/* Message IDs: */
#define CNVA  MAKE_ID('C','N','V','A')
    /* CoNVert to Ascii */

/* Item IDs: */

#define LINE  MAKE_ID('L','I','N','E')
    /* indicates a complete line of text -- omitting newline */

#define TEXT  MAKE_ID('T','E','X','T')
    /* Text block -- may include newlines */

#define STRG  MAKE_ID('S','T','R','G')
    /* general non-specific ASCII STRinG */


struct Library * IPCBase = NULL;

struct IPCPort *port=NULL; /* will point to server port */
struct MsgPort *rport=NULL; /* where we get our replies */
struct IPCMessage *imsg=NULL; /* this one message is used repeatedly */

void Cleanup();


/******************************
 *                            *
 *  Main program entry point: *
 *                            *
 ******************************/

void main()
{
    struct IPCItem *item, *item0; /* pointers to access message items */


    char tbuf[LINESZ+1]; /* keyboard input dumped in here */

    /****************************************************/
    /** Before anything else, we need the IPC Library: **/
    /****************************************************/
    IPCBase = OpenLibrary("ppipc.library",0);
    if (!IPCBase) {
        puts(
        "Couldn't find ppipc.library!\nHave you installed it in LIBS: ?\n");
        exit(20);
    }

    /********************************/
    /** First we set up our ports: **/
    /********************************/

    port = GetIPCPort("Demo");
    if (!port) {
        Cleanup();
        exit(21);
    }

    rport = CreatePort(NULL,0);
    if (!rport) {
        Cleanup();
        exit(21);
    }


    /***********************************/
    /** ... then make a message block **/
    /***********************************/
    imsg = CreateIPCMsg(2,0,rport); /* large enough for playing with... */
    /* remember to add more items here if we need them...! */
    if (!imsg) {Cleanup(); exit(22);}
    imsg->ipc_Id = CNVA; /* any message ID will do (except for QUIT) */
    /*.. and note that this simple client doesn't send QUIT */

    item0 = &imsg->ipc_Items[0]; /* a convenient permanent reference */


    /***********************************************************/
    /* The main program loop:                                  */
    /* -- continues until told to quit by end-of-file (ctrl-\) */
    /***********************************************************/
    while (1) {
        item = item0; /* reset item pointer */

        /* get keyboard input (terminated by return): */
        /* E-O-F returns a length of zero, causing break from loop */
        if (fgets(tbuf, LINESZ, stdin) == 0) break;

        tbuf[strlen(tbuf)-1] = '\0'; /* we assume it ended with a newline
                                        -- so we remove it */

    /*******************************/
    /** Now we build the message: **/
    /*******************************/

        item->ii_Id = STRG; /* A short string to start out with */
        item->ii_Ptr = (void *)("Got message");
        item->ii_Size = strlen(item->ii_Ptr);
        item++;
        item->ii_Id = LINE; /* now use the line from keyboard */
        item->ii_Ptr = (void *)tbuf;
        item->ii_Size = strlen(item->ii_Ptr);
        item++;
        /* Note that the Client retains ownership */

        /* Send the message (if possible) */
        if (!PutIPCMsg(port, imsg)) {
                puts("No server!\n");
                continue; /* don't wait for a reply that won't come! */
        }
        /* Wait at the reply port (we assume a reply WILL come!): */
        WaitPort(rport);
        GetMsg(rport);  /* we assume we know what's there! */
    }
    /*** end of main loop ***/

    Cleanup();
}


void Cleanup()
{
    if (port) DropIPCPort(port);
    if (rport) DeletePort(rport);
    if (imsg) DeleteIPCMsg(imsg);
    CloseLibrary(IPCBase);
}


