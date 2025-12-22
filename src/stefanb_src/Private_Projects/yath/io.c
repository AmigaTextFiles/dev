#include "io.h"

BYTE OpenSCSIchan(struct scsichan *ch)
{
 if (!ch) return(1);
 if (ch->iop || ch->ior) return(2);

 if (!(ch->iop=CreateMsgPort())) return(3);

 if (!(ch->ior=CreateIORequest(ch->iop,sizeof(struct IOStdReq))))
  {
   DeleteMsgPort(ch->iop);
   ch->iop=NULL;
   return(4);
  }

 return(OpenDevice(ch->name,ch->unit,ch->ior,ch->flags));
}

BYTE DoSCSIcmd(struct scsichan *ch, struct SCSICmd *cmd)
{
 if (!ch) return(1);
 if (!ch->iop) return(2);
 if (!ch->ior) return(3);
 if (!cmd) return(4);
 ch->ior->io_Command=HD_SCSICMD;
 ch->ior->io_Data=(APTR) cmd;
 ch->ior->io_Length=sizeof(struct SCSICmd);
 DoIO(ch->ior);

 return(cmd->scsi_Status);
}

BYTE CloseSCSIchan(struct scsichan *ch)
{
 if (!ch) return(1);
 if (!ch->iop) return(2);
 if (!ch->ior) return(3);
 CloseDevice(ch->ior);
 DeleteIORequest(ch->ior);
 ch->ior=NULL;
 DeleteMsgPort(ch->iop);
 ch->iop=NULL;
 return(0);
}
