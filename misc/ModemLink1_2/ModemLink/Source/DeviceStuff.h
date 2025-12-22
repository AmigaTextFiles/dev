#ifndef DEVICES_STUFF_H
#define DEVICE_STUFF_H

#include <exec/types.h>
#include <exec/io.h>
#include <exec/ports.h>

int OpenTimerDevice(struct MsgPort **TimerMP, struct timerequest **TimerIO);
int OpenSerialDevice(struct MsgPort **SerMP, struct IOExtSer **SerIO, char *SerName, LONG Unit);

int TimedIO(struct IORequest *IOReq, int TimeOut);
void DoAbortIO(struct IORequest *IO);
void SafeCloseDevice(struct MsgPort *MP, struct IORequest *IO);

int CloneIO(struct IORequest *IO, struct MsgPort **NewMP, struct IORequest **NewIO);
void DeleteIO_MP(struct MsgPort *MP, struct IORequest *IO);

#endif
