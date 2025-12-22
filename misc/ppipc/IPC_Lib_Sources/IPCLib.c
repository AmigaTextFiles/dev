/*******************************************************************
 *                                                                 *
 *                           IPClib.c                              *
 *                                                                 *
 *           Inter-Process-Communication Procedures                *
 *              in Shared Library Form                             *
 *                                                                 *
 *              Release  2.1 -- 1989 March 27                      *
 *                                                                 *
 *              Copyright 1988,1989 Peter Goodeve                  *
 *                                                                 *
 *  This source is freely distributable, but its functionality     *
 *  should not be modified without prior consultation with the     *
 *  author.  [Don't forget this is a SHARED library!]              *
 *                                                                 *
 *******************************************************************/

/*******************************************************************
 *                                                                 *
 *  Modification History:                                          *
 *                                                                 *
 *      88:7:22     PutIPCPort accepts IPP_LOADING flag            *
 *                                                                 *
 *      88:7:11     Manx/Aztec compatibility added                 *
 *                  CheckIPCPort now has flag return option        *
 *                  FindIPCPort now fails if no server             *
 *                  CreateIPCMsg has two added args                *
 *                                                                 *
 *      89:3:25     (Lattice 5.0) Shared Resident Library version. *
 *                  Return from CheckIPCPort is defined ULONG      *
 *                  to avoid confusion.                            *
 *                                                                 *
 *      89:3:27     IPP_LOADED flag detection added to             *
 *                  FindIPCPort.                                   *
 *                                                                 *
 *                                                                 *
 *******************************************************************/

/********************************************************************
 *                                                                  *
 *  Synopsis of usage:                                              *         *
 *  ========                                                        *
 *                                                                  *
 *  (via library interface stub routines)                           *
 *                                                                  *
 *    Client:                                                       *
 *                                                                  *
 *          port = GetIPCPort(name);                                *
 *      or  port = FindIPCPort(name)                                *
 *          .....                                                   *
 *          msg = CreateIPCMsg(nitems, nxbytes, replyport);         *
 *          .....                                                   *
 *          PutIPCMsg(port,msg);                                    *
 *          .....                                                   *
 *          DeleteIPCMsg(msg);                                      *
 *          .....                                                   *
 *          DropIPCPort(port);                                      *
 *                                                                  *
 *    Server: [standard Exec procedures in brackets]                *
 *                                                                  *
 *          port = ServeIPCPort(name);                              *
 *          .....                                                   *
 *          [WaitPort(port); or Wait(sigbits);]                     *
 *          .....                                                   *
 *          [msg = GetMsg(port);]                                   *
 *          .....                                                   *
 *          [ReplyMsg(msg);]                                        *
 *          .....                                                   *
 *          ShutIPCPort(port);                                      *
 *          <handle remaining messages on the port>                 *
 *          LeaveIPCPort(port);                                     *
 *                                                                  *
 *    Misc.:                                                        *
 *                                                                  *
 *          UseIPCPort(port);                                       *
 *          CheckIPCPort(port,flags);                               *
 *                                                                  *
 *                                                                  *
 ********************************************************************/

/********************************************************************
 *                                                                  *
 * These procedures provide a mechanism for independent processes   *
 * to communicate with each other through "IPC ports".   These are  *
 * similar to standard Exec Message Ports, except that they are     *
 * not "owned" by any of the processes; any one process can         *
 * declare itself a "server" (provided no other is currently        *
 * claiming this right), and thus becomes temporarily the handler   *
 * of messages passed to this port.  If there is no server, any     *
 * attempt to send a message to a port will return failure, and     *
 * the client may take whatever action is appropriate.  A client    *
 * may safely "Get" a pointer to a named port (even if there is no  *
 * server yet) and can rely on it remaining valid until it "Drops"  *
 * it again. (In contrast to Exec ports, which have no such         *
 * protection.)                                                     *
 *                                                                  *
 * IPC Ports don't appear in the Exec named port list -- they have  *
 * their own.                                                       *
 *                                                                  *
 *                                                                  *
 * Other modules will doubtless have to be added.  One such is      *
 * "LoadIPCPort(name)" which, after doing a GetIPCPort(), will      *
 * check the returned port to see if it has a  server; if not, it   *
 * will check to see if there is a "broker"  process serving the    *
 * IPCBasePort, and if so will send a message to that asking for    *
 * the port to be "served".  (The broker is essentially a server    *
 * like any other -- it will probably look up the port in a user    *
 * supplied list and load the specified server; more advanced       *
 * models may check to see if the server is on another machine,     *
 * for example.)                                                    *
 *                   - - - - - - - - - - -                          *
 *                                                                  *
 *   This code has only been tested under Lattice 5.02.             *
 *   It MUST be compiled with -b0 -v options                        *
 *   (32 bit addressing & no stack check)                           *
 *   AND linked with lcnb.lib  (NOT standard lc.lib).               *
 *   The "__asm" keyword and associated mechanisms have been used   *
 *   to allow direct passing of parameters in registers (the "-r"   *
 *   switch of the compiler could probably have been used instead). *
 *                                                                  *
 *                   - - - - - - - - - - -                          *
 *                                                                  *
 *                                                                  *
 *      %%  The fundamental concept of keeping a use-count  %%      *
 *      %%  on a port is due to Matt Dillon.  Thanks Matt!  %%      *
 *                                                                  *
 ********************************************************************/


