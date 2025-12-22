/* This file contains functions for manipulating boolean gadgets that use
 * custom Image structures as imagery.
 *
 *  Dominic Giampaolo © 1991
 */
#include "inc.h"      /* make sure to get the amiga includes */

#include "ezlib.h"



/* This function creates a boolean gadget which uses img and hi_img as
 * imagery.
 *
 *  Arguments :
 *     l_edge, t_edge - where the gadget's top left edge will be
 *     flags - corresponds to the Flags field of a struct Gadget
 *     activation - correpsonds to the Activation field of a struct Gadget
 *     img, hi_img - the struct Image's that will be used for the object.
 *		     The data they point to must be in CHIP memory.  If
 *		     hi_img isn't NULL, it will be the highlight image.
 *		     Otherwise complementing is used.
 *     id - an GadgetID for the gadget
 *
 * Returns NULL on failure.
 */
struct Gadget *CreateImgGadget(SHORT l_edge, SHORT t_edge, USHORT flags,
			       USHORT activation, struct Image *img,
			       struct Image *hi_img, USHORT id)
{
 struct Gadget *gadg = NULL;

 if (img == NULL)
   return NULL;

 if ((flags & GADGIMAGE) == NULL)
   flags |= GADGIMAGE;

 if (hi_img && (flags & GADGHIMAGE) == NULL)
   flags |= GADGHIMAGE;
 else
   flags |= GADGHCOMP;

 gadg = (struct Gadget *)AllocMem(sizeof(struct Gadget), MEMF_CLEAR);
 if (gadg == NULL)
   return NULL;

 /* do some generic setup stuff */
 gadg->LeftEdge   = l_edge;	    gadg->TopEdge      = t_edge;
 gadg->Flags	  = flags;	    gadg->Activation   = activation;
 gadg->GadgetID   = id; 	    gadg->GadgetType   = BOOLGADGET;
 gadg->GadgetRender = (APTR)img;

 if (hi_img)
   gadg->SelectRender = (APTR)hi_img;

 gadg->Width = img->Width;	    gadg->Height = img->Height;

 return gadg;
}


/* This function creates an Image based boolean gadget and adds it to
 * your window.
 *
 *  Arguments :
 *    win - a pointer to the window to add this gadget to.
 *    l_edge, t_edge - left and top edge of where the gadget begins
 *    img, hi_img - imagery to use for the gadget.  Hi_img if not NULL will
 *		    be the highlight image. Otherwise complementing is used.
 *    id - the GadgetID for this gadget.
 *
 * Returns NULL on failure
 */
struct Gadget *MakeImgGadget(struct Window *win, SHORT l_edge, SHORT t_edge,
			     struct Image *img, struct Image *hi_img, USHORT id)
{
 USHORT flags, activation;
 struct Gadget *gadg;

 flags	    = GADGIMAGE;
 activation = RELVERIFY;

 if (win == NULL)
   return NULL;

 gadg = CreateImgGadget(l_edge, t_edge, flags, activation, img, hi_img, id);
 if (gadg == NULL)
   return NULL;

 AddGadget(win, gadg, 0);
 RefreshGList(gadg, win, NULL, 1);

 return gadg;
}


/* This function creates an Image based toggle gadget and adds it to
 *  your window.
 *
 *  Arguments :
 *    win - a pointer to the window to add this gadget to.
 *    l_edge, t_edge - left and top edge of where the gadget begins
 *    img, hi_img - imagery to use for the gadget.  Hi_img if not NULL will
 *		    be the highlight image. Otherwise complementing is used.
 *    id - the GadgetID for this gadget.
 *
 * Returns NULL on failure
 */
struct Gadget *MakeImgToggle(struct Window *win, SHORT l_edge, SHORT t_edge,
			     struct Image *img, struct Image *hi_img, USHORT id)
{
 USHORT flags, activation;
 struct Gadget *gadg;

 flags	    = GADGIMAGE;
 activation = RELVERIFY | TOGGLESELECT | GADGIMMEDIATE;

 if (win == NULL || hi_img == NULL)
   return NULL;

 gadg = CreateImgGadget(l_edge, t_edge, flags, activation, img, hi_img, id);
 if (gadg == NULL)
   return NULL;

 AddGadget(win, gadg, 0);
 RefreshGList(gadg, win, NULL, 1);

 return gadg;
}


