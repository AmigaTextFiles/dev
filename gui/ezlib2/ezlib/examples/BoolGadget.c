/* This program demonstrates the boolean gadget functions of EzLib.
 * We open a window, add a few gadgets, let the user play with them,
 * then quit.
 *
 *   Dominic Giampaolo
 */
#include "inc.h"         /* get all the amiga includes needed */
#include <ezlib.h>

/* protos */
void print_msg(struct Window *win, char *string);



void main(void)
{
  struct Window *win;
  struct Gadget *button1, *button2, *gadg;
  struct IntuiMessage *msg;
  ULONG flags, idcmp;
  SHORT l_edge, t_edge, keep_going = TRUE;

  flags = WINDOWDRAG | WINDOWCLOSE | WINDOWDEPTH | ACTIVATE;
  idcmp = CLOSEWINDOW | GADGETUP;

  /* create a full screen window */
  win = CreateWindow(NULL, 0,0, -1,-1, flags, idcmp);
  if (win == NULL)
    {
       MSG("Couldn't open window.\n");
       exit(10);
    }

  l_edge = win->BorderLeft + 10;
  t_edge = win->BorderTop + (2*win->RPort->TxHeight);

  button1 = MakeBoolGadget(win, l_edge, t_edge, "EzLib Gadget", 1);
  if (button1 == NULL)
    {
       KillWindow(win);
       MSG("Error creating gadget.\n");
       exit(11);
    }

  t_edge += button1->Height + 10;

  button2 = MakeToggleGadget(win, l_edge, t_edge, "EzLib Toggle", 2);
  if (button2 == NULL)
    {
      KillGadget(win, button1);
      KillWindow(win);
      MSG("Couldn't make toggle gadget\n");
      exit(12);
    }


   /* now our display is set up, so lets get to the main loop */
   while(keep_going)
    {
      WaitPort(win->UserPort);
      while((msg = (struct IntuiMessage *)GetMsg(win->UserPort)) != NULL)
       {
	  switch(msg->Class)
	    {
	      case GADGETUP : gadg = (struct Gadget *)msg->IAddress;

			      if(gadg->GadgetID == 1)  /* button1 */
				print_msg(win, "You Clicked Button1");
			      else if (gadg->GadgetID == 2)
				print_msg(win, "You clicked Button2 (a toggle)");
			      else
				print_msg(win, "I don't know what happened");
			      break;

	      case CLOSEWINDOW : keep_going = FALSE;
				 break;

	      default : break;

	    }

	  ReplyMsg((struct Message *)msg);
       }
    }

  KillGadget(win, button1);
  KillGadget(win, button2);
  KillWindow(win);
  exit(0);
}


/* this is a particularly stupid function that prints messages in a
 * window a hard coded location.
 */
void print_msg(struct Window *win, char *string)
{
  if (win == NULL || string == NULL)
    return;

  /* clear the old message area */
  SetAPen(win->RPort, 0);
  RectFill(win->RPort, 320,win->BorderTop+5, win->Width-win->BorderRight, 100);

  SetAPen(win->RPort, 1);
  Move(win->RPort, 320, win->BorderTop+win->RPort->TxHeight*2);
  Print(win->RPort, string);
}
