/* This file contains functions that create/manipulate Proportional gadgets.
 *
 *  Dominic Giampaolo © 1991
 */
#include "inc.h"    /* make sure to get the amiga includes */

#include "ezlib.h"


extern struct GfxBase *GfxBase;


/* this structure is a user friendly prop gadget.  It contains the
 * normal gadget structures plus 12 extra bytes for application
 * specific prop gadget values.  The extra data at the end of the
 * gadget structure shouldn't harm any one.
 */
struct EzPropGadget
 {
   struct Gadget Gadg;
   int top, displayed, max;
 };


/* This function creates a Prop gadget of your said dimension, and type.
 *
 * Arguments :
 *    l_edge, t_edge, width, heigh : physical dimensions of the gadget
 *    flags : corresponds to the Flags variable of a struct Gadget
 *    activation : corresponds to the Activation field of a struct Gadget
 *    kind : either FREEVERT or FREEHORIZ
 *    id : a numeric id to identify the gadget in your event loop.
 *
 *  Returns NULL on failure.
 */
struct Gadget *CreatePropGadget(SHORT l_edge, SHORT t_edge, SHORT width,
				 SHORT height, USHORT flags,
				 USHORT activation, USHORT kind, USHORT id)
{
 int	size_needed;
 UBYTE *stuff;
 struct EzPropGadget *gadg   = NULL;
 struct PropInfo     *pinfo  = NULL;
 struct Image	     *img    = NULL;

 /* we don't support FREEHORIZ and FREEVERT in same gadget */
 if ( (kind & (FREEHORIZ | FREEVERT)) == (FREEHORIZ | FREEVERT) )
   return NULL;

 kind |= AUTOKNOB;   /* definitely need this */

 if ( (kind & FREEVERT) == NULL && (kind & FREEHORIZ) == NULL)
   kind |= FREEVERT;  /* arbitrary */


 /* get everything allocated first, and fail if any of this does */

 size_needed = sizeof(struct EzPropGadget) + sizeof(struct PropInfo) + sizeof(struct Image);
 stuff = (UBYTE *)AllocMem(size_needed, MEMF_CLEAR);
 if (stuff == NULL)
   return NULL;

 gadg	= (struct EzPropGadget *)stuff;
 pinfo	= (struct PropInfo *)(stuff + sizeof(struct EzPropGadget));
 img	= (struct Image *)(stuff + sizeof(struct EzPropGadget) + sizeof(struct PropInfo));

 /* everything is o.k. to start filling out now */
 gadg->Gadg.NextGadget = NULL;
 gadg->Gadg.LeftEdge   = l_edge;	 gadg->Gadg.TopEdge	 = t_edge;
 gadg->Gadg.Width      = width; 	 gadg->Gadg.Height	 = height;
 gadg->Gadg.Flags      = flags; 	 gadg->Gadg.Activation	 = activation;
 gadg->Gadg.GadgetID   = id;		 gadg->Gadg.GadgetType	 = (USHORT)PROPGADGET;
 gadg->Gadg.GadgetRender = (APTR)img;    gadg->Gadg.SpecialInfo  = (APTR)pinfo;

 pinfo->Flags = kind;

 if (kind & FREEVERT)
   {
     pinfo->HorizPot = MAXPOT;	pinfo->HorizBody = MAXBODY;
     pinfo->VertPot  = 0;	pinfo->VertBody  = 0;
   }
 else
   {
     pinfo->HorizPot = 0;	 pinfo->HorizBody = 0;
     pinfo->VertPot  = MAXPOT;	 pinfo->VertBody  = MAXBODY;
   }

 return (struct Gadget *)gadg;
}


/* This function sets the values a prop gadget represents.  It stores these
 * values in the extra 12 bytes after the Gadget structure.
 *
 * Here are some quick definitions so you don't get confused using this
 * function.
 *    Knob - The rectangle area of a prop gadget that you click on with
 *	     your mouse and move around.
 *
 *    Top - This value represents where the top edge of the Knob is located.
 *	    For example 0 represents the knob at the top of the prop gadget
 *	    container.	Top should always be less than or equal to (Max -
 *	    Displayed).
 *
 *    Displayed - This represents the size of the Knob relative to the total
 *		  value the prop gadget represents.  For instance, a
 *		  displayed value of 5 and a Max value of 15 means that the
 *		  Knob fills 1/3 of the entire prop gadget.
 *
 *     Max - This value represents the range of the entire prop gadget.
 *	     That is, Max is the maximum value a prop gadget can have. If you
 *	     have a max value of 100, you will get numbers in the range
 *	     0 to 99.
 *
 *  Arguments :
 *     win : A pointer to the window that contains the prop gadget.
 *     g : a pointer to the prop gadget itself.
 *     top, displayed, max : as described above.
 *
 */
