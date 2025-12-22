/*
 * yath.c   V0.06 (beta)
 *
 * main tape handler routine
 *
 * (c) 1991/2 by Stefan Becker
 *
 */

#include "yath.h"

struct Library *SysBase,*DOSBase;
struct IOStdReq *ior;
struct SCSICmd *scmd;
UBYTE *command,*sense;
#ifdef DEBUG
struct MsgPort *MonitorPort;
struct MsgPort *MReplyPort;
struct MonitorMessage *MonitorMsg;
#endif

/* Handler main entry point */
__geta4 void HandlerEntry(void)
{
 struct MsgPort *mp;                     /* Handler process ID */
 struct DosList *dn;                     /* Handler device node */
 struct DosPacket *dp;                   /* Pointer to last received packet */
 struct DosList *vn;                     /* Handler volume node */
 ULONG vnbptr;                           /* BPTR to handler volume node */
 struct FileSysStartupMsg *fssm;         /* Filehandler startup parameters */
 struct SCSIStuff *ss;                   /* Memory for SCSI stuff */
 struct MsgPort *iop;                    /* Message Port for IO requests */
 ULONG BytesPB,BufSize,BufType;          /* Size parameters */
 ULONG NumBlocks,BufBlocks,BlocksUsed=0; /* Block parameters */
 BOOL notend=TRUE;                       /* State flags - not ended yet   */
 BOOL open=FALSE;                        /*             - stream opened   */
 BOOL read;                              /*             - read from tape  */
 BOOL inhibit=FALSE;                     /*             - handler blocked */
 UBYTE *Buffer[2],*BufP;                 /* Buffer pointers */
 ULONG BufNum,BufB;                      /* Buffer counters */
 BOOL BufDirty;                          /* Buffer dirty flag */

 /* Initialize ExecBase library pointer */
 SysBase=*((struct Library **) 4);

 /* Open dos.library V36 or better */
 if (!(DOSBase=OpenLibrary(DOSNAME,36))) return;

 /* Get process parameters */
 mp=&((struct Process *) FindTask(NULL))->pr_MsgPort;

 /* Get handler startup packet */
 WaitPort(mp);
 dp=(struct DosPacket *) GetMsg(mp)->mn_Node.ln_Name;

 /* Got a startup message? */
 if (!(fssm=(struct FileSysStartupMsg *) BADDR(dp->dp_Arg2))) goto e1;

 /* Allocate memory for SCSI stuff */
 if (!(ss=AllocMem(sizeof(struct SCSIStuff),MEMF_PUBLIC|MEMF_CLEAR))) goto e1;

 /* Open device */
 if (!(iop=CreateMsgPort())) goto e2;
 if (!(ior=CreateIORequest(iop,sizeof(struct IOStdReq)))) goto e3;
 if (OpenDevice((char *) BADDR(fssm->fssm_Device)+1,fssm->fssm_Unit,
                (struct IORequest *) ior,fssm->fssm_Flags))
  goto e4;

 /* Set up SCSI stuff */
 scmd=&ss->scmd;
 command=ss->command;
 sense=ss->sense;
 ior->io_Command=HD_SCSICMD;
 ior->io_Data=(APTR) scmd;
 ior->io_Length=sizeof(struct SCSICmd);
 ss->scmd.scsi_Command=command;
 ss->scmd.scsi_CmdLength=6;
 ss->scmd.scsi_CmdActual=6;
 ss->scmd.scsi_SenseData=sense;
 ss->scmd.scsi_SenseLength=SENSELEN;

 /* Calculate size parameters */
 {
  ULONG *env=BADDR(fssm->fssm_Environ);

  BytesPB=4*env[DE_SIZEBLOCK];
  BufBlocks=env[DE_NUMBUFFERS];
  BufSize=BytesPB*BufBlocks;
  BufType=env[DE_BUFMEMTYPE];
  NumBlocks=env[DE_NUMHEADS]*env[DE_BLKSPERTRACK]*
            (env[DE_UPPERCYL]-env[DE_LOWCYL]+1);
 }

 /* Set up device node */
 dn=(struct DosList *) BADDR(dp->dp_Arg3);
 dn->dol_Task=mp;

 /* Set up volume node */
 if (vn=MakeDosEntry("Streamer Tape",DLT_VOLUME))
  {
   vn->dol_Task=mp;
   DateStamp(&vn->dol_misc.dol_volume.dol_VolumeDate);
   vn->dol_misc.dol_volume.dol_DiskType=ID_DOS_DISK;
   if (!AddDosEntry(vn))
    {
     FreeDosEntry(vn);
     vn=NULL;
    }
  }
 vnbptr=MKBADDR(vn);

 /* Got all resources, reply startup packet */
 ReplyPkt(dp,DOSTRUE,dp->dp_Res2);

#ifdef DEBUG
 MonitorPort=NULL; /* default: No debug monitor */
#endif

 /* Handler main event loop */
 while (notend)
  {
   struct Message *msg;

   /* Wait for next packet */
   WaitPort(mp);

   /* Retrieve & process all packets */
   while (msg=GetMsg(mp))
    {
     dp=(struct DosPacket *) msg->mn_Node.ln_Name;

     switch(dp->dp_Type)
      {
       case ACTION_FINDINPUT:  /* Open stream for reading an existing file */
       case ACTION_FINDOUTPUT: /* Open stream for writing a new file */
       case ACTION_FINDUPDATE: /* Open stream for writing to an existing file */
        if (open || inhibit || !notend)
         ReplyPkt(dp,DOSFALSE,ERROR_OBJECT_IN_USE);
        else
         {
          BOOL openerr=TRUE;

          /* Allocate memory for buffers */
          if (Buffer[0]=AllocMem(BufSize,BufType))
           if (Buffer[1]=AllocMem(BufSize,BufType))
            openerr=FALSE;
           else
            FreeMem(Buffer[0],BufSize);

          /* Got all needed memory? */
          if (openerr)
           ReplyPkt(dp,DOSFALSE,ERROR_NO_FREE_STORE);
          else
           {
            /* Eat up first sense data */
            DoSCSICmd(SCSI_SENSE,0,0,0);

            /* Special file name detection */
            {
             char *bstr=BADDR(dp->dp_Arg3);

             /* Valid BCPL string? */
             if (bstr)
              {
               ULONG len=*bstr++; /* BCPL length byte */
               char *cstr;

               /* Get memory for C string */
               if (len && (cstr=AllocMem(len+1,MEMF_CLEAR)))
                {
                 char *cp;

                 strncpy(cstr,bstr,len); /* Copy BCPL string */

                 /* Search end of device name, End of string reached? */
                 if ((cp=strchr(cstr,':')) && (*++cp!='\0'))
                  /* No, special file name detected */
                  switch(*cp)
                   {
                    case '*': /* <dev>:*<n>  Skip <n> File Marks */
                     LONG n=strtol(cp+1,&cp,10); /* Read number */

                     /* Valid value? Yes, issue SCSI Space command */
                     if (n!=0) DoSCSICmd(SCSI_SPACE,n,0,0);
                     break;

                    default:  /* Not recognized file name */
                     break;
                   }

                 FreeMem(cstr,len+1); /* Free memory */
                }
              }
            }

            /* Read from or write to tape? */
            if (read=dp->dp_Type==ACTION_FINDINPUT)
             {
              /* Read from tape. Read first buffer */
              if (openerr=DoSCSICmd(SCSI_READ,(ULONG) Buffer[0],BufSize,
                                    BufBlocks))
               {
                /* An error occured, close stream */
                FreeMem(Buffer[0],BufSize);
                FreeMem(Buffer[1],BufSize);
                ReplyPkt(dp,DOSFALSE,openerr);
                break;
               }

              /* Set pointers & counters */
              BufNum=1;
              BufP=Buffer[1];
              BufB=0;
             }
            else
             {
              /* Write to tape. Set pointers & counters */
              BufNum=0;
              BufP=Buffer[0];
              BufB=BufSize;
             }

            /* Stream opened */
#ifdef DEBUG
            /* Create debug message reply port */
            if (MReplyPort=CreateMsgPort())
             {
              /* Create debug message */
              if (MonitorMsg=AllocMem(sizeof(struct MonitorMessage),
                                      MEMF_CLEAR|MEMF_PUBLIC))
               {
                /* Initialize debug message */
                MonitorMsg->mm_msg.mn_ReplyPort=MReplyPort;
                MonitorMsg->mm_msg.mn_Length=sizeof(struct MonitorMessage);

                /* Find debug monitor */
                Forbid();         /* Singletasking */
                if (MonitorPort=FindPort(MPORTNAME)) /* Search monitor port */
                 MONITOR(YATH_OPEN,read,0);
                Permit();         /* Multitasking */

                /* Debug monitor found? */
                if (!MonitorPort)
                 {
                  /* No, free resources */
                  FreeMem(MonitorMsg,sizeof(MonitorMsg));
                  DeleteMsgPort(MReplyPort);
                 }
               }
              else DeleteMsgPort(MReplyPort);
             }
#endif
            open=TRUE;
            BufDirty=FALSE;
            ReplyPkt(dp,DOSTRUE,dp->dp_Res2);
           }
         }
        break;

       case ACTION_END: /* Close stream */
        if (!open)
         ReplyPkt(dp,DOSFALSE,ERROR_ACTION_NOT_KNOWN);
        else
         {
          /* Flush Buffers */
          if (BufDirty) DoSCSICmd(SCSI_WRITE,(ULONG) Buffer[BufNum],BufSize,
                                  BufBlocks);

          /* Write file end mark to tape */
          if (!read) DoSCSICmd(SCSI_WEOFM,0,0,0);

          /* Free buffer memory */
          FreeMem(Buffer[0],BufSize);
          FreeMem(Buffer[1],BufSize);

          /* Stream closed */
          MONITOR(YATH_CLOSE,0,0);
#ifdef DEBUG
          if (MonitorPort)
           {
            FreeMem(MonitorMsg,sizeof(struct MonitorMessage));
            DeleteMsgPort(MReplyPort);
            MonitorPort=NULL;
           }
#endif
          open=FALSE;
          ReplyPkt(dp,DOSTRUE,dp->dp_Res2);
         }
        break;

       case ACTION_READ: /* Read from stream */
        if (!open || !read)
         ReplyPkt(dp,DOSFALSE,ERROR_ACTION_NOT_KNOWN);
        else
         {
          UBYTE *dstp=(UBYTE *) dp->dp_Arg2; /* Destination pointer */
          ULONG dstb=dp->dp_Arg3;            /* Number of bytes to read */
          ULONG act=0;                       /* Number of bytes read */
          LONG err=0;                        /* Error flag */

          MONITOR(YATH_READ,dstb,0);

          /* Read all bytes */
          while (dstb)
           /* Number of bytes to read < Number of bytes in buffer? */
           if (dstb<BufB)
            {
             /* Yes, copy from buffer (not empty yet) */
             memcpy(dstp,BufP,dstb);

             /* Correct pointers & counters */
             act+=dstb;
             BufP+=dstb;
             BufB-=dstb;
             dstb=0;
            }
           else
            {
             /* No, empty buffer and read from tape */
             memcpy(dstp,BufP,BufB);

             /* Issue SCSI read command */
             if (err=DoSCSICmd(SCSI_READ,(ULONG) Buffer[BufNum],BufSize,
                               BufBlocks))
              break;

             /* Correct pointers & counters */
             BlocksUsed+=BufBlocks;
             act+=BufB;
             dstp+=BufB;
             dstb-=BufB;

             /* Swtich to filled buffer */
             BufNum^=1;
             BufP=Buffer[BufNum];
             BufB=BufSize;
            }

          /* Did an error occur? */
          if (err)
           act=DOSTRUE;
          else
           err=dp->dp_Res2;

          ReplyPkt(dp,act,err);
         }
        break;

       case ACTION_WRITE: /* Write to stream */
        if (!open || read)
         ReplyPkt(dp,DOSFALSE,ERROR_ACTION_NOT_KNOWN);
        else
         {
          UBYTE *srcp=(UBYTE *) dp->dp_Arg2; /* Source pointer */
          ULONG srcb=dp->dp_Arg3;            /* Number of bytes to write */
          ULONG act=0;                       /* Number of bytes written */
          LONG err=0;                        /* Error flag */

          MONITOR(YATH_WRITE,srcb,0);

          /* Write all bytes */
          while (srcb)
           /* Number of bytes to write < Number of free bytes in buffer? */
           if (srcb<BufB)
            {
             /* Yes, copy into buffer (not filled yet) */
             memcpy(BufP,srcp,srcb);

             /* Correct pointers & counters */
             act+=srcb;
             BufP+=srcb;
             BufB-=srcb;
             srcb=0;

             /* We've written to the buffer, but not saved it yet */
             BufDirty=TRUE;
            }
           else
            {
             /* No, fill buffer and write it to tape */
             memcpy(BufP,srcp,BufB);

             /* Issue SCSI write command */
             if (err=DoSCSICmd(SCSI_WRITE,(ULONG) Buffer[BufNum],BufSize,
                               BufBlocks))
              break;
             BufDirty=FALSE; /* Buffer saved */

             /* Correct pointers & counters */
             BlocksUsed+=BufBlocks;
             act+=BufB;
             srcp+=BufB;
             srcb-=BufB;

             /* Switch to empty buffer */
             BufNum^=1;
             BufP=Buffer[BufNum];
             BufB=BufSize;
            }

          /* Did no error occur? */
          if (!err) err=dp->dp_Res2;

          ReplyPkt(dp,act,err);
         }
        break;

       case ACTION_SEEK: /* Seek is not allowed on a tape! */
        ReplyPkt(dp,(ULONG) -1,ERROR_ACTION_NOT_KNOWN);
        break;

       case ACTION_CURRENT_VOLUME: /* Retrieve current volume */
        if (notend)
         ReplyPkt(dp,vnbptr,fssm->fssm_Unit);
        else
         ReplyPkt(dp,DOSFALSE,ERROR_OBJECT_IN_USE);
        break;

       case ACTION_DISK_INFO: /* Retreive InfoData */
        if (notend)
         {
          struct InfoData *id=BADDR(dp->dp_Arg1);

          id->id_NumSoftErrors=0;
          id->id_UnitNumber=fssm->fssm_Unit;
          id->id_DiskState=ID_VALIDATED;
          id->id_NumBlocks=NumBlocks;
          id->id_NumBlocksUsed=BlocksUsed;
          id->id_BytesPerBlock=BytesPB;
          id->id_DiskType=inhibit?ID_BUSY:ID_DOS_DISK;
          id->id_VolumeNode=vnbptr;
          id->id_InUse=open?DOSTRUE:DOSFALSE;

          ReplyPkt(dp,DOSTRUE,dp->dp_Res2);
         }
        else
         ReplyPkt(dp,DOSFALSE,ERROR_OBJECT_IN_USE);
        break;

       case ACTION_INHIBIT: /* Inhibit handler */
        if (dp->dp_Arg1==DOSTRUE)
         if (open || !notend)
          {
           ReplyPkt(dp,DOSFALSE,ERROR_OBJECT_IN_USE);
           break;
          }
         else
          {
           /* Rewind tape */
           DoSCSICmd(SCSI_SENSE,0,0,0);
           DoSCSICmd(SCSI_REWND,0,0,0);

           /* Reset block counter */
           BlocksUsed=0;

           inhibit=TRUE;
          }
        else
         inhibit=FALSE;
        ReplyPkt(dp,DOSTRUE,dp->dp_Res2);
        break;

       case ACTION_FLUSH: /* Flush buffers, stop motor */
        if (open)
         {
          MONITOR(YATH_FLUSH,0,0);

          /* Flush buffers */
          if (BufDirty)
           {
            DoSCSICmd(SCSI_WRITE,(ULONG) Buffer[BufNum],BufSize,BufBlocks);
            BufDirty=FALSE;
           }

          ReplyPkt(dp,DOSTRUE,dp->dp_Res2);
         }
        else
         ReplyPkt(dp,DOSFALSE,ERROR_ACTION_NOT_KNOWN);
        break;

       case ACTION_DIE: /* Shut down handler */
        if (open || inhibit)
         ReplyPkt(dp,DOSFALSE,ERROR_OBJECT_IN_USE);
        else
         {
          notend=FALSE;
          /* Reply packet AFTER freeing all resources! */
         }
        break;

       default: /* Unknown ACTION --> error */
        ReplyPkt(dp,DOSFALSE,ERROR_ACTION_NOT_KNOWN);
        break;
      }
    }
  }

 /* Clear process ID in device node */
 dn->dol_Task=NULL;

 /* Remove volume node */
 if (vn)
  {
   LockDosList(LDF_VOLUMES|LDF_WRITE);
   RemDosEntry(vn);
   UnLockDosList(LDF_VOLUMES|LDF_WRITE);
   FreeDosEntry(vn);
  }

 /* Wait until last I/O request is finished, then close device */
 DoSCSICmd(SCSI_WAIT,0,0,0);
 CloseDevice((struct IORequest *) ior);

 /* Free resources */
e4: DeleteIORequest(ior);
e3: DeleteMsgPort(iop);
e2: FreeMem(ss,sizeof(struct SCSIStuff));
e1: if (notend) /* Error or normal (ACTION_DIE) termination? */
     ReplyPkt(dp,DOSFALSE,ERROR_NO_FREE_STORE); /* Error */
    else /* normal termination */
     {
      Forbid(); /* Prevent UnLoadSeg() before exiting!! */
      ReplyPkt(dp,DOSTRUE,dp->dp_Res2); /* reply ACTION_DIE packet */
     }
    CloseLibrary(DOSBase);
    return;
}

