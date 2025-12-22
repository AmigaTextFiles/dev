/*
 * serio.c  V0.00
 *
 * Serial device utility routines
 *
 * (c) 1992 Stefan Becker
 *
 */

#include "serio.h"

/* Create a serial stream */
struct SerialStream *CreateSerialStream(char *DeviceName, ULONG Unit,
                                        ULONG SerFlags)
{
 register struct SerialStream *ss;

 /* Get memory for struct */
 if (ss=AllocMem(sizeof(struct SerialStream),MEMF_CLEAR|MEMF_PUBLIC))
  {
   /* Create reply port for I/O Requests */
   if (ss->ss_RPort=CreateMsgPort())
    {
     /* Create serial I/O command request */
     if (ss->ss_Cmd=CreateIORequest(ss->ss_RPort,sizeof(struct IOExtSer)))
      {
       /* Create serial I/O read reuqest */
       if (ss->ss_Read=CreateIORequest(ss->ss_RPort,sizeof(struct IOExtSer)))
        {
         /* Create serial I/O write reuqest */
         if (ss->ss_Write=CreateIORequest(ss->ss_RPort,sizeof(struct IOExtSer)))
          {
           /* Init I/O read request */
           ss->ss_Cmd->io_SerFlags=SerFlags;

           /* Open serial device */
           if (!OpenDevice(DeviceName,Unit,(struct IORequest *) ss->ss_Cmd,0))
            {
             /* Copy I/O request */
             *ss->ss_Read=*ss->ss_Cmd;
             *ss->ss_Write=*ss->ss_Cmd;

             /* Safety code for WaitIO()! */
             ReplyMsg((struct Message *) ss->ss_Read);
             ReplyMsg((struct Message *) ss->ss_Write);

             /* Init rest of struct */
             ss->ss_Mask=1L<<ss->ss_RPort->mp_SigBit;
             ss->ss_Baud=ss->ss_Cmd->io_Baud;

             /* All OK! */
             return(ss);
            }

           /* Something has gone wrong */
           DeleteIORequest(ss->ss_Write);
          }
         DeleteIORequest(ss->ss_Read);
        }
       DeleteIORequest(ss->ss_Cmd);
      }
     DeleteMsgPort(ss->ss_RPort);
    }
   FreeMem(ss,sizeof(struct SerialStream));
  }
 return(NULL);
}

/* Delete a serial stream */
void DeleteSerialStream(struct SerialStream *stream)
{
 /* Abort all pending I/O requests */
 RemoveIORequest((struct IORequest *) stream->ss_Read);
 RemoveIORequest((struct IORequest *) stream->ss_Write);

 /* Free all resources */
 CloseDevice((struct IORequest *) stream->ss_Cmd);
 DeleteIORequest(stream->ss_Write);
 DeleteIORequest(stream->ss_Read);
 DeleteIORequest(stream->ss_Cmd);
 DeleteMsgPort(stream->ss_RPort);
 FreeMem(stream,sizeof(struct SerialStream));
}

/* Set serial stream parameters */
BOOL SetSerialParamsTagList(struct SerialStream *stream,
                            struct TagItem *TagArray)
{
 struct TagItem *tstate,*ti;
 struct IOExtSer *ior=stream->ss_Cmd;

 /* Wait until all read/write I/O requests are finished */
 WaitIO((struct IORequest *) stream->ss_Read);
 WaitIO((struct IORequest *) stream->ss_Write);

 /* Scan all tags */
 tstate=TagArray;
 while (ti=NextTagItem(&tstate))
  switch(ti->ti_Tag)
   {
    case SIO_Baud:ior->io_Baud=ti->ti_Data;
                  break;
   }

 /* Execute I/O command */
 ior->IOSer.io_Command=SDCMD_SETPARAMS;
 if (DoIO((struct IORequest *) ior)) return(FALSE); /* Couldn't set params! */

 /* Read new values */
 *(stream->ss_Read)=*ior;
 *(stream->ss_Write)=*ior;
 stream->ss_Baud=ior->io_Baud;
 return(TRUE);
}