void SetPropGadg(struct Window *win, struct Gadget *g,
		  int top, int displayed, int max)
{
 int	hidden, t1;
 UWORD	body, pot;
 struct PropInfo      *pinfo;
 struct EzPropGadget  *gadg;

 if (g == NULL || win == NULL)
   return;

 gadg = (struct EzPropGadget *)g;

 if ((gadg->Gadg.GadgetType & PROPGADGET) == NULL)  /* not a prop gadget */
   return;

 pinfo = (struct PropInfo *)gadg->Gadg.SpecialInfo;

 gadg->top	 = top;
 gadg->displayed = displayed;
 gadg->max	 = max;

 if (max == 0)
   max = 1;

 hidden = max - displayed;  /* what about overlap? */
 if (hidden < 0)
   hidden = 0;

 if ((int)top > hidden)
   top = hidden;

 if (hidden > 0)
  {
    t1	 = (int)displayed * (int)MAXBODY;
    body = (UWORD) (t1 / (int)max);

    t1	 = (int)top * (int)MAXPOT;
    pot  = (hidden != 0) ? ((UWORD) (t1 / hidden)) : MAXPOT;
  }
 else
  {
    body = MAXBODY;
    pot  = 0;
  }

 if(pinfo->Flags & FREEVERT)
   {
     NewModifyProp((struct Gadget *)gadg, win, NULL, pinfo->Flags, MAXPOT,
		   pot, MAXBODY, body, 1);
   }
 else
   {
     NewModifyProp((struct Gadget *)gadg, win, NULL, pinfo->Flags, pot,
		   MAXPOT, body, MAXBODY, 1);
   }
} /* end of SetPropGadg() */


/* This function retrieves the current Top value of a prop gadget.  See the
 * above discussion for what this means.
 *
 *  Arguments :
 *     g : a pointer to the prop gadget.
 *
 * Returns 0 if you pass it a NULL pointer or some other type of gadget.
 */
int GetPropValue(struct Gadget *g)
{
  int hidden;
  struct PropInfo      *pinfo;
  struct EzPropGadget  *gadg;

  if (g == NULL)
    return NULL;

  gadg = (struct EzPropGadget *)g;

  if ((gadg->Gadg.GadgetType & PROPGADGET) == NULL)  /* not a prop gadget */
   return NULL;

  pinfo = (struct PropInfo *)gadg->Gadg.SpecialInfo;

  hidden = gadg->max - gadg->displayed;
  if (hidden < 0)
    hidden = 0;

  if (pinfo->Flags & FREEVERT)
    return ((hidden * (int)pinfo->VertPot  + MAXPOT/2) / (int)MAXPOT);
  else
    return ((hidden * (int)pinfo->HorizPot + MAXPOT/2) / (int)MAXPOT);
}


/* This function will create and add to your window a prop gadget.
 *
 *  Arguments :
 *    win : a pointer to the window to add this prop gadget to
 *    l_edge, t_edge, width, height : the gadget dimensions.
 *    kind : either FREEHORIZ or FREEVERT
 *    id : an id for identifying the gadget in your event loop
 *
 * Returns NULL on failure.
 */

struct Gadget *MakePropGadget(struct Window *window, SHORT l_edge,
			      SHORT t_edge, SHORT width, SHORT height,
			      SHORT kind, USHORT id)
{
 USHORT activation;
 struct Gadget *gadg;

 activation = RELVERIFY|GADGIMMEDIATE|FOLLOWMOUSE;

 if (window == NULL)
   return NULL;

 gadg = CreatePropGadget(l_edge, t_edge, width, height, GADGHNONE,
			  activation, kind, id);
 if (gadg == NULL)
   return NULL;

 AddGadget(window, gadg, 0);
 RefreshGList(gadg, window, NULL, 1);

 return gadg;
}


/* This function will create and add to your window a vertical prop
 * gadget.
 *
 *  Arguments :
 *    win : a pointer to the window to add this prop gadget to
 *    l_edge, t_edge, width, height : the gadget dimensions.
 *    flags : the Flags field of a struct Gadget
 *    activation : the Activation field of a struct Gadget
 *    id : an id for identifying the gadget in your event loop
 *
 * Returns NULL on failure.
 */
struct Gadget *MakeVertProp(struct Window *window, SHORT l_edge,
			    SHORT t_edge, SHORT width, SHORT height,
			    USHORT flags, USHORT activation, USHORT id)
{
 struct Gadget *gadg;

 if (window == NULL)
   return NULL;

 flags |= GADGHNONE;
 gadg = CreatePropGadget(l_edge, t_edge, width, height, flags, activation,
			  FREEVERT, id);
 if (gadg == NULL)
   return NULL;

 AddGadget(window, gadg, 0);
 RefreshGList(gadg, window, NULL, 1);

 return gadg;
}


