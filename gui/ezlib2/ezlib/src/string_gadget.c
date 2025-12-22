/* This file contains routines that create and manipulate string gadgets.
 * The string gadgets created by these routines have that sunk in look
 * to them.
 *
 *   Dominic Giampaolo © 1991
 */
#include "inc.h"    /* make sure to get the amiga includes */

#include "ezlib.h"



/* forwards to EzLib private functions */
void killstringgadget(struct Window *win, struct Gadget *gadget);

extern struct GfxBase *GfxBase;
extern BYTE EzLightPen, EzDarkPen;


#define SINFO StringInfo
#define NUMPOINTS 12

/* This function creates a specified string gadget.  The gadget is fully
 * created, and all necessary memory (such as for the string buffer) is
 * allocated.
 *
 *   Arguments :
 *	  l_edge, t_edge : left and top edge of where the gadget starts
 *	  flags : corresponds to the Flags variable of a struct Gadget
 *	  activation : corresponds to the Activation var of a struct Gadget
 *	  len : the length in pixels of the gadget entry field
 *	  def_string : a default string to put in the string gadget
 *	  id : the GadgetID this gadget will have
 *
 * Returns NULL on failure.
 */

struct Gadget *CreateStringGadget(SHORT l_edge, SHORT t_edge, USHORT len,
				  USHORT flags, USHORT activation,
				  char *def_string, USHORT id)
{
 struct Gadget	  *gadg   = NULL;
 struct Border	  *bord1  = NULL, *bord2 = NULL;
 struct StringInfo *sinfo = NULL;
 char  *buff;
 int i,j;

 if ( (flags & GADGHIMAGE) != NULL)
   return NULL;

 if ( (flags & GADGHBOX) == NULL && (flags & GADGHCOMP) == NULL)
    flags |= GADGHCOMP;

 if (GfxBase == NULL)
   if (OpenLibs(GFX) == NULL)
     return NULL;

 /* get everything allocated first, and fail if any of this does */
 if (get_gadgmem(&gadg, &bord1, &bord2) == NULL)
   return NULL;

 sinfo	 = (struct SINFO *) AllocMem(sizeof(struct SINFO),     MEMF_CLEAR);
 buff	 = (char *)         AllocMem(255,                      MEMF_CLEAR);
 if (sinfo == NULL || buff == NULL)
  {
    killstringgadget(NULL, gadg);

    if (sinfo)
      FreeMem(sinfo, sizeof(struct SINFO));
    if (buff)
      FreeMem(buff, 255);

    return NULL;
  }

 if (def_string != NULL)
   strncpy(buff, def_string, strlen(def_string));

 /* do some generic setup stuff */
 gadg->LeftEdge   = l_edge;	    gadg->TopEdge      = t_edge;
 gadg->Flags	  = flags;	    gadg->Activation   = activation;
 gadg->GadgetID   = id; 	    gadg->GadgetType   = STRGADGET;
 gadg->SpecialInfo= (void *)sinfo;  gadg->GadgetRender = (APTR)bord1;

 /* the only real thing we have to set up for the string gadget */
 sinfo->Buffer = (UBYTE *)buff;     sinfo->MaxChars    = 255;

 /* calculate where the box should be and fill in the border struct */
 bord1->LeftEdge    = -4;	    bord1->TopEdge     = -2;
 bord1->FrontPen    = EzDarkPen;    bord1->BackPen     = EzLightPen;
 bord1->DrawMode    = JAM1;	    bord1->Count       = 6;
 bord1->NextBorder  = bord2;

 /* calculate where the box should be and fill in the border struct */
 bord2->LeftEdge    = -4;	    bord2->TopEdge     = -2;
 bord2->FrontPen    = EzLightPen;   bord2->BackPen     = EzDarkPen;
 bord2->DrawMode    = JAM1;	    bord2->Count       = 6;

 /* here we calculate where everything should go... */
 i = len;
 if (i < 30)
   i = 30;
 j = GfxBase->DefaultFont->tf_YSize + 4;

 setupborders(bord1, bord2, i, j);

 gadg->Width = i-6;		      gadg->Height = j+1;

 return gadg;
}


