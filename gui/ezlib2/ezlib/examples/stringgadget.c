/* This program demonstrates the boolean gadget functions of EzLib.
 * We open a window, add a few gadgets, let the user play with them,
 * then quit.
 *
 * If you want an integer gadget instead of a string gadget, just use
 * MakeIntGadget() instead (it has the exact same calling sequence).
 * If you use MakeIntGadget(), try to be smart and make sure the default
 * string really has numbers in it.  Things work otherwise, but it can
 * be a little strange for the user.
 *
 *   Dominic Giampaolo
 */
#include "inc.h"         /* get all the amiga includes needed */

#include <ezlib.h>


void main(void)
{
  struct Window *win;
  struct Gadget *str_gadg, *gadg;
  struct StringInfo *sinfo;
  struct IntuiMessage *msg;
  ULONG flags, idcmp;
  SHORT l_edge, t_edge, keep_going = TRUE;

  flags = WINDOWDRAG | WINDOWCLOSE | WINDOWDEPTH | ACTIVATE;

  /* notice the ACTIVEWINDOW message is selected so that we can
   * turn on the string gadget whenever our window is active.
   */
  idcmp = CLOSEWINDOW | GADGETUP | ACTIVEWINDOW;

  /* create a full screen window */
  win = CreateWindow(NULL, 0,0, 320,100, flags, idcmp);
  if (win == NULL)
    {
       MSG("Couldn't open window.\n");
       exit(10);
    }
  SetWindowTitles(win, "EzLib String Gadgets", (char *)-1);

  l_edge = win->BorderLeft + 10;
  t_edge = win->BorderTop + (2*win->RPort->TxHeight);

  str_gadg = MakeStringGadget(win, l_edge, t_edge, 200, "Default text", 1);
  if (str_gadg == NULL)
    {
       KillWindow(win);
       MSG("Error creating string gadget.\n");
       exit(11);
    }

  /* now our display is set up, so lets get to the main loop */
  while(keep_going)
   {
     WaitPort(win->UserPort);
     while((msg = (struct IntuiMessage *)GetMsg(win->UserPort)) != NULL)
       {
	 switch(msg->Class)
	   {
	      case ACTIVEWINDOW : ActivateGadget(str_gadg, win, NULL);
				  break;

	      case GADGETUP : gadg  = (struct Gadget *)msg->IAddress;
			      sinfo = (struct StringInfo *)gadg->SpecialInfo;

			      if (gadg->GadgetID == 1)  /* string gadget */
			       {
				 MSG("You typed : ");
				 MSG(sinfo->Buffer);
				 MSG("\n");
			       }
			      break;

	      case CLOSEWINDOW : keep_going = FALSE;
				 break;

	      default : break;

	   }

	 ReplyMsg((struct Message *)msg);
      }
   }

  KillGadget(win, str_gadg);
  KillWindow(win);
  exit(0);
}