#include "IPCStruct.h"
/* This is IPC.h + IPCPorts.h - (Flags & Prototypes) */

/* As we're restricted to Lattice 5, use direct Exec calls: */
#include <proto/exec.h>

#include <exec/types.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <exec/tasks.h>

#define  SOL(s)  ((LONG)sizeof(s))


struct List PortList;  /* All IPC Ports are on this list */



/*
 *  CreateIPCPort is a private procedure which should not be called
 *  directly by a user program.  (Actually it is only called by GetIPCPort
 *  but for clarity it is kept separate.)
 *  The created IPCPort will be added to the PortList
 *  (GetIPCPort won't allow duplicate names) unless the name is NULL,
 *  in which case an "anonymous" port will be created that does not get
 *  onto the list; such anonymous ports can only be accessed by other
 *  processes if they are themselves passed as pointers in messages.
 *  (Note that the call to this procedure MUST be within a
 *  Forbid()/Permit() pair.)
 */

static struct IPCPort * CreateIPCPort(name) char *name;
{
    struct IPCPort * port;
    int psize;

    psize = sizeof(struct IPCPort) + (name ? strlen(name) : 0);
        /* psize is actually one byte too big -- do you care? */
    port = (struct IPCPort *)
           AllocMem((LONG)psize, MEMF_CLEAR | MEMF_PUBLIC);

    if (port) {
        port->ipp_Size = (UWORD)psize;
        NewList(&(port->ipp_Port.mp_MsgList));
        port->ipp_Port.mp_Node.ln_Type = NT_MSGPORT;
        port->ipp_Port.mp_Flags = PA_IGNORE; /* initially */
        if (name) { /* anonymous port is not put on list */
          port->ipp_Port.mp_Node.ln_Name = port->ipp_Name;
                    /* point to name storage array */
          strcpy(port->ipp_Name, name); /* move name to permanent storage */
          AddHead(&PortList, (struct Node *)port);
        }
    }
    return port;
}



/*
 *  UseIPCPort
 *
 *     Registers another connection to a port (outside this module,
 *     this procedure is only used  when the port was passed as a
 *     pointer from another process).
 *     (Use DropIPCPort when done.)
 *     If the current server has set the IPP_NOTIFY flag in the port, the
 *     server task will be signalled using the port signal bit.  NOTE that
 *     WaitPort will NOT detect these signals, because no message is
 *     actually sent; the program must do a Wait on this bit, and should do
 *     a GetMsg as usual, but if the message pointer is null it should
 *     then call, for example, CheckIPCPort.
 *     NOTE -- the port pointer MUST remain valid while this procedure is
 *     called: either the call (from e.g. GetIPCPort) is Forbid()den, or
 *     the port was passed from another process which guarantees its
 *     existence.
 */

void __asm UseIPCPort(register __a0 struct IPCPort * port)
{
    port->ipp_UseCount++;
    if (port->ipp_Flags & IPP_NOTIFY) /* Server wants to be notified */
        Signal(port->ipp_Port.mp_SigTask,
               1L<<port->ipp_Port.mp_SigBit);
}