/* This routine makes and adds a string gadget to your window.
 *
 *  Arguments :
 *    win : a pointer to the window you would like this gadget in.
 *    l_edge, t_edge : the top left edge of where the gadget starts
 *    len : the length of the text entry area in pixels
 *    def_string : a null terminated character string of the text to go
 *		   as the default string the gadget
 *    id : an numeric GadgetID so you can identify the gadget later on.
 *
 *  Returns NULL on failure.
 */
struct Gadget *MakeStringGadget(struct Window *window, SHORT l_edge,
				SHORT t_edge, USHORT len, char *def_string,
				USHORT id)
{
 USHORT flags, activation;
 struct Gadget *gadg;

 flags	    = GADGHCOMP;
 activation = RELVERIFY;

 if (window == NULL)
   return NULL;

 gadg = CreateStringGadget(l_edge, t_edge, len, flags, activation, def_string, id);
 if (gadg == NULL)
   return NULL;

 AddGadget(window, gadg, 0);
 RefreshGList(gadg, window, NULL, 1);

 return gadg;
}


/* This routine makes and adds an integer string gadget to your window.
 *
 *  Arguments :
 *    win : a pointer to the window you would like this gadget in.
 *    l_edge, t_edge : the top left edge of where the gadget starts
 *    len : the length of the text entry area in pixels
 *    def_string : a null terminated character string of the text to go
 *		   as the default string the gadget
 *    id : an numeric GadgetID so you can identify the gadget later on.
 *
 *  Returns NULL on failure.
 */
struct Gadget *MakeIntGadget(struct Window *window, SHORT l_edge,
				SHORT t_edge, USHORT len, char *def_string,
				USHORT id)
{
 USHORT flags, activation;
 struct Gadget *gadg;

 flags	    = GADGHCOMP;
 activation = RELVERIFY | LONGINT;

 if (window == NULL)
   return NULL;

 gadg = CreateStringGadget(l_edge, t_edge, len, flags, activation, def_string, id);
 if (gadg == NULL)
   return NULL;

 AddGadget(window, gadg, 0);
 RefreshGList(gadg, window, NULL, 1);

 return gadg;
}


/* This is the generic interface to removing/freeing gadgets.  It accepts
 * a pointer to any type of gadget and based on its type calls the
 * appropriate function.
 *
 *   Arguments :
 *	 win : a pointer to the window to remove this gadget from, can
 *	       be NULL (if so, don't remove it from a window!)
 *	 gadget : a pointer to the gadget you want removed.
 *
 */
void KillGadget(struct Window *win, struct Gadget *gadget)
{
  if (gadget == NULL)
    return;

  switch(gadget->GadgetType)
   {
     case STRGADGET : killstringgadget(win, gadget);
		      break;

     case BOOLGADGET : killboolgadget(win, gadget);
		       break;

     case PROPGADGET : killpropgadget(win, gadget);
		       break;

     default : break;
   } /* end of switch(gadget->GadgetType) */
}


/* This routine is an EzLib private routine that frees up string gadgets.
 */
void killstringgadget(struct Window *win, struct Gadget *gadg)
{
 struct SINFO *stemp;

 if (gadg == NULL)
   return;

 if (win)
  {
    RemoveGadget(win, gadg);
    RefreshGadgets( win->FirstGadget, win, NULL);
  }

 killgadgborder(gadg);

 stemp = ((struct StringInfo *)gadg->SpecialInfo);
 if (stemp && stemp->Buffer)
   FreeMem(((struct StringInfo *)gadg->SpecialInfo)->Buffer, 255);
 if (stemp)
   FreeMem(gadg->SpecialInfo, sizeof(struct StringInfo));

 FreeMem(gadg, sizeof(struct Gadget) + 2*sizeof(struct Border));
}

