/*******************************************************************
 *                                                                 *
 *                           IPC.h                                 *
 *                                                                 *
 *           Inter-Process-Communication Message Format            *
 *                                                                 *
 *              Revision 2.21 -- 1989 April 28                     *
 *                                                                 *
 *         Copyright 1988,1989 Peter da Silva & Peter Goodeve      *
 *                      All Rights reserved                        *
 *                                                                 *
 *  This source is freely distributable, but should not be         *
 *  modified without prior consultation with the authors.          *
 *                                                                 *
 *******************************************************************/
/*******************************************************************
 *                                                                 *
 *  89:3:26 [2.1]   Shared Library Version -- LoadIPCPort added.   *
 *  89:4:17 [2.2]   MakeIPCId and FindIPCItem added;               *
 *     "      "     Flags IPC_NONSTANDARD and IPC_VITAL added.     *
 *  89:4:28 [2.21]  IPC_NOTKNOWN changed to IPC_REJECT             *
 *                                                                 *
 *******************************************************************/

#ifdef AZTEC_C
/* can't use prototyping */
#define NARGS 1
/* (if NARGS is undefined, prototyping is enabled) */
#endif

#ifndef EXEC_TYPES_H
#include "exec/types.h"
#endif

#ifndef EXEC_PORTS_H
#include "exec/ports.h"
#endif

/*** Item Reference block -- an arbitrary number of these may be
   put in an IPCMessage ***/

struct IPCItem {
    ULONG   ii_Id;      /* four character ID (normally);
                           determines exact meaning of IPCItem IDs */
    ULONG   ii_Flags;   /* upper 16 bits have standard meaning;
                           lower 16 bits are message dependent */
    ULONG   ii_Size;    /* size of data structure (zero if ii_Ptr is not
                           actually a pointer to data) */
    void   *ii_Ptr;     /* points to defined data structure (could be within
                           message block if IE_Flags says so) -- also may be
                           recast to other 32-bit value (e.g. Lock) */
    };



/*** The basic IPCMessage block ***/

struct IPCMessage {
    struct Message  ipc_Msg;
        /* ..ln_Name field should be NULL
            mn_Length will include IPC_Items array and any in-line data
        */
    ULONG   ipc_Id,                /* four character (or other) ID */
            ipc_Flags;
    UWORD   ipc_ItemCount;         /* number of items in array */
    struct  IPCItem ipc_Items[1];  /* .. actual size as needed */
    };


/*************************************************************/

/*** Note that ALL bits in the upper byte are now allocated 89:4:17 ***/
/*** These are now considered pretty well set in concrete!  ***/

/* Flags set by client: */
/* -- may appear in either IPCItem or IPCMessage Flags field */

#define IPC_TRANSFER   0x08000000
    /* Data block ownership is to be transferred to receiver. */
#define IPC_NETWORK    0x04000000
    /* The data in this block/message may be transmitted to
       another machine */
#define IPC_INMESSAGE  0x02000000
    /* The data in this block/message is included in the message length */
#define IPC_NONSTANDARD 0x01000000
    /* The data in this block/message does NOT conform to the protocol
       (might be a list structure, for instance).  DON'T delete or modify
       UNLESS you know how to handle it.
       NOTE: ANY ID used with this flag MUST have common meaning to ALL
       programs (if they recognize it). */

#define IPC_VITAL      0x20000000
    /* This Item/Message MUST be recognized, otherwise the whole message
       must be replied unprocessed (with IPC_REJECT set). */


/* Flags returned by server: */

#define IPC_REJECT     0x80000000
#define IPC_NOTKNOWN   0x80000000
    /* The server could not handle this block/message
       (either because it did not understand the ID or
       was unable to process it -- see the secondary flags) */
    /* IPC_REJECT replaces IPC_NOTKNOWN (which should no longer be used) */

#define IPC_MODIFIED   0x40000000
    /* The server modified the data, either within the
       supplied data block(s) or -- if permitted -- by
       replacing/removing the block pointer; again maybe
       other flag bits should indicate the nature of
       the modification */

/* valid for Item only: */
#define IPC_SERVER_OWNED 0x10000000
    /* The server owns this data Item -- either because it has
       created it or because it took it over from the client
       (in which case it clears IPC_TRANSFER, which must have
       been set) */


/* secondary flag bits: */

#define IPC_CHECKITEM 0x00800000
    /* associated with IPC_REJECT -- indicates that one or more
       particular items caused the flag to be set */
#define IPC_FAILED 0x00400000
    /* IPC_REJECT flag was set because the server failed to
       handle an ID that it is designed to (rather than just
       not recognizing the block) */

/*************************************************************/


/*** IPC Ports and Procedures ***/


/* -- see IPCPorts.h for actual structure definitions */
#ifndef IPC_PORTS_H
/* Normal user doesn't need access to port components,
   so just use a convenient define.  Note that an IPC port
   is NEVER in private data space -- or in the public port
   list -- it is created and managed by the package routines
   only.
   NOTE also: IPCPorts are READ-ONLY TO ALL APPLICATION PROGRAMS!!
   -- their internal data must be changed ONLY by the library routines;
   for example, their ln_Node must NEVER be used by an application
   to hang them on a local list (even if they are anonymous). */
#define IPCPort MsgPort
#endif

/*************************************************************/


