/************************************************************
 *                                                          *
 *                IPC "QUIT" Requestor                      *
 *                                                          *
 *                Pete Goodeve 89:4:01                      *
 *                                                          *
 *  [This module has only been compiled under Lattice;      *
 *   it will need some modification for Manx/Aztec;         *
 *   ... I'd be very grateful if someone would do the       *
 *   conversion...]                                         *
 *                                                          *
 *                                                          *
 *  Invoke from the CLI with the required port names as     *
 *  arguments (remember case is important).  A simple       *
 *  QUIT message (no optional items) will be sent to each   *
 *  in turn.                                                *
 *                                                          *
 ************************************************************/



#ifdef LATTICE
#if LATTICE_40 | LATTICE_50
#include "IPC_proto.h"
/* ...else (not recent Lattice) will need library linkage stubs (IPC.o) */
#include <proto/exec.h>
#endif
#endif

#include "IPC.h"

/*
 *  Define the ID codes recognized by the print format server
 *
 *  (MAKE_ID is defined in IPC.h)
 */

/* Message IDs: */
#define QUIT  MAKE_ID('Q','U','I','T')


struct Library * IPCBase = NULL;

struct IPCPort *port=NULL; /* will point to server port */
struct MsgPort *rport=NULL; /* where we get our replies */
struct IPCMessage *imsg=NULL; /* this one message is used repeatedly */

void Cleanup();

void main(argc,argv) char **argv;
{
    /* Before anything else, we need the IPC Library: */
    IPCBase = OpenLibrary("ppipc.library",0);
    if (!IPCBase)
        exit(20);

    /* First we set up a reply port: */

    rport = CreatePort(NULL,0);
    if (!rport) {
        Cleanup();
        exit(21);
    }


    /* ... then make a message block */
    imsg = CreateIPCMsg(0,0,rport);
    if (!imsg) {Cleanup(); exit(22);}
    imsg->ipc_Id = QUIT;


    /* then send a QUIT to every port in the command line: */
    argv++;
    while(--argc > 0) {
        port = GetIPCPort(*argv);
        if (!port) continue; /* ignore unrecognized arguments */
        if (PutIPCMsg(port, imsg)) {
            WaitPort(rport);
            GetMsg(rport);
        }
        DropIPCPort(port);
        argv++;
    }
    Cleanup();
}

void Cleanup()
{
    if (rport) DeletePort(rport);
    if (imsg) DeleteIPCMsg(imsg);
    CloseLibrary(IPCBase);
}

