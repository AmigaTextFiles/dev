/* Primitive test program for LoadIPCPort facility */
/* ...simply displays a request for a port in its console window */
/* Shared Library version 89:3:26 */

#include "IPCPorts.h"
#include "IPC_proto.h"
#include "IPC.h"

#include "exec/memory.h"
#include "exec/tasks.h"
#include "libraries/DOS.h"

#define  SOL(s)  ((LONG)sizeof(s))

#define IPPL MAKE_ID('I','P','P','L')
#define PORT MAKE_ID('P','O','R','T')

ULONG IPCBase = NULL;

struct IPCPort *brokerport;
struct IPCMessage *imsg=NULL;

void baditem(struct IPCItem *, ULONG);
void outputstr(char *);

struct Task * FindTask(char *);

void Cleanup();


ULONG bportsig = 0;  /* signal masks for port */

int active = TRUE;


void _main()
{
    ULONG sigset;

    IPCBase = OpenLibrary("ppipc.library",0);
    if (!IPCBase) {
        outputstr("couldn't find IPC Library -- TTFN...\n");
        _exit(20);
    }

    brokerport = ServeIPCPort("PortBrokerPort");
    if (!brokerport) {Cleanup(); _exit(11);}
    bportsig = 1<<brokerport->ipp_Port.mp_SigBit;
    outputstr("Opened 'PortBrokerPort'\n");


    do {
        while ( procimsg() ) ;    /* loop */
        if (active) {
            sigset = Wait(bportsig | SIGBREAKF_CTRL_C);
            if (sigset & SIGBREAKF_CTRL_C) {
                active = FALSE;
                ShutIPCPort(brokerport);
                continue; /* so we clear out any messages that sneak in */
            }
        }
    } while (active);
    outputstr("Broker terminating...\n");

    Cleanup();
}


void Cleanup()
{
    if (brokerport) LeaveIPCPort(brokerport);
    CloseLibrary(IPCBase);
}


procimsg()
{
    struct IPCItem *item;
    if (!(imsg = (struct IPCMessage *) GetMsg(brokerport))) return FALSE;
    outputstr("got message\n");
    item = imsg->ipc_Items;
    if (imsg->ipc_Id == IPPL && item->ii_Id == PORT
        && loadport(item->ii_Ptr)) /* everything OK */;
    else imsg->ipc_Flags |= IPC_NOTKNOWN;
    ReplyMsg(imsg);
    return TRUE;
}


void baditem(item, extraflags)
    struct IPCItem *item;
    ULONG extraflags;
{
    imsg->ipc_Flags |= IPC_CHECKITEM;
    item->ii_Flags |= IPC_NOTKNOWN | extraflags;
}

void outputstr(str) char *str;
{
    Write(Output(), str, strlen(str));
}


/*
 *  loadport(portptr)
 *
 *  -- actually initiates the loading procedure (here just a skeleton).
 *      returns TRUE if successful, otherwise FALSE.
 */

loadport(port) struct IPCPort *port;
{
    outputstr("Please load server for port '");
    outputstr(port->ipp_Name);
    outputstr("' -- Thanks\n");
    return TRUE; /* -- doesn't know how to fail yet... */
}


/****************************************************************/


