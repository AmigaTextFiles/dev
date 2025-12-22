/*******************************************************************
 *                                                                 *
 *               IPCStruct.h                                       *
 *                                                                 *
 *              PPIPC Release  2.0 -- 1989 March 25                *
 *                                                                 *
 *  This contains just the IPC structures (Shared Library version) *
 *  (No IPC Flags or function prototypes)                          *
 *                                                                 *
 *                                                                 *
 *                                                                 *
 *              Copyright 1988,1989 Peter Goodeve                  *
 *                                                                 *
 *  This source is freely distributable, and may be used freely    *
 *  in any program,  but the structures should not be modified.    *
 *                                                                 *
 *******************************************************************/

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

#ifndef IPC_PORTS_H
#define IPC_PORTS_H


/*******************************************************************
 *                                                                 *
 *  88:7:22     ipp_BrokerInfo added to IPCPort                    *
 *                                                                 *
 *  89:3:25     IPCBasePort removed for shared library             *
 *                                                                 *
 *******************************************************************/


/*******************************************************************
 *                                                                 *
 *  IPC Ports are essentially standard Exec message Ports except   *
 *  for added fields to keep track of their usage.  Also they      *
 *  are kept on their own list.                                    *
 *                                                                 *
 *  Note that the port name has to be kept WITHIN the structure    *
 *  also, as the process that created it may go away.  The size    *
 *  field holds the size of the structure including the name, so   *
 *  it may be deleted safely when no longer needed.                *
 *                                                                 *
 *******************************************************************/

struct IPCPort {
    struct MsgPort  ipp_Port;
    ULONG           ipp_Id;         /* for future use */
    UWORD           ipp_UseCount,   /* number of connections to the port */
                    ipp_Flags,      /* internal information */
                    ipp_Size;       /* size of the WHOLE structure */
    void          * ipp_Broker_Info;  /* pointer to private information */
    char            ipp_Name[1];    /* where name is actually kept! */
    };


/*******************************************************************
 *                                                                 *
 *  Note that the Shared Library version does not use an           *
 *  "IPCBasePort" structure in the public Exec Port list.          *
 *  All data structures are maintained internally to the           *
 *  library.                                                       *
 *                                                                 *
 *******************************************************************/


#endif



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

#define IPP_SERVER_FLAGS 0x00FF


#define IPP_NOTIFY 0x0001
    /* server wants to be signalled if connection is added or
       dropped (the port sigbit is used to signal the task,
       but no message is sent) */

/*************************************************************/

/*
   For convenience in creating IDs:
*/

#define MAKE_ID(a,b,c,d) ((a)<<24L | (b)<<16L | (c)<<8 | (d))



