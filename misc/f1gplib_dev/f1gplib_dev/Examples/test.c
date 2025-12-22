/*******************************************************************
** Simple example of using "f1gp.library"
*/
#include <exec/types.h>
#include <dos/dos.h>
#include <proto/exec.h>
#include <proto/f1gp.h>
#include <proto/alib.h>
#include <libraries/f1gp.h>

#include <stdlib.h>
#include <stdio.h>

struct F1GPBase *F1GPBase;
struct MsgPort *F1GPPort;


VOID CleanPort(struct MsgPort *msgport)
{
   struct Message *msg;
   while (msg = GetMsg(msgport)) ReplyMsg(msg);
}

BOOL HandleF1GPMessages(VOID)
{
   struct F1GPMessage *msg;
   BOOL running = TRUE;

   while (msg = (struct F1GPMessage *)GetMsg(F1GPPort)) {
      switch (msg->EventType) {
         case F1GPEVENT_QUITGAME:
            printf("F1GP has exited (F1GPEVENT_QUITGAME)\n");
            running = FALSE;
            break;
         case F1GPEVENT_EXITCOCKPIT:
            printf("F1GP has returned to menu system (F1GPEVENT_EXITCOCKPIT)\n");
            break;
      }
      ReplyMsg((struct Message *)msg);
   }

   return(running);
}

int main(int argc, char **argv)
{
   APTR f1gpnotify;
   int i;
   ULONG sigr,sig_f1gp;
   BOOL running = TRUE;

   if (F1GPBase = (struct F1GPBase *)OpenLibrary("f1gp.library",36)) {
      if (F1GPPort = CreatePort(NULL,0)) {

         /*********************
         *** Initialisation ***
         *********************/

         sig_f1gp = 1L << F1GPPort->mp_SigBit;
         if (f1gpnotify = f1gpRequestNotification(F1GPPort,F1GPEVENT_QUITGAME | F1GPEVENT_EXITCOCKPIT)) {

            /****************
            *** Main code ***
            ****************/

            /* Detect if F1GP is currently running or not - IMPORTANT: this call
               will also automatically install all relevant patches */
            if (f1gpDetect()) {
               for (i=0;i<4;i++) printf("Hunk %d: 0x%08x\n",i,F1GPBase->HunkStart[i]);

               printf("F1GP version: %d (see libraries/f1gp.h)\n",F1GPBase->F1GPType);
               printf("Waiting until F1GP quits... (Press Ctrl-C to abort)\n");

               /* Wait for F1GP events of Ctrl-C */
               while (running) {
                  sigr = Wait(sig_f1gp | SIGBREAKF_CTRL_C);
                  if (sigr & sig_f1gp)         running = HandleF1GPMessages();
                  if (sigr & SIGBREAKF_CTRL_C) running = FALSE;
  	       }

               printf("Exiting...\n");
            }
            else {
               printf("F1GP not in memory - won't bother to wait, bye!\n");
            }

            /*************************
            *** Cleanup & Shutdown ***
            *************************/

            f1gpStopNotification(f1gpnotify);
	 }
         else {
            printf("f1gpRequestNotification() failed\n");
	 }
         CleanPort(F1GPPort);
         DeletePort(F1GPPort);

      }
      else {
         printf("Unable to create message port\n");
      }
      CloseLibrary((struct Library *)F1GPBase);
   }
   else {
      printf("Unable to open f1gp.library\n");
   }

   return(0);
}