BOOL SetSerialParamsTags(struct SerialStream *stream, Tag Tag1, ...)
{
 return(SetSerialParamsTagList(stream,(struct TagItem *) &Tag1));
}

/* Query actual parameters of serial stream */
BOOL QuerySerial(struct SerialStream *stream)
{
 struct IOExtSer *ior=stream->ss_Cmd;

 /* Execute I/O command */
 ior->IOSer.io_Command=SDCMD_QUERY;
 if (DoIO((struct IORequest *) ior)) return(FALSE); /* I/O Error */

 /* Read new status */
 stream->ss_Status=ior->io_Status;
 stream->ss_Unread=ior->IOSer.io_Actual;
 return(TRUE);
}

/* Clear serial read buffer */
BOOL ClearSerial(struct SerialStream *stream)
{
 struct IORequest *ior=stream->ss_Cmd;

 /* Execute I/O command */
 ior->io_Command=CMD_CLEAR;
 if (DoIO(ior)) return(FALSE); /* I/O Error */

 return(TRUE);
}

/* Perfomr a synchronous read request */
ULONG ReadSerialSynch(struct SerialStream *stream, void *buf, ULONG buflen)
{
 struct IOStdReq *ior=stream->ss_Read;

 /* Get replied I/O request */
 WaitIO((struct IORequest *) ior);

 /* Send Read request */
 ior->io_Command=CMD_READ;
 ior->io_Data=buf;
 ior->io_Length=buflen;
 DoIO((struct IORequest *) ior);
 return(ior->io_Actual);
}

/* Start an asynchronous read request */
void ReadSerialASynchStart(struct SerialStream *stream, void *buf,
                           ULONG buflen)
{
 struct IOStdReq *ior=stream->ss_Read;

 /* Get replied I/O request */
 WaitIO((struct IORequest *) ior);

 /* Send Read request */
 ior->io_Command=CMD_READ;
 ior->io_Data=buf;
 ior->io_Length=buflen;
 SendIO((struct IORequest *) ior);
}

/* End an asynchronous read request */
ULONG ReadSerialASynchEnd(struct SerialStream *stream)
{
 struct IOStdReq *ior=stream->ss_Read;

 /* Get replied I/O request */
 WaitIO((struct IORequest *) ior);

 /* Return number of bytes read */
 return(ior->io_Actual);
}

/* Perform a synchronous write request */
ULONG WriteSerialSynch(struct SerialStream *stream, void *buf, ULONG buflen)
{
 struct IOStdReq *ior=stream->ss_Write;

 /* Get replied I/O request */
 WaitIO((struct IORequest *) ior);

 /* Init I/O request */
 ior->io_Command=CMD_WRITE;
 ior->io_Data=buf;
 ior->io_Length=buflen;
 DoIO((struct IORequest *) ior);
 return(ior->io_Actual);
}

/* Start an asynchronous write request */
void WriteSerialASynchStart(struct SerialStream *stream, void *buf,
                            ULONG buflen)
{
 struct IOStdReq *ior=stream->ss_Write;

 /* Get replied I/O request */
 WaitIO((struct IORequest *) ior);

 /* Init I/O request */
 ior->io_Command=CMD_WRITE;
 ior->io_Data=buf;
 ior->io_Length=buflen;
 SendIO((struct IORequest *) ior);
}

/* Start an asynchronous write request */
ULONG WriteSerialASynchEnd(struct SerialStream *stream)
{
 struct IOStdReq *ior=stream->ss_Write;

 /* Get replied I/O request */
 WaitIO((struct IORequest *) ior);

 /* Return number of bytes read */
 return(ior->io_Actual);
}

/* Remove an I/O request */
void RemoveIORequest(struct IORequest *ior)
{
 /* No. I/O request still active? Yes --> abort it */
 if (!CheckIO(ior)) AbortIO(ior);

 WaitIO(ior);
}