/*
 *  FindIPCPort
 *
 *     Finds the IPCPort with the name supplied as argument if
 *     it exists and will accept messages (Server exists or is loading).
 *     Returns pointer to port if it exists AND has a server (maybe loading)
 *      -- null otherwise;
 *     registers a new connection to the port (i.e. increments UseCount)
 *     via UseIPCPort.
 *     (Connection must be terminated when program is done by the procedure
 *     DropIPCPort.)
 *     It will notify a server if requested (see UseIPCPort).
 */

struct IPCPort * __asm FindIPCPort(register __a0 char * name)
{
    struct IPCPort * port;
    Forbid();
    port = (struct IPCPort *)FindName(&PortList, name);
    if (port) {
        if (port->ipp_Flags & (IPP_SERVED |IPP_LOADING))
            UseIPCPort(port);
        else
            port = NULL; /* no good if not currently served */
    }
    Permit();
    return port;
}


/*
 *  GetIPCPort
 *
 *     Returns a pointer to IPCPort with the name supplied as an argument;
 *     unlike FindIPCPort, it always returns pointer to port -- this is
 *     created if it doesn't exist; registers a new connection to the port
 *     (use DropIPCPort when done).  It will notify a server if requested
 *     (see UseIPCPort).
 */

struct IPCPort * __asm GetIPCPort(register __a0 char * name)
{
    struct IPCPort * port=NULL;
    Forbid();
    if (name) /* port could be anonymous */
        port = (struct IPCPort *)FindName(&PortList, name);
    if (!port)
        port = CreateIPCPort(name);
    if (port)
        UseIPCPort(port);
    Permit();
    return port;
}


/*
 *  DropIPCPort
 *
 *     Terminate a connection to a port established by FindIPCPort,
 *     GetIPCPort, or UseIPCPort.  Port will be destroyed if there are
 *     no other connections left.
 *     If the IPP_NOTIFY flag is set in the port, the server will be
 *     signalled when this procedure is called (see FindIPCPort).
 */

void __asm DropIPCPort(register __a0 struct IPCPort * port)
{
    if (!port) return; /* to save the client some trouble
                          (in a cleanup procedure) */
    Forbid();
    if (--port->ipp_UseCount == 0) {
        /* an anonymous port is NOT on list -- ALL others MUST be! */
        if (port->ipp_Port.mp_Node.ln_Name) Remove((struct Node *)port);
        Permit();
        FreeMem(port, (ULONG)port->ipp_Size);
    }
    else {
        if (port->ipp_Flags & IPP_NOTIFY) /* Server wants to be notified */
            Signal(port->ipp_Port.mp_SigTask,
                   1L<<port->ipp_Port.mp_SigBit);
        Permit();
    }
}


/*
 *  ServeIPCPort
 *
 *     Registers calling task as the server on the named port (which is
 *     created if it doesn't exist); null is returned if the port already
 *     has a server, otherwise a pointer to it is returned.  At the same
 *     time the port is given the server as its SigTask and a suitable
 *     signal bit is allocated.
 */

struct IPCPort * __asm ServeIPCPort(register __a0 char *name)
{
    struct IPCPort * port;

    port = GetIPCPort(name);
    if (port) {
        Forbid();
        if ((port->ipp_Flags & (IPP_SERVED | IPP_SHUT))
         || (port->ipp_Port.mp_SigBit = AllocSignal(-1L)) == -1L) {
            DropIPCPort(port);
            port = NULL;
        }
        else {
            port->ipp_Port.mp_Flags = PA_SIGNAL;
            port->ipp_Port.mp_SigTask = FindTask(NULL);
            port->ipp_Flags = IPP_SERVED; /* all other bits cleared */
        }
        Permit();
    }
    return port;
}

/*
 *  ShutIPCPort
 *
 *     ONLY the current server may call this procedure.
 *     It prevents more messages being sent to this port, but
 *     does not end server connection; remaining messages can be dealt
 *     with before finally calling LeaveIPCPort.
 *     Note that it does NOT inhibit the server being signalled if
 *     IPP_NOTIFY is set and another client connects.  (At the moment
 *     there is no mechanism to reopen a shut port without Leaving
 *     first; this may be possible in a future revision.)
 */

void __asm ShutIPCPort(register __a0 struct IPCPort * port)
{
    Forbid(); /* now required because of FindIPCPort test */
    port->ipp_Flags |= IPP_SHUT; /* Prevent other servers connecting */
    port->ipp_Flags &= ~IPP_SERVED; /* prevent messages from landing */
    port->ipp_Port.mp_Flags = PA_IGNORE; /* someone might use PutMsg! */
    Permit();
}

