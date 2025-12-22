#include <exec/execbase.h>
#include <exec/errors.h>
#include <clib/_exec.h>

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

FC3(1,void,Dev_Open,A6,struct IORequest *iob,A1,ULONG unitnum,D0,ULONG flags,D1)
;
FC1(2,BPTR,Dev_Close,A6,struct IORequest *iob,A1)
;
FC0(3,BPTR,Dev_Expunge,A6)
;
FC1(5,void,Dev_BeginIO,A6,struct IORequest *iob,A1)
;
FC1(6,ULONG,Dev_AbortIO,A6,struct IORequest *iob,A1)
;

FD1(72,void,AddDevice,struct Device *device,A1)
{
  Forbid();
    Enqueue(&SysBase->DeviceList,&device->dd_Library.lib_Node);
  Permit();
}

FD1(73,void,RemDevice,struct Device *device,A1)
{
  Forbid();
    Dev_Expunge(device);
  Permit();
}

FD4(74,BYTE,OpenDevice,STRPTR devName,A0,ULONG unitNumber,D0,struct IORequest *iORequest,A1,ULONG flags,D1)
{
  struct Device *dev;
  BYTE ret=IOERR_OPENFAIL;
  Forbid();
    dev=(struct Device *)FindName(&SysBase->DeviceList,devName);
    if(dev)
    {
      iORequest->io_Error=0;
      iORequest->io_Device=dev;
      iORequest->io_Flags=flags;
      iORequest->io_Message.mn_Node.ln_Type=NT_REPLYMSG;
      Dev_Open(dev,iORequest,unitNumber,flags);
      if((ret=iORequest->io_Error)!=NULL)
        iORequest->io_Device=NULL;
    }
  Permit();
  return ret;
}

FD1(75,void,CloseDevice,struct IORequest *iORequest,A1)
{
  Forbid();
    if(iORequest->io_Device)
    {
      Dev_Close(iORequest->io_Device,iORequest);
      iORequest->io_Device=NULL;
    }
  Permit();
}

FD1(77,void,SendIO,struct IORequest *iORequest,A1)
{
  iORequest->io_Flags=0;
  iORequest->io_Message.mn_Node.ln_Type=0;
  Dev_BeginIO(iORequest->io_Device,iORequest);
}

FD1(78,struct IORequest *,CheckIO,struct IORequest *iORequest,A1)
{
  if(!(iORequest->io_Flags&IOF_QUICK)&&iORequest->io_Message.mn_Node.ln_Type==NT_MESSAGE)
    return NULL; /* Still in use */
  else
    return iORequest;
}

FD1(79,BYTE,WaitIO,struct IORequest *iORequest,A1)
{
  while(!CheckIO(iORequest))
    Wait(1<<iORequest->io_Message.mn_ReplyPort->mp_SigBit);
  if(iORequest->io_Message.mn_Node.ln_Type==NT_REPLYMSG)
  {
    Disable(); /* Cannot use GetMsg() - there may be other messages pending */
      Remove(&iORequest->io_Message.mn_Node);
    Enable();
  }
  return iORequest->io_Error;
}

FD1(80,void,AbortIO,struct IORequest *iORequest,A1)
{
  Dev_AbortIO(iORequest->io_Device,iORequest);
}

FD1(76,BYTE,DoIO,struct IORequest *iORequest,A1)
{
  iORequest->io_Flags=IOF_QUICK;
  iORequest->io_Message.mn_Node.ln_Type=0;
  Dev_BeginIO(iORequest->io_Device,iORequest);
  if(!(iORequest->io_Flags&IOF_QUICK))
    WaitIO(iORequest);
  return iORequest->io_Error;
}

FD2(109,struct IORequest *,CreateIORequest,struct MsgPort *ioReplyPort,A0,ULONG size,D0)
{
  struct IORequest *ret=NULL;
  if(ioReplyPort&&(ret=(struct IORequest *)AllocMem(size,MEMF_PUBLIC|MEMF_CLEAR)))
  {
    ret->io_Message.mn_ReplyPort=ioReplyPort;
    ret->io_Message.mn_Length=size;
  }
  return ret;
}

FD1(110,void,DeleteIORequest,struct IORequest *ioReq,A0)
{
  if(ioReq)
    FreeMem(ioReq,ioReq->io_Message.mn_Length);
}

/* Not really in exec.library but we must do it anyway */
void BeginIO(struct IORequest *ioReq)
{
  Dev_BeginIO(ioReq->io_Device,ioReq);
}
