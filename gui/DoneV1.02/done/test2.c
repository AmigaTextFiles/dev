/*
** Test2.c By Stuart Kelly
**
** Version: 1.02 - Example of How to use Done1.02 
** This example shows how you can detect if the user presses the abort
** button.
** You may change this code and alter it for your own programs.
**
** You MAY NOT change done.h and done.o in any way without
** written permission from the author.
*/
#include <stdio.h>
#include <dos/dostags.h>
#include <clib/dos_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/utility_protos.h>
#include "done.h"

/* define some varibles */

/* change GD_AbortID to GD_Abort because GD_Abort takes less time to type */
#define GD_Abort GD_AbortID

struct Window *TheWnd;

int quit_a = 0;

#define VERSION_STR "Test2 V 1.02 By Stuart Kelly Uses Done V 1.02"

char *version = VERSION_STR;

void main(void)
{
 struct IntuiMessage *imsg;
 struct IntuiMessage *imsg_copy;
 struct Gadget *gad;
 BOOL quit_now = FALSE;

 int a=0;

 printf(" Test2 By Stuart Kelly Copyright 1996 ©\n");
 printf(" Uses %s \n", DONE_VERSION_A);
 printf(" Press Return To Continue -> ");
 getchar(); 

 ST_WorkReq(NULL);

 TheWnd = ST_GetWindow();

 if (TheWnd == NULL) { ST_FreeWorkReq();
                      printf(" Window Fail\n");
                      printf(" ARRRRR\n");
                      return; }

  while ( !quit_now )
  {
  Wait(1L << TheWnd->UserPort->mp_SigBit);

  while (imsg = GT_GetIMsg(TheWnd->UserPort))
   {
    imsg_copy = imsg;
    GT_ReplyIMsg(imsg); /* reply after we copy imsg */
   
    gad = (struct Gadget *)imsg_copy->IAddress;
    switch(imsg_copy->Class)
     {
     case IDCMP_INACTIVEWINDOW:

      /* window not active , intuiticks wont work  so activate window */
      ActivateWindow(TheWnd);

     break;
     case IDCMP_INTUITICKS:

      ST_SetDone(a);
 
      a=a+1;

      if (a == ALL_DONE) {
                          ST_SetDone(ALL_DONE);
                          quit_now = TRUE;
                          printf(" Didn't Abort\n");
                          }

     break; /* so that we can check if quit_a < 3*/
     case IDCMP_GADGETUP:
      switch(gad->GadgetID)
       {
       case GD_Abort: quit_now = TRUE;
        printf(" You Aborted\n");
       break;
       default: break;
       }
     break;
     default: break;
     } /* switch imsg */

     /* reply here, but don't have to as we use a copy of imsg */
   } /* while imsg = */

  } /* while ! quit_now */

 ST_FreeWorkReq();

}
