/*  Cleanup program for IPC 90:03:05 */

/***************************************************************
 * This program has two functions:
 *
 *  Invoked without any arguments, it prints a list of all
 *  the IPCPorts currently defined, with the number of
 *  references (Clients or Servers) to each, and any state
 *  flags set.
 *
 *  If you give the name of any currently valid IPCPort
 *  as an argument (multiple args allowed) it will remove
 *  ALL the references to that port, and the port itself.
 *  This is ONLY an "Emergency Recovery" operation!!
 *  It should only be used when a faulty program has
 *  terminated without dropping its reference to the
 *  port.  ALL processes CORRECTLY connected to the
 *  port should be terminated BEFORE using this command.
 *
 **************************************************************/


#include <stdio.h>
#include "IPCPorts.h"
#include "IPC_proto.h"
#include "IPC.h"

#include "exec/memory.h"


ULONG IPCBase;

struct IPCPort *port, *testport;

char tportname[]= " CleaNeR  PoRt --";  /* a VERY odd name... */

int cleanport(char * portname)
{
    struct IPCMessage *imsg;
        if (!portname || !*portname) return FALSE;
        port = GetIPCPort(portname);
        if (port->ipp_Flags & IPP_SERVED) {
            printf("Shutting port %s\n", portname);
            ShutIPCPort(port);
            while (imsg = (struct IPCMessage *)GetMsg(port)) {
                imsg->ipc_Flags |= IPC_NOTKNOWN;
                ReplyMsg(imsg);
            }
        }
        if (port->ipp_Flags & IPP_SHUT) {
            printf("Leaving port %s\n", portname);
            LeaveIPCPort(port);
        }
        printf("dropping %d clients from %s\n",
            CheckIPCPort(port,0), portname);
        while (CheckIPCPort(port,0)) DropIPCPort(port);
        return TRUE;
}

void showport(struct Node * np)
{
    struct IPCPort * ip = (struct IPCPort *) np;
    int refs = ip->ipp_UseCount;
    printf("%s: %d reference%s\n", ip->ipp_Name, refs, refs == 1 ? "" : "s");
    if (ip->ipp_Flags)
        printf("  -- marked as %s%s%s%s%s\n",
                ip->ipp_Flags & IPP_LOADING ? "LOADING " : "",
                ip->ipp_Flags & IPP_SERVED ? "SERVED " : "",
                ip->ipp_Flags & IPP_REOPEN ? "REOPEN " : "",
                ip->ipp_Flags & IPP_SHUT ? "SHUT " : "",
                ip->ipp_Flags & IPP_NOTIFY ? "NOTIFY " : "");
}

void main(int argc, char ** argv)
{
    char **argp;
    struct Node *np; /* actually an IPCPort (but changed back when needed) */

    IPCBase = OpenLibrary("ppipc.library",0);
    if (!IPCBase) {
        puts("couldn't find IPC Library -- TTFN...\n");
        exit(20);
    }

    argp = &argv[1];

    if (argc > 1)
        while (--argc) cleanport(*argp++);
    else {
        if (FindIPCPort(tportname)) cleanport(tportname); /* just in case */
        testport = GetIPCPort(tportname);   /* now at head of list */
        for (np = (struct Node *)testport->ipp_Port.mp_Node.ln_Succ;
                     /* don't include testport...*/
                np->ln_Succ; np = np->ln_Succ)
            showport(np);
        DropIPCPort(testport);
    }
    CloseLibrary(IPCBase);
}