/* Version string. MUST be behind handler entry!! */
const char ident[]=YATH_VERSION;

/* Issue a SCSI command */
LONG DoSCSICmd(WORD action, ULONG parm1, ULONG parm2, ULONG parm3)
{
 static busy=FALSE;

 /* Is a SCSI command busy? */
 if (busy)
  {
   /* Yes, wait until it finished */
   WaitIO((struct IORequest *) ior);

   /* Not busy any more */
   busy=FALSE;

   /* If an error occured, return */
   if (ior->io_Error)
    {
     MONITOR(YATH_IOERR,ior->io_Error,scmd->scsi_Status);
     return(ior->io_Error<<8+scmd->scsi_Status);
    }
  }

 /* SCSI_WAIT is a dummy command */
 if (action==SCSI_WAIT) return(0);

 /* Initialize SCSI parameters */
 switch(action)
  {
   case SCSI_READ:
    command[0]=0x08;
    command[1]=1;
    command[2]=(parm3>>16)&0xff;
    command[3]=(parm3>>8)&0xff;
    command[4]=parm3&0xff;
    scmd->scsi_Data=(UWORD *) parm1;
    scmd->scsi_Length=parm2;
    scmd->scsi_Flags=SCSIF_READ|SCSIF_AUTOSENSE;
    busy=TRUE;
    break;
   case SCSI_WRITE:
    command[0]=0x0A;
    command[1]=1;
    command[2]=(parm3>>16)&0xff;
    command[3]=(parm3>>8)&0xff;
    command[4]=parm3&0xff;
    scmd->scsi_Data=(UWORD *) parm1;
    scmd->scsi_Length=parm2;
    scmd->scsi_Flags=SCSIF_WRITE|SCSIF_AUTOSENSE;
    busy=TRUE;
    break;
   case SCSI_WEOFM:
    command[0]=0x10;
    command[1]=0;
    command[2]=0;
    command[3]=0;
    command[4]=1;
    scmd->scsi_Length=0;
    scmd->scsi_Flags=SCSIF_AUTOSENSE;
    break;
   case SCSI_REWND:
    command[0]=0x01;
    command[1]=0;
    command[2]=0;
    command[3]=0;
    command[4]=0;
    scmd->scsi_Length=0;
    scmd->scsi_Flags=SCSIF_AUTOSENSE;
    busy=TRUE;
    break;
   case SCSI_SENSE:
    command[0]=0x3;
    command[1]=0;
    command[2]=0;
    command[3]=0;
    command[4]=SENSELEN;
    scmd->scsi_Data=sense;
    scmd->scsi_Length=0;
    scmd->scsi_Flags=SCSIF_READ|SCSIF_AUTOSENSE;
    break;
   case SCSI_SPACE:
    command[0]=0x11;
    command[1]=1;
    command[2]=(parm1>>16)&0xff;
    command[3]=(parm1>>8)&0xff;
    command[4]=parm1&0xff;
    scmd->scsi_Length=0;
    scmd->scsi_Flags=SCSIF_AUTOSENSE;
    busy=TRUE;
    break;
  }

 /* Initialize I/O request */
 ior->io_Error=0;
 MONITOR(YATH_SCSI,command[0],busy);

 /* What type of I/O operation? */
 if (busy)
  {
   /* Asynchronous I/O */
   ior->io_Flags=IOF_QUICK;
   BeginIO((struct IORequest *) ior);

   /* I/O error? */
   if (ior->io_Error)
    {
     busy=FALSE;
     MONITOR(YATH_IOERR,ior->io_Error,scmd->scsi_Status);
     return(ior->io_Error<<8+scmd->scsi_Status);
    }

   /* Command already executed? */
   if (ior->io_Flags&IOF_QUICK) busy=FALSE;
  }
 else
  {
   /* Synchronous I/O */
   DoIO((struct IORequest *) ior);

   /* I/O error? */
   if (ior->io_Error)
    {
     MONITOR(YATH_IOERR,ior->io_Error,scmd->scsi_Status);
     return(ior->io_Error<<8+scmd->scsi_Status);
    }
  }

 /* No error */
 return(0);
}

#ifdef DEBUG
/* Send a message to the debug monitor */
void SendMonitor(ULONG cmd, ULONG arg1, ULONG arg2)
{
 /* Set message values */
 MonitorMsg->mm_cmd=cmd;
 MonitorMsg->mm_arg1=arg1;
 MonitorMsg->mm_arg2=arg2;

 /* Send message to monitor */
 PutMsg(MonitorPort,(struct Message *) MonitorMsg);

 /* Wait on reply */
 WaitPort(MReplyPort);

 /* Retreive reply from port */
 GetMsg(MReplyPort);
}
#endif
