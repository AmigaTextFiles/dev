/*
 * ResetHandler.c  V1.0
 *
 * Main program
 *
 * (c) 1991 Stefan Becker
 *
 */
#include "ResetHandler.h"

/* Data */
char Version[]="$VER: ResetHandler V1.0 (27.10.1991)";
char Name[]="ResetHandler V1.0, © 1991 Stefan Becker\n";
char Message[]="System shuts down in X second(s)!";
extern struct GfxBase *GfxBase;
struct Process *MyTask;
struct MsgPort *KeyPort;
struct IOStdReq *kior;
ULONG IntSignal,IntSigMask;
struct Interrupt *MyInt;
struct NewWindow nw={0,0,320,100,0,1,IDCMP_CLOSEWINDOW,WFLG_CLOSEGADGET,NULL,
                     NULL,"Shutdown Requester"};

/* In-Reset routine */
void HandleReset(void)
{
 struct timerequest *tior;
 struct Screen *pubsc;
 struct TextFont *f;
 struct Window *w;
 struct RastPort *rp;
 ULONG sigmask,brkmask;
 UWORD top,fwidth;
 int i;

 /* Create I/O request for the timer.device */
 if (!(tior=CreateIORequest(KeyPort,sizeof(struct timerequest)))) goto hre1;

 /* Open timer.device */
 if (OpenDevice("timer.device",UNIT_MICROHZ,(struct IORequest *) tior,0))
  goto hre2;

 /* Lock default public screen and move it to front */
 if (!(pubsc=LockPubScreen(NULL))) goto hre3;
 ScreenToFront(pubsc);

 /* Calculate window border height */
 if (!(f=OpenFont(pubsc->Font))) goto hre4;
 top=pubsc->WBorTop+f->tf_YSize+2;
 CloseFont(f);

 /* Get system default font */
 f=GfxBase->DefaultFont;
 top+=f->tf_Baseline+30;
 fwidth=f->tf_XSize;

 /* Open Window */
 if (!(w=OpenWindowTags(&nw,WA_Left,pubsc->MouseX-5,
                            WA_Top,pubsc->MouseY-5,
                            WA_InnerHeight,f->tf_YSize+62,
                            WA_InnerWidth,33*fwidth+62,
                            WA_AutoAdjust,TRUE,
                            WA_PubScreen,pubsc,
                            TAG_DONE)))
  goto hre4;
 rp=w->RPort;
 brkmask=(1L<<w->UserPort->mp_SigBit) | SIGBREAKF_CTRL_C;
 sigmask=brkmask | (1L<<KeyPort->mp_SigBit);

 /* Set up rastport */
 SetAPen(rp,1);
 SetDrMd(rp,JAM2);

 /* Shutdown counter loop */
 for (i=9; i>=0; i--)
  {
   ULONG recvsigs;

   /* Send timer request */
   tior->tr_node.io_Command=TR_ADDREQUEST;
   tior->tr_time.tv_secs=1;
   tior->tr_time.tv_micro=0;
   SendIO((struct IORequest *) tior);

   /* Write message */
   Message[21]='0' + i;
   Move(rp,pubsc->WBorLeft+31,top);
   Text(rp,Message,33);

   /* Wait on signals */
   recvsigs=Wait(sigmask);

   /* Received a user break? Yes, do reset */
   if (recvsigs&brkmask)
    {
     /* Abort last timer request */
     AbortIO((struct IORequest *) tior);
     WaitIO((struct IORequest *) tior);

     /* Break loop */
     break;
    }

   /* Remove timer message from port */
   GetMsg(KeyPort);
  }

 /* Free Resources */
      CloseWindow(w);
hre4: UnlockPubScreen(NULL,pubsc);
hre3: CloseDevice((struct IORequest *) tior);
hre2: DeleteIORequest(tior);
hre1: return;
}

/* Cleanup procedure */
void cleanup(int i)
{
 switch(i)
  {
   case 99:
   case  6:FreeMem(MyInt,sizeof(struct Interrupt));
   case  5:CloseDevice((struct IORequest *) kior);
   case  4:FreeSignal(IntSignal);
   case  3:DeleteIORequest(kior);
   case  2:DeleteMsgPort(KeyPort);
   case  1:
   case  0:break;
  }

 if (i!=99) exit(i);
 exit(0);
}

/* Reset Handler code */
__geta4 void ResetHandler(void)
{
 /* Send wake-up signal to main process */
 Signal((struct Task *) MyTask,IntSigMask);
}

/* Main program */
void main(int argc, char *argv[])
{
 BPTR fh;
 struct MsgPort *oldct;
 ULONG recvsigs;

 /* Create message port for keyboard.device */
 if (!(KeyPort=CreateMsgPort())) cleanup(1);

 /* Create I/O request for keyboard.device */
 if (!(kior=CreateIORequest(KeyPort,sizeof(struct IOStdReq)))) cleanup(2);

 /* Get signal for reset handler */
 if ((IntSignal=AllocSignal(-1))==-1) cleanup(3);

 /* Open keyboard.device */
 if (OpenDevice("keyboard.device",0,(struct IORequest *) kior,0)) cleanup(4);

 /* Get memory for interrupt handler node */
 if (!(MyInt=AllocMem(sizeof(struct Interrupt),MEMF_PUBLIC|MEMF_CLEAR)))
  cleanup(5);

 /* Set up data for the reset handler */
 MyTask=FindTask(NULL);
 IntSigMask=1L<<IntSignal;
 MyInt->is_Node.ln_Name=Name;
 MyInt->is_Node.ln_Pri=32;    /* Highest priority */
 MyInt->is_Code=ResetHandler;

 /* Add reset handler */
 kior->io_Data=MyInt;
 kior->io_Command=KBD_ADDRESETHANDLER;
 DoIO((struct IORequest *) kior);

 /* Print banner and detach from console */
 if (fh=Open("CONSOLE:",MODE_NEWFILE))
  {
   FPuts(fh,Name);
   Close(fh);
  }
 fclose(stdout);
 fclose(stdin);
 fclose(stderr);
 oldct=MyTask->pr_ConsoleTask;
 MyTask->pr_ConsoleTask=NULL;

 /* Wait until a reset or a break signal occurs */
 recvsigs=Wait(IntSigMask|SIGBREAKF_CTRL_C);

 /* Got a signal from the reset handler? */
 if (recvsigs&IntSigMask)
  {
   /* Yes, handle reset */
   HandleReset();

   /* Reset handler has completed, system may shut down now */
   kior->io_Data=MyInt;
   kior->io_Command=KBD_RESETHANDLERDONE;
   DoIO((struct IORequest *) kior);
  }

 /* Reinstall old console task */
 MyTask->pr_ConsoleTask=oldct;

 /* Remove reset handler */
 kior->io_Data=MyInt;
 kior->io_Command=KBD_REMRESETHANDLER;
 DoIO((struct IORequest *) kior);

 /* All OK */
 cleanup(99);
}
