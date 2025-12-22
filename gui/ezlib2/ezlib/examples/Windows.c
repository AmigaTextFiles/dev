/* This program demonstrates the EzLib window manipulation routines.
 *
 * We open various windows with different attributes and draw something
 * in each.
 *
 *   Dominic Giampaolo
 */
#include "inc.h"         /* get all the amiga includes needed */
#include <ezlib.h>

#define IMSG struct IntuiMessage



void main(void)
{
  struct Window   *win;
  struct RastPort *rp;
  struct IntuiMessage *msg;
  ULONG flags, idcmp;
  int	keep_going = TRUE;

  /* make our first and simplest window */
  win = MakeWindow(NULL, 0,0, 320, 100);
  if (win == NULL)
    {
       MSG("Trouble making first window!\n");
       exit(10);
    }

  /* set the window title */
  SetWindowTitles(win, "EzLib MakeWindow() Example", (char *)-1);

  rp = win->RPort;
  Move(rp, win->BorderLeft+10, win->BorderTop + 2*rp->TxHeight);
  Print(rp, "Click The Close Gadget");

  /* since we only get close window messages on this window, we can
   * just wait, then call KillWindow()
   */
  WaitPort(win->UserPort);
  KillWindow(win);


  /* now make a window with only a titlebar and closegadget,
   * and VANILLAKEY messages
   */
  flags = WINDOWDRAG | WINDOWCLOSE | ACTIVATE;
  idcmp = CLOSEWINDOW | VANILLAKEY;
  win = CreateWindow(NULL, 320,0, 320,100, flags, idcmp);
  if (win == NULL)
   {
     MSG("Trouble making second window.\n");
     exit(11);
   }
  SetWindowTitles(win, "EzLib CreateWindow() Example", (char *)-1);

  rp = win->RPort;
  Move(rp, win->BorderLeft + 10, win->BorderTop + 2*rp->TxHeight);
  Print(rp, "Press some keys, then close window");


  /* now we have to have a mini main loop */
  while(keep_going)
   {
     WaitPort(win->UserPort);
     while((msg = (IMSG *)GetMsg(win->UserPort)) != NULL)
      {
	switch(msg->Class)
	 {
	   case VANILLAKEY : printf("You typed : %c\n", (char)msg->Code);
			     break;

	   case CLOSEWINDOW : printf("You clicked the close window gadget\n");
			      keep_going = FALSE;
			      break;

	   default : break;
	 }    /* end of switch(msg->Class) */

	ReplyMsg((struct Message *)msg);
      }    /* end of while(msg)... */
   }	/* end of while(keep_going) */

  KillWindow(win);

  printf("That's all folks!\n");
  exit(0);
}