/* This function will create and add to your window a horizontal prop
 * gadget.
 *
 *  Arguments :
 *    win : a pointer to the window to add this prop gadget to
 *    l_edge, t_edge, width, height : the gadget dimensions.
 *    flags : the Flags field of a struct Gadget
 *    activation : the Activation field of a struct Gadget
 *    id : an id for identifying the gadget in your event loop
 *
 * Returns NULL on failure.
 */
struct Gadget *MakeHorizProp(struct Window *window, SHORT l_edge,
			    SHORT t_edge, SHORT width, SHORT height,
			    USHORT flags, USHORT activation, USHORT id)
{
 struct Gadget *gadg;

 if (window == NULL)
   return NULL;

 flags |= GADGHNONE;
 gadg = CreatePropGadget(l_edge, t_edge, width, height, flags, activation,
			  FREEHORIZ, id);
 if (gadg == NULL)
   return NULL;

 AddGadget(window, gadg, 0);
 RefreshGList(gadg, window, NULL, 1);

 return gadg;
}



/* This is an EzLib private routine which kills a prop gadget for you.
 */
void killpropgadget(struct Window *win, struct Gadget *gadg)
{

 if (gadg == NULL)
   return;

 if (win)
  {
    RemoveGadget(win, gadg);
    RefreshGadgets(win->FirstGadget, win, NULL);
  }

 FreeMem(gadg, sizeof(struct EzPropGadget) + sizeof(struct PropInfo) + sizeof(struct Image));
}



/* This function monitors and tracks realtime changes to a prop gadget.
 * It returns TRUE if a realtime scroll took place and FALSE otherwise.
 *
 * Arguments :
 *   win : a pointer to the window all this actions is taking place in
 *   gadg : a pointer to gadget you wish to monitor in realtime.
 *   func : a function to be called when the prop gadget changes
 *   data : a pointer to any data you would like passed to func
 *
 * Func gets called each time the value in the prop gadget changes.
 * Func is called with a pointer to the window, the data ptr, and
 * the new value of the prop gadget.
 *
 * Also of note : This function takes over receiving messages for your
 *		  window.  A problem arises when you request to receive
 *		  DISKINSERTED, NEWPREFS, or INTUITICKS messages.  These
 *		  still come, but this function ignores them until the
 *		  user is done with the prop gadget.  Your program won't
 *		  know that a DISKINSERTED message came if one arrives while
 *		  a user is playing with a prop gadget.
 */
RealtimeProp(struct Window *win, struct Gadget *gadg, void (*func)(), void *data)
{
  struct IntuiMessage *msg;
  struct PropInfo     *pinfo;
  int val, oldval, reportmouse_set = FALSE, mousemove_set = FALSE;

  if (gadg == NULL || win == NULL)
    return NULL;

  if ((gadg->GadgetType & PROPGADGET) == NULL)  /* not a prop gadget */
   return NULL;

  pinfo = (struct PropInfo *)gadg->SpecialInfo;
  if ( (pinfo->Flags & KNOBHIT) == NULL)   /* not a knob hit, so leave */
    return NULL;

  val = GetPropValue(gadg);      /* get current value of prop gadget */


  if (win->IDCMPFlags & MOUSEMOVE)
    mousemove_set = TRUE;
  ModifyIDCMP(win, win->IDCMPFlags | MOUSEMOVE);

  if (win->Flags & REPORTMOUSE)
    reportmouse_set = TRUE;
  win->Flags |= REPORTMOUSE;

  while(1)
   {
     WaitPort(win->UserPort);
     while((msg = (struct IntuiMessage *)GetMsg(win->UserPort)) != NULL)
      {
	switch(msg->Class)
	 {
	   case MOUSEMOVE : oldval = val;
			    val = GetPropValue(gadg);
			    if (val == oldval)           /* no change */
			      break;

			    if (func)             /* call user function */
			      (*func)(win, data, val);
			    break;

	   case GADGETUP :  if (reportmouse_set == FALSE)
			      win->Flags &= ~REPORTMOUSE;
			    if (mousemove_set == FALSE)
			      ModifyIDCMP(win, win->IDCMPFlags & ~MOUSEMOVE);
			    ReplyMsg((struct Message *)msg);
			    return TRUE;
			    break;

	   default : break;
	 } /* end of switch(msg->Class) */

	ReplyMsg((struct Message *)msg);
      } /* end of while(msg...) */
   } /* end of while(1) */
}