/* IPC Port Handling function prototypes: */

#ifndef NARGS /* define this to SUPPRESS function argument prototyping */

struct IPCPort * LoadIPCPort(char *);
    /* [Requires an external "Port Broker" process -- otherwise
       it behaves like FindIPCPort.]
       returns pointer to port if it exists and has a Server
       (or one is loading) -- if it doesn't, it sends a
       message to PortBrokerPort requesting a server for the
       port; if the Broker process cannot load a server (or
       there IS no Broker process) the function returns
       NULL; if the Broker initiates execution of a server
       the function returns the port pointer and registers a
       new connection to the port */

                            /* * * * */

ULONG MakeIPCId(char *);
    /* returns 32-bit ID value corresponding to supplied (4-char) string
       (shorter will be LEFT justified, longer will be truncated). */

struct IPCItem * FindIPCItem(struct IPCMessage *, ULONG, struct IPCItem *);
    /* returns first item in message that matches ID; if item pointer is
       not NULL, search will begin at that item rather than first. */

                            /* * * * */

struct IPCPort * FindIPCPort(char *);
    /* returns pointer to port if it exists -- null otherwise;
       registers a new connection to the port */

struct IPCPort * GetIPCPort(char *);
    /* returns pointer to port -- it is created if it doesn't exist;
       registers a new connection to the port */


void UseIPCPort(struct IPCPort *);
    /* adds a connection to a port (passed by pointer from another
       process) */


void DropIPCPort(struct IPCPort *);
    /* disconnect from port -- port will be destroyed if there are
       no other connections left */


struct IPCPort * ServeIPCPort(char *);
    /* become a server for the named port (created if it doesn't exist);
       null is returned if the port already has a server, otherwise a
       pointer to it is returned */

void ShutIPCPort(struct IPCPort *);
    /* (server only) prevent more messages being sent to this port, but
       do not end server connection; remaining messages can be dealt
       with before Leaving */

void LeaveIPCPort(struct IPCPort *);
    /* cease to be a server for this port; another process can then
       become a server if it desires */

CheckIPCPort(struct IPCPort *, UWORD);
    /* returns number of current connections to this port (including
       server); a call by the server (only) will also set the (user
       settable) port flags to the value in the second argument --
       currently the only valid flag is IPP_NOTIFY */


PutIPCMsg(struct IPCPort *, struct IPCMessage *);
    /* sends an IPCMessage to an IPCPort; if the port has no server or
       is shut, the message is not sent and the function returns FALSE;
       otherwise it returns TRUE. (Other port flags to be added later
       may affect these actions.) */

struct IPCMessage * CreateIPCMsg(int, int, struct MsgPort *);
    /* creates a standard IPCMessage block (in MEMF_PUBLIC) with the
       number of IPCItems supplied as first argument;  the second
       argument is the number of bytes -- if any -- to reserve beyond
       that required for the items; the third is a pointer to the
       ReplyPort (may be NULL -- note that it's a standard MsgPort,
       not an IPCPort). (You always have to manage any data
       blocks yourself). */


void DeleteIPCMsg(struct IPCMessage *);
    /* deletes a standard IPCMessage block;  you must first have disposed
       of any attached data as appropriate */

/*************************************************************/
#else NARGS defined

struct IPCPort * LoadIPCPort ();

ULONG  MakeIPCId ();
struct IPCItem * FindIPCItem();

struct IPCPort * FindIPCPort ();
struct IPCPort * GetIPCPort ();
void             UseIPCPort ();
void             DropIPCPort ();
struct IPCPort * ServeIPCPort ();
void             ShutIPCPort ();
void             LeaveIPCPort ();
int              CheckIPCPort ();
int              PutIPCMsg ();
struct IPCMessage * CreateIPCMsg ();
void             DeleteIPCMsg ();

/*************************************************************/
#endif NARGS


/* System IPCPort flags: */

#define IPP_SERVED 0x8000
    /* port currently has a server */
#define IPP_SHUT 0x4000
    /* port is no longer open for new messages (server still attached) */
#define IPP_REOPEN 0x2000
    /* set (by "Port Broker") to request that server reopen service
       to this port after it has completed Shut/Leave sequence
       in progress */
#define IPP_LOADING 0x1000
    /* set (by "Port Broker") to indicate that a server is being loaded
       for this port (cleared by ServeIPCPort()) */


/* Server settable Port flags: */

#define IPP_NOTIFY 0x0001
    /* server wants to be signalled if connection is added or
       dropped (the port sigbit is used to signal the task,
       but no message is sent) */

/*************************************************************/

/*
 *  Some useful Macros:
 */

#define GetIPCMessage(port) ((struct IPCMessage *)GetMsg((struct MsgPort *)port))

#define ReplyIPCMessage(msg)  ReplyMsg((struct Message *)msg)

#define SigBitIPCPort(port) (1<<((struct MsgPort *)port)->mp_SigBit)
    /* note: this will work whether or not IPCPorts.h has been included */


/*
   For convenience in creating (fixed) IDs:
    (Alternatively, your compiler may have multi-character constants,
     which you may find more convenient (but less portable...))
     The library now also supplies the function MakeIPCId which you can
     use to create IDs at run-time from strings.
*/

#define MAKE_ID(a,b,c,d) ((a)<<24L | (b)<<16L | (c)<<8 | (d))


