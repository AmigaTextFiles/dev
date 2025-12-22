#ifndef IPC_PORTS_H
#define IPC_PORTS_H

/*** include this BEFORE IPC.H (if required) ***/

/*******************************************************************
 *                                                                 *
 *                           IPCPorts.h                            *
 *                                                                 *
 *           Inter-Process-Communication Port Format               *
 *                                                                 *
 *              Release  2.0 -- 1989 March 25                      *
 *                                                                 *
 *              Copyright 1988,1989 Peeter Goodeve                 *
 *                                                                 *
 *  This source is freely distributable, and may be used freely    *
 *  in any program,  but the structures should not be modified.     *
 *                                                                 *
 *******************************************************************/
/*******************************************************************
 *                                                                 *
 *  88:7:22     ipp_BrokerInfo added to IPCPort                    *
 *                                                                 *
 *  89:3:25     IPCBasePort structure removed for shared lib.      *
 *                                                                 *
 *                                                                 *
 *******************************************************************/

#ifndef EXEC_TYPES_H
#include "exec/types.h"
#endif

#ifndef EXEC_PORTS_H
#include "exec/ports.h"
#endif

/*******************************************************************
 *                                                                 *
 *  IPC Ports are essentially standard Exec message Ports except   *
 *  for added fields to keep track of their usage.  Also they      *
 *  are kept on their own list.                                    *
 *                                                                 *
 *  NOTE: IPCPorts are READ-ONLY TO ALL APPLICATION PROGRAMS!!     *
 *   -- their internal data must be changed ONLY by the library    *
 *  routines; for example, their ln_Node must NEVER be used by an  *
 *  application to hang them on a local list (even if they are     *
 *  anonymous).                                                    *
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


/* ipp_Flags -- defined in IPC.h: */

/***********************************
#define IPP_SERVED 0x8000
#define IPP_SHUT 0x4000
#define IPP_REOPEN 0x2000
#define IPP_LOADING 0x1000

#define IPP_NOTIFY 0x0001
***********************************/

#define IPP_SERVER_FLAGS 0x00FF


/*******************************************************************/

#endif

