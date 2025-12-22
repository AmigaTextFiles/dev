/********************************************************************
 *                                                                  *
 *      Direct call prototypes for IPC Shared Library internal use  *
 *                                                                  *
 *                  1989 March 26                                   *
 *                                                                  *
 ********************************************************************/

void __asm UseIPCPort(register __a0 struct IPCPort * port);
struct IPCPort * __asm FindIPCPort(register __a0 char * name);
struct IPCPort * __asm GetIPCPort(register __a0 char * name);
void __asm DropIPCPort(register __a0 struct IPCPort * port);
struct IPCPort * __asm ServeIPCPort(register __a0 char *name);
void __asm ShutIPCPort(register __a0 struct IPCPort * port);
void __asm LeaveIPCPort(register __a0 struct IPCPort * port);
ULONG __asm CheckIPCPort(
       register __a0 struct IPCPort *port,
       register __d0 UWORD flags);
ULONG __asm PutIPCMsg(
            register __a0 struct IPCPort *port,
            register __a1 struct IPCMessage *msg);
struct IPCMessage * __asm CreateIPCMsg(
    register __d0 int nitems,
    register __d1 int nxbytes,
    register __a0 struct MsgPort *replyport);
void __asm DeleteIPCMsg(register __a0 struct IPCMessage *msg);
struct IPCPort * __asm LoadIPCPort(register __a0 char * name);

