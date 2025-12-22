/* This program is a simple demonstration of almost all of the EzLib
 * gadget types.  String (integer), Prop, Boolean, Image, and Toggle
 * gadgets are all here.
 *
 *  There is a little bit of layout code in here so that gadgets don't
 * step over each other, but I tried to keep it minimal so as not to
 * obscure the code.
 *
 *  If you want to see how to make a certain type of gadget, grab
 * the code here and manipulate it to your needs.
 *
 *   Dominic Giampaolo
 */
#include "inc.h"         /* get all the amiga includes needed */

#include <ezlib.h>
#include "arrows.c"

/* forward declarations */
void doit();
void doit2();

/* we declare it as extern because it is declared inside of EzLib */
extern struct GfxBase *GfxBase;

struct Gadget *prop, *prop2;

void main(void)
{
 struct Window *win;
 struct Gadget *gadg;
 struct Gadget *button1, *button2, *button3, *button4;
 struct Gadget *numgadg;
 struct IntuiMessage  *msg;

 SHORT l_edge, t_edge, width, height;
 int  counter1 = 0, counter2 = 0;
 BYTE old_pen;


 if (OpenLibs(GFX|INTUI) == NULL)
   exit(100);

 win = MakeWindow(NULL, 0, 0, GfxBase->NormalDisplayColumns, GfxBase->NormalDisplayRows);
 if (win == NULL)
   exit(10);

 ModifyIDCMP(win, CLOSEWINDOW|GADGETUP|GADGETDOWN|NEWSIZE);

 l_edge = win->BorderLeft + 5;
 t_edge = win->BorderTop  + 5;
 width	= 20;
 height = 120;
 prop = (struct Gadget *)MakePropGadget(win,     /* window gadget goes in */
					l_edge, t_edge,  /* left edge, top edge   */
					width,	height,  /* width, height	  */
					FREEVERT,/* FREEVERT or FREEHORIZ */
					45);	 /* Gadget ID		  */
 if (prop == NULL)
   { KillWindow(win); exit(10); }

  /* set up prop gadget limits */
 SetPropGadg(win,   /* window of gadget */
	     prop,  /* the gadget we are talking about */
	     0,     /* top, i.e. where top of knob should be */
	     4,     /* displayed, i.e. how big body is */
	     32);   /* max, i.e. total amount gadget is representing */


 /* This is how to do a nice right hand side scroll bar.  It assumes that
  * you have a sizing gadget in your window.
  *
  * This acted funny under early versions of 2.0 (it overwrote the sizing
  * gadget), but I have no idea why, as the numbers appear to be correct.
  */
 l_edge = -win->BorderRight + 3;
 t_edge =  win->BorderTop;
 width	=  win->BorderRight - 2;
 height = -win->BorderRight - 2;
 prop2 = (struct Gadget *)MakeVertProp(win,       /* window gadget goes in */
				       l_edge,	  /* left edge */
				       t_edge,	  /* top edge  */
				       width,	  /* width     */
				       height,	  /* height    */
				       GRELRIGHT|GRELHEIGHT,	 /* gadget flags      */
				       RELVERIFY|GADGIMMEDIATE,  /* gadget activation */
				       46);		     /* gadget ID */
 if (prop2 == NULL)
   { KillGadget(win, prop); KillWindow(win); exit(20); }
 SetPropGadg(win, prop2, 25, 1, 50);

 l_edge = 100;
 t_edge = win->BorderTop + 5;
 button1 = MakeBoolGadget(win, l_edge, t_edge, "Tastes Great", 47);
 if (button1 == NULL)
   { KillGadget(win, prop); KillGadget(win,prop2); KillWindow(win); exit(30); }

 l_edge = 100;
 t_edge = button1->TopEdge + button1->Height + 20;
 button2 = MakeToggleGadget(win, l_edge, t_edge, "Less Filling", 48);
 button3 = MakeImgGadget(win, 70, 60, &arrow1, NULL, 49);
 button4 = MakeImgToggle(win, 70, 80, &arrow2, &arrow1, 50);
 numgadg = MakeIntGadget(win, 100,100, 100, "543", 51);

 if (button2 == NULL || button3 == NULL || button4 == NULL)
  {
    KillGadget(win, prop);       /* remember, KillGadget() handles NULLs */
    KillGadget(win, prop2);
    KillGadget(win, button1);
    KillGadget(win, button2);
    KillGadget(win, button3);
    KillGadget(win, button4);
    KillWindow(win);
    exit(30);
  }

 doit(win,  &counter1, GetPropValue(prop));   /* set up first time */
 doit2(win, &counter2, GetPropValue(prop2));

 while(1)
  {
    WaitPort(win->UserPort);

    while((msg = (struct IntuiMessage *)GetMsg(win->UserPort)) != NULL)
     {
       switch(msg->Class)
	{
	  case GADGETDOWN: gadg = (struct Gadget *)msg->IAddress;

			   if (gadg->GadgetID == 45)
			    {
			      RealtimeProp(win,  /* window of gadget */
					    prop, /* which gadget     */
					    doit, /* function to be called */
					    &counter1); /* data pointer to pass to above function when called */
			    }
			   else if (gadg->GadgetID == 46)
			     RealtimeProp(win, prop2, doit2, &counter2);
			   else if (gadg->GadgetID == 48)
			     printf("You clicked the 'Less Filling' button\n");
			   else if (gadg->GadgetID == 50)
			     printf("You clicked the arrow toggle\n");
			   break;

	  case GADGETUP  : gadg = (struct Gadget *)msg->IAddress;
			   if (gadg->GadgetID == 45)
			     doit(win, &counter1, GetPropValue(gadg));
			   else if (gadg->GadgetID == 46)
			     doit2(win, &counter2, GetPropValue(gadg));
			   else if (gadg->GadgetID == 47)
			     printf("You clicked the 'Tastes Great' Button\n");
			   else if (gadg->GadgetID == 49)
			     printf("You clicked the up arrow button\n");
			   else if (gadg->GadgetID == 51)
			     printf("You just typed a number\n");
			   break;

	  case NEWSIZE	 : old_pen = win->RPort->FgPen;
			   SetAPen(win->RPort, win->RPort->BgPen);
			   RectFill(win->RPort, win->BorderLeft, win->BorderTop,
				    win->Width - win->BorderRight,
				    win->Height - win->BorderBottom);
			   SetAPen(win->RPort, old_pen);
			   RefreshGadgets(win->FirstGadget, win, NULL);
			   doit(win, &counter1, GetPropValue(prop));
			   doit2(win, &counter2, GetPropValue(prop2));
			   break;

	  case CLOSEWINDOW : ReplyMsg((struct Message *)msg);
			     KillGadget(win, prop);
			     KillGadget(win, prop2);
			     KillGadget(win, button1);
			     KillGadget(win, button2);
			     KillGadget(win, button3);
			     KillGadget(win, button4);
			     KillGadget(win, numgadg);
			     KillWindow(win);
			     exit(0);
			     break;

	  default : break;
	}  /* end of switch */
       ReplyMsg((struct Message *)msg);
     } /* end of inner while */

  } /* end of outer while */

} /* end of main() */



/* These two functions will be called from within RealtimeProp() each time
 * the value of the prop gadget changes.
 *
 * The arguments to a function called from RealtimeProp() are always :
 *    win     - the window of the gadget
 *    counter - a pointer to data passed in the call to RealtimeProp(); this can be a pointer to anything really
 *    val     - the new value (already normalized) of the prop gadget
 */
void doit(win, counter, val)
  struct Window *win;
  int *counter;
  int val;
{
  char buff[64];

  Move(win->RPort, prop->LeftEdge, prop->TopEdge + prop->Height + win->RPort->TxBaseline + 5);
  sprintf(buff, "%d ", val);
  Print(win->RPort, buff);
  *counter += 1;
}

void doit2(win, counter, val)
  struct Window *win;
  int *counter;
  int val;
{
  char buff[64];

  Move(win->RPort,
       win->Width - win->BorderRight - 22*win->RPort->TxWidth,
       win->BorderTop + win->RPort->TxHeight + win->RPort->TxBaseline);
  sprintf(buff, "#2 (%d) Value == %d ", *counter, val);
  Print(win->RPort, buff);
  *counter += 1;
}

