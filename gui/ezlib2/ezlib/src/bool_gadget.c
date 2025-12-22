/* This file contains routines for dealing with standard text based
 * boolean gadgets.  The gadgets created by these routines are 3D raised
 * button affairs.
 *
 *  Dominic Giampaolo © 1991
 */
#include "inc.h"    /* make sure to get the amiga includes */

#include "ezlib.h"



/* forwards to EzLib private functions */
void setupborders(struct Border *bord1, struct Border *bord2, int i, int j);
void killboolgadget(struct Window *win, struct Gadget *gadg);
void killgadgborder(struct Gadget *gadg);


extern struct GfxBase *GfxBase;
extern struct IntuitionBase *IntuitionBase;

/* The following two variables contain the pen to use for giving gadgets
 * that cool raised three-d look.
 *
 * We set them inside of OpenLibs() with a call to PickHighlightColors().
 * Checking the colors is a matter of making sure that the colors
 * for the light pen and dark pen are actually light and dark
 * instead of reversed (which can happen between 1.3 and 2.0).
 *
 * The reason we do it inside of OpenLibs() is that before any Graphics
 * or Intuition function can be called, we have to call OpenLibs first.
 * If the user doesn't call OpenLibs(), there are reasonable defaults
 * placed here.
 */
extern BYTE EzLightPen;
extern BYTE EzDarkPen;

#define NUMPOINTS 12

/* This functions creates a boolean gadget.
 *
 *   Arguments :
 *	  l_edge, t_edge : left and top edge of where the gadget starts
 *	  flags : corresponds to the Flags variable of a struct Gadget
 *	  activation : corresponds to the Activation var of a struct Gadget
 *	  text : a null terminated char string that is the gadget text
 *	  id : the GadgetID this gadget will have
 *
 *  Returns NULL on failure.
 */

struct Gadget *CreateBoolGadget(SHORT l_edge, SHORT t_edge, USHORT flags,
				 USHORT activation, char *text, USHORT id)
{
 struct Gadget	  *gadg   = NULL;
 struct TextFont  *tf;
 struct IntuiText *i_text = NULL;
 struct Border	  *bord1 = NULL, *bord2 = NULL;
 int	i,j;

 if ( (flags & GADGHIMAGE) != NULL)
   return NULL;

 if ( (flags & GADGHBOX) == NULL && (flags & GADGHCOMP) == NULL)
    flags |= GADGHCOMP;

 if (GfxBase == NULL || IntuitionBase == NULL)
   if (OpenLibs(GFX|INTUI) == NULL)
     return NULL;

 /* get everything allocated first, and fail if any of this does */
 if (get_gadgmem(&gadg, &bord1, &bord2) == NULL)
   return NULL;

 i_text  = (struct IntuiText*) AllocMem(sizeof(struct IntuiText), MEMF_CLEAR);
 if (i_text == NULL)
   killboolgadget(NULL, gadg);

 /* do some generic setup stuff */
 gadg->LeftEdge   = l_edge-2;	    gadg->TopEdge      = t_edge-1;
 gadg->Flags	  = flags;	    gadg->Activation   = activation;
 gadg->GadgetID   = id; 	    gadg->GadgetType   = BOOLGADGET;
 gadg->GadgetText = i_text;	    gadg->GadgetRender = (APTR)bord1;

 /* fill in the Itext struct */
 i_text->FrontPen   =  3;	       i_text->DrawMode   =  JAM1;
 i_text->LeftEdge   =  12;	       i_text->TopEdge	  =  3;
 i_text->IText	    =  (UBYTE *)text;

 /* calculate where the box should be and fill in the border struct */
 bord1->LeftEdge    = 0;	     bord1->TopEdge	= 0;
 bord1->FrontPen    = EzLightPen;    bord1->BackPen	= EzDarkPen; /* 0 */
 bord1->DrawMode    = JAM1;	     bord1->Count	= 6;
 bord1->NextBorder  = bord2;

 /* calculate where the box should be and fill in the border struct */
 bord2->LeftEdge    = 0;	     bord2->TopEdge	= 0;
 bord2->FrontPen    = EzDarkPen;     bord2->BackPen	= EzLightPen; /* 0 */
 bord2->DrawMode    = JAM1;	     bord2->Count	= 6;

 /* here we calculate where everything should go... */
 i = IntuiTextLength(i_text) + 22;
 if (i < 30)
   i = 30;
 tf = GfxBase->DefaultFont;
 j = tf->tf_YSize + (tf->tf_YSize - tf->tf_Baseline) + 3;

 setupborders(bord1, bord2, i, j);

 gadg->Width = i+1;		      gadg->Height = j+1;
 return gadg;
}


/* This is the function that creates those nifty 3D borders.
 * It is a private ezlib function.
 *
 * Also notice how the size of the border structure is essentially
 * hard-coded -- a definite code dependancy if I've ever seen one :-)
 */
