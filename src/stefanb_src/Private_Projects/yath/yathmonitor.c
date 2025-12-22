/*
 * yathmonitor.c   V0.01 (beta)
 *
 * tape handler monitor
 *
 * (c) 1992 by Stefan Becker
 *
 */
#ifdef DEBUG
#include "yath.h"

void main(int argc, char *argv)
{
 BOOL notend=TRUE,open=FALSE;
 struct MsgPort *MonitorPort;
 ULONG PortSig,SigMask;

 /* Print banner */
 puts("YATH Debug Monitor V0.01");

 /* Create debug monitor port */
 if (!(MonitorPort=CreateMsgPort()))
  {
   puts("Couldn't create port!");
   exit(20);
  }

 /* Make port available to the public */
 MonitorPort->mp_Node.ln_Pri=0;
 MonitorPort->mp_Node.ln_Name=MPORTNAME;
 AddPort(MonitorPort);

 /* Create signal masks */
 PortSig=1L<<MonitorPort->mp_SigBit;
 SigMask=PortSig|SIGBREAKF_CTRL_C;

 /* Main event loop */
 while (notend || open)
  {
   ULONG RcvdSigs;

   /* Wait on signal */
   RcvdSigs=Wait(SigMask);

   /* Received a CTRL-C? */
   if (RcvdSigs&SIGBREAKF_CTRL_C)
    {
     if (open)
      puts("Can't close yet, will exit ASAP!"); /* Sorry.... */
     else
      RemPort(MonitorPort); /* Remove port from list */
     notend=FALSE; /* Set exit flag */
    }

   /* Received a message from tape handler? */
   if (RcvdSigs&PortSig)
    {
     struct MonitorMessage *msg;
     ULONG cmd,arg1,arg2;

     /* Retrieve message from port */
     msg=GetMsg(MonitorPort);

     /* Copy message values */
     cmd=msg->mm_cmd;
     arg1=msg->mm_arg1;
     arg2=msg->mm_arg2;

     /* Close command and pending CTRL-C? */
     if (!notend && (cmd==YATH_CLOSE))
      RemPort(MonitorPort); /* Yes, remove port from list */

     /* Reply message */
     ReplyMsg((struct Message *) msg);

     switch(cmd)
      {
       case YATH_OPEN:
        printf("Opened for %s.\n",(arg1)?"reading":"writing");
        open=TRUE;
        break;

       case YATH_CLOSE:
        puts("Closed.");
        open=FALSE;
        break;

       case YATH_READ:
        printf("Read %ld bytes.\n",arg1);
        break;

       case YATH_WRITE:
        printf("Write %ld bytes.\n",arg1);
        break;

       case YATH_FLUSH:
        puts("Flushing buffers.");
        break;

       case YATH_IOERR:
        printf("I/O Error %d, SCSI status 0x%02x\n",arg1,arg2);
        break;

       case YATH_SCSI:
        printf("SCSI Command 0x%02x, %synch I/O\n",arg1,(arg2)?"As":"S");
        break;

       default:
        printf("Unknown message received: %ld %ld %ld\n",cmd,arg1,arg2);
        break;
      }
    }
  }

 /* The end... */
 puts("Monitor closing...");
 DeleteMsgPort(MonitorPort);
 exit(0);
}
#endif
