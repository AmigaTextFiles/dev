#ifndef ML_API_DEV_H
#define ML_API_DEV_H

#include <exec/ports.h>

/*
** Commands to be sent to the device
*/
#define MLCMD_READ      (CMD_NONSTD+0)      // Send a packet
#define MLCMD_WRITE     (CMD_NONSTD+1)      // recieve a packet
#define MLCMD_QUERY     (CMD_NONSTD+2)      // query the device

#define MLCMD_INIT      (CMD_NONSTD+0x10)   // for internal use only

void __saveds __asm ML_BeginIO(register __a1 struct IORequest *IOReq);
void __saveds __asm ML_AbortIO(register __a1 struct IORequest *IOReq);

#endif