/*
 *  LeaveIPCPort
 *
 *     ONLY the current server may call this procedure.
 *     Disconnects the server process from the port; another process
 *     can then become a server if it desires.  If there are no other
 *     connections, the port is removed.
 */

void __asm LeaveIPCPort(register __a0 struct IPCPort * port)
{
    FreeSignal(port->ipp_Port.mp_SigBit);
    port->ipp_Port.mp_SigTask = NULL;
    port->ipp_Flags &= ~(IPP_SHUT | IPP_SERVED | IPP_SERVER_FLAGS);
    DropIPCPort(port);
}


/*
 *  CheckIPCPort
 *
 *     Normally returns the number of current connections to this port
 *     (including the server); if the top bit (0x8000) of the flags
 *     argument is set, it will instead return the IPCPort flag word
 *     value at the time of the call.  (Note that these values are
 *     not guaranteed!)
 *     A call by the server (only) will also set the (user
 *     settable) port flags to the value in the second argument --
 *     currently the only valid flag is IPP_NOTIFY.
 */

ULONG __asm CheckIPCPort(
       register __a0 struct IPCPort *port,
       register __d0 UWORD flags)
{
    UWORD origflags = port->ipp_Flags;
    if (port->ipp_Port.mp_SigTask == FindTask(NULL))
        /* only server can change flags */
        port->ipp_Flags = (port->ipp_Flags & ~IPP_SERVER_FLAGS) |
                          (flags & IPP_SERVER_FLAGS);
    return (ULONG)((flags & 0x8000)? origflags : port->ipp_UseCount);
}


/*
 *  PutIPCMsg
 *
 *     Sends an IPCMessage to an IPCPort; if the port has no server or
 *     is shut, the message is not sent and the function returns FALSE;
 *     otherwise it returns TRUE. (Other port flags to be added later
 *     may affect these actions.)
 *     Note that a ReplyPort should be supplied in the message as usual
 *     (except for the rare possible usage where a message is not to
 *     be replied; in this case, the IPC_TRANSFER flag must be set in
 *     both the message and all the items it contains, and the ReplyPort
 *     must be NULL).
 */

ULONG __asm PutIPCMsg(
            register __a0 struct IPCPort *port,
            register __a1 struct IPCMessage *msg)
{
    Forbid(); /* we do this the straightforward way -- it's very quick */
    if (port->ipp_Flags & (IPP_SERVED | IPP_LOADING)) {
        PutMsg((struct MsgPort *)port, (struct Message *)msg);
        Permit();
        return TRUE;
    }
    Permit();
    return FALSE;
}


/*
 *  CreateIPCMsg
 *
 *     Creates a standard IPCMessage block (in MEMF_PUBLIC) with the
 *     number of IPCItems supplied as argument. (Special cases -- like
 *     in-line data -- you will have to handle yourself, and you always
 *     have to manage the data blocks yourself).
 */

struct IPCMessage * __asm CreateIPCMsg(
    register __d0 int nitems,
    register __d1 int nxbytes,
    register __a0 struct MsgPort *replyport)
{
    ULONG msgsize, mlength;
    struct IPCMessage * mp;
    msgsize = sizeof(struct IPCMessage) +
                  (nitems - 1)*SOL(struct IPCItem) + nxbytes;
    mlength = msgsize - sizeof(struct Message);
    if (mlength > 0x0000FFFF)
        return NULL; /* no oversize messages! */
    mp = (struct IPCMessage *)
         AllocMem(msgsize, MEMF_CLEAR | MEMF_PUBLIC);
    if (mp) {
        mp->ipc_Msg.mn_Length = mlength;
        mp->ipc_ItemCount = nitems;
        mp->ipc_Msg.mn_ReplyPort = replyport;
    }
    return  mp;
}


/*
 *  DeleteIPCMsg
 *
 *     Deletes a standard IPCMessage block;  you must first have disposed
 *     of any attached data as appropriate.
 */

void __asm DeleteIPCMsg(register __a0 struct IPCMessage *msg)
{
    FreeMem(msg, SOL(struct Message) + msg->ipc_Msg.mn_Length);
}


            /*********************************************/

