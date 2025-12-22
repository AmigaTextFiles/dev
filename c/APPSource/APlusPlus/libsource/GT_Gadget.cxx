/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/GT_Gadget.cxx,v $
 **   $Revision: 1.12 $
 **   $Date: 1994/07/27 11:48:37 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C" {
#ifdef __GNUG__
#include <inline/intuition.h>
#include <inline/gadtools.h>
#endif

#ifdef __SASC
#include <proto/intuition.h>
#include <proto/gadtools.h>
#endif
}
#include <string.h>
#include <intuition/intuition.h>
#include <APlusPlus/intuition/GT_Gadget.h>
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/intuition/ScreenC.h>


static const char rcs_id[] = "$Id: GT_Gadget.cxx,v 1.12 1994/07/27 11:48:37 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
intui_typeinfo(GT_Gadget, derived(from(GadgetCV)), rcs_id)


/*************************************************************************************************
      GT_Gadget methods
 *************************************************************************************************/

GT_Gadget::GT_Gadget(GraphicObject *owner,ULONG createKind,AttrList& attrs)
      : GadgetCV(owner,attrs)
{
   if (Ok())
   {
      kind = createKind;
      getHomeWindow()->modifyIDCMP(intuiAttrs().getTagData(GT_IDCMP,LISTVIEWIDCMP));
      // per default all IDCMP flags needed by any GadTools gadget are set
      setIOType(IOTYPE_GTGADGET);
   }
}


GT_Gadget::~GT_Gadget()
{
   /* The gadget itself is freed by the GWindow. */
}


APTR GT_Gadget::redrawSelf(GWindow *homeWindow,ULONG& returnType)
{
   struct NewGadget createNG;
   GadgetCV::redrawSelf(homeWindow,returnType);

   storeGadget(NULL);    // the old gadgets will be deleted with FreeGadgets() afterwards.

   _dprintf("fill createNG struct..\n");
   // set the NewGadget structure with valid values according to the taglist.
   createNG.ng_LeftEdge    = (WORD)iLeft();
   createNG.ng_TopEdge     = (WORD)iTop();
   createNG.ng_Width       = (WORD)iWidth();
   createNG.ng_Height      = (WORD)iHeight();
   createNG.ng_GadgetText  = (UBYTE*)intuiAttrs().getTagData(GA_Text,NULL);
   createNG.ng_TextAttr    = (struct TextAttr*)intuiAttrs().getTagData(GT_TextAttr,
                              (ULONG)(const struct TextAttr*)homeWindow->getScreenFont());
   createNG.ng_GadgetID    = (UWORD)intuiAttrs().getTagData(GA_ID,4711);
   createNG.ng_Flags       = intuiAttrs().getTagData(GT_Flags,0);
   createNG.ng_VisualInfo  = getHomeWindow()->screenC()->getVisualInfo();
   createNG.ng_UserData    = (APTR)this;   // store reference to the GT_Gadget object in the gadget.

   if (storeGadget(CreateGadgetA(kind,getGT_Context(),&createNG,intuiAttrs())))
   {
      setIOType(IOTYPE_GTGADGET);
      returnType = IOTYPE_GTGADGET;
   }
   else
   {
      returnType = NULL;
      _ierror(GT_GADGET_CREATE_FAILED);
      setIOType(IOTYPE_GTGADGET);
      // immediately set object to valid state to have GWindow call redrawSelf next time the window changes
   }
   _dprintf("\tdone.\n");

   return gadgetPtr();
}

ULONG GT_Gadget::setAttributes(AttrList& attrs)
{
   if (notificationLoop()) return 0L;

   if (gadgetPtr())  // gadget available ?
   {
      GT_SetGadgetAttrsA(gadgetPtr(),(Window*)getHomeWindow()->windowPtr(),NULL,attrs);
   }
   return GadgetCV::setAttributes(attrs);
}

ULONG GT_Gadget::getAttribute(Tag tag,ULONG& dataStore)
{
   return GadgetCV::getAttribute(tag,dataStore);
}

void GT_Gadget::callback(const IntuiMessageC *imsg)
{
   /* GadTools gadgets need specialized callback methods.
      These are defined in the specialized GT_??? class methods. */
}