void setupborders(struct Border *bord1, struct Border *bord2, int i, int j)
{
 bord1->XY[0]  = i;		      bord1->XY[1]   = 0;
 bord1->XY[2]  = 0;		      bord1->XY[3]   = 0;
 bord1->XY[4]  = 0;		      bord1->XY[5]   = j;
 bord1->XY[6]  = 1;		      bord1->XY[7]   = j-1;
 bord1->XY[8]  = 1;		      bord1->XY[9]   = 0;
 bord1->XY[10] = i;		      bord1->XY[11]  = 0;

 bord2->XY[0]  = 1;		      bord2->XY[1]   = j;
 bord2->XY[2]  = i;		      bord2->XY[3]   = j;
 bord2->XY[4]  = i;		      bord2->XY[5]   = 0;
 bord2->XY[6]  = i-1;		      bord2->XY[7]   = 1;
 bord2->XY[8]  = i-1;		      bord2->XY[9]   = j;
 bord2->XY[10] = 1;		      bord2->XY[11]  = j;
}


/* this is just a convience function for above.  It allocates all the needed
 * memory with one function call and stuffs the appropriate values into the
 * pointer pointers.  Returns NULL on failure.
 */
get_gadgmem(struct Gadget **gadg, struct Border **bord1, struct Border **bord2)
{
 char *tmp = NULL, *tmp2 = NULL;
 int size1, size2;

 size1 = sizeof(struct Gadget) + sizeof(struct Border) + sizeof(struct Border);
 tmp = (char *)AllocMem(size1, MEMF_CLEAR);
 if (tmp == NULL)
   return NULL;

 *gadg	= (struct Gadget *)tmp;
 *bord1 = (struct Border *)(tmp + sizeof(struct Gadget));
 *bord2 = (struct Border *)(tmp + sizeof(struct Gadget) + sizeof(struct Border));

 size2 = 2 * (NUMPOINTS * sizeof(SHORT));
 tmp2 = (char *)AllocMem(size2, 0L);
 if (tmp2 == NULL)
   { FreeMem(tmp, size1); return NULL; }

 (*bord1)->XY = (SHORT *)tmp2;
 (*bord2)->XY = (SHORT *)(tmp2 + (NUMPOINTS * sizeof(SHORT)) );

 return TRUE;
}



/* This removes our phony 3-D gadgets. It is an EzLib private function.
 */
void killgadgborder(struct Gadget *gadg)
{
 struct Border *bord;

 /* get rid of both border structures */
 bord = (struct Border *)gadg->GadgetRender;
 FreeMem(bord->XY, 2 * (NUMPOINTS * sizeof(SHORT)) );
}


/* This routine frees up boolean gadgets.  It is an EzLib private function.
 *
 * It is smart enough to handle both regular (text) boolean gadgets,
 * and Image based gadgets (hence the test for GADGIMAGE).
 */
void killboolgadget(struct Window *win, struct Gadget *gadg)
{
 if (gadg == NULL)
   return;

 if (win)
  {
    RemoveGadget(win, gadg);
    RefreshGadgets( win->FirstGadget, win, NULL);
  }

 if ((gadg->Flags & GADGIMAGE) == NULL)
  {
   killgadgborder(gadg);

   if (gadg->GadgetText)
    FreeMem(gadg->GadgetText, sizeof(struct IntuiText));

   FreeMem(gadg, sizeof(struct Gadget) + sizeof(struct Border) + sizeof(struct Border));
  }
 else
   FreeMem(gadg, sizeof(struct Gadget));
}


/* This function makes a Boolean gadget, adds it to your window, and
 * causes it to display.
 *
 *  Arguments :
 *    win : a pointer to the window you would like this gadget in.
 *    l_edge, t_edge : the top left edge of where the gadget starts
 *    text : a null terminated character string of the text to go in
 *	     the gadget
 *    id : an numeric GadgetID so you can identify the gadget later on.
 *
 * Returns NULL on failure.
 */
struct Gadget *MakeBoolGadget(struct Window *window, SHORT l_edge,
			      SHORT t_edge, char *text, USHORT id)
{
 USHORT flags, activation;
 struct Gadget *gadg;

 flags	    = GADGHCOMP;
 activation = RELVERIFY;

 if (window == NULL)
   return NULL;

 gadg = CreateBoolGadget(l_edge, t_edge, flags, activation, text, id);
 if (gadg == NULL)
   return NULL;

 AddGadget(window, gadg, 0);
 RefreshGList(gadg, window, NULL, 1);

 return gadg;
}


/* This function is the same as above, but creates a toggle gadget instead
 * of a boolean gadget.
 *
 *  Arguments :
 *    win : a pointer to the window you would like this gadget in.
 *    l_edge, t_edge : the top left edge of where the gadget starts
 *    text : a null terminated character string of the text to go in
 *	     the gadget
 *    id : an numeric GadgetID so you can identify the gadget later on.
 *
 * Returns NULL on failure.
 */
struct Gadget *MakeToggleGadget(struct Window *window, SHORT l_edge,
				SHORT t_edge, char *text, USHORT id)
{
 USHORT flags, activation;
 struct Gadget *gadg;

 flags	    = GADGHCOMP;
 activation = RELVERIFY | TOGGLESELECT | GADGIMMEDIATE;

 if (window == NULL)
   return NULL;

 gadg = CreateBoolGadget(l_edge, t_edge, flags, activation, text, id);
 if (gadg == NULL)
   return NULL;

 AddGadget(window, gadg, 0);
 RefreshGList(gadg, window, NULL, 1);

 return gadg;
}

