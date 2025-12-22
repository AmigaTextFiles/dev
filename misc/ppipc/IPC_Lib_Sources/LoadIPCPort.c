/********************************************************************
 *                                                                  *
 *                 LoadIPCPort module 89:3:26                       *
 *                                                                  *
 *                  Shared Library version                          *
 *                                                                  *
 ********************************************************************/

#include "IPCStruct.h"
#include "IPCAsmCalls.h"

#define IPPL MAKE_ID('I','P','P','L')
#define PORT MAKE_ID('P','O','R','T')

/*
 *  LoadIPCPort
 *
 *     Gets an IPCPort of the specified name.  If it is not already
 *     being served or had a server being loaded, a message is sent
 *     to PortBrokerPort (if IT exists and has a server) requesting
 *     that a server be supplied.
 *     If, when the message is replied, the port is flagged as served
 *     or being loaded, the port pointer is returned. If no server is
 *     available, it drops the port again and returns NULL.
 */

struct IPCPort * __asm LoadIPCPort(register __a0 char *name)
{
    struct IPCPort * port = NULL,
                   * RPort = NULL,
                   * brokerport = NULL;
    struct IPCMessage *mesg = NULL;
    struct IPCItem *item;

    port = GetIPCPort(name);
    if (!port) return NULL;
    if (port->ipp_Flags & (IPP_SERVED | IPP_LOADING))
        return port;
    if ((RPort = ServeIPCPort(NULL)) /* only a replyport really
                                    ... saves need for CreatePort */
            && (mesg = CreateIPCMsg(1, 0, (struct MsgPort *)RPort))
            && (brokerport = FindIPCPort("PortBrokerPort"))) {
        mesg->ipc_Id = IPPL;
        item = mesg->ipc_Items;
        item->ii_Id = PORT;
        item->ii_Ptr = (void *)port;
        if (PutIPCMsg(brokerport, mesg)) {
            WaitPort(RPort);
            GetMsg(RPort);
        }
        DropIPCPort(brokerport);
    }
    if (RPort) LeaveIPCPort(RPort); /* No need to shut it first */
    if (mesg) DeleteIPCMsg(mesg);
    if (port->ipp_Flags & (IPP_SERVED | IPP_LOADING))
        return port;
    DropIPCPort(port);
    return NULL;
}


